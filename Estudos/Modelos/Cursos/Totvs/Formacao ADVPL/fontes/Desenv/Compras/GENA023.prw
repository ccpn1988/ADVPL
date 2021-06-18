#include 'protheus.ch'

/*
Função: GENA023

Descrição: Geração de Pedido de Vendas a partir de documento de entrada.

Manutenções:
25/06/2015 - Rafael Leite - Criação do fonte
*/
User Function GENA023

Local _cPerg	:= "GENA023"
Local _cSQL		:= ""
Local _cAlias1 	:= GetNextAlias()
Local _cTesImp	:= GetMv("GEN_COM005") 
Local _cTabImp	:= GetMv("GEN_COM006") 
Local _cTrpImp	:= GetMv("GEN_COM007") 
Local _aCabPed 	:= {}
Local _aLinha 	:= {}
Local _aItens 	:= {}
Local _cMsgFim	:= ""

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .F.

PutSx1(_cPerg, "01", "Documento:"	,	"a",	"a",	"mv_ch1", "C", TamSx3("F1_DOC")[1]		, 0, 0, "G","", "SF1_1"	, "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(_cPerg, "02", "Serie:"		,	"a",	"a",    "mv_ch2", "C", TamSx3("F1_SERIE")[1]	, 0, 0, "G","", ""		, "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSx1(_cPerg, "03", "Fornecedor:"	,	"a",	"a",    "mv_ch3", "C", TamSx3("F1_FORNECE")[1]	, 0, 0, "G","", ""		, "", "", "MV_PAR03","","","","","","","","","","","","","","","","")
PutSx1(_cPerg, "04", "Loja:"		,	"a",	"a",    "mv_ch4", "C", TamSx3("F1_LOJA")[1]		, 0, 0, "G","", ""		, "", "", "MV_PAR04","","","","","","","","","","","","","","","","")

//Parâmetros iniciais
If !Pergunte("GENA023",.T.)
	Return
Else
	_cDocOri := MV_PAR01
	_cSerOri := MV_PAR02
	_cForOri := MV_PAR03
	_cLojOri := MV_PAR04
Endif

_cSQL := " SELECT D1_TIPO, D1_COD, B1_DESC, B1_LOCPAD, DA1_PRCVEN
_cSQL += " , SUM(D1_QUANT) D1_QUANT 
_cSQL += " FROM " + RetSqlName("SD1") + " SD1
_cSQL += " ," + RetSqlName("SB1") + " SB1
_cSQL += " ," + RetSqlName("DA1") + " DA1
_cSQL += " WHERE SD1.D1_FILIAL = '" + xFilial("SD1") + "'
_cSQL += " AND SD1.D1_DOC = '" + _cDocOri + "'
_cSQL += " AND SD1.D1_SERIE = '" + _cSerOri + "'
_cSQL += " AND SD1.D1_FORNECE = '" + _cForOri + "'
_cSQL += " AND SD1.D1_LOJA = '" + _cLojOri + "'
_cSQL += " AND SD1.D_E_L_E_T_ = ' '
_cSQL += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'
_cSQL += " AND SB1.B1_COD = SD1.D1_COD
_cSQL += " AND SB1.D_E_L_E_T_ = ' '
_cSQL += " AND DA1.DA1_FILIAL = '" + xFilial("DA1") + "'
_cSQL += " AND DA1.DA1_CODTAB = '"+_cTabImp+"'
_cSQL += " AND DA1.DA1_CODPRO = SD1.D1_COD
_cSQL += " AND DA1.D_E_L_E_T_ = ' '
_cSQL += " GROUP BY D1_TIPO, D1_COD, B1_DESC, B1_LOCPAD, DA1_PRCVEN

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias1, .F., .T.)

If !(_cAlias1)->(EOF())
	
	If (_cAlias1)->D1_TIPO <> "B"
		MsgStop("O documento de entrada não é de devolução de consignação.")
		Return
	Endif
	
	SA1->(DbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+_cForOri+_cLojOri))
			
		While !(_cAlias1)->(EOF())
		
		
			//carrega array com os dados do cabeçalho da Pré-Nota de Entrada
			_aCabPed := {}
			
			aAdd ( _aCabPed , { "C5_TIPO"    	, "N"       					   			, NIL} )
			aAdd ( _aCabPed , { "C5_CLIENTE" 	, SA1->A1_COD 							   	, NIL} )
			aAdd ( _aCabPed , { "C5_LOJACLI" 	, SA1->A1_LOJA 								, NIL} )
			aAdd ( _aCabPed , { "C5_CLIENT"  	, SA1->A1_COD 								, NIL} )
			aAdd ( _aCabPed , { "C5_LOJAENT" 	, SA1->A1_LOJA 								, NIL} )
			aAdd ( _aCabPed , { "C5_TIPOCLI" 	, SA1->A1_TIPO						 		, NIL} )
			aAdd ( _aCabPed , { "C5_VEND1" 		, SA1->A1_VEND 								, NIL} )
			aAdd ( _aCabPed , { "C5_CONDPAG" 	, SA1->A1_COND			  					, NIL} )
			aAdd ( _aCabPed , { "C5_EMISSAO" 	, dDataBase									, NIL} )
			aAdd ( _aCabPed , { "C5_TPFRETE"	, SA1->A1_TPFRET		 					, NIL} )
			aAdd ( _aCabPed , { "C5_TRANSP"     , _cTrpImp									, NIL} )
			
			_nCnt	:= 0
			_aItens := {}
			
			While !(_cAlias1)->(EOF()) .and. _nCnt < 90
				
				_aLinha:={}
				
				_nCnt++
				
				aAdd ( _alinha , { "C6_ITEM"    , STRZERO(_nCnt,TAMSX3("D2_ITEM")[1])			, NIL} )
				aAdd ( _alinha , { "C6_PRODUTO" , (_cAlias1)->D1_COD							, NIL} )
				aAdd ( _alinha , { "C6_DESCRI"  , (_cAlias1)->B1_DESC 							, NIL} )
				aAdd ( _alinha , { "C6_QTDVEN"  , (_cAlias1)->D1_QUANT   						, NIL} )
				aAdd ( _alinha , { "C6_PRCVEN"  , (_cAlias1)->DA1_PRCVEN		   				, NIL} )
				aAdd ( _alinha , { "C6_VALOR"   , ((_cAlias1)->DA1_PRCVEN*(_cAlias1)->D1_QUANT)	, NIL} )
				aAdd ( _alinha , { "C6_TES"     , _cTesImp      	  							, NIL} )
				aAdd ( _alinha , { "C6_LOCAL"   , (_cAlias1)->B1_LOCPAD							, NIL} )
				aAdd ( _alinha , { "C6_ENTREG"  , dDataBase										, NIL} )
					
				aadd(_aItens,_aLinha)
				
				(_cAlias1)->(DbSkip())
			End
			
			If Len(_aItens) > 0
				
				DbSelectArea("SC5")
				DbSelectArea("SC6")
				DbSelectArea("SB1")
				
				Begin Transaction
				
				MSExecAuto({|x,y,z|MATA410(x,y,z)},_aCabPed, _aItens,3)
				
				End Transaction
				
				If lMsErroAuto
					
					_lRet := .F.
										
					_aErro := GetAutoGRLog()
					_cErro := MostraErro()
					
					Disarmtransaction()
				Else
					_cMsgFim += "Pedido gerado:" + SC5->C5_NUM + CHR(13) + CHR(10)
				EndIf
			Else
				MsgAlert("Não foram encontrados itens.")
			Endif 
		End 
		
		If !Empty(_cMsgFim)
			MsgInfo(_cMsgFim)
		Endif
	Else
		MsgStop("Cliente nao localizado.")
	Endif	
Else
	MsgAlert("Documento não encontrado.")
Endif

Return              