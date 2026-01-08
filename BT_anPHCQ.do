*------------------------------------------------------------------------------*
* 			World Bank Service Delivery Indicator (SDI) Surveys				   *
*				Primary Health Care (PHC) Quality Index						   *
* 							Created August 2025	
*					    Catherine Arsenault, GWSPH
*
* This do file creates summary indices of PHC quality by sentinel PHC condition 
* and creates summary figures and tables of PHC quality at national 
* level and by facility strata and subnational divisions.		
*------------------------------------------------------------------------------*		 
*  CONDITION-SPECIFIC PHC QUALITY INDICES
*------------------------------------------------------------------------------*	

	use "$user/$analysis/Bhutan_vignettes.dta", clear
	collapse (mean) cc_*  ///
			(count) n_diar_cc_cc=cc_diar n_pneumo_cc=cc_pneumo n_diab_cc=cc_diab ///
			n_tb_cc=cc_tb n_depr_cc=cc_depr n_htn_cc=cc_htn n_stun_cc=cc_stun [aw=hcpweight], by(facid)
						

		merge 1:1 facid using "$user/$analysis/Bhutan_facility.dta"
		drop if _merge!=3 // 2 facilities had no vignettes
		drop _merge
	
		recode strata_hftype 2=1 3=0, g(secondary)
		lab def secondary 0"Primary facility" 1"Secondary facility"
		lab val secondary secondary

		egen mchq=rowmean(cc_diar cc_pneumo cc_stun anc_sri child_health_sri )
		
		egen ncdq=rowmean(cc_diab cc_htn diabetes_sri cvd_sri )
		
		egen mentalq=rowmean(mental_health_sri cc_depr )
		
		egen tbq=rowmean(cc_tb tb_sri)
		
		tabstat mchq ncdq tbq mentalq, col(stat) stat(mean sd count)

		* Bar graph
		graph bar mchq ncdq tbq mentalq , ///
			blabel(bar, size(medium) format(%3.1f)) ///
			ylabel(0(20)100, nogrid)  bargap(50) ///
			legend(order(1 "MCH" 2 "NCD"  3 "TB" 4 "Mental health") ///
			size(medlarge) rows(1) position(6)) ///
			ysize(2.5) xsize(2) scheme(white_viridis) title("Bhutan")
			
*------------------------------------------------------------------------------*
* ANALYSES BY FACILITY TYPES
*------------------------------------------------------------------------------*
		u "$user/$analysis/Bhutan_facility.dta", clear 
		tabstat *_sri  , stat(mean sd count) col(stat)
		
			recode strata_hftype 2=1 3=0, g(secondary)
			lab def secondary 0"Primary facility" 1"Secondary facility"
			lab val secondary secondary
			
			mean phc_sri, over(secondary)
			test   c.phc_sri@0.secondary =   c.phc_sri@1.secondary 
			
			collapse (mean) phc_sri (semean) se_phc_sri=phc_sri, by(secondary)
			
			save "$user/$analysis/tmpbarcharts.dta", replace
		
		u "$user/$analysis/Bhutan_vignettes.dta", clear 
		
			recode strata_hftype 2=1 3=0, g(secondary)
			lab def secondary 0"Primary facility" 1"Secondary facility"
			lab val secondary secondary
			
			svyset [pw=hcpweight]
			svy: mean process_cc, over(secondary)
			test   c.process_cc@0.secondary=   c.process_cc@1.secondary
			
			collapse (mean) process_cc (semean) se_process_cc=process_cc [aw=hcpweight], by(secondary)
			merge 1:1 secondary using "$user/$analysis/tmpbarcharts.dta"
			drop _merge
			save "$user/$analysis/tmpbarcharts.dta", replace
			
		u  "$user/$analysis/Bhutan_patient.dta", clear
		
			recode strata_hftype 2=1 3=0, g(secondary)
			lab def secondary 0"Primary facility" 1"Secondary facility"
			lab val secondary secondary
			
			svyset [pw=weight_patient]
			svy: mean process_ux, over(secondary)
			test   c.process_ux@0.secondary=   c.process_ux@1.secondary
			
			collapse (mean) process_ux (semean) se_process_ux=process_ux [aw=weight_patient], by(secondary)
			merge 1:1 secondary using "$user/$analysis/tmpbarcharts.dta"
			drop _merge
			save "$user/$analysis/tmpbarcharts.dta", replace
		
		u "$user/$analysis/Bhutan_phcq_fac.dta", clear
		
			recode strata_hftype 2=1 3=0, g(secondary)
			lab def secondary 0"Primary facility" 1"Secondary facility"
			lab val secondary secondary
			
			 mean phcq, over(second)
			test   c.phcq@0.secondary=   c.phcq@1.secondary
			
			collapse (mean) phcq (semean) se_phcq=phcq , by(secondary)
			merge 1:1 secondary using "$user/$analysis/tmpbarcharts.dta"
			drop _merge
			
		foreach v in phc_sri process_cc process_ux  phcq {
			gen lcl_`v' = `v' - 1.96 * se_`v'
			gen ucl_`v' = `v'+ 1.96 * se_`v'		
		}
			save "$user/$analysis/tmpbarcharts.dta", replace
					
	// Step 1: Generate custom x-axis positions for each bar group
		gen x_phc = cond(secondary == 0, 0.85, 1.15)
		gen x_cc  = cond(secondary == 0, 1.85, 2.15)
		gen x_ux  = cond(secondary == 0, 2.85, 3.15)
		gen x_pqc  = cond(secondary == 0, 3.85, 4.15)


	// Step 2: Plot all bars with tighter spacing
	twoway ///
	  (bar phc_sri x_phc if secondary==0, barwidth(0.25) color(navy) lcolor(black) ///
		   legend(label(1 "Primary facility"))) ///
	  (bar phc_sri x_phc if secondary==1, barwidth(0.25) color(ltblue) lcolor(black) ///
		   legend(label(2 "Secondary facility"))) ///
	  (rcap ucl_phc_sri lcl_phc_sri x_phc, lcolor(black)) ///
	  (bar process_cc x_cc if secondary==0, barwidth(0.25) color(navy) lcolor(black)) ///
	  (bar process_cc x_cc if secondary==1, barwidth(0.25) color(ltblue) lcolor(black)) ///
	  (rcap ucl_process_cc lcl_process_cc x_cc, lcolor(black)) ///
	  (bar process_ux x_ux if secondary==0, barwidth(0.25) color(navy) lcolor(black)) ///
	  (bar process_ux x_ux if secondary==1, barwidth(0.25) color(ltblue) lcolor(black)) ///
	  (rcap ucl_process_ux lcl_process_ux x_ux, lcolor(black)) ///
	  (bar phcq x_pqc if secondary==0, barwidth(0.25) color(navy) lcolor(black)) ///
	  (bar phcq x_pqc if secondary==1, barwidth(0.25) color(ltblue) lcolor(black)) ///
	  (rcap ucl_phcq lcl_phcq x_pqc, lcolor(black)) ///
	  , ylabel(0(10)100, nogrid) ///
		ytitle("Mean scores (95% CI)") ///
		xlabel(1 "Structure" 2 "Provider competence" 3 "User experience" 4 "Overall PHC quality", nogrid) ///
		legend(order(1 "Primary facility" 2 "Secondary facility") ///
			   position(6) ring(1) row(1)) title("Bhutan", size(medium))
			   
*------------------------------------------------------------------------------*
* ANALYSES BY SUBNATIONAL DIVISIONS
*------------------------------------------------------------------------------*
	*Table: Overall PHC Quality and dimension-specific quality by district
			
			* Structural quality by district
			u "$user/$analysis/Bhutan_facility.dta", clear 
				table district, stat(mean phc_sri) 
				// Note: Bhutan included a census of all facilities, therefore 
				// there are no facility-level sampling weights.
				
			*User experience by district	
			u  "$user/$analysis/Bhutan_patient.dta", clear
				table district [aw=weight_patient], stat(mean process_ux) 
			
			* Provider competence by district 
			u "$user/$analysis/Bhutan_vignettes.dta", clear 
				table district [aw=hcpweight], stat(mean process_cc) 
				
			*Overall PHC quality by district
			use "$user/$analysis/Bhutan_phcq_fac.dta", clear 
				table district, stat(mean phcq) 
			
			bysort district: egen med_phcq = median(phcq)
			egen region_ord = group(med_phcq strata_region)
				label define BhutanRegions ///
					20 "Bumthang" ///
					8  "Chhukha" ///
					12 "Dagana" ///
					10 "Gasa" ///
					9  "Haa" ///
					14 "Lhuentse" ///
					17 "Monggar" ///
					6  "Paro" ///
					4  "Pema Gatshel" ///
					19 "Punakha" ///
					5  "Samdrup Jongkhar" ///
					2  "Samtse" ///
					1  "Sarpang" ///
					7  "Thimphu" ///
					15 "Trashigang" ///
					13 "Trashi Yangtse" ///
					16 "Trongsa" ///
					11 "Tsirang" ///
					18 "Wangdue Phodrang" ///
					3  "Zhemgang"
				label values region_ord BhutanRegions
						
			* Box plots: overall PHC quality by district
			graph box phcq   , title("Bhutan", size(large)) ///
			over(region_ord) scheme(white_tableau)  ylabel(0(20)100) ///
			marker(1, msize(vsmall)) asyvars legend( size(small)) ytitle("Overall PHC quality")

		
