module Relatorios where

import Dados
import Data.List (sortOn, groupBy)
import Data.Maybe (mapMaybe)

-- logs contendo falhas
logsDeErro :: [LogEntry] -> [LogEntry]
logsDeErro = filter (\l -> case status l of Falha _ -> True; _ -> False)

-- histórico por ID (simplificado)
historicoPorItem :: String -> [LogEntry] -> [LogEntry]
historicoPorItem itemId =
  filter (\l -> itemId `elem` words (detalhes l))

-- extrai o possível ID do item da primeira palavra do detalhes
-- mantém o nome 'extrairId' como você pediu, mas retorna Maybe
extrairId :: LogEntry -> Maybe String
extrairId loge =
  case words (detalhes loge) of
    (x:_) -> Just x
    []    -> Nothing

-- Auxiliar para pegar o maior grupo (retorna Maybe para evitar partials)
maximumByLength :: [[a]] -> Maybe [a]
maximumByLength [] = Nothing
maximumByLength (g:gs) = Just $ foldl (\a b -> if length a >= length b then a else b) g gs

-- item mais movimentado com base na primeira palavra do detalhe
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
