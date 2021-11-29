import unittest
import ../src/model/board
import ../src/model/pieces

test "test pawn single step":
  var
    b = populateBoard()

  let
    p = b.board[1][0]
    input = @["a7", "a6"]

  check(p.yPos == 1)
  check(move(input, b, Black))
  check(p.yPos == 2)
