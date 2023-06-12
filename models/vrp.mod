
param v; 
#number of customers

set V:={1..v}; 
#customers - where 1 is the depot

param l;#number of vehicles
param n;
set K=1..l; #number of vehicles
param Distance{V,V};
param Capacity{K};
param Demand{V};
var  x{i in V,j in V,k in K} ,binary;
var  u{1..v} integer;

# Objective setting : minimize the total distance travelled
minimize obj: sum{k in K,i in V,j in V: i<>j} Distance[i,j]*x[i,j,k];
# EAch vehicle entes the city exactly once
subject to R1{j in 2..v}: sum{k in K}sum{i in V:i<>j} x[i,j,k]==1;
# EAch vehicle exists the city exactly once
subject to R2{i in 2..v}: sum{k in K} sum{j in V:i<>j} x[i,j,k]=1;
## Make sure that all the vehicles leave the depot
subject to R3{k in K}: sum{j in 2..v} x[1,j,k]=1;

# All vehicles should exit the nodes they entered
#subject to R4{k in K,h in 2..v:h<>1}:sum{i in V}x[i,h,k]-sum{j in V}x[h,j,k]=0;
subject to R4{k in K,j in 2..v}:sum{i in V}x[i,j,k]=sum{i in V}x[j,i,k];
# Capacity constraint
subject to R5{k in K}:sum{i in 2..v,j in 2..v:i<>1} Demand[i]*x[i,j,k] <= Capacity[k];

#Subtour elimination constraint 
subject to R6{k in K,i in 2..v,j in 2..v:i<>j}: u[i]-u[j]+n*x[i,j,k]<= n-1;

  
  
#  subject to {
#    forall(j in V:j!=1)
#      sum (i in V, k in K )
#        x[i][j][k] == 1; 
        
#     forall(i in V:i!=1)
#       sum (j in V, k in K)
#         x[i][j][k] == 1;
         
#       forall (k in K)
#          sum (j in V) x[1][j][k] == 1;
 
         
#      forall(k in K, h in V:h!=1)
#        sum(i in V) x[i][h][k] - sum(j in V) x[h][j][k] == 0;
        
#     forall(k in K)
#       sum(i,j in V: i !=1 ) Demand[i]*x[i][j][k] <= Capacity[k];
         
       
#        forall (i in V, k in K)
 #       x[i][i][k] == 0;
          
         
  #     forall(k in K, i in 2:V, j in 2:V: i != j)
   #     u[i]-u[j]+n*x[i][j][k]<=n-1;
         
    #   }
