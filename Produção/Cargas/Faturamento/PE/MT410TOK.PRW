#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410TOK  �Autor  �Cleuto Lima         � Data �  04/25/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � ponto de entrada da rotina de pedido de vendas             ���
���          � chamado no TudoOk                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT410TOK()

Local lRet		:= .T. 
Local lDesc		:= .F.
Local lPedCom	:= .F.
Local lPrcLiq	:= Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_XNODESC") == "1"
Local nPosDesc	:= GdFieldPos("C6_DESCONT")
Local nPosValD	:= GdFieldPos("C6_VALDESC")
Local nPosItPed	:= GdFieldPos("C6_NUMPCOM")
Local nPosTES	:= GdFieldPos("C6_TES")
Local nPosCTA	:= GdFieldPos("C6_CONTA")

//Par�metro que cont�m o caminho onde ser� gravado o arquivo de log de inconsist�ncias
Local _cLogPd	:= SUPERGETMV("MV_XCAMLOG",.T.,"\logsiga\ped venda\") 
Local _lGrvLOG  := .f.
Local nX		:= 0
Local cErroLg   := ''

Local cConsign	:= SA1->A1_XCONSIG//M->C5_XCONSIG
Local cInTES	:= GetMv("GEN_FAT094",.F.,"")
Local cAmbiente := upper(alltrim(GetEnvServer()))
Local cProdutos	:= ""
Local cTES		:= ""

//Processo via Scheduller? 
Local _lProcSch := Type( "oMainWnd" ) <> "O"  

// Erica - 21/10/2016
// Obrigar colaboradres E-Commerce informar os campos abaixo, pois estamos com muitos pedidos no log devido ao n�o preenchimento dos mesmos.
Local cPedWeb	:= M->C5_XPEDWEB
Local cPedOld	:= M->C5_XPEDOLD
Local cGrpECo	:= GetMv("GEN_FAT127",.F.,"")

//projeto parcelamento
Local nMaxParc	:= GetMv("MV_NUMPARC",.F.,8)  
Local aCabParc	:= {}
Local nTotPrc	:= 0 // valor total a ser parcelado
Local nParcPed	:= 0 // parcela do pedido
Local nAuxPrc	:= 0
Local nQtdParc	:= 0
Local aParcel	:= {} // parcelas
Local cFORMAPG	:= ""
Local cFieldPrc	:= ""
Local _cMsg		:= ""
Local cParc1	:= GetMv("MV_1DUP")
Local _cParcela	:= ""   
Local lSugSCV	:= .F. 
Local nQtdSCV	:= 0

Local aGrp		:= UsrRetGrp( nil , RetCodUsr() )
Local cNatCart	:= GetMv("GENI018CAR") //NATUREZA PARA CARTAO DE CREDITO
Local cNatBol	:= GetMv("GENI018BOL") //NATUREZA PARA BOLETO

Local nValBrut	:= 0
Local nValLiq	:= 0
Local nVldDesc	:= 0
Local cProbDesc	:= 0

Local nAuxTes	:= 0 
Local lTemOk	:= .F.

Local cNotChar	:= SuperGetMv("GEN_FAT172",.f.,"<#>#&")
Local aNoCharXML	:= StrTokArr(cNotChar,"#")
Local cUnExp		:= ""
Local cTpPubSep	:= SuperGetMv("GEN_FAT214",.f.,.f.,"")
Local cTesVld		:= GetMv("GEN_FAT241",.F.,"504#505#505#507")

Local cVldCep		:= SuperGetMv("GEN_FAT220",.f.,.f.,"S")
Local nAuxSCV

If !Inclui .and. !Altera
	// limpa as quantidades atendidas da tabela de espelho do pedido
	If cFilAnt == "1022"	.and. !Empty(SC5->C5_XNUMESP)
		
		If Select("ZZB_TMP") > 0
			ZZB_TMP->(DbCloseArea())
		EndIf
		
		BeginSql Alias "ZZB_TMP"
			SELECT * FROM %Table:ZZB% ZZB
			WHERE ZZB_FILIAL = %Exp:SC5->C5_FILIAL%
			/*AND ZZB_NUM = %Exp:SC5->C5_NUM%*/
			AND ZZB_MSIDEN = %Exp:SC5->C5_XNUMESP% 
			AND ZZB.%NotDel%
		EndSql
		
		cUpd := "UPDATE "+RetSqlName("ZZB")+" SET ZZB_QTDENT = 0 WHERE ZZB_FILIAL = '"+SC5->C5_FILIAL+"' AND ZZB_MSIDEN = '"+SC5->C5_XNUMESP+"'"
		
		ZZB_TMP->(DbGoTop())
		If ZZB_TMP->(!EOF()) .and. !(cAmbiente $ "SCHEDULE")
			IF MsgYesNo("Este pedido, contem espelho armazenado, deseja deletar o espelho do pedido?")
				cUpd := "UPDATE "+RetSqlName("ZZB")+" SET D_E_L_E_T_ = '*' WHERE ZZB_FILIAL = '"+SC5->C5_FILIAL+"' AND ZZB_MSIDEN = '"+SC5->C5_XNUMESP+"'"				
			EndIF
		EndIf
		
		ZZB_TMP->(DbCloseArea())
			
		Begin transaction		
			Tcsqlexec(cUpd)
		End Transaction
		
	EndIf

	Return .t.	
EndIF

If !(cAmbiente $ "SCHEDULE")
	If aScan(aNoCharXML, {|x| x $ M->C5_MENNOTA } ) > 0
		IF !MsgYesNo("Os caracteres "+StrTran(cNotChar,"#",", ")+" n�o s�o permitidos na observa��o da nota fiscal, caso continue os mesmos ser�o removidos!"+chr(13)+chr(10)+"Deseja continuar?","Caractere Especial")
			Return .F.
		EndIf
    EndIf
EndIf

If !(cAmbiente $ "SCHEDULE-PRE")
	If aSCan(aGrp, {|x| AllTrim(x) $ cGrpECo } ) <> 0
		If Empty(cPedWeb) .OR. Empty(cPedOld)
			MsgStop("Necess�rio preenchimento dos campos Ped. Antigo e Pedido Web!")
			Return .F.
		EndIf
	EndIf
EndIf

IF AllTrim(cVldCep) == "S" .AND. !(M->C5_TIPO $ 'BD') .AND. !ISINCALLSTACK("U_JFILA02B")
	conout("GEN_FAT220 - consulta cep ativada")
	// Valida��o CEP ( entrega )
	if !empty(M->C5_XLOGENT)
		
		Conout("MT410TOK - Inicio - u_GENA062 - CEP - "+DtoS(DDatabase)+" - "+Time())
		If  ( "BR" $ UPPER(M->C5_XPAIENT) .OR. "BRASIL" $ UPPER(M->C5_XPAIENT) )
			lRet 	  := u_GENA062(M->C5_XCEPENT, _lProcSch, .T. , 'Dados Entrega', @cErroLg ) 
			_lGrvLOG  := !lRet
			If _lGrvLOG
				AutoGrLog( "MT410TOK - GENA062 - CEP "+M->C5_XCEPENT+" invalido "+DtoC(DDataBase)+" "+Time() )
			EndIf				
		EndIf
		Conout("MT410TOK - Fim - u_GENA062 - CEP - "+DtoS(DDatabase)+" - "+Time())
		
	Else
	
		If SA1->A1_EST <> "EX"
			Conout("MT410TOK - Inicio - u_GENA062 - CEP - "+DtoS(DDatabase)+" - "+Time())
			// Valida��o CEP ( cliente )
			lRet := u_GENA062(SA1->A1_CEP, _lProcSch, .T., 'Cliente', @cErroLg  )
			_lGrvLOG  := !lRet
			If _lGrvLOG
				AutoGrLog( "MT410TOK - GENA062 - CEP "+SA1->A1_CEP+" invalido "+DtoC(DDataBase)+" "+Time() )
			EndIf
			Conout("MT410TOK - Fim - u_GENA062 - CEP - "+DtoS(DDatabase)+" - "+Time())	
	    EndIf
	Endif
Else
	conout("GEN_FAT220 - consulta cep desativada")	
EndIf

// Validado CEP
if lRet 

	If lPrcLiq
			
		//aEval(aCols, {|x| lDesc := IIF( x[nPosDesc] > 0 .OR. x[nPosValD] > 0 , .T. , lDesc ) } )
		aEval(aCols, {|x| lPedCom := IIF( Empty(x[nPosItPed]) , .T. , lPedCom ) } )
		
		Do Case
			Case Empty(M->C5_XPEDCLI) .AND. lPedCom
				MsgStop('Para este cliente � obrigat�rio informar o campo "Pedido Cliente"')
				lRet := .F.
				
			//Case lDesc          
			//	MsgStop('Para este cliente n�o deve ser informado valor de desconto no pedido de vendas!')
			//	lRet := .F.
						
		EndCase
		
	EndIf
	 
	//�������������������������������������������������������������������������Ŀ
	//� Validacao se alguma das TES inseridas sao de cosignacao e o cliente nao �
	//� possui permissao para efetivar pedido                                   �
	//���������������������������������������������������������������������������
	If !(cAmbiente $ "SCHEDULE-PRE")
	
		For nX := 1 To Len(aCols)
			If aCols[nX][nPosTES] $ cInTES .AND. (cConsign == "N" .OR. Empty(cConsign))		
				Aviso(	"TES inv�lida", "Uma das TES especificada � uma TES de consigna��o e o cliente n�o tem permiss�o para essa opera��o." + CRLF +;
						"N�o ser� permitido utilizar esta TES, se o cadastro do cliente estiver com o campo '" +;
						GetSX3Cache("A1_XCONSIG", "X3_TITULO") + "' vazio ou sem permiss�o de consigna��o ('N').", {"&Voltar"},, "Aten��o",,;
						"MSGHIGH")
				lRet := .F.
				Exit
			Endif
		Next nX
	
		If lRet
			lRet := M410ContArr(aCols, @cProdutos, "C6_PRODUTO")
			If !Empty(cProdutos)
					Aviso(	"Itens replicados", "Existem produtos replicados. " + CRLF + "Por favor, revise-os para que a grava��o seja " +;
							"realizada:" + CRLF + CRLF + cProdutos, {"&Voltar"},3, "Aten��o",, "MSGHIGH" )
			EndIf
		EndIf
		
		//������������������������������������������������������������������������������Ŀ
		//� Caio Neves     - 04/mar�o/2020                                              �
		//� Verifica se existe TES em todos os itens da grid ao efetivar or�amento      �
		//��������������������������������������������������������������������������������	
		If cFilAnt == "1022" .AND. !ISINCALLSTACK("U_GENA006") .AND. !ISINCALLSTACK("U_GENA082") .AND. !ISINCALLSTACK("U_GENA082P")
			If aCols[1][nPosTES]  <> SF4->F4_CODIGO
				SF4->(DbSetOrder(1))
				SF4->(DbSeek( xFilial("SF4") + aCols[1][nPosTES]))			
			EndIf
			For nAuxTes := 1 To Len(aCols)
				If Empty(aCols[nAuxTes][nPosCTA]) 
					If  !Empty(AllTrim(SF4->F4_XCONTA)) .and. ( SF4->F4_LFICM <> 'N' .OR. SF4->F4_LFIPI <> 'N' .OR. SF4->F4_LFISS <> 'N' .OR. SF4->F4_PISCOF <> '4' )
						If ( cAmbiente $ "SCHEDULE" )
								AutoGrLog( "MT410TOK - Conta contabil n�o informada para o item "+cValToChar(nAuxTes)+" e TES que gera livro fiscal!" )						
							Else
								MsgStop( "MT410TOK - Conta contabil n�o informada para o item "+cValToChar(nAuxTes)+" e TES que gera livro fiscal!" )
						ENDIF
						lRet := .F.
						Exit
					ENDIF		 
				ENDIF
			Next nAuxTes
		ENDIF

	
		//������������������������������������������������������������������������������Ŀ
		//� Renato Calabro' - 24/jun/2016                                                �
		//� Verifica se existe mais de um codigo de TES inserido                         �
		//��������������������������������������������������������������������������������
		//������������������������������������������������������������������������������Ŀ
		//� Cleuto Lima     - 20/julho/2017                                              �
		//� Verifica se existe mais de um codigo de Pai TES inserido                     �
		//��������������������������������������������������������������������������������		
		If lRet
			cTES	:= Posicione("SF4",1,xFilial("SF4")+aCols[1][nPosTES],"F4_XTESPAI")
			For nAuxTes	:= 1 To Len(aCols)				
				If SF4->F4_CODIGO == aCols[nAuxTes][nPosTES]
					Loop
				EndIf
				If cTES <> Posicione("SF4",1,xFilial("SF4")+aCols[nAuxTes][nPosTES],"F4_XTESPAI")
					Aviso(	"M�ltiplas TES PAI inseridas", "N�o � permitido selecionar mais de um c�digo de TES com TES PAI diferentes." + CRLF + "Por favor, revise os " +;
							"itens novamente para confirmar o pedido de venda.", {"&Voltar"},, "Aten��o",, "MSGHIGH" )
					lRet := .F.					
				EndIf
			Next
			/*
			aEval(aCols, {|x| cTES += If(At(x[nPosTES], cTES) == 0 .AND. !aTail(x), x[nPosTES] + "@!@", "") })
			If Len(Separa(cTES, "@!@", .F.)) > 1
				Aviso(	"M�ltiplas TES inseridas", "N�o � permitido selecionar mais de um c�digo de TES." + CRLF + "Por favor, revise os " +;
						"itens novamente para confirmar o pedido de venda.", {"&Voltar"},, "Aten��o",, "MSGHIGH" )
				lRet := .F.
			EndIf
			*/
		EndIf
		
		//Validacao dos Campos da Entrega
		If lRet .AND. !Empty(M->C5_XLOGENT)
			If Empty(M->C5_XNOMENT) .OR.; //nome
				Empty(M->C5_XCEPENT) .OR.; //cep
				Empty(M->C5_XLOGENT) .OR.;//logradouro
				Empty(M->C5_XNUMENT) .OR.;//numero
				Empty(M->C5_XBAIENT) .OR.;//bairo
				Empty(M->C5_XCIDENT) .OR.;//cidade		
				Empty(M->C5_XUFENT ) //uf
				Aviso(	"Campos Obrigatorios ", "Campos da Entrega Obrigat�rios: " +CRLF+;
							TitSX3("C5_XNOMENT")[1]+CRLF+; //nome
							TitSX3("C5_XCEPENT")[1]+CRLF+; //cep
							TitSX3("C5_XLOGENT")[1]+CRLF+;//logradouro
							TitSX3("C5_XNUMENT")[1]+CRLF+;//numero
							TitSX3("C5_XBAIENT")[1]+CRLF+;//bairo
							TitSX3("C5_XCIDENT")[1]+CRLF+;//cidade		
							TitSX3("C5_XUFENT")[1] , {"&Voltar"},, "Aten��o",, "MSGHIGH" )
							
				lRet := .F.
			EndIf
		EndIf		
		 
	Endif
	
Endif

//Gravar LOG?
if _lGrvLOG

	MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(M->C5_TIPO) + "_WEB_" +;
			    AllTrim(M->C5_XPEDWEB) + "_OLD_" + AllTrim(M->C5_XPEDOLD) + ".txt" , cErroLg )
			     
Endif

//����������������������Ŀ
//�Valida��o de desconto.�
//������������������������
If lRet .and. !Empty(M->C5_TABELA) ;
	.AND. !IsInCallStack("U_GENA006") .AND. FunName() <> "GENA006" ;
	.AND. !IsInCallStack("U_GENA020") .AND. FunName() <> "GENA020" ;
	.AND. !IsInCallStack("U_GENI023") .AND. FunName() <> "GENI023";
	.AND. !IsInCallStack("U_GENI024") .AND. FunName() <> "GENI024";
	.AND. !IsInCallStack("U_GENA046") .AND. FunName() <> "GENA046";
	.AND. !IsInCallStack("U_GENA082") .AND. FunName() <> "GENA082";
	.AND. !( AllTrim(M->C5_CLIENTE) $ '0380795#0380796#0380794#031811#0378128#0005065')
	
	cProbDesc	:= ""
	
	For nVldDesc := 1 To Len(aCols)

		If GdDeleted( nVldDesc , aHeader , aCols )
			Loop
		EndIf
			
		DA1->( DbSetOrder(1) )
		DA1->(dbSeek(xFilial("DA1")+M->C5_TABELA+aCols[nVldDesc][GdFieldPos("C6_PRODUTO",aHeader)] ))	
			
		nValBrut	:= aCols[nVldDesc][GdFieldPos("C6_QTDVEN",aHeader)]*DA1->DA1_PRCVEN
		nValLiq	:= aCols[nVldDesc][GdFieldPos("C6_QTDVEN",aHeader)]*aCols[nVldDesc][GdFieldPos("C6_PRCVEN",aHeader)]
		
		Do Case
			/* verifico se o valor do desconto calculado pelo protheus � o mesmo do valor total do item */
			Case NoRound(nValLiq,0) <> NoRound(aCols[nVldDesc][GdFieldPos("C6_VALOR",aHeader)],0)
				lRet := .F.
				cProbDesc+= "Valor total liquido calculado diferente do valor calculado pelo Protheus para o item "+aCols[nVldDesc][GdFieldPos("C6_ITEM",aHeader)]+" valor calculado "+AllTrim(Transform(nValLiq, "@E 999,999,999.99"))+" valor do Protheus"+AllTrim(Transform(aCols[nVldDesc][GdFieldPos("C6_VALOR",aHeader)], "@E 999,999,999.99"))+chr(13)+chr(10)
				
			/* verifico de o valor bruto da tabela de pre�o aplicando o campo valor do desconto do pedido � o mesmo que o valor total calculado pelo protheus  */	
			Case NoRound(nValBrut-aCols[nVldDesc][GdFieldPos("C6_VALDESC",aHeader)],0) <> NoRound(aCols[nVldDesc][GdFieldPos("C6_VALOR",aHeader)],0)
				lRet := .F.
				cProbDesc+= "Valor total calculo diferente do valor total do protheus para o item "+aCols[nVldDesc][GdFieldPos("C6_ITEM",aHeader)]+" valor calculado "+AllTrim(Transform(Round(nValBrut-aCols[nVldDesc][GdFieldPos("C6_VALDESC",aHeader)],2), "@E 999,999,999.99"))+" valor Protheus "+AllTrim(Transform(aCols[nVldDesc][GdFieldPos("C6_VALOR",aHeader)], "@E 999,999,999.99"))
				
			/* verifico de o valor bruto da tabela de pre�o aplicando o campo % do desconto do pedido � o mesmo que o valor total calculado pelo protheus  */	
			//Case Round(nValBrut-((GdFieldPos("C6_DESCONT",aHeader)/100)*GdFieldPos("C6_QTDVEN",aHeader)),2) <> GdFieldPos("C6_VALOR",aHeader)
			Case NoRound(nValBrut - (((aCols[nVldDesc][GdFieldPos("C6_DESCONT",aHeader)]/100)*DA1->DA1_PRCVEN )*aCols[nVldDesc][GdFieldPos("C6_QTDVEN",aHeader)]) ,0) - NoRound(aCols[nVldDesc][GdFieldPos("C6_VALOR",aHeader)],0) < (-1) .OR.;
				 NoRound(nValBrut - (((aCols[nVldDesc][GdFieldPos("C6_DESCONT",aHeader)]/100)*DA1->DA1_PRCVEN )*aCols[nVldDesc][GdFieldPos("C6_QTDVEN",aHeader)]) ,0) - NoRound(aCols[nVldDesc][GdFieldPos("C6_VALOR",aHeader)],0) > 1
				 
				lRet := .F.
				cProbDesc+= "Valor total calculo diferente do valor total do protheus para o item "+aCols[nVldDesc][GdFieldPos("C6_ITEM",aHeader)]+" valor calculado "+AllTrim(Transform(Round(nValBrut - (((aCols[nVldDesc][GdFieldPos("C6_DESCONT",aHeader)]/100)*DA1->DA1_PRCVEN )*aCols[nVldDesc][GdFieldPos("C6_QTDVEN",aHeader)]) ,2), "@E 999,999,999.99"))+" valor Protheus "+AllTrim(Transform(aCols[nVldDesc][GdFieldPos("C6_VALOR",aHeader)], "@E 999,999,999.99"))
			/* verifico se os valores dos campos de desconto % e valor est�o corretos */
			Case	NoRound((((aCols[nVldDesc][GdFieldPos("C6_DESCONT",aHeader)]/100)*DA1->DA1_PRCVEN )*aCols[nVldDesc][GdFieldPos("C6_QTDVEN",aHeader)]) ,0) - NoRound(aCols[nVldDesc][GdFieldPos("C6_VALDESC",aHeader)]	,0) < (-2) .OR.;
					NoRound((((aCols[nVldDesc][GdFieldPos("C6_DESCONT",aHeader)]/100)*DA1->DA1_PRCVEN )*aCols[nVldDesc][GdFieldPos("C6_QTDVEN",aHeader)]) ,0) - NoRound(aCols[nVldDesc][GdFieldPos("C6_VALDESC",aHeader)]	,0) > 2
					
				lRet := .F.
				cProbDesc+= "Campo Valor do desconto diferente do percentual do desconto item "+aCols[nVldDesc][GdFieldPos("C6_ITEM",aHeader)]+" valor calculado com % de desconto "+Transform(Round((((aCols[nVldDesc][GdFieldPos("C6_DESCONT",aHeader)]/100)*DA1->DA1_PRCVEN )*aCols[nVldDesc][GdFieldPos("C6_QTDVEN",aHeader)]) ,2), "@E 999,999,999.99")+" valor do campo 'valor desconto' do Protheus "+AllTrim(Transform(aCols[nVldDesc][GdFieldPos("C6_VALDESC",aHeader)], "@E 999,999,999.99"))
			Case aCols[nVldDesc][GdFieldPos("C6_VALDESC",aHeader)] <> 0 .AND. aCols[nVldDesc][GdFieldPos("C6_DESCONT",aHeader)] == 0
				lRet := .F.
				cProbDesc+= "Campo Valor do desconto diferente do percentual do desconto item "+aCols[nVldDesc][GdFieldPos("C6_ITEM",aHeader)]+" valor calculado com % de desconto "+AllTrim(Transform(aCols[nVldDesc][GdFieldPos("C6_DESCONT",aHeader)], "@E 999,999,999.99"))+" valor do campo 'valor desconto' do Protheus "+AllTrim(Transform(aCols[nVldDesc][GdFieldPos("C6_VALDESC",aHeader)], "@E 999,999,999.99"))			
			Case aCols[nVldDesc][GdFieldPos("C6_DESCONT",aHeader)] <> 0 .AND. aCols[nVldDesc][GdFieldPos("C6_VALDESC",aHeader)] == 0
				lRet := .F.
				cProbDesc+= "Campo Valor do desconto diferente do percentual do desconto item "+aCols[nVldDesc][GdFieldPos("C6_ITEM",aHeader)]+" valor calculado com % de desconto "+AllTrim(Transform(aCols[nVldDesc][GdFieldPos("C6_DESCONT",aHeader)], "@E 999,999,999.99"))+" valor do campo 'valor desconto' do Protheus "+AllTrim(Transform(aCols[nVldDesc][GdFieldPos("C6_VALDESC",aHeader)], "@E 999,999,999.99"))			
		EndCase
			
	Next
	
	If !Empty(cProbDesc)
		/* armazena log caso seja execauto */
		AutoGrLog( "MT410TOK - Erro de desconto no pedido: "+DtoC(DDataBase)+" "+Time() )
		AutoGrLog( "MT410TOK - Filial:"+cFilant+" Pedido: "+M->C5_NUM )				
		
		If !("SCHEDULE" $ upper(alltrim(GetEnvServer())) )
			/* alert caso seja em tela */
			xMagHelpFis("Valor do pedido incorreto",cProbDesc,"Verifique se os campos % Desconto, Valor Desconto e Valor total est�o corretos e tente novamente")		
		EndIf
		/* envia e-mail para o TI */
		U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("Erro de desconto no pedido: "+M->C5_NUM+" - "+DtoC(DDataBase)+" "+Time()),cProbDesc,,,.F.)				
	EndIf
	
EndIf

If lRet// .AND. .f.
	
	//�������������������������������������������������Ŀ
	//�cleuto Lima - 19/01/2017                         �
	//�                                                 �
	//�tratamento para verificar a estrutura de parcelas�
	//���������������������������������������������������
	
	If !Empty(M->C5_XPEDWEB) .AND. !Empty(M->C5_XPEDOLD)
		
		IF (ISINCALLSTACK("U_JFILA02B") .AND. M->C5_CONDPAG == "001") .OR. ISINCALLSTACK("U_GENI027")  .OR. ISINCALLSTACK("U_GENI026") .OR. ISINCALLSTACK("U_GENI030")
			/* PARA PEDIDOS INCLUIDOS ANTES DA NOVA REGRA DE PARCELAMENTO */
			Return lRet
		EndIf
		
		If Empty(M->C5_NATUREZ)
			MsgStop("Natureza n�o informada, quando pedido web � preciso informar se natureza de cart�o ou boleto!"+Chr(13)+Chr(10)+"Boleto: "+cNatBol+" , Cart�o:"+cNatCart)
			Return .F.			
		EndIf
		
		If  AllTrim(M->C5_NATUREZ) == AllTrim(cNatCart)
			
			If AllTrim(M->C5_NATUREZ) == AllTrim(cNatCart) .AND. M->C5_CONDPAG <> "099"
				
				AutoGrLog( "MT410TOK - Pedidos originados do e-commerce devem ter condi��o de pagamento tipo 099!"+DtoC(DDataBase)+" "+Time() + Chr(13)+Chr(10)+cErroLg )
				AutoGrLog( "MT410TOK - Filial:"+cFilant+" Pedido: "+M->C5_NUM )
							
				MsgStop("Pedidos originados do e-commerce devem ter condi��o de pagamento tipo 099!")
				Return .F.
				//EndIf				
				//IF !MsgYes("Pedidos originados do e-commerce devem ter condi��o de pagamento tipo 099, deseja continuar mesmo assim!")
				//	Return .F.
				//EndIf	
			EndIf
			
			//_nTotParc valor a ser parcelado
			aEval( aCols , {|x| nTotPrc+=x[GdFieldPos("C6_VALOR",aHeader)] } )		
			aAdd ( aCabParc , { "C5_FRETE" 	, M->C5_FRETE , NIL} )
					
			aParcel := U_GENI018P(aCabParc,M->C5_XPEDOLD,@cFORMAPG,nTotPrc,_cMsg,NIL,M->C5_XPEDWEB)
	
			nParcPed	:= 0
			cCountPc	:= "0"
			For nAuxPrc := 1 To nMaxParc
				cCountPc	:= Soma1(cCountPc)
				cFieldPrc	:= "C5_PARC"+AllTrim(cCountPc)
				If SC5->(FieldPos(cFieldPrc))  > 0
					nParcPed	+= M->&(cFieldPrc)
					If M->&(cFieldPrc) > 0
						nQtdParc++
					EndIf
				EndIf
			Next
	        
			If Len(aParcel) <> nQtdParc
				MsgStop("Quantidade de parcelas informada no pedido � diferente do parcelamento e-commerce!")
				Return .F.
			EndIf   
	
			For nAuxSCV := 1 To Len(aColsFor)
				
				If !aColsFor[nAuxSCV][GdPosDeleted( aHeadFor )] .AND. !Empty(aColsFor[nAuxSCV][GdFieldPos("CV_FORMAPG",aHeadFor)])
					nQtdSCV++
				EndIf
				
			Next nAuxSCV
						
			//Ma410MtFor(aHeadFor,aColsFor,aRegSCV)
			If Len(aParcel) <> nQtdSCV
				lSugSCV := .T.//MsgYesNo("Quantidade de parcelas informada menu de pagamentos � diferente do parcelamento e-commerce!"+Chr(13)+Chr(10)+"Desja que o Protheus preencha automaticamente?")			
				If !lSugSCV
					Return .F.
				EndIf
			Else
				For nAuxSCV := 1 To Len(aColsFor)
					
					If !aColsFor[nAuxSCV][GdPosDeleted( aHeadFor )]
						
						Do Case
							//Case Empty(aColsFor[nAuxSCV][GdFieldPos("CV_PEDIDO",aHeadFor)])  
							//	lSugSCV := .T.
							Case Empty(aColsFor[nAuxSCV][GdFieldPos("CV_FORMAPG",aHeadFor)]) 
								lSugSCV := .T.
							Case Empty(aColsFor[nAuxSCV][GdFieldPos("CV_XPEDOLD",aHeadFor)]) 
								lSugSCV := .T.
							Case Empty(aColsFor[nAuxSCV][GdFieldPos("CV_XPARCEL",aHeadFor)]) 
								lSugSCV := .T.
							Case Empty(aColsFor[nAuxSCV][GdFieldPos("CV_XOPERA",aHeadFor)]) 
								lSugSCV := .T.
							Case Empty(aColsFor[nAuxSCV][GdFieldPos("CV_XNSUTEF",aHeadFor)]) 
								lSugSCV := .T.
							Case Empty(aColsFor[nAuxSCV][GdFieldPos("CV_XBANDEI",aHeadFor)]) 
								lSugSCV := .T.							
						EndCase
	
					EndIf
					
				Next nAuxSCV	
			EndIf
	        						
			If lSugSCV
	
				For nAuxSCV := 1 To Len(aColsFor)
					
					aColsFor[nAuxSCV][GdPosDeleted( aHeadFor )]	:= .T.
					
				Next nAuxSCV
	
					//Para remontar o aCols com os valores padr�es
				aLinSCV	:=	GdRmkaCols(     aHeadFor           ,;     //Array com a Estrutura para criacao do aCols
					                              .F.          ,;     //Estado do Elemento de Delecao no aCols
					                              .T.          ,;     //Se existe o Elemento de Delecao
					                              .F.           )[1]     //Se deve carregar os inicializadores padroes
							
				_cParcela	:= ""
				For nAuxSCV := 1 To Len(aParcel)
					
					Aadd( aColsFor , aClone(aLinSCV) )
					nLinAuxSCV	:= Len(aColsFor)				
					_cParcela 	:= If(nAuxSCV == 1,cParc1,Soma1(_cParcela))
					
					//aColsFor[nLinAuxSCV][GdFieldPos("CV_PEDIDO",aHeadFor)]		:= M->C5_NUM
					aColsFor[nLinAuxSCV][GdFieldPos("CV_FORMAPG",aHeadFor)]	:= "CC"
					aColsFor[nLinAuxSCV][GdFieldPos("CV_DESCFOR",aHeadFor)]	:= Posicione("SX5",1,xFilial("SX5")+"24"+"CC","X5_DESCRI")
					aColsFor[nLinAuxSCV][GdFieldPos("CV_XPEDOLD",aHeadFor)]	:= M->C5_XPEDOLD
					aColsFor[nLinAuxSCV][GdFieldPos("CV_XPARCEL",aHeadFor)]	:= _cParcela
					aColsFor[nLinAuxSCV][GdFieldPos("CV_XOPERA",aHeadFor)]	:= aParcel[nAuxSCV,3]
					aColsFor[nLinAuxSCV][GdFieldPos("CV_XNSUTEF",aHeadFor)]	:= aParcel[nAuxSCV,4]
					aColsFor[nLinAuxSCV][GdFieldPos("CV_XBANDEI",aHeadFor)]	:= aParcel[nAuxSCV,5]
					
				Next nAuxSCV		
				
				//MsgAlert("Informa��es carregadas com sucesso, por favor, confiradas os dados e confirme novamente o pedido!")
						
			EndIf
			
		EndIf
		
	EndIf
	
EndIf

If lRet
	If M->C5_TIPOCLI == "X"
		cUnExp		:= AllTrim(SuperGetMv("GEN_FAT208",.F.," ")) 
		cErroLg	:= ""
		If !Empty(cUnExp)
			For nAuxTes := 1 To Len(aCols)
		
				If GdDeleted( nAuxTes , aHeader , aCols )
					Loop
				EndIf
				
				nFtConv	:= Posicione("SB5",1,xFilial("SB5")+ aCols[nAuxTes][GdFieldPos("C6_PRODUTO",aHeader)],"B5_CONVDIP" )

				// verifica��o para n�o realizar dbseek desnecessario impactando em notas com 99 itens
				If AllTrim(SB1->B1_COD) <> AllTrim( aCols[nAuxTes][GdFieldPos("C6_PRODUTO",aHeader)] ) 
					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1")+ aCols[nAuxTes][GdFieldPos("C6_PRODUTO",aHeader)] ))
				EndIf
					
				If "#"+alltrim(SB1->B1_XIDTPPU)+"#" $ cTpPubSep
					nPsBru		:= Posicione("SB1",1,xFilial("SB1")+ aCols[nAuxTes][GdFieldPos("C6_PRODUTO",aHeader)],"B1_PESBRU" )
				Else
					nPsBru		:= 1
				EndIF
				
				If "#"+alltrim(SB1->B1_XIDTPPU)+"#" $ cTpPubSep
					If nPsBru <> nFtConv
						cErroLg+= "Item: "+aCols[nAuxTes][GdFieldPos("C6_ITEM",aHeader)]+",Obra: "+AllTrim(SB1->B1_COD)+" "+AllTrim(SB1->B1_DESC)+", fator de convers�o de peso para "+cUnExp+" n�o informado ou incorreto."+Chr(13)+Chr(10)							
					EndIf
				Else
					If nFtConv <> 1
						cErroLg+= "Item: "+aCols[nAuxTes][GdFieldPos("C6_ITEM",aHeader)]+",Obra: "+AllTrim(SB1->B1_COD)+" "+AllTrim(SB1->B1_DESC)+", fator de convers�o de peso para "+cUnExp+" n�o informado ou incorreto."+Chr(13)+Chr(10)							
					EndIf				
				EndIf
				
				If Empty(SB5->B5_UMDIPI) .OR. ( !Empty(SB5->B5_UMDIPI) .AND. AllTrim(SB5->B5_UMDIPI) <> cUnExp )
					cErroLg+= "Item: "+aCols[nAuxTes][GdFieldPos("C6_ITEM",aHeader)]+",Obra: "+AllTrim(SB1->B1_COD)+" "+AllTrim(SB1->B1_DESC)+", unidade de medida tributaria para exporta��o n�o informada ou invalida, a mesma deve ser "+cUnExp+" ."+Chr(13)+Chr(10)							
				EndIf			
				
			Next

			If !Empty(cErroLg)
				lRet := .F.
				AutoGrLog( "MT410TOK - Inconsist�ncias nos dados de unidade de medida tributaria para exporta��o. Verificar os campos �UM DIPI� e �Conv.DIPI� no complemento do produto. "+DtoC(DDataBase)+" "+Time() + Chr(13)+Chr(10)+cErroLg )
				AutoGrLog( "MT410TOK - Filial:"+cFilant+" Pedido: "+M->C5_NUM )
				
				IF !(cAmbiente $ "SCHEDULE")
					xMagHelpFis("Inconsist�ncias Exporta��o",cErroLg,"MT410TOK - Inconsist�ncias nos dados de unidade de medida tributaria para exporta��o. Verificar os campos �UM DIPI� e �Conv.DIPI� no complemento do produto.")
				EndIf
				
				cErroLg := ""
			EndIf	
								
		EndIf	
	EndIf
EndIf

If lRet .AND. !(cAmbiente $ "SCHEDULE") .AND. ( Inclui .OR. Altera ) .AND. M->C5_TIPO == "N" .AND. Len(aCols) > 0 .AND. cFilAnt == "1022" .AND. FunName()=="MATA410"
		
	IF Posicione("SF4",1,xFilial("SF4")+aCols[1][GdFieldPos("C6_TES")],"F4_ESTOQUE") <> "S" ;
		.OR. !(aCols[1][GdFieldPos("C6_TES")] $ cTesVld) ;
		.OR. Empty(aCols[1][GdFieldPos("C6_TES")])
		Return lRet
	EndIf
	
	If Type('oGetDad:oBrowse')<>"U"
		oGetDad:oBrowse:nAt	:= 1
		oGetDad:oBrowse:Refresh()

		lRet := ExecBlock("M410LIOK",.F.,.F.,oGetDad)//U_M410LIOK()
		If lRet
			lTemOk	:= .F.
			Processa({|| lRet := U_GENA084()},"Valida��o de estoque","Aguarde! Consultando saldo em estoque das obras solicitadas!",.F.)
			If lRet			
				For nAuxTes := 1 To Len(aCols)		
					If GdDeleted( nAuxTes , aHeader , aCols )
						Loop
					Else
						lTemOk := .T.	
					EndIf			
				Next
				lRet := lTemOk
			EndIf
		EndIf			
	Endif	
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410ContAr� Autor � Renato Calabro'    � Data �  06/23/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao que faz a contagem de quantos produtos existem no   ���
���          � array aCols                                                ���
�������������������������������������������������������������������������͹��
���Parametros� aExp1 - Array contendo o aCols                             ���
���          � cExp2 - Variavel para acumular as divergencias             ���
���          � cExp3 - Campo a ser considerado para referencia            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function M410ContArr(aColTmp, cProdutos, cCampo)

Local cTpPub	:= SuperGetMv("GEN_FAT108",, "5;9;11;14;15;16;17;19")

Local nX		:= 0
Local nCount	:= 0
Local nPosCpo	:= 0
Local nPosItem	:= aScan(aHeader, {|x| AllTrim(x[2]) == "C6_ITEM"})
Local nPosTes	:= aScan(aHeader, {|x| AllTrim(x[2]) == "C6_TES"})
Local lRet		:= .T.

Local aAreas	:= {SB1->(GetArea()), GetArea()}

Local bPosSB1	:= {|| AllTrim(Posicione("SB1", 1, xFilial("SB1")+aColTmp[nX][nPosCpo], "B1_XIDTPPU"))}

Default cProdutos	:= ""
Default cCampo		:= ""

Default aColTmp		:= {}

nPosCpo	:= aScan(aHeader, {|x| AllTrim(x[2]) == AllTrim(cCampo) })

For nX := 1 To Len(aColTmp)
	
	cTesAux := aColTmp[nX][nPosTes]
	cTesPed	:= Posicione("SF4",1,xFilial("SF4")+cTesAux,"F4_XSEPPED")
	
	If cTesPed <> "1"
		Loop
	EndIf
	
	nCount := 0
	aEval(aColTmp, {|x| nCount += If(	AllTrim(x[nPosCpo]) == AllTrim(aColTmp[nX][nPosCpo]) .AND.;
										!x[Len(x)] .AND.;
										aScan(Separa(cTpPub, ";", .F.), {|x| AllTrim(x) == AllTrim(Eval(bPosSB1)) }) == 0, 1, 0) })
										
	If nCount > 1 .AND. !(AllTrim(aColTmp[nX][nPosCpo]) $ cProdutos)
		cProdutos +=	"Item: " + AllTrim(aColTmp[nX][nPosItem]) + " " + AllTrim(aColTmp[nX][nPosCpo]) + " - n� repeti��es: " +;
						cValToChar(nCount) + CRLF
		lRet := .F.
	EndIf
	
Next nX

aEval(aAreas, {|x| RestArea(x) })

Return lRet


