#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} BLOCO
//TODO Descri��o auto-gerada.
@author RCTI TREINAMENTOS
@since 2018
@version undefined

@type function
/*/
user function BLOCO()
	
//Local bBloco := {|| Alert("Ol� Mundo!")}
	//Eval(bBloco)
	
	// Passagem por par�metros - Bloco de c�digos
	Local bBloco := {|cMsg| Alert(cMsg)}
		Eval(bBloco,"Ol� Mundo!")
	
return