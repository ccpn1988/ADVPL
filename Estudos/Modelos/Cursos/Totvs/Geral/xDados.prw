#Include 'Protheus.ch'

// Para que essa função funcione ela tem que ser adicionada ao menu

User Function xDados()

//Exercicio - Excluir um registro da tabela

dbSelectArea("SA1") //Abrindo a area da tabela

dbGoTop() // Posiciona no inicio da tabela

While ! Eof() // EOF Fim da tabela
// ou
//While .NOT. Eof() // Fim da tabela
	
	Reclock("SA1",.F.) // Realiza UPDATE
		DbDelete() // preenche o campo D_E_L_E_T_ com *
	MsUnlock() // Destrava o registro
	
	DbSkip() // Posiciona para o proximo registro
EndDo

MsgInfo("Registros estornados")

Return (NIL)

//----------------------------------------------------------------------

User Function xAltCadCgc

//Exercicio - fazer a busca pelo campo CGC 03338610002646
dbSelectArea("SA1") //Abrindo a area da tabela
dbSetOrder(3) // Seleciona o indice da tabela para realizar o update
              // No caso esse indice engloba os campos FILIAL + CODIGO + LOJA
              //FILIAL + CGC
              
IF MsSeek(xFilial("SA1") + "03338610002646") // Seleciona a tabela SA1 e o cnpj com numero 03338610002646
	Reclock("SA1",.F.) // Reclock trava na tabela -- .F. - Faz update na tabela
		SA1->A1_NOME := "Quem foi alterado ?" // Atualiza apenas o registro a qual esta posicionado na tela
	MsUnlock() // Commit
	MsgInfo("Alterado com sucesso")
Else
	MsgInfo("Dados não localizados")
Endif

Return (NIL)

//----------------------------------------------------------------------

User Function xAltCad()

dbSelectArea("SA1") //Abrindo a area da tabela
dbSetOrder(1) // Seleciona o indice da tabela para realizar o update
              // No caso esse indice engloba os campos FILIAL + CODIGO + LOJA
              //FILIAL + CODIGO + LOJA
              
IF MsSeek(xFilial("SA1") + "000002" + "01") // Seleciona a tabela SA1, o registro 000002 e a loja 01 para alterar
	Reclock("SA1",.F.) // Reclock trava na tabela -- .F. - Faz update na tabela
		SA1->A1_NOME := "Quem foi alterado ?" // Atualiza apenas o registro a qual esta posicionado na tela
	MsUnlock() // Commit
	MsgInfo("Alterado com sucesso")
Else
	MsgInfo("Dados não localizados")
Endif

Return (NIL)

//----------------------------------------------------------------------

User Function xIncSA1()
Reclock("SA1",.T.) // Insert - Reclock trava na tabela -- .T. - Inclui registro na tabela

	SA1->A1_FILIAL := xFilial("SA1")
	SA1->A1_COD    := "0001"
	SA1->A1_LOJA   := "04"
	SA1->A1_NOME   := "Seu Nome"
	SA1->A1_CGC    := "0000000000000"

MsUnlock() //Commit

MsgInfo("Gravado com sucesso")

Return (NIL)

