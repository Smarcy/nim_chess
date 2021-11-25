import strutils
import os
import model/board as b
from model/pieces import Color

var currentPlayer = White # set starting player
var board = b.populateBoard()

proc isValidMoveInput*(move: seq[string]): bool =
  ## Just to check if the input move is in correct format

  # Move command consists of 2 parts (source, target)
  if len(move) == 2:
    # Each part is of len(2) (e.g.: A1 A3, B4 B7, ...)
    for m in move:
      if len(m) != 2:
        return false

      # Each Part consists of a letter followed by a digit (a-h and 1-8)
      if m[0].isAlphaAscii and m[1].isDigit:
        return m[0].toLowerAscii in 'a'..'h' and m[1] in '1'..'8'


################ Game Loop ################
while true:
  discard os.execShellCmd("clear")
  b.draw(board)

  echo "\n", currentPlayer, "'s turn"

  write(stdout, "\nType your move (ex.: A2 A3) -> ")
  var input = readLine(stdin).split(" ")

  if isValidMoveInput(input):
    if move(input, board, currentPlayer):
      # Change currentPlayerColor if the given move was successful
      currentPlayer = if currentPlayer == White: Black else: White
    else:
      echo "Illegal Move!"
      discard readLine(stdin)
