import model/pieces

proc createPawns(): seq[Pawn] =
  let wPawn1 = newPawn('P', White, 0, 6)
  let wPawn2 = newPawn('P', White, 1, 6)
  let wPawn3 = newPawn('P', White, 2, 6)
  let wPawn4 = newPawn('P', White, 3, 6)
  let wPawn5 = newPawn('P', White, 4, 6)
  let wPawn6 = newPawn('P', White, 5, 6)
  let wPawn7 = newPawn('P', White, 6, 6)
  let wPawn8 = newPawn('P', White, 7, 6)

  let bPawn1 = newPawn('P', Black, 0, 1)
  let bPawn2 = newPawn('P', Black, 1, 1)
  let bPawn3 = newPawn('P', Black, 2, 1)
  let bPawn4 = newPawn('P', Black, 3, 1)
  let bPawn5 = newPawn('P', Black, 4, 1)
  let bPawn6 = newPawn('P', Black, 5, 1)
  let bPawn7 = newPawn('P', Black, 6, 1)
  let bPawn8 = newPawn('P', Black, 7, 1)

  result = @[wPawn1, wPawn2, wPawn3, wPawn4, wPawn5, wPawn6, wPawn7, wPawn8,
      bPawn1, bPawn2, bPawn3, bPawn4, bPawn5, bPawn6, bPawn7, bPawn8]

proc createBishops(): seq[Bishop] =
  let wBishop1 = newBishop('B', White, 2, 7)
  let wBishop2 = newBishop('B', White, 5, 7)

  let bBishop1 = newBishop('B', Black, 2, 0)
  let bBishop2 = newBishop('B', Black, 5, 0)

  result = @[wBishop1, wBishop2, bBishop1, bBishop2]

proc createKnights(): seq[Knight] =
  let wKnight1 = newKnight('N', White, 1, 7)
  let wKnight2 = newKnight('N', White, 6, 7)

  let bKnight1 = newKnight('N', Black, 1, 0)
  let bKnight2 = newKnight('N', Black, 6, 0)

  result = @[wKnight1, wKnight2, bKnight1, bKnight2]

proc createRooks(): seq[Rook] =
  let wRook1 = newRook('R', White, 0, 7)
  let wRook2 = newRook('R', White, 7, 7)

  let bRook1 = newRook('R', Black, 0, 0)
  let bRook2 = newRook('R', Black, 7, 0)

  result = @[wRook1, wRook2, bRook1, bRook2]

proc createQueens(): seq[Queen] =
  let wQueen = newQueen('Q', White, 3, 7)
  let bQueen = newQueen('Q', Black, 3, 0)
  result = @[wQueen, bQueen]

proc createKings(): seq[King] =
  let wKing = newKing('K', White, 4, 7)
  let bKing = newKing('K', Black, 4, 0)
  result = @[wKing, bKing]

proc createFreeTiles(): seq[FreeTile] =
  for i in 2..5:
    for j in 0..7:
      result.add(newFreeTile(' ', None, j, i))

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
