local _private = {}

function strict_read (t,k)
  if _private[k] then
    return _private[k]
  else
    error("Invalid key: " .. k)
  end
end

function strict_write (t,k,v)
  if _private[k] and v ~= nil then
    error("Duplicate key: " .. k)
  else
    _private[k] = v
  end
end

local mt = { __index    = strict_read
           , __newindex = strict_write
           }

treasure = {}
setmetatable(treasure,mt)

print "Setting gold to 50, expect 50"
treasure.gold = 50
print (treasure.gold)

--print "Try to access silver, expect invalid key err"
--print (treasure.silver)
--print "Try to overwrite gold, expect duplicate key err"
--treasure.gold = 150
