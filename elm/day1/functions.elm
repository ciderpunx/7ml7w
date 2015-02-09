add x y    = x + y
double x   = x * 2
anonSucc   = \x -> x + 1
listSuccs  = map anonSucc
double1to5 = map double [1..5]
getEvens   = filter (\x -> x % 2 == 0)

fac x =
  if | x == 0    -> 1
     | otherwise -> x * fac (x-1)

count list = 
  case list of
    []         -> 0
    head::tail -> 1 + count tail

-- pattern matching (prob bcs first[] will be a runtime error)
first (head::tail) = head

-- types of functions
-- add is number -> number -> number

-- partial application of add (currying)
-- inc is a <function> : number -> number
inc = add 1

-- <function> : appendable -> appendable -> appendable
concat x y = x ++ y

-- { x = 5, y = 4 } : {x : number, y : number'}
somePoint = {x=5,y=4}

-- <function> : {a | x : number} -> number
xDist point = abs point.x
-- > xDist somePoint
-- 5 : number
-- But also
--{ x = 5, y = 4 } : {x : number, y : number'}
twoD = {x=5,y=4}

-- { x = 5, y = 4, z = 3 } : {x : number, y : number', z : number''}
threeD = {x=5,y=4,z=3}

-- > xDist t
-- threeD  twoD
-- > xDist twoD
-- 5 : number
-- > xDist threeD
-- 5 : number

-- in non-REPL situations can also say
xDist' {x} = abs x

-- > double (add 1 2)
-- 6 : number
-- > listSuccs [1,2,3]
-- [2,3,4] : [number]

-- We also have the nice elixir composition operator:
-- > add 1 2 |> double
-- 6 : number

-- And in the other direction
-- > double <| anonSucc 4
-- 10 : number
