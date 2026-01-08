*------------------------------------------------------------------------------*
*			 World Bank Service Delivery Indicator (SDI) Surveys				   
*					 Primary Health Care (PHC) Quality Index						   
																			   
* 					PROCESS MEASURES: PROVIDER KNOWLEDGE 								   
																			   
* This dofile creates indices of process quality based on clinical vignettes 
* scores  for sentinel conditions using data from the SDI surveys. The score 
* combines recommended elements of patient assessment (average performance on 
* history taking, physical examinations, and clinical investigations), diagnoses, 
* appropriate treatments, and counseling (average performance on patient 
* education counseling and instructions for follow-up).
																			   
* Created by Catherine Arsenault and Sindhu Ravishankar						   
* June 26, 2025																   
*------------------------------------------------------------------------------*

* Use the SDI Provider-level dataset
 use "$user/$rawdata/Bhutan/surveydata/finaldata/Provider_Final_weighted.dta", clear	

*------------------------------------------------------------------------------*
*Variable recode
 
*stunting
foreach v in S3J_IIILAX S3J_IIILAY S3J_IIIWAX S3J_IIIWAY S3J_IIIWLX S3J_IIIWLY {
	recode `v' (2=0)
} 

* Replace missing to 0 if the diagnosis is non missing
 
*Diarrhea N=104 
foreach v in ///
S3C_Isymptoms__4 S3C_Isymptoms__5 S3C_Isymptoms__6 S3C_Isymptoms__7 ///
S3C_Isymptoms__8 S3C_Isymptoms__9 S3C_Isymptoms__10 S3C_Isymptoms__11 S3C_Isymptoms__12 	S3C_Isymptoms__13 S3C_Isymptoms__21 S3C_IIanthropo__1 S3C_IIanthropo__2 S3C_IIanthropo__5 S3C_IIanthropo__7 S3C_IIanthropo__8 S3C_IIgenexamination__13 S3C_IIgenexamination__20 S3C_IIgenexamination__21 S3C_IIheadneck__26 S3C_IIheadneck__27 S3C_IIheadneck__28 S3C_IIheadneck__29 S3C_IVdiagnosis__1 S3C_IVdiagnosis__2 S3C_IVdiagnosis__8 S3C_IVdiagnosis__5 S3C_Vtreatment__1 S3C_Vtreatment__2 S3C_Vtreatment__3 S3C_Vtreatment__4 S3C_VIadherence__1 S3C_VIadherence__2 S3C_VIadherence__3 S3C_VIadherence__4 S3C_VIadherence__5 S3C_VIadherence__6 S3C_VIfeeding__7 S3C_VIfeeding__8 S3C_VIfeeding__9 S3C_VIfeeding__10 S3C_VIfeeding__11 S3C_VIhygiene__12 S3C_VIhygiene__13 S3C_VIfollowup__16 S3C_VIfollowup__17  {
			replace `v'=0 if `v'>=. & (S3C_IVdiagnosis__1 ==1 | S3C_IVdiagnosis__1 ==0) 
		}
*Pneumonia N= 94 
foreach v in ///
S3D_IIsymptoms__4  S3D_IIsymptoms__8 S3D_IIsymptoms__9 S3D_IIsymptoms__11 S3D_IIsymptoms__13 S3D_IIsymptoms__14 S3D_IIsymptoms__18 S3D_IIsymptoms__19 S3D_IIanthropo__1 S3D_IIanthropo__5 S3D_IIanthropo__6 S3D_IIcomplaint__14 S3D_IIcomplaint__15 S3D_IIcomplaint__18 S3D_IVdiagnosis__1 S3D_Vtreatment__1 S3D_Vtreatment__2 S3D_Vtreatment__7 S3D_Vtreatment__8 S3D_VIadherence__1 S3D_VIadherence__4 S3D_VIadherence__7 S3D_VIadherence__8 S3D_VIadherence__9 S3D_VIfollowup__25 S3D_VIfollowup__26 S3D_VIfollowup__27  {
			replace `v'=0 if `v'>=. & (S3D_IVdiagnosis__1 ==1 | S3D_IVdiagnosis__1 ==0) 
		}
		
*Diabetes N=109  
foreach v in ///
S3E_Isymptoms__4 S3E_Isymptoms__8 S3E_Isymptoms__9 S3E_Isymptoms__17 S3E_Ifamily__25 S3E_Irisks__27 S3E_Irisks__28 S3E_Irisks__30 S3E_Irisks__31 S3E_IIanthropo__3 S3E_IIanthropo__7 S3E_IIanthropo__8 S3E_IIanthropo__9 S3E_IIBMI__2 S3E_IIexaminations__12 S3E_IIexaminations__13 S3E_IIexaminations__14 S3E_IIexaminations__15 S3E_IIexaminations__16 S3E_IIexaminations__17 S3E_IIexaminations__18 S3E_IIexaminations__19 S3E_IIIinvestigatio__2 S3E_IIIinvestigatio__3 S3E_IIIinvestigatio__5 S3E_IIIinvestigatio__8 S3E_IIIinvestigatio__11 S3E_IIIinvestigatio__16 S3E_IVdiagnosis__1 S3E_IVdiagnosis__2 S3E_IVdiagnosis__4 S3E_Vtreatment__1 S3E_Vtreatment__2 S3E_Vtreatment__3 S3E_VIbehavior__9 S3E_VIbehavior__10 S3E_VIbehavior__11 S3E_VIbehavior__12 S3E_VIbehavior__13 S3E_VIbehavior__14 S3E_VIbehavior__15 S3E_VIbehavior__16 S3E_VIbehavior__17 S3E_VIbehavior__18 S3E_VIbehavior__19 S3E_VIbehavior__20 S3E_VIfollowup__35 S3E_VIfollowup__36 S3E_VIfollowup__37 S3E_VIadherence__1 S3E_VIadherence__2 S3E_VIadherence__3 S3E_VIadherence__4 S3E_VIfollowup__30 S3E_VIfollowup__31 S3E_VIfollowup__32 S3E_VIfollowup__33 S3E_VIfollowup__34  {
			replace `v'=0 if `v'>=. & (S3E_IVdiagnosis__1 ==1 | S3E_IVdiagnosis__1 ==0) 
		}
		
*TB N= 93 
foreach v in ///
S3F_IIIlaboratory__3 S3F_IIIlaboratory__4 S3F_IIIlaboratory__3 S3F_Isymptoms__3 S3F_Isymptoms__6 S3F_Isymptoms__7 S3F_Isymptoms__8 S3F_Isymptoms__10 S3F_Isymptoms__11 S3F_Iprevious__18 S3F_Iprevious__20 S3F_Iprevious__21 S3F_Iprevious__22 S3F_Iprevious__23 S3F_Ifamily__34 S3F_Ifamily__36 S3F_Irisks__38 S3F_Irisks__39 S3F_IIanthropo__5 S3F_IIanthropo__6 S3F_IIanthropo__8 S3F_IIanthropo__9 S3F_IIBMI__2 S3F_IIheadtotoe__15 S3F_IIheadtotoe__16 S3F_IIIlaboratory__9 S3F_IVdiagnosis__2 S3F_IVdiagnosis__4 S3F_IVdiagnosis__1 S3F_Vtreatment__1 S3F_Vreferral__11 S3F_VIadherence__1 S3F_VIadherence__4 S3F_VIadherence__6 S3F_VIbehavior__9 S3F_VIbehavior__11 S3F_VIbehavior__12 S3F_VIbehavior__14 S3F_VIfollowup__15 S3F_VIfollowup__16 S3F_VIfollowup__17 {
			replace `v'=0 if `v'>=. & (S3F_IVdiagnosis__2 ==1 | S3F_IVdiagnosis__2 ==0) 
		}
		
*Depression N= 90 
foreach v in ///
S3G_IIIinvestigatio__1 S3G_IIIinvestigatio__13 S3G_Isymptoms__3 S3G_Isymptoms__4  S3G_Isymptoms__13 S3G_Isymptoms__14 S3G_Isymptoms__19 S3G_Isymptoms__22 S3G_Isymptoms__23 S3G_Isymptoms__24 S3G_Isymptoms__26 S3G_Isymptoms__29 S3G_Isymptoms__30 S3G_Isymptoms__31 S3G_Iprevious__35 S3G_Iprevious__36 S3G_Iprevious__37 S3G_Iprevious__38  S3G_Iprevious__42 S3G_Iprevious__44 S3G_Iprevious__53 S3G_Iprevious__54 S3G_IIanthropo__4 S3G_IIanthropo__8 S3G_IIanthropo__9 S3G_IIanthropo__13 S3G_IIBMI__2 S3G_IIIinvestigatio__4 S3G_IVdiagnosis__1 S3G_IVdiagnosis__2 S3G_IVdiagnosis__3 S3G_Vreferral__11 S3G_Vreferral__10 S3G_Vtreatment__2 S3G_Vtreatment__3 S3G_Vtreatment__4 S3G_Vtreatment__5 S3G_Vtreatment__6 S3G_Vtreatment__7 S3G_Vfollowup__16  {
			replace `v'=0 if `v'>=. & (S3G_IVdiagnosis__1 ==1 | S3G_IVdiagnosis__1 ==0) 
		}

*Hypertension N= 108 
foreach v in ///
S3I_Isymptoms__3 S3I_Iprevious__26 S3I_Iprevious__27 S3I_Iprevious__31 S3I_Iprevious__32 S3I_Iprevious__34 S3I_Iprevious__35 S3I_Ifamily__36 S3I_Ifamily__38 S3I_Ifamily__39 S3I_Ifamily__40 S3I_Irisks__41 S3I_Irisks__42 S3I_Irisks__43 S3I_Irisks__44 S3I_Irisks__45 S3I_IIanthropo__2 S3I_IIanthropo__3 S3I_IIanthropo__4 S3I_IIanthropo__5 S3I_IIanthropo__7 S3I_IIanthropo__8 S3I_IIanthropo__9 S3I_IIBMI__3 S3I_IIIlaboratory__6 S3I_IIIlaboratory__7 S3I_IIIlaboratory__8 S3I_IIIlaboratory__10 S3I_IIIlaboratory__12 S3I_IVdiagnosis__1 S3I_IVdiagnosis__2 S3I_IVdiagnosis__3 S3I_Vtreatment__1 S3I_Vtreatment__2 S3I_Vantihypertensiv__1 S3I_Vtreatment__8 S3I_VInutrition__7 S3I_VInutrition__8 S3I_VInutrition__9 S3I_VInutrition__10 S3I_VInutrition__11 S3I_VInutrition__12 S3I_VInutrition__13 S3I_VInutrition__14 S3I_VInutrition__15 S3I_VInutrition__16 S3I_VInutrition__17 S3I_VInutrition__18 S3I_VIadherence__1 S3I_VIadherence__2 S3I_VIadherence__4 S3I_VIadherence__5 S3I_VIadherence__6 S3I_VIfollowup__20 S3I_VIfollowup__21 {
			replace `v'=0 if `v'>=. & (S3I_IVdiagnosis__1 ==1 | S3I_IVdiagnosis__1 ==0) 
		}
		
*Stunting N= 199   
 foreach v in ///
S3J_Iprevious__4 S3J_Iprevious__5 S3J_Iprevious__8 S3J_Iprevious__10 S3J_Iprevious__11 S3J_Iprevious__12 S3J_Iprevious__14 S3J_Iprevious__17 S3J_Iprevious__19 S3J_Iprevious__21 S3J_Iperinatal__26 S3J_Iperinatal__28 S3J_Inutrition__36 S3J_Inutrition__37 S3J_Inutrition__38 S3J_Inutrition__39 S3J_Inutrition__40 S3J_Inutrition__41 S3J_Inutrition__42 S3J_Inutrition__43 S3J_Inutrition__44 S3J_IIanthropo__7 S3J_IIanthropo__8 S3J_IIanthropo__10 S3J_IIanthropo__11 S3J_IIILAX S3J_IIILAY S3J_IIIWAX S3J_IIIWAY S3J_IIIWLX S3J_IIIWLY S3J_IIIheadtotoe__12 S3J_IIIheadtotoe__13 S3J_IIIheadtotoe__14 S3J_IIIheadtotoe__22 S3J_IVaboratory__1 S3J_IVaboratory__2 S3J_IVaboratory__4 S3J_IVaboratory__5 S3J_IVaboratory__6 S3J_IVaboratory__7 S3J_IVaboratory__9 S3J_IVaboratory__12 S3J_Vdiagnosis__2 S3J_Vdiagnosis__3 S3J_Vdiagnosis__4 S3J_Vdiagnosis__5 S3J_Vdiagnosis__1 S3J_VItreatment__7 S3J_VItreatment__2 S3J_VIIfeeding__2 S3J_VIIfeeding__3 S3J_VIIfeeding__4 S3J_VIIfeeding__5 S3J_VIIfeeding__6 S3J_VIIfeeding__7 S3J_VIIfeeding__8 S3J_VIIfeeding__9 S3J_VIIfeeding__10 S3J_VIIfeeding__11 S3J_VIIfeeding__12 S3J_VIIfeeding__13 S3J_VIIfeeding__14 S3J_VIIstatus S3J_VIIhygiene__15 S3J_VIIhygiene__16  S3J_VIImother__23 S3J_VIImother__24 S3J_VIIfollowup__27 S3J_VIIfollowup__28 {
			replace `v'=0 if `v'>=. & (S3J_Vdiagnosis__2 ==1 | S3J_Vdiagnosis__2 ==0) 
		}


*------------------------------------------------------------------------------*	
* CASE 1: Child diarrhea 

	* Patient assessment
			egen diar_assess=rowmean(S3C_Isymptoms__4 - S3C_Isymptoms__13 ///
				S3C_Isymptoms__21 S3C_IIanthropo__1 S3C_IIanthropo__2 ///
				S3C_IIanthropo__5 S3C_IIanthropo__7 S3C_IIanthropo__8 ///
				S3C_IIgenexamination__13 S3C_IIgenexamination__20 ///
				S3C_IIgenexamination__21 S3C_IIheadneck__26 - S3C_IIheadneck__29)
	* Correct diagnosis 
		// Diarrhea or acute diarrhea or gastroenteritis, and severe dehydration
			egen diar_diag=rowmax(S3C_IVdiagnosis__1 S3C_IVdiagnosis__2 ///
								S3C_IVdiagnosis__8)
			gen dehyd_diag=  S3C_IVdiagnosis__5
			
	* Correct treatment
		// Based on provider training and health facility Equipment-Start intravenous 
		// fluid (WHO Integrated Management of Childhood Illness plan C) OR refer to 
		// higher-level health facility for IV or nasogastric tube. 	
			egen diar_tx= rowmax(S3C_Vtreatment__1 S3C_Vtreatment__2 S3C_Vtreatment__3 ///
						S3C_Vtreatment__4)
	* Counseling 
		egen diar_couns=rowmean(S3C_VIadherence__1 - S3C_VIhygiene__13 ///
			S3C_VIfollowup__16 S3C_VIfollowup__17)
	* Full score 	
		egen cc_diar=rowmean(diar_assess diar_diag dehyd_diag diar_tx diar_couns) 
	
*------------------------------------------------------------------------------*	
* CASE 2: Child pneumonia

	* Patient assessment
		egen pneumo_assess=rowmean(S3D_IIsymptoms__4  S3D_IIsymptoms__8 ///
			S3D_IIsymptoms__9 S3D_IIsymptoms__11 S3D_IIsymptoms__13 ///
			S3D_IIsymptoms__14 S3D_IIsymptoms__18 S3D_IIsymptoms__19 ///
			S3D_IIanthropo__1 S3D_IIanthropo__5 S3D_IIanthropo__6 ///
			S3D_IIcomplaint__14 S3D_IIcomplaint__15 S3D_IIcomplaint__18 )
	
	* Correct diagnosis // Pneumonia
		gen pneumo_diag = S3D_IVdiagnosis__1 
		
	* Correct treatment 
	// Amoxicillin or Cotrimoxazole and paracetamol or other antipyretic
		egen antibio=rowmax(S3D_Vtreatment__1 S3D_Vtreatment__2) 
		egen antip=rowmax(S3D_Vtreatment__7 S3D_Vtreatment__8)
		
	* Couselling 
		egen pneumo_counsel=rowmean(S3D_VIadherence__1 S3D_VIadherence__4 ///
			S3D_VIadherence__7 - S3D_VIadherence__9 S3D_VIfollowup__25 - S3D_VIfollowup__27)
			
	* Full score including assessment and counseling	
		egen cc_pneumo=rowmean(pneumo_diag antibio antip pneumo_counsel)

*------------------------------------------------------------------------------*	
* CASE 3: Diabetes

	* Patient assessment
		egen diab_assess=rowmean(S3E_Isymptoms__4 S3E_Isymptoms__8 S3E_Isymptoms__9 ///
			S3E_Isymptoms__17 S3E_Ifamily__25 S3E_Irisks__27 S3E_Irisks__28  ///
			S3E_Irisks__30 S3E_Irisks__31 S3E_IIanthropo__3 ///
			S3E_IIanthropo__7-S3E_IIanthropo__9 S3E_IIBMI__2 ///
			S3E_IIexaminations__12-S3E_IIexaminations__19 ///
			S3E_IIIinvestigatio__2 S3E_IIIinvestigatio__3 S3E_IIIinvestigatio__5 ///
			S3E_IIIinvestigatio__8 S3E_IIIinvestigatio__11 S3E_IIIinvestigatio__16 )
	
	* Correct diagnosis
		// Diabetes/Diabetes Type 2/ diabetes mellitus Type 2, and obesity
			egen diab_diag=rowmax(S3E_IVdiagnosis__1 S3E_IVdiagnosis__2)
			g diab_obes_diag = S3E_IVdiagnosis__4
	
	* Correct treatment 
		// Metformin and statin 
			g metform=S3E_Vtreatment__1
			egen statin=rowmax(S3E_Vtreatment__2 S3E_Vtreatment__3)
			egen diab_behav=rowmax(S3E_VIbehavior__9-S3E_VIbehavior__20)
			
	* Counseling 
			egen return= rowmax(S3E_VIfollowup__35-S3E_VIfollowup__37) // any one of these
			egen diab_couns=rowmean (S3E_VIbehavior__9-S3E_VIbehavior__20 ///
				S3E_VIadherence__1-S3E_VIadherence__4 S3E_VIfollowup__30-S3E_VIfollowup__34 ///
				return)
				
	* Full score 
			egen cc_diab=rowmean(diab_assess diab_diag diab_obes_diag metform ///
				statin diab_behav diab_couns)
	
*------------------------------------------------------------------------------*	
* CASE 4: Tuberculosis

	* Patient assessment 
		egen tb_test=rowmax(S3F_IIIlaboratory__3 S3F_IIIlaboratory__4 ///
		S3F_IIIlaboratory__3)
		egen tb_assess=rowmean(S3F_Isymptoms__3 S3F_Isymptoms__6-S3F_Isymptoms__8 ///
				S3F_Isymptoms__10 S3F_Isymptoms__11 S3F_Iprevious__18 ///
				S3F_Iprevious__20-S3F_Iprevious__23 S3F_Ifamily__34-S3F_Ifamily__36 ///
				S3F_Irisks__38 S3F_Irisks__39 S3F_IIanthropo__5 S3F_IIanthropo__6 ///
				S3F_IIanthropo__8 S3F_IIanthropo__9 S3F_IIBMI__2 S3F_IIheadtotoe__15 ///
				S3F_IIheadtotoe__16 S3F_IIIlaboratory__9 tb_test) 
				
	* Correct diagnosis  // Pulmonary, drug-susceptible, or non-specific TB. 
		egen tb_diag=rowmax(S3F_IVdiagnosis__2 S3F_IVdiagnosis__4 S3F_IVdiagnosis__1)
	
	* Correct treatment // Anti-TB Drug or refer to Local TB Focal Person/Facility
		egen tb_tx =rowmax(S3F_Vtreatment__1 S3F_Vreferral__11)
	
	* Counselling
		egen tb_couns=rowmean(S3F_VIadherence__1-S3F_VIadherence__4 ///
				S3F_VIadherence__6 S3F_VIbehavior__9 S3F_VIbehavior__11 ///
				S3F_VIbehavior__12 S3F_VIbehavior__14-S3F_VIfollowup__17)
				
	* Full score including patient assessment and counseling		
		egen cc_tb=rowmean(tb_assess tb_diag tb_tx tb_couns)
		
*------------------------------------------------------------------------------*	
* CASE 5: Depression

	* Patient assessment
		egen depr_hemog=rowmax(S3G_IIIinvestigatio__1 S3G_IIIinvestigatio__13) ///
		
		egen depr_assess=rowmean(S3G_Isymptoms__3 S3G_Isymptoms__4  ///
			S3G_Isymptoms__13 S3G_Isymptoms__14 S3G_Isymptoms__19 ///
			S3G_Isymptoms__22-S3G_Isymptoms__24 ///
			S3G_Isymptoms__26 S3G_Isymptoms__29-S3G_Isymptoms__31 ///
			S3G_Iprevious__35-S3G_Iprevious__38  S3G_Iprevious__42 S3G_Iprevious__44 ///
			S3G_Iprevious__53 S3G_Iprevious__54 S3G_IIanthropo__4 S3G_IIanthropo__8 ///
			S3G_IIanthropo__9 S3G_IIanthropo__13 S3G_IIBMI__2 ///
			S3G_IIIinvestigatio__4 depr_hemog) 
			
	* Correct diagnosis // Depression (mild/moderate) 
		egen depr_diag=rowmax(S3G_IVdiagnosis__1 S3G_IVdiagnosis__2 S3G_IVdiagnosis__3) 
	
	* Correct treatment
		// Referral to psychiatrist or Community Center for Mental Health (CCSM) 
		// and at least one behavioral treatment option
		egen depr_tx = rowmax(S3G_Vreferral__11 S3G_Vreferral__10)
		egen depr_behav=rowmax(S3G_Vtreatment__2-S3G_Vtreatment__7)
	* Counselling 
		egen depr_couns=rowmean(S3G_Vtreatment__2-S3G_Vtreatment__7 S3G_Vfollowup__16)
		
	* Full score 
		egen cc_depr=rowmean(depr_assess depr_diag depr_tx depr_behav depr_couns)

*------------------------------------------------------------------------------*	
* CASE 7: Hypertension

	* Patient assessment 
		egen htn_assess=rowmean(S3I_Isymptoms__3 S3I_Iprevious__26 ///
			S3I_Iprevious__27 S3I_Iprevious__31 S3I_Iprevious__32 ///
			S3I_Iprevious__34 S3I_Iprevious__35 S3I_Ifamily__36 ///
			S3I_Ifamily__38-S3I_Ifamily__40 S3I_Irisks__41-S3I_Irisks__45 ///
			S3I_IIanthropo__2-S3I_IIanthropo__5 S3I_IIanthropo__7-S3I_IIanthropo__9 ///
			S3I_IIBMI__3   S3I_IIIlaboratory__6-S3I_IIIlaboratory__8 ///
			S3I_IIIlaboratory__10 S3I_IIIlaboratory__12 )
		
	* Correct diagnosis // Hypertension, obesity, and Hyperlipidemia/ 
	 // Dyslipidemia/ Hypercholesterolemia
		g htn_diag= S3I_IVdiagnosis__1 
		g obese_diag = S3I_IVdiagnosis__2 
		g chol_diag= S3I_IVdiagnosis__3

	* Correct treatment 
		// Any antihypertensive or hydrochlorothiazide or losartan // and atorvastatin 
		egen antih= rowmax(S3I_Vtreatment__1 S3I_Vtreatment__2  S3I_Vantihypertensiv__1)
		g ator= S3I_Vtreatment__8
		egen htn_behav=rowmax(S3I_VInutrition__7-S3I_VInutrition__18) 
		
	* Counselling 
		egen htn_couns=rowmean(S3I_VIadherence__1 S3I_VIadherence__2 ///
		S3I_VIadherence__4-S3I_VInutrition__18 S3I_VIfollowup__20 S3I_VIfollowup__21)
		
	* Full score
		egen cc_htn=rowmean(htn_assess htn_diag obese_diag chol_diag antih ator ///
			htn_behav htn_couns )
		
*------------------------------------------------------------------------------*	
* CASE 8: Stunting

	* Patient assessment 
		egen stun_assess=rowmean(S3J_Iprevious__4 S3J_Iprevious__5 S3J_Iprevious__8 ///
			S3J_Iprevious__10-S3J_Iprevious__12 S3J_Iprevious__14 S3J_Iprevious__17 ///
			S3J_Iprevious__19 S3J_Iprevious__21 S3J_Iperinatal__26 S3J_Iperinatal__28 /// 
			S3J_Inutrition__36-S3J_Inutrition__44 S3J_IIanthropo__7 S3J_IIanthropo__8 ///
			S3J_IIanthropo__10 S3J_IIanthropo__11 S3J_IIILAX S3J_IIILAY S3J_IIIWAX ///
			S3J_IIIWAY S3J_IIIWLX S3J_IIIWLY S3J_IIIheadtotoe__12-S3J_IIIheadtotoe__14 ///
			S3J_IIIheadtotoe__22 S3J_IVaboratory__1 S3J_IVaboratory__2 ///
			S3J_IVaboratory__4-S3J_IVaboratory__7 S3J_IVaboratory__9 S3J_IVaboratory__12)
	
	* Correct diagnosis
	 // Stunting (unspecified, mild, moderate, or severe) and Anemia
		egen stun_diag=rowmax(S3J_Vdiagnosis__2-S3J_Vdiagnosis__5)
		g anem_diag = S3J_Vdiagnosis__1
		
	* Correct treatment 
	 // Micronutrient supplementation and albendazole & at least one element
	 // of dietary counseling
		g nutsup= S3J_VItreatment__7
		g deworm= S3J_VItreatment__2
		egen diet=rowmax(S3J_VIIfeeding__2-S3J_VIIfeeding__14)
		
	* Couselling 
		egen stun_couns= rowmean(S3J_VIIstatus-S3J_VIIhygiene__16 ///
			S3J_VIImother__23 S3J_VIImother__24 S3J_VIIfollowup__27 S3J_VIIfollowup__28)
	* Full score
		egen cc_stun=rowmean(stun_assess stun_diag anem_diag nutsup deworm diet stun_couns)
		
*------------------------------------------------------------------------------*	
* CALCULATE OVERALL PROVIDER KNOWLEDGE SCORE
	
	egen process_cc=rowmean(cc_* )
		
	keep HP0_q7assignhfcode strata_hftype strata_region cc_* process_cc iweight HP0_q4assigndzo
	rename HP0_q7assignhfcode facid
	rename iweight hcpweight 
	rename HP0_q4assigndzo district

	foreach var in  cc_diar cc_pneumo cc_diab cc_tb cc_depr cc_htn cc_stun process_cc {
							replace `var'= `var'*100
				}
				
				
	save "$user/$analysis/Bhutan_vignettes.dta", replace
	









