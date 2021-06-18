#Include 'Protheus.ch'

User Function INICIO

cVar:="" // ou ''
nVar:=0
lVar:=.t. // .f.
aVar:={}
bVar:={|| } //Bloco de código
dVar:=Date()

Return(NIL)

//======================================================

User Function MATA010()

Alert("Stop")
MsgInfo("Informativo","TITULO")
MsgStop("Stop","ATENÇÃO!!!")
MsgAlert("Alerta","DEU RUIM!!!")
MsgYesNo("No/Yes","SÓ QUE NÃO!!!")
MsgNoYes("Yes/No")

Return(nil)

//======================================================

User Function fVar
Local xVar

xVar := "Variável caracter"

MsgInfo(xvar)

xVar := 10 + 30 / 20 * 96 ^ 2

MsgInfo(xVar)

xVar:= Date() + 4 // Soma de Data

MsgInfo(xVar)

xVar:= {"Array", 20 + 10}

MsgInfo(xVar[1])
MsgInfo(xVar[2])

xVar:=Nil //Valor nulo
MsgInfo("Valor Nulo: "+cValtochar(xVar)) /// qualquer tipo para caracter

Return()




