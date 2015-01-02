-- Write a function reduce(max, init, f) that calls a function over the
-- integers from 1 to max like so:
--
-- This feels curiously imperitive for an implementation of a
-- functional-style fold :-)
function reduce(max, init, f)
  local acc = init
  for i=1, max do
    acc = f(acc, i)
  end
  return acc
end

function add(previous, next)
  return previous + next
end

-- Implement factorial() in terms of reduce()
-- helper function for doing products. though it is trivial enough that
-- you could use an anonyous function
function product(n,m)
  return n*m
end

function fac(n)
  return reduce(n,1,product)
end
