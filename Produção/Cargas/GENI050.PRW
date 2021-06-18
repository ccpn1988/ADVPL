#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#DEFINE cEnt Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENI050   บAutor  ณcleuto Lima         บ Data ณ  12/04/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIntegra็ใo financeiro de pedidos web em pr้-venda para gerarบฑฑ
ฑฑบ          ณRA.                                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GENI050()

Local alEmp 		:= {}
Local lEmp			:= Type('cFilAnt') == "C" .AND. Select("SM0") <> 0
Local nAuxEmp		:= 0
Local nX			:= 0
Local nLimite		:= 50  

Conout("GENI050 - Iniciando Job - "+Time()+".")

If !lEmp		
	RpcSetType(2)
	lOpenSM0 := RpcSetEnv( "00" , "1022")
	If !lOpenSM0
		ConOut("")
	   	ConOut(Replicate("+",nLimite))
	   	ConOut(Padc("GENI050 - Nao foi possivel incializar ambiente confirme a senha/usuario digitado. "+Dtoc(Date())+" "+Time(),nLimite))
	   	ConOut(Replicate("+",nLimite))
	   	ConOut("") 
	   	RpcClearEnv()
		Return Nil
	Else
		Conout("GENI050 - Abrindo empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())		
	EndIf
EndIF   

While !LockByName("GENI050",.T.,.T.,.T.)
    nX++
	Sleep(10)
	If nX > 2     
		Conout("GENI050 - Nใo foi possํvel a fun็ใo GENI050, jแ esta sendo executada por outra processamento!"+DTOC(DDataBase)+" "+Time())
		Return .F.
    EndIf
EndDo

GENI050A()
GENI050C()

If !lEmp .AND. Type('cFilAnt') == "C"
	Conout("GENI050 - Fechando empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())	
	RpcClearEnv()
EndIF

UnLockByName("GENI050",.T.,.T.,.T.)

Conout("GENI050 - Finalizando Job - "+Time()+".")

Return nil 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENI050A  บAutor  ณAngelo Henrique     บ Data ณ  11/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para o processamento da integra็ใo do pedido de vendaบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GENI050A()

Local _aArea 		:= GetArea()
Local _aClient	:= {} //Vetor para alimentar informa็๕es do cliente caso o mesmo nใo esteja cadastrado
Local _cArqAli	:= GetNextAlias()
Local _cCdMun 	:= ""
Local _cIncsr		:= ""
Local _cTpCli		:= ""
Local _cMsblq		:= ""
Local _cCep		:= ""
Local _cMunic		:= ""
Local _cRPIS		:= ""
Local _cRCSLL		:= ""
Local _cRCOFI		:= ""
Local _cRISS		:= ""
Local _cCGC		:= ""
Local _cCodPs		:= ""
Local _cEndNm		:= ""
Local _cLoja		:= "01"
Local _cCod		:= ""
Local _nLoja 		:= 0
Local _cVend		:= ""
Local _cTpDes		:= ""
Local _cDescPd	:= ""
Local _nItemC6  	:= 1 //Contador para os itens do pedido de vendas
Local _cQryIns	:= ""
Local _cLocB1		:= ""
Local _nQtdTot 	:= 0
Local _nValTot 	:= 0
Local _cMsg		:= ""
Local _cTransp	:= ""
Local _aDir		:= {}
Local _cCont 		:= "01"
Local _cFretePd	:= GetNextAlias()
Local _cArqPd		:= GetNextAlias()
Local _cArqPro	:= GetNextAlias()
Local _cNome		:= ""
Local _nDIGITAL	:= nil
					
Private _cQuery	:= ""
Private _cArqTmp	:= GetNextAlias()
Private _oServer	:= Nil
Private _cFilCont	:= ""
Private _cView	:= "" //Parโmetro que cont้m o nome da view que serแ consultada para a cria็ใo do Pedido de Vendas
Private _cLogPd	:= "" //Parโmetro que cont้m o caminho onde serแ gravado o arquivo de log de inconsist๊ncias
Private _aCabPd 	:= {}
Private _aItmPd 	:= {}
Private _alinha		:= {}

_cView		:= "DBA_EGK.TT_I34_CLIENTE_PRE_VENDA"
_cLogPd	:= "\logsiga\CLI_PRE_VENDA\CLIENTE\" //Parโmetro que cont้m o caminho onde serแ gravado o arquivo de log de inconsist๊ncias

cFAT065	:= GetMv("GEN_FAT065")
cFAT066 := GetMv("GEN_FAT066")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecutar limpeza dos logsณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_aDir:=directory(Alltrim(_cLogPd)+"*")

For _ni:= 1 to Len(_aDir)
	fErase(Alltrim(_cLogPd)+_aDir[_ni][1])
Next _ni

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ          
//ณConforme levantado serแ criado uma view disponibilizada no protheus ณ
//ณque irแ conter todos os pedidos que deverใo ser importados          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//_cQuery := " SELECT * FROM TT_I29A_PEDIDOS_SATELITES" //+ _cView
_cQuery := "SELECT * FROM "+_cView
//_cQuery += " WHERE C5_XPEDWEB = '31460' "

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqTmp, .F., .T.)

_nCtVi := 0
_cTabela 	:= GetMv("GEN_FAT064")
cRisc66 	:= GetMv("GEN_FAT066")
cCond65		:= GetMv("GEN_FAT065")

While (_cArqTmp)->(!EOF())
				
		If Empty(_cMsg)
			_cCod 		:= ""
			_aClient 	:= {}
			_cCodOld 	:= ""
			cPedWeb	:= (_cArqTmp)->C5_XPEDWEB
						
			_cCdMun	:= SUBSTR(cValToChar((_cArqTmp)->A1_COD_MUN),3,5)
			_cCdMun	:= IIF(Alltrim((_cArqTmp)->A1_EST) == 'EX','99999'			,_cCdMun)
			_cCep		:= IIF(Alltrim((_cArqTmp)->A1_EST) == 'EX'  ,'00000000'	,Alltrim((_cArqTmp)->A1_CEP))
			_cCep		:= StrTran(_cCep," ","")
			_cCep		:= StrTran(_cCep,".","")
			_cMunic	:= IIF(Alltrim((_cArqTmp)->A1_EST) == 'EX'  ,'EXTERIOR'	,(_cArqTmp)->A1_MUN)
			_cRPIS		:= IIF(Alltrim((_cArqTmp)->A1_RECPIS) == '' ,'N'		 	,Alltrim((_cArqTmp)->A1_RECPIS))
			_cRCSLL	:= IIF(Alltrim((_cArqTmp)->A1_RECCSLL)== '' ,'N'		 	,Alltrim((_cArqTmp)->A1_RECCSLL))
			_cRCOFI	:= IIF(Alltrim((_cArqTmp)->A1_RECCOFI)== '' ,'N'			,Alltrim((_cArqTmp)->A1_RECCOFI))
			_cRISS		:= IIF(Alltrim((_cArqTmp)->A1_RECISS) == '' ,'2'			,Alltrim((_cArqTmp)->A1_RECISS))
			_cRISS		:= IIF(Alltrim((_cArqTmp)->A1_RECISS) == 'N','2'			,Alltrim((_cArqTmp)->A1_RECISS))
			_cIncsr 	:= IIF(!EMPTY(AllTrim((_cArqTmp)->A1_INSCR)),AllTrim((_cArqTmp)->A1_INSCR),"ISENTO")
			_cTpCli 	:= STRZERO((_cArqTmp)->A1_XTIPCLI,3)
			_cMsblq 	:= IIF((_cArqTmp)->A1_MSBLQL='A','2','1')
			_cCGC 		:= IIF((_cArqTmp)->A1_EST='EX'	,' ',(_cArqTmp)->A1_CGC	)
			_cCodPs 	:= STRZERO((_cArqTmp)->A1_CODPAIS,TAMSX3("A1_CODPAIS")[1])
			_cEndNm 	:= IIF(Empty((_cArqTmp)->A1_XENDNUM),"0",AllTrim((_cArqTmp)->A1_XENDNUM))
			_cVend		:= IIF(ValType((_cArqTmp)->A1_VEND)=="C" ,STRZERO(Val((_cArqTmp)->A1_VEND),TAMSX3("A1_VEND")[1]),STRZERO((_cArqTmp)->A1_VEND,TAMSX3("A1_VEND")[1]))
			_cTpDes	:= IIF(ValType((_cArqTmp)->A1_VEND)=="C" ,(_cArqTmp)->A1_XTPDES,cValToChar((_cArqTmp)->A1_XTPDES))
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณCleuto Lima - 22/06/2016                            ณ
			//ณ                                                    ณ
			//ณincluido para validar o nome do cliente quando mesmoณ
			//ณnใo tem CGC                                         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			_cNome		:= upper(AllTrim((_cArqTmp)->A1_NOME))
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ	VERIFICA SE JA EXISTE O CLIENTE COM MESMA RAIZ DE CNPJ CADASTRADO  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			//VALIDA SE O CNPJ NAO ESTA PREENCHIDO COM '0' (ZERO)
			If SUBSTR(_cCGC,1,8) <> '00000000' .AND. !Empty(_cCGC)
				//Conout("GENI050 - Entrou na valida็ใo de CNPJ preenchido com ZERO")
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
					//Conout("GENI050 - Entrou na valida็ใo de adi็ใo de loja")
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
			
			_cBairro := alltrim((_cArqTmp)->A1_BAIRRO)
			_cEst := AllTrim((_cArqTmp)->A1_EST)
			_cEstado := allTrim((_cArqTmp)->A1_ESTADO)
			
			If len(alltrim(_cCep)) = 8 .and. _cEst <> 'EX'
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
			
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณGrava็ใo das Informa็๕es no Array que serแ enviado para o Execautoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			_aClient := {}
			If !Empty(_cCod)
				//Conout("GENI050 - Colocando o c๓digo do cliente")
				aAdd(_aClient,{"A1_COD"	,	_cCod													,Nil})
				aAdd(_aClient,{"A1_LOJA",	_cLoja													,Nil})
			EndIf
			//Conout("GENI050 - Alimentando vetor Cliente")
			If !Empty((_cArqTmp)->A1_XCODOLD)
				aAdd(_aClient,{"A1_XCODOLD"	,	alltrim(str((_cArqTmp)->A1_XCODOLD))				,Nil})
			Endif
			aAdd(_aClient,{"A1_NOME"		,	upper(AllTrim((_cArqTmp)->A1_NOME))						,Nil})
			aAdd(_aClient,{"A1_PESSOA"	,	AllTrim((_cArqTmp)->A1_PESSOA)							,Nil})
			aAdd(_aClient,{"A1_NREDUZ"	,	AllTrim((_cArqTmp)->A1_NREDUZ)							,Nil})
			aAdd(_aClient,{"A1_CEP"		,	_cCep													,Nil})
			aAdd(_aClient,{"A1_END"		,	(_cArqTmp)->A1_END										,Nil})
			aAdd(_aClient,{"A1_XENDNUM"	,	_cEndNm													,Nil}) //Numero do endereco
			aAdd(_aClient,{"A1_COMPLEM"	,	(_cArqTmp)->A1_COMPLEMEN								,Nil})
			aAdd(_aClient,{"A1_BAIRRO"	,	(_cArqTmp)->A1_BAIRRO									,Nil})
			aAdd(_aClient,{"A1_EST"		,	AllTrim((_cArqTmp)->A1_EST)								,Nil})
			aAdd(_aClient,{"A1_ESTADO"	,	AllTrim((_cArqTmp)->A1_ESTADO)							,Nil})
			aAdd(_aClient,{"A1_COD_MUN"	,	_cCdMun													,Nil})
			aAdd(_aClient,{"A1_MUN"		,	AllTrim(_cMunic)										,Nil})
			aAdd(_aClient,{"A1_DDD"		,	(_cArqTmp)->A1_DDD										,Nil})
			aAdd(_aClient,{"A1_DDI"		,	(_cArqTmp)->A1_DDI										,Nil})
			aAdd(_aClient,{"A1_TEL"		,	(_cArqTmp)->A1_TEL										,Nil})
			aAdd(_aClient,{"A1_FAX"		,	(_cArqTmp)->A1_FAX										,Nil})
			aAdd(_aClient,{"A1_TIPO"		,	(_cArqTmp)->A1_TIPO										,Nil})
			aAdd(_aClient,{"A1_PAIS"		,	(_cArqTmp)->A1_PAIS										,Nil})
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
			aAdd(_aClient,{"A1_VEND"		,	_cVend													,Nil})
			aAdd(_aClient,{"A1_XTPDES"	,	_cTpDes													,Nil}) //Tipo desconto
			aAdd(_aClient,{"A1_TRANSP"	,	STRZERO((_cArqTmp)->A1_TRANSP,6)						,Nil})
			aAdd(_aClient,{"A1_XCONDPG"	,	STRZERO((_cArqTmp)->A1_XCONDPG,TAMSX3("A1_XCONDPG")[1]),Nil}) //Condicao Pagto (GEN)
			aAdd(_aClient,{"A1_COND"		,	cFAT065	,Nil})
			aAdd(_aClient,{"A1_TABELA"	,	_cTabela			,Nil})
			aAdd(_aClient,{"A1_LC"		,	(_cArqTmp)->A1_LC										,Nil}) //Limite de Cr้dito 
			aAdd(_aClient,{"A1_BLEMAIL"	,	(_cArqTmp)->A1_BLEMAIL									,Nil}) //Boleto por Email
			aAdd(_aClient,{"A1_RISCO"	,	cFAT066												,Nil}) //Limite de Cr้dito
			
			aAdd(_aClient,{"A1_XPTREF"	,	(_cArqTmp)->A1_XPTREF									,Nil})
			
			GENI050B(_aClient,cPedWeb,_cCGC)

	EndIf
	
	(_cArqTmp)->(DbSkip())
EndDo

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENI050B  บAutor  ณAngelo Henrique     บ Data ณ  14/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina responsแvel pela execu็ใo do execauto de clientes    บฑฑ
ฑฑบ          ณe pedido de vendas                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//Rafael Leite - 29/01/2015. Inclusao do parametro _cCGC
//Rodrigo Mourใo - 01/02/2015. Inclusao do tipo e Pedido Web
Static Function GENI050B(_aClient,cPedWeb,_cCGC)

Local _aArea 			:= GetArea()
Local _cArqCli		:= GetNextAlias()
Local _cArqPd			:= GetNextAlias()
Local _cAliSC9 		:= GetNextAlias()
Local _cAliSC6 		:= GetNextAlias()
Local cQueryINS		:= ""
Local _cQuery			:= ""
Local _aAcabC5		:= {}
Local _aItmC6			:= {}

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.
Private _aErro			:= {}
Private _cErroLg			:= "" //Variแvel onde ้ armazenado o log quer serแ impresso em um arquivo
Private _cView			:= GETMV("MV_XVIEWPD")
Private _cLogPd			:= "\logsiga\CLI_PRE_VENDA\"

_nPosLj	:= aScan(_aClient, { |x| Alltrim(x[1]) == "A1_LOJA" })

//Conout("GENI050 - Inicio do execauto de pedido de vendas e de clientes")
nOpt := 3 //INCLUI
nRec := 0

DbSelectArea("SA1")
If SubStr(_cCGC,1,8) <> '00000000' .and. !Empty(_cCGC)
	DbSetOrder(3)
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
	EndIf 
ElseIf !Empty(AllTrim(_cNome))
	//_cNome := upper(AllTrim((_cArqTmp)->A1_NOME)) removido pois neste ponto o registro da _cArqTmp nใo ้ o do cliente do pedido
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
	
lMsErroAuto := .F.
MSExecAuto({|x,y| Mata030(x,y)},_aClient,nOpt)
//upper(replace(A1_NOME,'''',' '))	
If lMsErroAuto
	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + Chr(13)+Chr(10)
	Next _ni
	
	MemoWrite ( _cLogPd + SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL) + "_"+cPedWeb+".txt" , _cErroLg )
	Disarmtransaction()
EndIf

If Select(_cArqPd) > 0
	dbSelectArea(_cArqPd)
	(_cArqPd)->(dbCloseArea())
EndIf

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENI050   บAutor  ณcleuto Lima         บ Data ณ  12/04/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIntegra็ใo financeiro de pedidos web em pr้-venda para gerarบฑฑ
ฑฑบ          ณRA.                                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function GENI050C()

Local _cView	:= "DBA_EGK.TT_I34_RA_PRE_VENDA"
Local _cLogPd	:= "\logsiga\CLI_PRE_VENDA\TITULO\" //Parโmetro que cont้m o caminho onde serแ gravado o arquivo de log de inconsist๊ncias
Local _cQuery	:= "" 
Local aArray	:= {}
Local cNatBol	:= GetMv("GENI018BOL") //NATUREZA PARA BOLETO
Local aInfBAC	:= StrTokArr(AllTrim(GetMv("GEN_FIN006")),"/")
Local _cArqTmp:= GetNextAlias()
	 
PRIVATE lMsErroAuto	:= .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ          
//ณConforme levantado serแ criado uma view disponibilizada no protheus ณ
//ณque irแ conter todos os pedidos que deverใo ser importados          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cQuery := "SELECT * FROM "+_cView

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqTmp, .F., .T.)

(_cArqTmp)->(DbGoTop())

While (_cArqTmp)->(!EOF())
	
	SA1->(DbSetOrder(3))
	If !SA1->(DbSeek( xFilial("SA1")+(_cArqTmp)->A1_CGC ))
		(_cArqTmp)->(DbSkip())
		Loop
	EndIf
	
	DDataBase	:= StoD((_cArqTmp)->E1_VENCTO)
	
	lMsErroAuto	:= .F.
	 
	aArray := { { "E1_PREFIXO"  , "AUT"				, NIL },;
	            { "E1_NUM"      , AllTrim((_cArqTmp)->C5_XPEDWEB)	, NIL },;
	            { "E1_TIPO"     , "RA"					, NIL },;
	            { "E1_NATUREZ"  , cNatBol				, NIL },;
	            { "E1_CLIENTE"  , SA1->A1_COD			, NIL },;
	            { "E1_LOJA"  	, SA1->A1_LOJA		, NIL },;
	            { "E1_EMISSAO"  , StoD((_cArqTmp)->C5_EMISSAO)		, NIL },;
	            { "E1_VENCTO"   , StoD((_cArqTmp)->E1_VENCTO)		, NIL },;
	            { "E1_VENCREA"  , StoD((_cArqTmp)->E1_VENCTO)		, NIL },;
	            { "E1_VALOR"    , (_cArqTmp)->E1_VALOR				, NIL },;	            	            
	            { "cBancoAdt"	, PadR(aInfBAC[1],TamSX3("A6_COD")[1])				, NIL },; 
	            { "cAgenciaAdt"	, PadR(aInfBAC[2],TamSX3("A6_AGENCIA")[1])					, NIL },;
	            { "cNumCon"		, PadR(aInfBAC[3],TamSX3("A6_NUMCON")[1])					, NIL },;
	            { "E5_ORIGEM"	, "FINA740 "				, NIL },;
	            { "E1_HIST"		, "VENDA SITE - BOLETO - PEDIDO WEB "+	AllTrim((_cArqTmp)->C5_XPEDWEB)		, NIL },;	            
	            { "E1_XEDICAO"	, "3"	, NIL },;
	            { "E1_XINTER"	, "0"	, NIL };
	            }

	MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3)  // 3 - Inclusao, 4 - Altera็ใo, 5 - Exclusใo
	 
	 
	If lMsErroAuto
	    MostraErro(_cLogPd,"PEDWEB_"+AllTrim((_cArqTmp)->C5_XPEDWEB)+".log")		    
	Endif	
	
	(_cArqTmp)->(DbSkip())
EndDo


Return nil