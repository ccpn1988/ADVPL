#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M450BRW  � Autor � Renato Calabro'    � Data �  07/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada utilizado para manipula��o do array que   ���
���          � cont�m os dados que ser�o apresentados ao analisar o cr�-  ���
���          � dito do cliente manualmente                                ���
�������������������������������������������������������������������������͹��
���Retorno   � aExpR - Array com dados para apresenta��o no browser(tela) ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M450BRW()

Local cPitcSld	:= AllTrim(GetSX3Cache("A1_SALPED", "X3_PICTURE"))
 
Local nValor	:= 0

Local lAtivo	:= GetMV("GEN_FAT118",, .T.)

Local dDtInclus	:= CToD("")

Local aAreas	:= GetArea()
Local aBrowse	:= ParamIXB[1]

//������������������������������������������������������������������������������Ŀ
//� Se PE estiver ativo e se array possuir informacoes, continuo a adicionar no- �
//� vas informacoes                                                              �
//��������������������������������������������������������������������������������
If lAtivo .AND. Len(aBrowse) > 0
	
	//Ajusta t�tulos
	aBrowse[1][1] := "Limite de cr�dito (A)"
	aBrowse[2][1] := "Soma dos t�tulos abertos (B)"
	aBrowse[3][1] := "Soma dos pedidos digitados"
	aBrowse[4][1] := "Soma dos pedidos com bloqueio de credito"
	aBrowse[5][1] := "Soma dos pedidos liberados (C)"
	aBrowse[6][1] := "Soma do limite de cr�dito (A-B-C)"
	aBrowse[6][4] := ""
	aBrowse[6][5] := ""
	
	//aBrowse[8][1] := "Maior nota fiscal emitida"
	//Substituida informacao acima pela abaixo, chamado 47085 [Bruno Parreira, 23/05/2019]
	aBrowse[8][1] := "Maior Nota �ltimos 12 meses"
	aBrowse[8][2] := Transform(MaiorNota(SA1->A1_COD,SA1->A1_LOJA),PesqPict("SF2","F2_VALMERC"))
	
	aBrowse[8][4] := "" //"Maior t�tulo a receber emitido"
	aBrowse[8][5] := "" //Valor zerado chamado 47085 [Bruno Parreira, 23/05/2019]
	
	aBrowse[9][1] := "Maior saldo devedor registrado"
	//Substituida informacao acima pela abaixo, chamado 47085 [Bruno Parreira, 23/05/2019]
	//aBrowse[9][1] := "Maior Saldo devedor �ltimos 12 meses"
	//aBrowse[9][2] := ""//MaiorSaldo(SA1->A1_COD,SA1->A1_LOJA)
	
	//aBrowse[9][4] := "Somatorio pagamentos feitos atrasados"
	//Substituida informacao acima pela abaixo, chamado 47085 [Bruno Parreira, 23/05/2019]
	aBrowse[10][1] := "Somat�rio pagamentos atrasados �ltimos 12 meses"
	aBrowse[10][2] := Transform(SomaPag(SA1->A1_COD,SA1->A1_LOJA),PesqPict("SE1","E1_VALOR"))
	
	//aBrowse[10][1] := "" //"Numero notas emitidas"
	//aBrowse[10][2] := "" //Valor zerado chamado 47085 [Bruno Parreira, 23/05/2019]
	aBrowse[10][4] := "Numero t�tulos pagos"
	aBrowse[11][1] := "Valor Atraso atual (somat�rio t�tulos vencidos)"
	aBrowse[12][1] := "" //"Numero t�tulos protestados"
	aBrowse[12][2] := "" //Valor zerado chamado 47085 [Bruno Parreira, 23/05/2019]
	aBrowse[12][4] := "" //Ultimo Protesto - zerado chamado 47085
	aBrowse[12][5] := "" //Valor zerado chamado 47085 [Bruno Parreira, 23/05/2019]
	aBrowse[13][1] := "Numero cheques devolvidos"
	aBrowse[13][4] := "" //"Ultimo cheque devolvido"
	aBrowse[13][5] := "" //Valor zerado chamado 47085 [Bruno Parreira, 23/05/2019]
	aBrowse[14][1] := "Primeira compra"
	aBrowse[14][4] := "�ltima compra"
	aBrowse[15][1] := ""
	
	//Ajuste 
	_nValor1:= StrTran(aBrowse[1][2],".","")
	_nValor1:= StrTran(_nValor1,",",".")
	_nValor1:= Val(_nValor1)

	aBrowse[2][2] := TransForm(SldCliente(SA1->A1_COD+SA1->A1_LOJA),X3Picture("A1_SALDUP"))
	_nValor2:= StrTran(aBrowse[2][2],".","")
	_nValor2:= StrTran(_nValor2,",",".")
	_nValor2:= Val(_nValor2)

	_nValor3:= StrTran(aBrowse[5][2],".","")
	_nValor3:= StrTran(_nValor3,",",".")
	_nValor3:= Val(_nValor3)

	aBrowse[6][2] := TransForm((_nValor1-_nValor2-_nValor3),X3Picture("A1_SALDUP"))
	
	//Zera colunas de moeda 2    
	aBrowse[1][3] := ""
	aBrowse[1][4] := ""
	aBrowse[1][5] := "" 
	aBrowse[1][6] := ""
	aBrowse[2][3] := ""
	aBrowse[2][4] := "" 
	aBrowse[2][5] := ""
	aBrowse[2][6] := ""
	aBrowse[3][3] := "" 
	aBrowse[3][6] := ""
	aBrowse[4][3] := "" 
	aBrowse[4][6] := ""
	aBrowse[5][3] := "" 
	aBrowse[5][6] := ""
	aBrowse[6][3] := "" 
	aBrowse[6][6] := ""
	aBrowse[7][3] := "" 
	aBrowse[7][6] := ""
	aBrowse[8][3] := "" 
	aBrowse[8][6] := ""
	aBrowse[9][3] := "" 
	aBrowse[9][6] := ""
	aBrowse[10][3] := "" 
	aBrowse[10][6] := ""
	aBrowse[11][3] := "" 
	aBrowse[11][5] := Transform(SA1->A1_METR , cPitcSld)
	aBrowse[11][6] := ""
	aBrowse[12][3] := ""
	aBrowse[12][6] := ""
	aBrowse[13][3] := ""
	aBrowse[13][6] := ""	
	aBrowse[14][2] := DTOC(SA1->A1_PRICOM) 
	aBrowse[14][3] := ""
	aBrowse[14][6] := ""
	aBrowse[15][2] := ""
	aBrowse[15][3] := ""
	aBrowse[15][6] := ""
	
	//������������������������������������������������������������������������������Ŀ
	//� Adiciono linha em branco para separar novas informacoes                      �
	//��������������������������������������������������������������������������������
	AddLinBco(@aBrowse)

	//������������������������������������������������������������������������������Ŀ
	//� Informacao de data de inclusao do cliente                                    �
	//� Verifica se o campo USERLGI esta preenchido. Se nao, considero a data da     �
	//� primeira compra do cliente.                                                  �
	//��������������������������������������������������������������������������������
	If !Empty(SA1->A1_USERLGI)
		dDtInclus := CToD(FwLeUserlg("A1_USERLGI", 2))		//1-Cod. Usuario/2-Data inclusao
	ElseIf !Empty(SA1->A1_PRICOM)
		dDtInclus := SA1->A1_PRICOM
	EndIf

	//������������������������������������������������������������������������������Ŀ
	//� Posicao dos vetores do array aBrowse:                                        �
	//� [1] - 1a. informacao a ser exibida                                           �
	//� [2] - Valor da moeda 1 da 1a. informacao                                     �
	//� [3] - Valor da moeda 2 da 1a. informacao                                     �
	//� [4] - 2a. informacao a ser exibida                                           �
	//� [5] - Valor da moeda 1 da 2a. informacao                                     �
	//� [6] - Valor da moeda 2 da 2a. informacao                                     �
	//� [7] - Coluna sobressalente                                                   �
	//��������������������������������������������������������������������������������

	aTail(aBrowse)[1] := "Data de cadastro cliente"
	aTail(aBrowse)[2] := DToC(dDtInclus)

	aTail(aBrowse)[4] := "Saldo em Consigna��o"
	nValor := GetSldConsig(SA1->A1_COD, SA1->A1_LOJA)
	aTail(aBrowse)[5] := Transform(nValor, cPitcSld)
	
	AddLinBco(@aBrowse)
	
	aTail(aBrowse)[1] := RetTitle("A1_XCANALV")
	aTail(aBrowse)[2] := Alltrim(SA1->A1_XCANALV)+"-"+Alltrim(GetAdvFval("SX5","X5_DESCRI",xFilial("SX5") + "Z2" + SA1->A1_XCANALV, 1))
	
	aTail(aBrowse)[4] := RetTitle("A1_XTIPCLI")
	aTail(aBrowse)[5] := Alltrim(SA1->A1_XTIPCLI)+"-"+Alltrim(GetAdvFval("SX5","X5_DESCRI",xFilial("SX5") + "TP" + SA1->A1_XTIPCLI, 1))
	
	AddLinBco(@aBrowse)
	
	aTail(aBrowse)[1] := RetTitle("A1_VEND")
	aTail(aBrowse)[2] := Alltrim(SA1->A1_VEND)+"-"+Alltrim(GetAdvFval("SA3","A3_NOME",xFilial("SA3") + SA1->A1_VEND, 1))
	
	aTail(aBrowse)[4] := RetTitle("A1_XTPDES")
	aTail(aBrowse)[5] := Alltrim(SA1->A1_XTPDES)	
	
	AddLinBco(@aBrowse)
	
	//aTail(aBrowse)[1] := RetTitle("A1_XCLIPRE") //[Bruno Parreira, 23/05/2019]
	//aTail(aBrowse)[2] := If(Alltrim(SA1->A1_XCLIPRE) == "1","Sim","N�o") //[Bruno Parreira, 23/05/2019]
	
	aTail(aBrowse)[1] := RetTitle("A1_XAUTOR")  //Alterado da posicao 4 para 1 [Bruno Parreira, 23/05/2019]
	aTail(aBrowse)[2] := If(Alltrim(SA1->A1_XAUTOR) == "1","Sim","N�o") //Alterado da posicao 5 para 2 [Bruno Parreira, 23/05/2019]

	If ISINCALLSTACK("U_GENA078")
		// Cleuto - 29/10/2018 - incluida informa��o de condica��o de pagamento
		AddLinBco(@aBrowse)
		 
		aTail(aBrowse)[1] := "Cond.Pag.Cliente"
		aTail(aBrowse)[2] := SA1->A1_COND+" - "+AllTrim(Posicione("SE4",1,xFilial("SE4")+SA1->A1_COND,"E4_DESCRI"))
	EndIf
	
//	aBrowse := DelCpoArray(aBrowse, cDado)
EndIf

RestArea(aAreas)

Return aBrowse

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �MaiorNota � Autor � Bruno Parreira     � Data �  23/05/19   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna a maior nota emitida nos ultimos 12 meses          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MaiorNota(cCodCli,cLoja)
Local nRet := 0
Local cQuery := ""
Local cDatAnt := DtoS(MonthSub(DDATABASE,12)) 

Default cCodCli		:= ""
Default cLoja		:= ""

cQuery += "select NVL(MAX(F2_VALMERC),0) AS VALOR " + CRLF
cQuery += "from "+RetSqlName("SF2")+" SF2 " + CRLF
cQuery += "where F2_CLIENTE = '"+cCodCli+"' " + CRLF 
cQuery += "and F2_LOJA = '"+cLoja+"' " + CRLF
cQuery += "and SF2.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "and F2_EMISSAO >= '"+cDatAnt+"' " + CRLF
cQuery += "and F2_TIPO = 'N' " + CRLF
cQuery += "and F2_CHVNFE <> ' ' " + CRLF

Memowrite("\query\M450BRW_MaiorNota.sql",cQuery)

If Select("MFN") > 0
	MFN->(dbCloseArea())
EndIf
	
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"MFN", .F., .T.)

DbSelectArea("MFN")

If MFN->(!EOF())
	nRet := MFN->VALOR
EndIf

Return nRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �MaiorSaldo� Autor � Bruno Parreira     � Data �  23/05/19   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna o maior saldo devedor dos ultimos 12 meses.        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*Static Function MaiorSaldo(cCodCli,cLoja)
Local nRet := 0
Local cQuery := ""
Local cDatAnt := DtoS(MonthSub(DDATABASE,12)) 

Default cCodCli		:= ""
Default cLoja		:= ""

cQuery += " " + CRLF

Memowrite("\query\M450BRW_MaiorSaldo.sql",cQuery)

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
	
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB", .F., .T.)

DbSelectArea("TRB")

If TRB->(!EOF())
	nRet := 
EndIf

Return nRet*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �SomaPag   � Autor � Bruno Parreira     � Data �  23/05/19   ���
�������������������������������������������������������������������������͹��
���Descricao �Retorna a soma dos pagamentos atrasados dos ultimos 12 meses���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function SomaPag(cCodCli,cLoja)
Local nRet := 0
Local cQuery := ""
Local cDatAnt := DtoS(MonthSub(DDATABASE,12)) 

Default cCodCli		:= ""
Default cLoja		:= ""

cQuery += "select SUM(E1_VALOR) AS SOMA " + CRLF
cQuery += "from "+RetSqlName("SE1")+" SE1 " + CRLF
cQuery += "where E1_CLIENTE = '"+cCodCli+"' " + CRLF
cQuery += "and E1_LOJA = '"+cLoja+"' " + CRLF
cQuery += "and SE1.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "and E1_VENCREA >= '"+cDatAnt+"' " + CRLF
cQuery += "and E1_BAIXA > E1_VENCREA " + CRLF
cQuery += "and E1_SALDO = 0 " + CRLF

Memowrite("\query\M450BRW_SomaPag.sql",cQuery)

If Select("SUM") > 0
	SUM->(dbCloseArea())
EndIf
	
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SUM", .F., .T.)

DbSelectArea("SUM")

If SUM->(!EOF())
	nRet := SUM->SOMA
EndIf

Return nRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetSldCons� Autor � Renato Calabro'    � Data �  07/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Consulta via banco de dados para obter o saldo dos produ-  ���
���          � tos em consignacao para um determinado cliente             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� cExp1 - Codigo do cliente a ser consultado                 ���
���          � cExp2 - Loja do cliente a ser consultado                   ���
�������������������������������������������������������������������������͹��
���Retorno   � nExpR - Saldo em aberto do cliente consultado              ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GetSldConsig(cCodCli, cLoja,cProd)

Local cQuery		:= ""
Local cAlias		:= GetNextAlias()

Local nSldConsig	:= 0

Default cCodCli		:= ""
Default cLoja		:= ""
Default cProd		:= ""

IF ! Empty(cProd)
	cQuery += "SELECT SUM(SB6.B6_SALDO) SLD_CONSIG " + CRLF 		//Ajuste para validar saldo de obra consignada 16/05/2019 - CAIO NEVES
Else	
	cQuery := "SELECT SUM(SB6.B6_SALDO * SB6.B6_PRUNIT) SLD_CONSIG " + CRLF
EndIF
cQuery += "	 FROM " + RetSqlTab("SB6") + CRLF
cQuery += "  JOIN " + RetSqlTab("SF4") + CRLF
cQuery += "    ON SF4.F4_FILIAL = '" + xFilial("SF4") + "' " + CRLF
cQuery += "   AND SF4.F4_CODIGO = SB6.B6_TES " + CRLF
cQuery += "   AND SF4.F4_ESTOQUE = 'S' " + CRLF
cQuery += "   AND SF4.D_E_L_E_T_ <> '*' " + CRLF
cQuery += " WHERE B6_FILIAL = '" + xFilial("SB6") + "' " + CRLF
cQuery += "   AND B6_CLIFOR = '" + cCodCli + "' " + CRLF
cQuery += "   AND B6_LOJA = '" + cLoja + "' " + CRLF
IF ! Empty(cProd)
	cQuery += "   AND B6_PRODUTO = '" + cProd + "' " + CRLF 		//Ajuste para validar saldo de obra consignada 16/05/2019 - CAIO NEVES
EndIF
cQuery += "   AND B6_TIPO = 'E' " + CRLF						//E-Em Poder de terceiros/D-De poder de terceiros
cQuery += "   AND B6_TPCF = 'C' " + CRLF						//C-Cliente/F-Fornecedor
cQuery += "   AND B6_PODER3 = 'R' " + CRLF						//R-Remessa/D-Devolucao
cQuery += "   AND B6_SALDO <> 0 " + CRLF
cQuery += "   AND SB6.D_E_L_E_T_ <> '*'"

cQuery := ChangeQuery(cQuery)

MsgRun("Apurando saldos...", "Aguarde", {|| DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .F., .T.) })

If (cAlias)->(!EOF())
	nSldConsig := (cAlias)->(SLD_CONSIG)
EndIf

If Select(cAlias) > 0
	DbSelectArea(cAlias)
	(cAlias)->( DbCloseArea() )
EndIf

Return nSldConsig

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AddLinBco� Autor � Renato Calabro'    � Data �  07/13/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para adicionar uma linha em branco no array utili-  ���
���          � zado no Browse de consulta de credito por cliente para se- ���
���          � parar novas informacoes                                    ���
�������������������������������������������������������������������������͹��
���Parametros� aExp1 - Array contendo valores do Browse                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � Nil                                                        ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AddLinBco(aBrowse)

Local nPosBlank	:= 0				//Posicao de linha em branco

nPosBlank := aScan(aBrowse, {|x| Empty(x[1]) })

If nPosBlank > 0
	aAdd(aBrowse, aClone(aBrowse[nPosBlank]))
Else
	aAdd(aBrowse, Array(Len(aBrowse[1])))
	aEval(aTail(aBrowse), {|x| x := ""})
EndIf

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DelCpoArra� Autor � Renato Calabro'    � Data �  07/13/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao apagar qualquer dado do array que sera apresentado  ���
���          � na tela do Browse                                          ���
�������������������������������������������������������������������������͹��
���Parametros� aExp1 - Array contendo valores do Browse                   ���
���          � cExp2 - Texto do campo do vetor Informacoes (1a. coluna ou ���
���          �         4a. coluna)                                        ���
���          � lExp3 - Se apos apagar conteudo, se deve verificar se toda ���
���          �         linha esta' vazia, e apaga'-la se verdadeiro       ���
�������������������������������������������������������������������������͹��
���Retorno   � aBrowse                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function DelCpoArray(aBrowse, cDado, lDelLin)

Local nPosDado	:= 0

Local lTemDado	:= .F.

Default cDado	:= ""

Default lDelLin	:= .T.

Default aBrowse	:= {}

If Len(aBrowse) > 0
	//������������������������������������������������������������������������������Ŀ
	//� Verifico se o texto existe na 1a coluna de informacao                        �
	//��������������������������������������������������������������������������������
	nPosDado := aScan(aBrowse, {|x| AllTrim(cDado) $ AllTrim(x[1]) })
	//������������������������������������������������������������������������������Ŀ
	//� Se nao encontrou, verifico se o texto existe na 2a coluna de informacao      �
	//��������������������������������������������������������������������������������
	If nPosDado > 0
		nPosCol := 1
	Else
		nPosDado := aScan(aBrowse, {|x| AllTrim(cDado) $ AllTrim(x[4]) })
		If nPosDado > 0
			nPosCol := 4
		EndIf
	EndIf

	//������������������������������������������������������������������������������Ŀ
	//� Se encontrou texto, apago conteudo do texto e dos valores (duas colunas sub- �
	//� sequentes) da moeda 1 e da moeda forte                                       �
	//��������������������������������������������������������������������������������
	If nPosDado > 0
		aBrowse[nPosDado][nPosCol] := ""
		aBrowse[nPosDado][nPosCol + 1] := ""
		aBrowse[nPosDado][nPosCol + 2] := ""
	EndIf

	If lDelLin .AND. nPosDado > 0
		//������������������������������������������������������������������������������Ŀ
		//� Verifica se toda a linha de referencia esta totalmente vazia                 �
		//��������������������������������������������������������������������������������
		aEval(aBrowse[nPosDado], {|x| lTemDado := If(!lTemDado, !Empty(x), lTemDado) })

		If !lTemDado
			aDel(aBrowse, nPosDado)
			aSize(aBrowse, Len(aBrowse) - 1)
		EndIf
	EndIf
EndIf

Return aBrowse