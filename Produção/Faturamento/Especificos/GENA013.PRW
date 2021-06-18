#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

#DEFINE cEnt Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA013   ºAutor  ³ Joni Fujiyama      º Data ³  15/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de Acerto de Consignação com Cliente criará automati-º±±
±±ºDesc.     ³camente o Pedido de Venda e o Documento de Saída            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA013()

Local _cMvTsPd	:= GetMv("GEN_FAT068")		//TES de saída para o acerto de clientes
Local _cMvTbPr	:= GetMv("GEN_FAT069")		//Tabela de preço padrão
Local _cMvSeri	:= GetMv("GEN_FAT070")		//Serie da nota fiscal de saída
Local _cFILLIB	:= GetMV("GEN_FAT071")		//Filiais que serão consideradas para processamento '1001','1012','1021',1022'
Local _cArmUti	:= GetMv("GEN_FAT072")		//Armazem utilizado da nota fiscal de saída
Local _cTESGEN	:= GetMv("GEN_FAT073")		//TES consideradas na nota de entrada
Local _aCabPv	:= {}
Local _aItmPv	:= {}
Local _aItAlt	:= {}
Local _aLinha	:= {}
Local _aPVlNFs	:= {}
Local _aTmpPV1	:= {}
Local _cSQL		:= ""
Local _cQuery	:= ""
Local _cAlias1	:= ""
Local _cAlias2	:= ""
Local _cAliSC6	:= GetNextAlias()
Local _cAliSC9 	:= GetNextAlias()
Local _DescProd	:= ""
Local _LocPad	:= ""
Local _cTipoNF	:= "B"
Local _cAlias0	:= ""
Local _cCont 	:= "01"
Local cNaturez	:= GETMV("GEN_FAT177")

Private _cErroLg		:= "" //Variável onde é armazenado o log quer será impresso em um arquivo

_cSQL := "SELECT 1 AS CAMPO
_cSQL += " FROM " + RetSqlName("SD1") + " SD1
_cSQL += " WHERE SD1.D1_FILIAL = '" + SF1->F1_FILIAL + "'
_cSQL += " AND SD1.D1_DOC = '" + SF1->F1_DOC + "'
_cSQL += " AND SD1.D1_SERIE = '" + SF1->F1_SERIE + "'
_cSQL += " AND SD1.D1_FORNECE = '" + SF1->F1_FORNECE + "'
_cSQL += " AND SD1.D1_LOJA = '" + SF1->F1_LOJA + "'
_cSQL += " AND SD1.D1_TIPO = '"+ _cTipoNF +"'
_cSQL += " AND SD1.D1_TES IN (" + _cTESGEN + ")
_cSQL += " AND SD1.D1_FILIAL IN (" + _cFILLIB + ")
_cSQL += " AND SD1.D_E_L_E_T_ = ' '
_cSQL += " ORDER BY SD1.D1_ITEM"

_cAlias0 := GetNextAlias()

If Select(_cAlias0) > 0
	dbSelectArea(_cAlias0)
	(_cAlias0)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias0, .F., .T.)

//Caso nota tenha acerto com cliente, executa rotina para criação de nota de saida
If (_cAlias0)->CAMPO == 1
	
	// Buscar o cliente
	_cSQL := "SELECT *
	_cSQL += " FROM " + RetSqlName("SA1") + " SA1
	_cSQL += " WHERE SA1.A1_FILIAL = '" + XFILIAL("SA1") + "'
	_cSQL += " AND SA1.A1_COD = '" + SF1->F1_FORNECE + "'
	_cSQL += " AND SA1.A1_LOJA = '" + SF1->F1_LOJA + "'
	_cSQL += " AND SA1.D_E_L_E_T_ = ' '
	
	_cAlias2 := GetNextAlias()
	
	If Select(_cAlias2) > 0
		dbSelectArea(_cAliaS2)
		(_cAlias2)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias2, .F., .T.)
	
	//Se o parâmetro estiver em branco, abre tela para o usuário selecionar a tabela
	If Empty(_cMvTbPr)		
		_cMvTbPr := U_GENA013A((_cAlias2)->A1_COND)
	Endif
	
	//Carrega dados para o cabeçalho do pedido
	aAdd ( _aCabPv , { "C5_TIPO"    , "N"     				, Nil} )
	aAdd ( _aCabPv , { "C5_CLIENTE" , SF1->F1_FORNECE  		, Nil} )
	aAdd ( _aCabPv , { "C5_LOJACLI" , SF1->F1_LOJA  		, Nil} )
	aAdd ( _aCabPv , { "C5_CLIENT"  , SF1->F1_FORNECE 		, Nil} )
	aAdd ( _aCabPv , { "C5_LOJAENT" , SF1->F1_LOJA			, Nil} )
	aAdd ( _aCabPv , { "C5_TRANSP"  , (_cAlias2)->A1_TRANSP	, Nil} )
	aAdd ( _aCabPv , { "C5_TIPOCLI" , (_cAlias2)->A1_TIPO	, Nil} )
	aAdd ( _aCabPv , { "C5_TPFRETE" , (_cAlias2)->A1_TPFRET	, Nil} )
	aAdd ( _aCabPv , { "C5_CONDPAG" , (_cAlias2)->A1_COND	, Nil} )
	aAdd ( _aCabPv , { "C5_TABELA"  , _cMvTbPr				, Nil} )
	aAdd ( _aCabPv , { "C5_EMISSAO" , dDatabase				, Nil} )
	aAdd ( _aCabPv , { "C5_MOEDA" 	, 1						, Nil} )
	aAdd ( _aCabPv , { "C5_TPLIB" 	, "2"					, Nil} )

	aAdd ( _aCabPv , { "C5_NATUREZ" , cNaturez				, Nil} )
	
	
	If Select(_cAlias2) > 0
		dbSelectArea(_cAliaS2)
		(_cAlias2)->(dbCloseArea())
	EndIf
	
	//Carrega dados para os itens do pedido
	_cSQL := "SELECT SD1.*, nvl(D2_DESC,0) D2_DESC
	_cSQL += " FROM " + RetSqlName("SD1") + " SD1
	_cSQL += " LEFT JOIN " + RetSqlName("SD2") + " SD2 ON SD2.D2_FILIAL = '"+xFilial("SD2")+"' AND SD2.D2_DOC = SD1.D1_NFORI AND SD2.D2_SERIE = SD1.D1_SERIORI AND SD2.D2_ITEM = SD1.D1_ITEMORI AND SD2.D_E_L_E_T_= ' '
	_cSQL += " WHERE SD1.D1_FILIAL = '" + SF1->F1_FILIAL + "'
	_cSQL += " AND SD1.D1_DOC = '" + SF1->F1_DOC + "'
	_cSQL += " AND SD1.D1_SERIE = '" + SF1->F1_SERIE + "'
	_cSQL += " AND SD1.D1_FORNECE = '" + SF1->F1_FORNECE + "'
	_cSQL += " AND SD1.D1_LOJA = '" + SF1->F1_LOJA + "'
	_cSQL += " AND SD1.D1_TIPO = '" + SF1->F1_TIPO + "'
	_cSQL += " AND SD1.D_E_L_E_T_= ' '
	_cSQL += " ORDER BY SD1.D1_ITEM"
	
	_cAlias1 := GetNextAlias()
	
	If Select(_cAlias1) > 0
		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias1, .F., .T.)
	
	//Adiciona todos os itens encotrados na nota
	Do While (_cAlias1)->(! EOF())
		
		DBSelectArea("SB1")
		DBSetOrder(1)
		IF DBSeek(xFilial("SB1")+(_cAlias1)->D1_COD)
			_DescProd := SB1->B1_DESC
		Else
			Conout("GENA013 - Descrição do produto não encontrado")
		Endif
		dbSelectArea(_cAlias1)
		
		//_LocPad := Posicione("SB1",2,xFilial("SB1")+(_cAlias1)->D1_COD ,"B1_LOCPAD")
		_aLinha	:= {}
		_aLiAlt	:= {}
		
		//aAdd ( _alinha 	, 	{ "C6_ITEM"    	, STRZERO(val((_cAlias1)->D1_ITEM),TAMSX3("C6_ITEM")[1])	, Nil})
		aAdd ( _alinha 	, 	{ "C6_ITEM"    	, _cCont												, Nil})
		aAdd ( _alinha 	, 	{ "C6_PRODUTO" 	, (_cAlias1)->D1_COD 									, Nil})
		aAdd ( _alinha 	, 	{ "C6_DESCRI"  	, _DescProd			 									, Nil})
		aAdd ( _alinha 	, 	{ "C6_QTDVEN"  	, (_cAlias1)->D1_QUANT  								, Nil})
		aAdd ( _alinha 	, 	{ "C6_DESCONT"	, (_cAlias1)->D2_DESC									, Nil})
		aAdd ( _alinha 	, 	{ "C6_PRCVEN"  	, (_cAlias1)->D1_VUNIT									, Nil})
		aAdd ( _alinha 	, 	{ "C6_VALOR"   	, (_cAlias1)->D1_QUANT * (_cAlias1)->D1_VUNIT			, Nil})
		aAdd ( _alinha 	, 	{ "C6_QTDLIB"  	, (_cAlias1)->D1_QUANT									, Nil})
		aAdd ( _alinha 	, 	{ "C6_TES"     	, _cMvTsPd     		   									, Nil}) //TES diferente
		aAdd ( _alinha 	, 	{ "C6_LOCAL"   	, _cArmUti					   							, Nil})
		aAdd ( _alinha 	, 	{ "C6_ENTREG"	, dDataBase				   								, Nil})
		
		aAdd ( _alialt 	, 	{ "C6_ITEM"    	, _cCont												, Nil})
		aAdd ( _alialt 	, 	{ "C6_DESCONT"	, (_cAlias1)->D2_DESC									, Nil})
		aAdd(_aItAlt , _alialt  )

		aAdd(_aItmPv , _alinha  )
		_cCont := soma1(_cCont)
		
		(_cAlias1)->(DbSkip())
	Enddo
	
	If Select(_cAlias1) > 0
		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	EndIf
	
	//Cria pedido de venda
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,3)

	//Pedido criado com sucesso
	If !lMsErroAuto
		
		//aAdd ( _aCabPv , { "C5_NUM" 	, SC5->C5_NUM	, Nil} )
		//MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItAlt,4)
		
		/*
		
		//Efetua a liberação do pedido de venda
		DbSelectArea("SC9")
		DbSetOrder(1)
		If DbSeek(xFilial("SC9") + SC5->C5_NUM)
		
		bValid := {|| .T.}
		
		_cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_BLCRED,R_E_C_N_O_ SC9RECNO
		_cQuery += " FROM "+RetSqlName("SC9")+" SC9
		_cQuery += " WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND
		_cQuery += " SC9.C9_PEDIDO = '"+SC5->C5_NUM+"' AND
		_cQuery += " (SC9.C9_BLEST <> '  ' OR
		_cQuery += " SC9.C9_BLCRED <> '  ' ) AND
		_cQuery += " SC9.C9_BLCRED NOT IN('10','09') AND
		_cQuery += " SC9.C9_BLEST <> '10' AND
		_cQuery += " SC9.D_E_L_E_T_ = ' '
		
		_cAliSC9 := GetNextAlias()
		
		If Select(_cAliSC9) > 0
		dbSelectArea(_cAliSC9)
		(_cAliSC9)->(dbCloseArea())
		EndIf
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliSC9,.T.,.T.)
		
		//Conout("GENA013 - Ira varrer a SC9 para realizar o desbloqueio por crédito na empresa Matriz (GEN)")
		
		//Efetua o desbloqueio do pedido de venda
		Do While ( (_cAliSC9)->(!Eof()) .And. (_cAliSC9)->C9_FILIAL == xFilial("SC9") .And. (_cAliSC9)->C9_PEDIDO == SC5->C5_NUM .And. Eval(bValid) )
		
		If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .OR. (SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .OR. SC9->C9_BLCRED=="09" )
		
		//Conout("GENA013 - Liberação de Crédito do Pedido de Vendas")
		
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
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
		
		a450Grava(1,.T.,.F.,.F.)
		EndIf
		(_cAliSC9)->(DbSkip())
		EndDo
		EndIf
		//Fim    Rotina para desbloquear crédito para que o pedido seja faturado sem problemas
		
		//Inicio - Caso tenha ocorrido com sucesso a geração do Pedido de Vendas, irá iniciar a geração da Nota   '*
		DbSelectArea("SC9")
		DbSetOrder(1)
		If DbSeek(xFilial("SC9")+SC5->C5_NUM)
		//Conout("GENA013 - Inicio da Geração do Documento de Saída na empresa Matriz (GEN).")
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
		
		//CONOUT("GENA013 - Ira realizar a geracao da nota de saida (GEN) ")
		
		//Rotina utilizada para realizar a geração da Nota de Saída
		_cNotaImp := MaPVlNFs(_aPVlNFs,_cMvSeri,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)
		
		If Empty(_cNotaImp)
		MsgAlert("Falha na criação da nota fiscal de saída para acerto de clientes.","Atenção")
		Else
		If Select(_cAliSC9) > 0
		dbSelectArea(_cAliSC9)
		(_cAliSC9)->(dbCloseArea())
		EndIf
		
		TcSqlExec("UPDATE "+RetSqlName("SF2")+" SET F2_XSTROMA = 'B' WHERE F2_DOC = '"+_cNotaImp+"' AND D_E_L_E_T_ = ' '")
		MsgInfo("Foi gerada a nota " + _cNotaImp + " para acerto de cliente.","Sucesso")
		Endif
		ELSE
		//CONOUT("GENA013 - Não foi liberado o pedido para a geração do documento de saída. ")
		MsgAlert("Não foi liberado o pedido para a geração do documento de saída.","Atenção")
		ENDIF
		//Erro na criação do pedido
		
		*/
		
		
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
			
			If Select(_cAliSC9) > 0
				dbSelectArea(_cAliSC9)
				(_cAliSC9)->(dbCloseArea())
			EndIf
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliSC9,.T.,.T.)
			
			//Percorre todos itens bloqueados no pedido
			Do While !(_cAliSC9)->(Eof())
				
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
					
					a450Grava(1,.T.,.F.,.F.)
				Else
					_cErroLg := "Registro nao encontrado na SC9. Verifique se o pedido foi corretamente faturado. Recno SC9: " + cvaltochar((_cAliSC9)->SC9RECNO)
					//MemoWrite ( _cLogPd + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + ".txt" , _cErroLg )
					MsgAlert (_cErroLg,"Atenção")
				EndIf
				
				(_cAliSC9)->(DbSkip())
			EndDo
		Else
			_cErroLg := "Pedido não localizado na SC9. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC5->C5_NUM
			//MemoWrite ( _cLogPd + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + ".txt" , _cErroLg )
			MsgAlert (_cErroLg,"Atenção")
		EndIf
		
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
					.AND. (SC9->C9_BLCRED == '  ' .OR. SC9->C9_BLCRED == '10' .OR. SC9->C9_BLCRED == '09S')
					
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
						
					Else
						_cErroLg := "Item de pedido não localizado na tabela SC6. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + alltrim(SC9->C9_PEDIDO) + " Item: " + alltrim(SC9->C9_ITEM)
						//MemoWrite ( _cLogPd + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + ".txt" , _cErroLg )
						MsgAlert (_cErroLg,"Atenção")
					Endif
				Else
					_cErroLg := "Falha ao liberar item na tabela SC9. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + alltrim(SC9->C9_PEDIDO) + " Item: " + alltrim(SC9->C9_ITEM)
					//MemoWrite ( _cLogPd + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + ".txt" , _cErroLg )
					MsgAlert (_cErroLg,"Atenção")
				Endif
				DbSelectArea("SC9")
				DbSkip()
			EndDo
			
			MsgInfo("Gerado o pedido de venda "+alltrim(SC5->C5_NUM)+".","Atenção")
			_cNotaImp := Space(0)

			/* COMENTADO POR DANILO AZEVEDO - 15/05 - PARA NAO GERAR MAIS O DOCUMENTO DE SAIDA
			If len(_aPVlNFs) > 0
				*'------------------------------------------------'*
				*'Rotina utilizada para realizar a geração da Nota'*
				*'------------------------------------------------'*
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
				
				If Select(_cAliSC6) > 0
					dbSelectArea(_cAliSC6)
					(_cAliSC6)->(dbCloseArea())
				EndIf
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliSC6,.T.,.T.)
				
				If ! (_cAliSC6)->(Eof())
					
					_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. Será feita tentativa de exclusão."
					conout("GENA013 - "+_cErroLg)
					U_GenSendMail(,,,"noreply@grupogen.com.br","danilo.azevedo@grupogen.com.br;helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - GENA013 - Acerto de consignação cliente"),oemtoansi(_cErroLg),,,.F.)
					
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
							conout("GENA013 - "+_cErroLg)
							U_GenSendMail(,,,"noreply@grupogen.com.br","danilo.azevedo@grupogen.com.br;helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - GENA013 - Acerto de consignação cliente"),oemtoansi(_cErroLg),,,.F.)
							
						EndIf
						_cNotaImp := ""
					Else
						
						_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. Não foi possível encontrar o registro na SF2 para exclusão. Efetue o procedimento manualmente assim que possível."
						conout("GENA013 - "+_cErroLg)
						U_GenSendMail(,,,"noreply@grupogen.com.br","danilo.azevedo@grupogen.com.br;helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - GENA013 - Acerto de consignação cliente"),oemtoansi(_cErroLg),,,.F.)
						
					EndIf
				EndIf
			Endif
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
				_nPosLb	:= aScan(_aItmPv[1], { |x| Alltrim(x[1]) == "C6_QTDLIB" })
				
				For _ni := 1 To Len(_aItmPv)
					_aItmPv[_ni][_nPosLb][2] := 0
					aAdd(_aItmPv[_ni],{"C6_NUM", _cPedExc, Nil})
				Next _ni
				
				//CONOUT("GENA006B - Irá alterar o pedido de vendas para poder realizar a exclusão.")
				aAdd ( _aCabPv , { "C5_NUM"    , _cPedExc      	, Nil} )
				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,4)
				
				If !lMsErroAuto
					//CONOUT("GENA006B - Alterou o pedido de vendas com suceeso, irá realizar a exclusão.")
					lMsErroAuto := .F.
					
					_cErroLg := ""
					
					MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,5)
					
					If !lMsErroAuto
						//CONOUT("GENA006B - Excluiu com sucesso o pedido de vendas.")
						_cErroLg += "  " + cEnt
						_cErroLg += " O Pedido: " + _cPedExc + " foi excluído com sucesso. "  + cEnt
						_cErroLg += " Favor verificar o pedido: "  + cEnt
						_cErroLg += " Pois ele teve que ser excluído uma vez que o Documento de Saída não foi gerado corretamente. " + cEnt
						_cErroLg += " Favor verificar a geração do Documento de Saída, pois no processo houve erro. " + cEnt
						_cErroLg += " " + cEnt
						//MemoWrite ( _cLogPd + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + ".txt" , _cErroLg )
						MsgAlert (_cErroLg,"Atenção")
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
						//MemoWrite ( _cLogPd + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + ".txt" , _cErroLg )
						MsgAlert (_cErroLg,"Atenção")
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
					//MemoWrite ( _cLogPd + AllTrim(SM0->M0_CODFIL)+ "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + ".txt" , _cErroLg )
					MsgAlert (_cErroLg,"Atenção")
				EndIf
			Else
				//TcSqlExec("UPDATE "+RetSqlName("SF2")+" SET F2_XSTROMA = 'B' WHERE F2_DOC = '"+_cNotaImp+"' AND D_E_L_E_T_ = ' '")
				MsgInfo("Foi gerada a nota " + _cNotaImp + " para acerto de cliente.","Sucesso")
			EndIf


			FIM DO COMENTARIO - DANILO AZEVEDO - 15/05 - PARA NAO GERAR MAIS O DOCUMENTO DE SAIDA
			*/
			
		EndIf
		/*-------------------------------------------------------
		FIM DA ROTINA PARA GERAÇÃO  DE NOTA NO FATURAMENTO
		---------------------------------------------------------*/
	Else
		MostraErro()
	Endif
Endif

If Select(_cAlias0) > 0
	dbSelectArea(_cAlias0)
	(_cAlias0)->(dbCloseArea())
EndIf

Return()

User Function GENA013A(_cCondUsr)

Private oDlg 
Private _cTabUsr := Space(3)
Private _nOpca := 2

	DEFINE MSDIALOG oDlg TITLE "Tabela de preço" FROM 000,000 TO 100,300 PIXEL
	
	@010,010 SAY "Informe a tabela de preço do Pedido de Vendas." OF oDlg PIXEL
	@025,010 SAY "Tabela:" SIZE 55,07 OF oDlg PIXEL
	@023,035 MSGET _cTabUsr F3 "DA0" SIZE 50,11 OF oDlg PIXEL PICTURE "@!" VALID MaVldTabPrc(_cTabUsr,_cCondUsr,,dDataBase)
	
	DEFINE SBUTTON FROM 020, 90 TYPE 1 ACTION (_nOpca := 1,oDlg:End()) ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED 
	
	If _nOpca == 1
		Return _cTabUsr 
	Else
		Return Space(3)
	Endif
	
Return Space(3)