#include "totvs.ch"
#include "protheus.ch"
#INCLUDE "Topconn.ch"
#include "Fileio.ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEditPanel.CH'
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
±±∫Programa  ≥GENA103   ∫Autor  ≥Cleuto              ∫ Data ≥  25/06/2020 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Cadastro do produtos                                        ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ GEN - Projeto Gest„o de Obras                              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

/*
para amarraÁ„o com as tabelas de configura„o de layout o campo È utilizado o campo
ZZE_TIPINC = ???_TPPUB, PPE n„o tem tipo de publicaÁ„o, em substituiÁ„o È utilizado o campo tipo de inclus„o
*/

User Function GENA103()

	Local cDepto	:= ""

	Private aGrp		:= UsrRetGrp( nil , RetCodUsr() )
	Private oBrowse
	Private aRotina		:= {}
	Private cMicroGraph	:= "https://graph.microsoft.com/v1.0"
	Private oGetDA		:= nil
	Private cDefHtml	:= ""
	Private cCCusto		:= ""	
	Private lAmbPrd 	:= upper(alltrim(GetEnvServer())) $ "PRODUCAO"

	IF !xVldAcesso(@cDepto,@cCCusto)
		MsgStop("VocÍ n„o tem permiss„o para utilizar esta funcionalidade! Seu cÛdigo de usu·rio È "+RetCodUsr()+", solicite acesso a TI.")
		Return nil
	ENDIF

	DbSelectArea("ZZE")
	ZZE->(DbSetOrder(1))

// DefiniÁ„o das OperaÁıes disponÌveis.
	aRotina := MenuDef()

	oBrowse := FWMBrowse():New()
//oBrowse:SetOnlyFields( { 'ZZE_PPE','ZZE_CODHIS','ZZE_TIPINC','ZZE_EDICAO','ZZE_DESC','ZZE_AUTOR','ZZE_SITOBR','ZZE_DESSIT','ZZE_IDTPPU','ZZE_DESPUB','ZZE_EMPRES','ZZE_DESEMP','ZZE_SELO','ZZE_DESSEL','ZZE_AREGER','ZZE_DESAGE','ZZE_PERCRM','ZZE_PSITEG','ZZE_CONSIG','ZZE_OFERT','ZZE_DTPUBL','ZZE_ISBN','ZZE_FEC','ZZE_IDMAE'} ) 
	oBrowse:SetAlias('ZZE')
	oBrowse:SetDescription("PROPOSTA DE PROJETO EDITORIAL")

// Legendas
	oBrowse:AddLegend("ZZE_MSBLQL=='1'","RED"	,"Ativo")
	oBrowse:AddLegend("ZZE_MSBLQL<>'1'","GREEN"	,"Desativado")

//oBrowse:SetFilterDefault("ZZE_DEPTO $ '"+cDepto+"'")
	IF !("******" $ cCCusto)
		oBrowse:SetFilterDefault("ZZE_CC $ '"+cCCusto+"'")
	ENDIF

//Para mudar a cor da linha do browse
// Linha alternada
//obrowse:SetClrAlterRow(nCor RGB)

	oBrowse:Activate()

Return NIL

Static Function MenuDef()
	Local aRotina	:= {}

//aRotina := FWMVCMenu( "GENA103" )
	ADD OPTION aRotina TITLE 'Visualizar'		ACTION 'U_GENMNZZE("Visualizar",1)'		OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'			ACTION 'U_GENMNZZE("Incluir",3)' 		OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'			ACTION 'U_GENMNZZE("Alterar",4)' 		OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir' 			ACTION 'U_GENMNZZE("Excluir",5)' 		OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'E-Mail' 			ACTION 'u_GENA103M()' 					OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Ctr.Atividades'	ACTION 'U_GENCP001("2")'				OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir PPE'		ACTION 'U_GENA103I()' 					OPERATION 4 ACCESS 0
	//ADD OPTION aRotina TITLE 'EdiÁ„o Anterior'	ACTION 'u_GENA103D()' 					OPERATION 4 ACCESS 0

Return aRotina

User Function GENMNZZE(xParam1,xParam2,xParam3,xParam4,xParam5,xParam6)

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
	Private cTpSit		:= ""
	Private oViewSit	:= ""
	Private oVwImg		:= ""
	Private aImpDir		:= {}
	Private cCodCopy	:= xParam6
	Private cSitObr		:= AllTrim(ZZE->ZZE_SITOBR)
	Private cTpObr		:= IIF( xParam2 == 3 , "" , ZZE->ZZE_TIPINC )
	Private cCodEdiAnt	:= ""

	If xParam2 == 1
		lOk := ( FWExecView(xParam1,'VIEWDEF.GENA103', 1,,{ || .T. } ) == 0 )
	ElseIf xParam2 == 10 .OR. xParam2 == 11
		lOk := ( FWExecView(xParam1,'VIEWDEF.GENA103', 4,,{ || .T. } ) == 0 )
	ElseIF xParam2 == 3
		cTpObr	:= xTipoPPE()
		IF !Empty(cTpObr)
			lOk := ( FWExecView(xParam1,'VIEWDEF.GENA103', xParam2,,{ || .T. } ) == 0 )
		ELSE
			Return .f.
		ENDIF
	ElseIF xParam2 == 12

	Else
		If xParam2 == 4
			aEval(aGrp,{|x| cGrpUsr+="'"+x+"'," })
			cGrpUsr := "%("+Left(cGrpUsr, Len(cGrpUsr)-1)+")%"

			IF Empty(cGrpUsr)

				MsgStop("Nenhum grupo foi cadastrado no seu usu·rio, entre em contato com a TI!")
				FreeObj(oVwHtml)
				FreeObj(oWebEngine)
				FreeObj(oWebChannel)

				aEval(aImpDir,{|x| FErase(x) })

				Return .F.
			ENDIF

			If Select("TMP_SITOBR") > 0
				TMP_SITOBR->(DbCloseArea())
			EndIf
			BeginSql Alias "TMP_SITOBR"
			SELECT COUNT(*) QTD FROM %Table:ZZS% ZZS
			WHERE ZZS.ZZS_FILIAL = %xFilial:ZZS%
			AND ZZS_NUM = '02'
			AND ZZS_SITOBR = %Exp:AllTrim(ZZE->ZZE_SITOBR)%
			AND ZZS_TPPUB = %Exp:AllTrim(ZZE->ZZE_TIPINC)%
			AND ZZS_GRPUSR IN %Exp:cGrpUsr%
			AND ZZS_CAMPO = 'ZZE_SITOBR'
			AND ZZS_ACESSO = '2'
			AND ZZS.%NotDel%
			EndSql
			TMP_SITOBR->(DbGoTop())
			If TMP_SITOBR->QTD > 0
				lSitObr	:= .T.
			EndIf
			TMP_SITOBR->(DbCloseArea())
		EndIf

		lOk := ( FWExecView(xParam1,'VIEWDEF.GENA103', xParam2,,{ || .T. } ) == 0 )

	EndIF

//oWebEngine:disconnect()

	FreeObj(oVwHtml)
	FreeObj(oWebEngine)
	FreeObj(oWebChannel)

	aEval(aImpDir,{|x| FErase(x) })

Return .T.

Static Function ModelDef()
	Local oModel

	Local cGrpUsr	:= ""
	Local cFiledZZE	:= ""//"'ZZE_COD','ZZE_DESC','ZZE_SITOBR','ZZE_IDTPPU'"
	Local bBloco	:= {|oModel| loadField(oModel)}

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
		cTpSit	:= xMudaSitObr(ZZE->ZZE_SITOBR)
	OtherWise
		cTpSit	:= IIF( Empty(AllTrim(ZZE->ZZE_SITOBR)) .or. INCLUI , "000" , ZZE->ZZE_SITOBR )
	EndCase

// Cria Estruturas para serem usadas no Modelo de Dados
	Static oStruZZE  := nil
	Static oStruZZK  := nil
	Static oStruZZ1  := nil
	Static oStruZZN	 := nil

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
	AND ZZQ.%NotDel%
	JOIN %Table:ZZR% ZZR
	ON ZZR.ZZR_FILIAL = ZZQ.ZZQ_FILIAL
	AND ZZR.ZZR_NUM = ZZQ.ZZQ_NUM
	AND ZZR.ZZR_TPPUB = ZZQ.ZZQ_TPPUB
	AND ZZR.ZZR_SITOBR = ZZQ.ZZQ_SITOBR
	AND ZZR.%NotDel%
	JOIN %Table:ZZS% ZZS
	ON ZZS.ZZS_FILIAL = ZZR.ZZR_FILIAL
	AND ZZS.ZZS_NUM = ZZR.ZZR_NUM
	AND ZZS.ZZS_TPPUB = ZZR.ZZR_TPPUB
	AND ZZS.ZZS_SITOBR = ZZR.ZZR_SITOBR
	AND ZZS.ZZS_GRPUSR = ZZR.ZZR_GRPUSR
	AND ZZS.%NotDel%
	WHERE ZZP_FILIAL = %xFilial:ZZP%
	AND ZZP_NUM = '02'
	AND ZZR_SITOBR = %Exp:cTpSit%
	AND ZZP_IDTPPU = %Exp:cTpObr%
	AND ZZR_GRPUSR IN %Exp:cGrpUsr%
	AND ZZP.%NotDel%
	EndSql

	//TMP_FIELD->(DbGoTop())

	If TMP_FIELD->(EOF())
		TMP_FIELD->(DbCloseArea())
		oStruZZE  := FWFormStruct(1,'ZZE',{|cCampo| AllTrim(cCampo) $ "ZZE_FILIAL/ZZE_PPE/ZZE_DESC/ZZE_TIPINC/ZZE_DESPUB/ZZE_SITOBR/ZZE_DESSIT/ZZE_CODHIS"})
		oModel := MPFormModel():New('CAZZE_MD')
		oModel:AddFields('ZZE_FORM',/*cOwner*/,oStruZZE,/*blinePre*/,/*blinePos*/)
		// DefiniÁ„o da Chave Prim·ria
		oModel:SetPrimaryKey({"ZZE_FILIAL","ZZE_PPE"})
		// DescriÁ„o do Modelo
		oModel:SetDescription("PROPOSTA DE PROJETO EDITORIAL")
		// DescriÁ„o do Modelo
		oModel:GetModel('ZZE_FORM'):SetDescription("Produto")
		oModel:SetVldActivate( { |oModel| .F. } )
		Return oModel
	EndIf

	While TMP_FIELD->(!EOF())
		cFiledZZE+=AllTrim(TMP_FIELD->ZZS_CAMPO)+"/"
		TMP_FIELD->(DbSkip())
	EndDo

	oStruZZE  := FWFormStruct(1,'ZZE',{|cCampo| AllTrim(cCampo)+"/" $ cFiledZZE})
	oStruZZK  := FWFormStruct(1,'ZZK',{|cCampo| AllTrim(cCampo) $ "ZZK_IDTPPU/ZZK_DESPUB/ZZK_TIPINC/ZZK_DECISA/ZZK_DIREIT/ZZK_CODPRO/ZZK_CODANT/ZZK_CODHIS/ZZK_ISBN/ZZK_PRECO/ZZK_PERCDA/ZZK_INCIDE/ZZK_EMAE" })
	oStruZZ1  := FWFormStruct(1,'ZZ1',{|cCampo| !(AllTrim(cCampo) $ "ZZ1_FILIAL/ZZ1_PPE/ZZ1_ORIGEM") })
	oStruZZN  := FWFormStruct(1,'ZZN',{|cCampo| !(AllTrim(cCampo) $ "ZZN_FILIAL/ZZN_PPE/ZZN_PRODUT") })

	TMP_FIELD->(DbGoTop())

	While TMP_FIELD->(!EOF())

		oStruZZE:SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MODEL_FIELD_OBRIGAT,TMP_FIELD->ZZS_OBRIGA == "1")

		TMP_FIELD->(DbSkip())
	EndDo

	oModel := MPFormModel():New('CAZZE_MD' , ,{|oModel| VldTudOk(oModel)  })

// Adiciona um Componente de Formul·rio ao modelo.
	oModel:AddFields('ZZE_FORM',/*cOwner*/,oStruZZE,/*blinePre*/,/*blinePos*/)

	oModel:AddGrid( 'ZZK_GRID', 'ZZE_FORM', oStruZZK )
	oModel:SetRelation( 'ZZK_GRID', { { 'ZZK_FILIAL', 'xFilial("ZZK")' }, { 'ZZK_PPE', "ZZE_PPE" } }, ZZK->( IndexKey( 1 ) ) )

	oModel:AddGrid( 'ZZ1_GRID', 'ZZE_FORM', oStruZZ1 )
	oModel:SetRelation( 'ZZ1_GRID', { { 'ZZ1_FILIAL', 'xFilial("ZZ1")' },{'ZZ1_ORIGEM','PadR("GENA103",TamSX3("ZZ1_ORIGEM")[1])'}, { 'ZZ1_PPE', "ZZE_PPE" } }, ZZ1->( IndexKey( 2 ) ) )

	oModel:AddGrid( 'ZZN_GRID', 'ZZE_FORM', oStruZZN )
	oModel:SetRelation( 'ZZN_GRID', { { 'ZZN_FILIAL', 'xFilial("ZZN")' },{'ZZN_ORIGEM','PadR("GENA103",TamSX3("ZZN_ORIGEM")[1])'}, { 'ZZN_PRODUT', "ZZE_PPE" } }, ZZN->( IndexKey( 1 ) ) )

// DefiniÁ„o da Chave Prim·ria
	oModel:SetPrimaryKey({"ZZE_FILIAL","ZZE_PPE"})

// DescriÁ„o do Modelo
	If nOperAux == 3
		oModel:SetDescription("PROPOSTA DE PROJETO EDITORIAL")
	ElseIf nOperAux == 9
		oModel:SetDescription(AllTrim(ZZE->ZZE_PPE)+" : "+AllTrim(ZZE->ZZE_DESC)+" -> "+AllTrim(cDescAux))
	Else
		oModel:SetDescription(AllTrim(ZZE->ZZE_PPE)+" : "+AllTrim(ZZE->ZZE_DESC))
	EndIF

// DescriÁ„o do Modelo
	oModel:GetModel('ZZE_FORM'):SetDescription("PROPOSTA DE PROJETO EDITORIAL")
	oModel:GetModel('ZZK_GRID'):SetDescription("Produtos/ServiÁos")
	oModel:GetModel('ZZ1_GRID'):SetDescription("Arquivos Auxiliares")
	oModel:GetModel('ZZ1_GRID'):SetNoInsertLine(.T.)
	oModel:GetModel('ZZ1_GRID'):SetOptional( .T. )
	oModel:GetModel('ZZ1_GRID'):SetNoUpdateLine(.T.)

	oModel:GetModel('ZZN_GRID'):SetDescription("Categorias")
	oModel:GetModel('ZZN_GRID'):SetNoInsertLine(.T.)
	oModel:GetModel('ZZN_GRID'):SetOptional( .T. )
	oModel:GetModel('ZZN_GRID'):SetNoUpdateLine(.T.)

	oModel:SetActivate(bBloco)

	IF VALTYPE(oGetDA) == "O"
		FREEOBJ( oGetDA )
	ENDIF

Return oModel

Static Function VldTudOk(oModel)

	Local lRet		:= .T.
	Local oModelZZE := oModel:GetModel( 'ZZE_FORM' )
	Local lEJP		:= .F.
	Local oModelZZ1 := oModel:GetModel( 'ZZ1_GRID' )
	Local oModelZZK := oModel:GetModel( 'ZZK_GRID' )
	Local nQtdLin	:= oModelZZ1:Length()
	Local nQtdZZK	:= oModelZZK:Length()
	Local oViewAtv	:= FWViewActive()
	Local nAuxFor	:= 0
	Local cSitAprova:= GetMv("GEN_PPE001",.F.,"003")// retorna as situaÁıes que devem validar se os tipos de produtos foram informados
	Local cDirPPE	:= ""
	Local cUrlWeb	:= ""
	Local cFoldPPE	:= "Diretorio PPE-"+AllTrim(oModelZZE:GetValue("ZZE_PPE"))
	Local lFldPPE	:= .F.
	Local cTermo	:= ""
	Local lAchouMae	:= .F.
	Local lAprovado	:= .F.
	Local cPermReim	:= GetMv("GEN_REIMOK",.F.,"1#")
	Local aFldEmpty	:= {}
	Local cDescTp	:= ""

	IF lRet .AND. ;
			(oModel:GetOperation() == 4 .AND. nOperAux == 4) .OR.;
			(oModel:GetOperation() == 3 .AND. nOperAux == 3)

		IF AllTrim(oModelZZE:GetValue("ZZE_SITOBR")) == "005"
			For nAuxFor := 1 To nQtdZZK
				oModelZZK:GoLine( nAuxFor )
				IF oModelZZK:IsDeleted() .OR. AllTrim(oModelZZK:GetValue("ZZK_DECISA",nAuxFor)) <> "1"
					Loop
				ENDIF
				aFldEmpty := xVldField(oModelZZK:GetValue("ZZK_IDTPPU",nAuxFor),oModel, oModelZZE)
				IF Len(aFldEmpty) > 0
					For nAuxCp := 1 To Len(aFldEmpty)
						cDescTp	:= AllTrim(Posicione("ZZP",1,xFilial("ZZP")+PadR("01",TamSX3("ZZP_NUM")[1])+oModelZZK:GetValue("ZZK_IDTPPU",nAuxFor),"ZZP_DESCRI"))
						oModel:GetModel():SetErrorMessage('ZZE_FORM', aFldEmpty[nAuxCp][1] , 'ZZE_FORM' , aFldEmpty[nAuxCp][1] ,;
							"Campo Obrigatorios",;
							"O campo "+aFldEmpty[nAuxCp][2]+" deve ser informado para o tipo de publicaÁ„o "+cDescTp+".",;
							"Preencha os campos obrigatorios e tente novamente!")
					Next
					lRet := .F.
					Exit
				ENDIF
			Next
		ENDIF

		IF lRet
			IF oModel:HasField('ZZE_FORM', 'ZZE_TIPINC')
				IF oModelZZE:GetValue("ZZE_TIPINC") == "93" // reimpress„o

					For nAuxFor := 1 To nQtdZZK
						oModelZZK:GoLine( nAuxFor )
						IF oModelZZK:IsDeleted()
							Loop
						ENDIF
						IF AllTrim(oModelZZK:GetValue("ZZK_IDTPPU",	nAuxFor))+"#" $ cPermReim
							IF !Empty(oModelZZK:GetValue("ZZK_CODANT",	nAuxFor))
								lRet := !ExistReimp(oModelZZK:GetValue("ZZK_CODANT",	nAuxFor),oModelZZK:GetValue("ZZK_CODPRO",	nAuxFor))
								IF !lRet
									Exit
								EndIF
							ENDIF
						ENDIF
					Next

					IF !lRet
						oModel:GetModel():SetErrorMessage('ZZE_FORM', "ZZE_TIPINC" , 'ZZE_FORM' , 'ZZE_TIPINC' ,;
							"Reimpress„o anterior aberta",;
							"Foi identificada uma reimpress„o com situaÁ„o 'Aberta' para o produto '"+oModelZZK:GetValue("ZZK_CODANT",	nAuxFor)+"'",;
							"Entre em contato com o PCP e solicite que est· reimpress„o seja encerrada para que seja possÌvel a abertura de uma nova.")
						Return lRet
					ENDIF
				ENDIF
			ENDIF
		ENDIF

		IF oModel:HasField('ZZE_FORM', 'ZZE_BASEDA')

			IF Type("oGetDA") == "O"
				cTermo := xGetTermo(oGetDA:GetText())
				oModel:LoadValue( 'ZZE_FORM', 'ZZE_BASEDA', cTermo )
			ENDIF

		ENDIF

		IF cTpSit == cSitAprova
			lRet	:= .F.
			For nAuxFor := 1 To nQtdZZK
				oModelZZK:GoLine( nAuxFor )
				IF oModelZZK:IsDeleted()
					Loop
				ENDIF
				lAchouMae	:= IIF( AllTrim(oModelZZK:GetValue("ZZK_EMAE",	nAuxFor)) == "1", .T., lAchouMae )
				lAprovado	:= IIF( AllTrim(oModelZZK:GetValue("ZZK_DECISA",nAuxFor)) == "1", .T., lAprovado )
			Next
			IF !lAprovado
				lRet	:= .F.
				oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' ,;
					"Tipo de Produtos da PPE",;
					"N„o identificamos nenhum produto marcado como aprovado!",;
					"Na aba produtos/serviÁos indique quais tipos de produtos foram aprovados pelo comitÍ!")
			ELSEIF !lAchouMae
				lRet	:= .F.
				oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' ,;
					"Tipo de Produtos da PPE",;
					"N„o identificamos o produto M„e!",;
					"Na aba produtos/serviÁos indique qual o registro representa o produto M„e!")
			ELSE
				lRet	:= .T.
			ENDIF
		ENDIF

	ENDIF

	IF lRet .AND. ;
			(oModel:GetOperation() == 4 .AND. nOperAux == 4) .OR.;
			(oModel:GetOperation() == 3 .AND. nOperAux == 3)

		cDirPPE	:= FwNoAccent(AllTrim(Posicione("CTT",1,xFilial("CTT")+NoAcento(AllTrim(oModelZZE:GetValue("ZZE_CC"))),"CTT_DESC01"))+" "+NoAcento(AllTrim(oModelZZE:GetValue("ZZE_CC"))))

		IF lAmbPrd // tratamento para n„o acessar o sharepoint da produÁ„o pela base teste
			xPutDirPPE(cDirPPE,"PPE-"+NoAcento(AllTrim(oModelZZE:GetValue("ZZE_PPE"))),oModel,@cUrlWeb)
		ENDIF	

		For nAuxFor := 1 To nQtdLin
			IF Alltrim(oModelZZ1:GetValue("ZZ1_NOME",nAuxFor)) == AllTrim(cFoldPPE) .AND. ;
					Alltrim(oModelZZ1:GetValue("ZZ1_TIPO",nAuxFor)) == "OUT" .AND. ;
					Alltrim(oModelZZ1:GetValue("ZZ1_DADO",nAuxFor)) == AllTrim(cUrlWeb)
				lFldPPE	:= .T.
			ENDIF
		Next

		IF !lFldPPE .AND. !Empty(cUrlWeb)
			oModel:GetModel('ZZ1_GRID'):SetNoInsertLine(.F.)
			oModel:GetModel('ZZ1_GRID'):SetNoUpdateLine(.F.)

			If !Empty(oModelZZ1:GetValue("ZZ1_DADO",nQtdLin))
				If oModelZZ1:AddLine() == (nQtdLin+1)
					nQtdLin++
				Else
					MsgStop("N„o foi possÌvel carregar a imagem, tente novamente!")
				EndIf
			EndIf

			//oModelZZ1:LoadValue("ZZ1_ORIGEM","GENA013")
			oModelZZ1:LoadValue("ZZ1_MSIDEN",U_xGenSXE("ZZ1","ZZ1_MSIDEN",3))
			oModelZZ1:LoadValue("ZZ1_TIPO","OUT")
			oModelZZ1:LoadValue("ZZ1_NOME",cFoldPPE)
			oModelZZ1:LoadValue("ZZ1_DADO",AllTrim(cUrlWeb))

			IF oModelZZ1:VldData()
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
			oModel:GetModel('ZZ1_GRID'):SetNoInsertLine(.T.)
			oModel:GetModel('ZZ1_GRID'):SetNoUpdateLine(.T.)
			oViewAtv:Refresh("ZZ1_GRID")
		ENDIF
	EndIF

	If lRet .AND. oModel:GetOperation() == 4 .AND. nOperAux == 4
		//----------------------------------------------------------------------------
		// Esta validaÁ„o deve ser mantida sempre como ultima validaÁ„o pois a mesma -
		// pois a mesma realizada a copia da PPE para o Shareponit e deve ser feita  -
		// apenas em caso de lRet = true sem possibilidade modificaÁ„o               -
		//----------------------------------------------------------------------------
		IF cTpSit == cSitAprova
			For nAuxFor := 1 To nQtdLin
				oModelZZ1:GoLine( nAuxFor )
				IF oModelZZ1:IsDeleted()
					Loop
				ENDIF
				IF AllTrim(oModelZZ1:GetValue("ZZ1_TIPO",nAuxFor)) == "EJP"
					cDirPPE	:= AllTrim(Posicione("CTT",1,xFilial("CTT")+AllTrim(oModelZZE:GetValue("ZZE_CC")),"CTT_DESC01"))+" "+AllTrim(oModelZZE:GetValue("ZZE_CC"))
					cDirPPE	:= FwNoAccent(cDirPPE)
					IF lAmbPrd // tratamento para n„o acessar o sharepoint da produÁ„o pela base teste
						lEJP 	:= U_GENA103T(	cDirPPE ,;
							"PPE-"+AllTrim(oModelZZE:GetValue("ZZE_PPE")),;
							AllTrim(oModelZZ1:GetValue("ZZ1_DADO",nAuxFor)),;
							oModel;
							)
					ELSE
						lEJP	:= .T.							
					ENDIF		
				ENDIF
			Next
			lRet := lEJP
			IF !lRet
				oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' , " Controle de EJP", 'N„o foi possÌvel realizar a copia de seguranÁa da EJP para o diretorio de EJPs aprovadas.', 'Verifique se a EJP foi devidamente informada na grid de arquivos e tente novamente.')
			ENDIF
		ENDIF
	EndIf

Return lRet

Static Function loadField(oFieldModel)

	Local oModel	:= FWModelActive()
	Local oModelZZK := oModel:GetModel( 'ZZK_GRID' )
	Local nQtdLin	:= oModelZZK:Length()

	Local oView		:= FWViewActive()
	Local nAuxVw	:= 0
	Local nAuxFd	:= 0
	Local nAuxGp	:= 0

	//CADASTRO INICIAL
	If oFieldModel:GetOperation() == 3 .AND. nOperAux == 3 .AND. cTpSit == "000"

		IF oFieldModel:HasField('ZZE_FORM', 'ZZE_SITOBR')
			oViewSit:SetProperty( "ZZE_SITOBR", MVC_VIEW_CANCHANGE,.T.)
			oFieldModel:LoadValue( 'ZZE_FORM', 'ZZE_SITOBR', cTpSit )
			oFieldModel:LoadValue( 'ZZE_FORM', 'ZZE_DESSIT', ALLTRIM(POSICIONE("ZZC",1,XFILIAL("ZZC")+'PP'+cTpSit,"ZZC_DESC"))       )
			oViewSit:SetProperty( "ZZE_SITOBR", MVC_VIEW_CANCHANGE,.F.)
		ENDIF

		IF oFieldModel:HasField('ZZE_FORM', 'ZZE_TIPINC')
			oViewSit:SetProperty( "ZZE_TIPINC", MVC_VIEW_CANCHANGE,.T.)
			oFieldModel:LoadValue( 'ZZE_FORM', 'ZZE_TIPINC', cTpObr )
			oViewSit:SetProperty( "ZZE_TIPINC", MVC_VIEW_CANCHANGE,.F.)
		ENDIF

		/* carrega os tipo de publicaÁ„o para zzk de acordo com os tipo de pulibcaÁ„o configurados no gest„o de produtos*/
		ZZP->(DbSetOrder(1))
		ZZP->(DbSeek( xFilial("ZZP")+"01" ))
		While ZZP->ZZP_NUM == "01"
			IF ZZP->ZZP_MSBLQL == "1" .OR. !( "#"+AllTrim(ZZP->ZZP_IDTPPU)+"#" $ "#1#2#3#14#15#22#24#25#27#28#" )
				ZZP->(DbSkip())
				Loop
			ENDIF

			If !Empty(oModelZZK:GetValue("ZZK_IDTPPU",nQtdLin))
				If oModelZZK:AddLine() == (nQtdLin+1)
					nQtdLin++
				EndIf
			EndIf

			//oModelZZ1:LoadValue("ZZ1_ORIGEM","GENA013")
			oModelZZK:LoadValue("ZZK_IDTPPU",ZZP->ZZP_IDTPPU)
			oModelZZK:LoadValue("ZZK_DESPUB",AllTrim(ZZP->ZZP_DESCRI))

			IF oModelZZK:VldData()
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

			ZZP->(DbSkip())
		EndDo

		IF cTpObr $ "92#93"
			cCodEdiAnt := U_GENA103D("Pesquisa ediÁ„o anterior")
			IF Empty(cCodEdiAnt)
				xMagHelpFis("Inclus„o de Nova EdiÁ„o","EdiÁ„o anterior n„o informada ou n„o localizada!",;
					"N„o foi possivel localizar a ediÁ„o anterior com os dados informados,"+;
					" vocÍ pode tentar novamente clicando no menu superior direito 'Outras aÁıes -> Pesq.EdiÁ„o Anterior'")
			ELSE
				xCargaEdiAnt(cCodEdiAnt,oModel)
			ENDIF
		ENDIF
	EndIF

	//ALTERA«√O
	If oFieldModel:GetOperation() == 4 .AND. nOperAux == 4
		If cTpSit <> oFieldModel:GetValue("ZZE_FORM", "ZZE_SITOBR") .AND. !Empty(cTpSit)
			oFieldModel:LoadValue( 'ZZE_FORM', 'ZZE_SITOBR', cTpSit )
			oFieldModel:LoadValue( 'ZZE_FORM', 'ZZE_DESSIT', ALLTRIM(POSICIONE("ZZC",1,XFILIAL("ZZC")+'PP'+cTpSit,"ZZC_DESC")) )
			oViewSit:SetProperty( "ZZE_SITOBR", MVC_VIEW_CANCHANGE,.F.)
			//oViewSit:SetProperty( "ZZE_DESSIT", MVC_VIEW_CANCHANGE,.F.)
		EndIf
	EndIf

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
	Local oStruZZE  := nil
	Local oStruZZK  := nil
	Local oStruZZN  := nil

// Carrega o modelo de dados de um fonte MVC. No caso, carregamos deste fonte mesmo.
	Local oModel := FWLoadModel('GENA103')

// Cria o modelo da View
	Local oView := FWFormView():New()

//Local aGrp		:= UsrRetGrp( nil , RetCodUsr() )
	Local cGrpUsr	:= ""
	Local cFiledZZE	:= ""//"'ZZE_COD','ZZE_DESC','ZZE_SITOBR','ZZE_IDTPPU'"
//Local cTpObr	:= IIF( Empty(AllTrim(ZZE->ZZE_TIPINC)) .or. INCLUI, "1" , ZZE->ZZE_TIPINC )
	Local aFldCp	:= {}
	Local nFldAux	:= 0
	Local nAuxFd	:= 0
	Local lZZKSimp	:= .T.
	Local lTermoDA	:= .F.

	IF nOperAux == 1
		cTpSit	:= "500"
	ENDIF

	aEval(aGrp,{|x| cGrpUsr+="'"+x+"'," })
	cGrpUsr := "%("+Left(cGrpUsr, Len(cGrpUsr)-1)+")%"

	If Select("TMP_FIELD") > 0
		TMP_FIELD->(DbCloseArea())
	EndIf

	BeginSql Alias "TMP_FIELD"
	SELECT ZZS_CAMPO, ZZS_ACESSO, ZZS_OBRIGA,X3_TAMANHO,ZZS_FOLDER,ZZC_DESC,X3_TIPO,ZZS_ORDEM,ZZR_IMAGEM,ZZS_PULA,ZZR_DISTRI,ZZR_ACEPUB 
	FROM %Table:ZZP% ZZP
	JOIN %Table:ZZQ% ZZQ
	ON ZZQ.ZZQ_FILIAL = ZZP.ZZP_FILIAL
	AND ZZQ.ZZQ_NUM = ZZP.ZZP_NUM
	AND ZZQ.ZZQ_TPPUB = ZZP.ZZP_IDTPPU
	AND ZZQ.%NotDel%
	JOIN %Table:ZZR% ZZR
	ON ZZR.ZZR_FILIAL = ZZQ.ZZQ_FILIAL
	AND ZZR.ZZR_NUM = ZZQ.ZZQ_NUM
	AND ZZR.ZZR_TPPUB = ZZQ.ZZQ_TPPUB
	AND ZZR.ZZR_SITOBR = ZZQ.ZZQ_SITOBR
	AND ZZR.%NotDel%
	JOIN %Table:ZZS% ZZS
	ON ZZS.ZZS_FILIAL = ZZR.ZZR_FILIAL
	AND ZZS.ZZS_NUM = ZZR.ZZR_NUM
	AND ZZS.ZZS_TPPUB = ZZR.ZZR_TPPUB
	AND ZZS.ZZS_SITOBR = ZZR.ZZR_SITOBR
	AND ZZS.ZZS_GRPUSR = ZZR.ZZR_GRPUSR
	AND ZZS.%NotDel%
	JOIN %Table:SX3% SX3
	ON X3_ARQUIVO IN ('ZZE')
	AND X3_CAMPO = ZZS_CAMPO
	AND SX3.%NotDel%
	LEFT JOIN %Table:ZZC% ZZC
	ON ZZC_FILIAL = ' '
	AND ZZC_TABELA = 'Z5'
	AND trim(ZZC_CHAVE) = ZZS_FOLDER
	AND ZZC.%NotDel%
	WHERE ZZP_FILIAL = %xFilial:ZZP%
	AND ZZP_NUM = '02'
	AND ZZR_SITOBR = %Exp:cTpSit%
	AND ZZP_IDTPPU = %Exp:cTpObr%
	AND ZZR_GRPUSR IN %Exp:cGrpUsr%
	AND ZZP.%NotDel%
	ORDER BY ZZS_FOLDER,ZZS_CAMPO
	EndSql
	//TMP_FIELD->(DbGoTop())

	If TMP_FIELD->(EOF())
		TMP_FIELD->(DbCloseArea())
		oStruZZE  := FWFormStruct(2,'ZZE',{|cCampo| AllTrim(cCampo) $ "ZZE_FILIAL/ZZE_PPE/ZZE_DESC/ZZE_TIPINC/ZZE_DESPUB/ZZE_SITOBR/ZZE_DESSIT/ZZE_CODHIS"})
		oView:SetModel(oModel)
		oView:AddField('VIEW_ZZE', oStruZZE, 'ZZE_FORM')

		oStruZZE:SetProperty( "ZZE_PPE", MVC_VIEW_CANCHANGE,.F.)
		oStruZZE:SetProperty( "ZZE_DESC", MVC_VIEW_CANCHANGE,.F.)
		oStruZZE:SetProperty( "ZZE_TIPINC", MVC_VIEW_CANCHANGE,.F.)
		//oStruZZE:SetProperty( "ZZE_DESPUB", MVC_VIEW_CANCHANGE,.F.)
		oStruZZE:SetProperty( "ZZE_SITOBR", MVC_VIEW_CANCHANGE,.F.)
		oStruZZE:SetProperty( "ZZE_DESSIT", MVC_VIEW_CANCHANGE,.F.)

		oStruZZE:SetProperty( "ZZE_PPE", MVC_VIEW_ORDEM,1)
		oStruZZE:SetProperty( "ZZE_DESC", MVC_VIEW_ORDEM,2)
		oStruZZE:SetProperty( "ZZE_TIPINC", MVC_VIEW_ORDEM,3)
		//oStruZZE:SetProperty( "ZZE_DESPUB", MVC_VIEW_ORDEM,4)
		oStruZZE:SetProperty( "ZZE_SITOBR", MVC_VIEW_ORDEM,5)
		oStruZZE:SetProperty( "ZZE_DESSIT", MVC_VIEW_ORDEM,6)

		oStruZZE:SetProperty( "ZZE_PPE", MVC_VIEW_INSERTLINE,.F.)
		oStruZZE:SetProperty( "ZZE_DESC", MVC_VIEW_INSERTLINE,.T.)
		oStruZZE:SetProperty( "ZZE_TIPINC", MVC_VIEW_INSERTLINE,.F.)
		//oStruZZE:SetProperty( "ZZE_DESPUB", MVC_VIEW_INSERTLINE,.T.)
		oStruZZE:SetProperty( "ZZE_SITOBR", MVC_VIEW_INSERTLINE,.F.)
		oStruZZE:SetProperty( "ZZE_DESSIT", MVC_VIEW_INSERTLINE,.T.)

		oView:CreateHorizontalBox( 'TOTAL', 100 )
		oView:SetOwnerView('VIEW_ZZE' ,'TOTAL')
		return oView
	EndIf

	While TMP_FIELD->(!EOF())

		lZZKSimp := TMP_FIELD->ZZR_ACEPUB == "1"

		If "ZZE_" $ TMP_FIELD->ZZS_CAMPO
			cFiledZZE+=AllTrim(TMP_FIELD->ZZS_CAMPO)+"/"
		EndIf

		IF TMP_FIELD->ZZS_CAMPO == "ZZE_BASEDA"
			lTermoDA := .T.
		ENDIF

		nPosFld := aScan(aFldCp, {|x| x[1] ==  TMP_FIELD->ZZS_FOLDER } )

		If nPosFld  == 0
			Aadd(aFldCp,{ TMP_FIELD->ZZS_FOLDER  , AllTrim(TMP_FIELD->ZZC_DESC) , 0 , 0 , "" , nil , nil , nil , nil , TMP_FIELD->X3_TIPO == "M" })
			nPosFld := Len(aFldCp)
		EndIf

		aFldCp[nPosFld][5]+=AllTrim(TMP_FIELD->ZZS_CAMPO)+"/"

		TMP_FIELD->(DbSkip())
	EndDo

	For nFldAux := 1 To Len(aFldCp)
		aFldCp[nFldAux][6] := "OBJ_ZZE_"+cValtoChar(nFldAux)
		&(aFldCp[nFldAux][6]) := FWFormStruct(2,'ZZE',{|cCampo| AllTrim(cCampo)+"/" $ aFldCp[nFldAux][5]})
	Next

// Definimos qual modelo ser· carregado nessa View
	oView:SetModel(oModel)

	For nFldAux := 1 To Len(aFldCp)

		oView:AddField('VIEW_ZZE_'+aFldCp[nFldAux][1], &(aFldCp[nFldAux][6]), 'ZZE_FORM')
		aFldCp[nFldAux][8] := 'VIEW_ZZE_'+aFldCp[nFldAux][1]

		If "ZZE_SITOBR" $ AllTrim(aFldCp[nFldAux][5])
			oViewSit := &(aFldCp[nFldAux][6])
		EndIf

	Next

	TMP_FIELD->(DbGoTop())

	While TMP_FIELD->(!EOF())

		nPosFld := aScan(aFldCp, {|x| x[1] ==  TMP_FIELD->ZZS_FOLDER } )

		aFldCp[nPosFld][3]+=TMP_FIELD->X3_TAMANHO+IIF( TMP_FIELD->X3_TIPO=="M",TMP_FIELD->X3_TAMANHO*2,0 )

		If "ZZE_SITOBR" $ AllTrim(TMP_FIELD->ZZS_CAMPO)
			&(aFldCp[nPosFld][6]):SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MVC_VIEW_CANCHANGE, .F. )
		Else
			&(aFldCp[nPosFld][6]):SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MVC_VIEW_CANCHANGE,TMP_FIELD->ZZS_ACESSO == "2")
		EndIf

		&(aFldCp[nPosFld][6]):SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MVC_VIEW_FOLDER_NUMBER,AllTrim(TMP_FIELD->ZZS_FOLDER))
		&(aFldCp[nPosFld][6]):SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MVC_VIEW_ORDEM,AllTrim(TMP_FIELD->ZZS_ORDEM))
		&(aFldCp[nPosFld][6]):SetProperty( AllTrim(TMP_FIELD->ZZS_CAMPO), MVC_VIEW_INSERTLINE , TMP_FIELD->ZZS_PULA == "1" )

		TMP_FIELD->(DbSkip())
	EndDo

	aFldCp := aSort(aFldCp,,,{|x,y| val(x[1]) < val(y[1])})

	IF lZZKSimp
		//oStruZZK  := FWFormStruct(2,'ZZK',{|cCampo| AllTrim(cCampo) $ "ZZK_IDTPPU/ZZK_DESPUB/ZZK_TIPINC/ZZK_DECISA/ZZK_DIREIT/ZZK_PRECO/ZZK_PERCDA/ZZK_INCIDE" })
		oStruZZK  := FWFormStruct(2,'ZZK',{|cCampo| AllTrim(cCampo) $ "ZZK_IDTPPU/ZZK_DESPUB/ZZK_TIPINC/ZZK_DECISA/ZZK_DIREIT/ZZK_CODPRO/ZZK_CODANT/ZZK_CODHIS/ZZK_ISBN/ZZK_PRECO/ZZK_PERCDA/ZZK_INCIDE/ZZK_EMAE" })
	ELSE
		oStruZZK  := FWFormStruct(2,'ZZK',{|cCampo| AllTrim(cCampo) $ "ZZK_IDTPPU/ZZK_DESPUB/ZZK_TIPINC/ZZK_DECISA/ZZK_DIREIT/ZZK_CODPRO/ZZK_CODANT/ZZK_CODHIS/ZZK_ISBN/ZZK_PRECO/ZZK_PERCDA/ZZK_INCIDE/ZZK_EMAE" })
	ENDIF
	oStruZZK:SetNoFolder()

	oStruZZ1  := FWFormStruct(2,'ZZ1',{|cCampo| !(AllTrim(cCampo) $ "ZZ1_FILIAL/ZZ1_PPE/ZZ1_ORIGEM") })
	oStruZZ1:SetNoFolder()

	oStruZZN  := FWFormStruct(2,'ZZN',{|cCampo| !(AllTrim(cCampo) $ "ZZN_FILIAL/ZZN_PPE/ZZN_ORIGEM/ZZN_PRODUT") })
	oStruZZN:SetNoFolder()

	oView:CreateFolder( 'FOLDERS' )
	For nAuxFd := 1 To Len(aFldCp)
		oView:AddSheet( 'FOLDERS', AllTrim(aFldCp[nAuxFd][1]), AllTrim(aFldCp[nAuxFd][2]) )
		IF aFldCp[nAuxFd][10] // aba de campos memo ficam desativadas
			oView:HideFolder("FOLDERS",AllTrim(aFldCp[nAuxFd][1]),2)
		ENDIF
	Next

	For nAuxFd := 1 To Len(aFldCp)
		oView:CreateHorizontalBox( 'SUP_'+aFldCp[nAuxFd][1]+"_H"	,100 /*100 * (aFldCp[nAuxFd][3]/(aFldCp[nAuxFd][3]+aFldCp[nAuxFd][4]))*100*/ ,,, 'FOLDERS', aFldCp[nAuxFd][1]) // ocupar 50% da tela
		oView:CreateVerticalBox( 'SUP_'+aFldCp[nAuxFd][1]	,100 ,'SUP_'+aFldCp[nAuxFd][1]+"_H",, 'FOLDERS', aFldCp[nAuxFd][1]) // ocupar 50% da tela
		//oView:CreateHorizontalBox( 'SUP_'+aFldCp[nAuxFd][1]	,100 ,'SUP_'+aFldCp[nAuxFd][1]+"_V",, 'FOLDERS', aFldCp[nAuxFd][1]) // ocupar 50% da tela

		oView:SetOwnerView(aFldCp[nAuxFd][8] ,'SUP_'+aFldCp[nAuxFd][1]	)
		oView:SetViewProperty( aFldCp[nAuxFd][8], "SETLAYOUT", { FF_LAYOUT_VERT_DESCR_TOP  , 3 } )
		oView:SetViewProperty(aFldCp[nAuxFd][8], "SETCOLUMNSEPARATOR", {10})
	Next

/* GRID DE TIPO DE PROUTOS */
	oView:AddGrid('VIEW_ZZK', oStruZZK, 'ZZK_GRID')
	oView:AddSheet( 'FOLDERS', 'OBJ_ZZK', 'Produtos/ServiÁos' )
	oView:CreateHorizontalBox( 'GERAL_ZZK'	, 100,,, 'FOLDERS', 'OBJ_ZZK' )
	oView:SetOwnerView('VIEW_ZZK' ,'GERAL_ZZK')

/* GRID DE ARQUIVOS */
	oView:AddSheet( 'FOLDERS', 'OBJ_ARQ', 'Arquivos' )
	oView:CreateHorizontalBox( 'HMENU_A'	, 10,,, 'FOLDERS', 'OBJ_ARQ' )
	oView:CreateHorizontalBox( 'GRID_A'	, 90,,, 'FOLDERS', 'OBJ_ARQ' )


	oView:AddOtherObject("MENU_ARQ", {|oPanel| MENUARQ(oPanel,{|| xAddFile() })})
	oView:SetOwnerView('MENU_ARQ' ,'HMENU_A')

	oView:AddGrid('VIEW_ARQ', oStruZZ1, 'ZZ1_GRID')
	oView:SetOwnerView('VIEW_ARQ' ,'GRID_A')
	oView:aViews[aScan(oView:aViews, {|x| x[1] == "VIEW_ARQ" })][3]:BDoubleClick := {|x| ShowPag(x) }

/* GRID DE CATEGORIAS */
	oView:AddSheet( 'FOLDERS', 'OBJ_CAT', 'Categorias' )
	oView:CreateHorizontalBox( 'HCMENU_A'	, 10,,, 'FOLDERS', 'OBJ_CAT' )
	oView:CreateHorizontalBox( 'CGRID_A'	, 90,,, 'FOLDERS', 'OBJ_CAT' )

	oView:AddOtherObject("MENU_CAT", {|oPanel| MENUARQ(oPanel,{|| xAddCat() })})
	oView:SetOwnerView('MENU_CAT' ,'HCMENU_A')

	oView:AddGrid('VIEW_CAT', oStruZZN, 'ZZN_GRID')
	oView:SetOwnerView('VIEW_CAT' ,'CGRID_A')

	IF lTermoDA
	/* MANUTEN«√O TERMOS */
		oView:AddSheet( 'FOLDERS', 'OBJ_DA', 'Bases e Termos DA' )
		oView:CreateHorizontalBox( 'TELADA_A'	, 90,,, 'FOLDERS', 'OBJ_DA' )

		oView:AddOtherObject("EDI_DA", {|oPanel| xDadosDA(oPanel,oModel)})
		oView:SetOwnerView('EDI_DA' ,'TELADA_A')
	ENDIF

	If Select("TMP_FIELD") > 0
		TMP_FIELD->(DbCloseArea())
	EndIf


Return oView

User function CAZZE_MD()
	Local aAreaZZE	:= ZZE->(GetArea())
	Local aParam	:= PARAMIXB
	Local xRet		:= .T.
	Local oObj		:= ''
	Local cIdPonto	:= ''
	Local cIdModel	:= ''
	Local lIsGrid	:= .F.
	Local cDest		:= ""
	Local cCodPPE	:= ""
	Local aCpoMin	:= { "ZZE_SITOBR","ZZE_TIPINC","ZZE_CC","ZZE_REVI" }
	Local lCpoMin	:= .T.
	Local nAuxCpo	:= 0
	Local lIntegra	:= .F.

	If PARAMIXB <> NIL

		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]
		lIsGrid    := ( Len( aParam ) > 3 )

		If  cIdPonto == 'MODELVLDACTIVE' .AND. ;
				cIdModel == "CAZZE_MD"

			For nAuxCpo := 1 To Len(aCpoMin)
				IF !oObj:HasField('ZZE_FORM', aCpoMin[nAuxCpo])
					lCpoMin := .F.
					oObj:GetModel():SetErrorMessage('ZZ1_GRID', aCpoMin[nAuxCpo] , 'ZZ1_GRID' , aCpoMin[nAuxCpo] , ;
						"Layout de acesso", ;
						"N„o foram identificados os campos minimos de acesso a rotina para seu usu·rio!",;
						"Entre em contato com a TI e solicite revis„o do seu perfil de acesso!")
				ENDIF
			Next nAuxCpo

			IF lCpoMin
				xRet	:= .T.
			ELSE
				xRet	:= .F.
			ENDIF

		ElseIf cIdPonto == 'MODELPOS'
		ElseIf cIdPonto == 'FORMPOS'
		ElseIf cIdPonto == 'FORMLINEPRE'
		ElseIf cIdPonto == 'FORMLINEPOS'
		ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
		ElseIf cIdPonto == 'MODELCOMMITTTS'
		ElseIf cIdPonto == 'MODELCOMMITNTTS'

			RecLock("ZZE",.F.)

			ZZE->ZZE_DTALTE	:= DDataBase
			ZZE->ZZE_HALTER	:= Time()
			ZZE->ZZE_USRALT	:= AllTrim(UsrRetName(RetCodUsr()))
			If nOperAux == 3
				ZZE->ZZE_DTINC	:= DDataBase
				ZZE->ZZE_HRINCL	:= Time()
				ZZE->ZZE_USRINC	:= AllTrim(UsrRetName(RetCodUsr()))
			EndIf
			MsUnLock()

			IF AllTrim(ZZE->ZZE_SITOBR) == "003" .AND. nOperAux == 4
				cDest := xConObserv()
				cCodPPE	:= ZZE->ZZE_PPE
				IF !Empty(cDest)
					RecLock("ZZJ",.T.)
					ZZJ->ZZJ_FILIAL	:= xFilial("ZZJ")
					ZZJ->ZZJ_PRODUT	:= cCodPPE
					ZZJ->ZZJ_DATA  	:= DDataBase
					ZZJ->ZZJ_HORA  	:= Left(Time(),5)
					ZZJ->ZZJ_OBS   	:= cDest
					ZZJ->ZZJ_USER  	:= AllTrim(UsrRetName(RetCodUsr()))
					ZZJ->ZZJ_OBSTEX	:= "ConsideraÁıes de aprovaÁ„o"
					ZZJ->ZZJ_ORIGEM	:= "2"
					ZZJ->ZZJ_TIPO	:= "01" // 00=ObservaÁ„o ; 01 = ConsideraÁ„o de aprovaÁ„o
					MsUnLock()
				ENDIF
			ENDIF

			xRet := nil

			IF AllTrim(ZZE->ZZE_SITOBR) $ "#005"
				ZZK->(DbSetOrder(1))
				ZZK->(DbSeek( xFilial("ZZK")+ZZE->ZZE_PPE ))

				While ZZK->(!EOF()) .AND. ZZK->ZZK_PPE == ZZE->ZZE_PPE
					IF !lIntegra .AND. ZZK->ZZK_DECISA == "1" .AND. (ZZK->ZZK_TIPINC $ "91#92#93#")// .AND. Empty(ZZK->ZZK_CODPRO)
						lIntegra := MsgYesNo("Identificamos Produtos autorizados, deseja integrar com o modulo Gest„o de Produtos?")
						IF !lIntegra
							Exit
						ENDIF
					ENDIF
					IF lIntegra
						Exit
					ENDIF
					ZZK->(DbSkip())
				EndDo
				IF lIntegra
					U_GENA103P(.T.)
				ENDIF

				// gerar arquivo html com a PPE Digital e envia para o sharepoint
				IF lAmbPrd // tratamento para n„o acessar o sharepoint da produÁ„o pela base teste
					U_GENA103S()
				ENDIF	
			ENDIF

		ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
		ElseIf cIdPonto == 'MODELCANCEL'
		ElseIf cIdPonto == 'BUTTONBAR'
			xRet := {}
		EndIf
	EndIf

	RestArea(aAreaZZE)

Return xRet

Static Function MENUARQ(oPanel,bFuncAdd)

	Local oTBut1	:= nil

	@00,00 MSPANEL oBtnLeft PROMPT "" SIZE (oPanel:NCLIENTWIDTH/2)*0.45,0 /*COLOR CLR_RED,CLR_RED*/ of oPanel
	oBtnLeft:Align := CONTROL_ALIGN_LEFT

	@00,00 MSPANEL oBtnRight PROMPT "" SIZE (oPanel:NCLIENTWIDTH/2)*0.45,0 of oPanel
	oBtnRight:Align := CONTROL_ALIGN_RIGHT

	@00,00 MSPANEL oBtCenter PROMPT "" SIZE (oPanel:NCLIENTWIDTH/2)*0.1,0 OF oPanel
	oBtCenter:Align := CONTROL_ALIGN_ALLCLIENT

	oTBut1 := TButton():New( 10, 10, "Incluir"			, oBtCenter,bFuncAdd, 50,15,,,.F.,.T.,.F.,,.F.,{|| nOperAux == 3 .OR. nOperAux == 4 },,.F. )

Return nil

Static Function xAddFile()

	Local cFile		:= Space(500)
	Local cNome		:= ""
	Local cTipo		:= ""
	Local oModel	:= FWModelActive()
	Local oModelZZ1 := oModel:GetModel( 'ZZ1_GRID' )
	Local nQtdLin	:= oModelZZ1:Length()
	Local oViewAtv	:= FWViewActive()
	Local lRet		:= .F.
	Local nOpcA		:= 0
	Local oFont		:= nil
	Local oRadB		:= nil
	Local oGetFile	:= nil
	Local nRadB		:= 1
	Local aItb		:= {'EJP','Outros'}
	Local oBtn		:= nil
	Local oBtSave	:= nil
	Local oBtCanc	:= nil
	Local oGrpAll	:= nil

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Monta a tela                                                                    ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	Define MsDialog oDlgFiltro 	Title "Informe a localizaÁ„o do arquivo" ;
		From 00,00 TO 150,800 PIXEL ;
		STYLE nOR(WS_VISIBLE,WS_POPUP)

	oGrpAll:= TGroup():New(00,00,oDlgFiltro:NCLIENTHEIGHT/2,(oDlgFiltro:NCLIENTWIDTH/2),"",oDlgFiltro,CLR_BLUE,,.T.)

	oRadB	:= TRadMenu():New (010,10,aItb,,oDlgFiltro,,,,,,,,75,12,,,,.T.,.T.)
	oRadB:bSetGet := {|u|Iif (PCount()==0,nRadB,nRadB:=u)}

	oGetFile := TGet():New(030,010,{|u| if( Pcount()>0, cFile:= u,cFile ) },oDlgFiltro,350,010,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cFile",,,,,,,"URL/Caminho.: ",1,oFont,CLR_RED )

	//@ 037, 365 BUTTON oBtn PROMPT "Pesq." SIZE 025, 012 OF oDlgFiltro ACTION {|| cFile := ;
		///*cGetFile("Arquivo Texto|*.*|Todos os Arquivos|*.*", OemToAnsi("Selecione o arquivo"),0,"SERVIDOR",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)*/;
		//	tFileDialog( "All files (*.*)",'Selecao de Arquivos',0,"/tmp",.F.);
		//	} PIXEL

	oBtSave := TButton():New( 60, 10, "Salvar"	, oDlgFiltro,{|x| IIF( VldAdd(oModelZZ1,nRadB) , ( nOpcA := 1,oDlgFiltro:End() ) , nil ) },80,020,,,,.T.)
	oBtSave:SetCss( "QPushButton{ background-color:rgb(144,217,74);}" )

	oBtCanc := TButton():New( 60, 100, "Cancelar"	, oDlgFiltro,{|x| oDlgFiltro:End() },80,020,,,,.T.)
	oBtCanc:SetCss( "QPushButton{ background-color:rgb(157,47,66);}" )

	Activate MsDialog oDlgFiltro Centered

	If nOpcA == 1 .AND. !Empty(cFile)
		IF nRadB == 1
			cTipo := "EJP"
			cNome := "EJP"
		ELSE
			cTipo := "OUT"
			cNome := "Outros"
		ENDIF
		lRet := .T.
	Else
		MsgStop("Parametros inv·lidos ou n„o informados!")
		lRet := .F.
	EndIf

	If lRet
		oModel:GetModel('ZZ1_GRID'):SetNoInsertLine(.F.)
		oModel:GetModel('ZZ1_GRID'):SetNoUpdateLine(.F.)

		If !Empty(oModelZZ1:GetValue("ZZ1_DADO",nQtdLin))
			If oModelZZ1:AddLine() == (nQtdLin+1)
				nQtdLin++
			Else
				MsgStop("N„o foi possÌvel carregar a imagem, tente novamente!")
			EndIf
		EndIf

		//oModelZZ1:LoadValue("ZZ1_ORIGEM","GENA013")
		oModelZZ1:LoadValue("ZZ1_MSIDEN",U_xGenSXE("ZZ1","ZZ1_MSIDEN",3))
		oModelZZ1:LoadValue("ZZ1_TIPO",cTipo)
		oModelZZ1:LoadValue("ZZ1_NOME",AllTrim(cNome))
		oModelZZ1:LoadValue("ZZ1_DADO",AllTrim(cFile))

		IF oModelZZ1:VldData()
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
		oModel:GetModel('ZZ1_GRID'):SetNoInsertLine(.T.)
		oModel:GetModel('ZZ1_GRID'):SetNoUpdateLine(.T.)
		oViewAtv:Refresh("ZZ1_GRID")

	EndIf

Return nil

Static function VldAdd(oModelZZ1,nRadB)

	Local lRet		:= .T.
	Local nQtdLin	:= oModelZZ1:Length()
	Local nAuxZZ1	:= 0

	For nAuxZZ1 := 1 To nQtdLin
		oModelZZ1:GoLine( nAuxZZ1 )
		IF oModelZZ1:IsDeleted()
			Loop
		ENDIF
		IF nRadB == 1 .AND. AllTrim(oModelZZ1:GetValue("ZZ1_TIPO",nAuxZZ1)) == "EJP"
			MsgStop("J· existe um documento informado com o tipo EJP!"+chr(13)+chr(10)+"Apenas deve ser informada uma EJP por PPE!")
			Return .F.
		ENDIF
	Next

Return lRet

Static Function ShowPag(oObj)

	Local cURL := oObj:GetModel( 'ZZ1_GRID' ):GetValue("ZZ1_DADO")
//oObj:oBrowse:nAt
	IF !Empty(cURL)
		ShellExecute("Open", cURL , "", "", 1 )
	EndIF


Return .f.

Static Function xTipoPPE()

	Local oDlgSit	:= nil
	Local cGrpUsr	:= ""
	Local cCadastro	:= "Tipo de Proposta Editorial"
	Local nOpcA		:= 0
	Local oSay1		:= nil
	Local oTpPPE	:= nil
	Local cTpPPE	:= ""
	Local nTpPPE	:= 1
	Local aTiposPPE	:= {}
	Local oGrpAll	:= nil

	aEval(aGrp,{|x| cGrpUsr+="'"+x+"'," })
	cGrpUsr := "%("+Left(cGrpUsr, Len(cGrpUsr)-1)+")%"

	IF Select("TMP_PPE") > 0
		TMP_PPE->(DbcloseArea())
	ENDIF

	BeginSql Alias "TMP_PPE"
	SELECT ZZS_TPPUB,ZZT_DESC 
	FROM %Table:ZZS% ZZS
	JOIN %Table:ZZT% ZZT 
	ON ZZT_FILIAL = %xFilial:ZZT%
	AND trim(ZZT_COD) = trim(ZZS_TPPUB)
	AND ZZT_MSBLQL <> '1'
	AND ZZT.%NotDel%
	WHERE ZZS.ZZS_FILIAL = %xFilial:ZZS%
	AND ZZS_NUM = '02'
	AND ZZS_SITOBR = '000'
	AND ZZS_GRPUSR IN %Exp:cGrpUsr%
	AND ZZS_CAMPO = 'ZZE_TIPINC'
	AND ZZS_ACESSO = '2'
	AND ZZS.%NotDel%
	EndSql

	TMP_PPE->(DbGoTop())
	while TMP_PPE->(!EOF())

		Aadd(aTiposPPE, AllTrim(TMP_PPE->ZZS_TPPUB)+"="+AllTrim(TMP_PPE->ZZT_DESC) )

		TMP_PPE->(DbSkip())
	EndDo
	TMP_PPE->(DbcloseArea())


	DEFINE MSDIALOG oDlgSit TITLE cCadastro FROM 000,000 TO 135,300 COLORS 0, 16777215 PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP)

	oGrpAll:= TGroup():New(00,00,oDlgSit:NCLIENTHEIGHT/2,(oDlgSit:NCLIENTWIDTH/2),"",oDlgSit,CLR_BLUE,,.T.)

	oSay1:= TSay():New(005,005,{|| "<h3>Informe o tipo de Proposta Editorial que deseja incluir<h3>" },oDlgSit,,,,,,.T.,CLR_BLUE,RGB(240,240,240),130,50,,,,,,.T.)

	oTpPPE	:= TRadMenu():New (025,005,aTiposPPE,,oDlgSit,,,,,,,,100,50,,,,.T.,,.T.)
	oTpPPE:bSetGet := {|u|Iif (PCount()==0,nTpPPE,nTpPPE:=u)}

	oSButton	:= TButton():New( 055, 005, "CONFIRMAR"	, oDlgSit,{|| nOpcA := 1,oDlgSit:End() },50,015,,,,.T.)
	oSButton:SetCss( "QPushButton{ background-color:rgb(28,157,189);}" )

	ACTIVATE MSDIALOG oDlgSit CENTERED

	IF nOpcA == 1 .AND. nTpPPE > 0
		cTpPPE := Left(aTiposPPE[nTpPPE],At("=",aTiposPPE[nTpPPE])-1)
	ENDIF

Return cTpPPE


Static Function xVldAcesso(cDepto,cCCusto)

	Local lRet		:= .F.
	Local cCodUsr	:= RetCodUsr()
	Local nTamCC 	:= TamSX3("ZZC_CC")[1]

	IF Select("TMP_ZZF") > 0
		TMP_ZZF->(DbCloseArea())
	ENDIF

	BeginSql Alias "TMP_ZZF"
	SELECT ZZF_CC FROM %Table:ZZF% ZZF
	LEFT JOIN %Table:CTT% CTT
	ON CTT_FILIAL = %xFilial:CTT%
	AND (SUBSTR(CTT.CTT_CUSTO,1,4) = '1030' OR SUBSTR(CTT.CTT_CUSTO,4) = '1040') 
	AND CTT.CTT_CLASSE = '2' 
	AND CTT.CTT_XUSAPR = '1'
	AND CTT.CTT_CUSTO = ZZF_CC
	AND CTT.%NotDel%
	WHERE ZZF.ZZF_FILIAL = %xFilial:ZZF%
	AND ZZF.ZZF_CODUSR = %Exp:cCodUsr%
	AND ZZF.%NotDel%
	AND ZZF_TIPO = '2'
	AND ( ZZF_CC <> '         ' OR ZZF_CC = '*********' )
	EndSql
	TMP_ZZF->(DbGoTop())

	IF TMP_ZZF->(!EOF())
		lRet := .T.
		While TMP_ZZF->(!EOF())
			//cDepto+= AllTrim(TMP_ZZF->ZZF_DEPTO)+"|"
			cCCusto+= PadR(AllTrim(TMP_ZZF->ZZF_CC),nTamCC)+"|"
			TMP_ZZF->(DbSkip())
		EndDo
		//cDepto := FormatIn(cDepto,"|")
	ENDIF

	TMP_ZZF->(DbCloseArea())

Return lRet

Static Function xMudaSitObr(cParam1)

	Local oDlgSit	:= nil
	Local cCadastro	:= "Informe qual situaÁ„o da PPE deseja acessar"
	Local nOpcA		:= 0
	Local oSay1		:= nil
	Local oTpPPE	:= nil
	Local cTpPPE	:= ""
	Local aTiposPPE	:= {}
	Local cDescAtu	:= Posicione("ZZC",1,xFilial("ZZC")+"PP"+cParam1,"ZZC_DESC")
	Local cSitProx	:= AllTrim(ZZC->ZZC_ESTAGI)
	Local oGrpAll	:= nil

	Aadd(aTiposPPE, AllTrim(cParam1)+"="+AllTrim(cDescAtu) )

	IF Select("TMP_PPE") > 0
		TMP_PPE->(DbcloseArea())
	ENDIF

	BeginSql Alias "TMP_PPE"
	SELECT ZZC_DESC, ZZC_CHAVE FROM %Table:ZZC% ZZC
	WHERE ZZC_FILIAL = %xFilial:ZZC%
	AND ZZC_TABELA = 'PP'
	AND ZZC_CHAVE <> %Exp:cParam1%
	AND ZZC.%NotDel%
	AND ( %Exp:cSitProx% LIKE '%'||TRIM(ZZC_CHAVE)||'%' OR %Exp:cSitProx% = '*' )
	EndSql

	TMP_PPE->(DbGoTop())
	while TMP_PPE->(!EOF())

		Aadd(aTiposPPE, AllTrim(TMP_PPE->ZZC_CHAVE)+"="+AllTrim(TMP_PPE->ZZC_DESC) )

		TMP_PPE->(DbSkip())
	EndDo
	TMP_PPE->(DbcloseArea())

	Define MsDialog oDlgSit Title cCadastro ;
		From 00,00 TO 130,400 PIXEL ;
		STYLE nOR(WS_VISIBLE,WS_POPUP)

	oGrpAll:= TGroup():New(00,00,oDlgSit:NCLIENTHEIGHT/2,(oDlgSit:NCLIENTWIDTH/2),"",oDlgSit,CLR_BLUE,,.T.)

	oSay1 := TSay():New(005,005,{|| "<h3>SituaÁ„o atual: "+AllTrim(cParam1)+" - "+AllTrim(cDescAtu)+"</h3>" },oDlgSit,,,,,,.T.,CLR_BLUE,RGB(240,240,240),180,025,,,,,,.T.)

	oTpPPE := TComboBox():New(020, 05,{|u| if( PCount()>0, cTpPPE:=u,cTpPPE)},aTiposPPE,140,20,oDlgSit,,{|| .T. } ,,,,.T.,,,,,,,,,'cTpPPE',"<h3>Mudar Para:</h3>",1,nil,CLR_BLUE)

	oSButton	:= TButton():New( 60, 005, "CONFIRMAR"	, oDlgSit,{|| nOpcA := 1,oDlgSit:End() },50,015,,,,.T.)
	oSButton:SetCss( "QPushButton{ background-color:rgb(28,157,189);}" )

	ACTIVATE MSDIALOG oDlgSit CENTERED

Return cTpPPE

User Function GENA103V(lEmail,cMsgComple)

	Local _ni
	Local aStruHtml	:= {}
	Local bRetSN	:= {|x| IIF( x == "1" , "SIM" , "N√O" ) }
	Local cZZK		:= ""
	Local aNaturez	:= {}
	Local nPosNat	:= 0
	Local cMsg		:= ""
	Local cZZ1		:= ""
	Local cZZJ		:= ""
	Local cZZJb		:= ""
	Local cBaseDA	:= ""
	Local cLink		:= ""

	Default lEmail		:= .F.
	Default cMsgComple	:= ""

	aNaturez	:= StrTokArr(Posicione("SX3",2,"ZZK_TIPINC","X3_CBOX"),";")

//ZZE->(DbGoTo(13))

	Aadd(aStruHtml, {'!sitacao!', xConvHtml( Upper(Posicione("ZZC",1,xFilial("ZZC")+"PP"+ZZE->ZZE_SITOBR,"ZZC_DESC"  )) ) } )
	Aadd(aStruHtml, {'!numppe!',AllTrim(ZZE->ZZE_PPE)} )

	nPosNat := aScan(aNaturez,{|x| Separa(x,"=")[1] == ZZE->ZZE_TIPINC } )
	Aadd(aStruHtml, {'!tipo_ppe!', xConvHtml(Separa(aNaturez[nPosNat],"=")[2]) } )

	Aadd(aStruHtml, {'!editora!',AllTrim( Posicione("SX5",1,xFilial("SX5")+"Z3"+ZZE->ZZE_EMPRES,"X5_DESCRI") )} )
	Aadd(aStruHtml, {'!selo!', Posicione("ZZC",1,xFilial("ZZC")+"Z1"+ZZE->ZZE_SELO,"ZZC_DESC"  ) } )
	Aadd(aStruHtml, {'!centrolucro!', xConvHtml(POSICIONE("CTT",1,xFilial("CTT")+ZZE->ZZE_CC,"CTT_DESC01")) } )
	Aadd(aStruHtml, {'!autor!', xConvHtml(AllTrim(ZZE->ZZE_AUTOR )) } )
	Aadd(aStruHtml, {'!titulo_original!', xConvHtml(AllTrim(ZZE->ZZE_TITORI )) } )
	Aadd(aStruHtml, {'!autor_web!', xConvHtml(AllTrim(ZZE->ZZE_AUTWEB )) } )
	Aadd(aStruHtml, {'!edciao!', xConvHtml(AllTrim(ZZE->ZZE_EDICAO )) } )
	Aadd(aStruHtml, {'!impressao!', cValToChar(ZZE->ZZE_IMPRES) } )
	Aadd(aStruHtml, {'!editor!', xConvHtml(AllTrim(ZZE->ZZE_EDITOR )) } )
	Aadd(aStruHtml, {'!contato!', xConvHtml(AllTrim(ZZE->ZZE_CONTAT )) } )
	Aadd(aStruHtml, {'!titulo_sistema!', xConvHtml(AllTrim(ZZE->ZZE_DESC )) } )
	Aadd(aStruHtml, {'!titulo_publicado!', xConvHtml(AllTrim(ZZE->ZZE_CEME )) } )

	Aadd(aStruHtml, {'!original_isbn!', xConvHtml(AllTrim(ZZE->ZZE_ISBN )) } )
	Aadd(aStruHtml, {'!original_data!', DtoC(ZZE->ZZE_DTORIG) } )
	Aadd(aStruHtml, {'!original_editoria!', xConvHtml(AllTrim(ZZE->ZZE_EDORIG )) } )
	Aadd(aStruHtml, {'!original_preco!', cValToChar(ZZE->ZZE_PVORIG ) } )

//	Aadd(aStruHtml, {'!original_cod_mae!', ZZE->ZZE_IDMAE } )
	ZZK->(DbSetOrder(1))
	ZZK->(DbSeek( ZZE->ZZE_FILIAL+ZZE->ZZE_PPE ))
	cZZK	:= ""
	cCodMae	:= " "
	While ZZK->(!EOF()) .AND. ZZK->ZZK_FILIAL+ZZK->ZZK_PPE == ZZE->ZZE_FILIAL+ZZE->ZZE_PPE
		IF ZZK->ZZK_EMAE <> "1" .OR. Empty(ZZK->ZZK_CODPRO)
			ZZK->(DbSkip())
			Loop
		ENDIF
		IF ZZK->ZZK_TIPINC == "93"
			cCodMae	:= ZZK->ZZK_CODANT
		ELSE
			cCodMae	:= ZZK->ZZK_CODPRO
		ENDIF

		Exit
		ZZK->(DbSkip())
	EndDo

	Aadd(aStruHtml, {'!original_cod_mae!', cCodMae } )

	Aadd(aStruHtml, {'!dt_prev_publi!', DtoC(ZZE->ZZE_DTPPRE ) } )
	Aadd(aStruHtml, {'!dt_contrato!', DtoC(ZZE->ZZE_DTCTR ) } )
	Aadd(aStruHtml, {'!limite_entrega!', xConvHtml(AllTrim(ZZE->ZZE_ENTORI )) } )
	Aadd(aStruHtml, {'!prazo_contrato!', DtoC(ZZE->ZZE_PRZCTR ) } )
	Aadd(aStruHtml, {'!limite_publicacao!', DtoC(ZZE->ZZE_LIMPUB ) } )
	Aadd(aStruHtml, {'!altera_reimpressao!', xConvHtml ( eVal(bRetSN,ZZE->ZZE_ALTREI) ) } )
	Aadd(aStruHtml, {'!pin_livro!', xConvHtml ( eVal(bRetSN,ZZE->ZZE_PIN   ) )  } )
	Aadd(aStruHtml, {'!dt_aprova_comite!', DtoC(ZZE->ZZE_DTAPRO ) } )
	Aadd(aStruHtml, {'!tiragem_ini!', xConvHtml(AllTrim(ZZE->ZZE_TIRPRE )) } )
	//Aadd(aStruHtml, {'!dt_aprova_assinatura!', DtoC(ZZE->ZZE_DTASSI ) } )
	cPosMerca	:= ""
	IF !Empty(ZZE->ZZE_PAC)
		aCBox := Separa(Posicione("SX3",2,"ZZE_PAC","X3_CBOX"),";")
		IF aScan(aCBox, {|x| Left(x,1) == ZZE->ZZE_PAC }) > 0
			cPosMerca := SubStr(aCBox[ aScan(aCBox, {|x| Left(x,1) == ZZE->ZZE_PAC }) ],3,20)
		ENDIF
	ENDIF
	Aadd(aStruHtml, {'!posicaomercado!', cPosMerca } )

	cAcaba := ""
	cAcaba += "Formato de capa: "+AllTrim(POSICIONE("ZZC",1,XFILIAL("ZZC")+"Z8"+ZZE->ZZE_FORCAP,"ZZC_DESC"))+"</p>"
	cAcaba += "Acabamento de capa: "+AllTrim(POSICIONE("ZZC",1,XFILIAL("ZZC")+"Z6"+ZZE->ZZE_TPACAB,"ZZC_DESC"))+"</p>"
	cAcaba += "Cor: "+AllTrim(POSICIONE("ZZC",1,XFILIAL("ZZC")+"Z7"+ALLTRIM(ZZE->ZZE_CORMIO),"ZZC_DESC"))+"</p>"
	Aadd(aStruHtml, {'!acabamento!', cAcaba } )

	Aadd(aStruHtml, {'!ofertar!', xConvHtml ( eVal(bRetSN,ZZE->ZZE_OFERT ) ) } )
	Aadd(aStruHtml, {'!grau!', ZZE->ZZE_GRAU   } )
	Aadd(aStruHtml, {'!area!', xConvHtml(POSICIONE("SZ7",1,XFILIAL("SZ7")+ZZE->ZZE_AREGER,"Z7_DESC")) } )
	Aadd(aStruHtml, {'!grupo!', xConvHtml (AllTrim(Posicione("ZZV",1,xFilial("ZZV") + ZZE->ZZE_CLASSE,"ZZV_DESC"))) } )
	Aadd(aStruHtml, {'!academi_assunto!', xConvHtml(AllTrim(ZZE->ZZE_ASSUNT )) } )
	Aadd(aStruHtml, {'!academi_disciplina!', xConvHtml(AllTrim(ZZE->ZZE_ACADDI )) } )
	Aadd(aStruHtml, {'!academi_curso!', xConvHtml(AllTrim(ZZE->ZZE_ACADCU )) } )
	Aadd(aStruHtml, {'!ppe_area!', '' } )
	Aadd(aStruHtml, {'!ppe_curso!', xConvHtml(AllTrim(ZZE->ZZE_CURSO )) } )
	Aadd(aStruHtml, {'!ppe_disciplina!', xConvHtml(AllTrim(ZZE->ZZE_DISCIP )) } )

	ZZK->(DbSetOrder(1))
	ZZK->(DbSeek( ZZE->ZZE_FILIAL+ZZE->ZZE_PPE ))
	cZZK	:= ""
	While ZZK->(!EOF()) .AND. ZZK->ZZK_FILIAL+ZZK->ZZK_PPE == ZZE->ZZE_FILIAL+ZZE->ZZE_PPE

		IF Empty(ZZK->ZZK_TIPINC)
			ZZK->(DbSkip())
			Loop
		ENDIF

		nPosNat := aScan(aNaturez,{|x| Separa(x,"=")[1] == ZZK->ZZK_TIPINC } )


		cZZK += '<tr style="margin: 0;">
		cZZK += '	<th class="enfase" style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD; border-left: 1px solid #DDD; background-color: #3895c3;" align="left" bgcolor="#3895c3">'+xConvHtml(AllTrim(Posicione("SX5",1,xFilial("SX5")+"Z4"+ZZK->ZZK_IDTPPU,"X5_DESCRI")))+'</th>
		cZZK += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">'+xConvHtml(Separa(aNaturez[nPosNat],"=")[2])+'</td>
		cZZK += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">'+xConvHtml( eVal(bRetSN,ZZK->ZZK_DECISA) )+'</td>
		cZZK += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">'+xConvHtml( eVal(bRetSN,ZZK->ZZK_DIREIT) )+'</td>
		cZZK += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">'+ZZK->ZZK_CODPRO+'</td>
		cZZK += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">'+ZZK->ZZK_CODANT+'</td>
		cZZK += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">'+ZZK->ZZK_CODHIS+'</td>
		cZZK += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">'+ZZK->ZZK_ISBN+'</td>

		cZZK += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">'+xConvHtml("R$ "+AllTrim(Transform(ZZK->ZZK_PRECO ,"@E 999,999,999.99")))+'</td>
		cZZK += '</tr>

		ZZK->(DbSkip())
	EndDo

	Aadd(aStruHtml, {'!lista_produtos!', cZZK } )

	ZZM->(DbSetOrder(1))
	ZZN->(DbSetOrder(1))
	ZZN->(DbSeek( ZZE->ZZE_FILIAL+'GENA103   '+ZZE->ZZE_PPE  ))
	cZZN	:= ""
	While ZZN->(!EOF()) .AND. ZZN->ZZN_ORIGEM+ZZN->ZZN_PRODUT == 'GENA103   '+ZZE->ZZE_PPE

		// cZZN := '<tr style="margin: 0;">
		// cZZN := '	<th class="enfase" style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD; border-left: 1px solid #DDD; background-color: #3895c3;" align="left" bgcolor="#3895c3">'+AllTrim(Posicione("ZZM",1,xFilial("ZZM") + ZZN->ZZN_CODSIT + ZZN->ZZN_CODCAT, "ZZM_CODOLD" ))+'</th>
		// cZZN := '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">!class_area_num!</td>
		// cZZN := '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">!class_curso_num!</td>
		// cZZN := '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">!class_disciplina_num!</td>
		// cZZN := '</tr>

		cZZN += '<tr style="margin: 0;">
		cZZN += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="center">'+xConvHtml(AllTrim(ZZN->ZZN_DESC))+'</td>
		cZZN += '</tr>

		ZZN->(DbSkip())
	EndDo

	Aadd(aStruHtml, {'!classificacao!', cZZN } )

	ZZ1->(DbSetOrder(2))
	ZZ1->(DbSeek( ZZE->ZZE_FILIAL+'GENA103   '+ZZE->ZZE_PPE ))
	cZZ1	:= ""
	While ZZ1->(!EOF()) .AND. ZZ1->ZZ1_FILIAL+ZZ1->ZZ1_ORIGEM+ZZ1->ZZ1_PPE == ZZE->ZZE_FILIAL+'GENA103   '+ZZE->ZZE_PPE

		IF AllTrim(ZZ1->ZZ1_NOME) == "Diretorio PPE-"+AllTrim(ZZE->ZZE_PPE)
			cLink	:= AllTrim(ZZ1->ZZ1_DADO)
		ENDIF
		// cZZ1 += '<tr>
		// cZZ1 += '<td width="15%">
		// cZZ1 += '<span class="f-fallback">
		// cZZ1 += '<strong>'+xConvHtml(AllTrim(ZZ1->ZZ1_TIPO))+'</strong>
		// cZZ1 += '</span>
		// cZZ1 += '</td>
		// cZZ1 += '<td width="85%">
		// cZZ1 += '<span class="f-fallback">
		// cZZ1 += '<a href="'+AllTrim(ZZ1->ZZ1_DADO)+'" class="f-fallback email-masthead_name">'+xConvHtml(AllTrim(ZZ1->ZZ1_NOME))+'</a>
		// cZZ1 += '</span>
		// cZZ1 += '</td>
		// cZZ1 += '</tr>

		cZZ1 += '<tr style="margin: 0;">
		cZZ1 += '    <td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">'+xConvHtml(AllTrim(ZZ1->ZZ1_TIPO))+'</td>
		cZZ1 += '    <td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left"><a href="'+AllTrim(ZZ1->ZZ1_DADO)+'" style="-webkit-box-sizing: border-box; -moz-box-sizing: border-box; box-sizing: border-box;">'+xConvHtml(AllTrim(ZZ1->ZZ1_NOME))+'</a></td>
		cZZ1 += '</tr>

		ZZ1->(DbSkip())
	EndDo
	Aadd(aStruHtml, {'!link_doc!', cZZ1 } )


	ZZJ->(DbSetORder(1))
	ZZJ->(DbSeek(xFilial("ZZJ")+"2"+ZZE->ZZE_PPE))
	aBoxSX3 := StrTokArr(Posicione("SX3",2,"ZZJ_TIPO","X3_CBOX"),";")

	IF Select("TMP_OBS") > 0
		TMP_OBS->(DbCloseArea())
	ENDIF

	BeginSql Alias "TMP_OBS"
		SELECT ZZJ.R_E_C_N_O_ ZZJREC FROM %Table:ZZJ% ZZJ
		WHERE ZZJ_FILIAL = %xFilial:ZZJ%
		AND ZZJ_ORIGEM = %Exp:ZZJ->ZZJ_ORIGEM%
		AND ZZJ_PRODUT = %Exp:ZZJ->ZZJ_PRODUT%
		AND ZZJ.%NotDel%
		ORDER BY ZZJ_TIPO DESC,ZZJ_DATA DESC, ZZJ_HORA DESC	
	EndSql

	While TMP_OBS->(!EOF()) //ZZJ->ZZJ_FILIAL + ZZJ->ZZJ_ORIGEM + ZZJ->ZZJ_PRODUT == xFilial("ZZJ")+"2"+ZZE->ZZE_PPE

		ZZJ->(DbGoTo( TMP_OBS->ZZJREC ))

		IF ZZJ->ZZJ_TIPO == "01"

			cMsgObs := ZZJ->ZZJ_OBS
			IF Empty(cMsgObs)
				TMP_OBS->(Dbskip())
				Loop
			ENDIF
			
			cZZJ += '<tr>
			// cZZJ += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">'+AllTrim(xConvHtml(cMsgObs))+'</td>
			cZZJ += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left" width="10%">'+DtoC(ZZJ->ZZJ_DATA)+" "+ZZJ->ZZJ_HORA+'</td>
			cZZJ += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">'+AllTrim(xConvHtml(cMsgObs))+'</td>
			cZZJ += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="right" width="10%">'+AllTrim(ZZJ->ZZJ_USER)+'</td>
			cZZJ += '</tr>
		ELSE

			cMsgObs := IIF( !Empty(ZZJ->ZZJ_OBS), ZZJ->ZZJ_OBS , ZZJ->ZZJ_OBSTEX )
			IF Empty(cMsgObs) .OR. "Mensagem Complementar E-Mail" $ cMsgObs
				TMP_OBS->(Dbskip())
				Loop
			ENDIF
						
			cZZJb += '<tr>
			// cZZJb += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">'+AllTrim(xConvHtml(cMsgObs))+'</td>
			cZZJb += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left" width="10%">'+DtoC(ZZJ->ZZJ_DATA)+" "+ZZJ->ZZJ_HORA+'</td>
			cZZJb += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="left">'+AllTrim(xConvHtml(cMsgObs))+'</td>
			cZZJb += '	<td style="font-size: 0.8em; text-align: left; margin: 0; border-bottom: 1px solid #DDD; border-bottom: 1px solid #DDD;" align="right" width="10%">'+AllTrim(ZZJ->ZZJ_USER)+'</td>
			cZZJb += '</tr>
		ENDIF

		TMP_OBS->(Dbskip())
	EndDo
	TMP_OBS->(DbCloseArea())

	Aadd(aStruHtml, {'!consideracoes!', cZZJ } )
	Aadd(aStruHtml, {'!observacoes!', cZZJb } )

	IF lEmail
		cBaseDA := AllTrim(ZZE->ZZE_BASEDA)
	ELSE
		cBaseDA := EncodeUTF8(AllTrim(ZZE->ZZE_BASEDA))		
	ENDIF

	cBaseDA := StrTran(cBaseDA,"","")

	Aadd(aStruHtml, {'!basesTermosDA!', cBaseDA } )

	IF Empty(cMsgComple)
		cMsg	:= xRetHtml("workflow\html\ppeonline.html")
	ELSE

		cMsg :=' <html lang="en" style="-webkit-box-sizing: border-box; -moz-box-sizing: border-box; box-sizing: border-box;">
		cMsg +=' <head>
		cMsg +='     <meta charset="UTF-8">
		cMsg +='     <meta http-equiv="Content-Type"  content="text/html charset=UTF-8" />
		cMsg +='     <meta name="viewport" content="width=device-width, initial-scale=1.0">
		cMsg +='     <title>PPE ONLINE</title>
		cMsg +='     
		cMsg +=' </head>
		cMsg +=' <body style="font-family: '+"'Open sans'"+', sans-serif; font-family: '+"'Open sans'"+', sans-serif; margin: auto; width: 1080px; color: #222;">
		cMsg +=' <center>
		cMsg +=' <table cellpadding="10" style="width: 1080px; border-collapse: collapse; margin: 0;" width="1080px">
		cMsg +='     <tr style="margin: 0;">
		cMsg +='       <th class="column8 title enfase" style="text-align: left; margin: 0; font-size: 1.3em; font-weight: bold; width: 66.6%;" align="left" >'+StrTran(cMsgComple,Chr(13)+Chr(10),'</p>')+'</th>
		cMsg +='     </tr>
		cMsg +=' </table>
		cMsg +=' </body>
		cMsg +=' </html>

		cMsg	:= cMsg+Chr(13)+Chr(10)+xRetHtml("workflow\html\ppeonline.html")		
	ENDIF

	IF !Empty(cLink)
		Aadd(aStruHtml, {'#!link_ppe!', cLink } )
	ENDIF


	Aadd(aStruHtml, {"!ZZE_EDITOR!",AllTrim(xConvHtml(ZZE->ZZE_EDITOR)) })
	Aadd(aStruHtml, {"!ZZE_DESC!",AllTrim(xConvHtml(ZZE->ZZE_DESC)) }) 
	Aadd(aStruHtml, {"!ZZE_ENTORI!",AllTrim(xConvHtml(ZZE->ZZE_ENTORI) ) })
	Aadd(aStruHtml, {"!ZZE_CONTAT!",AllTrim(xConvHtml(ZZE->ZZE_CONTAT) ) })
	Aadd(aStruHtml, {"!ZZE_AUTOR!",AllTrim(xConvHtml(ZZE->ZZE_AUTOR))  })
	Aadd(aStruHtml, {"!ZZE_PRZCTR!",DtoC(ZZE->ZZE_PRZCTR) })
	Aadd(aStruHtml, {"!ZZE_LIMPUB!",Dtoc(ZZE->ZZE_LIMPUB) })
	Aadd(aStruHtml, {"!ZZE_AUTOR!",AllTrim(xConvHtml(ZZE->ZZE_AUTOR))  })
	Aadd(aStruHtml, {"!ZZE_EDICAO!",AllTrim(xConvHtml(ZZE->ZZE_EDICAO) ) })
	Aadd(aStruHtml, {"!ZZE_ISBN!",AllTrim(xConvHtml(ZZE->ZZE_ISBN)) }) 
	Aadd(aStruHtml, {"!ZZE_TIRPRE!",AllTrim(xConvHtml(ZZE->ZZE_TIRPRE)) }) 
	Aadd(aStruHtml, {"!ZZE_DTPPRE!",Dtoc(ZZE->ZZE_DTPPRE) }) 
	Aadd(aStruHtml, {"!ZZE_DTCTR!",Dtoc(ZZE->ZZE_DTCTR) })
	Aadd(aStruHtml, {"!ZZE_TITORI!",AllTrim(xConvHtml(ZZE->ZZE_TITORI)) })


	cAtt    := ""

/*	
nHdl 	:= FT_FUSE("PortalPPE\AHU\model1\modelo.html")
FT_FGOTOP()

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Processa a leitura do arquivo texto                  				≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	While !FT_FEOF()
        
    cBuffer := Alltrim(FT_FREADLN())
    cMsg+=cBuffer
    
	FT_FSKIP()
	EndDo

FT_FUSE()
*/

	For _ni := 1 To Len(aStruHtml)
		cAuxText	:= aStruHtml[_ni][2]
		cAuxText	:= IIF( !Empty(cAuxText) , cAuxText , '&nbsp;' )
		cMsg		:= STRTRAN(cMsg,aStruHtml[_ni][1],cAuxText)
	Next

Return cMsg

Static Function xRetHtml(cModel)

	Local nHdl 		:= FT_FUSE(cModel)
	Local cBuffer	:= ""
	Local cRet		:= ""

	if nHdl = -1
		MsgStop("Falha ao tentar carregar o modelo de documento "+cModel)
		return cRet
	endif

	FT_FGOTOP()

	While !FT_FEOF()

		cBuffer := Alltrim(FT_FREADLN())
		cRet+=cBuffer

		FT_FSKIP()
	EndDo

	FT_FUSE()

Return cRet

Static Function xConvHtml(cCharParam,lRemove)

	Local aCharHtml	:= {}
	Local nPosChar	:= 0
	Local nLenChar	:= Len(AllTrim(cCharParam))
	Local nAux		:= 0
	Local cRet		:= ""
	Local cCharAux	:= ""
	Default lRemove	:= .F.
	Aadd(aCharHtml,{'&#33;','!'})
	Aadd(aCharHtml,{'&#34;','"'})
	Aadd(aCharHtml,{'&#35;','#'})
	Aadd(aCharHtml,{'&#36;','$'})
	Aadd(aCharHtml,{'&#37;','%'})
	Aadd(aCharHtml,{'&#38;','&'})
	Aadd(aCharHtml,{'&#39;',"'"})
	Aadd(aCharHtml,{'&#40;','('})
	Aadd(aCharHtml,{'&#41;',')'})
	Aadd(aCharHtml,{'&#42;','*'})
	Aadd(aCharHtml,{'&#43;','+'})
	Aadd(aCharHtml,{'&#44;',','})
//Aadd(aCharHtml,{'&#45;','-'})
	Aadd(aCharHtml,{'&#46;','.'})
	Aadd(aCharHtml,{'&#47;','/'})
	Aadd(aCharHtml,{'&#58;',':'})
	Aadd(aCharHtml,{'&#59;',';'})
	Aadd(aCharHtml,{'&#60;','<'})
	Aadd(aCharHtml,{'&#61;','='})
	Aadd(aCharHtml,{'&#62;','>'})
	Aadd(aCharHtml,{'&#63;','?'})
	Aadd(aCharHtml,{'&#64;','@'})
	Aadd(aCharHtml,{'&#91;','['})
	Aadd(aCharHtml,{'&#92;','\'})
	Aadd(aCharHtml,{'&#93;',']'})
	Aadd(aCharHtml,{'&#94;','^'})
	Aadd(aCharHtml,{'&#95;','_'})
	Aadd(aCharHtml,{'&#96;','`'})
	Aadd(aCharHtml,{'&#123;','{'})
	Aadd(aCharHtml,{'&#124;','|'})
	Aadd(aCharHtml,{'&#125;','}'})
	Aadd(aCharHtml,{'&#126;','~'})
	Aadd(aCharHtml,{'&#161;','°'})
	Aadd(aCharHtml,{'&#162;','¢'})
	Aadd(aCharHtml,{'&#163;','£'})
	Aadd(aCharHtml,{'&#164;','§'})
	Aadd(aCharHtml,{'&#165;','•'})
	Aadd(aCharHtml,{'&#166;','¶'})
	Aadd(aCharHtml,{'&#167;','ß'})
	Aadd(aCharHtml,{'&#168;','®'})
	Aadd(aCharHtml,{'&#169;','©'})
	Aadd(aCharHtml,{'&#170;','™'})
	Aadd(aCharHtml,{'&#171;','´'})
	Aadd(aCharHtml,{'&#172;','¨'})
	Aadd(aCharHtml,{'&#173;','≠'})
	Aadd(aCharHtml,{'&#174;','Æ'})
	Aadd(aCharHtml,{'&#175;','Ø'})
	Aadd(aCharHtml,{'&#176;','∞'})
	Aadd(aCharHtml,{'&#177;','±'})
	Aadd(aCharHtml,{'&#178;','≤'})
	Aadd(aCharHtml,{'&#179;','≥'})
	Aadd(aCharHtml,{'&#180;','¥'})
	Aadd(aCharHtml,{'&#181;','µ'})
	Aadd(aCharHtml,{'&#182;','∂'})
	Aadd(aCharHtml,{'&#183;','∑'})
	Aadd(aCharHtml,{'&#184;','∏'})
	Aadd(aCharHtml,{'&#185;','π'})
	Aadd(aCharHtml,{'&#186;','∫'})
	Aadd(aCharHtml,{'&#187;','ª'})
	Aadd(aCharHtml,{'&#188;','º'})
	Aadd(aCharHtml,{'&#189;','Ω'})
	Aadd(aCharHtml,{'&#190;','æ'})
	Aadd(aCharHtml,{'&#191;','ø'})
	Aadd(aCharHtml,{'&#192;','¿'})
	Aadd(aCharHtml,{'&#193;','¡'})
	Aadd(aCharHtml,{'&#194;','¬'})
	Aadd(aCharHtml,{'&#195;','√'})
	Aadd(aCharHtml,{'&#196;','ƒ'})
	Aadd(aCharHtml,{'&#197;','≈'})
	Aadd(aCharHtml,{'&#198;','∆'})
	Aadd(aCharHtml,{'&#199;','«'})
	Aadd(aCharHtml,{'&#200;','»'})
	Aadd(aCharHtml,{'&#201;','…'})
	Aadd(aCharHtml,{'&#202;',' '})
	Aadd(aCharHtml,{'&#203;','À'})
	Aadd(aCharHtml,{'&#204;','Ã'})
	Aadd(aCharHtml,{'&#205;','Õ'})
	Aadd(aCharHtml,{'&#206;','Œ'})
	Aadd(aCharHtml,{'&#207;','œ'})
	Aadd(aCharHtml,{'&#208;','–'})
	Aadd(aCharHtml,{'&#209;','—'})
	Aadd(aCharHtml,{'&#210;','“'})
	Aadd(aCharHtml,{'&#211;','”'})
	Aadd(aCharHtml,{'&#212;','‘'})
	Aadd(aCharHtml,{'&#213;','’'})
	Aadd(aCharHtml,{'&#214;','÷'})
	Aadd(aCharHtml,{'&#215;','◊'})
	Aadd(aCharHtml,{'&#216;','ÿ'})
	Aadd(aCharHtml,{'&#217;','Ÿ'})
	Aadd(aCharHtml,{'&#218;','⁄'})
	Aadd(aCharHtml,{'&#219;','€'})
	Aadd(aCharHtml,{'&#220;','‹'})
	Aadd(aCharHtml,{'&#221;','›'})
	Aadd(aCharHtml,{'&#222;','ﬁ'})
	Aadd(aCharHtml,{'&#223;','ﬂ'})
	Aadd(aCharHtml,{'&#224;','‡'})
	Aadd(aCharHtml,{'&#225;','·'})
	Aadd(aCharHtml,{'&#226;','‚'})
	Aadd(aCharHtml,{'&#227;','„'})
	Aadd(aCharHtml,{'&#228;','‰'})
	Aadd(aCharHtml,{'&#229;','Â'})
	Aadd(aCharHtml,{'&#230;','Ê'})
	Aadd(aCharHtml,{'&#231;','Á'})
	Aadd(aCharHtml,{'&#232;','Ë'})
	Aadd(aCharHtml,{'&#233;','È'})
	Aadd(aCharHtml,{'&#234;','Í'})
	Aadd(aCharHtml,{'&#235;','Î'})
	Aadd(aCharHtml,{'&#236;','Ï'})
	Aadd(aCharHtml,{'&#237;','Ì'})
	Aadd(aCharHtml,{'&#238;','Ó'})
	Aadd(aCharHtml,{'&#239;','Ô'})
	Aadd(aCharHtml,{'&#240;',''})
	Aadd(aCharHtml,{'&#241;','Ò'})
	Aadd(aCharHtml,{'&#242;','Ú'})
	Aadd(aCharHtml,{'&#243;','Û'})
	Aadd(aCharHtml,{'&#244;','Ù'})
	Aadd(aCharHtml,{'&#245;','ı'})
	Aadd(aCharHtml,{'&#246;','ˆ'})
	Aadd(aCharHtml,{'&#247;','˜'})
	Aadd(aCharHtml,{'&#248;','¯'})
	Aadd(aCharHtml,{'&#249;','˘'})
	Aadd(aCharHtml,{'&#250;','˙'})
	Aadd(aCharHtml,{'&#251;','˚'})
	Aadd(aCharHtml,{'&#252;','¸'})
	Aadd(aCharHtml,{'&#253;','˝'})
	Aadd(aCharHtml,{'&#254;','˛'})
	Aadd(aCharHtml,{'&#255;','ˇ'})
	Aadd(aCharHtml,{'&#256;','?'})

	For nAux := 1 To nLenChar

		cCharAux := SubStr(cCharParam,nAux,1)

		nPosChar := aScan(aCharHtml, {|x| ASC(x[2]) == ASC(cCharAux) } )

		IF !lRemove
			IF nPosChar > 0
				cRet += aCharHtml[nPosChar][1]
			ELSE
				cRet += cCharAux
			ENDIF
		ENDIF

	Next nAux

Return cRet

User Function GENA103M()
	Local oDlgEmail
	Local oListBox
	Local aHList	:= {}
	Local acontatos	:= {}
	Local oOk		:= LoadBitMap(GetResources(),"LBOK")
	Local oNo		:= LoadBitMap(GetResources(),"LBNO")
	Local cTit 		:= ""
	Local oFont		:= TFont():New('ARIAL',,-16,.T.)
	Local cMailCC	:= ""
	Local aNaturez	:= StrTokArr(Posicione("SX3",2,"ZZK_TIPINC","X3_CBOX"),";")
	Local nPosNat	:= aScan(aNaturez,{|x| Separa(x,"=")[1] == ZZE->ZZE_TIPINC } )
	Local oGrpAll,oPntAll,oButPara
	Local cMailDe	:= AllTrim(UsrRetMail(RetCodUsr()))
	Local aAnexos	:= {}

	IF Empty(cMailDe)
		xMagHelpFis("Cadastro",;
			"Seu e-mail n„o est· cadastrado no Protheus!",;
			"Entre em contato com a TI e solicite a atualizaÁ„o do seu cadastro no sistema!"+Chr(13)+Chr(10)+;
			"N„o ser· possÌvel utilizar o envio de e-mail ate¥q eue seu cadastro seja atualizado!";
			)
		Return .F.
	ENDIF

	cTit 		:= PadR("Proposta Editorial "+ZZE->ZZE_PPE+" "+Separa(aNaturez[nPosNat],"=")[2],250)

	nLinha	:= 10

	DEFINE MSDIALOG oDlgEmail TITLE 'Envio de PPE por E-Mail'  From 0,0 To 315,900 pixel STYLE nOR(WS_VISIBLE,WS_POPUP)
	oDlgEmail:lMaximized := .F.

	oGrpAll:= TGroup():New(00,00,oDlgEmail:NCLIENTHEIGHT/2,(oDlgEmail:NCLIENTWIDTH/2),"",oDlgEmail,CLR_BLUE,,.T.)
	@05,15 MSPANEL oPntAll PROMPT "" SIZE (oDlgEmail:NCLIENTWIDTH/2)-30,(oDlgEmail:NCLIENTHEIGHT/2)-10 COLOR CLR_WHITE,CLR_WHITE OF oDlgEmail

	@00,00 MSPANEL oPEnvio PROMPT "" SIZE 100,100 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
	oPEnvio:Align := CONTROL_ALIGN_ALLCLIENT

	TSay():New(01,01,{|| '<h3>Assunto:</h3>' },oPEnvio,,,,,,.T.,,,,,,,,,,.T.)
	oEdit := TGet():New(09,01,{|u| if( Pcount()>0, cTit := u,cTit) },oPEnvio,354,010,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cTit")//,,,,,,,"Assunto: ",0,oTFont,CLR_BLUE )

	nWidth	:= 150
	TSay():New(22,01,{|| '<h3>Mensagem Complementar:</h3>' },oPEnvio,,,,,,.T.,,,nWidth,60,,,,,,.T.)
	cTexto1 := " "
	oTMultiget1 := tMultiget():new(30,01,{| u | if( pCount() > 0, cTexto1 := u, cTexto1 )},oPEnvio,354,60,,,,,,.T.)

	// oButAnexar	:= TButton():New( 95, 01, "Anexos"	, oPEnvio,{|| AnexarArq() },45,45,,oFont,,.T.)
	// oButAnexar:SetCss( "QPushButton{ background-color:rgb(28,157,189);}" )

	AAdd( aHList, ' ')
	AAdd( aHList, 'Contato')
	AAdd( aHList, 'E-Mail')

	IF Empty(UsrRetMail(RetCodUsr()))
		acontatos	:= {{.F.,"",""}}
	ELSE
		acontatos	:= {{.T.,UsrFullName(RetCodUsr()), cMailDe }}
	ENDIF
	oListBox := TWBrowse():New(95,01,354,60,,aHList,,oPEnvio,,,,,,,,,,,,, "ARRAY", .T. )
	oListBox:SetArray( acontatos )
	oListBox:bLine := {|| {	If(acontatos[oListBox:nAT,1], oOk, oNo),;
		acontatos[oListBox:nAT,2],;
		acontatos[oListBox:nAT,3] }}

	oListBox:bLDblClick := {|| acontatos[oListBox:nAt,1] := !acontatos[oListBox:nAt,1],oListBox:Refresh() }

	/*
	Cleuto -  26/11/2020 - removida funcionalidade de anexos a pedido da Simony e Rafael
	aHAnxe	:= {}
	aAnexos	:= {}

	AAdd( aHAnxe, ' ')
	AAdd( aHAnxe, 'Arquivos')

	AAdd(aAnexos, {.F.,""} )

	oLBoxAnx := TWBrowse():New(95,55,300,60,,aHAnxe,,oPEnvio,,,,,,,,,,,,, "ARRAY", .T. )
	oLBoxAnx:SetArray( aAnexos )
	oLBoxAnx:bLine := {|| {	If(aAnexos[oLBoxAnx:nAT,1], oOk, oNo),;
		aAnexos[oLBoxAnx:nAT,2]}}

	oLBoxAnx:bLDblClick := {|| aAnexos[oLBoxAnx:nAt,1] := !aAnexos[oLBoxAnx:nAt,1],oLBoxAnx:Refresh() }
	*/

	oButEnvCli	:= TButton():New( 30, 370, "Enviar"	, oPEnvio,{|| IF( EnvCli(acontatos,aAnexos,cMailCC,nil,AllTrim(cTit), cMailDe, cTexto1) , oDlgEmail:End() , nil ) },50,25,,oFont,,.T.)
	oButEnvCli:SetCss( "QPushButton{ background-color:rgb(144,217,74);}" )

	oButPara	:= TButton():New( 95, 370, "Para"	, oPEnvio,{|| xBuscDesc(@acontatos,oListBox) },50,25,,oFont,,.T.)
	oButPara:SetCss( "QPushButton{ background-color:rgb(28,157,189);}" )

	oButSair	:= TButton():New( 129, 370, "Sair"	, oPEnvio,{|| oDlgEmail:End() },50,25,,oFont,,.T.)
	oButSair:SetCss( "QPushButton{ background-color:rgb(157,47,66);}" )

	ACTIVATE MSDIALOG oDlgEmail CENTERED


Return nil

Static Function AnexarArq()

	Local oOk		:= LoadBitMap(GetResources(),"LBOK")
	Local oNo		:= LoadBitMap(GetResources(),"LBNO")
	Local cArquivo	:= tFileDialog("*.*", OemToAnsi("Selecione o arquivo para envio"), ,getTempPath(),.f.,GETF_MULTISELECT)
//Local cArquivo	:= cGetFile("Arquivo Texto|*.*|Todos os Arquivos|*.*", OemToAnsi("Selecione o arquivo para envio"),0,"SERVIDOR",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
	Local aBkp		:= aClone(aAnexos)
	Local nAux		:= 0

	If !File(cArquivo)
		MsgStop("Arquivo n„o localizado!")
		Return nil
	EndIF

	aAnexos	:= {}

	For nAux := 1 To Len(aBkp)
		If !Empty(aBkp[nAux,2])
			Aadd(aAnexos, aClone(aBkp[nAux]) )
		EndIf
	Next

	AAdd(aAnexos, {.T.,cArquivo} )

	oLBoxAnx:SetArray( aAnexos )
	oLBoxAnx:bLine := {|| {	If(aAnexos[oLBoxAnx:nAT,1], oOk, oNo),;
		aAnexos[oLBoxAnx:nAT,2]}}

	oLBoxAnx:Refresh()

Return nil

Static Function MailConf(cMailCC,cCorpo,cTit,aAnexos)

	Local cAtt		:= ""
	Local nAux		:= 0
	Local nNomeFile	:= ""


	for nAux := 1 to Len(aAnexos)
		IF aAnexos[nAux][1]
			nNomeFile := StrTokArr(aAnexos[nAux][2],"\")
			nNomeFile := nNomeFile[Len(nNomeFile)]
			IF __CopyFile( aAnexos[nAux][2], "\mailspool\"+nNomeFile)
				cAtt+="\mailspool\"+nNomeFile+","
			ELSE
				MsgYesNo("N„o foi possÌvel anexo o arquivo "+nNomeFile+", deseja enviar o e-mail mesmo assim?")
			ENDIF
		ENDIF
	next


	IF U_GenSendMail(,,,"noreply@grupogen.com.br",cMailCC,cTit,cCorpo,cAtt,,.F.)
		MsgInfo("E-Mail enviado com sucesso!")
	ELSE
		MsgStop("Falha ao enviar E-Mail!")
	ENDIF

	for nAux := 1 to Len(aAnexos)
		IF aAnexos[nAux][1]
			nNomeFile := StrTokArr(aAnexos[nAux][2],"\")
			nNomeFile := nNomeFile[Len(nNomeFile)]
			FErase("\mailspool\"+nNomeFile)
		ENDIF
	next

Return nil


Static Function xBuscDesc(acontatos,oListBox)

	Local cRet		:= ""
	Local oDlgDest	:= nil
	Local aHList	:= {"Nome","E-Mail","Departamento","Cargo"}
	Local oTFont 	:= TFont():New('Arial',,-20,.T.)
	Local oPDest	:= nil
	Local oPDTop	:= nil
	Local oGrpDes	:= nil
	Local oGtDesc	:= nil
	Local aBkpUsr	:= {}
	Local oBtSair	:= nil
	Local oPBottom	:= nil
	Local cDest		:= Space(150)
	Local cNome		:= ""
	Local nAux		:= 0
	Local oOk		:= LoadBitMap(GetResources(),"LBOK")
	Local oNo		:= LoadBitMap(GetResources(),"LBNO")
	Local cView		:= Space(500)
	Local aAuxDest	:= {}
	Local nAuxB		:= 0
	Local nLenAcc	:= 0

	Private oLiDesc	:= nil
	Private aDest	:= {}


	IF Select("TMP_USR") > 0
		TMP_USR->(DbCloseArea())
	ENDIF
	BeginSql Alias "TMP_USR"
	SELECT UPPER(USR_NOME) USR_NOME, UPPER(USR_EMAIL) USR_EMAIL, UPPER(USR_DEPTO) USR_DEPTO, UPPER(USR_CARGO) USR_CARGO FROM SYS_USR USR
	WHERE USR_MSBLQL = '2'
	AND USR.%NotDel%
	ORDER BY USR_NOME
	EndSql

	TMP_USR->(DbEval( {|x| Aadd( aDest, { ALLTRIM(TMP_USR->USR_NOME), ALLTRIM(TMP_USR->USR_EMAIL), ALLTRIM(TMP_USR->USR_DEPTO), ALLTRIM(TMP_USR->USR_CARGO) } ) }   ))

	TMP_USR->(DbCloseArea())
	aBkpUsr	:= aClone(aDest)

	DEFINE MSDIALOG oDlgDest TITLE ' '  From 0,0 To 400,800 pixel Style DS_MODALFRAME
	oDlgDest:lMaximized := .F.

	@00,00 MSPANEL oPDTop PROMPT "" SIZE 40,40 COLOR CLR_WHITE,CLR_WHITE OF oDlgDest
	oPDTop:Align := CONTROL_ALIGN_TOP
	oGtDesc	:= TGet():New(10,10,{|u| if( Pcount()>0, cDest := u,cDest) },oPDTop,(oPDTop:NCLIENTWIDTH/2)-30,010,"@!",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cDest",,,,,,,"Pesquisar.: ",1,oTFont,CLR_BLUE )
	oGtDesc:bChange	:= {|x| xFilDesc(aBkpUsr,cDest) }

	@00,00 MSPANEL oPBottom PROMPT "" SIZE 20,20 COLOR CLR_WHITE,CLR_WHITE OF oDlgDest
	oPBottom:Align := CONTROL_ALIGN_BOTTOM

	oBtSair	:= TButton():New( 05, 05, "Confirmar"	, oPBottom,{|| oDlgDest:End() },80,010,,,,.T.)
//oBtPesq	:= TButton():New( 05, 50, "Pesq."	, oPBottom,{|x| xFilDesc(aBkpUsr,cDest) },80,010,,,,.T.)

	@00,00 MSPANEL oPDest PROMPT "" SIZE 100,100 COLOR CLR_WHITE,CLR_WHITE OF oDlgDest
	oPDest:Align := CONTROL_ALIGN_ALLCLIENT

	oGtView	:= TGet():New(10,10,{|u| if( Pcount()>0, cView := u,cView) },oPDest,(oPDest:NCLIENTWIDTH/2)-30,010,"@!",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cView")//,,,,,,,"Pesquisar.: ",1,oTFont,CLR_BLUE )
	oGtView:Align := CONTROL_ALIGN_BOTTOM
	oGtView:bWhen	:= {|| .T. }
	oGtView:cPlaceHold	:= "'Nome Exemplo' <Exemplo@grupogen.com.br>"

	oGrpDes:= TGroup():New(00,00,00,00,"Destinatarios",oPDest,CLR_BLUE,,.T.)
	oGrpDes:Align := CONTROL_ALIGN_ALLCLIENT

	oLiDesc := TWBrowse():New(15,10,(oGrpDes:NCLIENTWIDTH/2)-30,(oGrpDes:NCLIENTHEIGHT/2)-60,,aHList,,oPDest,,,,,,,,,,,,, "ARRAY", .T. )
	oLiDesc:SetArray( aDest )
	oLiDesc:bLine := {|| {	aDest[oLiDesc:nAT,1],;
		aDest[oLiDesc:nAT,2],;
		aDest[oLiDesc:nAT,3],;
		aDest[oLiDesc:nAT,4];
		}}

	oLiDesc:bLDblClick := {|| xAddDesct(@acontatos,@oListBox,@cView,@oGtView) }

	ACTIVATE MSDIALOG oDlgDest CENTERED

	IF !Empty(cView)

		aAuxDest := StrTokArr2(AllTrim(cView),";",.F.)
		cStrAux	 := ""

		For nAux := 1 To Len(aAuxDest)

			cMailAux		:= ""
			cNomeAux		:= ""
			cStrAux			:= aAuxDest[nAux]
			aAuxDest[nAux]	:= StrTran(aAuxDest[nAux],"<"," ")
			aAuxDest[nAux]	:= StrTran(aAuxDest[nAux],">"," ")
			aAuxDest[nAux]	:= StrTran(aAuxDest[nAux],"'"," ")
			aAuxDest[nAux]	:= AllTrim(aAuxDest[nAux])
			aAuxDest[nAux]	:= STRTOKARR(aAuxDest[nAux]," ")

			For nAuxB := 1 To Len(aAuxDest[nAux])
				IF "@" $ aAuxDest[nAux][nAuxB]
					cMailAux := AllTrim(aAuxDest[nAux][nAuxB])
				ELSE
					cNomeAux := cNomeAux+" "+AllTrim(aAuxDest[nAux][nAuxB])
				ENDIF
			Next nAuxB

			IF !ISEMAIL(cMailAux)
				MsgStop("E-Mail Invalido "+cStrAux)
				Loop
			ENDIF

			cNomeAux	:= AllTrim(StrTran(cNomeAux,"'"))
			IF Empty(cNomeAux)
				IF ISEMAIL(cMailAux)
					cNomeAux := Separa(cMailAux,"@")[1]
				ENDIF
			ENDIF

			IF aScan(acontatos,{|x| AllTrim(x[3]) == cMailAux }) == 0
				IF ISEMAIL(cMailAux)
					Aadd(acontatos, {.T.,cNomeAux,cMailAux} )
				ELSE
					MsgStop("E-mial invalido"+cStrAux)
				ENDIF
			ENDIF

			nLenAcc := Len(acontatos)
			For nAuxB := 1 To Len(acontatos)
				IF Empty(acontatos[nAuxB]) .OR. Len(acontatos[nAuxB]) <> 3
					Loop
				ENDIF
				IF Empty(acontatos[nAuxB][3]) .OR. !ISEMAIL(acontatos[nAuxB][3])
					aDel(acontatos,nAuxB)
					nLenAcc--
					nAuxB--
				ENDIF
			Next

			aSize(acontatos,nLenAcc)

			IF Empty(acontatos)
				acontatos	:= {{.F.,"",""}}
			ENDIF


		/*
		aAuxDest[nAux] := StrTokArr(aAuxDest[nAux],"<")

			IF Len(aAuxDest[nAux]) > 2
			MsgStop("E-Mail invaliado"+cStrAux)
			ELSEIF Len(aAuxDest[nAux]) == 1

			aAuxDest[nAux][1] := StrTran(aAuxDest[nAux][1],"<","")
			aAuxDest[nAux][1] := StrTran(aAuxDest[nAux][1],">","")

				IF ISEMAIL(aAuxDest[nAux][1])
				cMailAux := AllTrim(aAuxDest[nAux][1])
				cNomeAux := AllTrim(Left(aAuxDest[nAux][1],At("@",aAuxDest[nAux][1])-1))
				cNomeAux := StrTran(cNomeAux,"'","")
				ENDIF

			ELSEIF Len(aAuxDest[nAux]) == 2

			aAuxDest[nAux][1] := StrTran(aAuxDest[nAux][1],"<","")
			aAuxDest[nAux][1] := StrTran(aAuxDest[nAux][1],">","")
			aAuxDest[nAux][2] := StrTran(aAuxDest[nAux][2],"<","")
			aAuxDest[nAux][2] := StrTran(aAuxDest[nAux][2],">","")

				IF ISEMAIL(aAuxDest[nAux][2])
				cMailAux := AllTrim(aAuxDest[nAux][2])
				cNomeAux := AllTrim(aAuxDest[nAux][1])
				cNomeAux	:= StrTran(cNomeAux,"'","")
				ENDIF
			ENDIF
		*/

		Next nAux

		oListBox:SetArray( acontatos )
		oListBox:bLine := {|| {	If(acontatos[oListBox:nAT,1], oOk, oNo),;
			acontatos[oListBox:nAT,2],;
			acontatos[oListBox:nAT,3] }}

	EndIf

Return cRet

Static Function xAddDesct(acontatos,oListBox,cView,oGtView)
	Local cNome 	:= AllTrim(aDest[oLiDesc:nAT,1])
	Local cRet  	:= AllTrim(aDest[oLiDesc:nAT,2])

	IF aScan(acontatos,{|x| !Empty(x) .AND. AllTrim(x[3]) == cRet }) == 0
		cView := PadR(AllTrim(cView)+" '"+AllTrim(cNome)+"' <"+cRet+">;",500)
		oGtView:CtrlRefresh()
	ELSE
		MsgStop("E-Mail j· informado")
	ENDIF

Return nil

Static Function xFilDesc(aBkpUsr,cDest)

	Local nAux	:= 0

	aDest	:= {}
	For nAux := 1 To Len(aBkpUsr)
		IF Alltrim(cDest) $ aBkpUsr[nAux][1] .OR.;
				Alltrim(cDest) $ aBkpUsr[nAux][2] .OR.;
				Alltrim(cDest) $ aBkpUsr[nAux][3] .OR.;
				Alltrim(cDest) $ aBkpUsr[nAux][4]

			//Aadd(aDest , aBkpUsr[nAux] )
			Aadd(aDest,Array(4))
			aDest[Len(aDest)][1] := aBkpUsr[nAux][1]
			aDest[Len(aDest)][2] := aBkpUsr[nAux][2]
			aDest[Len(aDest)][3] := aBkpUsr[nAux][3]
			aDest[Len(aDest)][4] := aBkpUsr[nAux][4]

		ENDIF
	Next

//oLiDesc:SetArray( aDest )

	oLiDesc:SetArray( aDest )
	oLiDesc:bLine := {|| {	aDest[oLiDesc:nAT,1],;
		aDest[oLiDesc:nAT,2],;
		aDest[oLiDesc:nAT,3],;
		aDest[oLiDesc:nAT,4];
		}}

	oLiDesc:Refresh()

Return .T.

Static Function EnvCli(acontatos,aAnexos,cMailCC,cCorpo,cTit, cMailDe, cMsgComple)

	Local nAux		:= 1
	Local cMail		:= ""
	Local cAtt		:= ""
	Local nNomeFile	:= ""
	Local lRet		:= .F.

	Default cCorpo := u_GENA103V(.T.,cMsgComple)
	
	For nAux := 1 To Len(acontatos)
		IF !acontatos[nAux][1]
			Loop
		ENDIF

		IF !ISEMAIL(AllTrim(acontatos[nAux][3]))
			MsgStop("E-Mail invalido "+AllTrim(acontatos[nAux][1]))
		ELSE
			cMail += AllTrim(acontatos[nAux][3])+";"
		ENDIF
	Next

	for nAux := 1 to Len(aAnexos)
		IF aAnexos[nAux][1]
			nNomeFile := StrTokArr(aAnexos[nAux][2],"\")
			nNomeFile := nNomeFile[Len(nNomeFile)]
			IF __CopyFile( aAnexos[nAux][2], "\mailspool\"+nNomeFile)
				cAtt+="\mailspool\"+nNomeFile+","
			ELSE
				MsgYesNo("N„o foi possÌvel anexo o arquivo "+nNomeFile+", deseja enviar o e-mail mesmo assim?")
			ENDIF
		ENDIF
	next


	IF !Empty(cMail)
		IF U_GenSendMail(,,,cMailDe,cMail,cTit,cCorpo,cAtt,,.F.)

			IF !Empty(cMsgComple)
				RecLock("ZZJ",.T.)
				ZZJ->ZZJ_FILIAL	:= xFilial("ZZJ")
				ZZJ->ZZJ_PRODUT	:= ZZE->ZZE_PPE
				ZZJ->ZZJ_DATA  	:= DDataBase
				ZZJ->ZZJ_HORA  	:= Left(Time(),5)
				ZZJ->ZZJ_OBS   	:= cMsgComple
				ZZJ->ZZJ_USER  	:= AllTrim(UsrRetName(RetCodUsr()))
				ZZJ->ZZJ_OBSTEX	:= "Mensagem Complementar E-Mail"
				ZZJ->ZZJ_ORIGEM	:= "2"
				ZZJ->ZZJ_TIPO	:= "00" // 00=ObservaÁ„o ; 01 = ConsideraÁ„o de aprovaÁ„o
				MsUnLock()
			EndIf	

			lRet	:= .T.
			MsgAlert( "E-mail enviado com sucesso!" )
		ELSE
			MsgStop( "Falha ao enviar e-mail!" )
		ENDIF
	ELSE
		MsgStop("Nenhum e-mail valido foi informado!")
	ENDIF

	for nAux := 1 to Len(aAnexos)
		IF aAnexos[nAux][1]
			nNomeFile := StrTokArr(aAnexos[nAux][2],"\")
			nNomeFile := nNomeFile[Len(nNomeFile)]
			FErase("\mailspool\"+nNomeFile)
		ENDIF
	next

Return lRet

/*/
	‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
	±±∫Programa  ≥GENA103T  ∫Autor  ≥Cleuto              ∫ Data ≥  25/06/2020 ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Desc.     ≥funÁ„o responsavel por realizar a copia da EJP para uma psta∫±±
	±±∫          ≥de nackup                                                   ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Uso       ≥ GEN - Projeto Gest„o de Obras                              ∫±±
	±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function GENA103T(cDepto,cNumPPE,cUrlDoc,oModel)

	Local lRet		:= .F.
	Local cToken	:= ""
	Local cIdDoc	:= ""
	Local cDriveId	:= ""
	Local cIdRef	:= ""
	Local cConteudo	:= ""
	Local cNameFile	:= ""
	Local lToken	:= .F.
	Local lUrlAzu	:= .F.
	Local lIdDoc	:= .F.
	Local lFileOk	:= .F.
	Local cUrlAzure	:= AllTrim(GetMv("GEN_URLAZU",.F.,"GENAZURE.SHAREPOINT.COM"))
	Local cDrivePPE	:= ""
	Local cIdFldPPE	:= ""
	Local lExist	:= .F.
	Local cRevi		:= ""
	Local nQtdAux	:= 0
	Local cNameRev	:= ""

	Default cDepto	:= ""
	Default cUrlDoc := ""

	IF Empty(cUrlDoc) .OR. Empty(cDepto)
		oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' , "EJP - Origem do arquivo inv·lida", 'O caminho ou URL informada para EJP È inv·lido!!', 'Na aba arquivos corrija o caminho informado para a EJP e tente novamente!')
		Return .F.
	ENDIF

//---------------------------------------
// Busco Token no Microsoft Graph       -
//---------------------------------------
	lToken := xGetToken(@cToken,oModel)

//---------------------------------------
// Verifico diretorio de PEs aprovadas  -
//---------------------------------------
	lPastaPPE := xPastaPPE(cToken,cDepto,nil,@cDrivePPE,@cIdFldPPE,oModel,.T.)
	IF lPastaPPE
		lPastaPPE := xPastaPPE(cToken,cNumPPE,cIdFldPPE,@cDrivePPE,@cIdFldPPE,oModel,.T.)
	ENDIF
//---------------------------------------
// Verifico se È uma URL do Sharepoint  -
//---------------------------------------

	IF Empty(oModel:GetValue("ZZE_FORM", "ZZE_REVI"))
		cRevi := StrZero(0,TamSx3("ZZE_REVI")[1])
		oModel:LoadValue( 'ZZE_FORM', 'ZZE_REVI', cRevi )
	ENDIF

	lUrlAzu:= Upper(cUrlAzure) $ Upper(cUrlDoc)
	IF lUrlAzu
		//---------------------------------------
		//* Busco ID do documento               -
		//---------------------------------------
		lIdDoc	:= .F.
		nQtdId	:= 0
		While !lIdDoc .AND. nQtdId <= 12
			lIdDoc	:= xGetIdDoc(cToken,cUrlDoc,@cIdDoc,@cDriveId,@cIdRef,oModel,@cNameFile)
			nQtdId++
			IF !lIdDoc
				Sleep(5000)
			ENDIF
		EndDo

		IF lIdDoc
			IF Empty(oModel:GetValue("ZZE_FORM", "ZZE_REVI"))
				cNameRev:= cNameFile
			ELSE
				cNameRev:= Left(cNameFile,;
					Rat(".",cNameFile)-1)+;
					"_"+;
					oModel:GetValue("ZZE_FORM", "ZZE_REVI")+;
					AllTrim(SubStr(cNameFile,Rat(".",cNameFile),10);
					)
			ENDIF
			lExist	:= .T.
			While lExist
				lExist	:= xExistDoc(cToken,cNameRev,cDrivePPE,cIdFldPPE,oModel)
				IF lExist
					cRevi := Soma1(oModel:GetValue("ZZE_FORM", "ZZE_REVI"))
					oModel:LoadValue( 'ZZE_FORM', 'ZZE_REVI', cRevi )
					cNameRev := Left(cNameFile,;
						Rat(".",cNameFile)-1)+;
						"_"+;
						oModel:GetValue("ZZE_FORM", "ZZE_REVI")+;
						AllTrim(SubStr(cNameFile,Rat(".",cNameFile),10);
						)
				ENDIF
				nQtdAux++
				IF nQtdAux >= 10
					lRet	:= .F.
					oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' ,;
						" Controle de EJP ",;
						'Falha ao tentar criar a copia da EJP para pasta de versionamento ',;
						'Entre em contato com a TI, pode ser qe j· exista um documento com memso nome!')
				ENDIF
			EndDo
			IF cNameRev == cNameFile
				// se envir o mesmo nome da erro a API
				cNameRev := ""
			ENDIF
		ELSE
			lRet	:= .F.
			oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' ,;
				" Controle de EJP ",;
				'Falha ao tentar criar a copia da EJP para pasta de versionamento ',;
				'Entre em contato com a TI, n„o foi possÌvel obter o ID do documento no Sharepoint!')
			Return 	lRet
		ENDIF

	ELSE
		//-----------------------------------------------
		// quando arquivo local pego os dados binarios  -
		//-----------------------------------------------
		lFileOk	:= File(cUrlDoc)
		IF lFileOk
			lExist	:= .T.
			While lExist
				lFileOk	:= xGetContFile(cUrlDoc,@cConteudo,@cNameFile,oModel)
				IF !lFileOk
					oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' , " Bacup EJP ", 'N„o foi possÌvel ler o conte˙do do arquivo da EJP', 'Na aba arquivos corrija o caminho da EJP informado e tente novamente')
					Exit
				EndIF
				lExist	:= xExistDoc(cToken,cNameFile,cDrivePPE,cIdFldPPE,oModel)
				IF lExist
					cRevi := Soma1(oModel:GetValue("ZZE_FORM", "ZZE_REVI"))
					oModel:LoadValue( 'ZZE_FORM', 'ZZE_REVI', cRevi )
				ENDIF
				nQtdAux++
				IF nQtdAux >= 10
					oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' ,;
						" Controle de EJP ",;
						'Falha ao tentar criar a copia da EJP para pasta de versionamento ',;
						'Entre em contato com a TI, pode ser qe j· exista um documento com memso nome!')
				ENDIF
			EndDo
		ENDIF
	ENDIF

	IF lToken
		IF lUrlAzu
			/*
			IF lIdDoc
				//------------------------------------------------
				// copia de arquivo entre drivers do Sharepoint  -
				//------------------------------------------------
				Processa({|| ;
					lRet := xCopyFile(cToken,cIdDoc,cDriveId,cIdFldPPE,oModel,cNameRev);
					},"Copia de seguranÁa da EJP","Aguarde.. estamos realizando a copia da EJP para uma pasta de versionamento!",.F.)
			ELSE
				lRet := .F.
			ENDIF
			*/
			IF lIdDoc
				lConfirmCopy := .F.
				nQtdTenta	:= 0
				While !lConfirmCopy .AND. nQtdTenta <= 5
					nQtdTenta++
					//------------------------------------------------
					// copia de arquivo entre drivers do Sharepoint  -
					//------------------------------------------------
					Processa({|| ;
						lConfirmCopy := xCopyFile(cToken,cIdDoc,cDriveId,cIdFldPPE,oModel,cNameRev);
						},"Copia de seguranÁa da EJP","Aguarde.. estamos realizando a copia da EJP para uma pasta de versionamento!",.F.)
					IF !lConfirmCopy
						cRevi := Soma1(oModel:GetValue("ZZE_FORM", "ZZE_REVI"))
						oModel:LoadValue( 'ZZE_FORM', 'ZZE_REVI', cRevi )
						cNameRev:= Left(cNameFile,;
							Rat(".",cNameFile)-1)+;
							"_"+;
							oModel:GetValue("ZZE_FORM", "ZZE_REVI")+;
							AllTrim(SubStr(cNameFile,Rat(".",cNameFile),10);
							)
					ENDIF
				EndDo
				lRet := lConfirmCopy
			ELSE
				lRet := .F.
			ENDIF

		ELSE
			IF lFileOk
				//------------------------------------------------
				// upload de arquivo local para sharepoint       -
				//------------------------------------------------
				Processa({|| ;
					lRet := xUpFileTo(cToken,cConteudo,cNameFile,cUrlDoc,cDrivePPE,cIdFldPPE,oModel);
					},"Copia de seguranÁa da EJP","Aguarde.. estamos realizando a copia da EJP para uma pasta de versionamento!",.F.)
			ENDIF
		ENDIF
	ENDIF

Return lRet

/*/
	‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
	±±∫Programa  ≥xUpFileTo ∫Autor  ≥Cleuto              ∫ Data ≥  25/06/2020 ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Uso       ≥ GEN - Projeto Gest„o de Obras                              ∫±±
	±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function xUpFileTo(cToken,cConteudo,cNameFile,cUrlDoc,cDrivePPE,cIdFldPPE,oModel)

	Local lRet		:= .F.
	Local cRet		:= ""

	Local aNames		:= {}
	Local aHeadStr		:= {}
	Local nPosId		:= 0
	Local cUrlGraph		:= cMicroGraph
	Local cHeaderGet	:= ""
	Local oJson			:= JsonObject():New()
	Local oRest     	:= FwRest():New(cUrlGraph)

	AADD(aHeadStr, "Authorization: bearer " + cToken )
	AADD(aHeadStr, "Content-Type: text/plain")

	oRest:SetPath(escape("/drives/"+cDrivePPE+"/items/"+cIdFldPPE+":/"+cNameFile+":/content"))

	If oRest:Put(aHeadStr,cConteudo)
		cRetWeb := oRest:GetResult()
		oJson:fromJson(cRetWeb)
		aNames	:= oJson:GetNames()
		nPosId	:= aScan(aNames,{|x| Upper(x) == "ID" })
		IF nPosId == 0
			IF ValType(oModel) == "O"
				oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' , " Controle de EJP ", 'Falha ao tentar criar uma copia de seguranÁa da EJP no Sharepoint', 'Entre en contato com a TI e informe o erro a seguir:'+cRetWeb)
			ELSE
				MsgInfo('Entre en contato com a TI e informe o erro a seguir:'+cRetWeb)
			ENDIF
		ELSE
			lRet := xCheckin(cToken,cDrivePPE,oJson[aNames[nPosId]])
		ENDIF
	Else
		cRetWeb := oRest:GetLastError()
		IF ValType(oModel) == "O"
			oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' , " Controle de EJP ", 'Falha ao tentar criar uma copia de seguranÁa da EJP no Sharepoint', 'Entre en contato com a TI e informe o erro a seguir:'+cRetWeb)
		ELSE
			MsgInfo('Entre en contato com a TI e informe o erro a seguir:'+cRetWeb)
		ENDIF
	EndIf

Return lRet

Static Function xCheckin(cToken,cDrivePPE,cIdDocUp)
	Local lRet	:= .F.

	Local aHeadStr		:= {}
	Local cUrlGraph		:= ""
	Local cHeaderGet	:= ""
	Local bMsgErro		:= {|x| xMagHelpFis("Acesso SharePoint","Falha ao tentar obter o token de acesso ao SharePoint!"+Chr(13)+Chr(10)+"Entre em contato com a TI e informe o erro abaixo!",cRet+Chr(13)+Chr(10)+cHeaderGet) }
	Local cRet			:= ""

return .T.

	AADD(aHeadStr, "Authorization: bearer " + cToken )
	AADD(aHeadStr, "Content-Type: application/json")

	cUrlgraph := cMicroGraph+"/drives/"+cDrivePPE+"/items/"+cIdDocUp+"/checkin"
	cParam	  := '{"comment":"Checkin Protheus"}'
	cRet 	  := HttpPost( cUrlgraph, nil , cParam, ,  aHeadStr ,  @cHeaderGet  )

	IF "204 NO CONTENT" $ Upper(cHeaderGet) .AND. Empty(cRet)
		lRet := .T.
	ELSE
		eVal(bMsgErro)
	ENDIF

Return lRet

Static Function xGetContFile(cUrlDoc,cConteudo,cNameFile,oModel)

	Local lRet		:= .T.
	Local aAux		:= Separa(cUrlDoc,"\")
	Local nHandle	:= 0
	Local aFiles := {} // O array receber· os nomes dos arquivos e do diretÛrio
	Local aSizes := {} // O array receber· os tamanhos dos arquivos e do diretorio

	ADir(cUrlDoc, aFiles, aSizes)//Verifica o tamanho do arquivo, par‚metro exigido na FRead.

	nHandle := fopen(cUrlDoc , FO_READWRITE + FO_SHARED )
	FRead( nHandle, cConteudo, aSizes[1] ) //Carrega na vari·vel cString, a string ASCII do arquivo.

	fclose(nHandle)
	cNameFile := aAux[Len(aAux)]

	IF !Empty(oModel:GetValue("ZZE_FORM", "ZZE_REVI"))
		cNameFile := Left(cNameFile,;
			Rat(".",cNameFile)-1)+;
			"_"+;
			oModel:GetValue("ZZE_FORM", "ZZE_REVI")+;
			AllTrim(SubStr(cNameFile,Rat(".",cNameFile),10);
			)
	ENDIF

Return lRet

Static Function xGetToken(cToken, oModel)

	Local lRet			:= .F.
	Local cTenant		:= GetMv("GEN_TENANT",.F.,"f4d29322-41d3-48e3-85d0-304df473dea7")
	Local cUrl          := "https://login.microsoftonline.com/"+cTenant+"/oauth2/v2.0/token"
	Local client_id     := GetMv("GEN_AZUCLI",.F.,"946a4006-e2ed-4b56-8eef-5d7faa7430cb")
	Local scope         := "https://graph.microsoft.com/.default"
	Local client_secret	:= GetMv("GEN_AZUSEC",.F.,"89qHvICdEx4_-~dFQi.oJxJ0m2pEk_OiO4")
	Local grant_type    := "client_credentials"
	Local cRet			:= ""
	Local cParam 		:= "client_id="+client_id
	Local aJSon			:= {}
	Local aNames		:= {}
	Local aHeadStr		:= {}
	Local cHeaderGet	:= ""
	Local nPosToken		:= 0
	Local oJson			:= JsonObject():New()
	Local bMsgErro		:= nil

	IF ValType(oModel) == ""
		bMsgErro := {|x| oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' , "Acesso SharePoint", "Falha ao tentar obter o token de acesso ao SharePoint!"+Chr(13)+Chr(10)+"Entre em contato com a TI e informe o erro abaixo!", cHeaderGet) }
	ELSE
		bMsgErro := {|x| MsgInfo(cHeaderGet) }
	ENDIF

	cParam += "&scope="+scope
	cParam += "&client_secret="+client_secret
	cParam += "&grant_type="+grant_type

	cRet := HttpPost( cUrl, nil , cParam, ,  aHeadStr ,  @cHeaderGet  )

	IF !("ACCESS_TOKEN" $ Upper(cRet))
		eVal(bMsgErro)
	ELSE

		aJSon 		:= oJson:FromJson(cRet)

		If !ValType(aJSon) == "U"
			eVal(bMsgErro)
		Else

			aNames 		:= oJson:GetNames( )
			nPosToken 	:= aScan(aNames,{|x| Upper(x) == "ACCESS_TOKEN" })

			IF nPosToken == 0
				eVal(bMsgErro)
			Else
				cToken	:= oJson[aNames[nPosToken]]
				lRet	:= .T.
			ENDIF
		Endif
	ENDIF

Return lRet


Static Function xGetIdDoc(cToken,cUrlDoc,cIdDoc,cDriveId,cIdRef,oModel,cNameFile)

	Local lRet			:= .F.
	Local cUrlAux 		:= Unescape(cUrlDoc)
	Local cVideoSuporte	:= "https://www.loom.com/share/d3011a15d27d4f9d9d426d3b1cc26cb2"

	Local nPosSite 		:= 0
	Local nPosSource	:= 0
	Local cSite			:= ""
	Local cIdSite		:= ""
	Local cSource		:= ""

	Local aHeadStr      := {}
	Local cHeaderGet    := ""
	Local nTimeOut      := 60
	Local oJson			:= JsonObject():New()
	Local cUrlgraph		:= cMicroGraph+"/sites/"
	Local cRet			:= ""
	Local aNames		:= {}
	Local bMsgErro		:= {|x| oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' , "Acesso SharePoint", "Falha ao tentar obter o ID sharpoint do documento informado!"+Chr(13)+Chr(10)+"Entre em contato com a TI e informe o erro abaixo!", cHeaderGet) }
	Local aFiles		:= {}
	Local aNaFiles		:= {}
	Local nPosName 		:= 0
	Local nPosIdFi 		:= 0
	Local nPosFile		:= 0
	Local nAuxF			:= 0
//Local cNameDoc		:= ""
	Local cFileUrl		:= ""
	Local nPosPare		:= 0
	Local nPDriId		:= 0
	Local nPIdRef		:= 0

/* localizo o site que est· armazenando o documento */
	IF !("SITES" $ Upper(cUrlAux) .AND. "SOURCEDOC" $ Upper(cUrlAux))
		oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' , "<h1>URL Inv·lida:</h1>", 'Acesse o link a seguir e veja o video instrutivo de como obter uma URL v·lida!</b> <p></b><a href="'+cVideoSuporte+'">'+cVideoSuporte+'</a>')
	ELSE

		nPosSite 	:= At("SITES",Upper(cUrlAux))+6
		nPosSource	:= At("SOURCEDOC",Upper(cUrlAux))+10
		nPosFile	:= At("FILE",Upper(cUrlAux))+5

		cSite	:= SubStr(cUrlAux, nPosSite , At("/",Upper(cUrlAux),nPosSite)-nPosSite )
		cSource := SubStr(cUrlAux, nPosSource , At("&",Upper(cUrlAux),nPosSite)-nPosSource )
		cSource	:= StrTran(StrTran(cSource,"{",""),"}","")
		cFileUrl:= SubStr(cUrlAux, nPosFile , At("&",Upper(cUrlAux),nPosFile)-nPosFile )

		IF !xGetIdSite(cToken,cSite,@cIdSite)
			oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' , " Controle de EJP ", 'N„o foi possÌvel obter o ID do Site SharePoint utilizando a URL informada', 'entre em contato com a TI')
		ELSE
			AADD(aHeadStr, "Authorization: bearer " + cToken )
			AADD(aHeadStr, "Content-Type: application/json")

			cUrlgraph += cIdSite+"/drive/root/search(q='{"+cSource+"}')"

			cRet := HttpGet( cUrlgraph , nil, nTimeOut , aHeadStr , @cHeaderGet  )

			IF !( "VALUE" $ Upper(cRet) )
				Eval(bMsgErro)
			ELSE
				aJSon 		:= oJson:FromJson(cRet)
				If !ValType(aJSon) == "U"
					Eval(bMsgErro)
				Else

					aNames 		:= oJson:GetNames()
					nPosValue 	:= aScan(aNames,{|x| Upper(x) == "VALUE" })

					IF nPosValue == 0
						Eval(bMsgErro)
					Else
						aFiles	:= oJson[aNames[nPosValue]]
						For nAuxF := 1 To Len(aFiles)
							aNaFiles := aFiles[nAuxF]:GetNames()
							nPosName := aScan(aNaFiles,{|x| Upper(x) == "NAME" })
							nPosIdFi := aScan(aNaFiles,{|x| Upper(x) == "ID" })
							nPosPare := aScan(aNaFiles,{|x| Upper(x) == "PARENTREFERENCE" })
							nPosUrl  := aScan(aNaFiles,{|x| Upper(x) == "WEBURL" })

							IF nPosName == 0 .OR. nPosIdFi == 0
								Eval(bMsgErro)
								Exit
							ELSE
								//IF Upper(aFiles[nAuxF][aNaFiles[nPosName]]) == Upper(cFileUrl)
								IF cSource $ aFiles[nAuxF][aNaFiles[nPosUrl]]
									aNaParent	:= aFiles[nAuxF][aNaFiles[nPosPare]]:GetNames()
									nPDriId	 := aScan(aNaParent,{|x| Upper(x) == "DRIVEID" })
									nPIdRef	 := aScan(aNaParent,{|x| Upper(x) == "ID" })

									//cNameFile	:= DecodeUtf8(aFiles[nAuxF][aNaFiles[nPosName]])
									cNameFile	:= DecodeUTF8(aFiles[nAuxF][aNaFiles[nPosName]])
									cIdDoc		:= aFiles[nAuxF][aNaFiles[nPosIdFi]]

									cDriveId:= aFiles[nAuxF][aNaFiles[nPosPare]][aNaParent[nPDriId]]
									cIdRef	:= aFiles[nAuxF][aNaFiles[nPosPare]][aNaParent[nPIdRef]]

									lRet	:= .T.
									Exit
								ENDIF
							ENDIF
						Next nAuxF
						IF !lRet
							Eval(bMsgErro)
						ENDIF
					EndIf
				EndIF
			EndIf

		ENDIF
	ENDIF

Return lRet

Static Function xExistDoc(cToken,cNameFile,cDriveId,cIdFldPPE,oModel)

	Local lRet			:= .F.
	Local nPosSite 		:= 0
	Local nPosSource	:= 0
	Local cSite			:= ""
	Local cIdSite		:= ""
	Local cSource		:= ""

	Local aHeadStr      := {}
	Local cHeaderGet    := ""
	Local nTimeOut      := 60
	Local oJson			:= JsonObject():New()
	Local cUrlgraph		:= cMicroGraph
	Local cRet			:= ""
	Local aNames		:= {}
	Local bMsgErro		:= {|x| oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' , "Acesso SharePoint", "Falha ao tentar obter o ID sharpoint do documento informado!"+Chr(13)+Chr(10)+"Entre em contato com a TI e informe o erro abaixo!", cHeaderGet) }
	Local aFiles		:= {}
	Local aNaFiles		:= {}
	Local nPosName 		:= 0
	Local nPosIdFi 		:= 0
	Local nPosFile		:= 0
	Local nAuxF			:= 0
	Local cNameDoc		:= ""
	Local cFileUrl		:= ""
	Local nPosPare		:= 0
	Local nPDriId		:= 0
	Local nPIdRef		:= 0
	Local cTipoFile		:= ""
	Local cIdSite		:= ""
	Local oJsonPai		:= nil
	Local aJsonPai		:= {}
	Local aNameDoc		:= {}

	cTipoFile 	:= Separa(cNameFile,".")
	cTipoFile	:= cTipoFile[Len(cTipoFile)]

	AADD(aHeadStr, "Authorization: bearer " + cToken )
	AADD(aHeadStr, "Content-Type: application/json")

	IF !xGetIdSite(cToken,"PPEDigital",@cIdSite)
		Return .F.
	ENDIF

	cUrlgraph += "/sites/"+cIdSite+"/drive//root/search(q='{"+cTipoFile+"}')"

//https://graph.microsoft.com/v1.0/sites/genazure.sharepoint.com,ccad27c0-d8af-4f87-b821-301f93f94780,dc4c078f-a0bd-4397-b2d2-62db5243b611/drive/root/search(q='xls')

	cRet := HttpGet( cUrlgraph , nil, nTimeOut , aHeadStr , @cHeaderGet  )

	IF !( "VALUE" $ Upper(cRet) )
		Eval(bMsgErro)
	ELSE
		aJSon 		:= oJson:FromJson(cRet)
		If !ValType(aJSon) == "U"
			Eval(bMsgErro)
		Else

			aNames 		:= oJson:GetNames()
			nPosValue 	:= aScan(aNames,{|x| Upper(x) == "VALUE" })

			IF nPosValue == 0
				Eval(bMsgErro)
			Else
				aFiles	:= oJson[aNames[nPosValue]]
				For nAuxF := 1 To Len(aFiles)
					aNaFiles := aFiles[nAuxF]:GetNames()
					nPosName := aScan(aNaFiles,{|x| Upper(x) == "NAME" })
					nPosIdFi := aScan(aNaFiles,{|x| Upper(x) == "ID" })
					nPosPare := aScan(aNaFiles,{|x| Upper(x) == "PARENTREFERENCE" })

					IF nPosName == 0 .OR. nPosIdFi == 0
						Eval(bMsgErro)
						Exit
					ELSE
						aNaParent	:= aFiles[nAuxF][aNaFiles[nPosPare]]:GetNames()
						nPDriId	 	:= aScan(aNaParent,{|x| Upper(x) == "DRIVEID" })
						nPIdRef		:= aScan(aNaParent,{|x| Upper(x) == "ID" })
						cIdDoc		:= aFiles[nAuxF][aNaFiles[nPosIdFi]]
						cDriveId	:= aFiles[nAuxF][aNaFiles[nPosPare]][aNaParent[nPDriId]]
						IF aFiles[nAuxF][aNaFiles[nPosPare]][aNaParent[nPIdRef]] == cIdFldPPE
							cHeaderGet	:= ""
							cUrlgraph	:= cMicroGraph+"/drives/"+cDriveId+"/items/"+cIdDoc
							cRet 		:= DecodeUtf8(HttpGet( cUrlgraph , nil, nTimeOut , aHeadStr , @cHeaderGet  ))
							oJsonPai	:= JsonObject():New()
							aJsonPai 	:= oJsonPai:FromJson(cRet)
							aNameDoc	:= oJsonPai:GetNames()
							nPNaFile	:= aScan(aNameDoc,{|x| Upper(x) == "NAME" })
							nUrlWeb  	:= aScan(aNameDoc,{|x| Upper(x) == "WEBURL" })

							IF NoAcento(Upper(DecodeUtf8(oJsonPai[aNameDoc[nPNaFile]]))) == NoAcento(Upper(cNameFile))
								lRet := .T.
								Exit
							ENDIF
						ENDIF
					ENDIF
				Next nAuxF
			EndIf
		EndIF
	EndIf


Return lRet

Static Function xGetIdSite(cToken,cSite,cIdSite)

	Local lRet			:= .F.
	Local aHeadStr      := {}
	Local cHeaderGet    := ""
	Local nTimeOut      := 60
	Local oJson			:= JsonObject():New()
	Local nPosValue		:= 0
	Local cUrlgraph		:= cMicroGraph+"/sites?search="
	Local cRet			:= ""
	Local aNames		:= {}
	Local aNaValue		:= {}
	Local bMsgErro		:= {|x| xMagHelpFis("Acesso SharePoint","Falha ao tentar obter a listagem de sites do SharePoint!"+Chr(13)+Chr(10)+"Entre em contato com a TI e informe o erro abaixo!",cRet+Chr(13)+Chr(10)+cHeaderGet) }
	Local aSites		:= {}
	Local nAuxS			:= 0

	AADD(aHeadStr, "Authorization: bearer " + cToken )
	AADD(aHeadStr, "Content-Type: application/json")

	cRet := HttpGet( cUrlgraph , nil, nTimeOut , aHeadStr , @cHeaderGet  )

	IF !( "VALUE" $ Upper(cRet) )
		Eval(bMsgErro)
	ELSE
		aJSon 		:= oJson:FromJson(cRet)
		If !ValType(aJSon) == "U"
			Eval(bMsgErro)
		Else

			aNames 		:= oJson:GetNames()
			nPosValue 	:= aScan(aNames,{|x| Upper(x) == "VALUE" })

			IF nPosValue == 0
				Eval(bMsgErro)
			Else
				aSites	:= oJson[aNames[nPosValue]]
				For nAuxS := 1 To Len(aSites)
					aNaValue := aSites[nAuxS]:GetNames()
					nPosName := aScan(aNaValue,{|x| Upper(x) == "NAME" })
					nPosIdSi := aScan(aNaValue,{|x| Upper(x) == "ID" })
					IF nPosName == 0 .OR. nPosIdSi == 0
						Eval(bMsgErro)
						Exit
					ELSE
						IF Upper(aSites[nAuxS][aNaValue[nPosName]]) == Upper(cSite)
							cIdSite	:= aSites[nAuxS][aNaValue[nPosIdSi]]
							lRet	:= .T.
							Exit
						ENDIF
					ENDIF
				Next nAuxS
				IF !lRet
					Eval(bMsgErro)
				ENDIF
			ENDIF

		Endif

	ENDIF

Return lRet

Static Function xCopyFile(cToken,cIdDoc,cDriveId,cIdFldPPE,oModel,cNameRev)

	Local lRet			:= .F.
	Local cUrlgraph		:= ""
	Local cRet			:= ""
	Local cParam		:= ""
	Local aHeadStr		:= {}
	Local cHeaderGet	:= ""
	Local bMsgErro		:= {|x| oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' , "Controle de EJP", "Falha ao tentar copiar a EJP para pasta de EJP Aprovadas!"+Chr(13)+Chr(10)+"Entre em contato com a TI e informe o erro abaixo!", cRet+Chr(13)+Chr(10)+cHeaderGet) }
	Local aRetHrd		:= {}
	Local nPosLoc		:= 0
	Local cUrlLoc		:= ""
	Local lCopOK		:= .F.
	Local nQtdCheck		:= 0
	Local lContinua		:= .T.

	ProcRegua(0)
	IncProc()

	AADD(aHeadStr, "Authorization: bearer " + cToken )
	AADD(aHeadStr, "Content-Type: application/json")

	cUrlgraph := cMicroGraph+"/drives/"+cDriveId+"/items/"+cIdDoc+"/copy"
	IF Empty(cNameRev)
		cParam	  := '{"parentReference":{"driveId":"'+cDriveId+'","id":"'+cIdFldPPE+'"} }'
	ELSE
		cParam	  := '{"parentReference":{"driveId":"'+cDriveId+'","id":"'+cIdFldPPE+'"},"name": "'+EnCodeUtf8(cNameRev)+'" }'
	ENDIF
	cRet 	  := HttpPost( cUrlgraph, nil , cParam, ,  aHeadStr ,  @cHeaderGet  )

/* verifico se a copia foi concluida */
	IF !("202 ACCEPTED" $ Upper(cHeaderGet))
		Eval(bMsgErro)
	ELSE
		Sleep(5000)
		aRetHrd := StrTokArr(cHeaderGet,Chr(13)+Chr(10))
		nPosLoc := aScan(aRetHrd,{|x| 'LOCATION:' $ Upper(x) })
		IF nPosLoc == 0
			Eval(bMsgErro)
		ELSE
			cUrlLoc := AllTrim(StrTran(aRetHrd[nPosLoc],'Location:',''))
			While lContinua .AND. !lCopOK
				lCopOK := xChecCop(cUrlLoc,@lContinua,oModel)
				nQtdCheck++
				IF !lCopOK
					IF nQtdCheck <= 10
						Sleep(3000)
					ELSE
						Eval(bMsgErro)
						Exit
					ENDIF
				ELSE
					lRet := .T.
				ENDIF
			EndDo
		ENDIF
	ENDIF

Return lRet

Static Function xChecCop(cUrlLoc,lContinua,oModel)

	Local lRet		:= .F.
	Local cRet		:= ""
	Local aHeadStr	:= {}
	Local cHeaderGet:= ""
	Local nTimeOut	:= 30
	Local oJson		:= JsonObject():New()
	Local bMsgErro	:= {|x| oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' , " Controle de EJP ", "Falha ao tentar copiar a EJP para pasta de EJP Aprovadas!"+Chr(13)+Chr(10)+"Entre em contato com a TI e informe o erro abaixo!", cRet+Chr(13)+Chr(10)+cHeaderGet)		 }
	Local aNames	:= {}
	Local nPosStatus:= 0
	Local aNameErr	:= {}

	cRet := HttpGet( cUrlLoc , nil, nTimeOut , aHeadStr , @cHeaderGet  )

	aJSon 		:= oJson:FromJson(cRet)
	If !ValType(aJSon) == "U"
		Eval(bMsgErro)
	Else

		aNames 		:= oJson:GetNames()
		nPosStatus 	:= aScan(aNames,{|x| Upper(x) == "STATUS" })
		nPosErro 	:= aScan(aNames,{|x| Upper(x) == "ERROR" })

		IF nPosStatus == 0
			Eval(bMsgErro)
		Else
			If Upper(oJson[aNames[nPosStatus]]) == "COMPLETED"
				lRet := .T.
			ElseIf  Upper(oJson[aNames[nPosStatus]]) == "INPROGRESS"
				lContinua	:= .T.
				lRet 		:= .F.
			ElseIf Upper(oJson[aNames[nPosStatus]]) == "FAILED"
				aNameErr 	:= oJson[aNames[nPosErro]]:GetNames()
				nPosIdErr	:= aScan(aNameErr,{|x| Upper(x) == "CODE" })
				nPosMsgEr	:= aScan(aNameErr,{|x| Upper(x) == "MESSAGE" })
				IF Upper(oJson[aNames[nPosErro]][aNameErr[nPosIdErr]]) == "NAMEALREADYEXISTS"
					lRet := MsgYesNo("J· existe uma EJP cadastrada para esta PPE no Sharepoint, deseja utilizar a vers„o do Sharepoint?"+Chr(13)+Chr(10)+;
						"Caso clique em n„o, n„o ser· possÌvel confimar a alteraÁ„o desta PPE e vocÍ voltada para tela de manutenÁ„o.")
					IF !lRet
						lContinua	:= .F.
						oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' , " Controle de EJP ", 'salvamento cancelado', ' ')
					ENDIF
				ELSE
					lContinua	:= .F.
					Eval(bMsgErro)
				ENDIF
			Else
				lContinua	:= .F.
				Eval(bMsgErro)
			EndIf
		EndIf
	EndIf

Return lRet

Static Function xPastaPPE(cToken,cNameDir,cIdFldPai,cDrivePPE,cIdFldPPE,oModel,lEJP,cWebUrlDir)

	Local lRet		:= .F.

//---------------------------------------------------------------------------
// ID Driver | ID Pasta Documentos | ID Diretorio PPEs aprovadas            -
//---------------------------------------------------------------------------
	Local aAzuAprov	:= StrTokArr2( GetMv("GEN_AZUAPR",.F.,"b!wCetzK_Yh0-4ITAfk_lHgI8HTNy9oJdDstJi21JDthFayEFJAxQnToMa_IVc93-W|01DLNBB5F6Y2GOVW7725BZO354PWSELRRZ|01DLNBB5HW2MUAZCGYHJDKEG77Q4QA5F7Y") , "|" , .F. )
//---------------------------------------------------------------------------
// ID Driver | ID Pasta Documentos | ID Diretorio Pastas Editoriais         -
//---------------------------------------------------------------------------
	Local aAzuEdit	:= StrTokArr2( GetMv("GEN_AZUEDI",.F.,"b!wCetzK_Yh0-4ITAfk_lHgI8HTNy9oJdDstJi21JDthFayEFJAxQnToMa_IVc93-W|01DLNBB5F6Y2GOVW7725BZO354PWSELRRZ|01DLNBB5HJCOETWUVVQRDJ4BTUYMST4MQK") , "|" , .F. )

	Local aAzure	:= IIF( lEJP , aAzuAprov , aAzuEdit )
//-----------------------------------------------------
// Id do Driver de PPE's no sharepoint                -
//-----------------------------------------------------
	Local cIdDriPPE	:= aAzure[1]
//-----------------------------------------------------
// Id da Pasta documentos no sharepoint               -
//-----------------------------------------------------
	Local cIITemPPE	:= aAzure[2]
//-----------------------------------------------------
// Id da Pasta raiz de PPE's aprovadas no sharepoint  -
//-----------------------------------------------------
	Local cIDFoldPPE:= aAzure[3]

	Local cUrlgraph		:= ""
	Local aJSon			:= {}
	Local aJSonPPE		:= {}
	Local aNames		:= {}
	Local aHeadStr		:= {}
	Local cHeaderGet	:= ""
	Local cRet			:= ""
	Local oJson			:= JsonObject():New()
	Local oJSonPPE		:= nil
	Local nTimeOut		:= 0
	Local nAuxS			:= 0
	Local cParam		:= ""
	Local aNaFldPPE		:= {}
	Local bMsgErro		:= NIL

	IF ValType(oModel) == "O"
		bMsgErro := {|x| oModel:GetModel():SetErrorMessage('ZZ1_GRID', "ZZ1_TIPO" , 'ZZ1_GRID' , 'ZZ1_TIPO' , "Acesso SharePoint", "Falha ao tentar obter o token de acesso ao SharePoint!"+Chr(13)+Chr(10)+"Entre em contato com a TI e informe o erro abaixo!", cHeaderGet)    }
	ELSE
		bMsgErro := {|x| MsgInfo(cHeaderGet) }
	ENDIF

	IF !lEJP
		Do Case
		Case "CONCURSO" $ FwNoAccent(cNameDir)
			cIDFoldPPE := "01DLNBB5BJUQ7Q4WP4VRGKSKNRVEX4MJFL"
		Case "SOC APLIC" $ FwNoAccent(cNameDir)
			cIDFoldPPE := "01DLNBB5GOVPLMY3YPMJCKXX52YBVIXUWX"
		Case "HUMANAS" $ FwNoAccent(cNameDir)
			cIDFoldPPE := "01DLNBB5G2G3D6D5BI4NDKYWENUL5G5CEX"
		Case "EXATAS" $ FwNoAccent(cNameDir)
			cIDFoldPPE := "01DLNBB5A5VMBU42RUHBCJEROYJRD4RA2O"
		Case "JURIDICO" $ FwNoAccent(cNameDir)
			cIDFoldPPE := "01DLNBB5CSX2NNHDPRX5G3Z2TNBF5BYZTK"
		Case "SAUDE" $ FwNoAccent(cNameDir)
			cIDFoldPPE := "01DLNBB5BD5ZP45J3IJBG3B6GX6HVN7FR2"
		EndCase
	ENDIF


	Default lEJP		:= .F.
	Default cIdFldPai	:= cIDFoldPPE

	cUrlgraph		:= cMicroGraph+"/drives/"+cIdDriPPE+"/items/"+cIdFldPai+"/children"

	AADD(aHeadStr, "Authorization: bearer " + cToken )
	AADD(aHeadStr, "Content-Type: application/json")

	cRet := HttpGet( cUrlgraph , nil, nTimeOut , aHeadStr , @cHeaderGet  )

	IF !( "VALUE" $ Upper(cRet) )
		Eval(bMsgErro)
	ELSE
		aJSon 		:= oJson:FromJson(cRet)
		If !ValType(aJSon) == "U"
			Eval(bMsgErro)
		Else
			aNames 		:= oJson:GetNames()
			nPosValue 	:= aScan(aNames,{|x| Upper(x) == "VALUE" })

			IF nPosValue == 0
				Eval(bMsgErro)
			Else
				aSites	:= oJson[aNames[nPosValue]]
				For nAuxS := 1 To Len(aSites)
					aNaValue := aSites[nAuxS]:GetNames()
					nPosName := aScan(aNaValue,{|x| Upper(x) == "NAME" })
					nPosIdSi := aScan(aNaValue,{|x| Upper(x) == "ID" })
					nUrlWeb  := aScan(aNaValue,{|x| Upper(x) == "WEBURL" })

					IF nPosName == 0 .OR. nPosIdSi == 0
						Eval(bMsgErro)
						Exit
					ELSE
						IF Upper(aSites[nAuxS][aNaValue[nPosName]]) == Upper(cNameDir)

							cDrivePPE := cIdDriPPE
							cIdFldPPE := aSites[nAuxS][aNaValue[nPosIdSi]]
							cWebUrlDir:= aSites[nAuxS][aNaValue[nUrlWeb]]

							lRet	:= .T.
							Exit
						ENDIF
					ENDIF
				Next nAuxS
				IF !lRet
					oJSonPPE	:= JsonObject():New()
					aNaFldPPE	:= {}
					cHeaderGet	:= ""
					cParam		:= '{"name":"'+cNameDir+'","folder":{}}'
					cRet 		:= HttpPost( cUrlgraph, nil , cParam, ,  aHeadStr ,  @cHeaderGet  )

					IF !( "CREATEDBY" $ Upper(cRet) .AND. "ID" $ Upper(cRet) )
						Eval(bMsgErro)
					ELSE
						aJSonPPE	:= oJSonPPE:FromJson(cRet)
						aNaFldPPE	:= oJSonPPE:GetNames()
						If !ValType(aJSonPPE) == "U"
							Eval(bMsgErro)
						Else
							nPosValue := aScan(aNaFldPPE,{|x| Upper(x) == "ID" })
							nUrlWeb   := aScan(aNaFldPPE,{|x| Upper(x) == "WEBURL" })
							cDrivePPE := cIdDriPPE
							cIdFldPPE := oJSonPPE[aNaFldPPE[nPosValue]]
							cWebUrlDir:= oJSonPPE[aNaFldPPE[nUrlWeb]]
							lRet		:= .T.
						EndIf
					ENDIF
				ENDIF
			ENDIF

		Endif

	ENDIF

Return lRet

Static Function xConObserv()

	Local oDlgObs	:= nil
	Local oPObs		:= nil
	Local oGrpAll	:= nil
	Local oBtSave	:= nil
	Local oGetObs	:= nil
	Local oPBottom	:= nil
	Local oPBTop	:= nil
	Local cDest		:= CriaVar("ZZJ_OBS",.F.)
	Local oFont		:= TFont():New('ARIAL',,-16,.T.)

	DEFINE MSDIALOG oDlgObs TITLE ' '  From 0,0 To 400,800 pixel STYLE nOR(WS_VISIBLE,WS_POPUP) //Style DS_MODALFRAME
	oDlgObs:lMaximized := .F.

	oGrpAll:= TGroup():New(00,00,oDlgObs:NCLIENTHEIGHT/2,(oDlgObs:NCLIENTWIDTH/2),"",oDlgObs,CLR_BLUE,,.T.)

	@05,15 MSPANEL oPntAll PROMPT "" SIZE (oDlgObs:NCLIENTWIDTH/2)-30,(oDlgObs:NCLIENTHEIGHT/2)-10 COLOR CLR_WHITE,CLR_WHITE OF oDlgObs

	@00,00 MSPANEL oPBTop PROMPT "" SIZE 30,30 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
	oPBTop:Align := CONTROL_ALIGN_TOP

	oSayQuest := TSay():New(10,01,{|| '<h1>ConsideraÁıes da aprovaÁ„o</h1>' },oPBTop,,,,,,.T.,,,,,,,,,,.T.)

	@00,00 MSPANEL oPBottom PROMPT "" SIZE 40,40 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
	oPBottom:Align := CONTROL_ALIGN_BOTTOM

	oBtSave	:= TButton():New( 010, 01, "Salvar"	, oPBottom,{|| oDlgObs:End() },80,020,,oFont,,.T.)
	oBtSave:SetCss( "QPushButton{ background-color:rgb(28,157,189);}" )

	@00,00 MSPANEL oPObs PROMPT "" SIZE 10,10 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
	oPObs:Align := CONTROL_ALIGN_ALLCLIENT

	oGetObs	:= tMultiget():new(10,10,{| u | if( pCount() > 0, cDest := u, cDest )},oPObs,260,92,,,,,,.T.)
	oGetObs:Align := CONTROL_ALIGN_ALLCLIENT

	ACTIVATE MSDIALOG oDlgObs CENTERED

Return cDest


Static Function xPutDirPPE(cDepto,cNumPPE,oModel,cUrlWeb)

	Local lRet		:= .T.
	Local cToken	:= ""
	Local cDrivePPE	:= ""
	Local cIdFldPPE	:= ""

//---------------------------------------
// Busco Token no Microsoft Graph       -
//---------------------------------------
	lToken := xGetToken(@cToken,oModel)

//---------------------------------------
// Verifico diretorio Editoriais        -
//---------------------------------------
	lPastaPPE := xPastaPPE(cToken,cDepto,nil,@cDrivePPE,@cIdFldPPE,oModel,.F.,@cUrlWeb)
	IF lPastaPPE
		//---------------------------------------
		// crio diretorio da PPE                -
		//---------------------------------------
		lPastaPPE := xPastaPPE(cToken,cNumPPE,cIdFldPPE,@cDrivePPE,@cIdFldPPE,oModel,.F.,@cUrlWeb)
	ENDIF


Return lRet

Static Function xAddCat()

	Local lOK 		:= U_GENCAZZN()//U_GENZZNF3(.F.)
	Local cDesc		:= ""
	Local nQtdLin	:= 0
	Local oModelZZN
	Local oViewAtv

	IF lOK

		IF Select("TMP_ZZM") > 0
			TMP_ZZM->(DbCloseArea())
		ENDIF
		BeginSql Alias "TMP_ZZM"
		SELECT TRIM(ZZO_DESC) ZZO_DESC,ZZM_CODCAT,ZZM_CODSIT,
		TRIM(TOTVS.GET_TREE_DISC(ZZM_CODCAT,ZZM_CODSIT,trim(ZZM_CODSIT)||' : '||TRIM(ZZO_DESC)||' >>> ')) DESCRI 
		FROM %Table:ZZM% ZZM
		JOIN %Table:ZZO% ZZO
		ON ZZO_FILIAL = %xFilial:ZZO%
		AND ZZO_COD = ZZM.ZZM_CODSIT
		AND ZZO.%NotDel%
		WHERE ZZM.ZZM_CODSIT = %Exp:ZZM->ZZM_CODSIT%
		AND ZZM.ZZM_CODCAT = %Exp:ZZM->ZZM_CODCAT%
		AND ZZM.%NotDel%	
		EndSql
		TMP_ZZM->(DbGoTop())

		cDesc	:= AllTrim(TMP_ZZM->DESCRI)

		TMP_ZZM->(DbCloseArea())

		oModel		:= FWModelActive()
		oModelZZN	:= oModel:GetModel( 'ZZN_GRID' )
		//oModelZZE 	:= oModel:GetModel( 'ZZE_FORM' )
		nQtdLin		:= oModelZZN:Length()
		oViewAtv	:= FWViewActive()
		//cNumPPE		:= AllTrim(oModelZZE:GetValue("ZZE_PPE"))

		oModel:GetModel('ZZN_GRID'):SetNoInsertLine(.F.)
		oModel:GetModel('ZZN_GRID'):SetNoUpdateLine(.F.)

		If oModelZZN:AddLine() == (nQtdLin+1)
			nQtdLin++
		Else
			MsgStop("N„o foi possÌvel carregar a imagem, tente novamente!")
		EndIf

		oModelZZN:LoadValue("ZZN_ORIGEM"	,PadR("GENA103",TamSX3("ZZN_ORIGEM")[1]))
		oModelZZN:LoadValue("ZZN_CODSIT"	,ZZM->ZZM_CODSIT	)
		oModelZZN:LoadValue("ZZN_DESC"		,cDesc				)
		oModelZZN:LoadValue("ZZN_CODCAT"	,ZZM->ZZM_CODCAT	)
		IF !oModelZZN:VldData()
			oModelZZN:CommitData()
		ELSE
			aErro	:= oModel:GetErrorMessage()
			AutoGrLog( "Id do formul·rio de origem:" + ' [' + AllToChar( aErro[1] ) +']' )
			AutoGrLog( "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) +']' )
			AutoGrLog( "Id do formul·rio de erro: " + ' [' + AllToChar( aErro[3] ) +']' )
			AutoGrLog( "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) +']' )
			AutoGrLog( "Id do erro: " + ' [' + AllToChar( aErro[5] ) +']' )
			MostraErro()
		EndIf
		oModel:GetModel('ZZN_GRID'):SetNoInsertLine(.T.)
		oModel:GetModel('ZZN_GRID'):SetNoUpdateLine(.T.)
		oViewAtv:Refresh("ZZN_GRID")

	ENDIF

Return nil

Static Function xDadosDA(oDlgDados,oModel)

//Local oDlgDados	:= nil
	Local oPObs		:= nil
	Local oGrpAll	:= nil
	Local oModelZZE := oModel:GetModel( 'ZZE_FORM' )
	Local cModelON	:= "\workflow\html\TERMO_DA_ON.HTML"
	Local cModelNE	:= "\workflow\html\TERMO_DA_NE.HTML"
	Local cModelRP	:= "\workflow\html\TERMO_DA_RP.HTML"
	Local cTemo		:= oModelZZE:GetValue("ZZE_BASEDA")
	Local oBtSave	:= nil
	Local oSayQuest
	Local oPntAll
	Local oPBTop
	Local oPBottom
	Local lReadOnly := !(oModel:GetOperation() == 4 .OR. oModel:GetOperation() == 3)


	oGrpAll:= TGroup():New(00,00,oDlgDados:NCLIENTHEIGHT/2,(oDlgDados:NCLIENTWIDTH/2),"",oDlgDados,CLR_BLUE,,.T.)

	@05,15 MSPANEL oPntAll PROMPT "" SIZE (oDlgDados:NCLIENTWIDTH/2)-30,(oDlgDados:NCLIENTHEIGHT/2)-10 COLOR CLR_WHITE,CLR_WHITE OF oDlgDados

	@00,00 MSPANEL oPBTop PROMPT "" SIZE 30,30 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
	oPBTop:Align := CONTROL_ALIGN_TOP

	oSayQuest := TSay():New(10,01,{|| '<h1>BASES E TERMOS DA</h1>' },oPBTop,,,,,,.T.,,CLR_WHITE,,,,,,,,.T.)
//oSayQuest:lTransparent = .T.

//@00,00 MSPANEL oPBottom PROMPT "" SIZE 40,40 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
//oPBottom:Align := CONTROL_ALIGN_BOTTOM

//oBtSave	:= TButton():New( 010, 01, "Salvar Termos DA"	, oPBottom,{|| xSaveDA( cDefault, oModel ) },80,020,,oFont,,.T.)
//oBtSave:SetCss( "QPushButton{ background-color:rgb(28,189,127);}" )

	@00,00 MSPANEL oPObs PROMPT "" SIZE 10,10 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
	oPObs:Align := CONTROL_ALIGN_ALLCLIENT

	@00,00 MSPANEL oPObs PROMPT "" SIZE 10,10 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
	oPObs:Align := CONTROL_ALIGN_ALLCLIENT

	oGetDA := FWSimpEdit():New(05,05,0,0,"","",1,,,oPObs,lReadOnly)
	oGetDA:oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	cDefHtml	:= oGetDA:GetText()
// removo o codigo padr„o carregado pela FWSimpEdit
	cTemo		:= xGetTermo(cTemo)

	IF Empty(cTemo)
		IF oModelZZE:GetValue("ZZE_TIPINC") == "91" //91=Produto Novo
			cTemo := xRetHtml(cModelON)
		ELSEIF oModelZZE:GetValue("ZZE_TIPINC") == "92"//92=Nova EdiÁ„o
			cTemo := xRetHtml(cModelNE)
		ELSEIF oModelZZE:GetValue("ZZE_TIPINC") == "93"//93=Reimpress„o
			cTemo := xRetHtml(cModelRP)
		ENDIF
	ENDIF

	oGetDA:SetText( cTemo, oModel )

Return nil


Static Function xGetTermo(cDados)

	Local aTermo	:= StrTokArr(cDados,Chr(13)+chr(10))
	Local cTermo	:= ""
	Local aRemove	:= StrTokArr(cDefHtml,Chr(13)+chr(10))
	Local nAux		:= 0

	Aadd(aRemove, "</body></html>")
	aEval(aRemove, {|x| cTermo := StrTran(cTermo,AllTrim(x)) } )

	For nAux := 1 To Len(aTermo)
		IF aScan(aRemove, {|x| AllTrim(x) == AllTrim(aTermo[nAux]) } ) == 0
			cTermo+=aTermo[nAux]+chr(13)+chr(10)
		ENDIF
	Next nAux

Return cTermo

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥          ∫Autor  ≥Cleuto Lima         ∫ DATE ≥             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function GENA103P(lIntegra)

	DEFAULT lIntegra := .F.

	IF !lIntegra
		lIntegra := MsgYesNo("Confirma a carga dos produtos no modulo Gest„o de Produtos?")
	ENDIF

	IF lIntegra
		Processa({|| ProcProd() },"Gerando Produtos...","Aguarde.. Estamos alimentando o modulo gest„o de produtos.",.F.)
	ENDIF

Return nil

Static Function ProcProd()
	Local aArea		:= GetArea()
	Local aAreaZZE	:= ZZE->(GetArea())
	Local aAreaZZK	:= ZZK->(GetArea())
	Local oNewProd	:= nil
	Local aLog		:= {}
	Local aErr		:= {}
	Local aSucess	:= {}
	Local cDescTp	:= ""
	Local cMsg		:= ""
	Local nQtdProd	:= 0
	Local cPermReim	:= GetMv("GEN_REIMOK",.F.,"1#")

	ProcRegua(0)
	IncProc()

	ZZK->(DbSetOrder(1))
	ZZK->(DbSeek( xFilial("ZZK")+ZZE->ZZE_PPE ))

	Begin Transaction
		While ZZK->(!EOF()) .AND. ZZK->ZZK_PPE == ZZE->ZZE_PPE

			IF ZZK->ZZK_DECISA <> "1"
				ZZK->(DbSkip())
				Loop
			ENDIF

			cDescTp	:= AllTrim(Posicione("ZZP",1,xFilial("ZZP")+PadR("01",TamSX3("ZZP_NUM")[1])+ZZK->ZZK_IDTPPU,"ZZP_DESCRI"))
			IncProc( "Gerando "+cDescTp+"..." )

			IF ValType(oNewProd) == "O"
				FREEOBJ( oNewProd )
			ENDIF

			oNewProd := GenNewZZL():New()
			oNewProd:DeParaZZExZZL(cDescTp)

			IF !(ZZK->ZZK_TIPINC $ "91#92#93")
				Aadd(aErr, cDescTp+" N„o informada natureza do produto")
				ZZK->(DbSkip())
				Loop
			ENDIF

			IF ZZK->ZZK_TIPINC == "93" .AND. !(AllTrim(ZZK->ZZK_IDTPPU)+"#" $ cPermReim)
				Aadd(aErr, cDescTp+" n„o permite reimpress„o")
				ZZK->(DbSkip())
				Loop
			ENDIF

			nQtdProd++

			// IF !Empty(ZZK->ZZK_CODPRO)
			// 	xProdClass(oNewProd:CLASSIFICA)
			// 	Aadd(aLog, cDescTp+" j· integrado anteriormente")
			// 	ZZK->(DbSkip())
			// 	Loop
			// ENDIF

			// ZZL->(DbOrderNickName("PPE"))
			// IF ZZL->(DbSeek( xFilial("ZZL") + ZZE->ZZE_PPE + ZZK->ZZK_IDTPPU ))
			// 	RecLock("ZZK",.F.)
			// 	ZZK->ZZK_CODPRO	:= ZZL->ZZL_COD
			// 	MsUnLock()
			// 	xProdClass(oNewProd:CLASSIFICA)
			// 	Aadd(aLog, cDescTp+" j· integrado anteriormente")
			// 	ZZK->(DbSkip())
			// 	Loop
			// ENDIF

			IF Empty(cDescTp)
				Aadd(aErr, "N„o foi localizado no Gest„o de produtos perfil para o tipo de publicaÁ„o "+ZZK->ZZK_IDTPPU)
				ZZK->(DbSkip())
				Loop
			ENDIF

			IF ZZK->ZZK_TIPINC $ "91#92#"
				oNewProd:CriaProduto(ZZE->ZZE_PPE)
			ELSEIF ZZK->ZZK_TIPINC == "93"
				oNewProd:CriaReimpre(ZZE->ZZE_PPE)
			ELSE
				Loop
			ENDIF
			IF oNewProd:LERRO
				aLog	:= {}
				aSucess	:= {}
				Aadd(aErr, oNewProd:CERRO )
				Disarmtransaction()
				Exit
			ELSE
				RecLock("ZZK",.F.)
				ZZK->ZZK_CODPRO	:= oNewProd:ZZL_COD
				ZZK->ZZK_DTINC	:= oNewProd:ZZL_DTINC
				ZZK->ZZK_HRINCL	:= oNewProd:ZZL_HRINCL
				IF ZZK->ZZK_TIPINC == "91"
					ZZK->ZZK_CODANT	:= oNewProd:ZZL_COD
					ZZK->ZZK_CODHIS	:= oNewProd:ZZL_CODHIS
				ENDIF
				MsUnLock()

				IF ZZK->ZZK_TIPINC $ "91#92#"
					xProdClass(oNewProd:CLASSIFICA)
				ENDIF

				IF ZZK->ZZK_TIPINC == "93"
					Aadd(aSucess, "reimpress„o "+cDescTp+" gerado com sucesso!" )
				ELSE
					Aadd(aSucess, cDescTp+" gerado com sucesso!" )
				ENDIF
			ENDIF

			IF ValType(oNewProd) == "O"
				FREEOBJ( oNewProd )
			ENDIF

			ZZK->(DbSkip())
		EndDo
	End Transaction

	IF ValType(oNewProd) == "O"
		FREEOBJ( oNewProd )
	ENDIF
	RestArea(aAreaZZK)
	RestArea(aAreaZZE)
	RestArea(aArea)

	IF nQtdProd > 0
		cMsg += "--> Processado com Sucesso --------------- "+chr(13)+Chr(10)
		aEval(aSucess, {|x| cMsg += x+chr(13)+Chr(10)  } )
		cMsg += chr(13)+Chr(10)

		cMsg += "--> N„o processados - Erros --------------- "+chr(13)+Chr(10)
		aEval(aErr, {|x| cMsg += x+chr(13)+Chr(10)  } )
		cMsg += chr(13)+Chr(10)

		cMsg += "--> Processado com Alertas --------------- "+chr(13)+Chr(10)
		aEval(aLog, {|x| cMsg += x+chr(13)+Chr(10)  } )
		cMsg += chr(13)+Chr(10)
	ELSE
		cMsg += "--> N„o processados - Erros --------------- "+chr(13)+Chr(10)
		aEval(aErr, {|x| cMsg += x+chr(13)+Chr(10)  } )
		cMsg += chr(13)+Chr(10)
		cMsg += "N„o foi identificado nenhum registro para processamento, nenhum registro foi integrado ao modulo gest„o de produtos!"
	ENDIF

	MostraLog(cMsg)

Return nil


Static function MostraLog(cMsg)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Declaracao de variaveis                                                         ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	Local aPosObj    	:= {}
	Local aObjects   	:= {}
	Local aSize      	:= MsAdvSize()

	Local oDlgMsg		:= Nil
	Local oBtnPanel		:= Nil
	Local nWidth 		:= 50
	Local oFont			:= Nil
	Local oBmp			:= Nil
	Local oTFont 		:= TFont():New('Courier new',,-18,.T.)

	Local lRet			:= .F.

	Private cCadastro	:= "Log de processamento"

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Define a area dos objetos                             ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	aObjects := {}
	Aadd( aObjects, { 100, 100, .t., .t. } )

	aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	aSize :=  {0,0,800,800,1800,800,0}
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Monta a tela                                                                    ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
//Define Dialog oDlgMsg 	Title cCadastro From aSize[7],00 TO aSize[6],aSize[5] ;
	Define Dialog oDlgMsg 	Title cCadastro From 00,00 TO 400,900 ;
/*STYLE nOR(WS_VISIBLE,WS_POPUP)*/ PIXEL

	oDlgMsg:lMaximized := .F.
	oDlgMsg:SetColor(CLR_BLACK,CLR_WHITE)
	oDlgMsg:SetFont(oFont)


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Armazena as corrdenadas da tela                                                 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	nMbrWidth := oDlgMsg:nWidth/2-43
	nMbrHeight := oDlgMsg:nHeight/2

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Define os paineis da telas                                                      ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	@00,00 MSPANEL oBtnPanel PROMPT "" SIZE 60,25 of oDlgMsg
	oBtnPanel:Align := CONTROL_ALIGN_LEFT

	@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgMsg
	oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Define os botoes da tela                                                        ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	oGrpMenu	:= TGroup():New(05,05,(oBtnPanel:NCLIENTHEIGHT/2)-10,(oBtnPanel:NCLIENTWIDTH/2),"FunÁıes",oBtnPanel,CLR_RED,,.T.)

	@ 05,05 BITMAP oBmp RESNAME GetMenuBmp() OF oGrpMenu SIZE (oBtnPanel:NCLIENTWIDTH/2)-05,(oBtnPanel:NCLIENTHEIGHT/2)-15 NOBORDER PIXEL

	TBrowseButton():New(015,008, OemToAnsi("Sair"), 	oBtnPanel, {|| oDlgMsg:End() }	, nWidth, 10,,oDlgMsg:oFont, .F., .T., .F.,, .F.,,,)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥                                                                                ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	oGrpLog		:= TGroup():New(05,05,(oMainCentro:NCLIENTHEIGHT/2)-10,(oMainCentro:NCLIENTWIDTH/2)-10,"Log de processamento",oMainCentro,CLR_RED,,.T.)
	oTMultiget1 := TMultiget():New(15,10,{|u|if(Pcount()>0,cMsg:=u,cMsg)}, oMainCentro,(oMainCentro:NCLIENTWIDTH/2)-30,(oMainCentro:NCLIENTHEIGHT/2)-30,,,,,,.T.)

	Activate MsDialog oDlgMsg Centered

Return lRet

Static Function xProdClass(aClassif)

	Local nAuxClas	:= 0

	ZZN->(DbSetOrder(1))//ZZN_FILIAL+ZZN_ORIGEM+ZZN_PRODUT+ZZN_CODSIT+ZZN_CODCAT

	For nAuxClas := 1 To Len(aClassif)
		IF !ZZN->(DbSeek(xFilial("ZZN")+;
				PadR("GENCAZZL",TamSX3("ZZN_ORIGEM")[1])+;
				ZZK->ZZK_CODPRO+;
				aClassif[nAuxClas][1]+;
				aClassif[nAuxClas][2];
				))

			RecLock("ZZN",.T.)
			ZZN->ZZN_FILIAL := xFilial("ZZN")
			ZZN->ZZN_CODSIT	:= aClassif[nAuxClas][1]
			ZZN->ZZN_CODCAT	:= aClassif[nAuxClas][2]
			ZZN->ZZN_DESC	:= aClassif[nAuxClas][3]
			ZZN->ZZN_PRODUT	:= ZZK->ZZK_CODPRO
			ZZN->ZZN_ORIGEM	:= PadR("GENCAZZL",TamSX3("ZZN_ORIGEM")[1])
			MsUnLock()

		ENDIF
	Next nAuxClas

Return nil


User Function GENA103D(cTiTela)

	Local oDlgProd
	Local oFont16	:= TFont():New('ARIAL',,-16,.T.)
	Local oFont12	:= TFont():New('ARIAL',,-12,.T.)
	Local oFont20	:= TFont():New('ARIAL',,-20,.T.)
	Local oGrpAll
	Local oPntAll
	Local oPTitleTop
	Local oSayQuest
	Local oPBTop
	Local bPesq
	Local oGetProd
	Local cPesq		:= Space(100)
	Local oBtPesq
	Local oPBottom
	Local oBtSave
	Local oPProd
	Local oListBox
	Local aProdutos	:= {Array(8)}
	Local cRet		:= ""

	Default cTiTela := "Pesquisar ediÁ„o"

	aHList	:= {"ID Produto", "ID Historico", "EdiÁ„o", "DescriÁ„o", "Autor", "SituaÁ„o", "ISBN", "Departamento" }

	DEFINE MSDIALOG oDlgProd TITLE ' '  From 0,0 To 650,800 pixel STYLE nOR(WS_VISIBLE,WS_POPUP) //Style DS_MODALFRAME
	oDlgProd:lMaximized := .F.

	oGrpAll:= TGroup():New(00,00,oDlgProd:NCLIENTHEIGHT/2,(oDlgProd:NCLIENTWIDTH/2),"",oDlgProd,CLR_BLUE,,.T.)

	@05,15 MSPANEL oPntAll PROMPT "" SIZE (oDlgProd:NCLIENTWIDTH/2)-30,(oDlgProd:NCLIENTHEIGHT/2)-10 COLOR CLR_WHITE,CLR_WHITE OF oGrpAll

	@00,00 MSPANEL oPTitleTop PROMPT "" SIZE 30,30 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
	oPTitleTop:Align := CONTROL_ALIGN_TOP

	oSayQuest := TSay():New(10,01,{|| '<h1>'+cTiTela+'</h1>' },oPTitleTop,,,,,,.T.,,,,,,,,,,.T.)

	@00,00 MSPANEL oPBTop PROMPT "" SIZE 30,30 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
	oPBTop:Align := CONTROL_ALIGN_TOP

	bPesq := {|| Processa({|| xGetProd(oListBox,oGetProd,cPesq,@aProdutos) },"Consultando dados","Aguarde.. Estamos consultados a base de dados.",.F.) }
	oGetProd	:= TGet():New(05,00,{|u| if( Pcount()>0, cPesq := u,cPesq ) },oPBTop,200,015,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cPesq",,,,,,,,1,oFont20,CLR_RED )
	oGetProd:cPlaceHold	:= "Informe aqui o titulo, ISBN ou Codigo do produto"
	oGetProd:bChange	:= bPesq

	oBtPesq		:= TButton():New( 05, 205, "Pesquisar"	, oPBTop,bPesq,35,17,,oFont12,,.T.)
	oBtPesq:SetCss( "QPushButton{ background-color:rgb(28,157,189);}" )

	@00,00 MSPANEL oPBottom PROMPT "" SIZE 60,60 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
	oPBottom:Align := CONTROL_ALIGN_BOTTOM

	oBtSave	:= TButton():New( 010, 01, "Sair"	, oPBottom,{|| oDlgProd:End() },80,020,,oFont16,,.T.)
	oBtSave:SetCss( "QPushButton{ background-color:rgb(28,157,189);}" )

	@00,00 MSPANEL oPProd PROMPT "" SIZE 10,10 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
	oPProd:Align := CONTROL_ALIGN_ALLCLIENT

	oListBox := TWBrowse():New(00,00,00,00,,aHList,,oPProd,,,,,,,,,,,,, "ARRAY", .T. )
	oListBox:Align := CONTROL_ALIGN_ALLCLIENT
	oListBox:SetArray( aProdutos )
	oListBox:bLine := {|| {	aProdutos[oListBox:nAT,1],;
		aProdutos[oListBox:nAT,2],;
		aProdutos[oListBox:nAT,3],;
		aProdutos[oListBox:nAT,4],;
		aProdutos[oListBox:nAT,5],;
		aProdutos[oListBox:nAT,6],;
		aProdutos[oListBox:nAT,7],;
		aProdutos[oListBox:nAT,8]}}

	oListBox:bLDblClick := {|| IIF( Len(aProdutos) > 0 .AND. !Empty(aProdutos[oListBox:nAT,1]) , ( cRet := aProdutos[oListBox:nAT,1],oDlgProd:End() ) , "" )   }


	ACTIVATE MSDIALOG oDlgProd CENTERED

Return cRet

Static Function xGetProd(oListBox,oGetProd,cPesq,aProdutos)

	Local cQuery	:= ""
	Local cWheCC	:= FormatIn(cCCusto,"|")
	Local cWhePesq	:= Upper(AllTrim(cPesq))
	Local cAliTmp	:= GetNExtAlias()

	ProcRegua(0)
	IncProc()

	aProdutos	:= {}

	cQuery += " SELECT ZZL_COD, ZZL_CODHIS, ZZL_EDICAO, TRIM(ZZL_DESC) ZZL_DESC, TRIM(ZZL_AUTOR) ZZL_AUTOR, ZZL_SITOBR, ZZL_ISBN, ZZL_CC  "
	cQuery += " FROM "+RetSqlName("ZZL")+" ZZL"
	cQuery += " WHERE ZZL_FILIAL = '"+xFilial("ZZL")+"'"
	IF IsAlpha( cPesq )
		cQuery += " AND ( ZZL_DESC LIKE '%"+cWhePesq+"%' OR ZZL_AUTOR LIKE '%"+cWhePesq+"%' )
	ELSE
		cQuery += " AND ( ZZL_COD = '"+cWhePesq+"' OR ZZL_ISBN LIKE '%"+cWhePesq+"%' )"
	ENDIF
	cQuery += " AND ZZL_CC IN "+cWheCC+""
	cQuery += " AND ZZL.D_E_L_E_T_ <> '*'"

// cQuery += " AND NOT EXISTS(
// cQuery += "   SELECT 1 FROM "+RetSqlName("ZZL")+" OLD
// cQuery += "   WHERE OLD.ZZL_FILIAL = ZZL.ZZL_FILIAL
// cQuery += "   AND OLD.ZZL_CODHIS = ZZL.ZZL_CODHIS
// cQuery += "   AND OLD.ZZL_IDTPPU = ZZL.ZZL_IDTPPU
// cQuery += "   AND TO_NUMBER(OLD.ZZL_COD) > TO_NUMBER(ZZL.ZZL_COD)
// cQuery += "   AND OLD.D_E_L_E_T_ <> '*'
// cQuery += " )

	cQuery += " ORDER BY ZZL_CODHIS DESC, ZZL_COD DESC, ZZL_EDICAO DESC"

	DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliTmp, .F., .T.)

	While(cAliTmp)->(!EOF())

		Aadd(aProdutos, { (cAliTmp)->ZZL_COD, (cAliTmp)->ZZL_CODHIS, (cAliTmp)->ZZL_EDICAO, (cAliTmp)->ZZL_DESC, (cAliTmp)->ZZL_AUTOR, (cAliTmp)->ZZL_SITOBR, (cAliTmp)->ZZL_ISBN, (cAliTmp)->ZZL_CC } )
		(cAliTmp)->(DbSkip())
	EndDo

	oListBox:SetArray( aProdutos )
	oListBox:bLine := {|| {	aProdutos[oListBox:nAT,1],;
		aProdutos[oListBox:nAT,2],;
		aProdutos[oListBox:nAT,3],;
		aProdutos[oListBox:nAT,4],;
		aProdutos[oListBox:nAT,5],;
		aProdutos[oListBox:nAT,6],;
		aProdutos[oListBox:nAT,7],;
		aProdutos[oListBox:nAT,8]}}

	oListBox:Refresh()

Return nil

Static Function xCargaEdiAnt(cCodZZL,oModel)
	Local cNoField	:= "ZZE_PPE/ZZE_SITOBR/ZZE_TIPINC"
	Local aSX3		:= FWSX3Util():GetAllFields( "ZZE", .F. )
	Local nAux		:= 0
	Local cOrigem	:= PadR("GENCAZZL",TamSX3("ZZN_ORIGEM")[1])
	Local oModelZZN := oModel:GetModel( 'ZZN_GRID' )
	Local oModelZZK := oModel:GetModel( 'ZZK_GRID' )
	Local oModelZZE := oModel:GetModel( 'ZZE_FORM' )
	Local nZZNQtdLin:= oModelZZN:Length()
	Local nZZKQtdLin:= oModelZZK:Length()
	Local cPermReim	:= GetMv("GEN_REIMOK",.F.,"1#")

	ZZL->(DbSetOrder(1))
	IF !ZZL->(DbSeek( xFilial("ZZL") + cCodZZL ))
		Return .F.
	ENDIF

	IF !Empty(ZZL->ZZL_PPE)
		IF ZZE->(DbSeek( xFilial("ZZE") + ZZL->ZZL_PPE ))
			xCargaZZE(oModel,aSX3,cNoField)
		ENDIF
	ENDIF

	xSetField(oModel,'ZZE_CC',AllTrim(ZZL->ZZL_CC)    )
	xSetField(oModel,'ZZE_AUTOR',AllTrim(ZZL->ZZL_AUTOR) )
	xSetField(oModel,'ZZE_OFERT',AllTrim(ZZL->ZZL_OFERT) )
//xSetField(oModel,'ZZE_DTPPRE',ZZL->ZZL_DTPPRE)
	cEdicao := AllTrim(ZZL->ZZL_EDICAO)
	IF At("|",cEdicao) > 0 .AND. cTpObr == "92"
		cEdicao := Soma1(SubStr(cEdicao,1,At("|",cEdicao)-1))+"|"+Left(DtoS(DDAtaBase),4)
	ENDIF
	xSetField(oModel,'ZZE_EDICAO',cEdicao)
	xSetField(oModel,'ZZE_GRAU',AllTrim(ZZL->ZZL_GRAU)  )
	xSetField(oModel,'ZZE_CLASSE',AllTrim(ZZL->ZZL_CLASSE))
	xSetField(oModel,'ZZE_EMPRES',AllTrim(ZZL->ZZL_EMPRES))
	xSetField(oModel,'ZZE_AREGER',AllTrim(ZZL->ZZL_AREGER))
	xSetField(oModel,'ZZE_SELO',AllTrim(ZZL->ZZL_SELO)  )
	xSetField(oModel,'ZZE_QTDPAG',AllTrim(ZZL->ZZL_QTDPAG))
	xSetField(oModel,'ZZE_CORMIO',AllTrim(ZZL->ZZL_CORMIO))
	xSetField(oModel,'ZZE_FORCAP',AllTrim(ZZL->ZZL_FORCAP))
	xSetField(oModel,'ZZE_TIRPRE',AllTrim(ZZL->ZZL_TIRPRE))
	xSetField(oModel,'ZZE_TPACAB',AllTrim(ZZL->ZZL_TPACAB))
	xSetField(oModel,'ZZE_DESC',AllTrim(ZZL->ZZL_DESC))
	xSetField(oModel,'ZZL_CEME',AllTrim(ZZE->ZZE_CEME))

	SX7->(DbSetOrder(1))
	For nAux := 1 To Len(aSX3)
		IF aSX3[nAux] $ cNoField
			Loop
		ENDIF
		IF oModel:HasField('ZZE_FORM', aSX3[nAux])
			IF !Empty(oModel:GetValue("ZZE_FORM", aSX3[nAux]))
				If ExistTrigger(aSX3[nAux])
					IF SX7->( DbSeek( aSX3[nAux] ) )
						While AllTrim(SX7->X7_CAMPO) == AllTrim(aSX3[nAux])
							RunTrigger(1,nil,nil,,aSX3[nAux])
							Eval({|x| FwFldPut( SX7->X7_CDOMIN, x)}, &(SX7->X7_REGRA) )
							SX7->(DbSkip())
						EndDo
					ENDIF
				Endif
			ENDIF
		ENDIF
	Next nAux

	IF Select("TMP_ZZN") > 0
		TMP_ZZN->(DbCloseArea())
	ENDIF

	BeginSql Alias "TMP_ZZN"
	SELECT ZZN_CODSIT, ZZN_CODCAT, ZZN_DESC, ZZN_PRODUT, ZZN_ORIGEM 
	FROM %Table:ZZN% ZZN
	WHERE ZZN_FILIAL = %xFilial:ZZN%
	AND ZZN_PRODUT = %Exp:cCodZZL%
	AND ZZN_ORIGEM = %Exp:cOrigem%
	AND ZZN.%NotDel%
	ORDER BY ZZN_CODSIT, ZZN_CODCAT
	EndSql

	oModel:GetModel('ZZN_GRID'):SetNoInsertLine(.F.)
	oModel:GetModel('ZZN_GRID'):SetNoUpdateLine(.F.)

	While TMP_ZZN->(!EOF())
		oModelZZN:LoadValue("ZZN_ORIGEM"	,PadR("GENA103",TamSX3("ZZN_ORIGEM")[1]))
		oModelZZN:LoadValue("ZZN_CODSIT"	,TMP_ZZN->ZZN_CODSIT	)
		oModelZZN:LoadValue("ZZN_DESC"		,TMP_ZZN->ZZN_DESC		)
		oModelZZN:LoadValue("ZZN_CODCAT"	,TMP_ZZN->ZZN_CODCAT	)
		TMP_ZZN->(DbSkip())
		IF TMP_ZZN->(!EOF())
			If oModelZZN:AddLine() == (nZZNQtdLin+1)
				nZZNQtdLin++
			Else
				MsgStop("N„o foi possÌvel carregar a classificaÁ„o!")
				Exit
			EndIf
		ENDIF
	EndDo

	oModel:GetModel('ZZN_GRID'):SetNoInsertLine(.T.)
	oModel:GetModel('ZZN_GRID'):SetNoUpdateLine(.T.)

	TMP_ZZN->(DbCloseArea())

	IF Select("TMP_OLD") > 0
		TMP_OLD->(DbCloseArea())
	ENDIF

	BeginSql Alias "TMP_OLD"
	SELECT ZZL_COD,ZZL_CODHIS,ZZL_IDTPPU,ZZL_IDMAE,ZZL_TIPINC,ZZL_ISBN FROM %Table:ZZL% ZZL
	WHERE ZZL_FILIAL = %xFilial:ZZL%
	AND ZZL_IDMAE = %Exp:cCodZZL%
	AND ZZL.%NotDel%
	EndSql

	While TMP_OLD->(!EOF())
		IF cTpObr == "93"
			IF !AllTrim(TMP_OLD->ZZL_IDTPPU) $ cPermReim
				TMP_OLD->(DbSkip())
				Loop
			ENDIF
		ENDIF

		For nAux := 1 To nZZKQtdLin
			oModelZZK:GoLine(nAux)
			IF AllTrim(TMP_OLD->ZZL_IDTPPU) == AllTrim(oModelZZK:GetValue("ZZK_IDTPPU",nAux))
				//oModelZZK:LoadValue("ZZK_TIPINC"	, IIF( TMP_OLD->ZZL_TIPINC == "1" , "91" , "92" )	)
				oModelZZK:LoadValue("ZZK_TIPINC"	, oModelZZE:GetValue("ZZE_TIPINC")	)
				oModelZZK:LoadValue("ZZK_EMAE"		, IIF( AllTrim(TMP_OLD->ZZL_IDMAE) == AllTrim(TMP_OLD->ZZL_COD) , "1", "2" ))
				oModelZZK:LoadValue("ZZK_CODANT"	, TMP_OLD->ZZL_COD	)
				oModelZZK:LoadValue("ZZK_CODHIS"	, TMP_OLD->ZZL_CODHIS	)

				IF cTpObr == "93"
					oModelZZK:LoadValue("ZZK_ISBN"		, TMP_OLD->ZZL_ISBN	)
				ENDIF
			ENDIF
		Next nAux
		TMP_OLD->(DbSkip())
	EndDo

	TMP_OLD->(DbCloseArea())

Return nil

Static Function xSetField(oModel,cField,cValue)

	IF oModel:HasField('ZZE_FORM', cField)
		IF Empty(oModel:GetValue("ZZE_FORM", cField))
			oModel:LoadValue( 'ZZE_FORM', cField, cValue )
		ENDIF
	ENDIF

Return nil

Static Function xCargaZZE(oModel,aSX3,cNoField)
	Local nAux		:= 0
	Local cEdicao	:= ""

	For nAux := 1 To Len(aSX3)
		IF aSX3[nAux] $ cNoField
			Loop
		ENDIF
		IF oModel:HasField('ZZE_FORM', aSX3[nAux])
			IF Empty(oModel:GetValue("ZZE_FORM", aSX3[nAux]))
				IF AllTrim(aSX3[nAux]) == "ZZL_EDICAO"
					cEdicao := ZZE->&(aSX3[nAux])
					IF At("|",cEdicao) > 0
						cEdicao := Soma1(SubStr(cEdicao,1,At("|",cEdicao)-1))+"|"+Left(DtoS(DDAtaBase),4)
					ENDIF
				ELSE
					oModel:LoadValue( 'ZZE_FORM', aSX3[nAux], ZZE->&(aSX3[nAux]) )
				ENDIF
			ENDIF
		ENDIF
	Next nAux

Return nil

User Function GENA103I()

	Local oDlgPrint
	Local oWebPrint
	Local cCorpo := u_GENA103V(.F.)
	Local obt
	Local oPDTop

	MemoWrite ( getTempPath()+ZZE->ZZE_PPE+".html" , cCorpo )

	Define MsDialog oDlgPrint 	Title "Impress„o da PPE" ;
		From 00,00 TO 150,800 PIXEL ;
		STYLE nOR(WS_VISIBLE,WS_POPUP)

	oDlgPrint:lMaximized := .T.

	@00,00 MSPANEL oPDTop PROMPT "" SIZE 40,40 COLOR CLR_WHITE,CLR_WHITE OF oDlgPrint
	oPDTop:Align := CONTROL_ALIGN_LEFT

	obtPrin := TButton():New(005,215,"Imprimir",oPDTop,{|| oWebPrint:PrintPDF() },50,12,,,,.T.)
	obtPrin:Align := CONTROL_ALIGN_TOP

	@00,00 MSPANEL oPDSpc PROMPT "" SIZE 10,10 COLOR CLR_WHITE,CLR_WHITE OF oPDTop
	oPDSpc:Align := CONTROL_ALIGN_TOP

	obtClose := TButton():New(005,215,"Fechar",oPDTop,{|| oDlgPrint:End() },50,12,,,,.T.)
	obtClose:Align := CONTROL_ALIGN_TOP

	oWebPrint := TWebEngine():New(oDlgPrint,0,0,100,100,/*cUrl*/,)
	oWebPrint:Align := CONTROL_ALIGN_ALLCLIENT

	oWebPrint:navigate(getTempPath()+ZZE->ZZE_PPE+".html")


	ACTIVATE MSDIALOG oDlgPrint CENTERED// ON INIT (oWebPrint:PrintPDF(), oDlgPrint:End())

Return

User Function GENA103U(cField)

	Local lRet		:= .T.
	Local cAux		:= ""
// Local oModel	:= FWModelActive()

	IF AllTrim(cField) == "ZZE_EDICAO"
		cAux := AllTrim(FwFldGet("ZZE_EDICAO"))
		IF !("|" $ cAux) .OR. ;
				Len(Separa(cAux,"|")) <> 2
			lRet := .F.

			xMagHelpFis("Campo EdiÁ„o",;
				"O formato da ediÁ„o È inv·lido.",;
				"Por favor,"+Chr(13)+Chr(10)+;
				"preencher seguindo o par„o 00|YY, onde:"+Chr(13)+Chr(10)+;
				"00  numero da ediÁ„o"+Chr(13)+Chr(10)+;
				"|  separador (Pipe) "+Chr(13)+Chr(10)+;
				"YY  ano da ediÁ„o"+Chr(13)+Chr(10);
				)

			// oModel:GetModel():SetErrorMessage('ZZE_FORM', "ZZE_EDICAO" , 'ZZE_FORM' , 'ZZE_EDICAO' ,;
				// "Campo EdiÁ„o",;
				// "O formato da ediÁ„o È inv·lido.",;
				// "Por favor,"+Chr(13)+Chr(10)+;
				// "preenhcer seguindo o par„o 00|YYYY, onde:"+Chr(13)+Chr(10)+;
				// "00  numero da ediÁ„o"+Chr(13)+Chr(10)+;
				// "|  separador (Pipe) "+Chr(13)+Chr(10)+;
				// "YYYY  ano da ediÁ„o"+Chr(13)+Chr(10);
				// )
		ELSE
		ENDIF
	ELSE
		lRet	:= .T.
	ENDIF

Return lRet

Static Function ExistReimp(cCodProd,cIdProducao)

	Local lRet		:= .F.
	Local cAliTmp	:= GetNextAlias()

	BeginSql Alias cAliTmp
	SELECT COUNT(*) QTD FROM %Table:ZZW% ZZW
	WHERE ZZW_FILIAL = %xFilial:ZZW%
	AND ZZW_CODPRO = %Exp:cCodProd%
	AND ZZW_IDPROD <> %Exp:cIdProducao%
	AND ZZW_SITUAC = '1'
	AND ZZW.%NotDel%
	EndSql

	lRet := (cAliTmp)->QTD > 0

	(cAliTmp)->(DbCloseArea())

Return lRet

/*/
	‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
	±±∫Programa  ≥GENA103S  ∫Autor  ≥Cleuto              ∫ Data ≥  10/10/2020 ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Desc.     ≥Gera arquivo da PPE Digital no Sharepoint                   ∫±±
	±±∫          ≥                                                            ∫±±
	±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
	±±∫Uso       ≥ GEN - Projeto Gest„o de Obras                              ∫±±
	±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function GENA103S()

	Local lRet		:= .T.
	Local cToken	:= ""
	Local cDrivePPE	:= ""
	Local cIdFldPPE	:= ""
	Local oModel	:= FWModelActive()
	Local oModelZZE := nil
	Local cDepto	:= ""
	Local cNumPPE	:= ""
	Local lFileOk	:= .F.
	Local cConteudo	:= ""
	Local cNameFile	:= ""

	IF ValType(oModel) == "O"
		oModelZZE 	:= oModel:GetModel( 'ZZE_FORM' )
		cDepto		:= FwNoAccent(AllTrim(Posicione("CTT",1,xFilial("CTT")+NoAcento(AllTrim(oModelZZE:GetValue("ZZE_CC"))),"CTT_DESC01"))+" "+NoAcento(AllTrim(oModelZZE:GetValue("ZZE_CC"))))
		cNumPPE		:= "PPE-"+NoAcento(AllTrim(oModelZZE:GetValue("ZZE_PPE")))
		cNameFile	:= "Capa da PPE-"+NoAcento(AllTrim(oModelZZE:GetValue("ZZE_PPE")))+" "+NoAcento(AllTrim(oModelZZE:GetValue("ZZE_DESC")))+".HTML"
	ELSE
		cDepto		:= FwNoAccent(AllTrim(Posicione("CTT",1,xFilial("CTT")+NoAcento(AllTrim(ZZE->ZZE_CC)),"CTT_DESC01"))+" "+NoAcento(AllTrim(ZZE->ZZE_CC)))
		cNumPPE		:= "PPE-"+NoAcento(AllTrim(ZZE->ZZE_PPE))
		cNameFile	:= "Capa da "+cNumPPE+" "+NoAcento(AllTrim(ZZE->ZZE_DESC))+".HTML"
	ENDIF

	cNameFile	:= StrTran(cNameFile,"/","-")
	cNameFile	:= StrTran(cNameFile,"\","-")
	cNameFile	:= StrTran(cNameFile,"|","-")
	cNameFile	:= StrTran(cNameFile,":","-")

	//---------------------------------------
	// Busco Token no Microsoft Graph       -
	//---------------------------------------
	lToken := xGetToken(@cToken,oModel)

	lPastaPPE := xPastaPPE(cToken,cDepto,nil,@cDrivePPE,@cIdFldPPE,oModel,.F.)
	IF lPastaPPE
		lPastaPPE := xPastaPPE(cToken,cNumPPE,cIdFldPPE,@cDrivePPE,@cIdFldPPE,oModel,.F.)
		IF lPastaPPE
			cConteudo 	:= u_GENA103V(.F.)
			MemoWrite ( getTempPath()+cNameFile , cConteudo )

			lFileOk	:= .T.//xGetContFile(getTempPath()+ZZE->ZZE_PPE+".html",@cConteudo,@cNameFile,oModel)

			IF lFileOk
				//------------------------------------------------
				// upload de arquivo local para sharepoint       -
				//------------------------------------------------
				Processa({|| ;
					lRet := xUpFileTo(cToken,cConteudo,cNameFile,"",cDrivePPE,cIdFldPPE,oModel);
					},"Gerando PPE Digital","Aguarde.. estamos envindo uma copia da PPE Digital para o sharepoint!",.F.)
			ENDIF

		ENDIF
	ENDIF


Return lRet

/*
verifica quais campos s„o obrigatorios de acordo com o tipo de publicaÁ„o
*/
Static function xVldField(cIdTpPub, oModel, oModelZZE)

	Local cTpSit	:= "109"
	Local cGrpUsr	:= GetMv("GEN_PPE002",.F.,"000044") // GRUPO PCP GEST√O DE PRODUTOS
	Local aFldEpt	:= {}

	If Select("TMP_FIELD") > 0
		TMP_FIELD->(DbCloseArea())
	EndIf

	BeginSql Alias "TMP_FIELD"
	SELECT SX3ZZE.X3_CAMPO X3_CAMPO, ZZS_ACESSO, ZZS_OBRIGA,ZZR_IMAGEM,ZZR_DISTRI,SX3ZZE.X3_TITULO X3_TITULO FROM %Table:ZZP% ZZP
	JOIN %Table:ZZQ% ZZQ
	ON ZZQ.ZZQ_FILIAL = ZZP.ZZP_FILIAL
	AND ZZQ.ZZQ_NUM = ZZP.ZZP_NUM
	AND ZZQ.ZZQ_TPPUB = ZZP.ZZP_IDTPPU
	AND ZZQ.%NotDel%
	JOIN %Table:ZZR% ZZR
	ON ZZR.ZZR_FILIAL = ZZQ.ZZQ_FILIAL
	AND ZZR.ZZR_NUM = ZZQ.ZZQ_NUM
	AND ZZR.ZZR_TPPUB = ZZQ.ZZQ_TPPUB
	AND ZZR.ZZR_SITOBR = ZZQ.ZZQ_SITOBR
	AND ZZR.%NotDel%
	JOIN %Table:ZZS% ZZS
	ON ZZS.ZZS_FILIAL = ZZR.ZZR_FILIAL
	AND ZZS.ZZS_NUM = ZZR.ZZR_NUM
	AND ZZS.ZZS_TPPUB = ZZR.ZZR_TPPUB
	AND ZZS.ZZS_SITOBR = ZZR.ZZR_SITOBR
	AND ZZS.ZZS_GRPUSR = ZZR.ZZR_GRPUSR
	AND ZZS.%NotDel%
	JOIN %Table:SX3% SX3
	ON X3_ARQUIVO = 'ZZL'
	AND X3_CAMPO = ZZS_CAMPO
	AND X3_CONTEXT <> 'V'
	AND SX3.%NotDel%
	JOIN %Table:SX3% SX3ZZE
	ON SX3ZZE.X3_ARQUIVO = 'ZZE'
	AND SX3ZZE.X3_CAMPO = REPLACE(ZZS_CAMPO,'ZZL_','ZZE_')
	AND SX3ZZE.X3_CONTEXT <> 'V'
	AND SX3ZZE.%NotDel%	
	WHERE ZZP_FILIAL = %xFilial:ZZP%
	AND ZZP_NUM = '01'
	AND ZZR_SITOBR = %Exp:cTpSit%
	AND ZZP_IDTPPU = %Exp:cIdTpPub%
	AND ZZR_GRPUSR = %Exp:cGrpUsr%
	AND ZZS_OBRIGA = '1'
	AND ZZP.%NotDel%
	EndSql

	While TMP_FIELD->(!EOF())

		IF oModel:HasField('ZZE_FORM', TMP_FIELD->X3_CAMPO)
			IF Empty(oModelZZE:GetValue(TMP_FIELD->X3_CAMPO))
				Aadd(aFldEpt,{ TMP_FIELD->X3_CAMPO, TMP_FIELD->X3_TITULO })
			ENDIF
		ENDIF

		TMP_FIELD->(DbSkip())
	EndDo

Return aFldEpt
