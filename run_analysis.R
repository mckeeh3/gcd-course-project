library(reshape2)

dataSetDirectory <- "UCI HAR Dataset"

downloadUnzipDataSet <- function() {
    downloadDataSet <- function() {
        zipFile <- "dataset.zip"
        if (!file.exists(zipFile)) {
            zipFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
            print(paste("download", zipFileUrl))
            download.file(zipFileUrl, zipFile, method = "curl")
            return(zipFile)
        }
    }

    unzipDataSet <- function() {
        if (!file.exists(dataSetDirectory)) {
            unzip(downloadDataSet())
            print(paste("unzip to directory", dataSetDirectory))
        }
    }
    unzipDataSet()
}

mergeTrainTestDataSets <- function() {
    mergeTrainDataSet <- function() {
        print("  merge train files")
        return(cbind(
                read.table(paste0(dataSetDirectory, "/train/X_train.txt")),
                read.table(paste0(dataSetDirectory, "/train/subject_train.txt")),
                read.table(paste0(dataSetDirectory, "/train/y_train.txt"))
            ))
    }

    mergeTestDataSet <- function() {
        print("  merge test files")
        return(cbind(
                read.table(paste0(dataSetDirectory, "/test/X_test.txt")),
                read.table(paste0(dataSetDirectory, "/test/subject_test.txt")),
                read.table(paste0(dataSetDirectory, "/test/y_test.txt"))
            ))
    }

    print("merge train and test data")
    return(rbind(
            mergeTrainDataSet(), 
            mergeTestDataSet()
        ))
}

extractMeanStdFeatureColumnNames <- function(data) {
    print("extract renamed subject, activity, mean and std fields")
    features <- read.table(paste0(dataSetDirectory, "/features.txt"), as.is = TRUE, col.names = c("id", "name"))

    namesMean <- grep(pattern = "mean()", features$name, fixed = TRUE)
    namesStd <- grep(pattern = "std()", features$name, fixed = TRUE)

    features$name <- gsub(pattern = "()", replacement = "", features$name, fixed = TRUE)
    features$name <- gsub(pattern = "-", replacement = ".", features$name, fixed = TRUE)

    colnames(data) <- c(features$name, "subject", "activity")

    return(data[, c(sort(c(namesMean, namesStd)), 562:563)])
}

convertActivityColumnToFactorWithActivities <- function(data) {
    activities <- read.table(paste0(dataSetDirectory, "/activity_labels.txt"), col.names = c("id", "activity"))
    activities$activity <- tolower(gsub(pattern = "^.*_", replacement = "", activities$activity))
    data$activity <- factor(data$activity, labels = activities$activity)

    return(data)
}

meltCastDataToTidyData <- function(data) {
    print("reshape data, melt and cast to tidy format")
    return(dcast(melt(data, id = c("subject", "activity")),
                 subject + activity ~ variable, mean))
}

tidyDataSet <- function() {
    downloadUnzipDataSet()
    data <- mergeTrainTestDataSets()
    data <- extractMeanStdFeatureColumnNames(data)
    data <- convertActivityColumnToFactorWithActivities(data)
    data <- meltCastDataToTidyData(data)

    return(data)
}

tidy <- tidyDataSet()

print("see results in variable tidy")

tidyFilename <- "uci-har-dataset-tidy.csv"
write.csv(tidy, file = tidyFilename, quote = FALSE)

print(paste("tidy data written to file", tidyFilename))
