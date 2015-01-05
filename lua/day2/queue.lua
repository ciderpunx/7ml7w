-- Using Lua's built-in OO syntax, write a class called Queue that impements a FIFO queue as follows:
-- * q=Queue.new() returns a new object
-- * q:add(item) adds item past the last one currently in the queue
-- * q:remove() removes and returns the first item in the queue or nill if it is empty

dumper = require "pl.pretty"

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
