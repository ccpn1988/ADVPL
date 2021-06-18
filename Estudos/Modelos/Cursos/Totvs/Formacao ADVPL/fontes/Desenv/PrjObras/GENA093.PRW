#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "Totvs.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "dbtree.ch"

#Define ENTER Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA093   ºAutor  ³Cleuto Lima         º Data ³  09/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gestão de reimpressão                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Projeto Gestão de Obras                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENA093(cParRec,cParOpc)

Local aArea         := GetArea()
Local lRet			:= .F.
Local aDados		:= {}
Local aPosObj    	:= {} 
Local aObjects   	:= {}                        
Local aSize      	:= MsAdvSize() 
Local aInfo			:= {}
Local aColsZZW		:= {}

Local bConfirm		:= {|| lRet := .T.,oDlgCre:End() }
Local bCancel		:= {|| lRet := .F.,oDlgCre:End() }
Local aButtons		:= {}

Local oDlgCre		:= Nil
Local nWidth 		:= 50
Local oFont			:= Nil
Local oTFont 		:= TFont():New('Courier new',,-18,.T.)
Local cCadastro		:= "Reimpressão"

Local nMbrWidth		:= 0
Local nMbrHeight	:= 0

Local aAlter		:= {"ZZW_DTREIM","ZZW_DTPREV","ZZW_SITUAC","ZZW_TIRPRE"}

Local aHeadAux		:= {}
Local aLinMod		:= {}
Local nFreeze		:= 0
Local nUsado		:= 0
Local aVirtual		:= {}
Local aVisual		:= {}
Local aNotFields	:= {"ZZW_FILIAL","ZZW_CODPRO"}
Local lAllFields	:= .F.
Local lNotVirtual	:= .F.
Local uGhostBmpCol	:= .F.
Local lOnlyNotFields:= .F.
Local lChkX3Uso		:= .T.
Local lChkNivel		:= .F.
Local lNumGhostCol	:= .F.
Local lCposUser		:= .F.
Local nForAc		:= 0
Local cAcesso       := ""
Local cIniCpos      := "+ZZW_ITEM"
Local nAuxHr        := 0

Private oDados		:= nil

If !RetAcess(@cAcesso)
    MsgStop("Você não tem acesso a esta funcionalidade!")
    Return nil
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿         
//³Define a area dos objetos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {} 
Aadd( aObjects, { 50, 50, .t., .t. } )
Aadd( aObjects, { 50, 50, .F., .F. } )

aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 

If aSize[3] == 0
	aSize :=  {0,0,800,800,1800,800,0}
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a tela                                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Define Dialog oDlgCre 	Title cCadastro ;
					From 00,00 TO 500,1000 ;
					 /*STYLE nOR(WS_VISIBLE,WS_POPUP)*/ PIXEL
					
//oDlgCre:lMaximized := .T.
oDlgCre:SetColor(CLR_BLACK,CLR_WHITE)
oDlgCre:SetFont(oFont)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Armazena as corrdenadas da tela                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMbrWidth	:= oDlgCre:nWidth/2-43
nMbrHeight	:= oDlgCre:nHeight/2
			
@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgCre
oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT

oGrpXML		:= TGroup():New(05,05,(oMainCentro:NCLIENTHEIGHT/2)-40,(oMainCentro:NCLIENTWIDTH/2)-10,"Reimpressão - "+AllTrim(ZZL->ZZL_DESC),oMainCentro,CLR_RED,,.T.)

aAlter := IIF(cParOpc == 2 , {} , aAlter )

DbSelectArea("ZZW")
ZZW->(DbSetOrder(1))
cSeek   := ZZL->ZZL_FILIAL + ZZL->ZZL_COD
cWhile  := "ZZW->ZZW_FILIAL + ZZW->ZZW_CODPRO"
FillGetDados(cParOpc,"ZZW",1,cSeek,{|| &cWhile },,aNotFields,/*alYesFields*/,/*.T.*/,/*cQuery*/,/*bMontCols*/,.F.,aHeadAux,aColsZZW,/*bAfterCols*/,/*bBeforeCols*/)

oDados := MsNewGetDados():New( 15,10,(oMainCentro:NCLIENTHEIGHT/2)-45,(oMainCentro:NCLIENTWIDTH/2)-15, IIF(cParOpc == 2 .OR. cAcesso <> "A", 0 , GD_DELETE+GD_UPDATE), "AllwaysTrue", "AllwaysTrue", cIniCpos, aAlter,nFreeze, 1, "AllwaysTrue", "", "U_GENA093D(oDados)", oMainCentro, aHeadAux, aColsZZW)

Activate MsDialog oDlgCre On Init EnchoiceBar(oDlgCre,bConfirm,bCancel,,aButtons) Centered

If lRet
	Begin Transaction
		For nForAc := 1 To Len(oDados:aCols)
			
			If Empty(oDados:aCols[nForAc][GdFieldPos("ZZW_IDPROD",oDados:aHeader)])
				LOOP
			EndIf
			
			If oDados:aCols[nForAc][GdFieldPos("ZZW_REC_WT",oDados:aHeader)] <> 0
				lNewZZW := .F. 
				ZZW->(DbGoTo( oDados:aCols[nForAc][GdFieldPos("ZZW_REC_WT",oDados:aHeader)] ))
			Else
				lNewZZW := .T.
			EndIf
			
			If GdDeleted( nForAc , oDados:aHeader , oDados:aCols ) .AND. !lNewZZW			
				RecLock("ZZW",.F.)
				ZZW->(DbDelete())
				MsUnLock()
			ElseIf !GdDeleted( nForAc , oDados:aHeader , oDados:aCols )
				RecLock("ZZW",lNewZZW)
				ZZW->ZZW_FILIAL	:= xFilial("ZZW")
                ZZW->ZZW_CODPRO	:= ZZL->ZZL_COD
                
                for nAuxHr := 1 to Len(oDados:aHeader)
                    IF FieldPos(oDados:aHeader[nAuxHr][2]) > 0
                        ZZW->&(oDados:aHeader[nAuxHr][2])	:= oDados:aCols[nForAc][nAuxHr]
                    EndIf
                next
                /*
                ZZW->ZZW_IDPROD	:= oDados:aCols[nForAc][GdFieldPos("ZZW_IDPROD",oDados:aHeader)]
                ZZW->ZZW_DTREIM	:= oDados:aCols[nForAc][GdFieldPos("ZZW_DTREIM",oDados:aHeader)]
                ZZW->ZZW_TIRPRE	:= oDados:aCols[nForAc][GdFieldPos("ZZW_TIRPRE",oDados:aHeader)]
                ZZW->ZZW_SITUAC	:= oDados:aCols[nForAc][GdFieldPos("ZZW_SITUAC",oDados:aHeader)]
                */
				MsUnLock()
                
			EndIf
        Next nForAc
                
        MsgRun("Classe de Valor","Processando classes de valor...",{|| RpcCTH() })

	End Transaction
EndIf

RestArea(aArea)

Return nil

Static Function RpcCTH()

ZZW->(DbSetOrder(1))
ZZW->(DbSeek( xFilial("ZZW")+ZZL->ZZL_COD ))
While ZZW->(!EOF()) .AND. ZZW->ZZW_CODPRO == ZZL->ZZL_COD
    U_GENA093C(ZZW->ZZW_IDPROD,ALLTRIM(ZZL->ZZL_DESC),ZZL->ZZL_COD)
    ZZW->(DbSkip())
EndDo

Return nil

User Function GENA093P()
Local cIdProd   := ""
Local lContinua := ISINCALLSTACK( "U_GENA093I" )

IF !lContinua
    Return cIdProd
ENDIF

cIdProd   := GetSX8Num("ZZL","ZZL_COD")
CTH->(DbSetOrder(1))
lContinua   := CTH->(DbSeek( xFilial("CTH")+cIdProd ))

While lContinua
    ConfirmSX8()
    //cIdProd     := GetSX8Num("ZZW","ZZW_IDPROD")
    cIdProd     := GetSX8Num("ZZL","ZZL_COD")
    lContinua   := CTH->(DbSeek( xFilial("CTH")+cIdProd ))
EndDo

Return cIdProd

User Function GENA093I()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da rotina.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea     := GetArea()
Local nOpca		:= 3
Local aParam 	:= {}
Local nRecZZW	:= ZZW->(Recno())
Local cAcesso   := ""

Private aCpos		:= {"ZZW_DTREIM","ZZW_DTPUB", "ZZW_DTPREV","ZZW_TIRPRE","ZZW_SITUAC"}
Private aButtons	:= {}
Private cCadastro	:= "Reimpressão" // título da tela

If !RetAcess(@cAcesso)
    MsgStop("Você não tem acesso a esta funcionalidade!")
    Return nil
EndIf

//adiciona codeblock a ser executado no inicio, meio e fim
aAdd( aParam,  {||  } )  	//antes da abertura
aAdd( aParam,  {||  } )//ao clicar no botao ok
aAdd( aParam,  {||  } )//durante a transacao
aAdd( aParam,  {||  } )//termino da transacao

DbSelectArea("ZZW")
DbSetOrder(1)
ZZW->(DbSeek( xFilial("ZZW")+ZZL->ZZL_COD ))
while ZZW->(!EOF()) .AND. ZZW->ZZW_CODPRO == ZZL->ZZL_COD
    If ZZW->ZZW_SITUAC <> "2"
        MsgStop("A reimpressão "+ZZW->ZZW_IDPROD+" não está fechada, não será possível incluir novas reimpressões!")
        Return nil
    EndIf
    ZZW->(DbSkip())
end
//			AxInclui( cAlias, nReg, nOpc, aAcho, cFunc, aCpos, cTudoOk, lF3, cTransact, aButtons, aParam, aAuto, lVirtual, lMaximized, cTela, lPanelFin, oFather, aDim, uArea)
nOpca :=	AxInclui("ZZW",,3,,/*"U_USRA041I"*/,, /*"U_USRA041H"*/, .F., /*"U_Transaction"*/, aButtons, /*aParam*/,,,.F.,,,,,)

IF nOpca == 1
    MsgRun("Classe de Valor","Processando integração com RPA...",{|| U_GENA093O(ZZW->ZZW_IDPROD,'3') })
    MsgRun("Processando classes de valor...","Integração",{|| U_GENA093C(ZZW->ZZW_IDPROD,ALLTRIM(ZZL->ZZL_DESC),ZZL->ZZL_COD) })
EndIf

RestArea(aArea) 

Return .f.


User Function GENA093C(cCodClass,cDesc,cCodProd)

Local lRet      := .F.
Local aRotAuto  := {}

Private lMSErroAuto := .F.

    aAdd(aRotAuto,{"CTH_CLVL"   , cCodClass	, Nil})
	aAdd(aRotAuto,{"CTH_CLASSE" , "2", Nil})
	aAdd(aRotAuto,{"CTH_DESC01" , Alltrim(Upper(cDesc)), Nil})
	aAdd(aRotAuto,{"CTH_XCOD"   , cCodProd, Nil})
	
	DbSelectArea("CTH")
	DbSetOrder(1)
	If !DbSeek(xFilial("CTH")+cCodClass)
        MSExecAuto({|x, y| CTBA060(x, y)},aRotAuto, 3)

        If lMSErroAuto //deu erro (retorno de msexecauto)
            MostraErro()
        Else
            lRet := .T.
        EndIf
	Else
        lRet := .T.
    Endif
        
Return lRet

User Function GENA093D(oDados)

Local lRet  := .T.

If !GdDeleted( oDados:oBrowse:nAt , oDados:aHeader , oDados:aCols )    
    CTH->(DbSetOrder(1))
    If CTH->(DbSeek(xFilial("CTH")+oDados:aCols[oDados:oBrowse:nAt][GdFieldPos("ZZW_IDPROD",oDados:aHeader)])) .AND. AllTrim(CTH->CTH_XCOD) == AllTrim(ZZL->ZZL_COD)
        lRet := .F.
        MsgStop("Classe de valor já cadastrada para este Id.Produção!"+chr(13)+Chr(10)+"Veja com a contabildiade a exclusão da classe de valor antes de excluir o ID.Produção!")
    EndIf
ENDIF

Return lRet


Static Function RetAcess(cAcesso)

Local lRet          := .F.
Local aGrp		    := UsrRetGrp( nil , RetCodUsr() )
Local cGrpUsr	    := ""

aEval(aGrp,{|x| cGrpUsr+="'"+x+"'," }) 
cGrpUsr := "%("+Left(cGrpUsr, Len(cGrpUsr)-1)+")%"
If Select("TMP_SITOBR") > 0
    TMP_SITOBR->(DbCloseArea())
EndIf
BeginSql Alias "TMP_SITOBR"
    SELECT ZZR_REIMPR FROM %Table:ZZR% ZZR
    WHERE ZZR_FILIAL = %xFilial:ZZR%
    AND ZZR_NUM = '01'
    AND ZZR_TPPUB = %Exp:AllTrim(ZZL->ZZL_IDTPPU)%
    AND ZZR_SITOBR = %Exp:AllTrim(ZZL->ZZL_SITOBR)%
    AND ZZR_GRPUSR IN %Exp:cGrpUsr%
    AND ZZR.%NotDel%
EndSql
TMP_SITOBR->(DbGoTop())
If TMP_SITOBR->(EOF()) .OR. Empty(TMP_SITOBR->ZZR_REIMPR)
    cAcesso := "N"
Else
    cAcesso := TMP_SITOBR->ZZR_REIMPR
    lRet    := .T.
EndIf
TMP_SITOBR->(DbCloseArea())

Return lRet

User function GENA093S()
Local aAreaZZW  := ZZW->(GetArea())
Local nRet      := 1
Local cAliTmp   := GetNextAlias()

BEGINSQL ALIAS cAliTmp
    SELECT MAX(ZZW_ITEM) ZZW_ITEM FROM %Table:ZZW% ZZW
    WHERE ZZW_FILIAL = %xFilial:ZZW%
    AND ZZW_CODPRO = %Exp:ZZL->ZZL_COD%
    AND ZZW.%NotDel% 
ENDSQL

(cAliTmp)->(DbGoTop())
IF (cAliTmp)->(!EOF()) .AND. !Empty((cAliTmp)->ZZW_ITEM)
    nRet    := (cAliTmp)->ZZW_ITEM+1
ENDIF
(cAliTmp)->(DbCloseArea())
RestArea(aAreaZZW)
Return nRet


User Function GENA093W()
Local cRet	:= ""

//Obra nova ou nova edição:
/*
HttpGet->EMP
HttpGet->FILIAL
HttpGet->IDOBRA
HttpGet->IDPROD
HttpGet->DTREPUB
HttpGet->QTDPAG
HttpGet->TIRAPREV
HttpGet->TIRARES
HttpGet->TIPO
*/

RpcSetenv(HttpGet->EMP,HttpGet->FILIAL)
ZZL->(DbSetOrder(1))
ZZW->(DbSetOrder(1))//ZZW_FILIAL+ZZW_CODPRO+ZZW_IDPROD

IF ZZL->(DbSeek( xFilial("ZZL")+HttpGet->IDOBRA ))
	//cRet := '{"STATUS":"SUCESSO","ZZL_CEME":"'+ALLTRIM(ZZL->ZZL_CEME)+'","ZZL_AUTWEB":"'+ALLTRIM(ZZL->ZZL_AUTWEB)+'", "TESTE":"'+MyAltCarEsp(ALLTRIM(ZZL->ZZL_CEME))+'"} '    
    If ZZW->(DbSeek( xFilial("ZZW")+HttpGet->IDOBRA+HttpGet->IDPROD ))
        //If ZZW->ZZW_SITUAC <> "2"
            IF HttpGet->TIPO == "1"
                
                cRet := '{"STATUS":"SUCESSO"}'
                RecLock("ZZL",.F.)
                If Type("HttpGet->DTREPUB") <> "U"
                    ZZL->ZZL_DTPPRE := StoD(HttpGet->DTREPUB)
                EndIF
                
                If Type("HttpGet->QTDPAG") <> "U"
                    ZZL->ZZL_QTDPAG := HttpGet->QTDPAG
                EndIF

                If Type("HttpGet->TIRAPREV") <> "U"
                    ZZL->ZZL_TIRPRE := HttpGet->TIRAPREV
                EndIF

                If Type("HttpGet->TIRARES") <> "U"
                    ZZL->ZZL_TIRREL := HttpGet->TIRARES
                EndIF    
                MsUnLock()

                RecLock("ZZW",.F.)
                If Type("HttpGet->DTREPUB") <> "U"
                    ZZW->ZZW_DTPREV := StoD(HttpGet->DTREPUB)
                EndIF

                If Type("HttpGet->TIRAPREV") <> "U"                    
                    ZZW->ZZW_TIRPRE := Val(HttpGet->TIRAPREV)
                EndIF

                If Type("HttpGet->DTREREAL") <> "U"
                    //ZZW->ZZW_TIRREL := Val(HttpGet->TIRARES)
                    ZZW->ZZW_DTREAL := StoD(HttpGet->DTREREAL)
                EndIF    

                If Type("HttpGet->QTDPAG") <> "U"
                    ZZW->ZZW_QTDPAG := Val(HttpGet->QTDPAG)
                EndIF

                ZZW->ZZW_SITUAC := "1"
                MsUnLock()

            ELSEIF HttpGet->TIPO == "2"

                cRet := '{"STATUS":"SUCESSO"}'
                RecLock("ZZW",.F.)
                If Type("HttpGet->DTREPUB") <> "U"
                    ZZW->ZZW_DTREIM := StoD(HttpGet->DTREPUB)
                EndIF  
                If Type("HttpGet->DTREREAL") <> "U"                        
                    ZZW->ZZW_DTREAL := StoD(HttpGet->DTREREAL)
                EndIF
                If Type("HttpGet->TIRAPREV") <> "U"
                    ZZW->ZZW_TIRPRE := Val(HttpGet->TIRAPREV)
                EndIF
                If Type("HttpGet->TIRARES") <> "U"
                    ZZW->ZZW_TIRREL := Val(HttpGet->TIRARES)
                EndIF
                If Type("HttpGet->QTDPAG") <> "U"
                    ZZW->ZZW_QTDPAG := Val(HttpGet->QTDPAG)
                EndIF
                ZZW->ZZW_SITUAC := "1"
                MsUnLock()

            ELSE
                cRet := '{"STATUS":"FALHA - TIPO DE PROCESSAMENTO INVALIDO!"}'
            ENDIF
        //ELSE
          //  cRet := '{"STATUS":"FALHA - ESTE ID.PRODUÇÃO ESTÁ COM STATUS FECHADO, NÃO PERMITINDO ALTERAÇÃO!"}'
        //ENDIF
    Else
        cRet := '{"STATUS":"FALHA - ID PRODUÇÃO NÃO LOCALIZADO"}'
    EndIf
else
	cRet := '{"STATUS":"FALHA - OBRA NÃO LOCALIZADA"}'
EndIF

Return EncodeUtf8(cRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA093O  ºAutor  ³Cleuto Lima         º Data ³  09/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza integração com o RPA Oracle                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Projeto Gestão de Obras                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User function GENA093O(cIdProd,cTipo)

Local aRetP     := {}
Local cRetPro   := ""
Local nRetPro   := 0
Local cUpdRPA   := ""

IF Select("EXT_RPA") > 0
    EXT_RPA->(DbCloseArea())
ENDIF

BEGINSQL ALIAS "EXT_RPA"
    SELECT IDOBRA, IDOBRAHISTORICO, IDSITUACAOOBRA, IDCLASSEOBRA, IDAREAOBRA, IDEMPRESA, IDSUBCLASSEOBRA, PRODUCAO, VENDA, DOACAO, INUTILIZACAO, OUTRO, IMPRESSAO, DATAINCLUSAO, QTDEPAGINA, TABPRECO, OFERTAR, EXPORTAR, ESTRANGEIRA, PRECOGD, PRECOEXPORTACAO, PESO, PRECO_ANT, REPRESENTADA, IDTIPOENTRADAOBRA, IDCONVERSAO, IDCONVERSAOADIANTA, IDPRECIFICACAO, IDINDEXADOR, IDINDEXADORADIANTA, VALORFIXO, VALORLIQUIDO, STATEMENT, IDSITUACAODIREITO, SEQPUBLICACAO, SALDOADIANTA, VENDAANT, DOACAOANT, INUTILIZACAOANT, IMPRESSAOANT, OUTROANT, STATEMENTANT, FEC, IDAUTOR, SALDOADIANTAANT, IDOBRADA, IDCENTROLUCRO, CONSIGNAR, USUARIOINCLUI, DATAHORAINCLUI, CUSTO, CUSTOGD, IDTIPOPRODUTO, PASTAPROFESSOR, IDSELO, OBRAINTERNET, IDFORMAPGTO, USUARIOALTERA, DATAHORAALTERA, PERMITESITEGEN, PERMITECATALOGO, PERMITEPARCEIRO, PRECOPROMOCIONAL, IDOBRAORIGEM, IDCLASSEOBRAANT, IDTIPOPUBLICACAO, IDACABAMENTOCAPA, IDFORMATOCAPA, IDCORMIOLO, SUPLEMENTO, PRECO, IDTIPOINCLUSAOOBRA, QTDEPAGINAREALIZADA, PERMITESITECRM, TIRAGEMPREVISTA, TIRAGEMREALIZADA, QTDEILUSTRACAO, IDSITUACAOPASTAPROFESSOR, QTDEPORCAIXA, IDSTATUSOBRADA, PRECONOVO, PUBLICACAOPERIODICA, PRECODE, IDSITUACAOEBOOK, IDSITUACAOPERMISSAO, IDSITUACAOMINHABIB, IDSITUACAOREIMP, IDSITUACAONOVAED, IDFABRICANTE, IDASSUNTO, D_E_L_E_T_E FROM OBRA O
    WHERE O.IDOBRA = %Exp:cIdProd%
ENDSQL

EXT_RPA->(DbGoTop())
IF EXT_RPA->(!EOF())
    If cTipo <> '3'
        Begin Transaction
            cUpdRPA := " UPDATE OBRA SET IDSITUACAOOBRA = "+IIF(ZZL->ZZL_SITOBR == "000","109",ZZL->ZZL_SITOBR)+",DESCRICAO = '"+AllTrim(ZZL->ZZL_DESC)+"', AUTORPRINC = '"+AllTrim(ZZL->ZZL_AUTOR)+"' WHERE IDOBRA = "+ZZL->ZZL_COD
            IF TCSqlExec(cUpdRPA) < 0
                xMagHelpFis("Integração Oracle", "TCSQLError()" + TCSQLError(), "Entre em contato com a TI" )
            EndIF
        End Transaction
    EndIf    
ELSE
    ZZA->(DbSetOrder(1))
    ZZA->(DbSeek( xFilial("ZZA")+ALLTRIM(ZZL->ZZL_CC) ))
    Begin Transaction
        /*
        cUpdRPA := " INSERT INTO OBRA (	IDOBRA			,DESCRICAO						,AUTORPRINC						,IDOBRAHISTORICO					,IDOBRAMAE						,	IDSITUACAOOBRA	,PRODUCAO			,IDFABRICANTE			,IDTIPOPUBLICACAO		,IDEMPRESA				,IDOBRADA			,IDCENTROLUCRO		                                ,IDOBRAORIGEM	,IDSITUACAODIREITO	,DATAINCLUSAO	,QTDEPAGINA	        ,USUARIOALTERA		                    ,DATAHORAALTERA	,USUARIOINCLUI							,DATAHORAINCLUI	,OUTRO,IMPRESSAO,TABPRECO,OFERTAR,EXPORTAR,ESTRANGEIRA,PRECOGD,PRECOEXPORTACAO,PESO,PRECO_ANT,REPRESENTADA,IDTIPOENTRADAOBRA,IDCONVERSAO,IDCONVERSAOADIANTA,IDPRECIFICACAO,IDINDEXADOR,IDINDEXADORADIANTA,VALORFIXO,VALORLIQUIDO,STATEMENT,SEQPUBLICACAO,SALDOADIANTA,VENDAANT,DOACAOANT,INUTILIZACAOANT,IMPRESSAOANT,OUTROANT,STATEMENTANT,FEC,IDAUTOR,SALDOADIANTAANT,CONSIGNAR,CUSTO,CUSTOGD,IDTIPOPRODUTO,PASTAPROFESSOR,IDSELO,OBRAINTERNET,IDFORMAPGTO,PERMITESITEGEN,PERMITECATALOGO,PERMITEPARCEIRO,PRECOPROMOCIONAL,IDCLASSEOBRAANT,IDACABAMENTOCAPA,IDFORMATOCAPA,IDCORMIOLO,SUPLEMENTO,PRECO,IDTIPOINCLUSAOOBRA,QTDEPAGINAREALIZADA,PERMITESITECRM,TIRAGEMPREVISTA,TIRAGEMREALIZADA,QTDEILUSTRACAO,IDSITUACAOPASTAPROFESSOR,QTDEPORCAIXA,IDSTATUSOBRADA,PRECONOVO,PUBLICACAOPERIODICA,PRECODE,IDSITUACAOEBOOK,IDSITUACAOPERMISSAO,IDSITUACAOMINHABIB,IDSITUACAOREIMP,IDSITUACAONOVAED,IDASSUNTO,IDAREAOBRA,IDSUBCLASSEOBRA,VENDA,DOACAO,INUTILIZACAO,IDCLASSEOBRA,D_E_L_E_T_E)"
        cUpdRPA += " VALUES ( 			"+cIdProd+"     ,'"+AllTrim(ZZL->ZZL_DESC)+"'   ,'"+AllTrim(ZZL->ZZL_AUTOR)+"'	,"+AllTrim(ZZL->ZZL_CODHIS)+"		,"+AllTrim(ZZL->ZZL_IDMAE)+"	,	109				,"+cIdProd+"	    ,"+ZZL->ZZL_EMPRES+"	,"+ZZL->ZZL_IDTPPU+"	,"+ZZL->ZZL_EMPRES+"	,"+cIdProd+"	    ,"+IIF( Empty(ZZA->ZZA_CL)  ,'0', ZZA->ZZA_CL )+"	,0		        ,0  				,SYSDATE		,0			        ,'"+AllTrim(UsrRetName(RetCodUsr()))+"'	,SYSDATE		,'"+AllTrim(UsrRetName(RetCodUsr()))+"'	,SYSDATE		,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,' ')"

        IF TCSqlExec(cUpdRPA) < 0
            xMagHelpFis("Integração Oracle", "TCSQLError()" + TCSQLError(), "Entre em contato com a TI" )
        EndIF
        */
        
        aRetP := TCSPEXEC("DBA_EGK.PROTHEUS_OBRAPRODUCAO_INSERT",Val(cIdProd),val(AllTrim(ZZL->ZZL_COD)),109,val(ZZL->ZZL_EMPRES),AllTrim(ZZL->ZZL_AUTOR),AllTrim(ZZL->ZZL_DESC),Val(AllTrim(ZZL->ZZL_CODHIS)),0,Val(IIF( Empty(ZZA->ZZA_CL)  ,'0', ZZA->ZZA_CL )),IIF( cTipo == "3",3,Val(ZZL->ZZL_TIPINC)),0)
        If cTipo <> '3'
            cUpdRPA := " UPDATE OBRA SET DESCRICAO = '"+AllTrim(ZZL->ZZL_DESC)+"', AUTORPRINC = '"+AllTrim(ZZL->ZZL_AUTOR)+"' WHERE IDOBRA = "+cIdProd
            IF TCSqlExec(cUpdRPA) < 0
                xMagHelpFis("Integração Oracle", "TCSQLError()" + TCSQLError(), "Entre em contato com a TI" )
            EndIF
        EndIf    

    End Transaction				
ENDIF

IF Select("EXT_RPA") > 0
    EXT_RPA->(DbCloseArea())
ENDIF

Return nil


