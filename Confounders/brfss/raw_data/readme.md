## BRFSS Confounder Input Data

This directory contains all of the data used to create our BRFSS confounder data, with the exception of the actual BRFSS data, which is larger than github's max file size limit. The BRFSS data can be downloaded from [here](https://www.cdc.gov/brfss/about/archived.htm). To prepare it for the pipeline, please download the "SAS Transport Format" data for each year place the unzipped XPT file in the directory of its respective year. The processing code will convert the XPT files first to the standard SAS format (in the `sas_files` directory) and then to csv format (in the `csv` directory). 

Other files in this directory are as follows:
- `state.txt`: Used to convert state FIPS codes to standard postal codes
- `esri_zipcode_2010.csv`: Used to link the county level values