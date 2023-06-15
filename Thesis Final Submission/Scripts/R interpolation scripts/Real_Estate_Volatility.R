# Recreating data in an R dataframe
df <- read.table(text="DATE Real_Estate_Volatility
01/01/2017	4.66722
01/02/2017	4.31068
01/03/2017	3.42054
01/04/2017	4.02302
01/05/2017	3.28816
01/06/2017	2.97414
01/07/2017	2.98077
01/08/2017	4.71762
01/09/2017	2.67259
01/10/2017	1.87857
01/11/2017	3.56427
01/12/2017	5.04561
01/01/2018	4.44438
01/02/2018	7.85358
01/03/2018	3.82581
01/04/2018	3.64037
01/05/2018	3.82713
01/06/2018	2.71897
01/07/2018	2.46833
01/08/2018	3.37996
01/09/2018	5.23869
01/10/2018	5.70544
01/11/2018	4.86677
01/12/2018	10.11239
01/01/2019	8.57731
01/02/2019	3.88753
01/03/2019	5.30322
01/04/2019	3.73027
01/05/2019	3.02348
01/06/2019	4.29018
01/07/2019	5.44756
01/08/2019	5.85441
01/09/2019	4.24375
01/10/2019	3.61407
01/11/2019	4.50055
01/12/2019	6.45396
01/01/2020	3.42816
01/02/2020	4.6878
01/03/2020	15.39068
01/04/2020	11.60076
01/05/2020	10.03249
01/06/2020	8.19182
01/07/2020	5.91092
01/08/2020	8.31456
01/09/2020	4.30912
01/10/2020	5.50234
01/11/2020	5.04755
01/12/2020	4.57933
01/01/2021	4.11672
01/02/2021	3.85807
01/03/2021	5.76789
01/04/2021	4.51584
01/05/2021	5.06135
01/06/2021	5.95601
01/07/2021	3.15482
01/08/2021	3.79038
01/09/2021	7.43257
01/10/2021	5.64704
01/11/2021	2.99842
01/12/2021	3.57827
01/01/2022	3.77967
01/02/2022	5.36223
01/03/2022	5.09234
01/04/2022	4.44289
01/05/2022	7.72273
01/06/2022	6.3632
01/07/2022	6.85084
01/08/2022	2.93702
01/09/2022	4.39865
01/10/2022	7.24512
01/11/2022	4.94162
01/12/2022	7.17342
01/01/2023	6.79745
01/02/2023	6.39657
01/03/2023	11.10109", header=TRUE)

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
df_merged$Real_Estate_Volatility <- na.approx(df_merged$Real_Estate_Volatility)

# Final output data frame
final_df <- df_merged

# Export final data frame as csv for further processing in Python
# write.csv(final_df, "C:\\Users\\Hriday Govind\\Documents\\MSc\\Thesis Final Submission\\Data\\Real_Estate_Volatility.csv", row.names = FALSE) # Uncomment if needed
