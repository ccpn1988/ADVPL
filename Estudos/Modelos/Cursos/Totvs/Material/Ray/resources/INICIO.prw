#Include 'Protheus.ch'


//Comentario

/*
comentario por bloco
*/


User Function INICIO()  //Função ADVPL

cVar := "" // ou ''
nVar := 0
lVar := .T. //ou .F.
aVar := {}
bVar := { || } //Bloco de codigo
dVar := Date()


//Return
//Return()
//Return NIL
Return( NIL )


//----------------------------------------------------------------------------
User Function fAlerta()

Alert("Stop")
MsgInfo("Informativo", "TITULO")
MsgStop("Stop", "ATENÇÃO!!!")
MsgAlert("Alert", "DEU RUIM")
MsgNoYes("No/Yes","SÓ QUE NÃO !!!")
MsgYesNo("Yes/No")

Return( NIL )
//----------------------------------------------------------------------------

User Function fVar
Local xVar
xVar := "Variavel Caracter"

MsgInfo(xVar,"mensagem 1")

xVar := Date() + 4
MsgInfo(xVar)

xVar := 10 + 30 / 20 * 96 ^ 2

MsgInfo(xVar)

xVar := {"Array", 20 + 10} 

MsgInfo(xVar[1])
MsgInfo(xVar[2])

xVar := NIL //Valor Nulo
msgInfo("Valor Nulo: " + cValToChar(xVar))



Return()
