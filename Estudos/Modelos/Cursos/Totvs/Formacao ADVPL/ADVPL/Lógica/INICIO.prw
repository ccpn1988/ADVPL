#Include 'Protheus.ch' //BIBLIOTECA

//COMENTARIO POR LINHA

/*
COMENTARIO 
POR BLOCO
*/

User Function INICIO()//FUNÇÃO DE USUÁRIO
cVar := "  " .AND. ' '
nVar := 0
lVar := .T. // .F.
aVar := {}
bVar := {||}
dVar := Date()

Return

//-----------------------------------------------------------------------------------------------

User Function fAlerta()

Alert("Stop")
MsgInfo("Informativo")
MsgStop("Stop")
MsgAlert("Alerta")
MsgNoYes("No/Yes")
MsgYesNo("Yes/No")
 
Return
//-----------------------------------------------------------------------------------------------
 User Function fAlerta1()//Mudar Nome do Alerta

Alert("Stop")
MsgInfo("Informativo","Titulo")
MsgStop("Stop","ATENÇÂO!!!")
MsgAlert("Alerta","ALERTA")
MsgNoYes("No/Yes","SE ATENTE")
MsgYesNo("Yes/No","OLHA A MERDA")
 
Return
//-----------------------------------------------------------------------------------------------

User Function fVar()
Local xVar 
xVar := "Variavel Caracter"

MsgInfo(xVar)

xVar := 10 + 30 / 20 *96 ^ 2

MsgInfo(xVar)

xVar:= Date() + 4 //Soma a Data
MsgInfo(xVar)


xVar:= {"Array",20 + 10}
MsgInfo(xVar[1])
MsgInfo(xVar[2])

xVar := Nil //Valor Nulo
MsgInfo("Valor Nulo :" + cValToChar(xVar))

Return
//-----------------------------------------------------------------------------------------------

