#Include 'Protheus.ch'

User Function xMOD2()// o Nome da função principal tem que ser exatamente igual ao nome do fonte - conceito MVC


	
	Local oBrowse	:= FwmBrowse():New()
	
	oBrowse:SetAlias("SZ0")	// Qual tabela vou usar
	oBrowse:SetDescription("Modelo 2 Cadastro de sucata") //Qual a descrição do meu browse
	
	oBrowse:AddLegend("Z0_ATIVO == 'S'","BR_MARRON","Ativo"	 )	//Adiciona legenda
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
				{ "Exlcuir"		, "U_MDL02SZ0"	, 0, 5},;
				{ "Legenda"		, "U_LEGSZ0"	, 0, 7};
				}
				
Return (aRotina)

//------------------------------------------------------------------------------------------------------

USER FUNCTION MDL02SZ0(cAlias,nReg,nOpc)
Local cTitulo := "Cadastro de Sucata"
Local aC := {}
Local aR := {}
Local aGetsD := {}
Local bF4 := {|| MsgInfo("Exemplo F4")}
Local nMax := 99
Local lMaximazed := .T.

Private cCodigo
Private dData := Date()
Private cNome := ""
Private aGd := {70,05,300,600} //TAMANHO

Private aHeader := {}
Private aCols := {}
Private aAlt := {}

RegToMemory(cAlias,nOpc==3) //GATILHO

fHeader(cAlias)//DECLARANDO AHEADER
faCols(cAlias,nReg,nOpc)//DECLARANDO ACOLS



AADD(aC, {"cCodigo"	,{20,005}	,"Código"		,"@!"		,/*VALIDÃO*/,/*F3*/		,nOpc==3})
AADD(aC, {"dData"	,{20,060}	,"Data"			,/*Picture*/,/*VALIDÃO*/,/*F3*/		,nOpc==3})
AADD(aC, {"cNome"	,{20,130}	,"Solicitante"	,"@!"		,/*VALIDÃO*/,/*F3*/		,nOpc==3})

//FORMULARIO CADASTRO GRID
IF Modelo2 ( cTitulo, aC,  aR, aGd, nOpc,/*cLinhaOk*/,/* cTudoOk*/,/*aGetsD*/, bF4, /*cIniCpos*/, nMax, /*aCordW*/,/* lDelGetD*/, lMaximazed,/*aButtons*/ )
	fGravaDados(cAlias,nReg,nOpc)
ELSE
	RollbackSx8()
ENDIF

Return(NIL)

//--------------------------------------------------------------------------------------------------------------------------

Static Function fHeader(cAlias)

 /////////////////////////////////////////////////////////////////////
// Cria vetor aHeader.  ESTRUTUA DOS CAMPOS  GRID                  //
/////////////////////////////////////////////////////////////////////

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)

While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAlias

   If X3Uso(SX3->X3_Usado)    .And.;                 	  // O Campo é usado.
      cNivel >= SX3->X3_Nivel .AND.;					  // Nivel do Usuario é maior que o Nivel do Campo.
      !ALLTRIM(SX3->X3_Campo) $ "Z0_COD|ZO_DATA#Z0_NOME"  // Define os campos não apresentados                 
     
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
Return

//-----------------------------------------------------------------------------------------------------------------------

Static Function faCols(cAlias,nRec,nOpc) //QUANTIDADE DOS CAMPOS A HEADER + 1(DELETE)

IF nOpc == 3

 cCodigo 	:= M->Z0_COD                  
 dData 		:= CRIAVAR("Z0_DATA")
 cNome 		:= CRIAVAR("Z0_NOME")

   // Cria uma linha em branco e preenche de acordo com o Inicializador-Padrao do Dic.Dados.
   AAdd(aCols, Array(Len(aHeader)+1))
   //Cria a Uultima coluna para o controle de GetDados: deletado ou não
   For i := 1 To Len(aHeader)
       aCols[1][i] := CriaVar(aHeader[i][2])
   Next
   
   // Cria a ultima coluna para o controle da GetDados: deletado ou nao.
   aCols[1][Len(aHeader)+1] := .F.
ELSE
	dbSelectArea(cAlias)
	(cAlias)->(dbSetOrder(1))
	IF MsSeek(FWxFilial(cAlias)+ SZ0->Z0_COD)
	
		cCodigo	:=SZ0->Z0_COD	
 		dData 	:=SZ0->Z0_DATA
		cNome 	:=SZ0->Z0_NOME
		
		While ! EoF() .AND. (cAlias)->Z0_FILIAL == xFilial(cAlias) .AND. cCodigo == (cAlias)->Z0_COD
		
			// Cria uma linha em branco e preenche de acordo com o Inicializador-Padrao do Dic.Dados.
	  		 AAdd(aCols, Array(Len(aHeader)+1))
	   		  // Cria a ultima coluna para o controle da GetDados: deletado ou nao.
	  		 aCols[Len(aCols),Len(aHeader)+1] := .F.
	  		 
	  		 For i := 1 To Len(aHeader)
	  		 	
	  		 	IF ALLTRIM( aHeader[i] [2]) == "Z0_DESCR"
	  		 		aCols[Len(aCols),i] := Posicione("SB1",1,xFilial("SB1")+SZ0->Z0_PROD,"B1_DESC")
	  		 	ELSEIF ALLTRIM( aHeader[i] [2]) == "Z0_TOTAL"
	  		 		aCols[Len(aCols),i] := SZ0->Z0_QTD * SZ0->Z0_VALOR
	  		 	ELSE
	     		 aCols[Len(aCols),i] := FieldGet( FieldPos(aHeader[i] [2])) //SZ0_PRODUTO
	  		 	ENDIF
	  		 Next
	      		AADD(aAlt, Recno()) //ALTERAÇÃO
	      			
			(cAlias)->(dbSkip())
		ENDDO
	ENDIF
ENDIF

 RETURN(NIL)
 //-----------------------------------------------------------------------------------------------------------------------
 
 Static Function fGravadados(cAlias,nReg,nOpc)
 
 IF nOpc == 3 //INCLUSÃO DE DADOS
		
		For nLinha := 1 To Len(aCols) // Quantidade de Linha 
		
			IF aCols[nLinha ,Len(aHeader)+1] //NÃO GRAVAR LINHA DELETADA NA INCLUSÃO
				Loop //VOLTA
			ENDIF
			
			RecLock(cAlias,.T.)
			
			For nCampo := 1 To Len(aHeader) //
								
				(cAlias)->Z0_FILIAL := xFilial("SZ0")
				(cAlias)->Z0_COD	:= cCodigo
				(cAlias)->Z0_DATA   := dData
				(cAlias)->Z0_NOME	:= cNome					
				FieldPut(FieldPos(aHeader[nCampo,2]), aCols[nLinha,nCampo])
			Next nCampo
		Next nLinha
		
		ConfirmSX8()
		MsUnLock()
		
		
ELSEIF nOpc == 4 //ALTERAçÂO
		For nLinha := 1 To Len( aCols ) // Quantidade de linha
			
				If nLinha <= Len(aAlt)
			
					dbGoto(aAlt[nLinha]) //POSICIONA NA LINHA
					
					RecLock(cAlias,.F. )
						If aCols[nLinha ,Len(aHeader)+1] //SE A LINHA FOR EXCLUIDA
								DbDelete()
						Else 
						 For nCampo := 1 To Len(aHeader)//INCLUSÂO DE NOVO DADO
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



ELSEIF nOpc == 5 //Exclusão
	dbSelectArea(cAlias)
	(cAlias)->(dbSetOrder(1))
	
	IF MsSeek(FWxFilial(cAlias)+ cCodigo)
	
		cCodigo	:=SZ0->Z0_COD	
 		dData 	:=SZ0->Z0_DATA
		cNome 	:=SZ0->Z0_NOME
		
		While ! EoF() .AND. (cAlias)->Z0_FILIAL == xFilial(cAlias) .AND. cCodigo == (cAlias)->Z0_COD
			RecLock(cAlias,.F.)
				DbDelete()
			msUnlock()
			dbSkip()
		EndDo
	ENDIF

ENDIF
 Return()
