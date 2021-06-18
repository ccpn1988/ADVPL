#include "rwmake.ch" 
#Include "Protheus.ch"

/*{Protheus.doc} GENI030
		 		Ajusta parâmetros e cria parâmetros
@author  	Ivan de Oliveira  
@since   	13/02/2018
@version 	1.0
@type    	User function
@Parâmetros {_aParam}, {Array-Multi}, {{ Código Parâmetro, tipo, Descrição, Descrição 1, Descrição 2, Conteúdo }} 
@Retorno	   {_lRet}  , {Lógico}	   , .T. - Sucesso/.F. - Erro na Inclusão.
*/
 
User Function GENI033(_aParam)

Local _nIt := 0   
Local lRet	:= .T.  
DeFault _aParam := {}

// Incluindo os Parâmetros.
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
		
			//Descrição
			SX6->X6_DESCRIC :=  _aParam[_nIt][03]
			SX6->X6_DESC1   :=  _aParam[_nIt][04]
			SX6->X6_DESC2   :=  _aParam[_nIt][05]
			
			//Conteúdo
			SX6->X6_CONTEUD :=  _aParam[_nIt][06]
			SX6->X6_CONTSPA :=  _aParam[_nIt][06]
			SX6->X6_CONTENG :=  _aParam[_nIt][06]
			
   		SX6->(MsUnlock())
   	*/	
   	Endif
   	
Next 
 
Return(lRet)