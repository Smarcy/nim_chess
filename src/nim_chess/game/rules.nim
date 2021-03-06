import ../model/pieces
from ../model/board import Board

proc canPawnPromote*(p: Pawn): bool =
  ##[ Check if a moved Pawn is able to be promoted to another Piece.
    This proc is called if a pawn does a successful move forward.]##
  case p.color
  # A Pawn is being promoted if its position BEFORE the move is 1 off of the rim
  of Black: return p.yPos == 6
  of White: return p.yPos == 1
  else: return false

proc short_castle(b: var Board, sourcePiece: King,
    targetPiece: Rook): bool =
  var y: int

  case sourcePiece.color
  of White: y = 7
  of Black: y = 0
  else: return false

  # TODO: return false if the king is in check on the way
  # Check if any Piece is blocking the way
  if b.board[y][5].color != None or b.board[y][6].color != None:
    return false

  else:
    if sourcePiece.canCastle and targetPiece.canCastle:
      # In this special case BOTH origin Tiles are FreeTiles
      b.board[sourcePiece.yPos][sourcePiece.xPos] = newFreeTile(None,
          sourcePiece.xPos, sourcePiece.yPos)
      b.board[targetPiece.yPos][targetPiece.xPos] = newFreeTile(None,
          targetPiece.xPos, targetPiece.yPos)

      sourcePiece.xPos = 6
      targetPiece.xPos = 5
      b.board[y][6] = sourcePiece
      b.board[y][5] = targetPiece
      return true

proc long_castle(b: var Board, sourcePiece: King, targetPiece: Rook): bool =
  var y: int

  case sourcePiece.color
  of White: y = 7
  of Black: y = 0
  else: return false

  # TODO: return false if the king is in check on the way
  # Check for Pieces blocking the way
  if b.board[y][1].color != None or b.board[y][2].color != None or b.board[y][
      3].color != None:
    return false
  else:
    if sourcePiece.canCastle and targetPiece.canCastle:

      # In this special case BOTH origin Tiles are FreeTiles
      b.board[sourcePiece.yPos][sourcePiece.xPos] = newFreeTile(None,
          sourcePiece.xPos, sourcePiece.yPos)
      b.board[targetPiece.yPos][targetPiece.xPos] = newFreeTile(None,
          targetPiece.xPos, targetPiece.yPos)

      sourcePiece.xPos = 2
      targetPiece.xPos = 3
      b.board[y][2] = sourcePiece
      b.board[y][3] = targetPiece
      return true

# Overload isValidMovePattern for every Piece type
proc isValidMovePattern(b: Board, sourcePiece: Pawn,
    targetPiece: Piece): bool =
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
    if sourcePiece.yPos == y and
      b.board[sourcePiece.yPos-x][sourcePiece.xPos].color == None:
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
    for y in (sourcePiece.yPos + yDir) .. (targetPiece.yPos):
      for x in (sourcePiece.xPos + xDir) .. (targetPiece.xPos):
        if b.board[y][x].color != None:
          return false
    return true

proc isValidMovePattern(b: Board, sourcePiece: Rook,
    targetPiece: Piece): bool =
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

  # Check for Pieces in the way
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

  # After any (first) successful rook move, lose right to castle on that rook
  sourcePiece.canCastle = false
  sourcePiece.xPos = targetPiece.xPos
  sourcePiece.yPos = targetPiece.yPos

  return true

proc isValidMovePattern(b: Board, sourcePiece: Queen,
    targetPiece: Piece): bool =
  ## Queen Movement Ruleset

  # If given move is valid for rook OR bishop, it is valid for queen
  return isValidMovePattern(b, cast[Bishop](sourcePiece), targetPiece) or
      isValidMovePattern(b, cast[Rook](sourcePiece), targetPiece)

proc isValidMovePattern(b: var Board, sourcePiece: King,
    targetPiece: Piece): bool =
  ## King Movement Ruleset

  let validOffsets = @[(1, 0), (0, 1), (1, 1)]
  let yOffset = abs(sourcePiece.yPos - targetPiece.yPos)
  let xOffset = abs(sourcePiece.xPos - targetPiece.xPos)

  ######## Castling ########
  var rookPiece: Rook

  if targetPiece of Rook: rookPiece = (Rook)targetPiece
  # 'canCastle' implicitly checks if the king is still on its initial position
  if (xOffset == 3 or xOffset == 4) and yOffset == 0:
    case targetPiece.xPos
    of 7:
      return short_castle(b, sourcePiece, rookPiece)
    of 0:
      return long_castle(b, sourcePiece, rookPiece)
    else:
      return false

  ######## Usual single-step ########

  # Lose right to castle after any (first) successful king move
  sourcePiece.canCastle = false

  # In this case it is sufficient to test for the offsets,
  # since there are no "in-between" tiles with king movement
  return (yOffset, xOffset) in validOffsets and targetPiece.color !=
      sourcePiece.color

proc isValidMove*(b: var Board, sourcePiece, targetPiece: Piece): bool =
  ## Supermethod to separate different Piece movement patterns depending on Piece-type
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

