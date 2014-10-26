
#run_analysis that does the following. 
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#download and unzip files
if (file.exists("./data")) {
    setwd("./data") 
} else {
    dir.create("./data")
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, "./data/Sensor.zip", method="curl")
    setwd("./data")
    unzip("Sensor.zip")
}

# read train data
trainSubject<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
trainY<-read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
trainX<-read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)


# read test data
testSubject<-read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
testY<-read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
testX<-read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)

#merge test and train datasets
Subject <- rbind(trainSubject, testSubject)
Activities <- rbind(trainY, testY)
Readings <- rbind(trainX, testX)


#append activities label
activityLabels<-read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE)
colnames(Activities) <- "Activity"
Activities[Activities == 1] = "WALKING"
Activities[Activities == 2] = "WALKING_UPSTAIRS"
Activities[Activities == 3] = "WALKING_DOWNSTAIRS"
Activities[Activities == 4] = "SITTING"
Activities[Activities == 5] = "STANDING"
Activities[Activities == 6] = "LAYING"

#append Subject label
colnames(Subject) <- "Subject"
#overall cleaned up dataset
totalData <- cbind(Interested_Readings, Activities, Subject)

#tidy dataset
id_labels = c("Subject", "Activity")
data_labels = setdiff(colnames(totalData), id_labels)
melt_data = melt(totalData, id = id_labels, measure.vars = data_labels)
tidyData = dcast(melt_data, Subject + Activity ~ variable, mean)

#write to file
write.csv(totalData, file="./tidy.csv")
