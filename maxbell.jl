function maximize_bellman(state_variables_in)
"""
Right hand side of the Bellman equation that gets maximized at each collocation
node
"""

    ## Pull variables out of stateVariables

    # Current states
    states = state_variables_in.states

    # Controls [consumption, abatement cost]
    controls = state_variables_in.controls

    # Exogenous variables
    exog_states = state_variables_in.exog_states

    # Parameters
    mparams = state_variables_in.mparams

    # Approximation space
    space = state_variables_in.space

    # Boolean options
    opts = state_variables_in.opts

    # Terminal approximation space
    space_terminal = state_variables_in.space_terminal

    # Current node
    node = state_variables_in.node

    # Compute flow utility + expected continuation value for learning model
    function value_func(controls, grad)

        cons = controls[1]
        cost = controls[2]

        # Abatement rate
        abatement = (cost ./ exog_states[:Psi]).^(1 ./ mparams[:a2])

        # Next period's states
        g = zeros(mparams[:nqnodes], mparams[:nqnodes], length(states))

        # Cumulative emissions
        g[:, :, 2] .= states[2] .+ exog_states[:emint].*(1 .- abatement[1]).*states[1].^mparams[:kappa] .+ exog_states[:Bs]

        # Damage quadrature
        dams, total_weight = qnwlogn(mparams[:nqnodes],
            states[3]*log.(mparams[:ccr]*g[1, 1, 2]),
            states[4]*log.(mparams[:ccr]*g[1, 1, 2])^2)

        # Fractional net output
        g[:, :, 5] .= 1 ./ (ones(size(dams, 1), size(mparams[:coeff], 1)) + dams*mparams[:coeff]')

        # d_2 mean
        g[:, :, 3] .= ((mparams[:coeff_scale])*states[3] .+
            states[4].*log.(mparams[:ccr]*g[1, 1, 2]).*(log.(1 ./ g[:, :, 5] .- 1) .- mparams[:coeff_loc]))./
            (mparams[:coeff_scale] .+ states[4]*log.(mparams[:ccr]*g[1, 1, 2])^2)

        # d_2 variance
        g[:, :, 4] .= states[4]*(mparams[:coeff_scale])./
            (mparams[:coeff_scale] .+ states[4]*log.(mparams[:ccr]*g[1, 1, 2])^2)

        # Net output
        exog_states[:net_output] = states[1].^(mparams[:kappa]).*states[5]

        # Capital
        g[:, :, 1] .= (states[1].*(1 .- mparams[:deltak]) .+ (exog_states[:net_output]*(1 .- cost[1]) .- cons[1])) .* exog_states[:effkgrowth]

        # Reshape next period states for evaluating continuation value
        g = reshape(g, mparams[:nqnodes]^2, size(g, 3))

        # Evaluate continuation value
        if mparams[:year] .== mparams[:time_horizon]
            vn,eval_out = funeval(space_terminal[:c_cont], space_terminal, [g[:, 1] g[:, 2] g[:, 5]])
            vn /= mparams[:scaling_factor]
        else
            vn,eval_out = funeval(space[:c_cont] ,space, g)
        end

        # Reshape for taking expectations
        vn = reshape(vn, mparams[:nqnodes], mparams[:nqnodes])

        if !opts[:robust]

            # Expected continuation value
            Ev = total_weight'*vn*total_weight

            # Flow utility
            f = (cons[1]^mparams[:rho])/mparams[:rho]/mparams[:scaling_factor]

            # Total utility
            v = (f .+ exog_states[:betaeff]*Ev)

        else

            # Center value for risk operator about zero
            rc_center = -1 .* total_weight'*vn*total_weight

            # Expectation over d_1,omega_{t+1} inside log, expectation over d_2 outside log
            # Undo centering: .- exog_states[:betaeff]*rc_center
            Ev = -mparams[:theta_robust]*total_weight'*
                log.((exp.(-exog_states[:betaeff]*(vn .+ rc_center)/mparams[:theta_robust]))*total_weight) .- exog_states[:betaeff]*rc_center

            # Flow utility
            f = (cons[1]^mparams[:rho])/mparams[:rho]/mparams[:scaling_factor]

            # Total utility
            v = (f .+ Ev)

        end

        return v[1]

    end

    # Compute flow utility .+ expected continuation value for non-learning model
    function value_func_unc(controls, grad)

        cons = controls[1]
        cost = controls[2]

        # Abatement rate
        abatement = (cost./exog_states[:Psi]).^(1 ./ mparams[:a2])

        # Next period's states
        g = zeros(mparams[:nqnodes], mparams[:nqnodes], length(states))

        # Cumulative emissions
        g[:, :, 2] .= states[2] .+ exog_states[:emint].*(1 .- abatement[1]).*states[1].^mparams[:kappa] .+ exog_states[:Bs]

        if ~opts[:perfect_info]

            # Damage quadrature
            dams, total_weight = qnwlogn(mparams[:nqnodes],
                mparams[:exp_mean]*log.(mparams[:ccr]*g[1, 1, 2]),
                mparams[:exp_var]*log.(mparams[:ccr]*g[1, 1, 2])^2)

            # Fractional net output
            g[:, :, 3] .= 1.0./(ones(size(dams,1),size(mparams[:coeff],1))+dams*mparams[:coeff]')

        else

            total_weight = ones(mparams[:nqnodes], 1)/mparams[:nqnodes]

            # Fractional net output
            g[:, :, 3] .= 1 ./ (1 + exp(mparams[:coeff_loc])*(mparams[:ccr]*g[1, 1, 2])^mparams[:exp_mean])

        end

        # Net output
        exog_states[:net_output] = states[1].^(mparams[:kappa]).*states[3]

        # Capital
        g[:, :, 1] .= (states[1].*(1 .- mparams[:deltak]) .+ (exog_states[:net_output]*(1 .- cost[1]) .- cons[1])) .* exog_states[:effkgrowth]

        # Reshape next period states for evaluating continuation value
        g = reshape(g, mparams[:nqnodes]^2, size(g, 3))

        # Evaluate continuation value
        if mparams[:year] .== mparams[:time_horizon]
            vn,eval_out = funeval(space_terminal[:c_cont], space_terminal, g)
            vn /= mparams[:scaling_factor]
        else
            vn,eval_out = funeval(space[:c_cont], space, g)
        end

        # Reshape for taking expectations
        vn = reshape(vn, mparams[:nqnodes], mparams[:nqnodes])

        if !opts[:robust]

            # Expected continuation value
            Ev = total_weight'*vn*total_weight

            # Flow utility
            f = (cons[1]^mparams[:rho])/mparams[:rho]/mparams[:scaling_factor]

            # Total utility
            v = (f .+ exog_states[:betaeff]*Ev)

        else

            # Center value for risk operator
            rc_center = -1 .* total_weight'*vn*total_weight

            # Expectation over d_1,omega_{t+1} inside log, expectation over d_2 outside log
            # Undo centering: .- exog_states[:betaeff]*rc_center
            Ev = -mparams[:theta_robust]*total_weight'*
                log.((exp.(-exog_states[:betaeff]*(vn .+ rc_center)/mparams[:theta_robust]))*total_weight) .- exog_states[:betaeff]*rc_center

            # Flow utility
            f = (cons[1]^mparams[:rho])/mparams[:rho]/mparams[:scaling_factor]

            # Total utility
            v = (f .+ Ev)
        end

        return v[1]

    end


    # Initialize optimizer
    opt = Opt(:LN_COBYLA,2)

    # Bounds on consumption (~0, net output) and abatement cost (0, cost of full abatement)
    lower_bounds!(opt, [1e-10, 0.])

    # Initial guess needs to be inside the bounds or else NLopt throws an error
    if opts[:learn_e]
        upper_bounds!(opt, [states[5]*states[1].^mparams[:kappa], exog_states[:Psi]])
        controls[1] = max(min(states[5]*states[1].^mparams[:kappa], controls[1]), 1e-5)
        controls[2] = max(min(exog_states[:Psi], controls[2]), 0.)
    else
        upper_bounds!(opt, [states[3]*states[1].^mparams[:kappa], exog_states[:Psi]])
        controls[1] = max(min(states[3]*states[1].^mparams[:kappa], controls[1]), 1e-5)
        controls[2] = max(min(exog_states[:Psi], controls[2]), 0.)
    end

    function resource_constraint(xx,grad)
    """
    Inequality constraint requiring that consumption and abatement are less than
    net output. Returns negative (required by NLopt) net output after consumption
    and abatement.
    """

        if opts[:learn_e]
            resource_left = xx[1] .+ (xx[2] - 1)*states[1].^mparams[:kappa].*states[5]
        else
            resource_left = xx[1] .+ (xx[2] - 1)*states[1].^mparams[:kappa].*states[3]
        end

        return resource_left

    end

    # Set resource constraint
    inequality_constraint!(opt, (xx,g) -> resource_constraint(xx,g), 1e-4)

    # Solution tolerances
    if opts[:sim]
        ftol_abs!(opt, 1e-13)
        ftol_rel!(opt, 1e-13)
        xtol_rel!(opt, 1e-13)
        xtol_abs!(opt, 1e-13)
    else
        ftol_abs!(opt, 1e-8)
        ftol_rel!(opt, 1e-8)
        xtol_rel!(opt, 1e-8)
        xtol_abs!(opt, 1e-8)
    end

    # Set max evaluations
    maxeval!(opt, 2000)

    # Declare maximization problem
    if opts[:learn_e]
        max_objective!(opt, value_func)
    else
        max_objective!(opt, value_func_unc)
    end

    # NLopt does a bad job handling initial guesses where the constraints are violated
    # so if the initial guess violates the constraint keep reducing consumption
    # until it doesnt
    while resource_constraint(controls, [0.]) > 0
        controls[1] /= 2
    end

    # Maximize right hand side of Bellman
    maxf, maxx, ret = optimize(opt, controls)

    # Return argmaxs and maximum value for polynomial fitting
    return maxx, maxf[1]

end
