library(readr)
library(stargazer)
library(tseries)
library(dplyr)
library(car)
library(ggplot2)
library(vars)
library(lmtest)
library(tsDyn)


full_df <- read_csv("full_df_revised.csv", col_types = cols(...1 = col_date(format = "%Y-%m-%d")))
colnames(full_df)[1] <- "Date"
stargazer(as.data.frame(full_df),type = 'text')

# Phillips Perron test for stationarity

pp.test(full_df$`Total Stock Market ETF Price`)
pp.test(full_df$`Total Stock Market ETF Volatility`)
pp.test(full_df$Real_Estate)
pp.test(full_df$Interest_Rate)
pp.test(full_df$Uncertainty)
pp.test(full_df$CCO)
pp.test(full_df$CCI)
pp.test(full_df$CPI)
pp.test(full_df$M1)
pp.test(full_df$Unemployment_Rate)
pp.test(full_df$USD_Index)
pp.test(full_df$`10-Yr Yield`)
pp.test(full_df$Personal_Current_Taxes)
pp.test(full_df$PCE_Watches)
pp.test(full_df$Real_Estate_Volatility)
pp.test(full_df$`Watch Price Index`)


# First differencing of non stationary variables

diff_df <- full_df

diff_df <- diff_df %>%
  mutate(ΔUncertainty = Uncertainty - lag(Uncertainty),
         ΔInterest_Rate = Interest_Rate - lag(Interest_Rate),
         ΔPCE_Watches = PCE_Watches - lag(PCE_Watches),
         ΔM1 = M1 - lag(M1),
         ΔCCO = CCO - lag(CCO),
         ΔCPI = CPI - lag(CPI),
         ΔReal_Estate = Real_Estate - lag(Real_Estate),
         `ΔTotal Stock Market ETF Price` = `Total Stock Market ETF Price` - lag(`Total Stock Market ETF Price`),
         ΔUSD_Index = USD_Index - lag(USD_Index),
         `Δ10-Yr Yield` = `10-Yr Yield` - lag(`10-Yr Yield`),
         ΔUnemployment_Rate = Unemployment_Rate - lag(Unemployment_Rate),
         ΔPersonal_Current_Taxes = Personal_Current_Taxes - lag(Personal_Current_Taxes),
         ΔCCI = CCI - lag(CCI),
         `ΔWatch Price Index` = `Watch Price Index` - lag(`Watch Price Index`))


diff_df <- diff_df[,c('ΔTotal Stock Market ETF Price','Total Stock Market ETF Volatility','ΔReal_Estate','ΔInterest_Rate'
                      ,'Uncertainty','ΔM1','ΔCCO','ΔCCI','ΔCPI','ΔUnemployment_Rate','ΔPersonal_Current_Taxes','ΔUSD_Index'
                      ,'Δ10-Yr Yield','ΔPCE_Watches','Real_Estate_Volatility','ΔWatch Price Index')]
diff_df <- diff_df[-1,]

pp.test(diff_df$`ΔTotal Stock Market ETF Price`)
pp.test(diff_df$`Total Stock Market ETF Volatility`)
pp.test(diff_df$ΔReal_Estate)
pp.test(diff_df$ΔInterest_Rate)
pp.test(diff_df$Uncertainty)
pp.test(diff_df$ΔM1)
pp.test(diff_df$ΔCCO)
pp.test(diff_df$ΔCCI)
pp.test(diff_df$ΔCPI)
pp.test(diff_df$ΔUnemployment_Rate)
pp.test(diff_df$ΔPersonal_Current_Taxes)
pp.test(diff_df$ΔUSD_Index)
pp.test(diff_df$`Δ10-Yr Yield`)
pp.test(diff_df$ΔPCE_Watches)
pp.test(diff_df$Real_Estate_Volatility)
pp.test(diff_df$`ΔWatch Price Index`)

# Exporting to python for correlation plots

write.csv(diff_df, "C:\\Users\\Hriday Govind\\Documents\\MSc\\Thesis Final Submission\\Data\\stationary_df.csv", row.names = FALSE)

# OLS Regression

model_ols <- lm(`ΔWatch Price Index` ~ `ΔTotal Stock Market ETF Price` + `Total Stock Market ETF Volatility` 
            + ΔCCI + ΔReal_Estate + ΔUnemployment_Rate + Uncertainty + ΔInterest_Rate + ΔUSD_Index + 
              `Δ10-Yr Yield` + ΔPCE_Watches + Real_Estate_Volatility + ΔCCO + ΔCPI + ΔM1 + 
              ΔPersonal_Current_Taxes,data = diff_df)

# Robust standard errors, multicollinarity and heteroskedasticity checks

vif(model_ols)

lmtest :: bptest (model_ols)

seNeweyWest <- sqrt(diag(vcovHC(model_ols,vcov.=NeweyWest(model, lag=0, adjust=TRUE, verbose=TRUE))))

stargazer(model_ols, se = list(seNeweyWest), type = 'text')

# Short run relationship

diff_df_lag <- diff_df %>%
  mutate(
    ΔReal_Estate_lag1 = lag(ΔReal_Estate, n = 1),
    ΔReal_Estate_lag2 = lag(ΔReal_Estate, n = 2),
    Real_Estate_Volatility_lag1 = lag(ΔCCI, n = 1),
    Real_Estate_Volatility_lag2 = lag(ΔCCI, n = 2),
    ΔInterest_Rate_lag1 = lag(ΔInterest_Rate, n = 1),
    ΔInterest_Rate_lag2 = lag(ΔInterest_Rate, n = 2))

# Drop NA values
diff_df_lag <- na.omit(diff_df_lag)

# Run regression
significant_ols <- lm(`ΔWatch Price Index` ~ ΔReal_Estate_lag1 + ΔReal_Estate_lag2 +
                        Real_Estate_Volatility_lag1 + Real_Estate_Volatility_lag2 + ΔInterest_Rate_lag1 + ΔInterest_Rate_lag2,
                      data = diff_df_lag)

seNeweyWest_sig <- sqrt(diag(vcovHC(significant_ols,vcov.=NeweyWest(model, lag=0, adjust=TRUE, verbose=TRUE))))
stargazer(significant_ols, se = list(seNeweyWest_sig), type = 'text')

#### VECM
full_df

ggplot(full_df, aes(x = Date)) +
  geom_line(aes(y = `Watch Price Index`, color = "Watch Price Index (USD)")) +
  scale_color_manual(values = c("black")) +
  labs(
    title = "Watch Price Index over Time",
    x = "Year",
    y = "watch Price Index (USD)"
  )

ggplot(full_df, aes(x = Date)) +
  geom_line(aes(y = `Watch Price Index`*10, color = "Watch Price Index")) +
  geom_line(aes(y = `Real_Estate`*1500, color = "Real_Estate")) +
  geom_line(aes(y = `Total Stock Market ETF Price`*1500, color = "Total Stock Market ETF Price")) +
  geom_line(aes(y = `Personal_Current_Taxes`*70, color = "Personal_Current_Taxes")) +
  geom_line(aes(y = `CPI`*300000, color = "CPI")) +
  scale_color_manual(values = c('coral2',"orange","blue", "red","black")) +
  labs(
    title = "Investigating shape of graphs for possible long run relationships ",
    x = "Year",
    y = "Not to be Scaled"
  )
    
VARselect(full_df[,c("Watch Price Index","Real_Estate")])
VARselect(full_df[,c("Watch Price Index","CPI")])
VARselect(full_df[,c("Watch Price Index","Total Stock Market ETF Price")])
VARselect(full_df[,c("Watch Price Index","Personal_Current_Taxes")])

coint_result_re <- ca.jo(full_df[,c("Watch Price Index","Real_Estate")], type = "trace",ecdet = "trend", K = 6)
coint_result_cpi <- ca.jo(full_df[,c("Watch Price Index","CPI")], type = "trace",ecdet = "trend", K = 3)
coint_result_stock <- ca.jo(full_df[,c("Watch Price Index","Total Stock Market ETF Price")], type = "trace",ecdet = "trend", K = 3)
coint_result_pce <- ca.jo(full_df[,c("Watch Price Index","Personal_Current_Taxes")], type = "trace",ecdet = "trend", K = 3)

# view the test results
summary(coint_result_re)
summary(coint_result_cpi)
summary(coint_result_stock)
summary(coint_result_pce)

vecm_result_cpi <- VECM(full_df[,c("Watch Price Index","CPI")],lag = 3,r = 1, estim = ("ML"))
vecm_result_pce <- VECM(full_df[,c("Watch Price Index","Personal_Current_Taxes")],lag = 3,r = 1, estim = ("ML"))

summary(vecm_result_cpi)
summary(vecm_result_pce)



