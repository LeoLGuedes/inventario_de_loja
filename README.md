Pontifícia Universidade Católica do Paraná  

Programação Lógica e Funcional  

Frank Coelho de Alcantara  

Leonardo Lino Guedes - @LeoLGuedes  


## Visão Geral  

Este projeto, é um projeto de inventario de loja. E possui operações de insserção/remoção de dados, assim como atualizações e consultas. Tudo isso interagindo com uma base de dados e geração de logs e relatórios. Alem disso, lista todas as ações em um arquivo de auditoria persistente.  
O sistema esta dividido em módulos, ficando assim bem organizado.  
Os cenários de teste solicitados foram realizados com sucesso, validando tanto a persistência de estado quanto o tratamento de erros e a geração de relatórios.


## Como compilar e Executar (no GDB)  

Basta baixar os arquivos deste repositório e fazer o upload deles dentro da plataforma do GDB, após isso rode o codigo do main e ira executar.  

# Cenários de Teste  
## Cenário 1 — Persistência  

(iniciar o programa no 'run')  
Sistema vai criar um inventário vazio  
Ira aparecer a seguinte tela para você:  

SISTEMA DE INVENTARIO  
1, Adicionar Item  
2. Remover item  
3. Atualizar Item  
4. Consultar Item  
5. Listar Inventario  
6. Gerar Relatório  
7. Sair  
Escolha uma opção:  

#### Você deverá seguir a seguinte ordem para fazer as 3 inserções:  

1   (opção adicionar)  
ID: 1   (ou qualquer outro id de preferencia)  
Nome: mouse   
Categoria: periferico  
Quantidade: 5  

1  
ID: 2  
Nome: teclado  
Categoria: periferico  
Quantidade: 10  

1  
ID: 3  
Nome: Monitor  
Categoria: periferico  
Quantidade: 2  

7 (opção sair)  

#### Os arquivos (Inventario.dat criado e Auditoria.log criado) vão ser criados  

(iniciar o programa no 'run' novamente)  

SISTEMA DE INVENTARIO  
1. Adicionar Item  
2. Remover item  
3. Atualizar Item  
4. Consultar Item  
5. Listar Inventario  <-(usar essa opção agora, para listar o que foi adicionado)  
6. Gerar Relatório  
7. Sair  
Escolha uma opção:  

## Cenário 2 — Erro de lógica (Estoque insuficiente)  
(iniciar o programa no 'run')  

#### (adiciona 10 teclados):  

1  
ID: 2  
Nome: teclado  
Categoria: periferico  
Quantidade: 10  

#### (tentar remover 15):

2  
ID: 2  
Quantidade removida: 15  

#### (o programa vai exibir):  
Erro: Estoque faltando  

#### (porém ao usar o comando listar o item permanece com sua quantidade normal):  

5  (listar)  
teclado → quantidade = 10  

#### ( e o log contem a falha):  

(Falha "Estoque faltando")  

## Cenário 3 — Relatório de erros:  

#### (executar comando relatorio/report - opção 6):  

6  
(relatório de erros exibido)  

#### (vai aparecer a falha do cenário 2):  

RELATÓRIO DE ERROS  
timestamp = (de acordo com a hora atual), Acao = Remove, detalhes = "Falha ao remover: 2 <-(ID do item esse aqui), status: Falha: "Estoque faltando"  


## Exemplo de uso

#### (rode o projeto no 'run')  
(ira aparecer a interface no terminal):

SISTEMA DE INVENTARIO  
1. Adicionar Item       <- (uasr essa opção para adicionar)  
2. Remover item         <- (usar essa opção para remover uma quantidade)  
3. Atualizar Item       <- (usar essa opção para atualizar um item especifico)  
4. Consultar Item       <- (usar essa opção para analisar um item em especifico)   
5. Listar Inventario    <- (usar essa opção para listar o inventaario com todos os itens)  
6. Gerar Relatório      <- (usar essa opção para mostrar os relatórios de erro, de item mais movido, e histórico de um item de acordo com seu ID digitado posteriormente)  
7. Sair                 <- (usar essa opção para sair)  
Escolha uma opção:

### Adicionando um item:

1  
ID: 34  
Nome: celular  
Categoria: smartphone  
Quantidade: 10  

### Removendo um item:

2  
ID: 34  
Quantidade removida: 10  

### Listar o inventario de itens:

(apenas escolha a opção 5 no menu)

# link do projeto no GDB: https://onlinegdb.com/J5LoTGD5E














