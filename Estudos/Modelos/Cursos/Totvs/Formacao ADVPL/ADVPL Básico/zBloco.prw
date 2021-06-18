#include 'protheus.ch'
#include 'parmtype.ch'

//Diferentemente de uma matriz, não se pode acessar elementos de um bloco de código através
//de um índice numérico. Porém blocos de código são semelhantes a uma lista de expressões, e
//a uma pequena função.
//Ou seja, podem ser executados. Para a execução, ou avaliação, de um bloco de código, devese
//utilizar a função Eval():

//Já que blocos de código são como pequenas funções, também é possível a passagem de
//parâmetros para um bloco de código. Os parâmetros devem ser informados entre as barras
//verticais (||) separados por vírgulas, assim como em uma função.

//{ | [parametro1],[parametro2],[expressãoN] | [expressao1],[expressao2],[expressãoN] }

//PASSAGEM POR PARÂMETROS
user function zBloco()
Local bBloco := {|cMsg|Alert(cMsg)}
		Eval(bBloco,"Olá Mundo!")
return

User Function Ola04()
Local bCB := {| x,y,z | y := x/2 , z := x*2 , x%2 == 0 }
Local nTeste := 4
Local lPar
Local nY , nZ
// O bloco de codigo recebe em x o valor de nTeste
// e recebe em y e z a referência das variáveis 
// nY e nZ respectivamente
lPar := Eval( bCB , nTeste , @nY , @nZ )
MsgInfo(lPar , "O numero é par ? ")
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

