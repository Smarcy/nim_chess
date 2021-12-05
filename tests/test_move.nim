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

test "bishop NW single step":
  var
    b = populateBoard()

  let
    p = b.board[6][4] # pawn
    bishop = b.board[7][5]
    input = @["e2", "e3", "f1", "e2"]

  check(p.yPos == 6)
  check(bishop.yPos == 7)
  check(bishop.xPos == 5)
  check(move(@[input[0], input[1]], b, White))
  check(p.yPos == 5)
  check(move(@[input[2], input[3]], b, White))
  check(bishop.yPos == 6)
  check(bishop.xPos == 4)
  check(b.board[6][4] == bishop)
  check(b.board[7][5] of FreeTile)

test "bishop NE single step":
  var
    b = populateBoard()

  let
    p = b.board[6][6] # pawn
    bishop = b.board[7][5]
    input = @["g2", "g3", "f1", "g2"]

  check(p.yPos == 6)
  check(bishop.yPos == 7)
  check(bishop.xPos == 5)
  check(move(@[input[0], input[1]], b, White))
  check(p.yPos == 5)
  check(move(@[input[2], input[3]], b, White))
  check(bishop.yPos == 6)
  check(bishop.xPos == 6)
  check(b.board[6][6] == bishop)
  check(b.board[7][5] of FreeTile)

test "bishop SE single step":
  var
    b = populateBoard()

  let
    p = b.board[1][6] # pawn
    bishop = b.board[0][5]
    input = @["g7", "g6", "f8", "g7"]

  check(p.yPos == 1)
  check(bishop.yPos == 0)
  check(bishop.xPos == 5)
  check(move(@[input[0], input[1]], b, Black))
  check(p.yPos == 2)
  check(move(@[input[2], input[3]], b, Black))
  check(bishop.yPos == 1)
  check(bishop.xPos == 6)
  check(b.board[1][6] == bishop)
  check(b.board[0][5] of FreeTile)

test "bishop SW single step":
  var
    b = populateBoard()

  let
    p = b.board[1][4] # pawn
    bishop = b.board[0][5]
    input = @["e7", "e6", "f8", "e7"]

  check(p.yPos == 1)
  check(bishop.yPos == 0)
  check(bishop.xPos == 5)
  check(move(@[input[0], input[1]], b, Black))
  check(p.yPos == 2)
  check(move(@[input[2], input[3]], b, Black))
  check(bishop.yPos == 1)
  check(bishop.xPos == 4)
  check(b.board[1][4] == bishop)
  check(b.board[0][5] of FreeTile)

test "knight all steps in one test":
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

