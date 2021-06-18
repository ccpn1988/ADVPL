//Bibliotecas
#Include 'Protheus.ch'
#Include 'FwMVCDef.ch'
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"
#include "Fileio.ch"  
#Include "Ap5Mail.ch"  

#DEFINE P_LOGOFIL 01
#DEFINE P_DESCFIL 02
#DEFINE P_EMPRESA 03
#DEFINE P_ENDEREC 04
#DEFINE P_CIDESTC 05
#DEFINE P_CNPJEMP 06
#DEFINE P_NRECIBO 07

#DEFINE P_FNOME 08
#DEFINE P_FENDE 09
#DEFINE P_FCIDA 10
#DEFINE P_FESTA 11
#DEFINE P_FIDCO 12
#DEFINE P_FCGC  13
#DEFINE P_FIDEN 14
#DEFINE P_FINSS 15
#DEFINE P_FCEP  16

#DEFINE P_FMSG      17
#DEFINE P_FVBRU     18
#DEFINE P_FVINSS    19
#DEFINE P_FVIRRF    20
#DEFINE P_FVACRE    21
#DEFINE P_FVDESC    22
#DEFINE P_FVLIQ     23
#DEFINE P_FBANTIR   24
#DEFINE P_FBIRRF    25
#DEFINE P_FBINSS    26
#DEFINE P_FDEDUC    27
#DEFINE P_FDTPGT    28
#DEFINE P_FBANCO    29
#DEFINE P_FAGENC    30
#DEFINE P_FCONTA    31
#DEFINE P_FCODPRO   32
#DEFINE P_FCODOBR   33
#DEFINE P_FAUTOR    34
#DEFINE P_FTPSERV   35
#DEFINE P_FMATERI   36
#DEFINE P_FCIDADE   37
#DEFINE P_FDESCDA   38

#DEFINE A_SIZE 40

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA101   บAutor  ณCleuto Lima         บ Data ณ  23/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcontrole de recibos                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA101()

Private oMark
//Criando o MarkBrow
oMark := FWMarkBrowse():New()
oMark:SetAlias('SZ1')

//Setando semแforo, descri็ใo e campo de mark
oMark:SetSemaphore(.T.)
oMark:SetDescription('Recibos de pagamento RPA')
oMark:SetFieldMark( 'Z1_OK' )
oMark:SetValid({|| u_GENA101V() })

//Setando Legenda
oMark:AddLegend( "!EMPTY(SZ1->Z1_DTEMAIL)", "GREEN","E-Mail enviado" )
oMark:AddLegend( "EMPTY(SZ1->Z1_DTEMAIL)", "RED","E-Mail nใo enviado" )

oMark:AddFilter("Pagamentos Confirmados", "Z1_STATUS=='2'", .T., .T.)
//oMark:AddFilter("DATA_AVISO",	"MBR_DTENAV = ''",.T.,.T.)

//Ativando a janela
oMark:Activate()

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA101   บAutor  ณCleuto Lima         บ Data ณ  23/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcontrole de recibos                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MenuDef()
Local aRotina := {}
//Cria็ใo das op็๕es
ADD OPTION aRotina TITLE 'Visualizar'           ACTION 'VIEWDEF.GENA101'      OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir Recibo'      ACTION 'u_GENA101I(.T.)'         OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Enviar'               ACTION 'u_GENA101E()'         OPERATION 2 ACCESS 0
//ADD OPTION aRotina TITLE 'Enviar Todos'         ACTION 'u_GENA101T()'         OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Legenda'              ACTION 'u_GENA101L()'         OPERATION 2 ACCESS 0

Return aRotina
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA101   บAutor  ณCleuto Lima         บ Data ณ  23/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcontrole de recibos                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ModelDef()
// Cria Estruturas para serem usadas no Modelo de Dados
Local oStruSZ1  := FWFormStruct(1,'SZ1')
Local oModel 

oModel := MPFormModel():New('MDFGENA101')

// Adiciona um Componente de Formulแrio ao modelo.
oModel:AddFields('SZ1_FORM',/*cOwner*/,oStruSZ1,/*blinePre*/,/*blinePos*/) 

// Descri็ใo do Modelo
oModel:SetDescription("Recibos de pagamento RPA") 
// Descri็ใo do Modelo
oModel:GetModel('SZ1_FORM'):SetDescription("Recibos de pagamento RPA")

Return oModel      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA101   บAutor  ณCleuto Lima         บ Data ณ  23/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcontrole de recibos                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ViewDef()

// Cria Estruturas para serem usadas na View
Local oStruSZ1  := FWFormStruct(2,'SZ1',{|cCampo| .T. })
// Carrega o modelo de dados de um fonte MVC. No caso, carregamos deste fonte mesmo.
Local oModel := FWLoadModel('GENA101')
// Cria o modelo da View
Local oView := FWFormView():New()

// Definimos qual modelo serแ carregado nessa View
oView:SetModel(oModel)

// Adiciona os componentes visuais. Cada componente Estแ relacionado เ um modelo de Estrutura de dados, definidos em ModelDef()
oView:AddField('VIEW_SZ1', oStruSZ1, 'SZ1_FORM')

oView:CreateHorizontalBox( 'CAB', 100 ) // ocupar 100% da tela

// Relacionamos o Box criado ao objeto View
oView:SetOwnerView('VIEW_SZ1' ,'CAB')

//Para mostrar os titulos dos grids                                          
oView:EnableTitleView('VIEW_SZ1')

Return oView
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA101   บAutor  ณCleuto Lima         บ Data ณ  23/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcontrole de recibos                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GENA101T()

Local aArea    := GetArea()
Local cMarca   := oMark:Mark()

SZ1->(DbGoTop())
While !SZ1->(EoF())
    If oMark:IsMark(cMarca)
        RecLock('SZ1', .F.)
        SZ1->Z1_DTEMAIL := DDATABASE
        SZ1->Z1_HREMAIL := TIME()
        SZ1->(MsUnlock())
    EndIf
    SZ1->(DbSkip())
EndDo

Restarea(aArea)

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA101   บAutor  ณCleuto Lima         บ Data ณ  23/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcontrole de recibos                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GENA101E()

Processa({|| ProcPDF()},"Processando..","Aguarde.. gerando recibos!",.F.)
Processa({|| EnvMail()},"Processando..","Aguarde.. enviado recibos!",.F.)

Return nil

User Function GENA101V()

Local cCodVb    := ""
Local lRet      := .F.

cPeriodo  := Left(DtoS(SZ1->Z1_DATA),6)

IF SZ1->Z1_FILIAL = '7001'
    cCodVb := "026"
ELSE    
    cCodVb := "257"
ENDIF

IF SZ1->Z1_INSS == "1"
    SRA->(DBOrderNickname("FORNECEDOR"))
    SRA->( DbSeek( SZ1->Z1_FILIAL+SZ1->Z1_FORNECE ) )
    cMat := SRA->RA_MAT
    nValBru := Posicione("SRC",5,SZ1->Z1_FILIAL+cCodVb+"00003"+cPeriodo+"AUT"+cMat,"RC_VALOR")//RC_FILIAL+RC_PD+RC_PROCES+RC_PERIODO+RC_ROTEIR+RC_MAT
    IF nValBru == 0
        nValBru := Posicione("SRD",5,SZ1->Z1_FILIAL+cMat+"00003AUT"+cPeriodo+"01"+cCodVb,"RD_VALOR")//RD_FILIAL+RD_MAT+RD_PROCES+RD_ROTEIR+RD_PERIODO+RD_SEMANA+RD_PD
    ENDIF
ELSE
    nValBru := Posicione("SE2",1,SZ1->Z1_FILIAL+"RPA"+SZ1->Z1_IDSEQ+"  RPA"+SZ1->Z1_FORNECE+SZ1->Z1_LOJA,"E2_VALOR")//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
EndIF  

lRet    := nValBru > 0

IF !lRet
    MsgStop("RPA ainda nใo foi paga!")
ENDIF

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA101   บAutor  ณCleuto Lima         บ Data ณ  23/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcontrole de recibos                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcPDF()

Local nValBru   := 0
Local cPeriodo  := ""
Local cMat      := ""
Local cFile		:= ""
Local cDir		:= ""
Local aAuxFiles := {}
Local aArea    := GetArea()
Local cMarca   := oMark:Mark()
Local nQtdTenta:= 0
Local cCodVb    := ""

SZ1->(DbGoTop())

While SZ1->(!EOF())

	If !oMark:IsMark(cMarca)
		SZ1->(DbSkip())
		Loop
	EndIf

    cPeriodo  := Left(DtoS(SZ1->Z1_DATA),6)
    cMat      := ""
    cFile	  := "RECIBO_"+SZ1->Z1_IDSEQ
    cDir	  := "\workflow\Anexos\RPA\"+AllTrim(SZ1->Z1_FILIAL)+"\"

    WFForceDir(cDir)

    IF SZ1->Z1_STATUS <> "2"        
        MsgStop("Situa็ใo do RPA nใo permite impressใo do recibo!")
        RecLock('SZ1', .F.)
        SZ1->Z1_OK  := " "
        SZ1->(MsUnlock())
        SZ1->(DbSkip())
        Loop
    ENDIF

    IF SZ1->Z1_FILIAL = '7001'
        cCodVb := "026"
    ELSE    
        cCodVb := "257"
    ENDIF

    IF SZ1->Z1_INSS == "1"
        SRA->(DBOrderNickname("FORNECEDOR"))
        SRA->( DbSeek( SZ1->Z1_FILIAL+SZ1->Z1_FORNECE ) )
        cMat := SRA->RA_MAT
        nValBru := Posicione("SRC",5,SZ1->Z1_FILIAL+cCodVb+"00003"+cPeriodo+"AUT"+cMat,"RC_VALOR")//RC_FILIAL+RC_PD+RC_PROCES+RC_PERIODO+RC_ROTEIR+RC_MAT
        IF nValBru == 0
            nValBru := Posicione("SRD",5,SZ1->Z1_FILIAL+cMat+"00003AUT"+cPeriodo+"01"+cCodVb,"RD_VALOR")//RD_FILIAL+RD_MAT+RD_PROCES+RD_ROTEIR+RD_PERIODO+RD_SEMANA+RD_PD
        ENDIF
    ELSE
        nValBru := Posicione("SE2",1,SZ1->Z1_FILIAL+"RPA"+SZ1->Z1_IDSEQ+"  RPA"+SZ1->Z1_FORNECE+SZ1->Z1_LOJA,"E2_VALOR")//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
    EndIF    

    IF nValBru == 0
        MsgStop("RPA ainda nใo foi paga!")
        RecLock('SZ1', .F.)
        SZ1->Z1_OK  := " "
        SZ1->(MsUnlock())
        SZ1->(DbSkip())
        Loop
    ENDIF

    FErase(cDir+cFile+".pdf")
    U_GENA101R(.F.,cDir,cFile)
    nQtdTenta:=0
    aAuxFiles := Directory(cDir+cFile+".pdf")
    while !File(cDir+cFile+".pdf")  .OR. Len(aAuxFiles) == 0 .OR. aAuxFiles[1][2] == 0
        aAuxFiles := Directory(cDir+cFile+".pdf")
        nQtdTenta++
        Sleep(5000)
        IF nQtdTenta > 5
            Exit
        EndIF
    end

    aAuxFiles := Directory(cDir+cFile+".pdf")
    If !File(cDir+cFile+".pdf")  .OR. Len(aAuxFiles) == 0 .OR. aAuxFiles[1][2] == 0
        MsgStop("Falha ao gerar PDF para o RPA numero "+SZ1->Z1_IDSEQ+"-"+alltrim(SZ1->Z1_NOME)+"!")
        RecLock('SZ1', .F.)
        SZ1->Z1_OK  := " "
        SZ1->(MsUnlock())
        SZ1->(DbSkip())
        Loop        
    EndIf

    SZ1->(DbSkip())
EndDo

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA101   บAutor  ณCleuto Lima         บ Data ณ  23/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcontrole de recibos                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA101L()

Local aCores:= {}

//ZB_SITUACA 1=Incluida;2=Aprovada;3=Finalizada
aAdd(aCores,{"BR_VERMELHO", "E-Mail nใo enviado"})
aAdd(aCores,{"BR_VERDE"   , "E-Mail enviado"})

BrwLegenda("Pre autoriza็ใo","Legenda",aCores)

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA101   บAutor  ณCleuto Lima         บ Data ณ  23/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcontrole de recibos                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GENA101I(lView)

Local nValBru   := 0
Local cPeriodo  := Left(DtoS(SZ1->Z1_DATA),6)
Local cMat      := ""
Local cCodVb    := ""

IF SZ1->Z1_STATUS <> "2"
    MsgStop("Situa็ใo do RPA nใo permite impressใo do recibo!")
    Return nil
ENDIF

IF SZ1->Z1_FILIAL = '7001'
    cCodVb := "026"
ELSE    
    cCodVb := "257"
ENDIF

IF SZ1->Z1_INSS == "1"
    SRA->(DBOrderNickname("FORNECEDOR"))
    SRA->( DbSeek( SZ1->Z1_FILIAL+SZ1->Z1_FORNECE ) )
    cMat := SRA->RA_MAT
    nValBru := Posicione("SRC",5,SZ1->Z1_FILIAL+cCodVb+"00003"+cPeriodo+"AUT"+cMat,"RC_VALOR")//RC_FILIAL+RC_PD+RC_PROCES+RC_PERIODO+RC_ROTEIR+RC_MAT
    IF nValBru == 0
        nValBru := Posicione("SRD",5,SZ1->Z1_FILIAL+cMat+"00003AUT"+cPeriodo+"01"+cCodVb,"RD_VALOR")//RD_FILIAL+RD_MAT+RD_PROCES+RD_ROTEIR+RD_PERIODO+RD_SEMANA+RD_PD
    ENDIF
ELSE
   nValBru := Posicione("SE2",1,SZ1->Z1_FILIAL+"RPA"+SZ1->Z1_IDSEQ+"  RPA"+SZ1->Z1_FORNECE+SZ1->Z1_LOJA,"E2_VALOR")//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
EndIF    

IF nValBru == 0
    MsgStop("RPA ainda nใo foi paga!")
    Return nil
ENDIF

U_GENA101R(lView)

Return nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA101   บAutor  ณCleuto Lima         บ Data ณ  23/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcontrole de recibos                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GENA101R(lView,cCaminho,cFilePrint)

Private aDados      := Array(A_SIZE)
Private nPagAtu		:= 0

//ฺฤฤฤฤฤฤฤฟ
//ณMargensณ
//ภฤฤฤฤฤฤฤู
Private nMgPgTop	:= 90
Private nMgPgLef	:= 15
Private nVertSize	:= 0
Private nHorzSize	:= 0

Default cCaminho	:= "c:\temp\"
Default cFilePrint	:= CriaTrab(nil,.F.)
Default lView		:= .T.

Private oArial08	    := TFont():New( "Arial",,08,,.F.,,,,,.F.)
Private oArial08T	    := TFont():New( "Arial",,08,,.T.,,,,,.F.)
Private oArial10T	    := TFont():New( "Arial",,10,,.T.,,,,,.F.)
Private oArial10	    := TFont():New( "Arial",,10,,.F.,,,,,.F.)
Private oArial12	    := TFont():New( "Arial",,12,,.F.,,,,,.F.)
Private oArial14	    := TFont():New( "Arial",,14,,.T.,,,,,.F.)
Private oArial16	    := TFont():New( "Arial",,16,,.F.,,,,,.F.)

WFForceDir(cCaminho)

lAdjustToLegacy := .F. //mantem legado de resolu็ใo com a TMSPrinter
oprn 			:= FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, cCaminho, .T.,,,,.F.)
oprn:SetPortrait()

oprn:StartPage()

// ----------------------------------------------
// Define para salvar o PDF
// ----------------------------------------------
oprn:SetPortrait()
oprn:nDevice 		:= IMP_PDF
oprn:lServer 		:= .f.                          
oprn:lViewPDF		:= lView 
oprn:cPathPDF 		:= cCaminho

nVertSize	:= (oprn:NPAGEHEIGHT/oprn:NFACTORHOR)-nMgPgTop
nHorzSize	:= (oprn:NPAGEWIDTH/oprn:NFACTORHOR)-nMgPgLef

xRetDados()

ImpCabec()

ImpCorp()

oprn:Print()  

//FClose(oprn:NHANDLE)
FT_FUSE()
FreeObj(oprn)	
oprn := Nil

Return nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA101   บAutor  ณCleuto Lima         บ Data ณ  23/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcontrole de recibos                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpCorp()

Local nLinAux   := nPagAtu 
Local nCol1     := nMgPgLef
Local nCol2     := nMgPgLef+70
Local nCol2B    := nMgPgLef+100
Local nCol3     := nHorzSize*0.60
Local nCol4     := nHorzSize*0.70
Local nCol4B    := nHorzSize-nCol4
Local oBrush 	:= TBrush():New( , CLR_BLACK )
Local aCord1    := {}

nLinAux += 20

oPrn:SayAlign ( nLinAux+10	, nCol1 ,"NOME:",oArial08T ,50,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+20	, nCol1 ,"ENDEREวO:",oArial08T ,50,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+30	, nCol1 ,"CIDADE:",oArial08T ,50,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+40	, nCol1 ,"ESTADO:",oArial08T ,50,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+40	, nCol1+100 ,"CEP:",oArial08T ,50,30, /*RGB(107,213,201)*/ , 0, 1)

oPrn:SayAlign ( nLinAux+10	, nCol3 ,"ID.COLABORADOR:",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+20	, nCol3 ,"CPF / CNPJ:",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+30	, nCol3 ,"IDENTIDADE:",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+40	, nCol3 ,"INSCRIวรO ISS:",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)

oPrn:SayAlign ( nLinAux+10	, nCol2 ,ALLTRIM(aDados[P_FNOME]),oArial08 ,200,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+20	, nCol2 ,ALLTRIM(aDados[P_FENDE]),oArial08 ,200,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+30	, nCol2 ,ALLTRIM(aDados[P_FCIDA]),oArial08 ,200,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+40	, nCol2 ,ALLTRIM(aDados[P_FESTA]),oArial08 ,200,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+40	, nCol2+65 ,ALLTRIM(aDados[P_FCEP]),oArial08 ,200,30, /*RGB(107,213,201)*/ , 0, 1)

oPrn:SayAlign ( nLinAux+10	, nCol4 ,ALLTRIM(aDados[P_FIDCO]),oArial08 ,nHorzSize-nCol4,30, /*RGB(107,213,201)*/ , 1, 1)
oPrn:SayAlign ( nLinAux+20	, nCol4 ,ALLTRIM(aDados[P_FCGC]) ,oArial08 ,nHorzSize-nCol4,30, /*RGB(107,213,201)*/ , 1, 1)
oPrn:SayAlign ( nLinAux+30	, nCol4 ,ALLTRIM(aDados[P_FIDEN]),oArial08 ,nHorzSize-nCol4,30, /*RGB(107,213,201)*/ , 1, 1)
oPrn:SayAlign ( nLinAux+40	, nCol4 ,ALLTRIM(aDados[P_FINSS]),oArial08 ,nHorzSize-nCol4,30, /*RGB(107,213,201)*/ , 1, 1)

nLinAux += 55
aCord1 := {nLinAux, nMgPgLef, nLinAux+5, nHorzSize }
oPrn:Fillrect( aCord1, oBrush, "-9")

nLinAux+=10
oPrn:SayAlign ( nLinAux	, nCol1 ,aDados[P_FMSG],oArial08 ,nHorzSize-nMgPgLef,nLinAux+60, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=60

aCord1 := {nLinAux, nMgPgLef, nLinAux+5, nHorzSize }
oPrn:Fillrect( aCord1, oBrush, "-9")
oPrn:SayAlign ( nLinAux+03	, nCol1 ,"VALORES DISCRIMINADOS:",oArial08T ,200,15, /*RGB(107,213,201)*/ , 0, 1)
nLinAux += 15
aCord1 := {nLinAux, nMgPgLef, nLinAux+5, nHorzSize }
oPrn:Fillrect( aCord1, oBrush, "-9")

nLinAux += 10

oPrn:SayAlign ( nLinAux+00	, nCol1 ,"VALOR BRUTO :",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
IF SZ1->Z1_INSS == "1"
    oPrn:SayAlign ( nLinAux+10	, nCol1 ,"I.N.S.S :",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
ENDIF    
oPrn:SayAlign ( nLinAux+20	, nCol1 ,"I.R.R.F :",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+30	, nCol1 ,"VALOR ACRESCIMO :",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+40	, nCol1 ,"VALOR DESCONTO :",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+50	, nCol1 ,"VALOR LIQUIDO :",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)

oPrn:SayAlign ( nLinAux+20	, nCol3 ,"BASE ANTERIOR I.R.R.F.:",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+30	, nCol3 ,"BASE I.R.R.F. :",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
IF SZ1->Z1_INSS == "1"
    oPrn:SayAlign ( nLinAux+40	, nCol3 ,"BASE I.N.S.S. :",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
ENDIF    
oPrn:SayAlign ( nLinAux+50	, nCol3 ,"DEDUวรO DEPENDENTES",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)

oPrn:SayAlign ( nLinAux+00	, nCol2B ,Transform(aDados[P_FVBRU],"@E 999,999,999.99"),oArial08 ,60,30, /*RGB(107,213,201)*/ , 1, 1)
IF SZ1->Z1_INSS == "1"
    oPrn:SayAlign ( nLinAux+10	, nCol2B ,Transform(aDados[P_FVINSS],"@E 999,999,999.99"),oArial08 ,60,30, /*RGB(107,213,201)*/ , 1, 1)
ENDIF    
oPrn:SayAlign ( nLinAux+20	, nCol2B ,Transform(aDados[P_FVIRRF],"@E 999,999,999.99"),oArial08 ,60,30, /*RGB(107,213,201)*/ , 1, 1)
oPrn:SayAlign ( nLinAux+30	, nCol2B ,Transform(aDados[P_FVACRE],"@E 999,999,999.99"),oArial08 ,60,30, /*RGB(107,213,201)*/ , 1, 1)
oPrn:SayAlign ( nLinAux+40	, nCol2B ,Transform(aDados[P_FVDESC],"@E 999,999,999.99"),oArial08 ,60,30, /*RGB(107,213,201)*/ , 1, 1)
oPrn:SayAlign ( nLinAux+50	, nCol2B ,Transform(aDados[P_FVLIQ],"@E 999,999,999.99"),oArial08 ,60,30, /*RGB(107,213,201)*/ , 1, 1)

oPrn:SayAlign ( nLinAux+20	, nCol4 ,Transform(aDados[P_FBANTIR],"@E 999,999,999.99"),oArial08 ,nHorzSize-nCol4,30, /*RGB(107,213,201)*/ , 1, 1)
oPrn:SayAlign ( nLinAux+30	, nCol4 ,Transform(aDados[P_FBIRRF],"@E 999,999,999.99"),oArial08 ,nHorzSize-nCol4,30, /*RGB(107,213,201)*/ , 1, 1)
IF SZ1->Z1_INSS == "1"
    oPrn:SayAlign ( nLinAux+40	, nCol4 ,Transform(aDados[P_FBINSS],"@E 999,999,999.99"),oArial08 ,nHorzSize-nCol4,30, /*RGB(107,213,201)*/ , 1, 1)
ENDIF    
oPrn:SayAlign ( nLinAux+50	, nCol4 ,Transform(aDados[P_FDEDUC],"@E 999,999,999.99"),oArial08 ,nHorzSize-nCol4,30, /*RGB(107,213,201)*/ , 1, 1)

nLinAux += 65
aCord1 := {nLinAux, nMgPgLef, nLinAux+5, nHorzSize }
oPrn:Fillrect( aCord1, oBrush, "-9")

nLinAux += 10
oPrn:SayAlign ( nLinAux	, nCol1 , AllTrim(aDados[P_FCIDADE])+", "+AllTrim(DtoC(aDados[P_FDTPGT])) ,oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)

nLinAux     += 35
/* calculo para centralizar a linha */
nColAux     := (nHorzSize)*0.25
nColBAux    := (nHorzSize)*0.75
/* -------------------------------- */
aCord1 := {nLinAux, nColBAux , nLinAux+5, nColAux }
oPrn:Fillrect( aCord1, oBrush, "-9")

nLinAux += 10
oPrn:SayAlign ( nLinAux	, nColAux , "ASSINATURA: " ,oArial08T ,nHorzSize,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+10	, nColAux , "CPF / CNPJ: " ,oArial08T ,nHorzSize,30, /*RGB(107,213,201)*/ , 0, 1)

oPrn:SayAlign ( nLinAux	, nColAux+60 , aDados[P_FNOME] ,oArial08 ,nHorzSize,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+10	, nColAux+60 , aDados[P_FCGC] ,oArial08 ,nHorzSize,30, /*RGB(107,213,201)*/ , 0, 1)
nLinAux += 25

oPrn:SayAlign ( nLinAux	, nCol1 , "O deposito bancแrio na conta corrente de minha titularidade ou indicada formalmente por mim, confere plena quita็ใo do pagamento com a dispensa de assinatura deste recibo." ,oArial08 ,nHorzSize-nMgPgLef,nLinAux+60, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=30

oPrn:SayAlign ( nLinAux+00	, nCol1 ,"Valor Depositado",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+00	, nCol1+80 ,"Banco",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+10	, nCol1+80 ,"Agencia",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+20	, nCol1+80 ,"Conta",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)

oPrn:SayAlign ( nLinAux+00	, nCol1+120 ,": "+aDados[P_FBANCO],oArial08 ,nHorzSize,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+10	, nCol1+120 ,": "+aDados[P_FAGENC],oArial08 ,nHorzSize,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+20	, nCol1+120 ,": "+aDados[P_FCONTA] ,oArial08 ,nHorzSize,30, /*RGB(107,213,201)*/ , 0, 1)

nLinAux+= 30

aCord1 := {nLinAux, nMgPgLef, nLinAux+5, nHorzSize }
oPrn:Fillrect( aCord1, oBrush, "-9")
IF SZ1->Z1_INSS == "1"
    oPrn:SayAlign ( nLinAux+03	, nCol1 ,"DESCRIวรO DOS SERVIวOS",oArial08T ,200,15, /*RGB(107,213,201)*/ , 0, 1)
ELSE    
    oPrn:SayAlign ( nLinAux+03	, nCol1 ,"DESCRIวรO DOS DIREITOS AUTORAIS",oArial08T ,200,15, /*RGB(107,213,201)*/ , 0, 1)
ENDIF
nLinAux += 15
aCord1 := {nLinAux, nMgPgLef, nLinAux+5, nHorzSize }
oPrn:Fillrect( aCord1, oBrush, "-9")
nLinAux += 15

oPrn:SayAlign ( nLinAux+00	, nCol1 ,"COD. PRODUวรO",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+10	, nCol1 ,"COD. OBRA",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+20	, nCol1 ,"AUTOR / TITULO / ED",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
IF SZ1->Z1_INSS == "1"
    oPrn:SayAlign ( nLinAux+30	, nCol1 ,"TIPO DE SERVIวO",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
ELSE
    oPrn:SayAlign ( nLinAux+30	, nCol1 ,"DIREITOS AUTORAIS",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)    
ENDIF    
oPrn:SayAlign ( nLinAux+40	, nCol1 ,"DESCRIวรO DO MATERIAL",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+50	, nCol1 ,"VALOR BRUTO",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)

IF SZ1->Z1_INSS == "1"
    oPrn:SayAlign ( nLinAux+50	, nCol1+200 ,"VALOR INSS",oArial08T ,100,30, /*RGB(107,213,201)*/ , 0, 1)
ENDIF

nCol2B+=10
oPrn:SayAlign ( nLinAux+00	, nCol2B ,aDados[P_FCODPRO],oArial08 ,nHorzSize,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+10	, nCol2B ,aDados[P_FCODOBR],oArial08 ,nHorzSize,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+20	, nCol2B ,aDados[P_FAUTOR],oArial08 ,nHorzSize,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+30	, nCol2B ,aDados[P_FTPSERV],oArial08 ,nHorzSize,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+40	, nCol2B ,aDados[P_FMATERI],oArial08 ,nHorzSize,30, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux+50	, nCol2B ,AllTrim(Transform(aDados[P_FVBRU],"@E 999,999,999.99")),oArial08 ,200,30, /*RGB(107,213,201)*/ , 0, 1)
IF SZ1->Z1_INSS == "1"
    oPrn:SayAlign ( nLinAux+50	, nCol2B+180 ,Transform(aDados[P_FVINSS],"@E 999,999,999.99"),oArial08 ,200,30, /*RGB(107,213,201)*/ , 0, 1)
ENDIF    

nLinAux+=65

oPrn:SayAlign ( nLinAux	, nCol1 ,Replicate("__ ",100),oArial08T ,nHorzSize-nMgPgLef,10, /*RGB(107,213,201)*/ , 0, 1)

nLinAux := (oprn:NPAGEHEIGHT/oprn:NFACTORHOR)
nLinAux+=40

aCord1 := {nLinAux, nMgPgLef, nLinAux+5, nHorzSize }
oPrn:Fillrect( aCord1, oBrush, "-9")

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGGDIRFPF  บAutor  ณMicrosiga           บ Data ณ  02/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpCabec()

Local nLinAux	:= nMgPgTop
Local cLogo     := "GEN.png"
Local cLogoFil  := aDados[P_LOGOFIL]
//Local oBrush 	:= TBrush():New( , Rgb(227,227,227) )
Local oBrush 	:= TBrush():New( , CLR_BLACK )
Local aCord1    := {nLinAux-5, nMgPgLef, nLinAux, nHorzSize }
Local aCord2    := {nLinAux+20, nMgPgLef, nLinAux+25, nHorzSize }
Local aCord3    := {10, 75, 80, 80 }

IF !File("c:\temp\"+cLogo)
	WFForceDir("c:\temp\")
	__CopyFile("\logos recibo\"+cLogo,"c:\temp\"+cLogo)
EndIF

IF !File("c:\temp\"+aDados[P_LOGOFIL])
	WFForceDir("c:\temp\")
	__CopyFile("\logos recibo\"+aDados[P_LOGOFIL],"c:\temp\"+aDados[P_LOGOFIL])
EndIF

oPrn:SayBitmap(10,nMgPgLef, "\logos recibo\"+cLogo,70,70, )
oPrn:SayBitmap(10,80, "\logos recibo\"+aDados[P_LOGOFIL],,70, )

//FWMsPrinter(): SayAlign ( < nRow>, < nCol>, < cText>, [ oFont], [ nWidth], [ nHeigth], [ nClrText], [ nAlignHorz], [ nAlignVert ] ) -->

oPrn:SayAlign ( nLinAux-30	, 00 ,aDados[P_DESCFIL],oArial16 ,nHorzSize,30, /*RGB(107,213,201)*/ , 1, 1)
oPrn:SayAlign ( nLinAux	, 00 ,"RECIBO",oArial16 ,nHorzSize,30, /*RGB(107,213,201)*/ , 2, 1)
oPrn:Fillrect( aCord1, oBrush, "-9")
oPrn:Fillrect( aCord2, oBrush, "-9")
oPrn:Fillrect( aCord3, oBrush, "-9")

nLinAux += 35

IF SZ1->Z1_INSS == "1"
    oPrn:SayAlign ( nLinAux+00	, 00 ,"RECIBO",oArial12 ,nHorzSize,30, /*RGB(107,213,201)*/ , 2, 1)
ELSE    
    oPrn:SayAlign ( nLinAux+00	, 00 ,"RECIBO DE DIREITOS AUTORAIS",oArial12 ,nHorzSize,30, /*RGB(107,213,201)*/ , 2, 1)
ENDIF    
oPrn:SayAlign ( nLinAux+00	, 00 ,"Nr. "+aDados[P_NRECIBO],oArial12 ,nHorzSize,30, /*RGB(107,213,201)*/ , 1, 1)

nLinAux += 10

oPrn:SayAlign ( nLinAux+10	, 00 ,aDados[P_EMPRESA],oArial10 ,nHorzSize,30, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+20	, 00 ,aDados[P_ENDEREC],oArial10 ,nHorzSize,30, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+30	, 00 ,aDados[P_CIDESTC],oArial10 ,nHorzSize,30, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+40	, 00 ,aDados[P_CNPJEMP],oArial10 ,nHorzSize,30, /*RGB(107,213,201)*/ , 2, 1)

nLinAux += 40

nPagAtu := nLinAux

Return nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA101   บAutor  ณCleuto Lima         บ Data ณ  23/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcontrole de recibos                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xRetDados()

//Local aEmpAux   := FWLoadSM0()
//Local nPosEmp   := aScan(aEmpAux,{|x| AllTrim(x[2]) == ALLTRIM(SZ1->Z1_FILIAL) }) 
Local aAreaSM0  := SM0->(GetArea())
Local cDescFil  := Posicione("SM0",1,cEmpAnt+SZ1->Z1_FILIAL,"M0_FILIAL")//AllTrim(aEmpAux[ ][7])
Local cMat      := ""
Local cPeriodo  := Left(DtoS(SZ1->Z1_DATA),6)
Local nPercVerb := 0
Local nValBru   := 0
Local lSRC      := .T.
Local nValDep   := GetMv("MV_TMSVDEP",.f.,0)
Local cCodVb    := ""

aDados[P_LOGOFIL] := ALLTRIM(SZ1->Z1_FILIAL)+".jpg"

If "/" $ cDescFil
    cDescFil := Left(cDescFil, At("/",cDescFil)-1 )
    aDados[P_DESCFIL] := cDescFil
Else
    aDados[P_DESCFIL] := cDescFil
EndIF

aDados[P_EMPRESA] := ALLTRIM(SM0->M0_NOMECOM)//AllTrim(aEmpAux[nPosEmp][17])
aDados[P_ENDEREC] := ALLTRIM(SM0->M0_ENDCOB)+" - "+ALLTRIM(SM0->M0_COMPCOB)+" - "+ALLTRIM(SM0->M0_BAIRCOB)
aDados[P_CIDESTC] := ALLTRIM(SM0->M0_CIDCOB)+" - "+ALLTRIM(SM0->M0_ESTCOB)+" - "+Transform(ALLTRIM(SM0->M0_CEPCOB),"@R 99999-999")
aDados[P_CNPJEMP] := Transform(ALLTRIM(SM0->M0_CGC),"@R 99.999.999/9999-99")
aDados[P_NRECIBO] := cValToChar(val(SZ1->Z1_IDSEQ))+" / "+cValToChar(Year(SZ1->Z1_DATA))

aDados[P_FNOME] := AllTrim(Posicione("SA2",1,xFilial("SA2")+SZ1->Z1_FORNECE+SZ1->Z1_LOJA,"A2_NOME"))
SRA->(DBOrderNickname("FORNECEDOR"))
SRA->( DbSeek( SZ1->Z1_FILIAL+SZ1->Z1_FORNECE ) )
cMat := SRA->RA_MAT

aDados[P_FENDE] := ALLTRIM(SA2->A2_END)+" "+ALLTRIM(SA2->A2_COMPLEM)
aDados[P_FCIDA] := CAPITAL(ALLTRIM(SA2->A2_MUN))
aDados[P_FESTA] := SA2->A2_EST
aDados[P_FIDCO] := SA2->A2_COD
aDados[P_FCGC]  := IIF( SA2->A2_TIPO == "F" ,  Transform(ALLTRIM(SA2->A2_CGC),"@R 999.999.999-99") , Transform(ALLTRIM(SA2->A2_CGC),"@R 99.999.999/9999-99") )
aDados[P_FIDEN] := ALLTRIM(SA2->A2_XRG)
aDados[P_FINSS] := ALLTRIM(SA2->A2_XPIS)
aDados[P_FCEP]  := Transform(ALLTRIM(SA2->A2_CEP),"@R 99999-999")

aDados[P_FDTPGT]      := SZ1->Z1_DATA
aDados[P_FBANCO]      := SA2->A2_BANCO+" - "+alltrim(Posicione("SX5",1,xFilial("SX5")+"K6"+SA2->A2_BANCO,"X5_DESCRI"))
aDados[P_FAGENC]      := ALLTRIM(SA2->A2_AGENCIA)+" - "+ALLTRIM(SA2->A2_XDIGAG)
aDados[P_FCONTA]      := ALLTRIM(SA2->A2_NUMCON)+" - "+ALLTRIM(SA2->A2_XDIGCON)
aDados[P_FCODPRO]     := ALLTRIM(SZ1->Z1_CLASSE)
aDados[P_FCODOBR]     := ALLTRIM(SZ1->Z1_CLASSE)
aDados[P_FAUTOR]      := ALLTRIM(Posicione("ZZL",1,xFilial("ZZL")+ALLTRIM(SZ1->Z1_CLASSE),"ZZL_AUTOR"))+" / "+ALLTRIM(SZ1->Z1_TITULO)
aDados[P_FTPSERV]     := ALLTRIM(SZ1->Z1_DESCRI)
aDados[P_FMATERI]     := ALLTRIM(SZ1->Z1_OBS)
aDados[P_FCIDADE]     := ALLTRIM(SM0->M0_CIDCOB)

/* calculo dos valores */

aDados[P_FVBRU]       := 0
aDados[P_FVINSS]      := 0
aDados[P_FVIRRF]      := 0
aDados[P_FVACRE]      := 0
aDados[P_FVDESC]      := 0
aDados[P_FVLIQ]       := 0
aDados[P_FBANTIR]     := 0
aDados[P_FBIRRF]      := 0
aDados[P_FBINSS]      := 0
aDados[P_FDEDUC]      := 0

IF SZ1->Z1_INSS == "1"

    //cMat := "601937" // APENAS TESTE REMOVER
    //cPeriodo := "201912" // APENAS TESTE REMOVER
    IF SZ1->Z1_FILIAL = '7001'
        cCodVb := "026"
    ELSE    
        cCodVb := "257"
    ENDIF

    nValBru := Posicione("SRC",5,SZ1->Z1_FILIAL+cCodVb+"00003"+cPeriodo+"AUT"+cMat,"RC_VALOR")//RC_FILIAL+RC_PD+RC_PROCES+RC_PERIODO+RC_ROTEIR+RC_MAT
    IF nValBru == 0
        lSRC    := .F.
        nValBru := Posicione("SRD",5,SZ1->Z1_FILIAL+cMat+"00003AUT"+cPeriodo+"01"+cCodVb,"RD_VALOR")//RD_FILIAL+RD_MAT+RD_PROCES+RD_ROTEIR+RD_PERIODO+RD_SEMANA+RD_PD
    ENDIF

    nPercVerb := (SZ1->Z1_HORAS*SZ1->Z1_VALOR)/nValBru

    If Select("TMP_VALOR") >0 
        TMP_VALOR->(DbCloseArea())
    EndIf

    If lSRC
        BeginSql Alias "TMP_VALOR"
            SELECT RV_DESC DESCRI, RC_PD VERBA, RC_VALOR VALOR,RC_FILIAL FILIAL FROM %Table:SRC% SRC
            JOIN %Table:SRV% SRV
            ON RV_FILIAL = SUBSTR(RC_FILIAL,1,2)||'  '
            AND RV_COD = RC_PD
            AND SRV.%NotDel%
            WHERE RC_FILIAL = %Exp:SZ1->Z1_FILIAL%
            AND RC_MAT = %Exp:cMat%
            AND SRC.%NotDel%
            AND RC_PERIODO = %Exp:cPeriodo%
            AND RC_PD IN ('026','257','500','505','B05','B16','Z02')    
        EndSql
    Else
        BeginSql Alias "TMP_VALOR"
            SELECT RV_DESC DESCRI, RD_PD VERBA, RD_VALOR VALOR,RD_FILIAL FILIAL FROM %Table:SRD% SRD
            JOIN %Table:SRV% SRV
            ON RV_FILIAL = SUBSTR(RD_FILIAL,1,2)||'  '
            AND RV_COD = RD_PD
            AND SRV.%NotDel%
            WHERE RD_FILIAL = %Exp:SZ1->Z1_FILIAL%
            AND RD_MAT = %Exp:cMat%
            AND SRD.RD_DATARQ = %Exp:cPeriodo%
            AND SRD.%NotDel%
        EndSql
    EndIf

    TMP_VALOR->(DbGoTop())
    While TMP_VALOR->(!EOF()) 
        Do Case
            Case TMP_VALOR->VERBA == "257" .AND. TMP_VALOR->FILIAL <> '7001'
                aDados[P_FVBRU]       := Round(TMP_VALOR->VALOR*nPercVerb,TamSx3("RC_VALOR")[2])
            Case TMP_VALOR->VERBA == "026" .AND. TMP_VALOR->FILIAL == '7001'
                aDados[P_FVBRU]       := Round(TMP_VALOR->VALOR*nPercVerb,TamSx3("RC_VALOR")[2])                
            Case TMP_VALOR->VERBA == "500"                
                aDados[P_FVINSS]      := Round(TMP_VALOR->VALOR*nPercVerb,TamSx3("RC_VALOR")[2])
            Case TMP_VALOR->VERBA == "505"                                
                aDados[P_FVIRRF]      := Round(TMP_VALOR->VALOR*nPercVerb,TamSx3("RC_VALOR")[2])
            //Case TMP_VALOR->VERBA == "257"                                
            //    aDados[P_FVACRE]      := 0
            //Case TMP_VALOR->VERBA == "257"                                
            //    aDados[P_FVDESC]      := TMP_VALOR->VALOR
            Case TMP_VALOR->VERBA == "Z02"                                
                aDados[P_FVLIQ]       := Round(TMP_VALOR->VALOR*nPercVerb,TamSx3("RC_VALOR")[2])
            //Case TMP_VALOR->VERBA == "257"                                
                //aDados[P_FBANTIR]     := TMP_VALOR->VALOR
            Case TMP_VALOR->VERBA == "B16"                                
                aDados[P_FBIRRF]      := Round(TMP_VALOR->VALOR*nPercVerb,TamSx3("RC_VALOR")[2])
            Case TMP_VALOR->VERBA == "B05"                                
                aDados[P_FBINSS]      := Round(TMP_VALOR->VALOR*nPercVerb,TamSx3("RC_VALOR")[2])
            Case TMP_VALOR->VERBA == "B40" // ??????????? ALTERAR PARA VERBA CORRETA POIS B40 ษ INSS
                aDados[P_FDEDUC]      := Round(TMP_VALOR->VALOR*nPercVerb,TamSx3("RC_VALOR")[2])
        EndCase
        TMP_VALOR->(DbSkip())
    EndDo
    TMP_VALOR->(DbCloseArea())

    aDados[P_FMSG] := "Recebi da referida editora pela presta็ใo de servi็os abaixo descritos a quantia de R$ "+AllTrim(Transform(aDados[P_FVLIQ],"@E 999,999,999.99"))+" ("+Extenso(aDados[P_FVLIQ])+") como pagamento da presta็ใo de servi็o abaixo discriminado."

ELSE


    If Select("TMP_VALOR") >0 
        TMP_VALOR->(DbCloseArea())
    EndIf

    BeginSql Alias "TMP_VALOR"
        SELECT
            (
            SELECT SUM(E5_BASEIRF) E5_BASEIRF  FROM %Table:SE5% SE5
            WHERE SE5.E5_FILIAL = E2_FILIAL
            AND SE5.E5_PREFIXO = E2_PREFIXO
            AND SE5.E5_CLIFOR = E2_FORNECE
            AND SE5.E5_LOJA = E2_LOJA
            AND SE5.E5_TIPO = E2_TIPO
            AND SE5.E5_NUMERO <> E2_NUM
            AND E5_DATA BETWEEN SUBSTR(SE2.E2_BAIXA,1,6)||'01' AND SUBSTR(SE2.E2_BAIXA,1,6)||'31'
            AND SE5.%NotDel%
            AND SE5.E5_RECPAG = 'P'
            AND SE5.E5_TIPODOC = 'BA'
            AND SE5.E5_MOTBX = 'IRF'
            AND SE5.E5_SITUACA NOT IN ('S','C')
            AND SE5.R_E_C_N_O_ < (     
                SELECT SE5B.R_E_C_N_O_
                FROM %Table:SE5% SE5B
                WHERE SE5B.E5_FILIAL = E2_FILIAL
                AND SE5B.E5_PREFIXO = E2_PREFIXO
                AND SE5B.E5_CLIFOR = E2_FORNECE
                AND SE5B.E5_LOJA = E2_LOJA
                AND SE5B.E5_TIPO = E2_TIPO
                AND SE5B.E5_NUMERO = E2_NUM
                AND SE5B.E5_PARCELA = E2_PARCELA
                AND SE5B.%NotDel%
                AND SE5B.E5_RECPAG = 'P'
                AND SE5B.E5_TIPODOC = 'BA'
                AND SE5B.E5_MOTBX = 'IRF'
                AND SE5B.E5_SITUACA NOT IN ('S',
                                            'C')
                )

        ) BASEIR,E2_VALOR-SE2.E2_VRETIRF VALOR,E2_BAIXA,E2_VALOR,E2_VRETIRF,E2_BASEIRF
        FROM %Table:SE2% SE2
        WHERE E2_FILIAL = %Exp:SZ1->Z1_FILIAL%
        AND E2_FORNECE = %Exp:SZ1->Z1_FORNECE%
        AND E2_LOJA = %Exp:SZ1->Z1_LOJA%
        AND E2_NUM = %Exp:SZ1->Z1_IDSEQ%
        AND E2_PREFIXO = 'RPA'
        AND SE2.%NotDel%
    EndSql
    TMP_VALOR->(DbGoTop())

    aDados[P_FVBRU]       := TMP_VALOR->E2_VALOR
    aDados[P_FVIRRF]      := TMP_VALOR->E2_VRETIRF
    aDados[P_FVLIQ]       := TMP_VALOR->VALOR
    aDados[P_FBIRRF]      := TMP_VALOR->E2_BASEIRF+TMP_VALOR->BASEIR
    aDados[P_FDEDUC]      := sa2->A2_NUMDEP * nValDep
    aDados[P_FBANTIR]     := TMP_VALOR->BASEIR

    TMP_VALOR->(DbCloseArea())

    aDados[P_FMSG] := "Recebi da referida editora a importโncia de R$ "+AllTrim(Transform(aDados[P_FVLIQ],"@E 999,999,999.99"))+" ("+Extenso(aDados[P_FVLIQ])+") como pagamento pela cessใo dos direitos autorais do material da(s) obras(s) conforme o demonstrativo abaixo."+;
    " Declaro nesta oportunidade que nada mais me ้ devido pela referida editoria em rela็ใo aos direitos autorias mencionados, que estใo em acordo com o(s) contrato(s) de cessใo de direitos autorais assinado em separado"

ENDIF

/* ------------------- */

RestArea(aAreaSM0)

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPDIRF   บAutor  ณMicrosiga           บ Data ณ  02/17/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnvMail()

Local aArea    := GetArea()
Local cMarca   := oMark:Mark()

Local cFile		:= ""
Local cDir		:= ""
Local nAuxCont	:= 0
Local aLog		:= {}
Local cAssunto	:= "GEN - Recibo de pagamento"

Local lConexao			:= .F.
Local lEnvio   			:= .F.
Local lDesconexao		:= .F.
Local cMailServer  		:= "smtp.grupogen.com.br"
Local cMailConta   		:= GetMv("MV_RELACNT",.f.,"")
Local cMailSenha   		:= GetMv("MV_RELPSW",.f.,"")
Local cErro_Conexao		:= ""
Local cErro_Envio		:= ""
Local cErro_Desconexao	:= ""
Local aEmail			:= {}
Local nQtdEnv			:= 1
Local cFilePDF          := ""
Local nAuxVld           := 0

Private CMAILCOPY   := GetMv("GEN_FIN025",.F.,"cleuto.lima@grupogen.com.br")

nOpcMail := GetMv("GEN_FIN026",.F.,1)

IF nOpcMail == 3 
	Return nil
EndIF

Connect Smtp Server cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lConexao

If !lConexao
	GET MAIL ERROR cErro_Conexao
	Aviso( "Conexao " + Procname(), OemToAnsi("Nao foi possivel estabelecer a Conexao com o servidor - " + cErro_Conexao + " SERVIDOR:"+cMailServer+"  CONTA:"+cMailConta), {"&Ok"} )
	Return .F.
Else
	lConexao := Mailauth(cMailConta, cMailSenha)			
	If !lConexao
		GET MAIL ERROR cErro_Conexao
		MsgStop("Erro de autentica็ใo","Verifique a conta e a senha para envio") 		 //"Erro de autentica็ใo","Verifique a conta e a senha para envio"
		Return(.F.)
	EndIf
EndIf
		
ProcRegua(0)

SZ1->(DbGoTop())

While SZ1->(!EOF())
	
	If !oMark:IsMark(cMarca)
		SZ1->(DbSkip())
		Loop
	EndIf
	
    cDir		:= "\workflow\Anexos\RPA\"+AllTrim(SZ1->Z1_FILIAL)+"\"

    aEmail		:= StrTokArr( Posicione("SA2",1,xFilial("SA2")+SZ1->Z1_FORNECE+SZ1->Z1_LOJA,"A2_EMAIL") ,";")
    cMailFim	:= ""	
    For nAuxVld := 1 To Len(aEmail)
        If ISEMAIL(AllTrim(aEmail[nAuxVld]))
            cMailFim += AllTrim(aEmail[nAuxVld])+";"
        EndIf
    Next
    cMailFim := Left(cMailFim,Len(cMailFim)-1)
    
    If Empty(cMailFim)
        Aadd(aLog,"E-Mail nใo informado ou invalido para o colaborador "+SZ1->Z1_FORNECE+"-"+SZ1->Z1_LOJA+"("+AllTrim(SZ1->Z1_NOME)+")")
        MsgStop("E-Mail nใo informado ou invalido para o colaborador "+SZ1->Z1_FORNECE+"-"+SZ1->Z1_LOJA+"("+AllTrim(SZ1->Z1_NOME)+")")
        SZ1->(DbSkip())
        Loop			
    EndIF

    cFilePDF    := "RECIBO_"+SZ1->Z1_IDSEQ+".pdf"

	aFiles := Directory(cDir+cFilePDF)
			
	If File(cDir+cFilePDF)  .AND. Len(aFiles) > 0 .AND. aFiles[1][2] > 0

		cBody	:= ' <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> '+Chr(13)+Chr(10)
		cBody	+= ' <HTML> '+Chr(13)+Chr(10)
		cBody	+= ' 	<HEAD> '+Chr(13)+Chr(10)
		cBody	+= ' 		<TITLE>MINISTษRIO DA FAZENDA</TITLE> '+Chr(13)+Chr(10)
		cBody	+= ' 		<META http-equiv=Content-Language content=en-us> '+Chr(13)+Chr(10)
		cBody	+= ' 		<META http-equiv=Content-Type content="text/html; charset=windows-1252"> '+Chr(13)+Chr(10)
		cBody	+= ' 		<META content="MSHTML 6.00.2900.5726" name=GENERATOR> '+Chr(13)+Chr(10)
		cBody	+= ' 	</HEAD> '+Chr(13)+Chr(10)
		cBody	+= ' 	<BODY> '+Chr(13)+Chr(10)
		cBody	+= '  '+Chr(13)+Chr(10)
		cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0"><font face="Calibri">Prezado(a) <b>'+AllTrim(SZ1->Z1_NOME)+'</b></font></p> '+Chr(13)+Chr(10)
		cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0">&nbsp;</p> '+Chr(13)+Chr(10)
		
		cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0"><span style="font-size: 12pt; font-family: Calibri">Voc๊ estแ recebendo o Recibo de Pagamento anexo.</span></font></p> '+Chr(13)+Chr(10)

		cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0">&nbsp;</p> '+Chr(13)+Chr(10)
		cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0"><font face="Calibri">Atenciosamente,</font></p> '+Chr(13)+Chr(10)
		cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0">&nbsp;</p> '+Chr(13)+Chr(10)
				
		cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0"><span style="font-size: 12pt; font-family: Calibri">GEN | Grupo Editorial Nacional</span></font></p> '+Chr(13)+Chr(10)
		cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0"><span style="font-size: 12pt; font-family: Calibri">Travessa do Ouvidor, 11</span></font></p> '+Chr(13)+Chr(10)
		cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0"><span style="font-size: 12pt; font-family: Calibri">20040-040 | Rio de Janeiro | RJ</span></font></p> '+Chr(13)+Chr(10)
		cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0"><span style="font-size: 12pt; font-family: Calibri">www.grupogen.com.br</span></font></p> '+Chr(13)+Chr(10)
		
		cBody	+= '  '+Chr(13)+Chr(10)
		cBody	+= ' 	</BODY> '+Chr(13)+Chr(10)
		cBody	+= ' </HTML> '+Chr(13)+Chr(10)

		
		ConfirmMailRead( .F. )// confirma็ใo de recebimento                                             
		cAnexos 	:= AllTrim(cDir+cFilePDF)
		
		If nOpcMail == 1
			cMailDest	:= "cleuto.lima@grupogen.com.br"
		Else 
			cMailDest	:= cMailFim
		Endif
		
		nQtdEnv++
		
		IncProc("Env..."+cMailDest)
		
		Send Mail From cMailConta To cMailDest BCC cMailCopy SubJect cAssunto BODY cBody FORMAT TEXT ATTACHMENT cAnexos RESULT lEnvio
				
		/* <20190215 - 1230> cleuto - 15/02/2019 - */
		If !lEnvio .OR. nQtdEnv >= 40
									
			If nQtdEnv >= 40 .OR. MsgYesNo("Deseja refazer a conexใo com o servidor de e-mails?")
				
				nQtdEnv := 0
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณEXECUTA desconexao ao servidor SMTPณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				DisConnect Smtp Server Result lDesconexao
				
				IF !lDesconexao
					Get Mail Error cErro_Desconexao
					Aviso( "Envio de Email", OemToAnsi("Nao foi possivel DESCONECTAR do servidor - " + cErro_Desconexao), {"&Ok"} )
					Exit
				EndIf	
									 
				Connect Smtp Server cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lConexao
				
				If !lConexao
					GET MAIL ERROR cErro_Conexao
					Aviso( "Conexao " + Procname(), OemToAnsi("Nao foi possivel estabelecer a Conexao com o servidor - " + cErro_Conexao + " SERVIDOR:"+cMailServer+"  CONTA:"+cMailConta), {"&Ok"} )
					Exit
				Else
					lConexao := Mailauth(cMailConta, cMailSenha)			
					If !lConexao
						GET MAIL ERROR cErro_Conexao
						MsgStop("Erro de autentica็ใo","Verifique a conta e a senha para envio") 		 //"Erro de autentica็ใo","Verifique a conta e a senha para envio"
						Exit
					Else
						
						/* nova tentativa de envio */
						
						Send Mail From cMailConta To cMailDest BCC cMailCopy SubJect cAssunto BODY cBody FORMAT TEXT ATTACHMENT cAnexos RESULT lEnvio
							
					EndIf
				EndIf
					
			EndIf
		EndIf
		
		/* </20190215 - 1230> cleuto - 15/02/2019 - */
		
		If !lEnvio
			Get Mail Error cErro_Envio
			Aviso( "Envio de Email " + Procname(), OemToAnsi("Nao foi possivel ENVIAR a mensagem - " + cErro_Envio + " - SERVIDOR:" + cMailServer+"  CONTA:"+cMailConta+' - DESTINO:' + cMailDest), {"&Ok"} )
			If MsgYesNo("Finalizar envio?")
				Exit
			EndIf
		Else
			Aadd(aLog,"Recibo enviado para "+AllTrim(SZ1->Z1_NOME)+"("+SZ1->Z1_FORNECE+")"+", e-mail "+AllTrim(cMailDest)+" em "+DtoC(DDataBase)+" as "+Time()+",  anexo "+AllTrim(cAnexos))
            RecLock('SZ1', .F.)
            SZ1->Z1_DTEMAIL := DDATABASE
            SZ1->Z1_HREMAIL := TIME()
            SZ1->(MsUnlock())		
		EndIf

	Else
		Aadd(aLog,"Arquivo de recibo nใo encontrado para colaborador "+SZ1->Z1_FORNECE+"("+AllTrim(AllTrim(SZ1->Z1_NOME))+")"+Chr(13)+Chr(10)+"Tente novamente, caso o problema continue entre em contato com departamento de TI!")
		MsgStop("Arquivo de recibo nใo encontrado para colaborador "+SZ1->Z1_FORNECE+"("+AllTrim(AllTrim(SZ1->Z1_NOME))+")"+Chr(13)+Chr(10)+"Tente novamente, caso o problema continue entre em contato com departamento de TI!")	
	EndIF
				
	Sleep(1000)

	SZ1->(DbSkip())
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEXECUTA desconexao ao servidor SMTPณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DisConnect Smtp Server Result lDesconexao

IF !lDesconexao
	Get Mail Error cErro_Desconexao
	Aviso( "Envio de Email", OemToAnsi("Nao foi possivel DESCONECTAR do servidor - " + cErro_Desconexao), {"&Ok"} )
	//Return(.F.)
EndIf

ViewLog(aLog)

Return nil 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณViewLog   บAutor  ณMicrosiga           บ Data ณ  11/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ViewLog(aLog)

Local oReport

oReport := reportDef(aLog)
oReport:printDialog()

Return

Static function ReportDef(aLog)

local oReport
local cTitulo	:= "Log de processamento"
local cPerg		:= ""

oReport := TReport():New(FunName(), cTitulo, cPerg , {|oReport| PrintReport(oReport,aLog)})

oReport:SetLandScape()

oReport:SetTotalInLine(.F.)

oReport:ShowHeader()

oSection0 := TRSection():New(oReport,"Mensagens",{""})

TRCell():New(oSection0,"LOG"  ,,"Log",,300)

return (oReport)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA101   บAutor  ณCleuto Lima         บ Data ณ  23/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณcontrole de recibos                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PrintReport(oReport,aLog)

Local oSection0 := oReport:Section(1)
Local nx        := 0

For nx:=1 To Len(aLog)
 
 oReport:IncMeter()
 
 oSection0:Init()
 
 oSection0:Cell("LOG"):SetValue(AllTrim(aLog[nx]))
 
 oSection0:PrintLine()      
  
Next nx

oSection0:Finish()

Return 
