SAS code to create analytic data set
================
Ben Sabath
June 01, 2020

This directory contains code we use to create our initial mortality data
set prior to merging it with the confounder and exposure data. We use
the Medicare Beneficiary summary file from 1999-2016 to create this data
set.

The code is run on a series of files. The first is a file names
`Denominator_1999_2013.sas7bdat`, which is a previously created data set
covering the years from 1999-2013. The same process for 2014-2016 is
performed on the source files for those years. for 2014-2016, the input
files are renamed from `mbsf_ab_summary.sas7bdat`,the output of the CMS
provided sas code, which converts the data from each year from the CMS
flat file format - name varies based on year, DUA number but takes the
format of `mbsf_ab_summary_<DUA/REQUEST SPECIFIC
CHARACTERS>_<year>.dat`) to a SAS data file to
`Denominator_<year>.sas7bdat`.

We select all individuals 65 or older with a known gender. We define a
mortality outcome as an enrollment record for a given year having a
non-missing date of death with a year matching the year of enrollment.
The code saves the data as one large file covering all years of data in
SAS format (`den_1999_2016.sas7bdat`) and as a CSV.
