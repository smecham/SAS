/********************************************************************/
/* Filename: Lab2-SLR.sas                                           */
/* Main: PROC MEANS, PROC CORR,  PROC REG                           */
/* Others: PROC UNIVARIATE, PROC PRINT, PROC GPLOT, PROC SGPLOT     */
/********************************************************************/
/*------------------------------------------------------------*/
/* NOTES IN THIS BOX ARE JUST FOR YOUR INFO.                  */
/*   OPTIONS allows specifying some options for output        */
/*   LS = line size, i.e., width of page                      */
/*   PS = page size, i.e., length of page                     */
/*   NOCENTER = left-justify printed output                   */
/*   NODATE = do not print date on printed output             */
/* "title;" clears the title if there is any from prior runs. */
/*------------------------------------------------------------*/
OPTIONS LS=70 PS=90 NOCENTER NODATE;
title;                                                                                                               
footnote;                            

/*============================================================*/
/* Instead of clicking the icon for the dataset to open SAS   */
/*   data directly, you can read any SAS data using codes     */
/*   such as below.  The libname loads a SAS dataset          */
/*   table501.sas7bdat to your working directory.  You should */
/*   specify the directory with your own folder path and file */
/*   name, such as "M:\biostat 522\" or                       */
/*   "c:\class\0bios522-w17\datasets\".                       */
/*============================================================*/
libname library "c:\class\0bios522-w18\datasets\"  ;
*libname library "M:\biostat 522\";

data tmp;
  set library.table501;
  * Below two lines are optional labels for the variables;
  label sbp = 'Systolic Blood Pressure'
        age = 'Age of Adult Males'; 
run;

*-------------------------------------------------------;
* Telling SAS to print the dataset tmp                  ;
*   with the title at the top of the page.              ;
*-------------------------------------------------------;
proc print data=tmp; 
title "List of SBP Data";
run;

*-------------------------------------------------------;
* Histogram of SBP to check its distribution            ;
*-------------------------------------------------------;
proc univariate data=tmp;
  var sbp;
  histogram / normal;
  title "Histograms for SBP";
run;

*================================================================================;
* Scatter Plot of SBP vs. Age                                                    ;
*================================================================================;
*-------------------------------------------------------;
* Using PROC GPLOT                                      ;
*    formats can be ignored or can be varied            ;
*         - get help from extensive online SAS help     ;
*    symbol1: Formats plotting symbol #1                ;
*    V = shape, C = color, I = interpolation method     ;
*-------------------------------------------------------;
proc gplot;
  plot sbp*age;
  *symbol value=dot;
  symbol1 V=circle C=blue I=none; 
  title "Scatter Plot of SBP versus Age";
run; 
quit;

*-------------------------------------------------------;
* Using PROC SGPLOT                                     ;
*-------------------------------------------------------;
proc sgplot; 
  scatter x=age y=sbp;
  ellipse x=age y=sbp;
run; 
quit;

*================================================================================;
* Simple regression using SBP data from Table 5-1                                ;
*  Compare Sample SD(Y) vs. Sigma_hat of the regression line                     ;
*================================================================================;
*-------------------------------------------------------;
* Get the SD of SBP                                     ;
*-------------------------------------------------------;
proc means data=tmp; 
  var sbp; 
  title "Crude Mean Model";
run;

*-------------------------------------------------------;
* Simple Regression Models with Age as the predictor    ;
*   Model: SBP = bega_0 + bega_1*AGE                    ;
*   Note PLOT is embedded in PROC REG                   ;
*-------------------------------------------------------;
proc reg; 
  model sbp = age; 
  title "SBP = bega0 + beta1*age";
  title2 "Includes Scatter Plot of SBP versus Age";
run;

*-------------------------------------------------------;
* Below is the same model as above, but asks for a plot ;
*   specifically.                                       ;
* Output line saves a dataset of predictions (regout)   ;
*   that includes yhat (called pred), confidence        ;
*   intervals and prediction intervals.                 ;
* Plot line plots sbp by age, including CI & PI.        ; 
*-------------------------------------------------------;
proc reg data=tmp; 
  title2 "Includes Scatter Plot, CI and PI";
  title3 "Predictions, CI, PI saved as regout";
** clb option below gives 95% CI of betas;
  model sbp = age / clb; 
  output out=regout p=pred l95m=lcl u95m=ucl l95=lpl u95=upl; 
  plot sbp * age / conf95 pred95;
run;    

*-------------------------------------------------------;
* Print dataset regout which includes y_hat,            ;
*    Confidence Intervals and Prediction Intervals      ;
* obs=10 option requests printing first 10 observations ; 
*-------------------------------------------------------;
title "Content of the saved dataset regout, including variable names";
proc contents data=regout; run;

title "Listing of dataset regout from SBP = bega0 + beta1*age";
proc print data=regout (obs=10) label;
run; 

*================================================================================;
* EXTRA FYI: Plots using REGOUT dataset you outputted after PROC REG             ;
*================================================================================;
*-------------------------------------------------------;
* Another way to get a plot - not so pretty             ;
*-------------------------------------------------------;
proc plot data=regout;
  plot sbp*age='o' pred*age='*'/ overlay;
quit;

*-------------------------------------------------------;
* Plots of (sbp by age) & (pred by age) Overlayed       ;
*-------------------------------------------------------;
proc gplot data=regout;
 symbol1 V=circle C=black I=none;
 symbol2 V=star  C=blue I=line;
 plot sbp*age pred*age / overlay;  
** OVERLAY = overlay one plot on top of the other  **;
run;
quit;

*-------------------------------------------------------;
* Plotting Six Lines Overlayed Using PROC GPLOT         ;
*-------------------------------------------------------;
proc gplot data=regout;
 plot sbp*age pred*age lcl*age ucl*age lpl*age upl*age / overlay;
 symbol1 V=dot C=green I=none;
 symbol2 V=dot C=black I=line;
 symbol3 V=dot C=red I=rc;
 symbol4 V=dot C=red I=rc;
 symbol5 V=dot C=blue I=rc;
 symbol6 V=dot C=blue I=rc;
run;
quit;

*================================================================================;
* Related to last question in homework 2                                         ;   
* Correlation coefficient & more descritive Stats                                ;
*================================================================================;
*-------------------------------------------------------;
* Back to "tmp" data and do descriptive Stats of Y & X  ;
*   css option gives corrected total SS (SSX or SSY)    ;
*-------------------------------------------------------;
proc means data=tmp mean std n min max css;
   var sbp age;
run;

*-------------------------------------------------------;
* Correlation between Y and X                           ;
*-------------------------------------------------------;
proc corr data=tmp pearson; 
  title 'Correlation between Y (sbp) and X (age)';
  var sbp age; 
run;

*================================================================================;
* SLR 3 Note: F-test, correlation coefficient, R-square and rescaling            ;
*================================================================================;
/*-----------------------------------------------------------------------*/ 
/* To get corr(y, yhat), first fit the model and save yhat in a dataset. */
/*-----------------------------------------------------------------------*/ 
proc reg data=tmp; 
  model sbp = age;
  output out=regout_age p=sbp_hat; 
run;

proc corr data=tmp;
title 'Correlation between SBP and Age';
  var sbp age; 
run;
                         
proc corr data=regout_age;
title 'Correlation between SBP and Predicted SBP (y_hat)';
  var sbp sbp_hat; 
run;

* To get pair-wise correlations across SBP, yhat, and AGE all in one PROC CORR;
* Learn to read the output from below;

proc corr data=regout_age;
title 'Pair-wise correlation in one PROC CORR';
  var sbp age sbp_hat; 
run;

/*-----------------------------------------------------------------------*/ 
/* Correlation between Y & yhat from Model 2 saved in data regout_age10  */
/*                                                                       */
/* Q: Compare the correlation from this vs. R-square from above model 1  */
/*    or model 2.  How are they related?                                 */
/*-----------------------------------------------------------------------*/ 
proc corr data=regout_age10;
title 'Correlation between Y (sbp) and Y_hat (predicted sbp) from Model 2';
  var sbp pred; 
run;

* SAS AS A CALCULATOR;
*  -- SEE WHY WE ARE DOING BELOW, AND CHECK YOUR LOG FILE;
data _null_;
  x = 0.65757**2;
  put x;
run;


/*-----------------------------------------------------------------------*/ 
/* RESCALING                                                             */
/*-----------------------------------------------------------------------*/ 
/*----------------------------------------------------------------------*/ 
/* Q1: What are we doing in below steps?                                */
/* Q2: What do the two identical PROC CONTENTS step below tell you?     */
/* Q3: Can you add a label for age10? If you add a label, what would    */
/*     that be? You want it to correctly describe the new variable so   */
/*     you know what it is later.                                       */
/*----------------------------------------------------------------------*/ 
proc contents data=tmp; run;

data tmp; set tmp;
  age10 = age/10;   
run;

proc contents data=tmp; run;

/*----------------------------------------------------------------------*/ 
/* Fit two regression models at the same time                           */     
/* Model 1: SBP = bega_0 + bega_1 * age                                 */
/* Model 2: sbp = beta_0 + beta_1 * age10                               */
/*                                                                      */
/* NOTE: OUTPUT OUT=REGOUT_AGE10 saves yhat from Model 2                */
/*    to a dataset named regout_age10                                   */
/*                                                                      */
/* Q1: Interpret parameter estimates for age from model1                */
/*    and for age10 from model2.                                        */
/* Q2: Without fitting another new model, can you guess the parameter   */
/*    estimate corresponding to every 2-year increment of age?          */
/*    Now verify your answer using SAS?                                 */ 
/*----------------------------------------------------------------------*/ 
proc reg; 
  model1: model sbp = age;   /* Model 1 */
  model2: model sbp = age10; /* Model 2 */
  output out=regout_age10 p=pred l95m=lcl u95m=ucl l95=lpl95 u95=upl; 
run; 

