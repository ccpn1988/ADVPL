#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBCLI    º Autor ³ DANILO AZEVEDO     º Data ³  28/04/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina para transportar cliente cadastrado no Protheus     º±±
±±º          ³para tabela de Cliente no oracle.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo GEN                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LIBCLI(lNewCad)

//FUNCAO DESABILITADA EM 22/01/2015 - DANILO AZEVEDO
Return()


If !upper(alltrim(GetEnvServer())) $ "PRODUCAO-DANILO" .or. FunName() = "RPC"
	Return()
Endif

nIdCli := 0
cCodPais := SA1->A1_CODPAIS
cEst := SA1->A1_EST

cQry1 := "SELECT IDPAIS FROM PAIS WHERE CODBACEN = '"+cCodPais+"'"
If Select("CLI1") <> 0
	CLI1->(dbCloseArea("CLI1"))
Endif
TcQuery cQry1 NEW ALIAS "CLI1"
CLI1->(dbGoTop())
nIdPais := cValToChar(CLI1->IDPAIS)

cQry2 := "SELECT IDUF, CODIGOIBGE FROM UF WHERE TRIM(DESCRICAO) = '"+cEst+"'"
If Select("CLI2") <> 0
	CLI2->(dbCloseArea("CLI2"))
Endif
TcQuery cQry2 NEW ALIAS "CLI2"
CLI2->(dbGoTop())
nIdUF := cValToChar(CLI2->IDUF)
cCodIbge := cValToChar(CLI2->CODIGOIBGE)+alltrim(SA1->A1_COD_MUN)

If cCodIbge <> "9999999"
	cQry21 := "SELECT IDMUNICIPIO IDMUN FROM MUNICIPIO WHERE CODIBGE = '"+cCodIbge+"'"
	If Select("CLI21") <> 0
		CLI21->(dbCloseArea("CLI21"))
	Endif
	TcQuery cQry21 NEW ALIAS "CLI21"
	CLI21->(dbGoTop())
	nIdMun := cValToChar(CLI21->IDMUN)
Else
	nIdMun := "9999999"
Endif

//PESQUISA CLIENTE PELO CNPJ/CPF
If Empty(SA1->A1_XCODOLD) .and. !Empty(SA1->A1_CGC)
	cQry0 := "SELECT IDCLIENTE IDCLI FROM CLIENTE WHERE TRIM(CGCCPF) = '"+alltrim(SA1->A1_CGC)+"' AND SITUACAO = 'A'"
	If Select("CLI0") <> 0
		CLI0->(dbCloseArea("CLI0"))
	Endif
	TcQuery cQry0 NEW ALIAS "CLI0"
	CLI0->(dbGoTop())
	If CLI0->(!EOF()) //ENCONTROU UM OU MAIS REGISTROS NO ORACLE
		nReg := 0
		Do While CLI0->(!EOF())
			nReg++
			CLI0->(dbSkip())
		Enddo
		If nReg = 1
			CLI0->(dbGoTop())
			nIdCli := CLI0->IDCLI
			
			//GRAVA O IDCLIENTE NA TABELA SA1
			RecLock("SA1",.F.)
			SA1->A1_XCODOLD := cValToChar(nIdCli)
			MsUnlock()
		Else
			cMsg := "Foi encontrada uma duplicidade no cadastro de Cliente no Oracle e não será possível sincronizar. Os dados serão salvos apenas no Protheus."
			MsgBox(cMsg,"Atenção")
			
			cMsg += CHR(13)+CHR(10) + CHR(13)+CHR(10)
			cMsg += "Cliente: "+SA1->A1_NOME
			cMsg += CHR(13)+CHR(10) + CHR(13)+CHR(10)
			cMsg += "CPF/CNPJ: "+SA1->A1_CGC
			cMsg += CHR(13)+CHR(10) + CHR(13)+CHR(10)
			
			U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br")+";helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Erro no cadastro de cliente"),cMsg,,,.F.)
			
			Return()
		Endif
	Else //NAO ENCONTROU REGISTRO NO ORACLE
		lNewCad := .T.
	Endif
Endif

If lNewCad
	
	If SA1->A1_MSBLQL = "1" //BLOQUEADO NAO INCLUI NO ORACLE
		Return()
	Endif
	
	If Empty(nIdCli)
		cQry4 := "SELECT SQ_CLIENTE.NEXTVAL IDCLI FROM DUAL"
		If Select("CLI4") <> 0
			CLI4->(dbCloseArea("CLI4"))
		Endif
		TcQuery cQry4 NEW ALIAS "CLI4"
		CLI4->(dbGoTop())
		nIdCli := CLI4->IDCLI
	Endif
	
	cQry := " INSERT INTO DBA_EGK.CLIENTE
	cQry += " (
	//cQry += " BLOQUEADO,
	cQry += " CGCCPF,
	cQry += " COMPLEMENTO,
	cQry += " CONTACONTABIL_TITRECEBER,
	cQry += " CONTATO,
	cQry += " COREND,
	cQry += " ENTEND,
	cQry += " COBEND,
	cQry += " CORBAIRRO,
	cQry += " ENTBAIRRO,
	cQry += " COBBAIRRO,
	cQry += " CORCEP,
	cQry += " ENTCEP,
	cQry += " COBCEP,
	cQry += " DESCRICAO,
	cQry += " EMAIL,
	cQry += " EMAILNFE,
	cQry += " ENTCONTATO,
	cQry += " FRETE,
	cQry += " IDCLIENTE,
	cQry += " IDCONDPGTO,
	cQry += " IDCOORDENADORVENDA,
	//	cQry += " IDGRUPOCLIENTE,
	cQry += " IDMUNICIPIOENT,
	cQry += " IDMUNICIPIOCOR,
	cQry += " IDMUNICIPIOCOB,
	cQry += " IDPAISENT,
	cQry += " IDPAISCOR,
	cQry += " IDPAISCOB,
	//	cQry += " IDREGIAO,
	cQry += " IDTIPOCLIENTE,
	cQry += " IDTIPODESCONTO,
	cQry += " IDTRANSPORTADORA,
	cQry += " IDUFENT,
	cQry += " IDUFCOR,
	cQry += " IDUFCOB,
	cQry += " IEIDENTIDADE,
	cQry += " LIMITE,
	cQry += " NUMERO,
	//	cQry += " OBS,
	cQry += " PREMIUM,
	cQry += " SITUACAO,
	cQry += " ENTTEL,
	cQry += " IDBANCO
	cQry += " )
	
	cQry += " SELECT
	//Iif(SA1->A1_MSBLQL = '1',' 1,',' 0,') //BLOQUEADO 1=SIM,0=NAO - NO PROTHEUS 1=SIM,2=NAO
	cQry += " TRIM(A1_CGC),
	cQry += Iif(Empty(SA1->A1_COMPLEM),"'-',"," TRIM(A1_COMPLEM),")
	cQry += " TRIM(A1_CONTA),
	cQry += " TRIM(A1_CONTATO),
	cQry += " TRIM(A1_END),
	cQry += " TRIM(A1_ENDENT),
	cQry += " TRIM(A1_END),
	cQry += " TRIM(A1_BAIRRO),
	cQry += " TRIM(A1_BAIRROE),
	cQry += " TRIM(A1_BAIRRO),
	cQry += " TRIM(A1_CEP),
	cQry += " TRIM(A1_CEPE),
	cQry += " TRIM(A1_CEP),
	cQry += " TRIM(A1_NOME),
	cQry += " TRIM(LOWER(A1_EMAIL)),
	cQry += " TRIM(LOWER(A1_XEMAILC)),
	cQry += " TRIM(A1_CONTATO),
	cQry += Iif(SA1->A1_TPFRET="C","1,","2,") //1=CIF 2=FOB
	cQry += cValToChar(nIdCli)+",
	cQry += " TRIM(A1_XCONDPG),
	cQry += " TRIM(A1_VEND),
	//	cQry += " , //IDGRUPOCLIENTE
	cQry += " "+nIdMun+","
	cQry += " "+nIdMun+","
	cQry += " "+nIdMun+","
	cQry += " "+nIdPais+",
	cQry += " "+nIdPais+",
	cQry += " "+nIdPais+",
	//	cQry += " , //IDREGIAO
	cQry += " TRIM(A1_XTIPCLI),
	cQry += " TRIM(A1_XTPDES),
	cQry += " TRIM(A1_TRANSP),
	cQry += " "+nIdUF+",
	cQry += " "+nIdUF+",
	cQry += " "+nIdUF+",
	cQry += " TRIM(A1_INSCR),
	cQry += " A1_LC,
	cQry += " TRIM(A1_XENDNUM),
	//	cQry += " 'CLIENTE AVULSO',
	cQry += " A1_XCLIPRE,
	cQry += Iif(SA1->A1_MSBLQL="1","'B',","'A',") //BLOQUEADO OU ATIVO
	cQry += " A1_TEL,
	cQry += " CASE
	cQry += "   WHEN A1_XBCOD='   '
	cQry += "   THEN null
	cQry += "   ELSE to_number(A1_XBCOD)
	cQry += " END A1_XBCOD
	cQry += " FROM "+RetSqlName("SA1")+" WHERE A1_COD = '"+SA1->A1_COD+"' AND A1_LOJA = '"+SA1->A1_LOJA+"' AND D_E_L_E_T_ <> '*'
	
Else
	
	cQry := "UPDATE DBA_EGK.CLIENTE SET
	//	cQry += " CGCCPF = " + TRIM(A1_CGC) + ","
	cQry += " COMPLEMENTO = '" + Iif(Empty(SA1->A1_COMPLEM),"-',", TRIM(SA1->A1_COMPLEM)+"',")
	cQry += Iif(!Empty(SA1->A1_CONTA)," CONTACONTABIL_TITRECEBER = '" + TRIM(SA1->A1_CONTA) + "',"," ")
	cQry += Iif(!Empty(SA1->A1_CONTATO)," CONTATO = '" + TRIM(SA1->A1_CONTATO) + "',"," ")
	cQry += " DESCRICAO = '" + TRIM(SA1->A1_NOME) + "',"
	cQry += " EMAILNFE = '" + lower(TRIM(SA1->A1_EMAIL)) + "',"
	cQry += " EMAIL = '" + lower(TRIM(SA1->A1_XEMAILC)) + "',"
	cQry += " ENTCONTATO = '" + Iif(!Empty(SA1->A1_CONTATO),TRIM(SA1->A1_CONTATO)," ") + "',"
	cQry += " FRETE = " + Iif(SA1->A1_TPFRET="C","1,","2,") //1=CIF 2=FOB
	cQry += Iif(!Empty(SA1->A1_XCONDPG)," IDCONDPGTO = " + TRIM(SA1->A1_XCONDPG) + ",","")
	cQry += Iif(!Empty(SA1->A1_VEND)," IDCOORDENADORVENDA = " + TRIM(SA1->A1_VEND) + ",","")
	cQry += " IDMUNICIPIOENT = " + nIdMun+","
	cQry += " IDMUNICIPIOCOR = " + nIdMun+","
	cQry += " IDMUNICIPIOCOB = " + nIdMun+","
	cQry += " IDPAISENT = " + nIdPais+",
	cQry += " IDPAISCOR = " + nIdPais+",
	cQry += " IDPAISCOB = " + nIdPais+",
	cQry += Iif(!Empty(SA1->A1_XTIPCLI)," IDTIPOCLIENTE = " + TRIM(SA1->A1_XTIPCLI) + ",","")
	cQry += Iif(!Empty(SA1->A1_XTPDES)," IDTIPODESCONTO = " + TRIM(SA1->A1_XTPDES) + ",","")
	cQry += Iif(!Empty(SA1->A1_TRANSP)," IDTRANSPORTADORA = " + TRIM(SA1->A1_TRANSP) + ",","")
	cQry += " IDUFENT = " + nIdUF+",
	cQry += " IDUFCOR = " + nIdUF+",
	cQry += " IDUFCOB = " + nIdUF+",
	cQry += Iif(!Empty(SA1->A1_INSCR)," IEIDENTIDADE = '" + TRIM(SA1->A1_INSCR) + "',","")
	cQry += Iif(!Empty(SA1->A1_LC)," LIMITE = " + alltrim(str(SA1->A1_LC)) + ",","")
	cQry += " COREND = '"+trim(SA1->A1_END)+"',
	cQry += " ENTEND = '"+trim(SA1->A1_END)+"',
	cQry += " COBEND = '"+trim(SA1->A1_END)+"',
	cQry += " CORBAIRRO = '"+trim(SA1->A1_BAIRRO)+"',
	cQry += " ENTBAIRRO = '"+trim(SA1->A1_BAIRRO)+"',
	cQry += " COBBAIRRO = '"+trim(SA1->A1_BAIRRO)+"',
	cQry += " CORCEP = '"+trim(SA1->A1_CEP)+"',
	cQry += " ENTCEP = '"+trim(SA1->A1_CEP)+"',
	cQry += " COBCEP = '"+trim(SA1->A1_CEP)+"',
	cQry += Iif(!Empty(SA1->A1_XENDNUM)," NUMERO = '" + TRIM(SA1->A1_XENDNUM) + "',","")
	cQry += Iif(!Empty(SA1->A1_XCLIPRE)," PREMIUM = " + SA1->A1_XCLIPRE + ",","")
	If SA1->A1_XREV = "0"
		cQry += " SITUACAO = 'C'," //CANCELADO
	Else
		cQry += Iif(SA1->A1_MSBLQL="1"," SITUACAO = 'B',"," SITUACAO = 'A',")  //BLOQUEADO OU ATIVO
	Endif
	cQry += " ENTTEL = '"+trim(SA1->A1_TEL)+"'
	If !Empty(SA1->A1_XBCOD)
		cQry += ", IDBANCO = "+trim(SA1->A1_XBCOD)
	Endif
	cQry += " WHERE IDCLIENTE = " + SA1->A1_XCODOLD
	
Endif

cCodUF := cValToChar(val(Posicione("SX5",1,xFilial("SX5")+"AA"+cEst,"X5_DESCRI")))

If (TCSQLExec(cQry) < 0)
	cMsg := "Ocorreu um erro ao sincronizar o cadastro no Oracle. O cadastro será salvo apenas no Protheus."
	cMsg += CHR(13)+CHR(10) + CHR(13)+CHR(10) + TCSQLError()
	
	U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br")+";helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Erro no cadastro de cliente"),cMsg,,,.F.)
	Return MsgBox(cMsg,"Atenção")
Else
	cQry := "UPDATE CLIENTECONDPGTO SET IDCONDPGTO = "+cValToChar(val((SA1->A1_XCONDPG)))+" WHERE IDCLIENTE = " + SA1->A1_XCODOLD
	TcSqlExec(cQry)
	
	If !Empty(SA1->A1_ENDENT) .and. alltrim(SA1->A1_ENDENT) <> alltrim(SA1->A1_END)
		
		cQry := "SELECT COUNT(*) QTD FROM CLIENTELOCALENTREGA WHERE IDCLIENTE = "+alltrim(SA1->A1_XCODOLD)
		cAlias := GetNextAlias()
		DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), cAlias, .F., .T.)
		nRec := (cAlias)->QTD
		
		If nRec = 0
			cQry := "INSERT INTO CLIENTELOCALENTREGA
			cQry += " (IDCLIENTE,
			cQry += " DESCRICAO,
			cQry += " CGCCPF,
			cQry += " LOGRADOURO,
			cQry += " NUMERO,
			cQry += " BAIRRO,
			cQry += " CODIBGE,
			cQry += " UF,
			cQry += " CEP)
			cQry += " VALUES
			cQry += " ("+alltrim(SA1->A1_XCODOLD)+",
			cQry += " '"+alltrim(SA1->A1_ENDENT)+" - "+alltrim(SA1->A1_BAIRROE)+" - "+alltrim(SA1->A1_MUN)+" - "+cEst+" - CEP "+SA1->A1_CEPE+"',
			cQry += " '"+alltrim(SA1->A1_CGC)+"',
			cQry += " '"+alltrim(SA1->A1_ENDENT)+"',
			cQry += " '"+alltrim(SA1->A1_XNUME)+"',
			cQry += " '"+alltrim(SA1->A1_BAIRROE)+"',
			cQry += " "+cCodUF+alltrim(SA1->A1_COD_MUN)+",
			cQry += " '"+cEst+"',
			cQry += " '"+alltrim(SA1->A1_CEPE)+"')
		Else
			cQry := "UPDATE CLIENTELOCALENTREGA
			cQry += " SET DESCRICAO = '"+alltrim(SA1->A1_ENDENT)+" - "+alltrim(SA1->A1_BAIRROE)+" - "+alltrim(SA1->A1_MUN)+" - "+cEst+" - CEP "+SA1->A1_CEPE+"',
			//cQry += " CGCCPF = ,
			cQry += " LOGRADOURO = '"+alltrim(SA1->A1_ENDENT)+"',
			cQry += " NUMERO = '"+alltrim(SA1->A1_XNUME)+"',
			cQry += " COMPLEMENTO = ' ',
			cQry += " OBSERVACAO = ' ',
			cQry += " BAIRRO = '"+alltrim(SA1->A1_BAIRROE)+"',
			cQry += " CODIBGE = "+cCodUF+alltrim(SA1->A1_COD_MUN)+",
			cQry += " UF = '"+cEst+"',
			cQry += " CEP = '"+alltrim(SA1->A1_CEPE)+"'
			cQry += " WHERE IDCLIENTE = "+alltrim(SA1->A1_XCODOLD)
		Endif
		TcSqlExec(cQry)
	Else
		cQry := "DELETE FROM CLIENTELOCALENTREGA WHERE IDCLIENTE = "+alltrim(SA1->A1_XCODOLD)
		TcSqlExec(cQry)
	Endif
	
EndIf

//TRATAMENTO DA CONDICAO DE PAGAMENTO
aEmpr := {}
aAdd(aEmpr,'1')
aAdd(aEmpr,'2')
aAdd(aEmpr,'4')
aAdd(aEmpr,'12')
aAdd(aEmpr,'18')

cFAt238	:= GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br")
If lNewCad
	For i := 1 to len(aEmpr)
		cQry3 := "SELECT CLIENTECONDPGTO_SEQUENCE.NEXTVAL CLICOND FROM DUAL"
		If Select("CLI3") <> 0
			CLI3->(dbCloseArea("CLI3"))
		Endif
		TcQuery cQry3 NEW ALIAS "CLI3"
		CLI3->(dbGoTop())
		nCliCond := cValToChar(CLI3->CLICOND)
		
		cQry := "INSERT INTO CLIENTECONDPGTO(IDCLIENTECONDPGTO,IDCLIENTE,IDEMPRESA,IDCONDPGTO) VALUES ("
		cQry += nCliCond+","
		cQry += cValToChar(nIdCli)+","
		cQry += aEmpr[i]+","
		cQry += cValToChar(val((SA1->A1_XCONDPG)))+")"
		
		If (TCSQLExec(cQry) < 0)
			cMsg := "Ocorreu um erro ao sincronizar o cadastro no Oracle. O cadastro será salvo apenas no Protheus."
			cMsg += CHR(13)+CHR(10) + CHR(13)+CHR(10) + TCSQLError()
			U_GenSendMail(,,,"noreply@grupogen.com.br",cFAt238,oemtoansi("Protheus - Erro no cadastro de cliente"),cMsg,,,.F.)
			Return MsgBox(cMsg,"Atenção")
		EndIf
	Next i
ElseIf !Empty(SA1->A1_XCONDPG)
	cQry := "UPDATE CLIENTECONDPGTO
	cQry += " SET IDCONDPGTO = "+cValToChar(val((SA1->A1_XCONDPG)))
	cQry += " WHERE IDCLIENTE = "+alltrim(SA1->A1_XCODOLD)
	If (TCSQLExec(cQry) < 0)
		cMsg := "TCSQLError() " + TCSQLError()
		U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br"),oemtoansi("Protheus - Erro no cadastro de cliente"),cMsg,,,.F.)
		Return MsgBox(cMsg,"Atenção")
	EndIf
Endif

//GRAVA O IDCLIENTE NA TABELA SA1
If lNewCad
	RecLock("SA1",.F.)
	SA1->A1_XCODOLD := cValToChar(nIdCli)
	MsUnlock()
	
	cQueryINS := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) "
	cQueryINS += " VALUES ('TT_I01_CLIENTE','A1_XCODOLD','"+alltrim(SA1->A1_XCODOLD)+"','    ' ) "
	TCSqlExec(cQueryINS)
	
Endif

Return()
