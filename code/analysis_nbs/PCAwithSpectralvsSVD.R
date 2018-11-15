# Found on: https://stats.idre.ucla.edu/r/codefragments/svd_demos/

require(foreign)
require(tidyverse)
require(psych)

auto <- read.dta("http://statistics.ats.ucla.edu/stat/data/auto.dta")

pca.m1 <- prcomp(~trunk + weight + length + headroom, data = auto,
                 scale = TRUE)

# screeplot(pca.m1)
pca.m1

# spectral decomposition: eigen values and eigen vectors
xvars <- with(auto, cbind(trunk, weight, length, headroom))
corr <- cor(xvars)
a <- eigen(corr)
(std <- sqrt(a$values)) #sqrt of eigenvalues = variances of PCs
(rotation <- a$vectors) #factor loadings


# svd approach
df <- nrow(xvars) - 1
zvars <- scale(xvars)
z.svd <- svd(zvars)
z.svd$d/sqrt(df) # variances of PCs
z.svd$v # factor loadings

pca.m2 <- princomp(~trunk + weight + length + headroom, data = auto %>% mutate_if(is.numeric, scale)) #very similar to pca.m1
pca.m3 <- principal(auto %>% select(trunk,weight,length,headroom)%>% mutate_if(is.numeric, scale), 4, rotate = "none")

#How to get princomp/prcomp/svd like factor loadings from psych::principal
#Converting them to have unit length [NOTE THIS DOESN'T GET SIGNS]
data.frame(pca.m3$loadings[]^2) %>%
  mutate(PC1 = sqrt(PC1/colSums(pca.m3$loadings[]^2)[1]),
         PC2 = sqrt(PC2/colSums(pca.m3$loadings[]^2)[2]),
         PC3 = sqrt(PC3/colSums(pca.m3$loadings[]^2)[3]),
         PC4 = sqrt(PC4/colSums(pca.m3$loadings[]^2)[4]))

#How to get psych::principal like scores from prcomp
ncomp = 4
pca.m1$rotation[,1:ncomp] %*% diag(pca.m1$sdev, ncomp, ncomp)

#How to get psych::principal like scores from prcomp
ncomp = 4
pca.m1$rotation[,1:ncomp] %*% diag(pca.m1$sdev, ncomp, ncomp)

irisX <- iris[,1:4]      # Iris data
ncomp <- 2

pca_iris_rotated <- psych::principal(irisX, rotate="varimax", nfactors=ncomp, scores=TRUE)
pca_iris_rotated$scores[1:5,]  # Scores returned by principal()

pca_iris        <- prcomp(irisX, center=T, scale=T)
rawLoadings     <- pca_iris$rotation[,1:ncomp] %*% diag(pca_iris$sdev, ncomp, ncomp)
rotatedLoadings <- varimax(rawLoadings)$loadings
invLoadings     <- t(pracma::pinv(rotatedLoadings))
scores          <- scale(irisX) %*% invLoadings
print(scores[1:5,])                   # Scores computed via rotated loadings

scores <- scale(pca_iris$x[,1:2]) %*% varimax(rawLoadings)$rotmat
print(scores[1:5,])                   # Scores computed via rotating the scores

#rotate using GPARotation