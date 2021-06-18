#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA430SE2     º Autor ³ Vinicius Lança  º Data ³  29/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FA430SE2


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cQuery
Local cArqSE2	:= GetNextAlias()
Local cArqID	:= GetNextAlias()
Local lRet		:= .F.
Local cIDCNAB

//aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValPgto, nJuros, nMulta, cForne, cOcorr, cCGC, nCM, cRejeicao, xBuffer })

//Verificar a quantidade de ocorrencias do IDCNAB

If (PARAMIXB[1][1]) == '0000000000'
	cIDCNAB := ' '
Else              
	cIDCNAB := PARAMIXB[1][1]
EndIf

cQuery := " SELECT COUNT(E2_NUM) CONTADOR"
cQuery += " FROM "+RetSqlName("SE2")
cQuery += " WHERE D_E_L_E_T_ = ' ' "
cQuery += " AND E2_IDCNAB = '"+cIDCNAB+"'" //cNumTit

If Select(cArqID) > 0
	dbSelectArea(cArqID)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cArqID, .F., .T.)

DbSelectArea(cArqID)
DbGoTop()

If (cArqID)->CONTADOR > 1
	
	cQuery := " SELECT R_E_C_N_O_ "
	cQuery += " FROM "+RetSqlName("SE2")
	cQuery += " WHERE D_E_L_E_T_ = ' '"
	cQuery += " AND E2_IDCNAB = '"+cIDCNAB+"'" //cNumTit
	cQuery += " AND E2_VALOR - E2_DECRESC + E2_ACRESC  = "+alltrim(str(PARAMIXB[1][8])) //nValPgto
	
Else
	
	cQuery := " SELECT R_E_C_N_O_ "
	cQuery += " FROM "+RetSqlName("SE2")
	cQuery += " WHERE D_E_L_E_T_ = ' '"
	cQuery += " AND E2_IDCNAB = '"+cIDCNAB+"'" //cNumTit
	
Endif

If Select(cArqSE2) > 0
	dbSelectArea(cArqSE2)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cArqSE2, .F., .T.)

DbSelectArea("SE2")
DbGoTo((cArqSE2)->R_E_C_N_O_)

Return