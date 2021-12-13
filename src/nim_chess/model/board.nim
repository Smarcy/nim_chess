import strutils
import ../factories/piece_factory
import pieces
import std/terminal

type
  Board* = object of RootObj
    board*: array[8, array[8, Piece]]

# Import has to be after Board definition, no clue why - otheriwse cyclic dep.
# edit: prolly because the imported procs already use Board. Makes sense I guess.
from ../game/rules import isValidMove, canPawnPromote


proc populateBoard*(): Board =
  ## Place all Pieces on the Chessboard

  let allPieces = piece_factory.createAllPieces()

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

proc findKing(b: Board, color: Color): King =
  for i in 0..7:
    for p in b.board[i]:
      if p of King and p.color == color:
        echo repr(p)
        return (King)p


proc promotePawn(b: Board, sourcePiece: Piece, x, y: int): Piece =
  ## Promote a Pawn into another Piece by user choice
  while(true):
    write(stdout, "\nType the symbol you'd like to promote to (Q, R, N, B) -> ")
    case readLine(stdin).toUpperAscii
    of "Q":
      result = newQueen(sourcePiece.color,
          sourcePiece.xPos, sourcePiece.yPos)
      break
    of "R":
      result = newRook(sourcePiece.color,
          sourcePiece.xPos, sourcePiece.yPos)
      break
    of "N":
      result = newKnight(sourcePiece.color,
          sourcePiece.xPos, sourcePiece.yPos)
      break
    of "B":
      result = newBishop(sourcePiece.color,
          sourcePiece.xPos, sourcePiece.yPos)
      break
    else:
      continue

proc isChecked(this: King, b: Board): bool =
  ##[ Check if a given King is currently in check (on a given Board).]##
  let
    rookDirs = @[(1, 0), (0, 1), (-1, 0), (0, -1)]

  var
    currPiece: Piece = this
    currX, currY: int

  for dir in rookDirs:
    currY = this.yPos + dir[0]
    currX = this.xPos + dir[1]

    while (currX > 0 and currX < 7) and (currY > 0 and currY < 7):
      currPiece = b.board[currY][currX]

      # If a friendly piece is blocking sight, stop looking in that direction
      if currPiece.color == this.color:
        break

      if (currPiece of Rook or currPiece of Queen) and currPiece.color != this.color:
        echo "ROOK CHECK"
        discard stdin.readLine()
        return true

      currY += dir[0]
      currX += dir[1]


proc move*(input: seq[string], b: var Board, currPlayer: Color): bool =
  ##[ Perform the move.
    Set sourceTile to FreeTile.
    Set targetTile to sourcePiece.]##
  let
    source = input[0]
    target = input[1]

  # sanity checks
  if source[0] notin "abcdefgh" or source[1] notin '1'..'8':
    return false
  if target[0] notin "abcdefgh" or target[1] notin '1'..'8':
    return false

  # calc Y with (8 minus input) because drawn-board and array are reversed
  let
    sourceX = "abcdefgh".find($source[0])
    sourceY = 8-(parseInt($source[1]))

    targetX = "abcdefgh".find($target[0])
    targetY = 8-(parseInt($target[1]))

    targetPiece = b.board[targetY][targetX]

    currPlayersKing = findKing(b, currPlayer)

  var
    sourcePiece = b.board[sourceY][sourceX]

  # Check if the move is viable for the current player(color)
  if sourcePiece.color != currPlayer: return false

  # Check if move input fits into piece-move-pattern
  if rules.isValidMove(b, sourcePiece, targetPiece):
    # Move onto a Tile with another Piece on it
    if sourcePiece.color != None:
      if sourcePiece.color == targetPiece.color:
        # Allow the move if its King and Rook (castling)
        if not(sourcePiece of King) and not(targetPiece of Rook):
        # If the targetPiece is a friendly Piece and player does not intend to castle, return false
          return false
      elif sourcePiece of Pawn and canPawnPromote((Pawn)sourcePiece):
        # If moved Piece is a Pawn and on the rim after its move -> promote it
        b.board[targetY][targetX] = promotePawn(b, sourcePiece, targetX, targetY)
      else:
        # Usual move to a FreeTile
        b.board[targetY][targetX] = sourcePiece

      # If the current players King is in check AFTER the move, revert it
      if currPlayersKing.isChecked(b):
        b.board[targetY][targetX] = targetPiece
        return false

      b.board[sourceY][sourceX] = newFreeTile(None, sourceX, sourceY)
      # Update SourcePiece Position data
      sourcePiece.xPos = targetX
      sourcePiece.yPos = targetY
      return true

