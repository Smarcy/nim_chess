type
  Color* {.pure.} = enum
    White, Black, None

  Piece* = ref object of RootObj
    ## Base class of every piece on the board
    symbol* {.requiresinit.}: char
    color* {.requiresinit.}: Color
    xPos* {.requiresinit.}: int
    yPos* {.requiresinit.}: int

  FreeTile* = ref object of Piece
  Pawn* = ref object of Piece
  Bishop* = ref object of Piece
  Knight* = ref object of Piece
  Rook* = ref object of Piece
    canCastle*: bool
  Queen* = ref object of Piece
  King* = ref object of Piece
    canCastle*: bool

proc newPiece*(color: Color, xPos, yPos: int, symbol: char = 'X'): Piece =
  Piece(symbol: symbol, color: color, xPos: xPos, yPos: yPos)

proc newPawn*(color: Color, xPos, yPos: int, symbol: char = 'P'): Pawn =
  Pawn(symbol: symbol, color: color, xPos: xPos, yPos: yPos)

proc newKnight*(color: Color, xPos, yPos: int, symbol: char = 'N'): Knight =
  Knight(symbol: symbol, color: color, xPos: xPos, yPos: yPos)

proc newBishop*(color: Color, xPos, yPos: int, symbol: char = 'B'): Bishop =
  Bishop(symbol: symbol, color: color, xPos: xPos, yPos: yPos)

proc newRook*(color: Color, xPos, yPos: int, canCastle: bool = true,
    symbol: char = 'R'): Rook =
  Rook(symbol: symbol, color: color, xPos: xPos, yPos: yPos,
      canCastle: canCastle)

proc newQueen*(color: Color, xPos, yPos: int, symbol: char = 'Q'): Queen =
  Queen(symbol: symbol, color: color, xPos: xPos, yPos: yPos)

proc newKing*(color: Color, xPos, yPos: int, canCastle: bool = true,
    symbol: char = 'K'): King =
  King(symbol: symbol, color: color, xPos: xPos, yPos: yPos,
      canCastle: canCastle)

proc newFreeTile*(color: Color, xPos, yPos: int, symbol: char = ' '): FreeTile =
  FreeTile(symbol: symbol, color: color, xPos: xPos, yPos: yPos)

proc `$`*(this: Piece): string =
  ##[ Pretty Print Piece Data (+ canCastle-field if King or Rook) ]##
  result = "S: " & this.symbol & "\nX: " & $this.xPos & "\nY: " & $this.yPos &
      "\nC: " & $this.color
  if this of King:
    var k = (King)this
    result.add("\ncanCastle: " & $k.canCastle)
  if this of Rook:
    var r = (Rook)this
    result.add("\ncanCastle: " & $r.canCastle)
