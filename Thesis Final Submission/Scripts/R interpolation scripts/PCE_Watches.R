# Recreating data in an R dataframe
df <- read.table(text="DATE PCE_Watches
01/01/2017	12.58
01/02/2017	12.45
01/03/2017	12.51
01/04/2017	12.56
01/05/2017	12.53
01/06/2017	12.7
01/07/2017	12.86
01/08/2017	12.78
01/09/2017	12.96
01/10/2017	12.96
01/11/2017	13.2
01/12/2017	13.03
01/01/2018	13.11
01/02/2018	13.31
01/03/2018	13.27
01/04/2018	13.42
01/05/2018	13.55
01/06/2018	13.45
01/07/2018	13.45
01/08/2018	13.39
01/09/2018	13.11
01/10/2018	13.43
01/11/2018	13.31
01/12/2018	12.97
01/01/2019	13.05
01/02/2019	13.36
01/03/2019	13.35
01/04/2019	13.59
01/05/2019	13.59
01/06/2019	13.54
01/07/2019	14.04
01/08/2019	14.06
01/09/2019	14.1
01/10/2019	13.89
01/11/2019	13.57
01/12/2019	14.22
01/01/2020	14.37
01/02/2020	14.06
01/03/2020	10.68
01/04/2020	7.02
01/05/2020	10.23
01/06/2020	14.24
01/07/2020	15.35
01/08/2020	15.78
01/09/2020	16.24
01/10/2020	15.91
01/11/2020	15.46
01/12/2020	16.01
01/01/2021	17.13
01/02/2021	16.93
01/03/2021	19.75
01/04/2021	19.05
01/05/2021	19.71
01/06/2021	20.1
01/07/2021	19.86
01/08/2021	20.06
01/09/2021	20.33
01/10/2021	20.99
01/11/2021	21.01
01/12/2021	20.11
01/01/2022	20.6
01/02/2022	21.08
01/03/2022	21.48
01/04/2022	21.18
01/05/2022	20.55
01/06/2022	21.28
01/07/2022	21.12
01/08/2022	20.75
01/09/2022	20.7
01/10/2022	20.41
01/11/2022	20.18
01/12/2022	19.94
01/01/2023	20.76
01/02/2023	20.79", header=TRUE)

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
df_merged$PCE_Watches <- na.approx(df_merged$PCE_Watches)

# Final output data frame
final_df <- df_merged

# Export final data frame as csv for further processing in Python
# write.csv(final_df, "C:\\Users\\Hriday Govind\\Documents\\MSc\\Thesis Final Submission\\Data\\PCE_Watches.csv", row.names = FALSE) # Uncomment if needed
