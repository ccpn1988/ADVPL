#Include 'Protheus.ch'
//COMENTARIO
/*cOMENTARIO
*/

User Function INICIO()
cVar := "" // ou ''
nVar := 0
lVar := .T. // .F.
aVar := {}
bVar := {||} //Bloco de codigo
dVar := Date()

//Return
//Return{}
//Return NIL


Return { NIL }
//----------------------------------------------------------------------------------

User Function MATA010()
Alert ('Errrouuuu')
MsgInfo ('Infomativo')
MsgStop ('Pensando na Rosquina né!!')
MsgAlert ('Alerta')
MsgNoYes('Vai no bloco das Piranhas')
MsgYesNo('Yes/No')

Return ( NIL )

User Function fVar
Local xVar //]as Char
xVar:= 'Variavel caracter'
MsgInfo(xVar)

xVar:= 10 + 30 / 20* 96^2
Msginfo (xVar)

xVar:= DATE() +4 //Soma de data
Msginfo (xVar)

xVar:= {'Array',20 + 10}
Msginfo(xVar[1])
Msginfo(xVar[2])

xVar:= 0 //Valor nulo
msginfo('Valor Nulo: '+ cValToChar (xVar))

Return ()






