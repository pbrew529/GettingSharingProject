getSourecData <- function(){
        
        fileurl <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        filesavepath <- "Dataset.zip"   
        
        # Download and extract
        download.file(fileurl, filesavepath)
        wd<-getwd()
        unzip(filesavepath, exdir = wd)
        testdir <- "UCI HAR Dataset/test/"
        traindir<-"UCI HAR Dataset/train/"
        
        list.files( testdir, recursive = T)
        list.files(traindir , recursive = T)
}


runAnalysis <- function(){

# Check if the directory exists from the extracted zip file        
        if(!file.exists("UCI HAR Dataset")){
                getSourecData()
        }



#1.) Merge training and test sets into one data set
#Data tables faster read and merge 
        library(data.table)
        
        testfile <- "UCI HAR Dataset/test/X_test.txt" 
        testdata <- fread(testfile, sep = "auto" , header = F ,   na.strings ="", stringsAsFactors= F)
        testsubjects <- fread("UCI HAR Dataset/test/subject_test.txt",sep = "auto" , header = F ,  na.strings ="", stringsAsFactors= F) 
        colnames(testsubjects) <- "subjectID"
        testactivities <- fread("UCI HAR Dataset/test/y_test.txt",sep = "auto" , header = F ,  na.strings ="", stringsAsFactors= F) 
        colnames(testactivities) <- "activityID"
        
        # Data set containing test data using cbind
        #First Column is subject ID second column is activity ID
        testdata <- cbind(testsubjects, testactivities, testdata)
        
        trainfile <- "UCI HAR Dataset/train/X_train.txt" 
        traindata <- fread(trainfile, sep = "auto" , header = F ,  na.strings ="", stringsAsFactors= F)
        trainsubjects <- fread("UCI HAR Dataset/train/subject_train.txt",sep = "auto" , header = F ,  na.strings ="", stringsAsFactors= F) 
        colnames(trainsubjects)<- "subjectID"
        trainactivities <- fread("UCI HAR Dataset/train/y_train.txt",sep = "auto" , header = F ,  na.strings ="", stringsAsFactors= F) 
        colnames(trainactivities) <- "activityID"
        
        # Data set containing training data using cbind
        #First Column is subject ID second column is activity ID
        traindata <- cbind(trainsubjects, trainactivities, traindata)
        
        #Row bind into one large set
        combineddata <- rbind(testdata, traindata)



#2.) extract the mean and stdDev for each measurement
# This part just extracts the columns for means and stddev

        headerfile <- "UCI HAR Dataset/features.txt"
        headerdata <- fread(headerfile,sep = "auto" , header = F , nrows = 561 ,na.strings ="", stringsAsFactors= F)
        
        # Use grepl to identify columns with "mean" or "std" in ther names
        colstouse <- grepl("*std",headerdata$V2)|grepl("mean",headerdata$V2)
        selectcols <- c("subjectID","activityID",paste("V",headerdata[colstouse,]$V1, sep=""))
        
        #Subset data where columns in selected columns (including subjectID and ActivityID)
        data <- subset(combineddata,T , select = selectcols)

#3.) Use descriptive activity names for the data set
        # Read activity descriptive names
        actlabels <- fread("UCI HAR Dataset/activity_labels.txt", sep = "auto" , header = F ,  na.strings ="", stringsAsFactors= F)
        colnames(actlabels) <- c("actid","activity")
        
        #Use merge actid = activityid to join
        data <- merge(actlabels, data, by.x = "actid", by.y = "activityID")
        selectcols <- c("subjectID","activity",paste("V",headerdata[colstouse,]$V1, sep=""))
        data <- subset(data,T,select=selectcols)


#4.) Label the data set with descriptive variable names

# Append Subject Id and Activity labels
        headernames <- c("Subject","Activity",headerdata[colstouse]$V2)

# Items prefixed with t are time
# Items prefixed with f are Fast Fourier Transforms of signals
# Acc = Acceleration
# Mag = magnitude
# X Y and Z are Axes
# Clean up names
        headernames <- sub("tBody", "Timer Body ", headernames)
        headernames <- sub("tGravity", "Timer Gravity ", headernames)
        headernames <- sub("fBody", "Fast Fourier Transform Body ", headernames)
        headernames <- sub("fGravity", "Fast Fourier Transform Gravity ", headernames)
        headernames <- sub("BodyGyro", "Body-Gyroscope ", headernames)
        headernames <- sub(" Gyro", " Gyroscope ", headernames)
        headernames <- sub("BodyAcc", "Body-Acc", headernames)
        headernames <- sub("Acc", "Acceleration ", headernames)
        headernames <- sub("Jerk", "Jerk-Signal ", headernames)
        headernames <- sub("-meanFreq()","Mean-Frequency" ,headernames)
        headernames <- sub("-mean\\(\\)","Mean ", headernames)
        headernames <- sub("-std\\(\\)","Standard Deviation ", headernames)
        headernames <- sub(" Mag"," Magnitude ", headernames)
        headernames <- sub("-X"," X-Axis", headernames)
        headernames <- sub("-Y"," Y-Axis", headernames)
        headernames <- sub("-Z"," Z-Axis", headernames)
        headernames <- sub("\\(\\)","",headernames)
        
        #Remove any double spaces
        headernames <- sub("  "," ", headernames)

        
        colnames(data) <- headernames
        
        data$`Subject` <- as.factor(data$`Subject`)

#5.) Create a tidy data set from step 4 data with the average of each variable for each activity and each subject
        library(reshape2)
        
        meas <- colnames(data)[3:81]
        ids <- colnames(data)[1:2]
        
        datamelt <- melt(data,id=ids, measure.vars = meas)
        finaldata <- dcast(datamelt, Activity + Subject ~ variable, mean)
        colnames(finaldata) <- c(colnames(finaldata)[1:2], paste("Average" ,colnames(finaldata)[3:81]))
        
        # At this point finaldata is already tidy  - in wide format
        write.table(finaldata,file = "TidyAverages.txt", row.name = F)
        
# Retun Final Data
        finaldata


}
