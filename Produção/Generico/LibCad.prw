#INCLUDE "rwmake.ch"

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

User Function LibCad(cTab)

Private _cTab := cTab

If _cTab = "SA1" //CLIENTE
	
	cNivel1 := GetMv("MV_XCLIN1") //NIVEL 1 = Dir.Comercial
	cNivel2 := GetMv("MV_XCLIN2") //NIVEL 2 = Financeiro
	cNivel3 := GetMv("MV_XCLIN3") //NIVEL 3 = Diretoria
	
ElseIf _cTab = "SA2" //FORNECEDOR
	
	cNivel1 := GetMv("MV_XFORN1") //NIVEL 1 = Dir.Comercial
	cNivel2 := GetMv("MV_XFORN2") //NIVEL 2 = Financeiro
	cNivel3 := GetMv("MV_XFORN3") //NIVEL 3 = Diretoria
	
Endif

If !RetCodUsr()$cNivel1+cNivel2+cNivel3
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

Local xLoop
Local i

_aStru := {}
_aCampos := {} 

/*
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(_cTab)
*/

AAdd( _aStru , { "OK" , "C" , 02 , 0 } )
AADD( _aCampos , { "OK" , "" , "@!" , "02" , "0" } )
cCampos := Space(0)

//MONTA TRB COM ESTRUTURA DA TABELA

aCampos := FWSX3Util():GetAllFields( _cTab, .F. )
                                           
For xLoop := 1 To Len(aCampos)
	If X3USO(Posicione("SX3",2,aCampos[xLoop],"X3_USADO"),nModulo) .And. cNivel >= Posicione("SX3",2,aCampos[xLoop],"X3_NIVEL") .And. FWSX3Util():GetFieldType(aCampos[xLoop]) <> "M" .and. Posicione("SX3",2,aCampos[xLoop],"X3_CONTEXT") <> "V"
//		aAdd(_aStru,{ aCampos[xLoop], ,Posicione("SX3",2,aCampos[xLoop],"X3_TITULO"),Posicione("SX3",2,aCampos[xLoop],"X3_PICTURE")}) 
		AAdd( _aStru , { aCampos[xLoop], FWSX3Util():GetFieldType(aCampos[xLoop]), TamSx3(aCampos[xLoop])[1],TamSx3(aCampos[xLoop])[2] } )
		AAdd( _aCampos, { aCampos[xLoop],Posicione("SX3",2,aCampos[xLoop],"X3_TITULO"),Posicione("SX3",2,aCampos[xLoop],"X3_PICTURE"), TamSx3(aCampos[xLoop])[1],TamSx3(aCampos[xLoop])[2] } )  
		cCampos += alltrim(aCampos[xLoop]) + ", "		
	EndIf
Next xLoop


/*
Do While !Eof() .And. X3_ARQUIVO == _cTab
	If X3USO(X3_USADO,nModulo) .And. cNivel >= X3_NIVEL .And. X3_TIPO <> "M" .and. X3_CONTEXT <> "V"
		AAdd( _aStru , { X3_CAMPO, X3_TIPO, X3_TAMANHO, X3_DECIMAL } )
		AAdd( _aCampos, { X3_CAMPO, X3_TITULO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL } )
		cCampos += alltrim(X3_CAMPO) + ", "
	Endif
	SX3->(dbSkip())
Enddo*/
/*
_cArq   := Criatrab(_aStru,.T.)
_cIndex := Criatrab(Nil,.F.)

dbSelectArea(_cTab)
dbSetOrder(1)
_cChave := alltrim(Posicione("SIX",1,_cTab,"CHAVE"))
_cChave := Substr(_cChave,AT("+",_cChave)+1,len(_cChave))
DbUseArea(.t.,,_cArq,"TRB")

Indregua("TRB",_cIndex,_cChave,,,"Selecionando Registros...")
*/

//Cria o Objeto do FwTemporaryTable
_oLIBCAD := FwTemporaryTable():New("TRB")

//Cria a estrutura do alias temporario
_oLIBCAD:SetFields(_aStru)
                                             
_cChave := alltrim(Posicione("SIX",1,_cTab,"CHAVE"))
//_cChave := Substr(_cChave,AT("+",_cChave)+1,len(_cChave))

//Adiciona o indicie na tabela temporaria

If "_FILIAL" $ _cChave  
 	nPos := At("_FILIAL",_cChave)
	_cChave := SubStr(_cChave,nPos+8,Len(_cChave)) 
EndIf	

_oLIBCAD:AddIndex("1",Separa(_cChave,'+'))

//Criando a Tabela Temporaria
_oLIBCAD:Create()
                                
cCampos := substr(cCampos,1,len(cCampos)-2)

//VERIFICA QUAIS NIVEIS O USUARIO PERTENCE
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

cQry := "SELECT "+cCampos
cQry += " FROM "+RetSqlName(_cTab)
cNiv := strtran(cNiv,"''","','")
cQry += " WHERE "+Substr(_cTab,2,2)+"_XREV in ("+cNiv+")
cQry += " AND "+Substr(_cTab,2,2)+"_MSBLQL = '1'
cQry += " AND D_E_L_E_T_ <> '*'
cQry += " ORDER BY "+strtran(_cChave,"+","||")

If Select("QRY") > 0; QRY->(DbCloseArea()); EndIf
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
	
	@ 180,040 BUTTON "Fechar"			SIZE 45,15 ACTION Close(oDlg2)
	@ 180,090 BUTTON "Marcar Tudo"		SIZE 45,15 ACTION Marca()
	@ 180,140 BUTTON "Desmarcar Tudo"	SIZE 45,15 ACTION Desmarca()
	@ 180,190 BUTTON "Liberar"  		SIZE 45,15 ACTION LibCad()
	
	ACTIVATE DIALOG oDlg2 CENTERED
	
Else
	MsgInfo("Não foram encontrados registros aguardando sua liberação.","Atenção")
Endif

TRB->(DbCloseArea())
//FErase(_cArq+".DBF")
//FErase(_cIndex+OrdBagExt())

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

Local cCodUsr	:= RetCodUsr()
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

If !MsgYesNo("Confirma a liberação de "+cValToChar(nLib)+" cadastro(s)?","Confirma")
	Return()
Endif

While TRB->(!Eof())
	IncProc()
	If TRB->(Marked("OK"))
		dbSelectArea(_cTab)
		dbSetOrder(1)
		
		If _cTab = "SA1"
			
			If dbSeek(xFilial(_cTab)+TRB->(A1_COD+A1_LOJA))
				RecLock(_cTab,.F.)
				If cCodUsr$cNivel3
					SA1->A1_XREV := "4" //LIBERADO
					SA1->A1_MSBLQL := "2" //LIBERADO
				ElseIf cCodUsr$cNivel2
					If SA1->A1_LC <= 10000 //SE APROVADOR NIVEL 2 LIBERAR CLIENTE COM LIMITE DE CREDITO ATE 10K, LIBERA DIRETO.
						SA1->A1_XREV := "4" //LIBERADO
						SA1->A1_MSBLQL := "2" //LIBERADO
					Else
						SA1->A1_XREV := "3" //PENDENTE DIRETORIA
						SA1->A1_MSBLQL := "1" //BLOQUEADO
					Endif
				ElseIf cCodUsr$cNivel1
					SA1->A1_XREV := "2" //PENDENTE CONTROLADORIA
					SA1->A1_MSBLQL := "1" //BLOQUEADO
				Endif
				MsUnlock()
				
				/*
				If SA1->A1_XREV = "4" .and. SA1->A1_MSBLQL = "2" //EXECUTA ROTINA DE COPIA DO CADASTRO PARA ORACLE
				U_LIBCLI(.T.)
				Endif
				*/
				tcsqlexec("UPDATE "+RetSqlName("SA1")+" SET A1_XREV = '4' WHERE A1_XREV <> '4' AND A1_MSBLQL <> '1' AND D_E_L_E_T_ = ' '")
			Endif
			
		ElseIf _cTab = "SA2"
			
			If dbSeek(xFilial(_cTab)+TRB->(A2_COD+A2_LOJA))
				RecLock(_cTab,.F.)
				If cCodUsr$cNivel3
					SA2->A2_XREV := "4"
					SA2->A2_MSBLQL := "2"
				ElseIf cCodUsr$cNivel2
					SA2->A2_XREV := "3"
					SA2->A2_MSBLQL := "1"
				ElseIf cCodUsr$cNivel1
					SA2->A2_XREV := "2"
					SA2->A2_MSBLQL := "1"
				Endif
				MsUnlock()
			Endif
			
		Endif
		
	EndIf
	TRB->(DbSkip())
End

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Marca     ºAutor  ³Danilo Azevedo      º Data ³  10/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Seleciona todos os registros apresentados na tela.          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³DesMarca  ºAutor  ³Danilo Azevedo      º Data ³  10/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Limpa a selecao de todos os registros apresentados na tela. º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
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
