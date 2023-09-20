import RegrasDamas (validateMove, checkWin, canCapture, executeCaptureMove, Piece(..), Board)
import Data.List (intersperse)
import System.Console.Haskeline
import Control.Monad (unless)
import Data.IORef
import System.IO.Unsafe (unsafePerformIO)

-- Sua arte aqui
menuArt :: String
menuArt =
  "        BBBQBBBBBBQdKuJ\n" ++
  "        BBBBBBBBBBBBBBQBQBBBBBBBBBgbUj\n" ++
  "        BBBBBBBBBBBBBBBBBBBQBBBBBQBBBBBBBBBBBBBBBBDXuY\n" ++
  "       IQBBBBBQBBBBBBBBBBBBBQBBBBBBBQBBBBBBBQBBBBBBBBBBBBBBBBZ\n" ++
  "       BBBBQBQBQBBBBBBBBBBBBBBBQBBB         subDBQBBBBBBBBBQBP\n" ++
  "       BBBBBBBQBQBQBBBBBBBBBQBBBBBB                       BBB\n" ++
  "       BBBBBBBBBBBBQBBBBBBBBBBBBBBE                       BQB\n" ++
  "       BBBBBBBBBBBBBBBBBBBQBBBBBBBv                      qQBB\n" ++
  "      kBBBBQBQBBBBBBBQBBBBBBBBBQBQ                       BBBB        iiiv       ri                          u               JvsKqj         vi jukkPU\n" ++
  "      MBBBBBBBBBBBQBBBBBBBBBBBBBBB                       BBBq       BBBBBD   BBBBBBBBB      BBBBQBQB    vBBBBBBBBB        kBQBBBBBQBBB    QBBBBBBBBg\n" ++
  "      BBBBBBBBBBBQBBBQBBBBBBBBBBBB                       BBBY       BQBQBv QBBBBLPBBBBBR  BQBBBBbSgP   QBBBBvgBBBBBE      uBBQB  uBBBBBB  BBBBQ ivi\n" ++
  "      BBQBBBBBBBBBBBBBQBQBBBBBBBBg                       BBB        BBBBB EBBBB    BBBBBiZQBQB        QBBBQ    BBBBBu      BBBB    MQBQBj BBBBu\n" ++
  "      BBBQBBBBBBBQBBBBBBBBBBBBBBBv                      VBBB        BBBBBiBBBBB     BBBBXBBBBM LBBBBB BQBBB     BBBBB      BBQB    iBQBBM BBBQBBBQB\n" ++
  "     iQBBBBBBBBBBBBBQBBBQBQBBBBBB                       QBBB        BBBBQvBBBBBi    BBBBvBBBQBr JBQBQ BBBBB     BBQBK      BBBB    BBBBBY BBBBBdgBv\n" ++
  "     PBBBBBBBBBBBQBBBBBBBBBBBQBQB                       BQBd       rBBBBB  QBQBQQ  BBBBQ  BBBBBBBBBBB iBBBBBg  BBBBB      jQBQB  sBQBBBB  BBBBS\n" ++
  "     BBBQBBBQBBBBBBBBBBBBBBBBBBBB                       BBQY   BBBQBBBBB    BBBBBBBBQBY    BBBBBBBBBB   BBBBBBBBBBi       IBBBBBBBBBBB    BBBBBBBBBB\n" ++
  "     BBBL  LUKZBBBBQBQBBBBBBBBBBV                       BQB    qBBBRV          VgBMr          jISIs       iSgBgi           uVkSggS        sIuYXKPPDg\n" ++
  "     BBB                  vkSPbBBBBBBBBBBQqIJ           BBB\n" ++
  "    iBBB                       RBBBBBBBBBBBBBBBBBBBBBBBBBBB           g                 k                                g                    vVDRgi\n" ++
  "    KBBB                       BBBBBBBBBBBBgPdRBBBBBBBBBBBQ         BBQB              uBBB             BQBBB           BBBQ                uBBBBBBBB\n" ++
  "    BBBB                       BBBBQB      BBBRi    uBBBBBV      bBBBBBBB           SBBBBBB           BBBBBB        EBBBBBBB              BBBQBBBI\n" ++
  "    BBBP                      rBBBBBBV     BBBBBBQ     BBB       qBBBBBBBB         XQBBBQBBBL        BBBBBBB        KBBBQBQBB            EBBBBBB\n" ++
  "    BBB                       qBBQBBBq    iBBBBBBBB     QB         QBBBQBBB         XBBBBBBBBZ     uBBBBBBBB          BBBQBBBQ           BBBBBBB\n" ++
  "    QBB                       BBBBBBBD    vBQBBBBBBu              BBQBBBBBBB         BBBBBBBBBB   dBBBBBBBBB         BBBBBBBBBB          BBBBBBB\n" ++
  "   sBBB                       BBBBBBBM    YBBBBQBQBB             BBBBBBBBBBBBv      vBBBBQBBBBBBiRBBBBBQBBBB        BBBBBBBQBQBBL        BBBBBBBK\n" ++
  "   QBBB                       BBBBBBBQ    YBQBQBBBQB            BBQBg BBQBBBBBu     vBBB BBBBBBBBBBB BBQBBBBB       BBBBZ BBBBBBBBj       qBBBBBBB\n" ++
  "   BBBQ                       BBBBBBBg    sBBBBBBBBB           BBBBL   BBBBBBBBX    vBBBr QBBBBBBBB  BBBBBBB      BBBBs   BQBBBBBBV       BBBBBQB\n" ++
  "   BBBY                      uBBBBBBBg    vBBBQBBBBu          BBQB  QBi BBBBBBBBg   vBBBv  SQBQBBD   BBBBBBB     BBBQ  BBi BBBBBBBBd      BBBBQBQK\n" ++
  "   BBQ                       gBBBBBBBP    rBBBBBBBB         sQBQB LBBQBQ QBBBBBBBQ  vBBBs   iBBBj    BBBBBBB   LBBBB uBBBBQ BBBBBQBBB     vBBBBQBq\n" ++
  "  uBBBQQdPUJ                 BBBBBQBBX     BBBBBBB     BQ  XBBBB BBBBBBBB BBQBBBBBB iBBBY     B      BBBBBBB  VBBBQ BBBBBBBB BQBBBQBBi    BBBBBB\n" ++
  "  QBBBBQBBBBBBBBBBBBBBBDbUu  BBBBBBBBr     BBBBR     gBBB BBBBB  BBBBBBBB  BBBBBBBB iBBBI            BBBBBBB BBBBB  BBBBBBBB  BQBBBQBBi   BBBQBBU\n" ++
  "  iqqDQBBBQBBBBBQBBBBBBBBBQBBBBBBBBBBD     ii  iUBBBQBQBY MBBB     RBBB     BBBBBL  LBBBU            BQBBBBB BBBQ     RBBB     BBBBBL uBBBBBBBB\n" ++
  "                 ijkdRBBBBBBBBBQBQBBBBBQBBBBBBBBBBBBBBBB   VB                BB     SBq              XPUkSK   bB                BB     BBQBRu\n" ++
  "                                 suXbBBBQBBBQBBBQBBBBBBB\n" ++
  "                                                iskKQBBQ\n"

-- Variável global para controlar se a arte já foi exibida
artExibidaRef :: IORef Bool
artExibidaRef = unsafePerformIO (newIORef False)


-- Função para imprimir a arte apenas na primeira execução
printMenuArtOnce :: IO ()
printMenuArtOnce = do
    artExibida <- readIORef artExibidaRef
    unless artExibida $ do
        putStrLn menuArt
        writeIORef artExibidaRef True

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
                    putStrLn menuArt  -- Imprime o menu de arte
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
    -- Inicializa a variável global como False na primeira execução
    artExibidaRef <- newIORef False
    putStrLn "Bem-vindo ao jogo de damas!"
    printBoard createInitialBoard
    playGame createInitialBoard Black

