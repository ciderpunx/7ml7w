defmodule Shapes do
  import :math

  point  = {1,9}          # x,y coords
  line   = {{1,1}, point} # 2 points in cartesian space
  circle = {{6,6}, 5}     # centre point, radius
  ngon   = {line, {point, {15,9}}, {{15,9}, {15,1}}, {{15,1},{1,1}}}
                          # lines between vertices
  triang = {line, {point,{15,1}}, {{15,1},{1,1}}} # lines between vertices

  # Function to "compute the hypotenuse" of a right angled triangle
  # given the length of 2 sides
  # By "compute the hypotenuse" I assume "compute the length of the hypotenuse"
  # I also assume that neither of the 2 given sides *are* the hypotenuse

  # First implement square 
  def sq(x) do
    x*x
  end

  # We can use the :math version of sqrt and our own sq to work out
  # the square root of the sum of the squares of the two non-hypotenuse sides
  # Which is the length of the hypotenuse.
  def hypo(a,b) do
    sqrt(sq(a) + sq(b))
  end

end

IO.inspect Shapes.hypo(3,4)

# Convert string to atom
IO.inspect String.to_atom("HalloElixir")

# test to see if it is an atom
IO.inspect is_atom(String.to_atom("HalloElixir"))
