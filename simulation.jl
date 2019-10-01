function simulate_paths(space, c_store, mparams, opts, smax, smin;
                        misspec_damages = :base, alt_damages = false, d1 = [], d2 = [])
"""
Simulate model, outer function
"""

    # Simulating
    opts[:sim] = true

    # Boolean option for doing alternative (but correctly specified) damage parameters
    opts[:alt_damages] = alt_damages
    if opts[:alt_damages]
        mparams[:d1] = d1
        mparams[:d2] = d2
    end

    # Correctly specified or misspecified damages
    mparams[:damages] = misspec_damages

    # Initialize state array
    if opts[:learn_e]
        states = zeros(mparams[:sim_length] + 1, 5)
    else
        states = zeros(mparams[:sim_length] + 1, 3)
    end

    ## Initialize storage arrays for simulations
    # State array
    s_store = Vector{Array}(undef, mparams[:num_runs])
    # d_2 mean quadrature
    loc_store = Vector{Vector{Array}}(undef, mparams[:num_runs])
    # Carbon tax channels
    channels = Vector{Dict{Symbol,Array}}(undef, mparams[:num_runs])
    # Fractional net output quadrature
    dam_store = Vector{Vector{Array}}(undef, mparams[:num_runs])
    # Controls
    controls_store = Vector{Vector}(undef, mparams[:num_runs])
    # Investment rate
    inv_rate = Vector{Vector}(undef, mparams[:num_runs])
    # Jumps up array
    jumps_up = Vector{Array}(undef, mparams[:num_runs])
    # Jumps down array
    jumps_down = Vector{Array}(undef, mparams[:num_runs])

    # Initial state
    if opts[:learn_e]
        states[1, :] = [mparams[:kstart], mparams[:Mstart], mparams[:expstart], mparams[:varstart], mparams[:lossstart]]
    else
        states[1, :] = [mparams[:kstart], mparams[:Mstart], mparams[:lossstart]]
    end

    # Exogenous variables
    exog_states = simulate_exog_vars(mparams)

    # Load shocks, pre-made so common shocks across different frameworks in the paper
    if mparams[:damages] == :base && mparams[:num_runs] > 1000
        temp = BSON.load("results/loaded_sim_values_large.bson")
    elseif mparams[:damages] == :base && mparams[:num_runs] <= 1000
        temp = BSON.load("results/loaded_sim_values_large_adapt.bson")
    else
        println("Simulating with misspecified damage function.")
        temp = BSON.load("results/loaded_sim_values_alt.bson")
    end
    sim_values = temp["sim_values"]

    # How to generate lognormal random variables:
    # exp.(rand(Normal(location_parameter, sqrt(scale_parameter), number_of_draws))
    # shocks = [exp.(rand(Normal(-0.5885394796543533,sqrt(1.1770789593087065)), 101)) for i = 1:50000]
    # bson("results/loaded_sim_values_large.bson", Dict{String, Array{Array{Float64}}}("shocks" => shocks))
    if opts[:alt_damages]
        shocks_dict = BSON.load("results/loaded_sim_values_shocks.bson")
        extract(shocks_dict)
        sim_values[2] = shocks
    end

    # Initialize array of variables to send to simulator
    sim_parameters = Array{Array}(undef, mparams[:num_runs], 1)
    sim_parameters = [simParameters(states, exog_states, mparams, space, opts, c_store,
        sim_values[1][i], sim_values[2][i], smax, smin) for i = 1:mparams[:num_runs]]

    # Simulate
    sim_results = pmap(simulate_inner, sim_parameters)

    # Pull out and store results
    for run = 1:mparams[:num_runs]
        # Controls
        controls_store[run] = sim_results[run][1]
        # States
        s_store[run] = sim_results[run][2]
        # d_2 mean quadrature
        loc_store[run] = sim_results[run][3]
        # Fractional net output
        dam_store[run] = sim_results[run][4]
        # Carbon tax channels
        channels[run] = sim_results[run][5]
        # Investment rate
        inv_rate[run] = sim_results[run][6]
    end

    # Functions to pull out and separate states and controls
    states_func(M) = [[M[i][:, j] for i = 1:length(M)] for j = 1:size(s_store[1], 2)]
    controls_func(M) = [[[M[i][j][k] for j = 1:mparams[:sim_length]] for i = 1:length(M)] for k = 1:2]

    # Pull out states
    if opts[:learn_e]
        capital, co2, prior_loc, prior_scale, damage = states_func(s_store)
    else
        capital, co2, damage = states_func(s_store)
    end

    # Pull out controls
    consumption, abatement = controls_func(controls_store)

    # Initialize dictionary for mean tax channels
    channels_out = Dict{Symbol,Array}()
    channels_out_samples = Dict{Symbol,Array}()

    # Get 90% confidence bounds on carbon tax
    channels_out[:tax_lower], channels_out[:tax_upper] = get_bounds([channels[i][:scc_direct] for i = 1:mparams[:num_runs]], .05)

    # Pull out individual channels to average out
    for key in keys(channels[1])
        channels_out[key] = [channels[i][key] for i = 1:mparams[:num_runs]]
        # Keep individual run tax channels
        channels_out_samples[key] = [channels[i][key] for i = 1:mparams[:num_runs]]
        # Average channels
        channels_out[key] = mean(hcat(channels_out[key]...), dims = 2)
    end

    if ~opts[:learn_e]
        prior_loc = 0.
        prior_scale = 0.
    end

    return consumption, abatement, inv_rate, capital, co2,
        prior_loc, prior_scale, damage, sim_values, loc_store, dam_store,
        channels_out, channels_out_samples, exog_states

end


function simulate_paths_adapt(space, c_store, mparams, opts, smax, smin;
    alt_damages = false)
"""
Simulate model, outer function for adapted grid
"""

    include("initialization.jl")

    # Boolean option for doing alternative (but correctly specified) damage parameters
    opts[:alt_damages] = alt_damages

    # Simulating
    opts[:sim] = false

    # Initialize state array
    if opts[:learn_e]
        states = zeros(mparams[:sim_length] + 1, 5)
    else
        states = zeros(mparams[:sim_length] + 1, 3)
    end

    ## Initialize storage arrays for simulations
    # State array
    s_store = Vector{Array}(undef, mparams[:num_runs])
    # d_2 mean quadrature
    loc_store = Vector{Vector{Array}}(undef, mparams[:num_runs])
    # Carbon tax channels
    channels = Vector{Dict{Symbol,Array}}(undef, mparams[:num_runs])
    # Fractional net output quadrature
    dam_store = Vector{Vector{Array}}(undef, mparams[:num_runs])
    # Controls
    controls_store = Vector{Vector}(undef, mparams[:num_runs])
    # Investment rate
    inv_rate = Vector{Vector}(undef, mparams[:num_runs])

    # Initial state
    if opts[:learn_e]
        states[1, :] = [mparams[:kstart], mparams[:Mstart], mparams[:expstart], mparams[:varstart], mparams[:lossstart]]
    else
        states[1, :] = [mparams[:kstart], mparams[:Mstart], mparams[:lossstart]]
    end

    # Exogenous variables
    exog_states = simulate_exog_vars(mparams)

    # Load shocks, pre-made so common shocks across different frameworks in the paper
    temp = BSON.load("results/loaded_sim_values_large_adapt.bson")

    sim_values = temp["sim_values"]

    # Initialize array of variables to send to simulator
    sim_parameters = Array{simParameters}(undef, mparams[:num_runs], 1)
    sim_parameters =
        [simParameters(states, exog_states, mparams, space, opts, c_store,
            sim_values[1][i], sim_values[2][i], smax, smin) for i = 1:mparams[:num_runs]]

    # Simulate
    sim_results = pmap(simulate_inner, sim_parameters)

    # Pull out and store results
    for run = 1:mparams[:num_runs]
        # Controls
        controls_store[run] = sim_results[run][1]
        # States
        s_store[run] = sim_results[run][2]
        # d_2 mean quadrature
        loc_store[run] = sim_results[run][3]
        # Fractional net output
        dam_store[run] = sim_results[run][4]
    end

    # Functions to pull out and separate states and controls
    states(M) = [[M[i][:, j] for i = 1:length(M)] for j = 1:size(s_store[1], 2)]
    controls(M) = [[[M[i][j][k] for j = 1:mparams[:sim_length]] for i = 1:length(M)] for k = 1:2]

    # Pull out states
    if opts[:learn_e]
        capital, co2, prior_loc, prior_scale, damage = states(s_store)
    else
        capital, co2, damage = states(s_store)
    end

    # Pull out controls
    consumption, abatement = controls(controls_store)

    if ~opts[:learn_e]
        prior_loc = 0.
        prior_scale = 0.
    end

    return consumption, abatement, capital, co2,
        prior_loc, prior_scale, damage, loc_store, dam_store

end


function simulate_paths_adapt(space, c_store, mparams, opts;
     alt_damages = false)
"""
Simulate model for adaptive grid on first iteration
"""

        include("initialization.jl")

        # Switch for doing alternative (but correctly specified) damage parameters
        opts[:alt_damages] = alt_damages

        # Simulating
        opts[:sim] = false

        # Initialize state array
        if opts[:learn_e]
            states = zeros(mparams[:sim_length] + 1, 5)
        else
            states = zeros(mparams[:sim_length] + 1, 3)
        end

        ## Initialize storage arrays for simulations
        loc_next = Vector{Array}(undef, mparams[:sim_length] + 1)
        dam_next = Vector{Array}(undef, mparams[:sim_length] + 1)
        loc_next[1] = mparams[:expstart]*ones(mparams[:nqnodes], mparams[:nqnodes])
        dam_next[1] = mparams[:lossstart]*ones(mparams[:nqnodes], mparams[:nqnodes])
        s_store = Vector{Array}(mparams[:num_runs_adapt])
        loc_store = Vector{Vector{Array}}(undef, mparams[:num_runs_adapt])
        dam_store = Vector{Vector{Array}}(undef, mparams[:num_runs_adapt])
        controls = Vector{Vector}(undef, mparams[:sim_length])
        controls_store = Vector{Vector}(undef, mparams[:num_runs_adapt])
        loc_next[1] = mparams[:expstart]*ones(mparams[:nqnodes], mparams[:nqnodes])
        dam_next[1] = mparams[:lossstart]*ones(mparams[:nqnodes], mparams[:nqnodes])

        # Initial state
        if opts[:learn_e]
            states[1, :] = [mparams[:kstart], mparams[:Mstart], mparams[:expstart], mparams[:varstart], mparams[:lossstart]]
        else
            states[1, :] = [mparams[:kstart], mparams[:Mstart], mparams[:lossstart]]
        end

        # Exogenous variables
        exog_states = simulate_exog_vars(mparams)

        # Load shocks, pre-made so common shocks across different frameworks in the paper
        temp = BSON.load("results/loaded_sim_values_large_adapt.bson")

        sim_values = temp["sim_values"]

        # Initialize array of variables to send to simulator
        sim_parameters = Array{simParameters}(undef, mparams[:num_runs], 1)
        sim_parameters =
            [simParameters(states, exog_states, mparams, space, opts,
            c_store, sim_values[1][i], sim_values[2][i], smax, smin) for i = 1:mparams[:num_runs]]

        # Simulate
        sim_results = pmap(simulate_inner, sim_parameters)

        # Pull out and store results
        for run = 1:mparams[:num_runs]
            # Controls
            controls_store[run] = sim_results[run][1]
            # States
            s_store[run] = sim_results[run][2]
            # d_2 mean quadrature
            loc_store[run] = sim_results[run][3]
            # Fractional net output
            dam_store[run] = sim_results[run][4]
        end

        # Functions to pull out and separate states and controls
        states(M) = [[M[i][:, j] for i = 1:length(M)] for j = 1:size(s_store[1], 2)]
        controls(M) = [[[M[i][j][k] for j = 1:mparams[:sim_length]] for i = 1:length(M)] for k = 1:2]

        # Pull out states
        if opts[:learn_e]
            capital, co2, prior_loc, prior_scale, damage = states(s_store)
        else
            capital, co2, damage = states(s_store)
        end

        # Pull out controls
        consumption, abatement = controls(controls_store)

        if ~opts[:learn_e]
            prior_loc = 0.
            prior_scale = 0.
        end

        return consumption, abatement, capital, co2,
            prior_loc, prior_scale, damage, loc_store, dam_store

    end

function simulate_inner(sim_parameters_in)
"""
Simulate model, inner function
"""

    # Current state array
    states = sim_parameters_in.states
    # Exogenous variables
    exog_states = sim_parameters_in.exog_states
    # Model parameters
    mparams = sim_parameters_in.mparams
    # Approximation space
    space = sim_parameters_in.space
    # Boolean options
    opts = sim_parameters_in.opts
    # Coefficient vector
    c_store = sim_parameters_in.coefficients

    # Randomly sampled damage parameters
    sim_values = Vector{Array}(undef, 2)
    sim_values[1] = [sim_parameters_in.dam_exponent]
    sim_values[2] = sim_parameters_in.dam_coefficient

    if opts[:adapted]
        smax = sim_parameters_in.smax
        smin = sim_parameters_in.smin
    end

    # Initialize d_2 mean and fractional net output quadrature
    loc_next = Vector{Array}(undef, mparams[:sim_length])
    dam_next = Vector{Array}(undef, mparams[:sim_length])

    # Initialize control vector
    controls = Vector{Vector}(undef, mparams[:sim_length])

    # Initial control guess
    qiguess = [.2, exog_states[:Psi][1]/2]
    cost = 0.
    cons = 0.

    # Initialize investment rate
    inv_rate = Vector{Float64}(undef, mparams[:sim_length])

    # Initialize abatement rate
    mu = Vector{Float64}(undef, mparams[:sim_length])

    # Simulate forward
    for t in 1:mparams[:sim_length]

        if opts[:adapted]
            space = fundefn(:cheb, mparams[:approximation_level], smin[t + 1, :], smax[t + 1, :])
        end

        # Load coefficient vector for continuation value function
        space[:c_cont] = c_store[t + 1]

        # Load year
        space[:year] = t - 1
        mparams[:year] = t - 1

        # Time t exogenous variables
        value_vars = reduce_dict(exog_states, t)

        # Maximize Bellman
        results = maximize_bellman(stateVariables(vec(states[t, :]), qiguess, value_vars, mparams, space, opts, space, 0))

        # Pull out consumption
        cons = results[1][1]

        # Abatement cost
        cost = results[1][2]

        # Abatement rate
        mu[t] = (cost/value_vars[:Psi]).^(1/mparams[:a2])

        # Next period's guess
        qiguess = [max(1, cons), cost]
        qi = [cons, cost]
        v_out = results[2]

        # Store controls in vector
        controls[t] = [qi[1], mu[t]]

        # Store investment rate
        if opts[:learn_e]
            inv_rate[t] = -(qi[1] .+ (qi[2] - 1)*states[t, 1].^mparams[:kappa].*states[t, 5])./(states[t, 1].^mparams[:kappa].*states[t, 5])
        else
            inv_rate[t] = -(qi[1] .+ (qi[2] - 1)*states[t, 1].^mparams[:kappa].*states[t, 3])./(states[t, 1].^mparams[:kappa].*states[t, 3])
        end

        # Compute actual next state and distributions for the next state
        states[t + 1, :], loc_next[t], dam_next[t] = transitions(states[t, :], qi, value_vars, mparams, opts, sim_values[1][1], sim_values[2][t])

    end

    # Compute tax and perform decomposition
    if opts[:sim]
        if opts[:adapted]
            tax_parameters = taxParameters(states, controls, exog_states, mparams, space, opts, c_store, smax, smin, loc_next, dam_next)
            channels = compute_tax(tax_parameters)
        else
            tax_parameters = taxParameters(states, controls, exog_states, mparams, space, opts, c_store, [0. 0.; 0. 0.], [0. 0.; 0. 0.], loc_next, dam_next)
            channels = compute_tax(tax_parameters)
        end

        return controls, states, loc_next, dam_next, channels, inv_rate
    else
        return controls, states, loc_next, dam_next
    end

end


function simulate_exog_vars(mparams)

    # Time periods vector
    t = 0:mparams[:sim_length]

    # Non-industrial emissions
    exog_states = Dict{Symbol,Array}(:Bs => mparams[:B0]*exp.(mparams[:gB]*t))

    # Labor
    exog_states[:Lt] = mparams[:L0] .+ (mparams[:Linf]-mparams[:L0])*(1.0 .- exp.(-mparams[:dL]*t))

    # Labor growth
    exog_states[:gL] = mparams[:dL]./((mparams[:Linf]/(mparams[:Linf]-mparams[:L0]))*exp.(mparams[:dL]*t) .- 1)

    # Technological growth rate
    exog_states[:gA] = mparams[:gA0]*exp.(-mparams[:dA]*t)

    # Technology
    exog_states[:At] = mparams[:A0]*exp.( (mparams[:gA0]/mparams[:dA])*(1 .- exp.(-mparams[:dA]*t)))

    # Growth rate for exogenous growth in labor and productivity
    exog_states[:effkgrowth] = exp.(-(exog_states[:gA]+exog_states[:gL]))

    # Effective discount factor
    exog_states[:betaeff] = exp.((-mparams[:delta] .+ exog_states[:gA]*mparams[:rho] + exog_states[:gL]))

    # Exogenous decarbonization of production
    exog_states[:sigma] = mparams[:sigma0]*exp.((mparams[:gsigma0]/mparams[:dsigma])*(1 .- exp.(-mparams[:dsigma]*t)))
    exog_states[:emint] = exog_states[:sigma].*exog_states[:At].*exog_states[:Lt]

    # Abatement cost function coefficient
    exog_states[:Psi] = (mparams[:a0]*exog_states[:sigma]./mparams[:a2]).*(1 .- (1 .- exp.(mparams[:gPsi]*t))./mparams[:a1] )

    # External forcing
    exog_states[:EF] = mparams[:EF0] .+ 0.01*(mparams[:EF1] .- mparams[:EF0])*min.(t, 100)

    # External forcing in next year
    exog_states[:EF_next] = mparams[:EF0] .+ 0.01*(mparams[:EF1] .- mparams[:EF0])*min.(t .+ 1, 100)

    return exog_states
end
