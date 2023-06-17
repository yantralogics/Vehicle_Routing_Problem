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
#  ampl$readData(here::here('data/M-n101-k10.dat'))
# ampl$readData(here::here('models/vrp2.dat'))
## Specify the solver 
 ampl$setOption("solver", 'scip')
ampl$setOption('scip_options','gap=0.05')
 # ampl$setOption('cbc_options','gmicuts=on')
  # ampl$setOption('cbc_options','ratioGap=0.1')
 #ampl$setOption('timelim',5)
ampl$solve()

# Get the values of the variable Buy in a dataframe object
buy <- ampl$getVariable("x")
df <- buy$getValues()

Obj = ampl$getObjective('cost')$getValues()
print(Obj)
# Print them
# print(df)
