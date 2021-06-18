#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "Report.ch"
#INCLUDE "RPTDEF.CH" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR070   บAutor  ณMicrosiga           บ Data ณ  07/01/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ RPA008 - PLANILHAS SINTETICAS A SEREM PAGAS                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function GENR070()

Local oReport
Local cPerg		:= "GENR070"    
Local cTempDir	:= GetTempPath()+"totvsprinter\" 
Local cFilename	:= CriaTrab(nil,.F.)
Local dDtPgto	:= CtoD("  /  /  ")
Local cDepto	:= ""

Private cDesDept	:= ""
Private cQrb		:= ""
Private cSigla		:= ""
Private cImgLogo	:= ""
Private oSection1	:= nil
Private oArial12T	:= TFont():New( "Arial",,12,,.T.,,,,,.F.)
Private oArial08	:= TFont():New( "Arial",,10,,.F.,,,,,.F.)

If !Pergunte(cPerg,.T.)
    Return nil
EndIf

dDtPgto := MV_PAR01
cDepto	:= MV_PAR02

oReport := ReportDef(cPerg,dDtPgto,cDepto)

If File(cTempDir+cFilename+".PDF")
	FErase(cTempDir+cFilename+".PDF")
EndIf

If File(cTempDir+cFilename+".PDF")
	FErase(cFilename+AllTrim(CriaTrab(nil,.f.)))
EndIf

oReport:SetDevice(6) 
oReport:SetEnvironment(1)
oReport:SetFile(cFilename)
oReport:NDEVICE			:= 6
oReport:CDIR			:= cTempDir
oReport:CFILE			:= cFilename
oReport:CPATHPDF		:= cTempDir
oReport:nEnvironment	:= 1
oReport:LPREVIEW		:= .F.          
oReport:LVIEWPDF		:= .F.
oReport:lParamPage		:= .F.
oReport:Print(.T.)

ShellExecute("Open", cTempDir+cFilename+".pdf", "", cTempDir, 1 )

oReport:FreeAllObjs()

Return nil

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg,dDtPgto,cDepto)

Local oReport

oReport := TReport():New("GENR070","RPA008 - PLANILHAS SINTETICAS A SEREM PAGAS EM "+Dtoc(dDtPgto),cPerg,{|oReport| PrintReport(oReport,dDtPgto,cDepto)},"PLANILHAS SINTETICAS A SEREM PAGAS EM "+Dtoc(dDtPgto))
/*
//Ajuste nas definicoes
oReport:nLineHeight		:= 50
oReport:cFontBody 		:= "Courier New"
oReport:nFontBody 		:= 9    		&& 10
oReport:lHeaderVisible	:= .T.  
oReport:lDisableOrientation := .T.
*/  
//oReport:SetLogo( "\SYSTEM\DANFE001022.png" ) 
oReport:SetCustomText({|| Cabec(oReport,dDtPgto,cDepto) }) 
oReport:bOnPageBreak	:= {|| /*oReport:PrtLogo()*/oReport:SayBitmap ( -050, 000 , "\SYSTEM\DANFE00"+cImgLogo+".png" , 280 , 220 ) }
oReport:SetPageFooter(1, {|| ;
							oReport:Say ( oReport:PageHeight(.F.)*0.97 , 10 , "Emissใo:   "+DtoC(DDataBase)+" - "+Time()+" - "+Capital(AllTrim(UsrRetName(RetCodUsr()))) , oArial08 , oReport:PageWidth()/2 , nil , nil ),;
							oReport:Say ( oReport:PageHeight(.F.)*0.97 , oReport:PageWidth()/2 , "Pag. "+AllTrim(Str(oReport:Page())) , oArial08 , oReport:PageWidth() , nil , nil );
							},.F.)//(nLinesFooter,bPageFooter,lFooterBefore)							
							//oReport:PrintText("Pag. "+AllTrim(Str(oReport:Page())), oReport:PageHeight(.F.)*0.98, oReport:PageWidth()/2);
oReport:HideFooter()
oReport:SetPortrait()    

//Secao do relatorio
oSection1 := TRSection():New(oReport," ",,,,,,,,,,,,,,,,,,,)//,,,,,,,,,.T.,,,,,,,,,,80)

//Celulas da secao
TRCell():New(oSection1,"SIGLA"			,"TMP_TAB","SIGLA","",20)
TRCell():New(oSection1,"PLANILHA"		,"TMP_TAB","PLANILHA","@E 9999999",30,,,,,"LEFT")
TRCell():New(oSection1,"COLAB"			,"TMP_TAB","COLABORADOR",,100)
TRCell():New(oSection1,"QTDE"			,"TMP_TAB","QTDE",'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection1,"BRUTO"			,"TMP_TAB","VALOR BRUTO",'@E 999,999,999.99',30,,,,,"RIGHT")
TRCell():New(oSection1,"ST"				,"TMP_TAB","SITUAวรO",,30)
//oSection1:SetPercentage(80)

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

Static Function PrintReport(oReport,dDtPgto,cDepto)

Local cAlias1		:= GetNextAlias()
Local cQuery		:= ""
Local aEmpAux		:= FWLoadSM0()
Local nTotBruto		:= 0
Local nTotQtde		:= 0
Local bImpTot		:= {|x| ;
							oReport:IncRow(2),;
							oReport:ThinLine(),; 
							oSection1:Cell("SIGLA"):SetValue( " " ),; 
							oSection1:Cell("PLANILHA"):SetValue( " " ),;
							oSection1:Cell("COLAB"):SetAlign("RIGHT"),;
							oSection1:Cell("COLAB"):SetValue( " TOTAL A SER PAGO NO DIA ("+DtoC(dDtPgto)+") "+Replicate("-",200) ),; 
							oSection1:Cell("QTDE"):SetValue(nTotQtde),;
							oSection1:Cell("BRUTO"):SetValue(nTotBruto),;
							oSection1:Cell("ST"):SetValue(" "),;
							oSection1:PrintLine()}

Local bImpAss		:= {|x| oReport:SkipLine(5),;
							oReport:PrintText("APROVADO PARA PAGAMENTO",oReport:PageWidth()/2),;
							oReport:SkipLine(3),;
							oReport:PrtCenter(Replicate("_",150)),;
							oReport:SkipLine(2),;
							oReport:PrtCenter("VISTO (DEPARTAMENTO)"),;
							oReport:SkipLine(2),;
							oReport:PrtCenter(cDesDept);
							}

oSection1		:= oReport:Section(1)

//BeginSQL Alias cAlias1  

cQuery += " SELECT Z1_FILIAL,Z1_DEPTO,TRIM(ZZC_DESC) ZZC_DESC,
cQuery += " Z1_FILIAL SIGLA,SZ1.Z1_IDSEQ PLANILHA, Z1_FORNECE||'-'||Z1_LOJA||' '||TRIM(Z1_NOME) COLABORADOR,Z1_HORAS QTDE, Z1_VALOR BRUTO,
cQuery += " DECODE(Z1_STATUS,'1','Digitado','2','Integrado Fin/Gpe','3','Suspenso','4','Cancelado') ST
cQuery += " FROM "+RetSqlName("SZ1")+" SZ1

cQuery += " JOIN "+RetSqlName("ZZC")+" ZZC
cQuery += " ON ZZC_FILIAL = '"+xFilial("ZZC")+"'
cQuery += " AND ZZC_TABELA = 'ZX'
cQuery += " AND ZZC_CHAVE = Z1_DEPTO
cQuery += " AND ZZC.D_E_L_E_T_ <> '*'

cQuery += " WHERE SZ1.D_E_L_E_T_ <> '*'
cQuery += " AND Z1_DATA = '"+DtoS(dDtPgto)+"'
IF !Empty(cDepto)
	cQuery += " AND Z1_DEPTO = '"+cDepto+"'
ENDIF 
cQuery += " AND SZ1.D_E_L_E_T_ <> '*'
cQuery += " ORDER BY Z1_FILIAL,Z1_DEPTO,Z1_FORNECE,Z1_IDSEQ

//EndSQL
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias1, .F., .T.)
(cAlias1)->(DbgoTop())

cQrb 		:= (cAlias1)->Z1_FILIAL+(cAlias1)->Z1_DEPTO 
cImgLogo	:= Alltrim((cAlias1)->Z1_FILIAL)
cDesDept	:= Alltrim((cAlias1)->ZZC_DESC)

(cAlias1)->(DbGoTop())
oSection1:Init()

While (cAlias1)->(!EOF())
	
	cImgLogo	:= Alltrim((cAlias1)->Z1_FILIAL)
	cDesDept	:= Alltrim((cAlias1)->ZZC_DESC)

	If oReport:Cancel()
		Return nil
	EndIF

	If aScan(aEmpAux,{|x| AllTrim(x[2]) == AllTrim((cAlias1)->SIGLA) }) > 0
		cSigla	:=  AllTrim(aEmpAux[ aScan(aEmpAux,{|x| AllTrim(x[2]) == AllTrim((cAlias1)->SIGLA) }) ][7])
	else
		cSigla	:= AllTrim((cAlias1)->SIGLA)	
	EndIf

	/*
	IF "/" $ cSigla
		cSigla := Left(cSigla, At("/",cSigla)-1 )
	ENDIF
	*/
	
	If cQrb <> (cAlias1)->Z1_FILIAL+(cAlias1)->Z1_DEPTO
		cQrb := (cAlias1)->Z1_FILIAL+(cAlias1)->Z1_DEPTO
		oReport:StartPage()
		oSection1:Init()
	EndIF	

	oSection1:Cell("SIGLA"):SetValue( cSigla ) 
	oSection1:Cell("PLANILHA"):SetValue((cAlias1)->PLANILHA)
	oSection1:Cell("COLAB"):SetAlign("LEFT")
	oSection1:Cell("COLAB"):SetValue((cAlias1)->COLABORADOR) 
	oSection1:Cell("QTDE"):SetValue((cAlias1)->QTDE)
	oSection1:Cell("BRUTO"):SetValue((cAlias1)->QTDE*(cAlias1)->BRUTO) 
	oSection1:Cell("ST"):SetValue((cAlias1)->ST) 

	oSection1:PrintLine()	

	nTotBruto	+= (cAlias1)->QTDE*(cAlias1)->BRUTO
	nTotQtde	+= (cAlias1)->QTDE

	(cAlias1)->(DbSkip())	

	If cQrb <> (cAlias1)->Z1_FILIAL+(cAlias1)->Z1_DEPTO
		eVal(bImpTot)
		eVal(bImpAss)
		oReport:EndPage()
		nTotBruto	:= 0
		nTotQtde	:= 0
	EndIF	

EndDo

Return(.T.)

Static Function Cabec(oReport,dDtPgto,cDepto)

Local aCabec	:= {} 
Local cChar		:= chr(160) // caracter dummy para alinhamento do cabe็alho 

oReport:IncRow(170)
oReport:Say ( oReport:Row()+30 , oReport:GetWidth()*0.30 , UPPER(AllTrim(oReport:Title())) , oArial12T , oReport:GetWidth() , nil , nil )
oReport:Say ( oReport:Row()+30 , oReport:GetWidth()*0.90 , cSigla , oArial12T , oReport:GetWidth() , nil , nil )

Aadd(aCabec,cChar + "        " + cChar)
Aadd(aCabec,cChar + "        " + cChar)

Return aCabec