This file explains the run_analysis.R file.

The run_analysis.R script analyzes and merges data from an experiment titled "Human Activity Recognition Using Smartphones".  30 volunteers with smart phones engaged in six everyday activities.  Data from the accelerometer and gryoscope of each phone was recorded in 2.56 second windows. Raw data, files containing features calculated form the raw data, and explanations of the experiment, variables, and data files may be found at this link:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Authors of study:  Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory at Università degli Studi di Genova in Genova, Italy.

The run_analysis.R script performs two main functions.  It merges the test data sets and training data sets.  It also calculates feature means of each subject-activity combination from the measurement data provided at the link.  Only the mean and standard deviation measurements are processed in this script.

This script must be in the users R working directory.  The unzipped files found at the link must also be in the working directory.


The script is split into six parts.

Step 1 reads and merges the training and test data sets.  The test and training raw intertial data sets are merged, as are the summary statistics found in the x and y data files.  The features, activities, and subject data are read into memory.

Step 2 finds those features from the x data files that are means or standard deviations.  It keeps these values and deletes all other summary statistics.  The features vector with the variable names is similarly reduced.

Step 3 replaces an integer index of activities with the descriptive factors: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, and LAYING.

Step 4 renames the column headings according the "feature" file.  It removes the end parentheses, and adds the suffix "_avg_over_subject-activity" to indicate that all features are (after Step 5) averaged over unique subject-activity combinations.

Step 5 uses the aggregate function to calculate the mean over each subject-activity combinations.  This is the final tidy data set and is labeled "TidyX".

Step 6 writes TidyX to a text file in the working directory titled "TidyX.txt".

