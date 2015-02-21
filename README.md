# getting_cleaning_data_project

(Feb. 2015)

This repo was created for submitting the course project of "Getting and Cleaning Data" within the Data Science Specialization. The purpose of the project was to demonstrate the ability to collect, work with, and clean a data set, that can be used for later analysis. It revolves around one of the most exciting areas in all of data science right now, which is wearable computing. The data represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
A full description is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

This repo includes only a single R script, called run_analysis.R. A detailed description of the script's variables, data and transformation can be found in the code book. Generally speaking, the script does the following:
1.	Merges the training and the test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
3.	Uses descriptive activity names to name the activities in the data set
4.	Appropriately labels the data set with descriptive variable names. 
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. This data set can be found in this repo.

# Important Notes
•	The data must be downloaded and unzipped before running the script.
•	The working directory must have a sub-directory named "UCI HAR Dataset", containing all the files (with the original names and structure).
•	Here is the link from which to download the data:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
