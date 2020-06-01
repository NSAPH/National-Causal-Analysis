libname dual    'R:\CMS\Denominator\dual\';
libname qian 'N:\R5400-4\R5400-4-H\Antonella\Qian\';

*R5400-3;

data den_1999_2016 (compress=yes drop=zipcode);
set 
qian.Denominator_2016
qian.Denominator_2015
qian.Denominator_2014
qian.Denominator_1999_2013
;
death=(BENE_DOD~=. and year(BENE_DOD)=year and year(BENE_DOD)~=.); /* all-cause death */
Zipcode_R=Reverse(zipcode);
if zipcode_R~='' and age>64 and sex in ('1','2'); /* no missing in zipcode, age 65+ and male/female sex */
run;

proc freq data=den_1999_2016;
table year*(death dual sex);
run;

proc means data=den_1999_2016;
class year;
var age;
run;

data qian.den_1999_2016 (compress=yes);
set den_1999_2016;
run;

proc contents data=den_1999_2016;
run;


PROC EXPORT DATA= den_1999_2016
            OUTFILE= "N:\R5400-4\R5400-4-H\Antonella\Qian\Denominator_1999_2016.csv" 
            DBMS=CSV REPLACE;
     PUTNAMES=YES;
RUN;
