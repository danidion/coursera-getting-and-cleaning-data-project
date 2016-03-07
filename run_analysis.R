install.packages("reshape2")
library(reshape2)

filename <- "getdata_dataset.zip"

### Download and unzip the dataset:
  fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip1"
  download.file(fileURL1, destfile="dataset.zip")
  unzip("dataset.zip") 


### Load activity labels + features
activityLabels1 <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels1[,2] <- as.character(activityLabels1[,2])
features1 <- read.table("UCI HAR Dataset/features.txt")
features1[,2] <- as.character(features1[,2])

### Extract only the data on mean and standard deviation
features2 <- grep(".*mean.*|.*std.*", features1[,2])
features2.names <- features1[features2,2]
features2.names = gsub('-mean', 'Mean', features2.names)
features2.names = gsub('-std', 'Std', features2.names)
features2.names <- gsub('[-()]', '', features2.names)


### Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[features2]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[features2]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

### merge datasets and add labels
mergeData <-rbind(train, test)
colnames(mergeData) <- c("subject", "activity", features2.names)

### turn activities & subjects into factors
mergeData$activity <- factor(mergeData$activity, levels = activityLabels1[,1], labels = activityLabels1[,2])
mergeData$subject <- as.factor(mergeData$subject)

mergeData.melted <- melt(mergeData, id = c("subject", "activity"))
mergeData.mean <- dcast(mergeData.melted, subject + activity ~ variable, mean)

write.table(mergeData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)