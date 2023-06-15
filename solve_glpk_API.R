library(glpkAPI)
# Using glpk API

## Allocate workspace 
prob1 <- initProbGLPK()

## set name to the problem
setProbNameGLPK(prob1, "vrp1")
## Allocate worspace 
vrpp <- mplAllocWkspGLPK()

rest <- mplReadModelGLPK(vrpp,  here::here('models/vrp2.mod'), skip=0)


#rest <- mplReadDataGLPK(vrpp,here::here('models/vrp2.dat'))
rest <- mplReadDataGLPK(vrpp,here::here('data/A-n32-k05.dat'))

result <- mplGenerateGLPK(vrpp)
rest <- mplBuildProbGLPK(vrpp,prob1)

result <- solveSimplexGLPK(prob1)

result <-solveMIPGLPK(prob1)

result <- mplPostsolveGLPK(vrpp,prob1,GLP_MIP)

mplFreeWkspGLPK(vrpp)
delProbGLPK(prob1)
