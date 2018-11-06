# https://www.bioconductor.org/packages/devel/bioc/vignettes/ConsensusClusterPlus/inst/doc/ConsensusClusterPlus.pdf

library(lattice)
library(psych)
library(ConsensusClusterPlus)
library(RColorBrewer) 

# colors payoffs
color_cluster = '#00008BDD'

################################
### Data users and contributions
################################

### users
users = read.csv("../data/users.csv", row.names = 1)

### w/ 120
data_csv = read.csv("../data/contributions.csv", row.names = 1)  # read csv file
data_unequal <- data_csv[data_csv[,1] == 1,]
data <- data_unequal[,c("X0","X24","X48","X72","X96","X.120")]

### transpose data
datat = t(data)

### consensus clustering
title="log/unequal"
maxK = 9 # maximum number of clusters
reps = 1000 # number of clusters calculate
seed = 123456789.01234 # seed calculcations
results = ConsensusClusterPlus(datat, maxK=maxK, reps=reps, pItem=0.8, pFeature=1, title=title, clusterAlg="hc", distance="euclidean", innerLinkage="ward.D2", finalLinkage="ward.D2", seed=seed, plot="pdf")

### Item-Consensus (ICL)
icl = calcICL(results,title=title,plot="pdf")

### Cluster k = 3
write.csv(results[[3]][["consensusClass"]], file = "log/unequal/clusters_consensus_k3.csv",row.names=TRUE)

### List clusters k = 3
id = row.names(data.frame(results[[3]][["consensusClass"]]))
cluster = results[[3]][["consensusClass"]]
list_clusters_k3 = data.frame(cbind(id, cluster))

### Cluster consensus k = 3
scaleblue <- colorRampPalette(c("darkblue", "white"), space = "Lab")(3)

cc <- icl[["clusterConsensus"]]

ratios = cc[3:5,3]
clusters = cc[3:5,2]
k = cc[3:5,1]

names(ratios) <- paste("Cluster ", clusters, sep="")

pdf("img/unequal/cluster_consensus_3.pdf")
barplot(ratios, col=color_cluster, ylim=c(0,1), ylab="Cluster Consensus Ratio")
dev.off()


# Item Consensus
scaleblue <- colorRampPalette(c("darkblue", "white"), space = "Lab")(3)
ic <- icl[["itemConsensus"]]

### k = 3
ic_ratio=c()

for(i in 1:nrow(list_clusters_k3)) {
  row <- list_clusters_k3[i,]
  ic_ratio[i] = ic$itemConsensus[ic$k== 3 & ic$cluster==row$cluster & ic$item==row$id]
}
list_clusters_k3['ic_ratio'] = ic_ratio

pdf("img/unequal/item_consensus_k3.pdf")
hist(list_clusters_k3$ic_ratio, xlim = c(0,1), main ="", xlab = "Item Consensus Ratio", ylab = "Counts", col = color_cluster, breaks=c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1))
dev.off()

list_clusters = cbind(id, cluster)
write.csv(list_clusters_k3, file = "log/unequal/clusters_consensus_k3.csv",row.names=TRUE)

################################
###### Average per group ###### 
################################

#######################
####### k = 3 #########
#######################
k = 3

means_dataframe <- as.data.frame(matrix(nrow=0,ncol=11))
total_users_in_group <- as.data.frame(matrix(nrow=11,ncol=1))

colnames(means_dataframe) <- c("0-24","25-48","49-72","73-96","97-120",">120")

for (i in 1:k) {
  
  users_in_group <<- which(results[[3]][["consensusClass"]]==i)
  selections_users_in_group <- data[users_in_group,]
  total_users_in_group[i,] <- length(users_in_group)
  
  mean_vector <- c(mean(na.omit(selections_users_in_group$X0)), 
                  mean(na.omit(selections_users_in_group$X24)),
                  mean(na.omit(selections_users_in_group$X48)),
                  mean(na.omit(selections_users_in_group$X72)), 
                  mean(na.omit(selections_users_in_group$X96)), 
                  mean(na.omit(selections_users_in_group$X.120)))

  
  means_dataframe <- rbind(means_dataframe, mean_vector)
  print(mean_vector)
}

colnames(means_dataframe) <- c("0-24","25-48","49-72","73-96","97-120",">120")
rownames(means_dataframe) <- c("Cluster 1", "Cluster 2", "Cluster 3")

nba_matrix <- data.matrix(means_dataframe)

myPanel <- function(x, y, z, ...) {
  panel.levelplot(x,y,z,...)
  panel.text(x, y, round(z,2))
}


######## Plots for the paper ########

pdf("img/unequal/means_per_cluster_consensus_k3_rotate.pdf")
scaleblue1 <- colorRampPalette(c("white", "darkblue"), space = "Lab")(100)
scaleblue2 <- colorRampPalette(c("darkblue", "black"), space = "Lab")(100)
scaleblue <- c(scaleblue1, scaleblue2)

levelplot(t(nba_matrix), col.regions= scaleblue, panel= myPanel, xlab="Accumulated contribution in the common fund", ylab="", at=seq(0, 2, length.out=41))

dev.off()

#################################
###### Cluster composition ###### 
#################################

k = 3

#### Tyology of users ####

users_characteristics_matrix <- as.data.frame(matrix(nrow=k,ncol=5))
colnames(users_characteristics_matrix) <- c("20","30","40","50","60")

clusters_hierarchital <- as.matrix(results[[3]][["consensusClass"]])
for (i in 1:k){
  cluster_components <- rownames(as.matrix(clusters_hierarchital[as.matrix(which(clusters_hierarchital==i, arr.ind = FALSE, useNames = TRUE)),1]))
  count_slc = table(users[cluster_components,2])
  users_characteristics_matrix[i,] <- c(count_slc['20'], count_slc['30'], count_slc['40'], count_slc['50'], count_slc['60'])
}

#### Plots ####

total = sum(users_characteristics_matrix, na.rm = TRUE)
distribution_per_cluster = c(sum(users_characteristics_matrix[1,]/sum(users_characteristics_matrix, na.rm = TRUE), na.rm = TRUE), +
                               sum(users_characteristics_matrix[2,]/sum(users_characteristics_matrix, na.rm = TRUE), na.rm = TRUE), +
                               sum(users_characteristics_matrix[3,]/sum(users_characteristics_matrix, na.rm = TRUE), na.rm = TRUE))
names(distribution_per_cluster) <- c("Cluster 1", "Cluster 2", "Cluster 3")


pdf("img/unequal/distribution_per_cluster_consensus_k3.pdf")
barplot(distribution_per_cluster, col=color_cluster, xlab="", ylab="Ratio of subjects per cluster", ylim=c(0,0.6))
dev.off()

for (i in 1:k){
  cat("Cluster:", i, " ")
  cat("Number: ", sum(users_characteristics_matrix[i,], na.rm = TRUE), " ")
  cat("Perc: ", (sum(users_characteristics_matrix[i,], na.rm = TRUE)/sum(users_characteristics_matrix[,], na.rm = TRUE))*100, "\n")
}

describe(list_clusters_k3['ic_ratio'])

describe(cc[,3][cc[,1]==3])




#################
### Distribution
#################

ylim = c(0,1)
BLUES = colorRampPalette(brewer.pal(9,"Blues"))(10)
scaleblue <- colorRampPalette(c("darkblue", "white"), space = "Lab")(k)

## Clusters
k <- 3
clusters = list_clusters_k3


### users
users = read.csv("../data/users.csv", row.names = 1)

### normalization Users Contributions
users[users[,2] == 20,]$contribution_norm <- users[users[,2] == 20,]$contribution_norm*(20/10)
users[users[,2] == 30,]$contribution_norm <- users[users[,2] == 30,]$contribution_norm*(30/10)
users[users[,2] == 40,]$contribution_norm <- users[users[,2] == 40,]$contribution_norm*(40/10)
users[users[,2] == 50,]$contribution_norm <- users[users[,2] == 50,]$contribution_norm*(50/10)
users[users[,2] == 60,]$contribution_norm <- users[users[,2] == 60,]$contribution_norm*(60/10)

# Users
users_20 <- users[which(users[,2]==20, arr.ind = FALSE, useNames = TRUE),]
users_30 <- users[which(users[,2]==30, arr.ind = FALSE, useNames = TRUE),]
users_40 <- users[which(users[,2]==40 & users[,1]==1, arr.ind = FALSE, useNames = TRUE),]
users_50 <- users[which(users[,2]==50, arr.ind = FALSE, useNames = TRUE),]
users_60 <- users[which(users[,2]==60, arr.ind = FALSE, useNames = TRUE),]



# Users id in cluster 1
uid_cluster_1 <- row.names(clusters)[which(clusters$cluster==1, arr.ind = FALSE, useNames = TRUE)]
users_cluster_1 <- users[uid_cluster_1,]

users_cluster_1_20 <- users_cluster_1[which(users_cluster_1[,2]==20, arr.ind = FALSE, useNames = TRUE),]
res_1_20 <- hist(users_cluster_1_20[,6], xlim=c(0,4), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
c1_20 <- res_1_20$counts/length(users_20[,1])

users_cluster_1_30 <- users_cluster_1[which(users_cluster_1[,2]==30, arr.ind = FALSE, useNames = TRUE),]
res_1_30 <- hist(users_cluster_1_30[,6], xlim=c(-0.5,4.5), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
c1_30 <- res_1_30$counts/length(users_30[,1])

users_cluster_1_50 <- users_cluster_1[which(users_cluster_1[,2]==50, arr.ind = FALSE, useNames = TRUE),]
res_1_50 <- hist(users_cluster_1_50[,6], xlim=c(-0.5,4.5), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
c1_50 <- res_1_50$counts/length(users_50[,1])

users_cluster_1_60 <- users_cluster_1[which(users_cluster_1[,2]==60, arr.ind = FALSE, useNames = TRUE),]
if (nrow(users_cluster_1_60) > 0){
  res_1_60 <- hist(users_cluster_1_60[,6], xlim=c(-0.5,4.5), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
  c1_60 <- res_1_60$counts/length(users_60[,1])
}else{
  c1_60 <- 0
}

users_cluster_1_40 <- users_cluster_1[which(users_cluster_1[,2]==40, arr.ind = FALSE, useNames = TRUE),]
res_1_40 <- hist(users_cluster_1_40[,6], xlim=c(-0.5,4.5), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
c1_40 <- res_1_40$counts/length(users_40[,1])


# Users id in cluster 2
uid_cluster_2 <- row.names(clusters)[which(clusters$cluster==2, arr.ind = FALSE, useNames = TRUE)]
users_cluster_2 <- users[uid_cluster_2,]

users_cluster_2_20 <- users_cluster_2[which(users_cluster_2[,2]==20, arr.ind = FALSE, useNames = TRUE),]
if (nrow(users_cluster_2_20) > 0){
  res_2_20 <- hist(users_cluster_2_20[,6], xlim=c(-0.5,4), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
  c2_20 <- res_2_20$counts/length(users_20[,1])
}else{
  c2_20 <- 0
}

users_cluster_2_30 <- users_cluster_2[which(users_cluster_2[,2]==30, arr.ind = FALSE, useNames = TRUE),]
if (nrow(users_cluster_2_30) > 0){
  res_2_30 <- hist(users_cluster_2_30[,6], xlim=c(-0.5,4), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
  c2_30 <- res_2_30$counts/length(users_30[,1])
}else{
  c2_30 <- 0
}

users_cluster_2_50 <- users_cluster_2[which(users_cluster_2[,2]==50, arr.ind = FALSE, useNames = TRUE),]
if (nrow(users_cluster_2_50) > 0){
  res_2_50 <- hist(users_cluster_2_50[,6], xlim=c(-0.5,4), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
  c2_50 <- res_2_50$counts/length(users_50[,1])
}else{
  c2_50 <- 0
}

users_cluster_2_60 <- users_cluster_2[which(users_cluster_2[,2]==60, arr.ind = FALSE, useNames = TRUE),]
if (nrow(users_cluster_2_60) > 0){
  res_2_60 <- hist(users_cluster_2_60[,6], xlim=c(-0.5,4), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
  c2_60 <- res_2_60$counts/length(users_60[,1])
}else{
  c2_60 <- 0
}



users_cluster_2_40 <- users_cluster_2[which(users_cluster_2[,2]==40, arr.ind = FALSE, useNames = TRUE),]
if (nrow(users_cluster_2_40) > 0){
  res_2_40 <- hist(users_cluster_2_40[,6], xlim=c(-0.5,4), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
  c2_40 <- res_2_40$counts/length(users_40[,1])
}else{
  c2_40 <- 0
}


# Users id in cluster 3
uid_cluster_3 <- row.names(clusters)[which(clusters$cluster==3, arr.ind = FALSE, useNames = TRUE)]
users_cluster_3 <- users[uid_cluster_3,]

users_cluster_3_20 <- users_cluster_3[which(users_cluster_3[,2]==20, arr.ind = FALSE, useNames = TRUE),]
if (nrow(users_cluster_3_20) > 0){
  res_3_20 <- hist(users_cluster_3_20[,6], xlim=c(-0.5,4), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
  c3_20 <- res_3_20$counts/length(users_20[,1])
}else{
  c3_20 <- 0
} 

users_cluster_3_30 <- users_cluster_3[which(users_cluster_3[,2]==30, arr.ind = FALSE, useNames = TRUE),]
if (nrow(users_cluster_3_30) > 0){
  res_3_30 <- hist(users_cluster_3_30[,6], xlim=c(-0.5,4), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
  c3_30 <- res_3_30$counts/length(users_30[,1])
}else{
  c3_30 <- 0
}

users_cluster_3_50 <- users_cluster_3[which(users_cluster_3[,2]==50, arr.ind = FALSE, useNames = TRUE),]
if (nrow(users_cluster_3_50) > 0){
  res_3_50 <- hist(users_cluster_3_50[,6], xlim=c(-0.5,4), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
  c3_50 <- res_3_50$counts/length(users_50[,1])
}else{
  c3_50 <- 0
}

users_cluster_3_60 <- users_cluster_3[which(users_cluster_3[,2]==60, arr.ind = FALSE, useNames = TRUE),]
if (nrow(users_cluster_3_60) > 0){
  res_3_60 <- hist(users_cluster_3_60[,6], xlim=c(-0.5,4), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
  c3_60 <- res_3_60$counts/length(users_60[,1])
}else{
  c3_60 <- 0
}


users_cluster_3_40 <- users_cluster_3[which(users_cluster_3[,2]==40, arr.ind = FALSE, useNames = TRUE),]
if (nrow(users_cluster_3_40) > 0){
  res_3_40 <- hist(users_cluster_3_40[,6], xlim=c(-0.5,4), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
  c3_40 <- res_3_40$counts/length(users_40[,1])
}else{
  c3_40 <- 0
}

### 20

options_20 <- as.data.frame(matrix(nrow=k,ncol=5))
colnames(options_20) <- c("0","1","2","3","4")

rownames(options_20) <- c("Cluster 1","Cluster 2", "Cluster 3")
options_20[1,] = c1_20
options_20[2,] = c2_20
options_20[3,] = c3_20


pdf("img/unequal/pdf_cluster_options_20.pdf")
barplot(as.matrix(options_20), col=scaleblue, ylim=ylim, xlab="Mean Contribution", ylab="")
legend("topright", legend =  rownames(options_20), fill = scaleblue, bty = "n")
dev.off()

### 30

options_30 <- as.data.frame(matrix(nrow=k,ncol=5))
colnames(options_30) <- c("0","1","2","3","4")

rownames(options_30) <- c("Cluster 1","Cluster 2", "Cluster 3")
options_30[1,] = c1_30
options_30[2,] = c2_30
options_30[3,] = c3_30



pdf("img/unequal/pdf_cluster_options_30.pdf")
barplot(as.matrix(options_30), col=scaleblue, ylim=ylim, xlab="Mean Contribution", ylab="")
legend("topright", legend =  rownames(options_30), fill = scaleblue, bty = "n")
dev.off()

### 40

options_40 <- as.data.frame(matrix(nrow=k,ncol=5))
colnames(options_40) <- c("0","1","2","3","4")

rownames(options_40) <- c("Cluster 1","Cluster 2", "Cluster 3")
options_40[1,] = c1_40
options_40[2,] = c2_40
options_40[3,] = c3_40


pdf("img/unequal/pdf_cluster_options_40.pdf")
barplot(as.matrix(options_40), col=scaleblue, ylim=ylim, xlab="Mean Contribution", ylab="")
legend("topright", legend =  rownames(options_40), fill = scaleblue, bty = "n")
dev.off()

### 50

options_50 <- as.data.frame(matrix(nrow=k,ncol=5))
colnames(options_50) <- c("0","1","2","3","4")

rownames(options_50) <- c("Cluster 1","Cluster 2", "Cluster 3")
options_50[1,] = c1_50
options_50[2,] = c2_50
options_50[3,] = c3_50



pdf("img/unequal/pdf_cluster_options_50.pdf")
barplot(as.matrix(options_50), col=scaleblue, ylim=ylim, xlab="Mean Contribution", ylab="")
legend("topright", legend =  rownames(options_50), fill = scaleblue, bty = "n")
dev.off()

### 60

options_60 <- as.data.frame(matrix(nrow=k,ncol=5))
colnames(options_60) <- c("0","1","2","3","4")

rownames(options_60) <- c("Cluster 1","Cluster 2", "Cluster 3")
options_60[1,] = c1_60
options_60[2,] = c2_60
options_60[3,] = c3_60



pdf("img/unequal/pdf_cluster_options_60.pdf")
barplot(as.matrix(options_60), col=scaleblue, ylim=ylim, xlab="Mean Contribution", ylab="")
legend("topright", legend = rownames(options_60), fill = scaleblue, bty = "n")
dev.off()

## Users clusters
cat("Cluster 1 - 20 euros: ", nrow(users_cluster_1_20))
cat("Cluster 2 - 20 euros: ", nrow(users_cluster_2_20))
cat("Cluster 3 - 20 euros: ", nrow(users_cluster_3_20))

cat("Cluster 1 - 30 euros: ", nrow(users_cluster_1_30))
cat("Cluster 2 - 30 euros: ", nrow(users_cluster_2_30))
cat("Cluster 3 - 30 euros: ", nrow(users_cluster_3_30))

cat("Cluster 1 - 40 euros: ", nrow(users_cluster_1_40))
cat("Cluster 2 - 40 euros: ", nrow(users_cluster_2_40))
cat("Cluster 3 - 40 euros: ", nrow(users_cluster_3_40))

cat("Cluster 1 - 50 euros: ", nrow(users_cluster_1_50))
cat("Cluster 2 - 50 euros: ", nrow(users_cluster_2_50))
cat("Cluster 3 - 50 euros: ", nrow(users_cluster_3_50))

cat("Cluster 1 - 60 euros: ", nrow(users_cluster_1_60))
cat("Cluster 2 - 60 euros: ", nrow(users_cluster_2_60))
cat("Cluster 3 - 60 euros: ", nrow(users_cluster_3_60))

#################################################
# Proporcion en cada cluster segun el endowment #
#################################################

clusters_1 = c(nrow(users_cluster_1_20)/(nrow(users_cluster_1_20) + nrow(users_cluster_2_20) + nrow(users_cluster_3_20)), nrow(users_cluster_1_30)/(nrow(users_cluster_1_30) + nrow(users_cluster_2_30) + nrow(users_cluster_3_30)), nrow(users_cluster_1_40)/(nrow(users_cluster_1_40) + nrow(users_cluster_2_40) + nrow(users_cluster_3_40)), nrow(users_cluster_1_50)/(nrow(users_cluster_1_50) + nrow(users_cluster_2_50) + nrow(users_cluster_3_50)), nrow(users_cluster_1_60)/(nrow(users_cluster_1_60) + nrow(users_cluster_2_60) + nrow(users_cluster_3_60)))
clusters_2 = c(nrow(users_cluster_2_20)/(nrow(users_cluster_1_20) + nrow(users_cluster_2_20) + nrow(users_cluster_3_20)), nrow(users_cluster_2_30)/(nrow(users_cluster_1_30) + nrow(users_cluster_2_30) + nrow(users_cluster_3_30)), nrow(users_cluster_2_40)/(nrow(users_cluster_1_40) + nrow(users_cluster_2_40) + nrow(users_cluster_3_40)), nrow(users_cluster_2_50)/(nrow(users_cluster_1_50) + nrow(users_cluster_2_50) + nrow(users_cluster_3_50)), nrow(users_cluster_2_60)/(nrow(users_cluster_1_60) + nrow(users_cluster_2_60) + nrow(users_cluster_3_60)))
clusters_3 = c(nrow(users_cluster_3_20)/(nrow(users_cluster_1_20) + nrow(users_cluster_2_20) + nrow(users_cluster_3_20)), nrow(users_cluster_3_30)/(nrow(users_cluster_1_30) + nrow(users_cluster_2_30) + nrow(users_cluster_3_30)), nrow(users_cluster_3_40)/(nrow(users_cluster_1_40) + nrow(users_cluster_2_40) + nrow(users_cluster_3_40)), nrow(users_cluster_3_50)/(nrow(users_cluster_1_50) + nrow(users_cluster_2_50) + nrow(users_cluster_3_50)), nrow(users_cluster_3_60)/(nrow(users_cluster_1_60) + nrow(users_cluster_2_60) + nrow(users_cluster_3_60)))

clusters_123 <- rbind(clusters_1, clusters_2, clusters_3)
colnames(clusters_123) <- c("20","30","40","50","60")
rownames(clusters_123) <- c("Cluster 1","Cluster 2","Cluster 3")

scaleblue <- colorRampPalette(c(BLUES[5], "darkblue", "white"), space = "Lab")(k)

pdf("img/unequal/distribution_endowments.pdf")
# margins: bottom, left, top and right
par(mar=c(4.5, 2, 1.5, 5.5), xpd=TRUE)
barplot(clusters_123, col=scaleblue, ylim=ylim, xlab="Endowments", ylab="")
legend("topright", inset=c(-0.2,0), legend =rownames(clusters_123), fill = scaleblue, bty = "n")
dev.off()
