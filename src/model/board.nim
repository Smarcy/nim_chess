import strutils
import ../piece_factory
import pieces

type
  Board* = object of RootObj
    board*: array[8, array[8, Piece]]

let allPieces = piece_factory.createAllPieces()

proc populateBoard*(): Board =
  ## Place all Pieces on the Chessboard
  for piece in allPieces:
    result.board[piece.yPos][piece.xPos] = piece

method draw*(board: Board) {.base.} =
  ## Draw the (populated) Chessboard

  var sideNotation = 8
  echo "  +---+---+---+---+---+---+---+---+"
  for row in board.board:
    write(stdout, sideNotation, " ")
    dec(sideNotation)
    for i in 0..7:
      write(stdout, "| ", row[i].symbol, " ")
    write(stdout, "|")
    write(stdout, "\n")
    echo "  +---+---+---+---+---+---+---+---+"
  echo "    A   B   C   D   E   F   G   H  "

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

# Overload isValidMovePattern for every Piece type
proc isValidMovePattern(p: Pawn): bool =
  echo "Pawn"
  return true

proc isValidMovePattern(p: Knight): bool =
  echo "Knight"
  return true

proc isValidMovePattern(p: Bishop): bool =
  echo "Bishop"
  return true

proc isValidMovePattern(p: Rook): bool =
  echo "Rook"
  return true

proc isValidMovePattern(p: Queen): bool =
  echo "Queen"
  return true

proc isValidMovePattern(p: King): bool =
  echo "King"
  return true

proc isValidMove(piece: Piece,
                 source: tuple[x, y: int],
                 target: tuple[x, y: int]): bool =
  if piece of Pawn:
    result = isValidMovePattern((Pawn)piece)
  elif piece of Knight:
    result = isValidMovePattern((Knight)piece)
  elif piece of Bishop:
    result = isValidMovePattern((Bishop)piece)
  elif piece of Rook:
    result = isValidMovePattern((Rook)piece)
  elif piece of Queen:
    result = isValidMovePattern((Queen)piece)
  elif piece of King:
    result = isValidMovePattern((King)piece)

proc move*(input: seq[string], b: var Board) =
  let source = input[0]
  let target = input[1]

  # calc Y with 8 minus input because board and array are reversed
  let sourceX = "abcdefgh".find($source[0])
  let sourceY = 8-(parseInt($source[1]))

  let targetX = "abcdefgh".find($target[0])
  let targetY = 8-(parseInt($target[1]))

  let sourcePiece = b.board[sourceY][sourceX]

  # Check if move input fits into piece-move-pattern
  if isValidMove(sourcePiece, (sourceX, sourceY), (targetX, targetY)):
    # Replace source tile with a FreeTile
    b.board[targetY][targetX] = b.board[sourceY][sourceX]
    b.board[sourceY][sourceX] = newFreeTile(' ', None, sourceX, sourceY)
