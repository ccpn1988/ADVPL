#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"
#DEFINE cEnt CHR(13)+CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DELPROD   ºAutor  ³Danilo Azevedo      º Data ³  09/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para exclusao de produtos Atlas que nao foram movi-  º±±
±±º          ³mentadas.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Incorporacao Atlas                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function DELPROD()

Local cPath   	:= "\LogSiga\Produtos\"
Local cFile   	:= ""

RPCSetType(3)
Prepare Environment Empresa "00" Filial "1022" //EXECUTA NA EMPRESA 1022 GEN DEPOSITO SP

Private cAlias := GetNextAlias()
cQuery := "SELECT *
cQuery += " FROM "+RetSqlName("SB1")
cQuery += " WHERE B1_COD LIKE '042%'
cQuery += " AND B1_ISBN NOT IN (SELECT ISBN FROM ATLAS_BASE)
cQuery += " AND B1_ISBN NOT IN (SELECT ISBN FROM ATLAS_TABPRECO)
cQuery += " AND B1_COD NOT IN (SELECT DISTINCT D1_COD from "+RetSqlName("SD1")+" WHERE D_E_L_E_T_ = ' ')
cQuery += " AND D_E_L_E_T_ = ' '
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
dbSelectArea(cAlias)
dbGoTop()
Do While !(cAlias)->(Eof())
	
	aProduto := {}
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	nOpt := 5 //EXCLUI
	aAdd(aProduto, {"B1_COD", (cAlias)->B1_COD				, Nil})
	aAdd(aProduto, {"B1_DESC", (cAlias)->B1_DESC			, Nil})
	aAdd(aProduto, {"B1_TIPO", (cAlias)->B1_TIPO			, Nil})
	aAdd(aProduto, {"B1_UM", (cAlias)->B1_UM				, Nil})
	aAdd(aProduto, {"B1_LOCPAD", (cAlias)->B1_LOCPAD		, Nil})
	aAdd(aProduto, {"B1_GRUPO", (cAlias)->B1_GRUPO			, Nil})
	aAdd(aProduto, {"B1_ORIGEM", (cAlias)->B1_ORIGEM		, Nil})
	aAdd(aProduto, {"B1_TNATREC", (cAlias)->B1_TNATREC		, Nil})
	aAdd(aProduto, {"B1_ISBN", (cAlias)->B1_ISBN			, Nil})
	aAdd(aProduto, {"B1_POSIPI", (cAlias)->B1_POSIPI		, Nil})
	aAdd(aProduto, {"B1_CC", (cAlias)->B1_CC				, Nil})
	MSExecAuto({|x,y| Mata010(x,y)},aProduto,nOpt)
	
	If lMSErroAuto
		lErro := .T.
		cFile := Dtos(dDataBase) + " - Produto "+Alltrim((cAlias)->B1_COD)+".log"
		
		MostraErro(cpath,cfile)
		lMsErroAuto := .F.
		lMSHelpAuto	:= .F.
	Endif
	(cAlias)->(DbSkip())
	
Enddo

Reset Environment

Return()
