#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#DEFINE cEnt Chr(13)+Chr(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENI066   �Autor  �Cleuto Lima         � Data �  19/06/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera Faturamento Gerencial Brinde Curso Forum               ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENI066()

Local _aArea 		:= GetArea()
Private lDigital	:= .F.

Conout("GENI066 - Inicio da importa��o de pedido de vendas - ")

//�������������������������������������������������������������������Ŀ
//�Verifica��o para saber se a rotina esta sendo chamada pela Schedule�
//���������������������������������������������������������������������
Prepare Environment Empresa "00" Filial "1022"

	If upper(alltrim(GetEnvServer())) $ "SCHEDULE" //EXECUTA SOMENTE NO AMBIENTE SCHEDULE
		
		If LockByName("GENI066",.T.,.T.,.T.)		
			GENI066A()
			UnLockByName("GENI066",.T.,.T.,.T.)
		Else
			Conout("GENI066 - n�o foi poss�vel iniciar a rotina pois a mesma j� est� sendo executada!")
		EndIf
	Endif
	
Reset Environment

RestArea(_aArea)

Return()

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �GENI066A  �Autor  �Saturnino - Loop      � Data �  07/06/2017	���
���������������������������������������������������������������������������͹��
���Desc.     �Rotina para o processamento da integra��o do pedido de venda	���
���          �                                                            	���
���������������������������������������������������������������������������͹��
���Uso       � GEN                                                        	���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GENI066A()

Local _cDescPd		:= ""
Local _cLocB1		:= ""
Local _cMsg			:= ""
Local _aDir			:= {}
Local _cCont 		:= "01"
Local _cTipo		:= "OFERTA"

Local _nI           := 0
Local _cTes			:= GetMv("GEN_FAT273",.f.,"571")
Local _cMailPdForum	:= GetMv("GEN_FAT153")
Local nPercDA		:= GetMv("GEN_FAT266",.f.,0.7)

Local nDesc			:= 0
Local nValtot		:= 0
Local nValDesc		:= 0
Local nValPrc		:= 0
Local _aCabPd 		:= {}
Local _aItmPd 		:= {}
Local _alinha		:= {}
Local _cTabela 		:= GetMv("GEN_FAT064")
Local cTesBrinde	:= GetMv("GEN_FAT271",.F.,"569|570")
Local _cArqTmp		:= GetNextAlias()

Private	_cLogPd		:= SUPERGETMV("GEN_FAT154",.T.,"\logsiga\ped_forum\")+"gen_to_forum\" 	 			//Par�metro que cont�m o caminho onde ser� gravado o arquivo de log de inconsist�ncias

//�������������������������������������������������������������������������Ŀ          
//� Saturnino - Cria a pasta de log caso a mesma nao exista no StarthPath	�
//���������������������������������������������������������������������������
WFForceDir(_cLogPd)

//�������������������������������������������������������������������������Ŀ
//� Executar limpeza dos logs												�
//���������������������������������������������������������������������������
_aDir	:= directory(Alltrim(_cLogPd)+"*")

For _ni:= 1 to Len(_aDir)
	fErase(Alltrim(_cLogPd)+_aDir[_ni][1])
Next _ni

cTesBrinde := '%'+FormatIn(cTesBrinde,"|")+'%'

//��������������������������������������������������������������������Ŀ          
//�Conforme levantado ser� criado uma view disponibilizada no protheus �
//�que ir� conter todos os pedidos que dever�o ser importados          �
//����������������������������������������������������������������������
BEGINSQL ALIAS _cArqTmp
	SELECT C6_NUM,C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_LOCAL, C5_CLIENTE,C5_LOJACLI, C6_XCURSO, DA1_PRCVEN,C5_XPEDOLD,C5_XPEDWEB FROM %Table:SC6% SC6
	JOIN %Table:SC5% SC5
	ON C5_FILIAL = SC6.C6_FILIAL
	AND C5_NUM = C6_NUM
	AND SC5.%NotDel%
	JOIN %Table:DA1% DA1
	ON DA1_FILIAL = %xFilial:DA1%
	AND DA1_CODPRO = C6_PRODUTO
	AND DA1_CODTAB = %Exp:_cTabela%
	AND DA1.%NotDel%
	JOIN %Table:SF2% SF2
	ON F2_FILIAL = C5_FILIAL
	AND F2_DOC = C5_NOTA
	AND F2_SERIE = C5_SERIE
	AND SF2.%NotDel%
	WHERE C6_FILIAL = %xFilial:SC6%
	AND C6_TES IN %Exp:cTesBrinde%
	AND C6_XPEDWEB <> ' '
	AND C6_XCURSO <> ' '
	AND SC6.%NotDel%
	AND NOT EXISTS
		(
		SELECT 1
		FROM %Table:SC6% DA
		WHERE DA.C6_FILIAL = SC6.C6_FILIAL
		AND DA.C6_XPEDWEB = SC6.C6_XPEDWEB
		AND DA.C6_XCURSO = SC6.C6_XCURSO
		AND DA.C6_PRODUTO = SC6.C6_PRODUTO
		AND DA.C6_TES = %Exp:_cTes%
		)
ENDSQL

While (_cArqTmp)->(!EOF())

	_cCont 		:= "01"
	_aItmPd		:= {}
	_aCabPd		:= {}
	_alinha		:= {}
	_cPedWeb    := (_cArqTmp)->C5_XPEDWEB
	_cPedOld	:= (_cArqTmp)->C5_XPEDOLD
	cChavCli 	:= (_cArqTmp)->C6_NUM

	aAdd ( _aCabPd , { "C5_CLIENTE" , (_cArqTmp)->C5_CLIENTE					, NIL} )			
	aAdd ( _aCabPd , { "C5_LOJACLI" , (_cArqTmp)->C5_LOJACLI		   			, NIL} )		
	aAdd ( _aCabPd , { "C5_TIPO"    , "N"       					   			, NIL} )
	aAdd ( _aCabPd , { "C5_CONDPAG"	, "001"										, NIL} )
	aAdd ( _aCabPd , { "C5_EMISSAO"	, DDataBase	  					 			, NIL} )
	aAdd ( _aCabPd , { "C5_TIPLIB" 	, "1"										, NIL} )
	aAdd ( _aCabPd , { "C5_XPEDWEB" , _cPedWeb									, NIL} )
	aAdd ( _aCabPd , { "C5_XPEDOLD"	, _cPedOld									, NIL} )			
	aAdd ( _aCabPd , { "C5_MENNOTA" , "Faturamento Gerencial Curso Forum"		, NIL} )
	
	//���������������������������������������������Ŀ
	//�Alimentando informacoes pertinente ao produto�
	//�����������������������������������������������
	
	While (_cArqTmp)->(!EOF()) .AND. cChavCli == (_cArqTmp)->C6_NUM
					
		_cDescPd  := AllTrim((_cArqTmp)->C6_DESCRI)
		_cLocB1   := (_cArqTmp)->C6_LOCAL
		_cProduto := (_cArqTmp)->C6_PRODUTO			
				
		//��������������������������������
		//�Alimentando os Itens do pedido�              
		//��������������������������������
		_alinha	:= {}
		aAdd ( _alinha , { "C6_ITEM"    , _cCont						, NIL} )
		aAdd ( _alinha , { "C6_PRODUTO" , _cProduto						, NIL} )
		aAdd ( _alinha , { "C6_DESCRI"  , _cDescPd  					, NIL} )					
		aAdd ( _alinha , { "C6_QTDVEN"  , (_cArqTmp)->C6_QTDVEN   		, NIL} )
		aAdd ( _alinha , { "C6_QTDLIB"  , (_cArqTmp)->C6_QTDVEN   		, NIL} )										

		SB1->(DbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+_cProduto))
		
		//��������������������������������������������������������������������������Ŀ
		//� Posiciona no cadastro de Tabela de Precos                                �
		//����������������������������������������������������������������������������				
		DA1->( DbSetOrder(1) )
		DA1->(dbSeek(xFilial("DA1")+_cTabela+_cProduto))					
		
		aAdd ( _alinha , { "C6_PRUNIT"	, DA1->DA1_PRCVEN   			, NIL} )
		
		nDesc		:= nPercDA //POSICIONE("SZ2",1,XFILIAL("SZ2")+SA1->A1_XTPDES+SB1->B1_GRUPO,"Z2_PERCDES")									
		nValtot		:= Round((DA1->DA1_PRCVEN*(_cArqTmp)->C6_QTDVEN)-(DA1->DA1_PRCVEN*nDesc)*(_cArqTmp)->C6_QTDVEN,2)
		nValDesc	:= Round((DA1->DA1_PRCVEN*(_cArqTmp)->C6_QTDVEN)-nValtot,2)
		nValPrc		:= nValtot/(_cArqTmp)->C6_QTDVEN
		
		aAdd ( _alinha , { "C6_PRCVEN"  , nValPrc				   		, NIL} )
		aAdd ( _alinha , { "C6_VALOR"   , nValtot    					, NIL} )
		aAdd ( _alinha , { "C6_DESCONT" , nDesc					    	, NIL} )
		aAdd ( _alinha , { "C6_VALDESC" , nValDesc				    	, NIL} )										
		aAdd ( _alinha , { "C6_TES"     , _cTes				      		, NIL} )					
		aAdd ( _alinha , { "C6_LOCAL"   ,  _cLocB1   					, NIL} )
		aAdd ( _alinha , { "C6_ENTREG"  , DDataBase						, NIL} )
		aAdd ( _alinha , { "C6_XPEDWEB" , _cPedWeb						, NIL} )
		aAdd ( _alinha , { "C6_XCURSO"	, (_cArqTmp)->C6_XCURSO			, NIL} )
															
		aAdd(_aItmPd , _alinha)			
		_cCont 	:= soma1(_cCont)
		
		(_cArqTmp)->(DbSkip())
		
		IF (_cArqTmp)->(!EOF()) .OR. cChavCli <> (_cArqTmp)->C6_NUM
			If Len(_aItmPd) > 0					
				GENI066B(_aCabPd,_aItmPd,_cPedOld,_cTipo,_cPedWeb,_cMailPdForum)
			Else
				_cMsg := "Erro ao preencher o array de itens do pedido, 'Pedido Web' "+_cPedWeb+" este pedido n�o foi emitido no Protheus!"
				MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + ".txt" , _cMsg )					
			EndIf	
		ENDIF
	EndDo

	_cMsg := Space(0)
Enddo

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

BeginSql Alias _cArqTmp
	SELECT *
	FROM %Table:SC6% DA
	WHERE DA.C6_FILIAL = %xFilial:SC6%
	AND DA.C6_XPEDWEB <> ' '
	AND DA.C6_XCURSO <> ' '
	AND DA.C6_TES = %Exp:_cTes%
	AND DA.C6_NOTA = ' '
EndSql

IF (_cArqTmp)->(!EOF())
	_cMsg := "Foram indetificados pedidos de oferta curso forum para calculo de DA que n�o geraram nota fiscal"+Chr(13)+Chr(10)
	While (_cArqTmp)->(!EOF())
		_cMsg += "Pedido: "+(_cArqTmp)->C6_XPEDWEB+", Curso: "+(_cArqTmp)->C6_XCURSO+Chr(13)+Chr(10)
		(_cArqTmp)->(DbSkip())
	EndDo
ENDIF

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

Return()

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENI066B  �Autor  �Saturnino - Loop    � Data �  07/06/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina respons�vel pela execu��o do execauto de pedido de   ���
���          �vendas			                                          ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function GENI066B(_aCabPd,_aItmPd,_cPedOld,_cTipo,_cPedWeb,_cMailPdForum)

Local _aAcabC5			:= {}
Local _aPVlNFs			:= {}
Local _cMvSeri 			:= Getmv("GEN_FAT225",.f.,"1")
Local _ni				:= 0
Local nSC5				:= 0
Local aBloqueio			:= {}
Local nArredPrcLis	:= 3
Local aNotas		:= {}
Local aNotaFeita	:= {}
Local lMostraCtb	:= .F.
Local lAglutCtb		:= .F.
Local lCtbOnLine	:= .F.
Local lCtbCusto		:= .F.
Local lReajuste		:= .F.
Local lAtuSA7		:= .F.
Local nX			:= 0
Local nCalAcrs		:= 0.00
Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.
Private _aErro			:= {}
Private _cErroLg		:= "" //Vari�vel onde � armazenado o log quer ser� impresso em um arquivo

//�������������������������������������������������������Ŀ
//�Ordenando o vetor conforme estrutura da SX3, pois      �
//�alguns execauto`s realizam validacoes de gatilhos      �
//�o que pode acabar matando uma informacaao obrigatoria  �
//�que ja havia sido enviada corretamente no array        �
//���������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC5")                                 
aSC5SX3 := FWSX3Util():GetAllFields( "SC5", .F. )
//While !EOF() .And. (SX3->X3_ARQUIVO == "SC5")
For nSC5 := 1 To Len(aSC5SX3)
	For _ni := 1 To Len(_aCabPd)
		If AllTrim(aSC5SX3[nSC5]) == Alltrim(_aCabPd[_ni][1])
			aAdd(_aAcabC5,_aCabPd[_ni])
			Exit
		EndIf
	Next _ni
//	dbSelectArea("SX3")
//	dbSkip()
//EndDo
Next nSC5
	
Conout("GENI066B - Execauto de Pedido de Vendas")

//������������������������������������������������Ŀ
//�Inicio a grava��o (Execauto) do pedido de vendas�
//��������������������������������������������������

DbSelectArea("SC5")
DbSelectArea("SC6")
DbSelectArea("SB1")

lMsErroAuto := .F.
_cPedExc := ""
MSExecAuto({|x,y,z| mata410(x,y,z)},_aAcabC5,_aItmPd,3)
_cPedExc := SC5->C5_NUM

If !lMsErroAuto
	
	Ma410LbNfs( 2, , ) // Liberacao de pedido
	
	lLibOk  := Ma410LbNfs( 1, @_aPVlNFs, @aBloqueio) // Checa itens liberados
	// Caso tenha itens liberados manda faturar
	If !Empty(aBloqueio) .OR. Empty(_aPVlNFs)
		_cErroLg := "Falha ao gerar nota fiscal. Pedido com bloqueio. Pedido Protheus: " + SC5->C5_NUM
	EndIf

	If Empty(_cErroLg)			

		nItemNf  := a460NumIt(_cMvSeri)
		aadd(aNotas,{})
		
		// Efetua as quebras de acordo com o numero de itens
		For nX := 1 To Len(_aPVlNFs)
			If Len(aNotas[Len(aNotas)])>=nItemNf
				aadd(aNotas,{})
			EndIf
			aadd(aNotas[Len(aNotas)],aClone(_aPVlNFs[nX]))
		Next nX

		// Gera as notas de acordo com a quebra
		For nX := 1 To Len(aNotas)
			_cNotaImp := MaPvlNfs(aNotas[nX],_cMvSeri,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajuste,nCalAcrs,nArredPrcLis,lAtuSA7)
			IF !Empty(_cNotaImp)
				AADD(aNotaFeita,_cNotaImp)
			ENDIF
		Next nX

		MsUnlockAll()		
		DbCommitAll()

		If Len(aNotaFeita) == 0
			_cErroLg := "Falha ao gerar nota fiscal. Pedido Protheus: " + SC5->C5_NUM
			MemoWrite ( _cLogPd + DtoS(DDataBase) +"\" + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_" + SC5->C5_NUM+".txt" , _cErroLg )		
			cMsg := SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_" + SC5->C5_NUM + cEnt + _cErroLg		
			U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("GENI066 - Protheus Faturamento - Importa��o Pedido Forum"),cMsg,,,.F.)										
		EndIf
	EndIf			  
				
Else

	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + Chr(13)+Chr(10)
	Next _ni
	
	MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + ".txt" , _cErroLg )
	Disarmtransaction()	
	
	U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("Protheus Faturamento - Importa��o Pedido Forum"),_cErroLg,,,.F.)	
EndIf

//�����������������������������������Ŀ
//�Caso tenha dado erro ir� gerar log �
//�������������������������������������
If lMsErroAuto
	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + Chr(13)+Chr(10)
	Next _ni
	
	MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) +"_"+ ".txt" , _cErroLg )
	Disarmtransaction()
EndIf

Return()