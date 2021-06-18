#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

#DEFINE cEnt Chr(13)+Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA012   �Autor  �Angelo Henrique     � Data �  29/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina utilizada para gerar a Reconsigna��o                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA012

Local _aArea	:= GetArea()
Local _aArB6	:= SB6->(GetArea())
Local _cFilGen	:= GETMV("GEN_FAT035")

If(Aviso("Aviso","Esse programa realizar� a Reconsigna��o na filial logada, Deseja coninuar?",{"Sim","N�o"})) == 1
	
	//���������������������������������������������������������D
	//�Valida��o para saber se a filial logada � da empresa GEN�
	//�pois o tratamento � diferente quando for na GEN         �
	//���������������������������������������������������������D
	If _cFilGen != xFilial("SB6")
		
		Processa({|| U_GENA012A()},"Processando...")
		
	Else
		
		Processa({|| U_GENA012B()},"Processando...")
		
	EndIf
	
EndIf

RestArea(_aArB6)
RestArea(_aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA012A  �Autor  �Angelo Henrique     � Data �  29/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina respons�vel pela execu��o da reconsigna��o para      ���
���          �filial que n�o � a empresa GEN                              ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA012A

Local _aArea	:= GetArea()
Local _cQuery	:= ""
Local _cAliQry	:= GetNextAlias()
Local _aCabGen	:= {}
Local _aCabOri	:= {}
Local _cTrpPv	:= ""
Local _cTipPv 	:= ""
Local _cVenPv 	:= ""
Local _cCliGen  := ""
Local _cLojGen  := ""
Local _cTrpGen  := ""
Local _cTipGen  := ""
Local _cVenGen  := ""
Local _aCabDcEn := {} //Vetor contendo o cabe�alho documento de entrada empresa Matriz
Local _aItmDcEn := {} //Vetor contendo os itens do documento de entrada empresa Matriz
Local _aCabDcOr := {} //Vetor contendo o cabe�alho documento de entrada empresa Origem
Local _aItmDcOr := {} //Vetor contendo os itens do documento de entrada empresa Origem
Local _cCGCGen  := ""
Local _cCGCOri  := ""
Local _cFnGen 	:= ""
Local _cLjGen 	:= ""
Local _cEmp		:= AllTrim(SM0->M0_CODIGO)
Local _cFil		:= AllTrim(SM0->M0_CODFIL)
Local _cCGCM0	:= AllTrim(SM0->M0_CGC)
Local _cForn  	:= ""
Local _cLojFn 	:= ""
Local _cCliOri  := ""
Local _cLojOri  := ""
Local _lVcDesc  := .F.
Local _cAliQry1	:= GetNextAlias()
Local _cAliQry2	:= GetNextAlias()
Local _cAliQry3	:= GetNextAlias()
Local _cAliQry4	:= GetNextAlias()
Local _cAliQry5	:= GetNextAlias()
Local _nDesc	:= 0
Local _nPrcVn	:= 0
Local _dDtAco	:= CTOD(" \ \")
Local _cMsg		:= ""
Local _nContOr	:= 0
Local _aItmPd 	:= {}
Local _alinha 	:= {}
Local _aItmPv 	:= {}
Local _nQtdTot 	:= 0
Local _nValTot 	:= 0
Local _aArM0	:= {}
Local _lEmp 	:= .F.
Local _cEmpCd 	:= ""
Local _cEmpFl 	:= ""
Local _oServer	:= Nil
Local _cNotaImp	:= ""
Local _cNotaOri	:= ""

Local _cCliPv	:= GetMv("GEN_FAT033") //Parametro que contem o codigo do cliente GEN
Local _cLjPv 	:= GetMv("GEN_FAT034") //Parametro que contem a loja do cliente GEN
Local _cFil		:= GetMv("GEN_FAT035") //Parametro que contem o codigo da filial da empresa GEN, utilizada em validacoes da reconsignacao
Local _cMvTbPr 	:= GetMv("GEN_FAT036") //Cont�m a tabela de pre�o usado no pedido de vendas na empresa Matriz e Origem
Local _cMvCdPv 	:= GetMv("GEN_FAT037") //Condi��o de pagamento pedido de venda
Local _cMvSeri 	:= GetMv("GEN_FAT038") //Serie da nota de sa�da de entrada nas empresas Matriz e Origem
Local _cMvEspc 	:= GetMv("GEN_FAT039") //Cont�m a especie utilizada na nota de entrada das empresas Matriz e Origem
Local _cMvCdDe	:= GetMv("GEN_FAT040") //Cont�m a condi��o de pagamento utilizada na nota de entrada das empresas Matriz e Origem
Local _cLogPd	:= GetMv("GEN_FAT041") //Cont�m o caminho que ser� gravado o log de erro
Local _cMvTsPd	:= GetMv("GEN_FAT044") //Cont�m o TES utilizado no Pedido de Vendas das empresas Matriz
Local _cMvTsOr	:= GetMv("GEN_FAT045") //Cont�m o TES utilizado na nota de entrada das empresas Origem
Local _cServ 	:= GetMv("GEN_FAT046") //Cont�m o Ip do servidor para realizar as mudan�as de ambiente
Local _nPort  	:= GetMv("GEN_FAT047") //Cont�m a porta para realizar as mudan�as de ambiente
Local _cAmb  	:= GetMv("GEN_FAT048") //Cont�m o ambiente a ser utilizado para realizar as mudan�as de filial   
Local _cMvTsPv	:= GetMv("GEN_FAT049") //Cont�m o TES utilizado no Pedido de Vendas das empresas Origem
Local _cTesEn	:= GetMv("GEN_FAT050") //Cont�m o TES utilizado na nota de entrada das empresas Matriz

//�����������������������������������������������������������������������H�
//�Pegando informa��es do cliente/fornecedor (empresa origem)  para serem �
//�colocados na nota de sa�da na empresa GEN                   			  �
//�����������������������������������������������������������������������H�
DbSelectArea("SA2")
DbSetOrder(3)
If DbSeek(xFilial("SA2")+_cCGCM0)
	
	_cCliOri  := SA1->A1_COD
	_cLojOri  := SA1->A1_LOJA
	
EndIf

//���������������������������������������������������a
//�Realizando a busca por saldo em poder de terceiros�
//���������������������������������������������������a

_cQuery := " SELECT B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO, B6_DOC, " + cEnt
_cQuery += " B6_SERIE, B6_CLIFOR, B6_LOJA, B6_SALDO, D1_ITEM , B1_COD ,B1_PROC, B1_LOJPROC " + cEnt
_cQuery += " FROM " + RetSqlName("SB6") + " SB6, " + RetSqlName("SD1") + " SD1, " + RetSqlName("SB1") + " SB1 " + cEnt
_cQuery += " WHERE SB6.B6_DOC = SD1.D1_DOC " + cEnt
_cQuery += " AND SB6.B6_SERIE = SD1.D1_SERIE " + cEnt
_cQuery += " AND SB6.B6_PRODUTO = SD1.D1_COD " + cEnt
_cQuery += " AND SB6.B6_CLIFOR = SD1.D1_FORNECE " + cEnt
_cQuery += " AND SB6.B6_LOJA = SD1.D1_LOJA " + cEnt
_cQuery += " AND SB6.B6_PRODUTO = SB1.B1_COD " + cEnt
_cQuery += " AND SB6.D_E_L_E_T_ = '' " + cEnt
_cQuery += " AND SD1.D_E_L_E_T_ = '' " + cEnt
_cQuery += " AND SB1.D_E_L_E_T_ = '' " + cEnt
_cQuery += " AND SB6.B6_FILIAL = '" + _cFil + "' " + cEnt
_cQuery += " AND SD1.D1_FILIAL = '" + _cFil + "' " + cEnt
_cQuery += " AND SB6.B6_TIPO = 'D' " + cEnt
_cQuery += " AND SB6.B6_TPCF = 'F' " + cEnt
_cQuery += " AND SB6.B6_PODER3 = 'R' " + cEnt
_cQuery += " AND SB6.B6_SALDO > 0 " + cEnt
_cQuery += " AND SB6.B6_CLIFOR = '" + _cCliOri + "' " + cEnt
_cQuery += " AND SB6.B6_LOJA = '" + _cLojOri + "' " + cEnt
_cQuery += " ORDER BY B6_EMISSAO " + cEnt

_cQuery := ChangeQuery(_cQuery)

If Select(_cAliQry) > 0
	dbSelectArea(_cAliQry)
	(_cAliQry)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry, .F., .T.)

While (_cAliQry)->(!EOF())
	
	//�������������������������������������������������������������H�
	//�Pegando informa��es do cliente (empresa origem)  para serem �
	//�colocados na nota de sa�da na empresa GEN                   �
	//�������������������������������������������������������������H�
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+PADR(AllTrim((_cAliQry)->B1_PROC),TamSX3("A1_LOJA")[1])+PADR(AllTrim((_cAliQry)->B1_LOJPROC),TamSX3("A1_LOJA")[1]))
		
		_cCliGen := SA1->A1_COD
		_cLojGen := SA1->A1_LOJA
		_cTrpGen := SA1->A1_TRANSP
		_cTipGen := SA1->A1_TIPO
		_cVenGen := SA1->A1_VEND
		_cCGCGen := SA1->A1_CGC
		
		//���������������������������������������������������������D�
		//�Pegando informa��es do Fornecedor (empresa origem) para �
		//�serem utilizadas na gera��o da Nota de Entrada          �
		//���������������������������������������������������������D�
		DbSelectArea("SA2")
		DbSetOrder(3)
		If DbSeek(xFilial("SA2")+_cCGCGen)
			
			_cFnGen := SA2->A2_COD
			_cLjGen := SA2->A2_LOJA
			
			//�����������������������������������������������������������������������Ŀ
			//�Ponterar no cliente para pegar as informa��es pertinentes a empresa GEN�
			//�ser� utilizado na empresa origem para gerar a nota de sa�da            �
			//�������������������������������������������������������������������������
			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(xFilial("SA1")+PADR(AllTrim(_cCliPv),TamSX3("A1_LOJA")[1])+PADR(AllTrim(_cLjPv),TamSX3("A1_LOJA")[1]))
				
				_cTrpPv		:= SA1->A1_TRANSP
				_cTipPv 	:= SA1->A1_TIPO
				_cVenPv 	:= SA1->A1_VEND
				_cCGCOri 	:= SA1->A1_CGC
				
				_aArM0 := SM0->(GetArea())
				DbSelectArea("SM0")
				SM0->(DbGoTop())
				While SM0->(!EOF())
					
					If AllTrim(SM0->M0_CGC) == AllTrim(_cCGCOri)
						
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
				
				//�����������������������������������������������������Ŀ
				//�Se encontrar a empresa matriz no cadastro de empresas�
				//�ir� prosseguir com o processamento                   �
				//�������������������������������������������������������
				If _lEmp
					
					DbSelectArea("SA2")
					DbSetOrder(3)
					If DbSeek(xFilial("SA2")+_cCGCGen)
						
						_cForn  := SA2->A2_COD
						_cLojFn := SA2->A2_LOJA
						
						//������������������������������������Ġ�A�
						//�Pegando o produto na tabela de pre�o	  �
						//������������������������������������Ġ�A�
						DbSelectArea("DA0")
						DbSetOrder(1)
						If DbSeek(xFilial("DA0")+_cMvTbPr)
							
							//�������������������������������������������������
							//�Validando se a tabela de pre�o esta vigente�
							//�������������������������������������������������
							If DA0->DA0_DATATE > dDatabase .OR. Empty(DA0->DA0_DATATE)
								
								_aCabGen := {}
								_aCabOri := {}
								
								//����������������������������������������������������������������������Ŀ
								//�Array contendo o cabe�alho da pedido de vendas para a empresa Matriz	 �
								//������������������������������������������������������������������������
								
								aAdd ( _aCabGen , { "C5_TIPO"    , "D"      	, Nil} )
								aAdd ( _aCabGen , { "C5_CLIENTE" , _cCliGen 	, Nil} )
								aAdd ( _aCabGen , { "C5_LOJACLI" , _cLojGen 	, Nil} )
								aAdd ( _aCabGen , { "C5_CLIENT"  , _cCliGen		, Nil} )
								aAdd ( _aCabGen , { "C5_LOJAENT" , _cLojGen		, Nil} )
								aAdd ( _aCabGen , { "C5_TRANSP"  , _cTrpGen		, Nil} )
								aAdd ( _aCabGen , { "C5_TIPOCLI" , _cTipGen 	, Nil} )
								aAdd ( _aCabGen , { "C5_VEND1" 	 , _cVenGen 	, Nil} )
								aAdd ( _aCabGen , { "C5_CONDPAG" , _cMvCdOr		, Nil} )
								aAdd ( _aCabGen , { "C5_TABELA"  , _cMvTbPr		, Nil} )
								aAdd ( _aCabGen , { "C5_EMISSAO" , dDatabase	, Nil} )
								aAdd ( _aCabGen , { "C5_MOEDA" 	 , 1			, Nil} )
								aAdd ( _aCabGen , { "C5_TPLIB" 	 , "2"			, Nil} )
								
								//����������������������������������������������������������������������Ŀ
								//�Array contendo o cabe�alho da pedido de vendas para a empresa origem	 �
								//������������������������������������������������������������������������
								
								aAdd ( _aCabOri , { "C5_TIPO"    , "N"     		, Nil} )
								aAdd ( _aCabOri , { "C5_CLIENTE" , _cCliPv  	, Nil} )
								aAdd ( _aCabOri , { "C5_LOJACLI" , _cLjPv  		, Nil} )
								aAdd ( _aCabOri , { "C5_CLIENT"  , _cCliPv 		, Nil} )
								aAdd ( _aCabOri , { "C5_LOJAENT" , _cLjPv		, Nil} )
								aAdd ( _aCabOri , { "C5_TRANSP"  , _cTrpPv		, Nil} )
								aAdd ( _aCabOri , { "C5_TIPOCLI" , _cTipPv 		, Nil} )
								aAdd ( _aCabOri , { "C5_VEND1" 	 , _cVenPv 		, Nil} )
								aAdd ( _aCabOri , { "C5_CONDPAG" , _cMvCdPv		, Nil} )
								aAdd ( _aCabOri , { "C5_TABELA"  , _cMvTbPr		, Nil} )
								aAdd ( _aCabOri , { "C5_EMISSAO" , dDatabase	, Nil} )
								aAdd ( _aCabOri , { "C5_MOEDA" 	 , 1			, Nil} )
								aAdd ( _aCabOri , { "C5_TPLIB" 	 , "2"			, Nil} )
								
								//�������������������������������������������������������������
								//�Array contendo o cabe�alho da nota de entrada para a Matriz�
								//�������������������������������������������������������������
								
								_aCabDcEn := {} //Vetor contendo o cabe�alho documento de entrada empresa Matriz
								_aItmDcEn := {} //Vetor contendo os itens do documento de entrada empresa Matriz
								
								aadd(_aCabDcEn , {"F1_TIPO"   	,"N"		, Nil} )
								aadd(_aCabDcEn , {"F1_FORMUL" 	,"N"		, Nil} )
								aadd(_aCabDcEn , {"F1_SERIE"  	,_cMvSeri	, Nil} )
								aadd(_aCabDcEn , {"F1_EMISSAO"	,dDataBase	, Nil} )
								aadd(_aCabDcEn , {"F1_FORNECE"	,PADR(AllTrim(_cFnGen),TAMSX3("F1_FORNECE")[1])		, Nil} )
								aadd(_aCabDcEn , {"F1_LOJA"   	,_cLjGen	, Nil} )
								aadd(_aCabDcEn , {"F1_ESPECIE"	,_cMvEspc	, Nil} )
								aadd(_aCabDcEn , {"F1_COND"		,_cMvCdDe	, Nil} )
								
								//�������������������������������������������������������������
								//�Array contendo o cabe�alho da nota de entrada para a Origem�
								//�������������������������������������������������������������
								
								_aCabDcOr := {} //Vetor contendo o cabe�alho documento de entrada empresa Origem
								_aItmDcOr := {} //Vetor contendo os itens do documento de entrada empresa Origem
								
								aadd(_aCabDcOr , {"F1_TIPO"   	,"D"		, Nil} )
								aadd(_aCabDcOr , {"F1_FORMUL" 	,"N"		, Nil} )
								aadd(_aCabDcOr , {"F1_SERIE"  	,_cMvSeri	, Nil} )
								aadd(_aCabDcOr , {"F1_EMISSAO"	,dDataBase	, Nil} )
								aadd(_aCabDcOr , {"F1_FORNECE"	,PADR(AllTrim(_cForn),TAMSX3("F1_FORNECE")[1])	, Nil} )
								aadd(_aCabDcOr , {"F1_LOJA"   	,_cLojFn	, Nil} )
								aadd(_aCabDcOr , {"F1_ESPECIE"	,_cMvEspc	, Nil} )
								aadd(_aCabDcOr , {"F1_COND"		,_cMvCdDe	, Nil} )
								
								_nContOr := 1
								
								_aItmPd := {}
								_alinha := {}
								_aItmPv := {}
								
								_lVcDesc := .F.
								
								While AllTrim((_cAliQry)->B1_PROC) == _cForn .And. AllTrim((_cAliQry)->B1_LOJPROC) == _cLojFn
									
									//�����������������������������������������������������������Ŀ
									//�Validando se a tabela de pre�o possui o produto selecionado�
									//�������������������������������������������������������������
									DbSelectArea("DA1")
									DbSetOrder(1)
									If DbSeek(xFilial("DA1")+_cMvTbPr+(_cAliQry)->B1_COD)
										
										//�����������������������������������������������������������������S
										//�Valida��o da regra de descontos para regra de cliente		   �
										//�����������������������������������������������������������������S
										_cQuery := " SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE "  + cEnt
										_cQuery += " FROM " + RetSqlName("ACO") + cEnt
										_cQuery += " WHERE D_E_L_E_T_ = ''" + cEnt
										_cQuery += " AND ACO_CODCLI = '" + SA1->A1_COD + "'" + cEnt
										_cQuery += " AND ACO_LOJA = '" + SA1->A1_LOJA + "'" + cEnt
										
										_cQuery := ChangeQuery(_cQuery)
										
										If Select(_cAliQry1) > 0
											dbSelectArea(_cAliQry1)
											(_cAliQry1)->(dbCloseArea())
										EndIf
										
										dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry1, .F., .T.)
										
										If (_cAliQry1)->(!EOF())
											
											//���������������������������������������������x�[�
											//�Valida��o se a regra de desconto esta v�lida�
											//���������������������������������������������x�[�
											If (_cAliQry1)->ACO_DATATE > dDatabase .OR. Empty((_cAliQry1)->ACO_DATATE)
												
												//���������������������������������������������������������������������S
												//�Valida��o da para pegar o produto  nas linhas da regra de desconto  �
												//���������������������������������������������������������������������S
												_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES "  + cEnt
												_cQuery += " FROM " + RetSqlName("ACP") + cEnt
												_cQuery += " WHERE D_E_L_E_T_ = ''" + cEnt
												_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'" + cEnt
												
												_cQuery := ChangeQuery(_cQuery)
												
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
												
												//����������������������������������I
												//�Fun��o para alimentar Log de erro�
												//����������������������������������I
												_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry1)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
												
												_lVcDesc := .T.
												
												Conout(_cMsg)
												
												MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
												(_cAliQry)->(DbSkip())
												
											EndIf
											
										Else
											
											//�����������������������������������������������������������������S
											//�Valida��o da regra de descontos para regra de grupo de cliente  �
											//�����������������������������������������������������������������S
											_cQuery := " SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE"  + cEnt
											_cQuery += " FROM " + RetSqlName("ACO") + cEnt
											_cQuery += " WHERE D_E_L_E_T_ = ''" + cEnt
											_cQuery += " AND ACO_GRPVEN = '" + SA1->A1_GRPVEN + "'" + cEnt
											
											_cQuery := ChangeQuery(_cQuery)
											
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
												
												If _dDtAco > dDatabase .OR. Empty((_cAliQry2)->ACO_DATATE)
													
													//���������������������������������������������������������������������S
													//�Valida��o da para pegar o produto  nas linhas da regra de desconto  �
													//���������������������������������������������������������������������S
													_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES "  + cEnt
													_cQuery += " FROM " + RetSqlName("ACP") + cEnt
													_cQuery += " WHERE D_E_L_E_T_ = ''" + cEnt
													_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'" + cEnt
													
													_cQuery := ChangeQuery(_cQuery)
													
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
													
													//����������������������������������I
													//�Fun��o para alimentar Log de erro�
													//����������������������������������I
													_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry2)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
													
													_lVcDesc := .T.
													
													Conout(_cMsg)
													
													MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
													
													(_cAliQry)->(DbSkip())
													
												EndIf
												
											Else
												
												//�����������������������������������������������������������������������������S
												//�Valida��o da regra de descontos sem cliente e sem regra de grupo de cliente �
												//�����������������������������������������������������������������������������S
												_cQuery := " SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE "  + cEnt
												_cQuery += " FROM " + RetSqlName("ACO") + cEnt
												_cQuery += " WHERE D_E_L_E_T_ = ''" + cEnt
												_cQuery += " AND (ACO_CODCLI = '' OR ACO_GRPVEN = '')" + cEnt
												
												_cQuery := ChangeQuery(_cQuery)
												
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
													
													If _dDtAco > dDatabase .OR. Empty((_cAliQry3)->ACO_DATATE)
														
														//���������������������������������������������������������������������S
														//�Valida��o da para pegar o produto  nas linhas da regra de desconto  �
														//���������������������������������������������������������������������S
														_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES "  + cEnt
														_cQuery += " FROM " + RetSqlName("ACP") + cEnt
														_cQuery += " WHERE D_E_L_E_T_ = ''" + cEnt
														_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'" + cEnt
														
														_cQuery := ChangeQuery(_cQuery)
														
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
														
														//����������������������������������I
														//�Fun��o para alimentar Log de erro�
														//����������������������������������I
														_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry3)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
														
														_lVcDesc := .T.
														
														Conout(_cMsg)
														
														MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
														
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
										
										If _nDesc != 0
											
											_nPrcVn := (DA1->DA1_PRCVEN * _nDesc) / 100
											
										Else
											
											_nPrcVn := DA1->DA1_PRCVEN
											
										EndIf
										
										_nDesc := 0 //Zerando a Vari�vel
										
										//������������������������������������������������������������Ŀ
										//�Array contendo a linha do pedido de vendas na empresa Matriz�
										//��������������������������������������������������������������
										aAdd ( _alinha 	, 	{ "C6_ITEM"    	, STRZERO(_nContOr,TAMSX3("C6_ITEM")[1]), Nil})
										aAdd ( _alinha 	, 	{ "C6_PRODUTO" 	, (_cAliQry)->B1_COD 					, Nil})
										aAdd ( _alinha 	, 	{ "C6_DESCRI"  	, (_cAliQry)->B1_DESC  					, Nil})
										aAdd ( _alinha 	, 	{ "C6_QTDVEN"  	, (_cAliQry)->B6_SALDO		   			, Nil})
										aAdd ( _alinha 	, 	{ "C6_PRCVEN"  	, _nPrcVn	    						, Nil})
										aAdd ( _alinha 	, 	{ "C6_VALOR"   	, (_cAliQry)->B6_SALDO * _nPrcVn		, Nil})
										aAdd ( _alinha 	, 	{ "C6_QTDLIB"  	, (_cAliQry)->B6_SALDO					, Nil})
										aAdd ( _alinha 	, 	{ "C6_TES"     	, _cMvTsPd     		   					, Nil}) //TES diferente
										aAdd ( _alinha 	, 	{ "C6_LOCAL"   	, (_cAliQry)->B1_LOCPAD   				, Nil})
										aAdd ( _alinha 	, 	{ "C6_ENTREG"	, dDataBase				   				, Nil})
										aAdd ( _alinha 	, 	{ "C6_NFORI"	, (_cAliQry)->B6_DOC	   				, Nil})
										aAdd ( _alinha 	, 	{ "C6_SERIORI"	, (_cAliQry)->B6_SERIE	   				, Nil})
										aAdd ( _alinha 	, 	{ "C6_ITEMORI"	, (_cAliQry)->D1_ITEM	   				, Nil})
										
										aAdd(_aItmPv , _alinha  )
										_alinha := {}
										
										//��������������������������������������������������������������Ŀ
										//�Array contendo os itens do Documento de Entrada empresa Origem�
										//����������������������������������������������������������������
										aAdd(_alinhaOr	,	{"D1_ITEM"		, STRZERO(_nContOr,TAMSX3("D1_ITEM")[1]), Nil})
										aAdd(_alinhaOr	,	{"D1_COD"  		, (_cAliQry)->B1_COD					, Nil})
										aAdd(_alinhaOr	,	{"D1_QUANT"		, (_cAliQry)->B6_SALDO					, Nil})
										aAdd(_alinhaOr	,	{"D1_VUNIT"		, _nPrcVn								, Nil})
										aAdd(_alinhaOr	,	{"D1_TOTAL"		, (_cAliQry)->B6_SALDO * _nPrcVn		, Nil})
										aAdd(_alinhaOr	,	{"D1_TES"		, _cMvTsOr								, Nil})
										aAdd(_alinhaOr	,	{"D1_LOCAL"		, (_cAliQry)->B1_LOCPAD					, Nil})
										aAdd(_alinhaOr	,	{"D1_NFORI"		, (_cAliQry)->B6_DOC					, Nil})
										aAdd(_alinhaOr	,	{"D1_SERIORI"	, (_cAliQry)->B6_SER					, Nil})
										aAdd(_alinhaOr	,	{"D1_ITEMORI"	, (_cAliQry)->D1_ITEM					, Nil})
										
										aadd(_aItmDcOr,_alinhaOr)
										_alinhaOr := {}
										
										//��������������������������������������������������������������
										//�Array contendo a linha do pedido de vendas na empresa Origem�
										//��������������������������������������������������������������
										aAdd ( _aLinPd 	, 	{ "C6_ITEM"    	, STRZERO(_nContOr,TAMSX3("C6_ITEM")[1]), Nil})
										aAdd ( _aLinPd 	, 	{ "C6_PRODUTO" 	, (_cAliQry)->B1_COD 					, Nil})
										aAdd ( _aLinPd 	, 	{ "C6_DESCRI"  	, (_cAliQry)->B1_DESC  					, Nil})
										aAdd ( _aLinPd 	, 	{ "C6_QTDVEN"  	, (_cAliQry)->B6_SALDO	   				, Nil})
										aAdd ( _aLinPd 	, 	{ "C6_PRCVEN"  	, _nPrcVn	    						, Nil})
										aAdd ( _aLinPd 	, 	{ "C6_VALOR"   	, (_cAliQry)->B6_SALDO * _nPrcVn		, Nil})
										aAdd ( _aLinPd 	, 	{ "C6_QTDLIB"  	, (_cAliQry)->B6_SALDO   				, Nil})											
										aAdd ( _aLinPd 	, 	{ "C6_TES"  	, _cMvTsPv     		   					, Nil}) //TES utilizado no Pedido de Vendas das empresas Origem
										aAdd ( _aLinPd 	, 	{ "C6_LOCAL"   	, (_cAliQry)->B1_LOCPAD   				, Nil})
										aAdd ( _aLinPd 	, 	{ "C6_ENTREG"	, dDataBase				   				, Nil})
										
										//��������������������������������������������������������������Ŀ
										//�Array contendo os itens do Documento de Entrada empresa Matriz�
										//����������������������������������������������������������������
										aAdd(_alinhaDe	,	{"D1_ITEM"		, STRZERO(_nContOr,TAMSX3("D1_ITEM")[1]), Nil})
										aAdd(_alinhaDe	,	{"D1_COD"  		, (_cAliQry)->B1_COD					, Nil})
										aAdd(_alinhaDe	,	{"D1_QUANT"		, (_cAliQry)->B6_SALDO					, Nil})
										aAdd(_alinhaDe	,	{"D1_VUNIT"		, _nPrcVn								, Nil})
										aAdd(_alinhaDe	,	{"D1_TOTAL"		, (_cAliQry)->B6_SALDO * _nPrcVn		, Nil})																															
										aAdd(_alinhaDe	,	{"D1_TES"		, _cTesEn								, Nil}) //TES utilizado na nota de entrada das empresas Matriz										
										aAdd(_alinhaDe	,	{"D1_LOCAL"		, (_cAliQry)->B1_LOCPAD					, Nil})
										
										aadd(_aItmDcEn,_alinhaDe)
										aAdd(_aItmPd , _aLinPd  )
										
										_nContOr ++
										
										//�������������������������������������������������������������H����H����H�������������H
										//�Calcular oos campos customizados de quantidade e valor total empresa Matriz e origem�
										//�������������������������������������������������������������H������H������H����������
										_nQtdTot += (_cAliQry)->B6_SALDO
										_nValTot += (_cAliQry)->B6_SALDO * _nPrcVn
										
										_aLinPd   := {}
										_alinhaDe := {}
										
									Else
										
										//����������������������������������I
										//�Fun��o para alimentar Log de erro�
										//����������������������������������I
										_cMsg := "N�o foi encontrado no sistema tabela de pre�o/produto com os c�digos: " + AllTrim(_cMvTbPr) + " / " + AllTrim(SB1->B1_COD)
										
										Conout(_cMsg)
										
										MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
										
									EndIf
									
									(_cAliQry)->(DbSkip())
									
								EndDo
								
								//���������������������������������������������������������������������������Ŀ
								//�Alimentando o cabe�alho do Pedido de Vendas com as informa��es customizadas�
								//�����������������������������������������������������������������������������
								aAdd ( _aCabGen , { "C5_XQTDTOT"    , _nQtdTot      	, Nil} )
								aAdd ( _aCabGen , { "C5_XVALTOT"    , _nValTot      	, Nil} )
								
								aAdd ( _aCabOri , { "C5_XQTDTOT"    , _nQtdTot      	, Nil} )
								aAdd ( _aCabOri , { "C5_XVALTOT"    , _nValTot      	, Nil} )
								
								//Zerando as Vari�veis
								_nQtdTot := 0
								_nValTot := 0
								
								//���������������������������������������������������
								//�Caso n�o tenha dado problema na regra de descontos�
								//���������������������������������������������������
								
								If !_lVcDesc
									
									//�����������������������������������������������������������������Ŀ
									//�Realizando a nova conex�o para entrar na empresa e filial correta�
									//�������������������������������������������������������������������
									If ValType(_oServer) == "O"
										
										//Fecha a Conexao com o Servidor
										RESET ENVIRONMENT IN SERVER _oServer
										CLOSE RPCCONN _oServer
										_oServer := Nil
										
									EndIf
									
									Conout("GENA012 - Inicio do RPC para logar na empresa Matriz Pedido/Nota de Sa�da")
									Conout("GENA012 - Empresa: " + _cEmpCd + " Filial: " + _cEmpFl)
									
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
										
										_cNotaImp := _oServer:CallProc("U_GENA012C",_aCabGen,_aItmPv)
										
										//�����������������������������������������������������������������Ŀ
										//�Realizando a nova conex�o para entrar na empresa e filial correta�
										//�������������������������������������������������������������������
										//Fecha a Conexao com o Servidor
										RESET ENVIRONMENT IN SERVER _oServer
										CLOSE RPCCONN _oServer
										_oServer := Nil
										
										If !Empty(_cNotaImp)
											
											//��������������������������������������������������������������������������������������
											//�Rotina que ir� criar a Nota de Entrada/Pedido de Vendas e Nota de Sa�da na empresa  ,
											//�origem com os valores atualizados.                                                  �
											//��������������������������������������������������������������������������������������
											
											Conout("GENA012 - Fechou o RCP, ira gerar Nota de Entrada/Pedido de Vendas e Nota de Saida")
											Conout("GENA012 - Empresa: " + _cEmp + " Filial: " + _cFil)
											
											_cNotaOri := U_GENA012D(_aCabDcOr,_aItmDcOr,_aCabOri,_aItmPd,_cNotaImp)
																						
											If !Empty(_cNotaOri)
												
												//����������������������������������������������������������������������������������Ŀ
												//�Gerando a nota de entrada na empresa Matriz (GEN) com os valores atualizados, ap�s�
												//�a cria��o da nota de sa�da da empresa origem.             						 �
												//������������������������������������������������������������������������������������
												
												If ValType(_oServer) == "O"
													
													//Fecha a Conexao com o Servidor
													RESET ENVIRONMENT IN SERVER _oServer
													CLOSE RPCCONN _oServer
													_oServer := Nil
													
												EndIf
												
												Conout("GENA012 - Inicio do RPC para logar na empresa Matriz Nota de Entrada")
												Conout("GENA012 - Empresa: " + _cEmpCd + " Filial: " + _cEmpFl)
												
												CREATE RPCCONN _oServer ON  SERVER _cServ 			;   //IP do servidor
												PORT  _nPort           								;   //Porta de conex�o do servidor
												ENVIRONMENT _cAmb       							;   //Ambiente do servidor
												EMPRESA _cEmpCd          							;   //Empresa de conex�o
												FILIAL  _cEmpFl          							;   //Filial de conex�o
												TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que ser�o abertas
												MODULO  "SIGAFAT"               					//M�dulo de conex�o
												
												If ValType(_oServer) == "O"
													
													_oServer:CallProc("RPCSetType", 2)
													
													_oServer:CallProc("U_GENA012E",_aCabDcEn,_aItmDcEn,_cNotaOri)
													
													//�����������������������������������������������������������������Ŀ
													//�Fecha a conex�o
													//�������������������������������������������������������������������
													
													RESET ENVIRONMENT IN SERVER _oServer
													CLOSE RPCCONN _oServer
													_oServer := Nil
													
												EndIf
												
											EndIf
											
										EndIf
										
									EndIf
									
								EndIf
								
							Else
								
								//����������������������������������Iq�\��W�
								//�Fun��o para alimentar Log de erro�
								//����������������������������������Iq�\��W�
								_cMsg := "A Tabela de pre�o:  " + AllTrim(_cMvTbPr) + " encontra-se vencida, favor verifica. "
								
								Conout(_cMsg)
								
								MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
								
								(_cAliQry)->(DbSkip())
								
							EndIf
							
						Else
							
							//����������������������������������Iq�\��W�
							//�Fun��o para alimentar Log de erro�
							//����������������������������������Iq�\��W�
							_cMsg := "N�o foi encontrado no sistema tabela de pre�o com o c�digo: " + AllTrim(_cMvTbPr)
							
							Conout(_cMsg)
							
							MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
							
							(_cAliQry)->(DbSkip())
							
						EndIf
						
					Else
						
						//����������������������������������Iq�\��W�
						//�Fun��o para alimentar Log de erro�
						//����������������������������������Iq�\��W�
						_cMsg := "N�o foi encontrado no sistema fornecedor com o CGC: " + AllTrim(_cCGCOri) + " ." + cEnt
						_cMsg += "CGC pertencente ao cliente: " + AllTrim(_cCliPv) + " loja: " + (_cLjPv) + cEnt
						_cMsg += "Este cliente tamb�m deve estar cadastrado como fornecedor para que o processo de reconsigna��o possa continuar." + cEnt
						_cMsg += "Favor verificar os cadastro de fornecedores."
						
						Conout(_cMsg)
						
						MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Problema_Cliente" + ".txt" , _cMsg )
						
						(_cAliQry)->(DbSkip())
						
					EndIf
					
				Else
					
					//����������������������������������Iq�\��W�
					//�Fun��o para alimentar Log de erro�
					//����������������������������������Iq�\��W�
					_cMsg := "N�o foi encontrado no sistema empresa (SM0) com o CNPJ: " + _cCGCGen
					
					Conout(_cMsg)
					
					MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + ".txt" , _cMsg )
					
					(_cAliQry)->(DbSkip())
					
				EndIf
				
			Else
				
				//����������������������������������Iq�\��W�
				//�Fun��o para alimentar Log de erro�
				//����������������������������������Iq�\��W�
				_cMsg := "N�o foi encontrado no sistema cliente com o c�digo: " + AllTrim(_cCliPv) + " e loja: " + AllTrim(_cLjPv) + cEnt
				_cMsg += "Favor verificar os cadastro de clientes."
				
				Conout(_cMsg)
				
				MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Problema_Cliente" + ".txt" , _cMsg )
				
				(_cAliQry)->(DbSkip())				
				
			EndIf			
			
		Else
			
			//����������������������������������Iq�\��W�
			//�Fun��o para alimentar Log de erro�
			//����������������������������������Iq�\��W�
			_cMsg := "N�o foi encontrado no sistema fornecedor com o CGC: " + AllTrim(_cCGCGen) + " ." + cEnt
			_cMsg += "CGC pertencente ao cliente: " + _cCliGen + " loja: " + _cLojGen + cEnt
			_cMsg += "Este cliente tamb�m deve estar cadastrado como fornecedor para que o processo de reconsigna��o possa continuar." + cEnt
			_cMsg += "Favor verificar os cadastro de fornecedores."
			
			Conout(_cMsg)
			
			MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Problema_Cliente" + ".txt" , _cMsg )
			
			(_cAliQry)->(DbSkip())
			
			
		EndIf
		
		
		//����������������������������������Iq�\��W�
		//�Fun��o para alimentar Log de erro�
		//����������������������������������Iq�\��W�
		_cMsg := "N�o foi encontrado no sistema cliente com o c�digo: " + AllTrim((_cAliQry)->B1_PROC) + " e loja: " +  AllTrim((_cAliQry)->B1_LOJPROC) + cEnt
		_cMsg += "Favor verificar os cadastro de clientes e produto, pois este c�digo esta vinculado ao produto: " +  AllTrim((_cAliQry)->B1_COD)
		
		Conout(_cMsg)
		
		MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Problema_Cliente" + ".txt" , _cMsg )
		
		(_cAliQry)->(DbSkip())
		
	Else
		
		
	EndIf
	
	
	(_cAliQry)->(DbSkip())
	
EndDo

RestArea(_aArea)

Return 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA012B  �Autor  �Angelo Henrique     � Data �  29/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina respons�vel pela execu��o da reconsigna��o para      ���
���          �filial que � a empresa GEN.                                 ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA012B

Local _aArea	:= GetArea()
Local _cQuery	:= ""
Local _cAliQry	:= GetNextAlias()
Local _aCabGen	:= {}
Local _aCabOri	:= {}
Local _cTrpPv	:= ""
Local _cTipPv 	:= ""
Local _cVenPv 	:= ""
Local _cCliGen  := ""
Local _cLojGen  := ""
Local _cTrpGen  := ""
Local _cTipGen  := ""
Local _cVenGen  := ""
Local _aCabDcEn := {} //Vetor contendo o cabe�alho documento de entrada empresa Matriz
Local _aItmDcEn := {} //Vetor contendo os itens do documento de entrada empresa Matriz
Local _aCabDcOr := {} //Vetor contendo o cabe�alho documento de entrada empresa Origem
Local _aItmDcOr := {} //Vetor contendo os itens do documento de entrada empresa Origem
Local _cCGCGen  := ""
Local _cCGCOri  := ""
Local _cFnGen 	:= ""
Local _cLjGen 	:= ""
Local _cEmp		:= AllTrim(SM0->M0_CODIGO)
Local _cFil		:= AllTrim(SM0->M0_CODFIL)
Local _cCGCM0	:= AllTrim(SM0->M0_CGC)
Local _cForn  	:= ""
Local _cLojFn 	:= ""
Local _cCliOri  := ""
Local _cLojOri  := ""
Local _lVcDesc  := .F.
Local _cAliQry1	:= GetNextAlias()
Local _cAliQry2	:= GetNextAlias()
Local _cAliQry3	:= GetNextAlias()
Local _cAliQry4	:= GetNextAlias()
Local _cAliQry5	:= GetNextAlias()
Local _nDesc	:= 0
Local _nPrcVn	:= 0
Local _dDtAco	:= CTOD(" \ \")
Local _cMsg		:= ""
Local _nContOr	:= 0
Local _aItmPd 	:= {}
Local _alinha 	:= {}
Local _aItmPv 	:= {}
Local _nQtdTot 	:= 0
Local _nValTot 	:= 0
Local _aArM0	:= {}
Local _lEmp 	:= .F.
Local _cEmpCd 	:= ""
Local _cEmpFl 	:= ""
Local _oServer	:= Nil
Local _cNotaImp	:= ""
Local _cNotaOri	:= ""

Local _cCliPv	:= GetMv("GEN_FAT033") //Parametro que contem o codigo do cliente GEN
Local _cLjPv 	:= GetMv("GEN_FAT034") //Parametro que contem a loja do cliente GEN
Local _cFil		:= GetMv("GEN_FAT035") //Parametro que contem o codigo da filial da empresa GEN, utilizada em validacoes da reconsignacao
Local _cMvTbPr 	:= GetMv("GEN_FAT036") //Cont�m a tabela de pre�o usado no pedido de vendas na empresa Matriz e Origem
Local _cMvCdPv 	:= GetMv("GEN_FAT037") //Condi��o de pagamento pedido de venda
Local _cMvSeri 	:= GetMv("GEN_FAT038") //Serie da nota de sa�da de entrada nas empresas Matriz e Origem
Local _cMvEspc 	:= GetMv("GEN_FAT039") //Cont�m a especie utilizada na nota de entrada das empresas Matriz e Origem
Local _cMvCdDe	:= GetMv("GEN_FAT040") //Cont�m a condi��o de pagamento utilizada na nota de entrada das empresas Matriz e Origem
Local _cLogPd	:= GetMv("GEN_FAT041") //Cont�m o caminho que ser� gravado o log de erro
Local _cMvTsPd	:= GetMv("GEN_FAT044") //Cont�m o TES utilizado no Pedido de Vendas das empresas Matriz
Local _cMvTsOr	:= GetMv("GEN_FAT045") //Cont�m o TES utilizado na nota de entrada das empresas Origem
Local _cServ 	:= GetMv("GEN_FAT046") //Cont�m o Ip do servidor para realizar as mudan�as de ambiente
Local _nPort  	:= GetMv("GEN_FAT047") //Cont�m a porta para realizar as mudan�as de ambiente
Local _cAmb  	:= GetMv("GEN_FAT048") //Cont�m o ambiente a ser utilizado para realizar as mudan�as de filial   
Local _cMvTsPv	:= GetMv("GEN_FAT049") //Cont�m o TES utilizado no Pedido de Vendas das empresas Origem
Local _cTesEn	:= GetMv("GEN_FAT050") //Cont�m o TES utilizado na nota de entrada das empresas Matriz

//�����������������������������������������������������������������������H�
//�Pegando informa��es do cliente/fornecedor (empresa origem)  para serem �
//�colocados na nota de sa�da na empresa GEN                   			  �
//�����������������������������������������������������������������������H�
DbSelectArea("SA2")
DbSetOrder(3)
If DbSeek(xFilial("SA2")+_cCGCM0)
	
	_cCliOri  := SA1->A1_COD
	_cLojOri  := SA1->A1_LOJA
	
EndIf

//���������������������������������������������������a
//�Realizando a busca por saldo em poder de terceiros�
//���������������������������������������������������a

_cQuery := " SELECT B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO, B6_DOC, " + cEnt
_cQuery += " B6_SERIE, B6_CLIFOR, B6_LOJA, B6_SALDO, D1_ITEM , B1_COD ,B1_PROC, B1_LOJPROC " + cEnt
_cQuery += " FROM " + RetSqlName("SB6") + " SB6, " + RetSqlName("SD1") + " SD1, " + RetSqlName("SB1") + " SB1 " + cEnt
_cQuery += " WHERE SB6.B6_DOC = SD1.D1_DOC " + cEnt
_cQuery += " AND SB6.B6_SERIE = SD1.D1_SERIE " + cEnt
_cQuery += " AND SB6.B6_PRODUTO = SD1.D1_COD " + cEnt
_cQuery += " AND SB6.B6_CLIFOR = SD1.D1_FORNECE " + cEnt
_cQuery += " AND SB6.B6_LOJA = SD1.D1_LOJA " + cEnt
_cQuery += " AND SB6.B6_PRODUTO = SB1.B1_COD " + cEnt
_cQuery += " AND SB6.D_E_L_E_T_ = '' " + cEnt
_cQuery += " AND SD1.D_E_L_E_T_ = '' " + cEnt
_cQuery += " AND SB1.D_E_L_E_T_ = '' " + cEnt
_cQuery += " AND SB6.B6_FILIAL = '" + _cFil + "' " + cEnt
_cQuery += " AND SD1.D1_FILIAL = '" + _cFil + "' " + cEnt
_cQuery += " AND SB6.B6_TIPO = 'D' " + cEnt
_cQuery += " AND SB6.B6_TPCF = 'F' " + cEnt
_cQuery += " AND SB6.B6_PODER3 = 'R' " + cEnt
_cQuery += " AND SB6.B6_SALDO > 0 " + cEnt
_cQuery += " AND SB6.B6_CLIFOR = '" + _cCliOri + "' " + cEnt
_cQuery += " AND SB6.B6_LOJA = '" + _cLojOri + "' " + cEnt
_cQuery += " ORDER BY B6_EMISSAO " + cEnt

_cQuery := ChangeQuery(_cQuery)

If Select(_cAliQry) > 0
	dbSelectArea(_cAliQry)
	(_cAliQry)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry, .F., .T.)

While (_cAliQry)->(!EOF())
	
	//�������������������������������������������������������������H�
	//�Pegando informa��es do cliente (empresa origem)  para serem �
	//�colocados na nota de sa�da na empresa GEN                   �
	//�������������������������������������������������������������H�
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+PADR(AllTrim((_cAliQry)->B1_PROC),TamSX3("A1_LOJA")[1])+PADR(AllTrim((_cAliQry)->B1_LOJPROC),TamSX3("A1_LOJA")[1]))
		
		_cCliGen := SA1->A1_COD
		_cLojGen := SA1->A1_LOJA
		_cTrpGen := SA1->A1_TRANSP
		_cTipGen := SA1->A1_TIPO
		_cVenGen := SA1->A1_VEND
		_cCGCGen := SA1->A1_CGC
		
		//���������������������������������������������������������D�
		//�Pegando informa��es do Fornecedor (empresa origem) para �
		//�serem utilizadas na gera��o da Nota de Entrada          �
		//���������������������������������������������������������D�
		DbSelectArea("SA2")
		DbSetOrder(3)
		If DbSeek(xFilial("SA2")+_cCGCGen)
			
			_cFnGen := SA2->A2_COD
			_cLjGen := SA2->A2_LOJA
			
			//�����������������������������������������������������������������������Ŀ
			//�Ponterar no cliente para pegar as informa��es pertinentes a empresa GEN�
			//�ser� utilizado na empresa origem para gerar a nota de sa�da            �
			//�������������������������������������������������������������������������
			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(xFilial("SA1")+PADR(AllTrim(_cCliPv),TamSX3("A1_LOJA")[1])+PADR(AllTrim(_cLjPv),TamSX3("A1_LOJA")[1]))
				
				_cTrpPv		:= SA1->A1_TRANSP
				_cTipPv 	:= SA1->A1_TIPO
				_cVenPv 	:= SA1->A1_VEND
				_cCGCOri 	:= SA1->A1_CGC
				
				_aArM0 := SM0->(GetArea())
				DbSelectArea("SM0")
				SM0->(DbGoTop())
				While SM0->(!EOF())
					
					If AllTrim(SM0->M0_CGC) == AllTrim(_cCGCOri)
						
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
				
				//�����������������������������������������������������Ŀ
				//�Se encontrar a empresa matriz no cadastro de empresas�
				//�ir� prosseguir com o processamento                   �
				//�������������������������������������������������������
				If _lEmp
					
					DbSelectArea("SA2")
					DbSetOrder(3)
					If DbSeek(xFilial("SA2")+_cCGCGen)
						
						_cForn  := SA2->A2_COD
						_cLojFn := SA2->A2_LOJA
						
						//������������������������������������Ġ�A�
						//�Pegando o produto na tabela de pre�o	  �
						//������������������������������������Ġ�A�
						DbSelectArea("DA0")
						DbSetOrder(1)
						If DbSeek(xFilial("DA0")+_cMvTbPr)
							
							//�������������������������������������������������
							//�Validando se a tabela de pre�o esta vigente�
							//�������������������������������������������������
							If DA0->DA0_DATATE > dDatabase .OR. Empty(DA0->DA0_DATATE)
								
								_aCabGen := {}
								_aCabOri := {}
								
								//����������������������������������������������������������������������Ŀ
								//�Array contendo o cabe�alho da pedido de vendas para a empresa Matriz	 �
								//������������������������������������������������������������������������
								
								aAdd ( _aCabGen , { "C5_TIPO"    , "D"      	, Nil} )
								aAdd ( _aCabGen , { "C5_CLIENTE" , _cCliGen 	, Nil} )
								aAdd ( _aCabGen , { "C5_LOJACLI" , _cLojGen 	, Nil} )
								aAdd ( _aCabGen , { "C5_CLIENT"  , _cCliGen		, Nil} )
								aAdd ( _aCabGen , { "C5_LOJAENT" , _cLojGen		, Nil} )
								aAdd ( _aCabGen , { "C5_TRANSP"  , _cTrpGen		, Nil} )
								aAdd ( _aCabGen , { "C5_TIPOCLI" , _cTipGen 	, Nil} )
								aAdd ( _aCabGen , { "C5_VEND1" 	 , _cVenGen 	, Nil} )
								aAdd ( _aCabGen , { "C5_CONDPAG" , _cMvCdOr		, Nil} )
								aAdd ( _aCabGen , { "C5_TABELA"  , _cMvTbPr		, Nil} )
								aAdd ( _aCabGen , { "C5_EMISSAO" , dDatabase	, Nil} )
								aAdd ( _aCabGen , { "C5_MOEDA" 	 , 1			, Nil} )
								aAdd ( _aCabGen , { "C5_TPLIB" 	 , "2"			, Nil} )
																
								
								//�������������������������������������������������������������
								//�Array contendo o cabe�alho da nota de entrada para a Matriz�
								//�������������������������������������������������������������
								
								_aCabDcEn := {} //Vetor contendo o cabe�alho documento de entrada empresa Matriz
								_aItmDcEn := {} //Vetor contendo os itens do documento de entrada empresa Matriz
								
								aadd(_aCabDcEn , {"F1_TIPO"   	,"N"		, Nil} )
								aadd(_aCabDcEn , {"F1_FORMUL" 	,"N"		, Nil} )
								aadd(_aCabDcEn , {"F1_SERIE"  	,_cMvSeri	, Nil} )
								aadd(_aCabDcEn , {"F1_EMISSAO"	,dDataBase	, Nil} )
								aadd(_aCabDcEn , {"F1_FORNECE"	,PADR(AllTrim(_cFnGen),TAMSX3("F1_FORNECE")[1])		, Nil} )
								aadd(_aCabDcEn , {"F1_LOJA"   	,_cLjGen	, Nil} )
								aadd(_aCabDcEn , {"F1_ESPECIE"	,_cMvEspc	, Nil} )
								aadd(_aCabDcEn , {"F1_COND"		,_cMvCdDe	, Nil} )																
								
								_nContOr := 1
								
								_aItmPd := {}
								_alinha := {}
								_aItmPv := {}
								
								_lVcDesc := .F.
								
								While AllTrim((_cAliQry)->B1_PROC) == _cForn .And. AllTrim((_cAliQry)->B1_LOJPROC) == _cLojFn
									
									//�����������������������������������������������������������Ŀ
									//�Validando se a tabela de pre�o possui o produto selecionado�
									//�������������������������������������������������������������
									DbSelectArea("DA1")
									DbSetOrder(1)
									If DbSeek(xFilial("DA1")+_cMvTbPr+(_cAliQry)->B1_COD)
										
										//�����������������������������������������������������������������S
										//�Valida��o da regra de descontos para regra de cliente		   �
										//�����������������������������������������������������������������S
										_cQuery := " SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE "  + cEnt
										_cQuery += " FROM " + RetSqlName("ACO") + cEnt
										_cQuery += " WHERE D_E_L_E_T_ = ''" + cEnt
										_cQuery += " AND ACO_CODCLI = '" + SA1->A1_COD + "'" + cEnt
										_cQuery += " AND ACO_LOJA = '" + SA1->A1_LOJA + "'" + cEnt
										
										_cQuery := ChangeQuery(_cQuery)
										
										If Select(_cAliQry1) > 0
											dbSelectArea(_cAliQry1)
											(_cAliQry1)->(dbCloseArea())
										EndIf
										
										dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry1, .F., .T.)
										
										If (_cAliQry1)->(!EOF())
											
											//���������������������������������������������x�[�
											//�Valida��o se a regra de desconto esta v�lida�
											//���������������������������������������������x�[�
											If (_cAliQry1)->ACO_DATATE > dDatabase .OR. Empty((_cAliQry1)->ACO_DATATE)
												
												//���������������������������������������������������������������������S
												//�Valida��o da para pegar o produto  nas linhas da regra de desconto  �
												//���������������������������������������������������������������������S
												_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES "  + cEnt
												_cQuery += " FROM " + RetSqlName("ACP") + cEnt
												_cQuery += " WHERE D_E_L_E_T_ = ''" + cEnt
												_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'" + cEnt
												
												_cQuery := ChangeQuery(_cQuery)
												
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
												
												//����������������������������������I
												//�Fun��o para alimentar Log de erro�
												//����������������������������������I
												_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry1)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
												
												_lVcDesc := .T.
												
												Conout(_cMsg)
												
												MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
												(_cAliQry)->(DbSkip())
												
											EndIf
											
										Else
											
											//�����������������������������������������������������������������S
											//�Valida��o da regra de descontos para regra de grupo de cliente  �
											//�����������������������������������������������������������������S
											_cQuery := " SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE"  + cEnt
											_cQuery += " FROM " + RetSqlName("ACO") + cEnt
											_cQuery += " WHERE D_E_L_E_T_ = ''" + cEnt
											_cQuery += " AND ACO_GRPVEN = '" + SA1->A1_GRPVEN + "'" + cEnt
											
											_cQuery := ChangeQuery(_cQuery)
											
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
												
												If _dDtAco > dDatabase .OR. Empty((_cAliQry2)->ACO_DATATE)
													
													//���������������������������������������������������������������������S
													//�Valida��o da para pegar o produto  nas linhas da regra de desconto  �
													//���������������������������������������������������������������������S
													_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES "  + cEnt
													_cQuery += " FROM " + RetSqlName("ACP") + cEnt
													_cQuery += " WHERE D_E_L_E_T_ = ''" + cEnt
													_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'" + cEnt
													
													_cQuery := ChangeQuery(_cQuery)
													
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
													
													//����������������������������������I
													//�Fun��o para alimentar Log de erro�
													//����������������������������������I
													_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry2)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
													
													_lVcDesc := .T.
													
													Conout(_cMsg)
													
													MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
													
													(_cAliQry)->(DbSkip())
													
												EndIf
												
											Else
												
												//�����������������������������������������������������������������������������S
												//�Valida��o da regra de descontos sem cliente e sem regra de grupo de cliente �
												//�����������������������������������������������������������������������������S
												_cQuery := " SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE "  + cEnt
												_cQuery += " FROM " + RetSqlName("ACO") + cEnt
												_cQuery += " WHERE D_E_L_E_T_ = ''" + cEnt
												_cQuery += " AND (ACO_CODCLI = '' OR ACO_GRPVEN = '')" + cEnt
												
												_cQuery := ChangeQuery(_cQuery)
												
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
													
													If _dDtAco > dDatabase .OR. Empty((_cAliQry3)->ACO_DATATE)
														
														//���������������������������������������������������������������������S
														//�Valida��o da para pegar o produto  nas linhas da regra de desconto  �
														//���������������������������������������������������������������������S
														_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES "  + cEnt
														_cQuery += " FROM " + RetSqlName("ACP") + cEnt
														_cQuery += " WHERE D_E_L_E_T_ = ''" + cEnt
														_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'" + cEnt
														
														_cQuery := ChangeQuery(_cQuery)
														
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
														
														//����������������������������������I
														//�Fun��o para alimentar Log de erro�
														//����������������������������������I
														_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry3)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
														
														_lVcDesc := .T.
														
														Conout(_cMsg)
														
														MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
														
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
										
										If _nDesc != 0
											
											_nPrcVn := (DA1->DA1_PRCVEN * _nDesc) / 100
											
										Else
											
											_nPrcVn := DA1->DA1_PRCVEN
											
										EndIf
										
										_nDesc := 0 //Zerando a Vari�vel
										
										//������������������������������������������������������������Ŀ
										//�Array contendo a linha do pedido de vendas na empresa Matriz�
										//��������������������������������������������������������������
										aAdd ( _alinha 	, 	{ "C6_ITEM"    	, STRZERO(_nContOr,TAMSX3("C6_ITEM")[1]), Nil})
										aAdd ( _alinha 	, 	{ "C6_PRODUTO" 	, (_cAliQry)->B1_COD 					, Nil})
										aAdd ( _alinha 	, 	{ "C6_DESCRI"  	, (_cAliQry)->B1_DESC  					, Nil})
										aAdd ( _alinha 	, 	{ "C6_QTDVEN"  	, (_cAliQry)->B6_SALDO		   			, Nil})
										aAdd ( _alinha 	, 	{ "C6_PRCVEN"  	, _nPrcVn	    						, Nil})
										aAdd ( _alinha 	, 	{ "C6_VALOR"   	, (_cAliQry)->B6_SALDO * _nPrcVn		, Nil})
										aAdd ( _alinha 	, 	{ "C6_QTDLIB"  	, (_cAliQry)->B6_SALDO					, Nil})
										aAdd ( _alinha 	, 	{ "C6_TES"     	, _cMvTsPd     		   					, Nil}) //TES diferente
										aAdd ( _alinha 	, 	{ "C6_LOCAL"   	, (_cAliQry)->B1_LOCPAD   				, Nil})
										aAdd ( _alinha 	, 	{ "C6_ENTREG"	, dDataBase				   				, Nil})
										aAdd ( _alinha 	, 	{ "C6_NFORI"	, (_cAliQry)->B6_DOC	   				, Nil})
										aAdd ( _alinha 	, 	{ "C6_SERIORI"	, (_cAliQry)->B6_SERIE	   				, Nil})
										aAdd ( _alinha 	, 	{ "C6_ITEMORI"	, (_cAliQry)->D1_ITEM	   				, Nil})
										
										aAdd(_aItmPv , _alinha  )
										_alinha := {}
																			
										//��������������������������������������������������������������Ŀ
										//�Array contendo os itens do Documento de Entrada empresa Matriz�
										//����������������������������������������������������������������
										aAdd(_alinhaDe	,	{"D1_ITEM"		, STRZERO(_nContOr,TAMSX3("D1_ITEM")[1]), Nil})
										aAdd(_alinhaDe	,	{"D1_COD"  		, (_cAliQry)->B1_COD					, Nil})
										aAdd(_alinhaDe	,	{"D1_QUANT"		, (_cAliQry)->B6_SALDO					, Nil})
										aAdd(_alinhaDe	,	{"D1_VUNIT"		, _nPrcVn								, Nil})
										aAdd(_alinhaDe	,	{"D1_TOTAL"		, (_cAliQry)->B6_SALDO * _nPrcVn		, Nil})																															
										aAdd(_alinhaDe	,	{"D1_TES"		, _cTesEn								, Nil}) //TES utilizado na nota de entrada das empresas Matriz										
										aAdd(_alinhaDe	,	{"D1_LOCAL"		, (_cAliQry)->B1_LOCPAD					, Nil})
										
										aadd(_aItmDcEn,_alinhaDe)
										aAdd(_aItmPd , _aLinPd  )
										
										_nContOr ++
										
										//�������������������������������������������������������������H����H����H�������������H
										//�Calcular oos campos customizados de quantidade e valor total empresa Matriz e origem�
										//�������������������������������������������������������������H������H������H����������
										_nQtdTot += (_cAliQry)->B6_SALDO
										_nValTot += (_cAliQry)->B6_SALDO * _nPrcVn
										
										_aLinPd   := {}
										_alinhaDe := {}
										
									Else
										
										//����������������������������������I
										//�Fun��o para alimentar Log de erro�
										//����������������������������������I
										_cMsg := "N�o foi encontrado no sistema tabela de pre�o/produto com os c�digos: " + AllTrim(_cMvTbPr) + " / " + AllTrim(SB1->B1_COD)
										
										Conout(_cMsg)
										
										MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
										
									EndIf
									
									(_cAliQry)->(DbSkip())
									
								EndDo
								
								//���������������������������������������������������������������������������Ŀ
								//�Alimentando o cabe�alho do Pedido de Vendas com as informa��es customizadas�
								//�����������������������������������������������������������������������������
								aAdd ( _aCabGen , { "C5_XQTDTOT"    , _nQtdTot      	, Nil} )
								aAdd ( _aCabGen , { "C5_XVALTOT"    , _nValTot      	, Nil} )
								
								//Zerando as Vari�veis
								_nQtdTot := 0
								_nValTot := 0
								
								//���������������������������������������������������
								//�Caso n�o tenha dado problema na regra de descontos�
								//���������������������������������������������������
								
								If !_lVcDesc
									
									//�����������������������������������������������������������������Ŀ
									//�Realizando a nova conex�o para entrar na empresa e filial correta�
									//�������������������������������������������������������������������
									If ValType(_oServer) == "O"
										
										//Fecha a Conexao com o Servidor
										RESET ENVIRONMENT IN SERVER _oServer
										CLOSE RPCCONN _oServer
										_oServer := Nil
										
									EndIf
									
									Conout("GENA012 - Inicio do RPC para logar na empresa Matriz Pedido/Nota de Sa�da")
									Conout("GENA012 - Empresa: " + _cEmpCd + " Filial: " + _cEmpFl)
									
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
										
										_cNotaImp := _oServer:CallProc("U_GENA012C",_aCabGen,_aItmPv)
										
										//�����������������������������������������������������������������Ŀ
										//�Realizando a nova conex�o para entrar na empresa e filial correta�
										//�������������������������������������������������������������������
										//Fecha a Conexao com o Servidor
										RESET ENVIRONMENT IN SERVER _oServer
										CLOSE RPCCONN _oServer
										_oServer := Nil
										
										If !Empty(_cNotaImp)
											
											//��������������������������������������������������������������������������������������
											//�Rotina que ir� criar a Nota de Entrada/Pedido de Vendas e Nota de Sa�da na empresa  ,
											//�origem com os valores atualizados.                                                  �
											//��������������������������������������������������������������������������������������
											
											Conout("GENA012 - Fechou o RCP, ira gerar Nota de Entrada/Pedido de Vendas e Nota de Saida")
											Conout("GENA012 - Empresa: " + _cEmp + " Filial: " + _cFil)
											
											_cNotaOri := U_GENA012D(_aCabDcOr,_aItmDcOr,_aCabOri,_aItmPd,_cNotaImp)
																						
											If !Empty(_cNotaOri)
												
												//����������������������������������������������������������������������������������Ŀ
												//�Gerando a nota de entrada na empresa Matriz (GEN) com os valores atualizados, ap�s�
												//�a cria��o da nota de sa�da da empresa origem.             						 �
												//������������������������������������������������������������������������������������
												
												If ValType(_oServer) == "O"
													
													//Fecha a Conexao com o Servidor
													RESET ENVIRONMENT IN SERVER _oServer
													CLOSE RPCCONN _oServer
													_oServer := Nil
													
												EndIf
												
												Conout("GENA012 - Inicio do RPC para logar na empresa Matriz Nota de Entrada")
												Conout("GENA012 - Empresa: " + _cEmpCd + " Filial: " + _cEmpFl)
												
												CREATE RPCCONN _oServer ON  SERVER _cServ 			;   //IP do servidor
												PORT  _nPort           								;   //Porta de conex�o do servidor
												ENVIRONMENT _cAmb       							;   //Ambiente do servidor
												EMPRESA _cEmpCd          							;   //Empresa de conex�o
												FILIAL  _cEmpFl          							;   //Filial de conex�o
												TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que ser�o abertas
												MODULO  "SIGAFAT"               					//M�dulo de conex�o
												
												If ValType(_oServer) == "O"
													
													_oServer:CallProc("RPCSetType", 2)
													
													_oServer:CallProc("U_GENA012E",_aCabDcEn,_aItmDcEn,_cNotaOri)
													
													//�����������������������������������������������������������������Ŀ
													//�Fecha a conex�o
													//�������������������������������������������������������������������
													
													RESET ENVIRONMENT IN SERVER _oServer
													CLOSE RPCCONN _oServer
													_oServer := Nil
													
												EndIf
												
											EndIf
											
										EndIf
										
									EndIf
									
								EndIf
								
							Else
								
								//����������������������������������Iq�\��W�
								//�Fun��o para alimentar Log de erro�
								//����������������������������������Iq�\��W�
								_cMsg := "A Tabela de pre�o:  " + AllTrim(_cMvTbPr) + " encontra-se vencida, favor verifica. "
								
								Conout(_cMsg)
								
								MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
								
								(_cAliQry)->(DbSkip())
								
							EndIf
							
						Else
							
							//����������������������������������Iq�\��W�
							//�Fun��o para alimentar Log de erro�
							//����������������������������������Iq�\��W�
							_cMsg := "N�o foi encontrado no sistema tabela de pre�o com o c�digo: " + AllTrim(_cMvTbPr)
							
							Conout(_cMsg)
							
							MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
							
							(_cAliQry)->(DbSkip())
							
						EndIf
						
					Else
						
						//����������������������������������Iq�\��W�
						//�Fun��o para alimentar Log de erro�
						//����������������������������������Iq�\��W�
						_cMsg := "N�o foi encontrado no sistema fornecedor com o CGC: " + AllTrim(_cCGCOri) + " ." + cEnt
						_cMsg += "CGC pertencente ao cliente: " + AllTrim(_cCliPv) + " loja: " + (_cLjPv) + cEnt
						_cMsg += "Este cliente tamb�m deve estar cadastrado como fornecedor para que o processo de reconsigna��o possa continuar." + cEnt
						_cMsg += "Favor verificar os cadastro de fornecedores."
						
						Conout(_cMsg)
						
						MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Problema_Cliente" + ".txt" , _cMsg )
						
						(_cAliQry)->(DbSkip())
						
					EndIf
					
				Else
					
					//����������������������������������Iq�\��W�
					//�Fun��o para alimentar Log de erro�
					//����������������������������������Iq�\��W�
					_cMsg := "N�o foi encontrado no sistema empresa (SM0) com o CNPJ: " + _cCGCGen
					
					Conout(_cMsg)
					
					MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + ".txt" , _cMsg )
					
					(_cAliQry)->(DbSkip())
					
				EndIf
				
			Else
				
				//����������������������������������Iq�\��W�
				//�Fun��o para alimentar Log de erro�
				//����������������������������������Iq�\��W�
				_cMsg := "N�o foi encontrado no sistema cliente com o c�digo: " + AllTrim(_cCliPv) + " e loja: " + AllTrim(_cLjPv) + cEnt
				_cMsg += "Favor verificar os cadastro de clientes."
				
				Conout(_cMsg)
				
				MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Problema_Cliente" + ".txt" , _cMsg )
				
				(_cAliQry)->(DbSkip())				
				
			EndIf			
			
		Else
			
			//����������������������������������Iq�\��W�
			//�Fun��o para alimentar Log de erro�
			//����������������������������������Iq�\��W�
			_cMsg := "N�o foi encontrado no sistema fornecedor com o CGC: " + AllTrim(_cCGCGen) + " ." + cEnt
			_cMsg += "CGC pertencente ao cliente: " + _cCliGen + " loja: " + _cLojGen + cEnt
			_cMsg += "Este cliente tamb�m deve estar cadastrado como fornecedor para que o processo de reconsigna��o possa continuar." + cEnt
			_cMsg += "Favor verificar os cadastro de fornecedores."
			
			Conout(_cMsg)
			
			MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Problema_Cliente" + ".txt" , _cMsg )
			
			(_cAliQry)->(DbSkip())
			
			
		EndIf
		
		
		//����������������������������������Iq�\��W�
		//�Fun��o para alimentar Log de erro�
		//����������������������������������Iq�\��W�
		_cMsg := "N�o foi encontrado no sistema cliente com o c�digo: " + AllTrim((_cAliQry)->B1_PROC) + " e loja: " +  AllTrim((_cAliQry)->B1_LOJPROC) + cEnt
		_cMsg += "Favor verificar os cadastro de clientes e produto, pois este c�digo esta vinculado ao produto: " +  AllTrim((_cAliQry)->B1_COD)
		
		Conout(_cMsg)
		
		MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Problema_Cliente" + ".txt" , _cMsg )
		
		(_cAliQry)->(DbSkip())
		
	Else
		
		
	EndIf
	
	
	(_cAliQry)->(DbSkip())
	
EndDo

RestArea(_aArea)

Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA012C  �Autor  �Angelo Henrique     � Data �  13/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina que ir� gerar a Nota fiscal de sa�da para devolucao  ���
���          �da consigna��o e a Nota Fiscal de Sa�da de Venda.           ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GENA012C(_aCabGen,_aItmPv)

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
Local _nPosLb			:= aScan(_aItmPv[1], { |x| Alltrim(x[2]) == "C6_QTDLIB" })

Local _cLogPd			:= GetMv("GEN_FAT041") //Cont�m o caminho que ser� gravado o log de erro
Local _cMvSeri 			:= GetMv("GEN_FAT038") //Serie da nota de sa�da de entrada nas empresas Matriz e Origem

Local _cMvEsp			:= GetMv("MV_ESPECIE") //Contem tipos de documentos fiscais utilizados na emissao de notas fiscais
Local _aPosEsp 			:= {}
Local _nMvEsp 			:= 0
Local _lEspec			:= .F.
Local _ni

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

Conout("GENA012C - Rotina para execu��o do Execauto de Gera��o do Pedido de Vendas e de Gera��o do Documento de Sa�da, empresa Matriz (GEN)")

lMsErroAuto := .F.

MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabGen,_aItmPv,3)

If !lMsErroAuto
	
	Conout("GENA012C - Gerou com sucesso o pedido, ir� ver se existe a necessidade de desbloquear por cr�dito na empresa Matriz (GEN)")
	
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
		
		_cQuery := ChangeQuery(_cQuery)
		
		If Select(_cAliSC9) > 0
			dbSelectArea(_cAliSC9)
			(_cAliSC9)->(dbCloseArea())
		EndIf
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliSC9,.T.,.T.)
		
		Conout("GENA012C - Ira varrer a SC9 para realizar o desbloqueio por cr�dito na empresa Matriz (GEN)")
		
		While ( (_cAliSC9)->(!Eof()) .And. (_cAliSC9)->C9_FILIAL == xFilial("SC9") .And. (_cAliSC9)->C9_PEDIDO == SC5->C5_NUM .And. Eval(bValid) )
			
			If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .OR. (SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .OR.;
				SC9->C9_BLCRED=="09" )
				
				Conout("GENA012C - Libera��o de Cr�dito do Pedido de Vendas na empresa Matriz (GEN)")
				
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
				a450Grava(1,.T.,.F.,.F.)
				
			EndIf
			
			(_cAliSC9)->(DbSkip())
			
		EndDo
		
	EndIf
	
	//�������������������������������������������������������������������������������������X�
	//� Fim    Rotina para desbloquear cr�dito para que o pedido seja faturado sem problemas�
	//�������������������������������������������������������������������������������������X�
	
	//���������������������������������������������������������������������������������������������������������X�
	//'Inicio - Caso tenha ocorrido com sucesso a gera��o do Pedido de Vendas, ir� iniciar a gera��o da Nota   '*
	//���������������������������������������������������������������������������������������������������������X�
	DbSelectArea("SC9")
	DbSetOrder(1)
	If DbSeek(xFilial("SC9")+SC5->C5_NUM)
		
		Conout("GENA012C - Inicio da Gera��o do Documento de Sa�da na empresa Matriz (GEN).")
		
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
		
		CONOUT("GENA012C - Ira realizar a geracao da nota de saida na empresa Matriz (GEN) ")
		
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
		
		_cPedExc := SC9->C9_PEDIDO
		
		If _lEspec
			
			_cNotaImp := MaPVlNFs(_aPVlNFs,_cMvSeri,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)
			
		Else
			
			_cNotaImp := ""
			
			_cMsg := "A Nota n�o foi gerada, pois a serie n�o esta preenchida corretamente." + cEnt
			_cMsg := "Favor revisar o parametro GEN_FAT038." + cEnt
			
			Conout(_cMsg)
			
			MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )
			
		EndIf
		
		//�������������������������������������������������������Ŀ
		//�Caso a nota n�o seja gerado ir� chamar a rotina de erro�
		//���������������������������������������������������������
		If Empty(AllTrim(_cNotaImp))
			
			Conout("GENA012C - Gera��o do Documento de Sa�da na empresa Matriz (GEN) apresentou erro .")
			
			_cPedExc := SC9->C9_PEDIDO
			
			//�����������������������������������������������������������Ŀ
			//�Chamando o Execauto de Altera��o e em seguida o de exclus�o�
			//�������������������������������������������������������������
			
			//�������������������������������Ŀ
			//�Alterando a quantidade liberada�
			//���������������������������������
			For _ni := 1 To Len(_aItmPv)
				
				_aItmPv[_ni][_nPosLb][2] := 0
				
			Next _ni
			
			CONOUT("GENA012C - Ir� alterar o pedido de vendas para poder realizar a exclus�o na empresa Matriz (GEN)")
			
			lMsErroAuto := .F.
			MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabGen,_aItmPv,4)
			
			If !lMsErroAuto
				
				CONOUT("GENA012C - Alterou o pedido de vendas com sucesso, ir� realizar a exclus�o na empresa Matriz (GEN).")
				
				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabGen,_aItmPv,5)
				
				If !lMsErroAuto
					
					CONOUT("GENA012C - Excluiu com sucesso o pedido de vendas na empresa Matriz (GEN).")
					
					_cErroLg += "  " + cEnt
					_cErroLg += " O Pedido: " + _cPedExc + " foi exclu�do com sucesso. "  + cEnt
					_cErroLg += " Favor verificar o pedido: "  + cEnt
					_cErroLg += " Pois ele teve que ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
					_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois no processo houve erro. " + cEnt
					_cErroLg += " " + cEnt
					
					MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
					
				Else
					
					Conout("GENA012C - N�o conseguiu excluir o pedido de vendas na empresa Matriz (GEN).")
					
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
					
					MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
					
				EndIf
				
			Else
				
				CONOUT("GENA012C - N�o conseguiu alterar o pedido de vendas na empresa Matriz (GEN).")
				
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
				
				MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
				
			EndIf
			
		EndIf
		
	EndIf
	
Else
	
	Conout("GENA012C - N�o conseguiu gerar o Pedido de Vendas na empresa Matriz (GEN). ")
	
	_aErro := GetAutoGRLog()
	
	For _ni := 1 To Len(_aErro)
		
		_cErroLg += _aErro[_ni] + cEnt
		
		CONOUT(_cErroLg)
		
	Next _ni
	
	MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil  + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraPedido.txt" , _cMsg )
	
	Disarmtransaction()
	
EndIf

RestArea(_aArea)

Return _cNotaImp



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA012D  �Autor  �Angelo Henrique     � Data �  13/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para gerar o documento de entrada/Pedido de vendas   ���
���          �e Nota de Sa�da da empresa origem para a matriz GEN         ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA012D(_aCabDcOr,_aItmDcOr,_aCabOri,_aItmPd,_cNotaImp)

Local _aArea 			:= GetArea()
Local _cQuery			:= ""
Local _cAliSC9			:= GetNextAlias()
Local _aTmpPV1			:= {}
Local _aPVlNFs			:= {}
Local _cNotaImp			:= ""
Local _cMsg				:= ""
Local _aErro			:= {}
Local _cErroLg			:= ""
Local _nPosLb			:= aScan(_aItmPd[1], { |x| Alltrim(x[1]) == "C6_QTDLIB" })
Local _cPedExc			:= ""
Local _cLogPd			:= GetMv("GEN_FAT041") //Cont�m o caminho que ser� gravado o log de erro
Local _cMvSeri 			:= GetMv("GEN_FAT038") //SERIE nota de sa�da
Local _cEmp				:= AllTrim(SM0->M0_CODIGO)
Local _cFil				:= AllTrim(SM0->M0_CODFIL)
Local _cMvEsp			:= GetMv("MV_ESPECIE") //Contem tipos de documentos fiscais utilizados na emissao de notas fiscais
Local _aPosEsp 			:= {}
Local _nMvEsp 			:= 0
Local _lEspec			:= .F.
Local _ni

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

DbSelectArea("SC5")
DbSetOrder(1)

Conout("GENA012D - Rotina de Gera��o da Nota Fiscal de Entrada (Devolu��o da Consigna��o) e Gera��o da Nota Fiscal de Sa�da da Venda na empresa Origem ")

Conout("GENA012D - Primeiro a Gera��o da Nota Fiscal de Entrada (Devolu��o da Consigna��o) da empresa origem")

DbSelectArea("SA1")
DbSelectArea("SA2")

aAdd( _aCabDcOr, { "F1_DOC"       ,_cNotaImp })

MSExecAuto({|x,y,z|MATA103(x,y,z)},_aCabDcOr, _aItmDcOr,3)

If lMsErroAuto
	
	_lRet := .F.
	
	Conout("GENA012D - N�o conseguiu gerar a Nota Fiscal de Entrada (Devolu��o da Consigna��o) na empresa origem. ")
	
	_aErro := GetAutoGRLog()
	
	For _ni := 1 To Len(_aErro)
		
		_cErroLg += _aErro[_ni] + cEnt
		
		CONOUT(_cErroLg)
		
	Next _ni
	
	MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraDocEntrada.txt" , _cErroLg )
	
	Disarmtransaction()
	
EndIf

Conout("GENA012D - Segundo a Gera��o da Nota Fiscal de Sa�da caso o saldo n�o seja negativo da empresa origem .")

If Len(_aItmPd) > 0 .And. !lMsErroAuto
	
	Conout("GENA012D - Gera��o da Nota Fiscal de Sa�da, empresa origem. ")
	
	//���������������������������������������������������������������ri@&:x�[�
	//�Forcar o ponteramento no produto para n�o dar erro no execauto�
	//���������������������������������������������������������������ril(:x�[�
	DbSelectArea("SB1")
	
	lMsErroAuto := .F.
	
	MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabOri,_aItmPd,3)
	
	If !lMsErroAuto
		
		Conout("GENA012D - Gerou com sucesso o pedido, ir� ver se existe a necessidade de desbloquear por cr�dito, empresa origem")
		
		//�����������������������������������������������������������������������������X�
		//�Rotina para desbloquear cr�dito para que o pedido seja faturado sem problemas�
		//�����������������������������������������������������������������������������X�
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
			
			_cQuery := ChangeQuery(_cQuery)
			
			If Select(_cAliSC9) > 0
				dbSelectArea(_cAliSC9)
				(_cAliSC9)->(dbCloseArea())
			EndIf
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliSC9,.T.,.T.)
			
			Conout("GENA012D - Ir� varrer a SC9, desbloqueio por cr�dito, empresa origem")
			
			While ( (_cAliSC9)->(!Eof()) .And. (_cAliSC9)->C9_FILIAL == xFilial("SC9") .And. (_cAliSC9)->C9_PEDIDO == SC5->C5_NUM .And. Eval(bValid) )
				
				If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .OR. (SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .OR.;
					SC9->C9_BLCRED=="09" )
					
					
					Conout("GENA012D - Libera��o de Cr�dito do Pedido de Vendas na empresa origem")
					
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
					a450Grava(1,.T.,.F.,.F.)
					
				EndIf
				
				(_cAliSC9)->(DbSkip())
				
			EndDo
			
			*'-----------------------------------------------------------------------------------------------------'*
			*'Inicio - Caso tenha ocorrido com sucesso a gera��o do Pedido de Vendas, ir� iniciar a gera��o da Nota'*
			*'-----------------------------------------------------------------------------------------------------'*
			DbSelectArea("SC9")
			DbSetOrder(1)
			If DbSeek(xFilial("SC9")+SC5->C5_NUM)
				
				Conout("GENA012D - Inicio da Gera��o do Documento de Sa�da de vendas na empresa origem")
				
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
				
				*'------------------------------------------------'*
				*'Rotina utilizada para realizar a gera��o da Nota'*
				*'------------------------------------------------'*
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
				
				_cPedExc := SC9->C9_PEDIDO
				
				If _lEspec
					
					_cNotaImp := MaPVlNFs(_aPVlNFs,_cMvSeri,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)
					
				Else
					
					_cNotaImp := ""
					
					_cMsg := "A Nota n�o foi gerada, pois a serie n�o esta preenchida corretamente." + cEnt
					_cMsg := "Favor revisar o parametro GEN_FAT003." + cEnt
					
					Conout(_cMsg)
					
					MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )
					
				EndIf
				
				//�������������������������������������������������������Ŀ
				//�Caso a nota n�o seja gerado ir� chamar a rotina de erro�
				//���������������������������������������������������������
				If Empty(AllTrim(_cNotaImp))
					
					_cNotaImp := ""
					
					Conout("GENA012D - Gera��o do Documento de Sa�da de venda apresentou erro na empresa origem.")
					
					_cPedExc := SC9->C9_PEDIDO
					
					//�����������������������������������������������������������Ŀ
					//�Chamando o Execauto de Altera��o e em seguida o de exclus�o�
					//�������������������������������������������������������������
					
					//�������������������������������Ŀ
					//�Alterando a quantidade liberada�
					//���������������������������������
					For _ni := 1 To Len(_aItmPd)
						
						_aItmPd[_ni][_nPosLb][2] := 0
						
					Next _ni
					
					Conout("GENA012D - Ir� alterar o pedido de vendas para poder realizar a exclus�o na empresa origem.")
					
					lMsErroAuto := .F.
					MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabOri,_aItmPd,4)
					
					If !lMsErroAuto
						
						Conout("GENA012D - Alterou o pedido de vendas com suceeso, ir� realizar a exclus�o, empresa origem.")
						
						lMsErroAuto := .F.
						MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabOri,_aItmPd,5)
						
						If !lMsErroAuto
							
							Conout("GENA011B - Excluiu com sucesso o pedido de vendas na empresa origem.")
							
							_cErroLg += "  " + cEnt
							_cErroLg += " O Pedido: " + _cPedExc + " foi exclu�do com sucesso. "  + cEnt
							_cErroLg += " Favor verificar o pedido: "  + cEnt
							_cErroLg += " Pois ele teve que ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
							_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois no processo houve erro. " + cEnt
							_cErroLg += " " + cEnt
							
							MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
							
						Else
							
							Conout("GENA012D - N�o conseguiu excluir o pedido de vendas na empresa origem.")
							
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
							
							MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
							
						EndIf
						
					Else
						
						CONOUT("GENA012D - N�o conseguiu alterar o pedido de vendas na empresa origem.")
						
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
						
						MemoWrite ( _cLogPd + "Emp" +SM0->M0_CODIGO + " Fil"+ AllTrim(SM0->M0_CODFIL) + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
						
					EndIf
					
				EndIf
				
			EndIf
			
			If Select(_cAliSC9) > 0
				dbSelectArea(_cAliSC9)
				(_cAliSC9)->(dbCloseArea())
			EndIf
			
		Else
			
			Conout("GENA012D - N�o conseguiu gerar o Pedido de Vendas na empresa origem. ")
			
			_aErro := GetAutoGRLog()
			
			For _ni := 1 To Len(_aErro)
				
				_cErroLg += _aErro[_ni] + cEnt
				
				CONOUT(_cErroLg)
				
			Next _ni
			
			MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraPedidoVenda.txt" , _cMsg )
			
			Disarmtransaction()
			
		EndIf
		
	EndIf
	
EndIf

RestArea(_aArea)

Return _cNotaImp


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA012E  �Autor  �Angelo Henrique     � Data �  13/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para cria��o da Nota de Entrada com os valores       ���
���          �atualizados na empresa Matriz (GEN)                         ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function U_GENA012E(_aCabDcEn,_aItmDcEn,_cNotaOri)

Local _aArea 			:= GetArea()
Local _aErro			:= {}
Local _cErroLg			:= ""
Local _cEmp				:= AllTrim(SM0->M0_CODIGO)
Local _cFil				:= AllTrim(SM0->M0_CODFIL)

Local _cLogPd			:= GetMv("GEN_FAT041") //Cont�m o caminho que ser� gravado o log de erro
Local _ni

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

CONOUT("GENA012E - Gera��o da Nota Fiscal de Entrada,  empresa Matriz (GEN)")

DbSelectArea("SA1")
DbSelectArea("SA2")

aAdd( _aCabDcEn, { "F1_DOC"       ,_cNotaOri })

MSExecAuto({|x,y,z|MATA103(x,y,z)},_aCabDcEn, _aItmDcEn,3)

If lMsErroAuto
	
	Conout("GENA012E - N�o foi poss�vel gerar a Nota Fiscal de Entrada de Vendas na empresa Matriz. ")
	
	_aErro := GetAutoGRLog()
	
	For _ni := 1 To Len(_aErro)
		
		_cErroLg += _aErro[_ni] + cEnt
		
		CONOUT(_cErroLg)
		
	Next _ni
	
	MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraDocEntrada.txt" , _cErroLg )
	
	Disarmtransaction()
	
EndIf

RestArea(_aArea)

Return
