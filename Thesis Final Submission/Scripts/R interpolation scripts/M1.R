# Recreating data in an R dataframe
df <- read.table(text="DATE M1
01/01/2017	3389.3
01/02/2017	3400.4
01/03/2017	3452.9
01/04/2017	3452.7
01/05/2017	3517.6
01/06/2017	3526.3
01/07/2017	3548.6
01/08/2017	3585.1
01/09/2017	3569.3
01/10/2017	3604.4
01/11/2017	3626.2
01/12/2017	3618.8
01/01/2018	3650.7
01/02/2018	3614
01/03/2018	3667
01/04/2018	3660
01/05/2018	3654.4
01/06/2018	3654.5
01/07/2018	3679.8
01/08/2018	3690.4
01/09/2018	3700.1
01/10/2018	3724.9
01/11/2018	3700.9
01/12/2018	3773
01/01/2019	3745
01/02/2019	3752.1
01/03/2019	3736.9
01/04/2019	3783.9
01/05/2019	3788.2
01/06/2019	3828.4
01/07/2019	3860.3
01/08/2019	3855.3
01/09/2019	3899.5
01/10/2019	3933.1
01/11/2019	3949.5
01/12/2019	4021.2
01/01/2020	3978.6
01/02/2020	3981.4
01/03/2020	4261
01/04/2020	4794.5
01/05/2020	16244.2
01/06/2020	16559.7
01/07/2020	16767.2
01/08/2020	16878.5
01/09/2020	17158.6
01/10/2020	17357.2
01/11/2020	17609.1
01/12/2020	17827
01/01/2021	18098.4
01/02/2021	18362.8
01/03/2021	18634.3
01/04/2021	18934.1
01/05/2021	19268.1
01/06/2021	19359.2
01/07/2021	19534.6
01/08/2021	19734.2
01/09/2021	19865.9
01/10/2021	20035.1
01/11/2021	20250.4
01/12/2021	20496
01/01/2022	20506.3
01/02/2022	20533.6
01/03/2022	20664.6
01/04/2022	20651.8
01/05/2022	20639.1
01/06/2022	20608.2
01/07/2022	20588.3
01/08/2022	20478.5
01/09/2022	20279.4
01/10/2022	20098.8
01/11/2022	19968.5
01/12/2022	19830.8
01/01/2023	19571.3
01/02/2023	19336.7", header=TRUE)

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
df_merged$M1 <- na.approx(df_merged$M1)

# Final output data frame
final_df <- df_merged

# Export final data frame as csv for further processing in Python
# write.csv(final_df, "C:\\Users\\Hriday Govind\\Documents\\MSc\\Thesis Final Submission\\Data\\M1.csv", row.names = FALSE) # Uncomment if needed
