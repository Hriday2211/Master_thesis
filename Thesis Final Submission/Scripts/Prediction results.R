# New attempt of prediction
library(tidyverse)
library(lubridate)
library(forecast)
library(dplyr)
library(glmnet)
library(ggplot2)
library(scales)

pred_df <- read_csv("full_df_revised.csv", col_types = cols(...1 = col_date(format = "%Y-%m-%d")))
colnames(pred_df)[1] <- "Date"

# Feature Selection
train_size <- floor(0.7 * nrow(pred_df))
train <- pred_df[1:train_size, ]
test <- pred_df[(train_size + 1):nrow(pred_df), ]

trainX <- train[,-c(1,16)]
trainY <- train[,c(16)]
CV = cv.glmnet(x = as.matrix(trainX), y = as.numeric(trainY$`Watch Price Index`),type.measure = "class",alpha = 1, nlambda = 100)

# plot(CV)

fit <- glmnet(x = as.matrix(trainX), y = as.numeric(trainY$`Watch Price Index`),alpha = 1,lambda = CV$lambda.1se)

fit$beta[,1]

# Remove unnecessary columns for final predictions
prediction_df <- within(pred_df, rm(`Total Stock Market ETF Price`, `Total Stock Market ETF Volatility`,Personal_Current_Taxes,Uncertainty,M1,Real_Estate_Volatility,CCO,CCI, PCE_Watches)) 
prediction_df$Watch_Price_4_Week_Ahead <- lead(prediction_df$`Watch Price Index`, n = 4)
x_cols <- c("CPI","10-Yr Yield","USD_Index","Interest_Rate","Real_Estate","Unemployment_Rate")

train_size_prediction <- floor(0.7 * nrow(prediction_df))
train_prediction <- prediction_df[1:train_size_prediction, ]
test_prediction <- prediction_df[(train_size_prediction + 1):nrow(prediction_df), ]
######Linear Regression
prediction_df_lm <- prediction_df

# Fit a linear regression model using the training data
model_lm_fit <- lm(Watch_Price_4_Week_Ahead ~ ., data = train_prediction[, c("Watch_Price_4_Week_Ahead", x_cols)])

# Print the summary of the model
print(summary(model_lm_fit))

# Make predictions on the test data using the fitted model
pred_lm <- predict(model_lm_fit, newdata = test_prediction[, x_cols])

# Print the accuracy metrics
accuracy(pred_lm[-(nrow(test_prediction)-4)], test_prediction$Watch_Price_4_Week_Ahead[-(nrow(test_prediction)-4)])

###### ARIMA
x_data_train <- train_prediction[,x_cols]
x_data_test <- test_prediction[,x_cols]

model_arima_fit <- auto.arima(train_prediction$Watch_Price_4_Week_Ahead, xreg = as.matrix(x_data_train), seasonal = TRUE)
print(summary(model_arima_fit))

pred <- forecast(model_arima_fit, h = nrow(test_prediction), xreg = as.matrix(x_data_test))

accuracy(pred$mean[c(1:84)], test_prediction$Watch_Price_4_Week_Ahead[c(1:84)])

results_arima <- as.data.frame(pred$mean[c(1:84)])

predicted_arima <- ts(results_arima[,c(1)], start = c(2021,4,15),frequency = 52)

####### Prophet
library(prophet)

# prepare data
prediction_df_prophet <- prediction_df

names(prediction_df_prophet)[names(prediction_df_prophet) == "Total Stock Market ETF Price"] <- "Total_Stock_Market_ETF_Price"
names(prediction_df_prophet)[names(prediction_df_prophet) == "Total Stock Market ETF Volatility"] <- "Total_Stock_Market_ETF_Volatility"
names(prediction_df_prophet)[names(prediction_df_prophet) == "Watch Price Index"] <- "Watch_Price_Index"
names(prediction_df_prophet)[names(prediction_df_prophet) == "10-Yr Yield"] <- "Ten_Yr_Yield"

train_size_prediction_prophet <- floor(0.7 * nrow(prediction_df_prophet))
train_prediction_prophet <- prediction_df_prophet[1:train_size_prediction_prophet, ]
test_prediction_prophet <- prediction_df_prophet[(train_size_prediction_prophet + 1):nrow(prediction_df_prophet), ]

# create the dataframe in the correct format for Prophet
train_prophet <- train_prediction_prophet[,c(1,9)]
colnames(train_prophet) <- c('ds', 'y')
for (col in setdiff(names(prediction_df_prophet), c("Date","Watch_Price_4_Week_Ahead"))) {
  train_prophet[[col]] <- train_prediction_prophet[[col]]
}

# fit the Prophet model with regressors
m <- prophet()
for (col in setdiff(names(prediction_df_prophet), c("Date","Watch_Price_4_Week_Ahead"))) {
  m <- add_regressor(m, col)
}
m <- fit.prophet(m, train_prophet)

# create the dataframe for future predictions
future_prophet <- test_prediction_prophet[,c(1,9)]
colnames(future_prophet) <- c('ds', 'y')
for (col in setdiff(names(prediction_df_prophet), c("Date","Watch_Price_4_Week_Ahead"))) {
  future_prophet[[col]] <- test_prediction_prophet[[col]]
}

# make predictions and plot the results
forecast <- predict(m, future_prophet)

results_prophet <- as.data.frame(forecast$yhat[c(1:84)])

predicted_prophet <- ts(results_prophet[,c(1)], start = c(2021,4,15),frequency = 52)

predicted_prophet
accuracy(predicted_prophet, test_prediction$Watch_Price_4_Week_Ahead[c(1:84)])

# Visualization of data
df1 <- pred_df[c(1,16)]
num_missing <- nrow(df1) - length(predicted_prophet)
missing_dates <- rep(NA, num_missing)
visualization_df <- cbind(df1, predicted_prophet = c(missing_dates, predicted_prophet))
names(visualization_df)[names(visualization_df) == "predicted_prophet"] <- "Predicted Price (Prophet)"

# Convert the Date column to a Date type
visualization_df$Date <- as.Date(visualization_df$Date)

ggplot(visualization_df, aes(x = Date)) +
  geom_line(aes(y = `Watch Price Index`, color = "Watch Price Index")) +
  geom_line(aes(y = `Predicted Price (Prophet)`, color = "Predicted Price (Prophet)")) +
  scale_color_manual(values = c("red", "black")) +
  labs(x = "Year", y = "Price (USD)", title = "Plot of Watch Price Index and Predicted Price") +
  theme_bw() +
  theme(legend.position = "top") +
  scale_x_date(labels = date_format("%Y"))
