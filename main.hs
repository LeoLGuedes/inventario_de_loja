module Main where

import Dados
import Logica
import Persistencia (carregarInventario, salvarInventario, registrarLog, registrarFalha, carregarLogs)
import Relatorios


import Data.Time (getCurrentTime)
import qualified Data.Map as Map
import System.IO (hFlush, stdout)


-- Funções auxiliares de I/O


prompt :: String -> IO String
prompt texto = do
    putStr texto
    putStr " "
    hFlush stdout
    getLine

pausar :: IO ()
pausar = do
    putStrLn "Pressione ENTER para continuar"
    _ <- getLine
    return ()


-- Menu principal


menu :: Inventario -> [LogEntry] -> IO ()
menu inventario logs = do
    putStrLn "\nSISTEMA DE INVENTARIO"
    putStrLn "1. Adicionar item"
    putStrLn "2. Remover item"
    putStrLn "3. Atualizar item"
    putStrLn "4. Consultar item"
    putStrLn "5. Listar inventario"
    putStrLn "6. Gerar relatório"
    putStrLn "7. Sair"
    putStr   "Escolha uma opção: "
    hFlush stdout

    opcao <- getLine
    case opcao of
        "1" -> adicionar inventario logs
        "2" -> remover inventario logs
        "3" -> atualizar inventario logs
        "4" -> consultar inventario logs
        "5" -> listar inventario logs
        "6" -> relatorio inventario logs
        "7" -> putStrLn "Finalizando o programa"
        _   -> do
            putStrLn "Opção inválida."
            menu inventario logs



-- Cada operação do menu

adicionar :: Inventario -> [LogEntry] -> IO ()
adicionar inventario logs = do
    itemID <- prompt "ID do item:"
    nome <- prompt "Nome:"
    categoria <- prompt "Categoria:"
    qtdStr <- prompt "quantidade:"
    let quantidade = read qtdStr :: Int

    agora <- getCurrentTime
    case addItem agora itemID nome quantidade categoria inventario of
        Left erro -> do
            let logFail = LogEntry agora Add ("Falha ao adicionar " ++ itemID) (Falha erro)
            registrarLog logFail
            putStrLn ("Erro: " ++ erro)
            pausar
            menu inventario (logFail : logs)

        Right (novoInv, logOk) -> do
            salvarInventario novoInv
            registrarLog logOk
            putStrLn "item adicionado com sucesso"
            pausar
            menu novoInv (logOk : logs)


remover :: Inventario -> [LogEntry] -> IO ()
remover inventario logs = do
    itemID <- prompt "ID do item:"
    qtdStr <- prompt "Quantidade removida:"
    let qtd = read qtdStr :: Int
    agora <- getCurrentTime

    case removeItem agora itemID qtd inventario of
        Left erro -> do
            let logFail = LogEntry agora Remove ("falha ao remover: " ++ itemID) (Falha erro)
            registrarLog logFail
            putStrLn ("Erro: " ++ erro)
            pausar
            menu inventario (logFail : logs)

        Right (novoInv, logOk) -> do
            salvarInventario novoInv
            registrarLog logOk
            putStrLn "Item removdo com sucesso"
            pausar
            menu novoInv (logOk : logs)


atualizar :: Inventario -> [LogEntry] -> IO ()
atualizar inventario logs = do
    itemID <- prompt "ID:"
    nome <- prompt "Novo nome:"
    categoria <- prompt "Nova categoria:"
    qtdStr <- prompt "Nova quantidade:"
    let qtd = read qtdStr :: Int
    agora <- getCurrentTime

    case updateItem agora itemID nome qtd categoria inventario of
        Left erro -> do
            let logFail = LogEntry agora Update ("Erro ao atualizar: " ++ itemID) (Falha erro)
            registrarLog logFail
            putStrLn ("Erro: " ++ erro)
            pausar
            menu inventario (logFail : logs)

        Right (novoInv, logOk) -> do
            salvarInventario novoInv
            registrarLog logOk
            putStrLn "Item atualizado"
            pausar
            menu novoInv (logOk : logs)


consultar :: Inventario -> [LogEntry] -> IO ()
consultar inventario logs = do
    itemID <- prompt "ID:"
    agora <- getCurrentTime

    case queryItem agora itemID inventario of
        Left erro -> do
            let logFail = LogEntry agora QueryFail ("Consulta falhou: " ++ itemID) (Falha erro)
            registrarLog logFail
            putStrLn ("Erro: " ++ erro)
            pausar
            menu inventario (logFail : logs)

        Right (_, logOk) -> do
            registrarLog logOk
            putStrLn ("Resultado da consulta:")
            putStrLn (showItem itemID inventario)
            pausar
            menu inventario (logOk : logs)


listar :: Inventario -> [LogEntry] -> IO ()
listar inventario logs = do
    putStrLn "\nINVENTARIO COMPLETO"
    mapM_ print (Map.elems inventario)
    pausar
    menu inventario logs


relatorio :: Inventario -> [LogEntry] -> IO ()
relatorio inventario logs = do
    putStrLn "\nRELATÓRIO DE ERROS"
    mapM_ print (logsDeErro logs)
    pausar
    menu inventario logs



-- Função principal

main :: IO ()
main = do
    putStrLn "Carregando inventario"
    inventario <- carregarInventario

    putStrLn "Carregando logs"
    logs <- carregarLogs

    putStrLn "Sistema iniciado"
    menu inventario logs
