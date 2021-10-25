import strutils
import ../piece_factory
import pieces
import std/terminal

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
      # echo repr(row[i])
      if row[i] == nil:
        continue
      if row[i].color == White:
        stdout.styledWrite("| ", fgRed, $row[i].symbol, fgDefault, " ")
      elif row[i].color == Black:
        stdout.styledWrite("| ", fgGreen, $row[i].symbol, fgDefault, " ")
      elif row[i].color == None:
        stdout.write("| " & row[i].symbol & " ")
    write(stdout, "|", "\n")
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

proc getPieceOnTile(x, y: int): Piece =
  return

# Overload isValidMovePattern for every Piece type
proc isValidMovePattern(b: Board, source: tuple[x, y: int],
                        target: tuple[x, y: int],
                        p: Pawn): bool =
  case p.color
  of White:
    # TODO: encapsule "in-the-way" check?
    if (target[1] == source[1] - 2) and (source[0] == target[0]):
      if source[1] == 6 and b.board[source[1]-1][source[0]].color == None:
      # If on initial Position, accept double step
        return true
    if source[1] == target[1] + 1 and b.board[source[1]-1][source[0]].color ==
        None and source[0] == target[0]:
      # Usual single step
      return true
    if (source[0]+1 == target[0] or source[0]-1 == target[0]) and (source[1] ==
        target[1]+1):
      return true
    else:
      # Illegal move
      return false

  of Black:
    return
  else:
    echo "Invalid"
    return

proc isValidMovePattern(source: tuple[x, y: int],
                        target: tuple[x, y: int],
                        p: Knight): bool =

  echo "Knight"
  return true

proc isValidMovePattern(source: tuple[x, y: int],
                        target: tuple[x, y: int],
                        p: Bishop): bool =

  echo "Bishop"
  return true

proc isValidMovePattern(source: tuple[x, y: int],
                        target: tuple[x, y: int],
                        p: Rook): bool =

  echo "Rook"
  return true

proc isValidMovePattern(source: tuple[x, y: int],
                        target: tuple[x, y: int],
                        p: Queen): bool =

  echo "Queen"
  return true

proc isValidMovePattern(source: tuple[x, y: int],
                        target: tuple[x, y: int],
                        p: King): bool =

  echo "King"
  return true

proc isValidMove(b: Board, piece: Piece,
                 source: tuple[x, y: int],
                 target: tuple[x, y: int]): bool =
  if piece of Pawn:
    result = isValidMovePattern(b, source, target, (Pawn)piece)
  elif piece of Knight:
    result = isValidMovePattern(source, target, (Knight)piece)
  elif piece of Bishop:
    result = isValidMovePattern(source, target, (Bishop)piece)
  elif piece of Rook:
    result = isValidMovePattern(source, target, (Rook)piece)
  elif piece of Queen:
    result = isValidMovePattern(source, target, (Queen)piece)
  elif piece of King:
    result = isValidMovePattern(source, target, (King)piece)

proc move*(input: seq[string], b: var Board) =
  let source = input[0]
  let target = input[1]

  # calc Y with 8 minus input because board and array are reversed
  let sourceX = "abcdefgh".find($source[0])
  let sourceY = 8-(parseInt($source[1]))

  let targetX = "abcdefgh".find($target[0])
  let targetY = 8-(parseInt($target[1]))

  let sourcePiece = b.board[sourceY][sourceX]
  let targetPiece = b.board[targetY][targetX]

  # Check if move input fits into piece-move-pattern
  if isValidMove(b, sourcePiece, (sourceX, sourceY), (targetX, targetY)):
    # Replace source tile with a FreeTile
    if sourcePiece.color != None:
      if sourcePiece.color == targetPiece.color:
        #If the targetPiece is a friendly Piece
        return
      elif sourcePiece.color != targetPiece.color and targetPiece.color != None:
        # If the targetPiece is an enemy Piece
        b.board[targetY][targetX] = sourcePiece
        b.board[sourceY][sourceX] = newFreeTile(' ', None, sourceX, sourceY)
      else:
        # If the targetPiece is a FreeTile
        # TODO: Check for pieces on the way to the targetpiece
        b.board[targetY][targetX] = sourcePiece
        b.board[sourceY][sourceX] = newFreeTile(' ', None, sourceX, sourceY)
    else:
      # FreeTiles can't be moved
      # TODO: When rounds are implemented, keep same player here
      return
