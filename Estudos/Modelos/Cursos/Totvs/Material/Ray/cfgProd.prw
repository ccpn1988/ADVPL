#include 'protheus.ch'
#include 'parmtype.ch'


//--------------------------------------------------------------
/*/{Protheus.doc} AtuProd
Description                                                     
                                                                
@param xParam Parameter Description                             
@return xRet Return Description                                 
@author  -                                               
@since 08/05/2019                                                   
/*/                                                             
//--------------------------------------------------------------

/*
	Esta fun��o gera a tela inicial para parametriza��o do sistema.
	O operador dever� informar o recurso, turno, nome e ajudante (se houver)
*/
User Function CfgProd()
                       

	Local Iniciar
	Local oButton2
	Local oComboBo1
	Local nComboBo1 := 1
	Local oGet1
	Local cGet1 := Space(6)
	Local oGet2
	Local cGet2 := Space(15)
	Local oGet3
	Local cGet3 := Space(15)
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4

	Private oFont1 := TFont():New("Segoe UI",,032,,.F.,,,,,.F.,.F.)
	Private oFontGet := TFont():New("Segoe UI",,028,,.F.,,,,,.F.,.F.)
	Private oFontLbl := TFont():New("Calibri",,032,,.F.,,,,,.F.,.F.)
	Private oFontMin := TFont():New("Segoe UI",,026,,.F.,,,,,.F.,.F.)
	Private oFont5 := TFont():New("Franklin Gothic Medium Cond",,028,,.F.,,,,,.F.,.F.)
	Private oFont6 := TFont():New("Calibri",,024,,.F.,,,,,.F.,.F.)

	Static oDlgIni
	
	RpcSetEnv("99","01")

	DEFINE MSDIALOG oDlgIni TITLE "Parametos Iniciais" FROM 000, 000  TO 300, 300 COLORS 0, 15132390 PIXEL

		@ 003, 003 SAY oSay1 PROMPT "Recurso" SIZE 065, 022 OF oDlgIni FONT oFontLbl COLORS 0, 16777215 PIXEL
		@ 002, 080 SAY oSay2 PROMPT "Turno" SIZE 050, 022 OF oDlgIni FONT oFontLbl COLORS 0, 16777215 PIXEL
		@ 030, 003 MSGET oGet1 VAR cGet1 SIZE 065, 022 OF oDlgIni COLORS 0, 16777215 FONT oFontGet PIXEL F3 "SH1"
		@ 030, 080 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"1","2","3"} SIZE 050, 022 OF oDlgIni COLORS 0, 16777215 FONT oFontGet PIXEL

		@ 060, 003 SAY oSay3 PROMPT "Operador" SIZE 065, 022 OF oDlgIni FONT oFontLbl COLORS 0, 16777215 PIXEL
		@ 060, 080 SAY oSay4 PROMPT "Ajudante" SIZE 060, 022 OF oDlgIni FONT oFontLbl COLORS 0, 16777215 PIXEL
		@ 087, 003 MSGET oGet2 VAR cGet2 SIZE 065, 022 OF oDlgIni COLORS 0, 16777215 FONT oFontGet PIXEL
		@ 087, 080 MSGET oGet3 VAR cGet3 SIZE 060, 022 OF oDlgIni COLORS 0, 16777215 FONT oFontGet PIXEL

		@ 117, 010 BUTTON Iniciar PROMPT "Iniciar" SIZE 050, 022 OF oDlgIni FONT oFontMin PIXEL ;
			ACTION AtuProd( cGet1, nComboBo1, cGet2, cGet3)
		@ 117, 085 BUTTON oButton2 PROMPT "Fim" SIZE 050, 022 OF oDlgIni FONT oFontMin PIXEL ACTION oDlgIni:End()

	ACTIVATE MSDIALOG oDlgIni CENTERED

Return

/*
	Esta Rotina � o Frame principal do sistema. 
		- Neste s�o exibidos os dados do par�metro Inicial.
		- Cadastro da OP do sistema (exibindo informa��es adicionais da mesma)
		- Lan�amentos de Produ��o, parada e refugo da produ��o.
*/

Static Function AtuProd( nMaq, nTurno, cOperador, cAjudante)

		Local oSay1
		Local oSay2
		Local oSay3
		Local oSay4
		Local oSay5
		Local oSay6
		Local oSay7
		Local oSay8
		Local oSay9		
		Local oSay10
		Local oSay11
		Local oSay12	
		Local oSay13
		Local oSay14
		Local oSay15
		
		
		
		
		Private oButton2M
		Private oButton3M
		Private oButton4M
		Private oButton5M
		Private oButton6M
		Private oButton7M
		Private oButton8M
		Private oButton9M
		Private oButtonAM
		Private oSayStatus
		
		Private oGetOp
		Private cCabecIni := "Recurso: " + cValToChar(nMaq) + " | Turno: " + cValToChar(nTurno);
			+ " | Operador: " + cOperador + " | Ajudante: " + cAjudante
		Private cProduto
		Private cDescProduto
		Private	cSaldo := Space(10)
		Private cGetOp  := Space(11)
		Private cStatusMq := {"Produ��o n�o alocada","Produzindo","M�quina Parada"}
		
		Static oDlgApnt

	DEFINE MSDIALOG oDlgApnt TITLE "Apontar Producao" FROM 000, 000  TO 450, 600 COLORS 0, 15132390 PIXEL

		@ 003, 006 SAY oSay1 PROMPT cCabecIni SIZE 290, 035 OF oDlgApnt FONT oFont6 COLORS 0, 16777215 PIXEL
		@ 042, 006 SAY oSay2 PROMPT "N� DA OP (CP): " SIZE 070, 022 OF oDlgApnt FONT oFont5 COLORS 0, 16777215 PIXEL
		@ 042, 090 MSGET oGetOp VAR cGetOp SIZE 080, 021 OF oDlgApnt COLORS 0, 16777215 FONT oFont5 PIXEL F3 "SC2TMP";
		 	VALID iif(ValOp(cGetOp),.T.,MsgInfo("C�digo da Op Errado!","Aten��o"))
		@ 042, 180 SAY oSay3 PROMPT cProduto SIZE 150, 022 OF oDlgApnt FONT oFont5 COLORS 0, 16777215 PIXEL

		@ 070, 006 SAY oSay4 PROMPT cDescProduto SIZE 300, 020 OF oDlgApnt FONT oFont5 COLORS 0, 16777215 PIXEL

		@ 100, 006 SAY oSay5 PROMPT cSaldo SIZE 090, 030 OF oDlgApnt FONT oFont5 COLORS 0, 16777215 PIXEL
		@ 100, 110 SAY oSayStatus PROMPT cStatusMq[1] SIZE 200, 030 OF oDlgApnt FONT oFont1 COLORS 0, 16777215 PIXEL

		
		@ 135, 006 SAY oSay7 PROMPT "Ini Produ��o" SIZE 050, 015 OF oDlgApnt FONT oFont6 COLORS 0, 16777215 PIXEL
		@ 146, 006 BUTTON oButton2M PROMPT "Iniciar Prod" SIZE 050, 025 OF oDlgApnt PIXEL ACTION HrPrdIni()
		@ 135, 062 SAY oSay8 PROMPT "Ini Parada" SIZE 050, 015 OF oDlgApnt FONT oFont6 COLORS 0, 16777215 PIXEL
		@ 146, 062 BUTTON oButton3M PROMPT "Iniciar Parada" SIZE 050, 025 OF oDlgApnt PIXEL ACTION IniParada()
		@ 135, 118 SAY oSay10 PROMPT "Produ��o Pcs" SIZE 050, 015 OF oDlgApnt FONT oFont6 COLORS 0, 16777215 PIXEL		
		@ 146, 118 BUTTON oButton4M PROMPT "Producao" SIZE 050, 025 OF oDlgApnt PIXEL ACTION QtProd()
		@ 135, 174 SAY oSay12 PROMPT "Trocar OP" SIZE 050, 015 OF oDlgApnt FONT oFont6 COLORS 0, 16777215 PIXEL
		@ 146, 174 BUTTON oButton6M PROMPT "Trocar OP" SIZE 050, 025 OF oDlgApnt PIXEL ACTION TrocaOp()

		@ 180, 006 SAY oSay8 PROMPT "Fechar Prod" SIZE 050, 015 OF oDlgApnt FONT oFont6 COLORS 0, 16777215 PIXEL
		@ 191, 006 BUTTON oButton9M PROMPT "Fechar Produ��o" SIZE 050, 025 OF oDlgApnt PIXEL ACTION HrPrdFin()
		@ 180, 062 SAY oSay9 PROMPT "Fim Parada" SIZE 050, 015 OF oDlgApnt FONT oFont6 COLORS 0, 16777215 PIXEL
		@ 191, 062 BUTTON oButtonAM PROMPT "Terminar Parada" SIZE 050, 025 OF oDlgApnt PIXEL ACTION FimParada()
		@ 180, 118 SAY oSay11 PROMPT "Refugo" SIZE 050, 015 OF oDlgApnt FONT oFont6 COLORS 0, 16777215 PIXEL		
		@ 191, 118 BUTTON oButton5M PROMPT "Refugo" SIZE 050, 025 OF oDlgApnt PIXEL ACTION QtRefugo()
		@ 180, 174 SAY oSay13 PROMPT "Setup" SIZE 050, 015 OF oDlgApnt FONT oFont6 COLORS 0, 16777215 PIXEL		
		@ 191, 174 BUTTON oButton7M PROMPT "Setup" SIZE 050, 025 OF oDlgApnt PIXEL
		

		@ 135, 230 SAY oSay14 PROMPT "Trocar Turno" SIZE 050, 015 OF oDlgApnt FONT oFont6 COLORS 0, 16777215 PIXEL		
		@ 146, 230 BUTTON oButton8M PROMPT "Trocar Turno" SIZE 050, 025 OF oDlgApnt PIXEL ;
			ACTION iif(MsgYesNo('Tem certeza?'),oDlgApnt:End(),)
			
		oButton9M:Hide()
		oButtonAM:Hide()
		oButton4M:Hide()
		
	ACTIVATE MSDIALOG oDlgApnt CENTERED

Return

/*
	Rotina acionada para in�cio de uma parada no sistema, � acionada por um bot�o de mesmo nome.
	Desabilita os bot�es: Terminar produ��o, produ��o, Iniciar Parada
	Habilita os bot�es: Terminar Parada
*/
Static Function IniParada()

	Local oButton1
	Local oButton2
	Local oGet1
	Local cGet1 := HoraAtual()
	Local oGet2
	Local cGet2 := Space(2)
	Local oSay1
	Local oSay2
	Static oDlgParada
	
	DEFINE MSDIALOG oDlgParada TITLE "Apontar Parada" FROM 000, 000  TO 250, 200 COLORS 0, 15132390 PIXEL

		@ 005, 012 SAY oSay1 PROMPT "Hora" SIZE 075, 017 OF oDlgParada FONT oFontMin COLORS 0, 16777215 PIXEL
		@ 027, 012 MSGET oGet1 VAR cGet1 SIZE 075, 017 OF oDlgParada PICTURE "@R 99:99" COLORS 0, 16777215 FONT oFontMin PIXEL
		@ 050, 012 SAY oSay2 PROMPT "Motivo" SIZE 075, 017 OF oDlgParada FONT oFontMin COLORS 0, 16777215 PIXEL
		@ 072, 037 MSGET oGet2 VAR cGet2 SIZE 025, 018 OF oDlgParada COLORS 0, 16777215 FONT oFontMin PIXEL F3 "44"
		@ 097, 007 BUTTON oButton1 PROMPT "OK" SIZE 037, 020 OF oDlgParada FONT oFontMin PIXEL ;
			ACTION (oButton9M:Hide(), oButton3M:Hide(), oButton4M:Hide(), oButtonAM:Show(), ;
				oSayStatus:setText(cStatusMq[3]), oSayStatus:nClrText := 255, oDlgParada:End())
		@ 097, 055 BUTTON oButton2 PROMPT "Cancela" SIZE 037, 020 OF oDlgParada FONT oFontMin PIXEL ACTION oDlgParada:End()
		
	ACTIVATE MSDIALOG oDlgParada CENTERED

Return

/*
	Rotina acionada para Finalizar uma parada iniciada no sistema, � acionada por um bot�o de mesmo nome.
	Tamb�m � poss�vel informar as perdas no sistema.
	Libera os bot�es: Parar produ��o, produ��o, Iniciar Parada
*/

Static Function FimParada()

	Local oButton1
	Local oButton2
	Local oGet1
	Local cGet1 := HoraAtual()
	Local oSay1
	Local oGet2
	Local cGet2 := Space(10)
	Local oSay2
	Static oDlgParada
	
	DEFINE MSDIALOG oDlgParada TITLE "Apontar Parada" FROM 000, 000  TO 250, 200 COLORS 0, 15132390 PIXEL

		@ 005, 012 SAY oSay1 PROMPT "Hora" SIZE 075, 017 OF oDlgParada FONT oFontMin COLORS 0, 16777215 PIXEL
		@ 027, 012 MSGET oGet1 VAR cGet1 SIZE 075, 017 OF oDlgParada PICTURE "@R 99:99" COLORS 0, 16777215 FONT oFontMin PIXEL
		
		@ 055, 012 SAY oSay2 PROMPT "Quantidade" SIZE 075, 012 OF oDlgProd FONT oFontMin COLORS 0, 16777215 PIXEL
		@ 070, 012 MSGET oGet2 VAR cGet2 SIZE 075, 017 OF oDlgProd PICTURE "@E" COLORS 0, 16777215 FONT oFontMin PIXEL
		
		@ 097, 007 BUTTON oButton1 PROMPT "OK" SIZE 037, 020 OF oDlgParada FONT oFontMin PIXEL ;
			ACTION (oButton9M:Show(), oButton3M:Show(), oButton4M:Show(), oButtonAM:Hide(), ;
				oSayStatus:setText(cStatusMq[2]), oSayStatus:nClrText := 65280, oDlgParada:End()) //Libera Bot�o de terminar 
		@ 097, 055 BUTTON oButton2 PROMPT "Cancela" SIZE 037, 020 OF oDlgParada FONT oFontMin PIXEL ACTION oDlgParada:End()
		
	ACTIVATE MSDIALOG oDlgParada CENTERED

Return

/*
	Esta rotina tem por objetivo iniciar ou reiniciar uma produ��o.
	Carrega a Hora atual, mas permite alterar manualmente.
	Desabilita os bot�es: Iniciar produ��o
	Habilitar os bot�es: produ��o, Parar Produ��o
*/
Static Function HrPrdIni()
	Local oSay1
	Local oButton1
	Local oButton2
	Local oGet1
	Local cGet1 := HoraAtual()
	Static oDlgProd
	
	DEFINE MSDIALOG oDlgProd TITLE "Apontar Produ��o" FROM 000, 000  TO 200, 200 COLORS 0, 15132390 PIXEL

		@ 005, 012 SAY oSay1 PROMPT "Hora" SIZE 075, 017 OF oDlgProd FONT oFontMin COLORS 0, 16777215 PIXEL
		@ 027, 012 MSGET oGet1 VAR cGet1 SIZE 075, 017 OF oDlgProd PICTURE "@R 99:99" COLORS 0, 16777215 FONT oFontMin PIXEL
		@ 060, 007 BUTTON oButton1 PROMPT "OK" SIZE 037, 020 OF oDlgProd FONT oFontMin PIXEL ;
		ACTION (oButton2M:Hide(), oButton4M:Show(), oButton9M:Show(), oSayStatus:setText(cStatusMq[2]),; 
			 oSayStatus:nClrText := 65280, oDlgProd:End())
		@ 060, 055 BUTTON oButton2 PROMPT "Cancela" SIZE 037, 020 OF oDlgProd FONT oFontMin PIXEL ACTION oDlgProd:End()
		
	ACTIVATE MSDIALOG oDlgProd CENTERED

Return

/*
	Esta rotina tem por objetivo iniciar ou reiniciar uma produ��o.
	Carrega a Hora atual, mas permite alterar manualmente.
	Desabilita os bot�es: Parar produ��o
	Habilitar os bot�es: Iniciar Produ��o
*/
Static Function HrPrdFin()

	Local oSay1
	Local oGet1
	Local cGet1 := HoraAtual()
	Local oSay2
	Local oGet2
	Local cGet2 := Space(10)
	
	Local oButton1
	Local oButton2
	Static oDlgProd
	
	DEFINE MSDIALOG oDlgProd TITLE "Apontar Produ��o" FROM 000, 000  TO 300, 200 COLORS 0, 15132390 PIXEL

		@ 005, 012 SAY oSay1 PROMPT "Hora" SIZE 075, 017 OF oDlgProd FONT oFontMin COLORS 0, 16777215 PIXEL
		@ 027, 012 MSGET oGet1 VAR cGet1 SIZE 075, 017 OF oDlgProd PICTURE "@R 99:99" COLORS 0, 16777215 FONT oFontMin PIXEL
		
		@ 055, 012 SAY oSay2 PROMPT "Quantidade" SIZE 075, 017 OF oDlgProd FONT oFontMin COLORS 0, 16777215 PIXEL
		@ 080, 012 MSGET oGet2 VAR cGet2 SIZE 075, 017 OF oDlgProd PICTURE "@E" COLORS 0, 16777215 FONT oFontMin PIXEL
		
		@ 120, 007 BUTTON oButton1 PROMPT "OK" SIZE 037, 020 OF oDlgProd FONT oFontMin PIXEL ;
		ACTION (oButton9M:Hide(), oButton2M:Show(), oSayStatus:setText(cStatusMq[1]),;
		 	oSayStatus:nClrText := 0, TrocaOp(), oDlgProd:End()) 
		@ 120, 055 BUTTON oButton2 PROMPT "Cancela" SIZE 037, 020 OF oDlgProd FONT oFontMin PIXEL ACTION oDlgProd:End()
		
	ACTIVATE MSDIALOG oDlgProd CENTERED

Return


/*
	Esta rotina tem por objetivo apontar os refugos de uma produ��o a partir de um motivo.
*/
Static Function QtRefugo()

	Local oButton1
	Local oButton2
	Local oGet1
	Local cGet1 := Space(10)
	Local oGet2
	Local cGet2 := Space(3)
	Local oSay1
	Local oSay2
	Static oDlgRef
	
	DEFINE MSDIALOG oDlgRef TITLE "Apontar Refugo" FROM 000, 000  TO 250, 200 COLORS 0, 15132390 PIXEL

		@ 005, 012 SAY oSay1 PROMPT "Quantidade - KG" SIZE 075, 017 OF oDlgRef FONT oFontMin COLORS 0, 16777215 PIXEL
		@ 027, 012 MSGET oGet1 VAR cGet1 SIZE 075, 017 OF oDlgRef COLORS 0, 16777215 FONT oFontMin PIXEL
		@ 050, 012 SAY oSay2 PROMPT "Motivo" SIZE 075, 017 OF oDlgRef FONT oFontMin COLORS 0, 16777215 PIXEL
		@ 072, 037 MSGET oGet2 VAR cGet2 SIZE 025, 018 OF oDlgRef COLORS 0, 16777215 FONT oFontMin PIXEL
		@ 097, 007 BUTTON oButton1 PROMPT "OK" SIZE 037, 020 OF oDlgRef FONT oFontMin PIXEL
		@ 097, 055 BUTTON oButton2 PROMPT "Cancela" SIZE 037, 020 OF oDlgRef FONT oFontMin PIXEL ACTION oDlgRef:End()
		
	ACTIVATE MSDIALOG oDlgRef CENTERED

Return

/*
	Esta rotina tem por objetivo apontar a produ��o e atualizar o saldo da OP.
*/
Static Function QtProd()

	Local oButton1
	Local oButton2
	Local oGet1
	Local cGet1 := Space(10)
	Local oSay1
	Static oDlgQtProd
	
	DEFINE MSDIALOG oDlgQtProd TITLE "Apontar Quantidade" FROM 000, 000  TO 250, 200 COLORS 0, 15132390 PIXEL

		@ 005, 012 SAY oSay1 PROMPT "Quantidade" SIZE 075, 017 OF oDlgQtProd FONT oFontMin COLORS 0, 16777215 PIXEL
		@ 027, 012 MSGET oGet1 VAR cGet1 SIZE 075, 017 OF oDlgQtProd COLORS 0, 16777215 FONT oFontMin PIXEL
		@ 060, 007 BUTTON oButton1 PROMPT "OK" SIZE 037, 020 OF oDlgQtProd FONT oFontMin PIXEL ACTION oDlgQtProd:End()
		@ 060, 055 BUTTON oButton2 PROMPT "Cancela" SIZE 037, 020 OF oDlgQtProd FONT oFontMin PIXEL ACTION oDlgQtProd:End()
		
	ACTIVATE MSDIALOG oDlgQtProd CENTERED

Return

/*
	Esta fun��o valida o n�mero da ordem de produ��o digitado pelo usu�rio e atualiza os campos de c�digo e no frame oDlgProd
*/
STATIC Function ValOp(cOp)
	
	Local lValida := .F.
	Local nSaldo
	
	dbSelectArea("SC2")
	dbSetOrder(1)
	
	If MsSeek(xFilial("SC2")+cOp)
		cProduto := SC2 -> C2_PRODUTO
		cDescProduto := Posicione('SB1',1,xFILIAL('SB1')+SC2->C2_PRODUTO,'B1_DESC')
		cSaldo := Round(SC2->C2_QUANT - SC2 -> C2_QUJE,3) * VlConverter(cProduto)
		cSaldo := "SALDO: " + cValToChar(cSaldo) + "  " + SC2 -> C2_SEGUM
		oGetOp:lReadOnly := .T.
		lValida := .T.

	Else
		MsgAlert("Produto n�o Localizado","Aten��o!!")
		cDescProduto := ""
	Endif
	
	dbCloseArea()	
	
return(lValida)


Static Function TrocaOp()

	oGetOp:lReadOnly := .F.
	cProduto := ""
	cDescProduto := ""
	cSaldo := ""
	cGetOp := Space(11)
	
Return

Static Function VlConverter(cCod)
	
	Local nFator //fator de convers�o do produto
	Local cTipConv //tipo de convers�o cadastrado no sistema M-> multiplica��o ou D->Divis�o
	Local nConv //Valor a ser multiplicado para converter os saldos
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	If MsSeek(xFILIAL("SB1")+cCod)
		cTipConv := SB1->B1_TIPCONV
		nFator := SB1->B1_CONV
	endif	
	
	If cTipConv = 'M'
		nConv := 1 * nFator
	ElseIf cTipConv = 'D'
		nConv := 1 / nFator
	Else
		nConv = 0
		MsgInfo("N�o h� convers�o cadastrada para este produto")
	endif	
	
Return(nConv)


// esta rotina busca a hora atual e retorna uma string com 5 caracteres
Static Function HoraAtual()
	Local cHoraAtu
	
	cHoraAtu := substring(Time(),1,5)
	
Return(cHoraAtu)
