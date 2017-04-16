# BKp Rev1 Version1 arrange and clean fitness data 

clean_data <- function(){
  
  # read test files  
  
  subject_test = read.table("UCI HAR Dataset/test/subject_test.txt")
  
  X_test = read.table("UCI HAR Dataset/test/X_test.txt")
  
  Y_test = read.table("UCI HAR Dataset/test/Y_test.txt")
  
  
  
  # read training files
  
  subject_train = read.table("UCI HAR Dataset/train/subject_train.txt")
  
  X_train = read.table("UCI HAR Dataset/train/X_train.txt")
  
  Y_train = read.table("UCI HAR Dataset/train/Y_train.txt")
  
  
  
  # read supporting information
  
  features <- read.table("UCI HAR Dataset/features.txt", col.names=c("featureID", "featureLABEL"))
  
  activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activityID", "activityLABEL"))
  
  activities$activityLABEL <- gsub("_", "", as.character(activities$activityLABEL))
  
  includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureLABEL)
  
  
  
  # merge test and training data and then name them
  
  subject <- rbind(subject_test, subject_train)
  
  names(subject) <- "subjectID"
  
  X <- rbind(X_test, X_train)
  
  X <- X[, includedFeatures]
  
  names(X) <- gsub("\\(|\\)", "", features$featureLABEL[includedFeatures])
  
  Y <- rbind(Y_test, Y_train)
  
  names(Y) = "activityID"
  
  activity <- merge(Y, activities, by="activityID")$activityLABEL
  
  
  
  # merge data frames 
  
  data <- cbind(subject,activity,X)
  write.csv(data, "cleandata.csv")
  
  
  # create a dataset grouped by subject and activity after applying standard deviation and average calculations
  
  library(data.table)
  
  secondtable <- data.table(data)
  
  AverageData<- secondtable[, lapply(.SD,mean), by=c("subjectID", "activity")]
  
  write.csv(AverageData, "Average.csv")
  
}