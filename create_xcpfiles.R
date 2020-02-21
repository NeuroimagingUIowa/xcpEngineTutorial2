library(dplyr)

lut <- read.table("lut.tsv", stringsAsFactors = F)

names(lut) <- lut[1,] 
lut <- lut[-1,]
rownames(lut) <- NULL

lut[,1] <- rownames(lut)

write.table(lut, "lut_updated.tsv", col.names = T, row.names = F, quote = F, sep = "\t")

# network mapping copying from James's script

#NETWORK_MAPPING = {
#  1: "VisCent",
#  2: "VisPeri",
#  3: "SomMotA",
#  4: "SomMotB",
#  5: "DorsAttnA",
#  6: "DorsAttnB",
#  7: "SalVentAttnA",
#  8: "SalVentAttnB",
#  9: "LimbicA",
#  10: "LimbicB",
#  11: "ContC",
#  12: "ContA",
#  13: "ContB",
#  14: "TempPar",
#  15: "DefaultC",
#  16: "DefaultA",
#  17: "DefaultB",
#}

CommunityNames <- as.data.frame(c("VisCent",
                    "VisPeri",
                    "SomMotA",
                    "SomMotB",
                    "DorsAttnA",
                    "DorsAttnB",
                    "SalVentAttnA",
                    "SalVentAttnB",
                    "LimbicA",
                    "LimbicB",
                    "ContC",
                    "ContA",
                    "ContB",
                    "TempPar",
                    "DefaultC",
                    "DefaultA",
                    "DefaultB"), nrow = 17, ncol = 1, stringsAsFactors = F)

write.table(CommunityNames, "mergedCommunityNames.txt", col.names = F, row.names = F, quote = F)

lut$network <- NA
for (i in 1:400) {lut$network[i] <- strsplit(lut[,2], "_")[[i]][2]}
for (i in 401:432) {lut$network[i] <- strsplit(lut[,2], "-")[[i]][2]}

lut$CommunityAffiliation <- NA
for (i in 1:length(lut$index)) {
  for (j in 1:17) {
    if(lut$network[i] == CommunityNames[j,1]){lut$CommunityAffiliation[i] <- j}}}
  
CommunityAffiliation <- as.data.frame(lut$CommunityAffiliation, nrow = 432, ncol = 1, stringsAsFactors = F)
write.table(CommunityAffiliation, "mergedCommunityAffiliation.txt", col.names = F, row.names = F, quote = F)

NodeIndex <- as.data.frame(lut$index, nrow = 432, ncol = 1, stringsAsFactors = F)
write.table(NodeIndex, "mergedNodeIndex.txt", col.names = F, row.names = F, quote = F)

NodeNames <- as.data.frame(lut$regions, nrow = 432, ncol = 1, stringsAsFactors = F)
write.table(NodeNames, "mergedNodeNames.txt", col.names = F, row.names = F, quote = F)
