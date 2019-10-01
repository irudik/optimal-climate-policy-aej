##########################################################################
##########################################################################
## Reproduction code for: Optimal Climate Policy When Damages are Unknown
## Ivan Rudik
## American Economic Journal: Economic Policy
#
# Julia version: 1.1.0
# Operating System: Linux CentOS
#
# Required packages:
# BSON, Roots, DataFrames, CSV, Distributed, BasisMatrices,
# NLopt, Distributions, Dierckx, LinearAlgebra, CompEcon

# 1. All functions in MAIN_SCRIPT.jl must be called in the
# order they appear in the code
# 2. The generate_results() call on line 202 is
# what creates the final results
#########################################################################
#########################################################################

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
#!!!!!!!!!!!!!!!!!!! SOLVE MODELS !!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



##################################
##################################
# Base models
# Figures 5a, 7, A2, A3
# Tables 2, 3, A4
##################################
##################################

### Solve uncertainty framework
solve_uncert()

### Solve learning framework
solve_learn()

### Solve RC framework
solve_rc(3.9)

### Solve RC+L framework
solve_rcl(3.9)


##################################
##################################
# Base models + alternate damage parameters
# Figures 5b, 5c, 5d
##################################
##################################

simulate_alt_damage_params("results/uncert_results.bson", 0.01, 1.88)
simulate_alt_damage_params("results/uncert_results.bson", .00556486, 3.0)
simulate_alt_damage_params("results/uncert_results.bson", 0.01, 3.0)
simulate_alt_damage_params("results/learning_results_adapt_20.bson", 0.01, 1.88)
simulate_alt_damage_params("results/learning_results_adapt_20.bson", .00556486, 3.0)
simulate_alt_damage_params("results/learning_results_adapt_20.bson", 0.01, 3.0)
simulate_alt_damage_params("results/rc_results_3.9.bson", 0.01, 1.88)
simulate_alt_damage_params("results/rc_results_3.9.bson", .00556486, 3.0)
simulate_alt_damage_params("results/rc_results_3.9.bson", 0.01, 3.0)
simulate_alt_damage_params("results/rcl_results_3.9_adapt_20.bson", 0.01, 1.88)
simulate_alt_damage_params("results/rcl_results_3.9_adapt_20.bson", .00556486, 3.0)
simulate_alt_damage_params("results/rcl_results_3.9_adapt_20.bson", 0.01, 3.0)


##################################
##################################
# Alternate penalty parameter
# Figures 6a and 6b
##################################
##################################

### RC
solve_alt_penalty_parameter_rc()

### RC+L
solve_alt_penalty_parameter_rcl()


##################################
##################################
# Misspecified damage simulations
# Figure 8
##################################
##################################

simulate_misspecified_damages("results/uncert_results.bson", :weitzman)
simulate_misspecified_damages("results/uncert_results.bson", :dietz)
simulate_misspecified_damages("results/uncert_results.bson", :extreme)
simulate_misspecified_damages("results/learning_results_adapt_20.bson", :weitzman)
simulate_misspecified_damages("results/learning_results_adapt_20.bson", :dietz)
simulate_misspecified_damages("results/learning_results_adapt_20.bson", :extreme)
simulate_misspecified_damages("results/rc_results_3.9.bson", :weitzman)
simulate_misspecified_damages("results/rc_results_3.9.bson", :dietz)
simulate_misspecified_damages("results/rc_results_3.9.bson", :extreme)
simulate_misspecified_damages("results/rcl_results_3.9_adapt_20.bson", :weitzman)
simulate_misspecified_damages("results/rcl_results_3.9_adapt_20.bson", :dietz)
simulate_misspecified_damages("results/rcl_results_3.9_adapt_20.bson", :extreme)


##################################
##################################
# Previous iteration state bounds
# Figure A2
##################################
##################################

solve_learn_previous_iter()


##################################
##################################
# Error checks
# Table A4
##################################
##################################

##################################
# Collocation points: Table A4 top panel

### Uncertainty: collocation points
solve_uncert_error_coll()

### Learning: collocation points
solve_learn_error_coll()

### RC: collocation points
solve_rc_error_coll()

### RC+L: collocation points
solve_rcl_error_coll()

##################################
# Quadrature points: Table A4 second panel

### Uncertainty: quadrature points
solve_uncert(quad = 13)

### Learning: quadrature points
solve_learn(load = true, quad = 13)

### RC: quadrature points
solve_rc(3.9, quad = 13)

### RC+L: quadrature points
solve_rcl(3.9, quad = 13)

##################################
# Expand domain: Table A4 third panel

### Uncertainty: expand domain
solve_uncert(expand = 1.1)

### RC: expand domain
solve_rc(3.9, expand = 1.1)

##################################
# Reduce adaptive grid iterations: Table A4 bottom panel

### Learning: adaptive iterations
solve_learn(adapt_iters = 10)

### RC+L: adaptive iterations
solve_rcl(3.9, adapt_iters = 10)


#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!! GENERATE RESULTS !!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

generate_results()
