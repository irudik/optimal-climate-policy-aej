********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
***************************************************CREATE DATA******************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
****************************************Create Marshallian Dataset*****************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************

clear
set more off
cd "C:\Users\phhoward\Documents\Research\Second Paper\Calculation\Post_AAEA\New\Revision 2\ForUpload\Consolidate"
use New_Metadata_051517

***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
****************************************************Drop Delete********************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
clear
use New_Metadata_051517
tab delete
list Study if delete==1
drop if delete==1
save New_Metadata_delete_051517, replace

***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
****************************************************Error Independence*************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************

********************************************************************************************************************************************************
*********************************************************Error Independence - All***********************************************************************
********************************************************************************************************************************************************

clear
use New_Metadata_delete_051517

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
*Add Berz, Burke, and Horowitz
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Burke"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz" 
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
*replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2


***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other" if Primary_model=="Bluedorn"
replace model_app="panel" if Primary_model=="Dell"
replace model_app="panel" if Primary_model=="Burke"
replace model_app="other" if Primary_model=="Env-Linkages"
replace model_app="other" if Primary_model=="GIAM"
replace model_app="other" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other" if Primary_model=="WITCH"
egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model3=author+method + replace****************************************************************************
gen model3_app=model2_app
replace model3_app="enumerativeTol" if obs==10
replace model3_app="enumerativeNordhaus" if Hope06_09==1 & model3_app =="enumerativeHope"
replace model3_app="enumerativeNordhaus" if Hane==1
replace model3_app="enumerativeFankhauser" if Meyer==1
replace model3_app="enumerativeManne" if GIAM==1
replace model3_app="enumerativeNordhaus" if WITCH==1
replace model3_app="enumerativeBosello or Eboli" if Dellink==1
egen model3 = group(model3_app)
sort model3
by model3: gen study_model3=_n
xtset model3 study_model3

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method2 + replace****************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
replace model4_app="CGE-ProductionBosello or Eboli" if Dellink==1
egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

********************************************By Model5=model3 + replace
gen model5_app=model4_app
replace model5_app="enumerativeTol" if obs==10
replace model5_app="enumerativeNordhaus" if Hope06_09==1 & model5_app =="enumerativeHope"
replace model5_app="enumerativeNordhaus" if Hane==1
replace model5_app="enumerativeFankhauser" if Meyer==1
replace model5_app="enumerativeManne" if GIAM==1
replace model5_app="enumerativeNordhaus" if WITCH==1
replace model5_app="enumerativeBosello or Eboli" if Dellink==1

egen model5 = group(model5_app)
sort model5
by model5: gen study_model5=_n
xtset model5 study_model5

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_All_Delete_051517, replace


********************************************************************************************************************************************************
*********************************************************Error Independence - Low and Drop Delete - Alt ******************************************************
********************************************************************************************************************************************************


clear
use New_Metadata_Delete_051517
keep if Group_new==1
*keep if delete==0
*save New_Metadata_Low_Delete_070215, replace

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other" if Primary_model=="Bluedorn"
replace model_app="other" if Primary_model=="CRED"
replace model_app="other" if Primary_model=="Dell"
replace model_app="CGE_other" if Primary_model=="ENVISAGE"
replace model_app="CGE_other" if Primary_model=="Env-Linkages"
replace model_app="other" if Primary_model=="GIAM"
replace model_app="other" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other" if Primary_model=="WITCH"
egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
replace model2_app="CGE_other" if Primary_model=="ENVISAGE"
replace model2_app="CGE_other" if Primary_model=="Env-Linkages"
egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model3=author+method + replace****************************************************************************
gen model3_app=model2_app
replace model3_app="enumerativeTol" if obs==10
replace model3_app="enumerativeNordhaus" if Hope06_09==1 & model3_app =="enumerativeHope"
replace model3_app="enumerativeNordhaus" if Hane==1
replace model3_app="enumerativeFankhauser" if Meyer==1
replace model3_app="enumerativeManne" if GIAM==1
replace model3_app="enumerativeNordhaus" if WITCH==1
replace model3_app="enumerativeBosello or Eboli" if Dellink==1
***Reduce groups
replace model3_app="CGE" if model3_app=="enumerativeBosello or Eboli" 
replace model3_app="CGE" if model3_app=="CGE_other"

egen model3 = group(model3_app)
sort model3
by model3: gen study_model3=_n
xtset model3 study_model3

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method2 + replace****************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
*replace model4_app="CGE" if Method2=="CGE-Production"
egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model5=model4 + replace****************************************************************************
gen model5_app=model4_app
replace model5_app="enumerativeTol" if obs==10
replace model5_app="enumerativeNordhaus" if Hope06_09==1 & model5_app =="enumerativeHope"
replace model5_app="enumerativeNordhaus" if Hane==1
replace model5_app="enumerativeFankhauser" if Meyer==1
replace model5_app="enumerativeManne" if GIAM==1
replace model5_app="enumerativeNordhaus" if WITCH==1
replace model5_app="CGE-ProductionBosello or Eboli" if Dellink==1
***Reduce groups
replace model5_app="CGE" if Method2=="CGE-Production"

egen model5 = group(model5_app)
sort model5
by model5: gen study_model5=_n
xtset model5 study_model5

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_Low_Delete_alt_051517, replace

********************************************************************************************************************************************************
********************************************************************************************************************************************************
****************************************************************Latest**********************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

********************************************************************************************************************************************************
*********************************************************Error Independence - All - Keep Latest*********************************************************
********************************************************************************************************************************************************

clear
use New_Metadata_delete_051517
keep if Group_latest_high==1

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Burke"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Schauer"
*new
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Hope"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="panel" if Primary_model=="Dell"
replace model_app="panel" if Primary_model=="Burke"
replace model_app="other_CGE" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="other_CGE" if Primary_model=="ICES"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="MERGE"
replace model_app="other_enum" if Primary_model=="PAGE"

egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
replace model2_app="enumerativeother" if model2_app=="enumerativeNordhaus"
replace model2_app="statisticalother" if model2_app=="statisticalNordhaus"
***Add CGE control"
*replace model2_app="CGE" if CGE=="GTAP"

egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model3=author+method + replace****************************************************************************
gen model3_app=method_app+author_app
replace model3_app="survey" if model3_app=="SurveyNordhaus"
replace model3_app="survey" if model3_app=="Surveyother"
replace model3_app="statisticalother" if model3_app=="statisticalNordhaus"
*replace
replace model3_app="enumerativeNordhaus" if Hope06_09==1 & model3_app =="enumerativeHope"
replace model3_app="enumerativeNordhaus" if Hane==1
replace model3_app="enumerativeFankhauser" if Meyer==1
replace model3_app="enumerativeManne" if GIAM==1
replace model3_app="enumerativeNordhaus" if WITCH==1
replace model3_app="enumerativeBosello or Eboli" if Dellink==1

egen model3 = group(model3_app)
sort model3
by model3: gen study_model3=_n
xtset model3 study_model3

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2


***********************************************By Model4=author+method2 + replace****************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus" 
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"
***Just renames a variable
replace model4_app="CGE-ProductionBosello or Eboli" if Dellink==1

egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

********************************************By Model5=model3 + replace
gen model5_app=method2_app+author_app
replace model5_app="survey" if model5_app=="SurveyNordhaus"
replace model5_app="survey" if model5_app=="Surveyother"
replace model5_app="statisticalother" if model5_app=="statisticalNordhaus"
*replace
replace model5_app="enumerativeNordhaus" if Hope06_09==1 & model5_app =="enumerativeHope"
replace model5_app="enumerativeNordhaus" if Hane==1
replace model5_app="enumerativeFankhauser" if Meyer==1
replace model5_app="enumerativeManne" if GIAM==1
replace model5_app="enumerativeNordhaus" if WITCH==1
replace model5_app="CGE-ProductionBosello or Eboli" if Dellink==1

egen model5 = group(model5_app)
sort model5
by model5: gen study_model5=_n
xtset model5 study_model5

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_All_Latest_051517, replace


*******************************************************************************************************************************************************
*********************************************************Error Independence - Low - Keep Latest - Alt *************************************************
*******************************************************************************************************************************************************


clear
use New_Metadata_delete_051517
keep if Group_latest==1

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
*New
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
replace author_app="other" if Primary_Author=="Hope"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="other_enum" if Primary_model=="CRED"
replace model_app="other_stat" if Primary_model=="Dell"
replace model_app="CGE" if Primary_model=="ENVISAGE"
replace model_app="CGE" if Primary_model=="ICES"
replace model_app="CGE" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
*replace model_app="other_enum" if Primary_model=="DICE"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="MERGE"
*replace model_app="other_enum" if Primary_model=="Fankhauser"
replace model_app="other_enum" if Primary_model=="PAGE"

egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
replace model2_app="enumerativeother" if model2_app=="enumerativeNordhaus"
replace model2_app="statisticalother" if model2_app=="statisticalNordhaus"

egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model3=author+method + replace****************************************************************************
gen model3_app=method_app+author_app
replace model3_app="survey" if model3_app=="SurveyNordhaus"
replace model3_app="survey" if model3_app=="Surveyother"
replace model3_app="statisticalother" if model3_app=="statisticalNordhaus"
*Replace
replace model3_app="enumerativeNordhaus" if Hope06_09==1 & model3_app =="enumerativeHope"
replace model3_app="enumerativeNordhaus" if Hane==1
replace model3_app="enumerativeFankhauser" if Meyer==1
replace model3_app="enumerativeManne" if GIAM==1
replace model3_app="enumerativeNordhaus" if WITCH==1
replace model3_app="enumerativeBosello or Eboli" if Dellink==1

egen model3 = group(model3_app)
sort model3
by model3: gen study_model3=_n
xtset model3 study_model3

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method**************************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus"
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"

egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model5=model4 + replace****************************************************************************
gen model5_app=method2_app+author_app
replace model5_app="survey" if model5_app=="SurveyNordhaus"
replace model5_app="survey" if model5_app=="Surveyother"
replace model5_app="statisticalother" if model5_app=="statisticalNordhaus"
*replace
replace model5_app="enumerativeNordhaus" if Hope06_09==1 & model5_app =="enumerativeHope"
replace model5_app="enumerativeNordhaus" if Hane==1
replace model5_app="enumerativeFankhauser" if Meyer==1
replace model5_app="enumerativeManne" if GIAM==1
replace model5_app="enumerativeNordhaus" if WITCH==1
replace model5_app="CGE-ProductionBosello or Eboli" if Dellink==1
***Reduce groups
replace model5_app="CGE" if Method2=="CGE-Production"

egen model5 = group(model5_app)
sort model5
by model5: gen study_model5=_n
xtset model5 study_model5

xtreg damage, mle
display "Intra-class correlation for author groups: " e(rho)
corr damage L1.damage
display "Correlation for adjoining method:" r(rho)

xtreg damage T2_new, fe
xttest2

save New_Metadata_Low_Latest_alt_051517, replace

********************************************************************************************************************************************************
********************************************************************************************************************************************************
****************************************************************Drop Based******************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

********************************************************************************************************************************************************
*********************************************************Error Independence - All and Drop Delete and Keep Latest and Drop Based on Other***************
********************************************************************************************************************************************************

clear
use New_Metadata_delete_051517
keep if delete==0
replace Based_On_Other =0 if Primary_Author=="Meyer"
replace Based_On_Other =0 if Primary_Author=="Hanemann"
keep if Based_On_Other==0
keep if Group_latest_high==1
list Study

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Burke"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Schauer"
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Hope"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2


***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="panel" if Primary_model=="Dell"
replace model_app="panel" if Primary_model=="Burke"
replace model_app="other" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="CGE" if Primary_model=="ICES"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
*replace model_app="other_enum" if Primary_model=="DICE"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="MERGE"
replace model_app="CGE" if Primary_model=="ENVISAGE"

egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
replace model2_app="enumerativeother" if model2_app=="enumerativeNordhaus"
replace model2_app="statisticalother" if model2_app=="statisticalNordhaus"
***Add CGE control"
*replace model2_app="CGE" if CGE=="GTAP"


egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method2 + replace****************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus" 
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"
***Just renames a variable
replace model4_app="CGE" if Method2=="CGE-Production"

egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_All_Delete_Latest_051517, replace



********************************************************************************************************************************************************
*********************************************************Error Independence - Low and Drop Delete and Keep Latest and Based on Other - Alt**************
********************************************************************************************************************************************************

clear
use New_Metadata_delete_051517
keep if delete==0
replace Based_On_Other =0 if Primary_Author=="Hanemann"
replace Based_On_Other =0 if Primary_Author=="Meyer"
keep if Based_On_Other==0
keep if Group_latest==1

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Hope"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="other_enum" if Primary_model=="CRED"
replace model_app="other_stat" if Primary_model=="Dell"
replace model_app="CGE" if Primary_model=="ENVISAGE"
replace model_app="CGE" if Primary_model=="ICES"
replace model_app="CGE" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
*replace model_app="other_enum" if Primary_model=="DICE"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="MERGE"
*replace model_app="other_enum" if Primary_model=="Fankhauser"
replace model_app="other_enum" if Primary_model=="PAGE"

egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
replace model2_app="enumerativeother" if model2_app=="enumerativeNordhaus"
replace model2_app="statisticalother" if model2_app=="statisticalNordhaus"

egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method**************************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus"
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"

egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_Low_Delete_Latest_alt_051517, replace

********************************************************************************************************************************************************
********************************************************************************************************************************************************
****************************************************************Preferred*******************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************


********************************************************************************************************************************************************
*********************************************************Error Independence - All and Drop Delete and Keep Latest and Preferred*************************
********************************************************************************************************************************************************

clear
use New_Metadata_delete_051517
keep if delete==0
replace Based_On_Other =0 if Primary_Author=="Meyer"
replace Based_On_Other =0 if Primary_Author=="Hanemann"
keep if Based_On_Other==0
keep if Group_latest_high==1
keep if prefer==1
list Study

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Burke"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Howard"
replace author_app="other" if Primary_Author=="Mendelsohn"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Hope"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
replace author_app="other" if Primary_Author=="Weitzman"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="panel" if Primary_model=="Dell"
replace model_app="panel" if Primary_model=="Burke"
replace model_app="CGE" if Primary_model=="ENVISAGE"
replace model_app="other" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Howard Survey"
replace model_app="CGE" if Primary_model=="ICES"
replace model_app="other_enum" if Primary_model=="Mendelsohn"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
*replace model_app="other_enum" if Primary_model=="DICE"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="MERGE"

egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
replace model2_app="enumerativeother" if model2_app=="enumerativeNordhaus"
replace model2_app="statisticalother" if model2_app=="statisticalNordhaus"
replace model2_app="science" if model2_app=="ScienceNordhaus"
replace model2_app="science" if model2_app=="Scienceother"
***Add CGE control"
*replace model2_app="CGE" if CGE=="GTAP"

egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method2 + replace****************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus" 
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"
replace model4_app="science" if model4_app=="ScienceNordhaus"
replace model4_app="science" if model4_app=="Scienceother"

egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_All_Prefer_051517, replace



********************************************************************************************************************************************************
*********************************************************Error Independence - Low and Drop Delete and Keep Latest and Preferred - Alt*******************
********************************************************************************************************************************************************

clear
use New_Metadata_delete_051517
keep if delete==0
replace Based_On_Other =0 if Primary_Author=="Hanemann"
replace Based_On_Other =0 if Primary_Author=="Meyer"
keep if prefer==1
keep if Based_On_Other==0
keep if Group_latest==1

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Howard"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Mendelsohn"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Hope"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
replace method_app="enumerative" if method_app=="Science"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
replace method2_app="enumerative" if method2_app=="Science"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="other_enum" if Primary_model=="CRED"
replace model_app="other_stat" if Primary_model=="Dell"
replace model_app="CGE" if Primary_model=="ENVISAGE"
replace model_app="CGE" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Howard Survey" 
replace model_app="CGE" if Primary_model=="ICES"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
*replace model_app="other_enum" if Primary_model=="DICE"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="Mendelsohn"
replace model_app="other_enum" if Primary_model=="MERGE"
*replace model_app="other_enum" if Primary_model=="Fankhauser"

egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
*replace model2_app="enumerativeother" if model2_app=="enumerativeNordhaus"
replace model2_app="statisticalother" if model2_app=="statisticalNordhaus"
*replace model2_app="other_enum" if model2_app=="ScienceNordhaus"


egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method**************************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
*replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus"
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"

egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_Low_Prefer_alt_051517, replace

********************************************************************************************************************************************************
********************************************************************************************************************************************************
************************************************************Creater low dataset with 4.5 temperature low boundary***************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************



********************************************************************************************************************************************************
********************************************************************************************************************************************************
****************************************************************Delete**********************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

clear
use New_Metadata_delete_051517
keep if T_new<4.5

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Burke"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other" if Primary_model=="Bluedorn"
replace model_app="other" if Primary_model=="CRED"
replace model_app="Panel" if Primary_model=="Burke"
replace model_app="Panel" if Primary_model=="Dell"
replace model_app="CGE_other" if Primary_model=="ENVISAGE"
replace model_app="CGE_other" if Primary_model=="Env-Linkages"
replace model_app="other" if Primary_model=="GIAM"
replace model_app="other" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other" if Primary_model=="WITCH"
egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method2 + replace****************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
*replace model4_app="CGE" if Method2=="CGE-Production"
egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_delete_4p5_051517, replace

********************************************************************************************************************************************************
********************************************************************************************************************************************************
****************************************************************Latest**********************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************


clear
use New_Metadata_delete_051517
keep if T_new<4.5
replace Group_latest=1 if obs==23
replace Group_latest=1 if obs==47
keep if Group_latest==1

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Burke"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
*New
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
replace author_app="other" if Primary_Author=="Hope"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="other_enum" if Primary_model=="CRED"
replace model_app="Panel" if Primary_model=="Burke"
replace model_app="Panel" if Primary_model=="Dell"
replace model_app="CGE" if Primary_model=="ENVISAGE"
replace model_app="CGE" if Primary_model=="ICES"
replace model_app="CGE" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
*replace model_app="other_enum" if Primary_model=="DICE"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="MERGE"
*replace model_app="other_enum" if Primary_model=="Fankhauser"
replace model_app="other_enum" if Primary_model=="PAGE"


egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method**************************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus"
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"

egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2


save New_Metadata_Low_Latest_4p5_051517, replace

********************************************************************************************************************************************************
********************************************************************************************************************************************************
****************************************************************Drop Based******************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************


clear
use New_Metadata_delete_051517
keep if T_new<4.5
keep if delete==0
replace Based_On_Other =0 if Primary_Author=="Hanemann"
replace Based_On_Other =0 if Primary_Author=="Meyer"
keep if Based_On_Other==0
replace Group_latest=1 if obs==23
replace Group_latest=1 if obs==47
keep if Group_latest==1


keep if delete==0
replace Based_On_Other =0 if Primary_Author=="Hanemann"
keep if Based_On_Other==0
keep if Group_latest==1

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Burke"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Hope"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="other_enum" if Primary_model=="CRED"
replace model_app="Panel" if Primary_model=="Burke"
replace model_app="Panel" if Primary_model=="Dell"
replace model_app="CGE" if Primary_model=="ENVISAGE"
replace model_app="other_enum" if Primary_model=="Fankhauser"
replace model_app="CGE" if Primary_model=="ICES"
replace model_app="CGE" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
*replace model_app="other_enum" if Primary_model=="DICE"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="MERGE"
*replace model_app="other_enum" if Primary_model=="Fankhauser"
replace model_app="other_enum" if Primary_model=="PAGE"


egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method2 + replace****************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus"
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"
egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_Low_Delete_Latest_4p5_051517, replace



********************************************************************************************************************************************************
********************************************************************************************************************************************************
****************************************************************Preferred*******************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

clear
use New_Metadata_delete_051517
keep if T_new<4.5
keep if delete==0
replace Based_On_Other =0 if Primary_Author=="Hanemann"
replace Based_On_Other =0 if Primary_Author=="Meyer"
keep if prefer==1
keep if Based_On_Other==0
replace Group_latest=1 if obs==23
replace Group_latest=1 if obs==47
keep if Group_latest==1


***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Burke"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Howard"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Mendelsohn"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Hope"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
replace method2_app="enumerative" if method2_app=="Science"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="other_enum" if Primary_model=="CRED"
replace model_app="Panel" if Primary_model=="Burke"
replace model_app="Panel" if Primary_model=="Dell"
replace model_app="CGE" if Primary_model=="ENVISAGE"
replace model_app="CGE" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Howard Survey" 
replace model_app="CGE" if Primary_model=="ICES"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
*replace model_app="other_enum" if Primary_model=="DICE"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="Mendelsohn"
replace model_app="other_enum" if Primary_model=="MERGE"
*replace model_app="other_enum" if Primary_model=="Fankhauser"

egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method**************************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
*replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus"
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"

egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_low_prefer_4p5_051517, replace



***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
*******************************************Create Hicksian Dataset*****************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************

clear
set more off
use New_Metadata_051517

***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
****************************************************Import data********************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************

cd "C:\Users\phhoward\Documents\Research\Second Paper\Calculation\Post_AAEA\New\Revision 2\ForUpload\Consolidate"
save New_Metadata_H051517, replace

***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
****************************************************Drop Delete********************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************

list Study D_new T_new if delete==1
replace delete=0 if Nonmarket==1
list Study D_new T_new if delete==1
tab delete
drop if delete==1
save New_Metadata_delete_H051517, replace

***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
****************************************************Error Independence*************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************

********************************************************************************************************************************************************
*********************************************************Error Independence - All***********************************************************************
********************************************************************************************************************************************************

clear
use New_Metadata_delete_H051517

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
*Add Berz, Burke, and Horowitz
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Burke"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz" 
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
*replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2


***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other" if Primary_model=="Bluedorn"
replace model_app="panel" if Primary_model=="Dell"
replace model_app="panel" if Primary_model=="Burke"
replace model_app="other" if Primary_model=="Env-Linkages"
replace model_app="other" if Primary_model=="GIAM"
replace model_app="other" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other" if Primary_model=="WITCH"
replace model_app="Maddison" if Primary_Author=="Maddison"
egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model3=author+method + replace****************************************************************************
gen model3_app=model2_app
replace model3_app="enumerativeTol" if obs==10
replace model3_app="enumerativeNordhaus" if Hope06_09==1 & model3_app =="enumerativeHope"
replace model3_app="enumerativeNordhaus" if Hane==1
replace model3_app="enumerativeFankhauser" if Meyer==1
replace model3_app="enumerativeManne" if GIAM==1
replace model3_app="enumerativeNordhaus" if WITCH==1
replace model3_app="enumerativeBosello or Eboli" if Dellink==1
egen model3 = group(model3_app)
sort model3
by model3: gen study_model3=_n
xtset model3 study_model3

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method2 + replace****************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
replace model4_app="CGE-ProductionBosello or Eboli" if Dellink==1
egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

********************************************By Model5=model3 + replace
gen model5_app=model4_app
replace model5_app="enumerativeTol" if obs==10
replace model5_app="enumerativeNordhaus" if Hope06_09==1 & model5_app =="enumerativeHope"
replace model5_app="enumerativeNordhaus" if Hane==1
replace model5_app="enumerativeFankhauser" if Meyer==1
replace model5_app="enumerativeManne" if GIAM==1
replace model5_app="enumerativeNordhaus" if WITCH==1
replace model5_app="enumerativeBosello or Eboli" if Dellink==1

egen model5 = group(model5_app)
sort model5
by model5: gen study_model5=_n
xtset model5 study_model5

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_All_Delete_H051517, replace




********************************************************************************************************************************************************
*********************************************************Error Independence - Low and Drop Delete - Alt ******************************************************
********************************************************************************************************************************************************


clear
use New_Metadata_Delete_H051517
keep if Group_new==1
*keep if delete==0
*save New_Metadata_Low_Delete_070215, replace

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other" if Primary_model=="Bluedorn"
replace model_app="other" if Primary_model=="CRED"
replace model_app="other" if Primary_model=="Dell"
replace model_app="CGE_other" if Primary_model=="ENVISAGE"
replace model_app="CGE_other" if Primary_model=="Env-Linkages"
replace model_app="other" if Primary_model=="GIAM"
replace model_app="other" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other" if Primary_model=="WITCH"
replace model_app="Maddison" if Primary_Author=="Maddison"
egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
replace model2_app="CGE_other" if Primary_model=="ENVISAGE"
replace model2_app="CGE_other" if Primary_model=="Env-Linkages"
egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model3=author+method + replace****************************************************************************
gen model3_app=model2_app
replace model3_app="enumerativeTol" if obs==10
replace model3_app="enumerativeNordhaus" if Hope06_09==1 & model3_app =="enumerativeHope"
replace model3_app="enumerativeNordhaus" if Hane==1
replace model3_app="enumerativeFankhauser" if Meyer==1
replace model3_app="enumerativeManne" if GIAM==1
replace model3_app="enumerativeNordhaus" if WITCH==1
replace model3_app="enumerativeBosello or Eboli" if Dellink==1
***Reduce groups
replace model3_app="CGE" if model3_app=="enumerativeBosello or Eboli" 
replace model3_app="CGE" if model3_app=="CGE_other"

egen model3 = group(model3_app)
sort model3
by model3: gen study_model3=_n
xtset model3 study_model3

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method2 + replace****************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
*replace model4_app="CGE" if Method2=="CGE-Production"
egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model5=model4 + replace****************************************************************************
gen model5_app=model4_app
replace model5_app="enumerativeTol" if obs==10
replace model5_app="enumerativeNordhaus" if Hope06_09==1 & model5_app =="enumerativeHope"
replace model5_app="enumerativeNordhaus" if Hane==1
replace model5_app="enumerativeFankhauser" if Meyer==1
replace model5_app="enumerativeManne" if GIAM==1
replace model5_app="enumerativeNordhaus" if WITCH==1
replace model5_app="CGE-ProductionBosello or Eboli" if Dellink==1
***Reduce groups
replace model5_app="CGE" if Method2=="CGE-Production"

egen model5 = group(model5_app)
sort model5
by model5: gen study_model5=_n
xtset model5 study_model5

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_Low_Delete_alt_H051517, replace

********************************************************************************************************************************************************
********************************************************************************************************************************************************
****************************************************************Latest**********************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

********************************************************************************************************************************************************
*********************************************************Error Independence - All - Keep Latest*********************************************************
********************************************************************************************************************************************************

clear
use New_Metadata_delete_H051517
keep if Group_latest_high==1

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Burke"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Schauer"
*new
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Hope"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="panel" if Primary_model=="Dell"
replace model_app="panel" if Primary_model=="Burke"
replace model_app="other_CGE" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="other_CGE" if Primary_model=="ICES"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="MERGE"
replace model_app="other_enum" if Primary_model=="PAGE"
replace model_app="Maddison" if Primary_Author=="Maddison"

egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
replace model2_app="enumerativeother" if model2_app=="enumerativeNordhaus"
replace model2_app="statisticalother" if model2_app=="statisticalNordhaus"
***Add CGE control"
*replace model2_app="CGE" if CGE=="GTAP"

egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model3=author+method + replace****************************************************************************
gen model3_app=method_app+author_app
replace model3_app="survey" if model3_app=="SurveyNordhaus"
replace model3_app="survey" if model3_app=="Surveyother"
replace model3_app="statisticalother" if model3_app=="statisticalNordhaus"
*replace
replace model3_app="enumerativeNordhaus" if Hope06_09==1 & model3_app =="enumerativeHope"
replace model3_app="enumerativeNordhaus" if Hane==1
replace model3_app="enumerativeFankhauser" if Meyer==1
replace model3_app="enumerativeManne" if GIAM==1
replace model3_app="enumerativeNordhaus" if WITCH==1
replace model3_app="enumerativeBosello or Eboli" if Dellink==1

egen model3 = group(model3_app)
sort model3
by model3: gen study_model3=_n
xtset model3 study_model3

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2


***********************************************By Model4=author+method2 + replace****************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus" 
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"
***Just renames a variable
replace model4_app="CGE-ProductionBosello or Eboli" if Dellink==1

egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

********************************************By Model5=model3 + replace
gen model5_app=method2_app+author_app
replace model5_app="survey" if model5_app=="SurveyNordhaus"
replace model5_app="survey" if model5_app=="Surveyother"
replace model5_app="statisticalother" if model5_app=="statisticalNordhaus"
*replace
replace model5_app="enumerativeNordhaus" if Hope06_09==1 & model5_app =="enumerativeHope"
replace model5_app="enumerativeNordhaus" if Hane==1
replace model5_app="enumerativeFankhauser" if Meyer==1
replace model5_app="enumerativeManne" if GIAM==1
replace model5_app="enumerativeNordhaus" if WITCH==1
replace model5_app="CGE-ProductionBosello or Eboli" if Dellink==1

egen model5 = group(model5_app)
sort model5
by model5: gen study_model5=_n
xtset model5 study_model5

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_All_Latest_H051517, replace


*******************************************************************************************************************************************************
*********************************************************Error Independence - Low - Keep Latest - Alt *************************************************
*******************************************************************************************************************************************************


clear
use New_Metadata_delete_H051517
keep if Group_latest==1

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
*New
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
replace author_app="other" if Primary_Author=="Hope"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="other_enum" if Primary_model=="CRED"
replace model_app="other_stat" if Primary_model=="Dell"
replace model_app="CGE" if Primary_model=="ENVISAGE"
replace model_app="CGE" if Primary_model=="ICES"
replace model_app="CGE" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
*replace model_app="other_enum" if Primary_model=="DICE"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="MERGE"
*replace model_app="other_enum" if Primary_model=="Fankhauser"
replace model_app="other_enum" if Primary_model=="PAGE"
replace model_app="Maddison" if Primary_Author=="Maddison"

egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
replace model2_app="enumerativeother" if model2_app=="enumerativeNordhaus"
replace model2_app="statisticalother" if model2_app=="statisticalNordhaus"

egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model3=author+method + replace****************************************************************************
gen model3_app=method_app+author_app
replace model3_app="survey" if model3_app=="SurveyNordhaus"
replace model3_app="survey" if model3_app=="Surveyother"
replace model3_app="statisticalother" if model3_app=="statisticalNordhaus"
*Replace
replace model3_app="enumerativeNordhaus" if Hope06_09==1 & model3_app =="enumerativeHope"
replace model3_app="enumerativeNordhaus" if Hane==1
replace model3_app="enumerativeFankhauser" if Meyer==1
replace model3_app="enumerativeManne" if GIAM==1
replace model3_app="enumerativeNordhaus" if WITCH==1
replace model3_app="enumerativeBosello or Eboli" if Dellink==1

egen model3 = group(model3_app)
sort model3
by model3: gen study_model3=_n
xtset model3 study_model3

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method**************************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus"
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"

egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model5=model4 + replace****************************************************************************
gen model5_app=method2_app+author_app
replace model5_app="survey" if model5_app=="SurveyNordhaus"
replace model5_app="survey" if model5_app=="Surveyother"
replace model5_app="statisticalother" if model5_app=="statisticalNordhaus"
*replace
replace model5_app="enumerativeNordhaus" if Hope06_09==1 & model5_app =="enumerativeHope"
replace model5_app="enumerativeNordhaus" if Hane==1
replace model5_app="enumerativeFankhauser" if Meyer==1
replace model5_app="enumerativeManne" if GIAM==1
replace model5_app="enumerativeNordhaus" if WITCH==1
replace model5_app="CGE-ProductionBosello or Eboli" if Dellink==1
***Reduce groups
replace model5_app="CGE" if Method2=="CGE-Production"

egen model5 = group(model5_app)
sort model5
by model5: gen study_model5=_n
xtset model5 study_model5

xtreg damage, mle
display "Intra-class correlation for author groups: " e(rho)
corr damage L1.damage
display "Correlation for adjoining method:" r(rho)

xtreg damage T2_new, fe
xttest2

save New_Metadata_Low_Latest_alt_H051517, replace

********************************************************************************************************************************************************
********************************************************************************************************************************************************
****************************************************************Drop Based******************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

********************************************************************************************************************************************************
*********************************************************Error Independence - All and Drop Delete and Keep Latest and Drop Based on Other***************
********************************************************************************************************************************************************

clear
use New_Metadata_delete_H051517
keep if delete==0
replace Based_On_Other =0 if Primary_Author=="Meyer"
replace Based_On_Other =0 if Primary_Author=="Hanemann"
keep if Based_On_Other==0
keep if Group_latest_high==1
list Study

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Burke"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Schauer"
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Hope"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2


***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="panel" if Primary_model=="Dell"
replace model_app="panel" if Primary_model=="Burke"
replace model_app="other" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="CGE" if Primary_model=="ICES"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
*replace model_app="other_enum" if Primary_model=="DICE"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="MERGE"
replace model_app="CGE" if Primary_model=="ENVISAGE"
replace model_app="Maddison" if Primary_Author=="Maddison"

egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
replace model2_app="enumerativeother" if model2_app=="enumerativeNordhaus"
replace model2_app="statisticalother" if model2_app=="statisticalNordhaus"
***Add CGE control"
*replace model2_app="CGE" if CGE=="GTAP"


egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method2 + replace****************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus" 
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"
***Just renames a variable
replace model4_app="CGE" if Method2=="CGE-Production"

egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_All_Delete_Latest_H051517, replace



********************************************************************************************************************************************************
*********************************************************Error Independence - Low and Drop Delete and Keep Latest and Based on Other - Alt**************
********************************************************************************************************************************************************

clear
use New_Metadata_delete_H051517
keep if delete==0
replace Based_On_Other =0 if Primary_Author=="Hanemann"
replace Based_On_Other =0 if Primary_Author=="Meyer"
keep if Based_On_Other==0
keep if Group_latest==1

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Hope"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="other_enum" if Primary_model=="CRED"
replace model_app="other_stat" if Primary_model=="Dell"
replace model_app="CGE" if Primary_model=="ENVISAGE"
replace model_app="CGE" if Primary_model=="ICES"
replace model_app="CGE" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
*replace model_app="other_enum" if Primary_model=="DICE"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="MERGE"
*replace model_app="other_enum" if Primary_model=="Fankhauser"
replace model_app="other_enum" if Primary_model=="PAGE"
replace model_app="Maddison" if Primary_Author=="Maddison"

egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
replace model2_app="enumerativeother" if model2_app=="enumerativeNordhaus"
replace model2_app="statisticalother" if model2_app=="statisticalNordhaus"

egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method**************************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus"
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"

egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_Low_Delete_Latest_alt_H051517, replace

********************************************************************************************************************************************************
********************************************************************************************************************************************************
****************************************************************Preferred*******************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************


********************************************************************************************************************************************************
*********************************************************Error Independence - All and Drop Delete and Keep Latest and Preferred*************************
********************************************************************************************************************************************************

clear
use New_Metadata_delete_H051517
keep if delete==0
replace Based_On_Other =0 if Primary_Author=="Meyer"
replace Based_On_Other =0 if Primary_Author=="Hanemann"
keep if Based_On_Other==0
keep if Group_latest_high==1
keep if prefer==1
list Study

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Burke"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Howard"
replace author_app="other" if Primary_Author=="Mendelsohn"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Hope"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
replace author_app="other" if Primary_Author=="Weitzman"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="panel" if Primary_model=="Dell"
replace model_app="panel" if Primary_model=="Burke"
replace model_app="CGE" if Primary_model=="ENVISAGE"
replace model_app="other" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Howard Survey"
replace model_app="CGE" if Primary_model=="ICES"
replace model_app="other_enum" if Primary_model=="Mendelsohn"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
*replace model_app="other_enum" if Primary_model=="DICE"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="MERGE"
replace model_app="Maddison" if Primary_Author=="Maddison"

egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
replace model2_app="enumerativeother" if model2_app=="enumerativeNordhaus"
replace model2_app="statisticalother" if model2_app=="statisticalNordhaus"
replace model2_app="science" if model2_app=="ScienceNordhaus"
replace model2_app="science" if model2_app=="Scienceother"
***Add CGE control"
*replace model2_app="CGE" if CGE=="GTAP"

egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method2 + replace****************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus" 
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"
replace model4_app="science" if model4_app=="ScienceNordhaus"
replace model4_app="science" if model4_app=="Scienceother"

egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_All_Prefer_H051517, replace


********************************************************************************************************************************************************
*********************************************************Error Independence - Low and Drop Delete and Keep Latest and Preferred - Alt*******************
********************************************************************************************************************************************************

clear
use New_Metadata_delete_H051517
keep if delete==0
replace Based_On_Other =0 if Primary_Author=="Hanemann"
replace Based_On_Other =0 if Primary_Author=="Meyer"
keep if prefer==1
keep if Based_On_Other==0
keep if Group_latest==1

***********************************************By Group***********************************************************************************************
sort Groups
by Groups: gen study_group=_n
xtset Groups study_group

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Primary Author*************************************************************************************
gen author_app=Primary_Author
replace author_app="other" if Primary_Author=="ABARE"
replace author_app="other" if Primary_Author=="Berz"
replace author_app="other" if Primary_Author=="Bluedorn"
replace author_app="other" if Primary_Author=="Bosetti"
replace author_app="other" if Primary_Author=="Dell"
replace author_app="other" if Primary_Author=="Dellink"
replace author_app="other" if Primary_Author=="Fankhauser"
replace author_app="other" if Primary_Author=="Hanemann"
replace author_app="other" if Primary_Author=="Howard"
replace author_app="other" if Primary_Author=="Horowitz"
replace author_app="other" if Primary_Author=="Mendelsohn"
replace author_app="other" if Primary_Author=="Meyer"
replace author_app="other" if Primary_Author=="Ng"
replace author_app="other" if Primary_Author=="Roson"
replace author_app="other" if Primary_Author=="Schauer"
replace author_app="other" if Primary_Author=="Bosello or Eboli"
replace author_app="other" if Primary_Author=="Hope"
replace author_app="other" if Primary_Author=="Manne"
replace author_app="other" if Primary_Author=="Tol"
egen primary_author = group(author_app)
sort primary_author
by primary_author: gen study_author=_n
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method***********************************************************************************************
gen method_app=Method
replace method_app="statistical" if Method=="experimental"
replace method_app="enumerative" if method_app=="Science"
egen method = group(method_app)
sort method
by method: gen study_method=_n
xtset method study_method

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
gen method2_app=Method2
replace method2_app="statistical" if Method2=="experimental"
replace method2_app="enumerative" if method2_app=="Science"
egen method2 = group(method2_app)
sort method2
by method2: gen study_method2=_n
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="other_enum" if Primary_model=="CRED"
replace model_app="other_stat" if Primary_model=="Dell"
replace model_app="CGE" if Primary_model=="ENVISAGE"
replace model_app="CGE" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Howard Survey" 
replace model_app="CGE" if Primary_model=="ICES"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
*replace model_app="other_enum" if Primary_model=="DICE"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="Mendelsohn"
replace model_app="other_enum" if Primary_model=="MERGE"
*replace model_app="other_enum" if Primary_model=="Fankhauser"
replace model_app="Maddison" if Primary_Author=="Maddison"

egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model2=author+method**************************************************************************************
gen model2_app=method_app+author_app
replace model2_app="survey" if model2_app=="SurveyNordhaus"
replace model2_app="survey" if model2_app=="Surveyother"
*replace model2_app="enumerativeother" if model2_app=="enumerativeNordhaus"
replace model2_app="statisticalother" if model2_app=="statisticalNordhaus"
*replace model2_app="other_enum" if model2_app=="ScienceNordhaus"


egen model2 = group(model2_app)
sort model2
by model2: gen study_model2=_n
xtset model2 study_model2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model4=author+method**************************************************************************************
gen model4_app=method2_app+author_app
replace model4_app="survey" if model4_app=="SurveyNordhaus"
replace model4_app="survey" if model4_app=="Surveyother"
*replace model4_app="enumerativeother" if model4_app=="enumerativeNordhaus"
replace model4_app="statisticalother" if model4_app=="statisticalNordhaus"

egen model4 = group(model4_app)
sort model4
by model4: gen study_model4=_n
xtset model4 study_model4

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

save New_Metadata_Low_Prefer_alt_H051517, replace





********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
*****************************************************RUNS***********************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************




clear
cd "C:\Users\phhoward\Documents\Research\Second Paper\Calculation\Post_AAEA\New\Revision 2\ForUpload\Consolidate"

********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
**************************************************************Paper*************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

clear
use New_Metadata_051517
set more off

**********************************************************************************************************
***********************************GENERATE Figure A1*****************************************************
**********************************************************************************************************
**********Figure - All Data - All, Not Deleted, and Not Repeated***********
replace Based_On_Other =0 if Primary_Author=="Hanemann"
replace Based_On_Other =0 if Primary_Author=="Meyer"
*twoway (scatter D_new t if delete==1, mcolor(navy8) msymbol(smx) mfcolor(gs0) mlcolor(gs0) mlwidth(medthick)) (scatter D_new t if delete==0, mcolor(gs10) msymbol(circle)) (scatter D_new t if Group_latest_high==1 & Based_On_Other==0 & delete==0, mcolor(gs5) msymbol(circle)) (scatter D_new t if Group_latest==1 & Based_On_Other==0 & delete==0, mcolor(black) msymbol(circle)), ytitle(Climate Damage (% of GDP)) ytitle(, margin(medium)) xtitle(Temperature Change (degrees Celsius)) xmtick(##5, ticks tlcolor(black) tposition(crossing)) legend(off) 
twoway (scatter D_new t if delete==1 & t<4.01, mcolor(navy8) msymbol(smx) mfcolor(gs0) mlcolor(gs0)) (scatter D_new t if delete==0  & t<4.01, mcolor(gs10) msymbol(circle)) (scatter D_new t if Group_latest_high==1 & Based_On_Other==0 & delete==0  & t<4.01, mcolor(gs5) msymbol(circle)) (scatter D_new t if Group_latest==1 & Based_On_Other==0 & delete==0 & t<4.01, mcolor(black) msymbol(circle)), ytitle(Climate Damage (% of GDP)) ytitle(, margin(medium)) xtitle(Temperature Change (degrees Celsius)) xmtick(##5, ticks tlcolor(black) tposition(crossing)) legend(off)
twoway (scatter D_new t if delete==1, mcolor(navy8) msymbol(smx) mfcolor(gs0) mlcolor(gs0) mlwidth(medthick)) (scatter D_new t if delete==0, mcolor(gs10) msymbol(circle)) (scatter D_new t if Group_latest_high==1 & Based_On_Other==0 & delete==0, mcolor(black) msymbol(circle)) (scatter D_new t if Group_latest==1 & Based_On_Other==0 & delete==0, mcolor(black) msymbol(circle)), ytitle(Climate Damage (% of GDP)) ytitle(, margin(medium)) xtitle(Temperature Change (degrees Celsius)) xmtick(##5, ticks tlcolor(black) tposition(crossing)) legend(off)
graph export FigureA1.eps, replace
graph export FigureA1.pdf, replace

**********Summary by Method - for Estimate Review ***************
*Enumerative
sum D_new t if Method2_4==1
list D_new t if Method2_4==1

*Survey
sum D_new t if Method2_3==1
list Study D_new t if Method2_3==1

*Statistical
preserve
list obs Study D_new t if Method2_6==1
drop if obs==23
drop if obs==47 
sum D_new t if Method2_6==1
list Study D_new t if Method2_6==1
restore

*Hicksian
sum D_new t if Method2_7==1
list Study D_new t if Method2_7==1

*CGE
sum D_new t if Method2_1==1
list  Study D_new t if Method2_1==1

*Panel
preserve
list obs Study D_new t if Method2_6==1
drop if obs==13
drop if obs==19 
drop if obs==21
drop if obs==26 
drop if obs==27
drop if obs==28 
drop if obs==32
sum D_new t if Method2_6==1
list Study D_new t if Method2_6==1
restore

*Science
sum D_new t if Method2_2==1
list D_new t if Method2_2==1

********************************************************************************************************************************************************
***************************************************************Box Plot*********************************************************************************
********************************************************************************************************************************************************
clear
*use New_Metadata_Low_Delete_Latest_051517 (new change)
use New_Metadata_Low_Delete_Latest_alt_051517
graph box D_new, over(Primary_Author, label(angle(vertical))) over(Method, label(angle(horizontal))) ytitle(Climate Damage (% of GDP))
graph box D_new, over(Primary_model, label(angle(vertical))) ytitle(Climate Damage (% of GDP))

clear
use New_Metadata_All_Delete_Latest_051517
graph box D_new, over(Primary_Author, label(angle(vertical))) over(Method, label(angle(horizontal))) ytitle(Climate Damage (% of GDP))
graph box D_new, over(Primary_model, label(angle(vertical))) ytitle(Climate Damage (% of GDP))

********************************************************************************************************************************************************
********************************************************************************************************************************************************
**************************************************************Table 1 - Summary ************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

********************************************************************************************************************************************************
********************************************************************************************************************************************************
***********************************************Table 1 - Summary and Time Variable**********************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

clear
*use New_Metadata_delete_051517
use New_Metadata_All_Delete_051517
*sum D_new damage T_new T2_new current Alt_Curr_NASA cross Time Time2 Year Market Nonmarket omit Eco_Market cat prod Grey Based_On_Other Group_latest
*summary
sum D_new T_new T2_new cat cross current Eco_Market Grey Market prod Time
*median estimate
sum D_new, detail
*temperature weighted mean
*gen inv_t=1/t
reg D_new [aweight = inv_t]
* Time
reg D_new Time
reg D_new Time Time2
test Time
test Time2, a
reg D_new Time t
reg D_new Time Time2 t
test Time
test Time2, a
*Scatter Plot
twoway (scatter D_new T_new) (qfit D_new T_new, estopts(noc)), ytitle(Climate Damages (% of GDP)) xtitle(Temperature Change (degree Celsius)) legend(off)
*Scatter Plot
twoway (scatter D_new T_new) (lfit D_new Time), ytitle(Climate Damages (% of GDP)) xtitle(Time (Publication Year Since 1994)) legend(off)
*Box Plots
*
graph box D_new, over(author_app, label(angle(vertical)))
preserve
drop if author_app=="Weitzman"
graph box D_new, over(author_app, label(angle(vertical)))
restore
*
graph box D_new, over(method2_app, label(angle(vertical)))
preserve
drop if Method2=="Science"
graph box D_new, over(method2_app, label(angle(vertical)))
restore
*
graph box D_new, over(model_app, label(angle(vertical)))
preserve
drop if Primary_model=="CRED"
graph box D_new, over(model_app, label(angle(vertical)))
restore

clear
use New_Metadata_All_Delete_Latest_051517
*Summary
sum D_new T_new T2_new cat cross current Eco_Market Grey Market prod Time
*median estimate
sum D_new, detail
*temperature weighted mean
*gen inv_t=1/t
reg D_new [aweight = inv_t]
* Time
reg D_new Time
reg D_new Time Time2
test Time
test Time2, a
reg D_new Time t
reg D_new Time Time2 t
test Time
test Time2, a
*Scatter Plot
twoway (scatter D_new T_new) (qfit D_new T_new, estopts(noc)), ytitle(Climate Damages (% of GDP)) xtitle(Temperature Change (degree Celsius)) legend(off)
*Scatter Plot
twoway (scatter D_new T_new) (lfit D_new Time), ytitle(Climate Damages (% of GDP)) xtitle(Time (Publication Year Since 1994)) legend(off)
*Box Plots
*
graph box D_new, over(author_app, label(angle(vertical)))
preserve
drop if author_app=="Weitzman"
graph box D_new, over(author_app, label(angle(vertical)))
restore
*
graph box D_new, over(method2_app, label(angle(vertical)))
preserve
drop if Method2=="Science"
graph box D_new, over(method2_app, label(angle(vertical)))
restore
*
graph box D_new, over(model_app, label(angle(vertical)))
preserve
drop if Primary_model=="CRED"
graph box D_new, over(model_app, label(angle(vertical)))
restore

***Final Box Plots***
clear
use New_Metadata_All_Delete_051517
graph box D_new, over(model_app, label(angle(vertical))) ytitle(Climate Damages (% of GDP))
replace method2_app="CGE" if method2_app=="CGE-Production"
graph box D_new, over(author_app, label(angle(vertical))) over(method2_app) nofill ytitle(Climate Damages (% of GDP))

clear
use New_Metadata_All_Delete_Latest_051517
graph box D_new, over(model_app, label(angle(vertical))) ytitle(Climate Damages (% of GDP))
replace method2_app="CGE" if method2_app=="CGE-Production"
graph box D_new, over(author_app, label(angle(vertical))) over(method2_app) nofill ytitle(Climate Damages (% of GDP))

********************************************************************************************************************************************************
********************************************************************************************************************************************************
**************************************************************Figure 2- Polynomial plots****************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

**********************************
**********Polynomial plots**********
*********************************
***Kernel Regression**
clear
use New_Metadata_All_Delete_051517

replace Based_On_Other =0 if Primary_Author=="Meyer"
replace Based_On_Other =0 if Primary_Author=="Hanemann"

*keep if Based_On_Other==0 & Group_latest_high==1
*twoway (lpolyci D_new t, clcolor(black) fcolor(none) blcolor(gs5) blpattern(dash)) (lpolyci D_new t if Based_On_Other==0 & Group_latest_high==1, clcolor(gs10) fcolor(none) blcolor(gs10) blpattern(dash)), ytitle(Climate Damages (% of GDP)) xtitle(Temperature Increase (Degrees Celsius)) legend(off)
twoway (lpoly D_new t, clcolor(black) fcolor(none) blcolor(gs5) blpattern(dash)) (lpoly D_new t if Based_On_Other==0 & Group_latest_high==1, clcolor(gs10) fcolor(none) blcolor(gs10) blpattern(dash)), ytitle(Climate Damages (% of GDP)) xtitle(Temperature Increase (Degrees Celsius)) legend(off)
graph export FigureA2i.eps, replace
graph export FigureA2i.pdf, replace

*twoway (lpolyci D_new t if t<4.01, clcolor(black) fcolor(none) blcolor(gs5) blpattern(dash)) (lpolyci D_new t if Based_On_Other==0 & Group_latest_high==1 & t<4.01, clcolor(gs10) fcolor(none) blcolor(gs10) blpattern(dash)), ytitle(Climate Damages (% of GDP)) xtitle(Temperature Increase (Degrees Celsius)) legend(off)
twoway (lpoly D_new t if t<4.01, clcolor(black) fcolor(none) blcolor(gs5) blpattern(dash)) (lpoly D_new t if Based_On_Other==0 & Group_latest_high==1 & t<4.01, clcolor(gs10) fcolor(none) blcolor(gs10) blpattern(dash)), ytitle(Climate Damages (% of GDP)) xtitle(Temperature Increase (Degrees Celsius)) legend(off)
graph export FigureA2ii.eps, replace
graph export FigureA2ii.pdf, replace


********************************************************************************************************************************************************
********************************************************************************************************************************************************
**************************************************************Table B1 - Error Independence *************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

********************************************************************************************************************************************************
********************************************************************************************************************************************************
*********************************************************Error Independence - All***********************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

clear 
use New_Metadata_All_Delete_051517

***********************************************By Primary Author*************************************************************************************
sort primary_author
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
sort method2
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2


***********************************************By Model***********************************************************************************************
sort model
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2




********************************************************************************************************************************************************
*********************************************************Error Independence - Low and Drop Delete - Alt ******************************************************
********************************************************************************************************************************************************


clear
use New_Metadata_Low_Delete_alt_051517

***********************************************By Primary Author*************************************************************************************
sort primary_author
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2


***********************************************By Method2***********************************************************************************************
sort method2
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
sort model
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2



********************************************************************************************************************************************************
********************************************************************************************************************************************************
****************************************************************Drop Based******************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

********************************************************************************************************************************************************
*********************************************************Error Independence - All***********************************************************************
********************************************************************************************************************************************************

clear
use New_Metadata_All_Delete_Latest_051517

***********************************************By Primary Author*************************************************************************************
sort primary_author
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Method2***********************************************************************************************
sort method2
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2


***********************************************By Model***********************************************************************************************
sort model
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

********************************************************************************************************************************************************
*********************************************************Error Independence - Low***********************************************************************
********************************************************************************************************************************************************

clear
use New_Metadata_Low_Delete_Latest_alt_051517


***********************************************By Primary Author*************************************************************************************
sort primary_author
xtset primary_author study_author

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2


***********************************************By Method2***********************************************************************************************
sort method2
xtset method2 study_method2

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2

***********************************************By Model***********************************************************************************************
sort model
xtset model study_model

xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)

xtreg D_new T2_new, fe
xttest2



********************************************************************************************************************************************************
********************************************************************************************************************************************************
**************************************************************Table B2 - Heteroskedasticity *************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

********************************************************************************************************************************************************
*******************************************Low Data Regressions****************************************************************************************
********************************************************************************************************************************************************

***Low Data Alt- Drop Delete
clear
use New_Metadata_Low_Delete_alt_051517
reg D_new t2 mkt_t2 cat_t2, noc 
estat imtest
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc 
estat imtest

***All Data - Drop Delete, Keep Latest, and Drop Cited
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2, noc 
estat imtest
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc 
estat imtest

********************************************************************************************************************************************************
*******************************************All Data Regressions****************************************************************************************
********************************************************************************************************************************************************

***All Data - Drop Delete
clear
use New_Metadata_All_Delete_051517
reg D_new t2 mkt_t2 cat_t2, noc 
estat imtest
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc 
estat imtest

***All Data - Drop Delete, Keep Latest, and Drop Cited
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t2 mkt_t2 cat_t2, noc 
estat imtest
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc 
estat imtest

********************************************************************************************************************************************************
*******************************************Low Data Regressions****************************************************************************************
********************************************************************************************************************************************************

***Low Data Alt- Drop Delete
clear
use New_Metadata_Low_Delete_alt_051517
reg D_new t2 mkt_t2 cat_t2
estat hettest
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross 
estat hettest

***All Data - Drop Delete, Keep Latest, and Drop Cited
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2
estat hettest
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross 
estat hettest

********************************************************************************************************************************************************
*******************************************All Data Regressions****************************************************************************************
********************************************************************************************************************************************************

***All Data - Drop Delete
clear
use New_Metadata_All_Delete_051517
reg D_new t2 mkt_t2 cat_t2
estat hettest
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross 
estat hettest

***All Data - Drop Delete, Keep Latest, and Drop Cited
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t2 mkt_t2 cat_t2
estat hettest
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross
estat hettest


***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
******************************************Table 2 - Regressions *******************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************

***These are not the proper tests. Really want to test test regression coefficient equality across "overlapping samples".
scalar drop _all
********************************************************************************************************************************************************
*******************************************Scalar*******************************************************************************************************
********************************************************************************************************************************************************

***Define Nordhaus and Sztorc (2013) scalar
scalar NS_13=0.21360

********************************************************************************************************************************************************
*******************************************Low Data - Regressions & Drop Delete*************************************************************************
********************************************************************************************************************************************************

***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_alt_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table2,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel replace
test t2=NS_13
scalar L_1_1=r(p)
*test t2+prod_t2=NS_13
scalar L_1_2=.
test t2+cat_t2=NS_13
scalar L_1_3=r(p)
*test t2+prod_t2+cat_t2=NS_13
scalar L_1_4=.

predict uhat_L_1, residual
predict yhat_L_1, xb
scatter uhat_L_1 yhat_L_1
scatter uhat_L_1 t
sort uhat_L_1
list Study D_new yhat_L_1 uhat_L_1

***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_alt_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table2,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel
test t2=NS_13
scalar L_2_1=r(p)
test t2+prod_t2=NS_13
scalar L_2_2=r(p)
test t2+cat_t2=NS_13
scalar L_2_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_2_4=r(p)

predict uhat_L_2, residual
predict yhat_L_2, xb
scatter uhat_L_2 yhat_L_2
scatter uhat_L_2 t
sort uhat_L_2
list Study D_new yhat_L_2 uhat_L_2


********************************************************************************************************************************************************
*******************************************Low Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************


***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table2,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel
test t2=NS_13
scalar L_3_1=r(p)
*test t2+prod_t2=NS_13
scalar L_3_2=.
test t2+cat_t2=NS_13
scalar L_3_3=r(p)
*test t2+prod_t2+cat_t2=NS_13
scalar L_3_4=.

predict uhat_L_3, residual
predict yhat_L_3, xb
scatter uhat_L_3 yhat_L_3
scatter uhat_L_3 t
sort uhat_L_3
list Study D_new yhat_L_3 uhat_L_3

***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table2,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel
test t2=NS_13
scalar L_4_1=r(p)
test t2+prod_t2=NS_13
scalar L_4_2=r(p)
test t2+cat_t2=NS_13
scalar L_4_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_4_4=r(p)

predict uhat_L_4, residual
predict yhat_L_4, xb
scatter uhat_L_4 yhat_L_4
scatter uhat_L_4 t
sort uhat_L_4
list Study D_new yhat_L_4 uhat_L_4


********************************************************************************************************************************************************
*******************************************All Data - Regressions & Drop Delete*************************************************************************
********************************************************************************************************************************************************

***Small set of exogenous variables***
clear
use New_Metadata_All_Delete_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table2,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel
test t2=NS_13
scalar A_1_1=r(p)
*test t2+prod_t2=NS_13
scalar A_1_2=.
test t2+cat_t2=NS_13
scalar A_1_3=r(p)
*test t2+prod_t2+cat_t2=NS_13
scalar A_1_4=.

predict uhat_A_1, residual
predict yhat_A_1, xb
scatter uhat_A_1 yhat_A_1
scatter uhat_A_1 t
sort uhat_A_1
list Study D_new yhat_A_1 uhat_A_1

***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table2,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel
test t2=NS_13
scalar A_2_1=r(p)
test t2+prod_t2=NS_13
scalar A_2_2=r(p)
test t2+cat_t2=NS_13
scalar A_2_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_2_4=r(p)

predict uhat_A_2, residual
predict yhat_A_2, xb
scatter uhat_A_2 yhat_A_2
scatter uhat_A_2 t
sort uhat_A_2
list Study D_new yhat_A_2 uhat_A_2


********************************************************************************************************************************************************
*******************************************All Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************


***Small set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table2,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel
test t2=NS_13
scalar A_3_1=r(p)
*test t2+prod_t2=NS_13
scalar A_3_2=.
test t2+cat_t2=NS_13
scalar A_3_3=r(p)
*test t2+prod_t2+cat_t2=NS_13
scalar A_3_4=.

predict uhat_A_3, residual
predict yhat_A_3, xb
scatter uhat_A_3 yhat_A_3
scatter uhat_A_3 t
sort uhat_A_3
list Study D_new yhat_A_3 uhat_A_3

***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table2,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel
test t2=NS_13
scalar A_4_1=r(p)
test t2+prod_t2=NS_13
scalar A_4_2=r(p)
test t2+cat_t2=NS_13
scalar A_4_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_4_4=r(p)

predict uhat_A_4, residual
predict yhat_A_4, xb
scatter uhat_A_4 yhat_A_4
scatter uhat_A_4 t
sort uhat_A_4
list Study D_new yhat_A_4 uhat_A_4


********************************************************************************************************************************************************
*******************************************Scalar List**************************************************************************************************
********************************************************************************************************************************************************

scalar list L_1_1 L_2_1 L_3_1 L_4_1 A_1_1 A_2_1 A_3_1 A_4_1 
scalar list L_1_2 L_2_2 L_3_2 L_4_2 A_1_2 A_2_2 A_3_2 A_4_2 
scalar list L_1_3 L_2_3 L_3_3 L_4_3 A_1_3 A_2_3 A_3_3 A_4_3
scalar list L_1_4 L_2_4 L_3_4 L_4_4 A_1_4 A_2_4 A_3_4 A_4_4

*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************Test 1 - Test whether results from low and all differ with SUR**********************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************

scalar drop _all

clear
use New_Metadata_All_Delete_Latest_051517
gen Group_noncite_low=1
replace Group_noncite_low=0 if t>3.2

*Short
reg D_new t2 mkt_t2 cat_t2[aweight = inv_t], noc
estimates store nc_all
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t] if Group_noncite_low==1, noc 
estimates store nc_low
suest nc_all nc_low, vce(cluster model)
test [nc_low_mean = nc_all_mean]
scalar S_1=r(p)
*
test [nc_all_mean]t2 - [nc_low_mean]t2=0
scalar S_1_1=r(p)
test [nc_all_mean]t2+ [nc_all_mean]cat_t2- [nc_low_mean]t2-[nc_low_mean]cat_t2=0
scalar S_1_2=r(p)
scalar S_1_3=.
scalar S_1_4=.
*
test [nc_all_mean]mkt_t2-[nc_low_mean]mkt_t2=0
test [nc_all_mean]cat_t2-[nc_low_mean]cat_t2=0

*Extended
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc 
estimates store nc_all
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t] if Group_noncite_low==1, noc
estimates store nc_low
suest nc_all nc_low, vce(cluster model)
test [nc_low_mean = nc_all_mean]
scalar S_2=r(p)
*
test [nc_all_mean]t2 - [nc_low_mean]t2=0
scalar S_2_1=r(p)
test [nc_all_mean]t2+ [nc_all_mean]cat_t2- [nc_low_mean]t2-[nc_low_mean]cat_t2=0
scalar S_2_2=r(p)
test [nc_all_mean]t2 +[nc_all_mean]prod_t2- [nc_low_mean]t2-[nc_low_mean]prod_t2=0
scalar S_2_3=r(p)
test [nc_all_mean]t2 +[nc_all_mean]prod_t2+[nc_all_mean]cat_t2- [nc_low_mean]t2-[nc_low_mean]prod_t2-[nc_low_mean]cat_t2=0
scalar S_2_4=r(p)
*
test [nc_all_mean]mkt_t2-[nc_low_mean]mkt_t2=0
test [nc_all_mean]cat_t2-[nc_low_mean]cat_t2=0
test [nc_all_mean]prod_t2-[nc_low_mean]prod_t2=0
test [nc_all_mean]cross-[nc_low_mean]cross=0
*
scalar list S_1 S_2
scalar list S_1_1 S_1_2 S_1_3 S_1_4
scalar list S_2_1 S_2_2 S_2_3 S_2_4

*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*******************Test 2 - Test whether results differ from Nordhauz and Sztorc (2013) with SUR*********
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************

clear
use New_Metadata_051517
sort Time Study
list obs Study Group_Nordhaus

scalar drop _all


***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
*****************************************************Define No Delete Data*********************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
clear
use New_Metadata_051517
sort Time Study
list obs Study Group_Nordhaus

***All***
gen model_app=Primary_model
replace model_app="other_stat" if Primary_model=="Bluedorn"
replace model_app="panel" if Primary_model=="Dell"
replace model_app="panel" if Primary_model=="Burke"
replace model_app="other_CGE" if Primary_model=="Env-Linkages"
replace model_app="other_enum" if Primary_model=="GIAM"
replace model_app="other_stat" if Primary_model=="Horowitz"
replace model_app="other_CGE" if Primary_model=="ICES"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other_enum" if Primary_model=="WITCH"
replace model_app="other_enum" if Primary_model=="FUND"
replace model_app="other_enum" if Primary_model=="MERGE"
replace model_app="other_enum" if Primary_model=="PAGE"
replace model_app="CS" if Primary_model=="Household production "
replace model_app="CS" if Primary_model=="Happiness"
*
egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model
*
xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)
*
xtreg D_new T2_new, fe
xttest2

save New_Metadata_051517_NoDelete_All, replace

***Low***
clear
use New_Metadata_051517
sort Time Study
list obs Study Group_Nordhaus
keep if Group_new==1


gen model_app=Primary_model
replace model_app="other" if Primary_model=="Bluedorn"
replace model_app="other" if Primary_model=="CRED"
replace model_app="other" if Primary_model=="Dell"
replace model_app="CGE_other" if Primary_model=="ENVISAGE"
replace model_app="CGE_other" if Primary_model=="Env-Linkages"
replace model_app="other" if Primary_model=="GIAM"
replace model_app="other" if Primary_model=="Horowitz"
replace model_app="survey" if Primary_model=="Nordhaus Survey"
replace model_app="survey" if Primary_model=="Schauer"
replace model_app="other" if Primary_model=="WITCH"
replace model_app="CS" if Primary_model=="Household production "
replace model_app="CS" if Primary_model=="Happiness"
*
egen model = group(model_app)
sort model
by model: gen study_model=_n
xtset model study_model
*
xtreg D_new, mle
display "Intra-class correlation for author groups: " e(rho)
corr D_new L1.D_new
display "Correlation for adjoining method:" r(rho)
*
xtreg D_new T2_new, fe
xttest2

save New_Metadata_051517_NoDelete_Low, replace

**********************************************************
***********************************************************
************************Low********************************
***********************************************************
***********************************************************
clear
use New_Metadata_051517_NoDelete_Low
gen Group_noncite=0
replace Group_noncite=1 if delete==0
replace Based_On_Other =0 if Primary_Author=="Hanemann"
replace Based_On_Other =0 if Primary_Author=="Meyer"
replace Group_noncite=0 if Based_On_Other==1
replace Group_noncite=0 if Group_latest==0
tab D_new if Group_noncite==1

***********************************************************
************************Original***************************
***********************************************************

***********************************************************
************************Simple*****************************
***********************************************************

reg D_new t2 [aweight = inv_t] if Group_Nordhaus==1, noc
estimates store final
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t] if Group_noncite==1, noc
estimates store noncite
suest final noncite, vce(cluster model)
*
test [final_mean]t2 - [noncite_mean]t2=0
scalar L_1_1=r(p)
*
test [final_mean]t2 - [noncite_mean]t2- [noncite_mean]cat_t2=0
scalar L_1_2=r(p)
*
scalar L_1_3=.
*
scalar L_1_4=.


***********************************************************
************************Complex****************************
***********************************************************

reg D_new t2 [aweight = inv_t]  if Group_Nordhaus==1, noc
estimates store final
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t] if Group_noncite==1, noc
estimates store noncite
suest final noncite, vce(cluster model)
*
test [final_mean]t2 - [noncite_mean]t2=0
scalar L_2_1=r(p)
*
test [final_mean]t2 - [noncite_mean]t2- [noncite_mean]cat_t2=0
scalar L_2_2=r(p)
*
test [final_mean]t2- [noncite_mean]t2-[noncite_mean]prod_t2=0
scalar L_2_3=r(p)
*
test [final_mean]t2 - [noncite_mean]t2-[noncite_mean]prod_t2-[noncite_mean]cat_t2=0
scalar L_2_4=r(p)




***********************************************************
***********************************************************
************************All********************************
***********************************************************
***********************************************************

clear
use New_Metadata_051517_NoDelete_All
*gen inv_t=1/t
gen Group_noncite=0
replace Group_noncite=1 if delete==0
replace Based_On_Other =0 if Primary_Author=="Hanemann"
replace Based_On_Other =0 if Primary_Author=="Meyer"
replace Group_noncite=0 if Based_On_Other==1
replace Group_noncite=0 if Group_latest_high==0
tab D_new if Group_noncite==1

***********************************************************
************************Original***************************
***********************************************************

***********************************************************
************************Simple*****************************
***********************************************************

reg D_new t2 [aweight = inv_t] if Group_Nordhaus==1, noc
estimates store final
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t] if Group_noncite==1, noc
estimates store noncite
suest final noncite, vce(cluster model)
*
test [final_mean]t2 - [noncite_mean]t2=0
scalar A_1_1=r(p)
*
test [final_mean]t2 - [noncite_mean]t2- [noncite_mean]cat_t2=0
scalar A_1_2=r(p)
*
scalar A_1_3=.
*
scalar A_1_4=.


***********************************************************
************************Complex****************************
***********************************************************

reg D_new t2 [aweight = inv_t]  if Group_Nordhaus==1, noc
estimates store final
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t] if Group_noncite==1, noc
estimates store noncite
suest final noncite, vce(cluster model)
*
test [final_mean]t2 - [noncite_mean]t2=0
scalar A_2_1=r(p)
*
test [final_mean]t2 - [noncite_mean]t2- [noncite_mean]cat_t2=0
scalar A_2_2=r(p)
*
test [final_mean]t2- [noncite_mean]t2-[noncite_mean]prod_t2=0
scalar A_2_3=r(p)
*
test [final_mean]t2 - [noncite_mean]t2-[noncite_mean]prod_t2-[noncite_mean]cat_t2=0
scalar A_2_4=r(p)


*
scalar list L_1_1 L_1_2 L_1_3 L_1_4
scalar list L_2_1 L_2_2 L_2_3 L_2_4
scalar list A_1_1 A_1_2 A_1_3 A_1_4
scalar list A_2_1 A_2_2 A_2_3 A_2_4

*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
************************Test 3 - Test for Duplication (i.e., Multiple Publication) Bias******************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************

scalar drop _all

***********************************************************
***********************************************************
************************Low********************************
***********************************************************
***********************************************************
clear
use New_Metadata_Low_Delete_alt_051517
*gen inv_t=1/t
gen Group_noncite=0
replace Group_noncite=1 if delete==0
replace Based_On_Other =0 if Primary_Author=="Hanemann"
replace Based_On_Other =0 if Primary_Author=="Meyer"
replace Group_noncite=0 if Based_On_Other==1
replace Group_noncite=0 if Group_latest==0

gen model_app2=Primary_model
replace model_app2="other_stat" if Primary_model=="Bluedorn"
replace model_app2="other_enum" if Primary_model=="CRED"
replace model_app2="other_stat" if Primary_model=="Dell"
replace model_app2="CGE" if Primary_model=="ENVISAGE"
replace model_app2="CGE" if Primary_model=="ICES"
replace model_app2="CGE" if Primary_model=="Env-Linkages"
replace model_app2="other_enum" if Primary_model=="GIAM"
replace model_app2="other_stat" if Primary_model=="Horowitz"
replace model_app2="survey" if Primary_model=="Nordhaus Survey"
replace model_app2="survey" if Primary_model=="Schauer"
replace model_app2="other_enum" if Primary_model=="WITCH"
*replace model_app2="other_enum" if Primary_model=="DICE"
replace model_app2="other_enum" if Primary_model=="FUND"
replace model_app2="other_enum" if Primary_model=="MERGE"
*replace model_app2="other_enum" if Primary_model=="Fankhauser"
replace model_app2="other_enum" if Primary_model=="PAGE"

***********************************************************
************************Simple*****************************
***********************************************************

reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], noc
estimates store final
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t] if Group_noncite==1, noc
estimates store noncite
suest final noncite, vce(cluster model)
test [final_mean = noncite_mean]
scalar L_1=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
scalar L_1_1=r(p)
test [final_mean]mkt_t2 - [noncite_mean]mkt_t2=0
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0
scalar L_1_1b=r(p)
*test [final_mean]prod_t2 - [noncite_mean]prod_t2=0
scalar L_1_1c=.
*test [final_mean]cross - [noncite_mean]cross=0
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0,a
scalar L_1_2=r(p)
*
*test [final_mean]t2 - [noncite_mean]t2=0
*test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
*test [final_mean]t2+[final_mean]prod_t2 - [noncite_mean]t2-[noncite_mean]prod_t2=0
*scalar L_2_3=r(p)
scalar L_1_3=.
*
*test [final_mean]t2 - [noncite_mean]t2=0
*test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
*test [final_mean]cat_t2 - [noncite_mean]cat_t2=0,a
*test [final_mean]t2+[final_mean]prod_t2+[final_mean]cat_t2 - [noncite_mean]t2-[noncite_mean]prod_t2-[noncite_mean]cat_t2=0
scalar L_1_4=.


***********************************************************
************************Complex****************************
***********************************************************


reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc
estimates store final
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t] if Group_noncite==1, noc
estimates store noncite
suest final noncite, vce(cluster model)
test [final_mean = noncite_mean]
scalar L_2=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
scalar L_2_1=r(p)
test [final_mean]mkt_t2 - [noncite_mean]mkt_t2=0
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0
scalar L_2_1b=r(p)
test [final_mean]prod_t2 - [noncite_mean]prod_t2=0
scalar L_2_1c=r(p)
test [final_mean]cross - [noncite_mean]cross=0
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0,a
*test [final_mean]t2+[final_mean]cat_t2- [noncite_mean]t2- [noncite_mean]cat_t2=0
scalar L_2_2=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
*test [final_mean]t2+[final_mean]prod_t2 - [noncite_mean]t2-[noncite_mean]prod_t2=0
scalar L_2_3=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0,a
*test [final_mean]t2+[final_mean]prod_t2+[final_mean]cat_t2 - [noncite_mean]t2-[noncite_mean]prod_t2-[noncite_mean]cat_t2=0
scalar L_2_4=r(p)

***********************************************************
***********************************************************
************************All********************************
***********************************************************
***********************************************************

clear
use New_Metadata_All_Delete_051517
*gen inv_t=1/t
gen Group_noncite=0
replace Group_noncite=1 if delete==0
replace Based_On_Other =0 if Primary_Author=="Hanemann"
replace Based_On_Other =0 if Primary_Author=="Meyer"
replace Group_noncite=0 if Based_On_Other==1
replace Group_noncite=0 if Group_latest_high==0
tab D_new if Group_noncite==1

gen model_app2=Primary_model
replace model_app2="other_stat" if Primary_model=="Bluedorn"
replace model_app2="panel" if Primary_model=="Dell"
replace model_app2="panel" if Primary_model=="Burke"
replace model_app2="other" if Primary_model=="Env-Linkages"
replace model_app2="other_enum" if Primary_model=="GIAM"
replace model_app2="other_stat" if Primary_model=="Horowitz"
replace model_app2="CGE" if Primary_model=="ICES"
replace model_app2="survey" if Primary_model=="Nordhaus Survey"
replace model_app2="survey" if Primary_model=="Schauer"
replace model_app2="other_enum" if Primary_model=="WITCH"
replace model_app2="other_enum" if Primary_model=="FUND"
replace model_app2="other_enum" if Primary_model=="MERGE"
replace model_app2="CGE" if Primary_model=="ENVISAGE"

***********************************************************
************************Simple*****************************
***********************************************************


reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], noc
estimates store final
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t] if Group_noncite==1, noc
estimates store noncite
suest final noncite, vce(cluster model)
test [final_mean = noncite_mean]
scalar A_1=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
scalar A_1_1=r(p)
test [final_mean]mkt_t2 - [noncite_mean]mkt_t2=0
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0
scalar A_1_1b=r(p)
*test [final_mean]prod_t2 - [noncite_mean]prod_t2=0
scalar A_1_1c=.
*test [final_mean]cross - [noncite_mean]cross=0
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0,a
*test [final_mean]t2+[final_mean]cat_t2- [noncite_mean]t2- [noncite_mean]cat_t2=0
scalar A_1_2=r(p)
*
*test [final_mean]t2 - [noncite_mean]t2=0
*test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
*test [final_mean]t2+[final_mean]prod_t2 - [noncite_mean]t2-[noncite_mean]prod_t2=0
*scalar L_2_3=r(p)
scalar A_1_3=.
*
*test [final_mean]t2 - [noncite_mean]t2=0
*test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
*test [final_mean]cat_t2 - [noncite_mean]cat_t2=0,a
*test [final_mean]t2+[final_mean]prod_t2+[final_mean]cat_t2 - [noncite_mean]t2-[noncite_mean]prod_t2-[noncite_mean]cat_t2=0
scalar A_1_4=.

***********************************************************
************************Complex****************************
***********************************************************


reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc
estimates store final
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t] if Group_noncite==1, noc
estimates store noncite
suest final noncite, vce(cluster model)
test [final_mean = noncite_mean]
scalar A_2=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
scalar A_2_1=r(p)
test [final_mean]mkt_t2 - [noncite_mean]mkt_t2=0
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0
scalar A_2_1b=r(p)
test [final_mean]prod_t2 - [noncite_mean]prod_t2=0
scalar A_2_1c=r(p)
test [final_mean]cross - [noncite_mean]cross=0
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0,a
*test [final_mean]t2+[final_mean]cat_t2- [noncite_mean]t2- [noncite_mean]cat_t2=0
scalar A_2_2=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
*test [final_mean]t2+[final_mean]prod_t2 - [noncite_mean]t2-[noncite_mean]prod_t2=0
scalar A_2_3=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0,a
*test [final_mean]t2+[final_mean]prod_t2+[final_mean]cat_t2 - [noncite_mean]t2-[noncite_mean]prod_t2-[noncite_mean]cat_t2=0
scalar A_2_4=r(p)


*
scalar list L_1 L_2
scalar list L_1_1 L_1_2 L_1_3 L_1_4 L_2_1 L_2_2 L_2_3 L_2_4
scalar list L_1_1b L_1_1c L_2_1b L_2_1c

*
scalar list A_1 A_2
scalar list A_1_1 A_1_2 A_1_3 A_1_4 A_2_1 A_2_2 A_2_3 A_2_4
scalar list A_1_1b A_1_1c A_2_1b A_2_1c


*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
***********************Test 4 - Test for omitted variable bias*******************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************

*********************************************************************************************************
*********************************************************************************************************
************************************Omitted Signficance**************************************************
*********************************************************************************************************
*********************************************************************************************************
scalar drop _all

***************************************************************************************************************************
*******************************************Low Data - Drop Delete**********************************************************
***************************************************************************************************************************


***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_alt_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_Table_Omit,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test mkt_t2
test cat_t2,a
scalar L_3_1=r(p)


***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
test mkt_t2
test cat_t2,a
test cat_t2,a
test prod_t2,a
test cross,a
scalar L_3_2=r(p)



********************************************************************************************************************************************************
*******************************************All Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************


***Small set of exogenous variables***
clear
use New_Metadata_All_Delete_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], noc vce(cluster model_app)
test mkt_t2
test cat_t2,a
test cat_t2,a
scalar A_3_1=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
test mkt_t2
test cat_t2,a
test cat_t2,a
test prod_t2,a
test cross,a
scalar A_3_2=r(p)


scalar list L_3_1 L_3_2 A_3_1 A_3_2



********************************************************************************************************************************************************
*******************************************Low Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************


***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_Table_Omit,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test mkt_t2
test cat_t2,a
scalar L_3_3=r(p)


***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
test mkt_t2
test cat_t2,a
test cat_t2,a
test prod_t2,a
test cross,a
scalar L_3_4=r(p)



********************************************************************************************************************************************************
*******************************************All Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************


***Small set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], noc vce(cluster model_app)
test mkt_t2
test cat_t2,a
test cat_t2,a
scalar A_3_3=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
test mkt_t2
test cat_t2,a
test cat_t2,a
test prod_t2,a
test cross,a
scalar A_3_4=r(p)


scalar list L_3_1 L_3_2 L_3_3 L_3_4 A_3_1 A_3_2 A_3_3 A_3_4

*********************************************************************************************************
*********************************************************************************************************
************************************Omitted Adjusted R2**************************************************
*********************************************************************************************************
*********************************************************************************************************

********************************************************************************************************************************************************
*******************************************Low Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************
***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
reg D_new t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TestOmitted,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel replace


***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TestOmitted,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel


***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TestOmitted,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel


********************************************************************************************************************************************************
*******************************************All Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************

***No set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
reg D_new t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TestOmitted,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel

***Small set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TestOmitted,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel


***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TestOmitted,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel

*********************************************************************************************************
*********************************************************************************************************
************************************Omitted Variable Bias************************************************
*********************************************************************************************************
*********************************************************************************************************

scalar drop _all
********************************************************************************************************************************************************
*******************************************Low Data - Regressions & Drop Delete*************************************************************************
********************************************************************************************************************************************************
clear
use New_Metadata_Low_Delete_alt_051517
*gen inv_t=1/t
reg D_new t2  [aweight = inv_t], vce(cluster model_app)
estat ovtest
scalar L_1_1=r(p)


***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_alt_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], vce(cluster model_app)
estat ovtest
scalar L_1_2=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_alt_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], vce(cluster model_app)
estat ovtest
scalar L_1_3=r(p)


********************************************************************************************************************************************************
*******************************************Low Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************

clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], vce(cluster model_app)
estat ovtest
scalar L_2_1=r(p)

***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], vce(cluster model_app)
estat ovtest
scalar L_2_2=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], vce(cluster model_app)
estat ovtest
scalar L_2_3=r(p)


********************************************************************************************************************************************************
*******************************************All Data - Regressions & Drop Delete*************************************************************************
********************************************************************************************************************************************************

clear
use New_Metadata_All_Delete_051517
reg D_new t2 [aweight = inv_t], vce(cluster model_app)
estat ovtest
scalar A_1_1=r(p)

***Small set of exogenous variables***
clear
use New_Metadata_All_Delete_051517
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], vce(cluster model_app)
estat ovtest
scalar A_1_2=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], vce(cluster model_app)
estat ovtest
scalar A_1_3=r(p)

********************************************************************************************************************************************************
*******************************************All Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t2  [aweight = inv_t], vce(cluster model_app)
estat ovtest
scalar A_2_1=r(p)

***Small set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t2 mkt_t2 cat_t2 [aweight = inv_t], vce(cluster model_app)
estat ovtest
scalar A_2_2=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], vce(cluster model_app)
estat ovtest
scalar A_2_3=r(p)

scalar list




*********************************************************************************************************
*********************************************************************************************************
*****************************Estimation of Table 3 and Table B3 - New Runs*******************************
*********************************************************************************************************
*********************************************************************************************************

***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
******************************************Table 3 - Bias **************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************

**********************************************************************************************
***************************Define Nordhaus and Sztorc (2013) scalar***************************
**********************************************************************************************
scalar NS_13=0.21360

**********************************************************************************************
**************************************Original************************************************
**********************************************************************************************
clear
use New_Metadata_051517
drop if obs==12
reg D_orig T2 if Group_1==1, noc
matrix mpg=r(table)
outreg2 using Table3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace 
scalar B_0=1.25*_b[T2]
scalar S_0=1.25^2*_se[T2]
scalar LL_0=1.25*mpg[5,1]
scalar UL_0=1.25*mpg[6,1]
matrix drop _all

**********************************************************************************************
**************************************Fixed data**********************************************
**********************************************************************************************
clear
use New_Metadata_Low_Delete_alt_051517
drop if obs==12
reg D_new t2 if Group_1==1 [aweight = inv_t], noc vce(cluster model_app)
matrix mpg=r(table)
outreg2 using Table3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar L_1_1=r(p)
*
scalar B_1=1.25*_b[t2]
scalar S_1=1.25^2*_se[t2]
scalar LL_1=1.25*mpg[5,1]
scalar UL_1=1.25*mpg[6,1]
matrix drop _all

**********************************************************************************************
*************************************All data*************************************************
**********************************************************************************************
clear
use New_Metadata_Low_Delete_alt_051517
reg D_new t2 [aweight = inv_t], noc vce(cluster model_app)
matrix mpg=r(table)
outreg2 using Table3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar L_2_1=r(p)
*
scalar B_2=1.25*_b[t2]
scalar S_2=1.25^2*_se[t2]
scalar LL_2=1.25*mpg[5,1]
scalar UL_2=1.25*mpg[6,1]
matrix drop _all

**********************************************************************************************
*************************************Add Variables********************************************
**********************************************************************************************
clear
use New_Metadata_Low_Delete_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
matrix mpg=r(table)
outreg2 using Table3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar L_3_1=r(p)
test t2+cat_t2=NS_13
scalar L_3_2=r(p)
*
scalar B_3=1.25*_b[t2]
scalar B_3_cat=1.25*_b[t2] + _b[cat]
scalar S_3=1.25^2*_se[t2]
scalar LL_3=1.25*mpg[5,1]
scalar UL_3=1.25*mpg[6,1]
*
scalar B_3b=1.25*(_b[t2]+_b[prod])
scalar B_3b_cat=1.25*(_b[t2]+_b[prod]) + _b[cat]
scalar S_3b=1.25^2*(_se[t2]+_se[prod])
scalar LL_3b=1.25*(mpg[5,1]+mpg[5,4])
scalar UL_3b=1.25*(mpg[6,1]+mpg[6,4])
matrix drop _all


**********************************************************************************************
*************************************Preferred************************************************
**********************************************************************************************
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
matrix mpg=r(table)
outreg2 using Table3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar L_4_1=r(p)
test t2+cat_t2=NS_13
scalar L_4_2=r(p)
*
scalar B_4=1.25*_b[t2]
scalar B_4_cat=1.25*_b[t2] + _b[cat]
scalar S_4=1.25^2*_se[t2]
scalar LL_4=1.25*mpg[5,1]
scalar UL_4=1.25*mpg[6,1]
*
scalar B_4b=1.25*(_b[t2]+_b[prod])
scalar B_4b_cat=1.25*(_b[t2]+_b[prod]) + _b[cat]
scalar S_4b=1.25^2*(_se[t2]+_se[prod])
scalar LL_4b=1.25*(mpg[5,1]+mpg[5,4])
scalar UL_4b=1.25*(mpg[6,1]+mpg[6,4])

matrix list e(V)
matrix drop _all

scalar list L_1_1 L_2_1 L_3_1 L_4_1
scalar list L_3_2 L_4_2

**********************************************************************************************
************************************Alternative Order - Duplication Bias**********************
**********************************************************************************************
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 [aweight = inv_t], noc vce(cluster model_app)
matrix mpg=r(table)
outreg2 using Table3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar L_5_1=r(p)
*test t2+cat_t2=NS_13
*scalar L_5_2=r(p)
*
scalar B_5=1.25*_b[t2]
scalar S_5=1.25^2*_se[t2]
scalar LL_5=1.25*mpg[5,1]
scalar UL_5=1.25*mpg[6,1]
matrix drop _all
***List***

scalar list L_1_1 L_2_1 L_3_1 L_4_1 L_5_1
*scalar list L_3_2 L_4_2 L_5_2
scalar list L_3_2 L_4_2

*No Productivity
scalar list LL_0 LL_1 LL_2 LL_3 LL_4 LL_5
scalar list B_0 B_1 B_2 B_3 B_4 B_5
scalar list UL_0 UL_1 UL_2 UL_3 UL_4 UL_5
scalar list B_3_cat B_4_cat
*Productivity
scalar list LL_3b LL_4b
scalar list B_3b B_4b
scalar list UL_3b UL_4b
scalar list B_3b_cat B_4b_cat

***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
******************************************Table B3 - Bias **************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
scalar drop _all

**********************************************************************************************
***************************Define Nordhaus and Sztorc (2013) scalar***************************
**********************************************************************************************
scalar NS_13=0.21360

**********************************************************************************************
**************************************Original************************************************
**********************************************************************************************
clear
use New_Metadata_051517
drop if obs==12
reg D_orig T2 if Group_1==1, noc
matrix mpg=r(table)
outreg2 using TableB3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace 
*
scalar B_0c=1.25*_b[T2]
scalar S_0c=1.25^2*_se[T2]
scalar LL_0c=1.25*mpg[5,1]
scalar UL_0c=1.25*mpg[6,1]
matrix drop _all


**********************************************************************************************
**************************************Fixed data**********************************************
**********************************************************************************************
clear
use New_Metadata_All_Delete_051517
drop if obs==12
reg D_new t2 if Group_1==1 [aweight = inv_t], noc vce(cluster model_app)
matrix mpg=r(table)
outreg2 using TableB3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar A_1_1=r(p)
*
scalar B_1c=1.25*_b[t2]
scalar S_1c=1.25^2*_se[t2]
scalar LL_1c=1.25*mpg[5,1]
scalar UL_1c=1.25*mpg[6,1]
matrix drop _all

**********************************************************************************************
*************************************All data*************************************************
**********************************************************************************************
clear
use New_Metadata_All_Delete_051517
reg D_new t2 [aweight = inv_t], noc vce(cluster model_app)
matrix mpg=r(table)
outreg2 using TableB3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar A_2_1=r(p)
*
scalar B_2c=1.25*_b[t2]
scalar S_2c=1.25^2*_se[t2]
scalar LL_2c=1.25*mpg[5,1]
scalar UL_2c=1.25*mpg[6,1]
matrix drop _all

**********************************************************************************************
*************************************Add Variables********************************************
**********************************************************************************************
clear
use New_Metadata_All_Delete_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
matrix mpg=r(table)
outreg2 using TableB3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar A_3_1=r(p)
test t2+cat_t2=NS_13
scalar A_3_2=r(p)
*
scalar B_3c=1.25*_b[t2]
scalar B_3c_cat=1.25*_b[t2] + _b[cat]
scalar S_3c=1.25^2*_se[t2]
scalar LL_3c=1.25*mpg[5,1]
scalar UL_3c=1.25*mpg[6,1]
*
scalar B_3d=1.25*(_b[t2]+_b[prod])
scalar B_3d_cat=1.25*(_b[t2]+_b[prod]) + _b[cat]
scalar S_3d=1.25^2*(_se[t2]+_se[prod])
scalar LL_3d=1.25*(mpg[5,1]+mpg[5,4])
scalar UL_3d=1.25*(mpg[6,1]+mpg[6,4])
matrix drop _all

**********************************************************************************************
*************************************Preferred************************************************
**********************************************************************************************
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross  [aweight = inv_t], noc vce(cluster model_app)
matrix mpg=r(table)
outreg2 using TableB3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar A_4_1=r(p)
test t2+cat_t2=NS_13
scalar A_4_2=r(p)
*
scalar B_4c=1.25*_b[t2]
scalar B_4c_cat=1.25*_b[t2] + _b[cat]
scalar S_4c=1.25^2*_se[t2]
scalar LL_4c=1.25*mpg[5,1]
scalar UL_4c=1.25*mpg[6,1]
*
scalar B_4d=1.25*(_b[t2]+_b[prod])
scalar B_4d_cat=1.25*(_b[t2]+_b[prod]) + _b[cat]
scalar S_4d=1.25^2*(_se[t2]+_se[prod])
scalar LL_4d=1.25*(mpg[5,1]+mpg[5,4])
scalar UL_4d=1.25*(mpg[6,1]+mpg[6,4])
matrix drop _all

**********************************************************************************************
*************************************Alt Order - Drop Duplicates ****************************
**********************************************************************************************
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t2  [aweight = inv_t], noc vce(cluster model_app)
matrix mpg=r(table)
outreg2 using TableB3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar A_5_1=r(p)
*test t2+cat_t2=NS_13
*scalar A_5_2=r(p)
matrix mpg=r(table)
*
scalar B_5c=1.25*_b[t2]
scalar S_5c=1.25^2*_se[t2]
scalar LL_5c=1.25*mpg[5,1]
scalar UL_5c=1.25*mpg[6,1]

matrix list e(V)
matrix drop _all

scalar list A_1_1 A_2_1 A_3_1 A_4_1 A_5_1
*scalar list A_3_2 A_4_2 A_5_2
scalar list A_3_2 A_4_2

***List***
*No Productivity
scalar list LL_0c LL_1c LL_2c LL_3c LL_4c LL_5c
scalar list B_0c B_1c B_2c B_3c B_4c B_5c
scalar list UL_0c UL_1c UL_2c UL_3c UL_4c UL_5c
scalar list B_3c_cat B_4c_cat
*Productivity
scalar list LL_3d LL_4d
scalar list B_3d B_4d
scalar list UL_3d UL_4d
scalar list B_3d_cat B_4d_cat


********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
**************************************************************Appendix**********************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
clear
use New_Metadata_051517
set more off

********************************************************************************************************************************************************
********************************************************************************************************************************************************
**************************************************************Appendix Table A1*************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

list Study T D_orig D2 T_new D_new if Group_1==1
list Study T D_orig D2 T_new D_new if Group_2==1
list Study t D_new if Group_2==0


gen marker=1
replace marker=0 if delete==1
replace Based_On_Other =0 if Primary_Author=="Meyer"
replace Based_On_Other =0 if Primary_Author=="Hanemann"
replace marker=0 if Based_On_Other==1
replace marker=0 if Group_latest_high==0

list Study Based_On_Other Group_latest_high marker if Group_1==1
list Study Based_On_Other Group_latest_high marker if Group_2==1
list Study Based_On_Other Group_latest_high marker if Group_2==0

***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
******************************************Appendix Table C1- New Functional Form - Linear and Quadratic Regression ******************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
scalar drop _all

********************************************************************************************************************************************************
********************************************Scalar******************************************************************************************************
********************************************************************************************************************************************************
***Define Tol(2014)
scalar T_14_1=0.28
scalar T_14_2=0.16

********************************************************************************************************************************************************
*******************************************Low Data - Regressions & Drop Delete*************************************************************************
********************************************************************************************************************************************************
***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_alt_051517
reg D_new t2 mkt_t2 cat_t2 t mkt_t [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC1,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace 
test t=T_14_1
test t2=T_14_2, a
scalar L_1_1=r(p)
test t=T_14_1
test t2+cat_t2=T_14_2, a
scalar L_1_2=r(p)
scalar L_1_3=.
scalar L_1_4=.

***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 t mkt_t prod_t cross [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_TableC1,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using BCA15_TableC1,  addstat("Liklihood", e(ll),  "R2", e(r2)) adjr2 word excel
test t=T_14_1
test t2=T_14_2, a
scalar L_2_1=r(p)
test t=T_14_1
test t2+cat_t2=T_14_2, a
scalar L_2_2=r(p)
test t+prod_t=T_14_1
test t2+prod_t2=T_14_2, a
scalar L_2_3=r(p)
test t=T_14_1
test t2+prod_t2+cat_t2=T_14_2, a
scalar L_2_4=r(p)

test t, a 
test t2, a
test mkt_t, a
test mkt_t2, a
test cat_t2, a 
test prod_t, a 
test prod_t2, a
test cross



********************************************************************************************************************************************************
*******************************************Low Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2 t mkt_t [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC1,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test t=T_14_1
test t2=T_14_2, a
scalar L_3_1=r(p)
test t=T_14_1
test t2+cat_t2=T_14_2, a
scalar L_3_2=r(p)
scalar L_3_3=.
scalar L_3_4=.

*Test Linear
test t
test mkt_t, a

***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 t mkt_t prod_t  cross [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_TableC1,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using BCA15_TableC1,  addstat("Liklihood", e(ll),  "R2", e(r2)) adjr2 word excel
test t=T_14_1
test t2=T_14_2, a
scalar L_4_1=r(p)
test t=T_14_1
test t2+cat_t2=T_14_2, a
scalar L_4_2=r(p)
test t+prod_t=T_14_1
test t2+prod_t2=T_14_2, a
scalar L_4_3=r(p)
test t=T_14_1
test t2+prod_t2+cat_t2=T_14_2, a
scalar L_4_4=r(p)

*Test Linear
test t
test mkt_t, a
test prod_t, a

test t
test mkt_t, a
test t, a 
test t2, a
test mkt_t, a
test mkt_t2, a
test cat_t2, a 
test prod_t, a 
test prod_t2, a
test cross



********************************************************************************************************************************************************
*******************************************All Data - Regressions & Drop Delete*************************************************************************
********************************************************************************************************************************************************

***Small set of exogenous variables***
clear
use New_Metadata_All_Delete_051517
reg D_new t2 mkt_t2 cat_t2 t mkt_t [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC1,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t=T_14_1
test t2=T_14_2, a
scalar A_1_1=r(p)
test t=T_14_1
test t2+cat_t2=T_14_2, a
scalar A_1_2=r(p)
scalar A_1_3=.
scalar A_1_4=.



***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 t mkt_t prod_t cross  [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_TableC1,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using BCA15_TableC1,  addstat("Liklihood", e(ll),  "R2", e(r2)) adjr2 word excel
test t=T_14_1
test t2=T_14_2, a
scalar A_2_1=r(p)
test t=T_14_1
test t2+cat_t2=T_14_2, a
scalar A_2_2=r(p)
test t+prod_t=T_14_1
test t2+prod_t2=T_14_2, a
scalar A_2_3=r(p)
test t=T_14_1
test t2+prod_t2+cat_t2=T_14_2, a
scalar A_2_4=r(p)

test t, a 
test t2, a
test mkt_t, a
test mkt_t2, a
test cat_t2, a 
test prod_t, a 
test prod_t2, a
test cross



********************************************************************************************************************************************************
*******************************************All Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************

***All Data - Drop Delete, Keep Latest, and Drop Cited
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t2 mkt_t2 cat_t2 t mkt_t [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC1,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test t=T_14_1
test t2=T_14_2, a
scalar A_3_1=r(p)
test t=T_14_1
test t2+cat_t2=T_14_2, a
scalar A_3_2=r(p)
scalar A_3_3=.
scalar A_3_4=.

*Test Linear
test t
test mkt_t, a

***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 t mkt_t prod_t cross [aweight = inv_t], noc vce(cluster model_app)
*reg D_new mkt_t2 cat_t2 prod_t2 t mkt_t prod_t [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_TableC1,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using BCA15_TableC1,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel 
test t=T_14_1
test t2=T_14_2, a
scalar A_4_1=r(p)
test t=T_14_1
test t2+cat_t2=T_14_2, a
scalar A_4_2=r(p)
test t+prod_t=T_14_1
test t2+prod_t2=T_14_2, a
scalar A_4_3=r(p)
test t=T_14_1
test t2+prod_t2+cat_t2=T_14_2, a
scalar A_4_4=r(p)

*Test Linear
test t
test mkt_t, a
test prod_t, a

test t, a 
test t2, a
test mkt_t, a
test mkt_t2, a
test cat_t2, a 
test prod_t, a 
test prod_t2, a
test cross



scalar list L_1_1 L_2_1 L_3_1 L_4_1 A_1_1 A_2_1 A_3_1 A_4_1 
scalar list L_1_2 L_2_2 L_3_2 L_4_2 A_1_2 A_2_2 A_3_2 A_4_2 
scalar list L_1_3 L_2_3 L_3_3 L_4_3 A_1_3 A_2_3 A_3_3 A_4_3 
scalar list L_1_4 L_2_4 L_3_4 L_4_4 A_1_4 A_2_4 A_3_4 A_4_4 


*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*****************************Test for Multiple Publication Bias******************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************

scalar drop _all

***********************************************************
***********************************************************
************************Low********************************
***********************************************************
***********************************************************
clear
use New_Metadata_Low_Delete_alt_051517
*gen inv_t=1/t
gen Group_noncite=0
replace Group_noncite=1 if delete==0
replace Based_On_Other =0 if Primary_Author=="Hanemann"
replace Based_On_Other =0 if Primary_Author=="Meyer"
replace Group_noncite=0 if Based_On_Other==1
replace Group_noncite=0 if Group_latest==0

gen model_app2=Primary_model
replace model_app2="other_stat" if Primary_model=="Bluedorn"
replace model_app2="other_enum" if Primary_model=="CRED"
replace model_app2="other_stat" if Primary_model=="Dell"
replace model_app2="CGE" if Primary_model=="ENVISAGE"
replace model_app2="CGE" if Primary_model=="ICES"
replace model_app2="CGE" if Primary_model=="Env-Linkages"
replace model_app2="other_enum" if Primary_model=="GIAM"
replace model_app2="other_stat" if Primary_model=="Horowitz"
replace model_app2="survey" if Primary_model=="Nordhaus Survey"
replace model_app2="survey" if Primary_model=="Schauer"
replace model_app2="other_enum" if Primary_model=="WITCH"
*replace model_app2="other_enum" if Primary_model=="DICE"
replace model_app2="other_enum" if Primary_model=="FUND"
replace model_app2="other_enum" if Primary_model=="MERGE"
*replace model_app2="other_enum" if Primary_model=="Fankhauser"
replace model_app2="other_enum" if Primary_model=="PAGE"
*gen prod_t=prod*t

***********************************************************
************************Simple*****************************
***********************************************************

reg D_new t2 t mkt_t2 mkt_t cat_t2 [aweight = inv_t], noc
estimates store final
reg D_new t2 t mkt_t2 mkt_t cat_t2 [aweight = inv_t] if Group_noncite==1, noc
estimates store noncite
suest final noncite, vce(cluster model)
test [final_mean = noncite_mean]
scalar L_1=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]t - [noncite_mean]t=0, a
scalar L_1_1=r(p)
*
test [final_mean]mkt_t2 - [noncite_mean]mkt_t2=0
test [final_mean]mkt_t - [noncite_mean]mkt_t=0, a
*
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0
scalar L_1_1b=r(p)
*
scalar L_1_1c=.
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]t - [noncite_mean]t=0, a
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0, a
scalar L_1_2=r(p)
*
*test [final_mean]t2 - [noncite_mean]t2=0
*test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
*test [final_mean]t2+[final_mean]prod_t2 - [noncite_mean]t2-[noncite_mean]prod_t2=0
*scalar L_2_3=r(p)
scalar L_1_3=.
*
*test [final_mean]t2 - [noncite_mean]t2=0
*test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
*test [final_mean]cat_t2 - [noncite_mean]cat_t2=0,a
*test [final_mean]t2+[final_mean]prod_t2+[final_mean]cat_t2 - [noncite_mean]t2-[noncite_mean]prod_t2-[noncite_mean]cat_t2=0
scalar L_1_4=.


***********************************************************
************************Complex****************************
***********************************************************


reg D_new t2 t mkt_t2 mkt_t cat_t2 prod_t2 prod_t cross [aweight = inv_t], noc
estimates store final
reg D_new t2 t mkt_t2 mkt_t cat_t2 prod_t2 prod_t cross [aweight = inv_t] if Group_noncite==1, noc
estimates store noncite
suest final noncite, vce(cluster model)
test [final_mean = noncite_mean]
scalar L_2=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]t - [noncite_mean]t=0, a
scalar L_2_1=r(p)
*
test [final_mean]mkt_t2 - [noncite_mean]mkt_t2=0
test [final_mean]mkt_t2 - [noncite_mean]mkt_t2=0, a
*
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0
scalar L_2_1b=r(p)
*
test [final_mean]prod_t2 - [noncite_mean]prod_t2=0
test [final_mean]prod_t - [noncite_mean]prod_t=0, a
scalar L_2_1c=r(p)
*
test [final_mean]cross - [noncite_mean]cross=0
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]t - [noncite_mean]t=0, a
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0,a
scalar L_2_2=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]t - [noncite_mean]t=0, a
test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
test [final_mean]prod_t - [noncite_mean]prod_t=0, a
scalar L_2_3=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]t - [noncite_mean]t=0, a
test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
test [final_mean]prod_t - [noncite_mean]prod_t=0, a
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0,a
scalar L_2_4=r(p)



***********************************************************
***********************************************************
************************All********************************
***********************************************************
***********************************************************

clear
use New_Metadata_All_Delete_051517
*gen inv_t=1/t
gen Group_noncite=0
replace Group_noncite=1 if delete==0
replace Based_On_Other =0 if Primary_Author=="Hanemann"
replace Based_On_Other =0 if Primary_Author=="Meyer"
replace Group_noncite=0 if Based_On_Other==1
replace Group_noncite=0 if Group_latest_high==0
tab D_new if Group_noncite==1

gen model_app2=Primary_model
replace model_app2="other_stat" if Primary_model=="Bluedorn"
replace model_app2="panel" if Primary_model=="Dell"
replace model_app2="panel" if Primary_model=="Burke"
replace model_app2="other" if Primary_model=="Env-Linkages"
replace model_app2="other_enum" if Primary_model=="GIAM"
replace model_app2="other_stat" if Primary_model=="Horowitz"
replace model_app2="CGE" if Primary_model=="ICES"
replace model_app2="survey" if Primary_model=="Nordhaus Survey"
replace model_app2="survey" if Primary_model=="Schauer"
replace model_app2="other_enum" if Primary_model=="WITCH"
replace model_app2="other_enum" if Primary_model=="FUND"
replace model_app2="other_enum" if Primary_model=="MERGE"
replace model_app2="CGE" if Primary_model=="ENVISAGE"
*gen prod_t=prod*t
***********************************************************
************************Simple*****************************
***********************************************************

reg D_new t2 t mkt_t2 mkt_t cat_t2 [aweight = inv_t], noc
estimates store final
reg D_new t2 t mkt_t2 mkt_t cat_t2 [aweight = inv_t] if Group_noncite==1, noc
estimates store noncite
suest final noncite, vce(cluster model)
test [final_mean = noncite_mean]
scalar A_1=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]t - [noncite_mean]t=0, a
scalar A_1_1=r(p)
*
test [final_mean]mkt_t2 - [noncite_mean]mkt_t2=0
test [final_mean]mkt_t - [noncite_mean]mkt_t=0, a
*
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0
scalar A_1_1b=r(p)
*
scalar A_1_1c=.
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]t - [noncite_mean]t=0, a
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0, a
scalar A_1_2=r(p)
*
*test [final_mean]t2 - [noncite_mean]t2=0
*test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
*test [final_mean]t2+[final_mean]prod_t2 - [noncite_mean]t2-[noncite_mean]prod_t2=0
*scalar A_2_3=r(p)
scalar A_1_3=.
*
*test [final_mean]t2 - [noncite_mean]t2=0
*test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
*test [final_mean]cat_t2 - [noncite_mean]cat_t2=0,a
*test [final_mean]t2+[final_mean]prod_t2+[final_mean]cat_t2 - [noncite_mean]t2-[noncite_mean]prod_t2-[noncite_mean]cat_t2=0
scalar A_1_4=.


***********************************************************
************************Complex****************************
***********************************************************


reg D_new t2 t mkt_t2 mkt_t cat_t2 prod_t2 prod_t cross [aweight = inv_t], noc
estimates store final
reg D_new t2 t mkt_t2 mkt_t cat_t2 prod_t2 prod_t cross [aweight = inv_t] if Group_noncite==1, noc
estimates store noncite
suest final noncite, vce(cluster model)
test [final_mean = noncite_mean]
scalar A_2=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]t - [noncite_mean]t=0, a
scalar A_2_1=r(p)
*
test [final_mean]mkt_t2 - [noncite_mean]mkt_t2=0
test [final_mean]mkt_t2 - [noncite_mean]mkt_t2=0, a
*
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0
scalar A_2_1b=r(p)
*
test [final_mean]prod_t2 - [noncite_mean]prod_t2=0
test [final_mean]prod_t - [noncite_mean]prod_t=0, a
scalar A_2_1c=r(p)
*
test [final_mean]cross - [noncite_mean]cross=0
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]t - [noncite_mean]t=0, a
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0,a
scalar A_2_2=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]t - [noncite_mean]t=0, a
test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
test [final_mean]prod_t - [noncite_mean]prod_t=0, a
scalar A_2_3=r(p)
*
test [final_mean]t2 - [noncite_mean]t2=0
test [final_mean]t - [noncite_mean]t=0, a
test [final_mean]prod_t2 - [noncite_mean]prod_t2=0, a
test [final_mean]prod_t - [noncite_mean]prod_t=0, a
test [final_mean]cat_t2 - [noncite_mean]cat_t2=0,a
scalar A_2_4=r(p)


*
scalar list L_1 L_2
scalar list L_1_1 L_1_2 L_1_3 L_1_4 L_2_1 L_2_2 L_2_3 L_2_4
scalar list L_1_1b L_1_1c L_2_1b L_2_1c
*
scalar list A_1 A_2
scalar list A_1_1 A_1_2 A_1_3 A_1_4 A_2_1 A_2_2 A_2_3 A_2_4
scalar list A_1_1b A_1_1c A_2_1b A_2_1c



***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
******************************************Table C2****************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
scalar drop _all

**********************************************************************************************
***************************Define Tol(2009) scalar********************************************
**********************************************************************************************
***Define Tol(2014)
scalar T_14_1=0.28
scalar T_14_2=0.16

**********************************************************************************************
**************************************Original************************************************
**********************************************************************************************
clear
use New_Metadata_051517
replace D_orig=0.9 if obs==20
replace T=5.4 if obs==36
replace T=2.9 if obs==37
replace T2=T^2 if obs==36
replace T2=T^2 if obs==37
drop if t>4
reg D_orig T T2 if Group_2==1, noc
outreg2 using BCA15_TableC2,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace 
test T=T_14_1
test T2=T_14_2, a
scalar L_1_1=r(p)

**********************************************************************************************
**************************************Fixed data**********************************************
**********************************************************************************************
clear
use New_Metadata_Low_Delete_alt_051517
reg D_new t t2 if Group_2==1 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC2,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test t=T_14_1
test t2=T_14_2, a
scalar L_2_1=r(p)


**********************************************************************************************
*************************************All data*************************************************
**********************************************************************************************
clear
use New_Metadata_Low_Delete_alt_051517
reg D_new t t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC2,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t=T_14_1
test t2=T_14_2, a
scalar L_3_1=r(p)

**********************************************************************************************
*************************************Add Variables********************************************
**********************************************************************************************
clear
use New_Metadata_Low_Delete_alt_051517
reg  D_new t t2 mkt_t mkt_t2 cat_t2 prod_t prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_TableC2_wgt,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
outreg2 using BCA15_TableC2,  addstat("Liklihood", e(ll), "F-statistic", e(F),"R2", e(r2)) adjr2 word excel  
test t=T_14_1
test t2=T_14_2, a
scalar L_4_1=r(p)
test t=T_14_1
test t2+cat_t2=T_14_2, a
scalar L_4_2=r(p)

**********************************************************************************************
*************************************Preferred************************************************
**********************************************************************************************
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg  D_new t t2 mkt_t mkt_t2 cat_t2 prod_t prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_TableC2_wgt,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
outreg2 using BCA15_TableC2,  addstat("Liklihood", e(ll), "F-statistic", e(F),"R2", e(r2)) adjr2 word excel 
test t=T_14_1
test t2=T_14_2, a
scalar L_5_1=r(p)
test t=T_14_1
test t2+cat_t2=T_14_2, a
scalar L_5_2=r(p)

**********************************************************************************************
*******************************Alt - Duplication bias ****************************************
**********************************************************************************************
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg  D_new t t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC2,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t=T_14_1
test t2=T_14_2, a
scalar L_6_1=r(p)

scalar list L_1_1 L_2_1 L_3_1 L_4_1 L_5_1 L_6_1
scalar list L_4_2 L_5_2



***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
******************************************Table C3****************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
scalar drop _all

**********************************************************************************************
***************************Define Tol(2009) scalar********************************************
**********************************************************************************************
***Define Tol(2014)
scalar T_14_1=0.28
scalar T_14_2=0.16

**********************************************************************************************
**************************************Original************************************************
**********************************************************************************************
clear
use New_Metadata_051517
replace D_orig=0.9 if obs==20
replace T=5.4 if obs==36
replace T=2.9 if obs==37
replace T2=T^2 if obs==36
replace T2=T^2 if obs==37
reg D_orig T T2 if Group_2==1, noc
outreg2 using BCA15_TableC3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace 
test T=T_14_1
test T2=T_14_2, a
scalar A_1_1=r(p)

**********************************************************************************************
**************************************Fixed data**********************************************
**********************************************************************************************
clear
use New_Metadata_All_Delete_051517
reg D_new t t2 if Group_2==1 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test t=T_14_1
test t2=T_14_2, a
scalar A_2_1=r(p)

**********************************************************************************************
*************************************All data*************************************************
**********************************************************************************************
clear
use New_Metadata_All_Delete_051517
reg D_new t t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t=T_14_1
test t2=T_14_2, a
scalar A_3_1=r(p)

**********************************************************************************************
*************************************Add Variables********************************************
**********************************************************************************************
clear
use New_Metadata_All_Delete_051517
reg D_new t t2 mkt_t mkt_t2 cat_t2 prod_t prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_TableC3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
outreg2 using BCA15_TableC3,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel 
test t=T_14_1
test t2=T_14_2, a
scalar A_4_1=r(p)
test t=T_14_1
test t2+cat_t2=T_14_2, a
scalar A_4_2=r(p)

**********************************************************************************************
*************************************Preferred************************************************
**********************************************************************************************
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t t2 mkt_t mkt_t2 cat_t2 prod_t prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_TableC3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using BCA15_TableC3,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel 
test t=T_14_1
test t2=T_14_2, a
scalar A_5_1=r(p)
test t=T_14_1
test t2+cat_t2=T_14_2, a
scalar A_5_2=r(p)

**********************************************************************************************
******************************Alt - Duplication bias **************************************
**********************************************************************************************
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC3,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t=T_14_1
test t2=T_14_2, a
scalar A_6_1=r(p)

scalar list A_1_1 A_2_1 A_3_1 A_4_1 A_5_1 A_6_1
scalar list A_4_2 A_5_2


matrix list e(V)

********************************************************************************************************************************************************
********************************************************************************************************************************************************
**************************************************************Appendix Table C4 - Functional Forms*******************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************


**********************************************************************************************************************************************
*********************************************Determine Optimal split for linear splines on low and all data***********************************
*********************************************Linear Spline - Works Well - Marginal************************************************************
**********************************************************************************************************************************************

*********
***Low***
*********
clear
use New_Metadata_Low_Delete_Latest_alt_051517

*generate variables
mkspline t_1 0.001 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel  replace
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2))  dec(7) pdec(7) adjr2 word excel replace
drop t_*


mkspline t_1 0.1 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 0.2 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 0.3 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 0.4 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 0.5 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 0.6 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 0.7 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*


mkspline t_1 0.8 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 0.9 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.0 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.1 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.2 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.3 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.4 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.5 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.6 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.7 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.8 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.9 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.0 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.1 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.2 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.3 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.4 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.5 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.6 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.7 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.8 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.9 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*



*********
***All***
*********

clear
use New_Metadata_All_Delete_Latest_051517

*generate variables
mkspline t_1 0.001 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adec(7) adjr2 word excel replace
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) tdec(7) adjr2 word excel replace
drop t_*

mkspline t_1 0.1 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*


mkspline t_1 0.2 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 0.3 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 0.4 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 0.5 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 0.6 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 0.7 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 0.8 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 0.9 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.0 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.1 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.2 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.3 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.4 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.5 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.6 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.7 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.8 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 1.9 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.0 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.1 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.2 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.3 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.4 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.5 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.6 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.7 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.8 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 2.9 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 3.0 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 3.1 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 3.2 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 3.3 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 3.4 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 3.5 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 3.6 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 3.7 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 3.8 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 3.9 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

mkspline t_1 4.0 t_2 = t, marginal
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_1c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Rev2_2c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "R2", e(r2)) dec(7) pdec(7) adjr2 word excel
drop t_*

************************************************************************************************************************
************************************************************************************************************************
***************************************Runs alternative functional forms************************************************
************************************************************************************************************************
************************************************************************************************************************

*********
***Low***
*********
clear
use New_Metadata_Low_Delete_Latest_alt_051517

gen cat_t=cat*t

gen T3_new= T_new^3
gen T4_new= T_new^4
gen T5_new= T_new^5
gen T6_new= T_new^6
gen theta= Alt_Curr_NASA
gen theta2= Alt_Curr_NASA^2
gen theta3= Alt_Curr_NASA^3
gen theta4= Alt_Curr_NASA^4
gen theta5= Alt_Curr_NASA^5
gen theta6= Alt_Curr_NASA^6

*gen t4= T4_new+4* Alt_Curr_NASA* T3_new+6* Alt_Curr_NASA^2* T2_new+4* Alt_Curr_NASA^3* T_new
gen t4= T4_new+4* theta* T3_new+6* theta2* T2_new+4* theta3* T_new
gen t6= T6_new+6*theta*T5_new+15*theta2*T4_new+20*theta3*T3_new+15*theta4*T2_new+6*theta5*T_new

*gen t4 =T_new^4
gen mkt_t4=t4*Market
gen cat_t4=cat*t4
gen prod_t4=prod*t4

*gen t6 =T_new^6
gen mkt_t6=t6*Market
gen cat_t6=cat*t6
gen prod_t6=prod*t6

reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace

reg D_new t mkt_t cat_t prod_t cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 

*reg D_new t t2 [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel

reg D_new t2 mkt_t2 cat_t2 prod_t2 t mkt_t prod_t cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel 

reg D_new t4 mkt_t4 cat_t4 prod_t4 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 

*reg D_new t2 t6 [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 

reg D_new t2 mkt_t2 prod_t2 t6 mkt_t6 cat_t6 prod_t6 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel 

mkspline t_1 1.7 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel 
drop t_*

*********
***All***
*********

clear
use New_Metadata_All_Delete_Latest_051517
*generate variables
gen cat_t=cat*t

gen T3_new= T_new^3
gen T4_new= T_new^4
gen T5_new= T_new^5
gen T6_new= T_new^6
gen theta= Alt_Curr_NASA
gen theta2= Alt_Curr_NASA^2
gen theta3= Alt_Curr_NASA^3
gen theta4= Alt_Curr_NASA^4
gen theta5= Alt_Curr_NASA^5
gen theta6= Alt_Curr_NASA^6

*gen t4= T4_new+4* Alt_Curr_NASA* T3_new+6* Alt_Curr_NASA^2* T2_new+4* Alt_Curr_NASA^3* T_new
gen t4= T4_new+4* theta* T3_new+6* theta2* T2_new+4* theta3* T_new
gen t6= T6_new+6*theta*T5_new+15*theta2*T4_new+20*theta3*T3_new+15*theta4*T2_new+6*theta5*T_new

*gen t4 =T_new^4
gen mkt_t4=t4*Market
gen cat_t4=cat*t4
gen prod_t4=prod*t4

*gen t6 =T_new^6
gen mkt_t6=t6*Market
gen cat_t6=cat*t6
gen prod_t6=prod*t6

reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel

reg D_new t mkt_t cat_t prod_t cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 

*reg D_new t t2 [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel

reg D_new t2 mkt_t2 cat_t2 prod_t2 t mkt_t prod_t cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel 

reg D_new t4 mkt_t4 cat_t4 prod_t4 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 

*reg D_new t2 t6 [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 

reg D_new t2 mkt_t2 prod_t2 t6 mkt_t6 cat_t6 prod_t6 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel 

mkspline t_1 0.8 t_2 = t
gen t_1_mkt = t_1*Market
gen t_2_mkt = t_2*Market
gen t_1_cat = t_1*cat 
gen t_2_cat = t_2*cat 
gen t_1_prod = t_1*prod
gen t_2_prod = t_2*prod
reg D_new t_1 t_1_mkt t_1_cat t_1_prod t_2 t_2_mkt t_2_cat t_2_prod cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_AltFncFrm,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel 
drop t_*




********************************************************************************************************************************************************
********************************************************************************************************************************************************
**************************************************************Appendix Table Dropped- Cluster at Alternative Scale**************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

***Define Nordhaus and Sztorc (2013) scalar
scalar NS_13=0.2136

****Author - Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster author_app)
outreg2 using BCA15_TableA6_wgt,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel replace
test t2=NS_13
scalar L_1_1=r(p)
test t2+prod_t2=NS_13
scalar L_1_2=r(p)
test t2+cat_t2=NS_13
scalar L_1_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_1_4=r(p)

****Method2 - Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster method2_app)
outreg2 using BCA15_TableA6_wgt,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar L_2_1=r(p)
test t2+prod_t2=NS_13
scalar L_2_2=r(p)
test t2+cat_t2=NS_13
scalar L_2_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_2_4=r(p)

****Method2 - Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model4_app)
outreg2 using BCA15_TableA6_wgt,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar L_3_1=r(p)
test t2+prod_t2=NS_13
scalar L_3_2=r(p)
test t2+cat_t2=NS_13
scalar L_3_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_3_4=r(p)

****Model
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster Primary_model)
outreg2 using BCA15_TableA6_wgt,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar L_4_1=r(p)
test t2+prod_t2=NS_13
scalar L_4_2=r(p)
test t2+cat_t2=NS_13
scalar L_4_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_4_4=r(p)

*********************************************************All********************************************************************

****Author - Large set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster author_app)
outreg2 using BCA15_TableA6_wgt,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar A_1_1=r(p)
test t2+prod_t2=NS_13
scalar A_1_2=r(p)
test t2+cat_t2=NS_13
scalar A_1_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_1_4=r(p)

****Method2 - Large set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster method2_app)
outreg2 using BCA15_TableA6_wgt,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar A_2_1=r(p)
test t2+prod_t2=NS_13
scalar A_2_2=r(p)
test t2+cat_t2=NS_13
scalar A_2_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_2_4=r(p)

****Model4 - Large set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model4_app)
outreg2 using BCA15_TableA6_wgt,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar A_3_1=r(p)
test t2+prod_t2=NS_13
scalar A_3_2=r(p)
test t2+cat_t2=NS_13
scalar A_3_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_3_4=r(p)

****Model 
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster Primary_model)
outreg2 using BCA15_TableA6_wgt,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar A_4_1=r(p)
test t2+prod_t2=NS_13
scalar A_4_2=r(p)
test t2+cat_t2=NS_13
scalar A_4_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_4_4=r(p)


scalar list L_1_1 L_2_1 L_3_1 L_4_1 A_1_1 A_2_1 A_3_1 A_4_1
scalar list L_1_2 L_2_2 L_3_2 L_4_2 A_1_2 A_2_2 A_3_2 A_4_2
scalar list L_1_3 L_2_3 L_3_3 L_4_3 A_1_3 A_2_3 A_3_3 A_4_3
scalar list L_1_4 L_2_4 L_3_4 L_4_4 A_1_4 A_2_4 A_3_4 A_4_4


********************************************************************************************************************************************************
********************************************************************************************************************************************************
**************************************************************Appendix Table C7 - Alternative Estimation Strategies**************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
scalar drop _all
scalar NS_13=0.21360

***Original - Preferred Model***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC7,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace
test t2=NS_13
scalar L_1_1=r(p)
test t2+cat_t2=NS_13
scalar L_1_2=r(p)
test t2+prod_t2=NS_13
scalar L_1_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_1_4=r(p)


***OLS***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc vce(cluster model_app)
outreg2 using BCA15_TableC7,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar L_2_1=r(p)
test t2+cat_t2=NS_13
scalar L_2_2=r(p)
test t2+prod_t2=NS_13
scalar L_2_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_2_4=r(p)

***GLS***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*
sort model
xtset model study_model
xtgls D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], nocon panels(h) corr(i) force
outreg2 using BCA15_TableC7, addstat("Min group Size",e(g_min),"Avg. group size",e(g_avg),"Max group size",e(g_max),"Chi-squared", e(chi2), "Degrees of Freedom", e(df), "Prob>chi2",e(p)) word excel
test t2=NS_13
scalar L_3_1=r(p)
test t2+cat_t2=NS_13
scalar L_3_2=r(p)
test t2+prod_t2=NS_13
scalar L_3_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_3_4=r(p)


***Fixed Effect Method2***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross Method2_1 - Method2_6 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC7,  addstat("R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar L_4_1=r(p)
test t2+cat_t2=NS_13
scalar L_4_2=r(p)
test t2+prod_t2=NS_13
scalar L_4_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_4_4=r(p)


***GLS with Fixed Effects***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*
sort model
xtset model study_model
xtgls  D_new t2 mkt_t2 cat_t2 prod_t2 cross Method2_1 - Method2_6 [aweight = inv_t], nocon panels(h) corr(i) force
outreg2 using BCA15_TableC7, addstat("Min group Size",e(g_min),"Avg. group size",e(g_avg),"Max group size",e(g_max),"Chi-squared", e(chi2), "Degrees of Freedom", e(df), "Prob>chi2",e(p)) word excel
test t2=NS_13
scalar L_5_1=r(p)
test t2+cat_t2=NS_13
scalar L_5_2=r(p)
test t2+prod_t2=NS_13
scalar L_5_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_5_4=r(p)

scalar list L_1_1 L_2_1 L_3_1 L_4_1 L_5_1 
scalar list L_1_2 L_2_2 L_3_2 L_4_2 L_5_2 
scalar list L_3_3 L_4_3 L_5_3 


***************************************************************All**********************************************************************************

clear
use New_Metadata_All_Delete_Latest_051517
*
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC7,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar A_1_1=r(p)
test t2+cat_t2=NS_13
scalar A_1_2=r(p)
test t2+prod_t2=NS_13
scalar A_1_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_1_4=r(p)

***Model4***
clear
use New_Metadata_All_Delete_Latest_051517
*
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc vce(cluster model_app)
outreg2 using BCA15_TableC7,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar A_2_1=r(p)
test t2+cat_t2=NS_13
scalar A_2_2=r(p)
test t2+prod_t2=NS_13
scalar A_2_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_2_4=r(p)


***GLS***
clear
use New_Metadata_All_Delete_Latest_051517
*
sort model
xtset model study_model
xtgls D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], nocon panels(h) corr(i) force
outreg2 using BCA15_TableC7, addstat("Min group Size",e(g_min),"Avg. group size",e(g_avg),"Max group size",e(g_max),"Chi-squared", e(chi2), "Degrees of Freedom", e(df), "Prob>chi2",e(p)) word excel
test t2=NS_13
scalar A_3_1=r(p)
test t2+cat_t2=NS_13
scalar A_3_2=r(p)
test t2+prod_t2=NS_13
scalar A_3_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_3_4=r(p)



***Fixed Effect Method2***
clear
use New_Metadata_All_Delete_Latest_051517
*
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross Method2_1 - Method2_6 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC7,  addstat("R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar A_4_1=r(p)
test t2+cat_t2=NS_13
scalar A_4_2=r(p)
test t2+prod_t2=NS_13
scalar A_4_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_4_4=r(p)


***GLS with Fixed Effects***
clear
use New_Metadata_All_Delete_Latest_051517
*
sort model
xtset model study_model
xtgls D_new t2 mkt_t2 cat_t2 prod_t2 cross Method2_1 - Method2_6  [aweight = inv_t], nocon panels(h) corr(i) force
outreg2 using BCA15_TableC7, addstat("Min group Size",e(g_min),"Avg. group size",e(g_avg),"Max group size",e(g_max),"Chi-squared", e(chi2), "Degrees of Freedom", e(df), "Prob>chi2",e(p)) word excel
test t2=NS_13
scalar A_5_1=r(p)
test t2+cat_t2=NS_13
scalar A_5_2=r(p)
test t2+prod_t2=NS_13
scalar A_5_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_5_4=r(p)

scalar list L_1_1 L_2_1 L_3_1 L_4_1 L_5_1 A_1_1 A_2_1 A_3_1 A_4_1 A_5_1 
scalar list L_1_2 L_2_2 L_3_2 L_4_2 L_5_2 A_1_2 A_2_2 A_3_2 A_4_2 A_5_2 
scalar list L_1_3 L_2_3 L_3_3 L_4_3 L_5_3 A_1_3 A_2_3 A_3_3 A_4_3 A_5_3 
scalar list L_1_4 L_2_4 L_3_4 L_4_4 L_5_4 A_1_4 A_2_4 A_3_4 A_4_4 A_5_4 


********************************************************************************************************************************************************
********************************************************************************************************************************************************
**************************************************************Appendix Table C5 - Senstivity Analyses***************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
scalar drop _all
scalar NS_13=0.21360

***Original - Preferred Model***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC5,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace
test t2=NS_13
scalar L_1_1=r(p)
test t2+cat_t2=NS_13
scalar L_1_2=r(p)
test t2+prod_t2=NS_13
scalar L_1_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_1_4=r(p)

***Science - Non-catastrophic
clear
use New_Metadata_Low_Delete_Latest_alt_051517
drop if Method2=="Science"
reg damage t2 mkt_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC5,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar L_2_1=r(p)
scalar L_2_2=.
test t2+prod_t2=NS_13
scalar L_2_3=r(p)
scalar L_2_4=.

***Eco
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*
gen Market2 = Market
replace Market2 = 0 if Eco_market==1
gen NASA2_mkt=T2_new* Market2 +2*Alt_Curr_NASA*Market2 *T_new
rename NASA2_mkt mkt2_t2

*
reg D_new t2 mkt2_t2 cat_t2 prod_t2 cross  [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC5,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar L_3_1=r(p)
test t2+cat_t2=NS_13
scalar L_3_2=r(p)
test t2+prod_t2=NS_13
scalar L_3_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_3_4=r(p)

***3
clear
use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross  [aweight = inv_t] if t<3.1, noc vce(cluster model_app)
*outreg2 using BCA15_TableC5,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
outreg2 using BCA15_TableC5,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar L_4_1=r(p)
test t2+cat_t2=NS_13
scalar L_4_2=r(p)
test t2+prod_t2=NS_13
scalar L_4_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_4_4=r(p)

***4.5 with prod
clear
use New_Metadata_Low_Delete_Latest_4p5_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC5,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar L_5_1=r(p)
test t2+cat_t2=NS_13
scalar L_5_2=r(p)
test t2+prod_t2=NS_13
scalar L_5_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_5_4=r(p)

***More Restrictive Definition of Duplication
clear
use New_Metadata_Low_Prefer_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC5,  addstat("Liklihood", e(ll), "R2", e(r2)) dec(3) adjr2 word excel
test t2=NS_13
scalar L_6_1=r(p)
test t2+prod_t2=NS_13
scalar L_6_2=r(p)
test t2+cat_t2=NS_13
scalar L_6_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_6_4=r(p)

***More Restrictive Definition of Citation - Drop Meyer and Hanemann
clear
use New_Metadata_Low_Delete_Latest_alt_051517
list obs Study if obs==4
list obs Study if obs==34
drop if obs==4
drop if obs==34
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_TableC5,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
outreg2 using BCA15_TableC5,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar L_7_1=r(p)
test t2+cat_t2=NS_13
scalar L_7_2=r(p)
test t2+prod_t2=NS_13
scalar L_7_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_7_4=r(p)

scalar list L_1_1 L_2_1 L_3_1 L_4_1 L_5_1 L_6_1 L_7_1
scalar list L_1_2 L_2_2 L_3_2 L_4_2 L_5_2 L_6_2 L_7_2
scalar list L_1_3 L_2_3 L_3_3 L_4_3 L_5_3 L_6_3 L_7_3
scalar list L_1_4 L_2_4 L_3_4 L_4_4 L_5_4 L_6_4 L_7_4

************Additional runs****************************

***Equal weighting of estimates form same study
clear
use New_Metadata_Low_Delete_Latest_alt_051517
sort Year Study t obs
list obs Study t D_new prefer
gen prob=1
replace prob=0.5 if obs==12
replace prob=0.5 if obs==13
replace prob=0.5 if obs==45
replace prob=0.5 if obs==46
replace prob=0.5 if obs==48
replace prob=0.5 if obs==49
list Study if obs==12|obs==13|obs==45|obs==46|obs==48|obs==49
tab Study if prob==0.5
gen inv_p=prob*inv_t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_p], noc vce(cluster model_app)
outreg2 using TableC5_add,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel replace
test t2=NS_13
scalar L_8_1=r(p)
test t2+prod_t2=NS_13
scalar L_8_2=r(p)
test t2+cat_t2=NS_13
scalar L_8_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_8_4=r(p)

***FUND
clear
use New_Metadata_Low_Delete_Latest_alt_051517
rename FUND_T2 t2_FUND
rename FUND_mkt mkt_t2_FUND
rename FUND_cat cat_t2_FUND
rename FUND_prod prod_t2_FUND
reg D_new t2_FUND mkt_t2_FUND cat_t2_FUND prod_t2_FUND cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TableC5_add,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2_FUND=NS_13
scalar L_9_1=r(p)
test t2_FUND+ cat_t2_FUND==NS_13
scalar L_9_2=r(p)
test t2_FUND+prod_t2_FUND=NS_13
scalar L_9_3=r(p)
test t2_FUND+prod_t2_FUND+cat_t2_FUND=NS_13
scalar L_9_4=r(p)

***AVG
clear
use New_Metadata_Low_Delete_Latest_alt_051517
rename AVG_T2 t2_AVG
rename AVG_mkt mkt_t2_AVG
rename AVG_cat cat_t2_AVG
rename AVG_prod prod_t2_AVG
reg D_new t2_AVG mkt_t2_AVG cat_t2_AVG prod_t2_AVG cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TableC5_add,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2_AVG=NS_13
scalar L_10_1=r(p)
test t2_AVG+cat_t2_AVG=NS_13
scalar L_10_2=r(p)
test t2_AVG+prod_t2_AVG=NS_13
scalar L_10_3=r(p)
test t2_AVG+prod_t2_AVG+cat_t2_AVG=NS_13
scalar L_10_4=r(p)

***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
list obs Study if obs==4
list obs Study if obs==34
list obs Study if Primary_model=="ENVISAGE"
list obs Study if Primary_model=="ICES"
drop if obs==4
drop if obs==34
drop if Primary_model=="ENVISAGE"
drop if Primary_model=="ICES"
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_TableC5,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
outreg2 using TableC5_add,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar L_11_1=r(p)
test t2+cat_t2=NS_13
scalar L_11_2=r(p)
test t2+prod_t2=NS_13
scalar L_11_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar L_11_4=r(p)

scalar list L_8_1 L_9_1 L_10_1 L_11_1
scalar list L_8_2 L_9_2 L_10_2 L_11_2
scalar list L_8_3 L_9_3 L_10_3 L_11_3
scalar list L_8_4 L_9_4 L_10_4 L_11_4


********************************************************************************************************************************************************
********************************************************************************************************************************************************
**************************************************************Appendix Table C6 - All - Alternative Estimation Strategies********************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

scalar NS_13=0.21360

***Original***
clear
use New_Metadata_All_Delete_Latest_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC6,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace
test t2=NS_13
scalar A_1_1=r(p)
test t2+cat_t2=NS_13
scalar A_1_2=r(p)
test t2+prod_t2=NS_13
scalar A_1_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_1_4=r(p)

***Science - Non-catastrophic
clear
use New_Metadata_All_Delete_Latest_051517
drop if Method2=="Science"
*replace damage=D_new if Method2=="Science"
*replace cat_t2=T2_new* cat +2*Alt_Curr_NASA*cat *T_new
reg damage t2 mkt_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC6,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test t2=NS_13
scalar A_2_1=r(p)
scalar A_2_2=.
test t2+prod_t2=NS_13
scalar A_2_3=r(p)
scalar A_2_4=.

***Eco
clear
use New_Metadata_All_Delete_Latest_051517
*
gen Market2 = Market
replace Market2 = 0 if Eco_market==1
gen NASA2_mkt=T2_new* Market2 +2*Alt_Curr_NASA*Market2 *T_new
rename NASA2_mkt mkt2_t2
*
reg D_new t2 mkt2_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC6,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar A_3_1=r(p)
test t2+cat_t2=NS_13
scalar A_3_2=r(p)
test t2+prod_t2=NS_13
scalar A_3_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_3_4=r(p)


***More Restrictive Definition of Duplication
clear
use New_Metadata_All_Prefer_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using BCA15_TableC6,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using BCA15_TableC6,  addstat("Liklihood", e(ll), "R2", e(r2)) dec(3) adjr2 word excel
test t2=NS_13
scalar A_4_1=r(p)
test t2+cat_t2=NS_13
scalar A_4_2=r(p)
test t2+prod_t2=NS_13
scalar A_4_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_4_4=r(p)

***Drop Meyer and Hanemann
clear
use New_Metadata_All_Delete_Latest_051517
list obs Study if obs==4
list obs Study if obs==34
drop if obs==4
drop if obs==34
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC6,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar A_5_1=r(p)
test t2+cat_t2=NS_13
scalar A_5_2=r(p)
test t2+prod_t2=NS_13
scalar A_5_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_5_4=r(p)

scalar list A_1_1 A_2_1 A_3_1 A_4_1 A_5_1
scalar list A_1_2 A_2_2 A_3_2 A_4_2 A_5_2
scalar list A_1_3 A_2_3 A_3_3 A_4_3 A_5_3
scalar list A_1_4 A_2_4 A_3_4 A_4_4 A_5_4

************************************Additional Runs***************************************
***Equal weighting of estimates form same study
clear
use New_Metadata_All_Delete_Latest_051517
sort Year Study t obs
list obs Study t D_new prefer
gen prob=1
tab Study if prefer==0
replace prob=0.5 if obs==2
replace prob=0.5 if obs==3
replace prob=0.5 if obs==12
replace prob=0.5 if obs==13
replace prob=0.5 if obs==36
replace prob=0.5 if obs==37
replace prob=0.5 if obs==38
replace prob=0.5 if obs==39
replace prob=0.5 if obs==45
replace prob=0.5 if obs==46
replace prob=0.5 if obs==48
replace prob=0.5 if obs==49
tab Study if prob==0.5
gen inv_p=prob*inv_t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_p], noc vce(cluster model_app)
outreg2 using BCA15_TableC6_add,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) dec(3) adjr2 word excel replace
test t2=NS_13
scalar A_6_1=r(p)
test t2+prod_t2=NS_13
scalar A_6_2=r(p)
test t2+cat_t2=NS_13
scalar A_6_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_6_4=r(p)

***FUND
clear
use New_Metadata_All_Delete_Latest_051517
rename FUND_T2 t2_FUND
rename FUND_mkt mkt_t2_FUND
rename FUND_cat cat_t2_FUND
rename FUND_prod prod_t2_FUND 
reg D_new t2_FUND mkt_t2_FUND cat_t2_FUND prod_t2_FUND cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC6_add,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar A_7_1=r(p)
test t2+cat_t2=NS_13
scalar A_7_2=r(p)
test t2+prod_t2=NS_13
scalar A_7_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_7_4=r(p)

***AVG
clear
use New_Metadata_All_Delete_Latest_051517
rename AVG_T2 t2_AVG
rename AVG_mkt mkt_t2_AVG
rename AVG_cat cat_t2_AVG 
rename AVG_prod prod_t2_AVG
reg D_new t2_AVG mkt_t2_AVG cat_t2_AVG prod_t2_AVG cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC6_add,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar A_8_1=r(p)
test t2+cat_t2=NS_13
scalar A_8_2=r(p)
test t2+prod_t2=NS_13
scalar A_8_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_8_4=r(p)

***Drop Meyer and Hanemann
clear
use New_Metadata_All_Delete_Latest_051517
list obs Study if obs==4
list obs Study if obs==34
list obs Study if Primary_model=="ENVISAGE"
list obs Study if Primary_model=="ICES"
drop if obs==4
drop if obs==34
drop if Primary_model=="ENVISAGE"
drop if Primary_model=="ICES"
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableC6_add,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel 
test t2=NS_13
scalar A_9_1=r(p)
test t2+cat_t2=NS_13
scalar A_9_2=r(p)
test t2+prod_t2=NS_13
scalar A_9_3=r(p)
test t2+prod_t2+cat_t2=NS_13
scalar A_9_4=r(p)


scalar list A_6_1 A_7_1 A_8_1 A_9_1
scalar list A_6_2 A_7_2 A_8_2 A_9_2
scalar list A_6_3 A_7_3 A_8_3 A_9_3
scalar list A_6_4 A_7_4 A_8_4 A_9_4

***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
******************************************Test Publication Bias -Grey Variables****************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************
***********************************************************************************************************************************************************

***Define Nordhaus and Sztorc (2013) scalar
scalar NS_13=0.21360

***********************************************************************************************************************************************************
********************************************************************************************************************************************************
*******************************************Both Grey Variables******************************************************************************************
********************************************************************************************************************************************************
***********************************************************************************************************************************************************


********************************************************************************************************************************************************
*******************************************Low Data - Regressions & Drop Delete*************************************************************************
********************************************************************************************************************************************************

***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_alt_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 Grey grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace
test Grey
scalar L_1_1=r(p)
test grey_t2
scalar L_1_2=r(p)
test Grey
test grey_t2, a
scalar L_1_3=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_alt_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross Grey grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test Grey
scalar L_2_1=r(p)
test grey_t2
scalar L_2_2=r(p)
test Grey
test grey_t2, a
scalar L_2_3=r(p)


********************************************************************************************************************************************************
*******************************************Low Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************

***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 Grey grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test Grey
scalar L_3_1=r(p)
test grey_t2
scalar L_3_2=r(p)
test Grey
test grey_t2, a
scalar L_3_3=r(p)


***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross Grey grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test Grey
scalar L_4_1=r(p)
test grey_t2
scalar L_4_2=r(p)
test Grey
test grey_t2, a
scalar L_4_3=r(p)


********************************************************************************************************************************************************
*******************************************All Data - Regressions & Drop Delete*************************************************************************
********************************************************************************************************************************************************

***Small set of exogenous variables***
clear
use New_Metadata_All_Delete_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 Grey grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test Grey
scalar A_1_1=r(p)
test grey_t2
scalar A_1_2=r(p)
test Grey
test grey_t2, a
scalar A_1_3=r(p)


***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross Grey grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test Grey
scalar A_2_1=r(p)
test grey_t2
scalar A_2_2=r(p)
test Grey
test grey_t2, a
scalar A_2_3=r(p)

********************************************************************************************************************************************************
*******************************************All Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************


***Small set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 Grey grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test Grey
scalar A_3_1=r(p)
test grey_t2
scalar A_3_2=r(p)
test Grey
test grey_t2, a
scalar A_3_3=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross Grey grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test Grey
scalar A_4_1=r(p)
test grey_t2
scalar A_4_2=r(p)
test Grey
test grey_t2, a
scalar A_4_3=r(p)

********************************************************************************************************************************************************
********************************************************************************************************************************************************
*******************************************Indicator Grey Variable**************************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************


********************************************************************************************************************************************************
*******************************************Low Data - Regressions & Drop Delete*************************************************************************
********************************************************************************************************************************************************

***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_alt_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 Grey [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace
test Grey
scalar L_5_1=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_alt_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross Grey [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test Grey
scalar L_6_1=r(p)

********************************************************************************************************************************************************
*******************************************Low Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************

***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 Grey [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test Grey
scalar L_7_1=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross Grey [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test Grey
scalar L_8_1=r(p)

********************************************************************************************************************************************************
*******************************************All Data - Regressions & Drop Delete*************************************************************************
********************************************************************************************************************************************************

***Small set of exogenous variables***
clear
use New_Metadata_All_Delete_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 Grey [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test Grey
scalar A_5_1=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross Grey [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test Grey
scalar A_6_1=r(p)

********************************************************************************************************************************************************
*******************************************All Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************


***Small set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 Grey [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test Grey
scalar A_7_1=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross Grey [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10b,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test Grey
scalar A_8_1=r(p)

********************************************************************************************************************************************************
********************************************************************************************************************************************************
*******************************************Grey-Temperature Squared Indicator Variable Only*************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************


********************************************************************************************************************************************************
*******************************************Low Data - Regressions & Drop Delete*************************************************************************
********************************************************************************************************************************************************

***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_alt_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace
test grey_t2
scalar L_5_2=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_alt_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test grey_t2
scalar L_6_2=r(p)

********************************************************************************************************************************************************
*******************************************Low Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************

***Small set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test grey_t2
scalar L_7_2=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test grey_t2
scalar L_8_2=r(p)

********************************************************************************************************************************************************
*******************************************All Data - Regressions & Drop Delete*************************************************************************
********************************************************************************************************************************************************

***Small set of exogenous variables***
clear
use New_Metadata_All_Delete_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test grey_t2
scalar A_5_2=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test grey_t2
scalar A_6_2=r(p)

********************************************************************************************************************************************************
*******************************************All Data - Drop Delete, Keep Latest, and Drop Cited**********************************************************
********************************************************************************************************************************************************


***Small set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test grey_t2
scalar A_7_2=r(p)

***Large set of exogenous variables***
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
gen grey_t2=Grey*t2
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross grey_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_TableA10c,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
test grey_t2
scalar A_8_2=r(p)

********************************************************************************************************************************************************
*******************************************Scalar List**************************************************************************************************
********************************************************************************************************************************************************

scalar list L_1_1 L_2_1 L_3_1 L_4_1 L_5_1 L_6_1 L_7_1 L_8_1 A_1_1 A_2_1 A_3_1 A_4_1 A_5_1 A_6_1 A_7_1 A_8_1
scalar list L_1_2 L_2_2 L_3_2 L_4_2 L_5_2 L_6_2 L_7_2 L_8_2 A_1_2 A_2_2 A_3_2 A_4_2 A_5_2 A_6_2 A_7_2 A_8_2
scalar list L_1_3 L_2_3 L_3_3 L_4_3 A_1_3 A_2_3 A_3_3 A_4_3



********************************************************************************************************************************************************
********************************************************************************************************************************************************
**********************************************Appendix Figure C1 and Parts of C3 and Tables C8 - Outlier Low -******************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
clear
use New_Metadata_Low_Delete_Latest_alt_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_FigureC1, addstat("Liklihood", e(ll),"R2", e(r2)) adjr2 word excel replace
sort Year Study t D_new
gen obs2=_n

scalar w21=21
global wbin=w21
forval j = 1/$wbin {
preserve
drop if obs2==`j'
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using BCA15_FigureC1, addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
restore
}
*

*Dropped Studies*
tab Study, gen(Study__)
gen obs3=0
scalar v18=18
global vbin=v18
forval j = 1/$vbin {
replace obs3=`j' if Study__`j'==1
}
*
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using  BCA15_FigureC1_Study, addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel replace
forval j = 1/$vbin {
preserve
drop if obs3==`j'
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using  BCA15_FigureC1_Study, addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
restore
}
*

***Residual versus
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc
predict d1, cooksd
predict r1, rstandard
gen absr1 = abs(r1)
gen r2 = r1^2
twoway (scatter d1 r1, mlabel(obs2)), ytitle(Cook's distance) xtitle(Absolute value of the residual)
*scatter d1 r2, mlabel(obs2)
*drop d1 r1 r2 absr1

reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t]
lvr2plot, mlabel(obs2)
graph export FigureC3ai.eps, replace
graph export FigureC3ai.pdf, replace

*Original
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], vce(cluster model_app)
outreg2 using TableC8_ext, excel replace

reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TableC8, excel replace

***M Estimator
*Hubwer weights
set seed 983432
mregress D_new t2 mkt_t2 cat_t2 prod_t2 cross
outreg2 using TableC8_ext, excel 

set seed 983432
mregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc
outreg2 using TableC8, excel 

*Bi-weights
set seed 983432
rreg D_new t2 mkt_t2 cat_t2  prod_t2 cross, genwt(HW3)
outreg2 using TableC8_ext, excel 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = HW3], noc vce(cluster model_app)
outreg2 using TableC8, excel 
*
set seed 983432
robreg m D_new t2 mkt_t2 cat_t2  prod_t2 cross, gen(HW4)
outreg2 using TableC8_ext, excel 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = HW4], noc vce(cluster model_app)
outreg2 using TableC8, excel 

***S Estimator
set seed 983432
robreg s D_new t2 mkt_t2 cat_t2  prod_t2 cross, gen(HW5)
outreg2 using TableC8_ext, excel 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = HW5], noc vce(cluster model_app)
outreg2 using TableC8, excel 
*
set seed 983432
sregress D_new t2 mkt_t2 cat_t2 prod_t2 cross
outreg2 using TableC8_ext, excel 
set seed 983432
xi: sregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc outlier graph
outreg2 using TableC8, excel 

***MM Estimator
set seed 983432
robreg mm D_new t2 mkt_t2 cat_t2  prod_t2 cross, gen(HW6)
outreg2 using TableC8_ext, excel 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = HW6], noc vce(cluster model_app)
outreg2 using TableC8, excel 
*
set seed 983432
mmregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, eff(0.85)
outreg2 using TableC8_ext, excel 
set seed 983432
xi: mmregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc outlier graph eff(0.85) label(obs2)
outreg2 using TableC8, excel 
graph export FigureC3bi.eps, replace
graph export FigureC3bi.pdf, replace

*
qreg D_new t2 mkt_t2 cat_t2  prod_t2 cross
outreg2 using TableC8_ext, excel 

list obs2 Study HW3 HW4 HW5 HW6

***Drop outliers consistent with mm regression (robreg)***
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t] if HW6>0.8, noc vce(cluster model_app) 
outreg2 using TableC8, excel 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t] if HW6>0.85, noc vce(cluster model_app) 
outreg2 using TableC8_drop_85, excel  replace


***Determine % of times that mm regressor collapses to OLS***
clear
use New_Metadata_Low_Delete_Latest_alt_051517
set seed 983432
scalar v20=1000
global vbin=v20
forval j = 1/$vbin {
mmregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, eff(0.85) noc
scalar a__`j'=_b[cat_t2]
}


***Robustness of MM estimator
*
set seed 983432
xi: mmregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc  eff(0.7)
outreg2 using TableC8_sens, excel replace
*
set seed 983432
xi: mmregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc  eff(0.85)
outreg2 using TableC8_sens, excel 
*
set seed 983432
xi: mmregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc eff(0.95)
outreg2 using TableC8_sens, excel 

********************************************************************************************************************************************************
********************************************************************************************************************************************************
**********************************************Appendix Figure C2 and Parts of C3 and Tables C8**********************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************
clear
use New_Metadata_All_Delete_Latest_051517
*gen inv_t=1/t
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using FigureC2, word excel replace
sort Year Study t D_new
gen obs2=_n

scalar w26=26
global wbin=w26
forval j = 1/$wbin {
preserve
drop if obs2==`j'
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using FigureC2, word excel
restore
}
*

*Dropped Studies*
tab Study, gen(Study__)
gen obs3=0
scalar v20=20
global vbin=v20
forval j = 1/$vbin {
replace obs3=`j' if Study__`j'==1
}
*
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using FigureC2_Study, addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel replace
forval j = 1/$vbin {
preserve
drop if obs3==`j'
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using FigureC2_Study, addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
restore
}
*

***Residual versus
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc
predict d1, cooksd
predict r1, rstandard
gen absr1 = abs(r1)
gen r2 = r1^2
twoway (scatter d1 r1, mlabel(obs2)), ytitle(Cook's distance) xtitle(Absolute value of the residual)
*scatter d1 r2, mlabel(obs2)
*drop d1 r1 r2 absr1

reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t]
lvr2plot, mlabel(obs2)
graph export FigureC3aii.eps, replace
graph export FigureC3aii.pdf, replace

*Original
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], vce(cluster model_app)
outreg2 using TableC8_ext, excel

reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TableC8, excel

***M Estimator
*Hubwer weights
set seed 983432
mregress D_new t2 mkt_t2 cat_t2 prod_t2 cross
outreg2 using TableC8_ext, excel 
set seed 983432
mregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc
outreg2 using TableC8, excel 

*Bi-weights
rreg D_new t2 mkt_t2 cat_t2  prod_t2 cross, genwt(HW3)
outreg2 using TableC8_ext, excel 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = HW3], noc vce(cluster model_app)
outreg2 using TableC8, excel 
*
robreg m D_new t2 mkt_t2 cat_t2  prod_t2 cross, gen(HW4)
outreg2 using TableC8_ext, excel 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = HW4], noc vce(cluster model_app)
outreg2 using TableC8, excel 

***S Estimator
set seed 983432
robreg s D_new t2 mkt_t2 cat_t2  prod_t2 cross, gen(HW5)
outreg2 using TableC8_ext, excel 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = HW5], noc vce(cluster model_app)
outreg2 using TableC8, excel 
*
set seed 983432
sregress D_new t2 mkt_t2 cat_t2 prod_t2 cross
outreg2 using TableC8_ext, excel 
set seed 983432
xi: sregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc outlier graph
outreg2 using TableC8, excel 

***MM Estimator
set seed 983432
robreg mm D_new t2 mkt_t2 cat_t2  prod_t2 cross, gen(HW6)
outreg2 using TableC8_ext, excel 
set seed 983432
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = HW6], noc vce(cluster model_app)
outreg2 using TableC8, excel 
*
set seed 983432
mmregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, eff(0.85)
outreg2 using TableC8_ext, excel 
set seed 983432
xi: mmregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc outlier graph eff(0.85) label(obs2)
outreg2 using TableC8, excel 
graph export FigureC3bii.eps, replace
graph export FigureC3bii.pdf, replace
*
qreg D_new t2 mkt_t2 cat_t2  prod_t2 cross
outreg2 using TableC8_ext, excel 

list obs2 Study HW3 HW4 HW5 HW6 

***Drop outliers consistent with mm regression (robreg)***
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t] if HW6>0.8, noc vce(cluster model_app) 
outreg2 using TableC8, excel 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t] if HW6>0.85, noc vce(cluster model_app) 
outreg2 using TableC8_drop_85, excel 


***Robustness of MM estimator
*
set seed 983432
xi: mmregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc  eff(0.7)
outreg2 using TableC8_sens, excel 
*
set seed 983432
xi: mmregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc  eff(0.85)
outreg2 using TableC8_sens, excel 
*
set seed 983432
xi: mmregress D_new t2 mkt_t2 cat_t2 prod_t2 cross, noc eff(0.95)
outreg2 using TableC8_sens, excel 

********From Low: Stability List***********
scalar list

********************************************************************************************************************************************************
********************************************************************************************************************************************************
************************************************************** Tables C9-12 - Method Regressions************************************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

********************************************************************************************************************************************************
********************************************************************************************************************************************************
**************************************************************Method Experiments 1 - Only a Method******************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

***************************
******By Method - LOW******
***************************
clear
use New_Metadata_Low_Delete_Latest_alt_051517

***Original***
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table_C9,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace

***Enumerative***
preserve
keep if Method2=="enumerative" 
list t2 mkt_t2 cat_t2 prod_t2 cross
reg D_new t2 cat_t2[aweight = inv_t], noc vce(robust)
outreg2 using Table_C9,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
restore

***CGE - market and productivity***
preserve
keep if Method2=="CGE-Production" 
list t2 mkt_t2 cat_t2 prod_t2 cross
reg D_new t2 [aweight = inv_t], noc vce(robust)
outreg2 using Table_C9,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
restore

***Statistical***
preserve
keep if Method2=="statistical"
list obs t2 mkt_t2 cat_t2 prod_t2 cross
reg D_new t2 prod_t2 [aweight = inv_t], noc vce(robust)
outreg2 using Table_C9,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel  
restore

***Statistical - Cross-sectional only***
preserve
keep if Method2=="statistical"
drop if obs==23
list obs t2 mkt_t2 cat_t2 prod_t2 cross
reg D_new t2 [aweight = inv_t], noc vce(robust)
outreg2 using Table_C9,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
restore

***Statistical - panel***
preserve
*keep if Method2=="statistical" 
*keep if obs==23
*list obs t2 mkt_t2 cat_t2 prod_t2 cross
*reg D_new t2 [aweight = inv_t], noc vce(robust)
outreg2 using Table_C9,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
restore

***Survey***
preserve
keep if Method2=="Survey" 
list t2 mkt_t2 cat_t2 prod_t2 cross
reg D_new t2 [aweight = inv_t], noc vce(robust)
outreg2 using Table_C9,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
restore

***Science - all include catastrophic
preserve
keep if Method2=="Science" 
list t2 mkt_t2 cat_t2 prod_t2 cross
reg D_new t2 [aweight = inv_t], noc vce(robust)
outreg2 using Table_C9,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
restore

***Hicksian***
clear
use New_Metadata_Low_Delete_Latest_alt_H051517
keep if Nonmarket==1
drop if obs==18
reg D_new t2 [aweight = inv_t] if t<4.01, noc vce(robust)
outreg2 using Table_C9,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 

***************************
******By Method - ALL******
***************************
clear
use New_Metadata_All_Delete_Latest_051517

***Original***
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table_C10, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace

***Enumerative***
preserve
keep if Method2=="enumerative" 
list t2 mkt_t2 cat_t2 prod_t2 cross
reg D_new t2 cat_t2[aweight = inv_t], noc vce(robust)
outreg2 using Table_C10, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
restore

***CGE - market and productivity***
preserve
keep if Method2=="CGE-Production" 
list t2 mkt_t2 cat_t2 prod_t2 cross
reg D_new t2 [aweight = inv_t], noc vce(robust)
outreg2 using Table_C10, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
restore

***Statistical - market only with one productivity
preserve
keep if Method2=="statistical" 
reg D_new t2 prod_t2 [aweight = inv_t], noc vce(robust)
outreg2 using Table_C10, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
restore

***Statistical - cross-sectional with market only
preserve
keep if Method2=="statistical"
drop if obs==23
drop if obs==47 
list t2 mkt_t2 cat_t2 prod_t2 cross
reg D_new t2 [aweight = inv_t], noc vce(robust)
outreg2 using Table_C10, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
restore

***Statistical - panel
preserve
keep if Method2=="statistical"
drop if obs==12
drop if obs==13
drop if obs==26
drop if obs==27 
drop if obs==32
drop if obs==28  
list t2 mkt_t2 cat_t2 prod_t2 cross
reg D_new t2 [aweight = inv_t], noc vce(robust)
outreg2 using Table_C10, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
restore

***Survey***
preserve
keep if Method2=="Survey" 
list t2 mkt_t2 cat_t2 prod_t2 cross
reg D_new t2 [aweight = inv_t], noc vce(robust)
outreg2 using Table_C10, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
restore

***Science - all include catastrophic
preserve
keep if Method2=="Science" 
list t2 mkt_t2 cat_t2 prod_t2 cross
reg D_new t2 [aweight = inv_t], noc vce(robust)
outreg2 using Table_C10, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
restore


***Hicksian***
clear
use New_Metadata_All_Delete_Latest_H051517
keep if Nonmarket==1
drop if obs==18
reg D_new t2 [aweight = inv_t] if t<4.01, noc vce(robust)
reg D_new t2 [aweight = inv_t], noc vce(robust)
outreg2 using Table_C10, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel

********************************************************************************************************************************************************
********************************************************************************************************************************************************
**************************************************************Method Experiments 2 - Only a Method******************************************************
********************************************************************************************************************************************************
********************************************************************************************************************************************************

***************************
******By Method - LOW******
***************************
clear
use New_Metadata_Low_Delete_Latest_alt_051517

***Original***
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table_C11,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace

***Enumerative***
preserve
drop if Method2=="enumerative" 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using Table_C11,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using Table_C11,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
restore

***CGE - market and productivity***
preserve
drop if Method2=="CGE-Production" 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using Table_C11,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using Table_C11,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
restore

***Statistical***
preserve
drop if Method2=="statistical"
reg D_new t2 mkt_t2 cat_t2 prod_t2 [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using Table_C11,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using Table_C11,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
restore

***Statistical - Cross-sectional only***
preserve
drop if Primary_model=="G-ECON"|cross==1
reg D_new t2 mkt_t2 cat_t2 prod_t2 [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using Table_C11,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using Table_C11,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
restore

***Statistical - panel***
preserve
drop if Method2=="statistical" & obs==23
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using Table_C11,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using Table_C11,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
restore

***Survey***
preserve
drop if Method2=="Survey" 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table_C11,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
restore

***Science - all include catastrophic
preserve
drop if Method2=="Science" 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table_C11,  addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel 
restore


***************************
******By Method - ALL******
***************************
clear
use New_Metadata_All_Delete_Latest_051517

***Original***
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table_C12, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel replace

***Enumerative***
preserve
drop if Method2=="enumerative" 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table_C12, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
restore

***CGE - market and productivity***
preserve
drop if Method2=="CGE-Production" 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using Table_C12, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using Table_C12, addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
restore

***Statistical - market only with one productivity
preserve
drop if Method2=="statistical" 
reg D_new t2 mkt_t2 cat_t2 prod_t2 [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using Table_C12, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using Table_C12, addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
restore

***Statistical - cross-sectional with market only
preserve
drop if Primary_model=="G-ECON"|cross==1
reg D_new t2 mkt_t2 cat_t2 prod_t2 [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using Table_C12, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using Table_C12, addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
restore

***Statistical - panel
preserve
drop if Method2=="statistical" & obs==23
drop if Method2=="statistical" & obs==47
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
*outreg2 using Table_C12, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
outreg2 using Table_C12, addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel
restore

***Survey***
preserve
drop if Method2=="Survey" 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table_C12, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
restore

***Science - all include catastrophic
preserve
drop if Method2=="Science" 
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using Table_C12, addstat("Liklihood", e(ll), "F-statistic", e(F), "Prob>F", e(p), "R2", e(r2)) adjr2 word excel
restore



**********************************************************************************************************************
**********************************************************************************************************************
********************************Table C13 - Hicksian******************************************************************
**********************************************************************************************************************
**********************************************************************************************************************

*Low-Final
clear
use New_Metadata_Low_Delete_alt_H051517
gen nmkt_t2=Nonmarket*t2
reg D_new t2 mkt_t2 nmkt_t2 cat_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TableC13_Hicks,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel replace

*Low-Final
clear
use New_Metadata_Low_Delete_alt_H051517
gen nmkt_t2=Nonmarket*t2
reg D_new t2 mkt_t2 nmkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TableC13_Hicks,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel

*Low-Non-cited
clear
use New_Metadata_Low_Delete_Latest_alt_H051517
gen nmkt_t2=Nonmarket*t2
reg D_new t2 mkt_t2 nmkt_t2 cat_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TableC13_Hicks,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel

*Low-Non-cited
clear
use New_Metadata_Low_Delete_Latest_alt_H051517
gen nmkt_t2=Nonmarket*t2
reg D_new t2 mkt_t2 nmkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TableC13_Hicks,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel

*All-Final
clear
use New_Metadata_All_Delete_H051517
gen nmkt_t2=Nonmarket*t2
reg D_new t2 mkt_t2 nmkt_t2 cat_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TableC13_Hicks,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel

*All-Final
clear
use New_Metadata_All_Delete_H051517
gen nmkt_t2=Nonmarket*t2
reg D_new t2 mkt_t2 nmkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TableC13_Hicks,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel


*All-Non-cited
clear
use New_Metadata_All_Delete_Latest_H051517
gen nmkt_t2=Nonmarket*t2
reg D_new t2 mkt_t2 nmkt_t2 cat_t2 [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TableC13_Hicks,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel

*All-Non-cited
clear
use New_Metadata_All_Delete_Latest_H051517
gen nmkt_t2=Nonmarket*t2
reg D_new t2 mkt_t2 nmkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
outreg2 using TableC13_Hicks,  addstat("Liklihood", e(ll), "R2", e(r2)) adjr2 word excel


**********************************************************************************************************************
**********************************************************************************************************************
*************************************Correlation Matrix***************************************************************
**********************************************************************************************************************
**********************************************************************************************************************
clear
use New_Metadata_Low_Delete_Latest_alt_051517
spearman t2 mkt_t2 cat_t2 prod_t2 cross

use New_Metadata_Low_Delete_Latest_alt_051517
reg D_new t2 mkt_t2 cat_t2 prod_t2 cross [aweight = inv_t], noc vce(cluster model_app)
matrix list e(V)
