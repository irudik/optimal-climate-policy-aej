function parameterization(inputs)
"""
Defines model parameters
"""

    # Parameters for beliefs about parameters
    # From /estimate_damage_parameters/table_1.do
    coeff_mean = .00556486
    coeff_var =  .00001433
    exp_mean = 1.882038
    exp_var = .4505272^2
    damage_shock_sd = 1.498293

    if !inputs[:robust]
        theta = 0.0
    end

    if inputs[:perfect_info]
        coeff_var = 1e-12
        exp_var = 1e-12
    end

    # Initialize model parameter dictionary
    mparams = Dict{Symbol,Any}( :theta_robust => inputs[:theta],
        :exp_mean => exp_mean, :exp_var => exp_var,
        :cscert => 3, :b2 => 0.0028388,
        :b3 => 2., :B0 => 1.1, :gB => -0.01, :a0 => 1.17,
        :a1 => 2., :a2 => 2.8, :gPsi => -0.005, :delta => 0.015, :beta => 1/(1.015),
        :L0 => 6514, :dL => 0.035, :Linf => 8600, :kappa => 0.3,
        :A0_N => 0.02722, :gA_N => 0.0092, :dA => 0.001,
        :sigma0 => 0.13418, :gsigma0 => -0.00730, :dsigma => 0.003,
        :deltak => 0.1, :EF0 => -0.06, :EF1 => 0.30,
        :lambda_0 => 0.315, :forcing_per_2xco2 => 3.8,
        :gtc_per_ppm => 2.16, :nqnodes => inputs[:nqnodes],
        :new_bounds_weight_up => inputs[:new_bounds_weight_up],
        :new_bounds_weight_down => inputs[:new_bounds_weight_down],
        :increase_adapt_iter => inputs[:increase_adapt_iter],
        :Mstart => 454.901, :Tstart => 0.7307,
        :increase_dims => inputs[:increase_dims], :increase_dims_adapt => inputs[:increase_dims_adapt],
        :increase_level => inputs[:increase_level], :increase_level_adapt => inputs[:increase_level_adapt],
        :initial_approximation_level => inputs[:initial_approximation_level],
        :approximation_level => inputs[:initial_approximation_level], :rho => -1., :deltak => 0.1,
        :ccr=> 0.0016, :time_horizon => inputs[:time_horizon], :damages => inputs[:damages],
        :sim_length => inputs[:sim_length], :num_runs => inputs[:num_runs], :root_dir => pwd(),
        :num_runs_adapt => inputs[:num_runs_adapt], :sim_length_adapt => inputs[:sim_length_adapt],
        :num_adapts => inputs[:num_adapts], :current_adapt => 0, :scaling_factor => inputs[:scaling_factor],
        :expand_domain => inputs[:expand_domain])

    # Initialize model options dictionary
    opts = Dict{Symbol,Bool}(:perfect_info => inputs[:perfect_info], :robust => inputs[:robust],
        :learn_e => inputs[:learn_e], :sim => false, :first_it => true,
        :adaptive_grid => inputs[:adapt], :adapted => false, :load => inputs[:load])

    # Parameters for misspecified runs: pure damage shocks and weitzman coefficients and exponents
    mparams[:shock_loc] = -0.59
    mparams[:shock_scale] = 1.18
    mparams[:weitz_c1] = 20.46
    mparams[:weitz_c2] = 6.081
    mparams[:weitz_e1] = 2
    mparams[:weitz_e2] = 6.754
    mparams[:dietz_c1] = 0.00284
    mparams[:dietz_c2] = 8.19e-5
    mparams[:dietz_e1] = 2
    mparams[:dietz_e2] = 6.754
    mparams[:extreme_c1] = 0.00284
    mparams[:extreme_c2] = 5.85e-4
    mparams[:extreme_e1] = 2
    mparams[:extreme_e2] = 6.754

    # Location and scale parameter for the joint d1-omega distribution
    mparams[:coeff_mean] = coeff_mean
    mparams[:coeff_loc] = log.(coeff_mean/sqrt(1 + coeff_var/coeff_mean^2)) .- log.(damage_shock_sd^2 + 1)/2.
    mparams[:coeff_scale] = log.(1 + coeff_var/coeff_mean^2) .+ log.(damage_shock_sd^2 + 1)

    # Initial production technology
    mparams[:A0] = mparams[:A0_N]^(1/(1-mparams[:kappa]))

    # Initial growth rate of production technology
    mparams[:gA0] = mparams[:gA_N]/(1-mparams[:kappa])

    # Initial capital
    mparams[:kstart] = 137/mparams[:A0]/mparams[:L0]

    # Initial fractional net output
    mparams[:lossstart] = 1/(1 + exp.(mparams[:coeff_loc])*mparams[:Tstart]^mparams[:exp_mean])

    # Quadrature scheme for joint d1-omega distribution
    de, dw = qnwlogn(mparams[:nqnodes], mparams[:coeff_loc], mparams[:coeff_scale])
    mparams[:coeff] = de
    mparams[:weights] = dw

    # Initial belief conditions
    mparams[:expstart] = mparams[:exp_mean]
    mparams[:varstart] = mparams[:exp_var]

    # Build domain
    if opts[:perfect_info]

        # Set exponent to mean
        mparams[:exp_var] = 1e-12
        mparams[:exp_mean] = 2.0

        # Restrict approximation domain
        domain_loc = mparams[:exp_mean]
        domain_scale = mparams[:exp_var]*1.01
        loc_adjust = .0001
        scale_adjust = .00001

    elseif opts[:learn_e]

        # Restrict approximation domain
        domain_loc = mparams[:exp_mean]
        domain_scale = mparams[:exp_var]*1.01
        loc_adjust = 1.25
        scale_adjust = domain_scale

    elseif ~opts[:perfect_info]

        # Restrict approximation domain
        domain_loc = mparams[:exp_mean]
        domain_scale = mparams[:exp_var]*1.01
        loc_adjust = .0001
        scale_adjust = .00001

    end

    sc = mparams[:expand_domain]

    # Set bounds on approximation domain
    # States in order: capital, cumulative emissions, prior_loc parameter, scale parameter, fractional net output
    if opts[:learn_e]
        mparams[:smin] = [0.00, mparams[:Mstart]-.01,  domain_loc-loc_adjust, domain_scale-scale_adjust, 0.4]
        mparams[:smax] = [6.00, 5000,                  domain_loc+loc_adjust, domain_scale,              1.0]
    else
        mparams[:smin] = [0.65/sc, (mparams[:Mstart]-.01)/sc, 0.3/sc/sc]
        mparams[:smax] = [4.30*sc, 3500*sc,                 1.0]
        mparams[:approximation_level] = mparams[:approximation_level][[1 2 5]]
        mparams[:increase_dims] = mparams[:increase_dims][[1 2 5]]
    end

    # Build approximation space
    space = fundefn(:cheb, mparams[:approximation_level], mparams[:smin], mparams[:smax])
    states = Array{Float64}(undef, prod(mparams[:approximation_level]), length(mparams[:approximation_level]))
    states, bounds = funnode(space)
    space[:num_nodes] = size(states, 1)
    space[:c_cont] = zeros(space[:num_nodes])
    Binv = funbase(space, states)\Matrix{Float64}(I, space[:num_nodes], space[:num_nodes])

    println("Approximating with $(space[:num_nodes]) nodes.")
    if opts[:robust]
        println("Penalty parameter: $(mparams[:theta_robust])")
    end
    println("Domain upper bound: $(mparams[:smax]).")
    println("Domain lower bound: $(mparams[:smin]).")

    ## Compute exogenously evolving variables
    t = 0:mparams[:time_horizon]

    # Non-industrial emissions
    exog_states = Dict{Symbol,Array{Float64}}(:Bs => mparams[:B0]*exp.(mparams[:gB]*t))

    # Labor
    exog_states[:Lt] = mparams[:L0] .+ (mparams[:Linf]-mparams[:L0])*(1 .- exp.(-mparams[:dL]*t))

    # Labor growth
    exog_states[:gL] = mparams[:dL]./((mparams[:Linf]/(mparams[:Linf] .- mparams[:L0]))*exp.(mparams[:dL]*t) .- 1)

    # Technological growth rate
    exog_states[:gA] = mparams[:gA0]*exp.(-mparams[:dA]*t)

    # Technology
    exog_states[:At] = mparams[:A0]*exp.( (mparams[:gA0]/mparams[:dA])*(1 .- exp.(-mparams[:dA]*t)))

    # Growth rate for exogenous growth in labor and productivity
    exog_states[:effkgrowth] = exp.(-(exog_states[:gA] .+ exog_states[:gL]));

    # Effective discount factor
    exog_states[:betaeff] = exp.((-mparams[:delta] .+ exog_states[:gA]*mparams[:rho] .+ exog_states[:gL]))

    # Exogenous decarbonization of production
    exog_states[:sigma] = mparams[:sigma0].*exp.((mparams[:gsigma0]./mparams[:dsigma])*(1 .- exp.(-mparams[:dsigma].*t)))
    exog_states[:emint] = exog_states[:sigma].*exog_states[:At].*exog_states[:Lt]

    # Abatement cost function coefficient
    exog_states[:Psi] = (mparams[:a0].*exog_states[:sigma]./mparams[:a2]).*(1 .- (1 .- exp.(mparams[:gPsi].*t))./mparams[:a1])

    # External forcing
    exog_states[:EF] = mparams[:EF0] .+ 0.01*(mparams[:EF1] .- mparams[:EF0])*min.(t, 100)

    # External forcing in next year
    exog_states[:EF_next] = mparams[:EF0] .+ 0.01*(mparams[:EF1] .- mparams[:EF0])*min.(t .+ 1, 100)

    return states, mparams, exog_states, opts, space, Binv

end
