#### Dittrichia: Blue Oak Competition Data Analysis: Phenology Survey ####


#### Packages ####

#Install packages
install.packages("googlesheets4")
install.packages("plotrix")
install.packages("dplyr")
install.packages("ggplot2")

#Load packages
library(googlesheets4)
library(plotrix)
library(dplyr)
library(ggplot2)

#### Loading Data Sheets ####

#Raw Data Input (whole data sheet) - straight from google sheets
phenology_data <- read_sheet("https://docs.google.com/spreadsheets/d/1dYs2nKqeF5yOkt4kmxDGKn8S9-H6o9OxXlO4oMAhOcs/edit#gid=913269526")
View(phenology_data)

#Raw Data Input (whole data sheet) - from csv file
phenology_data <- read.csv("Blue_Oak_2021_Phenology_Survey.csv")
View(phenology_data)

#Create Individual Data Frames for Analysis
daysalive <- phenology_data[, c("Flag_Pos", "Trt", "NumDaysAlive")]
View(daysalive)

biomass <- phenology_data[, c("Flag_Pos", "Trt", "Biomass")]
View(biomass)
biomass_na <- na.omit(biomass)
View(biomass_na)

height_raw <- phenology_data[, c("Flag_Pos", "Trt", "Height")]
View(height_raw)
height_na <- na.omit(height_raw)
View(height_na)

#### Summary Data Frames for Plotting ####

#Number of Days Alive
daysalive_sum <- daysalive %>%
  group_by(Trt) %>%
  summarise(
    mean_days = mean(NumDaysAlive),
    std_days = std.error(NumDaysAlive))
View(daysalive_sum)

#Biomass
biomass_sum <- biomass_na %>%
  group_by(Trt) %>%
  summarise(
    mean_biomass = mean(Biomass),
    std_biomass = std.error(Biomass))
View(biomass_sum)

#Height
height_sum <- height_na %>%
  group_by(Trt) %>%
  summarise(
    mean_height = mean(Height),
    std_height = std.error(Height))
View(height_sum)

#### Plots ####

#Number of Days Alive vs. Treatment
ggplot(daysalive_sum, aes(x=Trt, y=mean_days)) + 
  geom_bar(position = "dodge",
           stat = "summary",
           fun = "mean") +
  xlab("Treatment") + 
  ylab("Number of Days Alive") +
  geom_errorbar(aes(x=Trt, ymin=mean_days - std_days, ymax = mean_days + std_days)) +
  theme_bw() +
  scale_y_continuous(breaks=seq(0, 300, 20))

#Biomass vs. Treatment
ggplot(biomass_sum, aes(x=Trt, y=mean_biomass)) + 
  geom_bar(position = "dodge",
           stat = "summary",
           fun = "mean") +
  xlab("Treatment") + 
  ylab("Biomass") +
  geom_errorbar(aes(x=Trt, ymin=mean_biomass - std_biomass, ymax=mean_biomass + std_biomass)) +
  theme_bw() +
  scale_y_continuous(breaks=seq(0, 10, 1))

#Height vs. Treatment
ggplot(height_sum, aes(x=Trt, y=mean_height)) + 
  geom_bar(position = "dodge",
           stat = "summary",
           fun = "mean") +
  xlab("Treatment") + 
  ylab("Height") +
  geom_errorbar(aes(x=Trt, ymin=mean_height - std_height, ymax=mean_height + std_height)) +
  theme_bw()


