var x1 >= 0; # var 1
var x2 >= 0; # var 2

# objective function
maximize z: 300*x1 + 200*x2;


# constraints

subject to M1: 2*x1 + x2 <=8;
subject to M2: x1 + 2*x2 <= 8;