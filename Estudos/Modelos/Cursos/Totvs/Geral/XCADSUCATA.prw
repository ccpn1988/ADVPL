#Include 'Protheus.ch'

User Function XCADSUCATA()
Local oBrowser := FwMBrowse():NEW() //FwBrowse - novo browser
Private INCLUI := .T. //Na valida��o do campo SZ1_CODIGO na tabela SZ1, existe a fun��o INCLUI, por isso ela precisa ser declarada no fonte

oBrowser:SetAlias("SZ1")
oBrowser:SetDescription("Cadastro modelo 1")
oBrowser:Activate()

Return
//--------------------------------------------------------------------

Static Function MenuDef()
Local aRotina := {}
	
	 aRotina := {;
				{ "Pesquisar"  , "AxPesqui"   , 0, 1},;
				{ "Visualizar" , "U_xModelo01", 0, 2},;
				{ "Incluir"    , "U_xModelo01", 0, 3},;
				{ "Alterar"    , "U_xModelo01", 0, 4},;
				{ "Exlcuir"    , "U_xModelo01", 0, 5};
				}

Return aRotina
//--------------------------------------------------------------------

User Function xModelo01(cAlias, nReg, nOpc)

Local oSize
Local aPos
Private aGets := {}
Private aTela := {}

// Calcula as dimensoes dos objetos                                         
oSize := FwDefSize():New( .T. ) // Com enchoicebar
oSize:lLateral     := .F.  // Calculo vertical
// adiciona Enchoice       //100, 100 - Vem com a tela em 100% de aproveitamento                                                          
oSize:AddObject( "ENCHOICE", 100, 100, .T., .T. ) // Adiciona enchoice
// Dispara o calculo                                                     
oSize:Process()

    //aPos := {1,1,600,800} -  1,1 - Linha e coluna inicial || 600,800 - Linha e coluna final
aPos := {oSize:GetDimension("ENCHOICE","LININI"),;
         oSize:GetDimension("ENCHOICE","COLINI"),;
         oSize:GetDimension("ENCHOICE","LINEND"),;
         oSize:GetDimension("ENCHOICE","COLEND")} 

    //Enchoice - Cria um objeto visual para edi��o de campos baseado no Dicion�rio de Campos (SX3).
    //Enchoice(cAlias, nReg, nOpc, aCRA, cLetras, cTexto, aAcho, aPos)
    //cAlias - tabela cadastrada no SX2
    //nReg - parametro nao utilizado
    //nOpc - N�mero da linha do aRotina que definir� o tipo de edi��o (Inclus�o, Altera��o, Exclus�o, Visualiza��o)
    //aCRA - parametro nao utilizado
    //cLetras - parametro nao utilizado
    //cTexto - parametro nao utilizado
    
//dbSelectArea("SZ1")
dbSelectArea(cAlias)
    
//    M->Z1_CODIGO  := CriaVar("Z1_CODIGO")
//    M->Z1_NOME    := CriaVar("Z1_NOME")
//    M->Z1_DATA    := CriaVar("Z1_DATA")
//    M->Z1_PRODUTO := CriaVar("Z1_PRODUTO")

//RegToMemory("SZ1",.T.) //RegToMemory - executa as variaveis de mem�ria (carrega todos os campos da tabela para a memoria)
RegToMemory(cAlias,nOpc==3) //RegToMemory - executa as variaveis de mem�ria (carrega todos os campos da tabela para a memoria)
                 //nOpc = 3 (.T) - carrega os dados vazio
  	
                                      //oSize:aWindSize[x] - Recalcula o tamanho da tela pela variavel
DEFINE MSDIALOG oDlg TITLE "Cadastro" FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL  	  

		Enchoice(cAlias, nReg, nOpc, /*aCRA*/, /*cLetras*/, /*cTexto*/, /*aAcho*/, aPos)


//ACTIVATE MSDIALOG oDlg CENTERED // ACTIVATED - ativa a tela e o CENTERED deixa ela contralizada
ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{|| IIF( Obrigatorio(aGets, aTela),(fGravaSZ1(cAlias, nOpc),oDlg:End()),NIL ) } ,; //IFF - Se os campos obrigatorios forem preenchidos ele grava, se n�o ele espera e exibe a mensagem
                                                 {|| RollbackSX8(),oDlg:End()}))
                                          //Bloco de codigo a ser executado no bot�o
                                                                             //RollbackSX8() - N�o deixa registrar o sequencial       
Return (NIL)
//---------------------------------------------------------------------------------------------------------------------------------

Static Function fGravaSZ1(cAlias, nOpc)

//Exerc�cio gravar os dados da tabela SZ1 no banco

If nOpc == 3 .Or. nOpc == 4 //nOpc == 3 (Incluir) ou nOpc == 4 (Alterar)

dbSelectArea(cAlias)
RecLock(cAlias,nOpc == 3)

For nCampo := 1 To (cAlias)->(FCount()) //Fun��o FCount - retorna quantos campos tem na tabela

	If "FILIAL" $ AllTrim(FieldName(nCampo)) // Se o campo verificado for o Z1_FILIAL
	
		FieldPut(nCampo, xFilial(cAlias))
	
	ELSE
	
		FieldPut(nCampo, M->&(FieldName(nCampo))) //FieldPut - tras a posi��o do campo na tabela | FieldName - tras o nome do campo na tabela
		               //M->& - Fun��o chamada macro substitui��o (basicamente ele retira os parenteses)
	EndIf
Next		     

ConfirmSX8() //Registra o sequencial do codigo e n�o deixa se repetir

	MsUnlock()

ElseIf nOpc == 5 //nOpc == 5 (Excluir)

	RecLock(cAlias, .F.)
		(cAlias)->(dbDelete())
	MsUnlock()


EndIf
// Ou pode ser feito da maneira abaixo
	
//Reclock("SZ1",.T.) //Inclui um novo registro
//	
//	SZ1->Z1_FILIAL  := M->Z1_FILIAL
//	SZ1->Z1_CODIGO  := M->Z1_CODIGO
//	SZ1->Z1_NOME    := M->Z1_NOME
//	SZ1->Z1_DATA    := M->Z1_DATA
//	SZ1->Z1_PRODUTO := M->Z1_PRODUTO 
//	SZ1->Z1_QUANT   := M->Z1_QUANT
//	SZ1->Z1_VUNIT   := M->Z1_VUNIT
//	SZ1->Z1_OBS     := M->Z1_OBS
//	
//MsUnlock() //Commit
//
//MsgInfo("Cadastrado com sucesso")
//

Return (NIL)























