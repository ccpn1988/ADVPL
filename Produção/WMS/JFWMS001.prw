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
ฑฑบDesc.     ณPrceossa fila de gera็ใo de notas fiscais WMS.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN.                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function JFWMS1F1()

Local aParam	:= {"1","00","1022","",""}

U_JFWMS001(aParam)

Return nil

User Function JFWMS1F2()

Local aParam	:= {"2","00","1022","",""}

U_JFWMS001(aParam)

Return nil

User Function JFWMS1F3()

Local aParam	:= {"3","00","1022","",""}

U_JFWMS001(aParam)

Return nil

User Function JFWMS1F4()

Local aParam	:= {"4","00","1022","",""}

U_JFWMS001(aParam)

Return nil

User Function JFWMS001(aParam)

Local cIdDila		:= ""
Local alEmp 		:= {}
Local lEmp			:= Type('cFilAnt') == "C" .AND. Select("SM0") <> 0
Local nAuxEmp		:= 0
Local nX			:= 0
Local nLimite		:= 50  
Local nFilaExec	:= 0
Local nQtdFila	:= 10

Default aParam	:= {"1","00","1022","",""}
Default cIdDila	:= "1"

cIdDila		:= aParam[1]

Conout("JFWMS001 - Fila - "+cIdDila+" - Fila - "+cIdDila+" - Iniciando Job - fila de processos WMS - "+Time()+".")

If !lEmp		
	RpcSetType(2)
	lOpenSM0 := RpcSetEnv( "00" , "1022")
	If !lOpenSM0
		ConOut("")
	   	ConOut(Replicate("+",nLimite))
	   	ConOut(Padc("JFWMS001 - Nao foi possivel incializar ambiente confirme a senha/usuario digitado. "+Dtoc(Date())+" "+Time(),nLimite))
	   	ConOut(Replicate("+",nLimite))
	   	ConOut("") 
	   	RpcClearEnv()
		Return Nil
	Else
		Conout("JFWMS001 - Fila - "+cIdDila+" - Abrindo empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())		
	EndIf
EndIF   

/*
While !LockByName("JFWMS001F"+cIdDila,.T.,.T.,.T.)
    nX++
	Sleep(10)
	If nX > 2     
		Conout("JFWMS001 - Fila - "+cIdDila+" - Nใo foi possํvel executar a fila WMS neste momento pois a fun็ใo JFWMS001 jแ esta sendo executada por outra processamento!"+DTOC(DDataBase)+" "+Time())
		Return .F.
    EndIf
EndDo
*/

If !LockByName("JFWMS001F"+cIdDila,.T.,.T.,.T.)     
	Conout("JFWMS001 - Fila - "+cIdDila+" - Nใo foi possํvel executar a fila WMS neste momento pois a fun็ใo JFWMS001 jแ esta sendo executada por outra processamento!"+DTOC(DDataBase)+" "+Time())
	Return .F.
Else	
	Conout("JFWMS001 - Fila - "+cIdDila+" - Lock com sucesso!"+DTOC(DDataBase)+" "+Time())
EndIf

For nFilaExec := 1 To nQtdFila 
	ProcFila(cIdDila)	
	Sleep(3500)
Next nFilaExec	

If !lEmp .AND. Type('cFilAnt') == "C"
	Conout("JFWMS001 - Fila - "+cIdDila+" - Fechando empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())	
	RpcClearEnv()
EndIF

UnLockByName("JFWMS001F"+cIdDila,.T.,.T.,.T.)

Conout("JFWMS001 - Fila - "+cIdDila+" - Finalizando Job - fila de processos WMS - "+Time()+".")

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
Static Function ProcFila(cIdDila)

Local cAliasZZ5	:= GetNextAlias()
Local cSqlZZ5 	:= ""
Local cQuebra		:= Chr(13)+Chr(10)
Local nRegProc	:= 0  
Local cNota		:= ""
Local cSerie		:= SuperGetmv("GEN_FAT113",.f.,"10")

Local _cServ		:= SuperGetmv("GEN_FAT110",.f.,"10.1.0.243")//IP do servidor
Local _nPort		:= SuperGetmv("GEN_FAT111",.f.,1888) //Porta de conexใo do servidor
Local _cAmb		:= SuperGetmv("GEN_FAT112",.f.,"SCHEDULE") //Ambiente do servidor

Local aRet			:= {"",""}

Local cIdPedido	:= ""
Local cFilAux		:= ""
Local cPedido		:= ""
Local nRomaneio	:= 0
					    	
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
cSqlZZ5 += " AND ZZ5_IDFUNC = '0001' "+cQuebra
cSqlZZ5 += " AND ZZ5_STATUS = '00' "+cQuebra//00=Aguardando processamento;01=Processo finalizad;99=Falha de processamento
cSqlZZ5 += " AND ZZ5.D_E_L_E_T_ <> '*' "+cQuebra

/* controle para nใo permitir pesar o mesmo produto ao mesmo tempo por filas diferente
cSqlZZ5 += " AND EXISTS(   "+cQuebra 
cSqlZZ5 += "   SELECT 1 FROM ZZ5000 ZZ5EXT "+cQuebra 
cSqlZZ5 += "   JOIN SC6000 SC6 "+cQuebra 
cSqlZZ5 += "   ON ZZ5EXT.ZZ5_FILIAL = C6_FILIAL "+cQuebra 
cSqlZZ5 += "   AND ZZ5EXT.ZZ5_PEDIDO = C6_NUM "+cQuebra 
cSqlZZ5 += "   AND SC6.D_E_L_E_T_ <> '*' "+cQuebra 
cSqlZZ5 += "   WHERE ZZ5EXT.ZZ5_IDFUNC = '0001' "+cQuebra 
cSqlZZ5 += "   AND ZZ5EXT.ZZ5_STATUS = '00' "+cQuebra 
cSqlZZ5 += "   AND ZZ5EXT.D_E_L_E_T_ <> '*' "+cQuebra 
  
cSqlZZ5 += "   AND ZZ5.ZZ5_IDFILA = ZZ5EXT.ZZ5_IDFILA "+cQuebra 
  
cSqlZZ5 += "   AND NOT EXISTS( "+cQuebra 
cSqlZZ5 += "     SELECT 1 FROM SC6000 SC6_AUX "+cQuebra 
cSqlZZ5 += "     JOIN ZZ5000 ZZ5_AUX "+cQuebra 
cSqlZZ5 += "     ON ZZ5_AUX.ZZ5_FILIAL = SC6_AUX.C6_FILIAL "+cQuebra 
cSqlZZ5 += "     AND ZZ5_AUX.ZZ5_PEDIDO = SC6_AUX.C6_NUM "+cQuebra 
cSqlZZ5 += "     AND ZZ5_AUX.D_E_L_E_T_ <> '*' "+cQuebra 
cSqlZZ5 += "     AND ZZ5_STATUS = '00' "+cQuebra 
cSqlZZ5 += "     AND ZZ5_AUX.ZZ5_IDFUNC = '0001'   "+cQuebra 
cSqlZZ5 += "     WHERE SC6_AUX.C6_FILIAL = SC6.C6_FILIAL "+cQuebra 
cSqlZZ5 += "     AND SC6_AUX.C6_NUM <> SC6.C6_NUM "+cQuebra 
cSqlZZ5 += "     AND SC6_AUX.C6_PRODUTO = SC6.C6_PRODUTO "+cQuebra 
cSqlZZ5 += "     AND SC6_AUX.D_E_L_E_T_ <> '*' "+cQuebra 
cSqlZZ5 += "     AND ZZ5_AUX.ZZ5_IDFILA < ZZ5EXT.ZZ5_IDFILA "+cQuebra 
cSqlZZ5 += "   ) "+cQuebra 
cSqlZZ5 += " ) "+cQuebra 
*/

If Mod(Val(cIdDila),2) == 0
	//cSqlZZ5 += " AND MOD(to_number(ZZ5_IDFILA),2) = 0"
	cSqlZZ5 += " AND MOD(TO_NUMBER(nvl(TRIM( regexp_replace( regexp_replace(regexp_replace(TRIM(ZZ5_IDFILA),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)),2) = 0 "+cQuebra
Else
	//cSqlZZ5 += " AND MOD(to_number(ZZ5_IDFILA),2) <> 0"	
	cSqlZZ5 += " AND MOD(TO_NUMBER(nvl(TRIM( regexp_replace( regexp_replace(regexp_replace(TRIM(ZZ5_IDFILA),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)),2) <> 0 "+cQuebra
EndIf
cSqlZZ5 += " ORDER BY ZZ5_QTDPRC,ZZ5.R_E_C_N_O_ "+cQuebra

MemoWrite("JFWMS001.sql",cSqlZZ5)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cSqlZZ5),cAliasZZ5,.T.,.T.)

Conout("JFWMS001 - Fila - "+cIdDila+" - Iniciando processamento da tabela ZZ5 "+Time())

(cAliasZZ5)->(DbGoTop())
While (cAliasZZ5)->(!EOF())
	
	nRegProc++
	
	ZZ5->(DbGoTo((cAliasZZ5)->ZZ5REC))
    
   IF ZZ5->(!EOF())
    	If SOFTLOCK("ZZ5") .AND. ZZ5->ZZ5_STATUS == "00"
			Conout("JFWMS001 - Fila - "+cIdDila+" - Iniciando processamento do registro "+ZZ5->ZZ5_IDFILA+" "+Time())
    	    
    		SC5->(DbSetOrder(1))
    		
    		cChaveSC5	:= ZZ5->ZZ5_FILIAL+ZZ5->ZZ5_PEDIDO
    		If SC5->(DbSeek( cChaveSC5 ))
    		    
    		    If SC5->C5_XROMANE <> ZZ5->ZZ5_ROMANE
    		    	RecLock("SC5",.F.)
    		    	SC5->C5_XROMANE	:= ZZ5->ZZ5_ROMANE
    		    	SC5->(MsUnLock())
    		    	SOFTLOCK("ZZ5")
    		    EndIf
    		    
    			cNota	:= ""
    			
				If SC9->(dbSeek(SC5->C5_FILIAL+SC5->C5_NUM ))					
						/*
						_cServ	:= "10.3.0.72"			//IP do servidor
						_nPort	:= 1229           		//Porta de conexใo do servidor
						_cAmb	:= "HML_WMS"     //Ambiente do servidor
						*/
						_cEmpCd	:= "00"          		//Empresa de conexใo
						_cEmpFl	:= ZZ5->ZZ5_FILIAL		//Filial de conexใo
						
						If _cEmpFl <> cFilAnt 
							CREATE RPCCONN _oServer ON  SERVER _cServ 			;   //IP do servidor
							PORT  _nPort           								;   //Porta de conexใo do servidor
							ENVIRONMENT _cAmb       							;   //Ambiente do servidor
							EMPRESA _cEmpCd          							;   //Empresa de conexใo
							FILIAL  _cEmpFl          							;   //Filial de conexใo
							TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que serใo abertas
							MODULO  "SIGAFAT"               					//M๓dulo de conexใo
								
							If ValType(_oServer) == "O"														
								_oServer:CallProc("RPCSetType", 2)
								cNota	:= ""							
								aRet	:= _oServer:CallProc("U_JFWMS01B",cSerie,SC5->C5_FILIAL,SC5->C5_NUM,ZZ5->(Recno()),Alltrim(ZZ5->ZZ5_DADOS),cIdDila)
								cNota	:= aRet[1]
								//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
								//ณRealizando a nova conexใo para entrar na empresa e filial corretaณ
								//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
								//Fecha a Conexao com o Servidor
								RESET ENVIRONMENT IN SERVER _oServer
								CLOSE RPCCONN _oServer
								_oServer := Nil
							EndIf
						Else
							ZZ5->(DbGoTo((cAliasZZ5)->ZZ5REC))
							If Empty(ZZ5->ZZ5_NOTA) 
								cNota	:= ""							
								aRet	:= U_JFWMS01B(cSerie,SC5->C5_FILIAL,SC5->C5_NUM,ZZ5->(Recno()),Alltrim(ZZ5->ZZ5_DADOS),cIdDila)
								cNota	:= aRet[1]								
							EndIf	
						EndIf
						
						If !Empty(cNota)
							If ZZ5->ZZ5_STATUS <> "01"
								RecLock("ZZ5",.F.)
								ZZ5->ZZ5_QTDPRC	:= ZZ5->ZZ5_QTDPRC+1               
						    	ZZ5->ZZ5_STATUS	:= "01"
						    	ZZ5->ZZ5_NOTA		:= cNota
						    	ZZ5->ZZ5_SERIE	:= cSerie  
						    	ZZ5->ZZ5_DTNF		:= DDataBase
						    	ZZ5->ZZ5_DTUPDA	:= DDATABASE
						    	ZZ5->ZZ5_HRUPDA	:= Time()
						    	ZZ5->ZZ5_MSG		:= "Realizado processamento da nota fiscal!"
						    	ZZ5->(MsUnLock())					    	
						    	SOFTLOCK("ZZ5")
						    	
						    	cIdPedido	:= ZZ5->ZZ5_IDPEDI
						    	cFilAux	:= ZZ5->ZZ5_FILIAL
						    	cPedido	:= ZZ5->ZZ5_PEDIDO
						    	nRomaneio	:= ZZ5->ZZ5_ROMANE
								nNota		:= Val(cNota)
								nSerie		:= Val(cSerie)
								cUsrPesa	:= ZZ5->ZZ5_USUBAN
				    			
				    			nAreaZZ5	:= ZZ5->(GetArea())
				    			
				    			ZZ5->(DbSetOrder(3))
				    			If !ZZ5->(DbSeek( xFilial("ZZ5")+cNota+PadR(cSerie,TamSX3("ZZ5_SERIE")[1])+cPedido+"0004" ))  
					    			Conout("Gerando ZZ5 - 0004")
							    	cNextNum := U_xGenSXE("ZZ5","ZZ5_IDFILA",4)//GetSX8Num("ZZ5","ZZ5_IDFILA",NIL,4)
			    					ConfirmSX8()
								// gerar registro apra transmissใo		
									RecLock("ZZ5",.T.)
									ZZ5->ZZ5_FILIAL	:= cFilAux
									ZZ5->ZZ5_IDFILA	:= cNextNum
									ZZ5->ZZ5_STATUS	:= "00"//00=Aguardando processamento;01=Processo finalizad;99=Falha de processamento                                                     
									ZZ5->ZZ5_IDFUNC	:= "0004"
									ZZ5->ZZ5_DESC		:= "Transmissใo de notas fiscal"
									ZZ5->ZZ5_IDPEDI	:= cIdPedido
									ZZ5->ZZ5_PEDIDO	:= cPedido
									ZZ5->ZZ5_DATA		:= DDataBase
									ZZ5->ZZ5_HORA		:= Time()
									ZZ5->ZZ5_ROMANE	:= nRomaneio
									ZZ5->ZZ5_NOTA		:= cNota
									ZZ5->ZZ5_SERIE	:= cSerie  
									ZZ5->ZZ5_DTNF		:= DDataBase
									ZZ5->ZZ5_DADOS	:= "" 
									ZZ5->ZZ5_CHVASS	:= ""
									ZZ5->ZZ5_USUBAN	:= cUsrPesa
									ZZ5->ZZ5_MSG		:= "Aguardando transmissใo nota fiscal!"
									ZZ5->(MsUnLock())
								EndIf
								
								RestArea(nAreaZZ5)
								
							EndIf    	
						Else
							ZZ5->(DbGoTo((cAliasZZ5)->ZZ5REC))
							If Empty(ZZ5->ZZ5_NOTA)						
					    		RecLock("ZZ5",.F.)
					    		ZZ5->ZZ5_QTDPRC	:= iif( ZZ5->ZZ5_QTDPRC >= 9999 , 0 , ZZ5->ZZ5_QTDPRC )+1
					    		ZZ5->ZZ5_DTUPDA	:= DDATABASE
					    		ZZ5->ZZ5_HRUPDA	:= Time()				    		
								ZZ5->ZZ5_MSG		:= aRet[2]
					    		ZZ5->(MsUnLock())
					    	EndIf	 
				    		Conout("JFWMS001 - Fila - "+cIdDila+" - Nใo foi possํvel gerer a nota fiscal"+ZZ5->ZZ5_IDFILA+" "+Time())
						EndIF 

				Else
		    		RecLock("ZZ5",.F.)
		    		ZZ5->ZZ5_QTDPRC	:= iif( ZZ5->ZZ5_QTDPRC >= 9999 , 0 , ZZ5->ZZ5_QTDPRC )+1  
		    		ZZ5->ZZ5_DTUPDA	:= DDATABASE
		    		ZZ5->ZZ5_HRUPDA	:= Time()		    		
		    		ZZ5->ZZ5_MSG	:= "Pedido nใo liberado SC9"
		    		ZZ5->(MsUnLock())    		
	    			Conout("JFWMS001 - Fila - "+cIdDila+" - Pedido nใo liberado SC9 "+ZZ5->ZZ5_IDFILA+" "+Time())
				Endif     

    		Else 
	    		RecLock("ZZ5",.F.)
	    		ZZ5->ZZ5_QTDPRC	:= iif( ZZ5->ZZ5_QTDPRC >= 9999 , 0 , ZZ5->ZZ5_QTDPRC )+1 
	    		ZZ5->ZZ5_DTUPDA	:= DDATABASE
	    		ZZ5->ZZ5_HRUPDA	:= Time()	    		
	    		ZZ5->(MsUnLock())    		
    			Conout("JFWMS001 - Fila - "+cIdDila+" - Pedido nใo localizado na base "+ZZ5->ZZ5_IDFILA+" "+Time())
    		EndIF
    	       	
    	Else
    		Conout("JFWMS001 - Fila - "+cIdDila+" - Registro sendo processado por outra fila "+ZZ5->ZZ5_IDFILA+" "+Time())		
    	EndIF
   Else
    	Conout("JFWMS001 - Fila - "+cIdDila+" - Falha ao posicionar registro na tabela ZZ5 "+" "+Time())		
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


User Function JFWMS01B(cSerie,cFilPed,cNumPed,nRecZZ5,cParam,cIdDila) 

Local cNota		:= "" 
Local aPvlNfs	:= {}
Local aaParam	:= Array(#)
Local aRet		:= {"",""}
Local cAliVld	:= GetNextAlias()
Local cMonit	:= GetMv("GEN_EST007")
Local lValidWMS	:= .T.

aaParam	:= FromJson(cParam)

SC5->(DbSetOrder(1))
SC6->(DbSetOrder(1))

SC5->(DbSeek(cFilPed+cNumPed))

If !Empty(SC5->C5_NOTA)
	Conout("JFWMS001 - Fila - "+cIdDila+" - PEDIDO Jม GEROU NOTA FISCAL - "+cFilAnt+" - "+ZZ5->ZZ5_IDFILA+" "+Time())						
	aRet[2] := "Pedido "+SC5->C5_NUM+" jแ gerou nota fiscal - "+SC5->C5_NOTA
	aRet[1] := SC5->C5_NOTA
	Return aRet 
EndIf

RecLock("SC5",.F.)
SC5->C5_PBRUTO  := Val(aaParam[#"PESBRU"])
SC5->C5_PESOL   := Val(aaParam[#"PESLIQ"])
SC5->C5_VOLUME1 := Val(aaParam[#"VOLUCX"])
MsUnLock()

lVerSC9 := .T.
nContSC9 := 0

While lVerSC9

	If Select(cAliVld) > 0
		(cAliVld)->(DbCloseArea())
	EndIf

	Beginsql Alias cAliVld
		SELECT * FROM %Table:SC6% SC6
		WHERE C6_FILIAL = %Exp:SC5->C5_FILIAL%
		AND C6_NUM = %Exp:SC5->C5_NUM%
		AND SC6.%NotDel%
		AND C6_QTDVEN <> (
		  SELECT SUM(C9_QTDLIB) FROM %Table:SC9% SC9
		  WHERE C9_FILIAL = C6_FILIAL
		  AND C9_PEDIDO = C6_NUM
		  AND C9_PRODUTO = C6_PRODUTO
		  AND C9_ITEM = C6_ITEM
		  AND SC9.%NotDel%
		)
	EndSql

	(cAliVld)->(DbGoTop())
	If (cAliVld)->(!EOF())
		(cAliVld)->(DbCloseArea())
		
		If nContSC9 = 0
			JFVERSC9(SC5->C5_FILIAL,SC5->C5_NUM) //Funcao para corrigir a possivel duplicidade no SC9
		Else
			aRet[1] := ""
			aRet[2] := "Pedido:"+SC5->C5_NUM+",Detectada inconsist๊ncia na libera็ใo do pedido, a quantidade liberada estแ diferente da quantidade do pedido!"+SC5->C5_NUM
			U_GenSendMail(,,,"noreply@grupogen.com.br",cMonit,oemtoansi("Pedido:"+SC5->C5_NUM+",Detectada inconsist๊ncia na libera็ใo do pedido"),aRet[2],,,.F.)
			Return aRet
		EndIf
	Else
		(cAliVld)->(DbCloseArea())
		lVerSC9 := .F.	
	EndIf
	
	nContSC9++
	
EndDo

If Select(cAliVld) > 0
	(cAliVld)->(DbCloseArea())	
EndIf

Beginsql Alias cAliVld
	SELECT * FROM (
	SELECT C5_FILIAL,C5_NUM,COUNT(*) QTD_IT_PED,
	(
	SELECT COUNT(*) FROM GUA_PEDIDOS.DPS_D04_ROMANEIO ROMA
	JOIN GUA_PEDIDOS.DPS_D05_ITENS_ROMANEIO ITENS
	ON ROMA.D04_NR_ROMANEIO = ITENS.D04_NR_ROMANEIO
	WHERE TRIM(ROMA.D04_TX_EMPRESA) = TRIM(I10.SIGLAGEN)
	AND ROMA.D04_NR_PEDIDO = TO_NUMBER(TRIM(SC5.C5_NUM))
	AND D05_NR_QUANTIDADE > 0
	) QTD_WMS,
	(
	SELECT SUM(ITENS.D05_NR_QUANTIDADE) FROM GUA_PEDIDOS.DPS_D04_ROMANEIO ROMA
	JOIN GUA_PEDIDOS.DPS_D05_ITENS_ROMANEIO ITENS
	ON ROMA.D04_NR_ROMANEIO = ITENS.D04_NR_ROMANEIO
	WHERE TRIM(ROMA.D04_TX_EMPRESA) = TRIM(I10.SIGLAGEN)
	AND ROMA.D04_NR_PEDIDO = TO_NUMBER(TRIM(SC5.C5_NUM))
	AND D05_NR_QUANTIDADE > 0
	) QTD_EXEM,
	SUM(SC6.C6_QTDVEN) C6_QTDVEN
	FROM %Table:SC5% SC5
	JOIN TT_I10_FILIAL_GEN_TOTVS I10  
	ON I10.IDEMPRESATOTVS = TO_NUMBER(TRIM(SC5.C5_FILIAL))
	JOIN %Table:SC6% SC6
	ON C6_FILIAL = C5_FILIAL
	AND C6_NUM = C5_NUM
	AND SC6.%NotDel%
	WHERE C5_FILIAL = %Exp:SC5->C5_FILIAL%
	AND C5_NUM = %Exp:SC5->C5_NUM%
	AND SC5.%NotDel%
	GROUP BY C5_FILIAL,C5_NUM,I10.SIGLAGEN ) TMP
	WHERE QTD_IT_PED <> QTD_WMS OR C6_QTDVEN <> QTD_EXEM
EndSql

(cAliVld)->(DbGoTop())
If lValidWMS .AND. (cAliVld)->(!EOF())
	aRet[1] :=	""
	aRet[2] :=	"Pedido:"+SC5->C5_NUM+", Detectada inconsist๊ncia entre quantidade do pedido e quantidade do WMS! Qtd.It.Ped.:"+AllTrim(Str((cAliVld)->QTD_IT_PED))+", Qtd.It.WMS.:"+AllTrim(Str((cAliVld)->QTD_WMS))+;
				", Qtd.Exemp.Ped.:"+AllTrim(Str((cAliVld)->C6_QTDVEN))+", Qtd.Exemp.WMS.:"+AllTrim(Str((cAliVld)->QTD_EXEM))
				
	U_GenSendMail(,,,"noreply@grupogen.com.br",cMonit,oemtoansi("Pedido:"+SC5->C5_NUM+", Detectada inconsist๊ncia entre quantidade do pedido e quantidade do WMS"),aRet[2],,,.F.)
	(cAliVld)->(DbCloseArea())
	Return aRet
Else
	(cAliVld)->(DbCloseArea())	
EndIf

SC9->(dbSeek(SC5->C5_FILIAL+SC5->C5_NUM ))

//aListBlock := SB2->(DBRLockList("SB2"))

While SC9->(!EOF()) .and. SC9->(C9_FILIAL+C9_PEDIDO) == SC5->C5_FILIAL+SC5->C5_NUM
					
	If ( Empty(SC9->C9_BLEST) .OR. SC9->C9_BLEST == "10" ) .and. ( Empty(SC9->C9_BLCRED) .OR. SC9->C9_BLCRED == "10") .AND. Empty(SC9->C9_NFISCAL)
	
        SC6->(dbSeek(SC5->C5_FILIAL+SC9->(C9_PEDIDO+C9_ITEM+C9_PRODUTO) )) 
        SF4->(dbSeek(xFilial("SF4")+SC6->C6_TES ))
        SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO )) 
        SB2->(dbSeek(xFilial("SB2")+SC6->(C6_PRODUTO+C6_LOCAL) )) 
        SE4->(dbSeek(xFilial("SE4")+SC5->C5_CONDPAG ))
									
		aAdd(aPvlNfs,{ 	SC9->C9_PEDIDO,;
						SC9->C9_ITEM,;
						SC9->C9_SEQUEN,;
						SC9->C9_QTDLIB,;
						SC6->C6_PRCVEN,;
						SC9->C9_PRODUTO,;
						.F.,;
						SC9->(Recno()),;
						SC5->(Recno()),;
						SC6->(Recno()),;
						SE4->(Recno()),;
						SB1->(Recno()),;
						SB2->(Recno()),;
						SF4->(Recno())})
		/*
		IF SB2->(DBRLock(SB2->(Recno()))) //SB2->(SoftLock("SB2"))//RecLock("SB2",.F.,NIL,.F.,.T.)
			SB2->(MsUnLock())
		Else	
			aRet[2]	:= "Pedido com bloqueio SB2 - PEDIDO: "+SC5->C5_NUM+" - RECNO SB2 - "+cValToChar(SB2->(Recno()))+Time()
			Conout("JFWMS001 - Fila - "+cIdDila+" - Pedido com bloqueio SB2 "+ZZ5->ZZ5_IDFILA+" "+Time())
			aPvlNfs	:= {}
			Exit		
		EndIF
		*/
    Else		
		aRet[2]	:= "Pedido com bloqueio SC9 "+ZZ5->ZZ5_IDFILA+" "+Time()
		Conout("JFWMS001 - Fila - "+cIdDila+" - Pedido com bloqueio SC9 "+ZZ5->ZZ5_IDFILA+" "+Time())
		aPvlNfs	:= {}
		Exit
    EndIf

    SC9->(dbSkip())
EndDo
					
If Len(aPvlNfs) <> 0
	Conout("JFWMS001 - Fila - "+cIdDila+" - INICIADO PROCESSAMENTO NOTA FISCAL - "+cFilAnt+" - "+ZZ5->ZZ5_IDFILA+" "+Time())
	cNota := MaPVlNFs(aPvlNfs,cSerie,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)						
	Conout("JFWMS001 - Fila - "+cIdDila+" - TEMINO PROCESSAMENTO NOTA FISCAL - "+cFilAnt+" - "+ZZ5->ZZ5_IDFILA+" "+Time())
	If !Empty(cNota)
		aRet[1] := cNota				
	EndIf
EndIf	

Return aRet

Static Function JFVERSC9(cFilSC5,cPedido)
Local cQuery := ""

cQuery += "Select * FROM ( " + CRLF
cQuery += "SELECT C6_FILIAL,C6_NUM,C6_ITEM,C6_PRODUTO, " + CRLF
cQuery += "NVL((SELECT C9_QTDLIB from SC9000 where C9_FILIAL = C6_FILIAL and C9_PEDIDO = C6_NUM and C9_ITEM = C6_ITEM and C9_PRODUTO = C6_PRODUTO and C9_SEQUEN = '01' and D_E_L_E_T_ = ' '),0) AS SEQ01, " + CRLF 
cQuery += "NVL((SELECT C9_QTDLIB from SC9000 where C9_FILIAL = C6_FILIAL and C9_PEDIDO = C6_NUM and C9_ITEM = C6_ITEM and C9_PRODUTO = C6_PRODUTO and C9_SEQUEN = '02' and D_E_L_E_T_ = ' '),0) AS SEQ02 " + CRLF
cQuery += "FROM SC6000 SC6 " + CRLF
cQuery += "WHERE C6_FILIAL = '"+cFilSC5+"' " + CRLF
cQuery += "AND SC6.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "AND C6_NUM = '"+cPedido+"' " + CRLF
cQuery += ") where SEQ01 = SEQ02 " + CRLF
cQuery += "and SEQ01 > 0 "

Memowrite("query\JFWMS001_JFVERSC9.sql",cQuery)

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
	
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB", .F., .T.)

DbSelectArea("TRB")

If TRB->(!EOF())
	While TRB->(!EOF())
		DbSelectArea("SC9")
		DbSetOrder(1)
		If DbSeek(TRB->C6_FILIAL+TRB->C6_NUM+TRB->C6_ITEM+"02")
			RecLock("SC9",.F.)
			DbDelete()
			MsUnlock()
		EndIf
		TRB->(DbSkip())
	EndDo
EndIf

Return

User Function JFWMS01C(cFilPedi,cNumPedi)
Local lRet      := .T.
Local aArea     := GetArea()
Local lContinua := .T.

Return .T.

IF !ISINCALLSTACK("U_JFWMS001")
    Return lRet
ENDIF

IF Select("TMP_SB2") > 0
    TMP_SB2->(DbcloseArea())
EndIf

Beginsql Alias "TMP_SB2"
    SELECT SB2.R_E_C_N_O_ RECSB2
    FROM %Table:SC6% SC6
    JOIN %Table:SB2% SB2
    ON B2_FILIAL = C6_FILIAL
    AND B2_COD = C6_PRODUTO
    AND B2_LOCAL = C6_LOCAL
    AND SB2.%NotDel%
	WHERE C6_FILIAL = %Exp:cFilPedi%
	AND C6_NUM = %Exp:cNumPedi%
	AND SC6.%NotDel%
EndSql

while TMP_SB2->(!EOF())
    SB2->(DbGoTo( TMP_SB2->RECSB2 ))
    IF SB2->(DBRLock(SB2->(Recno())))//SB2->(SOFTLOCK("SB2"))
        SB2->(MsUnLock()) 
        TMP_SB2->(DbSkip())
	else
		U_GenSendMail(,,,"noreply@grupogen.com.br","desenvolvimento@grupogen.com.br",oemtoansi("JFWMS001 - Pedido:"+cNumPedi+", Detectado DEAD-LOCK SB2"),oemtoansi("O pedido "+cNumPedi+" estแ DEAD-LOCK SB2" + chr(13+chr(10)+"SB2 BLOQUEADO - "+cValToChar(TMP_SB2->RECSB2)+" - Obra "+SB2->B2_COD+" - "+Time()+".")),,,.F.)
        Conout("JFWMS001 - SB2 BLOQUEADO - "+cValToChar(TMP_SB2->RECSB2)+" - Obra "+SB2->B2_COD+" - "+Time()+".")
        TMP_SB2->(DbGoTop())
    EndIf    
endDo

TMP_SB2->(DbcloseArea())

RestArea(aArea)

Return lRet
