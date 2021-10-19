import model/pieces

proc createPawns(): seq[Pawn] =
  let wPawn1 = Pawn(symbol: 'P', color: White, xPos: 0, yPos: 1)
  let wPawn2 = Pawn(symbol: 'P', color: White, xPos: 1, yPos: 1)
  let wPawn3 = Pawn(symbol: 'P', color: White, xPos: 2, yPos: 1)
  let wPawn4 = Pawn(symbol: 'P', color: White, xPos: 3, yPos: 1)
  let wPawn5 = Pawn(symbol: 'P', color: White, xPos: 4, yPos: 1)
  let wPawn6 = Pawn(symbol: 'P', color: White, xPos: 5, yPos: 1)
  let wPawn7 = Pawn(symbol: 'P', color: White, xPos: 6, yPos: 1)
  let wPawn8 = Pawn(symbol: 'P', color: White, xPos: 7, yPos: 1)

  let bPawn1 = Pawn(symbol: 'P', color: Black, xPos: 0, yPos: 6)
  let bPawn2 = Pawn(symbol: 'P', color: Black, xPos: 1, yPos: 6)
  let bPawn3 = Pawn(symbol: 'P', color: Black, xPos: 2, yPos: 6)
  let bPawn4 = Pawn(symbol: 'P', color: Black, xPos: 3, yPos: 6)
  let bPawn5 = Pawn(symbol: 'P', color: Black, xPos: 4, yPos: 6)
  let bPawn6 = Pawn(symbol: 'P', color: Black, xPos: 5, yPos: 6)
  let bPawn7 = Pawn(symbol: 'P', color: Black, xPos: 6, yPos: 6)
  let bPawn8 = Pawn(symbol: 'P', color: Black, xPos: 7, yPos: 6)

  result = @[wPawn1, wPawn2, wPawn3, wPawn4, wPawn5, wPawn6, wPawn7, wPawn8,
      bPawn1, bPawn2, bPawn3, bPawn4, bPawn5, bPawn6, bPawn7, bPawn8]

proc createBishops(): seq[Bishop] =
  let wBishop1 = Bishop(symbol: 'B', color: White, xPos: 2, yPos: 0)
  let wBishop2 = Bishop(symbol: 'B', color: White, xPos: 5, yPos: 0)

  let bBishop1 = Bishop(symbol: 'B', color: Black, xPos: 2, yPos: 7)
  let bBishop2 = Bishop(symbol: 'B', color: Black, xPos: 5, yPos: 7)

  result = @[wBishop1, wBishop2, bBishop1, bBishop2]

proc createKnights(): seq[Knight] =
  let wKnight1 = Knight(symbol: 'N', color: White, xPos: 1, yPos: 0)
  let wKnight2 = Knight(symbol: 'N', color: White, xPos: 6, yPos: 0)

  let bKnight1 = Knight(symbol: 'N', color: Black, xPos: 1, yPos: 7)
  let bKnight2 = Knight(symbol: 'N', color: Black, xPos: 6, yPos: 7)

  result = @[wKnight1, wKnight2, bKnight1, bKnight2]

proc createRooks(): seq[Rook] =
  let wRook1 = Rook(symbol: 'R', color: White, xPos: 0, yPos: 0)
  let wRook2 = Rook(symbol: 'R', color: White, xPos: 7, yPos: 0)

  let bRook1 = Rook(symbol: 'R', color: Black, xPos: 0, yPos: 7)
  let bRook2 = Rook(symbol: 'R', color: Black, xPos: 7, yPos: 7)

  result = @[wRook1, wRook2, bRook1, bRook2]

proc createQueens(): seq[Queen] =
  let wQueen = Queen(symbol: 'Q', color: White, xPos: 3, yPos: 0)
  let bQueen = Queen(symbol: 'Q', color: Black, xPos: 3, yPos: 7)
  result = @[wQueen, bQueen]

proc createKings(): seq[King] =
  let wKing = King(symbol: 'K', color: White, xPos: 4, yPos: 0)
  let bKing = King(symbol: 'K', color: Black, xPos: 4, yPos: 7)
  result = @[wKing, bKing]

proc createFreeTiles(): seq[FreeTile] =
  for i in 2..5:
    for j in 0..7:
      result.add(FreeTile(symbol: ' ', xPos: j, yPos: i))

proc createAllPieces*(): seq[Piece] =
  for pawn in createPawns():
    result.add(pawn)
  for bishop in createBishops():
    result.add(bishop)
  for knight in createKnights():
    result.add(knight)
  for rook in createRooks():
    result.add(rook)
  for queen in createQueens():
    result.add(queen)
  for king in createKings():
    result.add(king)
  for freetile in createFreeTiles():
    result.add(freetile)
