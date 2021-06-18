#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "Totvs.ch"
#INCLUDE "Topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA097   ºAutor  ³Cleuto Lima         º Data ³  23/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³controle de pagamentos de autonomos                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA097()

Private oBrowse                                                               
Private aRotina     := {}
Private cTipo       := ""
Private cTitTela    := "Serviços Autonomos"

If !ZZF->( DbSeek( xFilial("ZZF")+RetCodUsr() ) )
    MsgStop("Usuário sem acesso a esta ferramenta!"+chr(13)+chr(10)+"Solicite a TI que inclua seu usuário "+RetCodUsr()+" na tabela ZZF!")
    Return nil
EndIf

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))

// Definição das Operações disponíveis.
aRotina := MenuDef(.F.)           

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('SZ1')

oBrowse:AddLegend( "Z1_STATUS=='1'", "GREEN"    , "Digitado" )
oBrowse:AddLegend( "Z1_STATUS=='2'", "RED"      , "Integrado Fin/Gpe" )
oBrowse:AddLegend( "Z1_STATUS=='3'", "YELLOW"   , "Suspenso" )
oBrowse:AddLegend( "Z1_STATUS=='4'", "BLACK"    , "Cancelado" )

oBrowse:DisableDetails()
oBrowse:SetDescription(cTitTela)
If ZZF->ZZF_INSSVI <> "3"
    If ZZF->ZZF_INSSVI == "1"
        oBrowse:SetFilterDefault("Z1_INSS == '1'")
    Else    
        oBrowse:SetFilterDefault("Z1_INSS <> '1'")
    EndIf
EndIf
oBrowse:Activate()

Return NIL

Static Function MenuDef(lCheck)
Local aRotina   := {}
Local aRela     := {}

Default lCheck  := .T.

IF lCheck
    CHKFILE("ZZF")
ENDIF 

//aRotina := FWMVCMenu( "GENA092" )
ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.GENA097' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.GENA097' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.GENA097' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.GENA097' OPERATION 5 ACCESS 0
If ZZF->ZZF_INSS == "1" .OR. ZZF->ZZF_INSS == "3"
    ADD OPTION aRotina TITLE 'Aprovar RPA'  ACTION 'U_GENA097B'      OPERATION 4 ACCESS 0
ENDIF
If ZZF->ZZF_INSS == "2" .OR. ZZF->ZZF_INSS == "3"
    ADD OPTION aRotina TITLE 'Aprovar Fin'      ACTION 'U_GENA097F(.f.)'        OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Apr.Fin.Todos'    ACTION 'U_GENA097T'             OPERATION 4 ACCESS 0    
EndIf    

ADD OPTION aRela TITLE 'Diário - Plan.Sintético - RPA008'    ACTION 'U_GENR070()'   OPERATION 4 ACCESS 0 
ADD OPTION aRela TITLE 'Diário - Plan.Analítico - RPA009'    ACTION 'U_GENR071()'   OPERATION 4 ACCESS 0 
ADD OPTION aRotina TITLE 'Relatorios'      ACTION aRela OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()
// Cria Estruturas para serem usadas no Modelo de Dados
Local oStruSZ1  := FWFormStruct(1,'SZ1')
Local oStruGRID := FWFormStruct(1,'SZ1',{|cCampo| .NOT. AllTrim(cCampo) $ "Z1_IDSEQ"})
Local bSavCom   := {|oModel| U_GENA097G(oModel)}
Local bVldCom   := {|oModel| U_GENA097V(oModel)}
Local bBloco	:= {|oModel| loadField(oModel)}
// Cria Modelo de Dados
Local oModel 

oModel := MPFormModel():New('MDFGENA097', , bVldCom, bSavCom)

// Adiciona um Componente de Formulário ao modelo.
oModel:AddFields('SZ1_FORM',/*cOwner*/,oStruSZ1,/*blinePre*/,/*blinePos*/) 
oModel:AddGrid('SZ1_GRID',"SZ1_FORM",oStruGRID, { |oModelGrid, nLine,cAction, cField| GENA097P(oModelGrid, nLine, cAction, cField) },/*blinePos*/)

//If ZZF->ZZF_INSSVI <> "3"
oModel:SetRelation( 'SZ1_GRID', { { 'Z1_FILIAL', 'xFilial("SZ1")' }, { 'Z1_FORNECE', 'Z1_FORNECE' }, { 'Z1_LOJA', 'Z1_LOJA' }, { 'Z1_DATAREF', 'Z1_DATAREF' }, { 'Z1_DATA', 'Z1_DATA' } , { 'Z1_NOME', 'Z1_NOME' }, { 'Z1_INSS', 'Z1_INSS' }  }, SZ1->( IndexKey( 1 ) ) )
//Else
//    oModel:SetRelation( 'SZ1_GRID', { { 'Z1_FILIAL', 'xFilial("SZ1")' }, { 'Z1_FORNECE', 'Z1_FORNECE' }, { 'Z1_LOJA', 'Z1_LOJA' }, { 'Z1_DATAREF', 'Z1_DATAREF' }, { 'Z1_DATA', 'Z1_DATA' } , { 'Z1_NOME', 'Z1_NOME' }  }, SZ1->( IndexKey( 1 ) ) )    
//EndIf
//oModel:GetModel( 'SZ1_GRID' ):SetNoUpdateLine( .T. )

//oStruGRID:SetProperty('Z1_PD', MODEL_FIELD_WHEN, {|| EMPTY(FwFldGet('Z1_PD')) })

// Descrição do Modelo
oModel:SetDescription(cTitTela) 
// Descrição do Modelo
oModel:GetModel('SZ1_FORM'):SetDescription(cTitTela)
oModel:GetModel('SZ1_GRID'):SetDescription("Serviços")

oModel:SetActivate(bBloco)
oModel:SetVldActivate( { |oModel| GENA097A( oModel ) } )

Return oModel      

Static Function GENA097A(oModel)

Local lRet  := .T.
Local nOpc  := oModel:GetOperation()

If nOpc == MODEL_OPERATION_DELETE 
    IF SZ1->Z1_STATUS == "2"
        MsgStop("Status do registro não permite alteração!")
        lRet := .F.
    EndIf
ElseIf nOpc == MODEL_OPERATION_UPDATE
    IF SZ1->Z1_STATUS == "2"
        MsgStop("Status do registro não permite alteração!")
        lRet := .F.
    EndIf
EndIf

Return lRet

Static Function ViewDef()

// Cria Estruturas para serem usadas na View
Local oStruSZ1  := FWFormStruct(2,'SZ1',{|cCampo| AllTrim(cCampo) $ "Z1_STATUS/Z1_FORNECE/Z1_LOJA/Z1_NOME/Z1_DATA/Z1_DATAREF/Z1_DEPTO/Z1_DESCDPT/Z1_CC/Z1_DESCC/Z1_IDSEQ"})
Local oGridSZ1  := FWFormStruct(2,'SZ1',{|cCampo| AllTrim(cCampo) $ "Z1_PD/Z1_HORAS/Z1_VALOR/Z1_CLASSE/Z1_ITEM/Z1_SERVICO/Z1_DESCRI/Z1_SEQ/Z1_OBS/Z1_JUSTIFI/Z1_TITULO/Z1_INSS/Z1_TOTAL"})
// Carrega o modelo de dados de um fonte MVC. No caso, carregamos deste fonte mesmo.
Local oModel := FWLoadModel('GENA097')
// Cria o modelo da View
Local oView := FWFormView():New()

// Definimos qual modelo será carregado nessa View
oView:SetModel(oModel)

// Adiciona os componentes visuais. Cada componente Está relacionado à um modelo de Estrutura de dados, definidos em ModelDef()
oView:AddField('VIEW_SZ1', oStruSZ1, 'SZ1_FORM')
oView:AddGrid('VIEW_GRID', oGridSZ1, 'SZ1_GRID')

oStruSZ1:SetProperty( "Z1_IDSEQ", MVC_VIEW_INSERTLINE , .T. )
oStruSZ1:SetProperty( "Z1_NOME", MVC_VIEW_INSERTLINE , .T. )
oStruSZ1:SetProperty( "Z1_DATAREF", MVC_VIEW_INSERTLINE , .T. )
oStruSZ1:SetProperty( "Z1_DESCDPT", MVC_VIEW_INSERTLINE , .T. )
oStruSZ1:SetProperty( "Z1_DESCC", MVC_VIEW_INSERTLINE , .T. )
oStruSZ1:SetProperty( "Z1_STATUS", MVC_VIEW_INSERTLINE , .T. )

// Agora vamos criar 'box' para suportar os componentes. Box é uma descrição genérica para Window, Panel, etc
//oView:CreateHorizontalBox( 'CAB', 100 ) // ocupar 100% da tela
oView:CreateHorizontalBox( 'CAB', 040 ) // ocupar 100% da tela
oView:CreateHorizontalBox( 'ITE', 060 ) // ocupar 100% da tela

// Relacionamos o Box criado ao objeto View
oView:SetOwnerView('VIEW_SZ1' ,'CAB')
oView:SetOwnerView('VIEW_GRID' ,'ITE')

//Para mostrar os titulos dos grids                                          
oView:EnableTitleView('VIEW_SZ1')
oView:EnableTitleView('VIEW_GRID')

Return oView

Static Function GENA097P(oModelGrid, nLinha, cAcao, cCampo )

Local lRet          := .T.
Local oModel        := oModelGrid:GetModel()
Local nOperation    := oModel:GetOperation()
// Valida se pode ou não apagar uma linha do Grid
If cAcao == 'CANSETVALUE' .AND. nOperation == MODEL_OPERATION_UPDATE .AND. oModelGrid:GetDataId(nLinha) <> 0
    lRet := .F.
    MsgStop("Ação não permitida!")
EndIf
//SETVALUE // nOperation = 3
Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA097B  ºAutor  ³Cleuto Lima         º Data ³  23/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function GENA097B()

    Processa({|| IntToGPE() },"Processando...","Aguarde.. integrando lançamento com modulo GPE!",.F.)

Return nil

Static function IntToGPE()

//Declaracao das variaveis de controle
Local aCabAuto  := {}
Local aItemAuto := {}
Local aLinha    := {}
Local cEmpBkp   := cEmpAnt
Local cFilBkp   := cFilant
Local cEmpAux   := cEmpant
Local cCC       := ""
Local cItem     := ""
Local cClass    := ""
Local aPerAtual	:= {}
Local cMatGen   := ""
Local nOper     := 3
Local aAreaSZ1  := SZ1->(GetArea())
Local aAreaRGB  := RGB->(GetArea())
Local cChaveSZ1 := SZ1->Z1_FILIAL+SZ1->Z1_FORNECE+SZ1->Z1_LOJA+DtoS(SZ1->Z1_DATA)
Local aLanc     := {}
Local nAuxIt    := 1
Local nAuxRc    := 1

Private lMsErroAuto := .F.

ProcRegua(0)
IncProc()

IF SZ1->Z1_STATUS <> "1"
    MsgStop("Status do registro não permite aprovação!")
    Return nil
EndIf

IF SZ1->Z1_INSS <> "1"
    MsgStop("Lançamento não pertence ao GPE!")
    Return nil
EndIf

SA2->(DbSetOrder(1))
IF !SA2->(DbSeek( xFilial("SA2")+SZ1->Z1_FORNECE+SZ1->Z1_LOJA ))
    MsgStop("Fornecedor não lozalizado!")
    Return nil
ENDIF

IF SA2->A2_MSBLQL == "1"
    MsgStop("Fornecedor está bloqueado, entre em contato com financeiro para soliitar o desbloqueio!")
    Return nil
ENDIF

IF !MsgYesNo("Confirma aprovação do lançamento?")
    Return nil
EndIf

//SRA->(DbSetOrder(1))
SRA->(DbOrderNickName("FORNECEDOR"))
If !SRA->(DbSeek( SZ1->Z1_FILIAL+SZ1->Z1_FORNECE ))
    IF !MsgYesNo("Não localizado autonomo cadastrado para o fornecedor informado!"+Chr(13)+Chr(10)+"Deseja gerar o autonomo agora?")
        return nil
    ELSE
        U_GENA100T(SA2->A2_COD,SZ1->Z1_FILIAL)
        SA2->(DbSetOrder(1))
        SA2->(DbSeek( xFilial("SA2")+SZ1->Z1_FORNECE+SZ1->Z1_LOJA ))

        SRA->(DbOrderNickName("FORNECEDOR"))
        If !SRA->(DbSeek( SZ1->Z1_FILIAL+SZ1->Z1_FORNECE ))
            MsgStop("Autonomo não localizado para a fornecedor informado! Tente novamente!")
            Return nil
        EndIF
    ENDIF
EndIF

If Empty(SRA->RA_CODFUNC)
    MsgStop("Codigo da função não informado para o autonomo!")
    Return .F.
EndIf

/*
If Empty(SRA->RA_DEPTO)
    MsgStop("Codigo do departamento não informado para o autonomo!")
    Return .F.
EndIf
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³usa funcao do padrao para busca do periodo a ser encerrado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fGetPerAtual( @aPerAtual, , "00003", "AUT" )
cPeriodo := aPerAtual[1,5]+aPerAtual[1,4]

IF MESANO(SZ1->Z1_DATA) <> cPeriodo
    MsgStop("Data de referencia informada está divergente ao período atual ("+cPeriodo+") em aberto no modulo Gestão de Pessoas?")
    Return .F.
ENDIF

SZ1->(DbSetOrder(3))//Z1_FILIAL+Z1_FORNECE+Z1_LOJA+Z1_DATA+Z1_PD+Z1_CLASSE+Z1_SEQ
SZ1->(DbSeek( cChaveSZ1 ))
While SZ1->Z1_FILIAL+SZ1->Z1_FORNECE+SZ1->Z1_LOJA+DtoS(SZ1->Z1_DATA) == cChaveSZ1

    IF SZ1->Z1_INSS <> "1"
        SZ1->(DbSkip())
        Loop
    ENDIF

    If SZ1->Z1_FILIAL == '7001'
        cCC := '10407012'
    ElseIF !Empty(SZ1->Z1_CC) .OR. SZ1->Z1_PD == "S01"
        cCC := SRA->RA_CC
    Else    
        cCC := SZ1->Z1_CC
    EndIF

    nPosLanc := aScan(aLanc, {|x| x[1]+x[2]+x[3]+x[4]/*+x[5]+x[6]*/ == SZ1->Z1_FILIAL + SZ1->Z1_FORNECE + SZ1->Z1_LOJA + cCC /*+ SZ1->Z1_CLASSE + SZ1->Z1_ITEM*/ })
    IF nPosLanc == 0
        Aadd(aLanc, { SZ1->Z1_FILIAL,SZ1->Z1_FORNECE,SZ1->Z1_LOJA,cCC,SZ1->Z1_CLASSE,SZ1->Z1_ITEM,SZ1->Z1_DATA,(SZ1->Z1_VALOR*SZ1->Z1_HORAS),0,IIF( SZ1->Z1_FILIAL == '7001' , '026' , '257' ),SZ1->Z1_SEQ,{SZ1->(Recno())} } )
        nPosLanc    := Len(aLanc)
    Else
        aLanc[nPosLanc][08] += (SZ1->Z1_VALOR*SZ1->Z1_HORAS)
        aLanc[nPosLanc][09] += 0
        Aadd(aLanc[nPosLanc][12],SZ1->(Recno()))
        If SZ1->Z1_SEQ > aLanc[nPosLanc][11]
            aLanc[nPosLanc][11] := SZ1->Z1_SEQ
        EndIF    
    EndIF

    SZ1->(DbSkip())
End

Restarea(aAreaSZ1)

IF Len(aLanc) == 0
    MsgStop("Nenhum lançamento identificado!")
    Return nil
EndIF

//Criando variaveis do cabecalho
aAdd( aCabAuto,{ 'RA_FILIAL',   SZ1->Z1_FILIAL          , nil })
aAdd( aCabAuto,{ 'RA_MAT',      SRA->RA_MAT             , nil })
aAdd( aCabAuto,{ 'CROTEIRO',    "AUT"                   , nil })
aAdd( aCabAuto,{ 'CNUMPAGTO',   '01'                    , nil })
//aAdd( aCabAuto,{ 'CPERIODO' ,   Left(DtoS(DDataBase),6) , nil })
aAdd( aCabAuto,{ 'CPERIODO' ,   cPeriodo , nil })

For nAuxIt := 1 To Len(aLanc)
    aLinha  := {}
    //Criando variaveis dos itens
    aadd(aLinha,{'RGB_SEMANA'   , '01'              , nil})
    aadd(aLinha,{'RGB_PD'       , aLanc[nAuxIt][10] , nil})
    aadd(aLinha,{'RGB_TIPO1'    , 'V'               , nil})
    aadd(aLinha,{'RGB_TIPO2'    , 'G'               , nil})
    aadd(aLinha,{'RGB_HORAS'    , 0                  , nil})
    aadd(aLinha,{'RGB_VALOR'    , aLanc[nAuxIt][08] , nil})
    aadd(aLinha,{'RGB_DTREF'    , aLanc[nAuxIt][07] , nil})

    cCC       := IIF( !Empty(aLanc[nAuxIt][04]) , aLanc[nAuxIt][04] , SRA->RA_CC    )
    //cItem     := IIF( !Empty(aLanc[nAuxIt][06]) , aLanc[nAuxIt][06] , SRA->RA_ITEM  )
    //cClass    := IIF( !Empty(aLanc[nAuxIt][05]) , aLanc[nAuxIt][05] , SRA->RA_CLVL  )

    aadd(aLinha,{'RGB_CC'       , cCC , nil})
    // durante a validação verifiquei que este dado não lançado pelo RH
    //aadd(aLinha,{'RGB_ITEM'     , cItem , nil})
    //aadd(aLinha,{'RGB_CLVL'     , cClass , nil})

    aadd(aLinha,{'RGB_PARCEL'   , 1                 , nil})
    aadd(aLinha,{'RGB_SEQ'      , nAuxIt            , nil})


    If !Empty(SRA->RA_CODFUNC)
        aadd(aLinha,{'RGB_CODFUN'   , SRA->RA_CODFUNC   , nil})
    EndIF
    
    // If !Empty(SRA->RA_DEPTO)
    //     aadd(aLinha,{'RGB_DEPTO'    , SRA->RA_DEPTO     , nil})
    // EndIf

    //Atribuindo variavel para MsExecAuto
    aadd(aItemAuto,aClone(aLinha))
Next

SM0->(dbSetOrder(1))
SM0->(dbSeek(cEmpAux + SZ1->Z1_FILIAL,.T.)) //Posiciona Empresa

cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
cFilAnt := SM0->M0_CODFIL
OpenFile(cEmpAnt + cFilAnt)

SRA->(DbOrderNickName("FORNECEDOR"))
SRA->(DBseek( SZ1->Z1_FILIAL+SZ1->Z1_FORNECE )) 

RGB->(DbSetOrder(3))//RGB_FILIAL+RGB_PROCES+RGB_MAT+RGB_PERIOD+RGB_SEMANA+RGB_PD+RGB_SEQ
If RGB->(DbSeek( xFilial("RGB")+"00003"+SRA->RA_MAT+cPeriodo ))
    nOper := 4
    IF !MsgYesNo("Foram identificados lançamentos para a matricula informada, deseja continuar e adiciobar os valores?")
        Return .F.
    ENDIF
EndIf

Restarea(aAreaRGB)

BEGIN TRANSACTION
    //Chama a rotina
    MsExecAuto({|a, b, c, d| GPEA580(a,b,c,d)},nil, aCabAuto, aItemAuto,nOper)

    //Faz a validacao
    If !lMsErroAuto
        For nAuxIt := 1 To Len(aLanc)
            For nAuxRc := 1 To Len(aLanc[nAuxIt][12])
                SZ1->( DbGoTo( aLanc[nAuxIt][12][nAuxRc] ) )
                RecLock("SZ1",.F.)
                SZ1->Z1_STATUS  := "2"
                MsUnLock()
            Next nAuxRc    
        Next nAuxIt   
    EndIf
End Transaction

//Faz a validacao
If !lMsErroAuto
    MsgInfo("Enviado ao GPE com sucesso! ")
Else
    MostraErro()
EndIf


SM0->(dbSetOrder(1))
SM0->(dbSeek(cEmpBkp + cFilBkp,.T.)) //Posiciona Empresa

cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
cFilAnt := SM0->M0_CODFIL
OpenFile(cEmpAnt + cFilAnt)

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA097S  ºAutor  ³Cleuto Lima         º Data ³  23/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ retorna sequencia do lançamento                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function GENA097S(cFornece,cLoja,cVerba)

Local aPerAtual	    := {}	
Local cSeq          := StrZero(1,TamSX3("RGB_SEQ")[1])
Local oModelDad     := FWModelActive()
Local nOpc          := oModelDad:GetOperation()
Local oModelGrid    := oModelDad:GetModel('SZ1_GRID')
Local nBkpLine      := oModelGrid:nLine
Local nAtual        := 0

If Empty(cFornece)
    cFornece    := oModelDad:GetValue('SZ1_FORM', 'Z1_FORNECE')
    cLoja       := oModelDad:GetValue('SZ1_FORM', 'Z1_LOJA')
EndIf    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³usa funcao do padrao para busca do periodo a ser encerrado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fGetPerAtual( @aPerAtual, , "00003", "AUT" )
cPeriodo := aPerAtual[1,5]+aPerAtual[1,4]
/*
RGB->(DbSetOrder(1))//RGB_FILIAL+RGB_MAT+RGB_PD+RGB_PERIOD+RGB_SEMANA+RGB_SEQ+RGB_CONVOC
RGB->(DbSeek( xFilial("RGB")+cMat+cVerba+cPeriodo))
While xFilial("RGB")+cMat+cVerba+cPeriodo == RGB->(RGB_FILIAL+RGB_MAT+RGB_PD+RGB_PERIOD)
    cSeq    := RGB->RGB_SEQ
    RGB->(DkSip())
EndDo

cSeq    := Soma1(cSeq)
*/
IF Select("TMP_SEQ") > 0
    TMP_SEQ->(DbCloseArea())
ENDIF

BEGINSQL ALIAS "TMP_SEQ"
    SELECT trim(MAX(Z1_SEQ)) Z1_SEQ FROM %Table:SZ1% SZ1
    WHERE Z1_FILIAL = %xFilial:SZ1%
    AND Z1_FORNECE = %Exp:cFornece%
    AND Z1_LOJA = %Exp:cLoja%
    /*AND Z1_MAT = %Exp:cCod%*/    
    /*AND SZ1.Z1_STATUS <> '1'*/
    AND SUBSTR(Z1_DATA,1,6) >= %Exp:cPeriodo%
    AND Z1_PD = %Exp:cVerba%
    AND SZ1.%NotDel%
ENDSQL
TMP_SEQ->(DbGoTop())

IF TMP_SEQ->Z1_SEQ >= cSeq
    cSeq := Soma1(TMP_SEQ->Z1_SEQ)
ENDIF

TMP_SEQ->(DbCloseArea())

For nAtual := 1 To oModelGrid:Length()
    oModelGrid:GoLine( nAtual )
    IF nAtual == nBkpLine .OR. oModelGrid:GetValue( 'Z1_PD' ) <> cVerba
        Loop
    ENDIF    
    IF Val(oModelGrid:GetValue( 'Z1_SEQ' )) >= Val(cSeq)
        cSeq := Soma1(AllTrim(oModelGrid:GetValue( 'Z1_SEQ' )))
    ENDIF
Next

oModelGrid:GoLine( nBkpLine )

Return cSeq

User function GENA097G(oModel)

Local lRet       := .T.
Local aArea      := GetArea()
Local lRet       := .T.
Local oModelDad  := oModel//FWModelActive()
Local nOpc       := oModelDad:GetOperation()
Local oModelGrid := oModelDad:GetModel('SZ1_GRID')
Local nAtual     := 0
Local cChave     := ""
Local nRecAux    := 0
Local lNewReg    := .F.

//Se for Inclusão
If nOpc == MODEL_OPERATION_INSERT
    //Cria o registro na tabela 00 (Cabeçalho de tabelas)
    //Percorre as linhas da grid
    For nAtual := 1 To oModelGrid:Length()
        oModelGrid:GoLine( nAtual )
        //Se a linha não estiver excluída, inclui o registro
        If !oModelGrid:IsDeleted()
            RecLock('SZ1', .T.)
            SZ1->Z1_FILIAL   := xFilial("SZ1")
            //SZ1->Z1_MAT      := oModelDad:GetValue('SZ1_FORM', 'Z1_MAT')
            SZ1->Z1_FORNECE  := oModelDad:GetValue('SZ1_FORM', 'Z1_FORNECE')
            SZ1->Z1_LOJA     := oModelDad:GetValue('SZ1_FORM', 'Z1_LOJA')
            SZ1->Z1_NOME     := oModelDad:GetValue('SZ1_FORM', 'Z1_NOME')
            SZ1->Z1_DATA     := oModelDad:GetValue('SZ1_FORM', 'Z1_DATA' )
            SZ1->Z1_DATAREF  := oModelDad:GetValue('SZ1_FORM', 'Z1_DATAREF' )
            SZ1->Z1_DEPTO    := oModelDad:GetValue('SZ1_FORM', 'Z1_DEPTO' )
            SZ1->Z1_CC       := oModelDad:GetValue('SZ1_FORM', 'Z1_CC' )
            SZ1->Z1_STATUS   := oModelDad:GetValue('SZ1_FORM', 'Z1_STATUS' )
            SZ1->Z1_PD       := oModelGrid:GetValue( 'Z1_PD' )
            SZ1->Z1_HORAS    := oModelGrid:GetValue( 'Z1_HORAS' )
            SZ1->Z1_SERVICO  := oModelGrid:GetValue( 'Z1_SERVICO' )
            SZ1->Z1_VALOR    := oModelGrid:GetValue( 'Z1_VALOR' )
            SZ1->Z1_DESCRI   := oModelGrid:GetValue( 'Z1_DESCRI' )            
            SZ1->Z1_ITEM     := oModelGrid:GetValue( 'Z1_ITEM' )
            SZ1->Z1_CLASSE   := oModelGrid:GetValue( 'Z1_CLASSE' )
            SZ1->Z1_SEQ      := oModelGrid:GetValue( 'Z1_SEQ' )
            SZ1->Z1_OBS      := oModelGrid:GetValue( 'Z1_OBS' )
            SZ1->Z1_JUSTIFI  := oModelGrid:GetValue( 'Z1_JUSTIFI' )
            SZ1->Z1_TITULO   := oModelGrid:GetValue( 'Z1_TITULO' )
            SZ1->Z1_INSS     := oModelGrid:GetValue( 'Z1_INSS' )
            SZ1->Z1_IDSEQ    := GetSX8Num("SZ1","Z1_IDSEQ")    
            SZ1->Z1_USERINC  := UsrRetName(RetCodUsr())        
            SZ1->(MsUnlock())
            ConfirmSx8()
        EndIf
    Next
    
//Se for Alteração
ElseIf nOpc == MODEL_OPERATION_UPDATE
    //Cria o registro na tabela 00 (Cabeçalho de tabelas)
    //Percorre as linhas da grid
    SZ1->(DbSetOrder(3))//Z1_FILIAL+Z1_MAT+Z1_DATA+Z1_PD+Z1_CLASSE+Z1_SEQ

    Begin Transaction
    For nAtual := 1 To oModelGrid:Length()
        lNewReg := .T.
        oModelGrid:GoLine( nAtual )
        nRecAux := oModelGrid:GetDataId(nAtual)
        //cChave  := xFilial("SZ1")+oModelDad:GetValue('SZ1_FORM', 'Z1_FORNECE')+oModelDad:GetValue('SZ1_FORM', 'Z1_LOJA')+DtoS(oModelDad:GetValue('SZ1_FORM', 'Z1_DATA' ))+oModelGrid:GetValue( 'Z1_PD' )+oModelGrid:GetValue( 'Z1_CLASSE' )+oModelGrid:GetValue( 'Z1_SEQ' )
        //IF SZ1->(DbSeek( cChave ))
        If nRecAux > 0
            lNewReg := .F.
            SZ1->(DbgoTo(nRecAux))
        EndIf    
       // ENDIF
        //Se a linha não estiver excluída, inclui o registro
        If !oModelGrid:IsDeleted()
            RecLock('SZ1', lNewReg)
            SZ1->Z1_FILIAL   := xFilial("SZ1")
            SZ1->Z1_FORNECE  := oModelDad:GetValue('SZ1_FORM', 'Z1_FORNECE')
            SZ1->Z1_LOJA     := oModelDad:GetValue('SZ1_FORM', 'Z1_LOJA')
            SZ1->Z1_NOME     := oModelDad:GetValue('SZ1_FORM', 'Z1_NOME')
            SZ1->Z1_DATA     := oModelDad:GetValue('SZ1_FORM', 'Z1_DATA' )
            SZ1->Z1_DATAREF  := oModelDad:GetValue('SZ1_FORM', 'Z1_DATAREF' )  
            SZ1->Z1_DEPTO    := oModelDad:GetValue('SZ1_FORM', 'Z1_DEPTO' )
            SZ1->Z1_CC       := oModelDad:GetValue('SZ1_FORM', 'Z1_CC' )          
            SZ1->Z1_STATUS   := oModelDad:GetValue('SZ1_FORM', 'Z1_STATUS' )            
            SZ1->Z1_PD       := oModelGrid:GetValue( 'Z1_PD' )
            SZ1->Z1_HORAS    := oModelGrid:GetValue( 'Z1_HORAS' )
            SZ1->Z1_SERVICO  := oModelGrid:GetValue( 'Z1_SERVICO' )
            SZ1->Z1_VALOR    := oModelGrid:GetValue( 'Z1_VALOR' )
            SZ1->Z1_DESCRI   := oModelGrid:GetValue( 'Z1_DESCRI' )            
            SZ1->Z1_ITEM     := oModelGrid:GetValue( 'Z1_ITEM' )
            SZ1->Z1_CLASSE   := oModelGrid:GetValue( 'Z1_CLASSE' )
            SZ1->Z1_SEQ      := oModelGrid:GetValue( 'Z1_SEQ' )
            SZ1->Z1_OBS      := oModelGrid:GetValue( 'Z1_OBS' )
            SZ1->Z1_JUSTIFI  := oModelGrid:GetValue( 'Z1_JUSTIFI' )    
            SZ1->Z1_TITULO   := oModelGrid:GetValue( 'Z1_TITULO' )    
            SZ1->Z1_INSS     := oModelGrid:GetValue( 'Z1_INSS' )   
            SZ1->Z1_USERINC  := UsrRetName(RetCodUsr())
            IF lNewReg
                SZ1->Z1_IDSEQ    := GetSX8Num("SZ1","Z1_IDSEQ")
                ConfirmSx8()
            ENDIF
            SZ1->(MsUnlock())
        else
            RecLock("SZ1",.F.)
            SZ1->(DbDelete())
            SZ1->(MsUnLock())                
        EndIf
    Next  
    End Transaction
//Se for Exclusão
ElseIf nOpc == MODEL_OPERATION_DELETE
    //Cria o registro na tabela 00 (Cabeçalho de tabelas)
    //Percorre as linhas da grid
    SZ1->(DbSetOrder(3))//Z1_FILIAL+Z1_MAT+Z1_DATA+Z1_PD+Z1_CLASSE+Z1_SEQ

    Begin Transaction
    For nAtual := 1 To oModelGrid:Length()
        oModelGrid:GoLine( nAtual )
        nRecAux := oModelGrid:GetDataId(nAtual)
        //cChave  := xFilial("SZ1")+oModelDad:GetValue('SZ1_FORM', 'Z1_FORNECE')+oModelDad:GetValue('SZ1_FORM', 'Z1_LOJA')+DtoS(oModelDad:GetValue('SZ1_FORM', 'Z1_DATA' ))+oModelGrid:GetValue( 'Z1_PD' )+oModelGrid:GetValue( 'Z1_CLASSE' )+oModelGrid:GetValue( 'Z1_SEQ' )
        //IF SZ1->(DbSeek( cChave ))
        If nRecAux > 0
            SZ1->(DbGoTo(nRecAux))
            RecLock("SZ1",.F.)
            SZ1->(DbDelete())
            SZ1->(MsUnLock())
        EndIf    
        //ENDIF
    Next  
    End Transaction   
EndIf

//Se não for inclusão, volta o INCLUI para .T. (bug ao utilizar a Exclusão, antes da Inclusão)
If nOpc != MODEL_OPERATION_INSERT
    INCLUI := .T.
EndIf

Return lRet

Static Function loadField(oFieldModel)

If oFieldModel:GetOperation() == MODEL_OPERATION_INSERT
    ZZF->(DbSetOrder(1))
    ZZC->(DbSetOrder(1))
    If ZZF->( DbSeek( xFilial("ZZF")+RetCodUsr() ) )        
	    oFieldModel:LoadValue( 'SZ1_FORM', 'Z1_DEPTO', ZZF->ZZF_DEPTO )
        IF ZZC->( DbSeek( xFilial("ZZC")+"ZX"+ZZF->ZZF_DEPTO ) )
            oFieldModel:LoadValue( 'SZ1_FORM', 'Z1_CC', ZZC->ZZC_CC )
            oFieldModel:LoadValue( 'SZ1_FORM', 'Z1_DESCDPT', AllTrim(ZZC->ZZC_DESC) )
            oFieldModel:LoadValue( 'SZ1_FORM', 'Z1_DESCC', AllTrim(Posicione("CTT",1,xFilial("CTT")+ZZC->ZZC_CC,"CTT_DESC01")) )
        ENDIF
    EndIf    
EndIF

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA097S  ºAutor  ³Cleuto Lima         º Data ³  23/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ retorna sequencia do lançamento                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function GENA097V(oModel)

Local lRet       := .T.
Local aArea      := GetArea()
Local lRet       := .T.
Local oModelDad  := oModel//FWModelActive()
Local nOpc       := oModelDad:GetOperation()
Local oModelGrid := oModelDad:GetModel('SZ1_GRID')
Local nAtual     := 0
Local cChave     := ""
Local nRecAux    := 0
Local lNewReg    := .F.
Local nValSrc    := 0

If nOpc == MODEL_OPERATION_UPDATE .OR. nOpc == MODEL_OPERATION_INSERT
    SZ1->(DbSetOrder(6))//Z1_FILIAL+Z1_FORNECE+Z1_LOJA+Z1_DATA+Z1_SERVICO

    For nAtual := 1 To oModelGrid:Length()
        oModelGrid:GoLine( nAtual )
        nRecAux := oModelGrid:GetDataId(nAtual)

        nValSrc := Posicione("ZZC",1,xFilial("ZZC")+"ZY"+oModelGrid:GetValue( 'Z1_SERVICO' ),"ZZC_VLR1")
        IF nValSrc > 0
            IF nValSrc < oModelGrid:GetValue( 'Z1_VALOR' )
                IF Empty(oModelGrid:GetValue( 'Z1_JUSTIFI' ))
                    lRet := .F.
                    MsgStop("Deve ser informada justificativa no item "+cValToChar(nAtual)+" para o serviço "+oModelGrid:GetValue( 'Z1_SERVICO' )+;
                    ", pois o valor pago é superior ao valor ("+Transform(nValSrc,'@E 999,999,999.99')+") cadastrado para este serviço!")
                    Exit                    
                ENDIF
            ENDIF
        ENDIF

        If oModelGrid:IsDeleted() .OR. nRecAux > 0
            Loop
        EndIF
        
        cChave := xFilial("SZ1")+oModelDad:GetValue('SZ1_FORM', 'Z1_FORNECE')+oModelDad:GetValue('SZ1_FORM', 'Z1_LOJA')+;
                                    DtoS(oModelDad:GetValue('SZ1_FORM', 'Z1_DATA' ))+oModelGrid:GetValue( 'Z1_SERVICO' )+;
                                    oModelGrid:GetValue( 'Z1_CLASSE' )

        IF SZ1->( DbSeek( cChave ) )
            lRet := .F.
            MsgStop("Já existe lançamento realizada para este fornecedor na data especificada para o tipo de serviço "+oModelGrid:GetValue( 'Z1_SERVICO' ))
            Exit
        ENDIF

    Next  
    
EndIF

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA097S  ºAutor  ³Cleuto Lima         º Data ³  23/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User function GENA097T()

Local lRet      := .F.
Local aAprov    := {}
Local oDlgFin   := nil
Local oPntGer   := nil
Local aHList    := NIL
Local oListPag  := nil
Local aButtons  := {}
Local bConfirm  := {|x| lRet := .T., oDlgFin:End() }
Local bCancel   := {|x| oDlgFin:End() }
Local nAuxFin   := 0
Local cMsgProc  := ""

Private oOk	  	:= LoadBitMap(GetResources(),"LBOK")
Private oNOk	:= LoadBitMap(GetResources(),"LBNO")

IF !Pergunte("GENA097T",.T.)
    Return nil
ENDIF

IF Select("TMP_SZ1") > 0
    TMP->(DbCloseArea())
EndIF

BEGINSQL ALIAS "TMP_SZ1"
    SELECT Z1_FILIAL,Z1_IDSEQ,Z1_FORNECE,Z1_NOME,Z1_SERVICO,Z1_DESCRI,Z1_HORAS,Z1_VALOR,Z1_CLASSE,Z1_TITULO,Z1_DATA,SZ1.R_E_C_N_O_ RECSZ1 FROM %Table:SZ1% SZ1
    WHERE Z1_DATA >= %Exp:DDataBase%
    AND SZ1.%NotDel%
    AND Z1_STATUS = '1'
    AND Z1_INSS = '2'
    AND Z1_DATA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
    ORDER BY Z1_FILIAL,Z1_FORNECE,Z1_IDSEQ
ENDSQL

TMP_SZ1->(DbGoTop())
While TMP_SZ1->(!EOF())

    Aadd(aAprov, Array(14))

    aAprov[Len(aAprov)][01]  := TMP_SZ1->Z1_FILIAL
    aAprov[Len(aAprov)][02]  := TMP_SZ1->Z1_IDSEQ
    aAprov[Len(aAprov)][03]  := TMP_SZ1->Z1_FORNECE
    aAprov[Len(aAprov)][04]  := TMP_SZ1->Z1_NOME
    aAprov[Len(aAprov)][05]  := TMP_SZ1->Z1_SERVICO
    aAprov[Len(aAprov)][06]  := TMP_SZ1->Z1_DESCRI
    aAprov[Len(aAprov)][07]  := TMP_SZ1->Z1_HORAS
    aAprov[Len(aAprov)][08]  := TMP_SZ1->Z1_VALOR
    aAprov[Len(aAprov)][09]  := TMP_SZ1->Z1_CLASSE
    aAprov[Len(aAprov)][10]  := TMP_SZ1->Z1_TITULO
    aAprov[Len(aAprov)][11]  := StoD(TMP_SZ1->Z1_DATA)
    aAprov[Len(aAprov)][12]  := TMP_SZ1->RECSZ1
    aAprov[Len(aAprov)][13]  := .T.
    aAprov[Len(aAprov)][14]  := TMP_SZ1->Z1_HORAS*TMP_SZ1->Z1_VALOR

    TMP_SZ1->(DbSkip())
EndDo

IF Select("TMP_SZ1") > 0
    TMP_SZ1->(DbCloseArea())
EndIF

Define Dialog oDlgFin Title "Aprovar pagamentos financeiro" From 00,00 TO 300,750 PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Armazena as corrdenadas da tela                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMbrWidth	:= oDlgFin:nWidth/2-43
nMbrHeight	:= oDlgFin:nHeight/2

@00,00 MSPANEL oPntGer PROMPT "" SIZE nMbrWidth/2.5,nMbrHeight/2.5 of oDlgFin
oPntGer:Align := CONTROL_ALIGN_ALLCLIENT

oGrpProd 	:= TGroup():New(05,05,(oPntGer:NCLIENTHEIGHT/2)-54,(oPntGer:NCLIENTWIDTH/2)-10,"Pagamentos encontrados...",oPntGer,CLR_RED,,.T.)
oListPag	:= TWBrowse():New(15,10,(oPntGer:NCLIENTWIDTH/2)-25,(oPntGer:NCLIENTHEIGHT/2)-70,,aHList,,oPntGer,,,,,,,,,,,,, "ARRAY", .T. )

oListPag:AddColumn(TCColumn():New( " "			,{|| IIF( aAprov[oListPag:nAT][13] == .T. , oOk , oNOk )		},,,,'CENTER'	,10,.t.,.F.,,,,.F.,))
oListPag:AddColumn(TCColumn():New( "Dt.Pgto" 	,{|| aAprov[oListPag:nAT][11]		},,,,'CENTER'	,045,.F.,.F.,,,,.F.,))
oListPag:AddColumn(TCColumn():New( "Filial"	    ,{|| aAprov[oListPag:nAT][01]		},,,,'LEFT'		,025,.F.,.F.,,,,.F.,))	
oListPag:AddColumn(TCColumn():New( "Num.Pagto"	,{|| aAprov[oListPag:nAT][02]		},,,,'LEFT'		,045,.F.,.F.,,,,.F.,))	
oListPag:AddColumn(TCColumn():New( "Cod.For."	,{|| aAprov[oListPag:nAT][03]		},,,,'LEFT'		,045,.F.,.F.,,,,.F.,))	
oListPag:AddColumn(TCColumn():New( "Nome"	    ,{|| aAprov[oListPag:nAT][04]		},,,,'LEFT'		,100,.F.,.F.,,,,.F.,))	
oListPag:AddColumn(TCColumn():New( "Cod.Serv."	,{|| aAprov[oListPag:nAT][05]		},,,,'LEFT'		,030,.F.,.F.,,,,.F.,))	
oListPag:AddColumn(TCColumn():New( "Desc.Serv."	,{|| aAprov[oListPag:nAT][06]		},,,,'LEFT'		,100,.F.,.F.,,,,.F.,))	
oListPag:AddColumn(TCColumn():New( "Qtd."   	,{|| aAprov[oListPag:nAT][07]		},,,,'RIGHT'	,030,.F.,.F.,,,,.F.,))	
oListPag:AddColumn(TCColumn():New( "Valor"  	,{|| aAprov[oListPag:nAT][08]		},"@E 999,999,999.99",,,'RIGHT'	,050,.F.,.F.,,,,.F.,))	
oListPag:AddColumn(TCColumn():New( "Total"  	,{|| aAprov[oListPag:nAT][14]		},"@E 999,999,999.99",,,'RIGHT'	,050,.F.,.F.,,,,.F.,))	
oListPag:AddColumn(TCColumn():New( "Produto"	,{|| aAprov[oListPag:nAT][09]		},,,,'LEFT'		,050,.F.,.F.,,,,.F.,))	
oListPag:AddColumn(TCColumn():New( "Titulo"	    ,{|| aAprov[oListPag:nAT][10]		},,,,'LEFT'		,100,.F.,.F.,,,,.F.,))		

oListPag:SetArray( aAprov )

If Len(aAprov) > 0
    oListPag:bLDblClick	:= {|x| aAprov[oListPag:nAT][13] := !aAprov[oListPag:nAT][13] }		
EndIf    

Activate MsDialog oDlgFin On Init EnchoiceBar(oDlgFin,bConfirm,bCancel,,aButtons) Centered

IF lRet
    For nAuxFin := 1 To Len(aAprov)
        IF !aAprov[nAuxFin][13]
            Loop
        ENDIF 
        SZ1->(DbGoTo( aAprov[nAuxFin][12] ))
        U_GENA097F(.T.,@cMsgProc,Len(aAprov),nAuxFin)
    Next nAuxFin
ENDIF

Return nil

User function GENA097F(lAll,cMsgProc,nQtdProc,nProcAtu)

Processa({|| ProcFin(lAll,@cMsgProc,nQtdProc,nProcAtu) },"Processando...","Aguarde.. integrando lançamento com modulo financeiro!",.F.)

Return nil

Static function ProcFin(lAll,cMsgProc,nQtdProc,nProcAtu)
Local aAreaSZ1  := SZ1->(GetArea())
Local cFornece  := SZ1->Z1_FORNECE
Local cLoja     := SZ1->Z1_LOJA
Local cPrefixo  := "RPA"
Local cTipo     := "RPA"
Local cNum      := ""
Local cParcela  := CriaVar("E2_PARCELA",.F.)
Local dDataOld  := Ctod("  /  /  ")
Local cEmpAux   := cEmpAnt
Local cEmpBkp   := cEmpAnt
Local cFilBkp   := cFilAnt
Local cChaveSZ1 := SZ1->Z1_FILIAL+SZ1->Z1_FORNECE+SZ1->Z1_LOJA+DtoS(SZ1->Z1_DATA)
Local nValTed   := GETMV("MV_XINFPGT")
Local cForPgt   := ""
Local cBanco    := POSICIONE("SA2",1,XFILIAL("SA2")+SZ1->Z1_FORNECE+SZ1->Z1_LOJA,"A2_BANCO")
Local nE2Valor  := 0

Default lAll        := .F.
Default nQtdProc    := 1
Default nProcAtu    := 1

ProcRegua(nQtdProc)

IF SZ1->Z1_STATUS <> "1"    
    If !lAll
        MsgStop("Situação do registro não permite efetivação "+SZ1->Z1_IDSEQ+" ("+AllTrim(SZ1->Z1_NOME)+")!")
    EndIF    
    Return nil
EndIf

IF SZ1->Z1_INSS <> "2"
    If !lAll
        MsgStop("Lançamento não pertence ao Financeiro!")
        Return nil
    EndIf
EndIf

If !lAll
    IF !MsgYesNo("Confirma aprovação do lançamento?")
        Return nil        
    EndIf
ENDIF

DbSelectArea("SE2")
DbSetOrder(1)

dDataOld	:= dDataBase
dDataBase	:= SZ1->Z1_DATAREF

If cFilAnt <> SZ1->Z1_FILIAL
    SM0->(dbSetOrder(1))
    SM0->(dbSeek(cEmpAux + SZ1->Z1_FILIAL,.T.)) //Posiciona Empresa

    cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
    cFilAnt := SM0->M0_CODFIL
    OpenFile(cEmpAnt + cFilAnt)
EndIf

SZ1->(DbSetOrder(3))//Z1_FILIAL+Z1_FORNECE+Z1_LOJA+Z1_DATA+Z1_PD+Z1_CLASSE+Z1_SEQ
SZ1->(DbSeek( cChaveSZ1 ))
While SZ1->Z1_FILIAL+SZ1->Z1_FORNECE+SZ1->Z1_LOJA+DtoS(SZ1->Z1_DATA) == cChaveSZ1

    IncProc("Processando.."+cValToChar(nProcAtu)+" de "+cValToChar(nQtdProc))

    IF SZ1->Z1_INSS <> "2"
        SZ1->(DbSkip())
        Loop
    ENDIF

    cNum     := PadL(AllTrim(SZ1->Z1_IDSEQ),TamSX3("E2_NUM")[1],"0") //NextNumSZ1(cFornece,cLoja,cPrefixo,cTipo)
    nE2Valor := SZ1->Z1_VALOR*SZ1->Z1_HORAS

    If Empty(cBanco)
        cForPgt := "  "
    ElseIf Alltrim(cBanco) = '341'
        cForPgt := "01"
    ElseIf nE2Valor <= nValTed
        cForPgt := "03"
    Else
        cForPgt := "41"
    EndIf

    aTitulo := {}

    aAdd(aTitulo, {"E2_FILIAL" 	, xFilial("SE2")                            , Nil})
    aAdd(aTitulo, {"E2_PREFIXO" , cPrefixo									, Nil})
    aAdd(aTitulo, {"E2_NUM" 	, cNum 										, Nil})
    aAdd(aTitulo, {"E2_PARCELA" , cParcela									, Nil})
    //aUpd := aClone(aTitulo) //Array para exclusao do titulo, caso necessario
    aAdd(aTitulo, {"E2_TIPO" 	, cTipo										, Nil})
    aAdd(aTitulo, {"E2_FORNECE" , cFornece		   							, Nil})
    aAdd(aTitulo, {"E2_LOJA" 	, cLoja	    				   				, Nil})
    //aExcl := aClone(aTitulo) //Array para exclusao do titulo, caso necessario
    aAdd(aTitulo, {"E2_CONTAD"	, IIF(SZ1->Z1_PD == 'S01','11030201','42070105') , Nil})
    aAdd(aTitulo, {"E2_NATUREZ" , IIF(SZ1->Z1_INSS == '2','40198','40199')       , Nil})

    aAdd(aTitulo, {"E2_EMISSAO" , SZ1->Z1_DATAREF           			    , Nil})
    aAdd(aTitulo, {"E2_EMIS1"	, SZ1->Z1_DATAREF				            , Nil})
    aAdd(aTitulo, {"E2_VENCTO" 	, SZ1->Z1_DATA				                , Nil})
    //aAdd(aTitulo, {"E2_VENCREA" , DATAVALIDA(sTod((cAliasQry)->E2_VENCREA)) 	, Nil})
    aAdd(aTitulo, {"E2_VALOR" 	, nE2Valor               , Nil})
    aAdd(aTitulo, {"E2_MOEDA" 	, 1                 	     				, Nil})
    aAdd(aTitulo, {"E2_FLUXO" 	, "S"										, Nil})
    aAdd(aTitulo, {"E2_XFORPGT" , cForPgt									, Nil})
    //RODRIGO MOURAO - CAMPOS CRIADOS PARA ATENDER A IMPORTAÇÃO DOS TITULOS RPA SEM INSS
    aAdd(aTitulo, {"E2_ITEMD"   , IIF(SZ1->Z1_PD == 'S02','000000',SZ1->Z1_ITEM   )  , Nil})
    aAdd(aTitulo, {"E2_CLVLDB" 	, IIF(SZ1->Z1_PD == 'S02','000000000',SZ1->Z1_CLASSE   )        			, Nil})
    aAdd(aTitulo, {"E2_RATEIO" 	, 'N'                   					, Nil})
    aAdd(aTitulo, {"E2_CCD" 	, IIF(SZ1->Z1_PD == 'S01',' ',SZ1->Z1_CC   )       				, Nil})
    //HELIMAR TAVARES - CAMPOS CRIADOS PARA DIRF NA IMPORTAÇÃO DOS TITULOS RPA SEM INSS	E D.A. NACIONAL

    If Len(AllTrim(SA2->A2_CGC)) == 14 // Cleuto - vivaz 36587 - 16/08/2017 - Se pessoa Juridica não vai pra DIRF
        aAdd(aTitulo, {"E2_DIRF"    , "2"       							, Nil})
        aAdd(aTitulo, {"E2_CODRET"  , " "									, Nil})
    Else
        aAdd(aTitulo, {"E2_DIRF"    , IIF(SZ1->Z1_INSS == '1','2','1')      , Nil})
        aAdd(aTitulo, {"E2_CODRET"  , IIF(SZ1->Z1_INSS == '1',' ','0588')   , Nil})			
    EndIf

    aAdd(aTitulo, {"E2_HIST"	, ALLTRIM(SZ1->Z1_DESCRI) 					, Nil})
    //aAdd(aTitulo, {"E2_XCODGEN" , ALLTRIM((cAliasQry)->E2_XCODGEN)			, Nil})
    aAdd(aTitulo, {"E2_CODRDA" , "EXECAUTO"									, Nil}) //FLAG PARA SABER SE O TITULO FOI IMPORTADO OU INSERIDO MANUALMENTE

    //aAdd(aUpd, {"E2_VALOR", SZ1->Z1_VALOR , Nil})
    lMsErroAuto := .F.
    lMSHelpAuto	:= .F.

    MSExecAuto({|x,y| Fina050(x,y)},aTitulo,3)

    If lMsErroAuto
        MostraErro()
    Else
        RecLock("SZ1",.F.)
        SZ1->Z1_STATUS  := "2"
        SZ1->Z1_NUM     := cNum
        MsUnLock()
        If !lAll
            MSGINFO("Lançamento integrado ao financeiro com sucesso!")            
        EndIF
    EndIf
    lMsErroAuto := .F.
    lMSHelpAuto	:= .F.

    SZ1->(Dbskip())
EndDo

If cFilBkp <> cFilAnt
    SM0->(dbSetOrder(1))
    SM0->(dbSeek(cEmpBkp + cFilBkp,.T.)) //Posiciona Empresa

    cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
    cFilAnt := SM0->M0_CODFIL
    OpenFile(cEmpAnt + cFilAnt)
EndIf

RestArea(aAreaSZ1)

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA097S  ºAutor  ³Cleuto Lima         º Data ³  23/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function NextNumSZ1(cFornece,cLoja,cPrefixo,cTipo)
Local cIdSZ1    := ""
Local lContinua := .T.
//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA

IF !lContinua
    Return cIdSZ1
ENDIF

cIdSZ1      := GetSX8Num("SZ1","Z1_NUM")
SE2->(DbSetOrder(1))
lContinua   := SE2->(DbSeek( xFilial("SE2")+cPrefixo+cIdSZ1+"  "+cTipo+cFornece+cLoja ))

While lContinua
    ConfirmSX8()
    cIdSZ1      := GetSX8Num("ZZL","ZZL_COD")
    lContinua   := SE2->(DbSeek( xFilial("SE2")+cPrefixo+cIdSZ1+"  "+cTipo+cFornece+cLoja ))
EndDo
ConfirmSX8()

Return cIdSZ1

User function GENA097R()



/*
Local cOptions  := "1;0;1;Teste"
Local cParam    := "cleuto.lima;15/04/20;2"

CALLCRYS("RPA008",cParam,cOptions)// + PADR(ALLTRIM(TMP->NUMOP),6) + "-" + alltrim(TMP->LABOR)
*/
Return nil
