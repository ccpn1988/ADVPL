#INCLUDE "Totvs.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#include "Fileio.ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEditPanel.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#include "apwebex.ch"


// DireÁıes disponÌvels para o par‚metro nDirection do construtor e da respectiva propriedade
#define LAYOUT_LINEAR_L2R 0 // LEFT TO RIGHT
#define LAYOUT_LINEAR_R2L 1 // RIGHT TO LEFT
#define LAYOUT_LINEAR_T2B 2 // TOP TO BOTTOM
#define LAYOUT_LINEAR_B2T 3 // BOTTOM TO TOP
 
// DefiniÁıes de alinhamento especÌficas para o par‚metro nAlign do mÈtodo addInLayout
#define LAYOUT_ALIGN_LEFT     1
#define LAYOUT_ALIGN_RIGHT    2
#define LAYOUT_ALIGN_HCENTER  4
#define LAYOUT_ALIGN_TOP      32
#define LAYOUT_ALIGN_BOTTOM   64
#define LAYOUT_ALIGN_VCENTER  128

//#Define ENTER Chr(13)+Chr(10)

//#DEFINE CSSTST	"QLineEdit { background-color: yellow }
//#DEFINE CSSTSTB	"TGet { background-color: yellow }

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GENCAZZL  ∫Autor  ≥Cleuto e Arthur Lima∫ Data ≥  09/08/2019 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Cadastro do produtos                                        ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ GEN - Projeto Gest„o de Obras                              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function GENCAZZL()

//<--Local aFiles	:= {"totvstec.js","ckeditor.js","custom.js","HtmlEdiro.html","jquery.js","jquery-1.11.1.min.js","style.default.css"}
//<--Local _tempPath	:= GetTempPath()

Private oBrowse                                                               
Private lValid	:= .T.
Private aRotina	:= {}
/*
// Baixa arquivos do exemplo do RPO no diretorio temporario
for i := 1 to len(aFiles)
    cFile := _tempPath + aFiles[i]
    nHandle := fCreate(cFile)
    fWrite(nHandle, getApoRes(aFiles[i]))
    fClose(nHandle)
next i
*/
DbSelectArea("ZZL")
ZZL->(DbSetOrder(1))

//RpcSetEnv("99","01")

// DefiniÁ„o do Modelo de Dados
//ModelDef()

// DefiniÁ„o do Modelo de VisualizaÁ„o
//ViewDef()

// DefiniÁ„o das OperaÁıes disponÌveis.
aRotina := MenuDef()           

oBrowse := FWMBrowse():New()
oBrowse:SetOnlyFields( { 'ZZL_COD','ZZL_CODHIS','ZZL_TIPINC','ZZL_EDICAO','ZZL_DESC','ZZL_AUTOR','ZZL_SITOBR','ZZL_DESSIT','ZZL_IDTPPU','ZZL_DESPUB','ZZL_EMPRES','ZZL_DESEMP','ZZL_SELO','ZZL_DESSEL','ZZL_AREGER','ZZL_DESAGE','ZZL_PERCRM','ZZL_PSITEG','ZZL_CONSIG','ZZL_OFERT','ZZL_DTPUBL','ZZL_ISBN','ZZL_FEC','ZZL_IDMAE'} ) 
oBrowse:SetAlias('ZZL')
oBrowse:SetDescription("Cadastro de Produtos") 

// Legendas
oBrowse:AddLegend("ZZL_MSBLQL=='1'","RED"	,"Ativo")
oBrowse:AddLegend("ZZL_MSBLQL<>'1'","GREEN"	,"Desativado")

//Para mudar a cor da linha do browse
// Linha alternada
//obrowse:SetClrAlterRow(nCor RGB)

oBrowse:Activate()

Return NIL

Static Function MenuDef()
Local aRotina	:= {}
Local aReimp	:= {}

//aRotina := FWMVCMenu( "GENCAZZL" )
ADD OPTION aRotina TITLE 'Visualizar'		ACTION 'U_GENMNZZL("Visualizar",1)'		OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'			ACTION 'U_GENMNZZL("Incluir",3)' 		OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'			ACTION 'U_GENMNZZL("Alterar",4)' 		OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir' 			ACTION 'U_GENMNZZL("Excluir",5)' 		OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Atribuir ISBN'	ACTION 'U_GENMNZZL("Atribuir ISBN",10)'	OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Categorias Gen'	ACTION 'U_GENCAZZS()'					OPERATION 9 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar Produto'	ACTION 'U_GENA090(ZZL->ZZL_COD,1)'		OPERATION 9 ACCESS 0
ADD OPTION aRotina TITLE 'Replicar Campos'	ACTION 'U_GENA090(ZZL->ZZL_COD,2)'		OPERATION 9 ACCESS 0
ADD OPTION aRotina TITLE 'Ctr.Atividades'	ACTION 'U_GENCP001("1")'					OPERATION 9 ACCESS 0

ADD OPTION aReimp TITLE 'Visualizar'		ACTION 'U_GENA093(ZZL->(Recno()),2)'		OPERATION 2 ACCESS 0
ADD OPTION aReimp TITLE 'Incluir'			ACTION 'U_GENA093I(ZZL->(Recno()),4)' 		OPERATION 3 ACCESS 0
ADD OPTION aReimp TITLE 'Alterar'			ACTION 'U_GENA093(ZZL->(Recno()),4)' 		OPERATION 4 ACCESS 0
//ADD OPTION aReimp TITLE 'Excluir' 			ACTION 'U_GENA093(ZZL->(Recno()),5)' 		OPERATION 5 ACCESS 0


ADD OPTION aRotina TITLE 'Reimpress„o'		ACTION aReimp							OPERATION 4 ACCESS 0


Return aRotina

User Function GENMNZZL(xParam1,xParam2,xParam3,xParam4,xParam5,xParam6)

Local aGrp		:= UsrRetGrp( nil , RetCodUsr() )
Local cGrpUsr	:= ""

Private oVwHtml		:= nil
Private oWebEngine	:= nil
Private oWebChannel	:= nil
Private oSayHeader	:= nil
Private oTFSay		:= nil
Private oTButSave	:= nil
Private nOperAux	:= xParam2
Private nSitAux		:= xParam3
Private cDescAux	:= xParam4
Private cTpPubAux	:= xParam5
Private aAcesMemo	:= {}
Private lSitObr		:= .F.
Private cTpSit		:= ""//IIF( nOperAux == 9 , "101" , ( IIF( Empty(AllTrim(ZZL->ZZL_SITOBR)) .or. INCLUI , "000" , ZZL->ZZL_SITOBR ) ) )
Private oViewSit	:= ""
Private oVwImg		:= ""
Private aImpDir		:= {}
Private cCodCopy	:= xParam6
Private cSitObr		:= AllTrim(ZZL->ZZL_SITOBR)
Private cSitOld		:= AllTrim(ZZL->ZZL_PSITEG)

//oModel := FWLoadModel( 'GENCAZZL' )
//oModel:DeActivate()
If xParam2 == 1
	lOk := ( FWExecView(xParam1,'VIEWDEF.GENCAZZL', 1,,{ || .T. } ) == 0 )
ElseIf xParam2 == 10 .OR. xParam2 == 11
	lOk := ( FWExecView(xParam1,'VIEWDEF.GENCAZZL', 4,,{ || .T. } ) == 0 )
Else
		
	If xParam2 == 4
		aEval(aGrp,{|x| cGrpUsr+="'"+x+"'," }) 
		cGrpUsr := "%("+Left(cGrpUsr, Len(cGrpUsr)-1)+")%"
		If Select("TMP_SITOBR") > 0
			TMP_SITOBR->(DbCloseArea())
		EndIf
		BeginSql Alias "TMP_SITOBR"
			SELECT COUNT(*) QTD FROM %Table:ZZS% ZZS
			WHERE ZZS.ZZS_FILIAL = %xFilial:ZZS%
			AND ZZS_NUM = '01'
			AND ZZS_SITOBR = %Exp:AllTrim(ZZL->ZZL_SITOBR)%
			AND ZZS_TPPUB = %Exp:AllTrim(ZZL->ZZL_IDTPPU)%
			AND ZZS_GRPUSR IN %Exp:cGrpUsr%
			AND ZZS_CAMPO = 'ZZL_SITOBR'
			AND ZZS_ACESSO = '2'
			AND ZZS.%NotDel%
		EndSql
		TMP_SITOBR->(DbGoTop())
		If TMP_SITOBR->QTD > 0
			lSitObr	:= .T.
		EndIf
		TMP_SITOBR->(DbCloseArea())	
	EndIf
	
	lOk := ( FWExecView(xParam1,'VIEWDEF.GENCAZZL', xParam2,,{ || .T. } ) == 0 )
	
EndIF	
	
//oWebEngine:disconnect()

FreeObj(oVwHtml)
FreeObj(oWebEngine)
FreeObj(oWebChannel)

aEval(aImpDir,{|x| FErase(x) })

Return .T.

Static Function xIniPad()

Local xRet := ""

Return xRet

Static Function ModelDef()     

// Cria Modelo de Dados
Local oModel 

Local aGrp		:= UsrRetGrp( nil , RetCodUsr() )
Local cGrpUsr	:= ""
Local cFiledZZL	:= ""//"'ZZL_COD','ZZL_DESC','ZZL_SITOBR','ZZL_IDTPPU'" 
Local cTpObr	:= IIF( Empty(AllTrim(ZZL->ZZL_IDTPPU)) .or. INCLUI , "1" , ZZL->ZZL_IDTPPU )
//Local bLoad		:= {|oFieldModel, lCopy| loadField(oFieldModel, lCopy)}
Local bBloco	:= {|oModel| loadField(oModel)}
Local cAcessImg	:= ""
Local cAcesdist	:= ""
Local oStruZZI	:= nil

Do Case
	Case nOperAux == 1
		cTpSit	:= "500"
	Case nOperAux == 10
		cTpSit	:= "200"
	Case nOperAux == 11
		cTpSit	:= "101"
	Case nOperAux == 9
		cTpSit	:= nSitAux
	Case lSitObr .AND. nOperAux == 4
		cTpSit	:= xMudaSitObr(ZZL->ZZL_SITOBR)
	OtherWise
		cTpSit	:= IIF( Empty(AllTrim(ZZL->ZZL_SITOBR)) .or. INCLUI , "000" , ZZL->ZZL_SITOBR ) 
EndCase

// Cria Estruturas para serem usadas no Modelo de Dados
Static oStruZZL  := nil
Static oStruZZU  := nil

aEval(aGrp,{|x| cGrpUsr+="'"+x+"'," }) 
cGrpUsr := "%("+Left(cGrpUsr, Len(cGrpUsr)-1)+")%"

If Select("TMP_FIELD") > 0
	TMP_FIELD->(DbCloseArea())
EndIf

BeginSql Alias "TMP_FIELD"
	SELECT ZZS_CAMPO, ZZS_ACESSO, ZZS_OBRIGA,ZZR_IMAGEM,ZZR_DISTRI FROM %Table:ZZP% ZZP
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
	WHERE ZZP_FILIAL = %xFilial:ZZP%
	AND ZZP_NUM = '01'
	AND ZZR_SITOBR = %Exp:cTpSit%
	AND ZZP_IDTPPU = %Exp:cTpObr%
	AND ZZR_GRPUSR IN %Exp:cGrpUsr%
	AND ZZP.D_E_L_E_T_ <> '*'
EndSql

TMP_FIELD->(DbGoTop())

If TMP_FIELD->(EOF()) 
	TMP_FIELD->(DbCloseArea())
	oStruZZL  := FWFormStruct(1,'ZZL',{|cCampo| AllTrim(cCampo) $ "ZZL_FILIAL/ZZL_COD/ZZL_DESC/ZZL_IDTPPU/ZZL_DESPUB/ZZL_SITOBR/ZZL_DESSIT/ZZL_CODHIS"})
	oModel := MPFormModel():New('CAZZL_MD')
	oModel:AddFields('ZZL_FORM',/*cOwner*/,oStruZZL,/*blinePre*/,/*blinePos*/)
	// DefiniÁ„o da Chave Prim·ria
	oModel:SetPrimaryKey({"ZZL_FILIAL","ZZL_COD"}) 
	// DescriÁ„o do Modelo
	oModel:SetDescription("Cadastro de Produto") 
	// DescriÁ„o do Modelo
	oModel:GetModel('ZZL_FORM'):SetDescription("Produto")	  
	Return oModel
EndIf

While TMP_FIELD->(!EOF())	
	cFiledZZL+=AllTrim(TMP_FIELD->ZZS_CAMPO)+"/"
	TMP_FIELD->(DbSkip())
EndDo

oStruZZL  := FWFormStruct(1,'ZZL',{|cCampo| AllTrim(cCampo)+"/" $ cFiledZZL})
oStruZZU  := FWFormStruct(1,'ZZU',{|cCampo| AllTrim(cCampo) $ "ZZU_CODIMG/ZZU_FILE/ZZU_TIPO/ZZU_SIZE/ZZU_DTINC/ZZU_HRINCL/ZZU_B64/ZZU_MEMO/ZZU_PRINCI/ZZU_ALTIMG/ZZU_HRALT/ZZU_DTALT" })

If "ZZL_TIPINC" $ cFiledZZL .AND. "ZZL_CODHIS" $ cFiledZZL 
	oStruZZL:SetProperty( "ZZL_TIPINC", MODEL_FIELD_VALID , {|x| xGetField(x,"ZZL_TIPINC","ZZL_CODHIS") } )	
EndIf

If "ZZL_MAESN" $ cFiledZZL .AND. "ZZL_IDMAE" $ cFiledZZL 
	oStruZZL:SetProperty( "ZZL_MAESN", MODEL_FIELD_VALID , {|x| xGetField(x,"ZZL_MAESN","ZZL_IDMAE") } )	
EndIf

/*
aGtZZL := FwStruTrigger('ZZL_TIPINC','ZZL_IDMAE' ,'"TESTE"',.F.,'',0,'M->ZZL_TIPINC == "1"')
//aGtZZL := FwStruTrigger('ZZL_TIPINC','ZZL_IDMAE' ,'GrpRetName( M->ZZL_TIPINC )',.F.,'',0,'M->ZZL_TIPINC')
oStruZZL:AddTrigger(aGtZZL[1] ,aGtZZL[2] ,aGtZZL[3] ,aGtZZL[4] )
*/
	
TMP_FIELD->(DbGoTop())

While TMP_FIELD->(!EOF())

	If TMP_FIELD->ZZR_IMAGEM $ "A/V"
		cAcessImg	:= TMP_FIELD->ZZR_IMAGEM 
	EndIf

	If TMP_FIELD->ZZR_DISTRI $ "A/V/O"
		cAcesdist	:= TMP_FIELD->ZZR_DISTRI
	EndIf
	/* campo removido devido a ter de validar os campos memos
	IF AllTrim(TMP_FIELD->ZZS_CAMPO) $ "ZZL_HTML,ZZL_TEXTO,ZZL_SOBRA, ZZL_SAUTOR, ZZL_SSERIE, ZZL_SUMARI, ZZL_ERRATA, ZZL_DIFERE, ZZL_GENEIO, ZZL_AMOSTR,ZZL_MATSUP,ZZL_DEPOIM"
		TMP_FIELD->(DbSkip())
		Loop
	EndIF
	*/
	oStruZZL:SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MODEL_FIELD_OBRIGAT,TMP_FIELD->ZZS_OBRIGA == "1")
		
	TMP_FIELD->(DbSkip())
EndDo
//oModel := MPFormModel():New('CAZZL_MD', , , { |oModel| GENCAGRV( oModel ) } )
If !empty(cAcesdist)
	oStruZZI  := FWFormStruct(1,'ZZI',{|cCampo| AllTrim(cCampo) $ "ZZI_CODDIS/ZZI_NOME/ZZI_MSBLQL" })
	oStruZZI:SetProperty( "*", MODEL_FIELD_OBRIGAT, .f. )
	//oStruZZI:SetProperty( "ZZI_NOME", MODEL_FIELD_OBRIGAT, .f. )
	//oStruZZI:SetProperty( "ZZI_MSBLQL", MODEL_FIELD_OBRIGAT, .f. )	
EndIf

oModel := MPFormModel():New('CAZZL_MD' , ,{|oModel| VldTudOk(oModel,cAcessImg)  })

// Adiciona um Componente de Formul·rio ao modelo.
oModel:AddFields('ZZL_FORM',/*cOwner*/,oStruZZL,/*blinePre*/,/*blinePos*/)   
oModel:AddGrid( 'ZZU_GRID', 'ZZL_FORM', oStruZZU )

If !empty(cAcesdist)
	oModel:AddGrid('ZZI_GRID','ZZL_FORM',oStruZZI)   
EndIf	

// Necess·rio somente quando os dados n„o s„o carregados por query
//oModel:SetRelation( 'ZZL_FORM', { { 'ZZL_FILIAL', 'xFilial("ZZL")' }, { 'ZZL_COD', "ZZL_COD" } }, ZZL->( IndexKey( 1 ) ) )
oModel:SetRelation( 'ZZU_GRID', { { 'ZZU_FILIAL', 'xFilial("ZZU")' }, { 'ZZU_PRODUT', "ZZL_COD" } }, ZZU->( IndexKey( 1 ) ) )

If !empty(cAcesdist)
	oModel:SetRelation( 'ZZI_GRID', { { 'ZZI_FILIAL', 'xFilial("ZZI")' }, { 'ZZI_CODPRO', "ZZL_COD" } }, ZZI->( IndexKey( 1 ) ) )
	oModel:SetOptional('ZZI_GRID', "A" == cAcesdist)
EndIf	

// DefiniÁ„o da Chave Prim·ria
oModel:SetPrimaryKey({"ZZL_FILIAL","ZZL_COD"}) 

// DescriÁ„o do Modelo
If nOperAux == 3
	oModel:SetDescription("Cadastro de Produto")
ElseIf nOperAux == 9
	oModel:SetDescription(AllTrim(ZZL->ZZL_COD)+" : "+AllTrim(ZZL->ZZL_DESC)+" -> "+AllTrim(cDescAux))
Else 
	oModel:SetDescription(AllTrim(ZZL->ZZL_COD)+" : "+AllTrim(ZZL->ZZL_DESC))
EndIF	

// DescriÁ„o do Modelo
oModel:GetModel('ZZL_FORM'):SetDescription("Produto")
oModel:GetModel('ZZU_GRID'):SetDescription("Imagens")
oModel:GetModel('ZZU_GRID'):SetNoInsertLine(.T.)
oModel:GetModel('ZZU_GRID'):SetOptional( .T. )
If !empty(cAcesdist)
	oModel:GetModel('ZZI_GRID'):SetDescription("Distribuidores")
EndIf	

If cAcessImg <> "A"
	oModel:GetModel( 'ZZU_GRID' ):SetNoDeleteLine( .T. )
EndIf

//aGtZZL := FwStruTrigger('ZZL_TIPINC','ZZL_IDMAE' ,'u_xGetField("ZZL_COD")',.F.,'ZZL',0,'M->ZZL_TIPINC')
//aGtZZL := FwStruTrigger('ZZL_TIPINC','ZZL_IDMAE' ,'GrpRetName( M->ZZL_TIPINC )',.F.,'',0,'M->ZZL_TIPINC')

//oStruZZL:AddTrigger(aGtZZL[1] ,aGtZZL[2] ,aGtZZL[3] ,aGtZZL[4] )

//oStruZZL:SetValue( 'ZZL_HTML', codeContent )
//oStruZZL:SetValue( 'ZZL_TEXTO', codeContent )

//oModelTest:SetValue( 'ZZL_FORM', 'ZZL_SITOBR', cTpSit)
//oModelTest:SetValue( 'ZZL_SITOBR', cTpSit )
//oModelTest:SetValue( 'ZZL_TEXTO', 'teste' )

//IF nOperAux == 4
	oModel:SetActivate(bBloco)
//EndIf
	
Return oModel  

Static Function xGetField(oModel,cFldGat,cFldAtu)

Local lRet		:= .T.
Local oModelZZL := oModel:GetModel( 'ZZL_FORM' )
Local oView		:= FWViewActive()
//Local nPosVw	:= 0

If oModelZZL:HasField('ZZL_FORM', cFldGat) .AND. oModelZZL:HasField('ZZL_FORM', cFldAtu)
	//nPosVw := aScan(oView:aViews, {|x| oView:HasField(x[1], cFldAtu) } )
	If AllTrim(oModel:GetValue(cFldGat)) == "1" .AND. ( ( Empty(oModel:GetValue(cFldAtu)) .AND. "ZZL_CODHIS" $ cFldAtu ) .OR. "ZZL_IDMAE" $ cFldAtu )				
		//oModel:SetValue('ZZL_CODHIS', AllTrim(oModel:GetValue('ZZL_COD')))
		oModel:LoadValue(cFldAtu, AllTrim(oModel:GetValue('ZZL_COD')))
		aEval(oView:aViews,{|x| oView:Refresh(x[1]) })
	Else
		oModel:LoadValue(cFldAtu, " ")		
		aEval(oView:aViews,{|x| oView:Refresh(x[1]) })		
	EndIf
EndIf

Return lRet

Static Function VldTudOk(oModel,cAcessImg) 

Local lRet		:= .T.
Local oModelZZL := oModel:GetModel( 'ZZL_FORM' )
Local oModelZZU	:= oModel:GetModel( 'ZZU_GRID' )
//Local oModelZZI	:= oModel:GetModel( 'ZZI_GRID' )
Local nLenght	:= oModelZZU:Length()
Local nAuxFor	:= 0
Local cObraProd	:= ""
Local cOriZZN	:= PadR("GENCAZZL",TamSX3("ZZN_ORIGEM")[1])

If oModel:HasField('ZZL_FORM', 'ZZL_TIPINC') .AND. oModel:HasField('ZZL_FORM', 'ZZL_CODHIS')
	If AllTrim(oModelZZL:GetValue("ZZL_TIPINC")) == "2" .AND. Empty(oModelZZL:GetValue('ZZL_CODHIS'))		
		oModel:GetModel():SetErrorMessage('ZZL_FORM', "ZZL_CODHIS" , 'ZZL_FORM' , 'ZZL_CODHIS' , "Erro", 'Campo Obrigatorio!', "Quando '"+TitSX3("ZZL_TIPINC")[1]+"' igual 'Nova EdiÁ„o' campo '"+AllTrim(TitSX3("ZZL_CODHIS")[1])+"' deve ser preenchido!")
		lRet := .F.
	EndIf
EndIf

If lRet .AND. oModel:HasField('ZZL_FORM', 'ZZL_SITOBR')
	
	If nOperAux == 3
		If Select("TMP_VLDPRO") > 0
			TMP_VLDPRO->(DbCloseArea())
		EndIf
		
		BeginSql Alias "TMP_VLDPRO"
			SELECT ZZL_COD, ZZL_DESC,ZZL_ISBN, ZZL_IDTPPU, ZZL_SITOBR, ZZL_CEME, ZZL_EDICAO 
			FROM %Table:ZZL% ZZL
			WHERE ZZL_FILIAL = %xFilial:ZZL%
			AND ZZL_CODHIS = %Exp:AllTrim(oModelZZL:GetValue("ZZL_CODHIS"))%
			AND ZZL.ZZL_SITOBR IN ('109','000')
			AND trim(ZZL.ZZL_IDTPPU) IN ('1',%Exp:AllTrim(oModelZZL:GetValue("ZZL_IDTPPU"))%)
			AND trim(ZZL_EDICAO) <> %Exp:AllTrim(oModelZZL:GetValue("ZZL_EDICAO"))%
			AND ZZL.%NotDel%
		EndSql
		
		TMP_VLDPRO->(DbGoTop())
		If TMP_VLDPRO->(!EOF())
			While TMP_VLDPRO->(!EOF())
				cObraProd+= "Cod.:"+AllTrim(TMP_VLDPRO->ZZL_COD)+", Edi.: "+AllTrim(TMP_VLDPRO->ZZL_EDICAO)+", Tit.: "+AllTrim(TMP_VLDPRO->ZZL_DESC)
				TMP_VLDPRO->(DbSkip())
			EndDo
			TMP_VLDPRO->(DbCloseArea())
			//xMagHelpFis("Produto em ProduÁ„o","Foram identificadas as obras a seguir ainda em produÁ„o para o cÛdigo historico informado!"+chr(13)+chr(10)+"N„o È permitido a inclus„o de uma nova ediÁ„o quando existe ediÁ„o anterior em produÁ„o!",;
			//"Verifique as obras a seguir:"+Chr(13)+Chr(10)+cObraProd)
			oModel:GetModel():SetErrorMessage('ZZL_FORM', "ZZL_CODHIS" , 'ZZL_FORM' , 'ZZL_CODHIS' , "Erro", "Produto em ProduÁ„o", "Foram identificadas as obras a seguir ainda em produÁ„o para o cÛdigo historico informado!"+chr(13)+chr(10)+"N„o È permitido a inclus„o de uma nova ediÁ„o quando existe ediÁ„o anterior em produÁ„o!"+;
			"Verifique as obras a seguir:"+Chr(13)+Chr(10)+cObraProd)
			
			Return .F.
		EndIf
		TMP_VLDPRO->(DbCloseArea())
		
	EndIf

	If lRet .AND. AllTrim(oModelZZL:GetValue("ZZL_SITOBR")) == "109" .AND. "A" $ cAcessImg
		lRet := .F.
		For nAuxFor := 1 To nLenght
			oModelZZU:SetLine(nAuxFor)
			If AllTrim(oModelZZU:GetValue("ZZU_PRINCI")) == "1"
				lRet := .T.
				Exit
			EndIf
		Next		

		If !lRet
			oModel:GetModel():SetErrorMessage('ZZU_GRID', "ZZU_CODIMG" , 'ZZU_GRID' , 'ZZU_CODIMG' , "Erro", 'Imagem principal Obrigatoria!', "N„o foi identificada nenhuma imagem principal para este produto o que inviabiliza sua ativaÁ„o uma vez que o mesmo est· com permite 'Site Gen' como 'Sim' ou permite 'CRM' como Sim''!")
		EndIf
	EndIf

	/*
	
	validaÁıes para ativaÁ„o
	
	*/	
	If lRet .AND. AllTrim(oModelZZL:GetValue("ZZL_SITOBR")) $ "101#105#110"

		If !oModel:HasField('ZZL_FORM', 'ZZL_PSITEG')
			oModel:GetModel():SetErrorMessage('ZZL_FORM', "ZZL_PSITEG" , 'ZZL_FORM' , 'ZZL_PSITEG' , "Erro", 'Permite Site gen!', "Campo permite site Gen n„o localizado, vocÍ precisa de acesso a este campo para ativar a obra!")
			lRet := .F.
			Return .F.
		EndIf
	
		If !oModel:HasField('ZZL_FORM', 'ZZL_PERCRM')
			oModel:GetModel():SetErrorMessage('ZZL_FORM', "ZZL_PERCRM" , 'ZZL_FORM' , 'ZZL_PERCRM' , "Erro", 'Permite CRM!', "Campo permite CRM n„o localizado, vocÍ precisa de acesso a este campo para ativar a obra!")
			lRet := .F.
			Return .F.
		EndIf
		
		If ( AllTrim(oModelZZL:GetValue("ZZL_PSITEG")) == "1" .OR. AllTrim(oModelZZL:GetValue("ZZL_PERCRM")) == "1" )
			lRet := .F.
			For nAuxFor := 1 To nLenght
				oModelZZU:SetLine(nAuxFor)
				If AllTrim(oModelZZU:GetValue("ZZU_PRINCI")) == "1" .AND. oModelZZU:GetValue("ZZU_SIZE") > 0
					lRet := .T.
					Exit
				EndIf
			Next
		EndIf

		If !lRet
			oModel:GetModel():SetErrorMessage('ZZU_GRID', "ZZU_CODIMG" , 'ZZU_GRID' , 'ZZU_CODIMG' , "Erro", 'Imagem principal Obrigatoria!', "N„o foi identificada nenhuma imagem principal para este produto o que inviabiliza sua ativaÁ„o uma vez que o mesmo est· com permite 'Site Gen' como 'Sim' ou permite 'CRM' como Sim''!")
		EndIf
	
		If lRet
			//ZZN_FILIAL+ZZN_ORIGEM+ZZN_PRODUT+ZZN_CODSIT+ZZN_CODCAT
			ZZN->(DbSetOrder(1))
			If AllTrim(oModelZZL:GetValue("ZZL_PSITEG")) == "1"
				IF !ZZN->(DbSeek( xFilial("ZZN")+cOriZZN+oModelZZL:GetValue("ZZL_COD")+"001" ))
					lRet := .F.
					oModel:GetModel():SetErrorMessage('ZZL_FORM', "ZZL_PSITEG" , 'ZZL_FORM' , 'ZZL_PSITEG' , "Erro", 'Categoria Site Gen!', "N„o localizada informaÁ„o categoria 'Site Gen' e obra com 'Site Gen' igual a 'Sim'")
				EndIf
			EndIf
			If AllTrim(oModelZZL:GetValue("ZZL_PERCRM")) == "1"
				IF !ZZN->(DbSeek( xFilial("ZZN")+cOriZZN+oModelZZL:GetValue("ZZL_COD")+"002" ))
					lRet := .F.
					oModel:GetModel():SetErrorMessage('ZZL_FORM', "ZZL_PERCRM" , 'ZZL_FORM' , 'ZZL_PERCRM' , "Erro", 'Categoria CRM!', "N„o localizada informaÁ„o categoria 'CRM gen' e obra com 'CRM gen' igual a 'Sim'")
				EndIf
			EndIf
		EndIf
							
	EndIf
EndIf

Return lRet	

Static Function loadField(oFieldModel)
Local oView		:= FWViewActive()
Local nAuxVw	:= 0
Local nAuxFd	:= 0
Local nAuxGp	:= 0
Local aCodDesc	:= {}
//Local oViewZZL	:= oView:GetModelStruct(cViewSit)//oView:getModel(cViewSit)//oView:GetModel( cViewSit )
//Local aLoad 	:= {}
//Local oModel	:= FWModelActive()
//Local oModelZZL := oModel:GetModel( 'ZZL_FORM' )
//CADASTRO INICIAL              
If oFieldModel:GetOperation() == 3 .AND. nOperAux == 3 .AND. cTpSit == "000" 
	oFieldModel:LoadValue( 'ZZL_FORM', 'ZZL_SITOBR', cTpSit )
	oFieldModel:LoadValue( 'ZZL_FORM', 'ZZL_DESSIT', "CADASTRO INICIAL" )		
EndIF

If oFieldModel:GetOperation() == 4 .AND. nOperAux == 4 .AND. AllTrim(cTpSit) == "101" 
	If Empty(oFieldModel:GetValue('ZZL_FORM',"ZZL_DTPUBL"))
		oFieldModel:LoadValue( 'ZZL_FORM', 'ZZL_DTPUBL', DDataBase )
	EndIf	
EndIF

If nOperAux == 9 
	oFieldModel:LoadValue( 'ZZL_FORM', 'ZZL_IDTPPU', AllTrim(cTpPubAux) )
	oFieldModel:LoadValue( 'ZZL_FORM', 'ZZL_DESPUB', LEFT(AllTrim(POSICIONE("ZZT",1,XFILIAL("ZZT")+cTpPubAux,"ZZT_DESC")),30))		
	oFieldModel:LoadValue( 'ZZL_FORM', 'ZZL_SITOBR', "000" )
	oFieldModel:LoadValue( 'ZZL_FORM', 'ZZL_DESSIT', "CADASTRO INICIAL" )
	
	If oFieldModel:HasField('ZZL_FORM', 'ZZL_CODHIS') .AND. oFieldModel:GetValue('ZZL_FORM',"ZZL_TIPINC") == "1"
		oFieldModel:LoadValue( 'ZZL_FORM', 'ZZL_CODHIS', oFieldModel:GetValue('ZZL_FORM',"ZZL_COD") )		
		oViewSit:SetProperty( "ZZL_CODHIS", MVC_VIEW_CANCHANGE,.T.)
	ElseIf oFieldModel:HasField('ZZL_FORM', 'ZZL_CODHIS') .AND. oFieldModel:GetValue('ZZL_FORM',"ZZL_TIPINC") == "2"	
		oFieldModel:LoadValue( 'ZZL_FORM', 'ZZL_CODHIS', "        " )		
		oViewSit:SetProperty( "ZZL_CODHIS", MVC_VIEW_CANCHANGE,.T.)
	EndIf
	
	If oFieldModel:HasField('ZZL_FORM', 'ZZL_CLASSE')	
		aCodDesc 	:= Separa(GetMv("GEN_CODDES",.f.,"14:501,15:502"),",")
		nPosCdDesc	:= aScan(aCodDesc, {|x| Separa(x,":")[1] == AllTrim(cTpPubAux) } )
		If nPosCdDesc > 0
			oFieldModel:LoadValue( 'ZZL_FORM', 'ZZL_CLASSE', Separa(aCodDesc[nPosCdDesc],":")[2] )
			oFieldModel:LoadValue( 'ZZL_FORM', 'ZZL_DESDES', AllTrim(Left(Posicione("ZZV",1,xFilial("ZZV")+Separa(aCodDesc[nPosCdDesc],":")[2],"ZZV_DESC"),50)) )
		EndIf
	EndIf

	//oFieldModel:LoadValue( 'ZZL_FORM', 'ZZL_IDTPPU', ' ' )
EndIF

If oFieldModel:GetOperation() == 4 .AND. nOperAux == 4
	If cTpSit <> oFieldModel:GetValue("ZZL_FORM", "ZZL_SITOBR") .AND. !Empty(cTpSit)
		oFieldModel:LoadValue( 'ZZL_FORM', 'ZZL_SITOBR', cTpSit )
		oFieldModel:LoadValue( 'ZZL_FORM', 'ZZL_DESSIT', POSICIONE("SZ4",1,XFILIAL("SZ4")+cTpSit,"Z4_DESC")                      )
		oViewSit:SetProperty( "ZZL_SITOBR", MVC_VIEW_CANCHANGE,.F.)
		//oViewSit:SetProperty( "ZZL_DESSIT", MVC_VIEW_CANCHANGE,.F.)	
	EndIf
EndIf

//oView:AFOLDERS[1][4][1][3]:OPANELSCROLL:ADIALOGS[1]:oWnd:oWnd:NCLRPANE	:= 16250871

If AttIsMemberOf( oView, "AFOLDERS" )
	For nAuxVw := 1 To len(oView:AFOLDERS)
		If Len(oView:AFOLDERS[nAuxVw]) >= 4
			If ValType(oView:AFOLDERS[nAuxVw][4]) == "A"
				For nAuxFd := 1 To Len(oView:AFOLDERS[nAuxVw][4])
					If Len(oView:AFOLDERS[nAuxVw][4][nAuxFd]) >= 3
						If AttIsMemberOf( oView:AFOLDERS[nAuxVw][4][nAuxFd][3], "OPANELSCROLL" )
							IF AttIsMemberOf( oView:AFOLDERS[nAuxVw][4][nAuxFd][3]:OPANELSCROLL, "ADIALOGS" )
								For nAuxGp := 1 To Len(oView:AFOLDERS[nAuxVw][4][nAuxFd][3]:OPANELSCROLL:ADIALOGS)
									If AttIsMemberOf( oView:AFOLDERS[nAuxVw][4][nAuxFd][3]:OPANELSCROLL:ADIALOGS[nAuxGp],"oWnd",.t. )
										oView:AFOLDERS[nAuxVw][4][nAuxFd][3]:OPANELSCROLL:ADIALOGS[nAuxGp]:oWnd:NCLRPANE	:= 16250871
									EndIf
								Next
							EndIf
						EndIF
					EndIf
				Next 
			EndIF
		EndIf		
	Next
EndIf	


/*
If AttIsMemberOf( oView, "aViews" )
	For nAuxVw := 1 To len(oView:aViews)
		If Len(oView:aViews[nAuxVw]) >= 3
			If AttIsMemberOf( oView:aViews[nAuxVw][3], "aFolders" )
				For nAuxFd := 1 To Len(oView:aViews[nAuxVw][3]:aFolders)
					If AttIsMemberOf( oView:aViews[nAuxVw][3]:aFolders[nAuxFd], "aoGroups" )
						For nAuxGp := 1 To Len(oView:aViews[nAuxVw][3]:aFolders[nAuxFd]:aoGroups)
							If AttIsMemberOf( oView:aViews[nAuxVw][3]:aFolders[nAuxFd]:aoGroups[nAuxGp], "OFWEDITPANEL" )
								If ttIsMemberOf( oView:aViews[nAuxVw][3]:aFolders[nAuxFd]:aoGroups[nAuxGp]:OFWEDITPANEL, "oTPanel" )
									oView:aViews[nAuxVw][3]:aFolders[nAuxFd]:aoGroups[nAuxGp]:OFWEDITPANEL:oTPanel:NCLRPANE := 16250871
								EndIf	
							EndIF	
						Next
					EndIF
				Next	
			EndIf
		EndIf		
	Next
EndIf	
*/
//FWFldPut("ZZL_SITOBR", cTpSit, /*[ nLinha ]*/, oFieldModel, .T., .F.)
//oModel:GetModel( 'ZZL_FORM' ):Activate()
//oModel:Activate()
//oModel:LoadValue( 'ZZL_FORM', 'ZZL_SITOBR', cTpSit )
   
//aAdd(aLoad, Array()) //dados
//aAdd(aLoad, 1) //recno
   
Return nil
                                                       
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function ViewDef()

// Cria Estruturas para serem usadas na View
Local oStruZZL  := nil
Local oStruZZI  := nil

// Carrega o modelo de dados de um fonte MVC. No caso, carregamos deste fonte mesmo.
Local oModel := FWLoadModel('GENCAZZL')

// Cria o modelo da View
Local oView := FWFormView():New()

Local aGrp		:= UsrRetGrp( nil , RetCodUsr() )
Local cGrpUsr	:= ""
Local cFiledZZL	:= ""//"'ZZL_COD','ZZL_DESC','ZZL_SITOBR','ZZL_IDTPPU'"
Local cFiledZZL	:= ""//"'ZZL_COD','ZZL_DESC','ZZL_SITOBR','ZZL_IDTPPU'"
Local lMemo		:= .F.
Local cMemos	:= ""
//Local cTpSit	:= "" //IIF( nOperAux == 9 , "101" , ( IIF( Empty(AllTrim(ZZL->ZZL_SITOBR)) .or. INCLUI , "000" , ZZL->ZZL_SITOBR ) ) )
Local cTpObr	:= IIF( Empty(AllTrim(ZZL->ZZL_IDTPPU)) .or. INCLUI, "1" , ZZL->ZZL_IDTPPU )
Local nTFZZL	:= 0
Local nTFZZL	:= 0
Local aFldCp	:= {}
Local nAcesView	:= 0
Local lAcessImg	:= .F.
Local cAcessImg	:= ""
Local cAcesdis	:= ""
Local nFldAux	:= 0
Local nAuxFd	:= 0

IF nOperAux == 1
	cTpSit	:= "500"
ENDIF 

/*
Do Case
	Case nOperAux == 10
		cTpSit	:= "200"
	Case nOperAux == 11
		cTpSit	:= "101"
	Case nOperAux == 9
		cTpSit	:= "300"		
	OtherWise
		cTpSit	:= IIF( Empty(AllTrim(ZZL->ZZL_SITOBR)) .or. INCLUI , "000" , ZZL->ZZL_SITOBR ) 
EndCase
*/
aEval(aGrp,{|x| cGrpUsr+="'"+x+"'," }) 
cGrpUsr := "%("+Left(cGrpUsr, Len(cGrpUsr)-1)+")%"

If Select("TMP_FIELD") > 0
	TMP_FIELD->(DbCloseArea())
EndIf

BeginSql Alias "TMP_FIELD"
	SELECT ZZS_CAMPO, ZZS_ACESSO, ZZS_OBRIGA,X3_TAMANHO,ZZS_FOLDER,ZZC_DESC,X3_TIPO,ZZS_ORDEM,ZZR_IMAGEM,ZZS_PULA,ZZR_DISTRI FROM %Table:ZZP% ZZP
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
	AND ZZR_SITOBR = %Exp:cTpSit%
	AND ZZP_IDTPPU = %Exp:cTpObr%
	AND ZZR_GRPUSR IN %Exp:cGrpUsr%
	AND ZZP.D_E_L_E_T_ <> '*'
	ORDER BY ZZS_FOLDER,ZZS_CAMPO
EndSql
TMP_FIELD->(DbGoTop())

If TMP_FIELD->(EOF()) 
	TMP_FIELD->(DbCloseArea())
	oStruZZL  := FWFormStruct(2,'ZZL',{|cCampo| AllTrim(cCampo) $ "ZZL_FILIAL/ZZL_COD/ZZL_DESC/ZZL_IDTPPU/ZZL_DESPUB/ZZL_SITOBR/ZZL_DESSIT/ZZL_CODHIS"})
	oView:SetModel(oModel)
	oView:AddField('VIEW_ZZL', oStruZZL, 'ZZL_FORM')
	
	oStruZZL:SetProperty( "ZZL_COD", MVC_VIEW_CANCHANGE,.F.)
	oStruZZL:SetProperty( "ZZL_DESC", MVC_VIEW_CANCHANGE,.F.)
	oStruZZL:SetProperty( "ZZL_IDTPPU", MVC_VIEW_CANCHANGE,.F.)
	oStruZZL:SetProperty( "ZZL_DESPUB", MVC_VIEW_CANCHANGE,.F.)
	oStruZZL:SetProperty( "ZZL_SITOBR", MVC_VIEW_CANCHANGE,.F.)
	oStruZZL:SetProperty( "ZZL_DESSIT", MVC_VIEW_CANCHANGE,.F.)
	oStruZZL:SetProperty( "ZZL_CODHIS", MVC_VIEW_CANCHANGE,.F.)

	oStruZZL:SetProperty( "ZZL_COD", MVC_VIEW_ORDEM,1)
	oStruZZL:SetProperty( "ZZL_DESC", MVC_VIEW_ORDEM,2)
	oStruZZL:SetProperty( "ZZL_IDTPPU", MVC_VIEW_ORDEM,3)
	oStruZZL:SetProperty( "ZZL_DESPUB", MVC_VIEW_ORDEM,4)
	oStruZZL:SetProperty( "ZZL_SITOBR", MVC_VIEW_ORDEM,5)
	oStruZZL:SetProperty( "ZZL_DESSIT", MVC_VIEW_ORDEM,6)
	oStruZZL:SetProperty( "ZZL_CODHIS", MVC_VIEW_ORDEM,7)

	oStruZZL:SetProperty( "ZZL_COD", MVC_VIEW_INSERTLINE,.F.)
	oStruZZL:SetProperty( "ZZL_DESC", MVC_VIEW_INSERTLINE,.T.)
	oStruZZL:SetProperty( "ZZL_IDTPPU", MVC_VIEW_INSERTLINE,.F.)
	oStruZZL:SetProperty( "ZZL_DESPUB", MVC_VIEW_INSERTLINE,.T.)
	oStruZZL:SetProperty( "ZZL_SITOBR", MVC_VIEW_INSERTLINE,.F.)
	oStruZZL:SetProperty( "ZZL_DESSIT", MVC_VIEW_INSERTLINE,.T.)
	oStruZZL:SetProperty( "ZZL_CODHIS", MVC_VIEW_INSERTLINE,.F.)

	oView:CreateHorizontalBox( 'TOTAL', 100 )
	oView:SetOwnerView('VIEW_ZZL' ,'TOTAL')
	return oView
EndIf

While TMP_FIELD->(!EOF())
	
	If TMP_FIELD->ZZR_IMAGEM $ "A/V"
		lAcessImg	:= .T.
		cAcessImg	:= TMP_FIELD->ZZR_IMAGEM 
	EndIf

	If TMP_FIELD->ZZR_DISTRI $ "A/V/O"
		cAcesdis	:= TMP_FIELD->ZZR_DISTRI 
	EndIf

	If "ZZL_" $ TMP_FIELD->ZZS_CAMPO .AND. !(AllTrim(TMP_FIELD->ZZS_CAMPO) $ "ZZL_HTML,ZZL_TEXTO,ZZL_SOBRA, ZZL_SAUTOR, ZZL_SSERIE, ZZL_SUMARI, ZZL_ERRATA, ZZL_DIFERE, ZZL_GENEIO, ZZL_AMOSTR,ZZL_MATSUP,ZZL_DEPOIM")
		cFiledZZL+=AllTrim(TMP_FIELD->ZZS_CAMPO)+"/"
	EndIf	
	
	If AllTrim(TMP_FIELD->ZZS_CAMPO) $ "ZZL_HTML,ZZL_TEXTO,ZZL_SOBRA, ZZL_SAUTOR, ZZL_SSERIE, ZZL_SUMARI, ZZL_ERRATA, ZZL_DIFERE, ZZL_GENEIO, ZZL_AMOSTR,ZZL_MATSUP,ZZL_DEPOIM"
		lMemo	:= .T.
		cMemos+=TMP_FIELD->ZZS_CAMPO+"/"
		Aadd(aAcesMemo, { TMP_FIELD->ZZS_CAMPO , TMP_FIELD->ZZS_ACESSO , TMP_FIELD->ZZS_OBRIGA } )
	Else
		nPosFld := aScan(aFldCp, {|x| x[1] ==  TMP_FIELD->ZZS_FOLDER } )
		
		If nPosFld  == 0
			Aadd(aFldCp,{ TMP_FIELD->ZZS_FOLDER  , AllTrim(TMP_FIELD->ZZC_DESC) , 0 , 0 , "" , nil , nil , nil , nil })
			nPosFld := Len(aFldCp)
		EndIf
		
		aFldCp[nPosFld][5]+=AllTrim(TMP_FIELD->ZZS_CAMPO)+"/"						
	EndIf
	
	TMP_FIELD->(DbSkip())
EndDo
//cFiledZZL+="ZZL_HTML / ZZL_TEXTO /"
//oStruZZL  := FWFormStruct(2,'ZZL',{|cCampo| AllTrim(cCampo) $ cFiledZZL})
//oStruZZL  := FWFormStruct(2,'ZZL',{|cCampo| AllTrim(cCampo) $ cFiledZZL})

For nFldAux := 1 To Len(aFldCp)
	aFldCp[nFldAux][6] := "OBJ_ZZL_"+cValtoChar(nFldAux) 
	&(aFldCp[nFldAux][6]) := FWFormStruct(2,'ZZL',{|cCampo| AllTrim(cCampo)+"/" $ aFldCp[nFldAux][5]})
Next

If lMemo
	oStruMem  := FWFormStruct(2,'ZZL',{|cCampo| AllTrim(cCampo) $ cMemos })
	oStruMem:SetNoFolder()
EndIf

If lAcessImg
	oStruImg  := FWFormStruct(2,'ZZU',{|cCampo| AllTrim(cCampo) $ "ZZU_CODIMG/ZZU_FILE/ZZU_TIPO/ZZU_SIZE/ZZU_DTINC/ZZU_HRINCL/ZZU_B64/ZZU_MEMO/ZZU_PRINCI/ZZU_ALTIMG" })
	oStruImg:SetNoFolder()
EndIf

If !Empty(cAcesdis)
	oStruDis  := FWFormStruct(2,'ZZI',{|cCampo| AllTrim(cCampo) $ "ZZI_CODDIS/ZZI_NOME/ZZI_MSBLQL" })
	oStruDis:SetNoFolder()
EndIf	

// Definimos qual modelo ser· carregado nessa View
oView:SetModel(oModel)

// Adiciona os componentes visuais. Cada componente Est· relacionado ‡ um modelo de Estrutura de dados, definidos em ModelDef()
//oView:AddField('VIEW_ZZL', oStruZZL, 'ZZL_FORM')
//oView:AddField('VIEW_ZZL', oStruZZL, 'ZZL_FORM')

For nFldAux := 1 To Len(aFldCp)
	
	oView:AddField('VIEW_ZZL_'+aFldCp[nFldAux][1], &(aFldCp[nFldAux][6]), 'ZZL_FORM')
	aFldCp[nFldAux][8] := 'VIEW_ZZL_'+aFldCp[nFldAux][1]

	If "ZZL_SITOBR" $ AllTrim(aFldCp[nFldAux][5])
		oViewSit := &(aFldCp[nFldAux][6])
	EndIf
				
Next

If lMemo
	oView:AddField('VIEW_MEM', oStruMem, 'ZZL_FORM')
EndIf	
If lAcessImg
	oView:AddGrid('VIEW_ZZU', oStruImg, 'ZZU_GRID')
EndIf
If !Empty(cAcesdis)
	oView:AddGrid('VIEW_ZZI', oStruDis, 'ZZI_GRID')
EndIf

TMP_FIELD->(DbGoTop())

While TMP_FIELD->(!EOF())
	
	IF AllTrim(TMP_FIELD->ZZS_CAMPO) $ "ZZL_HTML,ZZL_TEXTO,ZZL_SOBRA, ZZL_SAUTOR, ZZL_SSERIE, ZZL_SUMARI, ZZL_ERRATA, ZZL_DIFERE, ZZL_GENEIO, ZZL_AMOSTR,ZZL_MATSUP,ZZL_DEPOIM"
		TMP_FIELD->(DbSkip())
		Loop
	EndIF
		
	//cFiledZZL+=TMP_FIELD->ZZS_CAMPO+"/"

	//MVC_VIEW_CANCHANGE
	//MODEL_FIELD_OBRIGAT

	nPosFld := aScan(aFldCp, {|x| x[1] ==  TMP_FIELD->ZZS_FOLDER } )
	
	//If nPosFld  == 0
	//	Aadd(aFldCp,{ TMP_FIELD->ZZS_FOLDER  , AllTrim(TMP_FIELD->X5_DESCRI) , 0 , 0  })
	//	nPosFld := Len(aFldCp)
	//EndIf
		
		aFldCp[nPosFld][3]+=TMP_FIELD->X3_TAMANHO+IIF( TMP_FIELD->X3_TIPO=="M",TMP_FIELD->X3_TAMANHO*2,0 )
		//nTFZZL+=TMP_FIELD->X3_TAMANHO
		//oStruZZL:SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MVC_VIEW_CANCHANGE,TMP_FIELD->ZZS_ACESSO == "2")
		//oStruZZL:SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MVC_VIEW_FOLDER_NUMBER,AllTrim(TMP_FIELD->ZZS_FOLDER))
		If "ZZL_SITOBR" $ AllTrim(TMP_FIELD->ZZS_CAMPO)
			&(aFldCp[nPosFld][6]):SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MVC_VIEW_CANCHANGE, .F. )
		Else
			&(aFldCp[nPosFld][6]):SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MVC_VIEW_CANCHANGE,TMP_FIELD->ZZS_ACESSO == "2")
		EndIf
		&(aFldCp[nPosFld][6]):SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MVC_VIEW_FOLDER_NUMBER,AllTrim(TMP_FIELD->ZZS_FOLDER))
		&(aFldCp[nPosFld][6]):SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MVC_VIEW_ORDEM,AllTrim(TMP_FIELD->ZZS_ORDEM))
		
		//If TMP_FIELD->ZZS_SIZE > 0
		//	&(aFldCp[nPosFld][6]):SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MVC_VIEW_WIDTH  , TMP_FIELD->ZZS_SIZE )
		//EndIF	
		//If TMP_FIELD->ZZS_PULA == "1"
			&(aFldCp[nPosFld][6]):SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MVC_VIEW_INSERTLINE , TMP_FIELD->ZZS_PULA == "1" )
		//EndIF				
	TMP_FIELD->(DbSkip())
EndDo

//&(aFldCp[nPosFld][6]):SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MVC_VIEW_ORDEM,AllTrim(TMP_FIELD->ZZS_ORDEM))

aFldCp := aSort(aFldCp,,,{|x,y| val(x[1]) < val(y[1])})

oView:CreateFolder( 'FOLDERS' )
For nAuxFd := 1 To Len(aFldCp)
	oView:AddSheet( 'FOLDERS', AllTrim(aFldCp[nAuxFd][1]), AllTrim(aFldCp[nAuxFd][2]) )
Next

If lMemo
	oView:AddSheet( 'FOLDERS', 'OBJ_HTML', 'Editor HTML' )
	oView:AddSheet( 'FOLDERS', 'OBJ_MEMO', 'Memos' )
EndIf
If lAcessImg
	oView:AddSheet( 'FOLDERS', 'OBJ_IMG', 'Imagens' )
EndIf		
If !Empty(cAcesdis)
	IF cAcesdis $ "A/O"
		oStruDis:SetProperty( "ZZI_CODDIS", MVC_VIEW_CANCHANGE, .T. )
		oStruDis:SetProperty( "ZZI_NOME", MVC_VIEW_CANCHANGE, .T. )
		oStruDis:SetProperty( "ZZI_MSBLQL", MVC_VIEW_CANCHANGE, .T. )
	ELSE
		oStruDis:SetProperty( "ZZI_CODDIS", MVC_VIEW_CANCHANGE, .F. )
		oStruDis:SetProperty( "ZZI_NOME", MVC_VIEW_CANCHANGE, .F. )
		oStruDis:SetProperty( "ZZI_MSBLQL", MVC_VIEW_CANCHANGE, .F. )		
	EndIf
	oView:AddSheet( 'FOLDERS', 'OBJ_DIS', 'Distribuidores' )
EndIf	

// Agora vamos criar 'box' para suportar os componentes. Box È uma descriÁ„o genÈrica para Window, Panel, etc
//oView:CreateHorizontalBox( 'SUPERIOR'	, (nTFZZL/(nTFZZL+nTFZZL))*100 ,,, 'FOLDERS', 'OBJ_OBRA') // ocupar 50% da tela
//oView:CreateHorizontalBox( 'CENTRO'		, (nTFZZL/(nTFZZL+nTFZZL))*100,,, 'FOLDERS', 'OBJ_OBRA') // ocupar 50% da tela
//oView:SetContinuousForm(.F.)

For nAuxFd := 1 To Len(aFldCp)
	oView:CreateHorizontalBox( 'SUP_'+aFldCp[nAuxFd][1]+"_H"	,100 /*100 * (aFldCp[nAuxFd][3]/(aFldCp[nAuxFd][3]+aFldCp[nAuxFd][4]))*100*/ ,,, 'FOLDERS', aFldCp[nAuxFd][1]) // ocupar 50% da tela
	oView:CreateVerticalBox( 'SUP_'+aFldCp[nAuxFd][1]	,100 ,'SUP_'+aFldCp[nAuxFd][1]+"_H",, 'FOLDERS', aFldCp[nAuxFd][1]) // ocupar 50% da tela
	//oView:CreateHorizontalBox( 'SUP_'+aFldCp[nAuxFd][1]	,100 ,'SUP_'+aFldCp[nAuxFd][1]+"_V",, 'FOLDERS', aFldCp[nAuxFd][1]) // ocupar 50% da tela
	
	oView:SetOwnerView(aFldCp[nAuxFd][8] ,'SUP_'+aFldCp[nAuxFd][1]	)
	oView:SetViewProperty( aFldCp[nAuxFd][8], "SETLAYOUT", { FF_LAYOUT_VERT_DESCR_TOP  , 3 } )	
	oView:SetViewProperty(aFldCp[nAuxFd][8], "SETCOLUMNSEPARATOR", {10})
Next

If lMemo	
	oView:CreateHorizontalBox( 'GERAL_HTML'	, 100,,, 'FOLDERS', 'OBJ_HTML' )
	//oView:CreateVerticalBox( 'GERAL_HTML', 100 , 'TESTE_HTML',.T., 'FOLDERS', 'OBJ_HTML' ) 
	
	oView:CreateHorizontalBox( 'GERAL_MEMO'	, 100,,, 'FOLDERS', 'OBJ_MEMO' )
EndIf

If lMemo
	oView:SetOwnerView('VIEW_MEM' ,'GERAL_MEMO')
	oView:AddOtherObject("OTHER_PANEL", {|oPanel| GENCADOT(oPanel,oModel:GetOperation())})
	oView:SetOwnerView("OTHER_PANEL",'GERAL_HTML')
EndIf	

If lAcessImg
	oView:CreateHorizontalBox( 'HBOX_IMG'	, 70,,, 'FOLDERS', 'OBJ_IMG' )
	oView:CreateHorizontalBox( 'CENT_IMG'	, 30,,, 'FOLDERS', 'OBJ_IMG' )
	
	oView:AddOtherObject("MENU_IMG", {|oPanel| MENUIMG(oPanel,cAcessImg)})
	
	oView:SetOwnerView('MENU_IMG' ,'HBOX_IMG')
	oView:SetOwnerView('VIEW_ZZU' ,'CENT_IMG')
	
	oView:EnableTitleView('VIEW_ZZU')	
EndIf

If !Empty(cAcesdis)
	oView:CreateHorizontalBox( 'GERAL_DIST'	, 100,,, 'FOLDERS', 'OBJ_DIS' )
	oView:SetOwnerView('VIEW_ZZI' ,'GERAL_DIST')
endIf

If Select("TMP_FIELD") > 0
	TMP_FIELD->(DbCloseArea())
EndIf

Return oView


Static Function GENCAST(oPanel)

Local oModel	:= FWModelActive()
Local oModelZZL := oModel:GetModel( 'ZZL_FORM' )
		
  	oVwHtml := tSimpleEditor():New(0, 0, oPanel, 260, 184)
	oVwHtml:TextFormat( 1 )
    oVwHtml:Load(oModelZZL:GetValue("ZZL_HTML"))
    oVwHtml:Align := CONTROL_ALIGN_ALLCLIENT

Return nil

Static Function COMP021BUT(oView)

Local oModel := FWModelActive()
Local oModelZZL := oModel:GetModel( 'ZZL_FORM' )

oModelZZL:SetValue("ZZL_HTML", "teste") // ALTERA CAMPO MEMO
oView:Refresh("VIEW_ZZL") // ATUALIZA«√O A SUBVIEW ONDE O CAMPO EST¡ CONTIDO
   		

Return nil

Static Function GENCABT(oPanel)

    @ 010, 010 BUTTON oButton1 PROMPT "Aplicar >>>" SIZE 020, 020 OF oPanel;
         ACTION {|| oWebEngine:runJavaScript("GetContents();") } PIXEL
    oButton1:Align := CONTROL_ALIGN_LEFT

    @ 010, 010 BUTTON oButton2 PROMPT "<<< Aplicar" SIZE 020, 020 OF oPanel;
         ACTION {|| RetHtml() } PIXEL
    oButton2:Align := CONTROL_ALIGN_LEFT    


    @ 010, 010 BUTTON oButton3 PROMPT "Testar HTML" SIZE 020, 020 OF oPanel;
         ACTION {|| xTeste() } PIXEL
    oButton3:Align := CONTROL_ALIGN_LEFT
        
Return nil

Static Function xTeste()

Local _tempPath	:= GetTempPath()
Local cHtmlTmp	:= GetNextAlias()
Local oModel	:= FWModelActive()
Local oView		:= FWViewActive()
Local oModelZZL := oModel:GetModel( 'ZZL_FORM' )
//Local cScript	:= "SetInofTextArea('"+Encode64(oModelZZL:GetValue("ZZL_HTML"))+"');"

MemoWrite(_tempPath+cHtmlTmp+".html",oModelZZL:GetValue("ZZL_HTML"))
ShellExecute("Open", _tempPath+cHtmlTmp+".html", "", _tempPath, 1 )

Return nil

Static Function RetHtml(cFieldMemo)

Local oModel	:= FWModelActive()
Local oView		:= FWViewActive()
Local oModelZZL := oModel:GetModel( 'ZZL_FORM' )
Local cScript	:= "SetInofTextArea('"+Encode64(oModelZZL:GetValue(cFieldMemo))+"');"
// oWebEngine:runJavaScript('var cTexto = '+"'"+oModelZZL:GetValue("ZZL_HTML")+"'"+"; SetInofTextArea(cTexto);")
//oWebChannel:advplToJs("html","")
//oWebEngine:runJavaScript('var cTexto = '+"'"+oModelZZL:GetValue("ZZL_HTML")+"'"+"; SetInofTextArea(cTexto);")

oWebEngine:runJavaScript(cScript)

//FreeObj(oModel)
//FreeObj(oView)
//FreeObj(oModelZZL)


Return nil


Static Function MENUIMG(oPanel,cAcessImg)

Local lOk		:= .F.
Local oLayTop	:= nil
Local oLayImg	:= nil
Local oTBut1 	:= nil  
Local oTBut2 	:= nil  
Local oTBut3 	:= nil
Local oTBut4 	:= nil
Local oTBut5 	:= nil
Local oTBut6 	:= nil
Local oTBut7 	:= nil
Local oTBut8 	:= nil
Local oBodyLyt 	:= nil
Local oLinBtSave:= nil
Local oLinBtSave:= nil
Local oTFSay 	:= nil
Local oSayHeader:= nil
Local oCenterPnl:= nil
Local cTexto := ""
Local aFiles := {} // O array receber· os nomes dos arquivos e do diretÛrio
Local aSizes := {} // O array receber· os tamanhos dos arquivos e do diretorio

  oLayTop:= tLinearLayout():New(oPanel,LAYOUT_LINEAR_B2T,CONTROL_ALIGN_LEFT,45,45)
  
  //oLayTop:SetColor(,CLR_GREEN)
  //oLayTop:addSpacer(1,10)//obj - 01 
  If cAcessImg $ "A/V"
  	oTBut1 := TButton():New( 0, 0, "Visualizar"		, oLayTop,{|| xViewImg()}, 20,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  EndIf
  
  If cAcessImg == "A"
  	oTBut2 := TButton():New( 0, 0, "Adicionar"		, oLayTop,{|| xAddImg() }, 20,15,,,.F.,.T.,.F.,,.F.,,,.F. )  	  
  //oTBut3 := TButton():New( 0, 0, "Excluir"			, oLayTop,{||  }, 20,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  	oTBut4 := TButton():New( 0, 0, "Img.Principal"	, oLayTop,{|| xImgPric() }, 20,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  EndIf
  
  //oTBut8:SetCss("QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }")

  If cAcessImg == "A"
  	oLayTop:AddInLayout(oTBut4,LAYOUT_ALIGN_TOP)//obj - 06  
  //oLayTop:AddInLayout(oTBut3,LAYOUT_ALIGN_TOP)//obj - 02
  //oLayTop:addSpacer(3,02)//obj - 03  
  	oLayTop:AddInLayout(oTBut2,LAYOUT_ALIGN_TOP)//obj - 04
  	//oLayTop:addSpacer(5,02)//obj - 05
  EndIf
  	
  If cAcessImg $ "A/V"
  	oLayTop:AddInLayout(oTBut1,LAYOUT_ALIGN_TOP)//obj - 06
  	//oLayTop:addSpacer(7,02)//obj - 07
  EndIf	
  
  
  oLayTop:addSpacer(7)//obj - 07
  
  // --------------------------------------------------------------------------------------------------------
  
  oLayImg:= tLinearLayout():New(oPanel,LAYOUT_LINEAR_L2R,CONTROL_ALIGN_ALLCLIENT,0,500)
  //oLayImg:addSpacer(1,25)//obj - 01 
  
  /*
  oSayQuest := TSay():New(0,0,{|| '<img src="data:image/png;base64,'+tGzip()+'" alt="preview">' },oLayImg,,,,,,.T.,,,1,1,,,,,,.T.)
  oSayQuest:SetCss("TSay{ qproperty-alignment: AlignCenter; background-color: #33b5e5; color: #ffffff; }")
  oLayImg:addInLayout(oSayQuest)
  */
  @00,00 MSPANEL oPntHtml PROMPT "" SIZE 500,500/*nMbrHeight*0.10*/  of oLayImg
  oPntHtml:Align := CONTROL_ALIGN_ALLCLIENT

	//<--oVwImg := tSimpleEditor():New(0, 0, oPntHtml,(oPntHtml:NCLIENTHEIGHT/2),(oPntHtml:NCLIENTWIDTH/2)-10)
	//oVwImg := FWSimpEdit():New(10, 10, (oPntHtml:NCLIENTHEIGHT/2),(oPntHtml:NCLIENTWIDTH/2)-10 , "", "", 1 , .F., .F., oPntHtml , .f.)
	//<--oVwImg:TextFormat( 1 )
	//<--oVwImg:lReadOnly := .T.
//	oVwImg:lPixel	:= .T.
	//oVwImg:Load('<div align="center"><img src="data:image/png;base64,'+tGzip()+'" alt="preview"></div>')
	//<--oVwImg:Align := CONTROL_ALIGN_ALLCLIENT

	//oLayImg:AddInLayout(oVwHtml)//obj - 02
	//oLayImg:AddInLayout(oPntHtml,LAYOUT_ALIGN_HCENTER,100)

    //oLayImg:addSpacer(3,25)//obj - 01

    oVwImg := TWebEngine():New(oPntHtml, 0, 0, (oPntHtml:NCLIENTHEIGHT/2),(oPntHtml:NCLIENTWIDTH/2)-10,, )
    //oVwImg:bLoadFinished := {|self,url| conout("Termino da carga do pagina: " + url) }
    //oVwImg:navigate("http://totvs.com.br")
    oVwImg:Align := CONTROL_ALIGN_ALLCLIENT
          
Return nil

Static Function tGzip()
Local cTexto := ""
Local aFiles := {} // O array receber· os nomes dos arquivos e do diretÛrio
Local aSizes := {} // O array receber· os tamanhos dos arquivos e do diretorio

ADir("C:\temp\gen.PNG", aFiles, aSizes)//Verifica o tamanho do arquivo, par‚metro exigido na FRead.

nHandle := fopen('C:\temp\gen.PNG' , FO_READWRITE + FO_SHARED )
cString := ""
FRead( nHandle, cString, aSizes[1] ) //Carrega na vari·vel cString, a string ASCII do arquivo.

//cTexto := Encode64(cString) //Converte o arquivo para BASE64

fclose(nHandle)
/*
//Cria uma cÛpia do arquivo utilizando cTexto em um processo inverso(Decode64) para validar a convers„o.    
nHandle := fcreate("C:\temp\gen.PNG")
FWrite(nHandle, Decode64(cTexto))
fclose(nHandle)
*/
Return Encode64(cString)

Static Function GENCADOT(oPanel,nAcesMod)

Local lOk		:= .F.
Local oLayTop	:= tLinearLayout():New(oPanel,LAYOUT_LINEAR_L2R,CONTROL_ALIGN_TOP,30,30)
Local oTBut1 	:= nil  
Local oTBut2 	:= nil  
Local oTBut3 	:= nil
Local oTBut4 	:= nil
Local oTBut5 	:= nil
Local oTBut6 	:= nil
Local oTBut7 	:= nil
Local oTBut8 	:= nil
Local oBodyLyt 	:= nil
Local oLinBtSave:= nil
Local oLinBtSave:= nil
Local oTFSay 	:= nil
Local oSayHeader:= nil
Local oCenterPnl:= nil
    
  oLayTop:addSpacer(1,10)//obj - 01 
      
  oTBut1 := TButton():New( 0, 0, "Sobre Obra"			, oLayTop,{|| RetHtml("ZZL_SOBRA"),oSayHeader:SetText( "<H1>Sobre Obra</H1>" ),oTButSave:SetCss("QPushButton{ background-color:rgb(255, 242, 0);}"),oTButSave:bAction := {|| oWebEngine:runJavaScript("GetContents('ZZL_SOBRA');"), oTButSave:SetCss("QPushButton{ background-color:rgb(34, 177, 76);}")},oTButSave:cCaption := "Salvar - Sobre Obra",oTButSave:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_SOBRA" .AND. x[2] == "2" } ) > 0 .and. nAcesMod <> 1			}, 50,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut1:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_SOBRA" } ) > 0 
    
  oTBut2 := TButton():New( 0, 0, "Sobre Autor"			, oLayTop,{|| RetHtml("ZZL_SAUTOR"),oSayHeader:SetText( "<H1>Sobre Autor</H1>" ),oTButSave:SetCss("QPushButton{ background-color:rgb(255, 242, 0);}"),oTButSave:bAction := {|| oWebEngine:runJavaScript("GetContents('ZZL_SAUTOR');"), oTButSave:SetCss("QPushButton{ background-color:rgb(34, 177, 76);}")},oTButSave:cCaption := "Salvar - Sobre Autor",oTButSave:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_SAUTOR" .AND. x[2] == "2"} ) > 0 .and. nAcesMod <> 1	 			}, 50,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut2:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_SAUTOR" } ) > 0
    
  oTBut3 := TButton():New( 0, 0, "Sobre a SÈrie"		, oLayTop,{|| RetHtml("ZZL_SSERIE"),oSayHeader:SetText( "<H1>Sobre a SÈrie</H1>" ),oTButSave:SetCss("QPushButton{ background-color:rgb(255, 242, 0);}"),oTButSave:bAction := {|| oWebEngine:runJavaScript("GetContents('ZZL_SSERIE');"), oTButSave:SetCss("QPushButton{ background-color:rgb(34, 177, 76);}")},oTButSave:cCaption := "Salvar - Sobre a SÈrie",oTButSave:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_SSERIE" .AND. x[2] == "2"} ) > 0 .and. nAcesMod <> 1	 		}, 50,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut3:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_SSERIE" } ) > 0
  
  oTBut4 := TButton():New( 0, 0, "Sum·rio"				, oLayTop,{|| RetHtml("ZZL_SUMARI"),oSayHeader:SetText( "<H1>Sum·rio</H1>" ),oTButSave:SetCss("QPushButton{ background-color:rgb(255, 242, 0);}") ,oTButSave:bAction := {|| oWebEngine:runJavaScript("GetContents('ZZL_SUMARI');"), oTButSave:SetCss("QPushButton{ background-color:rgb(34, 177, 76);}")},oTButSave:cCaption := "Salvar - Sum·rio",oTButSave:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_SUMARI" .AND. x[2] == "2"} ) > 0 .and. nAcesMod <> 1					}, 50,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut4:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_SUMARI" } ) > 0
  
  oTBut5 := TButton():New( 0, 0, "Errata"				, oLayTop,{|| RetHtml("ZZL_ERRATA"),oSayHeader:SetText( "<H1>Errata</H1>" ),oTButSave:SetCss("QPushButton{ background-color:rgb(255, 242, 0);}"),oTButSave:bAction := {|| oWebEngine:runJavaScript("GetContents('ZZL_ERRATA');"), oTButSave:SetCss("QPushButton{ background-color:rgb(34, 177, 76);}")},oTButSave:cCaption := "Salvar - Errata",oTButSave:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_ERRATA" .AND. x[2] == "2"}	 ) > 0  .and. nAcesMod <> 1				}, 50,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut5:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_ERRATA" } ) > 0
  
  oTBut6 := TButton():New( 0, 0, "Diferenciais"			, oLayTop,{|| RetHtml("ZZL_DIFERE"),oSayHeader:SetText( "<H1>Diferenciais</H1>" ),oTButSave:SetCss("QPushButton{ background-color:rgb(255, 242, 0);}"),oTButSave:bAction := {|| oWebEngine:runJavaScript("GetContents('ZZL_DIFERE');"), oTButSave:SetCss("QPushButton{ background-color:rgb(34, 177, 76);}")},oTButSave:cCaption := "Salvar - Diferenciais",oTButSave:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_DIFERE" .AND. x[2] == "2"}	 ) > 0  .and. nAcesMod <> 1		}, 50,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut6:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_DIFERE" } ) > 0
  
  //oTBut7 := TButton():New( 0, 0, "Genio"				, oLayTop,{|| RetHtml("ZZL_GENEIO"),oSayHeader:SetText( "<H1>Genio</H1>" ) ,oTButSave:bAction := {|| oWebEngine:runJavaScript("GetContents('ZZL_GENEIO');")},oTButSave:cCaption := "Salvar - Genio"	,oTButSave:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_GENEIO" .AND. x[2] == "2"}	 ) > 0			}, 50,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut8 := TButton():New( 0, 0, "Amostras"	, oLayTop,{|| RetHtml("ZZL_AMOSTR"),oSayHeader:SetText( "<H1>Amostras</H1>" ),oTButSave:SetCss("QPushButton{ background-color:rgb(255, 242, 0);}") ,oTButSave:bAction := {|| oWebEngine:runJavaScript("GetContents('ZZL_AMOSTR');"), oTButSave:SetCss("QPushButton{ background-color:rgb(34, 177, 76);}")},oTButSave:cCaption := "Salvar - Amostras"	,oTButSave:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_AMOSTR" .AND. x[2] == "2"} ) > 0 .and. nAcesMod <> 1	}, 80,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut8:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_AMOSTR" } ) > 0

  oTBut9 := TButton():New( 0, 0, "Material Suplementar"	, oLayTop,{|| RetHtml("ZZL_MATSUP"),oSayHeader:SetText( "<H1>Material Suplementar</H1>" ),oTButSave:SetCss("QPushButton{ background-color:rgb(255, 242, 0);}") ,oTButSave:bAction := {|| oWebEngine:runJavaScript("GetContents('ZZL_MATSUP');"), oTButSave:SetCss("QPushButton{ background-color:rgb(34, 177, 76);}")},oTButSave:cCaption := "Salvar - Material Suplementar"	,oTButSave:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_MATSUP" .AND. x[2] == "2"} ) > 0 .and. nAcesMod <> 1	}, 80,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut9:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_MATSUP" } ) > 0

  oTBut10 := TButton():New( 0, 0, "Depoimentos"	, oLayTop,{|| RetHtml("ZZL_DEPOIM"),oSayHeader:SetText( "<H1>Depoimentos</H1>" ),oTButSave:SetCss("QPushButton{ background-color:rgb(255, 242, 0);}") ,oTButSave:bAction := {|| oWebEngine:runJavaScript("GetContents('ZZL_DEPOIM');"), oTButSave:SetCss("QPushButton{ background-color:rgb(34, 177, 76);}")},oTButSave:cCaption := "Salvar - Depoimentos"	,oTButSave:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_DEPOIM" .AND. x[2] == "2"} ) > 0 .and. nAcesMod <> 1	}, 80,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut10:lActive := aScan(aAcesMemo, {|x| AllTrim(x[1]) == "ZZL_DEPOIM" } ) > 0
    
  oLayTop:AddInLayout(oTBut1)//obj - 02
  oLayTop:addSpacer(3,02)//obj - 03
  
  oLayTop:AddInLayout(oTBut2)//obj - 04
  oLayTop:addSpacer(5,02)//obj - 05
  
  oLayTop:AddInLayout(oTBut3)//obj - 06
  oLayTop:addSpacer(7,02)//obj - 07
  
  oLayTop:AddInLayout(oTBut4)//obj - 08
  oLayTop:addSpacer(9,02)//obj - 09
  
  oLayTop:AddInLayout(oTBut5)//obj - 10
  oLayTop:addSpacer(11,02)//obj - 11
  
  oLayTop:AddInLayout(oTBut6)//obj - 12
  oLayTop:addSpacer(13,02)//obj - 13
  
  //oLayTop:AddInLayout(oTBut7)//obj - 14
  //oLayTop:addSpacer(15,02)//obj - 15
  
  oLayTop:AddInLayout(oTBut8)//obj - 16
  oLayTop:addSpacer(15,02)//obj - 17

  oLayTop:AddInLayout(oTBut9)//obj - 16
  oLayTop:addSpacer(17,02)//obj - 17

  oLayTop:AddInLayout(oTBut10)//obj - 16
  oLayTop:addSpacer(19,84)//obj - 17
    
 /*
  oLayTopB:= tLinearLayout():New(oPanel,LAYOUT_LINEAR_L2R,CONTROL_ALIGN_TOP,30,30)
  oLayTopB:addSpacer(1,10)//obj - 01 
  
  oTBut1B := TButton():New( 0, 0, "Sobre Obra"			, oLayTopB,{|| oWebEngine:runJavaScript("GetContents('ZZL_SOBRA');")			}, 80,15,,,.F.,.T.,.F.,,.F.,,,.F. )   
  oTBut2B := TButton():New( 0, 0, "Sobre Autor"			, oLayTopB,{|| oWebEngine:runJavaScript("GetContents('ZZL_SAUTOR');") 			}, 80,15,,,.F.,.T.,.F.,,.F.,,,.F. )  
  oTBut3B := TButton():New( 0, 0, "Sobre a SÈrie"		, oLayTopB,{|| oWebEngine:runJavaScript("GetContents('ZZL_SSERIE');") 		}, 80,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut4B := TButton():New( 0, 0, "Sum·rio"				, oLayTopB,{|| oWebEngine:runJavaScript("GetContents('ZZL_SUMARI');") 				}, 80,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut5B := TButton():New( 0, 0, "Errata"				, oLayTopB,{|| oWebEngine:runJavaScript("GetContents('ZZL_ERRATA');") 				}, 80,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut6B := TButton():New( 0, 0, "Diferenciais"		, oLayTopB,{|| oWebEngine:runJavaScript("GetContents('ZZL_DIFERE');") 		}, 80,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut7B := TButton():New( 0, 0, "Genio"				, oLayTopB,{|| oWebEngine:runJavaScript("GetContents('ZZL_GENEIO');") 				}, 80,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTBut8B := TButton():New( 0, 0, "Amostras de P·ginas"	, oLayTopB,{|| oWebEngine:runJavaScript("GetContents('ZZL_AMOSTR');") 	}, 80,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  //oTBut8:SetCss("QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }")
  
  oLayTopB:AddInLayout(oTBut1B)//obj - 02
  oLayTopB:addSpacer(3,02)//obj - 03
  
  oLayTopB:AddInLayout(oTBut2B)//obj - 04
  oLayTopB:addSpacer(5,02)//obj - 05
  
  oLayTopB:AddInLayout(oTBut3B)//obj - 06
  oLayTopB:addSpacer(7,02)//obj - 07
  
  oLayTopB:AddInLayout(oTBut4B)//obj - 08
  oLayTopB:addSpacer(9,02)//obj - 09
  
  oLayTopB:AddInLayout(oTBut5B)//obj - 10
  oLayTopB:addSpacer(11,02)//obj - 11
  
  oLayTopB:AddInLayout(oTBut6B)//obj - 12
  oLayTopB:addSpacer(13,02)//obj - 13
  
  oLayTopB:AddInLayout(oTBut7B)//obj - 14
  oLayTopB:addSpacer(15,02)//obj - 15
  
  oLayTopB:AddInLayout(oTBut8B)//obj - 16
  oLayTopB:addSpacer(17,76)//obj - 17
   */
  // --------------------------------------------------------------------------------------------------------
  // Cria o frame central
  oBodyLyt := tLinearLayout():New(oPanel, LAYOUT_LINEAR_T2B, CONTROL_ALIGN_ALLCLIENT, 100, 100)
  //oBodyLyt:SetColor(,CLR_BLACK)
  //oBodyLyt:AddSpacer(1, 10)
  
  oLinBtSave:= tLinearLayout():New(oBodyLyt,LAYOUT_LINEAR_L2R,CONTROL_ALIGN_TOP,30,30)
  oBodyLyt:addInLayout(oLinBtSave)
  //oLinBtSave:AddSpacer(1)
    
  oTButSave := TButton():New( 20, 20, "Salvar", oBodyLyt,{|| MsgStop("Nenhum conteudo selecionado!") }, 80,15,,,.F.,.T.,.F.,,.F.,,,.F. )
  oTButSave:SetCss("QPushButton{ background-color:rgb(255, 242, 0);}")
  oLinBtSave:AddInLayout(oTButSave,LAYOUT_ALIGN_HCENTER,15)
  
  oTFSay := TFont():New('Lucida Sans',,16,.T.)
  oSayHeader := TSay():New(0,0,{||" "},oLinBtSave,,oTFSay,,,,.T.,CLR_RED,,150,00,,,,,,.T.)
  oLinBtSave:addInLayout(oSayHeader, LAYOUT_ALIGN_VCENTER+LAYOUT_ALIGN_HCENTER, 85)
  
  //oLinBtSave:addSpacer(4,80)//obj - 03
  
  oCenterPnl := tPanel():New(0,0,,oBodyLyt,,.T.,,,CLR_CYAN,0,0)
  oBodyLyt:addInLayout(oCenterPnl,,100)
              
  webengine(oCenterPnl)

Return nil

Static function webengine(oDlg)
Local i
Local nPort,lConnected, link
Local _tempPath	:= GetTempPath()
Local aFiles	:= {"totvstec.js","ckeditor.js","custom.js","HtmlEdiro.html","jquery.js","jquery-1.11.1.min.js","style.default.css"}

// Baixa arquivos do exemplo do RPO no diretorio temporario
for i := 1 to len(aFiles)
    cFile := _tempPath + aFiles[i]
    nHandle := fCreate(cFile)
    fWrite(nHandle, getApoRes(aFiles[i]))
    fClose(nHandle)
next i

// ------------------------------------------
// Prepara o conector WebSocket
// ------------------------------------------
oWebChannel := TWebChannel():New()
nPort       := oWebChannel::connect() // Efetua conex„o e retorna a porta do WebSocket
lConnected  := oWebChannel:lConnected // Conectado ? [.T. ou .F.]

// Verifica conex„o
if !lConnected
    msgStop("Erro na conex„o com o WebSocket")
    return // Aborta aplicaÁ„o
endif

// ------------------------------------------
// Define o CallBack JavaScript
// IMPORTANTE: Este È o canal de comunicaÁ„o
//             "vindo do Javascript para o ADVPL"
// ------------------------------------------
oWebChannel:bJsToAdvpl := {|self,codeType,codeContent| jsToAdvpl(self,codeType,codeContent) }

// Monta link para navegaÁ„o local inserindo "file:///"
if subs(_tempPath,1,2) == "C:"
    _tempPath := "file:///" + strTran(_tempPath, "\", "/")
endif
//link := _tempPath + "webengine.index.html?port="+cValToChar(nPort)
link := _tempPath + "HtmlEdiro.html"

// ------------------------------------------
// Cria navegador embedado
// ------------------------------------------
oWebEngine := TWebEngine():New(oDlg, 0, 0, 100, 100,, nPort)
oWebEngine:navigate(link)
oWebEngine:Align := CONTROL_ALIGN_ALLCLIENT
   
//oDlg:addInLayout(oWebEngine)
   
Return
 
// ------------------------------------------
// Esta funÁ„o recebera todas as chamadas vindas do Javascript
// atravÈs do mÈtodo dialog.jsToAdvpl(), exemplo:
// dialog.jsToAdvpl("page_started", "Pagina inicializada");
// ------------------------------------------
static function jsToAdvpl(self,codeType,codeContent)
    local i
    local cFunJS
    local oTmpHashProg:= .F.
    local cCommand := ""
	Local oModel := nil
	Local oModelZZL := nil

 
    if valType(codeType) == "C"
        // ------------------------------------------b
        // Recebe mensagem de termino da carga da p·gina/componente
        // ------------------------------------------
        if "ZZL_" $ codeType //codeType == "ZZL_HTML"
        	
        	//MsgStop(codeContent)
        	//oModel := FWLoadModel('GENCAZZL')
        	//M->ZZL_HTML		:= codeContent
        	//M->ZZL_TEXTO	:= codeContent
        	//oStruZZL:SetValue( 'ZZL_HTML', codeContent )
        	//oStruZZL:SetValue( 'ZZL_TEXTO', codeContent )

			oModel	:= FWModelActive()
			oView	:= FWViewActive()
			
			oModelZZL := oModel:GetModel( 'ZZL_FORM' )
			
			oModelZZL:SetValue(codeType, codeContent) // ALTERA CAMPO MEMO
			oView:Refresh("VIEW_MEM") // ATUALIZA«√O A SUBVIEW ONDE O CAMPO EST¡ CONTIDO
			//oVwHtml:Load(oModelZZL:GetValue("ZZL_HTML"))
		/*	
        Elseif codeType == "ZZL_TEXTO"
        	
        	//MsgStop(codeContent)
        	//oModel := FWLoadModel('GENCAZZL')
        	//M->ZZL_HTML		:= codeContent
        	//M->ZZL_TEXTO	:= codeContent
        	//oStruZZL:SetValue( 'ZZL_HTML', codeContent )
        	//oStruZZL:SetValue( 'ZZL_TEXTO', codeContent )

			oModel	:= FWModelActive()
			oView	:= FWViewActive()
			
			oModelZZL := oModel:GetModel( 'ZZL_FORM' )
			
			oModelZZL:SetValue(codeType, xHtToTex(codeContent)) // ALTERA CAMPO MEMO
			oView:Refresh("VIEW_MEM") // ATUALIZA«√O A SUBVIEW ONDE O CAMPO EST¡ CONTIDO
			*/        	
        ElseIF codeType == "page_started"

			//oModel	:= FWModelActive()
			//oView	:= FWViewActive()
			
			//oModelZZL := oModel:GetModel( 'ZZL_FORM' )

        	// oWebEngine:runJavaScript('var cTexto = '+"'"+oModelZZL:GetValue("ZZL_HTML")+"'"+"; SetInofTextArea(cTexto);")
        	//oWebChannel:advplToJs("html","")
        	//oWebEngine:runJavaScript('var cTexto = '+"'"+oModelZZL:GetValue("ZZL_HTML")+"'"+"; SetInofTextArea(cTexto);")
        	oWebEngine:runJavaScript("SetInofTextArea('teste agora')")
        	/*
            // ------------------------------------------
            // Ao terminar a carga da p·gina inserimos um bot„o na p·gina HTML
            // que far· a execuÁ„o de uma funÁ„o ADVPL via JavaScript
            //
            // Importante: O comando BeginContent permite a criaÁ„o de pequenos trechos de cÛdigo
            // facilitando a construÁ„o de chamadas, como neste exemplo onde montamos um trecho Javascript
            // ------------------------------------------
            BeginContent var cFunJS
                <a onclick='totvstec.runAdvpl("DtoS(CtoD(\"" +getDate()+ "\"))", runAdvplSuccess);'>
                    <div>
                        <font size="5">runAdvpl</font><br><br>
                    </div>
                </a>
            EndContent
 
            // ------------------------------------------
            // O mÈtodo AdvplToJS envia uma mensagem do ADVPL para o JavaScript, para verificar a chegada
            // desta mensagem procure o trecho a seguir no arquivo webengine.index.html
            // if (codeType == "html") {...
            // ------------------------------------------
            oWebChannel:advplToJs("html", cFunJS)
            */
        endif
 
        // ------------------------------------------
        // Este trecho vai executar um comando ADVPL vindo do JavaScript
        // ------------------------------------------
        if codeType == "runAdvpl"
 
            // ------------------------------------------
            // Importante:
            // A informaÁ„o trafegada pela chamada do metodo Javascript runADVPL È uma vari·vel do tipo JSON
            // assim È necess·rio seu tratamento, para tanto utilise as funÁıes getJsonHash e getHField, documentadas neste exemplo
            // ------------------------------------------
            if getJsonHash(codeContent, @oTmpHashProg)
             
                cCommand := getHField(oTmpHashProg, "codeBlock")
                if !empty(cCommand)
                 
                    // Transforma o texo em um bloco de cÛdigo e
                    // em caso de sucesso executa o mesmo
                    xVal := &("{|| " + cCommand + "}")
                    if valType(xVal) == "B"
                        xRet := eval(xVal)
                        xRet := cValToChar(xRet) // Converte pra String
         
                        // ------------------------------------------
                        // Importante:
                        // Este trecho executa do callBack (mensagem de retorno) para o Javascript
                        // permitindo o retorno de informaÁıes ao HTML apÛs o processamento via ADVPL
                        // ------------------------------------------
                        fnCallBack = getHField(oTmpHashProg, "callBack")+"('" +xRet+ "')"
                        oWebEngine:runJavaScript(fnCallBack)
                         
                    endif
                     
                endif
            endif
         
        endif
 
    endif
 
return
 
/* ---------------------------------------------------------------
 Parseia o Json em um Hash
  
 getJsonHash: recebe o conteudo no formato Texto que ser· parseado
 oHash: È uma varivel que receber· "por referencia" o conteudo HASH
        contido no Texto inicial, por ser uma variavel utilizada por referencia
        ela deve ter seu valor declarado anteriormente, exemplo: oTmpHashProg:= .F.
---------------------------------------------------------------*/
Static Function getJsonHash(jsonData, oHash)
    Local oJson := tJsonParser():New()
    Local jsonfields := {}
    Local nRetParser := 0
 
    if empty(jsonData)
        return .F.
    endif
 
    // Converte JSON pra Hash
    return oJson:Json_Hash(jsonData, len(jsonData), @jsonfields, @nRetParser, @oHash)
return
 
/* ---------------------------------------------------------------
 Retorna valor do campo no Hash
  
 oHash: vari·vel no formato HASH criada pela funÁ„o  getJsonHash
 jsonField: nome do campono no formato Texto que se deseja recuperar
  
 retorno: valor do campo encontrado ou "vazio" caso contr·rio
 ---------------------------------------------------------------*/
Static Function getHField(oHash, jsonField)
    Local xGet := Nil
    // Recupera valor do campo
    if HMGet(oHash, jsonField, xGet)
        return xGet
    else
        return ""
    endif
return


Static Function xHtToTex(cParam)

Local cText		:= ""
Local bConfirm	:= {|x| oDlg:End()  }
Local bCancel	:= {|x| oDlg:End()  }
Local aButtons	:= {}

  DEFINE DIALOG oDlg TITLE "Load Html" FROM 180,180 TO 1000,1000 PIXEL
    
	//oBj := FWSimpEdit():New(10, 10, 500, 500 , "", cParam, 1 , .F., .F., oDlg , .f.) 
 	//oBj:InsertHtml(cParam)
	//AADD(aButtons, {"cargaseq",	{|| GravaHtml(oBj:GetText()) }, "Salvar"})

	oEdit := tSimpleEditor():New(0, 0, oDlg, 260, 184)
	oEdit:TextFormat( 1 )
    oEdit:Load(cParam)
          
  ACTIVATE DIALOG oDlg On Init (cText := CargaHtml(oEdit),oDlg:End() )

Return cText

Static Function CargaHtml(oEdit)

Local cRet := ""

oEdit:TextFormat( 2 )
cRet := oEdit:RetText()

Return cRet


Static Function xMudaSitObr(cParam1)

Local oDlgSit	:= nil
Local cRet 		:= PadR(cParam1,TamSX3("ZZL_SITOBR")[1])
Local cCadastro	:= "SituaÁ„o do Produto"
Local nOpcA		:= 0
Local aButtons	:= {}
//Local oFont		:= TFont():New('Courier new',,-15,.T.)
Local oSay1		:= nil
Local oGet1		:= nil

DEFINE MSDIALOG oDlgSit TITLE cCadastro FROM 000,000 TO 100,250 COLORS 0, 16777215 PIXEL

oSay1:= TSay():New(005,005,{|| "SituaÁ„o atual: "+AllTrim(cParam1)+" - "+Posicione("SZ4",1,xFilial("SZ4")+cParam1,"Z4_DESC") },oDlgSit,,/*oFont*/,,,,.T.,CLR_BLUE,CLR_WHITE,200,20)
 
oGet1 := TGet():New( 025, 005, { | u | If( PCount() == 0, cRet, cRet := u ) },oDlgSit, 030, 010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cRet"  )
oGet1:cF3	:= "ZZCTP"

oSButton := SButton():New( 025, 060, 1, {|| nOpcA := 1,oDlgSit:End() }, oDlgSit, .T.,,)

ACTIVATE MSDIALOG oDlgSit CENTERED

If Empty(cRet)
	cRet := cParam1
EndIf

Return cRet


Static Function xAddImg()

Local cTcPacth	:= GetTempPath()
Local cPacth	:= ""
Local cFile		:= ""
Local oModel	:= FWModelActive()
Local oModelZZU := oModel:GetModel( 'ZZU_GRID' )
Local nQtdLin	:= oModelZZU:Length()
Local aFiles	:= {} 
Local oViewAtv	:= FWViewActive()
Local nLenFile	:= 0
Local nHandle	:= 0
Local cDadosImg	:= ""
Local lTpImg	:= .T.
Local lRet		:= .F.
Local aRetPr	:= {}

Local cTexto 	:= ""
Local aFileAux	:= {} // O array receber· os nomes dos arquivos e do diretÛrio
Local aSizes 	:= {} // O array receber· os tamanhos dos arquivos e do diretorio

//Local oViewAtv	:= FWViewActive()
//Local oViewImg	:= oViewAtv:getModel(cViewSit)

lTpImg := Aviso("Escolha", "Qual tipo de mÌdia?", {"Arq.Imagem", "URL/LINK"}) == 1

If lTpImg
	cTcPacth	:= LEFT(cTcPacth, Rat(GetUserInfoArray()[1][1],cTcPacth)+Len(GetUserInfoArray()[1][1]) )
	If ExistDir(cTcPacth+"Desktop")
		cTcPacth+="Desktop\" 
	EndIf
	
	cPacth := cGetFile("Imagens PNG|*.png|Imagens jpg|*.jpg|Imagens BMP|*.bmp|Arquivos GIF|*.gif|Videos MP4|*.mp4|Todos|*.*" , "SeleÁ„o de Arquivo" , 0 , cTcPacth , .T. , GETF_LOCALHARD+GETF_NETWORKDRIVE,.F.)
	
	Do Case
	 	Case Empty(cPacth)
	 		Return nil
	 	Case !File(cPacth)
	 		MsgStop("Arquivo n„o localizado!")
	 		Return nil
	 	OtherWise
	 		cFile	:= Separa(cPacth,"\")[Len(Separa(cPacth,"\"))] 		
	EndCase
	
	aFiles	:= Directory(cPacth, "D")

	ADir(cPacth, aFileAux, aSizes)//Verifica o tamanho do arquivo, par‚metro exigido na FRead.	
	nHandle := fopen(cPacth, FO_READWRITE + FO_SHARED )
	cString := ""
	FRead( nHandle, cString, aSizes[1] ) //Carrega na vari·vel cString, a string ASCII do arquivo.
	fclose(nHandle)

	cEncode64	:= Encode64(cString,NIL,.F.,.F.)//Encode64(,cPacth,.F.,.F.)

	//<--oVwImg:Load('<div align="center"><img src="data:image/png;base64,'+cEncode64+'" alt="preview"></div>')
	//oVwImg:InsertHtml('<div align="center"><img src="data:image/png;base64,'+cEncode64+'" alt="preview"></div>')
	
	MontaImg(cEncode64,Separa(cFile,".")[Len(Separa(cFile,"."))],cString)
	
	lRet := MsgYesNo("A imagem est· visivel para vocÍ?") 
Else
	ParamBox({ {01,"URL/LINK"		,Space(250)	,"",".T.",""/*F3*/,"",100,.T.} },"Informe a URL/LINK",@aRetPr,{|x| .T. },,,,,,,.F.,.F.)
	If Len(aRetPr) > 0
		cFile := aRetPr[1]
		lRet := .T.
	Else
		lRet := .F.	
	EndIf
EndIf

If lRet
	oModel:GetModel('ZZU_GRID'):SetNoInsertLine(.F.)
	If !Empty(oModelZZU:GetValue("ZZU_FILE",nQtdLin))
		If oModelZZU:AddLine() == (nQtdLin+1)
			nQtdLin++
		Else
			MsgStop("N„o foi possÌvel carregar a imagem, tente novamente!")
		EndIf	
	EndIf
	oModelZZU:LoadValue("ZZU_CODIMG",GetSX8Num("ZZU","ZZU_CODIMG"))	
	
	If lTpImg
		oModelZZU:LoadValue("ZZU_FILE",AllTrim(cFile))
		oModelZZU:LoadValue("ZZU_TIPO",Separa(cFile,".")[Len(Separa(cFile,"."))])  
		oModelZZU:LoadValue("ZZU_SIZE",aFiles[01][2])
		oModelZZU:LoadValue("ZZU_B64",cEncode64)
		oModelZZU:LoadValue("ZZU_MEMO",cString)//Decode64(cEncode64))
	Else
		If "YOUTUBE" $ UPPER(cFile)
			oModelZZU:LoadValue("ZZU_FILE","YOUTUBE")
		else
			If "/" $ cFile
				oModelZZU:LoadValue("ZZU_FILE",AllTrim(Separa(cFile,"/")[Len(Separa(cFile,"/"))]))
			Else
				oModelZZU:LoadValue("ZZU_FILE",Alltrim(Separa(cFile,"\")[Len(Separa(cFile,"\"))]))
			EndIf
		endIf
		oModelZZU:LoadValue("ZZU_TIPO","URL")
		oModelZZU:LoadValue("ZZU_B64",cFile)
		oModelZZU:LoadValue("ZZU_MEMO",cFile)
	EndIF
	  
	oModelZZU:LoadValue("ZZU_DTINC",DDataBase)
	oModelZZU:LoadValue("ZZU_HRINCL",Left(Time(),5))
	oModelZZU:LoadValue("ZZU_PRINCI", IIF( oModelZZU:Length() == 1 , "1" , "2" ) )
	
	IF oModelZZU:VldData()
		ConfirmSX8()
	Else
		aErro	:= oModel:GetErrorMessage()
		AutoGrLog( "Id do formul·rio de origem:" + ' [' + AllToChar( aErro[1] ) +']' )
		AutoGrLog( "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) +']' )
		AutoGrLog( "Id do formul·rio de erro: " + ' [' + AllToChar( aErro[3] ) +']' )
		AutoGrLog( "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) +']' )
		AutoGrLog( "Id do erro: " + ' [' + AllToChar( aErro[5] ) +']' )		
		MostraErro()
	EndIf
	oModel:GetModel('ZZU_GRID'):SetNoInsertLine(.T.)
	oViewAtv:Refresh("ZZU_GRID")
	//MemoWrite("C:\TEMP\"+oModelZZU:GetValue("ZZU_CODIMG")+".png" , Decode64(cEncode64) )
Else
	MsgStop("N„o foi possÌvel carregar a informaÁ„o, tente novamente!")
EndIf

Return nil


Static Function xViewImg()

Local oModel	:= FWModelActive()
Local oModelZZU := oModel:GetModel( 'ZZU_GRID' )
Local cHtml		:= ""
/*
cHtml += '<!DOCTYPE html>'+chr(13)+chr(10)
cHtml += '<html>'+chr(13)+chr(10)
cHtml += '<head>'+chr(13)+chr(10)
cHtml += '<style>'+chr(13)+chr(10)
cHtml += 'div.ex1 {'+chr(13)+chr(10)
//cHtml += '  background-color: lightblue;'+chr(13)+chr(10)
cHtml += '  width: 110px;'+chr(13)+chr(10)
cHtml += '  height: 110px;'+chr(13)+chr(10)
cHtml += '  overflow: scroll;'+chr(13)+chr(10)
cHtml += '}'+chr(13)+chr(10)
cHtml += '</style>'+chr(13)+chr(10)
cHtml += '</head>'+chr(13)+chr(10)
cHtml += '<body>'+chr(13)+chr(10)
cHtml += '<div class="ex1" align="center"><img src="data:image/png;base64,'+oModelZZU:GetValue("ZZU_B64")+'"</div>'+chr(13)+chr(10)
cHtml += '</body>'+chr(13)+chr(10)
cHtml += '</html>'+chr(13)+chr(10)
*/

//cHtml += '<div align="center"><img src="data:image/png;base64,'+AllTrim(oModelZZU:GetValue("ZZU_B64"))+'"</div>'
//oVwImg:setHtml(cHtml)
MontaImg(AllTrim(oModelZZU:GetValue("ZZU_B64")),AllTrim(oModelZZU:GetValue("ZZU_TIPO")),AllTrim(oModelZZU:GetValue("ZZU_MEMO")))

//<--oVwImg:Load(cHtml)
//oVwImg:InsertHtml(cHtml)

Return nil


Static Function xImgPric()
Local oModel	:= FWModelActive()
Local oModelZZU	:= oModel:GetModel( 'ZZU_GRID' )
Local nLenght	:= oModelZZU:Length()
Local nBkpLine	:= oModelZZU:GetLine()
Local nAuxFor	:= 0
Local oViewAtv	:= FWViewActive()

If !MsgYesNo("Confirma a atribuiÁ„o desta imagem para imagem principal?"+Chr(13)+Chr(10)+"Caso exista outra imagem como principal a mesma ser· alterada para 'N„o'!")	
	Return nil
EndIf

For nAuxFor := 1 To nLenght
	oModelZZU:SetLine(nAuxFor)
	oModelZZU:LoadValue("ZZU_PRINCI","2")
Next

oModelZZU:SetLine(nBkpLine)
oModelZZU:LoadValue("ZZU_PRINCI","1")
oViewAtv:Refresh("ZZU_GRID")

Return nil

Static Function MontaImg(cImgB64,cExt,cMemoImg)

Local cDirTmp	:= GetTempPath()
Local cFileTmp	:= Criatrab(Nil,.F.)

If Upper(cExt) == "MP4"
	//MemoWrite(cDirTmp+"\"+cFileTmp+".html",'<div align="center"><video autoplay controls src="data:video/mp4;base64,'+cImgB64+'>" The ìvideoî tag is not supported by your browser. Click [here] to download the video file. </video></div>')
	Aadd(aImpDir,cDirTmp+"\"+cFileTmp+"."+cExt)
	Aadd(aImpDir,cDirTmp+"\"+cFileTmp+".html")
	MemoWrite(cDirTmp+"\"+cFileTmp+"."+cExt,Decode64(cImgB64))  
	MemoWrite(cDirTmp+"\"+cFileTmp+".html",'<div align="center"><video controls><source src="'+cFileTmp+'.'+cExt+'" type="video/'+cExt+'"></video></div>')
	ShellExecute("Open", cDirTmp+"\"+cFileTmp+".html", "", cDirTmp, 1 )
ElseIf Upper(cExt) == "URL"
	if Upper("iframe") $ Upper(cImgB64)
		Aadd(aImpDir,cDirTmp+"\"+cFileTmp+".html")
		MemoWrite(cDirTmp+"\"+cFileTmp+".html",'<div align="center">'+cImgB64+'</div>')
	elseIf "JPG" $ Upper(cImgB64) .or. "BMP" $ Upper(cImgB64) .or. "PNG" $ Upper(cImgB64)
		Aadd(aImpDir,cDirTmp+"\"+cFileTmp+".html")
		MemoWrite(cDirTmp+"\"+cFileTmp+".html",'<div align="center"><img src="'+cImgB64+'" alt="preview"></div>')
	else
		Aadd(aImpDir,cDirTmp+"\"+cFileTmp+".html")
		MemoWrite(cDirTmp+"\"+cFileTmp+".html",'<div align="center"><iframe  src="'+cImgB64+'" scrolling="no" frameborder="0" allow="geolocation; microphone; camera; encrypted-media; midi"></iframe>	</div>')				
	EndIf
Else
	//MemoWrite(cDirTmp+"\"+cFileTmp+"."+cExt,Decode64(cImgB64))
	Aadd(aImpDir,cDirTmp+"\"+cFileTmp+".html")
	//MemoWrite(cDirTmp+"\"+cFileTmp+".html",'<div align="center"><img src="data:image/png;base64,'+cImgB64+'" alt="preview"></div>')
	MemoWrite(cDirTmp+"\"+cFileTmp+"_img.png",cMemoImg)
	MemoWrite(cDirTmp+"\"+cFileTmp+".html",'<div align="center"><img src="'+cFileTmp+"_img.png"+'" alt="preview"></div>')
EndIF

If "PHP" $ Upper(cImgB64) .and. Upper(cExt) == "URL"
	ShellExecute("Open", cImgB64, "", "", 1 )	
EndIF

oVwImg:navigate(cDirTmp+"\"+cFileTmp+".html")

//oVwImg:setHtml('<div align="center"><img src="data:image/png;base64,'+cEncode64+'" alt="preview"></div>', nil)
//cHtml += '<div align="center"><img src="data:image/png;base64,'+AllTrim(oModelZZU:GetValue("ZZU_B64"))+'"</div>'

Return nil

User function CAZZL_MD()
Local aAreaZZL	:= ZZL->(GetArea())
Local aParam	:= PARAMIXB
Local xRet		:= .T.
Local oObj		:= ''
Local cIdPonto	:= ''
Local cIdModel	:= ''
Local lIsGrid	:= .F.
Local cUpdHist	:= ""
//Local oModelZZL	:= oObj:GetModel( 'ZZL_FORM' )
Local oModZZU	:= nil 
Local nAuxZZU	:= 0
Local cUpdRPA	:= ""
Local cOriZZN	:= PadR("GENCAZZL",TamSX3("ZZN_ORIGEM")[1])

If PARAMIXB <> NIL
      
	oObj       := aParam[1]
	cIdPonto   := aParam[2]
	cIdModel   := aParam[3]
	lIsGrid    := ( Len( aParam ) > 3 )
	
	If cIdPonto == 'MODELPOS'
	ElseIf cIdPonto == 'FORMPOS'
	ElseIf cIdPonto == 'FORMLINEPRE'
	ElseIf cIdPonto == 'FORMLINEPOS'
		
		If oObj:HasField("ZZU_CODIMG")
			//ZZU_CODIMG/ZZU_FILE/ZZU_TIPO/ZZU_SIZE/ZZU_DTINC/ZZU_HRINCL/ZZU_B64/ZZU_PRINCI/ZZU_ALTIMG/ZZU_HRALT/ZZU_DTALT
			For nAuxZZU := 1 To oObj:Length()
				oObj:GoLine( nAuxZZU )
				If oObj:IsDeleted() .OR. oObj:IsInserted() .OR. oObj:IsUpdated()
					oObj:LoadValue("ZZU_DTALT",DDataBase)
					oObj:LoadValue("ZZU_HRALT",Left(Time(),5))
				EndIf
			Next nAuxZZU
		EndIF
	ElseIf cIdPonto == 'FORMCOMMITTTSPRE'		
	ElseIf cIdPonto == 'MODELCOMMITTTS'
	ElseIf cIdPonto == 'MODELCOMMITNTTS'

		
		If oObj:HasField('ZZL_FORM', "ZZL_CEME")
			
			MemoWrite(GetTempPath()+"EncodeUTF8.html",EncodeUTF8(ZZL->ZZL_CEME))		
			RecLock("ZZL",.f.)
			ZZL->ZZL_WEB := EncodeUTF8('{"ZZL_CEME":"'+ALLTRIM(ZZL->ZZL_CEME)+'","ZZL_AUTWEB":"'+ALLTRIM(ZZL->ZZL_AUTWEB)+'", "TESTE":"'+MyAltCarEsp(ALLTRIM(ZZL->ZZL_CEME))+' ')
			MsUnLock()
		EndIF

		/* atualizada FEC */
		If (nOperAux == 3 .OR. nOperAux == 4) .AND. oObj:HasField('ZZL_FORM', "ZZL_FEC") .AND. oObj:GetValue('ZZL_FORM',"ZZL_FEC") <> "1";
			.AND. oObj:HasField('ZZL_FORM', "ZZL_CODHIS");
			.AND. oObj:HasField('ZZL_FORM', "ZZL_SITOBR");
			.AND. oObj:HasField('ZZL_FORM', "ZZL_EDICAO")
					
			If AllTrim(oObj:GetValue('ZZL_FORM',"ZZL_SITOBR")) == "101"
				
				If Select("TMP_FEC") > 0
					TMP_FEC->(DbClosearea())
				EndIf
				
				BeginSql Alias "TMP_FEC"
					SELECT MAX(ZZL_EDICAO) ZZL_EDICAO FROM %Table:ZZL% ZZL
					WHERE ZZL_FILIAL = %xFilial:ZZL%
					AND ZZL_CODHIS = %Exp:ZZL->ZZL_CODHIS%
					AND ZZL.ZZL_COD <> %Exp:ZZL->ZZL_COD%
					AND ZZL.ZZL_IDTPPU = %Exp:ZZL->ZZL_IDTPPU%
					AND ZZL.%NotDel%
				EndSql
				
				TMP_FEC->(DbGoTop())
				If TMP_FEC->(EOF()) .OR. EMPTY(TMP_FEC->ZZL_EDICAO)
					RecLock("ZZL",.F.)
					ZZL->ZZL_FEC	:= "1"
					MsUnLock()					
				Else 
					If Val(StrTran(TMP_FEC->ZZL_EDICAO,"|","")) < Val(StrTran( oObj:GetValue('ZZL_FORM',"ZZL_EDICAO") ,"|","")) .AND. !EMPTY(TMP_FEC->ZZL_EDICAO)
						RecLock("ZZL",.F.)
						ZZL->ZZL_FEC	:= "1"
						MsUnLock()
						cUpdHist	:= ""
						Begin transaction
							cUpdHist := " UPDATE "+RetSqlName("ZZL")+" SET ZZL_FEC = '2' WHERE ZZL_FILIAL = '"+xFilial("ZZL")+"' AND ZZL_CODHIS = '"+ZZL->ZZL_CODHIS+"' AND ZZL_COD <> '"+ZZL->ZZL_COD+"' AND ZZL_IDTPPU = '"+ZZL->ZZL_IDTPPU+"' AND D_E_L_E_T_ <> '*' "
							TcSqlExec(cUpdHist)
						End transaction
					EndIf					
				EndIf
				TMP_FEC->(DbClosearea())
					
			EndIf		
		EndIf

		RestArea(aAreaZZL)
		
		RecLock("ZZL",.F.)
		ZZL->ZZL_DTALTE	:= DDataBase
		ZZL->ZZL_HALTER	:= Time()
		ZZL->ZZL_USRALT	:= AllTrim(UsrRetName(RetCodUsr()))
		If nOperAux == 3
			ZZL->ZZL_DTINC	:= DDataBase
			ZZL->ZZL_HRINCL	:= Time()
			ZZL->ZZL_USRINC	:= AllTrim(UsrRetName(RetCodUsr()))			
		EndIf
		ZZL->ZZL_TPPROD := Posicione("ZZT",1,xFilial("ZZT")+AllTrim(ZZL->ZZL_IDTPPU),"ZZT_TIPO")
		MsUnLock()
		
		IF !Empty(ZZL->ZZL_ISBN)
			IF !Empty(ZZL->ZZL_PPE)
				ZZK->(DbSetOrder(1))
				ZZK->(DbSeek( ZZL->ZZL_FILIAL+ZZL->ZZL_PPE ))
				While ZZK->(!EOF()) .AND. ZZK->ZZK_FILIAL+ZZK->ZZK_PPE == ZZL->ZZL_FILIAL+ZZL->ZZL_PPE
					IF ZZK->ZZK_TIPINC == "93" .OR. ZZK->ZZK_CODPRO <> ZZL->ZZL_COD
						ZZK->(DbSkip())
						Loop
					ENDIF
					Reclock("ZZK",.F.)
					ZZK->ZZK_ISBN := ZZL->ZZL_ISBN
					MsUnLock()
					ZZK->(DbSkip())
				EndDo	
			ENDIF
		ENDIF

		If ( nOperAux == 3 .OR. nOperAux == 4  .OR. nOperAux == 9) .AND. ( AllTrim(cSitObr) <> AllTrim(oObj:GetValue('ZZL_FORM',"ZZL_SITOBR")) )
			Begin transaction
				cUpdHist	:= ""
				cUpdHist	+= "INSERT INTO SIS_DBA.SIS_AUDITORIA (QUANDO, QUEM, OPERACAO, TABELA, CAMPO, CHAVE, VALOR_ANTIGO, VALOR_NOVO)" 
				cUpdHist	+= "VALUES (SYSDATE, '"+AllTrim(UsrRetName(RetCodUsr()))+"', '"+IIF( nOperAux == 3 .OR. nOperAux == 9 , "I" , "U" )+"', '"+RetSqlName("ZZL")+"', 'ZZL_SITOBR', '"+AllTrim(oObj:GetValue('ZZL_FORM',"ZZL_COD"))+"' , '"+cSitObr+"', '"+AllTrim(oObj:GetValue('ZZL_FORM',"ZZL_SITOBR"))+"')"
				TcSqlExec(cUpdHist)
			End transaction
		EndIf

		If oObj:HasField('ZZL_FORM', "ZZL_PSITEG") .AND. ( nOperAux == 3 .OR. nOperAux == 4  .OR. nOperAux == 9) .AND. ( AllTrim(cSitOld) <> AllTrim(oObj:GetValue('ZZL_FORM',"ZZL_PSITEG")) )
			Begin transaction
				cUpdHist	:= ""
				cUpdHist	+= "INSERT INTO SIS_DBA.SIS_AUDITORIA (QUANDO, QUEM, OPERACAO, TABELA, CAMPO, CHAVE, VALOR_ANTIGO, VALOR_NOVO)" 
				cUpdHist	+= "VALUES (SYSDATE, '"+AllTrim(UsrRetName(RetCodUsr()))+"', '"+IIF( nOperAux == 3 .OR. nOperAux == 9 , "I" , "U" )+"', '"+RetSqlName("ZZL")+"', 'ZZL_PSITEG', '"+AllTrim(oObj:GetValue('ZZL_FORM',"ZZL_COD"))+"' , '"+cSitOld+"', '"+AllTrim(oObj:GetValue('ZZL_FORM',"ZZL_PSITEG"))+"')"
				TcSqlExec(cUpdHist)
			End transaction
		EndIf	

		If nOperAux == 9
			
			If Select("TMP_COPY") > 0
				TMP_COPY->(DbCloseArea())
			EndIf
			
			BeginSql Alias "TMP_COPY"
				SELECT ZZN_PRODUT, ZZN_CODSIT, ZZN_CODCAT, ZZN_DESC,ZZN_ORIGEM
				FROM %Table:ZZN% ZZN
				WHERE ZZN_FILIAL = %xFilial:ZZN%
				AND ZZN.ZZN_PRODUT = %Exp:cCodCopy%
				AND ZZN.ZZN_ORIGEM = %Exp:cOriZZN%
				AND ZZN.%NotDel%
			EndSql
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

			If Select("TMP_COPY") > 0
				TMP_COPY->(DbCloseArea())
			EndIf
							
		EndIF		
		
		If AllTrim(oObj:GetValue('ZZL_FORM',"ZZL_SITOBR")) <> "000"
			Processa({|| AtuSB1(oObj) },"Processando...","Aguarde.. atualizando SB1!",.F.)
			Processa({|| GerIdProd(oObj) },"Processando...","Aguarde.. gerando ID.ProduÁ„o!",.F.)
		EndIf

		//If AllTrim(oObj:GetValue('ZZL_FORM',"ZZL_SITOBR")) == "101" .OR. AllTrim(oObj:GetValue('ZZL_FORM',"ZZL_SITOBR")) == "105"
			//Processa({|| GerIdProd(oObj) },"Processando...","Aguarde.. gerando ID.ProduÁ„o!",.F.)
		//EndIf
				
		xRet := nil
		
		If (nOperAux == 3 .OR. nOperAux == 4)
			VldFEC(oObj:GetValue('ZZL_FORM',"ZZL_CODHIS"),oObj:GetValue('ZZL_FORM',"ZZL_IDTPPU"))
		EndIf	
		
		If nOperAux <> 5
			MsgRun("IntegraÁıes","Processando integraÁ„o com RPA Oracle...",{|| U_GENA093O(ZZL->ZZL_COD,ZZL->ZZL_TIPINC) })
		EndIF

	ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
	ElseIf cIdPonto == 'MODELCANCEL'
	ElseIf cIdPonto == 'BUTTONBAR'
		xRet := {}    
	EndIf
EndIf

RestArea(aAreaZZL)

Return xRet


/* valida integridade conceito FEC */

Static function VldFEC(cIDHist,cIDTpPub)

Local lRet	:= .T.

If Select("VLD_ZZL") > 0 
	VLD_ZZL->(DbcloseArea())
EndIf

BeginSql Alias "VLD_ZZL"
	SELECT COUNT(*) QTD_FEC
	FROM %Table:ZZL% ZZL
	WHERE ZZL_FILIAL = %xFilial:ZZL%
	AND ZZL_CODHIS = %Exp:cIDHist%
	AND ZZL.ZZL_IDTPPU = %Exp:cIDTpPub%
	AND ZZL.ZZL_FEC = '1'
	AND ZZL.%NotDel%
	GROUP BY ZZL_FEC
	HAVING COUNT(*) > 1
EndSql

VLD_ZZL->(DbGoTop())

If VLD_ZZL->(!EOF()) .AND. VLD_ZZL->QTD_FEC
	MsgStop("Detectada uma possÌvel falha de integridade do conceito FEC, por favor, verifique os produtos com ID Historico "+cIDHist+" e tipo de publicaÁ„o ("+cIDTpPub+")"+" "+AllTrim(Posicione("ZZT",1,xFilial("ZZT")+cIDTpPub,"ZZT_DESC")))
	lRet	:= .F.
EndIf

VLD_ZZL->(DbcloseArea())

Return lRet

/* Criar/Atualizada SB1 */

Static Function AtuSB1(oObj)

Local lNewSB1	:= .F.
Local aProduto	:= {}
Local nOpt		:= 0
Local cLoj		:= "01"
Local cFab		:= ""
Local _cTs		:= GetMv("GENA017TS")
Local aImpSV	:= Separa(SuperGetMv("GEN_FAT213",.F.," "),"#")//CODISS#ALIQISS#CNAE#TRIBMUN#POSIPI
Local aImpSVB	:= Separa(SuperGetMv("GEN_FAT212",.F.," "),"#")//PIS#COFINS#CSLL#IRRF
Local cUnExp	:= SuperGetMv("GEN_FAT208",.F.," ")
Local cTpPubSep	:= SuperGetMv("GEN_FAT214",.f.,.f.,"")
Local cTab		:= GETMV("GEN_FAT064")                                              
Local cCODISS	:= aImpSV[1] 
Local cALIQISS	:= Val(aImpSV[2])
Local cCNAE		:= aImpSV[3]
Local cTRIBMUN	:= aImpSV[4]
Local cPISIPI	:= aImpSV[5]
Local cPIS		:= aImpSVB[1]
Local cConfis	:= aImpSVB[2]
Local cCsll		:= aImpSVB[3]
Local cIrrf		:= aImpSVB[4]
Local nTxPis	:= SuperGetMv("MV_TXPIS",.F.,0)
Local nTxCof	:= SuperGetMv("MV_TXCOFIN",.F.,0)
Local lErro		:= .T.
Local cFile 	:= Dtos(dDataBase) + " - Produto "+Alltrim(ZZL->ZZL_COD)+".log"
Local cPath   	:= "\LogSiga\Produtos\"
Local cTpServ	:= Posicione("ZZT",1,xFilial("ZZT")+AllTrim(ZZL->ZZL_IDTPPU),"ZZT_TPCOME")
Local oServer	:= nil
Local aRet		:= {}
Local aMsgVld	:= {}
Local cMsgAux	:= ""
Local aSB5		:= {}
Local nOptSB5	:= 0
Local lLogaOri	:= .F.
Local lViaTT_I03	:= .T.
Local cEmpOri		:= ""
Local cCodDis		:= ""
Local cCodCurso		:= ""
Local cOriZZN		:= PadR("GENCAZZL",TamSX3("ZZN_ORIGEM")[1])

ProcRegua(0)
IncProc("Preparando Dados...")

SB1->(DbSetOrder(1))
SB5->(DbSetOrder(1))

lNewSB1 := !SB1->(DbSeek( xFilial("SB1")+ZZL->ZZL_COD ))
lNewSB5 := !SB5->(DbSeek( xFilial("SB5")+ZZL->ZZL_COD ))

If lNewSB1
	nOpt := 3 //INCLUI		
Else
	nOpt := 4 //ATUALIZA
Endif

If lNewSB5
	nOptSB5 := 3 //INCLUI		
Else
	nOptSB5 := 4 //ATUALIZA
Endif

aAdd(aProduto, {"B1_COD"	, AllTrim(ZZL->ZZL_COD)								, Nil})		
aAdd(aProduto, {"B1_DESC"	, ALLTRIM(ZZL->ZZL_DESC)					, Nil})
aAdd(aProduto, {"B1_TIPO"	, cTpServ									, Nil})
aAdd(aProduto, {"B1_UM"		, "UN"										, Nil})
aAdd(aProduto, {"B1_LOCPAD"	, "01"										, Nil})
aAdd(aProduto, {"B1_GRUPO"	, AllTrim(ZZL->ZZL_CLASSE)					, Nil})
aAdd(aProduto, {"B1_ORIGEM"	, '0'										, Nil})	
aAdd(aProduto, {"B1_MSBLQL"	, ZZL->ZZL_MSBLQL							, Nil})
aAdd(aProduto, {"B1_CODBAR"	, substr(alltrim( ZZL->ZZL_CODBAR ),1,13)	, Nil})
aAdd(aProduto, {"B1_ISBN"	, ZZL->ZZL_ISBN								, Nil})
aAdd(aProduto, {"B1_XSITOBR", ZZL->ZZL_SITOBR							, Nil})
aAdd(aProduto, {"B1_XEMPRES", AllTrim(ZZL->ZZL_EMPRES)					, Nil})
aAdd(aProduto, {"B1_XIDMAE"	, AllTrim(ZZL->ZZL_IDMAE)					, Nil})
aAdd(aProduto, {"B1_XIDTPPU", ZZL->ZZL_IDTPPU							, Nil})
aAdd(aProduto, {"B1_XPERCRM", IIF( ZZL->ZZL_PERCRM == "1" , ZZL->ZZL_PERCRM, "0" )	, Nil})
aAdd(aProduto, {"B1_XPSITEG", IIF( ZZL->ZZL_PSITEG == "1" , ZZL->ZZL_PSITEG, "0" )	, Nil})

ZZA->(DbSetOrder(1))
If ZZA->(DbSeek( xFilial("ZZA")+ALLTRIM(ZZL->ZZL_CC) )) 
	aAdd(aProduto, {"B1_CC"		, ZZA->ZZA_CC		, Nil})
	aAdd(aProduto, {"B1_XCC"	, ZZA->ZZA_CCINTE	, Nil})
EndIf

aAdd(aProduto, {"B1_TS"		, _cTs										, Nil}) //TES DE SAIDA = VENDA 
aAdd(aProduto, {"B1_PESO"	, ZZL->ZZL_PESO								, Nil})
aAdd(aProduto, {"B1_PESBRU"	, ZZL->ZZL_PESO								, Nil})

If cTpServ $ "SV#"
	aAdd(aProduto, {"B1_CODISS"		, cCODISS 	, Nil	})
	aAdd(aProduto, {"B1_ALIQISS"	, cALIQISS	, Nil 	})
	aAdd(aProduto, {"B1_CNAE"		, cCNAE 	, Nil	})
	aAdd(aProduto, {"B1_TRIBMUN"	, cTRIBMUN	, Nil	})
	aAdd(aProduto, {"B1_POSIPI"		, cPISIPI	, Nil	})			
	aAdd(aProduto, {"B1_PIS"		, cPIS		, Nil	})
	aAdd(aProduto, {"B1_COFINS"		, cConfis	, Nil	})
	aAdd(aProduto, {"B1_CSLL"		, cCsll		, Nil	})
	aAdd(aProduto, {"B1_IRRF"		, cIrrf		, Nil	})
	
	aAdd(aProduto, {"B1_PPIS"		, nTxPis	, Nil	})
	aAdd(aProduto, {"B1_PCOFINS"	, nTxCof	, Nil	})	
Else
	If ZZL->ZZL_PUBLIP == "1"
		aAdd(aProduto, {"B1_POSIPI"		, "49029000"	, Nil})
	Else
		aAdd(aProduto, {"B1_POSIPI"		, "49019900"	, Nil})
	EndIf	
EndIF

CCZ->(DbSetOrder(1))//CCZ_FILIAL+CCZ_TABELA+CCZ_COD+CCZ_GRUPO+DTOS(CCZ_DTFIM)                                                                                                         
CCZ->(DbSeek( xFilial("CCZ"+"4313903") ))
aAdd(aProduto, {"B1_TNATREC"	, CCZ->CCZ_TABELA 						, Nil})
aAdd(aProduto, {"B1_CNATREC"	, CCZ->CCZ_COD 						, Nil})

cLoj := "01"
If VAL(ZZL->ZZL_EMPRES) == 1 //EDITORA GUANABARA KOOGAN LTDA
	cFab	:= "0380795"
	cEmpOri	:= "2022"
ElseIf VAL(ZZL->ZZL_EMPRES) == 2 //LTC-LIVROS TEC. CIENTIFICOS LTDA
	cFab := "0380796"
	cEmpOri	:= "3022"
ElseIf VAL(ZZL->ZZL_EMPRES) == 4 //GEN - GRUPO EDITORIAL NACIONAL PARTICIPA
	cFab := "378803 "
	cEmpOri	:= "1022"
ElseIf VAL(ZZL->ZZL_EMPRES) == 12 //EDITORA FORENSE LTDA
	cFab := "0380794"
	cEmpOri	:= "4022"
ElseIf VAL(ZZL->ZZL_EMPRES) == 28 //EDITORA FORENSE UNIVERSITARIA LTDA
	cFab := "0380794"
	cEmpOri	:= "4022"
ElseIf VAL(ZZL->ZZL_EMPRES) == 30 //AC FARMACEUTICA LTDA
	cFab := "031811 "
	cLoj := "02"
	cEmpOri	:= "6022"
ElseIf VAL(ZZL->ZZL_EMPRES) == 41 //FORUM
	cFab := "0382982"
	cEmpOri	:= "7001"
ElseIf VAL(ZZL->ZZL_EMPRES) == 42 //ATLAS
	cFab := "0378128"
	cLoj := "07"
	cEmpOri	:= "9022"
Else
	cFab := Space(0)
	cEmpOri	:= ""
Endif
If lViaTT_I03
	aAdd(aProduto, {"B1_PROC"		, ZZL->ZZL_EMPRES			, Nil}) //FORNECEDOR PADRAO
Else	
	aAdd(aProduto, {"B1_PROC"		, AllTrim(cFab)				, Nil}) //FORNECEDOR PADRAO
EndIf
aAdd(aProduto, {"B1_LOJPROC"	, cLoj				, Nil}) //LOJA FORNECEDOR PADRAO
aAdd(aProduto, {"B1_NROPAG"		, ZZL->ZZL_NROPAG	, Nil})
/*
If Select("SB1_VLD") > 0
	SB1_VLD->(DbCloseArea())
EndIf

BeginSql Alias "SB1_VLD"
	SELECT X3_CAMPO CAMPO,X3_TITULO TITULO FROM SX3990
	WHERE X3_ARQUIVO = 'SB1'
	AND D_E_L_E_T_ <> '*'
EndSql

SB1_VLD->(DbGotop())
While SB1_VLD->(!EOF())	
	If X3Obrigat(SB1_VLD->CAMPO)
		nPosFd := aScan(aProduto, {|x| AllTrim(x[1]) == AllTrim(SB1_VLD->CAMPO) } )
		If nPosFd > 0
			If Empty(aProduto[nPosFd][2])
				Aadd(aMsgVld, SB1_VLD->CAMPO+"-"+SB1_VLD->TITULO )
			EndIf
		Else
			Aadd(aMsgVld, SB1_VLD->CAMPO+"-"+SB1_VLD->TITULO )
		EndIf
	EndIf	
	SB1_VLD->(DbSkip())
EndDo

SB1_VLD->(DbCloseArea())

If Len(aMsgVld) > 0
	cMsgAux+=" Campo Obrigatorios n„o preenchidos "+chr(13)+chr(10)
	aEval(aMsgVld,{|x| cMsgAux+=x+chr(13)+chr(10) })
	MsgStop(cMsgAux)
	Return .F.
EndIf
*/
aAdd(aSB5, {"B5_FILIAL"		, xFilial("SB5")	, Nil})
aAdd(aSB5, {"B5_COD"		, ZZL->ZZL_COD		, Nil})
aAdd(aSB5, {"B5_CEME"		, AllTrim(ZZL->ZZL_DESC)	, Nil})
aAdd(aSB5, {"B5_2CODBAR"	, ZZL->ZZL_ISBN		, Nil})
aAdd(aSB5, {"B5_UMDIPI"		, cUnExp			, Nil})
aAdd(aSB5, {"B5_UM"			, "UN"				, Nil})
IF "#"+ZZL->ZZL_IDTPPU+"#" $ cTpPubSep
	aAdd(aSB5,{"B5_CONVDIP",	ZZL->ZZL_PESO, Nil})
Else
	aAdd(aSB5,{"B5_CONVDIP",	1, Nil})
EndIF
aAdd(aSB5, {"B5_XPSITEG"	, ZZL->ZZL_PSITEG	, Nil})
aAdd(aSB5, {"B5_XPERCRM"	, ZZL->ZZL_PERCRM	, Nil})
aAdd(aSB5, {"B5_XEMPRES"	, ZZL->ZZL_EMPRES	, Nil})
aAdd(aSB5, {"B5_XDTHALT"	, ZZL->ZZL_DTALTE	, Nil})
aAdd(aSB5, {"B5_XSSERIE"	, ZZL->ZZL_SSERIE	, Nil})
aAdd(aSB5, {"B5_XSUMARI"	, ZZL->ZZL_SUMARI	, Nil})
aAdd(aSB5, {"B5_XERRATA"	, ZZL->ZZL_ERRATA	, Nil})
aAdd(aSB5, {"B5_XDIFERE"	, ZZL->ZZL_DIFERE	, Nil})
aAdd(aSB5, {"B5_XAMOSTR"	, ZZL->ZZL_AMOSTR	, Nil})
//aAdd(aSB5, {"B5_XDESEMP"	, ZZL->ZZL_DESEMP	, Nil})
aAdd(aSB5, {"B5_XEDICAO"	, ZZL->ZZL_EDICAO	, Nil})
aAdd(aSB5, {"B5_XTIPINC"	, ZZL->ZZL_TIPINC	, Nil})
aAdd(aSB5, {"B5_XCODHIS"	, ZZL->ZZL_CODHIS	, Nil})
aAdd(aSB5, {"B5_XDTREIM"	, ZZL->ZZL_DTREIM	, Nil})
aAdd(aSB5, {"B5_XDTPPRE"	, ZZL->ZZL_DTPPRE	, Nil})
aAdd(aSB5, {"B5_XDTPUBL"	, ZZL->ZZL_DTPUBL	, Nil})
aAdd(aSB5, {"B5_XPUBLIP"	, IIF( ZZL->ZZL_PUBLIP == "1" , ZZL->ZZL_PUBLIP, "0" )	, Nil})
aAdd(aSB5, {"B5_XCONSIG"	, IIF( ZZL->ZZL_CONSIG == "1" , ZZL->ZZL_CONSIG, "0" )	, Nil})
aAdd(aSB5, {"B5_XTABPRC"	, IIF( ZZL->ZZL_TABPRC == "1" , ZZL->ZZL_TABPRC, "0" )	, Nil})
aAdd(aSB5, {"B5_XEXPORT"	, ZZL->ZZL_EXPORT	, Nil})
aAdd(aSB5, {"B5_XPSTPRO"	, ZZL->ZZL_PSTPRO	, Nil})
aAdd(aSB5, {"B5_XTPACAB"	, ZZL->ZZL_TPACAB	, Nil})
aAdd(aSB5, {"B5_XFORCAP"	, ZZL->ZZL_FORCAP	, Nil})
aAdd(aSB5, {"B5_XCORMIO"	, ZZL->ZZL_CORMIO	, Nil})
aAdd(aSB5, {"B5_XQTDPAG"	, AllTrim(ZZL->ZZL_QTDPAG)	, Nil})
aAdd(aSB5, {"B5_XTIRPRE"	, AllTrim(ZZL->ZZL_TIRPRE)	, Nil})
aAdd(aSB5, {"B5_XTIRREL"	, AllTrim(ZZL->ZZL_TIRREL)	, Nil})
aAdd(aSB5, {"B5_XMINISI"	, ZZL->ZZL_MINISI	, Nil})
aAdd(aSB5, {"B5_XAUTWEB"	, ZZL->ZZL_AUTWEB	, Nil})
//aAdd(aSB5, {"B5_XTPPROD"	, ZZL->ZZL_TPPROD	, Nil})
//aAdd(aSB5, {"B5_XTPPROD"	, Posicione("ZZT",1,xFilial("ZZT")+AllTrim(ZZL->ZZL_IDTPPU),"ZZT_TIPO")	, Nil})

aAdd(aSB5, {"B5_XCODPRO"	, ZZL->ZZL_CODPRO	, Nil})
aAdd(aSB5, {"B5_XQTDILU"	, ZZL->ZZL_QTDILU	, Nil})
aAdd(aSB5, {"B5_XGRAFIC"	, ZZL->ZZL_GRAFIC	, Nil})
aAdd(aSB5, {"B5_XCODJUR"	, ZZL->ZZL_CODJUR	, Nil})
aAdd(aSB5, {"B5_XTITCON"	, ZZL->ZZL_TITCON	, Nil})
aAdd(aSB5, {"B5_XDETENT"	, ZZL->ZZL_DETENT	, Nil})
aAdd(aSB5, {"B5_XCCOPIA"	, ZZL->ZZL_CCOPIA	, Nil})
aAdd(aSB5, {"B5_XISBNOR"	, ZZL->ZZL_ISBNOR	, Nil})
aAdd(aSB5, {"B5_XSITEBK"	, ZZL->ZZL_SITEBK	, Nil})
aAdd(aSB5, {"B5_XAUTEBK"	, ZZL->ZZL_AUTEBK	, Nil})
aAdd(aSB5, {"B5_XPRECIF"	, ZZL->ZZL_PRECIF	, Nil})
aAdd(aSB5, {"B5_XIDXDIR"	, ZZL->ZZL_IDXDIR	, Nil})
aAdd(aSB5, {"B5_XIDXADI"	, ZZL->ZZL_IDXADI	, Nil})
aAdd(aSB5, {"B5_XCONVER"	, ZZL->ZZL_CONVER	, Nil})
aAdd(aSB5, {"B5_XCONVAD"	, ZZL->ZZL_CONVAD	, Nil})
aAdd(aSB5, {"B5_XVLFIXO"	, ZZL->ZZL_VLFIXO	, Nil})
aAdd(aSB5, {"B5_XSLDADI"	, ZZL->ZZL_SLDADI	, Nil})
aAdd(aSB5, {"B5_XDTCONT"	, ZZL->ZZL_DTCONT	, Nil})
aAdd(aSB5, {"B5_XDTEXPI"	, ZZL->ZZL_DTEXPI	, Nil})
aAdd(aSB5, {"B5_XESTRAN"	, ZZL->ZZL_ESTRAN	, Nil})
aAdd(aSB5, {"B5_XVLRLIQ"	, ZZL->ZZL_VLRLIQ	, Nil})
aAdd(aSB5, {"B5_XSITDIR"	, ZZL->ZZL_SITDIR	, Nil})
aAdd(aSB5, {"B5_XCLASSE"	, ZZL->ZZL_CLASSE	, Nil})
aAdd(aSB5, {"B5_XPRVPRO"	, ZZL->ZZL_PRVPRO	, Nil})
aAdd(aSB5, {"B5_XUSRINC"	, ZZL->ZZL_USRINC	, Nil})
aAdd(aSB5, {"B5_XUSRALT"	, ZZL->ZZL_USRALT	, Nil})
aAdd(aSB5, {"B5_XPRVOLD"	, ZZL->ZZL_PRVOLD	, Nil})
aAdd(aSB5, {"B5_XPRVNEW"	, ZZL->ZZL_PRVNEW	, Nil})
aAdd(aSB5, {"B5_XCUSUNI"	, ZZL->ZZL_CUSUNI	, Nil})
aAdd(aSB5, {"B5_XSEQPUB"	, ZZL->ZZL_SEQPUB	, Nil})
aAdd(aSB5, {"B5_XAREGER"	, ZZL->ZZL_AREGER	, Nil})
aAdd(aSB5, {"B5_XQTDPGR"	, ZZL->ZZL_QTDPGR	, Nil})
aAdd(aSB5, {"B5_XTPENTR"	, ZZL->ZZL_TPENTR	, Nil})
aAdd(aSB5, {"B5_XAUTOR"		, ZZL->ZZL_AUTOR	, Nil})  
aAdd(aSB5, {"B5_XAUTORW"	, ZZL->ZZL_AUTWEB	, Nil})
aAdd(aSB5, {"B5_XCREIMP"	, ZZL->ZZL_COD		, Nil})
aAdd(aSB5, {"B5_XFEC"		, IIF(ZZL->ZZL_FEC=="1","1","0")   	, Nil})
aAdd(aSB5, {"B5_XGRAU"		, ZZL->ZZL_GRAU  	, Nil})
aAdd(aSB5, {"B5_XGENIO"		, ZZL->ZZL_GENIO 	, Nil})
aAdd(aSB5, {"B5_XSELO"		, AllTrim(ZZL->ZZL_SELO)  	, Nil})
aAdd(aSB5, {"B5_XOFERT"		, IIF(ZZL->ZZL_OFERT=="1",'1','0') 	, Nil})
aAdd(aSB5, {"B5_XDESORI"	, Left(ZZL->ZZL_DESC,50) 	, Nil})
aAdd(aSB5, {"B5_XAREA"		, ZZL->ZZL_AREGER 	, Nil})
aAdd(aSB5, {"B5_XCATEG"		, Posicione("ZZV",1,xFilial("ZZV")+ZZL->ZZL_CLASSE,"ZZV_DIDATI") , Nil})

ZZN->(DbSetOrder(1))
IF ZZN->(DbSeek( xFilial("ZZN")+cOriZZN+ZZL->ZZL_COD+"001" ))	
	while ZZN->(!EOF()) .AND. ZZN->ZZN_PRODUT == ZZL->ZZL_COD .AND. ZZN->ZZN_ORIGEM == cOriZZN
		ZZM->(DbSetOrder(1))
		IF ZZM->(DbSeek(xFilial("ZZM")+"001"+ZZN->ZZN_CODCAT))
			cCodMae	:= ZZM->ZZM_CODMAE
			cCodDis := Padl(AllTrim(ZZM->ZZM_CODOLD),TamSX3("B5_XDISCIP")[1],"0")
			IF ZZM->(DbSeek( xFilial("ZZM")+"001"+cCodMae ))
				cCodMae		:= ZZM->ZZM_CODMAE
				cCodCurso	:= Padl(AllTrim(ZZM->ZZM_CODOLD),TamSX3("B5_XCURSO")[1],"0")
				IF ZZM->(DbSeek( xFilial("ZZM")+"001"+cCodMae ))
					IF Padl(AllTrim(ZZM->ZZM_CODOLD),TamSX3("B5_XAREA")[1],"0") == ZZL->ZZL_AREGER						
						Exit
					ENDIF
				ELSE
					cCodCurso	:= ""
					cCodDis		:= ""
				ENDIF	
			ENDIF
		ENDIF

		ZZN->(DbSkip())
	EndDo

	IF !Empty(cCodDis) .AND. !Empty(cCodCurso)
		aAdd(aSB5, {"B5_XDISCIP"	, cCodDis	, Nil})
		aAdd(aSB5, {"B5_XCURSO"		, cCodCurso	, Nil})	
	ELSE
		aAdd(aSB5, {"B5_XDISCIP"	, " " 	, Nil})
		aAdd(aSB5, {"B5_XCURSO"		, " " 	, Nil})	
		IF AllTrim(ZZL->ZZL_SITOBR) == "101"
			U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br"),"Protheus SB5 Area Curso Disciplina GENCAZZL1",;
			"Obra: "+ZZL->ZZL_COD+Chr(13)+Chr(10)+;
			"¡rea Gerencial: "+ZZL->ZZL_AREGER+" "+ AllTrim(Posicione("SZ7",1,XFILIAL("SZ7")+ALLTRIM(M->ZZL_AREGER),"SZ7->Z7_DESC")) +Chr(13)+Chr(10)+;
			Oemtoansi("N„o foi possÌvel identificar o curso e disciplina para a ·rea gerencial informada no Gest„o de Produtos");
			,,,.F.)
		ENDIF
	ENDIF

ELSE
	aAdd(aSB5, {"B5_XDISCIP"	, " " 	, Nil})
	aAdd(aSB5, {"B5_XCURSO"		, " " 	, Nil})
ENDIF
aMsgVld	:= {}
/*
If Select("SB1_VLD") > 0
	SB1_VLD->(DbCloseArea())
EndIf

BeginSql Alias "SB1_VLD"
	SELECT X3_CAMPO CAMPO,X3_TITULO TITULO FROM SX3990
	WHERE X3_ARQUIVO = 'SB5'
	AND D_E_L_E_T_ <> '*'
EndSql

SB1_VLD->(DbGotop())
While SB1_VLD->(!EOF())	
	If X3Obrigat(SB1_VLD->CAMPO)
		nPosFd := aScan(aSB5, {|x| AllTrim(x[1]) == AllTrim(SB1_VLD->CAMPO) } )
		If nPosFd > 0
			If Empty(aSB5[nPosFd][2])
				Aadd(aMsgVld, SB1_VLD->CAMPO+"-"+SB1_VLD->TITULO )
			EndIf
		Else
			Aadd(aMsgVld, SB1_VLD->CAMPO+"-"+SB1_VLD->TITULO )
		EndIf
	EndIf	
	SB1_VLD->(DbSkip())
EndDo

SB1_VLD->(DbCloseArea())

If Len(aMsgVld) > 0
	cMsgAux+=" Campo Obrigatorios n„o preenchidos "+chr(13)+chr(10)
	aEval(aMsgVld,{|x| cMsgAux+=x+chr(13)+chr(10) })
	MsgStop(cMsgAux)
	Return .F.
EndIf
*/
IncProc("Gravando SB1...")

If lViaTT_I03
	CargaTT_I23(aProduto,nOpt,SB1->(Recno()),ZZL->ZZL_COD,aSB5,nOptSB5,SB5->(Recno()),ZZL->ZZL_PRV1,cTab,cEmpOri,ZZL->ZZL_SITOBR)
Else
	If lLogaOri
		CREATE RPCCONN oServer ON  SERVER "10.3.0.56" 			;   //IP do servidor
		PORT  1230           								;   //Porta de conex„o do servidor
		ENVIRONMENT "GESTAOOBRA"       							;   //Ambiente do servidor
		EMPRESA "99"          							;   //Empresa de conex„o
		FILIAL  "01"          							;   //Filial de conex„o
		TABLES  "SB1"	;   //Tabela que ser„o abertas
		MODULO  "SIGAEST"
		
		If ValType(oServer) == "O"														
			oServer:CallProc("RPCSetType", 2)
			aRet	:= oServer:CallProc("U_GENCAZZO",aProduto,nOpt,SB1->(Recno()),ZZL->ZZL_COD,aSB5,nOptSB5,SB5->(Recno()),ZZL->ZZL_PRV1,cTab)
			
			RESET ENVIRONMENT IN SERVER oServer
			CLOSE RPCCONN oServer
			FreeObj(oServer)
		EndIf
	Else
		U_GENCAZZO(aProduto,nOpt,SB1->(Recno()),ZZL->ZZL_COD,aSB5,nOptSB5,SB5->(Recno()),ZZL->ZZL_PRV1,cTab)
	EndIf
EndIf

If ValType(aRet) == "A" .AND. Len(aRet) == 2
	MsgAlert(aRet[2])
EndIf	

Return nil

User Function GENCAZZO(aProduto,nOpt,nRec,cProd,aSB5,nOpcSB5,nRecSB5,nPreco,cTab)

Local aRet		:= Array(2)
Local cPath   	:= "\LogSiga\Produtos\"
Local cErroLg	:= ""
Local cBkpBlq	:= ""
Local cItem		:= "0000"
Local aSldIni 	:= {}
Local nAmz		:= 0

DbSelectarea("SB1")
SB1->(DbSetOrder(1))

If nOpt <> 3
	SB1->(DbGoto(nRec))
EndIf

Private lMsErroAuto	:= .F.
Private lMSHelpAuto	:= .F.

MSExecAuto({|x,y| Mata010(x,y)},aProduto,nOpt)

If lMSErroAuto
	WFForceDir(cPath)
	//lErro := .T.
	cFile := Dtos(dDataBase) + " - Produto "+Alltrim(cProd)+".log"	
	cErroLg	:= MostraErro(cpath,cfile)
				
	aRet[1] := .T.
	aRet[2] := "alteraÁ„o n„o replicada para o cadastro de produtos, verifique o erro indicado na mensagem e tente novamente!"+Chr(13)+Chr(10)+cErroLg
	lMsErroAuto := .F.
	lMSHelpAuto	:= .F.
Else
	SB1->(DbSeek( xFilial("SB1")+cProd ))
	nRec	:= SB1->(Recno())
	cBkpBlq := SB1->B1_MSBLQL
	If SB1->B1_MSBLQL == "1"
		RecLock("SB1",.F.)
		SB1->B1_MSBLQL := "1"
		MsUnlock()
	EndIf

	lMsErroAuto := .F.
	lMSHelpAuto	:= .F.
		
	MSExecAuto({|x,y| Mata180(x,y)},aSB5,nOpcSB5)
	
	SB1->(DbGoTo(nRec))
	If SB1->B1_MSBLQL == cBkpBlq
		RecLock("SB1",.F.)
		SB1->B1_MSBLQL := cBkpBlq
		MsUnlock()
	EndIf

	If lMSErroAuto
		WFForceDir(cPath)
		//lErro := .T.
		cFile := Dtos(dDataBase) + " - Produto "+Alltrim(cProd)+"sb5.log"	
		cErroLg	:= MostraErro(cpath,cfile)
						
		aRet[1] := .T.
		aRet[2] := "AlteraÁ„o n„o replicada para o cadastro de produtos, verifique o erro indicado na mensagem e tente novamente!"+Chr(13)+Chr(10)+cErroLg
		lMsErroAuto := .F.
		lMSHelpAuto	:= .F.
	Else
		aRet[1] := .F.
		aRet[2] := "Produto criado com sucesso no Protheus!"
		
		If SB1->B1_MSBLQL <> "1"						
			If nPreco > 0
				If Select("DA1_TMP") > 0
					DA1_TMP->(DbcloseArea())
				EndIf
				
				BeginSql Alias "DA1_TMP" 
					SELECT MAX(DA1_ITEM) ITEM FROM %Table:DA1% 
					WHERE DA1_CODTAB = %Exp:cTab% 
					AND D_E_L_E_T_ <> '*'
				EndSql
				DA1_TMP->(DbGotop())
				cItem := DA1_TMP->ITEM
			
				DA1->(DbSetOrder(1))
				If !DA1->(DbSeek(xFilial("DA1")+cTab+SB1->B1_COD)) //SE ENCONTRAR, ATUALIZA SOMENTE O PRECO
					cItem := Soma1(cItem)
					Reclock("DA1",.T.)
					DA1->DA1_FILIAL	:= xFilial("DA1")
					DA1->DA1_ITEM	:= cItem
					DA1->DA1_CODTAB	:= cTab
					DA1->DA1_CODPRO	:= SB1->B1_COD
				Else
					Reclock("DA1",.F.)
				Endif
				
				DA1->DA1_PRCVEN	:= nPreco
				DA1->DA1_ATIVO	:= "1"
				DA1->DA1_TPOPER	:= "4"
				DA1->DA1_QTDLOT	:= 999999.99
				DA1->DA1_INDLOT	:= "000000000999999.99"
				MsUnlock()
				
				If !DA1->(DbSeek(xFilial("DA1")+cTab+SB1->B1_COD))
					aRet[1] := .T.
					aRet[2] := "AlteraÁ„o n„o replicada para o cadastro de produtos, verifique o erro indicado na mensagem e tente novamente!"+Chr(13)+Chr(10)+"Falha ao gravar na tabela DA1 (PreÁo)"					
				Endif
			Endif			
		EndIf

		For nAmz := 1 to 5
			SB9->(DbSetOrder(1))
			If !SB9->(dbSeek(xFilial("SB9")+SB1->B1_COD+Strzero(nAmz,2)))
				
				aSldIni  := {}
				aAdd(aSldIni  ,{"B9_COD"	, SB1->B1_COD		,Nil})
				aAdd(aSldIni  ,{"B9_LOCAL"	, Strzero(nAmz,2)	,Nil})
				aAdd(aSldIni  ,{"B9_QINI"	, 0					,Nil})

				lMsErroAuto := .F.
				lMSHelpAuto	:= .F.
						
				MsExecAuto({|x,y,z|MATA220(x,y,z)},aSldIni,3)
				
				If lMSErroAuto
					cFile	:= Dtos(dDataBase) + " - Produto "+Alltrim(SB1->B1_COD)+" (saldo GEN).log"
					cErroLg	:= MostraErro(cpath,cfile)

					aRet[1] := .T.
					aRet[2] := "AlteraÁ„o n„o replicada para o cadastro de produtos, verifique o erro indicado na mensagem e tente novamente!"+Chr(13)+Chr(10)+cErroLg
					lMsErroAuto := .F.
					lMSHelpAuto	:= .F.							
				Endif				
			Endif
		Next nAmz

		lB9Ori	:= .T.
		cBkpFil	:= cFilAnt
		
		Do Case
			Case SB1->B1_PROC == "0380795"
				cFilAnt := "2022"
			Case SB1->B1_PROC == "0380796"
				cFilAnt := "3022"
			Case SB1->B1_PROC == "378803 "
				lB9Ori	:= .F.
			Case SB1->B1_PROC == "0380794"
				cFilAnt := "4022"
			Case SB1->B1_PROC == "031811 "
				cFilAnt := "6022"
			Case SB1->B1_PROC == "0382982"
				lB9Ori	:= .F.
			Case SB1->B1_PROC == "0378128"
				cFilAnt := "9022"
			OtherWise
				lB9Ori	:= .F.
		EndCase
		
		If lB9Ori .AND. .f. // ESTE .f. EST¡ AQUI PARA N√O ENTRAR NO LOOP POIS ESTAS FILIAIS N√O EXISTEM NA BASE TESTE
			SB9->(DbSetOrder(1))
			If !SB9->(dbSeek(xFilial("SB9")+SB1->B1_COD+"01"))				
				aSldIni  := {}
				aAdd(aSldIni  ,{"B9_COD"	, SB1->B1_COD		,Nil})
				aAdd(aSldIni  ,{"B9_LOCAL"	, "01"				,Nil})
				aAdd(aSldIni  ,{"B9_QINI"	, 0					,Nil})

				lMsErroAuto := .F.
				lMSHelpAuto	:= .F.
						
				MsExecAuto({|x,y,z|MATA220(x,y,z)},aSldIni,3)
				
				If lMSErroAuto
					cFile	:= Dtos(dDataBase) + " - Produto "+Alltrim(SB1->B1_COD)+" (saldo GEN).log"
					cErroLg	:= MostraErro(cpath,cfile)

					aRet[1] := .T.
					aRet[2] := "AlteraÁ„o n„o replicada para o cadastro de produtos, verifique o erro indicado na mensagem e tente novamente!"+Chr(13)+Chr(10)+cErroLg
					lMsErroAuto := .F.
					lMSHelpAuto	:= .F.							
				Endif
			Endif			
		EndIf
		
		cFilAnt	:= cBkpFil
		
	EndIf
EndIf

Return aRet 

User Function GENCAZZS()

Local lRet			:= .F.
Local aDados		:= {}
Local aPosObj    	:= {} 
Local aObjects   	:= {}                        
Local aSize      	:= MsAdvSize() 
Local aInfo			:= {}
Local aColsZZN		:= {}

Local bConfirm		:= {|| lRet := .T.,oDlgCre:End() }
Local bCancel		:= {|| lRet := .F.,oDlgCre:End() }
Local aButtons		:= {}

Local oDlgCre		:= Nil
Local nWidth 		:= 50
Local oFont			:= Nil
Local oTFont 		:= TFont():New('Courier new',,-18,.T.)
Local cCadastro		:= "Sites Gen"

Local nMbrWidth		:= 0
Local nMbrHeight	:= 0

Local aAlter		:= {"ZZN_CODCAT"}

Local aHeadAux		:= {}
Local aLinMod		:= {}
Local nFreeze		:= 0
Local nUsado		:= 0
Local aVirtual		:= {}
Local aVisual		:= {}
Local aNotFields	:= {"ZZN_FILIAL","ZZN_PRODUT","ZZN_ORIGEM"}
Local lAllFields	:= .F.
Local lNotVirtual	:= .F.
Local uGhostBmpCol	:= .F.
Local lOnlyNotFields:= .F.
Local lChkX3Uso		:= .T.
Local lChkNivel		:= .F.
Local lNumGhostCol	:= .F.
Local lCposUser		:= .F.
Local nForAc		:= 0
Local oMainTop		:= nil
Local oTBut1		:= nil
Private oDados		:= nil

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø         
//≥Define a area dos objetos                             ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
aObjects := {} 
Aadd( aObjects, { 50, 50, .t., .t. } )
Aadd( aObjects, { 50, 50, .F., .F. } )

aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 

If aSize[3] == 0
	aSize :=  {0,0,800,800,1800,800,0}
EndIf	

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Monta a tela                                                                    ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Define Dialog oDlgCre 	Title cCadastro ;
					From 00,00 TO 500,1000 ;
					 /*STYLE nOR(WS_VISIBLE,WS_POPUP)*/ PIXEL
					
//oDlgCre:lMaximized := .T.
oDlgCre:SetColor(CLR_BLACK,CLR_WHITE)
oDlgCre:SetFont(oFont)


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Armazena as corrdenadas da tela                                                 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
nMbrWidth	:= oDlgCre:nWidth/2-43
nMbrHeight	:= oDlgCre:nHeight/2
			
@00,00 MSPANEL oMainTop PROMPT "" SIZE 40,40 of oDlgCre
oMainTop:Align := CONTROL_ALIGN_TOP

oTBut1 := TButton():New( 10, 10, "Incluir", oMainTop,{|x| U_GENCAZZN() }, 50,15,,,.F.,.T.,.F.,,.F.,{|| .T. },,.F. )
oTBut2 := TButton():New( 10, 70, "Confirmar", oMainTop,bConfirm, 50,15,,,.F.,.T.,.F.,,.F.,{|| .T. },,.F. )
oTBut3 := TButton():New( 10, 130, "Cancelar", oMainTop,bCancel, 50,15,,,.F.,.T.,.F.,,.F.,{|| .T. },,.F. )

@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgCre
oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT

oGrpXML		:= TGroup():New(05,05,(oMainCentro:NCLIENTHEIGHT/2)-40,(oMainCentro:NCLIENTWIDTH/2)-10,"Produtos x Site x Categorias",oMainCentro,CLR_RED,,.T.)

cSeek   := ZZL->ZZL_FILIAL + PadR("GENCAZZL",TamSX3("ZZN_ORIGEM")[1]) + ZZL->ZZL_COD
cWhile  := "ZZN->ZZN_FILIAL + ZZN->ZZN_ORIGEM + ZZN->ZZN_PRODUT"
FillGetDados(4,"ZZN",1,cSeek,{|| &cWhile },,aNotFields,/*alYesFields*/,/*.T.*/,/*cQuery*/,/*bMontCols*/,.f.,aHeadAux,aColsZZN,/*bAfterCols*/,/*bBeforeCols*/)

oDados := MsNewGetDados():New( 15,10,(oMainCentro:NCLIENTHEIGHT/2)-45,(oMainCentro:NCLIENTWIDTH/2)-15, GD_DELETE, "AllwaysTrue", "AllwaysTrue", nil, aAlter,nFreeze, 999, "AllwaysTrue", "", "AllwaysTrue", oMainCentro, aHeadAux, aColsZZN)

Activate MsDialog oDlgCre Centered//On Init EnchoiceBar(oDlgCre,bConfirm,bCancel,,aButtons) 

If lRet
	Begin Transaction
		For nForAc := 1 To Len(oDados:aCols)
			
			If Empty(oDados:aCols[nForAc][GdFieldPos("ZZN_CODCAT",oDados:aHeader)])
				LOOP
			EndIf
			
			If oDados:aCols[nForAc][GdFieldPos("ZZN_REC_WT",oDados:aHeader)] <> 0
				lNewZZN := .F. 
				ZZN->(DbGoTo( oDados:aCols[nForAc][GdFieldPos("ZZN_REC_WT",oDados:aHeader)] ))
			Else
				lNewZZN := .T.
			EndIf
			
			If GdDeleted( nForAc , oDados:aHeader , oDados:aCols ) .AND. !lNewZZN			
				RecLock("ZZN",.F.)
				ZZN->(DbDelete())
				MsUnLock()
			ElseIf !GdDeleted( nForAc , oDados:aHeader , oDados:aCols )
				RecLock("ZZN",lNewZZN)
				ZZN->ZZN_FILIAL	:= xFilial("ZZN")
				ZZN->ZZN_PRODUT	:= ZZL->ZZL_COD
				ZZN->ZZN_CODSIT	:= oDados:aCols[nForAc][GdFieldPos("ZZN_CODSIT",oDados:aHeader)]
				ZZN->ZZN_CODCAT	:= oDados:aCols[nForAc][GdFieldPos("ZZN_CODCAT",oDados:aHeader)]
				ZZN->ZZN_DESC	:= oDados:aCols[nForAc][GdFieldPos("ZZN_DESC",oDados:aHeader)]
				ZZN->ZZN_ORIGEM	:= PadR("GENCAZZL",TamSX3("ZZN_ORIGEM")[1])
				MsUnLock()
			EndIf
		Next nForAc

		RecLock("ZZL",.F.)
		ZZL->ZZL_DTALTE	:= DDataBase
		ZZL->ZZL_HALTER	:= Time()
		ZZL->ZZL_USRALT	:= AllTrim(UsrRetName(RetCodUsr()))
		MsUnLock()

	End Transaction	
EndIf

Return nil 

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GENCAZZL  ∫Autor  ≥Cleuto Lima         ∫ Data ≥  09/08/2019 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Integra as cobras com a rotina TT_I03_PRODUTOS              ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ GEN - Projeto Gest„o de Obras                              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static function CargaTT_I23(aProduto,nOpt,nRec,cProd,aSB5,nOpcSB5,nRecSB5,nPreco,cTab,cEmpOri,cSitObr)

//Local aFldTT	:= {'B1_COD','B1_DESC','B1_PROC','B1_TIPO','B1_UM','B1_LOCPAD','B1_GRUPO','B1_ORIGEM','B1_TNATREC','B1_MSBLQL','B1_CODBAR','B1_ISBN','B1_POSIPI','PRECO','PRECONOVO','B1_PESO','B1_XSITOBR','B1_XEMPRES','B1_XIDMAE','B1_XIDTPPU','B1_XPERCRM','B1_XPSITEG','B1_CC','B1_XCC','B5_CEME','B5_XCODHIS','B5_XAUTOR','B5_XAUTORW','B5_XCREIMP','B5_XDTPUBL','B5_XFEC','B5_XGRAU','B5_XTPACAB','B5_XFORCAP','B5_XCORMIO','B5_XTIRPRE','B5_XTIRREL','B5_XGENIO','B5_XPUBLIP','B5_XDTPPRE','B5_XMINISI','B5_XTIPINC','B5_XSELO','B5_XEDICAO','B5_XQTDPAG','B5_XOFERT','B5_XEXPORT','B5_XTABPRC','B5_XDESORI','B5_XCONSIG','B5_XPSTPRO','B5_XOBRINT','B5_XDTREIM','B5_XCATEG','B5_XDISCIP','B5_XCURSO','B5_XAREA','BOM','CONSIGNACAO','EMPORIG','QTDORIG','B5_UMDIPI','B5_CONVDIP','DTHRALT','UPD'}
Local aFldTT	:= {'B1_COD','B1_DESC','B1_PROC','B1_TIPO','B1_UM','B1_LOCPAD','B1_GRUPO','B1_ORIGEM','B1_TNATREC','B1_MSBLQL','B1_CODBAR','B1_ISBN','B1_POSIPI','B1_PESO','B1_XSITOBR','B1_XEMPRES','B1_XIDMAE','B1_XIDTPPU','B1_XPERCRM','B1_XPSITEG','B1_CC','B1_XCC','B5_CEME','B5_XCODHIS','B5_XAUTOR','B5_XAUTORW','B5_XCREIMP','B5_XDTPUBL','B5_XFEC','B5_XGRAU','B5_XTPACAB','B5_XFORCAP','B5_XCORMIO','B5_XTIRPRE','B5_XTIRREL','B5_XGENIO','B5_XPUBLIP','B5_XDTPPRE','B5_XMINISI','B5_XTIPINC','B5_XSELO','B5_XEDICAO','B5_XQTDPAG','B5_XOFERT','B5_XEXPORT','B5_XTABPRC','B5_XDESORI','B5_XCONSIG','B5_XPSTPRO','B5_XDTREIM','B5_XAREA','B5_UMDIPI','B5_CONVDIP'}
Local aAllFld	:= {}
Local nAux		:= 0 
Local cNoField	:= ""
Local lRet		:= .T.
Local cQueryINS	:= "INSERT INTO DBA_EGK.TT_I03_PRODUTO_TB (PRECO,PRECONOVO,B5_XOBRINT,BOM,CONSIGNACAO,EMPORIG,QTDORIG,DTHRALT,UPD,B1_MSBLQL,"
Local cValues	:= " VALUES ("+cValToChar(nPreco)+",0,'0',0,0,'"+cEmpOri+"',0,SYSDATE,0,"+IIF( cSitObr <> "103" , "2" , "1" )+","
Local nPosFld	:= 0
Local nPosStr	:= 0
Local aStruTmp	:= {}

IF Select("STR_TMP_TT") > 0
	STR_TMP_TT->(DbCloseArea())
endIf

BEGINSQL ALIAS "STR_TMP_TT"
	SELECT TB.* FROM DBA_EGK.TT_I03_PRODUTO_TB TB
	WHERE ROWNUM <= 1
ENDSQL

aStruTmp := STR_TMP_TT->(DbStruct())
STR_TMP_TT->(DbCloseArea())

aEval(aProduto, {|x| aadd(aAllFld,aClone(x)) } )
aEval(aSB5, {|x| aadd(aAllFld,aClone(x)) } )

For nAux := 1 To Len(aStruTmp)
	IF AllTrim(aStruTmp[nAux][1]) $ cQueryINS
		Loop
	ENDIF

	cQueryINS += AllTrim(aStruTmp[nAux][1])+","
	nPosFld := aScan(aAllFld,{|x| AllTrim(x[1]) == AllTrim(aStruTmp[nAux][1]) })	
	IF nPosFld == 0
		If aScan(aAllFld,{|x| AllTrim(x[1]) == AllTrim(aStruTmp[nAux][1]) }) == 0
			cNoField+= AllTrim(aStruTmp[nAux][1]) +", "
		else
			cValues += "null,"			
		EndIf
	Else
		cValues += DeToTipo(aAllFld[nPosFld][2],ValType(aAllFld[nPosFld][2]),aStruTmp[nAux][2])+","
	EndIf
Next

/*
For nAux := 1 To Len(aFldTT)
	nPosStr	:= aScan(aStruTmp,{|x| AllTrim(x[1]) == AllTrim(aFldTT[nAux]) })
	nPosFld := aScan(aAllFld,{|x| AllTrim(x[1]) == AllTrim(aFldTT[nAux]) })
	If nPosFld == 0
		cNoField+= AllTrim(aFldTT[nAux])+", "
	Else
		cQueryINS += AllTrim(aFldTT[nAux])+","
		Do Case
			Case ValType(aAllFld[nPosFld][2]) == "D"
				cValues += "'"+DtoS(aAllFld[nPosFld][2])+"',"
			Case ValType(aAllFld[nPosFld][2]) == "N"
				cValues += cValToChar(aAllFld[nPosFld][2])+","
			OtherWise
				If Empty(AllTrim(aAllFld[nPosFld][2]))
					If TamSX3(AllTrim(aAllFld[nPosFld][1]))[3] == "N"
						cValues += ","
					else
						cValues += "' ',"	
					endIf	
				Else					
					If AllTrim(aAllFld[nPosFld][1]) == "N"
						cValues += ""+AllTrim(aAllFld[nPosFld][2])+","
					else
						cValues += "'"+AllTrim(aAllFld[nPosFld][2])+"',"	
					endIf	
				EndIf	
		EndCase
	EndIf
Next
*/

cQueryINS	:= Left(cQueryINS,Len(cQueryINS)-1)
cValues	:= Left(cValues,Len(cValues)-1)
 
If !Empty(cNoField)
	cNoField := Left(cNoField,Len(cNoField)-2)
	xMagHelpFis("Casdastro de Produto","N„o foi possÌvel cadastrar o produto Protheus, verifique os campos a seguir!",cNoField)
	Return .F.
EndIf

cQueryINS+=")" + cValues+")"
IF TCSqlExec(cQueryINS) < 0
	xMagHelpFis("IntegraÁ„o SB1", "TCSQLError()" + TCSQLError(), "Entre em contato com a TI" )
	Return .F.
EndIF

Return lRet

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GENCP001  ∫Autor  ≥Cleuto Lima         ∫ Data ≥  09/08/2019 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Cadastro de atividades 	                                  ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ GEN - Projeto Gest„o de Obras                              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function GENCP001(cOrigem)

Local lRet			:= .F.
Local aDados		:= {}
Local aPosObj    	:= {} 
Local aObjects   	:= {}                        
Local aSize      	:= MsAdvSize() 
Local aInfo			:= {}
Local aColsZZJ		:= {}

Local bConfirm		:= {|| lRet := .T.,oDlgCre:End() }
Local bCancel		:= {|| lRet := .F.,oDlgCre:End() }
Local aButtons		:= {}

Local oDlgCre		:= Nil
Local nWidth 		:= 50
Local oFont			:= Nil
Local oTFont 		:= TFont():New('Courier new',,-18,.T.)
Local cCadastro		:= "Controle de Atividades"

Local nMbrWidth		:= 0
Local nMbrHeight	:= 0

Local aAlter		:= {"ZZJ_DATA","ZZJ_HORA","ZZJ_OBS","ZZJ_OBSTEX"}

Local aHeadAux		:= {}
Local aLinMod		:= {}
Local nFreeze		:= 0
Local nUsado		:= 0
Local aVirtual		:= {}
Local aVisual		:= {}
Local aNotFields	:= {"ZZJ_FILIAL","ZZJ_PRODUT"}
Local lAllFields	:= .F.
Local lNotVirtual	:= .F.
Local uGhostBmpCol	:= .F.
Local lOnlyNotFields:= .F.
Local lChkX3Uso		:= .T.
Local lChkNivel		:= .F.
Local lNumGhostCol	:= .F.
Local lCposUser		:= .F.
Local nForAc		:= 0
Local cChave		:= ""
Local oSay1			:= nil
Local oMainButton	:= nil
Local oMainTop		:= nil
Local oBtSave		:= nil

Private oDados		:= nil

Default cOrigem := "1"

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø         
//≥Define a area dos objetos                             ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
aObjects := {} 
Aadd( aObjects, { 50, 50, .t., .t. } )
Aadd( aObjects, { 50, 50, .F., .F. } )

aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 

If aSize[3] == 0
	aSize :=  {0,0,800,800,1800,800,0}
EndIf	

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Monta a tela                                                                    ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Define Dialog oDlgCre 	Title cCadastro ;
					From 00,00 TO 500,1000 ;
					 STYLE nOR(WS_VISIBLE,WS_POPUP) PIXEL
					
//oDlgCre:lMaximized := .T.
oDlgCre:SetColor(CLR_BLACK,CLR_WHITE)
oDlgCre:SetFont(oFont)


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Armazena as corrdenadas da tela                                                 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
nMbrWidth	:= oDlgCre:nWidth/2-43
nMbrHeight	:= oDlgCre:nHeight/2

oGrpXML:= TGroup():New(00,00,00,00,"",oDlgCre,CLR_BLUE,,.T.)
oGrpXML:Align := CONTROL_ALIGN_ALLCLIENT

@010,010 MSPANEL oMainAll PROMPT "" SIZE (oDlgCre:NCLIENTWIDTH/2)-20,(oDlgCre:NCLIENTHEIGHT/2)-20 of oDlgCre

@00,00 MSPANEL oMainTop PROMPT "" SIZE 20,20 of oMainAll
oMainTop:Align := CONTROL_ALIGN_TOP

oSay1:= TSay():New(05,10,{|| "<h2>Controle de Atividades<h2>" },oMainTop,,,,,,.T.,CLR_BLUE,,130,50,,,,,,.T.)

@00,00 MSPANEL oMainButton PROMPT "" SIZE 30,30 of oMainAll
oMainButton:Align := CONTROL_ALIGN_BOTTOM

@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oMainAll
oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT

IF cOrigem == "1"
	cChave	:= ZZL->ZZL_COD	
ELSE	
	cChave	:= ZZE->ZZE_PPE
ENDIF	

cSeek   := xFilial("ZZJ") + cOrigem + cChave
cWhile  := "ZZJ->ZZJ_FILIAL + ZZJ->ZZJ_ORIGEM + ZZJ->ZZJ_PRODUT"
FillGetDados(4,"ZZJ",1,cSeek,{|| &cWhile },,aNotFields,/*alYesFields*/,/*.T.*/,/*cQuery*/,/*bMontCols*/,.f.,aHeadAux,aColsZZJ,/*bAfterCols*/,/*bBeforeCols*/)

oDados := MsNewGetDados():New( 15,10,10,10, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", nil, aAlter,nFreeze, 999, "AllwaysTrue", "", "u_GENCP003", oMainCentro, aHeadAux, aColsZZJ)
oDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

oBtSave	:= TButton():New( 05, 010, "CONFIRMAR"	, oMainButton,bConfirm,80,020,,oFont,,.T.)
oBtSave:SetCss( "QPushButton{ background-color:rgb(28,157,189);}" )

Activate MsDialog oDlgCre Centered// On Init EnchoiceBar(oDlgCre,bConfirm,bCancel,,aButtons) Centered

If lRet
	Begin Transaction
		For nForAc := 1 To Len(oDados:aCols)
			
			If Empty(oDados:aCols[nForAc][GdFieldPos("ZZJ_DATA",oDados:aHeader)]) .OR. ;
				( Empty(oDados:aCols[nForAc][GdFieldPos("ZZJ_OBSTEX",oDados:aHeader)]) .AND. ;
				Empty(oDados:aCols[nForAc][GdFieldPos("ZZJ_OBS",oDados:aHeader)]) )

				LOOP
			EndIf
			
			If oDados:aCols[nForAc][GdFieldPos("ZZJ_REC_WT",oDados:aHeader)] <> 0
				lNewZZJ := .F. 
				ZZJ->(DbGoTo( oDados:aCols[nForAc][GdFieldPos("ZZJ_REC_WT",oDados:aHeader)] ))
			Else
				lNewZZJ := .T.
			EndIf
			
			If GdDeleted( nForAc , oDados:aHeader , oDados:aCols ) .AND. !lNewZZJ
				RecLock("ZZJ",.F.)
				ZZJ->(DbDelete())
				MsUnLock()
			ElseIf !GdDeleted( nForAc , oDados:aHeader , oDados:aCols )
				RecLock("ZZJ",lNewZZJ)
				ZZJ->ZZJ_FILIAL	:= xFilial("ZZJ")
				ZZJ->ZZJ_PRODUT	:= cChave
				ZZJ->ZZJ_DATA  	:= oDados:aCols[nForAc][GdFieldPos("ZZJ_DATA",oDados:aHeader)]
				ZZJ->ZZJ_HORA  	:= oDados:aCols[nForAc][GdFieldPos("ZZJ_HORA",oDados:aHeader)]
				ZZJ->ZZJ_OBS   	:= oDados:aCols[nForAc][GdFieldPos("ZZJ_OBS",oDados:aHeader)]
				ZZJ->ZZJ_USER  	:= oDados:aCols[nForAc][GdFieldPos("ZZJ_USER",oDados:aHeader)]
				IF Empty(ZZJ->ZZJ_USER)
					ZZJ->ZZJ_USER := UsrRetName(RetCodUsr())
				ENDIF
				ZZJ->ZZJ_OBSTEX	:= oDados:aCols[nForAc][GdFieldPos("ZZJ_OBSTEX",oDados:aHeader)]
				ZZJ->ZZJ_ORIGEM	:= cOrigem
				ZZJ->ZZJ_TIPO	:= oDados:aCols[nForAc][GdFieldPos("ZZJ_TIPO",oDados:aHeader)] // 00=ObservaÁ„o ; 01 = ConsideraÁ„o de aprovaÁ„o
				MsUnLock()
			EndIf
		Next nForAc
	End Transaction	
EndIf

Return nil 

User Function GENCP002(cVld)

Local lRet	:= .T.
//AllTrim(M->ZZJ_USER) == AllTrim(UsrRetName(RetCodUsr()))    

If cVld == "VALID" .or. cVld == "WHEN"
	IF AllTrim(oDados:aCols[oDados:oBrowse:nAt][GdFieldPos("ZZJ_USER",oDados:aHeader)]) <> AllTrim(UsrRetName(RetCodUsr()))
		lRet	:= .F.
		IF cVld == "VALID"
			MsgStop("Apenas o usu·rio que incluiu a atividade pode alterala!")
		EndIF
	EndIF	
EndIf

Return lRet

User Function GENCP003()

Local lRet	:= .T.

IF oDados:aCols[oDados:oBrowse:nAt][GdFieldPos("ZZJ_REC_WT",oDados:aHeader)] <> 0 .OR.;
	AllTrim(oDados:aCols[oDados:oBrowse:nAt][GdFieldPos("ZZJ_USER",oDados:aHeader)]) <> AllTrim(UsrRetName(RetCodUsr()))
	lRet	:= .F.
	MsgStop("N„o È possÌvel deletar registros j· salvos!")
EndIF	

Return lRet

Static Function DeToTipo(xConteudo,cDeTipo,cParaTipo)

Local cRet	:= ""

Do Case
	Case cDeTipo == "C" .AND. cParaTipo == "N"
		cRet	:= cValToChar(Val(xConteudo))
	Case cDeTipo == "D" .AND. cParaTipo == "C"
//		cRet	:= "'"+DtoC(xConteudo)+"'"
		cRet	:= "'"+DtoS(xConteudo)+"'"
//	Case cDeTipo == "D" .AND. cParaTipo == "S"
//		cRet	:= "'"+DtoS(xConteudo)+"'"
	Case cDeTipo == "N" .AND. cParaTipo == "C"
		cRet	:= "'"+cValToChar(xConteudo)+"'"
	Case cDeTipo == "N" .AND. cParaTipo == "N"
		cRet	:= cValToChar(xConteudo)
	Case cDeTipo == "C" .AND. cParaTipo == "C"
		cRet	:= "'"+AllTrim(xConteudo)+"'"
EndCase

Return cRet

Static function GerIdProd(oObj)

ZZW->(DbSetOrder(1))
IF !ZZW->(Dbseek(xFilial("ZZW")+ZZL->ZZL_COD+ZZL->ZZL_COD))
	RecLock("ZZW",.T.)
	ZZW->ZZW_FILIAL	:= xFilial("ZZW")
	ZZW->ZZW_CODPRO	:= ZZL->ZZL_COD
	ZZW->ZZW_ITEM  	:= 1
	ZZW->ZZW_IDPROD	:= ZZL->ZZL_COD
	ZZW->ZZW_DTREIM	:= ZZL->ZZL_DTPUBL
	ZZW->ZZW_DTPUB	:= ZZL->ZZL_DTPUBL
	ZZW->ZZW_DTPREV	:= ZZL->ZZL_DTPPRE
	ZZW->ZZW_TIRPRE	:= Val(ZZL->ZZL_TIRREL)
	ZZW->ZZW_SITUAC	:= "2"
	MsUnLock()	
ENDIF

U_GENA093C(ZZW->ZZW_IDPROD,ALLTRIM(ZZL->ZZL_DESC),ZZL->ZZL_COD)

Return nil

User Function GenRetUsr()

Local i
Local cMsg		:= ""
Local aInfo 	:= GetUserInfoArray(.F.)
Local nQtdUser	:= 0
  
for i := 1 to Len(aInfo)
	//cMsg += "User: "+aInfo[i][1]+" Maquina: "+aInfo[i][2]+" ThreadID:" + cvaltochar(aInfo[i][3]) + " Program:" + aInfo[i][5] + " Obs:" + aInfo[i][11] + chr(13)+chr(10)+"<br/>"
	//IF aInfo[i][8] >= "00:59:00"
		nQtdUser++
	//ENDIF
next

Return cValToChar(nQtdUser)

User Function GenRetWeb(xParam)
Local cRet	:= ""

RpcSetenv(HttpGet->EMP,HttpGet->FILIAL)
ZZL->(DbSetOrder(1))
IF ZZL->(DbSeek( xFilial("ZZL")+HttpGet->IDOBRA ))
	cRet := '{"STATUS":"SUCESSO","ZZL_CEME":"'+ALLTRIM(ZZL->ZZL_CEME)+'","ZZL_AUTWEB":"'+ALLTRIM(ZZL->ZZL_AUTWEB)+'", "TESTE":"'+MyAltCarEsp(ALLTRIM(ZZL->ZZL_CEME))+'"} '
else
	cRet := '{"STATUS":"FALHA, OBRA N√O LOCALIZADA"}'
EndIF


Return cRet

Static Function MyAltCarEsp(cTexto, lVirgula)

	Local cRet := ""
	
	Default	cTexto		:= ""
	
	Default	lVirgula	:= .F.
	
	cRet := cTexto
	cRet := Replace(cRet,'-','')
	cRet := Replace(cRet,'≈','&Aring;')
	cRet := Replace(cRet,'Â','&aring;')
	cRet := Replace(cRet,'ƒ','&Auml;')
	cRet := Replace(cRet,'‰','&auml;')
	cRet := Replace(cRet,'∆','&AElig;')
	cRet := Replace(cRet,'Ê','&aelig;')
	cRet := Replace(cRet,'À','&Euml;')
	cRet := Replace(cRet,'Î','&euml;')
	cRet := Replace(cRet,'–','&ETH;')
	cRet := Replace(cRet,'','&eth;')
	cRet := Replace(cRet,'œ','&Iuml;')
	cRet := Replace(cRet,'Ô','&iuml;')
	cRet := Replace(cRet,'ÿ','&Oslash;')
	cRet := Replace(cRet,'¯','&oslash;')
	cRet := Replace(cRet,'÷','&Ouml;')
	cRet := Replace(cRet,'ˆ','&ouml;')
	cRet := Replace(cRet,'‹','&Uuml;')
	cRet := Replace(cRet,'¸','&uuml;')
	cRet := Replace(cRet,'<','&lt;')
	cRet := Replace(cRet,'>','&gt;')
	cRet := Replace(cRet,'&','&amp;')
	cRet := Replace(cRet,'"','&quot;')
	cRet := Replace(cRet,'Æ','&reg;')
	cRet := Replace(cRet,'©','&copy;')
	cRet := Replace(cRet,'›','&Yacute;')
	cRet := Replace(cRet,'˝','&yacute;')
	cRet := Replace(cRet,'ﬁ','&THORN;')
	cRet := Replace(cRet,'˛','&thorn;')
	cRet := Replace(cRet,'ﬂ','&szlig;')   
	cRet := Replace(cRet,"'",'&#39;')
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Remove caracteres especiais de espaco                             ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	cRet := Replace(cRet, chr(2), "")
	cRet := Replace(cRet, chr(9), "")
	cRet := Replace(cRet, chr(28), "")
	cRet := Replace(cRet, chr(29), "")
	cRet := Replace(cRet, chr(30), "")
	cRet := Replace(cRet, chr(31), "")
	cRet := Replace(cRet, chr(129), "")
	cRet := Replace(cRet, chr(141), "")
	cRet := Replace(cRet, chr(143), "")
	cRet := Replace(cRet, chr(144), "")
	cRet := Replace(cRet, chr(157), "")
	cRet := Replace(cRet, chr(160), "")

Return cRet


User Function GENCAZZN()

Local oDlgClass	:= nil
Local oGrpAll	:= nil
Local oPntAll	:= nil
Local oSayQuest	:= nil

Local oBtSave	:= nil
Local oPBottom	:= nil
Local oPBTop	:= nil
Local oPClass	:= nil
Local oPTitleTop:= nil
Local oFont16	:= TFont():New('ARIAL',,-16,.T.)
Local oFont12	:= TFont():New('ARIAL',,-12,.T.)
Local oFont20	:= TFont():New('ARIAL',,-20,.T.)
Local nRadB		:= 1
Local aItb		:= {}
Local aHList	:= {'Site','CÛdigo','DescriÁ„o'}
Local oListBox	:= nil
Local oGetClass	:= nil
Local aClass	:= {{"","",0}}
Local cClass	:= Space(150)
Local bPesq		:= nil

IF Select("TMP_ZZO") > 0
	TMP_ZZO->(DbCloseArea())
ENDIF

BEGINSQL ALIAS "TMP_ZZO"
	SELECT ZZO_COD, TRIM(ZZO_DESC) ZZO_DESC FROM %Table:ZZO% ZZO
	WHERE ZZO_FILIAL = %XfILIAL:zzo%
	AND ZZO.%nOTdEL%
ENDSQL

TMP_ZZO->(DbEval( {|x| Aadd( aItb, TMP_ZZO->ZZO_COD+"="+AllTrim(TMP_ZZO->ZZO_DESC) ) } ))

TMP_ZZO->(DbCloseArea())

DEFINE MSDIALOG oDlgClass TITLE ' '  From 0,0 To 650,800 pixel STYLE nOR(WS_VISIBLE,WS_POPUP) //Style DS_MODALFRAME
oDlgClass:lMaximized := .F.

aTFolder := { 'Listagem', '¡rvore' }
oTFolder := TFolder():New( 0,0,aTFolder,,oDlgClass,,,,.T.,,260,184 )
oTFolder:Align := CONTROL_ALIGN_ALLCLIENT

oGrpAll:= TGroup():New(00,00,oDlgClass:NCLIENTHEIGHT/2,(oDlgClass:NCLIENTWIDTH/2),"",oDlgClass,CLR_BLUE,,.T.)

@05,15 MSPANEL oPntAll PROMPT "" SIZE (oDlgClass:NCLIENTWIDTH/2)-30,(oDlgClass:NCLIENTHEIGHT/2)-10 COLOR CLR_WHITE,CLR_WHITE OF oTFolder:aDialogs[1]

@00,00 MSPANEL oPTitleTop PROMPT "" SIZE 30,30 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
oPTitleTop:Align := CONTROL_ALIGN_TOP

oSayQuest := TSay():New(10,01,{|| '<h1>ClassificaÁ„o</h1>' },oPTitleTop,,,,,,.T.,,,,,,,,,,.T.)

@00,00 MSPANEL oPBTop PROMPT "" SIZE 60,60 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
oPBTop:Align := CONTROL_ALIGN_TOP

oRadB	:= TRadMenu():New (05,00,aItb,,oPBTop,,,,,,,,(oDlgClass:NCLIENTWIDTH/2)-30,25,,,,.T.,.T.)
oRadB:lHoriz	:= .F.
oRadB:bSetGet := {|u|Iif (PCount()==0,nRadB,nRadB:=u)}
oRadB:Align := CONTROL_ALIGN_TOP

bPesq := {|| IIF( !Empty(cClass) , xPesClass(@oListBox,nRadB,aItb,cClass,@aClass) , nil ) }
oGetClass	:= TGet():New(30,00,{|u| if( Pcount()>0, cClass := u,cClass ) },oPBTop,200,015,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cClass",,,,,,,,1,oFont20,CLR_RED )
oGetClass:cPlaceHold	:= "Informe aqui a disciplina que deseja pesquisar"
oGetClass:bChange	:= bPesq

oBtPesq		:= TButton():New( 30, 205, "Pesquisar"	, oPBTop,bPesq,35,17,,oFont12,,.T.)
oBtPesq:SetCss( "QPushButton{ background-color:rgb(28,157,189);}" )

@00,00 MSPANEL oPBottom PROMPT "" SIZE 60,60 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
oPBottom:Align := CONTROL_ALIGN_BOTTOM

oBtSave	:= TButton():New( 010, 01, "Sair"	, oPBottom,{|| oDlgClass:End() },80,020,,oFont16,,.T.)
oBtSave:SetCss( "QPushButton{ background-color:rgb(28,157,189);}" )

@00,00 MSPANEL oPClass PROMPT "" SIZE 10,10 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
oPClass:Align := CONTROL_ALIGN_ALLCLIENT

oListBox := TWBrowse():New(00,00,00,00,,aHList,,oPClass,,,,,,,,,,,,, "ARRAY", .T. )  
oListBox:Align := CONTROL_ALIGN_ALLCLIENT
oListBox:SetArray( aClass )
oListBox:bLine := {|| {	aClass[oListBox:nAT,2] }}
oListBox:bLDblClick := {|| IIF( xCargaZZN(aClass[oListBox:nAT,3]) ,oDlgClass:End() , nil) }

u_GENZZNF3(.F.,oTFolder:aDialogs[2],@oDlgClass)

ACTIVATE MSDIALOG oDlgClass CENTERED

Return nil

Static Function xCargaZZN(nRecZZM)

Local lRet := .F.

ZZM->(DbGoTo( nRecZZM ))

lRet := U_GENSITEC()

Return lRet

Static Function xPesClass(oListBox,nRadB,aItb,cClass,aClass)

Local cCodSit	:= Left(aItb[nRadB],TamSX3("ZZO_COD")[1])
Local cPesq		:= AllTrim(cClass)
Local cPesqOld	:= PadR(AllTrim(cClass),TamSX3("ZZM_CODOLD")[1])

aClass	:= {}

IF Select("TMP_ZZM") > 0
	TMP_ZZM->(DbCloseArea())
ENDIF

BEGINSQL ALIAS "TMP_ZZM"
	SELECT ZZM.R_E_C_N_O_ RECZZM,ZZM_CODCAT,GET_TREE_DISC_OLD(ZZM_CODCAT,ZZM_CODSIT,'') DESCRI
	FROM %Table:ZZM% ZZM
	JOIN %Table:ZZO% ZZO
	ON ZZO_FILIAL = %xFilial:ZZO%
	AND ZZO_COD = ZZM_CODSIT
	AND ZZO.%NotDel%
	WHERE ZZM_FILIAL = %xFilial:ZZM%
	AND ZZM.%NotDel%
	AND ZZM.ZZM_CODSIT IN (%Exp:cCodSit%)
	AND NOT EXISTS(
		SELECT 1 FROM %Table:ZZM% FILHO
		WHERE FILHO.ZZM_FILIAL = %xFilial:ZZM%
		AND FILHO.ZZM_CODSIT = ZZM.ZZM_CODSIT
		AND FILHO.ZZM_CODMAE = ZZM.ZZM_CODCAT 
		AND FILHO.%NotDel%
	)	
	AND (
			Upper(DBA_EGK.F_TIRA_ACENTO(ZZM_DESCAT)) LIKE '%'||Upper(DBA_EGK.F_TIRA_ACENTO(%Exp:cPesq%))||'%'
			OR
			ZZM_CODOLD = %Exp:cPesqOld%
		)
	ORDER BY 2
ENDSQL

TMP_ZZM->(DbEval( {|| Aadd(aClass, { TMP_ZZM->ZZM_CODCAT,Alltrim(TMP_ZZM->DESCRI), TMP_ZZM->RECZZM } )}))

IF Empty(aClass)
	aClass := {{"","",0}}
ENDIF

oListBox:SetArray( aClass )
oListBox:bLine := {|| {	aClass[oListBox:nAT,2] }}
oListBox:Refresh()

TMP_ZZM->(DbCloseArea())

Return nil
