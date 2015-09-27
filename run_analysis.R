# -------------------------------------------------------------------------------------------
# 1. Merge the training and the test sets to create one data set
# -------------------------------------------------------------------------------------------
# Read train data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c("activity_id"))
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c("subject"))

# Read test data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c("activity_id"))
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c("subject"))

# Merge test and train data
x_total <- rbind(x_train, x_test)
y_total <- rbind(y_train, y_test)
subject_total <- rbind(subject_train, subject_test) 
# Create a single dataset from: activity, subject, and features
har_data <- cbind(y_total, subject_total, x_total)

# Load features
features <- read.table("./UCI HAR Dataset/features.txt")

# -------------------------------------------------------------------------------------------
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# -------------------------------------------------------------------------------------------
# Extracting only mean() and std() features
# Purposedly ignoring mean frequency features as they are not of importance for us at this moment
mean_std_features <- features[grep("mean\\(\\)|std\\(\\)", features$V2),]
# clean up feature names
mean_std_features$V2 <- gsub(",", "_", gsub("()", "", mean_std_features$V2, fixed=TRUE))
# Select only the features we are interested in
filtered_har_data <- har_data[,c(1, 2, mean_std_features$V1+2)]

# -------------------------------------------------------------------------------------------
# 3. Use descriptive activity names to name the activities in the data set.
# -------------------------------------------------------------------------------------------
# Read activity labels
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("id", "activity"))
# get descriptions
filtered_har_data <- merge(activities, filtered_har_data, by.x="id", by.y="activity_id", sort=FALSE)
# remove the id column as we have the description already
drop_cols <- "id"
filtered_har_data <- filtered_har_data[, !(names(filtered_har_data) %in% drop_cols)]

# -------------------------------------------------------------------------------------------
# 4. Appropriately labels the data set with descriptive variable names.
# -------------------------------------------------------------------------------------------
# Set descriptive variable names
mean_std_features$V2 <- gsub("Gyro", "-gyrometer", mean_std_features$V2)
mean_std_features$V2 <- gsub("Mag", "-magnitud", mean_std_features$V2)
mean_std_features$V2 <- gsub("Acc", "-accelerometer", mean_std_features$V2)
mean_std_features$V2 <- gsub("Jerk", "-jerk", mean_std_features$V2)
mean_std_features$V2 <- gsub("Body", "-body", mean_std_features$V2)
mean_std_features$V2 <- gsub("t-", "time-", mean_std_features$V2)
mean_std_features$V2 <- gsub("f-", "frequency-", mean_std_features$V2)

# Replace feature vector names
# Our feature names indexes already align with the names, so we just need to substitute
colnames(filtered_har_data) <- c("activity", "subject", mean_std_features$V2)

# -------------------------------------------------------------------------------------------
# 5. Create independent tidy data set with the average of each variable for each activity 
# and each subject. 
# -------------------------------------------------------------------------------------------
# Group by the activity and subject
by_act_subj <- filtered_har_data %>% group_by(activity, subject)
# Get the means
feature_means_by_act_subj <- by_act_subj %>% summarise_each(funs(mean))


# -------------------------------------------------------------------------------------------
# Save the results, aka "tidy" dataset
# -------------------------------------------------------------------------------------------
write.table(feature_means_by_act_subj, "har_data_by_act_subj.txt", row.name=FALSE)



