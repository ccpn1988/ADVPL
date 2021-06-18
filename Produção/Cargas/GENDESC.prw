#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GenDesc   º Autor ³ Danilo Azevedo     º Data ³  11/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao de tabela de descontos.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Cadastro de Clientes / Faturamento                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENDESC(lDel)

Default lDel := .T.

If lDel .and. MsgYesNo("Deseja excluir todos os descontos e importar novamente?","Pergunta")
	tcsqlexec("DELETE FROM "+RetSqlName("SZ2"))
Endif

cQry := "SELECT D.IDTIPODESCONTO TIPO, TD.DESCRICAO, D.IDCLASSEOBRA, CO.DESCRICAO CLASSE, D.PERC
cQry += " FROM DESCONTO D, TIPODESCONTO TD, CLASSEOBRA CO
cQry += " WHERE D.IDTIPODESCONTO = TD.IDTIPODESCONTO
cQry += " AND D.IDCLASSEOBRA = CO.IDCLASSEOBRA
cQry += " ORDER BY D.IDCLASSEOBRA
cAlias := Criatrab(Nil,.F.)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)

dbSelectArea("SZ2")
dbSetOrder(1)
Do while !(cAlias)->(eof())
	
	If dbSeek(xFilial("SZ2")+cValToChar((cAlias)->TIPO)+cValToChar((cAlias)->IDCLASSEOBRA))
		RecLock("SZ2",.F.)
	Else
		RecLock("SZ2",.T.)
		SZ2->Z2_FILIAL := xFilial("SZ2")
		SZ2->Z2_TIPO := cValToChar((cAlias)->TIPO)
		SZ2->Z2_CLASSE := cValToChar((cAlias)->IDCLASSEOBRA)
	Endif
	
	SZ2->Z2_DESC := (cAlias)->DESCRICAO
	SZ2->Z2_DESCCLA := (cAlias)->CLASSE
	SZ2->Z2_PERCDES := (cAlias)->PERC
	
	MsUnlock()
	(cAlias)->(dbskip())
Enddo

fErase(cAlias)

Return()
