

*------------------------------------------------------------------------------*
* 			World Bank Service Delivery Indicator (SDI) Surveys				   *
*				Primary Health Care (PHC) Quality Index						   *
* 								Main do file
*							Created August 2025	
*					    Catherine Arsenault, GWSPH
*------------------------------------------------------------------------------*
clear all
set more off

macro drop _all

* Setting user globals
*------------------------------------------------------------------------------*
* Defining globals	
global user "/Users/catherinearsenault/Library/CloudStorage/Box-Box/"
global rawdata "World Bank SDI Analyses/Data and instruments - do not edit"
global analysis "World Bank SDI Analyses/Data for analysis"
global dofiles "World Bank SDI Analyses/Do files"
*------------------------------------------------------------------------------*

* Create the structural quality index
	run "$user/$dofiles/BT_crPHCQ_structure.do"
	
* Create the provider competence index
	run "$user/$dofiles/BT_crPHCQ_process_vig.do"
	
* Create the user experience index
	run "$user/$dofiles/BT_crPHCQ_process_ux.do"

* Create the overall PHC quality index
	run "$user/$dofiles/BT_crPHCQ_overall.do"

* Run analyses of PHC quality by sentinel PHC condition, facility type, and district
	do "$user/$dofiles/BT_anPHCQ.do"
