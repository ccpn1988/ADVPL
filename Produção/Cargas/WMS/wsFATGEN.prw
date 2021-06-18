#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "aarray.CH"
#INCLUDE "json.CH"
#INCLUDE "shash.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWSFATGEN  บAutor  ณCleuto Lima         บ Data ณ  20/04/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Webservice para integra็ใo Protheus x WMS PIX              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

WSSERVICE wsFATGEN DESCRIPTION "Webservice de integra็ใo Protheus x WMS PIX"
    
	// Chamadas
	WSDATA 	ws_PARAMETRO	As String
    
    // Retornos
    WSDATA 	ws_RETORNO		As String
                
    //Metodos                                                    	
	WSMETHOD	wsCortePed	DESCRIPTION "Corte nos saldos e itens do pedido."	
	//WSMETHOD	wsDesvRoma	DESCRIPTION "Desvincular o romaneio do pedido de venda. " estamos analisando se serแ mesmo utilizado
	WSMETHOD	wsGeraNfe	DESCRIPTION "Gerar nota fiscal do pedido de venda."
	WSMETHOD	wsCancRoma	DESCRIPTION "Exclusใo de romaneio."
						
ENDWSSERVICE 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณwsCortePedบAutor  ณcleuto Lima         บ Data ณ  20/04/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCorte nos saldos e itens do pedido.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

WSMETHOD wsCortePed WSRECEIVE ws_PARAMETRO WSSEND ws_RETORNO WSSERVICE wsFATGEN
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cRet		:= ""
Local cQuebra	:= Chr(13)+Chr(10)
Local oParam	:= nil
Local cErro		:= ""
Local cAviso	:= ""
Local cAliTmp	:= ""
Local cPedido	:= ""
Local cFilPed	:= ""
Local aItens	:= {} 
Local lContinua	:= .T.
Local aaItAux	:= Array(#) 
Local nTamProd	:= TamSX3("B1_COD")[1] 
Local cChvAss	:= ""//AllTrim(Encode64(AllTrim(ws_PARAMETRO)))
Local cCodSB1	:= ""

Local cBufferIn  := ws_PARAMETRO
Local nLenghtIn  := Len( cBufferIn )
Local cBufferOut := ""
Local nLenghtOut := 0

//Compress( @cBufferOut, @nLenghtOut, cBufferIn, nLenghtIn )
//cChvAss	:= AllTrim(Encode64(AllTrim(cBufferOut)))

oParam	:= XmlParser(ws_PARAMETRO,"_",@cErro,@cAviso)

Do Case
	Case !Empty(cErro) .OR. !Empty(cAviso)
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>Erro! Falha na estrutura do xml!</DESCRICAO>"
		cRet += "</RETORNO>"	
	Case ValType(oParam) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>Erro! Falha na estrutura do xml!</DESCRICAO>"
		cRet += "</RETORNO>" 
	Case Valtype(XmlChildEx( oParam, "_VAZIO" )) == "O" .OR. Valtype(XmlChildEx( oParam, "_ERROR" )) == "O" .OR. Valtype(XmlChildEx( oParam, "_ERRORS" )) == "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>Erro! Falha na estrutura do xml!</DESCRICAO>"
		cRet += "</RETORNO>"  
	Case Valtype(XmlChildEx(oParam,"_PARAMETROS")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>Erro! Falha na estrutura do xml!</DESCRICAO>"
		cRet += "</RETORNO>" 	  
	Case Valtype(XmlChildEx(oParam:_PARAMETROS,"_IDPEDIDO")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>Erro! Falha na estrutura do xml!</DESCRICAO>"
		cRet += "</RETORNO>" 								
	Case Valtype(XmlChildEx(oParam:_PARAMETROS,"_ITENS")) <> "A" .AND.  Valtype(XmlChildEx(oParam:_PARAMETROS,"_ITENS")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>Erro! Falha na estrutura do xml!</DESCRICAO>"
		cRet += "</RETORNO>"  
	Case Empty(oParam:_PARAMETROS:_IDPEDIDO:TEXT)
		cRet := "<RETORNO>"
		cRet += "<CODIGO>1001</CODIGO>"
		cRet += "<DESCRICAO>Erro! IDPEDIDO em branco.</DESCRICAO>"
		cRet += "</RETORNO>"  
	Case Empty(oParam:_PARAMETROS:_ITENS)
		cRet := "<RETORNO>"
		cRet += "<CODIGO>1007</CODIGO>"
		cRet += "<DESCRICAO>Erro! Pedido sem itens</DESCRICAO>"
		cRet += "</RETORNO>"						
	OtherWise

		If Valtype(XmlChildEx(oParam:_PARAMETROS,"_ITENS")) == "O"
			XmlNode2Arr(oParam:_PARAMETROS:_ITENS, "_ITENS" )	
		EndIf
	    
	    SB1->(DbSetOrder(1))
	    
	    For nAuxForIt := 1 To Len(oParam:_PARAMETROS:_ITENS)
			
			Do Case
				Case Valtype(XmlChildEx(oParam:_PARAMETROS:_ITENS[nAuxForIt],"_PRODUTO")) <> "O"
					
					cRet := "<RETORNO>"
					cRet += "<CODIGO>3001</CODIGO>"
					cRet += "<DESCRICAO>Erro! Falha na estrutura do xml!</DESCRICAO>"
					cRet += "</RETORNO>" 
					lContinua	:= .F.	 
					Exit			
					
				Case Valtype(XmlChildEx(oParam:_PARAMETROS:_ITENS[nAuxForIt],"_QUANTIDADE")) <> "O"
				
					cRet := "<RETORNO>"
					cRet += "<CODIGO>3001</CODIGO>"
					cRet += "<DESCRICAO>Erro! Falha na estrutura do xml!</DESCRICAO>"
					cRet += "</RETORNO>" 				
					lContinua	:= .F.  
					Exit

				Case Valtype(XmlChildEx(oParam:_PARAMETROS:_ITENS[nAuxForIt],"_QUANT_ATUAL")) <> "O"
				
					cRet := "<RETORNO>"
					cRet += "<CODIGO>3001</CODIGO>"
					cRet += "<DESCRICAO>Erro! Falha na estrutura do xml!</DESCRICAO>"
					cRet += "</RETORNO>" 				
					lContinua	:= .F.  
					Exit


				Case AllTrim(oParam:_PARAMETROS:_ITENS[nAuxForIt]:_PRODUTO:TEXT) == ""
				
					cRet := "<RETORNO>"
					cRet += "<CODIGO>1003</CODIGO>"
					cRet += "<DESCRICAO>Erro! C๓digo do produto em branco.</DESCRICAO>"
					cRet += "</RETORNO>" 				
					lContinua	:= .F.  
					Exit
					
				Case AllTrim(oParam:_PARAMETROS:_ITENS[nAuxForIt]:_QUANTIDADE:TEXT) == ""
				
					cRet := "<RETORNO>"
					cRet += "<CODIGO>1004</CODIGO>"
					cRet += "<DESCRICAO>Erro! Quantidade em branco.</DESCRICAO>"
					cRet += "</RETORNO>" 				
					lContinua	:= .F.  
					Exit

				Case !ISDIGIT(AllTrim(oParam:_PARAMETROS:_ITENS[nAuxForIt]:_QUANTIDADE:TEXT))
				
					cRet := "<RETORNO>"
					cRet += "<CODIGO>1006</CODIGO>"
					cRet += "<DESCRICAO>Erro! Quantidade nใo ้ num้rico.</DESCRICAO>"
					cRet += "</RETORNO>" 				
					lContinua	:= .F.  
					Exit
					
				Case ( cCodSB1 := "" , !U_xGetObra(Val(oParam:_PARAMETROS:_ITENS[nAuxForIt]:_PRODUTO:TEXT) ,@cCodSB1 ) ) .OR. !SB1->(DbSeek(xFilial("SB1")+AllTrim(cCodSB1)))
				
					cRet := "<RETORNO>"
					cRet += "<CODIGO>2003</CODIGO>"
					cRet += "<DESCRICAO>Erro! Produto nใo localizado no cadastro.</DESCRICAO>"
					cRet += "</RETORNO>" 				
					lContinua	:= .F.  
					Exit
																				
				OtherWise
				
					Aadd(aItens, Array(#) )
					aItens[Len(aItens)][#"PRODUTO"]		:= cCodSB1//oParam:_PARAMETROS:_ITENS[nAuxForIt]:_PRODUTO:TEXT
					aItens[Len(aItens)][#"QUANTIDADE"]		:= Val(oParam:_PARAMETROS:_ITENS[nAuxForIt]:_QUANTIDADE:TEXT)
					aItens[Len(aItens)][#"QUANT_ATUAL"]	:= Val(oParam:_PARAMETROS:_ITENS[nAuxForIt]:_QUANT_ATUAL:TEXT)					
					aItens[Len(aItens)][#"ITEM"]			:= oParam:_PARAMETROS:_ITENS[nAuxForIt]:_NITEM:TEXT
					
			EndCase
			
	    Next nAuxForIt
	    
	    If Len(aItens) == 0 .AND. lContinua
			cRet := "<RETORNO>"
			cRet += "<CODIGO>1007</CODIGO>"
			cRet += "<DESCRICAO>Erro! Pedido sem itens</DESCRICAO>"
			cRet += "</RETORNO>" 
			lContinua := .F.	    	
	    EndIF
	    
	    If lContinua
	    
			cFilPed	:= Left(oParam:_PARAMETROS:_IDPEDIDO:TEXT,2)
			cPedido	:= Right(oParam:_PARAMETROS:_IDPEDIDO:TEXT,6)			
			cAliTmp	:= GetNextAlias()
			
			BeginSql Alias cAliTmp
				SELECT C5_NUM,C5_XROMANE,R_E_C_N_O_ C5REC,C5_NOTA,C5_SERIE,C5_FILIAL FROM %Table:SC5% SC5
				JOIN TT_I10_FILIAL_GEN_TOTVS I10  
				ON I10.IDEMPRESATOTVS = TO_NUMBER(TRIM(SC5.C5_FILIAL))
				AND IDEMPRESAGEN = %Exp: Val(cFilPed) %
				WHERE C5_NUM = %Exp:cPedido%
				AND SC5.%Notdel%
			EndSql
			
			(cAliTmp)->(DbGoTop())
			
			Do Case
				Case (cAliTmp)->(EOF()) 
				
					cRet := "<RETORNO>"
					cRet += "<CODIGO>2001</CODIGO>"
					cRet += "<DESCRICAO>Erro! Pedido nใo localizado.</DESCRICAO>"								
					cRet += "</RETORNO>"    
					
				Case !EMPTY((cAliTmp)->C5_NOTA)
			
					cRet := "<RETORNO>"
					cRet += "<CODIGO>2006</CODIGO>"
					cRet += "<DESCRICAO>Erro! Pedido com nota fiscal emitida.</DESCRICAO>"
					cRet += "</RETORNO>"
				
				OtherWise
                    /*
					SC6->(DbSetOrder(2))
					For nAuxForIt := 1 To Len(aItens)
					
						cChavePed := (cAliTmp)->C5_FILIAL+PadR(aItens[nAuxForIt][#"PRODUTO"],nTamProd)+cPedido
						If !SC6->(DbSeek( cChavePed ))
							cRet := "<RETORNO>"
							cRet += "<CODIGO>2002</CODIGO>"
							cRet += "<DESCRICAO>Erro! Item nใo localizado.</DESCRICAO>"
							cRet += "</RETORNO>"
							lContinua	:= .F.
							Exit
						ElseIf SC6->C6_QTDVEN <> aItens[nAuxForIt][#"QUANT_ATUAL"]
							cRet := "<RETORNO>"
							cRet += "<CODIGO>2007</CODIGO>"
							cRet += "<DESCRICAO>Erro! Quantidade atual diferente do pedido.</DESCRICAO>"
							cRet += "</RETORNO>"
							lContinua	:= .F.
							Exit
						EndIf
													
					Next nAuxForIt
			        */

					SB1->(DbSetOrder(1))
					For nAuxBIt := 1 To Len(aItens)
					
						cChavePed := xFilial("SB1")+PadR(aItens[nAuxBIt][#"PRODUTO"],nTamProd)
						If !SB1->(DbSeek( cChavePed ))
							cRet := "<RETORNO>"
							cRet += "<CODIGO>2002</CODIGO>"
							cRet += "<DESCRICAO>Erro! Item nใo localizado.</DESCRICAO>"
							cRet += "</RETORNO>"
							lContinua	:= .F.
							Exit
						EndIf

					Next nAuxBIt
								        
			        If lContinua
						cBufferIn	:= ""
						SB1->(DbSetOrder(1))
						For nAuxBIt := 1 To Len(aItens)
							cBufferIn+="<pedido>"+AllTrim(oParam:_PARAMETROS:_IDPEDIDO:TEXT)+"</pedido>"
							cBufferIn+="<prod>"+AllTrim(aItens[nAuxBIt][#"PRODUTO"])+"<prod>"
							cBufferIn+="<item>"+AllTrim(aItens[nAuxBIt][#"ITEM"])+"<item>"							
							cBufferIn+="<qtdcorte>"+AllTrim(Str(aItens[nAuxBIt][#"QUANTIDADE"]))+"<qtdcorte>"
							cBufferIn+="<qtdatu>"+AllTrim(Str(aItens[nAuxBIt][#"QUANT_ATUAL"]))+"<qtdatu>"														
						Next nAuxBIt
						nLenghtIn  := Len( cBufferIn )
									        
						Compress( @cBufferOut, @nLenghtOut, cBufferIn, nLenghtIn )
						cChvAss	:= AllTrim(Encode64(AllTrim(cBufferOut)))
						
						cRet := U_PixPedido(oParam:_PARAMETROS:_IDPEDIDO:TEXT,cFilPed,cPedido,aItens,cChvAss,oParam:_PARAMETROS:_ROMANEIO:TEXT)
					EndIF
						
			EndCase
			
			(cAliTmp)->(DbCloseArea())		
		EndIf
				
EndCase

/* Estrutura XML parametro de entrada (ws_PARAMETRO)
<PARAMETROS>
	<IDPEDIDO></IDPEDIDO>
		<ITENS nItem="1">
			<PRODUTO></PRODUTO>
			<QUANTIDADE></QUANTIDADE>
		</ITENS>
		<ITENS nItem="2">
			<PRODUTO></PRODUTO>
			<QUANTIDADE></QUANTIDADE>
	</ITENS>
</ PARAMETROS>

*/

If ValType(oParam) == "O"
	FreeObj(oParam)
EndIF
::ws_RETORNO	:= cRet
	
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณwsGeraNfe บAutor  ณCleuto Lima         บ Data ณ  09/05/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGerar nota fiscal do pedido de venda.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen.                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

WSMETHOD wsGeraNfe WSRECEIVE ws_PARAMETRO WSSEND ws_RETORNO WSSERVICE wsFATGEN 
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cRet		:= ""
Local cQuebra	:= Chr(13)+Chr(10)
Local oParam	:= nil
Local cErro		:= ""
Local cAviso	:= ""
Local cChvAss	:= ""//AllTrim(Encode64(AllTrim(ws_PARAMETRO)))

Local cBufferIn  := ws_PARAMETRO
Local nLenghtIn  := Len( cBufferIn )
Local cBufferOut := ""
Local nLenghtOut := 0

//Compress( @cBufferOut, @nLenghtOut, cBufferIn, nLenghtIn )
//cChvAss	:= cBufferOut

oParam	:= XmlParser(ws_PARAMETRO,"_",@cErro,@cAviso)

Do Case
	Case !Empty(cErro) .OR. !Empty(cAviso)
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>Erro! Falha de estrutura XML</DESCRICAO>"     
		cRet += "<NOTA></NOTA>"
		cRet += "<SERIE></SERIE>"						
		cRet += "<EMISSAO></EMISSAO>"		
		cRet += "</RETORNO>"	
	Case ValType(oParam) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "<NOTA></NOTA>"
		cRet += "<SERIE></SERIE>"								
		cRet += "<EMISSAO></EMISSAO>"
		cRet += "</RETORNO>"  
	Case Valtype(XmlChildEx( oParam, "_VAZIO" )) == "O" .OR. Valtype(XmlChildEx( oParam, "_ERROR" )) == "O" .OR. Valtype(XmlChildEx( oParam, "_ERRORS" )) == "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "<NOTA></NOTA>"
		cRet += "<SERIE></SERIE>"								
		cRet += "<EMISSAO></EMISSAO>"
		cRet += "</RETORNO>"  
	Case Valtype(XmlChildEx(oParam,"_PARAMETROS")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "<NOTA></NOTA>"
		cRet += "<SERIE></SERIE>"								
		cRet += "<EMISSAO></EMISSAO>"												
		cRet += "</RETORNO>"  	  
	Case Valtype(XmlChildEx(oParam:_PARAMETROS,"_IDPEDIDO")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "<NOTA></NOTA>"
		cRet += "<SERIE></SERIE>"								
		cRet += "<EMISSAO></EMISSAO>"												
		cRet += "</RETORNO>"  								
	Case Valtype(XmlChildEx(oParam:_PARAMETROS,"_ROMANEIO")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "<NOTA></NOTA>"
		cRet += "<SERIE></SERIE>"								
		cRet += "<EMISSAO></EMISSAO>"												
		cRet += "</RETORNO>"		
	Case Valtype(XmlChildEx(oParam:_PARAMETROS,"_PESOBRUTO")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "<NOTA></NOTA>"
		cRet += "<SERIE></SERIE>"								
		cRet += "<EMISSAO></EMISSAO>"												
		cRet += "</RETORNO>"		
	Case Valtype(XmlChildEx(oParam:_PARAMETROS,"_QTDEVOLUME_CX")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "<NOTA></NOTA>"
		cRet += "<SERIE></SERIE>"								
		cRet += "<EMISSAO></EMISSAO>"												
		cRet += "</RETORNO>"
	Case Valtype(XmlChildEx(oParam:_PARAMETROS,"_PESOLIQUIDO")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "<NOTA></NOTA>"
		cRet += "<SERIE></SERIE>"								
		cRet += "<EMISSAO></EMISSAO>"												
		cRet += "</RETORNO>" 
	Case Empty(oParam:_PARAMETROS:_PESOBRUTO:TEXT)
		cRet := "<RETORNO>"
		cRet += "<CODIGO>2004</CODIGO>"
		cRet += "<DESCRICAO>Erro! Peso bruto nใo informado</DESCRICAO>"
		cRet += "<NOTA></NOTA>"
		cRet += "<SERIE></SERIE>"								
		cRet += "<EMISSAO></EMISSAO>"												
		cRet += "</RETORNO>"		
	Case Empty(oParam:_PARAMETROS:_PESOLIQUIDO:TEXT)
		cRet := "<RETORNO>"
		cRet += "<CODIGO>2005</CODIGO>"
		cRet += "<DESCRICAO>Erro! Peso liquido nใo informado</DESCRICAO>"
		cRet += "<NOTA></NOTA>"
		cRet += "<SERIE></SERIE>"								
		cRet += "<EMISSAO></EMISSAO>"												
		cRet += "</RETORNO>"
	Case Empty(oParam:_PARAMETROS:_QTDEVOLUME_CX:TEXT)
		cRet := "<RETORNO>"
		cRet += "<CODIGO>2006</CODIGO>"
		cRet += "<DESCRICAO>Erro! Volume nใo informado</DESCRICAO>"
		cRet += "<NOTA></NOTA>"
		cRet += "<SERIE></SERIE>"								                            
		cRet += "<EMISSAO></EMISSAO>"												
		cRet += "</RETORNO>"																
	Case Empty(oParam:_PARAMETROS:_IDPEDIDO:TEXT)
		cRet := "<RETORNO>"
		cRet += "<CODIGO>1001</CODIGO>"
		cRet += "<DESCRICAO>Erro! IDPEDIDO em branco.</DESCRICAO>"
		cRet += "<NOTA></NOTA>"
		cRet += "<SERIE></SERIE>"								
		cRet += "<EMISSAO></EMISSAO>"												
		cRet += "</RETORNO>"		
	Case Empty(oParam:_PARAMETROS:_ROMANEIO:TEXT)
		cRet := "<RETORNO>"
		cRet += "<CODIGO>1002</CODIGO>"
		cRet += "<DESCRICAO>Erro! Romaneio em branco.</DESCRICAO>"
		cRet += "<NOTA></NOTA>"
		cRet += "<SERIE></SERIE>"
		cRet += "<EMISSAO></EMISSAO>"										
		cRet += "</RETORNO>"		
	OtherWise
	    
		cFilPed	:= Left(oParam:_PARAMETROS:_IDPEDIDO:TEXT,2)
		cPedido	:= Right(oParam:_PARAMETROS:_IDPEDIDO:TEXT,6)			
		cAliTmp	:= GetNextAlias()
		
		BeginSql Alias cAliTmp
			SELECT C5_NUM,C5_XROMANE,SC5.R_E_C_N_O_ C5REC,C5_NOTA,C5_SERIE,F2_EMISSAO FROM %Table:SC5% SC5
			JOIN TT_I10_FILIAL_GEN_TOTVS I10  
			ON I10.IDEMPRESATOTVS = TO_NUMBER(TRIM(SC5.C5_FILIAL))
			AND IDEMPRESAGEN = %Exp: Val(cFilPed) %
			LEFT JOIN SF2000 SF2
			ON F2_FILIAL = C5_FILIAL
			AND F2_DOC = C5_NOTA
			AND F2_SERIE = C5_SERIE
			AND SF2.%NotDel%
			WHERE C5_NUM = %Exp:cPedido%
			AND SC5.%Notdel%
		EndSql
		
		(cAliTmp)->(DbGoTop())
		
		
		Do Case
			Case (cAliTmp)->(EOF()) 
			
				cRet := "<RETORNO>"
				cRet += "<CODIGO>2001</CODIGO>"
				cRet += "<DESCRICAO>Erro! Pedido nใo localizado.</DESCRICAO>"
				cRet += "<NOTA></NOTA>"
				cRet += "<SERIE></SERIE>"								
				cRet += "<EMISSAO></EMISSAO>"				
				cRet += "</RETORNO>"  
			/*
			Case (cAliTmp)->C5_XROMANE <> Val(oParam:_PARAMETROS:_ROMANEIO:TEXT) .AND. (cAliTmp)->C5_XROMANE > 0
		
				cRet := "<RETORNO>"
				cRet += "<CODIGO>2002</CODIGO>"
				cRet += "<DESCRICAO>Erro! Romaneio informado diferente do romaneio do pedido.</DESCRICAO>"
				cRet += "<NOTA></NOTA>"
				cRet += "<SERIE></SERIE>"								
				cRet += "<EMISSAO></EMISSAO>"
				cRet += "</RETORNO>"   
				*/
			Case !EMPTY((cAliTmp)->C5_NOTA)// .AND. .F./* .F. apenas para teste deve remover*/
		
				cRet := "<RETORNO>"
				cRet += "<CODIGO>0001</CODIGO>"
				cRet += "<DESCRICAO>Aten็ใo! Processamento concluํdo, mas o pedido jแ continha nota fiscal emitida.</DESCRICAO>"
				cRet += "<NOTA>"+(cAliTmp)->C5_NOTA+"</NOTA>"
				cRet += "<SERIE>"+Alltrim((cAliTmp)->C5_SERIE)+"</SERIE>"
				cRet += "<EMISSAO>"+DtoC(StoD((cAliTmp)->F2_EMISSAO))+"</EMISSAO>"				
				cRet += "</RETORNO>"
			
			OtherWise
		        
		        cChvAss	:= "IDPEDIDO_"+AllTrim(oParam:_PARAMETROS:_IDPEDIDO:TEXT)+"_ROMANEIO_"+AllTrim(oParam:_PARAMETROS:_ROMANEIO:TEXT)
		        
				cRet := U_PixDanfe(oParam:_PARAMETROS:_IDPEDIDO:TEXT,cFilPed,cPedido,oParam:_PARAMETROS:_ROMANEIO:TEXT,oParam:_PARAMETROS:_PESOBRUTO:TEXT,oParam:_PARAMETROS:_PESOLIQUIDO:TEXT,oParam:_PARAMETROS:_QTDEVOLUME_CX:TEXT,cChvAss)
					
		EndCase
		
		(cAliTmp)->(DbCloseArea())
EndCase

If ValType(oParam) == "O"
	FreeObj(oParam)
EndIF
::ws_RETORNO	:= cRet
	
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณwsCancRomaบAutor  ณCleuto Lima         บ Data ณ  09/05/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExclusใo de romaneio.                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen.                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

WSMETHOD wsCancRoma WSRECEIVE ws_PARAMETRO WSSEND ws_RETORNO WSSERVICE wsFATGEN 
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cRet		:= ""
Local cQuebra	:= Chr(13)+Chr(10)
Local oParam	:= nil
Local cErro		:= ""
Local cAviso	:= ""

Local cFilPed	:= ""
Local cPedido	:= ""
Local cAliTmp	:= ""

Local cNota		:= ""
Local cSerie	:= ""

Local cChvAss	:= ""//AllTrim(Encode64(AllTrim(ws_PARAMETRO)))
Local cBufferIn  := ws_PARAMETRO
Local nLenghtIn  := Len( cBufferIn )
Local cBufferOut := ""
Local nLenghtOut := 0

Compress( @cBufferOut, @nLenghtOut, cBufferIn, nLenghtIn )
cChvAss	:= cBufferOut

oParam	:= XmlParser(ws_PARAMETRO,"_",@cErro,@cAviso)

/*  

Modelo de entrada

<PARAMETROS>
	<IDPEDIDO></IDPEDIDO>
	<ROMANEIO></ROMANEIO>
	<IDDEPOSITO></IDDEPOSITO>
	<NOTA></NOTA>
	<SERIE></SERIE>
</PARAMETROS>

*/
Do Case
	Case !Empty(cErro) .OR. !Empty(cAviso)
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>"+cErro+"</DESCRICAO>"     
		cRet += "</RETORNO>"	
	Case ValType(oParam) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "</RETORNO>"  
	Case Valtype(XmlChildEx( oParam, "_VAZIO" )) == "O" .OR. Valtype(XmlChildEx( oParam, "_ERROR" )) == "O" .OR. Valtype(XmlChildEx( oParam, "_ERRORS" )) == "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "</RETORNO>"  
	Case Valtype(XmlChildEx(oParam,"_PARAMETROS")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "</RETORNO>"  
	Case Valtype(XmlChildEx(oParam:_PARAMETROS,"_IDPEDIDO")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "</RETORNO>" 
	Case Valtype(XmlChildEx(oParam:_PARAMETROS,"_ROMANEIO")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "</RETORNO>" 
	Case Valtype(XmlChildEx(oParam:_PARAMETROS,"_IDDEPOSITO")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "</RETORNO>" 
	Case Valtype(XmlChildEx(oParam:_PARAMETROS,"_NOTA")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "</RETORNO>" 									
	Case Valtype(XmlChildEx(oParam:_PARAMETROS,"_SERIE")) <> "O"
		cRet := "<RETORNO>"
		cRet += "<CODIGO>3001</CODIGO>"
		cRet += "<DESCRICAO>FALHA NA ESTRUTURA DO XML DE PARAMETORS</DESCRICAO>"
		cRet += "</RETORNO>"		
	Case Empty(oParam:_PARAMETROS:_IDPEDIDO:TEXT)
		cRet := "<RETORNO>"
		cRet += "<CODIGO>1001</CODIGO>"
		cRet += "<DESCRICAO>Erro! Parโmetro IDPEDIDO em branco.</DESCRICAO>"
		cRet += "</RETORNO>"	
	Case Empty(oParam:_PARAMETROS:_ROMANEIO:TEXT)
		cRet := "<RETORNO>"
		cRet += "<CODIGO>1002</CODIGO>"
		cRet += "<DESCRICAO>Erro! Parโmetro Romaneio em branco.</DESCRICAO>"
		cRet += "</RETORNO>"   
	Case Empty(oParam:_PARAMETROS:_NOTA:TEXT)
		cRet := "<RETORNO>"
		cRet += "<CODIGO>1003</CODIGO>"
		cRet += "<DESCRICAO>Erro! Parโmetro Nota fiscal em branco.</DESCRICAO>"
		cRet += "</RETORNO>" 
	Case Empty(oParam:_PARAMETROS:_SERIE:TEXT)
		cRet := "<RETORNO>"
		cRet += "<CODIGO>1004</CODIGO>"
		cRet += "<DESCRICAO>Erro! Parโmetro S้rie em branco.</DESCRICAO>"
		cRet += "</RETORNO>"							

	OtherWise

		cFilPed	:= Left(oParam:_PARAMETROS:_IDPEDIDO:TEXT,2)
		cPedido	:= Right(oParam:_PARAMETROS:_IDPEDIDO:TEXT,6)			
		cAliTmp	:= GetNextAlias() 
		
		cNota	:= PadL( AllTrim(oParam:_PARAMETROS:_NOTA:TEXT),9,"0" )
		cSerie	:= AllTrim(oParam:_PARAMETROS:_SERIE:TEXT)
		
		BeginSql Alias cAliTmp
			SELECT C5_NUM,C5_XROMANE,R_E_C_N_O_ C5REC,C5_NOTA,C5_SERIE,C5_FILIAL FROM %Table:SC5% SC5
			JOIN TT_I10_FILIAL_GEN_TOTVS I10  
			ON I10.IDEMPRESATOTVS = TO_NUMBER(TRIM(SC5.C5_FILIAL))
			AND IDEMPRESAGEN = %Exp: Val(cFilPed) %
			WHERE C5_NUM = %Exp:cPedido%
			AND SC5.%Notdel%
		EndSql
		
		(cAliTmp)->(DbGoTop())
		
		
		Do Case
			Case (cAliTmp)->(EOF()) 
			
				cRet := "<RETORNO>"
				cRet += "<CODIGO>2001</CODIGO>"
				cRet += "<DESCRICAO>Erro! Pedido nใo localizado.</DESCRICAO>"								
				cRet += "</RETORNO>"  
			/*
			Case (cAliTmp)->C5_XROMANE <> Val(oParam:_PARAMETROS:_ROMANEIO:TEXT)
		
				cRet := "<RETORNO>"
				cRet += "<CODIGO>2002</CODIGO>"
				cRet += "<DESCRICAO>Erro! Romaneio informado diferente do romaneio do pedido.</DESCRICAO>"
				cRet += "</RETORNO>"   
				
			Case EMPTY((cAliTmp)->C5_NOTA)
		
				cRet := "<RETORNO>"
				cRet += "<CODIGO>????</CODIGO>"
				cRet += "<DESCRICAO>Erro! Pedido sem nota fiscal emtida!</DESCRICAO>"
				cRet += "</RETORNO>"

			Case (cAliTmp)->C5_NOTA <> cNota .OR. AllTrim((cAliTmp)->C5_SERIE) <> cSerie
		
				cRet := "<RETORNO>"
				cRet += "<CODIGO>2003</CODIGO>"
				cRet += "<DESCRICAO>Erro! Nota fiscal informada diferente da nota fiscal do pedido.</DESCRICAO>"
				cRet += "</RETORNO>"
			*/				
			OtherWise
		        
				cRet := U_PixCanRo((cAliTmp)->C5REC,oParam:_PARAMETROS:_IDPEDIDO:TEXT,cFilPed,cPedido,cChvAss,cNota,cSerie,(cAliTmp)->C5_FILIAL,oParam:_PARAMETROS:_ROMANEIO:TEXT)
					
		EndCase
		
		(cAliTmp)->(DbCloseArea())

EndCase

If ValType(oParam) == "O"
	FreeObj(oParam)
EndIF 

::ws_RETORNO	:= cRet
	
Return .T.  
