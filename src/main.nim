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

  if isSemanticValidMove(input):
    echo "VALID"
  else:
    echo "Invalid Move!"
  discard readLine(stdin)

