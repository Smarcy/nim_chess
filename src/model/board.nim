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

proc draw*(board: Board) =
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
        stdout.styledWrite("| ", fgGreen, $row[i].symbol, fgDefault, " ")
      elif row[i].color == Black:
        stdout.styledWrite("| ", fgRed, $row[i].symbol, fgDefault, " ")
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

proc canPawnPromote(p: Pawn): bool =
  # This method is called if a pawn does a successful move forward
  case p.color
  # A Pawn is being promoted if its position BEFORE the move is 1 off of the rim
  of Black:
    if p.yPos == 6: return true
  of White:
    if p.yPos == 1: return true
  else:
    return false

# Overload isValidMovePattern for every Piece type
proc isValidMovePattern(b: Board, sourcePiece: Pawn, targetPiece: Piece): bool =
  ## Pawn Movement Ruleset

  # Depending on color of sourcePiece
  # x = needed to calc steps (up/down)
  # y = initial pawn position
  var x, y: int

  case sourcePiece.color
  of White:
    x = 1
    y = 6
  of Black:
    x = -1
    y = 1
  else:
    return false

  if (targetPiece.yPos == sourcePiece.yPos - (2*x)) and (sourcePiece.xPos ==
      targetPiece.xPos):
    if sourcePiece.yPos == y and b.board[sourcePiece.yPos-x][
        sourcePiece.xPos].color == None:
    # If on initial Position and no piece in the way, accept double step
      return true
  if sourcePiece.yPos == targetPiece.yPos + x and b.board[sourcePiece.yPos +
          ((-1)*x)][sourcePiece.xPos].color == None and sourcePiece.xPos ==
          targetPiece.xPos:
    # Usual single step
    return true
  if abs(targetPiece.xPos - sourcePiece.xPos) == 1 and (sourcePiece.yPos ==
      targetPiece.yPos+x):
    if sourcePiece.color != targetPiece.color and targetPiece.color != None:
      # Take if diagonal tile has an enemy on it
      return true

proc isValidMovePattern(b: Board, sourcePiece: Knight,
    targetPiece: Piece): bool =
  ## Knight Movement Ruleset

  let validOffsets = @[(2, 1), (1, 2)]

  let yOffset = abs(sourcePiece.yPos - targetPiece.yPos)
  let xOffset = abs(sourcePiece.xPos - targetPiece.xPos)

  return (yOffset, xOffset) in validOffsets

proc isValidMovePattern(b: Board, sourcePiece: Bishop,
    targetPiece: Piece): bool =
  ## Bishop Movement Ruleset

  let yOffset = abs(sourcePiece.yPos - targetPiece.yPos)
  let xOffset = abs(sourcePiece.xPos - targetPiece.xPos)

  # Offsets absolutes have to be the same for diagonal movement pattern
  if xOffset == yOffset:
    let xDir = if sourcePiece.xPos > targetPiece.xPos: -1 else: 1
    let yDir = if sourcePiece.yPos > targetPiece.yPos: -1 else: 1

    # Check if anything is blocking the way. If yes -> don't move at all
    for y in (sourcePiece.yPos + yDir) .. (targetPiece.yPos - yDir):
      for x in (sourcePiece.xPos + xDir) .. (targetPiece.xPos - xDir):
        if b.board[y][x].color != None:
          return false
    return true

proc isValidMovePattern(b: Board, sourcePiece: Rook, targetPiece: Piece): bool =
  ## Rook Movement Ruleset

  let yOffset = abs(sourcePiece.yPos - targetPiece.yPos)
  let xOffset = abs(sourcePiece.xPos - targetPiece.xPos)

  # Rook movement always has one offset that equals zero
  if xOffset != 0 and yOffset != 0:
    return false

  var xDir = if sourcePiece.xPos > targetPiece.xPos: -1 else: 1
  var yDir = if sourcePiece.yPos > targetPiece.yPos: -1 else: 1

  # Find out which offset is zero
  if sourcePiece.xPos == targetPiece.xPos: xDir = 0
  if sourcePiece.yPos == targetPiece.yPos: yDir = 0

  if xDir == 0 and yDir == 1:
    for i in sourcePiece.yPos+1 .. targetPiece.yPos-1:
      if b.board[i][sourcePiece.xPos].color != None: return false
  elif xDir == 0 and yDir == -1:
    for i in targetPiece.yPos+1 .. sourcePiece.yPos-1:
      if b.board[i][sourcePiece.xPos].color != None: return false
  elif yDir == 0 and xDir == 1:
    for i in sourcePiece.xPos+1 .. targetPiece.xPos-1:
      if b.board[sourcePiece.yPos][i].color != None: return false
  elif yDir == 0 and xDir == -1:
    for i in targetPiece.xPos+1 .. sourcePiece.xPos-1:
      if b.board[sourcePiece.yPos][i].color != None: return false

  return true

proc isValidMovePattern(b: Board, sourcePiece: Queen,
    targetPiece: Piece): bool =

  # If given move is valid for rook OR bishop, it is valid for queen
  return isValidMovePattern(b, cast[Bishop](sourcePiece), targetPiece) or
      isValidMovePattern(b, cast[Rook](sourcePiece), targetPiece)

proc isValidMovePattern(b: Board, sourcePiece: King, targetPiece: Piece): bool =
  ## King Movement Ruleset

  let validOffsets = @[(1, 0), (0, 1), (1, 1)]
  let yOffset = abs(sourcePiece.yPos - targetPiece.yPos)
  let xOffset = abs(sourcePiece.xPos - targetPiece.xPos)

  # In this case it is sufficient to test for the offsets,
  # since there are no "in-between" tiles with king movement
  return (yOffset, xOffset) in validOffsets

proc isValidMove(b: Board, sourcePiece, targetPiece: Piece): bool =
  if sourcePiece of Pawn:
    result = isValidMovePattern(b, (Pawn)sourcePiece, targetPiece)
  elif sourcePiece of Knight:
    result = isValidMovePattern(b, (Knight)sourcePiece, targetPiece)
  elif sourcePiece of Bishop:
    result = isValidMovePattern(b, (Bishop)sourcePiece, targetPiece)
  elif sourcePiece of Rook:
    result = isValidMovePattern(b, (Rook)sourcePiece, targetPiece)
  elif sourcePiece of Queen:
    result = isValidMovePattern(b, (Queen)sourcePiece, targetPiece)
  elif sourcePiece of King:
    result = isValidMovePattern(b, (King)sourcePiece, targetPiece)

proc move*(input: seq[string], b: var Board, currPlayer: Color): bool =
  let source = input[0]
  let target = input[1]

  # sanity checks
  if source[0] notin "abcdefgh" or source[1] notin '1'..'8':
    return false
  if target[0] notin "abcdefgh" or target[1] notin '1'..'8':
    return false

  # calc Y with (8 minus input) because drawn-board and array are reversed
  let sourceX = "abcdefgh".find($source[0])
  let sourceY = 8-(parseInt($source[1]))

  let targetX = "abcdefgh".find($target[0])
  let targetY = 8-(parseInt($target[1]))

  var sourcePiece = b.board[sourceY][sourceX]
  let targetPiece = b.board[targetY][targetX]

  # Check if the move is viable for the current player(color)
  if sourcePiece.color != currPlayer: return false

  # Check if move input fits into piece-move-pattern
  if isValidMove(b, sourcePiece, targetPiece):
    # Replace source tile with a FreeTile
    if sourcePiece.color != None:
      if sourcePiece.color == targetPiece.color:
        #If the targetPiece is a friendly Piece
        return false
      else:
        # If moved Piece is a Pawn and on the rim after its move, promote (auto queen atm - TODO)
        if sourcePiece of Pawn and canPawnPromote((Pawn)sourcePiece):
          b.board[targetY][targetX] = newQueen('Q', sourcePiece.color,
              sourcePiece.xPos, sourcePiece.yPos)
          b.board[sourceY][sourceX] = newFreeTile(' ', None, sourceX, sourceY)
          return true
        else:
          # If the targetPiece is a FreeTile
          b.board[targetY][targetX] = sourcePiece
          b.board[sourceY][sourceX] = newFreeTile(' ', None, sourceX, sourceY)

          sourcePiece.xPos = targetX
          sourcePiece.yPos = targetY
          return true
    else:
      # FreeTiles can't be moved
      return false
