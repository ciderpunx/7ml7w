-- Using coroutines, write a fault tolerant function retry(count, body) that works as follows
-- * call the body function
-- * if body yields a string with coroutine.yield(), consider this an error message and restart body from the beginning
-- * Don't retry more than count times; if you exceed count, print an error message and return
-- * If body returns without yielding a string, consider this a success.
local debug=false

function retry(count, body)
  local tries = 0
  for i=1, count do
    tries = i
    _,res = coroutine.resume(coroutine.create(body))
    if type(res) ~= "string" then
      break
    else
      if(debug) then print("Err: " .. res) end
    end
  end
  if(tries>=count) then 
    if(debug) then print("Failure after " .. tries .. " attempts") end
    return
  end
  if(debug) then print("Succeeded after " .. tries .. " attempts") end
end

retry( 5
     ,  function()
          if math.random()>0.2 then
            coroutine.yield("something bad happened")
          end
          print "Success!"
        end
     )
