#Include "Protheus.ch"  
#INCLUDE "TBICONN.CH"                                                                                      
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGGDIRFPJ  บAutor  ณMicrosiga           บ Data ณ  02/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                        

User Function GGDIRFPJ(cCaminho,cFilePrint,cAno,cCodRem,cResponsavel,lView,cDescRet)

Local nMaxWdGrf		:= 0
Local nMaxHeGrf		:= 0

Local nMaxGrf		:= 200
Local nMinGrf		:= 80

Local nMaxGLin		:= 0// maximo de graficos por linha  
Local nMgGraf		:= 5 // Margem entre os graficos

Local nGfHeight		:= 0
Local nGfWidth		:= 0
Local nAreaGraf		:= 0
Local nQtdGraf		:= 4
Local nColIniAux	:= 0
Local nLinIniAux	:= 10
Local nLinAux		:= 0 

Private nPagAtu		:= 0

Private oArial6	:= TFont():New( "Arial",,6,,.F.,,,,,.F.)
Private oArial7	:= TFont():New( "Arial",,7,,.F.,,,,,.F.)
Private oArial8	:= TFont():New( "Arial",,8,,.F.,,,,,.F.)

Private oCalibB10	:= TFont():New( "Calibri (Corpo)",,10,,.F.,,,,,.F.)
Private oCalibB10N	:= TFont():New( "Calibri (Corpo)",,10,,.T.,,,,,.F.)

Private oArial10N	:= TFont():New( "Arial",,10,,.T.,,,,,.F.)

Private oCalibB11	:= TFont():New( "Calibri (Corpo)",,11,,.F.,,,,,.F.)

Private oArial11	:= TFont():New( "Arial",,11,,.F.,,,,,.F.)
Private oArial11N	:= TFont():New( "Arial",,11,,.T.,,,,,.F.)
Private oArial11IN	:= TFont():New( "Arial",,11,,.T.,,,,,.F.)
oArial11IN:Italic := .T.

Private oArial12	:= TFont():New( "Arial",,12,,.F.,,,,,.F.)
Private oArial13	:= TFont():New( "Arial",,13,,.F.,,,,,.F.)
Private oArial13N	:= TFont():New( "Arial",,13,,.T.,,,,,.F.)
Private oArial13IN	:= TFont():New( "Arial",,13,,.T.,,,,,.F.)
oArial13IN:Italic := .T.

Private oTimes12	:= TFont():New( "Times",,12,,.F.,,,,,.F.)
Private oTimes12N	:= TFont():New( "Times",,12,,.T.,,,,,.F.)


//ฺฤฤฤฤฤฤฤฟ
//ณMargensณ
//ภฤฤฤฤฤฤฤู
Private nMgPgTop	:= 30
Private nMgPgLef	:= 30
Private nVertSize	:= 0
Private nHorzSize	:= 0

Default cCaminho	:= "c:\windows\temp\"
Default cFilePrint	:= CriaTrab(nil,.F.)
Default cAno		:= "2014"
Default lView		:= .T.

lAdjustToLegacy := .F. //mantem legado de resolu็ใo com a TMSPrinter
oprn 			:= FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, cCaminho, .T.,,,,.F.)

oprn:StartPage()

// ----------------------------------------------
// Define para salvar o PDF
// ----------------------------------------------
oprn:SetPortrait()
oprn:nDevice 		:= IMP_PDF
oprn:lServer 		:= .F.                           
oprn:lViewPDF		:= lView 
oprn:cPathPDF 		:= cCaminho

nVertSize	:= (oprn:NPAGEHEIGHT/oprn:NFACTORHOR)-nMgPgTop
nHorzSize	:= (oprn:NPAGEWIDTH/oprn:NFACTORHOR)-nMgPgLef

//oprn:Box( nMgPgTop , nMgPgLef, nVertSize , nHorzSize, "2" )

nLinAux := ImpCabec(cAno)
nLinAux+=3

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ1. Fonte Pagadora Pessoa Jurํdicaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"1.FONTE PAGADORA",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

oprn:Box( nLinAux , nMgPgLef, (nLinAux+25) , nHorzSize, "-4" )

oPrn:SayAlign ( nLinAux		, nMgPgLef+5,"Nome empresarial",oArial6 ,105,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef+5,AllTrim(DIRF_TMP->RL_NOMFONT),oArial11 ,500,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

oPrn:SayAlign ( nLinAux		, nHorzSize-100,"CNPJ",oArial6 ,105,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nHorzSize-115,Transform(AllTrim(DIRF_TMP->RL_CGCFONT),"@R ##.###.###/####-##"),oArial11 ,115,nLinAux+25, /*RGB(107,213,201)*/ , 2, 2)
oprn:Line( nLinAux, nHorzSize-105, (nLinAux+25), nHorzSize-105, , "-4" )

nLinAux+=25


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ2. PESSOA JURอDICA BENEFICIมRIA DOS RENDIMENTOSณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"2.PESSOA JURอDICA BENEFICIมRIA DOS RENDIMENTOS",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

oprn:Box( nLinAux , nMgPgLef, (nLinAux+25) , nHorzSize, "-4" )

oPrn:SayAlign ( nLinAux		, nMgPgLef+5,"Nome empresarial",oArial6 ,105,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef+5,AllTrim(DIRF_TMP->RL_BENEFIC),oArial11 ,500,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

oPrn:SayAlign ( nLinAux		, nHorzSize-100,"CNPJ",oArial6 ,105,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nHorzSize-115,Transform(AllTrim(DIRF_TMP->RL_CPFCGC),"@R ##.###.###/####-##"),oArial11 ,115,nLinAux+25, /*RGB(107,213,201)*/ , 2, 2)
oprn:Line( nLinAux, nHorzSize-105, (nLinAux+25), nHorzSize-105, , "-4" )

nLinAux+=25

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ3. RENDIMENTO E IMPOSTO RETIDO NA FONTE                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"3.RENDIMENTO E IMPOSTO RETIDO NA FONTE",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12
nBkpAux	:= nLinAux 

nCol1 := nMgPgLef
nCol2 := 50
nCol3 := 100
nCol4 := 350
nCol5 := 460

oprn:Box( nLinAux , nMgPgLef, nLinAux+21 , nHorzSize, "-4" )

oPrn:SayAlign ( nLinAux+05	, nCol1,"M๊s"				   		,oArial10N ,nCol2-nMgPgLef,10, /*RGB(107,213,201)*/ , 2, 0)

oPrn:SayAlign ( nLinAux		, nCol2,"C๓digo de"	   				,oArial10N ,nCol3-nCol2,10, /*RGB(107,213,201)*/ , 2, 0)
oPrn:SayAlign ( nLinAux+10	, nCol2,"reten็ใo"			   		,oArial10N ,nCol3-nCol2,10, /*RGB(107,213,201)*/ , 2, 0)

oPrn:SayAlign ( nLinAux+05	, nCol3,"Descri็ใo do rendimento"	,oArial10N ,nCol4-nCol3,10, /*RGB(107,213,201)*/ , 2, 0)

oPrn:SayAlign ( nLinAux		, nCol4,"Rendimento"		  		,oArial10N ,nCol5-nCol4,10, /*RGB(107,213,201)*/ , 2, 0)
oPrn:SayAlign ( nLinAux+10	, nCol4,"(R$)"		   				,oArial10N ,nCol5-nCol4,10, /*RGB(107,213,201)*/ , 2, 0)

oPrn:SayAlign ( nLinAux		, nCol5,"Imposto retido"	   		,oArial10N ,100,10, /*RGB(107,213,201)*/ , 2, 0)
oPrn:SayAlign ( nLinAux+10	, nCol5,"(R$)"	   					,oArial10N ,100,10, /*RGB(107,213,201)*/ , 2, 0)

nLinAux+=21

DIRF_PJ->(DbGoTop())

DIRF_PJ->(DbSeek(DIRF_TMP->RL_CPFCGC))

While DIRF_PJ->(!EOF()) .AND. DIRF_PJ->RL_MAT == DIRF_TMP->RL_MAT .AND. DIRF_PJ->RL_CPFCGC == DIRF_TMP->RL_CPFCGC

	If DIRF_PJ->R4_ANO <> DIRF_TMP->R4_ANO
		DIRF_PJ->(DbSkip())
		Loop
	EndIf
	
	oprn:Box( nLinAux , nMgPgLef, nLinAux+10 , nHorzSize, "-4" )
	
	oPrn:SayAlign ( nLinAux	, nCol1,Left(MesExtenso(Val(DIRF_PJ->R4_MES)),3)	,oCalibB10 ,nCol2-nMgPgLef,10, /*RGB(107,213,201)*/ , 2, 0)
	oPrn:SayAlign ( nLinAux	, nCol2,cCodRem										,oCalibB10 ,nCol3-nCol2,10, /*RGB(107,213,201)*/ , 2, 0)
	oPrn:SayAlign ( nLinAux	, nCol3,cDescRet									,oCalibB10 ,nCol4-nCol3,10, /*RGB(107,213,201)*/ , 2, 0)
	
	oPrn:SayAlign ( nLinAux		, nCol4,Transform(DIRF_PJ->B_3_1,PesqPict("SR4","R4_VALOR")),oCalibB10 ,nCol5-nCol4-5,10, /*RGB(107,213,201)*/ , 1, 2)
	oPrn:SayAlign ( nLinAux		, nCol5,Transform(DIRF_PJ->B_3_5,PesqPict("SR4","R4_VALOR")),oCalibB10 ,nCol5-nCol4-10,10, /*RGB(107,213,201)*/ , 1, 2)
	
	nLinAux+=10
	
	DIRF_PJ->(DbSkip())
EndDo

oprn:Line( nBkpAux, nCol2, nLinAux , nCol2, , "-4" )
oprn:Line( nBkpAux, nCol3, nLinAux , nCol3, , "-4" )
oprn:Line( nBkpAux, nCol4, nLinAux , nCol4, , "-4" )
oprn:Line( nBkpAux, nCol5, nLinAux , nCol5, , "-4" )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ7. Informa็๕es Complementaresณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ImpComplento(cAno,cResponsavel,.F.,nLinAux)

oprn:Print()  

//FClose(oprn:NHANDLE)
FT_FUSE()
FreeObj(oprn)	
oprn := Nil

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGGDIRFPF  บAutor  ณMicrosiga           บ Data ณ  02/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpCabec(cAno)

Local nLinAux	:= nMgPgTop
Local nWhBox	:= (nLinAux+60)

oprn:Box( nLinAux , nMgPgLef, (nLinAux+60) , nHorzSize, "-4" )

//FWMsPrinter(): SayAlign ( < nRow>, < nCol>, < cText>, [ oFont], [ nWidth], [ nHeigth], [ nClrText], [ nAlignHorz], [ nAlignVert ] ) -->

oPrn:SayAlign ( nLinAux+5	, nMgPgLef+10,"Minist้rio da Fazenda",oArial13N ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+27	, nMgPgLef+10,"Secretaria da Receita Federal do Brasil",oArial12 ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)

oPrn:SayAlign ( nLinAux+5	, (nHorzSize/2),"COMPROVANTE ANUAL DE RENDIMENTOS PAGOS OU",oArial12 ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+18	, (nHorzSize/2),"CREDITADOS E DE RETENวรO DE",oArial12 ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+31	, (nHorzSize/2),"IMPOSTO DE RENDA NA FONTE - PESSOA JURอDICA",oArial12 ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+43	, (nHorzSize/2),"Ano-calendแrio de "+cAno,oArial11IN ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)

IF !File("c:\windows\temp\LogoFazenda.png")
	WFForceDir("c:\windows\temp\")
	__CopyFile("\workflow\html\imagens\LogoFazenda.png","c:\windows\temp\LogoFazenda.png")
EndIF

oPrn:SayBitmap(nLinAux+05,nMgPgLef+10, "c:\windows\temp\LogoFazenda.png",45.5,49, )

oprn:Line( nLinAux, nHorzSize/2, (nLinAux+60), nHorzSize/2, 900, "-4" )

nLinAux := nWhBox

ImpNumPg()

Return nLinAux 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGGDIRFPF  บAutor  ณMicrosiga           บ Data ณ  02/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpComplento(cAno,cResponsavel,lNewPag,nLinAux)

Local nBkpLine	:= 0

Default lNewPag	:= .F.

If lNewPag
	oprn:EndPage()
	oprn:StartPage()
	nLinAux := ImpCabec(cAno)
	nLinAux+=3		
EndIF

lComple := COMPLEMEN->(DbSeek(DIRF_TMP->RL_MAT))  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ7. Informa็๕es Complementaresณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"4.INFORMAวีES COMPLEMENTARES",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

nBkpLine	:= nLinAux 
/*
If lComple
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"Os rendimentos seguintes estใo informados na linha 01, quadro 3 e/ou linha 03, quadro 05:",oCalibB11 ,nHorzSize,nLinAux+10,nil, 0, 2)
	nLinAux+=10
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5," - Rendimentos do trabalho assalariado: R$ "+AllTrim(Transform(DIRF_TMP->B_3_1,PesqPict("SR4","R4_VALOR"))),oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
	nLinAux+=10
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5," - Participa็ใo nos Lucros ou Resultados (PLR): R$ "+AllTrim(Transform(DIRF_TMP->PLR,PesqPict("SR4","R4_VALOR"))),oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
	nLinAux+=10
EndIF
*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPagamentos a planos de sa๚de:ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//nLinAux+=5
//oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"Pagamentos a planos de sa๚de:",oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
nLinAux+=10

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณComplementos RCSณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nItemAux := "00"

While COMPLEMEN->(!EOF()) .AND. COMPLEMEN->RCS_MAT == DIRF_TMP->RL_MAT

	If nLinAux+15 > nVertSize

		/*<quadro final>*/
		nLinAux+=15
		oprn:Line( nBkpLine, nMgPgLef , nBkpLine , nHorzSize , nil, "-4" )
		oprn:Line( nLinAux, nMgPgLef , nLinAux , nHorzSize , nil, "-4" )
		
		oprn:Line( nBkpLine, nMgPgLef , nLinAux , nMgPgLef , nil, "-4" )
		oprn:Line( nBkpLine, nHorzSize , nLinAux , nHorzSize , nil, "-4" )
		/*</quadro final>*/
	
		oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"<< CONTINUA >>",oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
		oprn:EndPage()
		oprn:StartPage()
		
		nLinAux := ImpCabec(cAno)
		nLinAux+=3	
		
		oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"<< CONTINUAวรO 7. Informa็๕es Complementares >>",oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
		nLinAux+=15
		
	EndIf
		
	nItemAux	:= Soma1(nItemAux)
	
	aFrase	:= {}
	cFraAux	:= nItemAux+"."+AllTrim(COMPLEMEN->RCS_DESCRI)//StrTran(AllTrim(COMPLEMEN->RCS_DESCRI),"CPF:    .   .   -   -","")
	While !Empty(AllTrim(cFraAux))
		Aadd(aFrase, Left(cFraAux,090) )
		cFraAux := SubStr(cFraAux,091,Len(cFraAux))
	EndDo
	
	For nAuxFra := 1 To Len(aFrase)
		oPrn:SayAlign ( nLinAux	, nMgPgLef+5, aFrase[nAuxFra] ,oCalibB10 ,nHorzSize,nLinAux+10,nil, 0, 2)
		IF nAuxFra == Len(aFrase)
			oPrn:SayAlign ( nLinAux	, nHorzSize-080, "R$"+Transform(COMPLEMEN->RCS_VALOR,PesqPict("RCS","RCS_VALOR")) ,oCalibB10 ,078,nLinAux+10,nil, 1, 2)
		EndIF
		nLinAux+=10
	Next	
	
	oPrn:SayAlign ( nLinAux-04	, nMgPgLef+5, Replicate("-",292) ,oArial6 ,nHorzSize,nLinAux+10,nil, 0, 2)
	
	COMPLEMEN->(DbSkip()) 
	
EndDo
/*
If lComple
	nLinAux+=10
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"O Total informado na linha 03 do Quadro 5 jแ inclui o valor total pago a tํtulo de PLR",oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
	nLinAux+=10
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"correspondente a R$ "+AllTrim(Transform(DIRF_TMP->PLR,PesqPict("SR4","R4_VALOR")))+".",oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
EndIF	
*/
/*<quadro final>*/
nLinAux+=15
oprn:Line( nBkpLine, nMgPgLef , nBkpLine , nHorzSize , nil, "-4" )
oprn:Line( nLinAux, nMgPgLef , nLinAux , nHorzSize , nil, "-4" )

oprn:Line( nBkpLine, nMgPgLef , nLinAux , nMgPgLef , nil, "-4" )
oprn:Line( nBkpLine, nHorzSize , nLinAux , nHorzSize , nil, "-4" )
/*</quadro final>*/

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ8. Responsแvel pelas informa็๕esณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If nLinAux+50 > nVertSize
	oprn:EndPage()
	oprn:StartPage()
	
	nLinAux := ImpCabec(cAno)
	nLinAux+=3	
EndIf

nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"5.RESPONSมVEL PELAS INFORMAวีES",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

oprn:Box( nLinAux , nMgPgLef, (nLinAux+25) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux		, nMgPgLef+5,"Nome",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef+5,cResponsavel,oArial11 ,nHorzSize,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

oprn:Box( nLinAux , nHorzSize-250, (nLinAux+25) , nHorzSize-150, "-4" )
oPrn:SayAlign ( nLinAux		, nHorzSize-245,"Data",oArial6	,nHorzSize-150,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nHorzSize-250,DtoC(DDataBase)	,oArial11 ,100,nLinAux+25, /*RGB(107,213,201)*/ , 2, 2)

oPrn:SayAlign ( nLinAux		, nHorzSize-145,"Assinatura",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

nLinAux+=25

oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"Aprov ado pela IN/SRF nบ 119/2000",oArial11 ,nHorzSize,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGGDIRFPF  บAutor  ณMicrosiga           บ Data ณ  02/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function ImpNumPg()

Local nLinImp	:= oprn:NPAGEHEIGHT/oprn:NFACTORHOR

nPagAtu++

oprn:Line( nLinImp, nMgPgLef , nLinImp , nHorzSize , nil, "-4" )

oPrn:SayAlign ( nLinImp	, nHorzSize-70,"Pแg. "+AllTrim(Str(nPagAtu)),oArial11 ,nHorzSize,nLinImp+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinImp	, nMgPgLef+05,"Beneficiแrio: "+AllTrim(DIRF_TMP->RL_BENEFIC),oArial11 ,nHorzSize,nLinImp+15, /*RGB(107,213,201)*/ , 0, 2)

Return nil