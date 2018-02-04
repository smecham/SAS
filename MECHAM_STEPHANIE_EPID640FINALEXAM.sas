
*EPID 640 Take Home Final Exam | Stephanie Mecham | Section 2;

*Question 1: Importing and preparing the ACTV_E.csv file for analysis;

*Part A: importing via PROC import;
proc import 
datafile = 'C:\Users\smecham\Desktop\final\ACTV_E.csv'
out= actv_e
dbms=csv
replace;
getnames=yes;
datarow=2;
run;

*Part B: Creating new variables;

data bmi;
	set actv_e;
	if BMXWT =. then bmi=.;
	if BMXHT=. then bmi=.;
	else bmi= BMXWT/(BMXHT/100)**2;
	run;

data bmi;
	set bmi;
	if bmi =. then bmi_cat=.;
	else if bmi < 18.5 then bmi_cat=1;
	else if bmi >= 18.5 and bmi <25 then bmi_cat=2;
	else if bmi >= 25 and bmi <30 then bmi_cat=3;
	else if bmi >= 30 then bmi_cat=4;
	run;

data bmi;
	set bmi;
	if PAQ650 =. or PAQ650=7 or PAQ650=9 and PAQ665=. or PAQ665=7 or PAQ665=9 then lowactivity=.;
	else if PAQ650=2 and PAQ665=2 then lowactivity=1;
	else if PAQ650=1 then lowactivity=0;
	else if PAQ665=1 then lowactivity=0;
	run;
*Checking work;

proc means data= bmi n nmiss min max;
var bmi bmi_cat lowactivity;
run;

*Delete missing variables;

data bmi_final;
	set bmi;
	if bmi=. then delete;
	if bmi_cat=. then delete;
	if lowactivity=. then delete;
run;

*Part C: Drop non-recoded variables;

data recoded_bmi;
set bmi_final;
drop BMXWT -- PAQ665;
run;


*Part D: Create and apply formats;

proc format;
	value bmicategory 
	1= 'underweight'
	2= 'healthy weight'
	3= 'overweight'
	4= 'obese';

	value physical_activity
	0='normal'
	1='low';
	run;

data recoded_bmi;
set recoded_bmi;
format bmi_cat bmicategory. lowactivity physical_activity.;
run;

*Check work via PROC CONTENTS;

proc contents data=recoded_bmi;
run;
				
*Question 2;

*Part A: Importing file via DATA step;

data PFOA;
infile 'C:\Users\smecham\Desktop\final\LBX_E.txt'
DLM= '/'
firstobs=2
DSD
MISSOVER;
input SEQN LBXTC LBXCOT LBXSUA LBXPFOA;
run;

*Part B: Labeling variables; 

data PFOA;
set PFOA; 
label 
SEQN= 'ID Number'
LBXTC= 'Total Cholesterol (mg/dL)' 
LBXCOT= 'Serum Cotinine (ng/mL)'
LBXSUA= 'Uric Acid (mg/dL)'
LBXPFOA= 'Perfluorooctanoic acid (ng/mL)';
run;
	

*Part C: Delete records with missing PFOA values;

data PFOA_final;
	set PFOA;
	if LBXPFOA=. then delete;
run;

*finding remaining missing values;

proc means data= PFOA_final n nmiss min max;
var LBXTC LBXCOT LBXSUA;
run;

	
*Part D: Creating a Hyperuricemia Dummy Variable;

data PFOA_final;
set PFOA_final;
if LBXSUA = . then hyperuricemia=.;
else if LBXSUA < 7 then hyperuricemia=0;
else hyperuricemia=1;
run;

*Checking work;

proc means data= PFOA_final n nmiss min max;
var LBXSUA;
class hyperuricemia;
run;


*Question 3: Merging datasets into a permanent library;

libname final 'C:\Users\smecham\Desktop\final';
options fmtsearch = (final);

proc sort 
data=final.DEMO_E;
by SEQN;
run;

proc sort
data=recoded_bmi;
by SEQN;
run;

proc sort 
data=PFOA_final;
by SEQN;
run;

data final.combined;
merge final.DEMO_E (in=demo) recoded_bmi (in=actv) PFOA_final (in= pfoa);
by SEQN;
if demo and actv and pfoa;
run;


*Question 4: Summaries of Key Variables in Combined Dataset;

*Part A: Assessing normality;

proc univariate data=final.combined;
var LBXSUA;
histogram LBXSUA / normal;
qqplot;
run;


proc univariate data=final.combined;
var LBXPFOA;
histogram LBXPFOA / normal;
qqplot;
run;

*Part B: Log-transform PFOA variable;

data final.combined;
	set final.combined;
	LOGPFOA= log(LBXPFOA);
	run;

*Assessing normality;
proc univariate data=final.combined;
var LOGPFOA;
histogram LOGPFOA / normal;
qqplot;
run;

*Question 5: Evaluating hyperuricemia by various characteristics;

*Assessing normality of variables via Wilcoxon Rank-Sum Test;

proc npar1way data=final.combined wilcoxon;
class hyperuricemia;
var RIDRETH INDHHIN lowactivity bmi_cat;
exact wilcoxon;
run;

*Question 6: Evaluating uric acid concentration by various characteristics;


*Part A: Creating scatterplots;

proc sgplot data=final.combined;
scatter x=RIDAGEYR y=LBXSUA;
reg x=RIDAGEYR y=LBXSUA / cli clm;
title 'Age (yr) vs Uric Acid (mg/dL)';
run;

proc sgplot data=final.combined;
scatter x=LBXTC y=LBXSUA;
reg x=LBXTC y=LBXSUA / cli clm;
title 'Total Cholesterol (mg/dL) vs Uric Acid (mg/dL)';
run;

proc sgplot data=final.combined;
scatter x=LBXCOT y=LBXSUA;
reg x=LBXCOT y=LBXSUA / cli clm;
title 'Serum Cotinine (ng/mL) vs Uric Acid (mg/dL)';
run;

*Part B: Finding Pearson coefficient and p-values;

proc corr data=final.combined;
var RIDAGEYR LBXTC LBXCOT LBXSUA;
run;


*Question 7: Comparing PFOA exposures by hyperuricemia status;

*Part A: Creating boxplots;

proc sgplot data=final.combined;
vbox LOGPFOA / category=hyperuricemia;
title 'PFOA Measurement by Hyperuricemia Status';
run;

*Part B: T-test;

proc ttest data=final.combined
CI=equal
alpha=0.05;
class hyperuricemia;
var LOGPFOA;
run;

*Question 8: Examine association between PFOA and uric acid; 

*Part A: Linear Regression;

proc reg data=final.combined plots(maxpoints=none);
model LOGPFOA=LBXSUA /
dw
spec;
run;
quit;

*Part C: Adjust association between PFOA and uric acid for other characteristics;

proc glm data=final.combined
plots (maxpoints=none)=(diagnostics residuals(smooth));
class RIAGENDR RIDRETH bmi_cat INDHHIN lowactivity;
model LOGPFOA=LBXSUA RIDAGEYR RIAGENDR RIDRETH bmi_cat INDHHIN lowactivity LBXTC LBXCOT / solution clparm;
run;

*END OF CODE;






