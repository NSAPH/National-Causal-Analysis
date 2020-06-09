BRFSS Confounder Preparation
================
Ben Sabath
June 03, 2020

This directory contains the pipeline to acqure information from the
CDC’s BRFSS data set, which we use to acquire county level information
on mean BMI and smoking habits. All data has been linked from the county
level to the zip code level.

## Inputs

As input to this pipeline, we use the CDC Behavioral Risk Factor
Surveillance System (BRFSS) individual survey results from 1999-2012. We
stop at 2012 because survey responses were no longer tagged with county
level identifiers after that year.

The directory `raw_data` contains all of the data used to create our
BRFSS confounder data, with the exception of the actual BRFSS data,
which is larger than github’s max file size limit. The BRFSS data can be
downloaded from [here](https://www.cdc.gov/brfss/about/archived.htm). To
prepare it for the pipeline, please download the “SAS Transport Format”
data for each year and place the unzipped XPT file in the directory of its
respective year. The processing code will convert the XPT files first to
the standard SAS format (in the `sas_files` directory) and then to csv
format (in the `csv` directory).

Other files in `raw_data` are as follows: - `state.txt`: Used to convert
state FIPS codes to standard postal codes - `esri_zipcode_2010.csv`:
Used to link the county level values

## Data Preparation

All code used to prepare the data is in the `code` directory.

To create the final data sets, first we run `1_extract_xpt.sas` which
converts the downloaded and unzipped `.XPT` files to standard SAS format
files (`sas7bdat`). We then run `2_sas_convert_to_csv.sas` to create csv
files from the SAS files, to ease the process of working with the data
in R.

Finally, we run `3_prepare_brfss.R` which calculates the zip code level
variables for use with our health data. In its original form, the BRFSS
data is stored as individual survey results, which include both direct
questions, and calculated variables. Information on the location of
individuals is limited to their county. To create the zip code level
data, we aggregate the variables of interest within each county, and
then link the county level data to zip codes (using
`raw_data/esri_zipcode_2010.csv`). We also perform moving average
temporal interpolation to reduce missingness. The uninterpolated data
(`processed_data/brfss_confounders.csv`)is kept to help control for
uncertainty in the interpolation method, and allow users to identify
which values were interpolated.

## Output

There are two files output from this process, both of which are stored
in `processed_data`:

  - `brfss_confounders.csv`: The uninterpolated zip code level BRFSS
    confounders
  - `brfss_interpolated.csv`: The interpolated zip code level BRFSS
    confounders, this is what we use for our analysis.

## Variable details:

  - `fips`: 5 digit county code
  - `smoke_rate`: % of the respondents in a county who have ever smoked
  - `mean_bmi`: mean bmi of respondants in a county
  - `year`: Year of response
  - `ZIP`: zip code
