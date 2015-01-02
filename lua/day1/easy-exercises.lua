-- Write a function called ends_in_3(num) that returns true if the final
-- digit of num is 3, false otherwise
--
-- Interesting bug: works for small numbers, but when they get large this will 
-- not work as expected unless passed a string. Because numbers are stored with 
-- 'e' notation:
-- > return ends_in_3("2123323213213213213123")
-- true
-- But:
-- > return ends_in_3(2123323213213213213123)
-- false
-- Because:
-- > =2123323213213213213123
-- 2.1233232132132e+21
function ends_in_3(num)
  l = string.len(tostring(num))
  return string.sub(num,l,l) == "3"
end

-- Write a function called is_prime(num) to test if a number is prime
--
-- Don't do anything clever like pre-calcuating primes and doing a lookup
-- Just the simplest thing that could possibly work
function is_prime (n)
  for i=2, n^(1/2) do
    if ( n % i == 0) then
      return false
    end
  end
  return true
end

-- Create a program to print the first n prime numbers that end in 3
--
-- Again this is a naive approach. Could probably get better performance with 
-- some sort of sieve. But it works well for a few thousand primes and I am not
-- inclined to implement something too complex for the medium exercises.
function first_n_primes_ending_in_3 (n)
  primes = {}
  i=0
  while(#primes<n) do
    i=i+1
    if(is_prime(i) and ends_in_3(i)) then
      primes[#primes+1]=i
    end
  end
  return primes
end
