function transitions(states_t, controls_t, exog_states, mparams, opts)
"""
Calculate state transition for approximation
"""

    # Set up control variables
    cons = controls_t[1]
    cost = controls_t[2]

    # Abatement rate
    mu = (cost./exog_states[:Psi]).^(1 ./ mparams[:a2])

    # Next period's states
    states_next = zeros(length(states_t))

    # Net output
    if opts[:learn_e]
        exog_states[:net_output] = states_t[1]^(mparams[:kappa])*states_t[5]
    else
        exog_states[:net_output] = states_t[1]^(mparams[:kappa])*states_t[3]
    end

    # Capital
    states_next[1] = (states_t[1]*(1 - mparams[:deltak]) .+ (exog_states[:net_output]*(1 - cost[1]) .- cons[1])) * exog_states[:effkgrowth]

    # Cumulative emissions
    states_next[2] = states_t[2] .+ exog_states[:emint].*(1 - mu[1]).*states_t[1].^mparams[:kappa] .+ exog_states[:Bs]

    if opts[:learn_e]

        # Damage quadrature
        dams, total_weight = qnwlogn(mparams[:nqnodes],
            states_t[3]*log.(mparams[:ccr]*states_next[2]),
            states_t[4]*log.(mparams[:ccr]*states_next[2])^2)

        # Fractional net output, quadrature and actual state
        dam_next = 1 ./ (ones(size(dams,1), size(mparams[:coeff],1)) + dams*mparams[:coeff]')
        states_next[5] = 1 ./ (1 + exp(mparams[:coeff_loc])*(mparams[:ccr]*states_next[2])^mparams[:exp_mean])

        # d_2 mean, quadrature and actual state
        exp_next = ((mparams[:coeff_scale])*states_t[3] .+
            states_t[4].*log.(mparams[:ccr]*states_next[2]).*(log.(1 ./ dam_next .- 1) .- mparams[:coeff_loc]))./
            (mparams[:coeff_scale] .+ states_t[4]*log.(mparams[:ccr]*states_next[2])^2)
        states_next[3] = ((mparams[:coeff_scale])*states_t[3] .+
        states_t[4].*log.(mparams[:ccr]*states_next[2]).*(log.(1 ./ states_next[5] .- 1) .- mparams[:coeff_loc]))./
            (mparams[:coeff_scale] .+ states_t[4]*log.(mparams[:ccr]*states_next[2])^2)

        # d_2 variance
        states_next[4] = states_t[4]*(mparams[:coeff_scale])./
            (mparams[:coeff_scale] .+ states_t[4]*log.(mparams[:ccr]*states_next[2])^2)

    else

        # Damage quadrature
        dams, total_weight = qnwlogn(mparams[:nqnodes],
            mparams[:exp_mean]*log.(mparams[:ccr]*states_next[2]),
            mparams[:exp_var]*log.(mparams[:ccr]*states_next[2])^2)

        # Fractional net output, quadrature and actual state
        dam_next = 1 ./ (ones(size(dams,1), size(mparams[:coeff],1)) + dams*mparams[:coeff]')
        states_next[3] = 1 ./ (1 + exp(mparams[:coeff_loc])*(mparams[:ccr]*states_next[2])^mparams[:exp_mean])

        # Placeholder
        exp_next = mparams[:exp_mean].*ones(size(dam_next))


    end

    return states_next, exp_next, dam_next

end


function transitions(states_t, controls_t, exog_states, mparams, opts, exponent_sim, coeff_sim)
"""
Calculate state transition for simulations
"""

    # Set up control variables
    cons = controls_t[1]
    cost = controls_t[2]

    # Abatement rate
    mu = (cost./exog_states[:Psi]).^(1 ./ mparams[:a2])

    # No shocks if 1 run

    if mparams[:num_runs] == 1 | opts[:perfect_info]
        exponent_sim = mparams[:exp_mean]
        coeff_sim = exp(mparams[:coeff_loc])
    end

    # Next period's states
    states_next = zeros(length(states_t))

    # Net output
    if opts[:learn_e]
        exog_states[:net_output] = states_t[1]^(mparams[:kappa])*states_t[5]
    else
        exog_states[:net_output] = states_t[1]^(mparams[:kappa])*states_t[3]
    end

    # Capital
    states_next[1] = (states_t[1]*(1 - mparams[:deltak]) .+ (exog_states[:net_output]*(1 - cost[1]) .- cons[1])) * exog_states[:effkgrowth]

    # Cumulative emissions
    states_next[2] = states_t[2] .+ exog_states[:emint].*(1 - mu[1]).*states_t[1].^mparams[:kappa] .+ exog_states[:Bs]

    if opts[:learn_e]

        # Base fractional net output or misspecified fractional net output
        if mparams[:damages]  == :base
            if opts[:alt_damages]
                states_next[5] = 1 ./ (1 + coeff_sim*mparams[:d1]*(mparams[:ccr]*states_next[2])^mparams[:d2])
            else
                states_next[5] = 1 ./ (1 + coeff_sim*(mparams[:ccr]*states_next[2])^exponent_sim)
            end

        elseif mparams[:damages]  == :weitzman
            states_next[5] = 1 ./ (1 + coeff_sim*((mparams[:ccr]*states_next[2]/mparams[:weitz_c1])^mparams[:weitz_e1] .+
                (mparams[:ccr]*states_next[2]/mparams[:weitz_c2])^mparams[:weitz_e2]))

        elseif mparams[:damages] == :dietz
            states_next[5] = 1 ./ (1 + coeff_sim*(mparams[:dietz_c1].*(mparams[:ccr]*states_next[2])^mparams[:dietz_e1] .+
                mparams[:dietz_c2].*(mparams[:ccr]*states_next[2])^mparams[:dietz_e2]))

        elseif mparams[:damages] == :extreme
            states_next[5] = 1 ./ (1 + coeff_sim*(mparams[:extreme_c1].*(mparams[:ccr]*states_next[2])^mparams[:extreme_e1] .+
                mparams[:extreme_c2].*(mparams[:ccr]*states_next[2])^mparams[:extreme_e2]))
        end

        # Damage quadrature
        dams, total_weight = qnwlogn(mparams[:nqnodes],
            states_t[3]*log.(mparams[:ccr]*states_next[2]),
            states_t[4]*log.(mparams[:ccr]*states_next[2])^2)

        # Fractional net output quadrature
        dam_next = 1 ./ (ones(size(dams,1), size(mparams[:coeff],1)) + dams*mparams[:coeff]')

        # d_2 mean, quadrature and actual state
        exp_next = ((mparams[:coeff_scale])*states_t[3] .+
            states_t[4].*log.(mparams[:ccr]*states_next[2]).*(log.(1 ./ dam_next .- 1) .- mparams[:coeff_loc]))./
            (mparams[:coeff_scale] .+ states_t[4]*log.(mparams[:ccr]*states_next[2]).^2)
        states_next[3] = ((mparams[:coeff_scale])*states_t[3] .+
            states_t[4].*log.(mparams[:ccr]*states_next[2]).*(log.(1 ./ states_next[5] - 1) .- mparams[:coeff_loc]))./
            (mparams[:coeff_scale] .+ states_t[4]*log.(mparams[:ccr]*states_next[2])^2)

        # d_2 variance
        states_next[4] = states_t[4]*(mparams[:coeff_scale])./
            (mparams[:coeff_scale] .+ states_t[4]*log.(mparams[:ccr]*states_next[2])^2)

    else

        # Base fractional net output or misspecified fractional net output
        if mparams[:damages]  == :base
            if opts[:alt_damages]
                states_next[3] = 1 ./ (1 + mparams[:d1]*(mparams[:ccr]*states_next[2])^mparams[:d2])
            else
                states_next[3] = 1 ./ (1 + coeff_sim*(mparams[:ccr]*states_next[2])^exponent_sim)
            end

        elseif mparams[:damages]  == :weitzman
            states_next[3] = 1 ./ (1 + coeff_sim*((mparams[:ccr]*states_next[2]/mparams[:weitz_c1])^mparams[:weitz_e1] .+
                (mparams[:ccr]*states_next[2]/mparams[:weitz_c2])^mparams[:weitz_e2]))

        elseif mparams[:damages] == :dietz
            states_next[3] = 1 ./ (1 + coeff_sim*(mparams[:dietz_c1].*(mparams[:ccr]*states_next[2])^mparams[:dietz_e1] .+
                mparams[:dietz_c2].*(mparams[:ccr]*states_next[2])^mparams[:dietz_e2]))

        elseif mparams[:damages] == :extreme
            states_next[3] = 1 ./ (1 + coeff_sim*(mparams[:extreme_c1].*(mparams[:ccr]*states_next[2])^mparams[:extreme_e1] .+
                mparams[:extreme_c2].*(mparams[:ccr]*states_next[2])^mparams[:extreme_e2]))
        end

        # Damage quadrature
        dams, total_weight = qnwlogn(mparams[:nqnodes],
            mparams[:exp_mean]*log.(mparams[:ccr]*states_next[2]),
            mparams[:exp_var]*log.(mparams[:ccr]*states_next[2])^2)

        # Fractional net output quadrature
        dam_next = 1 ./ (ones(size(dams,1), size(mparams[:coeff],1)) + dams*mparams[:coeff]')

        # Placeholder
        exp_next = mparams[:exp_mean].*ones(size(dam_next))

    end

    return states_next, exp_next, dam_next

end
