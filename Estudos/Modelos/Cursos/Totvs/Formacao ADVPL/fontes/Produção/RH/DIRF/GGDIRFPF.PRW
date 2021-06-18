#Include "Protheus.ch"  
#INCLUDE "TBICONN.CH"                                                                                      
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

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
                          
User Function GGDIRFPF(cCaminho,cFilePrint,cAno,cCodRem,cResponsavel,lView,cDescRet)

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

oprn:Box( nLinAux , nMgPgLef+20, (nLinAux+25) , nHorzSize-20, "-4" )
oPrn:SayAlign ( nLinAux		, nMgPgLef,"Verifique as condi็๕es e o prazo para a apresenta็ใo da Declara็ใo do Imposto sobre a Renda da Pessoa Fํsica para este",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef,"ano-calendแrio no sํtio da Secretaria da Receita Federal do Brasil na Internet, no endere็o <ww w.receita.fazenda.gov.br>.",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 2, 1)
nLinAux+=25

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ1. Fonte Pagadora Pessoa Jurํdicaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"1. Fonte Pagadora Pessoa Jurํdica",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12
oprn:Box( nLinAux , nMgPgLef, (nLinAux+25) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux		, nMgPgLef+5,"CNPJ",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef,Transform(AllTrim(DIRF_TMP->RL_CGCFONT),"@R ##.###.###/####-##"),oArial11 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 2, 2)

oprn:Line( nLinAux, nMgPgLef+100, (nLinAux+25), nMgPgLef+100, , "-4" )

oPrn:SayAlign ( nLinAux		, nMgPgLef+105,"Nome empresarial",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef+115,AllTrim(DIRF_TMP->RL_NOMFONT),oArial11 ,nHorzSize,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
nLinAux+=25

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ2. Pessoa Fํsica Beneficiแria dos Rendimentosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"2. Pessoa Fํsica Beneficiแria dos Rendimentos",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12
oprn:Box( nLinAux , nMgPgLef, (nLinAux+25) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux		, nMgPgLef+5,"CPF",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef,Transform(AllTrim(DIRF_TMP->RL_CPFCGC),"@R ###.###.###-##"),oArial11 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 2, 2)

oprn:Line( nLinAux, nMgPgLef+100, (nLinAux+25), nMgPgLef+100, , "-4" )

oPrn:SayAlign ( nLinAux		, nMgPgLef+105,"Nome empresarial",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef+115,AllTrim(DIRF_TMP->RL_BENEFIC),oArial11 ,nHorzSize,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
nLinAux+=25
oprn:Box( nLinAux , nMgPgLef, (nLinAux+25) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux		, nMgPgLef+5,"Natureza do rendimento",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef+5,cDescRet,oArial11 ,nHorzSize,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
nLinAux+=25

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ3. Rendimentos Tributแveis, Dedu็๕es e Imposto sobre a Renda Retido na Fonteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"3. Rendimentos Tributแveis, Dedu็๕es e Imposto sobre a Renda Retido na Fonte",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux	, nHorzSize-95,"Valores em reais",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

nBkpAux	:= nLinAux 
oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"1. Total dos rendimentos (inclusive f้rias)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_3_1,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)

nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"2. Contribui็ใo previdenciแria oficial",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_3_2,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15 

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"3. Contribui็๕es a entidades de previd๊ncia complementar e a fundos de aposentadoria prog. individual (Fapi)(preencher tamb้m o quadro 7)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_3_3,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"4. Pensใo alimentํcia (preencher tamb้m o quadro 7)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_3_4,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"5. Imposto sobre a renda retido na fonte",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_3_5,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Line( nBkpAux, nHorzSize-100, nLinAux, nHorzSize-100, , "-4" )


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ4. Rendimentos Isentos e Nใo Tributแveis                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"4. Rendimentos Isentos e Nใo Tributแveis",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux	, nHorzSize-95,"Valores em reais",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

nBkpAux	:= nLinAux 
oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"1. Parcela isenta dos proventos de aposentadoria, reserva remunerada, reforma e pensใo (65 anos ou mais)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_4_1,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"2. Diแrias e ajudas de custo",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_4_2,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"3. Pensใo e proventos de aposentadoria ou reforma por mol้stia grave; proventos de aposentadoria ou reforma por acidente em serv i็o",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_4_3,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"4. Lucros e dividendos, apurados a partir de 1996, pagos por pessoa jurํdica (lucro real, presumido ou arbitrado)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_4_4,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"5. Valores pagos ao titular ou s๓cio da microempresa ou empresa de pequeno porte, exceto pro labore, alugu้is ou servi็os prestados",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_4_5,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"6. Indeniza็๕es por rescisใo de contrato de trabalho, inclusive a tํtulo de PDV, e por acidente de trabalho",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_4_6,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"7. Outros (abono pecuniแrio, 1/3 abono pecuniแrio, dif A)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_4_7,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Line( nBkpAux, nHorzSize-100, nLinAux, nHorzSize-100, , "-4" )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ5. Rendimentos sujeitos เ Tributa็ใo Exclusiva (rendimento lํquido)ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"5. Rendimentos sujeitos เ Tributa็ใo Exclusiva (rendimento lํquido)",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux	, nHorzSize-95,"Valores em reais",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

nBkpAux	:= nLinAux 
oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"1. D้cimo terceiro salแrio",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_5_1,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"2. Imposto sobre a renda retido na fonte sobre 13บ salแrio",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_5_2,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"3. Outros",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_5_3,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Line( nBkpAux, nHorzSize-100, nLinAux, nHorzSize-100, , "-4" )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ6. Rendimentos Recebidos Acumuladamente - Art. 12-A da Lei nบ 7.713, de 1988 (sujeito เ tributa็ใo exclusiva)ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"6. Rendimentos Recebidos Acumuladamente - Art. 12-A da Lei nบ 7.713, de 1988 (sujeito เ tributa็ใo exclusiva)",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize-100, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"6.1 N๚mero do processo:",oArial11 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oprn:Box( nLinAux , nHorzSize-250, (nLinAux+15) , nHorzSize-160, "-4" )
oPrn:SayAlign ( nLinAux+02		, nHorzSize-248,"Quantidade de meses",oArial11 ,nHorzSize-130,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-160,AllTrim(str(DIRF_TMP->B_6_QTDM)),oArial11 ,040,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)

nLinAux+=15
oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize-100, "-4" )
oPrn:SayAlign ( nLinAux+02	, nMgPgLef+5,"Natureza do rendimento:",oArial11 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+04	, nHorzSize-95,"Valores em reais",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=15

nLinAux+=02
nBkpAux	:= nLinAux
oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"1. Total dos rendimentos tributแveis (inclusive f้rias e d้cimo terceiro salแrio)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_6_1,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"2. Exclusใo: Despesas com a a็ใo judicial",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_6_2,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"3. Dedu็ใo: Contribui็ใo previdenciแria oficial",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_6_3,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"4. Dedu็ใo: Pensใo alimentํcia (preencher tamb้m o quadro 7)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_6_4,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"5. Imposto sobre a renda retido na fonte",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_6_5,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"6. Rendimentos isentos de pensใo, proventos de aposentadoria ou reforma por mol้stia grave ou aposentadoria ou reforma por acidente em servi็o",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_6_6,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Line( nBkpAux, nHorzSize-100, nLinAux, nHorzSize-100, , "-4" )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ7. Informa็๕es Complementaresณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ImpComplento(cAno,cResponsavel)

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
oPrn:SayAlign ( nLinAux+17	, nMgPgLef+10,"Secretaria da Receita Federal do Brasil",oArial12 ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+29	, nMgPgLef+10,"Imposto sobre a Renda da Pessoa Fํsica",oArial11N ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+41	, nMgPgLef+10,"Exercํcio de "+Soma1(cAno),oArial11IN ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)

oPrn:SayAlign ( nLinAux+5	, (nHorzSize/2),"Comprovante de Rendimentos Pagos e de",oArial13 ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+20	, (nHorzSize/2),"Imposto sobre a Renda Retido na Fonte",oArial13 ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+41	, (nHorzSize/2),"Ano-calendแrio de "+cAno,oArial11IN ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)

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

Static Function ImpComplento(cAno,cResponsavel)

Local nLinAux	:= 0
Local nBkpLine	:= 0

oprn:EndPage()
oprn:StartPage()

nLinAux := ImpCabec(cAno)
nLinAux+=3

lComple := COMPLEMEN->(DbSeek(DIRF_TMP->RL_MAT))  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ7. Informa็๕es Complementaresณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"7. Informa็๕es Complementares",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

nBkpLine	:= nLinAux 
If lComple .OR. DIRF_TMP->PLR > 0
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"Os rendimentos seguintes estใo informados na linha 01, quadro 3 e/ou linha 03, quadro 05:",oCalibB11 ,nHorzSize,nLinAux+10,nil, 0, 2)
	nLinAux+=10
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5," - Rendimentos do trabalho assalariado: R$ "+AllTrim(Transform(DIRF_TMP->B_3_1,PesqPict("SR4","R4_VALOR"))),oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
	nLinAux+=10
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5," - Participa็ใo nos Lucros ou Resultados (PLR): R$ "+AllTrim(Transform(DIRF_TMP->PLR,PesqPict("SR4","R4_VALOR"))),oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
	nLinAux+=10
EndIF

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

If lComple .OR. DIRF_TMP->PLR > 0
	nLinAux+=10
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"O Total informado na linha 03 do Quadro 5 jแ inclui o valor total pago a tํtulo de PLR",oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
	nLinAux+=10
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"correspondente a R$ "+AllTrim(Transform(DIRF_TMP->PLR,PesqPict("SR4","R4_VALOR")))+".",oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
EndIF	

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
oPrn:SayAlign ( nLinAux	, nMgPgLef,"8. Responsแvel pelas informa็๕es",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

oprn:Box( nLinAux , nMgPgLef, (nLinAux+25) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux		, nMgPgLef+5,"Nome",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef+5,cResponsavel,oArial11 ,nHorzSize,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

oprn:Box( nLinAux , nHorzSize-250, (nLinAux+25) , nHorzSize-150, "-4" )
oPrn:SayAlign ( nLinAux		, nHorzSize-245,"Data",oArial6	,nHorzSize-150,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nHorzSize-250,DtoC(DDataBase)	,oArial11 ,100,nLinAux+25, /*RGB(107,213,201)*/ , 2, 2)

oPrn:SayAlign ( nLinAux		, nHorzSize-145,"Assinatura",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

nLinAux+=25

oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"Aprovado pela Instru็ใo Normativa nบ 1.522, de 05 de dezembro de 2014.",oArial11 ,nHorzSize,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

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