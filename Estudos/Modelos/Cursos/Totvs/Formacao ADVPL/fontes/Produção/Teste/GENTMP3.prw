#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GenTmp3   º Autor ³ Danilo Azevedo     º Data ³  29/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao de tabela de Vendedores.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENTMP3()

If MsgYesNo("Deseja excluir todos os vendedores e importar novamente?","Pergunta")
	tcsqlexec("UPDATE "+RetSqlName("SA3")+" SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_")
Endif

cQry := "SELECT * FROM COORDENADORVENDA WHERE ATIVO = 1 ORDER BY IDCOORDENADORVENDA"
cAlias := Criatrab(Nil,.F.)
MsgRun("Selecionando registros...","Processando", {||DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)})

dbSelectArea("SA3")
dbSetOrder(1)
Do while !(cAlias)->(eof())
	
If dbSeek(xFilial("SA3")+cValToChar((cAlias)->IDCOORDENADOREVNDA))
		RecLock("SA3",.F.)
	Else
		RecLock("SA3",.T.)
		SA3->A3_FILIAL := xFilial("SA3")
		SA3->A3_COD := strzero((cAlias)->IDCOORDENADORVENDA,tamsx3("A3_COD")[1])
	Endif

	SA3->A3_NOME := (cAlias)->DESCRICAO
	SA3->A3_XATIVO := cValToChar((cAlias)->ATIVO)
	SA3->A3_COMIS := (cAlias)->COMISSAO
	MsUnlock()
	(cAlias)->(dbskip())
Enddo

fErase(cAlias)

Return()
