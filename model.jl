function compute_value_function(inputs)
"""
function for computing the value function
"""

    # Pull in time-invariant model parameters
    states, mparams, exog_states, opts, space, Binv = parameterization(inputs)

    # Copy initial level for later use
    mparams[:initial_smax] = deepcopy(mparams[:smax])
    mparams[:initial_smin] = deepcopy(mparams[:smin])

    # Load terminal value function
    terminal = BSON.load("terminal/terminal_value.bson")
    space_terminal = terminal["space_terminal"]

    # If not loading a previous run start from time-invariant domain
    if ~opts[:load]

        # Initialize domain bounds
        smax = repeat(mparams[:smax]', mparams[:sim_length_adapt], 1)
        smin = repeat(mparams[:smin]', mparams[:sim_length_adapt], 1)

        # Backwards induce the non-adapted problem
        space, c_store, controls = backwards_induce(mparams, exog_states, opts, space, states, Binv, space_terminal)

    end

    # Time-adaptive grid
    if opts[:adaptive_grid]

        if opts[:load]

            smax = inputs[:smax]
            smin = inputs[:smin]

            # Initialize coefficient storage vectors
            c_store = Vector{Vector}(undef, mparams[:time_horizon] + 1)

        end

        # Iterate and adapt the grid
        space, c_store, states, mparams, opts, smax, smin =
            iterate_adaptive_grid(mparams, exog_states, opts, space, states, Binv, space_terminal, smax, smin, c_store)

    end

    if ~opts[:adapted]
        smax = repeat(mparams[:smax]', mparams[:time_horizon], 1)
        smin = repeat(mparams[:smin]', mparams[:time_horizon], 1)
    end

    return space, c_store, states, mparams, opts, smax, smin

end

function backwards_induce(mparams, exog_states, opts, space, states, Binv, space_terminal)
"""
Loops backwards in time and performs VFI
"""

    # Initialize value array
    v = Array{Float64}(undef, space[:num_nodes], 1)

    # Initialize guess for control
    controls = Vector{Vector}(undef, space[:num_nodes])
    for i in eachindex(controls)
        controls[i] = [.1, 1e-4]
    end

    # Initialize coefficient storage vectors
    c_store = Vector{Vector}(undef, mparams[:time_horizon] + 1)

    # Initialize state_variables to pass to the solver
    state_variables = Array{Array}(undef, space[:num_nodes], 1)

    # Initialize current period exogenous variables
    exog_states_t = Dict{Symbol,Any}()

    # Backwards induce the problem
    for t = mparams[:time_horizon]:-1:0

        # Set current year
        mparams[:year] = t

        # Adjust collocation grid and basis functions if increasing number of grid points
        if any(t .== mparams[:increase_level])

            mparams[:approximation_level] = mparams[:approximation_level] .+ mparams[:increase_dims]
            space_new = fundefn(:cheb, mparams[:approximation_level], mparams[:smin], mparams[:smax])
            states = Array{Float64}(undef, prod(mparams[:approximation_level]), length(mparams[:approximation_level]))
            states, bounds = funnode(space_new)
            space_new[:num_nodes] = size(states, 1)
            space[:num_nodes] = size(states, 1)
            space_new[:c_cont] = zeros(space[:num_nodes])
            Binv = funbase(space_new, states)\Matrix{Float64}(I, space_new[:num_nodes], space_new[:num_nodes])
            state_variables = Array{stateVariables}(undef, space[:num_nodes], 1)
            controls = Vector{Vector}(undef, space[:num_nodes])
            [controls[ii] = [.1, .1] for ii in eachindex(controls)]

        end

        # Pull out time-varying variables
        exog_states_t = reduce_dict(exog_states, mparams[:year] + 1)

        # Put in array
        state_variables = [stateVariables(vec(states[node,:]), controls[node], exog_states_t,
            mparams, space, opts, space_terminal, node) for node in eachindex(state_variables)]

        # Iterate on the Bellman
        controls, v = @time iterate_nodes(controls, mparams, opts, state_variables)

        # Store recovered coefficients, controls, and value
        space[:c_cont] = Binv*v

        # If penalty parameter is too small expected continuation value will be Inf
        # and the fitting process will return NaNs for coefficients
        if any(isnan.(space[:c_cont]))
            error("Penalty parameter too small --> breakdown.")
        end

        # Store coefficient vector
        c_store[t+1] = space[:c_cont]

        # Update space if increased approximation level
        if any(mparams[:year] .== mparams[:increase_level])
            space_new[:c_cont] = Binv*v
            space = copy(space_new)
        end

    end

    return space, c_store, controls
end



function backwards_induce(mparams, exog_states, opts, space, states, Binv, space_terminal, smax, smin, adapts)
"""
Loops backwards in time and performs VFI on an adapted grid
"""

    if opts[:learn_e]
        mparams[:approximation_level] = mparams[:initial_approximation_level]
    else
        mparams[:approximation_level] = mparams[:initial_approximation_level][[1 2 5]]
    end

    mparams[:smax] = smax[mparams[:time_horizon] + 1, :]
    mparams[:smin] = smin[mparams[:time_horizon] + 1, :]
    space = fundefn(:cheb, mparams[:approximation_level], mparams[:smin], mparams[:smax])
    space_new = copy(space)
    states = Array{Float64}(undef, prod(mparams[:approximation_level]), length(mparams[:approximation_level]))
    states, bounds = funnode(space)
    space[:num_nodes] = size(states, 1)
    space[:c_cont] = zeros(space[:num_nodes])
    Binv = funbase(space, states)\Matrix{Float64}(I, space[:num_nodes], space[:num_nodes])

    # Initialize value array
    v = zeros(space[:num_nodes], 1)

    # Initialize guess for control
    controls = Vector{Vector}(undef, space[:num_nodes])
    [controls[ii] = [.1, 1e-4] for ii in eachindex(controls)]

    # Coefficient storage vectors
    c_store = Vector{Vector}(undef, mparams[:time_horizon] + 1)

    println("Reapproximating value function on iteration $(mparams[:current_adapt]) with initial approximation level $(mparams[:initial_approximation_level]) and jumps up at $(mparams[:increase_level_adapt]).")

    for t = mparams[:time_horizon]:-1:0

        mparams[:year] = t

        # Check if there was a previous/current increase in approx level
        prev_adapts = mparams[:current_adapt] .- mparams[:increase_adapt_iter]

        # If there was a previous/current adapt
        if any(prev_adapts .>= 0)

            # Get the last approx increase scheme
            last_adapt = mparams[:current_adapt] - minimum(prev_adapts[prev_adapts .>= 0])

            # If at the right year, increase approx level
            if any(adapts .>= mparams[:increase_adapt_iter]) &&
                any(t .== mparams[:increase_level_adapt][findall(mparams[:increase_adapt_iter] .<= adapts)[1]])

                # Current adaptive iteration
                current_iter = findall(mparams[:increase_adapt_iter] .== last_adapt)[1]

                opts[:learn_e] ? idx = collect(1:5) : idx = [1, 2, 5]

                # Increase approximation level given rules for current adaptive iteration and time t
                mparams[:approximation_level] = (mparams[:approximation_level] .+
                mparams[:increase_dims_adapt][current_iter][t .== mparams[:increase_level_adapt][current_iter], idx])

                println("Increased approximation level to  $(mparams[:approximation_level]).")

                # Update approximation space
                space_new = fundefn(:cheb, mparams[:approximation_level], mparams[:smin], mparams[:smax])
                states = Array{Float64}(undef, prod(mparams[:approximation_level]), length(mparams[:approximation_level]))
                states, bounds = funnode(space_new)
                space_new[:num_nodes] = size(states, 1)
                space[:num_nodes] = size(states, 1)
                space_new[:c_cont] = zeros(space[:num_nodes])
                Binv = funbase(space_new, states)\Matrix{Float64}(I, space_new[:num_nodes], space_new[:num_nodes])
                state_variables = Array{stateVariables}(undef, space[:num_nodes], 1)
                controls = Vector{Vector}(undef, space[:num_nodes])
                [controls[ii] = [.1, 1e-4] for ii in eachindex(controls)]

            end

        end

        # Initialize state_variables to pass to the solver
        state_variables = Array{Array}(undef, space[:num_nodes], 1)

        # Initialize current period exogenous variables
        exog_states_t = Dict{Symbol,Any}()

        # Pull out time-varying variables
        exog_states_t = reduce_dict(exog_states, mparams[:year] + 1)

        # Put in array
        state_variables =
            [stateVariables(vec(states[node, :]), controls[node], exog_states_t,
            mparams, space, opts, space_terminal, node) for node in eachindex(state_variables)]

        # Iterate on the Bellman
        controls, v = @time iterate_nodes(controls, mparams, opts, state_variables)

        if t > 0

            if t < mparams[:time_horizon]
                space = copy(space_new)
            end

            mparams[:smax] = smax[t+1, :]
            mparams[:smin] = smin[t+1, :]
            space_new = fundefn(:cheb, mparams[:approximation_level], smin[t,:], smax[t,:])
            space_new[:num_nodes] = size(states, 1)
            states, bounds = funnode(space_new)

        end

        # Store recovered coefficients, controls, and value
        space[:c_cont] = Binv*v
        c_store[t+1] = space[:c_cont]

        if any(t .== mparams[:increase_level_adapt])
            space_new[:c_cont] = Binv*v
            space = copy(space_new)
        end

        # If penalty parameter is too small expected continuation value will be Inf
        # and the fitting process will return NaNs for coefficients
        if any(isnan.(space[:c_cont]))
            error("Penalty parameter too small.")
        end

    end
    return space, c_store, controls
end


function iterate_nodes(controls, mparams, opts, state_variables)
"""
Iterates over the collocation nodes and maximizes the right hand side of the Bellman
"""

    # Initialize control and value vector
    controls = similar(controls)
    v = Array{Float64}(undef, length(controls))

    # Maximization step
    results = pmap(maximize_bellman, state_variables)

    # Pull out maximization results
    for node in eachindex(controls)

        # Consumption and abatement cost
        cons = results[node][1][1]
        cost = results[node][1][2]

        # Output vectors for controls and value
        controls[node] = [cons, cost]
        v[node] = results[node][2]

    end

    # Print current information
    println("----------------------------------------------------")
    println("Year $(mparams[:year]) - Adaptive grid iteration $(mparams[:current_adapt]).")
    if opts[:learn_e]
        println("Domain upper bound: $(mparams[:smax]).")
        println("Domain lower bound: $(mparams[:smin]).")
    end

    return controls, v

end

function iterate_adaptive_grid(mparams, exog_states, opts, space, states, Binv, space_terminal, smax, smin, c_store)
"""
Iterates to adapt the grid
"""

    # Loop over adaptive runs
    for adapts = 1:mparams[:num_adapts]

        # Save current adaptive iteration
        mparams[:current_adapt] = adapts

        # If not loading a previous run, simulate and re-fit the approximation bounds
        if ~opts[:load]

            smax_old = deepcopy(smax)
            smin_old = deepcopy(smin)

            mparams[:sim_length_temp] = copy(mparams[:sim_length])
            mparams[:sim_length] = copy(mparams[:sim_length_adapt])
            mparams[:num_runs] = mparams[:num_runs_adapt]
            opts[:sim] = false
            space_old = deepcopy(space)
            model_parameters_old = deepcopy(mparams)
            println("Adapting grid to simulated path - iteration $(mparams[:current_adapt]).")

            # Get simulated trajectories
            @time consumption, abatement, capital, co2,
                prior_loc, prior_scale, damage, loc_quad, dam_quad =
                simulate_paths_adapt(space, c_store, mparams, opts, smax, smin)

            mparams[:sim_length] = copy(mparams[:sim_length_temp])

            # Start building new approximation bounds
            if opts[:learn_e]
                smax, smin = @time time_adaptive_grid(mparams, capital, co2, prior_loc, prior_scale, damage, loc_quad, dam_quad, states)
            else
                smax, smin = @time time_adaptive_grid(mparams, capital, co2, damage, dam_quad, states)
            end

            # Do spline smoothing
            smax_new = Array{Float64}(undef, mparams[:sim_length_adapt], 5)
            smin_new = Array{Float64}(undef, mparams[:sim_length_adapt], 5)

            for i = [1, 2, 3, 4, 5]

                if i == 1
                    spline_type_max = 1
                    s_type_max = 0.02
                    s_type_min = 2
                    spline_type_min = 3

                elseif i == 5 || i == 4

                    spline_type_max = 2
                    s_type_max = 0.4
                    s_type_min = 3
                    spline_type_min = 3

                else

                    spline_type_max = 2
                    s_type_max = 0.4
                    s_type_min = 0.4
                    spline_type_min = 2

                end

                spline_max = Spline1D(1:mparams[:sim_length_adapt],
                    smax[1:mparams[:sim_length_adapt], i];
                    w = ones(mparams[:sim_length_adapt]), k = spline_type_max, bc = "nearest", s = s_type_max)

                global smax_new[:, i] = evaluate(spline_max, 1:mparams[:sim_length_adapt])

                spline_min = Spline1D(1:mparams[:sim_length_adapt],
                    smin[1:mparams[:sim_length_adapt], i];
                    w = ones(mparams[:sim_length_adapt]), k = spline_type_min, bc = "nearest", s = s_type_min)

                global smin_new[:, i] = evaluate(spline_min, 1:mparams[:sim_length_adapt])

            end

            smax_new = smax_new[:, [1, 2, 3, 4]]
            smin_new = smin_new[:, [1, 2, 3, 4, 5]]

            # Weighted average of old bounds and new bounds
            for tt = 1:mparams[:sim_length_adapt]
                for up_dim = 1:4
                    smax[tt, up_dim] =
                        mparams[:new_bounds_weight_up][up_dim].*smax_new[tt, up_dim] .+
                        (1 - mparams[:new_bounds_weight_up][up_dim]).*smax_old[tt, up_dim]
                end
                for down_dim = 1:5
                    smin[tt,down_dim] =
                        mparams[:new_bounds_weight_down][down_dim].*smin_new[tt,down_dim] .+
                        (1 - mparams[:new_bounds_weight_down][down_dim]).*smin_old[tt, down_dim]
                end
            end

            smin[:,4] = max.(smin[:,4], 0.)

            # Make sure if there are zeros for scale minimum,
            # It doesnt go positive later because of waviness in splines
            for ii = 2:mparams[:sim_length_adapt]
                if smin[ii-1, 4] == 0. && smin[ii, 4] > 0.
                    smin[ii, 4] = 0.
                end
            end

            smax[:,4] = min.(smax[:,4], mparams[:varstart])
            smin[:,4] .= 0.
            smax[:,2] = min.(smax[:,2], mparams[:initial_smax][2])
            smax[mparams[:sim_length_adapt]+1:end, 1] .= smax[mparams[:sim_length_adapt], 1]
            smax[mparams[:sim_length_adapt]+1:end, 4] .= smax[mparams[:sim_length_adapt], 4]
            smin[mparams[:sim_length_adapt]+1:end, 2] .= smin[mparams[:sim_length_adapt], 2]
            smin[mparams[:sim_length_adapt]+1:end, 1] .= mparams[:initial_smin][1]
            smin[mparams[:sim_length_adapt] + 1:end, 2] .= smin[mparams[:sim_length_adapt], 2]
            smax[1,:] = [mparams[:kstart], mparams[:Mstart], mparams[:expstart], mparams[:varstart], mparams[:lossstart]].*1.001
            smin[1,:] = [mparams[:kstart], mparams[:Mstart], mparams[:expstart], mparams[:varstart], mparams[:lossstart]].*0.999
            smax[:,5] .= 1.0


        end

        # Set up for approximation
        opts[:load] = false
        opts[:adapted] = true

        # Backwards induce the adapted problem
        space, c_store, controls =
            backwards_induce(mparams, exog_states, opts, space, states, Binv, space_terminal, smax, smin, adapts)

    end

    return space, c_store, states, mparams, opts, smax, smin

end
