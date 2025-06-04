#----------Code created by : Abirami K--------------------------------------------------------------------------------
#----------Created purpose : for doing meta analysis for region wise carbohydrate and its sources polled effect-------
#----------Created date    : 17-05-2025-------------------------------------------------------------------------------
#----------R version used  : R 4.3.3 version--------------------------------------------------------------------------



### Install & Load Required Packages --------------------------------------
reqd_pkg <- function(x) {
  if(!is.element(x, installed.packages()[,1])) {
    install.packages(x)
  } else { 
    cat(x, " library already installed\n\n")
  }
  library(x, character.only = TRUE)
}
install.packages("metafor")
install.packages("devtools")# Install devtools if not already installed
library(devtools)# Load devtools
devtools::install_github("MathiasHarrer/dmetar")# Install dmetar from GitHub
library(metafor)
library(openxlsx)
reqd_pkg("Rmisc")
reqd_pkg("readxl")
reqd_pkg("officer")
reqd_pkg('dplyr')
reqd_pkg('flextable')
reqd_pkg('tidyverse')
install.packages("dmetar", dependencies = TRUE)# Install dmetar if not installed
library(dmetar)
library(esc)
library(tidyverse)
library(flextable)
library(meta)
library(dplyr)


# Suppress warnings
defaultW <- getOption("warn") 
options(warn = -1)


# Set working directory
setwd("E:/Server Backup/Downloads/SAS_code/SAS_abi/data/nature medicine indiab work substitution model paper rework/META ANALYSIS BASED ON OUTCOME")

#--------------------------------This code for MAin figure 3(A) and 3(B)--------------------------------------------
# Read required data from the Excel sheet
# we have to do this for every outcome seperately like NDD, PD, General obesity and Abdominal obesity
#First we are doing this for NDD------------------------------------------------------------------------------------------------------
df <- read_excel("E:/Server Backup/Downloads/SAS_code/SAS_abi/data/nature medicine indiab work substitution model paper rework/META ANALYSIS BASED ON OUTCOME/OUTCOME BASED META ANALYSIS.xlsx", sheet = "NDD")
df_summary     <-  data.frame()


# Select only the required columns
Reqd_columns    =  c('CMR',	'Regions',	'OR',	'or.lb',	'or.ub', 'yi',	'ln_or.lb',	'ln_or.ub',	'se',	'vi', 'p-value',	'Carbohydrate sources')
l              =   length(Reqd_columns)
dat            <-  subset(df, select = Reqd_columns)
dat
data

# Display data structure
glimpse(dat)


#Perform meta-analysis with metagen
m.gen <- metagen(
  TE = yi,                    # Effect size (yi)
  seTE = se,                  # Standard error (se)
  studlab = Regions,          # Study label (e.g., carbohydrate sources)
  data = dat,                 # The dataset
  sm = "OR",                  # Summary measure (e.g., Odds Ratio)
  fixed = TRUE,               # Fixed effects model 
  random = TRUE,              # Random effects model
  method.tau = "REML",        # DerSimonian-Laird method for tau
  title = "Carb Source Odds", # Title for the plot
  byvar = dat$"Carbohydrate sources"        # Define the subgroup variable (e.g., carb souces like rice, wheat, millet etc)
)
print(m.gen)


# Detect outliers
find.outliers(m.gen)


# Generate forest plot and save as PNG
png(file = "ndd region wise odss forest plot with title.png", width = 3000, height = 3800, res = 300)
par(family = "serif", cex = 1.2) # Set font style and size using par() # Times New Roman style and 20% larger text
forest(m.gen,
       studlab = TRUE,                         
       comb.fixed = m.gen$comb.fixed,          
       comb.random = m.gen$comb.random,        
       overall = m.gen$overall,                
       label.left = "Protective",  
       label.right = "Risk",  
       xlim = c(0.5, 2),                      
       col.square = "black",                   
       col.diamond = "red",                    
       weight.study = "random",                
       weight.subgroup = "random",             
       print.I2 = TRUE,                        
       print.pval.Q = TRUE,                    
       smlab = "Odds Ratio",                   # Label for summary measure
       fontsize = 12                          # Set font size for text elements
)
#  Add title manually
grid::grid.text("(A)", x = 0.07, y = 0.95, gp = grid::gpar(fontsize = 16, fontface = "bold"))
dev.off()


# Run meta analysis for PD category
# Read required data from the Excel sheet
df <- read_excel("E:/Server Backup/Downloads/SAS_code/SAS_abi/data/nature medicine indiab work substitution model paper rework/META ANALYSIS BASED ON OUTCOME/OUTCOME BASED META ANALYSIS.xlsx", sheet = "PD")
df_summary     <-  data.frame()


# Select only the required columns
Reqd_columns    =  c('CMR',	'Regions',	'OR',	'or.lb',	'or.ub', 'yi',	'ln_or.lb',	'ln_or.ub',	'se',	'vi', 'p-value',	'Carbohydrate sources')
l              =   length(Reqd_columns)
dat            <-  subset(df, select = Reqd_columns)
dat
data


# Display data structure
glimpse(dat)


#Perform meta-analysis with metagen
m.gen <- metagen(
  TE = yi,                    # Effect size (yi)
  seTE = se,                  # Standard error (se)
  studlab = Regions,          # Study label (e.g., carbohydrate sources)
  data = dat,                 # The dataset
  sm = "OR",                  # Summary measure (e.g., Odds Ratio)
  fixed = TRUE,               # Fixed effects model 
  random = TRUE,              # Random effects model
  method.tau = "REML",        # DerSimonian-Laird method for tau
  title = "Carb Source Odds", # Title for the plot
  byvar = dat$"Carbohydrate sources"        # Define the subgroup variable (e.g., carb souces like rice, wheat, millet etc)
)
print(m.gen)


# Detect outliers
find.outliers(m.gen)


# Generate forest plot and save as PNG
png(file = "PD region wise odss forest plot with title.png",  width = 3000, height = 3800, res = 300)
# Set font style and size using par()
par(family = "serif", cex = 1.2)  # Times New Roman style and 20% larger text
forest(m.gen,
       studlab = TRUE,                         
       comb.fixed = m.gen$comb.fixed,          
       comb.random = m.gen$comb.random,        
       overall = m.gen$overall,                
       label.left = "Protective",  
       label.right = "Risk",  
       xlim = c(0.5, 2),                      
       col.square = "black",                   
       col.diamond = "red",                    
       weight.study = "random",                
       weight.subgroup = "random",             
       print.I2 = TRUE,                        
       print.pval.Q = TRUE                    
)
#  Add title manually
grid::grid.text("(B)", 
                x = 0.07, y = 0.95, gp = grid::gpar(fontsize = 16, fontface = "bold"))
dev.off()


### Combine Forest Plots Using Magick ------------------------------------
# load required pakages
library(magick)


# Read saved images
img1 <- image_read("E:/Server Backup/Downloads/SAS_code/SAS_abi/data/nature medicine indiab work substitution model paper rework/META ANALYSIS BASED ON OUTCOME/ndd region wise odss forest plot with title.png")
img2 <- image_read("E:/Server Backup/Downloads/SAS_code/SAS_abi/data/nature medicine indiab work substitution model paper rework/META ANALYSIS BASED ON OUTCOME/PD region wise odss forest plot with title.png")


# Combine images in 1 rows
top_row    <- image_append(c(img1, img2))     # Horizontally 
final_img <- image_append(c(top_row), stack = TRUE)


# Save the final image
image_write(final_img, "Main figure 3 (A) &(B) merged_forest_plot.png")


#--------------------------------This code for Supplementary figure 2(A) and 2(B)--------------------------------------------
# Run meta analysis for general obesity category
# Read required data from the Excel sheet
df <- read_excel("E:/Server Backup/Downloads/SAS_code/SAS_abi/data/nature medicine indiab work substitution model paper rework/META ANALYSIS BASED ON OUTCOME/OUTCOME BASED META ANALYSIS.xlsx", sheet = "general obesity")
df_summary     <-  data.frame()



# Select only the required columns
Reqd_columns    =  c('CMR',	'Regions',	'OR',	'or.lb',	'or.ub', 'yi',	'ln_or.lb',	'ln_or.ub',	'se',	'vi', 'p-value',	'Carbohydrate sources')
l              =   length(Reqd_columns)
dat            <-  subset(df, select = Reqd_columns)
dat
data


# Display data structure
glimpse(dat)


#Perform meta-analysis with metagen
m.gen <- metagen(
  TE = yi,                    # Effect size (yi)
  seTE = se,                  # Standard error (se)
  studlab = Regions,          # Study label (e.g., carbohydrate sources)
  data = dat,                 # The dataset
  sm = "OR",                  # Summary measure (e.g., Odds Ratio)
  fixed = TRUE,               # Fixed effects model 
  random = TRUE,              # Random effects model
  method.tau = "REML",        # DerSimonian-Laird method for tau
  title = "Carb Source Odds", # Title for the plot
  byvar = dat$"Carbohydrate sources"        # Define the subgroup variable (e.g., carb souces like rice, wheat, millet etc)
)
print(m.gen)


# Detect outliers
find.outliers(m.gen)


# Generate forest plot and save as PNG
png(file = "general obesity region wise odss forest plot with title.png",  width = 3000, height = 3800, res = 300)
# Set font style and size using par()
par(family = "serif", cex = 1.2)  # Times New Roman style and 20% larger text
forest(m.gen,
       studlab = TRUE,                         # Show study labels
       comb.fixed = m.gen$comb.fixed,          # Fixed effect option
       comb.random = m.gen$comb.random,        # Random effect option
       overall = m.gen$overall,                # Overall effect
       label.left = "Protective",  # Left label for effect
       label.right = "Risk",  # Right label for effect
       xlim = c(0.5, 2),                      # Set custom x-axis limits
       col.square = "black",                   # Color for squares
       col.diamond = "red",                    # Color for diamonds
       weight.study = "random",                # Set weight for studies
       weight.subgroup = "random",             # Set weight for subgroups
       print.I2 = TRUE,                        # Print I² statistic
       print.pval.Q = TRUE,                    # Print p-value for Q statistic
       
)
#  Add title manually
grid::grid.text("(A)", 
                x = 0.07, y = 0.95, gp = grid::gpar(fontsize = 16, fontface = "bold"))
dev.off()


# Run meta analysis for abdominal obesity category
# Read required data from the Excel sheet
df <- read_excel("E:/Server Backup/Downloads/SAS_code/SAS_abi/data/nature medicine indiab work substitution model paper rework/META ANALYSIS BASED ON OUTCOME/OUTCOME BASED META ANALYSIS.xlsx", sheet = "abdominal obesity")
df_summary     <-  data.frame()


# Select only the required columns
Reqd_columns    =  c('CMR',	'Regions',	'OR',	'or.lb',	'or.ub', 'yi',	'ln_or.lb',	'ln_or.ub',	'se',	'vi', 'p-value',	'Carbohydrate sources')
l              =   length(Reqd_columns)
dat            <-  subset(df, select = Reqd_columns)
dat
data


# Display data structure
glimpse(dat)


#Perform meta-analysis with metagen
m.gen <- metagen(
  TE = yi,                    # Effect size (yi)
  seTE = se,                  # Standard error (se)
  studlab = Regions,          # Study label (e.g., carbohydrate sources)
  data = dat,                 # The dataset
  sm = "OR",                  # Summary measure (e.g., Odds Ratio)
  fixed = TRUE,               # Fixed effects model 
  random = TRUE,              # Random effects model
  method.tau = "REML",        # DerSimonian-Laird method for tau
  title = "Carb Source Odds", # Title for the plot
  byvar = dat$"Carbohydrate sources"        # Define the subgroup variable (e.g., carb souces like rice, wheat, millet etc)
)
print(m.gen)


# Detect outliers
find.outliers(m.gen)


# Generate forest plot and save as PNG
png(file = "abdominal obesity region wise odss forest plot with title.png",  width = 3000, height = 3800, res = 300)
# Set font style and size using par()
par(family = "serif", cex = 1.2)  # Times New Roman style and 20% larger text
forest(m.gen,
       studlab = TRUE,                         # Show study labels
       comb.fixed = m.gen$comb.fixed,          # Fixed effect option
       comb.random = m.gen$comb.random,        # Random effect option
       overall = m.gen$overall,                # Overall effect
       label.left = "Protective",  # Left label for effect
       label.right = "Risk",  # Right label for effect
       xlim = c(0.5, 2),                      # Set custom x-axis limits
       col.square = "black",                   # Color for squares
       col.diamond = "red",                    # Color for diamonds
       weight.study = "random",                # Set weight for studies
       weight.subgroup = "random",             # Set weight for subgroups
       print.I2 = TRUE,                        # Print I² statistic
       print.pval.Q = TRUE,                    # Print p-value for Q statistic
       
)
#  Add title manually
grid::grid.text("(B)", 
                x = 0.07, y = 0.95, gp = grid::gpar(fontsize = 16, fontface = "bold"))
dev.off()


### Combine Forest Plots Using Magick ------------------------------------
# Required pakage
library(magick)


# Read saved images
img1 <- image_read("E:/Server Backup/Downloads/SAS_code/SAS_abi/data/nature medicine indiab work substitution model paper rework/META ANALYSIS BASED ON OUTCOME/general obesity region wise odss forest plot with title.png")
img2 <- image_read("E:/Server Backup/Downloads/SAS_code/SAS_abi/data/nature medicine indiab work substitution model paper rework/META ANALYSIS BASED ON OUTCOME/abdominal obesity region wise odss forest plot with title.png")


# Combine images in 1 rows
top_row    <- image_append(c(img1, img2))     # Horizontally
final_img <- image_append(c(top_row), stack = TRUE)


# Save the final image
image_write(final_img, "Extended figure 2 merged_forest_plot(A) and (B).png")




