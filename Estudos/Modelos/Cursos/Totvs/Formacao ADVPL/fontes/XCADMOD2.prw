#Include 'Protheus.ch'

User Function XCADMOD2()
	Local oBrowser := FwmBrowse():New()

	oBrowser:SetAlias("SZ0")
	oBrowser:SetDescription("Modelo 2 Cadastro sucata")

	oBrowser:AddLegend("Z0_ATIVO=='S'","BR_MARRON","Ativo"     )
	oBrowser:AddLegend("Z0_ATIVO=='N'","BR_PINK"  ,"Desativado")



	oBrowser:Activate() // Ativando o obj

Return( NIL )


Static Function MenuDef()
	Local aRotina := {}

	aRotina := {;
		{ "Pesquisar" , "AxPesqui"  , 0, 1},;
		{ "Visualizar", "U_MDL02SZ0", 0, 2},;
		{ "Incluir"   , "U_MDL02SZ0", 0, 3},;
		{ "Alterar"   , "U_MDL02SZ0", 0, 4},;
		{ "Excluir"   , "U_MDL02SZ0", 0, 5},;
		{ "Legenda"   , "U_LEGSZ0"  , 0, 7};
		}
Return(aRotina)
//----------------------------------------------------------------------------

User Function MDL02SZ0(cAlias,nReg,nOpc)
	Local cTitulo    := "Cadastro de sucata"
	Local aC         := {}
	Local aR         := {}
	Local aGetsD     := {}
	Local bF4        := {|| Msginfo("Exemplo F4")}
	Local nMax       := 99
	Local lMaximazed := .T.


	Private cCodigo := ""
	Private dData   := Date()
	Private cNome   := ""
	Private aGd     := {70,05,300,600} // tamanho do grid

	Private aHeader := {}
	Private aCols   := {}
	Private aAlt    := {}
	

	RegToMemory(cAlias,nOpc==3)
	
	fHeader(cAlias)
	faCols(cAlias,nReg,nOpc)

	aAdd( aC, {"cCodigo",{20,005} ,"Codigo"       ,"@!"       ,/*VALIDAÇÃO*/,/*F3*/,nOpc==3 } )
	aAdd( aC, {"dData"  ,{20,100} ,"Data"         ,/*Picture*/,/*VALIDAÇÃO*/,/*F3*/,nOpc==3 } )
	aAdd( aC, {"cNome"  ,{20,180} ,"Solicitante"  ,"@!"       ,/*VALIDAÇÃO*/,/*F3*/,nOpc==3 } )

// Formulário para cadastro com Grid
	If Modelo2( cTitulo, aC ,aR, aGd, nOpc ,/*cLinhaOk*/ ,/*cTudoOk*/ ,/*aGetsD*/ ,bF4 ,/*cIniCpos*/,nMax ,/*aCordW*/, /*lDelGetD*/, lMaximazed )
		fGravaDados(cAlias,nReg,nOpc)
	Else
		RollbackSx8()
	EndIf

Return( NIL )
//-------------------------------------------------------------------
Static Function faCols(cAlias,nRec,nOpc)
	
	If nOpc == 3
		cCodigo := M->Z0_COD
		dData   := CriaVar( "Z0_DATA" )
		cNome   := CriaVar( "Z0_NOME" )

   // Cria uma linha em branco e preenche de acordo com o Inicializador-Padrao do Dic.Dados.
		AAdd(aCols, Array(Len(aHeader)+1))
		For i := 1 To Len(aHeader)
			aCols[1][i] := CriaVar(aHeader[i][2])
		Next
   
   // Cria a ultima coluna para o controle da GetDados: deletado ou nao.
		aCols[1][Len(aHeader)+1] := .F.
	Else

		dbSelectArea(cAlias)
		(cAlias)->( dbSetOrder(1) )

		If MsSeek(xFilial(cAlias)+SZ0->Z0_COD)
		
			cCodigo := SZ0->Z0_COD
			dData   := SZ0->Z0_DATA
			cNome   := SZ0->Z0_NOME
	   
			While ! Eof() .AND. (cAlias)->Z0_FILIAL == xFilial(cAlias) .AND. cCodigo == (cAlias)->Z0_COD
			
			
			 // Cria uma linha em branco e preenche de acordo com o Inicializador-Padrao do Dic.Dados.
				AAdd(aCols, Array(Len(aHeader)+1))
			 // Cria a ultima coluna para o controle da GetDados: deletado ou nao.
				aCols[Len(aCols), Len(aHeader)+1 ] := .F.
			
			
				For i := 1 To Len(aHeader)
			
					If Alltrim( aHeader[i][2] ) == "Z0_DESCR"
						aCols[ Len(aCols) , i] := Posicione("SB1",1,xFilial("SB1")+SZ0->Z0_PROD,"B1_DESC")
					ElseIf Alltrim( aHeader[i][2] ) == "Z0_TOTAL"
						aCols[ Len(aCols) , i] := SZ0->Z0_QTD * SZ0->Z0_VALOR
					Else
						aCols[ Len(aCols) , i] := FieldGet( FieldPos(aHeader[i][2]) ) // SZ0->Z0_PRODUTO
			//	aCols[ Len(aCols) , i] := SZ0->&aHeader[i][2] // SZ0->Z0_PRODUTO
					Endif
				Next
				aAdd( aAlt, Recno() )
				
				(cAlias)->(dbSkip())
			EndDo
		EndIf
	




	Endif




Return( NIL )
//-------------------------------------------------------------------
Static Function fHeader(cAlias)

/////////////////////////////////////////////////////////////////////
// Cria vetor aHeader.                                             //
/////////////////////////////////////////////////////////////////////

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias)

	While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAlias

		If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo é usado.
			cNivel >= SX3->X3_Nivel .And.;                  // NIVEL DO USUARIO É MAIOR QUE O NIVEL DO CAMPO.
			! Alltrim(SX3->X3_CAMPO) $ "Z0_COD|Z0_DATA|Z0_NOME"
     
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

//--------------------------------------------------------------------------------
Static Function fGravaDados(cAlias,nReg,nOpc)

	If nOpc == 3
	
		For nLinha := 1 To Len( aCols ) // Quantidade de linha
		
			If aCols[nLinha ,Len(aHeader)+1]
				Loop
			Endif
		
			RecLock(cAlias,.T. )
		
			For nCampo := 1 To Len(aHeader)
	
				(cAlias)->Z0_FILIAL := xFilial("SZ0")
				(cAlias)->Z0_COD  := cCodigo
				(cAlias)->Z0_DATA := dData
				(cAlias)->Z0_NOME := cNome
				FieldPut(FieldPos(aHeader[nCampo,2]),  aCols[nLinha,nCampo])
			Next nCampo
		Next nLinha
	
		ConfirmSX8()
		MsUnLock()

ElseIf nOpc == 4
			
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
			
	
ElseIf nOpc == 5
	dbSelectArea(cAlias)
	(cAlias)->( dbSetOrder(1) )

		If MsSeek(xFilial(cAlias)+cCodigo)
			While ! Eof() .AND. (cAlias)->Z0_FILIAL == xFilial(cAlias) .AND. cCodigo == (cAlias)->Z0_COD
				RecLock(cAlias,.F.)
					dbDelete()
				msUnLock()	
				dbSkip()
			Enddo
	 EndIf	

Endif

Return()










