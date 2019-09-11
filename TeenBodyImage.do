***********************
/////////////////////////////////////////
***INITIALISATION***
///////////////////////////////////////
*********************

clear all
set maxvar 20000
set more off
cd "/users/panosprotopapas/desktop/Unil/SEN/Stata/"
cap log close
log close _all
log using SEN, replace
quietly{
use Wave1.dta

******************************
/////////////////////////////////////////////////////
***WAVE 1 PREPARATION***
///////////////////////////////////////////////////
****************************

/*Delete unwanted variables of Wave 1*/
keep AID IMONTH IDAY IYEAR BIO_SEX H1GI1M H1GI1Y H1GI18 H1GH1 H1GI20 ///
H1DA4 H1DA5 H1DA6 H1DA7 H1DA8 H1DA9 H1DA10 H1GH28 H1GH59A H1GH59B H1GH60 ///
H1IR1 H1IR2 H1IR5 H1IR6 FR_FLAG H1MF2A H1MF3A H1MF4A H1MF5A H1MF6A ///
H1MF7A H1MF8A H1MF9A H1MF10A H1MF2B H1MF3B H1MF4B H1MF5B H1MF6B H1MF7B H1MF8B H1MF9B H1MF10B H1MF2C ///
H1MF3C H1MF4C H1MF5C H1MF6C H1MF7C H1MF8C H1MF9C H1MF10C H1MF2D H1MF3D H1MF4D H1MF5D H1MF6D H1MF7D ///
H1MF8D H1MF9D H1MF10D H1MF2E H1MF3E H1MF4E H1MF5E H1MF6E H1MF7E H1MF8E H1MF9E H1MF10E H1FF2A H1FF3A ///
H1FF4A H1FF5A H1FF6A H1FF7A H1FF8A H1FF9A H1FF10A H1FF2B H1FF3B H1FF4B H1FF5B H1FF6B H1FF7B H1FF8B ///
H1FF9B H1FF10B H1FF2C H1FF3C H1FF4C H1FF5C H1FF6C H1FF7C H1FF8C H1FF9C H1FF10C H1FF2D H1FF3D H1FF4D ///
H1FF5D H1FF6D H1FF7D H1FF8D H1FF9D H1FF10D H1FF2E H1FF3E H1FF4E H1FF5E H1FF6E H1FF7E H1FF8E H1FF9E ///
H1FF10E

/*Gender*/
rename BIO_SEX gender

/*Construct Age*/
gen birth=.
replace H1GI1Y=. if H1GI1Y==96
replace H1GI1M=. if H1GI1M==96
replace birth=H1GI1Y+((H1GI1M-0.5)/12)
gen inter=.
replace inter=IYEAR+((IMONTH)/12)+((IDAY-1)/30.4)
gen age1=inter-birth
drop birth inter H1GI1Y H1GI1M IYEAR IMONTH IDAY

/*Construct BMI [height in inches, weight in pounds]*/
replace H1GH60=. if H1GH60==998 | H1GH60==996 | H1GH60==999
replace H1GH59A=. if H1GH59A==96 | H1GH59A==98
replace H1GH59B=. if H1GH59B==96 | H1GH59B==98 | H1GH59B==99
gen bmi1=.
replace bmi1=(703*H1GH60)/((H1GH59A*12)+H1GH59B)^2
drop H1GH60 H1GH59A H1GH59B

/*Construct Physical Exercise Variable*/
replace H1DA4=. if H1DA4==6 | H1DA4==8
replace H1DA5=. if H1DA5==6 | H1DA5==8
replace H1DA6=. if H1DA6==6 | H1DA6==8
gen physical1=H1DA4+H1DA5+H1DA6
drop H1DA4 H1DA5 H1DA6

/*Construct Physical Condition Variable*/
rename H1GH1 health1
replace health1=. if health1 ==6 | health1 ==8

/* Weight Image */
rename H1GH28 weightimage1
replace weightimage1=. if weightimage1==6 | weightimage1==8

/*Time varying network variables*/
**First Male Friend**
replace H1MF6A=. if H1MF6A!=0 & H1MF6A!=1
replace H1MF7A=. if H1MF7A!=0 & H1MF7A!=1
replace H1MF8A=. if H1MF8A!=0 & H1MF8A!=1
replace H1MF9A=. if H1MF9A!=0 & H1MF9A!=1
replace H1MF10A=. if H1MF10A!=0 & H1MF10A!=1
gen temp=0
forvalues i=6(1)10 {
replace temp=temp+1 if H1MF`i'A==.
}
gen malefriend1quality1=(H1MF6A+ H1MF7A+ H1MF8A+ H1MF9A+ H1MF10A)/(5-temp)
drop H1MF6A H1MF7A H1MF8A H1MF9A H1MF10A temp
**Second Male Friend**
replace H1MF6B=. if H1MF6B!=0 & H1MF6B!=1
replace H1MF7B=. if H1MF7B!=0 & H1MF7B!=1
replace H1MF8B=. if H1MF8B!=0 & H1MF8B!=1
replace H1MF9B=. if H1MF9B!=0 & H1MF9B!=1
replace H1MF10B=. if H1MF10B!=0 & H1MF10B!=1
gen temp=0
forvalues i=6(1)10 {
replace temp=temp+1 if H1MF`i'B==.
}
gen malefriend2quality1=(H1MF6B+ H1MF7B+ H1MF8B+ H1MF9B+ H1MF10B)/(5-temp)
drop H1MF6B H1MF7B H1MF8B H1MF9B H1MF10B temp
**Third Male Friend**
replace H1MF6C=. if H1MF6C!=0 & H1MF6C!=1
replace H1MF7C=. if H1MF7C!=0 & H1MF7C!=1
replace H1MF8C=. if H1MF8C!=0 & H1MF8C!=1
replace H1MF9C=. if H1MF9C!=0 & H1MF9C!=1
replace H1MF10C=. if H1MF10C!=0 & H1MF10C!=1
gen temp=0
forvalues i=6(1)10 {
replace temp=temp+1 if H1MF`i'C==.
}
gen malefriend3quality1=(H1MF6C+ H1MF7C+ H1MF8C+ H1MF9C+ H1MF10C)/(5-temp)
drop H1MF6C H1MF7C H1MF8C H1MF9C H1MF10C temp
**Fourth Male Friend**
replace H1MF6D=. if H1MF6D!=0 & H1MF6D!=1
replace H1MF7D=. if H1MF7D!=0 & H1MF7D!=1
replace H1MF8D=. if H1MF8D!=0 & H1MF8D!=1
replace H1MF9D=. if H1MF9D!=0 & H1MF9D!=1
replace H1MF10D=. if H1MF10D!=0 & H1MF10D!=1
gen temp=0
forvalues i=6(1)10 {
replace temp=temp+1 if H1MF`i'D==.
}
gen malefriend4quality1=(H1MF6D+ H1MF7D+ H1MF8D+ H1MF9D+ H1MF10D)/(5-temp)
drop H1MF6D H1MF7D H1MF8D H1MF9D H1MF10D temp
**Fifth Male Friend**
replace H1MF6E=. if H1MF6E!=0 & H1MF6E!=1
replace H1MF7E=. if H1MF7E!=0 & H1MF7E!=1
replace H1MF8E=. if H1MF8E!=0 & H1MF8E!=1
replace H1MF9E=. if H1MF9E!=0 & H1MF9E!=1
replace H1MF10E=. if H1MF10E!=0 & H1MF10E!=1
gen temp=0
forvalues i=6(1)10 {
replace temp=temp+1 if H1MF`i'E==.
}
gen malefriend5quality1=(H1MF6E+ H1MF7E+ H1MF8E+ H1MF9E+ H1MF10E)/(5-temp)
drop H1MF6E H1MF7E H1MF8E H1MF9E H1MF10E temp
**First Female Friend**
replace H1FF6A=. if H1FF6A!=0 & H1FF6A!=1
replace H1FF7A=. if H1FF7A!=0 & H1FF7A!=1
replace H1FF8A=. if H1FF8A!=0 & H1FF8A!=1
replace H1FF9A=. if H1FF9A!=0 & H1FF9A!=1
replace H1FF10A=. if H1FF10A!=0 & H1FF10A!=1
gen temp=0
forvalues i=6(1)10 {
replace temp=temp+1 if H1FF`i'A==.
}
gen femalefriend1quality1=(H1FF6A+ H1FF7A+ H1FF8A+ H1FF9A+ H1FF10A)/(5-temp)
drop H1FF6A H1FF7A H1FF8A H1FF9A H1FF10A temp
**Second Female Friend**
replace H1FF6B=. if H1FF6B!=0 & H1FF6B!=1
replace H1FF7B=. if H1FF7B!=0 & H1FF7B!=1
replace H1FF8B=. if H1FF8B!=0 & H1FF8B!=1
replace H1FF9B=. if H1FF9B!=0 & H1FF9B!=1
replace H1FF10B=. if H1FF10B!=0 & H1FF10B!=1
gen temp=0
forvalues i=6(1)10 {
replace temp=temp+1 if H1FF`i'B==.
}
gen femalefriend2quality1=(H1FF6B+ H1FF7B+ H1FF8B+ H1FF9B+ H1FF10B)/(5-temp)
drop H1FF6B H1FF7B H1FF8B H1FF9B H1FF10B temp
**Third Female Friend**
replace H1FF6C=. if H1FF6C!=0 & H1FF6C!=1
replace H1FF7C=. if H1FF7C!=0 & H1FF7C!=1
replace H1FF8C=. if H1FF8C!=0 & H1FF8C!=1
replace H1FF9C=. if H1FF9C!=0 & H1FF9C!=1
replace H1FF10C=. if H1FF10C!=0 & H1FF10C!=1
gen temp=0
forvalues i=6(1)10 {
replace temp=temp+1 if H1FF`i'C==.
}
gen femalefriend3quality1=(H1FF6C+ H1FF7C+ H1FF8C+ H1FF9C+ H1FF10C)/(5-temp)
drop H1FF6C H1FF7C H1FF8C H1FF9C H1FF10C temp
**Fourth Female Friend**
replace H1FF6D=. if H1FF6D!=0 & H1FF6D!=1
replace H1FF7D=. if H1FF7D!=0 & H1FF7D!=1
replace H1FF8D=. if H1FF8D!=0 & H1FF8D!=1
replace H1FF9D=. if H1FF9D!=0 & H1FF9D!=1
replace H1FF10D=. if H1FF10D!=0 & H1FF10D!=1
gen temp=0
forvalues i=6(1)10 {
replace temp=temp+1 if H1FF`i'D==.
}
gen femalefriend4quality1=(H1FF6D+ H1FF7D+ H1FF8D+ H1FF9D+ H1FF10D)/(5-temp)
drop H1FF6D H1FF7D H1FF8D H1FF9D H1FF10D temp
**Fifth Female Friend**
replace H1FF6E=. if H1FF6E!=0 & H1FF6E!=1
replace H1FF7E=. if H1FF7E!=0 & H1FF7E!=1
replace H1FF8E=. if H1FF8E!=0 & H1FF8E!=1
replace H1FF9E=. if H1FF9E!=0 & H1FF9E!=1
replace H1FF10E=. if H1FF10E!=0 & H1FF10E!=1
gen temp=0
forvalues i=6(1)10 {
replace temp=temp+1 if H1FF`i'E==.
}
gen femalefriend5quality1=(H1FF6E+ H1FF7E+ H1FF8E+ H1FF9E+ H1FF10E)/(5-temp)
drop H1FF6E H1FF7E H1FF8E H1FF9E H1FF10E temp
**Only keep "best friend" quality**
gen bestmalefriendquality1=max(malefriend1quality1,malefriend2quality1,malefriend3quality1,malefriend4quality1,malefriend5quality1)
drop malefriend1quality1 malefriend2quality1 malefriend3quality1 malefriend4quality1 malefriend5quality1
gen bestfemalefriendquality1=max(femalefriend1quality1,femalefriend2quality1,femalefriend3quality1,femalefriend4quality1,femalefriend5quality1)
drop femalefriend1quality1 femalefriend2quality1 femalefriend3quality1 femalefriend4quality1 femalefriend5quality1

/* Wave */
gen wave1=1

/* Drop unused-unwanted variables*/
drop  H1IR6 H1IR5 H1IR2 H1IR1 H1FF5E H1FF4E H1FF3E H1FF2E H1FF5D H1FF4D ///
H1FF3D H1FF2D H1FF5C H1FF4C H1FF3C H1FF2C H1FF5B H1FF4B H1FF3B H1FF2B ///
H1FF5A H1FF4A H1FF3A H1FF2A H1MF5E H1MF4E H1MF3E H1MF2E H1MF5D H1MF4D ///
H1MF3D H1MF2D H1MF5C H1MF4C FR_FLAG H1GI18  H1MF3C H1MF2C H1MF5B ///
H1MF4B H1MF2B H1MF3B H1MF5A H1MF4A H1MF3A H1MF2A H1DA10 H1DA9 H1DA8 ///
H1DA7 H1GI20

/*Save prepared wave 1 data set and open wave 2*/
save w1, replace
clear all
use Wave2.dta

******************************
/////////////////////////////////////////////////////
***WAVE 2 PREPARATION***
///////////////////////////////////////////////////
****************************

/*Delete unwanted variables of Wave 2*/
keep AID BIO_SEX2 IMONTH2 IDAY2 IYEAR2 H2GI1M H2GI1Y H2GI6 H2DA4 ///
H2DA5 H2DA6 H2DA7 H2DA8 H2DA9 H2DA10 H2GH30 H2GH52F H2GH52I ///
H2GH53 H2ED7 H2ED8 H2ED9 H2ED10 H2GH1 H2WP9 ///
H2WP13 H2PF1 H2PF8 H2RR2A H2IR1 H2IR2 H2IR5 H2IR6 H2GI9 ///
FR_FLAG2 H2FF11A H2FF11B H2FF11C H2FF11D H2FF11E H2FF12A ///
H2FF12B H2FF12C H2FF12D H2FF12E H2FF13A H2FF13B H2FF13C H2FF13D ///
H2FF13E H2FF14A H2FF14B H2FF14C H2FF14D H2FF14E H2FF15A H2FF15B ///
H2FF15C H2FF15D H2FF15E H2FF4A H2FF4B H2FF4C H2FF4D H2FF4E ///
H2FF5A H2FF5B H2FF5C H2FF5D H2FF5E H2FF6A H2FF6B H2FF6C H2FF6D ///
H2FF6E H2FF7A H2FF7B H2FF7C H2FF7D H2FF7E H2MF11A H2MF11B ///
H2MF11C H2MF11D H2MF11E H2MF12A H2MF12B H2MF12C H2MF12D H2MF12E ///
H2MF13A H2MF13B H2MF13C H2MF13D H2MF13E H2MF14A H2MF14B H2MF14C ///
H2MF14D H2MF14E H2MF15A H2MF15B H2MF15C H2MF15D H2MF15E H2MF4A ///
H2MF4B H2MF4C H2MF4D H2MF4E H2MF5A H2MF5B H2MF5C H2MF5D H2MF5E ///
H2MF6A H2MF6B H2MF6C H2MF6D H2MF6E H2MF7A H2MF7B H2MF7C H2MF7D H2MF7E

/*Gender*/
rename BIO_SEX2 gender

/*Construct Age*/
gen birth=.
replace H2GI1Y=. if H2GI1Y==96
replace H2GI1M=. if H2GI1M==96
replace birth=H2GI1Y+((H2GI1M-0.5)/12)
gen inter=.
replace inter=IYEAR2+((IMONTH2)/12)+((IDAY2-1)/30.4)
gen age2=inter-birth
drop birth inter H2GI1Y H2GI1M IYEAR2 IMONTH2 IDAY2

/*Construct BMI [height in inches, weight in pounds]*/
replace H2GH53=. if H2GH53==998 | H2GH53==996 | H2GH53==999
replace H2GH52F=. if H2GH52F==96 | H2GH52F==98
replace H2GH52I=. if H2GH52I==96 | H2GH52I==98 | H2GH52I==99
gen bmi2=.
replace bmi2=(703*H2GH53)/((H2GH52F*12)+H2GH52I)^2
drop H2GH53 H2GH52F H2GH52I

/*Construct Physical Exercise Variable*/
replace H2DA4=. if H2DA4==6 | H2DA4==8
replace H2DA5=. if H2DA5==6 | H2DA5==8
replace H2DA6=. if H2DA6==6 | H2DA6==8
gen physical2=H2DA4+H2DA5+H2DA6
drop H2DA4 H2DA5 H2DA6

/*Construct Physical Condition Variable*/
rename H2GH1 health2
replace health2=. if health2 ==6 | health2 ==8

/* Weight Image */
rename H2GH30 weightimage2
replace weightimage2=. if weightimage2==6 | weightimage2==8

/*Time varying network variables*/
**First Male Friend**
replace H2MF11A=. if H2MF11A!=0 & H2MF11A!=1
replace H2MF12A=. if H2MF12A!=0 & H2MF12A!=1
replace H2MF13A=. if H2MF13A!=0 & H2MF13A!=1
replace H2MF14A=. if H2MF14A!=0 & H2MF14A!=1
replace H2MF15A=. if H2MF15A!=0 & H2MF15A!=1
gen temp=0
forvalues i=11(1)15 {
replace temp=temp+1 if H2MF`i'A==.
}
gen malefriend1quality=(H2MF11A+ H2MF12A+ H2MF13A+ H2MF14A+ H2MF15A)/(5-temp)
drop H2MF11A H2MF12A H2MF13A H2MF14A H2MF15A temp
**Second Male Friend**
replace H2MF11B=. if H2MF11B!=0 & H2MF11B!=1
replace H2MF12B=. if H2MF12B!=0 & H2MF12B!=1
replace H2MF13B=. if H2MF13B!=0 & H2MF13B!=1
replace H2MF14B=. if H2MF14B!=0 & H2MF14B!=1
replace H2MF15B=. if H2MF15B!=0 & H2MF15B!=1
gen temp=0
forvalues i=11(1)15 {
replace temp=temp+1 if H2MF`i'B==.
}
gen malefriend2quality=(H2MF11B+ H2MF12B+ H2MF13B+ H2MF14B+ H2MF15B)/(5-temp)
drop H2MF11B H2MF12B H2MF13B H2MF14B H2MF15B temp
**Third Male Friend**
replace H2MF11C=. if H2MF11C!=0 & H2MF11C!=1
replace H2MF12C=. if H2MF12C!=0 & H2MF12C!=1
replace H2MF13C=. if H2MF13C!=0 & H2MF13C!=1
replace H2MF14C=. if H2MF14C!=0 & H2MF14C!=1
replace H2MF15C=. if H2MF15C!=0 & H2MF15C!=1
gen temp=0
forvalues i=11(1)15 {
replace temp=temp+1 if H2MF`i'C==.
}
gen malefriend3quality=(H2MF11C+ H2MF12C+ H2MF13C+ H2MF14C+ H2MF15C)/(5-temp)
drop H2MF11C H2MF12C H2MF13C H2MF14C H2MF15C temp
**Fourth Male Friend**
replace H2MF11D=. if H2MF11D!=0 & H2MF11D!=1
replace H2MF12D=. if H2MF12D!=0 & H2MF12D!=1
replace H2MF13D=. if H2MF13D!=0 & H2MF13D!=1
replace H2MF14D=. if H2MF14D!=0 & H2MF14D!=1
replace H2MF15D=. if H2MF15D!=0 & H2MF15D!=1
gen temp=0
forvalues i=11(1)15 {
replace temp=temp+1 if H2MF`i'D==.
}
gen malefriend4quality=(H2MF11D+ H2MF12D+ H2MF13D+ H2MF14D+ H2MF15D)/(5-temp)
drop H2MF11D H2MF12D H2MF13D H2MF14D H2MF15D temp
**Fifth Male Friend**
replace H2MF11E=. if H2MF11E!=0 & H2MF11E!=1
replace H2MF12E=. if H2MF12E!=0 & H2MF12E!=1
replace H2MF13E=. if H2MF13E!=0 & H2MF13E!=1
replace H2MF14E=. if H2MF14E!=0 & H2MF14E!=1
replace H2MF15E=. if H2MF15E!=0 & H2MF15E!=1
gen temp=0
forvalues i=11(1)15 {
replace temp=temp+1 if H2MF`i'E==.
}
gen malefriend5quality=(H2MF11E+ H2MF12E+ H2MF13E+ H2MF14E+ H2MF15E)/(5-temp)
drop H2MF11E H2MF12E H2MF13E H2MF14E H2MF15E temp
**First Female Friend**
replace H2FF11A=. if H2FF11A!=0 & H2FF11A!=1
replace H2FF12A=. if H2FF12A!=0 & H2FF12A!=1
replace H2FF13A=. if H2FF13A!=0 & H2FF13A!=1
replace H2FF14A=. if H2FF14A!=0 & H2FF14A!=1
replace H2FF15A=. if H2FF15A!=0 & H2FF15A!=1
gen temp=0
forvalues i=11(1)15 {
replace temp=temp+1 if H2FF`i'A==.
}
gen femalefriend1quality=(H2FF11A+ H2FF12A+ H2FF13A+ H2FF14A+ H2FF15A)/(5-temp)
drop H2FF11A H2FF12A H2FF13A H2FF14A H2FF15A temp
**Second Female Friend**
replace H2FF11B=. if H2FF11B!=0 & H2FF11B!=1
replace H2FF12B=. if H2FF12B!=0 & H2FF12B!=1
replace H2FF13B=. if H2FF13B!=0 & H2FF13B!=1
replace H2FF14B=. if H2FF14B!=0 & H2FF14B!=1
replace H2FF15B=. if H2FF15B!=0 & H2FF15B!=1
gen temp=0
forvalues i=11(1)15 {
replace temp=temp+1 if H2FF`i'B==.
}
gen femalefriend2quality=(H2FF11B+ H2FF12B+ H2FF13B+ H2FF14B+ H2FF15B)/(5-temp)
drop H2FF11B H2FF12B H2FF13B H2FF14B H2FF15B temp
**Third Female Friend**
replace H2FF11C=. if H2FF11C!=0 & H2FF11C!=1
replace H2FF12C=. if H2FF12C!=0 & H2FF12C!=1
replace H2FF13C=. if H2FF13C!=0 & H2FF13C!=1
replace H2FF14C=. if H2FF14C!=0 & H2FF14C!=1
replace H2FF15C=. if H2FF15C!=0 & H2FF15C!=1
gen temp=0
forvalues i=11(1)15 {
replace temp=temp+1 if H2FF`i'C==.
}
gen femalefriend3quality=(H2FF11C+ H2FF12C+ H2FF13C+ H2FF14C+ H2FF15C)/(5-temp)
drop H2FF11C H2FF12C H2FF13C H2FF14C H2FF15C temp
**Fourth Female Friend**
replace H2FF11D=. if H2FF11D!=0 & H2FF11D!=1
replace H2FF12D=. if H2FF12D!=0 & H2FF12D!=1
replace H2FF13D=. if H2FF13D!=0 & H2FF13D!=1
replace H2FF14D=. if H2FF14D!=0 & H2FF14D!=1
replace H2FF15D=. if H2FF15D!=0 & H2FF15D!=1
gen temp=0
forvalues i=11(1)15 {
replace temp=temp+1 if H2FF`i'D==.
}
gen femalefriend4quality=(H2FF11D+ H2FF12D+ H2FF13D+ H2FF14D+ H2FF15D)/(5-temp)
drop H2FF11D H2FF12D H2FF13D H2FF14D H2FF15D temp
**Fifth Female Friend**
replace H2FF11E=. if H2FF11E!=0 & H2FF11E!=1
replace H2FF12E=. if H2FF12E!=0 & H2FF12E!=1
replace H2FF13E=. if H2FF13E!=0 & H2FF13E!=1
replace H2FF14E=. if H2FF14E!=0 & H2FF14E!=1
replace H2FF15E=. if H2FF15E!=0 & H2FF15E!=1
gen temp=0
forvalues i=11(1)15 {
replace temp=temp+1 if H2FF`i'E==.
}
gen femalefriend5quality=(H2FF11E+ H2FF12E+ H2FF13E+ H2FF14E+ H2FF15E)/(5-temp)
drop H2FF11E H2FF12E H2FF13E H2FF14E H2FF15E temp
**Only keep "best friend" quality**
gen bestmalefriendquality2=max(malefriend1quality,malefriend2quality,malefriend3quality,malefriend4quality,malefriend5quality)
drop malefriend1quality malefriend2quality malefriend3quality malefriend4quality malefriend5quality
gen bestfemalefriendquality2=max(femalefriend1quality,femalefriend2quality,femalefriend3quality,femalefriend4quality,femalefriend5quality)
drop femalefriend1quality femalefriend2quality femalefriend3quality femalefriend4quality femalefriend5quality

/* Wave */
gen wave2=2

/* Drop unused-unwanted variables*/
drop   H2GI6 H2GI9 H2DA7 H2DA8 H2DA9 H2DA10 H2ED7 H2ED8 H2ED9 H2ED10 ///
H2WP9 H2WP13 H2PF1 H2PF8 FR_FLAG2 H2MF4A H2MF5A H2MF6A H2MF7A ///
H2MF4B H2MF5B H2MF6B H2MF7B H2MF4C H2MF5C H2MF6C H2MF7C H2MF4D ///
H2MF5D H2MF6D H2MF7D H2MF4E H2MF5E H2MF6E H2MF7E H2FF4A H2FF5A ///
H2FF6A H2FF7A H2FF4B H2FF5B H2FF6B H2FF7B H2FF4C H2FF5C H2FF6C H2FF7C ///
H2FF4D H2FF5D H2FF6D H2FF7D H2FF4E H2FF5E H2FF6E H2FF7E H2RR2A H2IR1 ///
H2IR2 H2IR5 H2IR6 gender

/*Save prepared wave 2 data set and open wave 3*/
save w2, replace
clear all
use Wave3.dta

******************************
/////////////////////////////////////////////////////
***WAVE 3 PREPARATION***
///////////////////////////////////////////////////
****************************

/*Delete unwanted variables of Wave 1*/
keep AID BIO_SEX3 IMONTH3 IDAY3 IYEAR3 H3OD1M H3OD1Y H3WP19 ///
H3WP20 H3WP24 H3WP25 H3FS11 H3FS12 H3GH1 H3GH2 RRELNO H3DA4 ///
H3DA5 H3DA6 H3DA9 H3DA10 H3DA12 H3ED23 ///
H3DA15 H3WGT H3HGT_F H3HGT_I H3IR1 H3IR2 H3IR5

/*Rename Variables*/
rename BIO_SEX3 gender

/*Construct Age*/
gen birth=.
replace H3OD1Y=. if H3OD1Y==96
replace H3OD1M=. if H3OD1M==96
replace birth=H3OD1Y+((H3OD1M-0.5)/12)
gen inter=.
replace inter=IYEAR3+((IMONTH3)/12)+((IDAY3-1)/30.4)
gen age3=inter-birth
drop birth inter H3OD1Y H3OD1M IYEAR3 IMONTH3 IDAY3

/*Construct BMI [height in inches, weight in pounds]*/
replace H3WGT=. if H3WGT==996
replace H3WGT=331 if H3WGT==888
replace H3HGT_F=. if H3HGT_F==96 | H3HGT_F==98
replace H3HGT_I=. if H3HGT_I==96 | H3HGT_I==98
gen bmi3=.
replace bmi3=(703*H3WGT)/((H3HGT_F*12)+H3HGT_I)^2
drop H3WGT H3HGT_F H3HGT_I

/*Construct Physical Exercise Variable*/
replace H3DA9=. if H3DA9==96 | H3DA9==98
replace H3DA10=. if H3DA10==96 | H3DA10==98
replace H3DA12=. if H3DA12==96 | H3DA12==98
replace H3DA9=1 if H3DA9==1 | H3DA9==2
replace H3DA9=2 if H3DA9==3 | H3DA9==4
replace H3DA9=3 if H3DA9>=5
replace H3DA10=1 if H3DA10==1 | H3DA10==2
replace H3DA10=2 if H3DA10==3 | H3DA10==4
replace H3DA10=3 if H3DA10>=5
replace H3DA12=1 if H3DA12==1 | H3DA12==2
replace H3DA12=2 if H3DA12==3 | H3DA12==4
replace H3DA12=3 if H3DA12>=5
gen physical3= H3DA9+ H3DA10+ H3DA12
drop H3DA9 H3DA10 H3DA12

/*Construct Physical Condition Variable*/
rename H3GH1 health3
replace health3=. if health3 ==6 | health3 ==8

/* Weight Image */
rename H3GH2 weightimage3
replace weightimage3=. if weightimage3==98 | weightimage3==99

/* Still friends with High-School */
rename H3FS11 friendschool
replace friendschool=. if friendschool==95 | friendschool==97 | friendschool==98
rename friendschool friendschool

/* Friends or Family influence more */
rename H3FS12 friendsorfamily
replace friendsorfamily=. if friendsorfamily==5 | friendsorfamily==7 | friendsorfamily==8 | friendsorfamily==9

/* Wave */
gen wave3=3

/*Drop unwanted-unused variables*/
drop  H3WP19 H3WP20 H3WP24 H3WP25 H3ED23 RRELNO H3DA4 H3DA5 H3DA6 ///
H3DA15 H3IR1 H3IR2 H3IR5 gender

/*Save prepared wave 3 data set and open network dataset*/
save w3, replace
clear all
use Network.dta

********************************
/////////////////////////////////////////////////////////
***NETWORK PREPARATION***
////////////////////////////////////////////////////////
*******************************

/*Delete unwanted variables of Nework*/
keep AID ODGX2 IGDMEAN ESDEN

/* Rename Variables */
rename ODGX2 outdegree
label variable outdegree "Number of people responder nominates as friends"
rename IGDMEAN geomean
label variable geomean "Average path length between ego and egoÕs complete set of reachable alters"
rename ESDEN density
label variable density "Density of Ego-sent network"


/*Save prepared network data set and open wave1 prepared dataset*/
save net, replace
clear all
use w1.dta

***************************
////////////////////////////////////////////////
***MERGE, MAKE LONG***
////////////////////////////////////////////////
***************************

/*Merge*/
merge 1:1 AID using w2.dta
drop _merge
merge 1:1 AID using w3.dta
drop _merge
merge 1:1 AID using net.dta
drop _merge

/*Reshape to long*/
reshape long  age@ bestfemalefriendquality@ bestmalefriendquality@ ///
bmi@  health@ physical@ wave@ weightimage@, i(AID) j(wavein) 

************************************
//////////////////////////////////////////////////////////
***CONSTRUCT BMI VARIABLES***
/////////////////////////////////////////////////////////
**********************************

/*Categorize According To Age-Gender BMI. 3 variables are beeing constructed, bmi1 which follows exactly the official US categorisation
according to gender and age, bmi2 which changes the categorisation cut-off points of adults so that the sudden change when being 20 years ols is vanished
and bmi3 that changes categorisation cut-off points for children again for the same reason.*/
gen temp=.
forvalues i=11(0.5)20 {
replace temp=`i' if age>`i'-0.5 & age<=`i'
}
replace temp=99 if age>20

**Boys**
gen sbmi=.
gen sbmi3=.
replace sbmi=1 if temp==11.5 & gender==1 & bmi<14.8
replace sbmi=1 if temp==12 & gender==1 & bmi<15
replace sbmi=1 if temp==12.5 & gender==1 & bmi<15.2
replace sbmi=1 if temp==13 & gender==1 & bmi<15.4
replace sbmi=1 if temp==13.5 & gender==1 & bmi<15.7
replace sbmi=1 if temp==14 & gender==1 & bmi<16
replace sbmi=1 if temp==14.5 & gender==1 & bmi<16.3
replace sbmi=1 if temp==15 & gender==1 & bmi<16.5
replace sbmi=1 if temp==15.5 & gender==1 & bmi<16.8
replace sbmi=1 if temp==16 & gender==1 & bmi<17.1
replace sbmi=1 if temp==16.5 & gender==1 & bmi<17.4
replace sbmi=1 if temp==17 & gender==1 & bmi<17.7
replace sbmi=1 if temp==17.5 & gender==1 & bmi<18
replace sbmi=1 if temp==18 & gender==1 & bmi<18.2
replace sbmi=1 if temp==18.5 & gender==1 & bmi<18.5
replace sbmi=1 if temp==19 & gender==1 & bmi<18.7
replace sbmi=1 if temp==19.5 & gender==1 & bmi<18.9
replace sbmi=1 if temp==20 & gender==1 & bmi<19.1
replace sbmi=2 if temp==11.5 & gender==1 & bmi>=14.8 & bmi<20.5
replace sbmi=2 if temp==12 & gender==1 & bmi>=15 & bmi<21
replace sbmi=2 if temp==12.5 & gender==1 & bmi>=15.2 & bmi<21.4
replace sbmi=2 if temp==13 & gender==1 & bmi>=15.4 & bmi<21.8
replace sbmi=2 if temp==13.5 & gender==1 & bmi>=15.7 & bmi<22.3
replace sbmi=2 if temp==14 & gender==1 & bmi>=16 & bmi<22.6
replace sbmi=2 if temp==14.5 & gender==1 & bmi>=16.3 & bmi<23
replace sbmi=2 if temp==15 & gender==1 & bmi>=16.5 & bmi<23.4
replace sbmi=2 if temp==15.5 & gender==1 & bmi>=16.8 & bmi<23.8
replace sbmi=2 if temp==16 & gender==1 & bmi>=17.1 & bmi<24.2
replace sbmi=2 if temp==16.5 & gender==1 & bmi>=17.4 & bmi<24.5
replace sbmi=2 if temp==17 & gender==1 & bmi>=17.7 & bmi<24.9
replace sbmi=2 if temp==17.5 & gender==1 & bmi>=18 & bmi<25.3
replace sbmi=2 if temp==18 & gender==1 & bmi>=18.2 & bmi<25.6
replace sbmi=2 if temp==18.5 & gender==1 & bmi>=18.5 & bmi<26
replace sbmi=2 if temp==19 & gender==1 & bmi>=18.7 & bmi<26.3
replace sbmi=2 if temp==19.5 & gender==1 & bmi>=18.9 & bmi<26.7
replace sbmi=2 if temp==20 & gender==1 & bmi>=19.1 & bmi<27
replace sbmi=3 if temp==11.5 & gender==1 & bmi>=20.5 & bmi<23.5
replace sbmi=3 if temp==12 & gender==1 & bmi>= 21 & bmi<24.2
replace sbmi=3 if temp==12.5 & gender==1 & bmi>= 21.4 & bmi<24.7
replace sbmi=3 if temp==13 & gender==1 & bmi>= 21.8 & bmi<25.2
replace sbmi=3 if temp==13.5 & gender==1 & bmi>=22.3 & bmi<25.6
replace sbmi=3 if temp==14 & gender==1 & bmi>= 22.6 & bmi<26
replace sbmi=3 if temp==14.5 & gender==1 & bmi>= 23 & bmi<26.5
replace sbmi=3 if temp==15 & gender==1 & bmi>= 23.4 & bmi<26.8
replace sbmi=3 if temp==15.5 & gender==1 & bmi>= 23.8 & bmi<27.2
replace sbmi=3 if temp==16 & gender==1 & bmi>= 24.2 & bmi<27.5
replace sbmi=3 if temp==16.5 & gender==1 & bmi>= 24.5 & bmi<27.9
replace sbmi=3 if temp==17 & gender==1 & bmi>= 24.9 & bmi<28.3
replace sbmi=3 if temp==17.5 & gender==1 & bmi>= 25.3 & bmi<28.5
replace sbmi=3 if temp==18 & gender==1 & bmi>= 25.6 & bmi<28.9
replace sbmi=3 if temp==18.5 & gender==1 & bmi>= 26 & bmi<29.3
replace sbmi=3 if temp==19 & gender==1 & bmi>= 26.3 & bmi<29.7
replace sbmi=3 if temp==19.5 & gender==1 & bmi>= 26.7 & bmi<30.1
replace sbmi=3 if temp==20 & gender==1 & bmi>= 27 & bmi<30.6
replace sbmi=4 if temp==11.5 & gender==1 & bmi>=23.5
replace sbmi=4 if temp==12 & gender==1 & bmi>=24.2
replace sbmi=4 if temp==12.5 & gender==1 & bmi>=24.7
replace sbmi=4 if temp==13 & gender==1 & bmi>=25.2
replace sbmi=4 if temp==13.5 & gender==1 & bmi>=25.6
replace sbmi=4 if temp==14 & gender==1 & bmi>=26
replace sbmi=4 if temp==14.5 & gender==1 & bmi>=26.5
replace sbmi=4 if temp==15 & gender==1 & bmi>=26.8
replace sbmi=4 if temp==15.5 & gender==1 & bmi>=27.2
replace sbmi=4 if temp==16 & gender==1 & bmi>=27.5
replace sbmi=4 if temp==16.5 & gender==1 & bmi>=27.9
replace sbmi=4 if temp==17 & gender==1 & bmi>=28.3
replace sbmi=4 if temp==17.5 & gender==1 & bmi>=28.5
replace sbmi=4 if temp==18 & gender==1 & bmi>=28.9
replace sbmi=4 if temp==18.5 & gender==1 & bmi>=29.3
replace sbmi=4 if temp==19 & gender==1 & bmi>=29.7
replace sbmi=4 if temp==19.5 & gender==1 & bmi>=30.1
replace sbmi=4 if temp==20 & gender==1 & bmi>=30.6
replace sbmi3=1 if temp==11.5 & gender==1 & bmi<14.38
replace sbmi3=1 if temp==12 & gender==1 & bmi<14.57
replace sbmi3=1 if temp==12.5 & gender==1 & bmi<14.75
replace sbmi3=1 if temp==13 & gender==1 & bmi<14.92
replace sbmi3=1 if temp==13.5 & gender==1 & bmi<15.22
replace sbmi3=1 if temp==14 & gender==1 & bmi<15.52
replace sbmi3=1 if temp==14.5 & gender==1 & bmi<15.81
replace sbmi3=1 if temp==15 & gender==1 & bmi<15.99
replace sbmi3=1 if temp==15.5 & gender==1 & bmi<16.28
replace sbmi3=1 if temp==16 & gender==1 & bmi<16.58
replace sbmi3=1 if temp==16.5 & gender==1 & bmi<16.86
replace sbmi3=1 if temp==17 & gender==1 & bmi<17.16
replace sbmi3=1 if temp==17.5 & gender==1 & bmi<17.45
replace sbmi3=1 if temp==18 & gender==1 & bmi<17.63
replace sbmi3=1 if temp==18.5 & gender==1 & bmi<17.93
replace sbmi3=1 if temp==19 & gender==1 & bmi<18.12
replace sbmi3=1 if temp==19.5 & gender==1 & bmi<18.32
replace sbmi3=1 if temp==20 & gender==1 & bmi<18.5
replace sbmi3=2 if temp==11.5 & gender==1 & bmi>=14.38 & bmi<19
replace sbmi3=2 if temp==12 & gender==1 & bmi>=14.57 & bmi<19.4
replace sbmi3=2 if temp==12.5 & gender==1 & bmi>=14.75 & bmi<19.75
replace sbmi3=2 if temp==13 & gender==1 & bmi>=14.92 & bmi<20.15
replace sbmi3=2 if temp==13.5 & gender==1 & bmi>=15.22 & bmi<20.55
replace sbmi3=2 if temp==14 & gender==1 & bmi>=15.52 & bmi<20.85
replace sbmi3=2 if temp==14.5 & gender==1 & bmi>=15.81 & bmi<21.25
replace sbmi3=2 if temp==15 & gender==1 & bmi>=15.99 & bmi<21.60
replace sbmi3=2 if temp==15.5 & gender==1 & bmi>=16.28 & bmi<22
replace sbmi3=2 if temp==16 & gender==1 & bmi>=16.58 & bmi<22.35
replace sbmi3=2 if temp==16.5 & gender==1 & bmi>=16.86 & bmi<22.7
replace sbmi3=2 if temp==17 & gender==1 & bmi>=17.16 & bmi<23.05
replace sbmi3=2 if temp==17.5 & gender==1 & bmi>=17.45 & bmi<23.45
replace sbmi3=2 if temp==18 & gender==1 & bmi>=17.63 & bmi<23.75
replace sbmi3=2 if temp==18.5 & gender==1 & bmi>=17.93 & bmi<24.1
replace sbmi3=2 if temp==19 & gender==1 & bmi>=18.12 & bmi<24.4
replace sbmi3=2 if temp==19.5 & gender==1 & bmi>=18.32 & bmi<24.7
replace sbmi3=2 if temp==20 & gender==1 & bmi>=18.5 & bmi<25
replace sbmi3=3 if temp==11.5 & gender==1 & bmi>=19 & bmi<23.03
replace sbmi3=3 if temp==12 & gender==1 & bmi>= 19.4 & bmi<23.69
replace sbmi3=3 if temp==12.5 & gender==1 & bmi>= 19.75 & bmi<24.18
replace sbmi3=3 if temp==13 & gender==1 & bmi>= 20.15 & bmi<24.67
replace sbmi3=3 if temp==13.5 & gender==1 & bmi>=20.55 & bmi<25.06
replace sbmi3=3 if temp==14 & gender==1 & bmi>= 20.85 & bmi<25.46
replace sbmi3=3 if temp==14.5 & gender==1 & bmi>= 21.25 & bmi<25.95
replace sbmi3=3 if temp==15 & gender==1 & bmi>= 21.60 & bmi<26.25
replace sbmi3=3 if temp==15.5 & gender==1 & bmi>= 22 & bmi<26.65
replace sbmi3=3 if temp==16 & gender==1 & bmi>= 22.35 & bmi<26.95
replace sbmi3=3 if temp==16.5 & gender==1 & bmi>= 22.7 & bmi<27.35
replace sbmi3=3 if temp==17 & gender==1 & bmi>= 23.05 & bmi<27.74
replace sbmi3=3 if temp==17.5 & gender==1 & bmi>= 23.45 & bmi<27.96
replace sbmi3=3 if temp==18 & gender==1 & bmi>= 23.75 & bmi<28.35
replace sbmi3=3 if temp==18.5 & gender==1 & bmi>= 24.1 & bmi<28.74
replace sbmi3=3 if temp==19 & gender==1 & bmi>= 24.4 & bmi<29.13
replace sbmi3=3 if temp==19.5 & gender==1 & bmi>= 24.7 & bmi<29.52
replace sbmi3=3 if temp==20 & gender==1 & bmi>= 25 & bmi<30
replace sbmi3=4 if temp==11.5 & gender==1 & bmi>=23.03
replace sbmi3=4 if temp==12 & gender==1 & bmi>=23.69
replace sbmi3=4 if temp==12.5 & gender==1 & bmi>=24.18
replace sbmi3=4 if temp==13 & gender==1 & bmi>=24.67
replace sbmi3=4 if temp==13.5 & gender==1 & bmi>=25.06
replace sbmi3=4 if temp==14 & gender==1 & bmi>=25.46
replace sbmi3=4 if temp==14.5 & gender==1 & bmi>=25.95
replace sbmi3=4 if temp==15 & gender==1 & bmi>=26.25
replace sbmi3=4 if temp==15.5 & gender==1 & bmi>=26.65
replace sbmi3=4 if temp==16 & gender==1 & bmi>=26.95
replace sbmi3=4 if temp==16.5 & gender==1 & bmi>=27.35
replace sbmi3=4 if temp==17 & gender==1 & bmi>=27.74
replace sbmi3=4 if temp==17.5 & gender==1 & bmi>=27.96
replace sbmi3=4 if temp==18 & gender==1 & bmi>=28.35
replace sbmi3=4 if temp==18.5 & gender==1 & bmi>=28.74
replace sbmi3=4 if temp==19 & gender==1 & bmi>=29.13
replace sbmi3=4 if temp==19.5 & gender==1 & bmi>=29.52
replace sbmi3=4 if temp==20 & gender==1 & bmi>=30
**Girls**
replace sbmi=1 if temp==11.5 & gender==2 & bmi<14.6
replace sbmi=1 if temp==12 & gender==2 & bmi<14.8
replace sbmi=1 if temp==12.5 & gender==2 & bmi<15.1
replace sbmi=1 if temp==13 & gender==2 & bmi<15.3
replace sbmi=1 if temp==13.5 & gender==2 & bmi<15.5
replace sbmi=1 if temp==14 & gender==2 & bmi<15.8
replace sbmi=1 if temp==14.5 & gender==2 & bmi<16
replace sbmi=1 if temp==15 & gender==2 & bmi<16.3
replace sbmi=1 if temp==15.5 & gender==2 & bmi<16.5
replace sbmi=1 if temp==16 & gender==2 & bmi<16.8
replace sbmi=1 if temp==16.5 & gender==2 & bmi<17
replace sbmi=1 if temp==17 & gender==2 & bmi<17.2
replace sbmi=1 if temp==17.5 & gender==2 & bmi<17.4
replace sbmi=1 if temp==18 & gender==2 & bmi<17.6
replace sbmi=1 if temp==18.5 & gender==2 & bmi<17.7
replace sbmi=1 if temp==19 & gender==2 & bmi<17.8
replace sbmi=1 if temp==19.5 & gender==2 & bmi<17.8
replace sbmi=1 if temp==20 & gender==2 & bmi<17.8
replace sbmi=2 if temp==11.5 & gender==2 & bmi>=14.6 & bmi<21.3
replace sbmi=2 if temp==12 & gender==2 & bmi>=14.8 & bmi<21.7
replace sbmi=2 if temp==12.5 & gender==2 & bmi>=15.1 & bmi<22.1
replace sbmi=2 if temp==13 & gender==2 & bmi>=15.3 & bmi<22.5
replace sbmi=2 if temp==13.5 & gender==2 & bmi>=15.5 & bmi<22.9
replace sbmi=2 if temp==14 & gender==2 & bmi>=15.8 & bmi<23.3
replace sbmi=2 if temp==14.5 & gender==2 & bmi>=16 & bmi<23.7
replace sbmi=2 if temp==15 & gender==2 & bmi>=16.3 & bmi<24
replace sbmi=2 if temp==15.5 & gender==2 & bmi>=16.5 & bmi<24.4
replace sbmi=2 if temp==16 & gender==2 & bmi>=16.8 & bmi<24.6
replace sbmi=2 if temp==16.5 & gender==2 & bmi>=17 & bmi<24.9
replace sbmi=2 if temp==17 & gender==2 & bmi>=17.2 & bmi<25.2
replace sbmi=2 if temp==17.5 & gender==2 & bmi>=17.4 & bmi<25.5
replace sbmi=2 if temp==18 & gender==2 & bmi>=17.6 & bmi<25.7
replace sbmi=2 if temp==18.5 & gender==2 & bmi>=17.7 & bmi<25.9
replace sbmi=2 if temp==19 & gender==2 & bmi>=17.8 & bmi<26.1
replace sbmi=2 if temp==19.5 & gender==2 & bmi>=17.8 & bmi<26.3
replace sbmi=2 if temp==20 & gender==2 & bmi>=17.8 & bmi<26.5
replace sbmi=3 if temp==11.5 & gender==2 & bmi>=21.3 & bmi<24.7
replace sbmi=3 if temp==12 & gender==2 & bmi>=21.7 & bmi<25.2
replace sbmi=3 if temp==12.5 & gender==2 & bmi>=22.1 & bmi<25.8
replace sbmi=3 if temp==13 & gender==2 & bmi>=22.5 & bmi<26.2
replace sbmi=3 if temp==13.5 & gender==2 & bmi>=22.9 & bmi<26.8
replace sbmi=3 if temp==14 & gender==2 & bmi>=23.3 & bmi<27.2
replace sbmi=3 if temp==14.5 & gender==2 & bmi>=23.7 & bmi<27.7
replace sbmi=3 if temp==15 & gender==2 & bmi>=24 & bmi<28.1
replace sbmi=3 if temp==15.5 & gender==2 & bmi>=24.4 & bmi<28.5
replace sbmi=3 if temp==16 & gender==2 & bmi>=24.6 & bmi<28.9
replace sbmi=3 if temp==16.5 & gender==2 & bmi>=24.9 & bmi<29.3
replace sbmi=3 if temp==17 & gender==2 & bmi>=25.2 & bmi<29.6
replace sbmi=3 if temp==17.5 & gender==2 & bmi>=25.5 & bmi<29.9
replace sbmi=3 if temp==18 & gender==2 & bmi>=25.7 & bmi<30.3
replace sbmi=3 if temp==18.5 & gender==2 & bmi>=25.9 & bmi<30.6
replace sbmi=3 if temp==19 & gender==2 & bmi>=26.1 & bmi<31
replace sbmi=3 if temp==19.5 & gender==2 & bmi>=26.3 & bmi<31.4
replace sbmi=3 if temp==20 & gender==2 & bmi>= 26.5 & bmi<31.7
replace sbmi=4 if temp==11.5 & gender==2 & bmi>=24.7
replace sbmi=4 if temp==12 & gender==2 & bmi>=25.2
replace sbmi=4 if temp==12.5 & gender==2 & bmi>=25.8
replace sbmi=4 if temp==13 & gender==2 & bmi>=26.2
replace sbmi=4 if temp==13.5 & gender==2 & bmi>=26.8
replace sbmi=4 if temp==14 & gender==2 & bmi>=27.2
replace sbmi=4 if temp==14.5 & gender==2 & bmi>=27.7
replace sbmi=4 if temp==15 & gender==2 & bmi>=28.1
replace sbmi=4 if temp==15.5 & gender==2 & bmi>=28.5
replace sbmi=4 if temp==16 & gender==2 & bmi>=28.9
replace sbmi=4 if temp==16.5 & gender==2 & bmi>=29.3
replace sbmi=4 if temp==17 & gender==2 & bmi>=29.6
replace sbmi=4 if temp==17.5 & gender==2 & bmi>=29.9
replace sbmi=4 if temp==18 & gender==2 & bmi>=30.3
replace sbmi=4 if temp==18.5 & gender==2 & bmi>=30.6
replace sbmi=4 if temp==19 & gender==2 & bmi>=31
replace sbmi=4 if temp==19.5 & gender==2 & bmi>=31.4
replace sbmi=4 if temp==20 & gender==2 & bmi>=31.7
replace sbmi3=1 if temp==11.5 & gender==2 & bmi<15.16
replace sbmi3=1 if temp==12 & gender==2 & bmi<15.39
replace sbmi3=1 if temp==12.5 & gender==2 & bmi<15.69
replace sbmi3=1 if temp==13 & gender==2 & bmi<15.91
replace sbmi3=1 if temp==13.5 & gender==2 & bmi<16.13
replace sbmi3=1 if temp==14 & gender==2 & bmi<16.43
replace sbmi3=1 if temp==14.5 & gender==2 & bmi<16.65
replace sbmi3=1 if temp==15 & gender==2 & bmi<16.95
replace sbmi3=1 if temp==15.5 & gender==2 & bmi<17.16
replace sbmi3=1 if temp==16 & gender==2 & bmi<17.45
replace sbmi3=1 if temp==16.5 & gender==2 & bmi<17.66
replace sbmi3=1 if temp==17 & gender==2 & bmi<17.86
replace sbmi3=1 if temp==17.5 & gender==2 & bmi<18.06
replace sbmi3=1 if temp==18 & gender==2 & bmi<18.26
replace sbmi3=1 if temp==18.5 & gender==2 & bmi<18.36
replace sbmi3=1 if temp==19 & gender==2 & bmi<18.48
replace sbmi3=1 if temp==19.5 & gender==2 & bmi<18.48
replace sbmi3=1 if temp==20 & gender==2 & bmi<18.5
replace sbmi3=2 if temp==11.5 & gender==2 & bmi>=15.16 & bmi<20.18
replace sbmi3=2 if temp==12 & gender==2 & bmi>=15.39 & bmi<20.58
replace sbmi3=2 if temp==12.5 & gender==2 & bmi>=15.69 & bmi<20.94
replace sbmi3=2 if temp==13 & gender==2 & bmi>=15.91 & bmi<21.31
replace sbmi3=2 if temp==13.5 & gender==2 & bmi>=16.13 & bmi<21.68
replace sbmi3=2 if temp==14 & gender==2 & bmi>=16.43 & bmi<22.05
replace sbmi3=2 if temp==14.5 & gender==2 & bmi>=16.65 & bmi<22.42
replace sbmi3=2 if temp==15 & gender==2 & bmi>=16.95 & bmi<22.72
replace sbmi3=2 if temp==15.5 & gender==2 & bmi>=17.16 & bmi<23.09
replace sbmi3=2 if temp==16 & gender==2 & bmi>=17.45 & bmi<23.29
replace sbmi3=2 if temp==16.5 & gender==2 & bmi>=17.66 & bmi<23.59
replace sbmi3=2 if temp==17 & gender==2 & bmi>=17.86 & bmi<23.86
replace sbmi3=2 if temp==17.5 & gender==2 & bmi>=18.06 & bmi<24.13
replace sbmi3=2 if temp==18 & gender==2 & bmi>=18.26 & bmi<24.33
replace sbmi3=2 if temp==18.5 & gender==2 & bmi>=18.36 & bmi<24.49
replace sbmi3=2 if temp==19 & gender==2 & bmi>=18.48 & bmi<24.69
replace sbmi3=2 if temp==19.5 & gender==2 & bmi>=18.48 & bmi<24.83
replace sbmi3=2 if temp==20 & gender==2 & bmi>=18.5 & bmi<25
replace sbmi3=3 if temp==11.5 & gender==2 & bmi>=20.18 & bmi<23.51
replace sbmi3=3 if temp==12 & gender==2 & bmi>=20.58 & bmi<23.99
replace sbmi3=3 if temp==12.5 & gender==2 & bmi>=20.94 & bmi<24.54
replace sbmi3=3 if temp==13 & gender==2 & bmi>=21.31 & bmi<24.93
replace sbmi3=3 if temp==13.5 & gender==2 & bmi>=21.68 & bmi<25.47
replace sbmi3=3 if temp==14 & gender==2 & bmi>=22.05 & bmi<25.86
replace sbmi3=3 if temp==14.5 & gender==2 & bmi>=22.42 & bmi<26.32
replace sbmi3=3 if temp==15 & gender==2 & bmi>=22.72 & bmi<26.71
replace sbmi3=3 if temp==15.5 & gender==2 & bmi>=23.09 & bmi<27.09
replace sbmi3=3 if temp==16 & gender==2 & bmi>=23.29 & bmi<27.46
replace sbmi3=3 if temp==16.5 & gender==2 & bmi>=23.59 & bmi<27.84
replace sbmi3=3 if temp==17 & gender==2 & bmi>=23.86 & bmi<28.12
replace sbmi3=3 if temp==17.5 & gender==2 & bmi>=24.13 & bmi<28.40
replace sbmi3=3 if temp==18 & gender==2 & bmi>=24.33 & bmi<28.77
replace sbmi3=3 if temp==18.5 & gender==2 & bmi>=24.49 & bmi<29.04
replace sbmi3=3 if temp==19 & gender==2 & bmi>=24.69 & bmi<29.40
replace sbmi3=3 if temp==19.5 & gender==2 & bmi>=24.83 & bmi<29.73
replace sbmi3=3 if temp==20 & gender==2 & bmi>= 25 & bmi<30
replace sbmi3=4 if temp==11.5 & gender==2 & bmi>=23.51
replace sbmi3=4 if temp==12 & gender==2 & bmi>=23.99
replace sbmi3=4 if temp==12.5 & gender==2 & bmi>=24.54
replace sbmi3=4 if temp==13 & gender==2 & bmi>=24.93
replace sbmi3=4 if temp==13.5 & gender==2 & bmi>=25.47
replace sbmi3=4 if temp==14 & gender==2 & bmi>=25.86
replace sbmi3=4 if temp==14.5 & gender==2 & bmi>=26.32
replace sbmi3=4 if temp==15 & gender==2 & bmi>=26.71
replace sbmi3=4 if temp==15.5 & gender==2 & bmi>=27.09
replace sbmi3=4 if temp==16 & gender==2 & bmi>=27.46
replace sbmi3=4 if temp==16.5 & gender==2 & bmi>=27.84
replace sbmi3=4 if temp==17 & gender==2 & bmi>=28.12
replace sbmi3=4 if temp==17.5 & gender==2 & bmi>=28.40
replace sbmi3=4 if temp==18 & gender==2 & bmi>=28.77
replace sbmi3=4 if temp==18.5 & gender==2 & bmi>=29.04
replace sbmi3=4 if temp==19 & gender==2 & bmi>=29.40
replace sbmi3=4 if temp==19.5 & gender==2 & bmi>=29.73
replace sbmi3=4 if temp==20 & gender==2 & bmi>=30
gen sbmi2=sbmi
**Adults**
replace sbmi=1 if temp==99 & bmi<18.5 
replace sbmi=2 if temp==99 & bmi>=18.5 & bmi<25
replace sbmi=3 if temp==99 & bmi>=25 & bmi<30
replace sbmi=4 if temp==99 & bmi>=30
replace sbmi3=sbmi if temp==99
replace sbmi2=1 if temp==99 & bmi<17.8 & gender==2
replace sbmi2=2 if temp==99 & bmi>=17.8 & bmi<26.5 & gender==2
replace sbmi2=3 if temp==99 & bmi>=26.5 & bmi<31.7 & gender==2
replace sbmi2=4 if temp==99 & bmi>=31.7 & gender==2
replace sbmi2=1 if temp==99 & bmi<19.1 & gender==1
replace sbmi2=2 if temp==99 & bmi>=19.1 & bmi<27 & gender==1
replace sbmi2=3 if temp==99 & bmi>=27 & bmi<30.6 & gender==1
replace sbmi2=4 if temp==99 & bmi>=30.6 & gender==1
**Finalising**
drop temp bmi
rename sbmi bmi1
rename sbmi2 bmi2
rename sbmi3 bmi3
label define bmi 1 "Underweight" 2 "Normal" 3 "Overweight" 4 "Obese"
label values bmi1 bmi
label values bmi2 bmi
label values bmi3 bmi

**************************
////////////////////////////////////////////
***RENAME, LABEL ETC***
////////////////////////////////////////////
**************************

/*Rename, add labels*/
encode AID, generate(id)
label variable id "Responder's id"
label values id clear
drop AID
label variable age "Age of Responder"
label variable bestmalefriendquality "Best Quality of Male Friends [W1-W2]"
label variable bestfemalefriendquality "Best Quality of Female Friends [W1-W2]"
label variable bmi1 "Body Mass Index Categorisation"
label variable bmi2 "Body Mass Index [Alternative definition 1]"
label variable bmi3 "Body Mass Index [Alternative definition 2]"
label variable friendschool "Whether still friends with school friends [W3]"
label variable friendsorfamily "Friends or Family a bigger influence [W3]"
label variable gender "Gender [Interviewer submitted] [W1]"
label variable health "Health Condition [Self-submitted]"
label variable physical "Physical Activity"
label variable wavein "Wave indicator"
label variable weightimage "Subjective Categorisation"
drop wave
rename wavein wave
gen age2=age^2
label variable age2 "Square of Age"
recode gender (1=0) (2=1)
label define sex 1 "Female" 0 "Male"
label values gender sex

**************************
////////////////////////////////////////////
***PROBIT DEPENDENT VARIABLE***
////////////////////////////////////////////
**************************
/*Create a binomial variable to be used in probit model and regroup age variable*/
gen weighttemp=weightimage
/*Combine very underweight and underweight weight images in one since this is how bmi is coded.
Note that weighttemp is coded so that for example 2=underweight while 2=normal in bmi variable*/
replace weighttemp=2 if weighttemp==1 
gen misperception=0
replace misperception=1 if weighttemp==2 & (bmi1==2 | bmi1==3 | bmi1==4)
replace misperception=1 if weighttemp==3 & (bmi1==1 | bmi1==3 | bmi1==4)
replace misperception=1 if weighttemp==4 & (bmi1==1 | bmi1==2 | bmi1==4)
replace misperception=1 if weighttemp==5 & (bmi1==1 | bmi1==2 | bmi1==3)
gen misperception2=0
replace misperception2=1 if weighttemp==2 & (bmi2==2 | bmi2==3 | bmi2==4)
replace misperception2=1 if weighttemp==3 & (bmi2==1 | bmi2==3 | bmi2==4)
replace misperception2=1 if weighttemp==4 & (bmi2==1 | bmi2==2 | bmi2==4)
replace misperception2=1 if weighttemp==5 & (bmi2==1 | bmi2==2 | bmi2==3)
gen misperception3=0
replace misperception3=1 if weighttemp==2 & (bmi3==2 | bmi3==3 | bmi3==4)
replace misperception3=1 if weighttemp==3 & (bmi3==1 | bmi3==3 | bmi3==4)
replace misperception3=1 if weighttemp==4 & (bmi3==1 | bmi3==2 | bmi3==4)
replace misperception3=1 if weighttemp==5 & (bmi3==1 | bmi3==2 | bmi3==3)
label variable misperception "Responder is misperceiving his weight (BMI1)"
label variable misperception2 "Responder is misperceiving his weight (BMI2)"
label variable misperception3 "Responder is misperceiving his weight (BMI3)"
label define yesno 1 "Yes" 0 "No"
label values misperception yesno
label values misperception2 yesno
label values misperception3 yesno
drop weighttemp
gen groupage=.
replace groupage=1 if age<14
replace groupage=2 if age>=14 & age<17
replace groupage=3 if age>=17 & age<20
replace groupage=4 if age>=20 & age<23
replace groupage=5 if age>=23 & age<26
replace groupage=6 if age>=26
gen groupage2=groupage^2
label variable groupage "Grouped variable of age"
label define age 1 "<14" 2 "14-17" 3 "17-20" 4 "20-23" 5 "23-26" 6 "26+"
label values groupage age
label variable groupage2 "Grouped variable of age squared"

/*Save prepared data version*/
save data, replace

******************************
///////////////////////////////////////////////////
***DESCRIPTIVE STATISTICS***
//////////////////////////////////////////////////
******************************

/*Make a graph showing the bmi categories percentages accorging to age. Drop first 2 and
last 2 grouped points in graph since there are very few observations*/
gen _underweight1=.
gen _average1=.
gen _overweight1=.
gen _obese1=.
gen _underweight2=.
gen _average2=.
gen _overweight2=.
gen _obese2=.
gen _underweight3=.
gen _average3=.
gen _overweight3=.
gen _obese3=.
gen Age=.
forvalues i=1(1)18 {
replace Age =`i'+10 in `i'
}
forvalues i=3(1)16 {
summ bmi1 if age>=`i'+10 & age<`i'+11 & bmi1==1
replace _underweight1 =r(N) in `i'
summ bmi1 if age>=`i'+10 & age<`i'+11 & bmi1==2
replace _average1 =r(N) in `i'
summ bmi1 if age>=`i'+10 & age<`i'+11 & bmi1==3
replace _overweight1 =r(N) in `i'
summ bmi1 if age>=`i'+10 & age<`i'+11 & bmi1==4
replace _obese1 =r(N) in `i'
summ bmi2 if age>=`i'+10 & age<`i'+11 & bmi2==1
replace _underweight2 =r(N) in `i'
summ bmi2 if age>=`i'+10 & age<`i'+11 & bmi2==2
replace _average2 =r(N) in `i'
summ bmi2 if age>=`i'+10 & age<`i'+11 & bmi2==3
replace _overweight2 =r(N) in `i'
summ bmi2 if age>=`i'+10 & age<`i'+11 & bmi2==4
replace _obese2 =r(N) in `i'
summ bmi3 if age>=`i'+10 & age<`i'+11 & bmi3==1
replace _underweight3 =r(N) in `i'
summ bmi3 if age>=`i'+10 & age<`i'+11 & bmi3==2
replace _average3 =r(N) in `i'
summ bmi3 if age>=`i'+10 & age<`i'+11 & bmi3==3
replace _overweight3 =r(N) in `i'
summ bmi3 if age>=`i'+10 & age<`i'+11 & bmi3==4
replace _obese3 =r(N) in `i'
}
gen temp1=_underweight1+ _average1 +_overweight1+ _obese1
gen temp2=_underweight2+ _average2 +_overweight2+ _obese2
gen temp3=_underweight3+ _average3 +_overweight3+ _obese3
gen underweight1= 100*_underweight1/temp1
gen average1= 100*_average1/temp1
gen overweight1= 100*_overweight1/temp1
gen obese1= 100*_obese1/temp1
gen underweight2= 100*_underweight2/temp2
gen average2= 100*_average2/temp2
gen overweight2= 100*_overweight2/temp2
gen obese2= 100*_obese2/temp2
gen underweight3= 100*_underweight3/temp3
gen average3= 100*_average3/temp3
gen overweight3= 100*_overweight3/temp3
gen obese3= 100*_obese3/temp3
label variable underweight1 "% of underweight [Obj.]"
label variable average1 "% of average [Obj.]"
label variable overweight1 "% of overweight [Obj.]"
label variable obese1 "% of obese [Obj.]"
label variable underweight2 "% of underweight [Obj.] (Alt. def. 1)"
label variable average2 "% of average [Obj.] (Alt. def. 1)"
label variable overweight2 "% of overweight [Obj.] (Alt. def. 1)"
label variable obese2 "% of obese [Obj.] (Alt. def. 1)"
label variable underweight3 "% of underweight [Obj.] (Alt. def. 2)"
label variable average3 "% of average [Obj.] (Alt. def. 2)"
label variable overweight3 "% of overweight [Obj.] (Alt. def. 2)"
label variable obese3 "% of obese [Obj.] (Alt. def. 2)"
twoway connected underweight1 average1 overweight1 obese1 Age
graph export bmi1_shares.eps , replace
twoway connected underweight2 average2 overweight2 obese2 Age
graph export bmi2_shares.eps , replace
twoway connected underweight3 average3 overweight3 obese3 Age
graph export bmi3_shares.eps , replace
drop temp1 _underweight1 _average1 _overweight1 _obese1 temp2 _underweight2 ///
_average2 _overweight2 _obese2 temp3 _underweight3 _average3 _overweight3 _obese3
/*Make a graph showing the weight opinion categories percentages according to age. Again,
drop first and last 2 observations */
gen _very_underweight1=.
gen _underweight1_=.
gen _average1_=.
gen _overweight1_=.
gen _very_overweight1 =.
forvalues i=3(1)16 {
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==1
replace _very_underweight1 =r(N) in `i'
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==2
replace _underweight1_ =r(N) in `i'
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==3
replace _average1_ =r(N) in `i'
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==4
replace _overweight1_ =r(N) in `i'
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==5
replace _very_overweight1 =r(N) in `i'
}
gen temp= _very_underweight1 + _underweight1_ + _average1_ + _overweight1_+ _very_overweight1
gen very_underweight1= 100* _very_underweight1/temp
gen underweight1_ = 100* _underweight1_/temp
gen average1_= 100* _average1_/temp
gen overweight1_ = 100* _overweight1_/temp
gen very_overweight1 = 100* _very_overweight1/temp
label variable very_underweight1 "% of very underweight [Subj.]"
label variable underweight1_ "% of underweight [Subj.]"
label variable average1_ "% of average [Subj.]"
label variable overweight1_ "% of overweight [Subj.]"
label variable very_overweight1 "% of very overweight [Subj.]"
twoway connected very_underweight1  underweight1_ average1_  overweight1_ very_overweight1 Age
drop temp _very_underweight1 _underweight1_ _average1_ _overweight1_ _very_overweight1
graph export weightimage_shares.eps , replace
/*Now graph average1-subjective against average1-objective*/
twoway connected  average1_ average1 Age
graph export extra1.eps , replace
twoway connected  average1_ average2 Age
graph export extra2.eps , replace
twoway connected  average1_ average3 Age
graph export extra3.eps , replace
drop very_underweight1 very_overweight1  underweight1_ overweight1_  ///
average1_  Age average1 obese1 underweight1 overweight1 average2 obese2 underweight2 overweight2 ///
average3 obese3 underweight3 overweight3

/*Same with above but only for men*/
gen _underweight1=.
gen _average1=.
gen _overweight1=.
gen _obese1=.
gen _underweight2=.
gen _average2=.
gen _overweight2=.
gen _obese2=.
gen _underweight3=.
gen _average3=.
gen _overweight3=.
gen _obese3=.
gen Age=.
forvalues i=1(1)18 {
replace Age =`i'+10 in `i'
}
forvalues i=3(1)16 {
summ bmi1 if age>=`i'+10 & age<`i'+11 & bmi1==1 & gender==0
replace _underweight1 =r(N) in `i'
summ bmi1 if age>=`i'+10 & age<`i'+11 & bmi1==2 & gender==0
replace _average1 =r(N) in `i'
summ bmi1 if age>=`i'+10 & age<`i'+11 & bmi1==3 & gender==0
replace _overweight1 =r(N) in `i'
summ bmi1 if age>=`i'+10 & age<`i'+11 & bmi1==4 & gender==0
replace _obese1 =r(N) in `i'
summ bmi2 if age>=`i'+10 & age<`i'+11 & bmi2==1 & gender==0
replace _underweight2 =r(N) in `i'
summ bmi2 if age>=`i'+10 & age<`i'+11 & bmi2==2 & gender==0
replace _average2 =r(N) in `i'
summ bmi2 if age>=`i'+10 & age<`i'+11 & bmi2==3 & gender==0
replace _overweight2 =r(N) in `i'
summ bmi2 if age>=`i'+10 & age<`i'+11 & bmi2==4 & gender==0
replace _obese2 =r(N) in `i'
summ bmi3 if age>=`i'+10 & age<`i'+11 & bmi3==1 & gender==0
replace _underweight3 =r(N) in `i'
summ bmi3 if age>=`i'+10 & age<`i'+11 & bmi3==2 & gender==0
replace _average3 =r(N) in `i'
summ bmi3 if age>=`i'+10 & age<`i'+11 & bmi3==3 & gender==0
replace _overweight3 =r(N) in `i'
summ bmi3 if age>=`i'+10 & age<`i'+11 & bmi3==4 & gender==0
replace _obese3 =r(N) in `i'
}
gen temp1=_underweight1+ _average1 +_overweight1+ _obese1
gen temp2=_underweight2+ _average2 +_overweight2+ _obese2
gen temp3=_underweight3+ _average3 +_overweight3+ _obese3
gen underweight1= 100*_underweight1/temp1
gen average1= 100*_average1/temp1
gen overweight1= 100*_overweight1/temp1
gen obese1= 100*_obese1/temp1
gen underweight2= 100*_underweight2/temp2
gen average2= 100*_average2/temp2
gen overweight2= 100*_overweight2/temp2
gen obese2= 100*_obese2/temp2
gen underweight3= 100*_underweight3/temp3
gen average3= 100*_average3/temp3
gen overweight3= 100*_overweight3/temp3
gen obese3= 100*_obese3/temp3
label variable underweight1 "% of underweight men [Obj.]"
label variable average1 "% of average men [Obj.]"
label variable overweight1 "% of overweight men [Obj.]"
label variable obese1 "% of obese men [Obj.]"
label variable underweight2 "% of underweight men [Obj.] (Alt. def. 1)"
label variable average2 "% of average men [Obj.] (Alt. def. 1)"
label variable overweight2 "% of overweight men [Obj.] (Alt. def. 1)"
label variable obese2 "% of obese men [Obj.] (Alt. def. 1)"
label variable underweight3 "% of underweight men [Obj.] (Alt. def. 2)"
label variable average3 "% of average men [Obj.] (Alt. def. 2)"
label variable overweight3 "% of overweight men [Obj.] (Alt. def. 2)"
label variable obese3 "% of obese men [Obj.] (Alt. def. 2)"
twoway connected underweight1 average1 overweight1 obese1 Age
graph export bmi1_sharesmale.eps , replace
twoway connected underweight2 average2 overweight2 obese2 Age
graph export bmi2_sharesmale.eps , replace
twoway connected underweight3 average3 overweight3 obese3 Age
graph export bmi3_sharesmale.eps , replace
drop temp1 _underweight1 _average1 _overweight1 _obese1 temp2 _underweight2 ///
_average2 _overweight2 _obese2 temp3 _underweight3 _average3 _overweight3 _obese3
gen _very_underweight1=.
gen _underweight1_=.
gen _average1_=.
gen _overweight1_=.
gen _very_overweight1 =.
forvalues i=3(1)16 {
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==1 & gender==0
replace _very_underweight1 =r(N) in `i'
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==2 & gender==0
replace _underweight1_ =r(N) in `i'
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==3 & gender==0
replace _average1_ =r(N) in `i'
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==4 & gender==0
replace _overweight1_ =r(N) in `i'
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==5 & gender==0
replace _very_overweight1 =r(N) in `i'
}
gen temp= _very_underweight1 + _underweight1_ + _average1_ + _overweight1_+ _very_overweight1
gen very_underweight1= 100* _very_underweight1/temp
gen underweight1_ = 100* _underweight1_/temp
gen average1_= 100* _average1_/temp
gen overweight1_ = 100* _overweight1_/temp
gen very_overweight1 = 100* _very_overweight1/temp
label variable very_underweight1 "% of very underweight men [Subj.]"
label variable underweight1_ "% of underweight men [Subj.]"
label variable average1_ "% of average men [Subj.]"
label variable overweight1_ "% of overweight men [Subj.]"
label variable very_overweight1 "% of very overweight men [Subj.]"
twoway connected very_underweight1  underweight1_ average1_  overweight1_ very_overweight1 Age
drop temp _very_underweight1 _underweight1_ _average1_ _overweight1_ _very_overweight1
graph export weightimage_sharesmale.eps , replace
twoway connected  average1_ average1 Age
graph export extra1male.eps , replace
twoway connected  average1_ average2 Age
graph export extra2male.eps , replace
twoway connected  average1_ average3 Age
graph export extra3male.eps , replace
drop very_underweight1 very_overweight1  underweight1_ overweight1_  ///
average1_  Age average1 obese1 underweight1 overweight1 average2 obese2 underweight2 overweight2 ///
average3 obese3 underweight3 overweight3

/*Same with above but only for women*/
gen _underweight1=.
gen _average1=.
gen _overweight1=.
gen _obese1=.
gen _underweight2=.
gen _average2=.
gen _overweight2=.
gen _obese2=.
gen _underweight3=.
gen _average3=.
gen _overweight3=.
gen _obese3=.
gen Age=.
forvalues i=1(1)18 {
replace Age =`i'+10 in `i'
}
forvalues i=3(1)16 {
summ bmi1 if age>=`i'+10 & age<`i'+11 & bmi1==1 & gender==1
replace _underweight1 =r(N) in `i'
summ bmi1 if age>=`i'+10 & age<`i'+11 & bmi1==2 & gender==1
replace _average1 =r(N) in `i'
summ bmi1 if age>=`i'+10 & age<`i'+11 & bmi1==3 & gender==1
replace _overweight1 =r(N) in `i'
summ bmi1 if age>=`i'+10 & age<`i'+11 & bmi1==4 & gender==1
replace _obese1 =r(N) in `i'
summ bmi2 if age>=`i'+10 & age<`i'+11 & bmi2==1 & gender==1
replace _underweight2 =r(N) in `i'
summ bmi2 if age>=`i'+10 & age<`i'+11 & bmi2==2 & gender==1
replace _average2 =r(N) in `i'
summ bmi2 if age>=`i'+10 & age<`i'+11 & bmi2==3 & gender==1
replace _overweight2 =r(N) in `i'
summ bmi2 if age>=`i'+10 & age<`i'+11 & bmi2==4 & gender==1
replace _obese2 =r(N) in `i'
summ bmi3 if age>=`i'+10 & age<`i'+11 & bmi3==1 & gender==1
replace _underweight3 =r(N) in `i'
summ bmi3 if age>=`i'+10 & age<`i'+11 & bmi3==2 & gender==1
replace _average3 =r(N) in `i'
summ bmi3 if age>=`i'+10 & age<`i'+11 & bmi3==3 & gender==1
replace _overweight3 =r(N) in `i'
summ bmi3 if age>=`i'+10 & age<`i'+11 & bmi3==4 & gender==1
replace _obese3 =r(N) in `i'
}
gen temp1=_underweight1+ _average1 +_overweight1+ _obese1
gen temp2=_underweight2+ _average2 +_overweight2+ _obese2
gen temp3=_underweight3+ _average3 +_overweight3+ _obese3
gen underweight1= 100*_underweight1/temp1
gen average1= 100*_average1/temp1
gen overweight1= 100*_overweight1/temp1
gen obese1= 100*_obese1/temp1
gen underweight2= 100*_underweight2/temp2
gen average2= 100*_average2/temp2
gen overweight2= 100*_overweight2/temp2
gen obese2= 100*_obese2/temp2
gen underweight3= 100*_underweight3/temp3
gen average3= 100*_average3/temp3
gen overweight3= 100*_overweight3/temp3
gen obese3= 100*_obese3/temp3
label variable underweight1 "% of underweight women [Obj.]"
label variable average1 "% of average women [Obj.]"
label variable overweight1 "% of overweight women [Obj.]"
label variable obese1 "% of obese women [Obj.]"
label variable underweight2 "% of underweight women [Obj.] (Alt. def. 1)"
label variable average2 "% of average women [Obj.] (Alt. def. 1)"
label variable overweight2 "% of overweight women [Obj.] (Alt. def. 1)"
label variable obese2 "% of obese women [Obj.] (Alt. def. 1)"
label variable underweight3 "% of underweight women [Obj.] (Alt. def. 2)"
label variable average3 "% of average women [Obj.] (Alt. def. 2)"
label variable overweight3 "% of overweight women [Obj.] (Alt. def. 2)"
label variable obese3 "% of obese women [Obj.] (Alt. def. 2)"
twoway connected underweight1 average1 overweight1 obese1 Age
graph export bmi1_sharesfemale.eps , replace
twoway connected underweight2 average2 overweight2 obese2 Age
graph export bmi2_sharesfemale.eps , replace
twoway connected underweight3 average3 overweight3 obese3 Age
graph export bmi3_sharesfemale.eps , replace
drop temp1 _underweight1 _average1 _overweight1 _obese1 temp2 _underweight2 ///
_average2 _overweight2 _obese2 temp3 _underweight3 _average3 _overweight3 _obese3
gen _very_underweight1=.
gen _underweight1_=.
gen _average1_=.
gen _overweight1_=.
gen _very_overweight1 =.
forvalues i=3(1)16 {
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==1 & gender==1
replace _very_underweight1 =r(N) in `i'
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==2 & gender==1
replace _underweight1_ =r(N) in `i'
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==3 & gender==1
replace _average1_ =r(N) in `i'
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==4 & gender==1
replace _overweight1_ =r(N) in `i'
summ weightimage if age>=`i'+10 & age<`i'+11 & weightimage ==5 & gender==1
replace _very_overweight1 =r(N) in `i'
}
gen temp= _very_underweight1 + _underweight1_ + _average1_ + _overweight1_+ _very_overweight1
gen very_underweight1= 100* _very_underweight1/temp
gen underweight1_ = 100* _underweight1_/temp
gen average1_= 100* _average1_/temp
gen overweight1_ = 100* _overweight1_/temp
gen very_overweight1 = 100* _very_overweight1/temp
label variable very_underweight1 "% of very underweight women [Subj.]"
label variable underweight1_ "% of underweight women [Subj.]"
label variable average1_ "% of average women [Subj.]"
label variable overweight1_ "% of overweight women [Subj.]"
label variable very_overweight1 "% of very overweight women [Subj.]"
twoway connected very_underweight1  underweight1_ average1_  overweight1_ very_overweight1 Age
drop temp _very_underweight1 _underweight1_ _average1_ _overweight1_ _very_overweight1
graph export weightimage_sharesfemale.eps , replace
twoway connected  average1_ average1 Age
graph export extra1female.eps , replace
twoway connected  average1_ average2 Age
graph export extra2female.eps , replace
twoway connected  average1_ average3 Age
graph export extra3female.eps , replace
drop very_underweight1 very_overweight1  underweight1_ overweight1_  ///
average1_  Age average1 obese1 underweight1 overweight1 average2 obese2 underweight2 overweight2 ///
average3 obese3 underweight3 overweight3
}

*****************
////////////////////////////
***ANALYSES BMI1***
///////////////////////////
****************
/*Pooled OLS*/
reg weightimage bmi1  age age2 gender health physical
reg weightimage bmi1  age age2 health gender physical outdegree geomean
reg weightimage bmi1  age age2 gender health physical bestmalefriendquality 
reg weightimage bmi1  age age2 gender health physical bestfemalefriendquality 
reg weightimage bmi1  age age2 health gender physical outdegree geomean bestmalefriendquality
reg weightimage bmi1  age age2 health gender physical  outdegree geomean bestfemalefriendquality
quietly{
**Same only for Males**
reg weightimage bmi1  age age2 health physical outdegree geomean if gender==0
reg weightimage bmi1  age age2 health bestmalefriendquality  if gender==0
reg weightimage bmi1  age age2 health bestfemalefriendquality  if gender==0
reg weightimage bmi1  age age2 health physical outdegree geomean bestmalefriendquality if gender==0
reg weightimage bmi1  age age2 health physical outdegree geomean bestfemalefriendquality if gender==0
**Same only for Females**
reg weightimage bmi1  age age2 health physical outdegree geomean if gender==1
reg weightimage bmi1  age age2 health bestmalefriendquality  if gender==1
reg weightimage bmi1  age age2 health bestfemalefriendquality  if gender==1
reg weightimage bmi1  age age2 health physical outdegree geomean bestmalefriendquality if gender==1
reg weightimage bmi1  age age2 health physical outdegree geomean bestfemalefriendquality if gender==1
}

/*Instrument geodesic mean with network density*/
ivregress 2sls weightimage bmi1  age age2 health gender physical outdegree (geomean=density)
ivregress 2sls weightimage bmi1  age age2 health gender physical outdegree (geomean=density) bestmalefriendquality
ivregress 2sls weightimage bmi1  age age2 health gender physical  outdegree (geomean=density) bestfemalefriendquality
quietly{
**Same only for Males**
ivregress 2sls weightimage bmi1  age age2 health physical outdegree (geomean=density) if gender==0
ivregress 2sls weightimage bmi1  age age2 health physical outdegree (geomean=density) bestmalefriendquality if gender==0
ivregress 2sls weightimage bmi1  age age2 health physical outdegree (geomean=density) bestfemalefriendquality if gender==0
**Same only for Females**
ivregress 2sls weightimage bmi1  age age2 health physical outdegree (geomean=density) if gender==1
ivregress 2sls weightimage bmi1  age age2 health physical outdegree (geomean=density) bestmalefriendquality if gender==1
ivregress 2sls weightimage bmi1  age age2 health physical outdegree (geomean=density) bestfemalefriendquality if gender==1
}

/*Fixed Effects*/
xtreg weightimage  age age2 bmi1 gender health physical bestfemalefriendquality, i(id) fe
xtreg weightimage  age age2 bmi1 gender health physical bestmalefriendquality, i(id) fe
quietly{
**Same only for Females**
xtreg weightimage  age age2 bmi1 health bestfemalefriendquality if gender==1, i(id) fe
xtreg weightimage  age age2 bmi1 health bestmalefriendquality if gender==1, i(id) fe
**Same only for Males**
xtreg weightimage  age age2 bmi1 health bestfemalefriendquality if gender==0, i(id) fe
xtreg weightimage  age age2 bmi1 health bestmalefriendquality if gender==0, i(id) fe
}

/*Hausman-Taylor*/
xtset id wave

xthtaylor weightimage  age age2 bmi1  physical gender health outdegree geomean, constant(gender outdegree geomean) endog(health)
xthtaylor weightimage  age age2 bmi1 gender physical bestmalefriendquality health outdegree geomean, constant(outdegree gender geomean) endog(health)
xthtaylor weightimage age age2  bmi1 gender physical bestfemalefriendquality health outdegree geomean, constant(outdegree gender geomean) endog(health)
quietly{
*Same only for Males
xthtaylor weightimage  age age2 bmi1 physical health geomean if gender==0, constant(geomean) endog(health)
xthtaylor weightimage age age2  bmi1 physical bestmalefriendquality health outdegree geomean if gender==0, constant(outdegree geomean) endog(health)
xthtaylor weightimage age age2  bmi1 physical bestfemalefriendquality health outdegree geomean if gender==0, constant(outdegree geomean) endog(health)
*Same only for Females
xthtaylor weightimage age age2  bmi1 physical health geomean if gender==1, constant(geomean) endog(health)
xthtaylor weightimage age age2  bmi1 physical bestmalefriendquality health outdegree geomean if gender==1, constant(outdegree geomean) endog(health)
xthtaylor weightimage  age age2 bmi1 physical bestfemalefriendquality health outdegree geomean if gender==1, constant(outdegree geomean) endog(health)
}

/*Binomial Probit*/
probit misperception groupage groupage2 bmi1  physical gender health outdegree geomean
margins, dydx(*)
quietly{
*Same for Males
probit misperception groupage groupage2 bmi1  physical health outdegree geomean if gender==0
margins, dydx(*)
*Same for Females
probit misperception groupage groupage2 bmi1  physical health outdegree geomean if gender==1
margins, dydx(*)
}

*****************
////////////////////////////
***ANALYSES BMI2***
///////////////////////////
****************
/*Pooled OLS*/
reg weightimage bmi2  age age2 gender health physical
reg weightimage bmi2  age age2 health gender physical outdegree geomean
reg weightimage bmi2  age age2 gender health physical bestmalefriendquality 
reg weightimage bmi2  age age2 gender health physical bestfemalefriendquality 
reg weightimage bmi2  age age2 health gender physical outdegree geomean bestmalefriendquality
reg weightimage bmi2  age age2 health gender physical  outdegree geomean bestfemalefriendquality
quietly{
**Same only for Males**
reg weightimage bmi2  age age2 health physical outdegree geomean if gender==0
reg weightimage bmi2  age age2 health bestmalefriendquality  if gender==0
reg weightimage bmi2  age age2 health bestfemalefriendquality  if gender==0
reg weightimage bmi2  age age2 health physical outdegree geomean bestmalefriendquality if gender==0
reg weightimage bmi2  age age2 health physical outdegree geomean bestfemalefriendquality if gender==0
**Same only for Females**
reg weightimage bmi2  age age2 health physical outdegree geomean if gender==1
reg weightimage bmi2  age age2 health bestmalefriendquality  if gender==1
reg weightimage bmi2  age age2 health bestfemalefriendquality  if gender==1
reg weightimage bmi2  age age2 health physical outdegree geomean bestmalefriendquality if gender==1
reg weightimage bmi2  age age2 health physical outdegree geomean bestfemalefriendquality if gender==1
}

/*Instrument geodesic mean with network density*/
ivregress 2sls weightimage bmi2  age age2 health gender physical outdegree (geomean=density)
ivregress 2sls weightimage bmi2  age age2 health gender physical outdegree (geomean=density) bestmalefriendquality
ivregress 2sls weightimage bmi2  age age2 health gender physical  outdegree (geomean=density) bestfemalefriendquality
quietly{
**Same only for Males**
ivregress 2sls weightimage bmi2  age age2 health physical outdegree (geomean=density) if gender==0
ivregress 2sls weightimage bmi2  age age2 health physical outdegree (geomean=density) bestmalefriendquality if gender==0
ivregress 2sls weightimage bmi2  age age2 health physical outdegree (geomean=density) bestfemalefriendquality if gender==0
**Same only for Females**
ivregress 2sls weightimage bmi2  age age2 health physical outdegree (geomean=density) if gender==1
ivregress 2sls weightimage bmi2  age age2 health physical outdegree (geomean=density) bestmalefriendquality if gender==1
ivregress 2sls weightimage bmi2  age age2 health physical outdegree (geomean=density) bestfemalefriendquality if gender==1
}

/*Fixed Effects*/
xtreg weightimage  age age2 bmi2 gender health physical bestfemalefriendquality, i(id) fe
xtreg weightimage  age age2 bmi2 gender health physical bestmalefriendquality, i(id) fe
quietly{
**Same only for Females**
xtreg weightimage  age age2 bmi2 health bestfemalefriendquality if gender==1, i(id) fe
xtreg weightimage  age age2 bmi2 health bestmalefriendquality if gender==1, i(id) fe
**Same only for Males**
xtreg weightimage  age age2 bmi2 health bestfemalefriendquality if gender==0, i(id) fe
xtreg weightimage  age age2 bmi2 health bestmalefriendquality if gender==0, i(id) fe
}

/*Hausman-Taylor*/
xtset id wave

xthtaylor weightimage  age age2 bmi2  physical gender health outdegree geomean, constant(gender outdegree geomean) endog(health)
xthtaylor weightimage  age age2 bmi2 gender physical bestmalefriendquality health outdegree geomean, constant(outdegree gender geomean) endog(health)
xthtaylor weightimage age age2  bmi2 gender physical bestfemalefriendquality health outdegree geomean, constant(outdegree gender geomean) endog(health)
quietly{
*Same only for Males
xthtaylor weightimage  age age2 bmi2 physical health geomean if gender==0, constant(geomean) endog(health)
xthtaylor weightimage age age2  bmi2 physical bestmalefriendquality health outdegree geomean if gender==0, constant(outdegree geomean) endog(health)
xthtaylor weightimage age age2  bmi2 physical bestfemalefriendquality health outdegree geomean if gender==0, constant(outdegree geomean) endog(health)
*Same only for Females
xthtaylor weightimage age age2  bmi2 physical health geomean if gender==1, constant(geomean) endog(health)
xthtaylor weightimage age age2  bmi2 physical bestmalefriendquality health outdegree geomean if gender==1, constant(outdegree geomean) endog(health)
xthtaylor weightimage  age age2 bmi2 physical bestfemalefriendquality health outdegree geomean if gender==1, constant(outdegree geomean) endog(health)
}

/*Binomial Probit*/
probit misperception2 groupage groupage2 bmi2  physical gender health outdegree geomean
margins, dydx(*)
quietly{
*Same for Males
probit misperception2 groupage groupage2 bmi2  physical health outdegree geomean if gender==0
margins, dydx(*)
*Same for Females
probit misperception2 groupage groupage2 bmi2  physical health outdegree geomean if gender==1
margins, dydx(*)
}

*****************
////////////////////////////
***ANALYSES BMI3***
///////////////////////////
****************
/*Pooled OLS*/
reg weightimage bmi3  age age2 gender health physical
reg weightimage bmi3  age age2 health gender physical outdegree geomean
reg weightimage bmi3  age age2 gender health physical bestmalefriendquality 
reg weightimage bmi3  age age2 gender health physical bestfemalefriendquality 
reg weightimage bmi3  age age2 health gender physical outdegree geomean bestmalefriendquality
reg weightimage bmi3  age age2 health gender physical  outdegree geomean bestfemalefriendquality
quietly{
**Same only for Males**
reg weightimage bmi3  age age2 health physical outdegree geomean if gender==0
reg weightimage bmi3  age age2 health bestmalefriendquality  if gender==0
reg weightimage bmi3  age age2 health bestfemalefriendquality  if gender==0
reg weightimage bmi3  age age2 health physical outdegree geomean bestmalefriendquality if gender==0
reg weightimage bmi3  age age2 health physical outdegree geomean bestfemalefriendquality if gender==0
**Same only for Females**
reg weightimage bmi3  age age2 health physical outdegree geomean if gender==1
reg weightimage bmi3  age age2 health bestmalefriendquality  if gender==1
reg weightimage bmi3  age age2 health bestfemalefriendquality  if gender==1
reg weightimage bmi3  age age2 health physical outdegree geomean bestmalefriendquality if gender==1
reg weightimage bmi3  age age2 health physical outdegree geomean bestfemalefriendquality if gender==1
}

/*Instrument geodesic mean with network density*/
ivregress 2sls weightimage bmi3  age age2 health gender physical outdegree (geomean=density)
ivregress 2sls weightimage bmi3  age age2 health gender physical outdegree (geomean=density) bestmalefriendquality
ivregress 2sls weightimage bmi3  age age2 health gender physical  outdegree (geomean=density) bestfemalefriendquality
quietly{
**Same only for Males**
ivregress 2sls weightimage bmi3  age age2 health physical outdegree (geomean=density) if gender==0
ivregress 2sls weightimage bmi3  age age2 health physical outdegree (geomean=density) bestmalefriendquality if gender==0
ivregress 2sls weightimage bmi3  age age2 health physical outdegree (geomean=density) bestfemalefriendquality if gender==0
**Same only for Females**
ivregress 2sls weightimage bmi3  age age2 health physical outdegree (geomean=density) if gender==1
ivregress 2sls weightimage bmi3  age age2 health physical outdegree (geomean=density) bestmalefriendquality if gender==1
ivregress 2sls weightimage bmi3  age age2 health physical outdegree (geomean=density) bestfemalefriendquality if gender==1
}

/*Fixed Effects*/
xtreg weightimage  age age2 bmi3 gender health physical bestfemalefriendquality, i(id) fe
xtreg weightimage  age age2 bmi3 gender health physical bestmalefriendquality, i(id) fe
quietly{
**Same only for Females**
xtreg weightimage  age age2 bmi3 health bestfemalefriendquality if gender==1, i(id) fe
xtreg weightimage  age age2 bmi3 health bestmalefriendquality if gender==1, i(id) fe
**Same only for Males**
xtreg weightimage  age age2 bmi3 health bestfemalefriendquality if gender==0, i(id) fe
xtreg weightimage  age age2 bmi3 health bestmalefriendquality if gender==0, i(id) fe
}

/*Hausman-Taylor*/
xtset id wave

xthtaylor weightimage  age age2 bmi3  physical gender health outdegree geomean, constant(gender outdegree geomean) endog(health)
xthtaylor weightimage  age age2 bmi3 gender physical bestmalefriendquality health outdegree geomean, constant(outdegree gender geomean) endog(health)
xthtaylor weightimage age age2  bmi3 gender physical bestfemalefriendquality health outdegree geomean, constant(outdegree gender geomean) endog(health)
quietly{
*Same only for Males
xthtaylor weightimage  age age2 bmi3 physical health geomean if gender==0, constant(geomean) endog(health)
xthtaylor weightimage age age2  bmi3 physical bestmalefriendquality health outdegree geomean if gender==0, constant(outdegree geomean) endog(health)
xthtaylor weightimage age age2  bmi3 physical bestfemalefriendquality health outdegree geomean if gender==0, constant(outdegree geomean) endog(health)
*Same only for Females
xthtaylor weightimage age age2  bmi3 physical health geomean if gender==1, constant(geomean) endog(health)
xthtaylor weightimage age age2  bmi3 physical bestmalefriendquality health outdegree geomean if gender==1, constant(outdegree geomean) endog(health)
xthtaylor weightimage  age age2 bmi3 physical bestfemalefriendquality health outdegree geomean if gender==1, constant(outdegree geomean) endog(health)
}

/*Binomial Probit*/
probit misperception3 groupage groupage2 bmi3  physical gender health outdegree geomean
margins, dydx(*)
quietly{
*Same for Males
probit misperception3 groupage groupage2 bmi3  physical health outdegree geomean if gender==0
margins, dydx(*)
*Same for Females
probit misperception3 groupage groupage2 bmi3  physical health outdegree geomean if gender==1
margins, dydx(*)
}

log close
