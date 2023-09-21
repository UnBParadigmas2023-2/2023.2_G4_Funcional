-- RegrasDamas.hs

module RegrasDamas
    ( validateMove
    , checkWin
    , Piece(..)
    , Board
    -- ... e possivelmente outras funções e tipos que você queira exportar
    ) where


import Data.List

data Piece = Empty | Black | White | KingW | KingB deriving (Eq, Show)
type Board = [[Piece]]

validateMove :: Board -> Piece -> Int -> Int -> Int -> Int -> Maybe Board
validateMove board player rowFrom colFrom rowTo colTo
    | outOfBounds || notPlayerPiece || notEmpty = Nothing
    | isCaptureMove = makeCaptureMove
    | isSimpleMove = Just makeSimpleMove
    | otherwise = Nothing
  where
    outOfBounds = any (\x -> x < 0 || x >= 8) [rowFrom, colFrom, rowTo, colTo]
    notPlayerPiece = board !! rowFrom !! colFrom /= player
    notEmpty = board !! rowTo !! colTo /= Empty
    rowDiff = rowTo - rowFrom
    colDiff = colTo - colFrom
    isCaptureMove = abs rowDiff == 2 && abs colDiff == 2 && isOpponentPiece (rowFrom + signum rowDiff) (colFrom + signum colDiff)
    isSimpleMove = abs rowDiff == 1 && abs colDiff == 1 && isValidDirection
    isValidDirection
        | player == Black = rowDiff == 1 
        | player == White = rowDiff == -1 
        | otherwise = False
    isOpponentPiece r c = r >= 0 && r < 8 && c >= 0 && c < 8 && board !! r !! c == nextPlayer player
    makeCaptureMove
        | rowTo == 7 && player == Black = Just $ replaceAt rowTo colTo KingB $ replaceAt (rowFrom + signum rowDiff) (colFrom + signum colDiff) Empty $ replaceAt rowFrom colFrom Empty board
        | rowTo == 0 && player == White = Just $ replaceAt rowTo colTo KingW $ replaceAt (rowFrom + signum rowDiff) (colFrom + signum colDiff) Empty $ replaceAt rowFrom colFrom Empty board
        | otherwise = Just $ replaceAt rowTo colTo player $ replaceAt (rowFrom + signum rowDiff) (colFrom + signum colDiff) Empty $ replaceAt rowFrom colFrom Empty board
    makeSimpleMove 
        | rowTo == 7 && player == Black = replaceAt rowTo colTo KingB $ replaceAt rowFrom colFrom Empty board
        | rowTo == 0 && player == White = replaceAt rowTo colTo KingW $ replaceAt rowFrom colFrom Empty board
        | otherwise = replaceAt rowTo colTo player $ replaceAt rowFrom colFrom Empty board



replaceAt :: Int -> Int -> a -> [[a]] -> [[a]]
replaceAt row col val matrix = take row matrix ++ [take col (matrix !! row) ++ [val] ++ drop (col + 1) (matrix !! row)] ++ drop (row + 1) matrix


nextPlayer :: Piece -> Piece
nextPlayer Black = White
nextPlayer White = Black
nextPlayer KingB = White
nextPlayer KingW = Black

checkWin :: Board -> Piece -> Bool
checkWin board player = null [() | row <- board, player `elem` row]
