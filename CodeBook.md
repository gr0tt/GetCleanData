# Goal
This script loads data from the UCI HAR Data set with the overall goal to make a tidy data set.
The tidy dataset averages all variables for each subject and activity.

# Procedure
All relevant steps are integrated in run_analysis.R

It consist of loading the data, processing the data, and finally describes the variables and persist the data frame.

## Data loading
- Download an unzip the [archive](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
- Read the general information 
- Read all data frames from the archive (x and y for training and testing respectively).
- The integer values of the y-data frames are converted to factors
- The y-data set contains only a single column, it is added to the x data frames.
- Both x-data frames are merged by the rbind function.
## Data processing
- Two for loops are used the calculate the mean values for all attributes
- Each loops extracts the relevant columns for one subject or activity values
- NAs are removed by a boolean vector
- The colMeans calculates the mean for each attribute
- A name for the current variable is added to the index list
- The mean values are added to tidy_df
## Description and persisting
- The column names are added
- A column that describes to variable is added, named "charactericForAverage"
- The results are saved in a file called "tidy_data.csv"