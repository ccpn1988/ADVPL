#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#DEFINE c_ent CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI021   ºAutor  ³Danilo Azevedo      º Data ³  19/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importação de Nota Fiscal de saida para consignacao mercadoº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Faturamento                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENI021C()

Prepare Environment Empresa "00" Filial "1022"
GENI021A()
Reset Environment

//If MsgYesNo("Deseja efetuar a importação de notas fiscais de saída para consignação ao mercado?")
//	Processa({|| GENI021A()},"Processando...")
//Endif

Return()


Static Function GENI021A()

Local _aArea2    := GetArea()
Local _aArea3
Local _aArea4
Local cQry       := ""
Local _cQuery    := ""
Local _aCabSF2   := {}
Local _aItemSD2  := {}
Local _cCodigo   := ""
Local _cLoja	 := ""
Local _cProduto	 := ""
Local _cUnidade  := ""
Local _cDocNF	 := ""
Local _cNFOrin   := ""
Local _cSerieOr  := ""
Local _cTipo	 := ""
Local _nItens	 := 0
Local _cTes		 := ""
Local _cCliente	 := ""
Local _cQueryINS := ""
Local _cQuery 	 := ""
Local _cEspecie  := "SPED"
Local _aSF2RecNo := {}
Local _aNFSaida	 := {}
Local _aStruSF2	 := SF2->(dbStruct())
Local _aStruSD2  := SD2->(dbStruct())
Local _cCaminho	 := GETMV("MV_XLOGSAI")
Local _cError2   := ""
Local _oError2 	 := ErrorBlock({|e| _cError2 := e:Description + e:ErrorStack})
Local _cNomeErro2 := "Erro_"+dtos(date())+"_"+StrTran(cValtoChar(Time()),":","")+".txt"
Local _cSerie    := Padr(GetMv("GEN_FAT003"),Tamsx3("F2_SERIE")[1]," ") //"10"
Local _cItemCC   := "000000"
Local _cCLVL	 := "000000"
Local _cConta	 := "000000"
Local _cCCusto	 := "000000"

Private _cNumNF  := strzero(1,tamsx3("F2_DOC")[1])
Private _aErros	 := {}
Private cCampo	 := ""
Private cHelp	 := ""
Private lMSErroAuto	:=.F.
Private lMsHelpAuto :=.F.

//MemoWrite(_cCaminho+"\inicio_"+dtos(date())+"_"+StrTran(cValtoChar(Time()),":","")+".txt","Processo iniciado")

/*
cQry := "SELECT TO_CHAR(CSG.IDCLIENTE) A1_XCODOLD, UF.DESCRICAO A1_EST, O.IDOBRAORIGEM IDOBRA, O.ISBN, CSG.QTDE, O.PRECO,
cQry += " (CSG.QTDE * O.PRECO * (D.PERC/100)) F2_DESCONT, CSG.QTDE * O.PRECO D2_TOTAL,
cQry += " SUM(CSG.QTDE * O.PRECO) OVER (PARTITION BY CSG.IDCLIENTE) F2_VALBRUT,
cQry += " SUM(((CSG.QTDE * O.PRECO)*(1 - (D.PERC/100)))) OVER (PARTITION BY CSG.IDCLIENTE) F2_VALLIQ,
cQry += " C.IDCOORDENADORVENDA A1_VEND1,
cQry += " DECODE(UF.DESCRICAO,'SP','5917','6917') CFOP,
cQry += " D.PERC DESCONTO, ((CSG.QTDE * O.PRECO)*(1 - (D.PERC/100))) VAL_LIQ
//cQry += " FROM CONSIGNACAO CSG, OBRA O, CLIENTE C, DESCONTO D, UF //ALTERADO PARA PEGAR A "FOTO" ANTES DO PROCESSO DE DEVOLUCAO NO ORACLE
cQry += " FROM dba_egk.CONSIGNACAO_GEN_MERCADO CSG, OBRA O, CLIENTE C, DESCONTO D, UF
cQry += " WHERE CSG.IDOBRA = O.IDOBRA
cQry += " AND CSG.IDCLIENTE = C.IDCLIENTE
cQry += " AND C.IDTIPODESCONTO = D.IDTIPODESCONTO
cQry += " AND O.IDCLASSEOBRA   = D.IDCLASSEOBRA (+)
cQry += " AND C.IDUFENT = UF.IDUF
cQry += " AND CSG.IDEMPRESA = 25
cQry += " AND QTDE <> 0
cQry += " AND CSG.IDCLIENTE <> 102007                 
cQry += " ORDER BY CSG.IDCLIENTE, O.IDOBRAORIGEM
*/

cQry := "SELECT SA1.A1_XCODOLD, SA1.A1_EST, CSG.IDOBRAORIGEM IDOBRA, SB1.B1_ISBN ISBN, CSG.QTDE, DA1.DA1_PRCVEN PRECO,
cQry += " (CSG.QTDE * DA1.DA1_PRCVEN * (SZ2.Z2_PERCDES/100)) F2_DESCONT, CSG.QTDE * DA1.DA1_PRCVEN D2_TOTAL,
cQry += " SUM(CSG.QTDE * DA1.DA1_PRCVEN) OVER (PARTITION BY SA1.A1_XCODOLD) F2_VALBRUT,
cQry += " SUM(((CSG.QTDE * DA1.DA1_PRCVEN)*(1 - (SZ2.Z2_PERCDES/100)))) OVER (PARTITION BY SA1.A1_XCODOLD) F2_VALLIQ,
cQry += " SA1.A1_VEND, DECODE(SA1.A1_EST, 'SP', '5917', '6917') CFOP,
cQry += " SZ2.Z2_PERCDES DESCONTO, ((CSG.QTDE * DA1.DA1_PRCVEN)*(1 - (SZ2.Z2_PERCDES/100))) VAL_LIQ
cQry += " FROM DBA_EGK.CONSIGNACAO_GEN_MERCADO CSG, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SZ2")+" SZ2,
cQry += " (SELECT DA1_CODPRO, DA1_PRCVEN
cQry += " FROM "+RetSqlName("DA1")
cQry += " WHERE DA1_CODTAB = '"+GETMV("GEN_FAT064")+"'"
cQry += " AND D_E_L_E_T_ = ' ') DA1
cQry += " WHERE CSG.IDOBRAORIGEM = TO_NUMBER(TRIM(SB1.B1_COD))
cQry += " AND CSG.IDCLIENTE = TO_NUMBER(TRIM(SA1.A1_XCODOLD))
cQry += " AND SA1.A1_XTPDES = SZ2.Z2_TIPO
cQry += " AND SB1.B1_GRUPO = SZ2.Z2_CLASSE
cQry += " AND SB1.B1_COD = DA1.DA1_CODPRO
cQry += " AND CSG.IDEMPRESA = 25
cQry += " AND QTDE <> 0
cQry += " AND CSG.IDCLIENTE <> 102007
cQry += " AND SB1.D_E_L_E_T_ = ' '
cQry += " AND SA1.D_E_L_E_T_ = ' '
cQry += " AND SB1.D_E_L_E_T_ = ' '
cQry += " AND SZ2.D_E_L_E_T_ = ' '
cQry += " AND SA1.A1_XCODOLD  NOT in ('301034')
cQry += " ORDER BY CSG.IDCLIENTE, CSG.IDOBRAORIGEM

cAlias := GetNextAlias()
TCQUERY cQry NEW ALIAS (cAlias)

dbSelectArea("SA1")
dbSetOrder(9) //XCODOLD

dbSelectArea("SB1")
//dbSetOrder(11) //ISBN
// cleuto lima - alterado pois este indice é proprietario totvs e deve ser tulizado nickname
SB1->(DbOrderNickName("GENISBN"))

Do While !(cAlias)->(EOF())
	
	//Zera variaveis de memoria
	_aCabNF   := {}
	_aItemNF  := {}
	_aErros   := {}
	_nItens   := 0
	_nIt		:= Replicate("0",tamsx3("D2_ITEM")[1])
	_cNumNF   := soma1(_cNumNF)
	
	SA1->(dbSetOrder(9))
	SA1->(dbSeek(xFilial("SA1")+(cAlias)->A1_XCODOLD))
	_cCodigo	:= SA1->A1_COD
	_cLoja		:= SA1->A1_LOJA
	_cCond		:= SA1->A1_COND
	_cTransp	:= "000472"//SA1->A1_TRANSP
	_cVend		:= SA1->A1_VEND
	
	_cTes	:= "520"
	_cNFFil	:= "1022"
	
	//Cabeçalho da nota fiscal
	_aCabNF		:= {}
	_aItemNF	:= {}
	dEmissao	:= dDataBase
	_cTipo		:= "N"
	
	//Arquivo de log
	cPathLog	:= _cCaminho+"\"+_cNumNF+".txt"
	
	//Itens da nota
	_nErro   := 0
	cXCodOld := (cAlias)->A1_XCODOLD
	nValBrut := 0
	nValLiq  := 0
	
	While !(cAlias)->(Eof()) .and. (cAlias)->A1_XCODOLD = cXCodOld /*.and. _nItens <= 250*/ .and. _nErro = 0
		
		//SB1->(DbSetOrder(11))
		// cleuto lima - alterado pois este indice é proprietario totvs e deve ser tulizado nickname
		SB1->(DbOrderNickName("GENISBN"))		
		If !SB1->(DbSeek(xFilial("SB1")+(cAlias)->ISBN))
			//_nErro++
			Memowrite(cPathLog,"Codigo "+ Alltrim((cAlias)->ISBN) +" de Produto inexistente")
			(cAlias)->(DbSkip())
			Loop
		Endif
		
		_cProduto := PADR(Alltrim(SB1->B1_COD),TAMSX3("B1_COD")[1])
		_cUnidade := PADR(Alltrim(SB1->B1_UM),TAMSX3("B1_UM")[1])
		
		("SB1")->(dbCloseArea())
		aAdd(_aItemNF,{})
		nLen := Len(_aItemNF)
		_nItens++
		_nIt := Soma1(_nIt)
		aAdd(_aSF2RecNo,0)
		
		For j := 1 to len(_aStruSD2)
			If ALLTRIM(_aStruSD2[j][1]) == 'D2_FILIAL'
				Aadd( _aItemNF[nLen], xFilial("SD2"))
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_ITEM"
				Aadd( _aItemNF[nLen], _nIt)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_COD"
				Aadd( _aItemNF[nLen], _cProduto)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_UM"
				Aadd( _aItemNF[nLen], _cUnidade)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_QUANT"
				Aadd( _aItemNF[nLen], (cAlias)->QTDE)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_CLIENTE"
				Aadd( _aItemNF[nLen], _cCodigo)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_LOJA"
				Aadd( _aItemNF[nLen], _cLoja)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_PRCVEN"
				Aadd( _aItemNF[nLen], (cAlias)->PRECO)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_TOTAL"
				Aadd( _aItemNF[nLen], (cAlias)->D2_TOTAL)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_TES"
				Aadd( _aItemNF[nLen], _cTes)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_TIPO"
				Aadd( _aItemNF[nLen], "N")
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_EST"
				Aadd( _aItemNF[nLen], Alltrim((cAlias)->A1_EST))
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_PRUNIT"
				Aadd( _aItemNF[nLen], (cAlias)->PRECO)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == 'D2_CF'
				Aadd( _aItemNF[nLen], (cAlias)->CFOP)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_ITEMCC"
				Aadd( _aItemNF[nLen], _cItemCC)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_LOCAL"
				Aadd( _aItemNF[nLen], "01")
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_CLVL"
				Aadd( _aItemNF[nLen], cValToChar((cAlias)->IDOBRA))
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_CONTA"
				Aadd( _aItemNF[nLen], _cConta)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_CCUSTO"
				Aadd( _aItemNF[nLen], _cCCusto)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_DOC"
				Aadd( _aItemNF[nLen], _cNumNF)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_SERIE"
				Aadd( _aItemNF[nLen], _cSerie)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_EMISSAO"
				Aadd( _aItemNF[nLen], Ddatabase)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_DESCON"
				Aadd( _aItemNF[nLen], (cAlias)->D2_TOTAL-(cAlias)->VAL_LIQ)
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_NFORI"
				Aadd( _aItemNF[nLen], Iif(_cTipo == "D", AllTrim(STRZERO(Val((cAlias)->D2_NFORI),9,0)),""))
			ElseIf ALLTRIM(_aStruSD2[j][1]) == "D2_SERIORI"
				Aadd( _aItemNF[nLen], Iif(_cTipo == "D",AllTrim(STRZERO(Val((cAlias)->D2_SERIORI),3,0)),""))
			Else
				aAdd(_aItemNF[nLen], CriaVar(_aStruSD2[j][1])  )
				// Campos excedentes do cabecalho da nota fiscal, necessarios na rotina mata461 para geracao de nota sem pedido de venda.
			Endif
		Next
		
		cEst      := (cAlias)->A1_EST
		nValBrut  += (cAlias)->D2_TOTAL
		nValLiq   += (cAlias)->VAL_LIQ
		
		(cAlias)->(DbSkip())
	EndDo
	
	For j := 1 to len(_aStruSF2)
		If ALLTRIM(_aStruSF2[j][1]) == 'F2_FILIAL'	// Filial
			Aadd(_aCabNF, "1022")
		ElseIf ALLTRIM(_aStruSF2[j][1]) == 'F2_DOC' // Numero do Documento
			Aadd(_aCabNF, _cNumNF)
		ElseIf ALLTRIM(_aStruSF2[j][1]) == 'F2_SERIE' // Serie
			Aadd(_aCabNF, _cSerie)
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_CLIENTE" // Codigo do Cliente
			Aadd(_aCabNF, _cCodigo)
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_LOJA" // Loja do Cliente
			Aadd(_aCabNF, _cLoja)
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_COND" // Condição de pagamento
			Aadd(_aCabNF, _cCond)
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_EMISSAO" // Data de Emissão
			Aadd(_aCabNF, dDataBase)
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_TIPO" // Tipo do Pedido
			Aadd(_aCabNF, "N")
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_EST" // Estado
			Aadd(_aCabNF, cEst)
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_FORMUL" // Formulario Proprio
			Aadd(_aCabNF, "N")
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_ESPECIE" // Especie
			Aadd(_aCabNF, "SPED")
		ElseIf ALLTRIM(_aStruSF2[j][1]) == 'F2_DTDIGIT' // Data de Digitação
			Aadd(_aCabNF, dDataBase)
		ElseIf ALLTRIM(_aStruSF2[j][1]) == 'F2_TPFRETE' // Tipo de Frete
			Aadd(_aCabNF, "C")
		ElseIf ALLTRIM(_aStruSF2[j][1]) == 'F2_FRETE' // Frete
			Aadd(_aCabNF, 0)
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_DESPESA" // Despesa
			Aadd(_aCabNF, 0)
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_DESCONT" // Desconto
			Aadd(_aCabNF, nValBrut - nValLiq)
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_TRANSP" // Transporte
			Aadd(_aCabNF, _cTransp)
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_VEND1" // Vendedor
			Aadd(_aCabNF, _cVend)
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_HORA" // Hora
			Aadd(_aCabNF, "00:15")
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_VALBRUT" // Valor LIQUIDO
			Aadd(_aCabNF, nValLiq)  
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_VALMERC" // Valor Mercadoria
			Aadd(_aCabNF, nValLiq) 
		ElseIf ALLTRIM(_aStruSF2[j][1]) == "F2_VALFAT" // Valor Valor Faturado
			Aadd(_aCabNF, nValLiq)
		Else
			Aadd(_aCabNF, CriaVar(_aStruSF2[j][1])) // Campos excedentes do cabecalho da nota fiscal, necessarios na rotina mata461 para geracao de nota sem pedido de venda.
		Endif
	Next
	
	//Caso encontre erro, passa todos os itens dessa nota
	If _nErro <> 0
		//Laço para posicionar na proxina nota
		While !(cAlias)->(Eof()) .and. (cAlias)->A1_XCODOLD = cXCodOld
			(cAlias)->(DbSkip())
		End
	ElseIf _nErro == 0 .and. Len(_aItemNF) > 0 //Efetua inclusão da nota caso não existam erros
		_aArea3 := GetArea()
		_aArea4 := (cAlias)->(GetArea())
		
		DBASEOLD := DDATABASE
		DDATABASE := dEmissao
		
		_cNota := MaNfs2Nfs(,,_cCodigo,_cLoja,_cSerie,,.F.,.F.,,,,,,,,,,{|| .T.},_aSF2RecNo,_aItemNF,_aCabNF,.F.,{|| .T.},{|| .T.},{|| .T.},)
		_cNota := PADR(_cNota,TamSX3("F2_DOC")[1])
		
		DDATABASE := DBASEOLD
		
		RestArea(_aArea4)
		RestArea(_aArea3)
		
		If(EMPTY(_cNota))
			Memowrite(cPathLog,"Nota Fiscal de Numero "+_cNumNF+" e Serie 002"+" Erro ao Gravar Nota Fiscal!")
			DisamTransaction()
		Else
			//Atualiza a especie da nota
			_cQuery := "UPDATE " + 	RetSqlName("SF2")
			_cQuery += " SET F2_ESPECIE = '" + _cEspecie + "'
			_cQuery += " WHERE F2_FILIAL = '" + xFilial("SF2") + "'
			_cQuery += " AND F2_DOC = '" + _cNota + "'
			_cQuery += " AND F2_SERIE = '" + _cSerie	+ "'
			_cQuery += " AND F2_CLIENTE = '" + _cCodigo + "'
			_cQuery += " AND F2_LOJA = '" + _cLoja + "'
			_cQuery += " AND D_E_L_E_T_ = ' '
			TCSQLEXEC(_cQuery)

			Memowrite(cPathLog,"NF "+_cNota+" cliente "+_cCodigo+"-"+_cLoja+" gerada.")

		Endif
	Endif
	
	ErrorBlock(_oError2)
	If(!Empty(_cError2))
		ConOut(_cError2)
		Memowrite(_cNomeErro2,_cError2)
	EndIf
Enddo

//MemoWrite(_cCaminho+"\fim_"+dtos(date())+"_"+StrTran(cValtoChar(Time()),":","")+".txt","Processo finalizado")

If Select(cAlias) > 0
	dbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
EndIf

RestArea(_aArea2)

Return()
