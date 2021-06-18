#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"
#DEFINE cEnt CHR(13)+CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENI017   บAutor  ณDanilo Azevedo      บ Data ณ  28/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para importacao de produtos                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAltera็ใo ณAutor  ณJoni Fujiyama                  บ Data ณ  02/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina foi adaptada para rodar por schedule.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ATLPROD()

Private cFunName := PROCNAME()
If MsgYesNo("Esta rotina farแ a importa็ใo de Produtos. Deseja continuar?","Aten็ใo")
	Processa({||Importa()})
EndIf

Return()

//*************************************************************************************************//
// Rotina da execu็ใo por schedule				Autor: Joni Fujiyama			Data:02/07/2014			 //
//*************************************************************************************************//
User Function ATLPRODA()

Local lRotMens:=.F.
Private cFunName := PROCNAME()

RPCSetType(3)
Prepare Environment Empresa "00" Filial "1022" //EXECUTA NA EMPRESA 1022 GEN DEPOSITO SP

Private cTab := GETMV("GEN_FAT064") // "150" - 2015 - PRECO NOVO

//RotMens("Executando a rotina ==> " + cFunName,"","")
lRotMens := RotMens("Iniciando o Schedule...","","")
//cMail := "GENI017 Carga de Produtos - Processo iniciado "+dtoc(MsDate())+" - "+Time() + cEnt + cEnt
Importa()
lRotMens := RotMens("Fim do Schedule...","","")
Reset Environment

Return()

/**************************************************************************************************
Mostra a mensagem na tela ou no console			Autor: Joni Fujiyama		Data:02/07/2014
**************************************************************************************************/
Static Function RotMens(pTexto1,pTexto2,pTexto3,pTipo)

IF cFunName == "U_ATLPROD"
	DO CASE
		Case pTipo = "1"
			MSGBOX(pTexto1,pTexto2)
		Case pTipo = "2"
			MSGINFO(pTexto1,pTexto2)
		Case pTipo = "3"
			AVISO(pTexto1,pTexto2,pTexto3)
		Case pTipo = "4"
			ALERTA(pTexto1,pTexto2)
		Case pTipo = "5"
			Return AVISO(pTexto1,pTexto2,pTexto3)
	ENDCASE
ELSE
	IF cFunName == "U_ATLPRODA"
		Conout(pTexto1)
	ENDIF
ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณImporta   บAutor  ณDanilo Azevedo      บ Data ณ  28/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel pelo processamento da rotina                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Importa()

Local lErro   	:= .F.
Local cPath   	:= "\LogSiga\Produtos\"
Local cFile   	:= ""
Local cQuery 	:= Space(0)
Local _cTs		:= GetMv("GENA017TS")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ TRATAMENTO DE AREA, CURSO E DISCIPLINA ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
If chkfile("SZ6")
//tcsqlexec("DELETE FROM "+RetSqlName("SZ6")) //DISCIPLINAS
cAlias := GetNextAlias()
cQuery := "SELECT D.IDDISCIPLINACRM COD, D.DESCRICAO DESCRI, CD.IDCURSOCRM CURSO
cQuery += " FROM DBA_EGK.DISCIPLINACRM2 D
cQuery += " JOIN DBA_EGK.CURSOCRMDISCIPLINACRM2 CD ON D.IDDISCIPLINACRM = CD.IDDISCIPLINACRM
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
dbSelectArea(cAlias)
dbGoTop()
Do While !(cAlias)->(Eof())
cCod := strzero((cAlias)->COD,tamsx3("Z6_DISCIPLI")[1])
dbSelectArea("SZ6")
dbSetOrder(1)
If dbSeek(xFilial("SZ6")+cCod)
Reclock("SZ6",.F.)
Else
Reclock("SZ6",.T.)
SZ6->Z6_FILIAL := xFilial("SZ6")
SZ6->Z6_DISCIPLI := cCod
Endif
SZ6->Z6_DESC := alltrim((cAlias)->DESCRI)
SZ6->Z6_CURSO := strzero((cAlias)->CURSO,tamsx3("Z6_CURSO")[1])
msUnlock()
(cAlias)->(dbSkip())
Enddo
fErase(cAlias)
Endif

If chkfile("SZ5")
//tcsqlexec("DELETE FROM "+RetSqlName("SZ5")) //CURSO
cAlias := GetNextAlias()
cQuery := "SELECT C.IDCURSOCRM COD, C.DESCRICAO DESCRI, AC.IDAREACRM AREA
cQuery += " FROM DBA_EGK.CURSOCRM2 C
cQuery += " JOIN DBA_EGK.AREACRMCURSOCRM2 AC ON C.IDCURSOCRM = AC.IDCURSOCRM"
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
dbSelectArea(cAlias)
dbGoTop()
Do While !(cAlias)->(Eof())
cCod := strzero((cAlias)->COD,tamsx3("Z5_CURSO")[1])
dbSelectArea("SZ5")
dbSetOrder(1)
If dbSeek(xFilial("SZ5")+cCod)
Reclock("SZ5",.F.)
Else
Reclock("SZ5",.T.)
SZ5->Z5_FILIAL := xFilial("SZ5")
SZ5->Z5_CURSO := cCod
Endif
SZ5->Z5_DESC := (cAlias)->DESCRI
SZ5->Z5_AREA := strzero((cAlias)->AREA,tamsx3("Z5_AREA")[1])
msUnlock()
(cAlias)->(dbSkip())
Enddo
fErase(cAlias)
Endif

If chkfile("SZ7")
//tcsqlexec("DELETE FROM "+RetSqlName("SZ7")) //AREA
cAlias := GetNextAlias()
cQuery := "SELECT IDAREACRM COD, DESCRICAO DESCRI FROM DBA_EGK.AREACRM2"
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
dbSelectArea(cAlias)
dbGoTop()
Do While !(cAlias)->(Eof())
cCod := strzero((cAlias)->COD,tamsx3("Z7_AREA")[1])
dbSelectArea("SZ7")
dbSetOrder(1)
If dbSeek(xFilial("SZ7")+cCod)
Reclock("SZ7",.F.)
Else
Reclock("SZ7",.T.)
SZ7->Z7_FILIAL := xFilial("SZ7")
SZ7->Z7_AREA := cCod
Endif
SZ7->Z7_DESC := (cAlias)->DESCRI
msUnlock()
(cAlias)->(dbSkip())
Enddo
fErase(cAlias)
Endif
*/

Private lMSHelpAuto := .T. // para nao mostrar os erro na tela
Private lMSErroAuto := .F. // inicializa como falso, se voltar verdadeiro e'que deu erro

cAmbiente := upper(alltrim(GetEnvServer()))
cArqT := "TT_I03_PROD_ATLAS"
cArqLob := "DBA_EGK.ATUALIZA_TEXTOS_DE_OBRAS"
cTabLob := "TEXTOS_DE_OBRAS"
//TCSPExec(cArqLob) //EXECUTA A PROCEDURE PARA RESGATAR CAMPOS CLOB DA TABELA DE OBRAS NO ORACLE

cQry1 := "SELECT COLUMN_NAME COLUNA FROM ALL_TAB_COLS WHERE OWNER = 'TOTVS' and TABLE_NAME = '"+cArqT+"' AND COLUMN_NAME LIKE 'B5_%' ORDER BY INTERNAL_COLUMN_ID"
cAlias1 := Criatrab(Nil,.F.)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),cAlias1,.T.)
(cAlias1)->(dbGoTop())
aColunas := {}
Do While (cAlias1)->(!EOF())
	aAdd(aColunas,alltrim((cAlias1)->COLUNA))
	(cAlias1)->(dbSkip())
Enddo
fErase(cAlias1)

//tcSqlExec("UPDATE SB5_ATLAS SET B5_XPUBLIP = '0'")

Private cAlias := GetNextAlias()
cQuery := "SELECT * FROM "+cArqT
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
Count TO nTotReg// Conta Registro
dbSelectArea(cAlias)
dbGoTop()

//RODRIGO MOURAO - Altera็ใo para gravar apenas a data e hora da execu็ใo da rotina.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGRAVA NA VIEW 'TT_I11_FLAG_VIEW' O REGISTRO IMPORTADOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
cQueryINS := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL)
cQueryINS += " VALUES ('"+cArqT+"','B1_COD','9999','    ')
TCSqlExec(cQueryINS)
*/

/*
DbSelectArea("DA1")
DbSetOrder(1)
Private cAlias2 := GetNextAlias()
cQuery := "SELECT MAX(DA1_ITEM) ITEM FROM "+RetSqlName("DA1")+" WHERE DA1_CODTAB = '"+cTab+"' AND D_E_L_E_T_ <> '*'"
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias2, .F., .T.)
cItem := (cAlias2)->ITEM
*/
//CAMPOS MEMO DA TABELA SB5
/*
aMem := {}
aAdd(aMem,{'B5_XDESWEB', '1'})
aAdd(aMem,{'B5_XDIFERE', '2'})
aAdd(aMem,{'B5_XERRATA', '3'})
//aAdd(aMem,{'SERIE', '4'})
aAdd(aMem,{'B5_XSOBAUT', '5'})
aAdd(aMem,{'B5_XSUMARI', '6'})
*/

aSldOrig := {}
cCod := Space(0)
nTamCod := 8
nReg := 0

Do While !(cAlias)->(Eof())
	
	nReg++
	
	//cCod := padl((cAlias)->B1_COD,nTamCod,"0")
	
	If cCod = padl((cAlias)->B1_COD,nTamCod,"0") //DESCONSIDERAR REPETIDOS
		(cAlias)->(DbSkip())
		Loop
	Else
		cCod := padl((cAlias)->B1_COD,nTamCod,"0")
	Endif
	
	aProduto := {}

	DbSelectArea("SB1")
	DbSetOrder(1)
	If !DbSeek(xFilial("SB1")+cCod)
		nOpt := 3 //INCLUI
		aAdd(aProduto, {"B1_PESO", (cAlias)->B1_PESO					, Nil})
		aAdd(aProduto, {"B1_PESBRU", (cAlias)->B1_PESO					, Nil})
	Else
		nOpt := 4 //ATUALIZA
	Endif
	aAdd(aProduto, {"B1_COD", cCod									, Nil})
	aAdd(aProduto, {"B1_DESC", alltrim((cAlias)->B1_DESC)			, Nil})
	aAdd(aProduto, {"B1_TIPO", alltrim((cAlias)->B1_TIPO)			, Nil})
	aAdd(aProduto, {"B1_UM", alltrim((cAlias)->B1_UM)				, Nil})
	aAdd(aProduto, {"B1_LOCPAD", alltrim((cAlias)->B1_LOCPAD)		, Nil})
	//	aAdd(aProduto, {"B1_GRUPO", cValToChar((cAlias)->B1_GRUPO)		, Nil})
	aAdd(aProduto, {"B1_GRUPO", "8888"								, Nil})
	aAdd(aProduto, {"B1_ORIGEM", alltrim((cAlias)->B1_ORIGEM)		, Nil})
	aAdd(aProduto, {"B1_TNATREC", alltrim((cAlias)->B1_TNATREC)	, Nil})
	aAdd(aProduto, {"B1_MSBLQL", alltrim((cAlias)->B1_MSBLQL)	   	, Nil})
	aAdd(aProduto, {"B1_CODBAR", substr(alltrim((cAlias)->B1_CODBAR),1,12)		, Nil})
	aAdd(aProduto, {"B1_ISBN", alltrim((cAlias)->B1_ISBN)			, Nil})
	aAdd(aProduto, {"B1_POSIPI", alltrim((cAlias)->B1_POSIPI)		, Nil})
	aAdd(aProduto, {"B1_XSITOBR", alltrim((cAlias)->B1_XSITOBR)	, Nil})
	aAdd(aProduto, {"B1_XEMPRES", alltrim((cAlias)->B1_XEMPRES)	, Nil})
	aAdd(aProduto, {"B1_XIDMAE", padl((cAlias)->B1_XIDMAE,7,"0")	, Nil})
	aAdd(aProduto, {"B1_XIDTPPU", alltrim((cAlias)->B1_XIDTPPU)	, Nil})
	aAdd(aProduto, {"B1_XPERCRM", alltrim((cAlias)->B1_XPERCRM)	, Nil})
	aAdd(aProduto, {"B1_XPSITEG", alltrim((cAlias)->B1_XPSITEG)	, Nil})
	aAdd(aProduto, {"B1_CC", (cAlias)->B1_CC						, Nil})
	aAdd(aProduto, {"B1_TS", _cTs									, Nil}) //TES DE SAIDA = VENDA
	//aAdd(aProduto, {"B1_CODANT", (cAlias)->B1_PESO					, Nil})
	
	cFab := "0378128"
	cLoj := "07"
	aAdd(aProduto, {"B1_PROC", cFab, Nil}) //FORNECEDOR PADRAO
	aAdd(aProduto, {"B1_LOJPROC", cLoj, Nil}) //LOJA FORNECEDOR PADRAO
	
	MSExecAuto({|x,y| Mata010(x,y)},aProduto,nOpt)
	
	If lMSErroAuto
		lErro := .T.
		cFile := Dtos(dDataBase) + " - Produto "+Alltrim(cCod)+".log"
		
		MostraErro(cpath,cfile)
		lMsErroAuto := .F.
		lMSHelpAuto	:= .F.
	Else //ERRO NA SB1 IMPEDE O RESTANTE
		
		cIdProd := cValToChar((cAlias)->B1_COD) //CODIGO DO PRODUTO PARA GRAVAR NA FLAGVIEW
		
		DbSelectArea("SB5")
		DbSetOrder(1)
		If !DbSeek(xFilial("SB5")+cCod)
			nOpt := 3 //INCLUI
		Else
			nOpt := 4 //ATUALIZA
		Endif
		aSB5 := {}
		aAdd(aSB5,{"B5_FILIAL", xFilial("SB5"), Nil})
		aAdd(aSB5,{"B5_COD", cCod, Nil})
		
		For i := 1 to len(aColunas)
			lIgual := .T.
			If SB5->(FieldPos(aColunas[i])) > 0 //SE O CAMPO EXISTIR NA SB5
				
				//VERIFICA INCONSISTENCIA DE TIPOS DE DADOS, CONVERTE E GRAVA NA TABELA
				cTipoDic := valtype(&("SB5->"+aColunas[i]))
				cTipoTab := valtype(&("(cAlias)->"+aColunas[i]))
				If cTipoDic <> cTipoTab
					If cTipoDic = "C" //DICIONARIO = CARACTER
						If cTipoTab = "N" //VIEW = NUMERO
							aAdd(aSB5,{aColunas[i], cValToChar(&("(cAlias)->"+aColunas[i])), Nil})
						Endif
					ElseIf cTipoDic = "D" //DICIONARIO = DATA
						If cTipoTab = "C" //VIEW = CARACTER
							If At("/",&("(cAlias)->"+aColunas[i])) > 0 //SE TIVER SEPARADOR DE DATA
								aAdd(aSB5,{aColunas[i], CTOD(&("(cAlias)->"+aColunas[i])), Nil})
							Else
								aAdd(aSB5,{aColunas[i], STOD(&("(cAlias)->"+aColunas[i])), Nil})
							Endif
						Endif
					ElseIf cTipoDic = "N" //DICIONARIO = NUMERO
						If cTipoTab = "C" //VIEW = CARACTER
							aAdd(aSB5,{aColunas[i], val(&("(cAlias)->"+aColunas[i])), Nil})
						Endif
					Endif
				Else
					aAdd(aSB5,{aColunas[i], alltrim(&("(cAlias)->"+aColunas[i])), Nil})
				Endif
			Endif
		Next i
		/*
		For x := 1 to len(aMem)
		cQry := "SELECT * FROM "+cTabLob
		cQry += " WHERE IDOBRA = "+alltrim(cCod)+" AND LINHA <> ' ' AND TIPOCAMPO = '"+aMem[x][2]+"'
		cQry += " ORDER BY IDOBRA, NUMLINHA
		Private cAliasM := GetNextAlias()
		DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), cAliasM, .F., .T.)
		cMemo := Space(0)
		Do While !(cAliasM)->(EOF())
		cMemo += (cAliasM)->LINHA
		(cAliasM)->(dbSkip())
		Enddo
		dbCloseArea(cAliasM)
		fErase(cAliasM)
		cMemo := alltrim(cMemo)
		If !Empty(cMemo)
		aAdd(aSB5,{aMem[x][1],cMemo, Nil})
		Endif
		Next x
		*/
		MSExecAuto({|x,y| Mata180(x,y)},aSB5,nOpt)
		
		//ERRO NA SB5 NAO IMPEDE O RESTANTE
		If lMSErroAuto
			lErro := .T.
			cFile := Dtos(dDataBase) + " - Produto "+Alltrim(cCod)+" (complemento).log"
			
			MostraErro(cpath,cfile)
			lMsErroAuto := .F.
			lMSHelpAuto	:= .F.
		Endif
		
		/*
		dbSelectArea("DA1")
		dbSetOrder(1)
		nPrc := (cAlias)->PRECO
		If !dbSeek(xFilial("DA1")+cTab+cCod) //SE ENCONTRAR, ATUALIZA SOMENTE O PRECO
		cItem := Soma1(cItem)
		Reclock("DA1",.T.)
		DA1->DA1_FILIAL := xFilial("DA1")
		DA1->DA1_ITEM := cItem
		DA1->DA1_CODTAB := cTab
		DA1->DA1_CODPRO := cCod
		Else
		Reclock("DA1",.F.)
		Endif
		DA1->DA1_PRCVEN := nPrc
		DA1->DA1_ATIVO := "1"
		DA1->DA1_TPOPER := "4"
		DA1->DA1_QTDLOT := 999999.99
		DA1->DA1_INDLOT := "000000000999999.99"
		msUnlock()
		
		If !dbSeek(xFilial("DA1")+cTab+cCod)
		cFile := "Produto "+Alltrim(cCod)+" (tab.preco).log"
		MemoWrite(cPath+cFile,"Falha ao gravar na tabela DA1 (Pre็o)")
		Endif
		
		//CARREGA SALDO INICIAL - TABELA SB9 - EMPRESA ORIGEM
		cFiliOrig := alltrim((cAlias)->EMPORIG)
		If cFiliOrig <> "0000"
		cFilAnt := cFiliOrig
		cProd := Padr(cCod,tamsx3("B9_COD")[1]," ")
		dbSelectArea("SB9")
		dbSetOrder(1)
		If !dbSeek(xFilial("SB9")+cProd+"01") //SE NAO ENCONTRAR, GERA SALDO INICIAL
		nOp := 3
		aSldIni  := {}
		aAdd(aSldIni  ,{"B9_COD",cCod,Nil})
		aAdd(aSldIni  ,{"B9_LOCAL","01",Nil})
		aAdd(aSldIni  ,{"B9_QINI",Iif((cAlias)->BOM+(cAlias)->CONSIGNACAO > 0, (cAlias)->BOM+(cAlias)->CONSIGNACAO,0),Nil})
		MsExecAuto({|x,y,z|MATA220(x,y,z)},aSldIni,nOp)
		cFilAnt := "1022"
		If lMSErroAuto
		lErro := .T.
		cFile := Dtos(dDataBase) + " - Produto "+Alltrim(cCod)+" (saldo origem).log"
		MostraErro(cpath,cfile)
		lMsErroAuto := .F.
		lMSHelpAuto	:= .F.
		Endif
		Endif
		cFilAnt := "1022"
		Endif
		*/
		//CARREGA SALDO INICIAL ZERADO - TABELA SB9 - GEN
		cProd := Padr(cCod,tamsx3("B9_COD")[1]," ")
		nQt := 0
		For nAmz := 1 to 5
			cLoc := strzero(nAmz,2)
			dbSelectArea("SB9")
			dbSetOrder(1)
			If !dbSeek(xFilial("SB9")+cProd+cLoc) //SE NAO ENCONTRAR, GERA SALDO INICIAL
				nOp := 3
				aSldIni  := {}
				aAdd(aSldIni  ,{"B9_COD",cCod,Nil})
				aAdd(aSldIni  ,{"B9_LOCAL",cLoc,Nil})
				aAdd(aSldIni  ,{"B9_QINI",nQt,Nil})
				MsExecAuto({|x,y,z|MATA220(x,y,z)},aSldIni,nOp)
				If lMSErroAuto
					lErro := .T.
					cFile := Dtos(dDataBase) + " - Produto "+Alltrim(cCod)+" (saldo GEN).log"
					MostraErro(cpath,cfile)
					lMsErroAuto := .F.
					lMSHelpAuto	:= .F.
					(cAlias)->(DbSkip())
					Loop
				Endif
				nQt := 0
			Endif
		Next nAmz
		
	Endif
	
	tcSqlExec("UPDATE APP_ATLAS.PRODUTOS SET UPLOAD = ' ' WHERE B1_COD = '"+cValToChar((cAlias)->B1_COD)+"'")
	(cAlias)->(DbSkip())
EndDo

//cMail += "Processados "+cValToChar(nReg)+" itens."+ cEnt + cEnt
//cMail += "GENI017 Carga de Produtos - Processo finalizado "+dtoc(MsDate())+" - "+Time() + cEnt + cEnt
//AcSendMail(,,,"noreply@grupogen.com.br","danilo.azevedo@grupogen.com.br;rodrigo.mourao@grupogen.com.br",oemtoansi("Protheus - Cadastro de Produtos"),cMail,,,.F.)

If !lErro
	RotMens("Importa็ใo Finalizada com sucesso!","Aviso","2")
Else
	RotMens("Ocorreram erros na importa็ใo. Consulte o log de erro em "+cPath+".","Aten็ใo","1")
Endif

fErase(cAlias)

Return()
