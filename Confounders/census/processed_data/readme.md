## Census Pipeline Output

This directory is left empty as the final products of the census
pipeline are larger than Github's file size limit. However running the 
`make.R` file in the `code` directory will recreate the final products. The files created
will be the following:

- census_zcta_uninterpolated.csv: Demographic values calculated at the zcta level, includes missingness
- census_zcta_interpolated.csv: Demographic values calculated at the zcta level, with missing values replaced
    by a moving average model for each ZCTA.
- census_uninterpolated_zips.csv: Demographic values crosswalked from the zcta level to zip codes, includes missingness
- census_interpolated_zips.csv: Demographic values crosswalked from zcta to zip codes, with missing values replaced by a moving average model for each ZCTA.