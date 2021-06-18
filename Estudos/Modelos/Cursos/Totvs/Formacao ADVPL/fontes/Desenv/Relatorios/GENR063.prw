#include "protheus.ch"
#include "topconn.ch"
#Include "Report.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR063   บAutor  ณCleuto Lima - Loop  บ Data ณ  06/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de acompanhamento intercompnay por obra.          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function GENR063J()

Local alEmp 		:= {}
Local lEmp			:= Type('cFilAnt') == "C" .AND. Select("SM0") <> 0
Local nAuxEmp		:= 0
Local nX			:= 0
Local nLimite		:= 50  

Conout("GENR063J - Iniciando Job - Analise Notas InterCompany - "+Time()+".")

If !lEmp		
	RpcSetType(3)
	lOpenSM0 := RpcSetEnv( "00" , "1022")
	If !lOpenSM0
		ConOut("")
	   	ConOut(Replicate("+",nLimite))
	   	ConOut(Padc("GENR063J - Nao foi possivel incializar ambiente confirme a senha/usuario digitado. "+Dtoc(Date())+" "+Time(),nLimite))
	   	ConOut(Replicate("+",nLimite))
	   	ConOut("") 
	   	RpcClearEnv()
		Return Nil
	Else
		Conout("GENR063J - Abrindo empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())		
	EndIf
EndIF   

While !LockByName("GENR063J",.T.,.T.,.T.)
    nX++
	Sleep(10)
	If nX > 2     
		Conout("GENR063J - Nใo foi possํvel executar a Analise Notas InterCompany neste momento pois a fun็ใo GENR063J jแ esta sendo executada por outra processamento!"+DTOC(DDataBase)+" "+Time())
		Return .F.
    EndIf
EndDo

U_GENR063(.T.)

If !lEmp .AND. Type('cFilAnt') == "C"
	Conout("GENR063J - Fechando empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())	
	RpcClearEnv()
EndIF

UnLockByName("GENR063J",.T.,.T.,.T.)

Conout("GENR063J - Finalizando Job - Analise Notas InterCompany- "+Time()+".")

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR063   บAutor  ณMicrosiga           บ Data ณ  01/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENR063(lJob)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cPerg		:= "GENR063"
Local nPeriMnt	:= SuperGetMv("GEN_FAT144",.F.,30)

Private lQuebra	:= .T.
Private cQryAlias	:= GetNextAlias()

Default lJob	:= .F.

//AjustaSX1(cPerg)

If !lJob
	If !Pergunte(cPerg,.T.)
		Return nil
	EndIF
Else

	Pergunte(cPerg,.F.)
	
	MV_PAR01 := DDataBase-nPeriMnt//cTod("31/12/2016")
	MV_PAR02 := DDataBase//cTod("31/12/2016")
	MV_PAR03 := ""
	MV_PAR04 := ""
	MV_PAR05 := 3
	MV_PAR06 := 3
	
EndIf

If !lJob
	oReport := ReportDef(cPerg)
	oReport:PrintDialog()
Else
	MailAcomp(lJob)
EndIf	

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR063   บAutor  ณMicrosiga           บ Data ณ  01/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MailAcomp(lJob)

Local cArquivo	:= "ACOMPANAHMENTO_INTERCOMPANY"+DtoS(DDataBase)+StrTran(Time(),":","")+".xls"
Local oExcel 	:= FWMSEXCEL():New()
Local cPath		:= "\workflow\Anexos\InterCompany\" //Diretorio de gravacao de arquivos
Local lMail		:= .F.
Local cSheet	:= "Intercompnay por Obra"
Local cSheet2	:= "Destino sem Origem"
Local cTable	:= "Intercompnay por Obra"
Local cMailMnt	:= SuperGetMv("GEN_FAT145",.F.,"cleuto.lima@grupogen.com.br")

WFForceDir(cPath)

//If !ApOleClient( 'MsExcel' )
//	MsgAlert( 'MsExcel nao instalado' )
//	Return
//EndIf

oExcel:AddworkSheet(cSheet)
oExcel:AddTable (cSheet,cTable)

//Alinhamento da coluna ( 1-Left,2-Center,3-Right )  //Codigo de formata็ใo ( 1-General,2-Number,3-Monetแrio,4-DateTime )
oExcel:AddColumn(cSheet,cTable,"Filial Origem"	   			,1,1)
oExcel:AddColumn(cSheet,cTable,"Documento"	   				,1,1)
oExcel:AddColumn(cSheet,cTable,"Serie"	   		  			,1,1)
oExcel:AddColumn(cSheet,cTable,"Emissใo"	   				,1,1)
oExcel:AddColumn(cSheet,cTable,"Valor Origem"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"Valor Destino"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"CGC Destino"	   			,1,1)
oExcel:AddColumn(cSheet,cTable,"Nome Destino"	   			,1,1)
oExcel:AddColumn(cSheet,cTable,"Situa็ใo Nota"	   			,1,1)
oExcel:AddColumn(cSheet,cTable,"Obra"	   		   			,1,1)
oExcel:AddColumn(cSheet,cTable,"Titulo"	   					,1,1)
oExcel:AddColumn(cSheet,cTable,"Quantidade Origem"	   		,3,2)
oExcel:AddColumn(cSheet,cTable,"Valor Origem"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"Quantidade Destino"	   		,3,2)
oExcel:AddColumn(cSheet,cTable,"Valor Destino"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"Sit.Qtd.Obra"	   			,1,1)
oExcel:AddColumn(cSheet,cTable,"Sit.Vlr.Obra"	   			,1,1)
oExcel:AddColumn(cSheet,cTable,"Chave"	   					,1,1)

oExcel:AddworkSheet(cSheet2)
oExcel:AddTable (cSheet2,cTable)

oExcel:AddColumn(cSheet2,cTable,"Filial Destino"	   		,1,1)
oExcel:AddColumn(cSheet2,cTable,"Documento"	   				,1,1)
oExcel:AddColumn(cSheet2,cTable,"Serie"	   		  			,1,1)
oExcel:AddColumn(cSheet2,cTable,"Obra"	   					,1,1)
oExcel:AddColumn(cSheet2,cTable,"Descri็ใo"	   				,1,1)
oExcel:AddColumn(cSheet2,cTable,"Tipo de Publica็ใo"	   	,1,1)
oExcel:AddColumn(cSheet2,cTable,"Situa็ใo da Obras"			,1,1)
oExcel:AddColumn(cSheet2,cTable,"Grupo"		   				,1,1)
oExcel:AddColumn(cSheet2,cTable,"Pre็o de Tabela"  			,1,1)
oExcel:AddColumn(cSheet2,cTable,"Emissใo da Nota"  			,1,1)
oExcel:AddColumn(cSheet2,cTable,"Dt.Digita็ใo"	   			,1,1)
oExcel:AddColumn(cSheet2,cTable,"Fornecedor"	   			,1,1)
oExcel:AddColumn(cSheet2,cTable,"Filial Origem"		   		,1,1)
oExcel:AddColumn(cSheet2,cTable,"Achou Emissใo Deletada?"	,1,1)

PrintReport(oExcel,lJob,@lMail)

If lMail
	oExcel:Activate()
	oExcel:GetXMLFile(cPath+cArquivo)
	
	If File(cPath+cArquivo)
		
		U_GenSendMail(,,,"noreply@grupogen.com.br",cMailMnt,"Acompanhamento Inter Company",RetBodyEmail(),cPath+cArquivo,,.F.)
		
		/*
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณGera objeto html.                                                                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oProcess := TWFProcess():New( "000001", "Envio de Analise Intercompany" )
		oProcess:NewTask("Envio Informe","\workflow\HTML\RelInterCompany.htm")
		oProcess:cTo		:= "cleuto.lima@grupogen.com.br"
		//oProcess:CCC		:= MV_PAR05
		//cBCC
		oProcess:cSubject	:= "Acompanhamento Inter Company"
		
		oProcess:ohtml:ValByName("cDtProc", DtoC(DDataBase) )
		
		oProcess:AttachFile(cPath+cArquivo,.F.)
		
		oProcess:Start()
		WFSENDMAIL({cEmpAnt,cFilAnt})
		
		FreeObj(oProcess)		
		oProcess	:= nil		
		*/
	EndIf
	
EndIf	
FreeObj(oExcel)

//oExcelApp := MsExcel():New()
//oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha
//oExcelApp:SetVisible(.T.)

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR063   บAutor  ณCleuto Lima - Loop  บ Data ณ  06/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de acompanhamento intercompnay.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef(cPerg)

Local oReport
Local oSection1

Local aOrdem	:= {}

//Declaracao do relatorio
oReport := TReport():New("GENR063","Acompanhamento Inter Company"	,cPerg		,{|oReport| PrintReport(oReport)},"Acompanhamento Inter Company") 
oReport:PrintHeader(.F.,.F.)
//Ajuste nas definicoes
oReport:nLineHeight := 55
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7		&& 10
oReport:lHeaderVisible := .F. 
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Acompanhamento Inter Company Analitico",{cQryAlias,"NAOUSADO"},aOrdem)
oSection2 := TRSection():New(oReport,"Destino sem Origem",{cQryAlias,"NAOUSADO"},aOrdem)

//Celulas da secao
TRCell():New(oSection1,"F2_FILIAL"	,cQryAlias,"Filial Origem"	,,15)
TRCell():New(oSection1,"F2_DOC"		,cQryAlias,"Documento"	  	,,20)
TRCell():New(oSection1,"F2_SERIE"	,cQryAlias,"Serie"		  	,,10)
TRCell():New(oSection1,"F2_EMISSAO"	,cQryAlias,"Emissใo"		,,15)
TRCell():New(oSection1,"VAL_ORIGEM"	,cQryAlias,"Valor Origem"	,PesqPict('SF2',"F2_VALBRUT"),20)
TRCell():New(oSection1,"VAL_DESTIN"	,cQryAlias,"Valor Destino"	,PesqPict('SF2',"F2_VALBRUT"),20)
TRCell():New(oSection1,"CGC"		,cQryAlias,"CGC Destino"	,,15)
TRCell():New(oSection1,"NOME"		,cQryAlias,"Nome Destino"	,,50)
TRCell():New(oSection1,"SITUACAO"	,cQryAlias,"Situa็ใo Nota"	,,50)

TRCell():New(oSection1,"OBRA"		,cQryAlias,"Obra"	,,50)
TRCell():New(oSection1,"TITULO"		,cQryAlias,"Titulo"	,,50)
TRCell():New(oSection1,"QTDORIG"	,cQryAlias,"Quantidade Origem"	,,50)
TRCell():New(oSection1,"VALORIG"	,cQryAlias,"Valor Origem"  		,,50)
TRCell():New(oSection1,"QTDDEST"	,cQryAlias,"Quantidade Destino"	,,50)
TRCell():New(oSection1,"VALDEST"	,cQryAlias,"Valor Destino" 		,,50)
TRCell():New(oSection1,"SITQTD"		,cQryAlias,"Sit.Qtd.Obra" 		,,50)
TRCell():New(oSection1,"SITVAL"		,cQryAlias,"Sit.Vlr.Obra" 		,,50)

TRCell():New(oSection1,"CHVNFE"		,cQryAlias,"Chave"		   		,,50)

TRCell():New(oSection2,"D1_FILIAL"	   		,"ORINODEST","Filial Destino"			,,15)
TRCell():New(oSection2,"D1_DOC"	   			,"ORINODEST","Documento"				,,20)
TRCell():New(oSection2,"D1_SERIE"	   		,"ORINODEST","Serie"					,,10)
TRCell():New(oSection2,"D1_COD"	   			,"ORINODEST","Obra"					,,50)
TRCell():New(oSection2,"B1_DESC"	   		,"ORINODEST","Descri็ใo"				,,50)
TRCell():New(oSection2,"X5_DESCRI"	   		,"ORINODEST","Tipo de Publica็ใo"		,,50)
TRCell():New(oSection2,"Z4_DESC"			,"ORINODEST","Situa็ใo da Obras"		,,50)
TRCell():New(oSection2,"BM_DESC"		   	,"ORINODEST","Grupo"					,,50)
TRCell():New(oSection2,"DA1_PRCVEN"  		,"ORINODEST","Pre็o de Tabela"		,PesqPict('SF2',"F2_VALBRUT"),20)
TRCell():New(oSection2,"D1_EMISSAO"  		,"ORINODEST","Emissใo da Nota"		,,20)
TRCell():New(oSection2,"D1_DTDIGIT"	   		,"ORINODEST","Dt.Digita็ใo"			,,20)
TRCell():New(oSection2,"D1_FORNECE"	   		,"ORINODEST","Fornecedor"				,,20)
TRCell():New(oSection2,"FIL_ORI"		   	,"ORINODEST","Filial Origem"			,,15)
TRCell():New(oSection2,"NF_ORI_DEL"			,"ORINODEST","Achou Emissใo Deletada?",,15)

//Faz a impressao do totalizador em linha
oSection1:SetHeaderPage(.F.)
oSection1:SetLeftMargin(2)
oSection1:lPrintHeader := .F.

//Faz a impressao do totalizador em linha
oSection2:SetHeaderPage(.F.)
oSection2:SetLeftMargin(2)
oSection2:lPrintHeader := .F.

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR063   บAutor  ณCleuto Lima - Loop  บ Data ณ  06/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de acompanhamento intercompnay.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function PrintReport(oReport,lJob,lMail)

Local oSection1 := nil
Local oSection2	:= nil
Local cQuery	:= ""
Local cSqlExec	:= ""
Local cQuebra	:= Chr(13)+Chr(10)
Local aAreaSM0	:= SM0->(GetArea())
Local cTabConsi	:= GetMv("GEN_FAT006")

Local aEstrutura	:= {	{'M0CODFIL','C',12,0}, {'M0FILIAL','C',40,0}, {'M0NOMECOM','C',50,0},	{'M0CGC','C',14,0},{'M0INSC','C',14,0}}

Local cSheet	:= "Intercompnay por Obra"
Local cSheet2	:= "Destino sem Origem"
Local cTable	:= "Intercompnay por Obra"

Default lJob	:= .F.  
Default lMail	:= .F.

If !lJob
	oSection1 := oReport:Section(1)
	oSection2 := oReport:Section(2)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAUX_EMPGEN: tabela auxiliar com os dados do EMPGENณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cSqlExec := "DROP TABLE AUX_EMPGEN"
TCSQLExec(cSqlExec)

cSqlExec := "COMMIT"
TCSQLExec(cSqlExec)

DBCreate ( "AUX_EMPGEN" , aEstrutura ,	"TOPCONN" )
//USE "AUX_EMPGEN" VIA "TOPCONN"
DbUseArea(.T., 'TOPCONN', "AUX_EMPGEN" , "AUX_EMPGEN", .F., .F.)

//SM0->(DbGoTop())
//While SM0->(!EOF())
aSM0 := FWLoadSM0()

For nSM0 := 1 To Len(aSM0)

	RecLock("AUX_EMPGEN",.T.)
	AUX_EMPGEN->M0CODFIL	:= aSm0[nSM0][2]
	AUX_EMPGEN->M0FILIAL	:= aSm0[nSM0][6]
	AUX_EMPGEN->M0NOMECOM	:= aSm0[nSM0][17]
	AUX_EMPGEN->M0CGC		:= aSm0[nSM0][18]
	AUX_EMPGEN->M0INSC		:= Posicione("SM0",1,aSm0[nSM0][1]+aSm0[nSM0][2],"M0_INSC")
	AUX_EMPGEN->(MsUnLock())

Next nSM0	
//	SM0->(DbSkip())
//EndDo

AUX_EMPGEN->(DbCloseArea())
RestArea(aAreaSM0)
/*
cQuery += " SELECT "
cQuery += " F2_TIPO,F2_FILIAL,F2_DOC,F2_SERIE,To_Date(F2_EMISSAO,'YYYYMMDD') F2_EMISSAO,"+cQuebra
cQuery += ' "VALOR ORIGEM" VAL_ORIGEM, "VALOR DESTINO" VAL_DESTIN, CGC, DESTINO '+cQuebra
cQuery += ' ,CASE WHEN "VALOR DESTINO" IS NULL THEN '+"'NOTA NรO ENCONTRADA NO DESTINO' WHEN "+'"VALOR DESTINO" <> "VALOR ORIGEM" THEN '+"'NOTA ORIGEM COM VALOR DIVERGENTE DA NOTA DESTINO' ELSE 'NOTA OK' END SITUACAO, F2_CHVNFE CHVNFE "+cQuebra 
*/

cQuery += " SELECT "+cQuebra
cQuery += "   CASE WHEN D1_QUANT IS NULL THEN 'PRODUTO NรO ENCONTRADO NO DESTINO' WHEN D2_QUANT <> D1_QUANT THEN 'PRODUTO ORIGEM COM QUANTIDADE DIVERGENTE DO PRODUTO DESTINO' ELSE 'QUANTIDADE OK' END SIT_QUANT "+cQuebra
cQuery += "  ,CASE WHEN D1_TOTAL IS NULL THEN 'PRODUTO NรO ENCONTRADO NO DESTINO' WHEN D2_TOTAL <> D1_TOTAL THEN 'PRODUTO ORIGEM COM VALOR DIVERGENTE DO PRODUTO DESTINO' ELSE 'VALOR OK' END SIT_VALOR "+cQuebra
cQuery += "  ,TMP2.* FROM ( "+cQuebra
//cQuery += "  SELECT F2_TIPO,F2_FILIAL,F2_DOC,F2_SERIE,To_Date(F2_EMISSAO,'YYYYMMDD') F2_EMISSAO, "+cQuebra
cQuery += "  SELECT F2_TIPO,F2_FILIAL,F2_DOC,F2_SERIE, F2_EMISSAO, "+cQuebra
cQuery += '  "VALOR ORIGEM" VAL_ORIGEM, "VALOR DESTINO" VAL_DESTIN,FIL_DEST, CGC, DESTINO,COD_DEST,LOJA_DEST  '+cQuebra
cQuery += "  , B1_COD,B1_DESC "+cQuebra
cQuery += "  , D2_QUANT, D2_TOTAL "+cQuebra
cQuery += "  , SUM(D1_QUANT) D1_QUANT, SUM(D1_TOTAL-D1_VALDESC) D1_TOTAL "+cQuebra
cQuery += '  ,CASE WHEN "VALOR DESTINO"'+" IS NULL THEN 'NOTA NรO ENCONTRADA NO DESTINO'"+' WHEN "VALOR DESTINO" <> "VALOR ORIGEM"'+" THEN 'NOTA ORIGEM COM VALOR DIVERGENTE DA NOTA DESTINO' ELSE 'NOTA OK' END SITUACAO "+cQuebra
cQuery += "  , F2_CHVNFE CHVNFE  "+cQuebra
 
cQuery += " FROM ( "+cQuebra                                                                                                                                                                                                             

//cQuery += " SELECT F2_TIPO,F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALBRUT "+'"VALOR ORIGEM",F1_VALBRUT "VALOR DESTINO",A2_CGC CGC,'+"'SA2 - '"+'||A2_NOME DESTINO,F2_CHVNFE , B1_COD,B1_DESC FROM '+RetSqlName("SF2")+" SF2 "+cQuebra  
cQuery += ' SELECT F2_TIPO,F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALBRUT "VALOR ORIGEM",F1_VALBRUT "VALOR DESTINO",F1_FILIAL FIL_DEST,A2_CGC CGC,'+"'SA2 - '||A2_NOME DESTINO,A1_COD COD_DEST,A1_LOJA LOJA_DEST,F2_CHVNFE , B1_COD,B1_DESC,SUM(D2_QUANT) D2_QUANT,SUM(D2_TOTAL) D2_TOTAL FROM "+RetSqlName("SF2")+" SF2 "+cQuebra   

cQuery += " JOIN "+RetSqlName("SA2")+" SA2 "+cQuebra
cQuery += " ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' "+cQuebra
cQuery += " AND SA2.A2_COD = F2_CLIENTE "+cQuebra
cQuery += " AND SA2.A2_LOJA = F2_LOJA "+cQuebra
If !Empty(MV_PAR04)
	cQuery += " AND SA2.A2_CGC IN ( SELECT M0CGC FROM AUX_EMPGEN WHERE TRIM(M0CODFIL) = '"+AllTrim(MV_PAR04)+"') "+cQuebra
Else
	cQuery += " AND SA2.A2_CGC IN ( SELECT M0CGC FROM AUX_EMPGEN ) "+cQuebra
EndIF	
cQuery += " AND SA2.D_E_L_E_T_ <> '*' "+cQuebra

cQuery += " JOIN "+RetSqlName("SD2")+" SD2 "+cQuebra
cQuery += " ON D2_FILIAL = F2_FILIAL "+cQuebra
cQuery += " AND D2_CLIENTE = F2_CLIENTE "+cQuebra
cQuery += " AND D2_LOJA = F2_LOJA "+cQuebra
cQuery += " AND D2_DOC = F2_DOC "+cQuebra
cQuery += " AND D2_SERIE = F2_SERIE "+cQuebra
cQuery += " AND SD2.D_E_L_E_T_ <> '*'  "+cQuebra

cQuery += " JOIN "+RetSqlName("SB1")+" SB1 "+cQuebra
cQuery += " ON B1_FILIAL = '"+xFilial("SB1")+"' "+cQuebra
cQuery += " AND B1_COD = D2_COD "+cQuebra
cQuery += " AND SB1.D_E_L_E_T_ <> '*' "+cQuebra

cQuery += " JOIN "+RetSqlName("SA1")+" SA1 "+cQuebra
cQuery += " ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+cQuebra
cQuery += " AND SA1.A1_CGC = ( SELECT TRIM(M0CGC) FROM AUX_EMPGEN WHERE TRIM(M0CODFIL) = TRIM(SF2.F2_FILIAL) ) "+cQuebra
cQuery += " AND SA1.D_E_L_E_T_ <> '*' "+cQuebra

If MV_PAR05 == 2
	cQuery += " JOIN "+RetSqlName("SF1")+" SF1 "+cQuebra 
Else
	cQuery += " LEFT JOIN "+RetSqlName("SF1")+" SF1 "+cQuebra 
EndIf	

cQuery += " ON SF1.F1_FILIAL IN ( SELECT TRIM(B.M0CODFIL) FROM AUX_EMPGEN B WHERE TRIM(B.M0CGC) = TRIM(SA2.A2_CGC) AND TRIM(B.M0INSC) = TRIM(REPLACE(REPLACE(SA2.A2_INSCR,'.',''),'-',''))) "+cQuebra
cQuery += " AND LPAD(TRIM(SF1.F1_DOC),9,'0') = LPAD(TRIM(F2_DOC),9,'0') "+cQuebra
cQuery += " AND SF1.F1_SERIE = F2_SERIE "+cQuebra
cQuery += " AND SF1.F1_FORNECE = A1_COD "+cQuebra
cQuery += " AND SF1.F1_LOJA = A1_LOJA "+cQuebra
cQuery += " AND SF1.D_E_L_E_T_ <> '*' "+cQuebra

If Empty(MV_PAR03)
	cQuery += " WHERE F2_FILIAL IN ( SELECT M0CODFIL FROM AUX_EMPGEN ) "+cQuebra
	cQuery += " AND F2_TIPO IN ('D','B') "+cQuebra
Else
	cQuery += " WHERE F2_FILIAL = '"+MV_PAR03+"' "+cQuebra
	cQuery += " AND F2_TIPO IN ('D','B') "+cQuebra
EndIF	

// CLEUTO - 29/05/2017 - INCLUIDO FILTRO PARA NรO CONSIDERAR AS NOTAS FISCAIS EMITIDAS CONTA A PROPRIA EMPRESA
cQuery += " AND F2_FILIAL NOT IN (SELECT M0CODFIL FROM AUX_EMPGEN WHERE TRIM(M0CGC) = TRIM(SA2.A2_CGC)) "+cQuebra

cQuery += " AND F2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "+cQuebra
cQuery += " AND SF2.D_E_L_E_T_ <> '*' "+cQuebra
//cQuery += " AND ( F1_VALBRUT IS NULL OR F1_VALBRUT <> F2_VALBRUT) "+cQuebra 
If MV_PAR05 == 2
	cQuery += " AND F1_VALBRUT = F2_VALBRUT "+cQuebra
ElseIf MV_PAR05 == 3
	cQuery += " AND ( F1_VALBRUT IS NULL OR F1_VALBRUT <> F2_VALBRUT) "+cQuebra
EndIf	

cQuery += "  GROUP BY F2_TIPO,F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALBRUT,F1_VALBRUT,F1_FILIAL,A2_CGC,A2_NOME ,F2_CHVNFE , B1_COD,B1_DESC,A1_COD ,A1_LOJA  "+cQuebra

cQuery += " UNION ALL "+cQuebra
//cQuery += " SELECT F2_TIPO,F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALBRUT "+'"VALOR ORIGEM",F1_VALBRUT "VALOR DESTINO",A1_CGC CGC,'+"'SA1 - '"+'||A1_NOME DESTINO ' + ", F2_CHVNFE , B1_COD,B1_DESC  FROM "+RetSqlName("SF2")+" SF2 "
cQuery += ' SELECT F2_TIPO,F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALBRUT "VALOR ORIGEM",F1_VALBRUT "VALOR DESTINO",F1_FILIAL FIL_DEST,A1_CGC CGC,'+"'SA1 - '||A1_NOME DESTINO,A2_COD COD_DEST,A2_LOJA LOJA_DEST , F2_CHVNFE , B1_COD,B1_DESC,SUM(D2_QUANT) D2_QUANT,SUM(D2_TOTAL) D2_TOTAL  FROM "+RetSqlName("SF2")+" SF2 "


cQuery += " JOIN "+RetSqlName("SA1")+" SA1 "+cQuebra
cQuery += " ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+cQuebra
cQuery += " AND SA1.A1_COD = F2_CLIENTE "+cQuebra
cQuery += " AND SA1.A1_LOJA = F2_LOJA "+cQuebra       
If !Empty(MV_PAR04)
	cQuery += " AND SA1.A1_CGC IN ( SELECT M0CGC FROM AUX_EMPGEN WHERE TRIM(M0CODFIL) = '"+AllTrim(MV_PAR04)+"') "+cQuebra
Else
	cQuery += " AND SA1.A1_CGC IN ( SELECT M0CGC FROM AUX_EMPGEN ) "+cQuebra
EndIF
cQuery += " AND SA1.D_E_L_E_T_ <> '*' "+cQuebra

cQuery += " JOIN "+RetSqlName("SD2")+" SD2 "+cQuebra
cQuery += " ON D2_FILIAL = F2_FILIAL "+cQuebra
cQuery += " AND D2_CLIENTE = F2_CLIENTE "+cQuebra
cQuery += " AND D2_LOJA = F2_LOJA "+cQuebra
cQuery += " AND D2_DOC = F2_DOC "+cQuebra
cQuery += " AND D2_SERIE = F2_SERIE "+cQuebra
cQuery += " AND SD2.D_E_L_E_T_ <> '*'  "+cQuebra

cQuery += " JOIN "+RetSqlName("SB1")+" SB1 "+cQuebra
cQuery += " ON B1_FILIAL = '"+xFilial("SB1")+"' "+cQuebra
cQuery += " AND B1_COD = D2_COD "+cQuebra
cQuery += " AND SB1.D_E_L_E_T_ <> '*' "+cQuebra

cQuery += " JOIN "+RetSqlName("SA2")+" SA2 "+cQuebra
cQuery += " ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' "+cQuebra
cQuery += " AND SA2.A2_CGC IN ( SELECT TRIM(M0CGC) FROM AUX_EMPGEN WHERE TRIM(M0CODFIL) = TRIM(SF2.F2_FILIAL) ) "+cQuebra
cQuery += " AND SA2.D_E_L_E_T_ <> '*' "+cQuebra
If MV_PAR05 == 2
	cQuery += " JOIN "+RetSqlName("SF1")+" SF1 "+cQuebra 
Else
	cQuery += " LEFT JOIN "+RetSqlName("SF1")+" SF1 "+cQuebra 
EndIf	
cQuery += " ON SF1.F1_FILIAL IN ( SELECT TRIM(B.M0CODFIL) FROM AUX_EMPGEN B WHERE TRIM(B.M0CGC) = TRIM(SA1.A1_CGC)  AND ( TRIM(B.M0INSC) = TRIM(REPLACE(REPLACE(SA1.A1_INSCR,'.',''),'-','')) OR TRIM(SA1.A1_INSCR) = 'ISENTO' ) ) "+cQuebra
cQuery += " AND LPAD(TRIM(SF1.F1_DOC),9,'0') = LPAD(TRIM(F2_DOC),9,'0') "+cQuebra
cQuery += " AND SF1.F1_SERIE = F2_SERIE "+cQuebra
cQuery += " AND SF1.F1_FORNECE = A2_COD "+cQuebra
cQuery += " AND SF1.F1_LOJA = A2_LOJA "+cQuebra
cQuery += " AND SF1.D_E_L_E_T_ <> '*' "+cQuebra

If Empty(MV_PAR03)
	cQuery += " WHERE F2_FILIAL IN ( SELECT M0CODFIL FROM AUX_EMPGEN ) "+cQuebra
	cQuery += " AND F2_TIPO NOT IN ('D','B') "+cQuebra
Else
	cQuery += " WHERE F2_FILIAL = '"+MV_PAR03+"' "+cQuebra
	cQuery += " AND F2_TIPO NOT IN ('D','B') "+cQuebra
EndIF	

// CLEUTO - 29/05/2017 - INCLUIDO FILTRO PARA NรO CONSIDERAR AS NOTAS FISCAIS EMITIDAS CONTA A PROPRIA EMPRESA
cQuery += " AND F2_FILIAL NOT IN (SELECT M0CODFIL FROM AUX_EMPGEN WHERE TRIM(M0CGC) = TRIM(SA1.A1_CGC)) "+cQuebra


cQuery += " AND F2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "+cQuebra
cQuery += " AND SF2.D_E_L_E_T_ <> '*' "+cQuebra

If MV_PAR05 == 2
	cQuery += " AND F1_VALBRUT = F2_VALBRUT "+cQuebra
ElseIf MV_PAR05 == 3
	cQuery += " AND ( F1_VALBRUT IS NULL OR F1_VALBRUT <> F2_VALBRUT) "+cQuebra
EndIf	

cQuery += " GROUP BY F2_TIPO,F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALBRUT,F1_VALBRUT,F1_FILIAL,A1_CGC,A1_NOME ,F2_CHVNFE , B1_COD,B1_DESC,A2_COD ,A2_LOJA "+cQuebra  

cQuery += " ) TMP "+cQuebra

If MV_PAR06 == 2
	cQuery += "  JOIN "+RetSqlName("SD1")+" SD1 "+cQuebra
Else	
	cQuery += "  LEFT JOIN "+RetSqlName("SD1")+" SD1 "+cQuebra
EndIf
	
cQuery += "  ON D1_FILIAL = FIL_DEST "+cQuebra
cQuery += "  AND D1_FORNECE = COD_DEST "+cQuebra
cQuery += "  AND D1_LOJA = LOJA_DEST "+cQuebra
cQuery += "  AND D1_DOC = F2_DOC "+cQuebra
cQuery += "  AND D1_SERIE = F2_SERIE "+cQuebra
cQuery += "  AND SD1.D_E_L_E_T_ <> '*'  "+cQuebra
cQuery += "  AND D1_COD = B1_COD"+cQuebra
cQuery += '  GROUP BY F2_TIPO,F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,"VALOR ORIGEM", "VALOR DESTINO",FIL_DEST, CGC, DESTINO,COD_DEST,LOJA_DEST '+cQuebra
cQuery += "  , B1_COD,B1_DESC"+cQuebra
cQuery += "  , D2_QUANT, D2_TOTAL"+cQuebra
cQuery += "  , F2_CHVNFE"+cQuebra
cQuery += "  ) TMP2 "+cQuebra

If MV_PAR06 == 3
	cQuery += "  WHERE ( D2_QUANT <> D1_QUANT or D2_TOTAL <> D1_TOTAL or D1_QUANT IS NULL OR D1_TOTAL IS NULL)"+cQuebra
ElseIf MV_PAR06 == 2
	cQuery += "  WHERE ( D2_QUANT = D1_QUANT AND D2_TOTAL = D1_TOTAL AND D1_QUANT IS NOT NULL )"+cQuebra
EndIF	
 
cQuery += " ORDER BY F2_FILIAL,DESTINO,F2_DOC,F2_SERIE "+cQuebra        

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cQryAlias, .F., .T.)
(cQryAlias)->(dbGoTop())

If Select("ORINODEST") > 0
	ORINODEST->(dbCloseArea())
EndIf

BeginSql Alias "ORINODEST"
	SELECT 
	D1_FILIAL
	,D1_DOC
	,D1_SERIE
	,D1_COD
	,B1_DESC
	,X5_DESCRI X5DESCRI
	,Z4_DESC
	,BM_DESC
	,DA1_PRCVEN
	,SD1.D1_EMISSAO
	,SD1.D1_DTDIGIT
	,D1_FORNECE
	,DECODE(D1_FORNECE,'0005065','1022','0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022') FIL_ORI
	,CASE WHEN ( 
	  SELECT count(*) FROM %Table:SD2% SD2 
	  WHERE D2_FILIAL = DECODE(D1_FORNECE,'0005065','1022','0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022')  
	  AND D2_DOC = D1_DOC 
	  AND D2_SERIE = D1_SERIE 
	  AND D2_COD = D1_COD 
	  AND SD2.D_E_L_E_T_ = '*' 
	) > 0 THEN 'SIM' ELSE 'NรO' END NF_ORI_DEL
	FROM %Table:SD1% SD1 
	JOIN %Table:SF1% SF1 
	ON F1_FILIAL = D1_FILIAL 
	AND F1_DOC = D1_DOC 
	AND F1_SERIE = D1_SERIE 
	AND F1_FORNECE = D1_FORNECE 
	AND F1_LOJA = D1_LOJA 
	AND SF1.%NotDel% 
	JOIN %Table:SF4% SF4AUX    
	ON SF4AUX.F4_FILIAL = %xFilial:SF4%
	AND SF4AUX.F4_CODIGO = D1_TES    
	AND SF4AUX.%NotDel%      
	AND SF4AUX.F4_PODER3 <> 'N'  
	JOIN %Table:SB1% SB1     
	ON B1_FILIAL = %xFilial:SB1%
	AND B1_COD = D1_COD     
	AND SB1.%NotDel%      
	JOIN %Table:SX5% SX5     
	ON X5_FILIAL = ' '     
	AND X5_TABELA = 'Z4'     
	AND X5_CHAVE = SB1.B1_XIDTPPU     
	AND SX5.%NotDel% 	     
	JOIN %Table:SZ4% SZ4    
	ON Z4_FILIAL = %xFilial:SZ4%
	AND Z4_COD = SB1.B1_XSITOBR    
	AND SZ4.%NotDel%     
	JOIN %Table:SBM% SBM    
	ON BM_FILIAL = %xFilial:SBM%
	AND BM_GRUPO = B1_GRUPO    
	AND SBM.%NotDel%     
	JOIN %Table:DA1% DA1    
	ON DA1_FILIAL = %xFilial:DA1%
	AND DA1_CODTAB = %Exp:cTabConsi%
	AND DA1_CODPRO = D1_COD
	AND DA1.%NotDel%     
	WHERE SD1.%NotDel%  
	AND NOT ( SD1.D1_FILIAL = '1022' AND SD1.D1_EMISSAO <= '20151231' AND SD1.D1_FORNECE = '0378128'  )/* NรO CONSIDERA AS NOTAS DA ATLAS ANTERIORES A 2015 POIS NรO FORAM EMITIDAS NO PROTHEUS GEM */  
	AND NOT EXISTS( 
	  SELECT * FROM %Table:SD2% SD2 
	  WHERE D2_FILIAL = DECODE(D1_FORNECE,'0005065','1022','0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022')  
	  AND D2_DOC = D1_DOC 
	  AND D2_SERIE = D1_SERIE 
	  AND D2_COD = D1_COD 
	  AND SD2.D_E_L_E_T_ <> '*' 
	) 
	AND F1_FORMUL <> 'S' 
	AND D1_FORNECE IN ('0005065','0380795','0380796','0380794','031811 ','0378128')  
	GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,SF4AUX.F4_PODER3,D1_FORNECE,SD1.D1_EMISSAO,SD1.D1_DTDIGIT,D1_COD,B1_DESC,X5_DESCRI,Z4_DESC,BM_DESC,DA1_PRCVEN
EndSql
ORINODEST->(DbGoTop())

//nQtdReg	:= 0
//(cQryAlias)->(DbEval({|x| nQtdReg++ }))

//oReport:SetMeter(nQtdReg)

//(cQryAlias)->(dbGoTop())

If !lJob
	
	While !(cQryAlias)->(Eof())

		If oReport:Cancel()
			Return nil
		EndIF
		
		oReport:IncMeter()
		oSection1:Init()  
		
		oSection1:Cell("F2_FILIAL"	):SetValue(	(cQryAlias)->F2_FILIAL	)
		oSection1:Cell("F2_DOC"		):SetValue(	(cQryAlias)->F2_DOC		)
		oSection1:Cell("F2_SERIE"	):SetValue(	(cQryAlias)->F2_SERIE	)
		oSection1:Cell("F2_EMISSAO"	):SetValue(	DtoC(StoD((cQryAlias)->F2_EMISSAO))	)
		oSection1:Cell("VAL_ORIGEM"	):SetValue(	(cQryAlias)->VAL_ORIGEM	)
		oSection1:Cell("VAL_DESTIN"	):SetValue(	(cQryAlias)->VAL_DESTIN	)
		oSection1:Cell("CGC"		):SetValue(	(cQryAlias)->CGC		)
		oSection1:Cell("NOME"		):SetValue(	(cQryAlias)->DESTINO	)
		oSection1:Cell("SITUACAO"	):SetValue(	(cQryAlias)->SITUACAO	)
	
		oSection1:Cell("OBRA"  		):SetValue(	(cQryAlias)->B1_COD		)
		oSection1:Cell("TITULO"		):SetValue(	(cQryAlias)->B1_DESC	)	
		oSection1:Cell("QTDORIG"	):SetValue(	(cQryAlias)->D2_QUANT	)	
		oSection1:Cell("VALORIG"	):SetValue(	(cQryAlias)->D2_TOTAL	)	
		oSection1:Cell("QTDDEST"	):SetValue(	(cQryAlias)->D1_QUANT	)	
		oSection1:Cell("VALDEST"	):SetValue(	(cQryAlias)->D1_TOTAL	)	
		oSection1:Cell("SITQTD"		):SetValue(	(cQryAlias)->SIT_QUANT	)	
		oSection1:Cell("SITVAL"		):SetValue(	(cQryAlias)->SIT_VALOR	)	
		
		oSection1:Cell("CHVNFE"		):SetValue(	(cQryAlias)->CHVNFE	)
					
		oSection1:PrintLine()
	
		(cQryAlias)->(dbSkip())
	
	EndDo

	(cQryAlias)->(DbCloseArea())  

	
	While !ORINODEST->(Eof())

		If oReport:Cancel()
			Return nil
		EndIF
		
		oReport:IncMeter()
		oSection2:Init()  
		oSection2:Cell("D1_FILIAL"	):SetValue( ORINODEST->D1_FILIAL	)
		oSection2:Cell("D1_DOC"		):SetValue( ORINODEST->D1_DOC		)
		oSection2:Cell("D1_SERIE"	):SetValue( ORINODEST->D1_SERIE		)
		oSection2:Cell("D1_COD"		):SetValue( ORINODEST->D1_COD		)
		oSection2:Cell("B1_DESC"	):SetValue( ORINODEST->B1_DESC		)
		oSection2:Cell("X5_DESCRI"	):SetValue( ORINODEST->X5DESCRI	)
		oSection2:Cell("Z4_DESC"	):SetValue( ORINODEST->Z4_DESC		)
		oSection2:Cell("BM_DESC"	):SetValue( ORINODEST->BM_DESC		)
		oSection2:Cell("DA1_PRCVEN"	):SetValue( ORINODEST->DA1_PRCVEN	)
		oSection2:Cell("D1_EMISSAO"	):SetValue( StoD(ORINODEST->D1_EMISSAO)	)
		oSection2:Cell("D1_DTDIGIT"	):SetValue( StoD(ORINODEST->D1_DTDIGIT)	)
		oSection2:Cell("D1_FORNECE"	):SetValue( ORINODEST->D1_FORNECE	)
		oSection2:Cell("FIL_ORI"	):SetValue( ORINODEST->FIL_ORI		)
		oSection2:Cell("NF_ORI_DEL"	):SetValue( ORINODEST->NF_ORI_DEL	)
		oSection2:PrintLine()
	
		ORINODEST->(dbSkip())
	
	EndDo

	ORINODEST->(DbCloseArea())
		
Else

	While !(cQryAlias)->(Eof())
		
		lMail := .T.
		
		oReport:AddRow(cSheet,cTable,{;
		(cQryAlias)->F2_FILIAL,;
		(cQryAlias)->F2_DOC,;
		(cQryAlias)->F2_SERIE,;
		DtoC(StoD((cQryAlias)->F2_EMISSAO)),;
		(cQryAlias)->VAL_ORIGEM,;
		(cQryAlias)->VAL_DESTIN	,;
		(cQryAlias)->CGC,;
		(cQryAlias)->DESTINO,;
		(cQryAlias)->SITUACAO,;
		(cQryAlias)->B1_COD,;
		(cQryAlias)->B1_DESC,;
		(cQryAlias)->D2_QUANT,;
		(cQryAlias)->D2_TOTAL,;
		(cQryAlias)->D1_QUANT,;
		(cQryAlias)->D1_TOTAL,;
		(cQryAlias)->SIT_QUANT	,;
		(cQryAlias)->SIT_VALOR,;
		(cQryAlias)->CHVNFE	;
		})

		(cQryAlias)->(dbSkip())
	
	EndDo
	(cQryAlias)->(DbCloseArea())


	ORINODEST->(dbGoTop())

	While !ORINODEST->(Eof())
		
		lMail := .T.
		
		oReport:AddRow(cSheet2,cTable,{; 		
		ORINODEST->D1_FILIAL,;
		ORINODEST->D1_DOC,;
		ORINODEST->D1_SERIE,;
		ORINODEST->D1_COD,;
		ORINODEST->B1_DESC,;
		ORINODEST->X5DESCRI,;
		ORINODEST->Z4_DESC,;
		ORINODEST->BM_DESC,;
		ORINODEST->DA1_PRCVEN,;
		DtoC(StoD(ORINODEST->D1_EMISSAO)),;
		DtoC(StoD(ORINODEST->D1_DTDIGIT)),;
		ORINODEST->D1_FORNECE,;
		ORINODEST->FIL_ORI,;
		ORINODEST->NF_ORI_DEL})

		ORINODEST->(dbSkip())
	
	EndDo		
	ORINODEST->(DbCloseArea())
EndIf

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR063   บAutor  ณCleuto Lima - Loop  บ Data ณ  06/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de acompanhamento intercompnay.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*
Static Function AjustaSX1(cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )
Local aHelp		:= {} 
Local cTamSX1	:= Len(SX1->X1_GRUPO)
Local cPesPerg	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define os tํtulos e Help das perguntas                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Grava as perguntas no arquivo SX1                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//		cGrupo cOrde cDesPor			cDesSpa				  	cDesEng				           	cVar	   cTipo cTamanho					cDecimal	nPreSel	cGSC	cValid                            cF3 		cGrpSXG	cPyme	cVar01			cDef1Por					cDef1Spa	cDef1Eng	cCnt01	  	cDef2Por		cDef2Spa	cDef2Eng	cDef3Por				cDef3Spa	cDef3Eng	cDef4Por		cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp)
PutSx1(cPerg,"01","Periodo De"			,"Periodo De"         	,"Periodo De"                	,"mv_ch1" ,"D" ,8        					,0  	    ,        ,"G"  ,""                                  ,""		,      ,"","mv_par01","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[01,1],	aHelp[01,2],	aHelp[01,3],	"" )
PutSx1(cPerg,"02","Periodo Ate"			,"Periodo Ate"       	,"Periodo Ate"               	,"mv_ch2" ,"D" ,8        					,0     	  	,        ,"G"  ,""                                  ,""   	  	,  ,"","mv_par02","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[02,1],	aHelp[02,2],	aHelp[02,3],	"" )
PutSx1(cPerg,"03","Filial Origem"		,"Filial Origem"      	,"Filial Origem"            	,"mv_ch3" ,"C" ,Len(cFilAnt)				,0     		,        ,"G"  ,""                                  ,""   	,      ,"","mv_par03","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[03,1],	aHelp[03,2],	aHelp[03,3],	"" )
PutSx1(cPerg,"04","Filial Destino"		,"Filial Destino"      	,"Filial Destino"      			,"mv_ch4" ,"C" ,Len(cFilAnt)				,0       	,        ,"G"  ,""                                  ,""   	,      ,"","mv_par04","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[04,1],	aHelp[04,2],	aHelp[04,3],	"" )
PutSx1(cPerg,"05","Situa็ใo Nota"		,"Situa็ใo Nota"		,"Situa็ใo Nota"				,"mv_ch5" ,"N"	,1							,0		 	,		 ,"C"  ,""									,""		,""	   ,"","mv_par05","Todas","Todas","Todas","","Notas Corretas","Notas Corretas","Notas Corretas","Notas Inconsistentes","Notas Inconsistentes","Notas Inconsistentes","","","","","","",nil,nil,nil,	"")
PutSx1(cPerg,"06","Situa็ใo Item"		,"Situa็ใo Item"		,"Situa็ใo Item"				,"mv_ch6" ,"N"	,1							,0		 	,		 ,"C"  ,""									,""		,""	   ,"","mv_par06","Todos","Todos","Todos","","Itens Corretos","Itens Corretos","Itens Corretos","Itens Inconsistentes","Itens Inconsistentes","Itens Inconsistentes","","","","","","",nil,nil,nil,	"")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Salva as แreas originais                                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea( aAreaSX1 )
RestArea( aAreaAtu )

Return( Nil ) 
*/

Static Function RetBodyEmail()

local cBody		:= ''
Local cQuebra	:= Chr(13)+Chr(10)

cBody+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'+cQuebra
cBody+='<html xmlns="http://www.w3.org/1999/xhtml"> '+cQuebra
cBody+=' <head> '+cQuebra
cBody+=' <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> '+cQuebra
cBody+=' <title>Untitled Document</title> '+cQuebra
cBody+=' <style type="text/css"> '+cQuebra
cBody+=' <!-- '+cQuebra
cBody+=' .style30 { '+cQuebra
cBody+=' 	font-family: Geneva, Arial, Helvetica, sans-serif; '+cQuebra
cBody+=' 	font-size: 9px; '+cQuebra
cBody+=' 	color: #FFFFFF; '+cQuebra
cBody+=' } '+cQuebra
cBody+=' .style53 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; } '+cQuebra
cBody+=' .style54 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; } '+cQuebra
cBody+=' .style56 {color: #000000; font-size: 12px; font-family: Geneva, Arial, Helvetica, sans-serif; font-weight: bold; } '+cQuebra
cBody+=' .style57 {color: #333333} '+cQuebra
cBody+=' .style58 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; color: #333333; } '+cQuebra
cBody+=' .style59 {font-size: 18px; font-weight: bold; font-family: Geneva, Arial, Helvetica, sans-serif;} '+cQuebra
cBody+=' .style60 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; color: #333333; } '+cQuebra
cBody+=' .style62 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px;  }'+cQuebra
cBody+=' .style63 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; color: #FF0000; } '+cQuebra
cBody+=' --> '+cQuebra
cBody+=' </style> '+cQuebra
cBody+=' </head> '+cQuebra
cBody+=' <body> '+cQuebra
cBody+=' <table width="612" border="0" align="center"> '+cQuebra
cBody+=' <td width="670" bgcolor="#FFFFFF"><div align="center"> '+cQuebra
cBody+='   <!--<p><img src="log_GenAtlas.png" width="200" height="108" /></p> -->'+cQuebra
cBody+='   <table width="603" border="0"> '+cQuebra
cBody+='   '+cQuebra
cBody+='     <tr> '+cQuebra
cBody+='       <td colspan="4"><div align="center" class="style57"><span class="style59">Acompanhamento de Notas Inter Company</span></div></td> '+cQuebra
cBody+='     </tr> '+cQuebra
cBody+='     '+cQuebra
cBody+='	 <tr> '+cQuebra
cBody+='       <td colspan="4"><div align="center" class="style57">__________________________________________________________________________</div></td> '+cQuebra
cBody+='     </tr> '+cQuebra
cBody+='     '+cQuebra
cBody+='	 <tr> '+cQuebra
cBody+='       <td width="145">'+cQuebra
cBody+='		<div align="LEFT" class="style60">'+cQuebra
cBody+='			<table align="LEFT" width="600"> 				'+cQuebra
cBody+='				<tr>'+cQuebra
cBody+='					<td><span> Segue em anexo o relat๓rio de integra็ใo de notas intercompany com as diverg๊ncias encontradas!</span></td>'+cQuebra
cBody+='				</td>'+cQuebra
cBody+='			  <tr> '+cQuebra
cBody+='				<td>&nbsp;</td> '+cQuebra
cBody+='			  </tr> 				'+cQuebra
cBody+='				<tr> '+cQuebra
cBody+='					<td>'+cQuebra
cBody+='						<table width="580" border="0">'+cQuebra
cBody+='						  <tr>'+cQuebra
cBody+='							<td><span class="style7"><strong>Perํodo:</strong>'+DtoC(MV_PAR01)+" At้ "+DtoC(MV_PAR02)+'</span></td>'+cQuebra
cBody+='						  </tr>					  '+cQuebra
cBody+='						  <tr>'+cQuebra
cBody+='							<td>'+cQuebra
cBody+='							'+cQuebra
cBody+='							</td>'+cQuebra
cBody+='					</td>'+cQuebra
cBody+='				</td>'+cQuebra
cBody+='				<tr> '+cQuebra
cBody+='					<td>&nbsp;</td> '+cQuebra
cBody+='				</tr> 						'+cQuebra
cBody+='			  <tr> '+cQuebra
cBody+='				<td>&nbsp;</td> '+cQuebra
cBody+='			  </tr> 				'+cQuebra
cBody+='				<tr>'+cQuebra
cBody+='					<td>'+cQuebra
cBody+='						Workflow Protheus'+cQuebra
cBody+='					</td>'+cQuebra
cBody+='				</td>				'+cQuebra
cBody+='			</table>'+cQuebra
cBody+=''+cQuebra
cBody+='		</div>'+cQuebra
cBody+='	   </td> '+cQuebra
cBody+='	   '+cQuebra
cBody+='	 </tr>   '+cQuebra
cBody+='   </table>'+cQuebra
cBody+='</td> '+cQuebra
cBody+='   <div align="left"></div> '+cQuebra
cBody+='   </div></td> '+cQuebra
cBody+=' 	  <tr> '+cQuebra
cBody+=' 	    <td>&nbsp;</td> '+cQuebra
cBody+=' 	  </tr> '+cQuebra
cBody+=' 	<div align="center"></div> '+cQuebra
cBody+='	 <tr> '+cQuebra
cBody+='       <td colspan="4"><div align="center" class="style57">__________________________________________________________________________</div></td> '+cQuebra
cBody+='     </tr> 	'+cQuebra
cBody+='  </table> 	'+cQuebra
cBody+='</body> '+cQuebra
cBody+='</html>  '+cQuebra
 
Return cBody 