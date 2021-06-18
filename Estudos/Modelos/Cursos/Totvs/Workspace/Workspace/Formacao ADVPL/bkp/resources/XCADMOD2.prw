#Include 'Protheus.ch'

User Function XCADMOD2() // o Nome da função principal tem que ser exatamente igual ao nome do fonte - conceito MVC
	
	Local oBrowse	:= FwmBrowse():New()
	
	oBrowse:SetAlias("SZ0")	// Qual tabela vou usar
	oBrowse:SetDescription("Modelo 2 Cadastro de sucata") //Qual a descrição do meu browse
	
	oBrowse:AddLegend("Z0_ATIVO == 'S'","BR_MARRON"	,"Ativo"	 )	//Adiciona legenda
	oBrowse:AddLegend("Z0_ATIVO == 'N'","BR_PINK"	,"Desativado")	//Adiciona legenda
	
	oBrowse:Activate()	// Ativa o OBJETO

Return

Static Function MenuDef()
	Local aRotina	:= {}

	aRotina := 	{;
				{ "Pesquisar"	, "AxPesqui"	, 0, 1},;
				{ "Visualizar"	, "U_MDL02SZ0"	, 0, 2},;
				{ "Incluir"		, "U_MDL02SZ0"	, 0, 3},;
				{ "Alterar"		, "U_MDL02SZ0"	, 0, 4},;
				{ "Excluir"		, "U_MDL02SZ0"	, 0, 5},;
				{ "Legenda"		, "U_LEGSZ0"	, 0, 7};
				}
				
Return (aRotina)

User Function MDL02SZ0(cAlias,nReg,nOpc)
Local cTitulo	 := "Cadastro de sucata"
Local aC		 := {}
Local aR		 := {}
Local aGetsD	 := {}
Local bF4		 := {|| MsgInfo("Exemplo F4")}
Local nMax		 := 99
Local lMaximazed := .T.

Private cCodigo	 := ""
Private dData	 := Date()
Private cNome	 := ""
Private aGd	 	 := {70,05,300,600} //tamano do grid

Private aHeader	 := {}
Private aCols 	 := {}
Private aAlt	 := {}

aAdd( aC, {"cCodigo",{020,005},"Codigo"	 	,"@!"		,/*Validação*/,/*F3*/,nOpc==3 } )
aAdd( aC, {"dData"	,{020,070},"Data"		,/*Picture*/,/*Validação*/,/*F3*/,nOpc==3 } )
aAdd( aC, {"cNome"	,{020,130},"Solicitante","@!"		,/*Validação*/,/*F3*/,nOpc==3 } )
/*aC
aC[n,1] = Nome da Variável Ex.:"cCliente"
aC[n,2] = Array com coordenadas do Get [x,y], em Windows estão em PIXEL
aC[n,3] = Titulo do Campo
aC[n,4] = Picture
aC[n,5] = Validação
aC[n,6] = F3
aC[n,7] = Se campo é editavel .T. se não .F.*/

RegToMemory(cAlias,nOpc==3)

fHeader(cAlias)
fAcols(cAlias,nReg,nOpc)

// Formulário para cadastro com Grid
If Modelo2(cTitulo,aC,aR,aGd,nOpc,/*cLinhaOk*/,/*cTudoOk*/,/*aGetsD*/,bF4,/*cIniCpos*/,nMax,/*aCordW*/,/*lDelGetD*/,lMaximazed)
	fGravaDados(cAlias,nReg,nOpc)
Else
	RollBackSx8()
EndIf
 
Return ( Nil )


/////////////////////////////////////////////////////////////////////
// Cria vetor aHeader.                                             //
/////////////////////////////////////////////////////////////////////
Static Function fHeader(cAlias)	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias)
	
	While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAlias
	
	   If X3Uso(SX3->X3_Usado)    .And.;            // O Campo é usado.
	      cNivel >= SX3->X3_Nivel .And.;  			// Nivel do Usuario é maior que o Nivel do Campo.
	      !(AllTrim(SX3->X3_Campo) $ "Z0_COD|Z0_DATA|Z0_NOME")  // Removendo campos do Acols
	     
	      AAdd(aHeader, {Trim(SX3->X3_Titulo),;
	                     SX3->X3_Campo       ,;
	                     SX3->X3_Picture     ,;
	                     SX3->X3_Tamanho     ,;
	                     SX3->X3_Decimal     ,;
	                     SX3->X3_Valid       ,;
	                     SX3->X3_Usado       ,;
	                     SX3->X3_Tipo        ,;
	                     SX3->X3_Arquivo     ,;
	                     SX3->X3_Context	 ,;
	                     SX3->X3_Relacao})
	
	   EndIf
	
	   SX3->(dbSkip())
	
	Enddo

Return

/////////////////////////////////////////////////////////////////////
// Cria vetor aCols	                                               //
/////////////////////////////////////////////////////////////////////
Static Function fAcols(cAlias,nRec,nOpc)

	If nOpc == 3
		cCodigo	 := M->Z0_COD
		dData	 := CriaVar("Z0_DATA")
		cNome	 := CriaVar("Z0_NOME")
		
		// Cria uma linha em branco e preenche de acordo com o Inicializador-Padrao do Dic.Dados.
		AAdd(aCols, Array(Len(aHeader)+1))	//Função ARRAY Cria a estrutura de uma matriz
	   
		For i := 1 To Len(aHeader)
			aCols[1][i] := CriaVar(aHeader[i][2])
		Next
	   
		// Cria a ultima coluna para o controle da GetDados: deletado ou nao.
		aCols[1][Len(aHeader)+1] := .F.
	Else
		dbSelectArea(cAlias)
		(cAlias)->(dbSetOrder(1))
		If MsSeek(xFilial(cAlias) + (cAlias)->Z0_COD)
		
			cCodigo	:= SZ0->Z0_COD
			dData	:= SZ0->Z0_DATA
			cNome	:= SZ0->Z0_NOME
		
			While ! Eof() .AND. (cAlias)->Z0_FILIAL == xFilial(cAlias) .AND. cCodigo == (cAlias)->Z0_COD
				
				// Cria uma linha em branco e preenche de acordo com o Inicializador padrão do Dicionario de Dados
				AAdd(aCols, Array(Len(aHeader)+1))	//Função ARRAY Cria a estrutura de uma matriz
				// Cria a ultima coluna para o controle da GetDados: deletado ou nao.
				aCols[Len(aCols),Len(aHeader)+1] := .F.
								
				/*For i := 1 To Len(aHeader)
					If AllTrim(aHeader[i,2]) == "Z0_DESCR"
						aCols[Len(aCols),i] := POSICIONE("SB1",1,XFILIAL("SB1") + (cAlias)->Z0_PROD,"B1_DESC")
					ElseiF AllTrim(aHeader[i,2]) == "Z0_TOTAL"
							aCols[Len(aCols),i] := (cAlias)->Z0_QTD * (cAlias)->Z0_VALOR
						Else                                                          
							aCols[Len(aCols),i] := FieldGet(FieldPos(aHeader[i][2]))
					EndIf
					//aCols[Len(aCols),i]) := CriaVar(aHeader[i][2])
				Next*/
				
				For i := 1 To Len(aHeader)
					If aHeader[i,10] == "V"
						aCols[Len(aCols),i] := &(aHeader[i,11]) 
					Else                                                          
						aCols[Len(aCols),i] := FieldGet(FieldPos(aHeader[i][2]))
					EndIf
					//aCols[Len(aCols),i]) := CriaVar(aHeader[i][2])
				Next

				aAdd( aAlt,Recno() ) // Grava o recno do registro que estou posicionado neste array auxiliar para ser utilizado na gravação de ALTERAÇÃO
				
				(cAlias)->(dbSkip())
			EndDo
		EndIf
	EndIf

Return


Static Function fGravaDados(cAlias,nReg,nOpc)
	
	If nOpc == 3
		For nLinha := 1 To Len( aCols ) // Quantidade de linha
			If ! aCols[nLinha][Len(aHeader)+1]
				RecLock(cAlias,.T.) 	//Cria linha de registro
					
				For nCampo := 1 To Len( aHeader )
					/*(cAlias)->&(FieldName(nCampo)) := M->&(FieldName(nCampo))*/ //Este tipo de atribuição não trata campo VIRTUAL
					(cAlias)->Z0_FILIAL	:= xFilial("SZ0")
					(cAlias)->Z0_COD	:= cCodigo
					(cAlias)->Z0_DATA	:= dData
					(cAlias)->Z0_NOME	:= cNome
					FieldPut(FieldPos(aHeader[nCampo,2]),aCols[nLinha,nCampo])
						
				Next nCampo
								
				ConfirmSX8()
				MsUnLock()
			EndIf
		Next nLinha
		
	ElseIf nOpc == 4
	
		For nLinha := 1 To Len( aCols ) // Quantidade de linha
			
			If nLinha <= Len(aAlt)
				dbGoTo(aAlt[nLinha])
				RecLock(cAlias,.F.)
				
				If aCols[nLinha][Len(aHeader)+1] //Se registro foi deletado durante a alteração
					(cAlias)->(dbDelete())
				Else
					For nCampo := 1 To Len( aHeader )
						FieldPut(FieldPos(aHeader[nCampo,2]),aCols[nLinha,nCampo])
					Next nCampo
				EndIf
				
				MsUnLock()

			Else
				RecLock(cAlias,.T.) 	//Cria linha de registro
					
				For nCampo := 1 To Len( aHeader )
					/*(cAlias)->&(FieldName(nCampo)) := M->&(FieldName(nCampo))*/ //Este tipo de atribuição não trata campo VIRTUAL
					(cAlias)->Z0_FILIAL	:= xFilial("SZ0")
					(cAlias)->Z0_COD	:= cCodigo
					(cAlias)->Z0_DATA	:= dData
					(cAlias)->Z0_NOME	:= cNome
					FieldPut(FieldPos(aHeader[nCampo,2]),aCols[nLinha,nCampo])
						
				Next nCampo
								
				ConfirmSX8()
				MsUnLock()
			EndIf
			
		Next nLinha
	
				
		/*For nLinha := 1 To Len( aCols ) // Quantidade de linha
			If ! aCols[nLinha][Len(aHeader)+1]
				RecLock(cAlias,.F.)
					
					For nCampo := 1 To Len( aHeader )
						FieldPut(FieldPos(aHeader[nCampo,2]),aCols[nLinha,nCampo])
					Next nCampo
				
				MsUnLock()
			EndIf
		Next nLinha*/
	
		MsgInfo("Alterado com sucesso","SóQueNão")
		
	ElseIf nOpc == 5
	
		dbSelectArea(cAlias)
		(cAlias)->(dbSetOrder(1))
		If MsSeek(xFilial(cAlias) + cCodigo)
		
			While ! Eof() .AND. (cAlias)->Z0_FILIAL == xFilial(cAlias) .AND. cCodigo == (cAlias)->Z0_COD

				RecLock(cAlias,.F.)
					(cAlias)->(dbDelete())
				MsUnLock()
				
				(cAlias)->(dbSkip())
			EndDo
		EndIf
		
		MsgInfo("Excluído com sucesso","SóQueNão")
			
	EndIf

Return ()