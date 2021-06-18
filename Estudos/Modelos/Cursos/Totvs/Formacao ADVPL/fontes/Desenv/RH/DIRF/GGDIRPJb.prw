#Include "Protheus.ch"  
#INCLUDE "TBICONN.CH"                                                                                      
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GGDIRFPJ  �Autor  �Microsiga           � Data �  02/16/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                     

User Function GGDIRPJb(cCaminho,cFilePrint,cAno,cCodRem,cResponsavel,lView,cDescRet)

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

//���������������������������������Ŀ
//�1. Fonte Pagadora Pessoa Jur�dica�
//�����������������������������������
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


//�����������������������������������������������Ŀ
//�2. PESSOA JUR�DICA BENEFICI�RIA DOS RENDIMENTOS�
//�������������������������������������������������  
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"2.PESSOA JUR�DICA FORNECEDORA DO SERVI�O",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

oprn:Box( nLinAux , nMgPgLef, (nLinAux+25) , nHorzSize, "-4" )

oPrn:SayAlign ( nLinAux		, nMgPgLef+5,"CNPJ",oArial6 ,105,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef+05,Transform(AllTrim(DIRF_TMP->RL_CPFCGC),"@R ##.###.###/####-##"),oArial11 ,100,nLinAux+25, /*RGB(107,213,201)*/ , 2, 2)

oPrn:SayAlign ( nLinAux		, nMgPgLef+105,"Nome empresarial",oArial6 ,105,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef+110,AllTrim(DIRF_TMP->RL_BENEFIC),oArial11 ,500,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

oprn:Line( nLinAux, nMgPgLef+100, (nLinAux+25), nMgPgLef+100, , "-4" )

nLinAux+=25

//����������������������������������������������������������������������������Ŀ
//�3. RENDIMENTO E IMPOSTO RETIDO NA FONTE                                     �
//������������������������������������������������������������������������������
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"3.RELA��O DE PAGAMENTOS E RETEN��ES",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12
nBkpAux	:= nLinAux 

nTamCol	:= (nHorzSize-nMgPgLef)/4

nCol1 := nMgPgLef
nCol2 := nTamCol
nCol3 := nTamCol*2
nCol4 := nTamCol*3

oprn:Box( nLinAux , nMgPgLef, nLinAux+21 , nHorzSize, "-4" )

oPrn:SayAlign ( nLinAux	, nCol1,"M�S DO PAGAMENTO"			,oArial10N ,nTamCol-nMgPgLef,10, /*RGB(107,213,201)*/ , 2, 0)
oPrn:SayAlign ( nLinAux	, nCol2,"C�DIGO DA RETEN��O"		,oArial10N ,nTamCol,10, /*RGB(107,213,201)*/ , 2, 0)
oPrn:SayAlign ( nLinAux	, nCol3,"VALOR PAGO"				,oArial10N ,nTamCol,10, /*RGB(107,213,201)*/ , 2, 0)
oPrn:SayAlign ( nLinAux	, nCol4,"VALOR RETIDO"		  		,oArial10N ,nTamCol,10, /*RGB(107,213,201)*/ , 2, 0)

nLinAux+=21

DIRF_PJ->(DbGoTop())

DIRF_PJ->(DbSeek(DIRF_TMP->RL_CPFCGC))

While DIRF_PJ->(!EOF()) .AND. DIRF_PJ->RL_MAT == DIRF_TMP->RL_MAT .AND. DIRF_PJ->RL_CPFCGC == DIRF_TMP->RL_CPFCGC

	If DIRF_PJ->R4_ANO <> DIRF_TMP->R4_ANO
		DIRF_PJ->(DbSkip())
		Loop
	EndIf
	
	oprn:Box( nLinAux , nMgPgLef, nLinAux+10 , nHorzSize, "-4" )
	
	oPrn:SayAlign ( nLinAux	, nCol1,Left(MesExtenso(Val(DIRF_PJ->R4_MES)),3)				,oCalibB10 ,nTamCol-nMgPgLef,10, /*RGB(107,213,201)*/ , 2, 0)
	oPrn:SayAlign ( nLinAux	, nCol2,cCodRem									   				,oCalibB10 ,nTamCol,10, /*RGB(107,213,201)*/ , 2, 0)	
	oPrn:SayAlign ( nLinAux	, nCol3,Transform(DIRF_PJ->B_3_1,PesqPict("SR4","R4_VALOR"))	,oCalibB10 ,nTamCol-5,10, /*RGB(107,213,201)*/ , 1, 2)
	oPrn:SayAlign ( nLinAux	, nCol4,Transform(DIRF_PJ->B_3_5,PesqPict("SR4","R4_VALOR"))	,oCalibB10 ,nTamCol+10,10, /*RGB(107,213,201)*/ , 1, 2)
	
	nLinAux+=10
	
	DIRF_PJ->(DbSkip())
EndDo

oprn:Line( nBkpAux, nCol2, nLinAux , nCol2, , "-4" )
oprn:Line( nBkpAux, nCol3, nLinAux , nCol3, , "-4" )
oprn:Line( nBkpAux, nCol4, nLinAux , nCol4, , "-4" )


//�����������������������������Ŀ
//�7. Informa��es Complementares�
//�������������������������������
ImpComplento(cAno,cResponsavel,.F.,nLinAux)

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
oPrn:SayAlign ( nLinAux+27	, nMgPgLef+10,"Secretaria da Receita Federal do Brasil",oArial12 ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)

oPrn:SayAlign ( nLinAux+5	, (nHorzSize/2),"COMPROVANTE ANUAL DE RETEN��O DE CSLL,",oArial12 ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+20	, (nHorzSize/2),"Cofins e PIS/Pasep (Lei n� 10.833, de 2003, art. 30)",oArial12 ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)
oPrn:SayAlign ( nLinAux+43	, (nHorzSize/2),"Ano-calend�rio de "+cAno,oArial11IN ,nHorzSize/2,nWhBox, /*RGB(107,213,201)*/ , 2, 1)

IF !File("c:\windows\temp\LogoReceita.png")
	WFForceDir("c:\windows\temp\")
	__CopyFile("\workflow\html\imagens\LogoReceita.png","c:\windows\temp\LogoReceita.png")
EndIF

oPrn:SayBitmap(nLinAux+05,nMgPgLef+10, "c:\windows\temp\LogoReceita.png",45.5,49, )

oprn:Line( nLinAux+40, nHorzSize/2 , nLinAux+40, nHorzSize , , "-4" )
oprn:Line( nLinAux, nHorzSize/2, (nLinAux+60), nHorzSize/2, , "-4" )

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

//�������������������������������
//�7. Informa��es Complementares�
//�������������������������������
nLinAux+=5
oPrn:SayAlign ( nLinAux	, nMgPgLef,"4.INFORMA��ES COMPLEMENTARES",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

nBkpLine	:= nLinAux 
/*
If lComple
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"Os rendimentos seguintes est�o informados na linha 01, quadro 3 e/ou linha 03, quadro 05:",oCalibB11 ,nHorzSize,nLinAux+10,nil, 0, 2)
	nLinAux+=10
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5," - Rendimentos do trabalho assalariado: R$ "+AllTrim(Transform(DIRF_TMP->B_3_1,PesqPict("SR4","R4_VALOR"))),oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
	nLinAux+=10
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5," - Participa��o nos Lucros ou Resultados (PLR): R$ "+AllTrim(Transform(DIRF_TMP->PLR,PesqPict("SR4","R4_VALOR"))),oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
	nLinAux+=10
EndIF
*/
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
/*
If lComple
	nLinAux+=10
	oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"O Total informado na linha 03 do Quadro 5 j� inclui o valor total pago a t�tulo de PLR",oCalibB11 ,nHorzSize,nLinAux+10, nil , 0, 2)
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
oPrn:SayAlign ( nLinAux	, nMgPgLef,"5.RESPONS�VEL PELAS INFORMA��ES",oArial11 ,nHorzSize-20,nLinAux+20, /*RGB(107,213,201)*/ , 0, 1)
nLinAux+=12

oprn:Box( nLinAux , nMgPgLef, (nLinAux+25) , nHorzSize, "-4" )
oPrn:SayAlign ( nLinAux		, nMgPgLef+5,"Nome",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nMgPgLef+5,cResponsavel,oArial11 ,nHorzSize,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

oprn:Box( nLinAux , nHorzSize-250, (nLinAux+25) , nHorzSize-150, "-4" )
oPrn:SayAlign ( nLinAux		, nHorzSize-245,"Data",oArial6	,nHorzSize-150,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)
oPrn:SayAlign ( nLinAux+10	, nHorzSize-250,DtoC(DDataBase)	,oArial11 ,100,nLinAux+25, /*RGB(107,213,201)*/ , 2, 2)

oPrn:SayAlign ( nLinAux		, nHorzSize-145,"Assinatura",oArial6 ,nMgPgLef+80,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

nLinAux+=25

oPrn:SayAlign ( nLinAux	, nMgPgLef+5,"Aprov ado pela IN/SRF n� 119/2000",oArial11 ,nHorzSize,nLinAux+25, /*RGB(107,213,201)*/ , 0, 2)

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