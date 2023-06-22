# Two index formulation : 
# n = number of cities
param n>=0;
# k = number of trucks
param K>=0;
# C = capacity of each truck - same capacity
param C >=0;

# Create the set for all the nodes - 1 indicating the depot
set N :=1..n;
# Create the set of arcs 
set A :={i in N,j in N};

param c{A}>=0;
# d = demand vector at all the cities except for the depot 
param d{2..n};

# decision variable
var x{A}>=0 binary;
# additional decision variable to remove subtours per MTZ formulation
var u{2..n} >=0;

# Objective function is sum of all distances travelled
minimize cost: sum{i in N,j in N:i<>j} c[i,j]*x[i,j];

# Each city must be entered only once
s.t. C1{j in 2..n}:sum{i in N:i<>j} x[i,j]=1;
# Each city must be exited only once
s.t. C2{i in 2..n}:sum{j in N:i<>j} x[i,j]=1;
# From depot, exactly K trucks should depart
s.t. C3:sum{j in 2..n} x[1,j]=K;
# At the depot, exactly K trucks should arrive
s.t. C31:sum{i in 2..n} x[i,1]=K;

# MTZ dictated subtour elimination constraint 1
s.t. C4{i in 2..n,j in 2..n:i<>j}: u[i] - u[j] + C*x[i,j] <= C- d[j];
# MTZ dictated subtour elimination constraint 2 
s.t. C5{i in 2..n}:d[i]<= u[i] <= C;


