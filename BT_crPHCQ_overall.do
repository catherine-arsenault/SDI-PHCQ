*------------------------------------------------------------------------------*
*	 		World Bank Service Delivery Indicator (SDI) Surveys				   
*				Overall Primary Health Care (PHC) Quality Index
*								BUTHAN
* 
*
* Created by Catherine Arsenault 
* June 26, 2025	
*------------------------------------------------------------------------------*
	
* Summarize provider knowledge at facility level 

	use "$user/$analysis/Bhutan_vignettes.dta", clear
	
		collapse (mean) cc_* process_cc ///
		(count) n_diar=cc_diar n_pneumo=cc_pneumo n_diab=cc_diab n_tb=cc_tb ///
		n_depr=cc_depr n_htn=cc_htn n_stun=cc_stun ///
		n_process_cc=process_cc [aw=hcpweight], by(facid)
			
			lab var cc_diar "Knowledge score: child diarrhea"
			lab var cc_pneumo "Knowledge score: child pneumonia"
			lab var cc_diab "Knowledge score: diabetes"
			lab var cc_tb "Knowledge score: tuberculosis"
			lab var cc_depr "Knowledge score: depression"
			lab var cc_htn "Knowledge score: hypertension"
			lab var cc_stun "Knowledge score: stunting"
			
		* Merge to facility level dataset
		merge 1:1 facid using "$user/$analysis/Bhutan_facility.dta" 
		 // 2 facilities had no vignettes
		drop _merge
	save"$user/$analysis/Bhutan_phcq_fac.dta", replace
	
* Summarize patient ratings at facility level

	use "$user/$analysis/Bhutan_patient.dta", clear
		
		collapse (mean) process_ux (count) n_process_ux=process_ux ///
		[aw=weight_patient], by(facid)
		
		* Merge to facility level dataset
		merge 1:1 facid using "$user/$analysis/Bhutan_phcq_fac.dta"
		  // 12 dropped
		drop _merge
		save"$user/$analysis/Bhutan_phcq_fac.dta", replace
		
		egen anymiss=rowmiss(phc_sri process_cc process_ux)
		* Calculate overall PHC Quality score for facilities that have all three
		* dimensions available - structure, vignettes, patient experience
		egen phcq=rowmean(phc_sri process_cc process_ux) if anymiss!=1
		
		
	save "$user/$analysis/Bhutan_phcq_fac.dta", replace
		
		