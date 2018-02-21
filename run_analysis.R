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

library(readr)
library(stringr)

test_X <-  read_table("./test/X_test.txt", col_names=FALSE)
train_X <- read_table("./train/X_train.txt", col_names=FALSE)

test_Y <-  read_table("./test/y_test.txt", col_names=FALSE)
train_Y <- read_table("./train/y_train.txt", col_names=FALSE)

#1 - merge train and test data sets
y <- rbind(train_Y, test_Y)
X <- rbind(train_X, test_X)

features <- read_delim("features.txt", delim=" ", col_names = FALSE)
names(X) <- features$X2

#2 - here we take any feature that is a mean() or std() measurement, but *not* "meanFreq()"
mean_or_std <- grepl("mean\\(|std\\(", names(X))
X <- X[,mean_or_std]

#3 - descriptive activity names
activities <- read_delim("activity_labels.txt", delim=" ", col_names = FALSE)
y <- merge(y, activities, by = "X1")

#4 - clean up the variable (column) names a bit, but still use names provided in features.txt
names(X) <- str_replace_all(names(X), c("\\(" = "", "\\)" = ""))

#5 - a tidy data set of just the mean for each measurement/subject
X_means <- X[,grepl("mean", names(X))]
names(X_means) <- str_replace(names(X_means), "-mean", "")
tidy <- cbind(y, X_means)
tidy_names <- names(tidy)
tidy_names[1:2] <- c("subject_id", "activity")
names(tidy) <- tidy_names

# export data set for submittal
write.table(tidy, file="./tidy.txt", row.names = FALSE)
