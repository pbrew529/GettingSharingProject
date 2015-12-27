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

You should first download that data and unzip it into your R working directory - this should create a folder structure like this:
*./ 
**UCI HAR Dataset
***test
****internal signals
***train
****internal signals
	
The folder structure will also contain a set of files as described in this link
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

If you do not download and unzip the data set as described, the script will identify that the "UCI HAR Dataset" folder is missing and will download and unzip the files for you.

## Running The script
* Download the run_analysis.R file to your R working directory
* Open R and source the file with the following command: source('./run_analysis.R')
* Type runAnalysis() at the R prompt

## What the script does


