# Two index formulation : 
# n = number of cities
param n>=0;
# k = number of trucks
param K>=0;
# C = capacity of each truck - same capacity
param C >=0;

# Create the set for all the nodes - 0 indicating the depot
set N :=0..n;
# Create the set of arcs 
set A :={i in N,j in N:i<>j};

param c{A}>=0;
# d = demand vector at all the cities except for the depot 
param d{1..n};

# decision variable
var x{A}>=0 binary;
# additional decision variable to remove subtours per MTZ formulation
var u{1..n} >=0;

# Objective function is sum of all distances travelled
minimize cost: sum{i in N,j in N:i<>j} c[i,j]*x[i,j];

# Each city must be entered only once
s.t. C1{j in 1..n-1}:sum{i in N:i<>j} x[i,j]=1;
# Each city must be exited only once
s.t. C2{i in 1..n-1}:sum{j in N:i<>j} x[i,j]=1;
# From depot, exactly K trucks should depart
s.t. C3:sum{j in 1..n-1} x[0,j]=K;
# At the dummy city, exactly K trucks should arrive
s.t. C31:sum{i in 1..n-1} x[i,n]=K;

# MTZ dictated subtour elimination constraint 1
s.t. C4{i in 1..n-1,j in 1..n-1:i<>j}: u[i] - u[j] + C*x[i,j] <= C- d[j];
# MTZ dictated subtour elimination constraint 2 
s.t. C5{i in 1..n-1}:d[i]<= u[i] <= C;
