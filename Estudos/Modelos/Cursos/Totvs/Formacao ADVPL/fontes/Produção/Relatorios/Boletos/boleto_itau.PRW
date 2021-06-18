#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º PROGRAMA     º P_FIR009  º AUTOR º                    º DATA º AGOSTO/2005 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º DESCRICAO    º PROGRAMA ESPECIFICO PARA REEMISSAO DA IMPRESSAO DO          º±±
±±º              º BOLETO DE COBRANCA DO BANCO ITAU, EM FORMATO GRAFICO A SER  º±±
±±º              º EMITIDO JUNTAMENTE COM A NOTA FISCAL FATURA OU CUPOM FISCAL º±±
±±º              º DESDE QUE A FORMA DE PAGAMENTO ASSIM O JUSTIFIQUE.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍ¹±±
±±º TABS.UTILIZ  º DESCRICAO                                          º ACESSO º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍ¹±±
±±º   SA1010     º CADASTRO DE CLIENTES                               º READ   º±±
±±º   SA6010     º CADASTRO DE BANCOS                                 º READ   º±±
±±º   SE1010     º CONTAS A RECEBER                                   º WRITE  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍ¹±±
±±º HISTORICO    º (AGO/2005) ELABORACAO DE PROGRAMA INICIAL - ALEX (REV. 00)  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º USO          º ESPECIFICO  - CONTROLE DE LOJAS/FINANCEIRO.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º PROPRIETARIO º CUSTOMIZADO PARA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function P_FIR009()
//
LOCAL   nOpc := 0
PRIVATE Exec    := .F.
//
cPerg     :="PFIR09"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()
//
If !Pergunte(cPerg,.T.)
	Return()
EndIf
//
CRIA_MV()
//
PRIVATE nCB1Linha	:= GETMV("PV_BOL_LI1") //14.5
PRIVATE nCB2Linha	:= GETMV("PV_BOL_LI2") //26.1
Private nCBColuna	:= GETMV("PV_BOL_COL") //1.3
Private nCBLargura	:= GETMV("PV_BOL_LAR") //0.0280
Private nCBAltura	:= GETMV("PV_BOL_ALT") //1.4
//
DbselectArea("SE1")
DbSetOrder(1)
//
Processa({|lEnd|MontaRel()})
//
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MontaRel()   ³Descri‡ão³Montagem e Impressao de boleto Gra- ³±±
±±³          ³             ³         ³fico do Banco Itau.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel()
LOCAL   oPrint
LOCAL   n := 0
LOCAL aBitmap := "\SIGAADV\ITAU.BMP"

LOCAL aDadosEmp    := {	AllTrim(SM0->M0_NOMECOM)                                                   ,; //[1]Nome da Empresa
SM0->M0_ENDCOB                                                              ,; //[2]Endereço
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                    ,; //[5]Telefones
"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
Subs(SM0->M0_CGC,13,2)                                                     ,; //[6]CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {"",;
"Mora Diaria de R$ "                                   ,;
""} //"Sujeito a Protesto apos 05 (cinco) dias do vencimento"}

// "Após o vencimento cobrar multa de R$ "

LOCAL i            := 1
LOCAL CB_RN_NN     := {}
LOCAL nRec         := 0
LOCAL _nVlrAbat    := 0
LOCAL cParcela	   := ""

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página
//
DBSEEK(xFilial("SE1")+MV_PAR01+MV_PAR02)
//
Do While !EOF() .and. E1_PREFIXO+E1_NUM == MV_PAR01+MV_PAR02
	//
	If E1_PARCELA < MV_PAR03
		DBSKIP()
		LOOP
	ENDIF
	//
	If E1_PARCELA > MV_PAR04
		DBSKIP()
		LOOP
	ENDIF
	//
	IF ALLTRIM(E1_NATUREZ) <> '900001'
		DBSKIP()
		LOOP
	ENDIF
	//
	If Alltrim(E1_TIPO) <> 'NF' .AND. Alltrim(E1_TIPO) <> 'FT' .AND. Alltrim(E1_TIPO) <> 'DP'
		DBSKIP()
		LOOP
	ENDIF
	//
	IF E1_SALDO <= 0
		DBSKIP()
		LOOP
	ENDIF
	//
	IF EMPTY(E1_NUMBCO) .OR. SUBSTR(ALLTRIM(E1_NUMBCO),1,3) <> "175"
		//
		IF !MsgBox("O título ("+E1_PREFIXO+"/"+E1_NUM+"-"+E1_PARCELA+") não gerou um Boleto Itaú préviamente. Deseja Imprimir o Boleto Itaú?", "Impressão de Boleto ITAÚ", "YESNO")
			DBSKIP()
			LOOP
		ENDIF
		//
	ENDIF
	//
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	//
	DO CASE
		CASE SE1->E1_PARCELA == "A"
			cParcela := "1"
		CASE SE1->E1_PARCELA == "B"
			cParcela := "2"
		CASE SE1->E1_PARCELA == "C"
			cParcela := "3"
		CASE SE1->E1_PARCELA == "D"
			cParcela := "4"
		CASE SE1->E1_PARCELA == "E"
			cParcela := "5"
		CASE SE1->E1_PARCELA == "F"
			cParcela := "6"
		CASE SE1->E1_PARCELA == "G"
			cParcela := "7"
		CASE SE1->E1_PARCELA == "H"
			cParcela := "8"
		CASE SE1->E1_PARCELA == "I"
			cParcela := "9"
		OTHERWISE
			cParcela := "0"
	ENDCASE
	//
	_cNossoNum := cFilant + substr((strzero(Val(Alltrim(SE1->E1_NUM)),6)),2,5) + cParcela //Composicao Filial + Titulo + Parcela
	//
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	//
	DbSelectArea("SE1")
	//
	aDadosBanco  := {"341"           		,; // [1]Numero do Banco
	"Banco Itaú S.A."      ,; // [2]Nome do Banco
	"9999"                 ,; // [3]Agência
	"99999"				,; // [4]Conta Corrente
	"9"  					,; // [5]Dígito da conta corrente
	"175"                  }  // [6]Codigo da Carteira
	//
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)                            ,;     // [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;     // [2]Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;     // [3]Endereço
		AllTrim(SA1->A1_MUN )                             ,;     // [4]Cidade
		SA1->A1_EST                                       ,;     // [5]Estado
		SA1->A1_CEP                                       ,;     // [6]CEP
		SA1->A1_CGC									  }       // [7]CGC
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)                               ,;   // [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]Código
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   // [3]Endereço
		AllTrim(SA1->A1_MUNC)	                              ,;   // [4]Cidade
		SA1->A1_ESTC	                                      ,;   // [5]Estado
		SA1->A1_CEPC                                         ,;   // [6]CEP
		SA1->A1_CGC										   }    // [7]CGC
	Endif
	
	//If aMarked[i]
	_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	
	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),(E1_VALOR-_nVlrAbat),Datavalida(E1_VENCTO,.T.))
	
	aDadosTit    := {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)						,;  // [1] Número do título
	E1_EMISSAO                              					,;  // [2] Data da emissão do título
	Date()                                  					,;  // [3] Data da emissão do boleto
	Datavalida(E1_VENCTO,.T.)                  					,;  // [4] Data do vencimento
	(E1_SALDO - _nVlrAbat)                  					,;  // [5] Valor do título
	CB_RN_NN[3]                             					,;  // [6] Nosso número (Ver fórmula para calculo)
	E1_PREFIXO                               					,;  // [7] Prefixo da NF
	E1_TIPO	                               						}  // [8] Tipo do Titulo
	//
	Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
	n := n + 1
	//EndIf
	
	dbSkip()
	IncProc()
	i := i + 1
EndDo
//
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
Return nil
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Impress      ³Descri‡ão³Impressao de Boleto Grafico do Banco³±±
±±³          ³             ³         ³Itau.                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
LOCAL _nTxper := GETMV("MV_TXPER")
LOCAL oFont2n
LOCAL oFont8
LOCAL oFont9
LOCAL oFont10
LOCAL oFont15n
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont14n
LOCAL oFont24
LOCAL i := 0
LOCAL aCoords1 := {0150,1900,0550,2300}
LOCAL aCoords2 := {0450,1050,0550,1900}
LOCAL aCoords3 := {0710,1900,0810,2300}
LOCAL aCoords4 := {0980,1900,1050,2300}
LOCAL aCoords5 := {1330,1900,1400,2300}
LOCAL aCoords6 := {2080,1900,2180,2300}     // 2000 - 2100
LOCAL aCoords7 := {2350,1900,2420,2300}     // 2270 - 2340
LOCAL aCoords8 := {2700,1900,2770,2300}     // 2620 - 2690
LOCAL oBrush
//
aBmp 	:= "\SIGAADV\ITAU.BMP"
aBmp2 	:= "\SIGAADV\LOGO.BMP"
//
//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
//
oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
//
oBrush := TBrush():New("",5)//4
//
oPrint:StartPage()   // Inicia uma nova página
//
oPrint:FillRect(aCoords1,oBrush)
oPrint:FillRect(aCoords2,oBrush)
oPrint:FillRect(aCoords3,oBrush)
oPrint:FillRect(aCoords4,oBrush)
oPrint:FillRect(aCoords5,oBrush)
oPrint:FillRect(aCoords6,oBrush)
oPrint:FillRect(aCoords7,oBrush)
oPrint:FillRect(aCoords8,oBrush)
//
// LOGOTIPO
If File(aBmp2)
	oPrint:SayBitmap( 0040,0100,aBmp2,0175,0100 )
Else
	oPrint:Say  (0084,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
EndIf
//
oPrint:Say  (0084,1860,"Comprovante de Entrega",oFont10)
oPrint:Line (0150,100,0150,2300)
oPrint:Say  (0150,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0200,100 ,aDadosEmp[1]                                 	,oFont10) //Nome + CNPJ
oPrint:Say  (0150,1060,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
oPrint:Say  (0150,1510,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0200,1510,(alltrim(aDadosTit[7]))+aDadosTit[1]	         ,oFont10) //Prefixo +Numero+Parcela
oPrint:Say  (0250,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (0300,100 ,aDatSacado[1]                                    ,oFont10)	//Nome
oPrint:Say  (0250,1060,"Vencimento"                                     ,oFont8)
oPrint:Say  (0300,1060,DTOC(aDadosTit[4])                               ,oFont10)
oPrint:Say  (0250,1510,"Valor do Documento"                          	,oFont8)
oPrint:Say  (0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99"))   ,oFont10)
if cFilant == "06" .or. cFilant == "18"
	oPrint:Say  (0370,0100,"Recebi(emos) o bloqueto/título com"  		,oFont10)
	oPrint:Say  (0410,0100,"as características acima."             		,oFont10)
	oPrint:Say  (0450,0100,"Favor devolver assinado juntamente"  		,oFont10)
	oPrint:Say  (0490,0100,"com o canhoto da Nota Fiscal." 				,oFont10)
else
	oPrint:Say  (0400,0100,"Recebi(emos) o bloqueto/título"                 ,oFont10)
	oPrint:Say  (0450,0100,"com as características acima."             		,oFont10)
endif
oPrint:Say  (0350,1060,"Data"                                           ,oFont8)
oPrint:Say  (0350,1410,"Assinatura"                                 	,oFont8)
oPrint:Say  (0450,1060,"Data"                                           ,oFont8)
oPrint:Say  (0450,1410,"Entregador"                                 	,oFont8)
//
oPrint:Line (0250, 100,0250,1900 )
oPrint:Line (0350, 100,0350,1900 )
oPrint:Line (0450,1050,0450,1900 )
oPrint:Line (0550, 100,0550,2300 )
//
oPrint:Line (0550,1050,0150,1050 )
oPrint:Line (0550,1400,0350,1400 )
oPrint:Line (0350,1500,0150,1500 )
oPrint:Line (0550,1900,0150,1900 )
//
oPrint:Say  (0165,1910,"(  ) Mudou-se"                                	,oFont8)
oPrint:Say  (0205,1910,"(  ) Ausente"                                    ,oFont8)
oPrint:Say  (0245,1910,"(  ) Não existe nº indicado"                  	,oFont8)
oPrint:Say  (0285,1910,"(  ) Recusado"                                	,oFont8)
oPrint:Say  (0325,1910,"(  ) Não procurado"                              ,oFont8)
oPrint:Say  (0365,1910,"(  ) Endereço insuficiente"                  	,oFont8)
oPrint:Say  (0405,1910,"(  ) Desconhecido"                            	,oFont8)
oPrint:Say  (0445,1910,"(  ) Falecido"                                   ,oFont8)
oPrint:Say  (0485,1910,"(  ) Outros(anotar no verso)"                  	,oFont8)
//
For i := 100 to 2300 step 50
	oPrint:Line( 0590, i, 0590, i+30)
Next i
//
oPrint:Line (0710,100,0710,2300)
oPrint:Line (0710,550,0610, 550)
oPrint:Line (0710,800,0610, 800)
//
// LOGOTIPO
If File(aBmp)
	oPrint:SayBitmap( 0600,0100,aBmp,0100,0100 )
	oPrint:Say  (0640,240,"Banco Itaú SA",oFont10 )	// [2]Nome do Banco
Else
	oPrint:Say  (0644,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
EndIf
//
oPrint:Say  (0618,569,"341-7",oFont24 )	// [1]Numero do Banco
oPrint:Say  (0644,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
//
oPrint:Line (0810,100,0810,2300 )
oPrint:Line (0910,100,0910,2300 )
oPrint:Line (0980,100,0980,2300 )
oPrint:Line (1050,100,1050,2300 )
//
oPrint:Line (0910,500,1050,500)
oPrint:Line (0980,750,1050,750)
oPrint:Line (0910,1000,1050,1000)
oPrint:Line (0910,1350,0980,1350)
oPrint:Line (0910,1550,1050,1550)
//
oPrint:Say  (0710,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (0730,400 ,"Pagável em qualquer Banco até o Vencimento."        ,oFont9)
oPrint:Say  (0770,400 ,"Após o Vencimento pague somente no Banco Itaú."        ,oFont9)
//
oPrint:Say  (0710,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (0750,2010,DTOC(aDadosTit[4])                               ,oFont10)
//
oPrint:Say  (0810,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0850,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
//
oPrint:Say  (0810,1910,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (0850,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
//
oPrint:Say  (0910,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (0940,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
//
oPrint:Say  (0910,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0940,605 ,(alltrim(aDadosTit[7]))+aDadosTit[1]			,oFont10) //Prefixo +Numero+Parcela
//
oPrint:Say  (0910,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (0940,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
//
oPrint:Say  (0910,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (0940,1455,"N"                                             ,oFont10)
//
oPrint:Say  (0910,1555,"Data do Processamento"                          ,oFont8)
oPrint:Say  (0940,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao
//
oPrint:Say  (0910,1910,"Nosso Número"                                   ,oFont8)
oPrint:Say  (0940,2010,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)
//
oPrint:Say  (0980,100 ,"Uso do Banco"                                   ,oFont8)
//
oPrint:Say  (0980,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (1010,555 ,aDadosBanco[6]                                  	,oFont10)
//
oPrint:Say  (0980,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (1010,805 ,"R$"                                             ,oFont10)
//
oPrint:Say  (0980,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (0980,1555,"Valor"                                          ,oFont8)
//
oPrint:Say  (0980,1910,"Valor do Documento"                          	,oFont8)
oPrint:Say  (1010,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
//
oPrint:Say  (1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (1200,100 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)),"@E 99,999.99"))  ,oFont10)
oPrint:Say  (1250,100 ,aBolText[3]                                        ,oFont10)
//
oPrint:Say  (1050,1910,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (1120,1910,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (1190,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (1260,1910,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (1330,1910,"(=)Valor Cobrado"                               ,oFont8)
//
oPrint:Say  (1400,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (1483,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
if Len(Alltrim(aDatSacado[7])) == 14
	oPrint:Say  (1589,400 ,"C.N.P.J.: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
else
	oPrint:Say  (1589,400 ,"C.P.F.: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) // CPF
endif
oPrint:Say  (1589,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)  ,oFont10)
//
oPrint:Say  (1605,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (1645,1500,"Autenticação Mecânica -"                        ,oFont8)
oPrint:Say  (1645,1900,"Recibo do Sacado"								,oFont10)
//
oPrint:Line (0710,1900,1400,1900 )
oPrint:Line (1120,1900,1120,2300 )
oPrint:Line (1190,1900,1190,2300 )
oPrint:Line (1260,1900,1260,2300 )
oPrint:Line (1330,1900,1330,2300 )
oPrint:Line (1400,100 ,1400,2300 )
oPrint:Line (1640,100 ,1640,2300 )
//
For i := 100 to 2300 step 50
	oPrint:Line( 1930, i, 1930, i+30)                 // 1850
Next i
//
oPrint:Line (2080,100,2080,2300)                                                       //   2000
oPrint:Line (2080,550,1980, 550)                                                       //   2000 - 1900
oPrint:Line (2080,800,1980, 800)                                                       //    2000 - 1900
//
// LOGOTIPO
If File(aBmp)
	oPrint:SayBitmap( 1970,0100,aBmp,0100,0100 )
	oPrint:Say  (2010,240,"Banco Itaú SA",oFont10 )	// [2]Nome do Banco
Else
	oPrint:Say  (2014,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco                     1934
EndIf
//
oPrint:Say  (1988,569,"341-7",oFont24 )	// [1]Numero do Banco                       1912
oPrint:Say  (2014,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
//
oPrint:Line (2180,100,2180,2300 )
oPrint:Line (2280,100,2280,2300 )
oPrint:Line (2350,100,2350,2300 )
oPrint:Line (2420,100,2420,2300 )
//
oPrint:Line (2280, 500,2420,500)
oPrint:Line (2350, 750,2420,750)
oPrint:Line (2280,1000,2420,1000)
oPrint:Line (2280,1350,2350,1350)
oPrint:Line (2280,1550,2420,1550)
//
oPrint:Say  (2080,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (2100,400 ,"Pagável em qualquer Banco até o Vencimento."        ,oFont9)
oPrint:Say  (2140,400 ,"Após o Vencimento pague somente no Banco Itaú."        ,oFont9)
//
oPrint:Say  (2080,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (2120,2010,DTOC(aDadosTit[4])                               ,oFont10)
//
oPrint:Say  (2180,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (2220,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
//
oPrint:Say  (2180,1910,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (2220,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
//
oPrint:Say  (2280,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (2310,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
//
oPrint:Say  (2280,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (2310,605 ,(alltrim(aDadosTit[7]))+aDadosTit[1]			,oFont10) //Prefixo +Numero+Parcela
//
oPrint:Say  (2280,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (2310,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
//
oPrint:Say  (2280,1355,"Aceite"                                         ,oFont8)  // 2200
oPrint:Say  (2310,1455,"N"                                             ,oFont10)  // 2230
//
oPrint:Say  (2280,1555,"Data do Processamento"                          ,oFont8)       // 2200
oPrint:Say  (2310,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao  2230
//
oPrint:Say  (2280,1910,"Nosso Número"                                   ,oFont8)       // 2200
oPrint:Say  (2310,2010,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)  // 2230
//
oPrint:Say  (2350,100 ,"Uso do Banco"                                   ,oFont8)       // 2270
//
oPrint:Say  (2350,505 ,"Carteira"                                       ,oFont8)       // 2270
oPrint:Say  (2380,555 ,aDadosBanco[6]                                  	,oFont10)      //  2300
//
oPrint:Say  (2350,755 ,"Espécie"                                        ,oFont8)       //  2270
oPrint:Say  (2380,805 ,"R$"                                             ,oFont10)      //  2300
//
oPrint:Say  (2350,1005,"Quantidade"                                     ,oFont8)       //  2270
oPrint:Say  (2350,1555,"Valor"                                          ,oFont8)       //  2270
//
oPrint:Say  (2350,1910,"Valor do Documento"                          	,oFont8)        //  2270
oPrint:Say  (2380,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)  //   2300
//
oPrint:Say  (2420,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8) // 2340
oPrint:Say  (2570,100 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)),"@E 99,999.99"))  ,oFont10)  // 2490  // *0.05)/30)
oPrint:Say  (2620,100 ,aBolText[3]                                        ,oFont10)    //2540
//
oPrint:Say  (2420,1910,"(-)Desconto/Abatimento"                         ,oFont8)      //  2340
oPrint:Say  (2490,1910,"(-)Outras Deduções"                             ,oFont8)      //  3410
oPrint:Say  (2560,1910,"(+)Mora/Multa"                                  ,oFont8)      //  2480
oPrint:Say  (2630,1910,"(+)Outros Acréscimos"                           ,oFont8)      //  2550
oPrint:Say  (2700,1910,"(=)Valor Cobrado"                               ,oFont8)      //  2620
//
oPrint:Say  (2770,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (2800,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (2853,400 ,aDatSacado[3]                                    ,oFont10)       // 2773
oPrint:Say  (2906,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado  2826
IF LEN(Alltrim(aDatSacado[7])) == 14
	oPrint:Say  (2959,400 ,"C.N.P.J.: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC        2879
ELSE
	oPrint:Say  (2959,400 ,"C.P.F.: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) // CPF        2879
ENDIF
oPrint:Say  (2959,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)  ,oFont10)         //  2879
//
oPrint:Say  (2975,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (3015,1500,"Autenticação Mecânica -"                        ,oFont8)
oPrint:Say  (3015,1850,"Ficha de Compensação"                           ,oFont10)      // 2935 + 280      = 3215
//
oPrint:Line (2080,1900,2770,1900 )
oPrint:Line (2490,1900,2490,2300 )
oPrint:Line (2560,1900,2560,2300 )
oPrint:Line (2630,1900,2630,2300 )
oPrint:Line (2700,1900,2700,2300 )
oPrint:Line (2770,100 ,2770,2300 )
//
oPrint:Line (3010,100 ,3010,2300 )
//
MsBar("INT25"  ,nCB1Linha,nCBColuna,CB_RN_NN[1]  ,oPrint,.F.,,,nCBLargura,nCBAltura,,,,.F.)
MsBar("INT25"  ,nCB2Linha,nCBColuna,CB_RN_NN[1]  ,oPrint,.F.,,,nCBLargura,nCBAltura,,,,.F.)
//
DbSelectArea("SE1")
RecLock("SE1",.f.)
SE1->E1_NUMBCO :=	Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)   // Nosso número (Ver fórmula para calculo)
SE1->E1_PORTADO	:= 	"999"
SE1->E1_AGEDEP 	:=  "999"
SE1->E1_CONTA	:=  "99999-9"
SE1->E1_SITUACA	:=	"1"
MsUnlock()
//
oPrint:EndPage() // Finaliza a página
//
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Modulo10    ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
±±³          ³             ³         ³to Verificador no Modulo 10.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Modulo11    ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
±±³          ³             ³         ³to Verificador no Modulo 11.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)
//
//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável
//Cobrança não identificada, número do boleto = Título + Parcela
//
//mj Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)
//
//					    		   Codigo Banco            Agencia		  C.Corrente     Digito C/C
//					               1-cBancoc               2-Agencia      3-cConta       4-cDacCC       5-cNroDoc              6-nValor
//	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"175"+AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat) )
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ret_cBarra   ³Descri‡ão³Gera a codificacao da Linha digitav.³±±
±±³          ³             ³         ³gerando o codigo de barras.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)
//
LOCAL bldocnufinal := strzero(val(cNroDoc),8)
LOCAL blvalorfinal := strzero(int(nValor*100),10)
LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL RN           := ''
LOCAL CB           := ''
LOCAL s            := ''
LOCAL _cfator      := strzero(dVencto - ctod("07/10/97"),4)
LOCAL _cCart	   := "175" //carteira de cobranca
//
//-------- Definicao do NOSSO NUMERO
s    :=  cAgencia + cConta + _cCart + bldocnufinal
dvnn := modulo10(s) // digito verifacador Agencia + Conta + Carteira + Nosso Num
NN   := _cCart + bldocnufinal + '-' + AllTrim(Str(dvnn))
//
//	-------- Definicao do CODIGO DE BARRAS
s    := cBanco + _cfator + blvalorfinal + _cCart + bldocnufinal + AllTrim(Str(dvnn)) + cAgencia + cConta + cDacCC + '000'
dvcb := modulo11(s)
CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)
//
//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DEFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
//
// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := cBanco + _cCart + SubStr(bldocnufinal,1,2)
dv   := modulo10(s)
RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := SubStr(bldocnufinal, 3, 6) + AllTrim(Str(dvnn)) + SubStr(cAgencia, 1, 3)
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
s    := SubStr(cAgencia, 4, 1) + cConta + cDacCC + '000'
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 4:
//	     K = DAC do Codigo de Barras
RN   := RN + AllTrim(Str(dvcb)) + '  '
//
// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
RN   := RN + _cfator + StrZero(Int(nValor * 100),14-Len(_cfator))
//
Return({CB,RN,NN})
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValidPerg   ³Descri‡ão³Verifica o Arquivo Sx1, criando as  ³±±
±±³          ³             ³         ³Perguntas se necessario.            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()
//
PRIVATE APERG := {},AALIASSX1:=GETAREA()
//
//     "X1_GRUPO"	,"X1_ORDEM"	,"X1_PERGUNT"      			,"X1_PERSPA"				,"X1_PERENG"				,"X1_VARIAVL"	,"X1_TIPO"	,"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"	,"X1_VALID"	,"X1_VAR01"	,"X1_DEF01"	,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"	,"X1_VAR02"	,"X1_DEF02"	,"X1_DEFSPA2"	,"X1_DEFENG2"	,"X1_CNT02"	,"X1_VAR03"	,"X1_DEF03"	,"X1_DEFSPA3"	,"X1_DEFENG3"	,"X1_CNT03"	,"X1_VAR04"	,"X1_DEF04"	,"X1_DEFSPA4"	,"X1_DEFENG4"	,"X1_CNT04"	,"X1_VAR05"	,"X1_DEF05"	,"X1_DEFSPA5"	,"X1_DEFENG5"	,"X1_CNT05"	,"X1_F3"	,"X1_PYME"	,"X1_GRPSXG"	,"X1_HELP"
//
AADD(APERG,{CPERG  ,"01"		,"Prefixo?"     			,"Prefixo?"    		    	,"Prefixo?"     			,"mv_ch1"		,"C"		,3 				,0 				,0 				,"G"		,""			,"mv_par01"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"02"		,"Numero?"         		    ,"Numero?"                  ,"Numero?"          		,"mv_ch2"		,"C"		,6 				,0 				,0 				,"G"		,""			,"mv_par02"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"03"		,"Da Parcela?"     			,"Da Parcela?"		    	,"Da Parcela?"		    	,"mv_ch3"		,"C"		,1 			    ,0 				,0 				,"G"		,""			,"mv_par03"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"04"		,"Ate a Parcela?"    		,"Ate a Parcela?"     		,"Ate a Parcela?"     		,"mv_ch4"		,"C"		,1 			    ,0 				,0 				,"G"		,""			,"mv_par04"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
//
DBSELECTAREA("SX1")
DBSETORDER(1)
//
FOR I := 1 TO LEN(APERG)
	IF  !DBSEEK(CPERG+APERG[I,2])
		RECLOCK("SX1",.T.)
		FOR J := 1 TO FCOUNT()
			IF  j <= LEN(APERG[I])
				FIELDPUT(J,APERG[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT
RESTAREA(AALIASSX1)
//
RETURN()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CRIA_MV ³Descri‡…o³ Criacao dos Param.Necessarios no (SX6) ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION CRIA_MV()
//
dbSelectArea("SX6")
dbSetOrder(1)
//
If !dbSeek(cFilant+"PV_BOL_LI1")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_LI1"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "14.5"
	SX6->X6_CONTSPA	:= "14.5"
	SX6->X6_CONTENG	:= "14.5"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_LI2")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_LI2"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "NUMERO DA SEGUNDA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "NUMERO DA SEGUNDA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "NUMERO DA SEGUNDA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "26.1"
	SX6->X6_CONTSPA	:= "26.1"
	SX6->X6_CONTENG	:= "26.1"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_COL")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_COL"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "1.3"
	SX6->X6_CONTSPA	:= "1.3"
	SX6->X6_CONTENG	:= "1.3"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_LAR")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_LAR"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "0.0280"
	SX6->X6_CONTSPA	:= "0.0280"
	SX6->X6_CONTENG	:= "0.0280"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_ALT")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_ALT"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "1.40"
	SX6->X6_CONTSPA	:= "1.40"
	SX6->X6_CONTENG	:= "1.40"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
RETURN()