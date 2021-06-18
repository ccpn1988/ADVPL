#include 'protheus.ch'

/*
Função: GENA022

Descrição: Geração de Documento de Entrada com Formulário Próprio para Devolução de Consignação.

Manutenções:
25/06/2015 - Rafael Leite - Criação do fonte
*/
User Function GENA022

Local _cPerg	:= "GENA022"
Local _cSQL		:= ""
Local _cCodForn
Local _cLojForn
Local _cAlias1 	:= GetNextAlias()
Local _cMvEspc 	:= GetMv("GEN_FAT020") //Contém a especie utilizada na nota de entrada das empresas Matriz e Origem
Local _cMvCdDe 	:= GetMv("GEN_FAT021") //Contém a condição de pagamento utilizada na nota de entrada das empresas Matriz e Origem
Local _cTesImp	:= GetMV("GEN_COM002")
Local _cSerie 	:= GetMv("GEN_COM003") //Serie de devolução
Local _dEmissao	:= GetMv("GEN_COM004") //Emissao maxima
Local _aCabDoc 	:= {}
Local _aLinha 	:= {}
Local _aItens 	:= {}
Local _cMsgFim	:= ""

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

PutSx1(_cPerg, "01", "Cliente:",	"Cliente:",	"Cliente:",	"mv_ch1", "C", TamSx3("A1_COD")[1], 0, 0, "G","", "SA1", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(_cPerg, "02", "Loja:",		"Loja:",	"Loja:",    "mv_ch2", "C", TamSx3("A1_LOJA")[1], 0, 0, "G","", ""	, "", "", "MV_PAR02","","","","","","","","","","","","","","","","")

//Parâmetros iniciais
If !MsgNoYes("Deseja importar DEVOLUÇÃO DE CONSIGNAÇÃO?")
	Return
Endif

If !Pergunte("GENA022",.T.)
	Return
Else
	_cCodForn := MV_PAR01
	_cLojForn := MV_PAR02
	_cTipoDoc := "B"
Endif

_cSQL := " SELECT B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO, B6_DOC, B6_SALDO,
_cSQL += " B6_SERIE, D2_ITEM, B6_IDENT, B6_PRUNIT, B6_LOCAL
_cSQL += " FROM " + RetSqlName("SB6") + " SB6, " + RetSqlName("SD2") + " SD2, " + RetSqlName("SB1") + " SB1 
_cSQL += " WHERE SB6.B6_FILIAL = '" + xFilial("SB6") + "'
_cSQL += " AND SB6.B6_CLIFOR = '" + _cCodForn + "'
_cSQL += " AND SB6.B6_LOJA = '" + _cLojForn + "'
_cSQL += " AND SB6.B6_EMISSAO <= '" + DtoS(_dEmissao) + "'
_cSQL += " AND SB6.B6_TIPO = 'E'
_cSQL += " AND SB6.B6_TPCF = 'C'
_cSQL += " AND SB6.B6_PODER3 = 'R'
_cSQL += " AND SB6.B6_SALDO > 0
_cSQL += " AND SB6.D_E_L_E_T_ = ' '
_cSQL += " AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'
_cSQL += " AND SB6.B6_DOC = SD2.D2_DOC
_cSQL += " AND SB6.B6_SERIE = SD2.D2_SERIE
_cSQL += " AND SB6.B6_PRODUTO = SD2.D2_COD
_cSQL += " AND SB6.B6_CLIFOR = SD2.D2_CLIENTE
_cSQL += " AND SB6.B6_LOJA = SD2.D2_LOJA
_cSQL += " AND SD2.D_E_L_E_T_ = ' '
_cSQL += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'
_cSQL += " AND SB6.B6_PRODUTO = SB1.B1_COD
_cSQL += " AND SB1.B1_MSBLQL = '2' 
_cSQL += " AND SB1.D_E_L_E_T_ = ' '
_cSQL += " ORDER BY B6_EMISSAO

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias1, .F., .T.)

If !(_cAlias1)->(EOF())
	
	
	While !(_cAlias1)->(EOF())
		
		//carrega array com os dados do cabeçalho da Pré-Nota de Entrada
		_aCabDoc := {}
		
		aadd(_aCabDoc , {"F1_TIPO"   	,_cTipoDoc				, Nil} ) // 03/02 - RAFAEL LEITE
		aadd(_aCabDoc , {"F1_FORMUL" 	,"S"					, Nil} )
		aadd(_aCabDoc , {"F1_SERIE"  	,_cSerie	, Nil} )
		aadd(_aCabDoc , {"F1_EMISSAO"	,dDataBase				, Nil} )
		aadd(_aCabDoc , {"F1_DTDIGIT"	,dDataBase				, Nil} )
		aadd(_aCabDoc , {"F1_FORNECE"	,PADR(AllTrim(_cCodForn),TAMSX3("F1_FORNECE")[1])	, Nil} )
		aadd(_aCabDoc , {"F1_LOJA"   	,Alltrim(_cLojForn)		, Nil} )
		aadd(_aCabDoc , {"F1_ESPECIE"	,_cMvEspc				, Nil} )
		aadd(_aCabDoc , {"F1_COND"		,_cMvCdDe				, Nil} )
		//aAdd(_aCabDoc , {"F1_CHVNFE"	,_cChvNFE				, NIL} )
		
		_nCnt	:= 0
		_aItens := {}
		
		While !(_cAlias1)->(EOF()) .and. _nCnt < 90
			
			_aLinha:={}
			
			_nCnt++
			
			aAdd(_aLinha,	{"D1_ITEM"		, STRZERO(_nCnt,TAMSX3("D1_ITEM")[1])			, Nil})
			aAdd(_aLinha,	{"D1_COD"  		, (_cAlias1)->B6_PRODUTO						, Nil})
			aAdd(_aLinha,	{"D1_QUANT"		, (_cAlias1)->B6_SALDO							, Nil})
			aAdd(_aLinha,	{"D1_VUNIT"		, (_cAlias1)->B6_PRUNIT							, Nil})
			aAdd(_aLinha,	{"D1_TOTAL"		, (_cAlias1)->B6_SALDO*(_cAlias1)->B6_PRUNIT	, Nil})
			aAdd(_aLinha,	{"D1_TES"		, _cTESImp										, Nil})
			aAdd(_aLinha,	{"D1_LOCAL"		, (_cAlias1)->B6_LOCAL							, Nil})
			aAdd(_aLinha,	{"D1_NFORI"		, (_cAlias1)->B6_DOC							, Nil})
			aAdd(_aLinha,	{"D1_SERIORI"	, (_cAlias1)->B6_SERIE							, Nil})
			aAdd(_aLinha,	{"D1_ITEMORI"	, (_cAlias1)->D2_ITEM							, Nil})
			aAdd(_aLinha,	{"D1_IDENTB6"	, (_cAlias1)->B6_IDENT							, Nil})
			
			aadd(_aItens,_aLinha)
			
			(_cAlias1)->(DbSkip())
		End
		
		If Len(_aItens) > 0
			
			_cDocImp := MA461NumNf(.T.,_cSerie)
			
			aadd(_aCabDoc , {"F1_DOC"		,_cDocImp	, Nil} )
			
			DbSelectArea("SC5")
			DbSetOrder(1)
			
			DbSelectArea("SA1")
			DbSelectArea("SA2")
			
			Begin Transaction
			
			MSExecAuto({|x,y,z|MATA103(x,y,z)},_aCabDoc, _aItens,3)
			
			End Transaction
			
			If lMsErroAuto
				
				_lRet := .F.
								
				_aErro := GetAutoGRLog()
				_cErro := MostraErro()
				
				Disarmtransaction()
			Else
				_cMsgFim += "Nota gerada com formulário próprio:" + _cSerie + "/" + _cDocImp + CHR(13)+CHR(10)
			EndIf
		Else
			MsgAlert("Não foram encontrados itens.")
		Endif
	End
	
	If !Empty(_cMsgFim)
		MsgInfo(_cMsgFim)
	Endif
Else
	MsgAlert("Cliente sem consignação.")
Endif

Return              