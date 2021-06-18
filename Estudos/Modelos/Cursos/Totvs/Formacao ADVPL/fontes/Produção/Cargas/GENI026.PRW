#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#DEFINE cEnt Chr(13)+Chr(10)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI026   ºAutor  ³Saturnino - Loop      º Data ³  07/06/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina utilizada para gerar a gravação dos pedidos de vendas	º±±
±±º          ³Integração Pedido de Vendas - Protheus x Oracle(Legado)    	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ 	GEN_PG9CUR													º±±
±±º			 ³ 	GENI026NAT													º±±
±±º			 ³ 	GEN_026CLI													º±±
±±º			 ³ 	GEN_026TES													º±±
±±º			 ³ 	GEN_VIEWPV													º±±
±±º			 ³	GEN_CAMLGC													º±±
±±º			 ³	GEN_FAT026													º±±
±±º			 ³	GEN_FAT26S													º±±
±±º			 ³	MV_XCAMLOG2													º±±
±±º			 ³	MV_XMAIBLK1													º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GENI026()

Local _aArea 		:= GetArea()
Private lDigital	:= .F.

Conout("GENI026 - Inicio da importação de pedido de vendas - ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verificação para saber se a rotina esta sendo chamada pela Schedule³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Prepare Environment Empresa "00" Filial "1022"

	If upper(alltrim(GetEnvServer())) $ "SCHEDULE" //EXECUTA SOMENTE NO AMBIENTE SCHEDULE
		
		If LockByName("GENI026",.T.,.T.,.T.)		
			GENI026A()
			UnLockByName("GENI026",.T.,.T.,.T.)
		Else
			Conout("GENI026 - não foi possível iniciar a rotina pois a mesma já está sendo executada!")
		EndIf
	Endif
	
Reset Environment

RestArea(_aArea)

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI026A  ºAutor  ³Saturnino - Loop      º Data ³  07/06/2017	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para o processamento da integração do pedido de venda	º±±
±±º          ³                                                            	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GENI026A()

Local _aArea 		:= GetArea()
Local _cDescPd		:= ""
Local _nItemC6  	:= 1 //Contador para os itens do pedido de vendas
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

Local _nI           := 0
Local _nTotParc     := 0

Local _cPgtCur		:= "001"
Local _cTes			:= GetMv("GEN_FAT159")
Local _cMailPdForum	:= GetMv("GEN_FAT153")
Local cFORMAPG		:= ""
Local nHdl
Local cCodCli		:= GetMv("GEN_FAT158")
Local cLojaCli		:= ""
Local aUpdFlag		:= {}

Local nDesc			:= 0
Local nValtot		:= 0
Local nValDesc		:= 0
Local nValPrc		:= 0
					
Private _cQuery		:= ""                                
Private _cArqTmp	:= GetNextAlias()
Private _oServer	:= Nil
Private _cFilCont	:= ""
Private _cView		:= "" //Parâmetro que contém o nome da view que será consultada para a criação do Pedido de Vendas
Private _cLogPd		:= "" //Parâmetro que contém o caminho onde será gravado o arquivo de log de inconsistências
Private _aCabPd 	:= {}
Private _aItmPd 	:= {}
Private _alinha		:= {}
Private _cTabela 	:= GetMv("GEN_FAT064")
Private	_cLogPd		:= SUPERGETMV("GEN_FAT154",.T.,"\logsiga\ped_forum\")+"gen_to_forum\" 	 			//Parâmetro que contém o caminho onde será gravado o arquivo de log de inconsistências
Private _cNatCur	:= GetMv("GEN_FAT160")							//GetMv("GENI026NAT") //NATUREZA UNICA PARA CURSOS

cLojaCli	:= Substr(cCodCli,At("/",cCodCli)+1,2)
cCodCli		:= Substr(cCodCli,1,At("/",cCodCli)-1)

SA1->(DbSetOrder(1))
If !SA1->(Dbseek(xFilial("SA1")+PadR(cCodCli,TamSX3("A1_COD")[1])+PadR(cLojaCli,TamSX3("A1_LOJA")[1]) ))
	_cMsg	:= "Cliente padrão LOJA FORUM não localizado no cadastro de clientes, verifique o parametro GEN_FAT153"+cEnt
	cMsg := "GENI026 - IMPORTAÇÃO PEDIDO FORUM" + cEnt
	cMsg += cEnt
	cMsg += _cMsg
	MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL)+"_CLIENTE_PADRAO.txt" , _cMsg )
	U_GenSendMail(,,,"noreply@grupogen.com.br",_cMailPdForum,oemtoansi("GENI026 - Protheus Faturamento - Pedido Forum"),_cMsg,,,.F.)
	Return .f.
EndIf

_cView	:= SUPERGETMV("GEN_FAT157",.T.,"DBA_EGK.TT_I33_PEDIDOS_FORUM")  				//Parâmetro que contém o nome da view que será consultada para a criação do Pedido de Vendas
_lVwWeb := alltrim(_cView) = "DBA_EGK.TT_I33_PEDIDOS_FORUM"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿          
//³ Saturnino - Cria a pasta de log caso a mesma nao exista no StarthPath	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WFForceDir(_cLogPd)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executar limpeza dos logs												³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aDir	:= directory(Alltrim(_cLogPd)+"*")

For _ni:= 1 to Len(_aDir)
	fErase(Alltrim(_cLogPd)+_aDir[_ni][1])
Next _ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿          
//³Conforme levantado será criado uma view disponibilizada no protheus ³
//³que irá conter todos os pedidos que deverão ser importados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cQuery := "SELECT * FROM "+_cView
	
If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqTmp, .F., .T.)

While (_cArqTmp)->(!EOF())

	cChavCli := alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))+" "+alltrim((_cArqTmp)->SKU_CURSO)
	
	Do While cChavCli == alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))+" "+alltrim((_cArqTmp)->SKU_CURSO)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Validação da Trasnportadora, para não realizar o processamento³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cPedWeb := IIF(ValType((_cArqTmp)->C5_XPEDWEB) == "N",alltrim(str((_cArqTmp)->C5_XPEDWEB)),(_cArqTmp)->C5_XPEDWEB)
		_cPedOld := IIF(ValType((_cArqTmp)->C5_XPEDOLD) == "N",alltrim(str((_cArqTmp)->C5_XPEDOLD)),(_cArqTmp)->C5_XPEDOLD)		
		//Rodrigo Mourão - 01/02/2015. Criadas variaveis Tipo e Pedido Web para incluir no nome do arquivo de log.
		_cTipo   := IIF(ValType((_cArqTmp)->C5_TIPO) == "N",alltrim(str((_cArqTmp)->C5_TIPO)),(_cArqTmp)->C5_TIPO)
		_cPedWeb := IIF(ValType((_cArqTmp)->C5_XPEDWEB) == "N",alltrim(str((_cArqTmp)->C5_XPEDWEB)),(_cArqTmp)->C5_XPEDWEB)
		_cFilLog := Alltrim((_cArqTmp)->C5_FILIAL)

					
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Validação de produto, para não realizar o processamento de mais de um item do mesmo produto no pedido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If _lVwWeb
			_cPedWeb := IIF(ValType((_cArqTmp)->C5_XPEDWEB) == "N",alltrim(str((_cArqTmp)->C5_XPEDWEB)),(_cArqTmp)->C5_XPEDWEB)
			_cProduto := alltrim((_cArqTmp)->C6_PRODUTO)

			_cQryPro := "SELECT C5_XPEDWEB, C6_PRODUTO, SUM(C6_QTDVEN) QTD,COUNT(*) ITENS
			_cQryPro += "  FROM " + _cView
			_cQryPro += " WHERE C5_XPEDWEB = '" + _cPedWeb + "'"
			_cQryPro += " 	AND C5_XPEDOLD = '" + _cPedOld + "'"
			_cQryPro += "   AND C6_PRODUTO = '" + _cProduto + "'" 
			_cQryPro += "   AND SKU_CURSO = " + alltrim((_cArqTmp)->SKU_CURSO)						
			_cQryPro += " GROUP BY C5_XPEDWEB,C5_XPEDOLD,C6_PRODUTO

			If Select(_cArqPro) > 0
				dbSelectArea(_cArqPro)
				(_cArqPro)->(dbCloseArea())
			EndIf
			
			dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQryPro), _cArqPro, .F., .T.)
			
			If (_cArqPro)->QTD > 1 .OR. (_cArqPro)->ITENS > 1//(_cArqPro)->(!EOF())
				_cMsg	:= "O Pedido Forum "+_cPedWeb+"/"+_cPedOld+" com itens em duplicidade e/ou quantidade superior a 1 para o mesmo produto"+cEnt
				cMsg := "GENI026 - IMPORTAÇÃO PEDIDO FORUM" + cEnt
				cMsg += cEnt
				cMsg += "O Pedido Forum "+_cPedWeb+"/"+_cPedOld+" com itens em duplicidade e/ou quantidade superior a 1 para o mesmo produto"+ cEnt
				U_GenSendMail(,,,"noreply@grupogen.com.br",_cMailPdForum,oemtoansi("GENI026 - Protheus Faturamento - Pedido Forum"),_cMsg,,,.F.)															
			EndIf
		EndIf
		
		Conout("GENI026A - Analisando pedido "+_cPedWeb)
		
		If Empty(_cMsg)
			_cCod 		:= ""
			
			//-----------------------------------------//
			//Gravando em variável a nova filial logada//
			//-----------------------------------------//
			_cFilCont	:= AllTrim((_cArqTmp)->C5_FILIAL)
			  aUpdFlag	:= {}
			  
			_aCabPd  := {}
			_cPedOld := IIF(ValType((_cArqTmp)->C5_XPEDOLD) == "N",alltrim(str((_cArqTmp)->C5_XPEDOLD)),(_cArqTmp)->C5_XPEDOLD)
						
			aAdd ( _aCabPd , { "C5_CLIENTE" , cCodCli		   							, NIL} )			
			aAdd ( _aCabPd , { "C5_LOJACLI" , cLojaCli						   			, NIL} )			
			aAdd ( _aCabPd , { "C5_TIPO"    , "N"       					   			, NIL} )
			aAdd ( _aCabPd , { "C5_CONDPAG"	, Posicione("SA1",1,xFilial("SA1") + cCodCli + cLojaCli,"A1_CONDPAG")	, NIL} )
			aAdd ( _aCabPd , { "C5_NATUREZ"	, _cNatCur									, NIL} )
			aAdd ( _aCabPd , { "C5_EMISSAO"	, DDataBase	  					 			, NIL} )
			aAdd ( _aCabPd , { "C5_MOEDA" 	, (_cArqTmp)->C5_MOEDA 						, NIL} )
			aAdd ( _aCabPd , { "C5_TIPLIB" 	, "1"										, NIL} )
			aAdd ( _aCabPd , { "C5_XPEDWEB" , _cPedWeb									, NIL} )
			aAdd ( _aCabPd , { "C5_XPEDOLD"	, _cPedOld 									, NIL} )			
			aAdd ( _aCabPd , { "C5_TABELA"  , _cTabela									, NIL} )	
			aAdd ( _aCabPd , { "C5_MENNOTA" , AllTrim((_cArqTmp)->C5_MENNOTA)			, NIL} )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Alimentando informacoes pertinente ao produto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			_nItemC6 := 1 
			_aItmPd := {}

			//Zerando as Variáveis
			_nTotParc := 0
			
			Conout("GENI026A - Montagem do Vetor de Pedido de Vendas - Item")
			
			_cCont 		:= "01"
			While (_cArqTmp)->(!EOF()) .And. _cPedOld == AllTrim(Str((_cArqTmp)->C5_XPEDOLD)) .and. _cCont <= "99";
				.and. cChavCli == alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))+" "+alltrim((_cArqTmp)->SKU_CURSO)
				
				lDigital := (_cArqTmp)->DIGITAL==1
				_alinha  := {}         
				
				Conout("GENI026A - Entrou no While do item pedido de vendas ")
				_cDescPd  := Posicione("SB1",1,xFilial("SB1") + (_cArqTmp)->C6_PRODUTO,"B1_DESC")
				_cLocB1   := IIF(Empty(AllTrim((_cArqTmp)->C6_LOCAL)),Posicione("SB1",1,xFilial("SB1") + (_cArqTmp)->C6_PRODUTO,"B1_LOCPAD"),(_cArqTmp)->C6_LOCAL)
				_cProduto := padr(alltrim((_cArqTmp)->C6_PRODUTO),tamsx3("C6_PRODUTO")[1])
				
		
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
				_cQuery += " AND C5_CLIENTE = '" + cCodCli + "'"
				_cQuery += " AND C5_LOJACLI = '" + cLojaCli + "'"					
				_cQuery += " AND C5_XPEDWEB = '"  + _cPedWeb  + "'"
				_cQuery += " AND C5_XPEDOLD = '"  + _cPedOld  + "'"
				_cQuery += " AND C6_XPEDWEB = '"  + _cPedWeb  + "'"
				_cQuery += " AND C6_PRODUTO = '"  + _cProduto + "'"
				_cQuery += " AND C6_XCURSO = '"  + PadR(Alltrim((_cArqTmp)->SKU_CURSO),TamSX3("C6_XCURSO")[1]) + "'"
				
				If Select(_cArqPd) > 0
					dbSelectArea(_cArqPd)
					(_cArqPd)->(dbCloseArea())
				EndIf

				dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqPd, .F., .T.)

				If ((_cArqPd)->(EOF()) .and. _lVwWeb) .or. !_lVwWeb    
											
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄá
					//³Alimentando os Itens do pedido³              
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄá
                    
					aAdd ( _alinha , { "C6_ITEM"    , _cCont						, NIL} )
					aAdd ( _alinha , { "C6_PRODUTO" , _cProduto						, NIL} )
					aAdd ( _alinha , { "C6_DESCRI"  , _cDescPd  					, NIL} )					
					aAdd ( _alinha , { "C6_QTDVEN"  , (_cArqTmp)->C6_QTDVEN   		, NIL} )
					aAdd ( _alinha , { "C6_QTDLIB"  , (_cArqTmp)->C6_QTDVEN   		, NIL} )										

					SB1->(DbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1")+_cProduto))
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona no cadastro de Tabela de Precos                                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
					DA1->( DbSetOrder(1) )
					DA1->(dbSeek(xFilial("DA1")+_cTabela+_cProduto))					
					
					aAdd ( _alinha , { "C6_RUNIT"	, DA1->DA1_PRCVEN   			, NIL} )
					
					nDesc		:= POSICIONE("SZ2",1,XFILIAL("SZ2")+SA1->A1_XTPDES+SB1->B1_GRUPO,"Z2_PERCDES")									
					nValtot		:= Round((DA1->DA1_PRCVEN*(_cArqTmp)->C6_QTDVEN)-((DA1->DA1_PRCVEN*nDesc)/100)*(_cArqTmp)->C6_QTDVEN,2)
					nValDesc	:= Round((DA1->DA1_PRCVEN*(_cArqTmp)->C6_QTDVEN)-nValtot,2)
					nValPrc		:= nValtot/(_cArqTmp)->C6_QTDVEN
					
					aAdd ( _alinha , { "C6_PRCVEN"  , nValPrc				   		, NIL} )
					aAdd ( _alinha , { "C6_VALOR"   , nValtot    					, NIL} )
					aAdd ( _alinha , { "C6_DESCONT" , nDesc					    	, NIL} )
					aAdd ( _alinha , { "C6_VALDESC" , nValDesc				    	, NIL} )										
					aAdd ( _alinha , { "C6_TES"     , _cTes				      		, NIL} )					
					aAdd ( _alinha , { "C6_LOCAL"   ,  _cLocB1   					, NIL} )
					aAdd ( _alinha , { "C6_ENTREG"  , STOD((_cArqTmp)->C6_ENTREG)	, NIL} )
					aAdd ( _alinha , { "C6_XPEDWEB" , _cPedWeb						, NIL} )
					aAdd ( _alinha , { "C6_XCURSO"	, Alltrim((_cArqTmp)->SKU_CURSO)	, NIL} )
					
					_nValTot += (_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN
					_nTotParc+= ((_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN) - (_cArqTmp)->C6_VALDESC
															
					aAdd(_aItmPd , _alinha)
					
					_nQtdTot += (_cArqTmp)->C6_QTDVEN
					_nItemC6 ++										
					_cCont 	:= soma1(_cCont)
					
					Aadd(aUpdFlag, (_cArqTmp)->RECNO )
					
				EndIF

				(_cArqTmp)->(DbSkip())
				
			EndDo

			If Select(_cArqPd) > 0
				dbSelectArea(_cArqPd)
				(_cArqPd)->(dbCloseArea())
			EndIf
							
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Alimentando o cabeçalho do Pedido de Vendas com as informações customizadas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd ( _aCabPd , { "C5_XQTDTOT"    , _nQtdTot      	, Nil} )
			aAdd ( _aCabPd , { "C5_XVALTOT"    , _nValTot      	, Nil} )
			
			//Zerando as Variáveis
			_nQtdTot := 0
			_nValTot := 0
			

			If Empty(_cMsg)
				If Len(_aItmPd) > 0
					
					GENI026B(_aCabPd,_aItmPd,_cPedOld,_cTipo,_cPedWeb,_cNome,aUpdFlag,_cMailPdForum)
					_cCod := ""       				
					
				Else
					_cMsg := "Erro ao preencher o array de itens do pedido, 'Pedido Web' "+_cPedWeb+" este pedido não foi emitido no Protheus!"
					MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
					(_cArqTmp)->(DbSkip())				
					
				EndIf	
			Else
			    If SubStr(_cMsg,1,1) = 'P'
					MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_PROD_" + AllTrim(_cProduto) +  "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
			    Else
					MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
	    		EndIf
				(_cArqTmp)->(DbSkip())					
			EndIF
		Else
		    If SubStr(_cMsg,1,1) = 'P'
				MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_PROD_" + AllTrim(_cProduto) +  "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI026B  ºAutor  ³Saturnino - Loop    º Data ³  07/06/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsável pela execução do execauto de pedido de   º±±
±±º          ³vendas			                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GENI026B(_aCabPd,_aItmPd,_cPedOld,_cTipo,_cPedWeb,_cNome,aUpdFlag,_cMailPdForum)

Local _aArea 			:= GetArea()
Local _cArqCli			:= GetNextAlias()
Local _cAliSC9 			:= GetNextAlias()
Local _cAliSC6 			:= GetNextAlias()
Local cQueryINS			:= ""
Local _cQuery			:= ""
Local _aAcabC5			:= {}
Local _aItmC6			:= {}

Local _aTmpPV1			:= {}
Local _aPVlNFs			:= {}
Local _nPosLb			:= 0
Local _cParcela 		:= ""
Local cParc1			:= GetMv("MV_1DUP")
Local _nTotTES			:= 0
Local _cMvSeri 			:= Iif(lDigital,"2",Alltrim(GetMv("GEN_FAT003"))) 

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.
Private _aErro			:= {}
Private _cErroLg		:= "" //Variável onde é armazenado o log quer será impresso em um arquivo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ordenando o vetor conforme estrutura da SX3, pois      ³
//³alguns execauto`s realizam validacoes de gatilhos      ³
//³o que pode acabar matando uma informacaao obrigatoria  ³
//³que ja havia sido enviada corretamente no array        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC5")                                 
aSC5SX3 := FWSX3Util():GetAllFields( "SC5", .F. )
//While !EOF() .And. (SX3->X3_ARQUIVO == "SC5")
For nSC5 := 1 To Len(aSC5SX3)
	For _ni := 1 To Len(_aCabPd)
		If AllTrim(aSC5SX3[nSC5]) == Alltrim(_aCabPd[_ni][1])
			aAdd(_aAcabC5,_aCabPd[_ni])
			Exit
		EndIf
	Next _ni
//	dbSelectArea("SX3")
//	dbSkip()
//EndDo
Next nSC5
	
Conout("GENI026B - Execauto de Pedido de Vendas")

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

	For nAuxUpdt := 1 To Len(aUpdFlag)		
		Begin transaction
			cScript	:= "UPDATE GENESB.FORUM_PEDIDO SET ACK2 = 1 WHERE RECNO = "+cValtochar(aUpdFlag[nAuxUpdt])+" AND NUMERO = "+_cPedWeb+" AND ENTITY_ID = "+_cPedOld
			If TCSQLEXEC(cScript) != 0
				_cErroLg	:= "FALHA AO TENTAR ATUALIZAR A FLAG DE PROCESSAMENTO PARA O PEDIDO "+ AllTrim(_cPedWeb)
				MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + "_" + "FALHA_FLAG.txt" , _cErroLg )
				U_GenSendMail(,,,"noreply@grupogen.com.br",_cMailPdForum,oemtoansi("GENI026 - Protheus Faturamento - Pedido Forum"),_cErroLg,,,.F.)
			EndIf
		end transaction
	Next

	Conout("GENI026B - Gerado Pedido de Vendas" + _cPedExc )
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
	
	While !(_cAlias1)->(EOF())
		_nTotTES++
		(_cAlias1)->(DbSkip())
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Rotina para desbloquear credito 											   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Posiciona na SC9 para confirmar que o pedido foi gravado na tabela
	DbSelectArea("SC9")
	DbSetOrder(1)
   
	//Posiciona na SC9 para confirmar que o pedido foi gravado na tabela
	If !DbSeek(xFilial("SC9") + SC5->C5_NUM) .AND. Empty(SC5->C5_BLQ)
		SC6->(DbSetOrder(1))
		SC6->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
		While SC6->(!EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
			
			If !SC9->(dbseek( SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM ))

				/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±							
				±±³Parametros³ExpN1: Registro do SC6                                      ³±±
				±±³          ³ExpN2: Quantidade a Liberar                                 ³±±
				±±³          ³ExpL3: Bloqueio de Credito                                  ³±±
				±±³          ³ExpL4: Bloqueio de Estoque                                  ³±±
				±±³          ³ExpL5: Avaliacao de Credito                                 ³±±
				±±³          ³ExpL6: Avaliacao de Estoque                                 ³±±
				±±³          ³ExpL7: Permite Liberacao Parcial                            ³±±
				±±³          ³ExpL8: Tranfere Locais automaticamente                      ³±±
				±±³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
				±±³          ³       apenas avalia ).                                     ³±±
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
				±±³          ³               ³                                            ³±±
				±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
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
				a450Grava(1,.T.,.T.,.F.)
			Else
				_cErroLg := "Recno nao encontrado na SC9. Verifique se o pedido foi corretamente faturado. Recno SC9: " + cvaltochar((_cAliSC9)->SC9RECNO)
				MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_" + ".txt" , _cErroLg )
			EndIf
			(_cAliSC9)->(DbSkip())
		EndDo

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
						MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(lDigital,"DIG_","IMP_")+ ".txt" , _cErroLg )
						SC9->(DBSKIP())
					Endif
				Else
					_cErroLg := "Pedido com itens SC9 não liberado. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC9->C9_PEDIDO + " Item: " + SC9->C9_ITEM
					MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(lDigital,"DIG_","IMP_")+ ".txt" , _cErroLg )
					SC9->(DBSKIP())
				Endif
			EndDo
			
			If Empty(_cErroLg)			
				_cNotaImp := MaPVlNFs(_aPVlNFs,_cMvSeri,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)				
				_aPVlNFs := {}				
				
				If Empty(_cNotaImp)					
					_cErroLg := "Falha ao gerar nota fiscal. Pedido Protheus: " + SC5->C5_NUM
					MemoWrite ( _cLogPd + DtoS(DDataBase) +"\" + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_" + SC5->C5_NUM+".txt" , _cErroLg )		
					cMsg := SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_" + SC5->C5_NUM + cEnt + _cErroLg		
					U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("GENI026 - Protheus Faturamento - Importação Pedido Forum"),cMsg,,,.F.)										
				EndIf
				
			EndIf			  
						
		EndIf					
	Else
		WFForceDir(_cLogPd + DtoS(DDataBase) +"\")
		_cErroLg := "Pedido não localizado na SC9. Verifique se o pedido foi corretamente liberado. Pedido Protheus: " + SC5->C5_NUM
		MemoWrite ( _cLogPd + DtoS(DDataBase) +"\" + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_" + SC5->C5_NUM+".txt" , _cErroLg )
		
		cMsg := SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_" + SC5->C5_NUM + cEnt + _cErroLg
		
		U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("Protheus Faturamento - Importação Pedido Forum"),cMsg,,,.F.)
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso tenha dado erro irá gerar log ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMsErroAuto
	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + Chr(13)+Chr(10)
	Next _ni
	
	MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) +"_"+ ".txt" , _cErroLg )
	Disarmtransaction()
EndIf

Return()