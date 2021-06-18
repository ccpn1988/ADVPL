#Include 'Protheus.ch'

User Function XCADMOD2()

	Local oBrowser := FwmBrowse():New()

	/*ATRIBUINDO AS PROPRIEDADES DO OBJETO BROWSER*/
	oBrowser:setAlias("SZ0")
	oBrowser:setDescription("Modelo 2 Cadastro de Sucata")
	/*LEGENDA DA TELA*/
	oBrowser:AddLegend("Z0_ATIVO=='S'","BR_PINK")
	oBrowser:AddLegend("Z0_ATIVO=='N'","BR_VERDE")
	oBrowser:AddLegend("Z0_ATIVO==' '","BR_AZUL")

//Ativando o OBJETO - Nada pode ser colocado abaixo deste.
	oBrowser:Activate()

Return (NIL)

/*SEMPRE NOSSOS BOTÔES RECEBERÀ ESTE NOME DESTA FUNCÂO POIS ESTA ENCAPSULADO*/
Static Function MenuDef()
	Local aRotina :={}
	aRotina := {;
		{ "Pesquisar",  "AxPesqui", 0, 1},;
		{ "Visualizar", "U_MDL02SZ0", 0, 2},;
		{ "Incluir", 	"U_MDL02SZ0", 0, 3},;
		{ "Alterar", 	"U_MDL02SZ0", 0, 4},;
		{ "Exlcuir", 	"U_MDL02SZ0", 0, 5},;
		{ "Legenda", 	"U_LEGSZ0", 0, 7};
		}
Return(aRotina)

User Function MDL02SZ0 (cAlias,nRec,nOpc)
	
	Local cTitulo := "Cadastro de Sucata - Modelo 2"
	Local aC 	  := {}
	Local bF4 := {||MsgInfo("Exemplo de F4")}
	Local nMax := 99
	Local aR := {}
	Local aGetsD := {}
	/*Tamnaho do GRID*/
	Local aGd := {70,05,300,600}
	/* Informa se a tala abrirá maximixada */
	Local lMaximazed := .T.
	Private cCodigo := ""
	Private dData := Date()
	Private cNome := ""
	Private aHeader := {}
	Private aCols := {}
	Private aAlt := {}
	
	/* MONTANDO O ACOLS - PARA CONTROLE DO CAMPOS
	aC[n,1] = Nome da Variável Ex.:"cCliente"
	aC[n,2] = Array com coordenadas do Get [x,y], em Windows estão em PIXEL
	aC[n,3] = Titulo do Campo
	aC[n,4] = Picture
	aC[n,5] = Validação
	aC[n,6] = F3
	aC[n,7] = Se campo é editavel .T. se não .F.
	OBS : COMO O NOPC JÀ ESTARA VALIDANDO PARA ALTERAR SOMENTE QUANDO INCLUSAO */
	RegToMemory(cAlias,nOpc==3)
	fHeader(cAlias)
	faCols(cAlias,nRec,nOpc)
	
	/*LINHA E COLUNA - SEGUINDO*/
	aAdd(aC,{"cCodigo",{20,10},"Codigo","@!", /* Validação*/, /*F3*/,nOpc == 3})
	aAdd(aC,{"dData",{20,75},  "Data",/* PICTURE */, /* Validação*/, /*F3*/,nOpc == 3})
	aAdd(aC,{"cNome",{20,140}, "Solicitante","@!", /* Validação*/, /*F3*/,nOpc == 3})
	
	// Formulário para cadastro com GRID
	if Modelo2( cTitulo, aC, aR /*COISA DO RODAPÉ */, aGd, nOpc, /*cLinhaOk*/, /*cTudoOk*/,/* aGetsD*/, bF4,/* cIniCpos - Ao pressionar a tecla para baixo*/, nMax,/* aCordW*/, /*lDelGetD - permite deletar linha*/, lMaximazed)
		fGravaDados(cAlias,nRec,nOpc)
	Else
		ROLLBACKSX8()
	EndIf
Return (NIL)


Static Function fHeader(cAlias)

/////////////////////////////////////////////////////////////////////
// Cria vetor aHeader. -  VERIFICA A TABELA DE CAMPOS              //                             //
/////////////////////////////////////////////////////////////////////

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias)

	While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAlias

		If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo é usado.
			cNivel >= SX3->X3_Nivel .And.;                  // Nivel do Usuario é maior que o Nivel do Campo.
			!AllTrim(SX3->X3_CAMPO) $ "Z0_COD|Z0_DATA|Z0_NOME"
     
			AAdd(aHeader, {Trim(SX3->X3_Titulo),;
				SX3->X3_Campo       ,;
				SX3->X3_Picture     ,;
				SX3->X3_Tamanho     ,;
				SX3->X3_Decimal     ,;
				SX3->X3_Valid       ,;
				SX3->X3_Usado       ,;
				SX3->X3_Tipo        ,;
				SX3->X3_Arquivo     ,;
				SX3->X3_Context})
		EndIf
		SX3->(dbSkip())
	Enddo
Return nil
       
Static Function faCols(cAlias,nRec,nOpc)
   
	if nOpc==3
		cCodigo:= M->Z0_COD
		dData := Criavar("Z0_DATA")
		cNome := Criavar("Z0_NOME")
	   
		/*MONTA A MINHA GRIS DE ACORDO COM A MINHA FUNÇÂO DO AHEADER - OU SEJA VERIFICA OS CAMPOS COLOCADOS LÀ MAIS O DELETE*/
	   // Cria uma linha em branco e preenche de acordo com o Inicializador-Padrao do Dic.Dados.
		AAdd(aCols, Array(Len(aHeader)+1))
	   
		For i := 1 To Len(aHeader)
			aCols[1][i] := CriaVar(aHeader[i][2])
		Next
	   
	   // Cria a ultima coluna para o controle da GetDados: deletado ou nao.
		aCols[1][Len(aHeader)+1] := .F.
	Else
		dbSelectArea(cAlias)
		dbSetOrder(1)
  	   	 
		if MsSeek(xFilial(cAlias) +  SZ0->Z0_COD)

			cCodigo:= SZ0->Z0_COD
			dData := SZ0->Z0_DATA
			cNome := SZ0->Z0_NOME
   	 
			While ! Eof() .AND. (cAlias)->Z0_FILIAL == xFilial(cAlias) .AND. cCodigo == (cAlias)->Z0_COD
   	 	
				/*CRIA UMA LI NHA EM BRANCO E PREENCHE DE ACORDO COM O INICIALIZADOR PADRAO DO DICIONARIO DE DADOS*/
				aAdd(aCols, Array(Len(aHeader)+1))
				/*CRIA UM CAMPO PARA CONTROLE - DELETADO POU NÂO*/
				aCols[Len(aCols),Len(aHeader)+ 1] := .F.

				For i:= 1 to Len(aHeader)
					
					if AllTrim(aHeader[i][2]) == "Z0_DESCR"
						aCols[ Len(aCols), i] := Posicione("SB1",1,xFilial("SB1")+ SZ0->Z0_PROD,"B1_DESC")
					ElseIf AllTrim(aHeader[i][2]) == "Z0_TOTAL"
						aCols[ Len(aCols), i] := SZ0->Z0_QTD * SZ0->Z0_VALOR
					else
						//OU aCols[ Len(aCols), i] := SZO -> &aHeader[i][2] // SZ0->Z0_PRODUTO
						aCols[ Len(aCols), i] := FieldGet(Fieldpos(aHeader[i][2])) // SZO->ZO_PRODUTO
					EndIf
				Next
				/*RETORNA O RECNO DO REGISTRO ONDE ESTOU POSICIONADO*/
				aAdd(aAlt,Recno())
				
				(cAlias)->(dbSkip())
			EndDO
		EndIf
	EndIf
Return nil
 
Static Function fGravaDados(cAlias,nRec,nOpc)
		
	if nOpc == 3
		/*PERCORRENDO AS LINHAS DIGITADAS PELOS ITENS*/
		for nLinha := 1 To len(aCols)
			
			/* VERIFICANDO OS ARQUIVOS QUANDO ESTES ESTIVEREM DELETADOS - QUANDO DELETADO ASSUME O VALOR DE FALASO*/
			If aCols[nLinha,len(aHeader)+1]
				Loop
			EndIf
			
			RecLock(cAlias,.T.) //INCLUIR
			
			/*PERCORRENDO OS CAMPOS DE CADA LINHA*/
			for nCampo := 1 To len(aHeader)
				/*AHEADER NÂO È IGUAL AO DA TABELA SX3*/
				(cAlias)->Z0_FILIAL := xFilial("SZ0")
				(cAlias)->Z0_COD :=  cCodigo
				(cAlias)->Z0_DATA := dData
				(cAlias)->Z0_NOME := cNome
				Fieldput(Fieldpos(aHeader[nCampo,2]), aCols[nLinha,ncampo])
			next nCampo
		next nLinha
		
		ConfirmSX8()
		MsUnlock() //LIBERA O REGISTRO
	ElseIf nOpc == 4
/*PERCORRENDO AS LINHAS DIGITADAS PELOS ITENS*/
For nLinha := 1 To Len( aCols ) // Quantidade de linha
			
	If nLinha <= Len(aAlt)
			
		dbGoto(aAlt[nLinha])
					
		RecLock(cAlias,.F. )
		If aCols[nLinha ,Len(aHeader)+1]
			DbDelete()
		Else
			For nCampo := 1 To Len(aHeader)
				(cAlias)->Z0_FILIAL := xFilial("SZ0")
				(cAlias)->Z0_COD  := cCodigo
				(cAlias)->Z0_DATA := dData
				(cAlias)->Z0_NOME := cNome
				FieldPut(FieldPos(aHeader[nCampo,2]),  aCols[nLinha,nCampo])
			Next nCampo
		EndIf
		MsUnLock()
	Else

		RecLock(cAlias,.T. )
				
		For nCampo := 1 To Len(aHeader)
			(cAlias)->Z0_FILIAL := xFilial("SZ0")
			(cAlias)->Z0_COD  := cCodigo
			(cAlias)->Z0_DATA := dData
			(cAlias)->Z0_NOME := cNome
			FieldPut(FieldPos(aHeader[nCampo,2]),  aCols[nLinha,nCampo])
		Next nCampo
		MsUnLock()
	Endif
		Next nLinha
	Elseif nOpc == 5
		dbSelectArea(cAlias)
		(cAlias)->(dbSetOrder(1))
  	   	 
		if MsSeek(xFilial(cAlias) +  cCodigo)
			While ! Eof() .AND. (cAlias)->Z0_FILIAL == xFilial(cAlias) .AND. cCodigo == (cAlias)->Z0_COD
				RecLock(cAlias,.F.) //DELETAR
				dbDelete()
				MsUnlock()
				dbSkip()
			EndDo
		EndIf
	EndIf
return