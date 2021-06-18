#include "PROTHEUS.CH"
#include "topconn.ch"
#include "XMLXFUN.ch"

#DEFINE F_NAME 1
#DEFINE F_SIZE 2
#DEFINE F_DATE 3
#DEFINE F_TIME 4
#DEFINE F_ATTR 5
#DEFINE c_BR CHR(13)+CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA028   ºAutor  ³Gustavo Marques     º Data ³  24/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega linhas do pedido de acordo com o XML               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Editora Atlas                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENA028(lShowBt)

Local oDlg
local oMenuMain 	:= nil
local oMenuDiv1 	:= nil
local oMenuDiv2 	:= nil
local oMenuItem1 	:= nil
local oMenuItem2 	:= nil
local oMenuItem3 	:= nil
//Local cUsuAcesso	:= GETMV("MV_ACPVBLO") </LOOP_20150812-019>

Private oDlgAtu := GetWndDefault()

Default lShowBt := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o cabecalho foi preenchido                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If UPPER(AllTrim(FUNNAME())) $ "MATA410" //ORÇAMENTOS
	If Empty(M->C5_CLIENTE) .OR. Empty(M->C5_LOJACLI) .OR. Empty(M->C5_XTES) .OR. Empty(M->C5_XLOCAL)
		Aviso("ATENÇÃO","O cabeçalho do pedido deve ser preenchido antes de executar essa rotina!",{"&Ok"},1,"Atenção")
		Return
	Endif
EndIf

If lShowBt
	DEFINE DIALOG oDlg TITLE "Importação" FROM 200,200 TO 300,400 PIXEL
	
	oPanel:= tPanel():New(01,01,,oDlg,,,,,,100,100)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT
	
	//</LOOP_20150812-019> //oTButton1 := TButton():New( 002, 002, "Arquivo XML (Formato PDP)",oPanel,{||U_GENA028A(),oDlg:End()},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	//</LOOP_20150812-019> //oTButton1:Align := CONTROL_ALIGN_TOP
	
	If !(UPPER(AllTrim(FUNNAME())) $ "MATA415") //ORÇAMENTOS
		oTButton2 := TButton():New( 002, 002, "Arquivo Texto",oPanel,{||	U_GENA028B(),oDlg:End()},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		oTButton2:Align := CONTROL_ALIGN_TOP	
	Endif
	
	oTButton3 := TButton():New( 002, 002, "Caixa de Texto",oPanel,{||	U_GENA028C(),oDlg:End()},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton3:Align := CONTROL_ALIGN_TOP
	
	//</LOOP_20150812-019> //oTButton4 := TButton():New( 002, 002, "Biblioteca Digital",oPanel,{||	U_PFATA51(),oDlg:End()},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	//</LOOP_20150812-019> //oTButton4:Align := CONTROL_ALIGN_TOP
	
	/*
	<LOOP_20150812-019>
	If UPPER(cUserName) $ UPPER(cUsuAcesso)
	oTButton5 := TButton():New( 002, 002, "Cx. Texto PV",oPanel,{|| U_GENA028D(),oDlg:End()},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton5:Align := CONTROL_ALIGN_TOP
	EndIf
	<LOOP_20150812-019>
	*/
	
	ACTIVATE DIALOG oDlg CENTERED
Else
	U_GENA028C()
EndIF

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA028A  ºAutor  ³Gustavo Marques     º Data ³  24/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega linhas do pedido de acordo com o XML               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Editora Atlas                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENA028A

Local aArea		:= GetArea()
Local cArq 		:= ""
Local cType		:=	"Arquivo XML|*.XML"
Local lRet		:= .T.
Local cTexto	:= ""
Local cEOL		:= Chr(13)+Chr(10)
Local nX		:= 0

Private aItens	:= {}
Private oProcess:= Nil
Private aError	:= {}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre janela para selecionar o arquivo                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cArq)
	cArq :=	cGetFile(cType, OemToAnsi("Selecione o arquivo XML"),0,"SERVIDOR",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se foi selecionado algum arquivo                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cArq)
		Aviso("ATENCAO","Escolha um Arquivo XML.",{"&Ok"},1,"Escolha um Arquivo!")
		Return(.f.)
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o arquivo é valido                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cArq) .Or. !File(cArq)
	Return
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Le o XML                                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Processa({||ReadFile(cArq)},"Aguarde...","Lendo Arquivo XML...",.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida dados lidos                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Processa({||lRet := ValidDados()},"Aguarde...","Validando dados importados...",.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se nao houve erros na validacao carrega linhas do pedido                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		Processa({||GravaAcols("1")},"Aguarde...","Carregando Linhas...",.T.)
	Else
		cTexto := "Foram encontrados as seguintes inconsistencias!"
		cTexto += " " + cEOL
		cTexto += " " + cEOL
		
		For nX := 1 To Len(aError)
			cTexto  +=  "Produto: "+aError[nX][1]+cEOL
			cTexto  +=  "Log: "+aError[nX][2]+cEOL
			cTexto  +=  "Qtde Ocorrencias: "+Alltrim(Str(aError[nX][3]))+cEOL
			cTexto 	+= 	" " + cEOL
		Next nX
		
		DEFINE MSDIALOG oDlg TITLE " INCONSISTENCIAS NO ARQUIVO XML " From 3,0 to 340,617 PIXEL
		@ 05,05 GET oMemo VAR cTexto MEMO SIZE 300,145 OF oDlg PIXEL
		oMemo:bRClicked := { || AllwaysTrue( ) }
		DEFINE SBUTTON FROM 153,275 TYPE 1 ACTION oDlg:End( ) ENABLE OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTER
	Endif
Endif

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReadFile  ºAutor  ³Gustavo Marques     º Data ³  24/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Le o arquivo XML                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Editora Atlas                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReadFile(cArq)

Local cError	:= ""
Local cWarning	:= ""
Local cBuffer 	:= ""
Local cLinha	:= ""
Local oXml		:= NIL
Local oNode		:= NIL
Local nH		:= 0

Local cC6EAN13		:= ""
Local nC6NrCopias 	:= 0
Local nC6Receita 	:= 0
Local nCont			:= 1
Local nReg			:= 1

Local oBuffer		:= Nil
Local nTamFile		:= 0
Local nTamReg		:= 0

Local lRetArq		:= .T.
Local cArqServ		:= "PDP"+DTOS(DATE())+STRTRAN(TIME(),":","")+".xml"
Local cArquivo		:= ""
Local cLocalServ	:= "\SYSTEM\PDP\"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava no servidor o arquivo                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArquivo := SelArq(cArq)
lRetArq := CpyT2S(cArq,cLocalServ)
FRENAME(cLocalServ+cArquivo,cLocalServ+cArqServ)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³carregar o arquivo do XML para um Handler                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nH := FT_FUSE(cLocalServ+cArqServ)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se conseguiu criar o arquivo                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nH == -1
	Aviso(	"Inconsistência","Não foi possivel a abertura do arquivo "+cArq+" para leitura. O mesmo será ignorado.",{"&Continua"},,"Atenção" )
	FT_FUSE()
Else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define tamanho maximo da regua                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTamFile := FT_FLASTREC()
	ProcRegua(nTamFile)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ler todo o arquivo xml para dentro de uma string                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	FT_FGOTOP()
	While !FT_FEOF()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a leitura da linha                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cLinha := Alltrim(FT_FREADLN())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Incrementa Barra de Progressao                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncProc("Lendo Arquivo XML... Linha [ "+Alltrim(Str(nReg++))+" / "+Alltrim(Str(nTamFile))+" ]")
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Desconsidera tag's que nao serão utilizadas                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
			Case "<Relatorio>" $ cLinha
				cBuffer += cLinha
			Case "<Item>" $ cLinha
				cBuffer += cLinha
			Case "<livroCapituloEAN13Comp>" $ cLinha
				cBuffer += cLinha
			Case "<livroCopias>" $ cLinha
				cBuffer += cLinha
			Case "<solicGeracaoVlReceita>" $ cLinha
				cBuffer += cLinha
			Case "</Item>" $ cLinha
				cBuffer += cLinha
		EndCase
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se chegou na tag de fim de item                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cLinha = "</Item>"
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Finaliza estrutura do XML <relatorio><item>...</item></relatorio>             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cBuffer += "</Relatorio>"
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Lendo a estrutura XML                                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oXml	:= XmlParser(cBuffer, "_", @cError, @cWarning)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se a estrutura é valida                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If oXml <> Nil
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Le codigo de barras do produto                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oNode	:= NIL
				oNode	:= XmlChildEx(oXml:_RELATORIO:_ITEM,"_LIVROCAPITULOEAN13COMP")
				If VALTYPE(oNode) <> 'U'
					If !Empty(Alltrim(oNode:Text))
						cC6EAN13	:= Upper(oNode:Text)
					Endif
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Le quantidade do produto                                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oNode	:= NIL
				oNode	:= XmlChildEx(oXml:_RELATORIO:_ITEM,"_LIVROCOPIAS")
				If VALTYPE(oNode) <> 'U'
					If !Empty(Alltrim(oNode:Text))
						nC6NrCopias	:= Val(oNode:Text)
					Endif
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Le preço do produto                                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oNode	:= NIL
				oNode	:= XmlChildEx(oXml:_RELATORIO:_ITEM,"_SOLICGERACAOVLRECEITA")
				If VALTYPE(oNode) <> 'U'
					If !Empty(Alltrim(oNode:Text))
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Guarda valor unitario                                                         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nC6Receita	:=	Val(oNode:Text) / nC6NrCopias
					Endif
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Guarda itens lidos na array                                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Aadd(aItens,{cC6EAN13,nC6NrCopias,nC6Receita})
				
			Else
				Aviso("ATENÇÃO - " + Procname(), "Ocorreu o seguinte erro no Xml "+cError, {"&Ok"}, 2, "Atencao!")
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Inicia a variavel do XML para pegar proximo item                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cBuffer := "<Relatorio>"
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona na proxima linha                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FT_FSKIP()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Finaliza o arquivo aberto                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FT_FUSE()
	
Endif


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaAcolsºAutor  ³Gustavo Marques     º Data ³  30/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Carrega os itens na aCols                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Editora Atlas                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaAcols(cOpcAcols,lAgrupa,lAcesso)
Local nTotReg	:= 0
Local nAtual	:= 1
Local cx1Tes	:=  ' '
Local lParDescEsp := .f. //GetMv ("MV_XDESCES",,.F. ) // Elizeu - 09/02/2010
Local cSZQAtivo := " " // Elizeu - 09/02/2010
Local lxPD 	:= .F.
Local cFilSF4	:= xFilial("SF4") //Romadier Mendonca - Corrigido junto Daniel - 07/12/2011 - Utilizado em Gravar Acols
Local nTipoTrf	:= 0
Local nDesc		:= 0 
Local lAchou	:= .F.
Local cTesPai	:= SuperGetMv("GEN_FAT169",.f.,"") 
Local cMvCodFor := SuperGetMv("GEN_FAT168",.f.,"378803") 
Local cTESExp   := SuperGetMv("GEN_FAT251",.f.,"537") 
Local aAreaSF4	:= nil
Local nX,i,nAuxIt

Default lAgrupa := .T.
Default lAcesso	:= .F.

If cOpcAcols == '1'
	
	cItem:= StrZero(1,TamSX3("C6_ITEM")[1])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica trouxe informacao do XML                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotReg := Len(aItens)
	If nTotReg > 0
		ProcRegua(nTotReg)
		For i= 1 to nTotReg
			IncProc("Carregando Linhas... Linha [ "+Alltrim(Str(nAtual++))+" / "+Alltrim(Str(nTotReg))+" ]")
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona a tabela de produtos                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB1")
			dbSetOrder(5)
			dbGoTop()
			dbSeek(xFilial()+aItens[i,1])
			
			nPos := Ascan(aCols,{|x| Alltrim(x[BuscaHeader("C6_PRODUTO")])==Alltrim(SB1->B1_COD)})
			If nPos > 0
				For nX := 1 To Len(aHeader)
					If AllTrim(aHeader[nX,2]) == "C6_QTDVEN"
						aCols[nPos,nX] += aItens[i,2]
						M->C6_QTDVEN := aCols[nPos,nX]
					ElseIf AllTrim(aHeader[nX,2]) == "C6_QTDLIB"
						aCols[nPos,nX] += aItens[i,2]
					ElseIf AllTrim(aHeader[nX,2]) == "C6_PRCVEN"
						nPrcven := aCols[nPos,nX]
					ElseIf AllTrim(aHeader[nX,2]) == "C6_VALOR"
						aCols[nPos,nX] := Round((nPrcven*M->C6_QTDVEN),2)
					Endif
				Next nX
				
				RunTrigger(2,nPos,Nil,,"C6_PRODUTO")
				RunTrigger(2,nPos,Nil,,"C6_QTDVEN")
				
				n := nPos
			Else
				
				If i > 1  .or. Len(aCols) > 1
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Gera numero do item de acordo com o numero de linhas da array                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cItem:= Soma1(aCols[Len(aCols)][1],TamSX3("C6_ITEM")[1])
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Adiciona nova linha                                                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aadd(aCols,Array(Len(aHeader)+1))
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Carrega os dados importados na linha do pedido                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nX := 1 To Len(aHeader)
					If AllTrim(aHeader[nX,2]) == "C6_ITEM"
						aCols[Len(aCols),nX] := cItem
					ElseIf AllTrim(aHeader[nX,2]) == "C6_NUM"
						aCols[Len(aCols),nX] := M->C5_NUM
					ElseIf AllTrim(aHeader[nX,2]) == "C6_PRODUTO"
						aCols[Len(aCols),nX] := SB1->B1_COD
						RunTrigger(2,Len(aCols),Nil,,"C6_PRODUTO")
					ElseIf AllTrim(aHeader[nX,2]) == "C6_QTDVEN"
						aCols[Len(aCols),nX] := aItens[i,2]
						RunTrigger(2,Len(aCols),Nil,,"C6_QTDVEN")
					ElseIf AllTrim(aHeader[nX,2]) == "C6_PRCVEN"
						aCols[Len(aCols),nX] := aItens[i,3]
					ElseIf AllTrim(aHeader[nX,2]) == "C6_CODATLA"
						aCols[Len(aCols),nX] := SB1->B1_CODINT
					ElseIf AllTrim(aHeader[nX,2]) == "C6_DESCRI"
						aCols[Len(aCols),nX] := SB1->B1_DESC
						/*
						ElseIf AllTrim(aHeader[nX,2]) == "C6_LOCAL"
						aCols[Len(aCols),nX] := SB1->B1_LOCPAD
						*/
					ElseIf AllTrim(aHeader[nX,2]) == "C6_LOCAL"
						aCols[Len(aCols),nX] := M->C5_XLOCAL
					ElseIf AllTrim(aHeader[nX,2]) == "C6_EDICAO"
						aCols[Len(aCols),nX] := SB1->B1_EDICAO
					ElseIf AllTrim(aHeader[nX,2]) == "C6_AUTOR"
						aCols[Len(aCols),nX] := SB1->B1_AUTOR
					ElseIf AllTrim(aHeader[nX,2]) == "C6_VALOR"
						aCols[Len(aCols),nX] := Round((aItens[i,3]*aItens[i,2]),2)
					ElseIf AllTrim(aHeader[nX,2]) == "C6_TES"
						
						aAreaSF4	:= SF4->(GetArea())						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Cleuto - 12/07/2017                      ³
						//³                                         ³
						//³Se obra Gen e TES PAI existe no parametro³
						//³deve utilizar a TES padrão do produto    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						DbSelectArea("SA1")
						DbSetOrder(1)
						DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)

						If AllTrim(SB1->B1_PROC) $ cMvCodFor .AND. AllTrim(Posicione("SF4",1,xFilial("SF4")+M->C5_XTES,"F4_XTESPAI"))+"#" $ AllTrim(cTesPai)+"#" 
							If SA1->A1_EST <> "EX"
								aCols[Len(aCols),nX] := SB1->B1_TS
							Else
								aCols[Len(aCols),nX] := AllTrim(cTESExp) //TES Padrão de exportação Obras GEN
							EndIf
						Else
							aCols[Len(aCols),nX] := M->C5_XTES	
						EndIf
						
						RestArea(aAreaSF4)
						
					ElseIf AllTrim(aHeader[nX,2]) == "C6_UM"
						aCols[Len(aCols),nX] := SB1->B1_UM
					ElseIf AllTrim(aHeader[nX,2]) == "C6_QTDLIB"
						aCols[Len(aCols),nX] := aItens[i,2]
					ElseIf AllTrim(aHeader[nX,2]) == "C6_TABELA"
						aCols[Len(aCols),nX] := M->C5_TABELA
					ElseIf AllTrim(aHeader[nX,2]) == "C6_ENTREG"
						aCols[Len(aCols),nX] := DDATABASE
					ElseIf AllTrim(aHeader[nX,2]) == "C6_PRUNIT"
						aCols[Len(aCols),nX] := aItens[i,3]
					ElseIf AllTrim(aHeader[nX,2]) == "C6_REC_WT"
						aCols[Len(aCols),nX] := 0
					ElseIf AllTrim(aHeader[nX,2]) == "C6_ALI_WT"
						aCols[Len(aCols),nX] := "SC6"
					ElseIf AllTrim(aHeader[nX,2]) == "C6_ENTREG"
						aCols[Len(aCols),nX] := CriaVar("C6_ENTREG", .F.)
					Else
						If aHeader[nX,10] <> 'V'
							aCols[Len(aCols),nX] := CriaVar(AllTrim(aHeader[nX,2]),.F.)
						Endif
					EndIf
				Next nX
			Endif
			
			aCols[Len(aCols),Len(aHeader)+1] := .F.
			
		Next i
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Recalcula as linhas do pedido                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RefazAcols(1,M->C5_XTES, 0, .F., .F. )
	n := 1	
ElseIf cOpcAcols == '2'
	
	cItem:= StrZero(1,TamSX3("C6_ITEM")[1])
	
	//lxPD := (M->C5_XTES=="603") </LOOP_20150812-006>
	
	//Takaki
	//nTipoTrf := iif(M->C5_XTES=="517",1,0) </LOOP_20150812-007>
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica trouxe informacao do XML                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotReg := Len(aLinha)
	If nTotReg > 0
		ProcRegua(nTotReg)
		For nAuxIt := 1 to nTotReg
			IncProc("Carregando Linhas... Linha [ "+Alltrim(Str(nAtual++))+" / "+Alltrim(Str(nTotReg))+" ]")
			
			nPos := Ascan(aCols,{|x| Alltrim(x[BuscaHeader("C6_PRODUTO")])==Alltrim(aLinha[nAuxIt][1])})
			If nPos > 0	.And. lAgrupa
				For nX := 1 To Len(aHeader)
					If AllTrim(aHeader[nX,2]) == "C6_QTDVEN"
						aCols[nPos,nX] += aLinha[nAuxIt][2]
						M->C6_QTDVEN := aCols[nPos,nX]
					Endif
				Next nX
				n := nPos
			Else
				
				If nAuxIt > 1  .or. Len(aCols) > 1
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Gera numero do item de acordo com o numero de linhas da array                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cItem:= Soma1(aCols[Len(aCols)][1],TamSX3("C6_ITEM")[1])
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Adiciona nova linha                                                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aadd(aCols,Array(Len(aHeader)+1))
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciona a tabela de produtos                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbGoTop()
				dbSeek(xFilial("SB1")+aLinha[nAuxIt][1])
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no cadastro de Tabela de Precos                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("DA1")
				DA1->( DbSetOrder(1) )
				DA1->(dbSeek(xFilial("DA1")+M->C5_TABELA+aLinha[nAuxIt][1],.F.))
				
				nDesc := POSICIONE("SZ2",1,XFILIAL("SZ2")+SA1->A1_XTPDES+SB1->B1_GRUPO,"Z2_PERCDES")
				
				cx1Tes := M->C5_XTES
				//<LOOP_20150812-008>
				/*
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Mudanca de TES no Produto que Utiliza Papel de Grafica.      ³
				//³ - by Elizeu - 07/07/2011                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If U_PapGraf(SB1->B1_COD)
				cx1Tes := Posicione("SF4", 1, cFilSF4 + M->C5_XTES, "F4_XTSPGRA")
				If Empty(cx1Tes)
				cx1Tes := M->C5_XTES
				Endif
				Endif
				
				If (SF4->F4_FILIAL + SF4->F4_CODIGO) <> (xFilial("SF4") + cx1Tes)
				dbSelectArea("SF4")
				SF4->( dbSetOrder(1) )
				If SF4->( !dbSeek(xFilial("SF4")+cx1Tes,.F.) )
				Aviso("Nao foi possivel definir o TES: "+cx1Tes, "Tipo de Entrada e Saida nao encontrado no cadastro de TES. ISBN: "+aLinha[nAuxIt][1], {"&Ok"})
				cx1Tes := M->C5_XTES
				Loop
				EndIf
				Endif
				*/
				//</LOOP_20150812-008>
				
				//<LOOP_20150812-009>
				/*
				If lxPD
				nDesc := 0
				lParDescEsp := .F.
				Else
				nDesc := Iif(SUBS(SB1->B1_CODINT,1,2) $ "05;12;15" .AND. SA1->A1_DESCESP > 0 , SA1->A1_DESCESP, SA1->A1_DESCPAD)
				Endif
				
				// Bloco Adicionado para gatilho automaticado do desconto dos livros juridicos - Elizeu - 09/02/2010
				// Transcrito e adaptado do fonte GFATA02.PRW
				If lParDescEsp
				If SA1->A1_DESCESP <> 0
				DBSelectArea("SZQ")
				SZQ->( DBSetOrder(1) )
				cSZQAtivo := " "
				If SZQ->( DBSeek(xFilial("SZQ")+SB1->B1_CODINT ) )
				cSZQAtivo := SZQ->ZQ_ATIVO // S/N
				Endif
				If Substr(SB1->B1_CODINT,1,2) $ "05;12;15" .or.;
				'DIREI' $ SB1->B1_DESC .or.;
				'JURID' $ SB1->B1_DESC .or.;
				'TRIBUT' $ SB1->B1_DESC .or.;
				'LEGIS' $ SB1->B1_DESC .or.;
				cSZQAtivo == "S"
				
				If cSZQAtivo $ " S"
				nDesc := Iif( SA1->A1_DESCESP <> 0, SA1->A1_DESCESP, SA1->A1_DESCPAD)
				Endif
				Endif
				Endif
				Endif
				// Fim do Bloco Adicionado para gatilho automaticado do desconto dos livros juridicos - Elizeu - 09/02/2010
				
				//If lxPD
				//	nPrcven := DA1->DA1_PRCVEN
				//Else
				//	nPrcven := DA1->DA1_PRCVEN-(DA1->DA1_PRCVEN*nDesc/100)
				//Endif
				*/
				//</LOOP_20150812-009>
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Carrega os dados importados na linha do pedido                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				//<LOOP_20150812-020>
				aCols[Len(aCols),GdFieldPos("C6_QTDVEN",aHeader)]	:= aLinha[nAuxIt,2]
				aCols[Len(aCols),GdFieldPos("C6_PRCVEN",aHeader)]	:= 0
				//</LOOP_20150812-020>
				
				For nX := 1 To Len(aHeader)
					If AllTrim(aHeader[nX,2]) == "C6_ITEM"
						aCols[Len(aCols),nX] := cItem
						
					ElseIf AllTrim(aHeader[nX,2]) == "C6_NUM"
						aCols[Len(aCols),nX] := M->C5_NUM
						
					ElseIf AllTrim(aHeader[nX,2]) == "C6_PRODUTO"
						aCols[Len(aCols),nX] := SB1->B1_COD
						RunTrigger(2,Len(aCols),Nil,,"C6_PRODUTO")
						
					ElseIf AllTrim(aHeader[nX,2]) == "C6_XISBN"
						aCols[Len(aCols),nX] := SB1->B1_ISBN
						
					ElseIf AllTrim(aHeader[nX,2]) == "C6_QTDVEN"
						aCols[Len(aCols),nX] := aLinha[nAuxIt][2]
						RunTrigger(2,Len(aCols),Nil,,"C6_QTDVEN")
						
					ElseIf AllTrim(aHeader[nX,2]) == "C6_PRUNIT"
						
						//If LEN(aLinha[nAuxIt]) >= 4
						//	aCols[Len(aCols),nX] := aLinha[nAuxIt,4]
						//Else
						aCols[Len(aCols),nX] := DA1->DA1_PRCVEN
						//EndIF
						
					ElseIf AllTrim(aHeader[nX,2]) == "C6_PRCVEN"
						
						IF LEN(aLinha[nAuxIt]) >= 4
							aCols[Len(aCols),nX] := aLinha[nAuxIt,4]-aLinha[nAuxIt,5]
						Else
							If nDesc == 0
								aCols[Len(aCols),nX] := DA1->DA1_PRCVEN
							Else
								aCols[Len(aCols),nX] := DA1->DA1_PRCVEN - ((DA1->DA1_PRCVEN*nDesc)/100)
							EndIf
						EndIf
						
					ElseIf AllTrim(aHeader[nX,2]) == "C6_DESCONT"
						
						IF LEN(aLinha[nAuxIt]) >= 4
							aCols[Len(aCols),nX] := Round((aLinha[nAuxIt][5]/aLinha[nAuxIt][4])*100,2)
						Else
							aCols[Len(aCols),nX] := nDesc
						EndIf
						
					ElseIf AllTrim(aHeader[nX,2]) == "C6_VALDESC"
						If LEN(aLinha[nAuxIt]) < 4
							If nDesc == 0
								aCols[Len(aCols),nX] := 0.00
							Else
								aCols[Len(aCols),nX] := Round(((DA1->DA1_PRCVEN*nDesc)/100)*aLinha[nAuxIt][2],2)  //aLinha[nAuxIt][2]*(DA1->DA1_PRCVEN-(nPrcven))
							Endif
						Else
							aCols[Len(aCols),nX] := aLinha[nAuxIt][2]*aLinha[nAuxIt][5]
						EndIf
					ElseIf AllTrim(aHeader[nX,2]) == "C6_CODATLA"
						aCols[Len(aCols),nX] := SB1->B1_CODINT
					ElseIf AllTrim(aHeader[nX,2]) == "C6_DESCRI"
						aCols[Len(aCols),nX] := SB1->B1_DESC
					ElseIf AllTrim(aHeader[nX,2]) == "C6_LOCAL"
						
						//<LOOP_20150812-010>
						//aCols[Len(aCols),nX] := SB1->B1_LOCPAD
						aCols[Len(aCols),nX] := M->C5_XLOCAL
						
						/*
						If lxPD
						aCols[Len(aCols),nX] := '99'
						Else
						aCols[Len(aCols),nX]	:= iif( lAcesso, '04', '01' )
						Endif
						*/
						//</LOOP_20150812-010>
						
					ElseIf AllTrim(aHeader[nX,2]) == "C6_EDICAO"
						aCols[Len(aCols),nX] := SB1->B1_EDICAO
					ElseIf AllTrim(aHeader[nX,2]) == "C6_AUTOR"
						aCols[Len(aCols),nX] := SB1->B1_AUTOR
						
					ElseIf AllTrim(aHeader[nX,2]) == "C6_VALOR"
						If LEN(aLinha[nAuxIt]) >= 4
							aCols[Len(aCols),nX] := Round( ( (aLinha[nAuxIt,4]-aLinha[nAuxIt,5]) * aLinha[nAuxIt][2] ),2)
						Else
							aCols[Len(aCols),nX] := Round((DA1->DA1_PRCVEN*aLinha[nAuxIt][2])-((DA1->DA1_PRCVEN*nDesc)/100)*aLinha[nAuxIt][2],2)
						EndIf
						
					ElseIf AllTrim(aHeader[nX,2]) == "C6_TES"
					
						aAreaSF4	:= SF4->(GetArea())						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Cleuto - 12/07/2017                      ³
						//³                                         ³
						//³Se obra Gen e TES PAI existe no parametro³
						//³deve utilizar a TES padrão do produto    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						DbSelectArea("SA1")
						DbSetOrder(1)
						DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)

						If AllTrim(SB1->B1_PROC) $ cMvCodFor .AND. AllTrim(Posicione("SF4",1,xFilial("SF4")+M->C5_XTES,"F4_XTESPAI"))+"#" $ AllTrim(cTesPai)+"#" 
							If SA1->A1_EST <> "EX"
								aCols[Len(aCols),nX] := SB1->B1_TS
							Else
								aCols[Len(aCols),nX] := AllTrim(cTESExp) //TES Padrão de exportação Obras GEN
							EndIf
						Else
							aCols[Len(aCols),nX] := M->C5_XTES	
						EndIf

						RestArea(aAreaSF4)
					ElseIf AllTrim(aHeader[nX,2]) == "C6_CONTA"
					
						aAreaSF4	:= SF4->(GetArea())
						aCols[Len(aCols),nX] := Posicione("SF4",1,xFilial("SF4")+ aCols[Len(aCols),GdFieldPos("C6_TES",aHeader)] ,"F4_XCONTA")
						RestArea(aAreaSF4)
						
					ElseIf AllTrim(aHeader[nX,2]) == "C6_UM"
						aCols[Len(aCols),nX] := SB1->B1_UM
					ElseIf AllTrim(aHeader[nX,2]) == "C6_TABELA"
						aCols[Len(aCols),nX] := M->C5_TABELA
					ElseIf AllTrim(aHeader[nX,2]) == "C6_ENTREG"
						aCols[Len(aCols),nX] := DDATABASE
					ElseIf AllTrim(aHeader[nX,2]) == "C6_REC_WT"
						aCols[Len(aCols),nX] := 0
					ElseIf AllTrim(aHeader[nX,2]) == "C6_ALI_WT"
						aCols[Len(aCols),nX] := "SC6"
						//TAKAKI
					ElseIf AllTrim(aHeader[nX,2]) == "C6_TIPOTRF"
						aCols[Len(aCols),nX] := nTipoTrf
					ElseIf AllTrim(aHeader[nX,2]) == "C6_CODISS"
						aCols[Len(aCols),nX] := SB1->B1_CODISS	
					Else
						If aHeader[nX,10] <> 'V'
							aCols[Len(aCols),nX] := CriaVar(AllTrim(aHeader[nX,2]),.F.)
						Endif
					EndIf
				Next nX
				
				aCols[Len(aCols),Len(aHeader)+1] := .F.
				
				n := Len(aCols)
				M->C6_QTDVEN := aLinha[nAuxIt][2]
				
			Endif
			
			
			cReadVar := "M->C6_QTDVEN"
			__READVAR := "M->C6_QTDVEN"
			
			//<LOOP_20150812-011>
			//U_AvalQtde(.F.,M->C5_SEQEMP)
			//</LOOP_20150812-011>
		Next nAuxIt
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Recalcula as linhas do pedido                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RefazAcols(1,M->C5_XTES, 0, .F., .F. )
	n := 1
ElseIf cOpcAcols == '3'	
	
	//A415DesCab( .T. )
	
	DbSelectArea("TMP1")
	nTotReg := Len(aLinha)
	If nTotReg > 0
		//nBrLin	:= 1
		//nPosObj := aScan(oDlgAtu:aControls, {|x|  AllTrim(x:ClassName()) == "BRGETDDB"  } )	
		//cItem:= "00"

		//oGetDad():ForceRefresh()		
		
		//TMP1->(DbGoTop())
		//TMP1->( DbEval( {|x| cItem	:= IIF( TMP1->CK_ITEM > cItem .AND. !EMPTY(TMP1->CK_PRODUTO), TMP1->CK_ITEM , cItem ) } ) )
		
		ProcRegua(nTotReg)
		For nAuxIt := 1 to nTotReg
			//oDlgAtu:aControls[nPosObj]:ADDLINE()
			//nBrLin++
			IncProc("Carregando Linhas... Linha [ "+Alltrim(Str(nAtual++))+" / "+Alltrim(Str(nTotReg))+" ]")
			lAchou	:= .f.
			//nPos := Ascan(aCols,{|x| Alltrim(x[BuscaHeader("C6_PRODUTO")])==Alltrim(aLinha[nAuxIt][1])})			
			TMP1->(DbGotop())
			/*
			If !TMP1->CK_FLAG .AND. EMPTY(TMP1->CK_PRODUTO)
				RecLock("TMP1",.F.)
				TMP1->CK_FLAG	:= .T.
				MsUnLock()				 
			EndIf
			*/
			While TMP1->(!eOf())
				//nBrLin++
				If ALLTRIM(TMP1->CK_PRODUTO) == ALLTRIM(aLinha[nAuxIt][1]) .AND. !TMP1->CK_FLAG .AND. !EMPTY(TMP1->CK_PRODUTO)
					lAchou	:= .T.
					Exit
				EndIf
				
				TMP1->(DbSkip())
			EndDo
			
			If lAchou .And. lAgrupa
			
				TMP1->CK_QTDVEN 	:= TMP1->CK_QTDVEN+aLinha[nAuxIt][2]
				TMP1->CK_VALOR		:= Round(TMP1->CK_PRCVEN*TMP1->CK_QTDVEN,2)
				TMP1->CK_VALDESC	:= Round( (TMP1->CK_PRUNIT*TMP1->CK_QTDVEN)-(TMP1->CK_PRCVEN*TMP1->CK_QTDVEN) ,2)
				
			Else
				
				//cItem:= Soma1(cItem)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciona a tabela de produtos                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				TMP1->(DbGotop())
				SB1->(DbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+aLinha[nAuxIt][1]))
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no cadastro de Tabela de Precos                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
				DA1->( DbSetOrder(1) )
				DA1->(dbSeek(xFilial("DA1")+M->CJ_TABELA+aLinha[nAuxIt][1],.F.))
				
				nDesc	:= POSICIONE("SZ2",1,XFILIAL("SZ2")+SA1->A1_XTPDES+SB1->B1_GRUPO,"Z2_PERCDES")				
				cx1Tes	:= SB1->B1_TS //CJ_XTES
				lNewSCK	:= !(TMP1->CK_ITEM == "01" .AND. !TMP1->CK_FLAG .AND. EMPTY(TMP1->CK_PRODUTO))
                /*
				If lNewSCK
					oDlgAtu:aControls[nPosObj]:NLINHAS++
					oDlgAtu:aControls[nPosObj]:NLEN++
					oDlgAtu:aControls[nPosObj]:NAT++
				EndIf
				*/		
				DbSelectArea("TMP1")
				If lNewSCK					
					TMP1->(dbGoBottom())
					oGetDad:AddLine() 
				EndIF
				RecLock("TMP1",.F.)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Carrega os dados importados na linha do pedido                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//aCols[Len(aCols),GdFieldPos("C6_QTDVEN",aHeader)]	:= aLinha[nAuxIt,2]
				//aCols[Len(aCols),GdFieldPos("C6_PRCVEN",aHeader)]	:= 0
				//TMP1->CK_FLAG		:= .F.
				//TMP1->CK_ITEM		:= cItem
				TMP1->CK_PRODUTO	:= SB1->B1_COD
				TMP1->CK_DESCRI		:= SB1->B1_DESC
				TMP1->CK_UM			:= SB1->B1_UM
				TMP1->CK_QTDVEN		:= aLinha[nAuxIt][2]

				TMP1->CK_PRUNIT		:= DA1->DA1_PRCVEN
				IF LEN(aLinha[nAuxIt]) >= 4 .AND. !lAgrupa
					TMP1->CK_PRCVEN		:= aLinha[nAuxIt,4]-aLinha[nAuxIt,5]
				Else
					If nDesc == 0
						TMP1->CK_PRCVEN	:= DA1->DA1_PRCVEN
					Else
						TMP1->CK_PRCVEN	:= DA1->DA1_PRCVEN - ((DA1->DA1_PRCVEN*nDesc)/100)
					EndIf
				EndIf

				If LEN(aLinha[nAuxIt]) >= 4 .AND. !lAgrupa
					TMP1->CK_VALOR		:= Round( ( (aLinha[nAuxIt,4]-aLinha[nAuxIt,5]) * aLinha[nAuxIt][2] ),2)
				Else
					TMP1->CK_VALOR		:= Round((DA1->DA1_PRCVEN*aLinha[nAuxIt][2])-((DA1->DA1_PRCVEN*nDesc)/100)*aLinha[nAuxIt][2],2)
				EndIf
				
				TMP1->CK_TES		:= Posicione("SF4", 1, xFilial("SF4") + cx1Tes, "F4_CODIGO")				
				//TMP1->CK_OPER		:= SF4->F4_OPERA
				TMP1->CK_LOCAL		:= SB1->B1_LOCPAD

				IF LEN(aLinha[nAuxIt]) >= 4 .AND. !lAgrupa
					TMP1->CK_DESCONT	:= Round((aLinha[nAuxIt][5]/aLinha[nAuxIt][4])*100,2)
				Else
					TMP1->CK_DESCONT	:= nDesc
				EndIf

				If LEN(aLinha[nAuxIt]) < 4 .OR. lAgrupa
					If nDesc == 0
						TMP1->CK_VALDESC	:= 0.00
					Else
						TMP1->CK_VALDESC	:= Round(((DA1->DA1_PRCVEN*nDesc)/100)*aLinha[nAuxIt][2],2)  //aLinha[nAuxIt][2]*(DA1->DA1_PRCVEN-(nPrcven))
					Endif
				Else
					TMP1->CK_VALDESC	:=	aLinha[nAuxIt][5]*aLinha[nAuxIt][2]
				EndIf
				 
				//TMP1->CK_CLASFIS	:= 
				TMP1->CK_FILVEN		:= cFilAnt
				TMP1->CK_FILENT		:= cFilAnt								
				MsUnLock()
			Endif
			
			M->CK_QTDVEN	:= TMP1->CK_QTDVEN
			M->CK_PRUNIT	:= TMP1->CK_PRUNIT
			M->CK_PRCVEN	:= TMP1->CK_PRCVEN
			M->CK_VALOR 	:= TMP1->CK_VALOR
			M->CK_DESCONT	:= TMP1->CK_DESCONT
			oGetDad:oBrowse:Refresh()
			oGetDad:ForceRefresh()			
			
			//A415LinOk(oGetDad)
			//A415LinOk(oGetDad)
			//oGetDad:ForceRefresh()
			//EvalTrigger()				
			//A415DesCab( .T. )
		    
		Next nAuxIt
		DbSelectArea("TMP1")
		TMP1->(dbGoBottom())		
		oGetDad:AddLine() 
		oGetDad:ForceRefresh()
		oGetDad:oBrowse:Refresh()		

	Endif	
	
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidDadosºAutor  ³Gustavo Marques     º Data ³  31/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida dados importados                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Editora Atlas                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidDados()
Local aDados 	:= {}
Local aNovo		:= {}
Local cProduto	:= ""
Local nQuant	:= 0
Local nPreco 	:= 0
Local nPrcVen	:= 0
Local nDesc		:= 0
Local nDesconto	:= 0
Local lRet		:= .T.
Local nPos		:= 0
Local nTotReg	:= 0
Local nAtual	:= 1
Local nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Limpa variavel de Log de Erros                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aError := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria array que ira ser manipulado na validacao                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDados := Aclone(aItens)
aSort(aDados,,,{|x,y| x[1] < y[1]})

nTotReg := Len(aDados)

ProcRegua(nTotReg)

For nX:= 1 To nTotReg
	IncProc("Validando dados importados... Linha [ "+Alltrim(Str(nAtual++))+" / "+Alltrim(Str(nTotReg))+" ]")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o item anterior é igual ao atual                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cProduto <> aDados[nX,1] .and. nX > 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Guarda itens com dados agrupados                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aNovo,{cProduto,nQuant,nPreco})
		cProduto:= ""
		nQuant 	:= 0
		nPreco	:= aDados[nX,3]
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o produto existe na base de dados                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSetOrder(5)
	dbGoTop()
	If !dbSeek(xFilial()+aDados[nX,1])
		nPos := aScan(aError,{|x| x[1]==aDados[nX,1]})
		If nPos = 0
			Aadd(aError,{aDados[nX,1],"Produto nao encontrado na base de dados",1})
		Else
			aError[nPos][3] := aError[nPos][3]+1
		Endif
		lRet := .F.
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o preco dos produto repetidos sao iguais                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cProduto == aDados[nX,1]
		If nPreco <> aDados[nX,3]
			nPos := aScan(aError,{|x| x[1]==aDados[nX,1]})
			If nPos = 0
				Aadd(aError,{cProduto,"Inconsistencia de valores",1})
			Else
				aError[nPos][3] := aError[nPos][3]+1
			Endif
			
			lRet := .F.
		Endif
	Endif
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Guarda dados atuais para ser comparados com o proximo                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cProduto:= aDados[nX,1]
	nQuant	+= aDados[nX,2]
	nPreco	:= aDados[nX,3]
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se os dados atuais estao incluidos                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPos	:= aScan( aNovo , { |x| x[1] == cProduto } )
If ( nPos = 0 )
	Aadd(aNovo,{cProduto,nQuant,nPreco})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza array de itens com dados agrupados                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aItens := {}
If lRet
	aItens := Aclone(aNovo)
Endif

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SelArq    ºAutor  ³Gustavo Marques     º Data ³  31/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Seleciona Arquivo                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Editora Atlas                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SelArq(cArq)
Local cArquivo
Local nPos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retira o caminho e retorna somente o nome do arquivo                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

While .T.
	nPos := AT("\",cArq)
	If nPos > 0
		cArquivo := SubStr(cArq,nPos+1,Len(cArq))
		cArq := cArquivo
	Else
		Exit
	Endif
Enddo

Return(cArquivo)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFATA32   ºAutor  ³Gustavo Marques     º Data ³  24/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega linhas do pedido de acordo com o XML               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Editora Atlas                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GENA028B

Processa({||PFAT33B1()},"Aguarde...","Lendo Arquivo Texto...",.T.)

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA028   ºAutor  ³Microsiga           º Data ³  08/17/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA028E()

Processa({|| PFAT33B1()},"Aguarde...","Lendo Arquivo Texto...",.T.)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA028   ºAutor  ³Microsiga           º Data ³  08/17/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpTxt(lAcessPreco)

Local cType		:=	"Arquivo Texto|*.TXT|Todos os Arquivos|*.*"
Local cArq 		:=	""

cArq :=	cGetFile(cType, OemToAnsi("Selecione o arquivo de Pedidos de Vendas"),0,"SERVIDOR",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
If Empty(cArq)
	Aviso("ATENCAO","Escolha um Arquivo de Pedido de Venda.",{"&Ok"},1,"Escolha um Arquivo!")
	Return(.f.)
EndIf

If Empty(cArq) .Or. !File(cArq)
	lRet := .f.
	Return
Else
	nHdl := FT_FUSE(cArq)
	nHdl := Iif(nHdl == Nil,1,nHdl)
Endif

If nHdl < 0
	Aviso("Nao foi possivel Abrir o arquivo", "Erro ao Abrir o Arquivo!", {"&Ok"})
	lRet := .f.
	Return
EndIf

nAuxLin	:= 0
nTotReg	:= FT_FLASTREC()
FT_FGOTOP()
While !FT_FEOF()
	
	nAuxLin++
	IncProc("Lendo arquivo texto... Linha [ "+Alltrim(Str(nAuxLin++))+" / "+Alltrim(Str(nTotReg))+" ] ")
	
	// Realiza a leitura da linha
	cBuffer := Alltrim(FT_FREADLN())
	
	// Troca os caracteres invalidos
	// cBuffer := Upper(u_RetAcent(cBuffer))
	
	If Empty(cBuffer)
		FT_FSKIP()
		Loop
	EndIf
	
	If Len(StrTokArr(cBuffer,";")) < 2
		MsgStop("Linha "+AllTrim(Str(nAuxLin))+" não atende o padrão de layout necessario.: PRODUTO;QUANTIDADE ")
		FT_FSKIP()
		Loop
	EndIf
	
	cMGet1 += StrTokArr(cBuffer,";")[1]+chr(13)+Chr(10)
	cMGet2 += StrTokArr(cBuffer,";")[2]+chr(13)+Chr(10)
	
	If Len(StrTokArr(cBuffer,";")) >= 3 .AND. lAcessPreco
		cMGet3 += StrTokArr(cBuffer,";")[3]+chr(13)+Chr(10)
	EndIF
	
	FT_FSKIP()
EndDo

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³PFAT33B1  º Autor ³ AP  IDE            º Data ³  16.04.03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. 										                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PFAT33B1()

Local cType		:=	"Arquivo Texto|*.TXT|Todos os Arquivos|*.*"
Local cArq 		:= ""

Local cFilSB1	:= xFilial("SB1")
Local cFilSF4	:= xFilial("SF4")
Local cFilSA1	:= xFilial("SA1")
Local cFilDA1	:= xFilial("DA1")

Local nHdl		:= 0
Local cBuffer
Local nA, nB
Local nX		:= 0
Local cItem		:= "00"
Local nItens	:= 0

Local nTotItens := 0
Local nVezes	:= 1
Local cEOL		:= Chr(13)+Chr(10)


Local aITE 		:= {}
Local cNUM		:= ""
Local cCLI		:= ""
Local cLOJ		:= ""
Local cCGC		:= ""
Local cITE		:= ""
Local cPRO		:= ""
Local cEAN13	:= "" // Elizeu - 01/03/2011
Local nPOS		:= 0
Local nPrc		:= 0
Local lPerg		:= .F. // Anderson - 01/11/11

Local aA1		:= {}
Local lRet		:= .T.

Local nTotReg	:= 0
Local nAtual	:= 1

Private cTabela		:= M->C5_TABELA// GetMv("MV_TABELA")
Private cEstado 	:= SA1->A1_EST // GetMv("MV_ESTADO")
Private cArqIt	:= ""
Private cInd1	:= ""
Private cInd2 	:= ""

Private lxPD		:= .F.

Private cx1Tes		:= CriaVar("C6_TES",.F.)
Private cx1CondPag	:= CriaVar("C5_CONDPAG",.F.)
Private cx1Transp	:= CriaVar("C5_TRANSP",.F.)

Private cx1Obs1		:= CriaVar("C5_MENNOTA",.F.)
//Private cx1Obs2		:= CriaVar("C5_MENNOT2",.F.)
//Private cx1Obs3		:= CriaVar("C5_MENNOT3",.F.)

Private nTItens		:= 0

If Empty(cArq)
	cArq :=	cGetFile(cType, OemToAnsi("Selecione o arquivo de Pedidos de Vendas"),0,"SERVIDOR",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
	If Empty(cArq)
		Aviso("ATENCAO","Escolha um Arquivo de Pedido de Venda.",{"&Ok"},1,"Escolha um Arquivo!")
		Return(.f.)
	EndIf
EndIf

If Empty(cArq) .Or. !File(cArq)
	lRet := .f.
	Return
Else
	nHdl := FT_FUSE(cArq)
	nHdl := Iif(nHdl == Nil,1,nHdl)
Endif

If nHdl < 0
	Aviso("Nao foi possivel Abrir o arquivo", "Erro ao Abrir o Arquivo", {"&Ok"})
	lRet := .f.
	Return
EndIf

// Criar Arquivo Temporario
PFAT33B2()

aITE := {}
aPedBlock := {}
DbSelectArea("SB1")
DbSetOrder(1)


nTotReg	:= FT_FLASTREC()
ProcRegua(nTotReg)


//<LOOP_20150812>
//lxPD := (M->C5_XTES=="603")
nAuxLin	:= 0
FT_FGOTOP()
While !FT_FEOF()
	nAuxLin++
	IncProc("Lendo arquivo texto... Linha [ "+Alltrim(Str(nAtual++))+" / "+Alltrim(Str(nTotReg))+" ] ")
	
	// Realiza a leitura da linha
	cBuffer := Alltrim(FT_FREADLN())
	
	// Troca os caracteres invalidos
	// cBuffer := Upper(u_RetAcent(cBuffer))
	
	If Empty(cBuffer)
		FT_FSKIP()
		Loop
	EndIf
	
	
	//If Subs(cBuffer,1,1) == "2"<LOOP_20150812-022>	// Itens do Pedido Eletronico
	DbSelectArea("TMPITE")
	// 06/04/04 - Dantas - Evitar a Repeticao de Produto
	/*
	<LOOP_20150812-022>
	cNUM := Subs(cBuffer,002,06)
	cCLI := Subs(cBuffer,008,06)
	cLOJ := Subs(cBuffer,014,02)
	cCGC := Subs(cBuffer,016,15)
	cITE := Subs(cBuffer,080,06)
	cPRO := Subs(cBuffer,031,15)
	
	// Elizeu - 01/03/2011
	cEAN13 := Subs(cBuffer,046,20)
	
	</LOOP_20150812-022>
	*/
	
	If Len(StrTokArr(cBuffer,";")) < 2
		MsgStop("Linha "+AllTrim(Str(nAuxLin))+" não atende o padrão de layout necessario.: PRODUTO;QUANTIDADE ")
		FT_FSKIP()
		Loop
	EndIf
	
	cPRO := StrTokArr(cBuffer,";")[1]
	nQtd := Val(StrTokArr(cBuffer,";")[2])
	
	If Len(StrTokArr(cBuffer,";")) >= 3
		nPrc := Val(StrTokArr(cBuffer,";")[3])
	EndIF
	
	SB1->(DbSetOrder(1))
	If !SB1->(DbSeek(xFilial("SB1")+cPRO))
		SB1->(DbSetOrder(5)) // B1_FILIAL + B1_CODBAR
		If !SB1->(DbSeek(xFilial("SB1")+cPRO))
			Aadd(aPedBlock, {M->C5_NUM,M->C5_CLIENT, M->C5_LOJACLI, "", cPRO, "", "", "", 0})
			FT_FSKIP()
			Loop
		EndIf
	EndIF
	
	cPRO	:= SB1->B1_COD
	
	/* <LOOP_20150812-023>
	If Empty(cPRO) .and. !Empty(cEAN13)
	SB1->( DbSetOrder(5) ) // B1_FILIAL + B1_CODBAR
	If SB1->( DbSeek(xFilial("SB1")+cEAN13) )
	cPRO := SB1->B1_COD
	
	//Verifica se existe nova edicao em circulação
	cQry := "SELECT Max(B1_COD) B1_NOVO, B1_BLOQUE FROM "+RetSqlName("SB1")+" WHERE B1_FILIAL='"+xFilial("SB1")+"' AND B1_TIPO = '"+SB1->B1_TIPO+"'  AND B1_XMODELO = '01' AND B1_CODINT='"+SB1->B1_CODINT+"' AND B1_COD>'"+cPRO+"' AND D_E_L_E_T_ <> '*' GROUP BY B1_BLOQUE"
	
	If Select("B1") > 0
	DbSelectArea("B1")
	DbCloseArea()
	EndIf
	
	TCQUERY cQry NEW ALIAS "B1"
	
	If B1->(!Eof())
	If !Empty(B1->B1_NOVO) .AND. B1->B1_BLOQUE <> "S"
	Do Case
	Case lPerg == .T.
	If lAutEd
	cPRO := Alltrim(B1->B1_NOVO)
	Endif
	Case lPerg == .F.
	If Aviso("A V I S O  !!! - "+ Procname(), "Esse livro tem uma edição mais atual! Deseja trocar?",{"&Nao", "&Sim"}, 2, "Atencao:")==2
	lAutEd := .T.
	cPRO := Alltrim(B1->B1_NOVO)
	Else
	lAutEd := .F.
	Endif
	lPerg := .T.
	EndCase
	Endif
	EndIf
	
	DbSelectArea("B1")
	DbCloseArea()
	
	SB1->( DbSetOrder(1) )
	SB1->(DbSeek(xFilial("SB1")+cPRO))
	Endif
	SB1->( DbSetOrder(1) )
	Endif
	
	If SB1->(DbSeek(xFilial("SB1")+cPRO))
	
	//Verifica se existe nova edicao em circulação
	cQry := "SELECT Max(B1_COD) B1_NOVO, B1_BLOQUE FROM "+RetSqlName("SB1")+" WHERE B1_FILIAL='"+xFilial("SB1")+"' AND B1_TIPO = '"+SB1->B1_TIPO+"'  AND B1_XMODELO = '01' AND B1_CODINT='"+SB1->B1_CODINT+"' AND B1_COD>'"+cPRO+"' AND D_E_L_E_T_ <> '*' GROUP BY B1_BLOQUE"
	
	
	If Select("B1") > 0
	DbSelectArea("B1")
	DbCloseArea()
	EndIf
	
	TCQUERY cQry NEW ALIAS "B1"
	
	If B1->(!Eof())
	If !Empty(B1->B1_NOVO) .AND. B1->B1_BLOQUE <> "S"
	Do Case
	Case lPerg == .T.
	If lAutEd
	cPRO := Alltrim(B1->B1_NOVO)
	Endif
	Case lPerg == .F.
	If Aviso("A V I S O  !!! - "+ Procname(), "Esse livro tem uma edição mais atual! Deseja trocar?",{"&Nao", "&Sim"}, 2, "Atencao:")==2
	lAutEd := .T.
	cPRO := Alltrim(B1->B1_NOVO)
	Else
	lAutEd := .F.
	Endif
	lPerg := .T.
	EndCase
	Endif
	EndIf
	
	SB1->( DbSetOrder(1) )
	SB1->(DbSeek(xFilial("SB1")+cPRO))
	
	
	If SB1->B1_BLOQUE == "S" .and. SB1->B1_TIPO <> "PD"
	If M->C5_TABELA # GetMv("MV_XPEXPAR")
	//Ref. chamado 7492 - ver cabecalho
	Aadd(aPedBlock, {M->C5_NUM,M->C5_CLIENT, M->C5_LOJACLI, cITE, Trim(SB1->B1_CODBAR), SB1->B1_DESC, SB1->B1_EDICAO, SB1->B1_AUTOR, Val(Subs(cBuffer,071,09))})
	FT_FSKIP()
	Loop
	EndIf
	EndIf
	
	If !lxPD .and. SB1->B1_TIPO == "PD"
	If M->C5_TABELA # GetMv("MV_XPEXPAR")
	// Ignorar item
	Aadd(aPedBlock, { M->C5_NUM,M->C5_CLIENT, M->C5_LOJACLI,cITE, Trim(SB1->B1_CODBAR), SB1->B1_DESC, SB1->B1_EDICAO, SB1->B1_AUTOR, Val(Subs(cBuffer,071,09))})
	FT_FSKIP()
	Loop
	Endif
	Endif
	
	If lxPD .and. SB1->B1_TIPO <> "PD"
	If M->C5_TABELA # GetMv("MV_XPEXPAR")
	// Ignorar item
	Aadd(aPedBlock, { M->C5_NUM,M->C5_CLIENT, M->C5_LOJACLI, cITE, Trim(SB1->B1_CODBAR), SB1->B1_DESC, SB1->B1_EDICAO, SB1->B1_AUTOR, Val(Subs(cBuffer,071,09))})
	FT_FSKIP()
	Loop
	EndIf
	Endif
	Else
	//Ref. chamado 7492 - ver cabecalho
	Aadd(aPedBlock, {M->C5_NUM,M->C5_CLIENT, M->C5_LOJACLI, cITE, Trim(SB1->B1_CODBAR), SB1->B1_DESC, SB1->B1_EDICAO, SB1->B1_AUTOR, Val(Subs(cBuffer,071,09))})
	FT_FSKIP()
	Loop
	EndIf
	</LOOP_20150812-023>
	*/
	
	nPOS := Ascan(aITE, {|aV| aV[06]=cPRO})
	If nPOS > 0
		TMPITE->(DbGoto(aITE[nPOS, 07]))
		Reclock("TMPITE", .F.)
		TMPITE->ITE_QUANT	:=	TMPITE->ITE_QUANT + nQtd//Val(Subs(cBuffer,071,09))
		TMPITE->( MsUnlock() )
		TMPITE->( dbCommit() )
	Else
		Reclock("TMPITE",.T.)
		TMPITE->ITE_TIPO	:=	""//Subs(cBuffer,001,01)
		TMPITE->ITE_NUMERO	:=	""//Subs(cBuffer,002,06)
		TMPITE->ITE_CLI		:=	""//Subs(cBuffer,008,06)
		TMPITE->ITE_LOJA	:=	""//Subs(cBuffer,014,02)
		TMPITE->ITE_CGCCLI	:=	""//Subs(cBuffer,016,15)
		TMPITE->ITE_PROD	:=	cPRO //Subs(cBuffer,031,15)
		
		TMPITE->ITE_DESC	:=	SB1->B1_DESC
		//			TMPITE->ITE_AUTOR	:=	SB1->B1_AUTOR
		//			TMPITE->ITE_EDICAO	:=	SB1->B1_EDICAO
		
		TMPITE->ITE_CBAR	:=	SB1->B1_CODBAR//Subs(cBuffer,046,15)
		TMPITE->ITE_ISBN	:=	SB1->B1_CODBAR//Subs(cBuffer,061,10)
		TMPITE->ITE_QUANT	:=	nQtd//Val(Subs(cBuffer,071,09))
		TMPITE->ITE_ITEM	:=	""//Subs(cBuffer,080,06)
		TMPITE->ITE_LOCPAD	:=	SB1->B1_LOCPAD//Subs(cBuffer,086,02)
		TMPITE->ITE_PRUNIT	:=  nPrc
		//If lxPD
		//	TMPITE->ITE_CBAR	:=	Subs(cBuffer,046,20)
		//	TMPITE->ITE_ISBN	:=	Subs(cBuffer,066,05)
		//	TMPITE->ITE_PRUNIT	:=	(Val(Subs(cBuffer,088,08))/10000)
		//Endif
		
		TMPITE->RECNO	:=	TMPITE->(RECNO())
		TMPITE->( MsUnlock() )
		TMPITE->( dbCommit() )
		Aadd(aITE, {M->C5_NUM,M->C5_CLIENT, M->C5_LOJACLI, ""/*cCGC*/, "" /*cITE*/, cPRO, TMPITE->(RECNO())})
	EndIf
	//EndIf </LOOP_20150812-022>
	FT_FSKIP()
EndDo
FT_FUSE()


nTItens := Len(aITE)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenche as linhas do pedido                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({||PFAT33B3()},"Aguarde...","Carregando Linhas...",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Reposiciona os indices do SB1 e SF4                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SB1")
DbSetOrder(1)

DbSelectArea("SF4")
DbSetOrder(1)

DbSelectArea("SF1")
DbSetOrder(1)

If Select("TMPITE") > 0
	dbSelectArea("TMPITE")
	TMPITE->( dbCloseArea() )
	
	FErase(cArqIt + GetDBExtension())
	FErase(cInd1 + OrdBagExt())
	FErase(cInd2 + OrdBagExt())
EndIf

Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³PFAT33B3  º Autor ³ Gustavo Marques    º Data ³  06.09.11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Preenche linha do pedido de acordo com o arquivo texto.    º±±
±±º          ³          								                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Editora Atlas                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PFAT33B3()

Local cItem		:= "00"
Local nItens	:= 0
Local nAtual	:= 1
Local i 		:= 1
Local nDesc		:= 0
Local aItmTmp	:= {}

Local cFilSB1	:= xFilial("SB1")
Local cFilSF4	:= xFilial("SF4")
Local cFilSA1	:= xFilial("SA1")
Local cFilDA1	:= xFilial("DA1")

Local cCliente  := ""		// Dantas - 18/04/06 - Esta gravando a segunda Parte do Pedido com outro Cliente na Quebra - Gorete-Vendas
Local cLoja     := ""		// Dantas - 18/04/06 - Esta gravando a segunda Parte do Pedido com outro Cliente na Quebra - Gorete-Vendas

Local lParDescEsp := .f. //GetMv ("MV_XDESCES",,.F. ) // Elizeu - 09/02/2010
Local cSZQAtivo := " " // Elizeu - 09/02/2010
Local nX,nY

cItem:= StrZero(1,TamSX3("C6_ITEM")[1])

dbSelectArea("TMPITE")
TMPITE->( dbSetOrder(2) )
TMPITE->( dbGotop() )


//aCols := {}
/*
<LOOP_20150812-024>
dbSelectArea("SA1")
SA1->( dbSetOrder(1) )
If SA1->( dbSeek(cFilSA1+M->C5_CLIENT+M->C5_LOJACLI) )
cCliente := SA1->A1_COD
cLoja	 := SA1->A1_LOJA
EndIf

dbSelectArea("SF4")
SF4->( dbSetOrder(1) )
If SF4->( !dbSeek(cFilSF4+M->C5_XTES,.F.) )
Aviso("Nao foi possivel definir o TES", "Tipo de Entrada e Saida nao encontrado no cadastro de TES.", {"&Ok"})
EndIf
</LOOP_20150812-024>
*/

ProcRegua(nTItens)

While !TMPITE->(Eof())
	nItens++
	IncProc("Carregando Linhas... Linha [ "+Alltrim(Str(nAtual++))+" / "+Alltrim(Str(nTItens))+" ]")
	
	nPos := Ascan(aCols,{|x| Alltrim(x[BuscaHeader("C6_PRODUTO")])==Alltrim(TMPITE->ITE_PROD)})
	If nPos > 0
		For nX := 1 To Len(aHeader)
			If AllTrim(aHeader[nX,2]) == "C6_QTDVEN"
				aCols[nPos,nX] += TMPITE->ITE_QUANT
				M->C6_QTDVEN := aCols[nPos,nX]
			ElseIf AllTrim(aHeader[nX,2]) == "C6_PRCVEN"
				nPrcven := aCols[nPos,nX]
			ElseIf AllTrim(aHeader[nX,2]) == "C6_VALOR"
				aCols[nPos,nX] := Round((nPrcven*M->C6_QTDVEN),2)
			Endif
		Next nX
		n := nPos
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no cadastro de produtos                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SB1")
		SB1->( DbSetOrder(1) )
		If SB1->( !dbSeek(cFilSB1+TMPITE->ITE_PROD,.F.) )
			Aviso("Nao foi possivel encontrar o produto", "Produto invalido "+TMPITE->ITE_PROD, {"&Ok"})
			DbSelectArea("TMPITE")
			TMPITE->( dbSkip() )
			Loop
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no cadastro de Tabela de Precos                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("DA1")
		DA1->( DbSetOrder(1) )
		//If !lxPD
		If DA1->( !dbSeek(cFilDA1+cTabela+TMPITE->ITE_PROD,.F.) )
			Aviso("Nao foi possivel encontrar a Tabela de Precos", "Tabela de Precos :"+TMPITE->ITE_PROD, {"&Ok"})
			DbSelectArea("TMPITE")
			TMPITE->( dbSkip() )
			Loop
		EndIf
		//Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Mudanca de TES no Produto que Utiliza Papel de Grafica.      ³
		//³ - by Elizeu - 07/07/2011                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cx1Tes := M->C5_XTES
		/* <LOOP_20150812-024>
		If U_PapGraf(SB1->B1_COD)
		cx1Tes := Posicione("SF4", 1, cFilSF4 + M->C5_XTES, "F4_XTSPGRA")
		If Empty(cx1Tes)
		cx1Tes := M->C5_XTES
		Endif
		Endif
		
		If (SF4->F4_FILIAL + SF4->F4_CODIGO) <> (cFilSF4 + cx1Tes)
		dbSelectArea("SF4")
		SF4->( dbSetOrder(1) )
		If SF4->( !dbSeek(cFilSF4+cx1Tes,.F.) )
		Aviso("Nao foi possivel definir o TES: "+cx1Tes, "Tipo de Entrada e Saida nao encontrado no cadastro de TES. ISBN: "+TMPITE->ITE_PROD, {"&Ok"})
		cx1Tes := M->C5_XTES
		DbSelectArea("TMPITE")
		TMPITE->( dbSkip() )
		Loop
		EndIf
		Endif
		</LOOP_20150812-024>
		*/
		
		If  i > 1 .or. Len(aCols) > 1
			cItem:= Soma1(aCols[Len(aCols)][1],TamSX3("C6_ITEM")[1])
			
			Aadd(aCols,Array(Len(aHeader)+1))
		Endif
		
		aCols[Len(aCols),Len(aHeader)+1] 				:= .F.
		aCols[Len(aCols),BuscaHeader("C6_ITEM")] 		:= cItem
		
		aCols[Len(aCols),BuscaHeader("C6_PRODUTO")] 	:= SB1->B1_COD
		
		//		aCols[Len(aCols),BuscaHeader("C6_CODATLA")] 	:= SB1->B1_CODINT //</LOOP_20150812-021>
		aCols[Len(aCols),BuscaHeader("C6_DESCRI")] 	:= SB1->B1_DESC
		//		aCols[Len(aCols),BuscaHeader("C6_EDICAO")] 		:= SB1->B1_EDICAO //</LOOP_20150812-021>
		//		aCols[Len(aCols),BuscaHeader("C6_AUTOR")]		:= SB1->B1_AUTOR //</LOOP_20150812-021>
		aCols[Len(aCols),BuscaHeader("C6_QTDVEN")] 	:= 0
		aCols[Len(aCols),BuscaHeader("C6_PRCVEN")]		:= 0
		RunTrigger(2,n,Nil,,"C6_PRODUTO")
		
		aCols[Len(aCols),BuscaHeader("C6_QTDVEN")] 	:= TMPITE->ITE_QUANT
		aCols[Len(aCols),BuscaHeader("C6_PRCVEN")]		:= 0
		
		//If lxPD
		//	aCols[Len(aCols),BuscaHeader("C6_PRUNIT")] 	:= TMPITE->ITE_PRUNIT
		//Else
		aCols[Len(aCols),BuscaHeader("C6_PRUNIT")] 	:= DA1->DA1_PRCVEN
		//Endif
		/*
		<LOOP_20150812-009>
		If lxPD
		nDesc := 0
		lParDescEsp := .F.
		Else
		nDesc := Iif(SUBS(SB1->B1_CODINT,1,2) $ "05;12;15" .AND. SA1->A1_DESCESP > 0 , SA1->A1_DESCESP, SA1->A1_DESCPAD)
		Endif
		
		// Bloco Adicionado para gatilho automaticado do desconto dos livros juridicos - Elizeu - 09/02/2010
		// Transcrito e adaptado do fonte GFATA02.PRW
		If lParDescEsp
		If SA1->A1_DESCESP <> 0
		DBSelectArea("SZQ")
		SZQ->( DBSetOrder(1) )
		cSZQAtivo := " "
		If SZQ->( DBSeek(xFilial("SZQ")+SB1->B1_CODINT ) )
		cSZQAtivo := SZQ->ZQ_ATIVO // S/N
		Endif
		If Substr(SB1->B1_CODINT,1,2) $ "05;12;15" .or.;
		'DIREI' $ SB1->B1_DESC .or.;
		'JURID' $ SB1->B1_DESC .or.;
		'TRIBUT' $ SB1->B1_DESC .or.;
		'LEGIS' $ SB1->B1_DESC .or.;
		cSZQAtivo == "S"
		
		If cSZQAtivo $ " S"
		nDesc := Iif( SA1->A1_DESCESP <> 0, SA1->A1_DESCESP, SA1->A1_DESCPAD)
		Endif
		Endif
		Endif
		Endif
		// Fim do Bloco Adicionado para gatilho automaticado do desconto dos livros juridicos - Elizeu - 09/02/2010
		</LOOP_20150812-009>
		*/
		
		//If lxPD
		nPrcven := Í IIF( TMPITE->ITE_PRUNIT == 0 , DA1->DA1_PRCVEN , TMPITE->ITE_PRUNIT )
		//Else
		//	nPrcven := DA1->DA1_PRCVEN-(DA1->DA1_PRCVEN*nDesc/100)
		//Endif
		
		aCols[Len(aCols),BuscaHeader("C6_PRCVEN")] 	:= nPrcven
		
		
		If nPrcven <= DA1->DA1_PRCVEN
			aCols[Len(aCols),BuscaHeader("C6_DESCONT")]	:= Round(((DA1->DA1_PRCVEN-(nPrcven))/DA1->DA1_PRCVEN)*100,2)
		EndIF
		
		If lxPD
			aCols[Len(aCols),BuscaHeader("C6_VALDESC")] := 0.00
		Else
			aCols[Len(aCols),BuscaHeader("C6_VALDESC")]	:= TMPITE->ITE_QUANT*(DA1->DA1_PRCVEN-(nPrcven))
		Endif
		
		aCols[Len(aCols),BuscaHeader("C6_VALOR")] 		:= TMPITE->ITE_QUANT*nPrcven
		
		aCols[Len(aCols),BuscaHeader("C6_TES")] 		:= cx1Tes
		aCols[Len(aCols),BuscaHeader("C6_CF")] 		:= Iif(SA1->A1_TIPO != "X", If(SA1->A1_EST == cEstado, SF4->F4_CF, "6"+Subs(SF4->F4_CF,2,LEN(SF4->F4_CF)-1)), "7"+Subs(SF4->F4_CF,2,LEN(SF4->F4_CF)-1))
		
		aCols[Len(aCols),BuscaHeader("C6_UM")] 		:= SB1->B1_UM
		
		If lxPD
			aCols[Len(aCols),BuscaHeader("C6_LOCAL")] := '99'
		Else
			aCols[Len(aCols),BuscaHeader("C6_LOCAL")]	:= IIF(EMPTY(TMPITE->ITE_LOCPAD), '01', TMPITE->ITE_LOCPAD)
		Endif
		
		//aItmTmp[1,BuscaHeader("C6_QTDLIB")]		:= 0
		//aCols[Len(aCols),BuscaHeader("C6_TABELA")] 	:= cTabela </LOOP_20150812-021>
		aCols[Len(aCols),BuscaHeader("C6_ENTREG")] 	:= dDatabase
		
		/* <LOOP_20150812-024>
		If lxPD
		aCols[Len(aCols),BuscaHeader("C6_TIPOTRF")] := 1 // 1 - Permite incluir itens bloqueados (B1_BLOQUE == "S") no pedido.
		Endif
		</LOOP_20150812-024>
		*/
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Acerta os campos nulos do array                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nY := 1 to Len(aHeader)
			If AllTrim(aHeader[nY,2]) $ "C6_ALI_WT#C6_REC_WT"
				Loop
			EndIf
			If aCols[Len(aCols),nY] == NIL
				aCols[Len(aCols),nY] := CriaVar(aHeader[nY,2],.F.)
			Endif
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche quantidade liberada                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		n := Len(aCols)
		M->C6_QTDVEN := TMPITE->ITE_QUANT
		
	Endif
	
	
	cReadVar := "M->C6_QTDVEN"
	__READVAR := "M->C6_QTDVEN"
	
	//U_AvalQtde(.F.,M->C5_SEQEMP)
	
	i++
	
	DbSelectArea("TMPITE")
	TMPITE->( dbSkip() )
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicina na primeira linha                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
n := 1

RefazAcols(1,M->C5_XTES, 0, .F., .F. )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³PFAT33B2  º Autor ³ Gustavo Marques    º Data ³  06.09.11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao Cria arquivos temporarios para importacao do Pedido º±±
±±º          ³ de venda.								                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Editora Atlas                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PFAT33B2()

Local aCposItm	:= {}

If Select("TMPITE") > 0
	dbSelectArea("TMPITE")
	dbCloseArea()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga o arquivo temporario gerado                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FErase("\SYSTEM\" + Trim(cArqIt) + GetDBExtension())
	FErase("\SYSTEM\" + cInd1+OrdBagExt())
	FErase("\SYSTEM\" + cInd2+OrdBagExt())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a Estrutura do Arquivo temporario Itens de NF          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCposIte := {}

aAdd(aCposIte, { "ITE_TIPO" 	, "C"	,01	, 0 })
aAdd(aCposIte, { "ITE_NUMERO" 	, "C"	,06	, 0 })
aAdd(aCposIte, { "ITE_CLI" 		, "C"	,06	, 0 })
aAdd(aCposIte, { "ITE_LOJA" 	, "C"	,02	, 0 })
aAdd(aCposIte, { "ITE_CGCCLI" 	, "C"	,15	, 0 })
aAdd(aCposIte, { "ITE_PROD" 	, "C"	,15	, 0 })

aTam := TamSX3("B1_DESC")
aAdd(aCposIte, { "ITE_DESC" 	, "C"	,aTam[1]	, aTam[2] })

//<LOOP_20150812-021>
//aTam := TamSX3("B1_AUTOR")
//aAdd(aCposIte, { "ITE_AUTOR" 	, "C"	,aTam[1]	, aTam[2] })

//aTam := TamSX3("B1_EDICAO")
//aAdd(aCposIte, { "ITE_EDICAO" 	, "C"	,aTam[1]	, aTam[2] })
//</LOOP_20150812-021>

aAdd(aCposIte, { "ITE_CBAR" 	, "C"	,15	, 0 })
aAdd(aCposIte, { "ITE_ISBN" 	, "C"	,10	, 0 })
aAdd(aCposIte, { "ITE_QUANT" 	, "N"	, 9	, 2	})
aAdd(aCposIte, { "ITE_ITEM" 	, "C"	,06	, 0	})
aAdd(aCposIte, { "ITE_LOCPAD"	, "C"	,02	, 0	})
aAdd(aCposIte, { "ITE_PRUNIT"	, "N"	,14	, 4	}) // Adicionado - Elizeu - 01/03/2011
aAdd(aCposIte, { "RECNO"		, "N"	,08	, 0	}) // Adicionado - Elizeu - 01/03/2011

//cArqIt := CriaTrab(aCposIte, .T.)
//dbUseArea(.T.,,cArqIt,"TMPITE",.T.,.F.)

oTMPITE := FWTemporaryTable():New( "TMPITE" )
oTMPITE:SetFields(aCposIte)

 //------------------
//Criação da tabela temporaria
//------------------
oTMPITE:Create()


cInd1 := CriaTrab(Nil,.F.)
IndRegua("TMPITE",cInd1,"ITE_NUMERO+ITE_CLI+ITE_LOJA+ITE_CGCCLI+ITE_ITEM+ITE_PROD",,.F.,,"Selecionando Registros...")

cInd2 := CriaTrab(Nil,.F.)
IndRegua("TMPITE",cInd2,"RECNO",,.F.,,"Selecionando Registros...")

DbClearIndex()
dbSetIndex(cInd1+OrdBagExt())
dbSetIndex(cInd2+OrdBagExt())

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BuscaHeadeºAutor  ³Microsiga           º Data ³  01/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BuscaHeader(cCampo)

Return(aScan(aHeader,{|x|AllTrim(x[2])==Alltrim(cCampo)}))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³PFAT33C   º Autor ³ Gustavo Marques    º Data ³  08.09.11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³Interface onde o usuario ira colar os dados a serem         º±±
±±º          ³importados.     							                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Editora Atlas                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User  Function GENA028C()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDlg

Local oOk

Local oMGet1
Local oMGet2
Local oMGet3
Local oTpPub

Local oSay
Local cEOL		:= Chr(13)+Chr(10)
Local oChkDig  

Local cGrpA			:= SuperGetMv("GEN_FAT083",.F.,"000001") // <LOOP_20150812-005>
Local aGrpUser 		:= PswRet(1)[1,10]
Local lAcesBlq		:= RetCodUsr() $ GetMv("GEN_FAT143")
Local cLogAux 		:= ""
Local nX
Local lBtOk		:= .F.

Private lAcessPreco	:= .F.

Private aOcorr	:= {}
Private cMGet1	:= "" //:= CriaVar("")
Private cMGet2	:= ""//:= CriaVar("")
Private cMGet3	:= ""
Private cTpPub	:= "   "

Private aLinha	:= {}
Private lPerg	:= .F.
Private lAutEd 	:= .F.
Private lNewEdi	:= .T.
Private lVldEst	:= .F.
Private lPerAgr	:= .T.
Private lVldBlq	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cleuto Lima - Loop Consultoria.                 ³
//³                                                ³
//³17/08/2015.                                     ³
//³                                                ³
//³Substituído acesso de grupo por nome do usuário.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If aScan(aGrpUser,{|x| x == cGrpA }) <> 0
lAcessPreco := .T.
EndIf
*/

lAcessPreco	:= (RetCodUsr() $ cGrpA)

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface com o usuario                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DEFINE MSDIALOG oDlg TITLE "Importa Itens" FROM 000, 000  TO 300, 600 COLORS 0, 16777215 PIXEL style 128

@ 005, 011 SAY oSay PROMPT "Copie e cole o codigo e a quantidade." SIZE 175, 014 OF oDlg PIXEL COLOR CLR_HRED FONT oFont
@ 020, 011 SAY oSay PROMPT "Codigo / Codigo de Barras" SIZE 175, 014 OF oDlg PIXEL  FONT oFont
@ 030, 010 GET oMGet1 VAR cMGet1 MEMO OF oDlg SIZE 088, 088 PIXEL
@ 020, 102 SAY oSay PROMPT "Quantidade" SIZE 175, 014 OF oDlg PIXEL FONT oFont
@ 030, 102 GET oMGet2 VAR cMGet2 MEMO OF oDlg SIZE 088, 088 PIXEL

oChkNew := TCheckBox():New(003,119,'&Sugere nova edição?'	,{|m| If(Pcount()>0, lNewEdi:=m, lNewEdi)},oDlg,100,210,,,,,,,,.T.,,,)

If ISINCALLSTACK("MATA415")
oChkEst := TCheckBox():New(003,183,'&Valida Saldo Estoque?',{|m| If(Pcount()>0, lVldEst:=m, lVldEst)},oDlg,100,210,,,,,,,,.T.,,,)
EndIf

If lAcessPreco
	oChkDig := TCheckBox():New(003,250,'Agrupa It.Repet?',{|m| If(Pcount()>0, lPerAgr:=m, lPerAgr)},oDlg,100,210,,,,,,,,.T.,,,)		
	@ 020, 200 SAY oSay PROMPT "Preço" SIZE 175, 014 OF oDlg PIXEL FONT oFont
	@ 030, 200 GET oMGet3 VAR cMGet3 MEMO OF oDlg SIZE 088, 088 PIXEL
EndIf

If lAcesBlq
	oChkBloq := TCheckBox():New(012,119,'&Valida Obra com bloqueio?',{|m| If(Pcount()>0, lVldBlq:=m, lVldBlq)},oDlg,100,210,,,,,,,,.T.,,,)
EndIf	

@ 127, 010 SAY oSay PROMPT "Tipo publicação" SIZE 175, 014 OF oDlg PIXEL FONT oFont
@ 127, 060 MsGET oTpPub VAR cTpPub Size 30,010 PIXEL Picture OF oDlg F3 "Z4" VALID (!Empty(cTpPub))

@ 127, 150 BUTTON oOk PROMPT "OK" 	SIZE 039, 016 OF oDlg PIXEL  ACTION ( IIF( VldInfo() , ( lBtOk := .T.,oDlg:End()) , nil ) )
@ 127, 200 BUTTON oTxt PROMPT "TXT" SIZE 039, 016 OF oDlg PIXEL  ACTION (ImpTxt(lAcessPreco))
@ 127, 250 BUTTON oExt PROMPT "Sair" SIZE 039, 016 OF oDlg PIXEL  ACTION (cMGet1:="",oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If Len(cMGet1) > 0 .and. !Empty(cTpPub) .AND. lBtOk
	
	Processa({|| ReadBox()},"Aguarde...","Lendo caixa de texto...",.T.)
	
	IF FunName()=="MATA410" .AND. Len(aOcorr) <> 0
		
		cLogAux := ""
		aEval(aOcorr, {|x| cLogAux+=x+chr(13)+chr(10) } )
		MemoWrite("\spool\GENA084_"+xFilial("SC5")+M->C5_NUM+M->C5_CLIENTE+M->C5_LOJACLI+DTOS(M->C5_EMISSAO)+".log",cLogAux)
		
		If MsgYesNo("Encontrados erros ou divergências. Deseja imprimir LOG de ocorrências?","Imprimir LOG")
			U_GENA028T(aOcorr)
		Else
			cMsg := ""
			aEval(aOcorr, {|x| cMsg+=x+Chr(13)+Chr(10) } )
			
			If !MostraLog(cMsg,.T.)
				Return .F.
			EndIf
		EndIf
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³TELA DE LOG ROTINA ORÇAMENTOS(MATA415) - CAIO NEVES -07/05/2019               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	ElseIF FunName()=="MATA415" .AND. Len(aOcorr) <> 0
		
		cLogAux := ""
		aEval(aOcorr, {|x| cLogAux+=x+chr(13)+chr(10) } )

		MemoWrite("\spool\GENA084_"+xFilial("SCJ")+M->CJ_NUM+M->CJ_CLIENTE+M->CJ_LOJA+DTOS(M->CJ_EMISSAO)+".log",cLogAux)
		
		If MsgYesNo("Encontrados erros ou divergências. Deseja imprimir LOG de ocorrências?","Imprimir LOG")
			U_GENA028T(aOcorr)
		Else
			cMsg := ""
			aEval(aOcorr, {|x| cMsg+=x+Chr(13)+Chr(10) } )
			
			If !MostraLog(cMsg,.T.)
				Return .F.
			EndIf
		EndIf
	
	EndIf
	
	If lAcessPreco
		lAgrupa := lPerAgr
	Else
		lAgrupa := !lAcessPreco
	EndIf
	
	If lAgrupa 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Agrupa produtos duplicados                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa({|| TiraRep() },"Aguarde...","Agrupando itens repetidos...",.T.)
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTÄÄ¿
	//³Preenche as linhas do pedido                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If UPPER(AllTrim(FUNNAME())) $ "MATA415	" //ORÇAMENTOS
		Processa({|| GravaAcols("3",lAgrupa)},"Aguarde...","Carregando Linhas...",.T.)
	Else
		Processa({|| GravaAcols("2",lAgrupa)},"Aguarde...","Carregando Linhas...",.T.)
	EndIf
	
	If Type("aPedBlock") == "A" .AND. Len(aPedBlock) > 0
		cTexto := "Itens não incluidos no pedido!"
		cTexto += " " + cEOL
		cTexto += " " + cEOL
		
		For nX := 1 To Len(aPedBlock)
			cTexto  +=  "Item: "+aPedBlock[nX][4]+cEOL
			cTexto  +=  "Produto: "+aPedBlock[nX][5]+" - "+aPedBlock[nX][6]+" "+cEOL
			cTexto  +=  "Edição: "+aPedBlock[nX][7]+cEOL
			cTexto  +=  "Autor: "+aPedBlock[nX][8]+cEOL
			cTexto  +=  "Quantidade: "+Alltrim(Str(aPedBlock[nX][9]))+cEOL
			cTexto 	+= 	" " + cEOL
		Next nX
		
		DEFINE MSDIALOG oDlg TITLE " Intens Não Incluidos " From 3,0 to 340,617 PIXEL
		@ 05,05 GET oMemo VAR cTexto MEMO SIZE 300,145 OF oDlg PIXEL
		oMemo:bRClicked := { || AllwaysTrue( ) }
		DEFINE SBUTTON FROM 153,275 TYPE 1 ACTION oDlg:End( ) ENABLE OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTER
	Endif
	
Endif

Return

Static Function VldInfo()

Local lRet		:= .T.
Local aProdutos :=  StrTokArr(cMGet1,CHR(13)+CHR(10))
Local aQtdes	:=  StrTokArr(cMGet2,CHR(13)+CHR(10))
Local nAtual	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retira linhas em branco no final³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While Len(aProdutos) > 1 .And. AllTrim(aProdutos[Len(aProdutos)])  = ""
	Asize(aProdutos,Len(aProdutos)-1)
EndDo

While Len(aQtdes) > 1 .And. AllTrim(aQtdes[Len(aQtdes)])  = ""
	Asize(aQtdes,Len(aQtdes)-1)
EndDo

If Len(aProdutos) <> Len(aQtdes)
	Aviso("ATENÇÃO","O numero de Isbns informados é diferente do numero de quantidades/Preços!"+Chr(13)+chr(10),{"&Ok"},2,"Atenção")
	return .F.
EndIf

nTotReg := Len(aProdutos)

For nAtual := 1 to nTotReg
	IF Mod(val(StrTran(aQtdes[nAtual],',','.')),1) > 0
		MsgStop("Linha "+StrZero(nAtual,4)+" Produto "+ALLTRIM(aProdutos[nAtual])+" com quantidade fracionada ("+aQtdes[nAtual]+")."+Chr(13)+Chr(10)+;
		"Processo não será realizado" )
		Return .F.
	ENDIF
Next

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TiraRep   ºAutor  ³Gustavo Marques     º Data ³  08/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Agrupa itens repetidos                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Editora Atlas                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TiraRep()
Local aDados 	:= {}
Local aNovo		:= {}
Local cProduto	:= ""
Local nQuant	:= 0
Local nPos		:= 0
Local nTotReg	:= 0
Local nAtual    := 1
Local cRecAtu	:= ""
Local nX


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria array que ira ser manipulado na validacao                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDados := Aclone(aLinha)
aSort(aDados,,,{|x,y| x[1] < y[1]})

nTotReg := Len(aDados)

ProcRegua(nTotReg)

For nX:= 1 To nTotReg
	IncProc("Agrupando itens repetidos... Linha [ "+Alltrim(Str(nAtual))+" / "+Alltrim(Str(nTotReg))+" ]")
	nAtual++
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o item anterior é igual ao atual                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cProduto <> aDados[nX,1] .and. nX > 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Guarda itens com dados agrupados                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aNovo,{cProduto,nQuant,cRecAtu})
		cProduto:= ""
		nQuant 	:= 0
		cRecAtu	:= aDados[nX,3]
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Guarda dados atuais para ser comparados com o proximo                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cProduto:= aDados[nX,1]
	If cRecAtu > aDados[nX,3]  .or. nX == 1
		cRecAtu	:= aDados[nX,3]
	Endif
	nQuant	+= aDados[nX,2]
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se os dados atuais estao incluidos                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPos	:= aScan( aNovo , { |x| x[1] == cProduto } )
If ( nPos = 0 ) .AND. !Empty(cProduto) //ALTERAÇÃO PARA ROTINA MATA415(ORÇAMENTO)
	Aadd(aNovo,{cProduto,nQuant,cRecAtu})
Endif

aSort(aNovo,,,{|x,y| x[3] < y[3]})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza array de itens com dados agrupados                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aLinha := {}
aLinha := Aclone(aNovo)


Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReadBox   ºAutor  ³Gustavo Marques     º Data ³  08/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a leitura da caixa de texto                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Editora Atlas                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReadBox()

Local aProdutos
Local aQtdes
Local aPrecos
Local lPreco	:= .F.
Local cSitValidas	:= GetMv("GEN_FAT239",.F.,"101#105")
Local lB1_Seek  := .F.
Local cProduto 	:= ""
Local nQuant 	:= 0
Local nPreco	:= 0
Local nTotReg	:= 0
Local nAtual	:= 0
Local cOldObra	:= ""
Local cTabPreco	:= ""
Local lObraCanc := .F.
local nsldcons	:= ""
Local lpd3		:= .F.

	
Private lxPD	:= .F.
//AJUSTE PARA VALIDAÇÂO SALDO CONSIGNADO, CONSIDERANDO ROTINA DE ORÇAMENTO
IF ISINCALLSTACK("MATA410") 
	Posicione("SF4",1,xFilial("SF4")+M->C5_XTES,'F4_PODER3') == "R"
	lpd3 :=	.T.
ENDIF

aProdutos :=  StrTokArr(cMGet1,CHR(13)+CHR(10))
aQtdes	  :=  StrTokArr(cMGet2,CHR(13)+CHR(10))
aPrecos	  :=  StrTokArr(cMGet3,CHR(13)+CHR(10))

lPreco	:= Len(aPrecos) > 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retira linhas em branco no final³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While Len(aProdutos) > 1 .And. AllTrim(aProdutos[Len(aProdutos)])  = ""
	Asize(aProdutos,Len(aProdutos)-1)
EndDo

While Len(aQtdes) > 1 .And. AllTrim(aQtdes[Len(aQtdes)])  = ""
	Asize(aQtdes,Len(aQtdes)-1)
EndDo

While Len(aPrecos) > 1 .And. AllTrim(aPrecos[Len(aPrecos)])  = ""
	Asize(aPrecos,Len(aPrecos)-1)
EndDo

If Len(aProdutos) <> Len(aQtdes) .or. ( len(aPrecos) <> Len(aProdutos) .AND. lPreco)
	Aviso("ATENÇÃO","O numero de Isbns informados é diferente do numero de quantidades/Preços!"+Chr(13)+chr(10),{"&Ok"},2,"Atenção")
	return .F.
EndIf

nTotReg := Len(aProdutos)

ProcRegua(nTotReg)

//lxPD := (M->C5_XTES $ "603#604%635") </LOOP_20150812-006>

For nAtual := 1 to nTotReg
	
	IncProc("Lendo caixa de texto... Linha [ "+Alltrim(Str(nAtual))+" / "+Alltrim(Str(nTotReg))+" ]")
	
	lB1_Seek := .F.
	lObraCanc := .F.
	nQt := 1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pega da lista os dados                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OldObra	:= ""
	cProduto	:= UPPER(Alltrim(aProdutos[nAtual]))
	nQuant		:= Val(Alltrim(aQtdes[nAtual]))
	
	If lPreco
		nPreco 	 := Val(Alltrim(StrTran(StrTran(aPrecos[nAtual],".",""),",",".")))
		nDesconto:= 0
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Procura por codigo o produto                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek(xFilial("SB1")+cProduto)
		lB1_Seek := .T.
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se o codigo nao foi encontrado procura por codigo de barras                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lB1_Seek
		aAreaB1	:= SB1->(GetArea())
		If Select("ISBN_OBRA") > 0
			ISBN_OBRA->(DbCloseArea())
			RestArea(aAreaB1)
		EndIf
		BeginSql Alias "ISBN_OBRA"
			SELECT B1_COD COD,B1_MSBLQL,B1_XSITOBR  FROM %Table:SB1% SB1
			WHERE SB1.B1_FILIAL = %xFilial:SB1%
			AND SB1.B1_ISBN = %Exp:cProduto%
			AND SB1.B1_XIDTPPU = %Exp:cTpPub%			
			AND SB1.%NotDel%
			ORDER BY B1_COD DESC
		EndSql
		ISBN_OBRA->(DbGoTop())
		nQt	:= 0
		lObraCanc := .F.
		While ISBN_OBRA->(!EOF())
			//If ISBN_OBRA->B1_MSBLQL <> '1' 
				nQt++
				cCod := ISBN_OBRA->COD
			//EndIf
			// //VAIDAÇÂO DE OBRA CANCELADA, ALTERANDO A DESCRIÇÃO JUNTO AO ESPELHO DO PEDIDO - 13/05/2019 - CAIO NEVES
			// ElseIf Alltrim(ISBN_OBRA->B1_XSITOBR) == '103'
			// 	lObraCanc := .T.
			// EndIf			
			ISBN_OBRA->(DbSkip())
		EndDo		
		aAreaB1	:= SB1->(GetArea())
		ISBN_OBRA->(DbClosearea())
		RestArea(aAreaB1)
		
		If nQt == 1
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek(xFilial("SB1")+cCod)
				lB1_Seek := .T.
				cProduto := Alltrim(SB1->B1_COD)
			Endif
		Else
			//MsgAlert("Encontrado mais de um registro para o ISBN "+cProduto+". Este registro será desconsiderado na importação.","Atenção")
			lB1_Seek := .F.
		Endif
	Endif
	
	If !lB1_Seek
		If nQt < 2	
			aAdd(aOcorr, "ISBN "+cProduto+" não encontrado na base de dados!")
		Else
			aAdd(aOcorr, "ISBN "+cProduto+" em duplicidade na base de dados!")
		Endif
	Else
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cleuto Lima - Loop consultoria. 18/08/2015.³
		//³                                           ³
		//³Incluida sugestão de nova edição.          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(AllTrim(SB1->B1_XSITOBR) $ cSitValidas); //.and. !lAcessPreco
		.and. Alltrim(SB1->B1_XIDTPPU) <> '15';	// 30/10/2015 - Rafael Leite - Ajuste Minha Biblioteca.
		.and. lNewEdi  
			
			//aAreaB1	:= SB1->(GetArea())
			If Select("NEW_OBRA") > 0
				NEW_OBRA->(DbCloseArea())
				RestArea(aAreaB1)
			EndIf
			
			cOldObra	:= AllTrim(SB1->B1_COD)
			cIdTpPu		:= Alltrim(SB1->B1_XIDTPPU)
			cIsbn		:= Alltrim(SB1->B1_ISBN)
			BeginSql Alias "NEW_OBRA"
				SELECT SB1.R_E_C_N_O_ B1RECNO FROM %Table:SB5% SB5A
				JOIN %Table:SB1% SB1
				ON SB1.B1_FILIAL = %xFilial:SB1%
				AND SB1.B1_COD = B5_COD
				AND SB1.%NotDel%
				AND sb1.B1_COD <> %Exp:cOldObra%
				AND SB1.B1_XSITOBR IN ('101','105')
				AND SB1.B1_XIDTPPU = %Exp:cIdTpPu%
				WHERE SB5A.B5_FILIAL = %xFilial:SB5%				
				AND SB5A.B5_XCODHIS = (
				SELECT SB5B.B5_XCODHIS FROM %Table:SB5% SB5B
				WHERE SB5B.B5_FILIAL = %xFilial:SB5%
				AND SB5B.B5_COD = %Exp:cOldObra%
				AND SB5B.%NotDel% )
				AND SB5A.%NotDel%
			EndSql
			NEW_OBRA->(DbGoTop())
			
			If NEW_OBRA->(!EOF())
			
			
				SB1->(DbGoTo(NEW_OBRA->B1RECNO))
				cProduto := Alltrim(SB1->B1_COD)
				cIsbn2 := Alltrim(SB1->B1_ISBN)
				cDesc := Alltrim(SB1->B1_DESC)
				Aadd(aOcorr, "Obra "+cOldObra+" / "+cIsbn+" - "+alltrim(Posicione("SB1",1,xFilial("SB1")+cOldObra,"B1_DESC"))+" substituída pela "+cProduto+" / "+cIsbn2+" - "+cDesc+".")
				
				//Ajuste para validar saldo de obra consignada 16/05/2019 - CAIO NEVES
				IF lpd3
					nsldcons :=	StaticCall(M450BRW,GetSldConsig,M->C5_CLIENTE,M->C5_LOJACLI,cOldObra)
					IF nsldcons > 0
						Aadd(aOcorr, "Obra "+cOldObra+" / "+cIsbn+" - "+alltrim(Posicione("SB1",1,xFilial("SB1")+cOldObra,"B1_DESC"))+" contém saldo consignado de "+cValToChar(nsldcons)+".")
					ENDIF
				ENDIF
				SB1->(DbGoTo(NEW_OBRA->B1RECNO)) //REPOSICIONANDO JUNTO A NOVA OBRA, POIS A FUNÇÃO POSICIONE DESPOSICIONA PARA OBRA ANTIGA.
				lB1_Seek	:= .T.
							
			Else
				//Caso não ache uma obra ativa procura se tem uma obra mais recente bloqueada. 
				//Se positivo informa na ocorrência que existe essa edição mais recente bloqueada mas não inclui no pedido. [Parreira, 17/12/2020, 51645]
				If Select("OBRA_BLOQ") > 0
					OBRA_BLOQ->(DbCloseArea())
					RestArea(aAreaB1)
				EndIf
				
				BeginSql Alias "OBRA_BLOQ"
					SELECT SB1.R_E_C_N_O_ B1RECNO FROM %Table:SB5% SB5A
					JOIN %Table:SB1% SB1
					ON SB1.B1_FILIAL = %xFilial:SB1%
					AND SB1.B1_COD = B5_COD
					AND SB1.%NotDel%
					AND SB1.B1_COD <> %Exp:cOldObra%
					AND SB1.B1_XSITOBR IN ('102')
					AND SB1.B1_XIDTPPU = %Exp:cIdTpPu%
					WHERE SB5A.B5_FILIAL = %xFilial:SB5%				
					AND SB5A.B5_XCODHIS = (
					SELECT SB5B.B5_XCODHIS FROM %Table:SB5% SB5B
					WHERE SB5B.B5_FILIAL = %xFilial:SB5%
					AND SB5B.B5_COD = %Exp:cOldObra%
					AND SB5B.%NotDel% )
					AND SB5A.%NotDel%
				EndSql
				OBRA_BLOQ->(DbGoTop())

				If OBRA_BLOQ->(!EOF())
					
					SB1->(DbGoTo(OBRA_BLOQ->B1RECNO))
					cProduto := Alltrim(SB1->B1_COD)
					cIsbn2 := Alltrim(SB1->B1_ISBN)
					cDesc := Alltrim(SB1->B1_DESC)
					Aadd(aOcorr, "Obra "+cOldObra+" / "+cIsbn+" - "+alltrim(Posicione("SB1",1,xFilial("SB1")+cOldObra,"B1_DESC"))+" seria substituída pela "+cProduto+" / "+cIsbn2+" - "+cDesc+". Porém esta obra está BLOQUEADA!")
					
					//Ajuste para validar saldo de obra consignada 16/05/2019 - CAIO NEVES
					IF lpd3
						nsldcons :=	StaticCall(M450BRW,GetSldConsig,M->C5_CLIENTE,M->C5_LOJACLI,cOldObra)
						IF nsldcons > 0
							Aadd(aOcorr, "Obra "+cOldObra+" / "+cIsbn+" - "+alltrim(Posicione("SB1",1,xFilial("SB1")+cOldObra,"B1_DESC"))+" contém saldo consignado de "+cValToChar(nsldcons)+".")
						ENDIF
					ENDIF
					SB1->(DbGoTo(OBRA_BLOQ->B1RECNO)) //REPOSICIONANDO JUNTO A NOVA OBRA, POIS A FUNÇÃO POSICIONE DESPOSICIONA PARA OBRA ANTIGA.
					lB1_Seek	:= .F.
				Else
					Aadd(aOcorr, "Obra "+cOldObra+" / "+cIsbn+" - "+alltrim(Posicione("SB1",1,xFilial("SB1")+cOldObra,"B1_DESC"))+" com situação "+alltrim(Posicione("SZ4",1,xFilial("SZ4")+SB1->B1_XSITOBR,"Z4_DESC")))
					lB1_Seek	:= .F.
				EndIf

				OBRA_BLOQ->(DbClosearea())

			EndIf
			
			//aAreaB1	:= SB1->(GetArea())
			NEW_OBRA->(DbClosearea())
			//RestArea(aAreaB1)
			
		EndIf
	EndIf
	
	If lB1_Seek
		IF Alltrim(SB1->B1_XSITOBR) == '103'
			lObraCanc := .T.
			aAdd(aOcorr, "ISBN "+cProduto+" Obra Fora de catálogo! Status CANCELADO!")
			lB1_Seek	:= .F.		
		ENDIF	
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cleuto Lima - Loop consultoria. 18/08/2015.³
	//³                                           ³
	//³Incluida validação de estoque.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lB1_Seek .AND. lVldEst
		cLocPad		:= IIF( Empty(SB1->B1_LOCPAD), "01" , SB1->B1_LOCPAD )
		cChaveB2	:= xFilial("SB2")+SB1->B1_COD+cLocPad
		SB2->(DbSetOrder(1))
		If SB2->(DbSeek(cChaveB2)) 	
		   
		   //	If !(SB2->B2_QATU >= nQuant); 
		   If !(SB2->(B2_QATU-(B2_RESERVA+B2_QEMP)) >= nQuant);
			.and. Alltrim(SB1->B1_XIDTPPU) <> '15' // 30/10/2015 - Rafael Leite - Ajuste Minha Biblioteca.  
				
			   //	If SB2->B2_QATU > 0  
			   If SB2->(B2_QATU-(B2_RESERVA+B2_QEMP)) > 0
				//	Aadd(aOcorr,"Obra "+AllTrim(SB1->B1_COD)+" / "+AllTrim(SB1->B1_ISBN)+" - "+alltrim(SB1->B1_DESC)+" atendida parcialmente. Qtd. solicitada: "+AllTrim(Str(nQuant))+" / Atendida: "+AllTrim(Str(SB2->B2_QATU)))
					Aadd(aOcorr,"Obra "+AllTrim(SB1->B1_COD)+" / "+AllTrim(SB1->B1_ISBN)+" - "+alltrim(SB1->B1_DESC)+" atendida parcialmente. Qtd. solicitada: "+AllTrim(Str(nQuant))+" / Atendida: "+AllTrim(Str(SB2->(B2_QATU-(B2_RESERVA+B2_QEMP)))))
					   //	nQuant := SB2->B2_QATU 
					   nQuant := SB2->(B2_QATU-(B2_RESERVA+B2_QEMP))
				Else
					Aadd(aOcorr,"Obra "+SB1->B1_COD+" / "+AllTrim(SB1->B1_ISBN)+" ("+AllTrim(SB1->B1_DESC)+") "+" não possui saldo em estoque.")
					lB1_Seek := .f.
				EndIf
			EndIf
		Else
			Aadd(aOcorr,"Obra não localizada no armazem "+cLocPad)
			lB1_Seek	:= .f.
		EndIf
	EndIf
		
	If lB1_Seek .AND. lVldBlq

		cSit := SB1->B1_XSITOBR//alltrim(Posicione("SB1",1,xFilial("SB1")+SB1->B1_COD,"B1_XSITOBR"))
		lBlq := Posicione("SZ4",1,xFilial("SZ4")+cSit,"Z4_MSBLQL") == "1" .OR. SB1->B1_MSBLQL == "1"
			
		If lBlq
			Aadd(aOcorr,"Obra "+SB1->B1_COD+" / "+AllTrim(SB1->B1_ISBN)+" ("+AllTrim(SB1->B1_DESC)+") "+" bloqueada.")
			lB1_Seek	:= .f.			
		EndIf
	EndIf	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o produto foi encontrado                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lB1_Seek
		
		
		//<LOOP_20150812-002>
		//cQry := "SELECT Max(B1_COD) B1_NOVO, B1_BLOQUE FROM "+RetSqlName("SB1")+" WHERE B1_FILIAL='"+xFilial("SB1")+"' AND B1_TIPO = '"+SB1->B1_TIPO+"'  AND B1_XMODELO = '"+SB1->B1_XMODELO+"' AND B1_CODINT ='"+SB1->B1_CODINT+"' AND B1_COD > '"+cProduto+"' AND D_E_L_E_T_ <> '*' GROUP BY B1_BLOQUE"
		/*
		If Select("B1") > 0
		DbSelectArea("B1")
		DbCloseArea()
		EndIf
		
		TCQUERY cQry NEW ALIAS "B1"
		
		If B1->(!Eof())
		If !Empty(B1->B1_NOVO) .AND. B1->B1_BLOQUE <> "S"
		Do Case
		Case lPerg == .T.
		If lAutEd
		cProduto := Alltrim(B1->B1_NOVO)
		Endif
		Case lPerg == .F.
		If Aviso("A V I S O  !!! - "+ Procname(), "Esse livro tem uma edição mais atual! Deseja trocar?",{"&Nao", "&Sim"}, 2, "Atencao:")==2
		lAutEd := .T.
		cProduto := Alltrim(B1->B1_NOVO)
		Else
		lAutEd := .F.
		Endif
		lPerg := .T.
		EndCase
		Endif
		EndIf
		
		DbSelectArea("B1")
		DbCloseArea()
		
		SB1->( DbSetOrder(1) )
		SB1->(DbSeek(xFilial("SB1")+cProduto))
		
		*/
		//</LOOP_20150812-002>
		
		//<LOOP_20150812-003>
		/*
		If SB1->B1_BLOQUE == "S" .and. SB1->B1_TIPO <> "PD"
		If M->C5_TABELA # GetMv("MV_XPEXPAR")
		//Ref. chamado 7492 - ver cabecalho
		Aadd(aPedBlock, {M->C5_NUM,M->C5_CLIENT, M->C5_LOJACLI, StrZero(nAtual,4), Trim(SB1->B1_CODBAR), SB1->B1_DESC, SB1->B1_EDICAO, SB1->B1_AUTOR, nQuant})
		Loop
		EndIf
		EndIf
		*/
		//</LOOP_20150812-003>
		
		//<LOOP_20150812-004>
		/*
		If !lxPD .and. SB1->B1_TIPO == "PD"
		If M->C5_TABELA # GetMv("MV_XPEXPAR")
		// Ignorar item
		Aadd(aPedBlock, { M->C5_NUM,M->C5_CLIENT, M->C5_LOJACLI,StrZero(nAtual,4), Trim(SB1->B1_CODBAR), SB1->B1_DESC, SB1->B1_EDICAO, SB1->B1_AUTOR, nQuant})
		Loop
		EndIf
		Endif
		
		If lxPD .and. SB1->B1_TIPO <> "PD"
		If M->C5_TABELA # GetMv("MV_XPEXPAR")
		// Ignorar item
		Aadd(aPedBlock, { M->C5_NUM,M->C5_CLIENT, M->C5_LOJACLI, StrZero(nAtual,4), Trim(SB1->B1_CODBAR), SB1->B1_DESC, SB1->B1_EDICAO, SB1->B1_AUTOR, nQuant})
		Loop
		EndIf
		Endif
		*/
		//</LOOP_20150812-004>
		
		If lPreco
			cTabPreco	:= IIF( UPPER(AllTrim(FUNNAME())) $ "MATA415" , M->CJ_TABELA , M->C5_TABELA )
			If DA1->(DbSeek(xFilial("DA1")+cTabPreco+SB1->B1_COD))
				If DA1->DA1_PRCVEN > nPreco
					nDesconto	:= DA1->DA1_PRCVEN-nPreco
					nPreco		:= DA1->DA1_PRCVEN
				EndIf
			EndIf
		EndIf
		
		If lPreco
			Aadd(aLinha,{cProduto,nQuant,StrZero(nAtual,8),nPreco,nDesconto})
		Else
			Aadd(aLinha,{cProduto,nQuant,StrZero(nAtual,8) })
		EndIf
	/*Else
		Aadd(aOcorr,"Obra "+cProduto+" / "+AllTrim(SB1->B1_ISBN)+" ("+AllTrim(SB1->B1_DESC)+") "+" Obra não encontrada.")*/
	Endif
	//Ajuste para validar saldo de obra consignada 16/05/2019 - CAIO NEVES
	IF lB1_Seek .AND. lpd3
		nsldcons :=	StaticCall(M450BRW,GetSldConsig,M->C5_CLIENTE,M->C5_LOJACLI,SB1->B1_COD)
	
		IF nsldcons > 0
			Aadd(aOcorr, "Obra "+Alltrim(SB1->B1_COD)+" / "+SB1->B1_ISBN+" - "+alltrim(SB1->B1_DESC)+" contém saldo consignado de "+cValToChar(nsldcons)+".")
		ENDIF
	ENDIF
Next nAtual

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³PFAT33D   º Autor ³ Alexandre Takaki   º Data ³ 30/04/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³Interface onde o usuario ira colar os dados a serem         º±±
±±º          ³importados.     							                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Editora Atlas                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User  Function GENA028D()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDlg

Local oOk

Local oMGet1
Local oMGet2
Local oMGet3

Local oSay
Local cEOL		:= Chr(13)+Chr(10)

Local cGrpA			:= ""//SuperGetMv("MV_XGRPCXT",.F.,"000046")
Local aGrpUser 		:= PswRet(1)[1,10]
Local lAcessPreco	:= .F.
Local nX

Private cMGet1	:= "" //:= CriaVar("")
Private cMGet2	:= ""//:= CriaVar("")
Private cMGet3	:= ""

Private aLinha	:= {}
Private lPerg	:= .F.
Private lAutEd 	:= .F.

If aScan(aGrpUser,{|x| x == cGrpA }) <> 0
	lAcessPreco := .T.
EndIf

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface com o usuario                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DEFINE MSDIALOG oDlg TITLE "Importa Itens" FROM 000, 000  TO 300, 600 COLORS 0, 16777215 PIXEL

@ 005, 011 SAY oSay PROMPT "Copie e cole o codigo e a quantidade ." SIZE 175, 014 OF oDlg PIXEL COLOR CLR_HRED FONT oFont
@ 020, 011 SAY oSay PROMPT "Codigo / Codigo de Barras" SIZE 175, 014 OF oDlg PIXEL  FONT oFont
@ 030, 010 GET oMGet1 VAR cMGet1 MEMO OF oDlg SIZE 088, 088 PIXEL
@ 020, 102 SAY oSay PROMPT "Quantidade" SIZE 175, 014 OF oDlg PIXEL FONT oFont
@ 030, 102 GET oMGet2 VAR cMGet2 MEMO OF oDlg SIZE 088, 088 PIXEL

If lAcessPreco
	@ 020, 200 SAY oSay PROMPT "Preço" SIZE 175, 014 OF oDlg PIXEL FONT oFont
	@ 030, 200 GET oMGet3 VAR cMGet3 MEMO OF oDlg SIZE 088, 088 PIXEL
EndIf

@ 127, 150 BUTTON oOk PROMPT "OK" SIZE 039, 016 OF oDlg PIXEL  ACTION (oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If Len(cMGet1) > 0
	
	Processa({|| LerCaixa()},"Aguarde...","Lendo caixa de texto...",.T.)
	
	lAgrupa := !lAcessPreco
	
	If lAgrupa
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Agrupa produtos duplicados                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa({||TiraRep()},"Aguarde...","Agrupando itens repetidos...",.T.)
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Preenche as linhas do pedido                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Processa({|| GravaAcols("2",lAgrupa,.T.)},"Aguarde...","Carregando Linhas...",.T.)
	
	If Len(aPedBlock) > 0
		cTexto := "Itens não incluidos no pedido!"
		cTexto += " " + cEOL
		cTexto += " " + cEOL
		
		For nX := 1 To Len(aPedBlock)
			cTexto  +=  "Item: "+aPedBlock[nX][4]+cEOL
			cTexto  +=  "Produto: "+aPedBlock[nX][5]+" - "+aPedBlock[nX][6]+" "+cEOL
			cTexto  +=  "Edição: "+aPedBlock[nX][7]+cEOL
			cTexto  +=  "Autor: "+aPedBlock[nX][8]+cEOL
			cTexto  +=  "Quantidade: "+Alltrim(Str(aPedBlock[nX][9]))+cEOL
			cTexto 	+= 	" " + cEOL
		Next nX
		
		DEFINE MSDIALOG oDlg TITLE " Intens Não Incluidos " From 3,0 to 340,617 PIXEL
		@ 05,05 GET oMemo VAR cTexto MEMO SIZE 300,145 OF oDlg PIXEL
		oMemo:bRClicked := { || AllwaysTrue( ) }
		DEFINE SBUTTON FROM 153,275 TYPE 1 ACTION oDlg:End( ) ENABLE OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTER
	Endif
	
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LerCaixa  ºAutor  ³ Alexandre Takaki   º Data ³ 30/04/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a leitura da caixa de texto                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Editora Atlas                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LerCaixa()

Local aProdutos
Local aQtdes
Local aPrecos
Local lPreco	:= .F.

Local lB1_Seek  := .F.
Local cProduto 	:= ""
Local nQuant 	:= 0
Local nPreco	:= 0
Local nTotReg	:= 0
Local nAtual	:= 0

Private lxPD	:= .F.

aProdutos	:= StrTokArr(cMGet1,CHR(13)+CHR(10))
aQtdes		:= StrTokArr(cMGet2,CHR(13)+CHR(10))
aPrecos		:= StrTokArr(cMGet3,CHR(13)+CHR(10))
lPreco		:= Len(aPrecos) > 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retira linhas em branco no final³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
while Len(aProdutos) > 1 .And. AllTrim(aProdutos[Len(aProdutos)])  = ""
	Asize(aProdutos,Len(aProdutos)-1)
EndDo

while Len(aQtdes) > 1 .And. AllTrim(aQtdes[Len(aQtdes)])  = ""
	Asize(aQtdes,Len(aQtdes)-1)
EndDo

while Len(aPrecos) > 1 .And. AllTrim(aPrecos[Len(aPrecos)])  = ""
	Asize(aPrecos,Len(aPrecos)-1)
EndDo

If Len(aProdutos) <> Len(aQtdes) .or. ( len(aPrecos) <> Len(aProdutos) .AND. lPreco)
	Aviso("ATENÇÃO","O numero de Isbns informados é diferente do numero de quantidades/Preços!"+Chr(13)+chr(10),{"&Ok"},2,"Atenção")
	return .F.
EndIf

nTotReg := Len(aProdutos)
ProcRegua(nTotReg)
lxPD := (M->C5_XTES $ "603#604%635")

For nAtual := 1 to nTotReg
	
	IncProc("Lendo caixa de texto... Linha [ "+Alltrim(Str(nAtual))+" / "+Alltrim(Str(nTotReg))+" ]")
	
	lB1_Seek := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pega da lista os dados                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cProduto := UPPER(Alltrim(aProdutos[nAtual]))
	nQuant	 := Val(Alltrim(aQtdes[nAtual]))
	
	If lPreco
		nPreco 	 := Val(Alltrim(StrTran(StrTran(aPrecos[nAtual],".",""),",",".")))
		nDesconto:= 0
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Procura por codigo o produto                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek(xFilial("SB1")+cProduto)
		lB1_Seek := .T.
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se o codigo nao foi encontrado procura por codigo de barras                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lB1_Seek
		dbSelectArea("SB1")
		DbOrderNickName("GENISBN") //ALTERAÇÃO INDICE (B1_FILIAL + B1_ISBN) - CAIO NEVES 07/05/19
		dbGoTop()
		If dbSeek(xFilial("SB1")+cProduto)
			lB1_Seek := .T.
			cProduto := Alltrim(SB1->B1_COD)
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o produto foi encontrado                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lB1_Seek
		
		cQry := "SELECT Max(B1_COD) B1_NOVO, B1_BLOQUE FROM "+RetSqlName("SB1")+" WHERE B1_FILIAL='"+xFilial("SB1")+"' AND B1_TIPO = '"+SB1->B1_TIPO+"'  AND B1_XMODELO = '"+SB1->B1_XMODELO+"' AND B1_CODINT ='"+SB1->B1_CODINT+"' AND B1_COD > '"+cProduto+"' AND D_E_L_E_T_ <> '*' GROUP BY B1_BLOQUE"
		
		If Select("B1") > 0
			DbSelectArea("B1")
			DbCloseArea()
		EndIf
		
		TCQUERY cQry NEW ALIAS "B1"
		
		If B1->(!Eof())
			If !Empty(B1->B1_NOVO) //.AND. B1->B1_BLOQUE <> "S"
				Do Case
					Case lPerg == .T.
						If lAutEd
							cProduto := Alltrim(B1->B1_NOVO)
						Endif
					Case lPerg == .F.
						If Aviso("A V I S O ! - "+ Procname(), "Esse livro tem uma edição mais atual. Deseja trocar?",{"&Nao", "&Sim"}, 2, "Atencao:")==2
							lAutEd := .T.
							cProduto := Alltrim(B1->B1_NOVO)
						Else
							lAutEd := .F.
						Endif
						lPerg := .T.
				EndCase
			Endif
		EndIf
		
		DbSelectArea("B1")
		DbCloseArea()
		
		SB1->( DbSetOrder(1) )
		SB1->(DbSeek(xFilial("SB1")+cProduto))
		
		/*
		If SB1->B1_BLOQUE == "S" .and. SB1->B1_TIPO <> "PD"
		If M->C5_TABELA # GetMv("MV_XPEXPAR")
		//Ref. chamado 7492 - ver cabecalho
		Aadd(aPedBlock, {M->C5_NUM,M->C5_CLIENT, M->C5_LOJACLI, StrZero(nAtual,4), Trim(SB1->B1_CODBAR), SB1->B1_DESC, SB1->B1_EDICAO, SB1->B1_AUTOR, nQuant})
		Loop
		EndIf
		EndIf
		*/
		
		/*
		If !lxPD .and. SB1->B1_TIPO == "PD"
		If M->C5_TABELA # GetMv("MV_XPEXPAR")
		// Ignorar item
		Aadd(aPedBlock, { M->C5_NUM,M->C5_CLIENT, M->C5_LOJACLI,StrZero(nAtual,4), Trim(SB1->B1_CODBAR), SB1->B1_DESC, SB1->B1_EDICAO, SB1->B1_AUTOR, nQuant})
		Loop
		EndIf
		Endif
		
		
		If lxPD .and. SB1->B1_TIPO <> "PD"
		If M->C5_TABELA # GetMv("MV_XPEXPAR")
		// Ignorar item
		Aadd(aPedBlock, { M->C5_NUM,M->C5_CLIENT, M->C5_LOJACLI, StrZero(nAtual,4), Trim(SB1->B1_CODBAR), SB1->B1_DESC, SB1->B1_EDICAO, SB1->B1_AUTOR, nQuant})
		Loop
		EndIf
		Endif
		*/
		If lPreco
			If DA1->(DbSeek(xFilial("DA1")+M->C5_TABELA+SB1->B1_COD))
				If DA1->DA1_PRCVEN > nPreco
					nDesconto	:= DA1->DA1_PRCVEN-nPreco
					nPreco		:= DA1->DA1_PRCVEN
				EndIf
			EndIf
		EndIf
		
		If lPreco
			Aadd(aLinha,{cProduto,nQuant,StrZero(nAtual,8),nPreco,nDesconto})
		Else
			Aadd(aLinha,{cProduto,nQuant,StrZero(nAtual,8) })
		EndIf
		
	Else
		Aviso("ATENÇÃO","O produto "+cProduto+" não foi encontrado na base de dados!",{"&Ok"},2,"Atenção")
	Endif
next nAtual

Return()

Static function MostraLog(cMsg,lConfirma)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aPosObj    	:= {}
Local aObjects   	:= {}
Local aSize      	:= MsAdvSize()

Local oDlgMsg		:= Nil
Local oBtnPanel		:= Nil
Local nWidth 		:= 50
Local oFont			:= Nil
Local oBmp			:= Nil
Local oTFont 		:= TFont():New('Courier new',,-18,.T.)

Local lRet			:= .F.

Private cCadastro	:= "Log de processamento"

Default lConfirma	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a area dos objetos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}
Aadd( aObjects, { 100, 100, .t., .t. } )

aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aSize :=  {0,0,800,800,1800,800,0}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a tela                                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Define Dialog oDlgMsg 	Title cCadastro ;
From aSize[7],00 TO aSize[6],aSize[5] ;
/*STYLE nOR(WS_VISIBLE,WS_POPUP)*/ PIXEL

oDlgMsg:lMaximized := .T.
oDlgMsg:SetColor(CLR_BLACK,CLR_WHITE)
oDlgMsg:SetFont(oFont)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Armazena as corrdenadas da tela                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMbrWidth := oDlgMsg:nWidth/2-43
nMbrHeight := oDlgMsg:nHeight/2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os paineis da telas                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@00,00 MSPANEL oBtnPanel PROMPT "" SIZE 60,25 of oDlgMsg
oBtnPanel:Align := CONTROL_ALIGN_LEFT

@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgMsg
oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define os botoes da tela                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGrpMenu	:= TGroup():New(05,05,(oBtnPanel:NCLIENTHEIGHT/2)-10,(oBtnPanel:NCLIENTWIDTH/2),"Funções",oBtnPanel,CLR_RED,,.T.)

@ 05,05 BITMAP oBmp RESNAME GetMenuBmp() OF oGrpMenu SIZE (oBtnPanel:NCLIENTWIDTH/2)-05,(oBtnPanel:NCLIENTHEIGHT/2)-15 NOBORDER PIXEL

If lConfirma
	TBrowseButton():New(075,008, OemToAnsi("Continuar")	, 	oBtnPanel, {|| lRet := .T.,oDlgMsg:End() }	, nWidth, 10,,oDlgMsg:oFont, .F., .T., .F.,, .F.,,,)
	TBrowseButton():New(090,008, OemToAnsi("Cancelar")		, 	oBtnPanel, {|| oDlgMsg:End() }	, nWidth, 10,,oDlgMsg:oFont, .F., .T., .F.,, .F.,,,)
Else
	TBrowseButton():New(075,008, OemToAnsi("Sair")			, 	oBtnPanel, {|| oDlgMsg:End() }	, nWidth, 10,,oDlgMsg:oFont, .F., .T., .F.,, .F.,,,)
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oGrpLog		:= TGroup():New(05,05,(oMainCentro:NCLIENTHEIGHT/2)-10,(oMainCentro:NCLIENTWIDTH/2)-10,"Log de processamento",oMainCentro,CLR_RED,,.T.)
oTMultiget1 := TMultiget():New(15,10,{|u|if(Pcount()>0,cMsg:=u,cMsg)}, oMainCentro,(oMainCentro:NCLIENTWIDTH/2)-30,(oMainCentro:NCLIENTHEIGHT/2)-30,,,,,,.T.)

Activate MsDialog oDlgMsg Centered

Return lRet

Static Function RefazAcols(nEvento,cTes,nPDesconto,lRefazDesconto,lRefazTabela) // Modificado - Elizeu - 21/08/2009

If "PFATA35" $ FunName()
	Return .T.
EndIf


// Bloco 001 - Retornar "True" se for executada a partir da lAuto.
If Type("l410Auto") <> "U"
	If l410Auto
		Return ( .T. )
	Endif
Endif
// Bloco 001 - Fim.

//Processa({|| PRefazAcols(nEvento,cTes,nPDesconto,lRefazDesconto) },"Atualizando itens...")
Processa({|| PRefazAcols(nEvento,cTes,nPDesconto,lRefazDesconto,lRefazTabela) },"Atualizando itens...") // Modificado - Elizeu - 21/08/2009

RETURN( .T. )

STATIC Function PRefazAcols(nEvento,cTes,nPDesconto,lRefazDesconto,lRefazTabela)

Local aArea := GetArea()
Local nPosCfo
Local nPosNfOri
Local nPosSerOri
Local nPosItmOri
Local nPosIdentB6
Local nPQtd
Local nPVrUnit
Local nPVlrItem
Local nPDesc
Local nPValDesc
Local nPTes
Local nPCfo
Local nPValAcre
Local nPPrctab
Local nPTabela // Elizeu - 21/08/2009
Local cDesconto
Local cPrcFiscal
Local cTesBonus
Local nValDesc := 0
Local nValUni := 0
Local nVlrTab := 0
Local lRet := .F.
Local nCont	:= 0
Local lAlteraFoco := .F.
Local cCfo		:= ""
Local cxTesEsp := ""//</LOOP_20150812-012>  Alltrim(GETMV("MV_XTESESP")) // Tes Especiais (Transferencia, doacao e destruicao) - Elizeu - 21/08/2009
Local cxTabEsp := ""//</LOOP_20150812-013> Alltrim(GETMV("MV_XTABESP")) // Tabela Especial "998" (Transferencia, doacao e destruicao) - Elizeu - 21/08/2009
Local nxRespDesc := 0

Local lParDescEsp := .F.//GetMv ("MV_XDESCES",,.F. ) // Elizeu - 21/01/2010
Local nxPEspDesc := 0 // Elizeu - 21/01/2010

Local cBkpTes := "" // Elizeu - 21/10/2010
Local cTesServMb	:= ""//SUPERGETMV( "MV_XTESERV", .f., "630" )
Local cTesDigital	:= ""//SUPERGETMV( "MV_F4MYLYB", .f., "639" )

Local _cCampo	:= "C5_TABELA"

Local cTesPai	:= SuperGetMv("GEN_FAT169",.f.,"") 
Local cMvCodFor := SuperGetMv("GEN_FAT168",.f.,"378803")
Local nCntFor
Local nLinha

Default nEvento := 1
Default cTes := Space( 3 )
Default	nPDesconto := 0
Default lRefazDesconto := .F. //</LOOP_20150812-016>
Default lRefazTabela := .F.  //</LOOP_20150812-017>

// Bloco 001 - Retornar "True" se for executada a partir da lAuto.
If Type("l410Auto") <> "U"
	If l410Auto
		Return ( .T. )
	Endif
Endif
// Bloco 001 - Fim.

cDesconto := If( nEvento != 2 , "1" , TkPosto(M->UA_OPERADO,"U0_DESCONT") ) 	// Desconto  1=ITEM / 2=TOTAL / 3=AMBOS / 4=NAO
cPrcFiscal:= If( nEvento != 2 , "1" , TkPosto(M->UA_OPERADO,"U0_PRECOF") ) 	// Preco fiscal bruto 1=SIM / 2=NAO

cEst028	:= GetMv("MV_ESTADO")

cTesBonus := ""//GetMv("MV_BONUSTS") // Codigo da TES usado para as regras de bonificacao

/// --- altera o foco do objeto para o ACOLS
If "UA/C5" $ ReadVar()
	lAlteraFoco := .T.
	If nEvento == 1
		oGetDad:oBrowse:SetFocus()
	ElseIf 	nEvento == 2
		oGetTlv:oBrowse:SetFocus()
	EndIf
EndIf

If nEvento == 1  // Pedido de Vendas
	xNfOri  	:="C6_NFORI"
	xSerOri 	:="C6_SERIORI"
	xItmOri 	:="C6_ITEMORI"
	xIdentB6	:="C6_IDENTB6"
	xQtd		:="C6_QTDVEN"
	xVrUnit		:="C6_PRCVEN"
	xVlrItem	:="C6_VALOR"
	xDesc		:="C6_DESCONT"
	xValDesc	:="C6_VALDESC"
	xTes		:="C6_TES"
	xCfo		:="C6_CF"
	xValAcre	:="C6_XACRFIN"
	xPrcTab		:="C6_PRUNIT"
	xTabela		:="C6_TABELA" // Elizeu - 21/08/2009
	xProduto	:="C6_PRODUTO" // Elizeu - 24/08/2009
ElseIf nEvento == 2  // TeleVendas
	xNfOri  	:=""
	xSerOri 	:=""
	xItmOri 	:=""
	xIdentB6	:=""
	xQtd		:="UB_QUANT"
	xVrUnit		:="UB_VRUNIT"
	xVlrItem	:="UB_VLRITEM"
	xDesc		:="UB_DESC"
	xValDesc	:="UB_VALDESC"
	xTes    	:="UB_TES"
	xCfo		:="UB_CF"
	xValAcre	:="UB_VALACRE"
	xPrcTab		:="UB_PRCTAB"
	xProduto	:="UB_PRODUTO" // Elizeu - 23/02/2010
	//ElseIF nEvento == 3  // Orcamento do Loja
	//ElseIF nEvento == 4  // Pre-Nota / Nota fiscal de entrada
ElseIF 	nEvento == 5  // Orcamento de Vendas
	xNfOri  	:=""
	xSerOri 	:=""
	xItmOri 	:=""
	xIdentB6	:=""
	xQtd		:="CK_QUANT"
	xVrUnit		:="CK_PRCVEN"
	xVlrItem	:="CK_VALOR"
	xDesc		:="CK_DESCONT"
	xValDesc	:="CK_VALDESC"
	xTes    	:="CK_TES"
	xCfo		:=""
	xValAcre	:=""
	xPrcTab		:="CK_PRUNIT"
Endif

nPosNfOri  	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xNfOri})
nPosSerOri 	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xSerOri})
nPosItmOri 	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xItmOri})
nPosIdentB6	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xIdentB6})
nPQtd		:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xQtd})
nPVrUnit	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xVrUnit})
nPVlrItem	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xVlrItem})
nPDesc		:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xDesc})
nPValDesc	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xValDesc})
nPTes		:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xTes})
nPCfo		:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xCfo})
nPValAcre	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xValAcre})
nPPrcTab	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xPrcTab})

If nEvento == 1
	nPTabela := Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xTabela}) // Elizeu - 21/08/2009
	nPProdut := Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xProduto}) // Elizeu - 24/08/2009
	nxPDesc := 0 // </LOOP_20150812-014> Posicione("SA1", 1, xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI, "A1_DESCPAD")
	nxPEspDesc := 0 // </LOOP_20150812-014> Posicione("SA1", 1, xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI, "A1_DESCESP")
Elseif nEvento == 2
	nPProdut := Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xProduto}) // Elizeu - 23/02/2010
Endif

If Empty(cTes)
	//MsgInfo("Nao esta Cadastrado o Tes para este Usuario")
	MessageBox("A TES não foi informada! Por favor, preencha o campo TES.","",48)
	Return(.f.)
	/*
	// Opcoes do MessageBox
	MB_OK                 0
	MB_OKCANCEL           1
	MB_YESNO              4
	MB_ICONHAND           16
	MB_ICONQUESTION       32
	MB_ICONEXCLAMATION    48
	MB_ICONASTERISK       64
	
	// Retornos possiveis do MessageBox
	IDOK                  1
	IDCANCEL              2
	IDYES                 6
	IDNO                  7
	*/
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se a TES utilizada for igual a TES de bonificacao nao calcula os acrescimos e descontos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cTes == cTesBonus)
	nPDesconto := 0
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³So pode dar desconto se o Posto de venda estiver configurado para Item ou Ambos					  	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Alltrim(cDesconto) == "2" .OR. Alltrim(cDesconto) == "4"   // Desconto = Total ou Desconto = Nao
	If npDesconto > 0
		Help( " ", 1, "NAO_DESCON")
		npDesconto := 0
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O valor de deconto (%) nao pode ser maior ou igual a 100%  			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If npDesconto >= 100
	Help( " ", 1, "DESCMAIOR2" )
	npDesconto := 0
Endif

///--- definicao do CFO

If nEvento # 5  // Diferente de Orcamento de Vendas
	ProcRegua(Len(aCols))
	
	For nLinha := 1 to len( aCols )
		
		IncProc( "Atualizando item: "+StrZero(nLinha,2))
		
		///--- inicializa conteudo dos campos caso a linha esteja DELETADA
		If (aCols[nLinha][Len(aHeader)+1])
			/*<LOOP_20150812-015>
			If ( "RATEIO" $ aCols[nLinha][GdFieldPos(xProduto,aHeader)] .And. aCols[nLinha][GdFieldPos(xTes,aHeader)] $ cTesServMb ) .or. ( "PAGEVIEWS" $ aCols[nLinha][GdFieldPos(xProduto,aHeader)] .And. aCols[nLinha][GdFieldPos(xTes,aHeader)] == cTesDigital) .or. ( "PAGEVIEWS" $ aCols[nLinha][GdFieldPos(xProduto,aHeader)] .And. aCols[nLinha][GdFieldPos(xTes,aHeader)] $ cTesServMb)
			Loop
			EndIf
			</LOOP_20150812-015>*/
			
			// Comeca pelo campo 2 para nao zerar o item do produto
			For nCntFor:=2 To Len(aHeader)
				aCOLS[nlinha][nCntFor] := CriaVar(aHeader[nCntFor,2])
			Next nCntFor
			aCols[nLinha][Len(aHeader)+1] := .T.
			Loop
		EndIf
		
		// Copia de pedido Incluir aqui a quantidade. Deny 02/12/03
		If lRefazDesconto
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Faz os calculos de desconto baseando-se no preco de tabela  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If	aCols[nLinha][nPPrcTab] > 0
				nVlrTab := aCols[nLinha][nPPrcTab] //+ ( aCols[nLinha][nPValAcre] / aCols[nLinha][nPQtd] )
			Else
				nVlrTab := aCols[nLinha][nPVrUnit]
			Endif
			
			If lParDescEsp
				If nEvento == 1
					nPDesconto := U_GFATA02( .F., M->C5_CLIENTE, M->C5_LOJACLI, .F., aCols[nLinha][nPProdut] ) // Adicionado conforme apontamento do chamado 6561 de 19/02/2010 - Elizeu - 23/02/2010
				Elseif nEvento == 2
					If Empty(M->UA_NSITE)
						nPDesconto := U_GFATA02( M->UA_PROSPEC, M->UA_CLIENTE, M->UA_LOJA, .F., aCols[nLinha][nPProdut] ) // Adicionado conforme apontamento do chamado 6561 de 19/02/2010 - Elizeu - 23/02/2010
					Endif
				Endif
			Endif
			
			aCols[nLinha][nPDesc]	:= npDesconto
			nValUni 	 			:= A410Arred(nVlrTab * (1-(npDesconto/100)), xVrUnit )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se o posto de venda do operador estiver com preco fiscal bruto = NAO  ³
			//³o valor unitario do produto sera recalculado com desconto 		     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Alltrim(cPrcFiscal) == "2"  //NAO
				aCols[nLinha][nPVrUnit] := nValUni
				aCols[nLinha][nPVlrItem]:= A410Arred(aCols[nLinha][nPQtd]*aCols[nLinha][nPVrUnit],   xVLRITEM )
				aCols[nLinha][nPValDesc]:= A410Arred(aCols[nLinha][nPQtd]*nVlrTab,xVALDESC ) - aCols[nLinha][nPVlrItem]
			Else
				aCols[nLinha][nPVlrItem]:= A410Arred(aCols[nLinha][nPQtd]*aCols[nLinha][nPVrUnit],   xVLRITEM )
				aCols[nLinha][nPValDesc]:= aCols[nLinha][nPVlrItem] - A410Arred(aCols[nLinha][nPQtd]*nValUni,   xVALDESC )
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³O desconto nao pode ser maior que o valor de Tabela		 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aCols[nLinha][nPQtd]!=0 .and. aCols[nLinha][nPValDesc] >= (aCols[nLinha][nPPrcTab]*aCols[nLinha][nPQtd]) .AND. npDesconto > 0
				Help(" ", 1, "DESCMAIOR2" )
				aCols[nLinha][nPDesc]   := 0
				aCols[nLinha][nPValDesc]:= 0
			Endif
			///--- TI1369 - Altera o valor no array fiscal
			MaFisAlt("IT_VALMERC",aCols[nLinha][nPVlrItem],nLinha)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Refaz campos de valores e descontos no caso de mudanca   ³
		//³ de TES que utilize tabela especial "998". Ou no caso de  ³
		//³ mudanca de tabela de precos.                             ³
		//³ Especifico Atlas - Elizeu - 21/08/2009.                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRefazTabela
			If nEvento == 1 // Pedido de Vendas
				//If aCols[nLinha][nPTabela] != M->C5_TABELA
				/*
				nPQtd		:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xQtd}) 	xQtd		:="C6_QTDVEN"
				nPVrUnit	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xVrUnit})	xVrUnit		:="C6_PRCVEN"
				nPVlrItem	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xVlrItem})	xVlrItem	:="C6_VALOR"
				nPDesc		:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xDesc})	xDesc		:="C6_DESCONT"
				nPValDesc	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xValDesc})	xValDesc	:="C6_VALDESC"
				nPValAcre	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xValAcre})	xValAcre	:="C6_XACRFIN"
				nPPrcTab	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xPrcTab})	xPrcTab		:="C6_PRUNIT"
				nPTabela 	:= Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == xTabela})	xTabela		:="C6_TABELA" // Elizeu - 21/08/2009
				*/
				
				nxPrUnit := 0.00
				//nxPrUnit := Posicione("DA1", 1, xFilial("DA1") + M->C5_TABELA + aCols[nLinha][nPProdut], "DA1_PRCVEN")	// Preco Praticado Na Tabela de Precos Informada
				nxPrUnit := MaTabPrVen(M->C5_TABELA, aCols[nLinha][nPProdut], aCols[nLinha][nPQtd], M->C5_CLIENTE, M->C5_LOJACLI, M->C5_MOEDA, M->C5_EMISSAO, 1 )
				
				If	nxPrUnit > 0.01 //.Or. ( nxPrUnit == 0.01 .and. M->C5_XTES == "517" )
					aCols[nLinha][nPTabela] := M->C5_TABELA
					nVlrTab := nxPrUnit + ( aCols[nLinha][nPValAcre] / aCols[nLinha][nPQtd] )
				Else
					// deletar linha e avisar
					// nVlrTab := aCols[nLinha][nPPrcTab]
					If ! ( Len(aCols) == 1 .and. Empty(aCols[nLinha,nPProdut]) )
						nVlrTab := 0
						aCols[nLinha][Len(aHeader)+1] := .T.
						Aviso("ATENÇÃO","A linha "+StrZero(nLinha,4)+" foi DELETADA, pois nao possui preco definido para o produto "+aCols[nLinha][nPProdut]+" na tabela escolhida." , {"&OK"}, 2,"Atenção")
					Endif
				Endif
				
				// C6_PRUNIT + Acrescimo Financeiro, quando houver.
				aCols[nLinha][nPPrcTab] := nVlrTab
				
				If lParDescEsp
					// Bloco Adicionado para tratamento de desconto especial na mudanca da tabela - Elizeu - 06/03/2010
					If nEvento == 1
						nPDesconto := U_GFATA02( .F., M->C5_CLIENTE, M->C5_LOJACLI, .F., aCols[nLinha][nPProdut] )
						aCols[nLinha][nPDesc] := npDesconto
					Elseif nEvento == 2
						If Empty(M->UA_NSITE)
							nPDesconto := U_GFATA02( M->UA_PROSPEC, M->UA_CLIENTE, M->UA_LOJA, .F., aCols[nLinha][nPProdut] )
							aCols[nLinha][nPDesc] := npDesconto
						Endif
					Endif
				Else
					// Verificar se o desconto da linha e diferente do desconto padrao do cliente.
					If aCols[nLinha][nPDesc] <> nxPDesc
						/*
						If Empty(M->C5_XCAMPVE) // Adicionado por Anderson Goncalves em 20/09/2011
						
						If nxRespDesc <> 3 // Se tiver definido corrigir tudo, nao perguntar mais.
						nxRespDesc := Aviso("Pergunta","O desconto do item "+StrZero(nLinha,4)+" esta com "+Str(aCols[nLinha][nPDesc],5,2)+"% diferente do pradrao do cliente que é de "+Str(nxPDesc,5,2)+"%. O que deseja fazer?" , {"&Acertar","&Ignorar","&Corr.Tudo"},1,"Atenção")
						Endif
						
						If nxRespDesc = 3 .or. nxRespDesc = 1 // Corrigir o item para o desconto padrao
						npDesconto := nxPDesc
						aCols[nLinha][nPDesc] := npDesconto
						Else
						npDesconto := aCols[nLinha][nPDesc] // Mantem o desconto do item.
						Endif
						Else
						npDesconto := aCols[nLinha][nPDesc] // Mantem o desconto do item.
						EndIf
						*/
						npDesconto := aCols[nLinha][nPDesc] // Mantem o desconto do item.
					Endif
				Endif
				
				nValUni := A410Arred(nVlrTab * (1-(npDesconto/100)), xVrUnit )
				
				// C6_PRCVEN
				aCols[nLinha][nPVrUnit] := nValUni
				
				// C6_VALOR
				aCols[nLinha][nPVlrItem]:= A410Arred(aCols[nLinha][nPQtd]*aCols[nLinha][nPVrUnit],   xVLRITEM )
				
				// C6_VALDESC
				aCols[nLinha][nPValDesc]:= A410Arred(aCols[nLinha][nPQtd]*nVlrTab,xVALDESC ) - aCols[nLinha][nPVlrItem]
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³O desconto nao pode ser maior que o valor de Tabela		 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aCols[nLinha][nPQtd]!=0 .and. aCols[nLinha][nPValDesc] >= (aCols[nLinha][nPPrcTab]*aCols[nLinha][nPQtd]) .AND. npDesconto > 0
					Help(" ", 1, "DESCMAIOR2" )
					aCols[nLinha][nPDesc]   := 0
					aCols[nLinha][nPValDesc]:= 0
				Endif
				///--- TI1369 - Altera o valor no array fiscal
				MaFisAlt("IT_VALMERC",aCols[nLinha][nPVlrItem],nLinha)
				//Endif
			Endif
		Endif
		
		If !Empty(cTes)
			
			// Adicionado devido a entrada da TES 609 de Catalogo no P.V. - Elizeu - 21/10/2010
			/* <LOOP_20150812-018>
			If Substr(aCols[nLinha,nPProdut],1,8) == "CATALOGO"
			cBkpTes := cTes
			cTes := "609"
			Endif
			</LOOP_20150812-019> */
			
			// Adicionado devido utilizacao de Produto com Papel de Grafica - Elizeu - 06/07/2011
			/* <LOOP_20150812-008>
			If U_PapGraf(aCols[nLinha,nPProdut])
			cBkpTes := cTes
			If nEvento == 1
			cTes := Posicione("SF4", 1, xFilial("SF4") + M->C5_XTES, "F4_XTSPGRA")
			If Empty(cTes)
			cTes := M->C5_XTES
			Endif
			Elseif nEvento == 2
			cTes := Posicione("SF4", 1, xFilial("SF4") + M->UA_XTES, "F4_XTSPGRA")
			If Empty(cTes)
			cTes := M->UA_XTES
			Endif
			Endif
			Endif
			</LOOP_20150812-008>*/
						
			DbSelectArea("SF4")
			DbSetOrder(1)
			DbSeek(xFilial("SF4")+cTes,.F.)
			If (nEvento == 1 .And. M->C5_TIPO $ "DB" )
				cCfo  := IIF(SA2->A2_TIPO!="X",If(SA2->A2_EST==cEst028,SF4->F4_CF,"6"+Subs(SF4->F4_CF,2,LEN(SF4->F4_CF)-1)),"7"+Subs(SF4->F4_CF,2,LEN(SF4->F4_CF)-1))
			Else
				If nEvento == 1 .And. FunName() $ "MATA410"
					Posicione("SA1", 1, xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI, "A1_EST")
				EndIF
				
				cCfo  := IIF(SA1->A1_TIPO!="X",If(SA1->A1_EST==cEst028,SF4->F4_CF,"6"+Subs(SF4->F4_CF,2,LEN(SF4->F4_CF)-1)),"7"+Subs(SF4->F4_CF,2,LEN(SF4->F4_CF)-1))
			EndIf
			
		EndIf
		
		///--- atualiza conteudo TES/CFO
		n := nLinha
		If "C6_QTDVEN" $ ReadVar()
			M->C6_QTDVEN := aCols[nLinha,GdFieldPos("C6_QTDVEN")]
			_cCampo := "C6_QTDVEN"
		EndIF
		
		If (nEvento == 1 .and. A410MultT(_cCampo)) .or. (nEvento != 1)
			///--- Altera o valor no array fiscal
			// MaFisAlt("IT_TES",cTes,nLinha)
			/*
			If nEvento == "2"
			If aCols[nLinha,nPTes] // Se for TES de Assinatura, ignorar
			//572 P/503
			//571 P/501
			Endif
			Endif
			*/
			
			If AllTrim(Posicione("SB1",1,xFilial("SB1")+aCols[nLinha,GdFieldPos("C6_PRODUTO")],"B1_PROC")) $ cMvCodFor
				If nEvento == 1
					M->C6_TES := aCols[nLinha,nPTes]
					//A410MultT()
					A410MultT("C6_TES")
					// MaFisAlt("IT_CF" ,cCfo,nLinha)
				Endif			
			Else
				aCols[nLinha,nPTes] := cTes
				If nEvento == 1
					M->C6_TES := cTES
					//A410MultT()
					A410MultT("C6_TES")
					// MaFisAlt("IT_CF" ,cCfo,nLinha)
				Endif
			EndIf
			
			aCols[nLinha,nPCfo] := cCfo
			If nEvento == 1
				M->C6_CF := cCFO
				MaFisGet("IT_CF")
			Endif
		EndIf
		
		If nEvento == 1 .And. !Empty(aCols[nLinha,nPosNfOri])
			aCols[nLinha,nPosNfOri]  :=CriaVar(xNfOri  ,.F.)
			aCols[nLinha,nPosSerOri] :=CriaVar(xSerOri ,.F.)
			aCols[nLinha,nPosItmOri] :=CriaVar(xItmOri ,.F.)
			aCols[nLinha,nPosIdentB6]:=CriaVar(xIdentB6,.F.)
		Endif
		
		// Adicionado devido a entrada da TES 609 de Catalogo no P.V. - Elizeu - 21/10/2010
		If !Empty(cTes) .and. !Empty(cBkpTes)
			cTes := cBkpTes
		Endif
	Next nLinha
Else
	dbSelectArea("TMP1")
	dbGoTop()
	While !Eof()
		TMP1->CK_TES := cTes
		DbSkip()
	EndDo
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Jogo o desconto desse item no TOTAL pois o valor do unitario nao sera recalculado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If 	nEvento == 2 .and. cPrcFiscal == "1"  // Se for PRECO FISCAL BRUTO igual a SIM
aValores[DESCONTO]:= 0
For nCont := 1 To Len(aCols)
aValores[DESCONTO] += aCols[nCont][nPValDesc]
Next nCont
Endif
*/
/// --- altera o foco do objeto para o ACOLS
If lAlteraFoco
	If nEvento == 1
		oDlg:SetFocus()
	ElseIf nEvento == 2
		oEnchTlv:SetFocus()
	EndIf
EndIf

// Dantas - 02/06/06 - Continue...
//If aCols[n, nPTes] $ "569"
//If M->C5_XTES $ "569"
//	aHeader[nPVrUnit,07] := aHeader[nPDesc,07]
//	aHeader[nPVrUnit,10] := aHeader[nPDesc,10]
//EndIf

RestArea( aArea )

Return( nil )


//LOG EM TREPORT

User Function GENA028T(_aParm1)

Local oReport
Private _aLog := _aParm1

oReport := ReportDef()
oReport:printDialog()

Return

Static Function ReportDef()

local oReport
local cTitulo := "Log de processamento"
local cPerg := ""

oReport := TReport():New('GENA028T', cTitulo, cPerg , {|oReport| PrintReport(oReport)})
oReport:SetLandScape()
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()
oSection0 := TRSection():New(oReport,"Mensagens",{""})
TRCell():New(oSection0,"LOG"  ,,"Log",,100)

Return (oReport)

Static Function PrintReport(oReport)

Local oSection0 := oReport:Section(1)
Local nx

For nx := 1 To Len(_aLog)
	oReport:IncMeter()
	oSection0:Init()
	oSection0:Cell("LOG"):SetValue(_aLog[nx])
	oSection0:PrintLine()
Next nx

oSection0:Finish()

Return()
