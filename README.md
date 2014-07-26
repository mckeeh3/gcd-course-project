Getting and Cleaning Data - Course Project
==================

This project contains a R script the processes the raw data that was captured in the
[Human Activity Recognition Using Smartphones Data Set]
(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#).
The data set information and dowload links are provided there.

The R script 
<code>run_analysis.R</code>
provided in this project is setup to download the zip file
located at the dowload site found in the above link. This script downloads the 
zip file and processes the raw data producing a tidy data file. The contents
and format of the tidy data file is defined in the code book document (CodeBook.md).

To produce the tidy data source the
<code>source("run_analysis.R")</code>
script in R. When sourced the script
runs as follows:

* downloads for Human Activity Recognition Using Smartphones Data Set zip file
* unzips the files into a local directory located in the current directory
* merges the train and test files
* extracts only the measurements on the mean and standard deviation fields from the merged data
* takes the descriptive feature names and uses them to name the fields in the data
* reshapes the data into a second, independent tidy data set with the average of each variable for each activity and each subject

When the script completes the tidy data is available in R named tidy. The data has also been written
to a text file named "uci-har-dataset-tidy.csv".
