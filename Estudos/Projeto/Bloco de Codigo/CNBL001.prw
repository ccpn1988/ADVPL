#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
14. Blocos de C�digo
Diferentemente de uma matriz, n�o se pode acessar elementos de um bloco de c�digo, atrav�s de um �ndice num�rico. 
Por�m blocos de c�digo s�o semelhantes a uma lista de express�es, e a uma pequena fun��o.
Ou seja, podem ser executados. Para a execu��o, ou avalia��o de um bloco de c�digo, deve-se utilizar a fun��o Eval():
nRes := Eval(B) ==> 20
Essa fun��o recebe como par�metro um bloco de c�digo e avalia todas as express�es contidas neste bloco de c�digo, 
retornando o resultado da �ltima express�o avaliada.

EVAL(bBloco, xParam1, xParam2, xParamZ)
A fun��o EVAL() � utilizada para avalia��o direta de um bloco de c�digo, utilizando as informa��es dispon�veis no 
momento de sua execu��o. Esta fun��o permite a defini��o e passagem de diversos par�metros que ser�o considerados 
na interpreta��o do bloco de c�digo.

EXEMPLO:
O retorno ser� dado pela avalia��o da ultima a��o da lista de express�es, no caso �z�.
Cada uma das vari�veis definidas, em uma das a��es da lista de express�es, fica dispon�vel para a pr�xima a��o.
Desta forma temos:
N ? recebe nInt como par�metro (10)
X ? tem atribu�do o valor 10 (10)
Y ? resultado da multiplica��o de X por N (100)
Z ? resultado da divis�o de Y pela multiplica��o de X por N ( 100 / 100) ? 1
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
A fun��o DBEval() permite que todos os registros, de uma determinada tabela, 
sejam analisados e para cada registro ser� executado o bloco de c�digo definido.
*/


User Function LblocoVII()
    Local aArea := GetArea()
    Local nCnt := ""

    dbSelectArea("SX5") //Selecionando tabela a ser usada
    dbSetOrder(1) //Definindo Indice
    dbGoTop() //Ap�s encerramento voltar ao topo da tabela.
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
A fun��o AEVAL() permite que todos os elementos de um determinada array sejam analisados e para cada elemento 
ser� executado o bloco de c�digo definido.

Considerando o trecho de c�digo abaixo:

AADD(aCampos,�A1_FILIAL�)
AADD(aCampos,�A1_COD�)
SX3->(dbSetOrder(2))
For nX:=1 To Len(aCampos)
SX3->(dbSeek(aCampos[nX]))
aAdd(aTitulos,AllTrim(SX3->X3_TITULO))
Next nX

O mesmo pode ser re-escrito com o uso da fun��o AEVAL():

aEval(aCampos,{|x| SX3->(dbSeek(x)),IIF(Found(), AAdd(aTitulos,AllTrim(SX3->X3_TITULO)))})

*/
