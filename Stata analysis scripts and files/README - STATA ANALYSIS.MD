# Overview
This file describes the contents of the folder "Stata analysis scripts and files" attached to the paper:

Jack Jamieson, Naomi Yamashita, and Eureka Foong. 2024. Predicting open source contributor turnover from value-related discussions: An analysis of GitHub issues. In 2024 IEEE/ACM 46th International Conference on Software Engineering (ICSE ’24), April 14–20, 2024, Lisbon, Portugal. ACM, New York, NY, USA, 13 pages. https://doi.org/10.1145/3597503.3623340

The analysis was run using Stata Basic Edition Version 17, and requires the `pvar` package created by Abrigo and Love. This package is used to perform panel vector autoregression, granger analysis, and to generate impulse response functions.

_Installation instructions:_

To install `pvar`, type the following into Stata: `net install st0455`

The package is described in:

Abrigo, M. R. M., & Love, I. (2016). Estimation of Panel Vector Autoregression in Stata. _The Stata Journal: Promoting Communications on Statistics and Stata_, _16_(3), 778–804. [https://doi.org/10.1177/1536867X1601600314](https://doi.org/10.1177/1536867X1601600314)




# Input data
## "data/" 
Folder containing the cleaned and processed data used for Granger analysis. 

- "codebook.csv" - A codebook summarizing the data file
- "project-level-data.csv" - A .csv version of the data.
- "project-level-data.dta" - The datafile used in the analysis, saved in Stata's proprietary .dta format.

# Analysis scripts

## "xtunitroot – test for stationarity.do"
This uses the xtunitroot command to test for stationarity. As described in the paper, the Phillips-Perron test is used, since this is robust to heteroskedastic data.




## "pvarsoc – lag selection.do"

This uses the _pvarsoc_ command to identify the appropriate number of lags for each pvar model.

**Output files:**

"pvarsoc\_results/pvarsoc\_log.log" – This raw Stata output from running this script.

"lag\_selection\_table.xlsx" – Based on the Stata output, this file lists the appropriate number of lags for each model, selected using the following criteria:

- Reject all lag-counts where Hansen's overidentification restriction is not satisfied, since this indicates possible model mis-specification. This restriction is satisfied if _J pvalue \>= .05_
- Among the remaining models, select the one with the lowest Modified Bayesian Information Criterion (MBIC) score. MBIC balances high model fit with low complexity.

## "pvar – main analysis.do"
This script iterates through each model and performs the following:

- Generates a pvar model, using the number of lags specified in _"lag\_selection\_table.xlsx"_
- Checks for stability of the model
- Runs panel granger analysis
- Generates impulse response functions

**Output files:**

"main\_results/pvar\_log.log" – This raw Stata output from running this script.

"Granger results.xlsx" – The granger analysis results from the log are put into a more human readable format in this file. This file also includes the calculation of Bonferroni-corrected p-values.

Additional PDF graphs are output to "main results".  (Described in detail under "Output files" below)

# Output files

## main_results
This folder contains a log file "pvar_log.log" with the raw Stata output from the analysis, as well as PDF charts, which are named using the following convention: `[Chart type]-[Value]—[Type of turnover]-[Direction of prediction].pdf`

**Explanation of naming convention:**

Chart-type:

- Graphs beginning with "stable" show the result of stability tests. (If all the points are within the circle, then the model is stable. Stability is additionally described in the output log.)
- Graphs beginning with "irf" show Impulse Response Functions.

Value:

- p\_respect\_iss: percentage of issues related to _respectfulness_
- p\_freedom\_iss: percentage of issues related to _freedom_
- p\_equity\_iss: percentage of issues related to equity and _equality_
- p\_broad\_iss: percentage of issues related to _broadmindedness_
- p\_power\_iss: percentage of issues related to _social power_
- p\_enviro\_iss: percentage of issues related to _protecting the environment_

Type of turnover:

- p\_in\_all: percentage of new contributors (incoming turnover)
- p\_out\_a0\_1: percentage of _first-month_ contributors who left (outgoing turnover)
- p\_out\_a2\_3: percentage of _2-3 month_ contributors who left (outgoing turnover)
- p\_out\_a4\_8: percentage of _4-8 month_ contributors who left (outgoing turnover)
- p\_out\_a9up: percentage of _9+ month_ contributors who left (outgoing turnover)

Direction of turnover:

- Val--\>Mig: Does value-related discussion predict turnover?
- Mig--\>Val: Does turnover predict value-related discussion?



## Granger results.xlsx
This file summarized the Granger results from the main analysis.  Additionally, it include the calculation of Bonferroni-adjusted p-values.



## lag_selection_table.xlsx
This file lists the number of lags for each model, based on the results of "pvarsoc – lag selection.do"

These lag counts are used in the main analysis ("pvar – main analysis.do")



## pvarsoc_results/
Contains `pvarsoc_log.log`, a log file showing the raw output from the lag selection analysis in `pvarsoc -- lag selection.do`.  


