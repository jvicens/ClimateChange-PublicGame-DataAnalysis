
cat("\014")

# colors bold
color1 = '#00008BDD'
color2 = '#8B8B00DD'

# colors transparent
color3 = '#00008B66'
color4 = '#8B8B0066'

#################
### Games data
#################
data_games <- read.table("../data/games.csv", header=TRUE, sep=",")

rounds_equal_VALID <- 0
rounds_unequal_VALID <- 0
rounds_equal_error_VALID <- 0
rounds_unequal_error_VALID <- 0
### round 1

ronda1 <- aggregate(data_games$ronda1, 
                          by = list(equal = data_games$homogenea, valid=data_games$valid_users),
                          FUN = function(x) c(mean = mean(x), sd = sd(x),n = length(x)))

ronda1 <- do.call(data.frame, ronda1)
ronda1$se <- ronda1$x.sd / sqrt(ronda1$x.n)
colnames(ronda1) <- c("equal", "valid", "mean", "sd", "n", "se")

rounds_equal_VALID[1] <- c(ronda1$mean[4])
rounds_equal_error_VALID[1] <- c(1.96*ronda1$sd[4]/10)
rounds_unequal_VALID[1] <- c(ronda1$mean[3])
rounds_unequal_error_VALID[1] <- c(1.96*ronda1$sd[3]/10)

### round 2

ronda2 <- aggregate(data_games$ronda2, 
                    by = list(equal = data_games$homogenea, valid=data_games$valid_users),
                    FUN = function(x) c(mean = mean(x), sd = sd(x),n = length(x)))

ronda2 <- do.call(data.frame, ronda2)
ronda2$se <- ronda2$x.sd / sqrt(ronda2$x.n)
colnames(ronda2) <- c("equal", "valid", "mean", "sd", "n", "se")

rounds_equal_VALID[2] <- c(ronda2$mean[4])
rounds_equal_error_VALID[2] <- c(1.96*ronda2$sd[4]/10)
rounds_unequal_VALID[2] <- c(ronda2$mean[3])
rounds_unequal_error_VALID[2] <- c(1.96*ronda2$sd[3]/10)

### round 3

ronda3 <- aggregate(data_games$ronda3, 
                    by = list(equal = data_games$homogenea, valid=data_games$valid_users),
                    FUN = function(x) c(mean = mean(x), sd = sd(x),n = length(x)))

ronda3 <- do.call(data.frame, ronda3)
ronda3$se <- ronda3$x.sd / sqrt(ronda3$x.n)
colnames(ronda3) <- c("equal", "valid", "mean", "sd", "n", "se")

rounds_equal_VALID[3] <- c(ronda3$mean[4])
rounds_equal_error_VALID[3] <- c(1.96*ronda3$sd[4]/10)
rounds_unequal_VALID[3] <- c(ronda3$mean[3])
rounds_unequal_error_VALID[3] <- c(1.96*ronda3$sd[3]/10)

### round 4

ronda4 <- aggregate(data_games$ronda4, 
                    by = list(equal = data_games$homogenea, valid=data_games$valid_users),
                    FUN = function(x) c(mean = mean(x), sd = sd(x),n = length(x)))

ronda4 <- do.call(data.frame, ronda4)
ronda4$se <- ronda4$x.sd / sqrt(ronda4$x.n)
colnames(ronda4) <- c("equal", "valid", "mean", "sd", "n", "se")

rounds_equal_VALID[4] <- c(ronda4$mean[4])
rounds_equal_error_VALID[4] <- c(1.96*ronda4$sd[4]/10)
rounds_unequal_VALID[4] <- c(ronda4$mean[3])
rounds_unequal_error_VALID[4] <- c(1.96*ronda4$sd[3]/10)

### round 5

ronda5 <- aggregate(data_games$ronda5, 
                    by = list(equal = data_games$homogenea, valid=data_games$valid_users),
                    FUN = function(x) c(mean = mean(x), sd = sd(x),n = length(x)))

ronda5 <- do.call(data.frame, ronda5)
ronda5$se <- ronda5$x.sd / sqrt(ronda5$x.n)
colnames(ronda5) <- c("equal", "valid", "mean", "sd", "n", "se")

rounds_equal_VALID[5] <- c(ronda5$mean[4])
rounds_equal_error_VALID[5] <- c(1.96*ronda5$sd[4]/10)
rounds_unequal_VALID[5] <- c(ronda5$mean[3])
rounds_unequal_error_VALID[5] <- c(1.96*ronda5$sd[3]/10)

### round 6

ronda6 <- aggregate(data_games$ronda6, 
                    by = list(equal = data_games$homogenea, valid=data_games$valid_users),
                    FUN = function(x) c(mean = mean(x), sd = sd(x),n = length(x)))

ronda6 <- do.call(data.frame, ronda6)
ronda6$se <- ronda6$x.sd / sqrt(ronda6$x.n)
colnames(ronda6) <- c("equal", "valid", "mean", "sd", "n", "se")

rounds_equal_VALID[6] <- c(ronda6$mean[4])
rounds_equal_error_VALID[6] <- c(1.96*ronda6$sd[4]/10)
rounds_unequal_VALID[6] <- c(ronda6$mean[3])
rounds_unequal_error_VALID[6] <- c(1.96*ronda6$sd[3]/10)

### round 7

ronda7 <- aggregate(data_games$ronda7, 
                    by = list(equal = data_games$homogenea, valid=data_games$valid_users),
                    FUN = function(x) c(mean = mean(x), sd = sd(x),n = length(x)))

ronda7 <- do.call(data.frame, ronda7)
ronda7$se <- ronda7$x.sd / sqrt(ronda7$x.n)
colnames(ronda7) <- c("equal", "valid", "mean", "sd", "n", "se")

rounds_equal_VALID[7] <- c(ronda7$mean[4])
rounds_equal_error_VALID[7] <- c(1.96*ronda7$sd[4]/10)
rounds_unequal_VALID[7] <- c(ronda7$mean[3])
rounds_unequal_error_VALID[7] <- c(1.96*ronda7$sd[3]/10)

### round 8

ronda8 <- aggregate(data_games$ronda8, 
                    by = list(equal = data_games$homogenea, valid=data_games$valid_users),
                    FUN = function(x) c(mean = mean(x), sd = sd(x),n = length(x)))

ronda8 <- do.call(data.frame, ronda8)
ronda8$se <- ronda8$x.sd / sqrt(ronda8$x.n)
colnames(ronda8) <- c("equal", "valid", "mean", "sd", "n", "se")

rounds_equal_VALID[8] <- c(ronda8$mean[4])
rounds_equal_error_VALID[8] <- c(1.96*ronda8$sd[4]/10)
rounds_unequal_VALID[8] <- c(ronda8$mean[3])
rounds_unequal_error_VALID[8] <- c(1.96*ronda8$sd[3]/10)

### round 9

ronda9 <- aggregate(data_games$ronda9, 
                    by = list(equal = data_games$homogenea, valid=data_games$valid_users),
                    FUN = function(x) c(mean = mean(x), sd = sd(x),n = length(x)))

ronda9 <- do.call(data.frame, ronda9)
ronda9$se <- ronda9$x.sd / sqrt(ronda9$x.n)
colnames(ronda9) <- c("equal", "valid", "mean", "sd", "n", "se")

rounds_equal_VALID[9] <- c(ronda9$mean[4])
rounds_equal_error_VALID[9] <- c(1.96*ronda9$sd[4]/10)
rounds_unequal_VALID[9] <- c(ronda9$mean[3])
rounds_unequal_error_VALID[9] <- c(1.96*ronda9$sd[3]/10)

### round 10

ronda10 <- aggregate(data_games$ronda10, 
                    by = list(equal = data_games$homogenea, valid=data_games$valid_users),
                    FUN = function(x) c(mean = mean(x), sd = sd(x),n = length(x)))

ronda10 <- do.call(data.frame, ronda10)
ronda10$se <- ronda10$x.sd / sqrt(ronda10$x.n)
colnames(ronda10) <- c("equal", "valid", "mean", "sd", "n", "se")

rounds_equal_VALID[10] <- c(ronda10$mean[4])
rounds_equal_error_VALID[10] <- c(1.96*ronda10$sd[4]/10)
rounds_unequal_VALID[10] <- c(ronda10$mean[3])
rounds_unequal_error_VALID[10] <- c(1.96*ronda10$sd[3]/10)

DATA_EQUAL <- data_games[ which(data_games$homogenea==1 & data_games$valid_users==6), ]
DATA_EQUAL <- DATA_EQUAL[,c('ronda1', 'ronda2','ronda3','ronda4', 'ronda5','ronda6','ronda7', 'ronda8','ronda9','ronda10')]

pdf("img/evolution_homogeneous_games.pdf")

plot(rounds_equal_VALID, ylab = "Common Fund (per group of six)", xlab = "Rounds", col=color2, main = "",  type="l", xaxt="n", yaxt="n", ylim=c(0,160), lwd=5)
axis(1, at=c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
axis(2, at=c(0, 20, 40, 60, 80, 100, 120, 140, 160))

# Errors
#lines(rounds_equal_VALID+rounds_equal_error_VALID, ylab = "", main = "",  type="l", lwd=1)
#lines(rounds_equal_VALID-rounds_equal_error_VALID, ylab = "", main = "",  type="l", lwd=1)

lines(c(12,24,36,48,60,72,84,96,108,120), type="l", lwd=1)

for(i in 1:nrow(DATA_EQUAL)) {
  row <- DATA_EQUAL[i,]
  a <- as.numeric(row[1,])
  lines(a, ylab = "", main = "",  type="l", lwd=.25, col=color4)
}

dev.off()
print(nrow(DATA_EQUAL))


DATA_UNEQUAL <- data_games[ which(data_games$homogenea==0 & data_games$valid_users==6), ]
DATA_UNEQUAL <- DATA_UNEQUAL[,c('ronda1', 'ronda2','ronda3','ronda4', 'ronda5','ronda6','ronda7', 'ronda8','ronda9','ronda10')]

pdf("img/evolution_heterogeneous_games.pdf")

plot(rounds_unequal_VALID, ylab = "Common Fund (per group of six)", xlab = "Rounds", main = "", col=color1,  type="l", xaxt="n", yaxt="n", ylim=c(0,160), lwd=5)
axis(1, at=c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
axis(2, at=c(0, 20, 40, 60, 80, 100, 120, 140, 160))

# Errors
#lines(rounds_unequal_VALID+rounds_unequal_error_VALID, ylab = "", main = "",  type="l", lwd=1)
#lines(rounds_unequal_VALID-rounds_unequal_error_VALID, ylab = "", main = "",  type="l", lwd=1)
lines(c(12,24,36,48,60,72,84,96,108,120), type="l", lwd=1)

for(i in 1:nrow(DATA_UNEQUAL)) {
  row <- DATA_UNEQUAL[i,]
  a <- as.numeric(row[1,])
  lines(a, ylab = "", main = "",  type="l", lwd=.25, col=color3)
}
dev.off()

print(nrow(DATA_UNEQUAL))



