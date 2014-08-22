#Step 1 - Merge train and test data
testRaw = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt",
                      header=FALSE)
testSub = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt",
                      header=FALSE)
colnames(testSub)[1] = "Subject"
testLabels = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt",
                        header=FALSE)
testData = cbind(testLabels,testSub,testRaw)

trainRaw = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt",
                       header=FALSE)
trainSub = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt",
                       header=FALSE)
colnames(trainSub)[1] = "Subject"
trainLabels = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt",
                         header=FALSE)
trainData = cbind(trainLabels,trainSub,trainRaw)

allData = rbind(testData,trainData)

#Step 2 - Extract only mean and standard deviation
colNames = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
colnames(allData)[-c(1,2)] = as.character(colNames[,2])
data_mean_sd = grep("mean|std",names(allData))
subData = allData[,c(1,2, data_mean_sd)]

#Step 3 - Use Descriptive Activity Names
labelDesc = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt",
                       header=FALSE)
colnames(labelDesc)[2] = "Activity"
subData2 = merge(labelDesc,subData,by="V1")
subData3 = subData2[ , which(colnames(subData2)!="V1")]

#Step 4 - Label with Descriptive Variable Names
colNames = names(subData3)
colNames = gsub("-|\\()","",colNames)
colnames(subData3) = colNames

#Step 5 - Calculate the mean by activity and subject
attach(subData3)
aggData = aggregate(subData3[,-c(1,2)],by=list(Activity,Subject),FUN=mean)
detach(subData3)
colnames(aggData)[c(1,2)] = c("Activity","Subject")

#Output Dataset
write.table(aggData,"aggData.txt",sep="\t",row.name=FALSE)
