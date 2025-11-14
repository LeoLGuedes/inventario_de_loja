module Relatorios where

import Dados
import Data.List (sortOn, groupBy)
import Data.Maybe (mapMaybe)

-- logs que tem falhas
logsDeErro :: [LogEntry] -> [LogEntry]
logsDeErro = filter (\l -> case status l of Falha _ -> True; _ -> False)


historicoPorItem :: String -> [LogEntry] -> [LogEntry]
historicoPorItem itemId =
  filter (\l -> itemId `elem` words (detalhes l))


extrairId :: LogEntry -> Maybe String
extrairId loge =
  case words (detalhes loge) of
    (x:_) -> Just x
    []    -> Nothing

-- ajuda a pegar o maior grupo
maximumByLength :: [[a]] -> Maybe [a]
maximumByLength [] = Nothing
maximumByLength (g:gs) = Just $ foldl (\a b -> if length a >= length b then a else b) g gs

-- item mais movimentado de acordo com a primeira palavra, que é o ID
itemMaisMovimentado :: [LogEntry] -> Maybe String
itemMaisMovimentado logs =
  let
    -- pega apenas IDs válidos
    idsValidos = mapMaybe extrairId logs
  in
    if null idsValidos
      then Nothing
      else
        let idsOrd = sortOn id idsValidos
            grupos = groupBy (==) idsOrd
        in case maximumByLength grupos of
             Nothing      -> Nothing
             Just grupoMaior -> case grupoMaior of
                                  (x:_) -> Just x
                                  []    -> Nothing
