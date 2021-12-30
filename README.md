# andrealandini-QDAnKNN
I've applied the Quadratic Discriminant Analysis and K-Nearest Neighboursto the movements of NASDAQ of the last 20 years.

I've also applied the same procedure to a long-short portfolio,
where losses in the long position are offset by gains in the short one,
thus minimising the standard deviation of the spot position by shorting an adequate amount of shares belonging to the futures position.

Output:
________________________________________________________________________________________________________________________ 

*QDA Model for Direction~Lag1 + Lag2 on Nasdaq*
The confusion matrix suggests that on days when it predicts an increase in the market, it has a 55.65217 % accuracy rate.
56.621 % of daily movements have been correctly predicted.


________________________________________________________________________________________________________________________

*KNN Model for Direction~Lag1 + Lag2 on Nasdaq*
The confusion matrix suggests that on days when it predicts an increase in the market, it has a 61.78862 % accuracy rate.
55.65217 % of daily movements have been correctly predicted.



________________________________________________________________________________________________________________________

*QDA Model for Direction~Lag1 + Lag2 on Long Short Portfolio*
The confusion matrix suggests that on days when it predicts an increase in the market, it has a 26.19048 % accuracy rate.
47.16157 % of daily movements have been correctly predicted.



________________________________________________________________________________________________________________________

*KNN Model for Direction~Lag1 + Lag2 on Long Short Portfolio*
The confusion matrix suggests that on days when it predicts an increase in the market, it has a 44.79167 % accuracy rate.
51.52838 % of daily movements have been correctly predicted.

