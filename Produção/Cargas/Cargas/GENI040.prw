*/
User Function GENI040()

Local alEmp 		:= {}
Local lEmp			:= Type('cFilAnt') == "C" .AND. Select("SM0") <> 0
Local nAuxEmp		:= 0
Local nX			:= 0
Local nLimite		:= 50  

Conout("GENI040 - Iniciando Job - "+Time()+".")

If !lEmp		
	RpcSetType(2)
	lOpenSM0 := RpcSetEnv( "00" , "1022")
	If !lOpenSM0
		ConOut("")
	   	ConOut(Replicate("+",nLimite))
	   	ConOut(Padc("GENI040 - Nao foi possivel incializar ambiente confirme a senha/usuario digitado. "+Dtoc(Date())+" "+Time(),nLimite))
	   	ConOut(Replicate("+",nLimite))
	   	ConOut("") 
	   	RpcClearEnv() 
		Return Nil
	Else
		Conout("GENI040 - Abrindo empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())		
	EndIf
EndIF   

While !LockByName("GENI040",.T.,.T.,.T.)
    nX++
	Sleep(10)
	If nX > 2     
		Conout("GENI040 - Não foi possível executar a fila WMS neste momento pois a função JFWMS001 já esta sendo executada por outra processamento!"+DTOC(DDataBase)+" "+Time())
		Return .F.
    EndIf
EndDo


If Select("TMP_NF") > 0
	TMP_NF->(Dbclosearea())
EndIf

BeginSql Alias "TMP_NF"
	SELECT count(*) QTD FROM SPED050 SPED
	WHERE STATUS  IN (1,4)
	AND STATUSCANC = 0
	AND AMBIENTE = 1
	AND MODALIDADE = 1
	AND DATE_NFE >= '20180309'
	AND ROUND((SYSDATE-TO_DATE(DATE_NFE||TIME_NFE,'RRRRMMDD HH24:MI:SS'))*60*24,3) >= 5
EndSql

TMP_NF->(DbGoTop())

If TMP_NF->QTD > 0
	shellExecute("Open", "D:\Restart_TSS.bat", " /k d	ir", "D:\", 1 )
	//U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br;cleutolima@gmail.com",oemtoansi("Notas paradas TSS será reinicado"),"Notas paradas TSS será reinicado",nil,,.F.)
	
	cQueryINS := "INSERT INTO SCH_NOTIFICAEMAIL.EMAIL
 	cQueryINS += " (ID,REMETENTE_NOME, REMETENTE_EMAIL, DESTINATARIO_NOME, DESTINATARIO_EMAIL, ASSUNTO, CORPO, COPIA, RESPONDER_PARA, ENVIADO)
	cQueryINS += " VALUES ( (SELECT MAX(ID)+1 FROM SCH_NOTIFICAEMAIL.EMAIL),
 	cQueryINS += " 'TI GEN', 'noreply@grupogen.com.br', 'TI GEN', 'CLEUTO.LIMA@GRUPOGEN.COM.BR', 'NOTAS TRAVADAS NO TSS', '"+StrZero(TMP_NF->QTD,4)+" NOTAS TRAVADAS NO TSS O MESMO FOI REINICIADO AUTOMATICAMENTE AS "+Time()+"', 'CLEUTOLIMA@GMAIL.COM;RAFAEL.LEITE@GRUPOGEN.COM.BR;MARCOS.SILVA@GRUPOGEN.COM.BR', ' ', 'N'
	cQueryINS += " )
 
	TCSqlExec(cQueryINS)

	Conout("GENI040 - Notas paradas "+StrZero(TMP_NF->QTD,4)+" "+time())
Else
	Conout("GENI040 - Nehuma nota parada "+time())
EndIf

TMP_NF->(Dbclosearea())


If !lEmp .AND. Type('cFilAnt') == "C"
	RpcClearEnv()
EndIF

UnLockByName("GENI040",.T.,.T.,.T.)

Conout("GENI040 - Finalizando Job - fila de processos WMS - "+Time()+".")

Return nil