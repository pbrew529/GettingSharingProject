# Getting and Sharing Data Project Course Project

## Overview
This project contains a script that process the UCI Har data set and produces a tidy data set
The included code book describes the contents of the tidy data set 

##Prerequisites to run the script
###R version and package dependecies
The script file was developed using R version 3.2.3, it depends on the packages data.table and resahape2 to run correctly.

To install those packages in R, run the following commmands

install.packages("data.table")

install.packages("reshape2")

### Data
The script uses data obtained from this link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should first download that data and unzip it into your R working directory - you should end up with a folder called "UCI Har Dataset" in your working directory

	
The folder structure will also contain a set of files as described in this link
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

If you do not download and unzip the data set as described, the script will identify that the "UCI HAR Dataset" folder is missing and will download and unzip the files for you.

## Running The script
* Download the run_analysis.R file to your R working directory
* Open R and source the file with the following command: source('./run_analysis.R')
* Type runAnalysis() at the R prompt

## What the script does
### Initial steps
* Uses file.exists to see if the "UCI Har Data" folder exists
** If the folder does not exists downloads and unzips the data set

### For part One of the assignment (Merge test and training data to one set)
* Loads the data.table library (This allows for faster reading and processing of the data)
* uses fread to read the test and train raw data sets
* uses fread to load the subject and activity data for each observation
* uses cbind to append subject and activity data to the test and train sets
* uses rbind to combine the test and training data sets

### For part two of the assignment (Extracts only the measurements on the mean and standard deviation for each measurement)
* Reads the header data from features.txt
* Identifies column names containing the words "mean" or "std" using regular expressions (grepl)
* subsets the data from part one to the "mean" and "std" columns only


### For part Three of the assignment (Uses descriptive activity names to name the activities in the data set)
* reads the activity descriptive names from activity_labels.txt
* uses merge to append those lables to th eoriginal data set joining on thee activity id field from each set
* Subsets the data again removing the activity id fields from the merge command

### For part four of the assignment (Appropriately labels the data set with descriptive variable names)
* Reuse the data from step to obtained from the features.txt file
* Using the sub function and regular expressions rename the measurement data headers into human readable names
* Appends the new column names to the data set

### For part five of the assignment (From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject)
* Loads the reshape2 library
* Sets the ID and measure columns and melts the data set (Melted data set)
* Uses dcast to apply the means grouping by activity and by subject(Final tidy data set)
* Writes the tidy data to a file
* Returns the tiday data to the user