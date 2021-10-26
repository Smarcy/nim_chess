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

proc newPiece*(symbol: char, color: Color, xPos, yPos: int): Piece =
  Piece(symbol: symbol, color: color, xPos: xPos, yPos: yPos)

proc newPawn*(symbol: char, color: Color, xPos, yPos: int): Pawn =
  Pawn(symbol: symbol, color: color, xPos: xPos, yPos: yPos)

proc newKnight*(symbol: char, color: Color, xPos, yPos: int): Knight =
  Knight(symbol: symbol, color: color, xPos: xPos, yPos: yPos)

proc newBishop*(symbol: char, color: Color, xPos, yPos: int): Bishop =
  Bishop(symbol: symbol, color: color, xPos: xPos, yPos: yPos)

proc newRook*(symbol: char, color: Color, xPos, yPos: int): Rook =
  Rook(symbol: symbol, color: color, xPos: xPos, yPos: yPos)

proc newQueen*(symbol: char, color: Color, xPos, yPos: int): Queen =
  Queen(symbol: symbol, color: color, xPos: xPos, yPos: yPos)

proc newKing*(symbol: char, color: Color, xPos, yPos: int): King =
  King(symbol: symbol, color: color, xPos: xPos, yPos: yPos)

proc newFreeTile*(symbol: char, color: Color, xPos, yPos: int): FreeTile =
  FreeTile(symbol: symbol, color: color, xPos: xPos, yPos: yPos)
