defmodule Medium do
  import Keyword
  # Given a list of numbers use recursion to find:
  # size of list

  def csize([]), do: 0
  def csize([_|t]), do: 1+csize(t)

  # max value
  def cmax(xs), do: cmax(xs,hd xs)
  def cmax([],n), do: n
  def cmax([h|t],n) do
    if(h>n) do cmax(t,h) else cmax(t,n) end
  end

  # min value
  def cmin(xs), do: cmin(xs, hd xs)
  def cmin([],n), do: n
  def cmin([h|t],n) do
    if(h<n) do cmin(t,h) else cmin(t,n) end
  end

  # given a list of atoms build a fn word_count that returns a 
  # keyword list where keys are atoms from the list
  # vals are count of occurences
  def word_count(xs) do
    Enum.reduce(xs, [], &(put(&2, &1, 1 + get(&2,&1,0))))
  end

end

testList = [2,1,3,4,9]
IO.inspect Medium.csize(testList)
IO.inspect Medium.cmax(testList)
IO.inspect Medium.cmin(testList)

atomList = [:one, :two, :two] 
IO.inspect Medium.word_count(atomList)



