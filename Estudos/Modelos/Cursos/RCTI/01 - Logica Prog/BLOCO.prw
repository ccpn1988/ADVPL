#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} BLOCO
//TODO Descrição auto-gerada.
@author RCTI TREINAMENTOS
@since 2018
@version undefined

@type function
/*/
user function BLOCO()
	
//Local bBloco := {|| Alert("Olá Mundo!")}
	//Eval(bBloco)
	
	// Passagem por parâmetros - Bloco de códigos
	Local bBloco := {|cMsg| Alert(cMsg)}
		Eval(bBloco,"Olá Mundo!")
	
return