#INCLUDE "PROTHEUS.CH"
#INCLUDE "aarray.CH"
#INCLUDE "json.CH"
#INCLUDE "shash.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWSFATGEN  บAutor  ณMicrosiga           บ Data ณ  05/13/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GetFilGen(cIdEmp,cFilGen)

Local cAliFil	:= "AUX_FILGEN"
Local cCodFil	:= ""

Default cIdEmp	:= ""
Default cFilGen	:= ""

If Select("AUX_FILGEN") <> 0
	AUX_FILGEN->(DbCloseArea())
EndIF

BeginSql Alias "AUX_FILGEN"
	SELECT IDEMPRESATOTVS,IDEMPRESAGEN FROM TT_I10_FILIAL_GEN_TOTVS I10  
	WHERE ( IDEMPRESAGEN = %Exp: Val(cIdEmp)% AND IDEMPRESAGEN <> 0)
	OR ( IDEMPRESATOTVS = %Exp: Val(cFilGen)% AND IDEMPRESATOTVS <> 0 )
EndSql

AUX_FILGEN->(DbGoTop())

If AUX_FILGEN->(EOF())
	cCodFil	:= xFilial("SC5")
Else
	cCodFil	:= IIF( AUX_FILGEN->IDEMPRESATOTVS <> 0 , AllTrim(Str(AUX_FILGEN->IDEMPRESATOTVS)) , cCodFil )
	cIdEmp	:= IIF( AUX_FILGEN->IDEMPRESAGEN <> 0 , AllTrim(Str(AUX_FILGEN->IDEMPRESAGEN)) , cIdEmp )
EndIf

AUX_FILGEN->(DbCloseArea())

Return cCodFil 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWSFATGEN  บAutor  ณMicrosiga           บ Data ณ  05/13/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PixDanfe(cIdPedido,cFilPed,cPedido,cRomaneio,cPesBru,cPesLiqui,cVolCaixa,cChvAss)

Local cAliZZ5	:= GetNExtAlias()
Local lAuxLoop	:= .T.
Local nLoop		:= 0 
Local nCtrLoop	:= 6
Local cRet		:= ""
Local cFilAux	:= ""
Local aInfo		:= Array(#)
Local nAchou	:= 0
      
cRet	:= "<RETORNO>"
cRet	+= "<CODIGO>3002</CODIGO>"
cRet	+= "<DESCRICAO>Erro! Falha de ExecAuto.</DESCRICAO>"
cRet	+= "<NOTA></NOTA>"
cRet	+= "<SERIE></SERIE>"
cRet	+= "<EMISSAO></EMISSAO>"
cRet	+= "</RETORNO>"

aInfo[#"PESBRU"]	:= cPesBru
aInfo[#"PESLIQ"]	:= cPesLiqui
aInfo[#"VOLUCX"]	:= cVolCaixa
				
While lAuxLoop
	
	If nLoop > nCtrLoop
		cRet	:= "<RETORNO>"
		cRet	+= "<CODIGO>3003</CODIGO>"
		cRet	+= "<DESCRICAO>Erro! Tempo de mแximo de processamento atingido!</DESCRICAO>"
		cRet	+= "<NOTA></NOTA>"
		cRet	+= "<SERIE></SERIE>"
		cRet	+= "<EMISSAO></EMISSAO>"
		cRet	+= "</RETORNO>"	
		Return cRet
	EndIf
	
	nLoop++
	
	If nLoop > 1
		Sleep(10000)
	EndIf
	
	If Select(cAliZZ5) <> 0
		(cAliZZ5)->(DbCloseArea())
	EndIF
	
	BeginSql Alias cAliZZ5
		SELECT ZZ5.R_E_C_N_O_ ZZ5REC FROM %Table:ZZ5% ZZ5
		JOIN TT_I10_FILIAL_GEN_TOTVS I10  
		ON I10.IDEMPRESATOTVS = TO_NUMBER(TRIM(ZZ5.ZZ5_FILIAL))
		AND IDEMPRESAGEN = %Exp: Val(cFilPed) %
		WHERE ZZ5.ZZ5_IDFUNC = '0001'
		AND TRIM(ZZ5.ZZ5_IDPEDI) = %Exp:Val(cIdPedido)%
		AND ZZ5.ZZ5_PEDIDO = %Exp:cPedido%  
		AND ZZ5.%NotDel%
	EndSql
	//AND TRIM(utl_raw.cast_to_varchar2(dbms_lob.substr(ZZ5_CHVASS))) like '%'||%Exp:AllTrim(cChvAss)%||'%'		
	
	nAchou	:= 0
	(cAliZZ5)->(DbGoTop())
	
	While (cAliZZ5)->(!EOF())
		
		ZZ5->(DbGoto((cAliZZ5)->ZZ5REC))
		
		If AllTrim(ZZ5->ZZ5_CHVASS) == AllTrim(cChvAss)
			nAchou	:= (cAliZZ5)->ZZ5REC
			Exit
		EndIf
		
		(cAliZZ5)->(DbSkip())
	EndDo
	
	//If (cAliZZ5)->(EOF())
	If nAchou == 0
	    
	    If Empty(cFilAux)
		    cFilAux := U_GetFilGen(cFilPed)                                                       
		    If Empty(cFilAux)
		    	(cAliZZ5)->(DbCloseArea())
		    	
					cRet	:= "<RETORNO>"
					cRet	+= "<CODIGO>2003</CODIGO>"
					cRet	+= "<DESCRICAO>Erro! Filial de faturamento nใo identificada.</DESCRICAO>"
					cRet	+= "<NOTA></NOTA>"
					cRet	+= "<SERIE></SERIE>"  
					cRet	+= "<EMISSAO></EMISSAO>"					
					cRet	+= "</RETORNO>"		    	
		    	
		    	Return cRet
		    EndIf
	    EndIf
	    
	    cNextNum := U_xGenSXE("ZZ5","ZZ5_IDFILA",4)//GetSX8Num("ZZ5","ZZ5_IDFILA",NIL,4)
	    ConfirmSX8()
	    
		Begin Transaction
			
			RecLock("ZZ5",.T.)
			ZZ5->ZZ5_FILIAL	:= cFilAux
			ZZ5->ZZ5_IDFILA	:= cNextNum
			ZZ5->ZZ5_STATUS	:= "00"//00=Aguardando processamento;01=Processo finalizad;99=Falha de processamento                                                     
			ZZ5->ZZ5_IDFUNC	:= "0001"
			ZZ5->ZZ5_DESC		:= "Gera็ใo de documento de saida"
			ZZ5->ZZ5_IDPEDI	:= cIdPedido
			ZZ5->ZZ5_PEDIDO	:= cPedido
			ZZ5->ZZ5_DATA		:= DDataBase
			ZZ5->ZZ5_HORA		:= Time()
			ZZ5->ZZ5_ROMANE	:= Val(cRomaneio)
			ZZ5->ZZ5_NOTA		:= ""
			ZZ5->ZZ5_SERIE	:= ""  
			ZZ5->ZZ5_DADOS	:= ToJSon(aInfo) 
			ZZ5->ZZ5_CHVASS	:= AllTrim(cChvAss)
			ZZ5->ZZ5_MSG		:= "Aguardando processamento nota fiscal!"
			MsUnLock()
			
		End Transaction	
		
			ConfirmSX8()
	Else
		
		ZZ5->(DbGoTo(nAchou))
		Do Case
			//Case ZZ5->ZZ5_STATUS == "00"
			//	Sleep(1000)
			Case ZZ5->ZZ5_STATUS == "01"
				cRet	:= "<RETORNO>"
				cRet	+= "<CODIGO>0000</CODIGO>"
				cRet	+= "<DESCRICAO>Processamento concluํdo com sucesso.</DESCRICAO>"
				cRet	+= "<NOTA>"+ZZ5->ZZ5_NOTA+"</NOTA>"
				cRet	+= "<SERIE>"+AllTrim(ZZ5->ZZ5_SERIE)+"</SERIE>"  
				cRet	+= "<EMISSAO>"+DtoC(ZZ5->ZZ5_DTNF)+"</EMISSAO>"				
				cRet	+= "</RETORNO>"	 
				(cAliZZ5)->(DbCloseArea())
				lAuxLoop	:= .F.
				Exit			
		EndCase
				
	EndIf
	
	If Select(cAliZZ5) <> 0
		(cAliZZ5)->(DbCloseArea())
	EndIF	
			
EndDo
     
Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPIXXFUN   บAutor  ณMicrosiga           บ Data ณ  05/17/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PixPedido(cIdPedido,cFilPed,cPedido,aItens,cChvAss,cRomaneio)

Local cAliZZ5	:= GetNextAlias()
Local lAuxLoop	:= .T.
Local nLoop		:= 0 
Local nCtrLoop	:= 6
Local cRet		:= ""
Local cFilAux	:= ""
Local nTamProd	:= TamSX3("B1_COD")[1]
Local lContinua	:= .T.
Local nAchou	:= 0
Local cError	:= ""
Local cWarning	:= ""
Local oRetWms	:= nil
					
cRet	:= "<RETORNO>"
cRet	+= "<CODIGO>3002</CODIGO>"
cRet	+= "<DESCRICAO>Erro! Falha de ExecAuto.</DESCRICAO>"
cRet	+= "</RETORNO>"

DbSelectArea("ZZ5")

While lAuxLoop
	
	If nLoop > nCtrLoop
		cRet	:= "<RETORNO>"
		cRet	+= "<CODIGO>3003</CODIGO>"
		cRet	+= "<DESCRICAO>Erro! Tempo de mแximo de processamento atingido!</DESCRICAO>"
		cRet	+= "</RETORNO>"	
		Return cRet
	EndIf
	
	nLoop++
	
	If nLoop > 1
		Sleep(10000)
	EndIf
	
	If Select(cAliZZ5) <> 0
		(cAliZZ5)->(DbCloseArea())
	EndIF
	
	BeginSql Alias cAliZZ5
		SELECT ZZ5.R_E_C_N_O_ ZZ5REC,ZZ5_PEDIDO FROM %Table:ZZ5% ZZ5
		JOIN TT_I10_FILIAL_GEN_TOTVS I10  
		ON I10.IDEMPRESATOTVS = TO_NUMBER(TRIM(ZZ5.ZZ5_FILIAL))
		AND IDEMPRESAGEN = %Exp: Val(cFilPed) %
		WHERE ZZ5.ZZ5_IDFUNC = '0002'
		AND TRIM(ZZ5.ZZ5_IDPEDI) = %Exp:Val(cIdPedido)%
		AND ZZ5.ZZ5_PEDIDO = %Exp:cPedido% 
		AND ZZ5.%NotDel%
	EndSql
	//AND TRIM(utl_raw.cast_to_varchar2(dbms_lob.substr(ZZ5_CHVASS))) like '%'||%Exp:AllTrim(cChvAss)%||'%'
	nAchou	:= 0
	(cAliZZ5)->(DbGoTop())
	
	While (cAliZZ5)->(!EOF())
		
		ZZ5->(DbGoto((cAliZZ5)->ZZ5REC))
		
		If AllTrim(ZZ5->ZZ5_CHVASS) == AllTrim(cChvAss)
			nAchou	:= (cAliZZ5)->ZZ5REC
			Exit
		EndIf
		
		(cAliZZ5)->(DbSkip())
	EndDo
		
	//If (cAliZZ5)->(EOF())
	If nAchou == 0
	    
	    If Empty(cFilAux)
		    cFilAux := U_GetFilGen(cFilPed)
		    If Empty(cFilAux)
		    	(cAliZZ5)->(DbCloseArea())
		    	
					cRet	:= "<RETORNO>"
					cRet	+= "<CODIGO>2003</CODIGO>"
					cRet	+= "<DESCRICAO>Erro! Filial de faturamento nใo identificada.</DESCRICAO>"
					cRet	+= "</RETORNO>"		    	
		    	
		    	Return cRet
		    EndIf
	    EndIf
	    
	    SC5->(DbSetOrder(1))
	    If SC5->(DbSeek(cFilAux+cPedido))
	    	
	    	SC6->(DbSetOrder(2))//C6_FILIAL+C6_PRODUTO+C6_NUM+C6_ITEM
	    	
			For nAuxIt := 1 To Len(aItens)
				
				cProd	:= PadR(AllTrim(aItens[nAuxIt][#"PRODUTO"]),nTamProd)
		   		If SC6->(DbSeek(SC5->C5_FILIAL+cProd+SC5->C5_NUM)) 		   			
		   			If SC6->C6_QTDVEN < aItens[nAuxIt][#"QUANTIDADE"]
			   			(cAliZZ5)->(DbCloseArea()) 
						cRet	:= "<RETORNO>"
						cRet	+= "<CODIGO>2005</CODIGO>"
						cRet	+= "<DESCRICAO>Erro! Quantidade superior a quantidade do pedido de vendas.</DESCRICAO>"
						cRet	+= "</RETORNO>"
						Return cRet	
					ElseIf SC6->C6_QTDVEN <> aItens[nAuxIt][#"QUANT_ATUAL"]
							cRet := "<RETORNO>"
							cRet += "<CODIGO>2007</CODIGO>"
							cRet += "<DESCRICAO>Erro! Quantidade atual diferente do pedido.</DESCRICAO>"
							cRet += "</RETORNO>"
							Return cRet
		   			EndIf		   			
		   		Else
		   			(cAliZZ5)->(DbCloseArea()) 
					cRet	:= "<RETORNO>"
					cRet	+= "<CODIGO>2002</CODIGO>"
					cRet	+= "<DESCRICAO>Erro! Item nใo localizado.</DESCRICAO>"
					cRet	+= "</RETORNO>"
					Return cRet
				EndIf
				
			Next
			
			If lContinua
				
				/*
				If Empty(SC5->C5_XROMANE)
					
					oWmsPix := WSWSRomaneiosService():NEW()
					oWmsPix:CIDPEDIDO	:= cIdPedido
					If !oWmsPix:consultaStatusRomaneio()
						cRet	:= "<RETORNO>"
						cRet	+= "<CODIGO>3004</CODIGO>"
						cRet	+= "<DESCRICAO>Erro! Falha ao consultar o numero do romaneio para este pedido</DESCRICAO>"
						cRet	+= "</RETORNO>"
						Return cRet	
					EndIf
					
					cError		:= ""
					cWarning	:= ""
					oRetWms		:= XmlParser(oWmsPix:cconsultaStatusRomaneioReturn, "_", @cError, @cWarning) 
										
					Do Case
						Case !Empty(cError) .OR. !Empty(cWarning) .OR. Empty(oRetWms:_RETORNO:_NRROMANEIO:TEXT)
							FreeObj(oWmsPix)
							cRet	:= "<RETORNO>"
							cRet	+= "<CODIGO>3004</CODIGO>"
							cRet	+= "<DESCRICAO>Erro! Falha ao consultar o numero do romaneio para este pedido</DESCRICAO>"
							cRet	+= "</RETORNO>"
							Return cRet
						Case Valtype(XmlChildEx(oRetWms,"_RETORNO")) <> "O" 
							FreeObj(oWmsPix)
							cRet	:= "<RETORNO>"
							cRet	+= "<CODIGO>3004</CODIGO>"
							cRet	+= "<DESCRICAO>Erro! Falha ao consultar o numero do romaneio para este pedido</DESCRICAO>"
							cRet	+= "</RETORNO>"
							Return cRet						
						Case Valtype(XmlChildEx(oRetWms:_RETORNO,"_NRROMANEIO")) <> "O"
							FreeObj(oWmsPix)
							cRet	:= "<RETORNO>"
							cRet	+= "<CODIGO>3004</CODIGO>"
							cRet	+= "<DESCRICAO>Erro! Falha ao consultar o numero do romaneio para este pedido</DESCRICAO>"
							cRet	+= "</RETORNO>"
							Return cRet						
						Case ValType(XmlChildEx(oRetWms:_RETORNO:_NRROMANEIO,"TEXT")) <> "C"
							FreeObj(oWmsPix)
							cRet	:= "<RETORNO>"
							cRet	+= "<CODIGO>3004</CODIGO>"
							cRet	+= "<DESCRICAO>Erro! Falha ao consultar o numero do romaneio para este pedido</DESCRICAO>"
							cRet	+= "</RETORNO>"
							Return cRet						
					EndCase
                    
					IF RecLock("SC5",.F.)
						SC5->C5_XROMANE	:= Val(oRetWms:_RETORNO:_NRROMANEIO:TEXT)
						MsUnLock()
					Else	
						FreeObj(oWmsPix)
						cRet	:= "<RETORNO>"
						cRet	+= "<CODIGO>3004</CODIGO>"
						cRet	+= "<DESCRICAO>Erro! Falha ao consultar o numero do romaneio para este pedido</DESCRICAO>"
						cRet	+= "</RETORNO>"
						Return cRet											
                    EndIF
                	RecLock("SC5",.F.)
					SC5->C5_XROMANE	:= 123123
					MsUnLock()               	 
				EndIf
				*/
    			RecLock("SC5",.F.)
				SC5->C5_XROMANE	:= Val(cRomaneio)
				MsUnLock()               	 				
				
				
			    cNextNum := U_xGenSXE("ZZ5","ZZ5_IDFILA",4)//GetSX8Num("ZZ5","ZZ5_IDFILA",NIL,4)
			    ConfirmSX8()
			    
				Begin Transaction
					
					RecLock("ZZ5",.T.)
					ZZ5->ZZ5_FILIAL	:= cFilAux
					ZZ5->ZZ5_IDFILA	:= cNextNum
					ZZ5->ZZ5_STATUS	:= "00"//00=Aguardando processamento;01=Processo finalizad;99=Falha de processamento                                                     
					ZZ5->ZZ5_IDFUNC	:= "0002"
					ZZ5->ZZ5_DESC	:= "Corte de pedido"
					ZZ5->ZZ5_IDPEDI	:= cIdPedido
					ZZ5->ZZ5_PEDIDO	:= cPedido
					ZZ5->ZZ5_DATA	:= DDataBase
					ZZ5->ZZ5_HORA	:= Time()
					ZZ5->ZZ5_ROMANE	:= Val(cRomaneio)//SC5->C5_XROMANE
					ZZ5->ZZ5_MSG	:= "Aguardando processamento de corte do pedido!"
					ZZ5->ZZ5_DADOS	:= ToJSon(aItens)
					ZZ5->ZZ5_CHVASS	:= cChvAss
					MsUnLock()
					
				End Transaction	
				ConfirmSX8()
		    EndIf
		Else 
			
			cRet	:= "<RETORNO>"
			cRet	+= "<CODIGO>2001</CODIGO>"
			cRet	+= "<DESCRICAO>Erro! Pedido nใo localizado.</DESCRICAO>"
			cRet	+= "</RETORNO>"				
			
		EndIf
		
	Else
		
		//ZZ5->(DbGoTo((cAliZZ5)->ZZ5REC))
		ZZ5->(DbGoTo(nAchou))
		Do Case
			Case ZZ5->ZZ5_STATUS == "00"
				Sleep(10000)
			Case ZZ5->ZZ5_STATUS == "01"
				cRet	:= "<RETORNO>"
				cRet	+= "<CODIGO>0000</CODIGO>"
				cRet	+= "<DESCRICAO>Processamento concluํdo com sucesso.</DESCRICAO>"
				cRet	+= "</RETORNO>"	 
				(cAliZZ5)->(DbCloseArea())
				lAuxLoop	:= .F.
				Exit			
		EndCase
				
	EndIf
	
	If Select(cAliZZ5) <> 0
		(cAliZZ5)->(DbCloseArea())
	EndIF	
			
EndDo

Return cRet

 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPixCanRo  บAutor  ณMicrosiga           บ Data ณ  05/31/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cancelamento de Romaneio                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Gen                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PixCanRo(nRecSC5,cIdPedido,cFilPed,cPedido,cChvAss,cNota,cSerie,cFilPro,cRomaneio)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cRet		:= ""
Local cSeekNota	:= ""
Local cAliZZ5	:= GetNExtAlias()
Local lContinua	:= .F.

Local nLoop		:= 0    
Local lAuxLoop	:= .T.
Local nCtrLoop	:= 6

Local nAchou	:= 0

cRet	:= "<RETORNO>"
cRet	+= "<CODIGO>3002</CODIGO>"
cRet	+= "<DESCRICAO>Erro! Falha de ExecAuto.</DESCRICAO>"
cRet	+= "</RETORNO>"

While lAuxLoop
	
	If nLoop > nCtrLoop
		cRet	:= "<RETORNO>"
		cRet	+= "<CODIGO>3003</CODIGO>"
		cRet	+= "<DESCRICAO>Erro! Tempo de mแximo de processamento atingido!</DESCRICAO>"
		cRet	+= "</RETORNO>"	
		Return cRet
	EndIf
	
	nLoop++
	
	If nLoop > 1
		Sleep(10000)
	EndIf
	
	If Select(cAliZZ5) <> 0
		(cAliZZ5)->(DbCloseArea())
	EndIF
	
	BeginSql Alias cAliZZ5
		SELECT ZZ5.R_E_C_N_O_ ZZ5REC,ZZ5_PEDIDO FROM %Table:ZZ5% ZZ5
		JOIN TT_I10_FILIAL_GEN_TOTVS I10  
		ON I10.IDEMPRESATOTVS = TO_NUMBER(TRIM(ZZ5.ZZ5_FILIAL))
		AND IDEMPRESAGEN = %Exp: Val(cFilPed) %
		WHERE ZZ5.ZZ5_IDFUNC = '0003'
		AND TRIM(ZZ5.ZZ5_IDPEDI) = %Exp:Val(cIdPedido)%
		AND ZZ5.ZZ5_PEDIDO = %Exp:cPedido% 
		AND ZZ5.%NotDel%
	EndSql
	//AND TRIM(utl_raw.cast_to_varchar2(dbms_lob.substr(ZZ5_CHVASS))) like '%'||%Exp:AllTrim(cChvAss)%||'%'
	nAchou	:= 0
	(cAliZZ5)->(DbGoTop())
	
	While (cAliZZ5)->(!EOF())
		
		ZZ5->(DbGoto((cAliZZ5)->ZZ5REC))
		
		If AllTrim(ZZ5->ZZ5_CHVASS) == AllTrim(cChvAss)
			nAchou	:= (cAliZZ5)->ZZ5REC
			Exit
		EndIf
		
		(cAliZZ5)->(DbSkip())
	EndDo
		
			
	//IF (cAliZZ5)->(EOF())
	If nAchou == 0
	   
	    SC5->(DbSetOrder(1))
	    If SC5->(DbSeek(cFilPro+cPedido))
	    
			cSeekNota	:= SC5->C5_FILIAL+SC5->C5_NOTA+SC5->C5_SERIE
			lContinua	:= .F.
			DbSelectArea("SF2")
			SF2->(DbsetOrder(1))//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
			
			Do Case
				
				Case Empty(AllTrim(SC5->C5_NOTA))
					/*
					cRet	:= "<RETORNO>"
					cRet	+= "<CODIGO>2006</CODIGO>"
					cRet	+= "<DESCRICAO>Erro! Pedidos sem nota fiscal</DESCRICAO>"
					cRet	+= "</RETORNO>"						
					Return cRet 
					*/
					lContinua := .T.
				Case SC5->C5_NOTA <> cNota .OR. AllTrim(SC5->C5_SERIE) <> AllTrim(cSerie)
					
					cRet	:= "<RETORNO>"
					cRet	+= "<CODIGO>2003</CODIGO>"
					cRet	+= "<DESCRICAO>Erro! Nota fiscal informada diferente da nota fiscal do pedido.</DESCRICAO>"
					cRet	+= "</RETORNO>"
					Return cRet
				Case !SF2->(Dbseek( cSeekNota ))

					cRet	:= "<RETORNO>"
					cRet	+= "<CODIGO>2005</CODIGO>"
					cRet	+= "<DESCRICAO>Erro! Nota fiscal nใo localizada</DESCRICAO>"
					cRet	+= "</RETORNO>"
					Return cRet
				Case !VldCancNfe(SF2->(Recno()))
				 
					cRet	:= "<RETORNO>"
					cRet	+= "<CODIGO>2004</CODIGO>"
					cRet	+= "<DESCRICAO>Erro! Nota fiscal fora do prazo de validade para exclusใo</DESCRICAO>"
					cRet	+= "</RETORNO>"				 	
				 	Return cRet
				OtherWise
				
					lContinua := .T.		
										
			EndCase
			
			If lContinua
							
			    cNextNum := U_xGenSXE("ZZ5","ZZ5_IDFILA",4)//GetSX8Num("ZZ5","ZZ5_IDFILA",NIL,4)
			    ConfirmSX8()
			    
				Begin Transaction
					
					RecLock("ZZ5",.T.)
					ZZ5->ZZ5_FILIAL	:= cFilPro
					ZZ5->ZZ5_IDFILA	:= cNextNum
					ZZ5->ZZ5_STATUS	:= "00"//00=Aguardando processamento;01=Processo finalizad;99=Falha de processamento
					ZZ5->ZZ5_IDFUNC	:= "0003"
					ZZ5->ZZ5_DESC	:= "Cancelamento de Nota Fiscal"
					ZZ5->ZZ5_IDPEDI	:= cIdPedido
					ZZ5->ZZ5_PEDIDO	:= cPedido
					ZZ5->ZZ5_DATA	:= DDataBase
					ZZ5->ZZ5_HORA	:= Time()
					ZZ5->ZZ5_ROMANE	:= Val(cRomaneio)//SC5->C5_XROMANE
					ZZ5->ZZ5_MSG	:= "Aguardando processamento de corte do pedido!"
					ZZ5->ZZ5_DADOS	:= ""
					If !Empty(AllTrim(SC5->C5_NOTA))
						ZZ5->ZZ5_DTNF	:= SF2->F2_EMISSAO					
						ZZ5->ZZ5_NOTA	:= SF2->F2_DOC
						ZZ5->ZZ5_SERIE	:= SF2->F2_SERIE
					EndIf
					ZZ5->ZZ5_CHVASS	:= cChvAss
					MsUnLock()
					
				End Transaction	
				ConfirmSX8()
				
		    EndIf
		Else 
			
			cRet	:= "<RETORNO>"
			cRet	+= "<CODIGO>2001</CODIGO>"
			cRet	+= "<DESCRICAO>Erro! Pedido nใo localizado.</DESCRICAO>"
			cRet	+= "</RETORNO>"				
			
		EndIf		
	
	Else
		
		//ZZ5->(DbGoTo((cAliZZ5)->ZZ5REC))
		ZZ5->(DbGoTo(nAchou))
		
		Do Case
			Case ZZ5->ZZ5_STATUS == "00"
				Sleep(10000)
			Case ZZ5->ZZ5_STATUS == "01"
				cRet	:= "<RETORNO>"
				cRet	+= "<CODIGO>0000</CODIGO>"
				cRet	+= "<DESCRICAO>Processamento concluํdo com sucesso.</DESCRICAO>"
				cRet	+= "</RETORNO>"	 
				(cAliZZ5)->(DbCloseArea())
				lAuxLoop	:= .F.
				Exit			
		EndCase
				
	EndIf	

EndDo

Return cRet 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldCancNfeบAutor  ณCleuto Lima         บ Data ณ  06/06/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณvalida se nota fiscal estแ dentro do praso de cancelamento  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function VldCancNfe(nRecSF2)

Local lRet		:= .F.
Local nMinAux	:= 0

// Estแ comentado para economizar processamento pois a fun็ใo da chamada jแ posiciona na SF2
//SF2->(DbGoTo(nRecSF2))

If Empty(SF2->F2_DAUTNFE)
	lRet	:= .T.
ElseIf DateDiffDay(SF2->F2_DAUTNFE,DDataBase) == 0
	lRet	:= .T.	
ElseIf DateDiffDay(SF2->F2_DAUTNFE,DDataBase) == 1
	nHrDif1 	:= 24 - Val(Left(SF2->F2_HAUTNFE,2)) //Val(Left(SF2->F2_HAUTNFE,2))//24 - Val(Left(SF2->F2_HAUTNFE,2))
	nHrDif2	:= Val(Left(Time(),2))//24 - Val(Left(Time(),2))
	nMinAux	:= Val(Substr(SF2->F2_HAUTNFE,4,2))+Val(Substr(Time(),4,2))
	nMinAux	:= IIF( nMinAux > 60 , 1 , 0 )
	
	If nHrDif1+nHrDif2+nMinAux <= 24
		lRet := .T.
	EndIf
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPIXXFUN   บAutor  ณMicrosiga           บ Data ณ  06/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xGetObra(nIdObra,cCodSB1)

Local lObra			:= .F.
Local cAliSb1Tmp	:= GetNextAlias()

BeginSql Alias cAliSb1Tmp
	SELECT B1_COD FROM %Table:SB1% SB1
	WHERE B1_FILIAL = %xFilial:SB1%
	AND TO_NUMBER(B1_COD) = %Exp:nIdObra%
	AND SB1.%NotDel%
EndSql

(cAliSb1Tmp)->(DbGoTop())
lObra	:= !(cAliSb1Tmp)->(EOF())

cCodSB1	:= (cAliSb1Tmp)->B1_COD

(cAliSb1Tmp)->(DbcloseArea())

Return lObra