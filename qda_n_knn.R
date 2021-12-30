ticker <- c('AAPL','JOBS','GOOG','^IXIC','^GSPC')

suppressMessages(library(dplyr))
suppressMessages(library(quantmod))
start <- as.Date("1999-01-01")
end <- as.Date("2021-12-01")

for (i in ticker){
  getSymbols(i, src = "yahoo", from = start, to = end)
}

l <- list(AAPL,JOBS,GOOG,IXIC,GSPC)

for(i in 1:length(l)){
  #print('funziona')
  l[[i]]$daily.return <- periodReturn(l[[i]][,6],period='daily',
                                      subset=NULL,type='log',leading=TRUE)
}

suppressMessages(library(ggplot2))
for(i in 1:length(l)){
  l[[i]] <- fortify(l[[i]])
  colnames(l[[i]]) <- c('Date',
                        paste(ticker[i],'Open',collapse = '',sep='.'),
                        paste(ticker[i],'High',collapse = '',sep='.'),
                        paste(ticker[i],'Low',collapse = '',sep='.'),
                        paste(ticker[i],'Close',collapse = '',sep='.'),
                        paste(ticker[i],'Volume',collapse = '',sep='.'),
                        paste(ticker[i],'Adjusted',collapse = '',sep='.'),
                        paste(ticker[i],'Daily.Return',collapse = '',sep='.')
  )
}

AAPL <- l[[1]]
JOBS <- l[[2]]
GOOG <- l[[3]]
IXIC <- l[[4]]
GSPC <- l[[5]]
#####################################CHECK######################################

suppressMessages(library(PerformanceAnalytics))

IXIC$Direction <- ifelse(test=IXIC$`^IXIC.Daily.Return`>0,yes='Up',no='Down')
ixic <- IXIC[,c(1,8,9)]



ixic$Lag1[2:dim(ixic)[1]] <- ixic$`^IXIC.Daily.Return`[2:dim(ixic)[1]-1]
ixic$Lag2[3:dim(ixic)[1]] <- ixic$`^IXIC.Daily.Return`[3:dim(ixic)[1]-2]
ixic <- ixic[,c('Date','^IXIC.Daily.Return','Lag1','Lag2','Direction')]

suppressMessages(library(lubridate))
date <- ixic$Date
ixic$Year <- year(date)

ixic <- na.omit(ixic)
suppressMessages(library(class))
train <- (ixic$Year<2021) #train condition
ixic <- na.omit(ixic)
ixic.2021 <- ixic[!ixic$Year<2021,]
#ixic.train <- ixic[ixic$Year<2021,]
ixic.Direction.2021 <- ixic$Direction[!ixic$Year<2021]

ixic.train.x <- cbind(ixic$Lag1,ixic$Lag2)[ixic$Year<2021,]
ixic.test.x <- cbind(ixic$Lag1,ixic$Lag2)[!ixic$Year<2021,]
ixic.train.Direction <- df$Direction[ixic$Year<2021]

set.seed(11)
ixic.knn.pred <- knn(ixic.train.x,ixic.test.x,ixic.train.Direction,k=3)
cm.knn.ixic <- table(ixic.knn.pred,ixic.Direction.2021)
test.knn.ixic <- mean(ixic.knn.pred==ixic.Direction.2021)
train.knn.ixic <- cm.knn.ixic['Up','Up'] / sum(cm.knn.ixic[2,])


suppressMessages(library(MASS))
ixic.qda.fit <- qda(Direction~Lag1 + Lag2, data=ixic,subset=ixic$Year<2021)
ixic.qda.class <- predict(ixic.qda.fit,ixic.2021)$class
cm.ixic <- table(ixic.qda.class,ixic.Direction.2021)
train.ixic <- mean(ixic.qda.class==ixic.Direction.2021)
test.ixic <- cm.ixic['Up','Up'] / sum(cm.ixic[2,])
#####################################CHECK######################################
suppressMessages(library(PerformanceAnalytics))

AAPL.returns <- AAPL$AAPL.Daily.Return
IXIC.returns <- IXIC$`^IXIC.Daily.Return`
AAPL.returns <- na.omit(AAPL.returns)
IXIC.returns <- na.omit(IXIC.returns)

corr <- cor(AAPL.returns,IXIC.returns)
AAPL.sd <- sd(AAPL.returns)
IXIC.sd <- sd(IXIC.returns)


HedgeRatio <- corr*AAPL.sd / IXIC.sd

v <- as.numeric(vector())
for(i in 1:nrow(AAPL)){
  x <- i +1
  spot <- as.numeric(AAPL[c(i:x),2])
  futures <- as.numeric(IXIC[c(i:x),2])
  Initial.position <- spot[1] - HedgeRatio*futures[1]
  as.numeric(Initial.position)
  spot.gain <- spot[2] - spot[1]
  futures.gain <- -(HedgeRatio*futures[2] - HedgeRatio*futures[1])
  New.position <- spot[2] - HedgeRatio*futures[2]
  gain.fromg.hedge <- (New.position - Initial.position)
  v <- c(v,(New.position - Initial.position))
}

suppressMessages(library(dplyr))
df <- data.frame(AAPL$Date,v)
colnames(df) <- c('Date',
                  'Gain.From.Hedge')

df$Direction <- ifelse(test=df$Gain.From.Hedge>0,yes='Up',no='Down')

df$Lag1[2:dim(df)[1]] <- df$Gain.From.Hedge[2:dim(df)[1]-1]
df$Lag2[3:dim(df)[1]] <- df$Gain.From.Hedge[3:dim(df)[1]-2]
df <- df[,c('Date','Gain.From.Hedge','Lag1','Lag2','Direction')]

suppressMessages(library(lubridate))
date <- df$Date
df$Year <- year(date)
df <- na.omit(df)
suppressMessages(library(class))
df.train <- (df$Year<2021)
df <- na.omit(df)
df.2021 <- df[!df$Year<2021,]
df.Direction.2021 <- df$Direction[!df$Year<2021]







#KNN
df.train.x <- cbind(df$Lag1,df$Lag2)[df$Year<2021,]
df.test.x <- cbind(df$Lag1,df$Lag2)[!df$Year<2021,]
df.train.Direction <- df$Direction[df$Year<2021]

set.seed(1)
df.knn.pred <- knn(df.train.x,df.test.x,df.train.Direction,k=3)
cm.knn.df <- table(df.knn.pred,df.Direction.2021)
test.knn.df <- mean(df.knn.pred==df.Direction.2021)
train.knn.df <- cm.knn.df['Up','Up'] / sum(cm.knn.df[2,])

#QDA
suppressMessages(library(MASS))
df.qda.fit <- qda(Direction~Lag1 + Lag2, data=df,subset=df$Year<2021)
df.qda.class <- predict(df.qda.fit,df.2021)$class
cm.qda.df <- table(df.qda.class,df.Direction.2021)
test.qda.df <- mean(df.qda.class==df.Direction.2021)
train.qda.df <- cm.qda.df['Up','Up'] / sum(cm.qda.df[2,])


###############################################################################
#cm.ixic
#test.ixic
#train.ixic

#cm.knn.df
#train.knn.df
#test.knn.df

#cm.qda.df
#train.qda.df
#test.qda.df

output <- function(q,w,e,r,t,y,a,s,d,f,z){
  cat(q)
  cat('\n')
  cat(w)
  cat('\n')
  cat('\n')
  cat('\t',e)
  cat('\n')
  cat('\n')
  print(r)
  cat('\n')
  cat(t,y*100,a)
  cat('\n')
  cat(s,d*100,f,z)
  cat('\n')
  cat('\n')
  cat('\n')
  cat('\n')
  cat('\n')
  cat('\n')
}


output('QDA Model for Direction~Lag1 + Lag2 on Nasdaq',
       '#using data before 2021 for training, 2021 data for testing',
       'Confusion Matrix',
       cm.ixic,
       'Vi è un riscontro nei del modello nei dati di prova del',train.ixic,'%',
       'Il modello prevede il',test.ixic,'%','dei dati.')
output('KNN Model for Direction~Lag1 + Lag2 on Nasdaq',
       '#using data before 2021 for training, 2021 data for testing',
       'Confusion Matrix',
       cm.knn.ixic,
       'Vi è un riscontro nei del modello nei dati di prova del',train.knn.ixic,'%',
       'Il modello prevede il',test.knn.ixic,'%','dei dati.')

output('KNN Model for Direction~Lag1 + Lag2 on Long Short Portfolio',
       '#using data before 2021 for training, 2021 data for testing',
       'Confusion Matrix',
       cm.knn.df,
       'Vi è un riscontro nei del modello nei dati di prova del',train.knn.df,'%',
       'Il modello prevede il',test.knn.df,'%','dei dati.')
output('QDA Model for Direction~Lag1 + Lag2 on Long Short Portfolio',
       '#using data before 2021 for training, 2021 data for testing',
       'Confusion Matrix',
       cm.qda.df,
       'Vi è un riscontro nei del modello nei dati di prova del',train.qda.df,'%',
       'Il modello prevede il',test.qda.df,'%','dei dati.')
output('QDA Model for Direction~Lag1 + Lag2 on Long Short Portfolio',
       '#using data before 2021 for training, 2021 data for testing',
       'Confusion Matrix',
       cm.qda.df,
       'Vi è un riscontro nei del modello nei dati di prova del',train.qda.df,'%',
       'Il modello prevede il',test.qda.df,'%','dei dati.')

