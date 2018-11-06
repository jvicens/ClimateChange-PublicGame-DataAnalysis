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
### contribution per round
users$contribution <- users$contribution/10

### w/ 120
data_csv = read.csv("../data/contributions.csv", row.names = 1)  # read csv file
data_equal <- data_csv[data_csv[,1] == 0,]
data <- data_equal[,c("X0","X24","X48","X72","X96","X.120")]

### transpose data
datat = t(data)

### consensus clustering
title="log/equal"
maxK = 9 # maximum number of clusters
reps = 1000 # number of clusters calculate
seed = 123456789.01234 # seed calculcations
results = ConsensusClusterPlus(datat, maxK=maxK, reps=reps, pItem=0.8, pFeature=1, title=title, clusterAlg="hc", distance="euclidean", innerLinkage="ward.D2", finalLinkage="ward.D2", seed=seed, plot="pdf")

### Item-Consensus (ICL)
icl = calcICL(results,title=title,plot="pdf")

### Cluster k = 2
write.csv(results[[2]][["consensusClass"]], file = "log/equal/clusters_consensus_k2.csv",row.names=TRUE)

# List clusters k = 2
id = row.names(data.frame(results[[2]][["consensusClass"]]))
cluster = results[[2]][["consensusClass"]]
list_clusters_k2 = data.frame(cbind(id, cluster))

# Cluster consensus k = 2
scaleblue <- colorRampPalette(c("darkblue", "white"), space = "Lab")(3)

cc <- icl[["clusterConsensus"]]

ratios = cc[1:2,3]
clusters = cc[1:2,2]
k = cc[1:2,1]

names(ratios) <- paste("Cluster ", clusters, sep="")

pdf("img/equal/cluster_consensus_2.pdf")
barplot(ratios, col=color_cluster, ylim=c(0,1), ylab="Cluster Consensus Ratio")
dev.off()

# Item Consensus
scaleblue <- colorRampPalette(c("darkblue", "white"), space = "Lab")(3)

ic <- icl[["itemConsensus"]]

### para k = 2

ic_ratio=c()

for(i in 1:nrow(list_clusters_k2)) {
  row <- list_clusters_k2[i,]
  ic_ratio[i] = ic$itemConsensus[ic$k== 2 & ic$cluster==row$cluster & ic$item==row$id]
}
list_clusters_k2['ic_ratio'] = ic_ratio

pdf("img/equal/item_consensus_k2.pdf")
hist(list_clusters_k2$ic_ratio, xlim = c(0,1), main ="", xlab = "Item Consensus Ratio", ylab = "Counts", col = color_cluster, breaks=c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1))
dev.off()

write.csv(list_clusters_k2, file = "log/equal/clusters_consensus_k2.csv",row.names=TRUE)

################################
###### Average per group ###### 
################################

#######################
####### k = 2 #########
#######################
k = 2

means_dataframe <- as.data.frame(matrix(nrow=0,ncol=11))
total_users_in_group <- as.data.frame(matrix(nrow=11,ncol=1))

colnames(means_dataframe) <- c("0-24","25-48","49-72","73-96","97-120",">120")

for (i in 1:k) {
  
  users_in_group <<- which(results[[2]][["consensusClass"]]==i)
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
rownames(means_dataframe) <- c("Cluster 1", "Cluster 2")

nba_matrix <- data.matrix(means_dataframe)

myPanel <- function(x, y, z, ...) {
  panel.levelplot(x,y,z,...)
  panel.text(x, y, round(z,2))
}


######## Plots for the paper ########

pdf("img/equal/means_per_cluster_consensus_k2.pdf")
scaleblue <- colorRampPalette(c("white", "darkblue"), space = "Lab")(100)

levelplot(t(nba_matrix), col.regions= scaleblue, panel= myPanel, xlab="Accumulated contribution in the common fund", ylab="", at=seq(0, 1, length.out=21))

dev.off()

#################################
###### Cluster composition ###### 
#################################

k = 2

#### Tyology of users ####

users_characteristics_matrix <- as.data.frame(matrix(nrow=k,ncol=5))
colnames(users_characteristics_matrix) <- c("20","30","40","50","60")

clusters_hierarchital <- as.matrix(results[[2]][["consensusClass"]])
for (i in 1:k){
  cluster_components <- rownames(as.matrix(clusters_hierarchital[as.matrix(which(clusters_hierarchital==i, arr.ind = FALSE, useNames = TRUE)),1]))
  
  count_slc = table(users[cluster_components,2])
  users_characteristics_matrix[i,] <- c(count_slc['20'], count_slc['30'], count_slc['40'], count_slc['50'], count_slc['60'])
}

#### Plots ####

total = sum(users_characteristics_matrix, na.rm = TRUE)
distribution_per_cluster = c(sum(users_characteristics_matrix[1,]/sum(users_characteristics_matrix, na.rm = TRUE), na.rm = TRUE), + 
                                 sum(users_characteristics_matrix[2,]/sum(users_characteristics_matrix, na.rm = TRUE), na.rm = TRUE))
names(distribution_per_cluster) <- c("Cluster 1", "Cluster 2")


pdf("img/equal/distribution_per_cluster_consensus_k2.pdf")
barplot(distribution_per_cluster, col=color_cluster, xlab="", ylab="Ratio of subjects per cluster", ylim=c(0,0.6))
dev.off()

for (i in 1:k){
  cat("Cluster:", i, " ")
  cat("Number: ", sum(users_characteristics_matrix[i,], na.rm = TRUE), " ")
  cat("Perc: ", (sum(users_characteristics_matrix[i,], na.rm = TRUE)/sum(users_characteristics_matrix[,], na.rm = TRUE))*100, "\n")
}

describe(list_clusters_k2['ic_ratio'])

describe(cc[,3][cc[,1]==2])

##################
### Distributions
##################

ylim = c(0,1)
BLUES = colorRampPalette(brewer.pal(9,"Blues"))(10)
scaleblue <- colorRampPalette(c("darkblue", "white"), space = "Lab")(k)

## Clusters
clusters = list_clusters_k2
k <- 2

# Users
users_40 <- users[which(users[,2]==40 & users[,1]==0, arr.ind = FALSE, useNames = TRUE),]

# Users id in cluster 1
uid_cluster_1 <- row.names(clusters)[which(clusters$cluster==1, arr.ind = FALSE, useNames = TRUE)]
users_cluster_1 <- users[uid_cluster_1,]

users_cluster_1_40 <- users_cluster_1[which(users_cluster_1[,2]==40, arr.ind = FALSE, useNames = TRUE),]
res_1_40 <- hist(users_cluster_1_40[,5], xlim=c(-0.5,4.5), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
c1_40 <- res_1_40$counts/length(users_40[,1])

# Users id in cluster 2
uid_cluster_2 <- row.names(clusters)[which(clusters$cluster==2, arr.ind = FALSE, useNames = TRUE)]
users_cluster_2 <- users[uid_cluster_2,]

users_cluster_2_40 <- users_cluster_2[which(users_cluster_2[,2]==40, arr.ind = FALSE, useNames = TRUE),]
if (nrow(users_cluster_2_40) > 0){
  res_2_40 <- hist(users_cluster_2_40[,5], xlim=c(-0.5,4), breaks=c(0, 0.9, 1.9, 2.9, 3.9, 4.9))
  c2_40 <- res_2_40$counts/length(users_40[,1])
}else{
  c2_40 <- 0
}

### 40

options_40 <- as.data.frame(matrix(nrow=k,ncol=5))
colnames(options_40) <- c("0","1","2","3","4")

rownames(options_40) <- c("Cluster 1","Cluster 2")
options_40[1,] = c1_40
options_40[2,] = c2_40



pdf("img/equal/pdf_cluster_k2.pdf")
barplot(as.matrix(options_40), col=scaleblue, ylim=ylim, xlab="Mean Contribution", ylab="")
legend("topright", legend =  rownames(options_40), fill = scaleblue, bty = "n")
dev.off()


cat("Cluster 1 - 40 euros: ", nrow(users_cluster_1_40))
cat("Cluster 2 - 40 euros: ", nrow(users_cluster_2_40))

#################################################
# Proporcion en cada cluster segun el endowment #
#################################################

clusters_1 = nrow(users_cluster_1_40)/(nrow(users_cluster_1_40) + nrow(users_cluster_2_40))
clusters_2 = nrow(users_cluster_2_40)/(nrow(users_cluster_1_40) + nrow(users_cluster_2_40))

clusters_12 <- rbind(clusters_1, clusters_2)
colnames(clusters_12) <- c("40")
rownames(clusters_12) <- c("Cluster 1","Cluster 2")

pdf("img/equal/distribution_endowments_clusters_k2.pdf")
par(mar=c(4.5, 2, 1.5, 5.5), xpd=TRUE)
barplot(clusters_12, col=scaleblue, ylim=ylim, xlab="Endowments", ylab="")
legend("topright", inset=c(-0.2,0), legend =rownames(clusters_12), fill = scaleblue, bty = "n")
dev.off()




