import RegrasDamas (validateMove, checkWin, canCapture, executeCaptureMove, Piece(..), Board)
import Data.List (intersperse)
import System.Console.Haskeline
import Menu

countPiece :: Piece -> Board -> Int
countPiece piece board = sum [ length (filter (== piece) row) | row <- board ]

printBoard :: Board -> IO ()
printBoard board = do
    putStrLn $ unlines (legend : countPieces : headerRow : map showRow (zip [0..] board))
  where
    showRow (rowNum, row) = show rowNum ++ " " ++ intersperse ' ' (map showPiece row)
    showPiece Empty = '.'
    showPiece Black = 'B'
    showPiece White = 'W'
    headerRow = "\n  " ++ unwords (map show [0..7])
    legend = "\nLegenda: B - Peça Preta | W - Peça Branca"
    countBlack = countPiece Black board
    countWhite = countPiece White board
    countPieces = "Peças Pretas (B): " ++ show countBlack ++ " | Peças Brancas (W): " ++ show countWhite

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

playGame :: Board -> Piece -> IO ()
playGame board player = do
    putStrLn $ "Jogador atual: " ++ show player
    putStrLn "Caso queira finalizar o programa, pressione CTRL + C"
    putStrLn "Informe a jogada (linhaOrigem colunaOrigem linhaDestino colunaDestino): "
    input <- runInputT defaultSettings getLine'
    case map read (words input) of
        [rowFrom, colFrom, rowTo, colTo] -> 
            case validateMove board player rowFrom colFrom rowTo colTo of
                Just newBoard -> do
                    printBoard newBoard
                    if checkWin newBoard player
                        then putStrLn $ "Jogador " ++ show player ++ " venceu!"
                        else if canCapture newBoard player rowTo colTo
                            then do
                                putStrLn "Captura disponível. Informe a próxima captura (linhaDestino colunaDestino): "
                                input' <- runInputT defaultSettings getLine'
                                case map read (words input') of
                                    [nextRow, nextCol] ->
                                        case validateMove newBoard player rowTo colTo nextRow nextCol of
                                            Just newerBoard -> playGame (executeCaptureMove newerBoard player rowTo colTo nextRow nextCol) player
                                            Nothing -> do
                                                putStrLn "Jogada de captura inválida, tente novamente."
                                                playGame newBoard player
                                    _ -> do
                                        putStrLn "Jogada inválida, tente novamente."
                                        playGame newBoard player
                            else playGame newBoard (nextPlayer player)
                Nothing -> do
                    putStrLn "Jogada inválida, tente novamente\n"
                    playGame board player
        _ -> do
            putStrLn "Jogada inválida, tente novamente\n"
            playGame board player
  where
    getLine' = getInputLine "" >>= maybe (return "") return

nextPlayer :: Piece -> Piece
nextPlayer Black = White
nextPlayer White = Black

main :: IO ()
main = do
    putStrLn menuArt
    let initialBoard = createInitialBoard
    printBoard initialBoard
    playGame initialBoard Black