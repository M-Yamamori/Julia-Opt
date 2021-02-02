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
This array type can be useful for handling network data, like(i, j).  
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

## 3.4 Printing Messages
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
<br>

## 3.5 Collection, Dictionary, and For-Loop  
Suppose we have the following data about a network.  
```julia
links = [ (1,2), (3,4), (4,2) ]
link_costs = [ 5, 13, 8 ]
```
Create a dictionary for this data.
```julia
link_dict = Dict()
for i in 1:length(links)
    link_dict[ links[i] ] = link_costs[i]
end
println(link_dict)
```
```
Dict{Any,Any}((1, 2) => 5,(4, 2) => 8,(3, 4) => 13)
```  
Then we can use it like this 
```julia
for (link, cost) in link_dict
    println("Link $link has cost of $cost.")
end
```
```
Link (1, 2) has cost of 5.
Link (4, 2) has cost of 8. 
Link (3, 4) has cost of 13.
```
<br>

## 3.6 Function  
We can create a Julia function as follows  
```julia
function f(x,y)
  return 3x + y
end
```
We also can define the same function in more compact form, called “assignment form”.  
```julia
f(x,y) = 3x+y
```
<br>

## 3.7 Scope of Variables  
```julia
function f(x)
  return x+2
end

function g(x)
  return 3x+3
end
```
In this code, x is used in two different functions, but they do not conflict. This is because they are defined in different **scope blocks**.  
```julia
function f2(x)
  a = 0
  return x+a
end

a = 5
println(f2(1))
println(a)
```
This result will be   
```
1
5
```
The same **a** variable name is used in two different places, and it can be confusing and may lead to bugs. To control the scope of variables, we can use keywords like **global**, **local**, and **const**.  
<br>

- Note  
Global variable: A variable that can be used in multiple functions.  
Local variable: A variable that can be used only in one function.  
Const: Variables with unchanging values can be conveyed to the compiler using the ```const``` keyword. The ```const``` declaration should only be used in global scope.  