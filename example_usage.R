source("composite_fun.R") #gives access to the function composite()

data<-read.csv("subjects.csv") #read in the data

# Assign columns of interest

# You should ensure that the data you want to composite all have the
# same direction. For example if you include a bunch of conflict
# tasks, a high score tracks worse performance. If you were to also
# include O-Span as a column of interest, where a high score is better
# preformance, you it would work against the rest of your
# measures. The function will reverse any measures that are assigned
# to the reverse columns of interest (or rev_coi) argument (instead of
# the coi argument) of the function by reversing the sign (multipying by -1).

columns_of_interest <- colnames(data)[c(2,4)]

reverse_columns_of_interest <- colnames(data)[3] #anything here should
                                                 #not appear in
                                                 #columns_of_interest

subject_column <- colnames(data)[1]

# The previous three lines are an easier way to grab the column names than typing the  names inby hand, but you could do that too:

#columns_of_interest <- c("Simon.Score" , "PN.AVG.RT")
#reverse_columns_of_interest <- c(""Ospan.Recall.Computer"")
#subject_column <- "Subject"

#To use composite() supply it with the name of the data frame, the columns of interest, columns of interest that need to be reversed, and the name of the Subject column

comp <- composite(data, columns_of_interest, reverse_columns_of_interest, subject_column)


# Note the composite will be reordered by subject number. I haven't
# felt the need to change this behavior.

data_with_composite <- merge(data,comp,by="Subject")#Merge the
                                                    #composite data
                                                    #frame back with
                                                    #your original
                                                    #data

write.csv(data_with_composite,"data_composite.csv") #write out the data
