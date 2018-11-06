library(psych)

# colors bold
color1 = '#00008BDD'
color2 = '#8B8B00DD'

# colors transparent
color3 = '#00008B66'
color4 = '#8B8B0066'

cat("\014")

###################
### Average payoff
###################

data_users <- read.table("../data/users.csv", header=TRUE, sep=",")

### payoffs per round
data_users$payoff <- (data_users$payoff)/10

### payoff per endowment
payoff_20 <- (data_users$payoff[data_users$endowment==20])
describe(payoff_20)

payoff_30 <- (data_users$payoff[data_users$endowment==30])
describe(payoff_30)

payoff_40_equal <- (data_users$payoff[data_users$endowment==40 & data_users$unequal==0])
describe(payoff_40_equal)

payoff_40_unequal <- (data_users$payoff[data_users$endowment==40 & data_users$unequal==1])
describe(payoff_40_unequal)

payoff_50 <- (data_users$payoff[data_users$endowment==50 & data_users$minor==0])
describe(payoff_50)

payoff_60 <- (data_users$payoff[data_users$endowment==60 & data_users$minor==0])
describe(payoff_60)

### payoffs stats
stats_payoff <- aggregate((data_users$payoff), 
                    by = list(endowment = data_users$endowment, unequal=data_users$unequal),
                    FUN = function(x) c(mean = mean(x), sd = sd(x),n = length(x)))

stats_payoff <- do.call(data.frame, stats_payoff)
stats_payoff$se <- stats_payoff$x.sd / sqrt(stats_payoff$x.n)
colnames(stats_payoff) <- c("endowment", "unequal", "mean", "sd", "n", "se")
stats_payoff$names <- c(paste(stats_payoff$endowment))

### Sort payoffs
stats_payoff <- rbind(stats_payoff[2,], stats_payoff[3,],stats_payoff[4,],stats_payoff[1,],stats_payoff[5,],stats_payoff[6,])

### Plot payoffs
error.bar <- function(x, y, upper, lower=upper, length=0.1,...){
  if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
    stop("vectors must be same length")
  arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length, ...)
}

pdf("img/payoffs.pdf")
barx <- barplot(stats_payoff$mean, names.arg=stats_payoff$names,ylim=c(0,4), col=c(color1, color1,color1,color2,color1,color1),border=NA, axis.lty=1, xlab="Endowment", ylab="payoff")
error.bar(barx,stats_payoff$mean, 1.96*stats_payoff$sd/10)
legend("topleft", legend = c("Unequal Treatment", "Equal Treatment"), fill = c(color1, color2), bty = "n")
dev.off()

# t-test between payoffs with different endowments
# t.test(payoff_XX, payoff_YY)

cat("\014")

##############################
### Average payoff Norm
##############################
data_users <- read.table("../data/users.csv", header=TRUE, sep=",")

data_users$payoff_norm <- (data_users$payoff_norm)

### payoffs per endowment
payoff_20 <- (data_users$payoff_norm[data_users$endowment==20])
describe(payoff_20)
payoff_30 <- (data_users$payoff_norm[data_users$endowment==30])
describe(payoff_30)
payoff_40_equal <- (data_users$payoff_norm[data_users$endowment==40 & data_users$unequal==0])
describe(payoff_40_equal)
payoff_40_unequal <- (data_users$payoff_norm[data_users$endowment==40 & data_users$unequal==1])
describe(payoff_40_unequal)
payoff_50 <- (data_users$payoff_norm[data_users$endowment==50 & data_users$minor==0])
describe(payoff_50)
payoff_60 <- (data_users$payoff_norm[data_users$endowment==60 & data_users$minor==0])
describe(payoff_60)

### payoffs stats
stats_payoff <- aggregate((data_users$payoff_norm), 
                                by = list(endowment = data_users$endowment, unequal=data_users$unequal),
                                FUN = function(x) c(mean = mean(x), sd = sd(x),n = length(x)))

stats_payoff <- do.call(data.frame, stats_payoff)
stats_payoff$se <- stats_payoff$x.sd / sqrt(stats_payoff$x.n)
colnames(stats_payoff) <- c("endowment", "unequal", "mean", "sd", "n", "se")
stats_payoff$names <- c(paste(stats_payoff$endowment))

### Sort payoffs
stats_payoff <- rbind(stats_payoff[2,], stats_payoff[3,],stats_payoff[4,],stats_payoff[1,],stats_payoff[5,],stats_payoff[6,])

### Plot payoffs
error.bar <- function(x, y, upper, lower=upper, length=0.1,...){
  if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
    stop("vectors must be same length")
  arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length, ...)
}

pdf("img/payoffs_norm.pdf")
barx <- barplot(stats_payoff$mean, names.arg=stats_payoff$names,ylim=c(0,1.1), col=c(color1, color1,color1,color2,color1,color1), border=NA, axis.lty=1, xlab="Endowment", ylab="payoff")
error.bar(barx,stats_payoff$mean, 1.96*stats_payoff$sd/10)
points(barx, c(1,1,1,1,0.8,0.66), col=c(color1, color1,color1,color2,color1,color1), bg=c(color1, color1,color1,color2,color1,color1), pch = 21, cex=1.5)
abline(h = 0.5, col="black", lwd=1, lty=2)
legend("topright", legend = c("Unequal Treatment", "Equal Treatment"), fill = c(color1, color2), bty = "n")

dev.off()

