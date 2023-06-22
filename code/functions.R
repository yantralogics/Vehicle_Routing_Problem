getVRPBenchmark <- function(filepath,filename){
  require(xml2)
  allDat = read_xml(file.path(filepath,filename)) 
  
  ## Get nodes 
  nodes <- allDat %>% xml_find_all('network/nodes')
  nodeNames <- nodes %>% xml_children() %>% xml_children() %>% xml_name() 
  nodeCoords <- nodes %>% xml_children() %>%xml_children() %>% xml_text()
  
  nodeDF <- data.frame(node1 = nodeNames, nodeCoord = nodeCoords, stringsAsFactors = F) %>% group_by(node1) %>% 
    mutate(Ind = 1:n()) %>% ungroup() %>% 
    pivot_wider(names_from = 'node1', values_from = nodeCoord) %>% 
    mutate(cx= as.numeric(cx),
           cy=as.numeric(cy))
  
  Demand <- allDat %>% xml_find_all('//requests') %>% xml_children() %>% xml_find_all('quantity') %>% xml_text()
  Demand <- c('0',Demand)
  demandDF <- data.frame(node =1:nrow(nodeDF),demand = Demand,stringsAsFactors = F)
  distMat= matrix(0,nrow = nrow(nodeDF),ncol = nrow(nodeDF))
  for(i in 1:nrow(nodeDF)){
    for(j in 1:nrow(nodeDF)){
      #distMat[i,j]=sqrt(nodeDF$cx[i]^2 + nodeDF$cy[j]^2)
      if(i!=j){
        distMat[i,j]=sqrt((nodeDF$cx[j]-nodeDF$cx[i])^2 + (nodeDF$cy[j]- nodeDF$cy[i])^2)  
      }
      
    }
  }
  
  k= str_extract(filename,'k\\d+')
  k2 = str_extract(k,'\\d+')
  
  ## Vehicle Capacity
  Cap = allDat %>% xml_find_all('//capacity') %>% xml_text()
  return(list(distMat= distMat, nodesDemand= Demand, vehicles=k2,Capacity=Cap))
}

writeVRPDataFile <- function(data,filename){
  ## input to the function is the data as parsed by getVRPBenchmark and corresponding filename
  newfileName = gsub(pattern = '.xml',replacement = '.dat',x = filename)
  f1 <- file(here::here('data',newfileName),open = 'w')
  writeLines(paste('param n :=',nrow(data$distMat),';'),f1)
  writeLines(paste('param K :=',as.integer(data$vehicles),';'),f1)
  writeLines(paste('param C :=',as.integer(data$Capacity),';'),f1)
  writeLines(paste('param d :='),f1)
  writeLines(paste(1:(nrow(data$distMat)),data$nodesDemand),f1)
  writeLines(';',f1)
  writeLines(paste( paste(c('param c :',
                            1:(nrow(data$distMat))),collapse = ' '),':='),f1)
  for(i in 1:(nrow(data$distMat))){
    ## write it row by row and index 
    writeLines(paste(c(i, as.integer(data$distMat[i,])), collapse = ' '),f1)
  }
  writeLines(';',f1)
  close(f1)
  return(newfileName)
}

createRandomfile <- function(nCities,nTrucks,openEnds=F,openStarts = F){
  ## Create a VRP file based on the cities and trucks 
  Xcoords = runif(nCities,min = 10, max = 30)
  Ycoords = runif(nCities, min = 20, max = 40)
  
  distMat=  dist(matrix(data = c(Xcoords,Ycoords), nrow = nCities,ncol = 2),
                 method = 'euclidian',
                 diag = T,
                 upper = T)
  
  data = list()
  data$distMat = as.matrix(distMat)
  data$vehicles = nTrucks
  data$nodesDemand = c(0,as.integer(runif(nCities-1,min=0,max = 10)))
  # hard coded for now 
  data$Capacity = 50
  data$filename = paste0('testFile-','n',nCities,'-k',nTrucks,'.dat')
  
  writeVRPDataFile(data,data$filename)
  
  
}