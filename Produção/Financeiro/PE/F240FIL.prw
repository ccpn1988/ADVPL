#include "Rwmake.ch"
#include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF240FIL   บ Autor ณ Florence Fran็a    บ Data ณ  01/12/10   บฑฑ 
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada executado na tela de parโmetros no campo  บฑฑ
ฑฑบ          ณ MODO (Forma de Pagamento) rotina border๔ a Pagar.		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 		                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/        

User Function F240FIL()
                          
Local cRet := " " 

/*
Local cFormPag  := Space(2)
Local cRet := " "                       

	DEFINE MSDIALOG oDlgClie FROM  000,000 TO 150,300 TITLE OemToAnsi("Filtro") PIXEL 
	
	@ 00, 005 TO 070, 200 Title "Parametros"
	@ 12, 025 SAY "Cobran็a por Forma de Pagamento" SIZE 100,100 PIXEL 
	@ 25, 025 GET cFormPag SIZE 35,10 F3 "58"
    
	DEFINE SBUTTON FROM 55, 020 oButton2 TYPE 1 ENABLE OF oDlgClie ACTION (lRet := .T.,oDlgClie:End()) PIXEL
	DEFINE SBUTTON FROM 55, 050 oButton3 TYPE 2 ENABLE OF oDlgClie ACTION (lRet := .F.,oDlgClie:End()) PIXEL
	
	ACTIVATE MSDIALOG oDlgClie CENTERED                                                                                      
*/   

cRet := " E2_XFORPGT == '"+CMODPGTO+"'"


Return cRet                                                       	