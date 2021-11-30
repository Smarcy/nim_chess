import unittest
import ../src/model/board
import ../src/model/pieces

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

