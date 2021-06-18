#include 'protheus.ch'
#include 'parmtype.ch'

//+--------------------------------------------------------------------+
//| Rotina | zDebug | Autor |CAIO NEVES    		      | Data | 14/05/19|
//+--------------------------------------------------------------------+
//| Descr. | DEBUG.  		     									   |
//+--------------------------------------------------------------------+
//| Uso    | DEBUG													   |
//+--------------------------------------------------------------------+

user function zDebug()
	Local aArea 	:= GetArea()
	Local aProduto 	:= {}
	Local nCount 	:= 0
	
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())
	
	While ! SB1->(EOF())
		aAdd(aProduto,{	SB1->B1_COD,;
						SB1->B1_DESC})
		nCount++
		SB1->(DBSkip())
	EndDo
	MsgAlert("Quantidade de Produtos encontradas "+ cValToChar(nCount))
	nCount := 0
	RestArea(aArea)
	
return