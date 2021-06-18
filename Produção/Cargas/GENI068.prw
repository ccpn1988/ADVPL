#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#DEFINE cEnt Chr(13)+Chr(10)

/*/                       
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENI068   �Autor  �Cleuto Lima         � Data �  09/10/20   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina copia da GENI068 para execu��o pontual do faturamento���
���          �de diferimentos residuais                                   ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENI068()  

Local _aArea 	:= GetArea()
Local nX		:= 0
Local lCloseEmp	:= .F.

Private lDigital := .F.
Private lGeraNF := .T. //PARAMETRO PARA INDICAR SE DEVE GERAR A NOTA (.T.) OU SOMENTE O PEDIDO (.F.)

Conout("GENI068 - Inicio da importa��o de pedido de vendas de servicos")

If Type("cFilAnt") == "U"
	lCloseEmp	:= .T.
	//�������������������������������������������������������������������Ŀ
	//�Verifica��o para saber se a rotina esta sendo chamada pela Schedule�
	//���������������������������������������������������������������������
	Prepare Environment Empresa "00" Filial "1001"
EndIf

//�������������Ŀ
//�Semaforo.	�
//���������������
IF !LockByName("GENI068",.T.,.T.,.T.)
	Conout("GENI068 - N�o foi poss�vel executar a rotina neste momento, a mesma j� est� sendo executada. "+DtoC(DDataBase)+" "+Time())
	Return .F.
EndIf		

If upper(alltrim(GetEnvServer())) $ "SCHEDULE-PRE" //EXECUTA SOMENTE NO AMBIENTE SCHEDULE
	GENI068A()
Endif

UnLockByName("GENI068",.T.,.T.,.T.)

If lCloseEmp
	Reset Environment
EndIf

RestArea(_aArea)

Return()


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENI068A  �Autor  �Angelo Henrique     � Data �  11/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para o processamento da integra��o do pedido de venda���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GENI068A()

Local _aClient		:= {} //Vetor para alimentar informa��es do cliente caso o mesmo n�o esteja cadastrado
Local _cArqAli		:= GetNextAlias()
Local _cCdMun 		:= ""
Local _cIncsr		:= ""
Local _cTpCli		:= ""
Local _cMsblq		:= ""
Local _cCep			:= ""
Local _cMunic		:= ""
Local _cRPIS		:= ""
Local _cRCSLL		:= ""
Local _cRCOFI		:= ""
Local _cRISS		:= ""
Local _cCGC			:= ""
Local _cCodPs		:= ""
Local _cEndNm		:= ""
Local _cLoja		:= "01"
Local _cCod			:= ""
Local _nLoja 		:= 0
Local _cVend		:= ""
Local _cTpDes		:= ""
Local _cDescPd		:= ""
Local _nItemC6  	:= 1 //Contador para os itens do pedido de vendas
Local _cLocB1		:= ""
Local _nQtdTot 		:= 0
Local _nValTot 		:= 0
Local _cMsg			:= ""
Local _cTransp		:= ""
Local _cCont 		:= "01"
Local _cNome		:= ""
Local cTes   		:= GetMv("GEN_FAT194",.F.,"565") // utilizada mesma TES de faturamento do curso forum antigo na 7001 que n�o gera financeiro
Local cDtValid     	:= ""

Local _nTotParc     := 0
Local _aParcItem	:= {}
Local _cPgt9Web		:= GETMV("GEN_PG9WEB")
Local nVldValPd		:= 0


Local cMVCliPJ  := GetMV("GEN_FAT254")
Local cMVCliPF  := GetMV("GEN_FAT256")

Local cIRRFPJ   := Substr(cMVCliPJ,1,1) //"1"
Local cRecPISPJ := Substr(cMVCliPJ,2,1) //"S"
Local cRecCOFPJ := Substr(cMVCliPJ,3,1) //"S"
Local cRecCSLPJ := Substr(cMVCliPJ,4,1) //"S"
Local cRecISSPJ := Substr(cMVCliPJ,5,1) //"2"
Local cAbatPJ   := Substr(cMVCliPJ,6,1) //"1"

Local cIRRFPF   := Substr(cMVCliPF,1,1) //"1"
Local cRecPISPF := Substr(cMVCliPF,2,1) //"N"
Local cRecCOFPF := Substr(cMVCliPF,3,1) //"N"
Local cRecCSLPF := Substr(cMVCliPF,4,1) //"N"
Local cRecISSPF := Substr(cMVCliPF,5,1) //"2"
Local nLimProc	:= GetMv("GEN_GENI68",.F.,2)

Local nIdPgt	:= 0
Local nQtdPdProc	:= 0

Private _cQuery		:= ""
Private _cArqTmp	:= GetNextAlias()
Private _oServer	:= Nil
Private _cFilCont	:= ""
Private _cView		:= "" //Par�metro que cont�m o nome da view que ser� consultada para a cria��o do Pedido de Vendas
Private _cLogPd		:= "" //Par�metro que cont�m o caminho onde ser� gravado o arquivo de log de inconsist�ncias
Private _aCabPd 	:= {}
Private _aItmPd 	:= {}
Private _alinha		:= {}

Private cNatCart	:= SuperGetMv("GENI068CAR",.f.,"") //NATUREZA PARA CARTAO DE CREDITO
Private cNatBol		:= SuperGetMv("GENI068BOL",.f.,"") //NATUREZA PARA BOLETO

_cView	:= "DBA_EGK.TT_I37_DIF_FUTUROS_FORUM"
_lVwWeb := .T.
_cLogPd	:= "\logsiga\ped curso\" //SUPERGETMV("MV_XCAMLOG",.T.,"\logsiga\ped venda\") //Par�metro que cont�m o caminho onde ser� gravado o arquivo de log de inconsist�ncias

//��������������������������������������������������������������������Ŀ
//�Conforme levantado ser� criado uma view disponibilizada no protheus �
//�que ir� conter todos os pedidos que dever�o ser importados          �
//����������������������������������������������������������������������
_cQuery := "SELECT * FROM "+_cView

_cTabela := GetMv("GEN_FAT064")

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqTmp, .F., .T.)

_nCtVi := 0
cCond23 := GetMv("GEN_FAT065")
cRisc23 := GetMv("GEN_FAT066")
While (_cArqTmp)->(!EOF())
	
	nQtdPdProc++

	IF nQtdPdProc > nLimProc
		Conout("GENI068 - maximo de pedidos por execu��o atingido - "+cValToChar(nLimProc)+" - encerrando processamento "+DtoC(DDataBase)+" "+Time())
		Exit
	ENDIF

	cChavCli := alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))
	
	Do While cChavCli == alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))
		
		_cPedWeb := IIF(ValType((_cArqTmp)->C5_XPEDWEB) == "N",alltrim((_cArqTmp)->C5_XPEDWEB),(_cArqTmp)->C5_XPEDWEB)
		_cPedOld := IIF(ValType((_cArqTmp)->C5_XPEDOLD) == "N",alltrim(str((_cArqTmp)->C5_XPEDOLD)),(_cArqTmp)->C5_XPEDOLD)		
		
		If Empty(_cMsg)
			_cCod 		:= ""
			_aClient 	:= {}
			_cCodOld 	:= ""
			cOrigem	:= (_cArqTmp)->ORIGEM
			
			//-----------------------------------------//
			//Gravando em vari�vel a nova filial logada//
			//-----------------------------------------//
			_cFilCont := AllTrim((_cArqTmp)->C5_FILIAL)
			
			//��������������������������������������������������������������������������������������������������������Ŀ
			//�Processo de montagem do array para o execauto de cliente												   �
			//����������������������������������������������������������������������������������������������������������
			//Conout("GENI068 - Montagem do Vetor de Clientes")
			
			//�����������������������������������������������Ŀ
			//�Ajustes de alguns dados para a inclus�o correta�
			//�������������������������������������������������
			
			_cCdMun := SUBSTR(cValToChar((_cArqTmp)->A1_COD_MUN),3,5)
			_cCdMun := IIF(Alltrim((_cArqTmp)->A1_EST) == 'EX','99999'			,_cCdMun)
			_cCep	:= IIF(Alltrim((_cArqTmp)->A1_EST) == 'EX'  ,'00000000'	,Alltrim((_cArqTmp)->A1_CEP))
			_cCep	:= StrTran(_cCep," ","")
			_cMunic	:= IIF(Alltrim((_cArqTmp)->A1_EST) == 'EX'  ,'EXTERIOR'	,(_cArqTmp)->A1_MUN)
			_cRPIS	:= IIF(Alltrim((_cArqTmp)->A1_RECPIS) == '' ,'N'		 	,Alltrim((_cArqTmp)->A1_RECPIS))
			_cRCSLL	:= IIF(Alltrim((_cArqTmp)->A1_RECCSLL)== '' ,'N'		 	,Alltrim((_cArqTmp)->A1_RECCSLL))
			_cRCOFI	:= IIF(Alltrim((_cArqTmp)->A1_RECCOFI)== '' ,'N'			,Alltrim((_cArqTmp)->A1_RECCOFI))
			_cRISS	:= IIF(Alltrim((_cArqTmp)->A1_RECISS) == '' ,'2'			,Alltrim((_cArqTmp)->A1_RECISS))
			_cRISS	:= IIF(Alltrim((_cArqTmp)->A1_RECISS) == 'N','2'			,Alltrim((_cArqTmp)->A1_RECISS))
			_cIncsr := IIF(!EMPTY(AllTrim((_cArqTmp)->A1_INSCR)),AllTrim((_cArqTmp)->A1_INSCR),"ISENTO")
			_cTpCli := STRZERO((_cArqTmp)->A1_XTIPCLI,3)
			_cMsblq := IIF((_cArqTmp)->A1_MSBLQL='A','2','1')
			_cCGC 	:= IIF((_cArqTmp)->A1_EST='EX'	,' ',(_cArqTmp)->A1_CGC	)
			_cCodPs := (_cArqTmp)->A1_CODPAIS
			_cEndNm := IIF(Empty((_cArqTmp)->A1_XENDNUM),"0",AllTrim((_cArqTmp)->A1_XENDNUM))
			_cVend	:= IIF(ValType((_cArqTmp)->A1_VEND)=="C" ,STRZERO(Val((_cArqTmp)->A1_VEND),TAMSX3("A1_VEND")[1]),STRZERO((_cArqTmp)->A1_VEND,TAMSX3("A1_VEND")[1]))
			_cTpDes	:= IIF(ValType((_cArqTmp)->A1_VEND)=="C" ,(_cArqTmp)->A1_XTPDES,cValToChar((_cArqTmp)->A1_XTPDES))
			
			//��������������������������������������������������������������������Ŀ
			//�	VERIFICA SE JA EXISTE O CLIENTE COM MESMA RAIZ DE CNPJ CADASTRADO  �
			//����������������������������������������������������������������������
			_cNome		:= upper(AllTrim((_cArqTmp)->A1_NOME))
			//VALIDA SE O CNPJ NAO ESTA PREENCHIDO COM '0' (ZERO)
			If SUBSTR(_cCGC,1,8) <> '00000000' .AND. !Empty(_cCGC)
				//Conout("GENI068 - Entrou na valida��o de CNPJ preenchido com ZERO")
				_cQuery := "SELECT A1_COD, MAX(A1_LOJA) NLOJA FROM "+ RetSqlName("SA1")
				_cQuery += " WHERE SUBSTR(A1_CGC,1,8) = SUBSTR('"+_cCGC+"',1,8) "
				_cQuery += " GROUP BY A1_COD "
				//_cQuery := ChangeQuery(_cQuery)
				
				If Select(_cArqAli) > 0
					dbSelectArea(_cArqAli)
					(_cArqAli)->(dbCloseArea())
				EndIf
				
				DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cArqAli, .F., .T.)
				dbSelectArea(_cArqAli)
				
				//SE HOUVER CLIENTE CADASTRADO ELE ADICIONA LOJA
				If (_cArqAli)->(!EOF())
					//Conout("GENI068 - Entrou na valida��o de adi��o de loja")
					DbSelectArea("SA1")
					DbSetOrder(3)
					_cCod	:= (_cArqAli)->A1_COD
					
					If !SA1->(DbSeek(xFilial("SA1") + _cCGC ))						
						_nLoja 	:= SOMA1((_cArqAli)->NLOJA)
						_cLoja	:= PADL(_nLoja,2,"0")
					Else
						_cLoja	:= SA1->A1_LOJA
					EndIf
					
				EndIf
				If Select(_cArqAli) > 0
					dbSelectArea(_cArqAli)
					(_cArqAli)->(dbCloseArea())
				EndIf
			EndIf
			
			_cBairro := alltrim((_cArqTmp)->A1_BAIRRO)
			_cEst := AllTrim((_cArqTmp)->A1_EST)
			_cEstado := allTrim((_cArqTmp)->A1_ESTADO)
			
			If len(alltrim(_cCep)) == 8 .and. _cEst <> 'EX'

				IF Empty(_cEst) .OR. Empty(_cCdMun) .OR. !ExistCpo("CC2",_cEst+_cCdMun)
					IF !U_GENA095C(_cCep,@_cEst,@_cEstado,@_cCdMun,@_cMunic,,@_cBairro)
						_cMsg := "Dados de endere�o invalido: "+Chr(13)+Chr(10)
						_cMsg += "cod.Mun.: "+_cCdMun+Chr(13)+Chr(10)
						_cMsg += "Cep: "+Alltrim((_cArqTmp)->A1_CEP)+Chr(13)+Chr(10)
						_cMsg += "Municio: "+(_cArqTmp)->A1_MUN+Chr(13)+Chr(10)

						MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_WEB_" + AllTrim(_cPedWeb) + ".txt" , _cMsg )
						(_cArqTmp)->(DbSkip())
						Loop
					EndIf
				EndIF

				_cQry := "SELECT CL.DS_LOGRADOURO_NOME,
				_cQry += " CB.DS_BAIRRO_NOME,
				_cQry += " CD.DS_CIDADE_NOME,
				_cQry += " CU.DS_UF_SIGLA,
				_cQry += " CU.DS_UF_NOME,
				_cQry += " SUBSTR(TO_CHAR(M.CODIGOMUNICIPIO),3,5) CODMUN,
				_cQry += " M.UF
				_cQry += " FROM CEP_LOGRADOUROS CL
				_cQry += " JOIN CEP_BAIRROS CB ON CL.CD_BAIRRO = CB.CD_BAIRRO
				_cQry += " JOIN CEP_CIDADES CD ON CB.CD_CIDADE = CD.CD_CIDADE
				_cQry += " JOIN CEP_UF CU ON CD.CD_UF = CU.CD_UF
				If _cEst = "DF"
					_cQry += " LEFT JOIN (SELECT * FROM MUNICIPIO_IBGE M JOIN UF_IBGE U ON M.CODIGOUF = U.CODIGOUF) M ON CU.DS_UF_SIGLA = M.UF
				Else
					_cQry += " LEFT JOIN (SELECT * FROM MUNICIPIO_IBGE M JOIN UF_IBGE U ON M.CODIGOUF = U.CODIGOUF) M ON UPPER(TRIM(CD.DS_CIDADE_NOME)) = UPPER(TRIM(M.DESCRICAO)) AND CU.DS_UF_SIGLA = M.UF
				Endif
				_cQry += " WHERE NO_LOGRADOURO_CEP = '"+_cCep+"'
				If Select(_cArqAli) > 0
					dbSelectArea(_cArqAli)
					(_cArqAli)->(dbCloseArea())
				EndIf
				DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQry), _cArqAli, .F., .T.)
				
				If !(_cArqAli)->(EOF())
					If Empty(_cBairro)
						_cBairro := alltrim((_cArqAli)->DS_BAIRRO_NOME)
					Endif
					If Empty(_cEst) .OR. _cEst = "N/A"
						_cEst := alltrim((_cArqAli)->DS_UF_SIGLA)
						_cEstado := alltrim((_cArqAli)->DS_UF_NOME)
					Endif
					If !Empty((_cArqAli)->CODMUN) .and. _cCdMun <> (_cArqAli)->CODMUN
						_cCdMun := (_cArqAli)->CODMUN
					Endif
				Endif
			Endif
			
			//������������������������������������������������������������������Ŀ
			//�Grava��o das Informa��es no Array que ser� enviado para o Execauto�
			//��������������������������������������������������������������������
			_aClient := {}
			If !Empty(_cCod)
				//Conout("GENI068 - Colocando o c�digo do cliente")
				aAdd(_aClient,{"A1_COD"	,	_cCod													,Nil})
				aAdd(_aClient,{"A1_LOJA",	_cLoja													,Nil})
			EndIf
			//Conout("GENI068 - Alimentando vetor Cliente")
			If !Empty((_cArqTmp)->A1_XCODOLD)
				aAdd(_aClient,{"A1_XCODOLD"	,	alltrim(str((_cArqTmp)->A1_XCODOLD))				,Nil})
			Endif
			aAdd(_aClient,{"A1_NOME"	,	upper(AllTrim((_cArqTmp)->A1_NOME))					,Nil})
			aAdd(_aClient,{"A1_PESSOA"	,	AllTrim((_cArqTmp)->A1_PESSOA)							,Nil})
			aAdd(_aClient,{"A1_NREDUZ"	,	AllTrim((_cArqTmp)->A1_NREDUZ)							,Nil})
			aAdd(_aClient,{"A1_CEP"		,	_cCep													,Nil})
			aAdd(_aClient,{"A1_END"		,	(_cArqTmp)->A1_END										,Nil})
			aAdd(_aClient,{"A1_XENDNUM"	,	_cEndNm													,Nil}) //Numero do endereco
			aAdd(_aClient,{"A1_COMPLEM"	,	(_cArqTmp)->A1_COMPLEMEN								,Nil})
			aAdd(_aClient,{"A1_BAIRRO"	,	(_cArqTmp)->A1_BAIRRO									,Nil})
			aAdd(_aClient,{"A1_EST"		,	AllTrim((_cArqTmp)->A1_EST)								,Nil})
			aAdd(_aClient,{"A1_ESTADO"	,	AllTrim((_cArqTmp)->A1_ESTADO)							,Nil})
			aAdd(_aClient,{"A1_COD_MUN"	,	_cCdMun													,Nil})
			aAdd(_aClient,{"A1_MUN"		,	AllTrim(_cMunic)										,Nil})
			aAdd(_aClient,{"A1_DDD"		,	(_cArqTmp)->A1_DDD										,Nil})
			aAdd(_aClient,{"A1_DDI"		,	(_cArqTmp)->A1_DDI										,Nil})
			aAdd(_aClient,{"A1_TEL"		,	(_cArqTmp)->A1_TEL										,Nil})
			aAdd(_aClient,{"A1_FAX"		,	(_cArqTmp)->A1_FAX										,Nil})
			aAdd(_aClient,{"A1_TIPO"	,	(_cArqTmp)->A1_TIPO										,Nil})
			aAdd(_aClient,{"A1_PAIS"	,	(_cArqTmp)->A1_PAIS										,Nil})
			aAdd(_aClient,{"A1_PAISDES"	,	AllTrim((_cArqTmp)->A1_PAISDES)							,Nil})
			aAdd(_aClient,{"A1_CODPAIS"	,	_cCodPs													,Nil})
			aAdd(_aClient,{"A1_CGC"		,	_cCGC													,Nil})
			aAdd(_aClient,{"A1_ENDCOB"	,	AllTrim((_cArqTmp)->A1_ENDCOB)							,Nil})
			aAdd(_aClient,{"A1_CONTATO"	,	(_cArqTmp)->A1_CONTATO									,Nil})
			aAdd(_aClient,{"A1_ENDENT"	,	(_cArqTmp)->A1_ENDENT									,Nil})
			aAdd(_aClient,{"A1_INSCRM"	,	(_cArqTmp)->A1_INSCRM									,Nil})
			aAdd(_aClient,{"A1_INSCR"	,	_cIncsr													,Nil})
			aAdd(_aClient,{"A1_TPESSOA"	,	AllTrim((_cArqTmp)->A1_TPESSOA)							,Nil})
			aAdd(_aClient,{"A1_EMAIL"	,	AllTrim((_cArqTmp)->A1_EMAIL)							,Nil})
			aAdd(_aClient,{"A1_MSBLQL"	,	_cMsblq													,Nil})
			aAdd(_aClient,{"A1_CONTA"	,	AllTrim((_cArqTmp)->A1_CONTA)							,Nil})

			aAdd(_aClient,{"A1_RECCSLL"	,	IIF(ValType(_cRCSLL)=="C",_cRCSLL,cValToChar(_cRCSLL))	,Nil})						
			aAdd(_aClient,{"A1_RECISS"	,	IIF(ValType(_cRISS)=="C" ,_cRISS,cValToChar(_cRISS))	,Nil})
			aAdd(_aClient,{"A1_XCLIPRE"	,	cValToChar((_cArqTmp)->A1_XCLIPRE)						,Nil}) //Cliente Premium
			aAdd(_aClient,{"A1_XTIPCLI"	,	_cTpCli													,Nil}) //Tipo de Cliente (GEN)
			aAdd(_aClient,{"A1_XCANALV"	,	(_cArqTmp)->A1_XCANALV									,Nil}) //Canal de Venda
			aAdd(_aClient,{"A1_VEND"	,	_cVend													,Nil})
			aAdd(_aClient,{"A1_XTPDES"	,	_cTpDes													,Nil}) //Tipo desconto
			aAdd(_aClient,{"A1_TRANSP"	,	STRZERO((_cArqTmp)->A1_TRANSP,6)						,Nil})
			aAdd(_aClient,{"A1_XCONDPG"	,	STRZERO((_cArqTmp)->A1_XCONDPG,TAMSX3("A1_XCONDPG")[1])	,Nil}) //Condicao Pagto (GEN)
			aAdd(_aClient,{"A1_COND"	,	cCond23	,Nil})
			aAdd(_aClient,{"A1_TABELA"	,	_cTabela			,Nil})
			aAdd(_aClient,{"A1_LC"		,	(_cArqTmp)->A1_LC										,Nil}) //Limite de Cr�dito
			aAdd(_aClient,{"A1_BLEMAIL"	,	(_cArqTmp)->A1_BLEMAIL									,Nil}) //Boleto por Email
			aAdd(_aClient,{"A1_RISCO"	,	cRisc23													,Nil}) //Limite de Cr�dito

			If Len(AllTrim(_cCGC)) == 14		
				aAdd(_aClient,{"A1_RECIRRF"	,	cIRRFPJ									,Nil}) //Recolhe IRR
				aAdd(_aClient,{"A1_ABATIMP"	,	cAbatPJ									,Nil}) //Modo Abatimento do Imposto (A1_ABATIMP) = Calculado pelo sistema
				aAdd(_aClient,{"A1_RECCOFI"	,	cRecCOFPJ								,Nil}) //
				aAdd(_aClient,{"A1_RECCSLL"	,	cRecCSLPJ								,Nil}) //
				aAdd(_aClient,{"A1_RECPIS"	,	cRecPISPJ								,Nil}) //
				aAdd(_aClient,{"A1_RECISS"	,	cRecISSPJ								,Nil}) //
			Else
				aAdd(_aClient,{"A1_RECPIS"	,	cRecPISPF								,Nil})
				aAdd(_aClient,{"A1_RECCSLL"	,	cRecCSLPF								,Nil})
				aAdd(_aClient,{"A1_RECCOFI"	,	cRecCOFPF								,Nil})
				aAdd(_aClient,{"A1_RECISS"	,	cRecISSPF								,Nil})			
				aAdd(_aClient,{"A1_RECIRRF"	,	cIRRFPF									,Nil}) //Recolhe IRR	
			EndIF
						
			_aCabPd  := {}
			_cPedOld := IIF(ValType((_cArqTmp)->C5_XPEDOLD) == "N",alltrim(str((_cArqTmp)->C5_XPEDOLD)),(_cArqTmp)->C5_XPEDOLD)
			_cCodOld := IIF(ValType((_cArqTmp)->A1_XCODOLD) == "N",alltrim(str((_cArqTmp)->A1_XCODOLD)),(_cArqTmp)->A1_XCODOLD)
			_cCodOld := PADR(_cCodOld,TAMSX3("A1_XCODOLD")[1]," ")
			
			//Rodrigo Mour�o - 01/02/2015. Criadas variaveis Tipo e Pedido Web para incluir no nome do arquivo de log.
			_cTipo   := IIF(ValType((_cArqTmp)->TIPO) == "N",alltrim(str((_cArqTmp)->TIPO)),(_cArqTmp)->TIPO)			
			_cFilLog := Alltrim((_cArqTmp)->C5_FILIAL)
			

			_cTransp := Space(TamSx3("C5_TRANSP")[1])
			lDigital := .T.		
			//EndIf
			
			//���������������������������������������������Ŀ
			//�Alimentando informa��es pertinente ao produto�
			//�����������������������������������������������
			
			_nItemC6	:= 1
			_aItmPd		:= {}
			//Zerando as Vari�veis
			_nTotParc	:= 0
			nVldValPd	:= 0	
			nIdPgt		:= 0		
			//Conout("GENI068 - Montagem do Vetor de Pedido de Vendas - Item")
			
			While (_cArqTmp)->(!EOF()) .And. _cPedOld == AllTrim(Str((_cArqTmp)->C5_XPEDOLD)) .and. _cCont <= "99";
				.and. cChavCli = alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))

				nIdPgt		:= (_cArqTmp)->C5_XRECORR
				_nTotParc	:= 0
				_aCabPd		:= {}

				aAdd ( _aCabPd , { "C5_FRETE" 	, 0				 						, NIL} )				
				aAdd ( _aCabPd , { "C5_TIPO"    , "N"       					   			, NIL} )

				_cCont 		:= "01"
				_alinha 	:= {}
				_aItmPd		:= {} 
				
				//Conout("GENI068 - Entrou no While do item pedido de vendas ")
				_cDescPd := Posicione("SB1",1,xFilial("SB1") + (_cArqTmp)->C6_PRODUTO,"B1_DESC")
				_cLocB1  := IIF(Empty(AllTrim((_cArqTmp)->C6_LOCAL)),Posicione("SB1",1,xFilial("SB1") + (_cArqTmp)->C6_PRODUTO,"B1_LOCPAD"),(_cArqTmp)->C6_LOCAL)

				// If "VENDA" $ _cTipo
				// 	aAdd ( _aCabPd , { "C5_CONDPAG" , _cPgt9Web             					, NIL} )
				// Else
				// 	aAdd ( _aCabPd , { "C5_CONDPAG" , (_cArqTmp)->C5_CONDPAG   				, NIL} )
				// EndIf	
				
				aAdd ( _aCabPd , { "C5_EMISSAO" , DDATABASE	   			, NIL} )
				aAdd ( _aCabPd , { "C5_XPEDOLD" , _cPedOld 									, NIL} )
				aAdd ( _aCabPd , { "C5_TPFRETE" , (_cArqTmp)->C5_TPFRETE 					, NIL} )
				aAdd ( _aCabPd , { "C5_MOEDA" 	, (_cArqTmp)->C5_MOEDA 						, NIL} )
				aAdd ( _aCabPd , { "C5_PESOL" 	, (_cArqTmp)->C5_PSOL 						, NIL} )
				aAdd ( _aCabPd , { "C5_PBRUTO" 	, (_cArqTmp)->C5_PBRUTO 					, NIL} )
				aAdd ( _aCabPd , { "C5_TIPLIB" 	, (_cArqTmp)->C5_TPLIB						, NIL} )
				aAdd ( _aCabPd , { "C5_TABELA"	, " "										, NIL} )
				aAdd ( _aCabPd , { "C5_MENNOTA"	, 'REFERENTE A COMPRA DE ['+AllTrim(_cDescPd)+']. PEDIDO ['+alltrim((_cArqTmp)->C5_XPEDWEB)+'].' 										, NIL} )
				aAdd ( _aCabPd , { "C5_XPEDWEB"	, alltrim((_cArqTmp)->C5_XPEDWEB)		, NIL} )  
				aAdd ( _aCabPd , { "C5_TRANSP" 	, _cTransp									, NIL} )
				aAdd ( _aCabPd , { "C5_XRECORR"	, (_cArqTmp)->C5_XRECORR					, NIL} )
				aAdd ( _aCabPd , { "C5_XOBS"	, '#DIFERIMENTO_FUTURO'						, NIL} )

				_cProduto := padr(alltrim((_cArqTmp)->C6_PRODUTO),tamsx3("C6_PRODUTO")[1])

				SB1->(DbSetOrder(1))
				IF !SB1->(dbSeek(xFilial("SB1")+_cProduto))
					_cMsg += "Produto " +_cProduto+" n�o localizado na tabela SB1"+ Chr(13)+Chr(10)
					(_cArqTmp)->(DbSkip())
					Loop
				Else
					If SB1->B1_PIS+SB1->B1_COFINS+SB1->B1_CSLL <> '111';
						.OR. SB1->B1_IRRF <> 'S'; 
						.OR. SB1->B1_ALIQISS == 0;
						.OR. Empty(SB1->B1_CODISS);
						.OR. Empty(SB1->B1_CNAE);
						.OR. Empty(SB1->B1_TNATREC);
						.OR. Empty(SB1->B1_CNATREC); 
						.OR. Empty(SB1->B1_TRIBMUN) 

						_cMsg += "Produto "+_cProduto+" n�o atende os criterios de faturamento como servi�o tributado no RJ!"+Chr(13)+Chr(10)+;
						"Verificar os campos a seguir no cadastro de produtos: "+;
						"B1_PIS: "+TitSX3("B1_PIS")[1]+Chr(13)+Chr(10)+;
						"B1_COFINS: "+TitSX3("B1_COFINS")[1]+Chr(13)+Chr(10)+;
						"B1_CSLL: "+TitSX3("B1_CSLL")[1]+Chr(13)+Chr(10)+;
						"B1_IRRF: "+TitSX3("B1_IRRF")[1]+Chr(13)+Chr(10)+;
						"B1_ALIQISS: "+TitSX3("B1_ALIQISS")[1]+Chr(13)+Chr(10)+;
						"B1_CODISS: "+TitSX3("B1_CODISS")[1]+Chr(13)+Chr(10)+;
						"B1_CNAE: "+TitSX3("B1_CNAE")[1]+Chr(13)+Chr(10)+;
						"B1_TNATREC: "+TitSX3("B1_TNATREC")[1]+Chr(13)+Chr(10)+;
						"B1_CNATREC: "+TitSX3("B1_CNATREC")[1]+Chr(13)+Chr(10)+;
						"B1_TRIBMUN: "+TitSX3("B1_TRIBMUN")[1]+Chr(13)+Chr(10)

						MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + ".txt" , _cMsg )
						
						(_cArqTmp)->(DbSkip())
						Loop
					
					EndIF
				EndIF
				
				aAdd ( _alinha , { "C6_ITEM"    , _cCont								, NIL} )
				aAdd ( _alinha , { "C6_PRODUTO" , _cProduto								, NIL} )
				aAdd ( _alinha , { "C6_DESCRI"  , _cDescPd  							, NIL} )
				aAdd ( _alinha , { "C6_QTDVEN"  , (_cArqTmp)->C6_QTDVEN   				, NIL} )
				aAdd ( _alinha , { "C6_QTDLIB"  , (_cArqTmp)->C6_QTDVEN   				, NIL} )
				aAdd ( _alinha , { "C6_PRUNIT"  , (_cArqTmp)->C6_PRCVEN+(_cArqTmp)->C6_VALDESC	, NIL} )					
				aAdd ( _alinha , { "C6_PRCVEN"  , (_cArqTmp)->C6_PRCVEN    				, NIL} )
				aAdd ( _alinha , { "C6_TES"     , cTes      							, NIL} )
				
				aAdd ( _alinha , { "C6_LOCAL"   ,  _cLocB1   							, NIL} )
				aAdd ( _alinha , { "C6_DESCONT" , (_cArqTmp)->C6_DESCONT    			, NIL} )
				aAdd ( _alinha , { "C6_VALDESC" , (_cArqTmp)->C6_VALDESC    			, NIL} )
				aAdd ( _alinha , { "C6_ENTREG"  , STOD((_cArqTmp)->C6_ENTREG)			, NIL} )
				aAdd ( _alinha , { "C6_XCURSO"  , (_cArqTmp)->SKU_CURSO			, NIL} )

				aAdd ( _aItmPd , aClone(_alinha)  )
				
				_nItemC6 ++
				_nQtdTot	:= (_cArqTmp)->C6_QTDVEN
				_nValTot	:= (_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN

				nPosAux := aScan(_aCabPd, {|x| x[1] == "C5_XMSGNFS" } )		
				If nPosAux == 0
					If (_cArqTmp)->TPPUBLI = 28 //Tipo de Publicacao E-Aluguel [Bruno Parreira,22/07/2019]
						cDtValid := "31/12/2019"
						aAdd ( _aCabPd , { "C5_XMSGNFS" , "Nro Pedido: "+alltrim((_cArqTmp)->C5_XPEDWEB)+" - "+AllTrim(_cDescPd)+" - DISPONIBILIZA��O, SEM CESS�O DEFINITIVA, DE TEXTO E IMAGEM DE LIVROS REF. � COLET�NEA POR MEIO DA INTERNET - V�LIDO AT� "+cDtValid, NIL} )
					Else 
						aAdd ( _aCabPd , { "C5_XMSGNFS" , "Nro Pedido: "+alltrim((_cArqTmp)->C5_XPEDWEB)+" - "+AllTrim(_cDescPd) , NIL} )
					EndIf
				Else
					If (_cArqTmp)->TPPUBLI = 28 //Tipo de Publicacao E-Aluguel [Bruno Parreira,22/07/2019]
						cDtValid := "31/12/2019"
						_aCabPd[nPosAux][2] := "Nro Pedido: "+alltrim((_cArqTmp)->C5_XPEDWEB)+" - "+AllTrim(_cDescPd)+" - DISPONIBILIZA��O, SEM CESS�O DEFINITIVA, DE TEXTO E IMAGEM DE LIVROS REF. � COLET�NEA POR MEIO DA INTERNET - V�LIDO AT� "+cDtValid
					Else 
						_aCabPd[nPosAux][2] := "Nro Pedido: "+alltrim((_cArqTmp)->C5_XPEDWEB)+" - "+AllTrim(_cDescPd)
					EndIf
					
				EndIF
			
			
				//���������������������������������������������������������������������������Ŀ
				//�Alimentando o cabe�alho do Pedido de Vendas com as informa��es customizadas�
				//�����������������������������������������������������������������������������
				
				nPosQtdTot := aScan(_aCabPd, {|x| x[1] == "C5_XQTDTOT" } )
				nPosValTot := aScan(_aCabPd, {|x| x[1] == "C5_XVALTOT" } )
				
				If nPosQtdTot == 0
					aAdd ( _aCabPd , { "C5_XQTDTOT"    , _nQtdTot      	, Nil} )
				Else
					_aCabPd[nPosQtdTot][2] := _nQtdTot	
				EndIf
				
				If nPosValTot == 0
					aAdd ( _aCabPd , { "C5_XVALTOT"    , _nValTot      	, Nil} )
				Else
					_aCabPd[nPosValTot][2] := _nValTot					
				EndIf	
				
				//Zerando as Vari�veis
				_nQtdTot := 0
				_nValTot := 0

				IF (_cArqTmp)->ORIGEM == "FORUM"
					_nTotParc+= ((_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN)
				ELSE
					_nTotParc+= ((_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN) - (_cArqTmp)->C6_VALDESC
				ENDIF	

				/*

				Cleuto - 23/09/2020 - comente este codigo pois a tabela GENESB.PEDIDO n�o � mais utilizada a muito tempo.
				If Select("TOT_PEDI")> 0
					TOT_PEDI->(DbCloseArea())
				EndIf

				BeginSql Alias "TOT_PEDI"
					SELECT SUM((ITEM.PRECO*ITEM.QUANTIDADE)-(ITEM.VALOR_DESCONTO*ITEM.QUANTIDADE)) VALOR FROM GENESB.PEDIDO PED
					JOIN GENESB.ITEM ITEM
					ON ITEM.PEDIDO_ENTITY_ID = PED.ENTITY_ID
					WHERE PED.NUMERO = %Exp: (_cArqTmp)->C5_XPEDWEB %
					AND PED.ENTITY_ID = %Exp: (_cArqTmp)->C5_XPEDOLD %
					AND SKU = %Exp: Val((_cArqTmp)->C6_PRODUTO) %
				EndSql
				
				TOT_PEDI->(DbGoTop())
				
				nVldValPd	:= TOT_PEDI->VALOR
				
				TOT_PEDI->(DbCloseArea())
				*/

				//������������������������������������������������������������������������Ŀ
				//�Valida��o da Condicao de Pagamento BOLETO OU CARTAO Multiplos/Unico     �
				//��������������������������������������������������������������������������							
				// cleuto - 09/11/2020 at� o momento a defini��o � que n�o teremos financeiro
				// If "VENDA" $ _cTipo
	                
	            //     cFORMAPG	:= ""
				// 	_aParcItem	:= U_GENI018P(_aCabPd,_cPedOld,@cFORMAPG,_nTotParc,@_cMsg,/*nVldValPd*/ nil,_cPedWeb,cOrigem,nIdPgt)
					
				// 	If cFORMAPG == 'B' //BOLETO
				// 		aAdd ( _aCabPd , { "C5_NATUREZ"  , cNatBol								, NIL} )
				// 		_aCabPd[ aScan(_aCabPd,{|x| X[1] == "C5_CONDPAG" }) ][2]	:= "001"
						
				// 	ElseIf cFORMAPG == 'C' //CARTAO
				// 		aAdd ( _aCabPd , { "C5_NATUREZ"  , cNatCart								, NIL} )
				// 	Endif
	
				// 	If Empty(_cMsg)			
				// 		For _nI := 1 To Len(_aParcItem)																	
				// 			aAdd ( _aCabPd , { "C5_DATA"+_aParcItem[_nI][6] , DataValida(_aParcItem[_nI][1]), Nil} )
				// 			aAdd ( _aCabPd , { "C5_PARC"+_aParcItem[_nI][6] , _aParcItem[_nI][2]            , Nil} )
				// 		Next
				// 	Else
				// 		If SubStr(_cMsg,1,1) = 'P'
				// 			MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_PROD_CURSO_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
				// 	    Else
				// 			MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
				//     		EndIf
				// 		(_cArqTmp)->(DbSkip())
				// 	EndIf
						
				// Else
				// 	_aParcItem := {}	
				// EndIf
				
				IF Empty(_cMsg)	
					GENI068B(_aClient,_aCabPd,_aItmPd,_cCodOld,_cPedOld,_cCGC,_cTipo,_cPedWeb,_cNome,_aParcItem,cOrigem,nIdPgt)
				EndIf	
				_cCod := ""
							
				(_cArqTmp)->(DbSkip())
				
			EndDo
			
		Else
			MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) +"_"+Iif((_cArqTmp)->DIGITAL=1,"DIG_","IMP_")+ ".txt" , _cMsg )
			(_cArqTmp)->(DbSkip())
		EndIf
		_cMsg := Space(0)
	Enddo
EndDo

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

Return()


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENI068B  �Autor  �Angelo Henrique     � Data �  14/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina respons�vel pela execu��o do execauto de clientes    ���
���          �e pedido de vendas                                          ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Rafael Leite - 29/01/2015. Inclusao do parametro _cCGC
//Rodrigo Mour�o - 01/02/2015. Inclusao do tipo e Pedido Web
Static Function GENI068B(_aClient,_aCabPd,_aItmPd,_cCodOld,_cPedOld,_cCGC,_cTipo,_cPedWeb,_cNome,_aParcItem,cOrigem,nIdPgt)

Local _aArea 			:= GetArea()
Local _cArqCli			:= GetNextAlias()
Local _cArqPd			:= GetNextAlias()
Local _cAliSC9 			:= GetNextAlias()
Local _cAliSC6 			:= GetNextAlias()
Local cQueryINS			:= ""
Local _cQuery			:= ""
Local _aAcabC5			:= {}
Local _aItmC6			:= {}

Local _aTmpPV1			:= {}
Local _aPVlNFs			:= {}
Local _cMvSeri 			:= Iif(lDigital,"3",GetMv("GEN_FAT003"))//GetMv("GEN_FAT003") //SERIE nota de sa�da
Local _cNotaImp			:= ""
Local _nPosLb			:= 0
//Local _cCGC := ""		//Rafael Leite - 29/01/2015. Variavel nao pode ser declarada em branco nesse ponto.
Local nPosProd			:= aScan(_aItmPd[1], {|x| AllTrim(x[1]) == "C6_PRODUTO" } )
Local _cParcela 		:= ""
Local cParc1			:= GetMv("MV_1DUP")
Local cSC5Aux			:= ""
Local _ni               := 0
Local nSC5              := 0

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.
Private _aErro			:= {}
Private _cErroLg		:= "" //Vari�vel onde � armazenado o log quer ser� impresso em um arquivo
//Private _cView	:= GETMV("MV_XVIEWPD")
Private _cLogPd	:= "\logsiga\ped diferimento\"//SUPERGETMV("MV_XCAMLOG",.T.,"\logsiga\ped venda\") //Par�metro que cont�m o caminho onde ser� gravado o arquivo de log de inconsist�ncias

//Default _cCGC := ""

_nPosLb	:= aScan(_aItmPd[1], { |x| Alltrim(x[1]) == "C6_QTDLIB" })
_nPosLj	:= aScan(_aClient, { |x| Alltrim(x[1]) == "A1_LOJA" })

//If _cCodOld != "0"
//�������������������������������������������������������������������������������������������������������Ŀ
//�S� ir� incluir os pedidos que n�o forem encontrados no protheus prevenindo assim algum problema na View�
//�Conforme solicitado ser� alimentado a FLAG VIEW dos pedidos
//���������������������������������������������������������������������������������������������������������
_cQuery := "SELECT C5_XPEDOLD
_cQuery += " FROM " + RetSqlName("SC5") + " SC5
_cQuery += " JOIN " + RetSqlName("SC6") + " SC6
_cQuery += " ON C6_FILIAL = C5_FILIAL
_cQuery += " AND C6_NUM = C5_NUM
_cQuery += " AND SC6.D_E_L_E_T_ <> '*'
_cQuery += " AND SC5.D_E_L_E_T_ <> '*'
_cQuery += " AND C5_XPEDOLD = '"  + _cPedOld + "'"
_cQuery += " AND C5_XRECORR = "+cValToChar(nIdPgt)

cInProd := "("
aEval(_aItmPd, {|x| cInProd+="'"+AllTrim(x[nPosProd][2])+"'," } )
cInProd	:= Left(cInProd,Len(cInProd)-1)
cInProd+=")"

_cQuery += " AND C6_PRODUTO IN "+cInProd

If Select(_cArqPd) > 0
	dbSelectArea(_cArqPd)
	(_cArqPd)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqPd, .F., .T.)

If ((_cArqPd)->(EOF()) .and. _lVwWeb)
	
	//Conout("GENI068 - Inicio do execauto de pedido de vendas e de clientes")
	nOpt := 3 //INCLUI
	nRec := 0
	
	DbSelectArea("SA1")
	If SubStr(_cCGC,1,8) <> '00000000' .and. !Empty(_cCGC)
		DbSetOrder(3)
		If (DbSeek(xFilial("SA1") + _cCGC))
			If !Empty(SA1->A1_CGC) .and. alltrim(_cCGC) == alltrim(SA1->A1_CGC)
				//_lImpCli := .F.
				nOpt := 4 //ATUALIZA
				nRec := Recno()
				If _aClient[1][1]<>"A1_COD"
					aAdd(_aClient,{"A1_COD"	,SA1->A1_COD,Nil})
					aAdd(_aClient,{"A1_LOJA",SA1->A1_LOJA,Nil})
				Endif
                //restaurar o posicionamento pois afeta a execauto Mata030
				SA1->(DbSetOrder(1))
				SA1->(DbGoTo(nRec))
									
			Endif
		EndIf 
	ElseIf !Empty(AllTrim(_cNome))
		//_cNome := upper(AllTrim((_cArqTmp)->A1_NOME)) removido pois neste ponto o registro da _cArqTmp n�o � o do cliente do pedido
		DbSetOrder(2) //FILIAL+NOME
		If (DbSeek(xFilial("SA1") + _cNome))
			If trim(SA1->A1_NOME) == _cNome
				nOpt := 4 //ATUALIZA
				nRec := Recno()
				If _aClient[1][1]<>"A1_COD"
					aAdd(_aClient,{"A1_COD"	,SA1->A1_COD,Nil})
					aAdd(_aClient,{"A1_LOJA",SA1->A1_LOJA,Nil})
				Endif
			Endif
		ElseIf !Empty(AllTrim(_cNome))
			//_cNome := upper(NoAcento(AllTrim((_cArqTmp)->A1_NOME)))
			If (DbSeek(xFilial("SA1") + upper(NoAcento(AllTrim(_cNome)))))
				If trim(SA1->A1_NOME) == _cNome
					nOpt := 4 //ATUALIZA
					nRec := Recno()
					If _aClient[1][1]<>"A1_COD"
						aAdd(_aClient,{"A1_COD"	,SA1->A1_COD,Nil})
						aAdd(_aClient,{"A1_LOJA",SA1->A1_LOJA,Nil})
					Endif
				Endif
			EndIf
		EndIf
	EndIf
	
	_nPosLj	:= aScan(_aClient, { |x| Alltrim(x[1]) == "A1_LOJA" })
	If _nPosLj = 0
		aAdd(_aClient,{"A1_LOJA","01",Nil})
	Endif
	
	//If _lImpCli
	//Conout("GENI068 - Execauto de Cliente" )
	lMsErroAuto := .F.
	IF nOpt == 3
		MSExecAuto({|x,y| Mata030(x,y)},_aClient,nOpt)
	ENDIF	
	
	//REMOVE ASPAS SIMPLES DO CADASTRO DE CLIENTE E FORNECEDOR
// 	Begin Transaction
// 		TcSqlexec("update "+RetSqlName("SA1")+" set A1_NOME = upper(replace(A1_NOME,'''',' ')), A1_NREDUZ = upper(replace(A1_NREDUZ,'''',' ')) where A1_COD = '"+SA1->A1_COD+"' AND A1_NOME like '%''%' or A1_NREDUZ like '%''%'")
// //		TcSqlexec("update "+RetSqlName("SA2")+" set A2_NOME = upper(replace(A2_NOME,'''',' ')), A2_NREDUZ = upper(replace(A2_NREDUZ,'''',' ')) where A2_NOME like '%''%' or A2_NREDUZ like '%''%'")
// 	End Transaction
	
	//������������������������������������������������������������������Ŀ
	//�Caso tenha entrado na rotina de execauto de cliente e n�o der erro�
	//�ir� prosseguir para a importa��o do pedido de vendas              �
	//��������������������������������������������������������������������
	If !lMsErroAuto
		
		If nOpt <> 3
			SA1->(dbGoTo(nRec))
		Endif
		
		nPosAux := aScan(_aCabPd, {|x| x[1] == "C5_CLIENTE" } )
		If nPosAux == 0
			aAdd ( _aCabPd , { "C5_CLIENTE"	, SA1->A1_COD	, NIL} )			
		Else
			_aCabPd[nPosAux][2] := SA1->A1_COD	
		EndIF
		
		nPosAux := aScan(_aCabPd, {|x| x[1] == "C5_LOJACLI" } )		
		If nPosAux == 0
			aAdd ( _aCabPd , { "C5_LOJACLI"	, SA1->A1_LOJA	, NIL} )
		Else
			_aCabPd[nPosAux][2] := SA1->A1_LOJA	
		EndIF
				
		nPosAux := aScan(_aCabPd, {|x| x[1] == "C5_CLIENT" } )		
		If nPosAux == 0
			aAdd ( _aCabPd , { "C5_CLIENT"	, SA1->A1_COD	, NIL} )
		Else
			_aCabPd[nPosAux][2] := SA1->A1_COD	
		EndIF
				 
		nPosAux := aScan(_aCabPd, {|x| x[1] == "C5_LOJAENT" } )		
		If nPosAux == 0
			aAdd ( _aCabPd , { "C5_LOJAENT"	, SA1->A1_LOJA	, NIL} )
		Else
			_aCabPd[nPosAux][2] := SA1->A1_LOJA
		EndIF
				
		nPosAux := aScan(_aCabPd, {|x| x[1] == "C5_TIPOCLI" } )		
		If nPosAux == 0
			aAdd ( _aCabPd , { "C5_TIPOCLI"	, SA1->A1_TIPO	, NIL} )
		Else
			_aCabPd[nPosAux][2] := SA1->A1_TIPO
		EndIF
				
		nPosAux := aScan(_aCabPd, {|x| x[1] == "C5_VEND1" } )		
		If nPosAux == 0
			aAdd ( _aCabPd , { "C5_VEND1"	, SA1->A1_VEND	, NIL} )
		Else
			_aCabPd[nPosAux][2] := SA1->A1_VEND
		EndIF
			
		//�������������������������������������������������������Ŀ
		//�Ordenando o vetor conforme estrutura da SX3, pois      �
		//�alguns execauto`s realizam valida;'oes de gatilhos     �
		//�o que pode acabar matando uma informa;'ao obrigat[oria �
		//�que ja havia sido enviada corretamente no array        �
		//���������������������������������������������������������
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SC5")
		//While !EOF() .And. (SX3->X3_ARQUIVO == "SC5")
		aSC5SX3 := FWSX3Util():GetAllFields( "SC5", .F. )
		For nSC5 := 1 To Len(aSC5SX3)
			For _ni := 1 To Len(_aCabPd)
				If AllTrim(aSC5SX3[nSC5]) == Alltrim(_aCabPd[_ni][1])
					aAdd(_aAcabC5,_aCabPd[_ni])
					Exit
				EndIf
			Next _ni
		//	dbSelectArea("SX3")
		Next nSC5
		//	dbSkip()
		//EndDo
		
		//Conout("GENI068 - Execauto de Pedido de Vendas")
		
		//������������������������������������������������Ŀ
		//�Inicio a grava��o (Execauto) do pedido de vendas�
		//��������������������������������������������������
		
		DbSelectArea("SC5")
		DbSelectArea("SC6")
		DbSelectArea("SB1")
		/*
		For nAuxSX := 1 To Len(_aAcabC5)
			
			If ValType(_aAcabC5[nAuxSX][2]) <> TamSX3(_aAcabC5[nAuxSX][1])[3]
				MsgStop("Erro campo "+_aAcabC5[nAuxSX][1])
			EndIF
			
		Next

		For nAuxSX := 1 To Len(_aItmPd)
			
			For nAuxBSX := 1 To Len(_aItmPd[nAuxSX])
				If ValType(_aItmPd[nAuxSX][nAuxBSX][2]) <> TamSX3(_aItmPd[nAuxSX][nAuxBSX][1])[3]
					MsgStop("Erro campo "+_aItmPd[nAuxSX][nAuxBSX][1])
				EndIF
			Next
		Next
        */
        cSC5Aux		:= SC5->C5_NUM
		lMsErroAuto := .F.
		_cPedExc := ""
		MSExecAuto({|x,y,z| mata410(x,y,z)},_aAcabC5,_aItmPd,3)
		_cPedExc := SC5->C5_NUM

		// If !lMsErroAuto .or. (AllTrim(SC5->C5_XPEDWEB) == AllTrim(_cPedWeb) .AND. AllTrim(SC5->C5_XPEDOLD) == AllTrim(_cPedOld) .AND. cSC5Aux <> SC5->C5_NUM )
		// 	_cParcela := ""
		// 	For _nI := 1 To Len(_aParcItem)			
		// 		_cParcela := If(_nI == 1,cParc1,Soma1(_cParcela))
																			
		// 		RecLock("SCV",.T.)
		// 		SCV->CV_FILIAL  := xFilial("SCV")
		// 		SCV->CV_PEDIDO  := SC5->C5_NUM
		// 		SCV->CV_FORMAPG := "CC"
		// 		SCV->CV_DESCFOR := Posicione("SX5",1,xFilial("SX5")+"24"+"CC","X5_DESCRI")
		// 		SCV->CV_XPEDOLD := SC5->C5_XPEDOLD
		// 		SCV->CV_XPARCEL := _cParcela
		// 		SCV->CV_XOPERA  := _aParcItem[_nI,3]
		// 		SCV->CV_XNSUTEF := _aParcItem[_nI,4]					
		// 		SCV->CV_XBANDEI := UPPER(_aParcItem[_nI,5])
		// 		MsUnLock()					
		// 	Next		
		// EndIf
		
		If !lMsErroAuto .and. lGeraNF
			
			_cAlias1 := GetNextAlias()
			//Verifica se tem TES diferente no pedido
			_cQuery := "SELECT F4_XTESPAI "						

			_cQuery += " FROM " + RetSqlName("SC6") +" SC6 "
			_cQuery += " JOIN " + RetSqlName("SF4") +" SF4 "
			_cQuery += " ON F4_FILIAL = ' ' "
			_cQuery += " AND SF4.F4_CODIGO = C6_TES "
			_cQuery += " AND SF4.D_E_L_E_T_ <> '*' "
			
			_cQuery += " WHERE C6_FILIAL = '" + xFilial("SC6") + "'"
			_cQuery += " AND C6_NUM = '" + SC5->C5_NUM + "'"
			_cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
			
			_cQuery += " GROUP BY F4_XTESPAI "
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias1,.T.,.T.)
			
			_nTotItem := 0
			While !(_cAlias1)->(EOF())
				_nTotItem++
				(_cAlias1)->(DbSkip())
			End
			
			//Verifica quantidade de itens
			If _nTotItem == 1
				
				//�����������������������������������������������������������������������������X�
				//�Rotina para desbloquear cr�dito para que o pedido seja faturado sem problemas�
				//�����������������������������������������������������������������������������X�
				//Posiciona na SC9 para confirmar que o pedido foi gravado na tabela
				DbSelectArea("SC9")
				DbSetOrder(1)
				If DbSeek(xFilial("SC9") + SC5->C5_NUM)
					
					//Verifica se o pedido ficou bloqueado
					_cQuery := "SELECT C9_FILIAL, C9_PEDIDO, C9_BLCRED,
					_cQuery += " R_E_C_N_O_ SC9RECNO
					_cQuery += " FROM "+RetSqlName("SC9")+" SC9
					_cQuery += " WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"'
					_cQuery += " AND SC9.C9_PEDIDO = '"+SC5->C5_NUM+"'
					_cQuery += " AND (SC9.C9_BLEST NOT IN('  ','10')
					_cQuery += " OR SC9.C9_BLCRED NOT IN('  ','09','10') )
					_cQuery += " AND SC9.D_E_L_E_T_ = ' '
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliSC9,.T.,.T.)
					
					//Percorre todos itens bloqueados no pedido
					While !(_cAliSC9)->(Eof())
						
						//Posiciona a SC9
						SC9->(DbGoTo((_cAliSC9)->SC9RECNO))
						IF 	SC9->(Recno()) == (_cAliSC9)->SC9RECNO
							
							//������������������������������������������������������������������������������
							//���          �Rotina de atualizacao da liberacao de credito                ���
							//��������������������������������������������������������������������������Ĵ��
							//���Parametros�ExpN1: 1 - Liberacao                                         ���
							//���          �       2 - Rejeicao                                          ���
							//���          �ExpL2: Indica uma Liberacao de Credito                       ���
							//���          �ExpL3: Indica uma liberacao de Estoque                       ���
							//���          �ExpL4: Indica se exibira o help da liberacao                 ���
							//���          �ExpA5: Saldo dos lotes a liberar                             ���
							//���          �ExpA6: Forca analise da liberacao de estoque                 ���
							//��������������������������������������������������������������������������Ĵ��
							//���Descri��o �Esta rotina realiza a atualizacao da liberacao de pedido de  ���
							//���          �venda com base na tabela SC9.                                ���
							//������������������������������������������������������������������������������
							
							//a450Grava(1,.T.,.F.,.F.) //ALTERADO POR DANILO AZEVEDO 24/04/15 PARA LIBERAR TAMBEM ESTOQUE
							a450Grava(1,.T.,.T.,.F.)
						Else
							_cErroLg := "Recno nao encontrado na SC9. Verifique se o pedido foi corretamente faturado. Recno SC9: " + cvaltochar((_cAliSC9)->SC9RECNO)
							MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif((_cArqTmp)->DIGITAL=1,"DIG_","IMP_")+ ".txt" , _cErroLg )
						EndIf
						(_cAliSC9)->(DbSkip())
					EndDo
				Else
					_cErroLg := "Pedido n�o localizado na SC9. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC5->C5_NUM
					MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif((_cArqTmp)->DIGITAL=1,"DIG_","IMP_")+ ".txt" , _cErroLg )
				EndIf
				
				/*-------------------------------------------------------
				INCLUS�O DE ROTINA PARA GERA��O  DE NOTA NO FATURAMENTO
				---------------------------------------------------------*/
				
				*'-----------------------------------------------------------------------------------------------------'*
				*'Inicio - Caso tenha ocorrido com sucesso a gera��o do Pedido de Vendas, ir� iniciar a gera��o da Nota'*
				*'-----------------------------------------------------------------------------------------------------'*
				
				//Posiciona a SC9
				DbSelectArea("SC9")
				DbSetOrder(1)
				If DbSeek(xFilial("SC9")+SC5->C5_NUM)
					
					_cCliente 	:= SC5->C5_CLIENTE
					_cLoja		:= SC5->C5_LOJACLI
					
					//Percorre todos os itens da SC9
					While !SC9->(EOF()) ;
						.and. SC9->C9_FILIAL == xFilial("SC9");
						.And. SC9->C9_PEDIDO == SC5->C5_NUM
						
						//Verifica se item n�o est� bloqueado
						If (SC9->C9_BLEST == '  ' .OR. SC9->C9_BLEST == '10');
							.AND. (SC9->C9_BLCRED == '  ' .OR. SC9->C9_BLCRED == '10' .OR. SC9->C9_BLCRED == '09')
							
							//Posiciona no item do pedido SC6
							DbSelectArea("SC6")
							DbSetOrder(1)
							If DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM)
								
								//Adiciona informa��es para faturamento
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
								//aAdd( _aTmpPV1, SE4->(RECNO(POSICIONE("SE4",1,xFilial("SE4")+"001"				,""))))
								aAdd( _aTmpPV1, SE4->(RECNO(POSICIONE("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG	,""))))
								aAdd( _aTmpPV1, SB1->(RECNO(POSICIONE("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO	,""))))
								aAdd( _aTmpPV1, SB2->(RECNO(POSICIONE("SB2",1,xFilial("SB2")+SC9->C9_PRODUTO	,""))))
								aAdd( _aTmpPV1, SF4->(RECNO(POSICIONE("SF4",1,xFilial("SF4")+SC6->C6_TES		,""))))
								aAdd( _aTmpPV1, SC9->C9_LOCAL	)
								aAdd( _aTmpPV1, 1				)
								aAdd( _aTmpPV1, SC9->C9_QTDLIB2	)
								
								aAdd( _aPVlNFs, aClone(_aTmpPV1))
								
								DbSelectArea("SC9")
								DbSkip()
							Else
								_cErroLg := "Item de pedido n�o localizado na SC6. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC9->C9_PEDIDO + " Item: " + SC9->C9_ITEM
								MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif((_cArqTmp)->DIGITAL=1,"DIG_","IMP_")+ ".txt" , _cErroLg )
								SC9->(DBSKIP())
							Endif
						Else
							_cErroLg := "Pedido com itens SC9 n�o liberado. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC9->C9_PEDIDO + " Item: " + SC9->C9_ITEM
							MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif((_cArqTmp)->DIGITAL=1,"DIG_","IMP_")+ ".txt" , _cErroLg )
							SC9->(DBSKIP())
						Endif
					EndDo
					
					//CONOUT("GENA006 - REALIZANDO A GERACAO DA NOTA ")
					
					*'------------------------------------------------'*
					*'Rotina utilizada para realizar a gera��o da Nota'*
					*'------------------------------------------------'*
					If Empty(_cErroLg) .and. _lVwWeb
						_cNotaImp := MaPVlNFs(_aPVlNFs,_cMvSeri,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)
						
						_aPVlNFs := {}
						
						//CHECK DE ERRO NO PEDIDO
						_cQry := "SELECT C6_PRODUTO, C6_QTDVEN, C6_QTDENT
						_cQry += " FROM "+RetSqlName("SC6")+" SC6
						_cQry += " WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"'
						_cQry += " AND SC6.C6_NOTA = '"+_cNotaImp+"'
						_cQry += " AND SC6.C6_SERIE = '"+_cMvSeri+"'
						_cQry += " AND SC6.D_E_L_E_T_ = ' '
						_cQry += " AND SC6.C6_QTDVEN <> SC6.C6_QTDENT
						_cQry += " UNION ALL
						_cQry += " SELECT C6_PRODUTO, C6_QTDVEN, D2_QUANT
						_cQry += " FROM "+RetSqlName("SC6")+" SC6
						_cQry += " ,"+RetSqlName("SD2")+" SD2
						_cQry += " WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"'
						_cQry += " AND SC6.C6_NOTA = '"+_cNotaImp+"'
						_cQry += " AND SC6.C6_SERIE = '"+_cMvSeri+"'
						_cQry += " AND SC6.D_E_L_E_T_ = ' '
						_cQry += " AND SD2.D2_FILIAL = '"+xFilial("SD2")+"'
						_cQry += " AND SD2.D2_DOC = SC6.C6_NOTA
						_cQry += " AND SD2.D2_SERIE = SC6.C6_SERIE
						_cQry += " AND SC6.C6_ITEM = SD2.D2_ITEMPV
						_cQry += " AND SD2.D_E_L_E_T_ = ' '
						_cQry += " AND SC6.C6_QTDVEN <> SD2.D2_QUANT
						_cQry += " UNION ALL
						_cQry += " SELECT SC6.C6_PRODUTO, SUM(SC6.C6_QTDVEN) Q1, SUM(SD2.D2_QUANT) Q2
						_cQry += " FROM "+RetSqlName("SC6")+" SC6
						_cQry += " ,"+RetSqlName("SD2")+" SD2
						_cQry += " WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"'
						_cQry += " AND SC6.C6_NOTA = '"+_cNotaImp+"'
						_cQry += " AND SC6.C6_SERIE = '"+_cMvSeri+"'
						_cQry += " AND SC6.D_E_L_E_T_ = ' '
						_cQry += " AND SD2.D2_FILIAL = '"+xFilial("SD2")+"'
						_cQry += " AND SD2.D2_DOC = SC6.C6_NOTA
						_cQry += " AND SD2.D2_SERIE = SC6.C6_SERIE
						_cQry += " AND SC6.C6_ITEM = SD2.D2_ITEMPV
						_cQry += " AND SD2.D_E_L_E_T_ = ' '
						_cQry += " GROUP BY C6_PRODUTO
						_cQry += " HAVING SUM(SC6.C6_QTDVEN) <> SUM(SD2.D2_QUANT)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliSC6,.T.,.T.)
						
						If ! (_cAliSC6)->(Eof())
							
							_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. Ser� feita tentativa de exclus�o."
							conout("GENI068 - "+_cErroLg)
							U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br")+";helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Importa��o WEB"),oemtoansi(_cErroLg),,,.F.)
							
							aRegSD2	:= {}
							aRegSE1 := {}
							aRegSE2 := {}
							
							//�������������������������������������������������������
							//�Posiciona no documento fiscal de sa�da a ser exclu�do�
							//�������������������������������������������������������
							DbSelectArea("SF2")
							DbSetOrder(1)
							If SF2->(DbSeek(xFilial("SF2") + _cNotaImp + padr(_cMvSeri,TamSx3("F2_SERIE")[1]) + _cCliente + _cLoja))
								//������������������������������������������������������������������
								//�Executa rotinas responsaveis pela exclus�o do documento de sa�da�
								//������������������������������������������������������������������
								If MaCanDelF2("SF2", SF2->(RECNO()) , @aRegSD2, @aRegSE1, @aRegSE2)
									SF2->(MaDelNFS(aRegSD2, aRegSE1, aRegSE2))
									_cNotaImp := ""
								Else
									_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. N�o foi poss�vel realizar a exclus�o. Efetue o procedimento manualmente assim que poss�vel."
									conout("GENI068 - "+_cErroLg)
									U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br")+";helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Importa��o WEB"),oemtoansi(_cErroLg),,,.F.)
								EndIf
								_cNotaImp := ""
							Else
								_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. N�o foi poss�vel encontrar o registro na SF2 para exclus�o. Efetue o procedimento manualmente assim que poss�vel."
								conout("GENI068 - "+_cErroLg)
								U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br")+";helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Importa��o WEB"),oemtoansi(_cErroLg),,,.F.)
							EndIf
						EndIf
					EndIf
				EndIf
				
				/*-------------------------------------------------------
				FIM DA ROTINA PARA GERA��O  DE NOTA NO FATURAMENTO
				---------------------------------------------------------*/
			Else
				cMsg := "GENI068 - IMPORTA��O SERVI�O WEB" + cEnt
				cMsg += cEnt
				cMsg += "O Pedido " + SC5->C5_NUM + " com TES PAI diferentes e n�o vai gerar documento de sa�da." + cEnt
				U_GenSendMail(,,,"noreply@grupogen.com.br","beatriz.reis@grupogen.com.br;rafael.leite@grupogen.com.br;helimar@grupogen.com.br",oemtoansi("Protheus Faturamento - Importa��o Servi�o Web"),cMsg,,,.F.)
			EndIf
			
		EndIf
		//������������������������������������������������Ŀ
		//�Fim   da grava��o (Execauto) do pedido de vendas�
		//��������������������������������������������������
	EndIf
	
	//�����������������������������������Ŀ
	//�Caso tenha dado erro ir� gerar log �
	//�������������������������������������
	If lMsErroAuto
		_aErro := GetAutoGRLog()
		For _ni := 1 To Len(_aErro)
			_cErroLg += _aErro[_ni] + Chr(13)+Chr(10)
		Next _ni
		
 		MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) +"_"+Iif((_cArqTmp)->DIGITAL=1,"DIG_","IMP_")+ ".txt" , _cErroLg )
		Disarmtransaction()
	EndIf
EndIf
//EndIf

If Select(_cArqPd) > 0
	dbSelectArea(_cArqPd)
	(_cArqPd)->(dbCloseArea())
EndIf

Return() 
