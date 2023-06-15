## This script will allow extracting benchmark data from files and write them in VRP compatible DAT files
# Step1 - read files from benchmark data 
# filepath = here::here('data/augerat-1995-set-a/')
filepath = here::here('data/christofides-et-al-1979-set-m/')
filename = list.files(filepath)[1] ## lets pick the first one 

data = getVRPBenchmark(filepath,filename)

writeVRPDataFile(data,filename)
