#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#DEFINE cEnt Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI018   ºAutor  ³Angelo Henrique     º Data ³  30/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina utilizada para gerar a gravação dos pedidos de vendasº±±
±±º          ³Integração Pedido de Vendas - Protheus x Oracle(Legado)     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENI018()

Local _aArea := GetArea()
Private lDigital := .F.

Conout("GENI018 - Inicio da importação de pedido de vendas")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verificação para saber se a rotina esta sendo chamada pela Schedule³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Prepare Environment Empresa "00" Filial "1022"

lExec := &(GetMv("GENI018EX"))
cExec := GetMv("GENI018DT")
lDiaAnt := substr(cExec,1,8) < DTOS(dDatabase)
lHoraAnt := val(strtran(elaptime(substr(cExec,10,8),time()),":","")) > 10000 //mais de 1 hora

If !lExec .or. (lExec .and. (lDiaAnt .or. lHoraAnt))
	If upper(alltrim(GetEnvServer())) $ "SCHEDULE-PRE" //EXECUTA SOMENTE NO AMBIENTE SCHEDULE
		PutMv("GENI018EX",".T.")
		PutMv("GENI018DT",DTOS(dDatabase)+" "+time())
		GENI018A()
		PutMv("GENI018EX",".F.")
	Endif
Endif
Reset Environment

RestArea(_aArea)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI018A  ºAutor  ³Angelo Henrique     º Data ³  11/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para o processamento da integração do pedido de vendaº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GENI018A()

Local _aArea 		:= GetArea()
Local _aClient		:= {} //Vetor para alimentar informações do cliente caso o mesmo não esteja cadastrado
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
Local _cQryIns		:= ""
Local _cLocB1		:= ""
Local _nQtdTot 		:= 0
Local _nValTot 		:= 0
Local _cMsg			:= ""
Local _cTransp		:= ""
Local _aDir			:= {}
Local _cCont 		:= "01"

Private _cQuery		:= ""
Private _cArqTmp	:= GetNextAlias()
Private _oServer	:= Nil
Private _cFilCont	:= ""
Private _cView		:= "" //Parâmetro que contém o nome da view que será consultada para a criação do Pedido de Vendas
Private _cLogPd		:= "" //Parâmetro que contém o caminho onde será gravado o arquivo de log de inconsistências
Private _aCabPd 	:= {}
Private _aItmPd 	:= {}
Private _alinha		:= {}

_cView	:= SUPERGETMV("MV_XVIEWPD",.T.,"TT_I29_PEDIDOS_SATELITES") //Parâmetro que contém o nome da view que será consultada para a criação do Pedido de Vendas
_lVwWeb := alltrim(_cView) = "TT_I29_PEDIDOS_SATELITES"
//_cView	:= "DBA_EGK.TT_I29A_PEDIDOS_PDP" //PASTA DO PROFESSOR
//_cView	:= "DBA_EGK.TT_I29_PEDIDOS_ROUBADOS_ECT" //Parâmetro que contém o nome da view que será consultada para a criação do Pedido de Vendas
_cLogPd	:= SUPERGETMV("MV_XCAMLOG",.T.,"\logsiga\ped venda\") //Parâmetro que contém o caminho onde será gravado o arquivo de log de inconsistências

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executar limpeza dos logs³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aDir:=directory(Alltrim(_cLogPd)+"*")

For _ni:= 1 to Len(_aDir)
	fErase(Alltrim(_cLogPd)+_aDir[_ni][1])
Next _ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Conforme levantado será criado uma view disponibilizada no protheus ³
//³que irá conter todos os pedidos que deverão ser importados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//_cQuery := " SELECT * FROM TT_I29A_PEDIDOS_SATELITES" //+ _cView
_cQuery := " SELECT * FROM "+_cView

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqTmp, .F., .T.)

_nCtVi := 0
While (_cArqTmp)->(!EOF())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validação da Trasnportadora, para não realizar o processamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (_cArqTmp)->DIGITAL <> 1
		_cTipo   := IIF(ValType((_cArqTmp)->TIPO) == "N",alltrim(str((_cArqTmp)->TIPO)),(_cArqTmp)->TIPO)
		_cPedWeb := IIF(ValType((_cArqTmp)->C5_XPEDWEB) == "N",alltrim(str((_cArqTmp)->C5_XPEDWEB)),(_cArqTmp)->C5_XPEDWEB)
		_cPedOld := IIF(ValType((_cArqTmp)->C5_XPEDOLD) == "N",alltrim(str((_cArqTmp)->C5_XPEDOLD)),(_cArqTmp)->C5_XPEDOLD)
		If !Empty((_cArqTmp)->C5_TRANSP)
			DbSelectArea("SA4")
			DbSetOrder(1)
			If DbSeek(xFilial("SA4")+STRZERO((_cArqTmp)->C5_TRANSP,6))
				If fieldpos("A4_MSBLQL") > 0 .and. SA4->A4_MSBLQL = "1"
					_cMsg := "Transportadora: " + STRZERO((_cArqTmp)->C5_TRANSP,6) + " encontra-se bloqueado, favor verificar."
				ElseIf AllTrim((_cArqTmp)->C5_TPFRETE) == "C" //CIF
					If Empty(SA4->A4_XFORNEC)
						_cMsg := "Transportadora: " + STRZERO((_cArqTmp)->C5_TRANSP,6) + " não possui fornecedor cadastrado, favor verificar." + Chr(13)+Chr(10)
						_cMsg += "O tipo do frete é CIF, por isso existe a necessidade de cadastrar o fornecedor."
					EndIf
				EndIf
			Else
				_cMsg := "Transportadora: " + STRZERO((_cArqTmp)->C5_TRANSP,6) + " não cadastrada no sistema, favor verificar."
			EndIf
		ElseIf Empty((_cArqTmp)->C5_TRANSP) .And. AllTrim((_cArqTmp)->C5_TPFRETE) == "C"
			_cMsg := "Transportadora em branco, favor cadastrar pois o tipo de frete é CIF, logo, torna-se obrigatório o seu cadastro."
		EndIf
	Endif
	If Empty(_cMsg)
		_cCod 		:= ""
		_aClient 	:= {}
		_cCodOld 	:= ""
		
		//-----------------------------------------//
		//Gravando em variável a nova filial logada//
		//-----------------------------------------//
		_cFilCont := AllTrim((_cArqTmp)->C5_FILIAL)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Processo de montagem do array para o execauto de cliente												   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//Conout("GENI018 - Montagem do Vetor de Clientes")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ajustes de alguns dados para a inclusão correta³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		_cCdMun := SUBSTR(cValToChar((_cArqTmp)->A1_COD_MUN),3,5)
		_cCdMun := IIF(Alltrim((_cArqTmp)->A1_EST) == 'EX','99999'		,_cCdMun						)
		_cCep	:= IIF(Alltrim((_cArqTmp)->A1_EST) == 'EX'  ,'00000000'	,Alltrim((_cArqTmp)->A1_CEP)	)
		_cMunic	:= IIF(Alltrim((_cArqTmp)->A1_EST) == 'EX'  ,'EXTERIOR'	,NoAcento((_cArqTmp)->A1_MUN)	)
		_cRPIS	:= IIF(Alltrim((_cArqTmp)->A1_RECPIS) == '' ,'N'		 	,Alltrim((_cArqTmp)->A1_RECPIS)	)
		_cRCSLL	:= IIF(Alltrim((_cArqTmp)->A1_RECCSLL)== '' ,'N'		 	,Alltrim((_cArqTmp)->A1_RECCSLL))
		_cRCOFI	:= IIF(Alltrim((_cArqTmp)->A1_RECCOFI)== '' ,'N'			,Alltrim((_cArqTmp)->A1_RECCOFI))
		_cRISS	:= IIF(Alltrim((_cArqTmp)->A1_RECISS) == '' ,'2'			,Alltrim((_cArqTmp)->A1_RECISS)	)
		_cRISS	:= IIF(Alltrim((_cArqTmp)->A1_RECISS) == 'N','2'			,Alltrim((_cArqTmp)->A1_RECISS)	)
		_cIncsr := IIF(!EMPTY(AllTrim((_cArqTmp)->A1_INSCR)),AllTrim((_cArqTmp)->A1_INSCR),"ISENTO")
		_cTpCli := STRZERO((_cArqTmp)->A1_XTIPCLI,3)
		_cMsblq := IIF((_cArqTmp)->A1_MSBLQL='A','2','1'				)
		_cCGC 	:= IIF((_cArqTmp)->A1_EST='EX'	,' ',(_cArqTmp)->A1_CGC	)
		_cCodPs := STRZERO((_cArqTmp)->A1_CODPAIS,TAMSX3("A1_CODPAIS")[1])
		_cEndNm := IIF(Empty((_cArqTmp)->A1_XENDNUM),"0",AllTrim((_cArqTmp)->A1_XENDNUM))
		_cVend	:= IIF(ValType((_cArqTmp)->A1_VEND)=="C" ,STRZERO(Val((_cArqTmp)->A1_VEND),TAMSX3("A1_VEND")[1]),STRZERO((_cArqTmp)->A1_VEND,TAMSX3("A1_VEND")[1]))
		_cTpDes	:= IIF(ValType((_cArqTmp)->A1_VEND)=="C" ,(_cArqTmp)->A1_XTPDES,cValToChar((_cArqTmp)->A1_XTPDES))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	VERIFICA SE JA EXISTE O CLIENTE COM MESMA RAIZ DE CNPJ CADASTRADO  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		//VALIDA SE O CNPJ NAO ESTA PREENCHIDO COM '0' (ZERO)
		If SUBSTR(_cCGC,1,8) <> '00000000' .AND. !Empty(_cCGC)
			//Conout("GENI018 - Entrou na validação de CNPJ preenchido com ZERO")
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
			If (_cArqAli)->(EOF())
				//Conout("GENI018 - Entrou na validação de adição de loja")
				DbSelectArea("SA1")
				DbSetOrder(3)
				If DbSeek(xFilial("SA1") + _cCGC )
					_cCod	:= (_cArqAli)->A1_COD
					_nLoja 	:= SOMA1((_cArqAli)->NLOJA)
					_cLoja	:= PADL(_nLoja,2,"0")
				EndIf
			EndIf
			If Select(_cArqAli) > 0
				dbSelectArea(_cArqAli)
				(_cArqAli)->(dbCloseArea())
			EndIf
		EndIf
		
		_cBairro	:= alltrim((_cArqTmp)->A1_BAIRRO)
		_cEst		:= AllTrim((_cArqTmp)->A1_EST)
		_cEstado	:= allTrim((_cArqTmp)->A1_ESTADO)
		_cEnd		:= NoAcento((_cArqTmp)->A1_END)	
		
		If !Empty(_cCep) .and. !(_cEst $ 'EX N/A')
			_cQry := "SELECT CL.DS_LOGRADOURO_NOME ENDER, CB.DS_BAIRRO_NOME BAIRRO, CD.DS_CIDADE_NOME CIDADE, CU.DS_UF_SIGLA UF, CU.DS_UF_NOME ESTADO, M.CODIBGE CODMUN
			_cQry += " FROM CEP_LOGRADOUROS CL
			_cQry += " JOIN CEP_BAIRROS CB ON CL.CD_BAIRRO = CB.CD_BAIRRO
			_cQry += " JOIN CEP_CIDADES CD ON CB.CD_CIDADE = CD.CD_CIDADE
			_cQry += " JOIN CEP_UF CU ON CD.CD_UF = CU.CD_UF
			_cQry += " JOIN DBA_EGK.MUNICIPIO M ON CD.DS_CIDADE_NOME = M.DESCRICAO
			_cQry += " JOIN DBA_EGK.UF ON UF.DESCRICAO = CU.DS_UF_SIGLA AND UF.IDUF = M.IDUF
			_cQry += " WHERE NO_LOGRADOURO_CEP = '"+_cCep+"'
			If Select(_cArqAli) > 0
				dbSelectArea(_cArqAli)
				(_cArqAli)->(dbCloseArea())
			EndIf
			DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQry), _cArqAli, .F., .T.)

			If !(_cArqAli)->(EOF())
				If Empty(_cBairro)
					_cBairro := alltrim((_cArqAli)->BAIRRO)
				Endif
				If Empty(_cEst) .or. Empty(_cEstado)
					_cEst := alltrim((_cArqAli)->UF)
					_cEstado := alltrim((_cArqAli)->ESTADO)
				Endif
				If Empty(_cEnd)
					_cEnd := alltrim((_cArqAli)->ENDER)
				Endif
				If Empty(_cCdMun)
					_cCdMun := SUBSTR(cValToChar((_cArqAli)->CODMUN),3,5)
				Endif
			Endif
		Endif
		
		If _lVwWeb
			_cTabela := GetMv("GEN_FAT064")
		Else
			_cTabela := Iif(!Empty((_cArqTmp)->C5_TABELA),(_cArqTmp)->C5_TABELA,GetMv("GEN_FAT064"))
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gravação das Informações no Array que será enviado para o Execauto³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_aClient := {}
		If !Empty(_cCod)
			//Conout("GENI018 - Colocando o código do cliente")
			aAdd(_aClient,{"A1_COD"	,	_cCod													,Nil})
			aAdd(_aClient,{"A1_LOJA",	_cLoja													,Nil})
		EndIf
		//Conout("GENI018 - Alimentando vetor Cliente")
		aAdd(_aClient,{"A1_XCODOLD"	,	cValtochar((_cArqTmp)->A1_XCODOLD)						,Nil})
		aAdd(_aClient,{"A1_NOME"	,	AllTrim(NoAcento((_cArqTmp)->A1_NOME))					,Nil})
		aAdd(_aClient,{"A1_PESSOA"	,	AllTrim(NoAcento((_cArqTmp)->A1_PESSOA))				,Nil})
		aAdd(_aClient,{"A1_NREDUZ"	,	AllTrim(NoAcento((_cArqTmp)->A1_NREDUZ))				,Nil})
		aAdd(_aClient,{"A1_CEP"		,	_cCep													,Nil})
		aAdd(_aClient,{"A1_END"		,	NoAcento((_cArqTmp)->A1_END)							,Nil})
		aAdd(_aClient,{"A1_XENDNUM"	,	_cEndNm													,Nil}) //Numero do endereco
		aAdd(_aClient,{"A1_COMPLEM"	,	NoAcento((_cArqTmp)->A1_COMPLEMEN)						,Nil})
		aAdd(_aClient,{"A1_BAIRRO"	,	NoAcento((_cArqTmp)->A1_BAIRRO)							,Nil})
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
		aAdd(_aClient,{"A1_ENDCOB"	,	AllTrim(NoAcento((_cArqTmp)->A1_ENDCOB))				,Nil})
		aAdd(_aClient,{"A1_CONTATO"	,	NoAcento((_cArqTmp)->A1_CONTATO)						,Nil})
		aAdd(_aClient,{"A1_ENDENT"	,	NoAcento((_cArqTmp)->A1_ENDENT)							,Nil})
		aAdd(_aClient,{"A1_INSCRM"	,	(_cArqTmp)->A1_INSCRM									,Nil})
		aAdd(_aClient,{"A1_INSCR"	,	_cIncsr													,Nil})
		aAdd(_aClient,{"A1_TPESSOA"	,	AllTrim((_cArqTmp)->A1_TPESSOA)							,Nil})
		aAdd(_aClient,{"A1_EMAIL"	,	AllTrim((_cArqTmp)->A1_EMAIL)							,Nil})
		aAdd(_aClient,{"A1_MSBLQL"	,	_cMsblq													,Nil})
		aAdd(_aClient,{"A1_CONTA"	,	AllTrim((_cArqTmp)->A1_CONTA)							,Nil})
		aAdd(_aClient,{"A1_RECPIS"	,	IIF(ValType(_cRPIS)=="C" ,_cRPIS,cValToChar(_cRPIS))	,Nil})
		aAdd(_aClient,{"A1_RECCSLL"	,	IIF(ValType(_cRCSLL)=="C",_cRCSLL,cValToChar(_cRCSLL))	,Nil})
		aAdd(_aClient,{"A1_RECCOFI"	,	IIF(ValType(_cRCOFI)=="C",_cRCOFI,cValToChar(_cRCOFI))	,Nil})
		aAdd(_aClient,{"A1_RECISS"	,	IIF(ValType(_cRISS)=="C" ,_cRISS,cValToChar(_cRISS))	,Nil})
		aAdd(_aClient,{"A1_XCLIPRE"	,	cValToChar((_cArqTmp)->A1_XCLIPRE)						,Nil}) //Cliente Premium
		aAdd(_aClient,{"A1_XTIPCLI"	,	_cTpCli													,Nil}) //Tipo de Cliente (GEN)
		aAdd(_aClient,{"A1_XCANALV"	,	(_cArqTmp)->A1_XCANALV									,Nil}) //Canal de Venda
		aAdd(_aClient,{"A1_VEND"	,	_cVend													,Nil})
		aAdd(_aClient,{"A1_XTPDES"	,	_cTpDes													,Nil}) //Tipo desconto
		aAdd(_aClient,{"A1_TRANSP"	,	STRZERO((_cArqTmp)->A1_TRANSP,6)						,Nil})
		aAdd(_aClient,{"A1_XCONDPG"	,	STRZERO((_cArqTmp)->A1_XCONDPG,TAMSX3("A1_XCONDPG")[1])	,Nil}) //Condicao Pagto (GEN)
		aAdd(_aClient,{"A1_COND"	,	GetMv("GEN_FAT065")	,Nil})
		aAdd(_aClient,{"A1_TABELA"	,	_cTabela			,Nil})
		aAdd(_aClient,{"A1_LC"		,	(_cArqTmp)->A1_LC										,Nil}) //Limite de Crédito
		aAdd(_aClient,{"A1_RISCO"	,	GetMv("GEN_FAT066")										,Nil}) //Limite de Crédito
		
		_aCabPd  := {}
		_cPedOld := IIF(ValType((_cArqTmp)->C5_XPEDOLD) == "N",alltrim(str((_cArqTmp)->C5_XPEDOLD)),(_cArqTmp)->C5_XPEDOLD)
		_cCodOld := IIF(ValType((_cArqTmp)->A1_XCODOLD) == "N",alltrim(str((_cArqTmp)->A1_XCODOLD)),(_cArqTmp)->A1_XCODOLD)
		_cCodOld := PADR(_cCodOld,TAMSX3("A1_XCODOLD")[1]," ")
		
		//Rodrigo Mourão - 01/02/2015. Criadas variaveis Tipo e Pedido Web para incluir no nome do arquivo de log.
		_cTipo   := IIF(ValType((_cArqTmp)->TIPO) == "N",alltrim(str((_cArqTmp)->TIPO)),(_cArqTmp)->TIPO)
		_cPedWeb := IIF(ValType((_cArqTmp)->C5_XPEDWEB) == "N",alltrim(str((_cArqTmp)->C5_XPEDWEB)),(_cArqTmp)->C5_XPEDWEB)
		_cFilLog := Alltrim((_cArqTmp)->C5_FILIAL)
		
		If (_cArqTmp)->DIGITAL <> 1
			_cTransp := IIF(ValType((_cArqTmp)->C5_TRANSP) == "N", (_cArqTmp)->C5_TRANSP, Val((_cArqTmp)->C5_TRANSP))
			_cTransp := IIF(_cTransp == 0, " ", STRZERO((_cArqTmp)->C5_TRANSP,TAMSX3("C5_TRANSP")[1]) )
			lDigital := .F.
		Else
			_cTransp := Space(TamSx3("C5_TRANSP")[1])
			lDigital := .T.
		Endif
		
		aAdd ( _aCabPd , { "C5_TIPO"    , "N"       					   			, NIL} )
		aAdd ( _aCabPd , { "C5_CONDPAG" , (_cArqTmp)->C5_CONDPAG   					, NIL} )
		aAdd ( _aCabPd , { "C5_EMISSAO" , STOD((_cArqTmp)->C5_EMISSAO)	   			, NIL} )
		aAdd ( _aCabPd , { "C5_XPEDOLD" , _cPedOld 									, NIL} )
		aAdd ( _aCabPd , { "C5_TPFRETE" , (_cArqTmp)->C5_TPFRETE 					, NIL} )
		aAdd ( _aCabPd , { "C5_FRETE" 	, (_cArqTmp)->C5_FRETE 						, NIL} )
		aAdd ( _aCabPd , { "C5_MOEDA" 	, (_cArqTmp)->C5_MOEDA 						, NIL} )
		aAdd ( _aCabPd , { "C5_PESOL" 	, (_cArqTmp)->C5_PSOL 						, NIL} )
		aAdd ( _aCabPd , { "C5_PBRUTO" 	, (_cArqTmp)->C5_PBRUTO 					, NIL} )
		aAdd ( _aCabPd , { "C5_TIPLIB" 	, (_cArqTmp)->C5_TPLIB						, NIL} )
		aAdd ( _aCabPd , { "C5_XTPREMS" , (_cArqTmp)->C5_XTPREMS					, NIL} )
		aAdd ( _aCabPd , { "C5_TABELA"  , _cTabela									, NIL} )
		aAdd ( _aCabPd , { "C5_XPEDWEB"  , alltrim(str((_cArqTmp)->C5_XPEDWEB))	, NIL} )
		
		//If !Empty(_cTransp)
		aAdd ( _aCabPd , { "C5_TRANSP"  , _cTransp									, NIL} )
		//EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Alimentando informações pertinente ao produto³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		_nItemC6 := 1
		_aItmPd := {}
		
		//Conout("GENI018 - Montagem do Vetor de Pedido de Vendas - Item")
		
		_cCont 		:= "01"
		While (_cArqTmp)->(!EOF()) .And. _cPedOld == AllTrim(str((_cArqTmp)->C5_XPEDOLD)) .and. _cCont <= "99"
			_alinha  := {}
			//Conout("GENI018 - Entrou no While do item pedido de vendas ")
			_cDescPd := Posicione("SB1",1,xFilial("SB1") + (_cArqTmp)->C6_PRODUTO,"B1_DESC")
			_cLocB1  := IIF(Empty(AllTrim((_cArqTmp)->C6_LOCAL)),Posicione("SB1",1,xFilial("SB1") + (_cArqTmp)->C6_PRODUTO,"B1_LOCPAD"),(_cArqTmp)->C6_LOCAL)
			
			If !_lVwWeb
				tcsqlexec("UPDATE "+RetSqlName("DA1")+" SET DA1_PRCVEN = "+alltrim(str((_cArqTmp)->C6_PRCVEN))+", DA1_DATVIG = ' ' WHERE DA1_CODTAB = '"+_cTabela+"' AND DA1_CODPRO = '"+padr(alltrim((_cArqTmp)->C6_PRODUTO),tamsx3("C6_PRODUTO")[1])+"' AND D_E_L_E_T_ = ' '")
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄá
			//³Alimentando os Itens do pedido³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄá
			
			//aAdd ( _alinha , { "C6_ITEM"    , STRZERO(_nItemC6,TAMSX3("C6_ITEM")[1]), NIL} )
			aAdd ( _alinha , { "C6_ITEM"    , _cCont								, NIL} )
			aAdd ( _alinha , { "C6_PRODUTO" , padr(alltrim((_cArqTmp)->C6_PRODUTO),tamsx3("C6_PRODUTO")[1])		, NIL} )
			aAdd ( _alinha , { "C6_DESCRI"  , _cDescPd  							, NIL} )
			aAdd ( _alinha , { "C6_QTDVEN"  , (_cArqTmp)->C6_QTDVEN   				, NIL} )
			aAdd ( _alinha , { "C6_QTDLIB"  , (_cArqTmp)->C6_QTDVEN   				, NIL} )
			aAdd ( _alinha , { "C6_PRCVEN"  , (_cArqTmp)->C6_PRCVEN    				, NIL} )
			aAdd ( _alinha , { "C6_VALOR"   , (_cArqTmp)->C6_VALOR    				, NIL} )
			aAdd ( _alinha , { "C6_TES"     , (_cArqTmp)->C6_TES      				, NIL} )
			aAdd ( _alinha , { "C6_LOCAL"   ,  _cLocB1   							, NIL} )
			aAdd ( _alinha , { "C6_DESCONT" , (_cArqTmp)->C6_DESCONT    			, NIL} )
			aAdd ( _alinha , { "C6_VALDESC" , (_cArqTmp)->C6_VALDESC    			, NIL} )
			aAdd ( _alinha , { "C6_ENTREG"  , STOD((_cArqTmp)->C6_ENTREG)			, NIL} )
			aAdd(_aItmPd , _alinha  )
			
			_nItemC6 ++
			_nQtdTot += (_cArqTmp)->C6_QTDVEN
			_nValTot += (_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN
			_cCont 	:= soma1(_cCont)
			(_cArqTmp)->(DbSkip())
			
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Alimentando o cabeçalho do Pedido de Vendas com as informações customizadas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd ( _aCabPd , { "C5_XQTDTOT"    , _nQtdTot      	, Nil} )
		aAdd ( _aCabPd , { "C5_XVALTOT"    , _nValTot      	, Nil} )
		
		//Zerando as Variáveis
		_nQtdTot := 0
		_nValTot := 0
		
		GENI018B(_aClient,_aCabPd,_aItmPd,_cCodOld,_cPedOld,_cCGC,_cTipo,_cPedWeb)
		_cCod := ""
	Else
		//Conout("Pedido: " + AllTrim(cValtochar((_cArqTmp)->C5_XPEDOLD)) + " " + _cMsg)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gravação do Log											³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//³Nome do arquivo: ped venda - EE_FFFF_NNNNNN.txt			³
		//³- Sendo:													³
		//³EE - empresa.											³
		//³FFFF - filial.											³
		//³NNNNNN - número do pedido.                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//MemoWrite ( _cLogPd + SM0->M0_CODIGO + Alltrim((_cArqTmp)->C5_FILIAL) + "_" + Alltrim((_cArqTmp)->TIPO) + "_" + AllTrim(cValtochar((_cArqTmp)->C5_XPEDWEB)) + ".txt" , _cMsg )
		MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + ".txt" , _cMsg )
		
		(_cArqTmp)->(DbSkip())
	EndIf
	
	//Nao eh necessario dar esse dbkip pois existem dois whiles tratando o alias
	//(_cArqTmp)->(DbSkip())
	
	_cMsg := Space(0)
EndDo

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI018B  ºAutor  ³Angelo Henrique     º Data ³  14/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsável pela execução do execauto de clientes    º±±
±±º          ³e pedido de vendas                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Rafael Leite - 29/01/2015. Inclusao do parametro _cCGC
//Rodrigo Mourão - 01/02/2015. Inclusao do tipo e Pedido Web
Static Function GENI018B(_aClient,_aCabPd,_aItmPd,_cCodOld,_cPedOld,_cCGC,_cTipo,_cPedWeb)

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
Local _cMvSeri 			:= Iif(lDigital,"2","0")//GetMv("GEN_FAT003") //SERIE nota de saída
Local _cNotaImp			:= ""
Local _nPosLb			:= 0
//Local _cCGC := ""		//Rafael Leite - 29/01/2015. Variavel nao pode ser declarada em branco nesse ponto.

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.
Private _aErro			:= {}
Private _cErroLg		:= "" //Variável onde é armazenado o log quer será impresso em um arquivo
Private _cView	:= GETMV("MV_XVIEWPD")
Private _cLogPd	:= SUPERGETMV("MV_XCAMLOG",.T.,"\logsiga\ped venda\") //Parâmetro que contém o caminho onde será gravado o arquivo de log de inconsistências

//Default _cCGC := ""

_nPosLb	:= aScan(_aItmPd[1], { |x| Alltrim(x[1]) == "C6_QTDLIB" })
_nPosLj	:= aScan(_aClient, { |x| Alltrim(x[1]) == "A1_LOJA" })

If _cCodOld != "0"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Só irá incluir os pedidos que não forem encontrados no protheus prevenindo assim algum problema na View³
	//³Conforme solicitado será alimentado a FLAG VIEW dos pedidos
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cQuery := "SELECT C5_XPEDOLD
	_cQuery += " FROM " + RetSqlName("SC5") + " SC5
	_cQuery += " WHERE D_E_L_E_T_ = ' '
	_cQuery += " AND C5_XPEDOLD = '"  + _cPedOld + "'"
	//_cQuery := ChangeQuery(_cQuery)
	
	If Select(_cArqPd) > 0
		dbSelectArea(_cArqPd)
		(_cArqPd)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqPd, .F., .T.)
	
	//Do while !(_cArqPd)->(EOF()) //FORCA A GRAVACAO DE PEDIDO MESMO QUE EXISTA
	//(_cArqPd)->(dbSkip())
	//Enddo
	
	If ((_cArqPd)->(EOF()) .and. _lVwWeb) .or. !_lVwWeb
		
		/*
		//Rafael Leite - 19/01/2015 - pesquisa o cliente pelo xcodlod e pelo CGC
		
		//Conout("GENI018 - Inicio do execauto de pedido de vendas e de clientes")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Conforme solicitado e levantado, antes da execução da importação deverá ser consultado o cliente, ³
		//³caso o mesmo não exista ele será criado via rotina automática                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SA1")
		//DbOrderNickName("A1_XCODOLD")
		DbSetOrder(9)
		If !(DbSeek(xFilial("SA1") + _cCodOld))
		//Conout("GENI018 - Execauto de Cliente")
		lMsErroAuto := .F.
		MSExecAuto({|x,y| Mata030(x,y)},_aClient,3)
		If !lMsErroAuto
		//Conout("GENI018B - Insert Cliente sem erro")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza a view de relacionamento da GEN, utilizada para controle interno³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQueryINS := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) "
		cQueryINS += " VALUES ('TT_I01_CLIENTE','A1_XCODOLD','"+_cCodOld+"','    ' ) "
		TCSqlExec(cQueryINS)
		EndIf
		EndIf
		*/
		
		//Rafael Leite - 19/01/2015 - pesquisa o cliente pelo xcodlod e pelo CGC
		//_lImpCli := .T.
		nOpt := 3 //INCLUI
		nRec := 0
		//Verifica se o cliente existe com xcodold
		DbSelectArea("SA1")
		DbOrderNickName("A1_XCODOLD")
		If (DbSeek(xFilial("SA1") + _cCodOld))
			//_lImpCli := .F.
			nOpt := 4 //ATUALIZA
			nRec := Recno()
			If _aClient[1][1]<>"A1_COD"
				aAdd(_aClient,{"A1_COD"	,SA1->A1_COD,Nil})
				aAdd(_aClient,{"A1_LOJA",SA1->A1_LOJA,Nil})
			Endif
		EndIf
		
		//Verifica se cliente existe com CGC. Esta validacao eh somente para nao existir CPF ou CNPJ duplicado.
		//Validacao feita somente se o cliente nao for encontrado. //Rafael Leite - 29/01/2015 includa validacao para pesquisar somente se nao encontrar o cliente pelo xcodold.
		//If _lImpCli .and. SubStr(_cCGC,1,8) <> '00000000' .and. !Empty(_cCGC)
		If 	nRec = 0 .and. SubStr(_cCGC,1,8) <> '00000000' .and. !Empty(_cCGC)
			DbSelectArea("SA1")
			DbSetOrder(3)
			If (DbSeek(xFilial("SA1") + _cCGC))
				If !Empty(SA1->A1_CGC) .and. _cCGC == SA1->A1_CGC
					//_lImpCli := .F.
					nOpt := 4 //ATUALIZA
					nRec := Recno()
					If _aClient[1][1]<>"A1_COD"
						aAdd(_aClient,{"A1_COD"	,SA1->A1_COD,Nil})
						aAdd(_aClient,{"A1_LOJA",SA1->A1_LOJA,Nil})
					Endif
				Endif
			EndIf
		EndIf
		
		_nPosLj	:= aScan(_aClient, { |x| Alltrim(x[1]) == "A1_LOJA" })
		If _nPosLj = 0
			aAdd(_aClient,{"A1_LOJA","01",Nil})
		Endif
		
		//If _lImpCli
		//Conout("GENI018 - Execauto de Cliente" )
		lMsErroAuto := .F.
		MSExecAuto({|x,y| Mata030(x,y)},_aClient,nOpt)
		
		//REMOVE ASPAS SIMPLES DO CADASTRO DE CLIENTE E FORNECEDOR
		tcsqlexec("update SA1000 set A1_NOME = replace(A1_NOME,'''',' '), A1_NREDUZ = replace(A1_NREDUZ,'''',' ') where A1_NOME like '%''%' or A1_NREDUZ like '%''%'")
		tcsqlexec("update SA2000 set A2_NOME = replace(A2_NOME,'''',' '), A2_NREDUZ = replace(A2_NREDUZ,'''',' ') where A2_NOME like '%''%' or A2_NREDUZ like '%''%'")
		
		If !lMsErroAuto
			If nOpt = 3 //INCLUSAO
				//Conout("GENI018B - Insert Cliente sem erro")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza a view de relacionamento da GEN, utilizada para controle interno³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cQueryINS := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) "
				cQueryINS += " VALUES ('TT_I01_CLIENTE','A1_XCODOLD','"+_cCodOld+"','    ' ) "
				TCSqlExec(cQueryINS)
			Else
				SA1->(dbGoTo(nRec))
			Endif
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso tenha entrado na rotina de execauto de cliente e não der erro³
		//³irá prosseguir para a importação do pedido de vendas              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lMsErroAuto
			
			aAdd ( _aCabPd , { "C5_CLIENTE" , SA1->A1_COD 					   	, NIL} )
			aAdd ( _aCabPd , { "C5_LOJACLI" , SA1->A1_LOJA 						, NIL} )
			aAdd ( _aCabPd , { "C5_CLIENT"  , SA1->A1_COD 						, NIL} )
			aAdd ( _aCabPd , { "C5_LOJAENT" , SA1->A1_LOJA 						, NIL} )
			aAdd ( _aCabPd , { "C5_TIPOCLI" , SA1->A1_TIPO				 		, NIL} )
			aAdd ( _aCabPd , { "C5_VEND1" 	, SA1->A1_VEND 						, NIL} )
			
			//aAdd ( _aCabPd , { "C5_MENNOTA" , "ENVIO GRATIS EM SUBSTITUICAO PEDIDO EXTRAVIADO NO CORREIO." , NIL} )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ordenando o vetor conforme estrutura da SX3, pois      ³
			//³alguns execauto`s realizam valida;'oes de gatilhos     ³
			//³o que pode acabar matando uma informa;'ao obrigat[oria ³
			//³que ja havia sido enviada corretamente no array        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SX3")
			dbSetOrder(1)
			MsSeek("SC5")
			While !EOF() .And. (SX3->X3_ARQUIVO == "SC5")
				For _ni := 1 To Len(_aCabPd)
					If AllTrim(SX3->X3_CAMPO) == Alltrim(_aCabPd[_ni][1])
						aAdd(_aAcabC5,_aCabPd[_ni])
						Exit
					EndIf
				Next _ni
				dbSelectArea("SX3")
				dbSkip()
			EndDo
			
			//Conout("GENI018 - Execauto de Pedido de Vendas")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Inicio a gravação (Execauto) do pedido de vendas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			DbSelectArea("SC5")
			DbSelectArea("SC6")
			DbSelectArea("SB1")
			
			lMsErroAuto := .F.
			_cPedExc := ""
			
			MSExecAuto({|x,y,z| mata410(x,y,z)},_aAcabC5,_aItmPd,3)
			
			_cPedExc := SC5->C5_NUM
			
			If !lMsErroAuto
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
				//³Rotina para desbloquear crédito para que o pedido seja faturado sem problemas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
				
				//Posiciona na SC9 para confirmar que o pedido foi gravado na tabela
				DbSelectArea("SC9")
				DbSetOrder(1)
				If DbSeek(xFilial("SC9") + SC5->C5_NUM)
					
					//Verifica se o pedido ficou bloqueado
					_cQuery := " SELECT C9_FILIAL "
					_cQuery += " ,C9_PEDIDO "
					_cQuery += " ,C9_BLCRED "
					_cQuery += " ,R_E_C_N_O_ SC9RECNO "
					_cQuery += " FROM "+RetSqlName("SC9")+" SC9 "
					_cQuery += " WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"' "
					_cQuery += " AND SC9.C9_PEDIDO = '"+SC5->C5_NUM+"' "
					_cQuery += " AND (SC9.C9_BLEST NOT IN('  ','10') "
					_cQuery += " OR SC9.C9_BLCRED NOT IN('  ','09','10') )"
					_cQuery += " AND SC9.D_E_L_E_T_ = ' ' "
					
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliSC9,.T.,.T.)
					
					//Percorre todos itens bloqueados no pedido
					While !(_cAliSC9)->(Eof())
						
						//Posiciona a SC9
						SC9->(DbGoTo((_cAliSC9)->SC9RECNO))
						IF 	SC9->(Recno()) == (_cAliSC9)->SC9RECNO
							
							//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
							//±±³          ³Rotina de atualizacao da liberacao de credito                ³±±
							//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							//±±³Parametros³ExpN1: 1 - Liberacao                                         ³±±
							//±±³          ³       2 - Rejeicao                                          ³±±
							//±±³          ³ExpL2: Indica uma Liberacao de Credito                       ³±±
							//±±³          ³ExpL3: Indica uma liberacao de Estoque                       ³±±
							//±±³          ³ExpL4: Indica se exibira o help da liberacao                 ³±±
							//±±³          ³ExpA5: Saldo dos lotes a liberar                             ³±±
							//±±³          ³ExpA6: Forca analise da liberacao de estoque                 ³±±
							//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							//±±³Descri‡„o ³Esta rotina realiza a atualizacao da liberacao de pedido de  ³±±
							//±±³          ³venda com base na tabela SC9.                                ³±±
							//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
							
							//a450Grava(1,.T.,.F.,.F.) //ALTERADO POR DANILO AZEVEDO 24/04/15 PARA LIBERAR TAMBEM ESTOQUE
							a450Grava(1,.T.,.T.,.F.)
						Else
							_cErroLg := "Recno nao encontrado na SC9. Verifique se o pedido foi corretamente faturado. Recno SC9: " + cvaltochar((_cAliSC9)->SC9RECNO)
							MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + ".txt" , _cErroLg )
						EndIf
						
						(_cAliSC9)->(DbSkip())
					EndDo

					//03/07/2015 - Rafael Leite - Fechar a area no final o while
					If Select(_cAliSC9) > 0
						(_cAliSC9)->(dbCloseArea())
					EndIf
				Else
					_cErroLg := "Pedido não localizado na SC9. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC5->C5_NUM
					MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + ".txt" , _cErroLg )
				EndIf
				
				/*-------------------------------------------------------
				
				INCLUSÃO DE ROTINA PARA GERAÇÃO  DE NOTA NO FATURAMENTO
				
				---------------------------------------------------------*/
				
				*'-----------------------------------------------------------------------------------------------------'*
				*'Inicio - Caso tenha ocorrido com sucesso a geração do Pedido de Vendas, irá iniciar a geração da Nota'*
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
						
						//Verifica se item não está bloqueado
						If (SC9->C9_BLEST == '  ' .OR. SC9->C9_BLEST == '10');
							.AND. (SC9->C9_BLCRED == '  ' .OR. SC9->C9_BLCRED == '10' .OR. SC9->C9_BLCRED == '09')
							
							//Posiciona no item do pedido SC6
							DbSelectArea("SC6")
							DbSetOrder(1)
							If DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM)
								
								//Adiciona informações para faturamento
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
								_cErroLg := "Item de pedido não localizado na SC6. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC9->C9_PEDIDO + " Item: " + SC9->C9_ITEM
								MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + ".txt" , _cErroLg )
								SC9->(DBSKIP())
							Endif
						Else
							_cErroLg := "Pedido com itens SC9 não liberado. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC9->C9_PEDIDO + " Item: " + SC9->C9_ITEM
							MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + ".txt" , _cErroLg )
							SC9->(DBSKIP())
						Endif
					EndDo
					
					//CONOUT("GENA006 - REALIZANDO A GERACAO DA NOTA ")
					
					*'------------------------------------------------'*
					*'Rotina utilizada para realizar a geração da Nota'*
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
							
							_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. Será feita tentativa de exclusão."
							conout("GENI018 - "+_cErroLg)
							AcSendMail(,,,"noreply@grupogen.com.br","danilo.azevedo@grupogen.com.br;helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Importação WEB"),oemtoansi(_cErroLg),,,.F.)
							
							aRegSD2	:= {}
							aRegSE1 := {}
							aRegSE2 := {}
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Posiciona no documento fiscal de saída a ser excluído³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							DbSelectArea("SF2")
							DbSetOrder(1)
							If SF2->(DbSeek(xFilial("SF2") + _cNotaImp + padr(_cMvSeri,TamSx3("F2_SERIE")[1]) + _cCliente + _cLoja))
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Executa rotinas responsaveis pela exclusão do documento de saída³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								If MaCanDelF2("SF2", SF2->(RECNO()) , @aRegSD2, @aRegSE1, @aRegSE2)
									SF2->(MaDelNFS(aRegSD2, aRegSE1, aRegSE2))
									_cNotaImp := ""
								Else
									
									_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. Não foi possível realizar a exclusão. Efetue o procedimento manualmente assim que possível."
									conout("GENI018 - "+_cErroLg)
									AcSendMail(,,,"noreply@grupogen.com.br","danilo.azevedo@grupogen.com.br;helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Importação WEB"),oemtoansi(_cErroLg),,,.F.)
									
								EndIf
								_cNotaImp := ""
							Else
								
								_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. Não foi possível encontrar o registro na SF2 para exclusão. Efetue o procedimento manualmente assim que possível."
								conout("GENI018 - "+_cErroLg)
								AcSendMail(,,,"noreply@grupogen.com.br","danilo.azevedo@grupogen.com.br;helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Importação WEB"),oemtoansi(_cErroLg),,,.F.)
								
							EndIf
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Caso a nota não seja gerado irá chamar a rotina de erro³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If Empty(AllTrim(_cNotaImp))
							
							//Conout("GENA006B - Geração do Documento de Saída apresentou erro.")
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Chamando o Execauto de Alteração e em seguida o de exclusão³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Alterando a quantidade liberada³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							For _ni := 1 To Len(_aItmPd)
								_aItmPd[_ni][_nPosLb][2] := 0
								aAdd(_aItmPd[_ni],{"C6_NUM", _cPedExc, Nil})
							Next _ni
							
							//CONOUT("GENA006B - Irá alterar o pedido de vendas para poder realizar a exclusão.")
							aAdd ( _aCabPd , { "C5_NUM"    , _cPedExc      	, Nil} )
							lMsErroAuto := .F.
							MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,4)
							
							If !lMsErroAuto
								//CONOUT("GENA006B - Alterou o pedido de vendas com suceeso, irá realizar a exclusão.")
								lMsErroAuto := .F.
								
								_cErroLg := ""
								
								MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,5)
								
								If !lMsErroAuto
									//CONOUT("GENA006B - Excluiu com sucesso o pedido de vendas.")
									_cErroLg += "  " + cEnt
									_cErroLg += " O Pedido: " + _cPedExc + " foi excluído com sucesso. "  + cEnt
									_cErroLg += " Favor verificar o pedido: "  + cEnt
									_cErroLg += " Pois ele teve que ser excluído uma vez que o Documento de Saída não foi gerado corretamente. " + cEnt
									_cErroLg += " Favor verificar a geração do Documento de Saída, pois no processo houve erro. " + cEnt
									_cErroLg += " " + cEnt
									//MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_"+ _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cErroLg )
									MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + ".txt" , _cErroLg )
								Else
									//Conout("GENA006B - Não conseguiu excluir o pedido de vendas.")
									_aErro := GetAutoGRLog()
									For _ni := 1 To Len(_aErro)
										_cErroLg += _aErro[_ni] + cEnt
									Next _ni
									_cErroLg += "  " + cEnt
									_cErroLg += " O Pedido: " + _cPedExc + " não pode ser excluído. "  + cEnt
									_cErroLg += " Favor verificar o pedido: "  + cEnt
									_cErroLg += " pois ele deve ser excluído uma vez que o Documento de Saída não foi gerado corretamente. " + cEnt
									_cErroLg += " Favor verificar a geração do Documento de Saída, pois no processo houve erro. " + cEnt
									_cErroLg += " " + cEnt
									//MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cErroLg )
									MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + ".txt" , _cErroLg )
								EndIF
							Else
								//CONOUT("GENA006B - Não conseguiu alterar o pedido de vendas.")
								_aErro := GetAutoGRLog()
								For _ni := 1 To Len(_aErro)
									_cErroLg += _aErro[_ni] + cEnt
								Next _ni
								_cErroLg += "  " + cEnt
								_cErroLg += " O Pedido: " + SC9->C9_PEDIDO + " não pode ser alterado para prosseguir com a exclusão. "  + cEnt
								_cErroLg += " Favor verificar o pedido: "  + cEnt
								_cErroLg += " pois ele deve ser excluído uma vez que o Documento de Saída não foi gerado corretamente. " + cEnt
								_cErroLg += " Favor verificar a geração do Documento de Saída, pois no processo houve erro. " + cEnt
								_cErroLg += " " + cEnt
								//MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cErroLg )
								MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL)+ "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + ".txt" , _cErroLg )
							EndIf
						EndIf
						
					EndIf
				EndIf
				
				/*-------------------------------------------------------
				
				FIM DA ROTINA PARA GERAÇÃO  DE NOTA NO FATURAMENTO
				
				---------------------------------------------------------*/
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Fim   da gravação (Execauto) do pedido de vendas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso tenha dado erro irá gerar log ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMsErroAuto
			_aErro := GetAutoGRLog()
			For _ni := 1 To Len(_aErro)
				_cErroLg += _aErro[_ni] + Chr(13)+Chr(10)
				//CONOUT(_cErroLg)
			Next _ni
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gravação do Log											³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//³Nome do arquivo: ped venda - EE_FFFF_NNNNNN.txt			³
			//³- Sendo:													³
			//³EE - empresa.											³
			//³FFFF - filial.											³
			//³NNNNNN - número do pedido.                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + ".txt" , _cErroLg )
			Disarmtransaction()
		EndIf
		//Else
		//Conout("GENI018 - Achou o pedido cadastrado no Protheus irá somente alimentar a View")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Incluindo na view da GEN a informação pertinente ao pedido para que a mesma possa ser excluida da view original de consulta³
		//³para que o pedido não tente ser gravado novamente, gerando log desnecessário  		                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//_cQryIns := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) "
		//_cQryIns := "INSERT INTO TT_T11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) "
		//_cQryIns += " VALUES ('" + _cView + "','C5_XPEDOLD','" + AllTrim(_cPedOld) + "','" + xFilial("SC5") + "' ) "
		//TCSqlExec(_cQryIns)
	EndIf
EndIf

If Select(_cArqPd) > 0
	dbSelectArea(_cArqPd)
	(_cArqPd)->(dbCloseArea())
EndIf

Return()
