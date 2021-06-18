#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

#DEFINE cEnt Chr(13)+Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA046   �Autor  �Helimar Tavares     � Data �  21/03/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de Devolu��o de Ofertas                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA046()

Conout(Time()+ " " + "GENA046 - Inicio - Rotina de Devolu��o de Ofertas")
//Prepare Environment Empresa "00" Filial "1022"

RpcSetType(2)
lOpenSM0 := RpcSetEnv( "00" , "1022")

If lOpenSM0	                    
	If LockByName("GENA046",.T.,.T.,.T.)
		U_GENA046A()
		UnLockByName("GENA046",.T.,.T.,.T.)
	Else 
		Conout("GENA046 - n�o foi poss�vel iniciar a rotina pois a mesma j� est� sendo executada!")
	EndIf
	
	Conout(Time()+ " GENA046 - Fim - Rotina de Devolu��o de Ofertas")
	
	//Reset Environment
	RpcClearEnv()
EndIf

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA046A  �Autor  �Helimar Tavares     � Data �  21/03/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina respons�vel por fazer o filtro das Notas de Entradas ���
���          �de devolu��o de oferta para fazer a saida para e empresa    ���
���          �origem e entrada na mesma.                                  ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA046A()

Local _aArea 	:= GetArea()
Local _cQuery 	:= ""
Local _cAliQry	:= GetNextAlias()
Local _cAliQry1	:= GetNextAlias()
Local _cEmpCd 	:= ""
Local _cEmpFl 	:= ""
Local _cForn 	:= ""
Local _cLojFn  	:= ""
Local _aDir		:= {}
Local _aCabDcOr := {} //Vetor contendo o cabe�a'lho documento de entrada empresa Origem
Local _alinhaOr := {} //Vetor que recebe os itens do documento de entrada empresa Origem
Local _aItmDcOr := {} //Vetor contendo os itens do documento de entrada empresa Origem
Local _nQuant	:= 0
Local _aCabPv 	:= {} //Gera��o do cabe�alho Pedido de Vendas no GEN
Local _alinha	:= {} //Gera��o do Item do Pedido de Vendas no GEN
Local _aItmPv	:= {} //Recebe os itens do pedido de Vendas no GEN
Local _aFlgView := {}
Local _cCliPv 	:= ""
Local _cLjPv  	:= ""
Local _cCliGen 	:= ""
Local _cLojGen 	:= ""
Local _cTrpGen 	:= ""
Local _cTipGen 	:= ""
Local _cVenGen 	:= ""
Local _cTrpPv	:= ""
Local _cTipPv 	:= ""
Local _cVenPv 	:= ""
Local _cMsg		:= ""
Local _nContOr	:= 0
Local _cContC6	:= 0
Local _nQtdTot  := 0
Local _nValTot 	:= 0
Local _cNotaImp	:= ""
Local _oServer 	:= Nil
Local _cCGCOr	:= ""
Local _aArM0	:= {}
Local _lEmp		:= .T.
Local _nQdTtOr  := 0
Local _nVlTtOr  := 0
Local _cNtDvCon	:= ""
Local _cEmp		:= AllTrim(SM0->M0_CODIGO)
Local _cFil		:= AllTrim(SM0->M0_CODFIL)
Local _cForUp 	:= ""
Local _cLojUp 	:= ""
Local _cProd    := ""

Local _cMvCdPv 	:= GetMv("GEN_FAT106") //Condi��o de pagamento pedido de venda GEN
Local _cMvTbPr 	:= GetMv("GEN_FAT107") //Tabela de pre�o pedido de venda GEN
Local _cLogPd	:= GetMv("GEN_FAT095") //Caminho onde ser� gravado o log de erro
Local _cMvClDe	:= GetMv("GEN_FAT096") //Cliente que ser� utilizado para realizar as movimenta��es no GEN
Local _cMvLjDe  := GetMv("GEN_FAT097") //Loja que ser� utilizada para realizar as movimenta��es no GEN
Local _cFil		:= GetMv("GEN_FAT098") //Filial correta do GEN onde ser�o realizadas as movimenta��es de devolu��o de oferta
Local _cMvEspc 	:= GetMv("GEN_FAT099") //Especie utilizada na nota de entrada das empresas de Origem
Local _cMvCdDe	:= GetMv("GEN_FAT100") //Condi��o de pagamento utilizada na nota de entrada das empresas de Origem
Local _cMvSeri 	:= GetMv("GEN_FAT101") //S�rie utilizada nas notas de sa�da e entrada no GEN e empresas de Origem
Local _cTesCRMOr:= GetMv("GEN_FAT102") //TES utilizado na nota de entrada das empresas Origem, dev. oferta CRM
Local _cTesDAOr	:= GetMv("GEN_FAT103") //TES utilizado na nota de entrada das empresas Origem, dev. oferta DA
Local _cTesCRMPv:= GetMv("GEN_FAT104") //TES utilizado no Pedido de Vendas do GEN, dev. oferta CRM
Local _cTesDAPv	:= GetMv("GEN_FAT105") //TES utilizado no Pedido de Vendas do GEN, dev. oferta DA

Local _cServ 	:= GETMV("GEN_FAT027") //Ip do servidor para realizar as mudan�as de ambiente
Local _nPort  	:= GETMV("GEN_FAT028") //Porta para realizar as mudan�as de ambiente
Local _cAmb  	:= GETMV("GEN_FAT029") //Ambiente a ser utilizado para realizar as mudan�as de filial

Local lConsMes	:= GETMV("GEN_FAT121") == "S" // considera m�s atual no filtro de notas de devolu��o de oferta
Local nDiasMen	:= SuperGetMv("GEN_FAT148",.F.,7)

Local lPedido	:= .T.
Local cPedido	:= ""

Local nVldDesc	:= 0
Local nPerDesc	:= 0
Local nVldDesc	:= 0
Local _ni,_aDir
					
WFForceDir(_cLogPd)
WFForceDir(_cLogPd+DtoS(DDataBase)+"\")

//��������������������������Ŀ
//�Executar limpeza dos logs �
//����������������������������
_aDir := directory(Alltrim(_cLogPd)+"*")
For _ni:= 1 to Len(_aDir)
	fErase(Alltrim(_cLogPd)+_aDir[_ni][1])
Next _ni

conout(Time()+ " " + "GENA046A - Inicio - Verificando Itens da Nota de Entrada")

tcSqlExec("UPDATE "+RetSqlName("SB1")+" SET B1_DESC = REPLACE(B1_DESC,'|','/') WHERE B1_DESC LIKE '%|%'") //TROCA "|" POR "/" NA DESCRICAO DOS PRODUTOS PARA NAO GERAR ERRO NA ROTINA GRAVAARQ/LEARQ

//����������������������������������������������������������������������������������������Ŀ
//�Pegando Informacoes do GEN atraves dos parametros para ser utilizado no pedido de vendas�
//������������������������������������������������������������������������������������������
DbSelectArea("SA1")
DbSetORder(1)
If !DbSeek(xFilial("SA1")+PADR(AllTrim(_cMvClDe),TAMSX3("A1_COD")[1])+PADR(AllTrim(_cMvLjDe),TAMSX3("A1_LOJA")[1]))
	_cMsg := "N�o foi encontrado no sistema o cliente cadastrado nos parametros de Devolu��o de Oferta." + cEnt
	_cMsg += "Cliente: " + AllTrim(_cMvClDe) + " loja: " + AllTrim(_cMvLjDe) + cEnt
	_cMsg += "Favor verificar os parametros: GEN_FAT096 e GEN_FAT097" + cEnt
	conout(Time()+ " " + _cMsg)
	MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "Devolu��oOferta.txt" , _cMsg )
Else
	_cCliGen := SA1->A1_COD
	_cLojGen := SA1->A1_LOJA
	_cTrpGen := SA1->A1_TRANSP
	_cTipGen := SA1->A1_TIPO
	_cVenGen := SA1->A1_VEND
	
	DbSelectArea("SA2")
	DbSetOrder(3)
	If !DbSeek(xFilial("SA2")+SA1->A1_CGC)
		_cMsg := "N�o foi encontrado no sistema associa��o do Cliente com o Fornecedor atrav�s do CGC cadastrado nos parametros de devolu��o de oferta." + cEnt
		_cMsg += "Cliente: " + AllTrim(_cMvClDe) + " loja: " + AllTrim(_cMvLjDe) + cEnt
		_cMsg += "Favor verificar os parametros: GEN_FAT096 e GEN_FAT097" + cEnt
		conout(Time()+ " " + _cMsg)
		MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "Devolu��oOferta.txt" , _cMsg )
	Else
		
		_cFnGen := SA2->A2_COD
		_cLjGen := SA2->A2_LOJA
		
		//�����������������������������������������������������������������������������Ŀ
		//�Pesquisa doc. entrada dev. oferta ainda n�o devolvidos para a empresa oritem �
		//�������������������������������������������������������������������������������
		
		_cQuery := "SELECT D1_DOC, D1_SERIE, D1_COD, B1_PROC, B1_LOJPROC, B1_DESC, B1_UM, B1_LOCPAD, B1_MSBLQL, D1_QUANT, D1_TES,D1_FORNECE
		_cQuery += " FROM " + RetSqlName("SD1") + " SD1
		_cQuery += " JOIN " + RetSqlName("SB1") + " SB1 ON D1_COD = B1_COD
		_cQuery += " WHERE D1_FILIAL   = '" + _cFil + "'
		_cQuery += " AND D1_TES       IN ('" + _cTesCRMOr + "','" + _cTesDAOr + "')"
		_cQuery += " AND B1_FILIAL     = '"+xFilial("SB1")+"'
		_cQuery += " AND SD1.D_E_L_E_T_ = ' '
		_cQuery += " AND SD1.D1_DTDIGIT BETWEEN '20170301' AND '"+DtoS( DDataBase-nDiasMen )+"' "
		//_cQuery += " AND SD1.D1_DTDIGIT >= '20170101' "
		//_cQuery += " AND SD1.D1_DTDIGIT <= '20170228' "
		
		//_cQuery += " AND SD1.D1_DTDIGIT <= '"+DtoS(DDataBase-7)+"' "
		
		//If !lConsMes
		//	_cQuery += " AND SD1.D1_DTDIGIT <= '"+ DtoS( FIRSTDATE(dDataBase)-1 ) +"' "
		//EndIf
		
		_cQuery += " AND SB1.D_E_L_E_T_ = ' '
		_cQuery += " AND NOT EXISTS (SELECT 1
		_cQuery += "                 FROM TT_I11_FLAG_VIEW
		_cQuery += "                 WHERE VIEW_NAME = 'SD1000'
		_cQuery += "                 AND CHAVE = 'D1_DOC||D1_SERIE||D1_COD||D1_FORNECE'
		_cQuery += "                 AND TRIM(D1_DOC)||TRIM(D1_SERIE)||TRIM(D1_COD)||TRIM(D1_FORNECE) = TT_I11_FLAG_VIEW.VALOR)
		_cQuery += " ORDER BY B1_PROC, B1_LOJPROC, D1_TES, D1_COD, D1_DOC, D1_SERIE
		
		If Select(_cAliQry) > 0
			dbSelectArea(_cAliQry)
			(_cAliQry)->(dbCloseArea())
		EndIf
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry, .F., .T.)
		
		While (_cAliQry)->(!EOF())
		
			If AllTrim((_cAliQry)->B1_PROC) <> _cForn .or. AllTrim((_cAliQry)->B1_LOJPROC) <> _cLojFn
				//����������������������������������������������������������������������������������������������������
				//�Ponterando no Fornecedor para realizar a busca na SM0 (Cadastro de Empresas), realizando assim    �
				//�uma nova conex�o na empresa em que ser� gerado a Nota de entrada e Pedido de Vendas/Nota de Sa�da �
				//����������������������������������������������������������������������������������������������������
				DbSelectArea("SA2")
				DbSetOrder(1)
				If !DbSeek(xFilial("SA2")+(_cAliQry)->B1_PROC+(_cAliQry)->B1_LOJPROC)
					_cMsg := "N�o foi encontrado no sistema fornecedor com o c�digo: " + (_cAliQry)->B1_PROC + " e loja: " + (_cAliQry)->B1_LOJPROC  + ", vinculados ao produto: " + (_cAliQry)->D1_COD
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil "+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim((_cAliQry)->D1_COD) + ".txt" , _cMsg )
					(_cAliQry)->(DbSkip())
					Loop
				EndIf
				
				_cForn 	:= AllTrim(SA2->A2_COD)
				_cLojFn := AllTrim(SA2->A2_LOJA)
				_cCGCOr := AllTrim(SA2->A2_CGC)
				
				DbSelectArea("SA1")
				DbSetOrder(3)
				If !DbSeek(xFilial("SA1")+_cCGCOr)
					_cMsg := "N�o foi encontrado no sistema Cliente com o CNPJ: " + _cCGCOr
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim((_cAliQry)->D1_COD) + ".txt" , _cMsg )
					While AllTrim((_cAliQry)->B1_PROC) = _cForn .and. AllTrim((_cAliQry)->B1_LOJPROC) = _cLojFn
						(_cAliQry)->(DbSkip())
					EndDo
					Loop
				EndIf
				
				_cCliPv 	:= SA1->A1_COD
				_cLjPv  	:= SA1->A1_LOJA
				_cTrpPv	:= SA1->A1_TRANSP
				_cTipPv 	:= SA1->A1_TIPO
				_cVenPv 	:= SA1->A1_VEND
				
				//���������������������������������������������������������������������Ŀ
				//�Ponterando na SM0 para pegar o CNPJ correto e realzar o ponteramento �
				//�na empresa que ser� gravada a Nota                                   �
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
				
				//��������������������������������������������������Ŀ
				//�Se achar a empresa correta realiza a movimenta��o �
				//����������������������������������������������������
				If !_lEmp
					_cMsg := "N�o foi encontrado no sistema empresa (SM0) com o CNPJ: " + SA2->A2_CGC
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + ".txt" , _cMsg )
					(_cAliQry)->(DbSkip())
					Loop
				EndIf
			EndIf
				
			_aCabPv		:= {}
			_aFlgView	:= {}
			
			//������������������������������������������������������Ŀ
			//�Array contendo o cabe�alho do pedido de vendas no GEN �
			//��������������������������������������������������������
			aAdd ( _aCabPv , { "C5_TIPO"    , "N"     	, Nil} )
			aAdd ( _aCabPv , { "C5_CLIENTE" , _cCliPv  	, Nil} )
			aAdd ( _aCabPv , { "C5_LOJACLI" , _cLjPv  	, Nil} )
			aAdd ( _aCabPv , { "C5_CLIENT"  , _cCliPv 	, Nil} )
			aAdd ( _aCabPv , { "C5_LOJAENT" , _cLjPv	, Nil} )
			aAdd ( _aCabPv , { "C5_TRANSP"  , ''		, Nil} )
			aAdd ( _aCabPv , { "C5_TIPOCLI" , _cTipPv 	, Nil} )
			aAdd ( _aCabPv , { "C5_VEND1" 	, '' 		, Nil} )
			aAdd ( _aCabPv , { "C5_CONDPAG" , _cMvCdPv	, Nil} )
//			aAdd ( _aCabPv , { "C5_TABELA"  , _cMvTbPr	, Nil} )
			aAdd ( _aCabPv , { "C5_EMISSAO" , dDatabase	, Nil} )
			aAdd ( _aCabPv , { "C5_MOEDA" 	, 1			, Nil} )
			aAdd ( _aCabPv , { "C5_TPLIB" 	, "2"		, Nil} )
			
			//������������������������������������������������������������Ŀ
			//�Array contendo o cabe�alho da nota de entrada para a Origem �
			//��������������������������������������������������������������
			
			_aCabDcOr := {} //Vetor contendo o cabe�alho documento de entrada empresa Origem
			_aItmDcOr := {} //Vetor contendo os itens do documento de entrada empresa Origem
			
			aadd(_aCabDcOr , {"F1_TIPO"   	,"N"		, Nil} )
			aadd(_aCabDcOr , {"F1_FORMUL" 	,"N"		, Nil} )
			aadd(_aCabDcOr , {"F1_SERIE"  	,_cMvSeri	, Nil} )
			aadd(_aCabDcOr , {"F1_EMISSAO"	,dDataBase	, Nil} )
			aadd(_aCabDcOr , {"F1_FORNECE"	,PADR(AllTrim(_cFnGen),TAMSX3("F1_FORNECE")[1])	, Nil} )
			aadd(_aCabDcOr , {"F1_LOJA"   	,_cLjGen	, Nil} )
			aadd(_aCabDcOr , {"F1_ESPECIE"	,_cMvEspc	, Nil} )
			aadd(_aCabDcOr , {"F1_COND"		,_cMvCdDe	, Nil} )
			
			_nContOr := 1
			_cContC6 := STRZERO(1,TAMSX3("C6_ITEM")[1])
			
			_aItmPv := {}
			_alinha := {}
			
			_cForUp	:= ""
			_cLojUp := ""
			
			_cTesOr  := (_cAliQry)->D1_TES
			_nItMax := 1
			
			SB2->(DbsetOrder(1))
			
			While AllTrim((_cAliQry)->B1_PROC) == _cForn .And. AllTrim((_cAliQry)->B1_LOJPROC) == _cLojFn .and. AllTrim((_cAliQry)->D1_TES )== _cTesOr .AND. _nItMax < 100 .and. (_cAliQry)->(!EOF())

				_nItMax++
				
				_nQuant := 0
				_cForUp := AllTrim((_cAliQry)->B1_PROC)
				_cLojUp := AllTrim((_cAliQry)->B1_LOJPROC)
				
				//�����������������������������������������������������Ŀ
				//�Validando a quantidade correta a ser usada nas notas �
				//�������������������������������������������������������
				
	            _cProd   := (_cAliQry)->D1_COD
	            _cDscPro := (_cAliQry)->B1_DESC
				
				//PRODUTOS BLQUEADOS
				If (_cAliQry)->B1_MSBLQL == '1'
					_cMsg := "Produto bloqueado (B1_MSBLQL) n�o ser� considerado na devolu��o: " + Alltrim(_cProd)
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod Blq "  + AllTrim(_cProd) + ".txt" , _cMsg )
					(_cAliQry)->(DbSkip())
					Loop
				Endif
				
				 _aEstoque := CalcEst(AllTrim(_cProd),"01",DDataBase)               
				
				If !SB2->(DbSeek( xFilial("SB2")+padr(_cProd,TAMSX3("B2_COD")[1])+"01" ))// .OR. _aEstoque[1] <= 0// .AND. SB2->B2_QATU < _nQuant
					_cMsg := "Sem saldo no armazem 01, n�o ser� considerado na devolu��o: " + Alltrim(_cProd)
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Saldo Prod "  + AllTrim(_cProd) + ".txt" , _cMsg )
					(_cAliQry)->(DbSkip())
					Loop
				EndIf
				
				//����������������������������������Ŀ
				//�Pegando o �ltimo custo do produto �
				//������������������������������������
			
				_cQuery := " SELECT B9_COD, B9_CM1
				_cQuery += " FROM " + RetSqlName("SB9")+ " SB9"
				_cQuery += " WHERE D_E_L_E_T_ = ' '
				_cQuery += " AND B9_COD = '" + _cProd + "'
				_cQuery += " AND B9_FILIAL = '" + _cEmpFl + "'
				_cQuery += " AND B9_LOCAL = '01'
				_cQuery += " AND B9_DATA IN (SELECT MAX(B9_DATA)
				_cQuery += "			     FROM " + RetSqlName("SB9") + " B "
				_cQuery += "                 WHERE B.D_E_L_E_T_ = ' '
				_cQuery += "                 AND B.B9_FILIAL = '" + _cEmpFl + "'
				_cQuery += "                 AND B.B9_COD = SB9.B9_COD
				_cQuery += "                 AND B.B9_CM1 > 0
				_cQuery += "                 AND B.B9_LOCAL = '01')
				
				If Select(_cAliQry1) > 0
					dbSelectArea(_cAliQry1)
					(_cAliQry1)->(dbCloseArea())
				EndIf
				
				dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry1, .F., .T.)
				
				If (_cAliQry1)->(EOF()) .or. (_cAliQry1)->B9_CM1 <= 0
					//������������������������������������������������������������Ŀ
					//�Validando se a tabela de pre�o possui o produto selecionado �
					//��������������������������������������������������������������
					DbSelectArea("DA1")
					DbSetOrder(1)
					If !DbSeek(xFilial("DA1")+_cMvTbPr+_cProd)
						//����������������������������������Ŀ
						//�Fun��o para alimentar Log de erro �
						//������������������������������������
						_cMsg := "N�o foi encontrado no sistema tabela de pre�o/produto com os c�digos: " + AllTrim(_cMvTbPr) + " / " + AllTrim(_cProd)
						conout(Time()+ " " + _cMsg)
						MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim(_cProd) + ".txt" , _cMsg )
						(_cAliQry)->(DbSkip())
						Loop                                 
					Else
						_nCusto := DA1->DA1_PRCVEN * 0.25
					EndIf
				Else
					_nCusto := (_cAliQry1)->B9_CM1
				EndIf

	           If _nCusto > 0 .AND. _nCusto < 0.01
	           	_nCusto	:= 0.01
	           EndIF

				_nCusto	:= Round(_nCusto,2)
				
				If _nCusto <= 0
					_cMsg := "Produto com custo e pre�co de venda zero (0), n�o ser� considerado na devolu��o: " + Alltrim(_cProd)
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prc_prod_"  + AllTrim(_cProd) + ".txt" , _cMsg )
					(_cAliQry)->(DbSkip())
					Loop
				EndIf
				
				If Select(_cAliQry1) > 0
					dbSelectArea(_cAliQry1)
					(_cAliQry1)->(dbCloseArea())
				EndIf
			    			
				While _cProd == (_cAliQry)->D1_COD  .and. AllTrim((_cAliQry)->D1_TES ) == _cTesOr .and. !(_cAliQry)->(EOF())
					/*
					If _aEstoque[1] < ( _nQuant + (_cAliQry)->D1_QUANT ) .OR. SB2->B2_QATU < (_nQuant + (_cAliQry)->D1_QUANT)
						_cMsg := "saldo insuficiente no armazem 01 para atender o documento"+(_cAliQry)->D1_DOC+"-"+(_cAliQry)->D1_SERIE+", n�o ser� considerado na devolu��o: " + Alltrim(_cProd)
						conout(Time()+ " " + _cMsg)
						MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Saldo Prod "  + AllTrim(_cProd) + ".txt" , _cMsg )
						(_cAliQry)->(DbSkip())
						Loop
					EndIf
					*/
					aAdd(_aFlgView,{(_cAliQry)->D1_DOC, (_cAliQry)->D1_SERIE, _cProd,(_cAliQry)->D1_FORNECE})
					
					_nQuant := _nQuant + (_cAliQry)->D1_QUANT
					(_cAliQry)->(DbSkip())
				End Do
				
				If _nQuant == 0
					//_cAliQry)->(DbSkip()) n�o precisa do DBSkip pois o loop do registro j� foi feito na valida��o anterior
					Loop
				EndIf
					
				_nVUnit := 0

				If _cTesOr = _cTesCRMOr
					_cTesPv := _cTesCRMPv
				Else
					_cTesPv := _cTesDAPv
				EndIf

				DbSelectArea("DA1")
				DbSetOrder(1)
				If DbSeek(xFilial("DA1")+_cMvTbPr+_cProd)
					nPrunit		:= DA1->DA1_PRCVEN
					nPerDesc	:= Round((1-(_nCusto/DA1->DA1_PRCVEN))*100,2)
					nVldDesc	:= Round((DA1->DA1_PRCVEN * _nQuant)-(_nQuant * _nCusto),2)
				Else
					nVldDesc	:= 0
					nPerDesc	:= 0
					nVldDesc	:= _nCusto
				EndIf	

				
				//�����������������������������������������������Ŀ
				//�Array contendo a linha do pedido de vendas GEN �
				//�������������������������������������������������
				aAdd ( _alinha	, 	{ "C6_ITEM"    	, _cContC6			, Nil})
				aAdd ( _alinha	, 	{ "C6_PRODUTO" 	, _cProd		 	, Nil})
				aAdd ( _alinha 	, 	{ "C6_DESCRI"  	, _cDscPro		  	, Nil})
				aAdd ( _alinha 	, 	{ "C6_PRUNIT "  , nPrunit			, Nil})				
				aAdd ( _alinha 	, 	{ "C6_QTDVEN"  	, _nQuant			, Nil})
				aAdd ( _alinha 	, 	{ "C6_PRCVEN"  	, _nCusto			, Nil})
				aAdd ( _alinha 	, 	{ "C6_VALOR"   	, Round(_nQuant * _nCusto,2)	, Nil})
				aAdd ( _alinha 	, 	{ "C6_QTDLIB"  	, _nQuant			, Nil})
				aAdd ( _alinha 	, 	{ "C6_TES"     	, _cTesPv 			, Nil})
				aAdd ( _alinha 	, 	{ "C6_LOCAL"   	, "01"   			, Nil})

				aAdd ( _alinha  , 	{ "C6_DESCONT"  , nPerDesc			, NIL} )
				aAdd ( _alinha  ,	{ "C6_VALDESC"  , nVldDesc			, NIL} )
								
				aAdd ( _alinha 	, 	{ "C6_ENTREG"	, dDataBase			, Nil})

										
				aAdd(_aItmPv, _alinha)
				_alinha := {}
				
				//���������������������������������������������������������������Ŀ
				//�Array contendo os itens do Documento de Entrada empresa Origem �
				//�����������������������������������������������������������������
				aAdd(_alinhaOr	,	{"D1_ITEM"		, _cContC6			, Nil})
				aAdd(_alinhaOr	,	{"D1_COD"  		, _cProd			, Nil})
				aAdd(_alinhaOr	,	{"D1_QUANT"		, _nQuant			, Nil})
				aAdd(_alinhaOr	,	{"D1_VUNIT"		, _nCusto			, Nil})
				aAdd(_alinhaOr	,	{"D1_TOTAL"		, Round(_nQuant * _nCusto,2)	, Nil})
				aAdd(_alinhaOr	,	{"D1_TES"		, _cTesOr			, Nil})
				aAdd(_alinhaOr	,	{"D1_LOCAL"		, "01"				, Nil})
				
				aadd(_aItmDcOr,_alinhaOr)
				_alinhaOr := {}
				_cContC6 := Soma1(_cContC6)
				
				//����������������������������������������������������������������������������Ŀ
				//�Calcular oos campos customizados de quantidade e valor total empresa Origem �
				//������������������������������������������������������������������������������
				_nQdTtOr += _nQuant
				_nVlTtOr += (_nQuant * _nCusto)
				
				_nContOr ++
				
				//����������������������������������������������������������������Ŀ
				//�Calcular os campos customizados de quantidade e valor total GEN �
				//������������������������������������������������������������������
				_nQtdTot += _nQuant
				_nValTot += (_nQuant * _nCusto)
			EndDo
			
			If Len(_aItmPv) > 0
				//����������������������������������������������������������������������������Ŀ
				//�Alimentando o cabe�alho do Pedido de Vendas com as informa��es customizadas �
				//������������������������������������������������������������������������������
				aAdd (_aCabPv, {"C5_XQTDTOT"	, _nQtdTot  , Nil})
				aAdd (_aCabPv, {"C5_XVALTOT"	, _nValTot	, Nil})
				
				//Zerando as Vari�veis
				_nQtdTot := 0
				_nValTot := 0
				_nQdTtOr := 0
				_nVlTtOr := 0
				
				//Realizando a gera��o da Nota de Sa�da para devolu��o de Consigna��o
				//na empresa Matriz (GEN)
				lPedido	:= .T.
				cPedido	:= ""
				_cNtDvCon := U_GENA046B(_aCabPv,_aItmPv,@lPedido,@cPedido)

				If lPedido
					//������������������������������������������������������������Ŀ
					//�Grava na view 'TT_I11_FLAG_VIEW' documento, s�rie e produto �
					//��������������������������������������������������������������
					
					For _ni := 1 To Len(_aFlgView)
						cQueryINS := " INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) VALUES ('SD1000','D1_DOC||D1_SERIE||D1_COD||D1_FORNECE','"+ALLTRIM(_aFlgView[_ni][1])+ALLTRIM(_aFlgView[_ni][2])+ALLTRIM(_aFlgView[_ni][3])+ALLTRIM(_aFlgView[_ni][4])+"','"+_cFil+"')"
						TCSqlExec(cQueryINS)
						cQueryINS := " INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) VALUES ('SD1XSC5','D1_DOC||D1_SERIE||D1_COD||D1_FORNECE||C5_NUM','"+ALLTRIM(_aFlgView[_ni][1])+ALLTRIM(_aFlgView[_ni][2])+ALLTRIM(_aFlgView[_ni][3])+ALLTRIM(_aFlgView[_ni][4])+cPedido+"','"+_cFil+"')"						
						TCSqlExec(cQueryINS)
					Next _ni				
				EndIf
				
				If !Empty(_cNtDvCon)
					
					//������������������������������������������������������������������Ŀ
					//�Realizando a nova conex�o para entrar na empresa e filial correta �
					//��������������������������������������������������������������������
					If ValType(_oServer) == "O"
						//Fecha a Conexao com o Servidor
						RESET ENVIRONMENT IN SERVER _oServer
						CLOSE RPCCONN _oServer
						_oServer := Nil
					EndIf
					
					conout(Time()+ " " + "GENA046 - In�cio do RPC para logar na empresa origem Nota de Entrada")
					conout(Time()+ " " + "GENA046 - Empresa: " + _cEmpCd + " Filial: " + _cEmpFl)
					
					_cTemp1 := U_GravArq1(_aItmPv)
					_cTemp2 := U_GravArq1(_aItmDcOr)
					
					CREATE RPCCONN _oServer ON  SERVER _cServ 			;   //IP do servidor
					PORT  _nPort           								;   //Porta de conex�o do servidor
					ENVIRONMENT _cAmb       							;   //Ambiente do servidor
					EMPRESA _cEmpCd          							;   //Empresa de conex�o
					FILIAL  _cEmpFl          							;   //Filial de conex�o
					TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que ser�o abertas
					MODULO  "SIGACOM"     		          					//M�dulo de conex�o
					
					If ValType(_oServer) == "O"
						_oServer:CallProc("RPCSetType", 2)
						_cNotaImp := ""
						_cNotaImp := _oServer:CallProc("U_GENA046C",_aCabPv,_cTemp1,_aCabDcOr,_cTemp2,_cNtDvCon,dDatabase)
						//������������������������������������������������������������������Ŀ
						//�Realizando a nova conex�o para entrar na empresa e filial correta �
						//��������������������������������������������������������������������
						//Fecha a Conexao com o Servidor
						RESET ENVIRONMENT IN SERVER _oServer
						CLOSE RPCCONN _oServer
						_oServer := Nil
						
						If Empty(_cNotaImp)
							_cMsg := "Erro de execauto MATA103 ao gerar documento de entrada para nota fiscal: " + Alltrim(_cNtDvCon)+" para filial "+_cEmpFl
							conout(Time()+ " " + _cMsg)
							MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_gera_documento_entrada_"  + AllTrim(_cNtDvCon) + ".txt" , _cMsg )							
						EndIf
						
					Else
						conout(Time()+ " " + "GENA046 - N�o foi poss�vel logar. Retorno para empresa origem n�o executado.")
					EndIf
					
				EndIf
			EndIf
		EndDo
	Endif
EndIf

If Select(_cAliQry) > 0
	dbSelectArea(_cAliQry)
	(_cAliQry)->(dbCloseArea())
EndIf

conout(Time()+ " " + "GENA046A - Fim - Verificando Itens da Nota de Entrada")
RestArea(_aArea)

Return()


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA046B  �Autor  �Helimar Tavares     � Data �  21/03/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina respons�vel por gerar a Nota Fiscal de Sa�da para    ���
���          �devolu��o de Oferta                                         ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA046B(_aCabPv,_aItmPv,lPedido,cPedido)

Local _aArea 			:= GetArea()
Local _cEmp				:= AllTrim(SM0->M0_CODIGO)
Local _cFil				:= AllTrim(SM0->M0_CODFIL)
Local _cQuery			:= ""
Local _cAliSC9			:= GetNextAlias()
Local _aTmpPV1 			:= {}
Local _aPVlNFs			:= {}
Local _cNotaImp			:= ""
Local _cPedExc			:= ""
Local _cMsg				:= ""
Local _aErro			:= {}
Local _cErroLg			:= ""
Local _nPosLb			:= aScan(_aItmPv[1], { |x| Alltrim(x[1]) == "C6_QTDLIB" })
Local _cLogPd			:= GetMv("GEN_FAT095") //Cont�m o caminho que ser� gravado o log de erro
Local _cMvSeri 			:= GetMv("GEN_FAT101") //SERIE nota de sa�da
Local _cMvEsp			:= GetMv("MV_ESPECIE") //Contem tipos de documentos fiscais utilizados na emissao de notas fiscais
Local _aPosEsp 			:= {}
Local _nMvEsp 			:= 0
Local _lEspec			:= .F.
Local _ni

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

//�����������������������������������������������������������Ŀ
//�Ponteramento nas tabelas para n�o ocorrer erro no execauto �
//�������������������������������������������������������������

DbSelectArea("SA1")
DbSelectArea("SA2")

DbSelectArea("SC5")
DbSetOrder(1)

conout(Time()+ " " + "GENA046B - Rotina para execu��o do Execauto de Gera��o do Pedido de Vendas e de Gera��o do Documento de Sa�da, empresa GEN")

Pergunte("MTA440",.F.)
MV_PAR02	:= 2
lLiber	:= .F.
	
lMsErroAuto := .F.
MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,3)

If !lMsErroAuto
	cPedido	:= SC5->C5_NUM
	lPedido	:= .T.
	
	conout(Time()+ " " + "GENA046B - Gerou com sucesso o pedido, ir� ver se existe a necessidade de desbloquear por cr�dito no GEN")
	
	//��������������������������������������������������������������������������������������Ŀ
	//� Inicio Rotina para desbloquear cr�dito para que o pedido seja faturado sem problemas �
	//����������������������������������������������������������������������������������������
	If Select("VLD_SC9") > 0
		VLD_SC9->(DbCloseArea())
	EndIf
	
	Beginsql Alias "VLD_SC9"
		SELECT * FROM %Table:SC6% SC6
		WHERE C6_FILIAL = %Exp:SC5->C5_FILIAL%
		AND C6_NUM = %Exp:SC5->C5_NUM%
		AND SC6.%NotDel%
		AND C6_QTDVEN <> (
		  SELECT SUM(C9_QTDLIB) FROM %Table:SC9% SC9
		  WHERE C9_FILIAL = C6_FILIAL
		  AND C9_PEDIDO = C6_NUM
		  AND C9_PRODUTO = C6_PRODUTO
		  AND C9_ITEM = C6_ITEM
		  AND SC9.%NotDel%
		)
	EndSql
    
	//��������������������������������������������������������Ŀ
	//�se a quantidade liberada n�o for a mesma que a do pedido�
	//�eu estorno tudo e for�o a libera��o integral.           �
	//����������������������������������������������������������
    If VLD_SC9->(!EOF())    	
		SC9->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
		While SC9->(!Eof()) .and. SC9->(C9_FILIAL+C9_PEDIDO) == SC5->C5_FILIAL+SC5->C5_NUM
			SC9->(a460Estorna())
			SC9->(DbSkip())
		Enddo    	    	
		
		DbSelectArea("SC9")
		DbSetOrder(1)
		If !DbSeek(xFilial("SC9") + SC5->C5_NUM)
			RecLock("SC5",.F.)
			SC5->C5_LIBEROK := "S"  
			SC5->(msUnlock())

			SC6->(DbSetOrder(1)) 
			SC6->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
			While SC6->(!EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM

				/*������������������������������������������������������������������������Ŀ��
				���Funcao    �MaLibDoFat� Autor �Eduardo Riera          � Data �09.03.99 ���
				�������������������������������������������������������������������������Ĵ��
				���Descri+.o �Liberacao dos Itens de Pedido de Venda                      ���
				�������������������������������������������������������������������������Ĵ��
				���Retorno   �ExpN1: Quantidade Liberada                                  ���
				�������������������������������������������������������������������������Ĵ��
				���Transacao �Nao possui controle de Transacao a rotina chamadora deve    ���
				���          �controlar a Transacao e os Locks                            ���
				�������������������������������������������������������������������������Ĵ��
				���Parametros�ExpN1: Registro do SC6                                      ���
				���          �ExpN2: Quantidade a Liberar                                 ���
				���          �ExpL3: Bloqueio de Credito                                  ���
				���          �ExpL4: Bloqueio de Estoque                                  ���
				���          �ExpL5: Avaliacao de Credito                                 ���
				���          �ExpL6: Avaliacao de Estoque                                 ���
				���          �ExpL7: Permite Liberacao Parcial                            ���
				���          �ExpL8: Tranfere Locais automaticamente                      ���
				���          �ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ���
				���          �       apenas avalia ).                                    ���
				���          �ExpbA: CodBlock a ser avaliado na gravacao do SC9           ���
				���          �ExpAB: Array com Empenhos previamente escolhidos            ���
				���          �       (impede selecao dos empenhos pelas rotinas)          ���
				���          �ExpLC: Indica se apenas esta trocando lotes do SC9          ���
				���          �ExpND: Valor a ser adicionado ao limite de credito          ���
				���          �ExpNE: Quantidade a Liberar - segunda UM                    ���
				*/
                                   					
				RecLock("SC6",.F.)
				SC6->C6_QTDLIB := MaLibDoFat(SC6->(Recno()),SC6->C6_QTDVEN,.F.,.F.,.F.,.F.,.F.)
				SC6->(msUnlock()) 

				SC6->(DbSkip())
			EndDo						
		EndIF		
    EndIf
    
	VLD_SC9->(DbCloseArea())

			
	DbSelectArea("SC9")
	DbSetOrder(1)
	If DbSeek(xFilial("SC9") + SC5->C5_NUM)
		
		bValid := {|| .T.}
		
		_cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_BLCRED,R_E_C_N_O_ SC9RECNO "
		_cQuery += "FROM "+RetSqlName("SC9")+" SC9 "
		_cQuery += "WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND "
		_cQuery += "SC9.C9_PEDIDO = '"+SC5->C5_NUM+"' AND "
		_cQuery += "(SC9.C9_BLEST <> '  ' OR "
		_cQuery += "SC9.C9_BLCRED <> '  ' ) AND "
		_cQuery += "SC9.C9_BLCRED NOT IN('10','09') AND "
		_cQuery += "SC9.C9_BLEST <> '10' AND "
		_cQuery += "SC9.D_E_L_E_T_ = ' ' "
		
		If Select(_cAliSC9) > 0
			dbSelectArea(_cAliSC9)
			(_cAliSC9)->(dbCloseArea())
		EndIf
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliSC9,.T.,.T.)
		conout(Time()+ " " + "GENA046B - Ira varrer a SC9 para realizar o desbloqueio por cr�dito no GEN")

		Pergunte("MTA440",.F.)
		MV_PAR02	:= 2
		lLiber	:= .F.
		
		While ( (_cAliSC9)->(!Eof()) .And. (_cAliSC9)->C9_FILIAL == xFilial("SC9") .And. (_cAliSC9)->C9_PEDIDO == SC5->C5_NUM .And. Eval(bValid) )
			SC9->(DbGoTo((_cAliSC9)->SC9RECNO))
			If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .OR. (SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .OR.;
				SC9->C9_BLCRED=="09" )
				conout(Time()+ " " + "GENA046B - Libera��o de Cr�dito do Pedido de Vendas no GEN")
				
				/*/
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
				//a450Grava(1,.T.,.F.,.F.)
				a450Grava(1,.T.,.T.,.F.)  //04/02 - RAFAEL LEITE - EFETUA TAMBEM A LIBERACAO DE ESTOQUE
				
			EndIf
			(_cAliSC9)->(DbSkip())
		EndDo
	EndIf
	
	//��������������������������������������������������������������������������������������Ŀ
	//� Fim    Rotina para desbloquear cr�dito para que o pedido seja faturado sem problemas �
	//����������������������������������������������������������������������������������������
	
	//������������������������������������������������������������������������������������������������������Ŀ
	//�Inicio - Caso tenha ocorrido com sucesso a gera��o do Pedido de Vendas, ir� iniciar a gera��o da Nota �
	//��������������������������������������������������������������������������������������������������������
	DbSelectArea("SC9")
	DbSetOrder(1)
	If DbSeek(xFilial("SC9")+SC5->C5_NUM)
		
		_cPedExc := SC9->C9_PEDIDO
		conout(Time()+ " " + "GENA046B - Inicio da Gera��o do Documento de Sa�da no GEN.")
		
		//Controle das quantidades liberadas
		_nConfLib := 0
		_nConfVen := 0
		
		While SC9->(!EOF()) .And. SC9->C9_PEDIDO == SC5->C5_NUM
			DbSelectArea("SC6")
			DbSetOrder(1)
			DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM)
			
			_nConfLib += SC9->C9_QTDLIB
			_nConfVen += SC6->C6_QTDVEN
			
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
		
		conout(Time()+ " " + "GENA046B - Ir� realizar a gera��o da nota de sa�da no GEN")
		
		//����������������������������������������������������������Ŀ
		//�Rotina utilizada para realizar a gera��o da Nota de Sa�da �
		//������������������������������������������������������������
		
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
		
		//��������������������������������������������������������������������Ŀ
		//�Varrendo o vetor que contem as s�ries para saber se a s�rie contida �
		//�no parametro esta correta.                                          �
		//����������������������������������������������������������������������
		
		_lEspec := .F.
		For _ni := 1 To Len(_aPosEsp)
			If _aPosEsp[_ni][1] == _cMvSeri
				_lEspec := .T.
			EndIf
		Next
		
		//_cPedExc := SC9->C9_PEDIDO
		//If _lEspec
		
		If _lEspec .and. _nConfLib == _nConfVen // 04/02 RAFAEL LEITE - VERIFICA QUANTIDADE LIBERADA
			
			_cNotaImp := MaPVlNFs(_aPVlNFs,_cMvSeri,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)
			
		Elseif !_lEspec
			
			_cNotaImp := ""
			_cMsg := "A Nota n�o foi gerada, pois a s�rie n�o est� preenchida corretamente." + cEnt
			_cMsg += "Favor revisar o par�metro GEN_FAT003." + cEnt
			conout(Time()+ " " + _cMsg)
			MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )
			
		Elseif !_nConfLib == _nConfVen //04/02 - RAFAEL LEITE
			
			_cNotaImp := ""
			_cMsg := "A quantidade liberada est� diferente da informada no pedido." + cEnt
			conout(Time()+ " " + _cMsg)
			MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )
		EndIf
		
		//��������������������������������������������������������Ŀ
		//�Caso a nota n�o seja gerada ir� chamar a rotina de erro �
		//����������������������������������������������������������
		If Empty(AllTrim(_cNotaImp))
			conout(Time()+ " " + "GENA046B - Gera��o do Documento de Sa�da no GEN apresentou erro .")
			//_cPedExc := SC9->C9_PEDIDO
			
			//������������������������������������������������������������Ŀ
			//�Chamando o Execauto de Altera��o e em seguida o de exclus�o �
			//��������������������������������������������������������������
			
			//��������������������������������Ŀ
			//�Alterando a quantidade liberada �
			//����������������������������������
			For _ni := 1 To Len(_aItmPv)
				_aItmPv[_ni][_nPosLb][2] := 0
			Next _ni
			
			conout(Time()+ " " + "GENA046B - Ir� alterar o pedido de vendas para poder realizar a exclus�o no GEN")			
			lMsErroAuto := .F.
			aAdd ( _aCabPv , { "C5_NUM"    , SC5->C5_NUM     	, Nil} )
			MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,4)
			
			If !lMsErroAuto
				conout(Time()+ " " + "GENA046B - Alterou o pedido de vendas com sucesso, ir� realizar a exclus�o no GEN")
				
				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,5)
				
				If !lMsErroAuto
					lPedido := .F.
					conout(Time()+ " " + "GENA046B - Excluiu com sucesso o pedido de vendas no GEN")
					
					_cErroLg += "  " + cEnt
					_cErroLg += " O Pedido: " + _cPedExc + " foi exclu�do com sucesso. "  + cEnt
					_cErroLg += " Favor verificar o pedido: "  + cEnt
					_cErroLg += " Pois ele teve que ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
					_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois houve erro no processo. " + cEnt
					_cErroLg += " " + cEnt
					MemoWrite ( _cLogPd + "Emp" +SM0->M0_CODIGO + "_Fil_"+ AllTrim(SM0->M0_CODFIL) + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cErroLg )
				Else
					lPedido	:= .T.
					conout(Time()+ " " + "GENA046B - N�o conseguiu excluir o pedido de vendas no GEN")
					
					_aErro := GetAutoGRLog()
					For _ni := 1 To Len(_aErro)
						_cErroLg += _aErro[_ni] + cEnt
					Next _ni
					
					_cErroLg += "  " + cEnt
					_cErroLg += " O Pedido: " + _cPedExc + " n�o pode ser exclu�do. "  + cEnt
					_cErroLg += " Favor verificar o pedido: "  + cEnt
					_cErroLg += " pois ele deve ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
					_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois houve erro no processo. " + cEnt
					_cErroLg += " " + cEnt
					MemoWrite ( _cLogPd +DtoS(DDataBase)+ "\Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cErroLg )
				EndIf
			Else
				lPedido	:= .T.
				conout(Time()+ " " + "GENA046B - N�o conseguiu alterar o pedido de vendas no GEN")
				
				_aErro := GetAutoGRLog()
				For _ni := 1 To Len(_aErro)
					_cErroLg += _aErro[_ni] + cEnt
				Next _ni
				
				_cErroLg += "  " + cEnt
				_cErroLg += " O Pedido: " + SC9->C9_PEDIDO + " n�o pode ser alterado para prosseguir com a exclus�o. "  + cEnt
				_cErroLg += " Favor verificar o pedido: "  + cEnt
				_cErroLg += " pois ele deve ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
				_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois houve erro no processo. " + cEnt
				_cErroLg += " " + cEnt
				MemoWrite ( _cLogPd +DtoS(DDataBase)+ "\Emp" + _cEmp + "_Fil_"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cErroLg )
			EndIf
		EndIf
	EndIf
Else
	lPedido	:= .F.
	conout(Time()+ " " + "GENA046B - N�o conseguiu gerar o Pedido de Vendas no GEN")
	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + cEnt
		conout(_cErroLg)
	Next _ni
	MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil  + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraPedido.txt" , _cErroLg )
	Disarmtransaction()
EndIf

RestArea(_aArea)

Return _cNotaImp


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA046C  �Autor  �Helimar Tavares     � Data �  21/03/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina que ir� gerar a Nota fiscal de entrada para devolucao���
���          �da oferta e a Nota Fiscan de Entrada.                       ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GENA046C(_aCabPv,_cTemp1,_aCabDcOr,_cTemp2,_cNtDvCon,dProcPed)

Local _aArea 			:= GetArea()
Local _cQuery			:= ""
Local _cAliSC9			:= GetNextAlias()
Local _aTmpPV1			:= {}
Local _aPVlNFs			:= {}
Local _cNotaImp			:= ""
Local _cMsg				:= ""
Local _aErro			:= {}
Local _cErroLg			:= ""
Local _nPosLb			:= 0
Local _cPedExc			:= ""
Local _cLogPd			:= GetMv("GEN_FAT095")+DtoS(DDataBase)+"\" //Cont�m o caminho que ser� gravado o log de erro
Local _cMvSeri 			:= GetMv("GEN_FAT101") //SERIE nota de sa�da
Local _cEmp				:= AllTrim(SM0->M0_CODIGO)
Local _cFil				:= AllTrim(SM0->M0_CODFIL)
Local _cMvEsp			:= GetMv("MV_ESPECIE") //Contem tipos de documentos fiscais utilizados na emissao de notas fiscais
Local _aPosEsp 			:= {}
Local _nMvEsp 			:= 0
Local _lEspec			:= .F.
Local _aItmPv   		:= {}
Local _aItmDcOr   		:= {}

	//DISPARA EMAIL AVISANDO SOBRE DOC DE SAIDA GERADO
Local cDest 			:= Alltrim(GetMv("GEN_FAT078"))
Local _ni
	
Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

If File(_cTemp1)
	_aItmPv := u_LeArq1(_cTemp1)
Endif

If File(_cTemp2)
	_aItmDcOr := u_LeArq1(_cTemp2)
Endif

DbSelectArea("SC5")
DbSetOrder(1)

conout(Time()+ " " + "GENA046C - Rotina de Gera��o da Nota Fiscal de Entrada (Devolu��o de Oferta)")
conout(Time()+ " " + "GENA046C - Primeiro a Gera��o da Nota Fiscal de Entrada (Devolu��o de Oferta)")

DbSelectArea("SA1")
DbSelectArea("SA2")

aAdd( _aCabDcOr, { "F1_DOC" ,_cNtDvCon })
MSExecAuto({|x,y,z|MATA103(x,y,z)},_aCabDcOr, _aItmDcOr,3)

If lMsErroAuto
	_lRet := .F.
	conout(Time()+ " " + "GENA046C - N�o conseguiu gerar a Nota Fiscal de Entrada (Devolu��o de Oferta) na empresa origem. ")
	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + cEnt
		conout(_cErroLg)
	Next _ni
	MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraDocEntrada.txt" , _cErroLg )
	U_GenSendMail(,,,"noreply@grupogen.com.br",cDest+";cleuto.lima@grupogen.com.br","Protheus - Processo Devolu��o de Oferta - Erro documento de entrada",_cErroLg,,,.F.)
	Disarmtransaction()
Else
	_cNotaImp	:= _cNtDvCon
	If !Empty(cDest)
		cMsg := "GENA046 - DEVOLU��O DE OFERTA" + cEnt
		cMsg += cEnt
		cMsg += "Foi gerado o documento de sa�da "+_cNtDvCon+"/"+_cMvSeri+" com "+cValToChar(len(_aItmDcOr))+" registro(s) para a empresa "+SM0->M0_CODFIL+" - "+alltrim(SM0->M0_NOMECOM) + cEnt
		U_GenSendMail(,,,"noreply@grupogen.com.br",cDest,"Protheus Faturamento - Processo Devolu��o de Oferta",cMsg,,,.F.)
	Endif	
EndIf

RestArea(_aArea)

Return(_cNotaImp)
