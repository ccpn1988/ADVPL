#include "PROTHEUS.ch"
#Include "TopConn.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA002   º Autor ³ Luiz Otavio Campos º Data ³  21/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ MBROWSE para permitir a aprovação do cancelamento de baixa.º±±
±±º          ³														      º±±
±±º          ³     														  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro - GEN                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENA002()

/*
cOrigem = "SX" - Solicitação de Cancelamento de Baixa
cOrigem = "AP" - Aprovação  de Cancelamento de Baixa
*/

Local cFiltra
Local aComb 	  := {}
Local aNumIt 	  := {}
Local oEdit1 	  := Nil
Local cValIt 	  := ""
Local aCores :={   	    { 'CR_STATUS== "01"', 'BR_AZUL' },;   //Bloqueado p/ sistema (aguardando outros niveis)
{ 'CR_STATUS== "02"', 'DISABLE' },;   //Aguardando Aprovação do usuario
{ 'CR_STATUS== "03"', 'ENABLE'  },;   //Cancelamento Liberado pelo usuario
{ 'CR_STATUS== "04"', 'BR_PRETO'},;   //Cancelamento Bloqueado pelo usuario
{ 'CR_STATUS== "05"', 'BR_CINZA'} }   //Cancelamento aprovate por outro usuario

Private oOk 	  := LoadBitmap( GetResources(), "LBOK"       )
Private oNo 	  := LoadBitmap( GetResources(), "LBNO"       )
Private cRed	  := LoadBitmap( GetResources(), "BR_VERMELHO")
Private cGreen    := LoadBitmap( GetResources(), "BR_VERDE" )
Private cBlue	  := LoadBitmap( GetResources(), "BR_AZUL" )
Private cLaranja  := LoadBitmap( GetResources(), "BR_LARANJA" )
Private cCinza	  := LoadBitmap( GetResources(), "BR_CINZA" )

Private aListBox1 := {}

Private cCadastro := "Aprovação do cancelamento de baixa a Pagar"
Private bFiltraBrw
Private aIndexSCR := {}
Private cDelFunc  := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString   := "SCR"
Private c_CodUser := ""
Private cNumTit	  := Space(TAMSX3("CR_NUM")[1])//space(20) //Anderson Serafim - 18/01/10
Private oNumSc
Private oListBox1
PRIVATE aRotina := {{OemToAnsi("Pesquisar"),'AxPesqui',   0 , 1},; //"Pesquisar"
{OemToAnsi("Consultar Titulo"),"U_fSE1Visualiza",  0 , 2},; //"Consulta Titulo
{OemToAnsi("Aprovar Canc Bx"),"U_FLibera",  0 , 4} }//"Aprovar"


Private a_Area := GetArea()
Private cPerg := "GENA002"
Private cChave := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o usuario possui direito de liberacao.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ca091User := RetCodUsr()

dbSelectArea("SAK")
dbSetOrder(2)
If !MsSeek(xFilial("SAK")+ca091User)
	Alert("O  acesso  e  a utilizacao desta rotina e destinada apenas aos usuarios envolvidos no processo de aprovacao da títulos de contas a pagar definido pelos grupos de aprovacao. Usuario sem permissao para utilizar esta rotina.Voltar!")
	Return
EndIf

/*
PutSx1(cPerg, "01", "Data Vencimento De: ",  "Data Vencimento De: ", 	 "Data Vencimento De: ", 	"mv_ch1" , "D", 08, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Data Vencimento Ate: ", "Data Vencimento Ate: ",  "Data Vencimento Ate: ", "mv_ch2" , "D", 08, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Data Inclusão De: ",    "Data Inclusão De: ",   "Data Inclusão De: ",  	"mv_ch3" , "D", 08, 0, 0, "G","", "", "", "", "MV_PAR03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Data Inclusão Ate: ",   "Data Inclusão Ate: ",  "Data Inclusão Ate: ", "mv_ch4" , "D", 08, 0, 0, "G","", "", "", "", "MV_PAR04","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "05", "Fornecedor De: ",       "Fornecedor De: ",      "Fornecedor De: ", 	"mv_ch5" , "C", 06, 0, 0, "G","", "SA2", "", "", "MV_PAR05","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "06", "Fornecedor Ate: ",      "Fornecedor Ate: ",     "Fornecedor Ate: ",    "mv_ch6" , "C", 06, 0, 0, "G","", "SA2", "", "", "MV_PAR06","","","","","","","","","","","","","","","","")

If !Pergunte(cPerg,.T.)
Return()
Endif

cVencDe    := mv_par01
cVencAte   := mv_par02
cIncDe     := mv_par03
cIncAte    := mv_par04
//cFornecDe  := mv_par05
//cFornecAte := mv_par06

*/

dbSelectArea("SCR")
dbSetOrder(1)
cFiltra  := " CR_FILIAL=='"+ xFilial("SCR")+"' .AND. CR_TIPO = 'BX' .And. CR_USER == '" + ca091User + "' .and. CR_STATUS=='02'
//cFiltra  += " .and. DTOS(CR_XDTVENC) >= '" + DToS(cVencDe) + "' .and.  DTOS(CR_XDTVENC)  <=  '" + DToS(cVencAte) + "' .And. DTOS(CR_EMISSAO) >= '" + DToS(cIncDe) + "
//cFiltra  += " .and. DTOS(CR_EMISSAO) <= '" + DToS(cIncAte) + "' .and. Substr(CR_NUM,20,6)  >= '" + cFornecDe + "' .and.  Substr(CR_NUM,20,6) <= '" + cFornecAte+"'"


bFiltraBrw := {|| FilBrowse("SCR",@aIndexSCR,@cFiltra) }

Eval(bFiltraBrw)


aCposBrw :=  { { "Baixas a Receber"           , {|| SCR->CR_NUM }}}

mBrowse( 6, 1,22,75,"SCR",aCposBrw,,,,,aCores)

EndFilBrw("SCR",aIndexSCR)

RestArea(a_Area)
Return

/*--------------------------------------------------------*
User Function fSE5Visualiza(cAlias,nRec,nOpcx)
*--------------------------------------------------------*
Local a_Area := GetArea()


dbSelectArea("SE2")
dbSetOrder(1)
If MsSeek(SCR->CR_NUM)
AxVisual("SE2",SE2->(Recno()),2)
EndIf


RestArea(a_Area)
Return
*-----------------------------------------------------------*
User Function  fSF1Visualiza(cAlias,nRec,nOpcx)
*-----------------------------------------------------------*
Local aArea := GetArea()

dbSelectArea("SE2")
dbSetOrder(1)
If MsSeek(SCR->CR_NUM)

DbSelectArea("SF1")
DbSetOrder(1)
If DbSeek(SE2->E2_FILIAL+ SE2->E2_NUM + SE2->E2_PREFIXO + SE2->E2_FORNECE + SE2->E2_LOJA)
A103NFiscal("SF1",SF1->(Recno()),2) //,lWhenGet,lEstNfClass)
Else
Aviso("Titulo não integrado","Esse título não é um título de integração do módulo de compras, portanto não possui documento de entrada associado.", {"Ok"})
Endif

Endif

RestArea(aArea)
Return
*/
*---------------------------------------------------------*
User Function fLibera(cAlias,nReg,nOpcx)
*---------------------------------------------------------*

Local aArea			:= GetArea()
Local aSizeAut		:= MsAdvSize(.F.,.F.)
//Local aCpos         := {"E2_PREFIXO","E2_NUM","E2_TIPO",C1_EMISSAO","C1_PRODUTO","C1_DESCRI","C1_OBS","C1_QUANT","C1_UM","C1_XOPER","C1_XVLESTI","C1_CC"}
local aObjects		:= {}
Local aInfo 		:= {}
Local aPosGet		:= {}
Local aPosObj		:= {}
Local nOpcA         := 0
Local oDlg
Local lRet
Local lContinua := .T.
Local oQual
Local aItens 	:= {}
Local aCposNew 	:= {}
Local aAreaSQS

Local aArea		:= GetArea()
Local aHeadCpos := {}
Local aHeadSize := {}
Local aArrayNF	:= {}
Local aCampos   := {}
Local aRetSaldo := {}
Local cObs 		:= CriaVar("CR_OBS")
Local ca091User := RetCodUsr()
Local cTipoLim  := ""
Local CRoeda    := ""
Local cAprov    := ""
Local cName     := ""
Local cSavColor := ""
Local cGrupo	:= ""
Local cCodLiber := SCR->CR_APROV
Local cDocto    := SCR->CR_NUM
Local cTipo     := SCR->CR_TIPO
Local dRefer 	:= dDataBase
Local cPCLib	:= ""
Local cPCUser	:= ""
Local c_NumSc   := ""
Local cTipoCR	:= "BX"


Local lLiberou	:= .F.
Local lLibOk    := .F.
Local lContinua := .T.

Local nSavOrd   := IndexOrd()
Local nSaldo    := 0
Local nOpc      := 0
Local nSalDif	:= 0
Local nTotal    := 0
Local nMoeda	:= 1
Local nX        := 1

Local oDataRef
Local oSaldo
Local oSalDif
Local oBtn1
Local oBtn2
Local oBtn3
Local oQual
Local oMemo1
Local n_opca    	:=	0
Local aPosObj   	:= {}
Local cFornecedor	:= ""
Private oDlg
Private mObs := " "
Private cQuery      := ""
Private oDlg
Private oLbx
Private oFont		:= TFont():New("Arial",,18,,.T.)
Private oFont2		:= TFont():New("Courier New",,18,,.T.)
Private oCodSol
Private oDescri
Private cMotivo
Private oMotivo
Private a_buttons 	:= {} 				//acrescenta os novos botoes na barra
Private aSize     	:= MsAdvSize()
Private aObjects  	:= {}
Private oDlgLIB := nil
Private cMailUser := ""


If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
	Alert("Esta movimentação já foi aprovada")
	lContinua := .F.
ElseIf SCR->CR_STATUS$"01"
	Alert("Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)")
	lContinua := .F.
EndIf

DbSelectArea("SE5")
DbSetOrder(7)
DbSeek(SCR->CR_NUM) //Posiciona no título



If lContinua
	
	dbSelectArea("SAL")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa as variaveis utilizadas no Display.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRetSaldo := MaSalAlc(cCodLiber,dRefer)
	nSaldo 	  := aRetSaldo[1]
	CRoeda 	  := A097Moeda(aRetSaldo[2])
	cName  	  := UsrRetName(ca091User)
	nTotal    := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
	cGrupo	  := SE5->E5_XGPAPRV //Grupo de Aprovação
	cCliente  := ""
	/// ------------------------------------------------------------------------------
	/// Busca o nome do fornecedor
	/// ------------------------------------------------------------------------------
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1") + SE5->E5_CLIFOR + SE5->E5_LOJA)
		cCliente := SA1->A1_NOME
	EndIf
	
	
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	
	DEFINE MSDIALOG oDlgLIB TITLE "Justificativa de Aprovação/Rejeição do Cancelamento de Baixa" From 109,95 To 440,630 OF oMainWnd PIXEL
	
	@ 010,10 SAY OemToAnsi("Prefixo:") Of oDlgLIB PIXEL SIZE 46,9 FONT oBold
	@ 010,40 SAY SE5->E5_PREFIXO Of oDlgLIB PIXEL SIZE 120,9 FONT oBold COLOR CLR_HBLUE
	
	@ 025,10 SAY OemToAnsi("Título:") Of oDlgLIB PIXEL SIZE 46,9 FONT oBold
	@ 025,40 SAY SE5->E5_NUMERO Of oDlgLIB PIXEL SIZE 120,9 FONT oBold COLOR CLR_HBLUE
	
	@ 040,10 SAY OemToAnsi("Parcela:") Of oDlgLIB PIXEL SIZE 46,9 FONT oBold
	@ 040,40 SAY SE5->E5_PARCELA Of oDlgLIB PIXEL SIZE 120,9 FONT oBold COLOR CLR_HBLUE
	
	@ 040,100 SAY OemToAnsi("Valor:") Of oDlgLIB PIXEL SIZE 52,9 FONT oBold
	@ 040,140 SAY Alltrim(Transform(SE5->E5_VALOR,PESQPICT("SE2","E2_VALOR")))  Of oDlgLIB PIXEL SIZE 120,9 FONT oBold COLOR CLR_HBLUE
	
	@ 055,10 SAY OemToAnsi("Tipo:") Of oDlgLIB PIXEL SIZE 46,9 FONT oBold
	@ 055,40 SAY SE5->E5_TIPO Of oDlgLIB PIXEL SIZE 120,9 FONT oBold COLOR CLR_HBLUE
	
	@ 010,100 SAY OemToAnsi("Fornecedor:") Of oDlgLIB PIXEL SIZE 52,9 FONT oBold
	@ 010,140 SAY OemToAnsi(SE5->E5_CLIFOR + "/" + SE5->E5_LOJA) Of oDlgLIB PIXEL SIZE 120,9 FONT oBold COLOR CLR_HBLUE
	@ 025,140 SAY OemToAnsi(cCliente) Of oDlgLIB PIXEL SIZE 120,9 FONT oBold COLOR CLR_HBLUE
	
	@ 070,010 Say	"Motivo"					Size 150,008 FONT oBold COLOR CLR_BLACK PIXEL OF oDlgLIB
	@ 080,010 Get	oMotivo VAR cMotivo Memo	Size 250,050 WHEN .T.	COLOR CLR_BLACK	PIXEL OF oDlgLIB
	
	@ 140,010 BUTTON "Título Aprovado" SIZE 60,15 FONT oDlgLIB:oFont ACTION (nOpc := 2,oDlgLIB:End()) PIXEL of oDlgLIB
	@ 140,080 BUTTON "Título Rejeitado" SIZE 60,15 FONT oDlgLIB:oFont ACTION (nOpc := 3,oDlgLIB:End()) PIXEL of oDlgLIB
	@ 140,150 BUTTON "Sair" SIZE 60,15 FONT oDlgLIB:oFont ACTION (nOpc := 1,oDlgLIB:End()) PIXEL of oDlgLIB
	
	ACTIVATE MSDIALOG oDlgLIB
	
	
	//		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg, {||(n_opca := 1 , oDlg:End())) },{|| n_opca := 2 },,a_buttons)
	
	
	SCR->(dbClearFilter())
	SCR->(dbGoTo(nReg))
	If nOpc == 2 .Or. nOpc == 3
		lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
		
		If lLiberou
			
			//Último nível de Aprovação, escolhe comprador.
			DbSelectArea("SE2")
			DbSetOrder(1)
			
			If SCR->CR_TIPO == "BX"
				
				*'----------------------------------------------------------------------------------'*
				*'Query para verificar se existe aprovadores do mesmo nivel, para liberar aprovacao.'*
				*'Ou seja, caso tenha mais de um aprovador do mesmo nivel, devera ser aprovado e    '*
				*'automaticamente chamado o proximo nivel                                           '*
				*'----------------------------------------------------------------------------------'*
				cQuery := ""
				cQuery := " SELECT CR_NUM ,CR_NIVEL,CR_STATUS,CR_APROV,CR_USER, CR_TIPO  "
				cQuery += " FROM "+RetSQLName("SCR")
				cQuery += " WHERE CR_NUM =  '"+SCR->CR_NUM+"' "
				cQuery += " AND   CR_TIPO     = '"+SCR->CR_TIPO+"' "
				cQuery += " AND   CR_STATUS   = '02' "
				cQuery += " AND   CR_NIVEL    = '"+SCR->CR_NIVEL+"' "
				cQuery += " AND   D_E_L_E_T_  = ' ' "
				
				TCQUERY cQuery NEW ALIAS "TRBSCR"
				
				If TRBSCR->(EOF())
					
					DbSelectArea("SE5")
					DbSetOrder(7)
					If DbSeek(SCR->CR_NUM)
						RecLock("SE5",.f.)
						SE5->E5_XCANCBX := "S"
						MsUnlock()
						
						PswOrder(1)
						PswSeek(SE5->E5_XSOLICT,.T.)
						aUser   := PswRet(1)
						cNomeUsu:= UsrFullName(__cuserId)
						cChave  := SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_SEQ
						
						If !Empty(aUser[1,14] )
							cMailUser := ALLTRIM(aUser[1,14])
						Endif
						
						U_AviLibBX("S",cNomeUsu,"Liberacação de Efetivação ","S")
						
					Endif
				EndIf
				
				
				DbSelectArea("TRBSCR")
				DbCloseArea()
			EndIf
		Else
			//*================================
			// Flaga as baixas rejetiadas
			//=================================
			DbSelectArea("SE5")
			DbSetOrder(7)
			If DbSeek(SCR->CR_NUM)
				RecLock("SE5",.f.)
				SE5->E5_XCANCBX := "B"
				MsUnlock()
				
				PswOrder(1)
				PswSeek(SE5->E5_XSOLICT,.T.)
				aUser   := PswRet(1)
				cNomeUsu:= UsrFullName(__cuserId)
				cChave  := SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_SEQ
				
				If !Empty(aUser[1,14] )
					cMailUser := ALLTRIM(aUser[1,14])
				Endif
				
				//Função de Aviso de Liberação
				U_AviLibBX("S",cNomeUsu,"Liberacação de Efetivação ","N")
			Endif
		EndIf
	Endif
Endif
dbSelectArea("SCR")
dbSetOrder(1)
SCR->(Eval(bFiltraBrw))

RestArea(aArea)

Return Nil
