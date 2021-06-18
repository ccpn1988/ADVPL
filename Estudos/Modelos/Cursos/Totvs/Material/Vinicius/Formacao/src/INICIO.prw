#Include 'Protheus.ch'

/* COMENTARIOS */  
//COMENTARIO

User Function INICIO()

/*
TIPOS DE VARIAVEIS
:= ATRIBUICAO
LETRA TIPO DE VARIAVEL

FRACAMENTE TIPADA = MISMACH 
NÂO RECHALA DE TIPOS DE VARIAVEIS
*/

cVar := "" // OU ''
nVar := 0
lVar := .T. // .F.
aVar := {}
bVar := {|| } //BLOCO DE CÒDIGO
dVar := Date()

/*
TIPOS DE RETURN
RETURN
RETURN()
RETURN NIL
*/

Return(NIL)

/*********************************************************************************/
 
User Function fAlerta()

Alert("Stop")
MsgInfo("Informativo","Info")
MsgStop("Stop","Pare")
MsgAlert("Alerta","ALERT")
MsgNoYes("No / Yes","NÂO")
MsgYesNo("Yes / No","SIM") 

Return nil
    
/*********************************************************************************/     
     
User Function MATA010()

Alert("Stop")
MsgInfo("Informativo","Info")
MsgStop("Stop","Pare")
MsgAlert("Alerta","ALERT")
MsgNoYes("No / Yes","NÂO")
MsgYesNo("Yes / No","SIM") 

Return nil

User Function fVar()

Local xVar //as Char /*RECEBE NULO*/

xVar := "Variável Caracter"
MsgInfo(xVar)

xVar := 10+30/20*96^2
MsgInfo(xVar)

xVar := Date() + 4 //"Soma de Data"
MsgInfo(xVar)

xVar := {"Array", 20 + 10}
MsgInfo(xVar[1])
MsgInfo(xVar[2])

xVar := Nil //Valor Nulo
MsgInfo("VALOR NULO " + cValToChar(xVar))

Return()
