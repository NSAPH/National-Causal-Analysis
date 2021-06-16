Preparation of Data and Statistical Analysis
================
Ben Sabath
June 16, 2021

This directory contains code covering the creation of the data set used
for analysis by Xiao Wu in the paper “Evaluating the Impact of Long-term
Exposure to Fine Particulate Matter on Mortality Among the Elderly.”.

The directory `Confounders` contains the process by which the zip code
level demographic data, smoking and BMI data, and weather data are
acquired and prepared for use. `Exposures` describes the preparation of
the PM2.5 data. Please note that we are unable to provide the code and
workflow, as our exposure data is provided by our collaborators.
However, the PM2.5 exposure data we used is available for download
[here](https://beta.sedac.ciesin.columbia.edu/data/set/aqdh-pm2-5-concentrations-contiguous-us-1-km-2000-2016).
`HealthOutcomes` contains the code used to select data from the Medicare
Beneficiary Summary Files. Finally, `MergedData` contains the process by
which all these data sources are combined and cleaned in order to be
analyzed by the code in `StatisticalAnalysis`.

We have included as much data as we are allowed to share and can
feasibly include in a github repo (some files are too large to share).
Where we are unable to share data, we have provided instructions on how
to acquire the source data and prepare it for use with the data
pipelines.

## Table of Contents

The directories can be read in any order; however, reading in the
following order reflects how data flows in the pipeline.

  - [Confounders](Confounders/readme.md) Overview of non health, non
    pm2.5 data used.
      - [Census Data](Confounders/census/readme.md) (All data needed
        provided)
      - [Smoking and BMI](Confounders/brfss/readme.md) (Some external
        data Downloads needed)
      - [Temperature and Humidity](Confounders/earth_engine/readme.md)
        (Some external data downloads needed)
  - [PM2.5 Data](Exposures/readme.md) (Not fully reproducible)
  - [Medicare Mortality Data](HealthOutcomes/readme.md) (Additional Data
    Acquisition Needed)
  - [Merging Process](MergedData/readme.md)
  - [Statistical Analysis](StatisticalAnalysis/README.md)
