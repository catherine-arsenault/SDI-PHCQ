*-------------------------------------------------------------------------------
*			World Bank Service Delivery Indicator (SDI) Surveys				   
* 					Primary Health Care (PHC) Quality Index						   
																			   
* 					PROCESS MEASURES: USER EXPERIENCE								   
																			   
/* This dofile creates indices of user experience (UX) based on PHC client exit  
 interviews. Clients rated 11 elements of their experience on a 5-point likert
 scale from very bad, bad, moderate, good, to very good. The resulting score 
 provides the average number of item rated as "good" or "very good". UX elements 
 included:
 overall quality of visit, convenience of operating hours, wait time, 
 time spent with the provider, respectful communication, visual privacy, 
 auditory privacy, clear communication, facility cleanliness, physical condition 
 of the rooms, and whether the provider  involved the client in decisions about 
 their care
																			   
 Created by Catherine Arsenault 						   
 June 26, 2025																   
------------------------------------------------------------------------------*/
* Use the SDI Client-level dataset
	use "$user/$rawdata/Bhutan/surveydata/finaldata/Patient_Final_weighted.dta", clear	
	
*------------------------------------------------------------------------------*
* Create a user experience score

	foreach v in S3A_q7a_hfrating S3A_q7c_hfrating S3A_q7d_hfrating ///
		S3A_q7e_hfrating S3A_q7f_hfrating S3A_q7g_hfrating S3A_q7h_hfrating ///
		S3A_q7i_hfrating S3A_q7j_hfrating S3A_q7n_hfrating S3A_q7o_hfrating {
		recode `v' 4/5=1 1/3=0, gen(b`v')
	}
	
	egen process_ux=rowmean(bS3A*)
	lab var process_ux "Proportion of 11 user experience elements rated as good/very good"
	
	rename (S1C_q10hfcode patient_weight S1C_q6dzongkhag) (facid weight_patient district)
	
	replace process_ux=process_ux*100
	
	save  "$user/$analysis/Bhutan_patient.dta", replace
	

