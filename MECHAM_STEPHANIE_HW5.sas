*Homework 5: Manipulating Datasets & Creating Variables | Stephanie Mecham | EPID 640 Section 2;

*Creating a permanent library;

libname nhanes "C:\Users\smecham\Desktop\nhanes";
run;

*Question 1-4: Creating and coding new variables;

data nhanes.sleepbp_final;
set nhanes.sleepbp;

*Creating sysbp_ave;
sysbp_ave= mean(BPXSY1, BPXSY2, BPXSY3, BPXSY4);

*Creating diabp_ave;
diabp_ave= mean(BPXDI1, BPXDI2, BPXDI3, BPXDI4);

*Creating bpmed;
if BPQ020=2 or BPQ040A=2 or BPQ050A=2 then bpmed= 0;
else if BPQ050A=1 then bpmed=1;
else if BPQ050A=. or BPQ050A=7 or BPQ050A=9 then bpmed=.;

*Creating htn;
if sysbp_ave=. and diabp_ave=. and bpmed=. then htn=.;
else if sysbp_ave >= 140 or diabp_ave>= 90 or bpmed=1 then  htn=1;
else htn=0;

*Creating smoker;
if SMQ040=. or SMQ040=7 or SMQ040=9 then smoker=.;
else if SMQ020=2 then smoker=0;
else if SMQ020= 1 and SMQ040=3 then smoker= 0;
else smoker=1;

*Creating diab;
if DIQ010=. or DIQ010=7 or DIQ010=9 then diab=.;
else if DIQ010= 1 then diab=1;
else if DIQ010=2 or DIQ010=3 then diab=0;

*Creating race;
if RIDRETH1=1 then race=3;
else if RIDRETH1=3 then race=1;
else if RIDRETH1=4 then race=2;
else race=4;

*Creating educ;
if DMDEDUC2=. or DMDEDUC2=7 or DMDEDUC2=9 then educ=.;
if DMDEDUC2=1 or DMDEDUC2=2 then educ=1;
else if DMDEDUC2=3 then educ=2;
else if DMDEDUC2=4 or DMDEDUC2=5 then educ=3;

*Creating PIR;
if INDFMPIR =. then pir=.;
else if INDFMPIR < 1 then pir=1;
else if INDFMPIR >=1 AND INDFMPIR <=3 then pir=2;
else if INDFMPIR >3 then pir=3;

*Re-coding health insurance (optional step);
if HIQ011 in (., 7, 9) then healthinsurance_new=.;
else if HIQ011 = 2 then healthinsurance_new=0;
else if HIQ011 = 1 then healthinsurance_new=1;

*Re-coding sleep disorder (optional step);
if SLQ060 in (., 7, 9) then sleepdisorder_new=.;
else if SLQ060 = 2 then sleepdisorder_new=0;
else if SLQ060= 1 then sleepdisorder_new=1;
run;

*Question 5: Assigning formats;

libname nhanes 'C:\Users\smecham\Desktop\nhanes';
options fmtsearch = (nhanes);

proc format library=nhanes;
value yn
.= ‘Missing’
0= ‘No’
1= ‘Yes’;

value sex
1 = 'Male'
2 = 'Female'
. = 'Missing';

value race
1 = 'Non-Hispanic White'
2 = 'Non-Hispanic Black'
3 = 'Mexican American'
4 = 'Other'
. = 'Missing';

value educ
1 = 'Less than high school'
2 = 'High school/GED'
3 = 'At least some college'
.= 'Missing';
	
value sleepcombo
1= Short sleep and sleep disorder
2= No short sleep and sleep disorder
3= Short sleep and no sleep disorder
4= No short sleep and no sleep disorder
.= Missing;
run;

data nhanes.Sleepbp_final;
	set nhanes.sleepbp_final;
	format bpmed yn. htn yn. smoker yn. sleepdisorder_new yn. diab yn. healthinsurance_new yn. sleepcombo sleepcombo. RIAGENDR sex. race race. educ educ.;
	run;

*Question 6: Checking re-codes;
*Proc Freq step;
proc freq data=nhanes.Sleepbp_final;
table smoker*SMQ020 diab*DIQ010 race*RIDRETH1 educ*DMDEDUC2;
run;

*Proc Means with CLASS statement step;
proc means data=nhanes.Sleepbp_final N NMISS MIN MAX;
var INDFMPIR;
class PIR;
run;


*Question 8: Completing the table;

proc means data=nhanes.Sleepbp_final;
var sysbp_ave diabp_ave RIDAGEYR BMXBMI;
run;

proc means data=nhanes.Sleepbp_final;
var sysbp_ave diabp_ave RIDAGEYR BMXBMI;
class htn;
run;

proc freq data=nhanes.Sleepbp_final;
tables RIAGENDR*htn race*htn healthinsurance_new*htn educ*htn smoker*htn pir*htn diab*htn sleepdisorder_new*htn shortsleep*htn sleepcombo*htn;
run;
