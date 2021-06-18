#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#DEFINE cEnt Chr(13)+Chr(10)

User Function UPDGEN1

Prepare Environment Empresa "00" Filial "1022"
UPDGEN1A()
Reset Environment

Return

Static Function UPDGEN1A

Local _cSQL := ""
Local _cAlias1 := GetNextAlias()
Local _cPedNum := ""
Local _aErro := {}
Local _cErroLg := ""

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

//Seleciona pedidos
_cSQL := "SELECT * "
_cSQL += " FROM " + RetSQLName("SC5") + " SC5 JOIN " + RetSQLName("SC6") + " SC6 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM"
_cSQL += " WHERE SC5.C5_FILIAL = '1022' "
_cSQL += " AND C5_LIBEROK = ' ' AND C5_EMISSAO < '20150900' AND SC5.D_E_L_E_T_ = ' ' and SC6.D_E_L_E_T_ = ' ' order by C6_NUM, C6_ITEM"

//Cria arquivo temporario
TCQUERY _cSQL NEW ALIAS (_cAlias1)

//Percorre pedidos encontrados
While !(_cAlias1)->(EOF())
	
	//Preencher o cabecalho
	_aCabPd  := {}
	_cPedNum := (_cAlias1)->C5_NUM
	
	aAdd ( _aCabPd , { "C5_NUM"			, _cPedNum					, Nil} )
	aAdd ( _aCabPd , { "C5_TIPO"		, (_cAlias1)->C5_TIPO		, NIL} )
	aAdd ( _aCabPd , { "C5_CLIENTE"		, (_cAlias1)->C5_CLIENTE	, NIL} )
	aAdd ( _aCabPd , { "C5_LOJACLI"		, (_cAlias1)->C5_LOJACLI 	, NIL} )
	aAdd ( _aCabPd , { "C5_CLIENT"		, (_cAlias1)->C5_CLIENT 	, NIL} )
	aAdd ( _aCabPd , { "C5_LOJAENT"		, (_cAlias1)->C5_LOJAENT	, NIL} )
	aAdd ( _aCabPd , { "C5_TIPOCLI"		, (_cAlias1)->C5_TIPOCLI	, NIL} )
	aAdd ( _aCabPd , { "C5_VEND1"		, (_cAlias1)->C5_VEND1		, NIL} )
	aAdd ( _aCabPd , { "C5_CONDPAG"		, (_cAlias1)->C5_CONDPAG	, NIL} )
	//aAdd ( _aCabPd , { "C5_EMISSAO" , (_cAlias1)->C5_EMISSAO	   	, NIL} )
	aAdd ( _aCabPd , { "C5_XPEDOLD"		, (_cAlias1)->C5_XPEDOLD 	, NIL} )
	aAdd ( _aCabPd , { "C5_TPFRETE"		, (_cAlias1)->C5_TPFRETE 	, NIL} )
	aAdd ( _aCabPd , { "C5_FRETE"		, (_cAlias1)->C5_FRETE 		, NIL} )
	aAdd ( _aCabPd , { "C5_MOEDA"		, (_cAlias1)->C5_MOEDA 		, NIL} )
	aAdd ( _aCabPd , { "C5_PESOL"		, (_cAlias1)->C5_PESOL 		, NIL} )
	aAdd ( _aCabPd , { "C5_PBRUTO"		, (_cAlias1)->C5_PBRUTO 	, NIL} )
	//aAdd ( _aCabPd , { "C5_TPLIB" 	, (_cAlias1)->C5_TPLIB		, NIL} )
	aAdd ( _aCabPd , { "C5_XTPREMS"		, (_cAlias1)->C5_XTPREMS	, NIL} )
	aAdd ( _aCabPd , { "C5_TABELA"		, (_cAlias1)->C5_TABELA		, NIL} )
	aAdd ( _aCabPd , { "C5_XPEDWEB"		, (_cAlias1)->C5_XPEDWEB	, NIL} )
	aAdd ( _aCabPd , { "C5_TRANSP"		, (_cAlias1)->C5_TRANSP		, NIL} )
	
	//Preenhce os itens
	_aItmPd := {}
	_aBlq := {}
	
	While !(_cAlias1)->(EOF()) .And. _cPedNum == (_cAlias1)->C5_NUM .and. xFilial("SC5") == (_cAlias1)->C5_FILIAL
		
		_alinha  := {}

		If Posicione("SB1",1,xFilial("SB1")+(_cAlias1)->C6_PRODUTO,"B1_MSBLQL")="1"
			aAdd(_aBlq,(_cAlias1)->C6_PRODUTO)
			TcSqlExec("UPDATE "+RetSqlName("SB1")+" SET B1_MSBLQL = '2' WHERE B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+(_cAlias1)->C6_PRODUTO+"' AND D_E_L_E_T_ = ' '")
		Endif
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴콩
		//쿌limentando os Itens do pedido�
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴콩
		
		aAdd ( _alinha , { "C6_NUM"    , _cPedNum						, NIL} )
		aAdd ( _alinha , { "C6_ITEM"    , (_cAlias1)->C6_ITEM			, NIL} )
		aAdd ( _alinha , { "C6_PRODUTO" , (_cAlias1)->C6_PRODUTO  		, NIL} )
		aAdd ( _alinha , { "C6_QTDLIB"  , 0	   							, NIL} )
		aAdd ( _alinha , { "C6_DESCRI"  , (_cAlias1)->C6_DESCRI  		, NIL} )
		aAdd ( _alinha , { "C6_QTDVEN"  , (_cAlias1)->C6_QTDVEN		, NIL} )
		aAdd ( _alinha , { "C6_PRCVEN"  , (_cAlias1)->C6_PRCVEN		, NIL} )
		aAdd ( _alinha , { "C6_VALOR"   , (_cAlias1)->C6_VALOR			, NIL} )
		//aAdd ( _alinha , { "C6_TES"     , (_cAlias1)->C6_TES			, NIL} )
		aAdd ( _alinha , { "C6_LOCAL"   ,  (_cAlias1)->C6_LOCAL		, NIL} )
		//aAdd ( _alinha , { "C6_DESCONT" , (_cAlias1)->C6_DESCONT		, NIL} )
		//aAdd ( _alinha , { "C6_VALDESC" , (_cAlias1)->C6_VALDESC		, NIL} )
		//aAdd ( _alinha , { "C6_ENTREG"  , STOD((_cAlias1)->C6_ENTREG)	, NIL} )
		
		aAdd(_aItmPd , _alinha  )
		
		(_cAlias1)->(DbSkip())
	EndDo
	
	//Altera pedidos
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,4)
	
	If !lMsErroAuto
		//Exclui pedidos
		lMsErroAuto := .F.
		_cErroLg := ""
		MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,5)
		If !lMsErroAuto
			_cErroLg := _cPedNum + " exclusao ok. "  + cEnt
			//Log de pedidos exlcuidos
			MemoWrite ("\UPDGEN1 - 2 " +  _cPedNum + ".txt" , _cErroLg )
		Else 			
			//Log de pedidos nao excluidos
			_cErroLg := _cPedNum + " pedido nao excluido. "  + cEnt
			_cErroLg += "  " + cEnt
			_aErro := GetAutoGRLog()
			For _ni := 1 To Len(_aErro)
				_cErroLg += _aErro[_ni] + cEnt
			Next _ni
			MemoWrite ("\UPDGEN2 - 3 " +  _cPedNum + ".txt" , _cErroLg )
		Endif
	Else
		//log de pedidos nao alterados
		_cErroLg := _cPedNum + " pedido nao alterado. "  + cEnt
		_cErroLg += "  " + cEnt
		_aErro := GetAutoGRLog()
		For _ni := 1 To Len(_aErro)
			_cErroLg += _aErro[_ni] + cEnt
		Next _ni
		MemoWrite ("\UPDGEN1 - 1 " +  _cPedNum + ".txt" , _cErroLg )
	Endif

	For nX := 1 to len(_aBlq)
		TcSqlExec("UPDATE "+RetSqlName("SB1")+" SET B1_MSBLQL = '1' WHERE B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+_aBlq[nX]+"' AND D_E_L_E_T_ = ' '")
	Next nX

Enddo

(_cAlias1)->(DbCloseArea())

MemoWrite ("\UPDGEN1 - fim.txt" , "Fim" )

Return                                                  