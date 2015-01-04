-- pl.pretty is a nice pretty printing library used to make tables printable
-- also I can say dumper.dump(tbl) when debugging
dumper = require "pl.pretty"

function concatenate (a1, a2)
  for i=1,#a2 do
    a1[#a1+i] = a2[i]
  end
  return a1
end


-- Change the global metatable you discovered in the Find section earlier so that any time you try to add 2 arrays using the plus sign (eg. a1+a2), Lua concatenates them together using your concatenate function

-- I take the approach of overriding the newindex metamethod in the global
-- metatable, _G. Not entirely happy with this as it feels kind of kludgey
-- having to hop in, look at the value and if it is a table override. It 
-- also won't work for locally scoped tables. I also overrode the tostring 
-- which helped with debugging
function newindex (t, k, v)
  rawset(t,k,v)
  if type(v) == "table" then
    -- print "setting mt"
    setmetatable(t[k]
                , { __add = concatenate
                  , __tostring = dumper.write
                  }
                )
  end
end

setmetatable(_G,{__newindex=newindex})
