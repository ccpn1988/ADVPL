#INCLUDE "Totvs.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "TBICONN.CH"
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA100   บAutor  ณMicrosiga           บ Data ณ  09/03/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ cadastro de colaborador                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function GENA100()

Private oBrowse                                                               
Private cFilAces
If !ZZF->( DbSeek( xFilial("ZZF")+RetCodUsr() ) )
    MsgStop("Usuแrio sem acesso a esta ferramenta!"+chr(13)+chr(10)+"Solicite a TI que inclua seu usuแrio "+RetCodUsr()+" na tabela ZZF!")
    Return nil
EndIf

aRotina := MenuDef()

oBrowse := FwLoadBrw("MATA020")
//oBrowse:SetOnlyFields( { 'A2_COD','A2_LOJA','A2_NOME','A2_NREDUZ','A2_CGC'} ) 
//oBrowse:SetAlias('SA2')
oBrowse:SetDescription("Cadastro de Pessoas") 

oBrowse:AddLegend("A2_MSBLQL == '1'","RED","Bloqueado")
oBrowse:AddLegend("A2_MSBLQL <> '1' .AND. A2_TIPO == 'J' ","BLUE","Pessoa Juridica")
oBrowse:AddLegend("A2_MSBLQL <> '1' .AND. A2_XGPE == '1' .AND. A2_TIPO == 'F'","GREEN","Integrado ao GPE")
oBrowse:AddLegend("A2_TIPO == 'F' .AND. A2_MSBLQL <> '1' .AND. A2_XGPE <> '1'","YELLOW","Nใo integrado ao GPE")
''
If ZZF->ZZF_VISFOR == "3"
    oBrowse:SetFilterDefault("A2_XORIGEM == '2'")
Else
    If ZZF->ZZF_VISFOR == "1"
        oBrowse:SetFilterDefault("A2_XORIGEM == '2' .AND. A2_TIPO == 'F'")
    Else    
        oBrowse:SetFilterDefault("A2_XORIGEM == '2' .AND. A2_TIPO == 'J'")
    EndIf
EndIf

oBrowse:Activate()

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA100   บAutor  ณMicrosiga           บ Data ณ  09/03/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA100L()

If SA2->A2_MSBLQL == "1"
    If MsgYesNo("Confirmar a libera็ใo do fornecedor?")
        RecLock("SA2",.F.)
        SA2->A2_MSBLQL  := "2"
        MsUnLock()
    endIF
else
    MsgStop("Cadastro nใo estแ bloqueado!")        
EndIF    

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA100   บAutor  ณMicrosiga           บ Data ณ  09/03/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA100M(cTit,nMnu)

If nMnu == 4
    IF SA2->A2_XGPE == '1'
        MsgStop("Altera็ใo nใo permitida, fornecedor jแ integrado do modulo gestใo de pesssoas!")
        Return nil
    EndIf
EndIf

FWExecModalView("Fornecedor", "MATA020", nMnu, {|x| .T.}, {|x| .T.}, 600, 800)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA100   บAutor  ณMicrosiga           บ Data ณ  09/03/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA100T(cCodFor,cFilAuto)

Local aArea     := GetArea()
Local aAreaSA2  := SA2->(GetArea())
Local cFilProc  := ""
Local cFilBkp   := cFilAnt
Local cCadEixt  := ""
//Local aFilAut   := STRTOKARR(SA2->A2_XFILGPE,";")
Local aFilAut   := {}
Local nAuxFil   := 0
Local aEmpAux	:= FWLoadSM0()
Local cMsgAux   := ""

Default cFilAuto    := xFilial("SRA")

aFilAut   := STRTOKARR(cFilAuto,";")

IF SA2->A2_MSBLQL  == "1"
    MsgStop("Integra็ใo com GPE nใo permitida, fornecedor estแ bloqueado!")
    Return nil
ENDIF

//IF Empty(SA2->A2_XFILGPE)
IF Empty(cFilAuto)
    MsgStop("Nใo foram informados filiais para este autonomo!")
    Return .F.
ELSE
    cMsgAux := "Serแ processado o cadastro do autonomo para as filais.: "+chr(13)+chr(10)
    For nAuxFil := 1 To Len(aFilAut)

        IF Empty(AllTrim(aFilAut[nAuxFil]))
            Loop
        ENDIF

        IF aScan(aEmpAux, {|x| x[2] == aFilAut[nAuxFil] } ) <> 0        
            cMsgAux += aFilAut[nAuxFil]+"-"+aEmpAux[aScan(aEmpAux, {|x| x[2] == aFilAut[nAuxFil] } )][7]+CHR(13)+cHR(10)
        EndIF
    Next nAuxFil    
    cMsgAux += "Confirma opera็ใo?"    

    IF !MsgYesNo(cMsgAux)
        Return .F.
    ENDIF
ENDIF

//IF SA2->A2_XGPE == "1"
    /*
    IF Select("TMP_SRA") > 0
        TMP_SRA->(DbCloseArea())
    ENDIF
    cCadEixt := ""

    BEGINSQL ALIAS "TMP_SRA"
        SELECT RA_FILIAL,RA_MAT FROM %Table:SRA% SRA
        WHERE RA_XFF = %Exp:SA2->A2_COD%
        AND SRA.RA_CIC = %Exp:SA2->A2_CGC%
        AND SRA.%NotDel%
    ENDSQL
    TMP_SRA->(DbGoTop())

    While TMP_SRA->(!EOF())

        cCadEixt += "FILIA.: "+TMP_SRA->RA_FILIAL+", MAT.: "+TMP_SRA->RA_MAT+chr(13)+chr(10)

        TMP_SRA->(DbSkip())
    EndDo

    IF !Empty(cCadEixt)
        If !MsgYesNo("Identificamos que jแ existe(m) autonomo(s) cadastrado(s) para o fornecedor informado, deseja realizar o vinculo para outra filial?"+chr(13)+chr(10)+;
            "Autonomo: "+cCadEixt)
            TMP_SRA->(DbCloseArea())
            Return nil
        EndIf
        TMP_SRA->(DbCloseArea())
    ENDIF
    */
//ENDIF


For nAuxFil := 1 To Len(aFilAut)

    IF Empty(AllTrim(aFilAut[nAuxFil]))
        Loop
    ENDIF

    IF aScan(aEmpAux, {|x| x[2] == aFilAut[nAuxFil] } ) == 0
        MsgStop("Codigo da Filial "+aFilAut[nAuxFil]+" nใo existe!")
        Loop
    EndIF

    cFilProc := aFilAut[nAuxFil]

    IF cFilProc <> cFilAnt
        SM0->(dbSetOrder(1))
        SM0->(dbSeek(cEmpAnt + cFilProc,.T.)) //Posiciona Empresa
                
        cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
        cFilAnt := SM0->M0_CODFIL
        OpenFile(cEmpAnt + cFilAnt)
    ENDIF

    IF Select("TMP_SRA") > 0
        TMP_SRA->(DbCloseArea())
    ENDIF

    BEGINSQL ALIAS "TMP_SRA"
        SELECT RA_MAT,SRA.R_E_C_N_O_ RECSRA,RA_XFF FROM %Table:SRA% SRA
        WHERE RA_FILIAL = %xFilial:SRA%
        /*AND RA_XFF = %Exp:SA2->A2_COD%*/
        AND SRA.RA_CIC = %Exp:SA2->A2_CGC%
        AND SRA.%NotDel%
    ENDSQL
    TMP_SRA->(DbGoTop())
    IF TMP_SRA->(!EOF())
        If MsgYesNo("Identificamos que jแ existe um autonomo cadastrado para o fornecedor informado, deseja realizar o vinculo com o cadastro jแ existente?"+chr(13)+chr(10)+;
            "Filial.:"+cFilAnt+",Cod. Autonomo: "+TMP_SRA->RA_MAT+", cod.fornecedor: "+TMP_SRA->RA_XFF)

            Reclock("SA2",.F.)
            SA2->A2_XGPE    := "1"
            MsUnLock()

            SRA->(DbGoTo( TMP_SRA->RECSRA ))
            RecLock("SRA",.F.)
            SRA->RA_XFF := SA2->A2_COD
            MsUnLock()

            MsgAlert("Vinculo GPE x FIN realizado com sucesso para filial "+cFilAnt+"!")
        EndIf    
        TMP_SRA->(DbCloseArea())
        LOOP
    ELSE
        TMP_SRA->(DbCloseArea())    
    ENDIF

    NewAuto(cCodFor,nil)

    RestArea(aAreaSA2)
    RestArea(aArea)

    IF Select("TMP_SRA") > 0
        TMP_SRA->(DbCloseArea())
    ENDIF

    BEGINSQL ALIAS "TMP_SRA"
        SELECT * FROM %Table:SRA% SRA
        WHERE RA_FILIAL = %xFilial:SRA%
        AND RA_XFF = %Exp:SA2->A2_COD%
        AND SRA.RA_CIC = %Exp:SA2->A2_CGC%
        AND SRA.%NotDel%
    ENDSQL
    TMP_SRA->(DbGoTop())
    IF TMP_SRA->(!EOF())
        Reclock("SA2",.F.)
        SA2->A2_XGPE    := "1"
        MsUnLock()
        MsgAlert("Vinculo GPE x FIN realizado com sucesso para filial "+cFilAnt+"!")
    ELSE
        MsgStop("Vinculo GPE x FIN nใo realizado "+cFilAnt+"!")
    ENDIF
    TMP_SRA->(DbCloseArea())

Next nAuxFil

SM0->(dbSetOrder(1))
SM0->(dbSeek(cEmpAnt + cFilBkp,.T.)) //Posiciona Empresa
        
cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
cFilAnt := SM0->M0_CODFIL
OpenFile(cEmpAnt + cFilAnt)

Return .f.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA100   บAutor  ณMicrosiga           บ Data ณ  09/03/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NewAuto(cCodFor,aRotAuto)
LOCAL cFiltraSRA			//Variavel para filtro
LOCAL aIndexSRA		:= {}		//Variavel Para Filtro
LOCAL cOrgCfg		:= GetMv("MV_ORGCFG", NIL, "0")	
LOCAL lItemClVl 	:= SuperGetMv( "MV_ITMCLVL", .F., "2" ) $ "13"
LOCAL lIncItClVl	:= .T.
LOCAL cCpoNoShow	:= 'RA_FILIAL'
Local nLoops		:= 0
Local aSRANotFields := {}
Local bSkip			:= { || .F. }
Local nI			:= 0

Private cCadastro    := "Autonomos"
Private bFiltraBrw := {|| Nil}		//Variavel para Filtro
Private aDicio  := {}          
Private aDicioT := {}			//Array contendo os campos do SX3
Private aDicioW	:= {} 			//Array auxiliar do aDicioT
Private nAgrup	:= 01
Private nCampo	:= 0
Private cAltSal := Getmv("MV_ALTSAL")
Private FocoAnterior:= ""       		

Private lSetCentury := __SetCentury("on")
Private lGp265Auto 	:=	(aRotAuto <> Nil)
Private lMsErroAuto := .F.

Private cIncRD0		:= GetMvRH( "MV_AUTPART", .F., "3" ) // 1-Pergunta se incluiu RD0;2-Sempre inclui;3-Nunca incluiu

Private aRetGPE	:= array(2)
Private aRetTAF	:= array(2)
Private cVersEnvio:= ""

If( FindFunction("fVersEsoc") ) 
	fVersEsoc("S2300", .F., @aRetGPE, @aRetTAF, @cVersEnvio)
Else
	cVersEnvio := "2.2"
	aRetGPE := {.F., ""}
	aRetTAF := {.F., ""}
EndIf

_SetOwnerPrvt(	"aSraFields"	, {} )
_SetOwnerPrvt(	"aSraAltera" 	, {} )
_SetOwnerPrvt(	"aSraNaoAlt" 	, {} )
_SetOwnerPrvt(	"aSraVirtual"	, {} )
_SetOwnerPrvt(	"aSraVisual" 	, {} )
_SetOwnerPrvt(	"aSraHeader" 	, {} )
_SetOwnerPrvt(	"aSraCols" 		, {} )
_SetOwnerPrvt(	"aSvSraCols"	, {} )

If !lItemClVl
	cCpoNoShow += '/RA_ITEM/RA_CLVL'
EndIf

//--Monta o Array com os Campos do sx3 e quando usado marca com x
SX3->(dbSetOrder(1))
SX3->(dbSeek("SRA"))
While SX3->(! Eof()) .And. SX3->X3_ARQUIVO = 'SRA'
	uCampo := SX3->X3_CAMPO
	If Alltrim(uCampo) $ cCpoNoShow .or. ;
	  (__lPyme	.and. SX3->X3_PYME="N" ) 
		SX3->(dbSkip())
		loop
	Endif

   	lIncItClVl	:= .T.
	// Remove ou insere os campos RA_ITEM e RA_CLVL conforme o conteudo do paramentro MV_ITMCLVL 
   	If ! lItemClVl 
		If AllTrim(SX3->X3_CAMPO) == "RA_ITEM" .OR. AllTrim(SX3->X3_CAMPO) == "RA_CLVL"
	   		lIncItClVl	:= .F.	
	   	EndIf
	EndIf   
		
	nCampo := nCampo + 1
	If lIncItClVl		 
		If cPaisLoc=="BRA"
			Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
		Else
			If X3USO(SX3->X3_USADO) .Or. !Empty(Substr(X3RESERV(SX3->X3_RESERV),8,1))
				Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
			Endif
		Endif
	EndIf	
	SX3->(dbSkip())
Enddo

//--Funcao Para atualizar a configuracao da ficha
f265Conf()


StaticCall(Gpea265,gp265Cad,"SRA",0,2)

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA100   บAutor  ณMicrosiga           บ Data ณ  09/03/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MenuDef()
Local aRotina	:= {}

//aRotina := FWMVCMenu( "MATA020" )

ADD OPTION aRotina TITLE 'Incluir'		ACTION 'U_GENA100M("Incluir",3)'		OPERATION 3 ACCESS 0

If ZZF->ZZF_LIBFOR == "1" .OR. ZZF->ZZF_LIBFOR == "4"
    ADD OPTION aRotina TITLE 'Liberar'	    ACTION 'U_GENA100L'		                OPERATION 4 ACCESS 0
EndIf    
ADD OPTION aRotina TITLE 'Visualizar'	ACTION 'U_GENA100M("Visualizar",1)'		OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'		ACTION 'U_GENA100M("Alterar",4)'		OPERATION 4 ACCESS 0

//If ZZF->ZZF_AUTGPE == "1"
//    ADD OPTION aRotina TITLE 'Autonomo'		ACTION 'U_GENA100T(SA2->A2_COD)'   		OPERATION 4 ACCESS 0
//EndIf    

Return aRotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA100   บAutor  ณMicrosiga           บ Data ณ  09/03/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function GENA100P(cField)

Local xRet  := nil

cField := AllTrim(cField)

IF !ISINCALLSTACK( "U_GENA097" )
    Do Case
        Case cField == "RA_CODCBO"
            xRet := IIF(Inclui,"",fDesc("SRJ",SRA->RA_CODFUNC,"RJ_CODCBO"))
    OtherWise        
        xRet    := CriaVar(cField,.F.)
    EndCase    
    Return xRet
ENDIF

Do Case
    Case cField == "RA_CATFUNC"
        xRet    := "A"
    Case cField == "RA_CC"
        xRet    := "10201010"
    Case cField == "RA_CLVL"
        xRet    := "000000000"
    Case cField == "RA_GRINRAI"
        xRet    := "55"
    Case cField == "RA_HRSDIA"
        xRet    := 8    
    Case cField == "RA_HRSEMAN"
        xRet    := 40
    Case cField == "RA_HRSMES"
        xRet    := 160    
    Case cField == "RA_ITEM"
        xRet    := cFilAnt    
    Case cField == "RA_MAT"
        xRet    := NewMAt()
    Case cField == "RA_NUMCP"
        xRet    := "0000000"
    Case cField == "RA_PROCES"
        xRet    := "00003"
    Case cField == "RA_SERCP"
        xRet    := "00000"
    Case cField == "RA_TIPOADM"
        xRet    := "9B"
    Case cField == "RA_TIPOPGT"
        xRet    := "M"    
    Case cField == "RA_TNOTRAB"
        xRet    := "001"    
    Case cField == "RA_VIEMRAI"
        xRet    := "10"
    Case cField == "RA_XFF"
        xRet    := SA2->A2_COD
    Case cField == "RA_CIC"
        xRet    := SA2->A2_CGC
    Case cField == "RA_NOME"
        xRet    := FwNoAccent(SA2->A2_NREDUZ)
    Case cField == "RA_NOMECMP"
        xRet    := FwNoAccent(SA2->A2_NOME)
    Case cField == "RA_NASC"
        xRet    := SA2->A2_DTNASC
    Case cField == "RA_ESTADO"
        xRet    := SA2->A2_XESTADO
    Case cField == "RA_CODMUNN"
        xRet    := SA2->A2_XCODMUN
    Case cField == "RA_CEP"
        xRet    := SA2->A2_CEP
    Case cField == "RA_ENDEREC"
        xRet    := FwNoAccent(SA2->A2_END)
    Case cField == "RA_ADMISSA"
        xRet    := FIRSTDATE(dDataBase)
    Case cField == "RA_CODFUNC"     
        xRet := SA2->A2_XCODFUN
    Case cField == "RA_COMPSAB"    
        xRet := "2"
    Case cField == "RA_HOPARC"    
        xRet := "2"
    Case cField == "RA_DEPIR"    
        xRet := SA2->A2_NUMDEP
    Case cField == "RA_TPJORNA"    
        xRet := "3"
    Case cField == "RA_LOGRDSC"    
        xRet := FwNoAccent(SA2->A2_END)
    Case cField == "RA_PIS"    
        xRet := SA2->A2_XPIS
    Case cField == "RA_CPAISOR"    
        xRet := SA2->A2_XNACION
    Case cField == "RA_RG"    
        xRet := SA2->A2_XRG
    Case cField == "RA_LOGRNUM"    
        xRet := FisGetEnd(SA2->A2_END)[3]
    Case cField == "RA_CODMUN"    
        xRet := SA2->A2_XCODMUN
    Case cField == "RA_NACIONC"    
        xRet := SA2->A2_XNACION
    Case cField == "RA_DTRGEXP"    
        xRet := SA2->A2_XDRGEXP
    Case cField == "RA_RGEXP"    
        xRet := SA2->A2_XOREMRG
    Case cField == "RA_CATEFD"    
        xRet := "701"
    Case cField == "RA_TNOTRAB"    
        xRet := "001"
    Case cField == "RA_REGRA"    
        xRet := "01"
    Case cField == "RA_SEQTURN"    
        xRet := "01"
    Case cField == "RA_CODRET"    
        xRet := "0588"
    Case cField == "RA_CODCBO"
        xRet := Posicione("SRJ",1,xFilial("SRJ")+SA2->A2_XCODFUN,"RJ_CODCBO")
    Case cField == "RA_NATURAL"        
        xRet := SA2->A2_XESTADO
    Case cField == "RA_SEXO"        
        xRet := SA2->A2_XSEXO
    Case cField == "RA_RACACOR"        
        xRet := SA2->A2_XRACACO                
    OTHERWISE
        xRet    :=  CriaVar(cField,.F.)
EndCase

Return xRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA100   บAutor  ณMicrosiga           บ Data ณ  09/03/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NewMAt()

Local cMat      := ""
        
IF Select("TMP_MAT")
    TMP_MAT->(DbCloseArea())
Endif

BEGINSQL ALIAS "TMP_MAT"
    SELECT NVL(MAX(RA_MAT),"600000") RA_MAT FROM %Table:SRA% SRA
    WHERE RA_FILIAL = %xFilial:SRA% 
    AND RA_CATFUNC = 'A' 
    AND RA_PROCES ='00003' 
    AND SRA.%NotDel%
    AND RA_MAT BETWEEN '600000' AND '699999'
ENDSQL
        
cMat := Soma1(TMP_MAT->RA_MAT)

IF cMat >= "699999"
    MsgStop("FALHA_NUMERACAO.LOG","O CONTROLE DE NUMERAวรO NรO TEM REGISTROS LIBERADOS PARA A FILIAL "+cFilAnt)
    cMat    := ""
EndIF

Return cMat

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA100   บAutor  ณMicrosiga           บ Data ณ  09/03/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xGetFil()

Local cRetFil		:= ""
Local aSelFil		:= {}

aSelFil := AdmGetFil(.F.,.F.,"SRA")

aEval(aSelFil, {|x| cRetFil+=x+";" } )

Return cRetFil	  

/*

nOpc := 3

oModel  := FWLoadModel('MATA020')
oView   := FWLoadView( 'MATA020' )

oModel:SetOperation(nOpc)
oModel:Activate()

//Cabe็alho
oModel:SetValue('SA2MASTER','A2_COD' ,"999999")
oModel:SetValue('SA2MASTER','A2_LOJA' ,"01")
oModel:SetValue('SA2MASTER','A2_NOME' ,"Fornecedor 999")
oModel:SetValue('SA2MASTER','A2_NREDUZ' ,"Fornecedor 999")
oModel:SetValue('SA2MASTER','A2_END' ,"Av. Braz Leme, 1000")
oModel:SetValue('SA2MASTER','A2_BAIRRO' ,"Casa Verde")
oModel:SetValue('SA2MASTER','A2_EST' ,"SP")
oModel:SetValue('SA2MASTER','A2_COD_MUN',"50308")
oModel:SetValue('SA2MASTER','A2_MUN' ,"Sใo Paulo")
oModel:SetValue('SA2MASTER','A2_TIPO' ,"F")
oModel:SetValue('SA2MASTER','A2_CGC' ,"99999999999")

If oModel:VldData()
    oModel:CommitData()
Else
    VarInfo("Erro",oModel:GetErrorMessage()[6])
Endif

oModel:DeActivate()

oModel:Destroy()


Return nil
*/

User Function GENA100F()

Local nTam			:= 1
Local aCat	      	:= {}
Local MvRet		  	:= Alltrim(ReadVar())
Local MvPar			:= ""
Local cTitulo		:= "Filiais SIGAGPE"
Local MvParDef  	:= ""                     
Local cF3           := ""  
Local aEmpAux		:= FWLoadSM0()
Local nAuxF         := 0
Local aAcesFil      := {}
Local lRetArray     := .T.
Local lRetOpc       := nil

ZZF->( DbSeek( xFilial("ZZF")+RetCodUsr() ) )

aAcesFil := StrTokArr(ZZF->ZZF_FILGPE,";")

For nAuxF := 1 To Len(aAcesFil)
    If aScan(aEmpAux, {|x| x[2] == AllTrim(aAcesFil[nAuxF]) } ) > 0
        Aadd(aCat, cValToChar(nAuxF)+"-"+alltrim(aEmpAux[aScan(aEmpAux, {|x| x[2] == AllTrim(aAcesFil[nAuxF]) } )][2]+" "+aEmpAux[aScan(aEmpAux, {|x| x[2] == AllTrim(aAcesFil[nAuxF]) } )][7]) )
        //MvParDef +=cValToChar(nAuxF)
        MvPar+=cValToChar(nAuxF)
    EndIF    
Next nAuxF

/*
aAdd(aCat,"1-VitalSource")
aAdd(aCat,"2-eLibros")
aAdd(aCat,"3-Kobo")
aAdd(aCat,"4-Apple")
aAdd(aCat,"5-Saraiva")
aAdd(aCat,"6-Saraiva XML")
*/

//MvPar:= PadR(AllTrim(StrTran(&MvRet,";","")),40)
//&MvRet:= PadR(AllTrim(StrTran(&MvRet,";","")),40)
	
	
//----------------------------------------------------------------------
// Executa f_Opcoes para Selecionar ou Mostrar os Registros Selecionados
lRetOpc := f_Opcoes(       @MvPar      ,;    //Variavel de Retorno
                cTitulo     ,;    //Titulo da Coluna com as opcoes
                @aCat       ,;    //Opcoes de Escolha (Array de Opcoes)
                @MvParDef   ,;    //String de Opcoes para Retorno
                NIL         ,;    //Nao Utilizado
                NIL         ,;    //Nao Utilizado
                .F.         ,;    //Se a Selecao sera de apenas 1 Elemento por vez
                nTam        ,;    //Tamanho da Chave
                NIL         ,;    //No maximo de elementos na variavel de retorno
                .T.         ,;    //Inclui Botoes para Selecao de Multiplos Itens
                .F.         ,;    //Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
                NIL         ,;    //Qual o Campo para a Montagem do aOpcoes
                .F.         ,;    //Nao Permite a Ordenacao
                .F.         ,;    //Nao Permite a Pesquisa    
                lRetArray   ,;    //Forca o Retorno Como Array
                cF3         ;    //Consulta F3    
                )
	  
    //Tratamento para separar retorno 
    //&MvRet := SubStr(MvPar,1,1)
    for nAuxF := 1 to Len(MvPar)
        IF !(SubStr(MvPar[nAuxF],3,4) $ &MvRet)
            &MvRet := SubStr(MvPar[nAuxF],3,4)+";"+AllTrim(&MvRet)
        EndIF
    next
	
Return .T.