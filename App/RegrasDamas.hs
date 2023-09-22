module RegrasDamas
    ( validateMove
    , checkWin
    , checkDraw
    , canCapture
    , executeCaptureMove
    , Piece(..)
    , Board
    ) where

import Data.List

data Piece = Empty | Black | White | King Piece deriving (Eq, Show)
type Board = [[Piece]]

validateMove :: Board -> Piece -> Int -> Int -> Int -> Int -> Maybe Board
validateMove board player rowFrom colFrom rowTo colTo
    | outOfBounds || notPlayerPiece || notEmpty || invalidMove = Nothing
    | isCaptureMove = makeCaptureMove
    | isSimpleMove = Just makeSimpleMove
  where
    outOfBounds = any (\x -> x < 0 || x >= 8) [rowFrom, colFrom, rowTo, colTo]
    notPlayerPiece
        | isKingPiece = board !! rowFrom !! colFrom /= King player
        | otherwise = board !! rowFrom !! colFrom /= player
    notEmpty = board !! rowTo !! colTo /= Empty
    rowDiff = rowTo - rowFrom
    colDiff = colTo - colFrom
    isCaptureMove
        | isKingPiece && rowDiff < 0 =  abs rowDiff >= 1 && abs rowDiff <= 7 && abs colDiff >= 1 && abs colDiff <= 7 && isOpponentPiece (rowTo + 1) (colTo + 1)
        | isKingPiece && rowDiff > 0 =  abs rowDiff >= 1 && abs rowDiff <= 7 && abs colDiff >= 1 && abs colDiff <= 7 && isOpponentPiece (rowTo - 1) (colTo - 1)
        | otherwise =  abs rowDiff == 2 && abs colDiff == 2 && isOpponentPiece (rowFrom + signum rowDiff) (colFrom + signum colDiff)
    isSimpleMove
        | isKingPiece = abs rowDiff <= 7 && abs rowDiff > 0  && abs colDiff <= 7 && abs colDiff > 0
        | otherwise = abs rowDiff == 1 && abs colDiff == 1 && isValidDirection
    isValidDirection
        | player == Black = rowDiff == 1
        | player == White = rowDiff == -1
        | otherwise = False
    isOpponentPiece r c = r >= 0 && r < 8 && c >= 0 && c < 8 && board !! r !! c == nextPlayer player
    isKingPiece = board !! rowFrom !! colFrom == King player
    makeCaptureMove
        | isKingPiece && rowDiff < 0 && colDiff < 0 = Just $ replaceAt rowTo colTo (King player) $ replaceAt (rowTo + 1) (colTo + 1) Empty $ replaceAt rowFrom colFrom Empty board
        | isKingPiece && rowDiff > 0 && colDiff > 0 = Just $ replaceAt rowTo colTo (King player) $ replaceAt (rowTo - 1) (colTo - 1) Empty $ replaceAt rowFrom colFrom Empty board
        | isKingPiece && rowDiff > 0 && colDiff < 0 = Just $ replaceAt rowTo colTo (King player) $ replaceAt (rowTo - 1) (colTo + 1) Empty $ replaceAt rowFrom colFrom Empty board
        | isKingPiece && rowDiff < 0 && colDiff > 0 = Just $ replaceAt rowTo colTo (King player) $ replaceAt (rowTo + 1) (colTo - 1) Empty $ replaceAt rowFrom colFrom Empty board
        | rowTo == 7 && player == Black = Just $ replaceAt rowTo colTo (King Black) $ replaceAt (rowFrom + signum rowDiff) (colFrom + signum colDiff) Empty $ replaceAt rowFrom colFrom Empty board
        | rowTo == 0 && player == White = Just $ replaceAt rowTo colTo (King White) $ replaceAt (rowFrom + signum rowDiff) (colFrom + signum colDiff) Empty $ replaceAt rowFrom colFrom Empty board
        | otherwise = Just $ executeCaptureMove board player rowFrom colFrom rowTo colTo
    makeSimpleMove 
        | rowTo == 7 && player == Black = replaceAt rowTo colTo (King Black) $ replaceAt rowFrom colFrom Empty board
        | rowTo == 0 && player == White = replaceAt rowTo colTo (King White) $ replaceAt rowFrom colFrom Empty board
        | isKingPiece = replaceAt rowTo colTo (King player) $ replaceAt rowFrom colFrom Empty board
        | otherwise = replaceAt rowTo colTo player $ replaceAt rowFrom colFrom Empty board
    invalidMove = outOfBounds || notPlayerPiece || notEmpty || (not isCaptureMove && not isSimpleMove)
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
nextPlayer (King Black) = White
nextPlayer (King White) = Black

checkWin :: Board -> Piece -> Bool
checkWin board player =
    all (\row -> all (\piece -> piece /= nextPlayer player) row) board

checkDraw :: Board -> Bool
checkDraw board =
    not (any (canMove board Black) [0..7]) && not (any (canMove board White) [0..7])
  where
    canMove :: Board -> Piece -> Int -> Bool
    canMove b player row =
        any (\col -> any (\r -> any (\c -> isNothing (validateMove b player row col r c)) [0..7]) [0..7]) [0..7]