/****************************************************************************************************************************/
/********************************************** EPID642 Sampling and Power **************************************************/
/************************************************** Lab 0: Getting started *************************************************/
/***************************************************************************************************************************/
libname lab0 'C:\Users\ning\Desktop\class materials\labs';
*Reading in comma separated values;
DATA nhanes;
   INFILE 'C:\Users\ning\Desktop\class materials\labs\lab0.csv' DLM=',';
   INPUT seqn	gender	ridageyr	bmxbmi	bmxwaist	LBXGLU	diabetes TSUGR;
RUN;

DATA lab0.nhanes;
SET nhanes;
RUN;

*Question 2: mean(std) total sugar intake by diabetes;
PROC MEANS DATA=lab0.nhanes;
VAR tsugr;
CLASS diabetes;
RUN;

*Question 3: diabetes status by gender;
PROC FREQ DATA=lab0.nhanes;
TABLES diabetes*gender;
RUN;

*Question 4: the proportion of the pre-obese and the obese;
*Create obesity classification by BMI;
DATA lab0.nhanes;
SET lab0.nhanes;
 IF bmxbmi ne . and bmxbmi<25 THEN obesity=0;
 IF bmxbmi >=25 and bmxbmi<30 THEN obesity=1;
 IF bmxbmi >=30 THEN obesity=2;
RUN;

PROC FREQ DATA=lab0.nhanes;
TABLES obesity;
RUN;
 
