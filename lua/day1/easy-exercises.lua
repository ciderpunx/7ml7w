function ends_in_3(str)
  sl = string.len(str)
  return string.sub(str,sl,sl)
end

function isPrime (n)
  for i=2, n^(1/2) do
    if ( n % i == 0) then
      return false
    end
  end
  return true
end
