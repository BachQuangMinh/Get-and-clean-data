# Get-and-clean-data
This is a repository for the course 'Get and clean data' on Coursera
In this project I did the following things:

1. Merges the training and the test sets to create one data set.
First the file features.txt was read in.
A few steps of processing the names were done to make the names look nicer:

_There are 561 features in total.

_The characters '()' in the names are removed. '-' and ',' were replaced with '.'

_Abbreviation such as 't' and 'f' were replaced with 'time' and 'freq.' respectively.

_The file activity_labels.txt was read into the *activity_labels* variable.

1.1 Prepare the train set
The training set was prepared as the y labels (the activities labels) were matched with the X_train.txt file.
The result is saved in the *data_train* variable.

1.2 Prepare the test set 
The test set is prepared in a similar way as the train set. 
The result is saved in the *data_test* variable.

1.3 Combine the data
The train set and the test set are combined and the result is saved in the combine_data variable.

2. Extracts only the measurements on the mean and standard deviation for each measurement.
For each measurement, the mean and the standard deviation contains the string 'mean' and 'std', respectively.

To extract the names containing these string, first, a boolean vector was created using the **grep** function with the regular expression '(mean)|(std)'.

This vector was then used to filter the *combine_data* with the **select** function.

3.	Uses descriptive activity names to name the activities in the data set
The *combine_data* and the *activity_label* was merged on the indices to get the descriptive activity names.
The result is saved in the *activity_name* variable.

4.	Appropriately labels the data set with descriptive variable names.
This has already been done in the begining of step 1.

5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
For each subject, the mean of the measurements of each variable should be computed for each activity.

There are 30 subjects and each subject has 6 activities. So the whole data set will have 30x6 = 180 rows.

With the *activity_name*, a **group_by** function was performed on first the 'subject' column, then the 'activity.labels' columns

Then **summarise_at** function was use on all columns except for 'subject', 'activity.labels' and 'activity.index', applying the function **mean**.

The result was saved in the variable *average*, which is eventually saved as the *tidy.xlsx* data set.

