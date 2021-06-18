#include 'protheus.ch'
#INCLUDE "Protheus.ch" 
#include "Fileio.ch"
#Include "Report.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA066   ºAutor  ³Cleuto Lima - Loop  º Data ³  30/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para gerar pedido de vendas de complemento de preço  º±±
±±º          ³por cliente com bsae no saldo consignado.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Gen                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA066()

Local _cPerg	:= "GENA066"
Local cMsgYesno	:= ""
Local cMsgProd	:= ""

PutSx1(_cPerg, "01", "Cliente:",	"Cliente:",		"Cliente:",		"mv_ch1", "C", TamSx3("A1_COD")[1], 0, 0, "G","", "SA1", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(_cPerg, "02", "Loja:",		"Loja:",		"Loja:",    	"mv_ch2", "C", TamSx3("A1_LOJA")[1], 0, 0, "G","", ""	, "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSx1(_cPerg ,"03", "Gera Simulação",	"Gera Simulação",	"Gera Simulação",	"mv_ch3", "N", 01, 0, 0, "C","", "", "", "", "MV_PAR03","Sim","Sim","Sim","","Não","Não","Não","","","","","","","","","",nil,nil,nil,	"")

If !Pergunte("GENA066",.T.)
	Return
EndIf

cMsgYesno	:= IIF( MV_PAR03 == 1 , "Confirma a simulação dos pedidos de complemento de preço?" , "Confirma a emissão dos pedidos de complemento de preço?" )
	
If !MsgYesNo(cMsgYesno)	
	Return
Endif
cMsgProd	:= IIF( MV_PAR03 == 1 , "Simulando pedidos..." , "Gerando pedidos..." ) 
//LJMsgRun("Gerando pedidos...","Aguarde...",{|| ProcPed() })
Processa({|| ProcPed() },cMsgProd)
	
Return nil

Static Function ProcPed() 
Local aLog		:= {}
Local aPedidos	:= {}
Local aEmitidos	:= {}
Local _cSQL		:= ""
Local _cCodCli
Local _cLojCli
Local _cTipo	:= "C"
Local _cAlias1 	:= GetNextAlias()
Local _cMvCdDe 	:= GetMv("GEN_FAT092") // Contém a condição de pagamento 
Local _cTesComp	:= GetMV("GEN_FAT091") // TES para complemento de preço de consignação
Local _cTabprc	:= GetMV("GEN_FAT064")
Local _dEmissao	:= GetMv("GEN_COM004") //Emissao maxima
Local _cMsgFim	:= ""
Local cQuebra	:= Chr(13)+Chr(10)
Local cPedidos	:= ""
Local cCFOP		:= Posicione("SF4",1,xFilial("SF4")+_cTesComp,"F4_CF") 
Local nTotPed	:= 0
Local cInTes	:= FormatIn(_cTesComp,";") 
Local lPrevia	:= .T.
Local aEmitAux	:= {}
Local cDocSerie	:= "" 
Local lTemDoc	:= .F.
                        
Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

If Empty(cCFOP)
	MsgStop("TES não localizada ou CFOP não preenchida!"+Chr(13)+Chr(10)+"Codigo: "+_cTesComp)
	Return .F.
EndIf
		
_cCodCli	:= MV_PAR01
_cLojCli	:= MV_PAR02
_cTipo		:= "C"
lPrevia		:= MV_PAR03 == 1

_cSQL := " SELECT B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO,B1_DESC,B1_XSITOBR,B1_ISBN, B6_DOC, B6_SALDO,B6_TES, "+cQuebra
_cSQL += " B6_SERIE, D2_ITEM, B6_IDENT, B6_PRUNIT, B6_LOCAL, NVL(DA1_PRCVEN,0) DA1_PRCVEN,(B6_PRUNIT/D2_PRUNIT) PERDES,D2_EMISSAO "+cQuebra


/*Substituida pela função CalcTerc*/
/*
_cSQL += "  , ( SELECT SUM(SD2B.D2_PRUNIT-NVL(D1_VUNIT,0)) FROM "+RetSqlName("SD2")+" SD2B "+cQuebra
_cSQL += "      JOIN "+RetSqlName("SB6")+" SB6B "+cQuebra
_cSQL += "      ON SD2B.D2_FILIAL = SB6B.B6_FILIAL  "+cQuebra
_cSQL += "      AND SB6B.B6_DOC = SD2B.D2_DOC "+cQuebra
_cSQL += "      AND SB6B.B6_SERIE = SD2B.D2_SERIE "+cQuebra
_cSQL += "      AND SB6B.B6_PRODUTO = SD2B.D2_COD "+cQuebra
_cSQL += "      AND SB6B.B6_CLIFOR = SD2B.D2_CLIENTE "+cQuebra
_cSQL += "      AND SB6B.B6_LOJA = SD2B.D2_LOJA "+cQuebra
_cSQL += "      AND SD2B.D_E_L_E_T_ = ' ' "+cQuebra
_cSQL += "      LEFT JOIN "+RetSqlName("SD1")+" SD1 "+cQuebra
_cSQL += "      ON SD1.D1_FILIAL = D2_FILIAL "+cQuebra
_cSQL += "      AND SD1.D1_NFORI = SD2B.D2_NFORI "+cQuebra
_cSQL += "      AND SD1.D1_SERIORI = SD2B.D2_SERIORI "+cQuebra
_cSQL += "      AND SD1.D1_FORNECE = SD2B.D2_CLIENTE "+cQuebra
_cSQL += "      AND SD1.D1_LOJA = SD2B.D2_LOJA "+cQuebra 
_cSQL += "      AND SD1.D1_LOJA = SD2B.D2_ITEMORI "+cQuebra 
_cSQL += "      AND SD1.D_E_L_E_T_ <> '*' "+cQuebra
_cSQL += "      WHERE SD2B.D2_FILIAL = SD2.D2_FILIAL AND SD2B.D2_NFORI = SD2.D2_DOC AND SD2B.D2_COD = SD2.D2_COD AND SD2B.D2_SERIORI = SD2.D2_SERIE AND SD2B.D2_ITEMORI = SD2.D2_ITEM AND SD2B.D2_CLIENTE = SD2.D2_CLIENTE AND SD2B.D2_LOJA = SD2.D2_LOJA AND SD2B.D_E_L_E_T_ <> '*' AND D2_TIPO = 'C' AND SB6B.B6_IDENT  = SD2B.D2_IDENTB6) COMPLEM "+cQuebra
*/

_cSQL += " ,NVL(( SELECT SUM(SD2C.D2_TOTAL/C6_XQTDPD3) FROM " + RetSqlName("SD2") + " SD2C "+cQuebra
_cSQL += " JOIN " + RetSqlName("SC6") + " SC6C "+cQuebra
_cSQL += " ON SC6C.C6_FILIAL = SD2C.D2_FILIAL "+cQuebra
_cSQL += " AND SC6C.C6_NUM = SD2C.D2_PEDIDO "+cQuebra
_cSQL += " AND SC6C.C6_ITEM = SD2C.D2_ITEMPV "+cQuebra
_cSQL += " AND SC6C.C6_PRODUTO = SD2C.D2_COD "+cQuebra
_cSQL += " WHERE SD2C.D2_FILIAL = SB6.B6_FILIAL "+cQuebra
_cSQL += " AND SD2C.D2_NFORI = SB6.B6_DOC "+cQuebra
_cSQL += " AND SD2C.D2_SERIORI = SB6.B6_SERIE "+cQuebra
_cSQL += " AND SD2C.D2_COD = SB6.B6_PRODUTO "+cQuebra
_cSQL += " AND SD2C.D2_TES IN "+cInTes+cQuebra
_cSQL += " AND SD2C.D_E_L_E_T_ <> '*' ),0) VAL_COMPLE "+cQuebra
     
_cSQL += " FROM " + RetSqlName("SB6") + " SB6 "+cQuebra

_cSQL += "  JOIN  " + RetSqlName("SA1") + "  SA1 "+cQuebra
_cSQL += "  ON A1_COD = B6_CLIFOR "+cQuebra
_cSQL += "  AND A1_LOJA = B6_LOJA "+cQuebra
_cSQL += "  AND SA1.A1_MSBLQL <> '1' "+cQuebra
_cSQL += "  AND SA1.D_E_L_E_T_ <> '*' "+cQuebra
 
_cSQL += " JOIN "+RetSqlName("SD2")+ " SD2 "+cQuebra
_cSQL += " ON SD2.D2_FILIAL = B6_FILIAL "+cQuebra
_cSQL += " AND SB6.B6_DOC = SD2.D2_DOC"+cQuebra
_cSQL += " AND SB6.B6_SERIE = SD2.D2_SERIE"+cQuebra
_cSQL += " AND SB6.B6_PRODUTO = SD2.D2_COD"+cQuebra
_cSQL += " AND SB6.B6_CLIFOR = SD2.D2_CLIENTE"+cQuebra
_cSQL += " AND SB6.B6_LOJA = SD2.D2_LOJA"+cQuebra
_cSQL += " AND SD2.D_E_L_E_T_ = ' '"+cQuebra

_cSQL += " JOIN "+RetSqlName("SB1") + " SB1 "+cQuebra
_cSQL += " ON SB1.B1_FILIAL = '" + xFilial("SB1") + "'"+cQuebra
_cSQL += " AND SB6.B6_PRODUTO = SB1.B1_COD"+cQuebra
_cSQL += " AND SB1.B1_MSBLQL = '2' "+cQuebra
_cSQL += " AND SB1.D_E_L_E_T_ = ' '"+cQuebra

_cSQL += " LEFT JOIN "+RetSqlName("DA1") + " DA1 "+cQuebra
_cSQL += " ON DA1.DA1_FILIAL = '" + xFilial("DA1") + "'"+cQuebra
_cSQL += " AND SB6.B6_PRODUTO = DA1.DA1_CODPRO"+cQuebra
_cSQL += " AND DA1.DA1_CODTAB = '"+_cTabprc+"'"+cQuebra
_cSQL += " AND DA1.D_E_L_E_T_ = ' '"+cQuebra
 
_cSQL += " WHERE SB6.B6_FILIAL = '" + xFilial("SB6") + "'"+cQuebra
_cSQL += " AND SB6.B6_CLIFOR = '" + _cCodCli + "'"+cQuebra
_cSQL += " AND SB6.B6_LOJA = '" + _cLojCli + "'"+cQuebra
//_cSQL += " AND SB6.B6_EMISSAO <= '" + DtoS(_dEmissao) + "'"+cQuebra
//_cSQL += " AND SB6.B6_DOC = '000274911'"+cQuebra // APENAS PARA LIMITAR O TESTE DEVE SER REMOVIDO

_cSQL += " AND SB6.B6_TIPO = 'E'"+cQuebra
_cSQL += " AND SB6.B6_TPCF = 'C'"+cQuebra
_cSQL += " AND SB6.B6_PODER3 = 'R'"+cQuebra      

//_cSQL += " AND SB6.B6_PRODUTO = '03810760'"+cQuebra      

_cSQL += " AND SB6.B6_SALDO > 0"+cQuebra         
_cSQL += " AND SB6.D_E_L_E_T_ = ' '"+cQuebra
_cSQL += " ORDER BY B6_FILIAL,B6_EMISSAO, B6_CLIFOR, B6_LOJA, B6_DOC, B6_SERIE,B6_IDENT "+cQuebra

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias1, .F., .T.)

nCountAux	:= 0
nTotReg 	:= Contar(_cAlias1, "!EOF()")
ProcRegua(nTotReg)

(_cAlias1)->(Dbgotop())
If !(_cAlias1)->(EOF())
		
	SA1->(DbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+_cCodCli+_cLojCli))
		
		cVend	:= Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND,"A3_COD")
		cVend	:= IIF( Empty(cVend) , "000005" , cVend )
		
		DA1->(DbSetOrder(1))
		
		While !(_cAlias1)->(EOF())		
	
			//carrega array com os dados do cabeçalho da Pré-Nota de Entrada
			_aCabPed := {}
			
			aAdd ( _aCabPed , { "C5_TIPO"    	, _cTipo       					   			, NIL} )
			aAdd ( _aCabPed , { "C5_CLIENTE" 	, SA1->A1_COD 							   	, NIL} )
			aAdd ( _aCabPed , { "C5_LOJACLI" 	, SA1->A1_LOJA 								, NIL} )
			aAdd ( _aCabPed , { "C5_CLIENT"  	, SA1->A1_COD 								, NIL} )
			aAdd ( _aCabPed , { "C5_LOJAENT" 	, SA1->A1_LOJA 								, NIL} )
			aAdd ( _aCabPed , { "C5_TIPOCLI" 	, SA1->A1_TIPO						 		, NIL} )
			aAdd ( _aCabPed , { "C5_VEND1" 		, cVend		 								, NIL} )
			aAdd ( _aCabPed , { "C5_CONDPAG" 	, _cMvCdDe				  					, NIL} )
			aAdd ( _aCabPed , { "C5_EMISSAO" 	, dDataBase									, NIL} )
			aAdd ( _aCabPed , { "C5_TPFRETE"	, "S"					 					, NIL} )
			
			_nCnt		:= 0
			_aItens 	:= {}
			aEmitAux	:= {}
			cDocSerie	:= (_cAlias1)->B6_DOC+(_cAlias1)->B6_SERIE
			
			While !(_cAlias1)->(EOF()) .and. _nCnt < 90 .and. cDocSerie == (_cAlias1)->B6_DOC+(_cAlias1)->B6_SERIE

				nCountAux++
				IncProc(StrZero(nCountAux,6)+" de "+StrZero(nTotReg,6))
			
				/*/
				ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
				±±³Fun‡…o  	 ³ CalcTerc ³                                                 ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
				±±³Descri‡…o	 ³ Retorna um Array onde:                                     ³±±
				±±³          ³ aSaldo[1] := Saldo de Poder Terceiro                       ³±±
				±±³          ³ aSaldo[2] := Quantidade Poder Terceiro Liberada(ainda nao  ³±±
				±±³          ³                               faturada)                    ³±±
				±±³          ³ aSaldo[3] := Saldo total do poder de terceiro ( Valor)     ³±±
				±±³          ³ aSaldo[4] := Soma do total de devolucoes do Poder Terceiros³±±          
				±±³          ³ aSaldo[5] := Valor Total em Poder Terceiros				  ³±±
				±±³          ³ aSaldo[6] := Quantidade Total em Poder Terceiros			  ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
				±±³Sintaxe   ³ ExpA1(ExpC1,ExpC2,ExpC3,ExpC4,ExpC5,ExpC6)                 ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
				±±³Parametros³ ExpC1 = Codigo do Produto                                  ³±±
				±±³          ³ ExpC2 = Codigo do Cliente/Fornecedor                       ³±±
				±±³          ³ ExpC3 = Codigo da Loja                                     ³±±
				±±³          ³ ExpC4 = Codigo do identIficador do SB6                     ³±±
				±±³          ³ ExpC5 = Codigo da Tes                                      ³±±
				±±³          ³ ExpC6 = Tipo da Nota                                       ³±±
				±±³			 ³ ExpD1 = Dt Inicial a ser Considerada na Composi‡Æo do Saldo ³±±
				±±³			 ³ ExpD2 = Dt Final a ser Considedara na Composi‡Æo do Saldo	  ³±±
				±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
				/*/
				
				aSldSB6	:= CalcTerc((_cAlias1)->B6_PRODUTO,SA1->A1_COD,SA1->A1_LOJA,(_cAlias1)->B6_IDENT,(_cAlias1)->B6_TES/*Posicione("SF4",1,xFilial("SF4")+_cTesComp,"F4_TESDV")*/,/*"B"*/,StoD((_cAlias1)->D2_EMISSAO),DDataBase)
				
				nSaldo		:= 0
				nValComDes	:= A410Arred(((_cAlias1)->DA1_PRCVEN*(_cAlias1)->PERDES) * (_cAlias1)->B6_SALDO,"D2_PRCVEN")
				
				//If (aSldSB6[5]-aSldSB6[4]) <> nValComDes
				If A410Arred(((_cAlias1)->B6_PRUNIT+(_cAlias1)->VAL_COMPLE) * (_cAlias1)->B6_SALDO,"D2_PRCVEN") <> nValComDes
				
					nSaldo		:= A410Arred(((_cAlias1)->B6_PRUNIT+(_cAlias1)->VAL_COMPLE) * (_cAlias1)->B6_SALDO,"D2_PRCVEN")//aSldSB6[5]-aSldSB6[4]//( IIF( aSldSB6[5]-aSldSB6[4] > aSldSB6[3], aSldSB6[5]-aSldSB6[4] , aSldSB6[3] ) )
					nPrcComp	:= nValComDes-nSaldo//aSldSB6[3] //nValComDes-( ((_cAlias1)->B6_PRUNIT*(_cAlias1)->B6_SALDO)+(_cAlias1)->COMPLEM)					
				Else
					nSaldo		:= nValComDes
			  		nPrcComp	:= 0
				EndIf

				If (_cAlias1)->DA1_PRCVEN == 0

					Aadd(aLog,{SA1->A1_COD, SA1->A1_LOJA , SA1->A1_NOME, (_cAlias1)->B6_DOC, (_cAlias1)->D2_ITEM, (_cAlias1)->B6_PRODUTO,;
							(_cAlias1)->B6_SALDO,;
							Round(((_cAlias1)->DA1_PRCVEN*(_cAlias1)->PERDES),2),;
							(1-(_cAlias1)->PERDES )*100 ,;
							nSaldo,;
							nPrcComp/(_cAlias1)->B6_SALDO,;
							nPrcComp,;
							_cTabprc,;
							"Não localizado na tabela de preço ",;
							(_cAlias1)->DA1_PRCVEN,; 
							aSldSB6[4],;
							aSldSB6[5],;
							(_cAlias1)->B1_ISBN;
							};
							 )	
							 					
					(_cAlias1)->(DbSkip())
					Loop
				EndIf
								
				If nPrcComp == 0

					Aadd(aLog,{SA1->A1_COD, SA1->A1_LOJA , SA1->A1_NOME, (_cAlias1)->B6_DOC, (_cAlias1)->D2_ITEM, (_cAlias1)->B6_PRODUTO,;
							(_cAlias1)->B6_SALDO,;
							Round(((_cAlias1)->DA1_PRCVEN*(_cAlias1)->PERDES),2),;
							(1-(_cAlias1)->PERDES )*100 ,;
							nSaldo,;
							nPrcComp/(_cAlias1)->B6_SALDO,;
							nPrcComp,;
							_cTabprc,;
							"Não houve alteração de preço para tabela ",;
							(_cAlias1)->DA1_PRCVEN,; 
							aSldSB6[4],;
							aSldSB6[5],;
							(_cAlias1)->B1_ISBN;
							};
							 )	
							 					
					(_cAlias1)->(DbSkip())
					Loop
				ElseIf nPrcComp < 0

					Aadd(aLog,{SA1->A1_COD, SA1->A1_LOJA , SA1->A1_NOME, (_cAlias1)->B6_DOC, (_cAlias1)->D2_ITEM, (_cAlias1)->B6_PRODUTO,;
							(_cAlias1)->B6_SALDO,;
							Round(((_cAlias1)->DA1_PRCVEN*(_cAlias1)->PERDES),2),;
							(1-(_cAlias1)->PERDES )*100 ,;
							nSaldo,;
							nPrcComp/(_cAlias1)->B6_SALDO,;
							nPrcComp,;
							_cTabprc,;
							"Preço a menor para tabela ",;
							(_cAlias1)->DA1_PRCVEN,; 
							aSldSB6[4],;
							aSldSB6[5],; 
							(_cAlias1)->B1_ISBN;
							};
							 )
							 					
					(_cAlias1)->(DbSkip())
					Loop 
				ElseIf nSaldo < 0
				
					Aadd(aLog,{SA1->A1_COD, SA1->A1_LOJA , SA1->A1_NOME, (_cAlias1)->B6_DOC, (_cAlias1)->D2_ITEM, (_cAlias1)->B6_PRODUTO,;
							(_cAlias1)->B6_SALDO,;
							Round(((_cAlias1)->DA1_PRCVEN*(_cAlias1)->PERDES),2),;
							(1-(_cAlias1)->PERDES )*100 ,;
							nSaldo,;
							nPrcComp/(_cAlias1)->B6_SALDO,;
							nPrcComp,;
							_cTabprc,;
							"Não foi posssível compor o valor do saldo em poder de terceriros pois o valor das entradas é maior que o valor das saidas!",;
							(_cAlias1)->DA1_PRCVEN,; 
							aSldSB6[4],;
							aSldSB6[5],;
							(_cAlias1)->B1_ISBN;
							};
							 )
							 					
					(_cAlias1)->(DbSkip())
					Loop 											
				Else     
					//aEmitidos
					Aadd(aEmitAux,{SA1->A1_COD /*1*/, SA1->A1_LOJA /*2*/, SA1->A1_NOME/*3*/, (_cAlias1)->B6_DOC/*4*/, (_cAlias1)->D2_ITEM/*5*/, (_cAlias1)->B6_PRODUTO/*6*/,;
							(_cAlias1)->B6_SALDO/*7*/,;
							Round(((_cAlias1)->DA1_PRCVEN*(_cAlias1)->PERDES),2)/*8*/,;
							(1-(_cAlias1)->PERDES )*100 /*9*/,;
							nSaldo/*10*/,;
							nPrcComp/(_cAlias1)->B6_SALDO/*11*/,;//unitario por total de complemento
							nPrcComp/*12*/,;
							_cTabprc/*13*/,;
							(_cAlias1)->DA1_PRCVEN,/*14*/; 
							(_cAlias1)->B1_ISBN/*15*/;
							};
							 )	
				EndIf
                
				_nCnt++

				_aLinha:={}
								
				aAdd ( _alinha , { "C6_ITEM"    , STRZERO(_nCnt,TAMSX3("D2_ITEM")[1])			, NIL} )
				aAdd ( _alinha , { "C6_PRODUTO" , (_cAlias1)->B6_PRODUTO						, NIL} )
				aAdd ( _alinha , { "C6_DESCRI"  , (_cAlias1)->B1_DESC 							, NIL} )
				aAdd ( _alinha , { "C6_TES"    	, _cTesComp      	  							, NIL} )				
				aAdd ( _alinha , { "C6_QTDVEN"  , 0/*(_cAlias1)->B6_SALDO */  					, NIL} )
								
				aAdd ( _alinha , { "C6_PRUNIT" 	, nPrcComp		   					, NIL} )				
				aAdd ( _alinha , { "C6_PRCVEN" 	, nPrcComp		   					, NIL} )
				aAdd ( _alinha , { "C6_VALOR"  	, nPrcComp							, NIL} )
								
				aAdd ( _alinha , { "C6_DESCONT"	, 0							   		, NIL} )
				aAdd ( _alinha , { "C6_VALDESC"	, 0							  		, NIL} )
												
//				aAdd ( _alinha , { "C6_CF"    	, cCFOP      	  			 		, NIL} )
				aAdd ( _alinha , { "C6_LOCAL"  	, (_cAlias1)->B6_LOCAL				, NIL} )
				aAdd ( _alinha , { "C6_ENTREG" 	, dDataBase							, NIL} )
				aAdd ( _alinha , { "C6_NFORI" 	, (_cAlias1)->B6_DOC				, NIL} )
				aAdd ( _alinha , { "C6_SERIORI"	, (_cAlias1)->B6_SERIE				, NIL} )
				aAdd ( _alinha , { "C6_ITEMORI"	, (_cAlias1)->D2_ITEM				, NIL} )
				aAdd ( _alinha , { "C6_IDENTB6"	, PADR(AllTrim((_cAlias1)->B6_IDENT),TAMSX3("C6_IDENTB6")[1])	, Nil})
				aAdd ( _alinha , { "C6_XQTDPD3" , (_cAlias1)->B6_SALDO			, NIL} )
																					
				aadd(_aItens,_aLinha)
				
				nTotPed += nPrcComp
				
				(_cAlias1)->(DbSkip())
			EndDo
			
			If Len(_aItens) > 0
				lTemDoc	:= .T.
				If !lPrevia				
					DbSelectArea("SC5")                                                                             
					DbSelectArea("SC6")
					DbSelectArea("SB1")
					
					Begin Transaction
					
				  		MSExecAuto({|x,y,z|MATA410(x,y,z)},_aCabPed, _aItens,3)
					
					End Transaction
					
					If lMsErroAuto					
						_lRet := .F.
						
						_cErroLg	:= ""
						_aErro 		:= GetAutoGRLog()
						For _ni := 1 To Len(_aErro)
							_cErroLg += _aErro[_ni]+Chr(13)+Chr(10)
						Next _ni
											
						xMagHelpFis("Inclusão de pedido",_cErroLg,"verifique os dadas informados!")
						
						Disarmtransaction() 
						nTotPed := 0
                        
						aEval(aEmitAux, {|x| Aadd(aLog, {;
						x[01],;
						x[02],;
						x[03],;
						x[04],;
						x[05],;
						x[06],;
						x[07],;
						x[08],;
						x[09],;
						x[10],;
						x[11],;
						x[12],;
						x[13],;
						"Falha ao gerar o pedido de vendas",;
						x[14],;
						0,;
						0,; 
						x[15];
						} ) } )
																		 						
					Else
						aEval(aEmitAux, {|x| Aadd( aEmitidos , aClone(x) ) } )
						Aadd(aPedidos,{SA1->A1_COD, SA1->A1_LOJA , SA1->A1_NOME,SC5->C5_NUM+", "+AllTrim(Str(Len(_aItens)))+" itens ",nTotPed,cDocSerie } )
						nTotPed := 0
					EndIf
				Else	
					aEval(aEmitAux, {|x| Aadd( aEmitidos , aClone(x) ) } )
					Aadd(aPedidos,{SA1->A1_COD, SA1->A1_LOJA , SA1->A1_NOME,"Simulação, "+AllTrim(Str(Len(_aItens)))+" itens ",nTotPed,cDocSerie} )
					nTotPed := 0					
				EndIf
				
			Endif
			 
		EndDo
		
		If !lTemDoc
			MsgStop("Não foram encontrados itens!")
		EndIf
		
		GENA066B(aLog,aPedidos,aEmitidos)
		
		/*
		If !Empty(_cMsgFim+cPedidos)
			cPedidos	:= IIF( !Empty(_cMsgFim) , cPedidos+"Verifique os erros apontados acima." , cPedidos )
			_cMsgFim	:= IIF( Empty(_cMsgFim) , "Processo finalizado!" , _cMsgFim )
			xMagHelpFis("Inclusão de pedido",_cMsgFim,cPedidos)
		Endif
		*/
	Else
		MsgStop("Cliente nao localizado.")
	Endif	
Else
	MsgAlert("Não foi encontrado saldo consignado para o cliente!")
Endif

Return     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA066   ºAutor  ³Microsiga           º Data ³  04/05/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GENA066B(aLog,aPedidos,aEmitidos)

Local oReport

oReport := ReportDef(aLog,aPedidos,aEmitidos)
oReport:printDialog()

Return

Static Function ReportDef(aLog,aPedidos,aEmitidos)

local oReport
local cTitulo := "Log de processamento"
local cPerg := ""

oReport := TReport():New('GENA066B', cTitulo, cPerg , {|oReport| PrintReport(oReport,aLog,aPedidos,aEmitidos)})
oReport:SetLandScape()
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()

oSection0 := TRSection():New(oReport,"Mensagens",{""}) 
oSection1 := TRSection():New(oReport,"Pedidos",{""}) 
oSection2 := TRSection():New(oReport,"Conferencia",{""}) 

TRCell():New(oSection0,"Cod"	,,"Codigo",,020)
TRCell():New(oSection0,"Loj"	,,"Loja" ,,010)
TRCell():New(oSection0,"Nome"	,,"Nome",,050)
TRCell():New(oSection0,"Doc"	,,"Documento",,025)
TRCell():New(oSection0,"Item"	,,"Item",,010)
TRCell():New(oSection0,"Prod"	,,"Produto",,035)
TRCell():New(oSection0,"Isbn"	,,"ISBN",,035)

TRCell():New(oSection0,"Saldo"	,,"Saldo",,035)       
TRCell():New(oSection0,"UnitBruTab"	,,"Unit.Tabela",,025)
TRCell():New(oSection0,"Per"	,,"Per.Desconto",,010)
TRCell():New(oSection0,"UnitTab"	,,"Unit.Liq.Tabela",,025)
TRCell():New(oSection0,"PrcTab"	,,"Total.Tabela",,025)
TRCell():New(oSection0,"Unit3",,"Unit.Pord3.",,025)
TRCell():New(oSection0,"Prc"	,,"Total.Pord3.",,025)
TRCell():New(oSection0,"UnitVal" ,,"Unit.Complemento",,025)
TRCell():New(oSection0,"Val"  	,,"Total.Complemento",,025)
//TRCell():New(oSection0,"Tot"  	,,"Total Compl.",,025)
TRCell():New(oSection0,"Tab"  	,,"Tabela",,025)

TRCell():New(oSection0,"Sai"  	,,"Val.Tot.Poder3",,025)
TRCell():New(oSection0,"Ent"  	,,"Val.Dev.Poder3",,025)

TRCell():New(oSection0,"Msg"  	,,"Mensagem",,150)

TRCell():New(oSection1,"Cod"	,,"Codigo",,020)
TRCell():New(oSection1,"Loj"	,,"Loja",,010)
TRCell():New(oSection1,"Nome"	,,"Nome",,100)
TRCell():New(oSection1,"Doc"	,,"Doc./Serie",,020)
TRCell():New(oSection1,"Pedido"	,,"Pedido",,020)
TRCell():New(oSection1,"Total"	,,"Total",,020)

TRCell():New(oSection2,"Cod"	,,"Codigo",,020)
TRCell():New(oSection2,"Loj"	,,"Loja" ,,010)
TRCell():New(oSection2,"Nome"	,,"Nome",,050)
TRCell():New(oSection2,"Doc"	,,"Documento",,025)
TRCell():New(oSection2,"Item"	,,"Item",,010)
TRCell():New(oSection2,"Prod"	,,"Produto",,035)
TRCell():New(oSection2,"Isbn"	,,"ISBN",,035)
TRCell():New(oSection2,"Saldo"	,,"Saldo",,035)
TRCell():New(oSection2,"UnitBruTab"	,,"Unit.Tabela",,025)
TRCell():New(oSection2,"Per"	,,"Per.Desconto",,010)
TRCell():New(oSection2,"UnitTab"	,,"Unit.Liq.Tabela",,025)
TRCell():New(oSection2,"PrcTab"	,,"Total.Tabela",,025)
TRCell():New(oSection2,"Unit3",,"Unit.Pord3.",,025)
TRCell():New(oSection2,"Prc"	,,"Total.Pord3.",,025)
TRCell():New(oSection2,"UnitVal" ,,"Unit.Complemento",,025)
TRCell():New(oSection2,"Val"  	,,"Total.Complemento",,025)
//TRCell():New(oSection2,"Tot"  	,,"Total Compl.",,025)
TRCell():New(oSection2,"Tab"  	,,"Tabela",,025)

Return (oReport)

Static Function PrintReport(oReport,aLog,aPedidos,aEmitidos)

Local oSection0 := oReport:Section(1)
Local oSection1 := oReport:Section(2)
Local oSection2 := oReport:Section(3)

oReport:SkipLine()

oReport:IncMeter()
oSection0:Init()
oReport:SkipLine()
oReport:PrintText("Inconsistências") 
			
For nx := 1 To Len(aLog)
	
	oSection0:Cell("Codigo"):SetValue(aLog[nx][1])
	oSection0:Cell("Loj"):SetValue(aLog[nx][2])
	oSection0:Cell("Nome"):SetValue(aLog[nx][3])
	oSection0:Cell("Doc"):SetValue(aLog[nx][4])
	oSection0:Cell("Item"):SetValue(aLog[nx][5])
	oSection0:Cell("Prod"):SetValue(aLog[nx][6])
	oSection0:Cell("Isbn"):SetValue(aLog[nx][18])
	oSection0:Cell("Saldo"):SetValue(aLog[nx][7])
	oSection0:Cell("Per"):SetValue(aLog[nx][9])		
	oSection0:Cell("UnitBruTab"):SetValue(aLog[nx][15])		
	oSection0:Cell("UnitTab"):SetValue(aLog[nx][8])
	oSection0:Cell("PrcTab"):SetValue(aLog[nx][8]*aLog[nx][7])						
	oSection0:Cell("Unit3"):SetValue(aLog[nx][10]/aLog[nx][7])		
	oSection0:Cell("Prc"):SetValue(aLog[nx][10])
	oSection0:Cell("UnitVal"):SetValue(aLog[nx][11])		
	oSection0:Cell("Val"):SetValue(aLog[nx][12])		
	oSection0:Cell("Tab"):SetValue(aLog[nx][13])

	oSection0:Cell("Sai"):SetValue(aLog[nx][17])
	oSection0:Cell("Ent"):SetValue(aLog[nx][16])
			
	oSection0:Cell("msg"):SetValue(aLog[nx][14])
		
	oSection0:PrintLine()
Next nx

oReport:SkipLine()

oReport:IncMeter()
oSection1:Init()	
oReport:SkipLine()
oReport:PrintText("Pedidos Gerados")

For nx := 1 To Len(aPedidos)
	oSection1:Cell("Cod"):SetValue(aPedidos[nx][1])
	oSection1:Cell("Loj"):SetValue(aPedidos[nx][2])
	oSection1:Cell("Nome"):SetValue(aPedidos[nx][3])
	oSection1:Cell("Pedido"):SetValue(aPedidos[nx][4])
	oSection1:Cell("Total"):SetValue(aPedidos[nx][5])
	oSection1:Cell("Doc"):SetValue(Left(aPedidos[nx][6],9)+"/"+SubStr(aPedidos[nx][6],10,3))

	oSection1:PrintLine()
Next nx

oReport:SkipLine()

oReport:IncMeter()
oSection2:Init()	
oReport:SkipLine()
oReport:PrintText("Composição dos Pedidos")

If Len(aPedidos) > 0
	For nx := 1 To Len(aEmitidos)
		oSection2:Cell("Codigo"):SetValue(aEmitidos[nx][1])
		oSection2:Cell("Loj"):SetValue(aEmitidos[nx][2])
		oSection2:Cell("Nome"):SetValue(aEmitidos[nx][3])
		oSection2:Cell("Doc"):SetValue(aEmitidos[nx][4])
		oSection2:Cell("Item"):SetValue(aEmitidos[nx][5])
		oSection2:Cell("Prod"):SetValue(aEmitidos[nx][6])
		oSection2:Cell("Isbn"):SetValue(aEmitidos[nx][15])
		oSection2:Cell("Saldo"):SetValue(aEmitidos[nx][7])
		oSection2:Cell("Per"):SetValue(aEmitidos[nx][9])		
		oSection2:Cell("UnitBruTab"):SetValue(aEmitidos[nx][14])		
		oSection2:Cell("UnitTab"):SetValue(aEmitidos[nx][8])
		oSection2:Cell("PrcTab"):SetValue(aEmitidos[nx][8]*aEmitidos[nx][7])						
		oSection2:Cell("Unit3"):SetValue(aEmitidos[nx][10]/aEmitidos[nx][7])		
		oSection2:Cell("Prc"):SetValue(aEmitidos[nx][10])
		oSection2:Cell("UnitVal"):SetValue(aEmitidos[nx][11])		
		oSection2:Cell("Val"):SetValue(aEmitidos[nx][12])		
		oSection2:Cell("Tab"):SetValue(aEmitidos[nx][13])
			
		oSection2:PrintLine()
	Next nx
EndIF

oSection0:Finish()
oSection1:Finish()
oSection2:Finish()

Return()
         