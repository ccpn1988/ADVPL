#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#DEFINE cEnt Chr(13)+Chr(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENI067   �Autor  �Cleuto Lima         � Data �  19/06/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera Pedidos entrega Brinde Curso Forum                     ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENI067()

Local _aArea := GetArea()
Private lDigital := .F.
Private lGeraNF := .T. //PARAMETRO PARA INDICAR SE DEVE GERAR A NOTA (.T.) OU SOMENTE O PEDIDO (.F.)

Conout("GENI067 - Inicio da importa��o de pedido de vendas")

//�������������������������������������������������������������������Ŀ
//�Verifica��o para saber se a rotina esta sendo chamada pela Schedule�
//���������������������������������������������������������������������
Prepare Environment Empresa "00" Filial "1022"

If upper(alltrim(GetEnvServer())) $ "SCHEDULE-PRE" //EXECUTA SOMENTE NO AMBIENTE SCHEDULE
	
	If LockByName("GENI067",.T.,.T.,.T.)
		GENI067A()
		UnLockByName("GENI067",.T.,.T.,.T.)		
	Else
		Conout("GENI067 - n�o foi poss�vel iniciar a rotina pois a mesma j� est� sendo executada!")
	EndIf	
Endif

Reset Environment

RestArea(_aArea)

Return()


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENI067A  �Autor  �Angelo Henrique     � Data �  11/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para o processamento da integra��o do pedido de venda���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GENI067A()

Local _aArea 		:= GetArea()
Local _aClient		:= {} //Vetor para alimentar informa��es do cliente caso o mesmo n�o esteja cadastrado
Local _cArqAli		:= GetNextAlias()
Local _cCdMun 		:= ""
Local _cIncsr		:= ""
Local _cTpCli		:= ""
Local _cMsblq		:= ""
Local _cCep			:= ""
Local _cMunic		:= ""
Local _cRPIS		:= ""
Local _cRCSLL		:= ""
Local _cRCOFI		:= ""
Local _cRISS		:= ""
Local _cCGC			:= ""
Local _cCodPs		:= ""
Local _cEndNm		:= ""
Local _cLoja		:= "01"
Local _cCod			:= ""
Local _nLoja 		:= 0
Local _cVend		:= ""
Local _cTpDes		:= ""
Local _cDescPd		:= ""
Local _nItemC6  	:= 1 //Contador para os itens do pedido de vendas
// Local _cQryIns		:= ""
Local _cLocB1		:= ""
Local _nQtdTot 		:= 0
Local _nValTot 		:= 0
Local _cMsg			:= ""
Local _cTransp		:= ""
Local _aDir			:= {}
Local _cCont 		:= "01"
Local _cFretePd		:= GetNextAlias()
Local _cArqPd		:= GetNextAlias()
Local _cArqPro		:= GetNextAlias()
Local _cNome		:= ""
Local _nDIGITAL		:= nil
Local lEntrega		:= .F.
Local aUpdFlag		:= {}
Local _nI           := 0
Local _nTotParc     := 0
Local _cMailPdForum	:= GetMv("GEN_FAT153")
Local _aParcItem	:= {}
// Local cFORMAPG		:= ""
// Local cProd1Cent	:= GetMv("GEN_FAT152")
Local _cTabela		:= GetMv("GEN_FAT064")
Local _cTransp		:= GetMv("GEN_FAT155")
Local cCodCli		:= GetMv("GEN_FAT158")
Local cLojaCli		:= ""
// Local _cTes			:= GetMv("GEN_FAT161") -- descontinuada
Private _cQuery		:= ""
Private _cArqTmp	:= GetNextAlias()
Private _oServer	:= Nil
Private _cFilCont	:= ""
Private _cView		:= "" //Par�metro que cont�m o nome da view que ser� consultada para a cria��o do Pedido de Vendas
Private _cLogPd		:= "" //Par�metro que cont�m o caminho onde ser� gravado o arquivo de log de inconsist�ncias
Private _aCabPd 	:= {}
Private _aItmPd 	:= {}
Private _alinha		:= {}
Private	_cLogPd		:= SUPERGETMV("GEN_FAT154",.T.,"\logsiga\ped_forum\")+"gen_to_cliente\"
Private cNatCart	:= GetMv("GENI018CAR") //NATUREZA PARA CARTAO DE CREDITO
Private cNatBol		:= GetMv("GENI018BOL") //NATUREZA PARA BOLETO
WFForceDir(_cLogPd)
cLojaCli	:= Substr(cCodCli,At("/",cCodCli)+1,2)
cCodCli		:= Substr(cCodCli,1,At("/",cCodCli)-1)

_cView	:= "DBA_EGK.TT_I67_PED_ENTREGA_FORUM"
_lVwWeb := .T. //variavel do legado

//�������������������������Ŀ
//�Executar limpeza dos logs�
//���������������������������
_aDir:=directory(Alltrim(_cLogPd)+"*")

For _ni:= 1 to Len(_aDir)
	fErase(Alltrim(_cLogPd)+_aDir[_ni][1])
Next _ni

//��������������������������������������������������������������������Ŀ          
//�Conforme levantado ser� criado uma view disponibilizada no protheus �
//�que ir� conter todos os pedidos que dever�o ser importados          �
//����������������������������������������������������������������������
//_cQuery := " SELECT * FROM TT_I29A_PEDIDOS_SATELITES" //+ _cView
_cQuery := "SELECT * FROM "+_cView
//_cQuery += " WHERE C5_XPEDOLD = '23991'"

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqTmp, .F., .T.)

_nCtVi := 0
cRisc66	:= GetMv("GEN_FAT066")
cCond65	:= GetMv("GEN_FAT065")
While (_cArqTmp)->(!EOF())
	
	cChavCli	:= alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))+" "+alltrim((_cArqTmp)->SKU_CURSO)
						
	Do While cChavCli = alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))+" "+alltrim((_cArqTmp)->SKU_CURSO)
		
		//��������������������������������������������������������������Ŀ
		//�Valida��o da Trasnportadora, para n�o realizar o processamento�
		//����������������������������������������������������������������
		_cTipo   := IIF(ValType((_cArqTmp)->C5_TIPO) == "N",cValtochar((_cArqTmp)->C5_TIPO),(_cArqTmp)->C5_TIPO)
		_cPedWeb := IIF(ValType((_cArqTmp)->C5_XPEDWEB) == "N",alltrim(str((_cArqTmp)->C5_XPEDWEB)),(_cArqTmp)->C5_XPEDWEB)
		_cPedOld := IIF(ValType((_cArqTmp)->C5_XPEDOLD) == "N",alltrim(str((_cArqTmp)->C5_XPEDOLD)),(_cArqTmp)->C5_XPEDOLD)
	
		If (_cArqTmp)->DIGITAL <> 1
			If !Empty(_cTransp)
				DbSelectArea("SA4")
				DbSetOrder(1)
				If SA4->(DbSeek(xFilial("SA4")+_cTransp))
					If fieldpos("A4_MSBLQL") > 0 .and. SA4->A4_MSBLQL = "1"
						_cMsg := "Transportadora: " + _cTransp + " encontra-se bloqueada, favor verificar."+ Chr(13)+Chr(10)
					ElseIf AllTrim((_cArqTmp)->C5_TPFRETE) == "C" //CIF
						If Empty(SA4->A4_XFORNEC)
							_cMsg := "Transportadora: " + _cTransp + " n�o possui fornecedor cadastrado, favor verificar." + Chr(13)+Chr(10)
							_cMsg += "O tipo do frete � CIF, por isso existe a necessidade de cadastrar o fornecedor."+ Chr(13)+Chr(10)
						EndIf
					EndIf
				Else
					_cMsg := "Transportadora: " + _cTransp + " n�o cadastrada no sistema, favor verificar."+ Chr(13)+Chr(10)
				EndIf
			ElseIf Empty(_cTransp) .And. AllTrim((_cArqTmp)->C5_TPFRETE) == "C"
				_cMsg := "Transportadora em branco, favor cadastrar pois o tipo de frete � CIF, logo, torna-se obrigat�rio o seu cadastro."+ Chr(13)+Chr(10)
			EndIf
		Endif

		lEntrega	:= !Empty((_cArqTmp)->C5_XLOGENT) .OR. !Empty((_cArqTmp)->C5_XCEPENT)
	
		If	lEntrega .AND. (;
			Empty((_cArqTmp)->C5_XSNOENT) .OR. ;
			Empty((_cArqTmp)->C5_XLOGENT) .OR. ;
			Empty((_cArqTmp)->C5_XBAIENT) .OR. ;
			Empty((_cArqTmp)->C5_XPAIENT) .OR. ;
			Empty((_cArqTmp)->C5_XCEPENT) .OR. ;
			Empty((_cArqTmp)->C5_XCIDENT) .OR. ;						
			Empty((_cArqTmp)->C5_XUFENT) )
			
			_cMsg += "Dados de endere�o de entrega invalidos!"+ Chr(13)+Chr(10)

		EndIf
						
		//�����������������������������������������������������������������������������������������������������Ŀ
		//�Valida��o de produto, para n�o realizar o processamento de mais de um item do mesmo produto no pedido�
		//�������������������������������������������������������������������������������������������������������
		If _lVwWeb
			_cPedWeb	:= IIF(ValType((_cArqTmp)->C5_XPEDWEB) == "N",alltrim(str((_cArqTmp)->C5_XPEDWEB)),(_cArqTmp)->C5_XPEDWEB)
			_cProduto	:= alltrim((_cArqTmp)->C6_PRODUTO)

			_cQryPro := "SELECT C5_XPEDWEB, C6_PRODUTO, COUNT(*) ITENS
			_cQryPro += "  FROM " + _cView
			_cQryPro += " WHERE C5_XPEDWEB = '" + _cPedWeb + "'"
			_cQryPro += "   AND C6_PRODUTO = '" + _cProduto + "'"
			_cQryPro += "   AND SKU_CURSO = " + alltrim((_cArqTmp)->SKU_CURSO)
			_cQryPro += " GROUP BY C5_XPEDWEB, C6_PRODUTO
			_cQryPro += " HAVING COUNT(*) > 1

			If Select(_cArqPro) > 0
				dbSelectArea(_cArqPro)
				(_cArqPro)->(dbCloseArea())
			EndIf
			
			dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQryPro), _cArqPro, .F., .T.)
			
			If (_cArqPro)->(!EOF())
				_cMsg += "Pedido com o produto " + ALLTRIM((_cArqPro)->C6_PRODUTO)+" com item duplicado (" + ALLTRIM(STR((_cArqPro)->ITENS)) + " itens)."
			EndIf		    
		EndIf
		
		Conout("GENI067 - Analisando pedido WEB "+_cPedWeb)
		
		If Empty(_cMsg)
			_cCod 		:= ""
			_aClient 	:= {}
			_cCodOld 	:= ""
			
			//-----------------------------------------//
			//Gravando em vari�vel a nova filial logada//
			//-----------------------------------------//
			_cFilCont := AllTrim((_cArqTmp)->C5_FILIAL)
			
			//��������������������������������������������������������������������������������������������������������Ŀ
			//�Processo de montagem do array para o execauto de cliente												   �
			//����������������������������������������������������������������������������������������������������������
			//Conout("GENI067 - Montagem do Vetor de Clientes")
			
			//�����������������������������������������������Ŀ
			//�Ajustes de alguns dados para a inclus�o correta�
			//�������������������������������������������������
			
			_cCdMun := (_cArqTmp)->A1_COD_MUN
			_cCdMun := IIF(Alltrim((_cArqTmp)->A1_EST) == 'EX','99999'			,_cCdMun)
			
			_cCep	:= IIF(Alltrim((_cArqTmp)->A1_EST) == 'EX'  ,'00000000'	,Alltrim((_cArqTmp)->A1_CEP))
			_cCep	:= StrTran(_cCep," ","")
			_cCep	:= StrTran(_cCep,".","")
			_cMunic	:= IIF(Alltrim((_cArqTmp)->A1_EST) == 'EX'  ,'EXTERIOR'	,(_cArqTmp)->A1_MUN)
			_cRPIS	:= IIF(Alltrim((_cArqTmp)->A1_RECPIS) == '' ,'N'		 	,Alltrim((_cArqTmp)->A1_RECPIS))
			_cRCSLL	:= IIF(Alltrim((_cArqTmp)->A1_RECCSLL)== '' ,'N'		 	,Alltrim((_cArqTmp)->A1_RECCSLL))
			_cRCOFI	:= IIF(Alltrim((_cArqTmp)->A1_RECCOFI)== '' ,'N'			,Alltrim((_cArqTmp)->A1_RECCOFI))
			_cRISS	:= IIF(Alltrim((_cArqTmp)->A1_RECISS) == '' ,'2'			,Alltrim((_cArqTmp)->A1_RECISS))
			_cIncsr := IIF(!EMPTY(AllTrim((_cArqTmp)->A1_INSCR)),AllTrim((_cArqTmp)->A1_INSCR),"ISENTO")
			_cTpCli := STRZERO((_cArqTmp)->A1_XTIPCLI,3)
			_cMsblq := (_cArqTmp)->A1_MSBLQL
			_cCGC 	:= IIF((_cArqTmp)->A1_EST='EX'	,' ',(_cArqTmp)->A1_CGC	)
			_cCodPs := STRZERO((_cArqTmp)->A1_CODPAIS,TAMSX3("A1_CODPAIS")[1])
			_cEndNm := IIF(Empty((_cArqTmp)->A1_XENDNUM),"0",AllTrim((_cArqTmp)->A1_XENDNUM))
			_cVend	:= IIF(ValType((_cArqTmp)->A1_VEND)=="C" ,STRZERO(Val((_cArqTmp)->A1_VEND),TAMSX3("A1_VEND")[1]),STRZERO((_cArqTmp)->A1_VEND,TAMSX3("A1_VEND")[1]))
			_cTpDes	:= IIF(ValType((_cArqTmp)->A1_VEND)=="C" ,(_cArqTmp)->A1_XTPDES,cValToChar((_cArqTmp)->A1_XTPDES))
			
			//����������������������������������������������������Ŀ
			//�Cleuto Lima - 22/06/2016                            �
			//�                                                    �
			//�incluido para validar o nome do cliente quando mesmo�
			//�n�o tem CGC                                         �
			//������������������������������������������������������
			_cNome		:= upper(AllTrim((_cArqTmp)->A1_NOME))
			_nDIGITAL	:= (_cArqTmp)->DIGITAL
			//��������������������������������������������������������������������Ŀ
			//�	VERIFICA SE JA EXISTE O CLIENTE COM MESMA RAIZ DE CNPJ CADASTRADO  �
			//����������������������������������������������������������������������
			
			//VALIDA SE O CNPJ NAO ESTA PREENCHIDO COM '0' (ZERO)
			If SUBSTR(_cCGC,1,8) <> '00000000' .AND. !Empty(_cCGC)
				//Conout("GENI067 - Entrou na valida��o de CNPJ preenchido com ZERO")
				_cQuery := "SELECT A1_COD, MAX(A1_LOJA) NLOJA FROM "+ RetSqlName("SA1")
				_cQuery += " WHERE SUBSTR(A1_CGC,1,8) = SUBSTR('"+_cCGC+"',1,8) "
				_cQuery += " GROUP BY A1_COD "
				//_cQuery := ChangeQuery(_cQuery)
				
				If Select(_cArqAli) > 0
					dbSelectArea(_cArqAli)
					(_cArqAli)->(dbCloseArea())
				EndIf
				
				DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cArqAli, .F., .T.)
				dbSelectArea(_cArqAli)
				
				//SE HOUVER CLIENTE CADASTRADO ELE ADICIONA LOJA
				If (_cArqAli)->(EOF())
					//Conout("GENI067 - Entrou na valida��o de adi��o de loja")
					DbSelectArea("SA1")
					DbSetOrder(3)
					If DbSeek(xFilial("SA1") + _cCGC )
						_cCod	:= (_cArqAli)->A1_COD
						_nLoja 	:= SOMA1((_cArqAli)->NLOJA)
						_cLoja	:= PADL(_nLoja,2,"0")
					EndIf
				EndIf
				If Select(_cArqAli) > 0
					dbSelectArea(_cArqAli)
					(_cArqAli)->(dbCloseArea())
				EndIf
			EndIf
			
			_cBairro	:= alltrim((_cArqTmp)->A1_BAIRRO)
			_cEst		:= AllTrim((_cArqTmp)->A1_EST)
			_cEstado	:= allTrim((_cArqTmp)->A1_ESTADO)
			
			If len(alltrim(_cCep)) = 8 .and. _cEst <> 'EX'
				
				IF Empty(_cEst) .OR. Empty(_cCdMun) .OR. !ExistCpo("CC2",_cEst+_cCdMun)
					IF !U_GENA095C(_cCep,@_cEst,@_cEstado,@_cCdMun,@_cMunic,,@_cBairro)
						_cMsg := "Dados de endere�o invalido: "+Chr(13)+Chr(10)
						_cMsg += "cod.Mun.: "+_cCdMun+Chr(13)+Chr(10)
						_cMsg += "Cep: "+Alltrim((_cArqTmp)->A1_CEP)+Chr(13)+Chr(10)
						_cMsg += "Municio: "+(_cArqTmp)->A1_MUN+Chr(13)+Chr(10)

						MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + ".txt" , _cMsg )
						(_cArqTmp)->(DbSkip())
						Loop
					EndIf
				EndIF

				_cQry := "SELECT CL.DS_LOGRADOURO_NOME,
				_cQry += " CB.DS_BAIRRO_NOME,
				_cQry += " CD.DS_CIDADE_NOME,
				_cQry += " CU.DS_UF_SIGLA,
				_cQry += " CU.DS_UF_NOME,
				_cQry += " SUBSTR(TO_CHAR(M.CODIGOMUNICIPIO),3,5) CODMUN,
				_cQry += " M.UF
				_cQry += " FROM CEP_LOGRADOUROS CL
				_cQry += " JOIN CEP_BAIRROS CB ON CL.CD_BAIRRO = CB.CD_BAIRRO
				_cQry += " JOIN CEP_CIDADES CD ON CB.CD_CIDADE = CD.CD_CIDADE
				_cQry += " JOIN CEP_UF CU ON CD.CD_UF = CU.CD_UF
				If _cEst = "DF"
					_cQry += " LEFT JOIN (SELECT * FROM MUNICIPIO_IBGE M JOIN UF_IBGE U ON M.CODIGOUF = U.CODIGOUF) M ON CU.DS_UF_SIGLA = M.UF
				Else
					_cQry += " LEFT JOIN (SELECT * FROM MUNICIPIO_IBGE M JOIN UF_IBGE U ON M.CODIGOUF = U.CODIGOUF) M ON UPPER(TRIM(CD.DS_CIDADE_NOME)) = UPPER(TRIM(M.DESCRICAO)) AND CU.DS_UF_SIGLA = M.UF
				Endif
				_cQry += " WHERE NO_LOGRADOURO_CEP = '"+_cCep+"'
				If Select(_cArqAli) > 0
					dbSelectArea(_cArqAli)
					(_cArqAli)->(dbCloseArea())
				EndIf
				DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQry), _cArqAli, .F., .T.)
				
				If !(_cArqAli)->(EOF())
					If Empty(_cBairro)
						_cBairro := alltrim((_cArqAli)->DS_BAIRRO_NOME)
					Endif
					If Empty(_cEst) .OR. _cEst = "N/A"
						_cEst := alltrim((_cArqAli)->DS_UF_SIGLA)
						_cEstado := alltrim((_cArqAli)->DS_UF_NOME)
					Endif
					If !Empty((_cArqAli)->CODMUN) .and. _cCdMun <> (_cArqAli)->CODMUN
						_cCdMun := (_cArqAli)->CODMUN
					Endif
				Endif
			Endif
						
			_cEstado	:= AllTrim(Posicione("SX5",1,xFilial("SX5")+"12"+_cEst,"X5_DESCRI"))
			//������������������������������������������������������������������Ŀ
			//�Grava��o das Informa��es no Array que ser� enviado para o Execauto�
			//��������������������������������������������������������������������
			_aClient := {}
			If !Empty(_cCod)
				//Conout("GENI067 - Colocando o c�digo do cliente")
				aAdd(_aClient,{"A1_COD"	,	_cCod													,Nil})
				aAdd(_aClient,{"A1_LOJA",	_cLoja													,Nil})
			EndIf
			//Conout("GENI067 - Alimentando vetor Cliente")
			If !Empty((_cArqTmp)->A1_XCODOLD)
				aAdd(_aClient,{"A1_XCODOLD"	,	alltrim(str((_cArqTmp)->A1_XCODOLD))				,Nil})
			Endif
			aAdd(_aClient,{"A1_NOME"	,	upper(AllTrim((_cArqTmp)->A1_NOME))						,Nil})
			aAdd(_aClient,{"A1_PESSOA"	,	AllTrim((_cArqTmp)->A1_PESSOA)							,Nil})
			aAdd(_aClient,{"A1_NREDUZ"	,	AllTrim((_cArqTmp)->A1_NREDUZ)							,Nil})
			aAdd(_aClient,{"A1_CEP"		,	_cCep													,Nil})
			aAdd(_aClient,{"A1_END"		,	(_cArqTmp)->A1_END										,Nil})
			aAdd(_aClient,{"A1_XENDNUM"	,	_cEndNm													,Nil}) //Numero do endereco
			aAdd(_aClient,{"A1_COMPLEM"	,	(_cArqTmp)->A1_COMPLEMEN								,Nil})
			aAdd(_aClient,{"A1_BAIRRO"	,	(_cArqTmp)->A1_BAIRRO									,Nil})
			aAdd(_aClient,{"A1_EST"		,	_cEst													,Nil})
			aAdd(_aClient,{"A1_ESTADO"	,	AllTrim((_cArqTmp)->A1_ESTADO)							,Nil})
			aAdd(_aClient,{"A1_COD_MUN"	,	_cCdMun													,Nil})
			aAdd(_aClient,{"A1_MUN"		,	AllTrim(_cMunic)										,Nil})
			aAdd(_aClient,{"A1_DDD"		,	(_cArqTmp)->A1_DDD										,Nil})
			aAdd(_aClient,{"A1_DDI"		,	(_cArqTmp)->A1_DDI										,Nil})
			aAdd(_aClient,{"A1_TEL"		,	(_cArqTmp)->A1_TEL										,Nil})
			aAdd(_aClient,{"A1_FAX"		,	(_cArqTmp)->A1_FAX										,Nil})
			aAdd(_aClient,{"A1_TIPO"	,	(_cArqTmp)->A1_TIPO										,Nil})
			aAdd(_aClient,{"A1_PAIS"	,	(_cArqTmp)->A1_PAIS										,Nil})
			aAdd(_aClient,{"A1_PAISDES"	,	AllTrim((_cArqTmp)->A1_PAISDES)							,Nil})
			aAdd(_aClient,{"A1_CODPAIS"	,	_cCodPs													,Nil})
			aAdd(_aClient,{"A1_CGC"		,	_cCGC													,Nil})
			aAdd(_aClient,{"A1_ENDCOB"	,	AllTrim((_cArqTmp)->A1_ENDCOB)							,Nil})
			aAdd(_aClient,{"A1_CONTATO"	,	(_cArqTmp)->A1_CONTATO									,Nil})
			aAdd(_aClient,{"A1_ENDENT"	,	AllTrim((_cArqTmp)->A1_ENDENT)							,Nil})
			aAdd(_aClient,{"A1_INSCRM"	,	(_cArqTmp)->A1_INSCRM									,Nil})
			aAdd(_aClient,{"A1_INSCR"	,	_cIncsr													,Nil})
			aAdd(_aClient,{"A1_TPESSOA"	,	AllTrim((_cArqTmp)->A1_TPESSOA)							,Nil})
			aAdd(_aClient,{"A1_EMAIL"	,	AllTrim((_cArqTmp)->A1_EMAIL)							,Nil})
			aAdd(_aClient,{"A1_MSBLQL"	,	_cMsblq													,Nil})
			aAdd(_aClient,{"A1_CONTA"	,	AllTrim((_cArqTmp)->A1_CONTA)							,Nil})
			aAdd(_aClient,{"A1_RECPIS"	,	IIF(ValType(_cRPIS)=="C" ,_cRPIS,cValToChar(_cRPIS))	,Nil})
			aAdd(_aClient,{"A1_RECCSLL"	,	IIF(ValType(_cRCSLL)=="C",_cRCSLL,cValToChar(_cRCSLL))	,Nil})
			aAdd(_aClient,{"A1_RECCOFI"	,	IIF(ValType(_cRCOFI)=="C",_cRCOFI,cValToChar(_cRCOFI))	,Nil})
			aAdd(_aClient,{"A1_RECISS"	,	IIF(ValType(_cRISS)=="C" ,_cRISS,cValToChar(_cRISS))	,Nil})
			aAdd(_aClient,{"A1_XCLIPRE"	,	cValToChar((_cArqTmp)->A1_XCLIPRE)						,Nil}) //Cliente Premium
			aAdd(_aClient,{"A1_XTIPCLI"	,	_cTpCli													,Nil}) //Tipo de Cliente (GEN)
			aAdd(_aClient,{"A1_XCANALV"	,	(_cArqTmp)->A1_XCANALV									,Nil}) //Canal de Venda
			aAdd(_aClient,{"A1_VEND"	,	_cVend													,Nil})
			aAdd(_aClient,{"A1_XTPDES"	,	_cTpDes													,Nil}) //Tipo desconto
			aAdd(_aClient,{"A1_TRANSP"	,	STRZERO((_cArqTmp)->A1_TRANSP,6)						,Nil})
			aAdd(_aClient,{"A1_XCONDPG"	,	STRZERO((_cArqTmp)->A1_XCONDPG,TAMSX3("A1_XCONDPG")[1]),Nil}) //Condicao Pagto (GEN)
			aAdd(_aClient,{"A1_COND"	,	cCond65													,Nil})
			aAdd(_aClient,{"A1_TABELA"	,	_cTabela	 											,Nil})
			aAdd(_aClient,{"A1_LC"		,	(_cArqTmp)->A1_LC										,Nil}) //Limite de Cr�dito 
			aAdd(_aClient,{"A1_BLEMAIL"	,	(_cArqTmp)->A1_BLEMAIL									,Nil}) //Boleto por Email
			aAdd(_aClient,{"A1_RISCO"	,	cRisc66													,Nil}) //Limite de Cr�dito
			
			_aCabPd  := {}
			_cPedOld := IIF(ValType((_cArqTmp)->C5_XPEDOLD) == "N",alltrim(str((_cArqTmp)->C5_XPEDOLD)),(_cArqTmp)->C5_XPEDOLD)
			_cCodOld := IIF(ValType((_cArqTmp)->A1_XCODOLD) == "N",alltrim(str((_cArqTmp)->A1_XCODOLD)),(_cArqTmp)->A1_XCODOLD)
			_cCodOld := PADR(_cCodOld,TAMSX3("A1_XCODOLD")[1]," ")
			
			//Rodrigo Mour�o - 01/02/2015. Criadas variaveis Tipo e Pedido Web para incluir no nome do arquivo de log.
			_cTipo   := IIF(ValType((_cArqTmp)->C5_TIPO) == "N",alltrim(str((_cArqTmp)->C5_TIPO)),(_cArqTmp)->C5_TIPO)
			_cPedWeb := IIF(ValType((_cArqTmp)->C5_XPEDWEB) == "N",alltrim(str((_cArqTmp)->C5_XPEDWEB)),(_cArqTmp)->C5_XPEDWEB)
			_cFilLog := Alltrim((_cArqTmp)->C5_FILIAL)
			
			If (_cArqTmp)->DIGITAL <> 1
				lDigital := .F.

				_cQry1 := "SELECT C5_XPEDWEB, C5_FRETE
				_cQry1 += " FROM " + RetSqlName("SC5") + " SC5
				_cQry1 += " WHERE D_E_L_E_T_ = ' '
				_cQry1 += " AND C5_XPEDWEB = '"  + _cPedWeb + "'"
				//_cQuery := ChangeQuery(_cQuery)
				
				If Select(_cFretePd) > 0
					dbSelectArea(_cFretePd)
					(_cFretePd)->(dbCloseArea())
				EndIf
				
				dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQry1), _cFretePd, .F., .T.)
				
				If (_cFretePd)->(!EOF()) .and. (_cFretePd)->C5_FRETE <> 0
					aAdd ( _aCabPd , { "C5_FRETE" 	, 0				 						, NIL} )
                Else				
					aAdd ( _aCabPd , { "C5_FRETE" 	, (_cArqTmp)->C5_FRETE 					, NIL} )
				EndIf
			Else
				_cTransp := Space(TamSx3("C5_TRANSP")[1])
				lDigital := .T.
				aAdd ( _aCabPd , { "C5_FRETE" 	, 0				 						, NIL} )
			Endif
			
			aAdd ( _aCabPd , { "C5_TIPO"    , "N"       					   			, NIL} )			
			aAdd ( _aCabPd , { "C5_CONDPAG"	, (_cArqTmp)->C5_CONDPAG   				, NIL} )
			//aAdd ( _aCabPd , { "C5_NATUREZ"	, cNatBol								, NIL} )

			
			// Cleuto - 19/09/2016 - chamado 30800
			//aAdd ( _aCabPd , { "C5_EMISSAO" , STOD((_cArqTmp)->C5_EMISSAO)	   			, NIL} )
			
			//DDataBase	:= STOD((_cArqTmp)->C5_EMISSAO) // APENAS PARA TESTES PARA QUE A DATA DE PAGAMENTO N�O SEJA MENOR QUE A DATABASE DO SISTEMA, DEVE SER REMOVIDO
			
			aAdd ( _aCabPd , { "C5_EMISSAO" , DDataBase	   								, NIL} )			
			aAdd ( _aCabPd , { "C5_XPEDOLD" , _cPedOld 									, NIL} )
			aAdd ( _aCabPd , { "C5_TPFRETE" , (_cArqTmp)->C5_TPFRETE 					, NIL} )
			aAdd ( _aCabPd , { "C5_MOEDA" 	, (_cArqTmp)->C5_MOEDA 						, NIL} )
			aAdd ( _aCabPd , { "C5_PESOL" 	, (_cArqTmp)->C5_PSOL 						, NIL} )
			aAdd ( _aCabPd , { "C5_PBRUTO" 	, (_cArqTmp)->C5_PBRUTO 					, NIL} )
			aAdd ( _aCabPd , { "C5_TIPLIB" 	, (_cArqTmp)->C5_TPLIB						, NIL} )
			aAdd ( _aCabPd , { "C5_XTPREMS" , (_cArqTmp)->C5_XTPREMS					, NIL} )
			aAdd ( _aCabPd , { "C5_MENNOTA" , AllTrim((_cArqTmp)->C5_MENNOTA)			, NIL} )
			
			//����������������������������������������������������������������������������Ŀ
			//�Cleuto - 16/02/2017                                                         �
			//�                                                                            �
			//�removida tabela de pre�o para que sempre seja fatuado com                   �
			//�o valor do pedido retornado pelo Site.                                      �
			//������������������������������������������������������������������������������
			aAdd ( _aCabPd , { "C5_TABELA"  , _cTabela									, NIL} )
			aAdd ( _aCabPd , { "C5_XPEDWEB" , _cPedWeb									, NIL} )
						
			If Empty(AllTrim((_cArqTmp)->C5_XLOGENT)) 
				aAdd ( _aCabPd , { "C5_XSNOENT" , " "									, NIL} )
				aAdd ( _aCabPd , { "C5_XNOMENT" , upper(AllTrim((_cArqTmp)->A1_NOME))	, NIL} )
				aAdd ( _aCabPd , { "C5_XTELENT" , (_cArqTmp)->A1_TEL					, NIL} )
				aAdd ( _aCabPd , { "C5_XDDDENT" , (_cArqTmp)->A1_DDD					, NIL} )
				aAdd ( _aCabPd , { "C5_XCOMENT" , (_cArqTmp)->A1_COMPLEMEN				, NIL} )
				aAdd ( _aCabPd , { "C5_XLOGENT" , (_cArqTmp)->A1_END					, NIL} )
				aAdd ( _aCabPd , { "C5_XCELENT" , " "									, NIL} )
				aAdd ( _aCabPd , { "C5_XDDCENT" , " "									, NIL} )
				aAdd ( _aCabPd , { "C5_XBAIENT" , (_cArqTmp)->A1_BAIRRO				, NIL} )
				aAdd ( _aCabPd , { "C5_XPAIENT" , (_cArqTmp)->A1_PAISDES				, NIL} )
				aAdd ( _aCabPd , { "C5_XCEPENT" , StrTran(_cCep,".","")				, NIL} )
				aAdd ( _aCabPd , { "C5_XMUNENT" , _cCdMun								, NIL} )
				aAdd ( _aCabPd , { "C5_XCIDENT" , AllTrim(_cMunic)						, NIL} )
				aAdd ( _aCabPd , { "C5_XUFENT"  , AllTrim((_cArqTmp)->A1_EST)			, NIL} )
				aAdd ( _aCabPd , { "C5_XNUMENT" , _cEndNm			   					, NIL} )			
			Else
				aAdd ( _aCabPd , { "C5_XSNOENT" , (_cArqTmp)->C5_XSNOENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XNOMENT" , (_cArqTmp)->C5_XNOMENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XTELENT" , (_cArqTmp)->C5_XTELENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XDDDENT" , (_cArqTmp)->C5_XDDDENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XCOMENT" , (_cArqTmp)->C5_XCOMENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XLOGENT" , (_cArqTmp)->C5_XLOGENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XCELENT" , (_cArqTmp)->C5_XCELENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XDDCENT" , (_cArqTmp)->C5_XDDCENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XBAIENT" , (_cArqTmp)->C5_XBAIENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XPAIENT" , (_cArqTmp)->C5_XPAIENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XCEPENT" , StrTran((_cArqTmp)->C5_XCEPENT,".",""), NIL} )
				aAdd ( _aCabPd , { "C5_XMUNENT" , (_cArqTmp)->C5_XMUNENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XCIDENT" , (_cArqTmp)->C5_XCIDENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XUFENT"  , (_cArqTmp)->C5_XUFENT				, NIL} )
				aAdd ( _aCabPd , { "C5_XNUMENT" , (_cArqTmp)->C5_XNUMENT				, NIL} )
    		EndIf
					
			//If !Empty(_cTransp)
			aAdd ( _aCabPd , { "C5_TRANSP"  , _cTransp									, NIL} )
			//EndIf
			
			//���������������������������������������������Ŀ
			//�Alimentando informa��es pertinente ao produto�
			//�����������������������������������������������
			
			_nItemC6	:= 1 
			_aItmPd		:= {}
			aUpdFlag	:= {}
			//Zerando as Vari�veis
			_nTotParc := 0
			
			//Conout("GENI067 - Montagem do Vetor de Pedido de Vendas - Item")
			
			_cCont 		:= "01"
			While (_cArqTmp)->(!EOF()) .And. _cPedOld == AllTrim(Str((_cArqTmp)->C5_XPEDOLD)) .and. _cCont <= "99";
				.and. cChavCli = alltrim(str((_cArqTmp)->C5_XPEDOLD))+" "+alltrim(str((_cArqTmp)->DIGITAL))+" "+alltrim((_cArqTmp)->SKU_CURSO)
				
				_alinha  := {}
				//Conout("GENI067 - Entrou no While do item pedido de vendas ")
				_cDescPd  := Posicione("SB1",1,xFilial("SB1") + (_cArqTmp)->C6_PRODUTO,"B1_DESC")
				_cLocB1   := IIF(Empty(AllTrim((_cArqTmp)->C6_LOCAL)),Posicione("SB1",1,xFilial("SB1") + (_cArqTmp)->C6_PRODUTO,"B1_LOCPAD"),(_cArqTmp)->C6_LOCAL)
				_cProduto := padr(alltrim((_cArqTmp)->C6_PRODUTO),tamsx3("C6_PRODUTO")[1])

				SB1->(DbSetOrder(1))
				IF !SB1->(dbSeek(xFilial("SB1")+_cProduto))
					_cMsg += "Produto " +_cProduto+" n�o localizado na tabela SB1"+ Chr(13)+Chr(10)
					(_cArqTmp)->(DbSkip())
					Loop
				EndIF
				
				//��������������������������������������������������������������������������Ŀ
				//� Posiciona no cadastro de Tabela de Precos                                �
				//����������������������������������������������������������������������������				
				DA1->( DbSetOrder(1) )
				If !DA1->(dbSeek(xFilial("DA1")+_cTabela+_cProduto))
					_cMsg += "Produto " +_cProduto+" n�o localizado na tabela de pre�o "+_cTabela+ Chr(13)+Chr(10)
					(_cArqTmp)->(DbSkip())
					Loop
				EndIF
																	
                // 25/069/2015 - Helimar Tavares - inclusao de critica pedidoweb + produto
				//�������������������������������������������������������������������������������������������������������Ŀ
				//�S� ir� incluir os pedidos que n�o forem encontrados no protheus prevenindo assim algum problema na View�
				//�Conforme solicitado ser� alimentado a FLAG VIEW dos pedidos
				//���������������������������������������������������������������������������������������������������������
				_cQuery := "SELECT C6_XPEDWEB, C6_PRODUTO
				_cQuery += " FROM " + RetSqlName("SC6") + " SC6
				_cQuery += " JOIN " + RetSqlName("SC5") + " SC5
				_cQuery += " ON C5_FILIAL = C6_FILIAL
				_cQuery += " AND C6_NUM = C5_NUM
				_cQuery += " AND SC6.D_E_L_E_T_ <> '*'
				_cQuery += " WHERE SC5.D_E_L_E_T_ = ' '
				// _cQuery += " AND C5_CLIENTE <> '" + cCodCli + "'"
				_cQuery += " AND C5_XPEDWEB = '"  + _cPedWeb  + "'"
				_cQuery += " AND C5_XPEDOLD = '"  + _cPedOld  + "'"
				_cQuery += " AND C6_XPEDWEB = '"  + _cPedWeb  + "'"
				_cQuery += " AND C6_PRODUTO = '"  + _cProduto + "'"
				_cQuery += " AND C6_XCURSO = '"  + PadR(Alltrim((_cArqTmp)->SKU_CURSO),TamSX3("C6_XCURSO")[1]) + "'"
				
				If Select(_cArqPd) > 0
					dbSelectArea(_cArqPd)
					(_cArqPd)->(dbCloseArea())
				EndIf

				dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqPd, .F., .T.)

				If ((_cArqPd)->(EOF()) .and. _lVwWeb) .or. !_lVwWeb    
											
					//��������������������������������
					//�Alimentando os Itens do pedido�              
					//��������������������������������
                    
					aAdd ( _alinha , { "C6_ITEM"    , _cCont						, NIL} )
					aAdd ( _alinha , { "C6_PRODUTO" , _cProduto						, NIL} )
					aAdd ( _alinha , { "C6_DESCRI"  , _cDescPd  					, NIL} )					
					aAdd ( _alinha , { "C6_QTDVEN"  , (_cArqTmp)->C6_QTDVEN   		, NIL} )
					aAdd ( _alinha , { "C6_QTDLIB"  , (_cArqTmp)->C6_QTDVEN   		, NIL} )																				
					aAdd ( _alinha , { "C6_PRUNIT"	, DA1->DA1_PRCVEN   			, NIL} )
					
					aAreaSA1	:= SA1->(GetArea())

					/*  99% DE DESCONTO FOI DEFINIDO PELA DIRETORIA */	
					nDesc		:= 99//POSICIONE("SZ2",1,XFILIAL("SZ2")+Posicione("SA1",1,xFilial("SA1")+cCodCli+cLojaCli,"A1_XTPDES")+SB1->B1_GRUPO,"Z2_PERCDES")									
					nValtot		:= Round((DA1->DA1_PRCVEN*(_cArqTmp)->C6_QTDVEN)-((DA1->DA1_PRCVEN*nDesc)/100)*(_cArqTmp)->C6_QTDVEN,2)
					nValDesc	:= Round((DA1->DA1_PRCVEN*(_cArqTmp)->C6_QTDVEN)-nValtot,2)
					nValPrc		:= nValtot/(_cArqTmp)->C6_QTDVEN
					
					RestArea(aAreaSA1)
					
					aAdd ( _alinha , { "C6_PRCVEN"  , nValPrc				   			, NIL} )
					aAdd ( _alinha , { "C6_VALOR"   , nValtot    						, NIL} )
					aAdd ( _alinha , { "C6_DESCONT" , nDesc					    		, NIL} )
					aAdd ( _alinha , { "C6_VALDESC" , nValDesc				    		, NIL} )										
					aAdd ( _alinha , { "C6_TES"     , (_cArqTmp)->C6_TES      			, NIL} )					
					aAdd ( _alinha , { "C6_LOCAL"   , _cLocB1			 				, NIL} )
					aAdd ( _alinha , { "C6_ENTREG"  , STOD((_cArqTmp)->C6_ENTREG)		, NIL} )
					aAdd ( _alinha , { "C6_XPEDWEB" , _cPedWeb							, NIL} )
					aAdd ( _alinha , { "C6_XCURSO"	, Alltrim((_cArqTmp)->SKU_CURSO)	, NIL} )
					
					_nValTot += (_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN
					_nTotParc+= ((_cArqTmp)->C6_QTDVEN * (_cArqTmp)->C6_PRCVEN) - (_cArqTmp)->C6_VALDESC
															
					aAdd(_aItmPd , _alinha)
					
					_nQtdTot += (_cArqTmp)->C6_QTDVEN
					_nItemC6 ++										
					_cCont 	:= soma1(_cCont)
					
					Aadd(aUpdFlag, (_cArqTmp)->RECNO )
				ELSE
					_cMsg += "Pedido com o produto " + ALLTRIM(_cProduto)+" com item duplicado (" + ALLTRIM(STR((_cArqPro)->ITENS)) + " itens)."	
				EndIF

				(_cArqTmp)->(DbSkip())
				
			EndDo
			
			//���������������������������������������������������������������������������Ŀ
			//�Alimentando o cabe�alho do Pedido de Vendas com as informa��es customizadas�
			//�����������������������������������������������������������������������������
			aAdd ( _aCabPd , { "C5_XQTDTOT"    , _nQtdTot      	, Nil} )
			aAdd ( _aCabPd , { "C5_XVALTOT"    , _nValTot      	, Nil} )
			//Zerando as Vari�veis
			_nQtdTot := 0
			_nValTot := 0
			
			//������������������������������������������������������������������������Ŀ
			//�Valida��o da Condicao de Pagamento BOLETO OU CARTAO Multiplos/Unico     �
			//��������������������������������������������������������������������������							
			
			If Empty(_cMsg)
				If Len(_aItmPd) > 0
					
					GENI067B(_aClient,_aCabPd,_aItmPd,_cCodOld,_cPedOld,_cCGC,_cTipo,_cPedWeb,_cNome,_nDIGITAL,_aParcItem,aUpdFlag,_cMailPdForum)
					_cCod := ""       				
					
				Else
					
					_cMsg := "Erro ao preencher o array de itens do pedido, 'Pedido Web' "+_cPedWeb+" este pedido n�o foi emitido no Protheus!"
					MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
					(_cArqTmp)->(DbSkip())				
					
				EndIf	
			Else
			    If SubStr(_cMsg,1,1) = 'P'
					MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_PROD_" + AllTrim(_cProduto) +  "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
			    Else
					MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
	    		EndIf
				(_cArqTmp)->(DbSkip())					
			EndIF
		Else
		    If SubStr(_cMsg,1,1) = 'P'
				MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_PROD_" + AllTrim(_cProduto) +  "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
		    Else
				MemoWrite (_cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) + "_" + Iif((_cArqTmp)->DIGITAL=1,"DIG","IMP")+ ".txt" , _cMsg )
    		EndIf
			(_cArqTmp)->(DbSkip())
		EndIf
		_cMsg := Space(0)
	Enddo
EndDo

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENI067B  �Autor  �Angelo Henrique     � Data �  14/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina respons�vel pela execu��o do execauto de clientes    ���
���          �e pedido de vendas                                          ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Rafael Leite - 29/01/2015. Inclusao do parametro _cCGC
//Rodrigo Mour�o - 01/02/2015. Inclusao do tipo e Pedido Web
Static Function GENI067B(_aClient,_aCabPd,_aItmPd,_cCodOld,_cPedOld,_cCGC,_cTipo,_cPedWeb,_cNome,_nDIGITAL,_aParcItem,aUpdFlag,_cMailPdForum)

// Local _aArea 			:= GetArea()
// Local _cArqCli			:= GetNextAlias()
Local _cArqPd			:= GetNextAlias()
Local _cAliSC9 			:= GetNextAlias()
Local _cAliSC6 			:= GetNextAlias()
// Local cQueryINS			:= ""
Local _cQuery			:= ""
Local _aAcabC5			:= {}
// Local _aItmC6			:= {}

Local _aTmpPV1			:= {}
Local _aPVlNFs			:= {}
Local _cMvSeri 			:= Iif(lDigital,"2",Alltrim(GetMv("GEN_FAT003"))) //Iif(lDigital,"2","10") //GetMv("GEN_FAT003") //SERIE nota de sa�da
Local _cNotaImp			:= ""
Local _nPosLb			:= 0
//Local _cCGC := ""		//Rafael Leite - 29/01/2015. Variavel nao pode ser declarada em branco nesse ponto.
// Local _cParcela 		:= ""
// Local cParc1			:= GetMv("MV_1DUP")
Local _ni				:= 0
Local nSC5				:= 0
// Local nAuxUpdt

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.
Private _aErro			:= {}
Private _cErroLg		:= "" //Vari�vel onde � armazenado o log quer ser� impresso em um arquivo

_nPosLb	:= aScan(_aItmPd[1], { |x| Alltrim(x[1]) == "C6_QTDLIB" })
_nPosLj	:= aScan(_aClient, { |x| Alltrim(x[1]) == "A1_LOJA" })
	
	//Conout("GENI067 - Inicio do execauto de pedido de vendas e de clientes")
	nOpt := 3 //INCLUI
	nRec := 0
	
	DbSelectArea("SA1")
	If SubStr(_cCGC,1,8) <> '00000000' .and. !Empty(_cCGC)
		SA1->(DbSetOrder(3))
		If (DbSeek(xFilial("SA1") + _cCGC))
			If !Empty(SA1->A1_CGC) .and. alltrim(_cCGC) == alltrim(SA1->A1_CGC)
				//_lImpCli := .F.
				nOpt := 4 //ATUALIZA
				nRec := Recno()
				If _aClient[1][1]<>"A1_COD"
					aAdd(_aClient,{"A1_COD"	,SA1->A1_COD,Nil})
					aAdd(_aClient,{"A1_LOJA",SA1->A1_LOJA,Nil})
					
					SA1->(DbSetOrder(1))
					SA1->(DbGoTo(nRec))
					
				Endif
			Endif
		Else
			SA1->(DbSetOrder(1))	
		EndIf 
	ElseIf !Empty(AllTrim(_cNome))
		//_cNome := upper(AllTrim((_cArqTmp)->A1_NOME)) removido pois neste ponto o registro da _cArqTmp n�o � o do cliente do pedido
		DbSetOrder(2) //FILIAL+NOME
		If (DbSeek(xFilial("SA1") + _cNome))
			If trim(SA1->A1_NOME) == _cNome
				nOpt := 4 //ATUALIZA
				nRec := Recno()
				If _aClient[1][1]<>"A1_COD"
					aAdd(_aClient,{"A1_COD"	,SA1->A1_COD,Nil})
					aAdd(_aClient,{"A1_LOJA",SA1->A1_LOJA,Nil})
				Endif
			Endif
		ElseIf !Empty(AllTrim(_cNome))
			//_cNome := upper(NoAcento(AllTrim((_cArqTmp)->A1_NOME)))
			If (DbSeek(xFilial("SA1") + upper(NoAcento(AllTrim(_cNome)))))
				If trim(SA1->A1_NOME) == _cNome
					nOpt := 4 //ATUALIZA
					nRec := Recno()
					If _aClient[1][1]<>"A1_COD"
						aAdd(_aClient,{"A1_COD"	,SA1->A1_COD,Nil})
						aAdd(_aClient,{"A1_LOJA",SA1->A1_LOJA,Nil})
					Endif
				Endif
			EndIf
		EndIf
	EndIf
	
	_nPosLj	:= aScan(_aClient, { |x| Alltrim(x[1]) == "A1_LOJA" })
	If _nPosLj = 0
		aAdd(_aClient,{"A1_LOJA","01",Nil})
	Endif
	
	//If _lImpCli
	//Conout("GENI067 - Execauto de Cliente" )
	lMsErroAuto := .F.
	MSExecAuto({|x,y| Mata030(x,y)},_aClient,nOpt)

	//������������������������������������������������������������������Ŀ
	//�Caso tenha entrado na rotina de execauto de cliente e n�o der erro�
	//�ir� prosseguir para a importa��o do pedido de vendas              �
	//��������������������������������������������������������������������
	If !lMsErroAuto
		
		If nOpt <> 3
			SA1->(dbGoTo(nRec))
		Endif
		
		aAdd ( _aCabPd , { "C5_CLIENTE"	, SA1->A1_COD	, NIL} )
		aAdd ( _aCabPd , { "C5_LOJACLI"	, SA1->A1_LOJA	, NIL} )
		aAdd ( _aCabPd , { "C5_CLIENT"	, SA1->A1_COD	, NIL} )
		aAdd ( _aCabPd , { "C5_LOJAENT"	, SA1->A1_LOJA	, NIL} )
		aAdd ( _aCabPd , { "C5_TIPOCLI"	, SA1->A1_TIPO	, NIL} )
		aAdd ( _aCabPd , { "C5_VEND1"	, SA1->A1_VEND	, NIL} )
		
		//aAdd ( _aCabPd , { "C5_MENNOTA" , "ENVIO GRATIS EM SUBSTITUICAO PEDIDO EXTRAVIADO NO CORREIO." , NIL} )
		
		//�������������������������������������������������������Ŀ
		//�Ordenando o vetor conforme estrutura da SX3, pois      �
		//�alguns execauto`s realizam valida;'oes de gatilhos     �
		//�o que pode acabar matando uma informa;'ao obrigat[oria �
		//�que ja havia sido enviada corretamente no array        �
		//���������������������������������������������������������
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SC5")
//		While !EOF() .And. (SX3->X3_ARQUIVO == "SC5")
		aSC5SX3 := FWSX3Util():GetAllFields( "SC5", .F. )
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
		//Conout("GENI067 - Execauto de Pedido de Vendas")
		
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

		// If !lMsErroAuto
		// 	For nAuxUpdt := 1 To Len(aUpdFlag)		
		// 		Begin transaction
		// 			cScript	:= "UPDATE GENESB.FORUM_PEDIDO SET ACK = 1, DATA_PROTHEUS = SYSDATE WHERE RECNO = "+cValtochar(aUpdFlag[nAuxUpdt])+" AND NUMERO = "+_cPedWeb+" AND ENTITY_ID = "+_cPedOld
		// 			If TCSQLEXEC(cScript) != 0
		// 				_cErroLg	:= "FALHA AO TENTAR ATUALIZAR A FLAG DE PROCESSAMENTO PARA O PEDIDO "+ AllTrim(_cPedWeb)
		// 				MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) + "_" + "FALHA_FLAG.txt" , _cErroLg )
		// 				U_GenSendMail(,,,"noreply@grupogen.com.br",_cMailPdForum,oemtoansi("GENI026 - Protheus Faturamento - Pedido Forum"),_cErroLg,,,.F.)
		// 			EndIf
		// 		end transaction
		// 	Next		
		// EndIf
					
		If !lMsErroAuto
	
			_cAlias1 := GetNextAlias()
			//Verifica se tem TES diferente no pedido
			_cQuery := "SELECT DISTINCT C6_TES
			_cQuery += " FROM " + RetSqlName("SC6")
			_cQuery += " WHERE C6_FILIAL = '" + xFilial("SC6") + "'"
			_cQuery += " AND C6_NUM = '" + SC5->C5_NUM + "'"
			_cQuery += " AND D_E_L_E_T_ = ' '
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias1,.T.,.T.)
			
			_nTotItem := 0
			While !(_cAlias1)->(EOF())
				_nTotItem++
				(_cAlias1)->(DbSkip())
			End
			
			//Verifica quantidade de itens
			If _nTotItem == 1
				
				//�����������������������������������������������������������������������������X�
				//�Rotina para desbloquear cr�dito para que o pedido seja faturado sem problemas�
				//�����������������������������������������������������������������������������X�
				//Posiciona na SC9 para confirmar que o pedido foi gravado na tabela
				DbSelectArea("SC9")
				DbSetOrder(1)
   
				//Posiciona na SC9 para confirmar que o pedido foi gravado na tabela
				If !DbSeek(xFilial("SC9") + SC5->C5_NUM) .AND. Empty(SC5->C5_BLQ)
					SC6->(DbSetOrder(1))
					SC6->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
					While SC6->(!EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
						
						If !SC9->(dbseek( SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM ))
							/*
							�����������������������������������������������������������������������������							
							���Parametros�ExpN1: Registro do SC6                                      ���
							���          �ExpN2: Quantidade a Liberar                                 ���
							���          �ExpL3: Bloqueio de Credito                                  ���
							���          �ExpL4: Bloqueio de Estoque                                  ���
							���          �ExpL5: Avaliacao de Credito                                 ���
							���          �ExpL6: Avaliacao de Estoque                                 ���
							���          �ExpL7: Permite Liberacao Parcial                            ���
							���          �ExpL8: Tranfere Locais automaticamente                      ���
							���          �ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ���
							���          �       apenas avalia ).                                    ���
							���          �ExpbA: CodBlock a ser avaliado na gravacao do SC9           ���
							���          �ExpAB: Array com Empenhos previamente escolhidos            ���
							���          �       (impede selecao dos empenhos pelas rotinas)          ���
							���          �ExpLC: Indica se apenas esta trocando lotes do SC9          ���
							���          �ExpND: Valor a ser adicionado ao limite de credito          ���
							���          �ExpNE: Quantidade a Liberar - segunda UM                    ���
							�������������������������������������������������������������������������Ĵ��
							���Observacao�Deve estar numa transacao                                   ���
							�������������������������������������������������������������������������Ĵ��
							���   DATA   � Programador   �Manutencao Efetuada                         ���
							�������������������������������������������������������������������������Ĵ��
							���          �               �                                           ���
							��������������������������������������������������������������������������ٱ�
							�����������������������������������������������������������������������������
							�����������������������������������������������������������������������������
							Function MaLibDoFat(nRegSC6,nQtdaLib,lCredito,lEstoque,lAvCred,lAvEst,lLibPar,lTrfLocal,aEmpenho,bBlock,aEmpPronto,lTrocaLot,lOkExpedicao,nVlrCred,nQtdalib2)
							/*/
																										
							RecLock("SC6",.F.)
							SC6->C6_QTDLIB := MaLibDoFat(SC6->(Recno()),SC6->C6_QTDVEN,.T.,.T.,.F.,.T.,.F.)
							SC6->(msUnlock())
						EndIf	

						SC6->(DbSkip())
					EndDo						
				EndIf				
				
				If DbSeek(xFilial("SC9") + SC5->C5_NUM)
					
					//Verifica se o pedido ficou bloqueado
					_cQuery := "SELECT C9_FILIAL, C9_PEDIDO, C9_BLCRED,
					_cQuery += " R_E_C_N_O_ SC9RECNO
					_cQuery += " FROM "+RetSqlName("SC9")+" SC9
					_cQuery += " WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"'
					_cQuery += " AND SC9.C9_PEDIDO = '"+SC5->C5_NUM+"'
					_cQuery += " AND (SC9.C9_BLEST NOT IN('  ','10')
					_cQuery += " OR SC9.C9_BLCRED NOT IN('  ','09','10') )
					_cQuery += " AND SC9.D_E_L_E_T_ = ' '
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliSC9,.T.,.T.)
					
					//Percorre todos itens bloqueados no pedido
					While !(_cAliSC9)->(Eof())
						
						//Posiciona a SC9
						SC9->(DbGoTo((_cAliSC9)->SC9RECNO))
						IF 	SC9->(Recno()) == (_cAliSC9)->SC9RECNO
							
							//������������������������������������������������������������������������������
							//���          �Rotina de atualizacao da liberacao de credito                ���
							//��������������������������������������������������������������������������Ĵ��
							//���Parametros�ExpN1: 1 - Liberacao                                         ���
							//���          �       2 - Rejeicao                                          ���
							//���          �ExpL2: Indica uma Liberacao de Credito                       ���
							//���          �ExpL3: Indica uma liberacao de Estoque                       ���
							//���          �ExpL4: Indica se exibira o help da liberacao                 ���
							//���          �ExpA5: Saldo dos lotes a liberar                             ���
							//���          �ExpA6: Forca analise da liberacao de estoque                 ���
							//��������������������������������������������������������������������������Ĵ��
							//���Descri��o �Esta rotina realiza a atualizacao da liberacao de pedido de  ���
							//���          �venda com base na tabela SC9.                                ���
							//������������������������������������������������������������������������������
							
							//a450Grava(1,.T.,.F.,.F.) //ALTERADO POR DANILO AZEVEDO 24/04/15 PARA LIBERAR TAMBEM ESTOQUE
							//a450Grava(1,.T.,.T.,.F.) // ALTERADO POR CLEUTO EM 13/04/2017 - VIVAZ 32105 - PARA N�O FOR�AR A LIBERA��O DE ESTOQUE
							//a450Grava(1,.T.,.F.,.F.) // ALTERADO POR CLEUTO EM 05/05/2017 - VIVAZ 34311 - PARA FOR�AR A LIBERA��O DE ESTOQUE POIS OS PEDIDOS EST�O FICANDO PARADOS DEVIDO AO CAMPO B2_QTNP
							a450Grava(1,.T.,.T.,.F.)
						Else
							_cErroLg := "Recno nao encontrado na SC9. Verifique se o pedido foi corretamente faturado. Recno SC9: " + cvaltochar((_cAliSC9)->SC9RECNO)
							MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+ ".txt" , _cErroLg )
						EndIf
						(_cAliSC9)->(DbSkip())
					EndDo
				Else
					WFForceDir(_cLogPd + DtoS(DDataBase) +"\")
					_cErroLg := "Pedido n�o localizado na SC9. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC5->C5_NUM
					MemoWrite ( _cLogPd + DtoS(DDataBase) +"\" + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+SC5->C5_NUM+".txt" , _cErroLg )
					
					cMsg := SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+SC5->C5_NUM+cEnt+_cErroLg
					
					U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("Protheus Faturamento - Importa��o Pedido Web"),cMsg,,,.F.)
				EndIf
				
				/*-------------------------------------------------------
				INCLUS�O DE ROTINA PARA GERA��O  DE NOTA NO FATURAMENTO
				---------------------------------------------------------*/
				
				*'-----------------------------------------------------------------------------------------------------'*
				*'Inicio - Caso tenha ocorrido com sucesso a gera��o do Pedido de Vendas, ir� iniciar a gera��o da Nota'*
				*'-----------------------------------------------------------------------------------------------------'*
				
				//Posiciona a SC9
				DbSelectArea("SC9")
				DbSetOrder(1)
				If DbSeek(xFilial("SC9")+SC5->C5_NUM)
					
					_cCliente 	:= SC5->C5_CLIENTE
					_cLoja		:= SC5->C5_LOJACLI
					
					//Percorre todos os itens da SC9
					While !SC9->(EOF()) ;
						.and. SC9->C9_FILIAL == xFilial("SC9");
						.And. SC9->C9_PEDIDO == SC5->C5_NUM
						
						//Verifica se item n�o est� bloqueado
						If (SC9->C9_BLEST == '  ' .OR. SC9->C9_BLEST == '10');
							.AND. (SC9->C9_BLCRED == '  ' .OR. SC9->C9_BLCRED == '10' .OR. SC9->C9_BLCRED == '09')
							
							//Posiciona no item do pedido SC6
							DbSelectArea("SC6")
							DbSetOrder(1)
							If DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM)
								
								//Adiciona informa��es para faturamento
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
								//aAdd( _aTmpPV1, SE4->(RECNO(POSICIONE("SE4",1,xFilial("SE4")+"001"				,""))))
								aAdd( _aTmpPV1, SE4->(RECNO(POSICIONE("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG	,""))))
								aAdd( _aTmpPV1, SB1->(RECNO(POSICIONE("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO	,""))))
								aAdd( _aTmpPV1, SB2->(RECNO(POSICIONE("SB2",1,xFilial("SB2")+SC9->C9_PRODUTO	,""))))
								aAdd( _aTmpPV1, SF4->(RECNO(POSICIONE("SF4",1,xFilial("SF4")+SC6->C6_TES		,""))))
								aAdd( _aTmpPV1, SC9->C9_LOCAL	)
								aAdd( _aTmpPV1, 1				)
								aAdd( _aTmpPV1, SC9->C9_QTDLIB2	)
								
								aAdd( _aPVlNFs, aClone(_aTmpPV1))
								
								DbSelectArea("SC9")
								DbSkip()
							Else
								_cErroLg := "Item de pedido n�o localizado na SC6. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC9->C9_PEDIDO + " Item: " + SC9->C9_ITEM
								MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+ ".txt" , _cErroLg )
								SC9->(DBSKIP())
							Endif
						Else
							_cErroLg := "Pedido com itens SC9 n�o liberado. Verifique se o pedido foi corretamente faturado. Pedido Protheus: " + SC9->C9_PEDIDO + " Item: " + SC9->C9_ITEM
							MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+ ".txt" , _cErroLg )
							SC9->(DBSKIP())
						Endif
					EndDo
					
					//CONOUT("GENA006 - REALIZANDO A GERACAO DA NOTA ")
					
					*'------------------------------------------------'*
					*'Rotina utilizada para realizar a gera��o da Nota'*
					*'------------------------------------------------'*
					// 28/07/2016 - Rafael Leite - Desabilitada gera��o do documento de saida por causa do Protheus Integra��o Faturamento Protheus x WMS
					//If Empty(_cErroLg) .and. _lVwWeb
					
					If Empty(_cErroLg) ;
					.and. _lVwWeb ;
					.and. ( Getmv("GEN_FAT114") .OR. (lDigital .AND. AllTrim(_cMvSeri) == "2" ))//parametro de controle de execucao
					
						_cNotaImp := MaPVlNFs(_aPVlNFs,_cMvSeri,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)
						
						_aPVlNFs := {}
						
						//CHECK DE ERRO NO PEDIDO
						_cQry := "SELECT C6_PRODUTO, C6_QTDVEN, C6_QTDENT
						_cQry += " FROM "+RetSqlName("SC6")+" SC6
						_cQry += " WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"'
						_cQry += " AND SC6.C6_NOTA = '"+_cNotaImp+"'
						_cQry += " AND SC6.C6_SERIE = '"+_cMvSeri+"'
						_cQry += " AND SC6.D_E_L_E_T_ = ' '
						_cQry += " AND SC6.C6_QTDVEN <> SC6.C6_QTDENT
						_cQry += " UNION ALL
						_cQry += " SELECT C6_PRODUTO, C6_QTDVEN, D2_QUANT
						_cQry += " FROM "+RetSqlName("SC6")+" SC6
						_cQry += " ,"+RetSqlName("SD2")+" SD2
						_cQry += " WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"'
						_cQry += " AND SC6.C6_NOTA = '"+_cNotaImp+"'
						_cQry += " AND SC6.C6_SERIE = '"+_cMvSeri+"'
						_cQry += " AND SC6.D_E_L_E_T_ = ' '
						_cQry += " AND SD2.D2_FILIAL = '"+xFilial("SD2")+"'
						_cQry += " AND SD2.D2_DOC = SC6.C6_NOTA
						_cQry += " AND SD2.D2_SERIE = SC6.C6_SERIE
						_cQry += " AND SC6.C6_ITEM = SD2.D2_ITEMPV
						_cQry += " AND SD2.D_E_L_E_T_ = ' '
						_cQry += " AND SC6.C6_QTDVEN <> SD2.D2_QUANT
						_cQry += " UNION ALL
						_cQry += " SELECT SC6.C6_PRODUTO, SUM(SC6.C6_QTDVEN) Q1, SUM(SD2.D2_QUANT) Q2
						_cQry += " FROM "+RetSqlName("SC6")+" SC6
						_cQry += " ,"+RetSqlName("SD2")+" SD2
						_cQry += " WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"'
						_cQry += " AND SC6.C6_NOTA = '"+_cNotaImp+"'
						_cQry += " AND SC6.C6_SERIE = '"+_cMvSeri+"'
						_cQry += " AND SC6.D_E_L_E_T_ = ' '
						_cQry += " AND SD2.D2_FILIAL = '"+xFilial("SD2")+"'
						_cQry += " AND SD2.D2_DOC = SC6.C6_NOTA
						_cQry += " AND SD2.D2_SERIE = SC6.C6_SERIE
						_cQry += " AND SC6.C6_ITEM = SD2.D2_ITEMPV
						_cQry += " AND SD2.D_E_L_E_T_ = ' '
						_cQry += " GROUP BY C6_PRODUTO
						_cQry += " HAVING SUM(SC6.C6_QTDVEN) <> SUM(SD2.D2_QUANT)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliSC6,.T.,.T.)
						
						If ! (_cAliSC6)->(Eof())
							
							_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. Ser� feita tentativa de exclus�o."
							conout("GENI067 - "+_cErroLg)
							U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br")+";helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Importa��o WEB"),oemtoansi(_cErroLg),,,.F.)
							
							aRegSD2	:= {}
							aRegSE1 := {}
							aRegSE2 := {}
							
							//�������������������������������������������������������
							//�Posiciona no documento fiscal de sa�da a ser exclu�do�
							//�������������������������������������������������������
							DbSelectArea("SF2")
							DbSetOrder(1)
							If SF2->(DbSeek(xFilial("SF2") + _cNotaImp + padr(_cMvSeri,TamSx3("F2_SERIE")[1]) + _cCliente + _cLoja))
								//������������������������������������������������������������������
								//�Executa rotinas responsaveis pela exclus�o do documento de sa�da�
								//������������������������������������������������������������������
								If MaCanDelF2("SF2", SF2->(RECNO()) , @aRegSD2, @aRegSE1, @aRegSE2)
									SF2->(MaDelNFS(aRegSD2, aRegSE1, aRegSE2))
									_cNotaImp := ""
								Else
									_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. N�o foi poss�vel realizar a exclus�o. Efetue o procedimento manualmente assim que poss�vel."
									conout("GENI067 - "+_cErroLg)
									U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br")+";helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Importa��o WEB"),oemtoansi(_cErroLg),,,.F.)
								EndIf
								_cNotaImp := ""
							Else
								_cErroLg := "Nota fiscal "+_cNotaImp+"-"+_cMvSeri+" com divergencia de quantidades. N�o foi poss�vel encontrar o registro na SF2 para exclus�o. Efetue o procedimento manualmente assim que poss�vel."
								conout("GENI067 - "+_cErroLg)
								U_GenSendMail(,,,"noreply@grupogen.com.br",GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br")+";helimar@grupogen.com.br;erica.vieites@grupogen.com.br",oemtoansi("Protheus - Importa��o WEB"),oemtoansi(_cErroLg),,,.F.)
							EndIf
						EndIf
						
						//�������������������������������������������������������Ŀ
						//�Caso a nota n�o seja gerado ir� chamar a rotina de erro�
						//���������������������������������������������������������
						If Empty(AllTrim(_cNotaImp))
							
							//Conout("GENA006B - Gera��o do Documento de Sa�da apresentou erro.")
							
							//�����������������������������������������������������������Ŀ
							//�Chamando o Execauto de Altera��o e em seguida o de exclus�o�
							//�������������������������������������������������������������
							
							//�������������������������������Ŀ
							//�Alterando a quantidade liberada�
							//���������������������������������
							For _ni := 1 To Len(_aItmPd)
								_aItmPd[_ni][_nPosLb][2] := 0
								aAdd(_aItmPd[_ni],{"C6_NUM", _cPedExc, Nil})
							Next _ni
							
							//CONOUT("GENA006B - Ir� alterar o pedido de vendas para poder realizar a exclus�o.")
							aAdd ( _aCabPd , { "C5_NUM"    , _cPedExc      	, Nil} )
							lMsErroAuto := .F.
							MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,4)
							
							If !lMsErroAuto
								//CONOUT("GENA006B - Alterou o pedido de vendas com suceeso, ir� realizar a exclus�o.")
								lMsErroAuto := .F.
								_cErroLg := ""
								
								MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,5)
								
								If !lMsErroAuto
									//CONOUT("GENA006B - Excluiu com sucesso o pedido de vendas.")
									_cErroLg += "  " + cEnt
									_cErroLg += " O Pedido: " + _cPedExc + " foi exclu�do com sucesso. "  + cEnt
									_cErroLg += " Favor verificar o pedido: "  + cEnt
									_cErroLg += " Pois ele teve que ser exclu�do uma vez que o Documento de Sa�da n�o foi gerado corretamente. " + cEnt
									_cErroLg += " Favor verificar a gera��o do Documento de Sa�da, pois no processo houve erro. " + cEnt
									_cErroLg += " " + cEnt
									//MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_"+ _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cErroLg )
									MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+ ".txt" , _cErroLg )
								Else
									//Conout("GENA006B - N�o conseguiu excluir o pedido de vendas.")
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
									//MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cErroLg )
									MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+ ".txt" , _cErroLg )
								EndIF
							Else
								//CONOUT("GENA006B - N�o conseguiu alterar o pedido de vendas.")
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
								//MemoWrite ( _cLogPd + "Emp_" + _cEmpM0 + " Fil_" + _cFilM0 + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cErroLg )
								MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL)+ "_" + AllTrim(_cTipo) + "_" + AllTrim(_cPedWeb) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+ ".txt" , _cErroLg )
							EndIf
						EndIf
					EndIf
				EndIf
				
				/*-------------------------------------------------------
				FIM DA ROTINA PARA GERA��O  DE NOTA NO FATURAMENTO
				---------------------------------------------------------*/
			Else
				cMsg := "GENI067 - IMPORTA��O PEDIDO WEB" + cEnt
				cMsg += cEnt
				cMsg += "O Pedido " + SC5->C5_NUM + " tem TES diferentes e n�o vai gerar documento de sa�da." + cEnt
				U_GenSendMail(,,,"noreply@grupogen.com.br","beatriz.reis@grupogen.com.br;rafael.leite@grupogen.com.br;helimar@grupogen.com.br",oemtoansi("Protheus Faturamento - Importa��o Pedido Web"),cMsg,,,.F.)
			EndIf
		ElseIf SC5->C5_BLQ	 == "4"
		        /*
				SC6->(DbSetOrder(1)) 
				SC6->(DbSeek( SC5->C5_FILIAL+SC5->C5_NUM ))
				While SC6->(!EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
					
					SC9->(DbSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))
					While SC9->(!Eof()) .and. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == SC6->(C6_FILIAL+C6_NUM+C6_ITEM)
						SC9->(a460Estorna())
						SC9->(DbSkip())
					Enddo
					
					SC6->(DbSkip())
		        EndDo
		        */
				cMsg := "GENI067 - IMPORTA��O PEDIDO WEB" + cEnt
				cMsg += cEnt
				cMsg += "O Pedido " + SC5->C5_NUM + " foi bloqueado por black list." + cEnt
				U_GenSendMail(,,,"noreply@grupogen.com.br",_cMailBlk,oemtoansi("Protheus Faturamento - Importa��o Pedido Web"),cMsg,,,.F.)			
		EndIf
		//������������������������������������������������Ŀ
		//�Fim   da grava��o (Execauto) do pedido de vendas�
		//��������������������������������������������������
	EndIf
	
	//�����������������������������������Ŀ
	//�Caso tenha dado erro ir� gerar log �
	//�������������������������������������
	If lMsErroAuto
		_aErro := GetAutoGRLog()
		For _ni := 1 To Len(_aErro)
			_cErroLg += _aErro[_ni] + Chr(13)+Chr(10)
		Next _ni
		
		MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_" + AllTrim(_cTipo) + "_WEB_" + AllTrim(_cPedWeb) + "_OLD_" + AllTrim(_cPedOld) +"_"+Iif(_nDIGITAL==1,"DIG_","IMP_")+ ".txt" , _cErroLg )
		Disarmtransaction()
	EndIf
//EndIf

If Select(_cArqPd) > 0
	dbSelectArea(_cArqPd)
	(_cArqPd)->(dbCloseArea())
EndIf

Return()
