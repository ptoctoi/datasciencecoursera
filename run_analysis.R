## Read files

#Activity 
activity <- read.table("C:\\Users\\ptocto\\Documents\\UCI HAR Dataset\\activity_labels.txt")

#Features 
features <- read.table("C:\\Users\\ptocto\\Documents\\UCI HAR Dataset\\features.txt")

# Train files
xtrain <- read.table("C:\\Users\\ptocto\\Documents\\UCI HAR Dataset\\train\\X_train.txt")
ytrain <- read.table("C:\\Users\\ptocto\\Documents\\UCI HAR Dataset\\train\\Y_train.txt")
subjtrain <- read.table("C:\\Users\\ptocto\\Documents\\UCI HAR Dataset\\train\\subject_train.txt")

# Test files
xtest <- read.table("C:\\Users\\ptocto\\Documents\\UCI HAR Dataset\\test\\X_test.txt")
ytest <- read.table("C:\\Users\\ptocto\\Documents\\UCI HAR Dataset\\test\\Y_test.txt")
subjtest <- read.table("C:\\Users\\ptocto\\Documents\\UCI HAR Dataset\\test\\subject_test.txt")

# Merge ytrain with activity desc  
ytraindesc <- merge(ytrain,activity,by.x = "activity", by.y = "V1")

# Merge ytest with activity desc  
ytestdesc <- merge(ytest,activity,by.x = "activity", by.y = "V1")

# Filter only column with "mean()" and "std()"
featuresm <- grep("mean()",features)
featuress <- grep("std()",features$V2)
featuresf <- c(featuresm,featuress)

# Filter data only with column "mean()" and "std()"
xtrainsub <- select(xtrain, featuresf)
xtestsub <- select(xtest, featuresf)

# Replace names without "-"
for (i in 1:79)
{
  names(xtrainsub)[i] <-  gsub("-","",features[featuresf[i],2])
  names(xtestesub)[i] <-  gsub("-","",features[featuresf[i],2])
}

# Union ytestdesc,xtestesub
filefinal <- data.frame(ytestdesc,xtestesub)
# Union ytraindesc,xtrainsub
filefinal2 <- data.frame(ytraindesc,xtrainsub)

# Change names
names(filefinal)[1] <-  "Activity"
names(filefinal)[2] <- "desc.activity"

names(filefinal2)[1] <-  "Activity"
names(filefinal2)[2] <- "desc.activity"

#Create data frame of text "Train" and "Test"
vtipotrain <- data.frame(matrix("Train",nrow = 7352, ncol=1))
vtipotest <- data.frame(matrix("Test",nrow = 2947, ncol=1))
names(vtipotrain)[1] <-  "Type Data"
names(vtipotest)[1] <-  "Type Data"

#Union data in order to indicate "Train" or "Test"
filefinaltrain <- data.frame(vtipotest,filefinal)
filefinaltest <- data.frame(vtipotrain,filefinal2)

# Combine data of train and test
FileTrainTest <- rbind(filefinaltrain,filefinaltest)

# Generate mean by subject and activity
tidydata <- aggregate(FileTrainTest[, 5:ncol(FileTrainTest)],
                      by=list(subject = FileTrainTest$subject, 
                              desc.activity = FileTrainTest$desc.activity),
                      mean)
# write final data to disk
write.table(tidydata, file = "./tidy_data.txt", row.name = FALSE)