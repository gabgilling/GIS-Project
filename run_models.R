library(spdep)
library(rgdal)
library(spatialreg)

all_vars <- readOGR("/Users/gabgilling/Documents/all_vars.shp")

fit <- lm(pref_index ~ pid + NUMPOINTS, data = all_vars@data)

list.queen <-poly2nb(all_vars, queen = T)

W <- nb2listw(list.queen, style = "W", zero.policy = T)

moran.lm <- lm.morantest(fit, W, alternative = "two.sided", zero.policy =  T)

print(moran.lm)

tests <- lm.LMtests(fit, W, test = "all", zero.policy = T)

sar <- lagsarlm(pref_index ~ pid + NUMPOINTS, data = all_vars@data, W, zero.policy = T)
err <- errorsarlm(pref_index ~ pid + NUMPOINTS, data = all_vars@data, W, zero.policy = T)

summary(sar)

summary(err)
