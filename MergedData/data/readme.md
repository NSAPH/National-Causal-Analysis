# Data Folder

This directory should contain all raw data and processed data used by a given project.All csv and rds files within this directory are assumed to be large and by default are not tracked by git. If there
are a large number of data files additional internal structure is recommended. The `.gitignore` file will need to be 
updated if more structure is used. One common paradign is to have a `data/raw_data` directory storing unedited files
as receinved from the source and a `data/analysis_data` folder containing the assembled and cleaned data ready for use with
models.

