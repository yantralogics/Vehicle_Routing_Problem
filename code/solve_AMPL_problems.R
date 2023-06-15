library(rAMPL)

## First identify where ampl is located
env <- new(Environment,'/Users/parikshitmehta/Documents/ampl.macos64/')
## now load a new instance of AMPL model
ampl <- new(AMPL,env)


## read files 
 #model file 
 ampl$read('models/vrp2.mod')
#data file
 ampl$readData(here::here('data/A-n32-k05.dat'))
 # ampl$readData(here::here('data/M-n101-k10.dat'))
# ampl$readData(here::here('models/vrp2.dat'))
## Specify the solver 
 ampl$setOption("solver", 'cbc')
 ampl$setOption('cbc_options','ratioGap=0.1')
 # ampl$setOption('cbc_options','timelim=50')
 # ampl$setOption('cbc_options','mipgap=0.1')
 #ampl$setOption('timelim',5)
ampl$solve()

# Get the values of the variable Buy in a dataframe object
buy <- ampl$getVariable("x")
df <- buy$getValues()
# Print them
# print(df)
