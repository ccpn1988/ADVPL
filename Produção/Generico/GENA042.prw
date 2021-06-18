#include 'protheus.ch'
#INCLUDE "Protheus.ch" 
#include "Fileio.ch"
#Include "Report.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA042   �Autor  �Cleuto Lima - Loop  � Data �  30/12/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Grupo Gen                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA042   �Autor  �Microsiga           � Data �  02/02/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProcPed()

//�������������������������������������������������������������������������������������Ŀ
//�Variaveis da rotina.                                                                 �
//���������������������������������������������������������������������������������������

Local _cSQL		:= ""
Local _cCodFor
Local _cLojFor
Local _cAlias1 	:= GetNextAlias()
Local _cMvCdDe 	:= "001" //GetMv("GEN_FAT093") // Cont�m a condi��o de pagamento 
Local _cTesDev	:= "521" //GetMV("GEN_FAT094") // TES para devolu��o de consigna��o
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
				MsgAlert("N�o foram encontrados itens.")
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
	MsgAlert("N�o foi encontrado saldo consignado para o cliente!")
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
Local _cLogPd			:= "C:\WINDOWS\TEMP\" //GetMv("GEN_FAT016") //Cont�m o caminho que ser� gravado o log de erro
Local _cMvSeri 			:= "0" //SERIE nota de sa�da

Local _cMvEsp			:= GetMv("MV_ESPECIE") //Contem tipos de documentos fiscais utilizados na emissao de notas fiscais
Local _aPosEsp 			:= {}
Local _nMvEsp 			:= 0
Local _lEspec			:= .F.
Local _ni

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

WFForceDir(_cLogPd)

//����������������������������������������������������������Ŀ
//�Ponteramento nas tabelas para n�o ocorrer erro no execauto�
//������������������������������������������������������������

DbSelectArea("SA1")
DbSelectArea("SA2")

DbSelectArea("SC5")
DbSetOrder(1)

Conout(TIME() + " - GENA042 - 13")

//lMsErroAuto := .F.
//MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,3)

//If !lMsErroAuto
	
	//�������������������������������������������������������������������������������������X�
	//� Inicio Rotina para desbloquear cr�dito para que o pedido seja faturado sem problemas�
	//�������������������������������������������������������������������������������������X�
	
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
				������������������������������������������������������������������������������
				���          �Rotina de atualizacao da liberacao de credito                ���
				��������������������������������������������������������������������������Ĵ��
				���Parametros�ExpN1: 1 - Liberacao                                         ���
				���          �       2 - Rejeicao                                          ���
				���          �ExpL2: Indica uma Liberacao de Credito                       ���
				���          �ExpL3: Indica uma liberacao de Estoque                       ���
				���          �ExpL4: Indica se exibira o help da liberacao                 ���
				���          �ExpA5: Saldo dos lotes a liberar                             ���
				���          �ExpA6: Forca analise da liberacao de estoque                 ���
				��������������������������������������������������������������������������Ĵ��
				���Descri��o  �Esta rotina realiza a atualizacao da liberacao de pedido de  ���
				���          �venda com base na tabela SC9.                                ���
				������������������������������������������������������������������������������
				/*/
				a450Grava(1,.T.,.T.,.F.)  //04/02 - RAFAEL LEITE - EFETUA TAMBEM A LIBERACAO DE ESTOQUE
			EndIf
			(_cAliSC9)->(DbSkip())
		EndDo
	EndIf
	
	//�������������������������������������������������������������������������������������X�
	//� Fim    Rotina para desbloquear cr�dito para que o pedido seja faturado sem problemas�
	//�������������������������������������������������������������������������������������X�
	
	//���������������������������������������������������������������������������������������������������������X�
	//'Inicio - Caso tenha ocorrido com sucesso a gera��o do Pedido de Vendas, ir� iniciar a gera��o da Nota   '*
	//���������������������������������������������������������������������������������������������������������X�	DbSelectArea("SC9")

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
		*'Rotina utilizada para realizar a gera��o da Nota de Sa�da'*
		*'---------------------------------------------------------'*
		
		//��������������������������������Ŀ
		//�Valida��o da especie para a nota�
		//����������������������������������
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
		
		//��������������������������������������������������������������������tP�
		//�Varrendo o vetor que contem as s�ries para saber se a s�rie contida�
		//�no parametro esta correta.                                         �
		//��������������������������������������������������������������������tP�
		
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
			_cMsg := "A Nota n�o foi gerada, pois a serie n�o esta preenchida corretamente." + cEnt
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
		
		//�������������������������������������������������������Ŀ
		//�Caso a nota n�o seja gerado ir� chamar a rotina de erro�
		//���������������������������������������������������������
		If Empty(AllTrim(_cNotaImp))
			
			Conout(TIME() + " - GENA042 - 21")
			
			//�����������������������������������������������������������Ŀ
			//�Chamando o Execauto de Altera��o e em seguida o de exclus�o�
			//�������������������������������������������������������������
			
			//�������������������������������Ŀ
			//�Alterando a quantidade liberada�
			//���������������������������������
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
					_cErroLg += " O Pedido: " + _cPedExc + " foi exclu�do com sucesso. "  + cEnt
					_cErroLg += " Favor verificar o pedido: "  + cEnt
					_cErroLg += " Pois ele teve que ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
					_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois no processo houve erro. " + cEnt
					_cErroLg += " " + cEnt
					MemoWrite ( _cLogPd + "Emp" +SM0->M0_CODIGO + " Fil"+ AllTrim(SM0->M0_CODFIL) + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
				Else
					_aErro := GetAutoGRLog()
					For _ni := 1 To Len(_aErro)
						_cErroLg += _aErro[_ni] + cEnt
					Next _ni
					
					_cErroLg += "  " + cEnt
					_cErroLg += " O Pedido: " + _cPedExc + " n�o pode ser exclu�do. "  + cEnt
					_cErroLg += " Favor verificar o pedido: "  + cEnt
					_cErroLg += " pois ele deve ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
					_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois no processo houve erro. " + cEnt
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
				_cErroLg += " O Pedido: " + SC9->C9_PEDIDO + " n�o pode ser alterado para prosseguir com a exclus�o. "  + cEnt
				_cErroLg += " Favor verificar o pedido: "  + cEnt
				_cErroLg += " pois ele deve ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
				_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois no processo houve erro. " + cEnt
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