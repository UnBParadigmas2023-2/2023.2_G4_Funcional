import RegrasDamas (validateMove, checkWin, Piece(..), Board)
import Data.List (intersperse)
import System.Console.Haskeline

printBoard :: Board -> IO ()
printBoard board = putStrLn $ unlines (legend : headerRow : map showRow (zip [0..] board))
  where
    showRow (rowNum, row) = show rowNum ++ " " ++ intersperse ' ' (map showPiece row)
    showPiece Empty = '.'
    showPiece Black = 'B'
    showPiece White = 'W'
    headerRow = "  " ++ unwords (map show [0..7])
    legend = "Legenda: B - Peça Preta, W - Peça Branca"

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
                        else playGame newBoard (nextPlayer player)
                Nothing -> do
                    putStrLn "Jogada inválida, tente novamente."
                    playGame board player
        _ -> do
            putStrLn "Jogada inválida, tente novamente."
            playGame board player
  where
    getLine' = getInputLine "" >>= maybe (return "") return

nextPlayer :: Piece -> Piece
nextPlayer Black = White
nextPlayer White = Black

main :: IO ()
main = do
    let initialBoard = createInitialBoard
    printBoard initialBoard
    playGame initialBoard Black
