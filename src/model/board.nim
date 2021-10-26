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
  let
    target = newPiece(b.board[target.y][target.x].symbol,
                      b.board[target.y][target.x].color,
                      b.board[target.y][target.x].xPos,
                      b.board[target.y][target.x].yPos)
  case p.color
  of White:
    # TODO: encapsule "in-the-way" check?
    if (target.yPos == p.yPos - 2) and (p.xPos == target.xPos):
      if p.yPos == 6 and b.board[p.yPos-1][p.xPos].color == None:
      # If on initial Position and no piece in the way, accept double step
        return true
    if p.yPos == target.yPos + 1 and b.board[source[1]-1][p.xPos].color ==
        None and p.xPos == target.xPos:
      # Usual single step
      return true
    if abs(target.xPos - p.xPos) == 1 and (p.yPos == target.yPos+1):
      if b.board[target.yPos][target.xPos].color != None:
        # Take
        return true
    else:
      # Illegal move
      return false

  of Black:
    if (target.yPos == p.yPos + 2) and (p.xPos == target.xPos):
      if p.yPos == 1 and b.board[p.yPos+1][p.xPos].color == None:
      # If on initial Position and no piece in the way, accept double step
        return true
    if p.yPos == target.yPos - 1 and b.board[source[1]+1][p.xPos].color ==
        None and p.xPos == target.xPos:
      # Usual single step
      return true
    if abs(target.xPos - p.xPos) == 1 and (p.yPos == target.yPos-1):
      if b.board[target.yPos][target.xPos].color != None:
        # Take
        return true
    else:
      # Illegal move
      return false

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

  var sourcePiece = b.board[sourceY][sourceX]
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
        # TODO: Check for pieces in the way
        b.board[targetY][targetX] = sourcePiece
        b.board[sourceY][sourceX] = newFreeTile(' ', None, sourceX, sourceY)
      else:
        # If the targetPiece is a FreeTile
        b.board[targetY][targetX] = sourcePiece
        b.board[sourceY][sourceX] = newFreeTile(' ', None, sourceX, sourceY)

        sourcePiece.xPos = targetX
        sourcePiece.yPos = targetY
    else:
      # FreeTiles can't be moved
      # TODO: When rounds are implemented, keep same player here
      return
