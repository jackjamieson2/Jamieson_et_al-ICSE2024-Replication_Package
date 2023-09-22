* Test for stationarity


* Determine number of lags



log close
clear all

*** IMPORTANT -- You must set this to the project root folder
local project_root_directory  "INSERT ABSOLUTE PATH TO PROJECT ROOT DIRECTORY"


local output_path "`project_root_directory'xtunitroot_results/"

local input_path "`project_root_directory'data/"


* Create output log
cd "`output_path'"
log using "xtunitroot_pperron.log", replace

* load the data file
cd "`input_path'"
use "project-level-data.dta", clear



* Define independent variables for analysis
local indepvars   p_respect_iss p_freedom_iss  p_broad_iss   p_equity_iss p_power_iss p_enviro_iss

* Define unit_id and xtset for time series analysis
encode project, gen(unit_id)   
isid unit_id month
xtset unit_id month
* Fill in gaps in the time series
tsfill




* Test turnover type
foreach time_group in "p_in_all" "p_out_a0_1" "p_out_a2_3" "p_out_a4_8" "p_out_a9up" {
	* Fill in gaps - Set gaps in the data to 0
	replace `time_group' = 0 if `time_group'  == .
	
	di "Variable == `time_group'"
	di "-------------------"
	xtunitroot fisher `time_group' , pperron lags(4)
	di "inverse chi-squared: `r(P)' , p = `r(p_P)'"
	di "inverse normal Z: `r(Z)' + , p = `r(p_Z)'"
} 
* end foreach time_group

	
	

	
* Test each independent variable
foreach indepvar in `indepvars' {
	* Fill in gaps - Set gaps in the data to 0
	replace `indepvar' = 0 if `indepvar'  == .
	di "Variable == `indepvar'"
	di "-------------------"
	xtunitroot fisher `indepvar', pperron lags(4)

	
	di "inverse chi-squared: `r(P)' , p = `r(p_P)'"
	di "inverse normal Z: `r(Z)' + , p = `r(p_Z)'"
} 
	
	
log close


