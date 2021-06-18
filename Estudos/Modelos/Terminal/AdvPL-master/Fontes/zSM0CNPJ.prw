//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zSM0CNPJ
Fun��o que retorna o c�digo da filial
@type function
@author Atilio
@since 22/11/2015
@version 1.0
	@param cCGC, Caracter, CNPJ buscado para encontrar a filial
	@return cFilRet, C�digo da filial encontrada
	@example
	u_zSM0CNPJ("000000000")
/*/

User Function zSM0CNPJ(cCGC)
	Local aArea := GetArea()
	Local aAreaM0 := SM0->(GetArea())
	Local cFilRet := ""
	
	//Percorrendo o grupo de empresas
	SM0->(DbGoTop())
	While !SM0->(EoF())
		//Se o CNPJ for encontrado, atualiza a filial e finaliza
		If cGCG == SM0->M0_CGC
			cFilRet := SM0->M0_CODFIL
			Exit
		EndIf
		
		SM0->(DbSkip())
	EndDo
	
	RestArea(aAreaM0)
	RestArea(aArea)
Return cFilRet