import ../piece_factory
import pieces

type
  Board = object of RootObj
    board*: array[8, array[8, Piece]]

let allPieces = piece_factory.createAllPieces()

proc populateBoard*(): Board =
  for piece in allPieces:
    result.board[piece.xPos][piece.yPos] = piece
