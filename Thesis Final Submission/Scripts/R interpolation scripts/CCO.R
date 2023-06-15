# Recreating data in an R dataframe
df <- read.table(text="DATE CCO
01/01/2017	3645.97
01/02/2017	3631.14
01/03/2017	3630.45
01/04/2017	3645.87
01/05/2017	3667.22
01/06/2017	3682.74
01/07/2017	3697.47
01/08/2017	3732.43
01/09/2017	3749.2
01/10/2017	3771.32
01/11/2017	3800.31
01/12/2017	3830.75
01/01/2018	3839.58
01/02/2018	3824.71
01/03/2018	3819.91
01/04/2018	3829.11
01/05/2018	3855.43
01/06/2018	3858.16
01/07/2018	3878.88
01/08/2018	3920.39
01/09/2018	3934.57
01/10/2018	3951.65
01/11/2018	3977.39
01/12/2018	4007.04
01/01/2019	4016.5
01/02/2019	4000.42
01/03/2019	3994.49
01/04/2019	4013.78
01/05/2019	4038.93
01/06/2019	4052.03
01/07/2019	4073.45
01/08/2019	4109.82
01/09/2019	4124.13
01/10/2019	4139.13
01/11/2019	4151.29
01/12/2019	4192.19
01/01/2020	4194.69
01/02/2020	4179.98
01/03/2020	4147.83
01/04/2020	4086.5
01/05/2020	4080.48
01/06/2020	4097.23
01/07/2020	4110.27
01/08/2020	4125.52
01/09/2020	4142.65
01/10/2020	4144.44
01/11/2020	4159.77
01/12/2020	4184.85
01/01/2021	4180.86
01/02/2021	4171.43
01/03/2021	4167.18
01/04/2021	4186.09
01/05/2021	4228.05
01/06/2021	4259.11
01/07/2021	4272.99
01/08/2021	4310.97
01/09/2021	4337.4
01/10/2021	4352.7
01/11/2021	4395.69
01/12/2021	4430.82
01/01/2022	4430.73
01/02/2022	4436.3
01/03/2022	4462.6
01/04/2022	4494
01/05/2022	4536.18
01/06/2022	4583.23
01/07/2022	4604.13
01/08/2022	4653
01/09/2022	4681.07
01/10/2022	4712.41
01/11/2022	4760.35
01/12/2022	4785.81
01/01/2023	4790.49
01/02/2023	4778.52", header=TRUE)

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
df_merged$CCO <- na.approx(df_merged$CCO)

# Final output data frame
final_df <- df_merged

# Export final data frame as csv for further processing in Python
# write.csv(final_df, "C:\\Users\\Hriday Govind\\Documents\\MSc\\Thesis Final Submission\\Data\\CCO.csv", row.names = FALSE) # Uncomment if needed
