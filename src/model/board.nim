import strutils
import ../piece_factory
import pieces
import std/terminal
from ../movement import isValidMovePattern


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
  if movement.isValidMove(b, sourcePiece, targetPiece):
    # Replace source tile with a FreeTile
    if sourcePiece.color != None:
      if sourcePiece.color == targetPiece.color:
        #If the targetPiece is a friendly Piece
        return false
      else:
        # If moved Piece is a Pawn and on the rim after its move, promote (auto queen atm - TODO)
        if sourcePiece of Pawn and canPawnPromote((Pawn)sourcePiece):

          while(true):
            write(stdout, "\nType the symbol you'd like to promote to (Q, R, N, B) -> ")
            case readLine(stdin).toUpperAscii
            of "Q":
              b.board[targetY][targetX] = newQueen('Q', sourcePiece.color,
                  sourcePiece.xPos, sourcePiece.yPos)
              break
            of "R":
              b.board[targetY][targetX] = newRook('R', sourcePiece.color,
                  sourcePiece.xPos, sourcePiece.yPos)
              break
            of "N":
              b.board[targetY][targetX] = newKnight('N', sourcePiece.color,
                  sourcePiece.xPos, sourcePiece.yPos)
              break
            of "B":
              b.board[targetY][targetX] = newBishop('B', sourcePiece.color,
                  sourcePiece.xPos, sourcePiece.yPos)
              break
            else:
              continue

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
