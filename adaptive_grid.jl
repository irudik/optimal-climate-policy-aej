function time_adaptive_grid(mparams, capital, co2, prior_loc, prior_scale,
    damage, loc_quad, dam_quad, states)
"""
Adapt grid to simulated trajectories: learning
"""

    smax = Array{Float64}(undef, mparams[:time_horizon] + 1, 5)
    smin = Array{Float64}(undef, mparams[:time_horizon] + 1, 5)

    smin[1:mparams[:sim_length_adapt] + 1, 1], smax[1:mparams[:sim_length_adapt] + 1, 1] = get_bounds(capital, 1e-6)
    smin[1:mparams[:sim_length_adapt] + 1, 2], smax[1:mparams[:sim_length_adapt] + 1, 2] = get_bounds(co2, 1e-6)
    smin[1:mparams[:sim_length_adapt] + 1, 3], smax[1:mparams[:sim_length_adapt] + 1, 3] = get_bounds(prior_loc, 1e-6)
    smin[1:mparams[:sim_length_adapt] + 1, 4], smax[1:mparams[:sim_length_adapt] + 1, 4] = get_bounds(prior_scale, 1e-6)
    smin[1:mparams[:sim_length_adapt] + 1, 5], smax[1:mparams[:sim_length_adapt] + 1, 5] = get_bounds(damage, 1e-6)

    # Add buffer
    smax[:, [1 2]] *= 1.05
    smax[:, 4] *= 1.1
    smin *= .95
    
    smax[:, 5] .= mparams[:initial_smax][5]

    for t = mparams[:sim_length_adapt]+1:mparams[:time_horizon]+1
        smax[t,:] = mparams[:initial_smax]
        smin[t,:] = mparams[:initial_smin]
    end

    return smax, smin

end

function time_adaptive_grid(mparams, capital, co2, damage, dam_quad, states)
"""
Adapt grid to simulated trajectories: no learning
"""

    smax = Array{Float64}(mparams[:time_horizon] + 1, 3)
    smin = Array{Float64}(mparams[:time_horizon] + 1, 3)

    smin[1:mparams[:sim_length_adapt] + 1, 1], smax[1:mparams[:sim_length_adapt] + 1, 1] = get_bounds(capital, 1e-6)
    smin[1:mparams[:sim_length_adapt] + 1, 2], smax[1:mparams[:sim_length_adapt] + 1, 2] = get_bounds(co2, 1e-6)
    smin[1:mparams[:sim_length_adapt] + 1, 3], smax[1:mparams[:sim_length_adapt] + 1, 3] = get_bounds(damage, 1e-6)

    # Add buffer
    smax[:, [1 2]] *= 1.05
    smin *= .95

    smax[:, 3] = mparams[:initial_smax][3]

    for t = mparams[:sim_length_adapt]+1:mparams[:time_horizon]+1
        smax[t, :] = mparams[:initial_smax]
        smin[t, :] = mparams[:initial_smin]
        smax[t, 3] = mparams[:initial_smax][3]
    end

    return smax, smin

end
