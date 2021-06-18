#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#DEFINE cEnt Chr(13)+Chr(10)

/*/                       
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI023   ºAutor  ³Angelo Henrique     º Data ³  30/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina utilizada para gerar a gravação dos pedidos de vendasº±±
±±º          ³Integração Pedido de Vendas - Protheus x Oracle(Legado)     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENI023()  

Local _aArea 	:= GetArea()
Local nX		:= 0
Local lCloseEmp	:= .F.

Private lDigital := .F.
Private lGeraNF := .T. //PARAMETRO PARA INDICAR SE DEVE GERAR A NOTA (.T.) OU SOMENTE O PEDIDO (.F.)

Conout("GENI023 - Inicio da importação de pedido de vendas de servicos")

If Type("cFilAnt") == "U"
	lCloseEmp	:= .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verificação para saber se a rotina esta sendo chamada pela Schedule³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Prepare Environment Empresa "00" Filial "1001"
EndIf

lExec := &(SuperGetMv("GENI023EX",.F.,".F."))
cExec := SuperGetMv("GENI023DT",.f.,DtoS(DDataBase))//DTOS(dDatabase)+" "+time()
lDiaAnt := substr(cExec,1,8) < DTOS(dDatabase)
lHoraAnt := val(strtran(elaptime(substr(cExec,10,8),time()),":","")) > 10000 //mais de 1 hora

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Semaforo.	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !LockByName("GENI023",.T.,.T.,.T.)
    nX++
	Sleep(10)
	If nX > 2
		Return .F.
    EndIf
EndDo
		
//If !lExec .or. (lExec .and. (lDiaAnt .or. lHoraAnt))
	If upper(alltrim(GetEnvServer())) $ "SCHEDULE-PRE" //EXECUTA SOMENTE NO AMBIENTE SCHEDULE
		PutMv("GENI023EX",".T.")
		PutMv("GENI023DT",DTOS(dDatabase)+" "+time())
		GENI023A()
		PutMv("GENI023EX",".F.")
	Endif
//Endif  

UnLockByName("GENI023",.T.,.T.,.T.)

If lCloseEmp
	Reset Environment
EndIf

RestArea(_aArea)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI023A  ºAutor  ³Angelo Henrique     º Data ³  11/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para o processamento da integração do pedido de vendaº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GENI023A()

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
Local _cNome		:= ""
Local cTesServ		:= SuperGetMv("GEN_FAT093",.f.,"564")
Local cTesEAlu    	:= SuperGetMv("GEN_FAT244",.f.,"543")
Local cTes   		:= ""
Local cDtValid     	:= ""

Local _nI           := 0
Local _nTotParc     := 0
Local _aParcItem	:= {}
Local _cPgt9Web		:= GETMV("GEN_PG9WEB")
Local cFORMAPG		:= ""
Local nVldValPd		:= 0
Local lBlqPed		:= .F.

Private _cQuery		:= ""
Private _cArqTmp	:= GetNextAlias()
Private _oServer	:= Nil
Private _cFilCont	:= ""
Private _cView		:= "" //Parâmetro que contém o nome da view que será consultada para a criação do Pedido de Vendas
Private _cLogPd		:= "" //Parâmetro que contém o caminho onde será gravado o arquivo de log de inconsistências
Private _aCabPd 	:= {}
Private _aItmPd 	:= {}
Private _alinha		:= {}

Private cNatCart	:= SuperGetMv("GENI023CAR",.f.,"") //NATUREZA PARA CARTAO DE CREDITO
Private cNatBol		:= SuperGetMv("GENI023BOL",.f.,"") //NATUREZA PARA BOLETO

_cView	:= SUPERGETMV("MV_XVIEDPD",.T.,"TT_I32_PEDIDOS_SERVICO") //Parâmetro que contém o nome da view que será consultada para a criação do Pedido de Vendas
_lVwWeb := alltrim(_cView) == "TT_I32_PEDIDOS_SERVICO" //"TT_I29_PEDIDOS_SATELITES"
//_cView	:= "DBA_EGK.TT_I29A_PEDIDOS_PDP" //PASTA DO PROFESSOR
//_cView	:= "DBA_EGK.TT_I29_PEDIDOS_ROUBADOS_ECT" //Parâmetro que contém o nome da view que será consultada para a criação do Pedido de Vendas
_cLogPd	:= "\logsiga\ped curso\" //SUPERGETMV("MV_XCAMLOG",.T.,"\logsiga\ped venda\") //Parâmetro que contém o caminho onde será gravado o arquivo de log de inconsistências

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executar limpeza dos logs³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
*************Cleuto Lima - 02/03/2016 - removida limpeza dos logs****************************

_aDir:=directory(Alltrim(_cLogPd)+"*")

For _ni:= 1 to Len(_aDir)
	fErase(Alltrim(_cLogPd)+_aDir[_ni][1])
Next _ni

************Cleuto Lima - 02/03/2016 - removida limpeza dos logs*****************************
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Conforme levantado será criado uma view disponibilizada no protheus ³
//³que irá conter todos os pedidos que deverão ser importados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//_cQuery := " SELECT * FROM TT_I29A_PEDIDOS_SATELITES" //+ _cView
_cQuery := "SELECT * FROM "+_cView
//_cQuery += " WHERE C5_XPEDOLD = '23991'"

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
	
	cChavCli := alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))
	
	Do While cChavCli == alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Validação da Trasnportadora, para não realizar o processamento³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (_cArqTmp)->DIGITAL <> 1
						
			_cMsg	:= "Obra não digital, não deve ser faturada pela rotina "+FunName()+", verifique a View "+_cView
						
			_cTipo   := IIF(ValType((_cArqTmp)->TIPO) == "N",cValtochar((_cArqTmp)->TIPO),(_cArqTmp)->TIPO)
			_cPedWeb := IIF(ValType((_cArqTmp)->C5_XPEDWEB) == "N",alltrim(str((_cArqTmp)->C5_XPEDWEB)),(_cArqTmp)->C5_XPEDWEB)
			_cPedOld := IIF(ValType((_cArqTmp)->C5_XPEDOLD) == "N",alltrim(str((_cArqTmp)->C5_XPEDOLD)),(_cArqTmp)->C5_XPEDOLD)
			
			/*
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
			*/
			
		Endif
		
		_cPedWeb := IIF(ValType((_cArqTmp)->C5_XPEDWEB) == "N",alltrim(str((_cArqTmp)->C5_XPEDWEB)),(_cArqTmp)->C5_XPEDWEB)
		
		/* < Valida pedido duplicado na GENESB.PEDIDO > */
		// Cleuto -12/06/2019 - temporario deve ser removido com OK do Rafael. 		
		If Empty(_cMsg)
			cMsgDupl	:= ""
			lBlqPed	:= .F.
			/* cleuto - 12/06/2019 - incluida validação de duplicidade do pedido, validação copiada da geni018 */
			_cQuery := ""
			_cQuery += " SELECT 1 POS, '0'  PEDIDO,Count(*) qtd,TOTAL, COBRANCA_NOME_RAZAO, COBRANCA_SOBRENOME_FANTAZIA, COBRANCA_CPF_CNPJ, ENTREGA_NOME, ENTREGA_BAIRRO, ENTREGA_UF, ENTREGA_MUNICIPIO_IBGE, ENTREGA_CEP, to_char(DATA_PEDIDO,'YYYYMMDD') DATA_PEDIDO, 0 EXISTE
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
			_cQuery += " )
			_cQuery += " GROUP BY TOTAL, COBRANCA_NOME_RAZAO, COBRANCA_SOBRENOME_FANTAZIA, COBRANCA_CPF_CNPJ, ENTREGA_NOME, ENTREGA_BAIRRO, ENTREGA_UF, ENTREGA_MUNICIPIO_IBGE, ENTREGA_CEP, to_char(DATA_PEDIDO,'YYYYMMDD')
			_cQuery += " HAVING COUNT(*) > 1
			_cQuery += " UNION ALL
			_cQuery += " SELECT 2 POS, NUMERO  PEDIDO,1 qtd,TOTAL, COBRANCA_NOME_RAZAO, COBRANCA_SOBRENOME_FANTAZIA, COBRANCA_CPF_CNPJ, ENTREGA_NOME, ENTREGA_BAIRRO, ENTREGA_UF, ENTREGA_MUNICIPIO_IBGE, ENTREGA_CEP, to_char(DATA_PEDIDO,'YYYYMMDD') DATA_PEDIDO,
			_cQuery += " ( SELECT COUNT(*) FROM " + RetSqlName("SC6") + " SC6 WHERE TRIM(C6_XPEDWEB) = TRIM(NUMERO) AND C6_PRODUTO = '"+Padr(alltrim((_cArqTmp)->C6_PRODUTO),tamsx3("C6_PRODUTO")[1])	+"' ) EXISTE
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
			_cQuery += " ) 
			_cQuery += " ORDER BY POS ASC
		
			If Select("TMP_PDWEB") > 0
				DbSelectArea("TMP_PDWEB")
				TMP_PDWEB->(dbCloseArea())
			EndIf
		
			DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), "TMP_PDWEB", .F., .T.)
			TMP_PDWEB->(DbGoTop())
			If TMP_PDWEB->POS == 1 .AND. TMP_PDWEB->QTD > 1
				cMsgDupl :=	"Possível duplicidade de Pedido do site Gen "+_cPedWeb+chr(13)+chr(10)+;
				"Sugerimos analise no magento e caso confirmada duplicidade efetue o procedimento de cancelamento"+chr(13)+chr(10)
				
				TMP_PDWEB->(DbSkip())
				While TMP_PDWEB->(!EOF()) 
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
			EndIf
			If !Empty(cMsgDupl)			
				U_GenSendMail(,,,"noreply@grupogen.com.br","ecommerce@grupogen.com.br;sac@grupogen.com.br;desenvolvimento@grupogen.com.br",oemtoansi("Site Gen - Pedido Duplicado"),cMsgDupl,,,.F.)
			EndIf	
		EndIf		
		/* </ Valida pedido duplicado na GENESB.PEDIDO > */

		
		If Empty(_cMsg)
			_cCod 		:= ""
			_aClient 	:= {}
			_cCodOld 	:= ""
			cOrigem	:= (_cArqTmp)->ORIGEM
			
			//-----------------------------------------//
			//Gravando em variável a nova filial logada//
			//-----------------------------------------//
			_cFilCont := AllTrim((_cArqTmp)->C5_FILIAL)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Processo de montagem do array para o execauto de cliente												   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//Conout("GENI023 - Montagem do Vetor de Clientes")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ajustes de alguns dados para a inclusão correta³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
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
			_cCodPs := STRZERO((_cArqTmp)->A1_CODPAIS,TAMSX3("A1_CODPAIS")[1])
			_cEndNm := IIF(Empty((_cArqTmp)->A1_XENDNUM),"0",AllTrim((_cArqTmp)->A1_XENDNUM))
			_cVend	:= IIF(ValType((_cArqTmp)->A1_VEND)=="C" ,STRZERO(Val((_cArqTmp)->A1_VEND),TAMSX3("A1_VEND")[1]),STRZERO((_cArqTmp)->A1_VEND,TAMSX3("A1_VEND")[1]))
			_cTpDes	:= IIF(ValType((_cArqTmp)->A1_VEND)=="C" ,(_cArqTmp)->A1_XTPDES,cValToChar((_cArqTmp)->A1_XTPDES))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³	VERIFICA SE JA EXISTE O CLIENTE COM MESMA RAIZ DE CNPJ CADASTRADO  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_cNome		:= upper(AllTrim((_cArqTmp)->A1_NOME))
			//VALIDA SE O CNPJ NAO ESTA PREENCHIDO COM '0' (ZERO)
			If SUBSTR(_cCGC,1,8) <> '00000000' .AND. !Empty(_cCGC)
				//Conout("GENI023 - Entrou na validação de CNPJ preenchido com ZERO")
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
					//Conout("GENI023 - Entrou na validação de adição de loja")
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
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gravação das Informações no Array que será enviado para o Execauto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_aClient := {}
			If !Empty(_cCod)
				//Conout("GENI023 - Colocando o código do cliente")
				aAdd(_aClient,{"A1_COD"	,	_cCod													,Nil})
				aAdd(_aClient,{"A1_LOJA",	_cLoja													,Nil})
			EndIf
			//Conout("GENI023 - Alimentando vetor Cliente")
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
			
			If Len(AllTrim(_cCGC)) == 11
				aAdd(_aClient,{"A1_RECPIS"	,	"N"	,Nil})
				aAdd(_aClient,{"A1_RECCOFI"	,	"N"	,Nil})
			Else
				aAdd(_aClient,{"A1_RECPIS"	,	"S"	,Nil})
				aAdd(_aClient,{"A1_RECCOFI"	,	"S"	,Nil})			
			EndIf	
			
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
			aAdd(_aClient,{"A1_LC"		,	(_cArqTmp)->A1_LC										,Nil}) //Limite de Crédito
			aAdd(_aClient,{"A1_BLEMAIL"	,	(_cArqTmp)->A1_BLEMAIL									,Nil}) //Boleto por Email
			aAdd(_aClient,{"A1_RISCO"	,	cRisc23													,Nil}) //Limite de Crédito
			
			_aCabPd  := {}
			_cPedOld := IIF(ValType((_cArqTmp)->C5_XPEDOLD) == "N",alltrim(str((_cArqTmp)->C5_XPEDOLD)),(_cArqTmp)->C5_XPEDOLD)
			_cCodOld := IIF(ValType((_cArqTmp)->A1_XCODOLD) == "N",alltrim(str((_cArqTmp)->A1_XCODOLD)),(_cArqTmp)->A1_XCODOLD)
			_cCodOld := PADR(_cCodOld,TAMSX3("A1_XCODOLD")[1]," ")
			
			//Rodrigo Mourão - 01/02/2015. Criadas variaveis Tipo e Pedido Web para incluir no nome do arquivo de log.
			_cTipo   := IIF(ValType((_cArqTmp)->TIPO) == "N",alltrim(str((_cArqTmp)->TIPO)),(_cArqTmp)->TIPO)			
			_cFilLog := Alltrim((_cArqTmp)->C5_FILIAL)
			
			//If (_cArqTmp)->DIGITAL <> 1
			//	_cTransp := IIF(ValType((_cArqTmp)->C5_TRANSP) == "N", (_cArqTmp)->C5_TRANSP, Val((_cArqTmp)->C5_TRANSP))
			//	_cTransp := IIF(_cTransp == 0, " ", STRZERO((_cArqTmp)->C5_TRANSP,TAMSX3("C5_TRANSP")[1]) )
			//	lDigital := .F.
			//	aAdd ( _aCabPd , { "C5_FRETE" 	, (_cArqTmp)->C5_FRETE 					, NIL} )
			//Else
				_cTransp := Space(TamSx3("C5_TRANSP")[1])
				lDigital := .T.
				aAdd ( _aCabPd , { "C5_FRETE" 	, 0				 						, NIL} )
			//Endif
			
			aAdd ( _aCabPd , { "C5_TIPO"    , "N"       					   			, NIL} )
			
			If "VENDA" $ _cTipo
				aAdd ( _aCabPd , { "C5_CONDPAG" , _cPgt9Web             					, NIL} )
			Else
				aAdd ( _aCabPd , { "C5_CONDPAG" , (_cArqTmp)->C5_CONDPAG   				, NIL} )
			EndIf	
			
			aAdd ( _aCabPd , { "C5_EMISSAO" , DDATABASE	   			, NIL} )
			aAdd ( _aCabPd , { "C5_XPEDOLD" , _cPedOld 									, NIL} )
			aAdd ( _aCabPd , { "C5_TPFRETE" , (_cArqTmp)->C5_TPFRETE 					, NIL} )
			aAdd ( _aCabPd , { "C5_MOEDA" 	, (_cArqTmp)->C5_MOEDA 						, NIL} )
			aAdd ( _aCabPd , { "C5_PESOL" 	, (_cArqTmp)->C5_PSOL 						, NIL} )
			aAdd ( _aCabPd , { "C5_PBRUTO" 	, (_cArqTmp)->C5_PBRUTO 					, NIL} )
			aAdd ( _aCabPd , { "C5_TIPLIB" 	, (_cArqTmp)->C5_TPLIB						, NIL} )
			aAdd ( _aCabPd , { "C5_TABELA"  , _cTabela									, NIL} )
			aAdd ( _aCabPd , { "C5_XPEDWEB"  , alltrim(str((_cArqTmp)->C5_XPEDWEB))	, NIL} )
            /*
			IF ValType((_cArqTmp)->C5_XTPREMS) == "N"
				aAdd ( _aCabPd , { "C5_XTPREMS" , AllTrim(Str((_cArqTmp)->C5_XTPREMS)) , NIL} )
			Else	
				aAdd ( _aCabPd , { "C5_XTPREMS" , AllTrim((_cArqTmp)->C5_XTPREMS) , NIL} )
			EndIf	
            */
            /*
			If (_cArqTmp)->FORMAPG == 'B' //BOLETO
				aAdd ( _aCabPd , { "C5_NATUREZ"  , cNatBol								, NIL} )
			Else
				aAdd ( _aCabPd , { "C5_NATUREZ"  , cNatCart								, NIL} )
			Endif
			*/
			//If !Empty(_cTransp)
			aAdd ( _aCabPd , { "C5_TRANSP"  , _cTransp									, NIL} )
			//EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Alimentando informações pertinente ao produto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			_nItemC6	:= 1
			_aItmPd		:= {}
			//Zerando as Variáveis
			_nTotParc	:= 0
			nVldValPd	:= 0			
			//Conout("GENI023 - Montagem do Vetor de Pedido de Vendas - Item")
			
			While (_cArqTmp)->(!EOF()) .And. _cPedOld == AllTrim(Str((_cArqTmp)->C5_XPEDOLD)) .and. _cCont <= "99";
				.and. cChavCli = alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))
				
				_cCont 		:= "01"
				_alinha 	:= {}
				_aItmPd		:= {} 
				
				//Conout("GENI023 - Entrou no While do item pedido de vendas ")
				_cDescPd := Posicione("SB1",1,xFilial("SB1") + (_cArqTmp)->C6_PRODUTO,"B1_DESC")
				_cLocB1  := IIF(Empty(AllTrim((_cArqTmp)->C6_LOCAL)),Posicione("SB1",1,xFilial("SB1") + (_cArqTmp)->C6_PRODUTO,"B1_LOCPAD"),(_cArqTmp)->C6_LOCAL)
				/*
				If !_lVwWeb 
					Begin Transaction
						tcsqlexec("UPDATE "+RetSqlName("DA1")+" SET DA1_PRCVEN = "+alltrim(str((_cArqTmp)->C6_PRCVEN))+", DA1_DATVIG = ' ' WHERE DA1_CODTAB = '"+_cTabela+"' AND DA1_CODPRO = '"+padr(alltrim((_cArqTmp)->C6_PRODUTO),tamsx3("C6_PRODUTO")[1])+"' AND D_E_L_E_T_ = ' '")
					End Transaction
				Endif
				*/
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄá
				//³Alimentando os Itens do pedido³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄá
				
				If (_cArqTmp)->TPPUBLI == 28 //Tipo de Publicacao E-Aluguel [Bruno Parreira,22/07/2019]
					cTes := cTesEAlu
				Else
					cTes := cTesServ
				EndIf
				
				aAdd ( _alinha , { "C6_ITEM"    , _cCont								, NIL} )
				aAdd ( _alinha , { "C6_PRODUTO" , padr(alltrim((_cArqTmp)->C6_PRODUTO),tamsx3("C6_PRODUTO")[1])		, NIL} )
				aAdd ( _alinha , { "C6_DESCRI"  , _cDescPd  							, NIL} )
				aAdd ( _alinha , { "C6_QTDVEN"  , (_cArqTmp)->C6_QTDVEN   				, NIL} )
				aAdd ( _alinha , { "C6_QTDLIB"  , (_cArqTmp)->C6_QTDVEN   				, NIL} )
				aAdd ( _alinha , { "C6_PRCVEN"  , (_cArqTmp)->C6_PRCVEN    			, NIL} )
				aAdd ( _alinha , { "C6_VALOR"   , (_cArqTmp)->C6_VALOR    				, NIL} )
				
				//aAdd ( _alinha , { "C6_TES"     , (_cArqTmp)->C6_TES      				, NIL} )
				aAdd ( _alinha , { "C6_TES"     , cTes      						, NIL} )
				
				aAdd ( _alinha , { "C6_LOCAL"   ,  _cLocB1   							, NIL} )
				aAdd ( _alinha , { "C6_DESCONT" , (_cArqTmp)->C6_DESCONT    			, NIL} )
				aAdd ( _alinha , { "C6_VALDESC" , (_cArqTmp)->C6_VALDESC    			, NIL} )
				aAdd ( _alinha , { "C6_ENTREG"  , STOD((_cArqTmp)->C6_ENTREG)			, NIL} )
				aAdd ( _aItmPd , aClone(_alinha)  )
				
				_nItemC6 ++
				_nQtdTot	:= (_cArqTmp)->C6_QTDVEN
				_nValTot	:= (_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN
//				_cCont		:= soma1(_cCont)


				nPosAux := aScan(_aCabPd, {|x| x[1] == "C5_XMSGNFS" } )		
				If nPosAux == 0
					If (_cArqTmp)->TPPUBLI = 28 //Tipo de Publicacao E-Aluguel [Bruno Parreira,22/07/2019]
						cDtValid := "31/12/2019"
						aAdd ( _aCabPd , { "C5_XMSGNFS" , "Nro Pedido: "+alltrim(str((_cArqTmp)->C5_XPEDWEB))+" - "+AllTrim(_cDescPd)+" - DISPONIBILIZAÇÃO, SEM CESSÃO DEFINITIVA, DE TEXTO E IMAGEM DE LIVROS REF. À COLETÂNEA POR MEIO DA INTERNET - VÁLIDO ATÉ "+cDtValid, NIL} )
					Else 
						aAdd ( _aCabPd , { "C5_XMSGNFS" , "Nro Pedido: "+alltrim(str((_cArqTmp)->C5_XPEDWEB))+" - "+AllTrim(_cDescPd) , NIL} )
					EndIf
				Else
					If (_cArqTmp)->TPPUBLI = 28 //Tipo de Publicacao E-Aluguel [Bruno Parreira,22/07/2019]
						cDtValid := "31/12/2019"
						_aCabPd[nPosAux][2] := "Nro Pedido: "+alltrim(str((_cArqTmp)->C5_XPEDWEB))+" - "+AllTrim(_cDescPd)+" - DISPONIBILIZAÇÃO, SEM CESSÃO DEFINITIVA, DE TEXTO E IMAGEM DE LIVROS REF. À COLETÂNEA POR MEIO DA INTERNET - VÁLIDO ATÉ "+cDtValid
					Else 
						_aCabPd[nPosAux][2] := "Nro Pedido: "+alltrim(str((_cArqTmp)->C5_XPEDWEB))+" - "+AllTrim(_cDescPd)
					EndIf
					
				EndIF
			
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Alimentando o cabeçalho do Pedido de Vendas com as informações customizadas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
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
				
				//Zerando as Variáveis
				_nQtdTot := 0
				_nValTot := 0
				_nTotParc+= ((_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN) - (_cArqTmp)->C6_VALDESC

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
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Validação da Condicao de Pagamento BOLETO OU CARTAO Multiplos/Unico     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ							
				
				If "VENDA" $ _cTipo
	                
	                cFORMAPG	:= ""
					_aParcItem	:= U_GENI018P(_aCabPd,_cPedOld,@cFORMAPG,_nTotParc,@_cMsg,nVldValPd,_cPedWeb,cOrigem)
					
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
							MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_PROD_CURSO_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
					    Else
							MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
				    		EndIf
						(_cArqTmp)->(DbSkip())
					EndIf
						
				Else
					_aParcItem := {}	
				EndIf
				
				IF Empty(_cMsg)	
					GENI023B(_aClient,_aCabPd,_aItmPd,_cCodOld,_cPedOld,_cCGC,_cTipo,_cPedWeb,_cNome,_aParcItem)
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI023B  ºAutor  ³Angelo Henrique     º Data ³  14/07/14   º±±
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
Static Function GENI023B(_aClient,_aCabPd,_aItmPd,_cCodOld,_cPedOld,_cCGC,_cTipo,_cPedWeb,_cNome,_aParcItem)

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
Local _cMvSeri 			:= Iif(lDigital,"3",GetMv("GEN_FAT003"))//GetMv("GEN_FAT003") //SERIE nota de saída
Local _cNotaImp			:= ""
Local _nPosLb			:= 0
//Local _cCGC := ""		//Rafael Leite - 29/01/2015. Variavel nao pode ser declarada em branco nesse ponto.
Local nPosProd			:= aScan(_aItmPd[1], {|x| AllTrim(x[1]) == "C6_PRODUTO" } )
Local _cParcela 		:= ""
Local cParc1			:= GetMv("MV_1DUP")
Local cSC5Aux			:= ""


Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.
Private _aErro			:= {}
Private _cErroLg		:= "" //Variável onde é armazenado o log quer será impresso em um arquivo
//Private _cView	:= GETMV("MV_XVIEWPD")
Private _cLogPd	:= "\logsiga\ped curso\"//SUPERGETMV("MV_XCAMLOG",.T.,"\logsiga\ped venda\") //Parâmetro que contém o caminho onde será gravado o arquivo de log de inconsistências

//Default _cCGC := ""

_nPosLb	:= aScan(_aItmPd[1], { |x| Alltrim(x[1]) == "C6_QTDLIB" })
_nPosLj	:= aScan(_aClient, { |x| Alltrim(x[1]) == "A1_LOJA" })

//If _cCodOld != "0"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Só irá incluir os pedidos que não forem encontrados no protheus prevenindo assim algum problema na View³
//³Conforme solicitado será alimentado a FLAG VIEW dos pedidos
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cQuery := "SELECT C5_XPEDOLD
_cQuery += " FROM " + RetSqlName("SC5") + " SC5
_cQuery += " JOIN " + RetSqlName("SC6") + " SC6
_cQuery += " ON C6_FILIAL = C5_FILIAL
_cQuery += " AND C6_NUM = C5_NUM
_cQuery += " AND SC6.D_E_L_E_T_ <> '*'
_cQuery += " AND SC5.D_E_L_E_T_ <> '*'
_cQuery += " AND C5_XPEDOLD = '"  + _cPedOld + "'"

cInProd := "("
aEval(_aItmPd, {|x| cInProd+="'"+AllTrim(x[nPosProd][2])+"'," } )
cInProd	:= Left(cInProd,Len(cInProd)-1)
cInProd+=")"

_cQuery += " AND C6_PRODUTO IN "+cInProd

//_cQuery := ChangeQuery(_cQuery)

If Select(_cArqPd) > 0
	dbSelectArea(_cArqPd)
	(_cArqPd)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqPd, .F., .T.)

If ((_cArqPd)->(EOF()) .and. _lVwWeb)
	
	//Conout("GENI023 - Inicio do execauto de pedido de vendas e de clientes")
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
	
	//If _lImpCli
	//Conout("GENI023 - Execauto de Cliente" )
	lMsErroAuto := .F.
	MSExecAuto({|x,y| Mata030(x,y)},_aClient,nOpt)
	
	//REMOVE ASPAS SIMPLES DO CADASTRO DE CLIENTE E FORNECEDOR
	Begin Transaction
		TcSqlexec("update "+RetSqlName("SA1")+" set A1_NOME = upper(replace(A1_NOME,'''',' ')), A1_NREDUZ = upper(replace(A1_NREDUZ,'''',' ')) where A1_COD = '"+SA1->A1_COD+"' AND A1_NOME like '%''%' or A1_NREDUZ like '%''%'")
//		TcSqlexec("update "+RetSqlName("SA2")+" set A2_NOME = upper(replace(A2_NOME,'''',' ')), A2_NREDUZ = upper(replace(A2_NREDUZ,'''',' ')) where A2_NOME like '%''%' or A2_NREDUZ like '%''%'")
	End Transaction
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso tenha entrado na rotina de execauto de cliente e não der erro³
	//³irá prosseguir para a importação do pedido de vendas              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ordenando o vetor conforme estrutura da SX3, pois      ³
		//³alguns execauto`s realizam valida;'oes de gatilhos     ³
		//³o que pode acabar matando uma informa;'ao obrigat[oria ³
		//³que ja havia sido enviada corretamente no array        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		
		//Conout("GENI023 - Execauto de Pedido de Vendas")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicio a gravação (Execauto) do pedido de vendas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
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

		If !lMsErroAuto .or. (AllTrim(SC5->C5_XPEDWEB) == AllTrim(_cPedWeb) .AND. AllTrim(SC5->C5_XPEDOLD) == AllTrim(_cPedOld) .AND. cSC5Aux <> SC5->C5_NUM )
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
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
				//³Rotina para desbloquear crédito para que o pedido seja faturado sem problemas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
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
							MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif((_cArqTmp)->DIGITAL=1,"DIG_","IMP_")+ ".txt" , _cErroLg )
						EndIf
						(_cAliSC9)->(DbSkip())
					EndDo
				Else
					_cErroLg := "Pedido não localizado na SC9. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC5->C5_NUM
					MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif((_cArqTmp)->DIGITAL=1,"DIG_","IMP_")+ ".txt" , _cErroLg )
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
								MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif((_cArqTmp)->DIGITAL=1,"DIG_","IMP_")+ ".txt" , _cErroLg )
								SC9->(DBSKIP())
							Endif
						Else
							_cErroLg := "Pedido com itens SC9 não liberado. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC9->C9_PEDIDO + " Item: " + SC9->C9_ITEM
							MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif((_cArqTmp)->DIGITAL=1,"DIG_","IMP_")+ ".txt" , _cErroLg )
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
							conout("GENI023 - "+_cErroLg)
							U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br")+";helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Importação WEB"),oemtoansi(_cErroLg),,,.F.)
							
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
									conout("GENI023 - "+_cErroLg)
									U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br")+";helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Importação WEB"),oemtoansi(_cErroLg),,,.F.)
								EndIf
								_cNotaImp := ""
							Else
								_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. Não foi possível encontrar o registro na SF2 para exclusão. Efetue o procedimento manualmente assim que possível."
								conout("GENI023 - "+_cErroLg)
								U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br")+";helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Importação WEB"),oemtoansi(_cErroLg),,,.F.)
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
									MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif((_cArqTmp)->DIGITAL=1,"DIG_","IMP_")+ ".txt" , _cErroLg )
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
									MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif((_cArqTmp)->DIGITAL=1,"DIG_","IMP_")+ ".txt" , _cErroLg )
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
								MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL)+ "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif((_cArqTmp)->DIGITAL=1,"DIG_","IMP_")+ ".txt" , _cErroLg )
							EndIf
						EndIf
					EndIf
				EndIf
				
				/*-------------------------------------------------------
				FIM DA ROTINA PARA GERAÇÃO  DE NOTA NO FATURAMENTO
				---------------------------------------------------------*/
			Else
				cMsg := "GENI023 - IMPORTAÇÃO SERVIÇO WEB" + cEnt
				cMsg += cEnt
				cMsg += "O Pedido " + SC5->C5_NUM + " com TES PAI diferentes e não vai gerar documento de saída." + cEnt
				U_GenSendMail(,,,"noreply@grupogen.com.br","beatriz.reis@grupogen.com.br;rafael.leite@grupogen.com.br;helimar@grupogen.com.br",oemtoansi("Protheus Faturamento - Importação Serviço Web"),cMsg,,,.F.)
			EndIf
			
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
