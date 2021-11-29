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

  #cleanup..
  b.board[1][0] = newPawn(Black, 0, 1)
  p.yPos = 1

test "bishop NW single step":
  var
    b = populateBoard()

  let
    p = b.board[6][4] # pawn
    bishop = b.board[7][5]
    input = @["e2", "e3", "f1", "e2"]

  b.draw()
  check(p.yPos == 6)
  check(bishop.yPos == 7)
  check(bishop.xPos == 5)
  check(move(@[input[0], input[1]], b, White))
  check(p.yPos == 5)
  check(move(@[input[2], input[3]], b, White))
  check(bishop.yPos == 6)
  check(bishop.xPos == 4)
  check(b.board[6][4] == bishop)

  #cleanup .. wtf there has to be a better way?!
  bishop.yPos = 7
  bishop.xPos = 5
  p.yPos = 6
  b.board[6][4] = newPawn(White, 4, 6)


test "bishop NE single step":
  var
    b = populateBoard()

  let
    p = b.board[6][6] # pawn
    bishop = b.board[7][5]
    input = @["g2", "g3", "f1", "g2"]

  b.draw()
  check(p.yPos == 6)
  check(bishop.yPos == 7)
  check(bishop.xPos == 5)
  check(move(@[input[0], input[1]], b, White))
  check(p.yPos == 5)
  check(move(@[input[2], input[3]], b, White))
  check(bishop.yPos == 6)
  check(bishop.xPos == 6)
  check(b.board[6][6] == bishop)

