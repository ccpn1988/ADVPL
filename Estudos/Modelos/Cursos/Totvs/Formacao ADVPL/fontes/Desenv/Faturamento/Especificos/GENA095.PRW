/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA095   ºAutor  ³Cleuto Lima         º Data ³  26/12/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ controle de logradouros Gen.                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gen                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA095(cCep)

Local lRet      := .T.
Local cInsert   := ""

cCep    := StrTran(StrTran(cCep,"-",""),".","")

cInsert := "INSERT INTO DBA_EGK.GEN_PROD_CEP (CEP, STATUS) VALUES ('"+cCep+"','0')"
BEGIN TRANSACTION 
    TCSqlExec(cInsert)
END TRANSACTION	

Return lRet

User Function GENA095A(cString)

Local cRet	:= StrTran(AnsiToOem(AllTrim( cString )),"'","")

	If Select("TMP_TIRAAC") > 0
		TMP_TIRAAC->(DbCloseArea())
	EndIf
	
	BeginSql Alias "TMP_TIRAAC"
		SELECT DBA_EGK.F_TIRA_ACENTO(%Exp:cRet%) NEW_INFO FROM DUAL
	EndSql
	TMP_TIRAAC->(DbGoTop())
	
	cRet	:= ALLTRIM(TMP_TIRAAC->NEW_INFO)
	
	TMP_TIRAAC->(DbCloseArea())

Return cRet

/*
valida o CEP do cliente e armazena na base de conhecimento do Gen
*/

User Function GENA095C(cCep,cUF,cEstado,cCodMun,cMunicio)

Local lRet		:= .F.
Local cRetCep	:= ""
Local oXml		:= nil
Local cError	:= ""
Local cWarning	:= ""

cCep	:= StrTran(StrTran(cCep,"-",""),".","")

IF Len(AllTrim(cCep)) <> 8
	Return .F.
EndIF

cRetCep := HttpGet('https://viacep.com.br/ws/'+cCep+'/xml/')

If ValType(cRetCep) == "C"
	cRetCep := DeCodeUtf8(cRetCep)
else
	Return .F.	
EndIF	

oXml := XmlParser( cRetCep, "_", @cError, @cWarning )
Do Case
	Case oXml == NIL 
		Return .F.
	Case !ValType(XmlChildEx( oXml , "_XMLCEP" )) == "O"	
		Return .F.
	Case !ValType(XmlChildEx( oXml:_XMLCEP , "_IBGE" )) == "O"		
		Return .F.
	Case !ValType(XmlChildEx( oXml:_XMLCEP , "_CEP" )) == "O"		
		Return .F.
	Case !ValType(XmlChildEx( oXml:_XMLCEP , "_UF" )) == "O"
		Return .F.
	Case !ValType(XmlChildEx( oXml:_XMLCEP , "_LOCALIDADE" )) == "O"
		Return .F.		
	Case !ExistCpo("CC2",AllTrim(oXml:_XMLCEP:_UF:TEXT)+Right(AllTrim(oXml:_XMLCEP:_IBGE:TEXT),5))
		Return .F.
	OTHERWISE
		lRet		:= .T.
		cUF			:= AllTrim(oXml:_XMLCEP:_UF:TEXT)
		cCodMun		:= Right(AllTrim(oXml:_XMLCEP:_IBGE:TEXT),5)
		cMunicio	:= AllTrim(Posicione("CC2",1,xFilial("CC2")+cUF+cCodMun,"CC2_MUN"))
        cEstado     := AllTrim(Posicione("SX5",1,xFilial("SX5")+"12"+cUF,"X5_DESCRI"))

        U_GENA095(cCep)

EndCase

Return lRet

/* armazena os dados de CEP nas tabela de conhecimento do gen */

Static Function GENI095D(cCep,cUF,cMunicio,cBairro,cLogra)

Local nCodUf	:= 0
Local nCodCid	:= 0
Local cCodBai	:= 0

IF Select("TMP_UF") > 0
	TMP_UF->(DbCloseArea())
ENDIF

BeginSql Alias "TMP_UF"
	SELECT COUNT(*) QTD FROM CEP_LOGRADOUROS
	WHERE NO_LOGRADOURO_CEP = %Exp:cCep%
EndSql

IF TMP_UF->QTD == 0
	TMP_UF->(DbCloseArea())

	BeginSql Alias "TMP_UF"
		SELECT CD_UF FROM CEP_UF
		WHERE DS_UF_SIGLA = %Exp:cUF%
	EndSql

	nCodUf := TMP_UF->CD_UF

	TMP_UF->(DbCloseArea())

	BeginSql Alias "TMP_UF"
		SELECT CD_CIDADE FROM CEP_CIDADES
		WHERE CD_UF = %Exp:nCodUf%
		AND UPPER(DBA_EGK.F_TIRA_ACENTO(DS_CIDADE_NOME)) = UPPER(DBA_EGK.F_TIRA_ACENTO(%Exp:cMunicio%))
	EndSql

	TMP_UF->(DbgoTop())

	IF TMP_UF->(EOF())

		TMP_UF->(DbCloseArea())

		cInsert := "INSERT INTO CEP_CIDADES (CD_UF, CD_CIDADE, DS_CIDADE_NOME) VALUES("+cValToChar(nCodUf)+",(SELECT MAX(CD_CIDADE)+1 FROM CEP_CIDADES),'"+cMunicio+"') "

		BEGIN TRANSACTION 
			TCSqlExec(cQueryINS)
		END TRANSACTION	

		IF Select("TMP_UF") > 0
			TMP_UF->(DbCloseArea())
		ENDIF

		BeginSql Alias "TMP_UF"
			SELECT CD_CIDADE FROM CEP_CIDADES
			WHERE CD_UF = %Exp:nCodUf%
			AND UPPER(DBA_EGK.F_TIRA_ACENTO(DS_CIDADE_NOME)) = UPPER(DBA_EGK.F_TIRA_ACENTO(%Exp:cMunicio%))
		EndSql

		nCodCid := TMP_UF->CD_CIDADE

		TMP_UF->(DbCloseArea())

	ELSE

		nCodCid := TMP_UF->CD_CIDADE	

	ENDIF

	IF Select("TMP_UF") > 0
		TMP_UF->(DbCloseArea())
	ENDIF

	BeginSql Alias "TMP_UF"
		SELECT CD_BAIRRO FROM CEP_BAIRROS
		WHERE CD_CIDADE = %Exp:nCodCid%
		AND UPPER(DBA_EGK.F_TIRA_ACENTO(DS_BAIRRO_NOME)) = UPPER(DBA_EGK.F_TIRA_ACENTO(%Exp:cBairro%))
	EndSql

	TMP_UF->(DbGoTop())
	IF TMP_UF->(!EOF())
		cCodBai := TMP_UF->CD_BAIRRO
	ELSE
		cInsert := "INSERT INTO CEP_BAIRROS (CD_BAIRRO, CD_CIDADE, DS_BAIRRO_NOME) VALUES((SELECT MAX(CD_BAIRRO)+1 FROM CEP_BAIRROS),"+cValToChar(nCodCid)+",UPPER(DBA_EGK.F_TIRA_ACENTO('"+cBairro+"'))) "

		BEGIN TRANSACTION 
			TCSqlExec(cQueryINS)
		END TRANSACTION			

		TMP_UF->(DbCloseArea())
		BeginSql Alias "TMP_UF"
			SELECT CD_BAIRRO FROM CEP_BAIRROS
			WHERE CD_CIDADE = %Exp:nCodCid%
			AND UPPER(DBA_EGK.F_TIRA_ACENTO(DS_BAIRRO_NOME)) = UPPER(DBA_EGK.F_TIRA_ACENTO(%Exp:cBairro%))
		EndSql
		TMP_UF->(DbgoTop())		

		cCodBai := TMP_UF->CD_BAIRRO
	ENDIF

	cInsert := "INSERT INTO CEP_BAIRROS (CD_LOGRADOURO, CD_BAIRRO, CD_TIPO_LOGRADOUROS, DS_LOGRADOURO_NOME, NO_LOGRADOURO_CEP) VALUES ("
	cInsert += " (SELECT MAX(CD_LOGRADOURO)+1 FROM CEP_BAIRROS) , "+cValToChar(cCodBai)+", 1, UPPER(DBA_EGK.F_TIRA_ACENTO('"+cLogra+"')), "+cCep+")"

	BEGIN TRANSACTION 
		TCSqlExec(cQueryINS)
	END TRANSACTION		

ENDIF

IF Select("TMP_UF") > 0
	TMP_UF->(DbCloseArea())
ENDIF

Return nil

