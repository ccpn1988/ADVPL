#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

STATIC cNfOri := Space(TAMSX3("D2_DOC")[1])

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTPM002    บ Autor ณ Helimar Tavares    บ Data ณ  05/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para gerar documento de entrada.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN - Estoque/Compras                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function TMP002()

U_TMP002I()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGENA024I  บAutor  ณDanilo Azevedo      บ Data ณ  15/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para importar arquivo .CSV de pre autorizacao.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Estoque/Compras                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TMP002I()

Private oGeraTxt
Private oLeTxt
Private aArea := GetArea()
Private cFile := Space(0)
Private cDest := Space(0)

DEFINE MSDIALOG oLeTxt TITLE "Doc Entrada" FROM 0,0 TO 175,370 PIXEL
@ 05,05 TO 55,180 PIXEL
@ 01,01 Say "Selecione um arquivo a ser importado."
@ 60,52 BUTTON "Arquivo" Size 40,12 PIXEL OF oLeTxt ACTION (cFile := cGetFile("Arquivos CSV(*.csv) |*.csv" , "Sele็ใo de Arquivo" , 0 , "" , .T. , GETF_LOCALHARD))
@ 60,94 BUTTON "Cancelar" SIZE 40,12 PIXEL OF oLeTxt ACTION Close(oLeTxt)
@ 60,136 BUTTON "OK" SIZE 40,12 PIXEL OF oLeTxt ACTION Processa({|| TMP002A()},"Processando...")

ACTIVATE MSDIALOG oLeTxt CENTER

Return()


Static Function TMP002A()

Local nOpc 		:= 0
Local _cAlias	:= GetNextAlias()
Private aCabec	:= {}
Private aItens	:= {}
Private aLinha	:= {}

If !File(cFile)
	MsgBox("O arquivo "+alltrim(cFile)+" nao pode ser aberto! Verifique os parametros.","Aten็ใo")
	Return()
Endif

Close(oLeTxt)

//ABRE ARQUIVO E POSICIONA NO INICIO
FT_FUSE(cFile)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()

nItens := 1
nDoc   := 0

aItens := {}

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
	
	If Select(_cAlias) > 0
		dbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	EndIf
	
	_cQry := "SELECT B1_COD FROM "+RetSqlName("SB1")
	_cQry += " WHERE B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+cProd+"'" //PESQUISA POR CODIGO
	_cQry += " AND D_E_L_E_T_ = ' '"
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQry), _cAlias, .F., .T.)
	
	If (_cAlias)->(!EOF())
		cVar := (_cAlias)->B1_COD
	Else
		MsgBox("Produto "+cProd+" nใo localizado.","Aten็ใo")
		FT_FSKIP()
		Loop
	Endif

	cCodPro := alltrim(cVar)

	If Select(_cAlias) > 0
		dbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	EndIf
	
	_cQry := "SELECT DA1_PRCVEN FROM "+RetSqlName("DA1")
	_cQry += " WHERE DA1_FILIAL = '"+xFilial("DA1")+"' AND DA1_CODTAB = '152' AND DA1_CODPRO = '"+cProd+"'" //PESQUISA POR CODIGO
	_cQry += " AND D_E_L_E_T_ = ' '"
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQry), _cAlias, .F., .T.)
	
	If (_cAlias)->(!EOF())
		nVUnit := (_cAlias)->DA1_PRCVEN
	Else
		MsgBox("Produto "+cProd+" sem pre็o.","Aten็ใo")
		FT_FSKIP()
		Loop
	Endif
	
	nPos := At(";",cLinha)
	cVar := strtran(substr(cLinha,1,nPos-1),".","")
	cLinha := alltrim(Substr(cLinha,nPos+1,len(cLinha)))
	nQtd := val(cVar) //QTD INFORMADA NO ARQUIVO
	
	aLinTmp := aClone(aLinIt)

	aLinIt := {}

	aAdd(aLinIt,{"D1_ITEM"		, STRZERO(nItens,TAMSX3("D1_ITEM")[1])		,Nil})
	aAdd(aLinIt,{'D1_COD'		,cCodPro									,NIL})
	aAdd(aLinIt,{'D1_UM'		,"UN"										,NIL})
	aAdd(aLinIt,{'D1_QUANT'		,nQtd										,NIL})
	aAdd(aLinIt,{'D1_VUNIT'		,nVUnit										,NIL})
	aAdd(aLinIt,{'D1_TOTAL'		,nQTd*nVUnit								,NIL})
	aAdd(aLinIt,{'D1_TES'		,"440"								  		,NIL})
	aAdd(aLinIt,{'D1_LOCAL'		,"01"										,NIL})

	aAdd(aItens,aLinIt)

	FT_FSKIP()
	
	nItens++

	if (nItens > 90) .or. (FT_FEOF())
		aCabec := {}
	                
	    nDoc++
	        
		aAdd(aCabec,{'F1_TIPO'		,"N"	 					,NIL})
		aAdd(aCabec,{'F1_FORMUL'	,"N"						,NIL})
		aAdd(aCabec,{'F1_DOC'		,cValToChar(nDoc)			,NIL})
		aAdd(aCabec,{'F1_SERIE'		,"1"						,NIL})
		aAdd(aCabec,{'F1_EMISSAO'	,dDataBase					,NIL})
		aadd(aCabec,{"F1_DTDIGIT"	,dDataBase					,NIl})
		aAdd(aCabec,{'F1_FORNECE'	,"0378128"					,NIL})
		aAdd(aCabec,{'F1_LOJA'		,"07"						,NIL})
		aAdd(aCabec,{'F1_ESPECIE'	,"NF"						,NIL})
	
		lMsErroAuto := .F.
		lMsHelpAuto := .T.
		
		Begin Transaction

		MSExecAuto({|x,y,z|MATA103(x,y,z)}, aCabec, aItens, 3)
			
		End Transaction
		
	    nItens := 1
		aItens := {}
	
		If lMsErroAuto
			mostraerro()
		EndIf
	EndIf
EndDo

MsgInfo("Documentos de entrada gerados com sucesso.","Aviso")

Return()
