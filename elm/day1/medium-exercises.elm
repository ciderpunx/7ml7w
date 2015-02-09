multiply x y  = x * y
multiplyBy6 y = multiply 6 y
-- > multiplyBy6 8
-- 48 : number
-- > 6*8
-- 48 : number
addr = { street = "Cowley rd."
          , town   = "Oxford"
          , county = "Oxon."
          , pc     = "OX4 1DN"
          }

-- Nb all my people share the same address, cos I am lazy!
people = 
  [ { name = "Edward Normalhands", age = 28,  address = addr }
  , { name = "Luke Landwalker",    age = 16,  address = addr }
  , { name = "Dave Vader",         age = 48,  address = addr }
  , { name = "Dan Solo",           age = 33,  address = addr }
  , { name = "Pizza the Hutt",     age = 164, address = addr }
  ]

oldies ps =  \
  case ps of  \
    []      -> [] \
    p::ps'  -> if p.age > 16  \
                  then p :: oldies ps' \
                  else oldies ps'

-- or for a simpler implementation with currying you could
oldies' = filter (\p -> p.age > 16)

-- > oldies people
-- [{ address = { county = "Oxon.", pc = "OX4 1DN", street = "Cowley rd.", town = "Oxford" }, age = 28, name = "Edward Normalhands" },{ address = { county = "Oxon.", pc = "OX4 1DN", street = "Cowley rd.", town = "Oxford" }, age = 48, name = "Dave Vader" },{ address = { county = "Oxon.", pc = "OX4 1DN", street = "Cowley rd.", town = "Oxford" }, age = 33, name = "Dan Solo" },{ address = { county = "Oxon.", pc = "OX4 1DN", street = "Cowley rd.", town = "Oxford" }, age = 164, name = "Pizza the Hutt" }]
--  : [{address : {county : String, pc : String, street : String, town : String}, name : String, age : comparable}]

-- > oldies' people
-- [{ address = { county = "Oxon.", pc = "OX4 1DN", street = "Cowley rd.", town = "Oxford" }, age = 28, name = "Edward Normalhands" },{ address = { county = "Oxon.", pc = "OX4 1DN", street = "Cowley rd.", town = "Oxford" }, age = 48, name = "Dave Vader" },{ address = { county = "Oxon.", pc = "OX4 1DN", street = "Cowley rd.", town = "Oxford" }, age = 33, name = "Dan Solo" },{ address = { county = "Oxon.", pc = "OX4 1DN", street = "Cowley rd.", town = "Oxford" }, age = 164, name = "Pizza the Hutt" }]
--  : [{address : {county : String, pc : String, street : String, town : String}, name : String, age : comparable}]
