# Multidimensional array with increasing numbers in 5x5 blocks
a = fill(0,(5,5,5))
for i in 1:5
  a[:,:,i]=i
end
println(a)
