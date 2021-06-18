#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

#DEFINE cEnt Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA046   ºAutor  ³Helimar Tavares     º Data ³  21/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de Devolução de Ofertas                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA046()

Conout(Time()+ " " + "GENA046 - Inicio - Rotina de Devolução de Ofertas")
//Prepare Environment Empresa "00" Filial "1022"

RpcSetType(2)
lOpenSM0 := RpcSetEnv( "00" , "1022")

If lOpenSM0	                    
	If LockByName("GENA046",.T.,.T.,.T.)
		U_GENA046A()
		UnLockByName("GENA046",.T.,.T.,.T.)
	Else 
		Conout("GENA046 - não foi possível iniciar a rotina pois a mesma já está sendo executada!")
	EndIf
	
	Conout(Time()+ " GENA046 - Fim - Rotina de Devolução de Ofertas")
	
	//Reset Environment
	RpcClearEnv()
EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA046A  ºAutor  ³Helimar Tavares     º Data ³  21/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsável por fazer o filtro das Notas de Entradas º±±
±±º          ³de devolução de oferta para fazer a saida para e empresa    º±±
±±º          ³origem e entrada na mesma.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
Local _aCabDcOr := {} //Vetor contendo o cabeça'lho documento de entrada empresa Origem
Local _alinhaOr := {} //Vetor que recebe os itens do documento de entrada empresa Origem
Local _aItmDcOr := {} //Vetor contendo os itens do documento de entrada empresa Origem
Local _nQuant	:= 0
Local _aCabPv 	:= {} //Geração do cabeçalho Pedido de Vendas no GEN
Local _alinha	:= {} //Geração do Item do Pedido de Vendas no GEN
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

Local _cMvCdPv 	:= GetMv("GEN_FAT106") //Condição de pagamento pedido de venda GEN
Local _cMvTbPr 	:= GetMv("GEN_FAT107") //Tabela de preço pedido de venda GEN
Local _cLogPd	:= GetMv("GEN_FAT095") //Caminho onde será gravado o log de erro
Local _cMvClDe	:= GetMv("GEN_FAT096") //Cliente que será utilizado para realizar as movimentações no GEN
Local _cMvLjDe  := GetMv("GEN_FAT097") //Loja que será utilizada para realizar as movimentações no GEN
Local _cFil		:= GetMv("GEN_FAT098") //Filial correta do GEN onde serão realizadas as movimentações de devolução de oferta
Local _cMvEspc 	:= GetMv("GEN_FAT099") //Especie utilizada na nota de entrada das empresas de Origem
Local _cMvCdDe	:= GetMv("GEN_FAT100") //Condição de pagamento utilizada na nota de entrada das empresas de Origem
Local _cMvSeri 	:= GetMv("GEN_FAT101") //Série utilizada nas notas de saída e entrada no GEN e empresas de Origem
Local _cTesCRMOr:= GetMv("GEN_FAT102") //TES utilizado na nota de entrada das empresas Origem, dev. oferta CRM
Local _cTesDAOr	:= GetMv("GEN_FAT103") //TES utilizado na nota de entrada das empresas Origem, dev. oferta DA
Local _cTesCRMPv:= GetMv("GEN_FAT104") //TES utilizado no Pedido de Vendas do GEN, dev. oferta CRM
Local _cTesDAPv	:= GetMv("GEN_FAT105") //TES utilizado no Pedido de Vendas do GEN, dev. oferta DA

Local _cServ 	:= GETMV("GEN_FAT027") //Ip do servidor para realizar as mudanças de ambiente
Local _nPort  	:= GETMV("GEN_FAT028") //Porta para realizar as mudanças de ambiente
Local _cAmb  	:= GETMV("GEN_FAT029") //Ambiente a ser utilizado para realizar as mudanças de filial

Local lConsMes	:= GETMV("GEN_FAT121") == "S" // considera mês atual no filtro de notas de devolução de oferta
Local nDiasMen	:= SuperGetMv("GEN_FAT148",.F.,7)

Local lPedido	:= .T.
Local cPedido	:= ""

Local nVldDesc	:= 0
Local nPerDesc	:= 0
Local nVldDesc	:= 0
					
WFForceDir(_cLogPd)
WFForceDir(_cLogPd+DtoS(DDataBase)+"\")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executar limpeza dos logs ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aDir := directory(Alltrim(_cLogPd)+"*")
For _ni:= 1 to Len(_aDir)
	fErase(Alltrim(_cLogPd)+_aDir[_ni][1])
Next _ni

conout(Time()+ " " + "GENA046A - Inicio - Verificando Itens da Nota de Entrada")

tcSqlExec("UPDATE "+RetSqlName("SB1")+" SET B1_DESC = REPLACE(B1_DESC,'|','/') WHERE B1_DESC LIKE '%|%'") //TROCA "|" POR "/" NA DESCRICAO DOS PRODUTOS PARA NAO GERAR ERRO NA ROTINA GRAVAARQ/LEARQ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pegando Informacoes do GEN atraves dos parametros para ser utilizado no pedido de vendas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA1")
DbSetORder(1)
If !DbSeek(xFilial("SA1")+PADR(AllTrim(_cMvClDe),TAMSX3("A1_COD")[1])+PADR(AllTrim(_cMvLjDe),TAMSX3("A1_LOJA")[1]))
	_cMsg := "Não foi encontrado no sistema o cliente cadastrado nos parametros de Devolução de Oferta." + cEnt
	_cMsg += "Cliente: " + AllTrim(_cMvClDe) + " loja: " + AllTrim(_cMvLjDe) + cEnt
	_cMsg += "Favor verificar os parametros: GEN_FAT096 e GEN_FAT097" + cEnt
	conout(Time()+ " " + _cMsg)
	MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "DevoluçãoOferta.txt" , _cMsg )
Else
	_cCliGen := SA1->A1_COD
	_cLojGen := SA1->A1_LOJA
	_cTrpGen := SA1->A1_TRANSP
	_cTipGen := SA1->A1_TIPO
	_cVenGen := SA1->A1_VEND
	
	DbSelectArea("SA2")
	DbSetOrder(3)
	If !DbSeek(xFilial("SA2")+SA1->A1_CGC)
		_cMsg := "Não foi encontrado no sistema associação do Cliente com o Fornecedor através do CGC cadastrado nos parametros de devolução de oferta." + cEnt
		_cMsg += "Cliente: " + AllTrim(_cMvClDe) + " loja: " + AllTrim(_cMvLjDe) + cEnt
		_cMsg += "Favor verificar os parametros: GEN_FAT096 e GEN_FAT097" + cEnt
		conout(Time()+ " " + _cMsg)
		MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "DevoluçãoOferta.txt" , _cMsg )
	Else
		
		_cFnGen := SA2->A2_COD
		_cLjGen := SA2->A2_LOJA
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa doc. entrada dev. oferta ainda não devolvidos para a empresa oritem ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
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
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ponterando no Fornecedor para realizar a busca na SM0 (Cadastro de Empresas), realizando assim    ³
				//³uma nova conexão na empresa em que será gerado a Nota de entrada e Pedido de Vendas/Nota de Saída ³
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SA2")
				DbSetOrder(1)
				If !DbSeek(xFilial("SA2")+(_cAliQry)->B1_PROC+(_cAliQry)->B1_LOJPROC)
					_cMsg := "Não foi encontrado no sistema fornecedor com o código: " + (_cAliQry)->B1_PROC + " e loja: " + (_cAliQry)->B1_LOJPROC  + ", vinculados ao produto: " + (_cAliQry)->D1_COD
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
					_cMsg := "Não foi encontrado no sistema Cliente com o CNPJ: " + _cCGCOr
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
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ponterando na SM0 para pegar o CNPJ correto e realzar o ponteramento ³
				//³na empresa que será gravada a Nota                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se achar a empresa correta realiza a movimentação ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !_lEmp
					_cMsg := "Não foi encontrado no sistema empresa (SM0) com o CNPJ: " + SA2->A2_CGC
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + ".txt" , _cMsg )
					(_cAliQry)->(DbSkip())
					Loop
				EndIf
			EndIf
				
			_aCabPv		:= {}
			_aFlgView	:= {}
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Array contendo o cabeçalho do pedido de vendas no GEN ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Array contendo o cabeçalho da nota de entrada para a Origem ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			_aCabDcOr := {} //Vetor contendo o cabeçalho documento de entrada empresa Origem
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
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Validando a quantidade correta a ser usada nas notas ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
	            _cProd   := (_cAliQry)->D1_COD
	            _cDscPro := (_cAliQry)->B1_DESC
				
				//PRODUTOS BLQUEADOS
				If (_cAliQry)->B1_MSBLQL == '1'
					_cMsg := "Produto bloqueado (B1_MSBLQL) não será considerado na devolução: " + Alltrim(_cProd)
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod Blq "  + AllTrim(_cProd) + ".txt" , _cMsg )
					(_cAliQry)->(DbSkip())
					Loop
				Endif
				
				 _aEstoque := CalcEst(AllTrim(_cProd),"01",DDataBase)               
				
				If !SB2->(DbSeek( xFilial("SB2")+padr(_cProd,TAMSX3("B2_COD")[1])+"01" ))// .OR. _aEstoque[1] <= 0// .AND. SB2->B2_QATU < _nQuant
					_cMsg := "Sem saldo no armazem 01, não será considerado na devolução: " + Alltrim(_cProd)
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Saldo Prod "  + AllTrim(_cProd) + ".txt" , _cMsg )
					(_cAliQry)->(DbSkip())
					Loop
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Pegando o último custo do produto ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
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
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Validando se a tabela de preço possui o produto selecionado ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea("DA1")
					DbSetOrder(1)
					If !DbSeek(xFilial("DA1")+_cMvTbPr+_cProd)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Função para alimentar Log de erro ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						_cMsg := "Não foi encontrado no sistema tabela de preço/produto com os códigos: " + AllTrim(_cMvTbPr) + " / " + AllTrim(_cProd)
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
					_cMsg := "Produto com custo e preçco de venda zero (0), não será considerado na devolução: " + Alltrim(_cProd)
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
						_cMsg := "saldo insuficiente no armazem 01 para atender o documento"+(_cAliQry)->D1_DOC+"-"+(_cAliQry)->D1_SERIE+", não será considerado na devolução: " + Alltrim(_cProd)
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
					//_cAliQry)->(DbSkip()) não precisa do DBSkip pois o loop do registro já foi feito na validação anterior
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

				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Array contendo a linha do pedido de vendas GEN ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Array contendo os itens do Documento de Entrada empresa Origem ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Calcular oos campos customizados de quantidade e valor total empresa Origem ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_nQdTtOr += _nQuant
				_nVlTtOr += (_nQuant * _nCusto)
				
				_nContOr ++
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Calcular os campos customizados de quantidade e valor total GEN ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_nQtdTot += _nQuant
				_nValTot += (_nQuant * _nCusto)
			EndDo
			
			If Len(_aItmPv) > 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Alimentando o cabeçalho do Pedido de Vendas com as informações customizadas ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aAdd (_aCabPv, {"C5_XQTDTOT"	, _nQtdTot  , Nil})
				aAdd (_aCabPv, {"C5_XVALTOT"	, _nValTot	, Nil})
				
				//Zerando as Variáveis
				_nQtdTot := 0
				_nValTot := 0
				_nQdTtOr := 0
				_nVlTtOr := 0
				
				//Realizando a geração da Nota de Saída para devolução de Consignação
				//na empresa Matriz (GEN)
				lPedido	:= .T.
				cPedido	:= ""
				_cNtDvCon := U_GENA046B(_aCabPv,_aItmPv,@lPedido,@cPedido)

				If lPedido
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Grava na view 'TT_I11_FLAG_VIEW' documento, série e produto ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					For _ni := 1 To Len(_aFlgView)
						cQueryINS := " INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) VALUES ('SD1000','D1_DOC||D1_SERIE||D1_COD||D1_FORNECE','"+ALLTRIM(_aFlgView[_ni][1])+ALLTRIM(_aFlgView[_ni][2])+ALLTRIM(_aFlgView[_ni][3])+ALLTRIM(_aFlgView[_ni][4])+"','"+_cFil+"')"
						TCSqlExec(cQueryINS)
						cQueryINS := " INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) VALUES ('SD1XSC5','D1_DOC||D1_SERIE||D1_COD||D1_FORNECE||C5_NUM','"+ALLTRIM(_aFlgView[_ni][1])+ALLTRIM(_aFlgView[_ni][2])+ALLTRIM(_aFlgView[_ni][3])+ALLTRIM(_aFlgView[_ni][4])+cPedido+"','"+_cFil+"')"						
						TCSqlExec(cQueryINS)
					Next _ni				
				EndIf
				
				If !Empty(_cNtDvCon)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Realizando a nova conexão para entrar na empresa e filial correta ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ValType(_oServer) == "O"
						//Fecha a Conexao com o Servidor
						RESET ENVIRONMENT IN SERVER _oServer
						CLOSE RPCCONN _oServer
						_oServer := Nil
					EndIf
					
					conout(Time()+ " " + "GENA046 - Início do RPC para logar na empresa origem Nota de Entrada")
					conout(Time()+ " " + "GENA046 - Empresa: " + _cEmpCd + " Filial: " + _cEmpFl)
					
					_cTemp1 := U_GravArq1(_aItmPv)
					_cTemp2 := U_GravArq1(_aItmDcOr)
					
					CREATE RPCCONN _oServer ON  SERVER _cServ 			;   //IP do servidor
					PORT  _nPort           								;   //Porta de conexão do servidor
					ENVIRONMENT _cAmb       							;   //Ambiente do servidor
					EMPRESA _cEmpCd          							;   //Empresa de conexão
					FILIAL  _cEmpFl          							;   //Filial de conexão
					TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que serão abertas
					MODULO  "SIGACOM"     		          					//Módulo de conexão
					
					If ValType(_oServer) == "O"
						_oServer:CallProc("RPCSetType", 2)
						_cNotaImp := ""
						_cNotaImp := _oServer:CallProc("U_GENA046C",_aCabPv,_cTemp1,_aCabDcOr,_cTemp2,_cNtDvCon,dDatabase)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Realizando a nova conexão para entrar na empresa e filial correta ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
						conout(Time()+ " " + "GENA046 - Não foi possível logar. Retorno para empresa origem não executado.")
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA046B  ºAutor  ³Helimar Tavares     º Data ³  21/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsável por gerar a Nota Fiscal de Saída para    º±±
±±º          ³devolução de Oferta                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
Local _cLogPd			:= GetMv("GEN_FAT095") //Contém o caminho que será gravado o log de erro
Local _cMvSeri 			:= GetMv("GEN_FAT101") //SERIE nota de saída
Local _cMvEsp			:= GetMv("MV_ESPECIE") //Contem tipos de documentos fiscais utilizados na emissao de notas fiscais
Local _aPosEsp 			:= {}
Local _nMvEsp 			:= 0
Local _lEspec			:= .F.

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponteramento nas tabelas para não ocorrer erro no execauto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SA1")
DbSelectArea("SA2")

DbSelectArea("SC5")
DbSetOrder(1)

conout(Time()+ " " + "GENA046B - Rotina para execução do Execauto de Geração do Pedido de Vendas e de Geração do Documento de Saída, empresa GEN")

Pergunte("MTA440",.F.)
MV_PAR02	:= 2
lLiber	:= .F.
	
lMsErroAuto := .F.
MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,3)

If !lMsErroAuto
	cPedido	:= SC5->C5_NUM
	lPedido	:= .T.
	
	conout(Time()+ " " + "GENA046B - Gerou com sucesso o pedido, irá ver se existe a necessidade de desbloquear por crédito no GEN")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicio Rotina para desbloquear crédito para que o pedido seja faturado sem problemas ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³se a quantidade liberada não for a mesma que a do pedido³
	//³eu estorno tudo e forço a liberação integral.           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

				/*±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
				±±³Funcao    ³MaLibDoFat³ Autor ³Eduardo Riera          ³ Data ³09.03.99 ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
				±±³Descri+.o ³Liberacao dos Itens de Pedido de Venda                      ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
				±±³Retorno   ³ExpN1: Quantidade Liberada                                  ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
				±±³Transacao ³Nao possui controle de Transacao a rotina chamadora deve    ³±±
				±±³          ³controlar a Transacao e os Locks                            ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
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
		conout(Time()+ " " + "GENA046B - Ira varrer a SC9 para realizar o desbloqueio por crédito no GEN")

		Pergunte("MTA440",.F.)
		MV_PAR02	:= 2
		lLiber	:= .F.
		
		While ( (_cAliSC9)->(!Eof()) .And. (_cAliSC9)->C9_FILIAL == xFilial("SC9") .And. (_cAliSC9)->C9_PEDIDO == SC5->C5_NUM .And. Eval(bValid) )
			SC9->(DbGoTo((_cAliSC9)->SC9RECNO))
			If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .OR. (SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .OR.;
				SC9->C9_BLCRED=="09" )
				conout(Time()+ " " + "GENA046B - Liberação de Crédito do Pedido de Vendas no GEN")
				
				/*/
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				±±³          ³Rotina de atualizacao da liberacao de credito                ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
				±±³Parametros³ExpN1: 1 - Liberacao                                         ³±±
				±±³          ³       2 - Rejeicao                                          ³±±
				±±³          ³ExpL2: Indica uma Liberacao de Credito                       ³±±
				±±³          ³ExpL3: Indica uma liberacao de Estoque                       ³±±
				±±³          ³ExpL4: Indica se exibira o help da liberacao                 ³±±
				±±³          ³ExpA5: Saldo dos lotes a liberar                             ³±±
				±±³          ³ExpA6: Forca analise da liberacao de estoque                 ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
				±±³Descri‡„o ³Esta rotina realiza a atualizacao da liberacao de pedido de  ³±±
				±±³          ³venda com base na tabela SC9.                                ³±±
				ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
				/*/
				//a450Grava(1,.T.,.F.,.F.)
				a450Grava(1,.T.,.T.,.F.)  //04/02 - RAFAEL LEITE - EFETUA TAMBEM A LIBERACAO DE ESTOQUE
				
			EndIf
			(_cAliSC9)->(DbSkip())
		EndDo
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fim    Rotina para desbloquear crédito para que o pedido seja faturado sem problemas ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicio - Caso tenha ocorrido com sucesso a geração do Pedido de Vendas, irá iniciar a geração da Nota ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SC9")
	DbSetOrder(1)
	If DbSeek(xFilial("SC9")+SC5->C5_NUM)
		
		_cPedExc := SC9->C9_PEDIDO
		conout(Time()+ " " + "GENA046B - Inicio da Geração do Documento de Saída no GEN.")
		
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
		
		conout(Time()+ " " + "GENA046B - Irá realizar a geração da nota de saída no GEN")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Rotina utilizada para realizar a geração da Nota de Saída ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Validação da especie para a nota³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Varrendo o vetor que contem as séries para saber se a série contida ³
		//³no parametro esta correta.                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
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
			_cMsg := "A Nota não foi gerada, pois a série não está preenchida corretamente." + cEnt
			_cMsg += "Favor revisar o parâmetro GEN_FAT003." + cEnt
			conout(Time()+ " " + _cMsg)
			MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )
			
		Elseif !_nConfLib == _nConfVen //04/02 - RAFAEL LEITE
			
			_cNotaImp := ""
			_cMsg := "A quantidade liberada está diferente da informada no pedido." + cEnt
			conout(Time()+ " " + _cMsg)
			MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso a nota não seja gerada irá chamar a rotina de erro ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(AllTrim(_cNotaImp))
			conout(Time()+ " " + "GENA046B - Geração do Documento de Saída no GEN apresentou erro .")
			//_cPedExc := SC9->C9_PEDIDO
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Chamando o Execauto de Alteração e em seguida o de exclusão ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Alterando a quantidade liberada ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For _ni := 1 To Len(_aItmPv)
				_aItmPv[_ni][_nPosLb][2] := 0
			Next _ni
			
			conout(Time()+ " " + "GENA046B - Irá alterar o pedido de vendas para poder realizar a exclusão no GEN")			
			lMsErroAuto := .F.
			aAdd ( _aCabPv , { "C5_NUM"    , SC5->C5_NUM     	, Nil} )
			MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,4)
			
			If !lMsErroAuto
				conout(Time()+ " " + "GENA046B - Alterou o pedido de vendas com sucesso, irá realizar a exclusão no GEN")
				
				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,5)
				
				If !lMsErroAuto
					lPedido := .F.
					conout(Time()+ " " + "GENA046B - Excluiu com sucesso o pedido de vendas no GEN")
					
					_cErroLg += "  " + cEnt
					_cErroLg += " O Pedido: " + _cPedExc + " foi excluído com sucesso. "  + cEnt
					_cErroLg += " Favor verificar o pedido: "  + cEnt
					_cErroLg += " Pois ele teve que ser excluído uma vez que o Documento de Saída não foi gerado corretamente. " + cEnt
					_cErroLg += " Favor verificar a geração do Documento de Saída, pois houve erro no processo. " + cEnt
					_cErroLg += " " + cEnt
					MemoWrite ( _cLogPd + "Emp" +SM0->M0_CODIGO + "_Fil_"+ AllTrim(SM0->M0_CODFIL) + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cErroLg )
				Else
					lPedido	:= .T.
					conout(Time()+ " " + "GENA046B - Não conseguiu excluir o pedido de vendas no GEN")
					
					_aErro := GetAutoGRLog()
					For _ni := 1 To Len(_aErro)
						_cErroLg += _aErro[_ni] + cEnt
					Next _ni
					
					_cErroLg += "  " + cEnt
					_cErroLg += " O Pedido: " + _cPedExc + " não pode ser excluído. "  + cEnt
					_cErroLg += " Favor verificar o pedido: "  + cEnt
					_cErroLg += " pois ele deve ser excluído uma vez que o Documento de Saída não foi gerado corretamente. " + cEnt
					_cErroLg += " Favor verificar a geração do Documento de Saída, pois houve erro no processo. " + cEnt
					_cErroLg += " " + cEnt
					MemoWrite ( _cLogPd +DtoS(DDataBase)+ "\Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cErroLg )
				EndIf
			Else
				lPedido	:= .T.
				conout(Time()+ " " + "GENA046B - Não conseguiu alterar o pedido de vendas no GEN")
				
				_aErro := GetAutoGRLog()
				For _ni := 1 To Len(_aErro)
					_cErroLg += _aErro[_ni] + cEnt
				Next _ni
				
				_cErroLg += "  " + cEnt
				_cErroLg += " O Pedido: " + SC9->C9_PEDIDO + " não pode ser alterado para prosseguir com a exclusão. "  + cEnt
				_cErroLg += " Favor verificar o pedido: "  + cEnt
				_cErroLg += " pois ele deve ser excluído uma vez que o Documento de Saída não foi gerado corretamente. " + cEnt
				_cErroLg += " Favor verificar a geração do Documento de Saída, pois houve erro no processo. " + cEnt
				_cErroLg += " " + cEnt
				MemoWrite ( _cLogPd +DtoS(DDataBase)+ "\Emp" + _cEmp + "_Fil_"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cErroLg )
			EndIf
		EndIf
	EndIf
Else
	lPedido	:= .F.
	conout(Time()+ " " + "GENA046B - Não conseguiu gerar o Pedido de Vendas no GEN")
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA046C  ºAutor  ³Helimar Tavares     º Data ³  21/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina que irá gerar a Nota fiscal de entrada para devolucaoº±±
±±º          ³da oferta e a Nota Fiscan de Entrada.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
Local _cLogPd			:= GetMv("GEN_FAT095")+DtoS(DDataBase)+"\" //Contém o caminho que será gravado o log de erro
Local _cMvSeri 			:= GetMv("GEN_FAT101") //SERIE nota de saída
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

conout(Time()+ " " + "GENA046C - Rotina de Geração da Nota Fiscal de Entrada (Devolução de Oferta)")
conout(Time()+ " " + "GENA046C - Primeiro a Geração da Nota Fiscal de Entrada (Devolução de Oferta)")

DbSelectArea("SA1")
DbSelectArea("SA2")

aAdd( _aCabDcOr, { "F1_DOC" ,_cNtDvCon })
MSExecAuto({|x,y,z|MATA103(x,y,z)},_aCabDcOr, _aItmDcOr,3)

If lMsErroAuto
	_lRet := .F.
	conout(Time()+ " " + "GENA046C - Não conseguiu gerar a Nota Fiscal de Entrada (Devolução de Oferta) na empresa origem. ")
	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + cEnt
		conout(_cErroLg)
	Next _ni
	MemoWrite ( _cLogPd + "Emp" + _cEmp + "_Fil_" + _cFil + "_" + DTOS(ddatabase) + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraDocEntrada.txt" , _cErroLg )
	U_GenSendMail(,,,"noreply@grupogen.com.br",cDest+";cleuto.lima@grupogen.com.br","Protheus - Processo Devolução de Oferta - Erro documento de entrada",_cErroLg,,,.F.)
	Disarmtransaction()
Else
	_cNotaImp	:= _cNtDvCon
	If !Empty(cDest)
		cMsg := "GENA046 - DEVOLUÇÃO DE OFERTA" + cEnt
		cMsg += cEnt
		cMsg += "Foi gerado o documento de saída "+_cNtDvCon+"/"+_cMvSeri+" com "+cValToChar(len(_aItmDcOr))+" registro(s) para a empresa "+SM0->M0_CODFIL+" - "+alltrim(SM0->M0_NOMECOM) + cEnt
		U_GenSendMail(,,,"noreply@grupogen.com.br",cDest,"Protheus Faturamento - Processo Devolução de Oferta",cMsg,,,.F.)
	Endif	
EndIf

RestArea(_aArea)

Return(_cNotaImp)
