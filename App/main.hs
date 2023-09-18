import Data.List

data Piece = Empty | Black | White deriving (Eq, Show)

type Board = [[Piece]]

printBoard :: Board -> IO ()
printBoard board = putStrLn $ unlines (legend : headerRow : map showRow (zip [0..] board))
  where
    showRow (rowNum, row) = show rowNum ++ " " ++ intersperse ' ' (map showPiece row)
    showPiece Empty = '.'
    showPiece Black = 'B'
    showPiece White = 'W'
    headerRow = "  " ++ unwords (map show [0..7])  -- Cabeçalho das colunas
    legend = "Legenda: B - Peça Preta, W - Peça Branca"  -- Legenda no canto do tabuleiro

main :: IO ()
main = do
    let initialBoard = createInitialBoard
    printBoard initialBoard
    playGame initialBoard Black

createInitialBoard :: Board
createInitialBoard = 
    [ [Empty, Black, Empty, Black, Empty, Black, Empty, Black]
    , [Black, Empty, Black, Empty, Black, Empty, Black, Empty]
    , [Empty, Black, Empty, Black, Empty, Black, Empty, Black]
    , [Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty]
    , [Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty]
    , [White, Empty, White, Empty, White, Empty, White, Empty]
    , [Empty, White, Empty, White, Empty, White, Empty, White]
    , [White, Empty, White, Empty, White, Empty, White, Empty]
    ]

-- Resto do código permanece o mesmo



playGame :: Board -> Piece -> IO ()
playGame board player = do
    putStrLn $ "Jogador atual: " ++ show player
    putStrLn "Informe a jogada (linha coluna): "
    input <- getLine
    let [row, col] = map read (words input)
    case validateMove board player row col of
        Just newBoard -> do
            printBoard newBoard
            if checkWin newBoard player
                then putStrLn $ "Jogador " ++ show player ++ " venceu!"
                else playGame newBoard (nextPlayer player)
        Nothing -> do
            putStrLn "Jogada inválida, tente novamente."
            playGame board player


validateMove :: Board -> Piece -> Int -> Int -> Maybe Board
validateMove board player row col
    | outOfBounds || notEmpty = Nothing
    | isCaptureMove = makeCaptureMove
    | isSimpleMove = Just makeSimpleMove
    | otherwise = Nothing
  where
    outOfBounds = row < 0 || row >= 8 || col < 0 || col >= 8
    notEmpty = board !! row !! col /= Empty
    rowFrom = findPieceRow player board
    colFrom = findPieceCol player (board !! rowFrom)
    rowDiff = row - rowFrom
    colDiff = col - colFrom
    isCaptureMove = abs rowDiff == 2 && abs colDiff == 2 && isOpponentPiece (rowFrom + signum rowDiff) (colFrom + signum colDiff)
    isSimpleMove = abs rowDiff == 1 && abs colDiff == 1 && isValidDirection
    isValidDirection
        | player == Black = rowDiff == 1
        | player == White = rowDiff == -1
        | otherwise = False  -- Inclua esse caso para evitar um erro de compilação
    isOpponentPiece r c = r >= 0 && r < 8 && c >= 0 && c < 8 && board !! r !! c == nextPlayer player
    makeCaptureMove = Just $ replaceAt row col player $ replaceAt (rowFrom + signum rowDiff) (colFrom + signum colDiff) Empty $ replaceAt rowFrom colFrom Empty board
    makeSimpleMove = replaceAt row col player $ replaceAt rowFrom colFrom Empty board

replaceAt :: Int -> Int -> a -> [[a]] -> [[a]]
replaceAt row col val matrix = take row matrix ++ [take col (matrix !! row) ++ [val] ++ drop (col + 1) (matrix !! row)] ++ drop (row + 1) matrix

findPieceRow :: Piece -> Board -> Int
findPieceRow piece board = case findIndex (elem piece) board of
    Just row -> row
    Nothing -> -1

findPieceCol :: Piece -> [Piece] -> Int
findPieceCol piece row = case elemIndex piece row of
    Just col -> col
    Nothing -> -1

nextPlayer :: Piece -> Piece
nextPlayer Black = White
nextPlayer White = Black

checkWin :: Board -> Piece -> Bool
checkWin board player = null [() | row <- board, player `elem` row]
