Getting and Cleaning Data Course Project
---------------------------------------------------------------------------

# Introduction
The data set comes originally from the: Human Activity Recognition (HAR) Using Smartphones Dataset, Version 1.0

A full description is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

### Description of the HAR dataset
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

#### For each record it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

#### Features
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

#### Files included
The dataset includes the following files:
- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

Note: The complete list of variables of each feature vector is available in 'features.txt'

# Data cleaning
For this project we are only interested in the features related to standard deviation and mean. After selecting these features, we will then compute the mean on each of them grouping by the activity and subject to give us an idea on what the averages are. The following section details how we went about reducing the dataset in order to achieve our goal.

The dataset we are working with can be obtained from here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Processing
The run_analysis.R script contains code that will process the HAR dataset and transforms it into the dataset we need. The script will automatically download the file and unzip it in the same directory where the run_analysis.R script is located at, if required.
Note: The script checks for the same filename given in the course site for download just to keep it simple.

1. The data comes separated into train and test data files. We are interested in a single view of the data and therefore we need to combine them first. As part of this exercise we also load the feature descriptions so that we can provide a better description for our columns.
2. We are only interested in features/measures that represent the mean and standard deviation (std). We now reduce the single data view we created in the previous step by selecting only those columns we are interested in. We purposedly left mean frequency out, because, at this moment, we are not interested in examining that ratio.
3. Next, we replace the activity ids with more readable labels: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
4. Now, we just need to provide more descriptive labels to our columns. We replace abbreviations such as Acc, Gyro, etc. with longer descriptions: Accelerator, Gyrometer, etc.
5. Last, we compute the average of the features by activity and subject id. As part of this step we save the resulting data set into the file 'means_by_act_subj.txt'. The measures/features are described in the codebook.md

### Files included:
- 'README.md': this readme
- 'codebook.md': contains the information about the variables for the dataset
- run_analysis.R: script that processes the original HAR dataset

### Reading the "tidy" dataset
The resulting data can be easily read using R after running the run_analysis.R script or using the following code snippet that will read it from the submission site and display it

```{r}
address <- "https://s3.amazonaws.com/coursera-uploads/user-30c935fc053618659828993a/975116/asst-3/d1bfbdd0653e11e5afaaefddacf17f73.txt"
address <- sub("^https", "http", address)
tidy_data <- read.table(url(address), header = TRUE) 
View(tidy_data)
````
