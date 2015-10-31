defmodule EasyExercises do
  # The text already describes how to crash a server by sending a message to it that it does not understand -- with supervisor you can just recover without one, you have to go back to the start

  def glove do
    receive do
      {:pitch, pitcher} -> send pitcher, {:catch, self()}
    after
      2000 -> IO.puts "Oh crap. Went to sleep."
    end
  end

end

