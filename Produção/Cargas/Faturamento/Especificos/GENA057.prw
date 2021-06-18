#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA057   ºAutor  ³Microsiga           º Data ³  09/27/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function GENA057()
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

MsgRun(OemToAnsi("Analisando saldos"),"Processando...",{|| ProcAux()} )
	
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA057   ºAutor  ³Microsiga           º Data ³  09/27/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcAux()
Local _cQuery	:= ""
Local cAliasSZA	:= GetNextAlias()
Local aInfo		:= {}
Local nSldBal	:= 0
//Local _cPerg   	:= "GENA019A"
Local _cPerg   	:= "GENA057"
Local _aArM0	:= SM0->(GetArea())
Local _lEmp		:= .F.
Local cFilGen	:= AllTrim(SM0->M0_CODFIL)
Local cFilOri	:= ""
Local cInIDTPPU	:= SuperGetMv("GEN_FAT125",.f.,"11#14#15#16#17#19#8#9") 
Local cTipo		:= ""

If !Pergunte(_cPerg,.T.)
	Return
Endif

cInIDTPPU	:= FormatIn(cInIDTPPU,"#") 
cTipo		:= AllTrim(str(MV_PAR04))
//ProcRegua(0)
//IncProc()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponterando na SM0 para pegar o CNPJ correto e realzar o ponteramento ³
//³na empresa quer será gravado a Nota                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SA2->(DbsetOrder(1))
SA2->(DbSeek(xFilial("SA2")+MV_PAR02+MV_PAR03))

SM0->(DbGoTop())
While SM0->(!EOF())
	If AllTrim(SM0->M0_CGC) == AllTrim(SA2->A2_CGC)
		_lEmp := .T.
		cFilOri := SM0->M0_CODFIL
		Exit
	EndIf
	SM0->(DbSkip())
EndDo

If !_lEmp
	MsgStop("Faha ao identificar a empresa origem!")
	Return nil	
EndIf

RestArea(_aArM0)

dProcInter := LastDay(MV_PAR01)

_cQuery := " SELECT ZA_COD   
_cQuery += " ,ZA_PROC 
_cQuery += " ,ZA_LOJPROC 
_cQuery += " ,ZA_DESC 
_cQuery += " ,ZA_UM 
_cQuery += " ,ZA_LOCPAD 
_cQuery += " ,ZA_MSBLQL 
_cQuery += " ,SUM(ZA_VALORI) ZA_VALORI 
_cQuery += " ,SUM(ZA_VALDEV) ZA_VALDEV 
_cQuery += " ,SUM(ZA_VALCAN) ZA_VALCAN 
_cQuery += " ,SUM(ZA_SALDO) ZA_SALDO
_cQuery += " ,ZA_VALUNI 
_cQuery += " FROM " + RetSQLName("SZA") + " SZA
_cQuery += " JOIN " + RetSQLName("SB1") + " SB1
_cQuery += " ON B1_FILIAL = '"+xFilial("SB1")+"' "
_cQuery += " AND SB1.B1_COD = ZA_COD "
_cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
_cQuery += " WHERE SZA.ZA_FILIAL  = '"+xFilial("SZA")+"' 
_cQuery += " AND SZA.ZA_REF = '"+DTOS(dProcInter)+"'
_cQuery += " AND SZA.ZA_PROC = '"+MV_PAR02+"'
_cQuery += " AND SZA.ZA_LOJPROC = '"+MV_PAR03+"'
_cQuery += " AND SZA.ZA_TIPO = '"+cTipo+"'
_cQuery += " AND SZA.ZA_STATUS = ' '
_cQuery += " AND SZA.ZA_SALDO > 0
_cQuery += " AND SZA.D_E_L_E_T_ = ' '
_cQuery += " AND B1_XIDTPPU IN "+cInIDTPPU+" "
_cQuery += " GROUP BY ZA_COD   
_cQuery += " ,ZA_PROC 
_cQuery += " ,ZA_LOJPROC 
_cQuery += " ,ZA_DESC 
_cQuery += " ,ZA_UM 
_cQuery += " ,ZA_LOCPAD 
_cQuery += " ,ZA_MSBLQL
_cQuery += " ,ZA_VALUNI 


If Select(cAliasSZA) > 0
	(cAliasSZA)->(DbCloseArea())
EndIf

DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), cAliasSZA, .F., .T.)	

If (cAliasSZA)->(EOF())
	MsgStop("Não encontrei informações para processar com os parametros informados!")
	(cAliasSZA)->(DbCloseArea())
	Return nil
EndIf

ZZ8->(DbSetOrder(2))

If ZZ8->( Dbseek( xFilial("ZZ8") + cTipo + DtoS(dProcInter) + MV_PAR02 + MV_PAR03 ) ) 
	If !MsgYesNo("Já existe dados para este periodo, deseja reprocessar?")
		Return nil
	EndIf
EndIf

ZZ8->(DbSetOrder(1))

While (cAliasSZA)->(!EOF())
	nSldBal	:= 0
	cObra		:= (cAliasSZA)->ZA_COD
	nSldPrest	:= (cAliasSZA)->ZA_SALDO
	cLocal		:= (cAliasSZA)->ZA_LOCPAD	
	
	IF U_GENA056(cObra,nSldPrest,cLocal,cFilGen,cFilOri,(cAliasSZA)->ZA_PROC,(cAliasSZA)->ZA_LOJPROC,dProcInter, cTipo ,@nSldBal,@aInfo)
	
		lNewZZ8	:= !ZZ8->( Dbseek( xFilial("ZZ8")  + cTipo + DtoS(dProcInter) + cObra + (cAliasSZA)->ZA_PROC + (cAliasSZA)->ZA_LOJPROC ) )//ZZ8_FILIAL+DTOS(ZZ8_REF)+ZZ8_COD+ZZ8_PROC+ZZ8_LOJPRO+ZZ8_TIPO
		
		RecLock("ZZ8",lNewZZ8)
		ZZ8->ZZ8_FILIAL	:= xFilial("ZZ8")
		ZZ8->ZZ8_REF	:= dProcInter
		ZZ8->ZZ8_COD	:= cObra
		ZZ8->ZZ8_PROC	:= (cAliasSZA)->ZA_PROC
		ZZ8->ZZ8_LOJPRO	:= (cAliasSZA)->ZA_LOJPROC
		ZZ8->ZZ8_TIPO	:= cTipo
		ZZ8->ZZ8_SALDO 	:= nSldPrest
		ZZ8->ZZ8_SALDOK	:= nSldBal
		ZZ8->ZZ8_SLDDIF	:= IIF( nSldBal >= nSldPrest , 0 , nSldPrest-nSldBal )
		ZZ8->ZZ8_STATUS	:= " " 
		ZZ8->ZZ8_LOCPAD	:= cLocal
		ZZ8->(MsUnLock())
		
	EndIf
	
	(cAliasSZA)->(DbSkip())
EndDo

Return nil