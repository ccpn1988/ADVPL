#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA378FLT  ºAutor  ³Microsiga           º Data ³  02/17/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//FinA378
User Function FA378FLT()

Local aArea			:= GetArea()
Local cRet			:= "" 
Local cSeek			:= ""
Local cRecSE5		:= ""
Local cRecSE2		:= ""
Local cAlias		:= "TRBSE5"
Local lQuery		:= paramixb[1]
Local cNomeArq   	:= ""
Local aVar			:= {}
Local cChave 		:= ""
Local aOrd			:= {}
Local nCont1		:= 0
Local aCampos		:= {}
Local nI			:= 0 
Local aListar		:= {}
Local cViewCampo	:= ""
Local lChangeX		:= .T.
Local nIndice 		:= SE5->(IndexOrd())
Local cMarca		:= GetMark()
Local aSize			:= MSADVSIZE()
Local oDlgFin		:= nil
Local oPanel		:= nil
Local cQryAyx		:= cQuery

Local aStrTemp		:= {}
Local aStruQry		:= {}
//Local cCodRetCus	:= GetMv("MV_CODRET")
	
Local oMark1		:= nil
Local oBtn			:= nil
Local oBt3			:= nil
Local oBt4			:= nil
Local oBt5			:= nil
Local cFilter		:= ""
Local lInverte		:= .F.
Local cCodRetCus	:= ""
Local lCodRet		:= 	.F.
Local cFornBen		:= ""
Local cLojBen		:= ""
Local cImposto		:= ""
Local lPCCBaixa		:= SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )


If !IsInCallStack("U_GENA060")
	Return ""
EndIf
//verificando a existencia do parametro
// Pega todos os codigos de retenção PCC - Pis / Cofins / Csll
/*
dbSelectArea("SX6")
dbSetOrder(1)
If ( dbSeek( "  " + "MV_CODRET" ) )
	cCodRetCus	:= GetMv("MV_CODRET")
	lCodRet		:= .T.
EndIf
*/
aStruQry	:= SE5->(dbStruct())
//If lChoose    

	cQryAyx		:= StrTran(cQryAyx,"SE5.R_E_C_N_O_ RECSE5","SE5.R_E_C_N_O_ RECSE5,SE2.R_E_C_N_O_ RECSE2,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_SEQBX,E2_NATUREZ,E2_EMISSAO,E2_VENCTO,E2_FORNECE,E2_LOJA,E2_CODRET,E2_VALOR  ")
	cQryAyx		:= StrTran(cQryAyx,RetSqlname("SE5")+" SE5",RetSqlname("SE5")+" SE5, "+RetSqlName("SE2")+" SE2 ")
    
	cQryAyx += " AND "
	cQryAyx += "E2_TIPO  = 'TX '      			AND "
	cQryAyx += "E2_VALOR = E2_SALDO   			AND "
	cQryAyx += "E2_SALDO > 0          			AND "
	cQryAyx += "E2_FORNECE = '"+cForUniao+"'	AND "
	cQryAyx += "E2_LOJA    = '"+cLojUniao+"'	AND "
	cQryAyx += "E2_NATUREZ <> '"+cNatIrf+"'	   	"

	// Esta condicao é para tratar alguns casos que tenha customização no parametro MV_IRF.			
	//If lCodRet
	//	cQryAyx += "E2_CODRET  IN ('"+cCodRetCus+"')	AND "
	//EndIf
	
	cQryAyx += " AND SE2.D_E_L_E_T_ = ' ' "
	//------------------- NOVO
	cQryAyx += " AND SE5.E5_FILIAL = SE2.E2_FILIAL "
	cQryAyx += " AND SE5.E5_PREFIXO||SE5.E5_NUMERO||SE5.E5_PARCELA||SE5.E5_TIPO||SE5.E5_CLIFOR||SE5.E5_LOJA = SE2.E2_TITPAI "
	cQryAyx += " AND ( "																					//1 Abre
	cQryAyx += " 	   	( SE5.E5_MOTBX != 'PCC' AND SE5.E5_SEQ = SE2.E2_SEQBX ) "	//2 Abre - Fecha
	cQryAyx += "       OR ( SE5.E5_MOTBX = 'PCC' AND "											//3 Abre
	cQryAyx += "          	(   "																		//4 Abre
	cQryAyx += "                 (E5_VRETCOF > 0 AND E5_PRETCOF IN (' ','4')) "       //4 4.1
	cQryAyx += "              OR (E5_VRETPIS > 0 AND E5_PRETPIS IN (' ','4')) "       //4 4.2
	cQryAyx += "              OR (E5_VRETCSL > 0 AND E5_PRETCSL IN (' ','4')) "       //4 4.3
	cQryAyx += "               )"                                                      //4 Fecha
	cQryAyx += "            ) "                                                       //3 Fecha
	cQryAyx += " 		)"																					//1 Fecha
		   
	Aadd(aStrTemp ,{"E2_PREFIXO"	, "C", 03, 0 } )
	Aadd(aStrTemp ,{"E2_NUM"		, "C", 09, 0 } )
	Aadd(aStrTemp ,{"E2_PARCELA"	, "C", 01, 0 } )
	Aadd(aStrTemp ,{"E2_SEQBX"		, "C", 02, 0 } )
	Aadd(aStrTemp ,{"E2_NATUREZ"	, "C", 10, 0 } )
	Aadd(aStrTemp ,{"E2_EMISSAO"	, "D", 08, 0 } )
	Aadd(aStrTemp ,{"E2_VENCTO"	, "D", 08, 0 } )
	Aadd(aStrTemp ,{"E2_FORNECE"	, "C", 06, 0 } )
	Aadd(aStrTemp ,{"E2_LOJA"		, "C", 02, 0 } )
	Aadd(aStrTemp ,{"E2_CODRET"	, "C", 04, 0 } )
	Aadd(aStrTemp ,{"E2_VALOR"		, "N", 17, 2 } )
	
	For nX := 1 To Len(aStrTemp)
		If Ascan(aStruQry,{|campo| AllTrim(campo[1]) == AllTrim(aStrTemp[nX,1])}) == 0
			Aadd(aStruQry,Aclone(aStrTemp[nX]))
		Endif
	Next
//EndIf
	
Asort(aStruQry,,,{|x,y| x[1]<y[1]})  // colocar os campos da tabela  SE2 na frente do browse
Aadd(aStruQry ,{"RECSE5", "N", 10, 0 } ) // tratar o campo recno

//If lChoose
	Aadd(aStruQry ,{"RECSE2", "N", 10, 0 } ) // tratar o campo recno
//EndIf	

	
If Select(cAlias) > 0
	(cAlias)->(Dbclosearea())
EndIf

//cNomeArq	:= CriaTrab( aStruQry, .T. )
//dbUseArea(.T.,__LocalDriver,cNomeArq,"TRBSE5",.T.,.F.)

//Cria o Objeto do FwTemporaryTable
_oFA378FLT := FwTemporaryTable():New("TRBSE5")

//Cria a estrutura do alias temporario
_oFA378FLT:SetFields(aStruQry)

//Adiciona o indicie na tabela temporaria		
_oFA378FLT:AddIndex("1",{"RECSE5"})
_oFA378FLT:AddIndex("2",{"E5_FILIAL"	, "E5_DATA"	, "E5_BANCO"	, "E5_AGENCIA", "E5_CONTA"	, "E5_NUMCHEQ", "RECSE5"})
_oFA378FLT:AddIndex("3",{"E5_FILIAL"	, "E5_TIPODOC", "E5_PREFIXO", "E5_NUMERO"	, "E5_PARCELA", "E5_TIPO"	, "E5_DATA"	, "E5_CLIFOR"	, "E5_LOJA"	, "E5_SEQ"	, "RECSE5"})
_oFA378FLT:AddIndex("4",{"E5_FILIAL"	, "E5_BANCO"	, "E5_AGENCIA", "E5_CONTA"	, "E5_PREFIXO", "E5_NUMERO"	, "E5_PARCELA", "E5_TIPO"	, "E5_DATA"	, "RECSE5"})
_oFA378FLT:AddIndex("5",{"E5_FILIAL"	, "E5_NATUREZ", "E5_PREFIXO", "E5_NUMERO"	, "E5_PARCELA", "E5_TIPO"	, "E5_DTDIGIT", "E5_RECPAG"	, "E5_CLIFOR"	, "E5_LOJA", "RECSE5"})
_oFA378FLT:AddIndex("6",{"E5_FILIAL"	, "E5_LOTE"	, "E5_PREFIXO", "E5_NUMERO"	, "E5_PARCELA", "E5_TIPO"	, "E5_DATA"	, "RECSE5"})
_oFA378FLT:AddIndex("7",{"E5_FILIAL"	, "E5_DTDIGIT", "E5_NATUREZ", "RECSE5"})
_oFA378FLT:AddIndex("8",{"E5_FILIAL"	, "E5_PREFIXO", "E5_NUMERO"	, "E5_PARCELA", "E5_TIPO"	, "E5_CLIFOR"	, "E5_LOJA"	, "E5_SEQ"		, "RECSE5"})
_oFA378FLT:AddIndex("9",{"E5_FILIAL"	, "E5_ORDREC"	, "E5_SERREC"	, "RECSE5"})
_oFA378FLT:AddIndex("10",{"E5_FILIAL"	, "E5_PROJPMS", "E5_EDTPMS"	, "E5_TASKPMS", "E5_DATA"	, "E5_BANCO"	, "E5_AGENCIA", "E5_CONTA"	, "RECSE5"})
_oFA378FLT:AddIndex("11",{"E5_FILIAL"	, "E5_DOCUMEN", "RECSE5"})
_oFA378FLT:AddIndex("12",{"E5_FILIAL"	, "E5_BANCO"	, "E5_AGENCIA", "E5_CONTA"	, "E5_NUMCHEQ", "E5_DATA"	, "RECSE5"})
_oFA378FLT:AddIndex("13",{"E5_FILIAL"	, "E5_BANCO"	, "E5_AGENCIA", "E5_CONTA"	, "E5_DTDISPO", "E5_NUMCHEQ", "RECSE5"})
_oFA378FLT:AddIndex("14",{"E5_FILIAL"	, "E5_BANCO"	, "E5_DTDISPO", "E5_CONTA"	, "E5_AGENCIA", "E5_TIPODOC", "RECSE5"})
_oFA378FLT:AddIndex("15",{"E5_FILIAL"	, "E5_NODIA"	, "RECSE5"})

//Criando a Tabela Temporaria
_oFA378FLT:Create()

//Gerando os indices sobre o arquivo TMP, com base o SE5
/*
DbSelectArea("SIX")
DbSetOrder(1)
DbSeek("SE5")
While SIX->(!Eof()) .AND. SIX->INDICE=="SE5" 
	nI++
	//Trato limitacao de 15 indices para __LocalDriver == DBFCDX
	//Nao ocorre com outras RDDs
	If !(__LocalDrive == "DBFCDX" .and. nI > 15)

		Aadd(aVar,SubStr(CriaTrab(Nil,.F.),1,7)+AllTrim(SIX->ORDEM))
		cChave := SIX->CHAVE
		DbSelectArea("TRBSE5")
		DbCreateInd(aVar[Len(aVar)]+OrdBagExt() ,cChave, {|| cChave})
		DbSelectArea("SIX")
		aAdd(aOrd,SIX->DESCRICAO)
		DbSkip()
	Else
		Exit
	Endif
		
EndDo

dbSelectArea("TRBSE5")
dbClearInd()
For nI := 1 To Len(aVar)
	dbSetIndex(aVar[nI]+OrdBagExt())
Next nI
*/

//Esta chamada cria o arquivo temporario sobre a cQryAyx enviada.
Processa({|| SqlToTMP(cQryAyx, aStruQry, "TRBSE5" ,lPCCBaixa )}) // Cria arquivo temporario

dbSelectArea(cAlias)
DbGoTop()

If Eof()
	Alert("Sem informação na base, com este parametro.")		//"Sem informação na base, com este parametro."
	dbCloseArea()
	Ferase(cAlias+GetDBExtension())
	Ferase(cAlias+OrdBagExt())

	cRet	:= " AND 1 <> 1 "
	Return cRet
Endif

ProcRegua(RecCount())

aListar	:= {}

cField  := "E5_OK"

//Bloco Descontinuado Lucas Ribeiro 16.07.19
/*dbSelectArea('SX3')
dbSetOrder(2)
dbSeek("E5_OK")
aAdd(aListar,{ X3_CAMPO, , AllTrim(X3_TITULO), X3_PICTURE })
*/
                                                            
aAdd(aListar,{ cField, , Posicione("SX3",2,cField,"X3_TITULO"), Posicione("SX3",2,cField,"X3_PICTURE") })

//Bloco Descontinuado Lucas Ribeiro 16.07.19
// Mostrando no titulo os registros do SE2
/*dbSetOrder(1)
dbSeek("SE2")*/

cViewCampo:= "E2_PREFIXO/E2_NUM/E2_PARCELA/E2_SEQBX/E2_NATUREZ/E2_EMISSAO/E2_VENCTO/E2_FORNECE/E2_LOJA/E2_CODRET/E2_VALOR"

//Bloco Descontinuado Lucas Ribeiro 16.07.19
/*    
While !Eof() .And. SX3->X3_ARQUIVO == "SE2"
	If Alltrim(SX3->X3_CAMPO) $ cViewCampo
		aAdd(aListar,{ X3_CAMPO, , AllTrim(X3_TITULO), X3_PICTURE })
	Endif
	dbSkip()
EndDo
*/
//---------------------------------------

aCampos := FWSX3Util():GetAllFields( "SE2", .F. )
                                           
For xLoop := 1 To Len(aCampos)
	If aCampos[xLoop] $ cViewCampo		
		aAdd(aListar,{ aCampos[xLoop], ,Posicione("SX3",2,aCampos[xLoop],"X3_TITULO"),Posicione("SX3",2,aCampos[xLoop],"X3_PICTURE")})
	EndIf
Next xLoop
              
/*
dbSetOrder(1)
dbSeek("SE5")
While !Eof() .And. SX3->X3_ARQUIVO == "SE5"
	If Alltrim(SX3->X3_CAMPO) <> "E5_OK"
		aAdd(aListar,{ X3_CAMPO, , AllTrim(X3_TITULO), X3_PICTURE })
	Endif
	dbSkip()
EndDo
*/

aCampos := FWSX3Util():GetAllFields( "SE5", .F. )
                                           
For xLoop := 1 To Len(aCampos)
	If aCampos[xLoop] <> cField
		aAdd(aListar,{ aCampos[xLoop], ,Posicione("SX3",2,aCampos[xLoop],"X3_TITULO"),Posicione("SX3",2,aCampos[xLoop],"X3_PICTURE")})
	EndIf
Next xLoop  

lChangeX	:= .T.
nIndice 	:= SE5->(IndexOrd())

dbSelectArea(cAlias)

cMarca	:= GetMark()
aSize	:= MSADVSIZE()

DEFINE MSDIALOG oDlgFin TITLE "Selecionados" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
oDlgFin:lMaximized := .T.

oPanel := TPanel():New(0,0,'',oDlgFin,, .T., .T.,, ,30,30,.T.,.T. )
oPanel:Align := CONTROL_ALIGN_BOTTOM

//Botao Pesquisa
DEFINE SBUTTON oBtn  FROM 10,200	TYPE 15 ACTION (Fin378Pesq(oMark1,cAlias,nIndice,lQuery)) ENABLE OF oPanel
//Botao confirmar
DEFINE SBUTTON FROM 10,230 TYPE 1 ACTION (oDlgFin:End()) ENABLE OF oPanel
//Botao Fechar
DEFINE SBUTTON FROM 10,260 TYPE 2 ACTION (lChangeX:= .F.,oDlgFin:End ()) ENABLE OF oPanel

oBtn:cToolTip := "Pesquisa" //"Pesquisa"
oBtn:cCaption := "Pesquisa" //"Pesquisa"

oMark1	:=	MsSelect():New (cAlias, "E5_OK",,aListar,@lInverte,@cMarca, {10, 11, 160, 535})
oMark1:oBrowse:bAllMark := { || F378Invert(cAlias,cMarca,.T.,oMark1)}
oMark1:oBrowse:Refresh()

oMark1:oBrowse:lHasMark 	:= 	.T.
oMark1:oBrowse:lCanAllMark	:=	.T.
oMark1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlgFin CENTERED

If !lChangeX
	cRet	:= " AND 1 <> 1 "
Else
	
	(cAlias)->(DbGoTop())
	While (cAlias)->(!EOF())
		
		If AllTrim((cAlias)->E5_OK) <> AllTrim(cMarca)
			(cAlias)->(DbSkip())
			Loop
		EndIf
		
//		If lChoose
			cRecSE2 += AllTrim(Str((cAlias)->RECSE2))+","
//		EndIf	
		cRecSE5 += AllTrim(Str((cAlias)->RECSE5))+","

		(cAlias)->(DbSkip())
	EndDo
	
	If lChoose
		If !Empty(cRecSE2)
			cRecSE2 := Left(cRecSE2,Len(cRecSE2)-1)//FormatIn(cRecSE2,"#")
			cRet	:= cRet+" AND SE2.R_E_C_N_O_ IN ("+cRecSE2+") "
		EndIf
	EndIf	
	
	If !Empty(cRecSE5)
		cRecSE5 := Left(cRecSE5,Len(cRecSE5)-1)//FormatIn(cRecSE5,"#")
		cRet	:= cRet+" AND SE5.R_E_C_N_O_ IN ("+cRecSE5+") "
	EndIf
	
	lChoose		:= .F. 
	lSeleciona	:= .F.
EndIf

dbSelectArea(cAlias)
(cAlias)->(dbCloseArea())
Ferase(cAlias+GetDBExtension())
Ferase(cAlias+OrdBagExt())


RestArea(aArea)
	    		
Return cRet  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA378   ºAutor  ³Microsiga           º Data ³  09/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function SqlToTMP( cQryAyx, aStrTemp, cAliasTmp , lPCCBaixa )
Local nI		:= 0
Local nJ        := 0
Local nF        := 0
Local nTotalRec := 0
Local aStruQry 	:= {}
Local cAliasTrx	:= ""

cAliasTrx := GetNextAlias()
cQryAyx := ChangeQuery(cQryAyx)
MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQryAyx), cAliasTrx, .F., .T.)},"Gerando....")

For nJ := 1 to Len(aStrTemp)
	If !(aStrTemp[nJ,2] $ 'CM')
		TCSetField(cAliasTrx, aStrTemp[nJ,1], aStrTemp[nJ,2],aStrTemp[nJ,3],aStrTemp[nJ,4])
	EndIf
Next nJ

nTotalRec:= (cAliasTrx)->(RecCount())
aStruQry := (cAliasTrx)->(DbStruct())
nF			:= Len(aStruQry)

(cAliasTrx)->(DbGoTop())

ProcRegua( nTotalRec )

While !((cAliasTrx)->(Eof()))
	IncProc()	
	(cAliasTmp)->(DbAppend())
	For nI := 1 To nF
		If (cAliasTmp)->(FieldPos(aStruQry[nI,1])) > 0	 .And. aStruQry[nI,2] <> 'M'
			(cAliasTmp)->(FieldPut(FieldPos(aStruQry[nI,1]),(cAliasTrx)->(FieldGet(FieldPos(aStruQry[nI,1])))))
		Endif
	Next nI
	(cAliasTrx)->(DbSkip())
End


DbSelectArea(cAliasTrx)
DbCloseArea()
DbSelectArea(cAliasTmp)

Return Nil
