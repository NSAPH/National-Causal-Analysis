Confounder Data Preperation
================
Ben Sabath
June 16, 2021

This directory contains the pipelines preparing data used as confounders
in Xiao Wu’s statistical analysis. Each directory within this directory
contains a single pipeline, along with detailed documentation of the
pipeline itself.

The directories are as follows:

  - `brfss`: smoking and BMI data from the CDC’s Behavioral Risk Factor
    Surveillance System. Additional downloading of the source data is
    necessary to run this pipeline.
  - `census`: zip code level demographic data from Social Explorer. All
    data needed to recreate this data is provided in this directory.
  - `eath_engine`: zip code level temperature, humidity, and
    precipitation data from Google Earth Engine. Additional data
    downloads are needed to reproduce this pipeline.
