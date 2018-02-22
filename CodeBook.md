# Code Book for Getting and Cleaning Data, Final Project

The test and training data is included in this github repo.
See README.md and README.txt for more info.

The R script run_analysis is in the root of the repo and performs the following 
steps.

- Reads the feature names into a data frame.
- Reads the X and y data from both test and training sets, as well as subject 
data.
- Merges X, y, and subject data (by column) into one data frame.
- Merges train and test data (by row) into one data frame.
- Converts the activity names to factors.
- Removes columns that do not represent a mean() or std() measurement.
- Groups the data by activity and subject, and calculates the mean of each 
remaining variable by activity and subject.
