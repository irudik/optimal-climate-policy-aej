// Generates estimates for the damage parameters in Table 1

// Replication data for Howard and Sterner (2017)
use "10640_2017_166_MOESM10_ESM.dta", clear

// GDP Loss is defined as GDP_loss == (Y^g - Y^n)/Y^g = 1 - Y^n/Y^g
// But the Polynomial damage function is equivalent to Y^g/Y^n-1
// These are not the same!
// Need to translates GDP loss into damage function terms: damages = GDP_loss/(1-GDP_loss)

// Translates % GDP loss into damages in the 1/(1+D) set up
gen correct_d = (D_new/100)/(1 - D_new/100)

// Generated log of correct damage spec
gen log_correct = log(correct_d)

// Generate log temperature
gen logt = log(t)

// Perform regression
reg log_correct logt

// Recover estimates
local exp_mean = round(_b[logt], .01)
local exp_sd = round(_se[logt], .01)
local exp_var = round(`exp_sd'^2, .001)
local coeff_loc = round(_b[_cons], .01)
local coeff_scale = round(_se[_cons]^2, .01)
local lmean = round(exp(_b[_cons]+_se[_cons]^2/2), .01)
local lvar = round(exp(_se[_cons]^2-1)*exp(2*_b[_cons]+_se[_cons]^2), .01)
predict resid, res
sum resid
local shock_sd = round(`r(sd)', .001)
local shock_scale = round(log(`shock_sd'^2 + 1), .01)
local shock_loc = -0.5*`shock_scale'


disp "Results for parameters defined at the top of function parameterization in initialization.jl:"

// Location of coefficient
disp "The coefficient (d_1) location parameter is `coeff_loc'."

// Scale of coefficient
disp "The coefficient (d_1) scale parameter is `coeff_scale'."

// Location of coefficient
disp "The exponent (d_2) location parameter is `exp_mean'."

// Scale of coefficient
disp "The exponent (d_2) scale parameter is `exp_var'."

// Location of damage shock
disp "The damage shock (\omega) location parameter is `shock_loc'." 

// Scale of damage shock
disp "The damage shock (\omega) scale parameter is `shock_scale'." 


gen loc_param_d1_coeff = `coeff_loc'
label var loc_param_d1_coeff "Coefficient (d1) location parameter"
gen scale_param_d1_coeff = `coeff_scale'
label var scale_param_d1_coeff "Coefficient (d1) scale parameter"
gen loc_param_d2_exp = `exp_mean'
label var loc_param_d2_exp "Exponent (d2) location parameter"
gen scale_param_d2_exp = `exp_var'
label var scale_param_d2_exp "Exponent (d2) scale parameter"
gen loc_param_omega_shock = `shock_loc'
label var loc_param_omega_shock "Shock (omega) location parameter"
gen scale_param_omega_shock = `shock_scale'
label var scale_param_omega_shock "Shock (omega) scale parameter"
keep loc_param_d1_coeff-scale_param_omega_shock
keep if _n == 1
export delimited using "../generate_plots/data/table_1.csv", replace
