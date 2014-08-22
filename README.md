---
title: "README"
author: "Jeremy Benson"
date: "Thursday, August 21, 2014"
output: html_document
---
This document explains the code that was used to extract the data "Human Activity Recognition Using Smartphones Data Set" and calculate average means and standard deviations by Subject and Activity Type. See codebook.html for a description of the fields in the resulting dataset.
## Step 1 - Merge Test and Train Datasets
Read in 3 datasets each from the Test and Train Datasets. The testRaw dataset is a list of values (field names added later). The testSub has Subjects numbered from 1 to 30. The testLabels dataset has labels corresponding to the type of activity. These 3 datasets are then combined.
A similar process is done with the train datasets and then the overall test and train datasets are combined.
```{r}
testRaw = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", header=FALSE)
testSub = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", header=FALSE)
colnames(testSub)[1] = "Subject"
testLabels = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", header=FALSE)
testData = cbind(testLabels,testSub,testRaw)
trainRaw = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", header=FALSE)
trainSub = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", header=FALSE)
colnames(trainSub)[1] = "Subject"
trainLabels = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", header=FALSE)
trainData = cbind(trainLabels,trainSub,trainRaw)
allData = rbind(testData,trainData)
```
## Step 2 - Extract only mean and standard deviation
In this step, the column names for the raw data are read in and then only the columns that have "mean" or "std" are kept.
```{r,}
colNames = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
colnames(allData)[-c(1,2)] = as.character(colNames[,2])
data_mean_sd = grep("mean|std",names(allData))
subData = allData[,c(1,2, data_mean_sd)]
```
## Step 3 - Use Descriptive Activity Names
This step applies descriptions to the activity names by loading a table of activity descriptions and then merging with the dataset created above. The last step is deleting the column that has a number for the activity.
```{r,}
labelDesc = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", header=FALSE)
colnames(labelDesc)[2] = "Activity"
subData2 = merge(labelDesc,subData,by="V1")
subData3 = subData2[ , which(colnames(subData2)!="V1")]
```
## Step 4 - Label with Descriptive Variable Names
This step takes the variable name and cleans them up by removing unwanted characters.
```{r,}
colNames = names(subData3)
colNames = gsub("-|\\()","",colNames)
colnames(subData3) = colNames
```
## Step 5 - Calculate the mean by activity and subject
This step aggregates the data by Activity Type and Subject Number and calculates the mean of each of the other fields. It creates a new dataset called aggData with the resulting output.
```{r,}
attach(subData3)
aggData = aggregate(subData3[,-c(1,2)],by=list(Activity,Subject),FUN=mean)
detach(subData3)
colnames(aggData)[c(1,2)] = c("Activity","Subject")
```
## Output Dataset
This step outputs the dataset to a tab-delimited text file.
```{r,}
write.table(aggData,"aggData.txt",sep="\t",row.name=FALSE)
```
