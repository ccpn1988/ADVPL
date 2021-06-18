#include "PROTHEUS.ch"
#Include "TopConn.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA001 º Autor ³ Luiz Otavio Campos   º Data ³  21/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³MBROWSE para permitir a solicitação do Cancelamento de Baixaº±±
±±º          ³e a aprovação do cancelamento de baixa.				      º±±
±±º          ³				                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro - GEN                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENA001()

Local cFiltra
Local aComb 	  := {}
Local aNumIt 	  := {}
Local oEdit1 	  := Nil
Local cValIt 	  := ""
Local aCores :={{ 'E5_XCANCBX = "A"', 'BR_AZUL' },;   //Enviado para aprovação
{ 'E5_XCANCBX = "N" .Or. E5_XCANCBX = " "', 'ENABLE' },;   // Esperando aprovação
{ 'E5_XCANCBX = "S"', 'DISABLE'  },;   // Liberado pelo usuario
{ 'E5_XCANCBX = "B"', 'BR_PRETO'}}   //  Reprovado


Private aListBox1 := {}

Private cCadastro := "Solicitação de Cancelamento de baixa a RECEBER"
Private bFiltraBrw
Private aIndexSE5 := {}
Private cDelFunc  := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString   := "SE5"
Private c_CodUser := ""
Private oNumSc
Private oListBox1
Private a_Area := GetArea()
Private cPerg := "GENA001"
PRIVATE aRotina := {{OemToAnsi("Pesquisar"),'AxPesqui',   0 , 1},; //"Pesquisar"
{OemToAnsi("Consultar Titulo"),"U_fSE1Visualiza",  0 , 2},; //"Consulta Titulo
{OemToAnsi("Enviar Solict Canc Bx"),"U_fEnvAprov('BX')",  0 , 4},; //"Enviar Solicitaçõ
{OemToAnsi("Consulta Aprov") ,"U_fTelaAprov",0,2},;
{OemToAnsi("Legenda") ,"U_GENA01LEG",0,2}}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o usuario possui direito de liberacao.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


PutSx1(cPerg, "01", "Data De:  ",  "Data De:" ,"Data  De: ",  "mv_ch1" , "D", 08, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Data Ate: ", "Data  Ate:","Data  Ate: ", "mv_ch2" , "D", 08, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")


If !Pergunte(cPerg,.T.)
	Return()
Endif

dbSelectArea("SE5")
dbSetOrder(1)
cFiltra  := " E5_FILIAL=='" + xFilial("SE5") + "' .and. (E5_RECPAG = 'R') .And. E5_DATA >= CTOD('"+DTOC(MV_PAR01)+"') .and. E5_DATA <= CTOD('"+DTOC(MV_PAR02)+"') "
cFiltra  += " .And. E5_TIPODOC $ ('VL|BA') "

bFiltraBrw := {|| FilBrowse("SE5",@aIndexSE5,@cFiltra) }

Eval(bFiltraBrw)

//aCposBrw :=  { { "Titulos a Pagar"           , {|| SCR->CR_NUM }}}
//mBrowse( 6, 1,22,75,"SE5",aCposBrw,,,,,aCores)
mBrowse( 6, 1,22,75,"SE5",,,,,,aCores)

EndFilBrw("SE5",aIndexSE5)

RestArea(a_Area)

Return()

*--------------------------------------------------------*
User Function fSE1Visualiza(cAlias,nRec,nOpcx)
*--------------------------------------------------------*
Local a_Area := SE5->(GetArea())


dbSelectArea("SE1")
dbSetOrder(1)
If Dbseek(XFILIAL("SE1")+SE5->E5_DOCUMEN)
	AxVisual("SE1",SE1->(Recno()),2)
EndIf

RestArea(a_Area)

Return()


*------------------------------------------------------------------------*
User Function GENA01LEG
*------------------------------------------------------------------------*
* Legenda da função
*------------------------------------------------------------------------*
Local aCores:= {}

AAdd ( aCores  , { "BR_VERMELHO" , "Solicitação aprovada"} )
AAdd ( aCores  , { "BR_AZUL"     , "Em aprovação"} )
AAdd ( aCores  , { "BR_VERDE"    , "Aguardando aprovação"    } )
AAdd ( aCores  , { "BR_PRETO"    , "Reprovado"   } )

BrwLegenda("Cancelamento de Baixa","Legenda",aCores)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fEnvAprov ºAutor  ³Luiz Otavio Campos  º Data ³  05/16/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para envio da solicitação de aprovação do cancelamen-º±±
±±º          ³to de baixa do contas a pagar.                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function fEnvAprov(cTipo)

Local nOpca  	  := 0
Local cMsg 		  :=""
Private cGrpAprov := Space(TamSx3("AL_COD")[1])
Private	cChave	  := ""

If (SE5->E5_XCANCBX = "S")
	Alert("Não é possível enviar a solicitação do cancelamento de baixa, pois o cancelamento da movimentação já foi aprovado anteriormente")
Else
	
	DEFINE MSDIALOG oDlg TITLE "Grupo de aprovacao" FROM 000,000 TO 080,300 PIXEL
	
	@ 001,001 TO 040,150 OF oDlg PIXEL
	@ 010,010 SAY "Gr. Aprovacao" SIZE 55,07 OF oDlg PIXEL
	@ 010,050 MSGET cGrpAprov F3 "SAL" SIZE 55,11 OF oDlg PIXEL PICTURE "@!" VALID !Vazio()
	
	DEFINE SBUTTON FROM 010, 120 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 020, 120 TYPE 2 ACTION (nOpca := 2,oDlg:End()) ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpca = 1
		
		cChave  := SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_SEQ
		nValor  := SE5->E5_VALOR
		
		//***********************************************************************/
		//Cria regisro de tabela
		//***********************************************************************/
		MaAlcDoc({cChave,cTipo,nValor,,,cGrpAprov,,,,," "},dDataBase,1)
		
		//***********************************************************************/
		//Envia e-mail para apovadores
		//***********************************************************************/
		U_fEnv2Mail(cChave,cTipo)//envia email para p grupo d aprovação
		
		DbSelectArea("SE5")
		Reclock("SE5",.F.)
		SE5->E5_XCANCBX:= "A"
		SE5->E5_XGPAPRV := cGrpAprov
		MsUnlock()
		
	EndIf
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fEnvMail  ºAutor  ³Luiz Otavio Campos  º Data ³  01/14/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de envio de e-mail dos titutulos para aprovacao.   º±±
±±º          ³                                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cChave --> Chave do Titulo no SCR	                     º±±
±±º          ³                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fEnvMail (cChave,cTpDoc)

Local aUser := {}
Local cMailUser := ""
Local lMailFin:= .F. //Identifica se Email do FInanceiro

DbSelectArea("SCR")
DBGotop()
DbSetOrder(1)
If DbSeek(xFilial("SCR")+cTpDoc+cChave)
	While !Eof() .And. SCR->CR_FILIAL = xFIlial("SCR") .And. SCR->CR_NUM = cChave .And. SCR->CR_TIPO = cTpDoc
		PswOrder(1)
		PswSeek(SCR->CR_USER,.T.)
		aUser := PswRet(1)
		
		If !Empty(aUser[1,14] )
			cMailUser := ALLTRIM(aUser[1,14])
		Endif
		
		Op:=TWFProcess():New("apvped", "Cancelamento de Baixa a Receber")
		Op:NewTask("apvped", "/html/avisopg.html")
		
		Op:cSubject := "Cancelamento de Baixa a Receber"
		Op:cTo		:= cMailUser
		Op:cTo		:= cMailUser
		Op:cCC		:= ""
		Op:cBCC     := ""
		oP:bReturn 	:= ""
		
		AAdd(oP:oHtml:ValByName("t2.1"),SE5->E5_FILIAL)
		AAdd(oP:oHtml:ValByName("t2.2"),SE5->E5_PREFIXO)
		AAdd(oP:oHtml:ValByName("t2.3"),SE5->E5_NUM)
		AAdd(oP:oHtml:ValByName("t2.4"),SE5->E5_PARCELA)
		AAdd(oP:oHtml:ValByName("t2.5"),SE5->E5_TIPO)
		AAdd(oP:oHtml:ValByName("t2.6"),SE5->E5_FORNECE + "-" + upper(POSICIONE("SA2",1,XFILIAL("SA2")+SE5->E5_FORNECE+SE5->E5_LOJA,"A2_NOME")))
		AAdd(oP:oHtml:ValByName("t2.7"),SE5->E5_LOJA)
		AAdd(oP:oHtml:ValByName("t2.8"),transform(SE5->E5_VALOR, "@E 999,999,999.99"))
		oP:Start()
		oP:Finish()
		
		lMailFin:=.T.
		
		DbSelectArea("SCR")
		DbSkip()
	EndDo
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ fTelaAprovºAutor ³ Luiz Otavio Campos º Data ³  12/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria uma tela de consulta do status da solicitacao de 	 º±±
±±º          ³   Parametros : ExpC1 = Alias do arquivo ,                 º±±
±±º			 ³	ExpN1 = Numero do registro								 º±±
±±º          ³  ExpN2 = Opcao selecionada                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-----------------------------------------------------------------------------------------------*
User Function fTelaAprov(cAlias,nReg,nOpcx)
* Cria uma tela de consulta do status da solicitacao de compras
* Parametros : ExpC1 = Alias do arquivo , ExpN1 = Numero do registro,ExpN2 = Opcao selecionada
*-----------------------------------------------------------------------------------------------*

Local bCampo
Local oDlg
Local oGet
Local nAcols := 0
Local nOpca := 0
Local cCampos
Local cSituaca := ""
Local lBloq := .F.
Local cPedido
Local cComprador
Local cStatus
Local cTipoSC1 := ""
Local oBold
Local nCntFor := 0
Local cFornecedor := ""
Local nFornecedor := 0
Local cTipo := ""

///

dbSelectArea("SE5")
dbGoto(nReg)

Private cCR_NUM	:= SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_SEQ

//SE5->E5_XCANCBX:= "A"
//	SE5->E5_XGPAPRV := cGrpAprov

If SE5->E5_XCANCBX == "B"
	cStatus := OemToAnsi("Título bloqueado")
elseif SE5->E5_XCANCBX == "N"
	cStatus := OemToAnsi("Título não liberado")
elseIf SE5->E5_XCANCBX = "S"
	cStatus := OemToAnsi("Título liberado")
endif

aCols := {}
aHeader := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aTELA[0][0],aGETS[0],Continua,nUsado:=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a montagem do aHeader com os campos fixos.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCampos := "CR_NIVEL/CR_OBS"


/// ------------------------------------------------------------------------------
/// Busca o nome do fornecedor
/// ------------------------------------------------------------------------------

dbSelectArea("SA1")
dbSetOrder(1)

if dbSeek(xFilial("SA1") + SE5->E5_CLIFOR + SE5->E5_LOJA)
	cFornecedor := SA1->A1_NOME
end if

/// ------------------------------------------------------------------------------

/*
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SCR")                      
*/

xLoop	:= 0
aCampos := FWSX3Util():GetAllFields( "SCR", .F. )

While !EOF()    
	For xLoop := 1 To Len(aCampos)
		IF AllTrim(aCampos[xLoop])$cCampos
			nUsado++
	//		AADD(aHeader		,	{ TRIM(x3titulo()), x3_campo, x3_picture, x3_tamanho, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Aadd(aHeader,   {Posicione("SX3",2,aCampos[xLoop],"X3_TITULO"),aCampos[xLoop],Posicione("SX3",2,aCampos[xLoop],"X3_PICTURE"),TamSx3(aCampos[xLoop])[1],TamSx3(aCampos[xLoop])[2],Posicione("SX3",2,aCampos[xLoop],"X3_VALID"),Posicione("SX3",2,aCampos[xLoop],"X3_USADO"),FWSX3Util():GetFieldType(aCampos[xLoop]),Posicione("SX3",2,aCampos[xLoop],"X3_ARQUIVO"),Posicione("SX3",2,aCampos[xLoop],"X3_CONTEXT")})			
			If AllTrim(aCampos[xLoop]) == "CR_NIVEL"
				AADD(aHeader,{ OemToAnsi("Tipo"),"bCR_TIPO", "@", 2, 0, "","","C","",""} )    		//"Tipo"
				nUsado++
				AADD(aHeader,{ OemToAnsi("Usuario"),"bCR_NOME", "@", 15, 0, "","","C","",""} )    		//"Usuario"
				nUsado++
				AADD(aHeader,{ OemToAnsi("Situacao"),"bCR_SITUACA", "@", 20, 0, "","","C","",""} )    	//"Situacao"
				nUsado++
				AADD(aHeader,{ OemToAnsi("Usuario Lib."),"bCR_NOMELIB", "@", 15, 0, "","","C","",""} )	//"Usuario Lib."
				nUsado++
				AADD(aHeader,{ OemToAnsi("Dt.Lib"),"bCR_DATALIB", "@", 8, 0, "","","D","",""} )    		//"Tipo"
				nUsado++
			EndIf
		Endif                     
		Next xLoop
	dbSkip()
End

/*******************************************************************/
//Quey para buscar os dados da alçada de aprovação
/*******************************************************************/
cQuery:= " SELECT * FROM "+RetSqlName("SCR")+" SCR "
cQuery+= " WHERE SCR.D_E_L_E_T_ = ' '"
cQuery+= " AND SCR.CR_NUM = '"+cCR_NUM+"'"
cQuery+= " AND CR_TIPO IN ('BX')"
cQuery+= " ORDER BY CR_TIPO DESC "

TcQuery cQuery new Alias "TMPSCR"

dbSelectArea("TMPSCR")
DbGotop()

cFilCR := TMPSCR->CR_FILIAL

While !TMPSCR->(Eof()) .And. TMPSCR->CR_FILIAL + Substr(TMPSCR->CR_NUM, 1, len(cCR_NUM)) = cFilCR +  cCR_NUM
	aadd(aCols,Array(nUsado+1))
	nAcols ++
	For nCntFor := 1 To nUsado
		If aHeader[nCntFor][02] == "bCR_NOME"
			aCols[nAcols][nCntFor] := UsrRetName(TMPSCR->CR_USER)
		ElseIf aHeader[nCntFor][02] == "bCR_TIPO"
			aCols[nAcols][nCntFor] := TMPSCR->CR_TIPO
		ElseIf aHeader[nCntFor][02] = "bCR_DATALIB"
			aCols[nAcols][nCntFor] := Stod(TMPSCR->CR_DATALIB)
		ElseIf aHeader[nCntFor][02] == "bCR_SITUACA"
			Do Case
				Case TMPSCR->CR_STATUS == "01"
					cSituaca := OemToAnsi("Aguardando") //"Aguardando"
				Case TMPSCR->CR_STATUS == "02"
					cSituaca := OemToAnsi("Em Aprovacao") //"Em Aprovacao"
				Case TMPSCR->CR_STATUS == "03"
					cSituaca := OemToAnsi("Aprovado")  //"Aprovado"
				Case TMPSCR->CR_STATUS == "04"
					cSituaca := OemToAnsi("Rejeitado") //"Bloqueado"
					lBloq := .T.
				Case TMPSCR->CR_STATUS == "05"
					cSituaca := OemToAnsi("Nivel Liberado ") // "Nivel Liberado "
			EndCase
			aCols[nAcols][nCntFor] := cSituaca
		ElseIf aHeader[nCntFor][02] == "bCR_NOMELIB"
			aCols[nAcols][nCntFor] := UsrRetName(TMPSCR->CR_USERLIB)
		ElseIf ( aHeader[nCntFor][10] != "V")
			aCols[nAcols][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
		EndIf
	Next nCntFor
	aCols[nAcols][nUsado+1] := .F.
	
	dbSelectArea("TMPSCR")
	dbSkip()
EndDo


If Empty(aCols)
	Aviso("Atencao","Este título nao possui controle de aprovacao.",{"Voltar"})
	dbSelectArea("TMPSCR")
	dbCloseArea()
	dbSelectArea(cAlias)
	Return nOpca
EndIf

Continua := .F.
nOpca := 0

DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

DEFINE MSDIALOG oDlg TITLE "Aprovação de Títulos" From 109,95 To 400,600 OF oMainWnd PIXEL

@ 4,10 SAY OemToAnsi("Prefixo:") Of oDlg PIXEL SIZE 46,9 FONT oBold
@ 4,40 SAY SE2->E2_PREFIXO Of oDlg PIXEL SIZE 120,9 FONT oBold COLOR CLR_HBLUE

@ 14,10 SAY OemToAnsi("Título:") Of oDlg PIXEL SIZE 46,9 FONT oBold
@ 14,40 SAY SE2->E2_NUM Of oDlg PIXEL SIZE 120,9 FONT oBold COLOR CLR_HBLUE

@ 24,10 SAY OemToAnsi("Parcela:") Of oDlg PIXEL SIZE 46,9 FONT oBold
@ 24,40 SAY SE2->E2_PARCELA Of oDlg PIXEL SIZE 120,9 FONT oBold COLOR CLR_HBLUE

@ 34,10 SAY OemToAnsi("Tipo:") Of oDlg PIXEL SIZE 46,9 FONT oBold
@ 34,40 SAY SE2->E2_TIPO Of oDlg PIXEL SIZE 120,9 FONT oBold COLOR CLR_HBLUE

@ 4,100 SAY OemToAnsi("Fornecedor:") Of oDlg PIXEL SIZE 52,9 FONT oBold
@ 4,140 SAY OemToAnsi(SE2->E2_FORNECE + "/" + SE2->E2_LOJA) Of oDlg PIXEL SIZE 120,9 FONT oBold COLOR CLR_HBLUE
@ 14,140 SAY OemToAnsi(cFornecedor) Of oDlg PIXEL SIZE 120,9 FONT oBold COLOR CLR_HBLUE

@ 132,8 SAY OemToAnsi("Situacao :") Of oDlg PIXEL SIZE 52,9
@ 132,38 SAY cStatus Of oDlg PIXEL SIZE 120,9 FONT oBold COLOR CLR_HRED

@ 132,205 BUTTON 'Fechar' SIZE 35 ,10  FONT oDlg:oFont ACTION (oDlg:End()) Of oDlg PIXEL
oGet := MSGetDados():New(50, 3, 120, 250,nOpcx,,,"")
@ 126,2 TO 127,250 LABEL '' OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

aCols := {}
aHeader := {}

dbSelectArea("TMPSCR")
dbCloseArea()

dbSelectArea(cAlias)

Return nOpca


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³WfEfe     ºAutor  ³Rafael Lima         º Data ³  10/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para montar os HTML's a serem enviados para os      º±±
±±º          ³ aprovadores                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fEnv2Mail

Local aMails	:= {}
Local cWFBRWSR	:= AllTrim(GetMv('MV_WFBRWSR'))

ConOut('============********* INICIO DE ENVIO DE E-MAIL CANCELAMENTO DE BAIXA *********==============')

aMails := u_AprovBX(cChave)

If len(aMails) = 0
	Aviso("A T E N Ç Ã O","Não foi montada nenhuma grade de aprovação para esse título. Contate ao Administrador", {"Ok"})
	Return
Endif

For i:=1 to len(aMails)
	cAssunto := "Aprovação de Cancelamento de Baixa a Receber"
	cTitHtm  := "Aprovação de Cancelamento de Baixa a Receber"
	
	//Gravar Pasta
	cCodPasta	:= "efebxr"
	Op:=Twfprocess():New("efebxr","Aprovacao de Cancelamento de Baixa")
	Op:NewTask("efebxr","/html/aprovcanc.htm") //Nome do HTML para montagem dos dados
	Op:oHtml:Valbyname("APROVADOR"  , amails[i,4])
	oP:oHtml:ValByName( "CHAVE", cChave)
	oP:oHtml:ValByName( "CFILANT", cFilAnt)
	oP:oHtml:ValByName( "CMAILUSER", amails[i,2])
	//oP:oHtml:ValByName( "RECNO", SE2->(Recno()))
	
	Montaemail()
	Op:cSubject := cAssunto
	Op:cTo := cCodPasta
	oP:bReturn := "U_LibBX()"
	cMailID := oP:Start()
	
	
	//Mandar Link
	cIdProc	:="emp"+cEmpAnt+"/efebxr/"+cMailID
	oP:= TWFProcess():New("efebxr","Aprovacao de Cancelaemnto de Baixa")
	oP:NewTask("efebxr","/html/linkcanc.htm") //Nome do HTML para envio do LINK
	Op:cSubject := cAssunto
	Op:cTo := aMails[i,2]
	
	cUsrNamec := UsrRetName(amails[i,1])
	
	Op:ohtml:ValByName("usuario",cUsrNamec)
	Op:ohtml:ValByName("proc_link","http://"+cWFBRWSR+"/messenger/emp"+cEmpAnt+"/efebxr/" + cMailID + ".htm")
	Op:ohtml:ValByName("link","http://"+cWFBRWSR+"/messenger/emp"+cEmpAnt+"/efebxr/" + cMailID + ".htm")
	Op:ohtml:ValByName("titulo","http://"+cWFBRWSR+"/messenger/emp"+cEmpAnt+"/efebxr/" + cMailID + ".htm")
	oP:Start()
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Montaemail ºAutor ³Rafael Lima         º Data ³  10/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para montar os dados do titulo de acordo com o layout±±
±±º          ³ do HTML                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Montaemail()

Local nX:= 0
//Dados do usuário
Op:oHtml:Valbyname("solicitante"	,UsrFullName(__cuserId))
Op:oHtml:Valbyname("emissao"   		,dDatabase)


AAdd((op:oHtml:ValByName( "t1.1"    )), SE5->E5_DATA)   //Data Mov
AAdd((op:oHtml:ValByName( "t1.2"    )), SE5->E5_CLIFOR +" "+SE5->E5_LOJA +" - "+ POSICIONE("SA1",1,xFilial("SA1")+SE5->E5_CLIFOR +SE5->E5_LOJA,"A1_NOME")    ) //Cliente
AAdd((op:oHtml:ValByName( "t1.3"    )), SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO) //Titulo
AAdd((op:oHtml:ValByName( "t1.4"    )), Transform(SE5->E5_VALOR, "@E 999,999,999.99")) // Valor


//Processo de aprovacao
DBSelectarea("SCR")
DBSetOrder(1)
If DbSeek(xFilial("SCR")+"BX"+cChave)
	Do While SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM = xFilial("SCR")+"BX"+cChave  .and. !Eof()
		
		cSituaca := ""
		Do Case
			Case SCR->CR_STATUS == "01"
				cSituaca := "Aguardando"
			Case SCR->CR_STATUS == "02"
				cSituaca := "Em Aprovacao"
			Case SCR->CR_STATUS == "03"
				cSituaca := "Aprovado"
			Case SCR->CR_STATUS == "04"
				cSituaca := "Reprovado"
				lBloq := .T.
			Case SCR->CR_STATUS == "05"
				cSituaca := "Nivel Liberado"
		EndCase
		
		_cT4 := Upper(UsrRetName(SCR->CR_USERLIB))
		_cT6 := SCR->CR_OBS
		
		//aUser := FWSFAllUsers()
		cUsrNamec	:= UsrRetName(SCR->CR_USER)

		AAdd( (op:oHtml:ValByName( "t2.1"    )), SCR->CR_NIVEL)
		AAdd( (op:oHtml:ValByName( "t2.2"    )), Upper(cUsrNamec))
		AAdd( (op:oHtml:ValByName( "t2.3"    )), cSituaca    )
		AAdd( (op:oHtml:ValByName( "t2.4"    )), IIF(EMPTY(_cT4),"", _cT4))
		AAdd( (op:oHtml:ValByName( "t2.5"    )), DTOC(SCR->CR_DATALIB))
		AAdd( (op:oHtml:ValByName( "t2.6"    )), IIF(EMPTY(_cT6),"", _cT6))
		
		dbSelectArea("SCR")
		SCR->(dbSkip())
	EndDo
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AprovEfe  ºAutor  ³Rafael Lima         º Data ³  10/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para listar os aprovadores que foram selecionados   º±±
±±º          ³ para o cancelamento de baixa.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function AprovBX(cChave)

Local aMails 	:= {}
Local cQuery	:= ""
Local ArqSCR	:= GetNextAlias()

cQuery := " SELECT CR_FILIAL, CR_TIPO, CR_USER ,CR_NUM, CR_APROV,R_E_C_N_O_ FROM "+RetSqlName("SCR")+" (NOLOCK) "
cQuery += " WHERE D_E_L_E_T_ = ' ' "
cQuery += " AND CR_FILIAL = "+ValToSql(xFilial("SCR"))
cQuery += " AND CR_STATUS = '02' "
cQuery += " AND CR_WF = ' ' "
cQuery += " AND CR_TIPO = 'BX' "
cQuery += " AND CR_NUM = "+ValToSql(cChave)

If Select(ArqSCR) > 0
	dbSelectArea(ArqSCR)
	dbCloseArea()
EndIf

cQuery := CHANGEQUERY(cQuery)
dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery), ArqSCR ,.T.,.T.)


DbSelectArea(ArqSCR)
(ArqSCR)->(dbGoTop())

Do While !(ArqSCR)->(Eof())
	
	PswOrder(1)
	PswSeek((ArqSCR)->CR_USER,.T.)
	aUser := PswRet(1)
	If aUser[1,14] <> ""
		AADD(amails,{(ArqSCR)->CR_USER,aUser[1,14],(ArqSCR)->R_E_C_N_O_,(ArqSCR)->CR_APROV})
	Endif
	(ArqSCR)->(DbSkip())
EndDo

Return(aMails)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LibEfe     ºAutor ³Rafael Lima         º Data ³  20/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para executar o retorno do e-mail                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LibBX(oP)

Local aArea			:= GetArea()
Local cCodFil   	:= AllTrim(oP:oHtml:RetByName('CFILANT'))
Local cCodApr   	:= AllTrim(oP:oHtml:RetByName('APROVADOR'))
Local cResp    		:= If(Upper(oP:oHtml:RetByName('OPC'))="S","S","N")
Local cGrupo
Local cObs      	:= alltrim(oP:oHtml:RetByName("OBS"))
Local cRecno		:= oP:oHtml:RetByName('RECNO')
Local cQryAtu		:= ""
//Local aAreaCT2		:= {}
Local nTotal		:= 0
Private cMailUser	:= AllTrim(oP:oHtml:RetByName('cMailUser'))
Private aVetLct		:= {}
Private cChave	   	:= AllTrim(oP:oHtml:RetByName('CHAVE'))
Private cAssunto	:= "Efetivação de Lançamento "+cChave

ConOut('====== *** Executando Retorno de aprovação de cancelamento *** ============')
ConOut('Chave: ' +cCodFil+cChave)
Conout('Variavel cResp Inicio'+cResp)

cCodUsr 	:= Posicione("SAK",1,xFilial("SAK")+cCodApr,"AK_USER")
cNomeUsu	:= UsrFullName(cCodUsr)

//Posicionar movimentação contabil
DbSelectArea("SE5")
DbSetOrder(7)
If DbSeek(cChave)
	
	cGrupo 	:= SE5->E5_XGPAPRV
	aArea	:= SE5->(GetArea())
	Conout('Entrei no DbSeek do SE5')
	
	Conout('Codigo do usuario '+cCodUsr+'-----'+cNomeUsu)
	//Processar liberacao
	aTam := TamSX3("CR_NUM")
	DbSelectArea("SCR")
	DbSetOrder(2)
	If DbSeek(xFilial("SCR")+'BX'+cChave+Space(aTam[1]-Len(cChave))+cCodUsr)
		
		
		Conout("Entrou no SCR")
		nTotal 	:= SCR->CR_TOTAL
		
		Conout('Variavel cResp '+cResp)
		If cResp = 'S'
			lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodApr,,cGrupo,,,,,cObs},dDataBase,If(cResp=='S',4,6))
			Conout(lLiberou)
			Conout('SCR->CR_NUM '+SCR->CR_NUM)
			Conout('SCR->CR_TIPO '+SCR->CR_TIPO)
			Conout(nTotal)
			Conout('cCodApr '+cCodApr)
			Conout('cGrupo '+cGrupo)
			CONOUT("LIBEROU")
		Else
			lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodApr,,cGrupo,,,,,cObs},dDataBase,If(cResp=='S',4,6))
			Conout(lLiberou)
			Conout('SCR->CR_NUM '+SCR->CR_NUM)
			Conout('SCR->CR_TIPO '+SCR->CR_TIPO)
			Conout(nTotal)
			Conout('cCodApr '+cCodApr)
			Conout('cGrupo '+cGrupo)
			CONOUT("BLOQUEOU")
		EndIf
		
		If lLiberou
			
			Conout('Registro Liberado')
			Conout('Tipo de Liberacao: '+SCR->CR_TIPO)
			
			If SCR->CR_TIPO == "BX"
				
				Conout('Atualiza a movimentacao  campo E5_XCANCBX')
				Conout('SCR->CR_NUM '+SCR->CR_NUM)
				
				dbSelectArea("SE5")
				dbSetOrder(7)
				If DbSeek(cChave)
					
					RecLock("SE5",.F.)
					SE5->E5_XCANCBX := 'S'
					MsUnlock()
					
					Conout(cQryAtu)
					cQryAtu := TcSqlExec(cQryAtu)
					
					Conout('Atualizei e vou enviar aviso de liberacao')
					
					PswOrder(1)
					PswSeek(SE5->E5_XSOLICT,.T.)
					aUser   := PswRet(1)
					cNomeUsu:= UsrFullName(__cuserId)
					
					If !Empty(aUser[1,14] )
						cMailUser := ALLTRIM(aUser[1,14])
					Endif
					
					//Função de Aviso de Liberação
					U_AviLibBX("S",cNomeUsu,"Liberacação de Efetivação ","S")
				Else
					Conout('Nao consegui entrar no IF para atualizar: '+SCR->CR_NUM)
				EndIf
			EndIf
			
			
		ElseIf !lLiberou .and. cResp = "S"
			
			
			Conout('Registro Liberado para outros niveis')
			
			c_Recno := SCR->(Recno()) //Gravar Recno Atual
			c_NvOrg	:= SCR->CR_NIVEL
			
			DbSelectArea("SCR")
			DbSetOrder(1)
			DbSeek(xFilial("SCR")+'BX'+cChave)
			While !Eof() .And. (xFilial("SCR")+'BX'+cChave = AllTrim(SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM))
				Conout('Nível c_NvOrg '+c_NvOrg)
				Conout('Nível SCR->CR_NIVEL '+SCR->CR_NIVEL)
				If Empty(SCR->CR_DATALIB).and. c_NvOrg <> SCR->CR_NIVEL
					
					c_Nivel := ""
					Do Case
						Case SCR->CR_NIVEL == "01"
							c_Nivel := "C"
						Case SCR->CR_NIVEL == "02"
							c_Nivel := "A"
						Case SCR->CR_NIVEL == "03"
							c_Nivel := "F"
						Case SCR->CR_NIVEL == "04"
							c_Nivel := "S"
					EndCase
					
					// Envio novamente para aprovação
					SE5->(dbSeek(cChave))
					
					conout(":-) Chamara novamente a fc de Envio WF....")
					
					U_fEnv2Mail()
					lContinua := .T.
					Exit
				EndIf
				DbSelectArea("SCR")
				DbSkip()
			End
			
			//Reposiciona SCR
			DbSelectArea("SCR")
			DbGoTo(c_Recno)
			
			// Envio novamente para aprovação
			SE5->(dbSeek(cChave))
			
		Else // REJEITOU
			
			Conout('Registro Rejeitado')
			
			If SCR->CR_TIPO == "BX"
				dbSelectArea("SE5")
				dbSetOrder(7)
				If DbSeek(cChave)
					
					Reclock("SE5",.F.)
					SE5->E5_XCANCBX := 'B'
					MsUnlock()
					
					Conout('Atualizei e vou enviar aviso de liberacao')
					
					PswOrder(1)
					PswSeek(SE5->E5_XSOLICT,.T.)
					aUser   := PswRet(1)
					cNomeUsu:= UsrFullName(__cuserId)
					
					If !Empty(aUser[1,14] )
						cMailUser := ALLTRIM(aUser[1,14])
					Endif
					
					//Função de Aviso de Liberação
					U_AviLibBX("S",cNomeUsu,"Liberacação de Efetivação ","N")
				Else
					Conout('Nao consegui entrar no IF para atualizar: '+SCR->CR_NUM)
				EndIf
				
				
			EndIf
			
		EndIf
	Else
		Conout("Aprovadores do cancelamento " + cChave + " nao encontrado")
	EndIf
	
	ConOut('Termino da Execucao do Retorno')
Else
	ConOut('Nao deu o Seek')
Endif
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AvisoLib   ºAutor ³Rafael Lima         º Data ³  20/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para envio do aviso de liberacao.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AviLibBX(cAprov,cNomeUsu,cAssunto,cResp)

Local lRet         := .F.
Local aDados 	   := {}

ConOut("Entrou na funcao de aviso!!!")

cSubject := "Cancelamento de Baixa : " + cChave + Iif(cResp == "S"," está liberado"," nao foi liberado")
cTitHtm  := "Cancelamento de Baixa : " + cChave + Iif(cResp == "S"," está liberado"," nao foi liberado")

Conout(cSubject)

Op:=Twfprocess():New("efebxr","Aviso de Liberacao do Cancelamento de Baixa")

Op:NewTask("efebxr","/html/avisocanc.htm")
Op:cSubject := cSubject

Op:oHtml:Valbyname("aprovado"  , IIf(cResp == "S","Liberado","Nao Liberado"))
Op:oHtml:Valbyname("M0_NOME"  , SM0->M0_NOMECOM)
Montaemail()

oP:bReturn  := ""
oP:cTo:= cMailUser
oP:Start()
op:Finish()

Return
