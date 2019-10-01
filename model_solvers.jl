##################################
##################################
# Figures 5a, 7, A2, A3
# Tables 2, 3, A4
##################################
##################################

function solve_uncert(na = 1; expand = 1., quad = 11)

    inputs = Dict{Symbol,Any}(:scaling_factor => 1.0::Float64,
        :initial_approximation_level => [9 9 9 9 9]::Array{Int64,2},
        :expand_domain => expand::Float64,
        :increase_level => [-111]::Vector{Int64},
        :increase_dims => [1 0 0 0 0]::Array{Int64,2},
        :adapt => false::Bool,
        :num_adapts => 1::Int64,
        :num_runs_adapt => 1000::Int64,
        :sim_length_adapt => 300::Int64,
        :increase_adapt_iter => [1]::Vector{Int64},
        :increase_level_adapt => [[502]]::Vector{Vector{Int64}},
        :increase_dims_adapt => [[2 0 0 0 0]]::Vector{Array{Int64,2}},
        :new_bounds_weight_up => [.3 .4 .5 .0 .0]::Array{Float64,2},
        :new_bounds_weight_down => [.1 .3 .5 .0 .5]::Array{Float64,2},
        :load => false::Bool,
        :time_horizon => 600::Int64,
        :sim_length => 101::Int64,
        :perfect_info => false::Bool,
        :learn_e => false::Bool,
        :robust => false::Bool,
        :theta => 3.9::Float64,
        :damages => :base::Symbol,
        :num_runs => 1000::Int64,
        :nqnodes => quad::Int64,
        :smax => [0. 0.; 0. 0.]::Array{Float64,2},
        :smin => [0. 0.; 0. 0.]::Array{Float64,2})


    # Solve the model
    space, c_store, s, mparams, opts, smax, smin = @time compute_value_function(inputs);

    if inputs[:nqnodes] == 11 && expand == 1.0
        mparams[:num_runs] = 50000
    else
        mparams[:num_runs] = 10000
    end

    @time consumption, abatement, inv_rate, capital, co2,
      prior_loc, prior_scale, damage, sim_values, loc_quad, dam_quad,
      tax_channels, channels_out_samples, vars =
      simulate_paths(space, c_store, mparams, opts, smax, smin);

    # Save variables
    if inputs[:nqnodes] == 11 && expand == 1.0
        bson("results/uncert_results.bson", Dict{String, Any}("inputs" => inputs, "mparams" => mparams, "smax" => smax, "smin" => smin,
          "tax_channels" => tax_channels, "consumption" => consumption, "abatement" => abatement,
          "capital" => capital, "co2" => co2, "prior_loc" => prior_loc,
          "prior_scale" => prior_scale, "damage" => damage, "opts" => opts,
          "channels_out_samples" => channels_out_samples, "space" => space, "c_store" => c_store))
    elseif expand > 1.0
        bson("results/uncert_results_wide.bson",
            Dict{String, Any}("tax_channels" => tax_channels, "consumption" => consumption))
    else
        bson("results/uncert_results_quad.bson",
            Dict{String, Any}("tax_channels" => tax_channels, "consumption" => consumption))
    end


end


function solve_learn(na = 1; load = false, quad = 11, adapt_iters = 20)

    if !load

        inputs = Dict{Symbol,Any}(:scaling_factor => 1.0::Float64,
            :initial_approximation_level => [3 5 3 7 5]::Array{Int64,2},
            :expand_domain => 1.::Float64,
            :increase_level => [-111]::Vector{Int64},
            :increase_dims => [1 0 0 0 0]::Array{Int64,2},
            :adapt => true::Bool,
            :num_adapts => adapt_iters::Int64,
            :num_runs_adapt => 1000::Int64,
            :sim_length_adapt => 300::Int64,
            :increase_adapt_iter => [17]::Vector{Int64},
            :increase_level_adapt => [[502]]::Vector{Vector{Int64}},
            :increase_dims_adapt => [[2 0 0 0 0]]::Vector{Array{Int64,2}},
            :new_bounds_weight_up => [.3 .4 .5 .0 .0]::Array{Float64,2},
            :new_bounds_weight_down => [.1 .3 .5 .0 .5]::Array{Float64,2},
            :load => false::Bool,
            :time_horizon => 600::Int64,
            :sim_length => 101::Int64,
            :perfect_info => false::Bool,
            :learn_e => true::Bool,
            :robust => false::Bool,
            :theta => 3.9::Float64,
            :damages => :base::Symbol,
            :num_runs => 1000::Int64,
            :nqnodes => 11::Int64,
            :smax => [0. 0. ; 0. 0.]::Array{Float64,2},
            :smin => [0. 0. ; 0. 0.]::Array{Float64,2})



        # Solve the model to get the final collocation bounds
        space, c_store, s, mparams, opts, smax, smin = @time compute_value_function(inputs)

        # Save variables
        bson("results/learning_results_adapt_$adapt_iters.bson",
            Dict{String, Any}("smax" => smax, "smin" => smin))

    else

        learn = BSON.load("results/learning_results_adapt_20.bson")
        smax = learn["smax"]
        smin = learn["smin"]

    end

    inputs = Dict{Symbol,Any}(:scaling_factor => 1.0::Float64,
        :initial_approximation_level => [3 5 3 7 5]::Array{Int64,2},
        :expand_domain => 1.::Float64,
        :increase_level => [-111]::Vector{Int64},
        :increase_dims => [1 0 0 0 0]::Array{Int64,2},
        :adapt => true::Bool,
        :num_adapts => 1::Int64,
        :num_runs_adapt => 1000::Int64,
        :sim_length_adapt => 300::Int64,
        :increase_adapt_iter => [1]::Vector{Int64},
        :increase_level_adapt => [[502]]::Vector{Vector{Int64}},
        :increase_dims_adapt => [[1 0 0 0 0]]::Vector{Array{Int64,2}},
        :new_bounds_weight_up => [.3 .4 .5 .0 .0]::Array{Float64,2},
        :new_bounds_weight_down => [.1 .3 .5 .0 .5]::Array{Float64,2},
        :load => true::Bool,
        :time_horizon => 600::Int64,
        :sim_length => 101::Int64,
        :perfect_info => false::Bool,
        :learn_e => true::Bool,
        :robust => false::Bool,
        :theta => 3.9::Float64,
        :damages => :base::Symbol,
        :num_runs => 1000::Int64,
        :nqnodes => quad::Int64,
        :smax => smax::Array{Float64,2},
        :smin => smin::Array{Float64,2})



    # Solve the model
    space, c_store, s, mparams, opts, smax, smin = @time compute_value_function(inputs)

    if inputs[:nqnodes] == 11 && adapt_iters == 20
        mparams[:num_runs] = 50000
    else
        mparams[:num_runs] = 10000
    end

    @time consumption, abatement, inv_rate, capital, co2,
        prior_loc, prior_scale, damage, sim_values, loc_quad, dam_quad,
        tax_channels, channels_out_samples, vars =
        simulate_paths(space, c_store, mparams, opts, smax, smin);

    # Save variables
    if inputs[:nqnodes] == 11
        bson("results/learning_results_adapt_$adapt_iters.bson", Dict{String, Any}("inputs" => inputs, "mparams" => mparams, "smax" => smax, "smin" => smin,
          "tax_channels" => tax_channels, "consumption" => consumption, "abatement" => abatement,
          "capital" => capital, "co2" => co2, "prior_loc" => prior_loc,
          "prior_scale" => prior_scale, "damage" => damage, "opts" => opts,
          "channels_out_samples" => channels_out_samples, "space" => space, "c_store" => c_store))
    else
        bson("results/learning_results_quad.bson",
            Dict{String, Any}("tax_channels" => tax_channels, "consumption" => consumption))
    end

end


function solve_rc(theta; expand = 1., quad = 11)

    inputs = Dict{Symbol,Any}(:scaling_factor => 1.06::Float64,
        :initial_approximation_level => [9 9 9 9 9]::Array{Int64,2},
        :expand_domain => expand::Float64,
        :increase_level => [-111]::Vector{Int64},
        :increase_dims => [1 0 0 0 0]::Array{Int64,2},
        :adapt => false::Bool,
        :num_adapts => 1::Int64,
        :num_runs_adapt => 1000::Int64,
        :sim_length_adapt => 300::Int64,
        :increase_adapt_iter => [1]::Vector{Int64},
        :increase_level_adapt => [[-111]]::Vector{Vector{Int64}},
        :increase_dims_adapt => [[2 0 0 0 0]]::Vector{Array{Int64,2}},
        :new_bounds_weight_up => [.3 .4 .5 .0 .0]::Array{Float64,2},
        :new_bounds_weight_down => [.1 .3 .5 .0 .5]::Array{Float64,2},
        :load => false::Bool,
        :time_horizon => 600::Int64,
        :sim_length => 101::Int64,
        :perfect_info => false::Bool,
        :learn_e => false::Bool,
        :robust => true::Bool,
        :theta => theta::Float64,
        :damages => :base::Symbol,
        :num_runs => 1000::Int64,
        :nqnodes => quad::Int64,
        :smax => [0. 0.; 0. 0.]::Array{Float64,2},
        :smin => [0. 0.; 0. 0.]::Array{Float64,2})


    # Solve the model
    space, c_store, s, mparams, opts, smax, smin = @time compute_value_function(inputs);

    if inputs[:nqnodes] == 11 && theta < 4.0 && expand == 1.0
        mparams[:num_runs] = 50000
    elseif theta < 4.0
        mparams[:num_runs] = 10000
    else
        mparams[:num_runs] = 10
    end

    @time consumption, abatement, inv_rate, capital, co2,
      prior_loc, prior_scale, damage, sim_values, loc_quad, dam_quad,
      tax_channels, channels_out_samples, vars =
      simulate_paths(space, c_store, mparams, opts, smax, smin);

    # Save variables
    if inputs[:nqnodes] == 11 && expand == 1.0
        bson("results/rc_results_$theta.bson", Dict{String, Any}("inputs" => inputs, "mparams" => mparams, "smax" => smax, "smin" => smin,
          "tax_channels" => tax_channels, "consumption" => consumption, "abatement" => abatement,
          "capital" => capital, "co2" => co2, "prior_loc" => prior_loc,
          "prior_scale" => prior_scale, "damage" => damage, "opts" => opts,
          "channels_out_samples" => channels_out_samples, "space" => space, "c_store" => c_store))
    elseif expand > 1
        bson("results/rc_results_$(theta)_wide.bson",
            Dict{String, Any}("tax_channels" => tax_channels, "consumption" => consumption))
    else
        bson("results/rc_results_$(theta)_quad.bson",
            Dict{String, Any}("tax_channels" => tax_channels, "consumption" => consumption))
    end

end


function solve_rcl(theta; quad = 11, adapt_iters = 20)

    learn = BSON.load("results/learning_results_adapt_$(adapt_iters).bson")

    inputs = Dict{Symbol,Any}(:scaling_factor => quad == 11 ? 2.9 : 3.1::Float64,
        :initial_approximation_level => [3 5 3 7 5]::Array{Int64,2},
        :expand_domain => 1.::Float64,
        :increase_level => [-111]::Vector{Int64},
        :increase_dims => [1 0 0 0 0]::Array{Int64,2},
        :adapt => true::Bool,
        :num_adapts => 1::Int64,
        :num_runs_adapt => 1000::Int64,
        :sim_length_adapt => 300::Int64,
        :increase_adapt_iter => [1]::Vector{Int64},
        :increase_level_adapt => [[502]]::Vector{Vector{Int64}},
        :increase_dims_adapt => [[1 0 0 0 0]]::Vector{Array{Int64,2}},
        :new_bounds_weight_up => [.3 .4 .5 .0 .0]::Array{Float64,2},
        :new_bounds_weight_down => [.1 .3 .5 .0 .5]::Array{Float64,2},
        :load => true::Bool,
        :time_horizon => 600::Int64,
        :sim_length => 101::Int64,
        :perfect_info => false::Bool,
        :learn_e => true::Bool,
        :robust => true::Bool,
        :theta => theta::Float64,
        :damages => :base::Symbol,
        :num_runs => 1000::Int64,
        :nqnodes => quad::Int64,
        :smax => learn["smax"]::Array{Float64,2},
        :smin => learn["smin"]::Array{Float64,2})

    # Solve the model
    space, c_store, s, mparams, opts, smax, smin = @time compute_value_function(inputs)

    if inputs[:nqnodes] == 11 && theta < 4.0 && adapt_iters == 20
        mparams[:num_runs] = 50000
    elseif theta < 4.0
        mparams[:num_runs] = 10000
    else
        mparams[:num_runs] = 10
    end

    @time consumption, abatement, inv_rate, capital, co2,
        prior_loc, prior_scale, damage, sim_values, loc_quad, dam_quad,
        tax_channels, channels_out_samples, vars =
        simulate_paths(space, c_store, mparams, opts, smax, smin);

    # Save variables
    if inputs[:nqnodes] == 11
        bson("results/rcl_results_$(theta)_adapt_$adapt_iters.bson", Dict{String, Any}("inputs" => inputs, "mparams" => mparams, "smax" => smax, "smin" => smin,
          "tax_channels" => tax_channels, "consumption" => consumption, "abatement" => abatement,
          "capital" => capital, "co2" => co2, "prior_loc" => prior_loc,
          "prior_scale" => prior_scale, "damage" => damage, "opts" => opts,
          "channels_out_samples" => channels_out_samples, "space" => space, "c_store" => c_store))
    else
        bson("results/rcl_results_$(theta)_quad.bson",
            Dict{String, Any}("tax_channels" => tax_channels, "consumption" => consumption))
    end

end


##################################
##################################
# Figures 5b, 5c, 5d
##################################
##################################

function simulate_alt_damage_params(model_path, d1, d2)

    model = BSON.load(model_path)

    model["mparams"][:num_runs] = 5000

    if model["opts"][:robust] && model["opts"][:learn_e]
        type = "rcl"
    elseif model["opts"][:robust] && !model["opts"][:learn_e]
        type = "rc"
    elseif !model["opts"][:robust] && model["opts"][:learn_e]
        type = "learn"
    else
        type = "uncert"
    end

    @time consumption, abatement, inv_rate, capital, co2,
        prior_loc, prior_scale, damage, sim_values, loc_quad, dam_quad,
        tax_channels, channels_out_samples, vars = simulate_paths(model["space"], model["c_store"], model["mparams"],
        model["opts"], model["smax"], model["smin"],
        alt_damages = true, d1 = d1, d2 = d2);


    # Save variables
    bson("results/" * type * "_results_dam_d1_$(d1)_d2_$(d2).bson",
        Dict{String, Any}("mparams" => model["mparams"], "tax_channels" => tax_channels,
        "consumption" => consumption, "abatement" => abatement,
        "capital" => capital, "co2" => co2, "prior_loc" => prior_loc,
        "prior_scale" => prior_scale, "damage" => damage))

end



##################################
##################################
# Figure 8
##################################
##################################

function simulate_misspecified_damages(model_path, damage_type)

    model = BSON.load(model_path)

    model["mparams"][:num_runs] = 10000
    model["mparams"][:sim_length] = 201

    if model["opts"][:robust] && model["opts"][:learn_e]
        type = "rcl"
    elseif model["opts"][:robust] && !model["opts"][:learn_e]
        type = "rc"
    elseif !model["opts"][:robust] && model["opts"][:learn_e]
        type = "learn"
    else
        type = "uncert"
    end

    @time consumption, abatement, inv_rate, capital, co2,
        prior_loc, prior_scale, damage, sim_values, loc_quad, dam_quad,
        tax_channels, channels_out_samples, vars =
        simulate_paths(model["space"], model["c_store"], model["mparams"],
        model["opts"], model["smax"], model["smin"],
        misspec_damages = damage_type);


    # Save variables
    bson("results/" * type * "_results_dam_misspec_$(string(damage_type)).bson",
        Dict{String, Any}("mparams" => model["mparams"], "tax_channels" => tax_channels,
        "consumption" => consumption, "abatement" => abatement,
        "capital" => capital, "co2" => co2, "prior_loc" => prior_loc,
        "prior_scale" => prior_scale, "damage" => damage))

end


##################################
##################################
# Figures 6a and 6b
##################################
##################################

function solve_alt_penalty_parameter_rc()

    thetas = [6.0, 8.0, 10.0, sqrt(10.)*10., 100.0, sqrt(10.)*100., 1000.0]

    for theta in thetas

        solve_rc(theta)

    end

end

function solve_alt_penalty_parameter_rcl()

    thetas = [6.0, 8.0, 10.0, sqrt(10.)*10., 100.0, sqrt(10.)*10., 1000.0]

    for theta in thetas

        solve_rcl(theta)

    end

end

##################################
##################################
# Table A4: 1st panel
##################################
##################################

function solve_uncert_error_coll()

inc_dims_vec = [[1 0 0 0 0],
                [0 1 0 0 0],
                [0 0 0 0 1],
                [-1 0 0 0 0]]

    for (index, inc_dims) in enumerate(inc_dims_vec)

        inputs = Dict{Symbol,Any}(:scaling_factor => 1.0::Float64,
            :initial_approximation_level => [9 9 9 9 9]::Array{Int64,2},
            :expand_domain => 1.::Float64,
            :increase_level => [102]::Vector{Int64},
            :increase_dims => inc_dims::Array{Int64,2},
            :adapt => false::Bool,
            :num_adapts => 1::Int64,
            :num_runs_adapt => 1000::Int64,
            :sim_length_adapt => 300::Int64,
            :increase_adapt_iter => [1]::Vector{Int64},
            :increase_level_adapt => [[502]]::Vector{Vector{Int64}},
            :increase_dims_adapt => [[2 0 0 0 0]]::Vector{Array{Int64,2}},
            :new_bounds_weight_up => [.3 .4 .5 .0 .0]::Array{Float64,2},
            :new_bounds_weight_down => [.1 .3 .5 .0 .5]::Array{Float64,2},
            :load => false::Bool,
            :time_horizon => 600::Int64,
            :sim_length => 101::Int64,
            :perfect_info => false::Bool,
            :learn_e => false::Bool,
            :robust => false::Bool,
            :theta => 3.9::Float64,
            :damages => :base::Symbol,
            :num_runs => 1000::Int64,
            :nqnodes => 11::Int64,
            :smax => [0. 0.; 0. 0.]::Array{Float64,2},
            :smin => [0. 0.; 0. 0.]::Array{Float64,2})


        # Solve the model
        space, c_store, s, mparams, opts, smax, smin = @time compute_value_function(inputs);

        mparams[:num_runs] = 10000
        @time consumption, abatement, inv_rate, capital, co2,
          prior_loc, prior_scale, damage, sim_values, loc_quad, dam_quad,
          tax_channels, channels_out_samples, vars =
          simulate_paths(space, c_store, mparams, opts, smax, smin);

        # Save variables
        bson("results/uncert_results_coll_$index.bson",
            Dict{String, Any}("tax_channels" => tax_channels, "consumption" => consumption))

    end

end

function solve_learn_error_coll()

    inc_dims_vec = [[1 0 0 0 0; 1 0 0 0 0],
                    [1 0 0 0 0; 0 1 0 0 0],
                    [1 0 0 0 0; 0 0 1 0 0],
                    [1 0 0 0 0; 0 0 0 1 0],
                    [1 0 0 0 0; 0 0 0 0 1],
                    [1 0 0 0 0; -1 0 0 0 0]]

    for (index, inc_dims) in enumerate(inc_dims_vec)

        learn = BSON.load("results/learning_results_adapt_20.bson")

        inputs = Dict{Symbol,Any}(:scaling_factor => 1.0::Float64,
            :initial_approximation_level => [3 5 3 7 5]::Array{Int64,2},
            :expand_domain => 1.::Float64,
            :increase_level => [-111]::Vector{Int64},
            :increase_dims => [1 0 0 0 0]::Array{Int64,2},
            :adapt => true::Bool,
            :num_adapts => 1::Int64,
            :num_runs_adapt => 1000::Int64,
            :sim_length_adapt => 300::Int64,
            :increase_adapt_iter => [1]::Vector{Int64},
            :increase_level_adapt => [[502, 102]]::Vector{Vector{Int64}},
            :increase_dims_adapt => [inc_dims]::Vector{Array{Int64,2}},
            :new_bounds_weight_up => [.3 .4 .5 .0 .0]::Array{Float64,2},
            :new_bounds_weight_down => [.1 .3 .5 .0 .5]::Array{Float64,2},
            :load => true::Bool,
            :time_horizon => 600::Int64,
            :sim_length => 101::Int64,
            :perfect_info => false::Bool,
            :learn_e => true::Bool,
            :robust => false::Bool,
            :theta => 3.9::Float64,
            :damages => :base::Symbol,
            :num_runs => 1000::Int64,
            :nqnodes => 11::Int64,
            :smax => learn["smax"]::Array{Float64,2},
            :smin => learn["smin"]::Array{Float64,2})



        # Solve the model
        space, c_store, s, mparams, opts, smax, smin = @time compute_value_function(inputs)

        mparams[:num_runs] = 10000

        @time consumption, abatement, inv_rate, capital, co2,
            prior_loc, prior_scale, damage, sim_values, loc_quad, dam_quad,
            tax_channels, channels_out_samples, vars =
            simulate_paths(space, c_store, mparams, opts, smax, smin);

        # Save variables
        bson("results/learning_results_coll_$index.bson",
            Dict{String, Any}("tax_channels" => tax_channels, "consumption" => consumption))

    end

end


function solve_rc_error_coll()

inc_dims_vec = [[1 0 0 0 0],
                [0 1 0 0 0],
                [0 0 0 0 1],
                [-1 0 0 0 0]]

    for (index, inc_dims) in enumerate(inc_dims_vec)

        inputs = Dict{Symbol,Any}(:scaling_factor => 1.06::Float64,
            :initial_approximation_level => [9 9 9 9 9]::Array{Int64,2},
            :expand_domain => 1.0::Float64,
            :increase_level => [502]::Vector{Int64},
            :increase_dims => inc_dims::Array{Int64,2},
            :adapt => false::Bool,
            :num_adapts => 1::Int64,
            :num_runs_adapt => 1000::Int64,
            :sim_length_adapt => 300::Int64,
            :increase_adapt_iter => [1]::Vector{Int64},
            :increase_level_adapt => [[502]]::Vector{Vector{Int64}},
            :increase_dims_adapt => [[2 0 0 0 0]]::Vector{Array{Int64,2}},
            :new_bounds_weight_up => [.3 .4 .5 .0 .0]::Array{Float64,2},
            :new_bounds_weight_down => [.1 .3 .5 .0 .5]::Array{Float64,2},
            :load => false::Bool,
            :time_horizon => 600::Int64,
            :sim_length => 101::Int64,
            :perfect_info => false::Bool,
            :learn_e => false::Bool,
            :robust => true::Bool,
            :theta => 3.9::Float64,
            :damages => :base::Symbol,
            :num_runs => 1000::Int64,
            :nqnodes => 11::Int64,
            :smax => [0. 0.; 0. 0.]::Array{Float64,2},
            :smin => [0. 0.; 0. 0.]::Array{Float64,2})


        # Solve the model
        space, c_store, s, mparams, opts, smax, smin = @time compute_value_function(inputs);

        mparams[:num_runs] = 10000

        @time consumption, abatement, inv_rate, capital, co2,
          prior_loc, prior_scale, damage, sim_values, loc_quad, dam_quad,
          tax_channels, channels_out_samples, vars =
          simulate_paths(space, c_store, mparams, opts, smax, smin);

        # Save variables
        bson("results/rc_results_coll_$index.bson",
            Dict{String, Any}("tax_channels" => tax_channels, "consumption" => consumption))

    end

end


function solve_rcl_error_coll()

    inc_dims_vec = [[1 0 0 0 0; 1 0 0 0 0],
                    [1 0 0 0 0; 0 1 0 0 0],
                    [1 0 0 0 0; 0 0 1 0 0],
                    [1 0 0 0 0; 0 0 0 1 0],
                    [1 0 0 0 0; 0 0 0 0 1],
                    [1 0 0 0 0; -1 0 0 0 0]]

    for (index, inc_dims) in enumerate(inc_dims_vec)

        learn = BSON.load("results/learning_results_adapt_20.bson")

        inputs = Dict{Symbol,Any}(:scaling_factor => 6.4::Float64,
            :initial_approximation_level => [3 5 3 7 5]::Array{Int64,2},
            :expand_domain => 1.::Float64,
            :increase_level => [-111]::Vector{Int64},
            :increase_dims => [1 0 0 0 0]::Array{Int64,2},
            :adapt => true::Bool,
            :num_adapts => 1::Int64,
            :num_runs_adapt => 1000::Int64,
            :sim_length_adapt => 300::Int64,
            :increase_adapt_iter => [1]::Vector{Int64},
            :increase_level_adapt => [[502, 102]]::Vector{Vector{Int64}},
            :increase_dims_adapt => [inc_dims]::Vector{Array{Int64,2}},
            :new_bounds_weight_up => [.3 .4 .5 .0 .0]::Array{Float64,2},
            :new_bounds_weight_down => [.1 .3 .5 .0 .5]::Array{Float64,2},
            :load => true::Bool,
            :time_horizon => 600::Int64,
            :sim_length => 101::Int64,
            :perfect_info => false::Bool,
            :learn_e => true::Bool,
            :robust => true::Bool,
            :theta => 3.9::Float64,
            :damages => :base::Symbol,
            :num_runs => 1000::Int64,
            :nqnodes => 11::Int64,
            :smax => learn["smax"]::Array{Float64,2},
            :smin => learn["smin"]::Array{Float64,2})



        # Solve the model
        space, c_store, s, mparams, opts, smax, smin = @time compute_value_function(inputs)

        mparams[:num_runs] = 10000

        @time consumption, abatement, inv_rate, capital, co2,
            prior_loc, prior_scale, damage, sim_values, loc_quad, dam_quad,
            tax_channels, channels_out_samples, vars =
            simulate_paths(space, c_store, mparams, opts, smax, smin);

        # Save variables
        bson("results/rcl_results_coll_$index.bson",
            Dict{String, Any}("tax_channels" => tax_channels, "consumption" => consumption))

    end

end


##################################
##################################
# Figure A2
##################################
##################################

function solve_learn_previous_iter(quad = 11, adapt_iters = 19)

    inputs = Dict{Symbol,Any}(:scaling_factor => 1.0::Float64,
        :initial_approximation_level => [3 5 3 7 5]::Array{Int64,2},
        :expand_domain => 1.::Float64,
        :increase_level => [-111]::Vector{Int64},
        :increase_dims => [1 0 0 0 0]::Array{Int64,2},
        :adapt => true::Bool,
        :num_adapts => adapt_iters::Int64,
        :num_runs_adapt => 1000::Int64,
        :sim_length_adapt => 300::Int64,
        :increase_adapt_iter => [17]::Vector{Int64},
        :increase_level_adapt => [[502]]::Vector{Vector{Int64}},
        :increase_dims_adapt => [[2 0 0 0 0]]::Vector{Array{Int64,2}},
        :new_bounds_weight_up => [.3 .4 .5 .0 .0]::Array{Float64,2},
        :new_bounds_weight_down => [.1 .3 .5 .0 .5]::Array{Float64,2},
        :load => false::Bool,
        :time_horizon => 600::Int64,
        :sim_length => 101::Int64,
        :perfect_info => false::Bool,
        :learn_e => true::Bool,
        :robust => false::Bool,
        :theta => 3.9::Float64,
        :damages => :base::Symbol,
        :num_runs => 1000::Int64,
        :nqnodes => 11::Int64,
        :smax => [0. 0. ; 0. 0.]::Array{Float64,2},
        :smin => [0. 0. ; 0. 0.]::Array{Float64,2})



    # Solve the model
    space, c_store, s, mparams, opts, smax, smin = @time compute_value_function(inputs)

    # Save variables
    bson("results/learning_results_adapt_$adapt_iters.bson",
        Dict{String, Any}("smax" => smax, "smin" => smin))


end
