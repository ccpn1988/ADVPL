#include "rwmake.ch" 
#Include "Protheus.ch"

/*{Protheus.doc} GENI030
		 		Ajusta par�metros e cria par�metros
@author  	Ivan de Oliveira  
@since   	13/02/2018
@version 	1.0
@type    	User function
@Par�metros {_aParam}, {Array-Multi}, {{ C�digo Par�metro, tipo, Descri��o, Descri��o 1, Descri��o 2, Conte�do }} 
@Retorno	   {_lRet}  , {L�gico}	   , .T. - Sucesso/.F. - Erro na Inclus�o.
*/
 
User Function GENI033(_aParam)

Local _nIt := 0   
Local lRet	:= .T.  
DeFault _aParam := {}

// Incluindo os Par�metros.
//DbSelectArea("SX6")
//DbSetOrder(1)
//SX6->(DbGoTop())  
for _nIt := 1 to len(_aParam)

	If FWSX6Util():ExistsParam( _aParam[_nIt][01] )
	lRet := .F.
/*
	If !(SX6->(DbSeek( FwXFilial("SX6") + _aParam[_nIt][01] )))
		lRet := .F.
           
		RecLock("SX6",.T.)          	
             
  			SX6->X6_FIL  	:=  FwXFilial("SX6") 
	    	SX6->X6_VAR     := _aParam[_nIt][01]
			SX6->X6_TIPO 	:= _aParam[_nIt][02]
			SX6->X6_PROPRI  :=  "U"
		
			//Descri��o
			SX6->X6_DESCRIC :=  _aParam[_nIt][03]
			SX6->X6_DESC1   :=  _aParam[_nIt][04]
			SX6->X6_DESC2   :=  _aParam[_nIt][05]
			
			//Conte�do
			SX6->X6_CONTEUD :=  _aParam[_nIt][06]
			SX6->X6_CONTSPA :=  _aParam[_nIt][06]
			SX6->X6_CONTENG :=  _aParam[_nIt][06]
			
   		SX6->(MsUnlock())
   	*/	
   	Endif
   	
Next 
 
Return(lRet)