#Include 'Protheus.ch'

/*
Cl�udia Balestri - Modelo 2 - 04/05/2019
*/

User Function XCADMOD2() //NOME DO FONTE TEM QUE SER IGUAL AO NOME DA FUN��O PRINCIPAL
Local oBrowser := FwmBrowse():New()

oBrowser:SetAlias("SZ0")
oBrowser:SetDescription("Modelo 2 Cadastro Sucata")
oBrowser:AddLegend("Z0_ATIVO == 'S'", "BR_MARRON","Ativo")
oBrowser:AddLegend("Z0_ATIVO == 'N'", "BR_PINK","Desativado")
oBrowser:Activate() //Ativando o objeto

Return(NIL)

Static Function MenuDef() //Barra de bot�es
Local aRotina:={}

	aRotina :=  {;
				{ "Pesquisar"  ,  "AxPesqui", 0, 1},;
				{ "Visualizar" ,  "U_MDL02SZ0", 0, 2},;
				{ "Incluir"    ,  "U_MDL02SZ0", 0, 3},;
				{ "Alterar"    ,  "U_MDL02SZ0", 0, 4},;
				{ "Exlcuir"    ,  "U_MDL02SZ0", 0, 5},;
				{ "Legenda"    ,  "U_LEGSZ0", 0, 7};
				}

Return(aRotina)

User Function MDL02SZ0(cAlias, nReg, nOpc)
Local cTitulo:="Cadastro de Sucata"
Local aC     := {}
Local aR     := {}
Local aGetsD := {}
Local bF4    := {|| MsgInfo("Exemplo F4")}

Private cCodigo    := ""
Private dData      := DATE()
Private cNome      := ""
Private nMax       := 99
Private lMaximazed := .T.
Private aGd        := {70,05,300,600} //tamanho do grid
Private aHeader    := {}
Private aCols      := {}
Private aAlt       := {}

	RegToMemory(cAlias, nOpc==3)
	
	fHeader(cAlias)
	fAcols(cAlias,nReg,nOpc)

	aAdd(aC,{"cCodigo" ,{15,005},"Codigo"      ,"@!",/*VALIDACAO*/,/*F3*/,nOpc==3})
	aAdd(aC,{"dData"   ,{15,100},"Data"        ,/*Picture*/,/*VALIDACAO*/,/*F3*/,nOpc==3})
	aAdd(aC,{"cNome"   ,{15,200},"Solicitante" ,"@!",/*VALIDACAO*/,/*F3*/,nOpc==3})
	/*
	aC[n,1] = Nome da Vari�vel Ex.:"cCliente"
	aC[n,2] = Array com coordenadas do Get [x,y], em Windows est�o em PIXEL
	aC[n,3] = Titulo do Campo
	aC[n,4] = Picture
	aC[n,5] = Valida��o
	aC[n,6] = F3
	aC[n,7] = Se campo � editavel .T. se n�o .F.
	*/
  
	//Modelo2 - Formul�rio para cadastro com Grid 
	//XrET := Modelo2( cTitulo,aC,aR,aGd,  nOpc,/*cLinhaOk*/,/*cTudoOk*/,/*aGetsD*/, bF4,/*cIniCpos*/, nMax,/*aCordW*/,/*lDelGetD*/, lMaximazed)
	//msginfo(cvaltochar(xret)) para saber o que retorna
	
	if Modelo2( cTitulo,aC,aR,aGd,  nOpc,/*cLinhaOk*/,/*cTudoOk*/,/*aGetsD*/, bF4,/*cIniCpos*/, nMax,/*aCordW*/,/*lDelGetD*/, lMaximazed)
	   fGravaDados(cAlias,nOpc)
	else
	   RollBackSx8()
	endif
	
 
Return(NIL)

Static Function fHeader(cAlias)
/////////////////////////////////////////////////////////////////////
// Cria vetor aHeader.                                             //
/////////////////////////////////////////////////////////////////////

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)

While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAlias

   If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo � usado.
      cNivel >= SX3->X3_Nivel .And.;                 // Nivel do Usuario � maior que o Nivel do Campo.
      ! Alltrim(SX3->X3_CAMPO) $  "Z0_COD|Z0_DATA|Z0_NOME"
      
      //aHeader define as propriedades dos campos
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

Return(Nil)

Static Function fAcols(cAlias,nRec, nOpc)

	if nOpc == 3
	
		cCodigo := M->Z0_COD//CriaVar("Z0_COD")
		dData   := CriaVar("Z0_DATA")
		cNome   := CriaVar("Z0_NOME")
	
		/////////////////////////////////////////////////////////////////////
		// Cria vetor aCols.                                               //
		/////////////////////////////////////////////////////////////////////
	   
	   // Cria uma linha em branco e preenche de acordo com o Inicializador-Padrao do Dic.Dados.
	   AAdd(aCols, Array(Len(aHeader)+1)) //array - cria uma estrutura de vetor +1 = .t. ou .f. se a linha est� deletada
	   
	   For i := 1 To Len(aHeader)
	       aCols[1][i] := CriaVar(aHeader[i][2])
	   Next aHeader
	   
	   // Cria a ultima coluna para o controle da GetDados: deletado ou nao.
	   aCols[1][Len(aHeader)+1] := .F.
	else
	   
	   dbSelectarea(cAlias)
	   dbsetorder(1)
	   if msseek(xfilial(cAlias)+SZ0->Z0_COD)
	   
	      cCodigo :=  (cAlias)->Z0_COD  
		  dData   :=  (cAlias)->Z0_DATA 
		  cNome   :=  (cAlias)->Z0_NOME 
		  
	      While ! eof() .AND. (cAlias)->Z0_FILIAL == xfilial(cAlias) .AND. cCodigo == (cAlias)->Z0_COD
	        
	        // Cria uma linha em branco e preenche de acordo com o Inicializador-Padrao do Dic.Dados.
	        AAdd(aCols, Array(Len(aHeader)+1)) //array - cria uma estrutura de vetor +1 = .t. ou .f. se a linha est� deletada
	        // Cria a ultima coluna para o controle da GetDados: deletado ou nao.
			aCols[Len(aCols)][Len(aHeader)+1] := .F. 
	   
	   		For i := 1 To Len(aHeader)
	   	         if alltrim(aheader[i][2]) == "Z0_DESCR"
	   	            aCols[Len(aCols), i]:=Posicione("SB1",1,xFilial("SB1")+SZ0->Z0_PROD,"B1_DESC")
	   	         elseif Alltrim(aHeader[i][2]) == "Z0_TOTAL"
	   	            aCols[Len(aCols), i]:= SZ0->Z0_QTD * SZ0->Z0_VALOR 
	   	         else
	   	            aCols[len(aCols),i] := FieldGet(FieldPos(aHeader[i][2])) // SZ0->Z0_PRODUTO
	       		    // ou    aCols[len(aCols),i] := SZ0->&aHeader[i][2] // SZ0->Z0_PRODUTO
	   	         endif             	
       	    Next aHeader
	              
	        aAdd(aAlt, Recno())
	        (cAlias)->(dbskip())
	      Enddo
	       
	   Endif
	
	Endif   
   
Return(NIL)   

//===================================================================

Static Function fGravadados(cAlias,nOpc)
	 	    
	if nOpc == 3 //Incluir
	       	    
			For nLinha :=1 to Len(aCols) //Quantidade de Linha
			    
			    if aCols[nLinha, Len(aHeader)+1]
			       Loop
			    Endif     
			      
	            reclock(cAlias,.T.)
	            For nCampo := 1 to len(aHeader)
	            
	                (cAlias)->Z0_FILIAL := xFilial("SZ0")
	                (cAlias)->Z0_COD    := cCodigo
	                (cAlias)->Z0_DATA   := dData
	                (cAlias)->Z0_NOME   := cNome      
	                       
	                //(cAlias)->&(FieldName(nCampo)):= M->&(FieldName(nCampo)) n�o trata campo virtual
	                SZ0->Z0_FILIAL := xFilial("SZ0")
	              	FieldPut(FieldPos(aHeader[nCampo,2]), aCols[nLinha,nCampo])  //trata campo virtual
	              	
	            Next nCampo
	            	           
	        Next nLinha
	 	         	     	    
	 	    ConfirmSX8()							
		    msunlock()
		    Msginfo("Inclu�do com Sucesso","S�QueN�o")
    elseif nOpc == 4 //alterar
         
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
			    		    
    elseif nOpc == 5 //Excluir
    
	    dbSelectarea(cAlias)
		(cAlias)->(dbsetorder(1))
	    if msseek(xfilial(cAlias)+cCodigo)	           
		      While ! eof() .AND. (cAlias)->Z0_FILIAL == xfilial(cAlias) .AND. cCodigo == (cAlias)->Z0_COD
		          RecLock(cAlias,.F.)
		          	dbDelete()
		          MsUnlock()		      
		          dbskip() 	    		    		 	  
			  Enddo  
	    endif
	    	    
	endif
	   	
Return()		