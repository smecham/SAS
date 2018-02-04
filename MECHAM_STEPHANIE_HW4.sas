*Homework 4: Merging and Descriptive Statistics | Stephanie Mecham | EPID 640 Section 2 ;

*Creating a permanent library;

libname nhanes "C:\Users\smecham\Desktop\nhanes";
run;

*Question 3: Merging datasets in merge1;

proc sort data= nhanes.bmx_h;
by seqn;
run;

data merge1;
	merge  nhanes.slq_h nhanes.bmx_h nhanes.diq_h nhanes.smq_h nhanes.hiq_h;
	by SEQN;
	keep SEQN SLQ060 SLD010H BMXBMI DIQ010 SMQ020 SMQ040 HIQ011;
	run;

*Question 4: Merging merge1 with samplenew;

data merge2;
	merge  merge1 nhanes.samplenew;
	by SEQN;
	run;

*Question 6: Merging into sleepbp with individuals only in both datasets;

data nhanes.sleepbp;
	merge  merge1 (in=a) nhanes.samplenew (in=b);
	by SEQN;
	if a and b;
	run;


*Question 9: Recoding refused/missing data points to missing in sleepbp set;

*Check;

proc means data=nhanes.sleepbp n nmiss min max;
var SLQ060 HIQ011 RIAGENDR DMDEDUC2;
run;

*Re-coding;

data nhanes.sleepbp;
	set nhanes.sleepbp;

	if SLQ060 = 7 then newSLQ060=.;
	else if SLQ060 = 9 then newSLQ060=.;
	else newSLQ060=SLQ060;

	if HIQ011 = 7 then newHIQ011=.;
	else if HIQ011= 9 then newHIQ011=.;
	else newHIQ011=HIQ011;

	if RIAGENDR = 7 then newRIAGENDR=.;
	else if RIAGENDR = 9 then newRIAGENDR=.;
	else newRIAGENDR=RIAGENDR;

	if DMDEDUC2 = 7 then newDMDEDUC2=.;
	else if DMDEDUC2 = 9 then newDMDEDUC2=.;
	else newDMDEDUC2=DMDEDUC2;

	if SLD010H = . then shortsleep =.;
	else if SLD010H < 7 then shortsleep=1;
	else shortsleep=0;

	run;

*Re-checking;

proc means data=nhanes.sleepbp n nmiss min max;
var newSLQ060 newHIQ011 newRIAGENDR newDMDEDUC2;
run;

*Question 10: Creating sleepcombo from shortsleep and SLQ060 and running a PROC FREQ;

data nhanes.sleepbp;
set nhanes.sleepbp;
if shortsleep=1 and SLQ060=1 then sleepcombo=4;
else if shortsleep=1 and SLQ060=2 then sleepcombo=3;
else if shortsleep=0 and SLQ060=1 then sleepcombo=2;
else if shortsleep=0 and SLQ060=2 then sleepcombo=1;
run;

proc freq data= nhanes.sleepbp;
	tables sleepcombo;
	run;

