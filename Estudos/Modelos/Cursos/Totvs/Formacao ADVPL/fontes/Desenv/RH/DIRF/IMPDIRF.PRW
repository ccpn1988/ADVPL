#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"  
#include "Fileio.ch"  
#Include "Ap5Mail.ch"  
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPDIRF   บAutor  ณMicrosiga           บ Data ณ  02/26/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPDIRF()
/*
RpcSetEnv("00","2001")

Teste()

Return nil

Static Function Teste()
*/
Local aArea		:= GetArea()
Local cPerg		:= "IMPDIRF"
Local cQryAlias	:= GetNextAlias()
Local cQryPJMes	:= GetNextAlias()
Local cMailCopy	:= ""

Local oDlgDIRF		:= Nil
Local oFont			:= Nil
Local oTFont 		:= TFont():New('Courier new',,-18,.T.)
Local lHtml			:= .T.

Local lContinua		:= .F.
Local bConfirm		:= {|| oDlgDIRF:End() }
Local bCancel		:= {|| oDlgDIRF:End() }
Local aButtons		:= {}

Local oNoMarked	:= LoaDBitmap( GetResources(), "LBNO" )
Local oMarked	:= LoaDBitmap( GetResources(), "LBOK" )
Local aStruRCS	:= RCS->(DbStruct())
Local cODRET	:= "" 

Local lAcesso	:= .F.

Local cCR1708	:= SuperGetMv("GEN_IN1708",.F.,"")
Local cCR5952	:= SuperGetMv("GEN_IN5952",.F.,"")
Local cCR8045	:= SuperGetMv("GEN_IN8045",.F.,"")
Local cCR0588	:= SuperGetMv("GEN_IN0588",.F.,"")
Local cCR0561	:= SuperGetMv("GEN_IN0561",.F.,"")
	
Private oVerme		:= LoadBitMap(GetResources(),"BR_VERMELHO")
Private oVerde		:= LoadBitMap(GetResources(),"BR_VERDE")
Private oAzul		:= LoadBitMap(GetResources(),"BR_AZUL")

Private nTotRegs	:= 0

PutSx1(cPerg, "01", "Matricula de ?"	,	"Matricula:"		,	"Matricula:"		, 	   	"mv_ch1", "C", TamSx3("RA_MAT")[1], 0, 0, "G","", "SRA", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Matricula ate ?"	,	"Matricula:"		,	"Matricula:"   		,	  	"mv_ch2", "C", TamSx3("RA_MAT")[1], 0, 0, "G","", "SRA", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Cod.Reten็ใo ?"	,	"Cod.Reten็ใo ?"	,	"Cod.Reten็ใo ?"	,		"mv_ch3", "C", TamSx3("R4_CODRET")[1], 0, 0, "G","", "", "", "", "MV_PAR03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Ano Calendario?"	,	"Ano ?"		,			"Ano ?"				,		"mv_ch4", "C", 04, 0, 0, "G","", "", "", "", "MV_PAR04","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "05", "E-Mail Copia ?"	,	"E-Mail Copia ?"	,	"E-Mail Copia ?"	,		"mv_ch5", "C", 99, 0, 0, "G","", "", "", "", "MV_PAR05","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "06", "Nome Responsavel ?",	"Nome Responsavel ?",	"Nome Responsavel ?",		"mv_ch6", "C", 99, 0, 0, "G","", "", "", "", "MV_PAR06","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "07", "De CPF/CGC ?"		,	"De CPF/CGC ?"		,	"De CPF/CGC ?"		,		"mv_ch7", "C", 14, 0, 0, "G","", "", "", "", "MV_PAR07","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "08", "Ate CPF/CGC ?"		,	"Ate CPF/CGC ?"		,	"Ate CPF/CGC ?"		,		"mv_ch8", "C", 14, 0, 0, "G","", "", "", "", "MV_PAR08","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "09", "Tipo ?"		   	,	"Tipo"				,	"Tipo"				,		"mv_ch9" ,"N", 01, 0,  , "C",""	,"","","","mv_par09","Fisica","Fisica","Fisica","","Juridico","Juridico","Juridico","","","","","","","","","",nil,nil,nil,	"")

If !Pergunte("IMPDIRF",.T.)
	Return
Endif

Do Case
	Case MV_PAR03 == "1708"
		If RetCodUsr() $ cCR1708
			lAcesso	:= .T.
		EndIf	
	Case MV_PAR03 == "5952"
		If RetCodUsr() $ cCR5952
			lAcesso	:= .T.
		EndIf	
	Case MV_PAR03 == "8045"
		If RetCodUsr() $ cCR8045
			lAcesso	:= .T.
		EndIF	
	Case  MV_PAR03 == "0588"
		If RetCodUsr() $ cCR0588
			lAcesso	:= .T.
		EndIf	
	Case  MV_PAR03 == "0561"
		If RetCodUsr() $ cCR0561
			lAcesso	:= .T.
		EndIf	
	OtherWise
		lAcesso	:= .F.
EndCase

If !lAcesso
	MsgStop("Usuแrio "+RetCodUsr()+" sem acesso a utilizar este Cod.Reten็ใo!")
	Return .F.
EndIf

/*
MV_PAR01	:= "900000" //"819371"
MV_PAR02	:= "900000"
MV_PAR03	:= "5952"
MV_PAR04	:= "2014"
MV_PAR05	:= "cleuto.lima@loopconsultoria.com.br"
MV_PAR06	:= "Rosemary R Rodrigues"
MV_PAR07	:= "68556224000118"
MV_PAR08	:= "68556224000118"
MV_PAR09	:= 2
*/
cMailCopy	:= MV_PAR05

cLeftJoin	:= "%"+IIF(MV_PAR03 == "0561", "" , " LEFT " )+"%"
cODRET		:= "%"+IIF(MV_PAR03 == "0561", FormatIn("0561#3562","#") , FormatIn(MV_PAR03,"#") )+"%"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcurar descricao do Cod.Retencao tab. 37ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cDescRet	:= Posicione("SX5",1,cFilial+"37"+MV_PAR03,"X5_DESCRI")
cDescRet	:= IIF( Empty(cDescRet) , "Codigo nao Cadastrado Tabela 37" , cDescRet)

BeginSql Alias cQryAlias
		
	SELECT SUBSTR(RA_EMAIL,1,2000) RA_EMAIL,CMARK,ENVIO,FILE_PDF, RL_FILIAL,RL_MAT,RL_CPFCGC,RL_BENEFIC, RL_UFBENEF,RL_TIPOFJ,RL_NOMFONT,RL_CGCFONT,B_3_1,B_3_2,B_3_3,B_3_4,B_3_5,B_4_1,B_4_2,B_4_3,B_4_4,B_4_5,B_4_6,B_4_7,B_5_1,B_5_2,B_5_3,PLR,B_6_1,B_6_2,B_6_3,B_6_4,B_6_5,B_6_6,B_6_QTDM,R4_ANO FROM (SELECT
	  	CASE WHEN RA_EMAIL <> ' ' THEN 'S' ELSE 'N' END CMARK,
	  	'                    ' ENVIO,
	  	'                                                                                                    ' FILE_PDF,
	  	RL_FILIAL,
		RL_MAT,
		RL_CPFCGC,
		RL_BENEFIC,
		RL_UFBENEF,
		RL_TIPOFJ,
		RL_NOMFONT,
		RL_CGCFONT,
		CASE 
			WHEN GET_AUTOR_EMAIL(TRIM(RL_CPFCGC)) <> ' ' THEN GET_AUTOR_EMAIL(TRIM(RL_CPFCGC)) 
			WHEN TRIM(RA_EMAIL) <> ' ' THEN TRIM(RA_EMAIL) 
			WHEN TRIM( (SELECT MAX(SRA_AUT.RA_EMAIL) FROM %Table:SRA% SRA_AUT WHERE SRA_AUT.RA_CIC = RL_CPFCGC AND SRA_AUT.%NotDel% ) ) IS NOT NULL THEN TRIM( (SELECT MAX(SRA_AUT.RA_EMAIL) FROM %Table:SRA% SRA_AUT WHERE SRA_AUT.RA_CIC = RL_CPFCGC AND SRA_AUT.%NotDel%) ) 
			ELSE (SELECT DISTINCT MAX(A2_EMAIL) FROM %Table:SA2% SA2 WHERE A2_FILIAL = %xFilial:SA2% AND A2_CGC = RL_CPFCGC AND SA2.%NotDel%) END RA_EMAIL,
	  /* 3. Rendimentos Tributแveis, Dedu็๕es e Imposto sobre a Renda Retido na Fonte */
	  SUM( CASE WHEN R4_TIPOREN IN ('A') THEN R4_VALOR ELSE 0 END ) B_3_1, /*--1 Rendimento Tributแvel*/
	  SUM( CASE WHEN R4_TIPOREN IN ('B') THEN R4_VALOR ELSE 0 END ) B_3_2, /*--2 Contribui็๕es Previdenciแrias/Dedu็๕es*/
	  SUM( CASE WHEN R4_TIPOREN IN ('M') THEN R4_VALOR ELSE 0 END ) B_3_3, /*--3 Contribui็ใo เ Previd๊ncia Privada*/
	  SUM( CASE WHEN R4_TIPOREN IN ('C') THEN R4_VALOR ELSE 0 END ) B_3_4, /*--4 Pensใo Judicial*/
	  SUM( CASE WHEN R4_TIPOREN IN ('D') THEN R4_VALOR ELSE 0 END ) B_3_5, /*--5 Imposto retido na fonte*/
	  /* 4. Rendimentos Isentos e Nใo Tributแveis */
	  SUM( CASE WHEN R4_TIPOREN IN ( 'F','F1') THEN R4_VALOR ELSE 0 END ) B_4_1, /*--1 Parcela isenta dos prov entos de aposentadoria, reserv a remunerada, ref orma e pensใo (65 anos ou mais)*/
	  SUM( CASE WHEN R4_TIPOREN IN ('G') THEN R4_VALOR ELSE 0 END )       B_4_2, /*--2 Diแrias e ajudas de custo*/
	  SUM( CASE WHEN R4_TIPOREN IN ('H','H1') THEN R4_VALOR ELSE 0 END )  B_4_3, /*--3 Pensใo e prov entos de aposentadoria ou ref orma por mol้stia grav e; prov entos de aposentadoria ou ref orma por acidente em serv i็o*/
	  SUM( CASE WHEN R4_TIPOREN IN ('P') THEN R4_VALOR ELSE 0 END )       B_4_4, /*--4 Lucros e div idendos, apurados a partir de 1996, pagos por pessoa jurํdica (lucro real, presumido ou arbitrado)*/
	  SUM( CASE WHEN R4_TIPOREN IN ('U') THEN R4_VALOR ELSE 0 END )       B_4_5, /*--5 Valores pagos ao titular ou s๓cio da microempresa ou empresa de pequeno porte, exceto pro labore, alugu้is ou serv i็os prestados  */
	  SUM( CASE WHEN R4_TIPOREN IN ('E') THEN R4_VALOR ELSE 0 END )       B_4_6, /*--6 Indeniza็๕es por rescisใo de contrato de trabalho, inclusiv e a tํtulo de PDV, e por acidente de trabalho*/
	  SUM( CASE WHEN R4_TIPOREN IN ('I','0') THEN R4_VALOR ELSE 0 END )       B_4_7, /*--7 Outros*/
	  /* 5. Rendimentos sujeitos เ Tributa็ใo Exclusiva (rendimento lํquido) */
	  SUM( CASE WHEN R4_TIPOREN IN ( 'J' ) THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( 'K' ) THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( '5' ) THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( 'B1') THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( 'T1') THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( 'C1') THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( 'M1') THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( 'L' ) THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( '1' ) THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( 'S1') THEN R4_VALOR ELSE 0 END )   B_5_1, /*--1 Valor lํquido do 13บ*/
	  SUM(CASE WHEN R4_TIPOREN IN ('L') THEN R4_VALOR ELSE 0 END) B_5_2, /*--2 Imposto sobre a renda retido na f onte sobre 13บ salแrio*/
	  ( SUM(CASE WHEN R4_TIPOREN IN ('O') THEN R4_VALOR ELSE 0 END) - SUM(CASE WHEN R4_TIPOREN IN ('Q') THEN R4_VALOR ELSE 0 END) )
		  +
	  ( SUM(CASE WHEN R4_TIPOREN IN ('O1') THEN R4_VALOR ELSE 0 END) - SUM(CASE WHEN R4_TIPOREN IN ('Q1') THEN R4_VALOR ELSE 0 END) - SUM(CASE WHEN R4_TIPOREN IN ('C3') THEN R4_VALOR ELSE 0 END ) ) B_5_3, /*--3 Outros*/ 
	  
	  SUM( CASE WHEN R4_TIPOREN IN ( 'O1', 'C3' ) THEN R4_VALOR ELSE 0 END ) PLR,  /* ('O1', 'Q1', 'C3') */
	  
	  /*6. Rendimentos Recebidos Acumuladamente - Art. 12-A da Lei nบ 7.713, de 1988 (sujeito เ tributa็ใo exclusiva)*/
	  SUM( CASE WHEN R4_TIPOREN IN ('A1') THEN R4_VALOR ELSE 0 END ) B_6_1, /*--1. Total dos rendimentos tributแv eis (inclusiv e f ้rias e d้cimo terceiro salแrio)*/
	  SUM( CASE WHEN R4_TIPOREN IN ('B3') THEN R4_VALOR ELSE 0 END ) B_6_2, /*--2. Exclusใo: Despesas com a a็ใo judicial*/
	  SUM( CASE WHEN R4_TIPOREN IN ('B2') THEN R4_VALOR ELSE 0 END ) B_6_3, /*--3. Dedu็ใo: Contribui็ใo prev idenciแria of icial*/
	  SUM( CASE WHEN R4_TIPOREN IN ('C2') THEN R4_VALOR ELSE 0 END ) B_6_4, /*--4. Dedu็ใo: Pensใo alimentํcia (preencher tamb้m o quadro 7)*/
	  SUM( CASE WHEN R4_TIPOREN IN ('D2') THEN R4_VALOR ELSE 0 END ) B_6_5, /*--5. Imposto sobre a renda retido na f onte*/
	  SUM( CASE WHEN R4_TIPOREN IN ('I1') THEN R4_VALOR ELSE 0 END ) B_6_6, /*--6. Rendimentos isentos de pensใo, prov entos de aposentadoria ou ref orma por mol้stia grav e ou aposentadoria ou ref orma por acidente em servi็o*/
	  SUM( CASE WHEN R4_TIPOREN IN ('A1','B3','B2','C2','D2','I1') THEN R4_MESES ELSE 0 END ) B_6_QTDM,
	  R4_ANO
	FROM %Table:SRL% SRL
	JOIN %Table:SR4% SR4
	ON R4_FILIAL = RL_FILIAL
	AND R4_MAT = RL_MAT  
	AND R4_CPFCGC = RL_CPFCGC
	AND R4_CODRET = RL_CODRET
	AND R4_ANO = %Exp:MV_PAR04%
	AND SR4.%NotDel% 
	%Exp:cLeftJoin% JOIN %Table:SRA% SRA
	ON RA_FILIAL = RL_FILIAL
	AND RA_MAT = RL_MAT
	AND RA_CIC = RL_CPFCGC
	AND RA_CIC <> ' '
	AND SRA.%NotDel% 
	WHERE RL_FILIAL = %xFilial:SRL%
	AND RL_MAT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND RL_CODRET IN %Exp:cODRET% 
	AND RL_CPFCGC BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
	AND RL_CPFCGC <> ' '
	AND RL_TIPOFJ = %Exp:AllTrim(Str(MV_PAR09))%
	AND SRL.%NotDel%     
	GROUP BY RL_FILIAL,
		RL_MAT,
		RL_CPFCGC,
		RL_BENEFIC,
		RL_UFBENEF,
		RL_TIPOFJ,
		RL_NOMFONT,
		RL_CGCFONT,
		RA_EMAIL,
		R4_ANO  ) TMP
	ORDER BY  RL_FILIAL,
	   RL_BENEFIC,
	   RL_MAT,
	   RL_CPFCGC,	   
	   RL_UFBENEF,
	   RL_TIPOFJ,
	   RL_NOMFONT,
	   RL_CGCFONT,
	   RA_EMAIL,
	   R4_ANO
EndSql

TCSetField(cQryAlias,"B_3_1","N",15,2)
TCSetField(cQryAlias,"B_3_2","N",15,2)
TCSetField(cQryAlias,"B_3_3","N",15,2)
TCSetField(cQryAlias,"B_3_4","N",15,2)
TCSetField(cQryAlias,"B_3_5","N",15,2)
TCSetField(cQryAlias,"B_4_1","N",15,2)
TCSetField(cQryAlias,"B_4_2","N",15,2)
TCSetField(cQryAlias,"B_4_3","N",15,2)
TCSetField(cQryAlias,"B_4_4","N",15,2)
TCSetField(cQryAlias,"B_4_5","N",15,2)
TCSetField(cQryAlias,"B_4_6","N",15,2)
TCSetField(cQryAlias,"B_5_1","N",15,2)
TCSetField(cQryAlias,"B_5_2","N",15,2)
TCSetField(cQryAlias,"B_6_1","N",15,2)
TCSetField(cQryAlias,"B_6_2","N",15,2)
TCSetField(cQryAlias,"B_6_3","N",15,2)
TCSetField(cQryAlias,"B_6_4","N",15,2)
TCSetField(cQryAlias,"B_6_5","N",15,2)
TCSetField(cQryAlias,"B_6_6","N",15,2)

//cFileTmp := ""
//aStruct := DBStruct()
//cFileTmp := Trim(CriaTrab(aStruct, .F. ))//+".dtc"
//cFileSrv := ""
//cFileSrv := "\data\"+cFileTmp
//COPY TO &(cFileTmp) VIA RDDName() 

aQuery	:= Getlastquery()
aStruct := DBStruct()

(cQryAlias)->(DbCloseArea())

_oDIRFTMP := FWTemporaryTable():New( "DIRF_TMP" )  
_oDIRFTMP:SetFields(aStruct) 
_oDIRFTMP:AddIndex("1", {"RL_FILIAL","RL_MAT"})

//------------------
//Cria็ใo da tabela temporaria
//------------------
_oDIRFTMP:Create()  

Processa({||SqlToTrb(aQuery[2], aStruct, "DIRF_TMP")})	// Cria arquivo temporario

DbSelectArea("DIRF_TMP")

//DbUseArea(.T., "TOPCONN",cFileTmp,"DIRF_TMP", .F.)
//DbSelectArea("DIRF_TMP")
//IndRegua("DIRF_TMP","IDX1","Alltrim(str(RECSRL))",,,OemToAnsi("Criando Arquivo Temporario...") )

If Select("COMPLEMEN") > 0
	COMPLEMEN->(DbCloseArea())
EndIf

//cComple := CriaTrab(aStruRCS,.T.)
//DbUseArea(.T., "TOPCONN",cComple,"COMPLEMEN", .F.)
//cInd1 := CriaTrab(nil,.F.)
//IndRegua("COMPLEMEN",cInd1,"RCS_MAT+RCS_NOME+RCS_VERBA",,.F.,,"Selecionando Registros...")        

//Cria o Objeto do FwTemporaryTable
oCOMPLEMEN := FwTemporaryTable():New("COMPLEMEN")

//Cria a estrutura do alias temporario
oCOMPLEMEN:SetFields(aStruRCS)
                                             
//Adiciona o indicie na tabela temporaria
oCOMPLEMEN:AddIndex("1",Separa("RCS_MAT+RCS_NOME+RCS_VERBA",'+'))

//Criando a Tabela Temporaria
oCOMPLEMEN:Create()

RCS->(DbSetOrder(1)) //RCS_FILIAL+RCS_MAT+RCS_TIPOFJ+RCS_CPFBEN+RCS_CODRET+RCS_ANO+RCS_VERBA+RCS_TIPORE

DIRF_TMP->(DbGoTop())
While DIRF_TMP->(!EOF())
	nTotRegs++
	If RCS->(DbSeek(DIRF_TMP->RL_FILIAL+DIRF_TMP->RL_MAT))
		While DIRF_TMP->RL_FILIAL+DIRF_TMP->RL_MAT == RCS->(RCS_FILIAL+RCS_MAT) .AND. RCS->RCS_CPFBEN == DIRF_TMP->RL_CPFCGC
			
			If RCS->RCS_ANO <> MV_PAR04 .OR. !(RCS->RCS_CODRET $ MV_PAR03+"#3562")
				RCS->(DbSkip())
				Loop
			EndIf
			
			RecLock("COMPLEMEN",.T.)
			aEval(aStruRCS, {|x| COMPLEMEN->&(x[1]) := RCS->&(x[1]) } )
			MsUnLock()
			RCS->(DbSkip())
		EndDo	
	EndIF
	
	DIRF_TMP->(DbSkip())
EndDo
DIRF_TMP->(DbGoTop())

If DIRF_TMP->(!EOF())//Len(aDados) > 0

	If MV_PAR09 == 2
		BasePJMes(cQryPJMes,cODRET)
	EndIF
	
	DEFINE MSDIALOG oDlgDIRF TITLE "DIRF" From 10,10 To 600,1200 pixel Style 128
						
	oDlgDIRF:lMaximized := .F.
	oDlgDIRF:SetColor(CLR_BLACK,CLR_WHITE)
	oDlgDIRF:SetFont(oFont)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณArmazena as corrdenadas da tela                                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nMbrWidth	:= oDlgDIRF:nWidth/2-43
	nMbrHeight	:= oDlgDIRF:nHeight/2
	
	@00,00 MSPANEL oMainTop PROMPT "" SIZE nMbrWidth,60/*nMbrHeight*0.10*/  of oDlgDIRF
	oMainTop:Align	:= CONTROL_ALIGN_TOP
	oGrpFilt		:= TGroup():New(05,05,(oMainTop:NCLIENTHEIGHT/2),(oMainTop:NCLIENTWIDTH/2)-10,"",oMainTop,CLR_RED,,.T.)
                                     	
	cTitAux	:= '<p style="margin:-20px" align="center"><font size="5" color="black">'+AllTrim(cDescRet)+"( "+MV_PAR03+" )"+'</font></p>'
	cTitAux	+= '<p style="margin:-20px" align="center"><font size="5" color="black">Exercํcio de '+Soma1(MV_PAR04)+'</font></p>'
	cTitAux	+= '<p style="margin:-20px" align="center"><font size="5" color="black">Ano-calendแrio de '+MV_PAR04+'</font></p>'
		
	oInfo	:= TSay():New(10,00,{|| cTitAux },oMainTop,,oFont,,,,.T.,CLR_RED,CLR_WHITE,(oMainTop:NCLIENTWIDTH/2),40,,,,,,lHtml)
	//oInfo:SetCss("QLabel{ margin: -20px }")
    
	oMCopy	:= TGet():New(35,10,{|u| if( Pcount()>0, cMailCopy:= u,cMailCopy ) },oMainTop,150,010,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cMailCopy",,,,,,,"E-Mail Copia.: ",1,oFont,CLR_RED )
	oMCopy:bValid		:= {|x| .F. }
	oMCopy:lReadOnly	:= .T.
	
	oButEnv		:= TButton():New( 43, 170, "Enviar"			, oMainTop,{|| EnvMail(cDescRet,MV_PAR03) },50,010,,,,.T.)
	oButAnex	:= TButton():New( 43, 230, "Proc.PDF"			, oMainTop,{|| Processa( {|| ProcAllPDF(cDescRet,MV_PAR03) }, "Aguarde...", "Gerando arquivos...", .F.) },50,010,,,,.T.)
	
	If MV_PAR09 == 1
		oButView	:= TButton():New( 43, 290, "Imprimir"	   		, oMainTop,{|| U_GGDIRFPF(nil,nil,MV_PAR04,MV_PAR03,MV_PAR06,.T.,cDescRet) },50,010,,,,.T.)
	Else
		If "5952" $ cODRET
			oButView	:= TButton():New( 43, 290, "Imprimir"	   		, oMainTop,{|| U_GGDIRPJb(nil,nil,MV_PAR04,MV_PAR03,MV_PAR06,.T.,cDescRet) },50,010,,,,.T.)
		Else	
			oButView	:= TButton():New( 43, 290, "Imprimir"	   		, oMainTop,{|| U_GGDIRFPJ(nil,nil,MV_PAR04,MV_PAR03,MV_PAR06,.T.,cDescRet) },50,010,,,,.T.)
		EndIF	
	EndIF	
	
	oButMark	:= TButton():New( 43, 350, "Marca todos"		, oMainTop,{|| Processa( {|| MarkAll(.T.) }, "Aguarde...", "...", .F.)  },50,010,,,,.T.)
	oButNoMar	:= TButton():New( 43, 410, "Desmarca todos"	, oMainTop,{|| Processa( {|| MarkAll(.F.) }, "Aguarde...", "...", .F.) },50,010,,,,.T.)
	
	@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgDIRF
	oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT
	
	oGrpXML	:= TGroup():New(05,05,(oMainCentro:NCLIENTHEIGHT/2)-40,(oMainCentro:NCLIENTWIDTH/2)-10,"",oMainCentro,CLR_RED,,.T.)
	aHList	:= {}
	
	oListBox := TWBrowse():New(15,10,(oMainCentro:NCLIENTWIDTH/2)-30,(oMainCentro:NCLIENTHEIGHT/2)-60,,aHList,,oMainCentro,,,,,,,,,,,,, "DIRF_TMP", .T. )
	
	oListBox:AddColumn(TCColumn():New(" "				,{|| IIF( DIRF_TMP->CMARK == "S", oMarked , oNoMarked )	},,,,'CENTER'		,15,.T.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New(" "				,{|| IIF( EMPTY(DIRF_TMP->FILE_PDF) .OR. EMPTY(DIRF_TMP->RA_EMAIL) , oVerme , IIF(Empty(DIRF_TMP->ENVIO),oAzul,oVerde) )	},,,,'CENTER'		,15,.T.,.F.,,,,.F.,))
	
	oListBox:AddColumn(TCColumn():New("Matricula"		,{|| DIRF_TMP->RL_MAT  			},,,,'LEFT'		,045,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("CGC"	   			,{|| DIRF_TMP->RL_CPFCGC		},,,,'LEFT'		,060,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("Beneficiario"	,{|| DIRF_TMP->RL_BENEFIC		},,,,'LEFT'		,150,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("UF"				,{|| DIRF_TMP->RL_UFBENEF		},,,,'LEFT'		,010,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("E-Mail"			,{|| DIRF_TMP->RA_EMAIL	   		},,,,'LEFT'		,150,.F.,.F.,,,,.F.,))			
	oListBox:AddColumn(TCColumn():New("Tipo"			,{|| DIRF_TMP->RL_TIPOFJ 		},,,,'LEFT'		,020,.F.,.F.,,,,.F.,))		
	oListBox:AddColumn(TCColumn():New("Fonte Pagadora"	,{|| DIRF_TMP->RL_NOMFONT		},,,,'LEFT'		,150,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("CGC Fonte"		,{|| DIRF_TMP->RL_CGCFONT		},,,,'LEFT'		,050,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("PDF"				,{|| DIRF_TMP->FILE_PDF			},,,,'LEFT'		,150,.F.,.F.,,,,.F.,))
		
	oListBox:bLDblClick := {|| RecLock("DIRF_TMP",.F.), DIRF_TMP->CMARK :=  IIF(DIRF_TMP->CMARK <> "S","S","") , MsUnLock() ,oListBox:DrawSelect()}
	
	ACTIVATE MSDIALOG oDlgDIRF On Init EnchoiceBar(oDlgDIRF,bConfirm,bCancel,,aButtons) Centered 
Else
	MsgStop("Nใo foram encontradas informa็๕es com os parametros informados!")	
EndIf

COMPLEMEN->(DbCloseArea())
DIRF_TMP->(DbCloseArea())

If Select("DIRF_PJ") > 0
	DIRF_PJ->(DbCloseArea())
EndIf	

//FErase("\system\"+cInd1+".cdx")
//FErase("\system\"+cComple+".dtc")
//FErase("\data\"+cFileSrv+".dtc")
//FErase("\system\"+cFileTmp)//+".dtc")
FWCloseTemp("DIRF_TMP")

//FErase("\system\"+cInd2+".cdx")
//FErase("\data\"+cFileSrv2+".dtc")
//FErase("\system\"+cFileTmp2+".dtc")

RestArea(aArea)

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


Static Function ProcAllPDF(cDescRet,cODRET)

Local cFile		:= ""
Local cDir		:= "\workflow\Anexos\DIRF_"+AllTrim(cFilant)+"_"+MV_PAR04+"\"+cODRET+"\"
Local nAuxCont	:= 0
Local nTenta	:= 0

IF !MsgYesNo("Confirma processamento dos anexos?")
	Return nil
EndIF

ProcRegua(nTotRegs)

WFForceDir(cDir)

DIRF_TMP->(DbGoTop())

While DIRF_TMP->(!EOF())
	
	IncProc()
	
	If DIRF_TMP->CMARK <> "S"
		DIRF_TMP->(DbSkip())
		Loop
	EndIf
	
	nTenta++
	
	cFile	:= AllTrim(DIRF_TMP->RL_CPFCGC)+MV_PAR04+"_"+AllTrim(MV_PAR03)
	
	FErase(cDir+cFile+".pdf")
	nAuxCont	:= 0
	While !File(cDir+cFile+".pdf") .AND. nAuxCont <= 3
		nAuxCont++

		If MV_PAR09 == 1
			U_GGDIRFPF(cDir,cFile,MV_PAR04,MV_PAR03,MV_PAR06,.F.,cDescRet)
		Else 
			If "5952" $ cODRET		
				U_GGDIRPJb(cDir,cFile,MV_PAR04,MV_PAR03,MV_PAR06,.F.,cDescRet)
			Else	
				U_GGDIRFPJ(cDir,cFile,MV_PAR04,MV_PAR03,MV_PAR06,.F.,cDescRet)
			EndIf	
		EndIF	

		If !File(cDir+cFile+".pdf")
			Sleep(3000)
		EndIF
	EndDo
    
	aFiles := Directory(cDir+cFile+".pdf")
	
	If Len(aFiles) == 0 .OR. aFiles[1][2] == 0
		Sleep(3000)
	EndIf
	
	aFiles := Directory(cDir+cFile+".pdf")
	
	If File(cDir+cFile+".pdf") .AND. Len(aFiles) > 0 .AND. aFiles[1][2] > 0
		nTenta	:= 0
		RecLock("DIRF_TMP",.F.)
		DIRF_TMP->FILE_PDF	:= cDir+cFile+".pdf"
		MsUnLock()	
	Else//If nTenta > 3 // tento 3 vezes antes de abortar a gera็ใo do arquivo
		nTenta	:= 0
		MsgStop("Nใo foi possํvel gerar o arquivo para a matricula "+DIRF_TMP->RL_MAT+"("+AllTrim(DIRF_TMP->RL_BENEFIC)+")"+Chr(13)+Chr(10)+"Tente novamente caso o problema continue entre em contato com departamento de TI!")	
	//Else // tentar mais uma vez
	  //	Loop
	EndIF
				
	DIRF_TMP->(DbSkip())
EndDo

oListBox:GoTop()
oListBox:DrawSelect()

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


Static Function EnvMail(cDescRet,cODRET)

Local cFile		:= ""
Local cDir		:= "\workflow\Anexos\DIRF_"+AllTrim(cFilant)+"_"+MV_PAR04+"\"+cODRET+"\"
Local nAuxCont	:= 0
Local aLog		:= {}
Local cAssunto	:= "Informe de Rendimentos "+MV_PAR04+", "+AllTrim(cDescRet)+"("+MV_PAR03+")"

Local lConexao			:= .F.
Local lEnvio   			:= .F.
Local lDesconexao		:= .F.
Local cMailServer  		:= "smtp.grupogen.com.br"
//Local cMailConta   		:= "noreply@grupogen.com.br"
Local cMailConta   		:= "informes@grupogen.com.br"
//Local cMailSenha   		:= "genrj$1311"
Local cMailSenha   		:= "irfp2016$"
Local cErro_Conexao		:= ""
Local cErro_Envio		:= ""
Local cErro_Desconexao	:= ""
Local aEmail			:= {}


nOpcMail := Aviso("Envio","Confirma o envios dos e-mails?",{"&Conferencia","&Beneficiario","&Cancelar"},3)

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
		
ProcRegua(nTotRegs)

DIRF_TMP->(DbGoTop())

While DIRF_TMP->(!EOF())
	
	IncProc()
	
	If DIRF_TMP->CMARK <> "S"
		DIRF_TMP->(DbSkip())
		Loop
	EndIf
	
	If Empty(DIRF_TMP->RA_EMAIL)
		Aadd(aLog,"E-Mail nใo informado ou invalido para matricula "+DIRF_TMP->RL_MAT+"("+AllTrim(DIRF_TMP->RL_BENEFIC)+")")
		MsgStop("E-Mail nใo informado ou invalido para matricula "+DIRF_TMP->RL_MAT+"("+AllTrim(DIRF_TMP->RL_BENEFIC)+")")	
		DIRF_TMP->(DbSkip())
		Loop
	Else
		aEmail		:= StrTokArr(DIRF_TMP->RA_EMAIL,";")	
		cMailFim	:= ""	
		 For nAuxVld := 1 To Len(aEmail)
		 	If ISEMAIL(AllTrim(aEmail[nAuxVld]))
		 		cMailFim += AllTrim(aEmail[nAuxVld])+";"
		 	EndIf
		 Next
		cMailFim := Left(cMailFim,Len(cMailFim)-1)
		
		If Empty(cMailFim)
			Aadd(aLog,"E-Mail nใo informado ou invalido para matricula "+DIRF_TMP->RL_MAT+"("+AllTrim(DIRF_TMP->RL_BENEFIC)+")")
			MsgStop("E-Mail nใo informado ou invalido para matricula "+DIRF_TMP->RL_MAT+"("+AllTrim(DIRF_TMP->RL_BENEFIC)+")")	
			DIRF_TMP->(DbSkip())
			Loop			
		EndIF
		
	EndIf

	aFiles := Directory(DIRF_TMP->FILE_PDF)
			
	If File(DIRF_TMP->FILE_PDF)  .AND. Len(aFiles) > 0 .AND. aFiles[1][2] > 0

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
		cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0"><font face="Calibri">Prezado(a) <b>'+AllTrim(DIRF_TMP->RL_BENEFIC)+'</b></font></p> '+Chr(13)+Chr(10)
		cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0">&nbsp;</p> '+Chr(13)+Chr(10)
		
		cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0"><span style="font-size: 12pt; font-family: Calibri">Segue em anexo seu Informe de Rendimentos referente ao Ano-Calendแrio de '+MV_PAR04+'.</span></font></p> '+Chr(13)+Chr(10)

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
		cAnexos 	:= AllTrim(DIRF_TMP->FILE_PDF)
		CMAILCOPY   := MV_PAR05
		
		If nOpcMail == 1
			cMailDest	:= MV_PAR05
		Else 
			cMailDest	:= Alltrim(DIRF_TMP->RA_EMAIL)
		Endif
		//cMailDest	:= MV_PAR05

		Send Mail From cMailConta To cMailDest BCC cMailCopy SubJect cAssunto BODY cBody FORMAT TEXT ATTACHMENT cAnexos RESULT lEnvio
			
		If !lEnvio
			Get Mail Error cErro_Envio
			Aviso( "Envio de Email " + Procname(), OemToAnsi("Nao foi possivel ENVIAR a mensagem - " + cErro_Envio + " - SERVIDOR:" + cMailServer+"  CONTA:"+cMailConta+' - DESTINO:' + cMailDest), {"&Ok"} )
			If MsgYesNo("Finalizar envio?")
				Exit
			EndIf
		Else
			Aadd(aLog,"Informe enviado para "+AllTrim(DIRF_TMP->RL_BENEFIC)+"("+DIRF_TMP->RL_MAT+")"+", e-mail "+AllTrim(DIRF_TMP->RA_EMAIL)+" em "+DtoC(DDataBase)+" as "+Time()+",  anexo "+AllTrim(DIRF_TMP->FILE_PDF))
			RecLock("DIRF_TMP",.F.)
			DIRF_TMP->ENVIO	:= DtoC(DDataBase)+" "+Time()
			DIRF_TMP->CMARK	:= "N"
			MsUnLock()			
		EndIf
					
		/*
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณGera objeto html.                                                                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oProcess := TWFProcess():New( "000001", "Envio de Informe" )
		oProcess:NewTask("Envio Informe","\workflow\HTML\INFORMERENDIMENTOS_PF.htm")
		oProcess:cTo		:= MV_PAR05//DIRF_TMP->RA_EMAIL
		//oProcess:CCC		:= MV_PAR05
		//cBCC
		oProcess:cSubject	:= cAssunto
		
		oProcess:ohtml:ValByName("NOMEDEST",AllTrim(DIRF_TMP->RL_BENEFIC))
		oProcess:ohtml:ValByName("ANOCALEND",MV_PAR04)
		
		oProcess:AttachFile(DIRF_TMP->FILE_PDF,.F.)
		
		oProcess:Start()
		//WFSENDMAIL({cEmpAnt,cFilAnt})
		
		FreeObj(oProcess)		
		oProcess	:= nil
		
		RecLock("DIRF_TMP",.F.)
		DIRF_TMP->ENVIO	:= DtoC(DDataBase)+" "+Time()
		DIRF_TMP->CMARK	:= "N"
		MsUnLock()
		
		Aadd(aLog,"Informe enviado para "+AllTrim(DIRF_TMP->RL_BENEFIC)+"("+DIRF_TMP->RL_MAT+")"+", e-mail "+AllTrim(DIRF_TMP->RA_EMAIL)+" em "+DtoC(DDataBase)+" as "+Time()+",  anexo "+AllTrim(DIRF_TMP->FILE_PDF))
		*/  
	Else
		Aadd(aLog,"Arquivo de Informe nใo encontrado para matricula "+DIRF_TMP->RL_MAT+"("+AllTrim(DIRF_TMP->RL_BENEFIC)+")"+Chr(13)+Chr(10)+"Tente novamente, caso o problema continue entre em contato com departamento de TI!")
		MsgStop("Arquivo de Informe nใo encontrado para matricula "+DIRF_TMP->RL_MAT+"("+AllTrim(DIRF_TMP->RL_BENEFIC)+")"+Chr(13)+Chr(10)+"Tente novamente, caso o problema continue entre em contato com departamento de TI!")	
	EndIF
				
	DIRF_TMP->(DbSkip())
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEXECUTA desconexao ao servidor SMTPณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DisConnect Smtp Server Result lDesconexao

IF !lDesconexao
	Get Mail Error cErro_Desconexao
	Aviso( "Envio de Email", OemToAnsi("Nao foi possivel DESCONECTAR do servidor - " + cErro_Desconexao), {"&Ok"} )
	Return(.F.)
EndIf
		
oListBox:GoTop()
oListBox:DrawSelect()

ViewLog(aLog)

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
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function MarkAll(lMark)

DIRF_TMP->(DbGoTop())

ProcRegua(nTotRegs)

While DIRF_TMP->(!EOF())
	
	IncProc()
	
	RecLock("DIRF_TMP",.F.)
	DIRF_TMP->CMARK	:=  IIF( lMark , "S" , "N" ) //"S" //IIF( !Empty(DIRF_TMP->RA_EMAIL) .AND. ISEMAIL(AllTrim(DIRF_TMP->RA_EMAIL)) .AND. lMark,"S","N")
	MsUnLock()
				
	DIRF_TMP->(DbSkip())
EndDo

oListBox:GoTop()
oListBox:DrawSelect()

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

Static Function BasePJMes(cQryPJMes,cODRET)

BeginSql Alias cQryPJMes
		
	SELECT
	  	RL_FILIAL,
		RL_MAT,
		RL_CPFCGC,
		RL_BENEFIC,
		RL_UFBENEF,
		RL_TIPOFJ,
		RL_NOMFONT,
		RL_CGCFONT,
	  /* 3. Rendimentos Tributแveis, Dedu็๕es e Imposto sobre a Renda Retido na Fonte */
	  SUM( CASE WHEN R4_TIPOREN IN ('A') THEN R4_VALOR ELSE 0 END ) B_3_1, /*--1 Rendimento Tributแvel*/
	  SUM( CASE WHEN R4_TIPOREN IN ('B') THEN R4_VALOR ELSE 0 END ) B_3_2, /*--2 Contribui็๕es Previdenciแrias/Dedu็๕es*/
	  SUM( CASE WHEN R4_TIPOREN IN ('M') THEN R4_VALOR ELSE 0 END ) B_3_3, /*--3 Contribui็ใo เ Previd๊ncia Privada*/
	  SUM( CASE WHEN R4_TIPOREN IN ('C') THEN R4_VALOR ELSE 0 END ) B_3_4, /*--4 Pensใo Judicial*/
	  SUM( CASE WHEN R4_TIPOREN IN ('D') THEN R4_VALOR ELSE 0 END ) B_3_5, /*--5 Imposto retido na fonte*/
	  /* 4. Rendimentos Isentos e Nใo Tributแveis */
	  SUM( CASE WHEN R4_TIPOREN IN ( 'F','F1') THEN R4_VALOR ELSE 0 END ) B_4_1, /*--1 Parcela isenta dos prov entos de aposentadoria, reserv a remunerada, ref orma e pensใo (65 anos ou mais)*/
	  SUM( CASE WHEN R4_TIPOREN IN ('G') THEN R4_VALOR ELSE 0 END )       B_4_2, /*--2 Diแrias e ajudas de custo*/
	  SUM( CASE WHEN R4_TIPOREN IN ('H','H1') THEN R4_VALOR ELSE 0 END )  B_4_3, /*--3 Pensใo e prov entos de aposentadoria ou ref orma por mol้stia grav e; prov entos de aposentadoria ou ref orma por acidente em serv i็o*/
	  SUM( CASE WHEN R4_TIPOREN IN ('P') THEN R4_VALOR ELSE 0 END )       B_4_4, /*--4 Lucros e div idendos, apurados a partir de 1996, pagos por pessoa jurํdica (lucro real, presumido ou arbitrado)*/
	  SUM( CASE WHEN R4_TIPOREN IN ('U') THEN R4_VALOR ELSE 0 END )       B_4_5, /*--5 Valores pagos ao titular ou s๓cio da microempresa ou empresa de pequeno porte, exceto pro labore, alugu้is ou serv i็os prestados  */
	  SUM( CASE WHEN R4_TIPOREN IN ('E') THEN R4_VALOR ELSE 0 END )       B_4_6, /*--6 Indeniza็๕es por rescisใo de contrato de trabalho, inclusiv e a tํtulo de PDV, e por acidente de trabalho*/
	  SUM( CASE WHEN R4_TIPOREN IN ('I') THEN R4_VALOR ELSE 0 END )       B_4_7, /*--7 Outros*/
	  /* 5. Rendimentos sujeitos เ Tributa็ใo Exclusiva (rendimento lํquido) */
	  SUM( CASE WHEN R4_TIPOREN IN ( 'J' ) THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( 'K' ) THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( '5' ) THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( 'B1') THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( 'T1') THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( 'C1') THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( 'M1') THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( 'L' ) THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( '1' ) THEN R4_VALOR ELSE 0 END ) -
	  SUM( CASE WHEN R4_TIPOREN IN ( 'S1') THEN R4_VALOR ELSE 0 END )   B_5_1, /*--1 Valor lํquido do 13บ*/
	  SUM(CASE WHEN R4_TIPOREN IN ('L') THEN R4_VALOR ELSE 0 END) B_5_2, /*--2 Imposto sobre a renda retido na f onte sobre 13บ salแrio*/
	  ( SUM(CASE WHEN R4_TIPOREN IN ('O') THEN R4_VALOR ELSE 0 END) - SUM(CASE WHEN R4_TIPOREN IN ('Q') THEN R4_VALOR ELSE 0 END) )
		  +
	  ( SUM(CASE WHEN R4_TIPOREN IN ('O1') THEN R4_VALOR ELSE 0 END) - SUM(CASE WHEN R4_TIPOREN IN ('Q1') THEN R4_VALOR ELSE 0 END) - SUM(CASE WHEN R4_TIPOREN IN ('C3') THEN R4_VALOR ELSE 0 END ) ) B_5_3, /*--3 Outros*/ 
	  
	  SUM( CASE WHEN R4_TIPOREN IN ( 'O1', 'Q1', 'C3' ) THEN R4_VALOR ELSE 0 END ) PLR,
	  
	  /*6. Rendimentos Recebidos Acumuladamente - Art. 12-A da Lei nบ 7.713, de 1988 (sujeito เ tributa็ใo exclusiva)*/
	  SUM( CASE WHEN R4_TIPOREN IN ('A1') THEN R4_VALOR ELSE 0 END ) B_6_1, /*--1. Total dos rendimentos tributแv eis (inclusiv e f ้rias e d้cimo terceiro salแrio)*/
	  SUM( CASE WHEN R4_TIPOREN IN ('B3') THEN R4_VALOR ELSE 0 END ) B_6_2, /*--2. Exclusใo: Despesas com a a็ใo judicial*/
	  SUM( CASE WHEN R4_TIPOREN IN ('B2') THEN R4_VALOR ELSE 0 END ) B_6_3, /*--3. Dedu็ใo: Contribui็ใo prev idenciแria of icial*/
	  SUM( CASE WHEN R4_TIPOREN IN ('C2') THEN R4_VALOR ELSE 0 END ) B_6_4, /*--4. Dedu็ใo: Pensใo alimentํcia (preencher tamb้m o quadro 7)*/
	  SUM( CASE WHEN R4_TIPOREN IN ('D2') THEN R4_VALOR ELSE 0 END ) B_6_5, /*--5. Imposto sobre a renda retido na f onte*/
	  SUM( CASE WHEN R4_TIPOREN IN ('I1') THEN R4_VALOR ELSE 0 END ) B_6_6, /*--6. Rendimentos isentos de pensใo, prov entos de aposentadoria ou ref orma por mol้stia grav e ou aposentadoria ou ref orma por acidente em servi็o*/
	  SUM( CASE WHEN R4_TIPOREN IN ('A1','B3','B2','C2','D2','I1') THEN R4_MESES ELSE 0 END ) B_6_QTDM,
	  R4_MES,
	  R4_ANO
	FROM %Table:SRL% SRL
	JOIN %Table:SR4% SR4
	ON R4_FILIAL = RL_FILIAL
	AND R4_MAT = RL_MAT  
	AND R4_CPFCGC = RL_CPFCGC
	AND R4_CODRET = RL_CODRET
	AND R4_ANO = %Exp:MV_PAR04%
	AND SR4.%NotDel% 
	%Exp:cLeftJoin% JOIN %Table:SRA% SRA
	ON RA_FILIAL = RL_FILIAL
	AND RA_MAT = RL_MAT
	AND RA_CIC = RL_CPFCGC
	AND SRA.%NotDel% 
	WHERE RL_FILIAL = %xFilial:SRL%
	AND RL_MAT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND RL_CODRET IN %Exp:cODRET% 
	AND RL_CPFCGC BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
	AND RL_TIPOFJ = %Exp:AllTrim(Str(MV_PAR09))%
	AND RL_CPFCGC <> ' '
	AND SRL.%NotDel%     
	GROUP BY RL_FILIAL,
		RL_MAT,
		RL_CPFCGC,
		RL_BENEFIC,
		RL_UFBENEF,
		RL_TIPOFJ,
		RL_NOMFONT,
		RL_CGCFONT,  
		R4_ANO,
		R4_MES 
	ORDER BY  RL_FILIAL,
	   RL_BENEFIC,
	   RL_MAT,
	   RL_CPFCGC,	   
	   RL_UFBENEF,
	   RL_TIPOFJ,
	   RL_NOMFONT,
	   RL_CGCFONT,
	   R4_ANO,
	   R4_MES		
EndSql

TCSetField(cQryPJMes,"B_3_1","N",15,2)
TCSetField(cQryPJMes,"B_3_2","N",15,2)
TCSetField(cQryPJMes,"B_3_3","N",15,2)
TCSetField(cQryPJMes,"B_3_4","N",15,2)
TCSetField(cQryPJMes,"B_3_5","N",15,2)
TCSetField(cQryPJMes,"B_4_1","N",15,2)
TCSetField(cQryPJMes,"B_4_2","N",15,2)
TCSetField(cQryPJMes,"B_4_3","N",15,2)
TCSetField(cQryPJMes,"B_4_4","N",15,2)
TCSetField(cQryPJMes,"B_4_5","N",15,2)
TCSetField(cQryPJMes,"B_4_6","N",15,2)
TCSetField(cQryPJMes,"B_5_1","N",15,2)
TCSetField(cQryPJMes,"B_5_2","N",15,2)
TCSetField(cQryPJMes,"B_6_1","N",15,2)
TCSetField(cQryPJMes,"B_6_2","N",15,2)
TCSetField(cQryPJMes,"B_6_3","N",15,2)
TCSetField(cQryPJMes,"B_6_4","N",15,2)
TCSetField(cQryPJMes,"B_6_5","N",15,2)
TCSetField(cQryPJMes,"B_6_6","N",15,2)

/*
cFileTmp2 := ""
cFileTmp2 := Trim(CriaTrab( NIL, .F. ))//+".dtc"
cFileSrv2 := ""
cFileSrv2 := "\data\"+cFileTmp2

COPY TO (cFileSrv2) VIA "TOPCONN"

(cQryPJMes)->(DbCloseArea())

If Select("DIRF_PJ") >0 
	DIRF_PJ->(DbCloseArea())
EndIF

DbUseArea(.T., "TOPCONN",cFileSrv2,"DIRF_PJ", .F.)
DbSelectArea("DIRF_PJ")
cInd2 := CriaTrab(nil,.F.)
IndRegua("DIRF_PJ",cInd2,"RL_CPFCGC+RL_TIPOFJ+R4_MES",,,OemToAnsi("Criando Arquivo Temporario...") )
*/

aQuery	:= Getlastquery()
aStruct := DBStruct()

_oDIRFTMP := FWTemporaryTable():New( "DIRF_PJ" )  
_oDIRFTMP:SetFields(aStruct) 
_oDIRFTMP:AddIndex("1", {"RL_CPFCGC","RL_TIPOFJ","R4_MES"})

//------------------
//Cria็ใo da tabela temporaria
//------------------
_oDIRFTMP:Create()  

Processa({||SqlToTrb(aQuery[2], aStruct, "DIRF_PJ")})	// Cria arquivo temporario

DbSelectArea("DIRF_PJ")

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


Static Function PrintReport(oReport,aLog)

Local oSection0 := oReport:Section(1)

For nx:=1 To Len(aLog)
 
 oReport:IncMeter()
 
 oSection0:Init()
 
 oSection0:Cell("LOG"):SetValue(AllTrim(aLog[nx]))
 
 oSection0:PrintLine()      
  
Next nx

oSection0:Finish()

Return 
