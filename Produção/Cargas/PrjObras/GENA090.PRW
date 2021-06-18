#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA090   ºAutor  ³Cleuto Lima         º Data ³  18/07/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Copia de produtos sistema gestão de produtos                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA090(cProduto,nTipoFunc)

Local aArea		:= GetArea()
Local aAreaZZL	:= ZZL->(GetArea())
Local lRet		:= .F.
Local aGrp		:= UsrRetGrp( nil , RetCodUsr() )
Local cGrpUsr	:= ""
Local cTpSit	:= ""
Local cTpObr	:= ""
Local oDlgCop	:= nil
Local oFont		:= nil
Local nMbrWidth	:= 0
Local nMbrHeight:= 0
Local oPntCp	:= nil
Local bConfirm	:= {|| lRet := .T.,oDlgCop:End() }
Local bCancel	:= {|| lRet := .F.,oDlgCop:End() }
Local aButtons	:= {}
Local aHList	:= {}
Local oListBox	:= nil
Local oGrpTp	:= nil
Local aDados	:= {}
Local aDFlds	:= {}
Local nAux		:= 0
Local oGrpFld 	:= nil
Local oListFld	:= nil
Local oPntProd	:= nil
Local oGrpProd 	:= nil
Local oListProd	:= nil
Local aProdAfe	:= {}

Private oOk	  	:= LoadBitMap(GetResources(),"LBOK")
Private oNOk	:= LoadBitMap(GetResources(),"LBNO")

ZZL->(DbSetOrder(1))
ZZL->( DbSeek( xFilial("ZZL")+cProduto ) )

cTpSit	:= ZZL->ZZL_SITOBR
cTpObr	:= ZZL->ZZL_IDTPPU
	
aEval(aGrp,{|x| cGrpUsr+="'"+x+"'," }) 
cGrpUsr := "%("+Left(cGrpUsr, Len(cGrpUsr)-1)+")%"

If Select("TMP_FIELD") > 0
	TMP_FIELD->(DbCloseArea())
EndIf

BeginSql Alias "TMP_FIELD"
	SELECT ZZQ_SITOBR, TRIM(Z4_DESC) Z4_DESC, ZZQ_COPPUB, TRIM(ZZT_DESC) ZZT_DESC 
	FROM %Table:ZZP% ZZP
	JOIN %Table:ZZQ% ZZQ
	ON ZZQ.ZZQ_FILIAL = ZZP.ZZP_FILIAL
	AND ZZQ.ZZQ_NUM = ZZP.ZZP_NUM
	AND ZZQ.ZZQ_TPPUB = ZZP.ZZP_IDTPPU
	AND ZZQ.%NotDel%
	JOIN %Table:ZZT% ZZT
	ON ZZT_FILIAL = %xFilial:ZZT%
	AND ZZT_COD = ZZQ_COPPUB
	JOIN %Table:SZ4% SZ4
	ON Z4_FILIAL = %xFilial:SZ4%
	AND Z4_COD = ZZQ_SITOBR
	AND SZ4.%NotDel%
	WHERE ZZP_FILIAL = %xFilial:ZZP%
	AND ZZP.%NotDel%
	AND ZZP_NUM = '01'
	AND ZZP_IDTPPU = %Exp:cTpObr%
	AND ZZQ_COPPUB <> ' '
	AND EXISTS(
	  SELECT 1 FROM %Table:ZZR% ZZR
	  WHERE ZZR_FILIAL = ' '
	  AND ZZR_NUM = ZZQ_NUM
	  AND ZZR_TPPUB = ZZQ_TPPUB
	  AND ZZR_SITOBR = ZZQ_SITOBR
	  AND ZZR_GRPUSR IN %Exp:cGrpUsr%
	  AND ZZR.%NotDel%
	)
EndSql

TMP_FIELD->(DbGoTop())
While TMP_FIELD->(!EOF())
	
	Aadd(aDados, {.F.,;
		TMP_FIELD->Z4_DESC,;
		TMP_FIELD->ZZQ_COPPUB,;
		TMP_FIELD->ZZT_DESC,;
		TMP_FIELD->ZZQ_SITOBR;		
	})
	
	TMP_FIELD->(DbSkip())
EndDo
TMP_FIELD->(DbCloseArea())

If Len(aDados) == 0 .and. nTipoFunc == 1
	MsgStop("Não foi localizado acesso a copia de produtos para o seu usuário!")
	Return .F.
EndIf

IF nTipoFunc == 2

	Aadd(aDFlds, {.F.,;
		"Categorias",;
		"Categorias informadas no produto",;
		"ZZN",;
		"A",;
		"S",;
		0,;
		1,;
		"Categorias",;
		"C",;
		1,;
		"",;
		"";		
	})

	Aadd(aDFlds, {.F.,;
		"Imagens",;
		"Imagens no produto",;
		"ZZU",;
		"A",;
		"S",;
		0,;
		1,;
		"Imagens",;
		"C",;
		1,;
		"",;
		"";		
	})

	If Select("TMP_FIELD") > 0
		TMP_FIELD->(DbCloseArea())
	EndIf
	
	BeginSql Alias "TMP_FIELD"
		SELECT ZZS_CAMPO,X3_TITULO, ZZS_ACESSO, ZZS_OBRIGA,X3_TAMANHO,ZZS_FOLDER,ZZC_DESC,X3_TIPO,ZZS_ORDEM,ZZR_IMAGEM,ZZS_PULA 
		FROM %Table:ZZP% ZZP
		JOIN %Table:ZZQ% ZZQ
		ON ZZQ.ZZQ_FILIAL = ZZP.ZZP_FILIAL
		AND ZZQ.ZZQ_NUM = ZZP.ZZP_NUM
		AND ZZQ.ZZQ_TPPUB = ZZP.ZZP_IDTPPU
		AND ZZQ.D_E_L_E_T_ <> '*'
		JOIN %Table:ZZR% ZZR
		ON ZZR.ZZR_FILIAL = ZZQ.ZZQ_FILIAL
		AND ZZR.ZZR_NUM = ZZQ.ZZQ_NUM
		AND ZZR.ZZR_TPPUB = ZZQ.ZZQ_TPPUB
		AND ZZR.ZZR_SITOBR = ZZQ.ZZQ_SITOBR
		AND ZZR.D_E_L_E_T_ <> '*'
		JOIN %Table:ZZS% ZZS
		ON ZZS.ZZS_FILIAL = ZZR.ZZR_FILIAL
		AND ZZS.ZZS_NUM = ZZR.ZZR_NUM
		AND ZZS.ZZS_TPPUB = ZZR.ZZR_TPPUB
		AND ZZS.ZZS_SITOBR = ZZR.ZZR_SITOBR
		AND ZZS.ZZS_GRPUSR = ZZR.ZZR_GRPUSR
		AND ZZS.D_E_L_E_T_ <> '*'
		JOIN %Table:SX3% SX3
		ON X3_ARQUIVO IN ('ZZL','ZZL')
		AND X3_CAMPO = ZZS_CAMPO
		AND SX3.%NotDel%
		LEFT JOIN %Table:ZZC% ZZC
		ON ZZC_FILIAL = ' '
		AND ZZC_TABELA = 'Z5'
		AND trim(ZZC_CHAVE) = ZZS_FOLDER
		AND ZZC.%NotDel%
		WHERE ZZP_FILIAL = %xFilial:ZZP%
		AND ZZP_NUM = '01'
		AND ZZR_SITOBR = '400'
		AND ZZP_IDTPPU = %Exp:cTpObr%
		AND ZZR_GRPUSR IN %Exp:cGrpUsr%
		AND ZZP.D_E_L_E_T_ <> '*'
		ORDER BY ZZS_FOLDER,ZZS_CAMPO
	EndSql
	
	TMP_FIELD->(DbGoTop())
	While TMP_FIELD->(!EOF())
		
		Aadd(aDFlds, {.F.,;
			TMP_FIELD->X3_TITULO,;
			ZZL->&(TMP_FIELD->ZZS_CAMPO),;
			TMP_FIELD->ZZS_CAMPO,;
			TMP_FIELD->ZZS_ACESSO,;
			TMP_FIELD->ZZS_OBRIGA,;
			TMP_FIELD->X3_TAMANHO,;
			TMP_FIELD->ZZS_FOLDER,;
			TMP_FIELD->ZZC_DESC,;
			TMP_FIELD->X3_TIPO,;
			TMP_FIELD->ZZS_ORDEM,;
			TMP_FIELD->ZZR_IMAGEM,;
			TMP_FIELD->ZZS_PULA;		
		})

		TMP_FIELD->(DbSkip())
	EndDo
	TMP_FIELD->(DbCloseArea())
EndIf

IF nTipoFunc == 1
	Define Dialog oDlgCop Title "Copiar produto "+ZZL->ZZL_COD+": "+AllTrim(ZZL->ZZL_DESC) From 00,00 TO 300,750 PIXEL
Else
	Define Dialog oDlgCop Title "Replicar campos do produto "+ZZL->ZZL_COD+": "+AllTrim(ZZL->ZZL_DESC) From 00,00 TO 600,1200 PIXEL
EndIf	

//oDlgCre:lMaximized := .T.
oDlgCop:SetColor(CLR_BLACK,CLR_WHITE)
oDlgCop:SetFont(oFont)

@00,00 MSPANEL oPntGer PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgCop
oPntGer:Align := CONTROL_ALIGN_ALLCLIENT
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Armazena as corrdenadas da tela                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMbrWidth	:= oDlgCop:nWidth/2-43
nMbrHeight	:= oDlgCop:nHeight/2

If nTipoFunc == 2
	@00,00 MSPANEL oPntProd PROMPT "" SIZE nMbrWidth/2.5,nMbrHeight/2.5 of oDlgCop
	oPntProd:Align := CONTROL_ALIGN_RIGHT

	oGrpProd 	:= TGroup():New(05,05,(oPntProd:NCLIENTHEIGHT/2)-54,(oPntProd:NCLIENTWIDTH/2)-10,"Produtos afetados...",oPntProd,CLR_RED,,.T.)
	oListProd	:= TWBrowse():New(15,10,(oPntProd:NCLIENTWIDTH/2)-25,(oPntProd:NCLIENTHEIGHT/2)-70,,aHList,,oPntProd,,,,,,,,,,,,, "ARRAY", .T. )
		
	oListProd:AddColumn(TCColumn():New( "ID. Prod SKU"	,{|| aProdAfe[oListProd:nAT][2]		},,,,'LEFT'		,050,.F.,.F.,,,,.F.,))	
	oListProd:AddColumn(TCColumn():New( "Titulo"		,{|| aProdAfe[oListProd:nAT][3]		},,,,'LEFT'		,150,.F.,.F.,,,,.F.,))
	oListProd:AddColumn(TCColumn():New( "Tp.Prod."		,{|| aProdAfe[oListProd:nAT][1]		},,,,'LEFT'		,030,.F.,.F.,,,,.F.,))
	oListProd:AddColumn(TCColumn():New( "Tipo Produto"	,{|| aProdAfe[oListProd:nAT][4]		},,,,'LEFT'		,080,.F.,.F.,,,,.F.,))

	@00,00 MSPANEL oPntField PROMPT "" SIZE nMbrWidth/2,nMbrHeight/2 of oPntGer
	oPntField:Align := CONTROL_ALIGN_BOTTOM
		
	oGrpFld 	:= TGroup():New(05,05,(oPntField:NCLIENTHEIGHT/2)-10,(oPntField:NCLIENTWIDTH/2)-10,"Seleção de campos...",oPntField,CLR_RED,,.T.)
	oListFld	:= TWBrowse():New(15,10,(oPntField:NCLIENTWIDTH/2)-25,(oPntField:NCLIENTHEIGHT/2)-30,,aHList,,oPntField,,,,,,,,,,,,, "ARRAY", .T. )

	oListFld:AddColumn(TCColumn():New( " "					,{|| IIF( aDFlds[oListFld:nAT][1] == .T. , oOk , oNOk )		},,,,'CENTER'	,10,.t.,.F.,,,,.F.,))	
	oListFld:AddColumn(TCColumn():New( "Replicar campos"	,{|| aDFlds[oListFld:nAT][2]		},,,,'LEFT'		,060,.F.,.F.,,,,.F.,))
	oListFld:AddColumn(TCColumn():New( "Replicar conteudo"	,{|| aDFlds[oListFld:nAT][3]		},,,,'LEFT'		,150,.F.,.F.,,,,.F.,))	
	oListFld:SetArray( aDFlds )
	
	oListFld:bLDblClick	:= {|x| aDFlds[oListFld:nAT][1] := !aDFlds[oListFld:nAT][1] }		
EndIf
			
@00,00 MSPANEL oPntCp PROMPT "" SIZE nMbrWidth,nMbrHeight of oPntGer
oPntCp:Align := CONTROL_ALIGN_ALLCLIENT

oGrpTp 		:= TGroup():New(05,05,(oPntCp:NCLIENTHEIGHT/2)-50,(oPntCp:NCLIENTWIDTH/2)-10,"Seleção de Tipos de Produtos para copia...",oPntCp,CLR_RED,,.T.)
oListBox	:= TWBrowse():New(15,10,(oPntCp:NCLIENTWIDTH/2)-25,(oPntCp:NCLIENTHEIGHT/2)-70,,aHList,,oPntCp,,,,,,,,,,,,, "ARRAY", .T. )

oListBox:AddColumn(TCColumn():New( " "			,{|| IIF( aDados[oListBox:nAT][1] == .T. , oOk , oNOk )		},,,,'CENTER'	,10,.t.,.F.,,,,.F.,))

oListBox:AddColumn(TCColumn():New( "Processo"	,{|| aDados[oListBox:nAT][2]		},,,,'LEFT'		,135,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New( "Tipo Prod."	,{|| aDados[oListBox:nAT][3]		},,,,'LEFT'		,40,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New( "Descrição"	,{|| aDados[oListBox:nAT][4]		},,,,'LEFT'		,50,.F.,.F.,,,,.F.,))

oListBox:SetArray( aDados )

If nTipoFunc == 1
	oListBox:bLDblClick	:= {|x| aDados[oListBox:nAT][1] := !aDados[oListBox:nAT][1] }
Else
	oListBox:bLDblClick	:= {|x| aDados[oListBox:nAT][1] := !aDados[oListBox:nAT][1] , CargaObras(aDados,oListBox,@oListProd,@aProdAfe) }
EndIf	
									
Activate MsDialog oDlgCop On Init EnchoiceBar(oDlgCop,bConfirm,bCancel,,aButtons) Centered

If lRet
	
	For nAux := 1 To Len(aDados)
		If aDados[nAux][1] == .F.
			Loop
		EndIf
		
		ZZL->(DbSetOrder(1))
		ZZL->( DbSeek( xFilial("ZZL")+cProduto ) )		
		
		If nTipoFunc == 1
			LJMsgRun("Processando copia...","Aguarde...",{|| U_GENMNZZL("Copia",9,aDados[nAux][5],aDados[nAux][2],aDados[nAux][3],cProduto) })
		Else
			LJMsgRun("Replicando dados...","Aguarde...",{|| xRepliProd(aDFlds,aProdAfe) })
		EndIf	
		
	Next nAux
	
EndIf

RestArea(aArea)
RestArea(aAreaZZL)

Return nil

Static Function xRepliProd(aDFlds,aProdAfe)

Local aAreaZZL	:= ZZL->(GetArea())
Local aArea		:= GetArea()
Local cCodCopy	:= ZZL->ZZL_COD
Local nAuxPrd	:= 0
Local nAuxFld	:= 0
Local lRepZZN	:= .F.
Local lRepZZU	:= .F.
Local cMemo 	:= ""
Local cB64zip	:= ""
Local cB64		:= ""
Local cOriZZN	:= PadR("GENCAZZL",TamSX3("ZZN_ORIGEM")[1])

If Select("TMP_COPY") > 0
	TMP_COPY->(DbCloseArea())
EndIf

BeginSql Alias "TMP_COPY"
	SELECT ZZN_PRODUT, ZZN_CODSIT, ZZN_CODCAT, ZZN_DESC,ZZN_ORIGEM
	FROM %Table:ZZN% ZZN
	WHERE ZZN_FILIAL = %xFilial:ZZN%
	AND ZZN.ZZN_PRODUT = %Exp:cCodCopy%
	and ZZN.ZZN_ORIGEM = %Exp:cOriZZN%
	AND ZZN.%NotDel%
EndSql

If Select("IMG_COPY") > 0
	IMG_COPY->(DbCloseArea())
EndIf

BeginSql Alias "IMG_COPY"
	SELECT ZZU.R_E_C_N_O_ RECZZU, ZZU_PRODUT, ZZU_CODIMG, ZZU_TITULO, ZZU_FILE, ZZU_TIPO, ZZU_SIZE, ZZU_MEMO, ZZU_B64ZIP, ZZU_B64, ZZU_DTINC, ZZU_PRINCI, ZZU_ALTIMG, ZZU_DTALT, ZZU_HRALT, ZZU_HRINCL
	FROM %Table:ZZU% ZZU
	WHERE ZZU_FILIAL = %xFilial:ZZU%
	AND ZZU.ZZU_PRODUT = %Exp:cCodCopy%
	AND ZZU.%NotDel%
EndSql

Begin Transaction
	For nAuxPrd := 1 To Len(aProdAfe)
		lRepZZN	:= .F.
		lRepZZU	:= .F.
		ZZL->(DbGoTo( aProdAfe[nAuxPrd][5] ))
		RecLock("ZZL",.F.)
		
		ZZL->ZZL_DTALTE	:= DDataBase
		ZZL->ZZL_HALTER	:= Time()
		ZZL->ZZL_USRALT	:= AllTrim(UsrRetName(RetCodUsr()))

		For nAuxFld := 1 To Len(aDFlds) 
			If aDFlds[nAuxFld][1] .AND. aDFlds[nAuxFld][4] == "ZZN"
			 	//If aDFlds[nAuxFld][4] == "ZZN"
			 		lRepZZN	:= .T.
			 	//EndIf
				Loop
			EndIf
			If aDFlds[nAuxFld][1] .AND. aDFlds[nAuxFld][4] == "ZZU"
				//If aDFlds[nAuxFld][4] == "ZZU"
					lRepZZU	:= .T.
				//EndIf
			   Loop
		   EndIf
		   If aDFlds[nAuxFld][1]
	       		ZZL->&(AllTrim(aDFlds[nAuxFld][4])) := aDFlds[nAuxFld][3]  
		   EndIF	   
		Next nAuxFld
		MsUnLock()

		If lRepZZN			
			ZZN->(DbSetOrder(1))//ZZN_FILIAL+ZZN_ORIGEM+ZZN_PRODUT+ZZN_CODSIT+ZZN_CODCAT
			ZZN->(DbSeek( xFilial("ZZN")+cOriZZN+ZZL->ZZL_COD ))
			While ZZN->(!EOF()) .AND. ZZN->ZZN_PRODUT == ZZL->ZZL_COD .AND. ZZN->ZZN_ORIGEM == cOriZZN
			 	Reclock("ZZN",.F.)
			 	ZZN->(DbDelete())
			 	MsUnLock()
			 	
			 	ZZN->(DbSkip())
			EndDo
			
			TMP_COPY->(DbGotop())
			While TMP_COPY->(!EOF())				
				RecLock("ZZN",.T.)
				ZZN->ZZN_FILIAL	:= xFilial("ZZN")
				ZZN->ZZN_PRODUT	:= ZZL->ZZL_COD
				ZZN->ZZN_CODSIT	:= TMP_COPY->ZZN_CODSIT
				ZZN->ZZN_CODCAT	:= TMP_COPY->ZZN_CODCAT
				ZZN->ZZN_DESC	:= TMP_COPY->ZZN_DESC
				ZZN->ZZN_ORIGEM	:= TMP_COPY->ZZN_ORIGEM
				MsUnLock()
				TMP_COPY->(DbSkip())
			EndDo		
		EndIf

		If lRepZZU
			ZZU->(DbSetOrder(1))
			ZZU->(DbSeek( xFilial("ZZU")+ZZL->ZZL_COD ))
			While ZZU->(!EOF()) .AND. ZZU->ZZU_PRODUT == ZZL->ZZL_COD
			 	Reclock("ZZU",.F.)
			 	ZZU->(DbDelete())
			 	MsUnLock()
			 	
			 	ZZU->(DbSkip())
			EndDo
			
			IMG_COPY->(DbGotop())
			While IMG_COPY->(!EOF())				

				ZZU->(DbGoTo( IMG_COPY->RECZZU ))
				
				cMemo 	:= ZZU->ZZU_MEMO
				cB64zip	:= ZZU->ZZU_B64ZIP
				cB64	:= ZZU->ZZU_B64

				RecLock("ZZU",.T.)
				ZZU->ZZU_FILIAL	:= xFilial("ZZN")
				ZZU->ZZU_PRODUT	:= ZZL->ZZL_COD
				ZZU->ZZU_CODIMG	:= IMG_COPY->ZZU_CODIMG
				ZZU->ZZU_TITULO	:= IMG_COPY->ZZU_TITULO
				ZZU->ZZU_FILE	:= IMG_COPY->ZZU_FILE
				ZZU->ZZU_TIPO	:= IMG_COPY->ZZU_TIPO
				ZZU->ZZU_DTINC	:= StoD(IMG_COPY->ZZU_DTINC)
				ZZU->ZZU_PRINCI	:= IMG_COPY->ZZU_PRINCI
				ZZU->ZZU_ALTIMG	:= IMG_COPY->ZZU_ALTIMG
				ZZU->ZZU_DTALT	:= StoD(IMG_COPY->ZZU_DTALT)
				ZZU->ZZU_HRALT	:= IMG_COPY->ZZU_HRALT
				ZZU->ZZU_HRINCL	:= IMG_COPY->ZZU_HRINCL
				ZZU->ZZU_SIZE	:= IMG_COPY->ZZU_SIZE

				ZZU->ZZU_MEMO	:= cMemo
				ZZU->ZZU_B64ZIP	:= cB64zip
				ZZU->ZZU_B64	:= cB64

				MsUnLock()
				IMG_COPY->(DbSkip())
			EndDo		
		EndIf

	Next nAuxPrd

	If Select("TMP_COPY") > 0
		TMP_COPY->(DbCloseArea())
	EndIf
				
End Transaction

RestArea(aAreaZZL)
RestArea(aArea)

Return nil

Static Function CargaObras(aDados,oListBox,oListProd,aProdAfe)

Local cTipos	:= ""
aProdAfe		:= {}

aEval(aDados, {|x| cTipos += IIF( x[1] , "'"+AllTrim(x[3])+"'," , "" ) } )

If !Empty(cTipos)

	cTipos	:= "%("+Left(cTipos,Len(cTipos)-1)+")%"
	
	If Select("TMP_LISTA")
		TMP_LISTA->(DbCloseArea())
	EndIf
	
	BeginSql Alias "TMP_LISTA"
		SELECT ZZL_COD, TRIM(ZZL_DESC) ZZL_DESC, ZZL_IDTPPU,TRIM(ZZT_DESC) ZZT_DESC,ZZL.R_E_C_N_O_ RECZZL 
		FROM %Table:ZZL% ZZL
		JOIN %Table:ZZT% ZZT
		ON ZZT_FILIAL = %xFilial:ZZT%
		AND ZZT_COD = ZZL_IDTPPU
		AND ZZT.%NotDel%
		WHERE ZZL_FILIAL = %xFilial:ZZL%
		AND ZZL.%NotDel%
		AND ZZL.ZZL_IDMAE = %Exp:ZZL->ZZL_IDMAE%
		AND ZZL.ZZL_IDTPPU IN %Exp:cTipos%
	EndSql
	
	TMP_LISTA->(DbGoTop())
	While TMP_LISTA->(!EOF())
		
		Aadd(aProdAfe,{;
			TMP_LISTA->ZZL_IDTPPU,;	
			TMP_LISTA->ZZL_COD,; 
			TMP_LISTA->ZZL_DESC,; 
			TMP_LISTA->ZZT_DESC,;
			TMP_LISTA->RECZZL; 
		})
		
		TMP_LISTA->(DbSkip())
	EndDo

EndIf

oListProd:nAT	:= 1
oListProd:SetArray( aProdAfe )
oListProd:DrawSelect()
oListProd:Refresh()
oListProd:GoTop()
	
Return nil