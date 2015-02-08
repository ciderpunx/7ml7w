-- ADTs are similar to Haskell or ML, though more Haskelly in syntax

data Colour = Black | White
data Piece  = Prawn | Horsey | Bish | Tower | LadyKing | SpikeyHeadMan
data ChessPiece = CP Colour Piece

pieceBQ = CP Black LadyKing
