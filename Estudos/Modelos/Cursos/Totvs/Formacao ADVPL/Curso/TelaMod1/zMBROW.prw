#include 'protheus.ch'
#include 'parmtype.ch'


//+--------------------------------------------------------------------+
//| Rotina | zMBROW | Autor |CAIO NEVES               | Data | 13/05/19|
//+--------------------------------------------------------------------+
//| Descr. | Rotina para Visualizar, Alterar e Excluir dados.          |
//+--------------------------------------------------------------------+
//| Uso    | Para treinamento e capacitação MBROWSE 	     		   |
//+--------------------------------------------------------------------+


user function zMBROW()
	Local cAlias := ("SRA")
	Private cTitulo := "CADASTRO FUNCIONARIOS MBROWSE"
	Private aRotina := {}
	
  //AADD(aRotina,{"Titulo"		, "Função",0,OPE})	
  
	AADD(aRotina,{"Pesquisa"	, "AxPesqui",0,1})
	AADD(aRotina,{"Visualizar"	, "AxVisual",0,2})
	AADD(aRotina,{"Incluir"		, "AxInclui",0,3})
	AADD(aRotina,{"Alterar"		, "AxAltera",0,4})
	AADD(aRotina,{"Excluir"		, "AxDeleta",0,5})
	AADD(aRotina,{"OLAMUNDO"	, "U_RCTI"	,0,6})
	
	dbSelectArea(cAlias)
	dbSetOrder(1)
	mBrowse(,,,,cAlias)
	//mBrowse(6,1,22,75,cAlias)
	
	
return

//-------------------------------------------------------------------------------------------------------------------------

//+--------------------------------------------------------------------+
//| Rotina | zFILBR | Autor |CAIO NEVES               | Data | 13/05/19|
//+--------------------------------------------------------------------+
//| Descr. | Rotina para Visualizar, Alterar e Excluir dados.          |
//+--------------------------------------------------------------------+
//| Uso    | Substituindo Função Padrão e Filtros (FILBROWSE)		   |
//+--------------------------------------------------------------------+


user function zFILBR()
	Local cAlias 		:= ("SA2")
	Local aCores 		:= {}
	Local cFiltra 		:= "A2_FILIAL == '"+xFilial('SA2')+"' .AND. A2_EST == 'SP'"
	Private cCadastro 	:= "CADASTRO FORNCEDORES MBROWSE"
	Private aRotina 	:= {}
	Private aIndexSA2 	:= {}
	Private bFiltraBrw 	:= {|| FilBrowse(cAlias,@aIndexSA2,@cFiltra)}//FILBROWSE
	
  //AADD(aRotina,{"Titulo"		, "Função"		,0,OPE})	
  
	AADD(aRotina,{"Pesquisa"	, "AxPesqui"	,0,1})
	AADD(aRotina,{"Visualizar"	, "AxVisual"	,0,2})
	AADD(aRotina,{"Incluir"		, "U_BInclui"	,0,3})
	AADD(aRotina,{"Alterar"		, "U_BAltera"	,0,4})
	AADD(aRotina,{"Excluir"		, "U_BDeleta"	,0,5})
	AADD(aRotina,{"Legenda"		, "U_BLegenda"	,0,6})
		
		
	//ACORES- LEGENDA
	//AADD(aCores,{"CAMPO '","BR_COR"})
	AADD(aCores,{"A2_TIPO == 'F'","BR_VERDE"})	
	AADD(aCores,{"A2_TIPO == 'J'","BR_AMARELO"})
	AADD(aCores,{"A2_TIPO == 'X'","BR_AZUL"})
	AADD(aCores,{"A2_TIPO == 'R'","BR_LARANJA"})
	AADD(aCores,{"Empty(A2_TIPO)","BR_PRETO"})
		
	dbSelectArea(cAlias)
	dbSetOrder(1)
	
	Eval(bFiltraBrw)
	dbGoTop()
	//mBrowse(,,,,cAlias)
	mBrowse(6,1,22,75,cAlias,,,,,,aCores)
	
	EndFilBrw(cAlias,aIndexSA2) //Encerra Filbrowse
	
	
return

//-------------------------------------------------------------------------------------------------------------------------

//+--------------------------------------------------------------------+
//| Rotina | zFILBR | Autor |CAIO NEVES               | Data | 13/05/19|
//+--------------------------------------------------------------------+
//| Descr. | Rotina para Visualizar, Alterar e Excluir dados.          |
//+--------------------------------------------------------------------+
//| Uso    | Incluir - Alterar - Excluiir - Legendas				   |
//+--------------------------------------------------------------------+


//User Function BInclui(cAlias,R_E_C_N_O,OPERAÇÂO)

User Function BInclui(cAlias,nReg,nOpc)
	Local nOpcao := 0
	nOpcao := AxInclui(cAlias,nReg,nOpc)
	
		IF nOpcao == 1
			MsgInfo("Inclusão efetuada com sucesso!")
		Else
			MsgAlert("Inclusão Cancelada")
		EndIf
	
Return
//-------------------------------------------------------------------------------------------------------------------------

User Function BAltera(cAlias,nReg,nOpc)
	Local nAlter := 0
	nAlter := AxAltera(cAlias,nReg,nOpc)
	
		IF nAlter == 1
			MsgInfo("Alteração efetuada com sucesso!")
		Else
			MsgAlert("Alteração Cancelada")
		EndIf
Return
//-------------------------------------------------------------------------------------------------------------------------

User Function BDeleta(cAlias,nReg,nOpc)
	Local nDel := 0
	nDel :=	AxDeleta(cAlias,nReg,nOpc)
	
		IF nDel == 1
			MsgInfo("Exclusão efetuada com sucesso!")
		Else
			MsgAlert("Exclusão não efetuada")
		EndIf
Return
//-------------------------------------------------------------------------------------------------------------------------

User Function BLegenda()
	Local alegenda := {}
	
	AADD(aLegenda,{"BR_VERDE"	,"Pessoa FIsica"})
	AADD(aLegenda,{"BR_AMARELO"	,"Pessoa Juridica"})
	AADD(aLegenda,{"BR_AZUL"	,"Pessoa Exportação"})
	AADD(aLegenda,{"BR_LARANJA"	,"Fornecedor Rural"})
	AADD(aLegenda,{"BR_PRETO"	,"Não Especificado"})
  
  //BrwLegenda(cCadastro,cTitulo ou Título, array)
	BrwLegenda(cCadastro,"Legenda",aLegenda)
	
Return