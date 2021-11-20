import strutils
import os
import model/board as b
from model/pieces import Color

var currentPlayer = White # set starting player
var board = b.populateBoard()

while true:
  discard os.execShellCmd("clear")
  b.draw(board)

  write(stdout, "\nType your move (ex.: A2 A3) -> ")
  var input = readLine(stdin).split(" ")

  if isValidMoveInput(input):
    if move(input, board, currentPlayer):
      # Change currentPlayerColor if the given move was successful
      if currentPlayer == White: currentPlayer = Black else: currentPlayer = White
    else:
      echo "Illegal Move!"
      discard readLine(stdin)
