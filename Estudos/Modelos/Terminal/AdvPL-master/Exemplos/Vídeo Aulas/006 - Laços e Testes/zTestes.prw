//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zTestes
Exemplo de testes em AdvPL
@author Atilio
@since 08/11/2015
@version 1.0
	@example
	u_zTestes()
/*/

User Function zTestes()
	Local aArea := GetArea()
	Local dDataTst := Date()
	Local lQuinta := .F.
	
	//Testando se o dia de hoje � quinta feira
	If Upper(cDoW(dDataTst)) == "THURSDAY"
		lQuinta := .T.
		Alert("Hoje � Quinta!")
		
	//Sen�o mostra um alerta que hoje n�o � quinta
	Else
		lQuinta := .F.
		Alert("Hoje n�o � Quinta!")
	EndIf
	
	//Se n�o for quinta feira, e for s�bado
	If !lQuinta .And. Upper(cDoW(dDataTst)) == "SATURDAY"
		Alert("S�bad�o!")
	
	//Sen�o, se n�o for quinta feira, e for domingo
	ElseIf !lQuinta .And. Upper(cDoW(dDataTst)) == "SUNDAY"
		Alert("Doming�o!")
	EndIf
	
	
	//Fazendo case de testes
	Do Case
		Case Upper(cDoW(dDataTst)) == "MONDAY"
			Alert("Hoje � <b>Segunda</b>")
			
		Case Upper(cDoW(dDataTst)) == "TUESDAY"
			Alert("Hoje � <b>Ter�a</b>")
			
		Case Upper(cDoW(dDataTst)) == "WEDNESDAY"
			Alert("Hoje � <b>Quarta</b>")
			
		Case Upper(cDoW(dDataTst)) == "THURSDAY"
			Alert("Hoje � <b>Quinta</b>")
			
		Case Upper(cDoW(dDataTst)) == "FRIDAY"
			Alert("Hoje � <b>Sexta</b>")
			
		Case Upper(cDoW(dDataTst)) == "SATURDAY"
			Alert("Hoje � <b>S�bado</b>")
			
		Case Upper(cDoW(dDataTst)) == "SUNDAY"
			Alert("Hoje � <b>Domingo</b>")
		OtherWise
			Alert("Hoje � <b>???</b>")
	EndCase
	
	RestArea(aArea)
Return