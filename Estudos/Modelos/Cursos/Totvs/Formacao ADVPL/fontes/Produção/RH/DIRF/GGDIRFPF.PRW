#Include "Protheus.ch"  
#INCLUDE "TBICONN.CH"                                                                                      
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GGDIRFPF  �Autor  �Microsiga           � Data �  02/16/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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


//�������Ŀ
//�Margens�
//���������
Private nMgPgTop	:= 30
Private nMgPgLef	:= 30
Private nVertSize	:= 0
Private nHorzSize	:= 0

Default cCaminho	:= "c:\windows\temp\"
Default cFilePrint	:= CriaTrab(nil,.F.)
Default cAno		:= "2014"
Default lView		:= .T.

lAdjustToLegacy := .F. //mantem legado de resolu��o com a TMSPrinter
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
oPrn:SayAlign ( nLinAux		, nMgPgLef,"Verifique as condi��es e o prazo para a apresenta��o da Declara��o do Imposto sobre a Renda da Pessoa F�sica para este",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef,"ano-calend�rio no s�tio da Secretaria da Receita Federal do Brasil na Internet, no endere�o <ww w.receita.fazenda.gov.br>.",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 2, 1)
nLinAux+=25

//���������������������������������Ŀ
//�1. Fonte Pagadora Pessoa Jur�dica�
//�����������������������������������
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"1. Fonte Pagadora Pessoa Jur�dica",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12
oprn:Box( nLinAux , nMgPgLef, (nLinAux+25) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux		, nMgPgLef+5,"CNPJ",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef,Transform(AllTrim(DIRF_TMP->RL_CGCFONT),"@R ##.###.###/####-##"),oArial11 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 2, 2)

oprn:Line( nLinAux, nMgPgLef+100, (nLinAux+25), nMgPgLef+100, , "-4" )

oPrn:SayAlign ( nLinAux		, nMgPgLef+105,"Nome empresarial",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef+115,AllTrim(DIRF_TMP->RL_NOMFONT),oArial11 ,nHorzSize,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
nLinAux+=25

//���������������������������������������������Ŀ
//�2. Pessoa F�sica Benefici�ria dos Rendimentos�
//�����������������������������������������������
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"2. Pessoa F�sica Benefici�ria dos Rendimentos",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
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

//����������������������������������������������������������������������������Ŀ
//�3. Rendimentos Tribut�veis, Dedu��es e Imposto sobre a Renda Retido na Fonte�
//������������������������������������������������������������������������������
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"3. Rendimentos Tribut�veis, Dedu��es e Imposto sobre a Renda Retido na Fonte",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux	, nHorzSize-95,"Valores em reais",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

nBkpAux	:= nLinAux 
oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"1. Total dos rendimentos (inclusive f�rias)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_3_1,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)

nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"2. Contribui��o previdenci�ria oficial",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_3_2,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15 

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"3. Contribui��es a entidades de previd�ncia complementar e a fundos de aposentadoria prog. individual (Fapi)(preencher tamb�m o quadro 7)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_3_3,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"4. Pens�o aliment�cia (preencher tamb�m o quadro 7)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_3_4,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"5. Imposto sobre a renda retido na fonte",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_3_5,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Line( nBkpAux, nHorzSize-100, nLinAux, nHorzSize-100, , "-4" )


//����������������������������������������������������������������������������Ŀ
//�4. Rendimentos Isentos e N�o Tribut�veis                                    �
//������������������������������������������������������������������������������
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"4. Rendimentos Isentos e N�o Tribut�veis",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux	, nHorzSize-95,"Valores em reais",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

nBkpAux	:= nLinAux 
oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"1. Parcela isenta dos proventos de aposentadoria, reserva remunerada, reforma e pens�o (65 anos ou mais)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_4_1,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"2. Di�rias e ajudas de custo",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_4_2,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"3. Pens�o e proventos de aposentadoria ou reforma por mol�stia grave; proventos de aposentadoria ou reforma por acidente em serv i�o",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_4_3,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"4. Lucros e dividendos, apurados a partir de 1996, pagos por pessoa jur�dica (lucro real, presumido ou arbitrado)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_4_4,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"5. Valores pagos ao titular ou s�cio da microempresa ou empresa de pequeno porte, exceto pro labore, alugu�is ou servi�os prestados",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_4_5,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"6. Indeniza��es por rescis�o de contrato de trabalho, inclusive a t�tulo de PDV, e por acidente de trabalho",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_4_6,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"7. Outros (abono pecuni�rio, 1/3 abono pecuni�rio, dif A)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_4_7,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Line( nBkpAux, nHorzSize-100, nLinAux, nHorzSize-100, , "-4" )

//�������������������������������������������������������������������Ŀ
//�5. Rendimentos sujeitos � Tributa��o Exclusiva (rendimento l�quido)�
//���������������������������������������������������������������������

nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"5. Rendimentos sujeitos � Tributa��o Exclusiva (rendimento l�quido)",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
oPrn:SayAlign ( nLinAux	, nHorzSize-95,"Valores em reais",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

nBkpAux	:= nLinAux 
oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"1. D�cimo terceiro sal�rio",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_5_1,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"2. Imposto sobre a renda retido na fonte sobre 13� sal�rio",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_5_2,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"3. Outros",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_5_3,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Line( nBkpAux, nHorzSize-100, nLinAux, nHorzSize-100, , "-4" )

//���������������������������������������������������������������������������������������������������������������
//�6. Rendimentos Recebidos Acumuladamente - Art. 12-A da Lei n� 7.713, de 1988 (sujeito � tributa��o exclusiva)�
//���������������������������������������������������������������������������������������������������������������

nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"6. Rendimentos Recebidos Acumuladamente - Art. 12-A da Lei n� 7.713, de 1988 (sujeito � tributa��o exclusiva)",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize-100, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"6.1 N�mero do processo:",oArial11 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
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
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"1. Total dos rendimentos tribut�veis (inclusive f�rias e d�cimo terceiro sal�rio)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_6_1,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"2. Exclus�o: Despesas com a a��o judicial",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_6_2,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"3. Dedu��o: Contribui��o previdenci�ria oficial",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_6_3,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"4. Dedu��o: Pens�o aliment�cia (preencher tamb�m o quadro 7)",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_6_4,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"5. Imposto sobre a renda retido na fonte",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_6_5,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Box( nLinAux , nMgPgLef, (nLinAux+15) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux+02		, nMgPgLef+5,"6. Rendimentos isentos de pens�o, proventos de aposentadoria ou reforma por mol�stia grave ou aposentadoria ou reforma por acidente em servi�o",oArial7 ,nHorzSize,nLinAux+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+02		, nHorzSize-100,Transform(DIRF_TMP->B_6_6,PesqPict("SR4","R4_VALOR")),oArial7 ,095,nLinAux+15, /*RGB(107,213,201)*/ , 1, 2)
nLinAux+=15

oprn:Line( nBkpAux, nHorzSize-100, nLinAux, nHorzSize-100, , "-4" )

//�����������������������������Ŀ
//�7. Informa��es Complementares�
//�������������������������������
ImpComplento(cAno,cResponsavel)

oprn:Print()  

//FClose(oprn:NHANDLE)
FT_FUSE()
FreeObj(oprn)	
oprn := Nil

Return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GGDIRFPF  �Autor  �Microsiga           � Data �  02/16/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ImpCabec(cAno)

Local nLinAux	:= nMgPgTop
Local nWhBox	:= (nLinAux+60)

oprn:Box( nLinAux , nMgPgLef, (nLinAux+60) , nHorzSize, "-4" )

//FWMsPrinter(): SayAlign ( < nRow>, < nCol>, < cText>, [ oFont], [ nWidth], [ nHeigth], [ nClrText], [ nAlignHorz], [ nAlignVert ] ) -->

oPrn:SayAlign ( nLinAux+5	, nMgPgLef+10,"Minist�rio da Fazenda",oArial13N ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+17	, nMgPgLef+10,"Secretaria da Receita Federal do Brasil",oArial12 ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+29	, nMgPgLef+10,"Imposto sobre a Renda da Pessoa F�sica",oArial11N ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+41	, nMgPgLef+10,"Exerc�cio de "+Soma1(cAno),oArial11IN ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)

oPrn:SayAlign ( nLinAux+5	, (nHorzSize/2),"Comprovante de Rendimentos Pagos e de",oArial13 ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+20	, (nHorzSize/2),"Imposto sobre a Renda Retido na Fonte",oArial13 ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+41	, (nHorzSize/2),"Ano-calend�rio de "+cAno,oArial11IN ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GGDIRFPF  �Autor  �Microsiga           � Data �  02/16/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ImpComplento(cAno,cResponsavel)

Local nLinAux	:= 0
Local nBkpLine	:= 0

oprn:EndPage()
oprn:StartPage()

nLinAux := ImpCabec(cAno)
nLinAux+=3

lComple := COMPLEMEN->(DbSeek(DIRF_TMP->RL_MAT))  

//�������������������������������
//�7. Informa��es Complementares�
//�������������������������������
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"7. Informa��es Complementares",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

nBkpLine	:= nLinAux 
If lComple .OR. DIRF_TMP->PLR > 0
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"Os rendimentos seguintes est�o informados na linha 01, quadro 3 e/ou linha 03, quadro 05:",oCalibB11 ,nHorzSize,nLinAux+10,nil, 0, 2)
	nLinAux+=10
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5," - Rendimentos do trabalho assalariado: R$ "+AllTrim(Transform(DIRF_TMP->B_3_1,PesqPict("SR4","R4_VALOR"))),oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
	nLinAux+=10
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5," - Participa��o nos Lucros ou Resultados (PLR): R$ "+AllTrim(Transform(DIRF_TMP->PLR,PesqPict("SR4","R4_VALOR"))),oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
	nLinAux+=10
EndIF

//�����������������������������Ŀ
//�Pagamentos a planos de sa�de:�
//�������������������������������
//nLinAux+=5
//oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"Pagamentos a planos de sa�de:",oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
nLinAux+=10

//����������������Ŀ
//�Complementos RCS�
//������������������
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
		
		oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"<< CONTINUA��O 7. Informa��es Complementares >>",oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
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
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"O Total informado na linha 03 do Quadro 5 j� inclui o valor total pago a t�tulo de PLR",oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
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

//��������������������������������Ŀ
//�8. Respons�vel pelas informa��es�
//����������������������������������

If nLinAux+50 > nVertSize
	oprn:EndPage()
	oprn:StartPage()
	
	nLinAux := ImpCabec(cAno)
	nLinAux+=3	
EndIf

nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"8. Respons�vel pelas informa��es",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

oprn:Box( nLinAux , nMgPgLef, (nLinAux+25) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux		, nMgPgLef+5,"Nome",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef+5,cResponsavel,oArial11 ,nHorzSize,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

oprn:Box( nLinAux , nHorzSize-250, (nLinAux+25) , nHorzSize-150, "-4" )
oPrn:SayAlign ( nLinAux		, nHorzSize-245,"Data",oArial6	,nHorzSize-150,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nHorzSize-250,DtoC(DDataBase)	,oArial11 ,100,nLinAux+25, /*RGB(107,213,201)*/ , 2, 2)

oPrn:SayAlign ( nLinAux		, nHorzSize-145,"Assinatura",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

nLinAux+=25

oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"Aprovado pela Instru��o Normativa n� 1.522, de 05 de dezembro de 2014.",oArial11 ,nHorzSize,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

Return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GGDIRFPF  �Autor  �Microsiga           � Data �  02/16/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static function ImpNumPg()

Local nLinImp	:= oprn:NPAGEHEIGHT/oprn:NFACTORHOR

nPagAtu++

oprn:Line( nLinImp, nMgPgLef , nLinImp , nHorzSize , nil, "-4" )

oPrn:SayAlign ( nLinImp	, nHorzSize-70,"P�g. "+AllTrim(Str(nPagAtu)),oArial11 ,nHorzSize,nLinImp+15, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinImp	, nMgPgLef+05,"Benefici�rio: "+AllTrim(DIRF_TMP->RL_BENEFIC),oArial11 ,nHorzSize,nLinImp+15, /*RGB(107,213,201)*/ , 0, 2)

Return nil