library(dplyr)
library(foreign)
library(tidyr)

cces <- read.table("/Users/gabgilling/Downloads/CCES19_Common_OUTPUT.tab", header = T, sep = "\t", fill = TRUE)

# RECODE AT-LARGE STATES TO ALIGN WITH GOV FORMAT
cces$cdid116 <- ifelse(cces$inputstate %in% c(2,10,30,38,46,50,56), "00", cces$cdid116)


cces$inputstate <- ifelse(nchar(cces$inputstate) == 1, paste("0", as.character(cces$inputstate), sep= ""),cces$inputstate)
cces$cdid116 <- ifelse(nchar(cces$cdid116) == 1, paste("0", as.character(cces$cdid116), sep= ""),cces$cdid116)

cces$q1 <- with(cces, ifelse(CC19_340a == 1, 1, ifelse(CC19_340a == 2, 0, NA)))
cces$q2 <- with(cces, ifelse(CC19_340b == 1, 1, ifelse(CC19_340b == 2, 0, NA)))
cces$q3 <- with(cces, ifelse(CC19_340c== 1, 1, ifelse(CC19_340c == 2, 0, NA)))
cces$q4 <- with(cces, ifelse(CC19_332a == 1, 1, ifelse(CC19_332a== 2, 0, NA)))

cces$state_cd <- paste(as.character(cces$inputstate), as.character(cces$cdid116), sep = "-")

cces2 <- read.csv("/Users/gabgilling/Downloads/cces18_common_vv.csv")

cces2$cdid116 <- ifelse(cces2$inputstate %in% c(2,10,30,38,46,50,56), "00", cces2$cdid116)

cces2$inputstate <- ifelse(nchar(cces2$inputstate) == 1, paste("0", as.character(cces2$inputstate), sep= ""),cces2$inputstate)
cces2$cdid116 <- ifelse(nchar(cces2$cdid116) == 1, paste("0", as.character(cces2$cdid116), sep= ""),cces2$cdid116)

cces2$state_cd <- paste(as.character(cces2$inputstate), as.character(cces2$cdid116), sep = "-")
cces2$q5 <- with(cces2, ifelse(CC18_415a == 1, 1, ifelse(CC18_415a == 2, 0, NA)))
cces2$q6 <- with(cces2, ifelse(CC18_415b == 1, 1, ifelse(CC18_415b == 2, 0, NA)))
cces2$q7 <- with(cces2, ifelse(CC18_415c == 1, 1, ifelse(CC18_415c == 2, 0, NA)))
cces2$q8 <- with(cces2, ifelse(CC18_415d == 1, 1, ifelse(CC18_415d == 2, 0, NA)))
#paris agreement
cces2$q9 <- with(cces2, ifelse(CC18_332c == 1, 1, ifelse(CC18_332c == 2, 0, NA)))

t2 <- cces2 %>% group_by(state_cd) %>% summarise(pref_index2 = mean(q5+q6+q7+q8+q9, na.rm = T))

t1 <- cces %>% group_by(state_cd) %>% summarise(pref_index1 = mean(q1+q2+q3+q4, na.rm = T))

pid <- cces %>% group_by(state_cd) %>% summarise(pid = mean(pid3, na.rm = T))

f <- merge(t1, t2, by = "state_cd", all = T)

f$pref_index <- NA

for (i in 1:nrow(f)){
  if(is.na(f$pref_index1[i]) & is.na(f$pref_index2[i])){
    next
  }
  else if (is.na(f$pref_index1[i]) & !is.na(f$pref_index2[i])){
    f$pref_index[i] <- f$pref_index2[i]
  }
  else if (!is.na(f$pref_index1[i]) & is.na(f$pref_index2[i])){
    f$pref_index[i] <- f$pref_index1[i]
  }  
  else if (!is.na(f$pref_index1[i]) & !is.na(f$pref_index2[i])){
    f$pref_index[i] <- (f$pref_index1[i] + f$pref_index2[i])/2
  }  
  
}

f$pref_index <- as.numeric(scale(f$pref_index))

cd_shp$pref_index.x <- NULL


cd_shp <- read.dbf("/Users/gabgilling/Downloads/tl_2018_us_cd116 (1)/tl_2018_us_cd116.dbf")


cd_shp$state_cd <- paste(as.character(cd_shp$STATEFP), as.character(cd_shp$CD116FP), sep = "-")

cd_shp <- merge(cd_shp, f %>% select(state_cd, pref_index), by = "state_cd", all.x = T)
cd_shp <- merge(cd_shp, pid %>% select(state_cd, pid), by = "state_cd", all.x = T)

write.dbf(cd_shp,"/Users/gabgilling/Downloads/tl_2018_us_cd116 (1)/tl_2018_us_cd116.dbf")