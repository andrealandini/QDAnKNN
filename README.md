# andrealandini-QDAnKNN
I've applied the Quadratic Discriminant Analysis and K-Nearest Neighboursto the movements of NASDAQ of the last 20 years.

I've also applied the same procedure to a long-short portfolio,
where losses in the long position are offset by gains in the short one,
thus minimising the standard deviation of the spot position by shorting an adequate amount of shares belonging to the futures position.

Output:
________________________________________________________________________________________________________________________ 

QDA Model for Direction~Lag1 + Lag2 on Nasdaq
#using data before 2021 for training, 2021 data for testing

	 Confusion Matrix

              ixic.Direction.2021
ixic.qda.class Down  Up
          Down    4   7
          Up     95 124

The confusion matrix suggests that on days when it predicts an increase in the market, it has a 55.65217 % accuracy rate.
56.621 % of daily movements have been correctly predicted.



________________________________________________________________________________________________________________________

KNN Model for Direction~Lag1 + Lag2 on Nasdaq
#using data before 2021 for training, 2021 data for testing

	 Confusion Matrix

             ixic.Direction.2021
ixic.knn.pred Down Up
         Down   52 55
         Up     47 76

The confusion matrix suggests that on days when it predicts an increase in the market, it has a 61.78862 % accuracy rate.
55.65217 % of daily movements have been correctly predicted.



________________________________________________________________________________________________________________________

QDA Model for Direction~Lag1 + Lag2 on Long Short Portfolio
#using data before 2021 for training, 2021 data for testing

	 Confusion Matrix

            df.Direction.2021
df.qda.class Down Up
        Down   97 90
        Up     31 11

The confusion matrix suggests that on days when it predicts an increase in the market, it has a 26.19048 % accuracy rate.
47.16157 % of daily movements have been correctly predicted.



________________________________________________________________________________________________________________________

KNN Model for Direction~Lag1 + Lag2 on Long Short Portfolio
#using data before 2021 for training, 2021 data for testing

	 Confusion Matrix

           df.Direction.2021
df.knn.pred Down Up
       Down   75 58
       Up     53 43

The confusion matrix suggests that on days when it predicts an increase in the market, it has a 44.79167 % accuracy rate.
51.52838 % of daily movements have been correctly predicted.



________________________________________________________________________________________________________________________
