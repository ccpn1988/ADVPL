#INCLUDE "rwmake.ch"
#INCLUDE "fivewin.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SqlToCsv  º Autor ³ Danilo Azevedo     º Data ³  26/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Funcao responsavel por executar um arquivo SQL e salvar o   º±±
±±º          ³resultado num arquivo CSV.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SQLTOCSV()

Private oGeraTxt
Private oLeTxt

Private cFile := Space(0)
Private cDest := Space(0)

DEFINE MSDIALOG oLeTxt TITLE "Relatório Genérico" FROM 0,0 TO 175,370 PIXEL
@ 05,05 TO 55,180 PIXEL
@ 01,01 Say " Este programa ira ler um arquivo com uma consulta SQL e irá gerar o "
@ 02,01 Say " resultado em um arquivo .CSV que poderá ser aberto no MS Excel ou "
@ 03,01 Say " aplicativo similar."

@ 60,10 BUTTON "Arquivo SQL" Size 40,12 PIXEL OF oLeTxt ACTION (cFile := cGetFile("Consulta SQL (*.sql) |*.sql| Todos os Arquivos (*.*) |*.*" , "Seleção de Arquivo" , 0 , "" , .T. , GETF_LOCALHARD))
@ 60,52 BUTTON "Local destino" Size 40,12 PIXEL OF oLeTxt ACTION (cDest := cGetFile("Todos os Arquivos (*.*) |*.*" , "Seleção de Diretório" , 0 , "" , .T. , nOR(GETF_LOCALHARD,GETF_RETDIRECTORY)))
@ 60,94 BUTTON "Cancelar" SIZE 40,12 PIXEL OF oLeTxt ACTION Close(oLeTxt)
@ 60,136 BUTTON "OK" SIZE 40,12 PIXEL OF oLeTxt ACTION OkLeTxt()

ACTIVATE MSDIALOG oLeTxt CENTER

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKLETXT  º Autor ³ AP6 IDE            º Data ³  26/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a leitura do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkLeTxt()

Local nTamFile, nTamLin, cBuffer, nBtLidos, cLin, cCpo

Private nHdl    := fOpen(cFile,68)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo "+cFile+" não pode ser aberto. Verifique os parametros.","Atencao")
	Return
Endif

//PREPARA ARQUIVO CSV
Private cArqTxt :=alltrim(cDest)+"\"+alltrim(retcodusr())+"_"+dtos(msdate())+"_"+strtran(time(),":","")+".csv"
Private nCsv    := fCreate(cArqTxt)

If nCsv == -1
	MsgAlert("O arquivo "+cArqTxt+" não pode ser criado! Verifique os parametros.","Atenção")
	Return
Endif

Processa({|| RunCont() },"Processando...")

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  26/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont

Local j

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0) //POSICIONA NO INICIO DO ARQUIVO NOVAMENTE
cBuffer  := Space(nTamFile)
nBtLidos := fRead(nHdl,@cBuffer,nTamFile)

cArqT := "TEMP"+dtos(msdate())+strtran(time(),":","")

cBuffer := upper(strtran(cBuffer,cEol," ")) //RETIRA ESPACOS E SALTO DE LINHA
cBuffer := ChangeQuery(cBuffer)

cDB := alltrim(upper(TcGetDb()))

If cDB = "MSSQL"
	//CRIA TABELA TEMPORARIA
	cQry := substr(cBuffer,1,at("FROM ",cBuffer)-1)
	cQry += "INTO "+cArqT
	cQry += substr(cBuffer,at("FROM ",cBuffer)-1,len(cBuffer))
	TcSqlExec(cQry)
	
	cQry1 := "SELECT COLUMN_NAME AS COLUNA FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '"+cArqT+"' ORDER BY ORDINAL_POSITION"
	
ElseIf cDB = "ORACLE"
	//CRIA TABELA TEMPORARIA
	cQry := "CREATE TABLE "+cArqT+" AS "+cBuffer
	TcSqlExec(cQry)
	
	cQry1 := "SELECT COLUMN_NAME AS COLUNA FROM USER_TAB_COLS WHERE TABLE_NAME = '"+cArqT+"'  order by INTERNAL_COLUMN_ID"
	
Else
	MsgBox(cDB+" - Banco de dados não suportado por esta função.","Atenção")
	Return()
Endif

MsgInfo("Será executado para o banco de dados "+cDB,"Informação")

cAlias1 := Criatrab(Nil,.F.)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),cAlias1,.T.)
(cAlias1)->(dbGoTop())
aColunas := {}
cLin := Space(0)
Do While (cAlias1)->(!EOF())
	aAdd(aColunas,(cAlias1)->COLUNA)
	cLin += alltrim((cAlias1)->COLUNA) + ";"
	(cAlias1)->(dbSkip())
Enddo
fErase(cAlias1)

If Select("TMPTMM") <> 0
	TMPTMM->(dbCloseArea("TMPTMM"))
Endif
TcQuery "SELECT * FROM "+cArqT NEW ALIAS "TMPTMM"

TMPTMM->(dbGoTop())
nRegs := Contar("TMPTMM","!Eof()")
ProcRegua(nRegs)
TMPTMM->(dbGoTop())
nPos := 1

aResulta := {}
aAdd(aResulta,aColunas) //ADICIONA CABECALHO
cLin+=cEOL
fWrite(nCsv,cLin,Len(cLin))

While TMPTMM->(!EOF())
	IncProc()
	//	aLin := {}
	cLin := Space(0)
	For j:=1 to len(aColunas)
		If valtype(TMPTMM->&(aColunas[j])) = "N"
			//aAdd(aLin,alltrim(str(TMPTMM->&(aColunas[j]))))
			cLin += alltrim(str(TMPTMM->&(aColunas[j])))+";"
		Else
			//aAdd(aLin,TMPTMM->&(aColunas[j]))
			cLin += alltrim(TMPTMM->&(aColunas[j]))+";"
		Endif
	Next j
	//aAdd(aResulta,aLin)
	cLin+=cEOL
	fWrite(nCsv,cLin,Len(cLin))
	TMPTMM->(dbSkip())
Enddo

fClose(nCsv)

tcSqlExec("DROP TABLE "+cArqT)
Close(oLeTxt)
MsgInfo("O arquivo "+cArqTxt+" foi criado!","Sucesso")

If !ApOleClient("MsExcel") //SE EXCEL NAO ESTIVER INSTALADO, RETORNA
	//MsgInfo("MS Excel não instalado.","Aviso")
	Return()
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cArqTxt)
oExcelApp:SetVisible(.T.)

Return()
