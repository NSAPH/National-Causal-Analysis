libname myLibLoc '../raw_data/sas_files'; * <-- Place Output Library Path Here *;

proc export data=myLibLoc.cdbrfs99
     FILE="../csv/brfss_1999.csv"
     DBMS = CSV
     REPLACE
     ;
run;

proc export data=myLibLoc.cdbrfs00
     FILE="../csv/brfss_2000.csv"
     DBMS = CSV
     REPLACE
     ;
run;

proc export data=myLibLoc.cdbrfs01
     FILE="../csv/brfss_2001.csv"
     DBMS = CSV
     REPLACE
     ;
run;

proc export data=myLibLoc.cdbrfs02
     FILE="../csv/brfss_2002.csv"
     DBMS = CSV
     REPLACE
     ;
run;

proc export data=myLibLoc.cdbrfs03
     FILE="../csv/brfss_2003.csv"
     DBMS = CSV
     REPLACE
     ;
run;

proc export data=myLibLoc.cdbrfs04
     FILE="../csv/brfss_2004.csv"
     DBMS = CSV
     REPLACE
     ;
run;

proc export data=myLibLoc.cdbrfs05
     FILE="../csv/brfss_2005.csv"
     DBMS = CSV
     REPLACE
     ;
run;

proc export data=myLibLoc.cdbrfs06
     FILE="../csv/brfss_2006.csv"
     DBMS = CSV
     REPLACE
     ;
run;

proc export data=myLibLoc.cdbrfs07
     FILE="../csv/brfss_2007.csv"
     DBMS = CSV
     REPLACE
     ;
run;

proc export data=myLibLoc.cdbrfs08
     FILE="../csv/brfss_2008.csv"
     DBMS = CSV
     REPLACE
     ;
run;

proc export data=myLibLoc.cdbrfs09
     FILE="../csv/brfss_2009.csv"
     DBMS = CSV
     REPLACE
     ;
run;

proc export data=myLibLoc.cdbrfs10
     FILE="../csv/brfss_2010.csv"
     DBMS = CSV
     REPLACE
     ;
run;

proc export data=myLibLoc.llcp2011
     FILE="../csv/brfss_2011.csv"
     DBMS = CSV
     REPLACE
     ;
run;

proc export data=myLibLoc.llcp2012
     FILE="../csv/brfss_2012.csv"
     DBMS = CSV
     REPLACE
     ;
run;



