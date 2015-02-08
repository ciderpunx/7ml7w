add x y    = x + y
double x   = x * 2
anonSucc   = \x -> x + 1
listSuccs  = map anonSucc
double1to5 = map double [1..5]
getEvens   = filter (\x -> x % 2 == 0)


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
