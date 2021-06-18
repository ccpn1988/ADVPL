#include "rwmake.ch"
#include "tbicode.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "ap5mail.ch"
#DEFINE   c_ent      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA003   ºAutor  ³Florence França     º Data ³  29/11/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para aprovacao DE lançamento contábil via workflow  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA003


Local cFiltra
Local aComb 	  	:= {}
Local aNumIt 	  	:= {}
Local oEdit1 	  	:= Nil
Local cValIt 	  	:= ""
Local aCores
Private oOk 	  	:= LoadBitmap( GetResources(), "LBOK"       )
Private oNo 	  	:= LoadBitmap( GetResources(), "LBNO"       )
Private cRed	  	:= LoadBitmap( GetResources(), "BR_VERMELHO" )
Private cGreen    	:= LoadBitmap( GetResources(), "BR_VERDE" )
Private cBlue	  	:= LoadBitmap( GetResources(), "BR_AZUL" )
Private cLaranja  	:= LoadBitmap( GetResources(), "BR_LARANJA" )
Private cCinza	  	:= LoadBitmap( GetResources(), "BR_CINZA" )
Private aListBox1 	:= {}
Private cCadastro 	:= "Liberacao Manual de para Efetivacao"
Private bFiltraBrw
Private aIndexSCR 	:= {}
Private cDelFunc  	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString   	:= "SCR"
Private c_CodUser 	:= ""
Private oNumSc
Private oListBox1
Private aRotina
Private a_Area 		:= GetArea()
Private cCodUsr    
Private aVetLct		:= {}      
Private cMailUser   := ALLTRIM(CT2->CT2_XEMAIL) // "marciougf2009@gmail.com"  //"florence.franca@totvs.com.br"
//Variaveis Private para inicializar a visualizacao da capa do lote
Private dDataLanc
Private cLote		
Private cLoteSub 	:= GetMv("MV_SUBLOTE")
Private cSubLote	
Private cDoc  
Private lSubLote 

/*                                   
************************ FLORENCE FRANCA *************************
DbSelectArea("CT2")
dbSetOrder(1)
MsSeek(ALLTRIM(SCR->CR_NUM)) 
cMailUser	:= ALLTRIM(CT2->CT2_XEMAIL) 
******************************************************************		
*/

//Montagem de Legenda
aCores :={{ 'CR_STATUS== "01"', 'BR_AZUL' },;   //Bloqueado p/ sistema (aguardando outros niveis)
{ 'CR_STATUS== "02"', 'DISABLE' },;   //Aguardando Liberacao do usuario
{ 'CR_STATUS== "03"', 'ENABLE'  },;   //Titulo Liberado pelo usuario
{ 'CR_STATUS== "04"', 'BR_PRETO'},;   //Titulo Bloqueado pelo usuario
{ 'CR_STATUS== "05"', 'BR_CINZA'} }   //Titulo Liberado por outro usuario

//Botoes da Tela
aRotina 	:= {{OemToAnsi("Pesquisar"),'AxPesqui',   0 , 1},; //"Pesquisar"
{OemToAnsi("Visualizar"),"U_LPVisual",  0 , 2},; //"Visualizar
{OemToAnsi("Liberar")   ,"U_LPLibera",  0 , 4} }//"Liberar"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o usuario logado possui direito de liberacao.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ca091User := RetCodUsr()

dbSelectArea("SAK")
dbSetOrder(2)
If !MsSeek(xFilial("SAK")+ca091User)
	Alert("O acesso e a utilizacao desta rotina e destinada apenas aos usuarios envolvidos no processo de aprovacao da Solicitação de Compras definido pelos grupos de aprovacao. Usuario sem permissao para utilizar esta rotina.Voltar!")
	Return
Else                                                                                                                                 
	//Filtra aprovações pendentes do usuario                                                                                      
	cCodUsr	:= SAK->AK_USER
	dbSelectArea("SCR")
	dbSetOrder(1)  
	dbSeek(ALLTRIM(SCR->CR_NUM))
	cFiltra := "CR_FILIAL =='" + xFilial("SCR") + "' .and. CR_TIPO = 'EF' .And. CR_USER == '" + ca091User + "' .and. CR_STATUS=='02' " 
EndIf                                                                                                                                        
                  
//Monta a tela de acrodo com os filtros
bFiltraBrw := {|| FilBrowse("SCR",@aIndexSCR,@cFiltra) }
Eval(bFiltraBrw)

                                                                                                                                                          
aCposBrw :=  { { "Data Lacto"         , {||  STOD(SUBSTR(SCR->CR_NUM,5,8))}},;
{ "Lote"        	 , {|| SUBSTR(SCR->CR_NUM,13,6) }},;
{ "Sub-Lote"         , {|| SUBSTR(SCR->CR_NUM,19,3) }},;
{ "Documento" 		 , {|| SUBSTR(SCR->CR_NUM,22,6) }}}

mBrowse( 6, 1,22,75,"SCR",aCposBrw,,,,,aCores)

EndFilBrw("SCR",aIndexSCR) //SE5                

RestArea(a_Area)   

Return

*------------------------------------------------------*
User Function LpVisual(cAlias,nRec,nOpcx)
*------------------------------------------------------*

Local a_Area 		:= GetArea()
   

dbSelectArea("CT2")   //SE1
dbSetOrder(1)
If DbSeek(xFilial("CT2")+SUBSTR(SCR->CR_NUM,3,8)+SUBSTR(SCR->CR_NUM,11,6)+SUBSTR(SCR->CR_NUM,17,3)+SUBSTR(SCR->CR_NUM,20,6))
	dDataLanc 	:= CT2->CT2_DATA
	cLote		:= CT2->CT2_LOTE
	cSubLote	:= CT2->CT2_SBLOTE
	cDoc		:= CT2->CT2_DOC
	lSubLote 	:= Empty(CT2->CT2_SBLOTE)
	Ctba102Cal("CT2",CT2->(Recno()),2) 	
EndIf


RestArea(a_Area)
Return


*------------------------------------------------------------------------*
User Function LpLibera(cAlias,nReg,nOpcx)
*------------------------------------------------------------------------*

Local aArea			:= GetArea()
Local aSizeAut		:= MsAdvSize(.F.,.F.)
//Colocar os campos da CT2
Local aCpos         := {"CT2_DATA","CT2_LOTE","CT2_SBLOTE","CT2_DOC",}
local aObjects		:= {}
Local aInfo 		:= {}
Local aPosGet		:= {}
Local aPosObj		:= {}
Local nOpcA         := 0
Local oDlg
Local lRet
Local oQual
Local aItens 	:= {}
Local aCposNew 	:= {}
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
Local cQryAtu		:= ""
Local aAreaCT2		:= CT2->(GetArea())
Private cChave  
Private oDlgLIB
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.
Private cIdTitulo

cNomeUsu	:= UsrFullName(cCodUsr)

If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
	Alert("Esta movimentação já foi liberada")
	lContinua := .F.
ElseIf SCR->CR_STATUS$"01"
	Alert("Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)")
	lContinua := .F.
EndIf

If lContinua
	
	dbSelectArea("SAL")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa as variaveis utilizadas no Display.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRetSaldo 	:= MaSalAlc(cCodLiber,dRefer)
	nSaldo 	  	:= aRetSaldo[1]
	CRoeda 	  	:= A097Moeda(aRetSaldo[2])
	cName  	  	:= UsrRetName(ca091User)
	nTotal    	:= xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
	cIdTitulo	:= SCR->CR_NUM
	If SCR->CR_TIPO == "EF"
				
		dbSelectArea("CT2")
		dbSetOrder(1) 
		MsSeek(ALLTRIM(SCR->CR_NUM))
	
		cChave := xFilial("CT2")+DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC
		
		cGrupo := GetNewPar('MV_XGRPEFE','EFELCT')
		
		//Inicializacao de variaveis para serem executadas no MontaEmail
	 	DbSelectArea("CT2")
		DbSetOrder(1)
		If DbSeek(cChave)
			Do While CT2->(!EOF()) .And. CT2->CT2_FILIAL+DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC == cChave
				
				nTotal	+= CT2->CT2_VALOR
				aAdd(aVetLct,{CT2->CT2_LINHA,CT2->CT2_DC,CT2->CT2_DEBITO,CT2->CT2_CREDIT,CT2->CT2_VALOR,CT2->CT2_HIST,__cUserId,CT2->CT2_DATA})
				
				CT2->(DbSkip())
			EndDo
		Endif
		RestArea(aAreaCT2)
		
		dbSelectArea("SAL")
		dbSetOrder(3)
		MsSeek(xFilial("SAL")+cGrupo+SAK->AK_COD)
	EndIf
	   
	//monta a tela para aprovar ou rejeitar
	AAdd( aObjects, { 100, 100, .T., .T. })
	AAdd( aObjects, { 0,    25, .T., .F. })
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{10,35,100,135,205,255},{10,45,105,145,225,265,210,255}})
	DEFINE MSDIALOG oDlgLIB TITLE OemToAnsi("Lançamentos Contabeis") From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL
	
	RegToMemory("CT2", .f., .F.)
	EnChoice( "CT2", nReg, nOpcx, , , , aCpos, aPosObj[1], , 3 )
	
	@ aPosObj[2,1]+008,aPosObj[2,4]-220 BUTTON "Efetivacao Liberada  " SIZE 60,15 FONT oDlgLIB:oFont ACTION (nOpc := 2,oDlgLIB:End()) PIXEL
	@ aPosObj[2,1]+008,aPosObj[2,4]-140 BUTTON "Efetivacao Nao Liberada" SIZE 65,15 FONT oDlgLIB:oFont ACTION (nOpc := 3,oDlgLIB:End()) PIXEL
	@ aPosObj[2,1]+008,aPosObj[2,4]-060 BUTTON "Sair" SIZE 60,15 FONT oDlgLIB:oFont ACTION (nOpc := 1,oDlgLIB:End()) PIXEL
	ACTIVATE MSDIALOG oDlgLIB
	
	
	If nOpc == 2 .Or. nOpc == 3
		SCR->(dbClearFilter())
		SCR->(dbGoTo(nReg))
		//Tela de motivo somente na reprovacao
		If nOpc == 3
			cObs := FMotivo()
		Endif   

		lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6)) //Funcao para liberar a alcada
        
		If lLiberou //Liberado todos os niveis 
			
			Conout('Registro Liberado')
			Conout('Tipo de Liberacao: '+SCR->CR_TIPO)
			
			If SCR->CR_TIPO == "EF"
				
				Conout('Vou todas as linhas do lote')
				Conout('SCR->CR_NUM '+SCR->CR_NUM)
				
				dbSelectArea("CT2")
				dbSetOrder(1)
				If DbSeek(cChave)
					
					dDataLanc   := CT2->CT2_DATA    
       				cLote		:= CT2->CT2_LOTE
					cSubLote	:= CT2->CT2_SBLOTE
					cDoc		:= CT2->CT2_DOC
					
					cQryAtu	:= " UPDATE "+RetSqlName("CT2")+" SET CT2_XAPROV = 'S' "					
					cQryAtu	+= " WHERE D_E_L_E_T_ <> '*' "
					cQryAtu	+= " AND CT2_FILIAL = '"+xFilial("CT2")+"' "    
					cQryAtu	+= " AND CT2_DATA = '"+DtoS(dDataLanc)+"' "
					cQryAtu	+= " AND CT2_LOTE = '"+cLote+"' "
					cQryAtu	+= " AND CT2_SBLOTE = '"+cSubLote+"' "															
					cQryAtu	+= " AND CT2_DOC = '"+cDoc+"' "																				
					cQryAtu := TcSqlExec(cQryAtu)

					
					Conout('Atualizei e vou enviar aviso de liberacao')
					
					//Função de Aviso de Liberação
					U_AvisoLib("S",cNomeUsu,"Liberacação de Efetivação ","S")    
						
				Else
					Conout('Nao consegui entrar no IF para atualizar: '+SCR->CR_NUM)
				EndIf
			EndIf
			
			
		ElseIf !lLiberou .and. nOpc == 2//Efetivacao Liberada
			
			
			Conout('Registro Liberado para outros niveis')
			
			c_Recno := SCR->(Recno()) //Gravar Recno Atual
			c_NvOrg	:= SCR->CR_NIVEL
			
			DbSelectArea("SCR")
			DbSetOrder(1)
			DbSeek(xFilial("SCR")+'EF'+cChave)
			While !Eof() .And. (xFilial("SCR")+'EF'+cChave = AllTrim(SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM))
				Conout('Nível c_NvOrg '+c_NvOrg)
				Conout('Nível SCR->CR_NIVEL '+SCR->CR_NIVEL)  
				Conout("OI")
				Conout(SCR->CR_DATALIB)
				If Empty(SCR->CR_DATALIB).and. c_NvOrg == SCR->CR_NIVEL //<>
					Conout("ENTREI NO IF")
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
					CT2->(dbSeek(cChave))
					
					conout(":-) Chamara novamente a fc de Envio WF....")
					
					U_WfEfe()
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
			CT2->(dbSeek(cChave))
			
		Else // REJEITOU
			
			Conout('Registro Rejeitado')
			
			If SCR->CR_TIPO == "EF"
				dbSelectArea("CT2")
				dbSetOrder(1)
				If DbSeek(cChave)
					
					dDataLanc :=  CT2->CT2_DATA    
       				cLote		:= CT2->CT2_LOTE
					cSubLote	:= CT2->CT2_SBLOTE
					cDoc		:= CT2->CT2_DOC
					
					cQryAtu	:= " UPDATE "+RetSqlName("CT2")+" SET CT2_XAPROV = 'N' "					
					cQryAtu	+= " WHERE D_E_L_E_T_ <> '*' "
					cQryAtu	+= " AND CT2_FILIAL = '"+xFilial("CT2")+"' "
					cQryAtu	+= " AND CT2_DATA = '"+DtoS(dDataLanc)+"' "
					cQryAtu	+= " AND CT2_LOTE = '"+cLote+"' "
					cQryAtu	+= " AND CT2_SBLOTE = '"+cSubLote+"' "															
					cQryAtu	+= " AND CT2_DOC = '"+cDoc+"' "																				
					cQryAtu := TcSqlExec(cQryAtu)
					 

					Conout('Atualizei e vou enviar aviso de liberacao')
					
					//Função de Aviso de Liberação
					U_AvisoLib("N",cNomeUsu,"Liberacação de Efetivação ","N")
				Else
					Conout('Nao consegui entrar no IF para atualizar: '+SCR->CR_NUM)
				EndIf
				
				
			EndIf
			
		EndIf
		
	Endif
	
EndIf       

dbSelectArea("SCR")
dbSetOrder(1)
SCR->(Eval(bFiltraBrw))

RestArea(aArea)

Return Nil                                                       


*---------------------------------------------------------------*
Static Function FMotivo()
*---------------------------------------------------------------*

Local oMemo1
Local n_opca    	:=	0
Local aPosObj   	:= {}
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

DEFINE MSDIALOG oDlg TITLE "Justificativa de Aprovação/Rejeição" FROM 0,0 to 300,350 OF oDlgLIB PIXEL
@ 040,010 Say	"Motivo"				Size 150,008 FONT oFont2 COLOR CLR_BLACK PIXEL OF oDlg
@ 070,010 Get	oMotivo VAR cMotivo Memo	Size 150,050 WHEN .T.	COLOR CLR_BLACK	PIXEL OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg, {|| iif  (fMemo(), (n_opca := 1 , oDlg:End()), n_opca := 0) },{|| fMemo(),n_opca := 1 ,n_opca := 0 },,a_buttons)

Return Alltrim(cMotivo)


Static Function fMemo

Local lRet := .T.

If empty(cMotivo)
	Alert("Favor preencher uma justificativa")
	lRet := .F.
EndIf

Return lRet

