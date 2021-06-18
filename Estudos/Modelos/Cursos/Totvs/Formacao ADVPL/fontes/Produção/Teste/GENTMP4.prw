#INCLUDE "rwmake.ch"
#Include "TopConn.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GenTmp4   º Autor ³ Danilo Azevedo     º Data ³  29/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao de tabela de Condicao de Pagamento (Temporario) º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENTMP4()

Local nTotReg := 0
Private cAlias := GetNextAlias()

If MsgYesNo("Deseja excluir todas as condições de pagamento e importar novamente?","Pergunta")
	tcsqlexec("DELETE FROM "+RetSqlName("SZ0"))
Endif

cQry := "SELECT IDCONDPGTO IDCOND, DESCRICAO, NUMPARCELA NUMPARC, USARDIAATUAL DIAATU, NUMMES, REDUCAODESCONTO REDDESC, NUMDIA, SITUACAO, INDPAG, PERDA, IDCONDPGTOTOTVS CONDTOTVS
cQry += " FROM CONDPGTO ORDER BY IDCONDPGTO"
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), cAlias, .F., .T.)
dbGoTop()
Do while !(cAlias)->(eof())
	
	dbSelectArea("SZ0")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ0")+STRZERO((cAlias)->IDCOND,6))
		RecLock("SZ0",.F.)
	Else
		RecLock("SZ0",.T.)
		SZ0->Z0_FILIAL := xFilial("SZ0")
		SZ0->Z0_COD := STRZERO((cAlias)->IDCOND,6)
		SZ0->Z0_DESC := upper(alltrim((cAlias)->DESCRICAO))
	Endif
	
	SZ0->Z0_NUMPARC := (cAlias)->NUMPARC
	SZ0->Z0_DIAATU := cValtoChar((cAlias)->DIAATU)
	SZ0->Z0_NUMMES := (cAlias)->NUMMES
	SZ0->Z0_REDDESC := (cAlias)->REDDESC
	SZ0->Z0_NUMDIA := (cAlias)->NUMDIA
	SZ0->Z0_SITUACA := (cAlias)->SITUACAO
	SZ0->Z0_INDPAG := (cAlias)->INDPAG
	SZ0->Z0_PERDA := (cAlias)->PERDA
	If FieldPos("Z0_E4CODIG") > 0 //VERIFICA SE O CAMPO EXISTE
		SZ0->Z0_E4CODIG := STRZERO(val((cAlias)->CONDTOTVS),6)
	Endif

	MsUnlock()
	(cAlias)->(dbskip())
Enddo

fErase(cAlias)

Return()
