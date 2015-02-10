addr = { street = "Cowley rd."
          , town   = "Oxford"
          , county = "Oxon."
          , pc     = "OX4 1DN"
          }

-- Nb all my people share the same address, cos I am lazy!
people =  \
  [ { name = "Edward Normalhands", age = Just 28,  address = addr } \
  , { name = "Luke Landwalker",    age = Just 16,  address = addr } \
  , { name = "Dave Vader",         age = Nothing,  address = addr } \
  , { name = "Dan Solo",           age = Just 33,  address = addr } \
  , { name = "Pizza the Hutt",     age = Just 164, address = addr } \
  ] \

oldies ps =  \
  case ps of  \
    []      -> [] \
    p::ps'  -> case p.age of
                  Just n -> if n > 16  \
                              then p :: oldies ps' \
                              else oldies ps'
                  Nothing -> oldies ps'

-- or for a simpler implementation with currying you could
oldies' = filter (\p -> case p.age of 
                              Just n  -> n > 16
                              Nothing -> False )
