module Dados where

import Data.Map.Strict (Map)
import Data.Time (UTCTime)


-- Representa um item no inventario
data Item = Item{ itemID:: String, nome :: String, quantidade :: Int, categoria  :: String }
  deriving (Show, Read, Eq)

-- O inventario é um Map de ID 
type Inventario = Map String Item

-- Ações permitidas no log
data AcaoLog = Add | Remove | Update | QueryFail
  deriving (Show, Read, Eq)

-- Sucesso ou falha com mensagem
data StatusLog = Sucesso | Falha String
  deriving (Show, Read, Eq)

-- Estrutura completa de log
data LogEntry = LogEntry{ timestamp :: UTCTime, acao:: AcaoLog, detalhes :: String, status:: StatusLog}
  deriving (Show, Read, Eq)

-- Operações retornam o inventario atualizado e um log
type ResultadoOperacao = (Inventario, LogEntry)
