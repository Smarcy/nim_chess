import unittest
import ../src/nim_chess/model/board
import ../src/nim_chess/model/pieces

test "pawn single step":
  var
    b = populateBoard()

  let
    p = b.board[1][0]
    input = @["a7", "a6"]

  check(p.yPos == 1)
  check(move(input, b, Black)) # == true
  check(p.yPos == 2)

test "white bishop NW/SE single step dist=1":
  var
    b = populateBoard()

  let
    p = b.board[6][4] # pawn
    bishop = b.board[7][5]
    input = @["e2", "e3", "f1", "e2", "e2", "f1"]

  check(p.yPos == 6)
  check(bishop.yPos == 7)
  check(bishop.xPos == 5)
  check(move(@[input[0], input[1]], b, White))
  check(p.yPos == 5)
  check(move(@[input[2], input[3]], b, White)) # NW step
  check(bishop.yPos == 6)
  check(bishop.xPos == 4)
  check(b.board[6][4] == bishop)
  check(b.board[7][5] of FreeTile)

  check(move(@[input[4], input[5]], b, White)) # SE step
  check(bishop.yPos == 7)
  check(bishop.xPos == 5)
  check(b.board[7][5] == bishop)
  check(b.board[6][4] of FreeTile)

test "white bishop NE/SW single step dist=1":
  var
    b = populateBoard()

  let
    p = b.board[6][6] # pawn
    bishop = b.board[7][5]
    input = @["g2", "g3", "f1", "g2", "g2", "f1"]

  check(p.yPos == 6)
  check(bishop.yPos == 7)
  check(bishop.xPos == 5)
  check(move(@[input[0], input[1]], b, White))
  check(p.yPos == 5)
  check(move(@[input[2], input[3]], b, White)) # NE step
  check(bishop.yPos == 6)
  check(bishop.xPos == 6)
  check(b.board[6][6] == bishop)
  check(b.board[7][5] of FreeTile)

  check(move(@[input[4], input[5]], b, White)) # SW step
  check(bishop.yPos == 7)
  check(bishop.xPos == 5)
  check(b.board[7][5] == bishop)
  check(b.board[6][6] of FreeTile)

test "black bishop SE/NW single step dist=1":
  var
    b = populateBoard()

  let
    p = b.board[1][6] # pawn
    bishop = b.board[0][5]
    input = @["g7", "g6", "f8", "g7", "g7", "f8"]

  check(p.yPos == 1)
  check(bishop.yPos == 0)
  check(bishop.xPos == 5)
  check(move(@[input[0], input[1]], b, Black))
  check(p.yPos == 2)
  check(move(@[input[2], input[3]], b, Black)) # SE step
  check(bishop.yPos == 1)
  check(bishop.xPos == 6)
  check(b.board[1][6] == bishop)
  check(b.board[0][5] of FreeTile)
  check(move(@[input[4], input[5]], b, Black)) # NW step
  check(bishop.yPos == 0)
  check(bishop.xPos == 5)
  check(b.board[0][5] == bishop)
  check(b.board[1][6] of FreeTile)

test "black bishop SW/NE single step dist=1":
  var
    b = populateBoard()

  let
    p = b.board[1][4] # pawn
    bishop = b.board[0][5]
    input = @["e7", "e6", "f8", "e7", "e7", "f8"]

  check(p.yPos == 1)
  check(bishop.yPos == 0)
  check(bishop.xPos == 5)
  check(move(@[input[0], input[1]], b, Black))
  check(p.yPos == 2)
  check(move(@[input[2], input[3]], b, Black)) # SW step
  check(bishop.yPos == 1)
  check(bishop.xPos == 4)
  check(b.board[1][4] == bishop)
  check(b.board[0][5] of FreeTile)
  check(move(@[input[4], input[5]], b, Black)) # NE step
  check(bishop.yPos == 0)
  check(bishop.xPos == 5)
  check(b.board[0][5] == bishop)
  check(b.board[1][4] of FreeTile)

test "white knight all directions in one test":
  var
    b = populateBoard()

  let
    knight = b.board[7][1]
    input = @["b1", "c3",
              "c3", "b5",
              "b5", "d6",
              "d6", "f5",
              "f5", "g3",
              "f5", "e3",
              "e3", "c4",
              "c4", "a3"]

  check(b.board[7][1] == knight)
  check(move(@[input[0], input[1]], b, White)) # NE
  check(knight.xPos == 2)
  check(knight.yPos == 5)
  check(b.board[5][2] == knight)
  check(b.board[7][1] of FreeTile)
  check(move(@[input[2], input[3]], b, White)) # NW
  check(b.board[3][1] == knight)
  check(b.board[5][2] of FreeTile)
  check(move(@[input[4], input[5]], b, White)) # EN
  check(b.board[2][3] == knight)
  check(b.board[3][1] of FreeTile)
  check(move(@[input[6], input[7]], b, White)) # ES
  check(b.board[3][5] == knight)
  check(b.board[2][3] of FreeTile)
  check(move(@[input[8], input[9]], b, White)) # SE
  check(b.board[5][6] == knight)
  check(b.board[3][5] of FreeTile)
  check(move(@["g3", "f5"], b, White)) # Take Knight back to test SW dir (NW)
  check(move(@[input[10], input[11]], b, White)) # SW
  check(b.board[5][4] == knight)
  check(b.board[3][5] of FreeTile)
  check(move(@[input[12], input[13]], b, White)) # WN
  check(b.board[4][2] == knight)
  check(b.board[5][4] of FreeTile)
  check(move(@[input[14], input[15]], b, White)) # WS
  check(b.board[5][0] == knight)
  check(b.board[4][2] of FreeTile)

test "black knight all directions in one test":
  var
    b = populateBoard()

  let
    knight = b.board[0][6]
    input = @["g8", "h6",
              "h6", "g4",
              "g4", "e3",
              "e3", "c4",
              "c4", "e3",
              "e3", "g4",
              "g4", "h6",
              "h6", "g8"]

  check(b.board[0][6] == knight)
  check(move(@[input[0], input[1]], b, Black)) # NE
  check(knight.xPos == 7)
  check(knight.yPos == 2)
  check(b.board[2][7] == knight)
  check(b.board[0][6] of FreeTile)
  check(move(@[input[2], input[3]], b, Black)) # SW
  check(knight.xPos == 6)
  check(knight.yPos == 4)
  check(b.board[4][6] == knight)
  check(b.board[0][6] of FreeTile)
  check(move(@[input[4], input[5]], b, Black)) # WS
  check(knight.xPos == 4)
  check(knight.yPos == 5)
  check(b.board[5][4] == knight)
  check(b.board[2][7] of FreeTile)
  check(move(@[input[6], input[7]], b, Black)) # WN
  check(knight.xPos == 2)
  check(knight.yPos == 4)
  check(b.board[4][2] == knight)
  check(b.board[5][4] of FreeTile)
  check(move(@[input[8], input[9]], b, Black)) # ES
  check(knight.xPos == 4)
  check(knight.yPos == 5)
  check(b.board[5][4] == knight)
  check(b.board[4][5] of FreeTile)
  check(move(@[input[10], input[11]], b, Black)) # EN
  check(knight.xPos == 6)
  check(knight.yPos == 4)
  check(b.board[4][6] == knight)
  check(b.board[5][4] of FreeTile)
  check(move(@[input[12], input[13]], b, Black)) # NE
  check(knight.xPos == 7)
  check(knight.yPos == 2)
  check(b.board[2][7] == knight)
  check(b.board[4][6] of FreeTile)
  check(move(@[input[14], input[15]], b, Black)) # NW
  check(knight.xPos == 6)
  check(knight.yPos == 0)
  check(b.board[0][6] == knight)
  check(b.board[2][7] of FreeTile)

test "black rook all directions with dist=1":
  var
    b = populateBoard()

  let
    rook = b.board[0][0]
    input = @["a8", "a7",
              "a7", "b7",
              "b7", "b8",
              "b8", "a8"]

  check(b.board[0][0] == rook)
  check(rook of Rook)
  check(rook.xPos == 0)
  check(rook.yPos == 0)

  # Remove adjacent Pieces without using 'move()' (move would distort test results)
  b.board[1][0] = newFreeTile(None, 0, 1)
  b.board[1][1] = newFreeTile(None, 1, 1)
  b.board[0][1] = newFreeTile(None, 1, 0)

  check(move(@[input[0], input[1]], b, Black))
  check(rook.xPos == 0)
  check(rook.yPos == 1)
  check(b.board[1][0] == rook)
  check(move(@[input[2], input[3]], b, Black))
  check(rook.xPos == 1)
  check(rook.yPos == 1)
  check(b.board[1][1] == rook)
  check(move(@[input[4], input[5]], b, Black))
  check(rook.xPos == 1)
  check(rook.yPos == 0)
  check(b.board[0][1] == rook)
  check(move(@[input[6], input[7]], b, Black))
  check(rook.xPos == 0)
  check(rook.yPos == 0)
  check(b.board[0][0] == rook)

test "white rook all directions with dist=1":
  var
    b = populateBoard()

  let
    rook = b.board[7][0]
    input = @["a1", "a2",
              "a2", "b2",
              "b2", "b1",
              "b1", "a1"]

  check(b.board[7][0] == rook)
  check(rook of Rook)
  check(rook.xPos == 0)
  check(rook.yPos == 7)

  # Remove adjacent Pieces without using 'move()' (move would distort test results)
  b.board[6][0] = newFreeTile(None, 0, 6)
  b.board[6][1] = newFreeTile(None, 1, 6)
  b.board[7][1] = newFreeTile(None, 1, 7)

  check(move(@[input[0], input[1]], b, White))
  check(rook.xPos == 0)
  check(rook.yPos == 6)
  check(b.board[6][0] == rook)
  check(move(@[input[2], input[3]], b, White))
  check(rook.xPos == 1)
  check(rook.yPos == 6)
  check(b.board[6][1] == rook)
  check(move(@[input[4], input[5]], b, White))
  check(rook.xPos == 1)
  check(rook.yPos == 7)
  check(b.board[7][1] == rook)
  check(move(@[input[6], input[7]], b, White))
  check(rook.xPos == 0)
  check(rook.yPos == 7)
  check(b.board[7][0] == rook)

test "black king all directions without captures":
  var
    b = populateBoard()

  let
    king = b.board[0][4]
    input = @["e8", "e7",
              "e7", "d6",
              "d6", "e5",
              "e5", "f5",
              "f5", "e5",
              "e5", "d6",
              "d6", "e7",
              "e7", "e8"]

  check(b.board[0][4] == king)
  check(king of King)
  check(king.xPos == 4)
  check(king.yPos == 0)

  # Remove adjacent Pieces without using 'move()' (move would distort test results)
  b.board[1][4] = newFreeTile(None, 4, 1)

  check(move(@[input[0], input[1]], b, Black))
  check(king.xPos == 4)
  check(king.yPos == 1)
  check(b.board[0][4] of FreeTile)
  check(b.board[1][4] == king)
  check(move(@[input[2], input[3]], b, Black))
  check(king.xPos == 3)
  check(king.yPos == 2)
  check(b.board[1][4] of FreeTile)
  check(b.board[2][3] == king)
  check(move(@[input[4], input[5]], b, Black))
  check(king.xPos == 4)
  check(king.yPos == 3)
  check(b.board[2][3] of FreeTile)
  check(b.board[3][4] == king)
  check(move(@[input[6], input[7]], b, Black))
  check(king.xPos == 5)
  check(king.yPos == 3)
  check(b.board[3][4] of FreeTile)
  check(b.board[3][5] == king)
  check(move(@[input[8], input[9]], b, Black))
  check(king.xPos == 4)
  check(king.yPos == 3)
  check(b.board[3][5] of FreeTile)
  check(b.board[3][4] == king)
  check(move(@[input[10], input[11]], b, Black))
  check(king.xPos == 3)
  check(king.yPos == 2)
  check(b.board[3][4] of FreeTile)
  check(b.board[2][3] == king)
  check(move(@[input[12], input[13]], b, Black))
  check(king.xPos == 4)
  check(king.yPos == 1)
  check(b.board[2][3] of FreeTile)
  check(b.board[1][4] == king)
  check(move(@[input[14], input[15]], b, Black))
  check(king.xPos == 4)
  check(king.yPos == 0)
  check(b.board[1][4] of FreeTile)
  check(b.board[0][4] == king)

test "white king all directions without captures":
  var
    b = populateBoard()

  let
    king = b.board[7][4]
    input = @["e1", "e2",
              "e2", "d3",
              "d3", "e4",
              "e4", "f4",
              "f4", "e4",
              "e4", "d3",
              "d3", "e2",
              "e2", "e1"]

  check(b.board[7][4] == king)
  check(king of King)
  check(king.xPos == 4)
  check(king.yPos == 7)

  # Remove adjacent Pieces without using 'move()' (move would distort test results)
  b.board[6][4] = newFreeTile(None, 4, 6)

  check(move(@[input[0], input[1]], b, White))
  check(king.xPos == 4)
  check(king.yPos == 6)
  check(b.board[7][4] of FreeTile)
  check(b.board[6][4] == king)
  check(move(@[input[2], input[3]], b, White))
  check(king.xPos == 3)
  check(king.yPos == 5)
  check(b.board[6][4] of FreeTile)
  check(b.board[5][3] == king)
  check(move(@[input[4], input[5]], b, White))
  check(king.xPos == 4)
  check(king.yPos == 4)
  check(b.board[5][3] of FreeTile)
  check(b.board[4][4] == king)
  check(move(@[input[6], input[7]], b, White))
  check(king.xPos == 5)
  check(king.yPos == 4)
  check(b.board[4][4] of FreeTile)
  check(b.board[4][5] == king)
  check(move(@[input[8], input[9]], b, White))
  check(king.xPos == 4)
  check(king.yPos == 4)
  check(b.board[4][5] of FreeTile)
  check(b.board[4][4] == king)
  check(move(@[input[10], input[11]], b, White))
  check(king.xPos == 3)
  check(king.yPos == 5)
  check(b.board[4][4] of FreeTile)
  check(b.board[5][3] == king)
  check(move(@[input[12], input[13]], b, White))
  check(king.xPos == 4)
  check(king.yPos == 6)
  check(b.board[5][3] of FreeTile)
  check(b.board[6][4] == king)
  check(move(@[input[14], input[15]], b, White))
  check(king.xPos == 4)
  check(king.yPos == 7)
  check(b.board[6][4] of FreeTile)
  check(b.board[7][4] == king)

test "white queen all directions with dist=1":
  var
    b = populateBoard()

  let
    queen = b.board[7][3]
    input = @["d1", "e1",
              "e1", "e2",
              "e2", "d3",
              "d3", "e4",
              "e4", "f4",
              "f4", "e4",
              "e4", "d3",
              "d3", "e2",
              "e2", "e1",
              "e1", "d1"]

  check(b.board[7][3] == queen)
  check(queen of Queen)
  check(queen.xPos == 3)
  check(queen.yPos == 7)

  # Remove adjacent Pieces without using 'move()' (move would distort test results)
  b.board[6][4] = newFreeTile(None, 4, 6)
  b.board[7][4] = newFreeTile(None, 4, 7)

  # There has to be a King of each color, otherwise isChecked
  # tries to read from nil (move() invokes isChecked())
  b.board[2][0] = newKing(White, 0, 2)
  check(b.board[6][4] of FreeTile)
  check(b.board[7][4] of FreeTile)

  check(move(@[input[0], input[1]], b, White))
  check(queen.xPos == 4)
  check(queen.yPos == 7)
  check(b.board[7][3] of FreeTile)
  check(b.board[7][4] == queen)
  check(move(@[input[2], input[3]], b, White))
  check(queen.xPos == 4)
  check(queen.yPos == 6)
  check(b.board[7][4] of FreeTile)
  check(b.board[6][4] == queen)
  check(move(@[input[4], input[5]], b, White))
  check(queen.xPos == 3)
  check(queen.yPos == 5)
  check(b.board[6][4] of FreeTile)
  check(b.board[5][3] == queen)
  check(move(@[input[6], input[7]], b, White))
  check(queen.xPos == 4)
  check(queen.yPos == 4)
  check(b.board[5][3] of FreeTile)
  check(b.board[4][4] == queen)
  check(move(@[input[8], input[9]], b, White))
  check(queen.xPos == 5)
  check(queen.yPos == 4)
  check(b.board[4][4] of FreeTile)
  check(b.board[4][5] == queen)
  check(move(@[input[10], input[11]], b, White))
  check(queen.xPos == 4)
  check(queen.yPos == 4)
  check(b.board[4][5] of FreeTile)
  check(b.board[4][4] == queen)
  check(move(@[input[12], input[13]], b, White))
  check(queen.xPos == 3)
  check(queen.yPos == 5)
  check(b.board[4][4] of FreeTile)
  check(b.board[5][3] == queen)
  check(move(@[input[14], input[15]], b, White))
  check(queen.xPos == 4)
  check(queen.yPos == 6)
  check(b.board[5][3] of FreeTile)
  check(b.board[6][4] == queen)
  check(move(@[input[16], input[17]], b, White))
  check(queen.xPos == 4)
  check(queen.yPos == 7)
  check(b.board[6][4] of FreeTile)
  check(b.board[7][4] == queen)


test "black queen all directions with dist=1":
  var
    b = populateBoard()

  let
    queen = b.board[0][3]
    input = @["d8", "e8",
              "e8", "e7",
              "e7", "d6",
              "d6", "e5",
              "e5", "f5",
              "f5", "e5",
              "e5", "d6",
              "d6", "e7",
              "e7", "e8",
              "e8", "d8"]

  check(b.board[0][3] == queen)
  check(queen of Queen)
  check(queen.xPos == 3)
  check(queen.yPos == 0)

  # Remove adjacent Pieces without using 'move()' (move would distort test results)
  b.board[1][4] = newFreeTile(None, 4, 1)
  b.board[0][4] = newFreeTile(None, 4, 0)

  # There has to be a King of each color, otherwise isChecked
  # tries to read from nil (move() invokes isChecked())
  b.board[2][0] = newKing(Black, 0, 2)
  check(b.board[1][4] of FreeTile)
  check(b.board[0][4] of FreeTile)

  check(move(@[input[0], input[1]], b, Black))
  check(queen.xPos == 4)
  check(queen.yPos == 0)
  check(b.board[0][3] of FreeTile)
  check(b.board[0][4] == queen)
  check(move(@[input[2], input[3]], b, Black))
  check(queen.xPos == 4)
  check(queen.yPos == 1)
  check(b.board[0][4] of FreeTile)
  check(b.board[1][4] == queen)
  check(move(@[input[4], input[5]], b, Black))
  check(queen.xPos == 3)
  check(queen.yPos == 2)
  check(b.board[1][4] of FreeTile)
  check(b.board[2][3] == queen)
  check(move(@[input[6], input[7]], b, Black))
  check(queen.xPos == 4)
  check(queen.yPos == 3)
  check(b.board[2][3] of FreeTile)
  check(b.board[3][4] == queen)
  check(move(@[input[8], input[9]], b, Black))
  check(queen.xPos == 5)
  check(queen.yPos == 3)
  check(b.board[3][4] of FreeTile)
  check(b.board[3][5] == queen)
  check(move(@[input[10], input[11]], b, Black))
  check(queen.xPos == 4)
  check(queen.yPos == 3)
  check(b.board[3][5] of FreeTile)
  check(b.board[3][4] == queen)
  check(move(@[input[12], input[13]], b, Black))
  check(queen.xPos == 3)
  check(queen.yPos == 2)
  check(b.board[3][4] of FreeTile)
  check(b.board[2][3] == queen)
  check(move(@[input[14], input[15]], b, Black))
  check(queen.xPos == 4)
  check(queen.yPos == 1)
  check(b.board[2][3] of FreeTile)
  check(b.board[1][4] == queen)
  check(move(@[input[16], input[17]], b, Black))
  check(queen.xPos == 4)
  check(queen.yPos == 0)
  check(b.board[1][4] of FreeTile)
  check(b.board[0][4] == queen)
  check(move(@[input[18], input[19]], b, Black))
  check(queen.xPos == 3)
  check(queen.yPos == 0)
  check(b.board[0][4] of FreeTile)
  check(b.board[0][3] == queen)

test "black king gets checked by white Rook":
  # Test Rook Check without capture
  var
    b = populateBoard()

  var
    blackKing = (King)b.board[0][4]

    input = @["a1", "a3",
              "a3", "e3"]

  # Remove unneeded Pieces out of the way
  b.board[6][0] = newFreeTile(None, 0, 1)
  b.board[1][4] = newFreeTile(None, 0, 1)

  check(not isChecked(blackKing, b))

  check(move(@[input[0], input[1]], b, White))
  check(move(@[input[2], input[3]], b, White))

  check(isChecked(blackKing, b))

  # //Test Rook Check without capture

  # Test Rook Check with capture on e7
  b = populateBoard()

  blackKing = (King)b.board[0][4]

  input = @["a1", "a3",
            "a3", "e3",
            "e3", "e7"]

  b.board[6][0] = newFreeTile(None, 0, 1)

  check(move(@[input[0], input[1]], b, White))
  check(not isChecked(blackKing, b))
  check(move(@[input[2], input[3]], b, White))
  check(not isChecked(blackKing, b))
  check(move(@[input[4], input[5]], b, White))
  check(isChecked(blackKing, b))
  # //Test Rook Check with capture on e7

  # Test Rook Check with captures on d7 and d8
  b = populateBoard()

  blackKing = (King)b.board[0][4]

  input = @["a1", "a3",
            "a3", "d3",
            "d3", "d7",
            "d7", "d8"]

  b.board[6][0] = newFreeTile(None, 0, 1)

  check(move(@[input[0], input[1]], b, White))
  check(not isChecked(blackKing, b))
  check(move(@[input[2], input[3]], b, White))
  check(not isChecked(blackKing, b))
  check(move(@[input[4], input[5]], b, White))
  check(not isChecked(blackKing, b))
  check(move(@[input[6], input[7]], b, White))
  check(isChecked(blackKing, b))
  b.draw
  # //Test Rook Check with captures on d7 and d8


#TODO: Test castling (incl. canCastle bool)
  #    Test isChecked (thoroughly)
  #    Test false moves
  #    Test captures
  #    Test dist > 1 for all relevant Pieces
