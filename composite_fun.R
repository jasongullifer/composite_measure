composite <- function(data, coi, rev_coi="", Sub="Subject"){
# Will reverse the direction of any specified measures. Our thought is
# the z-scores might cancel out of the signs are opposite

require(plyr)

if (rev_coi != ""){
  temp <- -1 * (data[,rev_coi])
  temp <- as.data.frame(temp)
  colnames(temp) <- paste("rev", colnames(temp), sep="_")
  data <- cbind(data,temp)
  coi <- c(coi,colnames(temp))
}

# Create z-scores
zscores <- scale(data[, coi], center=T, scale=T)
zscores <- as.data.frame(zscores)
colnames(zscores) <- paste(colnames(zscores),"Z",sep="_")
zscore_coi <- paste(coi,"Z",sep="_") #Get columns of interest for z-score frame
zscores <- cbind(data$Subject,zscores)
colnames(zscores)[1] <- c("Subject")

# Sum the z-scores
zscores$summedZ<-rowSums(zscores[, zscore_coi])

# Get the variance across all tasks for each subject
var_across<- ddply(zscores, .(Subject), function(df){var(as.numeric(df[, zscore_coi],na.rm=T))}) 
colnames(var_across)[2] <- "var_across"

zscores <- merge(zscores,var_across,by="Subject")

# Get the total covariance of the matrix
cov_all <- var(zscores[, zscore_coi], na.rm=T)

diag(cov_all) <- 0 # remove the diagonal
sum_cov <- sum(cov_all)/2 # divide by 2 to remove the other half over the diagonal
zscores$cov_all <- sum_cov

# Calculate the final composite
zscores$composite <- zscores$summedZ / (sqrt((zscores$var_across+zscores$cov_all)))

return(zscores)
}
