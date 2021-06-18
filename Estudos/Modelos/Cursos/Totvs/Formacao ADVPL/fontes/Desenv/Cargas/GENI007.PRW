#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

#DEFINE cEnt      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI007   ºAutor  ³Rafael Lima         º Data ³  28/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para importação de titulos a receber               º±±
±±º          ³                                                            º±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºAlteração ³Autor  ³Joni Fujiyama                  º Data ³  02/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina foi adaptada para rodar por schedule.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENI007

Private cFunName := PROCNAME()

If MsgYesNo("Esta rotina fará a importação de títulos a receber. Deseja continuar ?","Atencao")
	Processa({||Importa()})
EndIf

Return()


//*************************************************************************************************//
// Rotina da execução por schedule				Autor: Joni Fujiyama			Data:02/07/2014			 //
//*************************************************************************************************//
User Function GENI007A()

Local lRotMens:=.F.
Private cFunName := PROCNAME()

Prepare Environment Empresa "00" Filial "1001"

RotMens("Executando a rotina ==> " + cFunName,"","")

lRotMens := RotMens("Iniciando o Schedule ...","","")

Importa()

lRotMens := RotMens("Fim do Schedule ...","","")

Reset Environment

Return()



/**************************************************************************************
Mostra a mensagem na tela ou no console			Autor: Joni Fujiyama		Data:02/07/2014
***************************************************************************************/
Static Function RotMens(pTexto1,pTexto2,pTipo)


IF cFunName == "U_GENI007"
	DO CASE
		Case pTipo = "1"
			MSGBOX(pTexto1,pTexto2)
		Case pTipo = "2"
			MSGINFO(pTexto1,pTexto2)
	ENDCASE
ELSE
	IF cFunName == "U_GENI007A"
		Conout(pTexto1)
	ENDIF
ENDIF


Return .T.




Static Function Importa()

Local lErro   	:= .F.
Local nItens  	:= 0
Local cFilBkp 	:= cFilant //Para salvar a filial original
Local cPath   	:= "\logsiga\receber\"
Local cFile   	:= Space(0)
Local cQuery
Local cQueryINS
Local nTotReg 	:= 0
Local cGrupo	:= Space(0)
Local lFind		:= .F.
Local cPrefix	:= Space(0)
Local cNum		:= Space(0)
Local cParcela	:= Space(0)
Local cTipo		:= Space(0)
Local cCodNat	:= Space(0)
Local cCodCli	:= SPACE(TamSx3("A1_COD")[1])
Local cLojaCli	:= SPACE(TamSx3("A1_LOJA")[1])
Local cFilOld	:= cFilAnt
Local cE1DEBITO := Space(0)
Local cE1CREDIT := Space(0)
Local cXINTER   := Space(0)
Local cXEDICAO  := Space(0)
Local xcHist    := Space(0)
Local cCGC      := Space(0)

_aDir := directory(Alltrim(cPath)+"*")
For i:=1 to len(_aDir)
	fErase(Alltrim(cPath)+_aDir[i][1])
Next i

//Private lMSHelpAuto := .T. //.F. // para nao mostrar os erro na tela
Private lAchou      := .F.
Private lMSErroAuto := .F. // inicializa como falso, se voltar verdadeiro e'que deu erro
Private cAliasQry   := GetNextAlias()
Private aTitulo     := {}

cQuery := "SELECT SUBSTR(E1_NUM,2) NUM, TT.* FROM TT_I08_TITULOS_RECEBER TT ORDER BY E1_NUM
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliasQry, .F., .T.)
Count TO nTotReg// Conta Registro
RotMens("Select ... "+cQuery,"","")
dbSelectArea(cAliasQry)
dbGoTop()
IF cFunName == "U_GENI007"
	ProcRegua(nTotReg) // Numero de registros a processar
ENDIF
RotMens("Total de Registros a ser processado  ... "+str(nTotReg),"","")
//nTotReg
nItens:= 0
While !(cAliasQry)->(Eof())
	
	aTitulo	:= {}
	
	cPrefix	:= Iif(Empty(AllTrim((cAliasQry)->E1_PREFIXO)),SPACE(TamSx3("E1_PREFIXO")[1]),AllTrim((cAliasQry)->E1_PREFIXO))
	cNum		:= Iif(Empty(AllTrim((cAliasQry)->NUM)),SPACE(TamSx3("E1_NUM")[1]),AllTrim((cAliasQry)->NUM))
	cParcela	:= Iif(Empty(AllTrim((cAliasQry)->E1_PARCELA)),SPACE(TamSx3("E1_PARCELA")[1]),AllTrim((cAliasQry)->E1_PARCELA))
	cTipo		:= Iif(Empty(AllTrim((cAliasQry)->E1_TIPO)),SPACE(TamSx3("E1_TIPO")[1]),AllTrim((cAliasQry)->E1_TIPO))
	xcHist     := IIF(Empty(AllTrim((cAliasQry)->E1_HIST)),SPACE(TamSx3("E1_HIST")[1]),AllTrim((cAliasQry)->E1_HIST))
	cCodGEN	:= PADR(AllTrim(STR((cAliasQry)->E1_CLIENTE)),TAMSX3("A1_XCODOLD")[1])
	cCGC		:= padr(Alltrim((cAliasQry)->CNPJ_CLIENTE),TamSx3("A1_CGC")[1])
	
	cE1CREDIT	:= Space(0)
	cE1DEBITO	:= Space(0)
	cXINTER 	:= Space(0)
	cXEDICAO	:= Space(0)
	
	nItens++
	lAchou := .F.
	If alltrim(cCGC) <> ''
		cCodCli	 := POSICIONE("SA1",3,xFilial("SA1")+cCGC,"A1_COD")
		cLojaCli := POSICIONE("SA1",3,xFilial("SA1")+cCGC,"A1_LOJA")
		
		If alltrim(cCodGEN) = ''
			cCodCli	 := POSICIONE("SA1",9,xFilial("SA1")+cCodGEN,"A1_COD")
			cLojaCli := POSICIONE("SA1",9,xFilial("SA1")+cCodGEN,"A1_LOJA")
		End If
	Else
		cCodCli	 := POSICIONE("SA1",9,xFilial("SA1")+cCodGEN,"A1_COD")
		cLojaCli := POSICIONE("SA1",9,xFilial("SA1")+cCodGEN,"A1_LOJA")
	EndIf
	RotMens("Cliente ... "+cCodCli,"","")
	
	If alltrim(cCodCli) = ''
		Memowrite(cPath+"\"+Dtos(dDataBase) + " - Título "+Alltrim(cNum)+".log","Cod. Cliente GEN: " + cCodGEN +" | CNPJ: "+ALLTRIM((cAliasQry)->CNPJ_CLIENTE)+" - Não Encontrado")
		lErro := .T.
	Else
		RotMens("Iniciando a importação dos títulos do Cliente ... "+cCodCli,"","")
		cCodNat 	:= (cAliasQry)->E1_NATUREZ
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Incrementa a regua                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF cFunName == "U_GENI007"
			IncProc("Importando titulos a receber...  Linha "+cValtoChar(nItens))
		ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³PREENCHE COM ESPAÇO NECESSARIO PARA FUNCIONAR O DBSEEK³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cNum  	 := Strzero(Val(cNum),TamSx3("E1_NUM")[1])
		cPrefix  := padr(cPrefix,TamSx3("E1_PREFIXO")[1])
		cParcela := padr(cParcela,TamSx3("E1_PARCELA")[1])
		cTipo 	 := padr(cTipo,TamSx3("E1_TIPO")[1])
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CONTA DEBITO OU CREDITO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasQry)->E1_TIPO == 'NCC'
			cE1DEBITO := (cAliasQry)->E1_CONTA
			
			If SubStr(Alltrim((cAliasQry)->E1_CONTA),1,7) == '3102070'
				cE1CREDIT := '2109020'+SubStr(Alltrim((cAliasQry)->E1_CONTA),8,1)
			EndIf
			If SubStr(Alltrim((cAliasQry)->E1_CONTA),1,7) == '3102050'
				cE1CREDIT := '21090298'
			EndIf
			If SubStr(Alltrim((cAliasQry)->E1_CONTA),1,7) == '3102040'
				cE1CREDIT := '21090298'
			EndIf
			If SubStr(Alltrim((cAliasQry)->E1_CONTA),1,7) == '3102060'
				cE1CREDIT := '21090298'
			EndIf
		Else
			cE1CREDIT := (cAliasQry)->E1_CONTA
		EndIf
		RotMens("Conta Crédito ... "+cE1CREDIT,"","")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CONTA DEBITO E INTERCOMPANY  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cXINTER := '0'
		If (cAliasQry)->E1_CONTA == '31010301'
			cE1DEBITO := '11020201'
			cXINTER := '1'
		ElseIf	(cAliasQry)->E1_CONTA == '31010302'
			cE1DEBITO := '11020202'
			cXINTER := '2'
		ElseIf	(cAliasQry)->E1_CONTA == '31010303'
			cE1DEBITO := '11020203'
			cXINTER := '3'
		ElseIf	(cAliasQry)->E1_CONTA == '31010304'
			cE1DEBITO := '11020204'
			cXINTER := '4'
		ElseIf	(cAliasQry)->E1_CONTA == '31010305'
			cE1DEBITO := '11020205'
			cXINTER := '5'
		ElseIf	(cAliasQry)->E1_CONTA == '31010306'
			cE1DEBITO := '11020206'
			cXINTER := '6'
		ElseIf	(cAliasQry)->E1_CONTA = '31010201'
			cE1DEBITO := '11020102'
		ElseIf	(cAliasQry)->E1_CONTA = '31010202'
			cE1DEBITO := '11020102'
		ElseIf	(cAliasQry)->E1_CONTA = '31010101'
			cE1DEBITO := '11020101'
		ElseIf	(cAliasQry)->E1_CONTA = '31010102'
			cE1DEBITO := '11020101'
		ElseIf	(cAliasQry)->E1_CONTA = '31010502'
			cE1DEBITO := '11020101'
		EndIF
		RotMens("Conta Débito ... "+cE1DEBITO ,"","")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  EDIÇÃO        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF  (cAliasQry)->E1_CONTA $ '31010201|31010101|31020501|31020601'
			cXEDICAO := '1' //proprio
		ElseIf  (cAliasQry)->E1_CONTA $ '31010202|31010102|31020502|31020602'
			cXEDICAO := '2' //terceiro
		Else
			cXEDICAO := '3' //ambos
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os campos obtendo os valores da linha lida do arquivo texto.  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		cFilAnt := ALLTRIM((cAliasQry)->E1_FILIAL)
		DbSelectArea("SE1")
		DbSetOrder(2)
		//lFind := DbSeek(ALLTRIM((cAliasQry)->E1_FILIAL)+cCodCli+cLojaCli+cPrefix+cNum+cParcela+cTipo)
		If !DbSeek(ALLTRIM((cAliasQry)->E1_FILIAL)+cCodCli+cLojaCli+cPrefix+cNum+cParcela+cTipo)
			aAdd(aTitulo, {"E1_FILIAL", ALLTRIM((cAliasQry)->E1_FILIAL), Nil})
			aAdd(aTitulo, {"E1_PREFIXO", cPrefix, Nil})
			aAdd(aTitulo, {"E1_NUM", cNum, Nil})
			aAdd(aTitulo, {"E1_PARCELA", cParcela, Nil})
			aAdd(aTitulo, {"E1_TIPO", cTipo, Nil})
			aAdd(aTitulo, {"E1_NATUREZ", cCodNat, Nil})
			aAdd(aTitulo, {"E1_CLIENTE", cCodCli, Nil})
			aAdd(aTitulo, {"E1_LOJA", cLojaCli, Nil})
			aAdd(aTitulo, {"E1_EMISSAO", sTod((cAliasQry)->E1_EMISSAO), Nil})
			aAdd(aTitulo, {"E1_VENCTO", sTod((cAliasQry)->E1_VENCTO), Nil})
			aAdd(aTitulo, {"E1_VENCREA", DATAVALIDA(sTod((cAliasQry)->E1_VENCREA)), Nil})
			aAdd(aTitulo, {"E1_MOEDA", 1, Nil})
			aAdd(aTitulo, {"E1_VALOR", (cAliasQry)->E1_VALOR, Nil})
			aAdd(aTitulo, {"E1_FLUXO", "S", Nil})
			aAdd(aTitulo, {"E1_CREDIT", cE1CREDIT, Nil})
			aAdd(aTitulo, {"E1_DEBITO", cE1DEBITO, Nil})
			aAdd(aTitulo, {"E1_XINTER", cXINTER, Nil})
			aAdd(aTitulo, {"E1_XEDICAO", cXEDICAO, Nil})
			aAdd(aTitulo, {"E1_IDCNAB", AllTrim((cAliasQry)->NUM), Nil}) //Alterado para gravar o numero do documento sem os zeros - Vinicius Lança
			aAdd(aTitulo, {"E1_HIST", xcHist, Nil})
			aAdd(aTitulo, {"E1_OCORREN", "01", Nil}) //CONFORME MANUAL DO ITAU, 10=NAO PROTESTAR
			
			DbSelectArea("SE1")
			DbSetOrder(1)
			//MSExecAuto({|x,y| Fina040(x,y)},aTitulo,iIf(lFind,4,3))
			//ALTERADO POR Helimarf 11/10/2013
			MSExecAuto({|x,y| Fina040(x,y)},aTitulo,3)
			
			If lMSErroAuto
				lErro := .T.
				cFile := Dtos(dDataBase) + " - Título "+Alltrim(cNum)+".log"
				RotMens("FINA040 ERRO ...  ","","")
				
				MostraErro(cpath, cfile)
				lMsErroAuto := .F.
				lMSHelpAuto	:= .F.
			ELSE
				RotMens("FINA040 executado com sucesso ... " ,"","")
			Endif
			
		Else
			RotMens("SE1 encontrado - ERRO ... " + ALLTRIM((cAliasQry)->E1_FILIAL)+cCodCli+cLojaCli+cPrefix+cNum+cParcela+cTipo,"","")
		EndIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³GRAVA NA VIEW 'TT_I11_FLAG_VIEW' O REGISTRO IMPORTADO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lMsErroAuto
			cQueryINS := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) "
			cQueryINS += " VALUES ('TT_I08_TITULOS_RECEBER','E1_NUM','"+ALLTRIM((cAliasQry)->E1_NUM)+"','"+ALLTRIM((cAliasQry)->E1_FILIAL)+"')"
			TCSqlExec(cQueryINS)
			RotMens("Feito o INSERT na View TT_I11 ... " + E1_NUM ,"","")
		EndIf
	EndIF
	
	DbSelectARea(cAliasQry)
	DbSkip()
EndDo

DbSelectarea(cAliasQry)
DbcloseArea()

cFilAnt	:= cFilOld
If !lErro
	RotMens("Importação Finalizada com sucesso!","Aviso","2")
	//	MsgInfo("Importação concluída.","Aviso")
else
	RotMens("Ocorreram erros na importação. Consulte o log de erro em \logsiga\receber\.","Atenção","1")
	//	MsgBox("Ocorreram erros na importação. Consulte o log de erro em \logsiga\receber\.","Atenção")
endif

Return()
