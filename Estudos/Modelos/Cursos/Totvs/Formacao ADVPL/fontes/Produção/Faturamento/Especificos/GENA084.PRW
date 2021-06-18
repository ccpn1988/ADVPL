#include "rwmake.ch"
#include "protheus.ch"

#DEFINE P_FILIAL		01
#DEFINE P_PEDIDO		02
#DEFINE P_ITEM		03
#DEFINE P_DESCRI		04
#DEFINE P_TES			05
#DEFINE P_QTDSOL		06
#DEFINE P_QTDATE		07
#DEFINE P_PRCUNIT		08
#DEFINE P_PRCVEN		09
#DEFINE P_DESC		10
#DEFINE P_VALDESC		11
#DEFINE P_TOTAL		12
#DEFINE P_ARMAZEM		13
#DEFINE P_CODCLI		14
#DEFINE P_LOJCLI		15
#DEFINE P_EMISSAO		16
#DEFINE P_OCORRE		17
#DEFINE P_DELETA		18
#DEFINE P_POSACOLS	19
#DEFINE P_OBRA		20
#DEFINE P_TOATEND		21
#DEFINE P_ORDER		22
#DEFINE P_SIZE		22

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA084   บAutor  ณCLEUTO LIMA         บ Data ณ  13/03/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ controle de pedidos nใo atendidos.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA084()

Local lRet			:= .T.
Local nAuxSld		:= 0
Local nSaldo		:= 0
Local aDados		:= {}
Local nPosAux		:= 0
Local lDel			:= .F.
Local nQtdAte		:= 0
Local cMsg			:= ""
Local nQtdaCol	:= Len(aCols)
Local lParcial	:= .F.
Local lGrava		:= .F.
Local lSldOk		:= .F.
Local nOrdAux		:= 0
Local oDlgAux		:= nil
Local nValTotAux	:= 0
Local nValUnit	:= 0
Local cIdZZB		:= M->C5_XNUMESP
Local cTiposVld	:= GetMv("GEN_FAT240",.F.,"1#")
Local cTesVld		:= GetMv("GEN_FAT241",.F.,"504#505#505#507")
Local lImpEspe	:= .F.
Local lExistDel	:= .F.

ProcRegua(nQtdaCol+1)

For nAuxSld := 1 To nQtdaCol
	
	IncProc("Consultando item "+ StrZero(nAuxSld,4)+" de "+StrZero(nQtdaCol,4) )

	If GdDeleted( nAuxSld , aHeader , aCols ) .OR. Empty(aCols[nAuxSld][GdFieldPos("C6_PRODUTO")])
		Loop
	EndIf
		
	If !(AllTrim(Posicione("SB1",1,xFilial("SB1")+aCols[nAuxSld][GdFieldPos("C6_PRODUTO")],"B1_XIDTPPU"))+"#" $ cTiposVld) .OR. !( aCols[nAuxSld][GdFieldPos("C6_TES")]+"#" $ cTesVld)
		Loop 
	EndIf
	
	Aadd( aDados, Array(P_SIZE) )
	nPosAux	:= Len(aDados)

	aDados[nPosAux][P_FILIAL]	:= xFilial("SC5")
	aDados[nPosAux][P_PEDIDO]	:= M->C5_NUM
	aDados[nPosAux][P_ITEM]		:= aCols[nAuxSld][GdFieldPos("C6_ITEM")]
	aDados[nPosAux][P_OBRA]		:= aCols[nAuxSld][GdFieldPos("C6_PRODUTO")]
	aDados[nPosAux][P_DESCRI]	:= aCols[nAuxSld][GdFieldPos("C6_DESCRI")]
	aDados[nPosAux][P_TES]		:= aCols[nAuxSld][GdFieldPos("C6_TES")]
	aDados[nPosAux][P_QTDSOL]	:= aCols[nAuxSld][GdFieldPos("C6_QTDVEN")]
	aDados[nPosAux][P_PRCUNIT]	:= aCols[nAuxSld][GdFieldPos("C6_PRUNIT")]
	aDados[nPosAux][P_PRCVEN]	:= aCols[nAuxSld][GdFieldPos("C6_PRCVEN")]
	aDados[nPosAux][P_DESC]		:= aCols[nAuxSld][GdFieldPos("C6_DESCONT")]
	aDados[nPosAux][P_VALDESC]	:= aCols[nAuxSld][GdFieldPos("C6_VALDESC")]
	aDados[nPosAux][P_TOTAL]		:= aCols[nAuxSld][GdFieldPos("C6_VALOR")]
	aDados[nPosAux][P_ARMAZEM]	:= aCols[nAuxSld][GdFieldPos("C6_LOCAL")]
	aDados[nPosAux][P_CODCLI]	:= M->C5_CLIENTE
	aDados[nPosAux][P_LOJCLI]	:= M->C5_LOJACLI
	aDados[nPosAux][P_EMISSAO]	:= M->C5_EMISSAO
		
	nSaldo := CalcEst(aCols[nAuxSld][GdFieldPos("C6_PRODUTO")],aCols[nAuxSld][GdFieldPos("C6_LOCAL")], dDataBase+1)[1]
	
	Do Case
		Case nSaldo >=	aCols[nAuxSld][GdFieldPos("C6_QTDVEN")]
			lImpEspe	:= .T.
			nOrdAux	:= 2
			lSldOk		:= .T.
			lGrava		:= .T.
			lDel		:= .F.
			nQtdAte	:= aCols[nAuxSld][GdFieldPos("C6_QTDVEN")]
			cMsg		:= ""
			lImpEspe	:= .T.			
		Case nSaldo > 0
			lImpEspe	:= .T.
			nOrdAux	:= 1
			lGrava		:= .T.
			lParcial	:= .T.
			lDel		:= .F.
			nQtdAte	:= nSaldo
			cMsg		:= "Obra serแ atendida parcialmente!"
		Case nSaldo == 0
			nOrdAux	:= 0
			lDel		:= .T.
			lExistDel	:= .T.
			nQtdAte	:= 0
			cMsg		:= "Obra nใo tem saldo em estoque para atenter esta solicita็ใo!"
	EndCase

	aDados[nPosAux][P_OCORRE]	:= cMsg
	aDados[nPosAux][P_POSACOLS]	:= nAuxSld
	aDados[nPosAux][P_DELETA]	:= lDel
	aDados[nPosAux][P_QTDATE]	:= nQtdAte	
	aDados[nPosAux][P_ORDER]		:= nOrdAux
	
	aDados[nPosAux][P_TOATEND]	:=  A410Arred( ( aCols[nAuxSld][GdFieldPos("C6_VALOR")]/aCols[nAuxSld][GdFieldPos("C6_QTDVEN")] ) * nQtdAte , "C6_VALOR" ) 
	
Next nAuxSld

If Len(aDados) > 0
	IncProc("Ordenando registros!")
	aDados := aSort(aDados,,,{|x,y| x[P_ORDER] < y[P_ORDER] })
	
	IncProc("Analise finalizada!")
	If !lGrava
		lRet := .F.
	EndIf
	If !(lSldOk .AND. lGrava .AND. !lParcial .AND. !lExistDel)
		If !ProcVld(aDados,lGrava,@lParcial,lSldOk)
			lRet := .F.
		EndIf
	EndIf	
EndIf	

ProcRegua(nQtdaCol+1)
IncProc("Aguarde... Armazenando espelho do pedido!")

DbSelectarea("ZZB")
ZZB->(DbsetOrder(2))
 
If Select("TMP_ZZB") > 0
	TMP_ZZB->(DbCloseArea())
EndIf
BeginSql Alias "TMP_ZZB"
	SELETC ZZB_MSIDEN FROM %Table:ZZB% ZZB
	WHERE ZZB_FILIAL = %xFilial:ZZB%
	/*AND ZZB_NUM = %Exp:M->C5_NUM%*/
	AND ZZB_MSIDEN = %Exp:cIdZZB%
	AND ZZB.%NotDel%
	GROUP BY ZZB_MSIDEN
EndSql

TMP_ZZB->(DbGoTop())
cIdZZB	:= TMP_ZZB->ZZB_MSIDEN
TMP_ZZB->(DbCloseArea())

If Empty(cIdZZB) .OR. Empty(M->C5_XNUMESP)
	cIdZZB	:= GETSXENUM("ZZB","ZZB_MSIDEN")
	ConfirmSX8()
	M->C5_XNUMESP	:= cIdZZB
EndIf

nQtdaCol	:= Len(aDados)
DbSelectarea("ZZB")
ZZB->(DbsetOrder(2))
	
For nAuxSld := 1 To nQtdaCol
	lAchouZZB := ZZB->(DbSeek( xFilial("ZZB")+PadR(aDados[nAuxSld][P_OBRA],TamSx3("B1_COD")[1])+cIdZZB ))	
	//If !lAchouZZB .OR. (lAchouZZB .AND. aDados[nAuxSld][P_QTDSOL] <> ZZB->ZZB_QTDVEN)
		Reclock("ZZB",!lAchouZZB)
			ZZB->ZZB_MSIDEN	:= cIdZZB
			ZZB->ZZB_FILIAL	:= xFilial("ZZB")
			ZZB->ZZB_NUM		:= IIF( lRet .OR. ( !Inclui .and. Altera ) , M->C5_NUM , Replicate("X",TamSX3("C5_NUM")[1]) )
			ZZB->ZZB_XUSRDI	:= M->C5_XUSRDIG
			ZZB->ZZB_CLIENT	:= M->C5_CLIENT
			ZZB->ZZB_LOJA		:= M->C5_LOJACLI
			ZZB->ZZB_EMISSA	:= M->C5_EMISSAO
			ZZB->ZZB_VEND1	:= M->C5_VEND1			
			ZZB->ZZB_PRODUT	:= aDados[nAuxSld][P_OBRA]		
			ZZB->ZZB_DESCRI	:= aDados[nAuxSld][P_DESCRI]		
			ZZB->ZZB_TES		:= aDados[nAuxSld][P_TES]			
			ZZB->ZZB_ITEM		:= aDados[nAuxSld][P_ITEM]
			ZZB->ZZB_QTDVEN	:= IIF( aDados[nAuxSld][P_QTDSOL] >= ZZB->ZZB_QTDVEN , aDados[nAuxSld][P_QTDSOL] , ZZB->ZZB_QTDVEN )
			ZZB->ZZB_PRCVEN	:= aDados[nAuxSld][P_PRCVEN]			
			ZZB->ZZB_PRUNIT	:= aDados[nAuxSld][P_PRCUNIT]
			ZZB->ZZB_DESCON	:= aDados[nAuxSld][P_DESC]						
			ZZB->ZZB_QTDENT	:= IIF( lRet .AND. ( lParcial .OR. aCols[aDados[nAuxSld][P_POSACOLS]][GdFieldPos("C6_QTDVEN")] == aDados[nAuxSld][P_QTDATE] ) , aDados[nAuxSld][P_QTDATE] , 0 )
		MsUnLock()
	//EndIF
	
	If aDados[nAuxSld][P_DELETA]
	
		aCols[aDados[nAuxSld][P_POSACOLS]][GdPosDeleted( aHeader )]	:= .T.
		
	ElseIf !lParcial .AND. aCols[aDados[nAuxSld][P_POSACOLS]][GdFieldPos("C6_QTDVEN")] > aDados[nAuxSld][P_QTDATE]
	
		aCols[aDados[nAuxSld][P_POSACOLS]][GdPosDeleted( aHeader )]	:= .T.
		
	ElseIf lParcial .AND. aCols[aDados[nAuxSld][P_POSACOLS]][GdFieldPos("C6_QTDVEN")] > aDados[nAuxSld][P_QTDATE]
				
		If aCols[aDados[nAuxSld][P_POSACOLS]][GdFieldPos("C6_VALDESC")] > 0 .AND. aCols[aDados[nAuxSld][P_POSACOLS]][GdFieldPos("C6_PRUNIT")] > 0
		
			aCols[aDados[nAuxSld][P_POSACOLS]][GdFieldPos("C6_VALDESC")]	:= A410Arred( ( aCols[aDados[nAuxSld][P_POSACOLS]][GdFieldPos("C6_PRUNIT")]*aDados[nAuxSld][P_QTDATE] )-aDados[nAuxSld][P_TOATEND], "C6_VALOR" )
			
		ElseIf aCols[aDados[nAuxSld][P_POSACOLS]][GdFieldPos("C6_VALDESC")] > 0 .AND. aCols[aDados[nAuxSld][P_POSACOLS]][GdFieldPos("C6_PRUNIT")] == 0
			
			//Se o valor de tabela de pre็o for informado
			nValTotAux	:= aCols[aDados[nAuxSld][P_POSACOLS]][GdFieldPos("C6_VALDESC")]+aCols[aDados[nAuxSld][P_POSACOLS]][GdFieldPos("C6_VALOR")]
			nValUnit	:= nValTotAux/aDados[nAuxSld][P_QTDATE]
			 
			aCols[aDados[nAuxSld][P_POSACOLS]][GdFieldPos("C6_VALDESC")]	:= A410Arred( ( nValUnit*aDados[nAuxSld][P_QTDATE] )-aDados[nAuxSld][P_TOATEND], "C6_VALOR" )
			
		EndIf	

		aCols[aDados[nAuxSld][P_POSACOLS]][GdFieldPos("C6_QTDVEN")]		:= aDados[nAuxSld][P_QTDATE]
		aCols[aDados[nAuxSld][P_POSACOLS]][GdFieldPos("C6_VALOR")]		:= aDados[nAuxSld][P_TOATEND]
				
	EndIf
		
Next

If !lRet .AND. INCLUI .AND. !ALTERA

	aCols		:= {}		
	//Para remontar o aCols com os valores padr๕es
	aCols	:= aClone(GdRmkaCols(     aHeader           ,;     //Array com a Estrutura para criacao do aCols
	                              .F.          ,;     //Estado do Elemento de Delecao no aCols
	                              .T.          ,;     //Se existe o Elemento de Delecao
	                              .F.           ;     //Se deve carregar os inicializadores padroes
	                              ))
	                              
	aCols[1][GdFieldPos("C6_ITEM")]	:= StrZero(1,TamSX3("C6_ITEM")[1])
	
ElseIf !INCLUI .AND. ALTERA

	If Select("TMP_ZZB") > 0
		TMP_ZZB->(DbCloseArea())
	EndIf
	BeginSql Alias "TMP_ZZB"
		SELETC ZZB_PRODUT,ZZB.R_E_C_N_O_ RECZZB FROM %Table:ZZB% ZZB
		WHERE ZZB_FILIAL = %xFilial:ZZB%
		/*AND ZZB_NUM = %Exp:M->C5_NUM%*/
		AND ZZB_MSIDEN = %Exp:cIdZZB%
		AND ZZB.%NotDel%
	EndSql
	
	TMP_ZZB->(DbGoTop())
	nPosProd	:= GdFieldPos("C6_PRODUTO")
	nPosDel	:= GdPosDeleted( aHeader )
	
	While TMP_ZZB->(!EOF())
		
		If aScan(aCols, {|x| AllTrim(x[nPosProd]) == AllTrim(TMP_ZZB->ZZB_PRODUT) .AND. !x[nPosDel] } ) == 0
			ZZB->(DbGoTo(TMP_ZZB->RECZZB))
			RecLock("ZZB",.F.)
			ZZB->ZZB_MSIDEN	:= cIdZZB
			ZZB->ZZB_XUSRDI	:= M->C5_XUSRDIG
			ZZB->ZZB_QTDENT	:= 0			
			MsUnLock()
		EndIf
		
		TMP_ZZB->(DbSkip())
	EndDo
	TMP_ZZB->(DbCloseArea())
	
EndIf

//oDlgAux	:= GetWndDefault()
If Type('oGetDad:oBrowse')<>"U"
	oGetDad:oBrowse:Refresh()
Endif

IF ( lParcial .OR. lDel ) .AND. POSICIONE("SE4",1,xFilial("SE4")+M->C5_CONDPAG,"E4_TIPO") == "9"
	GENA084P()	
EndIf

//If lImpEspe .and. (Inclui .and. !Altera) /* DEVE IMPRIMRI AUTOMATICAMENTE O ESPELHO APENAS NA INCLUSรO DO PEDIDO *
//	U_GENR068(NIL,cIdZZB,xFilial("SC5"),M->C5_VEND1,M->C5_XPEDCLI,ALLTRIM(M->C5_CONDPAG),ALLTRIM(M->C5_TRANSP),M->C5_TPFRETE)
//EndIf	
	
Return lRet

Static Function ProcVld(aDados,lGrava,lParcial,lSldOk)

Local lRet			:= .T.
Local cCadastro	:= "Valida็ใo de Saldos"
Local lContinua	:= .T.
Local oDel			:= LoadBitmap( GetResources(), "BR_VERMELHO" )
Local oNoDel		:= LoadBitmap( GetResources(), "BR_AMARELO" )
Local oSldOk		:= LoadBitmap( GetResources(), "BR_VERDE" )
Local aButtons	:= {}
Local nSaldo		:= 0
Local nPosAux		:= 0
Local oPDown		:= nil
Local oPanel		:= nil
Local cFatParc	:= ""

DEFINE MSDIALOG oDlgT TITLE "Verifique os saldos a seguir" From 009,000 To 500,1000 OF oMainWnd Style DS_MODALFRAME Pixel

oDlgT:lMaximized	:= .F.

@00,00 MSPANEL oPDown PROMPT "" SIZE 250,45 COLOR CLR_WHITE,CLR_WHITE OF oDlgT 
oPDown:Align := CONTROL_ALIGN_BOTTOM
	
@00,00 MSPANEL oPanel PROMPT "" SIZE 250,45 COLOR CLR_WHITE,CLR_WHITE OF oDlgT 
oPanel:Align := CONTROL_ALIGN_ALLCLIENT
aHList:={}
oListBox := TWBrowse():New(05,05,(oPanel:NCLIENTWIDTH/2)-10,(oPanel:NCLIENTHEIGHT/2)-55,,aHList,,oPanel,,,,,,,,,,,,, "ARRAY", .T. )

oListBox:AddColumn(TCColumn():New(" "					,{|| IIF(aDados[oListBox:nAT][P_DELETA], oDel , IIF(aDados[oListBox:nAT][P_ORDER]==1 , oNoDel , oSldOk ) )		},,,,'CENTER'	,25,.T.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Item"		  		,{|| aDados[oListBox:nAT][P_ITEM]	},,,,'LEFT'		,20,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Obra"		  		,{|| aDados[oListBox:nAT][P_OBRA]	},,,,'LEFT'		,45,.F.,.F.,,,,.F.,))

oListBox:AddColumn(TCColumn():New("Qtd.Solicitada"	,{|| aDados[oListBox:nAT][P_QTDSOL]	},,,,'RIGHT'		,45,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Valor Solicitado"	,{|| aDados[oListBox:nAT][P_TOTAL]		},"@E 999,999,999.99",,,'RIGHT'		,45,.F.,.F.,,,,.F.,))

oListBox:AddColumn(TCColumn():New("Qtd.Atendida"		,{|| aDados[oListBox:nAT][P_QTDATE]	},,,,'RIGHT'		,45,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Valor Atendido"	,{|| aDados[oListBox:nAT][P_TOATEND]	},"@E 999,999,999.99",,,'RIGHT'		,45,.F.,.F.,,,,.F.,))

oListBox:AddColumn(TCColumn():New("Titulo"			,{|| aDados[oListBox:nAT][P_DESCRI]	},,,,'LEFT'		,35,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Ocorrencia"		,{|| aDados[oListBox:nAT][P_OCORRE]	},,,,'LEFT'		,200,.F.,.F.,,,,.F.,))

oListBox:SetArray( aDados )	
//oListBox:bLDblClick := {|| aDados[oListBox:nAT][9] := !aDados[oListBox:nAT][9] }
//AADD(aButtons, {"cargaseq",	{|| ExportGrid(aDados) }, "Registros Concilia็ใo"})

oFatParc 	:= TComboBox():New(05, 10,{|u|if(PCount()>0,cFatParc:=u,cFatParc)},{"1=Autorizo faturar obras com saldo parcial","2=Faturar apenas obras totalmente atendidas","3=Pedido nใo deve ser gerado"},200,20,oPDown,,{|| },,,,.T.,,,,,,,,,"cFatParc","Autoriza Faturamento Parcial do pedido? .:",1)

ACTIVATE MSDIALOG oDlgT ON INIT EnchoiceBar(oDlgT,{|| nOpca := 1,oDlgT:End()},{||  },,aButtons) CENTERED

If lGrava
	If lParcial
		lParcial := cFatParc == "1"
	EndIf
	If !lParcial .AND. !lSldOk
		lRet	:= .F.
		MsgStop("Nใo foi identificada nenhuma obra apta a ser faturada!"+chr(13)+chr(10)+"Pedido nใo serแ gravado!")
	ElseIf cFatParc == "3"
		lRet	:= .F.
		MsgStop("Inclusใo do pedido cancelada pelo usuแrio!")			
	EndIf
Else
	lRet	:= .F.
	MsgStop("Nใo foi identificada nenhuma obra apta a ser faturada!"+chr(13)+chr(10)+"Pedido nใo serแ gravado!")		
EndIf

Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA084P  บAutor  ณCletuo Lima         บ Data ณ  16/01/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ manuten็ใo dos valores da condi็ใo de pagamento tipo 99.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function GENA084P()

Local cParcela	:= "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0"
Local cMv1Dup		:= GetMV( "MV_1DUP" )
Local dParc		:= Ctod("")
Local nParcelas	:= SuperGetMv("MV_NUMPARC")
Local aAcho		:= {}
Local nX			:= 0
Local aPosEnch	:= {0,0,0,0}
Local aCpos		:= {}
Local oEnc01		:= nil
Local oDlg99		:= nil
Local nOp99		:= 0
Local aBut99		:= {}
Local aGets		:= {}
Local nLiGet		:= 10
Local oFont		:= Nil
Local lRet			:= .T.
Local nTotPed		:= 0
Local nLenAcols	:= Len(aCols)

For nX := 1 to nLenAcols
	If GdDeleted( nX , aHeader , aCols )
		Loop
	EndIf
	nTotPed+= aCols[nX][GdFieldPos("C6_VALOR",aHeader)]
Next nX

For nX := 1 to nParcelas
	If SC5->(FieldPos("C5_PARC"+Substr(cParcela,nX,1))) > 0
		Aadd(aAcho, "C5_PARC"+Substr(cParcela,nX,1) )
		Aadd(aAcho, "C5_DATA"+Substr(cParcela,nX,1) )
	EndIf
Next nX

aCpos	:= aClone(aAcho)

DEFINE MSDIALOG oDlg99 TITLE "Manuten็ใo Cond.Pag.99" From 009,000 To 600,450 OF oMainWnd Style DS_MODALFRAME Pixel

oPanTot		:= tPanel():New(01,01,,oDlg99,,,,,,15,050)
oPanTot:Align	:= CONTROL_ALIGN_BOTTOM
oGetTot := TGet():New(10,05,{|u| if( Pcount()>0, nTotPed := u, nTotPed ) },oPanTot,50,010,"@E 999,999,999.99",{|| .F. },0,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"nTotPed",,,,,,,"Total Pedido.: ",2,oFont)

oPanCl1		:= tPanel():New(01,01,,oDlg99,,,,,,100,15)
oPanCl1:Align	:= CONTROL_ALIGN_LEFT

oPanCl2		:= tPanel():New(01,01,,oDlg99,,,,,,100,15)
oPanCl2:Align	:= CONTROL_ALIGN_RIGHT

For nX := 1 to Len(aAcho)
	If Mod(nX,2) <> 0
		cScript	:= '{|| TGet():New('+cValToChar(nLiGet)+',05,{|u| if( Pcount()>0, M->'+aAcho[nX]+' := u, M->'+aAcho[nX]+' ) },oPanCl1,50,010,"'+PesqPict("SC5",aAcho[nX])+'",{|| .T. },0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"M->'+aAcho[nX]+'",,,,,,,"'+TitSX3(aAcho[nX])[1]+'.: ",2,oFont )}'
	Else	
		cScript	:= '{|| TGet():New('+cValToChar(nLiGet)+',05,{|u| if( Pcount()>0, M->'+aAcho[nX]+' := u, M->'+aAcho[nX]+' ) },oPanCl2,50,010,"'+PesqPict("SC5",aAcho[nX])+'",{|| .T. },0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"M->'+aAcho[nX]+'",,,,,,,"'+TitSX3(aAcho[nX])[1]+'.: ",2,oFont )}'
		nLiGet+=15
	EndIf
	&("oGetAux"+cValtochar(nX))	:= eVal(&(cScript))
Next nX

ACTIVATE MSDIALOG oDlg99 ON INIT EnchoiceBar(oDlg99,{|| IIF( Vld099(@nOp99) , oDlg99:End() , nil ) },{||  },,aBut99) CENTERED

Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVld099    บAutor  ณCletuo Lima         บ Data ณ  16/01/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ valida็ใo dos dados de condi็ใo de pagamento               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Vld099(nOp99)

Local lRet	:= .T.

lRet := U_M410TIP9()

If lRet
	nOp99 := 1
EndIf

Return lRet