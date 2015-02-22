Codebook.md

Data for this project were manually downloaded from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
using Google Chrome and unzipped into ~/R/UCI.

All unzipped files from subdirectories were copied into ~/R/UCI 

These files consist of:

activity_labels.txt
	A table relating the activity codes (found in y_test/train) to activities performed by the subjects.
	
features.txt
	A table describing the measurements/statistics derived from the wearable computing data. 
	This table contains the labels for the data found in X_test/train 
	
subject_test/train.txt 
	Two separate files (subject_test or subject_train) containing the subject ids corresponding to measurements in X_test/train.
	(i.e. which subjects are generating these measurements)
	
X_test/train.txt
	Unlabeled test/training measurements/statistics. 
	
y_test/train
	The activities (see activity_labels.txt) for each set of measurements/statistics in X_test/train.

clean_data.txt 
	A series of tables containing column means of each of the "mean" or "st.dev" variables in features.txt.
	These are split by subject, and then activity.
	
	A table which describes variables for subject #30, while walking would be designated
	30.WALKING
	

	
Objective #1
X_test/train.txt were transformed to data.frame using read.table.
Values were "" seperated
Training set had 7352x561 row x col
Test set had 2947x561

X_test and X_train were concatenated using rbind function. So that X_test results followed X_train results.

After concatenation using rbind, 10299 x 561
In subsequent objectives, y_test/train and subject_test/train were concatenated in a respective manner.

Objective #2 
Read.table of features_set.txt created a data frame 
561 x 2 
Each row contains a feature(column 2), and a code for that feature(column 1).

These features correspond to the 561 dependent variables in X_test/train.

Using grep("mean", features_set[,2]) (similarly for "std")
I pulled out the codes corresponding to features representing the mean and st. dev of measurements into a numeric vector, which was then ordered ascending.

These codes were used to subset the data.frame created in Objective #1
reducing it from 10299 x 561 to 10299 x 46 rows x col.
Since the vector was ordered, the order of the new data frame is also preserved.


Objective #3
Concatenated y_test/train as in Objective #1 to create a 10299 x 1 data.frame
The single column is the activity codes found in activity_labels.txt

Read activity_labels.txt in as a 6 x 2 data frame.

I made a function that relates the activity code(found in column 1 of activity_labels)
to the activity(i.e. WALKING, found in column 2)

assignactivity <- function(activitycode)
{
        activity <- activity_name[activitycode,2]
        return(activity)
}
full_activity <- sapply(full_activity, assignactivity)

I then sapply this over y_test/train to convert the codes to labels.

These labels were then cbind to the last column of the data frame from OBJ2.

Objective #4

I used the vector containing the feature codes created in Objective #2 (codes for means and std. devs)
to extract a character vector from features data table in which each row corresponds to a code. 

colnames() was used to set the names of first 46 columns from the data frame to this character vector.

Objective #5

Concatenated the subject numbers from train and test to create a 10299 x 1 data table.
This was concatenated to the beginning of the large dataframe from OBJ4 to give a 10299 x 48.

I split the dataframe into a list of dataframes sorted by subject and activity using:

split_list <- split(df, list(df$SUBJECT, df$ACTIVITY)

Since there are 30 subjects with 6 activities each, the list has a length of 180.

Since each list item is now labeled with the subject# and activity name, we can strip out these extraneous columns to make data more tidy.
The subject# is the first column, and the activity_name is in the last (48th) column.

split_list <- lapply(split_list,"[",2:(last_col - 1))

Since this operation has removed the character vector in the last column (activity label)
we can just take the column means across the list.

sapply(split_list, colMeans)

Then we write.table(row_labels = FALSE) this to clean_data.txt.


 