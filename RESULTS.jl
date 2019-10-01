function generate_results()
"""
Generates the results for the paper
"""

    ##################################
    ##################################
    # Load base models and tools
    ##################################
    ##################################

    uncert = BSON.load("results/uncert_results.bson")
    learn = BSON.load("results/learning_results_adapt_20.bson")
    rc = BSON.load("results/rc_results_3.9.bson")
    rcl = BSON.load("results/rcl_results_3.9_adapt_20.bson")
    @everywhere include("tools.jl")


    ##################################
    ##################################
    # Figures 5a and 7
    ##################################
    ##################################

    println("Generating data for Figures 5a and 7.")

    # Pull out tax components
    uncert_tax = Dict{Symbol,Vector}()
    learn_tax = Dict{Symbol,Vector}()
    rc_tax = Dict{Symbol,Vector}()
    rcl_tax = Dict{Symbol,Vector}()
    for (key,value) in uncert["tax_channels"]
            uncert_tax[key] = vec(uncert["tax_channels"][key])
            learn_tax[key] = vec(learn["tax_channels"][key])
            rc_tax[key] = vec(rc["tax_channels"][key])
            rcl_tax[key] = vec(rcl["tax_channels"][key])
    end

    ### uncertainty
    uncert_df = convert(DataFrame, uncert_tax)
    uncert_df[:, end+1] = "Uncertainty"
    uncert_df[:, end+1] = 2005:2005+size(uncert_df, 1)-1
    uncert_t = convert(Matrix, uncert_df)

    ### learning
    learn_df = convert(DataFrame, learn_tax)
    learn_df[:, end+1] = "Learning"
    learn_df[:, end+1] = 2005:2005+size(learn_df, 1)-1
    learn_t = convert(Matrix, learn_df)

    ### robust control
    rc_df = convert(DataFrame, rc_tax)
    rc_df[:, end+1] = "Robust Control"
    rc_df[:, end+1] = 2005:2005+size(rc_df, 1)-1
    rc_t = convert(Matrix, rc_df)

    ### robust control + learning
    rcl_df = convert(DataFrame, rcl_tax)
    rcl_df[:, end+1] = "RC + Learning"
    rcl_df[:, end+1] = 2005:2005+size(rcl_df, 1)-1
    rcl_t = convert(Matrix, rcl_df)

    figure_5a_7 = vcat(uncert_t, learn_t, rc_t, rcl_t)
    figure_5a_7 = convert(DataFrame, figure_5a_7)
    names!(figure_5a_7, [:ce_tax, :exp_tax, :learning_insurance,
        :output_insurance, :precaution, :robust_insurance,
        :scc_direct, :smoothing, :tax_lower, :tax_upper, :unc_adjust,
        :type, :year])

    CSV.write("generate_plots/data/figure_5a_and_7.csv", figure_5a_7)

    ##################################
    ##################################
    # Figures 5b, 5c, and 5d
    ##################################
    ##################################

    println("Generating data for Figures 5a, 5b, and 5c.")

    ### Load in files for specific damage parameters
    for run in zip(["d1_0.01_d2_1.88", "d1_0.00556486_d2_3.0", "d1_0.01_d2_3.0"], ["5b", "5c", "5d"])

        learn_alt = BSON.load("results/learn_results_dam_" * run[1] * ".bson")
        uncert_alt = BSON.load("results/uncert_results_dam_" * run[1] * ".bson")
        rcl_alt = BSON.load("results/rcl_results_dam_" * run[1] * ".bson")
        rc_alt = BSON.load("results/rc_results_dam_" * run[1] * ".bson")

        uncert_tax = Dict{Symbol,Vector}()
        learn_tax = Dict{Symbol,Vector}()
        rc_tax = Dict{Symbol,Vector}()
        rcl_tax = Dict{Symbol,Vector}()

        for (key, value) in uncert_alt["tax_channels"]
            if (key != :robust_insurance2)
                uncert_tax[key] = vec(uncert_alt["tax_channels"][key])
                learn_tax[key] = vec(learn_alt["tax_channels"][key])
                rc_tax[key] = vec(rc_alt["tax_channels"][key])
                rcl_tax[key] = vec(rcl_alt["tax_channels"][key])
            end
        end

        ### uncertainty
        uncert_df = convert(DataFrame, uncert_tax)
        uncert_df[!, end+1] .= "Uncertainty"
        uncert_df[:, end+1] = 2005:2005+size(uncert_df, 1)-1
        uncert_t = convert(Matrix, uncert_df)

        ### learning
        learn_df = convert(DataFrame, learn_tax)
        learn_df[!, end+1] .= "Learning"
        learn_df[:, end+1] = 2005:2005+size(learn_df, 1)-1
        learn_t = convert(Matrix, learn_df)

        ### robust control
        rc_df = convert(DataFrame, rc_tax)
        rc_df[!, end+1] .= "Robust Control"
        rc_df[:, end+1] = 2005:2005+size(rc_df, 1)-1
        rc_t = convert(Matrix, rc_df)

        ### robust control + learning
        rcl_df = convert(DataFrame, rcl_tax)
        rcl_df[!, end+1] .= "RC + Learning"
        rcl_df[:, end+1] = 2005:2005+size(rcl_df, 1)-1
        rcl_t = convert(Matrix, rcl_df)

        figure_5bcd = vcat(uncert_t, learn_t, rc_t, rcl_t)
        figure_5bcd = convert(DataFrame, figure_5bcd)
        figure_5bcd = figure_5bcd[:, [7, 12, 13]]
        names!(figure_5bcd, [:scc_direct, :type, :year])

        CSV.write("generate_plots/data/figure_" * run[2] * ".csv", figure_5bcd)
    end

    ##################################
    ##################################
    # Figures 6a and 6b
    ##################################
    ##################################

    println("Generating data for Figures 6a and 6b.")

    loaded_results = Vector(undef, 8)
    thetas = [6.0, 8.0, 10.0, sqrt(10.)*10., 100.0, sqrt(10.)*100., 1000.0]

    loaded_results[1] = rc
    figure_6a = DataFrame(tax = loaded_results[1]["tax_channels"][:scc_direct][1],
                           penalty_parameter = loaded_results[1]["mparams"][:theta_robust])


    for (index, i) in enumerate(thetas)
        loaded_results[index+1] =
            BSON.load("results/rc_results_$(i).bson")
        push!(figure_6a, [loaded_results[index+1]["tax_channels"][:scc_direct][1], i])
    end

    CSV.write("generate_plots/data/figure_6a.csv", figure_6a)

    loaded_results = Vector(undef, 8)

    loaded_results[1] = rcl
    figure_6b = DataFrame(tax = loaded_results[1]["tax_channels"][:scc_direct][1],
                           penalty_parameter = loaded_results[1]["mparams"][:theta_robust])

    for (index, i) in enumerate(thetas)
        loaded_results[index+1] =
            BSON.load("results/rcl_results_$(i)_adapt_20.bson")
        push!(figure_6b, [loaded_results[index+1]["tax_channels"][:scc_direct][1], i])
    end

    CSV.write("generate_plots/data/figure_6b.csv", figure_6b)


    ##################################
    ##################################
    # Figure 8
    ##################################
    ##################################

    println("Generating data for Figure 8.")

    # Extract uncertanty to get mparams for simulating trajectories
    extract(uncert)
    mparams_in = mparams
    mparams_in[:num_runs] = 10000
    mparams_in[:sim_length] = 201
    exog_states = simulate_exog_vars(mparams)

    # Load different model-damage function combinations, compute ex-post welfare
    model_welfare = Array{Vector}(undef, 3, 4)
    models = Array{Dict}(undef, 3, 4)
    @everywhere include("tools.jl")

    for (r_index,run_type) in enumerate(["weitzman", "dietz", "extreme"])

        for (m_index, model_type) in
            enumerate(["uncert_results_dam_misspec_",
                "rc_results_dam_misspec_",
                "rcl_results_dam_misspec_",
                "learn_results_dam_misspec_"])

            println([r_index m_index])

            models[r_index,m_index] = BSON.load("results/" * model_type * run_type * ".bson")
            println(model_type * run_type)
            model_welfare[r_index,m_index] = ex_post_welfare(models[r_index, m_index], [50, 100, 150, 200], exog_states, mparams_in)

        end

    end

    # initialize state and arrays
    extract(uncert)
    coeff = c_store[1]
    if space[:d] < 4
        initial_state = [mparams[:kstart], mparams[:Mstart], mparams[:lossstart]]
    else
        initial_state = [mparams[:kstart], mparams[:Mstart], mparams[:expstart], mparams[:varstart], mparams[:lossstart]]
    end

    lump = Array{Vector}(undef, 3, 4)

    # marginal utility for translating into dollar terms
    MU(x) = x.^(mparams[:rho] - 1.)/mparams[:scaling_factor]
    dollars_translate = exog_states[:At][1].*exog_states[:Lt][1]./MU(consumption[1][1])

    # compute lump sum welfare
    for model_type = 2:4
        for run_type = 1:3

            # Lump sum
            lump[run_type,model_type-1] = 1e3*vec(-(model_welfare[run_type, 1] .-
                model_welfare[run_type,model_type].*models[run_type, model_type]["mparams"][:scaling_factor])).*dollars_translate

        end
    end


    uncert_tax = Dict{Symbol,Vector}()
    learn_tax = Dict{Symbol,Vector}()
    rc_tax = Dict{Symbol,Vector}()
    rcl_tax = Dict{Symbol,Vector}()
    for (key,value) in uncert["tax_channels"]
        if (key != :robust_insurance2)
            uncert_tax[key] = vec(uncert["tax_channels"][key])
            learn_tax[key] = vec(learn["tax_channels"][key])
            rc_tax[key] = vec(rc["tax_channels"][key])
            rcl_tax[key] = vec(rcl["tax_channels"][key])
        end

    end

    ### learning
    l_out = Dict{Symbol,Vector}()
    l_out[:weitz] = lump[1, 3]
    pushfirst!(l_out[:weitz], 0)
    l_out[:dietz] = lump[2, 3]
    pushfirst!(l_out[:dietz], 0)
    l_out[:extreme] = lump[3, 3]
    pushfirst!(l_out[:extreme], 0)
    l_df = convert(DataFrame, l_out)
    l_df[:, end+1] = "Learning"
    l_df[:, end+1] = (2005:50:2205) .- 2005
    l_df = convert(Matrix, l_df)

    ### robust control
    rc_out = Dict{Symbol,Vector}()
    rc_out[:weitz] = lump[1, 1]
    pushfirst!(rc_out[:weitz], 0)
    rc_out[:dietz] = lump[2, 1]
    pushfirst!(rc_out[:dietz], 0)
    rc_out[:extreme] = lump[3, 1]
    pushfirst!(rc_out[:extreme], 0)
    rc_df = convert(DataFrame, rc_out)
    rc_df[:, end+1] = "Robust Control"
    rc_df[:, end+1] = (2005:50:2205) .- 2005
    rc_df = convert(Matrix, rc_df)
    rc_out = Dict{Symbol,Vector}()

    ### robust control + learning
    rcl_out = Dict{Symbol,Vector}()
    rcl_out[:weitz] = lump[1, 2]
    pushfirst!(rcl_out[:weitz], 0)
    rcl_out[:dietz] = lump[2, 2]
    pushfirst!(rcl_out[:dietz], 0)
    rcl_out[:extreme] = lump[3, 2]
    pushfirst!(rcl_out[:extreme], 0)
    rcl_df = convert(DataFrame, rcl_out)
    rcl_df[:, end+1] = "RC + Learning"
    rcl_df[:, end+1] = (2005:50:2205) .- 2005
    rcl_df = convert(Matrix, rcl_df)

    figure_8 = vcat(l_df, rcl_df, rc_df)
    figure_8 = convert(DataFrame, figure_8)
    names!(figure_8, [:dietz, :extreme, :weitzman, :type, :year])

    CSV.write("generate_plots/data/figure_8.csv", figure_8)

    ##################################
    ##################################
    # Table 2
    ##################################
    ##################################

    println("Generating data for Table 2.")

    table_2_mean = DataFrame(tax_2055 = Vector{Int64}(undef, 4),
                            tax_2105 = Vector{Int64}(undef, 4),
                            co2_2105 = Vector{Int64}(undef, 4),
                            temperature_2105 = Vector{Float64}(undef, 4),
                            framework = ["uncertainty", "learning", "robust control", "robust control + learning"],
                            type = "mean")
    table_2_5th = DataFrame(tax_2055 = Vector{Int64}(undef, 4),
                            tax_2105 = Vector{Int64}(undef, 4),
                            co2_2105 = Vector{Int64}(undef, 4),
                            temperature_2105 = Vector{Float64}(undef, 4),
                            framework = ["uncertainty", "learning", "robust control", "robust control + learning"],
                            type = "5th percentile")
    table_2_95th = DataFrame(tax_2055 = Vector{Int64}(undef, 4),
                            tax_2105 = Vector{Int64}(undef, 4),
                            co2_2105 = Vector{Int64}(undef, 4),
                            temperature_2105 = Vector{Float64}(undef, 4),
                            framework = ["uncertainty", "learning", "robust control", "robust control + learning"],
                            type = "95th percentile")

    for (idx, model) in enumerate([uncert, learn, rc, rcl])

        # co2: 1 ppm / 2.12 gigatons of carbon
        co2_bounds = get_bounds(model["co2"], .05)./2.12
        table_2_5th.co2_2105[idx] = round(Int, co2_bounds[1][end])
        table_2_95th.co2_2105[idx] = round(Int, co2_bounds[2][end])
        table_2_mean.co2_2105[idx] = round(Int, mean(hcat(model["co2"]...), dims = 2)[end]./2.12)

        # temperature: mparams[:ccr] translates cumulative emissions to temperature
        temp_bounds = get_bounds(model["co2"], .05).*mparams[:ccr]
        table_2_5th.temperature_2105[idx] = round(temp_bounds[1][end], digits = 2)
        table_2_95th.temperature_2105[idx] = round(temp_bounds[2][end], digits = 2)
        table_2_mean.temperature_2105[idx] = round(mean(hcat(model["co2"]...), dims = 2)[end].*mparams[:ccr], digits = 2)

        # tax
        tax_bounds = get_bounds(model["channels_out_samples"][:scc_direct], .05)
        table_2_5th.tax_2055[idx] = round(Int, tax_bounds[1][51])
        table_2_95th.tax_2055[idx] = round(Int, tax_bounds[2][51])
        table_2_5th.tax_2105[idx] = round(Int, tax_bounds[1][end])
        table_2_95th.tax_2105[idx] = round(Int, tax_bounds[2][end])
        tax_mean = mean(hcat(model["channels_out_samples"][:scc_direct]...), dims = 2)
        table_2_mean.tax_2055[idx] = round(Int, tax_mean[51])
        table_2_mean.tax_2105[idx] = round(Int, tax_mean[end])

    end

    # aggregate and order table for writing to csv
    table_2 = vcat(table_2_mean, table_2_5th, table_2_95th)


    CSV.write("generate_plots/data/table_2.csv", table_2)


    ##################################
    ##################################
    # Table 3
    ##################################
    ##################################

    println("Generating data for Table 3.")

    # compute lump sum and balanced growth equivalent welfare gains
    gains_learn = ex_ante_welfare(uncert, learn)
    gains_rc = ex_ante_welfare(uncert, rc)
    gains_rcl = ex_ante_welfare(uncert, rcl)

    # Notes:
    # 1) lump_sum is already in billions of 2005 dollars
    # 2) 6.514 is 2005 population in billions so per capita is in dollars
    # 3) bge is in percent, i.e. 1.5 = 1.5%
    table_3 = DataFrame(lump_sum_2005 = [gains_learn[2], gains_rc[2], gains_rcl[2]],
                        per_capita_2005 = [gains_learn[2], gains_rc[2], gains_rcl[2]]./6.514,
                        bge_gain = [gains_learn[1], gains_rc[1], gains_rcl[1]],
                        framework = ["learning", "robust control", "robust control + learning"])

    CSV.write("generate_plots/data/table_3.csv", table_3)



    ##################################
    ##################################
    # Figure A1
    ##################################
    ##################################

    println("Generating data for Figure A1.")

    # Initial level of cumulative emissions
    cumul_emissions = 500.000

    # Annual emissions along the DICE 2016 optimal trajectory (from DICE 2016 spread sheet)
    flow_emissions_dice = [0 38.340 35.402 37.142 38.557 39.604 40.250 40.470 40.245 39.563 38.416 36.802 34.725 32.191 29.208 25.790 21.950 17.705 13.072 8.066]*5/3.666
    flow_emissions = vcat(repeat(flow_emissions_dice, 5)...)/5

    # 1% increase in cumulative CO2 each year
    flow_emissions_1p = similar(flow_emissions_dice)
    flow_emissions_1p .= 1.01

    # Cumulative annual emissions along DICE optimal
    cumul_emissions = cumsum(flow_emissions) .+ cumul_emissions

    # Cumulative annual emissions along 1% increase
    cumul_emissions_1p = cumprod(vcat(repeat(flow_emissions_1p, 5)...)).*cumul_emissions[1]
    pushfirst!(cumul_emissions_1p, 500.)

    # Put into 5 year timestep for DICE
    flow_emissions_1p_dice = similar(flow_emissions_dice)
    flow_emissions_1p_dice .= 1.01^5
    cumul_emissions_1p_dice = vec(cumprod(flow_emissions_1p_dice, dims = 2).*cumul_emissions[1])
    pushfirst!(cumul_emissions_1p_dice, 500.)
    flow_emissions_1p_dice = vec(flow_emissions_1p_dice .- 1.).*cumul_emissions_1p_dice[1:end-1]

    # Cumulative carbon temperature trajectory
    transient_climate_response = 0.0016
    ccr_temp = transient_climate_response*cumul_emissions
    ccr_temp = [ccr_temp (2005:2005+length(ccr_temp)-1)]
    ccr_temp_1p = transient_climate_response*cumul_emissions_1p
    ccr_temp_1p = [ccr_temp_1p (2005:2005+length(ccr_temp_1p)-1)]

    # DICE temperature trajectory
    dice_carbon = [.88 .196 0.; .12 .797 .001465; 0 .007 .998535]
    forcing_per_2xco2 = 3.681
    Mpre = 588.
    c1 = 0.101
    c3 = 0.088
    c4 = 0.025
    doubling = 3.1
    exog_force(t) = 0.5 + min((1/17)*(1. - 0.5)*(t-1), 0.5)

    co2 = Matrix{Float64}(undef, 3, 21)
    dice_temperature_opt = Matrix{Float64}(undef, 3, 21)
    dice_temperature_opt[3, :] = 2015:5:2115
    co2[:, 1] = [851.; 460.; 1740.]
    dice_temperature_opt[1:2, 1] = [0.85; 0.007]

    for d = 2:20

        #CO2, emissions are 10 times the emissions from the middle of the decade
        co2[:, d] = dice_carbon*co2[:, d-1] + [flow_emissions_dice[d]; 0; 0]

        # Forcing
        forcing = forcing_per_2xco2*log(co2[1, d]/Mpre)/log(2) + exog_force(d)

        # Temperature
        dice_temperature_opt[1, d] = dice_temperature_opt[1, d-1] +
            c1*(forcing - (forcing_per_2xco2/doubling)*dice_temperature_opt[1, d-1] +
            c3*(dice_temperature_opt[2, d-1] - dice_temperature_opt[1, d-1]))

        dice_temperature_opt[2, d] = (1 - c4)*dice_temperature_opt[2, d-1] + c4*dice_temperature_opt[1, d-1]

    end


    dice_temperature_opt = transpose(dice_temperature_opt)

    co2 = Matrix{Float64}(undef, 3, 21)
    dice_temperature_1p = Matrix{Float64}(undef, 3, 21)
    dice_temperature_1p[3, :] = 2015:5:2115
    co2[:, 1] = [851.; 460.; 1740.]
    dice_temperature_1p[1:2, 1] = [0.85; 0.007]

    for d = 2:20

        #CO2, emissions are 10 times the emissions from the middle of the decade
        co2[:, d] = dice_carbon*co2[:, d-1] + [flow_emissions_1p_dice[d]; 0; 0]

        # Forcing
        forcing = forcing_per_2xco2*log(co2[1, d]/Mpre)/log(2) + exog_force(d)

        # Temperature
        dice_temperature_1p[1, d] = dice_temperature_1p[1, d-1] +
            c1*(forcing - (forcing_per_2xco2/doubling)*dice_temperature_1p[1, d-1] +
            c3*(dice_temperature_1p[2, d-1] - dice_temperature_1p[1, d-1]))

        dice_temperature_1p[2, d] = (1 - c4)*dice_temperature_1p[2, d-1] + c4*dice_temperature_1p[1, d-1]

    end


    dice_temperature_1p = transpose(dice_temperature_1p)

    figure_a1_dice = DataFrame(year = dice_temperature_1p[:, 3],
                        temp_opt = dice_temperature_opt[:, 1],
                        temp_1p = dice_temperature_1p[:, 1])

    figure_a1_ccr = DataFrame(year = ccr_temp[11:end, 2],
                        ccr_opt = ccr_temp[11:end, 1],
                        ccr_1p = ccr_temp_1p[11:end-1, 1])

    CSV.write("generate_plots/data/figure_a1_dice.csv", figure_a1_dice)
    CSV.write("generate_plots/data/figure_a1_ccr.csv", figure_a1_ccr)


    ##################################
    ##################################
    # Figure A2
    ##################################
    ##################################

    println("Generating data for Figure A2.")

    runs_func(x, n) = x*ones(n, 1)

    bounds_main = learn
    bounds_previous_iter = BSON.load("results/learning_results_adapt_19.bson")

    # Code to get average relative change on capital lower bound (< 1%):
    # mean((bounds_main["smin"][1:300,1] - bounds_previous_iter["smin"][1:300,1])./bounds_previous_iter["smin"][1:300,1])

    extract(bounds_previous_iter)
    smax_previous_iter = bounds_previous_iter["smax"]
    smin_previous_iter = bounds_previous_iter["smin"]
    smax_previous_iter = convert(Matrix{Any}, [smax_previous_iter[1:101, :] similar(smax_previous_iter[1:101, 1:3])])
    smin_previous_iter = convert(Matrix{Any}, [smin_previous_iter[1:101, :] similar(smin_previous_iter[1:101, 1:3])])
    smax_previous_iter[:, end] .= "smax"
    smin_previous_iter[:, end] .= "smin"
    smax_previous_iter[:, end-1] = 2005:size(smax_previous_iter, 1) + 2005 - 1
    smin_previous_iter[:, end-1] = 2005:size(smin_previous_iter, 1) + 2005 - 1
    smax_previous_iter[:, end-2] .= "previous_iter"
    smin_previous_iter[:, end-2] .= "previous_iter"

    extract(bounds_main)
    smax = convert(Matrix{Any}, [bounds_main["smax"][1:101, :] similar(bounds_main["smax"][1:101, 1:3])])
    smin = convert(Matrix{Any}, [bounds_main["smin"][1:101, :] similar(bounds_main["smin"][1:101, 1:3])])
    smax[:, end] .= "smax"
    smin[:, end] .= "smin"
    smax[:, end-1] = 2005:size(smax, 1) + 2005 - 1
    smin[:, end-1] = 2005:size(smin, 1) + 2005 - 1
    smax[:, end-2] .= "main"
    smin[:, end-2] .= "main"

    capital = vcat(hcat(bounds_main["capital"]...)[1:101, 1:1000]...)
    capital = convert(Matrix{Any}, [capital repeat(similar(capital), 1, 3)])
    capital[:, end] .= "capital"
    capital[:, end-1] = repeat(2005:size(smax, 1) + 2005 - 1, 1000)
    capital[:, end-2] = vcat([runs_func(run, size(smax, 1)) for run = 1:1000]...)

    co2 = vcat(hcat(bounds_main["co2"]...)[1:101, 1:1000]...)
    co2 = convert(Matrix{Any}, [co2 repeat(similar(co2), 1, 3)])
    co2[:, end] .= "co2"
    co2[:, end-1] = repeat(2005:size(smax, 1) + 2005 - 1, 1000)
    co2[:, end-2] = vcat([runs_func(run, size(smax, 1)) for run = 1:1000]...)

    damage = vcat(hcat(bounds_main["damage"]...)[1:101, 1:1000]...)
    damage = convert(Matrix{Any}, [damage repeat(similar(damage), 1, 3)])
    damage[:, end] .= "damage"
    damage[:, end-1] = repeat(2005:size(smax, 1) + 2005 - 1, 1000)
    damage[:, end-2] = vcat([runs_func(run, size(smax, 1)) for run = 1:1000]...)

    prior_loc = vcat(hcat(bounds_main["prior_loc"]...)[1:101, 1:1000]...)
    prior_loc = convert(Matrix{Any}, [prior_loc repeat(similar(prior_loc), 1, 3)])
    prior_loc[:, end] .= "prior_loc"
    prior_loc[:, end-1] = repeat(2005:size(smax, 1) + 2005 - 1, 1000)
    prior_loc[:, end-2] = vcat([runs_func(run, size(smax, 1)) for run = 1:1000]...)

    prior_scale = vcat(hcat(bounds_main["prior_scale"]...)[1:101, 1:1000]...)
    prior_scale = convert(Matrix{Any}, [prior_scale repeat(similar(prior_scale), 1, 3)])
    prior_scale[:, end] .= "prior_scale"
    prior_scale[:, end-1] = repeat(2005:size(smax, 1) + 2005 - 1, 1000)
    prior_scale[:, end-2] = vcat([runs_func(run, size(smax, 1)) for run = 1:1000]...)

    figure_a2 = vcat(smax, smin, smax_previous_iter, smin_previous_iter)
    figure_a2_states = vcat(capital, co2, damage, prior_loc, prior_scale)

    figure_a2 = convert(DataFrame, figure_a2)
    figure_a2_states = convert(DataFrame, figure_a2_states)

    names!(figure_a2, [:capital, :co2, :loc, :scale, :damage, :it, :year, :type])
    names!(figure_a2_states, [:value, :run, :year, :state])

    CSV.write("generate_plots/data/figure_a2_bounds.csv", figure_a2)
    CSV.write("generate_plots/data/figure_a2_states.csv", figure_a2_states)


    ##################################
    ##################################
    # Table A1
    ##################################
    ##################################

    table_a1 = DataFrame(A0 = mparams[:A0],
                        gA0 = mparams[:gA0],
                        delta_A = mparams[:dA],
                        L_0 = mparams[:L0],
                        L_inf = mparams[:Linf],
                        delta_L = mparams[:dL],
                        sigma_0 = mparams[:sigma0],
                        g_sigma0 = mparams[:gsigma0],
                        delta_sigma = mparams[:dsigma],
                        a_0 = mparams[:a0],
                        a_1 = mparams[:a1],
                        a_2 = mparams[:a2],
                        g_psi = mparams[:gPsi],
                        B_0 = mparams[:B0],
                        g_B = mparams[:gB],
                        kappa = mparams[:kappa],
                        delta_k = mparams[:deltak],
                        E_0 = mparams[:Mstart],
                        rho = mparams[:delta],
                        eta = 1 - mparams[:rho], # mparams[:rho] is old notation for (1-eta)
                        zeta = mparams[:ccr],
                        k_0 = mparams[:kstart],
                        mu_0 = mparams[:expstart],
                        cap_sigma_0 = mparams[:varstart],
                        joint_d1_omega_loc = mparams[:coeff_loc], # d1 and omega are joined into one distribution for efficiency, initialization.jl builds this on lines 72-72
                        joint_d1_omega_scale = mparams[:coeff_scale])

    CSV.write("generate_plots/data/table_a1.csv", table_a1)


    ##################################
    ##################################
    # Table A4
    ##################################
    ##################################

    println("Generating data for Table A4.")

    #############################
    ### First column: Uncertainty

    main_approx = uncert
    approx_1 = BSON.load("results/uncert_results_coll_1.bson")
    approx_2 = BSON.load("results/uncert_results_coll_2.bson")
    approx_3 = BSON.load("results/uncert_results_coll_3.bson")
    approx_4 = BSON.load("results/uncert_results_quad.bson")
    approx_5 = BSON.load("results/uncert_results_wide.bson")
    approx_6 = BSON.load("results/uncert_results_coll_4.bson")

    tax_store = Vector{Array}(undef, 7)
    cons_store = Vector{Array}(undef, 7)
    for (idx, type1) in enumerate([approx_1 approx_2 approx_3 approx_4 approx_5 approx_6 main_approx])
        extract(type1)
        tax_store[idx] = tax_channels[:scc_direct]
        cons_store[idx] = mean(hcat(consumption...), dims=2)
    end

    # Table output:
    # tax: tax error
    # cons: consumption error
    # mean: mean relative error
    # max: max relative error
    # coll: collocation nodes (top panel)
    # quad: quadrature (second panel)
    # domain: expand domain (third panel)
    # double coll: collocation error from increasing capital by 1 vs decreasing capital by 1 (footnote)

    table_a4_column_1 = DataFrame(tax_coll_error_mean = mean(abs.((tax_store[end] .- hcat(tax_store[1:3]...))./tax_store[end])),
                                tax_coll_error_max = maximum(abs.((tax_store[end] .- hcat(tax_store[1:3]...))./tax_store[end])),
                                tax_quad_error_mean = mean(abs.((tax_store[end] .- tax_store[4])./tax_store[end])),
                                tax_quad_error_max = maximum(abs.((tax_store[end] .- tax_store[4])./tax_store[end])),
                                tax_domain_error_mean = mean(abs.((tax_store[end] .- tax_store[5])./tax_store[end])),
                                tax_domain_error_max = maximum(abs.((tax_store[end] .- tax_store[5])./tax_store[end])),
                                tax_double_coll_error_mean = mean(abs.((tax_store[1] .- tax_store[6])./tax_store[1])),
                                tax_double_coll_error_max = maximum(abs.((tax_store[1] .- tax_store[6])./tax_store[1])),
                                cons_coll_error_mean = mean(abs.((cons_store[end] .- hcat(cons_store[1:3]...))./cons_store[end])),
                                cons_coll_error_max = maximum(abs.((cons_store[end] .- hcat(cons_store[1:3]...))./cons_store[end])),
                                cons_quad_error_mean = mean(abs.((cons_store[end] .- cons_store[4])./cons_store[end])),
                                cons_quad_error_max = maximum(abs.((cons_store[end] .- cons_store[4])./cons_store[end])),
                                cons_domain_error_mean = mean(abs.((cons_store[end] .- cons_store[5])./cons_store[end])),
                                cons_domain_error_max = maximum(abs.((cons_store[end] .- cons_store[5])./cons_store[end])),
                                cons_double_coll_error_mean = mean(abs.((cons_store[1] .- cons_store[6])./cons_store[1])),
                                cons_double_coll_error_max = maximum(abs.((cons_store[1] .- cons_store[6])./cons_store[1])))

    CSV.write("generate_plots/data/table_a4_uncert.csv", table_a4_column_1)

    #############################
    ### Second column: learning

    main_approx = learn
    approx_1 = BSON.load("results/learning_results_coll_1.bson")
    approx_2 = BSON.load("results/learning_results_coll_2.bson")
    approx_3 = BSON.load("results/learning_results_coll_3.bson")
    approx_4 = BSON.load("results/learning_results_coll_4.bson")
    approx_5 = BSON.load("results/learning_results_coll_5.bson")
    approx_6 = BSON.load("results/learning_results_quad.bson")
    approx_7 = BSON.load("results/learning_results_adapt_10.bson")
    approx_8 = BSON.load("results/learning_results_coll_6.bson")

    tax_store = Vector{Array}(undef, 9)
    cons_store = Vector{Array}(undef, 9)
    for (idx, type) in enumerate([approx_1 approx_2 approx_3 approx_4 approx_5 approx_6 approx_7 approx_8 main_approx])
        extract(type)
        tax_store[idx] = tax_channels[:scc_direct]
        cons_store[idx] = mean(hcat(consumption...), dims=2)
    end

    # Table output:
    # tax: tax error
    # cons: consumption error
    # mean: mean relative error
    # max: max relative error
    # coll: collocation nodes (top panel)
    # quad: quadrature (second panel)
    # adapt: 10 adaptive algorithms (fourth panel)
    # double coll: collocation error from increasing capital by 1 vs decreasing capital by 1 (footnote)

    table_a4_column_2 = DataFrame(tax_coll_error_mean = mean(abs.((tax_store[end] .- hcat(tax_store[1:5]...))./tax_store[end])),
                                tax_coll_error_max = maximum(abs.((tax_store[end] .- hcat(tax_store[1:5]...))./tax_store[end])),
                                tax_quad_error_mean = mean(abs.((tax_store[end] .- tax_store[6])./tax_store[end])),
                                tax_quad_error_max = maximum(abs.((tax_store[end] .- tax_store[6])./tax_store[end])),
                                tax_adapt_error_mean = mean(abs.((tax_store[end] .- tax_store[7])./tax_store[end])),
                                tax_adapt_error_max = maximum(abs.((tax_store[end] .- tax_store[7])./tax_store[end])),
                                tax_double_coll_error_mean = mean(abs.((tax_store[1] .- tax_store[8])./tax_store[1])),
                                tax_double_coll_error_max = maximum(abs.((tax_store[1] .- tax_store[8])./tax_store[1])),
                                cons_coll_error_mean = mean(abs.((cons_store[end] .- hcat(cons_store[1:5]...))./cons_store[end])),
                                cons_coll_error_max = maximum(abs.((cons_store[end] .- hcat(cons_store[1:5]...))./cons_store[end])),
                                cons_quad_error_mean = mean(abs.((cons_store[end] .- cons_store[6])./cons_store[end])),
                                cons_quad_error_max = maximum(abs.((cons_store[end] .- cons_store[6])./cons_store[end])),
                                cons_adapt_error_mean = mean(abs.((cons_store[end] .- cons_store[7])./cons_store[end])),
                                cons_adapt_error_max = maximum(abs.((cons_store[end] .- cons_store[7])./cons_store[end])),
                                cons_double_coll_error_mean = mean(abs.((cons_store[1] .- cons_store[8])./cons_store[1])),
                                cons_double_coll_error_max = maximum(abs.((cons_store[1] .- cons_store[8])./cons_store[1])))

    CSV.write("generate_plots/data/table_a4_learn.csv", table_a4_column_2)

    #############################
    ### Third column: Robust control

    main_approx = rc
    approx_1 = BSON.load("results/rc_results_coll_1.bson")
    approx_2 = BSON.load("results/rc_results_coll_2.bson")
    approx_3 = BSON.load("results/rc_results_coll_3.bson")
    approx_4 = BSON.load("results/rc_results_3.9_quad.bson")
    approx_5 = BSON.load("results/rc_results_3.9_wide.bson")
    approx_6 = BSON.load("results/rc_results_coll_4.bson")

    tax_store = Vector{Array}(undef, 7)
    cons_store = Vector{Array}(undef, 7)
    for (idx, type1) in enumerate([approx_1 approx_2 approx_3 approx_4 approx_5 approx_6 main_approx])
        extract(type1)
        tax_store[idx] = tax_channels[:scc_direct]
        cons_store[idx] = mean(hcat(consumption...), dims=2)
    end

    # Table output:
    # tax: tax error
    # cons: consumption error
    # mean: mean relative error
    # max: max relative error
    # coll: collocation nodes (top panel)
    # quad: quadrature (second panel)
    # domain: expand domain (third panel)
    # double coll: collocation error from increasing capital by 1 vs decreasing capital by 1 (footnote)

    table_a4_column_3 = DataFrame(tax_coll_error_mean = mean(abs.((tax_store[end] .- hcat(tax_store[1:3]...))./tax_store[end])),
                                tax_coll_error_max = maximum(abs.((tax_store[end] .- hcat(tax_store[1:3]...))./tax_store[end])),
                                tax_quad_error_mean = mean(abs.((tax_store[end] .- tax_store[4])./tax_store[end])),
                                tax_quad_error_max = maximum(abs.((tax_store[end] .- tax_store[4])./tax_store[end])),
                                tax_domain_error_mean = mean(abs.((tax_store[end] .- tax_store[5])./tax_store[end])),
                                tax_domain_error_max = maximum(abs.((tax_store[end] .- tax_store[5])./tax_store[end])),
                                tax_double_coll_error_mean = mean(abs.((tax_store[1] .- tax_store[6])./tax_store[1])),
                                tax_double_coll_error_max = maximum(abs.((tax_store[1] .- tax_store[6])./tax_store[1])),
                                cons_coll_error_mean = mean(abs.((cons_store[end] .- hcat(cons_store[1:3]...))./cons_store[end])),
                                cons_coll_error_max = maximum(abs.((cons_store[end] .- hcat(cons_store[1:3]...))./cons_store[end])),
                                cons_quad_error_mean = mean(abs.((cons_store[end] .- cons_store[4])./cons_store[end])),
                                cons_quad_error_max = maximum(abs.((cons_store[end] .- cons_store[4])./cons_store[end])),
                                cons_domain_error_mean = mean(abs.((cons_store[end] .- cons_store[5])./cons_store[end])),
                                cons_domain_error_max = maximum(abs.((cons_store[end] .- cons_store[5])./cons_store[end])),
                                cons_double_coll_error_mean = mean(abs.((cons_store[1] .- cons_store[6])./cons_store[1])),
                                cons_double_coll_error_max = maximum(abs.((cons_store[1] .- cons_store[6])./cons_store[1])))


    CSV.write("generate_plots/data/table_a4_rc.csv", table_a4_column_3)

    #############################
    ### Fourth column: RC+L

    main_approx = rcl
    approx_1 = BSON.load("results/rcl_results_coll_1.bson")
    approx_2 = BSON.load("results/rcl_results_coll_2.bson")
    approx_3 = BSON.load("results/rcl_results_coll_3.bson")
    approx_4 = BSON.load("results/rcl_results_coll_4.bson")
    approx_5 = BSON.load("results/rcl_results_coll_5.bson")
    approx_6 = BSON.load("results/rcl_results_3.9_quad.bson")
    approx_7 = BSON.load("results/rcl_results_3.9_adapt_10.bson")
    approx_8 = BSON.load("results/rcl_results_coll_6.bson")

    tax_store = Vector{Array}(undef, 9)
    cons_store = Vector{Array}(undef, 9)
    for (idx, type) in enumerate([approx_1 approx_2 approx_3 approx_4 approx_5 approx_6 approx_7 approx_8 main_approx])
        extract(type)
        tax_store[idx] = tax_channels[:scc_direct]
        cons_store[idx] = mean(hcat(consumption...), dims=2)
    end

    # Table output:
    # tax: tax error
    # cons: consumption error
    # mean: mean relative error
    # max: max relative error
    # coll: collocation nodes (top panel)
    # quad: quadrature (second panel)
    # adapt: 10 adaptive algorithms (fourth panel)
    # double coll: collocation error from increasing capital by 1 vs decreasing capital by 1 (footnote)

    table_a4_column_4 = DataFrame(tax_coll_error_mean = mean(abs.((tax_store[end] .- hcat(tax_store[1:5]...))./tax_store[end])),
                                tax_coll_error_max = maximum(abs.((tax_store[end] .- hcat(tax_store[1:5]...))./tax_store[end])),
                                tax_quad_error_mean = mean(abs.((tax_store[end] .- tax_store[6])./tax_store[end])),
                                tax_quad_error_max = maximum(abs.((tax_store[end] .- tax_store[6])./tax_store[end])),
                                tax_adapt_error_mean = mean(abs.((tax_store[end] .- tax_store[7])./tax_store[end])),
                                tax_adapt_error_max = maximum(abs.((tax_store[end] .- tax_store[7])./tax_store[end])),
                                tax_double_coll_error_mean = mean(abs.((tax_store[1] .- tax_store[8])./tax_store[1])),
                                tax_double_coll_error_max = maximum(abs.((tax_store[1] .- tax_store[8])./tax_store[1])),
                                cons_coll_error_mean = mean(abs.((cons_store[end] .- hcat(cons_store[1:5]...))./cons_store[end])),
                                cons_coll_error_max = maximum(abs.((cons_store[end] .- hcat(cons_store[1:5]...))./cons_store[end])),
                                cons_quad_error_mean = mean(abs.((cons_store[end] .- cons_store[6])./cons_store[end])),
                                cons_quad_error_max = maximum(abs.((cons_store[end] .- cons_store[6])./cons_store[end])),
                                cons_adapt_error_mean = mean(abs.((cons_store[end] .- cons_store[7])./cons_store[end])),
                                cons_adapt_error_max = maximum(abs.((cons_store[end] .- cons_store[7])./cons_store[end])),
                                cons_double_coll_error_mean = mean(abs.((cons_store[1] .- cons_store[8])./cons_store[1])),
                                cons_double_coll_error_max = maximum(abs.((cons_store[1] .- cons_store[8])./cons_store[1])))

    # Vector of Table A4 entries
    table_a4 = [table_a4_column_1,
                table_a4_column_2,
                table_a4_column_3,
                table_a4_column_4]

    CSV.write("generate_plots/data/table_a4_rcl.csv", table_a4_column_4)

    println("Done generating data. CSV files can be found in '/generate_plots/data'.")

end
