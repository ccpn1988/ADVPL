//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Se for espanhol
#Ifdef SPANISH
	#Define STR_TESTE		'Un gran poder conlleva una gran responsabilidad.'
	#Define STR_TITULO	'Precauci�n'
	
//Sen�o, ir� fazer outros testes
#Else
	//Se for em Ingl�s
	#Ifdef ENGLISH
		#Define STR_TESTE		'With great power comes great responsibility.'
		#Define STR_TITULO	'Caution'
		
	//Sen�o, ser� o padr�o (Portugu�s)
	#Else
		#Define STR_TESTE		'Com grandes poderes v�m grandes responsabilidades.'
		#Define STR_TITULO	'Aten��o'
	#EndIf
#EndIf

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} zConstantes
Exemplo de teste com diretivas / constantes
@author Atilio
@since 13/10/2015
@version 1.0
	@example
	u_zConstantes()
/*/

User Function zConstantes()
	Local aArea := GetArea()
	
	//Mostrando mensagem
	MsgAlert(STR_TESTE + STR_PULA + "...", STR_TITULO)
	
	RestArea(aArea)
Return