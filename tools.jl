####################################################
# Extract key/value combinations from a saved JLD dictionary
function extract(d)
    """
    Extracts variables in a dictionary into the workspace
    """
    expr = quote end
    for (k, v) in d
        push!(expr.args, :($(Symbol(k)) = $v))
    end
    eval(expr)
    return
end

####################################################
# Reduces the size of the variable dictionary to time t
function reduce_dict(exog_states, node)
    """
    Pulls out the current time exogenous variables
    """
    exog_states_t = Dict{Symbol,Float64}()

    for (key,value) in exog_states
        exog_states_t[key] = exog_states[key][node]
    end

    return exog_states_t

end

####################################################
# Gets bounds for simulated trajectories
function get_bounds(state, percentile)
"""
Recovers percentile bounds for simulated state paths
"""
    out = vcat([[quantile(hcat(state...)[row, :], percentile) quantile(hcat(state...)[row, :], 1 - percentile)] for row = 1:size(hcat(state...), 1)]...)
    return (out[:, 1], out[:, 2])
end


####################################################
# Extracts data from saved runs for use in welfare calculations
function extract_welfare_data(saved_data)
    """
    Pull out approximation space, coefficients, initial state, and parameters from
    a saved model
    """
    extract(saved_data)
    model = space
    coeff = c_store[1]
    if space[:d] < 4
        initial_state = [mparams[:kstart], mparams[:Mstart], mparams[:lossstart]]
    else
        initial_state = [mparams[:kstart], mparams[:Mstart], mparams[:expstart], mparams[:varstart], mparams[:lossstart]]
    end

    exog_states = simulate_exog_vars(mparams)

    return model, coeff, initial_state, mparams, exog_states
end

####################################################
# Compares ex ante welfare between two saved models
function ex_ante_welfare(model_1, model_2)
    """
    Compare welfare in terms of bge and pv lump sum
    """
    space_1, coeff_1, initial_state_1, mparams_1, exog_states = extract_welfare_data(model_1)
    space_2, coeff_2, initial_state_2, mparams_2, exog_states = extract_welfare_data(model_2)

    # Balanced growth equivalent
    bge = (-100*(1 .- (funeval(coeff_2, space_2, initial_state_2)[1].*mparams_2[:scaling_factor]/
        (funeval(coeff_1, space_1, initial_state_1)[1].*mparams_1[:scaling_factor]))^(1/(1-2))))[1]

    # Marginal utility function
    MU(x,t) = x.^(mparams[:rho] - 1)/mparams_1[:scaling_factor]

    # Lump sum benefit in 2005 (billion $)
    # -(V_1-V_2)/(MU)
    # A_0 L_0 adjusts MU from effective terms into real terms
    lump = (-(funeval(coeff_1, space_1, initial_state_1)[1].*mparams_1[:scaling_factor] .-
        funeval(coeff_2, space_2, initial_state_2)[1].*mparams_2[:scaling_factor])./
        MU(consumption[1], 1).*1e3.*(mparams_1[:A0].*mparams_1[:L0]))[1]
    return bge, lump
end

####################################################
# Computes ex-post welfare along a set of simulated trajectories
function ex_post_welfare(model, horizons, vars_in, mparams_in)
    """
    Computes ex-post sum of utility
    """
    # Extract consumption paths
    extract(model)
    cons = hcat(consumption...)
    cons = cons[:, 1:mparams_in[:num_runs]]

    # Present value utility fct in non-effective terms
    util_fct(x, t) = prod(vars_in[:betaeff][1:t]).*(x.^mparams_in[:rho])./mparams_in[:rho]/mparams[:scaling_factor]

    # Build utility array
    util = hcat([util_fct(cons[t, :], t) for t = 1:size(cons, 1)]...)'

    # Sum up over horizon length and take average utility across simulations
    avg_util = Vector{Float64}(undef, length(horizons))

    for (h_index, horizon) in enumerate(horizons)
        avg_util[h_index] = mean(sum(util[1:horizon, :], dims = 1))
    end

    return avg_util

end
