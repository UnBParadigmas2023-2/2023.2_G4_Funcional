-- RegrasDamas.hs

module RegrasDamas
    ( validateMove
    , checkWin
    , checkDraw
    , canCapture
    , executeCaptureMove
    , Piece(..)
    , Board
    -- ... e possivelmente outras funções e tipos que você queira exportar
    ) where


import Data.List

data Piece = Empty | Black | White deriving (Eq, Show)
type Board = [[Piece]]

validateMove :: Board -> Piece -> Int -> Int -> Int -> Int -> Maybe Board
validateMove board player rowFrom colFrom rowTo colTo
    | outOfBounds || notPlayerPiece || notEmpty || invalidMove = Nothing
    | isCaptureMove = makeCaptureMove
    | isSimpleMove = Just makeSimpleMove
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
    invalidMove = outOfBounds || notPlayerPiece || notEmpty || (not isCaptureMove && not isSimpleMove)
    makeCaptureMove = Just $ executeCaptureMove board player rowFrom colFrom rowTo colTo
    makeSimpleMove = replaceAt rowTo colTo player $ replaceAt rowFrom colFrom Empty board


executeCaptureMove :: Board -> Piece -> Int -> Int -> Int -> Int -> Board
executeCaptureMove board player rowFrom colFrom rowTo colTo =
    let intermediateBoard = replaceAt rowTo colTo player $ replaceAt (rowFrom + signum (rowTo - rowFrom)) (colFrom + signum (colTo - colFrom)) Empty $ replaceAt rowFrom colFrom Empty board
    in intermediateBoard  -- Mantenha a captura na mesma função, e o controle será passado de volta ao main.hs

canCapture :: Board -> Piece -> Int -> Int -> Bool
canCapture board player row col =
    any (\(rowDiff, colDiff) -> isValidCapture board player row col (row + rowDiff) (col + colDiff)) captureDirections
  where
    captureDirections = [(1, 1), (1, -1), (-1, 1), (-1, -1)]

isValidCapture :: Board -> Piece -> Int -> Int -> Int -> Int -> Bool
isValidCapture board player rowFrom colFrom rowTo colTo =
    let rowDiff = rowTo - rowFrom
        colDiff = colTo - colFrom
    in abs rowDiff == 2 && abs colDiff == 2 && isOpponentPiece (rowFrom + signum rowDiff) (colFrom + signum colDiff)
  where
    isOpponentPiece r c = r >= 0 && r < 8 && c >= 0 && c < 8 && board !! r !! c == nextPlayer player

replaceAt :: Int -> Int -> a -> [[a]] -> [[a]]
replaceAt row col val matrix = take row matrix ++ [take col (matrix !! row) ++ [val] ++ drop (col + 1) (matrix !! row)] ++ drop (row + 1) matrix


nextPlayer :: Piece -> Piece
nextPlayer Black = White
nextPlayer White = Black

checkWin :: Board -> Piece -> Bool
checkWin board player = null [() | row <- board, player `elem` row]

checkDraw :: Board -> Piece -> Bool
checkDraw board player =   null $ [() | row <- bord, Piece player `elem` row]
