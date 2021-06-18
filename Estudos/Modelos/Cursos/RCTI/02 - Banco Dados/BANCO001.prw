#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} BANCO001
//TODO Descrição auto-gerada.
@author RCTI TREINAMENTOS
@since 2018
@version undefined

@type function
/*/
user function BANCO001()
	Local aArea := SB1->(GetArea())
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1)) //Posiciona no indice 1
	SB1->(DbGoTop())
	
	// posiciona o produto de código 000002
	If SB1->(dbSeek(FWXFilial("SB1")+ "000002"))
	 Alert(SB1->B1_DESC)
	
	EndIf
	
	RestArea(aArea)
	
return