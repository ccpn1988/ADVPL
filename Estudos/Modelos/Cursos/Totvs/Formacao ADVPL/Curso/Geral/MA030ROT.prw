#Include 'Protheus.ch'

// Ponto de entrada que cria um novo menu no "Outras Ações" no array aRotina
// e exporta o cadastro selecionado

User Function MA030ROT()
Local aBotao := {}

AAdd ( aBotao, { "Exportar Cadastro", "U_EXPSA1", 2, 0 } )

Return aBotao

//------------------------------------------------------------

User Function EXPSA1(cAlias, nRec, nOpc)
Local cLinha := AllTrim(SA1->A1_COD  ) + ";"
      cLinha += AllTrim(SA1->A1_LOJA ) + ";"
      cLinha += AllTrim(SA1->A1_NOME ) + ";"
      cLinha += AllTrim(SA1->A1_END  ) + ";"
      cLinha += AllTrim(SA1->A1_CGC  )

	MemoWrite("\data\ExpSa1.csv",cLinha)
	
	MsgInfo("Processado com sucesso")

Return(NIL)

