#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "Totvs.ch"
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA097   ºAutor  ³Cleuto Lima         º Data ³  23/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
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

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))

// Definição das Operações disponíveis.
aRotina := MenuDef()           

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('SZ1')

oBrowse:AddLegend( "Z1_STATUS=='1'", "GREEN", "Integrado" )
oBrowse:AddLegend( "Z1_STATUS=='2'", "RED", "Não Integrado" )
oBrowse:AddLegend( "Z1_STATUS=='3'", "YELLOW", "Falha Integração" )

oBrowse:DisableDetails()
oBrowse:SetDescription(cTitTela) 
oBrowse:Activate()

Return NIL

Static Function MenuDef()
Local aRotina := {}

//aRotina := FWMVCMenu( "GENA092" )
ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.GENA097' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.GENA097' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.GENA097' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir' ACTION 'VIEWDEF.GENA097' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Aprovar' ACTION 'U_GENA097B' OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()
// Cria Estruturas para serem usadas no Modelo de Dados
Local oStruZZX  := FWFormStruct(1,'SZ1')
Local bBloco	:= {|oModel| loadField(oModel)}
// Cria Modelo de Dados
Local oModel 

oModel := MPFormModel():New('MDFGENA097')

// Adiciona um Componente de Formulário ao modelo.
oModel:AddFields('SZ1_FORM',/*cOwner*/,oStruZZX,/*blinePre*/,/*blinePos*/) 

// Descrição do Modelo
oModel:SetDescription(cTitTela) 
// Descrição do Modelo
oModel:GetModel('SZ1_FORM'):SetDescription(cTitTela)

Return oModel      

Static Function ViewDef()

// Cria Estruturas para serem usadas na View
Local oStruZZX  := FWFormStruct(2,'SZ1',{|cCampo| AllTrim(cCampo) $ "Z1_FILIAL/Z1_PD/Z1_MAT/Z1_NOME/Z1_HORAS/Z1_VALOR/Z1_DATA/Z1_DATAREF/Z1_MATGPE/Z1_CC/Z1_CLASSE/Z1_ITEM/Z1_SEQ/Z1_SERVICO/Z1_DESCRI"})
// Carrega o modelo de dados de um fonte MVC. No caso, carregamos deste fonte mesmo.
Local oModel := FWLoadModel('GENA097')
// Cria o modelo da View
Local oView := FWFormView():New()

// Definimos qual modelo será carregado nessa View
oView:SetModel(oModel)

// Adiciona os componentes visuais. Cada componente Está relacionado à um modelo de Estrutura de dados, definidos em ModelDef()
oView:AddField('VIEW_SZ1', oStruZZX, 'SZ1_FORM')
oStruZZX:SetProperty( "Z1_MATGPE", MVC_VIEW_INSERTLINE , .T. )
oStruZZX:SetProperty( "Z1_ITEM", MVC_VIEW_INSERTLINE , .T. )
oStruZZX:SetProperty( "Z1_VALOR", MVC_VIEW_INSERTLINE , .T. )

//oStruZZX:SetProperty( "ZZX_MSBLQL", MVC_VIEW_INSERTLINE , .T. )

// Agora vamos criar 'box' para suportar os componentes. Box é uma descrição genérica para Window, Panel, etc
oView:CreateHorizontalBox( 'CAB', 100 ) // ocupar 100% da tela
 
// Relacionamos o Box criado ao objeto View
oView:SetOwnerView('VIEW_SZ1' ,'CAB')

//Para mostrar os titulos dos grids                                          
oView:EnableTitleView('VIEW_SZ1')

Return oView


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
Local cPD       := SZ1->Z1_PD	
Local nOper     := 3
Local aAreaRGB  := RGB->(GetArea())

Private lMsErroAuto := .F.

ProcRegua(0)
IncProc()

IF !MsgYesNo("Confirma aprovação do lançamento?")
    Return nil
EndIf

IF SZ1->Z1_STATUS == "1"
    MsgStop("Movimentação já efetivada no modulo GPE!")
    Return nil
EndIf

ZZH->(DbSetOrder(1))
SRA->(DbSetOrder(1))
ZZH->(DbSeek( SZ1->Z1_FILIAL+SZ1->Z1_MAT ))

IF Empty(ZZH->ZZH_MATGPE) .OR. ZZH->ZZH_STATUS <> "1"
    MsgStop("Colaborador não enviado ao modulo GPE!")
    Return nil
EndIf

IF !SRA->(DbSeek( ZZH->ZZH_FILIAL+ZZH->ZZH_MATGPE ))
    MsgStop("Colaborador não enviado ao modulo GPE!")
    Return nil
EndIf

cMatGen := ZZH->ZZH_MATGPE

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³usa funcao do padrao para busca do periodo a ser encerrado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fGetPerAtual( @aPerAtual, , "00003", "AUT" )
cPeriodo := aPerAtual[1,5]+aPerAtual[1,4]

IF MESANO(SZ1->Z1_DATAREF) <> cPeriodo
    MsgStop("Data de referencia informada está divergente ao período atual ("+cPeriodo+") em aberto no modulo Gestão de Pessoas?")
    Return .F.
ENDIF

//Criando variaveis do cabecalho
aAdd( aCabAuto,{ 'RA_FILIAL',   SZ1->Z1_FILIAL          , nil })
aAdd( aCabAuto,{ 'RA_MAT',      ZZH->ZZH_MATGPE         , nil })
aAdd( aCabAuto,{ 'CROTEIRO',    "AUT"                   , nil })
aAdd( aCabAuto,{ 'CNUMPAGTO',   '01'                    , nil })
//aAdd( aCabAuto,{ 'CPERIODO' ,   Left(DtoS(DDataBase),6) , nil })
aAdd( aCabAuto,{ 'CPERIODO' ,   cPeriodo , nil })

//Criando variaveis dos itens
aadd(aLinha,{'RGB_SEMANA'   , '01'              , nil})
aadd(aLinha,{'RGB_PD'       , SZ1->Z1_PD        , nil})
aadd(aLinha,{'RGB_TIPO1'    , 'V'               , nil})
aadd(aLinha,{'RGB_TIPO2'    , 'G'               , nil})
aadd(aLinha,{'RGB_HORAS'    , SZ1->Z1_HORAS     , nil})
aadd(aLinha,{'RGB_VALOR'    , SZ1->Z1_VALOR     , nil})
aadd(aLinha,{'RGB_DTREF'    , SZ1->Z1_DATAREF   , nil})

cCC       := IIF( !Empty(SZ1->Z1_CC)       , SZ1->Z1_CC        , SRA->RA_CC    )
cItem     := IIF( !Empty(SZ1->Z1_ITEM)     , SZ1->Z1_ITEM      , SRA->RA_ITEM  )
cClass    := IIF( !Empty(SZ1->Z1_CLASSE)   , SZ1->Z1_CLASSE    , SRA->RA_CLVL  )

aadd(aLinha,{'RGB_CC'       , cCC , nil})
aadd(aLinha,{'RGB_ITEM'     , cItem , nil})
aadd(aLinha,{'RGB_CLVL'     , cClass , nil})
If !Empty(SRA->RA_CODFUNC)
    aadd(aLinha,{'RGB_CODFUN'   , SRA->RA_CODFUNC   , nil})
EndIF    
If !Empty(SRA->RA_DEPTO)
    aadd(aLinha,{'RGB_DEPTO'    , SRA->RA_DEPTO     , nil})
EndIf    
aadd(aLinha,{'RGB_PARCEL'   , 1                 , nil})
aadd(aLinha,{'RGB_SEQ'      , SZ1->Z1_SEQ       , nil})

//Atribuindo variavel para MsExecAuto
aadd(aItemAuto,aLinha)


SM0->(dbSetOrder(1))
SM0->(dbSeek(cEmpAux + SZ1->Z1_FILIAL,.T.)) //Posiciona Empresa

cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
cFilAnt := SM0->M0_CODFIL
OpenFile(cEmpAnt + cFilAnt)

RGB->(DbSetOrder(3))//RGB_FILIAL+RGB_PROCES+RGB_MAT+RGB_PERIOD+RGB_SEMANA+RGB_PD+RGB_SEQ
If RGB->(DbSeek( xFilial("RGB")+"00003"+cMatGen+cPeriodo ))
    nOper := 4
    IF !MsgYesNo("Foram identificados lançamentos para a matricula informada, deseja continuar e adiciobar os valores?")
        Return .F.
    ENDIF
EndIf

Restarea(aAreaRGB)

//Chama a rotina
MsExecAuto({|a, b, c, d| GPEA580(a,b,c,d)},nil, aCabAuto, aItemAuto,nOper)

SM0->(dbSetOrder(1))
SM0->(dbSeek(cEmpBkp + cFilBkp,.T.)) //Posiciona Empresa

cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
cFilAnt := SM0->M0_CODFIL
OpenFile(cEmpAnt + cFilAnt)

//Faz a validacao
If !lMsErroAuto
    RecLock("SZ1",.F.)
    SZ1->Z1_STATUS  := "1"
    MsUnLock()
    MsgInfo("Enviado ao GPE com sucesso! ")
Else
    MostraErro()
EndIf

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


User Function GENA097S(cCod,cMat,cVerba)

    Local aPerAtual	:= {}	
Local cSeq      := StrZero(0,TamSX3("RGB_SEQ")[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³usa funcao do padrao para busca do periodo a ser encerrado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fGetPerAtual( @aPerAtual, , "00003", "AUT" )
cPeriodo := aPerAtual[1,5]+aPerAtual[1,4]

RGB->(DbSetOrder(1))//RGB_FILIAL+RGB_MAT+RGB_PD+RGB_PERIOD+RGB_SEMANA+RGB_SEQ+RGB_CONVOC
RGB->(DbSeek( xFilial("RGB")+cMat+cVerba+cPeriodo))
While xFilial("RGB")+cMat+cVerba+cPeriodo == RGB->(RGB_FILIAL+RGB_MAT+RGB_PD+RGB_PERIOD)
    cSeq    := RGB->RGB_SEQ
    RGB->(DkSip())
EndDo

cSeq    := Soma1(cSeq)

IF Select("TMP_SEQ") > 0
    TMP_SEQ->(DbCloseArea())
ENDIF

BEGINSQL ALIAS "TMP_SEQ"
    SELECT MAX(Z1_SEQ) Z1_SEQ FROM %Table:SZ1% SZ1
    WHERE Z1_FILIAL = %xFilial:SZ1%
    AND Z1_MAT = %Exp:cCod%
    AND SZ1.Z1_STATUS <> '1'
    AND Z1_PD = %Exp:cVerba%
    AND SZ1.%NotDel%
ENDSQL
TMP_SEQ->(DbGoTop())

IF TMP_SEQ->Z1_SEQ >= cSeq
    cSeq := Soma1(TMP_SEQ->Z1_SEQ)
ENDIF

TMP_SEQ->(DbCloseArea())

Return cSeq