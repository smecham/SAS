*EPID 642 Homework 1 | Stephanie Mecham;

libname epi "C:\Users\smecham\Desktop\epi";
run;

*Sampling by Census Block;

proc sort data=epi.dm_sit_sec1;
by block;
run;

proc surveyselect data=epi.dm_sit_sec1 method=SRS
sampsize=50 seed=79589 out=epi.dm_samp;
strata block;
run;

*Question 5: Finding Diabetes Prevalence in Sample;

proc freq data=epi.dm_samp;
tables dm;
run;

*Question 6: Finding Sample Mean & Standard Error of HR_TVCOMP;

proc means data=epi.dm_samp n mean stderr;
var hr_tvcomp;
run;

*Question 7: Regression Analysis of HR_TVCOMP by Diabetes in Sample;

proc rank data= epi.dm_samp out=epi.recoded groups=4;
var hr_tvcomp;
ranks tech_quart;
run;

proc glm data=epi.recoded;
class tech_quart (ref='0') gender (ref='2') raceeth lowpir;
model dm = tech_quart age bmi gender raceeth lowpir / solution clparm;
run;

*Question 9: Regression Analysis of HR_TVCOMP by Diabetes in Population;

proc rank data= epi.dm_sit_sec1 out=epi.population groups=4;
var hr_tvcomp;
ranks tech_quart;
run;

proc glm data=epi.population;
class tech_quart (ref='0') gender (ref='2') raceeth lowpir;
model dm = tech_quart age bmi gender raceeth lowpir / solution clparm;
run;

*End of code;
