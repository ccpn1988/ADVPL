#Include 'Protheus.ch'

User Function INICIO() // Função ADVPL

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

User Function MATA010()
	
	Alert("Alerta")
	MsgInfo("Informativo","TITULO")
	MsgStop("Stop","DEU RUIM!!!")
	MsgAlert("Alerta","ATENÇÃO")
	MsgNoYes("No/Yes","Titulo")
	MsgYesNo("Yes/No","SÓ QUE NÃO")
	
	//MsgBox("Tem certeza capitão","Confirmação","YesNo")
		
Return (Nil)

User Function fVar
	Local xVar //as Char
	
	xVar := "Variavel caracter"
	
	MsgInfo(xVar)

	xVar := 10 + 30 / 20 * 96 ^ 2
	
	MsgInfo(xVar)
	
	xVar := Date() + 4 // Soma de data
	
	MsgInfo(xVar)
	
	xVar := {"Array", 20 + 10 }
	
	MsgInfo(xVar[1])
	MsgInfo(xVar[2])
	
	xVar := Nil // Valor nulo
	
	MsgInfo("Valor Nulo: " + cValToChar(xVar))
	
Return()