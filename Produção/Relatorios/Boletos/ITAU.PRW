#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ITAU     ³ Autor ³                       ³ Data ³ 01/06/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER ITAU COM CODIGO DE BARRAS        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ITAU()

LOCAL   aCampos := {{"E1_NOMCLI","Cliente","@!"},{"E1_PREFIXO","Prefixo","@!"},{"E1_NUM","Titulo","@!"},;
{"E1_PARCELA","Parcela","@!"},{"E1_VALOR","Valor","@E 9,999,999.99"},{"E1_VENCTO","Vencimento"}}
LOCAL   nOpc     := 0
LOCAL   aMarked  := {}

PRIVATE Exec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''
Private _nTotDesc  := 0
PUBLIC  aDadosNF   := {}

dbSelectArea("SE1")

cPerg := "BLITAU"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PutSx1(cPerg,"01","Prefixo de ?"              ,"","","mv_ch1" ,"C",03,0,0,"G","","","","","mv_par01" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"02","Prefixo Ate?"              ,"","","mv_ch2" ,"C",03,0,0,"G","","","","","mv_par02" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"03","Numero de?"                ,"","","mv_ch3" ,"C",09,0,0,"G","","","","","mv_par03" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"04","Numero Ate?"               ,"","","mv_ch4" ,"C",09,0,0,"G","","","","","mv_par04" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"05","Parcela de?"               ,"","","mv_ch5" ,"C",01,0,0,"G","","","","","mv_par05" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"06","Parcela Ate?"              ,"","","mv_ch6" ,"C",01,0,0,"G","","","","","mv_par06" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"07","Bordero de ?"              ,"","","mv_ch7" ,"C",06,0,0,"G","","","","","mv_par07" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"08","Bordero Ate?"              ,"","","mv_ch8" ,"C",06,0,0,"G","","","","","mv_par08" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"09","Emissao de ?"              ,"","","mv_cha" ,"D",08,0,0,"G","","","","","mv_par09" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"10","Emissao Ate?"              ,"","","mv_chb" ,"D",08,0,0,"G","","","","","mv_par10" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"11","Cliente de ?"              ,"","","mv_chc" ,"C",06,0,0,"G","","SA1","","","mv_par11" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"12","Cliente Ate?"              ,"","","mv_chd" ,"C",06,0,0,"G","","SA1","","","mv_par12" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")

If !Pergunte(cPerg,.T.)
	Return()
EndIf

cIndexName := Criatrab(Nil,.F.)
cIndexKey  := 	"E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
cFilter    := 	"E1_PREFIXO >= '" + MV_PAR01 + "' .And. E1_PREFIXO <= '" + MV_PAR02 + "' .And. "
cFilter    += 	"E1_NUM     >= '" + MV_PAR03 + "' .And. E1_NUM     <= '" + MV_PAR04 + "' .And. "
cFilter    += 	"E1_PARCELA >= '" + MV_PAR05 + "' .And. E1_PARCELA <= '" + MV_PAR06 + "' .And. "
cFilter    += 	"E1_FILIAL   = '" + xFilial("SE1")+ "' .And. "
cFilter    += 	"E1_CLIENTE >= '" + MV_PAR11 + "' .And. E1_CLIENTE <= '" + MV_PAR12 + "' .And. "
cFilter    += 	"((E1_FATURA = 'NOTFAT' .AND. E1_SALDO = 0 .And. "
cFilter    += 	"Dtos(E1_EMISSAO) >= '"+Dtos(MV_PAR09)+"' .AND. Dtos(E1_EMISSAO) <= '"+DTOS(MV_PAR10)+"' .AND. E1_PORTADO = '341') .Or. "
cFilter    += 	"(E1_SALDO > 0 .AND. E1_NUMBOR  >= '" + MV_PAR07 + "' .And. E1_NUMBOR  <= '" + MV_PAR08 + "' .AND. E1_PORTADO = '341')) .And. "
cFilter    += 	"SubsTring(E1_TIPO,3,1) != '-' "

DbSelectArea("SE1")
DbSetOrder(12) //Filial +- Bordero + Emissao
DBSEEK(xFILIAL("SE1")+MV_PAR07,.t.)

z := 0
While !EOF() .and. xFilial("SE1") == SE1->E1_FILIAL .and. SE1->E1_NUMBOR >= MV_PAR07 .AND. SE1->E1_NUMBOR <=  MV_PAR08
	
	_nRecE1    := RecNo()
	_nIndE1    := IndexOrd()
	_cFatPref  := SE1->E1_FATPREF
	_cPrefix   := SE1->E1_PREFIXO
	_cTitulo   := SE1->E1_NUM
	_cCliente  := SE1->E1_CLIENTE
	_cLoja     := SE1->E1_LOJA
	_cFatura   := SE1->E1_FATURA
	_cTitulos  := ""
	_lPrim     := .F.
	_cTit      := ""
	If SE1->E1_FATURA == "NOTFAT"
		DbSelectArea("SE1")
		DbSetOrder(10)
		If DbSeek(xFilial("SE1") + _cCliente + _cLoja + _cPrefix + _cTitulo)
			
			While !Eof() .And. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_FATPREF+SE1->E1_FATURA ==;
				xFilial("SE1")+_cCliente+_cLoja+_cPrefix+_cTitulo
				
				_cTit += If(!_lPrim , "" , "-") + SE1->E1_NUM
				_lPrim    := .T.
				DbSkip()
			End
		Endif
		
	Else
		_cTit +=  SE1->E1_NUM
	EndIf
	
	z++
	DbSelectArea("SE1")
	DbGoTo(_nRecE1)
	DbSetOrder(_nIndE1)
	DbSelectArea("SE1")
	aadd(aDadosNF,{SE1->E1_NUM,_cTit})
	SE1->(DBSKIP())
	
End

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")
dbGoTop()

@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Titulos"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
@ 180,310 BMPBUTTON TYPE 01 ACTION (Exec:=.T.,Close(oDlg))
@ 180,280 BMPBUTTON TYPE 02 ACTION (Exec:=.F.,Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED

dbGoTop()
Do While !Eof()
	If Marked("E1_OK")
		AADD(aMarked,.T.)
	Else
		AADD(aMarked,.F.)
	EndIf
	dbSkip()
EndDo

dbGoTop()

IF Exec
	Processa({|lEnd|MontaRel(aMarked,aDadosNF)})
EndIF

RetIndex("SE1")
fErase(cIndexName+OrdBagExt())

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³                       ³ Data ³ 23/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER        COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel(aMarked,aDadosNF)
LOCAL   oPrint
LOCAL   n := 0
LOCAL bBitmap := "logo341.bmp"
LOCAL aBitmap := ""

LOCAL aDadosEmp    := {	SM0->M0_NOMECOM										,; //[1]Nome da Empresa
SM0->M0_ENDCOB																,; //[2]Endereço
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB	,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)				,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL													,; //[5]Telefones
"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+			; //[6]
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+						; //[6]
Subs(SM0->M0_CGC,13,2)														,; //[6]CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+			; //[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)							}  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {}
LOCAL i            := 1
LOCAL CB_RN_NN     := {}
LOCAL nRec         := 0
LOCAL _nVlrAbat    := 0
Local a_TitCmp     := {}

oPrint:= TMSPrinter():New("Boleto Laser")
oPrint:Setup()
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página

dbGoTop()
Do While !EOF()
	nRec++
	dbSkip()
EndDo
dbGoTop()

ProcRegua(nRec)

Do While !EOF()
	
	DbSelectArea("SA6") //Posiciona o SA6 (Bancos)
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	
	DbSelectArea("SEE") //Posiciona no Arq de Parametros CNAB
	DbSetOrder(1)
	DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	/*
	aBolText     := {SEE->EE_MSG01,;
	SEE->EE_MSG02,;
	SEE->EE_MSG03,;
	SEE->EE_MSG04}
	*/
	
	If aMarked[i]
		If Empty(SE1->E1_NUMBCO)
			_oNossoNum := StrZero((Val(Alltrim(SEE->EE_FAXATU))+1),8)
			RecLock("SEE",.f.)
			SEE->EE_FAXATU := _oNossoNum
			MsUnlock()
		Else
			_oNossoNum := SE1->E1_NUMBCO
		Endif
	Endif
	
	_nTotDesc := 0
	a_TitCmp     := F_AchTit()
	
	DbSelectArea("SA1")	//Posiciona o SA1 (Cliente)
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	
	DbSelectArea("SE1")
	
	aDadosBanco  := {SA6->A6_COD	,; // [1]Numero do Banco
	SA6->A6_NOME					,; // [2]Nome do Banco
	Substr(SA6->A6_AGENCIA, 1, 4)	,; // [3]Agência
	Substr(SA6->A6_NUMCON,1,5)		,; // [4]Conta Corrente
	Substr(SA6->A6_NUMCON,6,1)		,; // [5]Dígito da conta corrente
	SEE->EE_CODCART					,; // [6]Codigo da Carteira
	Substr(SA6->A6_AGENCIA, 5, 1)	,; // [7]Digito da Agencia
	AllTrim(SA6->A6_NUMBCO)			} // [8]Codigo do Convenio
	
	aDatSacado   := {AllTrim(SA1->A1_NOME)				,;     // [1]Razão Social
	AllTrim(SA1->A1_COD)+"-"+SA1->A1_LOJA				,;     // [2]Código
	AllTrim(SA1->A1_END)+"-"+AllTrim(SA1->A1_BAIRRO)	,;     // [3]Endereço
	AllTrim(SA1->A1_MUN)								,;     // [4]Cidade
	SA1->A1_EST											,;     // [5]Estado
	SA1->A1_CEP											,;     // [6]CEP
	SA1->A1_CGC											}      // [7]CGC
	
	If aMarked[i]
		_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		//       _nVlrLiq    :=  Round((SE1->E1_SALDO+SE1->E1_ACRESC-_nVlrAbat-SE1->E1_DECRESC),2)
		CB_RN_NN    := Ret_cBarra(aDadosBanco[1],;
		aDadosBanco[3],;
		aDadosBanco[4],;
		aDadosBanco[5],;
		AllTrim(_oNossoNum),;
		Round((SE1->E1_SALDO+SE1->E1_ACRESC-_nVlrAbat-SE1->E1_DECRESC),2),;
		E1_VENCTO,;
		aDadosBanco[8],;
		aDadosBanco[6])
		
		aDadosTit    := {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)	,;  // [1] Número do título
		E1_EMISSAO                              				,;  // [2] Data da emissão do título
		Date()                                          		,;  // [3] Data da emissão do boleto
		E1_VENCTO                               				,;  // [4] Data do vencimentoDatavalida(E1_VENCTO,.T.)
		Round((SE1->E1_SALDO+SE1->E1_ACRESC-_nVlrAbat-SE1->E1_DECRESC),2),;// [5] Valor do título
		CB_RN_NN[3]                             				,;  // [6] Nosso número (Ver fórmula para calculo)
		E1_PREFIXO                               				,;  // [7] Prefixo da NF
		E1_TIPO	                               					 }  // [8] Tipo do Titulo
		
		oInd := Ascan(aDadosNF,{|aval| aval[1]=SE1->E1_NUM})
		IF oInd == 0
			_oTexto := ""
		Else
			_oTexto := aDadosNF[oInd,2]
		End
		
		Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN,_oTexto,a_TitCmp)
		n++
	EndIf
	
	dbSkip()
	IncProc()
	i++
EndDo

//oPrint:Print()
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³                       ³ Data ³ 23/05/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER        COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN,_oTexto,a_TitCmp)
LOCAL _nTxper := GETMV("MV_TXPER")
LOCAL oFont2n
LOCAL oFont8
LOCAL oFont9
LOCAL oFont10
LOCAL oFont15n
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont12n
LOCAL oFont14n
LOCAL oFont24
LOCAL i := 0
Local Iw

aBmp := "logo341.bmp"
oBmp := "" //Logo do cedente

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F.)
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12n:= TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20n:= TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oBrush := TBrush():New("",4)

oPrint:StartPage()   // Inicia uma nova página

oPrint:Line (0150,530,0050, 530) // inicio 001-9
oPrint:Line (0150,710,0050, 710) // final  001-9
oPrint:Line (0150,100,0150,2300) // linha

aBmp := "logo341.bmp"

If File(aBmp)
	oPrint:SayBitmap(0040,0100,aBmp,0400,0100)
Else
	oPrint:Say  (0074,100,"ITAU",oFont14n)	// [2]Nome do Banco
EndIf

oPrint:Say  (0080,530,"341-7",oFont20n)	// [1]Numero do Banco
oPrint:Say  (0090,1600,"Recibo do Sacado",oFont10)

oPrint:Line (0266,100,0266,1600)    //   linha
oPrint:Line (0366,100,0366,1600)    //   linha
oPrint:Line (0436,100,0436,1600)    //   linha
oPrint:Line (0506,100,0506,1600)    //   linha

oPrint:Line (0366, 400,0506,400)     //  1Barra
oPrint:Line (0436, 600,0506,600)     //  2Barra
oPrint:Line (0366, 750,0506,750)     //  3Barra
oPrint:Line (0366, 990,0436,990)     //  4Barra
oPrint:Line (0366,1200,0506,1200)    //  5Barra

oPrint:Say  (0163,100 ,"Local de Pagamento"									,oFont8)
oPrint:Say  (0186,100 ,"ATÉ O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAÚ"	,oFont9)
oPrint:Say  (0226,100 ,"APÓS O VENCIMENTO PAGUE SOMENTE NO ITAÚ."			,oFont9)

oPrint:Say  (0266,100 ,"Cedente"											,oFont8)
oPrint:Say  (0306,100 ,aDadosEmp[1]	,oFont10) //Nome + CNPJ
oBmp := "lgboleto.bmp" //Logo do cedente

oPrint:SayBitmap(0306,1700,oBmp,0500,0500)

oPrint:Say  (0366,100 ,"Data do Documento"									,oFont8)                                   // 2200
oPrint:Say  (0390,100 ,DTOC(aDadosTit[2])									,oFont10) // Emissao do Titulo (E1_EMISSAO)    2230

oPrint:Say  (0366,410 ,"Nro.Documento"										,oFont8)                           // 2200
oPrint:Say  (0390,410 ,aDadosTit[7]+" "+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela  2230

oPrint:Say  (0366,760,"Espécie Doc."										,oFont8)                 // 2200
oPrint:Say  (0390,760,"DP"													,oFont10) //Tipo do Titulo  2230

oPrint:Say  (0366,1000,"Aceite"												,oFont8)  // 2200
oPrint:Say  (0390,1015,"N"													,oFont10)  // 2230

oPrint:Say  (0366,1210,"Data do Processamento"								,oFont8)       // 2200
oPrint:Say  (0390,1210,DTOC(aDadosTit[3])									,oFont10) // Data impressao  2230

oPrint:Say  (0436,100 ,"Uso Banco"											,oFont8)       // 2270

oPrint:Say  (0436,410 ,"Carteira"											,oFont8)       // 2270
oPrint:Say  (0466,410 ,aDadosBanco[6]										,oFont10)      //  2300

oPrint:Say  (0436,610 ,"Espécie"											,oFont8)       //  2270
oPrint:Say  (0466,610 ,"R$"													,oFont10)      //  2300

oPrint:Say  (0436,760,"Quantidade"											,oFont8)       //  2270
oPrint:Say  (0436,1210,"Valor"												,oFont8)       //  2270

oPrint:Say  (0520,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
//oPrint:Say  (0580,100 ,aBolText[1],oFont10)
//oPrint:Say  (0630,100 ,aBolText[2],oFont10)
//oPrint:Say  (0680,100 ,aBolText[3]+"R$ "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)),"@E 99,999.99")),oFont10)

//SRSF
oPrint:Say  (0780,100 ,"Cobranca Referente as Nfs (abaixo), totalizando: *** R$ "+Alltrim(TransForm(E1_SALDO+_nTotDesc,"@E 999,999,999.99"))+"***",oFont10)
//SRSF

oPrint:Say  (0830,100 ,SUBSTR(_oTexto,1,66),oFont10)
oPrint:Say  (0880,100 ,SUBSTR(_oTexto,67),oFont10)

If Len(a_TitCmp) > 0
	oPrint:Say  (0930,100 ,"Desconto ja Concedido atraves dos Creditos Abaixo :",oFont10)
	n_Lin := 930 ; n_Col := 100
	For Iw:=1 To Len(a_TitCMP)
		oPrint:Say (n_Lin+=50,n_Col ,Substr(a_TitCmp[Iw,7],1,3)+"-"+Substr(a_TitCmp[Iw,7],4,6)+"/"+Substr(a_TitCmp[Iw,7],10,1)+"-"+Substr(a_TitCmp[Iw,7],11,3)+" no Valor de R$ "+a_TitCmp[Iw,9],oFont10)
		If Iw > 8
			n_Lin := 930 ; n_Col := 800
		Endif
	Next
Endif
_cDataVenc := SubStr(DTOS(aDadosTit[4]),7,2)+"/"+SubStr(DTOS(aDadosTit[4]),5,2)+"/"+SubStr(DTOS(aDadosTit[4]),1,4)
oPrint:Say  (0770,1610,"Vencimento"					,oFont8)
oPrint:Say  (0800,1910,_cDataVenc					,oFont10)

oPrint:Say  (0840,1610,"Agência / Código Cedente"	,oFont8)
oPrint:Say  (0870,1810,aDadosBanco[3]+"/"+Subs(SA6->A6_NUMCON,1,5)+"-"+Subs(SA6->A6_NUMCON,6,1)	,oFont10)

oPrint:Say  (0910,1610,"Nosso Número"				,oFont8)
oPrint:Say  (0940,1910,aDadosBanco[6]+"/"+SubStr(StrZero(Val(aDadosTit[6]),9),1,8)+"-"+SubStr(StrZero(Val(aDadosTit[6]),9),9,1)		,oFont10)

oPrint:Say  (0980,1610,"(=)Valor do Documento"		,oFont8)
oPrint:Say  (1010,1910,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (1050,1610,"(-)Desconto/Abatimento"		,oFont8)
oPrint:Say  (1120,1610,"(-)Outras Deduções"			,oFont8)
oPrint:Say  (1190,1610,"(+)Mora/Multa"				,oFont8)
oPrint:Say  (1260,1610,"(+)Outros Acréscimos"		,oFont8)
oPrint:Say  (1330,1610,"(=)Valor Cobrado"			,oFont8)

oPrint:Say  (1400,100 ,"Sacado"						,oFont8)
oPrint:Say  (1430,250 ,aDatSacado[1]+"  CGC: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10)

oPrint:Say  (1483,250 ,aDatSacado[3]				,oFont10)
oPrint:Say  (1536,250 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

oPrint:Say  (1620,100 ,"Sacador/Avalista"			,oFont8)
oPrint:Say  (1670,1500,"Autenticação Mecânica -"	,oFont8)

oPrint:Line (0150,1600,1400,1600)       // Linha vertical do recibo do sacado e vencimento
oPrint:Line (0770,1600,0770,2300)
oPrint:Line (0840,1600,0840,2300)
oPrint:Line (0910,1600,0910,2300)
oPrint:Line (0980,1600,0980,2300)
oPrint:Line (1050,1600,1050,2300)
oPrint:Line (1120,1600,1120,2300)
oPrint:Line (1190,1600,1190,2300)
oPrint:Line (1260,1600,1260,2300)
oPrint:Line (1330,1600,1330,2300)
oPrint:Line (1400,100 ,1400,2300)
oPrint:Line (1650,100 ,1650,2300)

For i := 100 to 2300 step 50
	oPrint:Line(1830, i, 1830, i+30)                 // 1850
Next i

oPrint:Line (2030,530,1950, 530) //inicio 001-9
oPrint:Line (2030,710,1950, 710) //final 001-9
oPrint:Line (2030,100,2030,2300) //linha                                                      //   2000

If File(aBmp)
	oPrint:SayBitmap(1920,0100,aBmp,0400,0100)
Else
	oPrint:Say  (1955,100,"ITAU"						,oFont16n)	// [2]Nome do Banco                     1934
EndIf

oPrint:Say  (1953,530,"341-7"							,oFont20n)	// [1]Numero do Banco                       1912

oPrint:Say  (1955,720,CB_RN_NN[2]						,oFont16)		//Linha Digitavel do Codigo de Barras   1934
oPrint:Line (2130,100,2130,2300)    //   linha
oPrint:Line (2230,100,2230,2300)    //   linha
oPrint:Line (2300,100,2300,2300)    //   linha
oPrint:Line (2370,100,2370,2300)    //   linha

oPrint:Line (2230, 400,2370,400)     //  1Barra
oPrint:Line (2300, 600,2370,600)     //  2Barra
oPrint:Line (2230, 750,2370,750)     //  3Barra
oPrint:Line (2230, 990,2300,990)     //  4Barra
oPrint:Line (2230,1200,2370,1200)    //  5Barra

oPrint:Say  (2035,100 ,"Local de Pagamento"				,oFont8)
oPrint:Say  (2055,355 ,"ATÉ O VENCIMENTO PAGUE PREFERENCIALMENTE NO ITAÚ",oFont9)
oPrint:Say  (2095,355 ,"APÓS O VENCIMENTO PAGUE SOMENTE NO ITAÚ.",oFont9)

oPrint:Say  (2045,1610,"Vencimento"						,oFont8)
//oPrint:Say  (2075,1910,DTOC(aDadosTit[4]),oFont10)
oPrint:Say  (2075,1910,_cDataVenc						,oFont10)

oPrint:Say  (2130,100 ,"Cedente"						,oFont8)
oPrint:Say  (2160,100 ,aDadosEmp[1]						,oFont10) //Nome

oPrint:Say  (2130,1610,"Agência/Código Cedente"			,oFont8)
oPrint:Say  (2165,1810,aDadosBanco[3]+"/"+Subs(SA6->A6_NUMCON,1,5)+"-"+Subs(SA6->A6_NUMCON,6,1)	,oFont10)

oPrint:Say  (2230,100 ,"Data do Documento"				,oFont8)                                   // 2200
oPrint:Say  (2260,100 ,DTOC(aDadosTit[2])				,oFont10) // Emissao do Titulo (E1_EMISSAO)    2230

oPrint:Say  (2230,410 ,"Nro.Documento"					,oFont8)                           // 2200
oPrint:Say  (2260,410 ,aDadosTit[7]+" "+aDadosTit[1]	,oFont10) //Prefixo +Numero+Parcela  2230

oPrint:Say  (2230,760,"Espécie Doc."					,oFont8)                 // 2200
//oPrint:Say  (2260,760,aDadosTit[8]									,oFont10) //Tipo do Titulo  2230
oPrint:Say  (2260,760,"DP"								,oFont10) //Tipo do Titulo  2230

oPrint:Say  (2230,1000,"Aceite"							,oFont8)  // 2200
oPrint:Say  (2260,1015,"N"								,oFont10)  // 2230

oPrint:Say  (2230,1210,"Data do Processamento"			,oFont8)       // 2200
oPrint:Say  (2260,1210,DTOC(aDadosTit[3])				,oFont10) // Data impressao  2230

oPrint:Say  (2230,1610,"Nosso Número"					,oFont8)       // 2200
oPrint:Say  (2260,1910,aDadosBanco[6]+"/"+SubStr(StrZero(Val(aDadosTit[6]),9),1,8)+"-"+SubStr(StrZero(Val(aDadosTit[6]),9),9,1)		,oFont10)

oPrint:Say  (2300,100 ,"Uso Banco"						,oFont8)       // 2270

oPrint:Say  (2300,410 ,"Carteira"						,oFont8)       // 2270
oPrint:Say  (2330,410 ,aDadosBanco[6]					,oFont10)      //  2300

oPrint:Say  (2300,610 ,"Espécie"						,oFont8)       //  2270
oPrint:Say  (2330,610 ,"R$"								,oFont10)      //  2300

oPrint:Say  (2300,760,"Quantidade"						,oFont8)       //  2270
oPrint:Say  (2300,1210,"Valor"							,oFont8)       //  2270

oPrint:Say  (2300,1610,"Valor do Documento"				,oFont8)        //  2270
oPrint:Say  (2330,1910,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)  //   2300

oPrint:Say  (2380,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8) // 2340
//oPrint:Say  (2430,100 ,aBolText[1],oFont10)    // 2440
//oPrint:Say  (2480,100 ,aBolText[2],oFont10)  // 2490  // *0.05)/30)
//oPrint:Say  (2530,100 ,aBolText[3]+"R$ "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)),"@E 99,999.99")),oFont10)  // 2490  // *0.05)/30)
//oPrint:Say  (2580,100 ,aBolText[4],oFont10)    //2540
//oPrint:Say  (2580,100 ,"APÓS VENCIMENTO PAGAR NO ITAÚ, BANCOOB OU BANSICRED/SICREDI",oFont10)    //2540

oPrint:Say  (2380,1610,"(-)Desconto/Abatimento"			,oFont8)      //  2340
oPrint:Say  (2450,1610,"(-)Outras Deduções"				,oFont8)      //  3410
oPrint:Say  (2520,1610,"(+)Mora/Multa"					,oFont8)      //  2480
oPrint:Say  (2590,1610,"(+)Outros Acréscimos"			,oFont8)      //  2550
oPrint:Say  (2660,1610,"(=)Valor Cobrado"				,oFont8)      //  2620

oPrint:Say  (2730,100 ,"Sacado"							,oFont8)
oPrint:Say  (2750,250 ,aDatSacado[1]+"   CGC: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10)

oPrint:Say  (2803,250 ,aDatSacado[3]					,oFont10)       // 2773
oPrint:Say  (2856,250 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado  2826

oPrint:Say  (2945,100 ,"Sacador/Avalista"				,oFont8)       //2895
oPrint:Say  (2985,1500,"Autenticação Mecânica -"		,oFont8)
oPrint:Say  (2985,1850,"Ficha de Compensação"			,oFont8)      // 2935 + 280      = 3215

oPrint:Line (2035,1600,2730,1600)         // Liha Vertical Recibo do sacado e Vencimento
oPrint:Line (2440,1600,2440,2300)         // 2410        -
oPrint:Line (2510,1600,2510,2300)         // 2480        -
oPrint:Line (2580,1600,2580,2300)         // 2550        -
oPrint:Line (2650,1600,2650,2300)         // 2620        -
oPrint:Line (2720,100 ,2720,2300)         // 2690        -

oPrint:Line (2975,100 ,2975,2300)         // 2930
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MSBAR       ³ Autor ³                     ³ Data ³  06/05   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime codigo de barras                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 01 cTypeBar String com o tipo do codigo de barras          ³±±
±±³          ³             "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"     ³±±
±±³          ³             "INT25","MAT25,"IND25","CODABAR" ,"CODE3_9"    ³±±
±±³          ³ 02 nRow     Numero da Linha em centimentros                ³±±
±±³          ³ 03 nCol     Numero da coluna em centimentros               ³±±
±±³          ³ 04 cCode    String com o conteudo do codigo                ³±±
±±³          ³ 05 oPr      Objeto Printer                                 ³±±
±±³          ³ 06 lcheck   Se calcula o digito de controle                ³±±
±±³          ³ 07 Cor      Numero  da Cor, utilize a "common.ch"          ³±±
±±³          ³ 08 lHort    Se imprime na Horizontal                       ³±±
±±³          ³ 09 nWidth   Numero do Tamanho da barra em centimetros      ³±±
±±³          ³ 10 nHeigth  Numero da Altura da barra em milimetros        ³±±
±±³          ³ 11 lBanner  Se imprime o linha em baixo do codigo          ³±±
±±³          ³ 12 cFont    String com o tipo de fonte                     ³±±
±±³          ³ 13 cMode    String com o modo do codigo de barras CODE128  ³±±
±±³          ³ 14 lprint   logico para que a impressao seja na chamada da ³±±
±±³          ³             funcao - Default .T.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ImpressÆo de etiquetas c¢digo de Barras para HP e Laser    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

MsBar("INT25"  ,26,1.5,CB_RN_NN[1]    ,oPrint,.F.,,,,1.3,,,,.F.)                     // ANTERIOR

DbSelectArea("SE1")
RecLock("SE1",.f.)
SE1->E1_NUMBCO := 	CB_RN_NN[3]   // Nosso número (Ver fórmula para calculo)
MsUnlock()

oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³                       ³ Data ³ 23/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER        COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Modulo10(cData)

LOCAL L,D,P   := 0
LOCAL B       := 2
LOCAL oDigito := 0
LOCAL aBase   := 10

L := Len(cData)
B := 2
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	//If (B)
	P := P * B
	If P > 9
		P := P - 9
	End
	//End
	D := D + P
	L := L - 1
	B := B - 1
	If B == 0
		B := 2
	End
	//B := !B
End
While .t.
	If aBase >= D
		oDigito := aBase - D
		Exit
	Endif
	aBase := aBase + 10
End

If oDigito == 10
	oDigito := 0
Endif

Return(oDigito)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³                       ³ Data ³ 23/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ CALCULO DO DIGITO VERFICADOR DO CODIGO DE BARRAS E NNUMERO ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
// cData e parte para calcular o digito e cX para definir se do NNumero ou Codigo de Barras
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 2
While L > 0
	D := D + (Val(SubStr(cData, L, 1)) * P)
	L--
	P++
	If P > 9
		P := 2
	End
End

D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D >= 10)
	D := 1
End
Return(D)

//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável, NN = Nosso Numero
//					    		   Codigo Banco            Agencia		  C.Corrente     Digito C/C
//					               1-cBancoc               2-Agencia      3-cConta       4-cDacCC       5-cNroDoc              6-nValor
//	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"175"+AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³                       ³ Data ³ 23/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER        COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto,cConv,cCarteira)

LOCAL oNNum := cNroDoc
LOCAL blvalorfinal := strzero((nValor*100),10)
LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL RN           := ''
LOCAL CB           := ''
LOCAL s            := ''
LOCAL _cfator      := strzero(dVencto - ctod("07/10/97"),4)

//-------- Definicao do NOSSO NUMERO
IF Len(oNNum) == 9  //Caso igual a 9 ja possui o digito verificador.
	oNNum := Substr(oNNum,1,8)
End
NN	  := oNNum + AllTrim(Str(modulo10(cAgencia + cConta + cCarteira + oNNum)))
//---------------------------------- //

//	-------- Definicao do CODIGO DE BARRAS
DigCB  := AllTrim(Str(modulo11(cBanco + "9" + _cFator + blvalorfinal + cCarteira + NN + cAgencia + cConta + AllTrim(Str(modulo10(cAgencia + cConta))) + "000")))
CB     := cBanco + "9" + DigCB + _cFator + blvalorfinal + cCarteira + NN + cAgencia + cConta + AllTrim(Str(modulo10(cAgencia + cConta))) + "000"
//---------------------------------- //

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCCCX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
//Campo 1
dv   := modulo10(cBanco + "9" + cCarteira + SubStr(NN,1,2))
RN   :=	cBanco + "9" + SubStr(cCarteira,1,1) + "." + substr(cCarteira,2,2)+ SubStr(NN,1,2) + AllTrim(Str(dv)) + ' '
//Campo 2
dv   := modulo10(SubStr(NN,3,7) + SubStr(cAgencia,1,3))
RN   +=	SubStr(NN,3,5) + "." + SubStr(NN,8,2) + SubStr(cAgencia,1,3) + AllTrim(Str(dv)) + ' '
//Campo 3
dv   := modulo10(SubStr(cAgencia,4,1)+cConta+cDacCC+"000")
RN   += SubStr(cAgencia,4,1)+SubStr(cConta,1,4)+ "." + SubStr(cConta,5,1) + cDacCC + "000" + Alltrim(str(Dv))+ ' '
//Campo 4
RN   += DigCB + ' '
//Campo 5
RN   += _cfator + blvalorfinal

Return({CB,RN,NN})


Static Function F_AchTit()
***************************
Local   aTitulos :={}

PRIVATE	cPrefixo := SE1->E1_PREFIXO
PRIVATE cNum     := SE1->E1_NUM
PRIVATE	cTipoTit := SE1->E1_TIPO
PRIVATE	cCliente := SE1->E1_CLIENTE
PRIVATE cLoja    := SE1->E1_LOJA
PRIVATE	cParcela := SE1->E1_PARCELA
PRIVATE	dBaixa   := SE1->E1_BAIXA
PRIVATE	cTipodoc := "  "
PRIVATE lCredito := .F.
PRIVATE cTipodc  := " "
PRIVATE nTamTit  := TamSX3("E1_PREFIXO")[1]+TamSX3("E1_NUM")[1]+TamSX3("E1_PARCELA")[1]

If SE1->E1_TIPO $MV_CRNEG+"/"+MVRECANT
	cTipodoc := "BA"
	lCredito:= .T.
	cTipodc:="CP"
Else
	cTipodoc := "CP"
	cTipodc:="BA"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Procura adiantamentos do titulo original.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE5")
dbSetOrder(2)
dbSeek(xFilial("SE5")+cTipoDoc+cPrefixo+cNum+cParcela+cTipoTit)

While (!Eof() .and. cFilial == SE5->E5_FILIAL .And.    ;
	SE5->E5_TIPODOC == cTipoDoc .And.               ;
	SE5->E5_PREFIXO == cPrefixo .And.               ;
	SE5->E5_NUMERO == cNum .And.                    ;
	SE5->E5_PARCELA == cParcela)
	
	If (SE5->E5_MOTBX != "CMP" .Or. SE5->E5_RECPAG != "R")
		dbSkip()
		Loop
	Endif
	
	//Verifica se tem baixa cancelada
	If TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
		SE5->(dbskip())
		loop
	EndIf
	
	// nOrdSE1 := SE1->(IndexOrd())
	// nRegSE1 := SE1->(Recno())
	// nTAbat  := SumAbatRec(cPrefixo,cNum,cParcela,SE1->E1_MOEDA,"V",dBaixa)
	// SE1->(dbSetOrder(nOrdSE1))
	// SE1->(dbGoto(nRegSE1))
	
	// nVlLiqTit:= SE1->E1_VALOR - nTAbat      // Valor do titulo - Abatimentos
	
	Aadd(aTitulos,{ SE5->E5_PREFIXO,;
	SE5->E5_NUMERO,;
	SE5->E5_PARCELA,;
	SE5->E5_TIPO,;
	SE5->E5_LOJA,;
	DtoC(SE5->E5_DATA),;
	SE5->E5_DOCUMEN,;
	SE5->E5_SEQ,;
	Transform(SE5->E5_VALOR,"@E 9,999,999.99"),;
	Transform(SE5->E5_VLMOED2,"@E 9,999,999.99"),;
	.T.})
	//  Transform(nVlLiqTit,"@E 9999,999,999.99"),;
	_nTotDesc += SE5->E5_VALOR
	dbSelectArea("SE5")
	dbSkip()
Enddo

Return(aTitulos)
