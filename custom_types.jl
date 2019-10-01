struct stateVariables
"""
Defines the state to be passed to the Bellman
"""
    states::Vector{Float64}
    controls::Vector{Float64}
    exog_states::Dict{Symbol,Float64}
    mparams::Dict{Symbol,Any}
    space::Dict{Symbol,Any}
    opts::Dict{Symbol,Bool}
    space_terminal::Dict{Symbol,Any}
    node::Int64
end

struct simParameters
"""
Defines the initial parameters to be passed to the simulator
"""
    states::Array{Float64}
    exog_states::Dict{Symbol,Array{Float64}}
    mparams::Dict{Symbol,Any}
    space::Dict{Symbol,Any}
    opts::Dict{Symbol,Bool}
    coefficients::Array{Vector{Float64}}
    dam_exponent::Float64
    dam_coefficient::Vector{Float64}
    smax::Array{Float64}
    smin::Array{Float64}
end

struct taxParameters
"""
Defines the parameters to be passed to the tax calculator
"""
    states::Array{Float64}
    controls::Vector{Vector{Float64}}
    exog_states::Dict{Symbol,Array{Float64}}
    mparams::Dict{Symbol,Any}
    space::Dict{Symbol,Any}
    opts::Dict{Symbol,Bool}
    coefficients::Array{Vector{Float64}}
    smax::Array{Float64}
    smin::Array{Float64}
    loc_next::Vector{Array{Float64}}
    dam_next::Vector{Array{Float64}}
end
