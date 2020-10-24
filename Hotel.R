# HOTEL project
library(readxl)
library(dplyr)

setwd("C:/Users/edwin/Desktop/Volunteer/Datasets/")

subjects = read_excel("Baseline cSVD Demo.xlsx", sheet = "demo")
binary = read_excel("Baseline cSVD Demo.xlsx", sheet = "binary", skip = 1)
weighted = read_excel("Baseline cSVD Demo.xlsx", sheet = "weighted", skip = 1)
colnames(binary)[1] = "Subject"
colnames(weighted)[1] = "Subject"

binary = merge(subjects, binary, by = "Subject")
binary = subset(binary, Subject != "01_083A" & Subject != "01_085A" & Subject != "01_126A" 
                & Subject != "02_012A" & Subject != "04_013A" & Subject != "03_029A")
colnames(binary) = sub("\\.\\.\\..*", "", colnames(binary))
binary_split = split(binary, binary$Group)

weighted = merge(subjects, weighted, by = "Subject")
weighted = subset(weighted, Subject != "01_083A" & Subject != "01_085A" & Subject != "01_126A" 
                & Subject != "02_012A" & Subject != "04_013A" & Subject != "03_029A")
colnames(weighted) = sub("\\.\\.\\..*", "", colnames(weighted))
weighted_split = split(weighted, weighted$Group)

binary_control = binary_split$Control
binary_SVD = binary_split$SVD

weighted_control = weighted_split$Control
weighted_SVD = weighted_split$SVD

binary_control_matrix = matrix(ncol = 14, nrow = 17)
colnames(binary_control_matrix) = colnames(binary_control[6:19])
rownames(binary_control_matrix) = seq(from=0.08, to=0.40, by=0.02)

binary_SVD_matrix = matrix(ncol = 14, nrow = 17)
colnames(binary_SVD_matrix) = colnames(binary_SVD[6:19])
rownames(binary_SVD_matrix) = seq(from=0.08, to=0.40, by=0.02)

# Check for normal distribution in binary
for (i in 1:17){
  x = 6 + (i-1)*15
  for (j in 1:14){
    test_control = shapiro.test(binary_control[,x])
    test_SVD = shapiro.test(binary_SVD[,x])
    binary_control_matrix[i,j] = test_control$p.value
    binary_SVD_matrix[i,j] = test_SVD$p.value
    x = x+1
  }
}

binary_control_matrix
binary_SVD_matrix

# Test the AIC and R squared
binary_control_matrix_intercept = matrix(ncol = 14, nrow = 17)
colnames(binary_control_matrix_intercept) = colnames(binary_control[6:19])
rownames(binary_control_matrix_intercept) = seq(from=0.08, to=0.40, by=0.02)

binary_control_matrix_age = matrix(ncol = 14, nrow = 17)
colnames(binary_control_matrix_age) = colnames(binary_control[6:19])
rownames(binary_control_matrix_age) = seq(from=0.08, to=0.40, by=0.02)

binary_control_matrix_gender = matrix(ncol = 14, nrow = 17)
colnames(binary_control_matrix_gender) = colnames(binary_control[6:19])
rownames(binary_control_matrix_gender) = seq(from=0.08, to=0.40, by=0.02)

binary_control_matrix_AG = matrix(ncol = 14, nrow = 17)
colnames(binary_control_matrix_AG) = colnames(binary_control[6:19])
rownames(binary_control_matrix_AG) = seq(from=0.08, to=0.40, by=0.02)

binary_control_matrix_education = matrix(ncol = 14, nrow = 17)
colnames(binary_control_matrix_education) = colnames(binary_control[6:19])
rownames(binary_control_matrix_education) = seq(from=0.08, to=0.40, by=0.02)

for (a in 1:17){
  b = 6 + (a-1)*15
  for (c in 1:14){
    control_fit_1 = lm(binary_control[,b] ~ 1)
    control_fit_2 = lm(binary_control[,b] ~ binary_control$Age)
    control_fit_3 = lm(binary_control[,b] ~ binary_control$Gender)
    control_fit_4 = lm(binary_control[,b] ~ binary_control$Age + binary_control$Gender)
    control_fit_5 = lm(binary_control[,b] ~ binary_control$Age + binary_control$Gender + binary_control$Education)
    binary_control_matrix_intercept[a,c] = summary(control_fit_1)$adj.r.squared
    binary_control_matrix_age[a,c] = summary(control_fit_2)$adj.r.squared
    binary_control_matrix_gender[a,c] = summary(control_fit_3)$adj.r.squared
    binary_control_matrix_AG[a,c] = summary(control_fit_4)$adj.r.squared
    binary_control_matrix_education[a,c] = summary(control_fit_5)$adj.r.squared
    b = b+1
  }
}

binary_control_matrix_intercept
binary_control_matrix_age
binary_control_matrix_gender
binary_control_matrix_AG
binary_control_matrix_education

binary_SVD_matrix_intercept = matrix(ncol = 14, nrow = 17)
colnames(binary_SVD_matrix_intercept) = colnames(binary_SVD[6:19])
rownames(binary_SVD_matrix_intercept) = seq(from=0.08, to=0.40, by=0.02)

binary_SVD_matrix_age = matrix(ncol = 14, nrow = 17)
colnames(binary_SVD_matrix_age) = colnames(binary_SVD[6:19])
rownames(binary_SVD_matrix_age) = seq(from=0.08, to=0.40, by=0.02)

binary_SVD_matrix_gender = matrix(ncol = 14, nrow = 17)
colnames(binary_SVD_matrix_gender) = colnames(binary_SVD[6:19])
rownames(binary_SVD_matrix_gender) = seq(from=0.08, to=0.40, by=0.02)

binary_SVD_matrix_AG = matrix(ncol = 14, nrow = 17)
colnames(binary_SVD_matrix_AG) = colnames(binary_SVD[6:19])
rownames(binary_SVD_matrix_AG) = seq(from=0.08, to=0.40, by=0.02)

binary_SVD_matrix_education = matrix(ncol = 14, nrow = 17)
colnames(binary_SVD_matrix_education) = colnames(binary_SVD[6:19])
rownames(binary_SVD_matrix_education) = seq(from=0.08, to=0.40, by=0.02)

for (a in 1:17){
  b = 6 + (a-1)*15
  for (c in 1:14){
    SVD_fit_1 = lm(binary_SVD[,b] ~ 1)
    SVD_fit_2 = lm(binary_SVD[,b] ~ binary_SVD$Age)
    SVD_fit_3 = lm(binary_SVD[,b] ~ binary_SVD$Gender)
    SVD_fit_4 = lm(binary_SVD[,b] ~ binary_SVD$Age + binary_SVD$Gender)
    SVD_fit_5 = lm(binary_SVD[,b] ~ binary_SVD$Age + binary_SVD$Gender + binary_SVD$Education)
    binary_SVD_matrix_intercept[a,c] = summary(SVD_fit_1)$adj.r.squared
    binary_SVD_matrix_age[a,c] = summary(SVD_fit_2)$adj.r.squared
    binary_SVD_matrix_gender[a,c] = summary(SVD_fit_3)$adj.r.squared
    binary_SVD_matrix_AG[a,c] = summary(SVD_fit_4)$adj.r.squared
    binary_SVD_matrix_education[a,c] = summary(SVD_fit_5)$adj.r.squared
    b = b+1
  }
}

binary_SVD_matrix_intercept
binary_SVD_matrix_age
binary_SVD_matrix_gender
binary_SVD_matrix_AG
binary_SVD_matrix_education

# Weighted distribution
weighted_control_matrix = matrix(ncol = 14, nrow = 1)
colnames(weighted_control_matrix) = colnames(weighted_control[6:19])
rownames(weighted_control_matrix) = 0.20

weighted_SVD_matrix = matrix(ncol = 14, nrow = 1)
colnames(weighted_SVD_matrix) = colnames(weighted_SVD[6:19])
rownames(weighted_SVD_matrix) = 0.20

# Check for normal distribution in weighted
for (j in 1:14){
  x = 6
  weighted_test_control = shapiro.test(weighted_control[,x])
  weighted_test_SVD = shapiro.test(weighted_SVD[,x])
  weighted_control_matrix[1,j] = weighted_test_control$p.value
  weighted_SVD_matrix[1,j] = weighted_test_SVD$p.value
  x = x+1
}

weighted_control_matrix
weighted_SVD_matrix

weighted_control_matrix_lm = matrix(ncol = 14, nrow = 5)
colnames(weighted_control_matrix_lm) = colnames(weighted_SVD[6:19])
rownames(weighted_control_matrix_lm) = c("Intercept", "Age", "Gender", "AG", "Education")

weighted_SVD_matrix_lm = matrix(ncol = 14, nrow = 5)
colnames(weighted_SVD_matrix_lm) = colnames(weighted_SVD[6:19])
rownames(weighted_SVD_matrix_lm) = c("Intercept", "Age", "Gender", "AG", "Education")

for (j in 1:14){
  x = 6
  control_test1 = lm(weighted_control[,x] ~ 1)
  control_test2 = lm(weighted_control[,x] ~ weighted_control$Age)
  control_test3 = lm(weighted_control[,x] ~ weighted_control$Gender)
  control_test4 = lm(weighted_control[,x] ~ weighted_control$Age + weighted_control$Gender)
  control_test5 = lm(weighted_control[,x] ~ weighted_control$Age + weighted_control$Gender + weighted_control$Education)
  SVD_test1 = lm(weighted_SVD[,x] ~ 1)
  SVD_test2 = lm(weighted_SVD[,x] ~ weighted_SVD$Age)
  SVD_test3 = lm(weighted_SVD[,x] ~ weighted_SVD$Gender)
  SVD_test4 = lm(weighted_SVD[,x] ~ weighted_SVD$Age + weighted_SVD$Gender)
  SVD_test5 = lm(weighted_SVD[,x] ~ weighted_SVD$Age + weighted_SVD$Gender + weighted_SVD$Education)
  weighted_control_matrix_lm[1,j] = summary(control_test1)$adj.r.squared
  weighted_control_matrix_lm[2,j] = summary(control_test2)$adj.r.squared
  weighted_control_matrix_lm[3,j] = summary(control_test3)$adj.r.squared
  weighted_control_matrix_lm[4,j] = summary(control_test4)$adj.r.squared
  weighted_control_matrix_lm[5,j] = summary(control_test5)$adj.r.squared
  weighted_SVD_matrix_lm[1,j] = summary(SVD_test1)$adj.r.squared
  weighted_SVD_matrix_lm[2,j] = summary(SVD_test2)$adj.r.squared
  weighted_SVD_matrix_lm[3,j] = summary(SVD_test3)$adj.r.squared
  weighted_SVD_matrix_lm[4,j] = summary(SVD_test4)$adj.r.squared
  weighted_SVD_matrix_lm[5,j] = summary(SVD_test5)$adj.r.squared
  x = x+1
}

weighted_control_matrix_lm
weighted_SVD_matrix_lm