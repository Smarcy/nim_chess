import strutils
from board import Board

type
  Color* = enum
    White, Black

  Piece* = ref object of RootObj
    ## Base class of every piece on the board
    symbol*: char
    color*: Color
    xPos*: int
    yPos*: int

  Pawn* = ref object of Piece
  Bishop* = ref object of Piece
  Knight* = ref object of Piece
  Rook* = ref object of Piece
  Queen* = ref object of Piece
  King* = ref object of Piece
  FreeTile* = ref object of Piece

proc isSemanticValidMove*(move: seq[string]): bool =
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

proc move*(move: seq[string], b: Board) =
  return


