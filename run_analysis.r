## script to import data, tidy and clean and create final output table



## load all packages neede

install.packages('downloader', repos='http://cran.us.r-project.org')
install.packages('plyr')


library(downloader)
library(plyr)


## Set working directory
setwd("C:/Users/Tristan/R projects/Cleaning_data_assignment")


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


labels<-rbind(rbind(featurelabels, c(562, "Subject")), c(563, "Id"))[,2]
names(all_data)<-labels


## Extracts only the measurements on the mean and standard deviation for each measurement.

mean_std <- all_data[,grepl("mean\\(\\)|std\\(\\)|Subject|Id", names(all_data))]

head(mean_std)  ## view and check

## Name activities

mean_std <- join(mean_std, activitylabels, by = "Id", match = "first")
mean_std <- mean_std[,-1]

head(mean_std)  ##check
str(mean_std)


## Label with descriptive names

names(mean_std) <- gsub("([()])","",names(mean_std))
names(mean_std) <- make.names(names(mean_std))
names(mean_std)<-gsub("BodyBody", "Body", names(mean_std))
names(mean_std)<-gsub("Acc", "Accelerometer", names(mean_std))
names(mean_std)<-gsub("Gyro", "Gyroscope", names(mean_std))
names(mean_std)<-gsub("^t", "time", names(mean_std))
names(mean_std)<-gsub("^f", "frequency", names(mean_std))
names(mean_std)<-gsub("Mag", "Magnitude", names(mean_std))

##check
names(mean_std)
dim(mean_std)


## create second dataset with averages
final <-aggregate(. ~subject + activity, clean, mean)
final <- final[order(final$subject,final$activity), ]

##Create output dataset
write.table(final, file = "cleaned_data.txt",row.name=FALSE)

