Temperature, Humidity, Preceipitation Earth Engine Data
================
Ben Sabath
May 27, 2020

## Summary

The temperature and humidity data is sourced from the University of
Idaho’s GRIDMET project. We access it using Google Earth Engine, where
it is available as daily 4km x 4km rasters from January 1st, 2000 until
the present.

To recreate the pipeline to get the GRIDMET temperature data from google
earth engine there are two major steps. The first step involves using
google earth engine to aggregate the source data (splitting up the data
in to multiple files so that it can all be processed) to the zip code
level and downloading the data. In the second step, we combine the
downloaded files in to large single files and calculate seasonal and
annual averages.

## Download steps

First, upload zip code shape files too google earth engine, we used the
zip code centroids and polygons from ESRI for this. Google Earth Engine
doesn’t provide a means for direct download, so the final output files
are exported to Google Drive. They then must be individually downloaded
and stored in a directory before proceeding with the next step. The
files in the directories `code/1_download_temperature_point` and
`code/2_download temperature_polygon` contain the code used to calculate
daily zip code level temperature estimates on google earth engine and
prepare those data for export to google drive.

## Combining the files

First, we combine the daily files for each year for each zip code
geography (`code/3_summarize_point_data.R`,
`code/summarize_polygon_data.T`) in to a single file. We also separately
calculate annual averages for each zip code at this time. As the polygon
zip code file only includes zip codes with non-zero area there are
around 8,000 fewer zip codes listed in that dataset. To resolve this
issue, we create a combined file (`code/5_combine_zips.R`)where we use
the centroid zip code estimate for all zip codes not present in the
polygon estimate. We do this for both the daily and annual estimates.
These combined datasets are the ones that we ultimately use in our
studies, and use to calculate the seasonal averages
(`code/6_calculate_seasonal_averages`)used in our study as well.
