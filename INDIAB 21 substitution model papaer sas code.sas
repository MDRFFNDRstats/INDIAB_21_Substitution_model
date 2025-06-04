/******************************************************************************/
/* Program     : Indiab_nature_medi_analysis.sas                               */
/* Purpose     : Calculate survey-based macro-nutrient distribution and        */
/* generate derived variables such as %Energy, BMI category,     */
/* and risk indicators for cardiometabolic conditions            */
/* Author      : Abirami K, Biostatistician, FNDR, MDRF, Gopalapuram          */
/* Created Date: 17/05/2025                                                 */
/* SAS Version : 9.4                                                          */
/******************************************************************************/

/*----------------------------------------------------------------------------*/
/* Step 1: Assign library for saving and reading datasets                     */
/*----------------------------------------------------------------------------*/
libname Indiab "E:\Server Backup\Downloads\SAS_code\SAS_abi\data\nature medicine indiab work substitution model paper rework";
/* Assigns a library reference named 'Indiab' to the specified directory. */
run;
/* Executes the preceding SAS statements. */

/*----------------------------------------------------------------------------*/
/* Step 2: Import master dataset from Excel                                    */
/*----------------------------------------------------------------------------*/
proc import
    out=Indiab.For_substitution
    /* Specifies the output SAS dataset name as 'For_substitution' in the 'Indiab' library. */
    datafile="E:\Server Backup\Downloads\SAS_code\SAS_abi\data\nature medicine indiab work substitution model paper rework\INDIAB maserdataset28-12-2024.XLSX"
    /* Specifies the path and filename of the input Excel file. */
    dbms=xlsx replace;
    /* Specifies the database management system as XLSX (Excel) and overwrites the output dataset if it already exists. */
    sheet="master07-01-2024";
    /* Specifies the name of the sheet to import from the Excel file. */
run;
/* Executes the PROC IMPORT step, importing the data. */

/*----------------------------------------------------------------------------*/
/* Step 3: Create derived variables related to macro-nutrient composition     */
/*----------------------------------------------------------------------------*/
data Indiab.For_substitution;
    /* Creates a new SAS dataset named 'For_substitution' in the 'Indiab' library or overwrites it. */
    set Indiab.For_substitution;
    /* Reads observations from the existing 'For_substitution' dataset in the 'Indiab' library. */

    /* Total energy calculation */
    MAC_NUTRI_CALC_energy =
        (Carbohydrates_g_unadj * 4) +
        (Protein_g_unadj * 4) +
        (Fat_g_unadj * 9) +
        (Energy_unadjusted_Alcohol__g * 7);
    /* Calculates total energy intake based on unadjusted macronutrient grams and their respective factors (Carbs: 4 kcal/g, Protein: 4 kcal/g, Fat: 9 kcal/g, Alcohol: 7 kcal/g). */

    /* Percent energy contribution from macronutrients */
    MAC_NUTRI_CALC_carbohydrate_E = (Carbohydrates_g_unadj * 4) / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from carbohydrates. */
    MAC_NUTRI_CALC_Protein_E     = (Protein_g_unadj * 4) / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from protein. */
    MAC_NUTRI_CALC_Fat_E         = (Fat_g_unadj * 9) / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from fat. */
    MAC_NUTRI_CALC_SFA_E         = (SFA_g_unadj * 9) / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from saturated fatty acids (SFA). */
    MAC_NUTRI_CALC_MUFA_E        = (MUFA_g_unadj * 9) / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from monounsaturated fatty acids (MUFA). */
    MAC_NUTRI_CALC_PUFA_E        = (PUFA_g_unadj * 9) / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from polyunsaturated fatty acids (PUFA). */
    MAC_NUTRI_CALC_PUFA_n3_E     = (PUFA_n3_unadj * 9) / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from omega-3 polyunsaturated fatty acids (PUFA n-3). */
    MAC_NUTRI_CALC_PUFA_n6_E     = (PUFA_n6_unadj * 9) / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from omega-6 polyunsaturated fatty acids (PUFA n-6). */
    MAC_NUTRI_CALC_alcohol_E     = (Energy_unadjusted_Alcohol__g * 7) / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from alcohol. */

    /* Protein source breakdown */
    MAC_NUTRI_CALC_animal_pro_E  = animal_protein_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from animal protein. */
    Animal_protein_withdairy_g   = animal_pro_g + Milk_protein_g;
    /* Calculates the total grams of animal protein including milk protein. */
    Animal_withmilk_pro_E        = Animal_protein_withdairy_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from animal protein including milk protein. */

    MAC_NUTRI_CALC_plat_pro_E    = plain_protein_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from plant protein (excluding milk). */
    plantprotein_withmilk        = plain_protein_g + Milk_protein_g;
    /* Calculates the total grams of plant protein including milk protein. */
    plant_withmilk_pro_E         = plantprotein_withmilk * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from plant protein including milk protein. */

    MAC_NUTRI_CALC_Milk_pro_E    = Milk_protein_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from milk protein. */
    fermented_Milk_pro_E         = Fermen_milk_pro_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from fermented milk protein. */
    nonfermented_Milk_pro_E      = Nonferm_milk_pro_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from non-fermented milk protein. */

    /* Refined and whole carbohydrate sources */
    MAC_NUTRI_CALC_refcarb_E     = Refined_cereals_carb_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from refined carbohydrates. */
    MAC_NUTRI_CALC_wholecarb_E   = Whole_cereals_carb_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from whole carbohydrates. */
    MAC_NUTRI_CALC_ricecarb_E    = Whiterice_carb_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from rice carbohydrates. */
    MAC_NUTRI_CALC_wheatcarb_E   = wheat_cereals_carb_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from wheat carbohydrates. */
    MAC_NUTRI_CALC_milletcarb_E  = Milletall_carb_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from millet carbohydrates. */

    /* Other sources */
    Pulses_legumes_pro_E_no0     = Pulses_legumes_pro_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from pulses and legumes protein. */
    cereal_pro_g               = Refined_cereals_pro_g + wheat_pro_g + Milletall_pro_g;
    /* Calculates the total grams of protein from all cereals. */
    cereal_protein_E_no0       = cereal_pro_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from cereal protein. */

    /* Added sugar and fiber */
    added_sugar_E_no0          = added_Sugar_no0 * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from added sugar. */
    MAC_NUTRI_CALC_FIBRE_e     = Fibre_g_unadj * 2 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from fiber (assuming 2 kcal/g). */

    /* Detailed animal protein components */
    MAC_NUTRI_CALC_Redmeat_pro_E = redmeat_pro_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from red meat protein. */
    MAC_NUTRI_CALC_egg_pro_E     = egg_egg_pro_pro_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from egg protein. */
    MAC_NUTRI_CALC_Poultry_pro_E = poultry_pro_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from poultry protein. */
    MAC_NUTRI_CALC_Fish_pro_E    = fish_pro_g * 4 / MAC_NUTRI_CALC_energy * 100;
    /* Calculates the percentage of total energy derived from fish protein. */

    /* Step 4: BMI Categorization based on Asian Cut-offs */
    if BMI < 18.5 then BMI_Asian_cutoff = 0;
    /* Assigns 0 if BMI is less than 18.5 (Underweight). */
    else if BMI < 23 then BMI_Asian_cutoff = 1;
    /* Assigns 1 if BMI is between 18.5 and 22.9 (Normal). */
    else if BMI < 27.5 then BMI_Asian_cutoff = 2;
    /* Assigns 2 if BMI is between 23 and 27.4 (Overweight). */
    else BMI_Asian_cutoff = 3;
    /* Assigns 3 if BMI is 27.5 or greater (Obese). */

    /* General Obesity cut-off based on 25 */
    if BMI < 25 then Generalise_obesity_25_based = 0;
    /* Assigns 0 if BMI is less than 25 (Not obese based on general cut-off). */
    else Generalise_obesity_25_based = 1;
    /* Assigns 1 if BMI is 25 or greater (Obese based on general cut-off). */

    /* Age category */
    if age < 60 then Age_code = 0;
    /* Assigns 0 if age is less than 60. */
    else Age_code = 1;
    /* Assigns 1 if age is 60 or greater. */

    /* Region mapping */
    if Region_code = 1 then region = "North";
    /* Assigns "North" if Region_code is 1. */
    else if Region_code = 2 then region = "South";
    /* Assigns "South" if Region_code is 2. */
    else if Region_code = 3 then region = "East";
    /* Assigns "East" if Region_code is 3. */
    else if Region_code = 4 then region = "West";
    /* Assigns "West" if Region_code is 4. */
    else if Region_code = 5 then region = "Central";
    /* Assigns "Central" if Region_code is 5. */
    else if Region_code = 6 then region = "Northeast";
    /* Assigns "Northeast" if Region_code is 6. */

    /* Area type */
    if Urm_code = 0 then URM = "Urban";
    /* Assigns "Urban" if Urm_code is 0. */
    else if Urm_code = 1 then URM = "Rural";
    /* Assigns "Rural" if Urm_code is 1. */

    /* Gender */
    if sex_code = 0 then Gender = "Male";
    /* Assigns "Male" if sex_code is 0. */
    else if sex_code = 1 then Gender = "Female";
    /* Assigns "Female" if sex_code is 1. */

    /* Lifestyle categories */
    if smoking = 1 then smoking_cat = "Never";
    /* Assigns "Never" if smoking code is 1. */
    else if smoking = 2 then smoking_cat = "Past";
    /* Assigns "Past" if smoking code is 2. */
    else if smoking = 3 then smoking_cat = "Current";
    /* Assigns "Current" if smoking code is 3. */

    if Alcohol = 1 then Alcohol_cat = "Never";
    /* Assigns "Never" if Alcohol code is 1. */
    else if Alcohol = 2 then Alcohol_cat = "Past";
    /* Assigns "Past" if Alcohol code is 2. */
    else if Alcohol = 3 then Alcohol_cat = "Current";
    /* Assigns "Current" if Alcohol code is 3. */

    if Pal_code = 1 then Pal_code_cat = "Vigorous";
    /* Assigns "Vigorous" if Physical Activity Level (Pal_code) is 1. */
    else if Pal_code = 2 then Pal_code_cat = "Moderate";
    /* Assigns "Moderate" if Pal_code is 2. */
    else if Pal_code = 3 then Pal_code_cat = "Sedentary";
    /* Assigns "Sedentary" if Pal_code is 3. */

    /* Clinical status variables */
    if NDD_cat = 0 then NDD_code = "No";
    /* Assigns "No" if NDD_cat is 0. */
    else if NDD_cat = 1 then NDD_code = "Yes";
    /* Assigns "Yes" if NDD_cat is 1. */

    if PD_cat = 0 then PD_code = "No";
    /* Assigns "No" if Pre-Diabetes (PD_cat) is 0. */
    else if PD_cat = 1 then PD_code = "Yes";
    /* Assigns "Yes" if PD_cat is 1. */

    if Dyslipideamia = 0 then Dyslipideamia_code = "No";
    /* Assigns "No" if Dyslipideamia is 0. */
    else if Dyslipideamia = 1 then Dyslipideamia_code = "Yes";
    /* Assigns "Yes" if Dyslipideamia is 1. */

    if Hypertension = 0 then Hypertension_code = "No";
    /* Assigns "No" if Hypertension is 0. */
    else if Hypertension = 1 then Hypertension_code = "Yes";
    /* Assigns "Yes" if Hypertension is 1. */

    if Overweight_BMI_above22_9 = 0 then OverweightBMIabove22_9_code = "No";
    /* Assigns "No" if Overweight (BMI < 22.9) is 0. */
    else if Overweight_BMI_above22_9 = 1 then OverweightBMIabove22_9_code = "Yes";
    /* Assigns "Yes" if Overweight (BMI > 22.9) is 1. */

    if GeneralisedobesityBMI_above27_5 = 0 then General_obesity_code = "No";
    /* If the indicator for generalized obesity (BMI < 27.5) is 0, assign "No" to General_obesity_code. */
    else if GeneralisedobesityBMI_above27_5 = 1 then General_obesity_code = "Yes";
    /* Otherwise (if the indicator is 1), assign "Yes" to General_obesity_code. */

    if Abdominal_obesity_Waist = 0 then Abdominal_obesity_code = "No";
    /* If the indicator for abdominal obesity (based on waist circumference) is 0, assign "No" to Abdominal_obesity_code. */
    else if Abdominal_obesity_Waist = 1 then Abdominal_obesity_code = "Yes";
    /* Otherwise (if the indicator is 1), assign "Yes" to Abdominal_obesity_code. */

    if Generalise_obesity_25_based = 0 then Generalise_obesity_25_code = "No";
    /* If the indicator for generalized obesity (BMI < 25) is 0, assign "No" to Generalise_obesity_25_code. */
    else if Generalise_obesity_25_based = 1 then Generalise_obesity_25_code = "Yes";
    /* Otherwise (if the indicator is 1), assign "Yes" to Generalise_obesity_25_code. */

    /* Derived indicator variables */
    if PD_cat = 1 or NDD_cat = 1 then dysglycemia = 1;
    /* If Pre-Diabetes (PD_cat) or Newly diagnosed Disease (NDD_cat) is 1, then assign 1 (Yes) to the dysglycemia indicator. */
    else dysglycemia = 0;
    /* Otherwise, assign 0 (No) to the dysglycemia indicator. */

    if PD_cat = 1 or NDD_cat = 1 or Dyslipideamia = 1 or Hypertension = 1
        or GeneralisedobesityBMI_above27_5 = 1 or Abdominal_obesity_Waist = 1 then cardio_met_risk = 1;
    /* If any of the cardiometabolic risk factors (Pre-Diabetes/Diabetes, Dyslipidemia, Hypertension, Generalized Obesity (BMI > 27.5), or Abdominal Obesity) are present (indicated by a value of 1), then assign 1 (Yes) to the cardio_met_risk indicator. */
    else cardio_met_risk = 0;
    /* Otherwise, assign 0 (No) to the cardio_met_risk indicator. */

    /* Education level (if transformation needed) */
    if edu_code=0 then edu_code=1;
    if edu_code=1 then edu_code=1;
    if edu_code=2 then edu_code=2;
    if edu_code=3 then edu_code=3;
    /* If the education code (edu_code) is 0, change it to 1. This suggests a potential recoding or standardization of education levels. */

    /* Cooking oil categorization */
    if ckoil = 1 then cooking_oil = "Mustard oil";
    /* If the cooking oil code (ckoil) is 1, assign "Mustard oil" to the cooking_oil variable. */
    else if ckoil = 2 then cooking_oil = "Coconut oil";
    /* If ckoil is 2, assign "Coconut oil". */
    else if ckoil = 3 then cooking_oil = "Groundnut Oil";
    /* If ckoil is 3, assign "Groundnut Oil". */
    else if ckoil = 4 then cooking_oil = "Sunflower oil";
    /* If ckoil is 4, assign "Sunflower oil". */
    else if ckoil = 5 then cooking_oil = "Soyabean oil";
    /* If ckoil is 5, assign "Soyabean oil". */
    else if ckoil = 6 then cooking_oil = "Palm oil";
    /* If ckoil is 6, assign "Palm oil". */
    else if ckoil = 7 then cooking_oil = "Vanaspathi";
    /* If ckoil is 7, assign "Vanaspathi". */
    else if ckoil = 8 then cooking_oil = "Ghee";
    /* If ckoil is 8, assign "Ghee". */
    else if ckoil = 9 then cooking_oil = "Butter";
    /* If ckoil is 9, assign "Butter". */
run;
/* Executes the preceding DATA step, creating or modifying the 'Indiab.For_substitution' dataset with the newly derived variables and recoded values. */


/*----------------------------------------------------------------------------*/
/* Step 4: Check Normality for Multiple Variables and Store Results           */
/*----------------------------------------------------------------------------*/
ods output TestsForNormality=norm_results;
proc univariate data=Indiab.For_substitution normal;
    var age
    BMI
    WC_cm
    SBP
    DBP
    FBS
    HbA1c
    Tri_Glyceride
    HDL
    LDL
    MAC_NUTRI_CALC_energy
    MAC_NUTRI_CALC_carbohydrate_E
    MAC_NUTRI_CALC_refcarb_E
    MAC_NUTRI_CALC_wholecarb_E
    added_sugar_E_no0
    MAC_NUTRI_CALC_Fat_E
    MAC_NUTRI_CALC_SFA_E
    MAC_NUTRI_CALC_MUFA_E
    MAC_NUTRI_CALC_PUFA_E
    MAC_NUTRI_CALC_PUFA_n6_E
    MAC_NUTRI_CALC_PUFA_n3_E
    MAC_NUTRI_CALC_Protein_E
    MAC_NUTRI_CALC_plat_pro_E
    MAC_NUTRI_CALC_Milk_pro_E
    fermented_Milk_pro_E
    nonfermented_Milk_pro_E
    MAC_NUTRI_CALC_animal_pro_E
    MAC_NUTRI_CALC_Redmeat_pro_E
    MAC_NUTRI_CALC_egg_pro_E
    MAC_NUTRI_CALC_Poultry_pro_E
    MAC_NUTRI_CALC_Fish_pro_E
    plant_withmilk_pro_E
    Animal_withmilk_pro_E; /* Add multiple variables */
run;

/* Create a categorical variable for normality results */
data norm_results_final;
    set norm_results;
    if Test in ("Kolmogorov-Smirnov", "Anderson-Darling", "Cramer-von Mises") then do;
        if pValue >= 0.05 then Normality_Status = "Normally Distributed";
        else Normality_Status = "Not Normally Distributed";
    end;
run;

/* Print final normality results */
proc print data=norm_results_final noobs;
    var VarName Test pValue Normality_Status;
run;
/*----------------------------------------------------------------------------*/
/* Step 5: Calculate weighted median and Inter quartiles by Region                 */
/*----------------------------------------------------------------------------*/
proc surveymeans data = Indiab.For_substitution median Q1 Q3;
    /* PROC SURVEYMEANS calculates descriptive statistics for survey data, */
    /* taking into account the complex survey design. */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable to be used in the calculations, */
    /* accounting for the sampling probability. */
    cluster PSUNo ;
    /* Specifies the primary sampling unit (PSU) variable, used to */
    /* account for clustering in the survey design. */
    strata state_code;
    /* Specifies the stratification variable, used to account for */
    /* different sampling rates across strata (states). */
    var  age
    BMI
    WC_cm
    SBP
    DBP
    FBS
    HbA1c
    Tri_Glyceride
    LDL HDL
    MAC_NUTRI_CALC_energy
    MAC_NUTRI_CALC_carbohydrate_E
    MAC_NUTRI_CALC_refcarb_E
    MAC_NUTRI_CALC_wholecarb_E
    added_sugar_E_no0
    MAC_NUTRI_CALC_Fat_E
    MAC_NUTRI_CALC_SFA_E
    MAC_NUTRI_CALC_MUFA_E
    MAC_NUTRI_CALC_PUFA_E
    MAC_NUTRI_CALC_PUFA_n6_E
    MAC_NUTRI_CALC_PUFA_n3_E
    MAC_NUTRI_CALC_Protein_E
    MAC_NUTRI_CALC_plat_pro_E
    MAC_NUTRI_CALC_Milk_pro_E
    fermented_Milk_pro_E
    nonfermented_Milk_pro_E
    MAC_NUTRI_CALC_animal_pro_E
    MAC_NUTRI_CALC_Redmeat_pro_E
    MAC_NUTRI_CALC_Poultry_pro_E
    MAC_NUTRI_CALC_egg_pro_E
    MAC_NUTRI_CALC_Fish_pro_E
    plant_withmilk_pro_E
    Animal_withmilk_pro_E ;
    /* Specifies the variables for which weighted median (MEDIAN), */
    /* first quartile (Q1), and third quartile (Q3) will be calculated. */
    domain region_code ;
    /* Specifies that the statistics will be calculated separately for */
    /* each category of the 'region_code' variable. */
run;
/* Executes the PROC SURVEYMEANS step for region. */

/*----------------------------------------------------------------------------*/
/* Step 6: Calculate weighted median and Inter quartiles by place of residence (Urban/Rural) */
/*----------------------------------------------------------------------------*/
proc surveymeans data = Indiab.For_substitution median Q1 Q3;
    /* PROC SURVEYMEANS calculates descriptive statistics for survey data, */
    /* taking into account the complex survey design. */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable. */
    cluster PSUNo ;
    /* Specifies the cluster variable. */
    strata state_code;
    /* Specifies the strata variable. */
    var  age
    BMI
    WC_cm
    SBP
    DBP
    FBS
    HbA1c
    Tri_Glyceride
    LDL HDL
    MAC_NUTRI_CALC_energy
    MAC_NUTRI_CALC_carbohydrate_E
    MAC_NUTRI_CALC_refcarb_E
    MAC_NUTRI_CALC_wholecarb_E
    added_sugar_E_no0
    MAC_NUTRI_CALC_Fat_E
    MAC_NUTRI_CALC_SFA_E
    MAC_NUTRI_CALC_MUFA_E
    MAC_NUTRI_CALC_PUFA_E
    MAC_NUTRI_CALC_PUFA_n6_E
    MAC_NUTRI_CALC_PUFA_n3_E
    MAC_NUTRI_CALC_Protein_E
    MAC_NUTRI_CALC_plat_pro_E
    MAC_NUTRI_CALC_Milk_pro_E
    fermented_Milk_pro_E
    nonfermented_Milk_pro_E
    MAC_NUTRI_CALC_animal_pro_E
    MAC_NUTRI_CALC_Redmeat_pro_E
    MAC_NUTRI_CALC_Poultry_pro_E
    MAC_NUTRI_CALC_egg_pro_E
    MAC_NUTRI_CALC_Fish_pro_E
    plant_withmilk_pro_E
    Animal_withmilk_pro_E ;
    /* Specifies the variables for which weighted median and Inter quartiles are calculated. */
    domain urm_code ;
    /* Specifies that the statistics will be calculated separately for */
    /* each category of the 'urm_code' variable (Urban/Rural). */
run;
/* Executes the PROC SURVEYMEANS step for urban/rural. */

/*----------------------------------------------------------------------------*/
/* Step 7: Calculate weighted median and Inter quartiles by Gender                  */
/*----------------------------------------------------------------------------*/
proc surveymeans data = Indiab.For_substitution median Q1 Q3;
    /* PROC SURVEYMEANS for weighted descriptive statistics. */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable. */
    cluster PSUNo ;
    /* Specifies the cluster variable. */
    strata state_code;
    /* Specifies the strata variable. */
    var  age
    BMI
    WC_cm
    SBP
    DBP
    FBS
    HbA1c
    Tri_Glyceride
    LDL HDL
    MAC_NUTRI_CALC_energy
    MAC_NUTRI_CALC_carbohydrate_E
    MAC_NUTRI_CALC_refcarb_E
    MAC_NUTRI_CALC_wholecarb_E
    added_sugar_E_no0
    MAC_NUTRI_CALC_Fat_E
    MAC_NUTRI_CALC_SFA_E
    MAC_NUTRI_CALC_MUFA_E
    MAC_NUTRI_CALC_PUFA_E
    MAC_NUTRI_CALC_PUFA_n6_E
    MAC_NUTRI_CALC_PUFA_n3_E
    MAC_NUTRI_CALC_Protein_E
    MAC_NUTRI_CALC_plat_pro_E
    MAC_NUTRI_CALC_Milk_pro_E
    fermented_Milk_pro_E
    nonfermented_Milk_pro_E
    MAC_NUTRI_CALC_animal_pro_E
    MAC_NUTRI_CALC_Redmeat_pro_E
    MAC_NUTRI_CALC_Poultry_pro_E
    MAC_NUTRI_CALC_egg_pro_E
    MAC_NUTRI_CALC_Fish_pro_E
    plant_withmilk_pro_E
    Animal_withmilk_pro_E ;
    /* Specifies the variables. */
    domain gender;
    /* Specifies that the statistics will be calculated separately for */
    /* each category of the 'gender' variable. */
run;
/* Executes the PROC SURVEYMEANS step for gender. */

/*----------------------------------------------------------------------------*/
/* Step 8: Calculate weighted median and Inter quartiles by Region and State       */
/*----------------------------------------------------------------------------*/
proc surveymeans data = Indiab.For_substitution median Q1 Q3;
    /* PROC SURVEYMEANS for weighted descriptive statistics. */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable. */
    cluster PSUNo ;
    /* Specifies the cluster variable. */
    strata state_code;
    /* Specifies the strata variable. */
    var
    MAC_NUTRI_CALC_carbohydrate_E
    MAC_NUTRI_CALC_refcarb_E
    MAC_NUTRI_CALC_wholecarb_E
    added_sugar_E_no0
    MAC_NUTRI_CALC_Fat_E
    MAC_NUTRI_CALC_SFA_E
    MAC_NUTRI_CALC_MUFA_E
    MAC_NUTRI_CALC_PUFA_E
    MAC_NUTRI_CALC_PUFA_n6_E
    MAC_NUTRI_CALC_PUFA_n3_E
    MAC_NUTRI_CALC_Protein_E
    MAC_NUTRI_CALC_plat_pro_E
    MAC_NUTRI_CALC_Milk_pro_E
    fermented_Milk_pro_E
    nonfermented_Milk_pro_E
    MAC_NUTRI_CALC_animal_pro_E
    MAC_NUTRI_CALC_Redmeat_pro_E
    MAC_NUTRI_CALC_egg_pro_E
    MAC_NUTRI_CALC_Poultry_pro_E
    MAC_NUTRI_CALC_Fish_pro_E
    plant_withmilk_pro_E
    Animal_withmilk_pro_E;
    /* Specifies the macronutrient percentage variables. */
    domain region_code * states;
    /* Specifies that the statistics will be calculated separately for */
    /* each combination of 'region_code' and 'states'. */
run;
/* Executes the PROC SURVEYMEANS step for region and state. */

/*----------------------------------------------------------------------------*/
/* Step 9: Analyze weighted frequencies and associations by Region           */
/*----------------------------------------------------------------------------*/
proc surveyfreq data=Indiab.For_substitution;
    /* PROC SURVEYFREQ performs frequency and cross-tabulation analyses for */
    /* survey data, accounting for complex survey designs. */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable. */
    cluster PSUNo;
    /* Specifies the cluster variable. */
    strata state_code;
    /* Specifies the strata variable. */
    tables region_code*gender
    /* Generates a two-way frequency table of 'region_code' and 'gender'. */
    region_code*Smoking_Yes_No
    /* Table of 'region_code' and 'Smoking_Yes_No'. */
    region_code*Alcohol_Yes_No
    /* Table of 'region_code' and 'Alcohol_Yes_No'. */
    region_code*Pal_code
    /* Table of 'region_code' and 'Pal_code' (Physical Activity Level). */
    region_code*Fam_his_yes_No
    /* Table of 'region_code' and 'Fam_his_yes_No' (Family History). */
    region_code*Overweight_BMI_above22_9
    /* Table of 'region_code' and 'Overweight_BMI_above22_9'. */
    region_code*GeneralisedobesityBMI_above25
    /* Table of 'region_code' and 'GeneralisedobesityBMI_above25'. */
    region_code*Abdominal_obesity_Waist
    /* Table of 'region_code' and 'Abdominal_obesity_Waist'. */
    region_code*Hypertension
    /* Table of 'region_code' and 'Hypertension'. */
    region_code*NDD_cat
    /* Table of 'region_code' and 'NDD_cat' (Newly diagnosed diabetes category). */
    region_code*PD_cat
    /* Table of 'region_code' and 'PD_cat' (Pre-Diabetes category). */
    region_code*Dyslipideamia
    /* Table of 'region_code' and 'Dyslipideamia'. */
    region_code*cardio_met_risk
    /* Table of 'region_code' and 'cardio_met_risk'. */
    / expected row col chisq lrchisq wchisq wllchisq;
    /* Requests expected frequencies under independence, row and column percentages, */
    /* and various chi-square tests for association (Pearson, likelihood ratio, */
    /* Wald chi-square, and Wald log-likelihood chi-square), adjusted for the survey design. */
run;
/* Executes the PROC SURVEYFREQ step for region-based analyses. */

/*----------------------------------------------------------------------------*/
/* Step 10: Analyze weighted frequencies and associations by place of residence       */
/*----------------------------------------------------------------------------*/
proc surveyfreq data=Indiab.For_substitution;
    /* PROC SURVEYFREQ for weighted frequency and cross-tabulation analyses. */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable. */
    cluster PSUNo;
    /* Specifies the cluster variable. */
    strata state_code;
    /* Specifies the strata variable. */
    tables urm_code*gender
    /* Table of 'urm_code' (Urban/Rural) and 'gender'. */
    urm_code*Smoking_Yes_No
    /* Table of 'urm_code' and 'Smoking_Yes_No'. */
    urm_code*Alcohol_Yes_No
    /* Table of 'urm_code' and 'Alcohol_Yes_No'. */
    urm_code*Pysically_active_yes_no
    /* Table of 'urm_code' and 'Pysically_active_yes_no'. */
    urm_code*Fam_his_yes_No
    /* Table of 'urm_code' and 'Fam_his_yes_No'. */
    urm_code*Overweight_BMI_above22_9
    /* Table of 'urm_code' and 'Overweight_BMI_above22_9'. */
    urm_code*GeneralisedobesityBMI_above25
    /* Table of 'urm_code' and 'GeneralisedobesityBMI_above25'. */
    urm_code*Abdominal_obesity_Waist
    /* Table of 'urm_code' and 'Abdominal_obesity_Waist'. */
    urm_code*Hypertension
    /* Table of 'urm_code' and 'Hypertension'. */
    urm_code*NDD_cat
    /* Table of 'urm_code' and 'NDD_cat'. */
    urm_code*PD_cat
    /* Table of 'urm_code' and 'PD_cat'. */
    urm_code*Dyslipideamia
    /* Table of 'urm_code' and 'Dyslipideamia'. */
    urm_code*cardio_met_risk
    /* Table of 'urm_code' and 'cardio_met_risk'. */
    / expected row col chisq lrchisq wchisq wllchisq;
    /* Requests expected frequencies, row and column percentages, and chi-square tests. */
run;
/* Executes the PROC SURVEYFREQ step for area type-based analyses. */

/*----------------------------------------------------------------------------*/
/* Step 11: Analyze weighted frequencies and associations by Gender          */
/*----------------------------------------------------------------------------*/
proc surveyfreq data=Indiab.For_substitution;
    /* PROC SURVEYFREQ for weighted frequency and cross-tabulation analyses. */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable. */
    cluster PSUNo;
    /* Specifies the cluster variable. */
    strata state_code;
    /* Specifies the strata variable. */
    tables
    gender*Smoking_Yes_No
    /* Table of 'gender' and 'Smoking_Yes_No'. */
    gender*Alcohol_Yes_No
    /* Table of 'gender' and 'Alcohol_Yes_No'. */
    gender*Pysically_active_yes_no
    /* Table of 'gender' and 'Pysically_active_yes_no'. */
    gender*Fam_his_yes_No
    /* Table of 'gender' and 'Fam_his_yes_No'. */
    gender*Overweight_BMI_above22_9
    /* Table of 'gender' and 'Overweight_BMI_above22_9'. */
    gender*GeneralisedobesityBMI_above25
    /* Table of 'gender' and 'GeneralisedobesityBMI_above25'. */
    gender*Abdominal_obesity_Waist
    /* Table of 'gender' and 'Abdominal_obesity_Waist'. */
    gender*Hypertension
    /* Table of 'gender' and 'Hypertension'. */
    gender*NDD_cat
    /* Table of 'gender' and 'NDD_cat'. */
    gender*PD_cat
    /* Table of 'gender' and 'PD_cat'. */
    gender*Dyslipideamia
    /* Table of 'gender' and 'Dyslipideamia'. */
    gender*cardio_met_risk
    /* Table of 'gender' and 'cardio_met_risk'. */
    / expected row col chisq lrchisq wchisq wllchisq;
    /* Requests expected frequencies, row and column percentages, and chi-square tests. */
run;
/* Executes the PROC SURVEYFREQ step for gender-based analyses. */

/*----------------------------------------------------------------------------*/
/* Step 12: Analyze weighted frequencies of Main Staple Eaters by State within Region */
/*----------------------------------------------------------------------------*/
proc sort data=Indiab.For_substitution;by  region_code;run;
/* Sorts the dataset 'Indiab.For_substitution' by 'region_code'. This is */
/* done to facilitate BY-group processing in the subsequent PROC SURVEYFREQ. */
proc surveyfreq data=Indiab.For_substitution;by  region_code;
    /* PROC SURVEYFREQ for weighted frequency and cross-tabulation analyses, */
    /* processed separately for each 'region_code'. */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable. */
    cluster PSUNo;
    /* Specifies the cluster variable. */
    tables
    states*Main_staple_eaters/ expected row col chisq lrchisq wchisq wllchisq;
    /* Generates a two-way frequency table of 'states' and 'Main_staple_eaters' */
    /* within each 'region_code'. Also requests expected frequencies, row and */
    /* column percentages, and chi-square tests. */
;
run;

/*--------------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------Substituion model analysis-----------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
/* Step 13: every % of nutrient conversion code */
/*----------------------------------------------------------------------------*/
/* Executes the PROC SURVEYFREQ step for staple food analysis by state within region. */
%macro nutrient_conversion(factor);
    /*
     * Macro to create new variables representing each macronutrient's
     * percentage of energy divided by a specified factor. This is likely
     * for analyzing the effect of substituting a certain percentage
     * of energy from one nutrient with another.
     *
     * Parameter:
     * factor - The divisor for the percentage of energy (e.g., 5 for every 5%).
     */
    data Indiab.For_substitution;
        set Indiab.For_substitution;
        /* Reads the existing 'Indiab.For_substitution' dataset. */
        Carbohydrate_E_&factor._per_sub = MAC_NUTRI_CALC_carbohydrate_E / &factor.;                         
        Protein_E_&factor._per_substu = MAC_NUTRI_CALC_Protein_E / &factor.;
		fat_E_&factor._per_substu = MAC_NUTRI_CALC_Fat_E / &factor.;
        animal_Protein_E_&factor._per_substu = MAC_NUTRI_CALC_animal_pro_E / &factor.;
        anim_milk_Protein_E_&factor._per_substu = animal_withmilk_pro_E / &factor.;
        Plant_Protein_E_&factor._per_substu = MAC_NUTRI_CALC_plat_pro_E / &factor.;
        Fat_E_&factor._per_substu = MAC_NUTRI_CALC_Fat_E / &factor.;
        SFA_E_&factor._per_substu = MAC_NUTRI_CALC_SFA_E / &factor.;
        MUFA_E_&factor._per_substu = MAC_NUTRI_CALC_MUFA_E / &factor.;
        PUFA_E_&factor._per_substu = MAC_NUTRI_CALC_PUFA_E / &factor.;
        PUFA_n6_E_&factor._per_substu = MAC_NUTRI_CALC_PUFA_n6_E / &factor.;
        PUFA_n3_E_&factor._per_substu = MAC_NUTRI_CALC_PUFA_n3_E / &factor.;

		 Redmeat_pro_E_&factor._per_substu = MAC_NUTRI_CALC_Redmeat_pro_E / &factor.;
        poultry_pro_E_&factor._per_substu = MAC_NUTRI_CALC_Poultry_pro_E/ &factor.;
		 Fish_pro_E_&factor._per_substu = MAC_NUTRI_CALC_Fish_pro_E / &factor.;
        egg_pro__E_&factor._per_substu = MAC_NUTRI_CALC_egg_pro_E / &factor.;
		 highfatmilk_pro_E_&factor._per_substu = MACNUTRICALC_highfatmilk_pro_E / &factor.;
        lowfatmilk_pro_E_&factor._per_substu = MACNUTRICALC_lowfatmilk_pro_E / &factor.;
		 yakmilk_pro_E_&factor._per_substu = MACNUTRI_CALC_yakmilk_pro_E / &factor.;
       	 milk_Protein_E_&factor._per_substu =MAC_NUTRI_CALC_Milk_pro_E/ &factor.;
		 fermmilk_Protein_E_&factor._per_substu =fermented_Milk_pro_E/ &factor.;
		  nonfermmilk_Pro_E_&factor._per_substu =nonfermented_Milk_pro_E/ &factor.;
		cereal_protein_E_&factor._per_substu = cereal_protein_E_no0 / &factor.;
       	Puls_legumes_pro_E_&factor._per_substu =Pulses_legumes_pro_E_no0/ &factor.;
    run;
    /* Executes the DATA step to create the new variables. */
%mend;
/* End of the nutrient_conversion macro. */
/* Example usage */
%nutrient_conversion(5);/* converted into every 5% of data */
/* Invokes the 'nutrient_conversion' macro with a factor of 5.
   This will create new variables where each nutrient's energy percentage
   is divided by 5 (e.g., Carbohydrate_E_5_per_sub). */


/*----------------------------------------------------------------------------*/
/* Step 14: Macro to run a survey-weighted logistic regression model for substitution of 5% carbohydrate%E is replaced with other 5%E nutrients*/
/*----------------------------------------------------------------------------*/
%macro run_logistic(dependent_var, independent_vars);
    /* Parameters:
     * dependent_var - The name of the dependent (outcome) variable.
     * independent_vars - A space-separated list of independent (predictor) variables*/
    
    proc surveylogistic data=Indiab.For_substitution;
        /* Invokes the SURVEYLOGISTIC procedure for logistic regression with complex survey data. */
        weight WeightageT_2011_NEW;
        /* Specifies the weight variable. */
        cluster PSUNo;
        /* Specifies the cluster variable. */
        strata state_code;
        /* Specifies the strata variable. */

        class Edu_code FAMILY_HISTORY Sex_code  alcohol Smoking urm_code / param=ref missing;
        /* Specifies categorical independent variables for the model.
           param=ref: Uses reference parameterization for the class variables.
           missing: Includes missing values as a separate level in the classification. */

        model &dependent_var = &independent_vars  Age Sex_code Fam_his_yes_No
        Smoking pal_code  urm_code Study_conducted_year Edu_code alcohol
            / clodds clparm ;
        /* Specifies the logistic regression model:
           - &dependent_var is the outcome variable.
           - &independent_vars and the listed variables are the predictors.
           - clodds: Requests confidence limits for the odds ratios.
           - clparm: Requests confidence limits for the parameter estimates. */
    run;
    /* Executes the PROC SURVEYLOGISTIC step. */

   %mend;
/* End of the run_logistic macro. */
/*NDD*/
title "Substitution with total Protein For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu MAC_NUTRI_CALC_energy   BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with plant Protein For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu animal_Protein_E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy  BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with cereal Protein For overll PD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu Puls_legumes_pro_E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy  BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with pulses and legumes Protein For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu cereal_protein_E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy  BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with plant+milk Protein For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu   MAC_NUTRI_CALC_energy  BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with milk Protein For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu   MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with fermented dairy Protein For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu nonfermmilk_Pro_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with non fermented Protein For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu  fermmilk_Protein_E_5_per_substu MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with animal Protein For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu 
milk_Protein_E_5_per_substu MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with animal+milk Protein For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with red meat Protein For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu  poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with poultry Protein For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with egg Protein For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu  Redmeat_pro_E_5_per_substu
poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu  milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with fish Protein For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub  SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu 
poultry_pro_E_5_per_substu  egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with fat For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub Protein_E_5_per_substu MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with sfa For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub Protein_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with MUFA For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub Protein_E_5_per_substu SFA_E_5_per_substu PUFA_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with PUFA For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub Protein_E_5_per_substu  SFA_E_5_per_substu MUFA_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with PUFA n6 For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub Protein_E_5_per_substu PUFA_n3_E_5_per_substu SFA_E_5_per_substu MUFA_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with PUFA n3 For overll NDD";
%run_logistic(NDD_cat, Carbohydrate_E_5_per_sub  Protein_E_5_per_substu PUFA_n6_E_5_per_substu SFA_E_5_per_substu MUFA_E_5_per_substu MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
/*PD*/
title "Substitution with total Protein For overll PD";
%run_logistic(PD_cat,Carbohydrate_E_5_per_sub  fat_E_5_per_substu MAC_NUTRI_CALC_energy   BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with cereal Protein For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu Puls_legumes_pro_E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy  BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with pulses and legumes Protein For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu cereal_protein_E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy  BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with plant Protein For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy  BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with plant+milk Protein For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu   MAC_NUTRI_CALC_energy  BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with milk Protein For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu   MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with fermented dairy Protein For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu nonfermmilk_Pro_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with non fermented Protein For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu  fermmilk_Protein_E_5_per_substu MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with animal Protein For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu 
milk_Protein_E_5_per_substu MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with animal+milk Protein For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with red meat Protein For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu  poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with poultry Protein For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with egg Protein For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu  Redmeat_pro_E_5_per_substu
poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu  milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with fish Protein For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub  SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu 
poultry_pro_E_5_per_substu  egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with fat For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub Protein_E_5_per_substu MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with sfa For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub Protein_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with MUFA For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub Protein_E_5_per_substu SFA_E_5_per_substu PUFA_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with PUFA For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub Protein_E_5_per_substu  SFA_E_5_per_substu MUFA_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with PUFA n6 For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub Protein_E_5_per_substu PUFA_n3_E_5_per_substu SFA_E_5_per_substu MUFA_E_5_per_substu  MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with PUFA n3 For overll PD";
%run_logistic(PD_cat, Carbohydrate_E_5_per_sub  Protein_E_5_per_substu PUFA_n6_E_5_per_substu SFA_E_5_per_substu MUFA_E_5_per_substu MAC_NUTRI_CALC_energy BMI Abdominal_obesity_Waist hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
/*general obesity*/
title "Substitution with total Protein For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub  fat_E_5_per_substu   MAC_NUTRI_CALC_energy   hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with plant Protein For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy   hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with plant+milk Protein For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu   MAC_NUTRI_CALC_energy   hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with cereal Protein For overll general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu Puls_legumes_pro_E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with pulses and legumes Protein For overll general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu cereal_protein_E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with milk Protein For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu   MAC_NUTRI_CALC_energy hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with fermented dairy Protein For overll PD";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu nonfermmilk_Pro_E_5_per_substu  MAC_NUTRI_CALC_energy  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with non fermented Protein For overll PD";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu  fermmilk_Protein_E_5_per_substu MAC_NUTRI_CALC_energy hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with animal Protein For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu 
milk_Protein_E_5_per_substu MAC_NUTRI_CALC_energy  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with animal+milk Protein For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu MAC_NUTRI_CALC_energy  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with red meat Protein For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu  poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with poultry Protein For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with egg Protein For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu  Redmeat_pro_E_5_per_substu
poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu  milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with fish Protein For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub  SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu 
poultry_pro_E_5_per_substu  egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with fat For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub Protein_E_5_per_substu MAC_NUTRI_CALC_energy  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with sfa For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub Protein_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu  MAC_NUTRI_CALC_energy  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with MUFA For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub Protein_E_5_per_substu SFA_E_5_per_substu PUFA_E_5_per_substu  MAC_NUTRI_CALC_energy  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with PUFA For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub Protein_E_5_per_substu  SFA_E_5_per_substu MUFA_E_5_per_substu  MAC_NUTRI_CALC_energy  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with PUFA n6 For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub Protein_E_5_per_substu PUFA_n3_E_5_per_substu SFA_E_5_per_substu MUFA_E_5_per_substu  MAC_NUTRI_CALC_energy  hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with PUFA n3 For general obesity";
%run_logistic(GeneralisedobesityBMI_above25, Carbohydrate_E_5_per_sub  Protein_E_5_per_substu PUFA_n6_E_5_per_substu SFA_E_5_per_substu MUFA_E_5_per_substu MAC_NUTRI_CALC_energy  hypertension dyslipideamia Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
/*abdominal obesity*/
title "Substitution with total Protein For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub  fat_E_5_per_substu   MAC_NUTRI_CALC_energy  BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with plant Protein For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy  BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with plant+milk Protein For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu   MAC_NUTRI_CALC_energy  BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with cereal Protein For overll Abdominal_obesity_Waist";
%run_logistic(Abdominal_obesity_Waist, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu Puls_legumes_pro_E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy  BMI hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with pulses and legumes Protein For overll Abdominal_obesity_Waist";
%run_logistic(Abdominal_obesity_Waist, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu 
egg_pro__E_5_per_substu cereal_protein_E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy BMI hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with milk Protein For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub  fat_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu   MAC_NUTRI_CALC_energy BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with fermented dairy Protein For overll Abdominal_obesity_Waist";
%run_logistic(Abdominal_obesity_Waist, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu nonfermmilk_Pro_E_5_per_substu  MAC_NUTRI_CALC_energy BMI hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with non fermented Protein For overll Abdominal_obesity_Waist";
%run_logistic(Abdominal_obesity_Waist, Carbohydrate_E_5_per_sub  fat_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu  fermmilk_Protein_E_5_per_substu MAC_NUTRI_CALC_energy BMI hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with animal Protein For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu 
milk_Protein_E_5_per_substu MAC_NUTRI_CALC_energy BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with animal+milk Protein For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu MAC_NUTRI_CALC_energy BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with red meat Protein For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu  poultry_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with poultry Protein For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu 
Fish_pro_E_5_per_substu egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with egg Protein For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu  Redmeat_pro_E_5_per_substu
poultry_pro_E_5_per_substu Fish_pro_E_5_per_substu  milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with fish Protein For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub  SFA_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu Plant_Protein_E_5_per_substu Redmeat_pro_E_5_per_substu 
poultry_pro_E_5_per_substu  egg_pro__E_5_per_substu milk_Protein_E_5_per_substu  MAC_NUTRI_CALC_energy BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with fat For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub Protein_E_5_per_substu MAC_NUTRI_CALC_energy BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with sfa For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub Protein_E_5_per_substu MUFA_E_5_per_substu PUFA_E_5_per_substu  MAC_NUTRI_CALC_energy BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with MUFA For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub Protein_E_5_per_substu SFA_E_5_per_substu PUFA_E_5_per_substu  MAC_NUTRI_CALC_energy BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with PUFA For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub Protein_E_5_per_substu  SFA_E_5_per_substu MUFA_E_5_per_substu  MAC_NUTRI_CALC_energy BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with PUFA n6 For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub Protein_E_5_per_substu PUFA_n3_E_5_per_substu SFA_E_5_per_substu MUFA_E_5_per_substu  MAC_NUTRI_CALC_energy BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
title "Substitution with PUFA n3 For overll Abdominal obesity";
%run_logistic(Abdominal_obesity_Waist , Carbohydrate_E_5_per_sub  Protein_E_5_per_substu PUFA_n6_E_5_per_substu SFA_E_5_per_substu MUFA_E_5_per_substu MAC_NUTRI_CALC_energy BMI  hypertension dyslipideamia NDD_cat PD_cat Carbohydrate_E_5_per_sub*sex_code Carbohydrate_E_5_per_sub*urm_code);
run;



/*----------------------------------------------------------------------------*/
/* Step 15: Survey-Weighted Logistic Regression model for subtitutng the food groups like some amount of refined cereals(g) replaced with same amount of whole grains (g)  */
/* Survey-Weighted Logistic Regression for NDD (Newly diagnosed-Diabetes)      
/*----------------------------------------------------------------------------*/
proc surveylogistic data=Indiab.For_substitution;
    /*
     * PROC SURVEYLOGISTIC performs logistic regression analysis for survey data,
     * taking into account the complex survey design (weighting, clustering, stratification).
     * The goal here is to model the association between various dietary substitutions
     * and the odds of having Newly diagnosed diabetes category (NDD_cat).
     */
    class Edu_code FAMILY_HISTORY Sex_code  alcohol Smoking;
    /*
     * Specifies the categorical independent variables to be included in the model.
     * SAS will create indicator (dummy) variables for each level of these class variables.
     * By default, the last level is treated as the reference category.
     */
    strata state_code;; /* Specify the stratification variable if applicable */
    /*
     * Specifies 'state_code' as the stratification variable. Stratification is used
     * when the population is divided into subgroups (strata) and samples are drawn
     * independently from each stratum. This needs to be accounted for in the analysis.
     */
    cluster PSUNo;         /* Specify the cluster variable if applicable */
    /*
     * Specifies 'PSUNo' (Primary Sampling Unit Number) as the cluster variable.
     * Clustering occurs when groups of individuals are sampled together.
     * Observations within a cluster are likely to be correlated, which needs
     * to be accounted for in the standard error estimation.
     */
    weight WeightageT_2011_NEW;;          /* Specify the weight variable if applicable */
    /*
     * Specifies 'WeightageT_2011_NEW' as the weight variable. Sample weights are used
     * to make the sample representative of the target population, especially when
     * sampling probabilities vary across individuals.
     */
    model ndd_cat = Totalrefinedcereals_sub whole_grain_sub
                    Pulsesandlegumes_sub Animal_foods_all_sub
                    Edible_oils_sub Edible_fats_sub fruits_sub
                    vegetablesgreensroot_sub Tubers_sub
                    milkandmilkproduct_sub Nutsoilseeds_sub Age
                    Sex_code FAMILY_HISTORY  Smoking
                    pal_code  Study_conducted_year Edu_code
                    alcohol MAC_NUTRI_CALC_energy BMI
                    Abdominal_obesity_Waist hypertension dyslipideamia/covb;
    /*
     * Specifies the logistic regression model:
     * - ndd_cat: This is the dependent variable (outcome). It is likely a binary variable
     * where 1 indicates having Newly diagnosed diabetes category and 0 indicates having a disease.
     * - Totalrefinedcereals_sub through dyslipideamia: These are the independent
     * (predictor) variables. They represent various dietary substitutions,
     * food group intakes, demographic factors, lifestyle factors,
     * anthropometric measures, and clinical conditions. The '_sub' suffix
     * likely indicates substitution variables created earlier.
     * - /covb: This option requests the estimated covariance matrix of the parameter estimates.
     * This matrix is useful for further analyses or for understanding the
     * relationships between the estimated coefficients.
     */
run;
/* Executes the PROC SURVEYLOGISTIC step. */


/*----------------------------------------------------------------------------*/
/* Step 16: Survey-Weighted Logistic Regression model for subtitutng the food groups like some amount of refined cereals(g) replaced with same amount of whole grains (g)  */
/* Survey-Weighted Logistic Regression for PD (Pre-Diabetes)      
/*----------------------------------------------------------------------------*/
proc surveylogistic data=Indiab.For_substitution;
    /*
     * Similar to the previous step, this PROC SURVEYLOGISTIC models the association
     * between the same set of predictors and the odds of having pre-diabetes (Pd_cat).
     */
    class Edu_code FAMILY_HISTORY Sex_code  alcohol Smoking;
    /* Specifies the categorical independent variables. */
    strata state_code;; /* Specify the stratification variable if applicable */
    /* Specifies the stratification variable. */
    cluster PSUNo;         /* Specify the cluster variable if applicable */
    /* Specifies the cluster variable. */
    weight WeightageT_2011_NEW;;          /* Specify the weight variable if applicable */
    /* Specifies the weight variable. */
    model Pd_cat = Totalrefinedcereals_sub whole_grain_sub
                    Pulsesandlegumes_sub Animal_foods_all_sub
                    Edible_oils_sub Edible_fats_sub fruits_sub
                    vegetablesgreensroot_sub Tubers_sub
                    milkandmilkproduct_sub Nutsoilseeds_sub Age
                    Sex_code FAMILY_HISTORY  Smoking
                    pal_code  Study_conducted_year Edu_code
                    alcohol MAC_NUTRI_CALC_energy BMI
                    Abdominal_obesity_Waist hypertension dyslipideamia/covb;
    /*
     * Specifies the logistic regression model:
     * - Pd_cat: This is the dependent variable, likely a binary variable where 1
     * indicates having pre-diabetes and 0 indicates not having it.
     * - The independent variables are the same as in the previous NDD model.
     * - /covb: Requests the covariance matrix of the parameter estimates.
     */
run;
/* Executes the PROC SURVEYLOGISTIC step. */

/*----------------------------------------------------------------------------*/
/* Step 17: Survey-Weighted Logistic Regression model for subtitutng the food groups like some amount of refined cereals(g) replaced with same amount of whole grains (g)  */
/* Survey-Weighted Logistic Regression for General obesity catwegory    
/*----------------------------------------------------------------------------*/
proc surveylogistic data=Indiab.For_substitution;
    /*
     * This PROC SURVEYLOGISTIC models the association between the predictors
     * and the odds of having generalised obesity defined as BMI >= 25
     * (GeneralisedobesityBMI_above25).
     */
    class Edu_code FAMILY_HISTORY Sex_code  alcohol Smoking;
    /* Specifies the categorical independent variables. */
    strata state_code;; /* Specify the stratification variable if applicable */
    /* Specifies the stratification variable. */
    cluster PSUNo;         /* Specify the cluster variable if applicable */
    /* Specifies the cluster variable. */
    weight WeightageT_2011_NEW;;          /* Specify the weight variable if applicable */
    /* Specifies the weight variable. */
    model GeneralisedobesityBMI_above25 = Totalrefinedcereals_sub whole_grain_sub
                    Pulsesandlegumes_sub Animal_foods_all_sub
                    Edible_oils_sub Edible_fats_sub fruits_sub
                    vegetablesgreensroot_sub Tubers_sub
                    milkandmilkproduct_sub Nutsoilseeds_sub Age
                    Sex_code FAMILY_HISTORY  Smoking
                    pal_code  Study_conducted_year Edu_code
                    alcohol MAC_NUTRI_CALC_energy hypertension dyslipideamia NDD_cat PD_cat/covb;
    /*
     * Specifies the logistic regression model:
     * - GeneralisedobesityBMI_above25: The dependent variable, likely binary (1=obese, 0=not obese).
     * - The independent variables include dietary factors, demographics, lifestyle,
     * total energy intake, and the presence of hypertension, dyslipidemia, NDD, and PD.
     * - /covb: Requests the covariance matrix of the parameter estimates.
     */
run;
/* Executes the PROC SURVEYLOGISTIC step. */

/*----------------------------------------------------------------------------*/
/* Step 18: Survey-Weighted Logistic Regression model for subtitutng the food groups like some amount of refined cereals(g) replaced with same amount of whole grains (g) */
/* Survey-Weighted Logistic Regression for Abdominal obesity catwegory    
/*----------------------------------------------------------------------------*/
proc surveylogistic data=Indiab.For_substitution;
    /*
     * This PROC SURVEYLOGISTIC models the association between the predictors
     * and the odds of having abdominal obesity (Abdominal_obesity_Waist).
     */
    class Edu_code FAMILY_HISTORY Sex_code  alcohol Smoking;
    /* Specifies the categorical independent variables. */
    strata state_code;; /* Specify the stratification variable if applicable */
    /* Specifies the stratification variable. */
    cluster PSUNo;         /* Specify the cluster variable if applicable */
    /* Specifies the cluster variable. */
    weight WeightageT_2011_NEW;;          /* Specify the weight variable if applicable */
    /* Specifies the weight variable. */
    model Abdominal_obesity_Waist = Totalrefinedcereals_sub whole_grain_sub
                    Pulsesandlegumes_sub Animal_foods_all_sub
                    Edible_oils_sub Edible_fats_sub fruits_sub
                    vegetablesgreensroot_sub Tubers_sub
                    milkandmilkproduct_sub Nutsoilseeds_sub Age
                    Sex_code FAMILY_HISTORY  Smoking
                    pal_code  Study_conducted_year Edu_code
                    alcohol MAC_NUTRI_CALC_energy BMI hypertension dyslipideamia NDD_cat PD_cat/covb;
    /*
     * Specifies the logistic regression model:
     * - Abdominal_obesity_Waist: The dependent variable, likely binary (1=abdominally obese, 0=not).
     * - The independent variables are the same as in the generalised obesity model.
     * - /covb: Requests the covariance matrix of the parameter estimates.
     */
run;

/*----------------------------------------------------------------------------*/
/* Step 19: Survey-Weighted Logistic Regression model for subtitutng the food groups like some amount of refined cereals(g) replaced with same amount of wheat (g) or millet (g) */
/* Survey-Weighted Logistic Regression for NDD (Newly diagnosed-Diabetes)      
/*----------------------------------------------------------------------------*/
proc surveylogistic data=Indiab.For_substitution;
    /*
     * This PROC SURVEYLOGISTIC models the association between a more detailed
     * breakdown of cereal substitutions and the odds of having Newly diagnosed diabetes category (ndd_cat).
     */
    class Edu_code FAMILY_HISTORY Sex_code  alcohol Smoking;
    /* Specifies the categorical independent variables. */
    strata state_code;; /* Specify the stratification variable if applicable */
    /* Specifies the stratification variable. */
    cluster PSUNo;         /* Specify the cluster variable if applicable */
    /* Specifies the cluster variable. */
    weight WeightageT_2011_NEW;;          /* Specify the weight variable if applicable */
    /* Specifies the weight variable. */
    model ndd_cat = Totalrefinedcereals_sub  Total_wheat_sub Total_millets_sub
                    Pulsesandlegumes_sub Animal_foods_all_sub
                    Edible_oils_sub Edible_fats_sub fruits_sub
                    vegetablesgreensroot_sub Tubers_sub
                    milkandmilkproduct_sub Nutsoilseeds_sub Age
                    Sex_code FAMILY_HISTORY  Smoking
                    pal_values  Study_conducted_year Edu_code
                    alcohol MAC_NUTRI_CALC_energy BMI
                    Abdominal_obesity_Waist hypertension dyslipideamia/covb;
    /*
     * Specifies the logistic regression model:
     * - ndd_cat: The dependent variable (Newly diagnosed diabetes category).
     * - Independent variables now include separate substitution terms for total refined cereals,
     * total wheat, and total millets, in addition to other food groups and covariates.
     * - pal_values: Note that 'pal_code' was used before, 'pal_values' might be a different
     * representation of physical activity level.
     * - /covb: Requests the covariance matrix of the parameter estimates.
     */
run;
/*----------------------------------------------------------------------------*/
/* Step 20: Survey-Weighted Logistic Regression model for subtitutng the food groups like some amount of refined cereals(g) replaced with same amount of wheat (g) or millet (g) */
/* Survey-Weighted Logistic Regression for PD (Pre-Diabetes)      
/*----------------------------------------------------------------------------*/
proc surveylogistic data=Indiab.For_substitution;
    /*
     * Similar to the previous step, this models the association between the detailed
     * cereal substitutions and the odds of having pre-diabetes (Pd_cat).
     */
    class Edu_code FAMILY_HISTORY Sex_code  alcohol Smoking;
    /* Specifies the categorical independent variables. */
    strata state_code;; /* Specify the stratification variable if applicable */
    /* Specifies the stratification variable. */
    cluster PSUNo;         /* Specify the cluster variable if applicable */
    /* Specifies the cluster variable. */
    weight WeightageT_2011_NEW;;          /* Specify the weight variable if applicable */
    /* Specifies the weight variable. */
    model Pd_cat = Totalrefinedcereals_sub  Total_wheat_sub Total_millets_sub
                    Pulsesandlegumes_sub Animal_foods_all_sub
                    Edible_oils_sub Edible_fats_sub fruits_sub
                    vegetablesgreensroot_sub Tubers_sub
                    milkandmilkproduct_sub Nutsoilseeds_sub Age
                    Sex_code FAMILY_HISTORY  Smoking
                    pal_code  Study_conducted_year Edu_code
                    alcohol MAC_NUTRI_CALC_energy BMI
                    Abdominal_obesity_Waist hypertension dyslipideamia/covb;
    /*
     * Specifies the logistic regression model with Pd_cat as the dependent variable
     * and the detailed cereal substitution terms along with other covariates as predictors.
     * Note the use of 'pal_code' here instead of 'pal_values'.
     * - /covb: Requests the covariance matrix of the parameter estimates.
     */
run;
/* Executes the PROC SURVEYLOGISTIC step. */

/*----------------------------------------------------------------------------*/
/* Step 21: Survey-Weighted Logistic Regression model for subtitutng the food groups like some amount of refined cereals(g) replaced with same amount of wheat (g) or millet (g)*/
/* Survey-Weighted Logistic Regression for General obesity catwegory    
/*----------------------------------------------------------------------------*/
proc surveylogistic data=Indiab.For_substitution;
    /*
     * This models the association between the detailed cereal substitutions and
     * the odds of having generalised obesity (GeneralisedobesityBMI_above25).
     */
    class Edu_code FAMILY_HISTORY Sex_code  alcohol Smoking;
    /* Specifies the categorical independent variables. */
    strata state_code;; /* Specify the stratification variable if applicable */
    /* Specifies the stratification variable. */
    cluster PSUNo;         /* Specify the cluster variable if applicable */
    /* Specifies the cluster variable. */
    weight WeightageT_2011_NEW;;          /* Specify the weight variable if applicable */
    /* Specifies the weight variable. */
    model GeneralisedobesityBMI_above25 = Totalrefinedcereals_sub Total_millets_sub Total_wheat_sub
                    Pulsesandlegumes_sub Animal_foods_all_sub
                    Edible_oils_sub Edible_fats_sub fruits_sub
                    vegetablesgreensroot_sub Tubers_sub
                    milkandmilkproduct_sub Nutsoilseeds_sub Age
                    Sex_code FAMILY_HISTORY  Smoking
                    pal_code  Study_conducted_year Edu_code
                    alcohol MAC_NUTRI_CALC_energy hypertension dyslipideamia NDD_cat PD_cat/covb;
    /*
     * Specifies the logistic regression model with GeneralisedobesityBMI_above25 as the
     * dependent variable and the detailed cereal substitution terms along with other covariates.
     * - /covb: Requests the covariance matrix of the parameter estimates.
     */
run;
/* Executes the PROC SURVEYLOGISTIC step. */

/*----------------------------------------------------------------------------*/
/* Step 22: Survey-Weighted Logistic Regression model for subtitutng the food groups like some amount of refined cereals(g) replaced with same amount of wheat (g) or millet (g)*/
/* Survey-Weighted Logistic Regression for abdominal obesity catwegory    
/*----------------------------------------------------------------------------*/
proc surveylogistic data=Indiab.For_substitution;
    /*
     * This models the association between the detailed cereal substitutions and
     * the odds of having abdominal obesity (Abdominal_obesity_Waist).
     */
    class Edu_code FAMILY_HISTORY Sex_code  alcohol Smoking;
    /* Specifies the categorical independent variables. */
    strata state_code;; /* Specify the stratification variable if applicable */
    /* Specifies the stratification variable. */
    cluster PSUNo;         /* Specify the cluster variable if applicable */
    /* Specifies the cluster variable. */
    weight WeightageT_2011_NEW;;          /* Specify the weight variable if applicable */
    /* Specifies the weight variable. */
    model Abdominal_obesity_Waist = Totalrefinedcereals_sub Total_millets_sub Total_wheat_sub
                    Pulsesandlegumes_sub Animal_foods_all_sub
                    Edible_oils_sub Edible_fats_sub fruits_sub
                    vegetablesgreensroot_sub Tubers_sub
                    milkandmilkproduct_sub Nutsoilseeds_sub Age
                    Sex_code FAMILY_HISTORY  Smoking
                    pal_code  Study_conducted_year Edu_code
                    alcohol MAC_NUTRI_CALC_energy BMI hypertension dyslipideamia NDD_cat PD_cat/covb;
    /*
     * Specifies the logistic regression model with Abdominal_obesity_Waist as the
     * dependent variable and the detailed cereal substitution terms along with other covariates.
     * - /covb: Requests the covariance matrix of the parameter estimates.
     */
run;
/* Executes the PROC SURVEYLOGISTIC step. */

/*----------------------------------------------------------------------------*/
/* Step 23: Recode Variables Based on Thresholds                             */
/*----------------------------------------------------------------------------*/
data Indiab.For_substitution;
    set Indiab.For_substitution;
    /* Reads the existing 'Indiab.For_substitution' dataset. */

    Total_White_rice_GR50 = Total_White_rice_no0;
    /* Assigns the value of 'Total_White_rice_no0' to the new variable 'Total_White_rice_GR50'. */
    if Total_White_rice_GR50 < 50 then Total_White_rice_GR50 = .;
    /* If the value of 'Total_White_rice_GR50' is less than 50g, it is set to missing (.).
       This step likely aims to handle very low consumption values. */

    Total_wheat_GR50 = Total_wheat_GR50;
    /* Assigns the value of 'Total_wheat_GR50' to itself (no change).
       Note: It seems there might be a typo here, as the input variable name is the same as the output.
       It's possible the intention was to use a different original variable. */
    if Total_wheat_GR50 < 50 then Total_wheat_GR50 = .;
    /* If the value of 'Total_wheat_GR50' is less than 50g, it is set to missing (.). */

    Totalmillets_GR50 = Total_millets_no0;
    /* Assigns the value of 'Total_millets_no0' to the new variable 'Totalmillets_GR50'. */
    if Totalmillets_GR50 < 50 then Totalmillets_GR50 = .;
    /* If the value of 'Totalmillets_GR50' is less than 50g, it is set to missing (.). */

    wholegrainmilledn_GR50=Whole_grains_no0;
    /* Assigns the value of 'Whole_grains_no0' to the new variable 'wholegrainmilledn_GR50'. */
    if wholegrainmilledn_GR50 < 50 then wholegrainmilledn_GR50 = .;
    /* If the value of 'wholegrainmilledn_GR50' is less than 50g, it is set to missing (.). */

    added_Sugar_GR5g = added_Sugar_no0;
    /* Assigns the value of 'added_Sugar_no0' to the new variable 'added_Sugar_GR5g'. */
    if added_Sugar_GR5g < 5 then added_Sugar_GR5g = .;
    /* If the value of 'added_Sugar_GR5g' is less than 5g, it is set to missing (.). */

run;
/* Executes the DATA step to create the new recoded variables. */

/*----------------------------------------------------------------------------*/
/* Step 24: Convert Continuous Variables into Tertiles                       */
/*----------------------------------------------------------------------------*/
proc rank data=Indiab.For_substitution out=Indiab.For_substitution  groups=3;
    /*
     * PROC RANK assigns ranks to observations within each variable.
     * The GROUPS=3 option divides the data into three groups (tertiles)
     * based on the distribution of each specified variable.
     * The output is stored back in the 'Indiab.For_substitution' dataset,
     * overwriting the original or creating new variables for the ranks.
     */
    var MAC_NUTRI_CALC_carbohydrate_E
    Total_White_rice_GR50
    refined_maida_GR50
    Total_wheat_GR50
    Totalmillets_GR50
    Total_refined_cereals_GR50
    wholegrainmilledn_GR50
    added_Sugar_GR5g
    ;
    /* Specifies the continuous variables to be divided into tertiles. */
    ranks carb_E_t3
    TotalWhitericeno0_t3
    refined_maida_t3
    Total_wheat_no_t3
    Totalmilletsno0_t3
    refined_cereals_GR50_t3
    wholegrainmilledn_GR50_t3
    added_Sugar_GR5g_t3
    ;
    /* Specifies the names of the new rank variables (tertile categories)
       that will be created for each of the 'var' variables, respectively.
       For example, 'carb_E_t3' will contain the tertile group (1, 2, or 3)
       for 'MAC_NUTRI_CALC_carbohydrate_E'.
       Note: There might be inconsistencies in the output variable names
       compared to the input variable names (e.g., 'TotalWhitericeno0_t3' vs. 'Total_White_rice_GR50'). */
run;
/* Executes the PROC RANK step. */

/*----------------------------------------------------------------------------*/
/* Step 25: Descriptive Statistics (Median, Q1, Q3) by Carbohydrate Tertile  */
/*----------------------------------------------------------------------------*/
proc surveymeans data = Indiab.For_substitution median q1 q3;
    /*
     * PROC SURVEYMEANS calculates descriptive statistics for survey data,
     * accounting for the complex survey design.
     * Here, it calculates the weighted median, first quartile (Q1), and
     * third quartile (Q3) for 'MAC_NUTRI_CALC_carbohydrate_E'.
     */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable. */
    cluster PSUNo ;
    /* Specifies the cluster variable. */
    strata state_code;
    /* Specifies the strata variable. */
    var MAC_NUTRI_CALC_carbohydrate_E
    ;
    /* Specifies the variable for which to calculate the statistics. */
    domain carb_E_t3 ;
    /* Specifies that the statistics will be calculated separately for each
       tertile category of the 'carb_E_t3' variable. */
run;
/* Executes the PROC SURVEYMEANS step. */

/*----------------------------------------------------------------------------*/
/* Step 26: Descriptive Statistics by Refined Cereals Tertile                */
/*----------------------------------------------------------------------------*/
proc surveymeans data = Indiab.For_substitution median q1 q3;
    /* Calculates weighted median, Q1, and Q3. */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable. */
    cluster PSUNo ;
    /* Specifies the cluster variable. */
    strata state_code;
    /* Specifies the strata variable. */
    var Total_refined_cereals_GR50
    ;
    /* Specifies the variable for which to calculate the statistics. */
    domain refined_cereals_GR50_t3 ;
    /* Calculates statistics separately for each tertile of 'refined_cereals_GR50_t3'. */
run;
/* Executes the PROC SURVEYMEANS step. */

/*----------------------------------------------------------------------------*/
/* Step 27: Descriptive Statistics by White Rice Tertile                     */
/*----------------------------------------------------------------------------*/
proc surveymeans data = Indiab.For_substitution median q1 q3;
    /* Calculates weighted median, Q1, and Q3. */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable. */
    cluster PSUNo ;
    /* Specifies the cluster variable. */
    strata state_code;
    /* Specifies the strata variable. */
    var Total_White_rice_GR50
    ;
    /* Specifies the variable for which to calculate the statistics. */
    domain TotalWhitericeno0_t3 ;
    /* Calculates statistics separately for each tertile of 'TotalWhitericeno0_t3'. */
run;
/* Executes the PROC SURVEYMEANS step. */

/*----------------------------------------------------------------------------*/
/* Step 28: Descriptive Statistics for Whole Grains (Overall)               */
/*----------------------------------------------------------------------------*/
proc surveymeans data = Indiab.For_substitution median q1 q3;
    /* Calculates weighted median, Q1, and Q3. */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable. */
    cluster PSUNo ;
    /* Specifies the cluster variable. */
    strata state_code;
    /* Specifies the strata variable. */
    var wholegrainmilledn_GR50
    ;
    /* Specifies the variable for which to calculate the statistics.
       Note: No 'domain' statement is used here, so the statistics will be
       calculated for the entire sample. */
run;
/* Executes the PROC SURVEYMEANS step. */

/*----------------------------------------------------------------------------*/
/* Step 29: Descriptive Statistics by Total Wheat Tertile                   */
/*----------------------------------------------------------------------------*/
proc surveymeans data = Indiab.For_substitution median q1 q3;
    /* Calculates weighted median, Q1, and Q3. */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable. */
    cluster PSUNo ;
    /* Specifies the cluster variable. */
    strata state_code;
    /* Specifies the strata variable. */
    var Total_wheat_GR50
    ;
    /* Specifies the variable for which to calculate the statistics. */
    domain Total_wheat_no_t3 ;
    /* Calculates statistics separately for each tertile of 'Total_wheat_no_t3'. */
run;
/* Executes the PROC SURVEYMEANS step. */

/*----------------------------------------------------------------------------*/
/* Step 30: Descriptive Statistics by Total Millets Tertile                  */
/*----------------------------------------------------------------------------*/
proc surveymeans data = Indiab.For_substitution median q1 q3;
    /* Calculates weighted median, Q1, and Q3. */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable. */
    cluster PSUNo ;
    /* Specifies the cluster variable. */
    strata state_code;
    /* Specifies the strata variable. */
    var Totalmillets_GR50
    ;
    /* Specifies the variable for which to calculate the statistics. */
    domain Totalmilletsno0_t3 ;
    /* Calculates statistics separately for each tertile of 'Totalmilletsno0_t3'. */
run;
/* Executes the PROC SURVEYMEANS step. */

/*----------------------------------------------------------------------------*/
/* Step 31: Descriptive Statistics for Added Sugar (Overall)                */
/*----------------------------------------------------------------------------*/
proc surveymeans data = Indiab.For_substitution median q1 q3;
    /* Calculates weighted median, Q1, and Q3. */
    weight WeightageT_2011_NEW;
    /* Specifies the weight variable. */
    cluster PSUNo ;
    /* Specifies the cluster variable. */
    strata state_code;
    /* Specifies the strata variable. */
    var added_Sugar_GR5g
    ;
    /* Specifies the variable for which to calculate the statistics.
       Note: No 'domain' statement is used here, so the statistics will be
       calculated for the entire sample. */
run;

/*------------------------------------------------------------------------------------------*/
/* --------------------------Odds ratio code for survey samples-----------------------------*/
/*--------------------------------Step 32 to Step 38----------------------------------------*/
/*------------------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
/* Step 32: Survey-Weighted Logistic Regression for Carbohydrate Energy Intake */
/*----------------------------------------------------------------------------*/
/* Outcome: NDD (Newly diagnosed diabetes category) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;  /* Survey weight variable: Accounts for unequal selection probabilities */
    cluster PSUNo;              /* Cluster variable: Accounts for correlation within primary sampling units */
    strata state_code;          /* Stratification variable: Accounts for different sampling rates across states */
    class NDD_cat (ref="0") carb_E_t3 (ref="1");
    /* NDD_cat: Binary outcome (0=No NDD, 1=NDD). ref="0" sets 'No NDD' as the reference category. */
    /* carb_E_t3: Tertiles of carbohydrate energy intake.  ref="1" sets the lowest tertile as the reference group */
    model NDD_cat = carb_E_t3      /* Predict NDD_cat based on carbohydrate energy tertiles */
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code alcohol MAC_NUTRI_CALC_energy added_salt
        MAC_NUTRI_CALC_fat_E BMI_Asian_cutoff Abdominal_obesity_Waist
        hypertension dyslipideamia
        / clodds clparm;
    /* Covariates: Variables adjusted for in the model.
       clodds:  Requests odds ratios and their confidence limits.
       clparm: Requests parameter estimates and their confidence limits. */
run;

/* Outcome: PD (Pre-Diabetes) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class PD_cat (ref="0") carb_E_t3 (ref="1");
    model PD_cat = carb_E_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code alcohol MAC_NUTRI_CALC_energy added_salt
        MAC_NUTRI_CALC_fat_E BMI_Asian_cutoff Abdominal_obesity_Waist
        hypertension dyslipideamia
        / clodds clparm;
run;

/* Outcome: Generalised Obesity (BMI>=25) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class GeneralisedobesityBMI_above25 (ref="0") carb_E_t3 (ref="1");
    model GeneralisedobesityBMI_above25 = carb_E_t3
        Age Sex_code Fam_his_yes_No Smoking pal_code urm_code
        Study_conducted_year Edu_code alcohol MAC_NUTRI_CALC_energy added_salt
        MAC_NUTRI_CALC_fat_E hypertension dyslipideamia ndd_cat pd_cat
        / clodds clparm;
run;

/* Outcome: Abdominal Obesity */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class Abdominal_obesity_Waist (ref="0") carb_E_t3 (ref="1");
    model Abdominal_obesity_Waist = carb_E_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code alcohol MAC_NUTRI_CALC_energy added_salt
        MAC_NUTRI_CALC_fat_E BMI_Asian_cutoff ndd_cat pd_cat
        hypertension dyslipideamia
        / clodds clparm;
run;

/* Executes the PROC SURVEYLOGISTIC step. */
/*----------------------------------------------------------------------------*/
/* Step 33: Survey-Weighted Logistic Regression for Refined Cereals Tertiles */
/*----------------------------------------------------------------------------*/
/* Outcome: NDD (Newly diagnosed diabetes category) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;  /* Survey weight variable: Accounts for unequal selection probabilities */
    cluster PSUNo;              /* Cluster variable: Accounts for correlation within primary sampling units */
    strata state_code;          /* Stratification variable: Accounts for different sampling rates across states */
    class NDD_cat (ref="0") refined_cereals_GR50_t3 (ref="1");
    /* NDD_cat: Binary outcome (0=No NDD, 1=NDD). ref="0" sets 'No NDD' as the reference category. */
    /* refined_cereals_GR50_t3:  Tertiles of refined cereals intake. ref="1" sets the lowest tertile as the reference.
       It's crucial to ensure tertiles are coded as 1, 2, and 3. If your coding is different, change ref="1" accordingly. */
    model NDD_cat = refined_cereals_GR50_t3  /* Predict NDD_cat based on refined cereals tertiles */
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
    /* Covariates:  Variables adjusted for in the model to isolate the effect of refined cereals.
       clodds:  Requests odds ratios and their confidence limits.
       clparm: Requests parameter estimates and their confidence limits. */
run;

/* Outcome: PD (Pre-Diabetes) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class PD_cat (ref="0") refined_cereals_GR50_t3 (ref="1");
    /* PD_cat: Binary outcome (0=No PD, 1=PD). */
    model PD_cat = refined_cereals_GR50_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: Generalised Obesity (BMI>=25) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class GeneralisedobesityBMI_above25 (ref="0") refined_cereals_GR50_t3 (ref="1");
    /* GeneralisedobesityBMI_above25: Binary outcome (0=BMI<25, 1=BMI>=25). */
    model GeneralisedobesityBMI_above25 = refined_cereals_GR50_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        hypertension Dyslipideamia NDD_cat PD_cat
        / clodds clparm;
run;

/* Outcome: Abdominal Obesity */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class Abdominal_obesity_Waist (ref="0") refined_cereals_GR50_t3 (ref="1");
    /* Abdominal_obesity_Waist: Binary outcome (0=No abdominal obesity, 1=Abdominal obesity). */
    model Abdominal_obesity_Waist = refined_cereals_GR50_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        hypertension Dyslipideamia NDD_cat PD_cat BMI
        / clodds clparm;
run;

/*----------------------------------------------------------------------------*/
/* Step 34: Survey-Weighted Logistic Regression for White Rice Tertiles       */
/*----------------------------------------------------------------------------*/
/* Outcome: NDD (Newly diagnosed diabetes category) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class NDD_cat (ref="0") TotalWhitericeno0_t3 (ref="1");
    /* TotalWhitericeno0_t3: Tertiles of white rice intake. */
    model NDD_cat = TotalWhitericeno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: PD (Pre-Diabetes) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class PD_cat (ref="0") TotalWhitericeno0_t3 (ref="1");
    model PD_cat = TotalWhitericeno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: Generalised Obesity (BMI>=25) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class GeneralisedobesityBMI_above25 (ref="0") TotalWhitericeno0_t3 (ref="1");
    model GeneralisedobesityBMI_above25 = TotalWhitericeno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        hypertension Dyslipideamia NDD_cat PD_cat
        / clodds clparm;
run;

/* Outcome: Abdominal Obesity */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class Abdominal_obesity_Waist (ref="0") TotalWhitericeno0_t3 (ref="1");
    model Abdominal_obesity_Waist = TotalWhitericeno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        hypertension Dyslipideamia NDD_cat PD_cat BMI
        / clodds clparm;
run;

/*----------------------------------------------------------------------------*/
/* Step 35: Survey-Weighted Logistic Regression for Wholegrains Tertiles     */
/*----------------------------------------------------------------------------*/
/* Outcome: NDD (Newly diagnosed diabetes category) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class NDD_cat (ref="0") wholegrainmilledn_GR50_t3 (ref="1");
     /* wholegrainmilledn_GR50_t3: Tertiles of wholegrain intake. */
    model NDD_cat = wholegrainmilledn_GR50_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: PD (Pre-Diabetes) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class PD_cat (ref="0") wholegrainmilledn_GR50_t3 (ref="1");
    model PD_cat = wholegrainmilledn_GR50_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: Generalised Obesity (BMI>=25) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class GeneralisedobesityBMI_above25 (ref="0") wholegrainmilledn_GR50_t3 (ref="1");
    model GeneralisedobesityBMI_above25 = wholegrainmilledn_GR50_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        hypertension Dyslipideamia NDD_cat PD_cat
        / clodds clparm;
run;

/* Outcome: Abdominal Obesity */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class Abdominal_obesity_Waist (ref="0") wholegrainmilledn_GR50_t3 (ref="1");
    model Abdominal_obesity_Waist = wholegrainmilledn_GR50_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        hypertension Dyslipideamia NDD_cat PD_cat BMI
        / clodds clparm;
run;

/*----------------------------------------------------------------------------*/
/* Step 36: Survey-Weighted Logistic Regression for Wheat Intake Tertiles      */
/*----------------------------------------------------------------------------*/
/* Outcome: NDD (Newly diagnosed diabetes category) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;  /* Survey weight variable: Accounts for unequal selection probabilities */
    cluster PSUNo;              /* Cluster variable: Accounts for correlation within primary sampling units */
    strata state_code;          /* Stratification variable: Accounts for different sampling rates across states */
    class NDD_cat (ref="0") Total_wheat_no_t3 (ref="1");
    /* NDD_cat: Binary outcome (0=No NDD, 1=NDD). ref="0" sets 'No NDD' as the reference category. */
    /* Total_wheat_no_t3: Tertiles of total wheat intake. ref="1" sets the lowest tertile as the reference. */
    model NDD_cat = Total_wheat_no_t3  /* Predict NDD_cat based on wheat tertiles */
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
    /* Covariates:  Variables adjusted for in the model.
       clodds:  Requests odds ratios and their confidence limits.
       clparm: Requests parameter estimates and their confidence limits. */
run;

/* Outcome: PD (Pre-Diabetes) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class PD_cat (ref="0") Total_wheat_no_t3 (ref="1");
    model PD_cat = Total_wheat_no_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: Generalised Obesity (BMI>=25) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class GeneralisedobesityBMI_above25 (ref="0") Total_wheat_no_t3 (ref="1");
    model GeneralisedobesityBMI_above25 = Total_wheat_no_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        hypertension Dyslipideamia NDD_cat PD_cat
        / clodds clparm;
run;

/* Outcome: Abdominal Obesity */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class Abdominal_obesity_Waist (ref="0") Total_wheat_no_t3 (ref="1");
    model Abdominal_obesity_Waist = Total_wheat_no_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        hypertension Dyslipideamia NDD_cat PD_cat BMI
        / clodds clparm;
run;

/*----------------------------------------------------------------------------*/
/* Step 37: Survey-Weighted Logistic Regression for Millets Intake Tertiles    */
/*----------------------------------------------------------------------------*/
/* Outcome: NDD (Newly diagnosed diabetes category) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class NDD_cat (ref="0") Totalmilletsno0_t3 (ref="1");
    /* Totalmilletsno0_t3: Tertiles of total millets intake. */
    model NDD_cat = Totalmilletsno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia fbs
        / clodds clparm;
run;

/* Outcome: PD (Pre-Diabetes) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class PD_cat (ref="0") Totalmilletsno0_t3 (ref="1");
    model PD_cat = Totalmilletsno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: Generalised Obesity (BMI>=25) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class GeneralisedobesityBMI_above25 (ref="0") Totalmilletsno0_t3 (ref="1");
    model GeneralisedobesityBMI_above25 = Totalmilletsno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        hypertension Dyslipideamia NDD_cat PD_cat
        / clodds clparm;
run;

/* Outcome: Abdominal Obesity */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class Abdominal_obesity_Waist (ref="0") Totalmilletsno0_t3 (ref="1");
    model Abdominal_obesity_Waist = Totalmilletsno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        hypertension Dyslipideamia NDD_cat PD_cat BMI
        / clodds clparm;
run;

/*----------------------------------------------------------------------------*/
/* Step 38: Survey-Weighted Logistic Regression for Added Sugar Intake Tertiles */
/*----------------------------------------------------------------------------*/
/* Outcome: NDD (Newly diagnosed diabetes category) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class NDD_cat (ref="0") added_Sugar_GR5g_t3 (ref="1");
     /* added_Sugar_GR5g_t3: Tertiles of added sugar intake. */
    model NDD_cat = added_Sugar_GR5g_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50  wholegrainmilledn_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: PD (Pre-Diabetes) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class PD_cat (ref="0") added_Sugar_GR5g_t3 (ref="1");
    model PD_cat = added_Sugar_GR5g_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50 wholegrainmilledn_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: Generalised Obesity (BMI>=25) */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class GeneralisedobesityBMI_above25 (ref="0") added_Sugar_GR5g_t3 (ref="1");
    model GeneralisedobesityBMI_above25 = added_Sugar_GR5g_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50 wholegrainmilledn_GR50
        hypertension Dyslipideamia NDD_cat PD_cat
        / clodds clparm;
run;

/* Outcome: Abdominal Obesity */
proc surveylogistic data=Indiab.For_substitution;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class Abdominal_obesity_Waist (ref="0") added_Sugar_GR5g_t3 (ref="1");
    model Abdominal_obesity_Waist = added_Sugar_GR5g_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50 wholegrainmilledn_GR50
        hypertension Dyslipideamia NDD_cat PD_cat BMI
        / clodds clparm;
run;

/*------------------------------------------------------------------------------------------*/
/* ----------------------region wise Odds ratio code for survey samples---------------------*/
/*--------------------------------Step 32 to Step 38----------------------------------------*/
/*------------------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
/* Step 39: Survey-Weighted Logistic Regression for Carbohydrate Energy Intake by region wise*/
/*----------------------------------------------------------------------------*/
/* Outcome: NDD (Newly diagnosed diabetes category) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;/* domain is used to get result region_wise*/
    weight WeightageT_2011_NEW;  /* Survey weight variable: Accounts for unequal selection probabilities */
    cluster PSUNo;              /* Cluster variable: Accounts for correlation within primary sampling units */
    strata state_code;          /* Stratification variable: Accounts for different sampling rates across states */
    class NDD_cat (ref="0") carb_E_t3 (ref="1");
    /* NDD_cat: Binary outcome (0=No NDD, 1=NDD). ref="0" sets 'No NDD' as the reference category. */
    /* carb_E_t3: Tertiles of carbohydrate energy intake.  ref="1" sets the lowest tertile as the reference group */
    model NDD_cat = carb_E_t3      /* Predict NDD_cat based on carbohydrate energy tertiles */
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code alcohol MAC_NUTRI_CALC_energy added_salt
        MAC_NUTRI_CALC_fat_E BMI_Asian_cutoff Abdominal_obesity_Waist
        hypertension dyslipideamia
        / clodds clparm;
    /* Covariates: Variables adjusted for in the model.
       clodds:  Requests odds ratios and their confidence limits.
       clparm: Requests parameter estimates and their confidence limits. */
run;

/* Outcome: PD (Pre-Diabetes) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class PD_cat (ref="0") carb_E_t3 (ref="1");
    model PD_cat = carb_E_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code alcohol MAC_NUTRI_CALC_energy added_salt
        MAC_NUTRI_CALC_fat_E BMI_Asian_cutoff Abdominal_obesity_Waist
        hypertension dyslipideamia
        / clodds clparm;
run;

/* Outcome: Generalised Obesity (BMI>=25) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class GeneralisedobesityBMI_above25 (ref="0") carb_E_t3 (ref="1");
    model GeneralisedobesityBMI_above25 = carb_E_t3
        Age Sex_code Fam_his_yes_No Smoking pal_code urm_code
        Study_conducted_year Edu_code alcohol MAC_NUTRI_CALC_energy added_salt
        MAC_NUTRI_CALC_fat_E hypertension dyslipideamia ndd_cat pd_cat
        / clodds clparm;
run;

/* Outcome: Abdominal Obesity */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class Abdominal_obesity_Waist (ref="0") carb_E_t3 (ref="1");
    model Abdominal_obesity_Waist = carb_E_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code alcohol MAC_NUTRI_CALC_energy added_salt
        MAC_NUTRI_CALC_fat_E BMI_Asian_cutoff ndd_cat pd_cat
        hypertension dyslipideamia
        / clodds clparm;
run;

/* Executes the PROC SURVEYLOGISTIC step. */
/*----------------------------------------------------------------------------*/
/* Step 40: Survey-Weighted Logistic Regression for Refined Cereals Tertiles by region wise*/
/*----------------------------------------------------------------------------*/
/* Outcome: NDD (Newly diagnosed diabetes category) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;  /* Survey weight variable: Accounts for unequal selection probabilities */
    cluster PSUNo;              /* Cluster variable: Accounts for correlation within primary sampling units */
    strata state_code;          /* Stratification variable: Accounts for different sampling rates across states */
    class NDD_cat (ref="0") refined_cereals_GR50_t3 (ref="1");
    /* NDD_cat: Binary outcome (0=No NDD, 1=NDD). ref="0" sets 'No NDD' as the reference category. */
    /* refined_cereals_GR50_t3:  Tertiles of refined cereals intake. ref="1" sets the lowest tertile as the reference.
       It's crucial to ensure tertiles are coded as 1, 2, and 3. If your coding is different, change ref="1" accordingly. */
    model NDD_cat = refined_cereals_GR50_t3  /* Predict NDD_cat based on refined cereals tertiles */
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
    /* Covariates:  Variables adjusted for in the model to isolate the effect of refined cereals.
       clodds:  Requests odds ratios and their confidence limits.
       clparm: Requests parameter estimates and their confidence limits. */
run;

/* Outcome: PD (Pre-Diabetes) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class PD_cat (ref="0") refined_cereals_GR50_t3 (ref="1");
    /* PD_cat: Binary outcome (0=No PD, 1=PD). */
    model PD_cat = refined_cereals_GR50_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: Generalised Obesity (BMI>=25) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class GeneralisedobesityBMI_above25 (ref="0") refined_cereals_GR50_t3 (ref="1");
    /* GeneralisedobesityBMI_above25: Binary outcome (0=BMI<25, 1=BMI>=25). */
    model GeneralisedobesityBMI_above25 = refined_cereals_GR50_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        hypertension Dyslipideamia NDD_cat PD_cat
        / clodds clparm;
run;

/* Outcome: Abdominal Obesity */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class Abdominal_obesity_Waist (ref="0") refined_cereals_GR50_t3 (ref="1");
    /* Abdominal_obesity_Waist: Binary outcome (0=No abdominal obesity, 1=Abdominal obesity). */
    model Abdominal_obesity_Waist = refined_cereals_GR50_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        hypertension Dyslipideamia NDD_cat PD_cat BMI
        / clodds clparm;
run;

/*----------------------------------------------------------------------------*/
/* Step 41: Survey-Weighted Logistic Regression for White Rice Tertiles by region wise    */
/*----------------------------------------------------------------------------*/
/* Outcome: NDD (Newly diagnosed diabetes category) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class NDD_cat (ref="0") TotalWhitericeno0_t3 (ref="1");
    /* TotalWhitericeno0_t3: Tertiles of white rice intake. */
    model NDD_cat = TotalWhitericeno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: PD (Pre-Diabetes) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class PD_cat (ref="0") TotalWhitericeno0_t3 (ref="1");
    model PD_cat = TotalWhitericeno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: Generalised Obesity (BMI>=25) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class GeneralisedobesityBMI_above25 (ref="0") TotalWhitericeno0_t3 (ref="1");
    model GeneralisedobesityBMI_above25 = TotalWhitericeno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        hypertension Dyslipideamia NDD_cat PD_cat
        / clodds clparm;
run;

/* Outcome: Abdominal Obesity */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class Abdominal_obesity_Waist (ref="0") TotalWhitericeno0_t3 (ref="1");
    model Abdominal_obesity_Waist = TotalWhitericeno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 wholegrainmilledn_GR50
        hypertension Dyslipideamia NDD_cat PD_cat BMI
        / clodds clparm;
run;

/*----------------------------------------------------------------------------*/
/* Step 42: Survey-Weighted Logistic Regression for Wholegrains Tertiles by region wise    */
/*----------------------------------------------------------------------------*/
/* Outcome: NDD (Newly diagnosed diabetes category) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class NDD_cat (ref="0") wholegrainmilledn_GR50_t3 (ref="1");
     /* wholegrainmilledn_GR50_t3: Tertiles of wholegrain intake. */
    model NDD_cat = wholegrainmilledn_GR50_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: PD (Pre-Diabetes) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class PD_cat (ref="0") wholegrainmilledn_GR50_t3 (ref="1");
    model PD_cat = wholegrainmilledn_GR50_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: Generalised Obesity (BMI>=25) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class GeneralisedobesityBMI_above25 (ref="0") wholegrainmilledn_GR50_t3 (ref="1");
    model GeneralisedobesityBMI_above25 = wholegrainmilledn_GR50_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        hypertension Dyslipideamia NDD_cat PD_cat
        / clodds clparm;
run;

/* Outcome: Abdominal Obesity */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class Abdominal_obesity_Waist (ref="0") wholegrainmilledn_GR50_t3 (ref="1");
    model Abdominal_obesity_Waist = wholegrainmilledn_GR50_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        hypertension Dyslipideamia NDD_cat PD_cat BMI
        / clodds clparm;
run;

/*----------------------------------------------------------------------------*/
/* Step 43: Survey-Weighted Logistic Regression for Wheat Intake Tertiles by region wise */
/*----------------------------------------------------------------------------*/
/* Outcome: NDD (Newly diagnosed diabetes category) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;  /* Survey weight variable: Accounts for unequal selection probabilities */
    cluster PSUNo;              /* Cluster variable: Accounts for correlation within primary sampling units */
    strata state_code;          /* Stratification variable: Accounts for different sampling rates across states */
    class NDD_cat (ref="0") Total_wheat_no_t3 (ref="1");
    /* NDD_cat: Binary outcome (0=No NDD, 1=NDD). ref="0" sets 'No NDD' as the reference category. */
    /* Total_wheat_no_t3: Tertiles of total wheat intake. ref="1" sets the lowest tertile as the reference. */
    model NDD_cat = Total_wheat_no_t3  /* Predict NDD_cat based on wheat tertiles */
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
    /* Covariates:  Variables adjusted for in the model.
       clodds:  Requests odds ratios and their confidence limits.
       clparm: Requests parameter estimates and their confidence limits. */
run;

/* Outcome: PD (Pre-Diabetes) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class PD_cat (ref="0") Total_wheat_no_t3 (ref="1");
    model PD_cat = Total_wheat_no_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: Generalised Obesity (BMI>=25) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class GeneralisedobesityBMI_above25 (ref="0") Total_wheat_no_t3 (ref="1");
    model GeneralisedobesityBMI_above25 = Total_wheat_no_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        hypertension Dyslipideamia NDD_cat PD_cat
        / clodds clparm;
run;

/* Outcome: Abdominal Obesity */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class Abdominal_obesity_Waist (ref="0") Total_wheat_no_t3 (ref="1");
    model Abdominal_obesity_Waist = Total_wheat_no_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        hypertension Dyslipideamia NDD_cat PD_cat BMI
        / clodds clparm;
run;

/*----------------------------------------------------------------------------*/
/* Step 44: Survey-Weighted Logistic Regression for Millets Intake Tertiles by region wise*/
/*----------------------------------------------------------------------------*/
/* Outcome: NDD (Newly diagnosed diabetes category) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class NDD_cat (ref="0") Totalmilletsno0_t3 (ref="1");
    /* Totalmilletsno0_t3: Tertiles of total millets intake. */
    model NDD_cat = Totalmilletsno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia fbs
        / clodds clparm;
run;

/* Outcome: PD (Pre-Diabetes) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class PD_cat (ref="0") Totalmilletsno0_t3 (ref="1");
    model PD_cat = Totalmilletsno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: Generalised Obesity (BMI>=25) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class GeneralisedobesityBMI_above25 (ref="0") Totalmilletsno0_t3 (ref="1");
    model GeneralisedobesityBMI_above25 = Totalmilletsno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        hypertension Dyslipideamia NDD_cat PD_cat
        / clodds clparm;
run;

/* Outcome: Abdominal Obesity */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class Abdominal_obesity_Waist (ref="0") Totalmilletsno0_t3 (ref="1");
    model Abdominal_obesity_Waist = Totalmilletsno0_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50
        hypertension Dyslipideamia NDD_cat PD_cat BMI
        / clodds clparm;
run;

/*----------------------------------------------------------------------------*/
/* Step 45: Survey-Weighted Logistic Regression for Added Sugar Intake Tertiles by region wise */
/*----------------------------------------------------------------------------*/
/* Outcome: NDD (Newly diagnosed diabetes category) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class NDD_cat (ref="0") added_Sugar_GR5g_t3 (ref="1");
     /* added_Sugar_GR5g_t3: Tertiles of added sugar intake. */
    model NDD_cat = added_Sugar_GR5g_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50  wholegrainmilledn_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: PD (Pre-Diabetes) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class PD_cat (ref="0") added_Sugar_GR5g_t3 (ref="1");
    model PD_cat = added_Sugar_GR5g_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50 wholegrainmilledn_GR50
        bmi Abdominal_obesity_Waist hypertension Dyslipideamia
        / clodds clparm;
run;

/* Outcome: Generalised Obesity (BMI>=25) */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class GeneralisedobesityBMI_above25 (ref="0") added_Sugar_GR5g_t3 (ref="1");
    model GeneralisedobesityBMI_above25 = added_Sugar_GR5g_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50 wholegrainmilledn_GR50
        hypertension Dyslipideamia NDD_cat PD_cat
        / clodds clparm;
run;

/* Outcome: Abdominal Obesity */
proc surveylogistic data=Indiab.For_substitution;domain region_code;
    weight WeightageT_2011_NEW;
    cluster PSUNo;
    strata state_code;
    class Abdominal_obesity_Waist (ref="0") added_Sugar_GR5g_t3 (ref="1");
    model Abdominal_obesity_Waist = added_Sugar_GR5g_t3
        Age Sex_code Fam_his_yes_No Smoking pal_values urm_code
        Study_conducted_year Edu_code income alcohol MAC_NUTRI_CALC_energy
        MAC_NUTRI_CALC_fat_E added_salt Total_fruits_1 Total_vegetablesgreensroot
        Edible_oils Edible_fats Pulses_and_legumes_no0 Total_refined_cereals_GR50 wholegrainmilledn_GR50
        hypertension Dyslipideamia NDD_cat PD_cat BMI
        / clodds clparm;
run;

