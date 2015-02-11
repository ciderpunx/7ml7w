product xs = 
  case xs of
    []     -> 1
    x::xs' -> x * product xs'

-- <function> : [number] -> number
-- > product [3,5]
-- 15 : number
-- > product [3,5,2]
-- 30 : number
-- > product [3,5,2,2]
-- 60 : number

somePoint = {x=5,y=4}
twoD = {x=5,y=4}

allX ps = 
  case ps of
    []     -> []
    p::ps' -> abs p.x :: allX ps'

-- > allX [twoD, somePoint]
-- [5,5] : [number]

address = { street = "Cowley rd."
          , town   = "Oxford"
          , county = "Oxon."
          , pc     = "OX4 1DN"
          }

person = { name    = "Edward Normalhands"
         , age     = 28
         , address = address
         }
data Street    = Street String
data Town      = Town String
data County    = County String
data Postcode  = Postcode String
data Address   = Address Street Town County Postcode

data Name          = Name String
data Age           = Age Int
data Person        = Person Name Age Address

ad = Address (Street "Cowley rd.") (Town "Oxford") (County "Oxon.") (Postcode "OX4 1DN")
p  = Person (Name "Edward Normalhands") (Age 28) ad

-- Records or ADTs easier to aolve the problem
-- Not that much in it.
-- Records are slightly more convenient for retrieving fields by name
-- ADTs need slightly less typing, and you could explicitly enforce types
-- rather than just using strings like I did.

-- > address = { street = "Cowley rd." \
-- |           , town   = "Oxford" \
-- |           , county = "Oxon." \
-- |           , pc     = "OX4 1DN" }
-- { county = "Oxon.", pc = "OX4 1DN", street = "Cowley rd.", town = "Oxford" }
--  : {county : String, pc : String, street : String, town : String}
-- > person = { name = "Edward Normalhands" \
-- |          , age  = 28 \
-- |          , address = address }
-- { address = { county = "Oxon.", pc = "OX4 1DN", street = "Cowley rd.", town = "Oxford" }, age = 28, name = "Edward Normalhands" }
--  : {address : {county : String, pc : String, street : String, town : String}, age : number, name : String}



