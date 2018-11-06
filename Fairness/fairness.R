
library(psych) 

cat("\014")

# colors payoffs
color1 = '#00008BDD'
color2 = '#8B8B00DD'

# colors differences
color3 = '#00008B66'
color4 = '#8B8B0066'

#################
### Fairness data
#################
data_users <- read.table("../data/fairness.csv", header=TRUE, sep=",")

### Payoff per type of fairness
payoff_fairness_equal_payoff <- c(20, 20, 20, 20, 20, 20)
payoff_fairness_equal_contribution <- c(0, 10, 20, 20, 30, 40)
payoff_fairness_relative_endowmnets <- c(10, 15, 20, 20, 25, 30)

payoff_20 <- data_users$payoff[data_users$endowment==20]
describe(payoff_20)
payoff_30 <- data_users$payoff[data_users$endowment==30]
describe(payoff_30)
payoff_40_equal <- data_users$payoff[data_users$endowment==40 & data_users$unequal==0]
describe(payoff_40_equal)
payoff_40_unequal <- data_users$payoff[data_users$endowment==40 & data_users$unequal==1]
describe(payoff_40_unequal)
payoff_50 <- data_users$payoff[data_users$endowment==50]
describe(payoff_50)
payoff_60 <- data_users$payoff[data_users$endowment==60]
describe(payoff_60)

payoff_means <- c(mean(payoff_20), mean(payoff_30), mean(payoff_40_equal), mean(payoff_40_unequal), mean(payoff_50), mean(payoff_60))
payoff_sd <- c(sd(payoff_20), sd(payoff_30), sd(payoff_40_equal), sd(payoff_40_unequal), sd(payoff_50), sd(payoff_60))


## Error bar functions
error.bar <- function(x, y, upper, lower=upper, length=0.1,...){
  if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
    stop("vectors must be same length")
  arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length, ...)
}

##################
### PAYOFF PURE
##################

pdf("img/payoff.pdf")
names(payoff_means) <- c('20', '30', '40', '40', '50', '60')
barx <- barplot(payoff_means,ylim=c(0,40), col=c(color1,color1,color1,color2,color1,color1), axis.lty=1, border=NA, xlab="Endowment", ylab="Payoff")
error.bar(barx,payoff_means, 1.96*payoff_sd/10)
legend("topleft", legend = c("Unequal Treatment", "Equal Treatment"), fill = c(color1,color2), bty = "n")
dev.off()

###########################
### PAYOFF EQUAL PAYOFF
###########################

pdf("img/fairness_equal_payoff.pdf")
names(payoff_fairness_equal_payoff) <- c('20', '30', '40', '40', '50', '60')
barx <- barplot(payoff_fairness_equal_payoff,
                ylim=c(0,40), 
                col=c(color1,color1,color1,color2,color1,color1), 
                border=NA, axis.lty=1, 
                xlab="Endowment", ylab="Payoff")
legend("topleft", legend = c("Unequal Treatment", "Equal Treatment"), fill = c(color1,color2), bty = "n")
dev.off()


pdf("img/diff_payoff_equal_payoff.pdf")
diff_payoff_equal_payoff <- payoff_means-payoff_fairness_equal_payoff
names(diff_payoff_equal_payoff) <- c('20', '30', '40', '40', '50', '60')
barx <- barplot(diff_payoff_equal_payoff,ylim=c(-20,20), col=c(color3,color3,color3,color4,color3,color3), border=NA, axis.lty=1, xlab="Endowment", ylab="Differences Payoff (Equal Payoff)")
legend("topleft", legend = c("Unequal Treatment", "Equal Treatment"), fill = c(color3,color4), bty = "n")
dev.off()

#################################
### PAYOFF EQUAL CONTRIBUTION
#################################

pdf("img/fairness_equal_contribution.pdf")
names(payoff_fairness_equal_contribution) <- c('20', '30', '40', '40', '50', '60')
barx <- barplot(payoff_fairness_equal_contribution,ylim=c(0,40), col=cbind(color1,color1,color1,color2,color1,color1), border=NA, axis.lty=1, xlab="Endowment", ylab="Payoff")
legend("topleft", legend = c("Unequal Treatment", "Equal Treatment"), fill = c(color1,color2), bty = "n")
dev.off()

pdf("img/diff_payoff_equal_contribution.pdf")
diff_payoff_equal_contribution <- payoff_means-payoff_fairness_equal_contribution
barx <- barplot(diff_payoff_equal_contribution,ylim=c(-20,20), col=c(color3,color3,color3,color4,color3,color3), border=NA, axis.lty=1, xlab="Endowment", ylab="Differences Payoff (Equal Contribution)")
legend("topleft", legend = c("Unequal Treatment", "Equal Treatment"), fill = c(color3,color4), bty = "n")
dev.off()

####################################
### PAYOFF RELATIVE CONTRIBUTION
####################################

pdf("img/fairness_relative.pdf")
names(payoff_fairness_relative_endowmnets) <- c('20', '30', '40', '40', '50', '60')
barx <- barplot(payoff_fairness_relative_endowmnets,ylim=c(0,40), col=c(color1,color1,color1,color2,color1,color1), border=NA, axis.lty=1, xlab="Endowment", ylab="Payoff")
legend("topleft", legend = c("Unequal Treatment", "Equal Treatment"), fill = c(color1,color2), bty = "n")
dev.off()

pdf("img/diff_payoff_relative.pdf")
diff_payoff_relative_endowment <- payoff_means-payoff_fairness_relative_endowmnets
barx <- barplot(diff_payoff_relative_endowment ,ylim=c(-20,20), names.arg=c("20","30","40","40","50","60"), col=c(color3,color3,color3,color4,color3,color3), border=NA, axis.lty=1, xlab="Endowment", ylab="Differences Payoff (Relative Endowment)")
legend("topleft", legend = c("Unequal Treatment", "Equal Treatment"), fill = c(color1,color2), bty = "n")
dev.off()


