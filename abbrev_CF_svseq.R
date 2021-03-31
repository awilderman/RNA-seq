R
library(sva)
library(DESeq2)

# # Use DESeq2 to create a matrix, normalize and transform the counts


countsfile <- ("/home/CAM/awilderman/ANALYSIS/RNA-seq/2017-10-24_human_cf/combined_data/tophat_pipeline/R_data/reordered_CF_RNAseq_hg19_GCv10.txt")
countdata <- read.table(countsfile, header=TRUE, row.names=1)

# convert to matrix
countdata <- as.matrix(countdata)
head(countdata)

# assign condition (if putting these in this order, the columns in the counts data have to be in this order, too.)
condition <- factor(c(rep("CS13", 3), rep("CS15", 3), rep("CS14", 3), rep("CS17", 3)))

(coldata <- data.frame(row.names=colnames(countdata), condition))

# create the object
ddsMat <- DESeqDataSetFromMatrix(countData = countdata,
                                  colData = coldata,
                                  design = ~ condition)
                                  

ddsMat <- estimateSizeFactors(ddsMat)

# # Estimate surrogate variables

# the normalized data for sva (DESeq2's normalization)
# and take normalized counts for which the average across samples is >1
# the known variable is condition (carnegie stage)
dat <- counts(ddsMat, normalized = TRUE)
idx <- rowMeans(dat) > 1
dat <- dat[idx,]
mod <- model.matrix (~ condition, colData(ddsMat))
mod0 <- model.matrix (~ 1, colData(ddsMat))
n.sv = num.sv(dat,mod,method="leek")
svseq <- svaseq(dat, mod, mod0)



ddssva <- ddsMat
ddssva$SV1 <- svseq$sv[,1]
ddssva$SV2 <- svseq$sv[,2]
ddssva$SV3 <- svseq$sv[,3]
design(ddssva) <- ~ SV1 + SV2 + SV3 + condition

ddssva <- DESeq(ddssva)
ressva <- results(ddssva)
ddssva
ressva 

ddsMat <- DESeq(ddsMat)
res <- results(ddsMat)
ddsMat
res 
