# Recreating data in an R dataframe
df <- read.table(text="DATE Real_Estate
01/01/2017	184.659
01/02/2017	185.026
01/03/2017	186.535
01/04/2017	188.55
01/05/2017	190.548
01/06/2017	192.276
01/07/2017	193.522
01/08/2017	194.357
01/09/2017	194.826
01/10/2017	195.092
01/11/2017	195.457
01/12/2017	195.852
01/01/2018	196.12
01/02/2018	196.909
01/03/2018	198.578
01/04/2018	200.621
01/05/2018	202.46
01/06/2018	204.053
01/07/2018	204.962
01/08/2018	205.34
01/09/2018	205.386
01/10/2018	205.381
01/11/2018	205.118
01/12/2018	204.709
01/01/2019	204.215
01/02/2019	204.443
01/03/2019	205.79
01/04/2019	207.702
01/05/2019	209.365
01/06/2019	210.603
01/07/2019	211.356
01/08/2019	211.715
01/09/2019	211.892
01/10/2019	211.984
01/11/2019	212.121
01/12/2019	212.251
01/01/2020	212.413
01/02/2020	213.235
01/03/2020	215.213
01/04/2020	217.26
01/05/2020	218.509
01/06/2020	219.835
01/07/2020	221.59
01/08/2020	224.07
01/09/2020	226.825
01/10/2020	229.841
01/11/2020	232.351
01/12/2020	234.405
01/01/2021	236.482
01/02/2021	239.252
01/03/2021	244.248
01/04/2021	249.844
01/05/2021	255.466
01/06/2021	261.19
01/07/2021	265.523
01/08/2021	268.798
01/09/2021	271.454
01/10/2021	273.67
01/11/2021	276.048
01/12/2021	278.628
01/01/2022	282.009
01/02/2022	287.251
01/03/2022	295.088
01/04/2022	301.764
01/05/2022	306.547
01/06/2022	308.323
01/07/2022	307.127
01/08/2022	303.648
01/09/2022	300.449
01/10/2022	298.676
01/11/2022	296.827
01/12/2022	294.32
01/01/2023	292.706", header=TRUE)

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
df_merged$Real_Estate <- na.approx(df_merged$Real_Estate)

# Final output data frame
final_df <- df_merged

# Export final data frame as csv for further processing in Python
# write.csv(final_df, "C:\\Users\\Hriday Govind\\Documents\\MSc\\Thesis Final Submission\\Data\\Real_Estate.csv", row.names = FALSE) # Uncomment if needed
