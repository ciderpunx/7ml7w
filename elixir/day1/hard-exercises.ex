defmodule SentenceTree do
  # Note that this only works for 2-tuples, which I am assuming was 
  # what was intended.
  # Note also that we print things rather than constructing a list
  # which is a bit impure. Whatever.

  def traverse(st) do
    t(0, st)
  end

  def indent(n,x) do
    if is_tuple x do
      t(n+1, x)
    else
      IO.puts String.duplicate("    ",n) <> x
    end
  end

  def t(n, {x,y}) do
    indent(n,x)
    indent(n,y)
  end

end

stup = {"See Spot.", {"See Spot sit.", {"See spot run.", "See spot code."}}}
SentenceTree.traverse(stup)

defmodule NoughtsAndCrosses do
  import Enum
  import List
  # check if there is a horizontal, vertical or diagonal line
  # for player p
  def winner?(p,[a,b,c,d,e,f,g,h,i]) do
    any?([ {a,b,c}, {d,e,f}, {g,h,i}, {a,d,g} \
           , {b,e,h}, {c,f,i}, {a,e,i}, {c,e,g} ] \
           , fn(x)->x=={p,p,p} end)
  end

  def fst ({x,_}) do
    x
  end
  def snd ({_,y}) do
    y
  end
  def other_player(p) do
    cond do
      p=="O" -> "X"
        true -> "O"
    end
  end

  # given an opponent flag, a player p and a board, look for any nearly complete
  # lines of that player. 
  # If opponent is true, then complete the line with the symbol of the 
  # opposite player of p (for O,X and vice versa)
  # Otherwise complete the line with p's symbol
  # Teturn a modified board
  def two_lines(opponent,p,[a,b,c,d,e,f,g,h,i]) do
    danger = [ {{a,b},2}, {{b,c},0}, {{d,e},5}, {{e,f},3}, {{g,h},9}, {{h,i},7} \
             , {{a,c},1}, {{d,f},4}, {{g,i},8} \
             , {{a,d},7}, {{d,g},0}, {{b,e},8}, {{e,h},1}, {{c,f},9}, {{f,i},2} \
             , {{a,g},3}, {{b,h},4}, {{c,i},5} \
             , {{a,e},9}, {{e,i},0}, {{c,e},7}, {{e,g},2}, {{g,c},4}, {{a,i},4} ]
    match  = find(danger, false, &(fst(&1) == {p,p}))
    cond do
      match == nil 
               -> [a,b,c,d,e,f,g,h,i]
      opponent -> replace_at([a,b,c,d,e,f,g,h,i], snd(match), other_player(p))
          true -> replace_at([a,b,c,d,e,f,g,h,i], snd(match), p)
    end
  end

  # is the centre available
  def centre_free([_,_,_,_,c,_,_,_,_]) do
    c==' '
  end

  def try_own_twos do
    fn(player,board) -> two_lines(false,player,board) end
  end

  def try_opponent_twos do
    fn(player,board) -> two_lines(true,player,board) end
  end

  # Go in the centre square
  def try_centre do
    fn(player,board) ->
      if(centre_free(board)) do
        replace_at(board,4,player)
      else
        board
      end
    end
  end

  # take the first empty square
  def try_crappy_move do
    fn(player,board) -> replace_at(board,find_index(board, &(&1==' ')),player) end
  end

  def show_result(player,board) do
    oppo = other_player(player)
    cond do
      winner?(player, board) -> IO.puts(player <> " Wins!")
      winner?(oppo, board)   -> IO.puts(other_player(player) <> " Wins!")
                        true -> IO.puts("A strange game. The only winning move is not to play. How about a nice game of chess?")
    end
  end

  def board_complete?(board) do
    not any?(board, &(&1==' '))
  end

  def next_move(player, board) do
    if board_complete?(board) do
      show_result(player, board)
      board
    else
        strategies = 
          [try_own_twos, try_opponent_twos, try_centre, try_crappy_move]
        find(map(strategies, &(&1.(player,board))), nil, &(&1!=board))
    end
  end
end

testBoard = [ 'X', ' ', 'X' \
            , 'O', ' ', 'X' \
            , 'X', 'O', 'O' ]

IO.inspect NoughtsAndCrosses.winner?('X',testBoard)
IO.inspect NoughtsAndCrosses.next_move('X',testBoard)
