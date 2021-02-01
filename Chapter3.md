# 3 Basics of the Julia Language  

## 3.1 Vector, Matrix, and Array  
```julia
a = [1; 2; 3]
c = [7; 8; 9]
a'*c
dot(a,c)
```
Both a'*c and dot(a,c) are ways to obtain the inner product. However, the result of a'*c is an Array object, and the result of dot(a,c) is a scalar value.  
<br>

## 3.2 Tuple  
```julia
pairs = Array{Tuple{Int64, Int64}}(3) #Create an array object of a certain type
pairs[1] = (1,2)
pairs[2] = (2,3)
pairs[3] = (3,4)
```
is same as 
```julia
pairs = [ (1,2); (2,3); (3,4) ]
```
This array type can be useful for handling network data, like(i,j).  
<br>

## 3.3 Indices and Ranges  
```julia
a = [10; 20; 30; 40; 50; 60; 70; 80; 90]
```
```julia
a[1:3]
```
This result is 
10  
20  
30  

```julia
a[1:3:9]
```
This result is  
10  
40  
70  
If we want steps of 3, we do 1:3:9, and it refers to 1, 4, and 7.  
<br>

# 3.4 Printing Messages
Combining the custom text with values in a variable is easy, It works for arrays
```julia
b = [1; 3; 10]
```
```julia
println("b is $b.")
```
The result is `b is [1,3,10].`  

```julia
println("The second element of b is $(b[2]).")
```
The result is `The second element of b is 3.`  
