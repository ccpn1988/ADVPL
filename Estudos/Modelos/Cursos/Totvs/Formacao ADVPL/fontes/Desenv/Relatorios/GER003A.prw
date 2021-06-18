#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGER003A   บAutor  ณHelimar Tavares     บ Data ณ  17/05/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Faturamento Por Area                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Faturamento                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


User Function GER003A(aParamSche)

Local lEmp			:= Type('cFilAnt') == "C" .AND. Select("SM0") <> 0
Default aParamSche	:= {.F.}

If aParamSche[1]
	Conout("FAT003A - Iniciando "+Dtoc(Date())+" - "+Time())  
	RpcSetType(2)
	lOpenSM0 := RpcSetEnv( "00" , aParamSche[3])
	If !LockByName("FAT003A",.T.,.T.,.T.)
		Conout("FAT003A - Rotina jแ em uso - Fim "+Dtoc(Date())+" - "+Time())  
		Return nil
	EndIf
EndIf

ProcRel(aParamSche[1])

If aParamSche[1]
	UnLockByName("FAT003A",.T.,.T.,.T.)  
	Conout("FAT003A - Fim do processamento "+Dtoc(Date())+" - "+Time())  
	If lOpenSM0
		RpcClearEnv()	
	EndIf	
EndIf

Return nil

Static Function ProcRel(lSched)  

Local oReport
Local cPerg			:= "GER03A"    
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณvariaives para envio automaricoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cTempDir		:= "\spool\" 
Local cFilename		:= "FAT003a - Faturamento por มrea"
Local cMailDest		:= SuperGetmv("GEN_FAT162",.F.,"cleuto.lima@grupogen.com.br")
Local dDePeri		:= &(SuperGetmv("GEN_FAT163",.F.,""))
Local dAtePeri		:= &(SuperGetmv("GEN_FAT164",.F.,""))
Local cMailBody		:= ""
Local cQuebra		:= "" 
Local lFileOk		:= .F.

//Cria grupo de perguntas
PutSx1(cPerg, "01", "Dt Emissใo de:" , "Dt Emissใo de:" ,"Dt Emissใo de:", "mv_ch1" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Dt Emissใo at้:", "Dt Emissใo at้" ,"Dt Emissใo at้", "mv_ch2" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSX1(cPerg, "03", "Relat๓rio:"     , "Relat๓rio:"     ,"Relat๓rio:"    , "mv_ch3" , "C", 1, 0, 1, "C","", "", "", "", "MV_PAR03", "Sint้tico", "Sint้tico", "Sint้tico", "", "Analํtico", "Analํtico", "Analํtico", "", "", "", "", "","", "", "", "", "", "", "", "" )

Pergunte(cPerg,!lSched)	

If lSched
	MV_PAR01	:= dDePeri
	MV_PAR02	:= dAtePeri 
	MV_PAR03	:= 	1
EndIf

oReport := ReportDef(cPerg)
	
If !lSched	
	oReport:PrintDialog()	
Else
		
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
	oReport:Print(.F.)

	If File(cTempDir+cFilename+".PDF")
		cMailBody := LayMail(DtoC(MV_PAR01),DtoC(MV_PAR02),"FAT003a - Faturamento por มrea")
		U_GenSendMail(,,,"noreply@grupogen.com.br",cMailDest,Oemtoansi("FAT003a - Faturamento por มrea"),cMailBody,cTempDir+cFilename+".PDF",,.F.)
	Else
		U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",Oemtoansi("FAT003a - Faturamento por มrea"),"Falha ao gerar ao arquyivo "+cFilename,,,.F.)
	EndIf
	
EndIf

Return

     

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport

//Declaracao do relatorio
If (MV_PAR03 == 1)
	oReport := TReport():New("FAT003A","FAT003A - Faturamento por มrea(Sint้tico)",cPerg,{|oReport| PrintReport(oReport)},"GER003A - Faturamento por มrea(Sint้tico)")
else
	oReport := TReport():New("FAT003A","FAT003A - Faturamento por มrea(Analํtico)",cPerg,{|oReport| PrintReport(oReport)},"GER003A - Faturamento por มrea(Analํtico)")
Endif

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SD2")

//Celulas da secao

TRCell():New(oSection1,"B5_XAREA"		,"SB1","Cod.มrea",,10)
TRCell():New(oSection1,"Z7_DESC"		,"SA2","Decr.มrea",,20)
If (MV_PAR03 == 2)
	TRCell():New(oSection1,"B1_COD"		,"SB1","C๓d.Prod.",,10)
	TRCell():New(oSection1,"B1_ISBN"	,"SB1","ISBN",,12)
	TRCell():New(oSection1,"B1_DESC"	,"SB1","Descr.Produto",,40)
    TRCell():New(oSection1,"SELO"  ,"Z1","Selo",,10) //Selo MARCOS
Endif  
TRCell():New(oSection1,"QTDE"		    ,"   ","Qtde",'@E 9,999,999',14,,,,,"RIGHT")
TRCell():New(oSection1,"D1_TOTAL"		,"SD1","Venda Liq. ((-) Dev.)",'@E 999,999,999.99',25,,,,,"RIGHT")
TRCell():New(oSection1,"QUANT"	    	,"   ","QtdeVenda",'@E 9,999,999',14,,,,,"RIGHT")
TRCell():New(oSection1,"D2_VALBRUT"		,"SD2","ValorVenda",'@E 999,999,999.99',25,,,,,"RIGHT")
TRCell():New(oSection1,"QTDEDEV"	 	,"   ","QtdeDev",'@E 9,999,999',14,,,,,"RIGHT")
TRCell():New(oSection1,"D1_VALDESC"	 	,"SD1","ValorDev",'@E 999,999,999.99',20,,,,,"RIGHT")

If (MV_PAR03 == 2)
	oBreak := TRBreak():New(oSection1,oSection1:Cell("B5_XAREA"),"Subtotal",.f.)

	//Totalizadores
	TRFunction():New(oSection1:Cell("QTDE")	    	,NIL,"SUM",oBreak,,,,.T.,.F.)
	TRFunction():New(oSection1:Cell("D1_TOTAL")		,NIL,"SUM",oBreak,,,,.T.,.F.)
	TRFunction():New(oSection1:Cell("QUANT")		,NIL,"SUM",oBreak,,,,.T.,.F.)
	TRFunction():New(oSection1:Cell("D2_VALBRUT")	,NIL,"SUM",oBreak,,,,.T.,.F.)
	TRFunction():New(oSection1:Cell("QTDEDEV")	    ,NIL,"SUM",oBreak,,,,.T.,.F.)
	TRFunction():New(oSection1:Cell("D1_VALDESC")  	,NIL,"SUM",oBreak,,,,.T.,.F.)

	//Faz a impressao do totalizador em linha
	oSection1:SetTotalInLine(.f.)
	oReport:SetTotalInLine(.f.)
Else
	//Totalizadores
	TRFunction():New(oSection1:Cell("QTDE")	    	,NIL,"SUM",,,,,.T.,.F.)
	TRFunction():New(oSection1:Cell("D1_TOTAL")		,NIL,"SUM",,,,,.T.,.F.)
	TRFunction():New(oSection1:Cell("QUANT")		,NIL,"SUM",,,,,.T.,.F.)
	TRFunction():New(oSection1:Cell("D2_VALBRUT")	,NIL,"SUM",,,,,.T.,.F.)
	TRFunction():New(oSection1:Cell("QTDEDEV")	    ,NIL,"SUM",,,,,.T.,.F.)
	TRFunction():New(oSection1:Cell("D1_VALDESC")  	,NIL,"SUM",,,,,.T.,.F.)

	//Faz a impressao do totalizador em linha
	oSection1:SetTotalInLine(.f.)
	//oReport:SetTotalInLine(.f.)
Endif  

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias()

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)

If (MV_PAR03 == 1) 
	//Cria query
	Begin Report Query oSection1
		BeginSQL Alias cAlias1  

		SELECT SB5.B5_XAREA,
		       NVL(TRIM(SZ7.Z7_DESC), '*** SEM มREA ***') AS Z7_DESC,
			   SUM(QTDEVENDA-QTDEDEV) AS QTDE,
			   SUM(VALORVENDA-VALORDEV) AS D1_TOTAL, 
			   SUM(QTDEVENDA) AS QUANT, 
			   SUM(VALORVENDA) AS D2_VALBRUT, 
			   SUM(QTDEDEV) AS QTDEDEV, 
			   SUM(VALORDEV) AS D1_VALDESC 
	 	  FROM (SELECT SD2.D2_COD COD, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0) QTDEVENDA, 0 QTDEDEV, NVL(SUM(SD2.D2_VALBRUT), 0) VALORVENDA, 0 VALORDEV 
	              FROM GER_SD2 SD2
	             INNER JOIN %table:SB1% SB1 ON SD2.D2_COD = SB1.B1_COD
    	         WHERE SD2.D2_EMISSAO BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
	         	   AND SD2.D2_FILIAL  = %xFilial:SD2%
                   AND SB1.B1_XIDTPPU <> ' '
	         	   AND SB1.B1_FILIAL = %xFilial:SB1%
	         	   AND SB1.%notDel%
	     	  	 GROUP BY SD2.D2_COD
	     	    UNION ALL 
	    	  	SELECT SD1.D1_COD, 0, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD1.D1_QUANT END),0), 0, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)
	     	  	  FROM GER_SD1 SD1
	             INNER JOIN %table:SB1% SB1 ON SD1.D1_COD = SB1.B1_COD
	      	     WHERE SD1.D1_DTDIGIT BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
	       	   	   AND SD1.D1_FILIAL  = %xFilial:SD1%
                   AND SB1.B1_XIDTPPU <> ' '
	         	   AND SB1.B1_FILIAL = %xFilial:SB1%
	         	   AND SB1.%notDel%
	             GROUP BY SD1.D1_COD) F
	     INNER JOIN %table:SB1% SB1  ON SB1.B1_COD = F.COD
	       AND SB1.B1_FILIAL  = %xFilial:SB1%
	       AND SB1.%notDel%
	     INNER JOIN %table:SB5% SB5 ON SB5.B5_COD = SB1.B1_COD
	       AND SB5.B5_FILIAL  = %xFilial:SB5%
	       AND SB5.%notDel%
	      LEFT JOIN %table:SZ7% SZ7 ON SZ7.Z7_AREA = SB5.B5_XAREA
	       AND SZ7.Z7_FILIAL  = %xFilial:SZ7%
	       AND SZ7.%notDel%
	     GROUP BY SB5.B5_XAREA, NVL(TRIM(SZ7.Z7_DESC), '*** SEM มREA ***')
	     ORDER BY SB5.B5_XAREA
	     
	    EndSQL
	End Report Query oSection1  
Else 
	//Cria query
	Begin Report Query oSection1
		BeginSQL Alias cAlias1  
		
		 SELECT SB5.B5_XAREA
		      , NVL(TRIM(SZ7.Z7_DESC), '*** SEM มREA ***') AS Z7_DESC
		      , SUM(F.QTDEVENDA-F.QTDEDEV)  AS QTDE
		      , SUM(F.VALORVENDA-F.VALORDEV) AS D1_TOTAL
		      , SUM(F.QTDEVENDA) AS QUANT
		      , SUM(F.VALORVENDA) AS D2_VALBRUT
		      , SUM(F.QTDEDEV) AS QTDEDEV
		      , SUM(F.VALORDEV) AS D1_VALDESC
		      , SB1.B1_COD
		      , SB1.B1_ISBN
		      , SB1.B1_DESC 
		      , Z1.X5_DESCRI AS SELO //SELO MARCOS
		   FROM (SELECT SD2.D2_COD COD, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0) QTDEVENDA, 0 QTDEDEV, NVL(SUM(SD2.D2_VALBRUT), 0) VALORVENDA, 0 VALORDEV 
		           FROM GER_SD2 SD2
		          INNER JOIN %table:SB1% SB1 ON SD2.D2_COD = SB1.B1_COD
		          WHERE SD2.D2_FILIAL  = %xFilial:SD2%
	                AND SD2.D2_EMISSAO BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
                    AND SB1.B1_XIDTPPU <> ' '
   	         	    AND SB1.B1_FILIAL = %xFilial:SB1%
	         	    AND SB1.%notDel%
		     	  GROUP BY SD2.D2_COD
		     	 UNION ALL 
		    	 SELECT SD1.D1_COD, 0, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD1.D1_QUANT END),0), 0, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)
		       	   FROM GER_SD1 SD1
		          INNER JOIN %table:SB1% SB1 ON SD1.D1_COD = SB1.B1_COD
		       	  WHERE SD1.D1_FILIAL  = %xFilial:SD1%
	       	   	    AND SD1.D1_DTDIGIT BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
                    AND SB1.B1_XIDTPPU <> ' '
		         	AND SB1.B1_FILIAL = %xFilial:SB1%
		         	AND SB1.%notDel%
	      	      GROUP BY SD1.D1_COD) F
		  INNER JOIN %table:SB1% SB1 ON SB1.B1_COD = F.COD
	        AND SB1.B1_FILIAL  = %xFilial:SB1%
	        AND SB1.%notDel%
	      INNER JOIN %table:SB5% SB5 ON SB5.B5_COD = SB1.B1_COD
	        AND SB5.B5_FILIAL  = %xFilial:SB5%
	        AND SB5.%notDel%
	       LEFT JOIN %table:SZ7% SZ7 ON SZ7.Z7_AREA = SB5.B5_XAREA
	        AND SZ7.Z7_FILIAL  = %xFilial:SZ7%
	        AND SZ7.%notDel%
	       LEFT JOIN %table:SX5% Z1 ON SB5.B5_XSELO = Z1.X5_CHAVE
	    	AND Z1.X5_FILIAL = %xFilial:SX5%
		    AND Z1.X5_TABELA = 'Z1'
    		AND Z1.%notDel%
	      GROUP BY Z1.X5_DESCRI, SB5.B5_XAREA, NVL(TRIM(SZ7.Z7_DESC), '*** SEM มREA ***'), SB1.B1_COD, SB1.B1_ISBN, SB1.B1_DESC
	      ORDER BY SB5.B5_XAREA, D1_TOTAL DESC
		
		EndSQL
	End Report Query oSection1

MemoWrite("\spool\fat003a.sql",GetLastquery()[2])

Endif

//Efetua impressใo
oSection1:Print()

Return(.t.) 

Static Function LayMail(cPerDe,cPerAte,cTitRel) 

Local cHtml 	:= "" 
Local cQuebra	:= Chr(13)+Chr(10)
Local cPeriodo	:= IIF( Time() <= "12:00" , "Bom dia!", IIF( Time() <= "18:00" , "Boa tarde!" , "Boa Noite!" ) ) 

cHtml += +cQuebra
cHtml += cPeriodo+cQuebra
cHtml += +cQuebra
cHtml += 'Relat๓rio referente a '+cPerDe+' แ '+cPerAte+cQuebra
cHtml += +cQuebra
cHtml += cTitRel+cQuebra
cHtml += +cQuebra
cHtml += "Atenciosamente"+cQuebra

Return cHtml
