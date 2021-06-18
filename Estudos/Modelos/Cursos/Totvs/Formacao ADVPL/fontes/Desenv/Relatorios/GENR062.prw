#include "protheus.ch"
#include "topconn.ch"
#Include "Report.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENR062   �Autor  �Cleuto Lima - Loop  � Data �  06/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio de acompanhamento intercompnay.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function GENR062()

//���������������������������������������������������������������������������������Ŀ
//�Variaveis da rotina.                                                             �
//�����������������������������������������������������������������������������������
Local cPerg		:= "GENR062"
Private lQuebra	:= .T.
Private cQryAlias	:= GetNextAlias()

//AjustaSX1(cPerg)

If !Pergunte(cPerg,.T.)
	Return nil
EndIF

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENR062   �Autor  �Cleuto Lima - Loop  � Data �  06/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio de acompanhamento intercompnay.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReportDef(cPerg)

Local oReport
Local oSection1

Local aOrdem	:= {}

//Declaracao do relatorio
oReport := TReport():New("GENR062","Acompanhamento Inter Company"	,cPerg		,{|oReport| PrintReport(oReport)},"Acompanhamento Inter Company") 
oReport:PrintHeader(.F.,.F.)
//Ajuste nas definicoes
oReport:nLineHeight := 55
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7		&& 10
oReport:lHeaderVisible := .F. 
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Acompanhamento Inter Company",{cQryAlias,"NAOUSADO"},aOrdem)

//Celulas da secao
TRCell():New(oSection1,"F2_FILIAL"	,cQryAlias,"Filial Origem"	,,15)
TRCell():New(oSection1,"F2_DOC"		,cQryAlias,"Documento"	  	,,20)
TRCell():New(oSection1,"F2_SERIE"	,cQryAlias,"Serie"		  	,,10)
TRCell():New(oSection1,"F2_EMISSAO"	,cQryAlias,"Emiss�o"		,,15)
TRCell():New(oSection1,"VAL_ORIGEM"	,cQryAlias,"Valor Origem"	,PesqPict('SF2',"F2_VALBRUT"),20)
TRCell():New(oSection1,"VAL_DESTIN"	,cQryAlias,"Valor Destino"	,PesqPict('SF2',"F2_VALBRUT"),20)
TRCell():New(oSection1,"CGC"		,cQryAlias,"CGC Destino"	,,15)
TRCell():New(oSection1,"NOME"		,cQryAlias,"Nome Destino"	,,50)
TRCell():New(oSection1,"SITUACAO"	,cQryAlias,"Situa��o"		,,50)
TRCell():New(oSection1,"CHVNFE"		,cQryAlias,"Chave"			,,50)
	
//Faz a impressao do totalizador em linha
oSection1:SetHeaderPage(.F.)
oSection1:SetLeftMargin(2)
oSection1:lPrintHeader := .F.

Return oReport


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENR062   �Autor  �Cleuto Lima - Loop  � Data �  06/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio de acompanhamento intercompnay.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

Local cQuery	:= ""
Local cSqlExec	:= ""
Local cQuebra	:= Chr(13)+Chr(10)
//Local aAreaSM0	:= SM0->(GetArea())

Local aEstrutura	:= {	{'M0_CODFIL','C',12,0}, {'M0_FILIAL','C',40,0}, {'M0_NOMECOM','C',50,0},	{'M0_CGC','C',14,0},{'M0_INSC','C',14,0}}

//����������������������������������������������������Ŀ
//�AUX_SIGAMAT: tabela auxiliar com os dados do sigamat�
//������������������������������������������������������
/*
cSqlExec := "DROP TABLE AUX_SIGAMAT"
TCSQLExec(cSqlExec)

cSqlExec := "COMMIT"
TCSQLExec(cSqlExec)


DBCreate ( "AUX_SIGAMAT" , aEstrutura ,	"TOPCONN" )
USE "AUX_SIGAMAT" VIA "TOPCONN"

SM0->(DbGoTop())
While SM0->(!EOF())

	RecLock("AUX_SIGAMAT",.T.)
	AUX_SIGAMAT->M0_CODFIL	:= SM0->M0_CODFIL
	AUX_SIGAMAT->M0_FILIAL	:= SM0->M0_FILIAL
	AUX_SIGAMAT->M0_NOMECOM	:= SM0->M0_NOMECOM
	AUX_SIGAMAT->M0_CGC		:= SM0->M0_CGC
	AUX_SIGAMAT->M0_INSC	:= SM0->M0_INSC
	AUX_SIGAMAT->(MsUnLock())
	
	SM0->(DbSkip())
EndDo

AUX_SIGAMAT->(DbCloseArea())
RestArea(aAreaSM0)
*/

cQuery += " SELECT F2_TIPO,F2_FILIAL,F2_DOC,F2_SERIE,To_Date(F2_EMISSAO,'YYYYMMDD') F2_EMISSAO,"+cQuebra
cQuery += ' "VALOR ORIGEM" VAL_ORIGEM, "VALOR DESTINO" VAL_DESTIN, CGC, DESTINO '+cQuebra
cQuery += ' ,CASE WHEN "VALOR DESTINO" IS NULL THEN '+"'NOTA N�O ENCONTRADA NO DESTINO' WHEN "+'"VALOR DESTINO" <> "VALOR ORIGEM" THEN '+"'NOTA ORIGEM COM VALOR DIVERGENTE DA NOTA DESTINO' ELSE 'NOTA OK' END SITUACAO, CHVNFE "+cQuebra
cQuery += " FROM ( "+cQuebra
cQuery += " SELECT F2_TIPO,F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALBRUT "+'"VALOR ORIGEM",F1_VALBRUT "VALOR DESTINO",A2_CGC CGC,'+"'SA2 - '"+'||A2_NOME DESTINO, F2_CHVNFE CHVNFE FROM '+RetSqlName("SF2")+" SF2 "+cQuebra
cQuery += " JOIN "+RetSqlName("SA2")+" SA2 "+cQuebra
cQuery += " ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' "+cQuebra
cQuery += " AND SA2.A2_COD = F2_CLIENTE "+cQuebra
cQuery += " AND SA2.A2_LOJA = F2_LOJA "+cQuebra
If !Empty(MV_PAR04)
	cQuery += " AND SA2.A2_CGC IN ( SELECT M0_CGC FROM AUX_SIGAMAT WHERE TRIM(M0_CODFIL) = '"+AllTrim(MV_PAR04)+"') "+cQuebra
Else
	cQuery += " AND SA2.A2_CGC IN ( SELECT M0_CGC FROM AUX_SIGAMAT ) "+cQuebra
EndIF	
cQuery += " AND SA2.D_E_L_E_T_ <> '*' "+cQuebra
cQuery += " JOIN "+RetSqlName("SA1")+" SA1 "+cQuebra
cQuery += " ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+cQuebra
cQuery += " AND SA1.A1_CGC = ( SELECT TRIM(M0_CGC) FROM AUX_SIGAMAT WHERE TRIM(M0_CODFIL) = TRIM(SF2.F2_FILIAL) ) "+cQuebra
cQuery += " AND SA1.D_E_L_E_T_ <> '*' "+cQuebra

If MV_PAR05 == 2
	cQuery += " JOIN "+RetSqlName("SF1")+" SF1 "+cQuebra 
Else
	cQuery += " LEFT JOIN "+RetSqlName("SF1")+" SF1 "+cQuebra 
EndIf	

cQuery += " ON SF1.F1_FILIAL IN ( SELECT TRIM(B.M0_CODFIL) FROM AUX_SIGAMAT B WHERE REPLACE(TRIM(B.M0_CGC),'.','') = REPLACE(TRIM(SA2.A2_CGC),'.','') AND REPLACE(TRIM(B.M0_INSC),'.','') = REPLACE(TRIM(SA2.A2_INSCR),'.','')) "+cQuebra
cQuery += " AND LPAD(TRIM(SF1.F1_DOC),9,'0') = LPAD(TRIM(F2_DOC),9,'0') "+cQuebra
cQuery += " AND SF1.F1_SERIE = F2_SERIE "+cQuebra
cQuery += " AND SF1.F1_FORNECE = A1_COD "+cQuebra
cQuery += " AND SF1.F1_LOJA = A1_LOJA "+cQuebra
cQuery += " AND SF1.D_E_L_E_T_ <> '*' "+cQuebra

If Empty(MV_PAR03)
	cQuery += " WHERE F2_FILIAL IN ( SELECT M0_CODFIL FROM AUX_SIGAMAT ) "+cQuebra
	cQuery += " AND F2_TIPO IN ('D','B') "+cQuebra
Else
	cQuery += " WHERE F2_FILIAL = '"+MV_PAR03+"' "+cQuebra
	cQuery += " AND F2_TIPO IN ('D','B') "+cQuebra
EndIF	

// CLEUTO - 29/05/2017 - INCLUIDO FILTRO PARA N�O CONSIDERAR AS NOTAS FISCAIS EMITIDAS CONTA A PROPRIA EMPRESA
cQuery += " AND F2_FILIAL NOT IN (SELECT M0_CODFIL FROM AUX_SIGAMAT WHERE TRIM(M0_CGC) = TRIM(SA2.A2_CGC)) "+cQuebra

cQuery += " AND F2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "+cQuebra
cQuery += " AND SF2.D_E_L_E_T_ <> '*' "+cQuebra
//cQuery += " AND ( F1_VALBRUT IS NULL OR F1_VALBRUT <> F2_VALBRUT) "+cQuebra 
If MV_PAR05 == 2
	cQuery += " AND F1_VALBRUT = F2_VALBRUT "+cQuebra
ElseIf MV_PAR05 == 3
	cQuery += " AND ( F1_VALBRUT IS NULL OR F1_VALBRUT <> F2_VALBRUT) "+cQuebra
EndIf	

cQuery += " UNION ALL "+cQuebra
cQuery += " SELECT F2_TIPO,F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALBRUT "+'"VALOR ORIGEM",F1_VALBRUT "VALOR DESTINO",A1_CGC CGC,'+"'SA1 - '"+'||A1_NOME DESTINO ' + ", F2_CHVNFE CHVNFE FROM "+RetSqlName("SF2")+" SF2 "
cQuery += " JOIN "+RetSqlName("SA1")+" SA1 "+cQuebra
cQuery += " ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+cQuebra
cQuery += " AND SA1.A1_COD = F2_CLIENTE "+cQuebra
cQuery += " AND SA1.A1_LOJA = F2_LOJA "+cQuebra       
If !Empty(MV_PAR04)
	cQuery += " AND SA1.A1_CGC IN ( SELECT M0_CGC FROM AUX_SIGAMAT WHERE TRIM(M0_CODFIL) = '"+AllTrim(MV_PAR04)+"') "+cQuebra
Else
	cQuery += " AND SA1.A1_CGC IN ( SELECT M0_CGC FROM AUX_SIGAMAT ) "+cQuebra
EndIF
cQuery += " AND SA1.D_E_L_E_T_ <> '*' "+cQuebra
cQuery += " JOIN "+RetSqlName("SA2")+" SA2 "+cQuebra
cQuery += " ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' "+cQuebra
cQuery += " AND SA2.A2_CGC IN ( SELECT TRIM(M0_CGC) FROM AUX_SIGAMAT WHERE TRIM(M0_CODFIL) = TRIM(SF2.F2_FILIAL) ) "+cQuebra
cQuery += " AND SA2.D_E_L_E_T_ <> '*' "+cQuebra
If MV_PAR05 == 2
	cQuery += " JOIN "+RetSqlName("SF1")+" SF1 "+cQuebra 
Else
	cQuery += " LEFT JOIN "+RetSqlName("SF1")+" SF1 "+cQuebra 
EndIf	
cQuery += " ON SF1.F1_FILIAL IN ( SELECT TRIM(B.M0_CODFIL) FROM AUX_SIGAMAT B WHERE REPLACE(TRIM(B.M0_CGC),'.','') = REPLACE(TRIM(SA1.A1_CGC),'.','')  AND ( REPLACE(TRIM(B.M0_INSC),'.','') = REPLACE(TRIM(SA1.A1_INSCR),'.','') OR TRIM(SA1.A1_INSCR) = 'ISENTO' ) ) "+cQuebra
cQuery += " AND LPAD(TRIM(SF1.F1_DOC),9,'0') = LPAD(TRIM(F2_DOC),9,'0') "+cQuebra
cQuery += " AND SF1.F1_SERIE = F2_SERIE "+cQuebra
cQuery += " AND SF1.F1_FORNECE = A2_COD "+cQuebra
cQuery += " AND SF1.F1_LOJA = A2_LOJA "+cQuebra
cQuery += " AND SF1.D_E_L_E_T_ <> '*' "+cQuebra
If Empty(MV_PAR03)
	cQuery += " WHERE F2_FILIAL IN ( SELECT M0_CODFIL FROM AUX_SIGAMAT ) "+cQuebra
	cQuery += " AND F2_TIPO NOT IN ('D','B') "+cQuebra
Else
	cQuery += " WHERE F2_FILIAL = '"+MV_PAR03+"' "+cQuebra
	cQuery += " AND F2_TIPO NOT IN ('D','B') "+cQuebra
EndIF	
// CLEUTO - 29/05/2017 - INCLUIDO FILTRO PARA N�O CONSIDERAR AS NOTAS FISCAIS EMITIDAS CONTA A PROPRIA EMPRESA
cQuery += " AND F2_FILIAL NOT IN (SELECT M0_CODFIL FROM AUX_SIGAMAT WHERE TRIM(M0_CGC) = TRIM(SA1.A1_CGC)) "+cQuebra

cQuery += " AND F2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "+cQuebra
cQuery += " AND SF2.D_E_L_E_T_ <> '*' "+cQuebra

If MV_PAR05 == 2
	cQuery += " AND F1_VALBRUT = F2_VALBRUT "+cQuebra
ElseIf MV_PAR05 == 3
	cQuery += " AND ( F1_VALBRUT IS NULL OR F1_VALBRUT <> F2_VALBRUT) "+cQuebra
EndIf	

cQuery += " ) TMP "+cQuebra

cQuery += " ORDER BY F2_FILIAL,DESTINO,F2_DOC,F2_SERIE "+cQuebra        

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cQryAlias, .F., .T.)
(cQryAlias)->(dbGoTop())

While !(cQryAlias)->(Eof())
	
	If oReport:Cancel()
		Return nil
	EndIF
	
	oReport:IncMeter()
	oSection1:Init()  
	
	oSection1:Cell("F2_FILIAL"	):SetValue(	(cQryAlias)->F2_FILIAL	)
	oSection1:Cell("F2_DOC"		):SetValue(	(cQryAlias)->F2_DOC		)
	oSection1:Cell("F2_SERIE"	):SetValue(	(cQryAlias)->F2_SERIE	)
	oSection1:Cell("F2_EMISSAO"	):SetValue(	(cQryAlias)->F2_EMISSAO	)
	oSection1:Cell("VAL_ORIGEM"	):SetValue(	(cQryAlias)->VAL_ORIGEM	)
	oSection1:Cell("VAL_DESTIN"	):SetValue(	(cQryAlias)->VAL_DESTIN	)
	oSection1:Cell("CGC"		):SetValue(	(cQryAlias)->CGC		)
	oSection1:Cell("NOME"		):SetValue(	(cQryAlias)->DESTINO	)
	oSection1:Cell("SITUACAO"	):SetValue(	(cQryAlias)->SITUACAO	)
	oSection1:Cell("CHVNFE"		):SetValue(	(cQryAlias)->CHVNFE	)
				
	oSection1:PrintLine()

	(cQryAlias)->(dbSkip())
	
EndDo

(cQryAlias)->(DbCloseArea())

Return nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENR062   �Autor  �Cleuto Lima - Loop  � Data �  06/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio de acompanhamento intercompnay.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
Static Function AjustaSX1(cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )
Local aHelp		:= {} 
Local cTamSX1	:= Len(SX1->X1_GRUPO)
Local cPesPerg	:= ""

//�����������������������������������������������������������������������������������������Ŀ
//� Define os t�tulos e Help das perguntas                                                  �
//�������������������������������������������������������������������������������������������
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )

//�����������������������������������������������������������������������������������������Ŀ
//� Grava as perguntas no arquivo SX1                                                       �
//�������������������������������������������������������������������������������������������
//		cGrupo cOrde cDesPor			cDesSpa				  	cDesEng				           	cVar	   cTipo cTamanho					cDecimal	nPreSel	cGSC	cValid                            cF3 		cGrpSXG	cPyme	cVar01			cDef1Por					cDef1Spa	cDef1Eng	cCnt01	  	cDef2Por		cDef2Spa	cDef2Eng	cDef3Por				cDef3Spa	cDef3Eng	cDef4Por		cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp)
PutSx1(cPerg,"01","Periodo De"			,"Periodo De"         	,"Periodo De"                	,"mv_ch1" ,"D" ,8        					,0  	    ,        ,"G"  ,""                                  ,""		,      ,"","mv_par01","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[01,1],	aHelp[01,2],	aHelp[01,3],	"" )
PutSx1(cPerg,"02","Periodo Ate"			,"Periodo Ate"       	,"Periodo Ate"               	,"mv_ch2" ,"D" ,8        					,0     	  	,        ,"G"  ,""                                  ,""   	  	,  ,"","mv_par02","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[02,1],	aHelp[02,2],	aHelp[02,3],	"" )
PutSx1(cPerg,"03","Filial Origem"		,"Filial Origem"      	,"Filial Origem"            	,"mv_ch3" ,"C" ,Len(cFilAnt)				,0     		,        ,"G"  ,""                                  ,""   	,      ,"","mv_par03","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[03,1],	aHelp[03,2],	aHelp[03,3],	"" )
PutSx1(cPerg,"04","Filial Destino"		,"Filial Destino"      	,"Filial Destino"      			,"mv_ch4" ,"C" ,Len(cFilAnt)				,0       	,        ,"G"  ,""                                  ,""   	,      ,"","mv_par04","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[04,1],	aHelp[04,2],	aHelp[04,3],	"" )
PutSx1(cPerg,"05","Situa��o"			,"Situa��o"				,"Situa��o"						,"mv_ch5" ,"N"	,1							,0		 	,		 ,"C"  ,""									,""		,""	   ,"","mv_par05","Todas","Todas","Todas","","Notas Corretas","Notas Corretas","Notas Corretas","Notas Inconsistentes","Notas Inconsistentes","Notas Inconsistentes","","","","","","",nil,nil,nil,	"")
//�����������������������������������������������������������������������������������������Ŀ
//� Salva as �reas originais                                                                �
//�������������������������������������������������������������������������������������������
RestArea( aAreaSX1 )
RestArea( aAreaAtu )

Return( Nil )  
*/