#Include "TOTVS.ch"

User Function xModelo3()

Private cCadastro := "Modelo 3"
Private cFornece  := ""
Private cAlias1   := "SZ2"            // Alias da Enchoice. Tabela Pai   CAPA
Private cAlias2   := "SZ3"            // Alias da GetDados. Tabela Filho ITEM
Private cIniCpos  := "+Z3_ITEM"       // Campo que vai auto incrementar
Private nTotal    := 0

Private aRotina   := {}
Private aSize     := {}
Private aInfo     := {}
Private aObj      := {}
Private aPObj     := {}
Private aPGet     := {}

Private bCampo    := {|nField| FieldName(nField) }                                         

Private oFornece
Private oTotal                    

	// Retorna a area util das janelas Protheus
	aSize := MsAdvSize()
	
	// Ser� utilizado tr�s �reas na janela
	// 1� - Enchoice, sendo 80 pontos pixel
	// 2� - MsGetDados, o que sobrar em pontos pixel � para este objeto
	// 3� - Rodap� que � a pr�pria janela, sendo 15 pontos pixel
	
	AADD( aObj, { 100, 080, .T., .F. })
	AADD( aObj, { 100, 100, .T., .T. })
	AADD( aObj, { 100, 015, .T., .F. })
	
	// C�lculo autom�tico da dimens�es dos objetos (altura/largura) em pixel
	
	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPObj := MsObjSize( aInfo, aObj )
	
	// C�lculo autom�tico de dimens�es dos objetos MSGET
	
	aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 315, { {004, 024, 240, 270} } )
	
	AADD( aRotina, {"Pesquisar"  , "AxPesqui" , 0, 1} )
	AADD( aRotina, {"Visualizar" , 'U_Mod3Mnt', 0, 2} )
	AADD( aRotina, {"Incluir"    , 'U_Mod3Mnt', 0, 3} )
	AADD( aRotina, {"Alterar"    , 'U_Mod3Mnt', 0, 4} )
	AADD( aRotina, {"Excluir"    , 'U_Mod3Mnt', 0, 5} )
	
	dbSelectArea(cAlias1)	
	dbSetOrder(1) 
	dbGoTop()
	
	MBrowse(,,,,cAlias1)                                                   

Return()

//+--------------------------------------------------------------------+
//| Rotina | Mod3Mnt | Autor |                      | Data |           |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para Visualizar, Alterar e Excluir dados.          |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o. 									  |
//+--------------------------------------------------------------------+

User Function Mod3Mnt( cAlias, nReg, nOpc )

Local nX       := 0
Local nOpcA    := 0      
Local cDelOk   := "AllwaysTrue"
Local cFieldOk := "AllwaysTrue" 

Local cLinOk   := "U_Mod3LOk"    // Fun�ao para valida��o da linha
Local cTudoOk  := "U_Mod3TOk"  // Fun�ao para valida��o de todas as linhas                   
Local lDeleta  := .T.
Local oDlg, oGet

Private aHeader := {}
Private aCOLS   := {}
Private aGets   := {}
Private aTela   := {}
Private aREG    := {}

	//Cria variaveis de memoria dos campos da tabela Pai Capa.
	RegToMemory(cAlias1, (nOpc==3))

	//Cria variaveis de memoria dos campos da tabela Filho Item.
	RegToMemory(cAlias2, (nOpc==3))

	Mod3aHeader(cAlias1, cAlias2)
	
	Mod3aCOLS(cAlias1, cAlias2, nOpc )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL

	EnChoice( cAlias, nReg, nOpc, , , , , aPObj[1])
// Atualiza��o do nome do Fornecedor
	@ aPObj[3,1],aPGet[1,1] SAY "Fornecedor: " SIZE 70,7 OF oDlg PIXEL
	@ aPObj[3,1],aPGet[1,2] SAY oFornece VAR cFornece SIZE 98,7 OF oDlg PIXEL
// Atualiza��o do total
	@ aPObj[3,1],aPGet[1,3] SAY "Valor Total: " SIZE 70,7 OF oDlg PIXEL
	@ aPObj[3,1],aPGet[1,4] SAY oTotal VAR nTotal PICTURE "@E 9,999,999,999.99" SIZE 70,7 OF oDlg PIXEL
	
	U_Mod3Cli() // Dados do Fornecedor         
	U_Mod3LOk() // Somas do Produto
	
	oGet := MSGetDados():New(aPObj[2,1],aPObj[2,2],aPObj[2,3],aPObj[2,4], nOpc,cLinOk,cTudoOk,cIniCpos,lDeleta,,,,,cFieldOk,,,cDelOk,,,)
	
 ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIF( Obrigatorio( aGets, aTela ), ( nOpcA := 1, oDlg:End() ), NIL ) },{|| oDlg:End() })

If nOpcA == 1
	Mod3Grv( cAlias1, cAlias2, nOpc, aREG ) // Grava dados		   
EndIf

Return( NIL )
//************************************************************************************************************************

//+--------------------------------------------------------------------+
//| Rotina | Mod3aHeader | Autor |                         |Data|      |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aHeader. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o. |
//+--------------------------------------------------------------------+
Static Function Mod3aHeader(cAlias1, cAlias2)
Local aArea := GetArea()

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias2)
	
	While !SX3->(EOF()) .And. SX3->X3_ARQUIVO == cAlias2
		If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
	
	      AADD( aHeader, { Trim( X3Titulo() ) ,;
										X3_CAMPO     ,;
							            X3_PICTURE   ,;
										X3_TAMANHO   ,;
								        X3_DECIMAL   ,;
										X3_VALID     ,;
								        X3_USADO	 ,;
								        X3_TIPO		 ,;
								        X3_ARQUIVO	 ,;
								        X3_CONTEXT     })
		Endif
		SX3->(dbSkip())
	EndDo

RestArea(aArea)

Return()

//--------------------------------------------------------------------------------------------------------------------

Static Function Mod3aCOLS(cAlias1, cAlias2, nOpc )

Local cChave := ""

Local nI := 0

If nOpc <> 3 // diferente de incluir

	cChave := (cAlias1)->Z2_COD
	
	dbSelectArea( cAlias2 )
	dbSetOrder(1)
	dbSeek( xFilial(cAlias2) + cChave )

	While ! (cAlias2)->( EOF() ) .AND. ( (cAlias2)->Z3_FILIAL == xFilial(cAlias2) .AND. (cAlias2)->Z3_COD == cChave )
		AADD( aREG, SZ3->( RecNo() ) )
		AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
		
		For nI := 1 To Len( aHeader )
			If aHeader[nI,10] == "V"
				aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)
			Else
				aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next nI
		
		aCOLS[ Len( aCOLS ), Len( aHeader ) + 1 ] := .F. //Adicionando o campo do Delete
		
		(cAlias2)->(dbSkip())
		
	EndDo 
	
Else

	AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
	
	For nI := 1 To Len( aHeader )
		aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
	Next nI
	
	aCOLS[1, AScan(aHeader,{|x| Trim(x[2])=="Z3_ITEM"})] := "01" // Atribui no valor := 01 na array na possi��o do Z3_ITEM
	aCOLS[1, Len( aHeader ) + 1 ] := .F.                         // Criar o elemento para deletar a linha
	
Endif                                  


Return()
//--------------------------------------------------------------------------------------------------------------------

//+--------------------------------------------------------------------+
//| Rotina | Mod3Cli | Autor | TOTVS CTT |           Data |            |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para atualizar a vari�vel com o nome do cliente.   |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o.                              |
//+--------------------------------------------------------------------+

User Function Mod3Cli()
Local lRet := .T.
	
	cFornece := Posicione( "SA2", 1, xFilial("SA2") + M->Z2_CODFOR + M->Z2_LOJAFOR, "A2_NREDUZ" )
	oFornece:Refresh()
	
Return(lRet)

//--------------------------------------------------------------------------------------------------------------------

//+--------------------------------------------------------------------+
//| Rotina | Mod3LOk | Autor | TOTVSCTT                     |Data |    |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para atualizar a varadmini�vel com o total dos itens. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o. |
//+--------------------------------------------------------------------+
User Function Mod3LOk()
Local lRet := .T.
Local nI :=0
Local nQtdVen := nPrcven := 0     

	nPrcven :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_QTD"})
	nQtdVen :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR"})

	nTotal := 0
	
	For nI := 1 To Len( aCOLS ) //aCOLS - quantidades de linhas no grid
	
		If aCOLS[nI,Len(aHeader)+1] // Se a linha for deletada, n�o calcula
			Loop
		Endif
		
		nTotal += Round( aCOLS[ nI, nQtdVen ] * aCOLS[ nI, nPrcven ], 2 )
		
	Next nI         
	
	oTotal:Refresh()
	
Return(lRet)           

//+--------------------------------------------------------------------+
//| Rotina | Mod3TOk | Autor | TOTVS CTT             |Data |           |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar os itens se foram preenchidos. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o. |
//+--------------------------------------------------------------------+

User Function Mod3TOk()

Local nI := 0
Local lRet := .T.                   
Local nQtdVen := nPrcven := nProd := ""
                                             
	nProd   :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_CODPRO"})
	nQtdVen :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_QTD"   })
	nPrcven :=  AScan(aHeader,{|x| Trim(x[2])=="Z3_VALOR" })


	For nI := 1 To Len(aCOLS)
	
		If aCOLS[nI, Len(aHeader)+1] // Se for Deletado
			Loop
		Endif

		If Empty(aCOLS[nI,nProd]) .And. lRet
			MsgAlert("Campo PRODUTO preenchimento obrigatorio",cCadastro)
			lRet := .F.
		Endif

		If Empty(aCOLS[nI,nPrcven]) .And. lRet
			MsgAlert("Campo QUANTIDADE preenchimento obrigatorio",cCadastro)
			lRet := .F.
		Endif
		
		If Empty(aCOLS[nI,nQtdVen]) .And. lRet
			MsgAlert("Campo PRECO UNITARIO preenchimento obrigatorio",cCadastro)
			lRet := .F.
		Endif
		
		If !lRet
			Exit
		Endif

	Next i

Return( lRet )

//+--------------------------------------------------------------------+
//| Rotina | Mod3Grv | Autor | TOTVSCTT             |Data |            |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para efetuar a grava��o nas tabelas. |
//+--------------------------------------------------------------------+
//| Uso | Para treinamento e capacita��o. |
//+--------------------------------------------------------------------+

Static Function Mod3Grv( cAlias1, cAlias2, nOpc, aREG )
Local nX := 0
Local nI := 0
Local nProd := GdFieldPos("Z3_CODPRO") // Pega a posi��o no grid do campo especificado
	
	If nOpc == 3 //INCLUS�O

	// Grava os itens
	
		dbSelectArea(cAlias2)
		dbSetOrder(1)
		
		For nX := 1 To Len( aCOLS )
		
			If ! aCols[nX][Len(aHeader)+1] .AND. ! Empty(aCols[nX,nProd])      //! aCols[nX][Len(aHeader)+1] -  Valida se a linha esta deletada | .AND. ! Empty(aCols[nX,nProd]) - verifica se a linha e o produto est�o vazio
				
				RecLock( cAlias2, .T. )
				
					For nI := 1 To Len( aHeader )
						FieldPut( FieldPos( Trim( aHeader[nI, 2] ) ), aCOLS[nX,nI] )
					Next nI
					
					SZ3->Z3_FILIAL := xFilial("SZ3")
					SZ3->Z3_COD    := M->Z2_COD //Utilizar a variavel de memoria, pois o cabe�alho � gravado depois do item
				MsUnLock()                      //Caso o cabe�alho serja gravado primeiro, pode-se utilizar SZ2->Z2_COD,
			Endif                               //mas o mais recomendado � sempre utilziar a variavel de mem�ria M->
		Next nX
		
		// Grava o Cabe�alho

		dbSelectArea( cAlias1 )	
		RecLock( cAlias1, .T. )
	
			For nX := 1 To (cAlias1)->( FCount() )
				If "FILIAL" $ FieldName( nX )
					FieldPut( nX, xFilial( cAlias1 ) )
				Else
					FieldPut( nX, M->&( Eval( bCampo, nX ) ) )
				Endif
			Next nX
		MsUnLock()
		
    

	Endif
	
	
	If nOpc == 4 //ALTERA��O
	
	// Grava os itens conforme as altera��es
		dbSelectArea(cAlias2)
		dbSetOrder(1)
		
		For nX := 1 To Len( aCOLS )
			If nX <= Len( aREG )
				dbGoto( aREG[nX] )
	
				RecLock(cAlias2,.F.)
					If aCOLS[ nX, Len( aHeader ) + 1 ]
						dbDelete()
					Endif
			Else
				If !aCOLS[ nX, Len( aHeader ) + 1 ]
					RecLock( cAlias2, .T. )
				Endif
			Endif
	
			If !aCOLS[ nX, Len(aHeader)+1 ]
		
				For nI := 1 To Len( aHeader )
					FieldPut( FieldPos( Trim( aHeader[ nI, 2] ) ),;
					aCOLS[ nX, nI ] )
				Next nI
		
				
				SZ3->Z3_FILIAL := xFilial("SZ3")
				SZ3->Z3_COD    := SZ2->Z2_COD
		
			Endif
	
			MsUnLock()

		Next nX
	
	// Grava o Cabe�alho
	
		dbSelectArea(cAlias1)
			
		RecLock( cAlias1, .F. )
			
			For nx := 1 To (cAlias1)->(FCount()) 
				If "FILIAL" $ FieldName( nX )
					FieldPut( nX, xFilial(cAlias1))
				Else
					FieldPut( nX, M->&( Eval( bCampo, nX ) ) )
				Endif
			Next nx
			
		MsUnLock()
		
	Endif
	
	
	If nOpc == 5 // EXCLUS�O
		// Deleta os Itens
		dbSelectArea(cAlias2)
		dbSetOrder(1)

		dbSeek(xFilial(cAlias2) + M->Z2_COD)		

		While ! (cAlias2)->(EOF()) .AND. ( (cAlias2)->Z3_FILIAL+(cAlias2)->(Z3_COD) == xFilial(cAlias1)+M->Z2_COD)
			RecLock(cAlias2, .F.)
				dbDelete()
			MsUnLock()
			(cAlias2)->(dbSkip())
		EndDo

		// Deleta o Cabe�alho
		dbSelectArea(cAlias1)
		
		
		RecLock(cAlias1,.F.)
			dbDelete()
		MsUnLock()
	Endif   
	
	ConfirmSX8()
	
	
Return( NIL )