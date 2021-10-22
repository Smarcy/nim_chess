import strutils
import os
import model/board as b

var board = b.populateBoard()
while true:
  discard os.execShellCmd("clear")
  b.draw(board)

  write(stdout, "\nType your move (ex.: A2 A3) -> ")
  var input = readLine(stdin).split(" ")

  if isValidMoveInput(input):
    move(input, board)
    discard readLine(stdin)
  else:
    continue
