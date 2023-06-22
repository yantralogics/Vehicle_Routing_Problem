# Open- Open Two index formulation : 
# n = number of cities
param n>=0;
# k = number of trucks
param K>=0;
# C = capacity of each truck - same capacity
param C >=0;

# Create the set for all city nodes 
set N :=1..n;

set allNodes := 0..(n+1);
# Create the set of arcs 
set A := {i in allNodes,j in allNodes};

# c is the parameter that contains distances across all arcs 
param c{A}>=0;
# d = demand vector at all the cities except for the depot and destination 
param d{N};

# decision variable
var x{A}>=0 binary;
# additional decision variable to remove subtours per MTZ formulation
var u{N} >=0;

# Objective function is sum of all distances travelled
minimize cost: sum{i in allNodes,j in allNodes:i<>j} c[i,j]*x[i,j];

# Each city must be entered only once
s.t. C1{j in N}:sum{i in allNodes:i<>j} x[i,j]=1;
# Each city must be exited only once
s.t. C2{i in N}:sum{j in allNodes:i<>j} x[i,j]=1;
# From depot, exactly K trucks should depart
s.t. C3:sum{j in N} x[0,j]=K;
# At the dummy city, exactly K trucks should arrive
s.t. C31:sum{i in N} x[i,n+1]=K;

## Trucks cannot arrive back at the origin
s.t. C32: sum{i in N}x[i,0]=0;

## Trucks cannot depart from the end destination:
s.t. C33: sum{i in N}x[n+1,i]=0;


# MTZ dictated subtour elimination constraint 1
s.t. C4{i in N,j in N:i<>j}: u[i] - u[j] + C*x[i,j] <= C- d[j];
# MTZ dictated subtour elimination constraint 2 
s.t. C5{i in N}:d[i]<= u[i] <= C;
