#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "aarray.CH"
#INCLUDE "json.CH"
#INCLUDE "shash.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJFILAWMS  บAutor  ณCleuto Lima         บ Data ณ  05/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ processa fila de corte de pedido do WMS.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function JFWMS002()

Local alEmp 		:= {}
Local lEmp			:= Type('cFilAnt') == "C" .AND. Select("SM0") <> 0
Local nAuxEmp		:= 0
Local nX			:= 0
Local nLimite		:= 50  

Conout("JFWMS002 - Iniciando Job - fila de processos WMS - "+Time()+".")

If !lEmp		
	RpcSetType(2)
	lOpenSM0 := RpcSetEnv( "00" , "1022")//, "cleuto.lima" ,  "@rionsx2" , "FAT"  , {'SM0','SX1'},,,.t.)
	If !lOpenSM0
		ConOut("")
	   	ConOut(Replicate("+",nLimite))
	   	ConOut(Padc("JFWMS002 - Nao foi possivel incializar ambiente confirme a senha/usuario digitado. "+Dtoc(Date())+" "+Time(),nLimite))
	   	ConOut(Replicate("+",nLimite))
	   	ConOut("") 
	   	RpcClearEnv()
		Return Nil
	Else
		Conout("JFWMS002 - Abrindo empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())		
	EndIf
EndIF   

While !LockByName("JFWMS002",.T.,.T.,.T.)
    nX++
	Sleep(10)
	If nX > 2     
		Conout("JFWMS002 - Nใo foi possํvel executar a fila WMS neste momento pois a fun็ใo JFWMS002 jแ esta sendo executada por outra processamento!"+DTOC(DDataBase)+" "+Time())
		Return .F.
    EndIf
EndDo

ProcFila()

If !lEmp .AND. Type('cFilAnt') == "C"
	Conout("JFWMS002 - Fechando empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())	
	RpcClearEnv()
EndIF

UnLockByName("JFWMS002",.T.,.T.,.T.)

Conout("JFWMS002 - Finalizando Job - fila de processos WMS - "+Time()+".")

Return nil  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJFILAWMS  บAutor  ณMicrosiga           บ Data ณ  05/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcFila()

Local cAliasZZ5 := GetNextAlias()
Local cSqlZZ5 	:= ""
Local cQuebra	:= Chr(13)+Chr(10)
Local nRegProc	:= 0  
Local aPvlNfs	:= {}
Local lCorte	:= .F.

Local _cServ	:= SuperGetmv("GEN_FAT110",.f.,"10.1.0.243")//IP do servidor
Local _nPort	:= SuperGetmv("GEN_FAT111",.f.,1888) //Porta de conexใo do servidor
Local _cAmb		:= SuperGetmv("GEN_FAT112",.f.,"SCHEDULE") //Ambiente do servidor
Local cMonit	:= GetMv("GEN_EST007")

DbSelectArea("ZZ5")
DbSelectArea("SC5")

// Nใo usei RetSqlName na tabela ZZ5000 apenas por questใo de desempenho
cSqlZZ5 := " SELECT ZZ5.R_E_C_N_O_ ZZ5REC FROM ZZ5000 ZZ5 "+cQuebra
cSqlZZ5 += " WHERE ZZ5_FILIAL IN ( "+cQuebra
cSqlZZ5 += " '1001', "+cQuebra
cSqlZZ5 += " '1012', "+cQuebra
cSqlZZ5 += " '1022', "+cQuebra
cSqlZZ5 += " '2001', "+cQuebra
cSqlZZ5 += " '2012', "+cQuebra
cSqlZZ5 += " '2022', "+cQuebra
cSqlZZ5 += " '3022', "+cQuebra
cSqlZZ5 += " '4012', "+cQuebra
cSqlZZ5 += " '4022', "+cQuebra
cSqlZZ5 += " '6001', "+cQuebra
cSqlZZ5 += " '6022', "+cQuebra
cSqlZZ5 += " '9022' "+cQuebra
cSqlZZ5 += " ) "+cQuebra     
cSqlZZ5 += " AND ZZ5_IDFUNC = '0002' "+cQuebra
cSqlZZ5 += " AND ZZ5_STATUS = '00' "+cQuebra//00=Aguardando processamento;01=Processo finalizad;99=Falha de processamento
cSqlZZ5 += " AND ZZ5.D_E_L_E_T_ <> '*' "+cQuebra
cSqlZZ5 += " ORDER BY ZZ5.R_E_C_N_O_ "+cQuebra
		
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cSqlZZ5),cAliasZZ5,.T.,.T.)

Conout("JFWMS002 - Iniciando processamento da tabela ZZ5 "+Time())

(cAliasZZ5)->(DbGoTop())
While (cAliasZZ5)->(!EOF())

	nRegProc++
	
	ZZ5->(DbGoTo((cAliasZZ5)->ZZ5REC))
    
    IF ZZ5->(!EOF())
    	If SOFTLOCK("ZZ5") 
    	
    		//aaParam	:= FromJson(Alltrim(ZZ5->ZZ5_DADOS))
    	
			Conout("JFWMS002 - Iniciando processamento do registro "+ZZ5->ZZ5_IDFILA+" "+Time())
    	    
    		SC5->(DbSetOrder(1))
    		
    		cChaveSC5	:= ZZ5->ZZ5_FILIAL+ZZ5->ZZ5_PEDIDO
    		If SC5->(DbSeek( cChaveSC5 ))
    		    
    		    If SC5->C5_XROMANE == 0
    		    	RecLock("SC5",.F.)
    		    	SC5->C5_XROMANE	:= ZZ5->ZZ5_ROMANE
    		    	SC5->(MsUnLock())
    		    EndIf
    		    /*
				_cServ	:= "10.3.0.72"			//IP do servidor
				_nPort	:= 1229           		//Porta de conexใo do servidor
				_cAmb	:= "HML_WMS"     //Ambiente do servidor
				*/
				_cEmpCd	:= "00"          		//Empresa de conexใo
				_cEmpFl	:= ZZ5->ZZ5_FILIAL		//Filial de conexใo 
				lCorte	:= .F.							
				
				CREATE RPCCONN _oServer ON  SERVER _cServ 			;   //IP do servidor
				PORT  _nPort           								;   //Porta de conexใo do servidor
				ENVIRONMENT _cAmb       							;   //Ambiente do servidor
				EMPRESA _cEmpCd          							;   //Empresa de conexใo
				FILIAL  _cEmpFl          							;   //Filial de conexใo
				TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que serใo abertas
				MODULO  "SIGAFAT"               					//M๓dulo de conexใo
					
				If ValType(_oServer) == "O"														
					_oServer:CallProc("RPCSetType", 2)					
					lCorte	:= _oServer:CallProc("U_JFILA02B",SC5->C5_FILIAL,SC5->C5_NUM,ZZ5->(Recno()),Alltrim(ZZ5->ZZ5_DADOS))
 
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณRealizando a nova conexใo para entrafr na empresa e filial corretaณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					//Fecha a Conexao com o Servidor
					RESET ENVIRONMENT IN SERVER _oServer
					CLOSE RPCCONN _oServer
					_oServer := Nil
				EndIf    			
    		    
    			If lCorte  
		    		RecLock("ZZ5",.F.)
		    		ZZ5->ZZ5_QTDPRC	:= ZZ5->ZZ5_QTDPRC+1               
		    		ZZ5->ZZ5_STATUS	:= "01"
		    		ZZ5->ZZ5_DTUPDA	:= DDATABASE
		    		ZZ5->ZZ5_HRUPDA	:= Time()
		    		ZZ5->ZZ5_MSG	:= "Corte realizado com sucesso!"
		    		ZZ5->(MsUnLock())         			
		    	Else
		    		RecLock("ZZ5",.F.)
		    		ZZ5->ZZ5_QTDPRC	:= ZZ5->ZZ5_QTDPRC+1
		    		ZZ5->ZZ5_MSG	:= "Corte nใo realizado!"
		    		ZZ5->(MsUnLock())
    			EndIF
    		
    		Else 
	    		RecLock("ZZ5",.F.)
	    		ZZ5->ZZ5_QTDPRC	:= ZZ5->ZZ5_QTDPRC+1
	    		ZZ5->(MsUnLock())
    			Conout("JFWMS002 - Pedido nใo localizado na base "+ZZ5->ZZ5_IDFILA+" "+Time())
    		EndIF
    	       	
    	Else
    		Conout("JFWMS002 - Nใo foi possํvel obter acesso exclusivo ao registro "+ZZ5->ZZ5_IDFILA+" "+Time())		
    	EndIF
    Else
    	Conout("JFWMS002 - Falha ao posicionar registro na tabela ZZ5 "+" "+Time())		
    EndIf

	(cAliasZZ5)->(DbSkip())
EndDo


(cAliasZZ5)->(DbCloseArea())

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJFILAWMS  บAutor  ณMicrosiga           บ Data ณ  05/17/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function JFILA02B(cFilPed,cPedido,nRecZZ5,cParam) 

Local _aCabPed	:= {}
Local _aItens	:= {}
Local alinha	:= {}
Local lRet		:= .T.
Local _cAliSC9	:= GetNextAlias()
Local nTamProd	:= TamSX3("B1_COD")[1]
Local aaParam	:= Array(#)
Local lDelAll	:= .T.
Local cObsAux	:= ""
Local cDtPed	:= ""  
Local cEmail	:= SuperGetmv("GEN_FAT120",.F.,"v.bentes@grupogen.com.br;logistica@grupogen.com.br")
Local cCopMail	:= "cleuto.lima@grupogen.com.br"
Local aMailxTes	:= {} 
Local aCorte	:= {}
Local _aCabParc	:= {} 
Local nTotPed	:= 0 
Local nValFret	:= 0	
Local cMonit	:= GetMv("GEN_EST007")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCleuto - 17/01/2016                                      ณ
//ณimplementado tratamento para condi็ใo de pagamento TIPO 9ณ
//ณpara o projeto de parcelamento                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _aParcItem	:= {}
Local cFORMAPG		:= ""
Local _nTotParc		:= 0
Local _cMsg			:= ""
Local nPosVal 		:= 0
Local nPosDel 		:= 0
Local nAux			:= 0
Local cMsgVld		:= ""
Local aAtend		:= {}
Local nAuxAtend		:= 0
Local lAchouZZB		:= .F.
Local cIdZZB		:= ""
Local _nI			:= 0
		
Aadd(aMailxTes, {"506","sac@grupogen.com.br"} ) //"TEs Venda site"

/*
Aaddd(aMailxTes, {"501;505","cleutolima@gmail.com"} ) //"TES Venda"
Aaddd(aMailxTes, {"501;505","cleutolima@gmail.com"} ) //"TEs Venda site"
Aaddd(aMailxTes, {"501;505","cleutolima@gmail.com"} ) //"TES Venda CRM"
Aaddd(aMailxTes, {"501;505","cleutolima@gmail.com"} ) //"TES Oferta CRM"
Aaddd(aMailxTes, {"501;505","cleutolima@gmail.com"} ) //"TES Ofetra DA"
Aaddd(aMailxTes, {"501;505","cleutolima@gmail.com"} ) //"TES Consigan็ใo"
Aaddd(aMailxTes, {"501;505","cleutolima@gmail.com"} ) //"TES Outros"
*/

aaParam	:= FromJson(cParam)

SC5->(DbSetOrder(1))
SC5->(DbSeek(cFilPed+cPedido))

cDtPed	:= SC5->C5_EMISSAO

SC6->(DbSetOrder(2))

aAdd ( _aCabPed , { "C5_TIPO" 		, SC5->C5_TIPO		, NIL} )
aAdd ( _aCabPed , { "C5_NUM"   		, SC5->C5_NUM 		, NIL} )
aAdd ( _aCabPed , { "C5_CLIENTE" 	, SC5->C5_CLIENTE	, NIL} )
aAdd ( _aCabPed , { "C5_LOJACLI" 	, SC5->C5_LOJACLI	, NIL} )

SC6->(DbSetOrder(1)) 
SC6->(DbSeek(cFilPed+cPedido))
While SC6->(!EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == cFilPed+cPedido
	
	
   //	lDelAll	:= !aScan(aaParam, {|x| x[#"QUANTIDADE"] <> 0 } ) <> 0
	
	nPosProd	:= aScan(aaParam, {|x| AllTrim(x[#"PRODUTO"]) == AllTrim(SC6->C6_PRODUTO) } ) 
	nQtdVen		:= 0
	nValTot		:= 0
	
	If nPosProd <> 0
		//If lDelAll
		//	nQtdVen		:= 1
		//	nValTot		:= nQtdVen*SC6->C6_PRCVEN			
		//Else
			nQtdVen		:= aaParam[nPosProd][#"QUANTIDADE"]
			nValTot		:= nQtdVen*SC6->C6_PRCVEN
		//EndIF
	Else 
		nQtdVen		:= SC6->C6_QTDVEN
		nValTot		:= SC6->C6_VALOR		
	EndIf
	
	aLinha	:= {}

	aadd(aLinha,{"LINPOS", 				"C6_ITEM",			SC6->C6_ITEM})
	
	If nQtdVen == 0//	 .AND. !lDelAll	
		aAdd(aLinha,{"AUTDELETA",			"S",			 	Nil})
		Aadd(aCorte, { SC6->C6_ITEM, SC6->C6_PRODUTO , SC6->C6_DESCRI , SC6->C6_QTDVEN , 0 , SC6->C6_VALOR , nValTot , "Item Excluido" } )
		Aadd(aAtend,{SC5->C5_FILIAL,SC5->C5_NUM,SC5->C5_XUSRDIG,SC5->C5_CLIENT,SC5->C5_LOJACLI,SC5->C5_EMISSAO,SC5->C5_VEND1,SC6->C6_PRODUTO,SC6->C6_DESCRI,SC6->C6_TES,SC6->C6_ITEM,SC6->C6_QTDVEN,SC6->C6_PRCVEN,SC6->C6_PRUNIT,SC6->C6_DESCONT,0} )
	Else
		aAdd(aLinha,{"AUTDELETA",			"N",			 	Nil})
		Aadd(aCorte, { SC6->C6_ITEM, SC6->C6_PRODUTO , SC6->C6_DESCRI , SC6->C6_QTDVEN , nQtdVen , SC6->C6_VALOR , nValTot , IIF( nPosProd <> 0 , "Item Alterado" , "Item sem altera็ใo" ) } )
		Aadd(aAtend,{SC5->C5_FILIAL,SC5->C5_NUM,SC5->C5_XUSRDIG,SC5->C5_CLIENT,SC5->C5_LOJACLI,SC5->C5_EMISSAO,SC5->C5_VEND1,SC6->C6_PRODUTO,SC6->C6_DESCRI,SC6->C6_TES,SC6->C6_ITEM,SC6->C6_QTDVEN,SC6->C6_PRCVEN,SC6->C6_PRUNIT,SC6->C6_DESCONT,nQtdVen} )
	EndIf

	//If lDelAll  
	//	cObsAux	:= "Pedido nใo serแ atendido devido a corte!"
	//EndIF
	
	lDelAll	:= IIF( nQtdVen <> 0 , .F. , lDelAll )
	
	aadd(aLinha,{"C6_PRODUTO",			SC6->C6_PRODUTO,	Nil})
	aadd(aLinha,{"C6_QTDVEN",			nQtdVen	,			Nil}) 
	
	/* a rotina geni018 nใo estแ carregando a tabela de pre็o e com isso o campo C6_PRUNIT estแ ficando em branco e protheus padrใo estแ calculando o desconto no campo C6_PRUNIT */
	
	If !Empty(SC5->C5_XPEDWEB)  .AND. !Empty(SC5->C5_XPEDOLD) .AND. SC6->C6_PRUNIT == 0
		aadd(aLinha,{"C6_PRUNIT",			Round( ( SC6->C6_VALOR+SC6->C6_VALDESC )/ SC6->C6_QTDVEN,2) ,		Nil})		
	Else
		aadd(aLinha,{"C6_PRUNIT",			SC6->C6_PRUNIT,		Nil})
	EndIf
	
	aadd(aLinha,{"C6_PRCVEN",			SC6->C6_PRCVEN,		Nil})	
	aadd(aLinha,{"C6_ENTREG",			SC6->C6_ENTREG,		NIL})
	aadd(aLinha,{"C6_VALOR", 			nValTot,			NIL})
	aadd(aLinha,{"C6_UM",				SC6->C6_UM, 		NIL})
//	aadd(aLinha,{"C6_TES",				SC6->C6_TES, 		NIL})
	aadd(aLinha,{"C6_LOCAL",			SC6->C6_LOCAL, 		NIL})
	
	nPrunitAux	:= Round( ( SC6->C6_VALOR+SC6->C6_VALDESC )/ SC6->C6_QTDVEN,2)

	nValDesc	:= (nPrunitAux*nQtdVen)-nValTot	//(SC6->C6_PRUNIT*nQtdVen)-nValTot	
	aadd(aLinha,{"C6_DESCONT",			SC6->C6_DESCONT    	, NIL} )
	aadd(aLinha,{"C6_VALDESC", 			nValDesc	    	, NIL} )

	
	aadd(aLinha,{"C6_QTDLIB",			nQtdVen, 			Nil})
	aadd(aLinha,{"C6_QTDEMP",			nQtdVen, 			Nil})	
						
	aAdd(_aItens, aClone(aLinha) )	
	
	IF !Empty(aMailxTes)
		
		nPosMail := aScan(aMailxTes, {|x| SC6->C6_TES $ x[1] } )
		If nPosMail <> 0
			If !(AllTrim(aMailxTes[nPosMail][2]) $ cEmail)
				cEmail += ";"+aMailxTes[nPosMail][2]
			EndIF
		ElseIf Empty(SC5->C5_XPEDWEB)
			If !("vendasp@grupogen.com.br" $ cEmail)
				cEmail += ";vendasp@grupogen.com.br"
			endIf
		EndIf
		
	EndIF
	
	SC6->(DbSkip())
EndDo

If Empty(cEmail)
	cEmail := "cleuto.lima@grupogen.com.br"
EndIf

	/*
	SC9->(DbSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))
	While SC9->(!Eof()) .and. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == SC6->(C6_FILIAL+C6_NUM+C6_ITEM)
		SC9->(a460Estorna())
		SC9->(DbSkip())
	Enddo
	*/

/*
SC6->(DbSetOrder(2))//C6_FILIAL+C6_PRODUTO+C6_NUM+C6_ITEM

For nAuxIt := 1 To Len(aaParam)

	cChavePed := cFilPed+PadR(aaParam[nAuxIt][#"PRODUTO"],nTamProd)+cPedido
	SC6->(DbSeek( cChavePed ))
	
	aLinha	:= {}
	nQtdVen	:= aaParam[nAuxIt][#"QUANTIDADE"]

	aadd(aLinha,{"LINPOS", 				"C6_ITEM",			SC6->C6_ITEM})
	If nQtdVen == 0		
		aAdd(aLinha,{"AUTDELETA",			"S",			 	Nil})	
	Else
		aAdd(aLinha,{"AUTDELETA",			"N",			 	Nil})		
	EndIf
	aadd(aLinha,{"C6_PRODUTO",			SC6->C6_PRODUTO,	Nil})
	aadd(aLinha,{"C6_QTDVEN",			nQtdVen	,			Nil})//SC6->C6_QTDVEN
	aadd(aLinha,{"C6_PRCVEN",			SC6->C6_PRCVEN,		Nil})
	aadd(aLinha,{"C6_PRUNIT",			SC6->C6_PRUNIT,		Nil})
	aadd(aLinha,{"C6_ENTREG",			SC6->C6_ENTREG,		NIL})
	aadd(aLinha,{"C6_VALOR", 			nQtdVen*SC6->C6_PRCVEN,		NIL})//SC6->C6_VALOR
	aadd(aLinha,{"C6_UM",				SC6->C6_UM, 		NIL})
	aadd(aLinha,{"C6_TES",				SC6->C6_TES, 		NIL})
	aadd(aLinha,{"C6_LOCAL",			SC6->C6_LOCAL, 		NIL})
	aadd(aLinha,{"C6_QTDLIB",			nQtdVen, 			Nil})
	
	aAdd(_aItens, aClone(aLinha) )
		
Next nAuxIt
*/

If lDelAll
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifico se todos os itens do pedido serใo deletados pois para ณ
	//ณestes casos o pedido ficara com quantidade 1 e sem libera็ใo   ณ
	//ณde estoque (SC9).                                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	For nAux := 1 To Len(_aItens)			
		nPosQtd := aScan(_aItens[nAux], {|x| x[1] == "C6_QTDVEN" } )
		nPosVal := aScan(_aItens[nAux], {|x| x[1] == "C6_VALOR" } )
		nPosPrc := aScan(_aItens[nAux], {|x| x[1] == "C6_PRCVEN" } )		
		nPosDel := aScan(_aItens[nAux], {|x| x[1] == "AUTDELETA" } )
		
		_aItens[nAux][nPosQtd][2]	:= 1
		_aItens[nAux][nPosVal][2]	:= _aItens[nAux][nPosPrc][2]
		_aItens[nAux][nPosDel][2]	:= "N"
	Next
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCleuto - 17/01/2017            ณ
//ณ                               ณ
//ณrecalculo do valor das parcelasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If SC5->C5_CONDPAG == "099" .AND. !Empty(SC5->C5_XPEDWEB)  .AND. !Empty(SC5->C5_XPEDOLD)
	
	For nAux := 1 To Len(_aItens)
	
		nPosQtd := aScan(_aItens[nAux], {|x| x[1] == "C6_QTDVEN" } )
		nPosVal := aScan(_aItens[nAux], {|x| x[1] == "C6_VALOR" } )
		nPosPrc := aScan(_aItens[nAux], {|x| x[1] == "C6_PRCVEN" } )		
		nPosDel := aScan(_aItens[nAux], {|x| x[1] == "AUTDELETA" } )				
		
		If _aItens[nAux][nPosDel][2] == "N"
			_nTotParc+=_aItens[nAux][nPosQtd][2]*_aItens[nAux][nPosPrc][2]
		EndIf
					
	Next

	aAdd ( _aCabParc , { "C5_FRETE" 	, SC5->C5_FRETE , NIL} )
	
	_aParcItem	:= U_GENI018P(_aCabParc,SC5->C5_XPEDOLD,@cFORMAPG,_nTotParc,@_cMsg,nil,SC5->C5_XPEDWEB)			

	If Empty(_cMsg)
		For _nI := 1 To Len(_aParcItem)																	
			aAdd ( _aCabPed , { "C5_DATA"+_aParcItem[_nI][6] , DataValida(_aParcItem[_nI][1]), Nil} )
			aAdd ( _aCabPed , { "C5_PARC"+_aParcItem[_nI][6] , _aParcItem[_nI][2]            , Nil} )
			nTotPed+=_aParcItem[_nI][2]
		Next
		
		If nTotPed <> SC5->C5_FRETE+_nTotParc
			U_GenSendMail(,,,"noreply@grupogen.com.br",cMonit,Oemtoansi("Erro corte de pedido"+cFilPed+"/"+cPedido),"Valor das parcelas ้ diferente que o valor total do pedido, Vlr.Ped:"+Transform(SC5->C5_FRETE+_nTotParc, "@E 999,999,999.99")+", Vlr.Parcelas:"+Transform(nTotPed, "@E 999,999,999.99"),,,.F.)
			Disarmtransaction()
			Return .F.			  
		EndIf
		
	Else
		U_GenSendMail(,,,"noreply@grupogen.com.br",cMonit,Oemtoansi("Erro corte de pedido"+cFilPed+"/"+cPedido),"Falha no calculo das parcelas"+Chr(13)+Chr(10)+_cMsg,,,.F.)
		Disarmtransaction()
		Return .F.
	EndIf
	
ElseIf SC5->C5_CONDPAG == "099" .AND. (Empty(SC5->C5_XPEDWEB)  .AND. Empty(SC5->C5_XPEDOLD))
	U_GenSendMail(,,,"noreply@grupogen.com.br",cMonit,Oemtoansi("Bloqueio de corte de pedido"+cFilPed+"/"+cPedido),"Pedido com condi็ใo de pagamento tipo 099 e origem diferente de e-Commerce!"+chr(13)+Chr(10)+"Corte nใo serแ realizado!",,,.F.)
	Disarmtransaction()
	Return .F.	
EndIf

SC6->(DbSetOrder(1)) 
SC6->(DbSeek(cFilPed+cPedido)) 
lMSHelpAuto := .f. // para nao mostrar os erro na tela
lMSErroAuto := .f. // inicializa como falso, se voltar verdadeiro e' que deu erro
nOpc	:= 4
MsExecAuto({|x,y,z| MATA410(x,y,z) },_aCabPed,_aItens,nOpc)
//MATA410(_aCabPed,_aItens,nOpc)
If !lMsErroAuto                                       

    If Len(aAtend) > 0
    	lPegouID := .F.
    	For nAuxAtend := 1 To Len(aAtend)
			lAchouZZB := ZZB->(DbSeek( aAtend[nAuxAtend][1]+aAtend[nAuxAtend][8]+aAtend[nAuxAtend][2] ))	
			Reclock("ZZB",!lAchouZZB)
				IF !lAchouZZB
					If !lPegouID
						cIdZZB := GETSXENUM("ZZB","ZZB_MSIDEN")
						ConfirmSX8()
						lPegouID := .T.
					EndIf
					
					/*//Ordem dos campos no array aAtend
					1-  SC5->C5_FILIAL,
					2-  SC5->C5_NUM,
					3-  SC5->C5_XUSRDIG,
					4-  SC5->C5_CLIENT,
					5-  SC5->C5_LOJACLI,
					6-  SC5->C5_EMISSAO,
					7-  SC5->C5_VEND1,
					8-  SC6->C6_PRODUTO,
					9-  SC6->C6_DESCRI,
					10- SC6->C6_TES,
					11- SC6->C6_ITEM,
					12- SC6->C6_QTDVEN,
					13- SC6->C6_PRCVEN,
					14- SC6->C6_PRUNIT,
					15- SC6->C6_DESCONT,
					16- nQtdVen*/
					
					ZZB->ZZB_MSIDEN	:= cIdZZB
					ZZB->ZZB_FILIAL	:= aAtend[nAuxAtend][1]
					ZZB->ZZB_NUM	:= aAtend[nAuxAtend][2]
					ZZB->ZZB_XUSRDI	:= aAtend[nAuxAtend][3]
					ZZB->ZZB_CLIENT	:= aAtend[nAuxAtend][4]
					ZZB->ZZB_LOJA	:= aAtend[nAuxAtend][5]
					ZZB->ZZB_EMISSA	:= aAtend[nAuxAtend][6]
					ZZB->ZZB_VEND1	:= aAtend[nAuxAtend][7]
					ZZB->ZZB_PRODUT	:= aAtend[nAuxAtend][8]
					ZZB->ZZB_DESCRI	:= aAtend[nAuxAtend][9]
					ZZB->ZZB_TES	:= aAtend[nAuxAtend][10]
					ZZB->ZZB_ITEM	:= aAtend[nAuxAtend][11]
					ZZB->ZZB_QTDVEN	:= aAtend[nAuxAtend][12]
					ZZB->ZZB_PRCVEN	:= aAtend[nAuxAtend][13]
					ZZB->ZZB_PRUNIT	:= aAtend[nAuxAtend][14]
					ZZB->ZZB_DESCON	:= aAtend[nAuxAtend][15]
					ZZB->ZZB_QTDENT	:= aAtend[nAuxAtend][16]

				Else
				
					ZZB->ZZB_QTDENT	:= aAtend[nAuxAtend][16]
							
				EndIf											
			MsUnLock()    		
    	Next
    	
    	SC6->(DbSetOrder(1))
    EndIf

	If lDelAll
		SC9->(DbSeek(cFilPed+cPedido))
		While SC9->(!Eof()) .and. SC9->(C9_FILIAL+C9_PEDIDO) == cFilPed+cPedido
			SC9->(a460Estorna())
			SC9->(DbSkip())
		Enddo	
	Else

		SC9->(DbSeek(cFilPed+cPedido))
		While SC9->(!Eof()) .and. SC9->(C9_FILIAL+C9_PEDIDO) == cFilPed+cPedido
			SC9->(a460Estorna())
			SC9->(DbSkip())
		Enddo	
			
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRotina para desbloquear cr้dito para que o pedido seja faturado sem problemasณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//Posiciona na SC9 para confirmar que o pedido foi gravado na tabela
		DbSelectArea("SC9")
		DbSetOrder(1)
		If !DbSeek(xFilial("SC9") + SC5->C5_NUM)
			RecLock("SC5",.F.)
			SC5->C5_LIBEROK := "S"  
			SC5->(msUnlock())

			SC6->(DbSetOrder(1)) 
			SC6->(DbSeek(cFilPed+cPedido))
			While SC6->(!EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
					
				RecLock("SC6",.F.)
				//SC6->C6_QTDLIB := MaLibDoFat(SC6->(Recno()),SC6->C6_QTDVEN)
				
				/*
				ฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				ณFuncao    ณMaLibDoFat                         ณ
				รฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด
				ณParametrosณExpN1: Registro do SC6             ณ
				ณ          ณExpN2: Quantidade a Liberar        ณ
				ณ          ณExpL3: Bloqueio de Credito         ณ
				ณ          ณExpL4: Bloqueio de Estoque         ณ
				ณ          ณExpL5: Avaliacao de Credito        ณ
				ณ          ณExpL6: Avaliacao de Estoque        ณ
				ณ          ณExpL7: Permite Liberacao Parcial   ณ
				ภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				*/				
				
				SC6->C6_QTDLIB := MaLibDoFat(SC6->(Recno()),SC6->C6_QTDVEN,.F.,.F.,.F.,.F.,.F.)						 
				SC6->(msUnlock()) 
						
				SC6->(DbSkip())
			EndDo						
		EndIF
		
		DbSelectArea("SC9")
		
		If SC9->(DbSeek(xFilial("SC9") + SC5->C5_NUM))
			//Verifica se o pedido ficou bloqueado
			_cQuery := " SELECT C9_FILIAL "
			_cQuery += " ,C9_PEDIDO "
			_cQuery += " ,C9_BLCRED "
			_cQuery += " ,R_E_C_N_O_ SC9RECNO "
			_cQuery += " FROM "+RetSqlName("SC9")+" SC9 "
			_cQuery += " WHERE SC9.C9_FILIAL = '"+SC5->C5_FILIAL+"' "
			_cQuery += " AND SC9.C9_PEDIDO = '"+SC5->C5_NUM+"' "
			_cQuery += " AND (SC9.C9_BLEST NOT IN('  ','10') "
			_cQuery += " OR SC9.C9_BLCRED NOT IN('  ','09','10') )"
			_cQuery += " AND SC9.D_E_L_E_T_ = ' ' "
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliSC9,.T.,.T.)
			
			//Percorre todos itens bloqueados no pedido
			While !(_cAliSC9)->(Eof())
				
				//Posiciona a SC9
				SC9->(DbGoTo((_cAliSC9)->SC9RECNO))
				IF 	SC9->(Recno()) == (_cAliSC9)->SC9RECNO
					
					//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
					//ฑฑณ          ณRotina de atualizacao da liberacao de credito                ณฑฑ
					//ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
					//ฑฑณParametrosณExpN1: 1 - Liberacao                                         ณฑฑ
					//ฑฑณ          ณ       2 - Rejeicao                                          ณฑฑ
					//ฑฑณ          ณExpL2: Indica uma Liberacao de Credito                       ณฑฑ
					//ฑฑณ          ณExpL3: Indica uma liberacao de Estoque                       ณฑฑ
					//ฑฑณ          ณExpL4: Indica se exibira o help da liberacao                 ณฑฑ
					//ฑฑณ          ณExpA5: Saldo dos lotes a liberar                             ณฑฑ
					//ฑฑณ          ณExpA6: Forca analise da liberacao de estoque                 ณฑฑ
					//ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
					//ฑฑณDescrio ณEsta rotina realiza a atualizacao da liberacao de pedido de   ณฑฑ
					//ฑฑณ          ณvenda com base na tabela SC9.                                ณฑฑ
					//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
					
					//a450Grava(1,.T.,.F.,.F.) //ALTERADO POR DANILO AZEVEDO 24/04/15 PARA LIBERAR TAMBEM ESTOQUE
					a450Grava(1,.T.,.T.,.F.)
				EndIf
				
				(_cAliSC9)->(DbSkip())
			EndDo
		EndIF
	EndIf	
	
	MailCorte(cFilPed,cPedido,aCorte,cObsAux,cDtPed,lDelAll,cEmail,cCopMail)
	/*
	If Select("TMP_DESC") > 0
		TMP_DESC->(DbCloseArea())
	EndIf	
	
	BeginSql Alias "TMP_DESC"
		SELECT SC6.* FROM %Table:SC6% SC6
		JOIN %Table:SC5% SC5
		ON C5_FILIAL = C6_FILIAL
		AND C5_NUM = C6_NUM
		AND SC6.%NotDel%
		WHERE C6_FILIAL = %xFilial:SC6%
		AND C6_NUM = %Exp:cPedido%
		AND SC6.%NotDel%
		AND EXISTS(
		  SELECT 1 FROM TOTVS_AUDIT.AUDIT_TRAIL
		  WHERE AT_RECID = SC6.R_E_C_N_O_
		  AND AT_TABLE LIKE '%SC6%'
		  AND ( AT_FIELD LIKE '%C6_DESCONT%' OR AT_FIELD LIKE '%C6_PRCVEN%' OR AT_FIELD LIKE '%C6_VALOR%' OR AT_FIELD LIKE '%C6_VALDESC%' )
		  )
			ORDER BY C6_ITEM 
	EndSql
	
	TMP_DESC->(DbGoTop())
	If TMP_DESC->(!EOF())
		cMsgVld	:= "Detectada possํvel inconsistencia no valor de desconto do pedido de venda "+cPedido
		U_GenSendMail(,,,"noreply@grupogen.com.br",cMonit,oemtoansi("problema de desconto corte pedido "+cFilPed+"/"+cPedido),cMsgVld,,,.F.)	
	EndIf
	
	TMP_DESC->(DbCloseArea())
		*/
Else
	lRet   		:= .F.	
	_cErroLg	:= ""
	_cErroLg	:= AllTrim(MostraErro())
	
	If Empty(_cErroLg)
		_aErro := GetAutoGRLog()
		For _ni := 1 To Len(_aErro)
			_cErroLg += _aErro[_ni] + Chr(13)+Chr(10)
		Next _ni
	EndIF
				
	U_GenSendMail(,,,"noreply@grupogen.com.br",cMonit,oemtoansi("erro corte de pedido"+cFilPed+"/"+cPedido),_cErroLg,,,.F.)
	
	Disarmtransaction()
EndIf

										
Return lRet   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJFWMS002  บAutor  ณMicrosiga           บ Data ณ  05/25/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MailCorte(cFilPed,cPedido,aCorte,cObsAux,cDtPed,lDelAll,cEmail,cCopMail)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local oProcess		:= nil
Local cForm			:= IIF( lDelAll , "\workflow\html\CancelCortePedido.htm", "\workflow\html\CortePedido.htm")
Local cfiletmp		:= CriaTrab(nil,.F.) 
Local cTemp			:= "c:\temp\"
Local cCorpo		:= ""

WfForceDir(cTemp)

cTitulo := IIF( lDelAll , "Comunicamos que o pedido a seguir nรฃo serรก atendido devido a corte na quantidade.", "Comunicamos que foi realizado corte de quantidade para o pedido a seguir.")

cCorpo	:= LayMail(cFilPed,cPedido,aCorte,cObsAux,cDtPed,lDelAll,cEmail,cTitulo)

U_GenSendMail(,,,"noreply@grupogen.com.br",cEmail+";"+cCopMail,oemtoansi("Corte de Pedido "+cPedido),cCorpo,,,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera objeto html.                                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
oProcess := TWFProcess():New( "000001", "Corte de Pedido" )
oProcess:NewTask("Certificados",cForm)
oProcess:cTo		:= cEmail
oProcess:csubject	:= "Corte de Pedido "+cPedido

oProcess:ohtml:ValByName("cFilPed"		, cFilPed )
oProcess:ohtml:ValByName("cNumPed"		, cPedido )
oProcess:ohtml:ValByName("cDtPed"		, cDtPed )

For nAux := 1 To Len(aCorte)
	aAdd( (oProcess:oHtml:ValByName( "t1.0"    )), aCorte[nAux,1]    )	//Item
	aAdd( (oProcess:oHtml:ValByName( "t1.1"    )), aCorte[nAux,2]    )	//Produto
	aAdd( (oProcess:oHtml:ValByName( "t1.2"    )), aCorte[nAux,3]    )	//Desc.
	aAdd( (oProcess:oHtml:ValByName( "t1.3"    )), aCorte[nAux,4]    )	//De Qtd.
	aAdd( (oProcess:oHtml:ValByName( "t1.4"    )), aCorte[nAux,5]    )	//Para Qtd.
	aAdd( (oProcess:oHtml:ValByName( "t1.5"    )), aCorte[nAux,6]    )	//De Vlr.Total
	aAdd( (oProcess:oHtml:ValByName( "t1.6"    )), aCorte[nAux,7]    )	//Para Vlr.Tota		
	aAdd( (oProcess:oHtml:ValByName( "t1.7"    )), aCorte[nAux,8]    )	//
Next

oProcess:start()   
*/
/*
oProcess:Finish()

nHdl := FT_FUSE(cTemp+cfiletmp)
FT_FGOTOP()
While !FT_FEOF()    
    cCorpo+=Alltrim(FT_FREADLN())+chr(13)+Chr(10)
    FT_FSKIP()
EndDo
FT_FUSE()    
*/	
Return nil  

Static Function LayMail(cFilPed,cPedido,aCorte,cObsAux,cDtPed,lDelAll,cEmail,cTitulo) 

Local cHtml 	:= "" 
Local cQuebra	:= Chr(13)+Chr(10)
Local nAux

cHtml += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'+cQuebra
cHtml += '<html xmlns="http://www.w3.org/1999/xhtml"> '+cQuebra
cHtml += ' <head> '+cQuebra
cHtml += ' <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> '+cQuebra
cHtml += ' <title>Untitled Document</title> '+cQuebra
cHtml += ' <style type="text/css"> '+cQuebra
cHtml += ' <!-- '+cQuebra
cHtml += ' .style30 { '+cQuebra
cHtml += ' 	font-family: Geneva, Arial, Helvetica, sans-serif; '+cQuebra
cHtml += ' 	font-size: 9px; '+cQuebra
cHtml += ' 	color: #FFFFFF; '+cQuebra
cHtml += ' } '+cQuebra
cHtml += ' .style53 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; } '+cQuebra
cHtml += ' .style54 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; } '+cQuebra
cHtml += ' .style56 {color: #000000; font-size: 12px; font-family: Geneva, Arial, Helvetica, sans-serif; font-weight: bold; } '+cQuebra
cHtml += ' .style57 {color: #333333} '+cQuebra
cHtml += ' .style58 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; color: #333333; } '+cQuebra
cHtml += ' .style59 {font-size: 18px; font-weight: bold; font-family: Geneva, Arial, Helvetica, sans-serif;} '+cQuebra
cHtml += ' .style60 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; color: #333333; } '+cQuebra
cHtml += ' .style62 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px;  }'+cQuebra
cHtml += ' .style63 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; color: #FF0000; } '+cQuebra
cHtml += ' --> '+cQuebra
cHtml += ' </style> '+cQuebra
cHtml += ' </head> '+cQuebra
cHtml += ' <body> '+cQuebra
cHtml += ' <table width="612" border="0" align="center"> '+cQuebra
cHtml += ' <td width="670" bgcolor="#FFFFFF"><div align="center"> '+cQuebra
cHtml += '   <!--<p><img src="log_GenAtlas.png" width="200" height="108" /></p> -->'+cQuebra
cHtml += '   <table width="603" border="0"> '+cQuebra
cHtml += '   '+cQuebra
cHtml += '     <tr> '+cQuebra
cHtml += '       <td colspan="4"><div align="center" class="style57"><span class="style59">Aviso de corte de pedido</span></div></td> '+cQuebra
cHtml += '     </tr> '+cQuebra
cHtml += '     '+cQuebra
cHtml += '	 <tr> '+cQuebra
cHtml += '       <td colspan="4"><div align="center" class="style57">__________________________________________________________________________</div></td> '+cQuebra
cHtml += '     </tr> '+cQuebra
cHtml += '     '+cQuebra
cHtml += '	 <tr> '+cQuebra
cHtml += '       <td width="145">'+cQuebra
cHtml += '		<div align="LEFT" class="style60">'+cQuebra
cHtml += '			<table align="LEFT" width="600"> 				'+cQuebra
cHtml += '				<tr>'+cQuebra
cHtml += '					<td><span>'+cTitulo+'</span></td>'+cQuebra
cHtml += '				</td>'+cQuebra
cHtml += '			  <tr> '+cQuebra
cHtml += '				<td>&nbsp;</td> '+cQuebra
cHtml += '			  </tr> 				'+cQuebra
cHtml += '				<tr> '+cQuebra
cHtml += '					<td>'+cQuebra
cHtml += '						<table width="580" border="0">'+cQuebra
cHtml += '						  <tr>'+cQuebra
cHtml += '							<td><span class="style7"><strong>Filial:</strong> '+cFilPed+'</span></td>'+cQuebra
cHtml += '						  </tr>'+cQuebra
cHtml += '						  <tr>'+cQuebra
cHtml += '							<td><span class="style7"><strong>Pedido:</strong> '+cPedido+'</span></td>'+cQuebra
cHtml += '						  </tr>'+cQuebra
cHtml += '						  <tr>'+cQuebra
cHtml += '							<td><span class="style7"><strong>Data:</strong> '+DtoC(cDtPed)+'</span></td>'+cQuebra
cHtml += '						  </tr>					  '+cQuebra
cHtml += '						  <tr>'+cQuebra
cHtml += '							<td><table width="595" border="0">'+cQuebra
cHtml += '							  <tr>'+cQuebra
cHtml += '							    <td width="02%" bgcolor="#003B6B"><div align="center"><span class="style16">Item</span></div></td>'+cQuebra
cHtml += '								<td width="18%" bgcolor="#003B6B"><div align="center"><span class="style16">Produto</span></div></td>'+cQuebra
cHtml += '								<td width="40%" bgcolor="#003B6B"><div align="center"><span class="style16">Desc.</span></div></td>'+cQuebra
cHtml += '								<td width="40%" bgcolor="#003B6B"><div align="center"><span class="style16">De Qtd.</span></div></td>'+cQuebra
cHtml += '								<td width="40%" bgcolor="#003B6B"><div align="center"><span class="style16">Para Qtd.</span></div></td>'+cQuebra
cHtml += '								<td width="40%" bgcolor="#003B6B"><div align="center"><span class="style16">De Vlr.Total</span></div></td>'+cQuebra
cHtml += '								<td width="40%" bgcolor="#003B6B"><div align="center"><span class="style16">Para Vlr.Total</span></div></td>'+cQuebra
cHtml += '								<td width="40%" bgcolor="#003B6B"><div align="center"><span class="style16">Obs.</span></div></td>'+cQuebra
cHtml += '							  </tr>'+cQuebra

For nAux := 1 To Len(aCorte)
	cHtml += '							  <tr>'+cQuebra
	cHtml += '								<td><div align="center"><span class="style62">'+aCorte[nAux,1]+'</span></div></td>'+cQuebra
	cHtml += '								<td><div align="LEFT"><span class="style62">'+aCorte[nAux,2]+'</span></div></td>'+cQuebra
	cHtml += '								<td><div align="center"><span class="style62">'+aCorte[nAux,3]+'</span></div></td>'+cQuebra
	cHtml += '								<td><div align="center"><span class="style62">'+AllTrim(Str(aCorte[nAux,4]))+'</span></div></td>'+cQuebra
	cHtml += '								<td><div align="center"><span class="style62">'+AllTrim(Str(aCorte[nAux,5]))+'</span></div></td>'+cQuebra
	cHtml += '								<td><div align="center"><span class="style62">'+AllTrim(Str(aCorte[nAux,6]))+'</span></div></td>'+cQuebra
	cHtml += '								<td><div align="center"><span class="style62">'+AllTrim(Str(aCorte[nAux,7]))+'</span></div></td>'+cQuebra
	cHtml += '								<td><div align="center"><span class="style62">'+aCorte[nAux,8]+'</span></div></td>'+cQuebra
	cHtml += '							  </tr>'+cQuebra
Next

cHtml += '								</table>'+cQuebra
cHtml += '							</td>'+cQuebra
cHtml += '					</td>'+cQuebra
cHtml += '				</td>'+cQuebra
cHtml += '				<tr> '+cQuebra
cHtml += '					<td>&nbsp;</td> '+cQuebra
cHtml += '				</tr> 						'+cQuebra
cHtml += '			  <tr> '+cQuebra
cHtml += '				<td>&nbsp;</td> '+cQuebra
cHtml += '			  </tr> 				'+cQuebra
cHtml += '				<tr>'+cQuebra
cHtml += '					<td>'+cQuebra
cHtml += '						Workflow Protheus'+cQuebra
cHtml += '					</td>'+cQuebra
cHtml += '				</td>				'+cQuebra
cHtml += '			</table>'+cQuebra
cHtml += ''+cQuebra
cHtml += '		</div>'+cQuebra
cHtml += '	   </td> '+cQuebra
cHtml += '	   '+cQuebra
cHtml += '	 </tr>   '+cQuebra
cHtml += '   </table>'+cQuebra
cHtml += '</td> '+cQuebra
cHtml += '   <div align="left"></div> '+cQuebra
cHtml += '   </div></td> '+cQuebra
cHtml += ' 	  <tr> '+cQuebra
cHtml += ' 	    <td>&nbsp;</td> '+cQuebra
cHtml += ' 	  </tr> '+cQuebra
cHtml += ' 	<div align="center"></div> '+cQuebra
cHtml += '	 <tr> '+cQuebra
cHtml += '       <td colspan="4"><div align="center" class="style57">__________________________________________________________________________</div></td> '+cQuebra
cHtml += '     </tr> 	'+cQuebra
cHtml += '  </table> 	'+cQuebra
cHtml += '</body> '+cQuebra
cHtml += '</html>  '+cQuebra

Return cHtml
