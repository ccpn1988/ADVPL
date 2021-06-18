#Include "FINR470.CH"
#include "PROTHEUS.CH"
#DEFINE REC_NAO_CONCILIADO 1                                 
#DEFINE REC_CONCILIADO		2
#DEFINE PAG_NAO_CONCILIADO 3
#DEFINE PAG_CONCILIADO		4

Static lFWCodFil := FindFunction("FWCodFil")
Static lE5TXMoeda

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR470  ³ Autor ³ Adrianne Furtado      ³ Data ³ 10/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Extrato Banc rio.		 					              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR470(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FIN001()
Local lExec			:= .T.

Private lTReport	:= .F.

/*
Verifica se o ambiente esta configurada para as rotina de "modelo II" */
If cPaisLoc == "ARG" .And. FindFunction("FinModProc")
	lExec := FinModProc()
Else
	lExec := .T.
Endif
If lExec
	If FindFunction("TRepInUse") .And. TRepInUse() 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Interface de impressao                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lTReport := .T.
		oReport := ReportDef()                         
		If !Empty(oReport:uParam) .AND. !isblind()
			Pergunte(oReport:uParam,.F.)
		EndIf
		oReport:PrintDialog()
	Else
	    Return FinR470R3() // Executa versão anterior do fonte
	Endif
Endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Adrianne Furtado      ³ Data ³10/08/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport 
Local oBanco
Local oMovBanc           
Local nTamChave	 := TamSX3("E5_PREFIXO")[1]+TamSX3("E5_NUMERO")[1]+TamSX3("E5_PARCELA")[1] + 3

//AjustaSX1()
Pergunte("FIN470",.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na admin		 da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
//"EXTRATO BANCARIO"
//"Este programa ir  emitir o relat¢rio de movimenta‡”es" "banc rias em ordem de data. Poder  ser utilizado para""conferencia de extrato."
oReport := TReport():New("FINR470",STR0004,"FIN470", {|oReport| ReportPrint(oReport)},STR0001+" "+STR0002+" "+STR0003) 
//desabilita o botao GESTAO CORPORATIVA do relatório
oReport:SetUseGC(.f.)
oBanco := TRSection():New(oReport,STR0035,{"SA6"},/*[Ordem]*/ )//"Dados Bancarios"
TRCell():New(oBanco,"A6_COD" 		,"SA6",STR0008,,23,.F.)//"BANCO"             
TRCell():New(oBanco,"A6_AGENCIA"	,"SA6",STR0009) //"   AGENCIA "
TRCell():New(oBanco,"A6_NUMCON"	,"SA6",STR0010)//"   CONTA "
TRCell():New(oBanco,"SALDOINI"	,		,STR0034,,20,,)//"SALDO INICIAL"

oMovBanc := TRSection():New(oBanco,STR0036,{"SE5"})//"Movimentos Bancarios"
TRCell():New(oMovBanc,"E5_DTDISPO" ,"SE5",STR0025	,/*Picture*/,13,/*lPixel*/,{|| DtoC(E5_DTDISPO)}) //"DATA"
TRCell():New(oMovBanc,"E5_HISTOR"	,"SE5",STR0026	,,TamSX3("E5_HISTOR")[1]+3,,{|| SubStr(E5_HISTOR,1,TamSX3("E5_HISTOR")[1])})//"OPERACAO"
TRCell():New(oMovBanc,"E5_NUMCHEQ"	,"SE5",STR0027	,,36,,{|| If(Len(Alltrim(E5_DOCUMEN)) + Len(Alltrim(E5_NUMCHEQ)) > 35,;  //"DOCUMENTO"
																		Alltrim(SUBSTR(E5_DOCUMEN,1,20)) + If(!empty(Alltrim(E5_DOCUMEN)),"-"," ") + Alltrim(E5_NUMCHEQ ),;
																		If(Empty(E5_NUMCHEQ),E5_DOCUMEN,E5_NUMCHEQ))})
TRCell():New(oMovBanc,"PREFIXO/TITULO"	,"SE5",STR0028	,,nTamChave+5,,{|| If(E5_TIPODOC="CH",ChecaTp(E5_NUMCHEQ+E5_BANCO+E5_AGENCIA+E5_CONTA),;
                                                                    E5_PREFIXO+If(Empty(E5_PREFIXO)," ","-")+E5_NUMERO+; //"PREFIXO/TITULO"
																	   	             If(Empty(E5_PARCELA)," ","-")+E5_PARCELA)})  

TRCell():New(oMovBanc,"E5_VALOR-ENTRAD","SE5",STR0029	,,20)//"ENTRADAS"
TRCell():New(oMovBanc,"E5_VALOR-SAIDA" ,"SE5",STR0030	,,20)//"SAIDAS"

TRCell():New(oMovBanc,"SALDO ATUAL"		,"SE5",STR0031	,,20,,{|| nSaldoAtu})//"SALDO ATUAL"
TRCell():New(oMovBanc,"TAXA"	,,STR0037,,12)//"CONCILIADOS"
TRCell():New(oMovBanc,"x-CONCILIADOS"	,"SE5",STR0016,,3)//"CONCILIADOS"

oTotal := TRSection():New(oReport ,STR0032,/*{"SE5"}*/,/*[Ordem]*/ )//"Totais"

TRCell():New(oTotal,"DESCRICAO",,STR0033 ,,30,,)//"DESCRICAO"
TRCell():New(oTotal,"NAOCONC"  ,,STR0015 ,,20,,)//"NAO CONCILIADOS" 
TRCell():New(oTotal,"CONC"		 ,,STR0016 ,,20,,)//"CONCILIADOS"
TRCell():New(oTotal,"TOTAL" 	 ,,STR0017 ,,20,,)//"TOTAL"

oTotal:SetLeftMargin(35)

Return(oReport)       

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Adrianne Furtado      ³ Data ³27.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local oBanco	:= oReport:Section(1)
Local oMovBanc:= oReport:Section(1):Section(1)    
Local oTotal	:= oReport:Section(2)
Local cAlias
Local lAllFil	:= .F.
Local cChave	:= ""
Local cAliasSA6	:= "SA6"
Local cAliasSE5	:= "SE5"
Local cSql1:= cSql2	:= ""
Local nMoeda	:= GetMv("MV_CENT"+(IIF(mv_par06 > 1 , Alltrim(STR(mv_par06)),"")))            
Local lSpbInUse	:= SpbInUse()        
Local nSaldoAtu	:= 0    
Local cTabela14	:= ""   
Local nCol		:= 0      
Local aRecon 	:= {}     
Local nTotEnt	:= 0 
Local nTotSaida	:= 0    
Local nLimCred	:= 0     
Local nRecebNCon:= 0
Local nRecebConc:= 0   
Local cPictVlr	:=	tm(SE5->E5_VALOR,15,nMoeda)
Local nX
Local aTotais := {}
Local nLinReport 	:= 8
Local nLinPag		:= mv_par08 
Local cExpMda		:= ""
Local nCont 		:= 0
Local cCampos 		:= ""
Local nTaxa 		:= 0  
Local lMultSld    	:= (FindFunction( "FXMultSld" ) .AND. FXMultSld())
Local lMsmMoeda   	:= .F.
Local lGestao		:= Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
Local cAliasTmp
Local cFilSE5 := IIf(lGestao, FwFilial("SE5"), xFilial("SE5")) 
Local cFilSE8 := IIf(lGestao, FWFilial("SE8"), xFilial("SE8"))
Local	nSaldoIni	:=0
Local aAreaSE5
Local lTop := .t.
Local nTamFilSE5 := Len(Alltrim(xFilial("SE5")))
Local nTamFilSA6 := Len(Alltrim(xFilial("SA6")))
Local nValTroco	:= 0
Local lDvc			:= oReport:nDevice == 4
Local lMoedBco	:= SuperGetMv("MV_MOEDBCO",,.F.)
Local nVlCruz		:= 0
Local nReceber   	:= 0
Local cQryR		:= ""

#IFNDEF TOP
	Local cCondicao := ""
	Local cFiltSE5 := oReport:Section(1):GetAdvplExp("SE5")
	lTop		:= .f.
#ELSE
	Local lOracle := "ORACLE"$Upper(TCGetDB())
	Local cDBtype := Alltrim(Upper(TCGetDB()))
	Local cNulo	:= ""
#ENDIF                       

Private nTxMoedBc := 0
Private nMoedaBco := 1
Private nMoedTit	:= 1

AAdd( aRecon, {0,0,0,0} )   

If !Empty(mv_par08)
	nLinPag := IIf(MV_PAR08>=80,80,MV_PAR08)
Else
	nLinPag := 80	
EndIf	

dbSelectArea("SA6")
dbSetOrder(1)
IF !(dbSeek(cFilial+mv_par01+mv_par02+mv_par03))
	Help(" ",1,"BCONOEXIST")
	Return
EndIF

nMoedaBco	:=	Max(A6_MOEDA,1)

// Carrega a tabela 14
cTabela14 := FR470Tab14() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Saldo de Partida 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE8")
dbSetOrder(1)			

If lTop .and. Mv_par10 == 2 .AND. FWModeAccess("SA6",3,) == 'C' .and. FWModeAccess("SE8",3,) == 'E' // recompor saldo por Banco

	CalcSldIni(@nSaldoAtu, @nSaldoIni)
Else
	dbSeek(xFilial("SE8")+mv_par01+mv_par02+mv_par03+Dtos(mv_par04),.T.)   // filial + banco + agencia + conta
	dbSkip(-1)

	IF E8_FILIAL != xFilial("SE8") .Or. E8_BANCO!=mv_par01 .or. E8_AGENCIA!=mv_par02 .or. E8_CONTA!=mv_par03 .or. BOF() .or. EOF()
		nSaldoAtu:=0
		nSaldoIni:=0
	Else
		If mv_par07 == 1  //Todos
			nSaldoAtu:=Round(xMoeda(E8_SALATUA,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
			nSaldoIni:=Round(xMoeda(E8_SALATUA,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
		ElseIf mv_par07 == 2 //Conciliados
			nSaldoAtu:=Round(xMoeda(E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
			nSaldoIni:=Round(xMoeda(E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
		ElseIf mv_par07 == 3	//Nao Conciliados
			nSaldoAtu:=Round(xMoeda(E8_SALATUA-E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
			nSaldoIni:=Round(xMoeda(E8_SALATUA-E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
		Endif	
	Endif
EndIf

// Deve considerar todas as filiais para selecao dos movimentos na query
lAllFil := Empty( xFilial("SA6") ) .And. !Empty( xFilial("SE5") )
	
If lAllFil
	cChave	:= "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
Else
	cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
EndIf

If ExistBlock("F470ALLF")
	lAllFil := ExecBlock("F470ALLF",.F.,.F.,{lAllFil})
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP

	cAlias := GetNextAlias()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBanco:BeginQuery()	     
	
	If	lAllFil
		cOrder  := "%E5_DTDISPO,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ,E5_DOCUMEN,SE5.R_E_C_N_O_,E5_PREFIXO,E5_NUMERO%"
		 /*
		 If nTamFilSE5 > nTamFilSA6
		 cSql1	:=	"E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "		 
		 Endif
		 */
	Else		
		If nTamFilSE5 == nTamFilSA6 .or. nTamFilSE5 < nTamFilSA6
			cSql1	:=	"E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
		Else
			cSql1	:=	"E5_FILIAL LIKE '" + Substr(xFilial("SE5"),1,nTamFilSA6) + "%'" + " AND "
		EndIf	
		If Empty(cFilSE5) .and. !Empty(cFilSE8)
			cSql1	+=	"E5_FILORIG = '" + xFilial("SE8") + "'" + " AND "
		Endif
		cOrder  := "%E5_DTDISPO,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ,E5_DOCUMEN,SE5.R_E_C_N_O_,E5_PREFIXO,E5_NUMERO%"
	EndIf           
	If lSpbInuse	                                                
		cSql1	+=	" E5_DTDISPO >=  '"     + DTOS(mv_par04) + "' AND"
		cSql1	+=	" ((E5_DTDISPO <= '"+ DTOS(mv_par05) + "') OR "
		cSql1	+=	"  (E5_DTDISPO >= '"+ DTOS(mv_par05) + "' AND "
		cSql1	+=	"  (E5_DATA    >= '"+ DTOS(mv_par04) + "' AND " 
		cSql1	+=	"   E5_DATA    <= '"+ DTOS(mv_par05) + "'))) AND"			
	Else			                                  
		cSql1	+=	" E5_DTDISPO >= '" + DTOS(mv_par04) + "' AND"
		cSql1	+=	" E5_DTDISPO <= '" + DTOS(mv_par05) + "' AND"
	EndIf                           
	If mv_par07 == 2
		cSql1	+=	" E5_RECONC <> ' ' AND "
	ElseIf mv_par07 == 3
		cSql1	+=	" E5_RECONC = ' ' AND " 
	EndIf

	cSql1 := "%"+cSql1+"%"
	cCampos := "E5_FILIAL,  E5_DTDISPO,	E5_HISTOR,	E5_NUMCHEQ,	E5_DOCUMEN, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPODOC, E5_FILORIG, "
	cCampos += "E5_RECPAG, 	E5_VALOR, 	E5_MOEDA, 	E5_VLMOED2, E5_CLIFOR, 	E5_LOJA, 	E5_RECONC, E5_TIPO, E5_SEQ, E5_KEY, E5_DATA, "
	cCampos += "SE5.R_E_C_N_O_ REGSE5, " 
	
	//Necessario incluir alguns campos de acordo com a alteracao realizada para a exibicao no relatorio dos dados corretos 
	//de um titulo a pagar quando baixado como normal e com cheque. 
	cCampos += "E5_BANCO, E5_AGENCIA, E5_CONTA, "
		
	cCampos += "A6_FILIAL, 	A6_COD, 	A6_NREDUZ, 	A6_AGENCIA, A6_NUMCON, A6_LIMCRED"
	If SE5->( FieldPos("E5_TXMOEDA") > 0 )
		cCampos += ", E5_TXMOEDA "
	EndIf
	cCampos := "%"+cCampos+"%"	  
	
	cExpMda	:= "%E5_MOEDA NOT IN " + FormatIn(cTabela14+"/DO","/") + "%"
	
	BeginSql Alias cAlias  
	Select	%Exp:cCampos%
	FROM 	%table:SE5% SE5
			LEFT JOIN %table:SA6% SA6 ON
			(E5_BANCO 	= A6_COD AND
			E5_AGENCIA	= A6_AGENCIA AND
			E5_CONTA 	= A6_NUMCON) 
	WHERE 	%Exp:cSql1%     
			A6_FILIAL 	= %xFilial:SA6% AND
			E5_BANCO 	= %Exp:mv_par01% AND
			E5_AGENCIA 	= %Exp:mv_par02% AND
			E5_CONTA 	= %Exp:mv_par03% AND		
			E5_TIPODOC NOT IN ('DC','JR','MT','CM','D2','J2','M2','V2','C2','CP','TL','BA','I2','EI') AND
			NOT (E5_MOEDA IN ('C1','C2','C3','C4','C5','CH') AND E5_NUMCHEQ = '               ' AND (E5_TIPODOC NOT IN('TR','TE'))) AND	
			NOT (E5_TIPODOC IN ('TR','TE') AND ((E5_NUMCHEQ BETWEEN '*              ' AND '*ZZZZZZZZZZZZZZ') OR (E5_DOCUMEN BETWEEN '*                ' AND '*ZZZZZZZZZZZZZZZZ' ))) AND
			NOT (E5_TIPODOC IN ('TR','TE') AND E5_NUMERO = '      ' AND %Exp:cExpMda% ) AND
			E5_SITUACA <> 'C' AND
			E5_VALOR   <> 0 AND
			NOT(E5_NUMCHEQ BETWEEN '*              ' AND '*ZZZZZZZZZZZZZZ') AND//NOT LIKE '*%' AND
			(E5_VENCTO <= %Exp:DTOS(mv_par05)% OR E5_VENCTO <= E5_DATA) AND 
			SE5.%notDel% AND
			SA6.%notDel%
	ORDER BY %exp:cOrder%			
	EndSql               
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBanco:EndQuery(/*Array com os parametros do tipo Range*/)

	oMovBanc:SetParentQuery()

	cAliasSA6	:= cAlias
	cAliasSE5 	:= cAlias
#ELSE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao Advpl                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbSelectArea("SE5")
	DbSetOrder(1)

	MakeAdvplExpr(oReport:uParam)
                   
	If	lAllFil
		cOrder  := "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
	Else
		cOrder  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
		If nTamFilSE5 == nTamFilSA6 .or. nTamFilSE5 < nTamFilSA6
			cCondicao := 'E5_FILIAL == "' + xFilial("SE5")+'" .And.'
		Else
			cCondicao := "'" + Substr(E5_FILIAL,1,nTamFilSA6) + "' == " + "'" + Substr(xFilial("SE5"),1,nTamFilSA6)+"' .And. "
		EndIf	
		If Empty(cFilSE5) .and. !Empty(cFilSE8)
			cCondicao += 'E5_FILORIG == "' + xFilial("SE8")+'" .And.'
		Endif
	EndIf           
	If lSpbInuse	                                                
		cCondicao	+=	" ((DTOS(E5_DTDISPO) <= '"+ DTOS(mv_par05) + "') .OR. "
		cCondicao	+=	"  (DTOS(E5_DTDISPO) >= '"+ DTOS(mv_par05) + "' .And. "
		cCondicao	+=	"  (DTOS(E5_DATA)    >= '"+ DTOS(mv_par04) + "' .And. " 
		cCondicao	+=	"   DTOS(E5_DATA)    <= '"+ DTOS(mv_par05) + "'))) .And. "			
	EndIf 
	cCondicao += 'DTOS(E5_DTDISPO) >= "' + DTOS(mv_par04) + '" .And. '
	cCondicao += 'DTOS(E5_DTDISPO) <= "' + DTOS(mv_par05) + '" .And. '
	cCondicao += 'E5_BANCO   == "' + mv_par01 + '" .And. '
	cCondicao += 'E5_AGENCIA == "' + mv_par02 + '" .And. '
	cCondicao += 'E5_CONTA   == "' + mv_par03 + '" .And. '
	cCondicao += 'E5_SITUACA <> "C" .And. '   //Cancelado
	cCondicao += 'E5_VALOR   <> 0 .And. '  
	cCondicao += '!(E5_TIPODOC $ "DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL/BA/I2/EI") .And. '  
	cCondicao += '!(E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .And. E5_NUMCHEQ = "               " .And. !(E5_TIPODOC $ "TR#TE")) .And.'
  	cCondicao += '(DTOS(E5_VENCTO) <= "' + DTOS(mv_par05) + '".Or. E5_VENCTO <= E5_DATA)'
	
	//Adiciona filtro do usuário
	If !Empty(cFiltSE5)
		cCondicao += ' .And. ' + cFiltSE5
   EndIf
                    
	oMovBanc:SetFilter( cCondicao, cOrder )

	oMovBanc:SetRelation( {|| xFilial((cAliasSE5))+(cAliasSA6)->(A6_COD+A6_AGENCIA+A6_NUMCON)},cAliasSA6,1,.T.)
	oMovBanc:SetParentFilter( {|cParam| (cAliasSE5)->(E5_BANCO+E5_AGENCIA+E5_CONTA) == cParam}, { || (cAliasSA6)->(A6_COD+A6_AGENCIA+A6_NUMCON) } )
                               
#ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cMoeda := Upper(GetMv("MV_MOEDA"+LTrim(Str(mv_par06))))

nTxMoeda := If(nTxMoedBc > 1, nTxMoedBc,RecMoeda(iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06))

If alltrim(oReport:title()) == alltrim (STR0004)
   oReport:SetTitle(OemToAnsi(STR0007 + " " + DTOC(mv_par04) + STR0040 + Dtoc(mv_par05) + STR0039 + cMoeda))//"EXTRATO BANCARIO ENTRE " 
Endif

oMovBanc:Cell("E5_VALOR-ENTRAD"	):SetPicture(tm(E5_VALOR,20,nMoeda))
oMovBanc:Cell("E5_VALOR-SAIDA"	):SetPicture(tm(E5_VALOR,20,nMoeda))
oMovBanc:Cell("TAXA"	):SetPicture(tm(E5_VALOR,12,nMoeda))
oMovBanc:Cell("SALDO ATUAL"		):SetPicture(tm(E5_VALOR,20,nMoeda))

If lMultSld .And. !Empty((cAliasSE5)->E5_TXMOEDA)
	If Empty(AllTrim((cAliasSE5)->E5_KEY)) .And. E5_TIPODOC $ MVPAGANT+MVRECANT + "ES/BA/VL"  	
		If (cAliasSE5)->E5_RECPAG == "P"
			lMsmMoeda := Posicione("SE2",1,xFilial("SE2")+(cAliasSE5)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA),"E2_MOEDA") == mv_par06
		Else
			lMsmMoeda := Posicione("SE1",1,xFilial("SE1")+(cAliasSE5)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA),"E1_MOEDA") == mv_par06
		EndIf
	Else
		lMsmMoeda := Iif(E5_TIPODOC $ MVPAGANT+MVRECANT + "ES/BA/VL", VerMoed(nMoedaBco, @nMoedTit,(cAliasSE5)->E5_TXMOEDA,.F.),F470VlMoeda(cAliasSE5)) == mv_par06
	EndIf
EndIf

oMovBanc:Cell("SALDO ATUAL"		):SetBlock({|| nSaldoAtu += Fr470ValSld(cAliasSE5,nMoeda,lMultSld,lMsmMoeda,@nValTroco,cAlias) })
oMovBanc:Cell("E5_VALOR-ENTRAD"	):SetHeaderAlign("RIGHT")           
oMovBanc:Cell("E5_VALOR-SAIDA"	):SetHeaderAlign("RIGHT")
oMovBanc:Cell("SALDO ATUAL"		):SetHeaderAlign("RIGHT")
oMovBanc:Cell("TAXA"		):SetHeaderAlign("CENTER")

// Se realiza controle de saldos em multiplas moedas
If lMultSld   
	If lMoedBco 
	
		oMovBanc:Cell("E5_VALOR-ENTRAD"  ):SetBlock({|| If((cAliasSE5)->E5_RECPAG == "R", ( Iif((cAliasSE5)->E5_TIPODOC $ MVPAGANT+MVRECANT + "ES/BA/VL",VerMoed(nMoedaBco, @nMoedTit, (cAliasSE5)->E5_TXMOEDA,.F.,@nVlCruz),F470VlMoeda(cAliasSE5)), nX := ConvMoed(cAliasSE5,nMoeda,lMsmMoeda,@aRecon, If((cAliasSE5)->E5_RECPAG == "R",.T.,.F.)),;  
			If( nX == 1, Round(xMoeda( F470VlMoeda(cAliasSE5), nMoedaBco, mv_par06, iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO), nMoeda + 1, IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ), IIf(!lMsmMoeda, RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06), (cAliasSE5)->E5_TXMOEDA)),nMoeda),;
			If( nX == 2, Round(xMoeda( F470VlMoeda(cAliasSE5), nMoedaBco, mv_par06, IIF(MV_PAR09==1,dDataBase,E5_DTDISPO), nMoeda + 1, IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco)),	IIF(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,E5_DTDISPO),mv_par06),E5_TXMOEDA) ),nMoeda),;
			If( nX == 3, Round(xMoeda( Iif((cAliasSE5)->E5_TIPODOC $ MVPAGANT+MVRECANT + "ES/BA/VL", Iif(VerMoed(nMoedaBco	, @nMoedTit,(cAliasSE5)->E5_TXMOEDA), E5_VALOR, E5_VLMOED2),F470VlMoeda(cAliasSE5)), Iif((cAliasSE5)->E5_MOEDA == "TB", nMoedaBco,nMoedTit), mv_par06, IIF(MV_PAR09==1,dDataBase,E5_DTDISPO), nMoeda + 1, IIf(lMultSld, /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedTit ), TxMoeda(cAliasSE5, nMoedTit) ) /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda),;
			If( nX == 4, Round(xMoeda( E5_VLMOED2, nMoedTit, mv_par06, dDataBase, nMoeda + 1, IIf(lMultSld, /**/ 0 /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda),;
			If( nX == 5, Round(xMoeda( Iif((cAliasSE5)->E5_TIPODOC $ MVPAGANT+MVRECANT + "ES/BA/VL", Iif(VerMoed(nMoedaBco, @nMoedTit,(cAliasSE5)->E5_TXMOEDA,,@nVlCruz), nVlCruz /*E5_VALOR*/, E5_VLMOED2),F470VlMoeda(cAliasSE5)), nMoedaBco, mv_par06, dDataBase, nMoeda + 1, IIf(lMultSld, /**/ E5_TXMOEDA /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda),nil)))))), Iif(lDvc, 0, nil))})
			
		oMovBanc:Cell("E5_VALOR-SAIDA"  ):SetBlock({|| If((cAliasSE5)->E5_RECPAG == "P", ( Iif((cAliasSE5)->E5_TIPODOC $ MVPAGANT+MVRECANT + "ES/BA/VL",VerMoed(nMoedaBco, @nMoedTit,(cAliasSE5)->E5_TXMOEDA,.F.,@nVlCruz),F470VlMoeda(cAliasSE5)), nX := ConvMoed(cAliasSE5,nMoeda,lMsmMoeda,@aRecon,If((cAliasSE5)->E5_RECPAG == "P",.T.,.F.)),;
			If( nX == 1, Round(xMoeda( F470VlMoeda(cAliasSE5), nMoedaBco, mv_par06, iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO), nMoeda + 1, IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ), IIf(!lMsmMoeda, RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06), (cAliasSE5)->E5_TXMOEDA)),nMoeda),;
			If( nX == 2, Round(xMoeda( F470VlMoeda(cAliasSE5), nMoedaBco, mv_par06, IIF(MV_PAR09==1,dDataBase,E5_DTDISPO), nMoeda + 1, IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco)),	IIF(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,E5_DTDISPO),mv_par06),E5_TXMOEDA) ),nMoeda),;
			If( nX == 3, Round(xMoeda( Iif((cAliasSE5)->E5_TIPODOC $ MVPAGANT+MVRECANT + "ES/BA/VL", Iif(VerMoed(nMoedaBco, @nMoedTit,(cAliasSE5)->E5_TXMOEDA), E5_VALOR, E5_VLMOED2),F470VlMoeda(cAliasSE5)), Iif((cAliasSE5)->E5_MOEDA == "TB", nMoedaBco,nMoedTit), mv_par06, IIF(MV_PAR09==1,dDataBase,E5_DTDISPO), nMoeda + 1, IIf(lMultSld, /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedTit ), TxMoeda(cAliasSE5, nMoedTit) ) /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda),;
			If( nX == 4, Round(xMoeda( E5_VLMOED2, nMoedTit, mv_par06, dDataBase, nMoeda + 1, IIf(lMultSld, /**/ 0 /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda),;
			If( nX == 5, Round(xMoeda( Iif((cAliasSE5)->E5_TIPODOC $ MVPAGANT+MVRECANT + "ES/BA/VL", Iif(VerMoed(nMoedaBco, @nMoedTit,(cAliasSE5)->E5_TXMOEDA,,@nVlCruz), nVlCruz /*E5_VALOR*/, E5_VLMOED2),F470VlMoeda(cAliasSE5)), nMoedaBco, mv_par06, dDataBase, nMoeda + 1, IIf(lMultSld, /**/ E5_TXMOEDA /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda),nil)))))), Iif(lDvc, 0, nil))})
	
	Else
		oMovBanc:Cell("E5_VALOR-ENTRAD"  ):SetBlock({|| If((cAliasSE5)->E5_RECPAG == "R", Round(xMoeda(F470VlMoeda(cAliasSE5),;
		nMoedaBco ,;
		mv_par06,;
		iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),;
		nMoeda+1,;
		IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ),;
		IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA)),nMoeda), Iif(lDvc, 0, nil))})
	

		oMovBanc:Cell("E5_VALOR-SAIDA"   ):SetBlock({|| If((cAliasSE5)->E5_RECPAG == "P", Round(xMoeda(F470VlMoeda(cAliasSE5),;
		nMoedaBco,;
		mv_par06,;
		iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),;
		nMoeda+1,;
		IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ),;
		IIf(!lMsmMoeda, RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06), (cAliasSE5)->E5_TXMOEDA)),nMoeda),Iif(lDvc, 0, nil))})
	EndIf
Else
	If lMoedBco
		If nMoedaBco == Mv_PAR06
			oMovBanc:Cell("E5_VALOR-ENTRAD"  ):SetBlock({||If((cAliasSE5)->E5_RECPAG == "R", Round(xMoeda( Iif((cAliasSE5)->E5_TIPODOC $ MVPAGANT+MVRECANT + "ES/BA/VL", Iif(VerMoed(nMoedaBco, @nMoedTit,(cAliasSE5)->E5_TXMOEDA,.T.,@nVlCruz), Iif(Mv_PAR09 == 1 .And. (cAliasSE5)->E5_TXMOEDA > 0 ,nVlCruz,E5_VALOR), E5_VLMOED2),F470VlMoeda(cAliasSE5)),;
			Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, Iif(Mv_PAR09 == 1 .And. (cAliasSE5)->E5_TXMOEDA > 0,nMoedaBco,nMoedTit) ),;
			mv_par06, IIF(MV_PAR09==1,dDataBase,E5_DTDISPO),, IIf(lMultSld, /**/ Iif(Mv_PAR09 == 1 .And. (cAliasSE5)->E5_TXMOEDA > 0,(cAliasSE5)->E5_TXMOEDA, IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedTit ), TxMoeda(cAliasSE5, nMoedTit) ) ) /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda), Iif(lDvc, 0, nil))})
		
			oMovBanc:Cell("E5_VALOR-SAIDA"   ):SetBlock({||; 
			If((cAliasSE5)->E5_RECPAG == "P", ;
			Round(	xMoeda( Iif((cAliasSE5)->E5_TIPODOC $ MVPAGANT+MVRECANT + "ES/BA/VL",Iif(VerMoed(nMoedaBco, @nMoedTit,(cAliasSE5)->E5_TXMOEDA,.T.,@nVlCruz),Iif(Mv_PAR09 == 1 .And. (cAliasSE5)->E5_TXMOEDA > 0 ,nVlCruz,E5_VALOR), E5_VLMOED2),F470VlMoeda(cAliasSE5)),Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, Iif(Mv_PAR09 == 1 .And. (cAliasSE5)->E5_TXMOEDA > 0,nMoedaBco,nMoedTit) ),;
			mv_par06, IIF(MV_PAR09==1,dDataBase,E5_DTDISPO),, IIf(lMultSld, /**/ Iif(Mv_PAR09 == 1 .And. (cAliasSE5)->E5_TXMOEDA > 0,(cAliasSE5)->E5_TXMOEDA, IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedTit ), TxMoeda(cAliasSE5, nMoedTit) ) ) /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda) ,Iif(lDvc, 0, nil))})
		Else
			oMovBanc:Cell("E5_VALOR-ENTRAD"  ):SetBlock({||If((cAliasSE5)->E5_RECPAG == "R", Round(xMoeda( Iif((cAliasSE5)->E5_TIPODOC $ MVPAGANT+MVRECANT + "ES/BA/VL",Iif(VerMoed(nMoedaBco, @nMoedTit,(cAliasSE5)->E5_TXMOEDA), E5_VALOR, E5_VLMOED2),F470VlMoeda(CAliasSE5)),;
			Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedTit ),;
			mv_par06, IIF(MV_PAR09==1,dDataBase,E5_DTDISPO),, IIf(lMultSld, /**/ IIF(MV_PAR09 == 1, Iif((cAliasSE5)->E5_TXMOEDA > 0 .And. nMoedaBco == Mv_PAR06, (cAliasSE5)->E5_TXMOEDA,RecMoeda(dDatabase, nMoedTit )), TxMoeda(cAliasSE5, nMoedTit) ) /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda), Iif(lDvc, 0, nil))})
			
			oMovBanc:Cell("E5_VALOR-SAIDA"   ):SetBlock({||; 
			If((cAliasSE5)->E5_RECPAG == "P", ;
				Round(	xMoeda( Iif((cAliasSE5)->E5_TIPODOC $ MVPAGANT+MVRECANT + "ES/BA/VL",Iif(VerMoed(nMoedaBco, @nMoedTit,(cAliasSE5)->E5_TXMOEDA), E5_VALOR, E5_VLMOED2),F470VlMoeda(cAliasSE5)),Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedTit ),;
				mv_par06, IIF(MV_PAR09==1,dDataBase,E5_DTDISPO),, IIf(lMultSld, /**/ IIF(MV_PAR09 == 1, Iif((cAliasSE5)->E5_TXMOEDA > 0 .And. nMoedaBco == Mv_PAR06, (cAliasSE5)->E5_TXMOEDA,RecMoeda(dDatabase, nMoedTit )), TxMoeda(cAliasSE5, nMoedTit) ) /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda) ,Iif(lDvc, 0, nil))})
		EndIf
			
	Else
	
	oMovBanc:Cell("E5_VALOR-ENTRAD"  ):SetBlock({||If((cAliasSE5)->E5_RECPAG == "R", Round(xMoeda(F470VlMoeda(cAliasSE5);
		,Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedaBco );
		,mv_par06;
		,iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO);
		,nMoeda+1;
		,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA", /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ) /**/,nTxMoedBc));
		,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),nTxMoeda)));
		,nMoeda);
		,Iif(lDvc, 0, nil))})

	oMovBanc:Cell("E5_VALOR-SAIDA"   ):SetBlock({||; 
		If((cAliasSE5)->E5_RECPAG == "P", ;
			Round(	xMoeda(F470VlMoeda(cAliasSE5),Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedaBco );
							,mv_par06;
							,iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO);
							,nMoeda+1;
							,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA", /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ) /**/ ,nTxMoedBc));
			 				,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc,if(cPaisLoc=="BRA",RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),nTxMoeda));
		  			);
			,nMoeda);
	 	, Iif(lDvc, 0, nil));
  	})
	EndIf
EndIf

oMovBanc:Cell("x-CONCILIADOS"		):SetBlock({|| Iif(Empty((cAliasSE5)->E5_RECONC), " ", "x")})
oMovBanc:Cell("x-CONCILIADOS"		):SetTitle("")

If cPaisLoc <> "BRA"
    If cPaisLoc<>"ANG"
		If mv_par06 <> nMoedaBco .And. mv_par06 > 1
			oMovBanc:Cell("TAXA"):SetBlock({||If(nTxMoedBc > 1, nTxMoedBc, RecMoeda(iif(MV_PAR09==1,dDataBase,E5_DTDISPO),mv_par06))})
		Else
			oMovBanc:Cell("TAXA"):Disable()
		EndIf
	Else    
	    If mv_par06 <> nMoedaBco
	        If nMoedaBco>1
				oMovBanc:Cell("TAXA"):SetBlock({||If(nTxMoedBc > 1, nTxMoedBc, RecMoeda(E5_DTDISPO,nMoedaBco))})
			Else
				oMovBanc:Cell("TAXA"):SetBlock({||If(nTxMoedBc > 1, nTxMoedBc, IIf(!lMsmMoeda,RecMoeda(E5_DTDISPO,mv_par06),(cAliasSE5)->E5_TXMOEDA))})
			EndIf
		Else
			oMovBanc:Cell("TAXA"):Disable()
		EndIf
	EndIf
Else
	oMovBanc:Cell("TAXA"):Disable()
EndIf	

oBanco:SetLineStyle()
        
If cPaisLoc == "BRA"
	nLimCred := SA6->(A6_LIMCRED)
Else 
	If SA6->A6_MOEDA <> 1 .and. SA6->A6_MOEDA == mv_par06
		nLimCred := (cAliasSA6)->(A6_LIMCRED)
	Else 
		nLimCred := xMoeda((cAliasSA6)->A6_LIMCRED,SA6->A6_MOEDA,1,dDataBase)
	EndIf	
EndIf	

oBanco:Init()         

oBanco:Cell("SALDOINI"):SetBlock( { || Transform(nSaldoIni,tm(nSaldoIni,16,nMoeda)) } )
oBanco:Cell("SALDOINI"):SetHeaderAlign("RIGHT")

oMovBanc:OnPrintLine( {|| F470LinPag(nLinPag, @nLinReport)})

(cAliasSE5)->(dbEval({|| nCont++}))
(cAliasSE5)->(dbGoTop())

If (cAliasSE5)->(Eof())  
	oBanco:Cell("A6_COD"):SetBlock( {|| SA6->A6_COD +" - "+AllTrim(SA6->A6_NREDUZ)} )
	oBanco:Cell("A6_AGENCIA"):SetBlock( {|| SA6->A6_AGENCIA } )
	oBanco:Cell("A6_NUMCON"):SetBlock( {|| SA6->A6_NUMCON } )
	oBanco:PrintLine()
	oMovBanc:Init()
	oMovBanc:PrintLine()
	oMovBanc:Finish()
Else
	oBanco:Cell("A6_COD"):SetBlock( {|| (cAliasSA6)->A6_COD +" - "+AllTrim((cAliasSA6)->A6_NREDUZ)} )
	oReport:OnPageBreak( { || oBanco:PrintLine() } )	
EndIf	

oReport:SetMeter(nCont)

While !oReport:Cancel() .And. (cAliasSE5)->(!Eof())          					
     
	If oReport:Cancel()
		Exit
	EndIf	

	If oBanco:Cancel()
		Exit
	EndIf
	
	lFirst := .T.

	oMovBanc:Init()               
	While !oReport:Cancel() .And. !(cAliasSE5)->(Eof())
		If oReport:Cancel()
			Exit
		EndIf               

		oReport:IncMeter()		          
		
		// Posiciona no correspondente SE5 para permitir configuracoes condicionais de colunas
		#IFDEF TOP
			SE5->( dbGoTo( (cAliasSE5)->REGSE5 ) )
		#ELSE
			If (cAliasSE5)->E5_TIPODOC $ "TR/TE" .and. Empty((cAliasSE5)->E5_NUMERO)
				If !((cAliasSE5)->E5_MOEDA $ cTabela14)
					dbSkip()
					Loop
				Endif
			Endif
			If (cAliasSE5)->E5_TIPODOC $ "TR/TE" .and. (Substr((cAliasSE5)->E5_NUMCHEQ,1,1)=="*" .or. Substr((cAliasSE5)->E5_DOCUMEN,1,1) == "*" )
				dbSkip()
				Loop
			Endif
			If !Fr470Skip(mv_par01,mv_par02,mv_par03)
				(cAliasSE5)->(dbSkip())
				Loop
			EndIf	
		#ENDIF
		
		nTxMoedBc 	:= 0 
       
        If (cAliasSE5)->E5_TIPODOC=="ES"
        	aAreaSE5 := (cAliasSE5)->( GetArea() )
        	cAliasTmp  :=Alias()
			cChave     := (cAliasSE5)->E5_FILIAL+(cAliasSE5)->E5_PREFIXO+(cAliasSE5)->E5_NUMERO+(cAliasSE5)->E5_PARCELA+(cAliasSE5)->E5_TIPO+(cAliasSE5)->E5_CLIFOR+(cAliasSE5)->E5_LOJA+(cAliasSE5)->E5_SEQ
        	
        	DbSelectArea("SE5")
        	DbSetOrder(7)    
        	DbGoTop()
        	
        	If DbSeek(cChave)
        		If SE5->E5_TIPODOC=="V2"
	        		RestArea( aAreaSE5 )
       				DbSelectArea(cAliasTmp)
	        		(cAliasSE5)->(dbSkip())	
	        		Loop
	        	EndIf
        	EndIf
			RestArea( aAreaSE5 )
        	DbSelectArea(cAliasTmp)

        EndIf
        
		If cPaisloc<>"BRA"
			nTaxa := TxMoeda(cAliasSE5, nMoedaBco)
			If mv_par09 == 1
				nTxMoedBc := 0 //RecMoeda(dDatabase,nMoedaBco)
			Else
				nTxMoedBc := nTaxa
			Endif
		EndIf

		oMovBanc:PrintLine()          
		If !lMoedBco
			If Empty((cAliasSE5)->E5_RECONC) .AND. (cAliasSE5)->E5_RECPAG == "R"			
				aRecon[1][REC_NAO_CONCILIADO] += Round(xMoeda( F470VlMoeda(cAliasSE5);
				,Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedaBco );
				,mv_par06;
				,iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO);
				,nMoeda+1;
				,IIf(lMultSld, /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ) /**/ ,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA", /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ) /**/ ,nTxMoedBc)));
				,IIf(lMultSld,IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA),Iif(nTxMoedBc > 1 ,nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,mv_par06),nTxMoedBc))));
				,nMoeda)
			ElseIf E5_RECPAG == "R"			
				aRecon[1][REC_CONCILIADO] += Round(xMoeda(F470VlMoeda(cAliasSE5);
				,Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedaBco );
				,mv_par06;
				,iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO);                                                                          
				,nMoeda+1;
				,IIf(lMultSld,/**/IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) )/**/ ,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",/**/IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ) /**/ ,nTxMoedBc)));
				,IIf(lMultSld,IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA),Iif(nTxMoedBc > 1 ,nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,mv_par06),nTxMoedBc))));
				,nMoeda)
			ElseIf Empty( E5_RECONC ) .AND. E5_RECPAG == "P"			
				aRecon[1][PAG_NAO_CONCILIADO] += Round(xMoeda(F470VlMoeda(cAliasSE5);
				,Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedaBco );
				,mv_par06;
				,iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO);
				,nMoeda+1;
				,IIf(lMultSld,/**/IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) )/**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA", /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ) /**/ ,nTxMoedBc)));
				,IIf(lMultSld,IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA),Iif(nTxMoedBc > 1 ,nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,mv_par06),nTxMoeda))));
				,nMoeda)
			ElseIf E5_RECPAG == "P"			
				aRecon[1][PAG_CONCILIADO] += Round(xMoeda(F470VlMoeda(cAliasSE5);
				,Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedaBco );
				,mv_par06;
				,iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO);
				,nMoeda+1;
				,IIf(lMultSld,/**/IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) )/**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",/**/IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) )/**/,nTxMoedBc)));
				,IIf(lMultSld,IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA),Iif(nTxMoedBc > 1 ,nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,mv_par06),nTxMoedBc))));
				,nMoeda)
			EndIf
		EndIf
		(cAliasSE5)->(dbSkip())
	EndDo       
	oMovBanc:Finish()        
	oReport:SkipLine()
EndDo
oBanco:Finish()    

If lDvc
	oMovBanc:Cell("E5_DTDISPO"		):Hide()
	oMovBanc:Cell("E5_HISTOR"		):Hide()
	oMovBanc:Cell("E5_NUMCHEQ"		):Hide()
	oMovBanc:Cell("PREFIXO/TITULO"	):Hide()
	oMovBanc:Cell("E5_VALOR-ENTRAD"	):Hide()
	oMovBanc:Cell("E5_VALOR-SAIDA" 	):Hide()
	oMovBanc:Cell("SALDO ATUAL"		):Hide()
EndIf

AADD( aTotais ,{STR0014,,,nSaldoIni})//"SALDO INICIAL...........: "
AADD( aTotais ,{STR0018,aRecon[1][REC_NAO_CONCILIADO] + nValTroco,aRecon[1][REC_CONCILIADO],aRecon[1][REC_NAO_CONCILIADO] +  aRecon[1][REC_CONCILIADO] + nValTroco})//"ENTRADAS NO PERIODO.....: "
AADD( aTotais ,{STR0019,aRecon[1][PAG_NAO_CONCILIADO],aRecon[1][PAG_CONCILIADO],aRecon[1][PAG_NAO_CONCILIADO] +  aRecon[1][PAG_CONCILIADO] })//"SAIDAS NO PERIODO ......: "
AADD( aTotais ,{STR0021,,,nLimCred})//"LIMITE DE CREDITO.......: "
AADD( aTotais ,{STR0020,,,nSaldoAtu += (nLimCred - nValTroco)})//"SALDO ATUAL ............: "

oTotal:Init()

oTotal:Cell("DESCRICAO"):HideHeader()
oTotal:Cell("NAOCONC"):SetHeaderAlign("CENTER")
oTotal:Cell("CONC"):SetHeaderAlign("CENTER")
oTotal:Cell("TOTAL"):SetHeaderAlign("CENTER")

For nX := 1 to 5
	oTotal:Cell("DESCRICAO"):SetBlock( { || aTotais[nX][1] } )
	oTotal:Cell("NAOCONC")	:SetBlock( { || If(nX == 2 .Or. nX == 3,Transform(aTotais[nX][2],tm(aTotais[nX][2],16,nMoeda)),"")} )
	oTotal:Cell("CONC") 		:SetBlock( { || If(nX == 2 .Or. nX == 3,Transform(aTotais[nX][3],tm(aTotais[nX][3],16,nMoeda)),"")} )
	oTotal:Cell("TOTAL")		:SetBlock( { || Transform(aTotais[nX][4],tm(aTotais[nX][4],16,nMoeda))} )
	If nX == 2 .Or. nX == 5
		oReport:SkipLine()
	EndIf
	oTotal:PrintLine()
Next

oReport:Title(STR0004) 
oTotal:Finish()

Return NIL          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  | F470VlMoeda  ºAutor ³ TOTVS            º Data ³ 09/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorno o campo de valor a ser utilizado para conversão    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cAliasSE5												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ nVlMoeda = Retorna o campo E5_VALOR ou E5_VLMOED2          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR470                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F470VlMoeda(cAliasSE5)                                
Local nVlMoeda:=0
Local cMoeda                    
Local lSpbInUse := SpbInUse()
Local lMoedBco	:= SuperGetMv("MV_MOEDBCO",,.F.)                 

cMoeda := Iif((cPaisLoc<>"BRA" .And. ((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .And. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedaBco )

If cPaisLoc $ "ARG|COL|DOM|EQU|MEX|VEN|PAR" //Gravaçao do SE5 nas rotinas localizadas são diferentes do Brasil.
	If cMoeda <> 1 
	   If (mv_par06 == 1) .OR. (mv_par06 == cMoeda)
		    nVlMoeda := (cAliasSE5)->E5_VALOR
		Else 
			If (cAliasSE5)->E5_VLMOED2 > 0
			   nVlMoeda := (cAliasSE5)->E5_VLMOED2   
			Else
				nVlMoeda := (cAliasSE5)->E5_VALOR
			EndIf
		EndIf
	Else
		nVlMoeda := (cAliasSE5)->E5_VALOR
	EndIf

Else

	If lSpbInUse .And. !lTReport
   	cAliasSE5 := "TRB"
	EndIf
	
	If cMoeda <> 1
		If lMoedBco .And. Empty(AllTrim((cAliasSE5)->E5_KEY))
			If nMoedaBco == nMoedTit .Or. (nMoedTit == 1 .Or. (nMoedaBco == nMoedTit))
				nVlMoeda	:= (cAliasSE5)->E5_VALOR
			ElseIf nMoedaBco > 1 .And. Mv_Par06 != nMoedaBco .And. (cAliasSE5)->E5_TXMOEDA > 0 .And. Mv_Par09 == 2 
				nVlMoeda := (cAliasSE5)->E5_VLMOED2
			ElseIf nMoedaBco > 1 .And. Mv_Par06 == nMoedaBco .And. (cAliasSE5)->E5_TXMOEDA > 0
				nVlMoeda := (cAliasSE5)->E5_VALOR
			Else
				nVlMoeda := Iif( !((cAliasSE5)->E5_TXMOEDA > 0) .And. nMoedaBco > 1 .And. nMoedTit > 1 .And. Mv_Par09 == 1 .And. Mv_Par06 > 1 .And. nMoedTit != nMoedaBco,(cAliasSE5)->E5_VALOR,SE2->E2_VLCRUZ)
			EndIf
		Else
			nVlMoeda	:= Iif(VerMoed(nMoedaBco, nMoedTit,(cAliasSE5)->E5_TXMOEDA), E5_VALOR, E5_VLMOED2)
	   	EndIf
	   //***********************************************
	   // Bloco comentado pois a movimentação bancaria *
	   // é sempre feita na moeda do banco.            *
	   //***********************************************	
	   /*If mv_par06 == 1 .and. (mv_par06 == cMoeda)
		    nVlMoeda := (cAliasSE5)->E5_VALOR
		Else  
			If (cAliasSE5)->E5_VLMOED2 > 0 .AND. !((cAliasSE5)->E5_TIPO $ MVRECANT ) // MOVIMENTO DE RA TEM COMPORTAMENTO DIFERENTE NA GRAVAÇÃO DA SE5
			   nVlMoeda := (cAliasSE5)->E5_VLMOED2   
			Elseif (cAliasSE5)->E5_TIPO $ MVRECANT .and. (cAliasSE5)->E5_RECPAG == "P" // MOVIMENTO DE RA TEM COMPORTAMENTO DIFERENTE NA GRAVAÇÃO DA SE5
				nVlMoeda := (cAliasSE5)->E5_VLMOED2   
			Else
				nVlMoeda := (cAliasSE5)->E5_VALOR
			EndIf
		EndIf*/
	Else
		nVlMoeda := (cAliasSE5)->E5_VALOR
	EndIf

Endif	

Return (nVlMoeda)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  | F470LinPag   ºAutor ³ Marcio Menon	  º Data ³ 29/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Faz a quebra de pagina de acordo com o parametro "Linhas   º±±
±±º          ³ por Pagina?" (mv_par08)                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPL1 - Numero maximo de linhas definido no relatorio      º±±
±±º          ³ EXPL2 - Contador de linhas impressas no relatorio          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ nil                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR470                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F470LinPag(nLinPag, nLinReport)

nLinReport++

If nLinReport > (nLinPag)
	oReport:EndPage()
	nLinReport := 9
EndIf

Return Nil


//------------------------------------------------------- R3 ------------------------------------------------------------------------


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINR470	³ Autor ³ Wagner Xavier 		³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Extrato Banc rio. 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR470(void)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
sTATIC Function FinR470R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1 := STR0001  //"Este programa ir  emitir o relat¢rio de movimenta‡”es"
LOCAL cDesc2 := STR0002  //"banc rias em ordem de data. Poder  ser utilizado para"
LOCAL cDesc3 := STR0003  //"conferencia de extrato."
LOCAL cString:="SE5"

PRIVATE Tamanho := "G" //P/M/G   
PRIVATE titulo:=OemToAnsi(STR0004)  //"Extrato Bancario"
PRIVATE cabec1
PRIVATE cabec2   
PRIVATE cabec3
PRIVATE aReturn := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="FINR470"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg	 :="FIN470"
PRIVATE aCabecAlt := FR470Alt(STR0011)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ajustasx1()                                                               
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros	 			        ³
//³ mv_par01				// Banco 							³
//³ mv_par02				// Agencia							³
//³ mv_par03				// Conta 							³
//³ mv_par04				// a partir de 						³
//³ mv_par05				// ate								³
//³ mv_par06				// Qual Moeda						³
//³ mv_par07				// Demonstra Todos/Conciliados/Nao Conc.³
//³ mv_par08				// Linhas por Pagina  ?			    ³
//³ mv_par09				// Converte Valores pelas ?        
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT 						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FINR470"            //Nome Default do relatorio em Disco
WnRel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao REPORTINI substituir as variaveis.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa470Imp(@lEnd,wnRel,cString)},titulo)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA470IMP ³ Autor ³ Wagner Xavier 		³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Extrato Banc rio. 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA470Imp(lEnd,wnRel,cString)
LOCAL CbCont,CbTxt
LOCAL cBanco,cNomeBanco,cAgencia,cConta
LOCAL nSaldoAtu:=0,nTipo,nSaldoIni:=0
LOCAL cDOC
LOCAL cFil	  :=""
LOCAL cChave
LOCAL cIndex
LOCAL aRecon := {}
Local nTxMoeda := 1
Local nValor := 0
Local aStru 	:= SE5->(dbStruct())
Local nI	:= 0
Local nMoeda	:= GetMv("MV_CENT"+(IIF(mv_par06 > 1 , STR(mv_par06,1),"")))
LOCAL nSalIniStr := 0
LOCAL nSalIniCip := 0
LOCAL nSalIniComp := 0
LOCAL nSalStr := 0
LOCAL nSalCip := 0    
LOCAL nSalComp := 0
LOCAL lSpbInUse := SpbInUse()
Local cFilterUser
Local cTabela14 := ""
Local nLin	:= mv_par08
Local lCxLoja := GetNewPar("MV_CXLJFIN",.F.)
Local cAlias:="SE5"           
Local nTaxa:=0  
Local lTaxa:=.F. 
Local lLayout := aReturn[4] == 1 .And. cPaisLoc == "BRA" //Retrato
Local lMsmMoeda   := .F.
Local cHistor	:= ""
Local aHistor	:= {}
lOCAL nTamHist	:= 50		//Quantidade maxima de caracteres para a coluna do historico. Quando o conteudo desse campos exceder este limite, devera ser impresso em varias linhas
Local cCposQry	:= ""
Local cFilQry	:= ""
Local lFxMultSld := FindFunction( "FXMultSld" )
Local aArea	     
Local cChSef := "" 
Local nSoma := 0
Local cChave2 := ""
Local lGestao := Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
Local cAliasTmp
Local cFilSE5 := IIf(lGestao, FwFilial("SE5"), xFilial("SE5")) 
Local cFilSE8 := IIf(lGestao, FWFilial("SE8"), xFilial("SE8"))
Local aAreaSE5 := {}
Local lExistSE5 := .F.
Local lTop		:= .f.
Local nTamFilSE5 := Len(Alltrim(xFilial("SE5")))
Local nTamFilSA6 := Len(Alltrim(xFilial("SA6")))
Local lMoedBco	:= SuperGetMv("MV_MOEDBCO",,.F.)
Local lMultSld    	:= (FindFunction( "FXMultSld" ) .AND. FXMultSld())
Local nVlCruz		:= 0

#IFDEF TOP
	Local lOracle := "ORACLE"$Upper(TCGetDB())
	Local cDBtype := Alltrim(Upper(TCGetDB()))
	Local cNulo	:= ""
	lTop := .t.
#ENDIF

AAdd( aRecon, {0,0,0,0} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCondWhile, lAllFil :=.F.
Private nMoedaBco 	:= 1
Private nMoedTit		:= 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 80
m_pag 	:= 1

dbSelectArea("SA6")
dbSetOrder(1)
IF !(dbSeek(cFilial+mv_par01+mv_par02+mv_par03))
	Help(" ",1,"BCONOEXIST")
	Return
EndIF
nLin		:=  mv_par08 + 9
cBanco		:= A6_COD
cNomeBanco	:= A6_NREDUZ
cAgencia	:= A6_AGENCIA
cConta		:= A6_NUMCON
nLimCred	:= A6_LIMCRED
nMoedaBco	:=	Max(A6_MOEDA,1)

If !Empty(mv_par08)
	nLin := IIf(MV_PAR08>=65,65,MV_PAR08)
Else
	nLin := 65
EndIf

// Carrega a tabela 14
cTabela14 := FR470Tab14() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMoeda := Upper(GetMv("MV_MOEDA"+LTrim(Str(mv_par06))))

titulo := OemToAnsi((STR0007) + " " + DTOC(mv_par04) + STR0040 +Dtoc(mv_par05)+ STR0039 + cMoeda)  //"EXTRATO BANCARIO ENTRE "

cabec2 := ""
cabec3 := OemToAnsi(STR0008)+ cBanco +" - " + ALLTRIM(cNomeBanco) + OemToAnsi(STR0009)+ cAgencia + OemToAnsi(STR0010)+ cConta  //"BANCO "###"   AGENCIA "###"   CONTA "
If cPaisLoc <> "BRA" .And. mv_par06 <> nMoedaBco  .And. nMoedaBco == 1
	If cPaisLoc == "MEX"
		cabec1 := OemToAnsi(STR0038) + Space(5) + Upper(OemToAnsi(STR0037))  //"DATA     OPERACAO                          DOCUMENTO         PREFIXO/TITULO          ENTRADAS           SAIDAS         SALDO ATUAL"
	Else
		cabec1 := OemToAnsi(STR0011) + Space(5) + Upper(OemToAnsi(STR0037))  //"DATA     OPERACAO                          DOCUMENTO         PREFIXO/TITULO          ENTRADAS           SAIDAS         SALDO ATUAL"
	EndIf	
Else
	If !lLayout //Paisagem   
		If cPaisLoc == "MEX"
			cabec1 := OemToAnsi(STR0038)  //"DATA     OPERACAO                          DOCUMENTO         PREFIXO/TITULO          ENTRADAS           SAIDAS         SALDO ATUAL"				
		Else
			cabec1 := OemToAnsi(STR0011)  //"DATA     OPERACAO                          DOCUMENTO         PREFIXO/TITULO          ENTRADAS           SAIDAS         SALDO ATUAL"	
		EndIf	
	Else
		cabec1 := aCabecAlt[1]  //DATA        DOCUMENTO                                          ENTRADAS          SALDO ATUAL
     	cabec2 := aCabecAlt[2]  //     OPERACAO                        PREFIXO/TITULO          SAIDAS
	EndIf		
EndIf

nTipo  :=IIF(aReturn[4]==1,15,18)
//Filtro do usuario
cFilterUser:=aReturn[7]
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Saldo de Partida 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE8")
dbSetOrder(1)

If lTop .and. Mv_par10 == 2 .AND. FWModeAccess("SA6",3,) == 'C' .and. FWModeAccess("SE8",3,) == 'E' // recompor saldo por Banco

	CalcSldIni(@nSaldoAtu, @nSaldoIni)
Else

	dbSeek( cFilial+cBanco+cAgencia+cConta+Dtos(mv_par04),.T.)
	dbSkip(-1)
	
	IF E8_FILIAL != xFilial("SE8") .Or. E8_BANCO!=cBanco .or. E8_AGENCIA!=cAgencia .or. E8_CONTA!=cConta .or. BOF() .or. EOF()
		nSaldoAtu:=0
		nSaldoIni:=0
	Else
		If mv_par07 == 1  //Todos
			nSaldoAtu:=Round(xMoeda(E8_SALATUA,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
			nSaldoIni:=Round(xMoeda(E8_SALATUA,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)	
		ElseIf mv_par07 == 2 //Conciliados
			nSaldoAtu:=Round(xMoeda(E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
			nSaldoIni:=Round(xMoeda(E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
		ElseIf mv_par07 == 3	//Nao Conciliados
			nSaldoAtu:=Round(xMoeda(E8_SALATUA-E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
			nSaldoIni:=Round(xMoeda(E8_SALATUA-E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
		Endif	
	Endif
EndIf

If lSpbInUse
	nSalIniStr := 0
	nSalIniCip := 0
	nSalIniComp := 0
Endif		

// Deve considerar todas as filiais para selecao dos movimentos na query
lAllFil := Empty( xFilial( "SA6" ) ) .And. !Empty( xFilial( "SE5" ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra o arquivo por tipo e vencimento						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAllFil
	cChave	:= "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
Else
	cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
EndIf

If ExistBlock("F470ALLF")
	lAllFil := ExecBlock("F470ALLF",.F.,.F.,{lAllFil})
EndIf

#IFNDEF TOP	
	dbSelectArea("SE5")
	dbSetOrder(1)
	cIndex	:= CriaTrab(nil,.f.)
	dbSelectArea("SE5")
	IndRegua("SE5",cIndex,cChave,,Nil,OemToAnsi(STR0012))  //"Selecionando Registros..."
	nIndex	:= RetIndex("SE5")
	dbSetIndex(cIndex+OrdBagExt())
	dbSetOrder(nIndex+1)
	cFil:= Iif(lAllFil,"",xFilial("SE5"))
	dbSeek(cFil+DtoS(mv_par04),.T.)
#ELSE
	If TcSrvType() == "AS/400"
		dbSelectArea("SE5")
		dbSetOrder(1)
		cIndex	:= CriaTrab(nil,.f.)
		dbSelectArea("SE5")
		IndRegua("SE5",cIndex,cChave,,Nil,OemToAnsi(STR0012))  //"Selecionando Registros..."
		nIndex	:= RetIndex("SE5")
		dbSetOrder(nIndex+1)
		cFil:= Iif(lAllFil,"",xFilial("SE5"))
		dbSeek(cFil+DtoS(mv_par04),.T.)
	EndIf	
#ENDIF

#IFNDEF TOP
	SetRegua(RecCount())
	If  lAllFil
		cCondWhile := "!Eof() .And. E5_DTDISPO <= mv_par05"
	Else		
		If Empty(cFilSE5) .and. !Empty(cFilSE8)
			cCondWhile := "!Eof() .And. E5_FILIAL == xFilial('SE5') .And. E5_FILORIG == xFilial('SE8') .And. E5_DTDISPO <= mv_par05"
		Else
		
			If nTamFilSE5 == nTamFilSA6 .or. nTamFilSE5 < nTamFilSA6
				cCondWhile := "!Eof() .And. E5_FILIAL == xFilial('SE5') .And. E5_DTDISPO <= mv_par05"
			Else
				cCondWhile := "!Eof() .And. " + Substr(E5_FILIAL,1,nTamFilSA6) + " == " + Substr(xFilial('SE5'),1,nTamFilSA6) + " .And. E5_DTDISPO <= mv_par05"				
			EndIf	
		Endif
	EndIf
#ELSE
	If TcSrvType() != "AS/400"
		SetRegua(0)
		DbSelectArea("SE5")
		DbSetOrder(1)
		cCondWhile := " !Eof() "
		cAlias := If(lSpbInUse, "SE5", "SE5SQ")

		cOrder	  := "E5_DTDISPO, E5_BANCO, E5_AGENCIA, E5_CONTA, E5_NUMCHEQ, E5_DOCUMEN,R_E_C_N_O_,E5_PREFIXO,E5_NUMERO"
		cCposQry  := "E5_FILIAL, E5_DTDISPO, E5_BANCO, E5_AGENCIA, E5_CONTA, E5_NUMCHEQ, E5_FILORIG, "
	          
    	If cPaisloc == "BRA"
			cCposQry += "E5_TIPODOC, E5_MOEDA, E5_DOCUMEN, E5_VALOR, E5_SITUACA, E5_DATA, E5_RECPAG, E5_RECONC, E5_MODSPB, E5_TXMOEDA, E5_VENCTO, E5_KEY, "
		Else
			cCposQry += "E5_TIPODOC, E5_MOEDA, E5_DOCUMEN, E5_VALOR, E5_SITUACA, E5_DATA, E5_RECPAG, E5_RECONC, E5_TXMOEDA, E5_VENCTO, " 
		Endif

		cCposQry += "E5_HISTOR, E5_VLMOED2, E5_MOTBX, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_SEQ "

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Converte filtro de usuario para clausula WHERE da Query      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cFilterUser)
			cFilQry := PcoParseFil(cFilterUser,"SE5")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se nao conseguiu converter o filtro de usuario, traz todos   ³
			//³ os campos para executar o filtro dentro do loop em Advpl     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty( cFilQry )
				cCposQry := "*"			
			EndIf
		EndIf
					
		cQuery := "SELECT " + cCposQry
		cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
		If !lAllFil			
			If nTamFilSE5 == nTamFilSA6 .or. nTamFilSE5 < nTamFilSA6
				cQuery	+=	"E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
			Else
				cQuery	+=	"E5_FILIAL LIKE '" + Substr(xFilial("SE5"),1,nTamFilSA6) + "%'" + " AND "
			EndIf	
			If Empty(cFilSE5) .and. !Empty(cFilSE8)
				cQuery += "	E5_FILORIG = '" + xFilial("SE8") + "' AND " 
			Endif
		Else
		 	if nTamFilSE5 > nTamFilSA6
		 	cQuery +=	"E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
		 	Endif
		EndIf
		cQuery += " E5_DTDISPO >=  '"     + DTOS(mv_par04) + "'"
		If lSpbInuse
			cQuery += " AND ((E5_DTDISPO <=  '"+ DTOS(mv_par05) + "') OR "
			cQuery += " (E5_DTDISPO >=  '"     + DTOS(mv_par05) + "' AND "
		   cQuery += " (E5_DATA >=  '"  		  + DTOS(mv_par04) + "' AND " 
			cQuery += "  E5_DATA <=  '"     	  + DTOS(mv_par05) + "')))"			
		Else			
			cQuery += " AND E5_DTDISPO <=  '"     + DTOS(mv_par05) + "'"
		Endif
		cQuery += " AND E5_BANCO = '"   + cBanco   + "'"
		cQuery += " AND E5_AGENCIA = '" + cAgencia + "'"
		cQuery += " AND E5_CONTA = '"   + cConta   + "'"
		cQuery += " AND NOT ( E5_NUMCHEQ BETWEEN '*              ' AND '*ZZZZZZZZZZZZZZ' ) "
		cQuery += " AND E5_SITUACA <> 'C' "
		cQuery += " AND E5_VALOR <> 0 "
		cQuery += " AND (E5_VENCTO <= '" + DTOS(mv_par05)  + "' OR E5_VENCTO <= E5_DATA) " 
		If mv_par07 == 2
			cQuery += " AND E5_RECONC <> ' ' "
		ElseIf mv_par07 == 3
			cQuery += " AND E5_RECONC = ' ' " 
		EndIf
		cQuery += " AND E5_TIPODOC NOT IN ('DC','JR','MT','CM','D2','J2','M2','C2','V2','CP','TL','BA','I2','EI') "
		cQuery += " AND NOT ( E5_MOEDA IN ('C1','C2','C3','C4','C5','CH') AND E5_NUMCHEQ = '               ' AND ( E5_TIPODOC NOT IN( 'TR', 'TE' ) ) ) "
		cQuery += " AND NOT ( E5_TIPODOC IN ('TR','TE') AND ( ( E5_NUMCHEQ BETWEEN '*              ' AND '*ZZZZZZZZZZZZZZ') OR (E5_DOCUMEN BETWEEN '*                ' AND '*ZZZZZZZZZZZZZZZZ' ))) "
		cQuery += " AND NOT ( E5_TIPODOC IN ('TR','TE') AND E5_NUMERO = '" + Space( TamSX3( "E5_NUMERO" )[1] ) + "' AND E5_MOEDA NOT IN " + FormatIn(cTabela14+"/DO","/") + " ) "
		cQuery += " AND D_E_L_E_T_ = ' ' "
		If !Empty(cFilterUser) .And. !Empty( cFilQry )
			cQuery += "AND (" + cFilQry + ") "
		EndIf
		cQuery += " ORDER BY " + cOrder
	
		cQuery := ChangeQuery(cQuery)

		dbSelectArea("SE5")
		dbCloseArea()

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .T., .T.)
	
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField(cAlias, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	Else		// Se TOP-AS400
		If lAllFil
			cCondWhile := "!Eof() .And. E5_DTDISPO <= mv_par05"
		Else
			cCondWhile := "!Eof() .And. E5_FILIAL == xFilial('SE5') .And. E5_DTDISPO <= mv_par05"
		EndIf
	EndIf
#ENDIF

// Monta arquivo de trabalho (apenas quando usa SPB)
If lSpbInUse
	dbSelectArea("SE5")
	cNomeArq:= CriaTrab("",.F.)
	cIndex  := cNomeArq	
	AAdd( aStru, {"E5_BLOQ"	,"C", 01, 0} )
	FwdbCreate( cNomeArq, aStru )
	//USE &cNomeArq	Alias Trb  NEW
	FWTemporaryTable():New("TRB")
	FWTemporaryTable():SetFields( aStru )
	dbSelectArea("TRB")
	IndRegua("TRB",cIndex,cChave,,,STR0012) //"Selecionando Registros..."		
	dbSetIndex( cNomeArq +OrdBagExt())
	FWTemporaryTable():Create()
	Fr470SPB(cChave, aStru)      
	
Endif

//Filtro do usuario
cFilterUser:=aReturn[7]

If !lLayout//Paisagem
	While &(cCondWhile)
		lExistSE5 := .T.
		If !Empty(E5_TXMOEDA) .And. ( lFxMultSld .AND. FXMultSld() ) 
			If Empty(AllTrim(SE5->E5_KEY)) .And. !(E5_TIPODOC $ "TR/TE")
				If E5_RECPAG == "P"
					lMsmMoeda := Posicione("SE2",1,xFilial("SE2")+(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA),"E2_MOEDA") == mv_par06
				Else
					lMsmMoeda := Posicione("SE1",1,xFilial("SE1")+(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA),"E1_MOEDA") == mv_par06
				EndIf
			ElseIf !(E5_TIPODOC $ "TR/TE")
				lMsmMoeda := VerMoed(nMoedaBco, @nMoedTit,E5_TXMOEDA,.F.,@nVlCruz) == mv_par06
			EndIf
		EndIf
	
		IF lEnd
			@PROW()+1,0 PSAY OemToAnsi(STR0013)  //"Cancelado pelo operador"
			EXIT
		Endif
		
		#IFNDEF TOP
			IncRegua()
			If !Fr470Skip(cBanco,cAgencia,cConta)
				dbSkip()
				Loop
			EndIf	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSkip()
				Loop
			Endif
		#ELSE
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If TcSrvType() == "AS/400"
				If !Fr470Skip(cBanco,cAgencia,cConta)
					dbSkip()
					Loop
				EndIf	
				If !Empty(cFilterUser).and.!(&cFilterUser)
					dbSkip()
					Loop
				Endif
			Else
				If !Empty(cFilterUser) .And. Empty( cFilQry ) 
					If !(&cFilterUser)
						dbSkip()
						Loop
					EndIf	
				EndIf	
			EndIf		
		#ENDIF		
	
		If !Empty( E5_MOTBX )
			If !MovBcoBx( E5_MOTBX )
				dbSkip( )
				Loop
			EndIf
		EndIf
	    
		If E5_TIPODOC=="ES" .and. !lSpbInUse
        	aAreaSE5 := SE5->( GetArea() )
        	cAliasTmp  :=Alias()
			cChave     := E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
        	
           	DbSelectArea("SE5")
	        DbSetOrder(7)
	        DbGoTop()
        	
        	If DbSeek(cChave)
        		If E5_TIPODOC=="V2"
       				DbSelectArea(cAliasTmp)
       				RestArea( aAreaSE5 )
	        		dbSkip()
	        		Loop
	        	EndIf
        	EndIf
			RestArea( aAreaSE5 )
        	DbSelectArea(cAliasTmp)        	
        EndIf
	
		IF li > nLin
			cabec(@titulo,cabec1,cabec2,nomeprog,"G",nTipo)
			@ li, 00 PSAY cabec3
			@ li,153 + Iif( cPaisLoc <> "BRA", Iif( cPaisLoc == "MEX", 15, 4 ), 0 ) PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,nMoeda) 
			li++
		EndIF
		
		If lSpbInUse	
			dbSelectArea("TRB")
		Else
			dbSelectArea(cAlias)
		Endif
	    
		If cPaisLoc<>"BRA" 
			nTaxa := TxMoeda(Iif(lSpbInUse,"TRB",cAlias),nMoedaBco)
			If mv_par09 == 1
				nTxMoedBc := 0 //RecMoeda(dDatabase,nMoedaBco)
			Else
				nTxMoedBc := nTaxa
			Endif
		EndIf
	
		@li, 0 PSAY E5_DTDISPO
		/*
		Imprimi a primeira linha do historico, de acordo com o limite da coluna e caso o tamanho desse campo exceda o limite, distribui em 
		quantas linhas forem necessarias */
		@li,11 PSAY Substr(E5_HISTOR,1,nTamHist)
		aHistor := {}
		cHistor := AllTrim(Substr(E5_HISTOR,nTamHist+1))
		While !Empty(cHistor)
			Aadd(aHistor,Substr(cHistor,1,nTamHist))
			cHistor := Substr(cHistor,nTamHist+1)
		Enddo
		
		cDoc := E5_NUMCHEQ
		
		IF Empty( cDoc )
			cDoc := E5_DOCUMEN
		Endif
		
		IF Len(Alltrim(SUBSTR(E5_DOCUMEN,1,35))) + Len(Alltrim(E5_NUMCHEQ)) > 50
			cDoc := Alltrim(SUBSTR(E5_DOCUMEN,1,35)) +if(!empty(Alltrim(E5_DOCUMEN)),"-"," ") + Alltrim(E5_NUMCHEQ )
		Endif
		
		If Substr( cDoc ,1, 1 ) == "*"
			/*
			Imprimi as demais linhas do historico, se o tamanho do campo excedeu limite da coluna*/
			If !Empty(aHistor)
				For nI := 1 To Len(aHistor)
					li++
					If li > nLin
						cabec(@titulo,cabec1,cabec2,nomeprog,"G",nTipo)
						@ li, 00 PSAY cabec3
						@ li,153 + Iif(cPaisLoc <> "BRA", Iif( cPaisLoc == "MEX", 15, 4 ), 0 ) PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,nMoeda) 
						li++
					EndIf
					@li,12 PSAY aHistor[nI]
				Next
			Else
				li++
			Endif
			dbSkip( )
			Loop
		Endif
		
		@li,076 PSAY IIF(AllTrim(cDoc) == ""," ",AllTrim(cDoc))
		
		cChSef := ""
		//Caso seja um registro gerado de uma baixa de cheque tipo "CH" deve-se procurar em outro arquivo.
		If E5_TIPODOC = "CH"
			aArea	:= GetArea()
			cChSef := (xFilial("SE5")+E5_NUMCHEQ+E5_BANCO+E5_AGENCIA+E5_CONTA)
			SEF->(dbSetOrder(4))
			If SEF->(Dbseek(cChSef))
				dbSelectArea("SEF")			
				While !EOF() .and. (EF_FILIAL+EF_NUM+EF_BANCO+EF_AGENCIA+EF_CONTA) = cChSef  .and. nSoma <= 1
					If !Empty(EF_TIPO)
						nSoma++
						cChave2 := EF_PREFIXO+IIF(EMPTY(EF_PREFIXO)," ","-")+AllTrim(EF_TITULO)+IIF(EMPTY(EF_PARCELA)," ","-")+EF_PARCELA
					Endif
					SEF->(Dbskip())
				Enddo
			Else
				cChSef := (E5_FILORIG+E5_NUMCHEQ+E5_BANCO+E5_AGENCIA+E5_CONTA)			
				dbSelectArea("SEF")							
				SEF->(dbSetOrder(4))
				SEF->(Dbseek(cChSef))
				While !EOF() .and. (EF_FILIAL+EF_NUM+EF_BANCO+EF_AGENCIA+EF_CONTA) = cChSef  .and. nSoma <= 1
					If !Empty(EF_TIPO)
						nSoma++
						cChave2 := EF_PREFIXO+IIF(EMPTY(EF_PREFIXO)," ","-")+AllTrim(EF_TITULO)+IIF(EMPTY(EF_PARCELA)," ","-")+EF_PARCELA
					Endif
					SEF->(Dbskip())
				Enddo
			EndIf	
			If nSoma = 1
				@li,094 PSAY cChave2
				nSoma := 0
			Endif
			
			dbCloseArea()
			RestArea(aArea)
			nSoma := 0
		Else
		   @li,094 PSAY E5_PREFIXO+IIF(EMPTY(E5_PREFIXO)," ","-")+AllTrim(E5_NUMERO)+;
		       					 IIF(EMPTY(E5_PARCELA)," ","-")+E5_PARCELA 		
		Endif
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VerIfica se foi utilizada taxa contratada para moeda > 1          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTxMoedBc 	:= 0 
	
		If SE5->(FieldPos('E5_TXMOEDA')) > 0 .And.  E5_TXMOEDA > 0
			nTxMoedBc := E5_TXMOEDA	
		ElseIf Empty(E5_MOEDA) .Or. (!Empty(E5_MOEDA).And. Val(E5_MOEDA)==1)
			nTxMoedBc :=E5_VALOR/E5_VLMOED2
		Else
			nTxMoedBc :=E5_VLMOED2/E5_VALOR
		Endif   
			
	    If cPaisloc<>"BRA" 
			If mv_par09 == 1
				nTxMoedBc := 0 //RecMoeda(dDatabase,nMoedaBco)
			Else
				nTxMoedBc := nTaxa
			Endif
		EndIf
	
   		nTxMoeda 	:= If(nTxMoedBc > 1, nTxMoedBc, RecMoeda(iif(MV_PAR09==1,dDataBase,E5_DTDISPO),mv_par06))		
		
		If Empty(AllTrim(SE5->E5_KEY)) .And. !(E5_TIPODOC $ "TR/TE")
			nMoedTit	:= VerMoed(nMoedaBco, @nMoedTit,E5_TXMOEDA,.F.,@nVlCruz)
		EndIf
		// Se realiza controle de saldos em multiplas moedas
		If ( lFxMultSld .AND. FXMultSld() )
			If lMoedBco .And. !(E5_TIPODOC $ "TR/TE")
				If !Empty(AllTrim(SE5->E5_KEY))
					nMoedTit := VerMoed(nMoedaBco, @nMoedTit,E5_TXMOEDA,.F.,@nVlCruz)
				EndIf
	
					ConvMoed(Alias(),nMoeda,lMsmMoeda,,.F.,@nValor)
			Else
				nValor   := Round(xMoeda( F470VlMoeda(cAlias),;
												nMoedaBco,;
												mv_par06,;
												IIF(MV_PAR09==1,dDataBase,E5_DTDISPO),;
												nMoeda + 1,;
												IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(Iif(lSpbInUse,"TRB",cAlias), nMoedaBco)),;
												IIF(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,E5_DTDISPO),mv_par06),E5_TXMOEDA) ),nMoeda)
			EndIf
		Else
			If lMoedBco .And. !(E5_TIPODOC $ "TR/TE")
				If !Empty(AllTrim(SE5->E5_KEY))
					nMoedTit := VerMoed(nMoedaBco, @nMoedTit,E5_TXMOEDA,.F.,@nVlCruz)
				EndIf
	
				ConvMoed(Alias(),nMoeda,lMsmMoeda,,.F.,@nValor)
			Else
				nValor   := Round(xMoeda(E5_VALOR,;
									Iif((cPaisLoc<>"BRA".And.(E5_TIPODOC $ MVRECANT+"|ES") .and. Empty(E5_MOEDA)),1, nMoedaBco ),;
									mv_par06,;
									iif(MV_PAR09==1,dDataBase,E5_DTDISPO),;
									nMoeda+1,;
									Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",	IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ) , TxMoeda("SE5", nMoedaBco) ),nTxMoedBc)),;
									Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda(IIf(MV_PAR09==1,dDataBase,E5_DTDISPO),mv_par06),nTxMoeda))),nMoeda)
			EndIf
		EndIf


		IF E5_RECPAG="R"
			@li,118 + Iif(cPaisLoc <> "BRA", Iif( cPaisLoc == "MEX", 13, 2 ), 0 ) PSAY nValor Picture tm(nValor,15,nMoeda) //ENTRADAS
			nSaldoAtu += nValor
			If Empty( E5_RECONC )
				aRecon[1][REC_NAO_CONCILIADO] += nValor
			Else
				aRecon[1][REC_CONCILIADO] += nValor
			EndIf
			If lSpbInUse
				//Adiantamentos sao sempre STR
				If E5_TIPO $ MVRECANT
						nSalSTR += nValor
				Else
					// Saldo STR ou transformados em STR
	  				If E5_MODSPB $ " 1" .or. (E5_MODSPB $ "2/3" .AND. Empty(E5_BLOQ))
						nSalSTR += nValor
	  				ElseIf E5_MODSPB == "2" //CIP
						nSalCIP += nValor
	  				ElseIf E5_MODSPB == "3" //COMP
						nSalCOMP += nValor
				   Endif
				Endif
			Endif	
		Else
			@li,137 + Iif( cPaisLoc <> "BRA", Iif( cPaisLoc == "MEX", 14, 3 ), 0 ) PSAY nValor Picture tm(nValor,15,nMoeda) 
			nSaldoAtu -= nValor
			If Empty( E5_RECONC )
				aRecon[1][PAG_NAO_CONCILIADO] += nValor
			Else
				aRecon[1][PAG_CONCILIADO] += nValor
			EndIf
			If lSpbInUse
				//Adiantamentos sao sempre STR
				If E5_TIPO $ MVPAGANT
					nSalSTR -= nValor
				Else
					// Saldo STR ou transformados em STR
	  				If E5_MODSPB $ " 1" .or. (E5_MODSPB $ "2/3" .AND. Empty(E5_BLOQ))
						nSalSTR -= nValor
	  				ElseIf E5_MODSPB == "2" //CIP
						nSalCIP -= nValor
	  				ElseIf E5_MODSPB == "3" //COMP
						nSalCOMP -= nValor
				   Endif
				Endif
			Endif	
		Endif
		@li,153 + Iif( cPaisLoc <> "BRA", Iif( cPaisLoc == "MEX", 15, 4 ), 0 ) PSAY nSaldoAtu Picture tm(nSaldoAtu,16,nMoeda) 
		If cPaisLoc <> "BRA" .And. mv_par06 <> nMoedaBco .And. mv_par06 > 1  
			If nTaxa == 0
				nTaxa := IIf(!lMsmMoeda,	IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAlias, nMoedaBco) ) ,E5_TXMOEDA)
			EndIf
			//@li,165  + Iif(cPaisLoc <> "BRA", Iif( cPaisLoc == "MEX", 15, 4 ), 0 )   PSAY nTaxa Picture tm(nSaldoAtu,16,nMoeda) 
			@li,165  + Iif(cPaisLoc <> "BRA", Iif( cPaisLoc == "MEX", 15, 4 ), 0 ) PSAY If(nTxMoedBc > 1, nTxMoedBc, RecMoeda(iif(MV_PAR09==1,dDataBase,E5_DTDISPO),mv_par06)) Picture tm(nSaldoAtu,16,nMoeda) 
		EndIf	
	   If lSpbInUse
			If (E5_MODSPB $ "2/3" .AND. !Empty(E5_BLOQ))
				@li,pCol() + 1 PSAY E5_BLOQ 
			Endif	
		Endif                 
		
		@li,pCol()+1 pSay Iif(Empty(E5_RECONC), " ", "x")
		
		/*
		Imprimi as demais linhas do historico, se o tamanho do campo excedeu limite da coluna*/
		If !Empty(aHistor)
			For nI := 1 To Len(aHistor)
				li++
				If li > nLin
					cabec(@titulo,cabec1,cabec2,nomeprog,"G",nTipo)
					@ li, 00 PSAY cabec3
					@ li,153 + Iif(cPaisLoc <> "BRA", Iif( cPaisLoc == "MEX", 15, 4 ), 0 ) PSAY nSaldoAtu Picture tm(nSaldoAtu,16,nMoeda) 
					li++
				EndIf
				@li,11 PSAY aHistor[nI]
			Next
		Endif
		
		If lSpbInUse	
			dbSelectArea("TRB")
		Else
			dbSelectArea(cAlias)
		Endif  
		li+=1
		dbSkip()
	EndDo 

	If ((li > nLin - 5 .And. nLin > 42) .or. ( li > 58)) .Or. !lExistSE5
		cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		@ li, 00 PSAY cabec3
		@ li,153 + Iif(cPaisLoc <> "BRA", Iif( cPaisLoc == "MEX", 15, 4 ), 0 ) PSAY nSaldoAtu Picture tm(nSaldoAtu,16,nMoeda) 
		li++
	Endif
	
	li+=2
	@li,051 + Iif(cPaisLoc <> "BRA", Iif( cPaisLoc == "MEX", 15, 4 ), 0 ) PSAY OemToAnsi(STR0014)  //"SALDO INICIAL...........: "
	@li,153 + Iif(cPaisLoc <> "BRA", Iif( cPaisLoc == "MEX", 15, 4 ), 0 ) PSAY nSaldoIni Picture tm(nSaldoIni,16,nMoeda)
	
	li++
	If (li > nLin - 5 .And. nLin > 42) .or. ( li > 58)
		cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		@ li, 00 PSAY cabec3
		@ li,153 + Iif(cPaisLoc <> "BRA", Iif( cPaisLoc == "MEX", 15, 4 ), 0 ) PSAY nSaldoAtu Picture tm(nSaldoAtu,16,nMoeda) 
		li++
	Endif
	@li,118  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 13, 2 ),0) PSAY OemToAnsi(STR0015)  //"NAO CONCILIADOS"
	@li,140  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 14, 3 ),0) PSAY OemToAnsi(STR0016)  //"    CONCILIADOS"
	@li,164  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY OemToAnsi(STR0017)  //"          TOTAL"
	
	li++
	@li,051  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY OemToAnsi(STR0018)  //"ENTRADAS NO PERIODO.....: "
	@li,118  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 13, 2 ),0) PSAY aRecon[1][REC_NAO_CONCILIADO] PicTure tm(aRecon[1][1],15,nMoeda)
	@li,136  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 14, 3 ),0) PSAY aRecon[1][REC_CONCILIADO] PicTure tm(aRecon[1][2],15,nMoeda)
	@li,153  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY aRecon[1][REC_CONCILIADO] + aRecon[1][REC_NAO_CONCILIADO] PicTure tm((aRecon[1][1]+aRecon[1][2]),16,nMoeda)
	
	li++
	If (li > nLin - 5 .And. nLin > 42) .or. ( li > 58)
		cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		@ li, 00 PSAY cabec3
		@ li,153 + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,nMoeda) 
		li++
	Endif
	@li,051  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY OemToAnsi(STR0019)  //"SAIDAS NO PERIODO ......: "
	@li,118  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 13, 2 ),0) PSAY aRecon[1][PAG_NAO_CONCILIADO] PicTure tm(aRecon[1][3],15,nMoeda)
	@li,136  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 14, 3 ),0) PSAY aRecon[1][PAG_CONCILIADO] PicTure tm(aRecon[1][4],15,nMoeda)
	@li,153  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY aRecon[1][PAG_CONCILIADO] + aRecon[1][PAG_NAO_CONCILIADO] PicTure tm((aRecon[1][3]+aRecon[1][4]),16,nMoeda)
	
	If lSpbInUse
	
		nSalStr += nSaldoAtu - (nSalStr+nSalCIP+nSalCOMP)
		li+=2
		If (li > nLin - 5 .And. nLin > 42) .or. ( li > 58)
			cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			@ li, 00 PSAY cabec3
			@ li,153 + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,nMoeda) 
			li++
		Endif
		@li,051  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY STR0022 //"SALDO DISPONIVEL........: "
		@li,153  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY nSalSTR	Picture tm(nSalSTR,16,nMoeda)
		
		li++
		@li,051  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY STR0023 //"SALDO BLOQUEADO CIP (2).: "
		@li,153  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY nSalCIP	Picture tm(nSalCIP,16,nMoeda)
		
		li++
		@li,051  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY STR0024 //"SALDO BLOQUEADO COMP (3):"
		@li,153  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY nSalCOMP	Picture tm(nSalCOMP,16,nMoeda)
	Endif
	
	li++
	If (li > nLin - 5 .And. nLin > 42) .or. ( li > 58)
		cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		@ li, 00 PSAY cabec3
		@ li,153 + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,nMoeda) 
		li++
	Endif
	@li,051  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY OemToAnsi(STR0021)  //"LIMITE DE CREDITO ......: "
	@li,153  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY nLimCred Picture tm(nLimCred,16,nMoeda)
	
	li+=2
	nSaldoAtu += nLimCred
	If (li > nLin - 5 .And. nLin > 42) .or. ( li > 58)
		cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		@ li, 00 PSAY cabec3
		@ li,153 + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,nMoeda) 
		li++
	Endif
	@li,051  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY OemToAnsi(STR0020)  //"SALDO ATUAL ............: "
	@li,153  + Iif(cPaisLoc <> "BRA",Iif( cPaisLoc == "MEX", 15, 4 ),0) PSAY nSaldoAtu	Picture tm(nSaldoAtu,16,nMoeda) 
	
Else //Retrato	
	Tamanho := "M"
	While &(cCondWhile)
		If !Empty(E5_TXMOEDA) .And. ( lFxMultSld .AND. FXMultSld() )
			If Empty(Alltrim(SE5->E5_KEY)) .And. !(E5_TIPODOC $ "TR/TE")
				If E5_RECPAG == "P"
					lMsmMoeda := Posicione("SE2",1,xFilial("SE2")+(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA),"E2_MOEDA") == mv_par06
				Else
					lMsmMoeda := Posicione("SE1",1,xFilial("SE1")+(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA),"E1_MOEDA") == mv_par06
				EndIf
			ElseIf !(E5_TIPODOC $ "TR/TE")
				lMsmMoeda := VerMoed(nMoedaBco, @nMoedTit,E5_TXMOEDA,.F.,@nVlCruz) == mv_par06
			EndIf
		EndIf
	
		IF lEnd
			@PROW()+1,0 PSAY OemToAnsi(STR0013)  //"Cancelado pelo operador"
			EXIT
		Endif
		
		#IFNDEF TOP
			IncRegua()
			If !Fr470Skip(cBanco,cAgencia,cConta)
				dbSkip()
				Loop
			EndIf	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSkip()
				Loop
			Endif
		#ELSE
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If TcSrvType() == "AS/400"
				If !Fr470Skip(cBanco,cAgencia,cConta)
					dbSkip()
					Loop
				EndIf	
				If !Empty(cFilterUser).and.!(&cFilterUser)
					dbSkip()
					Loop
				Endif
			Else
				If !Empty(cFilterUser) .And. Empty( cFilQry ) 
					If !(&cFilterUser)
						dbSkip()
						Loop
					EndIf	
				EndIf	
			EndIf		
		#ENDIF		
	
		If !Empty( E5_MOTBX )
			If !MovBcoBx( E5_MOTBX )
				dbSkip( )
				Loop
			EndIf
		EndIf
	
		IF li > nLin
			cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			@ li, 00 PSAY cabec3
			@ li, 099 PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,nMoeda) 
			li+=2
		EndIF
		
		If lSpbInUse	
			dbSelectArea("TRB")
		Else
			dbSelectArea(cAlias)
		Endif
	    
		If cPaisLoc<>"BRA"
			nTaxa := TxMoeda(Iif(lSpbInUse,"TRB",cAlias),nMoedaBco)
		EndIf
	
		cDoc := E5_NUMCHEQ
		
		IF Empty( cDoc )
			cDoc := E5_DOCUMEN
		Endif
		
		IF Len(Alltrim(SUBSTR(E5_DOCUMEN,1,35))) + Len(Alltrim(E5_NUMCHEQ)) > 50
			cDoc := Alltrim(SUBSTR(E5_DOCUMEN,1,35)) +if(!empty(Alltrim(E5_DOCUMEN)),"-"," ") + Alltrim(E5_NUMCHEQ )
		Endif
		
		If Substr( cDoc ,1, 1 ) == "*"
			li++
			dbSkip( )
			Loop
		Endif
		
		@li,0 PSAY E5_DTDISPO 

		@li,11 PSAY IIF(AllTrim(cDoc) == ""," ",AllTrim(cDoc))	      
		
		cChSef := ""
		//Caso seja um registro gerado de uma baixa de cheque tipo "CH" deve-se procurar em outro arquivo.
		If E5_TIPODOC = "CH"
	     cChSef := (xFilial("SE5")+E5_NUMCHEQ+E5_BANCO+E5_AGENCIA+E5_CONTA)
	     aArea	:= GetArea()	     
	     dbSelectArea("SEF")
	     dbSetOrder(4)
		  SEF->(Dbseek(cChSef))
		  While !EOF() .and. (xFilial("SEF")+EF_NUM+EF_BANCO+EF_AGENCIA+EF_CONTA) = cChSef
		    If !Empty(EF_TIPO)
            @li,37 PSAY EF_PREFIXO+IIF(EMPTY(EF_PREFIXO)," ","-")+EF_TITULO+;
		       					 IIF(EMPTY(EF_PARCELA)," ","-")+EF_PARCELA 		
		    Endif
		    SEF->(Dbskip())
		  Enddo
		  	dbCloseArea()
         RestArea(aArea)
		Else
		   @li,37 PSAY E5_PREFIXO+IIF(EMPTY(E5_PREFIXO)," ","-")+E5_NUMERO+;
		  					   IIF(EMPTY(E5_PARCELA)," ","-")+E5_PARCELA  	
		Endif									
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VerIfica se foi utilizada taxa contratada para moeda > 1          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTxMoedBc 	:= 0 
		
	
		If SE5->(FieldPos('E5_TXMOEDA')) > 0 .And.  E5_TXMOEDA > 0
			nTxMoedBc := E5_TXMOEDA	
		ElseIf Empty(E5_MOEDA) .Or. (!Empty(E5_MOEDA).And. Val(E5_MOEDA)==1)
			nTxMoedBc :=E5_VALOR/E5_VLMOED2
		Else
			nTxMoedBc :=E5_VLMOED2/E5_VALOR
		Endif   
			
	    If cPaisloc<>"BRA" 
			nTxMoedBc := 0
		EndIf	                                                                                                 
		
		nTxMoeda := If(nTxMoedBc > 1, nTxMoedBc, IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda("SE5", nMoedaBco) ))		
			
		// Se realiza controle de saldos em multiplas moedas
		If ( lFxMultSld .AND. FXMultSld() )
			If lMoedBco .And. !(E5_TIPODOC $ "TR/TE")

				If !Empty(AllTrim(SE5->E5_KEY))
					nMoedTit := VerMoed(nMoedaBco, @nMoedTit,E5_TXMOEDA,.F.,@nVlCruz)
				EndIf
	
					ConvMoed(Alias(),nMoeda,lMsmMoeda,,.F.,@nValor)
			Else
				nValor   := Round(xMoeda(F470VlMoeda(cAlias),;
										 nMoedaBco ,;
										 mv_par06,;
										 iif(MV_PAR09==1,dDataBase,E5_DTDISPO),;
										 nMoeda + 1,;
										 IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda("SE5", nMoedaBco) ),;
										 IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,E5_DTDISPO),mv_par06),E5_TXMOEDA)),nMoeda)
			EndIf
		Else
			If lMoedBco .And. !(E5_TIPODOC $ "TR/TE")
				ConvMoed(Alias(),nMoeda,lMsmMoeda,,.F.,@nValor)
			Else
				nValor   := Round(xMoeda(F470VlMoeda(cAlias),;
										Iif((cPaisLoc<>"BRA".And.(E5_TIPODOC $ MVRECANT+"|ES") .and. Empty(E5_MOEDA)),1, Val(E5_MOEDA)),;
										mv_par06,;
										iif(MV_PAR09==1,dDataBase,E5_DTDISPO),;
										nMoeda+1;
										,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda("SE5", nMoedaBco) ),nTxMoedBc));
										,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda(IIf(MV_PAR09==1,dDataBase,E5_DTDISPO),mv_par06),nTxMoedBc))),nMoeda)
			EndIf	
		EndIf
	
		If E5_RECPAG == "P"
			@li,82 PSAY nValor Picture tm(nValor,15,nMoeda) 
			nSaldoAtu -= nValor
			If Empty( E5_RECONC )
				aRecon[1][PAG_NAO_CONCILIADO] += nValor
			Else
				aRecon[1][PAG_CONCILIADO] += nValor
			EndIf
			If lSpbInUse
				//Adiantamentos sao sempre STR
				If E5_TIPO $ MVPAGANT
					nSalSTR -= nValor
				Else
					// Saldo STR ou transformados em STR
	  				If E5_MODSPB $ " 1" .or. (E5_MODSPB $ "2/3" .AND. Empty(E5_BLOQ))
						nSalSTR -= nValor
	  				ElseIf E5_MODSPB == "2" //CIP
						nSalCIP -= nValor
	  				ElseIf E5_MODSPB == "3" //COMP
						nSalCOMP -= nValor
				   Endif
				Endif
			Endif	
		Else
			@li,65 PSAY nValor Picture tm(nValor,15,nMoeda) 
			nSaldoAtu += nValor
			If Empty( E5_RECONC )
				aRecon[1][REC_NAO_CONCILIADO] += nValor
			Else
				aRecon[1][REC_CONCILIADO] += nValor
			EndIf
			If lSpbInUse
				//Adiantamentos sao sempre STR
				If E5_TIPO $ MVRECANT
						nSalSTR += nValor
				Else
					// Saldo STR ou transformados em STR
	  				If E5_MODSPB $ " 1" .or. (E5_MODSPB $ "2/3" .AND. Empty(E5_BLOQ))
						nSalSTR += nValor
	  				ElseIf E5_MODSPB == "2" //CIP
						nSalCIP += nValor
	  				ElseIf E5_MODSPB == "3" //COMP
						nSalCOMP += nValor
				   Endif
				Endif
			Endif	      
		EndIf

		@li++,99 PSAY nSaldoAtu Picture tm(nSaldoAtu,16,nMoeda) 
		@pRow(),pCol()+1 pSay Iif(Empty(E5_RECONC), " ", "x")

		///////////////////////////
		//    Quebra de Linha    //
		///////////////////////////  
					
		@li,5 PSAY E5_HISTOR
			
	    If lSpbInUse
			If (E5_MODSPB $ "2/3" .AND. !Empty(E5_BLOQ))
				@li,pCol() + 1 PSAY E5_BLOQ 
			Endif	
		Endif
		
		If lSpbInUse	
			dbSelectArea("TRB")
		Else
			dbSelectArea(cAlias)
		Endif   
		li+=1
		dbSkip()
	EndDo

	If (li > nLin - 5 .And. nLin > 42) .or. ( li > 58)
		cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		@ li, 00 PSAY cabec3
		@ li, 99 PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,nMoeda) 
		li+=2
	Endif
	
	li+=2
	@li,010 PSAY OemToAnsi(STR0014)  //"SALDO INICIAL...........: "
	@li,099 PSAY nSaldoIni Picture tm(nSaldoIni,16,nMoeda)
	
	li+=2
	If (li > nLin - 5 .And. nLin > 42) .or. ( li > 58)
		cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		@ li, 00 PSAY cabec3
		@ li, 99 PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,nMoeda) 
		li+=2
	Endif
	@li,079 PSAY OemToAnsi(STR0015)  //"NAO CONCILIADOS"
	@li,101 PSAY OemToAnsi(STR0016)  //"    CONCILIADOS"
	@li,125 PSAY OemToAnsi(STR0017)  //"          TOTAL"
	
	li++
	@li,010  PSAY OemToAnsi(STR0018)  //"ENTRADAS NO PERIODO.....: "
	@li,079  PSAY aRecon[1][REC_NAO_CONCILIADO] PicTure tm(aRecon[1][1],15,nMoeda)
	@li,097  PSAY aRecon[1][REC_CONCILIADO] PicTure tm(aRecon[1][2],15,nMoeda)
	@li,114  PSAY aRecon[1][REC_CONCILIADO] + aRecon[1][REC_NAO_CONCILIADO] PicTure tm((aRecon[1][1]+aRecon[1][2]),16,nMoeda)
	
	li++
	If (li > nLin - 5 .And. nLin > 42) .or. ( li > 58)
		cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		@ li, 00 PSAY cabec3
		@ li, 99 PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,nMoeda) 
		li+=2
	Endif
	@li,010  PSAY OemToAnsi(STR0019)  //"SAIDAS NO PERIODO ......: "
	@li,079  PSAY aRecon[1][PAG_NAO_CONCILIADO] PicTure tm(aRecon[1][3],15,nMoeda)
	@li,097  PSAY aRecon[1][PAG_CONCILIADO] PicTure tm(aRecon[1][4],15,nMoeda)
	@li,114  PSAY aRecon[1][PAG_CONCILIADO] + aRecon[1][PAG_NAO_CONCILIADO] PicTure tm((aRecon[1][3]+aRecon[1][4]),16,nMoeda)
	
	If lSpbInUse
	
		nSalStr += nSaldoAtu - (nSalStr+nSalCIP+nSalCOMP)
		li+=2
		If (li > nLin - 5 .And. nLin > 42) .or. ( li > 58)
			cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			@ li, 00 PSAY cabec3
			@ li, 99 PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,nMoeda) 
			li+=2
		Endif
		@li,010  PSAY STR0022 //"SALDO DISPONIVEL........: "
		@li,114  PSAY nSalSTR	Picture tm(nSalSTR,16,nMoeda)
		
		li++
		@li,010  PSAY STR0023 //"SALDO BLOQUEADO CIP (2).: "
		@li,114  PSAY nSalCIP	Picture tm(nSalCIP,16,nMoeda)
		
		li++
		@li,010  PSAY STR0024 //"SALDO BLOQUEADO COMP (3):"
		@li,114  PSAY nSalCOMP	Picture tm(nSalCOMP,16,nMoeda)
	Endif
	
	li++
	If (li > nLin - 5 .And. nLin > 42) .or. ( li > 58)
		cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		@ li, 00 PSAY cabec3
		@ li, 99 PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,nMoeda) 
		li+=2
	Endif
	@li,010  PSAY OemToAnsi(STR0021)  //"LIMITE DE CREDITO ......: "
	@li,114  PSAY nLimCred Picture tm(nLimCred,16,nMoeda)
	
	li+=2
	nSaldoAtu += nLimCred
	If (li > nLin - 5 .And. nLin > 42) .or. ( li > 58)
		cabec(@titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		@ li, 00 PSAY cabec3
		@ li, 99 PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,nMoeda) 
		li+=2
	Endif
	@li,010  PSAY OemToAnsi(STR0020)  //"SALDO ATUAL ............: "
	@li,099  PSAY nSaldoAtu	Picture tm(nSaldoAtu,16,nMoeda)
EndIf                                                              

IF li != 80
	roda(cbcont,cbtxt,Tamanho)
EndIF

Set Device To Screen

#IFNDEF TOP
	dbSelectArea("SE5")
	RetIndex( "SE5" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
   If TcSrvType() != "AS/400"
		dbSelectArea(cAlias)
		dbCloseArea()
		ChKFile(cAlias)
   	dbSelectArea("SE5")
		dbSetOrder(1)
	Else
		dbSelectArea("SE5")
		RetIndex( "SE5" )
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
		dbSetOrder(1)
	Endif
#ENDIF

If lSpbInUse
	dbSelectArea("TRB")
	dbCloseArea()
	Ferase(cNomeArq+GetDBExtension())
	Ferase(cNomeArq+OrdBagExt())
Endif
If aReturn[5] = 1
	Set Printer To
	dbCommit()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr470Skip ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 13.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR470.PRX												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr470Skip(cBanco,cAgencia,cConta)
Local lRet := .T.                                
Local cTabela14	:= ""   
// Carrega a tabela 14
cTabela14 := FR470Tab14() 


IF E5_TIPODOC $ "BA/DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL/I2/EI"   //Valores de Baixas
	lRet := .F.
ElseIF !(Alltrim(E5_BANCO+E5_AGENCIA+E5_CONTA)==Alltrim(cBanco+cAgencia+cConta))
	lRet := .F.
ElseIF E5_SITUACA = "C"    //Cancelado
	lRet := .F.
ElseIF E5_VALOR = 0
	lRet := .F.
ElseIF E5_VENCTO > mv_par05 .or. E5_VENCTO > E5_DATA
	lRet := .F.
ElseIf SubStr(E5_NUMCHEQ,1,1)=="*" 
	lRet := .F.
ElseIf (mv_par07 == 2 .and. Empty(E5_RECONC)) .or. (mv_par07 == 3 .and. !Empty(E5_RECONC))
	lRet := .F.
ElseIf E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
	lRet := .F.
ElseIf E5_TIPODOC $ "TR/TE" .and. (Substr(E5_NUMCHEQ,1,1)=="*" .or. Substr(E5_DOCUMEN,1,1) == "*" )
	lRet := .F.
ElseIf E5_TIPODOC $ "TR/TE" .and. Empty(E5_NUMERO) .and. !(E5_MOEDA $ cTabela14+IIf(cPaisLoc=="BRA","","/$ "))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Na transferencia somente considera nestes numerarios 		 ³
	//³ No Fina100 ‚ tratado desta forma.                    		 ³
	//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
	//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
    //³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
    //³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
    //³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet := .F.
Endif

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr470Spb  ³ Autor ³ Mauricio Pequim Jro   ³ Data ³ 23.03.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta arquivo de tranbalho para SPB                      )  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR470.PRX												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr470SPB(cChave, aStruct)

Local cCondTrb := iiF(lAllFil, ".T.",'E5_FILIAL == xFilial("SE5")')
Local nX

DbselectArea("SE5")
While !Eof() .and. &(cCondTrb)
	If (E5_DATA >= mv_par04 .and. E5_DATA <= MV_PAR05 .AND.E5_DTDISPO > MV_PAR05) .OR. (E5_DTDISPO <= MV_PAR05)
		RecLock( "TRB", .T. )
		For nX := 1 to Len( aStruct )   // Até o campo anterior a TRB->E5_BLOQ
			If SE5->(FieldName(nx))<>"E5_BLOQ"
				dbSelectArea("SE5")
				xConteudo := FieldGet( nX )
				dbSelectArea("TRB")
				FieldPut( TRB->(FieldPos(SE5->(FieldName(nx)))),	xConteudo )
			EndIf
		Next nX
		If (E5_DATA <= MV_PAR05 .AND.E5_DTDISPO > MV_PAR05 ) .or. ;
			(E5_DATA <= MV_PAR05 .AND.E5_MODSPB == "2" .and. E5_DTDISPO == MV_PAR05 .AND.;
			(dDataBase == E5_DTDISPO .and. ;
			((E5_RECPAG == "R" .and. E5_TIPODOC != "ES") .or. (E5_RECPAG == "P" .and. E5_TIPODOC == "ES"))) )
			TRB->E5_DTDISPO	:= TRB->E5_DATA
			TRB->E5_BLOQ		:= SE5->E5_MODSPB
		Endif	
		msUnlock()
   Endif                                                     
   DbselectArea("SE5")
   DBsKIP()
Enddo
dbselectArea("TRB")
dbGotop()
Return
             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Nilton Pereira      º Data ³27.04.2004   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Insere novas perguntas ao sx1                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA040                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
Static Function AjustaSX1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
Local aArea := GetArea()

Aadd( aHelpPor, "Informe o numero de linhas que serao "    )
Aadd( aHelpPor, "impressas .     "    )

Aadd( aHelpSpa, "Informe el numero de lineas que se "    )
Aadd( aHelpSpa, "imprimiran.      "    )

Aadd( aHelpEng, "Enter the number of lines to be "    )
Aadd( aHelpEng, "printed .  "    )

PutSx1( "FIN470", "08","Linhas por Pagina  ?","Lineas por Pagina  ?","Lines per Page  ?","mv_ch8","N",2,0,0,"G","","","","",;
	"mv_par08"," ","","","55","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

//Incluso pergunta para considerar a taxa contratada ou taxa da data base	
Aadd( aHelpPor, "Selecione qual a taxa sera utilizada "    )
Aadd( aHelpPor, "para a conversao do valores .     "    )
Aadd( aHelpSpa, "Seleccione la tasa que se utilisara "    )
Aadd( aHelpSpa, "para la conversion de los valores . "    )
Aadd( aHelpEng, "Select the rate to be used in order "    )
Aadd( aHelpEng, "to convert values  .  "    )

PutSx1( "FIN470", "09","Converte valores pela  ?","Conv. valores por la","Convert values by ?","mv_ch9","C",2,0,0,"C","","","","",;
	"mv_par09","Data Base","Tasa dia","Daily Rate","","Data Movimento","Tasa Movimiento","Movement Rate","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	
PutSX1Help("P.FIN47009.",aHelpPor,aHelpEng,aHelpSpa,.T.)		
	
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

//Incluso pergunta para considerar a taxa contratada ou taxa da data base	
Aadd( aHelpPor, "Considerado para compôr o Saldo Inicial."    )
Aadd( aHelpPor, "1- Filial: mov. bancários da filial;"    ) 
Aadd( aHelpPor, "2- Banco: todos os mov. do Banco"    ) 
Aadd( aHelpPor, " selecionado."    ) 
Aadd( aHelpSpa, "Se considera para compner el Saldo"    )
Aadd( aHelpSpa, " inicial."    )
Aadd( aHelpSpa, "1- Sucursal: mov. bancarios de la "    )
Aadd( aHelpSpa, "sucursal;"    )
Aadd( aHelpSpa, "2- Banco: todos los mov. del banco que "    )
Aadd( aHelpSpa, "se selecciono."    )
Aadd( aHelpEng, ""    )
Aadd( aHelpEng, ""    )
Aadd( aHelpEng, ""    )

*/	

//PutSx1( "FIN470", "10",/*STR0041*/"Saldo Inicial p/ ?","¿Saldo inicial p/ ?","Initial balance for","mv_chA","C",1,0,0,"C","","","","",;
//	"mv_par10",/*STR0042*/"Filial","Sucursal","Branch","",/*STR0043*/"Banco","Banco","Bank","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	
/*	
PutSX1Help("P.FIN47010.",aHelpPor,aHelpEng,aHelpSpa,.T.)			
	
If __LANGUAGE== "ENGLISH"             
	DbSelectArea("SX1")
	dbSetOrder(1)
	If SX1->( MsSeek( PadR("FIN470", Len(SX1->X1_GRUPO) ) + "10" ) )//Dbseek(cteste)         
		If EMPTY(SX1->X1_DEFENG1)                    
			RecLock("SX1",.F.)	
			Replace  SX1->X1_DEFENG1 With "Branch"
			MsUnlock()
		Endif
		If EMPTY(SX1->X1_DEFENG2)                    
			RecLock("SX1",.F.)	
			Replace  SX1->X1_DEFENG2 With "Bank"
			MsUnlock()
		Endif
	EndIf 	

ENDIF

If cPaisLoc == "COL"
	DbSelectArea("SX1")
	dbSetOrder(1)
	If SX1->( MsSeek( PadR("FIN470", Len(SX1->X1_GRUPO) ) + "06" ) )//Dbseek(cteste) 
		RecLock("SX1",.F.)
		Replace  X1_VALID With "VerifMoeda(mv_par06)"
		MsUnlock()
	EndIf 	
ENDIF
RestArea(aArea)
Return
                                                      
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TxMoeda  ºAutor  ³ Microsiga          º Data ³  31/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorna taxa da moeda do movimento de transferencia caso   º±±
±±º          ³ tenha sido informada. Caso contrario retorna a taxa do     º±±
±±º          ³ cadastro de moedas (SM2)									  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ EXPN1 - Taxa da moeda do movimento ou SM2.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR470                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TxMoeda( cAliasSE5, nMoedaBco )

Local aArea	:= GetArea()     
Local nTaxa	:= 0                
Local cNum		:= (cAliasSE5)->E5_NUMCHEQ
Local lMoedBco	:= SuperGetMv("MV_MOEDBCO",,.F.) == .T.
Default lE5TXMoeda := (cAliasSE5)->(FieldPos("E5_TXMOEDA") > 0)

If !Empty(cNum) .And. !SpbInUse()
	SE5->(dbSetOrder(10))
	SE5->(MsSeek(xFilial("SE5")+cNum))                                                     
	If MV_PAR09 == 1 // Taxa do dia
	   nTaxa := RecMoeda(dDatabase,mv_par06)
	ElseIf lE5TXMoeda .And. (cAliasSE5)->E5_TXMOEDA == 1 .And.;
	       (cAliasSE5)->(FieldPos("E5_MOEDA")   > 0) .And. Val((cAliasSE5)->E5_MOEDA) == 1
		nTaxa := RecMoeda((cAliasSE5)->E5_DTDISPO,mv_par06)	
	ElseIf lE5TXMoeda .And. !Empty((cAliasSE5)->E5_TXMOEDA)
		nTaxa := (cAliasSE5)->E5_TXMOEDA  	
	ElseIf (caliasSE5) -> E5_TIPODOC == "TE" .OR. (((cAliasSE5)->E5_TIPO $ MVPAGANT+MVRECANT) .and. mv_par06 <> Val((cAliasSE5)->E5_MOEDA))
		nTaxa := RecMoeda((cAliasSE5)->E5_DTDISPO,nMoedaBco)
	Else
		nTaxa := RecMoeda((cAliasSE5)->E5_DTDISPO,mv_par06)		
	EndIf	
Else 
	If MV_PAR09 == 1
	   nTaxa := RecMoeda(dDatabase,nMoedaBco)
	ElseIf lE5TXMoeda .And. !Empty((cAliasSE5)->E5_TXMOEDA) .And. ( Val((cAliasSE5)->E5_MOEDA) == nMoedaBco .or. (cAliasSE5)->E5_TIPO $ MVPAGANT+MVRECANT ) .And. ( !lMoedBco .Or. mv_par06 == 1 ) // QUANDO É ADIANTAMENTO O CAMPO E5_MOEDA FICA EM BRANCO
		nTaxa := (cAliasSE5)->E5_TXMOEDA  	
	Elseif lE5TXMoeda .And. !Empty((cAliasSE5)->E5_TXMOEDA) .And. ( nMoedaBco <> 1 .and. (cAliasSE5)->E5_TXMOEDA > 0) 
		nTaxa := (cAliasSE5)->E5_TXMOEDA //Caso de moeda contratada. Ou seja, valor da taxa da moeda fornecido por exemplo em cta a receber ou movimento bancario a receber. 	
	Else
		nTaxa := RecMoeda((cAliasSE5)->E5_DTDISPO,nMoedaBco)		
	EndIf	
EndIf	   	

RestArea( aArea )

Return( nTaxa )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FR470Alt  ºAutor  ³Pedro Pereira Lima  º Data ³  22/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta o cabeçalho do relatório para emissão em modo RETRATOº±±
±±º          ³com limite de 132 colunas                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR470                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
sTATIC Function FR470Alt(cConstCabec)

Local cCabFull := cConstCabec//"DATA|OPERACAO|DOCUMENTO|PREFIXO/TITULO|ENTRADAS|SAIDAS|SALDO ATUAL"
Local aCabecFull := {}

aAdd(aCabecFull,Substr(cCabFull,1,4) + Space(5) + Substr(cCabFull,44,9) + Space(46) + Substr(cCabFull,119,15) + Space(2) + Substr(cCabFull,140,15) + Space(8) + Substr(cCabFull,159,11))
aAdd(aCabecFull,Space(5) + Substr(cCabFull,13,8) + Space(24) + Substr(cCabFull,95,14))

Return aCabecFull



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINR470   ºAutor  ³ Gustavo Henrique   º Data ³  15/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega e retorna moedas da tabela 14                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FR470Tab14()

Local cTabela14 := ""

//SX5->(DbSetOrder(1))
//SX5->(MsSeek(xFilial("SX5")+"14"))
//While SX5->(!Eof()) .And. SX5->X5_TABELA == "14"
//	cTabela14 += (Alltrim(SX5->X5_CHAVE) + "/")
//	SX5->(DbSkip())
//End	
aSX514 	 := FwGetSX5("14")
For n14 := 1 To Len(aSX514)
	cTabela14 += (Alltrim(aSX514[n14][3]) + "/")
Next n14

cTabela14 += If(cPaisLoc=="BRA","","/$ ")         
If cPaisLoc == "BRA"
	cTabela14 := SubStr( cTabela14, 1, Len(cTabela14) - 1 )
EndIf	         

Return cTabela14 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ChecaTp    ³ Autor ³ Andrea Verissimo      ³ Data ³14/12/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Essa funcao retorna os dados do arquivo SEF para movimentos  ³±±
±±³          ³bancarios do tipo CH.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³prefixo, titulo e parcela do arquivo SEF.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ campos Nro Cheque, Banco, Agencia e Conta do arquivo SE5.   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ChecaTp(cChaveTp)
Local cRetorno := ""
Local cChavSef := ""
Local aArea    := GetArea()
Local nSoma := 0

If(E5_TIPODOC="CH")	     
	cChavSef := (xFilial("SE5")+cChaveTp)
	SEF->(dbSetOrder(4))
	If SEF->(Dbseek(cChavSef))
		dbSelectArea("SEF")
 		While !EOF() .and. (EF_FILIAL+EF_NUM+EF_BANCO+EF_AGENCIA+EF_CONTA) = cChavSef .and. nSoma <= 1
 			If !Empty(EF_TIPO)   
		 	  nSoma++
    		  cRetorno := EF_PREFIXO+If(Empty(EF_PREFIXO)," ","-")+EF_TITULO+If(Empty(EF_PARCELA)," ","-")+EF_PARCELA
	    	Endif
			 SEF->(Dbskip())
		 Enddo                          
	Else 
	    cChavSef := (E5_FILORIG+cChaveTp)
		dbSelectArea("SEF")
		SEF->(dbSetOrder(4))
		SEF->(Dbseek(cChavSef))
   		While !EOF() .and. (EF_FILIAL+EF_NUM+EF_BANCO+EF_AGENCIA+EF_CONTA) = cChavSef .and. nSoma <= 1
 		 	If !Empty(EF_TIPO)   
		 		nSoma++
    		  	cRetorno := EF_PREFIXO+If(Empty(EF_PREFIXO)," ","-")+EF_TITULO+If(Empty(EF_PARCELA)," ","-")+EF_PARCELA
	    	Endif
			SEF->(Dbskip())
		 Enddo
    EndIf

	If nSoma > 1
		cRetorno := "   "	
		nSoma := 0
	Endif
	
 	dbCloseArea()
	RestArea(aArea)
	nSoma := 0
EndIf
Return (cRetorno)

//--------------------------------------------------------
/*/{Protheus.doc}Fr470ValSld
Faz a pesquisa do saldo e traz o valor já com o fator imbutido
@author  	Varejo
@version 	P11.8
@since   	12/02/2015
@return  	nValor - Valor do Titulo
@obs     
@sample
/*/
//--------------------------------------------------------
static Function Fr470ValSld(cAliasSE5,nMoeda,lMultSld,lMsmMoeda,nValTroco,cAlias)
Local nValor := 0
Local nFator := 1
Local lMoedBco	:= SuperGetMv("MV_MOEDBCO",,.F.)
Local aArea	:= GetArea()
Local nVlCruz		:= 0
Local nMoedTit

Default nValTroco := 0

If lMoedBco

	nMoedTit := Iif((cAliasSE5)->E5_MOEDA != "TB", VerMoed(nMoedaBco, @nMoedTit,E5_TXMOEDA,.F.,@nVlCruz), nMoedaBco)
	
	ConvMoed(cAliasSE5,nMoeda,lMsmMoeda,,.F.,@nValor)
	
Else
	nValor := Round(xMoeda(F470VlMoeda(cAliasSE5);
				,Iif((cPaisLoc <> "BRA" .And. ((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)) ,1, nMoedaBco );
				,mv_par06;
				,iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO);
				,nMoeda + 1;
				,IIf(lMultSld, /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ) /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)));	
				,IIf(lMultSld,IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA),Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,mv_par06),nTxMoeda))));
				,nMoeda)
EndIf				

If (cAliasSE5)->E5_RECPAG == 'R'
	nFator := 1	
Else
	If	(cPaisLoc <> 'BRA') .And. (cAliasSE5)->E5_RECPAG == "P" .And.;
		AllTrim((cAliasSE5)->E5_MOEDA) == "TC" .And. ;
		AllTrim((cAliasSE5)->E5_TIPODOC) == "VL"
	    
		nFator		:= 1
		nValTroco 	+= nValor
	Else
	    nFator		:= -1
	EndIf
EndIf

nValor := nValor * nFator 

RestArea(aArea)

Return nValor

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINR470   ºAutor  ³ Rodrigo Oliveira   º Data ³  14/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se a moeda do título é dif. da moeda do bco       º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VerMoed(nMoedaBco, nMoedTit,nTxMoed,lVerAdiant,nVlCruz)

Local aArea		:= GetArea()
Local lRet			:= .F.
Local lPag			:= ( E5_RECPAG == "P" .And. E5_TIPODOC != "ES" ) .Or. ( E5_RECPAG == "R" .And. E5_TIPODOC == "ES" )
Local cE5Alias	:= Alias()
Local cAliasSE	:= GetNextAlias()

#IFDEF TOP
	cTipoDB	:= Upper(TCGetDB())
	lQuery		:= ( TcGetDb() # "AS/400" )
	cQry		:= ""
	lMsSql		:= "MSSQL" $ cTipoDB
#ELSE
	cTipoDB	:= ""
	lQuery 	:= .F.	
#ENDIF		

DEFAULT lVerAdiant	:= .T.
DEFAULT nVlCruz		:= 0

If Empty(Alltrim(SE5->E5_KEY)) // Adiant. não cancelado
	If E5_RECPAG == "P"
		nMoedTit 	:= Posicione("SE2",1,xFilial("SE2")+(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA),"E2_MOEDA")
		nVlCruz	:= SE2->E2_VLCRUZ
	Else
		nMoedTit 	:= Posicione("SE1",1,xFilial("SE1")+(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA),"E1_MOEDA")
		nVlCruz	:= SE1->E1_VLCRUZ
	EndIf
Else
	If lQuery
		cQry	:= "SELECT " + Iif(lPag,"E2_MOEDA NMOEDTIT, E2_VLCRUZ VLCRUZ","E1_MOEDA NMOEDTIT, E1_VLCRUZ VLCRUZ")
		cQry	+= " FROM " + RetSqlName(Iif(lPag, "SE2", "SE1"))
		cQry	+= " WHERE " + Iif(lPag,"E2_FILIAL","E1_FILIAL") + " = '" + xFilial(Iif(lPag, "SE2", "SE1")) + "' " 	
		If lMsSql
			If lPag
				cQry	+= " AND E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA = '" + (cE5Alias)->E5_KEY + "' "
			Else
				cQry	+= " AND E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + E1_CLIENTE + E1_LOJA = '" + (cE5Alias)->E5_KEY + "' "
			EndIf
		Else
			If lPag
				cQry	+= " AND E2_PREFIXO || E2_NUM || E2_PARCELA || E2_TIPO || E2_FORNECE || E2_LOJA = '" + (cE5Alias)->E5_KEY + "' "
			Else
				cQry	+= " AND E1_PREFIXO || E1_NUM || E1_PARCELA || E1_TIPO || E1_CLIENTE || E1_LOJA = '" + (cE5Alias)->E5_KEY + "' "
			EndIf
		EndIf
		If (cE5Alias)->E5_TIPODOC != "ES"
			cQry	+= " AND " + Iif(lPag,"E2_EMISSAO", "E1_EMISSAO") + " = '" + DTOS((cE5Alias)->E5_DATA) + "' "
		EndIf
		cQry	+= " AND (" + Iif(lPag,"E2_VALOR = ", "E1_VALOR = ") + AllTrim(Str((cE5Alias)->E5_VALOR)) + " OR " + Iif(lPag,"E2_VALOR = ", "E1_VALOR = ") + AllTrim(Str((cE5Alias)->E5_VLMOED2)) + ") "  
		cQry	+= " AND " + Iif(lPag,"E2_TXMOEDA = ", "E1_TXMOEDA = ") + AllTrim(Str(nTxMoed))
		cQry	+= " AND D_E_L_E_T_ = '*' "
		
		cQry	:= ChangeQuery(cQry)
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), cAliasSE, .F., .T. )
		
		nMoedTit	:= (cAliasSE)->NMOEDTIT
		nVlCruz	:= (cAliasSE)->VLCRUZ
		
		(cAliasSE)->(DbCloseArea()) 
	EndIf
EndIf

RestArea(aArea)

If lVerAdiant
	If nMoedTit == nMoedaBco .And. ( nTxMoed == 0 .Or. (nTxMoed > 0 .And. mv_par06 != nMoedTit))
		lRet := .T.
	ElseIf !Empty(Alltrim(SE5->E5_KEY)) .And. nMoedTit != nMoedaBco .And. nTxMoed > 0 .And. ( nMoedaBco == mv_par06 .Or. MV_PAR09 <> 2 )
		lRet := .T.
	ElseIf nMoedTit == nMoedaBco .And. nMoedaBco == mv_par06
		lRet := .T.
	EndIf
Else
	Return nMoedTit
EndIf

If E5_VLMOED2 = 0.00
	lRet := .T.
	nMoedTit := SA6->A6_MOEDA
EndIf

	
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINR470   ºAutor  ³ Rodrigo Oliveira   º Data ³  01/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realiza conversão dos valores entre moedas.                º±±
±±º          ³ Parâmetro MV_MOEDBCO = .T.                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ConvMoed(cAliasSE5,nMoeda,lMsmMoeda,aRecon,lCalc,nValor)

Local nRet
Local lMultSld    	:= (FindFunction( "FXMultSld" ) .AND. FXMultSld())
Local nVlCruz

DEFAULT nValor := 0
DEFAULT nVlCruz := 0

If Mv_Par09 == 2 
	If ( nMoedaBco != nMoedTit .And. (cAliasSE5)->E5_TXMOEDA > 0 ) 
		nValor 	:= Round(xMoeda(F470VlMoeda(cAliasSE5), nMoedaBco , mv_par06, iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO), nMoeda + 1, IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ), IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),E5_TXMOEDA)),nMoeda)
		nRet 	:= 1
	ElseIf nMoedaBco == nMoedTit .And. MV_PAR06 > 1
		nValor   := Round(xMoeda( F470VlMoeda(cAliasSE5), nMoedaBco, mv_par06, IIF(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO), nMoeda + 1, IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco)),	IIF(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA) ),nMoeda)
		nRet	:= 2
	Else
		nValor		:= Round(xMoeda( Iif(VerMoed(nMoedaBco, @nMoedTit,(cAliasSE5)->E5_TXMOEDA), E5_VALOR, E5_VLMOED2), nMoedTit, mv_par06, IIF(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO), nMoeda + 1, IIf(lMultSld, /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedTit ), TxMoeda(cAliasSE5, nMoedTit) ) /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda)
		nRet := 3
	EndIf
ElseIf Mv_PAR09 == 1 
	If (cAliasSE5)->E5_TXMOEDA > 0 .And. nMoedaBco == Mv_PAR06 .And. Mv_Par06 > 1
		If nMoedTit != nMoedaBco
			nValor   := Round(xMoeda( E5_VLMOED2, nMoedTit, mv_par06, dDataBase, nMoeda + 1, IIf(lMultSld, /**/ 0 /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda)
			nRet	:= 4
		ElseIf nMoedTit == nMoedaBco
			nValor 	:= Round(xMoeda(F470VlMoeda(cAliasSE5), nMoedaBco , mv_par06, iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO), nMoeda + 1, IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ), IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA)),nMoeda)
			nRet 	:= 1
		Else
			nValor   := Round(xMoeda( Iif(VerMoed(nMoedaBco, @nMoedTit,(cAliasSE5)->E5_TXMOEDA,,@nVlCruz), nVlCruz, E5_VLMOED2), nMoedaBco, mv_par06, dDataBase, nMoeda + 1, IIf(lMultSld, /**/ E5_TXMOEDA /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda)
			nRet	:= 5
		EndIf
	ElseIf ( nMoedaBco != nMoedTit .And. ( (cAliasSE5)->E5_TXMOEDA > 0 .Or. Mv_Par06 > 1 ) ) .Or. (nMoedTit == 1 .Or. (nMoedaBco == nMoedTit))
		If nMoedaBco > 1 .And. nMoedTit > 1 .And. Mv_Par09 == 1 .And. ( Mv_Par06 > 1 .Or. (cAliasSE5)->E5_TXMOEDA > 0 .Or. Mv_Par06 > 1 ) .And. nMoedTit != nMoedaBco
			nValor   := Round(xMoeda( Iif(VerMoed(nMoedaBco, @nMoedTit,(cAliasSE5)->E5_TXMOEDA), E5_VALOR, E5_VLMOED2), nMoedTit, mv_par06, IIF(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO), nMoeda + 1, IIf(lMultSld, /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedTit ), TxMoeda(cAliasSE5, nMoedTit) ) /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda)
			nRet	:= 3
		Else
			nValor 	:= Round(xMoeda(F470VlMoeda(cAliasSE5), nMoedaBco , mv_par06, iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO), nMoeda + 1, IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ), IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA)),nMoeda)
			nRet 	:= 1
		EndIf	
	Else
		nValor   := Round(xMoeda( Iif(VerMoed(nMoedaBco, @nMoedTit,(cAliasSE5)->E5_TXMOEDA), E5_VALOR, E5_VLMOED2), nMoedTit, mv_par06, IIF(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO), nMoeda + 1, IIf(lMultSld, /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedTit ), TxMoeda(cAliasSE5, nMoedTit) ) /**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)))),nMoeda)
		nRet	:= 3
	EndIf
EndIf

If lCalc
	If Empty((cAliasSE5)->E5_RECONC) .AND. (cAliasSE5)->E5_RECPAG == "R"
		aRecon[1][REC_NAO_CONCILIADO] += nValor
	ElseIf (cAliasSE5)->E5_RECPAG == "R"
		aRecon[1][REC_CONCILIADO] += nValor
	ElseIf Empty( (cAliasSE5)->E5_RECONC ) .AND. (cAliasSE5)->E5_RECPAG == "P"
		aRecon[1][PAG_NAO_CONCILIADO] += nValor
	ElseIf (cAliasSE5)->E5_RECPAG == "P"
		aRecon[1][PAG_CONCILIADO] += nValor
	End
EndIf
	
Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINR470   ºAutor  ³ Rodrigo Oliveira   º Data ³  09/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para cálculo do saldo inicial de banco compart.     º±±
±±º          ³ e saldo exclusivo                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CalcSldIni(nSaldoAtu, nSaldoIni) 

Local cSaldo 	:= GetNextAlias()
Local cQry		:= ""
Local nMoeda	:= GetMv("MV_CENT"+(IIF(mv_par06 > 1 , STR(mv_par06,1),"")))
Local cFl 		:= ""
Local nSld		:= 0
Local nSlRec	:= 0
Local lOracle := "ORACLE"$Upper(TCGetDB())

cQry := " SELECT E8_FILIAL, E8_BANCO, E8_AGENCIA, E8_CONTA, E8_DTSALAT, E8_SALATUA, E8_SALRECO "
cQry += " FROM " + RetSqlName("SE8") + " SE8 " 
cQry += " WHERE E8_BANCO 	= '" + mv_par01 + "' "
cQry += " AND E8_AGENCIA 	= '" + mv_par02 + "' "
cQry += " AND E8_CONTA 		= '" + mv_par03 + "' "
cQry += " AND E8_DTSALAT		< '" + DTOS(mv_par04) + "' "
If lOracle
	cQry += " AND D_E_L_E_T_ != '*' "
Else
	cQry += " AND D_E_L_E_T_ = '' "
EndIf
cQry += " ORDER BY E8_FILIAL, E8_DTSALAT DESC "

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cSaldo, .T., .T.)

(cSaldo)->(DbGoTop())

cFl 	:= (cSaldo)->E8_FILIAL
nSld	:= (cSaldo)->E8_SALATUA
nSlRec	:= (cSaldo)->E8_SALRECO

While !Eof()
	
	If (cSaldo)->E8_FILIAL != cFl
		nSld	+= (cSaldo)->E8_SALATUA
		nSlRec	+= (cSaldo)->E8_SALRECO
		cFl 	:= (cSaldo)->E8_FILIAL
	EndIf
	DbSkip()	
EndDo
 
(cSaldo)->(DbCloseArea())

If mv_par07 == 1  //Todos
	nSaldoAtu:=Round(xMoeda(nSld,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
	nSaldoIni:=Round(xMoeda(nSld,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
ElseIf mv_par07 == 2 //Conciliados
	nSaldoAtu:=Round(xMoeda(nSlRec,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
	nSaldoIni:=Round(xMoeda(nSlRec,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
ElseIf mv_par07 == 3	//Nao Conciliados
	nSaldoAtu:=Round(xMoeda(nSld - nSlRec,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
	nSaldoIni:=Round(xMoeda(nSld - nSlRec,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
Endif

Return