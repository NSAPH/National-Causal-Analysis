SAS code to create analytic data set
================
Ben Sabath
June 16, 2021

This directory contains code we use to create our initial mortality data
set prior to merging it with the confounder and exposure data. We use
the Medicare Beneficiary summary file from 1999-2016 to create this data
set.
In general, two files are purchased directly from CMS [RESDAC](https://www.resdac.org/)

1)100% MBSF - MASTER BENEFICIARY SUMMARY FILE (MBSF) base, years

2) 100% MEDPAR - MEDICARE PROVIDER ANALYSIS AND REVIEW (ss/ls/snf), years 

## Input data

We are unable to share the data we receive from CMS as it is private
health information and sharing it publicly would be a violation of our
DUA. However, all of the source files we use can be directly purchased
from [RESDAC](https://www.resdac.org/).

For the years 1999-2010, we use legacy data we received from Johns
Hopkins. These data are older formats of the medicare beneficiary
summary files that can currently be purchased, with a subset of the
variables available pre-selected. The variables selected are individual
id, date of birth, zip code of residence, age, race, data on original
enrollment, HMO coverage, dual eligibility, end state renal disease
indicators, and date of death. 

For questions about the data we received from Johns Hopkins, please
contact Aidan McDermott and Roger Peng at Johns Hopkins university.


For 2011 onward, we start our processing directly on the Medicare
Beneficiary Summary files we receive from CMS. We receive a flat file
(which has a name that varies based on year, request number, and DUA)
named `mbsf_ab_summary_<DUA/REQUEST SPECIFIC CHARACTERS>_<year>.dat`. We
run CMS provided SAS code that is delivered along side the flat files
which outputs a file named `mbsf_ab_summary.sas7bdat` (regardless of
year). For clarity, we rename the output for each year
`Denominator_<year>.sas7bdat`. We also use SAS libraries to also include
county code, latitude, longitude, and to reverse the zip code to further
protect privacy.

The files from Hopkins along with the Medicare Beneficiary Summary Files (MBSFs) from
2011 to 2013 were merged to create the file `Denominator_1999_2013.sas7bdat` that is used as input to
`RCE-Qian-den-1999-2016-01-23-2019.sas`.

## Processing

The code that generates the health data used in the statistical analysis
is `RCE-Qian-den-1999-2016-01-23-2019.sas`. It takes as input the
previously cleaned data `Denominator_1999_2013.sas7bdat`, which is a
previously created data set covering the years from 1999-2013 and the
files `Denominator_2014.sas7bdat`, `Denominator_2015.sas7bdat`, and
`Denominator_2016.sas7bdat`.

We select all individuals 65 or older with a known gender. We define a
mortality outcome as an enrollment record for a given year having a
non-missing date of death with a year matching the year of enrollment.
The code saves the data as one large file covering all years of data in
SAS format (`den_1999_2016.sas7bdat`) and as a CSV
(`Denominator_1999_2016.csv`).

## Final Output

We take the CSV output `Denominator_1999_2016.csv` as input to our final
merge that prepares data for statistical analysis. This data set
includes individual ID, Date of Death, Sex, Race, monthly information on
HMO enrollment, county code, state code, latitude, longitude, reversed
zip code, medicaid eligibility, and the defined death indicator.
