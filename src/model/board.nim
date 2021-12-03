import strutils
import ../piece_factory
import pieces
import std/terminal

type
  Board* = object of RootObj
    board*: array[8, array[8, Piece]]

# Import has to be after Board definition, no clue why - otheriwse cyclic dep.
# edit: prolly because the imported procs already use Board. Makes sense I guess.
from ../rules import isValidMove, canPawnPromote


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

proc move*(input: seq[string], b: var Board, currPlayer: Color): bool =
  ##[ Perform the move.
    Set sourceTile as FreeTile.
    Set targetTile to sourcePiece.]##
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
  if rules.isValidMove(b, sourcePiece, targetPiece):
    # Replace source tile with a FreeTile
    if sourcePiece.color != None:
      if sourcePiece.color == targetPiece.color:
        # Allow the move if its King and Rook (castling)
        # TODO: This can be abused on any tile, fix it!
        if not(sourcePiece of King) and not(targetPiece of Rook):
        #If the targetPiece is a friendly Piece
          return false
      elif sourcePiece of Pawn and canPawnPromote((Pawn)sourcePiece):
        # If moved Piece is a Pawn and on the rim after its move -> promote it
        b.board[targetY][targetX] = promotePawn(b, sourcePiece, targetX, targetY)
      else:
        b.board[targetY][targetX] = sourcePiece
      b.board[sourceY][sourceX] = newFreeTile(None, sourceX, sourceY)

      # Update SourcePiece Position data
      sourcePiece.xPos = targetX
      sourcePiece.yPos = targetY
      return true
