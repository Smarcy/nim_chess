type
  Color* = enum
    White, Black

  Piece* = ref object of RootObj
    ## Base class of every piece on the board
    symbol*: char
    color*: Color
    xPos*: int
    yPos*: int

  Pawn* = ref object of Piece
  Bishop* = ref object of Piece
  Knight* = ref object of Piece
  Rook* = ref object of Piece
  Queen* = ref object of Piece
  King* = ref object of Piece
  FreeTile* = ref object of Piece
