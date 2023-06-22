library(rAMPL)
library(tidyverse)
source(here::here('code/functions.R'))
## First identify where ampl is located
env <- new(Environment,'/Users/parikshitmehta/Documents/ampl.macos64/')
## now load a new instance of AMPL model
ampl <- new(AMPL,env)


## read files 
 #model file 
 ampl$read('models/vrp2.mod')
#data file
 
 ampl$readData(here::here('data/A-n32-k05.dat'))
 #ampl$readData(here::here('data/testFile-n30-k4.dat'))
 #ampl$readData(here::here('data/testFile-n50-k6.dat'))
#  ampl$readData(here::here('data/M-n101-k10.dat'))

 #ampl$readData(here::here('models/vrp2.dat'))
 #ampl$readData(here::here('data/F-n045-k4.dat'))
## Specify the solver 
 ampl$setOption("solver", 'cbc')
 ampl$setOption('scip_options','gap=0.2')
# ampl$setOption('ipopt_options','tol=0.2')
 ampl$setOption('cbcmp_options','gomoryCuts=on')
  ampl$setOption('cbc_options','timelim=600')
 t1<-Sys.time()
ampl$solve()
t2<- Sys.time()

print(t2-t1)
# Get the values of the variable Buy in a dataframe object
buy <- ampl$getVariable("x")
df <- buy$getValues()

Obj = ampl$getObjective('cost')$getValues()
print(Obj)
# Print them
# print(df)
