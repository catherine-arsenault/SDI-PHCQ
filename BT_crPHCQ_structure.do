*------------------------------------------------------------------------------*
* 			World Bank Service Delivery Indicator (SDI) Surveys				   *
*				Primary Health Care (PHC) Quality Index	- BHUTAN			   *
*																			   *
* This dofile creates indices of structural quality using data from			   *
* the SDI surveys. Indices were based on guidance from the WHO 				   *
* SARA service-specific readiness indices and WHO HHFA. 					   *
*																			   *
* Created by Catherine Arsenault and Sindhu Ravishankar
* June 26, 2025																   *
*------------------------------------------------------------------------------*
* Notes: Ensure all indicators are binary (available=1, not available=0) and 
* recode as necessary. For equipment, diagnostics, medicine, and commodities 
* indicators, most include one indicator indicating availability and another 
* indicating that it is functioning (or not expired in case of medicine) – 
* create a new variable that indicates available AND functioning. For staff 
* training code as no=0 and yes=1 if at least one provider has been trained. 
* For guidelines if there are separate indicators for guideline availability 
* and whether the guideline is current, combine the two into a new indicator.
*  If >5% observations are missing, recode missing as not available. 
*------------------------------------------------------------------------------*

* Use the SDI Facility-level dataset
	use "$user/$rawdata/Bhutan/surveydata/finaldata/Facility_Final.dta", clear

* Replace Missing to 0 for services not provided
foreach v in ///
S9R1_q4services20  S9R1_q4services19  S9R1_q4services31 S9R1_q4services30 ///
S9R1_q4services3 S9R1_q4services10 S9R1_q4services17 S9R1_q4services24 ///
S9R1_q4services23 {
			replace `v'=0 if `v'>=.	

			}	
*------------------------------------------------------------------------------*
* General Readiness Amenities Index

		//Power
		gen gen_amenities_power = 0
		replace gen_amenities_power = 1 if (S7A_q27electricity==2 | ///
					S7A_q27electricity==4) & S7A_q28funcelectricity==1
				
		//water source 
		recode S7A_q33watersource 1/2=1 3/max=0		
		gen gen_amenities_water = 0
		replace gen_amenities_water = 1 if S7A_q33watersource == 1 & ///
		S7A_q35wateravail == 1
		
		//auditory and visual privacy
		gen gen_amen_audio = 0
		replace gen_amen_audio = 1 if (S7A_q55consroomaudio == 1 | ///
		S7A_q55consroomaudio == 2) & S7A_q56roomaudioveri == 1
		
		gen gen_amen_visual = 0
		replace gen_amen_visual = 1 if (S7A_q57consroomvisual==1 | ///
		S7A_q57consroomvisual == 2)	& S7A_q58roomvisualveri==1	
		
		egen gen_amenities_audiovisual = rowmin(gen_amen_audio gen_amen_visual)
		
		//sanitation
		recode S7A_q39improvedtoilet 0=0 1/max=1, gen(gen_amenities_sanitation)	
		
		//communitcation equipment
		gen gen_amen_tel = 0  
		replace gen_amen_tel = 1 if S7A_q5telephone == 1 & S7A_q6functionaltele == 1
		
		gen gen_amen_mob = 0  
		replace gen_amen_mob = 1 if S7A_q7mobilephone == 1 & S7A_q8funmobile == 1	
		
		gen gen_amen_smart = 0
		replace gen_amen_smart = 1 if S7A_q9smartphone == 1 & S7A_q10funsmartphone == 1	
		
		gen gen_amen_radio = 0
		replace gen_amen_radio = 1 if S7A_q13radio == 1 & S7A_q14functionalradio == 1	
		
		egen gen_amenities_coms = rowmax(gen_amen_tel gen_amen_mob gen_amen_smart gen_amen_radio)
		
		//computer and internet
		gen gen_amen_comp = 0  
		replace gen_amen_comp = 1 if S7A_q15computer == 1 & S7A_q16funccomputer == 1
		
		gen gen_amen_wifi = 0  
		replace gen_amen_wifi = 1 if S7A_q19internet == 1 & S7A_q20funcinternet == 1		
		
		egen gen_amenities_computer = rowmin(gen_amen_comp gen_amen_wifi)
		
		//emergency transportation 
		gen ambu_station = 0 
		replace ambu_station = 1 if S7A_q77vechstationed == 1 | ///
		S7A_q77vechstationed == 2 
		
		gen ambu_func = 0 
		replace ambu_func = 1 if S7A_q77vechstationed ==1 & S7A_q78funcvehicle ==1 & ///
		S7A_q79vehiclefuel ==1 & S7A_q80ambudriver ==1	
		
		egen gen_amenities_ambulance = rowmin(ambu_station ambu_func)
				
		//Calculation of General amenities SRI 
		egen gen_amenities_sri=rowmean(gen_amenities_power gen_amenities_water ///
		gen_amenities_audiovisual gen_amenities_sanitation gen_amenities_coms ///
		gen_amenities_computer gen_amenities_ambulance) 

*------------------------------------------------------------------------------*	
* General Readiness Infection Prevention Index		

	//Sharps disposal 
	recode S7B_q4sharpsveri 3=0 1/2=1, gen(gen_prev_sharps)
	
	//Infectious waste disposal 
	recode S7B_q6infecveri 3=0 1/2=1, gen(gen_prev_infectious)
	
	//Disinfectant 
	recode S11E_q1infection5 2=0, g(gen_prev_disinfect)	
	
	//single use syringe 
	recode S11A_q1opd6 2=0, g(gen_prev_syringe)	
	
	//soap and water or alcohol rub 
	gen gen_prev_handwash = 0
	replace gen_prev_handwash = 1 if (S7A_q51watersoap5mt==1 | S7A_q51watersoap5mt==2) & 	S7A_q52watersoapveri==1	
	
	//latex gloves
	recode S11E_q1infection13 2=0, g(gen_prev_gloves)	
	
	//guidelines for standard precautions 
	recode S8A_q7ipcguidelines 2=0, g(gen_prev_guidelines)	

	//Calculation of General Infection Prevention SRI
		egen gen_infect_prev_sri=rowmean(gen_prev_sharps gen_prev_infectious gen_prev_disinfect gen_prev_syringe gen_prev_handwash gen_prev_gloves gen_prev_guidelines) 
*------------------------------------------------------------------------------*	
* ANC Service Readiness Index
	
	//ANC guidelines 
		recode S10R1_q1available5 (1=1) (2/3=0), gen(guidelines_mch)		
	 
	//ANC staff training
		recode S9R1_q4services10 0=0 1/max=1, gen(training_anc)	
	//BP apparatus 
		gen equip_bp = 0  
		replace equip_bp = 1 if S11B_q1mch13 == 1 & S11B_q3function13 == 1 
	//Haemoglobinometer 
		gen diag_hemog = 0 
		replace diag_hemog = 1 if S11D_q1lab20 == 1 & S11D_q3function20 == 1	
	//Urine dipstick 
		recode S11D_q1lab19 2=0, g(diag_urine_dipstick) 
	//Iron 
		gen med_ifa = avai_S12A_q1available17 
	//Folic acid 
		gen tmp = avai_S12A_q1available19 
		egen med_fa =rowmax(med_ifa tmp) 
	//DTP tetnus 
		gen med_dtp = avai_S12B_q1available2  
 
	
	//Calculation of ANC SRI 
		egen anc_sri=rowmean(guidelines_mch training_anc equip_bp diag_hemog ///
		diag_urine_dipstick med_ifa med_fa med_dtp)

**-------------------------------------------------------------------------------------*
* Child Health Services Service Readiness Index

	//IMNCI Guidelines 
		recode S10R1_q1available27 (1=1) (2/3=0), gen(guidelines_imnci) 
	//growth and immunization guidelines - guidelines_mch
	//IMNCI staff trained 
		recode S9R1_q4services3 0=0 1/max=1, gen(training_imnci)		
	//Growth and Immunization staff trained 
		recode S9R1_q4services1 0=0 1/max=1, gen(training_growth)		
	//Child and Infant weighing scale  
		gen func_child_scale = 0
		replace func_child_scale = 1 if S11B_q1mch1 == 1 & S11B_q3function1 == 1
		gen func_infant_scale = 0
		replace func_infant_scale = 1 if S11B_q1mch2 == 1 & S11B_q3function2 == 1
		egen equip_child_infant_scale = rowmin(func_child_scale func_infant_scale) 	  
	//Length or Height board 
		gen func_heightboard_measuretape = 0 
		replace func_heightboard_measuretape = 1 if S11B_q1mch4 == 1 & S11B_q3function4 == 1
		gen func_length_board = 0
		replace func_length_board = 1 if S11B_q1mch5 == 1 & S11B_q3function5 == 1
		egen equip_length_height_board = rowmax(func_length_board func_heightboard_measuretape)	
	//Thermometer 
		gen equip_TM = 0  
		replace equip_TM = 1 if S11B_q1mch6 == 1 & S11B_q3function6 == 1
	//Stethoscope 
		gen equip_stet = 0  
		replace equip_stet = 1 if S11B_q1mch12 == 1 & S11B_q3function12 == 1
	//Haemoglobinometer: diag_hemog
	
	//Microscope and glass slides/cover 
		gen func_mic = 0
		replace func_mic = 1 if S11D_q1lab3 == 1 & S11D_q3function3 == 1
		gen func_slides = 0
		replace func_slides = 1 if S11D_q1lab4 == 1 & S11D_q3function4 == 1
		egen diag_mic_slides = rowmin(func_mic func_slides)
	//ORS 
		gen med_ORS = avai_S12A_q1available30
	//Albendazole 
		gen med_albendazole = avai_S12A_q1available1 
	//Zinc 
		gen med_zinc = avai_S12A_q1available36 
	//Retinol 
		gen med_retinol = avai_S12A_q1available33 
	//Paracetamol 
		egen med_paracet =rowmax(avai_S12A_q1available31 avai_S12A_q1available32) 
	//Amoxicillin 
		egen med_amox =rowmax(avai_S12A_q1available3 avai_S12A_q1available4) 
	
	//Calculation of Child Health SRI 
		egen child_health_sri=rowmean(guidelines_mch guidelines_imnci training_imnci ///
		training_growth equip_child_infant_scale equip_length_height_board equip_TM ///
		equip_stet diag_hemog diag_mic_slides med_ORS med_albendazole med_zinc ///
		med_retinol med_paracet med_amox)	
*------------------------------------------------------------------------------*	
* Tuberculosis Service Readiness Index

	//TB guidelines for diagnosis and treatment of TB; HIV TB co-infection; TB infection control **Q for 	Catherine - these are three separate indicators in SARA...should we weigh accordingly? 
		recode S10R1_q1available9 (1=1) (2/3=0), gen(guidelines_tb) 
	//TB guidelines for MDR-TB 
		recode S10R1_q1available8 (1=1) (2/3=0), gen(guidelines_mdrtb) 
	//TB staff trained 
		recode S9R1_q4services30 0=0 1/max=1, gen(tb_diagnosis_training)	
		recode S9R1_q4services31 0=0 1/max=1, gen(tb_treatment_training)	
		egen training_tb = rowmin(tb_diagnosis_training tb_treatment_training)
	//TB microscopy 
		recode S9R3_q1services22 2=0, g(AFB_test) //Note for Catherine - assuming AFB is same as ZN stain 
		egen diag_tb_mic = rowmin(AFB_test diag_mic_slides)
	//HIV diagnostics 
		recode S11D_q1lab11 2=0, g(diag_hiv)
	//First line TB medication 
		gen med_tb = avai_S12A_q1available15 
	
	//Calculation of TB SRI 
		egen tb_sri=rowmean(guidelines_tb guidelines_mdrtb training_tb diag_tb_mic ///
		diag_hiv med_tb)

*------------------------------------------------------------------------------*	
* Diabetes Service Readiness Index

	//Guidelines for diabetes diagnosis and treatment 
		recode S10R1_q1available26 (1=1) (2/3=0), gen(guidelines_ncd) 
	//Diabetes staff trained 
		recode S9R1_q4services19 0=0 1/max=1, gen(diab_diag_training)	
		recode S9R1_q4services20 0=0 1/max=1, gen(diab_treat_training)	
		egen training_diabetes = rowmin(diab_diag_training diab_treat_training)
	//blood pressure apparatus : equip_bp

	//adult scale 
		gen equip_adult_scale = 0  
		replace equip_adult_scale = 1 if S11B_q1mch11 == 1 & S11B_q3function11 == 1
		
	//measuring tape : func_heightboard_measuretape
	
	//blood glucose 
		gen diag_glucometer = 0  
		replace diag_glucometer = 1 if S11D_q1lab14 == 1 & S11D_q3function14 == 1
		recode S11D_q1lab15	2=0, g(diag_gluc_strips)
		egen diag_blood_glucose = rowmin(diag_glucometer diag_gluc_strips)
	//urine dipstick protein: diag_urine_dipstick
	//urine dipstick ketones: same as above - Q. for catherine - should we adjust weight since double 	counted? 
	//metformin 
		gen med_metformin = avai_S12A_q1available25
	//glibenclamide 
		gen med_glibenclamide = avai_S12A_q1available20
	//insulin 
		gen med_insulin = avai_S12A_q1available17
	
	//Calculation of Diabetes SRI 	
	egen diabetes_sri=rowmean(guidelines_ncd training_diabetes equip_bp ///
	equip_adult_scale diag_blood_glucose func_heightboard_measuretape ///
	diag_urine_dipstick med_metformin med_glibenclamide med_insulin)

*------------------------------------------------------------------------------*	
* CVD Service Readiness Index **Q for Catherine - is it okay to use CVD as proxy for hypertension? HHFA categorizes hyptertension as CVD - should this be titled CVD or hypertension?. Some below not related to hypertension (oxygen,asprin, metformin). HHFA categorizes hypertension as CVD 

	//CVD guidelines : guidelines_ncd
	//CVD staff trained *note for CA - staff training spec to hypertension, rest related to hypertension and CVD. 
		recode S9R1_q4services17 0=0 1/max=1, gen(hypertension_diag_training)	
		recode S9R1_q4services18 0=0 1/max=1, gen(hypertension_treat_training)	
		egen training_hypertension = rowmin(hypertension_diag_training hypertension_treat_training) 
	//stethescope : equip_stet
	//BP apparatus : equip_bp
	//Adult scale: equip_adult_scale 
	//Oxygen 
		gen func_oxygen_supply = 0 
		replace func_oxygen_supply = 1 if S11A_q1opd19 == 1 & S11A_q3function19 == 1
		recode S11A_q1opd18 2=0, g(equip_oxygen_cylinder)
		recode S11A_q1opd20	2=0, g(equip_oxygen_delivery)
		egen equip_oxygen = rowmin(func_oxygen_supply equip_oxygen_cylinder equip_oxygen_delivery)
	//ACE inhibitor 
		gen med_ACE_inhibitor = avai_S12A_q1available14
	//Hydrochlorothiazide 
		gen med_hydrochlorothiazide  = avai_S12A_q1available22
	//beta blocker 
		gen med_beta_blocker = avai_S12A_q1available8
	//calcium channel blocker 
		gen med_calcium_channel_blocker = avai_S12A_q1available2
	//Aspirin 
		gen med_asprin = avai_S12A_q1available7
	//Metformin: med_metformin
	
	//Calculation of CVD SRI 

		egen cvd_sri=rowmean(guidelines_ncd training_hypertension equip_stet ///
		equip_bp equip_adult_scale equip_oxygen med_ACE_inhibitor med_hydrochlorothiazide ///
		med_beta_blocker med_calcium_channel_blocker med_asprin med_metformin)

*------------------------------------------------------------------------------*	
* Mental Health Service Readiness Index **Note for Catherine - need provider to cross check meds 

	//staff trained mental health 
		recode S9R1_q4services23 0=0 1/max=1, gen(mh_diagnosis_training)	
		recode S9R1_q4services24 0=0 1/max=1, gen(mh_management_training)	
		egen training_mental_health = rowmin(mh_diagnosis_training mh_management_training)
	//fluoxetine *Q for Catherine - this is relevant for 2 HHFA indicators- depression and OCD. should we weigh accordingy? 
		gen med_fluoxetine = avai_S12A_q1available18
	//Haloperiodol
		gen med_haloperiodol = avai_S12A_q1available21
	//Carbamazapine 
		gen med_carbamazapine = avai_S12A_q1available11

	//Calculation of Mental Health SRI 	
		egen mental_health_sri=rowmean(training_mental_health med_fluoxetine ///
		med_haloperiodol med_carbamazapine)

	
*------------------------------------------------------------------------------*	
* BHUTAN COMPOSITE PHC SERVICE READINESS INDEX 

	egen phc_sri=rowmean(gen_amenities_sri gen_infect_prev_sri anc_sri ///
						 child_health_sri tb_sri diabetes_sri cvd_sri ///
						 mental_health_sri)

	keep strata_region strata_hftype S1B_q5hfcode *_sri S1B_q1dzongkhag
	rename (S1B_q5hfcode S1B_q1dzongkhag) (facid district)
	sort facid
	
	foreach var in gen_amenities_sri gen_infect_prev_sri anc_sri child_health_sri tb_sri diabetes_sri cvd_sri ///
						mental_health_sri phc_sri {
							replace `var'= `var'*100
					}	
	
	lab var gen_amenities_sri "Necessary inputs general service readiness - amenities"
	lab var gen_infect_prev_sri "Necessary inputs general service readiness - infection prevention"
	lab var anc_sri "Necessary inputs ANC"
	lab var child_health_sri "Necessary inputs child health"
	lab var tb_sri "Necessary inputs TB"
	lab var diabetes_sri "Necessary inputs diabetes"
	lab var cvd_sri  "Necessary inputs CVD"
	lab var mental_health_sri "Necessary inputs mental health" 
	lab var phc_sri "Average service readiness"
	
	save "$user/$analysis/Bhutan_facility.dta", replace
	
