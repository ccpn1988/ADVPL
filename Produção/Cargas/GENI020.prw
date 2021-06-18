#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#DEFINE   c_ent      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI020   ºAutor  ³Leandro Ribeiro     º Data ³  10/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de importação de Nota Fiscal de Entrada.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GENI020()

If MsgYesNo("Deseja efetuar a importação de notas fiscais de saída?")
	Processa({|| GENI020A()},"Processando...")
Endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI020   ºAutor  ³Leandro Ribeiro     º Data ³  09/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para realizar a troca de filiais.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GENI020A()

Local _aArea1  := GetArea()
Local _aCodFil := {}
Local _cTabela := "SB1,SA2,SF1,SD1,SAH,SF4,CT1,CTD,CTT,CTH,SA1"
Local _oServer := Nil
Local _cAmb	   := GetEnvServer()
Local _cQuery  := ""
Local _cTrab2  := GetNextAlias()
Local _cIpServer := GETMV("MV_XIPSERV")	//"10.1.0.243"
Local _cPorta  	 := GETMV("MV_XPORTA")	//1998
Local _cView     := GETMV("MV_XNFENT")	//"TT_I27_NFENTRADA"
Local _cCaminho	 := GETMV("MV_XLOGENT")  //'\logsiga\nf entrada'
Local _nRet		 := MakeDir(_cCaminho)   // Criação da Pasta para gravação do log
Local cPathLog 	 := ""
Local _cError1   := ""
Local _oError1 	 := ErrorBlock({|e| _cError1 := e:Description + e:ErrorStack})
Local _ni,_nn
Local _cNomeErro1 := "ErroProcessamento"+"_"+dtos(date())+"_"+StrTran(cValtoChar(Time()),":","")+".txt"

If(_nRet != 0)
	Conout("Erro Protheus não pode criar o diretorio. Erro: "+cValToChar(FError()))
EndIf

//Seleciona as filiais que serão processadas
_cQuery := "SELECT DISTINCT F1_FILIAL
_cQuery += " FROM " + _cView
_cQuery += " WHERE F1_FILIAL = '1022'
_cQuery += " ORDER BY F1_FILIAL
_cQuery := ChangeQuery(_cQuery)

If Select(_cTrab2) > 0
	dbSelectArea(_cTrab2)
	(_cTrab2)->(dbCloseArea())
EndIf

TCQUERY _cQuery NEW ALIAS (_cTrab2)

Do While !(_cTrab2)->(Eof())
	Aadd(_aCodFil,AllTrim((_cTrab2)->F1_FILIAL))
	(_cTrab2)->(DbSkip())
EndDo

(_cTrab2)->(dbCloseArea())
_aDir:=directory(Alltrim(_cCaminho+"\")+"*") //Cria diretórios de log

For _ni:= 1 to Len(_aDir)
	fErase(Alltrim(_cCaminho+"\")+_aDir[_ni][1])
Next _ni

//Percorre em todas as filiais com notas e faz o RPC
For _nn := 1 to Len(_aCodFil)
	//Verifica se objeto de conexão está finalizado
	If ValType(_oServer) == "O"
		//Fecha a Conexao com o Servidor
		RESET ENVIRONMENT IN SERVER _oServer
		CLOSE RPCCONN _oServer
		_oServer := Nil
	EndIf
	
	//Cria nova conexão
	CREATE RPCCONN _oServer ON  SERVER _cIpServer	 	;   //IP do servidor
	PORT _cPorta         								;   //Porta de conexão do servidor
	ENVIRONMENT _cAmb       							;   //Ambiente do servidor
	EMPRESA  cEmpAnt          							;   //Empresa de conexão
	FILIAL  _aCodFil[_nn]          		   				;   //Filial de conexão
	TABLES  _cTabela 				   					;   //Tabela que serão abertas
	MODULO  "SIGACOM"               								//Módulo de conexão
	
	//Verifica se conectou corretamente
	If ValType(_oServer) == "O"
		//Executa função de importação de notas
		_oServer:CallProc("RPCSetType", 3)
		_oServer:CallProc("U_GENI020C",_aCodFil[_nn])
		
		//Fecha a Conexao com o Servidor
		RESET ENVIRONMENT IN SERVER _oServer
		CLOSE RPCCONN _oServer
		_oServer := Nil
	EndIf
Next _nn

If ValType(_oServer) == "O"
	
	//Fecha a Conexao com o Servidor
	RESET ENVIRONMENT IN SERVER _oServer
	CLOSE RPCCONN _oServer
	_oServer := Nil
	
EndIf

ErrorBlock(_oError1)

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
±±ºPrograma  ³GENI020   ºAutor  ³Leandro Ribeiro     º Data ³  10/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para Realizar a Gravação das Notas Fiscais de Entra-º±±
±±º          ³ da via integração Protheus x Oracle.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GENI020C(__aCodFil)

Local _aArea2    := GetArea()
Local _aArea3
Local _cTrab3    := GetNextAlias()
Local cQry       := ""
Local cQuery     := ""
Local _aCabSF1   := {}
Local _aItemSD1  := {}
Local _lRet1	 := .F.
Local _lRet2	 := .F.
Local _cCodigo   := ""
Local _cLoja	 := ""
Local _cProduto	 := ""
Local _cUnidade  := ""
Local _cNFOrin   := ""
Local _cSerieOr  := ""
Local _cTipo	 := ""
Local _nItens	 := 0
Local _cQueryINS := ""
Local _aNFent    := {}
Local _cView     := GETMV("MV_XNFENT")
Local _cCaminho	 := GETMV("MV_XLOGENT")
Local _cError2   := ""
Local _oError2 	 := ErrorBlock({|e| _cError2 := e:Description + e:ErrorStack})
Local _cNomeErro2 := "ErroProcessamento"+__aCodFil+"_"+dtos(date())+"_"+StrTran(cValtoChar(Time()),":","")+".txt"
Local _nIdNfEnt	 := 0
Local _cIdNfEnt	 := ""
Local _cF1Doc	 := ""

Private _aErros	 := {}
Private cCampo	 := ""
Private cHelp	 := ""
Private lMSErroAuto	:=.F.
Private lMsHelpAuto :=.F.

//Seleciona todas as notas da filial
cQry := " SELECT * FROM " + _cView
cQry += " WHERE F1_FILIAL = '"+__aCodFil+"'

cQry := ChangeQuery(cQry)

TCQUERY cQry NEW ALIAS (_cTrab3)

//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM+D1_FORMUL
_cNFFil := ""
_cNFDoc := ""
_cNFSer := ""
_cNFFor := ""
_cNFLoj := ""
_cNFItm := ""
_cNFFml := ""
cSr020	:= Padr(GetMv("GEN_EST005"),Tamsx3("F1_SERIE")[1]," ")

//Percorre todos as notas desta filial
While !(_cTrab3)->(EOF())
	
	//Carrega chave
	_cIdNfEnt	:= Alltrim(STR((_cTrab3)->IDNFENTRADA))
	_nIdNfEnt	:= (_cTrab3)->IDNFENTRADA
	_cNFFil	:= (_cTrab3)->F1_FILIAL
	_cNFDoc := AllTrim(STRZERO((_cTrab3)->F1_DOC,9,0))
	_cNFSer := (_cTrab3)->F1_SERIE
	_cNFFor := (_cTrab3)->F1_FORNECE
	_cNFLoj := (_cTrab3)->F1_LOJA
	_cNFFml := (_cTrab3)->F1_FORMUL
	
	_aCabSF1  := {}
	_aItemSD1 := {}
	_aLinha   := {}
	_aErros   := {}
	_nItens   := 0
	_cCodigo  := ""
	_cLoja    := ""
	_cProduto := ""
	_cUnidade := ""
	_lRet1	  := .F.
	cPathLog  := _cCaminho+"\"+"000"+"_"+AllTrim(STRZERO((_cTrab3)->F1_DOC,9,0))+"_" + Alltrim((_cTrab3)->F1_FORNECE) + ".txt"
	_cNFOrin  := ""
	_cSerieOr := ""
	lMSErroAuto	:=.F.
	
	//Pesquisa nota fiscal
	SF1->(DbSetOrder(1))
	If SF1->(DbSeek(xFilial("SF1")+AllTrim(STRZERO((_cTrab3)->F1_DOC,9,0))+"000"))
		
		//Nota Fiscal já Existente.
		Memowrite(cPathLog,"Nota Fiscal de Numero "+AllTrim(STRZERO((_cTrab3)->F1_DOC,9,0))+" 000"+" já importada!" )
		
		//Incluindo na view da GEN a informação pertinente ao pedido para que a mesma possa ser excluida da view original de consulta
		//para que o pedido não tente ser gravado novamente, gerando log desnecessário
		_cQueryINS := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) "
		_cQueryINS += " VALUES ('"+_cView+"','F1_DOC','"+Alltrim(_cIdNfEnt)+"','"+xFilial("SF1")+"' ) "
		
		If (TCSqlExec(_cQueryINS) < 0)
			
			Conout("TCSQLError()" + TCSQLError())
		EndIf
		
		(_cTrab3)->(DbSkip())
		
		//Nota não encontrada, pode ser inserida
	Else
		
		//Verifica se o Fornecedor ou Cliente informado existe na base
		If (_cTrab3)->F1_TIPO == "D"
			
			//Posiciona no cliente
			SA1->(DbSetOrder(9))
			If SA1->(DbSeek(xFilial("SA1")+PADR((_cTrab3)->F1_FORNECE,TAMSX3("A1_XCODOLD")[1])))
				
				_lRet1 := .T.
				_cCodigo := SA1->A1_COD
				_cLoja 	 :=	SA1->A1_LOJA
				
			Else
				
				_lRet1 := .F.
				_cCodigo := Alltrim((_cTrab3)->F1_FORNECE)
				_cLoja 	 := "XX"
			EndIf
			
		Else
			SA2->(DbSetOrder(9))
			If SA2->(DbSeek(xFilial("SA2")+PADR((_cTrab3)->F1_FORNECE,TAMSX3("A2_XCODOLD")[1])))
				
				_lRet1 := .T.
				_cCodigo := SA2->A2_COD
				_cLoja 	 := SA2->A2_LOJA
			Else
				
				_lRet1 := .F.
				_cCodigo := Alltrim((_cTrab3)->F1_FORNECE)
				_cLoja 	 := "XX"
			EndIf
		EndIf
		
		If _lRet1
			
			//Adiciona informações do cabeçalho
			_cTipo	 := (_cTrab3)->F1_TIPO
			
			Aadd(_aCabSF1,{"F1_FILIAL"   ,xFilial("SF1")             					,Nil})
			Aadd(_aCabSF1,{"F1_DOC"      ,AllTrim(STRZERO((_cTrab3)->F1_DOC,9,0))	 	,Nil})
			Aadd(_aCabSF1,{"F1_SERIE"    ,cSr020	,Nil})
			Aadd(_aCabSF1,{"F1_FORNECE"  ,_cCodigo	     								,Nil})
			Aadd(_aCabSF1,{"F1_LOJA"     ,_cLoja			 							,Nil})
			Aadd(_aCabSF1,{"F1_COND"     ,(_cTrab3)->F1_COND              		 		,Nil})
			Aadd(_aCabSF1,{"F1_EMISSAO"  ,STOD((_cTrab3)->F1_EMISSAO)	 				,Nil})
			Aadd(_aCabSF1,{"F1_TIPO"     ,_cTipo			                		 	,Nil})
			Aadd(_aCabSF1,{"F1_EST"      ,Alltrim((_cTrab3)->F1_EST)        		 	,Nil})
			Aadd(_aCabSF1,{"F1_FORMUL"   ,(_cTrab3)->F1_FORMUL                        	,Nil})
			Aadd(_aCabSF1,{"F1_ESPECIE"  ,(_cTrab3)->F1_ESPECIE                      	,Nil})
			Aadd(_aCabSF1,{"F1_DTDIGIT"  ,dDataBase										,Nil})//dDataBase
			Aadd(_aCabSF1,{"F1_FRETE"    ,(_cTrab3)->F1_FRETE		   					,Nil})
			Aadd(_aCabSF1,{"F1_DESPESA"  ,(_cTrab3)->F1_DESPESA		  					,Nil})
			Aadd(_aCabSF1,{"F1_DESCONT"  ,(_cTrab3)->F1_DESCONT		  					,Nil})
			
			_nErro := 0
			
			While !(_cTrab3)->(EOF()) .and. _cNFFil == (_cTrab3)->F1_FILIAL .and. _nIdNfEnt == (_cTrab3)->IDNFENTRADA .and. _nErro == 0
				
				//Pesquisa TES
				SF4->(DbSetOrder(1))
				If SF4->(DbSeek(xFilial("SF4")+PADR(Alltrim((_cTrab3)->D1_TES),TAMSX3("F4_CODIGO")[1])))
					
					//Pesquisa produto
					//SB1->(DbSetOrder(11))
					// cleuto lima - alterado pois este indice é proprietario totvs e deve ser tulizado nickname
					SB1->(DbOrderNickName("GENISBN"))					
					If SB1->(DbSeek(xFilial("SB1")+PADR(Alltrim((_cTrab3)->D1_COD),TAMSX3("B1_ISBN")[1])))
						
						_aLinha := {}
						
						_nItens++
						
						_cProduto := PADR(Alltrim(SB1->B1_COD),TAMSX3("B1_COD")[1])
						//_cUnidade := PADR(Alltrim(SB1->B1_UM),TAMSX3("B1_UM")[1])
						
						Aadd(_aLinha,{"D1_FILIAL"	,xFilial("SD1") 	 	  					,Nil})
						Aadd(_aLinha,{"D1_ITEM"		,STRZERO(_nItens,4,0)	 					,Nil})
						Aadd(_aLinha,{"D1_COD"		,_cProduto				  					,Nil})
						//Aadd(_aLinha,{"D1_UM"		,_cUnidade				 					,Nil})
						Aadd(_aLinha,{"D1_QUANT"	,(_cTrab3)->D1_QUANT	 					,Nil})
						Aadd(_aLinha,{"D1_VUNIT"	,(_cTrab3)->D1_VUNIT	  					,Nil})
						Aadd(_aLinha,{"D1_TOTAL"	,(_cTrab3)->D1_TOTAL	   					,Nil})
						Aadd(_aLinha,{"D1_TES"		,(_cTrab3)->D1_TES		  					,Nil})
						Aadd(_aLinha,{"D1_CONTA"	,(_cTrab3)->D1_CONTA	  					,Nil})
						Aadd(_aLinha,{"D1_ITEMCTA"	,(_cTrab3)->D1_ITEMCTA	  					,Nil})
						Aadd(_aLinha,{"D1_CC"		,(_cTrab3)->D1_CC		  					,Nil})
						Aadd(_aLinha,{"D1_CLVL"		,(_cTrab3)->D1_CLVL	  						,Nil})
						Aadd(_aLinha,{"D1_TIPO"		,(_cTrab3)->F1_TIPO	   						,Nil})
						Aadd(_aLinha,{"D1_FORNECE"  ,_cCodigo									,Nil})
						Aadd(_aLinha,{"D1_LOJA"     ,_cLoja 									,Nil})
						Aadd(_aLinha,{"D1_DOC"      ,AllTrim(STRZERO((_cTrab3)->F1_DOC,9,0))	,Nil})
						Aadd(_aLinha,{"D1_EMISSAO"  ,STOD((_cTrab3)->F1_EMISSAO)  				,Nil})
						Aadd(_aLinha,{"D1_SERIE"    ,cSr020										,Nil})
						
						If((_cTrab3)->F1_TIPO == "D")
							
							Aadd(_aLinha,{"D1_NFORI"	,AllTrim(STRZERO(Val((_cTrab3)->D1_NFORI),9,0)) 	,Nil})
							Aadd(_aLinha,{"D1_SERIORI"	,AllTrim(STRZERO(Val((_cTrab3)->D1_SERIORI),3,0))	,Nil})
						EndIf
						
						Aadd(_aLinha,{"AUTDELETA"    ,"N"                     	,Nil})
						
						Aadd(_aItemSD1,_aLinha)
						
					Else
						//Produto não encontrado
						_nErro++
						Memowrite(cPathLog,"Codigo "+ Alltrim((_cTrab3)->D1_COD) +" de Produto inexistente! ")
					Endif
				Else
					//TES inexistente
					_nErro++
					Memowrite(cPathLog,"Codigo " +Alltrim((_cTrab3)->D1_TES)+ "de TES inexistente! ")
				Endif
				
				(_cTrab3)->(DbSkip())
			End
			
			//Caso tenha encontrado erro, posiciona na proxima nota
			If _nErro <> 0
				While !(_cTrab3)->(EOF()) .and. _cNFFil == (_cTrab3)->F1_FILIAL .and. _nIdNfEnt == (_cTrab3)->IDNFENTRADA
					(_cTrab3)->(DbSkip())
				End
			ElseIf _nErro == 0
				
				SB1->(DbCloseArea())
				
				_aArea3 := GetArea()
				_aArea4 := (_cTrab3)->(GetArea())
				
				//Executa gravação do documento de entrada
				lMSErroAuto	:=.F.
				
				MSExecAuto({|x,y,z| MATA103(x,y,z)},_aCabSF1,_aItemSD1,3)
				
				RestArea(_aArea4)
				RestArea(_aArea3)
				
				If lMsErroAuto
					MostraErro(_cCaminho,"\"+"000"+"_"+AllTrim(STRZERO(_cF1Doc,9,0))+"_"+_cCodigo+_cLoja+".txt")
				Else
					//Incluindo na view da GEN a informação pertinente ao pedido para que a mesma possa ser excluida da view original de consulta
					//para que o pedido não tente ser gravado novamente, gerando log desnecessário
					_cQueryINS := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) "
					_cQueryINS += " VALUES ('"+_cView+"','F1_DOC','"+Alltrim(_cIdNfEnt)+"','"+xFilial("SF1")+"' ) "
					If (TCSqlExec(_cQueryINS) < 0)
						Conout("TCSQLError()" + TCSQLError())
					EndIf
				Endif
			Endif
		Else
			//Fornecedor não encontrado
			Memowrite(cPathLog,"Codigo "+ Alltrim((_cTrab3)->F1_FORNECE) +" de Fornecedor inexistente! ")
			(_cTrab3)->(DbSkip())
		Endif
	End
	
	//ErrorBlock(_oError2)
	
	//If(!Empty(_cError2))
	//	Memowrite(_cCaminho+"\"+_cNomeErro2,_cError2)
	//EndIf
End

RestArea(_aArea2)

Return()
