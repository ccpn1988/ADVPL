#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M020INC   º Autor ³ Helimar Tavares    º Data ³  10/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada após inclusão de fornecddor               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Cadastro de fornecedor                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M020INC()

Local aArea	:= GetArea()

//Inclusão de classe de valor
fClasseGen()

Restarea(aArea)

Return

static Function fClasseGen()

Local lErro   := .F.
Local cPath   := "\LogSiga\classe\"
Local cFile   := ""
Local nOpt    := 3

Private nTamCLVL := TAMSX3("CTH_CLVL")[1]
Private nTamDESC := TAMSX3("CTH_DESC01")[1]
Private lMSErroAuto := .F. // inicializa como falso, se voltar verdadeiro e'que deu erro

cCodCL  := PADR(ALLTRIM(SUBSTR("F" + SA2->A2_COD,1,nTamCLVL)),nTamCLVL)
cDesc   := ALLTRIM(UPPER(SUBSTR(SA2->A2_NOME,1,nTamDESC)))

aRotAuto := {}
aAdd(aRotAuto,{"CTH_CLVL"	, cCodCL,Nil})
aAdd(aRotAuto,{"CTH_CLASSE"	, "2"	,Nil})
aAdd(aRotAuto,{"CTH_DESC01"	, cDesc	,Nil})

DbSelectArea("CTH")
CTH->(DbSetOrder(1))
If CTH->(!DbSeek(xFilial("CTH")+cCodCL))
	MSExecAuto({|x, y| CTBA060(x, y)},aRotAuto, nOpt)
	
	If lMSErroAuto //deu erro (retorno de msexecauto)
		lErro := .T.
		cFile := "Cod_"+Alltrim(cCodCL)+".log"
		
		MostraErro(cpath, cfile)
		DisarmTransaction()
		lMsErroAuto := .F.
	EndIf
Endif      

Return