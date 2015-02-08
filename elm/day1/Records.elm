data Colour = Black | White
data Piece  = Prawn | Horsey | Bish | Tower | LadyKing | SpikeyHeadMan

blackQueen = { colour=Black, piece=LadyKing }

bqColour = blackQueen.colour -- same as .colour blackQueen
bqPiece  = blackQueen.piece

whiteQueen = { blackQueen | colour <- White }
position   = { column = "d", row = 1 }

homeWhiteQueen = { whiteQueen | position = position }
