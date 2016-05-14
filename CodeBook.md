
Getting and Cleaning Data Project

Description

This is information for replicating the import and cleaning of the Samsung accelerometer data


data Set Information from website

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Check the README.txt file for further details about this dataset. 

A video of the experiment including an example of the 6 recorded activities with one of the participants can be seen in the following link: [Web Link]

An updated version of this dataset can be found at [Web Link]. It includes labels of postural transitions between activities and also the full raw inertial signals instead of the ones pre-processed into windows.


Attribute Information:

For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.



1. Load required packages

## load all packages neede

install.packages('downloader', repos='http://cran.us.r-project.org')
install.packages('plyr')


library(downloader)
library(plyr)




Merges the training and the test sets to create one data set.



## download data

link <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"     
download(link,dest = "rawdata.zip")
unzip("rawdata.zip")

## take a look at the name of the downloaded data
dir()

##  Change my working directory to the UCI HAR Dataset folder
setwd("C:/Users/Tristan/R projects/Cleaning_data_assignment/UCI HAR Dataset")

##List files in this directory  - and locate the test and train folders
dir()

## see what is in these folders
list.files("./test")
list.files("./train")

## Read data for x in to R

x_test <- read.table("test/X_test.txt")
x_train <- read.table("train/X_train.txt")


## Read data for Y in to R

y_test <- read.table("test/Y_test.txt")
y_train <- read.table("train/Y_train.txt")

## Read data for subject in to R

subject_test <- read.table("test/subject_test.txt")
subject_train <- read.table("train/subject_train.txt")

dim(subject_test)
dim(subject_train)


## Descriptive activity names

activitylabels<-read.table(file.path("activity_labels.txt"), col.names = c("Id", "activity"))

# Features labels
featurelabels<-read.table(file.path("features.txt"), colClasses = c("character"))


#1.Merges the training and the test sets to create one data set.
train_data<-cbind(cbind(x_train, subject_train), y_train)
test_data<-cbind(cbind(x_test, subject_test), y_test)
all_data<-rbind(train_data, test_data)


Extracts only the measurements on the mean and standard deviation for each measurement.


## Extracts only the measurements on the mean and standard deviation for each measurement.

mean_std <- all_data[,grepl("mean\\(\\)|std\\(\\)|Subject|Id", names(all_data))]




Uses descriptive activity names to name the activities in the data set


## Name activities

mean_std <- join(mean_std, activitylabels, by = "Id", match = "first")
mean_std <- mean_std[,-1]

head(mean_std)  ##check
str(mean_std)



Appropriately labels the data set with descriptive variable names.


## Label with descriptive names

names(mean_std) <- gsub("([()])","",names(mean_std))
names(mean_std) <- make.names(names(mean_std))
names(mean_std)<-gsub("BodyBody", "Body", names(mean_std))
names(mean_std)<-gsub("Acc", "Accelerometer", names(mean_std))
names(mean_std)<-gsub("Gyro", "Gyroscope", names(mean_std))
names(mean_std)<-gsub("^t", "time", names(mean_std))
names(mean_std)<-gsub("^f", "frequency", names(mean_std))
names(mean_std)<-gsub("Mag", "Magnitude", names(mean_std))


From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



## create second dataset with averages
final <-aggregate(. ~subject + activity, clean, mean)
final <- final[order(final$subject,final$activity), ]

##Create output dataset
write.table(final, file = "cleaned_data.txt",row.name=FALSE)


















