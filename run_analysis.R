library(dplyr)
library(data.table)

## General information from textfiles
c_names_x <- unlist(read.table('UCI HAR Dataset/features.txt', header = FALSE, sep="")[2])
activity_names <- unlist(read.table('UCI HAR Dataset/activity_labels.txt', header = FALSE, sep="")[2])

## Testing set
dftestx <- read.table('UCI HAR Dataset/test/X_test.txt', header = FALSE, sep="", col.names=c_names_x, nrows = 1000)
dftesty <- read.table('UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep="", col.names = c("ActivityLabel"), nrows = 1000 )
subjecttest <- read.table('UCI HAR Dataset/test/y_test.txt', header = FALSE, sep="", col.names = c("Subject"), nrows = 1000 )
dftestx$activity <- factor(dftesty$ActivityLabel, levels=c(1:6), labels=(activity_names))
dftestx$subject <- subjecttest

## Training Set
dftrainx<- read.table('UCI HAR Dataset/train/X_train.txt', header = FALSE, sep="", col.names=c_names_x, nrows = 1000)
dftrainy <- read.table('UCI HAR Dataset/train/y_train.txt',header = FALSE, sep="", col.names = c("ActivityLabel"), nrows = 1000)
subjecttrain <- read.table('UCI HAR Dataset/train/subject_train.txt', header = FALSE, sep="", col.names = c("Subject"), nrows = 1000 )
# Add data
dftrainx$activity <- factor(dftrainy$ActivityLabel, levels=c(1:6), labels=(activity_names))
dftrainx$subject <- subjecttest

## Merge both data frames
df <- rbind(dftrainx, dftestx)


## Make tidy dataset


subjects <- unique(unlist(unique(df$subject)))
activities <- unique(df$activity)
activities <- activities [!is.na(activities )]
index <- vector(mode = "list", length = length(subjects) + length(activities))
df_tidy <- data.frame(matrix(ncol = length(c_names_x), nrow = 0))
i <- 1

for (name in subjects){
    loc_vec <- df$subject == name
    nas <- is.na(loc_vec)
    data <- filter(df, loc_vec & !nas)
    data <- select(data, -activity , -subject)
    means <- colMeans(data)
    df_tidy <- rbind(df_tidy, as.numeric(means))
    index[[i]] <- paste("subject ", i)
    i <- i + 1
}

for (act in activities){
    loc_vec <- df$activity == act
    nas <- is.na(loc_vec)
    data <- df %>% filter(loc_vec & !nas) %>% select(-activity , -subject)
    means <- colMeans(data)
    df_tidy <- rbind(df_tidy, as.numeric(means))
    index[i] <- act
    i <- i +1
}

# Add final information to tidy data frame
colnames(df_tidy) <- c_names_x          # col-names
df_tidy$charactericForAverage <- index   # indexes )
fwrite(df_tidy, file ="tidy_data.csv")
