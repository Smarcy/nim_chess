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

  case piece.symbol
  of 'P':
    if isValidMovePattern((Pawn)piece):
      return true
  of 'N':
    if isValidMovePattern((Knight)piece):
      return true
  of 'B':
    if isValidMovePattern((Bishop)piece):
      return true
  of 'R':
    if isValidMovePattern((Rook)piece):
      return true
  of 'Q':
    if isValidMovePattern((Queen)piece):
      return true
  of 'K':
    if isValidMovePattern((King)piece):
      return true
  else:
    return false

proc move*(input: seq[string], b: var Board) =
  let source = input[0]
  let target = input[1]

  # Calc X Val: charVal of a..h - 97 = 0..7
  # Calc Y Val: 8 - intVal(1..8)       = 0..7
  let sourceX = int(source[0])-97
  let sourceY = 8-(parseInt($source[1]))

  let targetX = int(target[0])-97
  let targetY = 8-(parseInt($target[1]))

  let sourcePiece = b.board[sourceY][sourceX]

  # Check if move input fits into piece-move-pattern
  if isValidMove(sourcePiece, (sourceX, sourceY), (targetX, targetY)):
    # Replace source tile with a FreeTile
    b.board[targetY][targetX] = b.board[sourceY][sourceX]
    b.board[sourceY][sourceX] = newFreeTile(' ', None, sourceX, sourceY)
