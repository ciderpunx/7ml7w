-- > x=0
-- 0 : number
-- > if x<0 then "too small" else "ok"
-- "ok" : String
-- > if | x<0 then "too small" \
-- |    | x>0 then "too big" \
-- |    | otherwise -> "just right"
-- [1 of 1] Compiling Repl                ( repl-temp-000.elm )
-- Parse error at (line 3, column 12):
-- unexpected "t"
-- expecting "{-", " ", newline or arrow (->)
-- 
-- > if | x<0 -> "too small" \
-- |    | x>0 -> "too big" \
-- |    | otherwise -> "just right"
-- 
-- "just right" : String

list1 = [1,2,3]

-- case list1 of head::tail -> tail
--               []         -> []
