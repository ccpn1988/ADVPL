#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} DEBUG01
//TODO Quantidade de produtos na tabela SB1
@author RCTI Treinamentos
@version undefined

@type function
/*/
user function DEBUG01()
	Local aArea := GetArea()
	Local aProduto := {}
	Local nCount := 0
	
	//Seleciona a tabela de produtos
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1)) //Seleciona o Indice
	SB1->(DbGoTop())

	While ! SB1->(EoF()) //Enquanto não for final do arquivo
		aAdd(aProduto,{	SB1->B1_COD,;
						SB1->B1_DESC})
	
		nCount++
		SB1->(DbSkip())
	EndDo
	
	MsgAlert("Quantidade de Produtos encontrada: <b>" + cValToChar(nCount))
	
	nCount := 0 //Zerando o valor da varável nCount
	
	RestArea(aArea)
	
return