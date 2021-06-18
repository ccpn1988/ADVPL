#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#DEFINE cEnt Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI029   ºAutor  ³Cleuto Lima         º Data ³  12/12/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina utilizada para gerar FATURAMENTO dos pedidos de vedasº±±
±±º          ³Integração Pedido curso Forum Protheus x Oracle             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENI029()

Conout("GENI029 - Inicio da importação de pedido de vendas curso forum")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verificação para saber se a rotina esta sendo chamada pela Schedule³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Prepare Environment Empresa "00" Filial "7001"

If upper(alltrim(GetEnvServer())) $ "SCHEDULE" //EXECUTA SOMENTE NO AMBIENTE SCHEDULE
	
	If LockByName("GENI029",.T.,.T.,.T.)
	
		/* verifico se tem notas autorizadas para atualizar o flag da  */
		//Atualiza a tabela GENESB.FORUM_PEDIDO_GERENCIAL com o flag de notas fiscais autorizadas na prefeiruta
		//GENI029N()
		
		//Processa integração
		GENI029A()
		
		UnLockByName("GENI029",.T.,.T.,.T.)		
	Else
		Conout("GENI029 - não foi possível iniciar a rotina pois a mesma já está sendo executada!")
	EndIf	
Endif

Reset Environment

Conout("GENI029 - Fim da importação de pedido de vendas curso forum")

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI029A  ºAutor  ³Angelo Henrique     º Data ³  11/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para o processamento da integração do pedido de vendaº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GENI029A()

Local _aArea 		:= GetArea()
Local _aClient	:= {} //Vetor para alimentar informações do cliente caso o mesmo não esteja cadastrado
Local _cArqAli	:= GetNextAlias()
Local _cCdMun 	:= ""
Local _cIncsr		:= ""
Local _cTpCli		:= ""
Local _cMsblq		:= ""
Local _cCep		:= ""
Local _cMunic		:= ""
Local _cCGC		:= ""
Local _cCodPs		:= ""
Local _cLoja		:= "01"
Local _cCod		:= ""
Local _nLoja 		:= 0
Local _cVend		:= ""
Local _cTpDes		:= ""
Local _cDescPd	:= ""
Local _nItemC6  	:= 1 //Contador para os itens do pedido de vendas
Local _cQryIns	:= ""
Local _cLocB1		:= ""
Local _nQtdTot 	:= 0
Local _nValTot 	:= 0
Local _cMsg		:= ""
Local _cTransp	:= ""
Local _aDir		:= {}
Local _cCont 		:= "01"
Local _cFretePd	:= GetNextAlias()
Local _cArqPd		:= GetNextAlias()
Local _cArqPro	:= GetNextAlias()
Local _cNome		:= ""
Local _nDIGITAL	:= 1
Local lEntrega	:= .F.
Local aUpdFlag	:= {}
Local _nI         := 0
Local _nTotParc   := 0
Local _cMailPdForum	:= GetMv("GEN_FAT153")
Local _aParcItem	:= {}
Local cFORMAPG	:= ""
Local _cTabela	:= GetMv("GEN_FAT064")
Local _cTesPF		:= GetMv("GEN_FAT194")
Local _cTesPJ		:= GetMv("GEN_FAT205")
Local lNewCli		:= .T.
 
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
Local cJSonCEP	:= ""
Local _cUf		:= ""
Local _cEst		:= ""

Private _cTipo		:= "CURSO"
Private _cQuery		:= ""
Private _cArqTmp		:= GetNextAlias()
Private _oServer		:= Nil
Private _cFilCont		:= ""
Private _cView		:= "" //Parâmetro que contém o nome da view que será consultada para a criação do Pedido de Vendas
Private _cLogPd		:= "" //Parâmetro que contém o caminho onde será gravado o arquivo de log de inconsistências
Private _aCabPd 		:= {}
Private _aItmPd 		:= {}
Private _alinha		:= {}
Private _cLogPd		:= "\logsiga\ped_gerencial_forum\"
Private cNatGForum	:=  GetMv("GEN_FAT207")

WFForceDir(_cLogPd)

_cView	:= "DBA_EGK.TT_I35_PEDIDOS_GERENCIAL_FORUM" //SUPERGETMV("GEN_FAT176",.T.,"") //Parâmetro que contém o nome da view que será consultada para a criação do Pedido de Vendas

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
_cQuery := "SELECT * FROM "+_cView
//_cQuery += " WHERE C5_XPEDOLD = '23991'"

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqTmp, .F., .T.)
(_cArqTmp)->(DbGotop())
nTotReg := Contar(_cArqTmp, "!EOF()")
(_cArqTmp)->(DbGotop())

_nCtVi := 0
While (_cArqTmp)->(!EOF())
	
	cChavCli	:= Alltrim((_cArqTmp)->C5_XPEDWEB)+(_cArqTmp)->C5_EMISSAO
	lNewCli	:= .T.
	_cMsg		:= ""
	
	Conout("GENI029 - Analisando pedido WEB "+Alltrim((_cArqTmp)->C5_XPEDWEB))
					
	Do While cChavCli == Alltrim((_cArqTmp)->C5_XPEDWEB)+(_cArqTmp)->C5_EMISSAO
		
		_cMsg		:= ""
		_cPedOld	:= AllTrim((_cArqTmp)->C5_XPEDOLD)
		_cPedWeb	:= AllTrim((_cArqTmp)->C5_XPEDWEB)
		
		cQryDup := "SELECT C5_XPEDWEB,C5_XPEDOLD "
		cQryDup += "  FROM "+RetSqlName("SC5")+" SC5 " 
		cQryDup += " WHERE C5_XPEDWEB = '" + _cPedWeb + "' "
		cQryDup += "   AND C5_XPEDOLD = '" + _cPedOld + "' "
		cQryDup += "   AND C5_FILIAL  = '" + xFilial("SC5") + "' "
		cQryDup += "   AND SC5.D_E_L_E_T_ <> '*' "
		
		If Select("TRB") > 0
			DbSelectArea("TRB")
			TRB->(DbCloseArea())
		EndIf

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryDup),"TRB", .F., .T.)

		If TRB->(!EOF())
			_cMsg += "Pedido Web: "+_cPedWeb+". Ped Old.: "+_cPedOld+". Já foram importados anteriormente. Favor verificar."
		EndIf
		
		If Empty(_cMsg)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ajustes de alguns dados para a inclusão correta³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lNewCli	:= .T.
			
			If Alltrim((_cArqTmp)->A1_EST) == 'EX'
				_cCdMun := '99999'
				_cCep	:= '00000000'
				_cMunic	:= 'EXTERIOR'
				_cCGC 	:= AllTrim((_cArqTmp)->A1_CGC)
				_cUf	:= 'EX'
				_cEst	:= 'EXTERIOR'
			Else
				_cCdMun := AllTrim((_cArqTmp)->A1_COD_MUN)
				_cCep	:= Alltrim((_cArqTmp)->A1_CEP)			
				_cMunic	:= AllTrim((_cArqTmp)->A1_MUN)
				_cCGC	:= AllTrim((_cArqTmp)->A1_CGC)
				_cUf	:= Alltrim((_cArqTmp)->A1_EST)
				_cEst	:= Alltrim((_cArqTmp)->A1_ESTADO)

				IF Empty(_cUf) .OR. Empty(_cCdMun) .OR. Empty(_cUf) .OR. !ExistCpo("CC2",_cUf+_cCdMun)
					IF !U_GENA095C(_cCep,@_cUf,@_cEst,@_cCdMun,@_cMunic)
						_cMsg := "Dados de endereço invalido: "+Chr(13)+Chr(10)
						_cMsg += "cod.Mun.: "+(_cArqTmp)->A1_COD_MUN+Chr(13)+Chr(10)
						_cMsg += "Cep: "+Alltrim((_cArqTmp)->A1_CEP)+Chr(13)+Chr(10)
						_cMsg += "Municio: "+(_cArqTmp)->A1_MUN+Chr(13)+Chr(10)

						MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + ".txt" , _cMsg )
						(_cArqTmp)->(DbSkip())
						Loop
					EndIf
				EndIF 
			EndIf
		
			_cIncsr := "ISENTO"
			_cTpCli := (_cArqTmp)->A1_XTIPCLI
			_cMsblq := (_cArqTmp)->A1_MSBLQL
			
			Do Case
				Case Empty(_cCGC) .AND. Alltrim(_cUf) <> 'EX'
					_cMsg += " Pedido Gerencial Forum:  "+Alltrim((_cArqTmp)->C5_XPEDWEB)+", Erro: CPF/CNPJ do Clinte não informado! <NOCGC>"
					MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + ".txt" , _cMsg )
					(_cArqTmp)->(DbSkip())
					Loop					
				Case !Empty(_cCGC) .AND. !CGC(AllTrim(_cCGC))
					_cMsg += " Pedido Gerencial Forum:  "+Alltrim((_cArqTmp)->C5_XPEDWEB)+", Erro: "+_cCGC+" - CPF/CNPJ do Client inválido! <NOVLDCGC>"
					MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + ".txt" , _cMsg )
					(_cArqTmp)->(DbSkip())
					Loop
				Case !Empty(_cCGC)	
				
					_cCod	:= ""
					_cLoja	:= ""
											
					SA1->(DbSetOrder(3))
					lNewCli	:= !SA1->(DbSeek( xFilial("SA1")+_cCGC ))
					
					If !lNewCli// .AND. Alltrim(_cUf) <> 'EX'
						_cCod	:= SA1->A1_COD
						_cLoja	:= SA1->A1_LOJA
					ElseIf Len(AllTrim(_cCGC)) > 11
						If Select("RAIZ_CGC") > 0
							RAIZ_CGC->(DbcloseArea())
						EndIf
						
						cLikeSA1 := "% AND A1_CGC LIKE '"+Left(_cCGC,8)+"%' AND A1_CGC <> '"+_cCGC+"' AND LENGTH(TRIM(A1_CGC)) > 11 %"
						
						BeginSql Alias "RAIZ_CGC"
							SELECT A1_COD,MAX(A1_LOJA) A1_LOJA FROM %Table:SA1% SA1
								WHERE A1_FILIAL = %xFilial:SA1%
								%Exp:cLikeSA1%
								AND SA1.%NotDel%
								GROUP BY A1_COD
						EndSql
						RAIZ_CGC->(DbGoTop())
						
						If RAIZ_CGC->(!EOF())
							_cCod	:= RAIZ_CGC->A1_COD
							_cLoja	:= Soma1(RAIZ_CGC->A1_LOJA)
						EndIf
						RAIZ_CGC->(DbcloseArea())
					EndIf					
			EndCase
						
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gravação das Informações no Array que será enviado para o Execauto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_aClient := {}
			If !Empty(_cCod)
				//Conout("GENI029 - Colocando o código do cliente")
				aAdd(_aClient,{"A1_COD"	,	_cCod													,Nil})
				aAdd(_aClient,{"A1_LOJA",	_cLoja													,Nil})
			else
				aAdd(_aClient,{"A1_COD"	,	GetSx8Num("SA1")										,Nil})
				aAdd(_aClient,{"A1_LOJA",	"01"													,Nil})
				ConfirmSx8()
			EndIf 
			
			//Conout("GENI029 - Alimentando vetor Cliente")
			If !Empty((_cArqTmp)->A1_XCODOLD)
				aAdd(_aClient,{"A1_XCODOLD"	,	alltrim((_cArqTmp)->A1_XCODOLD)						,Nil})
			Endif  
			
			aAdd(_aClient,{"A1_NOME"	,	U_GENA095A( (_cArqTmp)->A1_NOME )						,Nil})
			aAdd(_aClient,{"A1_PESSOA"	,	AllTrim((_cArqTmp)->A1_PESSOA)							,Nil})
			aAdd(_aClient,{"A1_NREDUZ"	,	U_GENA095A( (_cArqTmp)->A1_NREDUZ )						,Nil})
			aAdd(_aClient,{"A1_CEP"		,	_cCep													,Nil})
			aAdd(_aClient,{"A1_END"		,	(_cArqTmp)->A1_END										,Nil})
			aAdd(_aClient,{"A1_XENDNUM"	,	(_cArqTmp)->A1_XENDNUM									,Nil}) //Numero do endereco
			aAdd(_aClient,{"A1_COMPLEM"	,	" "														,Nil})
			aAdd(_aClient,{"A1_BAIRRO"	,	(_cArqTmp)->A1_BAIRRO									,Nil})
			aAdd(_aClient,{"A1_EST"		,	_cUf													,Nil})
			aAdd(_aClient,{"A1_ESTADO"	,	_cEst													,Nil})
			aAdd(_aClient,{"A1_COD_MUN"	,	_cCdMun													,Nil})
			aAdd(_aClient,{"A1_MUN"		,	AllTrim(_cMunic)										,Nil})
			aAdd(_aClient,{"A1_DDD"		,	(_cArqTmp)->A1_DDD										,Nil})
			aAdd(_aClient,{"A1_DDI"		,	(_cArqTmp)->A1_DDI										,Nil})
			aAdd(_aClient,{"A1_TEL"		,	(_cArqTmp)->A1_TEL										,Nil})
			aAdd(_aClient,{"A1_FAX"		,	(_cArqTmp)->A1_FAX										,Nil})
			aAdd(_aClient,{"A1_TIPO"	,	(_cArqTmp)->A1_TIPO										,Nil})
			aAdd(_aClient,{"A1_PAIS"	,	(_cArqTmp)->A1_PAIS										,Nil})
			aAdd(_aClient,{"A1_PAISDES"	,	AllTrim((_cArqTmp)->A1_PAISDES)							,Nil})
			aAdd(_aClient,{"A1_CODPAIS"	,	(_cArqTmp)->A1_CODPAIS								,Nil})
			aAdd(_aClient,{"A1_CGC"		,	_cCGC													,Nil})
			aAdd(_aClient,{"A1_ENDCOB"	,	AllTrim((_cArqTmp)->A1_ENDCOB)							,Nil})
			aAdd(_aClient,{"A1_CONTATO"	,	(_cArqTmp)->A1_CONTATO									,Nil})
			aAdd(_aClient,{"A1_ENDENT"	,	AllTrim((_cArqTmp)->A1_ENDENT)							,Nil})
			aAdd(_aClient,{"A1_INSCRM"	,	(_cArqTmp)->A1_INSCRM									,Nil})
			aAdd(_aClient,{"A1_INSCR"	,	(_cArqTmp)->A1_INSCR									,Nil})
			aAdd(_aClient,{"A1_TPESSOA"	,	AllTrim((_cArqTmp)->A1_TPESSOA)							,Nil})
			aAdd(_aClient,{"A1_EMAIL"	,	AllTrim((_cArqTmp)->A1_EMAIL)							,Nil})
			aAdd(_aClient,{"A1_MSBLQL"	,	(_cArqTmp)->A1_MSBLQL									,Nil})
			aAdd(_aClient,{"A1_CONTA"	,	AllTrim((_cArqTmp)->A1_CONTA)							,Nil})
			aAdd(_aClient,{"A1_XCLIPRE"	,	(_cArqTmp)->A1_XCLIPRE									,Nil}) //Cliente Premium
			aAdd(_aClient,{"A1_XTIPCLI"	,	(_cArqTmp)->A1_XTIPCLI									,Nil}) //Tipo de Cliente (GEN)
			aAdd(_aClient,{"A1_XCANALV"	,	(_cArqTmp)->A1_XCANALV									,Nil}) //Canal de Venda
			aAdd(_aClient,{"A1_VEND"		,	(_cArqTmp)->A1_VEND										,Nil})
			aAdd(_aClient,{"A1_XTPDES"	,	(_cArqTmp)->A1_XTPDES									,Nil}) //Tipo desconto
			aAdd(_aClient,{"A1_TRANSP"	,	(_cArqTmp)->A1_TRANSP									,Nil})
			aAdd(_aClient,{"A1_XCONDPG"	,	" "	                    								,Nil}) //Condicao Pagto (GEN)
			aAdd(_aClient,{"A1_COND"		,	GetMv("GEN_FAT065")										,Nil})
			aAdd(_aClient,{"A1_TABELA"	,	_cTabela	 											,Nil})
			aAdd(_aClient,{"A1_BLEMAIL"	,	(_cArqTmp)->A1_EMAIL									,Nil}) //Boleto por Email
			aAdd(_aClient,{"A1_RISCO"	,	GetMv("GEN_FAT066")										,Nil}) //Limite de Crédito	

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
			
			_cFilLog := xFilial("SC5")
			
			aAdd ( _aCabPd , { "C5_FRETE"	, 0				 							, NIL} )			
			aAdd ( _aCabPd , { "C5_TIPO"	, "N"       					   			, NIL} )			
			aAdd ( _aCabPd , { "C5_CONDPAG"	, (_cArqTmp)->C5_CONDPAG   				, NIL} )
			aAdd ( _aCabPd , { "C5_NATUREZ"  , cNatGForum								, NIL} )					
			aAdd ( _aCabPd , { "C5_EMISSAO"	, StoD((_cArqTmp)->C5_EMISSAO)			, NIL} )			
			//aAdd ( _aCabPd , { "C5_EMISSAO"	, DDataBase								, NIL} )
			aAdd ( _aCabPd , { "C5_TABELA"	, " "										, NIL} )

			aAdd ( _aCabPd , { "C5_XPEDWEB"	, (_cArqTmp)->C5_XPEDWEB 				, NIL} )
			aAdd ( _aCabPd , { "C5_XPEDOLD"	, (_cArqTmp)->C5_XPEDOLD 				, NIL} )
			aAdd ( _aCabPd , { "C5_TPFRETE"	, "S" 										, NIL} )
			aAdd ( _aCabPd , { "C5_MOEDA"	, 1											, NIL} )
			aAdd ( _aCabPd , { "C5_PESOL"	, 0					 						, NIL} )
			aAdd ( _aCabPd , { "C5_PBRUTO"	, 0 										, NIL} )
			aAdd ( _aCabPd , { "C5_TIPLIB"	, "2"										, NIL} )
			aAdd ( _aCabPd , { "C5_XTPREMS"	, "1"                					, NIL} )
			aAdd ( _aCabPd , { "C5_MENNOTA"	, AllTrim((_cArqTmp)->C5_MENNOTA)		, NIL} )
			
			aAdd ( _aCabPd , { "C5_XSNOENT" , " "										, NIL} )
			aAdd ( _aCabPd , { "C5_XNOMENT" , upper(AllTrim((_cArqTmp)->A1_NOME))	, NIL} )
			aAdd ( _aCabPd , { "C5_XTELENT" , (_cArqTmp)->A1_TEL						, NIL} )
			aAdd ( _aCabPd , { "C5_XDDDENT" , (_cArqTmp)->A1_DDD						, NIL} )
			aAdd ( _aCabPd , { "C5_XCOMENT" , (_cArqTmp)->A1_COMPLEMEN				, NIL} )
			aAdd ( _aCabPd , { "C5_XLOGENT" , (_cArqTmp)->A1_END					, NIL} )
			aAdd ( _aCabPd , { "C5_XCELENT" , " "									, NIL} )
			aAdd ( _aCabPd , { "C5_XDDCENT" , " "									, NIL} )
			aAdd ( _aCabPd , { "C5_XBAIENT" , (_cArqTmp)->A1_BAIRRO				, NIL} )
			aAdd ( _aCabPd , { "C5_XPAIENT" , (_cArqTmp)->A1_PAISDES				, NIL} )
			aAdd ( _aCabPd , { "C5_XCEPENT" , _cCep									, NIL} )
			aAdd ( _aCabPd , { "C5_XMUNENT" , _cCdMun								, NIL} )
			aAdd ( _aCabPd , { "C5_XCIDENT" , AllTrim(_cMunic)						, NIL} )
			aAdd ( _aCabPd , { "C5_XUFENT"  , _cUf									, NIL} )
			aAdd ( _aCabPd , { "C5_XNUMENT" , (_cArqTmp)->A1_XENDNUM				, NIL} )			
			//aAdd ( _aCabPd , { "C5_TRANSP"  , (_cArqTmp)->C5_TRANSP		, NIL} )
			aAdd ( _aCabPd , { "C5_TRANSP"  , ""									, NIL} )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Alimentando informações pertinente ao produto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			_nItemC6	:= 1 
			_aItmPd		:= {}
			aUpdFlag	:= {}
			//Zerando as Variáveis
			_nTotParc := 0
			
			//Conout("GENI029 - Montagem do Vetor de Pedido de Vendas - Item")
			
			_cCont 		:= "01"
			While (_cArqTmp)->(!EOF()) .And. _cPedOld == AllTrim((_cArqTmp)->C5_XPEDOLD) .and. _cCont <= "99";
				.and. cChavCli == Alltrim((_cArqTmp)->C5_XPEDWEB)+(_cArqTmp)->C5_EMISSAO
				
				_alinha  := {}
				//Conout("GENI029 - Entrou no While do item pedido de vendas ")
				_cDescPd  := Posicione("SB1",1,xFilial("SB1") + (_cArqTmp)->C6_PRODUTO,"B1_DESC")
				_cLocB1   := IIF(Empty(AllTrim((_cArqTmp)->C6_LOCAL)),Posicione("SB1",1,xFilial("SB1") + (_cArqTmp)->C6_PRODUTO,"B1_LOCPAD"),(_cArqTmp)->C6_LOCAL)
				_cProduto := padr(alltrim((_cArqTmp)->C6_PRODUTO),tamsx3("C6_PRODUTO")[1])

				SB1->(DbSetOrder(1))
				IF !SB1->(dbSeek(xFilial("SB1")+_cProduto))
					_cMsg += "Produto " +_cProduto+" não localizado na tabela SB1"+ Chr(13)+Chr(10)
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

						_cMsg += "Produto "+_cProduto+" não atende os criterios de faturamento como serviço tributado no RJ!"+Chr(13)+Chr(10)+;
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

						(_cArqTmp)->(DbSkip())
						Loop
					
					EndIF
				EndIF
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no cadastro de Tabela de Precos                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
				DA1->( DbSetOrder(1) )
				If !DA1->(dbSeek(xFilial("DA1")+_cTabela+_cProduto))
					_cMsg += "Produto " +_cProduto+" não localizado na tabela de preço "+_cTabela+ Chr(13)+Chr(10)
					(_cArqTmp)->(DbSkip())
					Loop
				EndIF
																	
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
				_cQuery += " AND C6_PRODUTO = '"  + AllTrim(_cProduto) + "'"
				_cQuery += " AND C5_EMISSAO = '"  + (_cArqTmp)->C5_EMISSAO + "'"
				
				
				If Select(_cArqPd) > 0
					dbSelectArea(_cArqPd)
					(_cArqPd)->(dbCloseArea())
				EndIf

				dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqPd, .F., .T.)

				If (_cArqPd)->(EOF())
											
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄá
					//³Alimentando os Itens do pedido³              
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄá
                    
					aAdd ( _alinha , { "C6_ITEM"	, _cCont						, NIL} )
					aAdd ( _alinha , { "C6_PRODUTO"	, _cProduto					, NIL} )
					aAdd ( _alinha , { "C6_DESCRI"	, _cDescPd  					, NIL} )					
					aAdd ( _alinha , { "C6_QTDVEN"	, (_cArqTmp)->C6_QTDVEN   	, NIL} )
					aAdd ( _alinha , { "C6_QTDLIB"	, (_cArqTmp)->C6_QTDVEN   	, NIL} )																				
					aAdd ( _alinha , { "C6_PRUNIT"	, (_cArqTmp)->C6_PRCVEN   	, NIL} )
					
					aAreaSA1	:= SA1->(GetArea())
										
					nDesc		:= 0									
					nValtot	:= Round(((_cArqTmp)->C6_PRCVEN*(_cArqTmp)->C6_QTDVEN)-(((_cArqTmp)->C6_PRCVEN*nDesc)/100)*(_cArqTmp)->C6_QTDVEN,2)
					nValDesc	:= Round(((_cArqTmp)->C6_PRCVEN*(_cArqTmp)->C6_QTDVEN)-nValtot,2)
					nValPrc	:= nValtot/(_cArqTmp)->C6_QTDVEN
					
					RestArea(aAreaSA1)
					
					aAdd ( _alinha , { "C6_PRCVEN"  , nValPrc				   			, NIL} )
					aAdd ( _alinha , { "C6_VALOR"   , nValtot    						, NIL} )
					aAdd ( _alinha , { "C6_DESCONT" , nDesc					    	, NIL} )
					aAdd ( _alinha , { "C6_VALDESC" , nValDesc				    	, NIL} )
					
					If 	Len(AllTrim(_cCGC)) == 11									
						aAdd ( _alinha , { "C6_TES"     , _cTesPF				      		, NIL} )
					Else
						aAdd ( _alinha , { "C6_TES"     , _cTesPJ				      		, NIL} )	
					EndIf					
					
					aAdd ( _alinha , { "C6_LOCAL"   , _cLocB1   						, NIL} ) 
					aAdd ( _alinha , { "C6_ENTREG"  , DDataBase						, NIL} )
					aAdd ( _alinha , { "C6_XPEDWEB" , _cPedWeb						, NIL} )
					
					_nValTot += (_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN
					_nTotParc+= ((_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN) - nValDesc
															
					aAdd(_aItmPd , _alinha)
					
					_nQtdTot += (_cArqTmp)->C6_QTDVEN
					_nItemC6 ++										
					_cCont 	:= soma1(_cCont)
					
					//Aadd(aUpdFlag, (_cArqTmp)->RECNO )
					
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
			
			/*
		     cFORMAPG	:= ""
			_aParcItem	:= U_GENI029P(_aCabPd,_cPedOld,@cFORMAPG,_nTotParc,@_cMsg)			
			
			If cFORMAPG == 'B' //BOLETO
				_aCabPd[ aScan(_aCabPd,{|x| X[1] == "C5_CONDPAG" }) ][2]	:= "001"				
			Endif			
			
			If Empty(_cMsg)			
				For _nI := 1 To Len(_aParcItem)																	
					aAdd ( _aCabPd , { "C5_DATA"+cValToChar(_nI) , DataValida(_aParcItem[_nI][1]), Nil} )
					aAdd ( _aCabPd , { "C5_PARC"+cValToChar(_nI) , _aParcItem[_nI][2]            , Nil} )
				Next
			Else
				If SubStr(_cMsg,1,1) = 'P'
					MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_PROD_" + AllTrim(_cProduto) +  "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
			    Else
					MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
		   		EndIf
				//(_cArqTmp)->(DbSkip())
			EndIf
			*/
			
			_aCabPd[ aScan(_aCabPd,{|x| X[1] == "C5_CONDPAG" }) ][2]	:= "001"				
													
			If Empty(_cMsg)
				If Len(_aItmPd) > 0
					
					GENI029B(_aClient,_aCabPd,_aItmPd,_cPedOld,_cCGC,_cTipo,_cPedWeb,_cNome,_nDIGITAL,_aParcItem,aUpdFlag,_cMailPdForum)
					_cCod := ""       				
					
				Else
					
					_cMsg := "Erro ao preencher o array de itens do pedido, 'Pedido Web' "+_cPedWeb+" este pedido não foi emitido no Protheus!"
					MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
					(_cArqTmp)->(DbSkip())				
					
				EndIf	
			Else
			    MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + ".txt" , _cMsg )
			    
	    		//If Alltrim((_cArqTmp)->C5_XPEDWEB)+(_cArqTmp)->C5_EMISSAO
					(_cArqTmp)->(DbSkip())
				//EndIf
			EndIF
		Else
		    If SubStr(_cMsg,1,1) = 'P'
				MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_PROD_" + alltrim((_cArqTmp)->C6_PRODUTO) +  "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
		    Else
				MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
    		EndIf
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
±±ºPrograma  ³GENI029B  ºAutor  ³Angelo Henrique     º Data ³  14/07/14   º±±
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
Static Function GENI029B(_aClient,_aCabPd,_aItmPd,_cPedOld,_cCGC,_cTipo,_cPedWeb,_cNome,_nDIGITAL,_aParcItem,aUpdFlag,_cMailPdForum)

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
Local _cMvSeri 			:= AllTrim(GetMV("GEN_FAT257"))
Local _cNotaImp			:= ""
Local _nPosLb			:= 0
//Local _cCGC := ""		//Rafael Leite - 29/01/2015. Variavel nao pode ser declarada em branco nesse ponto.
Local _cParcela 		:= ""
Local cParc1			:= GetMv("MV_1DUP")

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.
Private _aErro			:= {}
Private _cErroLg		:= "" //Variável onde é armazenado o log quer será impresso em um arquivo

_nPosLb	:= aScan(_aItmPd[1], { |x| Alltrim(x[1]) == "C6_QTDLIB" })
_nPosLj	:= aScan(_aClient, { |x| Alltrim(x[1]) == "A1_LOJA" })
	
	//Conout("GENI029 - Inicio do execauto de pedido de vendas e de clientes")
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
				SA1->(DbSetOrder(1))
				SA1->(DbGoTo(nRec))				
			Endif
		EndIf 
	EndIf
		
	_nPosLj	:= aScan(_aClient, { |x| Alltrim(x[1]) == "A1_LOJA" })	
	If _nPosLj = 0
		aAdd(_aClient,{"A1_LOJA","01",Nil})
	Endif
	
	//If _lImpCli
	//Conout("GENI029 - Execauto de Cliente" )
	lMsErroAuto := .F.
	MSExecAuto({|x,y| Mata030(x,y)},_aClient,nOpt)

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
		
		//Conout("GENI029 - Execauto de Pedido de Vendas")
		
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

		//If !lMsErroAuto
			/*For nAuxUpdt := 1 To Len(aUpdFlag)		
				Begin transaction
					cScript	:= "UPDATE GENESB.FORUM_PEDIDO_GERENCIAL SET RP = 1 WHERE RECNO = "+cValtochar(aUpdFlag[nAuxUpdt])+" AND PEDIDO_VOXEL_ID = "+_cPedWeb+" AND TO_CHAR(DATA_PEDIDO,'YYYYMMDD') = '"+DTOS(SC5->C5_EMISSAO)+"' "
					If TCSQLEXEC(cScript) != 0
						_cErroLg	:= "FALHA AO TENTAR ATUALIZAR A FLAG DE PROCESSAMENTO PARA O PEDIDO "+ AllTrim(_cPedWeb)
						MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + "_" + "FALHA_FLAG.txt" , _cErroLg )
						U_GenSendMail(,,,"noreply@grupogen.com.br",_cMailPdForum,oemtoansi("GENI026 - Protheus Faturamento - Pedido Forum"),_cErroLg,,,.F.)
					EndIf
				end transaction
			Next*/
			/*
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
			*/
		//EndIf
					
		If !lMsErroAuto
	
			_cAlias1 := GetNextAlias()
			//Verifica se tem TES diferente no pedido
			_cQuery := "SELECT DISTINCT C6_TES
			_cQuery += " FROM " + RetSqlName("SC6")
			_cQuery += " WHERE C6_FILIAL = '" + xFilial("SC6") + "'"
			_cQuery += " AND C6_NUM = '" + SC5->C5_NUM + "'"
			_cQuery += " AND D_E_L_E_T_ = ' '
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
					
					U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("Protheus Faturamento - Importação Pedido Web"),cMsg,,,.F.)
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
					
					//*'------------------------------------------------'*
					//*'Rotina utilizada para realizar a geração da Nota'*
					//*'------------------------------------------------'*
					// 28/07/2016 - Rafael Leite - Desabilitada geração do documento de saida por causa do Protheus Integração Faturamento Protheus x WMS
					//If Empty(_cErroLg) .and. _lVwWeb
					
					If Empty(_cErroLg) .AND. AllTrim(_cMvSeri) == "3"//parametro de controle de execucao
					
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
						
						If (_cAliSC6)->(!Eof())
							
							_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. Será feita tentativa de exclusão."
							conout("GENI029 - "+_cErroLg)
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
									conout("GENI029 - "+_cErroLg)
									U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br")+";helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Importação WEB"),oemtoansi(_cErroLg),,,.F.)
								EndIf
								_cNotaImp := ""
							Else
								_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. Não foi possível encontrar o registro na SF2 para exclusão. Efetue o procedimento manualmente assim que possível."
								conout("GENI029 - "+_cErroLg)
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
				cMsg := "GENI029 - IMPORTAÇÃO PEDIDO WEB" + cEnt
				cMsg += cEnt
				cMsg += "O Pedido " + SC5->C5_NUM + " tem TES diferentes e não vai gerar documento de saída." + cEnt
				U_GenSendMail(,,,"noreply@grupogen.com.br","beatriz.reis@grupogen.com.br;rafael.leite@grupogen.com.br;helimar@grupogen.com.br",oemtoansi("Protheus Faturamento - Importação Pedido Web"),cMsg,,,.F.)
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
				cMsg := "GENI029 - IMPORTAÇÃO PEDIDO WEB" + cEnt
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
 
User Function GENI029P(_aCabPd,_cPedOld,cFORMAPG,_nTotParc,_cMsg,nVldValPd)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da rotina.                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea	   		:= GetArea()
Local aParcelas		:= {}
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
Local cNSU			:= ""

Default _cPedOld	:= ""
Default _cMsg		:= ""
Default cFORMAPG	:= ""
Default _aCabPd		:= {}
Default nVldValPd	:= 0

If Empty(_cPedOld)
	_cMsg	:= "Pedido Old não informado!"
	Return aParcelas
EndIf

If Len(_aCabPd) == 0
	_cMsg	:= "Cabeçalho do pedido não informado!"
	Return aParcelas
EndIf

If ASCAN(_aCabPd,{|X|  X[1] == "C5_FRETE" }) == 0
	_cMsg	:= "Campo frete (C5_FRETE) não localizado no cabeçalho do pedido!"
	Return aParcelas
EndIf

If _nTotParc == 0
	_cMsg	:= "Valor total a ser parcelado igual a zero!"
	Return aParcelas
EndIf

BeginSql Alias _cGENESB
	SELECT /*PG.VALOR VALOR_PAGAMENTO, //removido pois não existe na produção */
			  NVL(PG.PARCELAMENTO,1) PARCELA,		  
			  PG.ADQUIRENTE OPERADORA, 
			  trim(TO_CHAR( CASE WHEN PG.DATA_AUTORIZACAO IS NULL THEN DATA_EMISSAO ELSE PG.DATA_AUTORIZACAO END, 'yyyymmdd')) DT_PGT,
			  ' ' TID,           
			  PG.NSU NSU,
			  PG.TIPO_PAGAMENTO BANDEIRA
			  FROM GENESB.FORUM_PGTO_GERENCIAL PG 
			WHERE UPPER(PG.TIPO_PAGAMENTO) <> 'BOLETO'
	    AND PG.PEDIDO_VOXEL_ID = %exp:_cPedOld%
EndSql

_lBoleto   := (_cGENESB)->(Eof())
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
		Aadd(aParcelas,{_aParcCart[_nI,1],_aParcCart[_nI,2],_cOper,_cNSUTEF,_cBandeira}) 
	Next
	*/		
Else //CARTAO
	
	cFORMAPG	:= "C"

	While (_cGENESB)->(!Eof())
		
		If Empty((_cGENESB)->DT_PGT)
			_cMsg := "data de autorização do pagamento não informada!"
			Exit
		EndIf		
		
		cNSU	:= (_cGENESB)->NSU
		If Empty(cNSU)
			cNSU	:= _cPedOld
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
		_nTotParc  := _nTotParc + _aCabPd[_nPosFre,2] //If((_cGENESB)->VALOR_PAGAMENTO == 0,_nTotParc,(_cGENESB)->VALOR_PAGAMENTO) + _aCabPd[_nPosFre,2]
		_dDataPGT  := STOD((_cGENESB)->DT_PGT)+1 // +1 pois o protheus está considerando a data do pagamento como dia inicial para o calulo das parcelas ficando com 1 dia a menos em relação as datas da acesstage
		_cOper     := (_cGENESB)->OPERADORA
		_cNSUTEF   := (_cGENESB)->NSU
		_cBandeira := (_cGENESB)->BANDEIRA
		_aParcCart := Condicao(_nTotParc,_cCondPgto,,_dDataPGT)
		cPcAux		:= "0"
		For _nI := 1 To Len(_aParcCart)
			cPcAux := Soma1(cPcAux)
			Aadd(aParcelas,{_aParcCart[_nI,1],_aParcCart[_nI,2],_cOper,_cNSUTEF,_cBandeira,cPcAux}) 
		Next

		 (_cGENESB)->(DbSkip())
	EndDo		
EndIf

(_cGENESB)->(DbCloseArea())

// Ajustando o valor de ultima parcela caso tenha alguma diferença de arredondamento
If nVldValPd > 0 .AND. Len(aParcelas) > 1

	aEval(aParcelas, {|x| nChecVal+=x[2] } )
	
	If nChecVal < nVldValPd
		 aParcelas[Len(aParcelas)][2] := A410Arred(aParcelas[Len(aParcelas)][2]+(nVldValPd-nChecVal) , "C6_VALOR" )
	EndIf

	If nChecVal > nVldValPd
		 aParcelas[Len(aParcelas)][2] := A410Arred(aParcelas[Len(aParcelas)][2]-(nChecVal-nVldValPd) , "C6_VALOR" )
	EndIf
	
EndIf

RestArea(aArea)
	
Return aParcelas
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI029   ºAutor  ³Cleuto Lima         º Data ³  12/12/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza a tabela GENESB.FORUM_PEDIDO_GERENCIAL com o flag  º±±
±±º          ³de notas fiscais autorizadas na prefeiruta                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static function GENI029N()

Local cAliNFSe		:= GetNextAlias()
Local cScript			:= ""
Local _cErroLg		:= ""
Local _cMailPdForum	:= GetMv("GEN_FAT153")
Local _cLogPd			:= "\logsiga\ped_gerencial_forum\"

BeginSql Alias cAliNFSe
	SELECT P.RECNO RECTMP,P.PEDIDO_VOXEL_ID NUMPED FROM GENESB.FORUM_PEDIDO_GERENCIAL P
	WHERE PROTHEUS = 0
	AND RP = 1
	AND EXISTS
	    (
	    SELECT 1
			FROM TOTVS.%Table:SC6% SC6
	    JOIN TOTVS.%Table:SC5% SC5    
	    ON C5_FILIAL = C6_FILIAL
	    AND C5_NUM = C6_NUM
	    AND SC5.%NotDel%
	    JOIN TOTVS.%Table:SF2% SF2
	    ON F2_FILIAL = C5_FILIAL
	    AND F2_DOC = C5_NOTA
	    AND F2_SERIE = C5_SERIE
	    AND SF2.%NotDel%
		 WHERE C6_FILIAL = '7001'
	     AND TO_NUMBER(TRIM(C6_XPEDWEB)) = P.PEDIDO_VOXEL_ID
		 AND TO_NUMBER(TRIM(C6_PRODUTO)) = TO_NUMBER('100'||P.PRODUTO_VOXEL_ID)
	     AND TO_NUMBER(TRIM(C5_XPEDWEB)) = PEDIDO_VOXEL_ID
		 AND TO_NUMBER(TRIM(C5_XPEDOLD)) = PEDIDO_VOXEL_ID
	    AND C5_EMISSAO = TO_CHAR(DATA_PEDIDO,'YYYYMMDD')
	    AND SF2.F2_NFELETR <> ' '
	    AND SC6.%NotDel%
	     )
EndSql

(cAliNFSe)->(DbGoTop())

While (cAliNFSe)->(!EOF())

	Begin transaction
		cScript	:= "UPDATE GENESB.FORUM_PEDIDO_GERENCIAL SET PROTHEUS = 1 WHERE RECNO = "+ cValtochar((cAliNFSe)->RECTMP)
		If TCSQLEXEC(cScript) != 0
			_cErroLg	:= "FALHA AO TENTAR ATUALIZAR A FLAG DE PROCESSAMENTO PARA O PEDIDO "+ cValtochar((cAliNFSe)->NUMPED)
			MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + cValtochar((cAliNFSe)->NUMPED) + "_" + "FALHA_NF_FLAG.txt" , _cErroLg )
			U_GenSendMail(,,,"noreply@grupogen.com.br",_cMailPdForum,oemtoansi("GENI026 - Protheus Faturamento - Pedido Forum - "+cValtochar((cAliNFSe)->NUMPED)),_cErroLg,,,.F.)
		EndIf
	end transaction	

	(cAliNFSe)->(DbSkip())
EndDo

(cAliNFSe)->(DbCloseArea())

Return nil