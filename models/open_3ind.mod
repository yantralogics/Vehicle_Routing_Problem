## 3 index formulation 
#number of cities
param n; 

#customers - where 1 is first customer, n is last
set V:={1..n}; 
#number of vehicles
param l>=0;
set H := {0,n+1};
# allNodes 
set allNodes := {0..n+1};

set K=1..l; #number of vehicles
param Distance{allNodes,allNodes};
param Capacity{K};
param Demand{allNodes};
var  x{i in allNodes,j in allNodes,k in K} ,binary;
#var y{i in allNodes, k in K} binary;
var  u{V, k in K} integer;

# Objective setting : minimize the total distance travelled
minimize obj: sum{k in K,i in allNodes,j in allNodes: i<>j} Distance[i,j]*x[i,j,k];

# EAch vehicle traverses the city exactly once
#subject to R1{i in V}: sum{k in K}y[i,k]==1;
subject to R1{j in V}: sum{i in V,k in K}x[i,j,k]=1;
## Leave origin depot 
#subject to R2:sum{k in K}y[0,k]=l;
subject to R2{k in K} :sum{i in V} x[0,i,k]=1;
## Arrive at destination depot
#subject to R21:sum{k in K}y[n+1,k]=l;
subject to R21{k in K}:sum{i in V}x[i,n+1,k]=1;
## Tours cannot terminate at origin node
subject to R22:sum{k in K,i in V}x[i,0,k]=0;


## Tours cannot start at destination node
subject to R23:sum{k in K,i in V}x[n+1,i,k]=0;

## Something more
#subject to R24:sum{k in K}x[0,n+1,k]=0;
#subject to R25{k in K}:x[n+1,0,k]=0;

subject to R31{i in allNodes, k in K}:sum{j in allNodes}x[i,j,k]=sum{j in allNodes}x[j,i,k];

#subject to R32{i in allNodes,k in K}:sum{j in allNodes}x[j,i,k]=y[i,k];


#subject to R4{k in K}:sum{i in allNodes, j in allNodes}Demand[i]*x[i,j,k]<=Capacity[k];


subject to R5{i in V,j in V, k in K}:u[i,k]-u[j,k]+Capacity[k]*x[i,j,k] <= Capacity[k]-Demand[j];

subject to R6{i in V, k in K}:Demand[i]<=u[i,k]<=Capacity[k];

### Above formulation works without needing the y_ik variable for the open tour- it's just one pesky edge between depots that's bothering me 
  