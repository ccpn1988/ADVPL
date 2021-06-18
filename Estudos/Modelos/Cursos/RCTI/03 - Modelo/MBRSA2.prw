#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MBRSA2
//TODO Descri��o auto-gerada.
@author RCTI TREINAMENTOS
@since 2018
@version undefined

@type function
/*/
user function MBRSA2()
	Local cAlias 		:= "SA2"
	Local aCores 		:= {}
	Local cFiltra 		:= "A2_FILIAL == '"+xFilial('SA2')+"' .And. A2_EST == 'SP'"
	Private cCadastro 	:= "Cadastro  MBROWSE"
	Private aRotina 	:= {}
	Private aIndexSA2 	:= {}
	Private bFiltraBrw := {|| FilBrowse(cAlias,@aIndexSA2,@cFiltra)} //Filbrowse
	 
	
	AADD(aRotina,{"Pesquisar" 	,"AxPesqui" 	,0,1})
	AADD(aRotina,{"Visualizar" 	,"AxVisual" 	,0,2})
	AADD(aRotina,{"Incluir" 	,"U_BInclui" 	,0,3})
	AADD(aRotina,{"Alterar" 	,"U_BAltera" 	,0,4})
	AADD(aRotina,{"Excluir" 	,"U_BDeleta" 	,0,5})
	AADD(aRotina,{"Legenda" 	,"U_BLegenda" 	,0,6})
	
	//Acores - Legenda
	
	AADD(aCores,{"A2_TIPO == 'F'" ,"BR_VERDE"   })
	AADD(aCores,{"A2_TIPO == 'J'" ,"BR_AMARELO" })
	AADD(aCores,{"A2_TIPO == 'X'" ,"BR_LARANJA" })
	AADD(aCores,{"A2_TIPO == 'R'" ,"BR_MARROM" 	})
	AADD(aCores,{"Empty(A2_TIPO)" ,"BR_PRETO" 	})
	

	dbSelectArea(cAlias)
	dbSetOrder(1)
	
	Eval(bFiltraBrw)
	
	dbGoTop()
	mBrowse(6,1,22,75,cAlias,,,,,,aCores)
	
	EndFilBrw(cAlias,aIndexSA2)
	
return
/*------------------------------------------
	Fun��o BInclui - Inclus�o
--------------------------------------------*/
User Function BInclui(cAlias,nReg,nOpc)
	Local nOpcao := 0
	nOpcao := AxInclui(cAlias,nReg,nOpc)
		If nOpcao == 1
			MsgInfo("Inclus�o efetuada com sucesso!")
		Else
			MsgAlert("Inclus�o Cancelada!")
		EndIf	
Return
/*---------------------------------------------
	Fun��o BAltera - Altera��o
-----------------------------------------------*/
User Function BAltera(cAlias,nReg,nOpc)
	Local nOpcao := 0
	nOpcao := AxAltera(cAlias,nReg,nOpc)
		If nOpcao == 1
			MsgInfo("Altera��o efetuada com sucesso!")
		Else
			MsgAlert("Altera��o Cancelada!")
		EndIf	
Return Nil
/*-------------------------------------
	Fun��o BDeleta - Exclus�o
---------------------------------------*/
User Function BDeleta(cAlias,nReg,nOpc)
	Local nOpcao := 0
	nOpcao := AxDeleta(cAlias,nReg,nOpc)
	If nOpcao == 1                                 
		MsgInfo("Exclus�o cancelada!")           
	Else
		MsgAlert("Exclus�o efetuada com sucesso!")
	Endif
Return Nil
/*---------------------------------
	Fun��o BLegenda - Legenda
-----------------------------------*/
User Function BLegenda()
	Local aLegenda := {}
	
	AADD(aLegenda,{"BR_VERDE" ,"Pessoa F�sica"})
	AADD(aLegenda,{"BR_AMARELO" ,"Pessoa Jur�dica" 	})
	AADD(aLegenda,{"BR_LARANJA" ,"Exporta��o" 		})
	AADD(aLegenda,{"BR_MARROM" 	,"Fornecedor Rural" })
	AADD(aLegenda,{"BR_PRETO" 	,"N�o Classificado" })
	
	BrwLegenda(cCadastro, "Legenda",aLegenda)
	
Return




