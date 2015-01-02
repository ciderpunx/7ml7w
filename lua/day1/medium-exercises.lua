-- Using if and while, write a function for_loop(a,b,f) that 
-- calls f() on each integer from a to b (inclusive)
function for_loop(a,b,f)
  local i=a -- loop counter, create local var rather than reuse 'a'.
  while(i <= b) do
    f(i)
    i=i+1
  end
end

-- example run:
-- > dofile("medium-exercises.lua")
-- > for_loop(1,5,print)
-- 1
-- 2
-- 3
-- 4
-- 5
-- >
