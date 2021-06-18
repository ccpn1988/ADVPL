#INCLUDE 'PROTHEUS.CH'
// Comentario 

/*
Mentario 
por
bloco
*/

//User Function INICIO()  // Função ADVPL 

User Function INICIO 
cVar := "" // ou ''
nVar := 0
lVar := .T. // .F.
aVar := {} 
bVar := {|| } // Bloco de codigo
dVar := Date()

//Return
//Return()
//Return NIL
Return( NIL )
//--------------------------------------------------------------------------
User Function MATA010()

Alert("Stop")
MsgInfo("Informativo","TITULO")
MsgStop("Stop","ATENÇÃO!!! ")
MsgAlert("Alerta","DEU RUIM !!!")
MsgNoYes("No/Yes","Só que NÃO !!!")
MsgYesNo("Yes/No")

Return( NIL )
//--------------------------------------------------------------------------
User Function fVar
Local xVar //as Char

xVar := "Variavel caracter"

Msginfo(xVar)


xVar := 10 + 30 / 20 * 96 ^ 2

Msginfo(xVar)


xVar := Date() + 4 // Soma de data 

msgInfo(xVar)



xVar:= {"Array",20 + 10}

Msginfo(xVar[1])
Msginfo(xVar[2])


xVar := NIL // Valor nulo
msgInfo("Valor Nulo: " + cValToChar(xVar) )


Return()







//--------------------------------------------------------------------------
















































