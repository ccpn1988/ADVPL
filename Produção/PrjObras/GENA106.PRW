#include "totvs.ch"
#include "protheus.ch"
#INCLUDE "Topconn.ch"
#include "Fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA106   บAutor  ณCleuto Lima         บ Data ณ  11/12/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAltera็ใo de situa็ใo da obra em lote                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function GENA106()

	Local oDlgMain	:= nil
	Local oPObs		:= nil
	Local oGrpAll	:= nil
	Local oBtSave	:= nil
	Local oGetObs	:= nil
	Local oPBottom	:= nil
	Local oPBTop	:= nil
	Local oFont		:= TFont():New('ARIAL',,-16,.T.)
    Local cSitObr   := ""
    Local cDeSitObr := ""
    Local cTpPub    := Space(20)//CriaTrab("ZZL_SITOBR",.F.)
    Local aSitProd  := {}
    Local cCombo    := " "
    Local aProdutos := {}
    Local nOpc      := 0
    Local aErro     := {}

    Private aEmpProd  := {{'0380795','EGK'},{'0380796','LTC'},{'0380794','FOR'},{'031811 ','ACF'},{'0378128','ATL'},{'378803','GEN'}}

    Aadd(aSitProd," ")
    Aadd(aSitProd,"Nใo reimprimir (105) para Bloqueado (102)")
    Aadd(aSitProd,"Nใo reimprimir (105) para Bloqueado Aparas (111)")
    Aadd(aSitProd,"Nใo reimprimir (105) para Cancelado (103)")
    Aadd(aSitProd,"Bloqueado (102) para Bloqueado Aparas (111)")
    Aadd(aSitProd,"Bloqueado (102) para Cancelado (103)")
    Aadd(aSitProd,"Bloqueado Aparas (111) para Cancelado (103)")

	DEFINE MSDIALOG oDlgMain TITLE ' '  From 0,0 To 400,800 pixel STYLE nOR(WS_VISIBLE,WS_POPUP) //Style DS_MODALFRAME
	oDlgMain:lMaximized := .F.

	oGrpAll:= TGroup():New(00,00,oDlgMain:NCLIENTHEIGHT/2,(oDlgMain:NCLIENTWIDTH/2),"",oDlgMain,CLR_BLUE,,.T.)

	@05,15 MSPANEL oPntAll PROMPT "" SIZE (oDlgMain:NCLIENTWIDTH/2)-30,(oDlgMain:NCLIENTHEIGHT/2)-10 COLOR CLR_WHITE,CLR_WHITE OF oDlgMain

	@00,00 MSPANEL oPBTop PROMPT "" SIZE 40,40 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
	oPBTop:Align := CONTROL_ALIGN_TOP

	oSayQuest := TSay():New(15,01,{|| '<h1>Alterar situa็ใo da obra De -> Para</h1>' },oPBTop,,,,,,.T.,,,,,,,,,,.T.)

    // oTpSitObr := TRadMenu():New (025,01,aSitProd,,oPBTop,,,,,,,,400,12,,,,.T.,.T.,.T.)
	// oTpSitObr:bSetGet := {|u|Iif (PCount()==0,nRadB,nRadB:=u)}

	@00,00 MSPANEL oPBottom PROMPT "" SIZE 40,40 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
	oPBottom:Align := CONTROL_ALIGN_BOTTOM

	@00,00 MSPANEL oPObs PROMPT "" SIZE 10,10 COLOR CLR_WHITE,CLR_WHITE OF oPntAll
	oPObs:Align := CONTROL_ALIGN_ALLCLIENT

	@00,00 MSPANEL oPObsLeft PROMPT "" SIZE oPObs:NCLIENTHEIGHT*0.80,10 COLOR CLR_WHITE,CLR_WHITE OF oPObs
	oPObsLeft:Align := CONTROL_ALIGN_LEFT

	oGetObs	:= tMultiget():new(10,10,{| u | if( pCount() > 0, cSitObr := u, cSitObr )},oPObsLeft,260,92,,,,,,.T.)
	oGetObs:Align := CONTROL_ALIGN_ALLCLIENT
    
	@00,00 MSPANEL oPObsRight PROMPT "" SIZE 10,10 COLOR CLR_WHITE,CLR_WHITE OF oPObs
	oPObsRight:Align := CONTROL_ALIGN_ALLCLIENT

    oCombo := TComboBox():New(01,15,{|u|if(PCount()>0,cCombo:=u,cCombo)},aSitProd,150,30,oPObsRight,,{|| },,,,.T.,,,,,,,,,'cCombo','Selecione qual situa็ใo deseja alterar',1,oFont,CLR_BLACK)
    oCombo:bChange  := {|x| cDeSitObr :=  xRetSit(cCombo) }

    oTpPub	:= TGet():New( 25, 15,{|u| if( Pcount()>0, cTpPub := u,cTpPub ) },oPObsRight,030,010,"@!",{|| .T. },0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cTpPub",,,,,,,"Informe o Tipo de Publica็ใo.: ",1,oFont,CLR_BLACK )
    oTpPub:cF3	:= "Z4"

    TSay():New(55,15,{|| '<h3>102 = Bloqueado</h3>' },oPObsRight,,,,,,.T.,,,,,,,,,,.T.)
    TSay():New(70,15,{|| '<h3>103 = Cancelado</h3>' },oPObsRight,,,,,,.T.,,,,,,,,,,.T.)
    TSay():New(85,15,{|| '<h3>105 = Nใo reimprimir</h3>' },oPObsRight,,,,,,.T.,,,,,,,,,,.T.)
    TSay():New(100,15,{|| '<h3>111 = Bloqueado Aparas</h3>' },oPObsRight,,,,,,.T.,,,,,,,,,,.T.)

	oBtSave	:= TButton():New( 010, 01, "Confirma็ใo"	, oPBottom,{|| ;
    Processa({|| IIF( VldTok(@aProdutos, cSitObr, @aErro, cTpPub, cDeSitObr) , (nOpc := 1,oDlgMain:End() ) , nil ) },"Validando...","Aguarde.. validando dados!",.F.);
    },80,020,,oFont,,.T.)

	oBtSave:SetCss( "QPushButton{ background-color:rgb(28,157,189);}" )

	oBtCanc	:= TButton():New( 010, 120, "Cancelar"	, oPBottom,{|| oDlgMain:End() },80,020,,oFont,,.T.)
	oBtCanc:SetCss( "QPushButton{ background-color:rgb(157,28,28);}" )

	ACTIVATE MSDIALOG oDlgMain CENTERED

    IF nOpc == 1
        Processa({|| xProdSit(@aProdutos,cDeSitObr,@aErro) },"Processando...","Aguarde.. alterando situa็ใo dos produtos",.F.)
    ENDIF


IF nOpc == 1 .AND. (Len(aProdutos) >0 .OR. Len(aErro))
    xMostraLog(cDeSitObr,aProdutos,aErro)
EndIF

MsgInfo('Fim do processamento')

Return nil

Static Function xRetSit(cCombo)

Local cRet   := ""

cRet := SubStr( cCombo , At("(",cCombo)+1 , 3 ) + ;
        "|" + ;
        SubStr( cCombo , At("(",cCombo, At("(",cCombo)+1 )+1, 3 )
IF AllTrim(cRet) == "|"
    cRet    := ""
ENDIF        

Return cRet

Static Function VldTok(aProdutos, cSitObr,aErro, cTpPub, cDeSitObr)

Local lRet      := .F.
Local aProdProd := {}
Local nAux      := 0
Local nLenProd  := 0
Local lTemSaldo := .F.
Local aDePara   := Separa(cDeSitObr, "|")
Local nQtdLido  := 0

IF Empty(cTpPub)
    MsgStop("Tipo de publica็ใo nใo informado")
    Return .F.
ENDIF

IF Empty(cDeSitObr) .OR. Len(aDePara) <> 2
    MsgStop("Op็ใo de altera็ใo nใo informada")
    Return .F.
ENDIF

aProdProd   := StrTokArr(cSitObr,Chr(13)+Chr(10))
nLenProd    := Len(aProdProd)

ProcRegua(nLenProd)
ZZL->(DbSetOrder( 1 ))
SB1->(DbSetOrder( 1 ))

For nAux := 1 To nLenProd

    IncProc("Validando "+cValToChar(nAux)+" de "+cValToChar(nLenProd))

    cProdAux    := OemToAnsi(FwCutOff(FwNoAccent(aProdProd[nAux]),.T.))
    lTemSaldo   := .T.

    IF Empty(AllTrim(cProdAux)) .OR. !xVldStr(cProdAux,@aErro,nAux)
        Loop
    ENDIF

    nQtdLido++

    IF !ZZL->(DbSeek( xFilial("ZZL") + cProdAux ))
        Aadd(aErro, { "Linha: "+cValToChar(nAux)+", Produto: "+cProdAux+", nใo localizado no Gestใo de Produtos", 0, 0, 0, cProdAux, "", 0 } )
        Loop
    ENDIF

    IF !SB1->(DbSeek( xFilial("SB1") + cProdAux ))
        Aadd(aErro, { "Linha: "+cValToChar(nAux)+", Produto: "+cProdAux+", nใo localizado no cadastro de produtos do comercial", 0, 0, 0, cProdAux , "", 0 } )
        Loop
    ENDIF

    nPosEmp := aScan(aEmpProd, {|x| AllTrim(x[1]) == AllTrim(SB1->B1_PROC) } )
    IF nPosEmp > 0
        cNomeEmp    := aEmpProd[nPosEmp][2]
    Else
        cNomeEmp    := ""    
    ENDIF
    

    IF !AllTrim(ZZL->ZZL_IDTPPU) == AllTrim(cTpPub)
        Aadd(aErro, { "Linha: "+cValToChar(nAux)+", Produto: "+cProdAux+", tipo de publica็ใo diferente do selecionado", 0, 0, 0, cProdAux, cNomeEmp, 0 } )
        Loop
    ENDIF

    IF !AllTrim(ZZL->ZZL_SITOBR) == AllTrim(aDePara[1])
        Aadd(aErro, { "Linha: "+cValToChar(nAux)+", Produto: "+cProdAux+", situa็ใo atual da obra ้ "+AllTrim(ZZL->ZZL_SITOBR)+" nใo serแ permitida a altera็ใo", 0, 0, 0, cProdAux, cNomeEmp, 0  } )
        Loop
    ENDIF

    IF Select("TMP_SALDO") > 0
        TMP_SALDO->(DbCloseArea())
    ENDIF

    BeginSql Alias "TMP_SALDO"
        SELECT B1_COD CODIGO
        ,B1_DESC DESCRICAO
        ,B1_ISBN ISBN
        ,B1_XIDTPPU PUBLICACAO
        ,B1_XSITOBR SITUACAO
        ,NVL((SELECT B2_QATU FROM %Table:SB2% S1 WHERE S1.B2_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022') AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '01' AND S1.%NotDel%),0) ORIGEM01
        ,NVL((SELECT B2_QATU FROM %Table:SB2% S1 WHERE S1.B2_FILIAL = '1022' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '01' AND S1.%NotDel%),0) GEN01

        ,NVL((SELECT B2_QATU FROM %Table:SB2% S1 WHERE S1.B2_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022') AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '02' AND S1.%NotDel%),0) ORIGEM02
        ,NVL((SELECT B2_QATU FROM %Table:SB2% S1 WHERE S1.B2_FILIAL = '1022' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '02' AND S1.%NotDel%),0) GEN02

        ,NVL((SELECT B2_QATU FROM %Table:SB2% S1 WHERE S1.B2_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022') AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '03' AND S1.%NotDel%),0) ORIGEM03
        ,NVL((SELECT B2_QATU FROM %Table:SB2% S1 WHERE S1.B2_FILIAL = '1022' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '03' AND S1.%NotDel%),0) GEN03

        ,NVL((SELECT B2_QATU FROM %Table:SB2% S1 WHERE S1.B2_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022') AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '04' AND S1.%NotDel%),0) ORIGEM04
        ,NVL((SELECT B2_QATU FROM %Table:SB2% S1 WHERE S1.B2_FILIAL = '1022' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '04' AND S1.%NotDel%),0) GEN04

        ,NVL((SELECT B2_QATU FROM %Table:SB2% S1 WHERE S1.B2_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022') AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '05' AND S1.%NotDel%),0) ORIGEM05
        ,NVL((SELECT B2_QATU FROM %Table:SB2% S1 WHERE S1.B2_FILIAL = '1022' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '05' AND S1.%NotDel%),0) GEN05 

        ,NVL((SELECT B2_QATU FROM %Table:SB2% S1 WHERE S1.B2_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022') AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '06' AND S1.%NotDel%),0) ORIGEM06
        ,NVL((SELECT B2_QATU FROM %Table:SB2% S1 WHERE S1.B2_FILIAL = '1022' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '06' AND S1.%NotDel%),0) GEN06

        ,NVL((SELECT SUM(B2_QATU) FROM %Table:SB2% S1 WHERE S1.B2_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022') AND S1.B2_COD = SB1.B1_COD AND S1.%NotDel%),0) ORIGEMT
        ,NVL((SELECT SUM(B2_QATU) FROM %Table:SB2% S1 WHERE S1.B2_FILIAL = '1022' AND S1.B2_COD = SB1.B1_COD AND S1.%NotDel%),0) GENT

        ,NVL((SELECT SUM(B61.B6_QUANT) FROM %Table:SB6% B61 WHERE B61.B6_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022') AND SB1.B1_COD = B61.B6_PRODUTO AND B61.B6_CLIFOR = '0005065' AND B61.B6_TIPO = 'E' AND B61.B6_TPCF = 'C' AND B61.B6_PODER3 = 'R' AND B61.%NotDel%),0) QCONORI
        ,NVL((SELECT SUM(B61.B6_QUANT) FROM %Table:SB6% B61 WHERE B61.B6_FILIAL = '1022' AND SB1.B1_COD = B61.B6_PRODUTO AND B61.B6_TIPO = 'D' AND B61.B6_TPCF = 'F' AND B61.B6_PODER3 = 'R' AND B61.%NotDel%),0) QCONGEN

        ,NVL((SELECT SUM(B61.B6_SALDO) FROM %Table:SB6% B61 WHERE B61.B6_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022') AND SB1.B1_COD = B61.B6_PRODUTO AND B61.B6_CLIFOR = '0005065' AND B61.B6_TIPO = 'E' AND B61.B6_TPCF = 'C' AND B61.B6_PODER3 = 'R' AND B61.%NotDel%),0) SCONORI
        ,NVL((SELECT SUM(B61.B6_SALDO) FROM %Table:SB6% B61 WHERE B61.B6_FILIAL = '1022' AND SB1.B1_COD = B61.B6_PRODUTO AND B61.B6_TIPO = 'D' AND B61.B6_TPCF = 'F' AND B61.B6_PODER3 = 'R' AND B61.%NotDel%),0) SCONGEN

        ,NVL((SELECT SUM(B61.B6_SALDO) FROM %Table:SB6% B61 WHERE B61.B6_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022') AND SB1.B1_COD = B61.B6_PRODUTO AND B61.B6_CLIFOR <> '0005065' AND B61.B6_TIPO = 'E' AND B61.B6_PODER3 = 'R' AND B61.%NotDel%),0) CONOUT
        ,NVL((SELECT SUM(B61.B6_SALDO) FROM %Table:SB6% B61 WHERE B61.B6_FILIAL = '1022' AND SB1.B1_COD = B61.B6_PRODUTO AND B61.B6_TIPO = 'E' AND B61.B6_PODER3 = 'R' AND B61.%NotDel%),0) CONMER

        FROM %Table:SB1% SB1
        WHERE SB1.B1_FILIAL = %xFilial:SB1%
        AND SB1.%NotDel%
        AND B1_COD = %Exp:cProdAux%
    EndSql

    IF TMP_SALDO->(!EOF())
        lTemSaldo := TMP_SALDO->( ORIGEMT + GENT + CONMER + CONOUT) > 0
    ELSE
        lTemSaldo := .F.
    ENDIF
    
    IF lTemSaldo
        Aadd(aErro, { "Linha: "+cValToChar(nAux)+", Produto: "+cProdAux+", produto contem saldo", TMP_SALDO->ORIGEMT, TMP_SALDO->GENT, TMP_SALDO->CONMER, cProdAux , cNomeEmp, TMP_SALDO->CONOUT } )
    ENDIF

    TMP_SALDO->(DbCloseArea())

    IF !lTemSaldo
        Aadd(aProdutos, { cProdAux, AllTrim(ZZL->ZZL_DESC) } )
    ENDIF    

Next nAux 

IF Len(aProdutos) == 0
    lRet    := .F.
    MsgStop("Nใo foram identificados produtos aptos a serem processados, processo serแ encerrado!")
    xMostraLog(cDeSitObr,aProdutos,aErro)
ELSEIF Len(aErro) > 0
    lRet := MsgYesNo("Foram identificados alguns produtos que nใo podem ser alterados."+Chr(13)+Chr(10)+;
            Chr(13)+Chr(10)+;
            "Produtos lidos: "+cValToChar(nQtdLido)+Chr(13)+Chr(10)+;
            "Produtos que podem ser alterados: "+cValToChar(Len(aProdutos))+Chr(13)+Chr(10)+;
            "Produtos com erro: "+cValToChar(Len(aErro))+Chr(13)+Chr(10)+;
            Chr(13)+Chr(10)+;
            "Deseja continuar com o processamento apenas para os produtos que podem ser alterados?"+Chr(13)+Chr(10)+;
            "Obs.: os produtos com erro nใo seram processados.";            
            )
ELSE
    lRet := MsgYesNo("Foram identificados "+cValToChar(Len(aProdutos))+" produtos aptos a serem alterados."+Chr(13)+Chr(10)+;
            "Confima a altera็ใo?";
            )
ENDIF

Return lRet


Static Function xProdSit(aProdutos,cDeSitObr,aErro)

Local nLenProd  := Len(aProdutos)
Local nAuxPrd   := 0
Local cFilSB1   := xFilial("SB1")
Local cFilZZL   := xFilial("ZZL")
Local cUpdHist  := ""
Local cSitAtu   := Separa(cDeSitObr,"|")[1]
Local cSitObr   := Separa(cDeSitObr,"|")[2]

ProcRegua(nLenProd)

SB1->(DbSetOrder(1))
ZZL->(DbSetOrder(1))

Begin Transaction

    For nAuxPrd := 1 To nLenProd
        IF SB1->(DbSeek( cFilSB1 + aProdutos[nAuxPrd][1] ))
            RecLock("SB1",.F.)
            SB1->B1_XSITOBR := cSitObr
            IF AllTrim(cSitObr) == "103"
                SB1->B1_MSBLQL   := "1"
            ENDIF
            MsUnLock()
        ENDIF

        IF ZZL->(DbSeek( cFilZZL + aProdutos[nAuxPrd][1] ))
            RecLock("ZZL",.F.)
            ZZL->ZZL_SITOBR := cSitObr
            ZZL->ZZL_DTALTE := DDataBase
            ZZL->ZZL_HALTER := Time()            
            MsUnLock()
        ENDIF

        cUpdHist := " UPDATE DBA_EGK.OBRA O SET IDSITUACAOOBRA = "+cSitObr+" WHERE IDOBRA = "+aProdutos[nAuxPrd][1]
        If ( TcSqlExec(cUpdHist)  < 0)
            aProdutos   := {}
            Aadd(aErro, { "Produto: "+aProdutos[nAuxPrd][1]+" - TCSQLError() " + TCSQLError() , 0, 0, 0,aProdutos[nAuxPrd][1], "", 0 } )

            MsgStop("Falha ao tentar atualizao Produto "+aProdutos[nAuxPrd][1]+" nas tabelas do legado, processo serแ finalizado."+Chr(13)+Chr(10)+;
            "TCSQLError() " + TCSQLError())

            DisarmTransaction()
            Exit
        Else
            
            cUpdHist	:= ""
            cUpdHist	+= "INSERT INTO SIS_DBA.SIS_AUDITORIA (QUANDO, QUEM, OPERACAO, TABELA, CAMPO, CHAVE, VALOR_ANTIGO, VALOR_NOVO)" 
            cUpdHist	+= "VALUES (SYSDATE, '"+AllTrim(UsrRetName(RetCodUsr()))+"', 'U', '"+RetSqlName("ZZL")+"', 'ZZL_SITOBR', '"+AllTrim(aProdutos[nAuxPrd][1])+"' , '"+cSitAtu+"', '"+AllTrim(cSitObr)+"')"
            TcSqlExec(cUpdHist)

        EndIf

    Next

End Transaction

Return nil


Static Function xMostraLog(cDeSitObr,aProdutos,aErro)

Local cArquivo	:= "LOG_"+DtoS(DDataBase)+"_"+StrTran(Time(),":","")+".xls"
Local oExcel 	:= FWMSEXCEL():New()
Local cPath		:= GetTempPath()
Local cSheetOK  := "Produtos alterados com sucesso De "+StrTran(cDeSitObr,"|"," Para ")
Local cTableOK  := "Produtos alterados com sucesso De "+StrTran(cDeSitObr,"|"," Para ")
Local cSheetNOk := "Produtos nใo processados ou com erro"
Local cTableNOk := "Produtos nใo processados ou com erro"
Local nAuxA     := 0


oExcel:AddworkSheet(cSheetOK)
oExcel:AddTable(cSheetOK,cTableOK)

//Alinhamento da coluna ( 1-Left,2-Center,3-Right )  //Codigo de formata็ใo ( 1-General,2-Number,3-Monetแrio,4-DateTime )
oExcel:AddColumn(cSheetOK,cTableOK,"Produto"    ,1,1)
oExcel:AddColumn(cSheetOK,cTableOK,"ID Produto" ,1,1)
oExcel:AddColumn(cSheetOK,cTableOK,"Observa็ใo" ,1,1)

oExcel:AddworkSheet(cSheetNOk)
oExcel:AddTable(cSheetNOk,cTableNOk)

//Alinhamento da coluna ( 1-Left,2-Center,3-Right )  //Codigo de formata็ใo ( 1-General,2-Number,3-Monetแrio,4-DateTime )
oExcel:AddColumn(cSheetNOk,cTableNOk,"ID Produto"       ,1,1)
oExcel:AddColumn(cSheetNOk,cTableNOk,"Erro"             ,1,1)
oExcel:AddColumn(cSheetNOk,cTableNOk,"Saldo Origem"     ,1,1)
oExcel:AddColumn(cSheetNOk,cTableNOk,"Saldo GEN"        ,1,1)
oExcel:AddColumn(cSheetNOk,cTableNOk,"Saldo Mercado"    ,1,1)
oExcel:AddColumn(cSheetNOk,cTableNOk,"Saldo Outros"     ,1,1)
oExcel:AddColumn(cSheetNOk,cTableNOk,"Empresa"          ,1,1)

For nAuxA := 1 To Len(aProdutos)
	oExcel:AddRow(cSheetOK,cTableOK,{;
		aProdutos[nAuxA][1],;
        aProdutos[nAuxA][2],;
        "Situa็ใo alterada com sucesso";
		})
Next

For nAuxA := 1 To Len(aErro)
	oExcel:AddRow(cSheetNOk,cTableNOk,{;
        aErro[nAuxA][5],;
		aErro[nAuxA][1],;
        cValToChar(aErro[nAuxA][2]),;
        cValToChar(aErro[nAuxA][3]),;
        cValToChar(aErro[nAuxA][4]),;
        cValToChar(aErro[nAuxA][7]),;
        aErro[nAuxA][6];
		})
Next

oExcel:Activate()
oExcel:GetXMLFile(cPath+cArquivo)
FreeObj(oExcel)

ShellExecute("Open", cPath+cArquivo, "", cPath, 10 )

Return nil


Static Function xVldStr(cProdAux,aErro,nLinha)

Local lRet  := .T.
Local cAux  := AllTrim(cProdAux)

While Len(cAux) > 0
    IF !IsDigit( Left(cAux,1) )
        Aadd(aErro, { "Linha: "+cValToChar(nLinha)+", Produto: "+cProdAux+", contem caracteres invแlidos no c๓digo do produto", 0, 0, 0, cProdAux, "", 0 } )
        lRet    := .F.
        Exit
    ENDIF
    cAux    := SubStr( cAux, 2, Len(cAux) )
EndDo

Return lRet
