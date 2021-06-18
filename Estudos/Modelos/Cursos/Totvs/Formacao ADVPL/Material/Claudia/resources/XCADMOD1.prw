#include "rwmake.ch"

// Cl·udia Balestri - Modelo 1 - 04/05/2019

//-----------------------------------------------------------------------------------------
User function XCADMOD1()
	
	///chkFile(cAlias) ALOCA A TABELA INTEIRA
	
	Local cAlias  := "SZ0"
	Local aColors := {}
	Private cCadastro := "Cadastro de Sucata"

	aRotina :=  {;
				{ "Pesquisar"  ,  "AxPesqui", 0, 1},;
				{ "Visualizar" ,  "U_INCSZ0", 0, 2},;
				{ "Incluir"    ,  "U_INCSZ0", 0, 3},;
				{ "Alterar"    ,  "U_INCSZ0", 0, 4},;
				{ "Exlcuir"    ,  "U_INCSZ0", 0, 5},;
				{ "Legenda"    ,  "U_LEGSZ0", 0, 7};
				}
				
	aAdd(aColors,{"Z0_ATIVO == 'S'", "BR_MARRON"})	
	aAdd(aColors,{"Z0_ATIVO == 'N'", "BR_PINK"})			
		
	dbSelectArea(cAlias)
	mBrowse(,,,,cAlias, /*<aFixe>*/,/* <cCpo>*/, /*<nPar>*/,/* <cCorFun>*/, 4 /*<nClickDef>*/, aColors)	
		                                                        //COR                      //ALTERAR
	//mBrowse(,,,,cAlias, /*<aFixe>*/,/* <cCpo>*/, /*<nPar>*/, "Z0_ATIVO=='S'" /*<cCorFun>*/, 4) //<nClickDef>, <aColors>)
    //mBrowse( <nLinha1>, <nColuna1>, <nLinha2>, <nColuna2>, <cAlias>, <aFixe>, <cCpo>, <nPar>, <cCorFun>, <nClickDef>, <aColors>)
	
return(NIL)

//toda funÁ„o chamada pelo arotina tem que ser user function
User Function LEGSZ01()
Local aLegenda := {}

	aAdd(aLegenda,{"BR_MARRON", "Ativo",})
	aAdd(aLegenda,{"BR_PINK"  , "Desativado"})

    BrwLegenda ( cCadastro, "Legenda", aLegenda )
   
Return(NIL)

//--------------------------------------------------------------

User function INCSZ0(cAlias, nReg, nOpc)

Static oDlg
Private aGets := {}
Private aTela  := {}

// Calcula as dimensoes dos objetos                                       
oSize := FwDefSize():New( .T. ) // Com enchoicebar
oSize:lLateral     := .F.  // Calculo vertical
// adiciona Enchoice                                                          
oSize:AddObject( "TELA", 100, 100, .T., .T. ) // Adiciona enchoice
// adiciona folder                                                           
//oSize:AddObject( "FOLDER",100, 100, .T., .T. ) // Adiciona Folder               
// Dispara o calculo                                                     
oSize:Process()   ///OSIZE RETORNA O TAMANHO DO CONTAINER PRINCIPAL

aPos :={oSize:GetDimension("TELA","LININI"),;
	    oSize:GetDimension("TELA","COLINI"),;
	    oSize:GetDimension("TELA","LINEND"),; 
	    oSize:GetDimension("TELA","COLEND")}
	   
RegToMemory(cAlias,nOpc==3)  // CARREGA TODOS OS CAMPOS DO BANCO  -Incluir

DEFINE MSDIALOG oDlg TITLE cCadastro FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL

// Objeto visual para ediÁ„o de campos                             aAcho //Trazer somente campos especÌficos
Enchoice ( cAlias, nReg , nOpc, /*aCRA*/, /*cLetras*/, /*cTexto*/, /*aAcho*/ ,aPos)

//ACTIVATE MSDIALOG oDlg CENTERED
ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg, {|| IIF (OBRIGATORIO(aGets,aTela),;
	                                                      (FGrava(cAlias,nOpc),oDlg:End()),;
	                                                       NIL)},;
	                                              {||oDlg:End(),ROLLBACKSX8()}/*,,@aButtons*/))  

Return(NIL)

Static Function fGrava(cAlias,nOpc)
	//Exercicio fazer a gravaÁ„o dos dados
Local lINCLUIR := .F.	
	
	dbselectarea(cAlias)
	dbsetorder(1)
	//lINCLUIR := MsSeek(xfilial(cAlias)+M->Z0_COD) //n„o precisa utilizar, estava usando como controle agora usando nOPc
	
	if nOpc == 3
		reclock(cAlias,!lINCLUIR)
			For nCampo :=1 to (cAlias)->(fcount())// qtde de campos no SX3
	            //(cAlias)->&(FieldName(nCampo)):= M->&(FieldName(nCampo)) n„o trata campo virtual
	            if "FILIAL" $ FieldName(nCampo)
	                FieldPut(nCampo, xfilial(cAlias))  
	            else
	            	FieldPut(nCampo, M->&(FieldName(nCampo)))  //trata campo virtual
	            endif
	        Next nCampo
	 	     	    
	 	    ConfirmSX8()							
		msunlock()
		Msginfo("IncluÌdo com Sucesso","SÛQueN„o")
		
	elseif nOpc == 4
		reclock(cAlias,.f.)
			For nCampo :=1 to (cAlias)->(fcount())// qtde de campos no SX3
	            //(cAlias)->&(FieldName(nCampo)):= M->&(FieldName(nCampo)) n„o trata campo virtual
	            if "FILIAL" $ FieldName(nCampo)
	                FieldPut(nCampo, xfilial(cAlias))  
	            else
	            	FieldPut(nCampo, M->&(FieldName(nCampo)))  //trata campo virtual
	            endif
	        Next nCampo	        					
		msunlock()
		Msginfo("Gravado com Sucesso","SÛQueN„o")
	elseif nOpc == 5
		reclock(cAlias,.f.)
			dbDelete()	        					
		msunlock()
		Msginfo("Excluido com Sucesso","SÛQueN„o")
	endif					
	
Return()