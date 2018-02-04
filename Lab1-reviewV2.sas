/*------------------------------------------------------------------------------
Filename: review.sas
-------------------------------------------------------------------------------;
*------------------------------------------------------------------------------;
*  Example 1                                                                   ;
*------------------------------------------------------------------------------;
/* Reading hand entered data into SAS */
data DetroitWeight;
  input weight @@;
  /* The trailing at signs (@@) enable the procedure to read more than 
         one observation per line.  */
  datalines;
157.7556 209.9111 136.5778 115.9111 136.8445 169.3333 168.8445 145.6667 199.8445
168.8445 137.6 105.8444 169.0889 157 125.7556 181.9333 155.7333 130.0222
268.8889 135.8222 157.4889 196.0667 147.6667 137.6
147.6667 152.2 196.0667 154.4667 173.1333 140.1111
140.1111 183.9556 189.7556 126.7556 103.0667 179.6667 163.8
179.6667 163.8 107.8667 185.4667 113.9111 139.8667 168.5778
201.8445 113.9111 305.4222 116.1778 170.3556 116.1778
;
run;
/* Requesting univariate statistics and histogram for variable weight */
proc univariate data=DetroitWeight plot;
  var weight;
  histogram;
  title "Histogram for weight (Continuous Variable)";
run;

/* One-sample t-test */
proc ttest h0=175 alpha=0.05;
      var weight;
title 'One-Sample t Test';
run;


*------------------------------------------------------------------------------;
*  Example 2                                                                   ;
*------------------------------------------------------------------------------;
/* Below step assumes that you have a copy of file "smoke.xls" 
   in a directory called "M:\Biostats 522". This is specified in the line
   that begins with DATAFILE.  I've also included a couple more examples showing 
   how the DATAFILE line can be written if you had the data saved in either afs 
   server or somewhere in your own C drive.  So if you choose to work with 
   another directory such as your flashdrive, change the "DATAFILE" line below 
   to specify that entire path. 

   Get help from your GSI if you don't know how to create a folder
   and save the files from canvas to that folder.             */

/* Note that the first set of commands (from PROC IMPORT to RUN) can also be 
    done by choosing "File -> Import Data" from SAS's menu tabs. 
	The SAS commands behind "File -> Import Data" 
	are basically made of below set of "proc import" command 
        details of which you do not really have to learn. */

/* Import smoke.xls and save the data as smoke.               */
PROC IMPORT OUT= WORK.smoke 
     /* datafile = "/afs/umich.edu/user/m/y/myrakim/class/bios522-W18/Datasets/smoke.xls" */
     datafile = "c:\class\0bios522-W18\Datasets\smoke.xls"
	 /* datafile= "M:\Biostats 522\smoke.xlsx" */
         DBMS=EXCELCS REPLACE;
     RANGE="Sheet1$"; 
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;


/* List smoke Data: 
   always list at least part of the data & check if they look good. */
proc print; run;

/* Univariate Descriptive Statistics of all variables in smoke data */
proc means data=smoke;
  title "Descriptive Statistics";
run;

/* Create a Dichotomous Variable, then Save the Data as smoke2.     */
data smoke2; set smoke;
  if b<100 then lbw=1;
  else if b>=100 then lbw=0;
run;

/* Univariate Descriptive Statistics using dataset smoke2                         */
/* Note that "var A S B;" or "var lbw;" line is optional, and excluding this line */
/*   means you are requesting descriptive stats for all variables in the dataset. */
/* If only "var lbw" is given, descriptive stats will be limited to lbw only.     */
proc means data=smoke2;
  title "Descriptive Statistics";
  title2 "A=age, S=smoke, B=Weight, lbw=low birth weight (1/0)";
  var A S B; 
  var lbw;
run;

/* Requesting the contents of the dataset such as variable names   */
proc contents data=smoke2;
  title "Contents of SAS Data Set";
run;

/* Formating Statement: Effort to explain what the values of 
   1 and 0 for lbw variable represent. The format is named lbwfmt. */
proc format;
  value lbwfmt 1="1:Less than 100 oz" 0="0:>= 100 oz";
run;

/* Requesting Frequency Table for Variable lbw */
proc freq data=smoke2;
  tables lbw;
  format lbw lbwfmt.;
  title "Frequencies for Categorical Variables";
run;

/* Requesting charts - simple visualization */ 
proc chart data=smoke2;
  hbar lbw / discrete;
  title "Bar Charts for Categorical Variables";
run;

/* Requesting univariate statistics and histogram for variables A and S */
proc univariate data=smoke2 plot;
  var A S;
  histogram;
  title "Histogram for Continuous Variables";
run;

*------------------------------------------------------------------------------;
*  Example 3                                                                   ;
*------------------------------------------------------------------------------;
/*
* There are many ways to use menu drive ways of SAS - like SPSS.
* For this course, I don't think these will be helpful.  But they can 
* be useful when you cannot remember the SAS command for some simple analysis.
* 
* Under Solutions tab, you will see ASSIST. Similarly under Solutions, you will 
* see Analysis, under which you will see Interactive Data Analysis. 
* ASSIST and Interactive Data Analysis provide ways to do menu driven SAS.
* For each these, you will need to first load the SAS data by finding where the 
* dataset is located using Explorer within SAS.
*
* Another way to do this is by clicking either a SAS dataset or SAS program file.
* For example, under Review module, you will see a dataset named "smoke.sas7bdat".  
* If you download this file to your working folder and double click the file, 
* you will have SAS Enterprise Guide open. Under SAS Enterprise Guide, 
* you will be able to do various analyses in menu-driven way by looking 
* under Tasks tab.  You can similarly double click this file (review.sas) 
* which will open SAS Enterprise Guide.
*/

