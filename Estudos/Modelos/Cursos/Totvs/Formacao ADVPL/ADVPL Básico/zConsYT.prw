#include 'protheus.ch'
#include 'parmtype.ch'

//CONSTANTES
#IFDEF SPANISH
	#DEFINE STR_TESTE "Un gran poder conileva una gran responsabilidad"
	#DEFINE STR_TITULO "Precaucion"

#ELSE 
	#IFDEF ENGLISH
		#DEFINE STR_TESTE "With great power comes great responsibility"
		#DEFINE STR_TITULO "Caution"
		
	#ELSE
		#DEFINE STR_TESTE "Com grandes poderes vem grandes responsabilidades"
		#DEFINE STR_TITULO "Atenção"
	#EndIF
#EndIF

#DEFINE STR_PULA CHR(30) + CHR(10)


User Function zConsYT()
Local aArea := GetArea()

	MSGAlert(STR_TESTE + STR_PULA + ".....", STR_TITULO)
	
	RestArea(aArea)
	
Return

User Function zVari()
	Local aArea := GetArea()

	//DECLARAÇÃO DE VARIAVEIS
	LOCAL nValor   := 0
	LOCAL dData    := Date()
	LOCAL lTeste   := .T.
	LOCAL cTexto   := "T"
	LOCAL oObjeto  := TFont() :New("Tahoma")
	LOCAL xInfo    := 0
	LOCAL aDados   := {"Daniel","Atilio",dData}
	LOCAL bBloco1  :={||	nValor := 1,;
							Alert("Valor é igual a: " + cValToChar(nValor))}
	LOCAL bBloco2  :={|nValor|, nValor +=2,;
								Alert("Valor é igual a: " + cValToChar(nValor))}
								
	//EXECUTANDO BLOCO DE CODIGO
	EVAL(bBloco1)
	EVAL(bBloco2,5)
	
	RestArea(aArea)
Return