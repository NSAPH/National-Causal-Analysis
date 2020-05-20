## Reading Social Explorer Data

library(dplyr)
library(yaml)

process_csv <- function(path, structure, varname) {
  info <- read.csv(path)
  
  info$zcta <- info[[structure$zcta]]
  if (is.numeric(info$zcta)) {
    info$zcta <- sprintf("%0.5d", info$zcta)
  }
  info$num <- 0
  for (var in structure$num) {
    var <- paste0(structure$prefix, var)
    info$num <- info$num + info[[var]]
  }
  
  if (!is.null(structure$den)) {
    info$den <- 0
    for (var in structure$den) {
      var <- paste0(structure$prefix, var)
      info$den <- info$den + info[[var]]
    }
    info[[varname]] <- info$num/info$den
  } else {
    info[[varname]] <- info$num
  }
  
  info <- select(info, zcta, varname)
  return(info)
}

make_start_structure <- function(zcta_list_path, start_year, end_year) {
  zcta_list <- read.csv(zcta_list_path)
  out <- zcta_list
  out$year <- start_year
  for (i in (start_year + 1):end_year) {
    year_zcta <- zcta_list
    year_zcta$year <- i
    out <- rbind(out, year_zcta)
  }
  
  return(out)
}

covar_structure <- yaml.load_file("census_list.yml")

root_path <- "~/shared_space/ci3_confounders/social_explorer"
merged_data <- make_start_structure("zcta_list.csv", 1999, 2016)
for (var in names(covar_structure)) {
  rm(variable_data)
  print(var)
  for (src in names(covar_structure[[var]])) {
    for (year in 2000:2016) {
      if(dir.exists(file.path(root_path, var, src,  "zcta", year))) {
        print(year)
        csv_path <- file.path(root_path, var, src,  "zcta", year, list.files(file.path(root_path, var, src,  "zcta", year), pattern = "csv"))
        
        #determine what structure to use
        data_key <- names(covar_structure[[var]][[src]])
        data_key <- data_key[data_key >= year]
        if (length(data_key) == 0) {
          break
        }
        data_key <- data_key[1]
        
        if (covar_structure[[var]][[src]][[data_key]] == "skip") {
          print("next")
          next
        }
        
        year_data <- process_csv(csv_path, covar_structure[[var]][[src]][[data_key]], var)
        year_data$year <- year
        if (!exists("variable_data")) {
          variable_data <- year_data
        } else {
          variable_data <- rbind(variable_data, year_data)
        }
      }
    }
  }
  if (!exists("merged_data")) {
    merged_data <- variable_data
  } else {
    merged_data <- merge(x = merged_data, y = variable_data, by = c("zcta", "year"), all = TRUE)
  }
}

write.csv(merged_data, "census_zcta_uninterpolated.csv", row.names=F)

###
