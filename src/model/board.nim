import ../piece_factory
import pieces

type
  Board = object of RootObj
    board*: array[8, array[8, Piece]]

let allPieces = piece_factory.createAllPieces()

proc populateBoard*(): Board =
  ## Place all Pieces on the Chessboard
  for piece in allPieces:
    result.board[piece.yPos][piece.xPos] = piece

method drawBoard*(board: Board) {.base.} =
  ## Draw the (populated) Chessboard

  echo " +---+---+---+---+---+---+---+---+"
  for row in board.board:
    for i in 0..7:
      write(stdout, " | ", row[i].symbol)
    write(stdout, " |")
    write(stdout, "\n")
    echo " +---+---+---+---+---+---+---+---+"
