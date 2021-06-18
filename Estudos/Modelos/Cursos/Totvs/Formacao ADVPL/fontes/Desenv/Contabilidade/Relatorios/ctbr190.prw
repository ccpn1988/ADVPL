#Include "CTBR190.Ch"
#Include "PROTHEUS.Ch"

#DEFINE 	COL_SEPARA1			1
#DEFINE 	COL_CONTA  			2
#DEFINE 	COL_SEPARA2			3
#DEFINE 	COL_DESCRICAO		4
#DEFINE 	COL_SEPARA3			5
#DEFINE 	COL_SALDO_ANT       6
#DEFINE 	COL_SEPARA4			7
#DEFINE 	COL_VLR_DEBITO      8
#DEFINE 	COL_SEPARA5			9
#DEFINE 	COL_VLR_CREDITO     10
#DEFINE 	COL_SEPARA6			11
#DEFINE 	COL_MOVIMENTO 		12
#DEFINE 	COL_SEPARA7			13
#DEFINE 	COL_SALDO_ATU 		14
#DEFINE 	COL_SEPARA8			15


// 17/08/2009 -- Filial com mais de 2 caracteres

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR190	³ Autor ³ Gustavo Henrique  	³ Data ³ 28.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Classe de Valor / Conta       			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctbr190()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso    	 ³ Generico     											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBR190()
PRIVATE titulo		:= "" 
Private nomeprog	:= "CTBR190"
PRIVATE aSelFil	:= {}
PRIVATE lTodasFil := .F.


If FindFunction("TRepInUse") .And. TRepInUse() 
	U_CTBR190R4()
Else
	U_CTBR190R3()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR190R4 ³ Autor³ Daniel Sakavicius		³ Data ³ 01/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Classe de Valor / Conta - R4  					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR190R4												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBR190R4() 
Local cPerg	   		:= "CTR190"			       
Local cArqTmp

Private cPictVal 		:= PesqPict("CT2","CT2_VALOR")
Private cSayClVl		:= CtbSayApro("CTH")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CTR190SX1()

oReport := ReportDef( @cArqTmp )      

If !Empty( oReport:uParam )
	Pergunte( cPerg, .T. )
	    
	If Empty(mv_par10)                       
	   Help(" ",1,"NOMOEDA")
	   Return
	Endif	
	
	If (mv_par35 == 1) .and. ( Empty(mv_par36) .or. Empty(mv_par37) )
		cMensagem	:= STR0023	// "Favor preencher os parametros Grupos Receitas/Despesas e Data Sld Ant. Receitas/Despesas ou "
		cMensagem	+= STR0024	// "deixar o parametro Ignora Sl Ant.Rec/Des = Nao "
		MsgAlert(cMensagem,"Ignora Sl Ant.Rec/Des")	
    	Return
	EndIf
	
	If mv_par38 == 1 .And. Len( aSelFil ) <= 0
		aSelFil := AdmGetFil(@lTodasFil)
		If Len( aSelFil ) <= 0
			Return
		Endif
	EndIf 
EndIf	

oReport :PrintDialog()      

If Select("cArqTmp") > 0
	dbSelectArea("cArqTmp")
	Set Filter To
	dbCloseArea()

	If Select("cArqTmp") == 0
		FErase(cArqTmp+GetDBExtension())
		FErase("cArqInd"+OrdBagExt())
	EndIf
EndIf	

Return                                

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Daniel Sakavicius		³ Data ³ 01/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao tem como objetivo definir as secoes, celulas,   ³±±
±±³          ³totalizadores do relatorio que poderao ser configurados     ³±±
±±³          ³pelo relatorio.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef( cArqTmp )   
local aArea	   		:= GetArea()   
Local cReport		:= "CTBR190"
Local cTitulo		:= OemToAnsi(STR0003)+ Upper(cSayClVl)+" / "+Upper(OemToAnsi(STR0021)) 	//"Balancete de Verificacao  / Conta"
Local cDesc			:= OemToAnsi(STR0001)+ Upper(cSayClVl)+" / "+Upper(OemToAnsi(STR0021))	//"Este programa ira imprimir o Balancete de  /Conta"
Local cPerg	   		:= "CTR190"			       
Local aTamConta		:= TAMSX3("CT1_CONTA")    
Local aTamCLVL		:= TAMSX3("CTH_CLVL")    
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local aTamDesc		:= TAMSX3("CTH_DESC01")
Local nDecimais

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//"Este programa tem o objetivo de emitir o Cadastro de Itens Classe de Valor "
//"Sera impresso de acordo com os parametros solicitados pelo"
//"usuario"
oReport	:= TReport():New( cReport, cTitulo, cPerg, { |oReport| ReportPrint( oReport, @cArqTmp ) }, cDesc ) 
oReport:ParamReadOnly()
oReport:SetLandscape()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection0  := TRSection():New( oReport, Capital(cSayClVl), {"cArqTmp", "CTH"},, .F., .F. )        
TRCell():New( oSection0, "CLVL"	 , 		,Capital(STR0025)/*Titulo*/	,/*Picture*/,aTamClvl[1]/*Tamanho*/,/*lPixel*/,{ || EntidadeCTB(cArqTmp->CLVL,,,20,.F.,cMascara2,,,,,,.F.) }/*CodeBlock*/)  //"CODIGO"
TRCell():New( oSection0, "DESCCLVL" , 	,Capital(STR0026)/*Titulo*/	,/*Picture*/,aTamDesc[1]/*Tamanho*/,/*lPixel*/,{ || (cArqTMP->DESCCLVL) }/*CodeBlock*/)  //"DESCRICAO"
TRPosition():New( oSection0, "CTH", 1, {|| xFilial("CTH") + cArqTMP->CLVL })

oSection0:SetLineStyle()
oSection0:SetNoFilter({"cArqTmp", "CTH"})

oSection1  := TRSection():New( oSection0, Capital(STR0021), {"cArqTmp", "CT1"},, .F., .F. )

TRCell():New( oSection1, "CONTA"	 , ,Capital(STR0025)/*Titulo*/,/*Picture*/,aTamConta[1]/*Tamanho*/,/*lPixel*/	, {|| IIF(cArqTmp->TIPOCONTA=="2","  ","")+EntidadeCTB(cArqTmp->CONTA ,,,70,.F.,cMascara1,,,,,,.F.) }/*CodeBlock*/)  //"CODIGO"
TRCell():New( oSection1, "DESCCTA"  , ,Capital(STR0026)/*Titulo*/,/*Picture*/,aTamDesc[1]/*Tamanho*/,/*lPixel*/	, {|| cArqTmp->DESCCTA }/*CodeBlock*/)  //"DESCRICAO"
TRCell():New( oSection1, "SALDOANT" , ,Capital(STR0027)/*Titulo*/,/*Picture*/,aTamVal[1]/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/,,"CENTER")  //"SALDO ANTERIOR"
TRCell():New( oSection1, "SALDODEB" , ,Capital(STR0028)/*Titulo*/,/*Picture*/,aTamVal[1]/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/,,"CENTER")  //"DEBITO"
TRCell():New( oSection1, "SALDOCRD" , ,Capital(STR0029)/*Titulo*/,/*Picture*/,aTamVal[1]/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/,,"CENTER")   //"CREDITO"
TRCell():New( oSection1, "MOVIMENTO", ,Capital(STR0030)/*Titulo*/,/*Picture*/,aTamVal[1]/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/,,"CENTER") //"MOVIMENTO DO PERIODO"
TRCell():New( oSection1, "SALDOATU" , ,Capital(STR0031)/*Titulo*/,/*Picture*/,aTamVal[1]+5/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/,,"CENTER") //"SALDO ATUAL"
TRPosition():New( oSection1, "CT1", 1, {|| xFilial("CT1") + cArqTMP->CONTA})

oSection1:SetTotalInLine(.F.)          
oSection1:SetNoFilter({"cArqTmp"})
oSection1:SetLinesBefore(0)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Daniel Sakavicius	³ Data ³ 01/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio definido pelo usuario de acordo com as  ³±±
±±³          ³secoes/celulas criadas na funcao ReportDef definida acima.  ³±±
±±³          ³Nesta funcao deve ser criada a query das secoes se SQL ou   ³±±
±±³          ³definido o relacionamento e filtros das tabelas em CodeBase.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportPrint(oReport)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³EXPO1: Objeto do relatório                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport, cArqTmp )  
Local oSection0 	:= oReport:Section(1)    
Local oSection1 	:= oReport:Section(1):Section(1)

Local aSetOfBook
Local aCtbMoeda	:= {}
Local cDescMoeda

Local cPicture

Local cClVlAnt 		:= ""
Local cSegAte   	:= mv_par14

Local dDataLP		:= mv_par28
Local dDataFim		:= mv_par02

Local lFirstPage	:= .T.
Local lPula			:= .F.
Local l132			:= .F.
Local lImpAntLP		:= Iif(mv_par27 == 1,.T.,.F.)
Local lJaPulou		:= .F.
Local lPrintZero	:= Iif(mv_par23==1,.T.,.F.)
Local lPulaSint		:= Iif(mv_par22==1,.T.,.F.) 
Local lVlrZerado	:= Iif(mv_par09==1,.T.,.F.)

Local nDecimais
Local nDivide		:= 0

Local nDigitAte	:= 0
Local nDigClAte	:= 0
Local lRecDesp0		:= Iif(mv_par35==1,.T.,.F.)
Local cRecDesp		:= mv_par36
Local dDtZeraRD		:= mv_par37    
Local cFilter		:= ""
Local oBreak, oBreak1, oFuncDeb, oFuncCred, oFuncMov, oTotDeb, oTotCred, oTotMov
Local oFuncPerDeb, oFuncPerCred, oFuncPerMov, oTotPerDeb, oTotPerCred, oTotPerMov
Local lCtiSint      := ( mv_par34 == 1 .OR. mv_par34 == 3 ) 

Local cSepara1  	:= ""
Local cSepara2  	:= ""
Local cTipoAnt  	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par08)
	lRet := .F.
Else
   aSetOfBook := CTBSetOf(mv_par08)
Endif

aCtbMoeda  	:= CtbMoeda(mv_par10,nDivide)

cDescMoeda 	:= aCtbMoeda[2]
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par10)

If mv_par25 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par25 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par25 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	

//Mascara da Conta
If Empty(aSetOfBook[2])
	cMascara1 := GetMv("MV_MASCARA")
Else
	cMascara1 	:= RetMasCtb(aSetOfBook[2],@cSepara1)
EndIf

// Mascara da Classe de Valor
If Empty(aSetOfBook[8])
	cMascara2 := ""
Else
	cMascara2 := RetMasCtb(aSetOfBook[8],@cSepara2)
EndIf

cPicture 		:= aSetOfBook[4]

If !ct040Valid(mv_par08)
	Return
Else
   aSetOfBook := CTBSetOf(mv_par08)
Endif

If mv_par25 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par25 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par25 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	
             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If mv_par07 == 1 //sintetica
	Titulo:=	OemToAnsi(STR0007) + Upper(cSayClVl)+ " / "+Upper(OemToAnsi(STR0021))		//"BALANCETE SINTETICO DE  /CONTA"
ElseIf mv_par07 == 2 //analitica
	Titulo:=	OemToAnsi(STR0006) + Upper(cSayClVl)+ " / "+Upper(OemToAnsi(STR0021)) 	//"BALANCETE ANALITICO DE  /CONTA"
ElseIf mv_par07 == 3 //ambas
	Titulo:=	OemToAnsi(STR0008) + Upper(cSayClVl)+ " / "+Upper(OemToAnsi(STR0021))		//"BALANCETE DE / CONTA"
EndIf

Titulo += 	OemToAnsi(STR0009) + DTOC(mv_par01) + OemToAnsi(STR0010) + Dtoc(mv_par02) + ;
				OemToAnsi(STR0011) + cDescMoeda

If mv_par12 > "1"
	Titulo += " (" + Tabela("SL", mv_par12, .F.) + ")"
EndIf

If nDivide > 1			
	Titulo += " (" + OemToAnsi(STR0022) + Alltrim(Str(nDivide)) + ")"
EndIf	

oReport:SetPageNumber( mv_par11 ) // numeração da pagina
oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport) } )

oSection0:SetLineCondition( {|| ( cClVlAnt := cArqTmp->CLVL, .T.) } )
oSection1:SetTotalText({||Capital(STR0020)+" "+Capital(Alltrim(cSayClVl))+ " : "+cClVlAnt}) //Total 

oReport:SetTotalText(Capital(STR0018)) 
oReport:SetTotalInLine(.F.)          

If mv_par26 == 2 
	oSection1:Cell("CONTA"):SetBlock( { || IIF(cArqTmp->TIPOCONTA=="2","  ","")+EntidadeCTB(cArqTmp->CTARES,,,70,.F.,cMascara1,,,,,,.F.) } )		
Else
	oSection1:Cell("CONTA"):SetBlock( { || IIF(cArqTmp->TIPOCONTA=="2","  ","")+EntidadeCTB(cArqTmp->CONTA ,,,70,.F.,cMascara1,,,,,,.F.) } )
EndIf	

oSection1:Cell("DESCCTA")	:SetBlock( { || cArqTmp->DESCCTA } )                                                                     
oSection1:Cell("SALDOANT")	:SetBlock( { || ValorCTB(cArqTmp->SALDOANT	,,,17,nDecimais,.T.,cPicture,cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )		
oSection1:Cell("SALDODEB")	:SetBlock( { || ValorCTB(cArqTmp->SALDODEB	,,,17,nDecimais,.F.,cPicture,cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } ) 
oSection1:Cell("SALDOCRD")	:SetBlock( { || ValorCTB(cArqTmp->SALDOCRD	,,,17,nDecimais,.F.,cPicture,cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } ) 
//Imprime Movimento
If mv_par19 = 1
	oSection1:Cell("MOVIMENTO"):SetBlock( { || ValorCTB(cArqTmp->MOVIMENTO	,,,17,nDecimais,.T.,cPicture,cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )	
ElseIf mv_par19 = 2 //Nao imprime movimento
	oSection1:Cell("MOVIMENTO"):Disable()
Endif
oSection1:Cell("SALDOATU"):SetBlock( { || ValorCTB(cArqTmp->SALDOATU	,,,17,nDecimais,.T.,cPicture,cArqTmp->NORMAL, , , , , ,lPrintZero,.F./*lSay*/) } )		

MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CTI","",mv_par03,mv_par04,,,,,mv_par05,mv_par06,mv_par10,;
				mv_par12,aSetOfBook,mv_par15,mv_par16,mv_par17,mv_par18,;
				l132,.T.,,"CTH",lImpAntLP,dDataLP, nDivide,lVlrZerado,,,;
				mv_par30,mv_par31,mv_par32,mv_par33,,,,,,,,,oSection0:GetAdvplExp('CT1'),lRecDesp0,;
				cRecDesp,dDtZeraRD,,,,,,,,,aSelFil,,,,,,,,lCtiSint,lTodasFil)},;
				OemToAnsi(OemToAnsi(STR0014)),;  //"Criando Arquivo Tempor rio..."
				OemToAnsi(STR0003)+cSayClVl)   //"Balancete Verificacao Conta /"      
				
oSection1:SetParentFilter({|cParam| cArqTmp->CLVL == cParam  },{|| cArqTmp->CLVL })  

If mv_par07 == 1					// So imprime Sinteticas
	cFilter := "cArqTmp->TIPOCONTA  <>  '2'  "
	If mv_par34 == 1					// So imprime Sinteticas
		cFilter += ".and. cArqTmp->TIPOCLVL  <>  '2'  "
	ElseIf mv_par34 == 2				// So imprime Analiticas
		cFilter += ".and. cArqTmp->TIPOCLVL  <>  '1'  "
	EndIf
ElseIf mv_par07 == 2				// So imprime Analiticas
	cFilter := "cArqTmp->TIPOCONTA  <>  '1'  "
	If mv_par34 == 1					// So imprime Sinteticas
		cFilter += ".and. cArqTmp->TIPOCLVL  <>  '2'  "
	ElseIf mv_par34 == 2				// So imprime Analiticas
		cFilter += ".and. cArqTmp->TIPOCLVL  <>  '1'  "
	EndIf
EndIf

If mv_par34 == 1 .and. Empty(cFilter)					// So imprime Sinteticas
	cFilter := "cArqTmp->TIPOCLVL  <>  '2'  "
ElseIf mv_par34 == 2 .and. Empty(cFilter)				// So imprime Analiticas
	cFilter := "cArqTmp->TIPOCLVL  <>  '1'  "
EndIf    
   
oSection1:SetFilter( cFilter )                                                

oBreak:= TRBreak():New(oReport, {|| cArqTmp->CLVL },  )

If mv_par21 == 1 //Pula Pagina? 1 = Sim   2 = Nao
	oBreak:SetPageBreak(.T.)
Else
	oBreak:SetPageBreak(.F.)
Endif

If mv_par13 == 1				// Grupo Diferente
	oBreak1:= TRBreak():New(oReport, {|| cArqTmp->GRUPO },  )
	oBreak1:SetPageBreak(.T.)
EndIf          

//Totalizadores
oFuncDeb 	:= TRFunction():New(oSection1:Cell("SALDODEB") , ,"SUM", oBreak 	,,/*[ cPicture ]*/,{ || TotSaldo(1) }/*[ uFormula ]*/,,.T.,.F.,oSection1)
oFuncCred 	:= TRFunction():New(oSection1:Cell("SALDOCRD") , ,"SUM", oBreak	,,/*[ cPicture ]*/,{ || TotSaldo(2) }/*[ uFormula ]*/,,.T.,.F.,oSection1)

If mv_par19 = 1
	oFuncMov := TRFunction():New(oSection1:Cell("MOVIMENTO"), ,"SUM", oBreak,,/*[ cPicture ]*/,{ || Iif(cArqTMP->TIPOCONTA="1",0,cArqTMP->MOVIMENTO) }/*[ uFormula ]*/,,.T.,.F.,oSection1)
Endif

oFuncDeb:Disable()
oFuncCred:Disable()

If mv_par19 = 1
	oFuncMov:Disable()
EndIf

oFuncPerDeb 	:= TRFunction():New(oSection1:Cell("SALDODEB") , ,"SUM", /*oBreak*/ 	,,/*[ cPicture ]*/,{ || TotSaldo(1) }/*[ uFormula ]*/,.F.,.T.,.F.,oSection1)
oFuncPerCred 	:= TRFunction():New(oSection1:Cell("SALDOCRD") , ,"SUM", /*oBreak*/	,,/*[ cPicture ]*/,{ || TotSaldo(2) }/*[ uFormula ]*/,.F.,.T.,.F.,oSection1)

If mv_par19 = 1
	oFuncPerMov := TRFunction():New(oSection1:Cell("MOVIMENTO"), ,"SUM", /*oBreak*/,,/*[ cPicture ]*/,{ || Iif(cArqTMP->TIPOCONTA="1",0,cArqTMP->MOVIMENTO) }/*[ uFormula ]*/,.F.,.T.,.F.,oSection1)
Endif

oFuncPerDeb:Disable()
oFuncPerCred:Disable()

If mv_par19 = 1
	oFuncPerMov:Disable()
EndIf

oTotDeb := TRFunction():New(oSection1:Cell("SALDODEB") , ,"ONPRINT", /*oBreak */	,,/*[ cPicture ]*/,/*[ uFormula ]*/,,.T.,.F.,oSection1)
oTotDeb:SetFormula( {|| ValorCTB(oFuncDeb:GetValue(),,,17,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero, .F.)})
oTotCred := TRFunction():New(oSection1:Cell("SALDOCRD") , ,"ONPRINT", /*oBreak*/	,,/*[ cPicture ]*/,/*[ uFormula ]*/,,.T.,.F.,oSection1)
oTotCred:SetFormula( {|| ValorCTB(oFuncCred:GetValue(),,,17,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero, .F.) })

If mv_par19 = 1
	oTotMov := TRFunction():New(oSection1:Cell("MOVIMENTO"), ,"ONPRINT", /*oBreak*/,,/*[ cPicture ]*/,/*[ uFormula ]*/,,.T.,.F.,oSection1)
	oTotMov:SetFormula( {|| nTotMov := oFuncCred:GetValue()-oFuncDeb:GetValue() , ValorCTB(nTotMov,,,17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero, .F.)})
Endif

oTotPerDeb := TRFunction():New(oSection1:Cell("SALDODEB") , ,"ONPRINT", /*oBreak */	,,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.T.,.F.,oSection1)
oTotPerDeb:SetFormula( {|| ValorCTB(oFuncPerDeb:GetValue(),,,17,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero, .F.)})
oTotPerCred := TRFunction():New(oSection1:Cell("SALDOCRD") , ,"ONPRINT", /*oBreak*/	,,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.T.,.F.,oSection1)
oTotPerCred:SetFormula( {|| ValorCTB(oFuncPerCred:GetValue(),,,17,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero, .F.) })

If mv_par19 = 1
	oTotPerMov := TRFunction():New(oSection1:Cell("MOVIMENTO"), ,"ONPRINT", /*oBreak*/,,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.T.,.F.,oSection1)
	oTotPerMov:SetFormula( {|| nTotMov := oFuncPerCred:GetValue()-oFuncPerDeb:GetValue() , ValorCTB(nTotMov,,,17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero, .F.)})
Endif

oSection1:OnPrintLine( {|| ( IIf( lPulaSint .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOCONTA == "1" .And. cTipoAnt == "2")), oReport:skipLine(),NIL),;
								 cTipoAnt := cArqTmp->TIPOCONTA;
							)  }) 

oSection0:Print()		

oBreak:SetPageBreak(.F.)
If mv_par13 == 1
	oBreak1:SetPageBreak(.F.)
Endif
Return

Static Function TotSaldo(nTpSld)
Local nTotDeb := 0
Local nTotCrd := 0
Local nRet := 0

If mv_par07 != 1					// Imprime Analiticas ou Ambas
	If cArqTMP->TIPOCONTA == "2"
		If (mv_par34 != 1 .And. cArqTMP->TIPOCLVL == "2")
			nTotDeb 		:= cArqTMP->SALDODEB 
			nTotCrd    		:= cArqTMP->SALDOCRD
		ElseIf (mv_par34 == 1 .And. cArqTMP->TIPOCLVL != "2"	)
				nTotDeb 		:= cArqTMP->SALDODEB 
				nTotCrd    		:= cArqTMP->SALDOCRD			
		EndIf	
	Endif
Else
	If (cArqTMP->TIPOCONTA == "1" .And. Empty(cArqTMP->SUPERIOR))
		If (mv_par34 != 1 .And. cArqTMP->TIPOCLVL == "2")
			nTotDeb 		:= cArqTMP->SALDODEB 
			nTotCrd    		:= cArqTMP->SALDOCRD
		ElseIf (mv_par34 == 1 .And. cArqTMP->TIPOCLVL != "2"	)
			nTotDeb 		:= cArqTMP->SALDODEB 
			nTotCrd    		:= cArqTMP->SALDOCRD	
		EndIf	
	EndIf		
Endif

If nTpSld=1
	nRet := nTotDeb
Else	
	nRet := nTotCrd
EndIf

Return(nRet)
/*
-------------------------------------------------------- RELEASE 3 -------------------------------------------------------------
*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR190r3³ Autor ³ Gustavo Henrique  	³ Data ³ 28.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Classe de Valor / Conta       			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctbr190()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso    	 ³ Generico     											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBR190R3()

Local aSetOfBook
Local aCtbMoeda		:= {}
Local cSayClVl		:= CtbSayApro("CTH")
LOCAL cDesc1 		:= OemToAnsi(STR0001)+ Upper(cSayClVl)+" / "+Upper(OemToAnsi(STR0021))	//"Este programa ira imprimir o Balancete de  /Conta"
LOCAL cDesc2 		:= OemToansi(STR0002)  //"de acordo com os parametros solicitados pelo Usuario"

LOCAL wnrel
LOCAL cString		:= "CT1"
Local titulo 		:= OemToAnsi(STR0003)+ Upper(cSayClVl)+" / "+Upper(OemToAnsi(STR0021)) 	//"Balancete de Verificacao  / Conta"
Local lRet			:= .T.
Local nDivide		:= 1

PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= "CTR190"
PRIVATE aReturn 	:= { OemToAnsi(STR0015), 1,OemToAnsi(STR0016), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha		:= {}
PRIVATE nomeProg  	:= "CTBR190"
PRIVATE Tamanho		:="M"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

li 		:= 80
m_pag	:= 1

CTR190SX1()
Pergunte("CTR190",.F.)

If mv_par38 == 1 .And. Len( aSelFil ) <= 0
	aSelFil := AdmGetFil()
	If Len( aSelFil ) <= 0
		Return
	Endif
EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  	   	³
//³ mv_par01				// Data Inicial              	       	³
//³ mv_par02				// Data Final                          	³
//³ mv_par03				// Conta Inicial                       	³
//³ mv_par04				// Conta Final  					   	³
//³ mv_par05				// Da Classe de Valor                  	³
//³ mv_par06				// Ate a Classe de Valor               	³
//³ mv_par07				// Imprime Contas: Sintet/Analit/Ambas 	³
//³ mv_par08				// Set Of Books				    	   	³
//³ mv_par09				// Saldos Zerados?			     	   	³
//³ mv_par10				// Moeda?          			     	   	³
//³ mv_par11				// Pagina Inicial  		     		   	³
//³ mv_par12				// Saldos? Reais / Orcados	/Gerenciais	³
//³ mv_par13				// Quebra por Grupo Contabil?		   	³
//³ mv_par14				// Imprimir ate o Segmento?			   	³
//³ mv_par15				// Filtra Segmento?					   	³
//³ mv_par16				// Conteudo Inicial Segmento?		   	³
//³ mv_par17				// Conteudo Final Segmento?		       	³
//³ mv_par18				// Conteudo Contido em?				   	³
//³ mv_par19				// Imprime Movimento do Mes            	³
//³ mv_par20				// Imprime Totalizacao de Itens Sintet.	³
//³ mv_par21				// Pula Pagina                         	³

//³ mv_par22				// Salta linha sintetica ?			    ³
//³ mv_par23				// Imprime valor 0.00    ?			    ³
//³ mv_par24				// Imprimir Codigo? Normal / Reduzido  	³
//³ mv_par25				// Divide por ?                   		³
                                                                     
//³ mv_par26				// Imprime Cod. Conta ? Normal/Reduzido ³
//³ mv_par27				// Posicao Ant. L/P? Sim / Nao         	³
//³ mv_par28 				// Data Lucros/Perdas?                	³
//³ mv_par29				// Clvl ate o Segmento?			   		³
//³ mv_par30				// Filtra Segmento?					   	³
//³ mv_par31				// Conteudo Inicial Segmento?		   	³
//³ mv_par32				// Conteudo Final Segmento?		       	³
//³ mv_par33				// Conteudo Contido em?				   	³
//³ mv_par34				// Imprime ClVl: Sintet/Analit/Ambas 	³
//³ mv_par35				// Rec./Desp. Anterior Zeradas?			³		
//³ mv_par36				// Grupo Receitas/Despesas?      		³		
//³ mv_par37				// Data de Zeramento Receita/Despesas?	³		
//³ mv_par38				// Seleciona filiais?	                ³		
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := "CTBR190"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par08)
	lRet := .F.
Else
   aSetOfBook := CTBSetOf(mv_par08)
Endif

If mv_par25 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par25 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par25 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par10,nDivide)
	If Empty(aCtbMoeda[1])                       
      Help(" ",1,"NOMOEDA")
      lRet := .F.
   Endif
Endif

If lRet
	If (mv_par35 == 1) .and. ( Empty(mv_par36) .or. Empty(mv_par37) )
		cMensagem	:= STR0023	// "Favor preencher os parametros Grupos Receitas/Despesas e Data Sld Ant. Receitas/Despesas ou "
		cMensagem	+= STR0024	// "deixar o parametro Ignora Sl Ant.Rec/Des = Nao "
		MsgAlert(cMensagem,"Ignora Sl Ant.Rec/Des")	
		lRet    	:= .F.	
    EndIf
EndIf

If !lRet
	Set Filter To
	Return
EndIf

If mv_par19 == 1			// Se imprime coluna movimento -> relatorio 220 colunas
	tamanho := "G"
EndIf

//SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,1))	
                           
If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR190Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,cSayClVl,nDivide)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTR190IMP ³ Autor ³ Simone Mie / Gustavo  ³ Data ³ 28.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio -> Balancete Conta/Classe de Valor.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTR190Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,cSayClVl) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1   - A‡ao do Codeblock                                ³±±
±±³          ³ ExpC1   - T¡tulo do relat¢rio                              ³±±
±±³          ³ ExpC2   - Mensagem                                         ³±±
±±³          ³ ExpA1   - Matriz ref. Config. Relatorio                    ³±±
±±³          ³ ExpA2   - Matriz ref. a moeda                              ³±±
±±³          ³ ExpC3   - Descricao da cl.valor utilizada pelo usuario.    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR190Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,cSayClVl,nDivide)

LOCAL CbTxt			:= Space(10)
Local CbCont		:= 0
LOCAL tamanho		:= "M"
LOCAL limite		:= 132
Local cabec1  		:= ""
Local cabec2		:= ""

Local aColunas		

Local cSepara1  	:= ""
Local cSepara2      := ""
Local cPicture
Local cDescMoeda

Local cMascara1
Local cMascara2
Local cGrupo		:= ""
Local cClVlAnt 		:= ""
Local cSegAte   	:= mv_par14
Local cArqTmp

Local dDataLP		:= mv_par28
Local dDataFim		:= mv_par02

Local lFirstPage	:= .T.
Local lPula			:= .F.
Local l132			:= .T.
Local lImpAntLP		:= Iif(mv_par27 == 1,.T.,.F.)
Local lJaPulou		:= .F.
Local lPrintZero	:= Iif(mv_par23==1,.T.,.F.)
Local lPulaSint		:= Iif(mv_par22==1,.T.,.F.) 
Local lVlrZerado	:= Iif(mv_par09==1,.T.,.F.)

Local nDecimais
Local nTotSalAnt    := 0
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotSalAtu    := 0
Local nTamClVl		:= Len(CriaVar("CTH_CLVL"))
Local nTotItSalAnt  := 0
Local nTotItDeb		:= 0
Local nTotItCrd		:= 0
Local nTotItSalAtu  := 0

Local nDigitAte	:= 0
Local nDigClAte	:= 0
Local nTotMov		:= 0
Local nCont			:= 0

Local lRecDesp0		:= Iif(mv_par35==1,.T.,.F.)
Local cRecDesp		:= mv_par36
Local dDtZeraRD		:= mv_par37
Local lCtiSint      := ( mv_par34 == 1 .OR. mv_par34 == 3 ) 
cDescMoeda 	:= aCtbMoeda[2]
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par10)

//Mascara da Conta
If Empty(aSetOfBook[2])
	cMascara1 := GetMv("MV_MASCARA")
Else
	cMascara1 	:= RetMasCtb(aSetOfBook[2],@cSepara1)
EndIf             

// Mascara da Classe de Valor
If Empty(aSetOfBook[8])
	cMascara2 := ""
Else
	cMascara2 := RetMasCtb(aSetOfBook[8],@cSepara2)
EndIf

cPicture 		:= aSetOfBook[4]

If mv_par19 == 1 // Se imprime saldo movimento do periodo
	cabec1 := OemToAnsi(STR0004)  //"|  CODIGO                     |      D E S C R I C A O                          |    SALDO ANTERIOR              |    DEBITO       |      CREDITO      |    MOVIMENTO DO PERIODO       |         SALDO ATUAL               |"
	tamanho := "G"
	limite	:= 220        
	l132	:= .F.
Else	
	cabec1 := OemToAnsi(STR0005)  //"|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
Endif      

SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,1))	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par07 == 1 //sintetico
	Titulo:=	OemToAnsi(STR0007) + Upper(cSayClVl)+ " / "+Upper(OemToAnsi(STR0021))		//"BALANCETE SINTETICO DE  /CONTA"
ElseIf mv_par07 == 2 //analitico
	Titulo:=	OemToAnsi(STR0006) + Upper(cSayClVl)+ " / "+Upper(OemToAnsi(STR0021)) 	//"BALANCETE ANALITICO DE  /CONTA"
ElseIf mv_par07 == 3 //ambas
	Titulo:=	OemToAnsi(STR0008) + Upper(cSayClVl)+ " / "+Upper(OemToAnsi(STR0021))		//"BALANCETE DE / CONTA"
EndIf

Titulo += 	OemToAnsi(STR0009) + DTOC(mv_par01) + OemToAnsi(STR0010) + Dtoc(mv_par02) + ;
				OemToAnsi(STR0011) + cDescMoeda

If mv_par12 > "1"
	Titulo += " (" + Tabela("SL", mv_par12, .F.) + ")"
EndIf

If nDivide > 1			
	Titulo += " (" + OemToAnsi(STR0022) + Alltrim(Str(nDivide)) + ")"
EndIf	

If l132
	aColunas := { 000,001, 024, 025, 057,058, 077, 078, 094, 095, 111, , , 112, 131 }
Else
	aColunas := { 000,001, 030, 032, 080,082, 112, 114, 131, 133, 151, 153, 183,185,219}
Endif

m_pag := mv_par11
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CTI","",mv_par03,mv_par04,,,,,mv_par05,mv_par06,mv_par10,;
				mv_par12,aSetOfBook,mv_par15,mv_par16,mv_par17,mv_par18,;
				l132,.T.,,"CTH",lImpAntLP,dDataLP, nDivide,lVlrZerado,,,;
				mv_par30,mv_par31,mv_par32,mv_par33,,,,,,,,,aReturn[7],lRecDesp0,;
				cRecDesp,dDtZeraRD,,,,,,,,,aSelFil,,,,,,,,lCtiSint,lTodasFil)},;
				OemToAnsi(OemToAnsi(STR0014)),;  //"Criando Arquivo Tempor rio..."
				OemToAnsi(STR0003)+cSayClVl)   //"Balancete Verificacao Conta /"

// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
	For nCont := 1 to Val(cSegAte)
		nDigitAte += Val(Subs(cMascara1,nCont,1))	
	Next
EndIf		

// Verifica Se existe filtragem Ate o Segmento
If !Empty(mv_par29)
	For nCont := 1 to Val(mv_par29)
		nDigClAte += Val(Subs(cMascara2,nCont,1))	
	Next
EndIf		

dbSelectArea("cArqTmp")
dbSetOrder(1)
dbGoTop()
                  
//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial 
//nao esta disponivel e sai da rotina.
If RecCount() == 0 .And. !Empty(aSetOfBook[5])                                       
	dbCloseArea()
	FErase(cArqTmp+GetDBExtension())
	FErase("cArqInd"+OrdBagExt())
	Return
Endif

SetRegua(RecCount())

cClVlAnt := cArqTmp->CLVL

While !Eof()

	If lEnd
		@Prow()+1,0 PSAY OemToAnsi(STR0017)   //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()

	******************** "FILTRAGEM" PARA IMPRESSAO *************************

	If mv_par34 == 1					// So imprime Sinteticas
		If TIPOCLVL == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par34 == 2				// So imprime Analiticas
		If TIPOCLVL == "1"
			dbSkip()
			Loop
		EndIf
	EndIf

	If mv_par07 == 1					// So imprime Sinteticas
		If TIPOCONTA == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par07 == 2				// So imprime Analiticas
		If TIPOCONTA == "1"
			dbSkip()
			Loop
		EndIf
	EndIf

	//Filtragem ate o Segmento da Conta( antigo nivel do SIGACON)		
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf

	//Filtragem ate o Segmento do CLVL ( antigo nivel do SIGACON)		
	If !Empty(mv_par29)
		If Len(Alltrim(CLVL)) > nDigCLAte
			dbSkip()
			Loop
		Endif
	EndIf

	************************* ROTINA DE IMPRESSAO *************************
	
	If (cClVlAnt <> cArqTmp->CLVL) .And. !lFirstPage
		@li,00 PSAY	Replicate("-",limite)
		li++
		@li,0 PSAY "|"          			                    
		// T O T A I S  D O 
		@li, 30 PSAY OemToAnsi(STR0020)+ RTrim(Upper(cSayClVl)) + " : "
		If mv_par24 == 2 //Se Imprime Cod. Red. Cl.Valor
			dbSelectArea("CTH")
			dbSetOrder(1)
			dbSeek(xFilial("CTH")+cClVlAnt)
			If CTH->CTH_CLASSE == '2' //Se for Analitico				
				EntidadeCTB(CTH->CTH_RES,li,60,nTamClVl+len(cSepara2),.F.,cMascara2,cSepara2)					
			Else 	//Se for sintetico, imprime cod. normal
				EntidadeCTB(cClVlAnt,li,60,nTamClVl+len(cSepara2),.F.,cMascara2,cSepara2)								
			Endif                            
			dbSelectArea("cArqTmp")
		Else
			EntidadeCTB(cClVlAnt,li,60,nTamClVl+len(cSepara2),.F.,cMascara2,cSepara2)	
		Endif                            
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		ValorCTB(nTotItDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		ValorCTB(nTotItCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		
		If !l132
			nTotMov := nTotItCrd - nTotItDeb
			If Round(NoRound(nTotMov,3),2) < 0
				ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
			ElseIf Round(NoRound(nTotMov,3),2) >= 0
				ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
	        EndIf
			@ li,aColunas[COL_SEPARA7] PSAY "|"	
		Endif
		@ li,aColunas[COL_SEPARA8] PSAY "|"
		nTotItDeb := 0
		nTotItCrd := 0                     
		If mv_par21 == 1
			li := 60  
			lPula := .T.
		Else
			li ++
		EndIf	
	Endif	
	
	If mv_par13 == 1				// Grupo Diferente
		If cGrupo != GRUPO
			lPula := .T.
			li		:= 60
			cGrupo:= GRUPO
		EndIf		
	Else          
		If mv_par21 == 1 
			If cClVlAnt <> cArqTmp->CLVL //Se o item atual for diferente do item anterior
				lPula := .T.
				li 	:= 60
			EndIf
		Endif
	EndIf          
	
	    
	If li > 58 
		If !lFirstPage
			@ Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		If mv_par21 == 1 .or. lFirstPage
			@ li,000 PSAY REPLICATE("-",limite)
 			li++
			@ li,000 PSAY "|"                                
			@ li,001 PSAY Upper(cSayClVl) + " : "
			If mv_par24 == 2 .And. cArqTmp->TIPOCLVL == '2' //Se eh analitico e imprime reduzido
				EntidadeCTB(CLVLRES,li,17,nTamClVl+len(cSepara2),.F.,cMascara2,cSepara2)			
			Else
				EntidadeCTB(CLVL,li,17,nTamClVl+len(cSepara2),.F.,cMascara2,cSepara2)
			Endif
			@ li,aColunas[COL_CONTA]+ Len(CriaVar("CTH_DESC01")) PSAY " - " +cArqTMP->DESCCLVL
			@ li,131 PSAY "|"		                                        
			li++
			@ li,000 PSAY REPLICATE("-",limite)		
			li+=1		
		Endif
		lFirstPage := .F.		
	Endif
    
	If (mv_par21 == 2 .And. cClVlAnt <> cArqTmp->CLVL	) .Or. li > 58
		@ li,000 PSAY REPLICATE("-",limite)
		li++
		@ li,000 PSAY "|"                                
		@ li,001 PSAY Upper(cSayClVl) + " : "
		If mv_par24 == 2 .And. cArqTmp->TIPOCLVL == '2'//Se Imprime Red. e o tipo Cl.Valor eh analitico
			EntidadeCTB(CLVLRES,li,17,nTamClVl+len(cSepara2),.F.,cMascara2,cSepara2)
		Else
			EntidadeCTB(CLVL,li,17,nTamClVl+len(cSepara2),.F.,cMascara2,cSepara2)
		EndIf		
		@ li,aColunas[COL_CONTA]+ Len(CriaVar("CTH_DESC01")) PSAY " - " +cArqTMP->DESCCLVL
		@ li,131 PSAY "|"		                                        
		li++
		@ li,000 PSAY REPLICATE("-",limite)		
		li+=1			
	Endif                     

	@ li,aColunas[COL_SEPARA1] PSAY "|"
	If mv_par26 == 2 .and. cArqTmp->TIPOCONTA == "2"
		EntidadeCTB(CTARES,li,aColunas[COL_CONTA],20,.F.,cMascara1,cSepara1)
	Else
		EntidadeCTB(CONTA,li,aColunas[COL_CONTA],20,.F.,cMascara1,cSepara1)
	Endif		
	@ li,aColunas[COL_SEPARA2] PSAY "|"
	@ li,aColunas[COL_DESCRICAO] PSAY Substr(DESCCTA,1,31)
	@ li,aColunas[COL_SEPARA3] PSAY "|"
	ValorCTB(SALDOANT,li,aColunas[COL_SALDO_ANT],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4] PSAY "|"
	ValorCTB(SALDODEB,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5] PSAY "|"
	ValorCTB(SALDOCRD,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6] PSAY "|"
	If !l132
		ValorCTB(MOVIMENTO,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"	
	Endif
	ValorCTB(SALDOATU,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] PSAY "|"

	lJaPulou := .F.
	If lPulaSint .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
		li++
		@ li,aColunas[COL_SEPARA1] PSAY "|"
		@ li,aColunas[COL_SEPARA2] PSAY "|"
		@ li,aColunas[COL_SEPARA3] PSAY "|"	
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		If !l132  
			@ li,aColunas[COL_SEPARA7] PSAY "|"
			@ li,aColunas[COL_SEPARA8] PSAY "|"
		Else
			@ li,aColunas[COL_SEPARA8] PSAY "|"
		EndIf	
		li++
		lJaPulou := .T.
	Else
		li++
	EndIf	

	************************* FIM   DA  IMPRESSAO *************************
	
	If mv_par07 != 1					// Imprime Analiticas ou Ambas
		If TIPOCONTA == "2"
			If (mv_par34 != 1 .And. TIPOCLVL == "2")
				nTotDeb 		+= SALDODEB 
				nTotCrd    		+= SALDOCRD
			ElseIf (mv_par34 == 1 .And. TIPOCLVL != "2"	)
					nTotDeb 		+= SALDODEB 
					nTotCrd    		+= SALDOCRD			
			EndIf	
			nTotItDeb 		+= SALDODEB
			nTotItCrd 		+= SALDOCRD				
		Endif
	Else
		If (TIPOCONTA == "1" .And. Empty(SUPERIOR))
			If (mv_par34 != 1 .And. TIPOCLVL == "2")
				nTotDeb 		+= SALDODEB 
				nTotCrd    		+= SALDOCRD
			ElseIf (mv_par34 == 1 .And. TIPOCLVL != "2"	)
				nTotDeb 		+= SALDODEB 
				nTotCrd    		+= SALDOCRD	
			EndIf	
			nTotItDeb 		+= SALDODEB
			nTotItCrd 		+= SALDOCRD							
		EndIf		
	Endif

	cClVlAnt := cArqTmp->CLVL
	dbSkip()
	If lPulaSint .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
		If !lJaPulou
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			@ li,aColunas[COL_SEPARA2] PSAY "|"
			@ li,aColunas[COL_SEPARA3] PSAY "|"	
			@ li,aColunas[COL_SEPARA4] PSAY "|"
			@ li,aColunas[COL_SEPARA5] PSAY "|"
			@ li,aColunas[COL_SEPARA6] PSAY "|"
			If !l132  
				@ li,aColunas[COL_SEPARA7] PSAY "|"
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			Else
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			EndIf	
			li++
		EndIf	
	EndIf	
	
EndDO

//Imprime o total do ultimo item a ser impresso.
@li,00 PSAY	Replicate("-",limite)
li++
@li,0 PSAY "|"          			
//T O T A I S  D O
@li, 30 PSAY OemToAnsi(STR0020)+ RTrim(Upper(cSayClVl)) + " :"
If mv_par24 == 2 //Se Imprime Cod. Red. Cl.Valor
	dbSelectArea("CTH")
	dbSetOrder(1)
	dbSeek(xFilial("CTH")+cClVlAnt)
	If CTH->CTH_CLASSE == '2' //Se for Analitico				
		EntidadeCTB(CTH->CTH_RES,li,61,nTamClVl+len(cSepara2),.F.,cMascara2,cSepara2)					
	Else 	//Se for sintetico, imprime cod. normal
		EntidadeCTB(cClVlAnt,li,61,nTamClVl+len(cSepara2),.F.,cMascara2,cSepara2)								
	Endif                            
	dbSelectArea("cArqTmp")
Else
	EntidadeCTB(cClVlAnt,li,61,nTamClVl+len(cSepara2),.F.,cMascara2,cSepara2)	
Endif                            
@ li,aColunas[COL_SEPARA4] PSAY "|"
ValorCTB(nTotItDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero )
@ li,aColunas[COL_SEPARA5] PSAY "|"
ValorCTB(nTotItCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)			
@ li,aColunas[COL_SEPARA6] PSAY "|"
If !l132
	nTotMov := nTotItCrd - nTotItDeb
	If Round(NoRound(nTotMov,3),2) < 0
		ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
	ElseIf Round(NoRound(nTotMov,3),2) >= 0
		ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
	EndIf
	@ li,aColunas[COL_SEPARA7] PSAY "|"	
Endif
@ li,aColunas[COL_SEPARA8] PSAY "|"
nTotItDeb := 0
nTotItCrd := 0         

IF li != 80 .And. !lEnd
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY "|"          			
	@li, 39 PSAY OemToAnsi(STR0018)  		//"T O T A I S  D O  P E R I O D O : "
	@ li,aColunas[COL_SEPARA4] PSAY "|"	
	ValorCTB(nTotDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5] PSAY "|"
	ValorCTB(nTotCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6] PSAY "|"
	If !l132
		nTotMov := nTotCrd - nTotDeb
		If Round(NoRound(nTotMov,3),2) < 0
			ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
		ElseIf Round(NoRound(nTotMov,3),2) >= 0
			ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
        EndIf
		@ li,aColunas[COL_SEPARA7] PSAY "|"	
	Endif

	@ li,aColunas[COL_SEPARA8] PSAY "|"
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY " "
	If !lExterno
		roda(cbcont,cbtxt,"M")
		Set Filter To
	EndIf		
EndIF

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase("cArqInd"+OrdBagExt())
EndIf	
dbselectArea("CT2")

MS_FLUSH()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTR190SX1    ³Autor ³  Simone Mie Sato     ³Data³ 16/05/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria as perguntas do relatório                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTR190SX1()

Local aArea 	:= GetArea()


aPergs 		:= {}    

aHelpPor	:= {} 
aHelpEng	:= {}	
aHelpSpa	:= {}

Aadd(aHelpPor,"Informe se deseja ignorar o saldo ")			
Aadd(aHelpPor,"anterior das contas de receitas/despesas ")
Aadd(aHelpPor,"de acordo com o grupo e a data escolhida nas ")
Aadd(aHelpPor,"duas perguntas abaixo.")

Aadd(aHelpEng,"Enter if you want to ignore the prior ")
Aadd(aHelpEng,"balance of  revenue/expense accounts ")
Aadd(aHelpEng,"according to the group and chosen date ")
Aadd(aHelpEng,"in teh two queries below.")

Aadd(aHelpSpa,"Informe si desea ignorar el saldo ")
Aadd(aHelpSpa,"anterior de las cuentas de ingresos/ ")
Aadd(aHelpSpa,"gastos  de acuerdo con el grupo y la ")                             
Aadd(aHelpSpa,"fecha elegida en las dos preguntas ")
Aadd(aHelpSpa,"siguientes.")

Aadd(aPergs,{"Ignora Sl Ant.Rec/Des?","¨Ignora Sl Ant.Ing/Gas?","Ignore Rev/Exp.Pr.Blc?","mv_chz","N",1,0,0,"C","","mv_par35","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})

aHelpPor	:= {} 
aHelpEng	:= {}	
aHelpSpa	:= {}

Aadd(aHelpPor,"Informe quais os grupos de receitas/despesas")			
Aadd(aHelpPor,"que deverao ter seus saldos anteriores ignorados.")
Aadd(aHelpPor,"Essa pergunta sera considerada somente se a pergunta ")
Aadd(aHelpPor,"'Ignora Sl Ant.Rec/Des' estiver preenchida com 'Sim'.")                       

Aadd(aHelpEng,"Inform which revenue/expense groups must ")
Aadd(aHelpEng,"hold their prior balances ignored. ")
Aadd(aHelpEng,"This query will only be considered if the one ")
Aadd(aHelpEng,"'Ignore Rev/Exp.Pr.Blc' is filled out with 'Yes'")

Aadd(aHelpSpa,"Informe los grupos de ingresos/gastos que ")
Aadd(aHelpSpa,"deben tener sus saldos anteriores ignorados.")
Aadd(aHelpspa,"Esta pregunta solo se hara en el caso que ")                             
Aadd(aHelpspa,"'¨Ignora Sl Ant.Ing/Gas?' haya sido llenada ")
Aadd(aHelpspa," con 'Si'.")


Aadd(aPergs,{"Grupo Receitas/Desp. ?","¨Grupo Ingres./Gastos?","Revenue/Exp.Group?","mr_chz","C",5,0,0,"G","","mv_par36","","","","","","","","","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})

aHelpPor	:= {} 
aHelpEng	:= {}	
aHelpSpa	:= {}

Aadd(aHelpPor,"Informe qual a data que as contas de receitas/despesas")			
Aadd(aHelpPor,"terao seus saldos anteriores ignorados.")
Aadd(aHelpPor,"Essa pergunta sera considerada somente se a pergunta ")
Aadd(aHelpPor,"'Ignora Sl Ant.Rec/Des' estiver preenchida com 'Sim'.")

Aadd(aHelpEng,"Inform which date the revenue/expense accounts will ")
Aadd(aHelpEng," hold their prior balances ignored.This query will ")
Aadd(aHelpEng," only be considered if the one 'Ignore Rev/Exp.Pr.Blc'")
Aadd(aHelpEng," is filled out with 'Yes'.")                          

Aadd(aHelpSpa,"Informe la fecha en que las cuentas de ingresos/gastos ")
Aadd(aHelpSpa,"tendran sus saldos anteriores ignorados. ")
Aadd(aHelpspa,"Esta pregunta solo se hara en el caso que ")                             
Aadd(aHelpSpa,"'¨Ignora Sl Ant.Ing/Gas?' haya sido llenada con 'Si'.")

Aadd(aPergs,{"Data Sld Ant.Rec/Desp?"      ,"¨Fecha Sld Ant.Ing/Gas?","Rev/Exp.Prior Blc.Date?","mv_chz","D",8,0,0,"G","","mv_par37","","","","","","","","","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})

aHelpPor	:= {} 
aHelpEng	:= {}	
aHelpSpa	:= {}

Aadd(aHelpPor,"Escolha Sim se deseja selecionar ")			
Aadd(aHelpPor,"as filiais")			

Aadd(aHelpEng,"Enter Yes if you want to select ")		
Aadd(aHelpEng,"the branches")
	
Aadd(aHelpSpa,"La opción Sí, permite seleccionar ")
Aadd(aHelpSpa,"las sucursales")
	
Aadd(aPergs,{"Seleciona Filiais?" , "Selecciona sucursales?" , "Select Branches?" ,"MV_CHZ","N",1,0,2,"C",,"MV_PAR38","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})
PutSX1Help("P.CTR19038.",aHelpPor,aHelpEng,aHelpSpa)	

AjustaSx1("CTR190",aPergs)   

//Apaga conteudo do campo X1_F3 do parametro MV_PAR28
SX1->(DbSetOrder(1))
If SX1->(DbSeek(Padr("CTR190",Len(X1_GRUPO))+"28"))
	If !Empty(SX1->X1_F3)
		RecLock("SX1",.F.)
		SX1->X1_F3 := ""
		SX1->(MsUnLock())
	EndIf
EndIf

RestArea(aArea)

Return
