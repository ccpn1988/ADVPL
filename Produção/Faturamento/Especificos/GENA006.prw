#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#Include "rwmake.ch"

#DEFINE cEnt Chr(13)+Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA006   �Autor  �Angelo Henrique     � Data �  28/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina utilizada para realizar as movimenta��es referente a ���
���          �consigna��o do GEN                                          ���
���          �Rotina que ser� ativada via SCHEDULE                        ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA006()

//���������������������������������������Ŀ
//�Rotina ser� chamada apenas por Schedule�
//�����������������������������������������

Prepare Environment Empresa "00" Filial "1022"

//����������������������������������������������������������������������Ŀ
//�Rotina que ir� varrer os produtos com saldo e assim iniciar o processo�
//������������������������������������������������������������������������
lExec := &(GetMv("GENA006EX"))
cExec := GetMv("GENA006DT")
lDiaAnt := substr(cExec,1,8) < DTOS(dDatabase)
lHoraAnt := val(strtran(elaptime(substr(cExec,10,8),time()),":","")) > 3000 //mais de 30 minutos

If !lExec .or. (lExec .and. (lDiaAnt .or. lHoraAnt))
	
	If upper(alltrim(GetEnvServer())) $ "SCHEDULE" //EXECUTA SOMENTE NO AMBIENTE SCHEDULE
		If LockByName("GENA006",.T.,.T.,.T.)
			PutMv("GENA006EX",".T.")
			PutMv("GENA006DT",DTOS(dDatabase)+" "+time())
			U_GENA006A()
			PutMv("GENA006EX",".F.")
			UnLockByName("GENA006",.T.,.T.,.T.)
		Else
			Conout("GENA006 - n�o foi poss�vel iniciar a rotina pois a mesma j� est� sendo executada!")			
		EndIf	
	Endif
	
Endif

Reset Environment
//11/01/2016 - Rafael Leite - Rotina sem aplicacao neste momento.
//U_GENA006D()

Return()


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA006A  �Autor  �Angelo Henrique     � Data �  29/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina que ir� varrer os produtos com saldo e logar na      ���
���          �empresa correta para realizar as movimenta��es.             ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA006A()

Local _aArea 	:= GetArea()
Local _cQuery   := ""
Local _cMsg		:= "" //Mensagem gravada para encaminhar no log de erros
Local _oServer	:= Nil
Local _cEmpCd 	:= ""
Local _cEmpFl 	:= ""
Local _cQuery	:= ""
Local _cAliQry	:= GetNextAlias()
Local _aCabPd	:= {} //Vetor contendo o cabe�alho do pedido de vendas
Local _alinha	:= {} //Vetor contendo a linha do pedido de vendas
Local _aItmPd	:= {} //Vetor que ir� receber o vetor de linhas do pedido de vendas simulando assim os itens do pedido
Local _cClien 	:= ""
Local _cLoj  	:= ""
Local _nCont 	:= 1
Local _cCont 	:= '01'
Local _cAliQry1	:= GetNextAlias()
Local _cAliQry2	:= GetNextAlias()
Local _cAliQry3	:= GetNextAlias()
Local _cAliQry4	:= GetNextAlias()
Local _cAliQry5	:= GetNextAlias()
Local _cAliQry6	:= GetNextAlias()
Local _nDesc 	:= 0
Local _dDtAco	:= CTOD(" / / ")
Local _aCabDcEn := {} //Vetor contendo o cabe�alho documento de entrada
Local _aItmDcEn := {} //Vetor contendo os itens do documento de entrada
Local _alinhaDe := {}
Local _cCliGen 	:= ""
Local _cLojGen 	:= ""
Local _cTrpGen 	:= ""
Local _cTipGen 	:= ""
Local _cVenGen 	:= ""
Local _cNotaImp := ""
Local _nQtdTot  := 0
Local _nValTot  := 0
Local _aDir		:= {}
Local _nPrcVn	:= 0
Local _cEmpM0   := AllTrim(SM0->M0_CODIGO)
Local _cFilM0	:= AllTrim(SM0->M0_CODFIL)
Local _lEmp		:= .F.
Local _aArM0	:= {}
Local _lVcDesc  := .F.

Local _cMvCdPv 	:= GetMv("GEN_FAT001") //Condi��o de pagamento pedido de venda
Local _cMvTsPv 	:= GetMv("GEN_FAT002") //TES Pedido de Vendas
Local _cMvSeri 	:= GetMv("GEN_FAT003") //SERIE nota de sa�da
Local _cMvCdDe 	:= GetMv("GEN_FAT004") //Condi��o de pagamento documento de entrada
Local _cMvTsDe 	:= GetMv("GEN_FAT005") //TES documento de entrada
Local _cMvTbPr 	:= GetMv("GEN_FAT006") //Cont�m a tabela de pre�o usado no pedido de vendas
Local _cLogPd	:= GetMv("GEN_FAT007") //Cont�m o caminho que ser� gravado o log de erro
Local _cMvClDe	:= GetMv("GEN_FAT009") //Cont�m o cliente que ser� utilizado na Nota de Saida
Local _cMvLjDe  := GetMv("GEN_FAT010") //Cont�m a Loja que ser� utilizado na Nota de Saida
Local _cMvEspc  := GetMv("GEN_FAT011") //Cont�m a Especie utilizada para o processo de consigna��o do Doc de Entrada
Local _cServ 	:= GETMV("GEN_FAT030") //Cont�m o Ip do servidor para realizar as mudan�as de ambiente
Local _nPort  	:= GETMV("GEN_FAT031") //Cont�m a porta para realizar as mudan�as de ambiente
Local _cAmb  	:= GETMV("GEN_FAT032") //Cont�m o ambiente a ser utilizado para realizar as mudan�as de filial
Local cCfops	:= AllTrim(SuperGetMv("GEN_EST001",.F.,"1102/5202/6202")) //CFOPs considerados no processo de entrada de grafica

//Local _nPort  	:= 1222 //Cont�m a porta para realizar as mudan�as de ambiente
//Local _cAmb  	:= "DANILO" //Cont�m o ambiente a ser utilizado para realizar as mudan�as de filial

Private lMsErroAuto 	:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.
Private cMail128			:= GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br")

//�������������������������Ŀ
//�Executar limpeza dos logs�
//��������������������������� 

//10/11/2015 - Rafael Leite - Comentado para n�o apagar historico de notas, pois processo ser� alterado
/*
_aDir:=directory(Alltrim(_cLogPd)+"*")
For _ni:= 1 to Len(_aDir)
	fErase(Alltrim(_cLogPd)+_aDir[_ni][1])
Next _ni
*/

cCfops += GetMV("GEN_EST002") //adiciona cfops considerados somente para o processo de entrada de grafica 
cCfops := FormatIn(cCfops,"/")

//�����������������������������������������������������������������������������������������d�
//�Pegando Informa��es da GEN atrav�s dos parametros para ser utilizado no pedido de vendas�
//�����������������������������������������������������������������������������������������d�
DbSelectArea("SA1")
DbSetORder(1)

If DbSeek(xFilial("SA1")+PADR(AllTrim(_cMvClDe),TAMSX3("A1_COD")[1])+PADR(AllTrim(_cMvLjDe),TAMSX3("A1_LOJA")[1]))
	
	_cCliGen := SA1->A1_COD
	_cLojGen := SA1->A1_LOJA
	_cTrpGen := SA1->A1_TRANSP
	_cTipGen := SA1->A1_TIPO
	_cVenGen := SA1->A1_VEND
	
	//���������������������������������������������������Ŀ
	//�Query respons�vel por varrer os produtos com saldos�
	//�����������������������������������������������������
	
	//10/11/2015 - Rafael Leite - Saldo em estoque na origem, gerou a necessidade de ajustar a view.
	//_cQuery := "SELECT * FROM TT_I30_CONSIG_ORIG_GEN
	
	/*
	SELECT B2_FILIAL,B2_COD, B2_LOCAL, B2_QATU, B2_VATU1, B2_CM1, B1_COD, B1_DESC, B1_PROC, B1_LOJPROC, B1_UM
	FROM TOTVS.SB2000 sb2, totvs.SB1000 SB1, totvs.SZ4000 SZ4
	WHERE SB2.B2_COD       = SB1.B1_COD
	AND SB2.B2_QATU        > 0
	AND SB2.D_E_L_E_T_     = ' '
	AND SB1.D_E_L_E_T_     = ' '
	AND SZ4.D_E_L_E_T_     = ' '
	AND SB1.B1_XSITOBR     = SZ4.Z4_COD
	AND (SZ4.Z4_MSBLQL      = '2' or SB1.B1_xsitobr in ('102','109'))
	AND SB1.B1_ISBN       <> ' '
	AND SB2.B2_FILIAL NOT IN ('1022','6002')
	ORDER BY B1_PROC,
	B1_LOJPROC,
	B2_FILIAL
	*/
	
	_cQuery := ""
	_cQuery += " SELECT D1_FILIAL B2_FILIAL, "
	_cQuery += "     D1_DOC, "
	_cQuery += "     D1_SERIE, "
	_cQuery += "     D1_FORNECE, "
	_cQuery += "     D1_LOJA, "
	_cQuery += "     D1_ITEM, "
	_cQuery += "     D1_COD B2_COD, "
	_cQuery += "     D1_LOCAL B2_LOCAL, "
	_cQuery += "     D1_QUANT B2_QATU, "
	_cQuery += "     B2_VATU1, "
	_cQuery += "     B2_CM1, "
	_cQuery += "     B1_COD, "
	_cQuery += "     B1_DESC, "
	_cQuery += "     B1_PROC, "
	_cQuery += "     B1_LOJPROC, "
	_cQuery += "     B1_UM, "
	_cQuery += "     B1_MSBLQL, "
	_cQuery += "     B1_XIDTPPU "
	_cQuery += "   FROM SD1000 SD1,  "
	_cQuery += "     SB2000 SB2, "
	_cQuery += "     SB1000 SB1, "
	_cQuery += "     SZ4000 SZ4, "
	_cQuery += "     SF4000 SF4 "	
	_cQuery += "   WHERE SD1.D_E_L_E_T_  = ' ' "
	_cQuery += "   AND D1_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022') "	
	_cQuery += "   AND SD1.D1_CF         IN " + cCfops + " "
	_cQuery += "   AND SD1.D1_LOCAL      = '01' "
	_cQuery += "   AND SD1.D1_FILIAL     NOT IN ('1022','6002') "
	_cQuery += "   AND SD1.D1_COD        <> '00002419' "
	
	//_cQuery += "   AND SD1.D1_DTDIGIT    > '20151109' "
	
	_cQuery += "   AND SD1.D1_DTDIGIT    > '20160311' " // Cleuto Lima - 04/03/2016 - chamado 27527 	
	_cQuery += "   AND SD1.D1_FILIAL     = SB2.B2_FILIAL "
	_cQuery += "   AND SD1.D1_COD        = SB2.B2_COD "
	_cQuery += "   AND SD1.D1_LOCAL      = SB2.B2_LOCAL "
	
	// <-- Cleuto - 19/11/2020 - Vivaz 50299 - Consigna��o InterCia (GENA006) al�m da CFOP deve verificar se TES movimenta estoque
	_cQuery += "   AND SF4.F4_FILIAL 	 = '"+xFilial("SF4")+"'"
	_cQuery += "   AND SF4.F4_CODIGO     = SD1.D1_TES "
	_cQuery += "   AND SF4.F4_ESTOQUE	 = 'S' "
	_cQuery += "   AND SF4.D_E_L_E_T_	 = ' ' "
	// -->

	_cQuery += "   AND SB2.B2_QATU       > 0  "
	_cQuery += "   AND SB2.D_E_L_E_T_    = ' ' "
	_cQuery += "   AND SB1.D_E_L_E_T_    = ' ' "
	_cQuery += "   AND SB2.B2_COD        = SB1.B1_COD "
	_cQuery += "   AND SB1.B1_ISBN       <> ' ' "
	_cQuery += "   AND SB1.B1_XIDTPPU    NOT IN ('11','15') "
	_cQuery += "   AND SZ4.D_E_L_E_T_    = ' ' "
	_cQuery += "   AND SB1.B1_XSITOBR    = SZ4.Z4_COD "
	_cQuery += "   AND (SZ4.Z4_MSBLQL    = '2' or SB1.B1_xsitobr in ('102','109','110')) "
	_cQuery += "   AND NOT EXISTS "
	_cQuery += "     (SELECT 1 "
	_cQuery += "     FROM TT_I11_FLAG_VIEW I11 "
	_cQuery += "     WHERE I11.VIEW_NAME LIKE '%TT_I30_CONSIG_ORIG_GEN%' "
	_cQuery += "     AND I11.CHAVE       = 'D1_ITEM' "
	_cQuery += "     AND TRIM(I11.VALOR) = TRIM(SD1.D1_DOC||SD1.D1_SERIE||SD1.D1_FORNECE||SD1.D1_LOJA) "
	_cQuery += "     AND TRIM(I11.FILIAL) = TRIM(SD1.D1_FILIAL) "
	_cQuery += "     ) "
	_cQuery += "   ORDER BY B1_PROC desc, "
	_cQuery += "     B1_LOJPROC, "
	_cQuery += "     B2_FILIAL, "
	_cQuery += "     B2_COD "
	
	MemoWrite("GENA006.SQL",_cQuery)
	
	If Select(_cAliQry) > 0
		dbSelectArea(_cAliQry)
		(_cAliQry)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry, .F., .T.)
	
	Conout("GENA006 - Inicia processo")
	
	While (_cAliQry)->(!EOF())
		
		Conout("GENA006 - Nota de entrada " + (_cAliQry)->D1_DOC )
		
		//Ponterando no Fornecedor para realizar a busca na SM0 (Cadastro de Empresas), realizando assim
		//uma nova conex�o na empresa em que ser� gerado a Nota de entrada e Pedido de Vendas/Nota de Saida
		DbSelectArea("SA2")
		DbSetOrder(1)
		If !DbSeek(xFilial("SA2")+(_cAliQry)->B1_PROC+(_cAliQry)->B1_LOJPROC)
			//�����������������������������������
			//�Fun��o para alimentar Log de erro�
			//�����������������������������������
			_cMsg := "N�o foi encontrado no sistema fornecedor com o c�digo: " + AllTrim((_cAliQry)->B1_PROC) + " e loja: " + AllTrim((_cAliQry)->B1_LOJPROC)
			MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_Prod_"+AllTrim((_cAliQry)->B1_COD)+".txt",_cMsg)
			(_cAliQry)->(DbSkip())
			Loop
		EndIf
		
		_cClien := AllTrim(SA2->A2_COD)
		_cLoj   := AllTrim(SA2->A2_LOJA)
		
		DbSelectArea("SA1")
		DbSetOrder(3)
		If !DbSeek(xFilial("SA1")+SA2->A2_CGC)
			//�����������������������������������
			//�Fun��o para alimentar Log de erro�
			//�����������������������������������
			_cMsg := "N�o foi encontrado no sistema cliente com o CNPJ: " + SA2->A2_CGC
			MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_Prod_"+AllTrim((_cAliQry)->B1_COD)+".txt",_cMsg)
			(_cAliQry)->(DbSkip())
			Loop
		EndIf
		
		//���������������������������������������������������������������������Ŀ
		//�Ponterando na SM0 para pegar o CNPJ correto e realzar o ponteramento �
		//�na empresa quer ser� gravado a Nota                                  �
		//�����������������������������������������������������������������������
		_aArM0 := SM0->(GetArea())
		DbSelectArea("SM0")
		SM0->(DbGoTop())
		While SM0->(!EOF())
			If AllTrim(SM0->M0_CGC) == AllTrim(SA2->A2_CGC)
				_lEmp := .T.
				_cEmpCd := SM0->M0_CODIGO
				_cEmpFl := SM0->M0_CODFIL
				Exit
			Else
				_lEmp := .F.
			EndIf
			SM0->(DbSkip())
		EndDo
		
		RestArea(_aArM0)
		
		//GERA LOG CASO PRODUTO ESTEJA COM SALDO NA EMPRESA ERRADA
		If AllTrim((_cAliQry)->B2_FILIAL) <> alltrim(_cEmpFl)
			_cMsg := "Produto com saldo em empresa diferente da informada no fornecedor padr�o (B1_PROC).
			_cMsg += cEnt
			_cMsg += "O correto � " + alltrim(_cEmpFl) + " e n�o " + AllTrim((_cAliQry)->B2_FILIAL) + "."
			MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_Emp_"+AllTrim(SA2->A2_CGC)+".txt",_cMsg)
			(_cAliQry)->(DbSkip())
			Loop
		Endif
		//�������������������������������������������������Ŀ
		//�Se achar a empresa correta realiza a movimenta��o�
		//���������������������������������������������������
		If !_lEmp
			//�����������������������������������
			//�Fun��o para alimentar Log de erro�
			//�����������������������������������
			_cMsg := "N�o foi encontrado no sistema empresa (SM0) com o CNPJ: " + SA2->A2_CGC
			MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_Emp_"+AllTrim(SA2->A2_CGC)+".txt",_cMsg)
			(_cAliQry)->(DbSkip())
			Loop
		EndIf
		
		//��������������������������������������������������������������������������������������������Ŀ
		//�Sequ�ncia considerada no levantamento, listada abaixo para compreens�o:			           �
		//��������������������������������������������������������������������������������������������Ŀ
		//�- Pesquisa tabela de pre�o;                                                                 �
		//�- Verifica vig�ncia da tabela;                                                              �
		//�- Pesquisa produto na tabela de pre�o;                                                      �
		//�- pesquisa regra para cliente;                                                              �
		//�- pesquisa regra de desconto para grupo de cliente;                                         �
		//�- Pesquisa regra de desconto sem cliente Pesquisa regra de desconto grupo de cliente;       �
		//�- Verifica vig�ncia da regra de desconto;                                                   �
		//�- Pesquisa produto dentro da regra de desconto.                                             �
		//�- Se encontrar o produto, pega o desconto; Se n�o pega o desconto do cabe�alho da tabela.   �
		//����������������������������������������������������������������������������������������������
		
		//������������������������������������Ġ�A�
		//�Pegando o produto na tabela de pre�o	  �
		//������������������������������������Ġ�A�
		DbSelectArea("DA0")
		DbSetOrder(1)
		If !DbSeek(xFilial("DA0")+_cMvTbPr)
			//�����������������������������������
			//�Fun��o para alimentar Log de erro�
			//�����������������������������������
			_cMsg := "N�o foi encontrado no sistema tabela de pre�o com o c�digo: " + AllTrim(_cMvTbPr)
			MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_TabPreco_"+AllTrim(_cMvTbPr)+".txt",_cMsg)
			(_cAliQry)->(DbSkip())
			Loop
		EndIf
		
		//���������������������������������������������
		//�Validando se a tabela de pre�o esta vigente�
		//���������������������������������������������
		_aCabPd := {}
		_aCabDcEn := {} //Vetor contendo o cabe�alho documento de entrada
		_aItmDcEn := {} //Vetor contendo os itens do documento de entrada
		_aItmPd := {}
		
		If DA0->DA0_DATATE > dDatabase .OR. Empty(DA0->DA0_DATATE)
			//����������������������������������������������Ŀ
			//�Array contendo o cabe�alho da pedido de vendas�
			//������������������������������������������������
			aAdd ( _aCabPd , { "C5_TIPO"    , "N"      	, Nil} )
			aAdd ( _aCabPd , { "C5_CLIENTE" , _cCliGen 	, Nil} )
			aAdd ( _aCabPd , { "C5_LOJACLI" , _cLojGen 	, Nil} )
			aAdd ( _aCabPd , { "C5_CLIENT"  , _cCliGen	, Nil} )
			aAdd ( _aCabPd , { "C5_LOJAENT" , _cLojGen	, Nil} )
			aAdd ( _aCabPd , { "C5_TRANSP"  , _cTrpGen	, Nil} )
			aAdd ( _aCabPd , { "C5_TIPOCLI" , _cTipGen 	, Nil} )
			aAdd ( _aCabPd , { "C5_VEND1" 	, _cVenGen 	, Nil} )
			aAdd ( _aCabPd , { "C5_CONDPAG" , _cMvCdPv	, Nil} )
			aAdd ( _aCabPd , { "C5_TABELA"  , _cMvTbPr	, Nil} )
			aAdd ( _aCabPd , { "C5_EMISSAO" , dDatabase	, Nil} )
			aAdd ( _aCabPd , { "C5_MOEDA" 	, 1			, Nil} )
			aAdd ( _aCabPd , { "C5_TPLIB" 	, "2"		, Nil} )
			
			//�����������������������������������������������
			//�Array contendo o cabe�alho da nota de entrada�
			//�����������������������������������������������
			
			aadd(_aCabDcEn , {"F1_TIPO"   	,"N"		, Nil} )
			aadd(_aCabDcEn , {"F1_FORMUL" 	,"N"		, Nil} )
			aadd(_aCabDcEn , {"F1_SERIE"  	,_cMvSeri	, Nil} )
			aadd(_aCabDcEn , {"F1_EMISSAO"	,dDataBase	, Nil} )
			aadd(_aCabDcEn , {"F1_FORNECE"	,PADR(AllTrim(_cClien),TAMSX3("F1_FORNECE")[1])	, Nil} )
			aadd(_aCabDcEn , {"F1_LOJA"   	,_cLoj		, Nil} )
			aadd(_aCabDcEn , {"F1_ESPECIE"	,_cMvEspc	, Nil} )
			aadd(_aCabDcEn , {"F1_COND"		,_cMvCdDe	, Nil} )
			
			_nCont := 1
			_cCont := '01'
			
			_lVcDesc := .F.
			_aInsert := {}
			
			_nIt := 1
			While AllTrim((_cAliQry)->B1_PROC) == _cClien .And. AllTrim((_cAliQry)->B1_LOJPROC) == _cLoj .and. _nIt < 50
				_nIt++
				
				//�����������������������������������������������������Ŀ
				//�Validando se saldo atual e igual ao retornado na view�
				//�������������������������������������������������������
				cQry := "SELECT B2_QATU FROM "+RetSqlName("SB2")+" B2
				cQry += " WHERE B2_FILIAL = '"+(_cAliQry)->B2_FILIAL+"'
				cQry += " AND B2_COD = '"+(_cAliQry)->B2_COD+"'
				cQry += " AND B2_LOCAL = '"+(_cAliQry)->B2_LOCAL+"'
				cQry += " AND D_E_L_E_T_ = ' '
				If Select(_cAliQry1) > 0
					dbSelectArea(_cAliQry1)
					(_cAliQry1)->(dbCloseArea())
				EndIf
				
				dbUseArea(.T., "TOPCONN", TcGenQry(,,cQry), _cAliQry1, .F., .T.)
				
				//10/11/2015 - Rafael Leite - Ajusta novo processo de consigna��o. Saldo deve ser maior ou igual
				//lSaldo := (_cAliQry1)->B2_QATU == (_cAliQry)->B2_QATU //SALDO ATUAL IGUAL DO RETORNADO NA VIEW
				lSaldo := (_cAliQry1)->B2_QATU >= (_cAliQry)->B2_QATU //SALDO ATUAL IGUAL DO RETORNADO NA VIEW
				
				If Select(_cAliQry1) > 0
					dbSelectArea(_cAliQry1)
					(_cAliQry1)->(dbCloseArea())
				EndIf
				
				If !lSaldo
					_cMsg := "Saldo atual diferente do encontrado na view para o produto " + AllTrim((_cAliQry)->B2_COD) + "."
					MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_Prod_"+AllTrim((_cAliQry)->B1_COD)+"_Saldo.txt",_cMsg)
					(_cAliQry)->(DbSkip())
					Loop
				Endif
				
				//Retira produtos bloqueados do pedido de venda. // 06/02/2015 - Rafael Leite
				If (_cAliQry)->B1_MSBLQL == '1'
					_cMsg := "Produto bloqueado: " + AllTrim((_cAliQry)->B2_COD) + "."
					MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_Prod_"+AllTrim((_cAliQry)->B1_COD)+"_Bloqueado.txt",_cMsg)
					(_cAliQry)->(DbSkip())
					Loop
				Endif				
				
				//�����������������������������������������������������������Ŀ
				//�Validando se a tabela de pre�o possui o produto selecionado�
				//�������������������������������������������������������������
				DbSelectArea("DA1")
				DbSetOrder(1)
				If DbSeek(xFilial("DA1")+_cMvTbPr+(_cAliQry)->B1_COD)
					
					//����������������������������������������������������������������Ŀ
					//�Valida��o da regra de descontos para regra de cliente		   �
					//������������������������������������������������������������������
					_cQuery := "SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE "
					_cQuery += " FROM " + RetSqlName("ACO")
					_cQuery += " WHERE D_E_L_E_T_ = ' '"
					_cQuery += " AND ACO_CODCLI = '" + SA1->A1_COD + "'"
					_cQuery += " AND ACO_LOJA = '" + SA1->A1_LOJA + "'"
					//_cQuery := ChangeQuery(_cQuery)
					
					If Select(_cAliQry1) > 0
						dbSelectArea(_cAliQry1)
						(_cAliQry1)->(dbCloseArea())
					EndIf
					
					dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry1, .F., .T.)
					
					If (_cAliQry1)->(!EOF())
						
						//��������������������������������Ŀ
						//�Valida��o se a regra de desconto�
						//����������������������������������
						If (_cAliQry1)->ACO_DATATE > dDatabase .OR. Empty((_cAliQry1)->ACO_DATATE)
							
							//��������������������������������������������������������������������Ŀ
							//�Valida��o da para pegar o produto  nas linhas da regra de desconto  �
							//����������������������������������������������������������������������
							_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES "
							_cQuery += " FROM " + RetSqlName("ACP")
							_cQuery += " WHERE D_E_L_E_T_ = ' '"
							_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'"
							//_cQuery := ChangeQuery(_cQuery)
							
							If Select(_cAliQry4) > 0
								dbSelectArea(_cAliQry4)
								(_cAliQry)->(dbCloseArea())
							EndIf
							
							dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry4, .F., .T.)
							
							If (_cAliQry4)->(!EOF())
								_nDesc := (_cAliQry4)->ACP_PERDES
							Else
								
								//�������������������������������������������������������������������������Ŀ
								//�Pega o valor do desconto do cabe�alho, pois n�o achou o produto nos itens�
								//���������������������������������������������������������������������������
								_nDesc := (_cAliQry1)->ACO_PERDES
							EndIf
							
							If Select(_cAliQry4) > 0
								dbSelectArea(_cAliQry4)
								(_cAliQry)->(dbCloseArea())
							EndIf
							
						Else
							
							//���������������������������������Ŀ
							//�Fun��o para alimentar Log de erro�
							//�����������������������������������
							_lVcDesc := .F.
							_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry1)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
							MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_Prod_"+AllTrim((_cAliQry)->B1_COD)+".txt",_cMsg)
							(_cAliQry)->(DbSkip())
						EndIf
					Else
						
						//����������������������������������������������������������������Ŀ
						//�Valida��o da regra de descontos para regra de grupo de cliente  �
						//������������������������������������������������������������������
						_cQuery := "SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE
						_cQuery += " FROM " + RetSqlName("ACO")
						_cQuery += " WHERE D_E_L_E_T_ = ' '
						_cQuery += " AND ACO_GRPVEN = '" + SA1->A1_GRPVEN + "'
						//_cQuery := ChangeQuery(_cQuery)
						
						If Select(_cAliQry2) > 0
							dbSelectArea(_cAliQry2)
							(_cAliQry2)->(dbCloseArea())
						EndIf
						
						dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry2, .F., .T.)
						
						If (_cAliQry2)->(!EOF())
							
							//��������������������������������������������Ŀ
							//�Valida��o se a regra de desconto esta v�lida�
							//����������������������������������������������
							_dDtAco := IIF(ValType((_cAliQry2)->ACO_DATATE) = "C", STOD((_cAliQry2)->ACO_DATATE), (_cAliQry2)->ACO_DATATE)
							
							If _dDtAco > dDatabase .OR. Empty((_cAliQry2)->ACO_DATATE)
								
								//��������������������������������������������������������������������Ŀ
								//�Valida��o da para pegar o produto  nas linhas da regra de desconto  �
								//����������������������������������������������������������������������
								_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES "
								_cQuery += " FROM " + RetSqlName("ACP")
								_cQuery += " WHERE D_E_L_E_T_ = ' '"
								_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'"
								//_cQuery := ChangeQuery(_cQuery)
								
								If Select(_cAliQry4) > 0
									dbSelectArea(_cAliQry4)
									(_cAliQry4)->(dbCloseArea())
								EndIf
								
								dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry4, .F., .T.)
								
								If (_cAliQry4)->(!EOF())
									_nDesc := (_cAliQry4)->ACP_PERDES
								Else
									
									//�������������������������������������������������������������������������Ŀ
									//�Pega o valor do desconto do cabe�alho, pois n�o achou o produto nos itens�
									//���������������������������������������������������������������������������
									_nDesc := (_cAliQry2)->ACO_PERDES
								EndIf
								
								If Select(_cAliQry4) > 0
									dbSelectArea(_cAliQry4)
									(_cAliQry4)->(dbCloseArea())
								EndIf
							Else
								//���������������������������������Ŀ
								//�Fun��o para alimentar Log de erro�
								//�����������������������������������
								_lVcDesc := .T.
								_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry2)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
								MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_Prod_"+AllTrim((_cAliQry)->B1_COD)+".txt",_cMsg)
								(_cAliQry)->(DbSkip())
							EndIf
						Else
							
							//�����������������������������������������������������������������������������S
							//�Valida��o da regra de descontos sem cliente e sem regra de grupo de cliente �
							//������������������������������������������������������������������������������
							_cQuery := " SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE "
							_cQuery += " FROM " + RetSqlName("ACO")
							_cQuery += " WHERE D_E_L_E_T_ = ' '"
							_cQuery += " AND (ACO_CODCLI = ' ' OR ACO_GRPVEN = ' ')"
							//_cQuery := ChangeQuery(_cQuery)
							
							If Select(_cAliQry3) > 0
								dbSelectArea(_cAliQry3)
								(_cAliQry3)->(dbCloseArea())
							EndIf
							
							dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry3, .F., .T.)
							
							If (_cAliQry3)->(!EOF())
								
								//��������������������������������������������Ŀ
								//�Valida��o se a regra de desconto esta v�lida�
								//����������������������������������������������
								_dDtAco := IIF(ValType((_cAliQry2)->ACO_DATATE) = "C", STOD((_cAliQry2)->ACO_DATATE), (_cAliQry2)->ACO_DATATE)
								
								If _dDtAco > dDatabase .OR. Empty((_cAliQry3)->ACO_DATATE)
									
									//��������������������������������������������������������������������Ŀ
									//�Valida��o da para pegar o produto  nas linhas da regra de desconto  �
									//����������������������������������������������������������������������
									_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES "
									_cQuery += " FROM " + RetSqlName("ACP")
									_cQuery += " WHERE D_E_L_E_T_ = ' '"
									_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'"
									//_cQuery := ChangeQuery(_cQuery)
									
									If Select(_cAliQry4) > 0
										dbSelectArea(_cAliQry4)
										(_cAliQry4)->(dbCloseArea())
									EndIf
									
									dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry4, .F., .T.)
									
									If (_cAliQry4)->(!EOF())
										_nDesc := (_cAliQry4)->ACP_PERDES
									Else
										//�������������������������������������������������������������������������Ŀ
										//�Pega o valor do desconto do cabe�alho, pois n�o achou o produto nos itens�
										//���������������������������������������������������������������������������
										_nDesc := (_cAliQry3)->ACO_PERDES
									EndIf
									
									If Select(_cAliQry4) > 0
										dbSelectArea(_cAliQry4)
										(_cAliQry4)->(dbCloseArea())
									EndIf
								Else
									//���������������������������������Ŀ
									//�Fun��o para alimentar Log de erro�
									//�����������������������������������
									_lVcDesc := .T.
									_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry3)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
									MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_Prod_"+AllTrim((_cAliQry)->B1_COD)+".txt",_cMsg)
									(_cAliQry)->(DbSkip())
								EndIf
							EndIf
							If Select(_cAliQry3) > 0
								dbSelectArea(_cAliQry3)
								(_cAliQry3)->(dbCloseArea())
							EndIf
						EndIf
						If Select(_cAliQry2) > 0
							dbSelectArea(_cAliQry2)
							(_cAliQry2)->(dbCloseArea())
						EndIf
					EndIf
					If Select(_cAliQry1) > 0
						dbSelectArea(_cAliQry1)
						(_cAliQry1)->(dbCloseArea())
					EndIf
					
					//��������������������������������������������������Ŀ
					//�Caso n�o tenha dado problema na regra de descontos�
					//����������������������������������������������������
					
					If !_lVcDesc
						If _nDesc != 0
							_nPrcVn := (DA1->DA1_PRCVEN * _nDesc) / 100
						Else
							_nPrcVn := DA1->DA1_PRCVEN
						EndIf
						
						//23/01/2016 - Rafael Leite - Foi cadastrado produto com valor 30.03, com isso, ao aplicar 50% de desconto ocorre erro de arredondamento.
						_nPrcVn := NoRound(_nPrcVn,2)
						
						_nDesc := 0 //Zerando a Vari�vel
						
						If _nPrcVn > 0
							//��������������������������������������������
							//�Array contendo a linha do pedido de vendas�
							//��������������������������������������������
							//aAdd ( _alinha 	, 	{ "C6_ITEM"    	, STRZERO(_nCont,TAMSX3("C6_ITEM")[1])	, Nil})
							
							aAdd ( _alinha 	, 	{ "C6_ITEM"    	, _cCont								, Nil})
							aAdd ( _alinha 	, 	{ "C6_PRODUTO" 	, (_cAliQry)->B1_COD 					, Nil})
							aAdd ( _alinha 	, 	{ "C6_DESCRI"  	, (_cAliQry)->B1_DESC  					, Nil})
							aAdd ( _alinha 	, 	{ "C6_QTDVEN"  	, (_cAliQry)->B2_QATU	  				, Nil})
							aAdd ( _alinha 	, 	{ "C6_PRCVEN"  	, _nPrcVn	    						, Nil})
							If alltrim((_cAliQry)->B1_XIDTPPU) = "11" //ARREDONDA VALOR PARA TIPO PUBLICACAO = PASTA DO PROF. - ALTERADO EM 19/02/2015 - DANILO AZEVEDO
								aAdd ( _alinha 	, 	{ "C6_VALOR"   	, round((_cAliQry)->B2_QATU*_nPrcVn,2)			, Nil})
							Else
								aAdd ( _alinha 	, 	{ "C6_VALOR"   	, (_cAliQry)->B2_QATU*_nPrcVn			, Nil})
							Endif
							aAdd ( _alinha 	, 	{ "C6_QTDLIB"  	, (_cAliQry)->B2_QATU   				, Nil})
							aAdd ( _alinha 	, 	{ "C6_TES"     	, _cMvTsPv     		   					, Nil})
							aAdd ( _alinha 	, 	{ "C6_LOCAL"   	, (_cAliQry)->B2_LOCAL   				, Nil})
							aAdd ( _alinha 	, 	{ "C6_ENTREG"	, dDataBase				   				, Nil})
							
							//�������������������������������������������������������������H
							//�Calcular oos campos customizados de quantidade e valor total�
							//�������������������������������������������������������������H
							_nQtdTot += (_cAliQry)->B2_QATU
							_nValTot += (_cAliQry)->B2_QATU * _nPrcVn
							
							//�����������������������������������������������Ŀ
							//�Array contendo os itens do Documento de Entrada�
							//�������������������������������������������������
							//aAdd(_alinhaDe	,	{"D1_ITEM"		, STRZERO(_nCont,TAMSX3("D1_ITEM")[1])	, Nil})
							aAdd(_alinhaDe	,	{"D1_ITEM"		, _cCont								, Nil})
							aAdd(_alinhaDe	,	{"D1_COD"  		, (_cAliQry)->B1_COD					, Nil})
							aAdd(_alinhaDe	,	{"D1_UM"		, (_cAliQry)->B1_UM						, Nil})
							aAdd(_alinhaDe	,	{"D1_QUANT"		, (_cAliQry)->B2_QATU					, Nil})
							aAdd(_alinhaDe	,	{"D1_VUNIT"		, _nPrcVn								, Nil})
							If alltrim((_cAliQry)->B1_XIDTPPU) = "11" //ARREDONDA VALOR PARA TIPO PUBLICACAO = PASTA DO PROF. - ALTERADO EM 19/02/2015 - DANILO AZEVEDO
								aAdd(_alinhaDe	,	{"D1_TOTAL"		, round((_cAliQry)->B2_QATU*_nPrcVn,2)			, Nil})
							Else
								aAdd(_alinhaDe	,	{"D1_TOTAL"		, (_cAliQry)->B2_QATU*_nPrcVn			, Nil})
							Endif
							aAdd(_alinhaDe	,	{"D1_TES"		, _cMvTsDe								, Nil})
							aAdd(_alinhaDe	,	{"D1_LOCAL"		, (_cAliQry)->B2_LOCAL 					, Nil})
							
							_nCont ++
							_cCont := Soma1(_cCont)
							
							aAdd(_aItmPd , _alinha  )
							_alinha := {}
							
							aadd(_aItmDcEn,_alinhaDe)
							_alinhaDe := {}
							
							aadd(_aInsert,{(_cAliQry)->D1_DOC+(_cAliQry)->D1_SERIE+(_cAliQry)->D1_FORNECE+(_cAliQry)->D1_LOJA,(_cAliQry)->B2_FILIAL})
						Else
							//�����������������������������������
							//�Fun��o para alimentar Log de erro�
							//�����������������������������������
							_cMsg := "Valor informado na tabela de pre�o: " + AllTrim(_cMvTbPr) + " n�o pode ser menor ou igual a 0 (ZERO), produto: " + AllTrim((_cAliQry)->B1_COD)
							MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_Prod_"+AllTrim((_cAliQry)->B1_COD)+".txt",_cMsg)
						EndIf
					EndIf
				Else
					//�����������������������������������
					//�Fun��o para alimentar Log de erro�
					//�����������������������������������
					_cMsg := "N�o foi encontrado no sistema tabela de pre�o/produto com os c�digos: " + AllTrim(_cMvTbPr) + " / " + AllTrim((_cAliQry)->B1_COD)
					MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_Prod_"+AllTrim((_cAliQry)->B1_COD)+".txt",_cMsg)
				EndIf
				(_cAliQry)->(DbSkip())
			EndDo
			
			//���������������������������������������������������
			//�Caso n�o tenha dado problema na regra de descontos�
			//���������������������������������������������������
			
			If !_lVcDesc .and. len(_aItmPd) > 0
				//���������������������������������������������������������������������������Ŀ
				//�Alimentando o cabe�alho do Pedido de Vendas com as informa��es customizadas�
				//�����������������������������������������������������������������������������
				
				// 06/02/2015 - Rafael Leite - Retirado, pois estava estourando o campo. Conversei com o Rodrigo Mourao e ele informou que campo nao eh utilizado para essa nota.
				//aAdd ( _aCabPd , { "C5_XQTDTOT"    , _nQtdTot      	, Nil} )
				//aAdd ( _aCabPd , { "C5_XVALTOT"    , _nValTot      	, Nil} )
				
				aAdd ( _aCabPd , { "C5_XQTDTOT"    , 0.01      	, Nil} )
				aAdd ( _aCabPd , { "C5_XVALTOT"    , 0.01      	, Nil} )
				
				//Zerando as Vari�veis
				_nQtdTot := 0
				_nValTot := 0
				
				//�����������������������������������������������������������������Ŀ
				//�Realizando a nova conex�o para entrar na empresa e filial correta�
				//�������������������������������������������������������������������
				If ValType(_oServer) == "O"
					//Fecha a Conexao com o Servidor
					RESET ENVIRONMENT IN SERVER _oServer
					CLOSE RPCCONN _oServer
					_oServer := Nil
				EndIf
				
				_cTemp1 := U_GravArq1(_aItmPd)
				
				//Inicio do RPC para logar na empresa origem
				CREATE RPCCONN _oServer ON  SERVER _cServ		 	;   //IP do servidor
				PORT _nPort            								;   //Porta de conex�o do servidor
				ENVIRONMENT _cAmb       							;   //Ambiente do servidor
				EMPRESA _cEmpCd          							;   //Empresa de conex�o
				FILIAL  _cEmpFl          							;   //Filial de conex�o
				TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que ser�o abertas
				MODULO  "SIGAFAT"               					//M�dulo de conex�o
				
				//�����������������������������������������������������������������Ŀ
				//�Realizando a nova conex�o para entrar na empresa e filial correta�
				//�������������������������������������������������������������������
				If ValType(_oServer) == "O"
					
					_oServer:CallProc("RPCSetType",3)
					
					_cNotaImp := _oServer:CallProc("U_GENA006B",_aCabPd,_cTemp1,_aInsert)
					
					//Fecha a Conexao com o Servidor
					RESET ENVIRONMENT IN SERVER _oServer
					CLOSE RPCCONN _oServer
					_oServer := Nil
				EndIf
				
				_cTemp1 := ""
				
				If !Empty(_cNotaImp)
					//��������������������������������������������������������������������������������������
					//�Rotina que ir� criar a Nota de Entrada na empresa GEN, ap�s ter ocorrido com sucesso�
					//�a gera��o do pedido de vendas e da Nota de Sa�da para a empresa GEN                 �
					//��������������������������������������������������������������������������������������
					
					aAdd( _aCabDcEn, { "F1_DOC"       ,_cNotaImp })
					If !U_GENA006C(_aCabDcEn,_aItmDcEn)
						/* Cleuto Lima - 30/03/2016 - Incluida exclus�o de pedido e nota fiscal de saida quando n�o conseguir gerar nota fiscal de entrada*/  
						
						//�����������������������������������������������������������������Ŀ
						//�Realizando a nova conex�o para entrar na empresa e filial correta�
						//�������������������������������������������������������������������
						If ValType(_oServer) == "O"
							//Fecha a Conexao com o Servidor
							RESET ENVIRONMENT IN SERVER _oServer
							CLOSE RPCCONN _oServer
							_oServer := Nil
						EndIf
												
						//Inicio do RPC para logar na empresa origem
						CREATE RPCCONN _oServer ON  SERVER _cServ		 	;   //IP do servidor
						PORT _nPort            								;   //Porta de conex�o do servidor
						ENVIRONMENT _cAmb       							;   //Ambiente do servidor
						EMPRESA _cEmpCd          							;   //Empresa de conex�o
						FILIAL  _cEmpFl          							;   //Filial de conex�o
						TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que ser�o abertas
						MODULO  "SIGAFAT"               					//M�dulo de conex�o
						
						//�����������������������������������������������������������������Ŀ
						//�Realizando a nova conex�o para entrar na empresa e filial correta�
						//�������������������������������������������������������������������
						If ValType(_oServer) == "O"
							
							_oServer:CallProc("RPCSetType",3)
							
							_cNotaImp := _oServer:CallProc("U_GENA006F",_cNotaImp,_cMvSeri,_aInsert)
							
							//Fecha a Conexao com o Servidor
							RESET ENVIRONMENT IN SERVER _oServer
							CLOSE RPCCONN _oServer
							_oServer := Nil
						EndIf
										
					EndIf
				EndIf 

				_cEmpCd := ""
				_cEmpFl := ""
								
				//Else
				//_cMsg := "N�o h� itens aptos a consignar na empresa "+alltrim(_cEmpFl)+". Verifique os logs e tente novamente."
				//MemoWrite(_cLogPd+"Fil_"+alltrim(_cEmpFl)+"_erro_itens.txt",_cMsg)
				//(_cAliQry)->(DbSkip())
			EndIf
		Else
			//�����������������������������������
			//�Fun��o para alimentar Log de erro�
			//�����������������������������������
			_cMsg := "A Tabela de pre�o:  " + AllTrim(_cMvTbPr) + " encontra-se vencida, favor verificar. "
			MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_Prod_"+AllTrim((_cAliQry)->B1_COD)+".txt",_cMsg)
			(_cAliQry)->(DbSkip())
		EndIf
	EndDo
	If Select(_cAliQry) > 0
		dbSelectArea(_cAliQry)
		(_cAliQry)->(dbCloseArea())
	EndIf
Else
	//����������������������������������I
	//�Fun��o para alimentar Log de erro�
	//����������������������������������I
	_cMsg := "N�o foi encontrado no sistema o cliente cadastrado nos par�metros de Consigna��o." + cEnt
	_cMsg += "Cliente: " + AllTrim(_cMvClDe) + " loja: " + AllTrim(_cMvLjDe) + cEnt
	_cMsg += "Favor verificar os parametros: GEN_FAT009 e GEN_FAT010" + cEnt
	MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_Cliente_"+AllTrim(_cMvClDe)+".txt",_cMsg)
EndIf

//ENVIA EMAIL CASO ENCONTRE PRODUTO COM SALDO NEGATIVO NA ORIGEM
lEnvMail := (val(strtran(time(),":","")) >= 80000 .and. val(strtran(time(),":","")) <= 81000) .or. (val(strtran(time(),":","")) >= 163000 .and. val(strtran(time(),":","")) <= 163500) //enviara email somente entre 08:00 e 08:05 e entre 16:30 e 16:35

If lEnvMail
	cQry := "SELECT * FROM "+RetSqlName("SB2")+" WHERE B2_FILIAL <> '1022' AND B2_QATU < 0 AND D_E_L_E_T_ = ' ' ORDER BY B2_FILIAL, B2_COD"
	If Select(_cAliQry1) > 0
		dbSelectArea(_cAliQry1)
		(_cAliQry1)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,,cQry), _cAliQry1, .F., .T.)
	
	cProd := Space(0)
	Do While !(_cAliQry1)->(EOF())
		cProd += "Produto "+alltrim((_cAliQry1)->B2_COD)+" com saldo "+cValtoChar((_cAliQry1)->B2_QATU)
		cProd += " no armaz�m "+(_cAliQry1)->B2_LOCAL+" da empresa "+(_cAliQry1)->B2_FILIAL+"."+cEnt
		(_cAliQry1)->(dbSkip())
	Enddo
	
	If !Empty(cProd)
		cDest := GetMV("GENA006E")
		cMsg := "Encontrado um ou mais registros de produto com saldo negativo na tabela SB2 nas empresas origem. Favor verificar a lista abaixo."+cEnt+cEnt
		cMsg += cProd+cEnt+cEnt+cEnt
		cMsg += "Consulta realizada no ambiente "+upper(alltrim(GetEnvServer()))+"."
		U_GenSendMail(,,,"noreply@grupogen.com.br",cDest,oemtoansi("Protheus - Saldo negativo na origem"),oemtoansi(cMsg),,,.F.)
	Endif
	
	If Select(_cAliQry1) > 0
		dbSelectArea(_cAliQry1)
		(_cAliQry1)->(dbCloseArea())
	EndIf
Endif

RestArea(_aArea)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA006B  �Autor  �Angelo Henrique     � Data �  29/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina que ir� gerar o pedido de vendas e a nota de sa�da   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA006B(_aCabPd,_cTemp1,_aInsert)

Local _aArea 			:= GetArea()
Local _cQuery			:= ""
Local _cAliSC9			:= GetNextAlias()
Local _aTmpPV1			:= {}
Local _aPVlNFs			:= {}
Local _cNotaImp			:= ""
Local _cMsg				:= ""
Local _aErro			:= {}
Local _cErroLg			:= ""
Local _cMvSeri 			:= GetMv("GEN_FAT003") //SERIE nota de sa�da
Local _cLogPd			:= GetMv("GEN_FAT007") //Cont�m o caminho que ser� gravado o log de erro
Local _nPosLb			:= 0
Local _cEmpM0           := AllTrim(SM0->M0_CODIGO)
Local _cFilM0			:= AllTrim(SM0->M0_CODFIL)
Local _cMvEsp			:= GetMv("MV_ESPECIE") //Contem tipos de documentos fiscais utilizados na emissao de notas fiscais
Local _aPosEsp 			:= {}
Local _nMvEsp 			:= 0
Local _lEspec			:= .F.
Local _ni,_nr	

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

_aItmPd := u_LeArq1(_cTemp1)
_nPosLb	:= aScan(_aItmPd[1], { |x| Alltrim(x[1]) == "C6_QTDLIB" })

DbSelectArea("SC5")
DbSetOrder(1)

//Forcar o ponteramento no produto para n�o dar erro no execauto
DbSelectArea("SB1")

//��������������������������������Ŀ
//�Valida��o da especie para a nota�
//����������������������������������
_nMvEsp := 0
_aPosEsp := {}

For _ni := 1 To Len(_cMvEsp)
	If SubStr(_cMvEsp,_ni,1) == ";"
		_nMvEsp := _ni
	EndIf
	If _nMvEsp = 0
		If SubStr(_cMvEsp,_ni,1) == "="
			aAdd(_aPosEsp,{SubStr(_cMvEsp,1,_ni-1)})
		EndIf
	Else
		If SubStr(_cMvEsp,_ni,1) == "="
			aAdd(_aPosEsp,{Replace(AllTrim(SubStr(_cMvEsp,_nMvEsp+1,_ni-(_nMvEsp+1))),"=")})
		EndIf
	EndIf
Next

//��������������������������������������������������������������������tP�
//�Varrendo o vetor que contem as s�ries para saber se a s�rie contida�
//�no parametro esta correta.                                         �
//��������������������������������������������������������������������tP�

_lEspec := .F.

For _ni := 1 To Len(_aPosEsp)
	If _aPosEsp[_ni][1] == _cMvSeri
		_lEspec := .T.
	EndIf
Next

If _lEspec
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,3)
	_cPedExc := SC5->C5_NUM
	If !lMsErroAuto //Gerou com sucesso o pedido, ir� ver se existe a necessidade de desbloquear por cr�dito
		
		//Rotina para desbloquear cr�dito para que o pedido seja faturado sem problemas
		DbSelectArea("SC9")
		DbSetOrder(1)
		If DbSeek(xFilial("SC9") + SC5->C5_NUM)
			bValid := {|| .T.}
			_cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_BLCRED,R_E_C_N_O_ SC9RECNO
			_cQuery += " FROM "+RetSqlName("SC9")+" SC9
			_cQuery += " WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"'
			_cQuery += " AND SC9.C9_PEDIDO = '"+SC5->C5_NUM+"'
			_cQuery += " AND (SC9.C9_BLEST <> '  ' OR SC9.C9_BLCRED <> '  ' )
			_cQuery += " AND SC9.C9_BLCRED NOT IN ('10','09')
			_cQuery += " AND SC9.C9_BLEST <> '10'
			_cQuery += " AND SC9.D_E_L_E_T_ = ' '
			
			If Select(_cAliSC9) > 0
				dbSelectArea(_cAliSC9)
				(_cAliSC9)->(dbCloseArea())
			EndIf
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliSC9,.T.,.T.)
			
			While ( (_cAliSC9)->(!Eof()) .And. (_cAliSC9)->C9_FILIAL == xFilial("SC9") .And. (_cAliSC9)->C9_PEDIDO == SC5->C5_NUM .And. Eval(bValid) )
				If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .OR. (SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .OR.;
					SC9->C9_BLCRED=="09" )
					
					/*/
					������������������������������������������������������������������������������
					������������������������������������������������������������������������������
					���          �Rotina de atualizacao da liberacao de credito                ���
					��������������������������������������������������������������������������Ĵ��
					���Parametros�ExpN1: 1 - Liberacao                                         ���
					���          �       2 - Rejeicao                                          ���
					���          �ExpL2: Indica uma Liberacao de Credito                       ���
					���          �ExpL3: Indica uma liberacao de Estoque                       ���
					���          �ExpL4: Indica se exibira o help da liberacao                 ���
					���          �ExpA5: Saldo dos lotes a liberar                             ���
					���          �ExpA6: Forca analise da liberacao de estoque                 ���
					��������������������������������������������������������������������������Ĵ��
					���Descri��o �Esta rotina realiza a atualizacao da liberacao de pedido de  ���
					���          �venda com base na tabela SC9.                                ���
					������������������������������������������������������������������������������
					/*/
					
					a450Grava(1,.T.,.T.,.F.)
				EndIf
				(_cAliSC9)->(DbSkip())
			EndDo
			
			//Inicio - Caso tenha ocorrido com sucesso a gera��o do Pedido de Vendas, ir� iniciar a gera��o da Nota
			DbSelectArea("SC9")
			DbSetOrder(1)
			If DbSeek(xFilial("SC9")+SC5->C5_NUM)
				While SC9->(!EOF()) .And. SC9->C9_PEDIDO == SC5->C5_NUM
					DbSelectArea("SC6")
					DbSetOrder(1)
					DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM)
					
					_aTmpPV1 := {}
					
					aAdd( _aTmpPV1, SC9->C9_PEDIDO	)
					aAdd( _aTmpPV1, SC9->C9_ITEM 	)
					aAdd( _aTmpPV1, SC9->C9_SEQUEN	)
					aAdd( _aTmpPV1, SC9->C9_QTDLIB	)
					aAdd( _aTmpPV1, SC9->C9_PRCVEN	)
					aAdd( _aTmpPV1, SC9->C9_PRODUTO	)
					aAdd( _aTmpPV1, SF4->F4_ISS=="S")
					aAdd( _aTmpPV1, SC9->(RECNO())	)
					aAdd( _aTmpPV1, SC5->(RECNO())	)
					aAdd( _aTmpPV1, SC6->(RECNO())	)
					aAdd( _aTmpPV1, SE4->(RECNO(POSICIONE("SE4",1,xFilial("SE4")+"001"				,""))))
					aAdd( _aTmpPV1, SB1->(RECNO(POSICIONE("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO	,""))))
					aAdd( _aTmpPV1, SB2->(RECNO(POSICIONE("SB2",1,xFilial("SB2")+SC9->C9_PRODUTO	,""))))
					aAdd( _aTmpPV1, SF4->(RECNO(POSICIONE("SF4",1,xFilial("SF4")+SC6->C6_TES		,""))))
					aAdd( _aTmpPV1, SC9->C9_LOCAL	)
					aAdd( _aTmpPV1, 1				)
					aAdd( _aTmpPV1, SC9->C9_QTDLIB2	)
					
					aAdd( _aPVlNFs, aClone(_aTmpPV1))
					
					DbSelectArea("SC9")
					DbSkip()
				EndDo
				
				//Rotina utilizada para realizar a geracao da Nota
				_cNotaImp := MaPVlNFs(_aPVlNFs,_cMvSeri,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)
				
				_aPVlNFs := {}
				
				//�������������������������������������������������������Ŀ
				//�Caso a nota n�o seja gerado ir� chamar a rotina de erro�
				//���������������������������������������������������������
				//If Empty(AllTrim(_cNotaImp))
				SF2->(DbSetOrder(1))
				IF Empty(AllTrim(_cNotaImp)) .OR. !SF2->(Dbseek( xFilial("SF2")+_cNotaImp+_cMvSeri ))				
					
					//�����������������������������������������������������������Ŀ
					//�Chamando o Execauto de Altera��o e em seguida o de exclus�o�
					//�������������������������������������������������������������
					//�������������������������������Ŀ
					//�Alterando a quantidade liberada�
					//���������������������������������
					For _ni := 1 To Len(_aItmPd)
						_aItmPd[_ni][_nPosLb][2] := 0
						aAdd(_aItmPd[_ni],{"C6_NUM", _cPedExc, Nil})
					Next _ni
					
					//Ira alterar o pedido de vendas para poder realizar a exclusao
					aAdd ( _aCabPd , { "C5_NUM"    , _cPedExc      	, Nil} )
					lMsErroAuto := .F.
					MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,4)
					
					If !lMsErroAuto
						//Alterou o pedido de vendas com suceeso, ira realizar a exclusao
						lMsErroAuto := .F.
						MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,5)
						If !lMsErroAuto
							//Excluiu com sucesso o pedido de vendas
							_cErroLg += "  " + cEnt
							_cErroLg += " O Pedido: " + _cPedExc + " foi exclu�do com sucesso. "  + cEnt
							_cErroLg += " Favor verificar o pedido: "  + cEnt
							_cErroLg += " Pois ele teve que ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
							_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois no processo houve erro. " + cEnt
							_cErroLg += " " + cEnt
							MemoWrite(_cLogPd+"Fil_"+_cFilM0+" Ped_"+_cPedExc+".txt",_cErroLg)
						Else
							//Nao conseguiu excluir o pedido de vendas
							_aErro := GetAutoGRLog()
							For _ni := 1 To Len(_aErro)
								_cErroLg += _aErro[_ni] + cEnt
							Next _ni
							_cErroLg += "  " + cEnt
							_cErroLg += " O Pedido: " + _cPedExc + " n�o pode ser exclu�do. "  + cEnt
							_cErroLg += " Favor verificar o pedido: "  + cEnt
							_cErroLg += " pois ele deve ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
							_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois no processo houve erro. " + cEnt
							_cErroLg += " " + cEnt
							MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cErroLg )
						EndIF
					Else
						//Nao conseguiu alterar o pedido de vendas
						_aErro := GetAutoGRLog()
						For _ni := 1 To Len(_aErro)
							_cErroLg += _aErro[_ni] + cEnt
						Next _ni
						_cErroLg += "  " + cEnt
						_cErroLg += " O Pedido: " + SC9->C9_PEDIDO + " n�o pode ser alterado para prosseguir com a exclus�o. "  + cEnt
						_cErroLg += " Favor verificar o pedido: "  + cEnt
						_cErroLg += " pois ele deve ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
						_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois no processo houve erro. " + cEnt
						_cErroLg += " " + cEnt
						MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cErroLg )
					EndIf
				Else
				
					//Rafael Leite - 10/11/2015 - Inclus�o na Flag view para novo controle da rotina
					
					For _nr:=1 to Len(_aInsert)
					
						_cInsert := " INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) VALUES ('TT_I30_CONSIG_ORIG_GEN','D1_ITEM','"+_aInsert[_nr][1]+"','"+_aInsert[_nr][2]+"' ) "
						
						If TCSqlExec(_cInsert) < 0
						
							_cErroLg += "  " + cEnt
							_cErroLg += " N�o foi possivel gerar registro na Flag View na nota fiscal: " + SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA + ". "  + cEnt
							Conout(_cErroLg)
							MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Doc_" + SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA + ".txt" , _cErroLg )												
							U_GenSendMail(,,,"noreply@grupogen.com.br",cMail128+";rafael.leite@grupogen.com.br",oemtoansi("Protheus - Consigna��o intercompany"),oemtoansi(_cErroLg),,,.F.)
						Else
							Conout("GENA006 - Insert ok")
						Endif
                    Next _nr
				EndIf
			EndIf
		EndIf
		If Select(_cAliSC9) > 0
			dbSelectArea(_cAliSC9)
			(_cAliSC9)->(dbCloseArea())
		EndIf
	Else
		//Nao conseguiu gerar o Pedido de Vendas
		_aErro := GetAutoGRLog()
		For _ni := 1 To Len(_aErro)
			_cErroLg += _aErro[_ni] + cEnt
			CONOUT(_cErroLg)
		Next _ni
		MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraPedido.txt" , _cErroLg )
		Disarmtransaction()
	EndIf
Else
	_cNotaImp := ""
	_cMsg := "A Nota n�o foi gerada, pois a serie n�o esta preenchida corretamente." + cEnt
	_cMsg += "Favor revisar o parametro GEN_FAT003." + cEnt
	MemoWrite(_cLogPd+"Fil_"+_cFilM0+"_Serie.txt",_cMsg)
EndIf

RestArea(_aArea)

Return(_cNotaImp)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA006C  �Autor  �Angelo Henrique     � Data �  06/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para realizar a gera��o da nota de Entrada no GEN    ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA006C(_aCabDcEn,_aItmDcEn)

Local _aArea 			:= GetArea()
Local _aErro			:= {}
Local _cErroLg			:= ""
Local _cLogPd			:= GetMv("GEN_FAT007") //Cont�m o caminho que ser� gravado o log de erro
Local _cEmpM0           := AllTrim(SM0->M0_CODIGO)
Local _cFilM0			:= AllTrim(SM0->M0_CODFIL)
Local lRet				:= .T.
Local _ni

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

DbSelectArea("SA1")
DbSelectArea("SA2")

ConOut("GENA006 - Mata103")

MSExecAuto({|x,y,z|MATA103(x,y,z)},_aCabDcEn, _aItmDcEn,3)

If lMsErroAuto
	//Nao conseguiu gerar o Documento de Entrada
	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + cEnt
		CONOUT(_cErroLg)
	Next _ni
	MemoWrite ( _cLogPd + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraDocEntrada.txt" , _cErroLg )
	//Disarmtransaction()
	lRet := .F.
Else
	//Update para zerar estoque de terceiros
	_cQuery := "UPDATE " + RetSqlName("SB2") + " SET B2_QTNP = 0
	_cQuery += " WHERE B2_FILIAL = '" + xFilial("SB2") + "'
	_cQuery += " AND B2_COD IN (SELECT D1_COD FROM " + RetSqlName("SD1") + " SD1 WHERE SD1.D1_FILIAL = '" + xFilial("SD1") + "'
	_cQuery += " AND SD1.D1_DOC = '" + SD1->D1_DOC + "'
	_cQuery += " AND SD1.D1_SERIE = '" + SD1->D1_SERIE + "'
	_cQuery += " AND SD1.D1_FORNECE = '" + SD1->D1_FORNECE + "'
	_cQuery += " AND SD1.D1_LOJA = '" + SD1->D1_LOJA + "'
	_cQuery += " AND SD1.D_E_L_E_T_ = ' ')
	_cQuery += " AND B2_LOCAL IN (SELECT D1_LOCAL FROM " + RetSqlName("SD1") + " SD1 WHERE SD1.D1_FILIAL = '" + xFilial("SD1") + "'
	_cQuery += " AND SD1.D1_DOC = '" + SD1->D1_DOC + "'
	_cQuery += " AND SD1.D1_SERIE = '" + SD1->D1_SERIE + "'
	_cQuery += " AND SD1.D1_FORNECE = '" + SD1->D1_FORNECE + "'
	_cQuery += " AND SD1.D1_LOJA = '" + SD1->D1_LOJA + "'
	_cQuery += " AND SD1.D_E_L_E_T_ = ' ')
	_cQuery += " AND D_E_L_E_T_ = ' '
	
	If TCSQLEXEC(_cQuery) != 0
		
		//����������������������������������I
		//�Fun��o para alimentar Log de erro�
		//����������������������������������I
		_cErroLg := "N�o foi possivel zerar o saldo de terceiros no SB2" + cEnt
		MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraDocEntrada.txt" , _cErroLg )
	EndIf
	lRet := .T.
EndIf

RestArea(_aArea)

Return lRet


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GENA006D  �Autor  �Danilo Azevedo      � Data �  20/02/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para dar entrada automatica em uma NF de saida gera- ���
���          �da na empresa origem para o cliente GEN e que ainda nao foi ���
���          �carregada no GEN por alguma falha na rotina GENA006.        ���
�������������������������������������������������������������������������͹��
���Uso       �GEN - Estoque                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENA006D()

Local _aCabDcEn := {} //Vetor contendo o cabe�alho documento de entrada
Local _aItmDcEn := {} //Vetor contendo os itens do documento de entrada
Local _cMvTsDe 	//TES documento de entrada
Local _cLogPd	//Cont�m o caminho que ser� gravado o log de erro
Local _cAliQry

Prepare Environment Empresa "00" Filial "1022"

_cMvTsDe 	:= GetMv("GEN_FAT005") //TES documento de entrada
_cLogPd		:= GetMv("GEN_FAT007") //Cont�m o caminho que ser� gravado o log de erro
_cAliQry    := GetNextAlias()

cQry := "SELECT F2.*, D2.*, B1_PROC, B1_LOJPROC
cQry += " FROM "+RetSqlName("SF2")+" F2
cQry += " JOIN "+RetSqlName("SD2")+" D2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA
cQry += " JOIN "+RetSqlName("SB1")+" B1 ON D2_COD = B1_COD
cQry += " WHERE D2_FILIAL <> '1022'
cQry += " AND D2_COD IN
cQry += "   (SELECT COD
cQry += "   FROM
cQry += "     (SELECT *
cQry += "     FROM
cQry += "       (SELECT D2_COD COD,
cQry += "         D2_TIPO TIPO,
cQry += "         SUM(D2_QUANT) QTD
cQry += "       FROM "+RetSqlName("SD2")
cQry += "       WHERE D2_FILIAL <> '1022'
cQry += "       AND D2_CLIENTE   = '0005065'
cQry += "       AND D2_LOJA      = '01'
cQry += "       AND D_E_L_E_T_  = ' '
cQry += "       GROUP BY D2_COD,
cQry += "         D2_CLIENTE,
cQry += "         D2_LOJA,
cQry += "         D2_TIPO
cQry += "       )
cQry += "     UNION ALL
cQry += "     SELECT *
cQry += "     FROM
cQry += "       (SELECT D1_COD COD,
cQry += "         D1_TIPO TIPO,
cQry += "         SUM(D1_QUANT) *-1 QTD
cQry += "       FROM "+RetSqlName("SD1")
cQry += "       WHERE D1_FILIAL = '1022'
cQry += "       AND D1_FORNECE IN
cQry += "         (SELECT DISTINCT B1_PROC
cQry += "         FROM "+RetSqlName("SB1")
cQry += "         WHERE B1_PROC      <> ' '
cQry += "         AND D_E_L_E_T_ = ' '
cQry += "         )
cQry += "       AND D_E_L_E_T_ = ' '
cQry += "       GROUP BY D1_COD,
cQry += "         D1_FORNECE,
cQry += "         D1_LOJA,
cQry += "         D1_TIPO
cQry += "       )
cQry += "     )
cQry += "   GROUP BY COD,
cQry += "     TIPO
cQry += "   HAVING SUM(QTD)<>0
cQry += "   )
cQry += " AND F2.D_E_L_E_T_ = ' '
cQry += " AND D2.D_E_L_E_T_ = ' '
cQry += " AND B1.D_E_L_E_T_ = ' '
cQry += " ORDER BY D2_FILIAL, D2_DOC, D2_ITEM

If Select(_cAliQry) > 0
	dbSelectArea(_cAliQry)
	(_cAliQry)->(dbCloseArea())
EndIf

MemoWrite("GENA006D.SQL",cQry)

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQry), _cAliQry, .F., .T.)

Do While (_cAliQry)->(!EOF())
	
	aAdd(_aCabDcEn , {"F1_DOC"		,(_cAliQry)->F2_DOC			, Nil} )
	aadd(_aCabDcEn , {"F1_TIPO"   	,"N"						, Nil} )
	aadd(_aCabDcEn , {"F1_FORMUL" 	,"N"						, Nil} )
	aadd(_aCabDcEn , {"F1_SERIE"  	,(_cAliQry)->F2_SERIE		, Nil} )
	aadd(_aCabDcEn , {"F1_EMISSAO"	,StoD((_cAliQry)->F2_EMISSAO), Nil} )
	aadd(_aCabDcEn , {"F1_FORNECE"	,(_cAliQry)->B1_PROC		, Nil} )
	aadd(_aCabDcEn , {"F1_LOJA"   	,(_cAliQry)->B1_LOJPROC		, Nil} )
	aadd(_aCabDcEn , {"F1_ESPECIE"	,(_cAliQry)->F2_ESPECIE		, Nil} )
	aadd(_aCabDcEn , {"F1_COND"		,(_cAliQry)->F2_COND		, Nil} )
	
	cChave := (_cAliQry)->F2_FILIAL + (_cAliQry)->F2_DOC + (_cAliQry)->F2_SERIE + (_cAliQry)->F2_CLIENTE + (_cAliQry)->F2_LOJA
	
	Do While cChave = (_cAliQry)->F2_FILIAL + (_cAliQry)->F2_DOC + (_cAliQry)->F2_SERIE + (_cAliQry)->F2_CLIENTE + (_cAliQry)->F2_LOJA
		
		_alinhaDe := {}
		aAdd(_alinhaDe	,	{"D1_ITEM"		, (_cAliQry)->D2_ITEM		, Nil})
		aAdd(_alinhaDe	,	{"D1_COD"  		, (_cAliQry)->D2_COD		, Nil})
		aAdd(_alinhaDe	,	{"D1_UM"		, (_cAliQry)->D2_UM			, Nil})
		aAdd(_alinhaDe	,	{"D1_QUANT"		, (_cAliQry)->D2_QUANT		, Nil})
		aAdd(_alinhaDe	,	{"D1_VUNIT"		, (_cAliQry)->D2_PRCVEN		, Nil})
		aAdd(_alinhaDe	,	{"D1_TOTAL"		, (_cAliQry)->D2_TOTAL		, Nil})
		aAdd(_alinhaDe	,	{"D1_TES"		, _cMvTsDe					, Nil})
		aAdd(_alinhaDe	,	{"D1_LOCAL"		, (_cAliQry)->D2_LOCAL 		, Nil})
		
		aadd(_aItmDcEn,_alinhaDe)
		(_cAliQry)->(DbSkip())
		
	Enddo
	
	U_GENA006C(_aCabDcEn,_aItmDcEn) //EXECUTA ROTINA DESENVOLVIDA PREVIAMENTE
	_aCabDcEn := {}
	_aItmDcEn := {}
	
Enddo

Reset Environment

Return()

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �GENA006F    �Autor  �Cleuto Lima         � Data �  30/03/16   ���
���������������������������������������������������������������������������͹��
���Desc.     �                                                              ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       � Grupo Gen                                                    ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

User Function GENA006F(cNota,cSerie,_aInsert)

//���������������������������������������������������������������������Ŀ
//� Variaveis da Rotina                                                 �
//�����������������������������������������������������������������������
Local aRegSD2	:= {}
Local aRegSE1	:= {}
Local aRegSE2	:= {} 
Local _cLogPd	:= GetMv("GEN_FAT007") //Cont�m o caminho que ser� gravado o log de erro
Local _cEmpM0   := AllTrim(SM0->M0_CODIGO)
Local _cFilM0	:= AllTrim(SM0->M0_CODFIL)
Local _ni		:= 0
Local _cErroLg	:= "" 
Local cPedBkp	:= ""  
Local cLodPadr	:= "Ocorreu uma falha ao tentar gerar o documento de entrada na empresa destino devido a isso foi necess�rio excluir a nota fiscal e pedido da filial origem."
//Local _nPosLb	:= aScan(_aItmDcEn[1], { |x| Alltrim(x[1]) == "C6_QTDLIB" })
Local _nr

Private cCadastro	:= OemToAnsi("Exclus�o de Documento de Saida")  
Private l265auto	:= Nil
Private aCab		:= {}
Private aItens		:= {}
Private nAutoAdt	:= 3  

SF2->(DbSetOrder(1))
IF SF2->(DbSeek(xFilial("SF2")+cNota+cSerie)) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO

	SD2->(DbSetOrder(3))//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	SD2->(DbSeek(xFilial("SD2")+cNota+cSerie))
	cPedBkp	:= SD2->D2_PEDIDO
							
	If MaCanDelF2("SF2",SF2->(Recno()),@aRegSD2,@aRegSE1,@aRegSE2) .and. MA521VerSC6(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)
	
		//���������������������������������������������������������������������Ŀ
		//� Exclui documento fiscal                                             �
		//����������������������������������������������������������������������� 
		MaDelNFS(aRegSD2,aRegSE1,aRegSE2,.F.,.F.,.F.,.F.) 
	Else
		_cErroLg	:= cLodPadr+Chr(13)+Chr(10)+"N�o foi poss�vel excluir o documento de entrada "+cNota+"-"+cSerie
		MemoWrite ( _cLogPd + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " ExcluiDocSaida.txt" , _cErroLg )	
		Return .F.	
    EndIf
    
	If SF2->(DbSeek(xFilial("SF2")+cNota+cSerie))  
		_cErroLg	:= cLodPadr+Chr(13)+Chr(10)+"N�o foi poss�vel excluir o documento de entrada "+cNota+"-"+cSerie
		MemoWrite ( _cLogPd + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " ExcluiDocSaida.txt" , _cErroLg )	
		Return .F.
	EndIf

	dbSelectArea("SC9")
	SC9->(dbSetOrder(1))
	SC9->(dbSeek(xFilial("SC9")+cPedBkp ))
	While SC9->(!EOF()) .and. xFilial("SC9")+cPedBkp == (SC9->C9_FILIAL+C9_PEDIDO)
		a460Estorna(.F.,.T.)
		SC9->(dbSkip())
	Enddo                           
			
	aCab := {}                                           
	AADD( aCab, {"C5_NUM", 	   		SC5->C5_NUM, 			NIL }) 
	AADD( aCab, {"C5_TIPO", 		SC5->C5_TIPO,	 		NIL }) 
	AADD( aCab, {"C5_CLIENTE", 		SC5->C5_CLIENTE, 		NIL }) 
	AADD( aCab, {"C5_LOJACLI", 		SC5->C5_LOJACLI, 		NIL }) 
	AADD( aCab, {"C5_LOJAENT", 		SC5->C5_LOJAENT, 		NIL }) 
	AADD( aCab, {"C5_TIPOCLI", 		SC5->C5_TIPOCLI, 		NIL }) 
	AADD( aCab, {"C5_CONDPAG", 		SC5->C5_CONDPAG, 		NIL }) 
	AADD( aCab, {"C5_TABELA", 		SC5->C5_TABELA, 		NIL }) 
	AADD( aCab, {"C5_TRANSP", 		SC5->C5_TRANSP, 		NIL }) 
	AADD( aCab, {"C5_MOEDA", 		SC5->C5_MOEDA, 	 		NIL }) 
	AADD( aCab, {"C5_TIPLIB", 		SC5->C5_TIPLIB, 		NIL }) 
	AADD( aCab, {"C5_TPFRETE", 		SC5->C5_TPFRETE, 		NIL }) 
	AADD( aCab, {"C5_EMISSAO", 		SC5->C5_EMISSAO, 		NIL }) 
			                                                                       
	aItens := {}
	dbSelectArea("SC6")
	SC6->(dbSetOrder(1))   
	
	SC6->(Dbseek(xFilial("SC6")+cPedBkp))
	
	While SC6->(!EOF()) .and. SC6->(C6_FILIAL+C6_NUM) == xFilial("SC6")+SC5->C5_NUM  
		AADD( aItens, {	{"C6_FILIAL", 		SC6->C6_FILIAL,		NIL },;
						{"C6_ITEM", 		SC6->C6_ITEM, 		NIL },;
						{"C6_NUM",			SC6->C6_NUM, 		NIL },;
						{"C6_CLI",			SC6->C6_CLI, 		NIL },;
						{"C6_LOJA", 		SC6->C6_LOJA, 		NIL },;
						{"C6_PRODUTO",  	SC6->C6_PRODUTO, 	NIL },;
						{"C6_DESCRI", 		SC6->C6_DESCRI, 	NIL },;
						{"C6_QTDVEN",		SC6->C6_QTDVEN, 	NIL },;
						{"C6_PRUNIT",		SC6->C6_PRUNIT, 	NIL },;
						{"C6_PRCVEN",		SC6->C6_PRCVEN, 	NIL },;						
						{"C6_DESCONT",		SC6->C6_DESCONT,	NIL },;
						{"C6_VALDESC",		SC6->C6_VALDESC,	NIL },;
						{"C6_VALOR", 		SC6->C6_VALOR, 		NIL },;
						{"C6_TES", 			SC6->C6_TES, 		NIL },;
						{"C6_CF", 			SC6->C6_CF, 		NIL },;
						{"C6_UM", 			SC6->C6_UM, 		NIL },;
						{"C6_LOCAL",    	SC6->C6_LOCAL, 		NIL },;
						{"C6_QTDLIB",   	SC6->C6_QTDLIB, 	NIL },;
						{"C6_ENTREG",   	SC6->C6_ENTREG, 	NIL }})
		SC6->(dbSkip()) 
	Enddo
	
	aRatCTBPC 	:= {}  
	lMsErroAuto	:= .F.
	MSExecAuto({|x,y,z| MATA410(x,y,z)}, aCab, aItens, 5, Nil, Nil, SC5->C5_CLIENTE, SC5->C5_LOJACLI,aRatCTBPC, Nil  )

	If !lMsErroAuto
		//Excluiu com sucesso o pedido de vendas
		_cErroLg += cLodPadr+cEnt
		_cErroLg += "  " + cEnt
		_cErroLg += " O Pedido: " + cPedBkp + " foi exclu�do com sucesso. "  + cEnt
		MemoWrite(_cLogPd+"Fil_"+_cFilM0+" Ped_"+cPedBkp+".txt",_cErroLg)

		//Rafael Leite - 10/11/2015 - Inclus�o na Flag view para novo controle da rotina
		For _nr:=1 to Len(_aInsert)
		
			_cInsert := " DELETE TT_I11_FLAG_VIEW WHERE VIEW_NAME = 'TT_I30_CONSIG_ORIG_GEN' AND CHAVE = 'D1_ITEM' AND VALOR = '"+_aInsert[_nr][1]+"' AND FILIAL = '"+_aInsert[_nr][2]+"' AND TRIM(DATAHORAINCLUSAO) = '"+DtoC(DDataBase)+"' "
			Begin Transaction
				nExec := TCSqlExec(_cInsert)
			End Transaction
			
			If nExec < 0
			
				_cErroLg := "  " + cEnt
				_cErroLg += " N�o foi possivel deletar registro na Flag View na nota fiscal: " + _aInsert[_nr][1] + ". "  + cEnt
				Conout(_cErroLg)
				MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Doc_" + _aInsert[_nr][1] + ".txt" , _cErroLg )												
				U_GenSendMail(,,,"noreply@grupogen.com.br",cMail128+";rafael.leite@grupogen.com.br",oemtoansi("Protheus - Consigna��o intercompany"),oemtoansi(_cErroLg),,,.F.)
				
			Else
			
				Conout("GENA006 - Indelete ok")
				
			Endif
        Next _nr
        
                    		
	Else
		//Nao conseguiu excluir o pedido de vendas
		_aErro := GetAutoGRLog()
		For _ni := 1 To Len(_aErro)
			_cErroLg += _aErro[_ni] + cEnt
		Next _ni
		_cErroLg += cLodPadr+cEnt
		_cErroLg += "  " + cEnt
		_cErroLg += " O Pedido: " + cPedBkp + " n�o pode ser exclu�do. "  + cEnt
		_cErroLg += " Favor verificar o pedido: "  + cEnt
		_cErroLg += " pois ele deve ser exclu�do uma vez que o Documento de Sa�da n�o foi excluido. " + cEnt
		_cErroLg += " " + cEnt
		MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + cPedBkp + ".txt" , _cErroLg )
	EndIF
						
Else
    
	_cErroLg	:= "N�o foi poss�vel excluir o documento de saida "+cNota+"-"+cSerie
	MemoWrite ( _cLogPd + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " ExcluiDocSaida.txt" , _cErroLg )
		
EndIf

Return nil
