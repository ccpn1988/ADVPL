#include 'protheus.ch'
#include 'parmtype.ch'

//Diferentemente de uma matriz, n�o se pode acessar elementos de um bloco de c�digo atrav�s
//de um �ndice num�rico. Por�m blocos de c�digo s�o semelhantes a uma lista de express�es, e
//a uma pequena fun��o.
//Ou seja, podem ser executados. Para a execu��o, ou avalia��o, de um bloco de c�digo, devese
//utilizar a fun��o Eval():

//J� que blocos de c�digo s�o como pequenas fun��es, tamb�m � poss�vel a passagem de
//par�metros para um bloco de c�digo. Os par�metros devem ser informados entre as barras
//verticais (||) separados por v�rgulas, assim como em uma fun��o.

//{ | [parametro1],[parametro2],[express�oN] | [expressao1],[expressao2],[express�oN] }

//PASSAGEM POR PAR�METROS
user function zBloco()
Local bBloco := {|cMsg|Alert(cMsg)}
		Eval(bBloco,"Ol� Mundo!")
return

User Function Ola04()
Local bCB := {| x,y,z | y := x/2 , z := x*2 , x%2 == 0 }
Local nTeste := 4
Local lPar
Local nY , nZ
// O bloco de codigo recebe em x o valor de nTeste
// e recebe em y e z a refer�ncia das vari�veis 
// nY e nZ respectivamente
lPar := Eval( bCB , nTeste , @nY , @nZ )
MsgInfo(lPar , "O numero � par ? ")
MsgInfo(nY , "Numero / 2 ")
MsgInfo(nZ , "Numero * 2 ")
Return

User Function Ola05()
Local aValores := {}
Local nSoma := 0
Local bSoma := {| nValor , nPos | nSoma += nValor }
aadd(aValores,3)
aadd(aValores,4)
aadd(aValores,3)
aadd(aValores,10)
aEval(aValores,bSoma) //BLOCO DE CODIGO COM ARRAY
MsgInfo(nSoma,"Valores Somados")
Return

