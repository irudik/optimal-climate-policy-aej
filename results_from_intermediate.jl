# Load up packages
using Roots, DataFrames, CSV, Distributed, CompEcon
@everywhere using CompEcon
@everywhere using BSON, BasisMatrices, NLopt, Distributions, Dierckx, LinearAlgebra

# Include required .jl files to bring in model functions
@everywhere include("custom_types.jl")
@everywhere include("tools.jl")
@everywhere include("maxbell.jl")
@everywhere include("simulation.jl")
@everywhere include("transitions.jl")
@everywhere include("initialization.jl")
@everywhere include("tax_calc.jl")
@everywhere include("adaptive_grid.jl")
@everywhere include("model.jl")
@everywhere include("model_solvers.jl")
@everywhere include("RESULTS.jl")

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!! GENERATE RESULTS !!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

generate_results()
