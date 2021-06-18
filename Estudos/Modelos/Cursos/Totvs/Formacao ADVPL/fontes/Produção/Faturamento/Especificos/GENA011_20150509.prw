#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

#DEFINE cEnt Chr(13)+Chr(10)   
#DEFINE dProcInter cTod("30/04/2015")

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA011   �Autor  �Angelo Henrique     � Data �  29/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de presta��o de contas do processo de consigna��o    ���
���          �que foi realizado manualmente.                              ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//����������������������������Ŀ
//�Funcao para chamar rotina   �
//�principal e processar Oferta�
//������������������������������
User Function GENA011T() //VENDA + OFERTA

conout(Time()+ " " + "GENA011 - TUDO")

U_GENA011({"2"})
U_GENA011({"1"})

Return()


//����������������������������Ŀ
//�Funcao para chamar rotina   �
//�principal e processar Oferta�
//������������������������������
User Function GENA011O() //OFERTA

conout(Time()+ " " + "GENA011 - OFERTA")

U_GENA011({"1"})

Return()


//����������������������������Ŀ
//�Funcao para chamar rotina   �
//�principal e processar Venda �
//������������������������������
User Function GENA011V() //VENDA

conout(Time()+ " " + "GENA011 - VENDA")

U_GENA011({"2"})

Return()


//����������������������������Ŀ
//�Funcao para chamar rotina   �
//�principal e processar Venda �
//������������������������������
User Function GENA011U()

Prepare Environment Empresa "00" Filial "1022"
tcsqlexec("UPDATE "+RetSqlName("SB2")+" SET B2_QTNP = 0 WHERE B2_FILIAL = '"+xFilial("SB2")+"' AND B2_LOCAL = '01' AND D_E_L_E_T_ = ' '")
Reset Environment

Return()


//�����������������������������������������Ŀ
//�Rotina Principal - Executada via schedule�
//�������������������������������������������
User Function GENA011(_aParam1) //CHAMADA VIA SCHEDULE PASSANDO PARAMETROS 1 (OFERTA) OU 2 (VENDA)

Local _cParam1 := _aParam1[1] //Parametro enviado na configura��o da schedule para saber se o TES a ser pesquisado � de Venda ou Oferta
conout(Time()+ " " + "GENA011 - Inicio - Rotina de Gera��o do Processo de Prestacao de Contas")

Prepare Environment Empresa "00" Filial "1022"

If upper(alltrim(GetEnvServer())) $ "SCHEDULE" //EXECUTA SOMENTE NO AMBIENTE SCHEDULE
	dDataBase := dProcInter
	U_GENA011A(_cParam1)
Endif

conout(Time()+ " " + "GENA011 - Fim - Rotina de Gera��o do Processo de Prestacao de Contas")
Reset Environment

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA011A   �Autor  �Angelo Henrique     � Data �  29/08/14  ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina respons�vel por fazer o filtro das Notas de Entradas ���
���          �corretas para realizar o processo de presta��o de contas.   ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA011A(_cParam1)

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
Local _aCabDcEn := {} //Vetor contendo o cabe�alho documento de entrada empresa Matriz
Local _alinhaDe := {} //Vetor que recebe os itens do documento de entrada empresa Matriz
Local _aItmDcEn := {} //Vetor contendo os itens do documento de entrada empresa Matriz
Local _aCabDcOr := {} //Vetor contendo o cabe�a'lho documento de entrada empresa Origem
Local _alinhaOr := {} //Vetor que recebe os itens do documento de entrada empresa Origem
Local _aItmDcOr := {} //Vetor contendo os itens do documento de entrada empresa Origem
Local _nQuant	:= 0
Local _aCabPd 	:= {} //Gera��o do cabe�alho Pedido de Vendas na empresa Origem
Local _alinha	:= {} //Gera��o do Item do Pedido de Vendas na empresa Origem
Local _aItmPd	:= {} //Recebe os itens do pedido de Vendas na empresa Origem
Local _aCabPv	:= {} //Gera��o do cabe�alho Pedido de Vendas na empresa Matriz
Local _aLinPd	:= {} //Gera��o do Item do Pedido de Vendas na empresa Matriz
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
Local _dDtAco	:= CTOD(" \ \ ")
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
Local _lNegat   := .F.
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

Local _cTesEn	:= GetMv("GEN_FAT008") //Cont�m o TES utilizado na nota de entrada das empresas Matriz - Oferta
Local _cTesDv	:= GetMv("GEN_FAT012") //Cont�m o TES utilizado no Pedido de Vendas das empresas Origem - Oferta
Local _cMvCdPv 	:= GetMv("GEN_FAT013") //Condi��o de pagamento pedido de venda empresa Matriz
Local _cMvCdOr 	:= GetMv("GEN_FAT014") //Condi��o de pagamento pedido de venda empresa Origem
Local _cMvTbPr 	:= GetMv("GEN_FAT015") //Cont�m a tabela de pre�o usado no pedido de vendas na empresa Matriz e Origem
Local _cLogPd	:= GetMv("GEN_FAT016") //Cont�m o caminho que ser� gravado o log de erro
Local _cMvClDe	:= GetMv("GEN_FAT017") //Cont�m o cliente que ser� utilizado para realizar as movimenta��es na empresa Matriz
Local _cMvLjDe  := GetMv("GEN_FAT018") //Cont�m a Loja que ser� utilizado as movimenta��es na empresa Matriz
Local _cFil		:= GetMv("GEN_FAT019") //Cont�m a Filial correta da empresa GEN que ser� realizado as movimenta��es de consigna��o
Local _cMvEspc 	:= GetMv("GEN_FAT020") //Cont�m a especie utilizada na nota de entrada das empresas Matriz e Origem
Local _cMvCdDe	:= GetMv("GEN_FAT021") //Cont�m a condi��o de pagamento utilizada na nota de entrada das empresas Matriz e Origem
Local _cMvTsPd	:= GetMv("GEN_FAT022") //Cont�m o TES utilizado no Pedido de Vendas das empresas Matriz, consigna��o (positivo)
Local _cMvTsPv	:= GetMv("GEN_FAT023") //Cont�m o TES utilizado no Pedido de Vendas das empresas Origem - Venda
Local _cMvTsDe	:= GetMv("GEN_FAT024") //Cont�m o TES utilizado na nota de entrada das empresas Matriz - Venda
Local _cMvTsOr	:= GetMv("GEN_FAT025") //Cont�m o TES utilizado na nota de entrada das empresas Origem, consigna��o (positivo) - Vendas
Local _cMvSeri 	:= GetMv("GEN_FAT026") //SERIE nota de sa�da de entrada nas empresas Matrz e Origem
Local _cServ 	:= GETMV("GEN_FAT027") //Cont�m o Ip do servidor para realizar as mudan�as de ambiente
Local _nPort  	:= GETMV("GEN_FAT028") //Cont�m a porta para realizar as mudan�as de ambiente
Local _cAmb  	:= GETMV("GEN_FAT029") //Cont�m o ambiente a ser utilizado para realizar as mudan�as de filial
Local _cMvTsPdV := GETMV("GEN_FAT042") //Cont�m o TES utilizado no Pedido de Vendas das empresas Matriz, devolu��o (negativo) - Vendas
Local _cMvTsOrV := GETMV("GEN_FAT043") //Cont�m o TES utilizado na nota de entrada das empresas Origem, consigna��o (negativo)- Vendas
Local _cMvTsOf	:= GetMv("GEN_FAT053") //Cont�m o TES utilizado no Pedido de Vendas das empresas Matriz, consigna��o (positivo) - Oferta
Local _cMvTsPOf := GETMV("GEN_FAT054") //Cont�m o TES utilizado no Pedido de Vendas das empresas Matriz, devolu��o (negativo) - Oferta
Local _cMvTsOrF	:= GetMv("GEN_FAT055") //Cont�m o TES utilizado na nota de entrada das empresas Origem, consigna��o (positivo) - Oferta
Local _cMvTsNoF := GETMV("GEN_FAT056") //Cont�m o TES utilizado na nota de entrada das empresas Origem, consigna��o (negativo)- Oferta

//���������������������������
//�Executar limpeza dos logs�
//���������������������������

//_aDir := directory(Alltrim(_cLogPd)+"*")
//For _ni:= 1 to Len(_aDir)
//	fErase(Alltrim(_cLogPd)+_aDir[_ni][1])
//Next _ni

conout(Time()+ " " + "GENA011A - Inicio - Verificando Itens da Nota de Entrada")


tcSqlExec("UPDATE "+RetSqlName("SB1")+" SET B1_DESC = REPLACE(B1_DESC,'|','/')") //TROCA "|" POR "/" NA DESCRICAO DOS PRODUTOS PARA NAO GERAR ERRO NA ROTINA GRAVAARQ/LEARQ

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
	
	DbSelectArea("SA2")
	DbSetOrder(3)
	If DbSeek(xFilial("SA2")+SA1->A1_CGC)
		
		_cFnGen := SA2->A2_COD
		_cLjGen := SA2->A2_LOJA
		
		//�����������������������������������������������������������������������Ŀ
		//�Query para pegar os TES que ser�o utilizados no processo de consigna��o�
		//�������������������������������������������������������������������������
		_cQryTes := " SELECT F4_CODIGO, F4_XPRCONT, F4_XTPCONT
		_cQryTes += " FROM " + RetSqlName("SF4") + " SF4
		_cQryTes += " WHERE F4_XPRCONT = 'S'
		_cQryTes += " AND F4_XTPCONT = '" + _cParam1 + "'
		_cQryTes += " AND D_E_L_E_T_ = ' '
		
		If Select(_cAliTes) > 0
			dbSelectArea(_cAliTes)
			(_cAliTes)->(dbCloseArea())
		EndIf
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQryTes), _cAliTes, .F., .T.)
		_cTesPr := "" //Limpando a variavel
		
		While (_cAliTes)->(!EOF())
			_cTesPr += (_cAliTes)->F4_CODIGO + "','"
			(_cAliTes)->(DbSkip())
		EndDo
		
		If Select(_cAliTes) > 0
			dbSelectArea(_cAliTes)
			(_cAliTes)->(dbCloseArea())
		EndIf
		
		_cTesPr := Substr(_cTesPr,1,Len(_cTesPr)-3)
		
		//��������������������������������������������������������������������������������������������������������������Ŀ
		//�Query ir� varrer os itens das notas de entradas para realizar toda a movimenta��o nas empresas correspondentes�
		//����������������������������������������������������������������������������������������������������������������
		
		_cQuery := "SELECT * FROM (
		_cQuery += " SELECT DISTINCT SB1.B1_COD, SB1.B1_PROC, SB1.B1_LOJPROC, SB1.B1_DESC, SB1.B1_UM, SB1.B1_LOCPAD, SB1.B1_MSBLQL,
		_cQuery += " (
		_cQuery += "     SELECT NVL(SUM(SD2PR.D2_QUANT),0)
		_cQuery += "     FROM " + RetSqlName("SD2") + " SD2PR
		_cQuery += "     WHERE SD2PR.D2_TES   IN ('" + _cTesPr + "')
		_cQuery += "     AND SD2PR.D2_COD     = SB1.B1_COD
		_cQuery += "     AND SD2PR.D2_FILIAL  = '" + _cFil + "'
		_cQuery += " 	 AND SD2PR.D2_EMISSAO BETWEEN '" + DTOS(FirstDay(dDatabase)) + "' AND '" + DTOS(LastDay(ddatabase)) + "'
		_cQuery += "     AND SD2PR.D2_XCONSIG = ' '
		_cQuery += "     AND SD2PR.D_E_L_E_T_ = ' '
		//_cQuery += " 	 AND SD2PR.D2_EMISSAO BETWEEN '20150100' AND '20150105'
		_cQuery += " ) AS VALOR_ORI,
		_cQuery += " (
		_cQuery += "     SELECT NVL(SUM(SD1SE.D1_QUANT),0)
		_cQuery += "     FROM " + RetSqlName("SD1") + " SD1SE
		_cQuery += "     WHERE SD1SE.D1_TES   IN ('" + _cTesPr + "')
		_cQuery += "     AND SD1SE.D1_COD     = SB1.B1_COD
		_cQuery += "     AND SD1SE.D1_FILIAL  = '" + _cFil + "'
		_cQuery += " 	 AND SD1SE.D1_EMISSAO BETWEEN '" + DTOS(FirstDay(dDatabase)) + "' AND '" + DTOS(LastDay(ddatabase)) + "'
		_cQuery += "     AND SD1SE.D1_XCONSIG = ' '
		_cQuery += "     AND SD1SE.D_E_L_E_T_ = ' '
		//_cQuery += " 	 AND SD1SE.D1_EMISSAO BETWEEN '20150100' AND '20150105'
		_cQuery += " ) AS VALOR_DEV,
		_cQuery += " (
		_cQuery += "     SELECT NVL(SUM(SD2CA.D2_QUANT),0)
		_cQuery += "     FROM " + RetSqlName("SD2") + " SD2CA
		_cQuery += "     WHERE SD2CA.D2_COD     = SB1.B1_COD
		_cQuery += "     AND SD2CA.D2_TES   IN ('" + _cTesPr + "')
		_cQuery += "     AND SD2CA.D2_FILIAL  = '" + _cFil + "'
		_cQuery += "     AND SD2CA.D_E_L_E_T_ = '*'
		_cQuery += "     AND SD2CA.D2_XCONSIG = 'S'
		_cQuery += " ) AS VALOR_CAN
		_cQuery += " FROM " + RetSqlName("SB1") + " SB1
		_cQuery += " INNER JOIN " + RetSqlName("SZ4") + " SZ4 ON SB1.B1_XSITOBR = SZ4.Z4_COD
		_cQuery += " 	 AND SZ4.Z4_MSBLQL = '2'
		_cQuery += " 	 AND SZ4.Z4_FILIAL = '" + xFilial("SZ4") + "'
		_cQuery += " 	 AND SZ4.D_E_L_E_T_ = ' '
		_cQuery += " WHERE SB1.B1_FILIAL = '" + xFilial("SB1") + "'
		_cQuery += " AND SB1.D_E_L_E_T_ = ' '
		_cQuery += " AND SB1.B1_ISBN <> ' '
		
		//ATENCAO DEIXAR SEM COMENTARIO SOMENTE UMA EMPRESA. FOI ESCRITO DESSA FORMA PARA FACILITAR A MANUTENCAO.
		//AC
		//_cQuery += " AND SB1.B1_PROC = '031811'
		//_cQuery += " AND SB1.B1_LOJPROC = '02'
		
		//LTC
		//_cQuery += " AND SB1.B1_PROC = '0380796'
		//_cQuery += " AND SB1.B1_LOJPROC = '01'
		  
		//FORENSE
		//_cQuery += " AND SB1.B1_PROC = '0380794'
		//_cQuery += " AND SB1.B1_LOJPROC = '01'
		
		//EGK
		_cQuery += " AND SB1.B1_PROC = '0380795'
		_cQuery += " AND SB1.B1_LOJPROC = '01'
		
		//_cQuery += " AND SB1.B1_COD IN ('00004180                      ','00004289                      ','00004522                      ')
		_cQuery += " )
		_cQuery += " where VALOR_ORI <> 0 OR VALOR_DEV <> 0 OR VALOR_CAN <> 0
		_cQuery += " ORDER BY B1_PROC, B1_LOJPROC
		
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
			If DbSeek(xFilial("SA2")+(_cAliQry)->B1_PROC+(_cAliQry)->B1_LOJPROC)
				
				_cForn 	:= AllTrim(SA2->A2_COD)
				_cLojFn := AllTrim(SA2->A2_LOJA)
				_cCGCOr := AllTrim(SA2->A2_CGC)
				
				DbSelectArea("SA1")
				DbSetOrder(3)
				If DbSeek(xFilial("SA1")+_cCGCOr)
					
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
					If _lEmp
						
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
								aAdd ( _aCabPv , { "C5_TRANSP"  , ''	, Nil} )
								aAdd ( _aCabPv , { "C5_TIPOCLI" , _cTipPv 	, Nil} )
								//aAdd ( _aCabPv , { "C5_VEND1" 	, _cVenPv 	, Nil} )
								aAdd ( _aCabPv , { "C5_VEND1" 	, '' 	, Nil} )
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
								aAdd ( _aCabPd , { "C5_TRANSP"  , _cTrpGen	, Nil} )
								aAdd ( _aCabPd , { "C5_TIPOCLI" , _cTipGen 	, Nil} )
								aAdd ( _aCabPd , { "C5_VEND1" 	, _cVenGen 	, Nil} )
								aAdd ( _aCabPd , { "C5_CONDPAG" , _cMvCdOr	, Nil} )
								aAdd ( _aCabPd , { "C5_TABELA"  , _cMvTbPr	, Nil} )
								aAdd ( _aCabPd , { "C5_EMISSAO" , dDatabase	, Nil} )
								aAdd ( _aCabPd , { "C5_MOEDA" 	, 1			, Nil} )
								aAdd ( _aCabPd , { "C5_TPLIB" 	, "2"		, Nil} )
								
								//�������������������������������������������������������������
								//�Array contendo o cabe�alho da nota de entrada para a Matriz�
								//�������������������������������������������������������������
								
								_aCabDcEn := {} //Vetor contendo o cabe�alho documento de entrada empresa Matriz
								_aItmDcEn := {} //Vetor contendo os itens do documento de entrada empresa Matriz
								
								aadd(_aCabDcEn , {"F1_TIPO"   	,"N"		, Nil} ) //ALTERADO DANILO "D"
								aadd(_aCabDcEn , {"F1_FORMUL" 	,"N"		, Nil} )
								aadd(_aCabDcEn , {"F1_SERIE"  	,_cMvSeri	, Nil} )
								aadd(_aCabDcEn , {"F1_EMISSAO"	,dDataBase	, Nil} )
								aadd(_aCabDcEn , {"F1_FORNECE"	,PADR(AllTrim(_cForn),TAMSX3("F1_FORNECE")[1])		, Nil} )
								aadd(_aCabDcEn , {"F1_LOJA"   	,_cLojFn	, Nil} )
								aadd(_aCabDcEn , {"F1_ESPECIE"	,_cMvEspc	, Nil} )
								aadd(_aCabDcEn , {"F1_COND"		,_cMvCdDe	, Nil} )
								
								//�������������������������������������������������������������
								//�Array contendo o cabe�alho da nota de entrada para a Origem�
								//�������������������������������������������������������������
								
								_aCabDcOr := {} //Vetor contendo o cabe�alho documento de entrada empresa Origem
								_aItmDcOr := {} //Vetor contendo os itens do documento de entrada empresa Origem
								
								//aadd(_aCabDcOr , {"F1_TIPO"   	,"D"		, Nil} ) //ALTERADO DANILO "N"
								aadd(_aCabDcOr , {"F1_TIPO"   	,"B"		, Nil} ) // 03/02 - RAFAEL LEITE
								aadd(_aCabDcOr , {"F1_FORMUL" 	,"N"		, Nil} )
								aadd(_aCabDcOr , {"F1_SERIE"  	,_cMvSeri	, Nil} )
								aadd(_aCabDcOr , {"F1_EMISSAO"	,dDataBase	, Nil} )
								//aadd(_aCabDcOr , {"F1_FORNECE"	,PADR(AllTrim(_cFnGen),TAMSX3("F1_FORNECE")[1])	, Nil} )
								aadd(_aCabDcOr , {"F1_FORNECE"	,PADR(AllTrim(_cCliGen),TAMSX3("F1_FORNECE")[1])	, Nil} )
								//aadd(_aCabDcOr , {"F1_LOJA"   	,_cLjGen	, Nil} )
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
									
									_lNegat := .F.
									_nQuant := 0
									_cForUp 	:= AllTrim((_cAliQry)->B1_PROC)
									_cLojUp 	:= AllTrim((_cAliQry)->B1_LOJPROC)
									
									//�����������������������������������������������������Ŀ
									//�Validando a quantidade correta a ser usada nas notas.�
									//�������������������������������������������������������
									
									_nQuant := (_cAliQry)->VALOR_ORI - (_cAliQry)->VALOR_DEV - (_cAliQry)->VALOR_CAN
									If _nQuant = 0
										
										//Rafael Leite - 07/05/2015 - Inclusao de mensagem de log
										_cMsg := "Produto com calculo de prestacao ZERO. Sera desconsiderado do processamento. Codigo do produto: " + Alltrim((_cAliQry)->B1_COD)
										conout(Time()+ " " + _cMsg)
										MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod Calc Zero "  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
										(_cAliQry)->(DbSkip())
										Loop
									EndIf
									
									//PRODUTOS BLQUEADOS
									If (_cAliQry)->B1_MSBLQL == '1'
										_cMsg := "Produto bloqueado (B1_MSBLQL) nao sera considerado na prestacao, mas tem quantidade a prestar contas: " + Alltrim((_cAliQry)->B1_COD)
										conout(Time()+ " " + _cMsg)
										MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod Blq "  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
										(_cAliQry)->(DbSkip())
										Loop
									Endif
									
									//�����������������������������������������������������������Ŀ
									//�Validando se a tabela de pre�o possui o produto selecionado�
									//�������������������������������������������������������������
									DbSelectArea("DA1")
									DbSetOrder(1)
									If DbSeek(xFilial("DA1")+_cMvTbPr+(_cAliQry)->B1_COD)
										
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
											If StoD((_cAliQry1)->ACO_DATATE) > dDatabase .OR. Empty((_cAliQry1)->ACO_DATATE)
												
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
												
												//����������������������������������I
												//�Fun��o para alimentar Log de erro�
												//����������������������������������I
												_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry1)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
												_lVcDesc := .T.
												conout(Time()+ " " + _cMsg)
												MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
												(_cAliQry)->(DbSkip())
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
												
												If _dDtAco > dDatabase .OR. Empty((_cAliQry2)->ACO_DATATE)
													
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
													
													//����������������������������������I
													//�Fun��o para alimentar Log de erro�
													//����������������������������������I
													_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry2)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
													_lVcDesc := .T.
													conout(Time()+ " " + _cMsg)
													MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
													(_cAliQry)->(DbSkip())
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
													
													If _dDtAco > dDatabase .OR. Empty((_cAliQry3)->ACO_DATATE)
														
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
													Else
														//����������������������������������I
														//�Fun��o para alimentar Log de erro�
														//����������������������������������I
														_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry3)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
														_lVcDesc := .T.
														conout(Time()+ " " + _cMsg)
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
											If _nQuant < 0
												_lNegat := .T.
												_nQuant := _nQuant * -1
											EndIf
											
											_aSldB6 := {} //Zerando o Vetor de Saldos em poder de terceiros
											//���������������������������������������������������a��
											//�Realizando a busca por saldo em poder de terceiros�
											//���������������������������������������������������a��
											_cQuery := " SELECT B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO, B6_DOC, B6_SALDO,
											_cQuery += " B6_SERIE, B6_CLIFOR, B6_LOJA, D1_ITEM, B6_IDENT, 
											
											//Rafael Leite - 08/05/2015 - Incluido tratamento para comparar saldo GEN e Empresa Origem
											_cQuery += " (SELECT B6_SALDO
  											_cQuery += " FROM " + RetSqlName("SB6") + " B6_ORI
										  	_cQuery += " WHERE B6_ORI.B6_FILIAL = '"+_cEmpFl+"'
											_cQuery += " AND B6_ORI.B6_DOC      = SB6.B6_DOC
											_cQuery += " AND B6_ORI.B6_SERIE    = SB6.B6_SERIE
											_cQuery += " AND B6_ORI.B6_PRODUTO  = SB6.B6_PRODUTO
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
										   
											//Rafael Leite - 07/05/2015 - Adicionado filtro para exibir somente documentos com saldo na empresa origem.
											_cQuery += " AND (SELECT B6_SALDO
  											_cQuery += " FROM " + RetSqlName("SB6") + " B6_ORI
										  	_cQuery += " WHERE B6_ORI.B6_FILIAL = '"+_cEmpFl+"'
											_cQuery += " AND B6_ORI.B6_DOC      = SB6.B6_DOC
											_cQuery += " AND B6_ORI.B6_SERIE    = SB6.B6_SERIE
											_cQuery += " AND B6_ORI.B6_PRODUTO  = SB6.B6_PRODUTO
											_cQuery += " AND D_E_L_E_T_  = ' ' ) > 0  
																				   
											_cQuery += " ORDER BY B6_EMISSAO
											
											If Select(_cAliQry5) > 0
												dbSelectArea(_cAliQry5)
												(_cAliQry5)->(dbCloseArea())
											EndIf
											
											dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry5, .F., .T.)
											
											If (_cAliQry5)->(!EOF())
												//Passando a quantidade para outra variavel, trabalhando assim livremente
												//sem alterar as demais valida��es e aplica��es da vari�vel _nQuant
												//pois a vari�vel _nQuant � utilizada abaixo em outras situa��es
												_nQtdSld := _nQuant
												
												While (_cAliQry5)->(!EOF())
													
													//08/05/2015 - Rafael Leite - Compara saldo GEN e Empresa Origem
													_nSldB6Comp := (_cAliQry5)->B6_SALDO
													
													//Se o saldo de poder terceiro na origem estiver menor que no GEN, utiliza o saldo da Origem.
													If _nSldB6Comp > (_cAliQry5)->SALDO_ORI
														_nSldB6Comp := (_cAliQry5)->SALDO_ORI
													Endif 
													
													//_nQtdB6 := _nQtdSld - (_cAliQry5)->B6_SALDO
													_nQtdB6 := _nQtdSld - _nSldB6Comp
													
													//����������������������������������������������������������������
													//�Caso a quantidade seja igual ao saldo, preencher somente um vez�
													//�o array e sair do while para este produto                      �
													//����������������������������������������������������������������
													If _nQtdB6 = 0
														//aAdd(_aSldB6,{_nQtdB6, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM })
														//aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM }) //03/02 - RAFAEL LEITE
														aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM, (_cAliQry5)->B6_IDENT})
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
														aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM, (_cAliQry5)->B6_IDENT })
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
														aAdd(_aSldB6,{_nSldB6Comp, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM, (_cAliQry5)->B6_IDENT })
														
														//_nQtdSld := _nQtdSld - (_cAliQry5)->B6_SALDO
														_nQtdSld := _nQtdSld - _nSldB6Comp
													EndIf
													(_cAliQry5)->(DbSkip())
												EndDo
											Else
												//���������������������������������� �
												//�Fun��o para alimentar Log de erro�
												//���������������������������������� �
												_cMsg := "N�o foi encontrado no sistema Saldo em poder de terceiros para o produto: " + AllTrim((_cAliQry)->B1_COD) + ", com o cliente/fornecedor: " + AllTrim(_cCliPv) + " e Loja: " + AllTrim(_cLjPv)
												conout(Time()+ " " + _cMsg)
												MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
												(_cAliQry)->(DbSkip())
												Loop
											EndIf
											
											If Select(_cAliQry5) > 0
												dbSelectArea(_cAliQry5)
												(_cAliQry5)->(dbCloseArea())
											EndIf
											
											_nQtdSld := 0
											
											//�������������������������������������������������������Ŀ
											//�Validando se a quantidade esta correta para prosseguir �
											//���������������������������������������������������������
											For _ni := 1 To Len(_aSldB6)
												_nQtdSld += _aSldB6[_ni][1]
											Next _ni
											
											If _nQtdSld = _nQuant
												For _ni := 1 To Len(_aSldB6)
													
													//������������������������������������������������������������Ŀ
													//�Array contendo a linha do pedido de vendas na empresa Matriz�
													//��������������������������������������������������������������
													aAdd ( _alinha 	, 	{ "C6_ITEM"    	, _cContC6, Nil})
													aAdd ( _alinha 	, 	{ "C6_PRODUTO" 	, (_cAliQry)->B1_COD 					, Nil})
													aAdd ( _alinha 	, 	{ "C6_DESCRI"  	, (_cAliQry)->B1_DESC  					, Nil})
													aAdd ( _alinha 	, 	{ "C6_QTDVEN"  	, _aSldB6[_ni][1]		   				, Nil})
													aAdd ( _alinha 	, 	{ "C6_PRCVEN"  	, _nPrcVn	    						, Nil})
													aAdd ( _alinha 	, 	{ "C6_VALOR"   	, _aSldB6[_ni][1] *	_nPrcVn				, Nil})
													aAdd ( _alinha 	, 	{ "C6_QTDLIB"  	, _aSldB6[_ni][1]						, Nil})
													
													If !_lNegat
														If _cParam1 == "2" //Vendas
															aAdd ( _alinha 	, 	{ "C6_TES"     	, _cMvTsPd 		   					, Nil}) //TES diferente
														Else
															aAdd ( _alinha 	, 	{ "C6_TES"     	, _cMvTsOf 		   					, Nil}) //TES diferente
														EndIf
													Else
														If _cParam1 == "2" //Vendas
															aAdd ( _alinha 	, 	{ "C6_TES"     	, _cMvTsPdV		   					, Nil}) //TES diferente valor negativo Vendas
														Else
															aAdd ( _alinha 	, 	{ "C6_TES"     	, _cMvTsPOf		   					, Nil}) //TES diferente valor negativo Oferta
														EndIf
													EndIf
													
													aAdd ( _alinha 	, 	{ "C6_LOCAL"   	, (_cAliQry)->B1_LOCPAD   				, Nil})
													aAdd ( _alinha 	, 	{ "C6_ENTREG"	, dDataBase				   				, Nil})
													
													/*
													aAdd ( _alinha 	, 	{ "C6_NFORI"	, _aSldB6[_ni][2]		   				, Nil})
													aAdd ( _alinha 	, 	{ "C6_SERIORI"	, _aSldB6[_ni][3]		   				, Nil})
													aAdd ( _alinha 	, 	{ "C6_ITEMORI"	, _aSldB6[_ni][4]		   				, Nil})
													*/
													
													aAdd ( _alinha 	, 	{ "C6_NFORI"	, PADR(AllTrim(_aSldB6[_ni][2]),TAMSX3("C6_NFORI")[1])		, Nil})
													aAdd ( _alinha 	, 	{ "C6_SERIORI"	, PADR(AllTrim(_aSldB6[_ni][3]),TAMSX3("C6_SERIORI")[1])	, Nil})
													aAdd ( _alinha 	, 	{ "C6_ITEMORI"	, PADR(AllTrim(_aSldB6[_ni][4]),TAMSX3("C6_ITEMORI")[1])	, Nil})
													aAdd ( _alinha 	, 	{ "C6_IDENTB6"	, PADR(AllTrim(_aSldB6[_ni][5]),TAMSX3("C6_IDENTB6")[1])	, Nil})
													
													aAdd(_aItmPv , _alinha  )
													_alinha := {}
													
													//��������������������������������������������������������������Ŀ
													//�Array contendo os itens do Documento de Entrada empresa Origem�
													//����������������������������������������������������������������
													aAdd(_alinhaOr	,	{"D1_ITEM"		, _cContC6, Nil})
													aAdd(_alinhaOr	,	{"D1_COD"  		, (_cAliQry)->B1_COD					, Nil})
													aAdd(_alinhaOr	,	{"D1_QUANT"		, _aSldB6[_ni][1]						, Nil})
													aAdd(_alinhaOr	,	{"D1_VUNIT"		, _nPrcVn								, Nil})
													aAdd(_alinhaOr	,	{"D1_TOTAL"		, _aSldB6[_ni][1] *	_nPrcVn				, Nil})
													
													If !_lNegat
														If _cParam1 == "2" //Vendas
															aAdd(_alinhaOr	,	{"D1_TES"		, _cMvTsOr							, Nil})
														Else
															aAdd(_alinhaOr	,	{"D1_TES"		, _cMvTsOrF							, Nil})
														EndIf
													Else
														If _cParam1 == "2" //Vendas
															aAdd(_alinhaOr	,	{"D1_TES"		, _cMvTsOrV							, Nil})
														Else
															aAdd(_alinhaOr	,	{"D1_TES"		, _cMvTsNoF							, Nil})
														EndIf
													EndIf
													
													aAdd(_alinhaOr	,	{"D1_LOCAL"		, (_cAliQry)->B1_LOCPAD					, Nil})
													
													If !_lNegat
														cQry := "SELECT D2_ITEM, D2_IDENTB6 FROM "+RetSqlName("SD2")+" D2
														cQry += " WHERE D2_FILIAL = '"+_cEmpFl+"'
														cQry += " AND D2_DOC = '"+_aSldB6[_ni][2]+"'
														cQry += " AND D2_SERIE = '"+_aSldB6[_ni][3]+"'
														cQry += " AND D2_COD = '"+(_cAliQry)->B1_COD+"'
														cQry += " AND D_E_L_E_T_ = ' '
														If Select(_cAliQryX) > 0
															dbSelectArea(_cAliQryX)
															(_cAliQryX)->(dbCloseArea())
														EndIf
														
														dbUseArea(.T., "TOPCONN", TcGenQry(,,cQry), _cAliQryX, .F., .T.)
														
														aAdd(_alinhaOr	,	{"D1_NFORI"		, _aSldB6[_ni][2]						, Nil})
														aAdd(_alinhaOr	,	{"D1_SERIORI"	, _aSldB6[_ni][3]						, Nil})
														aAdd(_alinhaOr	,	{"D1_ITEMORI"	, (_cAliQryX)->D2_ITEM					, Nil})
														aAdd(_alinhaOr	,	{"D1_IDENTB6"	, (_cAliQryX)->D2_IDENTB6				, Nil}) // 03/02 - RAFAEL LEITE
														
														If Select(_cAliQryX) > 0
															dbSelectArea(_cAliQryX)
															(_cAliQryX)->(dbCloseArea())
														EndIf
														
													EndIf
													
													aadd(_aItmDcOr,_alinhaOr)
													_alinhaOr := {}
													_cContC6 := Soma1(_cContC6)
												Next _ni
											Else
												//�����������������������������������
												//�Fun��o para alimentar Log de erro�
												//�����������������������������������
												_cMsg := "Saldo em poder de terceiros para o produto " + AllTrim((_cAliQry)->B1_COD) + ", com o cliente/fornecedor " + AllTrim(_cCliPv) + " e Loja " + AllTrim(_cLjPv) + " n�o atende a quantidade necess�ria."
												conout(Time()+ " " + _cMsg)
												MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
												(_cAliQry)->(DbSkip())
												Loop
											EndIf
											
											If !_lNegat
												
												//��������������������������������������������������������������
												//�Array contendo a linha do pedido de vendas na empresa Origem�
												//��������������������������������������������������������������
												aAdd ( _aLinPd 	, 	{ "C6_ITEM"    	, STRZERO(_nContOr,TAMSX3("C6_ITEM")[1]), Nil})
												aAdd ( _aLinPd 	, 	{ "C6_PRODUTO" 	, (_cAliQry)->B1_COD 					, Nil})
												aAdd ( _aLinPd 	, 	{ "C6_DESCRI"  	, (_cAliQry)->B1_DESC  					, Nil})
												aAdd ( _aLinPd 	, 	{ "C6_QTDVEN"  	, _nQuant				   				, Nil})
												aAdd ( _aLinPd 	, 	{ "C6_PRCVEN"  	, _nPrcVn	    						, Nil})
												aAdd ( _aLinPd 	, 	{ "C6_VALOR"   	, _nQuant *	_nPrcVn						, Nil})
												aAdd ( _aLinPd 	, 	{ "C6_QTDLIB"  	, _nQuant   							, Nil})
												
												If _cParam1 == "2" //Vendas
													aAdd ( _aLinPd 	, 	{ "C6_TES"  , _cMvTsPv     		   					, Nil}) //TES utilizado no Pedido de Vendas das empresas Origem - Venda
												Else
													aAdd ( _aLinPd 	, 	{ "C6_TES"  , _cTesDv     		   					, Nil}) //TES utilizado no Pedido de Vendas das empresas Origem - Oferta
												EndIf
												
												aAdd ( _aLinPd 	, 	{ "C6_LOCAL"   	, (_cAliQry)->B1_LOCPAD   				, Nil})
												aAdd ( _aLinPd 	, 	{ "C6_ENTREG"	, dDataBase				   				, Nil})
												
												//��������������������������������������������������������������Ŀ
												//�Array contendo os itens do Documento de Entrada empresa Matriz�
												//����������������������������������������������������������������
												aAdd(_alinhaDe	,	{"D1_ITEM"		, STRZERO(_nContOr,TAMSX3("D1_ITEM")[1]), Nil})
												aAdd(_alinhaDe	,	{"D1_COD"  		, (_cAliQry)->B1_COD					, Nil})
												aAdd(_alinhaDe	,	{"D1_QUANT"		, _nQuant								, Nil})
												aAdd(_alinhaDe	,	{"D1_VUNIT"		, _nPrcVn								, Nil})
												aAdd(_alinhaDe	,	{"D1_TOTAL"		, _nQuant *	_nPrcVn						, Nil})
												
												If _cParam1 == "2"
													aAdd(_alinhaDe	,	{"D1_TES"	, _cMvTsDe								, Nil}) //TES utilizado na nota de entrada das empresas Matriz - Venda
												Else
													aAdd(_alinhaDe	,	{"D1_TES"	, _cTesEn								, Nil}) //TES utilizado na nota de entrada das empresas Matriz - Oferta
												EndIf
												aAdd(_alinhaDe	,	{"D1_LOCAL"		, (_cAliQry)->B1_LOCPAD					, Nil})
												
												//�������������������������������������������������������������H����H����H����H
												//�Calcular oos campos customizados de quantidade e valor total empresa Origem�
												//�������������������������������������������������������������H������H������H�
												_nQdTtOr += _nQuant
												_nVlTtOr += _nQuant * _nPrcVn
												
												aadd(_aItmDcEn,_alinhaDe)
												aAdd(_aItmPd , _aLinPd  )
												_nContOr ++
											EndIf
											
											//�������������������������������������������������������������H����H����H����H
											//�Calcular oos campos customizados de quantidade e valor total empresa Matriz�
											//�������������������������������������������������������������H������H������H�
											_nQtdTot += _nQuant
											_nValTot += _nQuant * _nPrcVn
											
											_aLinPd   := {}
											_alinhaDe := {}
										Else
											//���������������������������������� �
											//�Fun��o para alimentar Log de erro�
											//���������������������������������� �
											_cMsg := "Valor informado na tabela de pre�o: " + AllTrim(_cMvTbPr) + " n�o pode ser menor ou igual a 0 (ZERO), produto: " + AllTrim((_cAliQry)->B1_COD)
											conout(Time()+ " " + _cMsg)
											MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
										EndIf
									Else
										//���������������������������������� �
										//�Fun��o para alimentar Log de erro�
										//���������������������������������� �
										_cMsg := "N�o foi encontrado no sistema tabela de pre�o/produto com os c�digos: " + AllTrim(_cMvTbPr) + " / " + AllTrim((_cAliQry)->B1_COD)
										conout(Time()+ " " + _cMsg)
										MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
									EndIf
									(_cAliQry)->(DbSkip())
								EndDo
								
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
								If Len(_aItmPv) > 0
									If !_lVcDesc
										
										//Realizando a gera��o da Nota de Sa�da para devolu��o de Consigna��o
										//na empresa Matriz (GEN)
										_cNtDvCon := U_GENA011B(_aCabPv,_aItmPv)
										
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
											
											conout(Time()+ " " + "GENA011 - Inicio do RPC para logar na empresa origem Pedido/Nota de Sa�da")
											conout(Time()+ " " + "GENA011 - Empresa: " + _cEmpCd + " Filial: " + _cEmpFl)
											
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
												_oServer:CallProc("RPCSetType", 3)
												_cNotaImp := ""
												_cNotaImp := _oServer:CallProc("U_GENA011C",_aCabPd,_cTemp1,_aCabDcOr,_cTemp2,_cNtDvCon,dProcInter)
												//�����������������������������������������������������������������Ŀ
												//�Realizando a nova conex�o para entrar na empresa e filial correta�
												//�������������������������������������������������������������������
												//Fecha a Conexao com o Servidor
												RESET ENVIRONMENT IN SERVER _oServer
												CLOSE RPCCONN _oServer
												_oServer := Nil
											Else
										   		conout(Time()+ " " + "GENA011 - Nao foi possivel logar. Retorno para empresa origem nao executado.")
											EndIf
											
											If !Empty(_cNotaImp)
												
												//��������������������������������������������������������������������������������������
												//�Rotina que ir� criar a Nota de Entrada/Pedido de Vendas e Nota de Sa�da na empresa GEN,
												//�ap�s ter ocorrido com sucesso�
												//�a gera��o do pedido de vendas e da Nota de Sa�da para a empresa GEN                 �
												//��������������������������������������������������������������������������������������
												If _cNotaImp <> "XXX"
													U_GENA011D(_aCabDcEn,_aItmDcEn,_cNotaImp)
												Endif
												conout(Time()+ " " + "GENA011A - Inicio dos UPDATES para as notas com FLAG")
												conout(Time()+ " " + "GENA011A - UPDATE dos Itens nota de saida SD2")
												
												//RAFAEL LEITE - 27/01/2015 - ALTERADO PARA ATUALIZAR SOMENTE OS PRODUTOS CONTIDOS NA NOTA FISCAL
												/*
												_cQuery := "UPDATE " + RetSqlName("SD2")
												_cQuery += " SET D2_XCONSIG = 'S'
												_cQuery += " WHERE D2_FILIAL  = '" + _cFil + "'
												_cQuery += " AND D2_EMISSAO BETWEEN '" + DTOS(FirstDay(dDatabase)) + "' AND '" + DTOS(LastDay(ddatabase)) + "'
												_cQuery += " AND D2_TES IN ('" + _cTesPr + "')
												_cQuery += " AND D2_COD IN (SELECT B1_COD FROM "+RetSqlName("SB1")+" WHERE B1_PROC	= '" + _cForUp + "' AND B1_LOJPROC = '" + _cLojUp + "' AND D_E_L_E_T_ = ' ')
												_cQuery += " AND D_E_L_E_T_ = ' '
												*/
												
												_cQuery := "UPDATE " + RetSqlName("SD2")
												_cQuery += " SET D2_XCONSIG = 'S'
												_cQuery += " WHERE D2_FILIAL  = '" + _cFil + "'
												_cQuery += " AND D2_EMISSAO BETWEEN '" + DTOS(FirstDay(dDatabase)) + "' AND '" + DTOS(LastDay(ddatabase)) + "'
												_cQuery += " AND D2_TES IN ('" + _cTesPr + "')
												_cQuery += " AND D2_COD IN (SELECT SD1.D1_COD "
												_cQuery += " 				FROM "+RetSqlName("SD1")+" SD1 "
												_cQuery += " 				WHERE SD1.D1_FILIAL = '" + _cFil + "' "
												_cQuery += " 				AND SD1.D1_DOC = '" + _cNotaImp + "' "
												_cQuery += " 				AND SD1.D1_SERIE = '" + _cMvSeri + "' "
												_cQuery += " 				AND SD1.D_E_L_E_T_ = ' ')
												_cQuery += " AND D_E_L_E_T_ = ' '
												
												If TCSQLEXEC(_cQuery) != 0
													//����������������������������������I
													//�Fun��o para alimentar Log de erro�
													//����������������������������������I
													_cMsg := "1 - N�o foi possivel realizar o update na SD2(Itens da Nota de Saida) ap�s a execucao da Prestacao de Contas" + cEnt
													conout(Time()+ " " + _cMsg)
													MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + "Consigna��o.txt" , _cMsg )
												EndIf
												
												conout(Time()+ " " + "GENA011A - UPDATE dos Itens nota de entrada SD1")
												
												//RAFAEL LEITE - 27/01/2015 - ALTERADO PARA ATUALIZAR SOMENTE OS PRODUTOS CONTIDOS NA NOTA FISCAL
												/*
												_cQuery := "UPDATE " + RetSqlName("SD1")
												_cQuery += " SET D1_XCONSIG = 'S'
												_cQuery += " WHERE D1_FILIAL  = '" + _cFil + "'
												_cQuery += " AND D1_EMISSAO BETWEEN '" + DTOS(FirstDay(dDatabase)) + "' AND '" + DTOS(LastDay(ddatabase)) + "'
												_cQuery += " AND D1_TES IN ('" + _cTesPr + "')
												_cQuery += " AND D1_COD IN (SELECT B1_COD FROM "+RetSqlName("SB1")+" WHERE B1_PROC	= '" + _cForUp + "' AND B1_LOJPROC = '" + _cLojUp + "' AND D_E_L_E_T_ = ' ')
												_cQuery += " AND D_E_L_E_T_ = ' '
												*/
												
												_cQuery := "UPDATE " + RetSqlName("SD1")
												_cQuery += " SET D1_XCONSIG = 'S'
												_cQuery += " WHERE D1_FILIAL  = '" + _cFil + "'
												_cQuery += " AND D1_EMISSAO BETWEEN '" + DTOS(FirstDay(dDatabase)) + "' AND '" + DTOS(LastDay(ddatabase)) + "'
												_cQuery += " AND D1_TES IN ('" + _cTesPr + "')
												_cQuery += " AND D1_COD IN (SELECT SD1.D1_COD "
												_cQuery += " 				FROM "+RetSqlName("SD1")+" SD1 "
												_cQuery += " 				WHERE SD1.D1_FILIAL = '" + _cFil + "' "
												_cQuery += " 				AND SD1.D1_DOC = '" + _cNotaImp + "' "
												_cQuery += " 				AND SD1.D1_SERIE = '" + _cMvSeri + "' "
												_cQuery += " 				AND SD1.D_E_L_E_T_ = ' ')
												_cQuery += " AND D_E_L_E_T_ = ' '
												
												If TCSQLEXEC(_cQuery) != 0
													//����������������������������������I
													//�Fun��o para alimentar Log de erro�
													//����������������������������������I
													_cMsg := "N�o foi possivel realizar o update na SD1(Itens da Nota de Entrada) ap�s a execucao da Prestacao de Contas" + cEnt
													conout(Time()+ " " + _cMsg)
													MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + "Consigna��o.txt" , _cMsg )
												EndIf
												
												conout(Time()+ " " + "GENA011A - UPDATE dos Itens nota de saida SD2 CANCELADAS")
												
												//RAFAEL LEITE - 27/01/2015 - ALTERADO PARA ATUALIZAR SOMENTE OS PRODUTOS CONTIDOS NA NOTA FISCAL
												/*
												_cQuery := "UPDATE " + RetSqlName("SD2")
												_cQuery += " SET D2_XCONSIG = 'C'
												_cQuery += " WHERE D2_FILIAL = '" + _cFil + "'
												_cQuery += " AND D2_XCONSIG = 'S'
												_cQuery += " AND D_E_L_E_T_ = '*'
												_cQuery += " AND D2_COD IN (SELECT B1_COD FROM "+RetSqlName("SB1")+" WHERE B1_PROC	= '" + _cForUp + "' AND B1_LOJPROC = '" + _cLojUp + "' AND D_E_L_E_T_ = ' ')
												*/
												
												_cQuery := "UPDATE " + RetSqlName("SD2")
												_cQuery += " SET D2_XCONSIG = 'C'
												_cQuery += " WHERE D2_FILIAL = '" + _cFil + "'
												_cQuery += " AND D2_XCONSIG = 'S'
												_cQuery += " AND D_E_L_E_T_ = '*'
												_cQuery += " AND D2_COD IN (SELECT SD1.D1_COD "
												_cQuery += " 				FROM "+RetSqlName("SD1")+" SD1 "
												_cQuery += " 				WHERE SD1.D1_FILIAL = '" + _cFil + "' "
												_cQuery += " 				AND SD1.D1_DOC = '" + _cNotaImp + "' "
												_cQuery += " 				AND SD1.D1_SERIE = '" + _cMvSeri + "' "
												_cQuery += " 				AND SD1.D_E_L_E_T_ = ' ')
												
												
												If TCSQLEXEC(_cQuery) != 0
													//����������������������������������I
													//�Fun��o para alimentar Log de erro�
													//����������������������������������I
													_cMsg := "2 - N�o foi possivel realizar o update na SD2(Itens da Nota de Entrada) Canceladas ap�s a execucao da Prestacao de Contas" + cEnt
													conout(Time()+ " " + _cMsg)
													MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + "Consigna��o.txt" , _cMsg )
												EndIf
												conout(Time()+ " " + "GENA011A - Fim dos UPDATES para as notas com FLAG")
											EndIf
										EndIf
									EndIf
								Else
									//���������������������������������� �
									//�Fun��o para alimentar Log de erro�
									//���������������������������������� �
									_cMsg := "Produto:  " + AllTrim((_cAliQry)->B1_COD) + " n�o possui saldo em poder de terceiros, para o cliente: " + _cCliPv + " e loja: " + _cLjPv
									conout(Time()+ " " + _cMsg)
									MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
									(_cAliQry)->(DbSkip())
								EndIf
							Else
								//���������������������������������� �
								//�Fun��o para alimentar Log de erro�
								//���������������������������������� �
								_cMsg := "A Tabela de pre�o:  " + AllTrim(_cMvTbPr) + " encontra-se vencida, favor verifica. "
								conout(Time()+ " " + _cMsg)
								MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
								(_cAliQry)->(DbSkip())
							EndIf
						Else
							//���������������������������������� �
							//�Fun��o para alimentar Log de erro�
							//���������������������������������� �
							_cMsg := "N�o foi encontrado no sistema tabela de pre�o com o c�digo: " + AllTrim(_cMvTbPr)
							conout(Time()+ " " + _cMsg)
							MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
							(_cAliQry)->(DbSkip())
						EndIf
					Else
						//���������������������������������� �
						//�Fun��o para alimentar Log de erro�
						//���������������������������������� �
						_cMsg := "N�o foi encontrado no sistema empresa (SM0) com o CNPJ: " + SA2->A2_CGC
						conout(Time()+ " " + _cMsg)
						MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + ".txt" , _cMsg )
						(_cAliQry)->(DbSkip())
					EndIf
				Else
					//���������������������������������� �
					//�Fun��o para alimentar Log de erro�
					//���������������������������������� �
					_cMsg := "N�o foi encontrado no sistema Cliente com o CNPJ: " + _cCGCOr
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
					(_cAliQry)->(DbSkip())
				EndIf
			Else
				//���������������������������������� �
				//�Fun��o para alimentar Log de erro�
				//���������������������������������� �
				_cMsg := "N�o foi encontrado no sistema fornecedor com o c�digo: " + (_cAliQry)->B1_PROC + " e loja: " + (_cAliQry)->B1_LOJPROC  + ", vinculados ao produto: " + (_cAliQry)->B1_COD
				conout(Time()+ " " + _cMsg)
				MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil "+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
				(_cAliQry)->(DbSkip())
			EndIf
		EndDo
	Else
		//����������������������������������I
		//�Fun��o para alimentar Log de erro�
		//����������������������������������I
		_cMsg := "N�o foi encontrado no sistema associa��o do Cliente com o Fornecedor atrav�s do CGC cadastrado nos parametros de Consigna��o." + cEnt
		_cMsg += "Cliente: " + AllTrim(_cMvClDe) + " loja: " + AllTrim(_cMvLjDe) + cEnt
		_cMsg += "Favor verificar os parametros: GEN_FAT015 e GEN_FAT016" + cEnt
		conout(Time()+ " " + _cMsg)
		MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + "Consigna��o.txt" , _cMsg )
	EndIf
Else
	//����������������������������������I
	//�Fun��o para alimentar Log de erro�
	//����������������������������������I
	_cMsg := "N�o foi encontrado no sistema o cliente cadastrado nos parametros de Consigna��o." + cEnt
	_cMsg += "Cliente: " + AllTrim(_cMvClDe) + " loja: " + AllTrim(_cMvLjDe) + cEnt
	_cMsg += "Favor verificar os parametros: GEN_FAT015 e GEN_FAT016" + cEnt
	conout(Time()+ " " + _cMsg)
	MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + "Consigna��o.txt" , _cMsg )
EndIf

If Select(_cAliQry) > 0
	dbSelectArea(_cAliQry)
	(_cAliQry)->(dbCloseArea())
EndIf

conout(Time()+ " " + "GENA011A - Fim - Verificando Itens da Nota de Entrada")
RestArea(_aArea)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA011B  �Autor  �Angelo Henrique     � Data �  17/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina respons�vel por gerar a Nota Fiscal de Sa�da para    ���
���          �devolu��o da Consigna��o - Presta��o de Contas              ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA011B(_aCabPv,_aItmPv)

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

Local _cLogPd			:= GetMv("GEN_FAT016") //Cont�m o caminho que ser� gravado o log de erro
Local _cMvSeri 			:= GetMv("GEN_FAT026") //SERIE nota de sa�da

Local _cMvEsp			:= GetMv("MV_ESPECIE") //Contem tipos de documentos fiscais utilizados na emissao de notas fiscais
Local _aPosEsp 			:= {}
Local _nMvEsp 			:= 0
Local _lEspec			:= .F.

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

conout(Time()+ " " + "GENA011B - Rotina para execu��o do Execauto de Gera��o do Pedido de Vendas e de Gera��o do Documento de Sa�da, empresa Matriz (GEN)")

lMsErroAuto := .F.
MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,3)

If !lMsErroAuto
	
	conout(Time()+ " " + "GENA011B - Gerou com sucesso o pedido, ir� ver se existe a necessidade de desbloquear por cr�dito na empresa Matriz (GEN)")
	
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
		conout(Time()+ " " + "GENA011B - Ira varrer a SC9 para realizar o desbloqueio por cr�dito na empresa Matriz (GEN)")
		
		While ( (_cAliSC9)->(!Eof()) .And. (_cAliSC9)->C9_FILIAL == xFilial("SC9") .And. (_cAliSC9)->C9_PEDIDO == SC5->C5_NUM .And. Eval(bValid) )
			If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .OR. (SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .OR.;
				SC9->C9_BLCRED=="09" )
				conout(Time()+ " " + "GENA011B - Libera��o de Cr�dito do Pedido de Vendas na empresa Matriz (GEN)")
				
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
		conout(Time()+ " " + "GENA011B - Inicio da Gera��o do Documento de Sa�da na empresa Matriz (GEN).")
		
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
		
		conout(Time()+ " " + "GENA011B - Ira realizar a geracao da nota de saida na empresa Matriz (GEN) ")
		
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
			conout(Time()+ " " + "GENA011B - Gera��o do Documento de Sa�da na empresa Matriz (GEN) apresentou erro .")
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
			
			conout(Time()+ " " + "GENA011B - Ir� alterar o pedido de vendas para poder realizar a exclus�o na empresa Matriz (GEN)")
			
			lMsErroAuto := .F.
			MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,4)
			
			If !lMsErroAuto
				conout(Time()+ " " + "GENA011B - Alterou o pedido de vendas com sucesso, ir� realizar a exclus�o na empresa Matriz (GEN).")
				
				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,5)
				
				If !lMsErroAuto
					conout(Time()+ " " + "GENA011B - Excluiu com sucesso o pedido de vendas na empresa Matriz (GEN).")
					
					_cErroLg += "  " + cEnt
					_cErroLg += " O Pedido: " + _cPedExc + " foi exclu�do com sucesso. "  + cEnt
					_cErroLg += " Favor verificar o pedido: "  + cEnt
					_cErroLg += " Pois ele teve que ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
					_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois no processo houve erro. " + cEnt
					_cErroLg += " " + cEnt
					MemoWrite ( _cLogPd + "Emp" +SM0->M0_CODIGO + " Fil"+ AllTrim(SM0->M0_CODFIL) + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
				Else
					conout(Time()+ " " + "GENA011B - N�o conseguiu excluir o pedido de vendas na empresa Matriz (GEN).")
					
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
				conout(Time()+ " " + "GENA011B - N�o conseguiu alterar o pedido de vendas na empresa Matriz (GEN).")
				
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
	conout(Time()+ " " + "GENA011B - N�o conseguiu gerar o Pedido de Vendas na empresa Matriz (GEN). ")
	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + cEnt
		conout(_cErroLg)
	Next _ni
	MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil  + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraPedido.txt" , _cErroLg )
	Disarmtransaction()
EndIf

RestArea(_aArea)

Return _cNotaImp


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA011C  �Autor  �Angelo Henrique     � Data �  17/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina que ir� gerar a Nota fiscal de entrada para devolucao���
���          �da consigna��o e a Nota Fiscal de Sa�da de Venda.           ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GENA011C(_aCabPd,_cTemp1,_aCabDcOr,_cTemp2,_cNtDvCon,dProcPed)

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
Local _cLogPd			:= GetMv("GEN_FAT016") //Cont�m o caminho que ser� gravado o log de erro
Local _cMvSeri 			:= GetMv("GEN_FAT026") //SERIE nota de sa�da
Local _cEmp				:= AllTrim(SM0->M0_CODIGO)
Local _cFil				:= AllTrim(SM0->M0_CODFIL)
Local _cMvEsp			:= GetMv("MV_ESPECIE") //Contem tipos de documentos fiscais utilizados na emissao de notas fiscais
Local _aPosEsp 			:= {}
Local _nMvEsp 			:= 0
Local _lEspec			:= .F.
Local _aItmPd   		:= {}
Local _aItmDcOr   		:= {}

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

//Ajusta data base para facilitar execucao retroativa
dDataBase := dProcPed // 03/02 - RAFAEL LEITE

If File(_cTemp1)
	_aItmPd := u_LeArq1(_cTemp1)
Endif

If File(_cTemp2)
	_aItmDcOr := u_LeArq1(_cTemp2)
Endif

DbSelectArea("SC5")
DbSetOrder(1)

conout(Time()+ " " + "GENA011C - Rotina de Gera��o da Nota Fiscal de Entrada (Devolu��o da Consigna��o) e Gera��o da Nota Fiscal de Sa�da da Venda na empresa Origem ")
conout(Time()+ " " + "GENA011C - Primeiro a Gera��o da Nota Fiscal de Entrada (Devolu��o da Consigna��o) da empresa origem")

DbSelectArea("SA1")
DbSelectArea("SA2")

aAdd( _aCabDcOr, { "F1_DOC"       ,_cNtDvCon })
MSExecAuto({|x,y,z|MATA103(x,y,z)},_aCabDcOr, _aItmDcOr,3)

If lMsErroAuto
	_lRet := .F.
	conout(Time()+ " " + "GENA011C - N�o conseguiu gerar a Nota Fiscal de Entrada (Devolu��o da Consigna��o) na empresa origem. ")
	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + cEnt
		conout(_cErroLg)
	Next _ni
	MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraDocEntrada.txt" , _cErroLg )
	Disarmtransaction()
EndIf

conout(Time()+ " " + "GENA011C - Segundo a Gera��o da Nota Fiscal de Sa�da caso o saldo n�o seja negativo da empresa origem .")

If Len(_aItmPd) > 0 .And. !lMsErroAuto
	
	conout(Time()+ " " + "GENA011C - Gera��o da Nota Fiscal de Sa�da, empresa origem. ")
	
	_nPosLb	:= aScan(_aItmPd[1], { |x| Alltrim(x[1]) == "C6_QTDLIB" })
	
	//���������������������������������������������������������������ri@&:x�[�
	//�Forcar o ponteramento no produto para n�o dar erro no execauto�
	//���������������������������������������������������������������ril(:x�[�
	DbSelectArea("SB1")
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,3)
	If !lMsErroAuto
		conout(Time()+ " " + "GENA011C - Gerou com sucesso o pedido, ir� ver se existe a necessidade de desbloquear por cr�dito, empresa origem")
		
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
			
			If Select(_cAliSC9) > 0
				dbSelectArea(_cAliSC9)
				(_cAliSC9)->(dbCloseArea())
			EndIf
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliSC9,.T.,.T.)
			conout(Time()+ " " + "GENA011C - Ir� varrer a SC9, desbloqueio por cr�dito, empresa origem")
			
			While ( (_cAliSC9)->(!Eof()) .And. (_cAliSC9)->C9_FILIAL == xFilial("SC9") .And. (_cAliSC9)->C9_PEDIDO == SC5->C5_NUM .And. Eval(bValid) )
				If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .OR. (SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .OR.;
					SC9->C9_BLCRED=="09" )
					
					conout(Time()+ " " + "GENA011C - Libera��o de Cr�dito do Pedido de Vendas na empresa origem")
					
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
				_cPedExc := SC9->C9_PEDIDO
				conout(Time()+ " " + "GENA011C - Inicio da Gera��o do Documento de Sa�da de vendas na empresa origem")
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
				
				//_cPedExc := SC9->C9_PEDIDO
				If _lEspec
					_cNotaImp := MaPVlNFs(_aPVlNFs,_cMvSeri,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)
				Else
					_cNotaImp := ""
					_cMsg := "A Nota n�o foi gerada, pois a serie n�o esta preenchida corretamente." + cEnt
					_cMsg := "Favor revisar o parametro GEN_FAT003." + cEnt
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )
				EndIf
				
				//�������������������������������������������������������Ŀ
				//�Caso a nota n�o seja gerado ir� chamar a rotina de erro�
				//���������������������������������������������������������
				If Empty(AllTrim(_cNotaImp))
					_cNotaImp := ""
					conout(Time()+ " " + "GENA011C - Gera��o do Documento de Sa�da de venda apresentou erro na empresa origem.")
					//_cPedExc := SC9->C9_PEDIDO
					//�����������������������������������������������������������Ŀ
					//�Chamando o Execauto de Altera��o e em seguida o de exclus�o�
					//�������������������������������������������������������������
					
					//�������������������������������Ŀ
					//�Alterando a quantidade liberada�
					//���������������������������������
					For _ni := 1 To Len(_aItmPd)
						_aItmPd[_ni][_nPosLb][2] := 0
					Next _ni
					conout(Time()+ " " + "GENA011C - Ir� alterar o pedido de vendas para poder realizar a exclus�o na empresa origem.")
					
					lMsErroAuto := .F.
					MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,4)
					If !lMsErroAuto
						conout(Time()+ " " + "GENA011C - Alterou o pedido de vendas com suceeso, ir� realizar a exclus�o, empresa origem.")
						
						lMsErroAuto := .F.
						MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,5)
						If !lMsErroAuto
							conout(Time()+ " " + "GENA011B - Excluiu com sucesso o pedido de vendas na empresa origem.")
							_cErroLg += "  " + cEnt
							_cErroLg += " O Pedido: " + _cPedExc + " foi exclu�do com sucesso. "  + cEnt
							_cErroLg += " Favor verificar o pedido: "  + cEnt
							_cErroLg += " Pois ele teve que ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
							_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois no processo houve erro. " + cEnt
							_cErroLg += " " + cEnt
							MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
						Else
							conout(Time()+ " " + "GENA011C - N�o conseguiu excluir o pedido de vendas na empresa origem.")
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
						conout(Time()+ " " + "GENA011C - N�o conseguiu alterar o pedido de vendas na empresa origem.")
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
			conout(Time()+ " " + "GENA011C - N�o conseguiu gerar o Pedido de Vendas na empresa origem. ")
			_aErro := GetAutoGRLog()
			For _ni := 1 To Len(_aErro)
				_cErroLg += _aErro[_ni] + cEnt
				conout(_cErroLg)
			Next _ni
			MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraPedidoVenda.txt" , _cMsg )
			Disarmtransaction()
		EndIf
	EndIf
ElseIf Len(_aItmPd) = 0 .And. !lMsErroAuto
	_cNotaImp := "XXX"
EndIf

RestArea(_aArea)

Return _cNotaImp


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA011D  �Autor  �Angelo Henrique     � Data �  17/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina que ir� realizar a gera��o da Nota Fiscal de        ���
���          �Entrada de Vendas na empresa Matriz (GEN)                   ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA011D(_aCabDcEn,_aItmDcEn,_cNotaImp)

Local _aArea 			:= GetArea()
Local _aErro			:= {}
Local _cErroLg			:= ""
Local _cEmp				:= AllTrim(SM0->M0_CODIGO)
Local _cFil				:= AllTrim(SM0->M0_CODFIL)

Local _cLogPd			:= GetMv("GEN_FAT016") //Cont�m o caminho que ser� gravado o log de erro

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

conout(Time()+ " " + "GENA011D - Gera��o da Nota Fiscal de Entrada de Vendas,  empresa Matriz (GEN)")

DbSelectArea("SA1")
DbSelectArea("SA2")

aAdd( _aCabDcEn, { "F1_DOC" ,_cNotaImp })
MSExecAuto({|x,y,z|MATA103(x,y,z)},_aCabDcEn, _aItmDcEn,3)

If lMsErroAuto
	conout(Time()+ " " + "GENA011D - N�o foi poss�vel gerar a Nota Fiscal de Entrada de Vendas na empresa Matriz.")
	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + cEnt
		conout(_cErroLg)
	Next _ni
	MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraDocEntrada.txt" , _cErroLg )
	Disarmtransaction()
EndIf
RestArea(_aArea)

Return
