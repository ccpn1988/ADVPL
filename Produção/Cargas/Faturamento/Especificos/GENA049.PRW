#INCLUDE "Protheus.ch" 
#INCLUDE "TopConn.ch"

#DEFINE CRLF	CHR(13)+CHR(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA048   � Autor �Cleuto Lima-LOOP    � Data �  05/05/16   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para transmiss�o automatica de notas fiscais de     ���
���          �servi�o.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � GEn                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENA049(cSerie,cNotaini,cNotaFin,cForca,dDataIni,dDataFim)

//�����������������������������������������������������������������������������Ŀ
//�Variaveis da rotina.                                                         �
//�������������������������������������������������������������������������������
Local lContinua		:= .T.
Local cReturn		:= ""

PRIVATE bFiltraBrw	:= {||.t.}	// N�o remover a variavel bFiltraBrw pois a mesma � utlizada internamente pela rotina de transmiss�o padr�o.
PRIVATE aIndArq  	:= {}		// N�o remover a variavel aIndArq pois a mesma � utlizada internamente pela rotina de transmiss�o padr�o.
PRIVATE cCondicao 	:= ""		// N�o remover a variavel cCondicao pois a mesma � utlizada internamente pela rotina de transmiss�o padr�o.

Default cSerie			:= "3  "
Default cNotaini		:= ""
Default cNotaFin		:= ""
Default cForca			:= ""
Default dDataIni		:= CToD('01/01/14')
Default dDataFim        := CToD('31/12/49')
     
lContinua	:= !(Empty(cSerie) .Or. ( Empty(cNotaini) .And. Empty(cNotaFin) .And. Empty(dDataIni) .And. Empty(dDataFim) ))

//���������������Ŀ
//�valida conex�o.�
//�����������������      
If lContinua
	lContinua 	:= VldConec()
EndIF	

If lContinua
	cReturn	:= EnvNfse(cSerie,cNotaini,cNotaFin,cForca,dDataIni,dDataFim)
EndIf	

Return cReturn

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA049   �Autor  �Cleuto Lima-Oficina1� Data �  26/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �valida/cria conex�o com webservice de transmiss�o.          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VldConec() 

//���������������������������������������������������������Ŀ
//�Variaveis da rotina.                                     �
//�����������������������������������������������������������

Local aArea		:= GetArea()     
Local cCodMun	:= SM0->M0_CODMUN  

Local cUsaColab		:= GetNewPar("MV_SPEDCOL","N")
Local cUSERNEOG		:= GetNewPar("MV_USERCOL","")
Local cPASSWORD		:= GetNewPar("MV_PASSCOL","")
Local cCONFALL 		:= GetNewPar("MV_CONFALL","N") 
Local cDocsColab	:= GetNewPar("MV_DOCSCOL","0")
Local cConteudo		:= ""

Local nRetCol	  := GetNewPar("MV_NRETCOL",10)
Local nAmbCTeC	  := GetNewPar("MV_AMBCTEC",2)
Local nAmbNFeC	  := GetNewPar("MV_AMBICOL",2)

Local lRetorno    := .T.
Local lOk         := .F.

Local oWs

Private cURL       := Padr(GetNewPar("MV_SPEDURL","http://localhost:8080/nfse"),250)
Private cInscMun   := Alltrim(SM0->M0_INSCM)
Private cIdEnt     := U_NFseIdEnt()
Private cVerTSS    := ""
Private cTypeaXML  := ""

Private lBtnFiltro := .F.
Private lDirCert   := .T.  
Private cEntSai	   := "1"
Private aUf		   := {}

//������������������������������������������������������������������������Ŀ
//�Preenchimento do Array de UF                                            �
//��������������������������������������������������������������������������
aadd(aUF,{"RO","11"})
aadd(aUF,{"AC","12"})
aadd(aUF,{"AM","13"})
aadd(aUF,{"RR","14"})
aadd(aUF,{"PA","15"})
aadd(aUF,{"AP","16"})
aadd(aUF,{"TO","17"})
aadd(aUF,{"MA","21"})
aadd(aUF,{"PI","22"})
aadd(aUF,{"CE","23"})
aadd(aUF,{"RN","24"})
aadd(aUF,{"PB","25"})
aadd(aUF,{"PE","26"})
aadd(aUF,{"AL","27"})
aadd(aUF,{"MG","31"})
aadd(aUF,{"ES","32"})
aadd(aUF,{"RJ","33"})
aadd(aUF,{"SP","35"})
aadd(aUF,{"PR","41"})
aadd(aUF,{"SC","42"})
aadd(aUF,{"RS","43"})
aadd(aUF,{"MS","50"})
aadd(aUF,{"MT","51"})
aadd(aUF,{"GO","52"})
aadd(aUF,{"DF","53"})
aadd(aUF,{"SE","28"})
aadd(aUF,{"BA","29"})
aadd(aUF,{"EX","99"})
	  

//Montagem das perguntas
oWs:= WsSpedCfgNFe():New()
oWs:cUSERTOKEN      := "TOTVS"
oWs:cID_ENT         := cIdEnt
oWS:_URL            := AllTrim(cURL)+"/SPEDCFGNFe.apw"
lOk                 := U_NFSeIsRe(cCodMun, cURL, 1) // Mudar o terceiro par�metro para 2 ap�s o c�digo de munic�pio 003 ter sido homologado no m�todo CFGREADYX do servi�o NFSE001

If !( lOk )

	If Empty(cIdEnt)
		cVerTss := "1.28"
	EndIf
	
	// Caso n�o se tenha uma conex�o ou certificado configurado corretamente no TSS, chama o wizard de configura��o
	Fisa022Cfg()
	lOk	:= U_NFSeIsRe(cCodMun, cURL, 1)
	
EndIf

If lOk
	lOk 	:= oWs:CfgTSSVersao()
	cVerTss := oWs:cCfgTSSVersaoResult
EndIf

	
If lOk .And. oWs:cCfgTssVersaoResult >= "1.35"
	oWS:cUSERTOKEN := "TOTVS"
	oWS:cID_ENT    := cIdEnt			
	oWS:cUSACOLAB  := cUsaColab
	oWS:nNUMRETNF  := nRetCol
	oWS:nAMBIENTE  := 0
	oWS:nMODALIDADE:= 0
	oWS:cVERSAONFE := ""
	oWS:cVERSAONSE := ""
	oWS:cVERSAODPEC:= ""
	oWS:cVERSAOCTE := ""
	oWS:cUSERNEOG  := cUSERNEOG
	oWS:cPASSWORD  := cPASSWORD
	oWS:cCONFALL   := cCONFALL   
	
	IF oWs:cCfgTssVersaoResult >= "1.43"
		If "1" $ Upper(cDocsColab)
    		cConteudo += "1"
   		EndiF
   		If "2" $ Upper(cDocsColab)
   			cConteudo += "2"
   		EndIF
   		If "3" $ Upper(cDocsColab)
   			cConteudo += "3"
   		EndIF                    
   		If "4" $ Upper(cDocsColab)
			cConteudo := "4"
    	EndIF
    	If "0" $ Upper(cDocsColab)
    		cConteudo := "0"
   		EndIF				 
		oWS:cDOCSCOL	:= cConteudo
		oWS:nAMBNFECOLAB:= IIF(nAmbNFeC >= 1 .And. nAmbNFeC <=2,nAmbNFeC,2)
		oWS:nAMBCTECOLAB:= IIF(nAmbCTeC >= 1 .And. nAmbCTeC <=2,nAmbCTeC,2)
	EndIF 
	
	oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	ExecWSRet(oWS,"CFGPARAMSPED")		
Else
	lRetorno := .F.
EndIf

Return lRetorno


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA049   �Autor  �Cleuto Lima-Oficina1� Data �  26/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � fun��o para transmiss�o.                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen.                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function EnvNfse(cSerie,cNotaini,cNotaFin,cForca,dDataIni,dDataFim)

//��������������������������������������������������������������Ŀ
//�Variaveis da rotina.                                          �
//����������������������������������������������������������������

Local aArea		:= GetArea()
Local aPerg		:= {}   
Local aParam	:= {}

Local cAlias   		:= "SF2"
Local cParTrans		:= SM0->M0_CODIGO+SM0->M0_CODFIL+"Fisa022Rem"
Local cCodMun  		:= SM0->M0_CODMUN
Local cNotasOk 		:= ""
Local cDEST	   		:= Space(10)
Local cMensRet		:= "" 
Local cMvPar06		:= ""
Local cNftMvPar6	:= ""
Local cWhen 		:= ".T."
local cMsgAIDF 		:= "" 
Local cGravaDest	:= ""
Local dData	 		:= Date()

Local lObrig	:= .T.
Local lNFT		:= .F.

Local nForca	:= 1

DbSelectArea("SF2")
SF2->(DbSetOrder(1))
SF2->(DbSeek(xFilial("SF2")+cNotaini+cSerie))

DbSelectArea("SD2")
SD2->(DbSetOrder(3))
SD2->(DbSeek(xFilial("SD2")+cNotaini+cSerie))

//������������������������������������������������������������Ŀ
//�Fun��o padr�o para transmiss�o com base no fonte FISA022.PRW�
//��������������������������������������������������������������
Fisa022Trs(cCodMun,cSerie,cNotaini,cNotaFin,cForca,cAlias,@cNotasOk,cDEST,nForca,@cMensRet,dDataIni,dDataFim,/*lAuto*/,/*nMaxTrans*/,@cGravaDest)

If Empty(cNotasOk) 	
	Aviso("NFS-e","Nenhuma nota foi transmitida."+CRLF+cMensRet,{"&Sair"},3)
Else
	If ( cCodMun $ Fisa022Cod("101") .or. cCodMun $ Fisa022Cod("102") .Or. ( cCodMun $ GetMunNFT() .And. cEntSai == "0"  ) )
		Aviso("NFS-e","Arquivos Gerados:" +CRLF+ cNotasOk,{"&Sair"},3)
	Else		
		cMensRet := Iif("Uma ou mais notas nao puderam ser transmitidas:"$cNotasOk,"","Notas Transmitidas:"+CRLF)
		Aviso("NFS-e",cMensRet + cNotasOk,{"&Sair"},3)
		cMensRet := cMensRet + cNotasOk
	EndIf
EndIf
	
Return cMensRet   

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �NFseIdEnt � Autor �Eduardo Riera          � Data �18.06.2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Obtem o codigo da entidade apos enviar o post para o Totvs  ���
���          �Service                                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpC1: Codigo da entidade no Totvs Services                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function NFseIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
Local lUsaGesEmp := IIF(FindFunction("FWFilialName") .And. FindFunction("FWSizeFilial") .And. FWSizeFilial() > 2,.T.,.F.)
Local lEnvCodEmp := GetNewPar("MV_ENVCDGE",.F.)
//������������������������������������������������������������������������Ŀ
//�Obtem o codigo da entidade                                              �
//��������������������������������������������������������������������������
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"
	
oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")	
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM		
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := IIF(lUsaGesEmp,FWFilialName(),Alltrim(SM0->M0_NOME))
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""

If lUsaGesEmp .And. lEnvCodEmp
	oWS:oWSEMPRESA:CIDEMPRESA:= FwGrpCompany()+FwCodFil()
EndIf
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If ExecWSRet(oWs,"ADMEMPRESAS")
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	Aviso("NFS-e",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"&Sair"},3)
EndIf

RestArea(aArea)
Return(cIdEnt)   

Static Function ExecWSRet( oWS, cMetodo )

Local bBloco	:= {||}

Local lRetorno	:= .F.    

Private oWS2 

DEFAULT oWS		:= NIL
DEFAULT cMetodo	:= ""

If ( ValType(oWS) <> "U" .And. !Empty(cMetodo) )

	oWS2 := oWS

	If ( Type("oWS2") <> "U" )
		bBloco 	:= &("{|| oWS2:"+cMetodo+"() }") 
		lRetorno:= eval(bBloco)
		
		If ( lRetorno == NIL )
			lRetorno := .F.			
		EndIf
		
	EndIf
	
EndIf

Return lRetorno   


/*
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �NFSeIsRe  � Autor �Eduardo Riera          � Data �18.06.2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica se a conexao com a Totvs Sped Services pode ser    ���
���          �estabelecida                                                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN2: C�digo do munic�pio                               OPC���
���          �ExpC1: URL do Totvs Services SPED                        OPC���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function NFSeIsRe(cCodMun, cURL, nTipo)
	
	Local lRetorno := .T.
	Local oWs      := Nil
	
	Default cCodMun := SM0->M0_CODMUN
	
	If !Empty(cURL) .And. !PutMV("MV_SPEDURL",cURL)
		/*
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial( "SX6" )
		SX6->X6_VAR     := "MV_SPEDURL"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "URL do WebService Nota Fiscal de Servi�os Eletr�nica."
		MsUnLock()
		PutMV("MV_SPEDURL",cURL)
		*/
		lRetorno := .F.		
		Aviso("NFS-e","O parametro MV_SPEDURL n�o est� criado para a empresa:"+cEmpAnt+" e filial:"+cFilAnt,{"&Sair"},3)
	EndIf
	SuperGetMv() //Limpa o cache de parametros - nao retirar
	
	DEFAULT cURL  := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Default nTipo := 1
	
	// Verifica se o servidor da Totvs esta no ar
	oWs := WsSpedCfgNFe():New()
	oWs:cUserToken := "TOTVS"
	oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	If ExecWSRet( oWs ,"CFGCONNECT" )
		lRetorno := .T.
	Else
		Aviso("NFS-e",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"&Sair"},3)
		lRetorno := .F.
	EndIf
	
	// Verifica se o certificado digital ja foi transferido
	If lRetorno .And. nTipo == 2
		oWs := WsNFSe001():New()
		oWs:cUserToken := "TOTVS"
		oWs:cID_ENT    := U_NFseIdEnt()
		oWs:cCODMUN    := cCodMun
		oWS:_URL       := AllTrim(cURL)+"/NFSe001.apw"
		If ExecWSRet( oWs ,"CFGREADYX" )
			lRetorno := .T.
		Else
			lRetorno := .F.
		EndIf
	EndIf
	
Return lRetorno