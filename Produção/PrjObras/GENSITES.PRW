#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "Totvs.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "dbtree.ch"

#Define ENTER Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENSITES  ºAutor  ³Cleuto Lima         º Data ³  09/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Sites gen x categorias                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Projeto Gestão de Obras                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENSITES()

Private oBrowse                                                               
Private aRotina	:= {}

DbSelectArea("ZZM")
ZZM->(DbSetOrder(1))

// Definição das Operações disponíveis.
aRotina := MenuDef()           

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZZM')
oBrowse:SetDescription("Site x Categoria") 

oBrowse:Activate()

Return NIL

Static Function MenuDef()
Local aRotina := {}

//aRotina := FWMVCMenu( "GENSITES" )
ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.GENSITES' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.GENSITES' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.GENSITES' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir' ACTION 'VIEWDEF.GENSITES' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Verficiar Estrutura' ACTION 'U_GENZZNF3(.T.)' OPERATION 2 ACCESS 0

Return aRotina


Static Function ModelDef()     
// Cria Estruturas para serem usadas no Modelo de Dados
Local oStruZZM  := FWFormStruct(1,'ZZM')

// Cria Modelo de Dados
Local oModel 

oModel := MPFormModel():New('GENCAD_SITE')

// Adiciona um Componente de Formulário ao modelo.
oModel:AddFields('ZZM_FORM',/*cOwner*/,oStruZZM,/*blinePre*/,/*blinePos*/)   

// Descrição do Modelo
oModel:SetDescription("Site x Categoria") 
// Descrição do Modelo
oModel:GetModel('ZZM_FORM'):SetDescription("Site x Categoria")

Return oModel      

Static Function ViewDef()

// Cria Estruturas para serem usadas na View
Local oStruZZM  := FWFormStruct(2,'ZZM')

// Carrega o modelo de dados de um fonte MVC. No caso, carregamos deste fonte mesmo.
Local oModel := FWLoadModel('GENSITES')

// Cria o modelo da View
Local oView := FWFormView():New()

// Definimos qual modelo será carregado nessa View
oView:SetModel(oModel)

// Adiciona os componentes visuais. Cada componente Está relacionado à um modelo de Estrutura de dados, definidos em ModelDef()
oView:AddField('VIEW_ZZM', oStruZZM, 'ZZM_FORM')

// Agora vamos criar 'box' para suportar os componentes. Box é uma descrição genérica para Window, Panel, etc
oView:CreateHorizontalBox( 'TELA', 100 ) // ocupar 100% da tela
 
// Relacionamos o Box criado ao objeto View
oView:SetOwnerView('VIEW_ZZM' ,'TELA')

//Para mostrar os titulos dos grids                                          
oView:EnableTitleView('VIEW_ZZM')

Return oView

User Function GENZZNF3(lViewAll,oDlgTree,oDlgPai)

Local oGrpTRee	:= nil
Local oTree		:= nil
Local lRet		:= .F.
Local oPntTree	:= nil
Local nMbrWidth	:= nil
Local nMbrHeight:= nil
Local aNos		:= {}
Local cSeqTree	:= "000"
Local cSites	:= ""
Local lCriDlg	:= ValType(oDlgTree) == "U"

Default lViewAll := .F.

IF !lViewAll
	// alinhado com Rafa em 07/10/2019 para trazer todas as gategorias
	cSites += ";"
	/*
	If !(ZZL->ZZL_PSITEG == "1")
		cSites += "001;"
	EndIf

	If !(ZZL->ZZL_PERCRM == "1")
		cSites += "002;"
	EndIf

	If
	cSites += "003;"
	*/

else
	cSites += ";"
EndIf

cSites := Replace("%"+FormatIn(cSites,";")+"%",",''",",' '")

If Select("TMP_XML") > 0
	TMP_XML->(DbCloseArea())
EndIf

BeginSql Alias "TMP_XML"
	SELECT ZZO_COD,TRIM(ZZO_DESC) ZZO_DESC
	FROM %Table:ZZO% ZZO
	WHERE ZZO_FILIAL = %xFilial:ZZO%
	AND ZZO_COD NOT IN %Exp:cSites%
	AND ZZO.%NotDel%	 	
	ORDER BY ZZO_COD
EndSql

If TMP_XML->(EOF())
	TMP_XML->(DbCloseArea())
	MsgStop("Este produto não tem nenhum site atrelado a ele!")
	Return .F.
EndIf

TMP_XML->(DbgoTop())

IF lCriDlg
	DEFINE DIALOG oDlgTree TITLE "Seleção de Categorias" FROM 180,180 TO 800,1200 PIXEL
ENDIF

nMbrWidth	:= oDlgTree:nWidth/2-43
nMbrHeight	:= oDlgTree:nHeight/2
    
@00,00 MSPANEL oPntTree PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgTree
oPntTree:Align := CONTROL_ALIGN_ALLCLIENT

oGrpTree		:= TGroup():New(05,05,(oPntTree:NCLIENTHEIGHT/2)-40,(oPntTree:NCLIENTWIDTH/2)-10,"Site x Categorias - Tecla de atalho F5",oPntTree,CLR_RED,,.T.)

oTree := DbTree():New(15,10,(oPntTree:NCLIENTHEIGHT/2)-45,(oPntTree:NCLIENTWIDTH/2)-15,oDlgTree,,,.T.)
oTree:lShowHint := .t.

While TMP_XML->(!EOF())

	oTree:AddTreeItem("S"+TMP_XML->ZZO_COD+" - "+PadR(AllTrim(TMP_XML->ZZO_DESC),300),"WEB",NIL,"S"+TMP_XML->ZZO_COD)
	Aadd(aNos,  {TMP_XML->ZZO_COD , "" , "" , PadR(AllTrim(TMP_XML->ZZO_DESC),300) , "SITE","S"+TMP_XML->ZZO_COD} )
	
	TMP_XML->(DbSkip())
EndDo

TMP_XML->(DbCloseArea())
oTree:EndTree()
oTree:PTRefresh()
oTree:TreeSeek("S001")
oTree:PTUpdateNodes("S001")
oTree:PTSrvUpdatePosition()

oTree:BLCLICKed	:= {|x| IIF( (lRet := ZZNF3RET(x,aNos,@cSeqTree,.t.,lViewAll)) , oDlgPai:End() , nil ) }
SetKey(VK_F5  , {|x| IIF( (lRet := ZZNF3RET(oTree,aNos,@cSeqTree,.t.,lViewAll)) , oDlgPai:End() , nil )  })

IF lCriDlg
	ACTIVATE DIALOG oDlgTree CENTERED 
ENDIF	

// Apaga um SetKey
SetKey(VK_F5, {||})

Return lRet

Static Function xRetTree(oParam,aNos,cCargo,cSeqTree)

Local nPosCargo	:= aScan(aNos, {|x| x[6] == cCargo } )
Local cSeekAux	:= ""
Local lFilho	:= aNos[nPosCargo][5] == "FILHO" 
Local cSite		:= aNos[nPosCargo][1]
Local cMae		:= IIF( aNos[nPosCargo][5] == "FILHO" , PadR(aNos[nPosCargo][2],TamSx3("ZZM_CODMAE")[1]) , PadR(aNos[nPosCargo][3],TamSx3("ZZM_CODCAT")[1]) ) 
//Local cCat	:= PadR(aNos[nPosCargo][3],TamSx3("ZZM_CODCAT")[1])

If Select("TMP_XML") > 0
	TMP_XML->(DbCloseArea())
EndIf

BeginSql Alias "TMP_XML"
	SELECT ZZM_CODSIT,TRIM(ZZO_DESC) ZZO_DESC, ZZM_CODMAE, ZZM_CODCAT, TRIM(ZZM_DESCAT)||' : '||Trim(ZZM_CODOLD) ZZM_DESCAT,
	CASE WHEN ( SELECT COUNT(*) FROM %Table:ZZM% FILHO WHERE FILHO.ZZM_FILIAL = ZZM.ZZM_FILIAL AND FILHO.ZZM_CODSIT = ZZM.ZZM_CODSIT AND FILHO.ZZM_CODMAE = ZZM.ZZM_CODCAT AND FILHO.%NotDel% ) > 0 THEN 'PAI' ELSE 'FILHO' END FILHO
	FROM %Table:ZZM% ZZM
	JOIN %Table:ZZO% ZZO
	ON ZZO_FILIAL = %xFilial:ZZO%
	AND ZZO_COD = ZZM_CODSIT	
	AND ZZM_CODMAE = %Exp:cMae%
	//AND ZZM_CODCAT = %Exp:cCat%	
	AND ZZO_COD = %Exp:cSite%
	AND ZZO.%NotDel%	 	
	WHERE ZZM.%NotDel%	
	ORDER BY ZZM_CODSIT,CASE WHEN ZZM_CODMAE = ' ' THEN ZZM_CODCAT ELSE ZZM_CODMAE END,ZZM_CODCAT
EndSql	
//AND ( SELECT COUNT(*) FROM %Table:ZZM% FILHO WHERE FILHO.ZZM_FILIAL = ZZM.ZZM_FILIAL AND FILHO.ZZM_CODSIT = ZZM.ZZM_CODSIT AND FILHO.ZZM_CODMAE = ZZM.ZZM_CODCAT AND FILHO.%NotDel% ) > 0
oParam:BeginUpdate()

TMP_XML->(DbGoTop())
While TMP_XML->(!EOF())
	
	nPosCargo := aScan(aNos, {|x| x[1] == TMP_XML->ZZM_CODSIT .AND. x[2] == TMP_XML->ZZM_CODMAE .AND. x[3] == TMP_XML->ZZM_CODCAT  } )
	
	If nPosCargo == 0
		cSeqTree	:= Soma1(cSeqTree)
		If Empty(cSeekAux)
			cSeekAux	:= cSeqTree
		EndIf		
		//oParam:TreeSeek(cCargo)				
		oParam:AddItem(TMP_XML->ZZM_CODCAT+" - "+allTrim(TMP_XML->ZZM_DESCAT),AllTrim(cSeqTree), iif( AllTrim(TMP_XML->FILHO) == "FILHO" , "S4WB009N" , "Normas") ,iif( AllTrim(TMP_XML->FILHO) == "FILHO" , "S4WB009N" , "Normas"),,,2)		
		//oTree:AddTreeItem(AllTrim(TMP_XML->ZZM_DESCAT),"WEB",NIL,TMP_XML->ZZO_COD)
		//Aadd(aNos,  {TMP_XML->ZZM_CODSIT , ZZM_CODMAE , TMP_XML->ZZO_COD , AllTrim(TMP_XML->ZZO_DESC) , "SITE",cSeqTree} )	
		Aadd(aNos,  {TMP_XML->ZZM_CODSIT , TMP_XML->ZZM_CODMAE , TMP_XML->ZZM_CODCAT , TMP_XML->ZZM_DESCAT , TMP_XML->FILHO , cSeqTree } )		
	EndIf
		
	TMP_XML->(DbSkip())
EndDo

If !lFilho .and. nPosCargo == 0 
	oParam:TreeSeek(cSeekAux)
EndIF	

oParam:EndUpdate()

TMP_XML->(DbCloseArea())

Return nil

Static Function ZZNF3RET(oParam,aNos,cSeqTree,lDbClick,lViewAll)

Local lRet		:= .F.
Local cDesc		:= ""
//Local nPosNo	:= aScan(aNos, {|x| x[1]+x[2]+x[3] == oParam:CurrentNodeId } )
//Local aNos[nPosNo][1]	:= aScan(aNos, {|x| x[6] == AllTrim(oParam:GetCargo()) } )
Local nPosNo	:= aScan(aNos, {|x| x[6] == AllTrim(oParam:GetCargo()) } )

Default lViewAll	:= .F.

If nPosNo > 0// .AND. !lDbClick
	LJMsgRun("Buscando dados...","Aguarde...",{|| xRetTree(@oParam,@aNos,AllTrim(oParam:GetCargo()),@cSeqTree) })
EndIf

IF !lViewAll .AND. lDbClick .AND. nPosNo > 0 .and. AllTrim(aNos[nPosNo][5]) == "FILHO"
	ZZM->(DbSetOrder(2))//ZZM_FILIAL+ZZM_CODSIT+ZZM_CODMAE+ZZM_CODCAT
	If ZZM->(DbSeek( xFilial("ZZM")+aNos[nPosNo][1]+aNos[nPosNo][2]+aNos[nPosNo][3] ))
		
		If !xVldExist(aNos,nPosNo)
			Return .F.
		EndIf
		
		lRet := U_GENSITEC()
		
		/*
		lRet	:= .T.
		xPutCodSit()
		 
		ZZM->(DbSetOrder(1))//ZZM_FILIAL+ZZM_CODSIT+ZZM_CODCAT+ZZM_CODMAE
		ZZM->(DbSeek( xFilial("ZZM")+aNos[nPosNo][1]+aNos[nPosNo][3]+aNos[nPosNo][2] ))
		cDesc	:= AllTrim(ZZM->ZZM_CODCAT) + " : " + Capital(AllTrim(ZZM->ZZM_DESCAT))
				 
		While ZZM->(!EOF()) .AND. ZZM->ZZM_CODSIT == aNos[nPosNo][1]
			
			If Empty(ZZM->ZZM_CODMAE)
				ZZO->(DbSetOrder(1))				
				ZZO->(DbSeek( xFilial("ZZO")+ZZM->ZZM_CODSIT ))
				cDesc := AllTrim(ZZM->ZZM_CODSIT) + " : " + Capital(AllTrim(ZZO->ZZO_DESC))+" >>> "+cDesc
				Exit
			Else
				ZZM->(DbSeek( xFilial("ZZM")+ZZM->ZZM_CODSIT+ZZM->ZZM_CODMAE ))
				cDesc := AllTrim(ZZM->ZZM_CODCAT) + " : " + Capital(AllTrim(ZZM->ZZM_DESCAT))+" >>> "+cDesc
			EndIf
		EndDo
		
		xPutDesc(cDesc)		
		
		ZZM->(DbSetOrder(2))//ZZM_FILIAL+ZZM_CODSIT+ZZM_CODMAE+ZZM_CODCAT
		ZZM->(DbSeek( xFilial("ZZM")+aNos[nPosNo][1]+aNos[nPosNo][2]+aNos[nPosNo][3] ))
		*/
	Else
		MsgStop("Falha ao identificar a categoria, tente novamente, caso o problema continue contate a TI!")
	EndIf
EndIf

Return lRet

Static Function xVldExist(aNos,nPosNo)
	
Local lRet	:= .T.

IF ISINCALLSTACK( "U_GENCAZZL" )
	IF aScan(oDados:aCols, {|x| x[GdFieldPos("ZZN_CODSIT",oDados:aHeader)] == aNos[nPosNo][1] .AND. x[GdFieldPos("ZZN_CODCAT",oDados:aHeader)] == aNos[nPosNo][3] } ) > 0
		MsgStop("Categoria jÃ¡ informada!")
		Return .F.
	ENDIF
ENDIF

Return lRet

Static Function xPutCodSit()

IF ISINCALLSTACK( "U_GENCAZZL" )
	GdFieldPut( "ZZN_CODSIT" , ZZM->ZZM_CODSIT , oDados:nAt , oDados:aHeader , oDados:aCols , .F. )
ENDIF	

IF ISINCALLSTACK( "U_GENA103" )
	
ENDIF	

Return nil

Static Function xPutDesc(cDesc)

Local oModel
Local oModelZZN
Local nQtdLin
Local oViewAtv

IF ISINCALLSTACK( "U_GENCAZZL" )
	GdFieldPut( "ZZN_DESC" , cDesc , oDados:nAt , oDados:aHeader , oDados:aCols , .F. )
ENDIF

Return nil

User Function GENSITEC()

Local lRet		:= .F.
Local nLenAux	:= 0
Local aLinDef	:= {}
Local oModel	:= nil
Local oModelZZN := nil
Local nQtdLin	:= nil
Local oView		:= nil
Local lZZL		:= ISINCALLSTACK( "U_GENCAZZL" )
Local lZZE		:= ISINCALLSTACK( "U_GENA103" )
Local aErro		:= {}
Local nAtBkp	:= 0
IF lZZL
	nAtBkp	:= oDados:nAt
	aLinDef	:= aClone(GdRmkaCols(     oDados:aHeader	,;     //Array com a Estrutura para criacao do aCols
										.F.          	,;     //Estado do Elemento de Delecao no aCols
										.T.          	,;     //Se existe o Elemento de Delecao
										.F.           	)[1])     //Se deve carregar os inicializadores padroes
ENDIF

IF lZZE
	oView		:= FWViewActive()
	oModel		:= FWModelActive()
	oModelZZN 	:= oModel:GetModel( 'ZZN_GRID' )
	nQtdLin		:= oModelZZN:Length()
ENDIF

IF Select("TMP_ZZM") > 0
	TMP_ZZM->(DbCloseArea())
ENDIF

BEGINSQL ALIAS "TMP_ZZM"	
	SELECT ZZM_CODSIT,ZZM_CODCAT,ZZM_CODMAE,GET_TREE_DISC_OLD(ZZM_CODCAT,ZZM_CODSIT,TRIM(ZZO_DESC)||' : '||ZZO_COD||' > ') DESCRI
	FROM %Table:ZZM% ZZM
	JOIN %Table:ZZO% ZZO
	ON ZZO_FILIAL = %xFilial:ZZO%
	AND ZZO_COD = ZZM_CODSIT
	AND ZZO.%NotDel%
	WHERE ZZM_FILIAL = %xFilial:ZZM%
	AND ZZM.%NotDel%
	AND ZZM.ZZM_CODSIT = %Exp:ZZM->ZZM_CODSIT%
	AND ZZM.ZZM_CODOLD = %Exp:ZZM->ZZM_CODOLD%
	AND NOT EXISTS(
		SELECT 1 FROM %Table:ZZM% FILHO
		WHERE FILHO.ZZM_FILIAL = %xFilial:ZZM%
		AND FILHO.ZZM_CODSIT = ZZM.ZZM_CODSIT
		AND FILHO.ZZM_CODMAE = ZZM.ZZM_CODCAT 
		AND FILHO.%NotDel%
	)
	ORDER BY 4
ENDSQL

While TMP_ZZM->(!EOF())

	IF lZZL

		lRet:= .T.
		IF aScan(oDados:aCols, {|x| x[GdFieldPos("ZZN_CODCAT",oDados:aHeader)] == TMP_ZZM->ZZM_CODCAT } ) <> 0
			TMP_ZZM->(DbSkip())
			Loop
		ENDIF

		nLenAux := aScan(oDados:aCols, {|x| Empty(x[GdFieldPos("ZZN_CODCAT",oDados:aHeader)]) } )

		IF nLenAux == 0 .OR. GdDeleted( nLenAux , oDados:aHeader , oDados:aCols )
			Aadd(oDados:aCols, aClone(aLinDef) )
			nLenAux := Len(oDados:aCols)
		ENDIF
		oDados:aCols[nLenAux][GdFieldPos("ZZN_CODSIT",oDados:aHeader)]	:= TMP_ZZM->ZZM_CODSIT
		oDados:aCols[nLenAux][GdFieldPos("ZZN_CODCAT",oDados:aHeader)]	:= TMP_ZZM->ZZM_CODCAT
		oDados:aCols[nLenAux][GdFieldPos("ZZN_DESC",oDados:aHeader)]	:= TMP_ZZM->DESCRI		

	ELSEIF lZZE
		aErro		:= {}
		oModel:GetModel('ZZN_GRID'):SetNoInsertLine(.F.)
		oModel:GetModel('ZZN_GRID'):SetNoUpdateLine(.F.)
		If !Empty(oModelZZN:GetValue("ZZN_CODCAT",nQtdLin))
			If oModelZZN:AddLine() == (nQtdLin+1)
				nQtdLin++
			Else
				MsgStop("Não foi possível armazenar a classificação, por favor, tente novamente!")
				Exit
			EndIf	
		EndIf

		oModelZZN:LoadValue("ZZN_CODCAT", TMP_ZZM->ZZM_CODCAT )
		oModelZZN:LoadValue("ZZN_CODSIT", TMP_ZZM->ZZM_CODSIT)
		oModelZZN:LoadValue("ZZN_DESC"	, AllTrim(TMP_ZZM->DESCRI))
		IF oModelZZN:VldData()
			lRet:= .T.
		ELSE
			lRet:= .F.
			aErro	:= oModel:GetErrorMessage()
			AutoGrLog( "Id do formulário de origem:" + ' [' + AllToChar( aErro[1] ) +']' )
			AutoGrLog( "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) +']' )
			AutoGrLog( "Id do formulário de erro: " + ' [' + AllToChar( aErro[3] ) +']' )
			AutoGrLog( "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) +']' )
			AutoGrLog( "Id do erro: " + ' [' + AllToChar( aErro[5] ) +']' )
			MostraErro()
		EndIf
		oModel:GetModel('ZZN_GRID'):SetNoInsertLine(.T.)
		oModel:GetModel('ZZN_GRID'):SetNoUpdateLine(.T.)
		oView:Refresh("ZZN_GRID")
		IF Len(aErro) > 0
			Exit
		ENDIF
	ENDIF	

	TMP_ZZM->(DbSkip())
EndDo

TMP_ZZM->(DbCloseArea())

IF lZZL
	oDados:nAt	:= nAtBkp
ENDIF	

Return lRet
