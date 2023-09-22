* Determine number of lags - version 2



log close
clear all



*** IMPORTANT -- You must set this to the project root folder
local project_root_directory  "INSERT ABSOLUTE PATH TO PROJECT ROOT DIRECTORY"




local output_path "`project_root_directory'pvarsoc_results/"

local input_path "`project_root_directory'data/"



* Create a log file
cd "`output_path'"
log using "pvarsoc_log.log", replace


* load the data file
cd "`input_path'"
use "project-level-data.dta", clear



* Set directory to save results, logs, and charts
cd "`output_path'"



* Define independent variables for analysis
local indepvars   p_respect_iss p_freedom_iss p_equity_iss p_broad_iss   p_power_iss p_enviro_iss 




	* Define unit_id and xtset for time series analysis
	encode project, gen(unit_id)   
	isid unit_id month
	xtset unit_id month

* Loop through each independent variable
foreach indepvar in `indepvars' {
	* Loop through each time group
	foreach time_group in "p_in_all" "p_out_a0_1" "p_out_a2_3" "p_out_a4_8" "p_out_a9up" {
		
		* Fill in gaps with zeros
		replace `time_group'= 0 if `time_group'  == .
		
		* Run pvarsoc for each independent variable
		di "-------------------"
		di "time_group == `time_group'."
		di "indepvar == `indepvar'."
		di "-------------------"
		
		di "-------------------"
		pvarsoc `time_group' `indepvar' , pvaropts(instlags(1/6)) maxlag(6)				
		di "-------------------"
				
					
					
	}
}
	

	
log close
