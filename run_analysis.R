
########################
## IMPORTANT ASSUMPTION
########################
# The Samsung data is in the working directory
# under a sub-directory named "UCI HAR Dataset"


############################################################
## indices and tidy names for "mean" or "std" features only
############################################################

## read names of all features
feature_names_original<-read.table("UCI HAR Dataset/features.txt")
# dim(feature_names_original) # 561   2
# head(feature_names_original)
# feature_names_original[2] ==> look in second column for feature names that include "mean()" or "std()"

## indices for "mean" features only
mean_indices<-grep("mean()", feature_names_original[,2], value=FALSE, fixed=TRUE)
# length(mean_indices) # 33

## indices for "std" features only
std_indices<-grep("std()", feature_names_original[,2], value=FALSE, fixed=TRUE)
# length(std_indices) # 33

## sorted indices for "mean" or "std" features only
indices<-sort(c(mean_indices, std_indices))
# length(indices) # 66

## indices of columns of interest
feature_indices <- (feature_names_original[indices,1])
# length(indices) # 66

## names of columns of interest
feature_names <- (feature_names_original[indices,2]) # get the names
# length(feature_names) # 66
# head(feature_names) 
# tail(feature_names)
# ==> feature names are not tidy enough
# ==> need to change "-" to "_" and deal with duplicate "Body" in "BodyBody" feature names
feature_names <- gsub(pattern='-', replacement='_', x=feature_names) # tidy
feature_names <- gsub(pattern='BodyBody', replacement='Body', x=feature_names) # tidy
# head(feature_names) 
# tail(feature_names)
# ==> O.K.


###########################
## prepare activity labels
###########################

# read table
# and assign column names
# in a single line of code
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activity_index","activity_description"))
# str(activity_labels) # O.K.


#################################
## pre-process the training data
#################################

## read training data
## take only selected columns (mean / std)
X_train<-read.table("UCI HAR Dataset/train/X_train.txt")[,feature_indices]
# head(X_train) # column names are v1, v2, ..., v543
# str(X_train) # all column are numeric
# dim(X_train) # 7352   66 ==> O.K.

## assign feature names to training data
colnames(X_train)<-feature_names
# head(X_train) # column names are now more comprehendible
# str(X_train)

## read training subject IDs
X_tr_subject<-read.table("UCI HAR Dataset/train/subject_train.txt")
# head(X_tr_subject) # a single column

## assign a column name instead of "V1"
colnames(X_tr_subject)<-"subject"
# str(X_tr_subject) # 7352 obs. ==> O.K.

## read training activity index
y_train_ind<-read.table("UCI HAR Dataset/train/y_train.txt")
# str(y_train_ind) # a single column

## assign a column name instead of "V1"
colnames(y_train_ind)<-"activity_index"
# str(y_train_ind) # 7352 obs. ==> O.K.

## merge (by binding columns) the subject IDs + activity ind + measurements
X_tr_temp <- cbind(X_tr_subject, y_train_ind, X_train)
# head(X_tr_temp)
# str(X_tr_temp)

## merge (by joining) in order to get activity descriptions (in addition ti IDs)
X_tr_description<-merge(X_tr_temp,activity_labels,by="activity_index", all.x = TRUE ,sort=FALSE)
# head(X_tr_description)
# str(X_tr_description)
# with(X_tr_description, table(subject,activity_description)) # ==> O.K.

## tidy training set:
# subject ID first
# activity descriptions second
# then all the mean / std measurements
X_tr <- X_tr_description[c(2,ncol(X_tr_description),3:(ncol(X_tr_description)-1))]
# head(X_tr)
# str(X_tr) # 7352 obs. of  68 variables ==> O.K.


#############################
## pre-process the test data
#############################

## read test data
## take only selected columns (mean / std)
X_test<-read.table("UCI HAR Dataset/test/X_test.txt")[,feature_indices]
# head(X_test) # column names are v1, v2, ..., v543
# str(X_test) # all column are numeric
# dim(X_test) # 2947   66 ==> O.K.

## assign feature names to test data
colnames(X_test)<-feature_names
# head(X_test) # column names are now more comprehendible
# str(X_test)

## read test subject IDs
X_ts_subject<-read.table("UCI HAR Dataset/test/subject_test.txt")
# head(X_ts_subject) # a single column

## assign a column name instead of "V1"
colnames(X_ts_subject)<-"subject"
# str(X_ts_subject) # 2947 obs. ==> O.K.

## read test activity index
y_test_ind<-read.table("UCI HAR Dataset/test/y_test.txt")
# str(y_test_ind) # a single column

## assign a column name instead of "V1"
colnames(y_test_ind)<-"activity_index"
# str(y_test_ind) # 2947 obs. ==> O.K.

## merge (by binding columns) the subject IDs + activity ind + measurements
X_ts_temp <- cbind(X_ts_subject, y_test_ind, X_test)
# head(X_ts_temp)
# str(X_ts_temp)

## merge (by joining) in order to get activity desriptions (in addition ti IDs)
X_ts_description<-merge(X_ts_temp,activity_labels,by="activity_index", all.x = TRUE ,sort=FALSE)
# head(X_ts_description)
# str(X_ts_description)
# with(X_ts_description, table(subject,activity_description)) # ==> O.K.

## tidy test set:
# subject ID first
# activity descriptions second
# then all the mean / std measurements
X_ts <- X_ts_description[c(2,ncol(X_ts_description),3:(ncol(X_ts_description)-1))]
# head(X_ts)
# str(X_ts) # 2947 obs. of  68 variables ==> O.K.


############################################
## merge (union) training and test datasets
############################################

X <- rbind(X_tr,X_ts)
# dim(X) 
# str(X) # 10299 obs. of  68 variables ==> O.K.


###############################################################
## aggregate into a wide form:
## average of each variable for each activity and each subject
###############################################################

## aggregate
agg_wide <-aggregate(X[,3:ncol(X)], by=list(X$activity_description, X$subject), FUN=mean, na.rm=TRUE)
# dim(agg_wide) # 180  68
# str(agg_wide) # 1st and 2nd columns are named Group.1 and Group.2 respectively

## assign meaningful column names to 1st and 2nd columns
colnames(agg_wide)[1:2]<-c("activity_description","subject")

## add a prefix "mean_of_" to each computed mean
for (i in 3:ncol(agg_wide)) {colnames(agg_wide)[i]<-paste("mean_of_",colnames(agg_wide)[i],sep = "")}
# str(agg_wide) # 180 obs. of  68 variables

## order the data by activity_description and subject
agg_wide<-agg_wide[order(agg_wide$activity_description,agg_wide$subject),]
# head(agg_wide,15)

## create txt file for submission
write.table(x=agg_wide, file="averages_wide_format.txt", row.name=FALSE )

## print the output: tidy aggregation by activity and subject
agg_wide