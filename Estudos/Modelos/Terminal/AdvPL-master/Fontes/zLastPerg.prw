//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zLastPerg
Retorna a última pergunta executada pelo Protheus
@type function
@author Atilio
@since 05/03/2016
@version 1.0
	@return cPerg, Código da pergunta
/*/

User Function zLastPerg()
	Local aArea   := GetArea()
	Local aAreaX1 := SX1->(GetArea())
	Local cPerg   := ""
	
	DbSelectArea("SX1")
	
	//Se não tiver no começo da tabela
	If ! SX1->(BoF())
		//Volta um registro e pega o grupo
		SX1->(DbSkip(-1))
		cPerg := SX1->X1_GRUPO
	EndIf
	
	RestArea(aAreaX1)
	RestArea(aArea)
Return cPerg