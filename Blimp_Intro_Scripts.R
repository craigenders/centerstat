#------------------------------------------------------------------------------#
# Introduction to Data Modeling in Blimp
# CenterStat
#
# rblimp scripts for the four class examples. The scripts read the class data
# from GitHub, so no file download is needed. Blimp must be installed first
# (https://www.appliedmissingdata.com/blimp).
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# INSTALL AND LOAD R PACKAGES ----
#------------------------------------------------------------------------------#

# run once to install rblimp (choose one)
# install.packages('rblimp')                       # CRAN release
# remotes::install_github('blimp-stats/rblimp')    # development version

library(rblimp)                                    # R interface to Blimp

#------------------------------------------------------------------------------#
# IMPORT DATA ----
#------------------------------------------------------------------------------#

data_url <- 'https://raw.githubusercontent.com/craigenders/centerstat/main/inflammation.csv'

inflammation <- read.csv(data_url)                 # csv with header row, NA = missing

#------------------------------------------------------------------------------#
# MODEL 1: LINEAR REGRESSION ----
#------------------------------------------------------------------------------#

model1 <- rblimp(
  data    = inflammation,                          # R data frame
  ordinal = 'female',                              # binary/ordinal variables
  nominal = 'elstress',                            # automatic dummy coding
  center  = 'inflam age',                          # grand mean centering
  model   = 'dpdd ~ inflam elstress female age',   # regression equation
  seed    = 90291,                                 # random number seed
  burn    = 10000,                                 # warm-up iterations
  iter    = 10000)                                 # analysis iterations

output(model1)                                     # print output

#------------------------------------------------------------------------------#
# MODEL 2: GRAPHICAL DIAGNOSTICS ----
#------------------------------------------------------------------------------#

model2 <- rblimp(
  data    = inflammation,                          # R data frame
  ordinal = 'female',                              # binary/ordinal variables
  nominal = 'elstress',                            # automatic dummy coding
  center  = 'inflam age',                          # grand mean centering
  model   = 'dpdd ~ inflam elstress female age',   # regression equation
  seed    = 90291,                                 # random number seed
  burn    = 10000,                                 # warm-up iterations
  iter    = 10000,                                 # analysis iterations
  nimps   = 20)                                    # save 20 imputed data sets

output(model2)                                     # print output
distribution_plots(model2)                         # univariate plots
diagnostic_plots(model2)                           # regression diagnostics

#------------------------------------------------------------------------------#
# MODEL 3: SENSITIVITY ANALYSIS WITH A NORMALIZED OUTCOME ----
#------------------------------------------------------------------------------#

model3 <- rblimp(
  data    = inflammation,                          # R data frame
  ordinal = 'female',                              # binary/ordinal variables
  nominal = 'elstress',                            # automatic dummy coding
  center  = 'inflam age',                          # grand mean centering
  model   = 'yjt(dpdd - 6) ~ inflam elstress female age',   # normalized outcome
  seed    = 90291,                                 # random number seed
  burn    = 10000,                                 # warm-up iterations
  iter    = 10000,                                 # analysis iterations
  nimps   = 20)                                    # save 20 imputed data sets

output(model3)                                     # print output
distribution_plots(model3)                         # univariate plots
diagnostic_plots(model3)                           # regression diagnostics

#------------------------------------------------------------------------------#
# MODEL 4: MODERATED REGRESSION ----
#------------------------------------------------------------------------------#

model4 <- rblimp(
  data    = inflammation,                          # R data frame
  ordinal = 'female',                              # binary/ordinal variables
  nominal = 'elstress',                            # automatic dummy coding
  center  = 'inflam age',                          # grand mean centering
  model   = 'dpdd ~ inflam elstress female age inflam*elstress',   # product term
  simple  = 'inflam | elstress',                   # conditional effects
  seed    = 90291,                                 # random number seed
  burn    = 10000,                                 # warm-up iterations
  iter    = 10000)                                 # analysis iterations

output(model4)                                     # print output
simple_plot(dpdd ~ inflam | elstress, model4)      # plot conditional effects
