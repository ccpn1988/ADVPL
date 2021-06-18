#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA087   ºAutor  ³ Cleuto P. Lima     º Data ³  15/03/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para controle de impressão e envio de boleto email   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA087()

Local cPerg		:= "GENA087"
Local cWhere		:= "% 1 = 1 %"
Local nTotReg		:= 0
Local aLogs		:= {}
Local aEnviados	:= {}
Local cMsg			:= ""
Local cMailTeste	:= ""
/*
U_xGPutSx1(cPerg, "01", "Borderô"					, ".", ".", "mv_ch1" , "C",	TamSX3("E1_NUMBOR")[1]	, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg, "02", "Considera já enviado?"	, ".", ".", "mv_ch2" , "C",	01							, 0, 1, "C","", "", "", "", "MV_PAR02","Sim","Sim","Sim","","Não","Não","Não","","","","","","","","","")
U_xGPutSx1(cPerg, "03", "E-mail Teste?"			, ".", ".", "mv_ch3" , "C",	99							, 0, 0, "G","", "", "", "", "MV_PAR03","","","","","","","","","","","","","","","","")
*/
If !Pergunte(cPerg,.T.)
	Return nil
EndIf

cMailTeste	:= AllTrim(MV_PAR03)

If MV_PAR02 == 2
	cWhere	:= "% E1_XDTMAIL = '        ' %"
EndIf

If Select("TMP_BOL") > 0
	TMP_BOL->(DbCloseArea())
EndIf

BeginSql Alias "TMP_BOL"	
	SELECT SE1.R_E_C_N_O_ RECSE1, SA1.R_E_C_N_O_ RECSA1,E1_FILIAL,E1_NUM,E1_PREFIXO,E1_PARCELA,A1_COD,A1_LOJA
	FROM %Table:SE1% SE1
	JOIN %Table:SA1% SA1
	ON A1_FILIAL = %xFilial:SA1%
	AND A1_COD = E1_CLIENTE
	AND A1_LOJA = E1_LOJA
	AND SA1.%NotDel%
	WHERE E1_SALDO > 0
	AND SE1.%NotDel%
	AND E1_NUMBOR = %Exp:MV_PAR01%
	AND %Exp:cWhere%
	AND E1_TIPO = 'NF'
	AND TRIM(E1_NUMBCO) IS NOT NULL
	ORDER BY E1_FILIAL,E1_NUMBCO,E1_CLIENTE,E1_NUM
EndSql

TMP_BOL->(DbGoTop())
nTotReg := Contar("TMP_BOL", "!EOF()")
TMP_BOL->(DbGoTop())

 If nTotReg == 0
	TMP_BOL->(DbCloseArea())
	MsgStop("Nenhum registro encontrado com os parametros informados!")
	Return nil
EndIf

Processa({|| GENA087A(nTotReg,@aLogs,@aEnviados,cMailTeste) },"Processando envio dos boletos...")

TMP_BOL->(DbCloseArea())

If Len(aLogs) > 0
	cMsg := ""
	aEval(aLogs, {|x| cMsg+=x+Chr(13)+Chr(10) } )
	
	If !MostraLog(cMsg)
		Return .F.
	EndIf	
EndIf

If Len(aEnviados) > 0
	ExportGrid(aEnviados,.T.) 
EndIf

Return nil 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA087   ºAutor  ³ Cleuto P. Lima     º Data ³  15/03/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera boleto                                  				 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GENA087A(nTotReg,aLogs,aEnviados,cMailTeste)

Local nCnt			:= 0
Local cFilePrint	:= ""
Local aFileCli	:= {}
Local nPosBol		:= 0
Local nAuxFl		:= 0
Local lContinua	:= .T.
Local cFileAux	:= ""
Local cFilOld		:= cFilAnt
Local cDirPDF		:= GetMv("GEN_FIN009",.f.,"\workflow\Anexos\Boleto\")//+cFilAnt+"\"

WFForceDir(cDirPDF)

ProcRegua(nTotReg)

TMP_BOL->(DbGoTop())

While TMP_BOL->(!EOF())
	nCnt++
	
	SE1->(DbGoto( TMP_BOL->RECSE1 ))
	
	IncProc(SE1->E1_FILIAL+": Gerando boleto "+StrZero(nCnt,4)+" de "+StrZero(nTotReg,4)+" ...")
	
	If SE1->E1_FILIAL <> cFilAnt
		SM0->(dbSetOrder(1))
		SM0->(dbSeek("00" + SE1->E1_FILIAL,.T.)) //Posiciona Empresa
				
		cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
		cFilAnt := SM0->M0_CODFIL
		OpenFile(cEmpAnt + cFilAnt)		
	EndIf
	
	U_GENA085(TMP_BOL->RECSE1,TMP_BOL->E1_FILIAL,TMP_BOL->E1_NUM,TMP_BOL->E1_PREFIXO,TMP_BOL->E1_PARCELA,@aLogs,.F.,.T.,TMP_BOL->RECSA1,TMP_BOL->A1_COD,TMP_BOL->A1_LOJA,@cFilePrint)
	
	nPosBol := aScan(aFileCli, {|x| x[1] == TMP_BOL->RECSA1 .AND. x[5] == TMP_BOL->E1_NUM }  )
	If nPosBol == 0
		Aadd(aFileCli, { TMP_BOL->RECSA1,TMP_BOL->A1_COD,TMP_BOL->A1_LOJA, {  } , TMP_BOL->E1_NUM} )
		nPosBol := Len(aFileCli)
	EndIf

	Aadd(aFileCli[nPosBol][4], { TMP_BOL->RECSE1,TMP_BOL->E1_FILIAL,TMP_BOL->E1_NUM,TMP_BOL->E1_PREFIXO,TMP_BOL->E1_PARCELA,cDirPDF+cFilAnt+"\",cFilePrint , File(cDirPDF+cFilAnt+"\"+cFilePrint) } )

	TMP_BOL->(DbSkip())

EndDo

If cFilOld <> cFilAnt
	SM0->(dbSetOrder(1))
	SM0->(dbSeek("00"+cFilOld,.T.)) //Posiciona Empresa
			
	cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
	cFilAnt := SM0->M0_CODFIL
	OpenFile(cEmpAnt + cFilAnt)
EndIf

ProcRegua(nTotReg)

If Len(aFileCli) > 0
	
	For nCnt := 1 To Len(aFileCli)
		lContinua	:= .T.
		
		/* verifica se todos os PDFs do cliente estão OK */
		For nAuxFl := 1 to Len(aFileCli[nCnt][4])
			cFileAux	:= aFileCli[nCnt][4][nAuxFl][6]+aFileCli[nCnt][4][nAuxFl][7]
			aFiles 	:= Directory(cFileAux)
			If !(File(cFileAux)  .AND. Len(aFiles) > 0 .AND. aFiles[1][2] > 0)
				Aadd(aLogs, "GENA087E: arquivo PDF do boleto não localizado "+cFileAux+", Recno SE1: "+cValToChar(aFileCli[nCnt][4][nAuxFl][1])+", Filial Tit.:"+aFileCli[nCnt][4][nAuxFl][2]+", Num.Tit.:,"+aFileCli[nCnt][4][nAuxFl][3]+;
				",Pref.Tit.:"+aFileCli[nCnt][4][nAuxFl][4]+",Parc.Tit.:"+aFileCli[nCnt][4][nAuxFl][5] )
				lContinua	:= .F.
				aFileCli[nCnt][4][nAuxFl][8]	:= .F.
			Else
				aFileCli[nCnt][4][nAuxFl][8]	:= .T.	
			EndIF				
		Next nAuxFl	
	
		IncProc("Enviando e-mail "+StrZero(nCnt,4)+" de "+StrZero(nTotReg,4)+" ...")
		If lContinua
			GENA087E(aFileCli[nCnt,1],aFileCli[nCnt,2],aFileCli[nCnt,3],aFileCli[nCnt,4],@aLogs,@aEnviados,cMailTeste,aFileCli[nCnt,5])
		EndIf	
	Next nCnt
	
EndIf
	
	
Return nil

Static Function GENA087E(nRecSA1,cCodCli,cLojaCli,aFilePrint,aLogs,aEnviados,cMailTeste,cNumDanfe)

Local cFile		:= ""
Local cMailAudit	:= GetMv("GEN_FIN010",.f.,"desenvolvimentogen@gmail.com")
Local cMailHomol	:= GetMv("GEN_FIN011",.f.,"cleuto.lima@grupogen.com.br")
Local nAuxCont	:= 0
Local aLog			:= {}
Local cMailBol	:= ""
Local cAnexos		:= ""
Local cAssunto	:= "Boleto para pagamento do(s) danfe(s) "+cNumDanfe
Local aFiles		:= {}

Local lConexao			:= .F.
Local lEnvio   			:= .F.
Local lDesconexao			:= .F.
Local cMailServer  		:= "smtp.grupogen.com.br"
//Local cMailConta   		:= "informes@grupogen.com.br"
//Local cMailSenha   		:= "irfp2016$"
Local cMailConta   		:= "noreply@grupogen.com.br"
Local cMailSenha   		:= "genrj$1311"
Local cErro_Conexao		:= ""
Local cErro_Envio			:= ""
Local cErro_Desconexao	:= ""
Local aEmail				:= {}
Local nAuxVld				:= 0
Local cBody				:= ""
Local cMailDest			:= ""
Local nAuxFl				:= {}

DbSelectArea("SE1")
DbSelectArea("SA1")
SE1->(DbSetOrder(1))
SA1->(DbSetOrder(1))

SA1->(Dbgoto(nRecSA1))

For nAuxVld := 1 To Len(aFilePrint)
	cAnexos	+= aFilePrint[nAuxVld][6]+aFilePrint[nAuxVld][7]+","
	//cAssunto	+= aFilePrint[nAuxVld][3]+","
Next nAuxVld

cAnexos	:= Left(cAnexos,len(cAnexos)-1)

If !Empty(SA1->A1_XEMAILF)
	cMailBol := AllTrim(SA1->A1_XEMAILF)
Else
	cMailBol := AllTrim(SA1->A1_EMAIL)	
EndIf

If Empty(cMailBol)
	Aadd(aLogs, "GENA087E: E-mail cliente não informado ou invalido "+SA1->A1_COD+"-"+SA1->A1_LOJA+" "+AllTrim(SA1->A1_NOME) + " - " + AllTrim(cMailBol) )	
	lRet	:= .F.
	Return .F.
Else
	aEmail		:= StrTokArr(cMailBol,";")	
	cMailBol	:= ""	
	 For nAuxVld := 1 To Len(aEmail)
	 	If ISEMAIL(AllTrim(aEmail[nAuxVld]))
	 		cMailBol += AllTrim(aEmail[nAuxVld])+";"
	 	EndIf
	 Next
	cMailBol := Left(cMailBol,Len(cMailBol)-1)		
EndIf

If Empty(cMailBol)
	Aadd(aLogs, "GENA087E: E-mail cliente não informado ou invalido "+SA1->A1_COD+"-"+SA1->A1_LOJA+" "+AllTrim(SA1->A1_NOME) + " - " + AllTrim(cMailBol) )
	lRet	:= .F.
	Return .F.
EndIf

Connect Smtp Server cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lConexao

If !lConexao
	GET MAIL ERROR cErro_Conexao
	Aadd(aLogs, "GENA087E: Nao foi possivel estabelecer a Conexao com o servidor - " + cErro_Conexao + " SERVIDOR:"+cMailServer+"  CONTA:"+cMailConta+", cliente: "+SA1->A1_COD+"-"+SA1->A1_LOJA+" - "+AllTrim(SA1->A1_NOME) )	
	lRet	:= .F.
	Return .F.	
Else
	lConexao := Mailauth(cMailConta, cMailSenha)			
	If !lConexao
		GET MAIL ERROR cErro_Conexao
		Aadd(aLogs, "GENA087E: Erro de autenticação, Verifique a conta e a senha para envio - " + cErro_Conexao + " SERVIDOR:"+cMailServer+"  CONTA:"+cMailConta+", cliente: "+SA1->A1_COD+"-"+SA1->A1_LOJA+" - "+AllTrim(SA1->A1_NOME)  )
		lRet	:= .F.
		Return .F.			
	EndIf
EndIf

cBody	:= ' <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> '+Chr(13)+Chr(10)
cBody	+= ' <HTML> '+Chr(13)+Chr(10)
cBody	+= ' 	<HEAD> '+Chr(13)+Chr(10)
cBody	+= ' 		<TITLE>MINISTÉRIO DA FAZENDA</TITLE> '+Chr(13)+Chr(10)
cBody	+= ' 		<META http-equiv=Content-Language content=en-us> '+Chr(13)+Chr(10)
cBody	+= ' 		<META http-equiv=Content-Type content="text/html; charset=windows-1252"> '+Chr(13)+Chr(10)
cBody	+= ' 		<META content="MSHTML 6.00.2900.5726" name=GENERATOR> '+Chr(13)+Chr(10)
cBody	+= ' 	</HEAD> '+Chr(13)+Chr(10)
cBody	+= ' 	<BODY> '+Chr(13)+Chr(10)
cBody	+= '  '+Chr(13)+Chr(10)
cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0"><font face="Calibri">Prezado(a) <b>'+Capital(AllTrim(SA1->A1_NOME))+'</b></font></p> '+Chr(13)+Chr(10)
cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0">&nbsp;</p> '+Chr(13)+Chr(10)

cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0"><span style="font-size: 12pt; font-family: Calibri">Segue(m) em anexo seu(s) boleto(s) referente(s) ao(s) DANFE(s):</span></font></p> '+Chr(13)+Chr(10)

//aEval(aFilePrint, {|x| cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0"><span style="font-size: 12pt; font-family: Calibri">'+x[3]+'</span></font></p> '+Chr(13)+Chr(10) } )
cBody	+= ' 	<p style="margin-top: 0; margin-bottom: 0"><span style="font-size: 12pt; font-family: Calibri">'+cNumDanfe+'</span></font></p> '+Chr(13)+Chr(10)

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

		
ConfirmMailRead( .F. )// confirmação de recebimento                                             
//cAnexos	:= AllTrim(cDirPDF+cFilePrint)

Do Case	
	Case !Empty(cMailTeste) 
		cMailDest	:= cMailTeste
	Case !Empty(cMailHomol)
		cMailDest	:= cMailHomol 	
	OtherWise
		cMailDest	:= cMailBol
EndCase		

Send Mail From cMailConta To cMailDest BCC cMailAudit SubJect cAssunto BODY cBody FORMAT TEXT ATTACHMENT cAnexos RESULT lEnvio
			
If !lEnvio
	Get Mail Error cErro_Envio
	lRet	:= .F.
	//Aadd(aFileCli,{ TMP_BOL->RECSE1,TMP_BOL->E1_FILIAL,TMP_BOL->E1_NUM,TMP_BOL->E1_PREFIXO,TMP_BOL->E1_PARCELA,cDirPDF,cFilePrint })
	For nAuxFl := 1 to Len(aFileCli)
		Aadd(aEnviados, { aFilePrint[nAuxFl][2], aFilePrint[nAuxFl][3], aFilePrint[nAuxFl][4], aFilePrint[nAuxFl][5],Capital(AllTrim(SA1->A1_NOME))+" ("+SA1->A1_COD+"-"+SA1->A1_LOJA+") ",AllTrim(cMailDest),DtoC(DDataBase)+" "+Time(), "FALHA" , cErro_Envio } )		
	Next
	Return .F.			
Else
	For nAuxFl := 1 to Len(aFilePrint)
		Aadd(aEnviados, { aFilePrint[nAuxFl][2], aFilePrint[nAuxFl][3], aFilePrint[nAuxFl][4], aFilePrint[nAuxFl][5],Capital(AllTrim(SA1->A1_NOME))+" ("+SA1->A1_COD+"-"+SA1->A1_LOJA+") ",AllTrim(cMailDest),DtoC(DDataBase)+" "+Time(), "SUCESSO" , "" } )
		SE1->(DbGoTo( aFilePrint[nAuxFl][1] ))
		RecLock("SE1",.F.)
		SE1->E1_XDTMAIL	:= DDataBase
		SE1->E1_XHRMAIL	:= Time()
		MsUnLock()				
	Next
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³EXECUTA desconexao ao servidor SMTP³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DisConnect Smtp Server Result lDesconexao

IF !lDesconexao
	Get Mail Error cErro_Desconexao
	Aadd(aLogs, "GENA087E: Envio de Email, Nao foi possivel DESCONECTAR do servidor - " + cErro_Desconexao +", cliente: "+SA1->A1_COD+"-"+SA1->A1_LOJA+" - "+AllTrim(SA1->A1_NOME) )
	lRet	:= .F.
	Return .F.			
EndIf

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA087   ºAutor  ³ Cleuto P. Lima     º Data ³  15/03/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera boleto                                  				 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA087B(cAliSE1, nReg, nOpc)

Local aLogs		:= {}
Local cFilePrint	:= ""
Local cMsg			:= ""

DbSelectArea("SE1")
SE1->(DbGoTo(nReg))

DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbSeek( xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA ))

If !U_GENA085(SE1->(Recno()),SE1->E1_FILIAL,SE1->E1_NUM,SE1->E1_PREFIXO,SE1->E1_PARCELA,@aLogs,.T.,.F.,SA1->(Recno()),SA1->A1_COD,SA1->A1_LOJA,@cFilePrint)
	cMsg := ""
	aEval(aLogs, {|x| cMsg+=x+Chr(13)+Chr(10) } )
	
	If !MostraLog(cMsg)
		Return .F.
	EndIf	
EndIf

Return nil


Static function MostraLog(cMsg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aPosObj    	:= {}
Local aObjects   	:= {}
Local aSize      	:= MsAdvSize()

Local oDlgMsg		:= Nil
Local oBtnPanel	:= Nil
Local nWidth 		:= 50
Local oFont		:= Nil
Local oBmp			:= Nil
Local oTFont 		:= TFont():New('Courier new',,-18,.T.)

Local lRet			:= .F.

Private cCadastro	:= "Log de processamento"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a area dos objetos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}
Aadd( aObjects, { 100, 100, .t., .t. } )

aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aSize :=  {0,0,800,800,1800,800,0}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a tela                                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Define Dialog oDlgMsg 	Title cCadastro ;
From aSize[7],00 TO aSize[6],aSize[5] ;
/*STYLE nOR(WS_VISIBLE,WS_POPUP)*/ PIXEL

oDlgMsg:lMaximized := .T.
oDlgMsg:SetColor(CLR_BLACK,CLR_WHITE)
oDlgMsg:SetFont(oFont)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Armazena as corrdenadas da tela                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMbrWidth := oDlgMsg:nWidth/2-43
nMbrHeight := oDlgMsg:nHeight/2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os paineis da telas                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@00,00 MSPANEL oBtnPanel PROMPT "" SIZE 60,25 of oDlgMsg
oBtnPanel:Align := CONTROL_ALIGN_LEFT

@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgMsg
oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os botoes da tela                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGrpMenu	:= TGroup():New(05,05,(oBtnPanel:NCLIENTHEIGHT/2)-10,(oBtnPanel:NCLIENTWIDTH/2),"Funções",oBtnPanel,CLR_RED,,.T.)

@ 05,05 BITMAP oBmp RESNAME GetMenuBmp() OF oGrpMenu SIZE (oBtnPanel:NCLIENTWIDTH/2)-05,(oBtnPanel:NCLIENTHEIGHT/2)-15 NOBORDER PIXEL

TBrowseButton():New(075,008, OemToAnsi("Sair")			, 	oBtnPanel, {|| oDlgMsg:End() }	, nWidth, 10,,oDlgMsg:oFont, .F., .T., .F.,, .F.,,,)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oGrpLog		:= TGroup():New(05,05,(oMainCentro:NCLIENTHEIGHT/2)-10,(oMainCentro:NCLIENTWIDTH/2)-10,"Log de processamento",oMainCentro,CLR_RED,,.T.)
oTMultiget1 := TMultiget():New(15,10,{|u|if(Pcount()>0,cMsg:=u,cMsg)}, oMainCentro,(oMainCentro:NCLIENTWIDTH/2)-30,(oMainCentro:NCLIENTHEIGHT/2)-30,,,,,,.T.)

Activate MsDialog oDlgMsg Centered

Return lRet



Static Function ExportGrid(aEnviados,lView,cFileLog)

Local cSheet	:= "LogEmail"
Local cTable	:= "Log de Processamento"

Local cArquivo	:= "LOG_MAIL_BOL_"+DtoS(DDataBase)+StrTran(Time(),":","")+".xls"
Local oExcel 		:= FWMSEXCEL():New()
Local cPath		:= IIF( !lView , GetMv("GEN_FIN009",.f.,"\workflow\Anexos\Boleto\")+cFilAnt+"\" , GetTempPath() )
Local lMail		:= .F.

Default lView	:= .F.

//If !ApOleClient( 'MsExcel' )
//	MsgAlert( 'MsExcel nao instalado' )
//	Return
//EndIf

oExcel:AddworkSheet(cSheet)
oExcel:AddTable (cSheet,cTable)

//Alinhamento da coluna ( 1-Left,2-Center,3-Right )  //Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )

oExcel:AddColumn(cSheet,cTable,"Filial"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"No.Titulo"	   	,1,1)
oExcel:AddColumn(cSheet,cTable,"Parcela"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"Prefixo"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"Cliente"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"E-Mail Dest."	   	,1,1)
oExcel:AddColumn(cSheet,cTable,"Dt.Processamento",2,4)
oExcel:AddColumn(cSheet,cTable,"Status"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"Observação"	   	,1,1)


For nAuxExp := 1 To Len(aEnviados)

		oExcel:AddRow(cSheet,cTable,{;		
			aEnviados[nAuxExp][1],;
			aEnviados[nAuxExp][2],;
			aEnviados[nAuxExp][3],;
			aEnviados[nAuxExp][4],;
			aEnviados[nAuxExp][5],;
			aEnviados[nAuxExp][6],;
			aEnviados[nAuxExp][7],;
			aEnviados[nAuxExp][8],;
			aEnviados[nAuxExp][9];				
		})

Next nAuxExp
		
oExcel:Activate()
oExcel:GetXMLFile(cPath+cArquivo)
cFileLog	:= cPath+cArquivo

If lView
	ShellExecute("Open", cPath+cArquivo, "", cPath, 1 )
EndIf		
//oExcelApp := MsExcel():New()
//oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha
//oExcelApp:SetVisible(.T.)

FreeObj(oExcel)

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA087   ºAutor  ³ Cleuto P. Lima     º Data ³  15/03/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera boleto                                  				 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GENA087V(cAliSE1, nReg, nOpc)

Local aAreaSX1	:= SX1->(GetArea())
Local aLogs		:= {}
Local cFilePrint	:= ""
Local cMsg			:= ""
Local aFileCli	:= {}
Local nPosBol		:= 0
Local cDirPDF		:= GetMv("GEN_FIN009",.f.,"\workflow\Anexos\Boleto\")//+cFilAnt+"\"
Local aFiles		:= {}
Local lContinua	:= .T.
Local cPerg		:= "GENA087V" 
Local aEnviados	:= {}

WFForceDir(cDirPDF)

//U_xGPutSx1(cPerg, "01", "E-mail Teste?"			, ".", ".", "mv_ch1" , "C",	99							, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")

If !Pergunte(cPerg,.T.)
	Return nil
EndIf

cMailTeste	:= MV_PAR01

DbSelectArea("SE1")
SE1->(DbGoTo(nReg))

DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbSeek( xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA ))

If !U_GENA085(SE1->(Recno()),SE1->E1_FILIAL,SE1->E1_NUM,SE1->E1_PREFIXO,SE1->E1_PARCELA,@aLogs,.F.,.T.,SA1->(Recno()),SA1->A1_COD,SA1->A1_LOJA,@cFilePrint)

	cMsg := ""
	aEval(aLogs, {|x| cMsg+=x+Chr(13)+Chr(10) } )
	
	If !MostraLog(cMsg)
		Return .F.
	EndIf
	
Else

	/* verifica se todos os PDFs do cliente estão OK */
	aFiles 	:= Directory(cDirPDF+cFilAnt+"\"+cFilePrint)
	If !(File(cDirPDF+cFilAnt+"\"+cFilePrint)  .AND. Len(aFiles) > 0 .AND. aFiles[1][2] > 0)
		Aadd(aLogs, "GENA087E: arquivo PDF do boleto não localizado "+cDirPDF+cFilAnt+"\"+cFilePrint+", Recno SE1: "+cValToChar(nReg)+", Filial Tit.:"+SE1->E1_FILIAL+", Num.Tit.:,"+SE1->E1_NUM+;
		",Pref.Tit.:"+SE1->E1_PREFIXO+",Parc.Tit.:"+SE1->E1_PARCELA )
		lContinua	:= .F.	
	EndIF
	
	If lContinua	
		Aadd(aFileCli, { nReg,SE1->E1_FILIAL,SE1->E1_NUM,SE1->E1_PREFIXO,SE1->E1_PARCELA,cDirPDF+cFilAnt+"\",cFilePrint , File(cDirPDF+cFilePrint) } )		
		GENA087E( SA1->(Recno()) ,SA1->A1_COD,SA1->A1_LOJA,aFileCli,@aLogs,@aEnviados,cMailTeste,SE1->E1_NUM)		
	EndIf

	If Len(aEnviados) > 0
		ExportGrid(aEnviados,.T.) 
	EndIf
	
	If Len(aLogs) > 0
		cMsg := ""
		aEval(aLogs, {|x| cMsg+=x+Chr(13)+Chr(10) } )
		
		If !MostraLog(cMsg)
			Return .F.
		EndIf
	EndIf
					
EndIf

RestArea(aAreaSX1)

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA087W  ºAutor  ³ Cleuto P. Lima     º Data ³  15/03/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera boleto                                  				 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GENA087W()

Local aLogs		:= {}
Local aEnviados	:= {}
Local cMsg			:= ""
Local cMailTeste	:= GetMv("GEN_FIN011",.f.,"cleuto.lima@grupogen.com.br;rodrigo.pacheco@grupogen.com.br")
Local cEmailLog	:= GetMv("GEN_FIN012",.f.,"cleuto.lima@grupogen.com.br;rodrigo.pacheco@grupogen.com.br")
Local cFileLog	:= ""

If Select("TMP_BOL") > 0
	TMP_BOL->(DbCloseArea())
EndIf

BeginSql Alias "TMP_BOL"	
	SELECT SE1.R_E_C_N_O_ RECSE1, SA1.R_E_C_N_O_ RECSA1,E1_FILIAL,E1_NUM,E1_PREFIXO,E1_PARCELA,A1_COD,A1_LOJA
	FROM %Table:SE1% SE1
	JOIN %Table:SA1% SA1
	ON A1_FILIAL = %xFilial:SA1%
	AND A1_COD = E1_CLIENTE
	AND A1_LOJA = E1_LOJA
	AND SA1.%NotDel%
	JOIN %Table:SEA% SEA
	ON EA_FILIAL = E1_FILIAL
	AND EA_NUM = E1_NUM
	AND EA_PARCELA = E1_PARCELA
	AND EA_PREFIXO = E1_PREFIXO
	AND EA_TIPO = E1_TIPO
	AND SEA.EA_PORTADO = SE1.E1_PORTADO
	AND EA_NUMBOR = E1_NUMBOR
	AND SEA.EA_AGEDEP = SE1.E1_AGEDEP
	AND SEA.EA_NUMCON = SE1.E1_CONTA
	AND SEA.%NotDel%		
	WHERE E1_FILIAL = %xFilial:SE1%
	AND E1_SALDO > 0
	AND SE1.%NotDel%
	AND TRIM(E1_XDTMAIL) IS NULL
	AND TRIM(E1_NUMBCO) IS NOT NULL
	AND TRIM(E1_IDCNAB) IS NOT NULL
	AND E1_TIPO = 'NF'	
	AND A1_BLEMAIL = '1'
	AND E1_BAIXA = ' '
	AND EA_DATABOR BETWEEN TO_CHAR(SYSDATE-7,'YYYYMMDD') AND TO_CHAR(SYSDATE-1,'YYYYMMDD')
  	AND EXISTS(
	    SELECT 1 FROM %Table:SEE% SEE
	    WHERE EE_FILIAL = %xFilial:SEE%
	    AND EE_AGENCIA = EA_AGEDEP
	    AND EE_CODIGO = SEA.EA_PORTADO
	    AND EE_CONTA = EA_NUMCON
	    AND EE_XWFBOL = '1'
	    AND SEE.%NotDel%
  	)	 	  				
	ORDER BY SE1.E1_FILIAL,A1_COD,A1_LOJA,E1_NUM,E1_PREFIXO,E1_PARCELA
EndSql

TMP_BOL->(DbGoTop())

If TMP_BOL->(EOF())
	TMP_BOL->(DbCloseArea())
	Conout("Nenhum registro encontrado com os parametros informados!")
	Return nil
EndIf

GENA087A(0,@aLogs,@aEnviados,cMailTeste)

TMP_BOL->(DbCloseArea())

If Len(aLogs) > 0
	cMsg := ""
	aEval(aLogs, {|x| cMsg+=x+Chr(13)+Chr(10) } )
	/*
	If !MostraLog(cMsg)
		Return .F.
	EndIf
	*/	
EndIf

If Len(aEnviados) > 0
	ExportGrid(aEnviados,.F.,@cFileLog)
	cMsg := "Log de processamento de envio de boletos Gen filial "+cFilAnt+chr(13)+chr(10)+cMsg	
EndIf

If Len(aEnviados) > 0 .OR. Len(aLogs) > 0
	U_GenSendMail(,,,"noreply@grupogen.com.br",cEmailLog,oemtoansi("Workflow Protheus Financeiro - Boleto Gen - Log Processamento"),cMsg,cFileLog,,.F.)
EndIf

Return nil 

