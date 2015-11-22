library(plyr) 
library(data.table)
library(dplyr) 



temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
unzip(temp, list = TRUE)
YTest <- read.table(unzip(temp, "UCI HAR Dataset/test/y_test.txt"))
XTest <- read.table(unzip(temp, "UCI HAR Dataset/test/X_test.txt"))
SubjectTest <- read.table(unzip(temp, "UCI HAR Dataset/test/subject_test.txt"))
YTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/y_train.txt"))
XTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/X_train.txt"))
SubjectTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/subject_train.txt"))
Features <- read.table(unzip(temp, "UCI HAR Dataset/features.txt"))
unlink(temp) 

colnames(XTrain) <- t(Features[2])
colnames(XTest) <- t(Features[2])

XTrain$activities <- YTrain[, 1]
XTrain$participants <- SubjectTrain[, 1]
XTest$activities <- YTest[, 1]
XTest$participants <- SubjectTest[, 1]

dataset <- rbind(XTrain, XTest)
duplicated(colnames(dataset))
dataset <- dataset[, !duplicated(colnames(dataset))]

#setwd("D:/workspace_R/")
#write.csv(x = dataset,file = "D:/workspace_R/merge.csv")

Mean <- grep("mean()", names(dataset), value = FALSE, fixed = TRUE)

Mean <- append(Mean, 471:477)
InstrumentMeanMatrix <- dataset[Mean]

STD <- grep("std()", names(dataset), value = FALSE)
InstrumentSTDMatrix <- dataset[STD]

dataset$activities <- as.character(dataset$activities)
dataset$activities[dataset$activities == 1] <- "Walking"
dataset$activities[dataset$activities == 2] <- "Walking Upstairs"
dataset$activities[dataset$activities == 3] <- "Walking Downstairs"
dataset$activities[dataset$activities == 4] <- "Sitting"
dataset$activities[dataset$activities == 5] <- "Standing"
dataset$activities[dataset$activities == 6] <- "Laying"
dataset$activities <- as.factor(dataset$activities)

names(dataset)  # survey the data
names(dataset) <- gsub("Acc", "Accelerator", names(dataset))
names(dataset) <- gsub("Mag", "Magnitude", names(dataset))
names(dataset) <- gsub("Gyro", "Gyroscope", names(dataset))
names(dataset) <- gsub("^t", "time", names(dataset))
names(dataset) <- gsub("^f", "frequency", names(dataset))


dataset$participants <- as.character(dataset$participants)
dataset$participants[dataset$participants == 1] <- "Participant 1"
dataset$participants[dataset$participants == 2] <- "Participant 2"
dataset$participants[dataset$participants == 3] <- "Participant 3"
dataset$participants[dataset$participants == 4] <- "Participant 4"
dataset$participants[dataset$participants == 5] <- "Participant 5"
dataset$participants[dataset$participants == 6] <- "Participant 6"
dataset$participants[dataset$participants == 7] <- "Participant 7"
dataset$participants[dataset$participants == 8] <- "Participant 8"
dataset$participants[dataset$participants == 9] <- "Participant 9"
dataset$participants[dataset$participants == 10] <- "Participant 10"
dataset$participants[dataset$participants == 11] <- "Participant 11"
dataset$participants[dataset$participants == 12] <- "Participant 12"
dataset$participants[dataset$participants == 13] <- "Participant 13"
dataset$participants[dataset$participants == 14] <- "Participant 14"
dataset$participants[dataset$participants == 15] <- "Participant 15"
dataset$participants[dataset$participants == 16] <- "Participant 16"
dataset$participants[dataset$participants == 17] <- "Participant 17"
dataset$participants[dataset$participants == 18] <- "Participant 18"
dataset$participants[dataset$participants == 19] <- "Participant 19"
dataset$participants[dataset$participants == 20] <- "Participant 20"
dataset$participants[dataset$participants == 21] <- "Participant 21"
dataset$participants[dataset$participants == 22] <- "Participant 22"
dataset$participants[dataset$participants == 23] <- "Participant 23"
dataset$participants[dataset$participants == 24] <- "Participant 24"
dataset$participants[dataset$participants == 25] <- "Participant 25"
dataset$participants[dataset$participants == 26] <- "Participant 26"
dataset$participants[dataset$participants == 27] <- "Participant 27"
dataset$participants[dataset$participants == 28] <- "Participant 28"
dataset$participants[dataset$participants == 29] <- "Participant 29"
dataset$participants[dataset$participants == 30] <- "Participant 30"
dataset$participants <- as.factor(dataset$participants)


dataset.dt <- data.table(dataset)

TidyData <- dataset.dt[, lapply(.SD, mean), by = 'participants,activities']
write.table(TidyData, file = "tidy.txt", row.names = FALSE)
