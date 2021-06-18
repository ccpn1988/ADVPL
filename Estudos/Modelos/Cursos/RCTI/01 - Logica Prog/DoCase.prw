#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} DoCase
//TODO Descri��o auto-gerada.
@author RCTI TREINAMENTOS
@since 2018
@version undefined

@type function
/*/
user function DoCase()
	
	Local cData := "15/12/2018"
	
	Do Case
	
	Case cData == "20/12/2017"
	Alert("N�o � Natal " + cData)
	
	Case cData == "25/12/2017"
	Alert("� NATAL!!")
	
	OtherWise
	MsgAlert("N�o sei qual dia � hoje !")
	
	EndCase
	
return