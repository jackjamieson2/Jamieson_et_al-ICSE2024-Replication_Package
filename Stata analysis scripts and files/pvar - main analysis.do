* Master pvar script - - June 2023

* Set colorblind friendly scheme from https://github.com/asjadnaqvi/stata-schemepack
set scheme cblind1 


log close
clear all
* Create a log file


*** IMPORTANT -- You must set this to the project root folder
local project_root_directory  "INSERT ABSOLUTE PATH TO PROJECT ROOT DIRECTORY"




local output_path "`project_root_directory'pvarsoc_results/"

local input_path "`project_root_directory'data/"


local output_path "`project_root_directory'main_results/"




local lag_selection_table "`project_root_directory'/lag_selection_table.xlsx"

* Create output log
cd "`output_path'"
log using "pvar_log.log", replace


* load the data file
cd "`input_path'"
use "project-level-data.dta", clear

* Set directory to save results, logs, and charts
cd "`output_path'"



* Define independent variables for analysis
local indepvars   p_respect_iss p_freedom_iss p_equity_iss p_broad_iss  p_power_iss p_enviro_iss 

* Define time groups (contribution length)
local time_groups "p_in_all" "p_out_a0_1" "p_out_a2_3" "p_out_a4_8" "p_out_a9up"


* Loop through each independent variable
foreach indepvar in `indepvars' {

		
	* Loop through each time_group
	foreach time_group in "`time_groups'" {
	
		
			* Look up how many lags for this item
			clear
			import excel "`lag_selection_table'", sheet("Sheet1") firstrow
			
			keep if time_group == "`time_group'"
			keep if IV == "`indepvar'"			
			local n_lags = n_lags[1]
			di "n_lags == `n_lags'."
			
			* Load the data file
			cd "`input_path'"
			use "project-level-data.dta", clear
			cd "`output_path'"
			
			* Define unit_id and xtset for time series analysis
			encode project, gen(unit_id)   
			isid unit_id month
			xtset unit_id month
			* Fill in gaps in the time series
			tsfill
			
					
			* Do the pvar and granger analayis
			
			if `n_lags' == 99 {
				di "Skipping `indepvar' / `action_verb' / `time_group' because the model did not meet requirements or is not applicable  "
			}
			else {
				di "-------------------"
				di "indepvar == `indepvar'."
				di "time_group == `time_group'."
				di "n_lags == `n_lags'."
				di "-------------------"
				
				local depvar "`time_group'"
		
				

				pvar `depvar' `indepvar', fod instlags(1/8) gmmstyle vce(robust) lags(`n_lags') 
				pvarstable, graph
				graph export "stable-`indepvar'-`action_verb'-`time_group'.pdf", replace
				pvargranger
				matlist r(pgstats)
				
				
				* Chart 1: Val --> Migration (single chart)
				pvarirf, oirf mc(200) byoption(yrescale) step(8) porder(`indepvar' `depvar') impulse(`indepvar') response(`depvar') legend(size(large)) subtitle(, size(large)) ylabel(, labsize(large)) xlabel(, labsize(large))  xtitle("Months after impulse", size(large))
				graph export "irf-`indepvar'-`action_verb'-`time_group'-Val-->Mig.pdf", replace

				* Chart 2: Migration --> Val  (single chart)
				pvarirf, oirf mc(200) byoption(yrescale) step(8) porder(`depvar' `indepvar')  impulse(`depvar') response(`indepvar') legend(size(large)) subtitle(, size(large)) ylabel(, labsize(large)) xlabel(, labsize(large))  xtitle("Months after impulse", size(large))
				graph export "irf-`indepvar'-`action_verb'-`time_group'-Mig-->Val.pdf", replace

				
				
				
			}
			* end if n_lags !=99

	}
	* end foreach time_group
}
* end foreach indepvar



log close





