# Recreating data in an R dataframe
df <- read.table(text="DATE Unemployment_Rate
01/01/2017	4.7
01/02/2017	4.6
01/03/2017	4.4
01/04/2017	4.4
01/05/2017	4.4
01/06/2017	4.3
01/07/2017	4.3
01/08/2017	4.4
01/09/2017	4.3
01/10/2017	4.2
01/11/2017	4.2
01/12/2017	4.1
01/01/2018	4
01/02/2018	4.1
01/03/2018	4
01/04/2018	4
01/05/2018	3.8
01/06/2018	4
01/07/2018	3.8
01/08/2018	3.8
01/09/2018	3.7
01/10/2018	3.8
01/11/2018	3.8
01/12/2018	3.9
01/01/2019	4
01/02/2019	3.8
01/03/2019	3.8
01/04/2019	3.6
01/05/2019	3.7
01/06/2019	3.6
01/07/2019	3.7
01/08/2019	3.7
01/09/2019	3.5
01/10/2019	3.6
01/11/2019	3.6
01/12/2019	3.6
01/01/2020	3.5
01/02/2020	3.5
01/03/2020	4.4
01/04/2020	14.7
01/05/2020	13.2
01/06/2020	11
01/07/2020	10.2
01/08/2020	8.4
01/09/2020	7.9
01/10/2020	6.9
01/11/2020	6.7
01/12/2020	6.7
01/01/2021	6.3
01/02/2021	6.2
01/03/2021	6.1
01/04/2021	6.1
01/05/2021	5.8
01/06/2021	5.9
01/07/2021	5.4
01/08/2021	5.2
01/09/2021	4.8
01/10/2021	4.5
01/11/2021	4.2
01/12/2021	3.9
01/01/2022	4
01/02/2022	3.8
01/03/2022	3.6
01/04/2022	3.6
01/05/2022	3.6
01/06/2022	3.6
01/07/2022	3.5
01/08/2022	3.7
01/09/2022	3.5
01/10/2022	3.7
01/11/2022	3.6
01/12/2022	3.5
01/01/2023	3.4
01/02/2023	3.6
01/03/2023	3.5", header=TRUE)

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
df_merged$Unemployment_Rate <- na.approx(df_merged$Unemployment_Rate)

# Final output data frame
final_df <- df_merged

# Export final data frame as csv for further processing in Python
# write.csv(final_df, "C:\\Users\\Hriday Govind\\Documents\\MSc\\Thesis Final Submission\\Data\\Unemployment_Rate.csv", row.names = FALSE) # Uncomment if needed
