SAS code to create analytic data set
================
Ben Sabath
June 01, 2020

This directory contains code we use to create our initial mortality data
set prior to merging it with the confounder and exposure data. We use
the Medicare Beneficiary summary file from 1999-2016 to create this data
set. We select all individuals 65 or older with a known gender. We
define a mortality outcome as an enrollment record for a given year
having a non-missing date of death with a year matching the year of
enrollment. The code saves the data as one large file covering all years
of data in SAS format and as a CSV.
