#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
14. Blocos de Código
Diferentemente de uma matriz, não se pode acessar elementos de um bloco de código, através de um índice numérico. 
Porém blocos de código são semelhantes a uma lista de expressões, e a uma pequena função.
Ou seja, podem ser executados. Para a execução, ou avaliação de um bloco de código, deve-se utilizar a função Eval():
nRes := Eval(B) ==> 20
Essa função recebe como parâmetro um bloco de código e avalia todas as expressões contidas neste bloco de código, 
retornando o resultado da última expressão avaliada.

EVAL(bBloco, xParam1, xParam2, xParamZ)
A função EVAL() é utilizada para avaliação direta de um bloco de código, utilizando as informações disponíveis no 
momento de sua execução. Esta função permite a definição e passagem de diversos parâmetros que serão considerados 
na interpretação do bloco de código.

EXEMPLO:
O retorno será dado pela avaliação da ultima ação da lista de expressões, no caso “z”.
Cada uma das variáveis definidas, em uma das ações da lista de expressões, fica disponível para a próxima ação.
Desta forma temos:
N ? recebe nInt como parâmetro (10)
X ? tem atribuído o valor 10 (10)
Y ? resultado da multiplicação de X por N (100)
Z ? resultado da divisão de Y pela multiplicação de X por N ( 100 / 100) ? 1
*/

User Function CNBL001()
    Local aArea := GetArea()
    Local nINt := 10
    
    //N == nInt devido a passagem do valor em Eval()
    bBloco := {|N| x:= 10, y:= x * N, z:= y / (X * N)}

    //EVAL(bBloco, xParam1, xParam2, xParamZ)
    nValor := Eval(bBloco, nInt)

    MsgInfo(nValor)

    RestArea(aArea)

Return



/*
DBEVAL(bBloco, bFor, bWhile)
A função DBEval() permite que todos os registros, de uma determinada tabela, 
sejam analisados e para cada registro será executado o bloco de código definido.
*/


User Function LblocoVII()
    Local aArea := GetArea()
    Local nCnt := ""

    dbSelectArea("SX5") //Selecionando tabela a ser usada
    dbSetOrder(1) //Definindo Indice
    dbGoTop() //Após encerramento voltar ao topo da tabela.
/*
    While !Eof() .And. X5_FILIAL == xFilial("SX5") .And.; X5_TABELA <=cTab
    nCnt++
    dbSkip()
    EndDo
*/
    dbEval({|X| nCnt ++},,{||X5_FILIAL == xFilial("SX5") .AND. X5_TABELA <= cTab})

    nResp := Eval(nResp)
    
    RestArea(aArea)
Return

/*
AEVAL(aArray, bBloco, nInicio, nFim)
A função AEVAL() permite que todos os elementos de um determinada array sejam analisados e para cada elemento 
será executado o bloco de código definido.

Considerando o trecho de código abaixo:

AADD(aCampos,”A1_FILIAL”)
AADD(aCampos,”A1_COD”)
SX3->(dbSetOrder(2))
For nX:=1 To Len(aCampos)
SX3->(dbSeek(aCampos[nX]))
aAdd(aTitulos,AllTrim(SX3->X3_TITULO))
Next nX

O mesmo pode ser re-escrito com o uso da função AEVAL():

aEval(aCampos,{|x| SX3->(dbSeek(x)),IIF(Found(), AAdd(aTitulos,AllTrim(SX3->X3_TITULO)))})

*/
