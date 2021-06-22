/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2016/04/12/descobrir-ultima-pergunta-executada-pelo-protheus/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zLastPerg
Retorna a �ltima pergunta executada pelo Protheus
@type function
@author Atilio
@since 05/03/2016
@version 1.0
	@return cPerg, C�digo da pergunta
/*/

User Function zLastPerg()
	Local aArea   := GetArea()
	Local aAreaX1 := SX1->(GetArea())
	Local cPerg   := ""
	
	DbSelectArea("SX1")
	
	//Se n�o tiver no come�o da tabela
	If ! SX1->(BoF())
		//Volta um registro e pega o grupo
		SX1->(DbSkip(-1))
		cPerg := SX1->X1_GRUPO
	EndIf
	
	RestArea(aAreaX1)
	RestArea(aArea)
Return cPerg