type
  Color* = enum
    White, Black, None

  Piece* = ref object of RootObj
    ## Base class of every piece on the board
    symbol* {.requiresinit.}: char
    color* {.requiresinit.}: Color
    xPos* {.requiresinit.}: int
    yPos* {.requiresinit.}: int

  Pawn* = ref object of Piece
  Bishop* = ref object of Piece
  Knight* = ref object of Piece
  Rook* = ref object of Piece
  Queen* = ref object of Piece
  King* = ref object of Piece
  FreeTile* = ref object of Piece

proc newPawn(symbol: char, color: Color, xPos, yPos: int): Pawn =
  Pawn(symbol: symbol, color: color, xPos: xPos, yPos: yPos)

proc newFreeTile*(symbol: char, color: Color, xPos, yPos: int): FreeTile =
  FreeTile(symbol: symbol, color: color, xPos: xPos, yPos: yPos)
