#include 'protheus.ch'
#INCLUDE "Protheus.ch" 
#include "Fileio.ch"
#Include "Report.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA042   ºAutor  ³Cleuto Lima - Loop  º Data ³  30/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Gen                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA042()

Local _cPerg	:= "GENA042"

PutSx1(_cPerg, "01", "Fornecedor:"	,	"Fornecedor:"	,	"Fornecedor:"	,	"mv_ch1", "C", TamSx3("A2_COD")[1]	, 0, 0, "G","", "SA2"	, "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(_cPerg, "02", "Loja:"		,		"Loja:"		,	"Loja:"			,	"mv_ch2", "C", TamSx3("A2_LOJA")[1]	, 0, 0, "G","", ""		, "", "", "MV_PAR02","","","","","","","","","","","","","","","","")

If !Pergunte("GENA042",.T.)
	Return
Endif

LJMsgRun("Gerando pedidos...","Aguarde...",{|| ProcPed() })

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA042   ºAutor  ³Microsiga           º Data ³  02/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcPed()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da rotina.                                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local _cSQL		:= ""
Local _cCodFor
Local _cLojFor
Local _cAlias1 	:= GetNextAlias()
Local _cMvCdDe 	:= "001" //GetMv("GEN_FAT093") // Contém a condição de pagamento 
Local _cTesDev	:= "521" //GetMV("GEN_FAT094") // TES para devolução de consignação
Local cQuebra	:= Chr(13)+Chr(10)
Local cPedidos	:= ""
Local cVend		:= ""
Local _cTipo	:= "B"
                        
Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

_cCodFor	:= MV_PAR01
_cLojFor	:= MV_PAR02

_cSQL += " SELECT B6_FILIAL,B6_CLIFOR,B6_LOJA,B6_PRODUTO,B6_LOCAL,B6_DOC,B6_SERIE,B6_SALDO,B6_QUANT,B6_PRUNIT,B6_TES,D1_ITEM,B1_DESC,D1_QUANT,B6_IDENT,D1_VALDESC,D1_VUNIT,D1_TOTAL FROM "+RetSqlName("SB6")+" SB6 "+cQuebra
_cSQL += " JOIN "+RetSqlName("SB1")+" SB1 "+cQuebra
_cSQL += " ON B1_FILIAL = '"+xFilial("SB1")+"' "+cQuebra
_cSQL += " AND B1_COD = B6_PRODUTO "+cQuebra
_cSQL += " AND SB1.D_E_L_E_T_ <> '*' "+cQuebra
_cSQL += " JOIN "+RetSqlName("SF4")+" SF4 "+cQuebra
_cSQL += " ON F4_FILIAL = '"+xFilial("SF4")+"' "+cQuebra
_cSQL += " AND F4_CODIGO = B6_TES "+cQuebra
_cSQL += " AND F4_ESTOQUE = 'S' "+cQuebra
_cSQL += " AND F4_PODER3 = 'R' "+cQuebra
_cSQL += " AND F4_TIPO = 'E' "+cQuebra
_cSQL += " AND SF4.D_E_L_E_T_ <> '*' "+cQuebra
_cSQL += " JOIN "+RetSqlName("SD1")+" SD1 "+cQuebra
_cSQL += " ON D1_FILIAL = B6_FILIAL "+cQuebra
_cSQL += " AND D1_FORNECE = B6_CLIFOR "+cQuebra
_cSQL += " AND D1_LOJA = B6_LOJA "+cQuebra
_cSQL += " AND D1_DOC = B6_DOC "+cQuebra
_cSQL += " AND D1_SERIE = B6_SERIE "+cQuebra
_cSQL += " AND D1_COD = B6_PRODUTO "+cQuebra
_cSQL += " AND D1_DTDIGIT < '20160211' "+cQuebra
_cSQL += " AND SD1.D1_IDENTB6 = SB6.B6_IDENT "+cQuebra
_cSQL += " AND (SD1.D1_QUANT - SD1.D1_QTDEDEV) >= SB6.B6_SALDO "+cQuebra
_cSQL += " AND SD1.D_E_L_E_T_ <> '*' "+cQuebra
_cSQL += " WHERE B6_FILIAL = '"+xFilial("SB6")+"' "+cQuebra
_cSQL += " AND SB6.B6_CLIFOR = '"+_cCodFor+"' "+cQuebra
_cSQL += " AND SB6.B6_LOJA = '"+_cLojFor+"' "+cQuebra
_cSQL += " AND B6_SALDO > 0 "+cQuebra
_cSQL += " AND B6_TIPO = 'D' "+cQuebra
_cSQL += " AND B6_PODER3 = 'R' "+cQuebra   
_cSQL += " AND B6_PRODUTO NOT IN ('04215782') "+cQuebra                         
_cSQL += " AND B6_TPCF = 'F' "+cQuebra
_cSQL += " AND SB6.D_E_L_E_T_ <> '*' "+cQuebra
//_cSQL += " AND ROWNUM < 201 "+cQuebra
//_cSQL += " ORDER BY B6_FILIAL,B6_CLIFOR,B6_LOJA,B6_LOCAL "+cQuebra
_cSQL += " ORDER BY B6_DOC DESC"+cQuebra

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbCloseArea())
EndIf

DbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias1, .F., .T.)

Conout(_cSQL)

Conout(TIME() + " - GENA042 - 1")

If !(_cAlias1)->(EOF())
	
	Conout(TIME() + " - GENA042 - 2")
	
	SA2->(DbSetOrder(1))
	If SA2->(DbSeek(xFilial("SA2")+_cCodFor+_cLojFor))
	
		Conout(TIME() + " - GENA042 - 3")
				
		cCFOP	:= Posicione("SF4",1,xFilial("SF4")+_cTesDev,"F4_CF")
						
		While !(_cAlias1)->(EOF())		
		
			Conout(TIME() + " - GENA042 - 4")
	
			_aCabPed := {}
			
			aAdd ( _aCabPed , { "C5_TIPO"    	, _cTipo		, NIL} )
			aAdd ( _aCabPed , { "C5_CLIENTE" 	, SA2->A2_COD	, NIL} )
			aAdd ( _aCabPed , { "C5_LOJACLI" 	, SA2->A2_LOJA	, NIL} )
			aAdd ( _aCabPed , { "C5_CLIENT"  	, SA2->A2_COD	, NIL} )
			aAdd ( _aCabPed , { "C5_LOJAENT" 	, SA2->A2_LOJA	, NIL} )
			aAdd ( _aCabPed , { "C5_TIPOCLI" 	, "F"/*SA2->A2_TIPO*/	, NIL} )
			aAdd ( _aCabPed , { "C5_VEND1" 		, ''			, NIL} )
			aAdd ( _aCabPed , { "C5_CONDPAG" 	, _cMvCdDe		, NIL} )
			aAdd ( _aCabPed , { "C5_EMISSAO" 	, dDataBase		, NIL} )
			aAdd ( _aCabPed , { "C5_TPFRETE"	, "S"			, NIL} )
			aAdd ( _aCabPed , { "C5_MOEDA" 		, 1				, Nil} )
			aAdd ( _aCabPed , { "C5_TPLIB" 		, "2"			, Nil} )			
						
			_nCnt	:= 0
			_aItens := {}
			
			While !(_cAlias1)->(EOF()) .and. _nCnt < 90
			
				Conout(TIME() + " - GENA042 - 5")

				//nSaldoSB2	:= Posicione("SB2",1,xFilial("SB2")+(_cAlias1)->B6_PRODUTO+(_cAlias1)->B6_LOCAL,"B2_QATU")
				//aSaldos		:= CalcEst((_cAlias1)->B6_PRODUTO, (_cAlias1)->B6_LOCAL, DDataBase)				
				//If (_cAlias1)->B6_SALDO > aSaldos[1]
				//	nQtdDev := aSaldos[1]
				//Else 
				//	nQtdDev := (_cAlias1)->B6_SALDO
				//endIF
				//nQtdDev	:= (_cAlias1)->D1_QUANT
				nQtdDev := (_cAlias1)->B6_SALDO
				nPedDes	:= (_cAlias1)->D1_VALDESC/(_cAlias1)->D1_TOTAL
				nPrunit	:= (_cAlias1)->B6_PRUNIT-((_cAlias1)->B6_PRUNIT*nPedDes)
				nValTot	:= nPrunit*nQtdDev//(_cAlias1)->B6_SALDO
				nValDes	:= ((_cAlias1)->B6_PRUNIT*nQtdDev)-nValTot
				
				_nCnt++

				_aLinha:={}
								
				aAdd ( _alinha , { "C6_ITEM"    , STRZERO(_nCnt,TAMSX3("D2_ITEM")[1])			, NIL} )
				aAdd ( _alinha , { "C6_PRODUTO" , (_cAlias1)->B6_PRODUTO						, NIL} )
				aAdd ( _alinha , { "C6_DESCRI"  , (_cAlias1)->B1_DESC 							, NIL} )
				aAdd ( _alinha , { "C6_TES"    	, _cTesDev      	  							, NIL} )				
				aAdd ( _alinha , { "C6_QTDVEN"  , nQtdDev										, NIL} )

				aAdd ( _alinha , { "C6_PRUNIT" 	, (_cAlias1)->B6_PRUNIT					   		, NIL} )
				aAdd ( _alinha , { "C6_PRCVEN" 	, nPrunit		   			   					, NIL} )
				aAdd ( _alinha , { "C6_VALOR"  	, nValTot 			   							, NIL} )
				aAdd ( _alinha , { "C6_QTDLIB"	, nQtdDev						   				, NIL} )
												
				aAdd ( _alinha , { "C6_DESCONT"	, nPedDes*100				   	   				, NIL} )
				aAdd ( _alinha , { "C6_VALDESC"	, nValDes										, NIL} )
												
				aAdd ( _alinha , { "C6_CF"    	, cCFOP      	  			 		, NIL} )
				aAdd ( _alinha , { "C6_LOCAL"  	, (_cAlias1)->B6_LOCAL				, NIL} )
				aAdd ( _alinha , { "C6_ENTREG" 	, dDataBase							, NIL} )
				aAdd ( _alinha , { "C6_NFORI" 	, (_cAlias1)->B6_DOC				, NIL} )
				aAdd ( _alinha , { "C6_SERIORI"	, (_cAlias1)->B6_SERIE				, NIL} )
				aAdd ( _alinha , { "C6_ITEMORI"	, (_cAlias1)->D1_ITEM				, NIL} )
				aAdd ( _alinha , { "C6_IDENTB6"	, PADR(AllTrim((_cAlias1)->B6_IDENT),TAMSX3("C6_IDENTB6")[1])	, Nil})
																	
				aadd(_aItens,_aLinha)
				
				(_cAlias1)->(DbSkip())
			End
			
			Conout(TIME() + " - GENA042 - 6")
			
			If Len(_aItens) > 0
				
				Conout(TIME() + " - GENA042 - 7")
				
				DbSelectArea("SC5")
				DbSelectArea("SC6")
				DbSelectArea("SB1")
				                                                                       
				//Begin Transaction
				
			  		MSExecAuto({|x,y,z|MATA410(x,y,z)},_aCabPed, _aItens,3)
				                                      
				//End Transaction
				
				Conout(TIME() + " - GENA042 - 8")
				
				If lMsErroAuto					
					
					Conout(TIME() + " - GENA042 - 9")
					
					_lRet := .F.
										
					_aErro := GetAutoGRLog()                                                    
					_cErro	:= ""
					If Empty(_cErro)
						aEval(_aErro, {|x| _cErro+=x+Chr(13)+Chr(10)  } )	
					EndIF
					MsgStop(_cErro)	
					//xMagHelpFis("Falha ao gerar pedido",_cErro,"Corriga o problema")				
					//_cErro := MostraErro()
					
					Disarmtransaction()
					Return nil
				Else                   

					Conout(TIME() + " - GENA042 - 10")
					
					cNotaGer := GENA042B(_aCabPed,_aItens)				
					
					Conout(TIME() + " - GENA042 - 11")
					
					If !Empty(cNotaGer)
						cPedidos += "Pedido gerado:" + SC5->C5_NUM+", "+AllTrim(Str(Len(_aItens)))+" itens " + "Nota "+cNotaGer + CHR(13) + CHR(10)					
					EndIf	
				EndIf
			Else
				MsgAlert("Não foram encontrados itens.")
			Endif
		End 

		Conout(TIME() + " - GENA042 - 12")		
		
		If !Empty(cPedidos)			
			
			Conout(TIME() + " - GENA042 - 12")
			
			MemoWrite ( _cLogPd + "Emp" + cEmpAnt + " Fil"+ cFilAnt + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " LogFinal.txt" , cPedidos )
		Endif
	Else
		MsgStop("Cliente nao localizado.")
	Endif	
Else
	MsgAlert("Não foi encontrado saldo consignado para o cliente!")
Endif

Return 

Static Function GENA042B(_aCabPv,_aItmPv)

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
Local cEnt				:= Chr(13)+Chr(10)
Local _cLogPd			:= "C:\WINDOWS\TEMP\" //GetMv("GEN_FAT016") //Contém o caminho que será gravado o log de erro
Local _cMvSeri 			:= "0" //SERIE nota de saída

Local _cMvEsp			:= GetMv("MV_ESPECIE") //Contem tipos de documentos fiscais utilizados na emissao de notas fiscais
Local _aPosEsp 			:= {}
Local _nMvEsp 			:= 0
Local _lEspec			:= .F.

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

WFForceDir(_cLogPd)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponteramento nas tabelas para não ocorrer erro no execauto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SA1")
DbSelectArea("SA2")

DbSelectArea("SC5")
DbSetOrder(1)

Conout(TIME() + " - GENA042 - 13")

//lMsErroAuto := .F.
//MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,3)

//If !lMsErroAuto
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
	//³ Inicio Rotina para desbloquear crédito para que o pedido seja faturado sem problemas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
	
	DbSelectArea("SC9")
	DbSetOrder(1)
	If DbSeek(xFilial("SC9") + SC5->C5_NUM)
	
		Conout(TIME() + " - GENA042 - 14")
		
		bValid := {|| .T.}
		
		_cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_BLCRED,C9_BLEST,R_E_C_N_O_ SC9RECNO "
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
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliSC9,.T.,.T.)
		
		While ( (_cAliSC9)->(!Eof()) .And. (_cAliSC9)->C9_FILIAL == xFilial("SC9") .And. (_cAliSC9)->C9_PEDIDO == SC5->C5_NUM .And. Eval(bValid) )
		
			Conout(TIME() + " - GENA042 - 14")
			
			If !( ( Empty((_cAliSC9)->C9_BLCRED) .AND. Empty((_cAliSC9)->C9_BLEST) ) .OR. ((_cAliSC9)->C9_BLCRED=="10" .And. (_cAliSC9)->C9_BLEST=="10") .OR. (_cAliSC9)->C9_BLCRED=="09" )
			
				Conout(TIME() + " - GENA042 - 15")
				
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
				±±³Descri‡„o  ³Esta rotina realiza a atualizacao da liberacao de pedido de  ³±±
				±±³          ³venda com base na tabela SC9.                                ³±±
				ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
				/*/
				a450Grava(1,.T.,.T.,.F.)  //04/02 - RAFAEL LEITE - EFETUA TAMBEM A LIBERACAO DE ESTOQUE
			EndIf
			(_cAliSC9)->(DbSkip())
		EndDo
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
	//³ Fim    Rotina para desbloquear crédito para que o pedido seja faturado sem problemas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
	//'Inicio - Caso tenha ocorrido com sucesso a geração do Pedido de Vendas, irá iniciar a geração da Nota   '*
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ	DbSelectArea("SC9")

	Conout(TIME() + " - GENA042 - 16")
	
	DbSelectArea("SC9")
	DbSetOrder(1)
	If DbSeek(xFilial("SC9")+SC5->C5_NUM)
	
		Conout(TIME() + " - GENA042 - 17")
			
		_cPedExc := SC9->C9_PEDIDO
		
		//Controle das quantidades liberadas
		_nConfLib := 0
		_nConfVen := 0
		
		While SC9->(!EOF()) .And. SC9->C9_PEDIDO == SC5->C5_NUM
			
			Conout(TIME() + " - GENA042 - 18")
			
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
				
		*'---------------------------------------------------------'*
		*'Rotina utilizada para realizar a geração da Nota de Saída'*
		*'---------------------------------------------------------'*
		
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
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄtP¿
		//³Varrendo o vetor que contem as séries para saber se a série contida³
		//³no parametro esta correta.                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄtPÙ
		
		_lEspec := .F.
		For _ni := 1 To Len(_aPosEsp)
			If _aPosEsp[_ni][1] == _cMvSeri
				_lEspec := .T.
			EndIf
		Next
		
		//_cPedExc := SC9->C9_PEDIDO
		//If _lEspec
		
		Conout(TIME() + " - GENA042 - 19")
		
		If _lEspec .and. _nConfLib == _nConfVen // 04/02 RAFAEL LEITE - VERIFICA QUANTIDADE LIBERADA
			
			_cNotaImp := MaPVlNFs(_aPVlNFs,_cMvSeri,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)
			
		Elseif !_lEspec
			
			_cNotaImp := ""
			_cMsg := "A Nota não foi gerada, pois a serie não esta preenchida corretamente." + cEnt
			_cMsg += "Favor revisar o parametro GEN_FAT003." + cEnt
			conout(Time()+ " " + _cMsg)
			MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )
			
		Elseif !_nConfLib == _nConfVen //04/02 - RAFAEL LEITE
			
			_cNotaImp := ""
			_cMsg := "A quantidade liberada esta diferente da informada no pedido." + cEnt
			conout(Time()+ " " + _cMsg)
			MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )
		EndIf
		
		Conout(TIME() + " - GENA042 - 20")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso a nota não seja gerado irá chamar a rotina de erro³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(AllTrim(_cNotaImp))
			
			Conout(TIME() + " - GENA042 - 21")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Chamando o Execauto de Alteração e em seguida o de exclusão³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Alterando a quantidade liberada³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For _ni := 1 To Len(_aItmPv)
				_aItmPv[_ni][_nPosLb][2] := 0
			Next _ni
			
			lMsErroAuto := .F.
			MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,4)
			
			If !lMsErroAuto
				
				Conout(TIME() + " - GENA042 - 22")
				
				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,5)
				
				If !lMsErroAuto					
					_cErroLg += "  " + cEnt
					_cErroLg += " O Pedido: " + _cPedExc + " foi excluído com sucesso. "  + cEnt
					_cErroLg += " Favor verificar o pedido: "  + cEnt
					_cErroLg += " Pois ele teve que ser excluído uma vez que o Documento de Saída não foi gerado corretamente. " + cEnt
					_cErroLg += " Favor verificar a geração do Documento de Saída, pois no processo houve erro. " + cEnt
					_cErroLg += " " + cEnt
					MemoWrite ( _cLogPd + "Emp" +SM0->M0_CODIGO + " Fil"+ AllTrim(SM0->M0_CODFIL) + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
				Else
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
					MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
				EndIf
				
				Conout(TIME() + " - GENA042 - 23") 
				
			Else				
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
				MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
			EndIf
		EndIf
	EndIf
//Else
//	_aErro := GetAutoGRLog()
//	For _ni := 1 To Len(_aErro)
//		_cErroLg += _aErro[_ni] + cEnt
//	Next _ni                          
//	conout(_cErroLg)
//	MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil  + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraPedido.txt" , _cErroLg )
//	Disarmtransaction()
//EndIf

RestArea(_aArea)

Conout(TIME() + " - GENA042 - 24")

Return _cNotaImp             