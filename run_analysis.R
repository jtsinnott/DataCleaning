###############################################################################
#
# Getting and Cleaning Data Course Project
# 
# Here are the data for the project:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each
# measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
#
#
###############################################################################

library(dplyr)
library(readr)
library(stringr)

features <- read_delim("features.txt", delim=" ", col_names = FALSE)

X_test <- read_table("./test/X_test.txt", col_names=FALSE)
test_subj <- read_table("./test/subject_test.txt", col_names=FALSE)
X_train <- read_table("./train/X_train.txt", col_names=FALSE)
train_subj <- read_table("./train/subject_train.txt", col_names=FALSE)

Y_test <-  read_table("./test/y_test.txt", col_names=FALSE)
Y_train <- read_table("./train/y_train.txt", col_names=FALSE)

#1 - merge train and test data sets
y <- rbind(Y_train, Y_test)
X <- rbind(X_train, X_test)
subj <- rbind(train_subj, test_subj)

#3 - descriptive activity names
activities <- read_delim("activity_labels.txt", delim=" ", col_names = FALSE)
y <- merge(y, activities, by = "X1")
y <- y[,2]
names(y) <- c("activity")
y <- as.factor(y)
X <- cbind(y, X)

X <- cbind(subj, X)

#4 - use names provided in features.txt
all_columns <- c("subjectid", "activityid", features$X2)

#2 - here we take any feature that is a mean() or std() measurement, but *not* "meanFreq()"
keep_columns <- c(TRUE, TRUE, grepl("mean\\(|std\\(", features$X2))
X <- X[,keep_columns]
names(X) <- all_columns[keep_columns]

#5 - a tidy data set of the mean of each variable for each measurement/subject
X_means <- X %>% group_by(subjectid, activityid) %>% summarise_all(mean)
write.table(X_means, file="./tidy.txt", row.names = FALSE)
