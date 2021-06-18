#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH
#INCLUDE "TBICONN.CH"
#INCLUDE 'FILEIO.CH'
#DEFINE   c_ent      CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI021   ºAutor  ³Leandro Ribeiro     º Data ³  10/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de importação de Nota Fiscal de Saida.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GENI021()

If MsgYesNo("Deseja efetuar a importação de notas fiscais de saída?")
	Processa({|| GENI021A()},"Processando...")
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI021   ºAutor  ³Leandro Ribeiro     º Data ³  09/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para realizar a troca de filiais.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GENI021A

Local _aArea1  := GetArea()
Local _aCodFil := {}
Local _cTabela := "SB1,SA2,SF2,SD2,SAH,SF4,CT1,CTD,CTT,CTH,SA1"
Local _oServer := Nil
Local _cAmb	   := GetEnvServer()
Local _cQuery  := ""
Local _cTrab2  := GetNextAlias()
Local _cIpServer := GETMV("MV_XIPSERV")	//"10.1.0.243"
Local _cPorta  	 := GETMV("MV_XPORTA")	//1998
Local _cView     := GETMV("MV_XNFSAI")	//"TT_I28_NFSAIDA"
Local _cCaminho	 := GETMV("MV_XLOGSAI")  //'\logsiga\nf saida'
Local _nRet		 := MakeDir(_cCaminho)   // Criação da Pasta para gravação do log
Local _cError1   := ""
Local _oError1 	 := ErrorBlock({|e| _cError1 := e:Description + e:ErrorStack})
Local _cNomeErro1 := "ErroProcessamento"+"_"+dtos(date())+"_"+StrTran(cValtoChar(Time()),":","")+".txt"

//F001("01")

//Verifica criação dos diretórios
If(_nRet != 0)
	Conout("Erro Protheus não pode criar o diretorio. Erro: "+cValToChar(FError()))
EndIf

//Seleciona empresas a serem processadas
_cQuery := " SELECT DISTINCT F2_FILIAL " + c_ent
_cQuery += " FROM " + _cView + " " + c_ent
_cQuery += " ORDER BY F2_FILIAL " + c_ent
_cQuery := ChangeQuery(_cQuery)

If Select(_cTrab2) > 0
	dbSelectArea(_cTrab2)
	(_cTrab2)->(dbCloseArea())
EndIf

TCQUERY _cQuery NEW ALIAS (_cTrab2)

While !(_cTrab2)->(Eof())
	Aadd(_aCodFil,AllTrim((_cTrab2)->F2_FILIAL))
	(_cTrab2)->(DbSkip())
EndDo

(_cTrab2)->(dbCloseArea())

//Apaga informações anteriores no diretório
_aDir:=directory(Alltrim(_cCaminho+"\")+"*")

For _ni:= 1 to Len(_aDir)
	
	fErase(Alltrim(_cCaminho+"\")+_aDir[_ni][1])
	
Next _ni

ProcRegua(0)

//F001("02")

//Conecta nas filiais com nota fiscal
For _nn := 1 to Len(_aCodFil)
	
	IncProc("Filial: " + _aCodFil[_nn] + " Aguarde..." )
	
	If ValType(_oServer) == "O"
		
		//Fecha a Conexao com o Servidor
		RESET ENVIRONMENT IN SERVER _oServer
		CLOSE RPCCONN _oServer
		_oServer := Nil
		
	EndIf
	
	CREATE RPCCONN _oServer ON  SERVER _cIpServer	 	;   //IP do servidor
	PORT  _cPorta         								;   //Porta de conexão do servidor
	ENVIRONMENT _cAmb       							;   //Ambiente do servidor
	EMPRESA  cEmpAnt          							;   //Empresa de conexão
	FILIAL  _aCodFil[_nn]          		   				;   //Filial de conexão
	TABLES  _cTabela 				   					;   //Tabela que serão abertas
	MODULO  "SIGAFAT"          								//Módulo de conexão
	
	If ValType(_oServer) == "O"
		
		_oServer:CallProc("RPCSetType", 2)
		
		//F001("03")
		
		_oServer:CallProc("U_GENI021B",_aCodFil[_nn])
		
		//F001("04")
		
		RESET ENVIRONMENT IN SERVER _oServer
		CLOSE RPCCONN _oServer
		_oServer := Nil
		
	Endif
	
Next _nn

//F001("05")

If ValType(_oServer) == "O"
	
	//Fecha a Conexao com o Servidor
	RESET ENVIRONMENT IN SERVER _oServer
	CLOSE RPCCONN _oServer
	_oServer := Nil
	
EndIf

ErrorBlock(_oError1)

ConOut(_cError1)

If(!Empty(_cError1))
	Aviso("Aviso","Ocorreu um erro no processamento, favor verificar a pasta de Log.",{"Ok"})
	Memowrite(_cCaminho+"\"+_cNomeErro1,_cError1)
Else
	Aviso("Aviso","Processo de Importação Finalizado!",{"Ok"})
EndIf

RestArea(_aArea1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI021   ºAutor  ³Leandro Ribeiro     º Data ³  10/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para Realizar a Gravação das Notas Fiscais de Saida º±±
±±º          ³ via integração Protheus x Oracle.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GENI021B(__aCodFil)

Local _aArea2    := GetArea()
Local _aArea3
Local _aArea4
Local _cTrab3    := GetNextAlias()
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
Local _nFlagV    := 0
Local _cEspecie  := ""
Local _aSF2RecNo := {}
Local _aNFSaida	 := {}
Local _aStruSF2	 := SF2->(dbStruct())
Local _aStruSD2  := SD2->(dbStruct())
Local _cView     := GETMV("MV_XNFSAI")	//"TT_I28_NFSAIDA"
Local _cCaminho	 := GETMV("MV_XLOGSAI")
Local _cError2   := ""
Local _oError2 	 := ErrorBlock({|e| _cError2 := e:Description + e:ErrorStack})
Local _cNomeErro2 := "ErroProcessamento"+__aCodFil+"_"+dtos(date())+"_"+StrTran(cValtoChar(Time()),":","")+".txt"

Private _cNumNF  := ""
Private _aErros	 := {}
Private cCampo	 := ""
Private cHelp	 := ""
Private lMSErroAuto	:=.F.
Private lMsHelpAuto :=.F.
Private cSr021 := ""
//F001("06")

//Seleciona notas a serem processadas na filial
cQry := " SELECT * FROM " + _cView + " " + c_ent
cQry += " WHERE " + c_ent
cQry += " F2_FILIAL = '"+__aCodFil+"'" + c_ent
cQry := ChangeQuery(cQry)

If Select(_cTrab3) > 0
	dbSelectArea(_cTrab3)
	(_cTrab3)->(dbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS (_cTrab3)

cSr021	:= Padr(GetMv("GEN_EST005"),Tamsx3("F1_SERIE")[1]," ")

While !(_cTrab3)->(EOF())
	
	//F001("07")
	
	//Zera variaveis de memória
	_aCabNF   := {}
	_aItemNF  := {}
	_aErros   := {}
	_nItens   := 0
	_cCodigo  := ""
	_cLoja    := ""
	_cProduto := ""
	_cUnidade := ""
	cPathLog  := ""
	_cCliente := ""
	_cTes	  := ""
	
	_nIdNfEnt	:= (_cTrab3)->IDPEDIDOOBRA
	_cNFFil		:= (_cTrab3)->F2_FILIAL
	_nFlagV   	:= Alltrim(STR((_cTrab3)->IDPEDIDOOBRA))
	
	//Arquivo de log
	//cPathLog := _cCaminho+"\"+"000"+"_"+AllTrim(STRZERO((_cTrab3)->F2_DOC,9,0))+"_"+dtos(date())+"_"+StrTran(cValtoChar(Time()),":","")+".txt"
	cPathLog := _cCaminho+"\"+"000"+"_"+AllTrim(STRZERO((_cTrab3)->F2_DOC,9,0))+".txt"
	
	//Verifica se nota já existe
	SF2->(DbSetOrder(1))
	If SF2->(DbSeek(xFilial("SF2")+PADR(AllTrim(STRZERO((_cTrab3)->F2_DOC,9,0)),TAMSX3("F2_DOC")[1])+cSr021))
		
		//F001("08")
		
		//Nota Fiscal já Existente.
		Memowrite(cPathLog,"Nota Fiscal de Numero "+AllTrim(STRZERO((_cTrab3)->F2_DOC,9,0))+" já importada!" )
		
		_nFlagV   := Alltrim(STR((_cTrab3)->IDPEDIDOOBRA))
		
		//Inclusão de registro na flag view
		_cQueryINS := "INSERT INTO DBA_EGK.TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) "
		//_cQueryINS += " VALUES ('"+_cView+"','F2_DOC','"+_nFlagV+"','"+xFilial("SF2")+"' ) "
		_cQueryINS += " VALUES ('TT_I28_NFSAIDA','F2_DOC','"+_nFlagV+"','"+xFilial("SF2")+"' ) "
		
		If (TCSqlExec(_cQueryINS) < 0)
			
			//F001("09")
			
			Memowrite(cPathLog,"TCSQLError()" + TCSQLError())
		EndIf
		
		(_cTrab3)->(DbSkip())
		Loop
	Else
		
		//F001("10")
		
		//Verifica se a nota é de devolução e se tem os dados da nota original
		If (_cTrab3)->F2_TIPO == 'D' .and. ;
			( Empty((_cTrab3)->D2_NFORI) .or. Empty((_cTrab3)->D2_SERIORI) )
			
			//F001("11")
			
			//Nota sem dados da devolução
			Memowrite(cPathLog,"Nota Fiscal de devolução sem os dados originais. Numero "+AllTrim(STRZERO((_cTrab3)->F2_DOC,9,0)))
			
			(_cTrab3)->(DbSkip())
			Loop
		EndIf
		
		//Verifica condição de pagamento
		SE4->(DbSetOrder(1))
		If !SE4->(DbSeek(xFilial("SE4")+(_cTrab3)->F2_COND))
			
			//Condiçao de pagamento invalida
			Memowrite(cPathLog,"Condição de pagamento inválida ("+(_cTrab3)->F2_COND+") na Nota Fiscal. Numero "+AllTrim(STRZERO((_cTrab3)->F2_DOC,9,0)))
			
			(_cTrab3)->(DbSkip())
			Loop
		Endif
		
		_cCodigo := Iif(Valtype((_cTrab3)->A1_XCODOLD) == "N",AllTrim(STR((_cTrab3)->A1_XCODOLD)),(_cTrab3)->A1_XCODOLD)
		
		//Verifica se o Fornecedor ou Cliente informado existe na base
		_lRet1 := .F.
		If (_cTrab3)->F2_TIPO == "D"
			
			//F001("12")
			
			SA2->(DbSetOrder(9))
			If SA2->(DbSeek(xFilial("SA2")+PADR(_cCodigo,TAMSX3("A2_XCODOLD")[1])))
				
				//F001("13")
				
				_lRet1 := .T.
				_cCodigo := SA2->A2_COD
				_cLoja 	 := SA2->A2_LOJA
			Else
				
				//F001("14")
				
				_lRet1 := .F.
				_cCodigo := Alltrim((_cTrab3)->A1_XCODOLD)
				_cLoja 	 := "XX"
			EndIf
		Else
			
			//F001("15")
			
			//Posiciona no cliente
			SA1->(DbSetOrder(9))
			If SA1->(DbSeek(xFilial("SA1")+PADR(_cCodigo,TAMSX3("A1_XCODOLD")[1])))
				
				//F001("16")
				
				_lRet1 := .T.
				_cCodigo := SA1->A1_COD
				_cLoja 	 :=	SA1->A1_LOJA
				
			Else
				
				//F001("17")
				
				_lRet1 := .F.
				_cCodigo := Alltrim((_cTrab3)->A1_XCODOLD)
				_cLoja 	 := "XX"
			EndIf
		EndIf
		
		//F001("18")
		
		//Caso tenha encontrado cliente/fornecedor gera a nota
		If _lRet1
			
			//F001("19")
			
			//Cabeçalho da nota fiscal
			_aCabNF   := {}
			_aItemNF  := {}
			dEmissao  := dDataBase
			dDataBase := STOD((_cTrab3)->F2_EMISSAO)
			_cTipo	 := (_cTrab3)->F2_TIPO
			
			For j := 1 to len(_aStruSF2)
				Do Case
					Case ALLTRIM(_aStruSF2[j][1]) == 'F2_FILIAL'	// Filial
						Aadd( _aCabNF, xFilial("SF2"))
						
					Case ALLTRIM(_aStruSF2[j][1]) == 'F2_DOC' 	// Numero do Documento
						Aadd( _aCabNF, AllTrim(STRZERO((_cTrab3)->F2_DOC,9,0)))
						
					Case ALLTRIM(_aStruSF2[j][1]) == 'F2_SERIE' // Serie
						Aadd( _aCabNF, cSr021)
						
					Case ALLTRIM(_aStruSF2[j][1]) == "F2_CLIENTE" 	// Codigo do Cliente
						Aadd( _aCabNF, _cCodigo)
						
					Case ALLTRIM(_aStruSF2[j][1]) == "F2_LOJA" // Loja do Cliente
						Aadd( _aCabNF, _cLoja)
						
					Case ALLTRIM(_aStruSF2[j][1]) == "F2_COND" // Condição de pagamento
						Aadd( _aCabNF, (_cTrab3)->F2_COND)
						
					Case ALLTRIM(_aStruSF2[j][1]) == "F2_EMISSAO" // Data de Emissão
						Aadd( _aCabNF, dDataBase)
						
					Case ALLTRIM(_aStruSF2[j][1]) == "F2_TIPO" 	// Tipo do Pedido
						Aadd( _aCabNF, _cTipo)
						
					Case ALLTRIM(_aStruSF2[j][1]) == "F2_EST" // Estado
						Aadd( _aCabNF, Alltrim((_cTrab3)->F2_EST))
						
					Case ALLTRIM(_aStruSF2[j][1]) == "F2_FORMUL" // Formula
						Aadd( _aCabNF, (_cTrab3)->F2_FORMUL)
						
					Case ALLTRIM(_aStruSF2[j][1]) == "F2_ESPECIE" // Especie
						Aadd( _aCabNF, (_cTrab3)->F2_ESPECIE)
						
					Case ALLTRIM(_aStruSF2[j][1]) == 'F2_DTDIGIT'	// Data de Digitação
						Aadd( _aCabNF, dEmissao)
						
					Case ALLTRIM(_aStruSF2[j][1]) == 'F2_TPFRETE' 	// Tipo de Frete
						Aadd( _aCabNF, (_cTrab3)->F2_TPFRETE)
						
					Case ALLTRIM(_aStruSF2[j][1]) == 'F2_FRETE' // Frete
						Aadd( _aCabNF, (_cTrab3)->F2_FRETE)
						
					Case ALLTRIM(_aStruSF2[j][1]) == "F2_DESPESA" 	// Despesa
						Aadd( _aCabNF, (_cTrab3)->F2_DESPESA)
						
					Case ALLTRIM(_aStruSF2[j][1]) == "F2_DESCONT" // Desconto
						Aadd( _aCabNF, (_cTrab3)->F2_DESCONT)
						
					Case ALLTRIM(_aStruSF2[j][1]) == "F2_TRANSP" // Transporte
						Aadd( _aCabNF, Alltrim(STR((_cTrab3)->F2_TRANSP)))
						
					Case ALLTRIM(_aStruSF2[j][1]) == "F2_VEND1" //
						Aadd( _aCabNF, Iif(Valtype((_cTrab3)->F2_VEND1) == "N",AllTrim(STRZERO((_cTrab3)->F2_VEND1,3,0)),(_cTrab3)->F2_VEND1))
						
					Case ALLTRIM(_aStruSF2[j][1]) == "F2_HORA" 	// Hora
						Aadd( _aCabNF, (_cTrab3)->F2_HORA)
						
					Case ALLTRIM(_aStruSF2[j][1]) == "F2_VALBRUT" // Valor Bruto
						Aadd( _aCabNF, (_cTrab3)->F2_VALBRUT)
						
					Otherwise
						Aadd( _aCabNF, CriaVar(_aStruSF2[j][1])  )
						// Campos excedentes do cabecalho da nota fiscal, necessarios na rotina mata461
						// para geracao de nota sem pedido de venda.
				EndCase
			Next
			
			//F001("20")
			
			//Itens da nota
			_nErro := 0
			While !(_cTrab3)->(Eof()) ;
				.and. _cNFFil == (_cTrab3)->F2_FILIAL;
				.and. _nIdNfEnt == (_cTrab3)->IDPEDIDOOBRA;
				.and. _nErro == 0
				
				//F001("21")
				
				//Verifica se o TES informado existe na base
				_cTes := Iif(Valtype((_cTrab3)->D2_TES) == "N",AllTrim(STRZERO((_cTrab3)->D2_TES,3,0)),(_cTrab3)->D2_TES)
				
				SF4->(DbSetOrder(1))
				If SF4->(DbSeek(xFilial("SF4")+PADR(Alltrim(_cTes),TAMSX3("F4_CODIGO")[1])))
					
					//F001("22")
					
					//SB1->(DbSetOrder(11))
					// cleuto lima - alterado pois este indice é proprietario totvs e deve ser tulizado nickname
					SB1->(DbOrderNickName("GENISBN"))					
					If SB1->(DbSeek(xFilial("SB1")+PADR(Alltrim((_cTrab3)->D2_COD),TAMSX3("B1_COD")[1])))
						
						//F001("23")
						
						_cProduto := PADR(Alltrim(SB1->B1_COD),TAMSX3("B1_COD")[1])
						_cUnidade := PADR(Alltrim(SB1->B1_UM),TAMSX3("B1_UM")[1])
						
						("SB1")->(dbCloseArea())
						
						aadd(_aItemNF,{})
						nLen := Len(_aItemNF)
						_nItens++
						aAdd(_aSF2RecNo,0)
						
						For j := 1 to len(_aStruSD2)
							
							Do Case
								Case ALLTRIM(_aStruSD2[j][1]) == 'D2_FILIAL'
									Aadd( _aItemNF[nLen], xFilial("SD2"))
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_ITEM"
									Aadd( _aItemNF[nLen], STRZERO(_nItens,4,0))
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_COD"
									Aadd( _aItemNF[nLen], _cProduto)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_UM"
									Aadd( _aItemNF[nLen], _cUnidade)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_QUANT"
									Aadd( _aItemNF[nLen], (_cTrab3)->D2_QUANT)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_CLIENTE"
									Aadd( _aItemNF[nLen], _cCodigo)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_LOJA"
									Aadd( _aItemNF[nLen], _cLoja)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_QUANT"
									Aadd( _aItemNF[nLen], (_cTrab3)->D2_QUANT)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_PRCVEN"
									Aadd( _aItemNF[nLen], (_cTrab3)->D2_PRCVEN)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_TOTAL"
									Aadd( _aItemNF[nLen], (_cTrab3)->D2_TOTAL)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_TES"
									Aadd( _aItemNF[nLen], _cTes)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_TIPO"
									Aadd( _aItemNF[nLen], _cTipo)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_EST"
									Aadd( _aItemNF[nLen], Alltrim((_cTrab3)->F2_EST))
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_PRUNIT"
									Aadd( _aItemNF[nLen], (_cTrab3)->D2_PRUNIT)
									
								Case ALLTRIM(_aStruSD2[j][1]) == 'D2_CF'
									Aadd( _aItemNF[nLen], Alltrim(STR((_cTrab3)->D2_CF)))
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_ITEMCC"
									Aadd( _aItemNF[nLen], (_cTrab3)->D2_ITEMCC)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_LOCAL"
									Aadd( _aItemNF[nLen], "01")
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_CLVL"
									Aadd( _aItemNF[nLen], (_cTrab3)->D2_CLVL)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_CONTA"
									Aadd( _aItemNF[nLen], (_cTrab3)->D2_CONTA)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_CCUSTO"
									Aadd( _aItemNF[nLen], (_cTrab3)->D2_CCUSTO)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_DOC"
									Aadd( _aItemNF[nLen], AllTrim(STRZERO((_cTrab3)->F2_DOC,9,0)))
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_SERIE"
									Aadd( _aItemNF[nLen], cSr021)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_EMISSAO"
									Aadd( _aItemNF[nLen], Ddatabase)
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_NFORI"
									Aadd( _aItemNF[nLen], Iif(_cTipo == "D", AllTrim(STRZERO(Val((_cTrab3)->D2_NFORI),9,0)),""))
									
								Case ALLTRIM(_aStruSD2[j][1]) == "D2_SERIORI"
									Aadd( _aItemNF[nLen], Iif(_cTipo == "D",AllTrim(STRZERO(Val((_cTrab3)->D2_SERIORI),3,0)),""))
									
								Otherwise
									Aadd( _aItemNF[nLen], CriaVar(_aStruSD2[j][1])  )
									// Campos excedentes do cabecalho da nota fiscal, necessarios na rotina mata461
									// para geracao de nota sem pedido de venda.
							EndCase
						Next
						
						//F001("24")
						
						_nFlagV   := Alltrim(STR((_cTrab3)->IDPEDIDOOBRA))
						_cNumNF   := AllTrim(STRZERO((_cTrab3)->F2_DOC,9,0))
						_cEspecie := (_cTrab3)->F2_ESPECIE
						
					Else
						
						//F001("25")
						
						//Produto inexistente
						_nErro++
						Memowrite(cPathLog,"Codigo "+ Alltrim((_cTrab3)->D2_COD) +" de Produto inexistente! ")
					EndIf
				Else
					
					//F001("26")
					
					//TES inexistente
					_nErro++
					Memowrite(cPathLog,"Codigo " +Alltrim((_cTrab3)->D2_TES)+ "de TES inexistente! ")
				EndIf
				
				//F001("27")
				
				(_cTrab3)->(DbSkip())
			EndDo
			
			//F001("28")
			
			If Len(_aItemNF) == 0
				
				//Não foram gerados itens
				Memowrite(cPathLog,"Falha para gerar os itens da Nota Fiscal de Numero "+AllTrim(STRZERO((_cTrab3)->F2_DOC,9,0))+"e Serie 10.")
			Endif
			
			//Caso encontre erro, passa todos os itens dessa nota
			If _nErro <> 0
				
				//Laço para posicionar na proxina nota
				While !(_cTrab3)->(Eof()) ;
					.and. _cNFFil == (_cTrab3)->F2_FILIAL;
					.and. _nIdNfEnt == (_cTrab3)->IDPEDIDOOBRA
					
					(_cTrab3)->(DbSkip())
				End
				
				//Efetua inclusão da nota caso não existam erros
			ElseIf _nErro == 0 .and. Len(_aItemNF) > 0
				
				//F001("29")
				
				_aArea3 := GetArea()
				_aArea4 := (_cTrab3)->(GetArea())
				
				DBASEOLD := DDATABASE
				DDATABASE := dEmissao
				
				_cNota := MaNfs2Nfs(,,_cCodigo,_cLoja,"000",,.F.,.F.,,,,,,,,,,{|| .T.},_aSF2RecNo,_aItemNF,_aCabNF,.F.,{|| .T.},{|| .T.},{|| .T.},)
				_cNota := PADR(_cNota,TamSX3("F2_DOC")[1])
				
				DDATABASE := DBASEOLD
				
				RestArea(_aArea4)
				RestArea(_aArea3)
				
				//F001("30")
				
				If(EMPTY(_cNota))
					
					F001("31" + "- Erro para gravar a Nota Fiscal de Numero "+_cNumNF)
					
					Memowrite(cPathLog,"Nota Fiscal de Numero "+_cNumNF+" e Serie 10"+" Erro ao Gravar Nota Fiscal!")
					
					DisamTransaction()
					
				Else
					
					//F001("32")
					
					//Atualiza a especie da nota
					_cQuery := "UPDATE " + 	RetSqlName("SF2")
					_cQuery += " SET F2_ESPECIE = '" + _cEspecie + "'
					_cQuery += " WHERE F2_FILIAL = '" + xFilial("SF2") + "'
					_cQuery += " AND F2_DOC 		= '" + _cNota + "'
					_cQuery += " AND F2_SERIE 	= '" + cSr021	+ "'
					_cQuery += " AND F2_CLIENTE 	= '" + _cCodigo + "'
					_cQuery += " AND F2_LOJA 	= '" + _cLoja + "'
					_cQuery += " AND D_E_L_E_T_ = ' '
					TCSQLEXEC(_cQuery)
					
					F001("33" + "- Insert view F2_DOC " + _cNota )
					
					//Insert na flag view
					_cQueryINS := "INSERT INTO DBA_EGK.TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL)"
					//_cQueryINS += " VALUES ('"+_cView+"','F2_DOC','"+_nFlagV+"','"+xFilial("SF2")+"' )"
					_cQueryINS += " VALUES ('TT_I28_NFSAIDA','F2_DOC','"+_nFlagV+"','"+xFilial("SF2")+"' ) "
					
					If (TCSqlExec(_cQueryINS) < 0)
						Memowrite(cPathLog,"TCSQLError()" + TCSQLError())
					EndIf
				Endif
			Endif
		Else
			
			//F001("34")
			
			//Cliente
			If (_cTrab3)->F2_TIPO = "D"
				Memowrite(cPathLog,"Codigo "+ Alltrim(_cCodigo) +" de Fornecedor inexistente!")
			Else
				Memowrite(cPathLog,"Codigo "+ Alltrim(_cCodigo) +" de Cliente inexistente!")
			Endif
			(_cTrab3)->(DbSkip())
			Loop
		Endif
	Endif
	
	//F001("35")
	
	ErrorBlock(_oError2)
	If(!Empty(_cError2))
		ConOut(_cError2)
		Memowrite(_cNomeErro2,_cError2)
	EndIf
End

//F001("36")

If Select(_cTrab3) > 0
	dbSelectArea(_cTrab3)
	(_cTrab3)->(dbCloseArea())
EndIf

RestArea(_aArea2)

Return

Static Function f001( _cMsgCon)

ConOut("GENI021-"+DtoC(dDataBase)+"-"+Time()+"- Status: " + _cMsgCon)

Return
