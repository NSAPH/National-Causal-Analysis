## Output Temperature Data

This directory should contain the output of the entire earth engine pipeline. Due to Github's 
storage constraints, we only include the data sets ultimately used in the final analysis here. All data covers the period from Jan 1, 2000 to April 30th, 2020.

Those two data sets are as follows:
- `temperature_seasonal_zipcode_combined.csv`: Winter and summer mean daily max temperature and max relative humidity for all zip codes. Polygons are used to define zip code areas for area weighted means where possible, otherwise centroid estimates are used.
- `temperature_annual_zipcode_combined.csv`: Annual mean daily max temperature, precipitation, and humidity for all zip codes. Polygons are used to define zip code areas for area weighred means where possible, otherwise centroid estimates are used.

Additional data produced by the pipeline is as follows:
- temperature_annual_zipcode_centroid.csv: Annual mean temperature, precipitation, and humidity for all zip codes. The max temperature at the zip code centroid is used.
- temperature_annual_zipcode_polygon.csv: Annual mean daily max temperature, precipitation, and humidity for all zip codes. Area weighted means of the max temperature are used. Zip codes without defined polygons are excluded from this data set.
- temperature_daily_zipcode_centroid.csv: Daily max temperature values. The max temperature at the zip code centroid is used.
- temperature_daily_zipcode_combined.csv: Daily max temperature values. Polygons are used to define zip code areas for area weighted means where possible, otherwise centroid estimates are used.
- temperature_daily_zipcode_polygon.csv: Daily max temperature values. Area weighted means of the max temperature are used. Zip codes without defined polygons are excluded from this data set.