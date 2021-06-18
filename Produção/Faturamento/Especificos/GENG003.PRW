#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENG003  ºAutor  ³ Joni Fujiyama       º Data ³  30/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa contendo o help do cadastro do CGC da transportado-º±±
±±º          ³ra (para não cadastrar duas transportadora com o mesmo CGC).º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//************************************************************************************************//
User Function GENG003()
//************************************************************************************************//

Local aArea	:= GetArea()
Local aAreaSA4	:= SA4->(GetArea())
Local lRet 	:= .T.
Local _cSQL	:= ""
Local _cAlias1	:= GetNextAlias()

//SA4->(DBSETORDER(3))
//IF SA4->(DBSEEK(XFILIAL("SA4") + PADR ( ALLTRIM ( A4_CGC ) , TAMSX3("A4_CGC")[1] ) ))
//IF EXISTCHAV("SA4",XFILIAL("SA4")+M->A4_CGC,3)


//Select valor total do pedido
_cSQL := "SELECT A4_CGC, A4_NOME, A4_COD "
_cSQL += "FROM " + RetSQLName("SA4") + " SA4 "
_cSQL += "WHERE SA4.A4_FILIAL = " + ValtoSQL(xFilial("SA4")) + " "
_cSQL += "AND SA4.A4_CGC = " + ValToSQL(M->A4_CGC) + " "
_cSQL += "AND SA4.D_E_L_E_T_ = '' " 

//_cAlias1 := GetNextAlias()
_cSQL := ChangeQuery(_cSQL)

TcQuery _cSQL Alias (_cAlias1) New 

IF (_cAlias1)->(!EOF()) 

	MSGBOX("O CNPJ informado já foi cadastrado em outra transportadora. Revise a informação antes de continuar para o próximo campo.")
	
	lRet := .F.
	
ELSE

	lRet := .T.
	
ENDIF

(_cAlias1)->(DbCloseArea())
RestArea(aAreaSA4)
RestArea(aArea)
Return lRet
