module Persistencia 
  ( carregarInventario
  , carregarLogs
  , salvarInventario
  , registrarLog
  , registrarFalha
  ) where

import System.IO
import Control.Exception (catch, IOException)
import Data.Time (UTCTime)
import qualified Data.Map.Strict as Map

import Dados

arquivoInventario :: FilePath
arquivoInventario = "Inventario.dat"

arquivoLog :: FilePath
arquivoLog = "Auditoria.log"


--  CARREGAR INVENTARIO


carregarInventario :: IO Inventario
carregarInventario =
  (do conteudo <- readFile arquivoInventario
      let inv = read conteudo :: Inventario
      return inv
  ) `catch` handler
  where
    handler :: IOException -> IO Inventario
    handler _ = do
      putStrLn "Inventario.dat não encontrado. Criando inventário vazio"
      return Map.empty


--  CARREGAR LOGS


carregarLogs :: IO [LogEntry]
carregarLogs =
  (do txt <- readFile arquivoLog
      let entradas = map read (lines txt) :: [LogEntry]
      return entradas
  ) `catch` handler
  where
    handler :: IOException -> IO [LogEntry]
    handler _ = do
      putStrLn "Auditoria.log não encontrado. Iniciando log vazio"
      return []



--  SALVAR INVENTARIO

salvarInventario :: Inventario -> IO ()
salvarInventario inv =
  writeFile arquivoInventario (show inv)




--  REGISTRAR LOG


registrarLog :: LogEntry -> IO ()
registrarLog entry = appendFile arquivoLog (show entry ++ "\n")


--  REGISTRAR FALHA AUTOMATIZADA


registrarFalha :: UTCTime -> String -> String -> IO ()
registrarFalha momento acaoStr msgErro = do
  let logEntry = LogEntry 
                  momento
                  QueryFail
                  ("Falha na ação " ++ acaoStr ++ ": " ++ msgErro)
                  (Falha msgErro)
  registrarLog logEntry
