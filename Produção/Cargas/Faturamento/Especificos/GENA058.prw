#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

#DEFINE P_FORNECE	1
#DEFINE P_LOJA		2
#DEFINE P_OBRASNF	3
#DEFINE P_OBRASTR	4

#DEFINE P_IDOBRA	1
#DEFINE P_SALDO	2
#DEFINE P_RECZZ8	3
#DEFINE P_TPID		4
#DEFINE P_LOCAL	5
#DEFINE P_OK		6
#DEFINE P_MSG		7
#DEFINE P_SLD01	8
#DEFINE P_OK2		9
#DEFINE P_DTPUBLI	10
#DEFINE P_QTDPRES	11

#DEFINE   cEnt      CHR(13)+CHR(10)

//ZZ8_STATUS = "1" // saldo balanceado
//ZZ8_STATUS = "2" // saldo desbalanceado e nใo pode gera saldo devido a ser primeira carga

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA057   บAutor  ณMicrosiga           บ Data ณ  09/27/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function GENA058()
/*
RpcSetEnv("00","1022")

Default dProcInter	:= StoD("20160630")
Default cFornInter	:= "0378128"
Default cLojaInter	:= "07"
Default cTipo		:= "2"
Default cFilGen		:= "1022"
Default cFilOri		:= "9022"

Teste(dProcInter,cFornInter,cLojaInter,cTipo,cFilGen,cFilOri)
                
Return nil
Static Function Teste(dProcInter,cFornInter,cLojaInter,cTipo,cFilGen,cFilOri)
*/

If AllTrim(cFilAnt) <> "1022"
	MsgStop("Rotina deve ser executada apenas na filial 1022")
	Return .F.
EndIf

If !MsgYesNo("Confirma processo paara gerar saldo para o processo intercompany?")
	Return .F.
EndIf


MsgRun(OemToAnsi("Processando saldos"),"Processando...",{|| ProcAux()} )
	
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA057   บAutor  ณMicrosiga           บ Data ณ  09/27/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcAux()
Local _cQuery	:= ""
Local cAliasZZ8	:= GetNextAlias()
//Local _cPerg   	:= "GENA019A"
Local _cPerg   	:= "GENA057"
Local _aArM0	:= SM0->(GetArea())
Local _lEmp		:= .F.
Local cFilGen	:= AllTrim(SM0->M0_CODFIL)
Local cFilOri	:= ""
Local cInIDTPPU	:= SuperGetMv("GEN_FAT125",.f.,"11#14#15#16#17#19#8#9") 
Local cTipo		:= ""
Local aGerSld	:= {}
Local aLogAux	:= {}
Local cSerie 	:= Padr(GetMv("GEN_EST004"),Tamsx3("F1_SERIE")[1]," ") //"10 "//GetMv("GEN_COM125")
Local cMvClDe	:= GetMv("GEN_FAT017") //Cont้m o cliente que serแ utilizado para realizar as movimenta็๕es na empresa Matriz
Local cMvLjDe	:= GetMv("GEN_FAT018") //Cont้m a Loja que serแ utilizado as movimenta็๕es na empresa Matriz
Local cTpPubNFe	:= SuperGetMv("GEN_FAT126",.f.,"14#")
Local aTpPubNFe	:= Separa(cTpPubNFe,"#")
Local _cTrpPv	:= ""
Local _cTipPv 	:= ""
Local _cVenPv 	:= ""

If !Pergunte(_cPerg,.T.)
	Return
Endif

SA1->(DbSetOrder(1))
If !SA1->(DbSeek(xFilial("SA1")+PADR(AllTrim(cMvClDe),TAMSX3("A1_COD")[1])+PADR(AllTrim(cMvLjDe),TAMSX3("A1_LOJA")[1])))
	MsgStop("Cliente Gen nใo localizado!"+Chr(13)+Chr(10)+"Verifique os parametros GEN_FAT017 e GEN_FAT018")
	Return nil
EndIf	

_cTrpPv		:= SA1->A1_TRANSP
_cTipPv 	:= SA1->A1_TIPO
_cVenPv 	:= SA1->A1_VEND
					
cInIDTPPU	:= FormatIn(cInIDTPPU,"#") 
cTipo		:= AllTrim(str(MV_PAR04))
//ProcRegua(0)
//IncProc()

//dProcInter := LastDay(MV_PAR01)
dProcInter := If(dDataBase < MV_PAR01,dDataBase,MV_PAR01)

dDataBase := dProcInter

ZZ8->(DbSetOrder(1))    

_cQuery := " SELECT ZZ8_FILIAL, ZZ8_REF, ZZ8_COD, ZZ8_LOCPAD, ZZ8_PROC, ZZ8_LOJPRO, ZZ8_TIPO, ZZ8_SALDO, ZZ8_STATUS, ZZ8_SALDOK, ZZ8_SLDDIF, ZZ8.R_E_C_N_O_ RECZZ8,B1_XIDTPPU,
_cQuery += " ( SELECT MAX(SB5.B5_XDTPUBL) FROM " + RetSQLName("SB5") + " SB5 WHERE B5_FILIAL = '"+xFilial("SB5")+"' AND B5_COD = B1_COD AND SB5.D_E_L_E_T_ <> '*' ) B5_XDTPUBL, 
_cQuery += "NVL((SELECT B2_QATU-(B2_RESERVA+B2_QEMP) FROM " + RetSQLName("SB2") + " S1 WHERE S1.B2_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022') AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '01' AND S1.D_E_L_E_T_ = ' '),0) SLD_ORI_01 "
_cQuery += " FROM " + RetSQLName("ZZ8") + " ZZ8
_cQuery += " JOIN " + RetSQLName("SB1") + " SB1
_cQuery += " ON B1_FILIAL = '"+xFilial("SB1")+"' "
_cQuery += " AND SB1.B1_COD = ZZ8_COD "
_cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
_cQuery += " WHERE ZZ8.ZZ8_FILIAL  = '"+xFilial("ZZ8")+"' 
//_cQuery += " AND ZZ8.ZZ8_REF = '"+DTOS(dProcInter)+"'
_cQuery += " AND ZZ8.ZZ8_REF = '"+DTOS(LastDay(MV_PAR01))+"' "
_cQuery += " AND ZZ8.ZZ8_PROC = '"+MV_PAR02+"'
_cQuery += " AND ZZ8_LOJPRO = '"+MV_PAR03+"'
_cQuery += " AND ZZ8_TIPO = '"+cTipo+"'
_cQuery += " AND ZZ8_STATUS = ' '
_cQuery += " AND ZZ8_SALDO > 0
_cQuery += " AND ZZ8.D_E_L_E_T_ = ' '
_cQuery += " AND B1_XIDTPPU IN "+cInIDTPPU+" "
_cQuery += " ORDER BY ZZ8_PROC, ZZ8_LOJPRO,B1_XIDTPPU,ZZ8_COD

If Select(cAliasZZ8) > 0
	(cAliasZZ8)->(DbCloseArea())
EndIf

DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), cAliasZZ8, .F., .T.)	

If (cAliasZZ8)->(EOF())
	MsgStop("Nใo encontrei informa็๕es para processar com os parametros informados!")
	(cAliasZZ8)->(DbCloseArea())
	Return nil
EndIf

While (cAliasZZ8)->(!EOF())
	
	nSldPrestar	:= (cAliasZZ8)->ZZ8_SALDO		// saldo a prestar contas
	nSldBal		:= (cAliasZZ8)->ZZ8_SALDOK		// saldo balanceado que pode ser utilizado
	nSldDif		:= (cAliasZZ8)->ZZ8_SLDDIF//nSldBal-nSldPrestar			// Diferen็a de saldo 
	
	If nSldDif > 0 //.AND. STOD((cAliasZZ8)->B5_XDTPUBL) <= (FirstDay(dProcInter)-1)
	
		nPosFor := aScan(aGerSld, {|x| AllTrim(x[P_FORNECE])+AllTrim(x[P_LOJA]) == AllTrim((cAliasZZ8)->ZZ8_PROC)+AllTrim((cAliasZZ8)->ZZ8_LOJPRO) } )
		If nPosFor == 0
			Aadd(aGerSld,Array(4))
			nPosFor	:= Len(aGerSld)
			
			aGerSld[nPosFor][P_FORNECE]	:= AllTrim((cAliasZZ8)->ZZ8_PROC)
			aGerSld[nPosFor][P_LOJA]	:= AllTrim((cAliasZZ8)->ZZ8_LOJPRO)
			aGerSld[nPosFor][P_OBRASNF]	:= {}
			aGerSld[nPosFor][P_OBRASTR]	:= {}			
		EndIf
        
		nPosAuxTp	:= 0
		//If AllTrim((cAliasZZ8)->B1_XIDTPPU) $ cTpPubNFe
		If aScan(aTpPubNFe, {|x| AllTrim(x) == AllTrim((cAliasZZ8)->B1_XIDTPPU) } ) > 0
			nPosAuxTp := P_OBRASNF
		Else	
			nPosAuxTp := P_OBRASTR
		EndIf
		
		Aadd(aGerSld[nPosFor][nPosAuxTp], Array(11) )
		nPosObra	:= Len(aGerSld[nPosFor][nPosAuxTp])
		
		aGerSld[nPosFor][nPosAuxTp][nPosObra][P_IDOBRA]	:= AllTrim((cAliasZZ8)->ZZ8_COD)
		aGerSld[nPosFor][nPosAuxTp][nPosObra][P_SALDO]		:= nSldDif
		aGerSld[nPosFor][nPosAuxTp][nPosObra][P_RECZZ8]	:= (cAliasZZ8)->RECZZ8 
		aGerSld[nPosFor][nPosAuxTp][nPosObra][P_TPID]		:= (cAliasZZ8)->B1_XIDTPPU
		aGerSld[nPosFor][nPosAuxTp][nPosObra][P_LOCAL]		:= "01"

		aGerSld[nPosFor][nPosAuxTp][nPosObra][P_OK]		:= (cAliasZZ8)->ZZ8_SALDO <= (cAliasZZ8)->SLD_ORI_01//nSldDif <= (cAliasZZ8)->SLD_ORI_01//(nSldDif*(-1)) <= (cAliasZZ8)->SLD_ORI_01		
		aGerSld[nPosFor][nPosAuxTp][nPosObra][P_MSG]		:= ""
		aGerSld[nPosFor][nPosAuxTp][nPosObra][P_SLD01]		:= (cAliasZZ8)->SLD_ORI_01
		aGerSld[nPosFor][nPosAuxTp][nPosObra][P_OK2]		:= .F. 
		aGerSld[nPosFor][nPosAuxTp][nPosObra][P_DTPUBLI]	:= STOD((cAliasZZ8)->B5_XDTPUBL) 
		aGerSld[nPosFor][nPosAuxTp][nPosObra][P_QTDPRES]	:= (cAliasZZ8)->ZZ8_SALDO 				
						
	Else//If nSldDif >= 0
		
		ZZ8->(DbGoTo( (cAliasZZ8)->RECZZ8 ))
		
		RecLock("ZZ8",.F.)
		ZZ8->ZZ8_STATUS	:= "1"
		ZZ8->(MsUnLock())
	/*		
	ElseIf STOD((cAliasZZ8)->B5_XDTPUBL) <= (FirstDay(dProcInter)-1)
		
		ZZ8->(DbGoTo( (cAliasZZ8)->RECZZ8 ))
		
		RecLock("ZZ8",.F.)
		ZZ8->ZZ8_STATUS	:= "2"
		ZZ8->(MsUnLock())
	*/	
	EndIf
	
	
	(cAliasZZ8)->(DbSkip())
EndDo

For nAuxZZ8 := 1 To Len(aGerSld)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPonterando na SM0 para pegar o CNPJ correto e realzar o ponteramento ณ
	//ณna empresa quer serแ gravado a Nota                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SA2->(DbsetOrder(1))
	SA2->(DbSeek(xFilial("SA2")+ PadR(aGerSld[nAuxZZ8][P_FORNECE],TamSX3("A1_COD")[1])+aGerSld[nAuxZZ8][P_LOJA] ))
	
	SM0->(DbGoTop())
	While SM0->(!EOF())
		If AllTrim(SM0->M0_CGC) == AllTrim(SA2->A2_CGC)
			cFilOri := SM0->M0_CODFIL
			Exit
		EndIf
		SM0->(DbSkip())
	EndDo
	
	If Empty(cFilOri)
		MsgStop("Falha ao identificar a empresa origem para o fornecedor "+SA2->A2_NOME+"("+SA2->A2_COD+")"+"!")
		Loop
	EndIf
	
	RestArea(_aArM0)
		
//	cFilOri	:= ""
	If Len(aGerSld[nAuxZZ8][P_OBRASNF]) > 0

		If GerSldNFe(cFilOri,dProcInter,aGerSld[nAuxZZ8][P_OBRASNF],SA2->A2_COD,SA2->A2_LOJA,cMvClDe,cMvLjDe,_cTrpPv,_cTipPv,_cVenPv,P_OBRASNF,@aLogAux)
			
			
		EndIf
		
	EndIf

//	cFilOri	:= ""
	If Len(aGerSld[nAuxZZ8][P_OBRASTR]) > 0

		If GerSldNFe(cFilOri,dProcInter,aGerSld[nAuxZZ8][P_OBRASTR],SA2->A2_COD,SA2->A2_LOJA,cMvClDe,cMvLjDe,_cTrpPv,_cTipPv,_cVenPv,P_OBRASTR,@aLogAux)
			
			
		EndIf
		
	EndIf
	
Next nAuxZZ8

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA058   บAutor  ณMicrosiga           บ Data ณ  09/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GerSldNFe(cFilOri,dProcInter,aObras,cFornece,cLojafor,cMvClDe,cMvLjDe,_cTrpPv,_cTipPv,_cVenPv,nTpSaldo,aLogAux)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVaraiveis da rotina.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cSerie		:= Padr(GetMv("GEN_EST004"),Tamsx3("F1_SERIE")[1]," ")
//Local cTes			:= "001"		
Local aSF1Gen		:= {}
Local aSD1Itens		:= {}
Local aSD1Orig		:= {}
Local aItemOri		:= {}
Local aSC6Aux		:= {}
Local aSC5Gen		:= {}
Local aSC6Gen		:= {}
Local nAuxIt		:= 0
Local nVUnit		:= 0.01
Local cItemAux		:= StrZero(0,TamSX3("D1_ITEM")[1])
Local cItC6Aux		:= StrZero(0,TamSX3("C6_ITEM")[1])
Local cItemOri		:= StrZero(0,TamSX3("D1_ITEM")[1])
Local _cMvTbPr 		:= GetMv("GEN_FAT015") //Cont้m a tabela de pre็o usado no pedido de vendas na empresa Matriz e Origem
Local aSaldos		:= {}
Local aObrasAux		:= {}
Local _cLogPd		:= GetMv("GEN_FAT016") //Cont้m o caminho que serแ gravado o log de erro
Local cTesIntCia	:= GetMv("GEN_COM011") 
Local cTesSOri		:= "820"

Local _cServ 		:= GETMV("GEN_FAT027") //Cont้m o Ip do servidor para realizar as mudan็as de ambiente
Local _nPort  		:= GETMV("GEN_FAT028") //Cont้m a porta para realizar as mudan็as de ambiente
Local _cAmb  		:= GETMV("GEN_FAT029") //Cont้m o ambiente a ser utilizado para realizar as mudan็as de filial
Local lSldOri		:= .T.
Local _cNotaImp		:= ""
Local nColProd		:= 2

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณverifico se existe obra sem saldo no 01 da origem para ser enviada ณ
//ณpara o Gen                                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aEval(aObras, {|x| lSldOri := IIF( !x[P_OK] , .F. , lSldOri ) } ) 

If !lSldOri
	CREATE RPCCONN _oServer ON  SERVER _cServ 			;   //IP do servidor
	PORT  _nPort           								;   //Porta de conexใo do servidor
	ENVIRONMENT _cAmb       							;   //Ambiente do servidor
	EMPRESA cEmpAnt          							;   //Empresa de conexใo
	FILIAL  cFilOri          							;   //Filial de conexใo
	TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que serใo abertas
	MODULO  "SIGAFAT"               					//M๓dulo de conexใo
		
	If ValType(_oServer) == "O"
		
		_oServer:CallProc("RPCSetType", 2)
		
		If nTpSaldo == P_OBRASNF
			aObrasAux := _oServer:CallProc("U_GENA058B",aObras,dProcInter,cFornece,cLojafor)
		ElseIf nTpSaldo == P_OBRASTR
			aObrasAux := _oServer:CallProc("U_GENA058E",aObras,dProcInter,cFornece,cLojafor)	
		EndIf	
	 
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRealizando a nova conexใo para entrar na empresa e filial corretaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//Fecha a Conexao com o Servidor
		RESET ENVIRONMENT IN SERVER _oServer
		CLOSE RPCCONN _oServer
		FreeObj(_oServer)
		_oServer := Nil
		
	EndIf
Else
	aObrasAux := aClone(aObras)	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCabe็alho da nota de entrada no Gen de remessa consigna็ใo   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aadd(aSF1Gen , {"F1_TIPO"   	,"N"				, Nil} )
aadd(aSF1Gen , {"F1_FORMUL" 	,"N"				, Nil} )
aadd(aSF1Gen , {"F1_SERIE"  	,cSerie				, Nil} )
aadd(aSF1Gen , {"F1_EMISSAO"	,dProcInter			, Nil} )
aadd(aSF1Gen , {"F1_DTDIGIT"	,dProcInter			, Nil} )
aadd(aSF1Gen , {"F1_FORNECE"	,cFornece			, Nil} )
aadd(aSF1Gen , {"F1_LOJA"   	,cLojafor			, Nil} )
aadd(aSF1Gen , {"F1_ESPECIE"	,"SPED"				, Nil} )
aadd(aSF1Gen , {"F1_COND"		,"001"				, Nil} )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCabe็alho do pedido de envio de remessa de consigna็ใoณ
//ณpara o Gen                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd ( aSC5Gen , { "C5_TIPO"	, "N"     		, Nil} )
aAdd ( aSC5Gen , { "C5_CLIENTE"	, cMvClDe  		, Nil} )
aAdd ( aSC5Gen , { "C5_LOJACLI"	, cMvLjDe  		, Nil} )
aAdd ( aSC5Gen , { "C5_CLIENT"	, cMvClDe 		, Nil} )
aAdd ( aSC5Gen , { "C5_LOJAENT"	, cMvLjDe		, Nil} )
aAdd ( aSC5Gen , { "C5_TRANSP"	, _cTrpPv		, Nil} )
aAdd ( aSC5Gen , { "C5_TIPOCLI"	, _cTipPv 		, Nil} )
aAdd ( aSC5Gen , { "C5_VEND1"	, _cVenPv 		, Nil} )
aAdd ( aSC5Gen , { "C5_CONDPAG"	, "001"	  		, Nil} )
aAdd ( aSC5Gen , { "C5_TABELA"	, _cMvTbPr		, Nil} )
aAdd ( aSC5Gen , { "C5_EMISSAO"	, dProcInter	, Nil} )
aAdd ( aSC5Gen , { "C5_MOEDA"	, 1		   		, Nil} )
aAdd ( aSC5Gen , { "C5_TPLIB"	, "2"			, Nil} )

If Type("_oServer") <> "U"
	If ValType(_oServer) == "O"
		FreeObj(_oServer)
	EndIf
EndIf

								
For nAuxIt := 1 To Len(aObrasAux)			
    
	If !aObrasAux[nAuxIt][P_OK2]
	
		aItemAux	:= {}
		aSC6Aux		:= {}			
		cItemAux	:= Soma1(cItemAux)
		cItC6Aux	:= Soma1(cItC6Aux)
				
		aAdd(aItemAux,	{"D1_ITEM"		, cItemAux							, Nil})
		aAdd(aItemAux,	{"D1_COD"  		, aObrasAux[nAuxIt][P_IDOBRA]		, Nil})
		aAdd(aItemAux,	{"D1_QUANT"		, aObrasAux[nAuxIt][P_SALDO]		, Nil})
		aAdd(aItemAux,	{"D1_VUNIT"		, nVUnit							, Nil})
		aAdd(aItemAux,	{"D1_TOTAL"		, nVUnit*aObrasAux[nAuxIt][P_SALDO]	, Nil})
		aAdd(aItemAux,	{"D1_TES"		, cTesIntCia						, Nil})
		aAdd(aItemAux,	{"D1_LOCAL"		, "01"								, Nil})
		
		aadd(aSD1Itens,aClone(aItemAux))
	    
		aAdd ( aSC6Aux 	, 	{ "C6_ITEM"    	, cItC6Aux					   										 		, Nil})
		aAdd ( aSC6Aux 	, 	{ "C6_PRODUTO" 	, aObrasAux[nAuxIt][P_IDOBRA]										 		, Nil})
		aAdd ( aSC6Aux 	, 	{ "C6_DESCRI"  	, Posicione("SB1",1,xFilial("SB1")+aObrasAux[nAuxIt][P_IDOBRA],"B1_DESC")	, Nil})
		aAdd ( aSC6Aux 	, 	{ "C6_QTDVEN"  	, aObrasAux[nAuxIt][P_SALDO]		   	   									, Nil})
		aAdd ( aSC6Aux 	, 	{ "C6_PRCVEN"  	, nVUnit				    										   		, Nil})
		aAdd ( aSC6Aux 	, 	{ "C6_VALOR"   	, Round(nVUnit*aObrasAux[nAuxIt][P_SALDO],2)			   					, Nil})
		aAdd ( aSC6Aux 	, 	{ "C6_QTDLIB"  	, aObrasAux[nAuxIt][P_SALDO]												, Nil})
		aAdd ( aSC6Aux 	, 	{ "C6_TES"     	, cTesSOri									 		   				   		, Nil})
		aAdd ( aSC6Aux 	, 	{ "C6_LOCAL"   	, "01"		   																, Nil})
		aAdd ( aSC6Aux 	, 	{ "C6_ENTREG"	, dProcInter			   			   								   		, Nil})
															
		Aadd(aSC6Gen, aClone(aSC6Aux) )

	EndIf
		
	If (Len(aSC6Gen) >= 90 .OR. nAuxIt == Len(aObrasAux)) .and. Len(aSC6Gen) > 0
		 
		_cNotaImp := ""
				
		CREATE RPCCONN _oServer ON  SERVER _cServ 			;   //IP do servidor
		PORT  _nPort           								;   //Porta de conexใo do servidor
		ENVIRONMENT _cAmb       							;   //Ambiente do servidor
		EMPRESA cEmpAnt          							;   //Empresa de conexใo
		FILIAL  cFilOri          							;   //Filial de conexใo
		TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que serใo abertas
		MODULO  "SIGAFAT"               					//M๓dulo de conexใo
			
		If ValType(_oServer) == "O"
			
			_oServer:CallProc("RPCSetType", 2)
			_cNotaImp := _oServer:CallProc("U_GENA058C",aSC5Gen,aSC6Gen,dProcInter)
 
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณRealizando a nova conexใo para entrar na empresa e filial corretaณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			//Fecha a Conexao com o Servidor
			RESET ENVIRONMENT IN SERVER _oServer
			CLOSE RPCCONN _oServer                                
			FreeObj(_oServer)
			_oServer := Nil
			
		EndIf
		
		If !Empty(_cNotaImp)
			If U_GENA058D(_cNotaImp,aSD1Itens,aClone(aSF1Gen))
			
				For nAuxAtuZZ8 := 1 To Len(aSD1Itens)
					
					nColProd	:= aScan(aSD1Itens[nAuxAtuZZ8], {|x| x[1] == "D1_COD" } )
					nPosObra	:= aScan(aObrasAux, {|x| AllTrim(x[P_IDOBRA]) == AllTrim(aSD1Itens[nAuxAtuZZ8][nColProd][2]) } )
					
					If nPosObra == 0
						_cErroLg := "Falha ao atualizar o status da obra na tabela ZZ8, Obra: "+AllTrim(aSD1Itens[nAuxAtuZZ8][nColProd][2])+" para nota: "+_cNotaImp
						MemoWrite ( _cLogPd + "Emp" + cEmpAnt + " Fil" + cFilant + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " AtuStsZZ8.txt" , _cErroLg )
					Else
						
						aObrasAux[nPosObra][P_OK2]	:= .T.
						ZZ8->(DbgoTo( aObrasAux[nPosObra][P_RECZZ8] ))
						RecLock("ZZ8",.F.)
						ZZ8->ZZ8_STATUS	:= "1"
						ZZ8->(MsUnLock())
						
					EndIf
					
				Next nAuxAtuZZ8
				
			EndIf
			
		EndIf
        
		aSD1Orig	:= {}
		aSD1Itens	:= {}
		aItemAux	:= {} 
		aItemOri	:= {}			
						
		aSC6Aux		:= {} 
		aSC6Gen		:= {} 

		cItemAux	:= StrZero(0,TamSX3("D1_ITEM")[1])
		cItC6Aux	:= StrZero(0,TamSX3("C6_ITEM")[1])
				
	EndIf

Next nAuxIt

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA058   บAutor  ณMicrosiga           บ Data ณ  09/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA058B(aObras,dProcInter,cFornece,cLojafor)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina                                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local nAuxSld  		:= 0 
Local aItemAux 		:= {}
Local nItemAux		:= 0
Local nVUnit   		:= 0.1
Local aSD1Orig		:= {}
Local cTes	   		:= "004"
Local aSF1Origem	:= {}
Local cSerie		:= "2  "
Local _cDocImp		:= ""
Local _cLogPd		:= GetMv("GEN_FAT016") //Cont้m o caminho que serแ gravado o log de erro
Local _ni			:= 0 
Local nColIdObra	:= 0
Local nAuxObra		:= 0
Local aObraOk		:= {}
Local aSF1Aux		:= {}
Local nGerSld		:= 0

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

DDataBase := dProcInter
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCabe็alho da nota de entrada na origem para gerar saldo.     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aadd(aSF1Origem , {"F1_TIPO"   	,"N"				, Nil} )
aadd(aSF1Origem , {"F1_FORMUL" 	,"S"				, Nil} )
aadd(aSF1Origem , {"F1_SERIE"  	,cSerie				, Nil} )
aadd(aSF1Origem , {"F1_EMISSAO"	,dProcInter			, Nil} )
aadd(aSF1Origem , {"F1_DTDIGIT"	,dProcInter			, Nil} )
aadd(aSF1Origem , {"F1_FORNECE"	,cFornece			, Nil} )
aadd(aSF1Origem , {"F1_LOJA"   	,cLojafor			, Nil} )
aadd(aSF1Origem , {"F1_ESPECIE"	,"SPED"				, Nil} )
aadd(aSF1Origem , {"F1_COND"	,"001"				, Nil} )

For nAuxSld := 1 To Len(aObras)

	If !aObras[nAuxSld][P_OK] 
		                                                                             	
		If aObras[nAuxSld][P_DTPUBLI] > (FirstDay(dProcInter)-1)
			aObras[nAuxSld][P_OK] 		:= .F.         
			aObras[nAuxSld][P_MSG] 		:= "Nใo pode ser gerado saldo pois a data de publica็ใo ้ muito recente"
			Loop
		EndIf
		
		nGerSld	:= aObras[nAuxSld][P_QTDPRES]-aObras[nAuxSld][P_SLD01] //aObras[nAuxSld][P_SALDO]-aObras[nAuxSld][P_SLD01] 
		
		If nGerSld <= 0
			aObras[nAuxSld][P_OK] 		:= .F.         
			aObras[nAuxSld][P_MSG] 		:= "Falha ao gerar ao calcular o saldo para dar entrada!"
			Loop			
		EndIf
		
		aItemAux	:= {}
		
		nItemAux++
		aAdd(aItemAux,	{"D1_ITEM"		, StrZero(nItemAux,TamSX3("D1_ITEM")[1])	, Nil})
		aAdd(aItemAux,	{"D1_COD"  		, aObras[nAuxSld][P_IDOBRA]					, Nil})
		nColIdObra	:= 2
		
		aAdd(aItemAux,	{"D1_QUANT"		, nGerSld				   					, Nil})
		aAdd(aItemAux,	{"D1_VUNIT"		, nVUnit				  			   		, Nil})
		aAdd(aItemAux,	{"D1_TOTAL"		, Round(nVUnit*nGerSld,2)					, Nil})
		aAdd(aItemAux,	{"D1_TES"		, cTes										, Nil})
		aAdd(aItemAux,	{"D1_LOCAL"		, aObras[nAuxSld][P_LOCAL]					, Nil})
		
		aAdd(aSD1Orig,aClone(aItemAux))		
	
	EndIf
		
	If (nItemAux >= 90 .OR. nAuxSld == Len(aObras)) .AND. Len(aSD1Orig) > 0
		                           
		lMsErroAuto		:= .F.
		lMsHelpAuto		:= .T.
		lAutoErrNoFile 	:= .T.
		
		_cDocImp	:= MA461NumNf(.T.,cSerie)
		aSF1Aux		:= aClone(aSF1Origem)
		aadd(aSF1Aux , {"F1_DOC"		,_cDocImp , nil } )
		
		MSExecAuto({|x,y,z| MATA103(x,y,z)},aSF1Aux, aSD1Orig,3)
		
		If lMsErroAuto
			_cErroLg	:= ""
			_aErro		:= GetAutoGRLog()
			For _ni := 1 To Len(_aErro)
				_cErroLg += _aErro[_ni] + cEnt
			Next _ni
			conout(_cErroLg)
			If Empty(_cErroLg)
				MostraErro(_cLogPd + "Emp" + cEmpAnt + " Fil" + cFilant + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4)," NFeSldEntrada.txt")
			Else
				MemoWrite ( _cLogPd + "Emp" + cEmpAnt + " Fil" + cFilant + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " NFeSldEntrada.txt" , _cErroLg )	
			EndIf
			Disarmtransaction()
		Else
			
			aEval(aSD1Orig, {|x| Aadd(aObraOk, allTrim(x[nColIdObra][2]) ) })

		EndIf
		
		aItemAux	:= {}
		aSF1Aux		:= {}
		aSD1Orig	:= {}
		nItemAux	:= 0
				
	EndIf
    
Next nAuxSld

For nAuxSld := 1 To Len(aObraOk)

	nAuxObra := aScan(aObras, {|x| AllTrim(x[P_IDOBRA]) == AllTrim(aObraOk[nAuxSld]) } )
	If nAuxObra <> 0
		aObras[nAuxObra][P_OK]	:= .T.
	EndIf

Next nAuxSld

Return aObras

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA058   บAutor  ณMicrosiga           บ Data ณ  09/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA058C(aSC5Gen,aSC6Gen,dProcInter)

Local lRet		:= .F.
Local _cErroLg	:= ""
Local _aErro	:= {}
Local _aTmpPV1	:= {}
Local _aPVlNFs	:= {}
Local _cNotaImp	:= {} 
Local _cMvSeri	:= Padr(GetMv("GEN_EST004"),Tamsx3("F1_SERIE")[1]," ")//0  "
Local _cLogPd	:= GetMv("GEN_FAT016") //Cont้m o caminho que serแ gravado o log de erro
	
Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.  

DDataBase := dProcInter		

DbSelectArea("SB1")
MSExecAuto({|x,y,z| Mata410(x,y,z)},aSC5Gen,aSC6Gen,3)

If lMsErroAuto
	_cErroLg	:= ""
	_aErro		:= GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + cEnt
	Next _ni
	conout(_cErroLg)
	If Empty(_cErroLg)
		MostraErro(_cLogPd + "Emp" + cEmpAnt + " Fil" + cFilant + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4)," SldPedidoToGen.txt")
	Else
		MemoWrite ( _cLogPd + "Emp" + cEmpAnt + " Fil" + cFilant + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " SldPedidoToGen.txt" , _cErroLg )	
	EndIf
	Disarmtransaction()
Else

	SC6->(DbSetOrder(1))
	SC9->(DbSetOrder(1))//C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO                                                                                                                	
	SC6->(DbSeek( SC5->(C5_FILIAL+C5_NUM) ))	

	While SC6->(!EOF()) .AND. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM) 
		
		If !SC9->(DbSeek( SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM ))
			RecLock("SC6",.F.)
			SC6->C6_QTDLIB := MaLibDoFat(SC6->(Recno()),SC6->C6_QTDVEN)						 
			SC6->(msUnlock())						
		EndIf
		
		If ( !Empty(SC9->C9_BLEST) .OR. !Empty(SC9->C9_BLCRED) ) .AND. ( !(SC9->C9_BLCRED $ '10#09') .OR. SC9->C9_BLEST <> '10')					
			/*/
			ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
			ฑฑณ          ณRotina de atualizacao da liberacao de credito                ณฑฑ
			ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
			ฑฑณParametrosณExpN1: 1 - Liberacao                                         ณฑฑ
			ฑฑณ          ณ       2 - Rejeicao                                          ณฑฑ
			ฑฑณ          ณExpL2: Indica uma Liberacao de Credito                       ณฑฑ
			ฑฑณ          ณExpL3: Indica uma liberacao de Estoque                       ณฑฑ
			ฑฑณ          ณExpL4: Indica se exibira o help da liberacao                 ณฑฑ
			ฑฑณ          ณExpA5: Saldo dos lotes a liberar                             ณฑฑ
			ฑฑณ          ณExpA6: Forca analise da liberacao de estoque                 ณฑฑ
			ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
			/*/
			If !Empty(SC9->C9_BLCRED) .AND. !(SC9->C9_BLCRED $ '10#09')
				a450Grava(1,.T.,.F.,.F.)                            
			EndIf
			If !Empty(SC9->C9_BLEST) .AND. SC9->C9_BLEST <> '10' 
				a450Grava(1,.F.,.T.,.F.)                            
			EndIf
						
		EndIf
        
		If SC9->(DbSeek( SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM )) 
		
			_aTmpPV1 := {}
			aAdd( _aTmpPV1, SC9->C9_PEDIDO	)
			aAdd( _aTmpPV1, SC9->C9_ITEM 	)
			aAdd( _aTmpPV1, SC9->C9_SEQUEN	)
			aAdd( _aTmpPV1, SC9->C9_QTDLIB	)
			aAdd( _aTmpPV1, SC9->C9_PRCVEN	)
			aAdd( _aTmpPV1, SC9->C9_PRODUTO	)
			aAdd( _aTmpPV1, POSICIONE("SF4",1,xFilial("SF4")+SC6->C6_TES		,"F4_ISS")=="S")
			aAdd( _aTmpPV1, SC9->(RECNO())	)
			aAdd( _aTmpPV1, SC5->(RECNO())	)
			aAdd( _aTmpPV1, SC6->(RECNO())	)
			aAdd( _aTmpPV1, SE4->(RECNO(POSICIONE("SE4",1,xFilial("SE4")+"001"				,""))))
			aAdd( _aTmpPV1, SB1->(RECNO(POSICIONE("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO	,""))))
			aAdd( _aTmpPV1, SB2->(RECNO(POSICIONE("SB2",1,xFilial("SB2")+SC9->C9_PRODUTO	,""))))
			aAdd( _aTmpPV1, SF4->(RECNO()))
			aAdd( _aTmpPV1, SC9->C9_LOCAL	)
			aAdd( _aTmpPV1, 1				)
			aAdd( _aTmpPV1, SC9->C9_QTDLIB2	)
			
			aAdd( _aPVlNFs, aClone(_aTmpPV1))
			
		EndIf
								
		SC6->(DbSkip())
	EndDo
	
	If SC5->C5_LIBEROK <> "S" .AND. Len(_aPVlNFs) > 0
		RecLock("SC5",.F.)
		SC5->C5_LIBEROK := "S"  
		SC5->(MsUnlock())	
	EndIf	
				
	If Len(_aPVlNFs) > 0 
		_cNotaImp := MaPVlNFs(_aPVlNFs,_cMvSeri,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)
		If Empty(_cNotaImp)
			_cErroLg	:= "Falha ao tentar gerar a nota fiscal de saida para o Gen no pedido "+SC5->C5_NUM
			MemoWrite ( _cLogPd + "Emp" + cEmpAnt + " Fil" + cFilant + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " SldNotaToGen.txt" , _cErroLg )		
		EndIf	
	Else
		_cErroLg	:= "Nenhum item liberado para o pedido "+SC5->C5_NUM
		MemoWrite ( _cLogPd + "Emp" + cEmpAnt + " Fil" + cFilant + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " SldNotaToGen.txt" , _cErroLg )		
	EndIf
	
EndIf
							
Return _cNotaImp 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA058   บAutor  ณMicrosiga           บ Data ณ  09/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA058D(_cNotaImp,aItemAux,aSF1Gen)

Local _aArea 			:= GetArea()
Local _aErro			:= {}
Local _cErroLg			:= ""
Local _cEmp				:= AllTrim(SM0->M0_CODIGO)
Local _cFil				:= AllTrim(SM0->M0_CODFIL)
Local lRet				:= .F.
Local _cLogPd			:= GetMv("GEN_FAT016") //Cont้m o caminho que serแ gravado o log de erro

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

DbSelectArea("SA1")
DbSelectArea("SA2")

aAdd( aSF1Gen, { "F1_DOC" ,_cNotaImp, nil })
MSExecAuto({|x,y,z|MATA103(x,y,z)},aSF1Gen, aItemAux,3)

If lMsErroAuto
	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + cEnt
		conout(_cErroLg)
	Next _ni
	If Empty(_cErroLg)
		MostraErro( _cLogPd + "Emp" + cEmpAnt + " Fil" + cFilant + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4)," NFeSldEntradaGen.txt")
	Else
		MemoWrite ( _cLogPd + "Emp" + cEmpAnt + " Fil" + cFilant + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " NFeSldEntradaGen.txt" , _cErroLg )	
	EndIf	
	Disarmtransaction()
Else
	lRet	:= .T.	
EndIf

RestArea(_aArea)

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA058   บAutor  ณMicrosiga           บ Data ณ  09/29/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function GENA058E(aObras,dProcInter,cFornece,cLojafor)

Local nGerSld	:= 0
Local nAuxSld	:= 0 

Local _aCab1	:= {}
Local _aItem	:= {}
Local _aTotItem	:= {}
Local cCodigoT	:= "100"
Local nCtdAux	:= 0
Local aObraOk	:= {}  
Local cDtAux	:= DtoS(dProcInter)
Local _cLogPd	:= GetMv("GEN_FAT016") //Cont้m o caminho que serแ gravado o log de erro
Local nColIdObra	:= 1

DDataBase := dProcInter

Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
Private lMsErroAuto := .f. //necessario a criacao
Private _acod		:={"1","MP1"}

_aCab1 := {	{"D3_TM" 		, cCodigoT		, NIL}	,;
			{"D3_EMISSAO" 	, dProcInter	, NIL}	} 

For nAuxSld := 1 To Len(aObras)

	If !aObras[nAuxSld][P_OK] 

		If !SB2->(dbSeek(xFilial("SB2")+PadR(aObras[nAuxSld][P_IDOBRA],TamSX3("B2_COD")[1])+aObras[nAuxSld][P_LOCAL]))
			RecLock("SB2",.T.)
			SB2->B2_FILIAL := xFilial("SB2")
			SB2->B2_COD    := aObras[nAuxSld][P_IDOBRA]
			SB2->B2_LOCAL  := aObras[nAuxSld][P_LOCAL]
			MsUnLock()
		EndIf	
		
		nCtdAux++
		SB1->(DbSeek(xFilial("SB1")+ aObras[nAuxSld][P_IDOBRA] ))
		
		nGerSld	:= aObras[nAuxSld][P_QTDPRES]-aObras[nAuxSld][P_SLD01] //aObras[nAuxSld][P_SALDO]-aObras[nAuxSld][P_SLD01] 
		
		If nGerSld <= 0
			aObras[nAuxSld][P_OK] 		:= .F.         
			aObras[nAuxSld][P_MSG] 		:= "Falha ao gerar ao calcular o saldo para dar entrada!"
			Loop			
		EndIf
		
		_aItem:={	{"D3_COD"		, SB1->B1_COD				,NIL},;
					{"D3_UM"		, SB1->B1_UM				,NIL},; 
					{"D3_QUANT"		, nGerSld 					,NIL},;
					{"D3_LOCAL"		, aObras[nAuxSld][P_LOCAL]	,NIL},;
					{"D3_XCHVSD1"	, "GENA058"+cDtAux			,NIL}}

		Aadd(_aTotItem,_aItem) 									
	EndIf
	
	Begin Transaction
	
		If (nCtdAux >= 100 .OR. nAuxSld == Len(aObras) ) .AND. Len(_aTotItem) > 0
			
			MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_aTotItem,3)
				
			If lMsErroAuto 
				Mostraerro(_cLogPd,"Emp" + cEmpAnt + " Fil" + cFilant + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4)+"_MATA241.txt") 
				DisarmTransaction() 
			Else
				aEval(_aTotItem, {|x| Aadd(aObraOk, allTrim(x[nColIdObra][2]) ) })	
			EndIf		
			
			_aTotItem	:= {}
			_aItem		:= {}
			nCtdAux		:= 0
			
		EndIf
	
	End Transaction
	
Next nAuxSld

For nAuxSld := 1 To Len(aObraOk)
	
	nAuxObra := aScan(aObras, {|x| AllTrim(x[P_IDOBRA]) == AllTrim(aObraOk[nAuxSld]) } )
	If nAuxObra <> 0
		aObras[nAuxObra][P_OK]	:= .T.
	EndIf

Next nAuxSld

Return aObras
