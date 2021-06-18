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

Local _aArea	:= GetArea()
Local aTimeExec	:= {}
Local lExec		:= .T.

Private lDigital := .F.
Private lGeraNF := .T. //PARAMETRO PARA INDICAR SE DEVE GERAR A NOTA (.T.) OU SOMENTE O PEDIDO (.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verificação para saber se a rotina esta sendo chamada pela Schedule³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Prepare Environment Empresa "00" Filial "1022"

Conout("GENI018 - Inicio da importação de pedido de vendas."+DtoC(DDataBase)+" - "+Time())

aTimeExec	:= StrTokArr(GetMv("GEN_FAT242"),"#")


If !(Time() >= aTimeExec[1] .AND. Time() <= aTimeExec[2])
	Conout("GENI018 - fora do horario de operação. "+DtoC(DDataBase)+" - "+Time())
	lExec := .F.
EndIf

//lExec := &(GetMv("GENI018EX"))
//cExec := GetMv("GENI018DT")
//lDiaAnt := substr(cExec,1,8) < DTOS(dDatabase)
//lHoraAnt := val(strtran(elaptime(substr(cExec,10,8),time()),":","")) > 10000 //mais de 1 hora

//If !lExec .or. (lExec .and. (lDiaAnt .or. lHoraAnt))
If lExec
	If upper(alltrim(GetEnvServer())) $ "SCHEDULE-PRE" //EXECUTA SOMENTE NO AMBIENTE SCHEDULE
		
		If LockByName("GENI018",.T.,.T.,.T.)
		
			//PutMv("GENI018EX",".T.")
			//PutMv("GENI018DT",DTOS(dDatabase)+" "+time())
			GENI018A(Val(aTimeExec[3]))
			//PutMv("GENI018EX",".F.")			
			UnLockByName("GENI018",.T.,.T.,.T.)
			
			Conout("GENI018 - finalizando importação de pedido de vendas. "+DtoC(DDataBase)+" - "+Time())
			
		Else
			Conout("GENI018 - não foi possível iniciar a rotina pois a mesma já está sendo executada! "+DtoC(DDataBase)+" - "+Time())
		EndIf	
	Endif
//Endif
EndIf

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
Static Function GENI018A(nTimeExec)

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
Local _cFretePd		:= GetNextAlias()
Local _cArqPd		:= GetNextAlias()
Local _cArqPro		:= GetNextAlias()
Local _cNome		:= ""
Local _nDIGITAL		:= nil

Local _nI           := 0
Local _nTotParc     := 0

Local _aParcItem	:= {}
Local _cPgt9Web		:= GETMV("GEN_PG9WEB")
Local cFORMAPG		:= ""
Local cProd1Cent	:= SuperGetMv("GEN_FAT152",.f.,"")
Local cCodFor		:= ""
Local cMvCodFor 	:= SuperGetMv("GEN_FAT168",.f.,"378803")
Local cMvTESGen		:= SuperGetMv("GEN_FAT170",.f.,"")
Local cCST			:= ""
Local cTesUsada		:= ""
Local cOrigem		:= ""
Local cTimeIni		:= ""
Local dDataIni		:= Ctod("  /  /  ")
Local cMsgDupl		:= ""
Local lBlqPed		:= .F.
Local _cProduto		:= ""
Local nPrcLis		:= 0
Local nPrcVen		:= 0
Local cProdAct		:= GetMv("GEN_PROACT",.F.,"42198502|42198503|42198504|42198505|42198506|")// produtos action
Local lVldDuplic	:= GetMv("GEN_FAT270",.F.,.T.)

Private _cQuery		:= ""
Private _cArqTmp	:= GetNextAlias()
Private _oServer	:= Nil
Private _cFilCont	:= ""
Private _cView		:= "" //Parâmetro que contém o nome da view que será consultada para a criação do Pedido de Vendas
Private _cLogPd		:= "" //Parâmetro que contém o caminho onde será gravado o arquivo de log de inconsistências
Private _aCabPd 	:= {}
Private _aItmPd 	:= {}
Private _alinha		:= {}

Private cNatCart	:= GetMv("GENI018CAR") //NATUREZA PARA CARTAO DE CREDITO
Private cNatBol		:= GetMv("GENI018BOL") //NATUREZA PARA BOLETO

Default nTimeExec	:= 1

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

MemoWrite("GENI018_1.sql",_cQuery)

If _lVwWeb
	_cTabela := GetMv("GEN_FAT064")
	//	_dIniTab := Posicione("DA0",1,xFilial("DA0")+_cTabela,"DA0_DATDE")
	//	_cQuery += " WHERE C5_EMISSAO >= '"+dtos(_dIniTab)+"'
Endif

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqTmp, .F., .T.)

cTimeIni	:= Time()
dDataIni	:= DDataBase
cFat64		:= GetMv("GEN_FAT064")
cCoFAT65	:= GetMv("GEN_FAT065")                         
cRisco		:= GetMv("GEN_FAT066")	
_nCtVi 		:= 0

While (_cArqTmp)->(!EOF())

	/* validação de tempo de execução para não ultrapassar tempo de processamento evitando travamentos */
	If Val(StrTokArr(ElapTime ( cTimeIni, Time() ),":")[1]) >= nTimeExec .OR. dDataIni <> DDataBase
		Conout("GENI018 - ultrapassou o tempo limite de execução, a mesma será finalizada! "+DtoC(DDataBase)+" - "+Time())
		Exit
	EndIf
	
	cChavCli := alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))
	
	Do While cChavCli == alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Validação da Trasnportadora, para não realizar o processamento³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cMsg	 := ""
		_cTipo   := IIF(ValType((_cArqTmp)->TIPO) == "N",cValtochar((_cArqTmp)->TIPO),(_cArqTmp)->TIPO)
		_cPedWeb := IIF(ValType((_cArqTmp)->C5_XPEDWEB) == "N",alltrim(str((_cArqTmp)->C5_XPEDWEB)),(_cArqTmp)->C5_XPEDWEB)
		_cPedOld := IIF(ValType((_cArqTmp)->C5_XPEDOLD) == "N",alltrim(str((_cArqTmp)->C5_XPEDOLD)),(_cArqTmp)->C5_XPEDOLD)
		_cProduto:= padr(alltrim((_cArqTmp)->C6_PRODUTO),tamsx3("C6_PRODUTO")[1])
		
		Conout("GENI018 - Analisando pedido WEB "+_cPedWeb+" - "+DtoC(DDataBase)+" - "+Time())

		If (_cArqTmp)->DIGITAL <> 1
			_cTipo   := IIF(ValType((_cArqTmp)->TIPO) == "N",cValtochar((_cArqTmp)->TIPO),(_cArqTmp)->TIPO)
			If !Empty((_cArqTmp)->C5_TRANSP)
				DbSelectArea("SA4")
				DbSetOrder(1)
				If SA4->(DbSeek(xFilial("SA4")+STRZERO((_cArqTmp)->C5_TRANSP,6)))
					If fieldpos("A4_MSBLQL") > 0 .and. SA4->A4_MSBLQL = "1"
						_cMsg := "Transportadora: " + STRZERO((_cArqTmp)->C5_TRANSP,6) + " encontra-se bloqueada, favor verificar."
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
			cOrigem	:= (_cArqTmp)->ORIGEM
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
			_cCdMun := IIF(Alltrim((_cArqTmp)->A1_EST) == 'EX','99999'			,_cCdMun)
			_cCep	:= IIF(Alltrim((_cArqTmp)->A1_EST) == 'EX'  ,'00000000'	,Alltrim((_cArqTmp)->A1_CEP))
			_cCep	:= StrTran(_cCep," ","")
			_cCep	:= StrTran(_cCep,".","")
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
			_cCodPs := STRZERO((_cArqTmp)->A1_CODPAIS,TAMSX3("A1_CODPAIS")[1])
			_cEndNm := IIF(Empty((_cArqTmp)->A1_XENDNUM),"0",AllTrim((_cArqTmp)->A1_XENDNUM))
			_cVend	:= IIF(ValType((_cArqTmp)->A1_VEND)=="C" ,STRZERO(Val((_cArqTmp)->A1_VEND),TAMSX3("A1_VEND")[1]),STRZERO((_cArqTmp)->A1_VEND,TAMSX3("A1_VEND")[1]))
			_cTpDes	:= IIF(ValType((_cArqTmp)->A1_VEND)=="C" ,(_cArqTmp)->A1_XTPDES,cValToChar((_cArqTmp)->A1_XTPDES))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Cleuto Lima - 22/06/2016                            ³
			//³                                                    ³
			//³incluido para validar o nome do cliente quando mesmo³
			//³não tem CGC                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_cNome		:= upper(AllTrim((_cArqTmp)->A1_NOME))
			_nDIGITAL	:= (_cArqTmp)->DIGITAL
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
			
			_cBairro := alltrim((_cArqTmp)->A1_BAIRRO)
			_cEst := AllTrim((_cArqTmp)->A1_EST)
			_cEstado := allTrim((_cArqTmp)->A1_ESTADO)
			
			If len(alltrim(_cCep)) = 8 .and. _cEst <> 'EX'
				
				IF Empty(_cEst) .OR. Empty(_cCdMun) .OR. !ExistCpo("CC2",_cEst+_cCdMun)
					IF !U_GENA095C(_cCep,@_cEst,@_cEstado,@_cCdMun,@_cMunic,,@_cBairro)
						_cMsg := "Dados de endereço invalido: "+Chr(13)+Chr(10)
						_cMsg += "cod.Mun.: "+_cCdMun+Chr(13)+Chr(10)
						_cMsg += "Cep: "+Alltrim((_cArqTmp)->A1_CEP)+Chr(13)+Chr(10)
						_cMsg += "Municio: "+(_cArqTmp)->A1_MUN+Chr(13)+Chr(10)

						MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + ".txt" , _cMsg )
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
			
			If !_lVwWeb
				_cTabela := Iif(!Empty((_cArqTmp)->C5_TABELA),(_cArqTmp)->C5_TABELA,cFat64)
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
			If !Empty((_cArqTmp)->A1_XCODOLD)
				aAdd(_aClient,{"A1_XCODOLD"	,	alltrim(str((_cArqTmp)->A1_XCODOLD))				,Nil})
			Endif
			aAdd(_aClient,{"A1_NOME"	,	upper(AllTrim((_cArqTmp)->A1_NOME))						,Nil})
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
			aAdd(_aClient,{"A1_ENDENT"	,	AllTrim((_cArqTmp)->A1_ENDENT)							,Nil})
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
			aAdd(_aClient,{"A1_XCONDPG"	,	STRZERO((_cArqTmp)->A1_XCONDPG,TAMSX3("A1_XCONDPG")[1]),Nil}) //Condicao Pagto (GEN)
			//aAdd(_aClient,{"A1_COND"	,	GetMv("GEN_FAT065")	,Nil})
			aAdd(_aClient,{"A1_COND"	,	cCoFAT65	,Nil})			
			aAdd(_aClient,{"A1_TABELA"	,	_cTabela			,Nil})
			aAdd(_aClient,{"A1_LC"		,	(_cArqTmp)->A1_LC										,Nil}) //Limite de Crédito 
			aAdd(_aClient,{"A1_BLEMAIL"	,	(_cArqTmp)->A1_BLEMAIL									,Nil}) //Boleto por Email
			aAdd(_aClient,{"A1_RISCO"	,	cRisco												,Nil}) //Limite de Crédito
			
			aAdd(_aClient,{"A1_XPTREF"	,	(_cArqTmp)->A1_XPTREF									,Nil})
						
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

				_cQry1 := "SELECT C5_XPEDWEB, SUM(C5_FRETE) C5_FRETE
				_cQry1 += " FROM " + RetSqlName("SC5") + " SC5
				_cQry1 += " WHERE D_E_L_E_T_ = ' '
				_cQry1 += " AND C5_XPEDWEB = '"  + _cPedWeb + "'"
				_cQry1 += " GROUP BY C5_XPEDWEB
				//_cQuery := ChangeQuery(_cQuery)
				
				If Select(_cFretePd) > 0
					dbSelectArea(_cFretePd)
					(_cFretePd)->(dbCloseArea())
				EndIf
				
				dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQry1), _cFretePd, .F., .T.)
				
				If (_cFretePd)->(!EOF()) .and. (_cFretePd)->C5_FRETE <> 0
					aAdd ( _aCabPd , { "C5_FRETE" 	, 0				 						, NIL} )
                Else				
					aAdd ( _aCabPd , { "C5_FRETE" 	, (_cArqTmp)->C5_FRETE 					, NIL} )
				EndIf
			Else
				_cTransp := Space(TamSx3("C5_TRANSP")[1])
				lDigital := .T.
				aAdd ( _aCabPd , { "C5_FRETE" 	, 0				 						, NIL} )
			Endif
			
			aAdd ( _aCabPd , { "C5_TIPO"    , "N"       					   			, NIL} )
			
			If "VENDA" $ _cTipo
				aAdd ( _aCabPd , { "C5_CONDPAG" , _cPgt9Web             					, NIL} )
			Else
				aAdd ( _aCabPd , { "C5_CONDPAG"	, (_cArqTmp)->C5_CONDPAG   				, NIL} )
				aAdd ( _aCabPd , { "C5_NATUREZ"	, cNatBol								, NIL} )
			EndIf
			
			// Cleuto - 19/09/2016 - chamado 30800
			//aAdd ( _aCabPd , { "C5_EMISSAO" , STOD((_cArqTmp)->C5_EMISSAO)	   			, NIL} )
			
			aAdd ( _aCabPd , { "C5_EMISSAO" , DDataBase	   			, NIL} )			
			aAdd ( _aCabPd , { "C5_XPEDOLD" , _cPedOld 									, NIL} )
			aAdd ( _aCabPd , { "C5_TPFRETE" , (_cArqTmp)->C5_TPFRETE 					, NIL} )
			aAdd ( _aCabPd , { "C5_MOEDA" 	, (_cArqTmp)->C5_MOEDA 						, NIL} )
			aAdd ( _aCabPd , { "C5_PESOL" 	, (_cArqTmp)->C5_PSOL 						, NIL} )
			aAdd ( _aCabPd , { "C5_PBRUTO" 	, (_cArqTmp)->C5_PBRUTO 					, NIL} )
			aAdd ( _aCabPd , { "C5_TIPLIB" 	, (_cArqTmp)->C5_TPLIB						, NIL} )
			aAdd ( _aCabPd , { "C5_XTPREMS" , (_cArqTmp)->C5_XTPREMS					, NIL} )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Cleuto - 16/02/2017                                                         ³
			//³                                                                            ³
			//³removida tabela de preço para que sempre seja fatuado com                   ³
			//³o valor do pedido retornado pelo Site.                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//aAdd ( _aCabPd , { "C5_TABELA"  , _cTabela									, NIL} )
			aAdd ( _aCabPd , { "C5_XPEDWEB" , _cPedWeb									, NIL} )
			
			If Empty(AllTrim((_cArqTmp)->C5_XLOGENT)) 
				aAdd ( _aCabPd , { "C5_XSNOENT" , " "									, NIL} )
				aAdd ( _aCabPd , { "C5_XNOMENT" , upper(AllTrim((_cArqTmp)->A1_NOME))	, NIL} )
				aAdd ( _aCabPd , { "C5_XTELENT" , (_cArqTmp)->A1_TEL					, NIL} )
				aAdd ( _aCabPd , { "C5_XDDDENT" , (_cArqTmp)->A1_DDD					, NIL} )
				aAdd ( _aCabPd , { "C5_XCOMENT" , (_cArqTmp)->A1_COMPLEMEN				, NIL} )
				aAdd ( _aCabPd , { "C5_XLOGENT" , (_cArqTmp)->A1_END					, NIL} )
				aAdd ( _aCabPd , { "C5_XCELENT" , " "									, NIL} )
				aAdd ( _aCabPd , { "C5_XDDCENT" , " "									, NIL} )
				aAdd ( _aCabPd , { "C5_XBAIENT" , (_cArqTmp)->A1_BAIRRO				, NIL} )
				aAdd ( _aCabPd , { "C5_XPAIENT" , (_cArqTmp)->A1_PAISDES				, NIL} )
				aAdd ( _aCabPd , { "C5_XCEPENT" , StrTran(_cCep,".","")				, NIL} )
				aAdd ( _aCabPd , { "C5_XMUNENT" , AllTrim((_cArqTmp)->A1_COD_MUN)		, NIL} )
				aAdd ( _aCabPd , { "C5_XCIDENT" , AllTrim(_cMunic)						, NIL} )
				aAdd ( _aCabPd , { "C5_XUFENT"  , AllTrim((_cArqTmp)->A1_EST)			, NIL} )
				aAdd ( _aCabPd , { "C5_XNUMENT" , _cEndNm			   					, NIL} )			
				
				If SC5->(FieldPos("C5_XPTREF")) > 0 .AND. SA1->(FieldPos("A1_XPTREF")) > 0 
					aAdd ( _aCabPd , { "C5_XPTREF"  , (_cArqTmp)->A1_XPTREF			, NIL} )			
				EndIf
								
			Else
				aAdd ( _aCabPd , { "C5_XSNOENT" , (_cArqTmp)->C5_XSNOENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XNOMENT" , (_cArqTmp)->C5_XNOMENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XTELENT" , (_cArqTmp)->C5_XTELENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XDDDENT" , AllTrim(Str((_cArqTmp)->C5_XDDDENT))	, NIL} )
				aAdd ( _aCabPd , { "C5_XCOMENT" , (_cArqTmp)->C5_XCOMENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XLOGENT" , (_cArqTmp)->C5_XLOGENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XCELENT" , IIF( AllTrim(Str((_cArqTmp)->C5_XCELENT)) <> "0" , AllTrim(Str((_cArqTmp)->C5_XCELENT)), "" )	, NIL} )
				aAdd ( _aCabPd , { "C5_XDDCENT" , IIF( AllTrim(Str((_cArqTmp)->C5_XDDCENT)) <> "0" , AllTrim(Str((_cArqTmp)->C5_XDDCENT)) , "" )	, NIL} )
				aAdd ( _aCabPd , { "C5_XBAIENT" , (_cArqTmp)->C5_XBAIENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XPAIENT" , (_cArqTmp)->C5_XPAIENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XCEPENT" , StrTran((_cArqTmp)->C5_XCEPENT,".",""), NIL} )
				aAdd ( _aCabPd , { "C5_XMUNENT" , IIF( AllTrim(STR((_cArqTmp)->C5_XMUNENT)) <> "0" , AllTrim(STR((_cArqTmp)->C5_XMUNENT)) , "" )	, NIL} )
				aAdd ( _aCabPd , { "C5_XCIDENT" , (_cArqTmp)->C5_XCIDENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XUFENT"  , (_cArqTmp)->C5_XUFENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XNUMENT" , (_cArqTmp)->C5_XNUMENT				, NIL} )				
				
				If SC5->(FieldPos("C5_XPTREF")) > 0
					aAdd ( _aCabPd , { "C5_XPTREF"  , (_cArqTmp)->C5_XPTREF			   	, NIL} )			
				EndIf	
								
    		EndIf

			//If !Empty(_cTransp)
			aAdd ( _aCabPd , { "C5_TRANSP"  , _cTransp									, NIL} )
			//EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Alimentando informações pertinente ao produto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			_nItemC6 	:= 1 
			_aItmPd 	:= {}
			//Zerando as Variáveis
			_nTotParc 	:= 0
			nPrcLis		:= 0
			nPrcVen		:= 0

			//Conout("GENI018 - Montagem do Vetor de Pedido de Vendas - Item")
			
			_cCont 		:= "01"
			While (_cArqTmp)->(!EOF()) .And. _cPedOld == AllTrim(Str((_cArqTmp)->C5_XPEDOLD)) .and. _cCont <= "99";
				.and. cChavCli = alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))//;
				 //.AND. Empty(_cMsg)
				
				_alinha  := {}
				//Conout("GENI018 - Entrou no While do item pedido de vendas ")
				_cDescPd	:= Posicione("SB1",1,xFilial("SB1") + (_cArqTmp)->C6_PRODUTO,"B1_DESC")				
				cCodFor		:= SB1->B1_PROC
				//cMvTESGen	:= SB1->B1_TS alterado para utilizar parametro
				
				_cLocB1		:= IIF(Empty(AllTrim((_cArqTmp)->C6_LOCAL)),Posicione("SB1",1,xFilial("SB1") + (_cArqTmp)->C6_PRODUTO,"B1_LOCPAD"),(_cArqTmp)->C6_LOCAL)
				_cProduto	:= padr(alltrim((_cArqTmp)->C6_PRODUTO),tamsx3("C6_PRODUTO")[1])

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Validação de produto, para não realizar o processamento de mais de um item do mesmo produto no pedido³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If _lVwWeb
					_cQryPro := "SELECT C5_XPEDWEB, C6_PRODUTO, COUNT(*) ITENS
					_cQryPro += "  FROM " + _cView
					_cQryPro += " WHERE TRIM(C5_XPEDWEB) = '" + ALLTRIM(_cPedWeb) + "'"
					//_cQryPro += "   AND TRIM(C6_PRODUTO) = '" + ALLTRIM(_cProduto) + "'"			
					_cQryPro += " GROUP BY C5_XPEDWEB, C6_PRODUTO
					_cQryPro += " HAVING COUNT(*) > 1

					If Select(_cArqPro) > 0
						dbSelectArea(_cArqPro)
						(_cArqPro)->(dbCloseArea())
					EndIf
					
					dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQryPro), _cArqPro, .F., .T.)
					
					If (_cArqPro)->(!EOF())
						_cMsg := "Pedido com o produto " + ALLTRIM((_cArqPro)->C6_PRODUTO)+" com item duplicado (" + ALLTRIM(STR((_cArqPro)->ITENS)) + " itens)."
					EndIf
					(_cArqPro)->(dbCloseArea())
				EndIf

				If Empty(_cMsg)
					/* cleuto - 08/03/2019 - incluida validação de duplicidade do pedido  */
					_cQuery := "SELECT SC5.D_E_L_E_T_ DELSC5,C5_XPEDWEB,C6_XPEDWEB, C6_PRODUTO
					_cQuery += " FROM " + RetSqlName("SC6") + " SC6
					_cQuery += " JOIN " + RetSqlName("SC5") + " SC5
					_cQuery += " ON C5_FILIAL = C6_FILIAL
					_cQuery += " AND C6_NUM = C5_NUM
					_cQuery += " WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"'
					_cQuery += " AND ( C5_XPEDWEB = '"  + _cPedWeb  + "'"+" OR C6_XPEDWEB = '"  + _cPedWeb  + "' )"
					_cQuery += " AND C6_PRODUTO = '"  + _cProduto + "'"
				
					If Select("TMP_PDWEB") > 0
						DbSelectArea("TMP_PDWEB")
						TMP_PDWEB->(dbCloseArea())
					EndIf
				
					DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), "TMP_PDWEB", .F., .T.)
					TMP_PDWEB->(DbGoTop())
					If TMP_PDWEB->(!EOF())
						_cMsg :=	"Pedido web "+_cPedWeb+" já localizado na base de dados com o produto " + ALLTRIM(_cProduto)+"."+chr(13)+chr(10)+;
									IIF( TMP_PDWEB->DELSC5=="*", "Pedido já deletado no Protheus", "" )
					EndIf
					TMP_PDWEB->(dbCloseArea())
				EndIf
				
				/* < Valida pedido duplicado na GENESB.PEDIDO > */
				// Cleuto -17/04/2019 - temporario deve ser removido com OK do Rafael. 		

				/*
				Cleuto - 05/10/2020 - 17hs incluida lVldDuplic para desativar a validação a pedido da diretoria em 05/10/2020, essa alteração é
				pontual e deve ser revista em 06/10/2020
				*/
				If lVldDuplic .and. Empty(_cMsg)
					cMsgDupl	:= ""
					lBlqPed	:= .F.
					/* cleuto - 08/03/2019 - incluida validação de duplicidade do pedido  */
					_cQuery := ""
					_cQuery += " SELECT 1 POS, '0'  PEDIDO,Count(*) qtd,TOTAL, COBRANCA_NOME_RAZAO, COBRANCA_SOBRENOME_FANTAZIA, COBRANCA_CPF_CNPJ, ENTREGA_NOME, ENTREGA_BAIRRO, ENTREGA_UF, ENTREGA_MUNICIPIO_IBGE, ENTREGA_CEP, to_char(DATA_PEDIDO,'YYYYMMDD') DATA_PEDIDO, 0 EXISTE
					_cQuery += " FROM GENESB.PEDIDO_NOVO PD
					_cQuery += " WHERE NUMERO <> '"+_cPedWeb+"'
					/* verifico de existe pedido com mesmos dados de entrega e valor no mesmo dia para o mesmo cliente */
					_cQuery += " AND EXISTS(
					_cQuery += "     SELECT 1 FROM GENESB.PEDIDO_NOVO DUP
					_cQuery += "     WHERE NUMERO = '"  + _cPedWeb  + "'" 
					_cQuery += "     AND TRIM(DUP.COBRANCA_CPF_CNPJ) = TRIM(PD.COBRANCA_CPF_CNPJ)
					_cQuery += "     AND to_char(DUP.DATA_PEDIDO,'YYYYMMDD') = to_char(PD.DATA_PEDIDO,'YYYYMMDD')
					_cQuery += "     AND NVL(DUP.ENTREGA_BAIRRO,' ') = NVL(PD.ENTREGA_BAIRRO,' ')
					_cQuery += "     AND NVL(DUP.ENTREGA_UF,' ') = NVL(PD.ENTREGA_UF,' ')
					_cQuery += "     AND NVL(DUP.ENTREGA_MUNICIPIO_IBGE,0) = NVL(PD.ENTREGA_MUNICIPIO_IBGE,0)
					_cQuery += "     AND NVL(DUP.ENTREGA_CEP,' ') = NVL(PD.ENTREGA_CEP,' ')
					_cQuery += "     AND NVL(DUP.TOTAL,0) = NVL(PD.TOTAL,0)
					_cQuery += " )
					
					/* verifico se quantidade de itens são as mesmas */
					_cQuery += " AND ( SELECT COUNT(*) QTD FROM GENESB.ITEM_NOVO ITA WHERE ITA.PEDIDO_ENTITY_ID = PD.ENTITY_ID) = ( SELECT COUNT(*) QTD FROM GENESB.ITEM_NOVO ITB WHERE ITB.PEDIDO_ENTITY_ID = "+AllTrim(_cPedOld)+" )

					/* verifico se existe algum item diferente entre os pedidos */
					_cQuery += " AND (
					_cQuery += "       SELECT COUNT(*) QTD FROM GENESB.ITEM_NOVO ITA
					_cQuery += "       WHERE ITA.PEDIDO_ENTITY_ID = "+AllTrim(_cPedOld)
					_cQuery += "       AND NOT EXISTS(
					_cQuery += "         SELECT 1 FROM GENESB.ITEM_NOVO ITB
					_cQuery += "         WHERE ITB.PEDIDO_ENTITY_ID = PD.ENTITY_ID
					_cQuery += "         AND ITB.SKU = ITA.SKU
					_cQuery += "         AND ITB.QUANTIDADE = ITA.QUANTIDADE
					_cQuery += "       )
					_cQuery += "      ) = 0

					_cQuery += " GROUP BY TOTAL, COBRANCA_NOME_RAZAO, COBRANCA_SOBRENOME_FANTAZIA, COBRANCA_CPF_CNPJ, ENTREGA_NOME, ENTREGA_BAIRRO, ENTREGA_UF, ENTREGA_MUNICIPIO_IBGE, ENTREGA_CEP, to_char(DATA_PEDIDO,'YYYYMMDD')
					_cQuery += " HAVING COUNT(*) > 0
					
					_cQuery += " UNION ALL
					_cQuery += " SELECT 2 POS, NUMERO  PEDIDO,1 qtd,TOTAL, COBRANCA_NOME_RAZAO, COBRANCA_SOBRENOME_FANTAZIA, COBRANCA_CPF_CNPJ, ENTREGA_NOME, ENTREGA_BAIRRO, ENTREGA_UF, ENTREGA_MUNICIPIO_IBGE, ENTREGA_CEP, to_char(DATA_PEDIDO,'YYYYMMDD') DATA_PEDIDO,
					_cQuery += " ( SELECT COUNT(*) FROM " + RetSqlName("SC6") + " SC6 WHERE TRIM(C6_XPEDWEB) = TRIM(NUMERO) AND C6_PRODUTO = '"+_cProduto+"' ) EXISTE
					_cQuery += " FROM GENESB.PEDIDO_NOVO PD
					_cQuery += " WHERE EXISTS(
					_cQuery += "     SELECT 1 FROM GENESB.PEDIDO_NOVO DUP
					_cQuery += "     WHERE NUMERO = '"  + _cPedWeb  + "'" 
					_cQuery += "     AND TRIM(DUP.COBRANCA_CPF_CNPJ) = TRIM(PD.COBRANCA_CPF_CNPJ)
					_cQuery += "     AND to_char(DUP.DATA_PEDIDO,'YYYYMMDD') = to_char(PD.DATA_PEDIDO,'YYYYMMDD')
					_cQuery += "     AND NVL(DUP.ENTREGA_BAIRRO,' ') = NVL(PD.ENTREGA_BAIRRO,' ')
					_cQuery += "     AND NVL(DUP.ENTREGA_UF,' ') = NVL(PD.ENTREGA_UF,' ')
					_cQuery += "     AND NVL(DUP.ENTREGA_MUNICIPIO_IBGE,0) = NVL(PD.ENTREGA_MUNICIPIO_IBGE,0)
					_cQuery += "     AND NVL(DUP.ENTREGA_CEP,' ') = NVL(PD.ENTREGA_CEP,' ')
					_cQuery += "     AND NVL(DUP.TOTAL,0) = NVL(PD.TOTAL,0)
					_cQuery += " ) 
					/* verifico se quantidade de itens são as mesmas */
					_cQuery += " AND ( SELECT COUNT(*) QTD FROM GENESB.ITEM_NOVO ITA WHERE ITA.PEDIDO_ENTITY_ID = PD.ENTITY_ID) = ( SELECT COUNT(*) QTD FROM GENESB.ITEM_NOVO ITB WHERE ITB.PEDIDO_ENTITY_ID = "+AllTrim(_cPedOld)+" )

					/* verifico se existe algum item diferente entre os pedidos */
					_cQuery += " AND (
					_cQuery += "       SELECT COUNT(*) QTD FROM GENESB.ITEM_NOVO ITA
					_cQuery += "       WHERE ITA.PEDIDO_ENTITY_ID = "+AllTrim(_cPedOld)
					_cQuery += "       AND NOT EXISTS(
					_cQuery += "         SELECT 1 FROM GENESB.ITEM_NOVO ITB
					_cQuery += "         WHERE ITB.PEDIDO_ENTITY_ID = PD.ENTITY_ID
					_cQuery += "         AND ITB.SKU = ITA.SKU
					_cQuery += "         AND ITB.QUANTIDADE = ITA.QUANTIDADE
					_cQuery += "       )
					_cQuery += "      ) = 0
										
					_cQuery += " ORDER BY POS ASC
				
					If Select("TMP_PDWEB") > 0
						DbSelectArea("TMP_PDWEB")
						TMP_PDWEB->(dbCloseArea())
					EndIf
				
					DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), "TMP_PDWEB", .F., .T.)
					TMP_PDWEB->(DbGoTop())
					If TMP_PDWEB->POS == 1 .AND. TMP_PDWEB->QTD > 0

						cMsgDupl :=	"Possível duplicidade de Pedido do site Gen "+_cPedWeb+chr(13)+chr(10)+;
						"Sugerimos analise no magento e caso confirmada duplicidade efetue o procedimento de cancelamento"+chr(13)+chr(10)
												
						While TMP_PDWEB->(!EOF()) 
							IF TMP_PDWEB->POS == 1
								TMP_PDWEB->(DbSkip())
								Loop
							ENDIF

							lBlqPed	:= IIF( TMP_PDWEB->EXISTE > 0 , .T. , lBlqPed  )						
							cMsgDupl	+=	"Pedido web "+AllTrim(TMP_PDWEB->PEDIDO)+"  "+IIF( TMP_PDWEB->EXISTE > 0 , "( Já Faturado no Protheus )" , ""  )+" , CPF cobrança "+AllTrim(TMP_PDWEB->COBRANCA_CPF_CNPJ)+;
							", Dados entrega: "+AllTrim(TMP_PDWEB->ENTREGA_NOME)+" - "+AllTrim(TMP_PDWEB->ENTREGA_BAIRRO)+" - "+AllTrim(TMP_PDWEB->ENTREGA_UF)+" - "+AllTrim(TMP_PDWEB->ENTREGA_CEP)+;
							", Data Pedido: "+DtoC(StoD(TMP_PDWEB->DATA_PEDIDO))+chr(13)+chr(10)
							TMP_PDWEB->(DbSkip())
						EndDo
						
					EndIf
					TMP_PDWEB->(dbCloseArea())
					If lBlqPed
						_cMsg := cMsgDupl
					ElseIf !Empty(cMsgDupl)
						cMsgDupl += "O Protheus vai tentar faturar o pedido "+_cPedWeb+" pois entende que apenas um dos pedidos pode ser faturado!"	
						MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_DUPLICIDADE.txt" , cMsgDupl )
					EndIf
					
					/* Cleuto - 29/04/2020 - desativado o envio de e-mail a pedido do Rafael devido a quantidade de ocorrencias
					If !Empty(cMsgDupl)
						U_GenSendMail(,,,"noreply@grupogen.com.br","ecommerce@grupogen.com.br;sac@grupogen.com.br;desenvolvimento@grupogen.com.br",oemtoansi("Site Gen - Pedido Duplicado"),cMsgDupl,,,.F.)
					EndIf	
					*/
				EndIf		
				/* </ Valida pedido duplicado na GENESB.PEDIDO > */

				If !_lVwWeb
					tcsqlexec("UPDATE "+RetSqlName("DA1")+" SET DA1_PRCVEN = "+alltrim(str((_cArqTmp)->C6_PRCVEN))+", DA1_DATVIG = ' ' WHERE DA1_CODTAB = '"+_cTabela+"' AND DA1_CODPRO = '"+_cProduto+"' AND D_E_L_E_T_ = ' '")
				Endif
				
                // 25/069/2015 - Helimar Tavares - inclusao de critica pedidoweb + produto
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Só irá incluir os pedidos que não forem encontrados no protheus prevenindo assim algum problema na View³
				//³Conforme solicitado será alimentado a FLAG VIEW dos pedidos
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_cQuery := "SELECT C6_XPEDWEB, C6_PRODUTO
				_cQuery += " FROM " + RetSqlName("SC6") + " SC6
				_cQuery += " JOIN " + RetSqlName("SC5") + " SC5
				_cQuery += " ON C5_FILIAL = C6_FILIAL
				_cQuery += " AND C6_NUM = C5_NUM
				_cQuery += " AND SC6.D_E_L_E_T_ <> '*'
				_cQuery += " WHERE SC5.D_E_L_E_T_ = ' '
				_cQuery += " AND C5_XPEDWEB = '"  + _cPedWeb  + "'"
				_cQuery += " AND C5_XPEDOLD = '"  + _cPedOld  + "'"
				_cQuery += " AND C6_XPEDWEB = '"  + _cPedWeb  + "'"
				_cQuery += " AND C6_PRODUTO = '"  + _cProduto + "'"

				If Select(_cArqPd) > 0
					dbSelectArea(_cArqPd)
					(_cArqPd)->(dbCloseArea())
				EndIf

				dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqPd, .F., .T.)

				If Empty(_cMsg) .AND. (((_cArqPd)->(EOF()) .and. _lVwWeb) .or. !_lVwWeb)

					Begin Transaction
						tcsqlexec("UPDATE "+RetSqlName("SB2")+" SET B2_QTNP = 0 WHERE B2_FILIAL = '"+xFilial("SB2")+"' AND B2_LOCAL = '01' AND D_E_L_E_T_ = ' ' AND B2_COD = '"+_cProduto+"'")							
					End Transaction
											
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄá
					//³Alimentando os Itens do pedido³              
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄá
                    
					/* <Vivaz - 34422  - Cleuto - 10/05/2017 - >*/
					/* Tratamento especifico para produtos vendidos com valor de R$ 0,01, na view os mesmos estão sendo retornados com desconto de 100% e com isso o Protheus gerar erro de execauto. */
					If AllTrim(_cProduto) $ cProd1Cent .AND. (_cArqTmp)->C6_DESCONT == 100

						aAdd ( _alinha , { "C6_ITEM"    , _cCont						, NIL} )
						aAdd ( _alinha , { "C6_PRODUTO" , _cProduto						, NIL} )
						aAdd ( _alinha , { "C6_DESCRI"  , _cDescPd  					, NIL} )
						aAdd ( _alinha , { "C6_QTDVEN"  , (_cArqTmp)->C6_QTDVEN   		, NIL} )
						aAdd ( _alinha , { "C6_QTDLIB"  , (_cArqTmp)->C6_QTDVEN   		, NIL} )
						aAdd ( _alinha , { "C6_PRCVEN"  , 0.01					   		, NIL} )
						aAdd ( _alinha , { "C6_VALOR"   , (_cArqTmp)->C6_QTDVEN*0.01	, NIL} )
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Cleuto - 20/07/2017                                         ³
						//³                                                            ³
						//³quando obra pertence ao Gen deve utilizar a TES especificada³
						//³no produto                                                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If AllTrim(cCodFor) == AllTrim(cMvCodFor)
							If "VENDA" $ _cTipo
								aAdd ( _alinha , { "C6_TES"     , cMvTESGen				, NIL} )
								cTesUsada	:= cMvTESGen
							Else
								aAdd ( _alinha , { "C6_TES"     , (_cArqTmp)->C6_TES				, NIL} )
								cTesUsada	:= (_cArqTmp)->C6_TES
							EndIf
						Else
							aAdd ( _alinha , { "C6_TES"     , (_cArqTmp)->C6_TES	, NIL} )
							cTesUsada	:= (_cArqTmp)->C6_TES
						EndIf
											
						aAdd ( _alinha , { "C6_LOCAL"   ,  _cLocB1   					, NIL} )
						aAdd ( _alinha , { "C6_DESCONT" , 0						    	, NIL} )
						aAdd ( _alinha , { "C6_VALDESC" , 0						    	, NIL} )
						aAdd ( _alinha , { "C6_ENTREG"  , STOD((_cArqTmp)->C6_ENTREG)	, NIL} )
						aAdd ( _alinha , { "C6_XPEDWEB" , _cPedWeb						, NIL} )

						_nValTot += (_cArqTmp)->C6_QTDVEN*0.01
						_nTotParc+= (_cArqTmp)->C6_QTDVEN*0.01
																
					Else

						aAdd ( _alinha , { "C6_ITEM"    , _cCont						, NIL} )
						aAdd ( _alinha , { "C6_PRODUTO" , _cProduto						, NIL} )
						aAdd ( _alinha , { "C6_DESCRI"  , _cDescPd  					, NIL} )
						aAdd ( _alinha , { "C6_QTDVEN"  , (_cArqTmp)->C6_QTDVEN   		, NIL} )
						aAdd ( _alinha , { "C6_QTDLIB"  , (_cArqTmp)->C6_QTDVEN   		, NIL} )

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Cleuto - 20/07/2017                                         ³
						//³                                                            ³
						//³quando obra pertence ao Gen deve utilizar a TES especificada³
						//³no produto                                                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

						IF AllTrim(_cProduto) $ cProdAct
							aAdd ( _alinha , { "C6_TES"     , "506" , NIL} )
							cTesUsada	:= '506'
						ELSE
							If AllTrim(cCodFor) == AllTrim(cMvCodFor)
								If "VENDA" $ _cTipo
									aAdd ( _alinha , { "C6_TES"     , cMvTESGen				, NIL} )
									cTesUsada	:= cMvTESGen
								Else
									aAdd ( _alinha , { "C6_TES"     , (_cArqTmp)->C6_TES				, NIL} )
									cTesUsada	:= (_cArqTmp)->C6_TES
								EndIf
							Else
								aAdd ( _alinha , { "C6_TES"     , (_cArqTmp)->C6_TES	, NIL} )
								cTesUsada	:= (_cArqTmp)->C6_TES
							EndIf
						ENDIF	
						
						aAdd ( _alinha , { "C6_LOCAL"   ,  _cLocB1   					, NIL} )
						
						If "VENDA" $ _cTipo
							nPrcLis		:= (_cArqTmp)->ZZL_PRV1
							nPrcVen		:= (_cArqTmp)->LIQ_ITEM/(_cArqTmp)->C6_QTDVEN

							aAdd ( _alinha , { "C6_PRUNIT" ,   (_cArqTmp)->ZZL_PRV1 	, NIL} )
							//aAdd ( _alinha , { "C6_PRCVEN" ,   Round(nPrcVen,2) 		, NIL} )
							aAdd ( _alinha , { "C6_PRCVEN" ,   nPrcVen 		, NIL} )

							nGenBruto := (_cArqTmp)->ZZL_PRV1*(_cArqTmp)->C6_QTDVEN
							nValDesc  := nGenBruto-(_cArqTmp)->LIQ_ITEM

							_nValTot += (_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN
							_nTotParc+= (_cArqTmp)->LIQ_ITEM							
						ELSE
							aAdd ( _alinha , { "C6_PRCVEN"  , (_cArqTmp)->C6_PRCVEN   		, NIL} )
							aAdd ( _alinha , { "C6_VALOR"   , (_cArqTmp)->C6_VALOR    		, NIL} )
							aAdd ( _alinha , { "C6_DESCONT" , (_cArqTmp)->C6_DESCONT    	, NIL} )
							aAdd ( _alinha , { "C6_VALDESC" , (_cArqTmp)->C6_VALDESC    	, NIL} )

							_nValTot += (_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN
							_nTotParc+= ((_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN) - (_cArqTmp)->C6_VALDESC
						ENDIF

						aAdd ( _alinha , { "C6_ENTREG"  , STOD((_cArqTmp)->C6_ENTREG)	, NIL} )
						aAdd ( _alinha , { "C6_XPEDWEB" , _cPedWeb						, NIL} )																
					EndIf
					/* </Vivaz - 34422 >*/
                    
					If AllTrim((_cArqTmp)->A1_TIPO) == "X"
						cCST		:= SB1->B1_ORIGEM+Posicione("SF4",1,xFilial("SF4")+cTesUsada,"F4_SITTRIB")
						aAdd ( _alinha , { "C6_CLASFIS" , cCST	, NIL} )
					EndIf
									
					aAdd(_aItmPd , _alinha)

					_nQtdTot += (_cArqTmp)->C6_QTDVEN
					_nItemC6 ++										
					_cCont 	:= soma1(_cCont)
				EndIF

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

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Validação da Condicao de Pagamento BOLETO OU CARTAO Multiplos/Unico     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ							
			
			IF Empty(_cMsg)
				If "VENDA" $ _cTipo
					
					cFORMAPG	:= ""
					_aParcItem	:= U_GENI018P(_aCabPd,_cPedOld,@cFORMAPG,_nTotParc,@_cMsg,NIL,_cPedWeb,cOrigem)

					If cFORMAPG == 'B' //BOLETO
					
						aAdd ( _aCabPd , { "C5_NATUREZ"  , cNatBol								, NIL} )
						_aCabPd[ aScan(_aCabPd,{|x| X[1] == "C5_CONDPAG" }) ][2]	:= "001"
						
					ElseIf cFORMAPG == 'C' //CARTAO
						aAdd ( _aCabPd , { "C5_NATUREZ"  , cNatCart								, NIL} )
					Endif

					If Empty(_cMsg)			
						For _nI := 1 To Len(_aParcItem)																	
							aAdd ( _aCabPd , { "C5_DATA"+_aParcItem[_nI][6] , DataValida(_aParcItem[_nI][1]), Nil} )
							aAdd ( _aCabPd , { "C5_PARC"+_aParcItem[_nI][6] , _aParcItem[_nI][2]            , Nil} )
						Next
					Else
						If SubStr(_cMsg,1,1) = 'P'
							MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_PROD_" + AllTrim(_cProduto) +  "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
						Else
							MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
						EndIf
						//(_cArqTmp)->(DbSkip())
					EndIf
						
				Else
					_aParcItem := {}	
				EndIf
			EndIF
			
			If Empty(_cMsg)
				If Len(_aItmPd) > 0
					
					GENI018B(_aClient,_aCabPd,_aItmPd,_cCodOld,_cPedOld,_cCGC,_cTipo,_cPedWeb,_cNome,_nDIGITAL,_aParcItem)
					_cCod := ""       				
					
					Conout("GENI018 - Finalizado pedido WEB "+_cPedWeb+" - "+DtoC(DDataBase)+" - "+Time())
					
				Else
					
					_cMsg := "Erro ao preencher o array de itens do pedido, 'Pedido Web' "+_cPedWeb+" este pedido não foi emitido no Protheus!"
					MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
					//(_cArqTmp)->(DbSkip())				
					
				EndIf	
			Else
			    If SubStr(_cMsg,1,1) = 'P'
					MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_PROD_" + AllTrim(_cProduto) +  "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
			    Else
					MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
	    		EndIf
				//(_cArqTmp)->(DbSkip())					
			EndIF
		Else
		    If SubStr(_cMsg,1,1) = 'P'
				MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_PROD_" + AllTrim(_cProduto) +  "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
		    Else
				MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
    		EndIf
			(_cArqTmp)->(DbSkip())
		EndIf
		_cMsg := ""
	Enddo
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
Static Function GENI018B(_aClient,_aCabPd,_aItmPd,_cCodOld,_cPedOld,_cCGC,_cTipo,_cPedWeb,_cNome,_nDIGITAL,_aParcItem)

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
Local _cMvSeri 			:= Iif(lDigital,"2",Alltrim(GetMv("GEN_FAT003"))) //Iif(lDigital,"2","10") //GetMv("GEN_FAT003") //SERIE nota de saída
Local _cNotaImp			:= ""
Local _nPosLb			:= 0
//Local _cCGC := ""		//Rafael Leite - 29/01/2015. Variavel nao pode ser declarada em branco nesse ponto.
Local _cParcela 		:= ""
Local cParc1			:= GetMv("MV_1DUP")

Local _ni,nSC5			:= 0

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.
Private _aErro			:= {}
Private _cErroLg		:= "" //Variável onde é armazenado o log quer será impresso em um arquivo
Private _cView	:= GETMV("MV_XVIEWPD")
Private _cLogPd	:= SUPERGETMV("MV_XCAMLOG",.T.,"\logsiga\ped venda\") //Parâmetro que contém o caminho onde será gravado o arquivo de log de inconsistências

Private _cMailBlk	:= SUPERGETMV("MV_XMAIBLK",.T.,"beatriz.reis@grupogen.com.br;rafael.leite@grupogen.com.br;cleuto.lima@grupogen.com.br")// Email de monitoramento dos pedidos em black list

Private cMvTpCli := SuperGetMV("GEN_FAT259",.T.,"020|033") //Tipos de Cliente que serão alterados na importação de pedidos do site GEN

//Default _cCGC := ""

_nPosLb	:= aScan(_aItmPd[1], { |x| Alltrim(x[1]) == "C6_QTDLIB" })
_nPosLj	:= aScan(_aClient, { |x| Alltrim(x[1]) == "A1_LOJA" })

// 25/09/2015 - Helimar Tavares - retirada a critica desse ponto, agora esta na criacao do array de itens
//If _cCodOld != "0"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Só irá incluir os pedidos que não forem encontrados no protheus prevenindo assim algum problema na View³
//³Conforme solicitado será alimentado a FLAG VIEW dos pedidos
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
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

If ((_cArqPd)->(EOF()) .and. _lVwWeb) .or. !_lVwWeb
*/	
	//Conout("GENI018 - Inicio do execauto de pedido de vendas e de clientes")
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
					
					SA1->(DbSetOrder(1))
					SA1->(DbGoTo(nRec))
					
				Endif
			Endif
		EndIf 
	ElseIf !Empty(AllTrim(_cNome))
		//_cNome := upper(AllTrim((_cArqTmp)->A1_NOME)) removido pois neste ponto o registro da _cArqTmp não é o do cliente do pedido
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
	
	lMsErroAuto := .F.
	//If _lImpCli
	
	//Incluida condicao abaixo. [Bruno Parreira, Actual Trend, 27/07/2018]
	//Se for cliente novo (nOpt <> 4), faz a inclusao via execauto. Se o cliente ja existir (nOpt = 4), somente executa o execauto se o tipo do cliente for 020. 
	If nOpt <> 4 .Or. (nOpt = 4 .And. AllTrim(SA1->A1_XTIPCLI) $ cMvTpCli) 
		//Conout("GENI018 - Execauto de Cliente" )
		MSExecAuto({|x,y| Mata030(x,y)},_aClient,nOpt)
	EndIf
	
	//REMOVE ASPAS SIMPLES DO CADASTRO DE CLIENTE E FORNECEDOR
	tcsqlexec("update SA1000 set A1_NOME = upper(replace(A1_NOME,'''',' ')), A1_NREDUZ = upper(replace(A1_NREDUZ,'''',' ')) where A1_NOME like '%''%' or A1_NREDUZ like '%''%'")
	tcsqlexec("update SA2000 set A2_NOME = upper(replace(A2_NOME,'''',' ')), A2_NREDUZ = upper(replace(A2_NREDUZ,'''',' ')) where A2_NOME like '%''%' or A2_NREDUZ like '%''%'")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso tenha entrado na rotina de execauto de cliente e não der erro³
	//³irá prosseguir para a importação do pedido de vendas              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lMsErroAuto
		
		If nOpt <> 3
			SA1->(dbGoTo(nRec))
		Endif
		
		aAdd ( _aCabPd , { "C5_CLIENTE"	, SA1->A1_COD	, NIL} )
		aAdd ( _aCabPd , { "C5_LOJACLI"	, SA1->A1_LOJA	, NIL} )
		aAdd ( _aCabPd , { "C5_CLIENT"	, SA1->A1_COD	, NIL} )
		aAdd ( _aCabPd , { "C5_LOJAENT"	, SA1->A1_LOJA	, NIL} )
		aAdd ( _aCabPd , { "C5_TIPOCLI"	, SA1->A1_TIPO	, NIL} )
		aAdd ( _aCabPd , { "C5_VEND1"	, SA1->A1_VEND	, NIL} )
		
		//aAdd ( _aCabPd , { "C5_MENNOTA" , "ENVIO GRATIS EM SUBSTITUICAO PEDIDO EXTRAVIADO NO CORREIO." , NIL} )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ordenando o vetor conforme estrutura da SX3, pois      ³
		//³alguns execauto`s realizam valida;'oes de gatilhos     ³
		//³o que pode acabar matando uma informa;'ao obrigat[oria ³
		//³que ja havia sido enviada corretamente no array        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSC5SX3 := FWSX3Util():GetAllFields( "SC5", .F. )
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SC5")
		//While !EOF() .And. (SX3->X3_ARQUIVO == "SC5")
		For nSC5 := 1 To Len(aSC5SX3)
			For _ni := 1 To Len(_aCabPd)
				If AllTrim(aSC5SX3[nSC5]) == Alltrim(_aCabPd[_ni][1])
					aAdd(_aAcabC5,_aCabPd[_ni])
					Exit
				EndIf
			Next _ni
			
			dbSelectArea("SX3")
		//	dbSkip()
		//EndDo
		 Next nSC5
		//Conout("GENI018 - Execauto de Pedido de Vendas")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicio a gravação (Execauto) do pedido de vendas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		DbSelectArea("SC5")
		DbSelectArea("SC6")
		DbSelectArea("SB1")
		
		lMsErroAuto := .F.
		_cPedExc := ""
		
		Conout("GENI018 - Inicio - MSExecAuto - mata410 - "+DtoS(DDatabase)+" - "+Time())
		
		MSExecAuto({|x,y,z| mata410(x,y,z)},_aAcabC5,_aItmPd,3)
		_cPedExc := SC5->C5_NUM
		
		Conout("GENI018 - Fim - MSExecAuto - mata410 - "+DtoS(DDatabase)+" - "+Time())
		
		If !lMsErroAuto
			_cParcela := ""
			For _nI := 1 To Len(_aParcItem)			
				_cParcela := If(_nI == 1,cParc1,Soma1(_cParcela))
																			
				RecLock("SCV",.T.)
				SCV->CV_FILIAL  := xFilial("SCV")
				SCV->CV_PEDIDO  := SC5->C5_NUM
				SCV->CV_FORMAPG := "CC"
				SCV->CV_DESCFOR := Posicione("SX5",1,xFilial("SX5")+"24"+"CC","X5_DESCRI")
				SCV->CV_XPEDOLD := SC5->C5_XPEDOLD
				SCV->CV_XPARCEL := _cParcela
				SCV->CV_XOPERA  := _aParcItem[_nI,3]
				SCV->CV_XNSUTEF := _aParcItem[_nI,4]					
				SCV->CV_XBANDEI := UPPER(_aParcItem[_nI,5])
				MsUnLock()					
			Next		
		EndIf
					
		If !lMsErroAuto .and. lGeraNF .AND. SC5->C5_BLQ <> "4"
	
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
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
				//³Rotina para desbloquear crédito para que o pedido seja faturado sem problemas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
				//Posiciona na SC9 para confirmar que o pedido foi gravado na tabela
				DbSelectArea("SC9")
				DbSetOrder(1)
   
				//Posiciona na SC9 para confirmar que o pedido foi gravado na tabela
				If !DbSeek(xFilial("SC9") + SC5->C5_NUM) .AND. Empty(SC5->C5_BLQ)
					SC6->(DbSetOrder(1))
					SC6->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
					While SC6->(!EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
						
						If !SC9->(dbseek( SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM ))
							/*
							±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±							
							±±³Parametros³ExpN1: Registro do SC6                                      ³±±
							±±³          ³ExpN2: Quantidade a Liberar                                 ³±±
							±±³          ³ExpL3: Bloqueio de Credito                                  ³±±
							±±³          ³ExpL4: Bloqueio de Estoque                                  ³±±
							±±³          ³ExpL5: Avaliacao de Credito                                 ³±±
							±±³          ³ExpL6: Avaliacao de Estoque                                 ³±±
							±±³          ³ExpL7: Permite Liberacao Parcial                            ³±±
							±±³          ³ExpL8: Tranfere Locais automaticamente                      ³±±
							±±³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
							±±³          ³       apenas avalia ).                                    ³±±
							±±³          ³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³±±
							±±³          ³ExpAB: Array com Empenhos previamente escolhidos            ³±±
							±±³          ³       (impede selecao dos empenhos pelas rotinas)          ³±±
							±±³          ³ExpLC: Indica se apenas esta trocando lotes do SC9          ³±±
							±±³          ³ExpND: Valor a ser adicionado ao limite de credito          ³±±
							±±³          ³ExpNE: Quantidade a Liberar - segunda UM                    ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Observacao³Deve estar numa transacao                                   ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³          ³               ³                                           ³±±
							±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
							±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
							ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
							Function MaLibDoFat(nRegSC6,nQtdaLib,lCredito,lEstoque,lAvCred,lAvEst,lLibPar,lTrfLocal,aEmpenho,bBlock,aEmpPronto,lTrocaLot,lOkExpedicao,nVlrCred,nQtdalib2)
							/*/
																										
							RecLock("SC6",.F.)
							SC6->C6_QTDLIB := MaLibDoFat(SC6->(Recno()),SC6->C6_QTDVEN,.T.,.T.,.F.,.T.,.F.)
							SC6->(msUnlock())
						EndIf	

						SC6->(DbSkip())
					EndDo						
				EndIf				
				
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
							//a450Grava(1,.T.,.T.,.F.) // ALTERADO POR CLEUTO EM 13/04/2017 - VIVAZ 32105 - PARA NÃO FORÇAR A LIBERAÇÃO DE ESTOQUE
							//a450Grava(1,.T.,.F.,.F.) // ALTERADO POR CLEUTO EM 05/05/2017 - VIVAZ 34311 - PARA FORÇAR A LIBERAÇÃO DE ESTOQUE POIS OS PEDIDOS ESTÃO FICANDO PARADOS DEVIDO AO CAMPO B2_QTNP
							a450Grava(1,.T.,.T.,.F.)
						Else
							_cErroLg := "Recno nao encontrado na SC9. Verifique se o pedido foi corretamente faturado. Recno SC9: " + cvaltochar((_cAliSC9)->SC9RECNO)
							MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+ ".txt" , _cErroLg )
						EndIf
						(_cAliSC9)->(DbSkip())
					EndDo
				Else
					WFForceDir(_cLogPd + DtoS(DDataBase) +"\")
					_cErroLg := "Pedido não localizado na SC9. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC5->C5_NUM
					MemoWrite ( _cLogPd + DtoS(DDataBase) +"\" + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+SC5->C5_NUM+".txt" , _cErroLg )
					
					cMsg := SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+SC5->C5_NUM+cEnt+_cErroLg
					
					U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br"),oemtoansi("Protheus Faturamento - Importação Pedido Web"),cMsg,,,.F.)
				EndIf

				IF SC5->C5_LIBEROK <> "S"
					Begin Transaction
						MaLiberOk({SC5->C5_NUM},.F.)
					End Transaction	

					IF SC5->C5_LIBEROK <> "S"			
						RecLock("SC5",.F.)
						SC5->C5_LIBEROK := "S"					
						MsUnLock()
						cMsg	:= "Pedido: "+SC5->C5_NUM+", campo C5_LIBEROK foi atualizado via RECLOCK."
						U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br"),oemtoansi("Protheus Faturamento - Importação Pedido Web"),cMsg,,,.F.)					
					ENDIF
				ENDIF
				/*-------------------------------------------------------
				INCLUSÃO DE ROTINA PARA GERAÇÃO  DE NOTA NO FATURAMENTO
				---------------------------------------------------------*/
				
				// *'-----------------------------------------------------------------------------------------------------'*
				// *'Inicio - Caso tenha ocorrido com sucesso a geração do Pedido de Vendas, irá iniciar a geração da Nota'*
				// *'-----------------------------------------------------------------------------------------------------'*
				
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
								MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+ ".txt" , _cErroLg )
								SC9->(DBSKIP())
							Endif
						Else
							_cErroLg := "Pedido com itens SC9 não liberado. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC9->C9_PEDIDO + " Item: " + SC9->C9_ITEM
							MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+ ".txt" , _cErroLg )
							SC9->(DBSKIP())
						Endif
					EndDo
					
					//CONOUT("GENA006 - REALIZANDO A GERACAO DA NOTA ")
					
					*'------------------------------------------------'*
					*'Rotina utilizada para realizar a geração da Nota'*
					*'------------------------------------------------'*
					// 28/07/2016 - Rafael Leite - Desabilitada geração do documento de saida por causa do Protheus Integração Faturamento Protheus x WMS
					//If Empty(_cErroLg) .and. _lVwWeb
					
					If Empty(_cErroLg) ;
					.and. _lVwWeb ;
					.and. ( Getmv("GEN_FAT114") .OR. (lDigital .AND. AllTrim(_cMvSeri) == "2" ))//parametro de controle de execucao
					
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
							U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br"),oemtoansi("Protheus - Importação WEB"),oemtoansi(_cErroLg),,,.F.)
							
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
									U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br"),oemtoansi("Protheus - Importação WEB"),oemtoansi(_cErroLg),,,.F.)
								EndIf
								_cNotaImp := ""
							Else
								_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. Não foi possível encontrar o registro na SF2 para exclusão. Efetue o procedimento manualmente assim que possível."
								conout("GENI018 - "+_cErroLg)
								U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br"),oemtoansi("Protheus - Importação WEB"),oemtoansi(_cErroLg),,,.F.)
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
									MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+ ".txt" , _cErroLg )
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
									MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+ ".txt" , _cErroLg )
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
								MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL)+ "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+ ".txt" , _cErroLg )
							EndIf
						EndIf
					EndIf
				EndIf
				
				/*-------------------------------------------------------
				FIM DA ROTINA PARA GERAÇÃO  DE NOTA NO FATURAMENTO
				---------------------------------------------------------*/
			Else
				cMsg := "GENI018 - IMPORTAÇÃO PEDIDO WEB" + cEnt
				cMsg += cEnt
				cMsg += "O Pedido " + SC5->C5_NUM + " com TES PAI diferentes e não vai gerar documento de saída." + cEnt
				U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br"),oemtoansi("Protheus Faturamento - Importação Pedido Web"),cMsg,,,.F.)
			EndIf
		ElseIf SC5->C5_BLQ	 == "4"
		        /*
				SC6->(DbSetOrder(1)) 
				SC6->(DbSeek( SC5->C5_FILIAL+SC5->C5_NUM ))
				While SC6->(!EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
					
					SC9->(DbSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))
					While SC9->(!Eof()) .and. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == SC6->(C6_FILIAL+C6_NUM+C6_ITEM)
						SC9->(a460Estorna())
						SC9->(DbSkip())
					Enddo
					
					SC6->(DbSkip())
		        EndDo
		        */
				cMsg := "GENI018 - IMPORTAÇÃO PEDIDO WEB" + cEnt
				cMsg += cEnt
				cMsg += "O Pedido " + SC5->C5_NUM + " foi bloqueado por black list." + cEnt
				U_GenSendMail(,,,"noreply@grupogen.com.br",_cMailBlk,oemtoansi("Protheus Faturamento - Importação Pedido Web"),cMsg,,,.F.)			
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
		Next _ni
		
		MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+ ".txt" , _cErroLg )
		Disarmtransaction()
	EndIf
//EndIf

If Select(_cArqPd) > 0
	dbSelectArea(_cArqPd)
	(_cArqPd)->(dbCloseArea())
EndIf

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI018   ºAutor  ³Microsiga           º Data ³  11/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
User Function GENI018P(_aCabPd,_cPedOld,cFORMAPG,_nTotParc,_cMsg,nVldValPd,_cPedWeb,cOrigem,nIdPgt)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da rotina.                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea	   		:= GetArea()
Local aParcCC_A		:= {}
Local aParcCC_B		:= {}
Local _cGENESB		:= GetNextAlias()
Local _dDataPGT		:= CTOD(SPACE(8))
Local _cNSUTEF 		:= ""
Local _cBandeira	:= ""
Local _cCondPgto	:= ""
Local _cOper		:= ""
Local _lBoleto		:= .T.
Local _nPosFre      := 0
Local _cPgt1Web		:= GETMV("GEN_PG1WEB")
Local _aParcCart	:= {}      
Local nChecVal		:= 0
Local cSqlAuxA		:= ""
Local cSqlAuxB		:= ""
Local cSqlAuxC		:= ""
Local nAuxPg		:= 0
Local _nI			:= 0
Local nValTotal		:= _nTotParc
Local aParcelas		:= {}
Local nLenPC		:= 0
Local nAuxPc		:= 0
Local nTotCartao	:= 0
Local nPrcCC_A		:= 0
Local nPrcCC_B		:= 0
Local lRecorrencia	:= .F.
Local nAuxRec 		:= 0
Local nRecIni		:= 0
Local nQtdMaxRecor	:= 12

Default _cPedOld	:= ""
Default _cMsg		:= ""
Default cFORMAPG	:= ""
Default _aCabPd		:= {}
Default nVldValPd	:= 0
Default cOrigem		:= ""
Default nIdPgt		:= 0

If !Empty(cOrigem)
	cSqlAuxA		:= "% 'LEGADO' = '"+cOrigem+"' %"
	cSqlAuxB		:= "% 'SITE' = '"+cOrigem+"' %"
	cSqlAuxC		:= "% 'FORUM' = '"+cOrigem+"' %"
Else
	cSqlAuxA		:= "% 1 = 1 %"
	cSqlAuxB		:= "% 1 = 1 %"	
	cSqlAuxC		:= "% 1 = 1 %"	
EndIf

If Empty(_cPedOld)
	_cMsg	:= "Pedido Old não informado!"
	Return aParcCC_A
EndIf

If Len(_aCabPd) == 0
	_cMsg	:= "Cabeçalho do pedido não informado!"
	Return aParcCC_A
EndIf

If ASCAN(_aCabPd,{|X|  X[1] == "C5_FRETE" }) == 0
	_cMsg	:= "Campo frete (C5_FRETE) não localizado no cabeçalho do pedido!"
	Return aParcCC_A
EndIf

If _nTotParc == 0
	_cMsg	:= "Valor total a ser parcelado igual a zero!"
	Return aParcCC_A
EndIf

/* removido legado do antigo site GEN
	SELECT 
		  NVL(PG.PARCELAMENTO,1) PARCELA,		  
		  PG.OPERADORA OPERADORA, 
		  trim(TO_CHAR(PG.DATA_STATUS, 'yyyymmdd')) DT_PGT,
		  PG.TID TID,           
		  PG.NSU NSU,
		  BANDEIRA,
		  0 VALOR_1,

		  0 PARCELA_2,
		  ' ' OPERADORA2, 
		  trim(TO_CHAR(PG.DATA_STATUS, 'yyyymmdd')) DT_PGT_2,
		  ' ' TID,
		  ' ' NSU_2,
		  ' ' BANDEIRA_2,
		  0 VALOR_2

		  FROM GENESB.PAGAMENTO PG
		  JOIN GENESB.PEDIDO PD
		  ON PD.ENTITY_ID = PG.PEDIDO_ENTITY_ID
		WHERE PG.TIPO_PAGAMENTO = 'C' 
			AND TO_number(PD.NUMERO) = %exp:_cPedWeb%
			AND PG.PEDIDO_ENTITY_ID = %exp:_cPedOld% AND
			%Exp:cSqlAuxA%
	UNION
*/

BeginSql Alias _cGENESB
	SELECT /*PG.VALOR VALOR_PAGAMENTO, //removido pois não existe na produção */
		  NVL(PG.PARCELAMENTO_1,1) PARCELA,		  
		  PG.OPERADORA_1 OPERADORA, 
		  trim(TO_CHAR(PG.DATA_STATUS, 'yyyymmdd')) DT_PGT,
		  ' ' TID,           
		  CASE WHEN TRIM(PG.NSU_1) = '143000' OR TRIM(PG.NSU_1) IS NULL  THEN TO_CHAR(PG.PEDIDO_ENTITY_ID) ELSE PG.NSU_1 END  NSU,
		  BANDEIRA_1 BANDEIRA,
		  VALOR_1,

		  NVL(PG.PARCELAMENTO_2,1) PARCELA_2,
		  PG.OPERADORA_2 OPERADORA2, 
		  trim(TO_CHAR(PG.DATA_STATUS, 'yyyymmdd')) DT_PGT_2,
		  ' ' TID,           
		  PG.NSU_2 NSU_2,
		  BANDEIRA_2,
		  VALOR_2,
		  '0' RECORRENTE,
		  'N' ABRE_RECO
 		  FROM GENESB.PAGAMENTO_NOVO PG
		  JOIN GENESB.PEDIDO_NOVO PD
		  ON PD.ENTITY_ID = PG.PEDIDO_ENTITY_ID
		WHERE PG.TIPO_PAGAMENTO = 'C' 
			AND TO_number(PD.NUMERO) = %exp:_cPedWeb%
			AND PG.PEDIDO_ENTITY_ID = %exp:_cPedOld% AND
			%Exp:cSqlAuxB%	
	UNION
		  SELECT /*PG.VALOR VALOR_PAGAMENTO, //removido pois não existe na produção */
		  NVL(PG.PARCELAMENTO_1,1) PARCELA,		  
		  PG.OPERADORA_1 OPERADORA, 
		  trim(TO_CHAR(PG.DATA_STATUS, 'yyyymmdd')) DT_PGT,
		  ' ' TID,           
		  PG.NSU_1 NSU,
		  BANDEIRA_1 BANDEIRA,
		  VALOR_1,

		  NVL(PG.PARCELAMENTO_2,1) PARCELA_2,
		  PG.OPERADORA_2 OPERADORA2, 
		  trim(TO_CHAR(PG.DATA_STATUS, 'yyyymmdd')) DT_PGT_2,
		  ' ' TID,           
		  PG.NSU_2 NSU_2,
		  BANDEIRA_2,
		  VALOR_2,
	      RECORRENTE,
		  'N' ABRE_RECO
		  FROM GENESB.PAGAMENTO_NOVO_FORUM PG
		  JOIN GENESB.PEDIDO_NOVO_FORUM PD
		  ON PD.ENTITY_ID = PG.PEDIDO_ENTITY_ID
		WHERE PG.TIPO_PAGAMENTO = 'C' 
			AND TO_number(PD.NUMERO) = %exp:_cPedWeb%
			AND PG.PEDIDO_ENTITY_ID = %exp:_cPedOld%
			AND ( NVL(PG.NUM_PARCELA,0) = %exp:nIdPgt% OR RECORRENTE <> '1') AND
			%Exp:cSqlAuxC%	
	UNION
		  SELECT /*PG.VALOR VALOR_PAGAMENTO, //removido pois não existe na produção */
		  NVL(PG.PARCELAMENTO_1,1) PARCELA,		  
		  PG.OPERADORA_1 OPERADORA, 
		  trim(TO_CHAR(PG.DATA_STATUS, 'yyyymmdd')) DT_PGT,
		  ' ' TID,           
		  PG.NSU_1 NSU,
		  BANDEIRA_1 BANDEIRA,
		  VALOR_1,

		  NVL(PG.PARCELAMENTO_2,1) PARCELA_2,
		  PG.OPERADORA_2 OPERADORA2, 
		  trim(TO_CHAR(PG.DATA_STATUS, 'yyyymmdd')) DT_PGT_2,
		  ' ' TID,           
		  PG.NSU_2 NSU_2,
		  BANDEIRA_2,
		  VALOR_2,
          RECORRENTE,
		  'S' ABRE_RECO
		  FROM GENESB.PAGAMENTO_NEW_FORUM PG
		  JOIN GENESB.PEDIDO_NEW_FORUM PD
		  ON PD.ENTITY_ID = PG.PEDIDO_ENTITY_ID
		WHERE PG.TIPO_PAGAMENTO = 'C' 
			AND TO_number(PD.NUMERO) = %exp:_cPedWeb%
			AND PG.PEDIDO_ENTITY_ID = %exp:_cPedOld%
			AND ( NVL(PG.NUM_PARCELA,0) = %exp:nIdPgt% OR RECORRENTE <> '1') AND
			%Exp:cSqlAuxC%					 			
EndSql

_lBoleto	:= (_cGENESB)->(Eof())
nTotCartao	:= (_cGENESB)->VALOR_1+(_cGENESB)->VALOR_2
nPrcCC_A	:= (_cGENESB)->VALOR_1/nTotCartao
nPrcCC_B	:= (_cGENESB)->VALOR_2/nTotCartao

/*
// Ajustando o valor de ultima parcela caso tenha alguma diferença de arredondamento
If nVldValPd > 0 .AND. !_lBoleto
	
	If _nTotParc > nVldValPd
		 _nTotParc := A410Arred(_nTotParc-(_nTotParc-nVldValPd) , "C6_VALOR" )
	EndIf
		
EndIf
*/			
If _lBoleto //BOLETO

	cFORMAPG	:= "B"
	/*
	_nPosFre	:= ASCAN(_aCabPd,{|X|  X[1] == "C5_FRETE" })									
	_nTotParc	:= _nTotParc + _aCabPd[_nPosFre,2]
			
	_aParcCart	:= Condicao(_nTotParc,"001",,DDataBase)
	For _nI := 1 To Len(_aParcCart)
		Aadd(aParcCC_A,{_aParcCart[_nI,1],_aParcCart[_nI,2],_cOper,_cNSUTEF,_cBandeira}) 
	Next
	*/		
Else //CARTAO
	lRecorrencia	:= (_cGENESB)->RECORRENTE == '1' .AND. (_cGENESB)->ABRE_RECO == 'S'
	cFORMAPG		:= "C"

	While (_cGENESB)->(!Eof())
	
		If Empty((_cGENESB)->NSU)
			_cMsg := "Para pagamento com carto e obrigatorio informado o NSU"
			Exit
		EndIf
		
		cPcAux	:= "0"
		For nAuxPg := 1 To (_cGENESB)->PARCELA
			cPcAux := Soma1(cPcAux)						
		Next
	
		_cCondPgto := "WB"+cPcAux
		If !( _cCondPgto $ _cPgt1Web )		
			_cMsg := "Pedido com a Cond.Pagto tipo Cartao: "+_cCondPgto+" nao cadastrada no parametro (GEN_PG1WEB)"
			Exit
		EndIf
		
		_nPosFre   := ASCAN(_aCabPd,{|X|  X[1] == "C5_FRETE" })									
		nValTotal  := (_nTotParc*nPrcCC_A) + _aCabPd[_nPosFre,2]
		_dDataPGT  := STOD((_cGENESB)->DT_PGT)+1 // +1 pois o protheus está considerando a data do pagamento como dia inicial para o calulo das parcelas ficando com 1 dia a menos em relação as datas da acesstage
		_cOper     := (_cGENESB)->OPERADORA
		_cNSUTEF   := (_cGENESB)->NSU
		_cBandeira := (_cGENESB)->BANDEIRA
		_aParcCart := Condicao(nValTotal,_cCondPgto,,_dDataPGT)
		cPcAux		:= "0"
		For _nI := 1 To Len(_aParcCart)
			cPcAux := Soma1(cPcAux)
			Aadd(aParcCC_A,{_aParcCart[_nI,1],_aParcCart[_nI,2],_cOper,_cNSUTEF,_cBandeira,cPcAux}) 
		Next

		//*********************** Parcelamento com segundo cartão ***********************
		IF !Empty((_cGENESB)->NSU_2)

			cPcAux	:= "0"
			For nAuxPg := 1 To (_cGENESB)->PARCELA_2
				cPcAux := Soma1(cPcAux)						
			Next
		
			_cCondPgto := "WB"+cPcAux
			If !( _cCondPgto $ _cPgt1Web )		
				_cMsg := "Pedido com a Cond.Pagto tipo Cartao: "+_cCondPgto+" nao cadastrada no parametro (GEN_PG1WEB)"
				Exit
			EndIf

			nValTotal  := (_nTotParc*nPrcCC_B)
			_dDataPGT  := STOD((_cGENESB)->DT_PGT_2)+1 // +1 pois o protheus está considerando a data do pagamento como dia inicial para o calulo das parcelas ficando com 1 dia a menos em relação as datas da acesstage
			_cOper     := (_cGENESB)->OPERADORA2
			_cNSUTEF   := (_cGENESB)->NSU_2
			_cBandeira := (_cGENESB)->BANDEIRA_2
			_aParcCart := Condicao(nValTotal,_cCondPgto,,_dDataPGT)
			cPcAux		:= "0"
			For _nI := 1 To Len(_aParcCart)
				cPcAux := Soma1(cPcAux)
				Aadd(aParcCC_B,{_aParcCart[_nI,1],_aParcCart[_nI,2],_cOper,_cNSUTEF,_cBandeira,cPcAux}) 
			Next
			
		ENDIF	
		//********************************************************************************

		 (_cGENESB)->(DbSkip())
	EndDo		


	// Ajustando o valor de ultima parcela caso tenha alguma diferença de arredondamento
	If nVldValPd > 0 .AND. Len(aParcCC_A) > 1

		aEval(aParcCC_A, {|x| nChecVal+=x[2] } )
		
		If nChecVal < nVldValPd
			aParcCC_A[Len(aParcCC_A)][2] := A410Arred(aParcCC_A[Len(aParcCC_A)][2]+(nVldValPd-nChecVal) , "C6_VALOR" )
		EndIf

		If nChecVal > nVldValPd
			aParcCC_A[Len(aParcCC_A)][2] := A410Arred(aParcCC_A[Len(aParcCC_A)][2]-(nChecVal-nVldValPd) , "C6_VALOR" )
		EndIf
		
	EndIf

	// Ajustando o valor de ultima parcela caso tenha alguma diferença de arredondamento
	If nVldValPd > 0 .AND. Len(aParcCC_B) > 1

		aEval(aParcCC_B, {|x| nChecVal+=x[2] } )
		
		If nChecVal < nVldValPd
			aParcCC_B[Len(aParcCC_B)][2] := A410Arred(aParcCC_B[Len(aParcCC_B)][2]+(nVldValPd-nChecVal) , "C6_VALOR" )
		EndIf

		If nChecVal > nVldValPd
			aParcCC_B[Len(aParcCC_B)][2] := A410Arred(aParcCC_B[Len(aParcCC_B)][2]-(nChecVal-nVldValPd) , "C6_VALOR" )
		EndIf
		
	EndIf

	//********************************************************************************************************************************************************
	// unifico as parcelas de ambos os cartões
	nLenPC	:= Len(aParcCC_A)
	IF Len(aParcCC_B) > nLenPC
		nLenPC := Len(aParcCC_B)
	ENDIF

	cPcAux	:= "0"
	For nAuxPc := 1 To nLenPC				
		IF Len(aParcCC_A) >= nAuxPc
			cPcAux := Soma1(cPcAux)
			Aadd(aParcelas, { aParcCC_A[nAuxPc][1], aParcCC_A[nAuxPc][2], aParcCC_A[nAuxPc][3], aParcCC_A[nAuxPc][4], aParcCC_A[nAuxPc][5], cPcAux } )
		ENDIF
		IF Len(aParcCC_B) >= nAuxPc
			cPcAux := Soma1(cPcAux)
			Aadd(aParcelas, { aParcCC_B[nAuxPc][1], aParcCC_B[nAuxPc][2], aParcCC_B[nAuxPc][3], aParcCC_B[nAuxPc][4], aParcCC_B[nAuxPc][5], cPcAux } )
		ENDIF		
	Next
	//********************************************************************************************************************************************************

EndIf

(_cGENESB)->(DbCloseArea())


/*
Cleuto - 16/11/2020 
Quando recorrencia verifico se todas as parcelas da recorrencia existem
*/
IF lRecorrencia
	IF Select("TMP_RECOR") > 0
		TMP_RECOR->(DBCLOSEAREA())
	ENDIF

	BeginSql Alias "TMP_RECOR"
		SELECT COUNT(*) QTD
			FROM GENESB.PAGAMENTO_NEW_FORUM PG
			JOIN GENESB.PEDIDO_NEW_FORUM PD
			ON PD.ENTITY_ID = PG.PEDIDO_ENTITY_ID
		WHERE PG.TIPO_PAGAMENTO = 'C' 
			AND TO_number(PD.NUMERO) = %exp:_cPedWeb%
			AND PG.PEDIDO_ENTITY_ID = %exp:_cPedOld%
			AND PG.RECORRENTE = '1'
	EndSql

	IF TMP_RECOR->QTD < nQtdMaxRecor
		BEGIN TRANSACTION
			nRecIni := TMP_RECOR->QTD+1

			For nAuxRec := nRecIni To nQtdMaxRecor
				cInsert := " INSERT INTO GENESB.PAGAMENTO_NEW_FORUM (PEDIDO_ENTITY_ID,TIPO_PAGAMENTO, CODIGO_CUPOM, REGRAS_PROMOCIONAIS, BANDEIRA_1, PARCELAMENTO_1, OPERADORA_1, NSU_1, VALOR_1, BANDEIRA_2, PARCELAMENTO_2, OPERADORA_2, NSU_2, VALOR_2, STATUS, DATA_PAGAMENTO, DATA_STATUS, ACK, STATUS_PAGAMENTO, STATUS_TRANSACAO, FORMA_PAGAMENTO, TIPO_PAGAMENTO_GER, RECORRENTE, NUM_PARCELA)"
				cInsert += " SELECT PEDIDO_ENTITY_ID,TIPO_PAGAMENTO, CODIGO_CUPOM, REGRAS_PROMOCIONAIS, BANDEIRA_1, PARCELAMENTO_1, OPERADORA_1, NSU_1, VALOR_1, BANDEIRA_2, PARCELAMENTO_2, OPERADORA_2, NSU_2, VALOR_2, STATUS, ADD_MONTHS(DATA_PAGAMENTO,"+CVALTOCHAR( nAuxRec-1 )+") DATA_PAGAMENTO, ADD_MONTHS(DATA_PAGAMENTO,"+CVALTOCHAR( nAuxRec-1 )+") DATA_STATUS, ACK, STATUS_PAGAMENTO, STATUS_TRANSACAO, FORMA_PAGAMENTO, TIPO_PAGAMENTO_GER, RECORRENTE, "+CVALTOCHAR( nAuxRec )+" NUM_PARCELA FROM GENESB.PAGAMENTO_NEW_FORUM A
				cInsert += " WHERE PEDIDO_ENTITY_ID = "+_cPedOld+" AND NUM_PARCELA = 1 "
				cInsert += " AND NOT EXISTS(
				cInsert += "   SELECT 1 FROM GENESB.PAGAMENTO_NEW_FORUM B
				cInsert += "   WHERE A.PEDIDO_ENTITY_ID = B.PEDIDO_ENTITY_ID
				cInsert += "   AND B.NUM_PARCELA = "+CVALTOCHAR( nAuxRec )
				cInsert += " )

				If (TCSqlExec(cInsert) < 0)
					Disarmtransaction()
					Memowrite(cLogPd,"TCSQLError()" + TCSQLError())
					cMsg += "GENI018 - Erro ao tentar gravar a recorencia para o pedido "+_cPedWeb
					U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("Protheus GENI018 - Grava recorrenia"),cMsg,,,.F.)
				EndIf
			Next
			
		END TRANSACTION
	ENDIF		

	TMP_RECOR->(DBCLOSEAREA())
ENDIF

RestArea(aArea)
	
Return aParcelas


// copia da rotina padrão A410Tipo9()

User Function GENI018C()

Local aArea     := GetArea()
Local aAreaSE4  := SE4->(GetArea())

Local cParcela  := "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0"
Local cMv1Dup   := GetMV( "MV_1DUP" )
Local dParc     := Ctod("")
Local nParc     := 0
Local nAux      := 0
Local nTotLib9  := 0
Local nTot9     := 0
Local nTotal    := 0
Local nQtdLib   := 0
Local nQtdVen   := 0
Local nValor    := 0
Local nOrder    := IndexOrd() 
Local nY        := 0 
Local nX        := 0     
Local nMaxTipo9 := 26     
Local nParcelas := SuperGetMv("MV_NUMPARC")

Local lRet      :=.T.
Local lIPI      := (GetMV("MV_IPITP9") == "S")
Local lMt410Parc:= Existblock("MT410PC")
Local lParc     := .T.

	
	For nX := 1 to Len(aCols)
		If !aCols[nx][Len(aCols[nx])]
			For ny := 1 to Len(aHeader)
				If Trim(aHeader[ny][2]) == "C6_QTDVEN"
					nQtdVen := aCols[nx][ny]
				ElseIf Trim(aHeader[ny][2]) == "C6_QTDLIB"
					nQtdLib := aCols[nx][ny]
				ElseIf Trim(aHeader[ny][2]) == "C6_VALOR"
					nValor := aCols[nx][ny] 
				EndIf
			Next ny
			
			nTotal   +=  nValor
			nTotLib9 +=  nQtdLib
			nTot9    +=  nQtdVen
		EndIf
	Next nX
	
	nTotal := nTotal + M->C5_FRETE + M->C5_DESPESA + M->C5_SEGURO + M->C5_FRETAUT
	
	// permite que o numero de parcela possa se manipulado por customização, independente do parametro
	If lMt410Parc
		nParcelas := Execblock("MT410PC",.F.,.F.)
	Endif
	
	For nX:=1 to nParcelas
		nParc := &("M->C5_PARC"+Substr(cParcela,nx,1))
		dParc := &("M->C5_DATA"+Substr(cParcela,nx,1))
		If nParc > 0 .And. Empty(dParc)
			lParc := .F.
		EndIf
		nAux  += nParc
	Next nX
	
	If !lParc
		Help(" ",1,"A410TIPO9")		
		lRet := .F.		
	Else	
		dbSelectArea("SE4")
		dbSetOrder(1)
		If MsSeek(xFilial()+M->C5_CONDPAG)
			If SE4->E4_TIPO =="9"
				If AllTrim(SE4->E4_COND) = "0"
						
					If	( lIpi .And. NoRound(nTotal,2) > NoRound(nAux,2) ) .Or. ;
						( !lIpi .And. NoRound(nTotal,2) <> NoRound(nAux,2) )
						
						Help(" ",1,"A410TIPO9")

						If ( ExistBlock("A410VTIP") )
							lRet := ExecBlock("A410VTIP",.F.,.F.,{lRet})
							If ValType(lRet) <> "L"
								lRet := .F.
							EndIf							
						EndIf
						
						If SuperGetMV("MV_TIPO9SP",,.T.)	// Tipo 9 Sem Parcela informada
							If lRet
								If ( Type("l410Auto") == "U" .or. ! l410Auto )
									OpcQW:=MsgYesNo(OemToAnsi("Confirma a Inclusao do Pedido ?"),OemToAnsi("Aten‡„o"))  //"Confirma a Inclusao do Pedido ?"###"Aten‡„o"
									If !OpcQW 				// Abandona
										lRet := .F.
									EndIf
								EndIf
							EndIf  
						Else 
							lRet := .F.
						EndIf
					EndIf
				ElseIf AllTrim(SE4->E4_COND) = "%" .And. nAux # 100
					Help(" ",1,"A410TIPO9P")
					
					If ( ExistBlock("A410VTIP") )
						lRet := ExecBlock("A410VTIP",.F.,.F.,{lRet})
						If ValType(lRet) <> "L"
							lRet := .F.
						EndIf							
					EndIf
					
					If SuperGetMV("MV_TIPO9SP",,.T.)		// Tipo 9 Sem Parcela informada
						If lRet
							If ( Type("l410Auto") == "U" .or. ! l410Auto )
								OpcQW:=MsgYesNo(OemToAnsi("Confirma a Inclusao do Pedido ?"),OemToAnsi("Aten‡„o"))  //"Confirma a Inclusao do Pedido ?"###"Aten‡„o"
								If !OpcQW 				// Abandona
									lRet := .F.
								EndIf
							EndIf
						EndIf					
					Else 
						lRet := .F.
					EndIf
					
				EndIf
			EndIf
		EndIf
	EndIf	


RestArea(aAreaSE4)
RestArea(aArea)

Return lRet
