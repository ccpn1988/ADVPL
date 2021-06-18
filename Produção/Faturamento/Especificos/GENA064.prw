#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

#DEFINE cEnt Chr(13)+Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA064   �Autor  �Danilo Azevedo      � Data �  15/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de Aparas                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA064()

conout(Time()+ " " + "GENA064 - Inicio - Rotina de aparas")
Prepare Environment Empresa "00" Filial "1022"

LockByName("GENA064",.T.,.T.,.T.)
U_GENA064A()
UnLockByName("GENA064",.T.,.T.,.T.)

conout(Time()+ " " + "GENA064 - Fim - Rotina de aparas")
Reset Environment

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA064A  �Autor  �Angelo Henrique     � Data �  29/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina respons�vel por fazer o filtro das Notas de Entradas ���
���          �corretas para realizar o processo de presta��o de contas.   ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA064A()

Local _aArea 	:= GetArea()
Local _cQuery 	:= ""
Local _cAliQry	:= GetNextAlias()
Local _cEmpCd 	:= ""
Local _cEmpFl 	:= ""
Local _cForn 	:= ""
Local _cLojFn  	:= ""
Local _cAliQry1	:= GetNextAlias()
Local _cAliQry2	:= GetNextAlias()
Local _cAliQry3	:= GetNextAlias()
Local _cAliQry4	:= GetNextAlias()
Local _cAliQry5	:= GetNextAlias()
Local _cAliQryX	:= GetNextAlias()
Local _aDir		:= {}
Local _aCabDcOr := {} //Vetor contendo o cabe�a'lho documento de entrada empresa Origem
Local _alinhaOr := {} //Vetor que recebe os itens do documento de entrada empresa Origem
Local _aItmDcOr := {} //Vetor contendo os itens do documento de entrada empresa Origem
Local _nQuant	:= 0
Local _aCabPd 	:= {} //Gera��o do cabe�alho Pedido de Vendas na empresa Origem
Local _alinha	:= {} //Gera��o do Item do Pedido de Vendas na empresa Origem
Local _aItmPd	:= {} //Recebe os itens do pedido de Vendas na empresa Origem
Local _aCabPv	:= {} //Gera��o do cabe�alho Pedido de Vendas na empresa Matriz
Local _aItmPv	:= {} //Recebe os itens do pedido de Vendas na empresa Matriz
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
Local _lOkNe	:= .T.
Local _dDtAco	:= CTOD(" / / ")
Local _cMsg		:= ""
Local _nDesc	:= 0
Local _nContOr	:= 0
Local _cContC6	:= 0
Local _nPrcVn	:= 0
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
Local _cQryTes  := ""
Local _cAliTes	:= GetNextAlias()
Local _cTesPr	:= ""
Local _cEmp		:= AllTrim(SM0->M0_CODIGO)
Local _cFil		:= AllTrim(SM0->M0_CODFIL)
Local _aSldB6	:= {}
Local _nQtdB6	:= 0
Local _nQtdSld	:= 0
Local _lVcDesc  := .F.
Local _cForUp 	:= ""
Local _cLojUp 	:= ""

Local _cMvCdPv 	:= GetMv("GEN_FAT013") //Condi��o de pagamento pedido de venda empresa Matriz
Local _cMvCdOr 	:= GetMv("GEN_FAT014") //Condi��o de pagamento pedido de venda empresa Origem
Local _cMvTbPr 	:= GetMv("GEN_FAT015") //Cont�m a tabela de pre�o usado no pedido de vendas na empresa Matriz e Origem
Local _cLogPd	:= GetMv("GEN_FAT146") //Cont�m o caminho que ser� gravado o log de erro
Local _cMvClDe	:= GetMv("GEN_FAT017") //Cont�m o cliente que ser� utilizado para realizar as movimenta��es na empresa Matriz
Local _cMvLjDe  := GetMv("GEN_FAT018") //Cont�m a Loja que ser� utilizado as movimenta��es na empresa Matriz
Local _cFil		:= GetMv("GEN_FAT019") //Cont�m a Filial correta da empresa GEN que ser� realizado as movimenta��es de consigna��o
Local _cMvEspc 	:= GetMv("GEN_FAT020") //Cont�m a especie utilizada na nota de entrada das empresas Matriz e Origem
Local _cMvCdDe	:= GetMv("GEN_FAT021") //Cont�m a condi��o de pagamento utilizada na nota de entrada das empresas Matriz e Origem
Local _cMvSeri 	:= GetMv("GEN_FAT026") //SERIE nota de sa�da de entrada nas empresas Matrz e Origem
Local _cMvTsPd	:= GetMv("GEN_FAT076") //Cont�m o TES utilizado no Pedido de Vendas das empresas Matriz, consigna��o (positivo)
Local _cMvTsOr	:= GetMv("GEN_FAT077") //Cont�m o TES utilizado na nota de entrada das empresas Origem, consigna��o (positivo) - Vendas
Local _cServ 	:= GETMV("GEN_FAT290") //Cont�m o Ip do servidor para realizar as mudan�as de ambiente
Local _nPort  	:= GETMV("GEN_FAT277") //Cont�m a porta para realizar as mudan�as de ambiente
Local _cAmb  	:= GETMV("GEN_FAT278") //Cont�m o ambiente a ser utilizado para realizar as mudan�as de filial

Local _cLogSld	:= ""

Local aItOri	:= {}
Local _ni		:= 0

WFForceDir(_cLogPd)

//���������������������������
//�Executar limpeza dos logs�
//���������������������������
_aDir := directory(Alltrim(_cLogPd)+"*")
For _ni:= 1 to Len(_aDir)
	fErase(Alltrim(_cLogPd)+_aDir[_ni][1])
Next _ni

conout(Time()+ " " + "GENA064A - Inicio - Verificando Itens da Nota de Entrada")

tcSqlExec("UPDATE "+RetSqlName("SB1")+" SET B1_DESC = REPLACE(B1_DESC,'|','/') WHERE B1_DESC LIKE '%|%'") //TROCA "|" POR "/" NA DESCRICAO DOS PRODUTOS PARA NAO GERAR ERRO NA ROTINA GRAVAARQ/LEARQ

//����������������������������������������������������������������������������������������Ŀ
//�Pegando Informacoes do GEN atraves dos parametros para ser utilizado no pedido de vendas�
//������������������������������������������������������������������������������������������
DbSelectArea("SA1")
DbSetORder(1)
If !DbSeek(xFilial("SA1")+PADR(AllTrim(_cMvClDe),TAMSX3("A1_COD")[1])+PADR(AllTrim(_cMvLjDe),TAMSX3("A1_LOJA")[1]))
	_cMsg := "N�o foi encontrado no sistema o cliente cadastrado nos parametros de Consigna��o." + cEnt
	_cMsg += "Cliente: " + AllTrim(_cMvClDe) + " loja: " + AllTrim(_cMvLjDe) + cEnt
	_cMsg += "Favor verificar os parametros: GEN_FAT015 e GEN_FAT016" + cEnt
	conout(Time()+ " " + _cMsg)
	MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "Consigna��o.txt" , _cMsg )
Else
	_cCliGen := SA1->A1_COD
	_cLojGen := SA1->A1_LOJA
	_cTrpGen := SA1->A1_TRANSP
	_cTipGen := SA1->A1_TIPO
	_cVenGen := SA1->A1_VEND
	
	DbSelectArea("SA2")
	DbSetOrder(3)
	If !DbSeek(xFilial("SA2")+SA1->A1_CGC)
		_cMsg := "N�o foi encontrado no sistema associa��o do Cliente com o Fornecedor atrav�s do CGC cadastrado nos parametros de Consigna��o." + cEnt
		_cMsg += "Cliente: " + AllTrim(_cMvClDe) + " loja: " + AllTrim(_cMvLjDe) + cEnt
		_cMsg += "Favor verificar os parametros: GEN_FAT015 e GEN_FAT016" + cEnt
		conout(Time()+ " " + _cMsg)
		MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "Consigna��o.txt" , _cMsg )
	Else
		
		_cFnGen := SA2->A2_COD
		_cLjGen := SA2->A2_LOJA
		
		//�������������������������������������������������������������������Ŀ
		//�Pesquisa produtos com status bloqueado aparas e saldo no armazem 06�
		//���������������������������������������������������������������������
		
		_cQuery := "SELECT B1_COD, B1_PROC, B1_LOJPROC, B1_DESC, B1_UM, B1_LOCPAD, B1_MSBLQL, B2_QATU, B1_ISBN
		_cQuery += " FROM " + RetSqlName("SB2") + " B2
		_cQuery += " JOIN " + RetSqlName("SB1") + " B1 ON B2_COD = B1_COD
		_cQuery += " WHERE B2_FILIAL   = '" + _cFil + "'
		_cQuery += " AND B2_LOCAL      = '06'
		_cQuery += " AND B2_QATU-(B2_RESERVA+B2_QEMP) > 0
		_cQuery += " AND B1_FILIAL     = '"+xFilial("SB1")+"'
		//_cQuery += " AND B1_MSBLQL     <> '1'
		//_cQuery += " AND B1_XSITOBR    = '111' //COMENTADO POR DANILO AZEVEDO - 13/10/2015 - VIVAZ 24374
		_cQuery += " AND B1.D_E_L_E_T_ = ' '
		_cQuery += " AND B2.D_E_L_E_T_ = ' '
		_cQuery += " AND B1_PROC <> '378803 '
		_cQuery += "   AND NOT EXISTS "
		_cQuery += "     (SELECT 1 "
		_cQuery += "     FROM TT_I11_FLAG_VIEW I11 "
		_cQuery += "     WHERE I11.VIEW_NAME LIKE '%GENA064_OBRA_NO_PROC%' "
		_cQuery += "     AND I11.CHAVE       = 'B2_COD' "
		_cQuery += "     AND TRIM(I11.VALOR) = TRIM(B2_COD) "
		_cQuery += "     AND TRIM(I11.FILIAL) = TRIM(B2_FILIAL) "
		_cQuery += "     ) "

		_cQuery += " ORDER BY B1_PROC, B1_LOJPROC, B2_QATU DESC
		
		If Select(_cAliQry) > 0
			dbSelectArea(_cAliQry)
			(_cAliQry)->(dbCloseArea())
		EndIf
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry, .F., .T.)

		While (_cAliQry)->(!EOF())
								
			//���������������������������������������������������������������������������������������������������
			//�Ponterando no Fornecedor para realizar a busca na SM0 (Cadastro de Empresas), realizando assim   �
			//�uma nova conex�o na empresa em que ser� gerado a Nota de entrada e Pedido de Vendas/Nota de Sa�da�
			//���������������������������������������������������������������������������������������������������
			DbSelectArea("SA2")
			DbSetOrder(1)
			If !DbSeek(xFilial("SA2")+(_cAliQry)->B1_PROC+(_cAliQry)->B1_LOJPROC)
				_cMsg := "N�o foi encontrado no sistema fornecedor com o c�digo: " + (_cAliQry)->B1_PROC + " e loja: " + (_cAliQry)->B1_LOJPROC  + ", vinculados ao produto: " + (_cAliQry)->B1_COD
				conout(Time()+ " " + _cMsg)
				MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil "+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
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
				MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
				(_cAliQry)->(DbSkip())
				Loop
			EndIf
			
			_cCliPv 	:= SA1->A1_COD
			_cLjPv  	:= SA1->A1_LOJA
			_cTrpPv		:= SA1->A1_TRANSP
			_cTipPv 	:= SA1->A1_TIPO
			_cVenPv 	:= SA1->A1_VEND
			
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
			
			//�������������������������������������������������Ŀ
			//�Se achar a empresa correta realiza a movimenta��o�
			//���������������������������������������������������
			If !_lEmp
				_cMsg := "N�o foi encontrado no sistema empresa (SM0) com o CNPJ: " + SA2->A2_CGC
				conout(Time()+ " " + _cMsg)
				MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + ".txt" , _cMsg )
				(_cAliQry)->(DbSkip())
				Loop
			EndIf
			
			//������������������������������������Ŀ
			//�Pegando o produto na tabela de pre�o�
			//��������������������������������������
			DbSelectArea("DA0")
			DbSetOrder(1)
			If !DbSeek(xFilial("DA0")+_cMvTbPr)
				_cMsg := "N�o foi encontrado no sistema tabela de pre�o com o c�digo: " + AllTrim(_cMvTbPr)
				conout(Time()+ " " + _cMsg)
				MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
				(_cAliQry)->(DbSkip())
				Loop
			EndIf
			
			//���������������������������������������������
			//�Validando se a tabela de pre�o esta vigente�
			//���������������������������������������������
			If !(DA0->DA0_DATATE > dDatabase .OR. Empty(DA0->DA0_DATATE))
				_cMsg := "A Tabela de pre�o:  " + AllTrim(_cMvTbPr) + " encontra-se vencida, favor verificar."
				conout(Time()+ " " + _cMsg)
				MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
				(_cAliQry)->(DbSkip())
				Loop
			EndIf
			
			_aCabPv := {}
			
			//����������������������������������������������������������������������Ŀ
			//�Array contendo o cabe�alho da pedido de vendas para a empresa Matriz	 �
			//������������������������������������������������������������������������
			//aAdd ( _aCabPv , { "C5_TIPO"    , "D"     	, Nil} ) // 03/02 - Rafael Leite
			aAdd ( _aCabPv , { "C5_TIPO"    , "B"     	, Nil} )
			aAdd ( _aCabPv , { "C5_CLIENTE" , _cForn  	, Nil} )
			aAdd ( _aCabPv , { "C5_LOJACLI" , _cLojFn  	, Nil} )
			aAdd ( _aCabPv , { "C5_CLIENT"  , _cForn 	, Nil} )
			aAdd ( _aCabPv , { "C5_LOJAENT" , _cLojFn	, Nil} )
			//aAdd ( _aCabPv , { "C5_TRANSP"  , _cTrpPv	, Nil} )
			//aAdd ( _aCabPv , { "C5_TRANSP"  , ''	, Nil} )
			aAdd ( _aCabPv , { "C5_TIPOCLI" , _cTipPv 	, Nil} )
			//aAdd ( _aCabPv , { "C5_VEND1" 	, '' 	, Nil} )
			aAdd ( _aCabPv , { "C5_CONDPAG" , _cMvCdPv	, Nil} )
			aAdd ( _aCabPv , { "C5_TABELA"  , _cMvTbPr	, Nil} )
			aAdd ( _aCabPv , { "C5_EMISSAO" , dDatabase	, Nil} )
			aAdd ( _aCabPv , { "C5_MOEDA" 	, 1			, Nil} )
			aAdd ( _aCabPv , { "C5_TPLIB" 	, "2"		, Nil} )
			
			_aCabPd := {}
			
			//����������������������������������������������������������������������Ŀ
			//�Array contendo o cabe�alho da pedido de vendas para a empresa origem	 �
			//������������������������������������������������������������������������
			aAdd ( _aCabPd , { "C5_TIPO"    , "N"      	, Nil} )
			aAdd ( _aCabPd , { "C5_CLIENTE" , _cCliGen 	, Nil} )
			aAdd ( _aCabPd , { "C5_LOJACLI" , _cLojGen 	, Nil} )
			aAdd ( _aCabPd , { "C5_CLIENT"  , _cCliGen	, Nil} )
			aAdd ( _aCabPd , { "C5_LOJAENT" , _cLojGen	, Nil} )
			//aAdd ( _aCabPd , { "C5_TRANSP"  , _cTrpGen	, Nil} )
			aAdd ( _aCabPd , { "C5_TIPOCLI" , _cTipGen 	, Nil} )
			//aAdd ( _aCabPd , { "C5_VEND1" 	, _cVenGen 	, Nil} )
			aAdd ( _aCabPd , { "C5_CONDPAG" , _cMvCdOr	, Nil} )
			aAdd ( _aCabPd , { "C5_TABELA"  , _cMvTbPr	, Nil} )
			aAdd ( _aCabPd , { "C5_EMISSAO" , dDatabase	, Nil} )
			aAdd ( _aCabPd , { "C5_MOEDA" 	, 1			, Nil} )
			aAdd ( _aCabPd , { "C5_TPLIB" 	, "2"		, Nil} )
			
			//�������������������������������������������������������������
			//�Array contendo o cabe�alho da nota de entrada para a Origem�
			//�������������������������������������������������������������
			
			_aCabDcOr := {} //Vetor contendo o cabe�alho documento de entrada empresa Origem
			_aItmDcOr := {} //Vetor contendo os itens do documento de entrada empresa Origem
			
			aadd(_aCabDcOr , {"F1_TIPO"   	,"B"		, Nil} ) // 03/02 - RAFAEL LEITE
			aadd(_aCabDcOr , {"F1_FORMUL" 	,"N"		, Nil} )
			aadd(_aCabDcOr , {"F1_SERIE"  	,_cMvSeri	, Nil} )
			aadd(_aCabDcOr , {"F1_EMISSAO"	,dDataBase	, Nil} )
			aadd(_aCabDcOr , {"F1_FORNECE"	,PADR(AllTrim(_cCliGen),TAMSX3("F1_FORNECE")[1])	, Nil} )
			aadd(_aCabDcOr , {"F1_LOJA"   	,_cLojGen	, Nil} )
			aadd(_aCabDcOr , {"F1_ESPECIE"	,_cMvEspc	, Nil} )
			aadd(_aCabDcOr , {"F1_COND"		,_cMvCdDe	, Nil} )
			
			_nContOr := 1
			_cContC6 := STRZERO(1,TAMSX3("C6_ITEM")[1])
			
			_aItmPd := {}
			_alinha := {}
			_aItmPv := {}
			
			_lVcDesc := .F.
			
			_cForUp	:= ""
			_cLojUp := ""
			
			_nItMax := 1
			While AllTrim((_cAliQry)->B1_PROC) == _cForn .And. AllTrim((_cAliQry)->B1_LOJPROC) == _cLojFn .and. _nItMax < 100
				
				_nItMax++
				
				_nQuant := 0
				_cForUp 	:= AllTrim((_cAliQry)->B1_PROC)
				_cLojUp 	:= AllTrim((_cAliQry)->B1_LOJPROC)
				
				//�����������������������������������������������������Ŀ
				//�Validando a quantidade correta a ser usada nas notas.�
				//�������������������������������������������������������
				
				_nQuant := (_cAliQry)->B2_QATU
				
				//PRODUTOS BLQUEADOS
				If (_cAliQry)->B1_MSBLQL == '1'
					_cMsg := "Produto bloqueado (B1_MSBLQL) nao sera considerado na prestacao, mas tem quantidade a prestar contas: " + Alltrim((_cAliQry)->B1_COD)
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod Blq "  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
					(_cAliQry)->(DbSkip())
					Loop
				Endif
				
				//�����������������������������������������������������������Ŀ
				//�Validando se a tabela de pre�o possui o produto selecionado�
				//�������������������������������������������������������������
				DbSelectArea("DA1")
				DbSetOrder(1)
				If !DbSeek(xFilial("DA1")+_cMvTbPr+(_cAliQry)->B1_COD)
					//���������������������������������� �
					//�Fun��o para alimentar Log de erro�
					//���������������������������������� �
					_cMsg := "N�o foi encontrado no sistema tabela de pre�o/produto com os c�digos: " + AllTrim(_cMvTbPr) + " / " + AllTrim((_cAliQry)->B1_COD)
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
					(_cAliQry)->(DbSkip())
					Loop
				EndIf
				
				//�����������������������������������������������������������������S
				//�Valida��o da regra de descontos para regra de cliente		   �
				//�����������������������������������������������������������������S
				_cQuery := " SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE
				_cQuery += " FROM " + RetSqlName("ACO")
				_cQuery += " WHERE D_E_L_E_T_ = ' '
				_cQuery += " AND ACO_CODCLI = '" + SA1->A1_COD + "'
				_cQuery += " AND ACO_LOJA = '" + SA1->A1_LOJA + "'
				
				If Select(_cAliQry1) > 0
					dbSelectArea(_cAliQry1)
					(_cAliQry1)->(dbCloseArea())
				EndIf
				
				dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry1, .F., .T.)
				
				If (_cAliQry1)->(!EOF())
					
					//���������������������������������������������x�[�
					//�Valida��o se a regra de desconto esta v�lida�
					//���������������������������������������������x�[�
					If !(StoD((_cAliQry1)->ACO_DATATE) > dDatabase .OR. Empty((_cAliQry1)->ACO_DATATE))
						//����������������������������������I
						//�Fun��o para alimentar Log de erro�
						//����������������������������������I
						_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry1)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
						_lVcDesc := .T.
						conout(Time()+ " " + _cMsg)
						MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
						(_cAliQry)->(DbSkip())
						Loop
					EndIf
					
					//���������������������������������������������������������������������S
					//�Valida��o da para pegar o produto  nas linhas da regra de desconto  �
					//���������������������������������������������������������������������S
					_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES
					_cQuery += " FROM " + RetSqlName("ACP")
					_cQuery += " WHERE D_E_L_E_T_ = ' '
					_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'
					
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
						_nDesc := (_cAliQry1)->ACO_PERDES
					EndIf
					
					If Select(_cAliQry4) > 0
						dbSelectArea(_cAliQry4)
						(_cAliQry4)->(dbCloseArea())
					EndIf
				Else
					//�����������������������������������������������������������������S
					//�Valida��o da regra de descontos para regra de grupo de cliente  �
					//�����������������������������������������������������������������S
					_cQuery := " SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE
					_cQuery += " FROM " + RetSqlName("ACO")
					_cQuery += " WHERE D_E_L_E_T_ = ' '
					_cQuery += " AND ACO_GRPVEN = '" + SA1->A1_GRPVEN + "'
					
					If Select(_cAliQry2) > 0
						dbSelectArea(_cAliQry2)
						(_cAliQry2)->(dbCloseArea())
					EndIf
					dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry2, .F., .T.)
					If (_cAliQry2)->(!EOF())
						
						//���������������������������������������������x�[�
						//�Valida��o se a regra de desconto esta v�lida�
						//���������������������������������������������x�[�
						
						_dDtAco := IIF(ValType((_cAliQry2)->ACO_DATATE) = "C", STOD((_cAliQry2)->ACO_DATATE), (_cAliQry2)->ACO_DATATE)
						
						If !(_dDtAco > dDatabase .OR. Empty((_cAliQry2)->ACO_DATATE))
							_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry2)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
							_lVcDesc := .T.
							conout(Time()+ " " + _cMsg)
							MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
							(_cAliQry)->(DbSkip())
							Loop
						EndIf
						
						//���������������������������������������������������������������������S
						//�Valida��o da para pegar o produto  nas linhas da regra de desconto  �
						//���������������������������������������������������������������������S
						_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES
						_cQuery += " FROM " + RetSqlName("ACP")
						_cQuery += " WHERE D_E_L_E_T_ = ' '
						_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'
						
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
						//�����������������������������������������������������������������������������S
						//�Valida��o da regra de descontos sem cliente e sem regra de grupo de cliente �
						//�����������������������������������������������������������������������������S
						_cQuery := " SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE
						_cQuery += " FROM " + RetSqlName("ACO")
						_cQuery += " WHERE D_E_L_E_T_ = ' '
						_cQuery += " AND (ACO_CODCLI = ' ' OR ACO_GRPVEN = ' ')
						
						If Select(_cAliQry3) > 0
							dbSelectArea(_cAliQry3)
							(_cAliQry3)->(dbCloseArea())
						EndIf
						
						dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry3, .F., .T.)
						
						If (_cAliQry3)->(!EOF())
							//���������������������������������������������x�[�
							//�Valida��o se a regra de desconto esta v�lida�
							//���������������������������������������������x�[�
							_dDtAco := IIF(ValType((_cAliQry2)->ACO_DATATE) = "C", STOD((_cAliQry2)->ACO_DATATE), (_cAliQry2)->ACO_DATATE)
							
							If !(_dDtAco > dDatabase .OR. Empty((_cAliQry3)->ACO_DATATE))
								//����������������������������������I
								//�Fun��o para alimentar Log de erro�
								//����������������������������������I
								_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry3)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
								_lVcDesc := .T.
								conout(Time()+ " " + _cMsg)
								MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
								(_cAliQry)->(DbSkip())
							EndIf
							
							//���������������������������������������������������������������������S
							//�Valida��o da para pegar o produto  nas linhas da regra de desconto  �
							//���������������������������������������������������������������������S
							_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES
							_cQuery += " FROM " + RetSqlName("ACP")
							_cQuery += " WHERE D_E_L_E_T_ = ' '
							_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'
							
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
				
				If _nDesc != 0
					_nPrcVn := (DA1->DA1_PRCVEN * _nDesc) / 100
				Else
					_nPrcVn := DA1->DA1_PRCVEN
				EndIf
				
				//07/05/2015 - Rafael Leite - N�o existe pre�o de venda menor que R$ 0.01.
				If _nPrcVn < 0.01
					_nPrcVn := 0.01
				Endif
				
				//_nPrcVn := DA1->DA1_PRCVEN
				_nDesc := 0 //Zerando a Vari�vel
				
				If _nPrcVn > 0
					
					//������������������������������������������������������������������������������������������������Ŀ
					//�Sempre ir� gravar todos os produtos na empresa matriz, por�m alguns valores podem vir negativos,�
					//�fazer a transforma��o do negativo para positivo, isso somente para a empresa Matriz             �
					//��������������������������������������������������������������������������������������������������
					_aSldB6 := {} //Zerando o Vetor de Saldos em poder de terceiros
					//���������������������������������������������������a��
					//�Realizando a busca por saldo em poder de terceiros�
					//���������������������������������������������������a��
					_cQuery := "SELECT B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO, B6_DOC, B6_SALDO, B6_PRUNIT,
					_cQuery += " B6_SERIE, B6_CLIFOR, B6_LOJA, D1_ITEM, B6_IDENT,(D1_VALDESC/D1_TOTAL) DESCONTO,(D1_TOTAL-D1_VALDESC)/D1_QUANT PRC_CALC,
					
					//Rafael Leite - 08/05/2015 - Incluido tratamento para comparar saldo GEN e Empresa Origem
					_cQuery += " (SELECT SUM(B6_SALDO)
					_cQuery += " FROM " + RetSqlName("SB6") + " B6_ORI
					_cQuery += " WHERE B6_ORI.B6_FILIAL = '"+_cEmpFl+"'
					_cQuery += " AND B6_ORI.B6_DOC      = SB6.B6_DOC
					_cQuery += " AND B6_ORI.B6_SERIE    = SB6.B6_SERIE
					_cQuery += " AND B6_ORI.B6_PRODUTO  = SB6.B6_PRODUTO
					_cQuery += " AND B6_ORI.B6_QUANT    = SB6.B6_QUANT
					_cQuery += " AND D_E_L_E_T_  = ' ' ) SALDO_ORI
					_cQuery += " FROM " + RetSqlName("SB6") + " SB6, " + RetSqlName("SD1") + " SD1
					_cQuery += " WHERE SB6.B6_DOC = SD1.D1_DOC
					_cQuery += " AND SB6.B6_SERIE = SD1.D1_SERIE
					_cQuery += " AND SB6.B6_PRODUTO = SD1.D1_COD
					_cQuery += " AND SB6.B6_CLIFOR = SD1.D1_FORNECE
					_cQuery += " AND SB6.B6_LOJA = SD1.D1_LOJA
					_cQuery += " AND SB6.D_E_L_E_T_ = ' '
					_cQuery += " AND SD1.D_E_L_E_T_ = ' '
					_cQuery += " AND SB6.B6_FILIAL = '" + _cFil + "'
					_cQuery += " AND SD1.D1_FILIAL = '" + _cFil + "'
					_cQuery += " AND SB6.B6_TIPO = 'D'
					_cQuery += " AND SB6.B6_TPCF = 'F'
					_cQuery += " AND SB6.B6_PODER3 = 'R'
					_cQuery += " AND SB6.B6_SALDO > 0
					_cQuery += " AND SB6.B6_PRODUTO = '" + (_cAliQry)->B1_COD + "'
					_cQuery += " AND SB6.B6_CLIFOR = '" + _cForn + "'
					_cQuery += " AND SB6.B6_LOJA = '" + _cLojFn + "'
					
					//Helimar Tavares - 08/03/2016 - Adicionado filtro para exibir somente produtos com D1_QUANT-D1_QTDEDEV maior ou igual ao saldo na filial
					_cQuery += " AND SD1.D1_QUANT - SD1.D1_QTDEDEV >= SB6.B6_SALDO
					//Rafael Leite - 07/05/2015 - Adicionado filtro para exibir somente documentos com saldo na empresa origem.
					_cQuery += " AND (SELECT SUM(B6_SALDO)
					_cQuery += " FROM " + RetSqlName("SB6") + " B6_ORI
					_cQuery += " WHERE B6_ORI.B6_FILIAL = '"+_cEmpFl+"'
					_cQuery += " AND B6_ORI.B6_DOC      = SB6.B6_DOC
					_cQuery += " AND B6_ORI.B6_SERIE    = SB6.B6_SERIE
					_cQuery += " AND B6_ORI.B6_PRODUTO  = SB6.B6_PRODUTO
					_cQuery += " AND B6_ORI.B6_QUANT    = SB6.B6_QUANT
					_cQuery += " AND D_E_L_E_T_  = ' ' ) > 0
					
					_cQuery += " ORDER BY B6_EMISSAO
					
					If Select(_cAliQry5) > 0
						dbSelectArea(_cAliQry5)
						(_cAliQry5)->(dbCloseArea())
					EndIf

					lOriOk	:= .T.

					dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry5, .F., .T.)
					(_cAliQry5)->(DbGoTop())
					If (_cAliQry5)->(EOF())
					            
						If Select("TMP_SALDO") > 0
							TMP_SALDO->(DbCloseArea())
						EndIF
						_cQuery := "SELECT SUM(B6_SALDO) B6_SALDO,
						
						//Rafael Leite - 08/05/2015 - Incluido tratamento para comparar saldo GEN e Empresa Origem
						_cQuery += " SUM((SELECT SUM(B6_SALDO)
						_cQuery += " FROM " + RetSqlName("SB6") + " B6_ORI
						_cQuery += " WHERE B6_ORI.B6_FILIAL = '"+_cEmpFl+"'
						_cQuery += " AND B6_ORI.B6_DOC      = SB6.B6_DOC
						_cQuery += " AND B6_ORI.B6_SERIE    = SB6.B6_SERIE
						_cQuery += " AND B6_ORI.B6_PRODUTO  = SB6.B6_PRODUTO
//						_cQuery += " AND B6_ORI.B6_QUANT    = SB6.B6_QUANT
						_cQuery += " AND D_E_L_E_T_  = ' ' )) SALDO_ORI
						_cQuery += " FROM " + RetSqlName("SB6") + " SB6, " + RetSqlName("SD1") + " SD1
						_cQuery += " WHERE SB6.B6_DOC = SD1.D1_DOC
						_cQuery += " AND SB6.B6_SERIE = SD1.D1_SERIE
						_cQuery += " AND SB6.B6_PRODUTO = SD1.D1_COD
						_cQuery += " AND SB6.B6_CLIFOR = SD1.D1_FORNECE
						_cQuery += " AND SB6.B6_LOJA = SD1.D1_LOJA
						_cQuery += " AND SB6.D_E_L_E_T_ = ' '
						_cQuery += " AND SD1.D_E_L_E_T_ = ' '
						_cQuery += " AND SB6.B6_FILIAL = '" + _cFil + "'
						_cQuery += " AND SD1.D1_FILIAL = '" + _cFil + "'
						_cQuery += " AND SB6.B6_TIPO = 'D'
						_cQuery += " AND SB6.B6_TPCF = 'F'
						_cQuery += " AND SB6.B6_PODER3 = 'R'
						_cQuery += " AND SB6.B6_SALDO > 0
						_cQuery += " AND SB6.B6_PRODUTO = '" + (_cAliQry)->B1_COD + "'
						_cQuery += " AND SB6.B6_CLIFOR = '" + _cForn + "'
						_cQuery += " AND SB6.B6_LOJA = '" + _cLojFn + "'
						
						//Helimar Tavares - 08/03/2016 - Adicionado filtro para exibir somente produtos com D1_QUANT-D1_QTDEDEV maior ou igual ao saldo na filial
						_cQuery += " AND SD1.D1_QUANT - SD1.D1_QTDEDEV >= SB6.B6_SALDO
						//Rafael Leite - 07/05/2015 - Adicionado filtro para exibir somente documentos com saldo na empresa origem.						
						_cQuery += " ORDER BY B6_EMISSAO
						
						DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), "TMP_SALDO", .F., .T.)
						
						_cMsg := "N�o foi encontrado no sistema Saldo em poder de terceiros para o produto: " + AllTrim((_cAliQry)->B1_COD) + ", com o cliente/fornecedor: " + AllTrim(_cCliPv) + " e Loja: " + AllTrim(_cLjPv)+;
								" - Saldo Aparas: "+AllTrim(str((_cAliQry)->B2_QATU))+", "+;
								" Saldo Gen balanceado:"+AllTrim(Str( (_cAliQry5)->B6_SALDO ))+", Saldo Origem balanceado:"+AllTrim(Str( (_cAliQry5)->SALDO_ORI ))+" , "+;
								" Saldo Gen total:"+AllTrim(Str( TMP_SALDO->B6_SALDO ))+", Saldo Origem total:"+AllTrim(Str( TMP_SALDO->SALDO_ORI ))+" , "+;
/*Saldo a ser gerado no GEN: */	" | "+AllTrim(Str(  IIF( (_cAliQry5)->B6_SALDO-(_cAliQry)->B2_QATU < 0 , ((_cAliQry5)->B6_SALDO-(_cAliQry)->B2_QATU)*(-1), (_cAliQry5)->B6_SALDO-(_cAliQry)->B2_QATU )))+" "+;
 /*Saldo a ser gerado na Origem: */	" | "+AllTrim(Str(  IIF( (_cAliQry5)->SALDO_ORI-(_cAliQry)->B2_QATU < 0 , ((_cAliQry5)->SALDO_ORI-(_cAliQry)->B2_QATU)*(-1), (_cAliQry5)->SALDO_ORI-(_cAliQry)->B2_QATU )))
						
						TMP_SALDO->(DbCloseArea())
						_cLogSld+= AllTrim((_cAliQry)->B1_COD)+"|"+AllTrim((_cAliQry)->B1_ISBN)+"|"+AllTrim(str((_cAliQry)->B2_QATU))+"|"+_cMsg+Chr(13)+chr(10)
						conout(Time()+ " " + _cMsg)
						MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
						(_cAliQry)->(DbSkip())
						Loop
					EndIf
										
					//_nPrcVn := (_cAliQry5)->B6_PRUNIT //ADICIONADO POR DANILO AZEVEDO - 14/08/2015 //  COMENTADO EM 15/03/16 - HELIMAR TAVARES

					//Passando a quantidade para outra variavel, trabalhando assim livremente
					//sem alterar as demais valida��es e aplica��es da vari�vel _nQuant
					//pois a vari�vel _nQuant � utilizada abaixo em outras situa��es
					_nQtdSld := _nQuant
															
					While (_cAliQry5)->(!EOF())

						cItemAux	:= CriaVar("D2_ITEM",.F.)
						cIdentB6	:= ""
						
						nCount		:= 0
						While nCount < Val((_cAliQry5)->D1_ITEM)							
							cItemAux := Soma1(cItemAux)
							nCount++
						EndDo
                        
						If Select("TMP_ORI") > 0 
							TMP_ORI->(DbCloseArea())
						EndIf

						BeginSql Alias "TMP_ORI"
							
								SELECT D2_ITEM,D2_IDENTB6,D2_QTDEDEV,D2_QUANT
								FROM %Table:SB6% B6_ORI
								JOIN %Table:SD2% SD2
								ON B6_ORI.B6_FILIAL = SD2.D2_FILIAL
								AND B6_ORI.B6_DOC = SD2.D2_DOC
								AND B6_ORI.B6_SERIE = SD2.D2_SERIE
								AND B6_ORI.B6_PRODUTO = SD2.D2_COD
								AND B6_ORI.B6_CLIFOR = SD2.D2_CLIENTE
								AND B6_ORI.B6_LOJA = SD2.D2_LOJA
								AND B6_ORI.B6_IDENT = SD2.D2_IDENTB6
								WHERE B6_ORI.B6_FILIAL = %Exp:_cEmpFl%
								AND B6_ORI.B6_DOC      = %Exp:(_cAliQry5)->B6_DOC%
								AND B6_ORI.B6_SERIE    = %Exp:(_cAliQry5)->B6_SERIE%
								AND B6_ORI.B6_PRODUTO  = %Exp:(_cAliQry5)->B6_PRODUTO%
								AND B6_ORI.B6_SALDO	> 0
								AND B6_ORI.%NotDel%
							
						EndSql
						TMP_ORI->(DbGoTop())
						
						// cleuto - 17/10/2016 - removi da query  o filtro de item pois algumas notas o item de entrada foi digitado diferente do item de saida da origem
						/*AND SD2.D2_ITEM = %Exp:cItemAux%*/												
						
						If TMP_ORI->(EOF())
							If Select("TMP_ORI") > 0
								TMP_ORI->(DbCloseArea())
							endIf
							(_cAliQry5)->(DbSkip())
							If (_cAliQry5)->(EOF())								
								lOriOk	:= .F.
								_cMsg := "N�o foi poss�vel identificar os dados da nota de origem para o produto: " + AllTrim((_cAliQry)->B1_COD) + ", com o cliente/fornecedor: " + AllTrim(_cCliPv) + " e Loja: " + AllTrim(_cLjPv)
								_cLogSld+= AllTrim((_cAliQry)->B1_COD)+"|"+AllTrim((_cAliQry)->B1_ISBN)+"|"+AllTrim(str((_cAliQry)->B2_QATU))+"|"+_cMsg+CHR(13)+CHR(10)
								conout(Time()+ " " + _cMsg)
								MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )															
                                Exit
                            Else
                            	Loop    
							EndIf
						Else
							
							// Primeiro procuro pelo item correspondente
							While TMP_ORI->(!EOF())
							
								If TMP_ORI->D2_ITEM == cItemAux
									cItemAux	:= TMP_ORI->D2_ITEM 
									cIdentB6	:= TMP_ORI->D2_IDENTB6								
									Exit
								EndIf
								
								TMP_ORI->(DbSkip())
							EndDo
                            
							TMP_ORI->(DbGoTop())
							// N�o localizando pelo item correspondente eu procuro pelo item que tenha saldo mas que seja da mesma nota
							While TMP_ORI->(!EOF()) .and. Empty(cIdentB6)
																
                                If aScan(aItOri,{|x| x[1] == (_cAliQry5)->B6_PRODUTO .AND. x[2] == (_cAliQry5)->B6_DOC .AND. x[3] == (_cAliQry5)->B6_SERIE .AND. x[4] == TMP_ORI->D2_ITEM  }) == 0
									Aadd(aItOri,{ (_cAliQry5)->B6_PRODUTO, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, TMP_ORI->D2_ITEM })

									cItemAux	:= TMP_ORI->D2_ITEM 
									cIdentB6	:= TMP_ORI->D2_IDENTB6
									Exit
								EndIf
																							
								TMP_ORI->(DbSkip())
							EndDo
														
						EndIf
						
						If Empty(AllTrim(cItemAux)) .OR. Empty(AllTrim(cIdentB6))
							If Select("TMP_ORI") > 0
								TMP_ORI->(DbCloseArea())
							endIf						
							(_cAliQry5)->(DbSkip())
							If (_cAliQry5)->(EOF())								
								lOriOk	:= .F.
								_cMsg := "N�o foi poss�vel identificar os dados da nota de origem para o produto: " + AllTrim((_cAliQry)->B1_COD) + ", com o cliente/fornecedor: " + AllTrim(_cCliPv) + " e Loja: " + AllTrim(_cLjPv)
								_cLogSld+= AllTrim((_cAliQry)->B1_COD)+"|"+AllTrim((_cAliQry)->B1_ISBN)+"|"+AllTrim(str((_cAliQry)->B2_QATU))+"|"+_cMsg+CHR(13)+CHR(10)
								conout(Time()+ " " + _cMsg)
								MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )															
                                Exit
                            Else
                            	Loop    
							EndIf							
						EndIf
						
						If Select("TMP_ORI") > 0
							TMP_ORI->(DbCloseArea())
						endIf
						//08/05/2015 - Rafael Leite - Compara saldo GEN e Empresa Origem
						_nSldB6Comp := (_cAliQry5)->B6_SALDO
						
						//Se o saldo de poder terceiro na origem estiver menor que no GEN, utiliza o saldo da Origem.
						If _nSldB6Comp > (_cAliQry5)->SALDO_ORI
							_nSldB6Comp := (_cAliQry5)->SALDO_ORI
						Endif
						
						//_nQtdB6 := _nQtdSld - (_cAliQry5)->B6_SALDO
						_nQtdB6 := _nQtdSld - _nSldB6Comp
						
						// Se a nota de entrada for digitado com desconto � preciso utilizar o valor com desconto 
						_nPruNit := IIF( (_cAliQry5)->DESCONTO <> 0, (_cAliQry5)->PRC_CALC , (_cAliQry5)->B6_PRUNIT )
						
						//����������������������������������������������������������������
						//�Caso a quantidade seja igual ao saldo, preencher somente um vez�
						//�o array e sair do while para este produto                      �
						//����������������������������������������������������������������
						If _nQtdB6 = 0
							//aAdd(_aSldB6,{_nQtdB6, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM })
							//aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM }) //03/02 - RAFAEL LEITE
							//aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM, (_cAliQry5)->B6_IDENT}) // 15/03/16 - HELIMAR TAVARES
							//aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM, (_cAliQry5)->B6_IDENT, (_cAliQry5)->B6_PRUNIT }) // cleuto lima - 10/06/2016
							
							//aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM	, (_cAliQry5)->B6_IDENT, _nPruNit })
							//aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, cItemAux				, (_cAliQry5)->B6_IDENT, _nPruNit, cIdentB6 })
							aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, cItemAux				, (_cAliQry5)->B6_IDENT, _nPruNit, cIdentB6,(_cAliQry5)->D1_ITEM })
							Exit
						EndIf
						
						//�������������������������������������������������������������Ŀ
						//�Caso a quantidade desejada seja menor que o saldo, ir� gravar�
						//�o array e sair do while para este produto                    �
						//���������������������������������������������������������������
						If _nQtdB6 < 0
							_nQtdB6 := _nQtdB6 * -1
							//aAdd(_aSldB6,{_nQtdB6, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM })
							//aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM }) //03/02 - RAFAEL LEITE
							//aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM, (_cAliQry5)->B6_IDENT }) // 15/03/16 - HELIMAR TAVARES
							//aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM, (_cAliQry5)->B6_IDENT, (_cAliQry5)->B6_PRUNIT })// cleuto lima - 10/06/2016
							
							//aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM	, (_cAliQry5)->B6_IDENT, _nPruNit })
							//aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, cItemAux				, (_cAliQry5)->B6_IDENT, _nPruNit, cIdentB6 })
							aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, cItemAux				, (_cAliQry5)->B6_IDENT, _nPruNit, cIdentB6, (_cAliQry5)->D1_ITEM })
							Exit
						EndIf
						
						//����������������������������������������������������������������Ŀ
						//�Caso a quantidade seja maior que o saldo, ir� continuar no while�
						//�deste produto para preencher o array dando a quantidade correta �
						//������������������������������������������������������������������
						If _nQtdB6 > 0
							//aAdd(_aSldB6,{_nQtdB6, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM })
							//aAdd(_aSldB6,{(_cAliQry5)->B6_SALDO, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM }) //03/02 - RAFAEL LEITE
							
							//08/05/2015 - Rafael Leite - Ajuste para usar variavel com saldo poder 3 comparado (vide inicio do while)
							//aAdd(_aSldB6,{(_cAliQry5)->B6_SALDO, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM, (_cAliQry5)->B6_IDENT })
							//aAdd(_aSldB6,{_nSldB6Comp, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM, (_cAliQry5)->B6_IDENT }) // 15/03/16 - HELIMAR TAVARES
							//aAdd(_aSldB6,{_nSldB6Comp, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM, (_cAliQry5)->B6_IDENT, (_cAliQry5)->B6_PRUNIT })// cleuto lima - 10/06/2016
							
							//aAdd(_aSldB6,{_nSldB6Comp, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM	, (_cAliQry5)->B6_IDENT, _nPruNit })
							//aAdd(_aSldB6,{_nSldB6Comp, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, cItemAux				, (_cAliQry5)->B6_IDENT, _nPruNit, cIdentB6 })
							aAdd(_aSldB6,{_nSldB6Comp, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, cItemAux				, (_cAliQry5)->B6_IDENT, _nPruNit, cIdentB6, (_cAliQry5)->D1_ITEM})
														
							//_nQtdSld := _nQtdSld - (_cAliQry5)->B6_SALDO
							_nQtdSld := _nQtdSld - _nSldB6Comp
						EndIf
						(_cAliQry5)->(DbSkip())
					EndDo
										
					If Select(_cAliQry5) > 0
						dbSelectArea(_cAliQry5)
						(_cAliQry5)->(dbCloseArea())
					EndIf

					If !lOriOk
						(_cAliQry)->(DbSkip())
						Loop
					EndIf
					
					_nQtdSld := 0
					
					//�������������������������������������������������������Ŀ
					//�Validando se a quantidade esta correta para prosseguir �
					//���������������������������������������������������������
					For _ni := 1 To Len(_aSldB6)
						_nQtdSld += _aSldB6[_ni][1]
					Next _ni
					
					/* COMENTADO POR DANILO AZEVEDO 14/08/2015
					If _nQtdSld <> _nQuant
						//�����������������������������������
						//�Fun��o para alimentar Log de erro�
						//�����������������������������������
						_cMsg := "Saldo em poder de terceiros para o produto " + AllTrim((_cAliQry)->B1_COD) + ", com o cliente/fornecedor " + AllTrim(_cCliPv) + " e Loja " + AllTrim(_cLjPv) + " n�o atende a quantidade necess�ria."
						conout(Time()+ " " + _cMsg)
						MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
						(_cAliQry)->(DbSkip())
						Loop
					EndIf
					*/
					_nVUnit := 0
					For _ni := 1 To Len(_aSldB6)
						
						//����������������������������������������������Ŀ
						//�Array contendo a linha do pedido de vendas GEN�
						//������������������������������������������������
						aAdd ( _alinha 	, 	{ "C6_ITEM"    	, _cContC6, Nil})
						aAdd ( _alinha 	, 	{ "C6_PRODUTO" 	, (_cAliQry)->B1_COD 					, Nil})
						aAdd ( _alinha 	, 	{ "C6_DESCRI"  	, (_cAliQry)->B1_DESC  					, Nil})
						aAdd ( _alinha 	, 	{ "C6_QTDVEN"  	, _aSldB6[_ni][1]		   				, Nil})
						//aAdd ( _alinha 	, 	{ "C6_PRCVEN"  	, _nPrcVn	    						, Nil}) // 15/03/16 - HELIMAR TAVARES
						//aAdd ( _alinha 	, 	{ "C6_VALOR"   	, _aSldB6[_ni][1] *	_nPrcVn				, Nil}) // 15/03/16 - HELIMAR TAVARES
						aAdd ( _alinha 	, 	{ "C6_PRCVEN"  	, _aSldB6[_ni][6]						, Nil})
						aAdd ( _alinha 	, 	{ "C6_VALOR"   	, _aSldB6[_ni][1] * _aSldB6[_ni][6]	, Nil})
						aAdd ( _alinha 	, 	{ "C6_QTDLIB"  	, _aSldB6[_ni][1]						, Nil})
						aAdd ( _alinha 	, 	{ "C6_TES"     	, _cMvTsPd 		   						, Nil}) //TES diferente
						aAdd ( _alinha 	, 	{ "C6_LOCAL"   	, "06"   								, Nil})
						aAdd ( _alinha 	, 	{ "C6_ENTREG"	, dDataBase				   				, Nil})
						//aAdd ( _alinha 	, 	{ "C6_DESCONT" 	, 50									, Nil})
						aAdd ( _alinha 	, 	{ "C6_NFORI"	, PADR(AllTrim(_aSldB6[_ni][2]),TAMSX3("C6_NFORI")[1])	, Nil})
						aAdd ( _alinha 	, 	{ "C6_SERIORI"	, PADR(AllTrim(_aSldB6[_ni][3]),TAMSX3("C6_SERIORI")[1])	, Nil})
						aAdd ( _alinha 	, 	{ "C6_ITEMORI"	, PADR(AllTrim(_aSldB6[_ni][8]),TAMSX3("C6_ITEMORI")[1])	, Nil})
						aAdd ( _alinha 	, 	{ "C6_IDENTB6"	, PADR(AllTrim(_aSldB6[_ni][5]),TAMSX3("C6_IDENTB6")[1])	, Nil})
						
						aAdd(_aItmPv , _alinha  )
						_alinha := {}
						
						//��������������������������������������������������������������Ŀ
						//�Array contendo os itens do Documento de Entrada empresa Origem�
						//����������������������������������������������������������������
						aAdd(_alinhaOr	,	{"D1_ITEM"		, _cContC6, Nil})
						aAdd(_alinhaOr	,	{"D1_COD"  		, (_cAliQry)->B1_COD					, Nil})
						aAdd(_alinhaOr	,	{"D1_QUANT"		, _aSldB6[_ni][1]						, Nil})
						//aAdd(_alinhaOr	,	{"D1_VUNIT"		, _nPrcVn								, Nil}) // 15/03/16 - HELIMAR TAVARES
						//aAdd(_alinhaOr	,	{"D1_TOTAL"		, _aSldB6[_ni][1] *	_nPrcVn				, Nil}) // 15/03/16 - HELIMAR TAVARES
						aAdd(_alinhaOr	,	{"D1_VUNIT"		, _aSldB6[_ni][6]						, Nil})
						aAdd(_alinhaOr	,	{"D1_TOTAL"		, _aSldB6[_ni][1] * _aSldB6[_ni][6]	, Nil})
						aAdd(_alinhaOr	,	{"D1_TES"		, _cMvTsOr								, Nil})
						aAdd(_alinhaOr	,	{"D1_LOCAL"		, "06"									, Nil})
						/*
						cQry := "SELECT B6_SALDO,D2_ITEM, D2_IDENTB6 FROM "+RetSqlName("SD2")+" D2
						
						cQry += " JOIN "+RetSqlName("SB6")+" SB6 "+cEnt
						cQry += " ON B6_FILIAL = D2_FILIAL "+cEnt
						cQry += " AND B6_DOC = D2_DOC "+cEnt
						cQry += " AND B6_SERIE = D2_SERIE "+cEnt
						cQry += " AND B6_PRODUTO = D2_COD "+cEnt
						cQry += " AND B6_CLIFOR = D2_CLIENTE "+cEnt
						cQry += " AND B6_LOJA = D2_LOJA "+cEnt
						cQry += " AND SB6.D_E_L_E_T_ <> '*' "+cEnt
						cQry += " AND SB6.B6_IDENT = D2.D2_IDENTB6 "+cEnt
																				
						cQry += " WHERE D2_FILIAL = '"+_cEmpFl+"'
						cQry += " AND D2_DOC = '"+_aSldB6[_ni][2]+"'
						cQry += " AND D2_SERIE = '"+_aSldB6[_ni][3]+"'
						cQry += " AND D2_COD = '"+(_cAliQry)->B1_COD+"'
						cQry += " AND D2.D_E_L_E_T_ = ' '
						If Select(_cAliQryX) > 0
							dbSelectArea(_cAliQryX)
							(_cAliQryX)->(dbCloseArea())
						EndIf
						
						dbUseArea(.T., "TOPCONN", TcGenQry(,,cQry), _cAliQryX, .F., .T.)
						
						cItOri	:= ""
						cIdent	:= ""
						While (_cAliQryX)->(!EOF())							
							If (_cAliQryX)->B6_SALDO >= _aSldB6[_ni][1]
								cItOri	:= (_cAliQryX)->D2_ITEM
								cIdent	:= (_cAliQryX)->D2_IDENTB6
								Exit
							EndIf							
							(_cAliQryX)->(DbSkip())	
						EndDo

						aAdd(_alinhaOr	,	{"D1_NFORI"		, _aSldB6[_ni][2]						, Nil})
						aAdd(_alinhaOr	,	{"D1_SERIORI"	, _aSldB6[_ni][3]						, Nil})						
						aAdd(_alinhaOr	,	{"D1_ITEMORI"	, cItOri	   							, Nil})
						aAdd(_alinhaOr	,	{"D1_IDENTB6"	, cIdent			 					, Nil}) // 03/02 - RAFAEL LEITE										
                        */
						aAdd(_alinhaOr	,	{"D1_NFORI"		, _aSldB6[_ni][2]						, Nil})
						aAdd(_alinhaOr	,	{"D1_SERIORI"	, _aSldB6[_ni][3]						, Nil})						
						aAdd(_alinhaOr	,	{"D1_ITEMORI"	, PADR(AllTrim(_aSldB6[_ni][4]),TAMSX3("C6_ITEMORI")[1]) , Nil})
						aAdd(_alinhaOr	,	{"D1_IDENTB6"	, PADR(AllTrim(_aSldB6[_ni][7]),TAMSX3("C6_IDENTB6")[1]) , Nil}) // 03/02 - RAFAEL LEITE										                        
						
						If Select(_cAliQryX) > 0
							dbSelectArea(_cAliQryX)
							(_cAliQryX)->(dbCloseArea())
						EndIf
						
						aadd(_aItmDcOr,_alinhaOr)
						_alinhaOr := {}
						_cContC6 := Soma1(_cContC6)
						
						_nVUnit := _nVUnit + _aSldB6[_ni][6] // 15/03/16 - HELIMAR TAVARES
					Next _ni
					
					//�������������������������������������������������������������H����H����H����H
					//�Calcular oos campos customizados de quantidade e valor total empresa Origem�
					//�������������������������������������������������������������H������H������H�
					_nQdTtOr += _nQuant
					_nVlTtOr += _nVUnit //_nQuant * _nPrcVn  // 15/03/16 - HELIMAR TAVARES
					
					_nContOr ++
					
					//�������������������������������������������������������������H����H����H����H
					//�Calcular oos campos customizados de quantidade e valor total empresa Matriz�
					//�������������������������������������������������������������H������H������H�
					_nQtdTot += _nQuant
					_nValTot += _nVUnit //_nQuant * _nPrcVn  // 15/03/16 - HELIMAR TAVARES
					
					_alinhaDe := {}
				Else
					//���������������������������������� �
					//�Fun��o para alimentar Log de erro�
					//���������������������������������� �
					_cMsg := "Valor informado na tabela de pre�o: " + AllTrim(_cMvTbPr) + " n�o pode ser menor ou igual a 0 (ZERO), produto: " + AllTrim((_cAliQry)->B1_COD)
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
				EndIf
				(_cAliQry)->(DbSkip())
			EndDo
						
			If Len(_aItmPv) > 0
				//���������������������������������������������������������������������������Ŀ
				//�Alimentando o cabe�alho do Pedido de Vendas com as informa��es customizadas�
				//�����������������������������������������������������������������������������
				aAdd ( _aCabPv , { "C5_XQTDTOT"    , _nQtdTot      	, Nil} )
				aAdd ( _aCabPv , { "C5_XVALTOT"    , _nValTot      	, Nil} )
				aAdd ( _aCabPd , { "C5_XQTDTOT"    , _nQdTtOr      	, Nil} )
				aAdd ( _aCabPd , { "C5_XVALTOT"    , _nVlTtOr      	, Nil} )
				
				//Zerando as Vari�veis
				_nQtdTot := 0
				_nValTot := 0
				_nQdTtOr := 0
				_nVlTtOr := 0
				
				//���������������������������������������������������
				//�Caso n�o tenha dado problema na regra de descontos�
				//���������������������������������������������������
				If !_lVcDesc
					
					//Realizando a gera��o da Nota de Sa�da para devolu��o de Consigna��o
					//na empresa Matriz (GEN)
					_cNtDvCon := U_GENA064B(_aCabPv,_aItmPv)
					
					If !Empty(_cNtDvCon)
						
						//�����������������������������������������������������������������Ŀ
						//�Realizando a nova conex�o para entrar na empresa e filial correta�
						//�������������������������������������������������������������������
						If ValType(_oServer) == "O"
							//Fecha a Conexao com o Servidor
							RESET ENVIRONMENT IN SERVER _oServer
							CLOSE RPCCONN _oServer
							_oServer := Nil
						EndIf
						
						conout(Time()+ " " + "GENA064 - Inicio do RPC para logar na empresa origem Pedido/Nota de Sa�da")
						conout(Time()+ " " + "GENA064 - Empresa: " + _cEmpCd + " Filial: " + _cEmpFl)
						
						_cTemp1 := U_GravArq1(_aItmPd)
						_cTemp2 := U_GravArq1(_aItmDcOr)
						
						CREATE RPCCONN _oServer ON  SERVER _cServ 			;   //IP do servidor
						PORT  _nPort           								;   //Porta de conex�o do servidor
						ENVIRONMENT _cAmb       							;   //Ambiente do servidor
						EMPRESA _cEmpCd          							;   //Empresa de conex�o
						FILIAL  _cEmpFl          							;   //Filial de conex�o
						TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que ser�o abertas
						MODULO  "SIGAFAT"               					//M�dulo de conex�o
						
						If ValType(_oServer) == "O"
							_oServer:CallProc("RPCSetType", 2)
							_cNotaImp := ""
							_cNotaImp := _oServer:CallProc("U_GENA064C",_aCabPd,_cTemp1,_aCabDcOr,_cTemp2,_cNtDvCon,dDatabase)
							//�����������������������������������������������������������������Ŀ
							//�Realizando a nova conex�o para entrar na empresa e filial correta�
							//�������������������������������������������������������������������
							//Fecha a Conexao com o Servidor
							RESET ENVIRONMENT IN SERVER _oServer
							CLOSE RPCCONN _oServer
							_oServer := Nil
						Else
							conout(Time()+ " " + "GENA064 - Nao foi possivel logar. Retorno para empresa origem nao executado.")
						EndIf
						
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

MemoWrite ( _cLogPd +"log_prod_sem_saldo.txt" , _cLogSld )
						
conout(Time()+ " " + "GENA064A - Fim - Verificando Itens da Nota de Entrada")
RestArea(_aArea)

Return()


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA064B  �Autor  �Angelo Henrique     � Data �  17/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina respons�vel por gerar a Nota Fiscal de Sa�da para    ���
���          �devolu��o da Consigna��o - Presta��o de Contas              ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA064B(_aCabPv,_aItmPv)

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
Local _cLogPd			:= GetMv("GEN_FAT146") //Cont�m o caminho que ser� gravado o log de erro
Local _cMvSeri 			:= GetMv("GEN_FAT026") //SERIE nota de sa�da
Local _cMvEsp			:= GetMv("MV_ESPECIE") //Contem tipos de documentos fiscais utilizados na emissao de notas fiscais
Local _aPosEsp 			:= {}
Local _nMvEsp 			:= 0
Local _lEspec			:= .F.
Local _ni				:= 0

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

//����������������������������������������������������������Ŀ
//�Ponteramento nas tabelas para n�o ocorrer erro no execauto�
//������������������������������������������������������������

DbSelectArea("SA1")
DbSelectArea("SA2")

DbSelectArea("SC5")
DbSetOrder(1)

conout(Time()+ " " + "GENA064B - Rotina para execu��o do Execauto de Gera��o do Pedido de Vendas e de Gera��o do Documento de Sa�da, empresa Matriz (GEN)")

lMsErroAuto := .F.
MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,3)

If !lMsErroAuto
	
	conout(Time()+ " " + "GENA064B - Gerou com sucesso o pedido, ir� ver se existe a necessidade de desbloquear por cr�dito na empresa Matriz (GEN)")
	
	//�������������������������������������������������������������������������������������X�
	//� Inicio Rotina para desbloquear cr�dito para que o pedido seja faturado sem problemas�
	//�������������������������������������������������������������������������������������X�
	
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
		conout(Time()+ " " + "GENA064B - Ira varrer a SC9 para realizar o desbloqueio por cr�dito na empresa Matriz (GEN)")
		
		While ( (_cAliSC9)->(!Eof()) .And. (_cAliSC9)->C9_FILIAL == xFilial("SC9") .And. (_cAliSC9)->C9_PEDIDO == SC5->C5_NUM .And. Eval(bValid) )
			If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .OR. (SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .OR.;
				SC9->C9_BLCRED=="09" )
				conout(Time()+ " " + "GENA064B - Libera��o de Cr�dito do Pedido de Vendas na empresa Matriz (GEN)")
				
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
	
	//�������������������������������������������������������������������������������������X�
	//� Fim    Rotina para desbloquear cr�dito para que o pedido seja faturado sem problemas�
	//�������������������������������������������������������������������������������������X�
	
	//���������������������������������������������������������������������������������������������������������X�
	//'Inicio - Caso tenha ocorrido com sucesso a gera��o do Pedido de Vendas, ir� iniciar a gera��o da Nota   '*
	//���������������������������������������������������������������������������������������������������������X�	DbSelectArea("SC9")
	DbSelectArea("SC9")
	DbSetOrder(1)
	If DbSeek(xFilial("SC9")+SC5->C5_NUM)
		
		_cPedExc := SC9->C9_PEDIDO
		conout(Time()+ " " + "GENA064B - Inicio da Gera��o do Documento de Sa�da na empresa Matriz (GEN).")
		
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
		
		conout(Time()+ " " + "GENA064B - Ira realizar a geracao da nota de saida na empresa Matriz (GEN) ")
		
		*'---------------------------------------------------------'*
		*'Rotina utilizada para realizar a gera��o da Nota de Sa�da'*
		*'---------------------------------------------------------'*
		
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
		
		//_cPedExc := SC9->C9_PEDIDO
		//If _lEspec
		
		If _lEspec .and. _nConfLib == _nConfVen // 04/02 RAFAEL LEITE - VERIFICA QUANTIDADE LIBERADA
			
			_cNotaImp := MaPVlNFs(_aPVlNFs,_cMvSeri,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)
			
		Elseif !_lEspec
			
			_cNotaImp := ""
			_cMsg := "A Nota n�o foi gerada, pois a serie n�o esta preenchida corretamente." + cEnt
			_cMsg += "Favor revisar o parametro GEN_FAT003." + cEnt
			conout(Time()+ " " + _cMsg)
			MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )
			
		Elseif !_nConfLib == _nConfVen //04/02 - RAFAEL LEITE
			
			_cNotaImp := ""
			_cMsg := "A quantidade liberada esta diferente da informada no pedido." + cEnt
			conout(Time()+ " " + _cMsg)
			MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )
		EndIf
		
		//�������������������������������������������������������Ŀ
		//�Caso a nota n�o seja gerado ir� chamar a rotina de erro�
		//���������������������������������������������������������
		If Empty(AllTrim(_cNotaImp))
			conout(Time()+ " " + "GENA064B - Gera��o do Documento de Sa�da na empresa Matriz (GEN) apresentou erro .")
			//_cPedExc := SC9->C9_PEDIDO
			
			//�����������������������������������������������������������Ŀ
			//�Chamando o Execauto de Altera��o e em seguida o de exclus�o�
			//�������������������������������������������������������������
			
			//�������������������������������Ŀ
			//�Alterando a quantidade liberada�
			//���������������������������������
			For _ni := 1 To Len(_aItmPv)
				_aItmPv[_ni][_nPosLb][2] := 0
			Next _ni
			
			conout(Time()+ " " + "GENA064B - Ir� alterar o pedido de vendas para poder realizar a exclus�o na empresa Matriz (GEN)")
			
			lMsErroAuto := .F.
			MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,4)
			
			If !lMsErroAuto
				conout(Time()+ " " + "GENA064B - Alterou o pedido de vendas com sucesso, ir� realizar a exclus�o na empresa Matriz (GEN).")
				
				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,5)
				
				If !lMsErroAuto
					conout(Time()+ " " + "GENA064B - Excluiu com sucesso o pedido de vendas na empresa Matriz (GEN).")
					
					_cErroLg += "  " + cEnt
					_cErroLg += " O Pedido: " + _cPedExc + " foi exclu�do com sucesso. "  + cEnt
					_cErroLg += " Favor verificar o pedido: "  + cEnt
					_cErroLg += " Pois ele teve que ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
					_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois no processo houve erro. " + cEnt
					_cErroLg += " " + cEnt
					MemoWrite ( _cLogPd + "Emp" +SM0->M0_CODIGO + "_Fil_"+ AllTrim(SM0->M0_CODFIL) + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cErroLg )
				Else
					conout(Time()+ " " + "GENA064B - N�o conseguiu excluir o pedido de vendas na empresa Matriz (GEN).")
					
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
					MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cErroLg )
				EndIf
			Else
				conout(Time()+ " " + "GENA064B - N�o conseguiu alterar o pedido de vendas na empresa Matriz (GEN).")
				
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
				MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cErroLg )
			EndIf
		EndIf
	EndIf
Else
	conout(Time()+ " " + "GENA064B - N�o conseguiu gerar o Pedido de Vendas na empresa Matriz (GEN). ")
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
���Programa  �GENA064C  �Autor  �Angelo Henrique     � Data �  17/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina que ir� gerar a Nota fiscal de entrada para devolucao���
���          �da consigna��o e a Nota Fiscal de Sa�da de Venda.           ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GENA064C(_aCabPd,_cTemp1,_aCabDcOr,_cTemp2,_cNtDvCon,dProcPed)

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
Local _cLogPd			:= GetMv("GEN_FAT146")+DtoS(DDataBase)+"\"//Cont�m o caminho que ser� gravado o log de erro
Local _cMvSeri 			:= GetMv("GEN_FAT026") //SERIE nota de sa�da
Local _cEmp				:= AllTrim(SM0->M0_CODIGO)
Local _cFil				:= AllTrim(SM0->M0_CODFIL)
Local _cMvEsp			:= GetMv("MV_ESPECIE") //Contem tipos de documentos fiscais utilizados na emissao de notas fiscais
Local _aPosEsp 			:= {}
Local _nMvEsp 			:= 0
Local _lEspec			:= .F.
Local _aItmPd   		:= {}
Local _aItmDcOr   		:= {}
Local nAux06			:= 0

Local nPoProd			:= 0
Local nPoLocal			:= 0
Local _ni

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

If File(_cTemp1)
	_aItmPd := u_LeArq1(_cTemp1)
Endif

If File(_cTemp2)
	_aItmDcOr := u_LeArq1(_cTemp2)
Endif

DbSelectArea("SC5")
DbSetOrder(1)

conout(Time()+ " " + "GENA064C - Rotina de Gera��o da Nota Fiscal de Entrada (Devolu��o da Consigna��o) e Gera��o da Nota Fiscal de Sa�da da Venda na empresa Origem ")
conout(Time()+ " " + "GENA064C - Primeiro a Gera��o da Nota Fiscal de Entrada (Devolu��o da Consigna��o) da empresa origem")

DbSelectArea("SA1")
DbSelectArea("SA2")

nPoProd			:= aScan(_aItmDcOr[1],{|x| AllTrim(x[1]) == "D1_COD" })
nPoLocal		:= aScan(_aItmDcOr[1],{|x| AllTrim(x[1]) == "D1_LOCAL" })


For nAux06 := 1 To Len(_aItmDcOr)

	If !SB2->(dbSeek(xFilial("SB2")+_aItmDcOr[nAux06][nPoProd][2]+_aItmDcOr[nAux06][nPoLocal][2] ))
		RecLock("SB2",.T.)
		SB2->B2_FILIAL := xFilial("SB2")
		SB2->B2_COD    := _aItmDcOr[nAux06][nPoProd][2]
		SB2->B2_LOCAL  := _aItmDcOr[nAux06][nPoLocal][2]
		MsUnLock()
	EndIf	
	
Next


aAdd( _aCabDcOr, { "F1_DOC" ,_cNtDvCon })
MSExecAuto({|x,y,z|MATA103(x,y,z)},_aCabDcOr, _aItmDcOr,3)

If lMsErroAuto
	cMsg := "GENA064 - VENDA APARAS" + cEnt
	cMsg += cEnt
	cMsg += "Erro ao gerar documento de entrada "+_cNtDvCon+"/"+_cMvSeri+" - "+SM0->M0_CODFIL+" - "+alltrim(SM0->M0_NOMECOM)
	U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("Protheus Faturamento - Processo Aparas - Doc.Entra"),cMsg,,,.F.)			
		
	_lRet := .F.
	conout(Time()+ " " + "GENA064C - N�o conseguiu gerar a Nota Fiscal de Entrada (Devolu��o da Consigna��o) na empresa origem. ")
	_aErro := GetAutoGRLog()
	_cErroLg	:= ""
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + cEnt
		conout(_cErroLg)
	Next _ni
	MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraDocEntrada.txt" , _cErroLg )
	Disarmtransaction()
Else

	//DISPARA EMAIL AVISANDO SOBRE DOC DE SAIDA GERADO
	cDest := Alltrim(GetMv("GEN_FAT078"))
	If !Empty(cDest)
		cMsg := "GENA064 - VENDA APARAS" + cEnt
		cMsg += cEnt
		cMsg += "Foi gerado o documento de sa�da "+_cNtDvCon+"/"+_cMvSeri+" com "+cValToChar(len(_aItmDcOr))+" registro(s) para a empresa "+SM0->M0_CODFIL+" - "+alltrim(SM0->M0_NOMECOM) + cEnt
		U_GenSendMail(,,,"noreply@grupogen.com.br",cDest,oemtoansi("Protheus Faturamento - Processo Aparas"),cMsg,,,.F.)
	Endif
	
	Mov01To03(_cNtDvCon,_cMvSeri,_aCabDcOr,_aItmDcOr)		
EndIf

RestArea(_aArea)

Return(_cNotaImp)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA064   �Autor  �Microsiga           � Data �  08/12/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Mov01To03(_cNtDvCon,_cMvSeri,_aCabDcOr,_aItmDcOr)

Local lRet		:= .F.
Local cLogPd	:= AllTrim(GetMv("GEN_FAT146"))+"LogTransf\"+DtoS(DDataBase)+"\" //Cont�m o caminho que ser� gravado o log de erro
Local nPProd	:= aScan(_aItmDcOr[1], {|x| AllTrim(x[1]) == "D1_COD" } )
Local nPQtd		:= aScan(_aItmDcOr[1], {|x| AllTrim(x[1]) == "D1_QUANT" } )
Local nPLoc		:= aScan(_aItmDcOr[1], {|x| AllTrim(x[1]) == "D1_LOCAL" } )
Local nPIte		:= aScan(_aItmDcOr[1], {|x| AllTrim(x[1]) == "D1_ITEM" } )
Local nPFor		:= aScan(_aCabDcOr, {|x| AllTrim(x[1]) == "F1_FORNECE" } )
Local nPcli		:= aScan(_aCabDcOr, {|x| AllTrim(x[1]) == "F1_LOJA" } )
Local nPDoc		:= aScan(_aCabDcOr, {|x| AllTrim(x[1]) == "F1_DOC" })
Local nPSerie	:= aScan(_aCabDcOr, {|x| AllTrim(x[1]) == "F1_SERIE" })
Local cDest 	:= Alltrim(GetMv("GEN_FAT078"))
Local cChave	:= ""
Local aChave	:= {} 
Local lTransf	:= .F.
						
Local aTransfer	:= {}	
Local cNumDoc	:= ""
Local aTransfer	:= {}
Local cProduto	:= ""
Local cLocOri	:= SuperGetMv("GEN_EST003",.F.,"01")
Local nQuant	:= 0
Local nQatu		:= 0
Local cLocDes	:= "" 
Local cMsgVld	:= ""
Local cLogSld	:= ""
Local aTraSaldo	:= {}
Local cMonitMail	:= GetMv("GEN_EST008")//e-mail de monitoramento aparas
Local lItDCF		:= SuperGetMv("GEN_EST009",.F.,.F.)
Local nAuxMv,_ni,nMvtAux

WFForceDir(cLogPd)

DbSelectArea("SB1")
SB1->(DbSetOrder(1))
aTransfer	:= {{cNumDoc,DDataBase}}

DbSelectArea("SB2")
SB2->(dbSetOrder(1))

For nAuxMv := 1 To Len(_aItmDcOr)
	
	cChave	:= Padr(AllTrim(_cNtDvCon),TamSX3("F1_DOC")[1])+;
				Padr(AllTrim(_cMvSeri),TamSX3("F1_SERIE")[1])+;
				Padr(AllTrim(_aCabDcOr[nPFor][2]),TamSX3("F1_FORNECE")[1])+;
				Padr(AllTrim(_aCabDcOr[nPcli][2]),TamSX3("F1_LOJA")[1])	
				
	nPosSld := aScan(aTraSaldo, { |x| x[1] == _aItmDcOr[nAuxMv][nPProd][2]  } )
	
	If nPosSld == 0
		Aadd(aTraSaldo, { _aItmDcOr[nAuxMv][nPProd][2] , 0 , _aItmDcOr[nAuxMv][nPLoc][2] , cChave } )
		nPosSld	:= Len(aTraSaldo)
	EndIf
	
	aTraSaldo[nPosSld][2] := aTraSaldo[nPosSld][2]+_aItmDcOr[nAuxMv][nPQtd][2]	
	
Next
	
For nAuxMv := 1 To Len(aTraSaldo)
	
	/*
	cChave	:= Padr(AllTrim(_cNtDvCon),TamSX3("F1_DOC")[1])+;
				Padr(AllTrim(_cMvSeri),TamSX3("F1_SERIE")[1])+;
				Padr(AllTrim(_aItmDcOr[nAuxMv][nPIte][2]) , TamSX3("D1_ITEM")[1] )+;
				Padr(AllTrim(_aCabDcOr[nPFor][2]),TamSX3("F1_FORNECE")[1])+;
				Padr(AllTrim(_aCabDcOr[nPcli][2]),TamSX3("F1_LOJA")[1])
	*/

	cChave	:= aTraSaldo[nAuxMv][4]

	SB1->(DbSeek(xFilial("SB1")+ aTraSaldo[nAuxMv][1] ))
	nQatu		:= 0
	cNumDoc		:= NextNumero("SD3",2,"D3_DOC",.T.)		
	cProduto	:= SB1->B1_COD
	nQuant		:= aTraSaldo[nAuxMv][2]//_aItmDcOr[nAuxMv][nPQtd][2]
	cLocDes		:= aTraSaldo[nAuxMv][3]//_aItmDcOr[nAuxMv][nPLoc][2]

	If !SB2->(dbSeek(xFilial("SB2")+cProduto+cLocOri))
		cLogSld += "Produto "+SB1->B1_COD+" n�o tem saldo no armazem "+cLocOri+" para ser transferido para o "+cLocDes+" na filial "+cFilAnt+", Sld."+cLocOri+":0, Qtd.Transf:"+Alltrim(Str(nQuant))+Chr(13)+chr(10)
		Loop
	ElseIf SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP) < nQuant 
		cLogSld += "Produto "+SB1->B1_COD+" n�o tem saldo no armazem "+cLocOri+" para ser transferido para o "+cLocDes+" na filial "+cFilAnt+", Sld."+cLocOri+":"+AllTrim(Str(SB2->B2_QATU))+", Qtd.Transf:"+Alltrim(Str(nQuant))+Chr(13)+chr(10)
		Loop	
	Else
		nQatu := SB2->B2_QATU
	EndIf
	
	If SB2->(dbSeek(xFilial("SB2")+cProduto+cLocDes))
		nQatu := SB2->B2_QATU
	Else
		nQatu := 0	
	EndIf
		
	/*	
	If Select("TMPSLD") > 0
		TMPSLD->(DbCloseArea())
	EndIf

	BeginSql Alias "TMPSLD"
		SELECT B2_QATU 
		FROM %Table:SB2% SB2
		WHERE B2_FILIAL = %xFilial:SB2%
		AND B2_COD = %Exp:SB1->B1_COD%
		AND B2_LOCAL = %Exp:cLocDes%
		AND SB2.%NotDel%				
	EndSql
	
	TMPSLD->(DbGoTop())
	nQatu := TMPSLD->B2_QATU
	TMPSLD->(DbCloseArea())
    */
    
    
	Aadd(aChave, { cNumDoc , cChave , SB1->B1_COD,cLocDes, nQatu, nQuant , 0} )
	
	If lItDCF
		AADD(aTransfer,{SB1->B1_COD,;		//1-PRODUTO ORIGEM
									SB1->B1_DESC,;	//2-DESCRICAO ORIGEM
			                      	    SB1->B1_UM,;	//3-UM ORIGEM
			                      	    cLocOri,;		//4-ARMAZEM DE ORIGEM
			                            " ",;			//5-ENDERECO ORIGEM
			                      	    SB1->B1_COD,;	//6-PRODUTO DESTINO
			                      	    SB1->B1_DESC,;	//7-DESCRICAO DESTINO
			                      	    SB1->B1_UM,;	//8-UM DESTINO
			                      	    cLocDes,;		//9-ARMAZEM DESTINO
			                            " ",;			//10-ENDERECO DESTINO
			                            " ",;			//11-NUMERO DE SERIE
			                      	    " ",;			//12-LOTE
			                      	    " ",;			//13-SUB-LOTE
			                      	    CtoD("  /  /  "),;			//14-VALIDADE
			                      	    0,;				//15-POTENCIA
			                      	    nQuant,;		//16-QUANTIDADE
			                      	    ConvUm(SB1->B1_COD,nQuant,0,2),; //17-QUANTIDADE SEGUNDA UM
			                      	    Space(10),;		//18-ESTORNADO
			                      	    "      " 		/*cNumDoc*/,; //19-SEQUENCIA
			                      	    " ",; 			//20-LOTE DESTINO
			                      	    CtoD("  /  /  "),; 			//21-VALIDADE DESTINO
			                      	    Space(3),;//22 - Item Grade D3_ITEMGRD  C         3       0
			                      	    Space(6),;//23 - Id DCF     D3_IDDCF    C         6       0
			                      	    "transferencia aparas";//24 - Observa��o D3_OBSERVA  C        30       0
			                      	    })	
	Else
		AADD(aTransfer,{SB1->B1_COD,;		//1-PRODUTO ORIGEM
							SB1->B1_DESC,;	//2-DESCRICAO ORIGEM
	                      	    SB1->B1_UM,;	//3-UM ORIGEM
	                      	    cLocOri,;		//4-ARMAZEM DE ORIGEM
	                            " ",;			//5-ENDERECO ORIGEM
	                      	    SB1->B1_COD,;	//6-PRODUTO DESTINO
	                      	    SB1->B1_DESC,;	//7-DESCRICAO DESTINO
	                      	    SB1->B1_UM,;	//8-UM DESTINO
	                      	    cLocDes,;		//9-ARMAZEM DESTINO
	                            " ",;			//10-ENDERECO DESTINO
	                            " ",;			//11-NUMERO DE SERIE
	                      	    " ",;			//12-LOTE
	                      	    " ",;			//13-SUB-LOTE
	                      	    CtoD("  /  /  "),;			//14-VALIDADE
	                      	    0,;				//15-POTENCIA
	                      	    nQuant,;		//16-QUANTIDADE
	                      	    ConvUm(SB1->B1_COD,nQuant,0,2),; //17-QUANTIDADE SEGUNDA UM
	                      	    Space(10),;		//18-ESTORNADO
	                      	    "      " 		/*cNumDoc*/,; //19-SEQUENCIA
	                      	    " ",; 			//20-LOTE DESTINO
	                      	    CtoD("  /  /  "),; 			//21-VALIDADE DESTINO
	                      	    Space(3),;//22 - Item Grade D3_ITEMGRD  C         3       0
	                      	    "transferencia aparas";//23 - Observa��o D3_OBSERVA  C        30       0
	                      	    })
	EndIf	                      	    
                      	    
Next
	
For nAuxMv := 2 To Len(aTransfer)
	If !SB2->(dbSeek(xFilial("SB2")+aTransfer[nAuxMv][1]+aTransfer[nAuxMv][9]))
		RecLock("SB2",.T.)
		SB2->B2_FILIAL := xFilial("SB2")
		SB2->B2_COD    := aTransfer[nAuxMv][1]
		SB2->B2_LOCAL  := aTransfer[nAuxMv][9]
		MsUnLock()
	EndIf	
Next     

If !Empty(cLogSld)
	cMsg := "GENA064 - TRANSFERENCIA APARAS" + cEnt
	cMsg += cLogSld
	MemoWrite(cLogPd+"Emp"+"_"+cFilAnt+"_"+DTOS(ddatabase)+ "_" + SUBSTR(STRTRAN(Time(),":",""),1,4)+"_"+AllTrim(_cNtDvCon)+"_"+AllTrim(_cMvSeri)+"_"+AllTrim(_aCabDcOr[nPFor][2])+"_"+AllTrim(_aCabDcOr[nPcli][2])+"_Transferencia.log",cLogSld)	
	U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("Protheus Faturamento - Processo Aparas - Transferencia"),cMsg,,,.F.)				
EndIf

lMsHelpAuto := .T. // Se .t. direciona as msgs de help para o arq. de log.
lMsErroAuto := .F. // Nessecario a criacao, pois sera atualizado quando houver alguma inconsistencia nos parametros

Begin Transaction
	MSExecAuto({|x,y| Mata261(x,y)},aTransfer,3)

	If lMsErroAuto   				
		lTransf	:=.F.
		cMsg := "GENA064 - TRANSFERENCIA APARAS" + cEnt
		cMsg += cEnt
		cMsg += "Erro n�o transferir o documento "+_cNtDvCon+"/"+_cMvSeri+" - "+SM0->M0_CODFIL+" - "+alltrim(SM0->M0_NOMECOM)+ cEnt

		_aErro := GetAutoGRLog()
		For _ni := 1 To Len(_aErro)
			cMsg += _aErro[_ni] + cEnt
			conout(cMsg)
		Next _ni
			
		MemoWrite(cLogPd+"Emp"+"_"+cFilAnt+"_"+DTOS(ddatabase)+ "_" + SUBSTR(STRTRAN(Time(),":",""),1,4)+"_"+Padr(AllTrim(_cNtDvCon),TamSX3("F1_DOC")[1])+"_"+Padr(AllTrim(_cMvSeri),TamSX3("F1_SERIE")[1])+"_"+Padr(AllTrim(_aCabDcOr[nPFor][2]),TamSX3("F1_FORNECE")[1])+"_"+Padr(AllTrim(_aCabDcOr[nPcli][2]),TamSX3("F1_LOJA")[1])+"_Transferencia.log",cMsg)
		
		U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("Protheus Faturamento - Processo Aparas - Transferencia"),cMsg,,,.F.)			
		
		Disarmtransaction()
	Else
		lTransf	:=.T.
		For nMvtAux := 1 To Len(aChave)			
			cUpdAux	:= ""
			cUpdAux += " UPDATE "+RetSqlName("SD3")+" SET D3_XCHVSD1 = '"+aChave[nMvtAux][2]+"'"
			cUpdAux += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'"
			cUpdAux += " AND D3_DOC = '"+aChave[nMvtAux][1]+"'"
			cUpdAux += " AND D3_COD = '"+aChave[nMvtAux][3]+"'"
	//		cUpdAux += " AND D3_LOCAL = '"+aChave[nMvtAux][4]+"'"
			cUpdAux += " AND D3_EMISSAO = '"+DtoS(DDataBase)+"'"
			cUpdAux += " AND D_E_L_E_T_ <> '*'"			
			If (TCSqlExec(cUpdAux) < 0)
				Disarmtransaction()
				Memowrite(cLogPd,"TCSQLError()" + TCSQLError())
				cMsg := "GENA064 - TRANSFERENCIA APARAS" + cEnt
				cMsg += cEnt
				cMsg += "Erro ao atualizar a chava de transferir para documento "+_cNtDvCon+"/"+_cMvSeri+" - "+SM0->M0_CODFIL+" - "+alltrim(SM0->M0_NOMECOM)
				U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("Protheus Faturamento - Processo Aparas - Transferencia"),cMsg,,,.F.)
			EndIf					
		Next			
	EndIf
End Transaction

If lTransf

	SB2->(DbSetOrder(1))

	cMsg := "GENA064 - TRANSFERENCIA APARAS" + cEnt
	cMsg += cEnt
	cMsg += "Realizada transferencia do documento "+_cNtDvCon+"/"+_cMvSeri+" Armazem 01 para 06 - "+SM0->M0_CODFIL+" - "+alltrim(SM0->M0_NOMECOM)
	U_GenSendMail(,,,"noreply@grupogen.com.br",cDest,oemtoansi("Protheus Faturamento - Processo Aparas - Transferencia"),cMsg,,,.F.)			
	
	For nMvtAux := 1 To Len(aChave)

		If !SB2->(dbSeek(xFilial("SB2")+aChave[nMvtAux][3]+aChave[nMvtAux][4]))
			aChave[nMvtAux][7] := 0
		Else	
			aChave[nMvtAux][7] := SB2->B2_QATU
		EndIf
		
		/*
		If Select("TMPSLD") > 0
			TMPSLD->(DbCloseArea())
		EndIf
	
		BeginSql Alias "TMPSLD"
			SELECT B2_QATU 
			FROM %Table:SB2% SB2
			WHERE B2_FILIAL = %xFilial:SB2%
			AND B2_COD = %Exp:aChave[nMvtAux][3]%
			AND B2_LOCAL = %Exp:aChave[nMvtAux][4]%
			AND SB2.%NotDel%				
		EndSql
		
		TMPSLD->(DbGoTop())
		aChave[nMvtAux][7] := TMPSLD->B2_QATU
		TMPSLD->(DbCloseArea())		
		*/
	Next
	// { cNumDoc , cChave , SB1->B1_COD,cLocDes, nQatu, nQuant , 0} 
	For nMvtAux := 1 To Len(aChave)
		If aChave[nMvtAux][7] - aChave[nMvtAux][5] <> aChave[nMvtAux][6]
			cMsgVld += "Inconstencia no saldo final para obra: "+aChave[nMvtAux][3]+", Sld.Ini: "+AllTrim(Str(aChave[nMvtAux][5]))+", Sld.final:"+AllTrim(Str(aChave[nMvtAux][7]))+", Sld.Mov:"+AllTrim(Str(aChave[nMvtAux][6]))+cEnt
		EndIf            
	Next	
	
	If !Empty(cMsgVld)
		cMsg := "GENA064 - TRANSFERENCIA APARAS" + cEnt
		cMsg += cEnt
		cMsg += "Inconsistencia de saldo pos transferencia "+_cNtDvCon+"/"+_cMvSeri+" - "+SM0->M0_CODFIL+" - "+alltrim(SM0->M0_NOMECOM)
		MemoWrite ( cLogPd + "Emp_Fil_Erro_Saldo_Transf_"+ cFilAnt + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Doc" + _cMvSeri + "_Transferencia.txt" , cMsg )		
		U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("Protheus Faturamento - Processo Aparas - Transferencia"),cMsg,,,.F.)					
	endIf
EndIf

	
Return lRet
