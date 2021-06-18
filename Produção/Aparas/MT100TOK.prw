#INCLUDE "PROTHEUS.CH"

#DEFINE ND2COD		1
#DEFINE ND2ITEM    2
#DEFINE ND2NFORI   3
#DEFINE ND2SERIORI 4
#DEFINE ND2ITEMORI 5
#DEFINE NF4PODER3  6 
#DEFINE NF4CODIGO	7
#DEFINE ND2LOCAL	8


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT100TOK  บAutor  ณcleuto Lima         บ Data ณ  06/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada chamado no TudoOk da tela de documento de  บฑฑ
ฑฑบ          ณentrada.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT100TOK()

Local lRet		:= .T.
Local nFDup		:= 0
Local cNatCC	:= ""
Local cNatOri	:= ""
Local cNatGra	:= ""
Local lFin		:= .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVALIDA SE A NATUREZA FOI INFORMADA NAS NOTAS FISCAIS DE  ณ
//ณDEVOLUวรO.                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If cTipo == "D" .AND. !( upper(alltrim(GetEnvServer())) $ "SCHEDULE" )
	
	If Type("OFOLDER:ADIALOGS") == "A"
	    
		lFin	:= AllTrim(Posicione("SF4",1,xFilial("SF4")+GdFieldGet("D1_TES"),"F4_DUPLIC")) == "S"

		If lFin
			nFDup		:= aScan(OFOLDER:ADIALOGS,{|x| Upper(AllTrim(x:CCAPTION)) == "DUPLICATAS" })
			nVarNat	:= aScan(OFOLDER:ADIALOGS[nFDup]:OWND:ACONTROLS, {|x| Upper(AllTrim(x:CREADVAR)) == "CNATUREZA" })
			cNatCC		:= AllTrim(GetMv("GENI018CAR"))+"#"+AllTrim(GetMv("GENI018BOL"))
			cNatGra	:= AllTrim(SuperGetMv("GEN_FIN005",.F.," "))	
			
			If Empty(AllTrim(OFOLDER:ADIALOGS[nFDup]:OWND:ACONTROLS[nVarNat]:CTEXT))			
				cNatOri := AllTrim(Posicione("SE1",1,xFilial("SE1")+GdFieldGet("D1_SERIORI")+GdFieldGet("D1_NFORI"),"E1_NATUREZ"))//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO				
				If cNatOri $ cNatCC
					cNatGra := cNatOri
				EndIf							
				xMagHelpFis("Natureza financeira","Natureza financeira ้ obrigat๓ria para este tipo de nota fiscal.","Na aba duplicatas deve ser informado no campo natureza o c๓digo "+cNatGra)
				Return .F.
			EndIf
		EndIf	
	EndIf
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณChamada para valida็ใo dos dados da nota fiscal de origemณ
//ณnas notas intercompany.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

lRet	:= VldNfInterCia()

If lRet

	For nAuxIt := 1 To Len(aCols)
		
		If !Empty(GdFieldGet("D1_TES",nAuxIt,.F.,aHeader, aCols))
			Loop
		EndIf
		
		If GdFieldGet("D1_TES",nAuxIt,.F.,aHeader, aCols) <> SF4->F4_CODIGO
			SF4->(DbSetOrder(1))
			SF4->(DbSeek( xFilial("SF4") + GdFieldGet("D1_TES",nAuxIt,.F.,aHeader, aCols) ))			
		EndIf
		
		If !("SCHEDULE" $ upper(alltrim(GetEnvServer())) ) .AND.  !Empty(AllTrim(SF4->F4_XCONTA)) .AND. ( SF4->F4_LFICM <> 'N' .OR. SF4->F4_LFIPI <> 'N' .OR. SF4->F4_LFISS <> 'N' .OR. SF4->F4_PISCOF <> '4' )
			If Empty(GdFieldGet("D1_CONTA",nAuxIt,.F.,aHeader, aCols))
				 lRet := .F.
				 If ( upper(alltrim(GetEnvServer())) $ "SCHEDULE" )
				 	AutoGrLog( "MT100TOK - Conta contabil nใo informada para o item "+GdFieldGet("D1_TES",nAuxIt,.F.,aHeader, aCols)+" e TES que gera livro fiscal!" )						
				 Else
				 	MsgStop( "Conta contabil nใo informada para o item "+GdFieldGet("D1_TES",nAuxIt,.F.,aHeader, aCols)+" e TES que gera livro fiscal!" )
				 EndIf
				 Exit
			EndIf
		EndIf		
	Next
				
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldNfInterCiaบAutor  ณCleuto Lima         บ Data ณ  06/06/17   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณvalida็ใo das notas intercia.                                  บฑฑ
ฑฑบ          ณ                                                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                           บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldNfInterCia()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aAreaSA1	:= SA1->(GetArea())		
Local lRet		:= .T.
Local nAuxIt	:= 0
Local cQbrLin	:= Chr(13)+Chr(10)
Local aDados	:= {}
Local cCtrPd3	:= "" 
Local cMsgErro	:= ""
Local lContPd3	:= .F.

If cTipo $ "B#D" .AND. cFilAnt <> "1022"
	/* verificar se tem TES que controla poder de 3 para realizar a valida็ใo da nota de origem */
	For nAuxIt := 1 To Len(aCols)
		If Posicione("SF4",1,xFilial("SF4")+GdFieldGet("D1_TES",nAuxIt,.F.,aHeader, aCols),"F4_PODER3") $ "D$R"
			lContPd3	:= .T.
			Exit
		EndIf
	Next

	If AllTrim(cA100For) $ "0380795#0380796#0380794#031811#0378128#0005065" .AND. lContPd3 .AND. Posicione("SA1",1,xFilial("SA1")+cA100For+cLoja,"A1_CGC") <> SM0->M0_CGC
		
		If Select("TMPNFORI") > 0
			TMPNFORI->(DbCloseArea())
		EndIf
				
		/* BUSCA OS DADOS DA NOTA DE SAIDA NA FILIAL QUE EMITIU A NOTA*/
		BeginSql Alias "TMPNFORI"
			SELECT
				D2_COD,D2_ITEM,D2_NFORI,D2_SERIORI,D2_ITEMORI,D2_QUANT,
				F4_PODER3,F4_CODIGO,D2_LOCAL				
			FROM %Table:SD2% SD2
			JOIN %Table:SF4% SF4
			ON F4_FILIAL = %xFilial:SF4%
			AND F4_CODIGO = D2_TES
			AND SF4.%NotDel%
			WHERE D2_FILIAL = DECODE(%Exp:cA100For%,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022','0005065','1022')
			AND D2_DOC = %Exp:cNFiscal%
			AND D2_SERIE = %Exp:cSerie%
			AND D2_CLIENTE = DECODE(%xFilial:SF1%,'2022','0380795','3022','0380796','4022','0380794','6022','031811 ','9022','0378128')
			AND SD2.%NotDel%
			ORDER BY D2_ITEM
		EndSql
		TMPNFORI->(DbGoTop())
		
		While TMPNFORI->(!EOF())			
			nQtdIt	:= 0
			
			If cSerie == "4" .OR. TMPNFORI->D2_LOCAL $ "03#06"/* quando serie 4 o item origem da SD2 pode nใo ser o mesmo da SD1 */
				cChvSD2	:= AllTrim(TMPNFORI->D2_COD)+AllTrim(TMPNFORI->D2_NFORI)+PadL("0",TamSx3("D2_ITEMORI")[1],"0")+PadL(AllTrim(TMPNFORI->D2_SERIORI),TamSx3("D2_SERIORI")[1],"0")
			Else
				cChvSD2	:= AllTrim(TMPNFORI->D2_COD)+AllTrim(TMPNFORI->D2_NFORI)+PadL(AllTrim(TMPNFORI->D2_ITEMORI),TamSx3("D2_ITEMORI")[1],"0")+PadL(AllTrim(TMPNFORI->D2_SERIORI),TamSx3("D2_SERIORI")[1],"0")
			EndIf
			
			If AllTrim(cSerie) == "4"
				nFirtLoop	:= 0
			Else
				nFirtLoop	:= 2
			EndIf
			
			While nFirtLoop <= 2
				nFirtLoop++
				For nAuxIt := 1 To Len(aCols)
				If cSerie == "4" .OR. TMPNFORI->D2_LOCAL $ "03#06" /* quando serie 4 o item origem da SD2 pode nใo ser o mesmo da SD1 */
						If nFirtLoop == 1 // a primeira vez tento com o item origem
							cChvSD1 :=	AllTrim(GdFieldGet("D1_COD",nAuxIt,.F.,aHeader, aCols))+;
										AllTrim(GdFieldGet("D1_NFORI",nAuxIt,.F.,aHeader, aCols))+;							
										PadL(	AllTrim(GdFieldGet("D1_ITEMORI",nAuxIt,.F.,aHeader, aCols)),TamSx3("D2_ITEMORI")[1],"0")+;
										PadL(	AllTrim(GdFieldGet("D1_SERIORI",nAuxIt,.F.,aHeader, aCols)),TamSx3("D2_SERIORI")[1],"0")				
							
						Else
							cChvSD1 :=	AllTrim(GdFieldGet("D1_COD",nAuxIt,.F.,aHeader, aCols))+;
										AllTrim(GdFieldGet("D1_NFORI",nAuxIt,.F.,aHeader, aCols))+;							
										PadL(	"0",TamSx3("D2_ITEMORI")[1],"0")+;
										PadL(	AllTrim(GdFieldGet("D1_SERIORI",nAuxIt,.F.,aHeader, aCols)),TamSx3("D2_SERIORI")[1],"0")
						EndIf			
					Else
						cChvSD1 :=	AllTrim(GdFieldGet("D1_COD",nAuxIt,.F.,aHeader, aCols))+;
									AllTrim(GdFieldGet("D1_NFORI",nAuxIt,.F.,aHeader, aCols))+;							
									PadL(	AllTrim(GdFieldGet("D1_ITEMORI",nAuxIt,.F.,aHeader, aCols)),TamSx3("D2_ITEMORI")[1],"0")+;
									PadL(	AllTrim(GdFieldGet("D1_SERIORI",nAuxIt,.F.,aHeader, aCols)),TamSx3("D2_SERIORI")[1],"0")				
					EndIf
					
					If cChvSD1 == cChvSD2 
						If AllTrim(cSerie) == "4"
							If TMPNFORI->D2_QUANT == GdFieldGet("D1_QUANT",nAuxIt,.F.,aHeader, aCols)
								nFirtLoop	:= 3
								nQtdIt+=GdFieldGet("D1_QUANT",nAuxIt,.F.,aHeader, aCols)
								Exit
							EndIf
						Else
							nQtdIt+=GdFieldGet("D1_QUANT",nAuxIt,.F.,aHeader, aCols)
						EndIf	
					EndIf
				Next
			EndDo
			
			If nQtdIt == 0
				cMsgErro += "Nใo localizei a digita็ใo da nota de origem "+AllTrim(TMPNFORI->D2_NFORI)+" para o produto "+AllTrim(TMPNFORI->D2_COD)+", esta nota origem foi informada na nota de saida do Gen!"+cQbrLin
			ElseIf nQtdIt <> TMPNFORI->D2_QUANT
				cMsgErro += "Quantidade informada ้ diferente a quantidade da nota de origem "+AllTrim(TMPNFORI->D2_NFORI)+" para o produto "+AllTrim(TMPNFORI->D2_COD)+", quantidade origem "+AllTrim(cValToChar(TMPNFORI->D2_QUANT))+", quantidade informada "+AllTrim(cValToChar(nQtdIt))+cQbrLin
			EndIf
			
			TMPNFORI->(DbSkip())
		EndDo
				
		TMPNFORI->(DbEval( {|x| Aadd(aDados, { TMPNFORI->D2_COD,TMPNFORI->D2_ITEM,TMPNFORI->D2_NFORI,TMPNFORI->D2_SERIORI,TMPNFORI->D2_ITEMORI,TMPNFORI->F4_PODER3,TMPNFORI->F4_CODIGO,TMPNFORI->D2_LOCAL } ) } ))
		TMPNFORI->(DbCloseArea())		
		
		For nAuxIt := 1 To Len(aCols)
			/* quando serie 4 o item origem da SD2 pode nใo ser o mesmo da SD1 */
			If aScan(aDados, {|x| ;
								AllTrim(x[ND2COD]) == AllTrim(GdFieldGet("D1_COD",nAuxIt,.F.,aHeader, aCols)) .AND.;
								AllTrim(x[ND2NFORI]) == AllTrim(GdFieldGet("D1_NFORI",nAuxIt,.F.,aHeader, aCols)) .AND.;
								AllTrim(x[ND2SERIORI]) == AllTrim(GdFieldGet("D1_SERIORI",nAuxIt,.F.,aHeader, aCols)) .AND.;
								( AllTrim(x[ND2ITEMORI]) == AllTrim(GdFieldGet("D1_ITEMORI",nAuxIt,.F.,aHeader, aCols)) .OR. cSerie == "4" .or. x[ND2LOCAL] $ "03#06" );
								} ) == 0 
								
				cMsgErro += "Item:"+GdFieldGet("D1_ITEM",nAuxIt,.F.,aHeader, aCols)+", Nota fiscal de origem nใo localizada "+GdFieldGet("D1_NFORI",nAuxIt,.F.,aHeader, aCols)+" na nota de saida emitida pelo Gen!"+cQbrLin
				
			EndIf
		Next nAuxIt					
	EndIf
	
	If !Empty(cMsgErro)		
		lRet	:= .F.
		xMagHelpFis("Inconsist๊ncia entre entrada e nota de saํda da origem",cMsgErro,"Verifique se os dados de nota de origem estใo de acordo com a nota de saida emitida pelo Gen!")
		AutoGrLog( "Inconsist๊ncia entre entrada e nota de saํda da origem")
		AutoGrLog( "Nota: "+cNFiscal)
		AutoGrLog( "Serie: "+cSerie)
		AutoGrLog( "Fornecedor: "+cA100For)
		AutoGrLog( cMsgErro)
		AutoGrLog( "Verifique se os dados de nota de origem estใo de acordo com a nota de saida emitida pelo Gen!") 
	EndIf
	
	RestArea(aAreaSA1)
	
EndIf

Return lRet
