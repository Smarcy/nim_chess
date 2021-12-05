import ../model/pieces

proc createPawns(): seq[Pawn] =

  var wPawn1 = newPawn(White, 0, 6)
  var wPawn2 = newPawn(White, 1, 6)
  var wPawn3 = newPawn(White, 2, 6)
  var wPawn4 = newPawn(White, 3, 6)
  var wPawn5 = newPawn(White, 4, 6)
  var wPawn6 = newPawn(White, 5, 6)
  var wPawn7 = newPawn(White, 6, 6)
  var wPawn8 = newPawn(White, 7, 6)

  var bPawn1 = newPawn(Black, 0, 1)
  var bPawn2 = newPawn(Black, 1, 1)
  var bPawn3 = newPawn(Black, 2, 1)
  var bPawn4 = newPawn(Black, 3, 1)
  var bPawn5 = newPawn(Black, 4, 1)
  var bPawn6 = newPawn(Black, 5, 1)
  var bPawn7 = newPawn(Black, 6, 1)
  var bPawn8 = newPawn(Black, 7, 1)

  result = @[wPawn1, wPawn2, wPawn3, wPawn4, wPawn5, wPawn6, wPawn7, wPawn8,
      bPawn1, bPawn2, bPawn3, bPawn4, bPawn5, bPawn6, bPawn7, bPawn8]

proc createBishops(): seq[Bishop] =
  var wBishop1 = newBishop(White, 2, 7)
  var wBishop2 = newBishop(White, 5, 7)

  var bBishop1 = newBishop(Black, 2, 0)
  var bBishop2 = newBishop(Black, 5, 0)

  result = @[wBishop1, wBishop2, bBishop1, bBishop2]

proc createKnights(): seq[Knight] =
  var wKnight1 = newKnight(White, 1, 7)
  var wKnight2 = newKnight(White, 6, 7)

  var bKnight1 = newKnight(Black, 1, 0)
  var bKnight2 = newKnight(Black, 6, 0)

  result = @[wKnight1, wKnight2, bKnight1, bKnight2]

proc createRooks(): seq[Rook] =
  var wRook1 = newRook(White, 0, 7)
  var wRook2 = newRook(White, 7, 7)

  var bRook1 = newRook(Black, 0, 0)
  var bRook2 = newRook(Black, 7, 0)

  result = @[wRook1, wRook2, bRook1, bRook2]

proc createQueens(): seq[Queen] =
  var wQueen = newQueen(White, 3, 7)
  var bQueen = newQueen(Black, 3, 0)
  result = @[wQueen, bQueen]

proc createKings(): seq[King] =
  var wKing = newKing(White, 4, 7)
  var bKing = newKing(Black, 4, 0)
  result = @[wKing, bKing]

proc createFreeTiles(): seq[FreeTile] =
  for i in 2..5:
    for j in 0..7:
      result.add(newFreeTile(None, j, i))

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
