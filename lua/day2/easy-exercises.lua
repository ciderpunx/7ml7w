-- write a function called concatenate(a1,a2) that takes 2 arrays and returns a new array with all the elements of a1 followed by all the elements of a2.
function concatenate (a1, a2)
  for i=1,#a2 do
    a1[#a1+i] = a2[i]
  end
  return a1
end

-- Our strict table implementation in Reading and Writing on p19 doesn't provide a good way to delete items from the table. If we try the usual approach treasure.gole = nil, we get a duplicate key error. Modify strict_write to allow deleting keys (by setting their values to nil)
-- I just changed the if condition in the strict_write implementation (see strict.lua)
-- was 
--  if _private[k] then
-- now:
--  if _private[k] and v ~= nil then
