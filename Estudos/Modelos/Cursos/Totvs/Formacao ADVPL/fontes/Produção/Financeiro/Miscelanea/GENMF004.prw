#include "rwmake.ch"
#include "protheus.ch"

#DEFINE cEnt	Chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF004  บAutor  ณCLEUTO LIMA         บ Data ณ  11/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENMF004(cDeNSU,cAteNSU,cOperadora,dDeDtCred,dAtDtCred,nFiltCon,cDeParcela,cAtParcela,lPergunta,nRecZZ9)

Local cPerg 	:= "GENMF004"
Local cAliTmp	:= ""

Local aDados		:= {}
Local oDados		:= nil
Local aPosObj    	:= {} 
Local aObjects   	:= {}                        
Local aSize      	:= MsAdvSize() 
Local aInfo			:= {}

Local bConfirm		:= {|| oDlgCre:End() }
Local bCancel		:= {|| oDlgCre:End() }
Local aButtons		:= {}

Local oDlgCre		:= Nil
Local nWidth 		:= 50
Local oFont			:= Nil
Local oBmp			:= Nil
Local oTFont 		:= TFont():New('Courier new',,-18,.T.)
Local lRet			:= .F.
Local lBitmap		:= .T. 
Local nLenPixel		:= 0
Local cCadastro		:= "Registros Concilia็ใo Cartใo de Credito"

Local nMbrWidth		:= 0
Local nMbrHeight	:= 0

Local aAlter		:= {}

Local aHeadZZ9		:= {}
Local aColsZZ9		:= {}
Local aLinMod		:= {} 
Local aHeadAux		:= {}

Local nFreeze		:= 0
Local nUsado		:= 0
Local aVirtual		:= {}
Local aVisual		:= {}
Local aNotFields	:= {"ZZ9_FILIAL"}
Local lAllFields	:= .F.
Local lNotVirtual	:= .F.
Local uGhostBmpCol	:= .F.
Local lOnlyNotFields:= .F.
Local lChkX3Uso		:= .T.
Local lChkNivel		:= .F.
Local lNumGhostCol	:= .F.
Local lCposUser		:= .F.

Private oVerme		:= LoadBitMap(GetResources(),"BR_VERMELHO")
Private oVerde		:= LoadBitMap(GetResources(),"BR_VERDE")
Private oAmar		:= LoadBitMap(GetResources(),"BR_AMARELO")

Default lPergunta	:= .T.
Default cDeNSU		:= CriaVar("E1_DOCTEF",.F.)
Default cAteNSU		:= CriaVar("E1_DOCTEF",.F.)
Default cOperadora	:= CriaVar("ZZ9_OPERA",.F.)
Default dDeDtCred	:= CtoD("  /  /  ")
Default dAtDtCred	:= CtoD("  /  /  ")
Default nFiltCon	:= 2
Default cDeParcela	:= ""
Default cAtParcela	:= ""
Default nRecZZ9		:= 0

AjustSX1(cPerg)

If lPergunta
	If !Pergunte(cPerg,lPergunta)
		Return nil
	EndIf
Else
	Pergunte(cPerg,lPergunta)	
EndIF

If lPergunta
	
	cDeNSU		:= MV_PAR01
	cAteNSU		:= MV_PAR02
	cOperadora	:= MV_PAR03
	dDeDtCred	:= MV_PAR04
	dAtDtCred	:= MV_PAR05
	nFiltCon	:= MV_PAR06
	cDeParcela	:= MV_PAR07
	cAtParcela	:= MV_PAR08
	
EndIf

//Para montar o aHeader
aHeadAux	:= GdMontaHeader( @nUsado               ,;     //01 -> Por Referencia contera o numero de campos em Uso
                              @aVirtual          ,;     //02 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Virtuais
                              @aVisual               ,;     //03 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Visuais
                              "ZZ9"               ,;     //04 -> Opcional, Alias do Arquivo Para Montagem do aHeader
                              aNotFields          ,;     //05 -> Opcional, Campos que nao Deverao constar no aHeader
                              lAllFields          ,;     //06 -> Opcional, Carregar Todos os Campos
                              lNotVirtual      ,;     //07 -> Nao Carrega os Campos Virtuais
                              uGhostBmpCol     ,;     //08 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
                              lOnlyNotFields     ,;     //09 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
                              lChkX3Uso          ,;     //10 -> Verifica se Deve Checar se o campo eh usado
                              lChkNivel          ,;     //11 -> Verifica se Deve Checar o nivel do usuario
                              lNumGhostCol     ,;     //12 -> Utiliza Numeracao na GhostCol
                              lCposUser           )     //13 -> Carrega os Campos de Usuario 

Aadd(aHeadZZ9, {  "Conciliado",;
	"X_BMP",;
	"@BMP",;
	2,;
	0,;
	/*SX3->X3_VALID*/,;
	/*SX3->X3_USADO*/,;
	"C",;
	/*SX3->X3_ARQUIVO*/,;
	/*SX3->X3_CONTEXT*/ })

Aadd(aHeadZZ9, {  "Situa็ใo",;
	"Z_BMP",;
	"@BMP",;
	2,;
	0,;
	/*SX3->X3_VALID*/,;
	/*SX3->X3_USADO*/,;
	"C",;
	/*SX3->X3_ARQUIVO*/,;
	/*SX3->X3_CONTEXT*/ })

aHeadAux[GdFieldPos( "ZZ9_MSG",	aHeadAux )][8]	:= "C"
aHeadAux[GdFieldPos( "ZZ9_MSG",	aHeadAux )][4]	:= 250
	
aEval(aHeadAux, {|x| Aadd(aHeadZZ9,aClone(x)) } )

//Para remontar o aCols com os valores padr๕es
aLinMod	:= GdRmkaCols(     aHeadZZ9           ,;     //Array com a Estrutura para criacao do aCols
                              .F.          ,;     //Estado do Elemento de Delecao no aCols
                              .T.          ,;     //Se existe o Elemento de Delecao
                              .F.           )[1]     //Se deve carregar os inicializadores padroes
                              	                                                            
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ         
//ณDefine a area dos objetos                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aObjects := {} 
Aadd( aObjects, { 100, 100, .t., .t. } )

aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 

If aSize[3] == 0
	aSize :=  {0,0,800,800,1800,800,0}
EndIf	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta a tela                                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Define Dialog oDlgCre 	Title cCadastro ;
					From aSize[7],00 TO aSize[6],aSize[5] ;
					 /*STYLE nOR(WS_VISIBLE,WS_POPUP)*/ PIXEL
					
oDlgCre:lMaximized := .T.
oDlgCre:SetColor(CLR_BLACK,CLR_WHITE)
oDlgCre:SetFont(oFont)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณArmazena as corrdenadas da tela                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nMbrWidth	:= oDlgCre:nWidth/2-43
nMbrHeight	:= oDlgCre:nHeight/2
			
@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgCre
oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT

oGrpXML		:= TGroup():New(05,05,(oMainCentro:NCLIENTHEIGHT/2)-40,(oMainCentro:NCLIENTWIDTH/2)-10,"Registros concilia็๕a cartใo de credito",oMainCentro,CLR_RED,,.T.)

oDados := MsNewGetDados():New( 15,10,(oMainCentro:NCLIENTHEIGHT/2)-45,(oMainCentro:NCLIENTWIDTH/2)-15, /*GD_INSERT+*/GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlter,nFreeze, 999, "AllwaysTrue", "", "AllwaysTrue", oMainCentro, aHeadZZ9, aColsZZ9)
oDados:oBrowse:bLDblClick := {|| EditaAux(aLinMod,cAliTmp,cDeNSU,cAteNSU,cOperadora,dDeDtCred,dAtDtCred,nFiltCon,aHeadZZ9, @oDados,@aColsZZ9,cDeParcela,cAtParcela,nRecZZ9) }

Processa({|| SqlAux(aLinMod,cAliTmp,cDeNSU,cAteNSU,cOperadora,dDeDtCred,dAtDtCred,nFiltCon,aHeadZZ9, @oDados,@aColsZZ9,cDeParcela,cAtParcela,nRecZZ9)	},"Consultando dados...")

AADD(aButtons, {"cargaseq",	{|| GENMF04C(aLinMod,cAliTmp,@cDeNSU,@cAteNSU,@cOperadora,@dDeDtCred,@dAtDtCred,@nFiltCon,aHeadZZ9, @oDados,@aColsZZ9,cDeParcela,cAtParcela,nRecZZ9)	}	, "Parametros"})
AADD(aButtons, {"cargaseq",	{|| ExportGrid(oDados)	}	, "Excel"})

Activate MsDialog oDlgCre On Init EnchoiceBar(oDlgCre,bConfirm,bCancel,,aButtons) Centered
//execblock("GENMF004") 
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF004  บAutor  ณMicrosiga           บ Data ณ  11/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustSX1(cPerg)

PutSx1(cPerg,"01","De NSU"				,"","","mv_ch1" ,"C",TamSX3("E1_DOCTEF")[1],0,0,"G","","","","","mv_par01" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"02","At้ NSU"				,"","","mv_ch2" ,"C",TamSX3("E1_DOCTEF")[1],0,0,"G","","","","","mv_par02" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"03","Operadora"			,"","","mv_ch3" ,"C",TamSX3("ZZ9_OPERA")[1],0,0,"G","","SX5ZW","","","mv_par03" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"04","De Dt.Cr้dito"		,"","","mv_ch4" ,"D",08,0,0,"G","","","","","mv_par04" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"05","At้ Dt.Cr้dito"		,"","","mv_ch5" ,"D",08,0,0,"G","","","","","mv_par05" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"06","Filtra Conciliados"	,"","","mv_ch6" ,"N",01,0,2,"C","","","","","mv_par06","Sim","Yes","Si", "","Nใo","No","No", "", "", "", "", "", "", "", "", "", "", "", "", "")
PutSx1(cPerg,"07","De Parcela"			,"","","mv_ch7" ,"C",TamSX3("E1_PARCELA")[1],0,0,"G","","","","","mv_par07" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"08","At้ Parcela"			,"","","mv_ch8" ,"C",TamSX3("E1_PARCELA")[1],0,0,"G","","","","","mv_par08" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")

Return nil    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF004  บAutor  ณMicrosiga           บ Data ณ  11/17/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SqlAux(aLinMod,cAliTmp,cDeNSU,cAteNSU,cOperadora,dDeDtCred,dAtDtCred,nFiltCon,aHeadZZ9, oDados,aColsZZ9,cDeParcela,cAtParcela,nRecZZ9)

Local cSqlTmp	:= ""
Local nLinAux	:= 0
Local cAliTmp	:= GetNExtAlias()

oDados:aCols	:= {}

cSqlTmp += " SELECT "+cEnt
cSqlTmp += " ZZ9_FILIAL, "+cEnt
cSqlTmp += " ZZ9_TIPO, "+cEnt
cSqlTmp += " ZZ9_NUMSEQ, "+cEnt
cSqlTmp += " ZZ9_NUMEST, "+cEnt
cSqlTmp += " ZZ9_NOMEES, "+cEnt
cSqlTmp += " ZZ9_NUMLOT, "+cEnt
cSqlTmp += " ZZ9_PARCEL, "+cEnt
cSqlTmp += " ZZ9_PLANO, "+cEnt
cSqlTmp += " ZZ9_NSU, "+cEnt
cSqlTmp += " ZZ9_AUTORI, "+cEnt
cSqlTmp += " ZZ9_CARTAO, "+cEnt
cSqlTmp += " ZZ9_DTVEND, "+cEnt
cSqlTmp += " ZZ9_DTCRED, "+cEnt
cSqlTmp += " ZZ9_VALBRU, "+cEnt
cSqlTmp += " ZZ9_TXADM, "+cEnt
cSqlTmp += " ZZ9_TXANTE, "+cEnt
cSqlTmp += " ZZ9_LIGPAG, "+cEnt
cSqlTmp += " ZZ9_NUMANT, "+cEnt
cSqlTmp += " ZZ9_TPEXP, "+cEnt
cSqlTmp += " ZZ9_STATUS, "+cEnt
cSqlTmp += " ZZ9_PRODUT, "+cEnt
cSqlTmp += " ZZ9_OPERA, "+cEnt
cSqlTmp += " ZZ9_BANCO, "+cEnt
cSqlTmp += " ZZ9_AGENCI, "+cEnt
cSqlTmp += " ZZ9_CONTA, "+cEnt
cSqlTmp += " ZZ9_IDCONC, "+cEnt
cSqlTmp += " ZZ9_DESAJU, "+cEnt
cSqlTmp += " ZZ9_DATA, "+cEnt
cSqlTmp += " ZZ9_HORA, "+cEnt
cSqlTmp += " ZZ9_ARQUIV, "+cEnt
cSqlTmp += " ZZ9_LINHA, "+cEnt
cSqlTmp += " ZZ9_CONCIL, "+cEnt
cSqlTmp += " ZZ9_SITUAC, "+cEnt 

cSqlTmp += " ZZ9_STXADM, "+cEnt 
cSqlTmp += " ZZ9_SALDO, "+cEnt 

cSqlTmp += " trim(utl_raw.cast_to_varchar2(ZZ9_MSG)) ZZ9_MSG, "+cEnt
cSqlTmp += " ZZ9.R_E_C_N_O_ RECZZ9 "+cEnt
cSqlTmp += " FROM "+RetSqlName("ZZ9")+" ZZ9 "+cEnt
cSqlTmp += " WHERE ZZ9_FILIAL = '"+xFilial("ZZ9")+"' "+cEnt
If nRecZZ9 <> 0
	cSqlTmp += " AND ZZ9.R_E_C_N_O_ = "+AllTrim(Str(nRecZZ9))+" "+cEnt	
Else
	cSqlTmp += " AND ZZ9_NSU BETWEEN '"+cDeNSU+"' AND '"+cAteNSU+"' "+cEnt
	cSqlTmp += " AND ZZ9_PARCEL BETWEEN '"+cDeParcela+"' AND '"+cAtParcela+"' "+cEnt
	cSqlTmp += " AND ZZ9_DTCRED BETWEEN '"+DtoS(dDeDtCred)+"' AND '"+DtoS(dAtDtCred)+"' "+cEnt
	If nFiltCon == 1
		cSqlTmp += " AND ZZ9.ZZ9_CONCIL NOT IN ('1') "+cEnt
	EndIf
	If !Empty(cOperadora)
		cSqlTmp += " AND ZZ9.ZZ9_OPERA = '"+cOperadora+"' "+cEnt	
	EndIf
EndIf

cSqlTmp += " AND ZZ9.D_E_L_E_T_ <> '*' "+cEnt

If Select(cAliTmp) > 0
	dbSelectArea(cAliTmp)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cSqlTmp), cAliTmp, .F., .T.)

TCSetFiEld(cAliTmp,"ZZ9_DTVEND","D",8,0)
TCSetFiEld(cAliTmp,"ZZ9_DTCRED","D",8,0) 
TCSetFiEld(cAliTmp,"ZZ9_DATA","D",8,0) 

(cAliTmp)->(DbGoTop())

While (cAliTmp)->(!EOF())
	
	Aadd(oDados:aCols, aClone(aLinMod) )
	nLinAux := Len(oDados:aCols)
	
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_TIPO",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_TIPO
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_NUMSEQ",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_NUMSEQ
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_NUMEST",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_NUMEST
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_NOMEES",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_NOMEES
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_NUMLOT",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_NUMLOT
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_PARCEL",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_PARCEL
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_PLANO",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_PLANO
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_NSU",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_NSU
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_AUTORI",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_AUTORI
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_CARTAO",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_CARTAO
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_DTVEND",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_DTVEND
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_DTCRED",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_DTCRED
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_VALBRU",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_VALBRU
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_TXADM",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_TXADM
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_TXANTE",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_TXANTE
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_LIGPAG",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_LIGPAG
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_NUMANT",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_NUMANT
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_TPEXP",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_TPEXP
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_STATUS",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_STATUS
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_PRODUT",	aHeadZZ9 )]	:= Posicione("SX5",1,xFilial("SX5")+"ZY"+(cAliTmp)->ZZ9_PRODUT,"X5_DESCRI")//(cAliTmp)->ZZ9_PRODUT
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_OPERA",	aHeadZZ9 )]	:= Posicione("SX5",1,xFilial("SX5")+"ZW"+(cAliTmp)->ZZ9_OPERA,"X5_DESCRI")//(cAliTmp)->ZZ9_OPERA
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_BANCO",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_BANCO
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_AGENCI",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_AGENCI
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_CONTA",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_CONTA
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_IDCONC",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_IDCONC
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_DESAJU",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_DESAJU
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_DATA",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_DATA
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_HORA",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_HORA
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_ARQUIV",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_ARQUIV
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_LINHA",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_LINHA
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_CONCIL",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_CONCIL
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_SITUAC",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_SITUAC
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_MSG",	aHeadZZ9 )]	:= Alltrim((cAliTmp)->ZZ9_MSG)

	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_STXADM",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_STXADM
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_SALDO",	aHeadZZ9 )]	:= (cAliTmp)->ZZ9_SALDO

	
	oDados:aCols[nLinAux][GdFieldPos( "X_BMP",	aHeadZZ9 )]		:= IIF( (cAliTmp)->ZZ9_CONCIL == "1" , oVerde , oVerme )

	Do Case
		Case (cAliTmp)->ZZ9_SITUAC == "1"//1=Nao validado;2=Consistente;3=Inconsistente
			oDados:aCols[nLinAux][GdFieldPos( "Z_BMP",	aHeadZZ9 )]	:= oAmar
		Case (cAliTmp)->ZZ9_SITUAC == "2"//1=Nao validado;2=Consistente;3=Inconsistente
			oDados:aCols[nLinAux][GdFieldPos( "Z_BMP",	aHeadZZ9 )]	:= oVerde
		Case (cAliTmp)->ZZ9_SITUAC == "3"//1=Nao validado;2=Consistente;3=Inconsistente
			oDados:aCols[nLinAux][GdFieldPos( "Z_BMP",	aHeadZZ9 )]	:= oVerme
		OtherWise
			oDados:aCols[nLinAux][GdFieldPos( "Z_BMP",	aHeadZZ9 )]	:= oAmar
	EndCase
	
	oDados:aCols[nLinAux][GdFieldPos( "ZZ9_REC_WT",	aHeadZZ9 )]	:= (cAliTmp)->RECZZ9
	
	(cAliTmp)->(DbSkip())
EndDo

aColsZZ9 := oDados:aCols

oDados:ForceRefresh()

Return nil  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF004  บAutor  ณMicrosiga           บ Data ณ  11/17/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EditaAux(aLinMod,cAliTmp,cDeNSU,cAteNSU,cOperadora,dDeDtCred,dAtDtCred,nFiltCon,aHeadZZ9, oDados,aColsZZ9,cDeParcela,cAtParcela,nRecZZ9)

Local nPosAux	:= oDados:oBrowse:nAt
Local aAcho 	:= {"ZZ9_TIPO","ZZ9_NUMSEQ","ZZ9_NUMEST","ZZ9_NOMEES","ZZ9_NUMLOT","ZZ9_PARCEL","ZZ9_PLANO","ZZ9_NSU","ZZ9_AUTORI","ZZ9_CARTAO","ZZ9_DTVEND","ZZ9_DTCRED","ZZ9_VALBRU","ZZ9_TXADM","ZZ9_TXANTE","ZZ9_LIGPAG","ZZ9_NUMANT","ZZ9_TPEXP","ZZ9_STATUS","ZZ9_PRODUT","ZZ9_OPERA","ZZ9_BANCO","ZZ9_AGENCI","ZZ9_CONTA","ZZ9_IDCONC","ZZ9_DESAJU","ZZ9_DATA","ZZ9_HORA","ZZ9_ARQUIV","ZZ9_LINHA","ZZ9_CONCIL","ZZ9_SITUAC","ZZ9_MSG"}
Local aCpos		:= {"ZZ9_PARCEL","ZZ9_NSU","ZZ9_AUTORI","ZZ9_DTVEND","ZZ9_DTCRED","ZZ9_VALBRU","ZZ9_TXADM","ZZ9_TXANTE","ZZ9_LIGPAG","ZZ9_STATUS","ZZ9_CONCIL","ZZ9_SITUAC"}
Local aButtons	:= {}
Local nRet		:= 0
Local nValLig	:= 0
Local cTmpZZ9	:= GetNextAlias()
Local cSituac	:= "2"
Local cMsg		:= ""
Local cNatCart	:= GetMv("GENI018CAR") //NATUREZA PARA CARTAO DE CREDITO
Local cConsil	:= ""  
Local cSitBkp	:= ""

Local lConManual	:= .F.

Private CCADASTRO	:= "Editar"
		
ZZ9->(DbGoTo(oDados:aCols[nPosAux][GdFieldPos( "ZZ9_REC_WT",aHeadZZ9 )]))
cSitBkp	:= ZZ9->ZZ9_SITUAC

nRet := AxAltera( "ZZ9", oDados:aCols[nPosAux][GdFieldPos( "ZZ9_REC_WT",aHeadZZ9 )] , 4 , aAcho , aCpos , nil , nil , "(U_GENMF04B())" , nil , nil , aButtons, nil , nil , nil , .F. )

If nRet == 0
	Return nil
EndIf

//nValLig := ZZ9->ZZ9_LIGPAG
nValLig := (ZZ9->ZZ9_LIGPAG+ZZ9->ZZ9_STXADM)

If cSitBkp <> ZZ9->ZZ9_SITUAC
	If ZZ9->ZZ9_SITUAC == "2"
		lConManual	:= .T.
	EndIf	
EndIf

cConsil	:= ZZ9->ZZ9_CONCIL
If 	ZZ9->ZZ9_TIPO == "11" // pagamento
	U_GENMF04D(cTmpZZ9,ZZ9->ZZ9_NSU,ZZ9->ZZ9_PARCEL,nValLig,ZZ9->ZZ9_DTCRED,@cSituac,@cMsg,ZZ9->ZZ9_TIPO,@cConsil,ZZ9->ZZ9_OPERA,ZZ9->ZZ9_TXADM,ZZ9->ZZ9_VALBRUT,ZZ9->ZZ9_PRODUT,ZZ9->ZZ9_DTVEND,lConManual)
ElseIf 	ZZ9->ZZ9_TIPO == "12" // estorno
	U_GENMF04E(cTmpZZ9,ZZ9->ZZ9_NSU,ZZ9->ZZ9_PARCEL,nValLig,ZZ9->ZZ9_DTCRED,@cSituac,@cMsg,ZZ9->ZZ9_TIPO,@cConsil,ZZ9->ZZ9_OPERA,ZZ9->ZZ9_TXADM,ZZ9->ZZ9_VALBRUT,ZZ9->ZZ9_PRODUT)
EndIf

Reclock("ZZ9",.F.)
ZZ9->ZZ9_SITUAC	:= cSituac//1=Nao validado;2=Consistente;3=Inconsistente
ZZ9->ZZ9_MSG	:= cMsg
ZZ9->ZZ9_CONCIL	:= cConsil
MsUnLock()

Processa({|| SqlAux(aLinMod,cAliTmp,cDeNSU,cAteNSU,cOperadora,dDeDtCred,dAtDtCred,nFiltCon,aHeadZZ9, @oDados,@aColsZZ9,cDeParcela,cAtParcela,nRecZZ9)	},"Consultando dados...")

(cTmpZZ9)->(DbcloseArea())

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF004  บAutor  ณMicrosiga           บ Data ณ  12/13/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GENMF04D(cTmpAlias,cNsu,cNumParc,nValLiq,dDtCred,cSituac,cMsg,cTipo,cConsil,cOpera,nValTxAdm,nValBrut,cIDProdut,dDtVend,lConManual)

Local aArea		:= GetArea()
Local cNatCart	:= GetMv("GENI018CAR") //NATUREZA PARA CARTAO DE CREDITO
Local nMgMais	:= 2
Local nMgMenos	:= -2
Local nValDif	:= 0
Local nMgVenc	:= SuperGetMv("GEN_FIN004",.F.,4)
Local nTxAdm	:= 0
Local cAuxParc	:= PadR("A",TamSX3("E1_PARCELA")[1])
Local nAuxParc	:= 1

Local nLimDifTax	:= SuperGetMv("GEN_FIN003",.F.,0)

Local cQuery    := ""
		
Default cSituac	:= "2"
Default cMsg	:= ""
Default cConsil	:= "2"
Default lConManual	:= .F.

/*
If Select(cTmpAlias) > 0
	(cTmpAlias)->(DbCloseArea())
EndIf


BeginSql Alias cTmpAlias
	
	SELECT E1_PARCELA,E1_TIPO,SUM(E1_SALDO) E1_SALDO,SUM(E1_VALOR) E1_VALOR,E1_VENCREA,MIN(E1_EMISSAO) E1_EMISSAO,COUNT(*) QTD 
	FROM %Table:SE1% SE1
	WHERE E1_TIPO = 'NF'
	AND TO_NUMBER(TRIM(E1_DOCTEF)) = %Exp:val(AllTrim(cNsu))%
	AND NVL(TRIM(E1_PARCELA),'A') = %Exp:AllTrim(cNumParc)%
	AND E1_NATUREZ = %Exp:cNatCart%
	AND E1_DOCTEF <> ' '  	
	AND SE1.%NotDel%
	GROUP BY E1_PARCELA,E1_TIPO,E1_VENCREA
	
EndSql

(cTmpAlias)->(DbGoTop())*/

cQuery := "SELECT E1_PARCELA,E1_TIPO,SUM(E1_SALDO) E1_SALDO,SUM(E1_VALOR) E1_VALOR,E1_VENCREA,MIN(E1_EMISSAO) E1_EMISSAO,COUNT(*) QTD "+CRLF 
cQuery += "FROM "+RetSqlName("SE1")+" SE1 "+CRLF
cQuery += "WHERE E1_TIPO = 'NF' "+CRLF
cQuery += "AND TO_NUMBER(nvl(TRIM( regexp_replace( regexp_replace(regexp_replace(TRIM(E1_DOCTEF),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)) = "+ALLTRIM(STR(VAL(ALLTRIM(cNsu))))+" "+CRLF
cQuery += "AND NVL(TRIM(E1_PARCELA),'A') = '"+AllTrim(cNumParc)+"' "+CRLF
cQuery += "AND E1_NATUREZ = '"+cNatCart+"' "+CRLF
cQuery += "AND E1_DOCTEF <> ' ' "+CRLF
cQuery += "AND SE1.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "GROUP BY E1_PARCELA,E1_TIPO,E1_VENCREA "+CRLF

MemoWrite("GENMF004_TMP1.sql",cQuery)
			
If Select("TMP1") > 0
	TMP1->(DbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP1", .F., .T.)

DbSelectArea("TMP1")

TMP1->(DbGoTop())

//nValDif := (ZZ9->ZZ9_LIGPAG+ZZ9->ZZ9_STXADM) - TMP1->E1_SALDO
nValDif := nValLiq - TMP1->E1_SALDO

//SAE->(DbSetOrder(1))
SAE->(DbOrderNickName("IDOPERA"))

Do Case
	
	Case TMP1->(EOF())
		
		If Select("BUSCA_DEL") > 0
			BUSCA_DEL->(DbCloseArea())
		EndIf
		
		// verifico se a nota fiscal foi cancelada
		
		/*BeginSql Alias "BUSCA_DEL"
			
			SELECT E1_PARCELA,E1_TIPO,SUM(E1_SALDO) E1_SALDO,SUM(E1_VALOR) E1_VALOR,E1_BAIXA,E1_VENCREA,COUNT(*) QTD 
			FROM %Table:SE1% SE1
			JOIN %Table:SF2% SF2
			ON F2_FILIAL = E1_FILIAL
			AND F2_DUPL = E1_NUM
			AND F2_PREFIXO = E1_PREFIXO
			AND F2_CLIENTE = E1_CLIENTE
			AND F2_LOJA = E1_LOJA
			AND SF2.D_E_L_E_T_ = '*'						
			WHERE E1_TIPO = 'NF'
			AND TO_NUMBER(TRIM(E1_DOCTEF)) = %Exp:val(AllTrim(cNsu))%
			AND NVL(TRIM(E1_PARCELA),'A') = %Exp:AllTrim(cNumParc)%
			AND E1_NATUREZ = %Exp:cNatCart%
			AND SE1.D_E_L_E_T_ = '*'                           
			AND E1_DOCTEF <> ' '    
			GROUP BY E1_PARCELA,E1_TIPO,E1_BAIXA,E1_VENCREA
			
		EndSql	*/
		
		cQuery := "SELECT E1_PARCELA,E1_TIPO,SUM(E1_SALDO) E1_SALDO,SUM(E1_VALOR) E1_VALOR,E1_BAIXA,E1_VENCREA,COUNT(*) QTD "+CRLF 
		cQuery += "FROM "+RetSqlName("SE1")+" SE1 "+CRLF
		cQuery += "JOIN "+RetSqlName("SF2")+" SF2 "+CRLF
		cQuery += "ON F2_FILIAL = E1_FILIAL "+CRLF
		cQuery += "AND F2_DUPL = E1_NUM "+CRLF
		cQuery += "AND F2_PREFIXO = E1_PREFIXO "+CRLF
		cQuery += "AND F2_CLIENTE = E1_CLIENTE "+CRLF
		cQuery += "AND F2_LOJA = E1_LOJA "+CRLF
		cQuery += "AND SF2.D_E_L_E_T_ = '*' "+CRLF
		cQuery += "WHERE E1_TIPO = 'NF' "+CRLF
		cQuery += "AND TO_NUMBER(nvl(TRIM( regexp_replace( regexp_replace(regexp_replace(TRIM(E1_DOCTEF),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)) = "+ALLTRIM(STR(VAL(ALLTRIM(cNsu))))+" "+CRLF
		cQuery += "AND NVL(TRIM(E1_PARCELA),'A') = '"+AllTrim(cNumParc)+"' "+CRLF
		cQuery += "AND E1_NATUREZ = '"+cNatCart+"' "+CRLF
		cQuery += "AND SE1.D_E_L_E_T_ = '*' "+CRLF
		cQuery += "AND E1_DOCTEF <> ' ' "+CRLF
		cQuery += "GROUP BY E1_PARCELA,E1_TIPO,E1_BAIXA,E1_VENCREA "+CRLF

		MemoWrite("GENMF004_BUSCA_DEL.sql",cQuery)
					
		If Select("BUSCA_DEL") > 0
			BUSCA_DEL->(DbCloseArea())
		EndIf
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"BUSCA_DEL", .F., .T.)
		
		DbSelectArea("BUSCA_DEL")
		
		BUSCA_DEL->(DbGoTop())
		
		IF BUSCA_DEL->(EOF())
			cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
			cMsg	:= "Nใo localizado titulo com os dados de NSU e parcela informados!" 
		Else 
			cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
			cMsg	:= "Nota fiscal cancelada!"
			cConsil	:= "1"
		EndIf
		
		BUSCA_DEL->(DbCloseArea())
		
	Case TMP1->E1_SALDO == 0

		cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
		cMsg	:= "Nใo existe saldo em aberto para o titulo!" 

	Case nValDif < nMgMenos .OR. nValDif > nMgMais

		cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
		cMsg	:= "Valor liquido informado no arquivo divergente do saldo do titulo, Saldo titulo: R$ "+AllTrim(transform(TMP1->E1_SALDO, "@E 999,999,999.99"))+", Valor arquivo: R$ "+AllTrim(transform(nValLiq, "@E 999,999,999.99"))+"." 

/*	Case StoD(TMP1->E1_VENCREA) <> dDtCred

		cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
		cMsg	:= "Vencimento informado no arquivo divergente do vencimento do titulo, Venc.Titulo: "+DtoC(StoD(TMP1->E1_VENCREA))+", Venc.Arquivo: "+DtoC(dDtCred)+"."
  */		
	Case dDtCred < StoD(TMP1->E1_EMISSAO)

		cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
		cMsg	:= "Vencimento informado no arquivo ้ menor que a emissใo do titulo, Emissใo Titulo: "+DtoC(StoD(TMP1->E1_EMISSAO))+", Venc.Arquivo: "+DtoC(dDtCred)+"."
    
    Case DateDiffDay(dDtCred, StoD(TMP1->E1_VENCREA)) > nMgVenc .AND. dDtCred > StoD(TMP1->E1_VENCREA)

		cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
		cMsg	:= "Diferen็a entre vencimento informado no arquivo e vencimento do titulo ้ superior a margem aceitแvel, Venc.Titulo: "+DtoC(StoD(TMP1->E1_VENCREA))+", Venc.Arquivo: "+DtoC(dDtCred)+"."
	
	Case !SAE->(DbSeek( xFilial("SAE")+cOpera ))

		cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
		cMsg	:= "Operadora nใo localizada para o c๓digo "+cOpera+"."
		
	Case Empty(SAE->AE_XCODIGO) .OR. Empty(SAE->AE_XAGENCI) .OR. Empty(SAE->AE_XCONTA)
	
		cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
		cMsg	:= "Dados bancarios nใo informados para Operadora "+cOpera+"."	

	OtherWise
	
		cSituac	:= "2"
		cMsg	:= ""
EndCase			

If cSituac == "2"
	
	IF !SAE->(DbSeek( xFilial("SAE")+cOpera+cIDProdut ))
		SAE->(DbSeek( xFilial("SAE")+cOpera+CriaVar("AE_XIDOPER",.F.) ))
	EndIf
	
    MEN->(DbsetOrder(2))
	If !MEN->(DbSeek( xFilial("MEN") + SAE->AE_COD ))
		
		cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
		cMsg	:= "Faixa de taxa administrativa nใo informada para Operadora "+cOpera+"."			
		
	Else
	    
		If Select("INFO_PAR") > 0
			INFO_PAR->(DbCloseArea())
		EndIf
	    
		/*BeginSql Alias "INFO_PAR" 
			
			SELECT MAX(CV_XPARCEL) CV_XPARCEL FROM %Table:SCV% SCV  
			WHERE TO_NUMBER(TRIM(SCV.CV_XNSUTEF)) = %Exp:VAL(ALLTRIM(cNsu))%
			AND SCV.%NotDel%
			
		EndSql*/
	
		cQuery := "SELECT MAX(CV_XPARCEL) CV_XPARCEL "+CRLF 
		cQuery += "	FROM "+RetSqlName("SCV")+" SCV "+CRLF
		cQuery += "	WHERE TO_NUMBER(nvl(TRIM( regexp_replace( regexp_replace(regexp_replace(TRIM(SCV.CV_XNSUTEF),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)) = "+ALLTRIM(STR(VAL(ALLTRIM(cNsu))))+" "+CRLF
		cQuery += "	AND SCV.D_E_L_E_T_ = ' ' "+CRLF
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"INFO_PAR", .F., .T.)
		
		DbSelectArea("INFO_PAR")
		
		INFO_PAR->(DbGoTop())		
		
		cAuxParc	:= "A" //PadR("A",TamSX3("E1_PARCELA")[1])
		nAuxParc	:= 1
		
		While AllTrim(cAuxParc) < AllTrim(INFO_PAR->CV_XPARCEL)
			cAuxParc	:= Soma1(cAuxParc)
			nAuxParc++
		EndDo		
		
		cAuxParc	:= PadR(cAuxParc,TamSX3("E1_PARCELA")[1])
		
	    While MEN->MEN_FILIAL == SAE->AE_FILIAL .AND. MEN->MEN_CODADM == SAE->AE_COD
	    	/*
	    	If !( StoD(TMP1->E1_EMISSAO) >= MEN->MEN_DATINI .AND. StoD(TMP1->E1_EMISSAO) <= MEN->MEN_DATFIM )
	    		MEN->(Dbskip())
	    		Loop
	    	EndIf	    	
	    	*/
	    	If !( dDtVend >= MEN->MEN_DATINI .AND. dDtVend <= MEN->MEN_DATFIM )
	    		MEN->(Dbskip())
	    		Loop
	    	EndIf	    	
	    	
	    	If nAuxParc <= MEN->MEN_PARFIN
	    		nTxAdm := MEN->MEN_TAXADM//MEN->MEN_TAXJUR
	    		Exit
	    	EndIf
	    	
	    	MEN->(Dbskip())
	    EndDo
		
		If nTxAdm == 0
			If !lConManual
				cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
				cMsg	:= "Faixa de taxa administrativa nใo informada para Operadora "+cOpera+"."			
			Else
				cSituac	:= "2"//1=Nao validado;2=Consistente;3=Inconsistente
				cMsg	:= "( Conciliado manualmente ) - Faixa de taxa administrativa nใo informada para Operadora "+cOpera+"."								
			EndIf	
		ElseIf Round(nValBrut*(nTxAdm/100),2) < nValTxAdm
			
			If nValTxAdm-Round(nValBrut*(nTxAdm/100),2) > nLimDifTax
				If !lConManual
					cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
					cMsg	:= "Valor da taxa administrativa ้ maior que o valor que a faixa para operada "+cOpera+"."						
				Else
					cSituac	:= "2"//1=Nao validado;2=Consistente;3=Inconsistente
					cMsg	:= "( Conciliado manualmente ) - Faixa de taxa administrativa nใo informada para Operadora "+cOpera+"."								
				EndIf			
			EndIf	
			
		EndIf
		
	EndIf

EndIf

If TMP1->QTD > 1
	If !Empty(cMsg) 
		cMsg := cMsg+" | Valor do pagamento compartilho em "+StrZero(TMP1->QTD,2)+" titulos (Digital/Impresso/Curso)."
	Else
		cMsg := "Valor do pagamento compartilho em "+StrZero(TMP1->QTD,2)+" titulos (Digital/Impresso/Curso)."
	EndIf
EndIf		

RestArea(aArea)

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF004  บAutor  ณMicrosiga           บ Data ณ  12/13/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GENMF04E(cTmpAlias,cNsu,cNumParc,nValLiq,dDtCred,cSituac,cMsg,cTipo,cConsil,cOpera,nValTxAdm,nValBrut,cIDProdut)

Local aArea		:= GetArea()
Local cNatCart	:= GetMv("GENI018CAR") //NATUREZA PARA CARTAO DE CREDITO
Local nMgMais	:= 2
Local nMgMenos	:= -2
Local nValDif	:= 0

Default cSituac		:= "2"
Default cMsg		:= ""
Default cConsil		:= "2"
Default cTmpAlias	:= GetNextAlias()

If Select(cTmpAlias) > 0
	(cTmpAlias)->(DbCloseArea())
EndIf

BeginSql Alias cTmpAlias
	
	SELECT E1_PARCELA,E1_TIPO,SUM(E1_SALDO) E1_SALDO,SUM(E1_VALOR) E1_VALOR,E1_BAIXA,E1_VENCREA,COUNT(*) QTD 
	FROM %Table:SE1% SE1
	WHERE E1_TIPO = 'NF'
	AND TO_NUMBER(TRIM(E1_DOCTEF)) = %Exp:VAL(AllTrim(cNsu))%	
	AND E1_NATUREZ = %Exp:cNatCart%
	AND SE1.%NotDel%  
	AND E1_DOCTEF <> ' '
	GROUP BY E1_PARCELA,E1_TIPO,E1_BAIXA,E1_VENCREA
	
EndSql
//AND E1_PARCELA = %Exp:cNumParc%

(cTmpAlias)->(DbGoTop())

//nValDif := nValLiq - (cTmpAlias)->E1_SALDO

Do Case
	
	Case (cTmpAlias)->(EOF())
		
		If Select("BUSCA_DEL") > 0
			BUSCA_DEL->(DbCloseArea())
		EndIf
		
		// verifico se a nota fiscal foi cancelada
		
		BeginSql Alias "BUSCA_DEL"
			
			SELECT E1_TIPO,SUM(E1_SALDO) E1_SALDO,SUM(E1_VALOR) E1_VALOR,COUNT(*) QTD 
			FROM %Table:SE1% SE1
			JOIN %Table:SF2% SF2
			ON F2_FILIAL = E1_FILIAL
			AND F2_DUPL = E1_NUM
			AND F2_PREFIXO = E1_PREFIXO
			AND F2_CLIENTE = E1_CLIENTE
			AND F2_LOJA = E1_LOJA
			AND SF2.D_E_L_E_T_ = '*'			
			WHERE E1_TIPO = 'NF'
			AND TO_NUMBER(TRIM(E1_DOCTEF)) = %Exp:VAL(AllTrim(cNsu))%
			AND E1_NATUREZ = %Exp:cNatCart%
			AND SE1.D_E_L_E_T_ = '*'
			GROUP BY E1_TIPO
			
		EndSql		
		
		BUSCA_DEL->(DbGoTop())
		
		IF BUSCA_DEL->(EOF())
			cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
			cMsg	:= "Nใo localizado titulo com os dados de NSU e parcela informados!" 
		Else 
			cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
			cMsg	:= "Nota fiscal cancelada!"
			cConsil	:= "1"
		EndIf
		
		BUSCA_DEL->(DbCloseArea())
		
	Case (cTmpAlias)->(!EOF())

		// valida a existencia de nota fiscal de devolu็ใo com NCC

		If Select("BUSCA_NCC") > 0
			BUSCA_NCC->(DbCloseArea())
		EndIf
				
		BeginSql Alias "BUSCA_NCC"
			
			SELECT *
			FROM %Table:SE1% SE1
			JOIN %Table:SF2% SF2
			ON F2_FILIAL = SE1.E1_FILIAL
			AND F2_DUPL = SE1.E1_NUM
			AND F2_PREFIXO = SE1.E1_PREFIXO
			AND F2_CLIENTE = SE1.E1_CLIENTE
			AND F2_LOJA = SE1.E1_LOJA
			AND SF2.%NotDel%
			JOIN %Table:SD1% SD1
			ON D1_FILIAL = F2_FILIAL
			AND D1_NFORI = F2_DOC
			AND D1_SERIORI = F2_SERIE
			AND D1_FORNECE = F2_CLIENTE
			AND D1_LOJA = F2_LOJA
			AND SD1.%NotDel%
			JOIN %Table:SF1% SF1
			ON F1_FILIAL = D1_FILIAL
			AND F1_DOC = D1_DOC
			AND F1_SERIE = D1_SERIE
			AND F1_FORNECE = D1_FORNECE
			AND F1_LOJA = D1_LOJA
			AND SF1.%NotDel%
			JOIN %Table:SE1%  SE1B
			ON SE1B.E1_FILIAL = F1_FILIAL
			AND SE1B.E1_NUM = F1_DUPL
			AND SE1B.E1_PREFIXO = F1_PREFIXO
			AND SE1B.E1_CLIENTE = F1_FORNECE
			AND SE1B.E1_LOJA = F1_LOJA
			AND SE1B.E1_TIPO = 'NCC'
			AND SE1B.%NotDel%			
			WHERE SE1.E1_TIPO = 'NF'
			AND TO_NUMBER(TRIM(SE1.E1_DOCTEF)) = %Exp:VAL(AllTrim(cNsu))%
			AND SE1.E1_NATUREZ = %Exp:cNatCart%
			AND SE1.%NotDel%
			
		EndSql
		
		BUSCA_NCC->(DbGoTop())
		If BUSCA_NCC->(EOF())
			
			cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
			cMsg	:= "Nใo foi localizada NCC em aberto a compensar para realizar o estorno/compensa็ใo do credito!" 			
			
		Else
		
			cSituac	:= "2"//1=Nao validado;2=Consistente;3=Inconsistente
			cMsg	:= ""

		EndIf		
		
		BUSCA_NCC->(DbCloseArea())
				
	OtherWise
	
		cSituac	:= "2"
		cMsg	:= "" 
		
EndCase			

RestArea(aArea)

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF004  บAutor  ณMicrosiga           บ Data ณ  11/17/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENMF04B()

Local lRet	:= .T.

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF004  บAutor  ณMicrosiga           บ Data ณ  11/17/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function GENMF04C(aLinMod,cAliTmp,cDeNSU,cAteNSU,cOperadora,dDeDtCred,dAtDtCred,nFiltCon,aHeadZZ9, oDados,aColsZZ9,cDeParcela,cAtParcela,nRecZZ9)

Local cPerg 	:= "GENMF004"

If !Pergunte(cPerg,.T.)
	Return nil
EndIf

cDeNSU		:= MV_PAR01
cAteNSU		:= MV_PAR02
cOperadora	:= MV_PAR03
dDeDtCred	:= MV_PAR04
dAtDtCred	:= MV_PAR05
nFiltCon	:= MV_PAR06
cDeParcela	:= MV_PAR07
cAtParcela	:= MV_PAR08
	
Processa({|| SqlAux(aLinMod,cAliTmp,cDeNSU,cAteNSU,cOperadora,dDeDtCred,dAtDtCred,nFiltCon,aHeadZZ9, @oDados,@aColsZZ9,cDeParcela,cAtParcela,nRecZZ9)	},"Consultando dados...")

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF003  บAutor  ณMicrosiga           บ Data ณ  02/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function ExportGrid(oDados)

Local cSheet	:= "Concilia็ใo de Cartใo - AcesStage"
Local cTable	:= "Concilia็ใo de Cartใo - AcesStage"

Local cArquivo	:= "CONCIL_CARTAO_"+DtoS(DDataBase)+StrTran(Time(),":","")+".xls"
Local oExcel 	:= FWMSEXCEL():New()
Local cPath		:= GetTempPath() //Diretorio de gravacao de arquivos
Local lMail		:= .F.  
Local aItem		:= {}
Local nAuxHr	:= 0 
Local nAuxAc	:= 0

If !ApOleClient( 'MsExcel' )
	MsgAlert( 'MsExcel nao instalado' )
	Return
EndIf

oExcel:AddworkSheet(cSheet)
oExcel:AddTable (cSheet,cTable)

//Alinhamento da coluna ( 1-Left,2-Center,3-Right )  //Codigo de formata็ใo ( 1-General,2-Number,3-Monetแrio,4-DateTime )

For nAuxHr := 1 To Len(oDados:aHeader)
	oExcel:AddColumn(cSheet,cTable,oDados:aHeader[nAuxHr][1],IIF( oDados:aHeader[nAuxHr][8] $ "C#D" ,1,3),IIF( oDados:aHeader[nAuxHr][8] $ "C#D" ,1,3))
Next

For nAuxAc := 1 To Len(oDados:aCols)      
	aItem	:= {}
	For nAuxHr := 1 To Len(oDados:aHeader)		
		Aadd(aItem, IIF( oDados:aHeader[nAuxHr][3] == "@BMP" ,oDados:aCols[nAuxAc][nAuxHr]:CNAME,oDados:aCols[nAuxAc][nAuxHr]) )
	Next	
	oExcel:AddRow(cSheet,cTable,aClone(aItem))
Next

oExcel:Activate()
oExcel:GetXMLFile(cPath+cArquivo)

ShellExecute("Open", cPath+cArquivo, "", cPath, 1 )	
	
//oExcelApp := MsExcel():New()
//oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha
//oExcelApp:SetVisible(.T.)

FreeObj(oExcel)

Return nil   
