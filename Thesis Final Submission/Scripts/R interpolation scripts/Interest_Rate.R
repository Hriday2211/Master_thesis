# Recreating data in an R dataframe
df <- read.table(text="DATE Interest_Rate
01/01/2017	0.65
01/02/2017	0.66
01/03/2017	0.79
01/04/2017	0.9
01/05/2017	0.91
01/06/2017	1.04
01/07/2017	1.15
01/08/2017	1.16
01/09/2017	1.15
01/10/2017	1.15
01/11/2017	1.16
01/12/2017	1.3
01/01/2018	1.41
01/02/2018	1.42
01/03/2018	1.51
01/04/2018	1.69
01/05/2018	1.7
01/06/2018	1.82
01/07/2018	1.91
01/08/2018	1.91
01/09/2018	1.95
01/10/2018	2.19
01/11/2018	2.2
01/12/2018	2.27
01/01/2019	2.4
01/02/2019	2.4
01/03/2019	2.41
01/04/2019	2.42
01/05/2019	2.39
01/06/2019	2.38
01/07/2019	2.4
01/08/2019	2.13
01/09/2019	2.04
01/10/2019	1.83
01/11/2019	1.55
01/12/2019	1.55
01/01/2020	1.55
01/02/2020	1.58
01/03/2020	0.65
01/04/2020	0.05
01/05/2020	0.05
01/06/2020	0.08
01/07/2020	0.09
01/08/2020	0.1
01/09/2020	0.09
01/10/2020	0.09
01/11/2020	0.09
01/12/2020	0.09
01/01/2021	0.09
01/02/2021	0.08
01/03/2021	0.07
01/04/2021	0.07
01/05/2021	0.06
01/06/2021	0.08
01/07/2021	0.1
01/08/2021	0.09
01/09/2021	0.08
01/10/2021	0.08
01/11/2021	0.08
01/12/2021	0.08
01/01/2022	0.08
01/02/2022	0.08
01/03/2022	0.2
01/04/2022	0.33
01/05/2022	0.77
01/06/2022	1.21
01/07/2022	1.68
01/08/2022	2.33
01/09/2022	2.56
01/10/2022	3.08
01/11/2022	3.78
01/12/2022	4.1
01/01/2023	4.33
01/02/2023	4.57
01/03/2023	4.65", header=TRUE)

# Convert DATE column to date format
df$DATE <- as.Date(df$DATE, format="%d/%m/%Y")

# Create a sequence of dates on a weekly time frame
all_dates <- seq(from=min(df$DATE), to=max(df$DATE), by="week")

# Create a new data frame with all_dates as the date column
new_df <- data.frame(DATE=all_dates)

# Merge the new data frame with the original data frame
df_merged <- merge(df, new_df, all=TRUE)

# Interpolate missing values
library(zoo)
df_merged$Interest_Rate <- na.approx(df_merged$Interest_Rate)

# Final output data frame
final_df <- df_merged

# Export final data frame as csv for further processing in Python
# write.csv(final_df, "C:\\Users\\Hriday Govind\\Documents\\MSc\\Thesis Final Submission\\Data\\Interest_Rate.csv", row.names = FALSE) # Uncomment if needed
