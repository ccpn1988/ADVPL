#INCLUDE "Protheus.ch" 
#INCLUDE "TopConn.ch"

#DEFINE CRLF	CHR(13)+CHR(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENJOB01  � Autor �Cleuto Lima-Oficina1� Data �  25/02/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Job    para transmiss�o automatica de notas fiscais de     ���
���          �servi�o.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENJOB01(aParam)

//����������������������������������������������������������������������������������Ŀ
//�Variaveis da rotina.                                                              �
//������������������������������������������������������������������������������������
Local cUserJob	:=	"cleuto.lima"
Local cPswJob	:=	""
Local cEmpJob	:= "00"
Local cFilJob	:= ""
Local lCloseEmp	:= .F.
Local nLimite	:= 150 
Local aNfse		:= {}

Default aParam	:= {"00","1001","",""}

cFilJob	:= aParam[2]

If Type("cFilAnt") == "U"
	RpcSetType(2)
	//If !RpcSetEnv( cEmpJob , cFilJob, cUserJob ,  cPswJob, "FAT"  , {'SM0','SX1'},,,.t.)
	If !RpcSetEnv( cEmpJob , cFilJob)
		ConOut("")
	   	ConOut(Replicate("+",nLimite))
	   	ConOut(Padc("GENJOB01 - Nao foi possivel inicializar ambiente confirme a senha/usuario digitado. "+Dtoc(Date())+" "+Time(),nLimite))
	   	ConOut(Replicate("+",nLimite))
	   	ConOut("") 
	   	RpcClearEnv()
		Return Nil
	 EndIf
	 lCloseEmp	:= .T.
EndIf

ConOut(Padc("GENJOB01 - "+cFilJob+" - Iniciando Transmiss�o NFSe. "+Dtoc(Date())+" "+Time(),nLimite))

If LockByName("GENJOB01_"+cFilAnt,.T.,.T.,.T.)
	ConOut("GENJOB01 - Inciando processamento. "+cFilAnt+"_"+Dtoc(Date())+" "+Time())
	GENJOB01A(aNfse)
	UnLockByName("GENJOB01_"+cFilAnt,.T.,.T.,.T.)
	ConOut("GENJOB01 - Processamento finalizado. "+cFilAnt+"_"+Dtoc(Date())+" "+Time())
else
	ConOut("GENJOB01 - N�o foi poss�vel iniciar processamento, rotina j� em execu��o. "+Dtoc(Date())+" "+Time())	
EndIf	

If lCloseEmp
	RpcClearEnv()	
EndIf

Return nil  


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENJOB01A �Autor  �Cleuto Lima-Oficina1� Data �  27/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Busca as notas fiscais de servi�o pendentes para transmiss�o���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen  .                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GENJOB01A(aNfse)
//����������������������������������������������������������������������������������������Ŀ
//�Variaveis da rotina.                                                                    �
//������������������������������������������������������������������������������������������
Local aArea	   		:= GetArea()
Local cSql	   		:= ""
Local cChr			:= Chr(13)+Chr(10)
Local cAliasSql		:= GetNextAlias()
Local cSerieDoc		:= ""
Local cFilNf  		:= ""
Local aLogProc		:= {}
Local cRet			:= ""

// Variaveis criadas com base no fonte padr�o FISA022.
Local aMonitor		:= {}
Local lAuto			:= .t. 
Local cParNfseRem  	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"AUTONFSEREM"
Local dDataIni		:= FirstDay(DDataBase)-120
Local dDataFim		:= DDataBase
Local cForca		:= ""  
Local cMailMonit	:= SuperGetMv("GEN_JOB001",.f.,"cleutolima@gmail.com;rafael.leite@grupogen.com.br")

// Variaveis criadas com base no fonte padr�o FISA022 de uso obrigatorio.
Private cURL       := Padr(GetNewPar("MV_SPEDURL","http://localhost:8080/nfse"),250)
Private cInscMun   := Alltrim(SM0->M0_INSCM)
Private cIdEnt     := U_NFseIdEnt()
Private cVerTSS    := ""
Private cTypeaXML  := ""

Private lBtnFiltro := .F.
Private lDirCert   := .T.  
Private cEntSai	   := "1"
Private aUf		   := {}

// Pergunte padr�o utilizado pela fun��o monitor NFSe.
Pergunte(cParNfseRem,.f.)

cSql	+=	"	SELECT F2_FILIAL FILIAL,F2_DOC DOC,F2_SERIE SERIE,F2_CLIENTE CLI_FOR,F2_LOJA LOJA, 'S' TIPO,F2_ESPECIE ESPECIE,F2_TIPO TIPO_NF,F2_EMISSAO EMISSAO FROM "+RetSqlName("SF2")+" SF2	"+cChr
cSql	+=	"	WHERE F2_FILIAL = '"+cFilAnt+"' " 
cSql	+=	"	AND F2_EMISSAO between '"+DtoS(dDataIni)+"'	and '"+DtoS(dDataFim)+"'"+cChr
cSql	+=	"	AND	F2_ESPECIE = 'RPS' AND F2_NFELETR = ' '	"+cChr
cSql	+=	"	AND SF2.D_E_L_E_T_ <> '*'	"+cChr
cSql	+=	"	ORDER BY FILIAL,DOC,SERIE,CLI_FOR	"+cChr

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasSql,.T.,.T.)

(cAliasSql)->(DbGoTop())
While (cAliasSql)->(!Eof())

	cSerie		:= (cAliasSql)->SERIE
	cIniDoc		:= (cAliasSql)->DOC
	cFimDoc		:= (cAliasSql)->DOC	
	cFilNf		:= PadL((cAliasSql)->FILIAL,6,"0")
	cCgc		:= ""
	
	SA1->(DbSeek(xFilial("SA1")+(cAliasSql)->CLI_FOR+(cAliasSql)->LOJA))		
	cCgc	:= SA1->A1_CGC
	
	MV_PAR01	:= cSerie
	MV_PAR02	:= cIniDoc
	MV_PAR03	:= cFimDoc
	
	//������������������������������������������������������������������������������Ŀ
	//�Fun��o padr�o Monitor NFSe.                                                   �
	//��������������������������������������������������������������������������������
	Fis022Mnt1(lAuto,@aMonitor)
	
	If Len(aMonitor) == 0

		ConOut("GENJOB01 - "+cFilAnt+" - transmitino nota "+cIniDoc+". "+Dtoc(Date())+" "+Time())  
		
	   	cRet	:= U_GENA049(cSerie,cIniDoc,cFimDoc,cForca,dDataIni,dDataFim)

		//������������������������������������������������������������������������������Ŀ
		//�Fun��o padr�o Monitor NFSe.                                                   �
		//��������������������������������������������������������������������������������		
		Fis022Mnt1(lAuto,@aMonitor)	
	EndIf
	
	If Len(aMonitor) == 0
		Aadd(aLogProc, {(cAliasSql)->DOC,cFilNf,cSerie,"Problema na transmiss�o automatica da NFSe",(cAliasSql)->TIPO_NF,(cAliasSql)->CLI_FOR,(cAliasSql)->LOJA,(cAliasSql)->TIPO,(cAliasSql)->EMISSAO} )		
	ElseIf !Empty(aMonitor[1][9][1][1]) .And. aMonitor[1][9][1][1] <> "111" /*<-- 111 = Emissao de Nota Autorizada.*/
		Aadd(aLogProc, {(cAliasSql)->DOC,cFilNf,cSerie,aMonitor[1][6]+CRLF+"Erro: "+aMonitor[1][9][1][1]+" - "+aMonitor[1][9][1][2],(cAliasSql)->TIPO_NF,(cAliasSql)->CLI_FOR,(cAliasSql)->LOJA,(cAliasSql)->TIPO,(cAliasSql)->EMISSAO} )			
	EndIf

	(cAliasSql)->(DbSkip())
EndDo

If Len(aLogProc) <> 0
    cMsg	:= ""
    
    cMsg	+= "    <html> "+cChr
    cMsg	+= "	<body> "+cChr
    cMsg	+= "		<table> "+cChr
    cMsg	+= "			<th> "+cChr
    cMsg	+= "				<td>Filial</td> "+cChr
    cMsg	+= "				<td>Nota</td> "+cChr
    cMsg	+= "				<td>Serie</td> "+cChr
    cMsg	+= "				<td>Mensagem</td> "+cChr
    cMsg	+= "			</th> "+cChr
    
    For nLog := 1 To Len(aLogProc)
	    cMsg	+= "			<tr> "+cChr
	    cMsg	+= "				<td>"+aLogProc[nLog][2]+"</td> "+cChr
	    cMsg	+= "				<td>"+aLogProc[nLog][1]+"</td> "+cChr
	    cMsg	+= "				<td>"+aLogProc[nLog][3]+"</td> "+cChr
	    cMsg	+= "				<td>"+aLogProc[nLog][4]+"</td> "+cChr
	    cMsg	+= "			</tr> "+cChr    
    Next
    
    cMsg	+= "		</table> "+cChr
    cMsg	+= "	</body> "+cChr
    cMsg	+= "	</html> "+cChr
	
   //	U_GenSendMail(,,,"cleutolima@gmail.com","cleuto.lima@loopconsultoria.com.br",oemtoansi("Protheus - Transmiss�o automatica de nota fiscal"),oemtoansi(cMsg),,,.F.)
   	WFNotifyAdmin(AllTrim(cMailMonit),oemtoansi("Protheus - Transmiss�o automatica de nota fiscal"),oemtoansi(cMsg))
EndIF	

RestArea(aArea)

Return nil  