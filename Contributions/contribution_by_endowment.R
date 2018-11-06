library(psych)

# colors bold
color1 = '#00008BDD'
color2 = '#8B8B00DD'

# colors transparent
color3 = '#00008B66'
color4 = '#8B8B0066'

cat("\014")

#########################
### Average Contribution
#########################

data_users <- read.table("../data/users.csv", header=TRUE, sep=",")

### Contribution per round
data_users$contribution <- (data_users$contribution)/10

### Contribution per endowment
contribution_20 <- (data_users$contribution[data_users$endowment==20])
describe(contribution_20)

contribution_30 <- (data_users$contribution[data_users$endowment==30])
describe(contribution_30)

contribution_40_equal <- (data_users$contribution[data_users$endowment==40 & data_users$unequal==0])
describe(contribution_40_equal)

contribution_40_unequal <- (data_users$contribution[data_users$endowment==40 & data_users$unequal==1])
describe(contribution_40_unequal)

contribution_50 <- (data_users$contribution[data_users$endowment==50 & data_users$minor==0])
describe(contribution_50)

contribution_60 <- (data_users$contribution[data_users$endowment==60 & data_users$minor==0])
describe(contribution_60)

### Stats contributions
stats_contribution <- aggregate((data_users$contribution), 
                    by = list(endowment = data_users$endowment, unequal=data_users$unequal),
                    FUN = function(x) c(mean = mean(x), sd = sd(x),n = length(x)))

stats_contribution <- do.call(data.frame, stats_contribution)
stats_contribution$se <- stats_contribution$x.sd / sqrt(stats_contribution$x.n)
colnames(stats_contribution) <- c("endowment", "unequal", "mean", "sd", "n", "se")
stats_contribution$names <- c(paste(stats_contribution$endowment))

### Sort contributions
stats_contribution <- rbind(stats_contribution[2,], stats_contribution[3,],stats_contribution[4,],stats_contribution[1,],stats_contribution[5,],stats_contribution[6,])

### Plot contributions
error.bar <- function(x, y, upper, lower=upper, length=0.1,...){
  if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
    stop("vectors must be same length")
  arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length, ...)
}

pdf("img/contributions.pdf")
barx <- barplot(stats_contribution$mean, names.arg=stats_contribution$names,ylim=c(0,4), col=c(color1, color1,color1,color2,color1,color1),border=NA, axis.lty=1, xlab="Endowment", ylab="Contribution")
error.bar(barx,stats_contribution$mean, 1.96*stats_contribution$sd/10)
legend("topleft", legend = c("Unequal Treatment", "Equal Treatment"), fill = c(color1, color2), bty = "n")
dev.off()

# t-test between contributions with different endowments
# t.test(contribution_XX, contribution_YY)

cat("\014")

##############################
### Average Contribution Norm
##############################
data_users <- read.table("../data/users.csv", header=TRUE, sep=",")

data_users$contribution_norm <- (data_users$contribution_norm)

### Contributions per endowment
contribution_20 <- (data_users$contribution_norm[data_users$endowment==20])
describe(contribution_20)
contribution_30 <- (data_users$contribution_norm[data_users$endowment==30])
describe(contribution_30)
contribution_40_equal <- (data_users$contribution_norm[data_users$endowment==40 & data_users$unequal==0])
describe(contribution_40_equal)
contribution_40_unequal <- (data_users$contribution_norm[data_users$endowment==40 & data_users$unequal==1])
describe(contribution_40_unequal)
contribution_50 <- (data_users$contribution_norm[data_users$endowment==50 & data_users$minor==0])
describe(contribution_50)
contribution_60 <- (data_users$contribution_norm[data_users$endowment==60 & data_users$minor==0])
describe(contribution_60)

### Contributions stats
stats_contribution <- aggregate((data_users$contribution_norm), 
                                by = list(endowment = data_users$endowment, unequal=data_users$unequal),
                                FUN = function(x) c(mean = mean(x), sd = sd(x),n = length(x)))

stats_contribution <- do.call(data.frame, stats_contribution)
stats_contribution$se <- stats_contribution$x.sd / sqrt(stats_contribution$x.n)
colnames(stats_contribution) <- c("endowment", "unequal", "mean", "sd", "n", "se")
stats_contribution$names <- c(paste(stats_contribution$endowment))

### Sort contributions
stats_contribution <- rbind(stats_contribution[2,], stats_contribution[3,],stats_contribution[4,],stats_contribution[1,],stats_contribution[5,],stats_contribution[6,])

### Plot contributions
error.bar <- function(x, y, upper, lower=upper, length=0.1,...){
  if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
    stop("vectors must be same length")
  arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length, ...)
}

pdf("img/contributions_norm.pdf")
barx <- barplot(stats_contribution$mean, names.arg=stats_contribution$names,ylim=c(0,1.1), col=c(color1, color1,color1,color2,color1,color1), border=NA, axis.lty=1, xlab="Endowment", ylab="Contribution")
error.bar(barx,stats_contribution$mean, 1.96*stats_contribution$sd/10)
points(barx, c(1,1,1,1,0.8,0.66), col=c(color1, color1,color1,color2,color1,color1), bg=c(color1, color1,color1,color2,color1,color1), pch = 21, cex=1.5)
abline(h = 0.5, col="black", lwd=1, lty=2)
legend("topright", legend = c("Unequal Treatment", "Equal Treatment"), fill = c(color1, color2), bty = "n")

dev.off()

