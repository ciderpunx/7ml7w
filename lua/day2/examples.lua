-- just examples from the text

-- table constructor
-- nb - allows the trailing comma perl-stylee
book = {
  title  = "grail diary",
  author = "henry jones",
  pages  = 100,
}

--book.stars  = 5 -- new item in book table
--book.author = "Someone Else" -- overwrite orig. value
--book.pages  = nil -- delete an item

medals = { "gold"
         , "silver"
         , "bronze"
         }

-- medals[4] = lead
-- NB: 1 based indexing. yuk.

ice_creams = { "vanilla"
             , "choco"
             , "strawb"
             ;          -- convention when switching between arraylike
                        -- and hashike table data
             sprinkles = true
             , vegan = true
             }

dofile("util.lua")
greek_nums = { ena  = "one"
             , dyo  = "two"
             , tria = "three"
             }

mt = { __tostring = table_to_string}

setmetatable(greek_nums,mt)

-- =greek_nums

-- Doing OO works thus. 
dietrich = { name   = "D"
           , health = 100
           , take_hit = function(self)
                          self.health = self.health - 10
                        end
           }

-- NB have explicitly to set self here
dietrich.take_hit(dietrich)
print("D health (expect 90): " .. dietrich.health)

-- cloning can be done in an ugly way
clone = { name   = dietrich.name
        , health = dietrich.health
        , take_hit = dietrich.take_hit
        }

-- but nicer to:
Villain = { health = 100
          , new = function(self,name)
                    local obj = { name   = name
                                , health = self.health
                                }
                    setmetatable(obj, self) -- delegate field lookup to Villain prototype
                    self.__index = self
                    return obj
                  end
          , take_hit = function(self)
                         self.health = self.health - 10
                       end
          }

newdietrich = Villain.new(Villain, "Dietrich")
print("ND health (expect 100): " .. newdietrich.health)

-- inheritence
SuperVillain = Villain.new(Villain)

-- overriding methods is just:
function SuperVillain.take_hit(self)
  self.health = self.health - 5
end

toht = SuperVillain.new(SuperVillain, "Toht")
toht.take_hit(toht)
print("Toht health (expect 95): " .. toht.health)

-- We can leave out the self parameter by using the tbl:method() notation
d3 = Villain:new("baddie")
d3:take_hit()
print("Baddie health (expect 90): " .. d3.health)

-- Coroutines

function fibonacci()
  local m = 1
  local n = 1

  while true do
    coroutine.yield(m)
    m, n = n, m + n
  end
end

generator = coroutine.create(fibonacci)
succeeded, val = coroutine.resume(generator)
print ("Val of first fib (expect 1): " .. val)
succeeded, val = coroutine.resume(generator)
print ("Val of second fib (expect 1): " .. val)
succeeded, val = coroutine.resume(generator)
print ("Val of third fib (expect 2): " .. val)
succeeded, val = coroutine.resume(generator)
print ("Val of fourth fib (expect 3): " .. val)
