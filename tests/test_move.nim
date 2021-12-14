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

test "white bishop NW/SE single step":
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

test "white bishop NE/SW single step":
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

test "black bishop SE/NW single step":
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

test "black bishop SW/NE single step":
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

test "white knight all steps in one test":
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

test "black knight all steps in one test":
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

