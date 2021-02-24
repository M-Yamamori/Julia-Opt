## 5.2 Searching All Basic Feasible Solutions  
In this chapter, we try to search all BFS.  
First, I want to think about ```isnonnegative function```.  
```julia
length(x[x.<0]) == 0

x = [-1; 2; -2]
x.<0
x[x.<0]
length(x[x.<0]) == 0
```