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

-- Using Lua's built-in OO syntax, write a class called Queue that impements a FIFO queue as follows:
-- * q=Queue.new() returns a new object
-- * q:add(item) adds item past the last one currently in the queue
-- * q:remove() removes and returns the first item in the queue or nill if it is empty
Queue = { _q = {} }

function Queue:new()
  local obj = {  }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Queue:add(item)
  if item == nil then
    error "Can't add nil item to queue"
  end
  self._q[#self._q+1] = item
end

function Queue:remove()
  if #self._q<1 then
    return nil
  else
    fst = self._q[1]
    for i=1,#self._q - 1 do
      self._q[i] = self._q[i+1]
    end
    self._q[#self._q] = nil
    return fst
  end
end

function Queue:show()
  dumper.dump(self._q)
end
