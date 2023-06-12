## 3 index formulation 
#number of cities
param n; 

#customers - where 1 is the depot
set V:={1..n}; 
#number of vehicles
param l;


set K=1..l; #number of vehicles
param Distance{V,V};
param Capacity{K};
param Demand{V};
var  x{i in V,j in V,k in K} ,binary;
var y{i in V, k in K} binary;
var  u{1..v, k in K} integer;

# Objective setting : minimize the total distance travelled
minimize obj: sum{k in K,i in V,j in V: i<>j} Distance[i,j]*x[i,j,k];

# EAch vehicle entes the city exactly once
subject to R1{i in 2..v}: sum{k in K}y[i,k]==1;

subject to R2:sum{k in K}y[1,k]=l;


subject to R31{i in V, k in K}:sum{j in V}x[i,j,k]=sum{j in V}x[j,i,k];

subject to R32{i in V,k in K}:sum{j in V}x[j,i,k]=y[i,k];


subject to R4{k in K}:sum{i in V}Demand[i]*y[i,k]<=Capacity[k];


subject to R5{i in 2..v,j in 2..v, k in K}:u[i,k]-u[j,k]+Capacity[k]*x[i,j,k] <= Capacity[k]-Demand[j];

subject to R6{i in 2..v, k in K}:Demand[i]<=u[i,k]<=Capacity[k];
  