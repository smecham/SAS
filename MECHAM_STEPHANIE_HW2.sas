*Homework 2: Compiling Data Sets - Stephanie Mecham | EPID 640 Section 4;

*Question 2 - Creating a permanent library;

LIBNAME nhanes "C:\Users\smecham\Desktop\nhanes";
RUN;

*Question 3 - Importing demographic data using PROC IMPORT;

proc import
	datafile='C:\Users\smecham\Desktop\nhanes\DEMO_H.xlsx'
	out= nhanes.demo
	dbms= xlsx
	replace;
getnames=yes;
datarow=2;
run;

*Question 4 - Import sleep disorder data using DATA step;

*saving code to temporary work space;
data sleep; 
	infile 'C:\Users\smecham\Desktop\nhanes\SLQ_H.txt' 
		DLM='09'X
		firstobs= 2;
	input SEQN	SLD010H	SLQ050	SLQ060;
	RUN; 

*saving code to permanent work space;

data nhanes.sleep; 
	infile 'C:\Users\smecham\Desktop\nhanes\SLQ_H.txt' 
		DLM='09'X
		firstobs= 2;
	input SEQN	SLD010H	SLQ050	SLQ060;
	RUN; 


*Question 5 - Importing smoking data using a DATA step;

*saving code to temporary workspace;

data smq; 
	infile 'C:\Users\smecham\Desktop\nhanes\SMQ_H.csv' 
	DLM=','
	DSD
	firstobs=2;
	input SEQN	SMQ020	SMD030	SMQ040	SMQ050Q	SMQ050U	SMD055	SMD057	SMQ078	SMD641	SMD650	SMD093	SMDUPCA $	SMD100BR $	SMD100FL	SMD100MN	SMD100LN	SMD100TR	SMD100NI	SMD100CO	SMQ621	SMD630	SMQ661	SMQ665A	SMQ665B	SMQ665C	SMQ665D	SMQ670	SMQ848	SMQ852Q	SMQ852U	SMAQUEX2;
	run;

*saving code to permanent workspace;

data nhanes.smq; 
	infile 'C:\Users\smecham\Desktop\nhanes\SMQ_H.csv' 
	DLM=','
	DSD
	firstobs=2;
	input SEQN	SMQ020	SMD030	SMQ040	SMQ050Q	SMQ050U	SMD055	SMD057	SMQ078	SMD641	SMD650	SMD093	SMDUPCA $	SMD100BR $	SMD100FL	SMD100MN	SMD100LN	SMD100TR	SMD100NI	SMD100CO	SMQ621	SMD630	SMQ661	SMQ665A	SMQ665B	SMQ665C	SMQ665D	SMQ670	SMQ848	SMQ852Q	SMQ852U	SMAQUEX2;
	run;



*Question 6 - Importing blood pressure data using SAS Export file;

LIBNAME BPQ XPORT "C:\Users\smecham\Desktop\nhanes\BPQ_H.xpt"; 
PROC COPY IN=BPQ OUT=nhanes;
RUN;

