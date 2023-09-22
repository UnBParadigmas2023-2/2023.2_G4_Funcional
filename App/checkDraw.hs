-- checDraw.hs

module checkDraw
    ( checkDraw
    , Piece(..)
    , Board
    -- ... e possivelmente outras funções e tipos que você queira exportar
    ) where

import Data.List

data Piece = Empty | Black | White deriving (Eq, Show)
type Board = [[Piece]]

checkDraw :: Board -> Piece -> Bool
checkDraw board player =   null $ [() | row <- bord, Piece player `elem` row]