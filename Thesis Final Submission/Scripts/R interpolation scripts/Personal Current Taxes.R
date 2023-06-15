# Recreating data in an R dataframe
df <- read.table(text="DATE Personal_Current_Taxes
01/01/2017	1999.1
01/02/2017	2006.8
01/03/2017	2006.3
01/04/2017	2006.9
01/05/2017	2009.4
01/06/2017	2019.9
01/07/2017	2035
01/08/2017	2052
01/09/2017	2077.6
01/10/2017	2104.3
01/11/2017	2127.2
01/12/2017	2139.2
01/01/2018	2078
01/02/2018	2073.6
01/03/2018	2066.8
01/04/2018	2057
01/05/2018	2054.1
01/06/2018	2062
01/07/2018	2079.3
01/08/2018	2090
01/09/2018	2088.9
01/10/2018	2080.4
01/11/2018	2079.2
01/12/2018	2089.7
01/01/2019	2135.7
01/02/2019	2156.8
01/03/2019	2188.1
01/04/2019	2215.5
01/05/2019	2225.5
01/06/2019	2223.7
01/07/2019	2200.9
01/08/2019	2195.1
01/09/2019	2191.5
01/10/2019	2204.7
01/11/2019	2217.9
01/12/2019	2225.5
01/01/2020	2259
01/02/2020	2279.8
01/03/2020	2208.5
01/04/2020	2042.6
01/05/2020	2097.4
01/06/2020	2154.5
01/07/2020	2198
01/08/2020	2241
01/09/2020	2273.6
01/10/2020	2320.6
01/11/2020	2362.1
01/12/2020	2399.4
01/01/2021	2479.8
01/02/2021	2501.9
01/03/2021	2545.2
01/04/2021	2605.3
01/05/2021	2643.5
01/06/2021	2666.7
01/07/2021	2677
01/08/2021	2686.8
01/09/2021	2715.8
01/10/2021	2768.8
01/11/2021	2808.8
01/12/2021	2840.6
01/01/2022	3125.7
01/02/2022	3147
01/03/2022	3163.7
01/04/2022	3177.6
01/05/2022	3189.2
01/06/2022	3198.5
01/07/2022	3224.2
01/08/2022	3236.7
01/09/2022	3248.6
01/10/2022	3244.8
01/11/2022	3231.8
01/12/2022	3220.3
01/01/2023	2952.6
01/02/2023	2935.6", header=TRUE)

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
df_merged$Personal_Current_Taxes <- na.approx(df_merged$Personal_Current_Taxes)

# Final output data frame
final_df <- df_merged

# Export final data frame as csv for further processing in Python
# write.csv(final_df, "C:\\Users\\Hriday Govind\\Documents\\MSc\\Thesis Final Submission\\Data\\Personal_Current_Taxes.csv", row.names = FALSE) # Uncomment if needed
