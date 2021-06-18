#include 'protheus.ch'
#include 'parmtype.ch'

//DO WHILE ENDDO

user function doWhile()
	Local nNum1 := 0
	Local nNum2 := 10
	
	While nNum1 < nNum2
		nNum1++
	ENDDO
	Alert (nNum1)
return
//------------------------------------------------------------------------------
//While Composto

User Function WHILECOMP()
	local nNum1 := 1
	local cNome := "RCTI"
	
	While nNum1 < 10 .AND. cNome != "PROTHEUS"
		nNum1++
			IF nNum1 == 5 
				cNome := "PROTHEUS"
			ENDIF
	ENDDO
	ALERT("Numero: " + cValToChar (nNum1))
	ALERT("O nome é: " + (cNome))
	
RETURN

//------------------------------------------------------------------------------

USER FUNCTION xWhilex()
	Local nValor := 1
	Local cNome := ""
	
	//EXEMPLO DE WHILE(FAÇA ENQUANTO FOR DIFERENTE DE 10)
	nValor := 1
	While nValor != 10
		nValor++
	ENDDO
	Alert("While: "+cValToChar(nValor))
	
	//EXEMPLO DE WHILE COMPOSTO COM MAIS DE UMA CONDIÇÃO
	nValor := 1
	While nValor != 10 .AND. cNome != "Daniel"
		IF nValor ==5
			cNome := "Daniel"
		ENDIF
		nValor++
	ENDDO
	Alert("While: "+cValToChar(nValor))	