#Set the work directory
dir = "C:/Users/DELL/Google Drive/JVN couse materials/Projects/Get and clean data/final project"
setwd(dir)

#Create the data folder if not exists in the directory
if(!file.exists('data')){
  dir.create('data')
}

#Download the data
url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(url, destfile = './data/humanactivitiesdata.zip')
list.files('./data')

#Unzip the data
zipF<- "./data/humanactivitiesdata.zip"
outDir<-"./data"
unzip(zipF,exdir=outDir)
list.files('./data')

#1. Merges the training and the test sets to create one data set.
features = read.table('./data/UCI HAR Dataset/features.txt', header = FALSE,
                      sep ="", col.names = c("index","feature.names"))
# Process the feature names to look nicer
features$feature.names = gsub('(\\(\\))','',features$feature.names)
features$feature.names = gsub('-|,','.',features$feature.names)
features$feature.names = sub('t','time.',features$feature.names)
features$feature.names = sub('f','freq.',features$feature.names)

activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt', header = FALSE,
                             sep = "", col.names = c("index","activity.labels"))

#1.1 Prepare the train set
X_train = read.table('./data/UCI HAR Dataset/train/X_train.txt', sep = "" , header = F,
                             na.strings ="", stringsAsFactors= F, col.names = features$feature.names)
y_train = read.table('./data/UCI HAR Dataset/train/y_train.txt', header = FALSE,
                     sep = " ", col.names = c("activity.index"))
subject_train = read.table('./data/UCI HAR Dataset/train/subject_train.txt', header = FALSE,
                           sep = "", col.names = c("subject.train"))
library(dplyr)
data_train = X_train %>% mutate(activity.index=y_train$activity.index,subject=subject_train$subject.train)

#1.2 Prepare the test set 
X_test = read.table('./data/UCI HAR Dataset/test/X_test.txt', sep="", header = F,
                    na.strings = "", stringsAsFactors = F, col.names = features$feature.names)
y_test = read.table('./data/UCI HAR Dataset/test/y_test.txt', header=F,
                    sep="", col.names = c('activity.index'))
subject_test = read.table('./data/UCI HAR Dataset/test/subject_test.txt', header=F,
                          sep = "", col.names = c("subject.test"))
data_test = X_test %>% mutate(activity.index=y_test$activity.index,subject=subject_test$subject.test)

#1.3 Combine the data
combine_data = rbind(data_train,data_test)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
variable_names = names(combine_data)
mean_sd_names = grep('(mean)|(std)',variable_names,value = T)
mean_sd = combine_data %>% select(mean_sd_names)

#3.	Uses descriptive activity names to name the activities in the data set
activity_name = merge(x=combine_data, y=activity_labels, by.x='activity.index',by.y='index',all.x = T)

#4.	Appropriately labels the data set with descriptive variable names.
# This has already been done in the first step

#5.	From the data set in step 4,
#   creates a second, independent tidy data set 
#   with the average of each variable for each activity
#   and each subject.

average = activity_name %>% group_by(subject,activity.labels) %>% summarise_at(vars(-c('subject','activity.labels','activity.index')), funs(mean(., na.rm=TRUE)))

# Write the file as xlsx
library('xlsx')
write.xlsx(x=average,file='./1. tidy.xlsx')
