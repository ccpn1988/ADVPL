#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

STATIC cNfOri := Space(TAMSX3("D2_DOC")[1])

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA024   º Autor ³ Danilo Azevedo     º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de Pre autorizacao.                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Estoque/Compras                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENA024()

Local aCores :={}

aAdd(aCores,{"ZB_SITUACA='1'", "BR_VERMELHO"})
//aAdd(aCores,{"ZB_SITUACA='2'", "BR_AZUL"    })
aAdd(aCores,{"ZB_SITUACA='3'", "BR_VERDE"   })

Private cCadastro := "Pre autorização"
Private aRotina := {}
aAdd(aRotina,{"Pesquisar",		"U_GENA024C",0,1})
aAdd(aRotina,{"Visualizar",		"U_GENA024C",0,2})
aAdd(aRotina,{"Incluir",		"U_GENA024C",0,3})
aAdd(aRotina,{"Alterar",		"U_GENA024C",0,4})
aAdd(aRotina,{"Excluir",		"U_GENA024C",0,5})
aAdd(aRotina,{"Importar CSV",	"U_GENA024I",0,3})
//aAdd(aRotina,{"Liberar",		"U_LIBPRE"	,4,0})
If Existblock("FAT013")
	aAdd(aRotina,{"Imprimir",		"U_FAT013",0,2})
Endif
aAdd(aRotina,{"Gerar Pre Nota",	"U_GENA024P",4,0})
aAdd(aRotina,{"Legenda",		"U_GENA024L",0,2})

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SZB"

dbSelectArea(cString)
//Set Filter to
//cFiltro := "SZB->ZB_SERIE = 'PRE'"// .and. SZB->ZB_COD <> space(tamsx3('ZB_COD')[1])"
//Set Filter to &cFiltro
dbSetOrder(1)

mBrowse( 6,1,22,75,cString,,,,,,aCores)

Set Filter to

Return()


User Function GENA024L

Local aCores:= {}

//ZB_SITUACA 1=Incluida;2=Aprovada;3=Finalizada
aAdd(aCores,{"BR_VERMELHO", "Incluida"})
//aAdd(aCores,{"BR_AZUL"    , "Liberada"})
aAdd(aCores,{"BR_VERDE"   , "Finalizada"})

BrwLegenda("Pre autorização","Legenda",aCores)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GENA024I  ºAutor  ³Danilo Azevedo      º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para importar arquivo .CSV de pre autorizacao.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³GEN - Estoque/Compras                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA024I()

cPerg := "GENA024"
PutSx1(cPerg, "01", "Cliente"	, "Cliente"	, "Cliente"	, "mv_ch1", "C", tamsx3("A1_COD")[1]	, 0, 0, "G","", "SA1", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Loja"		, "Loja"	, "Loja"	, "mv_ch2", "C", tamsx3("A1_LOJA")[1]	, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
//PutSx1(cPerg, "03", "Tipo"	, "Tipo"	, "Tipo"	, "mv_ch3", "N", 1						, 0, 2, "C","", "", "", "", "MV_PAR03","Troca Edição","Troca Edição","Troca Edição","","Defeito","Defeito","Defeito","Negociação Comercial","Negociação Comercial","Negociação Comercial","Compra indevida","Compra indevida","Compra indevida","Consignação","Consignação","Consignação")
PutSx1(cPerg, "03", "Tipo"		, "Tipo"	, "Tipo"	, "mv_ch3", "N", 1						, 0, 2, "C","", "", "", "", "MV_PAR03","Venda","Venda","Venda","","Consignação","Consignação","Consignação","","","","","","","","","")
PutSx1(cPerg, "04", "Armazem"	, "Armazem"	, "Armazem"	, "mv_ch4", "C", 2						, 0, 2, "C","", "", "", "", "MV_PAR04","","","","","","","","","","","","","","","","")
Pergunte(cPerg,.F.)
Private oGeraTxt
Private oLeTxt
Private aArea := GetArea()
Private cFile := Space(0)
Private cDest := Space(0)

DEFINE MSDIALOG oLeTxt TITLE "Pre Autorização" FROM 0,0 TO 175,370 PIXEL
@ 05,05 TO 55,180 PIXEL
@ 01,01 Say "Informe os parâmetros e selecione um arquivo a ser importado."
@ 60,10 BUTTON "Parâmetros" Size 40,12 PIXEL OF oLeTxt ACTION Pergunte(cPerg,.T.)
@ 60,52 BUTTON "Arquivo" Size 40,12 PIXEL OF oLeTxt ACTION (cFile := cGetFile("Arquivos CSV(*.csv) |*.csv" , "Seleção de Arquivo" , 0 , "" , .T. , GETF_LOCALHARD))
@ 60,94 BUTTON "Cancelar" SIZE 40,12 PIXEL OF oLeTxt ACTION Close(oLeTxt)
@ 60,136 BUTTON "OK" SIZE 40,12 PIXEL OF oLeTxt ACTION Processa({|| GENA024A()},"Processando...")

ACTIVATE MSDIALOG oLeTxt CENTER

Return()


Static Function GENA024A()

Local nOpc 		:= 0
Local _cAlias	:= GetNextAlias()
Local i			:= 0
Local j			:= 0

Private aCabec	:= {}
Private aItens	:= {}
Private aLinha	:= {}
Private cHash 	:= Space(tamsx3("ZB_HASHMD5")[1])

If !File(cFile)
	MsgBox("O arquivo "+alltrim(cFile)+" nao pode ser aberto! Verifique os parametros.","Atenção")
	Return()
Endif

If Empty(MV_PAR01) .or. Empty(MV_PAR02) .or. Empty(MV_PAR03)
	MsgBox("Um ou mais parâmetros não foi informado. Tente novamente.","Atenção")
	Return()
Endif

Close(oLeTxt)

//ABRE ARQUIVO E POSICIONA NO INICIO
FT_FUSE(cFile)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()

dbSelectArea("SZB")
dbOrderNickName("MD5")
cHash := MD5File(cFile)
If Empty(cHash)
	MsgBox("Verifique se o arquivo a ser importação está sendo utilizado por outro programa.","Atenção")
	Return()	
ElseIf dbSeek(cHash)
	MsgBox("Este arquivo já foi processado e gerou a pre autorização "+alltrim(SZB->ZB_COD)+".","Atenção")
	Return()
Endif

//E=Troca Edicao;D=Defeito;N=Neg.Comercial;I=Compra Indevida;C=Consignacao
cTp := Space(1)
If MV_PAR03 = 1
	cTp := "V"
ElseIf MV_PAR03 = 2
	cTp := "C"
Endif

aAdd(aCabec,{'ZB_TIPO'		,cTp					,NIL})
aAdd(aCabec,{'ZB_EMISSAO'	,dDataBase				,NIL})
aAdd(aCabec,{'ZB_CLIENTE'	,MV_PAR01				,NIL})
aAdd(aCabec,{'ZB_LOJA'		,MV_PAR02				,NIL})
aAdd(aCabec,{'ZB_HASHMD5'	,cHash					,NIL})
aAdd(aCabec,{'ZB_SITUACA'	,"1"					,NIL})
aAdd(aCabec,{'ZB_COND'		,Posicione("SA1",1,xFilial("SA1")+MV_PAR01+MV_PAR02,"A1_COND")	,NIL})

Do While !FT_FEOF()
	
	IncProc()
	aLinIt := {}
	
	cLinha := FT_FREADLN()
	If substr(cLinha,len(cLinha),1) <> ";" //TRATAMENTO PARA ARQUIVO SEM ; NO FINAL DA LINHA
		cLinha += ";"
	Endif
	
	nPos := At(";",cLinha)
	cVar := substr(cLinha,1,nPos-1)
	cProd := alltrim(cVar)
	cLinha := alltrim(Substr(cLinha,nPos+1,len(cLinha)))
	
	If len(cProd) = 13 //ISBN
		If Select(_cAlias) > 0
			dbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		EndIf
		
		_cQry := "SELECT B1_COD FROM "+RetSqlName("SB1")
		_cQry += " WHERE B1_FILIAL = '"+xFilial("SB1")+"' AND B1_ISBN = '"+cProd+"'" //PESQUISA POR ISBN
		_cQry += " AND B1_XIDTPPU in ('11','10','7','6','12','2','18','1','8','13')" //SOMENTE IMPRESSO (FISICO)
		_cQry += " AND D_E_L_E_T_ = ' '"
		dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQry), _cAlias, .F., .T.)
		If (_cAlias)->(!EOF())
			cVar := (_cAlias)->B1_COD
		Endif
		
		If Select(_cAlias) > 0
			dbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		EndIf
	ElseIf Len(cProd) < 13
		If Select(_cAlias) > 0
			dbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		EndIf
		
		_cQry := "SELECT B1_COD FROM "+RetSqlName("SB1")
		_cQry += " WHERE B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+cProd+"'" //PESQUISA POR CODIGO
		_cQry += " AND B1_XIDTPPU in ('11','10','7','6','12','2','18','1','8','13')" //SOMENTE IMPRESSO (FISICO)
		_cQry += " AND D_E_L_E_T_ = ' '"
		dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQry), _cAlias, .F., .T.)
		If (_cAlias)->(!EOF())
			cVar := (_cAlias)->B1_COD
		Else
			MsgBox("Produto "+cProd+" não localizado.","Atenção")
			FT_FSKIP()
			Loop
		Endif
		
		If Select(_cAlias) > 0
			dbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		EndIf
		
	Endif
	
	cCodPro := alltrim(cVar)
	
	AADD(aLinIt,{"ZC_PROD",		cVar,					Nil})
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+cVar)
	AADD(aLinIt,{"ZC_UM",		SB1->B1_UM,				Nil})
	If Empty(MV_PAR04)
		AADD(aLinIt,{"ZC_LOCAL",	SB1->B1_LOCPAD,			Nil})
	Else
		AADD(aLinIt,{"ZC_LOCAL",	MV_PAR04,				Nil})
	Endif
	AADD(aLinIt,{"ZC_ISBN",		SB1->B1_ISBN,			Nil})
	AADD(aLinIt,{"ZC_DESCPRO",	SB1->B1_DESC,			Nil})
	
	nPos := At(";",cLinha)
	cVar := strtran(substr(cLinha,1,nPos-1),".","")
	cLinha := alltrim(Substr(cLinha,nPos+1,len(cLinha)))
	
	If Select(_cAlias) > 0
		dbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	EndIf
	
	If cTp = "C" //DEVOLUCAO DE CONSIGNACAO CONSIDERA SB6 E SD2
		_cQry := "SELECT B6_SALDO SALDO, B6_IDENT IDENT, D2_ITEM ITEM, D2_PRCVEN PRCVEN, D2_PRUNIT PRUNIT, B6_DOC DOC, B6_SERIE SERIE, D2_DESC DESCO, D2_EMISSAO EMISSAO
		_cQry += " FROM "+RetSqlName("SB6")+" B6 JOIN "+RetSqlName("SD2")+" D2
		_cQry += " ON B6_CLIFOR = D2_CLIENTE AND B6_LOJA = D2_LOJA AND B6_DOC = D2_DOC AND B6_SERIE = D2_SERIE AND B6_PRODUTO = D2_COD AND B6_LOCAL = D2_LOCAL
		_cQry += " WHERE B6_FILIAL = '"+xFilial("SB6")+"'
		_cQry += " AND D2_FILIAL = '"+xFilial("SD2")+"'
		_cQry += " AND B6_PRODUTO = '"+cCodPro+"'
		_cQry += " AND B6_CLIFOR = '"+MV_PAR01+"'
		_cQry += " AND B6_LOJA = '"+MV_PAR02+"'
		_cQry += " AND B6_PODER3 = 'R'
		_cQry += " AND B6_TIPO = 'E'
		_cQry += " AND B6_SALDO > 0
		_cQry += " AND B6.D_E_L_E_T_ = ' '
		_cQry += " AND D2.D_E_L_E_T_ = ' '
		_cQry += " ORDER BY B6_EMISSAO
	Else //DEVOLUCAO DE VENDA CONSIDERA SD2
		_cQry := "SELECT D2_QUANT-D2_QTDEDEV SALDO, ' ' IDENT, D2_ITEM ITEM, D2_PRCVEN PRCVEN, D2_PRUNIT PRUNIT, D2_DOC DOC, D2_SERIE SERIE, D2_DESC DESCO, D2_EMISSAO EMISSAO
		_cQry += " FROM "+RetSqlName("SD2")+" D2
		_cQry += " WHERE D2_FILIAL = '"+xFilial("SD2")+"'
		_cQry += " AND D2_COD = '"+cCodPro+"'
		_cQry += " AND D2_CLIENTE = '"+MV_PAR01+"'
		_cQry += " AND D2_LOJA = '"+MV_PAR02+"'
		_cQry += " AND D2_TIPO = 'N'
		_cQry += " AND D2_QUANT-D2_QTDEDEV > 0
		_cQry += " AND D_E_L_E_T_ = ' '
		_cQry += " ORDER BY D2_EMISSAO
	Endif
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQry), _cAlias, .F., .T.)
	nQtdImp := val(cVar) //QTD INFORMADA NO ARQUIVO
	nSaldo := 0 //ACUMULADOR PARA SALDO NA SB6
	aEnvCli := {} //PRODUTOS ENVIADOS AO CLIENTE
	Do While (_cAlias)->(!EOF()) .AND. nSaldo < nQtdImp
		aItEnv := {} //ITEM ENVIADO AO CLIENTE
		aAdd(aItEnv,(_cAlias)->SALDO)			//1
		aAdd(aItEnv,(_cAlias)->IDENT)			//2
		aAdd(aItEnv,(_cAlias)->ITEM)			//3
		aAdd(aItEnv,(_cAlias)->PRCVEN)			//4
		aAdd(aItEnv,(_cAlias)->PRUNIT)			//5
		aAdd(aItEnv,(_cAlias)->DOC)				//6
		aAdd(aItEnv,(_cAlias)->SERIE)			//7
		aAdd(aItEnv,(_cAlias)->DESCO)			//8
		aAdd(aItEnv,STOD((_cAlias)->EMISSAO))	//9
		aAdd(aEnvCli,aItEnv)
		
		nSaldo += (_cAlias)->SALDO
		(_cAlias)->(dbSkip())
	Enddo
	
	aLinTmp := aClone(aLinIt)
	
	If nSaldo < nQtdImp
		MsgAlert("O saldo informado para o produto "+cCodPro+" é maior do que o disponível no sistema. Será considerado o saldo disponível.","Atenção")
	Endif
	
	For i := 1 to len(aEnvCli)
		If nQtdImp <= aEnvCli[i][1] //SE A QTD DO ARQUIVO FOR MENOR OU IGUAL AO ENVIADO AO CLIENTE
			AADD(aLinIt,{"ZC_QUANT"		,nQtdImp,				Nil})
			i := len(aEnvCli)
		Else
			AADD(aLinIt,{"ZC_QUANT"		,aEnvCli[i][1],			Nil})
			nQtdImp -= aEnvCli[i][1]
		Endif
		AADD(aLinIt,{"ZC_IDENTB6"	,aEnvCli[i][2],	Nil})
		AADD(aLinIt,{"ZC_ITEMORI"	,aEnvCli[i][3],	Nil})
		AADD(aLinIt,{"ZC_VUNIT"		,aEnvCli[i][4],	Nil})
		AADD(aLinIt,{"ZC_PRCTAB"	,aEnvCli[i][5],	Nil})
		AADD(aLinIt,{"ZC_VALDESC"	,aEnvCli[i][5]-aEnvCli[i][4],	Nil})
		AADD(aLinIt,{"ZC_NFORI"		,aEnvCli[i][6],	Nil})
		AADD(aLinIt,{"ZC_SERIORI"	,aEnvCli[i][7],	Nil})
		AADD(aLinIt,{"ZC_DESC"		,aEnvCli[i][8],	Nil})
		
		aAdd(aItens,aLinIt)
		aLinIt := aClone(aLinTmp)
	Next i
	
	If Select(_cAlias) > 0
		dbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	EndIf
	FT_FSKIP()
EndDo

BEGIN TRANSACTION

//GRAVA CABECALHO
RecLock("SZB",.T.)
For i := 1 to len(aCabec)
	If FieldPos(aCabec[i][1])>0
		SZB->&(aCabec[i][1]) := aCabec[i][2]
	Endif
Next i
cPre := GETSXENUM("SZB","ZB_COD")
SZB->ZB_FILIAL := xFilial("SZB")
SZB->ZB_COD := cPre
MsUnlock()

//GRAVA ITENS
For i := 1 to len(aItens)
	RecLock("SZC",.T.)
	For j := 1 to len(aItens[i])
		If FieldPos(aItens[i][j][1])>0
			cTipoDic := valtype(&("SZC->"+aItens[i][j][1]))
			If cTipoDic = "N" .and. valtype(aItens[i][j][2]) = "C"
				SZC->&(aItens[i][j][1]) := Transform(aItens[i][j][2],PesqPict("SZC",aItens[i][j][1]))
			Else
				SZC->&(aItens[i][j][1]) := aItens[i][j][2]
			Endif
		Endif
	Next j
	SZC->ZC_TOTAL 	:= SZC->ZC_QUANT*ZC_VUNIT
	SZC->ZC_FILIAL 	:= xFilial("SZC")
	SZC->ZC_COD 	:= cPre
	SZC->ZC_ITEM 	:= strzero(i,tamsx3("ZC_ITEM")[1])
	MsUnlock()
Next i

END TRANSACTION

RestArea(aArea)

ConfirmSX8()

SZB->(DbSetOrder(1))
If SZB->(DbSeek(xFilial("SZC")+cPre))
	MsgInfo("Gerada a pre autorização: "+cPre)
Endif

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±

±±ºFuncao    ³GENA024C  ºAutor  ³Danilo Azevedo      º Data ³  15/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executa tela modelo 3.                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENA024C(cAlias,nReg,nOpcx)

Local cTitulo := "Pre Autorização"
Local cAliasE := "SZB"
Local cChaveE := "ZB_COD"
Local cFiliE  := "ZB_FILIAL"
Local cAliasG := "SZC"
Local cChaveG := "ZC_COD"
Local cFiliG  := "ZC_FILIAL"
Local cLinOk  := "AllwaysTrue()"
Local cTudOk  := "AllwaysTrue()"
Local cFieldOk:= "AllwaysTrue()"
Local aCposE  := {}
Local nUsado, nX  := 0
Local NJ,NI,k

cChav := "SZB->ZB_FILIAL+SZB->ZB_COD" //CAMPO CHAVE TABELA ENCHOICE
cRelac := "ALLTRIM(SZC->ZC_COD) == ALLTRIM(SZB->ZB_COD)" //RELACIONAMENTO ENTRE AS TABELAS
bCond	:= {|| &(cRelac)} //RELACIONAMENTO ENTRE AS TABELAS

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcoes de acesso para a Modelo 3                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case nOpcx==3; nOpcE:=3 ; nOpcG:=3    // 3 - "INCLUIR"
	Case nOpcx==4; nOpcE:=3 ; nOpcG:=3    // 4 - "ALTERAR"
	Case nOpcx==2; nOpcE:=2 ; nOpcG:=2    // 2 - "VISUALIZAR"
	Case nOpcx==5; nOpcE:=2 ; nOpcG:=2	   // 5 - "EXCLUIR"
EndCase

dbSelectArea(cAliasE)
RegToMemory(cAliasE,(nOpcx==3))


//REGRA ESPECIFICA PARA PRE AUTORIZACAO
/*
If nOpcx==4 .and. SZB->ZB_SITUACA = "2"
If !MsgYesNo("Esta Pre Autorização já foi aprovada. Caso seja alterada, será necessária nova aprovação. Deseja prosseguir?","Atenção")
Return()
Endif
Else
*/
If nOpcx>=4 .and. SZB->ZB_SITUACA = "3"
	MsgBox("Esta Pre Autorização foi finalizada e não é possível alterá-la ou excluí-la.","Atenção")
	Return()
Endif
//FIM DA REGRA ESPECIFICA

dbSelectArea(cAliasG)

nUsado:=0
DbSelectArea("SX3")
dbSetOrder(1)
dbGoTop()
DbSeek(cAliasG)
aHeader:={}
/*
Do While !Eof() .And. (X3_ARQUIVO == cAliasG)
	If Alltrim(X3_CAMPO)==cChaveG
		dbSkip()
		Loop
	Endif
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
		nUsado++
		Aadd(aHeader,{ Trim(X3_TITULO) , X3_CAMPO   , X3_PICTURE,;
		X3_TAMANHO , X3_DECIMAL , X3_VALID  ,;
		X3_USADO   , X3_TIPO    , X3_ARQUIVO,;
		X3_CONTEXT } )
	Endif
	DbSkip()
Enddo
*/


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se for inclusao, nao alimenta as variaveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSeek	:= ""
cWhile	:= ""
If !nOpcx==3
	cSeek := SZB->ZB_FILIAL+SZB->ZB_COD 
	cWhile := "SZC->ZC_FILIAL + SZC->ZC_COD"
EndIf

FillGetDados(nOpcx,"SZC",1,cSeek,{|| &cWhile})

// Alterado para FwSx3Util
/*
aCamposE := {}
DbSeek(cAliasE)
Do While !EOF() .and. (X3_ARQUIVO == cAliasE)
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
		Aadd(aCamposE,{ Trim(X3_TITULO) , X3_CAMPO   , X3_PICTURE,;
		X3_TAMANHO , X3_DECIMAL , X3_VALID  ,;
		X3_USADO   , X3_TIPO    , X3_ARQUIVO,;
		X3_CONTEXT } )
		Aadd(aCposE,Trim(X3_CAMPO))
	Endif
	DbSkip()
Enddo
*/
aCamposE := FWSX3Util():GetAllFields( cAliasE, .F. )
aCposE 	 := aCamposE  

/*
If nOpcx == 3
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For _ni:=1 to nUsado
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
Else
	aCols := {}
	DbSelectArea(cAliasG)
	DbSetOrder(1)
	If dbSeek(xFilial(cAliasG)+&(cChav))
		
		Do While !Eof() .And. &cRelac //CHAVE ENTRE TABELAS
			AADD(aCols,Array(nUsado+1))
			For _ni:=1 to nUsado
				aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
			Next
			aCols[Len(aCols),nUsado+1]:=.F.
			DbSkip()
		Enddo
		
	Else
		aCols:={Array(nUsado+1)}
		aCols[1,nUsado+1]:=.F.
		n:=1
		For _ni:=1 to nUsado
			aCols[n,_ni]:=CriaVar(aHeader[_ni,2])
		Next
	Endif
	
Endif
*/
If Len(aCols)>0
	
	DbSelectArea(cAliasG)
	DbSetOrder(1)
	
	lDataOk := .F.
	
	lRetMod3 := Modelo3(cTitulo, cAliasE, cAliasG, aCposE, cLinOk, cTudOk, nOpcE, nOpcG,cFieldOk,,,,,,,210)
	
	DbSelectArea(cAliasG)
	DbSetOrder(1)
	
	If lRetMod3
		If nOpcx == 3  // Inclusao
			
			_nCont := 0
			For NI := 1 to Len(aCols)
				If aCols [nI,Len(aHeader)+1] .Or. Empty(aCols[NI,2])
					NI++
					Loop
				EndIf
				_nCont := _nCont + 1
				DbSelectArea(cAliasG)
				DbSetOrder(1)
				RecLock(cAliasG,.T.)
				(cAliasG)->&(cFiliG) := xFilial(cAliasG) //FILIAL TABELA GETDADOS
				For NJ := 1 to len(aHeader)
					FieldPut(FieldPos(Trim(aHeader[NJ,2])),aCols[NI,NJ])
				Next NJ
				(cAliasG)->&(cChaveG) := M->&(cChaveE) //CHAVE TABELA GETDADOS
				MsUnLock()
			Next NI
			
			DbSelectArea(cAliasE)
			DbSetOrder(1)
			RecLock(cAliasE,.T.)
			(cAliasE)->ZB_FILIAL := xFilial(cAliasE) //FILIAL TABELA ENCHOICE
			For k := 1 to len(aCamposE)
				If !(aCamposE[k] == 'ZB_FILIAL')
				//FieldPut( FieldPos(aCamposE[k][2]) , &("M->"+aCamposE[k][2]) )
					FieldPut( FieldPos(aCamposE[k]) , &("M->"+aCamposE[k]) )
				EndIf	
			Next k
			MsUnLock()
			ConfirmSx8()
			
		ElseIf nOpcx == 4  // Alteracao
			
			/*
			//REGRA ESPECIFICA PARA PRE AUTORIZACAO
			If SZB->ZB_SITUACA = "2" //VOLTA A LIBERACAO
			M->ZB_SITUACA := "1"
			Endif
			//FIM DA REGRA ESPECIFICA
			*/
			
			_nCont := 0
			For NI := 1 to len(aCols)
				DbSelectArea(cAliasG)
				DbSetOrder(1)
				DbGoTop()
				If DbSeek(xFilial(cAliasG)+M->&cChaveE+aCols[NI][1]) //CHAVE TABELA GETDADOS
					RecLock(cAliasG,.F.)
					If aCols[nI,Len(aHeader)+1]
						DbDelete()
						MsunLock()
						NI++
						Loop
					Endif
				Else
					If aCols [nI,Len(aHeader)+1] .Or. Empty(aCols[NI,2])
						NI++
						Loop
					Else
						RecLock(cAliasG,.T.)
						(cAliasG)->(cFiliG) := xFilial(cAliasG) //FILIAL TABELA GETDADOS
						(cAliasG)->(cChaveG) := M->(cChaveE) //CHAVE TABELA GETDADOS
					Endif
				Endif
				_nCont++
				//DbSelectArea(cAliasG)
				For NJ := 1 to len(aHeader)
					FieldPut(FieldPos(Trim(aHeader[NJ,2])),aCols[NI,NJ])
				Next NJ
				
				MsUnLock()
			Next NI
			
			DbSelectArea(cAliasE)
			DbSetOrder(1)
			RecLock(cAliasE,.F.)
			(cAliasE)->ZB_FILIAL := xFilial(cAliasE) //FILIAL TABELA ENCHOICE
			For k := 1 to len(aCamposE)
				//FieldPut( FieldPos(aCamposE[k][2]) , &("M->"+aCamposE[k][2]) )
				FieldPut( FieldPos(aCamposE[k]) , &("M->"+aCamposE[k]) )
			Next k
			
			MsUnLock()
			
		ElseIf nOpcx == 5  // Exclusao
			
			BEGIN TRANSACTION
			
			DbSelectArea(cAliasE)
			DbSetOrder(1)
			DbGoTop()
			DbSeek(xFilial(cAliasE)+M->&(cChaveE),.F.)
			RecLock(cAliasE,.F.)
			DbDelete()
			MsUnLock()
			
			DbSelectArea(cAliasG)
			DbSetOrder(1)
			DbGoTop()
			DbSeek(xFilial(cAliasG)+M->&(cChaveE),.F.)
			Do While !Eof() .And. &cFiliG = xFilial(cAliasG) .and. &cRelac
				RecLock(cAliasG,.F.)
				DbDelete()
				MsUnLock()
				DbSkip()
			Enddo
			
			END TRANSACTION
			
		EndIf
	Else
		RollbackSx8()
	EndIf
EndIf

Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LibCad   ³ Autor ³ Danilo Azevedo        ³ Data ³ 10/12/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Liberacao de cadastros de Cliente/Fornecedor - Grupo GEN   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Grupo GEN                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LibPre()

Private _cTab := "SZB"

cNivel1 := GetMv("GENA024N1") //NIVEL 1 = Dir.Comercial
cNivel2 := GetMv("GENA024N2") //NIVEL 2 = Financeiro
cNivel3 := GetMv("GENA024N3") //NIVEL 3 = Diretoria
cCodVend := Posicione("SA3",7,xFilial("SA3")+RetCodUsr(),"A3_COD")

If !RetCodUsr()$cNivel1+cNivel2+cNivel3 .and. Empty(cCodVend)
	MsgBox("Você não possui permissão para utilizar esta rotina.","Atenção")
	Return()
Endif

lEnd := .F.
Processa( {|lEnd| _MontaTRB() } , "Processando" , "Selecionando registros..." , .t. )

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³_MontaTRB ºAutor  ³Danilo Azevedo      º Data ³  10/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta tela principal tipo MarkBrowse.                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _MontaTRB()

Local x,i

_aStru := {}
_aCampos := {}
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(_cTab)

AAdd( _aStru , { "OK" , "C" , 02 , 0 } )
AADD( _aCampos , { "OK" , "" , "@!" , "02" , "0" } )
cCampos := Space(0)

//MONTA TRB COM ESTRUTURA DA TABELA

// Alterado para FWSX3UTIL
aSx3 := FWSX3Util():GetAllFields( _cTab, .F. )
For x := 1 To Len(aSx3)
	If X3USO(Posicione("SX3",2,aSx3[x],"X3_USADO"),nModulo) .And. cNivel >= Posicione("SX3",2,aSx3[x],"X3_NIVEL") .And. FWSX3Util():GetFieldType(aSx3[x]) <> "M" .and. Posicione("SX3",2,aSx3[x],"X3_CONTEXT") <> "V"
		AAdd( _aStru , { aSx3[x], FWSX3Util():GetFieldType(aSx3[x]), TamSx3(aSx3[x])[1], TamSx3(aSx3[x])[2] } )
		AAdd( _aCampos, { aSx3[x], FWSX3Util():GetDescription( aSx3[x] ), Posicione("SX3",2,aSx3[x],"X3_PICTURE"), TamSx3(aSx3[x])[1], TamSx3(aSx3[x])[2] } )
		cCampos += alltrim(aSx3[x]) + ", "

	EndIf
Next()
/*
Do While !Eof() .And. X3_ARQUIVO == _cTab
	If X3USO(X3_USADO,nModulo) .And. cNivel >= X3_NIVEL .And. X3_TIPO <> "M" .and. X3_CONTEXT <> "V"
		AAdd( _aStru , { X3_CAMPO, X3_TIPO, X3_TAMANHO, X3_DECIMAL } )
		AAdd( _aCampos, { X3_CAMPO, X3_TITULO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL } )
		cCampos += alltrim(X3_CAMPO) + ", "
	Endif
	SX3->(dbSkip())
Enddo
*/

//_cArq   := Criatrab(_aStru,.T.)
//_cIndex := Criatrab(Nil,.F.)

dbSelectArea(_cTab)
dbSetOrder(1)
_cChave := alltrim(Posicione("SIX",1,_cTab,"CHAVE"))
_cChave := Substr(_cChave,AT("+",_cChave)+1,len(_cChave))
//DbUseArea(.t.,,_cArq,"TRB")
//Indregua("TRB",_cIndex,_cChave,,,"Selecionando Registros...")

TRB := FWTemporaryTable():New( "TRB" )
TRB:SetFields(_aStru)        
TRB:AddIndex("1", Separa(_cChave,"+"))
TRB:Create()

cCampos := substr(cCampos,1,len(cCampos)-2)

//VERIFICA QUAIS NIVEIS O USUARIO PERTENCE
/*
cNiv := Space(0)
If RetCodUsr()$cNivel1
cNiv += "'1'"
Endif
If RetCodUsr()$cNivel2
cNiv += "'2'"
Endif
If RetCodUsr()$cNivel3
cNiv += "'3'"
Endif
*/

cQry := "SELECT "+cCampos
cQry += " FROM "+RetSqlName(_cTab)+" TAB
cQry += " JOIN "+RetSqlName("SA1")+" A1 ON ZB_CLIENTE = A1_COD and ZB_LOJA = A1_LOJA
cQry += " WHERE "+Substr(_cTab,2,2)+"_SITUACA = '1'
If !(RetCodUsr()$cNivel1)
	cQry += " AND A1.A1_VEND = '"+cCodVend+"'
Endif
cQry += " AND A1.D_E_L_E_T_ <> '*'
cQry += " AND TAB.D_E_L_E_T_ <> '*'
cQry += " ORDER BY "+_cChave

If Select("QRY") > 0
	QRY->(DbCloseArea())
EndIf
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'QRY', .F., .T.)

QRY->(dbGoTop())

If QRY->(!Eof())
	While QRY->(!Eof())
		TRB->(RecLock("TRB",.T.))
		For i := 2 to len(_aStru)
			If _aStru[i][2] = "D" //CAMPO TIPO DATA
				TRB->&(_aStru[i][1]) := stod(QRY->&(_aStru[i][1]))
			Else
				TRB->&(_aStru[i][1]) := QRY->&(_aStru[i][1])
			Endif
		Next i
		TRB->(MsUnLock())
		QRY->(DbSkip())
	End
	
	TRB->(DbGoTop())
	
	@ 200,001 TO 600,550 DIALOG oDlg2 TITLE "Seleção de Cadastros para Liberação"
	@ 010,010 TO 170,270 BROWSE "TRB" FIELDS _aCampos MARK "OK" object _oMark
	
	@ 18,05 BUTTON "Fechar"			SIZE 45,15 ACTION Close(oDlg2)
	@ 18,20 BUTTON "Marcar Tudo"	SIZE 45,15 ACTION Marca()
	@ 18,35 BUTTON "Desmarcar Tudo"	SIZE 45,15 ACTION Desmarca()
	@ 18,50 BUTTON "Liberar"  		SIZE 45,15 ACTION LibCad()
	
	ACTIVATE DIALOG oDlg2 CENTERED
	
Else
	MsgInfo("Não foram encontrados registros aguardando sua liberação.","Atenção")
Endif

TRB->(DbCloseArea())
FErase(_cArq+".DBF")
FErase(_cIndex+OrdBagExt())

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LIBCAD    ºAutor  ³Danilo Azevedo      º Data ³  10/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento da rotina principal                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LibCad()

Close(oDlg2)

ProcRegua(TRB->(RecCount()))

nLib := 0
TRB->(DbGoTop())
While TRB->(!Eof())
	If TRB->(Marked("OK"))
		nLib++
	Endif
	TRB->(DbSkip())
End
TRB->(DbGoTop())

If !MsgYesNo("Confirma a liberação de "+cValToChar(nLib)+" registro(s)?","Confirma")
	Return()
Endif

While TRB->(!Eof())
	IncProc()
	If TRB->(Marked("OK"))
		dbSelectArea(_cTab)
		dbSetOrder(1)
		
		If dbSeek(xFilial(_cTab)+TRB->(ZB_COD))
			RecLock(_cTab,.F.)
			SZB->ZB_SITUACA := soma1(SZB->ZB_SITUACA)
			MsUnlock()
		Endif
		
	EndIf
	TRB->(DbSkip())
End

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Marca     ºAutor  ³Danilo Azevedo      º Data ³  10/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Seleciona todos os registros apresentados na tela.          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Marca()

_cMarca:=GetMark()

DbSelectArea("TRB")
ProcRegua( TRB->(RecCount()) )
DbGoTop()
While !Eof()
	If !Marked("OK")
		Reclock("TRB",.F.)
		TRB->OK := _cMarca
		MsUnlock()
	EndIf
	DbSkip()
End
DbGoTop()
_oMark:oBrowse:Refresh()

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³DesMarca  ºAutor  ³Danilo Azevedo      º Data ³  10/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Limpa a selecao de todos os registros apresentados na tela. º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function DesMarca()

DbSelectArea("TRB")
ProcRegua( TRB->(RecCount()) )
DbGoTop()
While !EOF()
	If Marked("OK")
		Reclock("TRB",.F.)
		TRB->OK := ThisMark()
		MsUnlock()
	EndIf
	DbSkip()
End
DbGoTop()
_oMark:oBrowse:Refresh()

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA024P  ºAutor  ³Danilo Azevedo      º Data ³  18/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para gerar pre nota a partir de uma pre autorizacao  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³GEN - Faturamento                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User function GENA024P()

Local cCodPre   := SZB->ZB_COD
Local _cAliPre  := GetNextAlias()
Local _cAliPre1 := GetNextAlias()
Local _cDocImp  := SZB->ZB_DOC
Local _cFormul  := SZB->ZB_FORMUL

If Select(_cAliPre) > 0
	dbSelectArea(_cAliPre)
	(_cAliPre)->(dbCloseArea())
EndIf

_cQry := "SELECT COUNT(*) QTD FROM "+RetSqlName("SF1")+" F1
_cQry += " WHERE F1_FILIAL = '"+xFilial("SF1")+"'
_cQry += " AND F1_DOC = '"+SZB->ZB_DOC+"'
_cQry += " AND F1_SERIE = '"+SZB->ZB_SERIE+"'
_cQry += " AND F1_FORNECE = '"+SZB->ZB_CLIENTE+"'
_cQry += " AND F1_LOJA = '"+SZB->ZB_LOJA+"'
_cQry += " AND D_E_L_E_T_ = ' '
dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQry), _cAliPre, .F., .T.)

If (_cAliPre)->QTD > 0
	MsgAlert("Já existe uma Pre nota ou Documento de Entrada com esse número e série para este cliente.","Erro")
	Return()
Endif

If SZB->ZB_SITUACA <> "1"
	MsgAlert("Essa Pre autorização está finalizada e não é possível gerar uma Pre nota.","Erro")
	Return()
Endif
If empty(SZB->ZB_FORMUL)
	MsgAlert("Formulário próprio não informado. Preencha esse campo e tente novamente.","Erro")
	Return()
ElseIf SZB->ZB_FORMUL = "N"
	If empty(SZB->ZB_DOC) .or. empty(SZB->ZB_SERIE)
		MsgAlert("Número do documento e/ou série não preenchidos. Verifique os campos e tente novamente.","Erro")
		Return()
	Endif
Endif
If empty(SZB->ZB_COND)
	MsgAlert("Condição de pagamento não informada. Preencha esse campo e tente novamente.","Erro")
	Return()
Endif
If empty(SZB->ZB_ESPECIE)
	MsgAlert("Espécie não informada. Preencha esse campo e tente novamente.","Erro")
	Return()
Endif

If Select(_cAliPre) > 0
	dbSelectArea(_cAliPre)
	(_cAliPre)->(dbCloseArea())
EndIf

_cQry := "SELECT * FROM "+RetSqlName("SZB")+" ZB"
_cQry += " JOIN "+RetSqlName("SZC")+" ZC ON ZB_FILIAL = ZC_FILIAL AND ZB_COD = ZC_COD"
_cQry += " JOIN "+RetSqlName("SA1")+" A1 ON ZB_CLIENTE = A1_COD AND ZB_LOJA = A1_LOJA"
_cQry += " JOIN "+RetSqlName("SD2")+" D2 ON ZC_NFORI = D2_DOC AND ZC_ITEMORI = D2_ITEM AND ZB_CLIENTE = D2_CLIENTE AND ZB_LOJA = D2_LOJA"
_cQry += " WHERE ZB_FILIAL = '"+xFilial("SZB")+"'
_cQry += " AND ZC_FILIAL = '"+xFilial("SZC")+"'
_cQry += " AND A1_FILIAL = '"+xFilial("SA1")+"'
_cQry += " AND D2_FILIAL = '"+xFilial("SD2")+"'
_cQry += " AND ZB_COD = '"+cCodPre+"'
_cQry += " AND ZB.D_E_L_E_T_ = ' '"
_cQry += " AND ZC.D_E_L_E_T_ = ' '"
_cQry += " AND A1.D_E_L_E_T_ = ' '"
_cQry += " AND D2.D_E_L_E_T_ = ' '"

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQry), _cAliPre, .F., .T.)

If (_cAliPre)->(!EOF())
	
	aCabec := {}
	
	//08/01/2016 - Rafael Leite - Verifica o tipo de nota
	_cTpImp := ""
	If (_cAliPre)->ZB_TIPO$"CE"
		_cTpImp := "B"
	Elseif (_cAliPre)->ZB_TIPO$"R"
		_cTpImp := "N"
	Else 
		_cTpImp := "D"
	Endif		      	
	aAdd(aCabec,{'F1_TIPO'		,_cTpImp ,NIL})
	
	aAdd(aCabec,{'F1_FORMUL'	,(_cAliPre)->ZB_FORMUL					,NIL})
	If (_cAliPre)->ZB_FORMUL = "N"
		aAdd(aCabec,{'F1_DOC'		,(_cAliPre)->ZB_DOC					,NIL})
		cSer := (_cAliPre)->ZB_SERIE
	Else
		cSer := Padr(GetMv("GEN_FAT003"),Tamsx3("F1_SERIE")[1]," ")
	Endif
	
	aAdd(aCabec,{'F1_SERIE'		,cSer								,NIL})
	aAdd(aCabec,{'F1_EMISSAO'	,dDataBase							,NIL})
	aAdd(aCabec,{'F1_FORNECE'	,(_cAliPre)->ZB_CLIENTE				,NIL})
	aAdd(aCabec,{'F1_LOJA'		,(_cAliPre)->ZB_LOJA				,NIL})
	aAdd(aCabec,{'F1_ESPECIE'	,"SPED"								,NIL})
	aAdd(aCabec,{'F1_COND'		,(_cAliPre)->ZB_COND				,NIL})
	
	aItens := {}
	Do While (_cAliPre)->(!EOF())
		aLinIt := {}
		aAdd(aLinIt,{'D1_COD'		,(_cAliPre)->ZC_PROD						,NIL})
		aAdd(aLinIt,{'D1_UM'		,(_cAliPre)->ZC_UM							,NIL})
		aAdd(aLinIt,{'D1_QUANT'		,(_cAliPre)->ZC_QUANT						,NIL})
		//aAdd(aLinIt,{'D1_VUNIT'		,(_cAliPre)->ZC_VUNIT						,NIL})
		aAdd(aLinIt,{'D1_VUNIT'		,(_cAliPre)->ZC_TOTAL/(_cAliPre)->ZC_QUANT	,NIL})
		
		//18/01/2016 - Rafael Leite - Retirado, pois os valores unitários já tem desconto
		//aAdd(aLinIt,{'D1_DESC'		,(_cAliPre)->ZC_DESC						,NIL})
		//aAdd(aLinIt,{'D1_VALDESC'	,(_cAliPre)->ZC_VALDESC						,NIL})
		
		aAdd(aLinIt,{'D1_LOCAL'		,(_cAliPre)->ZC_LOCAL						,NIL})
		aAdd(aLinIt,{'D1_NFORI'		,(_cAliPre)->ZC_NFORI				  		,NIL})
		aAdd(aLinIt,{'D1_SERIORI'	,(_cAliPre)->ZC_SERIORI						,NIL})
		aAdd(aLinIt,{'D1_ITEMORI'	,(_cAliPre)->ZC_ITEMORI				   		,NIL})
		aAdd(aLinIt,{'D1_IDENTB6'	,(_cAliPre)->ZC_IDENTB6						,NIL})
		aAdd(aLinIt,{'D1_DATAORI'	,STOD((_cAliPre)->D2_EMISSAO)				,NIL})
		aAdd(aItens,aLinIt)
		(_cAliPre)->(dbSkip())
	Enddo
	
	lMsErroAuto := .F.
	lMsHelpAuto := .F.
	
	If _cFormul = "S"
		_cDocImp := MA461NumNf(.T.,cSer)
		aAdd(aCabec,{'F1_DOC',_cDocImp,NIL})
	Endif
	MsgRun("Gerando Pre Nota...","Processando", {||MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens, 3)})
	If lMsErroAuto
		mostraerro()
	Else
		If Select(_cAliPre) > 0
			dbSelectArea(_cAliPre)
			(_cAliPre)->(dbCloseArea())
		EndIf

		_cQry := "SELECT SZC.ZC_IDENTB6, SD1.R_E_C_N_O_
		_cQry += "  FROM SZC000 SZC
		_cQry += "  JOIN SZB000 SZB
		_cQry += "    ON ZB_FILIAL = ZC_FILIAL
		_cQry += "   AND ZB_COD = ZC_COD
		_cQry += "   AND SZB.D_E_L_E_T_ = ' '
		_cQry += "  JOIN SD1000 SD1
		_cQry += "    ON D1_FILIAL = ZB_FILIAL
		_cQry += "   AND D1_DOC = ZB_DOC
		_cQry += "   AND D1_SERIE = ZB_SERIE
		_cQry += "   AND D1_FORNECE = ZB_CLIENTE
		_cQry += "   AND D1_LOJA = ZB_LOJA
		_cQry += "   AND D1_COD = ZC_PROD
		_cQry += "   AND D1_QUANT = ZC_QUANT 
		_cQry += "   AND D1_NFORI = ZC_NFORI
		_cQry += "   AND D1_SERIORI = ZC_SERIORI
		_cQry += "   AND D1_ITEMORI = ZC_ITEMORI
		_cQry += "   AND ZC_IDENTB6 <> ' '
		_cQry += "   AND SD1.D_E_L_E_T_ = ' '
		_cQry += " WHERE SZC.ZC_COD = '"+cCodPre+"'
		_cQry += "   AND SZC.ZC_FILIAL = '"+xFilial("SZC")+"'"
		_cQry += "   AND SZC.D_E_L_E_T_ = ' '

		dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQry), _cAliPre, .F., .T.)
		
		While (_cAliPre)->(!EOF())
			tcSqlExec("UPDATE "+RetSqlName("SD1")+" SET D1_IDENTB6 = '"+(_cAliPre)->ZC_IDENTB6+"' WHERE R_E_C_N_O_ = "+cValToChar((_cAliPre)->R_E_C_N_O_)) //ATUALIZA IDENTB6 NA SD1
		   (_cAliPre)->(DbSkip())
		End

		tcSqlExec("UPDATE "+RetSqlName("SZB")+" SET ZB_SITUACA = '3', ZB_DOC = '"+_cDocImp+"', ZB_SERIE = '"+cSer+"' WHERE ZB_COD = '"+cCodPre+"' AND D_E_L_E_T_ = ' '") //ATUALIZA SITUACAO DA PRE AUTORIZACAO
		MsgInfo("Pre nota "+_cDocImp+"-"+alltrim(cSer)+" gerada com sucesso.","Aviso")
	EndIf
	
Else
	MsgBox("Ocorreu um erro ao selecionar os registros. Entre em contato com o Administrador do sistema.","Erro")
Endif

If Select(_cAliPre) > 0
	dbSelectArea(_cAliPre)
	(_cAliPre)->(dbCloseArea())
EndIf

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GENA024F  ºAutor  ³Danilo Azevedo      º Data ³  20/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para ativar a consulta padrao conforme tipo de pre   º±±
±±º          ³autorizacao                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENA024F()

If M->ZB_TIPO $ "CE"
	lRet := ConPad1(,,,"SB6SZC")
	If lRet
		//gdFieldPut("ZC_NFORI",SD2->D2_DOC)
		gdFieldPut("ZC_SERIORI",SB6->B6_SERIE)
		cItOri := Posicione("SD2",4,xFilial("SD2")+SB6->B6_IDENT,"D2_ITEM")
		gdFieldPut("ZC_ITEMORI",cItOri)
		cNfOri := SB6->B6_DOC
	Endif
Else
	lRet := ConPad1(,,,"SD2SZC")
	If lRet
		//gdFieldPut("ZC_NFORI",SD2->D2_DOC)
		gdFieldPut("ZC_SERIORI",SD2->D2_SERIE)
		gdFieldPut("ZC_ITEMORI",SD2->D2_ITEM)
		cNfOri := SD2->D2_DOC
	Endif
Endif

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GENA024X  ºAutor  ³Danilo Azevedo      º Data ³  20/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para ativar o preenchimento do campo ZC_NFORI        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENA024X()
Return(cNfOri)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GENA024V  ºAutor  ³Danilo Azevedo      º Data ³  20/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para validar se a quantidade digitada eh maior que a º±±
±±º          ³disponivel no sistema                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GENA024V()

dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(xFilial("SD2")+GdFieldGet("ZC_NFORI")+GdFieldGet("ZC_SERIORI")+M->ZB_CLIENTE+M->ZB_LOJA+GdFieldGet("ZC_PROD")+GdFieldGet("ZC_ITEMORI"))
nQtdSld := SD2->D2_QUANT - SD2->D2_QTDEDEV
lRet := M->ZC_QUANT <= nQtdSld

If !lRet
	MsgAlert("A quantidade informada é maior que a disponível para este item.","Atenção")
Endif

Return(lRet)
