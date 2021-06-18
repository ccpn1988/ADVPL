#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#DEFINE cEnt CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI001   ºAutor  ³Florence França     º Data ³  14/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para importacao de Clientes e Transportadoras.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³Autor  ³Joni Fujiyama                  º Data ³  30/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina foi adaptada para rodar por schedule.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENI001()

Private lUpd := .F.
Private cFunName := PROCNAME()

If MsgYesNo("Esta rotina fará a importação de Clientes. Deseja continuar?","Atenção")
	Processa({||Importa()})
EndIf

Return()


//*************************************************************************************************//
// Rotina da execução por schedule				Autor: Joni Fujiyama			Data:02/07/2014			 //
//*************************************************************************************************//
User Function GENI001A()

Local lRotMens:=.F.
Private cFunName := PROCNAME()
Private lUpd := .F.

Prepare Environment Empresa "00" Filial "1001"
RotMens("Executando a rotina ==> " + cFunName,"","")
Importa()
lRotMens := RotMens("Fim do Schedule ==> " + cFunName,"","")
Reset Environment

Return()

//*************************************************************************************
// Mostra a mensagem na tela ou no console			Autor: Joni Fujiyama		Data:02/07/2014
//***************************************************************************************/
Static Function RotMens(pTexto1,pTexto2,pTipo)

IF cFunName == "U_GENI001"
	DO CASE
		Case pTipo = "1"
			MSGBOX(pTexto1,pTexto2)
		Case pTipo = "2"
			MsgInfo(pTexto1,pTexto2)
	ENDCASE
ELSE
	IF cFunName == "U_GENI001A"
		Conout("[" + DtoC(dDataBase) + Space(1) + Time() + "] " + cFunName + Space(1) + pTexto1)
	ENDIF
ENDIF

Return .T.

Static Function Importa()

Local 	cQuerySA1
Local 	cArqSA1		:= GetNextAlias()
Local 	cQuery
Local 	cArqTmp 	:= GetNextAlias()
Local 	nContLin 	:= 0
Local 	_cCod
Local   cCGCdmin
Local 	nContx 		:= 0
Local   nAtual		:= 0
Local	lFlag 		:= .F.
Local   lAchou		:= .F.
Local   cTipCli
Local   cCanalV
Private _nLoja
Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.
Private aLog 		:= {}
Private cCodigo 	:= "0000002"
Private cFile		:= ""
Private cPath 		:= "\logsiga\cliente\"
Private lUpd := .F.

_aDir := directory(Alltrim(cPath)+"*")
For i:=1 to len(_aDir)
	fErase(Alltrim(cPath)+_aDir[i][1])
Next i

nReg := 0


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºEXECUTA ROTINAS AUXILIARES - PRE-REQUISITOS PARA CADASTRO              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
CadTransp() //ATUALIZA CADASTRO DE TRANSPORTADORAS - TABELA SA4
lRet := CadTipo() //ATUALIZA CADASTRO DE TIPO DE CLIENTE - TABELA SX5 (TP)
//U_GENDESC(.F.) //ATUALIZA TABELA DE DESCONTO - TABELA SZ2
If !lRet
	Return()
EndIf
lAmbPrd := upper(alltrim(GetEnvServer())) $ "PRODUCAO-DANILO-SCHEDULE" //ambientes de "producao"

If lAmbPrd
	cArqT := "TT_I01_CLIENTE"
Else
	cArqT := "TT_T01_CLIENTE"
Endif
//cArqT := "TT_T01_CLIENTE"

cQuerySA1 := "SELECT * FROM "+cArqT+" T
cQuerySA1 += " ORDER BY T.A1_COD

If Select(cArqSA1) > 0
	dbSelectArea(cArqSA1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuerySA1), cArqSA1, .F., .T.)
(cArqSA1)->(dbGoTop())

cErr := Space(0)
aRepete := {}

nRegs := 0

Do While !(cArqSA1)->(EOF())
	
	nRegs++
	
	nOpt := 3
	cCGC := Iif(val((cArqSA1)->A1_PAIS) = 105,(cArqSA1)->A1_CGC,Space(1))
	
	//Armazena Codigo GEN
	cCodOld := cValtochar((cArqSA1)->A1_COD)
	cLoja 	:= "01"
	
	//VERIFICA SE REGISTRO JA EXISTE NA TABELA ATRAVES DO CGC OU XCODOLD (CASO O CGC ESTIVER EM BRANCO)
	DbSelectArea("SA1")
	If !Empty(cCgc)
		DbSetOrder(3) //FILIAL + CGC
	Else
		DbOrderNickName("A1_XCODOLD") //FILIAL + XCODOLD
	Endif
	If !Empty(cCgc) .and. DbSeek(xFilial("SA1") + cCgc)
		If !lUpd
			If alltrim(SA1->A1_XCODOLD) <> cCodOld
				RecLock("SA1",.F.)
				SA1->A1_XCODOLD := cCodOld
				MsUnlock()
			Endif
			cErr := "CGC***"+cCgc+"***"+cCodOld
			aAdd(aRepete,cErr)
			
			If lAmbPrd
				cQueryINS := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) VALUES ('"+cArqT+"','A1_XCODOLD','"+cCodOld+"','    ' ) " //INSERE O REGISTRO JA EXISTENTE NA FLAGVIEW
				TCSqlExec(cQueryINS)
			Endif
			
			(cArqSA1)->(DbSkip())
			Loop
		Endif
		nOpt := 4 //encontrou, atualiza
		cLoja := SA1->A1_LOJA
	ElseIf Empty(cCgc) .and. DbSeek(xFilial("SA1") + cCodOld)
		If !lUpd
			cErr := "COD***"+cCodOld+"***"+cCodOld
			aAdd(aRepete,cErr)
			
			If lAmbPrd
				cQueryINS := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) VALUES ('"+cArqT+"','A1_XCODOLD','"+cCodOld+"','    ' ) " //INSERE O REGISTRO JA EXISTENTE NA FLAGVIEW
				TCSqlExec(cQueryINS)
			Endif
			
			(cArqSA1)->(DbSkip())
			Loop
		Endif
		nOpt := 4 //encontrou, atualiza
		cLoja := SA1->A1_LOJA
	EndIf
	
	//VALIDA AS REGRAS DE CANAL DE VENDA, VENDEDOR E TIPO DE CLIENTE
	cTipCli := strzero((cArqSA1)->A1_XTIPCLI, 3)
	cCanalV := alltrim((cArqSA1)->A1_XCANALV)
	cVend := strzero((cArqSA1)->A1_VEND,tamsx3("A1_VEND")[1])
	lRet := .T.
	cMsg := Space(0)
	If !((cCanalV="2" .and. cVend$"000006-000008").or.(cCanalV<>"2" .and. !(cVend$"000006-000008")))
		lRet := .F.
		cMsg += "O vendedor informado "+alltrim(Posicione("SA3",1,xFilial("SA3")+cVend,"A3_NOME"))+" é incompatível com o canal de venda "+alltrim(Posicione("SX5",1,xFilial("SX5")+"Z2"+cCanalV,"X5_DESCRI"))+". Verifique e tente novamente."
		cFile := "Cliente - CodGen "+alltrim(cCodOld)+".log"
		MemoWrite(cpath+cFile,cMsg)
		aAdd(aLog, {cPath+cFile, "Verifique o LOG gerado"})
		(cArqSA1)->(DbSkip())
		Loop
	Endif
	If !((cCanalV="1" .and. cTipCli$"001-018-021-002") .or. (cCanalV="2" .and. cTipCli$"024-025-028-022-031-032-014-004-023-017-011-003") .or. (cCanalV="3" .and. cTipCli$"009-029-005-020-006-013") .or. (cCanalV="4" .and. cTipCli$"007-099-030-010"))
		lRet := .F.
		cMsg += "O tipo de cliente informado "+alltrim(Posicione("SX5",1,xFilial("SX5")+"TP"+cTipCli,"X5_DESCRI"))+" é incompatível com o canal de venda "+alltrim(Posicione("SX5",1,xFilial("SX5")+"Z2"+cCanalV,"X5_DESCRI"))+". Verifique e tente novamente."
		cFile := "Cliente - CodGen "+alltrim(cCodOld)+".log"
		MemoWrite(cpath+cFile,cMsg)
		aAdd(aLog, {cPath+cFile, "Verifique o LOG gerado"})
		(cArqSA1)->(DbSkip())
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³	VERIFICA SE JA EXISTE O CLIENTE COM MESMA RAIZ DE CNPJ CADASTRADO  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//VALIDA SE O CNPJ NAO ESTA PREENCHIDO COM '0' (ZERO)
	If !lUpd .and. substr(cCGC,1,8) <> '00000000' .AND. !Empty(cCGC)
		cQuery := "SELECT A1_COD, MAX(A1_LOJA) NLOJA FROM "+ RetSqlName("SA1")
		cQuery += " WHERE SUBSTR(A1_CGC,1,8) = SUBSTR('"+cCGC+"',1,8)
		cQuery += " GROUP BY A1_COD
		
		If Select(cArqTmp) > 0
			dbSelectArea(cArqTmp)
			dbCloseArea()
		EndIf
		
		DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cArqTmp, .F., .T.)
		dbSelectArea(cArqTmp)
		
		//SE HOUVER CLIENTE CADASTRADO ELE ADICIONA LOJA
		If !(cArqTmp)->(EOF())
			DbSelectArea("SA1")
			DbSetOrder(3)
			If !DbSeek(xFilial("SA1") + cCGC )
				_cCod	:= (cArqTmp)->A1_COD
				_nLoja 	:= VAL((cArqTmp)->NLOJA) + 1
				cLoja	:= PADL(_nLoja,2,"0")
			Else
				_cCod   := SA1->A1_COD
				cLoja	:= SA1->A1_LOJA
			EndIf
		EndIf
	Else
		DbSelectArea ("SA1")
		DbOrderNickName("A1_XCODOLD")
		If DbSeek(xFilial("SA1") + cCodOld )
			_cCod 	:= SA1->A1_COD
			cLoja 	:= SA1->A1_LOJA
		EndIf
	EndIf
	
	If val((cArqSA1)->A1_PAIS) = 105
		cEst := alltrim((cArqSA1)->A1_EST)
		cCodMun := Substr(cValToChar((cArqSA1)->A1_COD_MUN),3,5)
		cCEP	:= Alltrim((cArqSA1)->A1_CEP)
		cMunic	:= (cArqSA1)->A1_MUN
		cInsc := upper(Alltrim((cArqSA1)->A1_INSCR))
	Else
		cEst := "EX"
		cCodMun	:= '99999'
		cCEP	:= '00000000'
		cMunic	:= 'EXTERIOR'
		cInsc := "ISENTO"
	Endif
	
	aMATA030 := {}
	
	aAdd(aMATA030,{"A1_FILIAL",(xFilial("SA1")),Nil})
	If cLoja <= "01" .and. nOpt = 3 //se for inclusao
		_cCod := VerCod()
	Endif
	aAdd(aMATA030,{"A1_COD",_cCod,Nil})
	aAdd(aMATA030,{"A1_LOJA",cLoja,Nil})
	aAdd(aMATA030,{"A1_XCODOLD",cValtochar((cArqSA1)->A1_COD),Nil})
	aAdd(aMATA030,{"A1_NOME",upper((cArqSA1)->A1_NOME),Nil})
	aAdd(aMATA030,{"A1_NREDUZ",upper((cArqSA1)->A1_NREDUZ),Nil})
	aAdd(aMATA030,{"A1_PESSOA",(cArqSA1)->A1_PESSOA,Nil})
	aAdd(aMATA030,{"A1_END",upper(alltrim((cArqSA1)->A1_END)),Nil})
	cEndNum := alltrim((cArqSA1)->A1_XENDNUM)
	If Empty(cEndNum)
		cEndNum := "-"
	Endif
	aAdd(aMATA030,{"A1_XENDNUM",cEndNum,Nil}) //NUMERO ENDERECO
	//aAdd(aMATA030,{"A1_ENDCOB",NoAcento((cArqSA1)->A1_ENDCOB),Nil})
	//aAdd(aMATA030,{"A1_ENDENT",NoAcento((cArqSA1)->A1_ENDENT),Nil})
	aAdd(aMATA030,{"A1_TIPO",(cArqSA1)->A1_TIPO,Nil})
	aAdd(aMATA030,{"A1_EST",cEst,Nil})
	aAdd(aMATA030,{"A1_ESTADO",(cArqSA1)->A1_ESTADO,Nil})
	aAdd(aMATA030,{"A1_COD_MUN",cCodMun,Nil})
	aAdd(aMATA030,{"A1_MUN",cMunic,Nil})
	aAdd(aMATA030,{"A1_BAIRRO",(cArqSA1)->A1_BAIRRO,Nil})
	aAdd(aMATA030,{"A1_CEP",cCEP,Nil})
	aAdd(aMATA030,{"A1_DDI",(cArqSA1)->A1_DDI,Nil})
	
	If !Empty((cArqSA1)->A1_TEL) .and. Empty((cArqSA1)->A1_DDD)
		cTel := alltrim((cArqSA1)->A1_TEL)
		cTel := strtran(cTel," ","")
		cTel := strtran(cTel,")","")
		cTel := strtran(cTel,"(","")
		cTel := strtran(cTel,"-","")
		cDdd := Space(0)
		
		If substr(cTel,1,1)="0" .and. substr(cTel,1,4)<>"0800"
			cTel := substr(cTel,2,len(cTel))
		Endif
		
		If len(cTel)=10 .or. len(cTel)=11 .and. substr(cTel,1,4)<>"0800"
			cDdd := substr(cTel,1,2)
			cTel := substr(cTel,3,len(cTel))
		Endif
		
		aAdd(aMATA030,{"A1_DDD",cDDD,Nil})
		aAdd(aMATA030,{"A1_TEL",cTel,Nil})
	Endif
	If !Empty((cArqSA1)->A1_FAX)
		cFax := alltrim((cArqSA1)->A1_FAX)
		cFax := strtran(cTel," ","")
		cFax := strtran(cTel,")","")
		cFax := strtran(cTel,"(","")
		cFax := strtran(cTel,"-","")
		
		If substr(cTel,1,1)="0" .and. substr(cTel,1,4)<>"0800"
			cFax := substr(cTel,2,len(cTel))
		Endif
		
		If len(cTel)=10 .or. len(cTel)=11 .and. substr(cTel,1,4)<>"0800"
			cFax := substr(cTel,3,len(cTel))
		Endif
		
		aAdd(aMATA030,{"A1_FAX",cFax,Nil})
	Endif
	aAdd(aMATA030,{"A1_PAIS",(cArqSA1)->A1_PAIS,Nil})
	aAdd(aMATA030,{"A1_PAISDES",(cArqSA1)->A1_PAISDES,Nil})
	aAdd(aMATA030,{"A1_CONTATO",(cArqSA1)->A1_CONTATO,Nil})
	aAdd(aMATA030,{"A1_CGC",cCgc,Nil})
	aAdd(aMATA030,{"A1_EMAIL",lower((cArqSA1)->A1_EMAIL),Nil})
	aAdd(aMATA030,{"A1_CODPAIS",strzero((cArqSA1)->A1_CODPAIS, 5),Nil})
	aAdd(aMATA030,{"A1_COMPLEMEN",(cArqSA1)->A1_COMPLEMEN,Nil})
	aAdd(aMATA030,{"A1_TPESSOA",(cArqSA1)->A1_TPESSOA,Nil})
	aAdd(aMATA030,{"A1_CONTA",(cArqSA1)->A1_CONTA,Nil})
	aAdd(aMATA030,{"A1_RECPIS","N",Nil})
	aAdd(aMATA030,{"A1_RECCSLL","N",Nil})
	aAdd(aMATA030,{"A1_RECCOFI","N",Nil})
	aAdd(aMATA030,{"A1_RECISS","2",Nil})
	aAdd(aMATA030,{"A1_INSCR",cInsc,Nil})
	aAdd(aMATA030,{"A1_XTIPCLI",cTipCli,Nil}) //TIPO DE CLIENTE VALORES CONTIDOS NA TABELA GENÉRICA "TIPO DE CLIENTE" NA SX5
	aAdd(aMATA030,{"A1_XCANALV",cCanalV,Nil}) //CANAL DE VENDA VALORES CONTIDOS NA TABELA GENÉRICA "CANAL DE VENDA" NA SX5
	aAdd(aMATA030,{"A1_VEND",cVend,Nil}) //VENDEDOR VALORES CONTIDOS NA TABELA DE VENDEDORE SA3
	aAdd(aMATA030,{"A1_XTPDES",cValToChar((cArqSA1)->A1_XTPDES),Nil}) //TIPO DE DESCONTO VALORES CONTIDOS NA TABELA DE DESCONTOS SZ2
	aAdd(aMATA030,{"A1_XCLIPRE",cValToChar((cArqSA1)->A1_XCLIPRE),Nil}) //CLIENTE PREMIUM 0-NÃO 1-SIM
	aAdd(aMATA030,{"A1_RISCO",Iif(cValToChar((cArqSA1)->A1_XCLIPRE)="1","A","B"),Nil}) //RISCO - PARA EFEITO DE BLOQUEIO DE PEDIDO POR LIMITE DE CREDITO
	aAdd(aMATA030,{"A1_INSCRM",(cArqSA1)->A1_INSCRM,Nil})
	aAdd(aMATA030,{"A1_TRANSP",strzero((cArqSA1)->A1_TRANSP,tamsx3("A1_TRANSP")[1]),Nil})
	aAdd(aMATA030,{"A1_TABELA","150",Nil})
	aAdd(aMATA030,{"A1_SUFRAMA",alltrim((cArqSA1)->SUFRAMA),Nil})
	aAdd(aMATA030,{"A1_TPFRET",Iif((cArqSA1)->FRETE=1,"C","F"),Nil})
	
	If SA1->(FieldPos("A1_XEMAILF")) > 0 .and. alltrim((cArqSA1)->A1_XMAILF) <> alltrim((cArqSA1)->A1_EMAIL)
		aAdd(aMATA030,{"A1_XEMAILF",lower((cArqSA1)->A1_XMAILF),Nil}) //EMAIL FINANCEIRO (COBRANCA)
	Endif
	If SA1->(FieldPos("A1_XEMAILC")) > 0 .and. alltrim((cArqSA1)->A1_XMAILC) <> alltrim((cArqSA1)->A1_EMAIL)
		aAdd(aMATA030,{"A1_XEMAILC",lower((cArqSA1)->A1_XMAILC),Nil}) //EMAIL DE CONTATO
	Endif
	cXCond := strzero((cArqSA1)->A1_XCONDPG,tamsx3("A1_XCONDPG")[1])
	If val(cXCond) = 0
		cXCond := strzero(91,tamsx3("A1_XCONDPG")[1])
	Endif
	aAdd(aMATA030,{"A1_XCONDPG",cXCond,Nil})
	
	cCond := strzero(val((cArqSA1)->A1_COND),tamsx3("A1_COND")[1])
	If cCond = "000" //NAO CADASTRADA
		cCond := "001" //A VISTA
	Endif
	aAdd(aMATA030,{"A1_COND",cCond,Nil})
	aAdd(aMATA030,{"A1_XBCOD",cValToChar((cArqSA1)->A1_XBCOD),Nil})
	
	//TRATA O GRUPO DE CLIENTE
	If (cArqSA1)->A1_GRPVEN > 0
		cGrupo := strzero((cArqSA1)->A1_GRPVEN,tamsx3("A1_GRPVEN")[1])
		dbSelectArea("ACY")
		dbSetOrder(1)
		If !dbSeek(xFilial("ACY")+cGrupo)
			RecLock("ACY",.T.)
			ACY->ACY_FILIAL := xFilial("ACY")
			ACY->ACY_GRPVEN := cGrupo
			ACY->ACY_DESCRI := alltrim(upper((cArqSA1)->GRPDESC))
			MsUnlock()
		Endif
		aAdd(aMATA030,{"A1_GRPVEN",strzero((cArqSA1)->A1_GRPVEN,tamsx3("A1_GRPVEN")[1]),Nil})
	Endif
	
	lMsErroAuto := .F.
	lVar := MSExecAuto({|x,y| MatA030(x,y)},aMATA030,nOpt) //Inclusao - 3; Alteracao - 4; Exclusao - 5
	
	If !lMsErroAuto
		DbSelectArea("SA1")
		RecLock("SA1", .F.)
		SA1->A1_MSBLQL := IIF((cArqSA1)->A1_MSBLQL='A','2','1')
		SA1->A1_XREV := "4"
		If cValToChar((cArqSA1)->A1_XBCOD) = "341"
			SA1->A1_BLEMAIL := "1"
		Endif
		MsUnLock()
		
		If IE(cInsc,cEst,.F.)
			DbSelectArea("SA1")
			RecLock("SA1", .F.)
			SA1->A1_INSCR := cInsc
			MsUnLock()
		Else
			cFile := "Cliente - CodGen "+alltrim(cCodOld)+" Inscr.log"
			MemoWrite(cpath+cfile, "Codigo Cliente "+_cCod+" / Codigo GEN "+cCodOld+" / Estado "+cEst+" / Inscrição Estadual -> ("+cInsc+") Incorreta!")
			aAdd(aLog, {cPath+cFile, "Verifique o LOG gerado"})
			DisarmTransaction()
		EndIf
	Else
		cFile := "Cliente - CodGen "+alltrim(cCodOld)+".log"
		MostraErro(cPath,cFile)
		aAdd(aLog, {cPath+cFile, "Verifique o LOG gerado"})
		DisarmTransaction()
		ROLLBACKSX8()
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄë¿
	//³GRAVA NA VIEW 'TT_I11_FLAG_VIEW' O REGISTRO IMPORTADO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄëÙ
	If lAmbPrd .and. !lMsErroAuto .and. ExistChav("SA1",_cCod+cLoja,1,0) .and. nOpt = 3 //inclusao em ambiente de producao
		cQueryINS := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) VALUES ('"+cArqT+"','A1_XCODOLD','"+cValtochar((cArqSA1)->A1_COD)+"','    ' ) "
		TCSqlExec(cQueryINS)
	EndIf
	lMsErroAuto := .F.
	
	(cArqSA1)->(DbSkip())
EndDo

If Len(aRepete)>0
	cMsg := Space(0)
	For i := 1 to len(aRepete)
		cMsg += aRepete[i]+cEnt
	Next i
	MemoWrite(cpath+"rep"+dtos(dDatabase)+StrTran(Time(),":")+".log",cMsg)
Endif

If Len(aLog) > 0
	RotMens("Ocorreram erros na importação!","Atenção","1")
Else
	RotMens("Importação Finalizada com Sucesso!","Aviso","2")
EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI001   ºAutor  ³Microsiga           º Data ³  04/09/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ BUSCA ACENTUAÇÃO E ALTERA                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION NoAcento(cString)

Local cChar  := ""
Local nX     := 0
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
Local cTio   := "ãõ"
Local cCecid := "çÇ"

cString := AllTrim(cString)

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next

cString := UPPER(cString)

Return(cString)


Static Function VerCod()

cMax := GetSx8Num("SA1")
RollbackSx8()
//cCodigo := cMax

dbSelectArea("SA1")
dbSetOrder(1)
lFind := .T.
Do While lFind .and. cCodigo < cMax //enquanto achar registro com o codigo pesquisado e o codigo for menor que o getsx8num
	If !dbSeek(xFilial("SA1")+cCodigo) //testa a chave
		lFind := .F. //se achar, desabilita pesquisa
	Else
		cCodigo := Soma1(cCodigo) //soma o codigo
	Endif
Enddo
If cCodigo >= cMax
	cCodigo := GetSx8Num("SA1")
Endif

Return(cCodigo)


Static Function CadTransp()

cQry := "SELECT T.*, U.DESCRICAO EST, M.DESCRICAO MUN
cQry += " FROM DBA_EGK.TRANSPORTADORA T INNER JOIN DBA_EGK.MUNICIPIO M ON T.IDMUNICIPIO = M.IDMUNICIPIO
cQry += " INNER JOIN DBA_EGK.UF U ON T.IDUF = U.IDUF
cQry += " WHERE T.IDTRANSPORTADORA IN (SELECT IDTRANSPORTADORA
cQry += " FROM PEDIDO
cQry += " WHERE to_char(DATA,'YYYYMMDD') >= '20140101')
cQry += " ORDER BY IDTRANSPORTADORA
cAlias := Criatrab(Nil,.F.)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)

dbSelectArea("SA4")
dbSetOrder(1)
Do While !(cAlias)->(EOF())
	
	If !dbSeek(xFilial("SA4")+STRZERO((cAlias)->IDTRANSPORTADORA,6))
		//RecLock("SA4",.F.)
		//Else
		RecLock("SA4",.T.)
		SA4->A4_FILIAL := xFilial("SA4")
		SA4->A4_COD := STRZERO((cAlias)->IDTRANSPORTADORA,6)
		SA4->A4_NOME := (cAlias)->DESCRICAO
		//Endif
		
		SA4->A4_END := (cAlias)->ENDERECO
		SA4->A4_BAIRRO := (cAlias)->BAIRRO
		SA4->A4_CEP := (cAlias)->CEP
		SA4->A4_MUN := (cAlias)->MUN
		SA4->A4_EST := (cAlias)->EST
		SA4->A4_VIA := (cAlias)->VIATRANSPORTADA
		//SA4->A4_DDD := (cAlias)->SITUACAO
		SA4->A4_TEL := (cAlias)->TEL
		SA4->A4_CGC := (cAlias)->CGC
		SA4->A4_INSEST := (cAlias)->IE
		SA4->A4_EMAIL := (cAlias)->EMAIL
		SA4->A4_XFORNEC := Posicione("SA2",3,xFilial("SA2")+(cAlias)->CGC,"A2_COD")
		SA4->A4_XLJFOR := Posicione("SA2",3,xFilial("SA2")+(cAlias)->CGC,"A2_LOJA")
		
		MsUnlock()
	Endif
	
	(cAlias)->(dbskip())
Enddo

fErase(cAlias)

Return()


Static Function CadTipo()

Local lRet	:= .T.

cQry := "SELECT * FROM TIPOCLIENTE WHERE IDTIPOCLIENTE > 0 AND ATIVO = 1 ORDER BY IDTIPOCLIENTE"
cAlias := Criatrab(Nil,.F.)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)

dbSelectArea("SX5")
dbSetOrder(1)
Do While !(cAlias)->(eof())
	If !dbSeek(xFilial("SX5")+"TP"+strzero((cAlias)->IDTIPOCLIENTE,3))
		//RecLock("SX5",.F.)
		//Else
		/*
		RecLock("SX5",.T.)
		SX5->X5_FILIAL := xFilial("SX5")
		SX5->X5_TABELA := "TP"
		SX5->X5_CHAVE := strzero((cAlias)->IDTIPOCLIENTE,3)
		//Endif
		SX5->X5_DESCRI := (cAlias)->DESCRICAO
		SX5->X5_DESCSPA := (cAlias)->DESCRICAO
		SX5->X5_DESCENG := (cAlias)->DESCRICAO
		MsUnlock()
		*/
		cMsg := " Tipo do cliente não cadastrado "+strzero((cAlias)->IDTIPOCLIENTE,3)
		cFile := "Cliente - CodGen "+alltrim(strzero((cAlias)->IDTIPOCLIENTE,3))+".log"
		MemoWrite(cpath+cFile,cMsg)
		aAdd(aLog, {cPath+cFile, "Verifique o LOG gerado"})
    	lRet := .F.
	Endif
	(cAlias)->(dbskip())
Enddo

fErase(cAlias)

MostraErro(cPath,cFile)

Return(lRet)