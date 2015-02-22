#run_analysis.R

## OBJECTIVE #1, Merge the training and test sets to create one data set.

### First create data tables for training and test data.
### 

train_set <-read.table("~/R/UCI/X_train.txt")
test_set <-read.table("~/R/UCI/X_test.txt")

### Concatenate these datasets. 

full_set <- rbind(train_set, test_set)

OBJ_1 <- full_set

### This completes Objective #1.




## OBJECTIVE #2, Extract only the measurements 
## On the mean and standard deviaion for each measurement.

### Read the list of features for each measurement to a data table

features_set <- read.table("~/R/UCI/features.txt")

### Find the rows of features_set containing either "std" or "mean"
### These correspond to the means or stdev for each measurement.

means <- grep("mean",features_set[,2])
stdevs <- grep("std",features_set[,2])

### Order them ascending.

means_and_stdevs <- order(as.numeric(means,stdevs))

### Extract only the columns containing means or stdev. 
### These are the column numbers in the vector "means_and_stdev"

full_set_mean_stdev <- full_set[,means_and_stdevs]
#Equivalently, OBJ2 <- OBJ1[,means_and_stdev]

### This completes Objective #2




## OBJECTIVE #3, Use descriptive activity names
## to name the activities in the data set.
##
### The activity names for coded activities (1-6)
### are found in activity_labels.txt
###

activity_name <- read.table("~/R/UCI/activity_labels.txt")

### Create a data table containing the activities
### for each set of measurements
train_activity <- read.table("~/R/UCI/y_train.txt")
test_activity <- read.table("~/R/UCI/y_test.txt")
full_activity <- rbind(train_activity, test_activity)

### Rename activity codes in this table to their corresponding activity.
### the activity_name object is used as a lookup table.
assignactivity <- function(activitycode)
{
        activity <- activity_name[activitycode,2]
        return(activity)
}

### Apply the function over the full list of activities

full_activity <- sapply(full_activity, assignactivity)

### Append activities to corresponding measurements in table from OBJ #2
### onto the last column.

full_set_mean_stdev_activities <- cbind(full_set_mean_stdev, full_activity)

### Objective #3 Complete.




## OBJECTIVE #4 Appropriately label
## the data set with descriptive variable names

### Extract the descriptive variable names 
descriptive_names <- features_set[means_and_stdevs,]
descriptive_names <- descriptive_names[,2]
### Rename the columns to these names
colnames(full_set_mean_stdev_activities) <- descriptive_names
# Equivalently, colnames(OBJ3) <- descriptive_names
# OBJ4 <- OBJ3

### Objective #4 Complete.



## OBJECTIVE #5: From the data set in OBJ4, create a second
## independent tidy data set with the average of each variable
## for each activity and each subject

### Append Subject # at beginning of table.
train_subject <- read.table("~/R/UCI/subject_train.txt")
test_subject <- read.table("~/R/UCI/subject_test.txt")
full_subject <- rbind(train_subject, test_subject)
final_table <- cbind(full_subject, full_set_mean_stdev_activities)
last_col <- ncol(final_table)
### Split by subject#(in column#1), then by activity(in final column)

subj_act_split <- split(final_table, list(final_table[,last_col],final_table[,1]))

### After splitting, then select only numeric columns.
### i.e. exclude the activity column and subject column

subj_act_split_exclude_last <- lapply(subj_act_split,"[",2:(last_col - 1))

### Calculate the mean for each measurement for subjects and activities.
### Save it as a *.txt file

tidy_data <- sapply(subj_act_split_exclude_last, colMeans)
write.table(tidy_data, file = "~/R/clean_data.txt", row.names = FALSE)

###