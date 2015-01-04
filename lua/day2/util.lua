function print_table(t)
  for k,v in pairs(t) do
    -- pairs is an iterator for for loops -- returns a new function which for calls 
    -- repeatedly until it returns nil
    print(k .. ":\t" .. v) -- .. is concatenation
  end
end

function table_to_string(t)
  local res = {}
  for k,v in pairs(t) do
    res[#res+1] = k .. ":\t" .. v
  end
  return table.concat(res,"\n")
end
