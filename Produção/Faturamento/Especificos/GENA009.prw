#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA009   ºAutor  ³ Joni Fujiyama      º Data ³  16/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica quantidade liberada no pedido de venda e zera 	 ¹±±
±±º   		   ³ valor mínimo														¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GENA009

Local _aAreaSA1	:= SA1->(GetArea())
Local _aAreaSF4	:= SF4->(GetArea())
Local _nValMin		:= SuperGetMv( "MV_XVALMIN" , , 1000.00 )
Local _cCanal		:= SuperGetMv( "MV_XCANAL" , ,"1/2" )
Local _nVal		:= ascan(aHeader,{|x| alltrim(x[2])=="C6_VALOR"})
Local _nQtd		:= ascan(aHeader,{|x| alltrim(x[2])=="C6_QTDLIB"})
Local _nTES		:= ascan(aHeader,{|x| alltrim(x[2])=="C6_TES"})
Local _nPedTot		:= 0
Local _lValMin		:= .F.

//Pesquisa cliente
SA1->(DbSetOrder(1))
IF SA1->(DBSEEK(XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		
	//Verifica canal do cliente
	IF ALLTRIM(SA1->A1_XCANALV) $ _cCanal 
	
		//Verifica valor total do pedido 
		For _nx:=1 To Len(aCols)
		
			// Verifica se a linha do acols está deletada
			If !GDDeleted(_nx)
				
				// Busca a TES
				SF4->(DbSetOrder(1))
				IF SF4->(DBSEEK(XFILIAL("SF4")+aCols[_nx][_nTES]))
					
					// Verifica se é uma TES com cálculo de valor mínimo
				 	IF SF4->F4_XVALMIN == "S"

				 		_lValMin := .T.

				 	ENDIF
				 	
				 ELSE
				 
				 	ALERT("TES não encontrada")
				 
				 ENDIF
				 		
				_nPedTot += aCols[_nx][_nVal]
							
			Endif
		
		Next _nx
	    
	    //Se estiver abaixo do valor mínimo zera a quantidade liberada para não gerar SC9
		If _nValMin > _nPedTot .AND. _lValMin 
			
			For _nx:=1 To Len(aCols)
				
				aCols[_nx][_nQtd] := 0	
									
			Next _nx			

		Endif	

	ENDIF

ENDIF

RestArea(_aAreaSF4)
RestArea(_aAreaSA1)

Return 
