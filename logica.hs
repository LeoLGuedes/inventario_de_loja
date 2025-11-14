module Logica where

import Dados
import Data.Time (UTCTime)
import qualified Data.Map.Strict as Map

-- ADD ITEM


addItem :: UTCTime -> String -> String -> Int -> String -> Inventario -> Either String ResultadoOperacao

addItem tempo itemId nomeItem qtd categoria invent 
  | qtd <= 0 = Left "Quantidade tem que ser maior que zero"
  | otherwise =
      case Map.lookup itemId invent of

        Nothing ->
          let item = Item itemId nomeItem qtd categoria
              novoInv = Map.insert itemId item invent
              logEntry = LogEntry tempo Add (itemId ++ " Criado item " ++ nomeItem) Sucesso
          in Right (novoInv, logEntry)

        Just existente ->
          let novaQtd = quantidade existente + qtd
              atualizado = existente { quantidade = novaQtd }
              novoInv = Map.insert itemId atualizado invent
              logEntry = LogEntry tempo Add (itemId ++ " Atualizada quantidade de " ++ nomeItem) Sucesso
          in Right (novoInv, logEntry)




-- REMOVE ITEM



removeItem :: UTCTime -> String-> Int -> Inventario -> Either String ResultadoOperacao

removeItem tempo itemId qtdRemover invent =
  case Map.lookup itemId invent of

    Nothing ->
      Left ("Item não encontrado " ++ itemId)

    Just item ->
      let qtdAtual = quantidade item
      in if qtdRemover > qtdAtual
          then Left "Estoque faltando"
          else
            let qtdNova = qtdAtual - qtdRemover
                novoInv =
                  if qtdNova == 0
                    then Map.delete itemId invent
                    else Map.insert itemId (item { quantidade = qtdNova }) invent
                logEntry = LogEntry tempo Remove 
                           (itemId ++ ", removidas " ++ show qtdRemover ++ " unidades")
                           Sucesso
            in Right (novoInv, logEntry)



-- UPDATE ITEM


updateItem :: UTCTime -> String -> String -> Int -> String -> Inventario-> Either String ResultadoOperacao

updateItem tempo itemId novoNome novaQtd novaCategoria invent =
  case Map.lookup itemId invent of

    Nothing ->
      Left ("item não encontrado: " ++ itemId)

    Just itemAtual ->
      let itemNovo = itemAtual 
                        { nome = novoNome
                        , quantidade = novaQtd
                        , categoria = novaCategoria
                        }

          novoInv = Map.insert itemId itemNovo invent
          detalhes =
            "Atualizado " ++ itemId 
            ++ ": nome=" ++ novoNome
            ++ ", qtd=" ++ show novaQtd
            ++ ", categoria=" ++ novaCategoria

          logEntry = LogEntry tempo Update detalhes Sucesso

      in Right (novoInv, logEntry)



-- QUERY ITEM

queryItem :: UTCTime -> String -> Inventario -> Either String (Item, LogEntry)
queryItem tempo itemId invent =
  case Map.lookup itemId invent of
    Nothing ->
      let logEntry = LogEntry tempo QueryFail ("consulta falhou: " ++ itemId) (Falha "Item não encontrado")
      in Left ("Item não encontrado: " ++ itemId)

    Just item ->
      let logEntry = LogEntry tempo QueryFail ("consulta ao item " ++ itemId) Sucesso
      in Right (item, logEntry)


-- MOSTRAR ITEM

showItem :: String -> Inventario -> String
showItem itemId invent =
  case Map.lookup itemId invent of
    Nothing -> "Item não encontrado: " ++ itemId
    Just item -> "ID: " ++ itemId ++ "\nNome: " ++ nome item ++"\nQuantidade: " ++ show (quantidade item) ++ "\nCategoria: " ++ categoria item
