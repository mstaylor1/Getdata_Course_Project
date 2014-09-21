# run_analysis.R

# Script for Course Project of Getting and Cleaning Data
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the
#    average of each variable for each activity and each subject. 
# 6. Writes data to a text file titled "TidX.txt"

# NOTE: Unzipped data and run_analysis.R must be in working directory.

# 1.  STEP ONE:  Merge training and test sets

testPath <- "test/"
trainPath <- "train/"
InertialPath <- "Inertial Signals/"

# Read Inertial data into two lists of data frames, one for Test set, one for train set
#Building file names out of text strings
a <- "body_acc_"; b <- "body_gyro_"; c <- "total_acc_"; d <- "_test"; e <- ".txt" 
testFileNames <- matrix(NA,9,6)
testFileNames[1,] <- c(testPath,InertialPath,a,"x",d,e)
testFileNames[2,] <- c(testPath,InertialPath,a,"y",d,e)
testFileNames[3,] <- c(testPath,InertialPath,a,"z",d,e)
testFileNames[4,] <- c(testPath,InertialPath,b,"x",d,e)
testFileNames[5,] <- c(testPath,InertialPath,b,"y",d,e)
testFileNames[6,] <- c(testPath,InertialPath,b,"z",d,e)
testFileNames[7,] <- c(testPath,InertialPath,c,"x",d,e)
testFileNames[8,] <- c(testPath,InertialPath,c,"y",d,e)
testFileNames[9,] <- c(testPath,InertialPath,c,"z",d,e)
testFileNames <- apply(testFileNames,1,paste,collapse="")
trainFileNames <- gsub("test","train",testFileNames)

# Merge Test data set with Train data set
dataSet <- lapply(trainFileNames,read.table) #makes a list of data frames with inertia data
dataSetTest <- lapply(testFileNames,read.table)
for (i in 1:9) {
    dataSet[[i]] <- rbind(dataSet[[i]],dataSetTest[[i]]) 
}

# Read feature, activity, and subject keys in memory
features <- read.table("features.txt") 
activities <- read.table("activity_labels.txt")
subject_key <- read.table(paste(c(trainPath,"subject_train.txt"),collapse="")) #training set
subject_test <- read.table(paste(c(testPath,"subject_test.txt"),collapse="")) #test set
subject_key <- rbind(subject_key,subject_test) #merges training and test sets

## Read summary data (x, y) into memory
x <- read.table(paste(c(trainPath,"X_train.txt"),collapse=""))
y <- read.table(paste(c(trainPath,"y_train.txt"),collapse=""))
x_test <- read.table(paste(c(testPath,"X_test.txt"),collapse=""))
y_test <- read.table(paste(c(testPath,"y_test.txt"),collapse=""))
x <- rbind(x,x_test)
y <- rbind(y,y_test)

# STEP TWO: Extracts only mean and standard deviation measurements in x
mean_ind <- grep("mean",features[,2],ignore.case=TRUE) #returns vector of features indices with "mean" in the title
std_ind <- grep("std()",features[,2],ignore.case=TRUE) #returns vector of features indices with "std" in the title
mean_std_ind <- sort(c(mean_ind,std_ind)) #combined mean & standard deviation index vector
x <- x[mean_std_ind] #keep only mean and standard deviation summary data
features <- features[mean_std_ind,] #keep only mean and stadard deviation features

# STEP THREE:  Replace numeric index of activities with names of those activities as factors
for (i in 1:6) {
    y[y == i] <- levels(activities[,2])[i] #Generates data frame of activities as factors
}
x <- cbind(y,subject_key,x)  #Include activities and subjects as columns in data set

# STEP FOUR:  

colnames(x)[3:88] <- as.character(features[[2]]) #name summary statistic columns by the names of the given features
colnames(x) <- sub("()","",colnames(x),fixed = TRUE) #remove parentheses in column names for readability
colnames(x) <- sapply(colnames(x),paste,"_avg_over_subject-activity",sep="",collapse="")
colnames(x)[1] <- "activity" #rename column 1
colnames(x)[2] <- "subject" #rename column 2

# STEP FIVE

#Applies mean function over every subject-activity combination
TidyX <- aggregate(x[,3:88],by = x[c("activity","subject")],FUN="mean") 

# STEP SIX WRITE DATA TO FILE
write.table(TidyX, file = "TidyX.txt",row.names = FALSE, sep = " ")


