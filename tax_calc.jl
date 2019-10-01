function compute_tax(tax_parameters)
"""
Calculate optimal tax
"""

    space = tax_parameters.space
    c_store = tax_parameters.coefficients
    mparams = tax_parameters.mparams
    opts = tax_parameters.opts
    states = tax_parameters.states
    exog_states = tax_parameters.exog_states
    smax = tax_parameters.smax
    smin = tax_parameters.smin
    loc_next = tax_parameters.loc_next
    dam_next = tax_parameters.dam_next
    controls = tax_parameters.controls

    # Vectors denoting derivatives to take with respect to each state
    if opts[:learn_e]
        k_deriv = [1 0 0 0 0]
        m_deriv = [0 1 0 0 0]
        mu_deriv = [0 0 1 0 0]
        mu_deriv_2 = [0 0 1 0 0]
        sigma_deriv = [0 0 0 1 0]
        l_deriv = [0 0 0 0 1]
        mll_deriv = [0 1 0 0 2]
    else
        k_deriv = [1 0 0]
        m_deriv = [0 1 0]
        l_deriv = [0 0 1]
        mll_deriv = [0 1 2]
    end

    # d cumulative emissions/d emission
    dm_de = 1.

    # Reshaped quadrature weights for expectations over vectors
    mparams[:weights2] = mparams[:weights]*mparams[:weights]'
    mparams[:weights2] = reshape(mparams[:weights2], mparams[:nqnodes]^2)

    # Reshaped quadrature for damage and prior_loc
    dam_next = [reshape(dam_next[i], mparams[:nqnodes]^2) for i = 1:length(dam_next)]
    loc_next = [reshape(loc_next[i], mparams[:nqnodes]^2) for i = 1:length(loc_next)]

    # Expected damage and prior_loc next period
    dam_next_exp = [(mparams[:weights2]'*dam_next[i])[1] for i = 1:length(dam_next)]
    loc_next_exp = [(mparams[:weights2]'*loc_next[i])[1] for i = 1:length(loc_next)]

    # Variance of damage and prior_loc next period, why is it zero for first period?
    dam_var = [(mparams[:weights2]'*dam_next[i].^2 - (mparams[:weights2]'*dam_next[i]).^2)[1] for i = 1:length(dam_next)]
    loc_var = [(mparams[:weights2]'*loc_next[i].^2 - (mparams[:weights2]'*loc_next[i]).^2)[1] for i = 1:length(loc_next)]

    # Covariance between fractional net output and d_2 mean
    dl_covar = [(mparams[:weights2]'*(dam_next[i].*loc_next[i])-
        (dam_next_exp[i].*loc_next_exp[i]))[1] for i = 1:length(loc_next)]

    # States for simulation
    s_base = Array{Array}(undef, size(states, 1) - 1)
    s_base_exp = Array{Array}(undef, size(states, 1) - 1)
    s_base_ce = Array{Array}(undef, size(states, 1) - 1)

    # Compute next period's states, expected states, and certainty states
    if opts[:learn_e]
        for t = 2:size(states, 1)
            s_base[t - 1] = [states[t,[1, 2]]'.*ones(mparams[:nqnodes]^2, 2) loc_next[t - 1] states[t, 4].*ones(mparams[:nqnodes]^2, 1) dam_next[t - 1]]
            s_base_exp[t - 1] = [states[t,[1, 2]]' loc_next_exp[t - 1] states[t, 4] dam_next_exp[t - 1]]
            s_base_ce[t - 1] = [states[t,[1, 2]]' states[t, 3] 0 1 ./ (1+mparams[:coeff_mean].*(mparams[:ccr]*states[t, 2]).^states[t, 3])]
        end
    else
        for t = 2:size(states, 1)
            s_base[t - 1] = [states[t,[1, 2]]'.*ones(mparams[:nqnodes]^2, 2)  dam_next[t - 1]]
            s_base_exp[t - 1] = [states[t,[1, 2]]' dam_next_exp[t - 1]]
            s_base_ce[t - 1] = [states[t,[1, 2]]' 1 ./ (1+mparams[:coeff_mean].*(mparams[:ccr]*states[t, 2]).^states[t, 3])]
        end
    end

    # Initialize vectors for value partials and channels
    Vstar_beta = Vector{Array}(undef, size(states, 1) - 1)
    dvstar_dk = Vector{Array}(undef, size(states, 1) - 1)
    dvstar_dm = Vector{Array}(undef, size(states, 1) - 1)
    dvstar_dl = Vector{Array}(undef, size(states, 1) - 1)
    dvstar_dm_ce = Vector{Float64}(undef, size(states, 1) - 1)
    dvstar_dl_ce = Vector{Float64}(undef, size(states, 1) - 1)
    dvstar_dm_exp = Vector{Float64}(undef, size(states, 1) - 1)
    dvstar_dl_exp = Vector{Float64}(undef, size(states, 1) - 1)
    dvstar_dl3_exp = Vector{Float64}(undef, size(states, 1) - 1)
    dvstar_dl2_dm_exp = Vector{Float64}(undef, size(states, 1) - 1)
    if opts[:learn_e]
        dvstar_dsigma_ce = Vector{Float64}(undef, size(states, 1) - 1)
        dvstar_dsigma_exp = Vector{Float64}(undef, size(states, 1) - 1)
        dvstar_dsigma = Vector{Array}(undef, size(states, 1) - 1)
        dvstar_dexp = Vector{Array}(undef, size(states, 1) - 1)
        dvstar_dl2_dsigma_exp = Vector{Float64}(undef, size(states, 1) - 1)
        dvstar_dl_dm_dmu_exp = Vector{Float64}(undef, size(states, 1) - 1)
        dvstar_dl_dsigma_dmu_exp = Vector{Float64}(undef, size(states, 1) - 1)
        dvstar_dl2_dmu_exp = Vector{Float64}(undef, size(states, 1) - 1)
        dvstar_dexp2_dm_exp = Vector{Float64}(undef, size(states, 1) - 1)
        dvstar_dexp2_exp = Vector{Float64}(undef, size(states, 1) - 1)
        dvstar_dexp2_dsigma_exp = Vector{Float64}(undef, size(states, 1) - 1)
        dvstar_dexp2_dl_exp = Vector{Float64}(undef, size(states, 1) - 1)
    end

    # Compute values and value partials for channels
    for t = 1:size(states, 1) - 1

        if opts[:adapted]
            space = fundefn(:cheb, mparams[:approximation_level],smin[t + 1, :],smax[t + 1, :])
        end

        # Set year
        space[:year] = t - 1

        # Set value function coefficient vector
        space[:c_cont] = c_store[t + 1]

        # beta_t*V for misspecification insurance
        Vstar_beta[t] = exog_states[:betaeff][t].*reshape(funeval(c_store[t + 1], space, s_base[t])[1], mparams[:nqnodes], mparams[:nqnodes])

        # dv/dcapital
        dvstar_dk[t] = funeval(c_store[t + 1], space, s_base[t], k_deriv)[1]
        # dv/dcumulative emissions
        dvstar_dm[t] = funeval(c_store[t + 1], space, s_base[t],  m_deriv)[1]
        # dv/dfractional net output
        dvstar_dl[t] = funeval(c_store[t + 1], space, s_base[t], l_deriv)[1]

        if opts[:learn_e]
            # dv/dmean
            dvstar_dexp[t] = funeval(c_store[t + 1], space, s_base[t],  mu_deriv)[1]
            # dv/dvariance
            dvstar_dsigma[t] = funeval(c_store[t + 1], space, s_base[t], sigma_deriv)[1]
        end


        ## Decomposition components

        # Cumulative emissions
        # Certainty-equivalent
        dvstar_dm_ce[t] = funeval(c_store[t + 1], space, s_base_ce[t], m_deriv)[1][1]
        # At expected state
        dvstar_dm_exp[t] = funeval(c_store[t + 1], space, s_base_exp[t], m_deriv)[1][1]
        # Precaution: CO2 interaction
        dvstar_dl2_dm_exp[t] = funeval(c_store[t + 1], space, s_base_exp[t], mll_deriv)[1][1]

        if opts[:learn_e]
            # Signal smoothing
            dvstar_dexp2_dm_exp[t] = funeval(c_store[t + 1], space, s_base_exp[t], [0, 1, 2, 0, 0])[1][1]
            dvstar_dexp2_exp[t] = funeval(c_store[t + 1], space, s_base_exp[t], [0, 0, 2, 0, 0])[1][1]
        end


        if opts[:learn_e]
            # Variance
            # Certainty-equivalent
            dvstar_dsigma_ce[t] = funeval(c_store[t + 1], space, s_base_ce[t], sigma_deriv)[1][1]
            # At expected state
            dvstar_dsigma_exp[t] = funeval(c_store[t + 1], space, s_base_exp[t], sigma_deriv)[1][1]
            # Precaution: scale interaction
            dvstar_dl2_dsigma_exp[t] = funeval(c_store[t + 1], space, s_base_exp[t], [0, 0, 0, 1, 2])[1][1]
            # Signal smoothing
            dvstar_dl_dsigma_dmu_exp[t] = funeval(c_store[t + 1], space, s_base_exp[t], [0, 0, 1, 1, 1])[1][1]
            # Signal smoothing
            dvstar_dexp2_dsigma_exp[t] = funeval(c_store[t + 1], space, s_base_exp[t], [0, 0, 2, 1, 0])[1][1]
        end

        # Fractional net output
        # Certainty-equivalent
        dvstar_dl_ce[t] = funeval(c_store[t + 1], space, s_base_ce[t], l_deriv)[1][1]
        # At Expected-state
        dvstar_dl_exp[t] = funeval(c_store[t + 1], space, s_base_exp[t], l_deriv)[1][1]
        # Precaution
        dvstar_dl3_exp[t] = funeval(c_store[t + 1], space, s_base_exp[t], l_deriv*3)[1][1]

        # Precaution: belief interaction
        if opts[:learn_e]
            dvstar_dl2_dmu_exp[t] = funeval(c_store[t + 1], space, s_base_exp[t], [0, 0, 1, 0, 2])[1][1]
            dvstar_dl_dm_dmu_exp[t] = funeval(c_store[t + 1], space, s_base_exp[t], [0, 1, 1, 0, 1])[1][1]
        end

        # Signal smoothing
        if opts[:learn_e]
            dvstar_dexp2_dl_exp[t] = funeval(c_store[t + 1], space, s_base_exp[t], [0, 0, 2, 0, 1])[1][1]
        end
    end


    # Fractional net output next period quadrature
    dam_next = [reshape(dam_next[i], mparams[:nqnodes], mparams[:nqnodes]) for i = 1:length(dam_next)]

    # dfractional net output/de quadrature
    if opts[:learn_e]
        dl_dm = [-qnwnorm(mparams[:nqnodes], states[i, 3], states[i, 4])[1]./
            s_base[i][1, 2].*(dam_next[i] - dam_next[i].^2) for i = 1:length(s_base)]
    else
        dl_dm = [-qnwnorm(mparams[:nqnodes], mparams[:exp_mean], mparams[:exp_var])[1]./
            s_base[i][1, 2].*(dam_next[i] - dam_next[i].^2) for i = 1:length(s_base)]
    end

    if opts[:learn_e]
        # dfractional net output/de exp
        dl_dm_exp = [(-mparams[:weights]'*(qnwnorm(mparams[:nqnodes], states[i, 3], states[i, 4])[1]./
            s_base[i][1, 2].*(dam_next[i] - dam_next[i].^2))*mparams[:weights])[1] for i = 1:length(s_base)]

        # dfractional net output/de ce
        dl_dm_ce =
            -[s_base_ce[i][3]/s_base_ce[i][2]*(s_base_ce[i][5] - s_base_ce[i][5]^2) for i = 1:length(s_base)]
    else
        # dfractional net output/de exp
        dl_dm_exp = [(-mparams[:weights]'*(qnwnorm(mparams[:nqnodes], mparams[:exp_mean], mparams[:exp_var])[1]./
            s_base[i][1, 2].*(dam_next[i] - dam_next[i].^2))*mparams[:weights])[1] for i = 1:length(s_base)]

        # dfractional net output/de ce
        dl_dm_ce =
            -[mparams[:exp_mean]./s_base_ce[i][2]*(s_base_ce[i][3] - s_base_ce[i][3]^2) for i = 1:length(s_base)]

    end

    # dfractional net output/de
    dl_dm = [reshape(dl_dm[i], mparams[:nqnodes]^2) for i = 1:length(dl_dm)]

    dam_next = [reshape(dam_next[i], mparams[:nqnodes]^2) for i = 1:length(dam_next)]

    # dvariance/de
    if opts[:learn_e]
        dsigma_de =
            [-2.0.*log.(mparams[:ccr]*s_base[i][1, 2])*states[i, 4]*(states[i, 4]*mparams[:coeff_scale])./
            s_base[i][1, 2]./(mparams[:coeff_scale] .+ states[i, 4]*log.(mparams[:ccr]*s_base[i][1, 2])^2).^2 for i = 1:length(s_base_ce)]
    end


    if opts[:learn_e]
        # dmean/de
        dmu_dm =
            [(((states[i, 4]*(1 ./ s_base[i][1, 2])*(log.(1 ./ dam_next[i] .- 1) .- mparams[:coeff_loc]) .+
            states[i, 4]*log.(mparams[:ccr]*s_base[i][1, 2])*(1 ./ (1 ./ dam_next[i] .- 1)).*( -1 ./ (dam_next[i].^2)).*dl_dm[i]).*
            (mparams[:coeff_scale] .+ states[i, 4]*log.(mparams[:ccr]*s_base[i][1, 2]).^2)) -
            (2*states[i, 4]*log.(mparams[:ccr]*s_base[i][1, 2])./s_base[i][1, 2]*
            (mparams[:coeff_scale]*states[i, 3] .+
            states[i, 4]*log.(mparams[:ccr]*s_base[i][1, 2])*(log.(1 ./ dam_next[i].- 1) .- mparams[:coeff_loc]))))./
            (mparams[:coeff_scale] .+ states[i, 4]*log.(mparams[:ccr]*s_base[i][1, 2])^2).^2 for i = 1:length(s_base_ce)]

        # dmean/de exp
        dmu_dm_exp =
            [mparams[:weights2]'*(((states[i, 4]*(1 ./ s_base[i][1, 2])*(log.(1 ./ dam_next[i] .- 1) .- mparams[:coeff_loc]) .+
            states[i, 4]*log.(mparams[:ccr]*s_base[i][1, 2])*(1 ./ (1 ./ dam_next[i] .- 1)).*( -1 ./ (dam_next[i].^2)).*dl_dm[i]).*
            (mparams[:coeff_scale] .+ states[i, 4]*log.(mparams[:ccr]*s_base[i][1, 2]).^2)) -
            (2*states[i, 4]*log.(mparams[:ccr]*s_base[i][1, 2])./s_base[i][1, 2]*
            (mparams[:coeff_scale]*states[i, 3] .+
            states[i, 4]*log.(mparams[:ccr]*s_base[i][1, 2])*(log.(1 ./ dam_next[i] .- 1) .- mparams[:coeff_loc]))))./
            (mparams[:coeff_scale] .+ states[i, 4]*log.(mparams[:ccr]*s_base[i][1, 2])^2).^2 for i = 1:length(s_base_ce)]

        # dmu/de
        dmu_dm = [reshape(dmu_dm[i], mparams[:nqnodes]^2) for i = 1:length(dmu_dm)]
    end

    # Insurance covariance term cov(dv_dl, dl_de)
    insurance_l =
        -[(mparams[:weights2]'*((dvstar_dl[i].-mparams[:weights2]'*dvstar_dl[i])
        .*(dl_dm[i].-dl_dm_exp[i])))[1] for i = 1:length(dvstar_dl)]

    # Insurance covariance term cov(dv_dmu, dmu_de)
    if opts[:learn_e]
        insurance_mu =
            -[(mparams[:weights2]'*((dvstar_dexp[i].-mparams[:weights2]'*dvstar_dexp[i])
            .*(dmu_dm[i].-dmu_dm_exp[i])))[1] for i = 1:length(dvstar_dl)]
    end

    # Define channels dictionary
    channels = Dict{Symbol,Any}()

    # Marginal utility function
    MU(x,t) = x.^(mparams[:rho] - 1)/mparams[:scaling_factor]

    # NOTE FOR ALL CHANNELS BELOW:
    # 3/11 translates tons of carbon to tons of CO2
    # 1000 translates billions to millions between capital and labor
    # At.*Lt adjusts effective terms into real terms
    if opts[:learn_e]
        channels[:ce_tax] =
            [-(1000*3/11*(dvstar_dm_ce[i]
            .+ dvstar_dsigma_ce[i]*dsigma_de[i]
            .+ dvstar_dl_ce[i]*dl_dm_ce[i])
            .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
            exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

        channels[:exp_tax] =
            [-(1000*3/11*(dvstar_dm_exp[i]
            .+ dvstar_dsigma_exp[i]*dsigma_de[i] .+
            dvstar_dl_exp[i]*dl_dm_exp[i])
            .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
            exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

        channels[:unc_adjust] =
            [-(1000*3/11*((dvstar_dm_exp[i] - dvstar_dm_ce[i])*dm_de
            .+ (dvstar_dsigma_exp[i] - dvstar_dsigma_ce[i])*dsigma_de[i]
            .+ (dvstar_dl_exp[i]*dl_dm_exp[i]- dvstar_dl_ce[i]*dl_dm_ce[i]))
            .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
            exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

        channels[:output_insurance] =
            [(1000*3/11*(insurance_l[i])
            .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
            exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

        channels[:learning_insurance] =
            [(1000*3/11*(insurance_mu[i])
            .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
            exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

        channels[:precaution] =
            [-(1000*3/11*(1/2*(dvstar_dl3_exp[i]*dl_dm_exp[i] .+ dvstar_dl2_dm_exp[i] .+ dvstar_dl2_dsigma_exp*dsigma_de[i])*dam_var[i]
            .+ (dvstar_dl2_dmu_exp[i]*dl_dm_exp[i] .+ dvstar_dl_dm_dmu_exp[i] .+ dvstar_dl_dsigma_dmu_exp*dsigma_de[i])*dl_covar[i])
            .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

        channels[:smoothing] =
            [-(1000*3/11*(1/2*(dvstar_dexp2_dl_exp[i]*dl_dm_exp[i] .+ dvstar_dexp2_dm_exp[i] .+ dvstar_dexp2_dsigma_exp[i]*dsigma_de[i])*loc_var[i])
            .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

    else

        channels[:ce_tax] =
            [-(1000*3/11*(dvstar_dm_ce[i]
            .+ dvstar_dl_ce[i]*dl_dm_ce[i])
            .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
            exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

        channels[:exp_tax] =
            [-(1000*3/11*(dvstar_dm_exp[i]
            .+ dvstar_dl_exp[i]*dl_dm_exp[i])
            .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
            exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

        channels[:unc_adjust] =
            [-(1000*3/11*((dvstar_dm_exp[i] - dvstar_dm_ce[i])*dm_de
            .+ (dvstar_dl_exp[i]*dl_dm_exp[i]- dvstar_dl_ce[i]*dl_dm_ce[i]))
            .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
            exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

        channels[:output_insurance] =
            [(1000*3/11*(insurance_l[i])
            .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
            exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

        channels[:learning_insurance] = [0. for i = 1:length(dvstar_dk)]

        channels[:precaution] =
            [-(1000*3/11*(1/2*(dvstar_dl3_exp[i]*dl_dm_exp[i] .+ dvstar_dl2_dm_exp[i])*dam_var[i])
            .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
            exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

        channels[:smoothing] = [0. for i = 1:length(dvstar_dk)]

    end

    # Compute misspecification insurance
    if opts[:robust]

        if opts[:learn_e]

            channels[:scc_direct] = [-(1000*3/11*mparams[:weights2]'*
                (dvstar_dm[i]
                .+ dvstar_dexp[i].*dmu_dm[i]
                .+ dvstar_dsigma[i].*dsigma_de[i]
                .+ dvstar_dl[i].*dl_dm[i])
                .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
                exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

            # dV/de with cols being coeff quad, rows being exponent quad
            deriv_cont_value_quad = [(dvstar_dm[i]
                + dvstar_dexp[i].*dmu_dm[i]
                + dvstar_dsigma[i].*dsigma_de[i]
                + dvstar_dl[i].*dl_dm[i]) for i = 1:length(dvstar_dk)]

            deriv_cont_value_quad =
                [reshape(deriv_cont_value_quad[i], mparams[:nqnodes], mparams[:nqnodes]) for i = 1:length(deriv_cont_value_quad)]

            # Taking expectation over model dimension: E_{d_1,omega}[dV/de]
            deriv_cont_value_exp = [(mparams[:weights]'*deriv_cont_value_quad[i]')' for i = 1:length(dvstar_dk)]

            # Shock to transition distribution from RC operator: exp(-beta*V/theta)
            rc_shock_quad = [exp.(-Vstar_beta[i]/mparams[:theta_robust]) for i = 1:length(dvstar_dk)]

            # Expectation over the model dimension: E_{d_1,omega}[exp(-beta*V/theta)]
            rc_shock_quad_exp = [(mparams[:weights]'*rc_shock_quad[i]')' for i = 1:length(dvstar_dk)]

            # E_{d_1,omega}[XY]
            rc_adj_val_shock = [deriv_cont_value_quad[i].*rc_shock_quad[i] for i = 1:length(dvstar_dk)]
            rc_adj_val_shock_exp = [(mparams[:weights]'*rc_adj_val_shock[i]')' for i = 1:length(dvstar_dk)]

            # E_{d_1,omega}[X]E_{d_1,omega}[Y]
            rc_adj_val_exp_shock_exp = [rc_shock_quad_exp[i].*deriv_cont_value_exp[i] for i = 1:length(dvstar_dk)]

            # E_{d_2}[E_{d_1,omega}[XY] - E_{d_1,omega}[X]E_{d_1,omega}[Y]] <=> E_{d_2}[cov_{d_1,omega}(X,Y)]
            rc_adjustment = [mparams[:weights]'*(rc_adj_val_shock_exp[i] - rc_adj_val_exp_shock_exp[i]) for i = 1:length(dvstar_dk)]

            channels[:robust_insurance] = [-(1000*3/11*rc_adjustment
                .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
                exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

        else

            channels[:scc_direct] = [-(1000*3/11*mparams[:weights2]'*
                (dvstar_dm[i]
                .+ dvstar_dl[i].*dl_dm[i])
                .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
                exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

            # dV/de with cols being coeff quad, rows being exponent quad
            deriv_cont_value_quad = [(dvstar_dm[i]
                + dvstar_dl[i].*dl_dm[i]) for i = 1:length(dvstar_dk)]

            deriv_cont_value_quad =
            [reshape(deriv_cont_value_quad[i], mparams[:nqnodes], mparams[:nqnodes]) for i=1:length(deriv_cont_value_quad)]

            # Taking expectation over model dimension: E_{d_1,omega}[dV/de]
            deriv_cont_value_exp = [(mparams[:weights]'*deriv_cont_value_quad[i])' for i = 1:length(dvstar_dk)]

            # Shock to transition distribution from RC operator: exp(-beta*V/theta)
            rc_shock_quad = [exp.(-Vstar_beta[i]/mparams[:theta_robust]) for i = 1:length(dvstar_dk)]

            # Expectation over the model dimension: E_{d_1,omega}[exp(-beta*V/theta)]
            rc_shock_quad_exp = [(mparams[:weights]'*rc_shock_quad[i])' for i = 1:length(dvstar_dk)]

            # E_{d_1,omega}[XY]
            rc_adj_val_shock = [deriv_cont_value_quad[i].*rc_shock_quad[i] for i = 1:length(dvstar_dk)]
            rc_adj_val_shock_exp = [(mparams[:weights]'*rc_adj_val_shock[i])' for i = 1:length(dvstar_dk)]

            # E_{d_1,omega}[X]E_{d_1,omega}[Y]
            rc_adj_val_exp_shock_exp = [rc_shock_quad_exp[i].*deriv_cont_value_exp[i] for i = 1:length(dvstar_dk)]

            # E_{d_2}[E_{d_1,omega}[XY] - E_{d_1,omega}[X]E_{d_1,omega}[Y]] <=> E_{d_2}[cov_{d_1,omega}(X,Y)]
            rc_adjustment = [mparams[:weights]'*(rc_adj_val_shock_exp[i] - rc_adj_val_exp_shock_exp[i]) for i = 1:length(dvstar_dk)]

            channels[:robust_insurance] = [-(1000*3/11*rc_adjustment
                .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
                exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]

        end

        # Add up taylor expansion channels
        channels[:total_taylor] = channels[:ce_tax] .+ channels[:unc_adjust] .+
            channels[:smoothing] .+ channels[:precaution] .+
            channels[:output_insurance]

    else

        channels[:robust_insurance] = zeros(size(channels[:smoothing]))

        if opts[:learn_e]
            channels[:scc_direct] = [-(1000*3/11*mparams[:weights2]'*
                (dvstar_dm[i]
                .+ dvstar_dexp[i].*dmu_dm[i]
                .+ dvstar_dsigma[i].*dsigma_de[i]
                .+ dvstar_dl[i].*dl_dm[i])
                .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
                exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]
        else
            channels[:scc_direct] = [-(1000*3/11*mparams[:weights2]'*
                (dvstar_dm[i]
                .+ dvstar_dl[i].*dl_dm[i])
                .*(exog_states[:betaeff][i]/MU(controls[i][1],i)).*
                exog_states[:At][i].*exog_states[:Lt][i])[1] for i = 1:length(dvstar_dk)]
        end

    end

    channels[:scc_direct] = channels[:scc_direct] + channels[:robust_insurance]


    return channels

end
