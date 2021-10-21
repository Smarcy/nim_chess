import strformat
import strutils
import sequtils
import os
import model/pieces
import model/board as b

let board = b.populateBoard()
while true:
  discard os.execShellCmd("clear")
  b.draw(board)

  write(stdout, "\nType your move (ex.: A2 A3) -> ")
  var input = readLine(stdin).split(" ")

  if isValidMoveInput(input):
    discard move(input, board)
  else:
    continue
