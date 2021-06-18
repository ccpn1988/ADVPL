#include "rwmake.ch"
#include "protheus.ch"

#DEFINE cEnt	Chr(13)+chr(10) 

#DEFINE N_FNOME	01
#DEFINE N_FNUM		02
#DEFINE N_FOPERA	03
#DEFINE N_FORDEM	04

#DEFINE N_TQTDREG	01
#DEFINE N_TSALDO	02
#DEFINE N_TATRASO	03
#DEFINE N_TSLDARQ	04
#DEFINE N_TSLDTXA	05

#DEFINE N_TVALBRU	06
#DEFINE N_TVALLIQ	07
#DEFINE N_TVALTX	08

#DEFINE N_FILIAL	01
#DEFINE N_TITCON	02
#DEFINE N_NUM		03
#DEFINE N_PARCELA	04
#DEFINE N_NOMCLI	05
#DEFINE N_EMISSAO	06
#DEFINE N_VENCREA  07
#DEFINE N_VALOR    08
#DEFINE N_SALDO    09
#DEFINE N_BAIXA    10
#DEFINE N_NSU      11
#DEFINE N_VALBRU   12
#DEFINE N_LIGPAG   13
#DEFINE N_DTVEND   14
#DEFINE N_DTCRED   15
#DEFINE N_OPERA    16
#DEFINE N_ZZ9CONC  17
#DEFINE N_ZZ9INTE  18
#DEFINE N_MSG      19
#DEFINE N_OK	    20
#DEFINE N_ZZ9REC   21
#DEFINE N_VENDA 	22
#DEFINE N_PEDIDO	23
#DEFINE N_ZZ9SIT	24
#DEFINE N_TOT_PAR	25
#DEFINE N_PG_SALDO	26
#DEFINE N_SE1REC	27
#DEFINE N_STXADM	28
#DEFINE N_TXADM		29
#DEFINE N_BANDE		30
#DEFINE N_DESBA		31
#DEFINE N_LOTE		32
#DEFINE N_QTDPAR	33
#DEFINE N_CODCLI	34
#DEFINE N_LOJCLI	35
#DEFINE N_SIZE     35

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF002  บAutor  ณCLEUTO LIMA         บ Data ณ  11/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENMF003()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cPerg		:= "GENMF003"
Local aDados	:= {}
Local aQuery	:= {}
Local alog		:= {}

Local aPosObj    	:= {} 
Local aObjects   	:= {}                        
Local aSize      	:= MsAdvSize() 
Local aInfo			:= {}

Local bConfirm		:= {|| oDlgFin:End() }
Local bCancel		:= {|| oDlgFin:End() }
Local aButtons		:= {}

Local oDlgFin		:= Nil
Local nWidth 		:= 50
Local oFont			:= Nil
Local oBmp			:= Nil
Local oTFont 		:= TFont():New('Courier new',,-18,.T.)
Local lRet			:= .F.
Local lBitmap		:= .T. 
Local nLenPixel		:= 0
Local cCadastro		:= "Concilia็ใo Cartใo de Credito"

Local nMbrWidth		:= 0
Local nMbrHeight	:= 0

Private oListBox	:= nil

Private aFiltros	:= Array(4)
Private aBkpSX1		:= Array(12)
Private aTotReg		:= Array(8)

Private oVerme		:= LoadBitMap(GetResources(),"BR_VERMELHO")
Private oVerde		:= LoadBitMap(GetResources(),"BR_VERDE")
Private oAmar		:= LoadBitMap(GetResources(),"BR_AMARELO")
Private oAzul		:= LoadBitMap(GetResources(),"BR_AZUL")
Private oBranco		:= LoadBitMap(GetResources(),"BR_BRANCO")
Private oOk	  		:= LoadBitMap(GetResources(),"LBOK")
Private oNOk		:= LoadBitMap(GetResources(),"LBNO")

AjustSX1(cPerg)

If !Pergunte(cPerg,.t.)
	return nil
EndIf

aTotReg[N_TQTDREG]	:= 0
aTotReg[N_TSALDO]	:= 0
aTotReg[N_TATRASO]	:= 0 
aTotReg[N_TSLDARQ]	:= 0 
aTotReg[N_TSLDTXA]	:= 0 

aTotReg[N_TVALBRU]	:= 0 
aTotReg[N_TVALLIQ]	:= 0 
aTotReg[N_TVALTX]	:= 0 


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
Define Dialog oDlgFin 	Title cCadastro ;
					From aSize[7],00 TO aSize[6],aSize[5] ;
					 /*STYLE nOR(WS_VISIBLE,WS_POPUP)*/ PIXEL
					
oDlgFin:lMaximized := .T.
oDlgFin:SetColor(CLR_BLACK,CLR_WHITE)
oDlgFin:SetFont(oFont)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณArmazena as corrdenadas da tela                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nMbrWidth	:= oDlgFin:nWidth/2-43
nMbrHeight	:= oDlgFin:nHeight/2

@00,00 MSPANEL oMainTop PROMPT "" SIZE nMbrWidth,40/*nMbrHeight*0.10*/  of oDlgFin
oMainTop:Align := CONTROL_ALIGN_TOP
oGrpFilt		:= TGroup():New(05,05,(oMainTop:NCLIENTHEIGHT/2),(oMainTop:NCLIENTWIDTH/2)-10,"Filtros",oMainTop,CLR_RED,,.T.)

aFiltros[N_FOPERA]		:= Array(4)

aFiltros[N_FOPERA][4]	:= Space(150)
oGFlCli		:= TGet():New(15,10,{|u| if( Pcount()>0, aFiltros[N_FOPERA][4] := u,aFiltros[N_FOPERA][4] ) },oMainTop,200,010,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"aFiltros[N_FOPERA][4]",,,,,,,"Pesquisar.: ",1,oFont,CLR_RED )

aFiltros[N_FOPERA][1]	:= {"1=Titulo","2=Nome Cliente","3=NSU","4=#Operadora","5=#Dt.Vencto","6=#Dt.Credito","7=Vencimento","8=Emissใo"}//[#'IDXPESQ']
aFiltros[N_FOPERA][2]	:= NIL //#'OBJPESQ']	:= nil
aFiltros[N_FOPERA][3]	:= "" //#'PESQUISA']	:= ""
aFiltros[N_FOPERA][2] 	:= TComboBox():New(23, 215,{|u|if(PCount()>0,aFiltros[N_FOPERA][3]:=u,aFiltros[N_FOPERA][3])},aFiltros[N_FOPERA][1],100,20,oMainTop,,{|| },,,,.T.,,,,,,,,,'aFiltros[N_FOPERA][3]')

oButFilt 	:= TButton():New( 23, 320, "Buscar"		, oMainTop,{|| FiltDados(aQuery,@aDados) },50,010,,,,.T.)
oButParam 	:= TButton():New( 23, 380, "Parametros"	, oMainTop,{|| IIF( Pergunte("GENMF003",.T.) , Processa({|| CargaBase(@aQuery,@aDados)	},"Consultando titulos...") , nil ) },60,010,,,,.T.)

aFiltros[N_FORDEM]		:= Array(4)
aFiltros[N_FORDEM][1]	:= {"1=Titulo","2=Nome Cliente","3=NSU","4=#Cartใo","5=#Dt.Vencto","6=#Dt.Credito","7=Vencimento","8=Emissใo","9=Pedido","10=#Situa็ใo"}//[#'IDXPESQ']
aFiltros[N_FORDEM][2]	:= "" //#'PESQUISA']	:= ""
aFiltros[N_FORDEM][3] 	:= TComboBox():New(23, 470,{|u|if(PCount()>0,aFiltros[N_FORDEM][2]:=u,aFiltros[N_FORDEM][2])},aFiltros[N_FORDEM][1],100,20,oMainTop,,{|| },,,,.T.,,,,,,,,,'aFiltros[N_FORDEM][2]','Ordenar.:  ',2,oTFont,CLR_RED)

aFiltros[N_FORDEM][3]:bChange	:= {|x| Processa({|| OrderDados(@aDados)	},"Ordenando dados...") }

//aaFilt[#'DTBASE']	:= DDATABASE
//oGDtBase		:= TGet():New(15,450,{|u| if( Pcount()>0, aaFilt[#'DTBASE'] := u,aaFilt[#'DTBASE']) },oMainTop,80,010,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,{|x| DDataBase := aaFilt[#'DTBASE'] },.F.,.F.,,"aaFilt[#'DTBASE']",,,,,,,"Data Base.: ",1,oFont,CLR_RED )
//oGDtBase

//oButAuto 	:= TButton():New( 23, 550, "Autorizar CTe"	, oMainTop,{|| Autoriz() },60,010,,,,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTotalizadores.                                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@00,00 MSPANEL oMain2Top PROMPT "" SIZE nMbrWidth,40/*nMbrHeight*0.10*/  of oDlgFin
oMain2Top:Align := CONTROL_ALIGN_TOP
oGrpTot		:= TGroup():New(05,05,(oMain2Top:NCLIENTHEIGHT/2),(oMain2Top:NCLIENTWIDTH/2)-10,"Totais",oMain2Top,CLR_RED,,.T.)

oGTotSld	:= TGet():New(15,010,{|u| if( Pcount()>0, aTotReg[N_TSALDO] := u,aTotReg[N_TSALDO] ) },oMain2Top,050,010,PESQPICT("SE1","E1_VALOR"),{|| .F. },0,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"aTotReg[N_TSALDO]",,,,,,,"Saldo Financeiro.: ",1,oFont,CLR_RED )
oGTotReg	:= TGet():New(15,080,{|u| if( Pcount()>0, aTotReg[N_TQTDREG] := u,aTotReg[N_TQTDREG] ) },oMain2Top,050,010,"",{|| .F. },0,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"aTotReg[N_TQTDREG]",,,,,,,"Titulos encontrados.: ",1,oFont,CLR_RED )
//oGTotAtr	:= TGet():New(15,150,{|u| if( Pcount()>0, aTotReg[N_TATRASO] := u,aTotReg[N_TATRASO] ) },oMain2Top,050,010,PESQPICT("SE1","E1_VALOR"),{|| .F. },0,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"aTotReg[N_TATRASO]",,,,,,,"Saldo Atraso.: ",1,oFont,CLR_RED )
//oGTotAce	:= TGet():New(15,220,{|u| if( Pcount()>0, aTotReg[N_TSLDARQ] := u,aTotReg[N_TSLDARQ] ) },oMain2Top,050,010,PESQPICT("SE1","E1_VALOR"),{|| .F. },0,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"aTotReg[N_TSLDARQ]",,,,,,,"Sld. a conciliar.: ",1,oFont,CLR_RED )
//oGTotaDM	:= TGet():New(15,290,{|u| if( Pcount()>0, aTotReg[N_TSLDTXA] := u,aTotReg[N_TSLDTXA] ) },oMain2Top,050,010,PESQPICT("SE1","E1_VALOR"),{|| .F. },0,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"aTotReg[N_TSLDTXA]",,,,,,,"Sld.Tx.Adm.: ",1,oFont,CLR_RED )
oGTValBru	:= TGet():New(15,150,{|u| if( Pcount()>0, aTotReg[N_TVALBRU] := u,aTotReg[N_TVALBRU] ) },oMain2Top,050,010,PESQPICT("SE1","E1_VALOR"),{|| .F. },0,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"aTotReg[N_TVALBRU]",,,,,,,"Val.Bruto.: ",1,oFont,CLR_RED )
oGTValTx	:= TGet():New(15,220,{|u| if( Pcount()>0, aTotReg[N_TVALTX] := u,aTotReg[N_TVALTX] ) },oMain2Top,050,010,PESQPICT("SE1","E1_VALOR"),{|| .F. },0,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"aTotReg[N_TVALTX]",,,,,,,"Val.Tx.Adm.: ",1,oFont,CLR_RED )
oGTValLiq	:= TGet():New(15,290,{|u| if( Pcount()>0, aTotReg[N_TVALLIQ] := u,aTotReg[N_TVALLIQ] ) },oMain2Top,050,010,PESQPICT("SE1","E1_VALOR"),{|| .F. },0,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"aTotReg[N_TVALLIQ]",,,,,,,"Val.Liq.: ",1,oFont,CLR_RED )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณtitulos.                                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgFin
oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT

oGrpXML		:= TGroup():New(05,05,(oMainCentro:NCLIENTHEIGHT/2)-40,(oMainCentro:NCLIENTWIDTH/2)-10,"Titulos Cartใo de Credito",oMainCentro,CLR_RED,,.T.)
//aHList	:= {"Documento/Serie","CGC","Cliente","Emissใo","Integridade Emissใo","Autorizado CTE","CONEMB","Pr้-Fatura","Fatura","Valida็ใo Fat.","DOCCOB","Bordero","CNAB"}
aHList	:= {}

Processa({|| CargaBase(@aQuery,@aDados)	},"Consultando titulos...") 

oListBox := TWBrowse():New(15,10,(oMainCentro:NCLIENTWIDTH/2)-30,(oMainCentro:NCLIENTHEIGHT/2)-60,,aHList,,oMainCentro,,,,,,,,,,,,, "ARRAY", .T. )

//oListBox:AddColumn(TCColumn():New(" "					,{|| IIF( aDados[oListBox:nAT][N_OK] == .T. , oOk , oNOk )		},,,,'CENTER'	,10,lBitmap,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New(" "					,{|| aDados[oListBox:nAT][N_TITCON]								},,,,'CENTER'	,10,lBitmap,.F.,,,,.F.,))


nLenPixel	:= RetTanCp("E1_FILIAL")
oListBox:AddColumn(TCColumn():New(AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_FILIAL]		},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("E1_NUM")
oListBox:AddColumn(TCColumn():New(AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_NUM]		},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("E1_PARCELA")
oListBox:AddColumn(TCColumn():New(AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_PARCELA]		},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("E1_NOMCLI")
oListBox:AddColumn(TCColumn():New(AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_NOMCLI]		},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("E1_EMISSAO")
oListBox:AddColumn(TCColumn():New(AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_EMISSAO]		},,,,'CENTER'	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("E1_VENCREA")
oListBox:AddColumn(TCColumn():New(AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_VENCREA]		},,,,'CENTER'	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("E1_VALOR")
oListBox:AddColumn(TCColumn():New(AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_VALOR]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("E1_SALDO")
oListBox:AddColumn(TCColumn():New(AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_SALDO]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("C6_VALOR")
oListBox:AddColumn(TCColumn():New("Vlr.Tot.Parcela"	,{|| aDados[oListBox:nAT][N_TOT_PAR]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("C6_VALOR")
oListBox:AddColumn(TCColumn():New("Vlr.Tot.Venda"	,{|| aDados[oListBox:nAT][N_VENDA]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("E1_BAIXA")
oListBox:AddColumn(TCColumn():New(AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_BAIXA]		},,,,'CENTER'	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("E1_DOCTEF")
oListBox:AddColumn(TCColumn():New("NSU - Titulo"	,{|| aDados[oListBox:nAT][N_NSU]		},,,,'LEFT'	,nLenPixel,.F.,.F.,,,,.F.,))

oListBox:AddColumn(TCColumn():New("Ped.Protheus/Web"	,{|| aDados[oListBox:nAT][N_PEDIDO]	},,,,'LEFT'	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("ZZ9_VALBRU")
oListBox:AddColumn(TCColumn():New("#"+AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_VALBRU]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("ZZ9_LIGPAG")
oListBox:AddColumn(TCColumn():New("#"+AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_LIGPAG]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("ZZ9_SALDO")
oListBox:AddColumn(TCColumn():New("#"+AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_PG_SALDO]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("ZZ9_DTVEND")
oListBox:AddColumn(TCColumn():New("#"+AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_DTVEND]		},,,,'CENTER'	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("ZZ9_DTCRED")
oListBox:AddColumn(TCColumn():New("#"+AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_DTCRED]		},,,,'CENTER'	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("ZZ9_OPERA")
oListBox:AddColumn(TCColumn():New("#"+AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_OPERA]		},,,,'CENTER'	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("E1_XBANDEI")
oListBox:AddColumn(TCColumn():New(AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_DESBA]		},,,,'CENTER'	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("ZZ9_TXADM")
oListBox:AddColumn(TCColumn():New("#"+AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_TXADM]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("ZZ9_STXADM")
oListBox:AddColumn(TCColumn():New("#"+AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_STXADM]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))


oListBox:AddColumn(TCColumn():New("#CONC."					,{|| IIF( aDados[oListBox:nAT][N_ZZ9CONC] == "1" , oVerde , oVerme )		},,,,'CENTER'	,25,lBitmap,.F.,,,,.F.,))
//oListBox:AddColumn(TCColumn():New("INTE."					,{|| aDados[oListBox:nAT][N_ZZ9INTE]		},,,,'CENTER'	,60,lBitmap,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("ZZ9_NUMLOT")
oListBox:AddColumn(TCColumn():New("#Resumo Vendas"	,{|| aDados[oListBox:nAT][N_LOTE]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("E1_PARCELA")
oListBox:AddColumn(TCColumn():New("Qtd.Parcelas"	,{|| aDados[oListBox:nAT][N_QTDPAR]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= RetTanCp("ZZ9_MSG")
oListBox:AddColumn(TCColumn():New(AllTrim(SX3->(X3Titulo()))	,{|| aDados[oListBox:nAT][N_MSG]		},,,,'LEFT'	,800,.F.,.F.,,,,.F.,))


//E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_SALDO,E1_VALOR,E1_BAIXA,SE1.E1_VENCREA,SE1.E1_SITUACA

oListBox:SetArray( aDados )

AADD(aButtons, {"cargaseq",	{|| Processa({|| GENMF03B(.T.) , U_GENMF004() , GENMF03B(.F.) , Processa({|| CargaBase(@aQuery,@aDados)	},"Consultando titulos...")	},"Processando...")  }, "Registros Concilia็ใo"})

AADD(aButtons, {"cargaseq",	{|| Processa({|| GENMF03B(.T.) , U_GENMF03C(aDados) , GENMF03B(.F.) , Processa({|| CargaBase(@aQuery,@aDados)	},"Baixando titulos...")	},"Processando...")  }, "Baixar"})

/*
AADD(aButtons, {"cargaseq",	{|| Processa({|| GENMF03B(.T.) , ProcEstono() , GENMF03B(.F.) , Processa({|| CargaBase(@aQuery,@aDados)	},"Processado estornos...")	},"Processando...")  }, "Estornos"})
*/

AADD(aButtons, {"cargaseq",	{|| Processa({|| GENMF03B(.T.) , U_GENMF03H() , GENMF03B(.F.) , Processa({|| CargaBase(@aQuery,@aDados)	},"Reprocessando Status...")	},"Processando...")  }, "Reproc.Satus"})

AADD(aButtons, {"cargaseq",	{|| Processa({|| GENMF03B(.T.) , xAlterTit(aDados[oListBox:nAT][N_SE1REC],aDados[oListBox:nAT][N_ZZ9REC] ) , GENMF03B(.F.) , Processa({|| CargaBase(@aQuery,@aDados)	},"Reprocessando Status...")	},"Processando...")  }, "Manutenใo titulo"})

AADD(aButtons, {"cargaseq",	{|| Processa({||  ExportGrid(aDados)	},"Processando...")  }, "Excel"})

//oListBox:bLDblClick	:= {|x| aDados[oListBox:nAT][N_OK] := !aDados[oListBox:nAT][N_OK] }

oListBox:bLDblClick	:= {|x| IIF( aDados[oListBox:nAT][N_TITCON] <> oAmar , (GENMF03B(.T.) , ;
									U_GENMF004(	aDados[oListBox:nAT][N_NSU],;
												aDados[oListBox:nAT][N_NSU],;
												"",;
												aDados[oListBox:nAT][N_DTCRED],;
												aDados[oListBox:nAT][N_DTCRED],;
												2,;
												aDados[oListBox:nAT][N_PARCELA],;
												aDados[oListBox:nAT][N_PARCELA],;
												.F.,;
												aDados[oListBox:nAT][N_ZZ9REC]);
									, GENMF03B(.F.) , Processa({|| CargaBase(@aQuery,@aDados)	},"Consultando titulos...")	) , nil ) }


Activate MsDialog oDlgFin On Init EnchoiceBar(oDlgFin,bConfirm,bCancel,,aButtons) Centered

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF003  บAutor  ณMicrosiga           บ Data ณ  11/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CargaBase(aQuery,aDados)

Local cQuery	:= ""
Local nLin		:= 0
Local cNatCart	:= GetMv("GENI018CAR") //NATUREZA PARA CARTAO DE CREDITO
Local cAliTmp	:= GetNextAlias()
Local cMsg		:= ""
Local lOkAux	:= nil 
Local oAux		:= nil
Local aTotAux	:= {}

ProcRegua(0)
IncProc()

aTotReg[N_TQTDREG]	:= 0
aTotReg[N_TSALDO]	:= 0
aTotReg[N_TATRASO]	:= 0 
aTotReg[N_TSLDARQ]	:= 0 
aTotReg[N_TSLDTXA]	:= 0 

aTotReg[N_TVALBRU]	:= 0 
aTotReg[N_TVALLIQ]	:= 0 
aTotReg[N_TVALTX]	:= 0

aQuery	:= {}

cQuery += " SELECT E1_FILIAL,ZZ9_SITUAC,E1_NUM,E1_PARCELA,E1_NOMCLI,E1_EMISSAO,E1_VENCREA,E1_VALOR,E1_SALDO,E1_BAIXA,E1_DOCTEF,ZZ9_VALBRU,ZZ9_LIGPAG,ZZ9_SALDO,ZZ9_DTVEND,ZZ9_DTCRED,ZZ9_OPERA,ZZ9_CONCIL,utl_raw.cast_to_varchar2(ZZ9_MSG) ZZ9_MSG,ZZ9.R_E_C_N_O_ RECZZ9,SE1.R_E_C_N_O_ SE1REC,ZZ9_STXADM,ZZ9_TXADM,ZZ9_PARCEL,E1_XBANDEI "+cEnt

/*cQuery += " ,(SELECT DISTINCT C5_PARC1+C5_PARC2+C5_PARC3+C5_PARC4+C5_PARC5+C5_PARC6+C5_PARC7+C5_PARC8 VALOR_VENDA FROM "+RetSqlName("SCV")+" SCV  "+cEnt
cQuery += "       JOIN "+RetSqlName("SC5")+" SC5 "+cEnt
cQuery += "       ON C5_FILIAL = '"+xFilial("SC5")+"' "+cEnt
cQuery += "       AND C5_NUM = SCV.CV_PEDIDO "+cEnt
cQuery += "       AND C5_XPEDWEB <> ' ' "+cEnt
cQuery += "       AND C5_XPEDOLD <> ' ' "+cEnt
cQuery += "       AND SC5.D_E_L_E_T_ <> '*' "+cEnt
cQuery += "       WHERE CV_FILIAL = '"+xFilial("SCV")+"' "+cEnt
cQuery += "       AND TRIM(SCV.CV_XNSUTEF) = TRIM(E1_DOCTEF) "+cEnt
cQuery += "       AND TRIM(SCV.CV_XPARCEL) = TRIM(E1_PARCELA) "+cEnt
cQuery += "       AND C5_NOTA = E1_NUM "+cEnt
cQuery += "       AND SCV.D_E_L_E_T_ <> '*' ) VENDA "+cEnt
*/
cQuery += "  , (SELECT SUM(SE1P.E1_VALOR) FROM "+RetSqlname("SE1")+" SE1P "+cEnt
//cQuery += "      WHERE SE1P.E1_FILIAL = SE1.E1_FILIAL "+cEnt
cQuery += "      WHERE SE1P.E1_FILIAL IN ('1001','1022') AND SE1P.E1_DOCTEF = SE1.E1_DOCTEF AND SE1P.D_E_L_E_T_ <> '*' "+cEnt
cQuery += "      AND NVL(TRIM(SE1P.E1_PARCELA),'A') = NVL(TRIM(SE1.E1_PARCELA),'A') AND SE1P.E1_TIPO = 'NF' "+cEnt
cQuery += "      ) TOT_PARCELA   "+cEnt
     
cQuery += " ,(SELECT DISTINCT C5_NUM||' / '||SC5.C5_XPEDWEB FROM "+RetSqlName("SCV")+" SCV  "+cEnt
cQuery += "       JOIN "+RetSqlName("SC5")+" SC5 "+cEnt
cQuery += "       ON C5_FILIAL IN ('1001','1022') AND C5_FILIAL = CV_FILIAL "+cEnt
cQuery += "       AND C5_NUM = SCV.CV_PEDIDO "+cEnt
cQuery += "       AND C5_XPEDWEB <> ' ' "+cEnt
cQuery += "       AND C5_XPEDOLD <> ' ' "+cEnt
cQuery += "       AND SC5.D_E_L_E_T_ <> '*' "+cEnt
//cQuery += "       WHERE CV_FILIAL = '"+xFilial("SCV")+"' "+cEnt
cQuery += "       WHERE CV_FILIAL IN ('1001','1022') AND TRIM(SCV.CV_XNSUTEF) = TRIM(E1_DOCTEF) "+cEnt
cQuery += "       AND TRIM(SCV.CV_XPARCEL) = NVL(TRIM(E1_PARCELA),'A') "+cEnt
cQuery += "       AND C5_NOTA = E1_NUM "+cEnt
cQuery += "       AND SCV.D_E_L_E_T_ <> '*' ) PED_PROWEB "+cEnt

cQuery += " ,(SELECT SUM(C5_PARC1+C5_PARC2+C5_PARC3+C5_PARC4+C5_PARC5+C5_PARC6+C5_PARC7+C5_PARC8) VALOR_VENDA FROM "+RetSqlName("SCV")+" SCV  "+cEnt
cQuery += "       JOIN "+RetSqlName("SC5")+" SC5 "+cEnt
cQuery += "       ON C5_FILIAL IN ('1001','1022') AND C5_FILIAL = CV_FILIAL "+cEnt
cQuery += "       AND C5_NUM = SCV.CV_PEDIDO "+cEnt
cQuery += "       AND C5_XPEDWEB <> ' ' "+cEnt
cQuery += "       AND C5_XPEDOLD <> ' ' "+cEnt
cQuery += "       AND SC5.D_E_L_E_T_ <> '*' "+cEnt
//cQuery += "       WHERE CV_FILIAL = '"+xFilial("SCV")+"' "+cEnt
cQuery += "       WHERE CV_FILIAL IN ('1001','1022') AND TRIM(SCV.CV_XNSUTEF) = TRIM(E1_DOCTEF) "+cEnt
cQuery += "       AND TRIM(SCV.CV_XPARCEL) = NVL(TRIM(E1_PARCELA),'A') "+cEnt
cQuery += "       AND SCV.D_E_L_E_T_ <> '*' ) VENDA_TOTAL "+cEnt

cQuery += "  ,	ZZ9_NUMLOT "
cQuery += "  , nvl(trim((SELECT MAX(SE1P.E1_PARCELA) FROM "+RetSqlname("SE1")+" SE1P "+cEnt
//cQuery += "      WHERE SE1P.E1_FILIAL = SE1.E1_FILIAL "+cEnt
cQuery += "      WHERE SE1P.E1_FILIAL IN ('1001','1022') AND SE1P.E1_DOCTEF = SE1.E1_DOCTEF AND SE1P.D_E_L_E_T_ <> '*' "+cEnt
cQuery += "      AND NVL(TRIM(SE1P.E1_PARCELA),'A') = NVL(TRIM(SE1.E1_PARCELA),'A') AND SE1P.E1_TIPO = 'NF' "+cEnt
cQuery += "      )),'A') QTD_PARCELA   "+cEnt

cQuery += "   FROM "+RetSqlName("SE1")+" SE1  "+cEnt
If MV_PAR05 == 2 .OR. MV_PAR05 == 3
	cQuery += "   JOIN "+RetSqlName("ZZ9")+" ZZ9"+cEnt	
Else
	cQuery += "   LEFT JOIN "+RetSqlName("ZZ9")+" ZZ9"+cEnt	
EndIf
cQuery += "   ON ZZ9_FILIAL = '"+xFilial("ZZ9")+"'"+cEnt
cQuery += "   AND TO_NUMBER(TRIM(ZZ9.ZZ9_NSU)) = TO_NUMBER(TRIM(E1_DOCTEF))"+cEnt
cQuery += "   AND TRIM(ZZ9.ZZ9_PARCEL) = NVL(TRIM(SE1.E1_PARCELA),'A') "+cEnt
cQuery += "   AND ZZ9.D_E_L_E_T_ <> '*'"+cEnt
If MV_PAR05 == 2 .OR. MV_PAR05 == 3
	cQuery += "	AND ZZ9_DTCRED BETWEEN '"+DtoS(MV_PAR08)+"' AND '"+DtoS(MV_PAR09)+"' "+cEnt
EndIf
//cQuery += "   WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"' "+cEnt

cQuery += "   AND ZZ9.ZZ9_TIPO = '11' "+cEnt
//1=Nao validado;2=Consistente;3=Inconsistente

Do Case
	//Case MV_PAR05 == 1

		//cQuery += "       AND (NVL(ZZ9_SITUAC,' ') IN ('1',' ') OR ZZ9.ZZ9_SITUAC IS NULL) "+cEnt
		
	Case MV_PAR05 == 2
		
		cQuery += "       AND ZZ9_SITUAC IN ('2') "+cEnt
					
	Case MV_PAR05 == 3	
	
		cQuery += "       AND ZZ9_SITUAC IN ('3') "+cEnt

EndCase

cQuery += "   WHERE E1_FILIAL IN ('1001','1022') "
cQuery += "   	  AND SE1.E1_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "+cEnt
cQuery += "       AND SE1.E1_VENCREA BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' "+cEnt
cQuery += "       AND SE1.E1_TIPO = 'NF ' "+cEnt
cQuery += "       AND SE1.D_E_L_E_T_ <> '*' "+cEnt
cQuery += "       AND SE1.E1_NATUREZ = '"+cNatCart+"' "+cEnt
cQuery += "       AND SE1.E1_SALDO > 0 "+cEnt
cQuery += "       AND SE1.E1_DOCTEF <> ' ' "+cEnt
cQuery += " 	  AND EXISTS( SELECT 1 FROM "+RetSqlName("SCV")+" SCV  "+cEnt
cQuery += "       JOIN "+RetSqlName("SC5")+" SC5 ON C5_FILIAL IN ('1001','1022') AND C5_FILIAL = CV_FILIAL AND SC5.C5_NUM = CV_PEDIDO AND SC5.D_E_L_E_T_ <> '*' "+cEnt
cQuery += "       AND SC5.C5_EMISSAO BETWEEN '"+DtoS(MV_PAR06)+"' AND '"+DtoS(MV_PAR07)+"' "+cEnt
cQuery += "       WHERE CV_FILIAL IN ('1001','1022') AND TRIM(SCV.CV_XNSUTEF) = TRIM(E1_DOCTEF) "+cEnt
cQuery += "       AND TRIM(SCV.CV_XPARCEL) = NVL(TRIM(E1_PARCELA),'A') "+cEnt
cQuery += "       AND SCV.D_E_L_E_T_ <> '*'  "+cEnt
cQuery += " 			) "+cEnt
If MV_PAR05 == 1
	cQuery += "     AND ( ZZ9.ZZ9_SITUAC IS NULL AND NOT EXISTS( "+cEnt
	cQuery += "         SELECT 1 FROM "+RetSqlName("ZZ9")+" ZZ9C "+cEnt
	cQuery += "         WHERE ZZ9C.ZZ9_FILIAL = '"+xFilial("ZZ9")+"' "+cEnt
	cQuery += "         AND TO_NUMBER(TRIM(ZZ9C.ZZ9_NSU)) = TO_NUMBER(TRIM(E1_DOCTEF)) "+cEnt
	cQuery += "         AND TRIM(ZZ9C.ZZ9_PARCEL) = NVL(TRIM(SE1.E1_PARCELA),'A')  "+cEnt
	cQuery += "         AND ZZ9C.D_E_L_E_T_ <> '*' "+cEnt
	cQuery += "         AND ZZ9C.ZZ9_TIPO = '11'  "+cEnt
	cQuery += "         AND (NVL(ZZ9C.ZZ9_SITUAC,' ') IN ('1',' ') OR ZZ9C.ZZ9_SITUAC IS NULL)        "+cEnt
	cQuery += "     ) ) "+cEnt
EndIf	    
cQuery += "       ORDER BY E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO "+cEnt

MemoWrite("GENMF003.sql",cQuery)

If Select(cAliTmp) > 0
	dbSelectArea(cAliTmp)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliTmp, .F., .T.)

(cAliTmp)->(DbGoTop())

While (cAliTmp)->(!EOF())

	oAux	:= nil	
	Do Case
		Case (cAliTmp)->ZZ9_SITUAC == "1"//1=Nao validado;2=Consistente;3=Inconsistente
		
			oAux	:= oAmar
//			aQuery[nLin][N_TITCON]	:= oAmar  			
			cMsg	:= "Registro de concilia็ใo nใo analisado!" 
			lOkAux	:= .F.
			
		Case (cAliTmp)->ZZ9_SITUAC == "2"//1=Nao validado;2=Consistente;3=Inconsistente
		
			oAux	:= oVerde
//			aQuery[nLin][N_TITCON]	:= oVerde
			cMsg	:= (cAliTmp)->ZZ9_MSG
			lOkAux	:= .T.
						
		Case (cAliTmp)->ZZ9_SITUAC == "3"//1=Nao validado;2=Consistente;3=Inconsistente
		
			oAux	:= oVerme
//			aQuery[nLin][N_TITCON]	:= oVerme
			cMsg	:= (cAliTmp)->ZZ9_MSG
			lOkAux	:= .F. 

		OtherWise
		
			oAux	:= oAmar
//			aQuery[nLin][N_TITCON]	:= oAmar
			cMsg	:= "Sem concilia็ใo a realizar!"
			lOkAux	:= .F.
						
	EndCase

	Aadd(aQuery, Array(N_SIZE) )	
	nLin := Len(aQuery)
	
	aQuery[nLin][N_TITCON]	:= oAux
		
	aQuery[nLin][N_FILIAL]		:= (cAliTmp)->E1_FILIAL	
	aQuery[nLin][N_NUM]			:= (cAliTmp)->E1_NUM
	aQuery[nLin][N_PARCELA]		:= (cAliTmp)->E1_PARCELA
	aQuery[nLin][N_NOMCLI]		:= (cAliTmp)->E1_NOMCLI
	aQuery[nLin][N_EMISSAO]		:= StoD((cAliTmp)->E1_EMISSAO)
	aQuery[nLin][N_VENCREA]		:= StoD((cAliTmp)->E1_VENCREA)
	aQuery[nLin][N_VALOR]  		:= (cAliTmp)->E1_VALOR
	aQuery[nLin][N_SALDO]  		:= (cAliTmp)->E1_SALDO
	aQuery[nLin][N_BAIXA] 		:= StoD((cAliTmp)->E1_BAIXA)
	aQuery[nLin][N_NSU]	   		:= (cAliTmp)->E1_DOCTEF
	aQuery[nLin][N_VALBRU] 		:= (cAliTmp)->ZZ9_VALBRU
	aQuery[nLin][N_LIGPAG]		:= (cAliTmp)->ZZ9_LIGPAG
	aQuery[nLin][N_DTVEND] 		:= StoD((cAliTmp)->ZZ9_DTVEND)
	aQuery[nLin][N_DTCRED] 		:= StoD((cAliTmp)->ZZ9_DTCRED)
	aQuery[nLin][N_OPERA]  		:= AllTrim(Posicione("SX5",1,xFilial("SX5")+"ZW"+(cAliTmp)->ZZ9_OPERA,"X5_DESCRI"))
	aQuery[nLin][N_BANDE]  		:= (cAliTmp)->E1_XBANDEI
	aQuery[nLin][N_DESBA]  		:= AllTrim(Posicione("SX5",1,xFilial("SX5")+"ZX"+(cAliTmp)->E1_XBANDEI,"X5_DESCRI"))
	
	aQuery[nLin][N_ZZ9CONC]		:= (cAliTmp)->ZZ9_CONCIL
//	aQuery[nLin][N_ZZ9INTE]		:= (cAliTmp)->E1_NUM
	aQuery[nLin][N_MSG]	   		:= cMsg
	aQuery[nLin][N_OK]	   		:= lOkAux
	aQuery[nLin][N_ZZ9REC] 		:= (cAliTmp)->RECZZ9 
	aQuery[nLin][N_VENDA]  		:= (cAliTmp)->VENDA_TOTAL
	aQuery[nLin][N_PEDIDO]		:= (cAliTmp)->PED_PROWEB
	aQuery[nLin][N_ZZ9SIT]		:= (cAliTmp)->ZZ9_SITUAC
	aQuery[nLin][N_TOT_PAR]		:= (cAliTmp)->TOT_PARCELA  
	aQuery[nLin][N_PG_SALDO]	:= (cAliTmp)->ZZ9_SALDO
	aQuery[nLin][N_SE1REC]		:= (cAliTmp)->SE1REC
	aQuery[nLin][N_STXADM]		:= (cAliTmp)->ZZ9_STXADM
	aQuery[nLin][N_TXADM]		:= (cAliTmp)->ZZ9_TXADM	
	
	aQuery[nLin][N_LOTE]		:= (cAliTmp)->ZZ9_NUMLOT
	aQuery[nLin][N_QTDPAR]		:= (cAliTmp)->QTD_PARCELA
		
	aTotReg[N_TQTDREG]	:= aTotReg[N_TQTDREG]+1
	aTotReg[N_TSALDO]	:= aTotReg[N_TSALDO]+(cAliTmp)->E1_SALDO
	If StoD((cAliTmp)->E1_VENCREA) < DDatabase
		aTotReg[N_TATRASO]	:= aTotReg[N_TATRASO]+(cAliTmp)->E1_SALDO
	EndIf

	aTotReg[N_TVALBRU]	:= aTotReg[N_TVALBRU]+(cAliTmp)->ZZ9_VALBRU 
	aTotReg[N_TVALLIQ]	:= aTotReg[N_TVALLIQ]+(cAliTmp)->ZZ9_SALDO
	aTotReg[N_TVALTX]	:= aTotReg[N_TVALTX]+(cAliTmp)->ZZ9_STXADM
	
	If aScan(aTotAux, {|x| VAL(AllTrim(x[1])) == VAL(AllTrim((cAliTmp)->E1_DOCTEF)) .and. ALLTRIM(X[2]) == ALLTRIM((cAliTmp)->ZZ9_PARCEL) } ) == 0
		Aadd( aTotAux , { (cAliTmp)->E1_DOCTEF , (cAliTmp)->ZZ9_PARCEL , (cAliTmp)->ZZ9_SALDO , (cAliTmp)->ZZ9_STXADM } )
	EndIf

	(cAliTmp)->(DbSkip())
EndDo

aEval(aTotAux, {|x| aTotReg[N_TSLDARQ] := aTotReg[N_TSLDARQ]+x[3],aTotReg[N_TSLDTXA] := aTotReg[N_TSLDTXA]+x[4] } )

(cAliTmp)->(DbCloseArea())

FiltDados(aQuery,@aDados)

OrderDados(@aDados)

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF003  บAutor  ณMicrosiga           บ Data ณ  11/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FiltDados(aQuery,aDados)

Local nLoop	:= 0

If Type("oListBox") == "O"
	
	If Empty(AllTrim(aFiltros[N_FOPERA][4]))
	
		aDados	:= aClone(aQuery)
		
	Else

		aDados	:= {}    
	    		
		For nLoop := 1 To Len(aQuery)
			Do Case // 1=Titulo","2=Nome Cliente","3=NSU","4=Cartใo","5=Dt.Vencto","6=Dt.Credito"
				Case aFiltros[N_FOPERA][3] == "1" .AND. !(UPPER(AllTrim(aFiltros[N_FOPERA][4])) $ UPPER(aQuery[nLoop][N_NUM]))
					Loop
				Case aFiltros[N_FOPERA][3] == "2" .AND. !(UPPER(AllTrim(aFiltros[N_FOPERA][4])) $ UPPER(aQuery[nLoop][N_NOMCLI]))
					Loop
				Case aFiltros[N_FOPERA][3] == "3" .AND. !(UPPER(AllTrim(aFiltros[N_FOPERA][4])) $ UPPER(aQuery[nLoop][N_NSU]))
					Loop
				Case aFiltros[N_FOPERA][3] == "4" .AND. !(UPPER(AllTrim(aFiltros[N_FOPERA][4])) $ UPPER(aQuery[nLoop][N_OPERA]))
					Loop
				Case aFiltros[N_FOPERA][3] == "5" .AND. !(CtoD(aFiltros[N_FOPERA][4]) == aQuery[nLoop][N_DTVEND] )
					Loop
				Case aFiltros[N_FOPERA][3] == "6" .AND. !(CtoD(aFiltros[N_FOPERA][4]) == aQuery[nLoop][N_DTCRED] )
					Loop  
				Case aFiltros[N_FOPERA][3] == "7" .AND. !(CtoD(aFiltros[N_FOPERA][4]) == aQuery[nLoop][N_VENCREA] )
					Loop  
				Case aFiltros[N_FOPERA][3] == "8" .AND. !(CtoD(aFiltros[N_FOPERA][4]) == aQuery[nLoop][N_EMISSAO] )
					Loop  										
				OtherWise	
					    
					Aadd(aDados , aQuery[nLoop] )
									
			EndCase
	    Next
	    
	EndIf	
    
	If Len(aDados) == 0
		Aadd(aDados,Array(N_SIZE))
		nLin := Len(aDados)

		aDados[nLin][N_TITCON] 		:= oVerme
		aDados[nLin][N_FILIAL] 		:= ""
		aDados[nLin][N_NUM]	   		:= ""
		aDados[nLin][N_PARCELA]		:= ""
		aDados[nLin][N_NOMCLI] 		:= ""
		aDados[nLin][N_EMISSAO]		:= Ctod("  /  /  ")
		aDados[nLin][N_VENCREA]		:= Ctod("  /  /  ")
		aDados[nLin][N_VALOR]  		:= 0
		aDados[nLin][N_SALDO]  		:= 0
		aDados[nLin][N_BAIXA]  		:= Ctod("  /  /  ")
		aDados[nLin][N_NSU]	   		:= ""
		aDados[nLin][N_VALBRU] 		:= 0
		aDados[nLin][N_LIGPAG] 		:= 0
		aDados[nLin][N_DTVEND] 		:= Ctod("  /  /  ")
		aDados[nLin][N_DTCRED] 		:= Ctod("  /  /  ")
		aDados[nLin][N_OPERA]  		:= ""
		aDados[nLin][N_BANDE]  		:= ""
		aDados[nLin][N_DESBA]  		:= ""		
		aDados[nLin][N_ZZ9CONC]		:= ""
		aDados[nLin][N_MSG]	   		:= ""
		aDados[nLin][N_OK]	   		:= .F.
		aDados[nLin][N_ZZ9REC] 		:= 0  
		aDados[nLin][N_VENDA]  		:= 0 
		aDados[nLin][N_PEDIDO]		:= ""
		aDados[nLin][N_ZZ9SIT]		:= "" 
		aDados[nLin][N_TOT_PAR]		:= 0
		aDados[nLin][N_PG_SALDO]	:= 0
		aDados[nLin][N_SE1REC]		:= 0
		aDados[nLin][N_TXADM]		:= 0
		aDados[nLin][N_STXADM]		:= 0		
		aDados[nLin][N_LOTE]		:= ""
		aDados[nLin][N_QTDPAR]		:= ""
		
	EndIF

	oListBox:nAT	:= 1
	oListBox:SetArray( aDados )
            
 	oListBox:DrawSelect()
	oListBox:Refresh()
	oListBox:GoTop()
Else
	aDados	:= aClone(aQuery)	
EndIf

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF003  บAutor  ณMicrosiga           บ Data ณ  11/21/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OrderDados(aDados)

Local nCol	:= 0 

Do Case
//"1=Titulo","2=Nome Cliente","3=NSU","4=Cartใo","5=Dt.Vencto","6=Dt.Credito","7=Vencimento","8=Emissใo","9=Pedido","10=Situa็ใo"
	Case aFiltros[N_FORDEM][2] == "1"
		nCol := N_NUM
	Case aFiltros[N_FORDEM][2] == "2"
		nCol := N_NOMCLI
	Case aFiltros[N_FORDEM][2] == "3"
		nCol := N_NSU
	Case aFiltros[N_FORDEM][2] == "4"
		nCol := N_OPERA
	Case aFiltros[N_FORDEM][2] == "5"
		nCol := N_VENCREA
	Case aFiltros[N_FORDEM][2] == "6"
		nCol := N_DTCRED
	Case aFiltros[N_FORDEM][2] == "7"
		nCol := N_DTVEND
	Case aFiltros[N_FORDEM][2] == "8"
		nCol := N_EMISSAO
	Case aFiltros[N_FORDEM][2] == "9"
		nCol := N_PEDIDO
	Case aFiltros[N_FORDEM][2] == "10"
		nCol := N_ZZ9SIT
	OtherWise
		nCol := N_NUM
EndCase


//aDados	:= aSort( aDados,,, {|x,y| x[nCol] <= y[nCol] .AND. RetNumPc(AllTrim(x[N_PARCELA])) <= RetNumPc(AllTrim(y[N_PARCELA])) })
aDados	:= aSort( aDados,,, {|x,y| x[nCol] <= y[nCol] .AND. AllTrim(x[N_PARCELA]) <= AllTrim(y[N_PARCELA]) })

If Type("oListBox") == "O"
		
	oListBox:nAT	:= 1
	oListBox:SetArray( aDados )
            
 	oListBox:DrawSelect()
	oListBox:Refresh()
	oListBox:GoTop()
	
EndIf

Return nil


Static function RetNumPc(xParc)

Local nRet	:= 1
Local cLoop	:= ""

If Empty(xParc)
	Return 0
EndIf

If ValType(xParc) == "N"
	xParc := AllTrim(Str(xParc))
EndIf

If IsAlpha( xParc )
	cLoop := "A"
Else
	cLoop := "1"	
EndIf

While cLoop < xParc	
	 cLoop := Soma1(cLoop)
	 nRet++
EndDo

Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF003  บAutor  ณMicrosiga           บ Data ณ  11/16/16   บฑฑ
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

PutSx1(cPerg,"01","De Num.titulo"		,"","","mv_ch1" ,"C",TamSX3("E1_NUM")[1],0,0,"G","","","","","mv_par01" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"02","At้ Num.titulo"		,"","","mv_ch2" ,"C",TamSX3("E1_NUM")[1],0,0,"G","","","","","mv_par02" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"03","De Vencimento"		,"","","mv_ch3" ,"D",08,0,0,"G","","","","","mv_par03" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"04","At้ Vencimento"		,"","","mv_ch4" ,"D",08,0,0,"G","","","","","mv_par04" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"05","Situa็ใo"			,"","","mv_ch5", "N",01,0,4,"C","","","","","mv_par05","Nao validado","Nao validado","Nao validado", "","Consistente","Consistente","Consistente", "Inconsistente", "Inconsistente", "Inconsistente", "Todas", "Todas", "Todas", "", "", "", "", "", "", "")
PutSx1(cPerg,"06","De Dt.Venda"			,"","","mv_ch6" ,"D",08,0,0,"G","","","","","mv_par06" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"07","At้ Dt.Venda"		,"","","mv_ch7" ,"D",08,0,0,"G","","","","","mv_par07" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"08","De Dt.Credito"		,"","","mv_ch8" ,"D",08,0,0,"G","","","","","mv_par08" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"09","At้ Dt.Credito"		,"","","mv_ch9" ,"D",08,0,0,"G","","","","","mv_par09" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")


Return nil 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMGC_001   บAutor  ณMicrosiga           บ Data ณ  26/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณrealiza backup do SX1 posicionado.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Golden                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GENMF03B(lBackup)

Local aAreaSX1	:= SX1->(GetArea()) 
Local aAreaUser	:= PROFALIAS->(GetArea())

Default lBackup	:= .F.

If lBackup

	aBkpSX1[1]	:= MV_PAR01
	aBkpSX1[2]	:= MV_PAR02
	aBkpSX1[3]	:= MV_PAR03
	aBkpSX1[4]	:= MV_PAR04
	aBkpSX1[5]	:= MV_PAR05
	aBkpSX1[6]	:= MV_PAR06
	aBkpSX1[7]	:= MV_PAR07
	aBkpSX1[8]	:= MV_PAR08
	aBkpSX1[9]	:= MV_PAR09
						
	aBkpSX1[11]	:= aAreaSX1
	aBkpSX1[12]	:= aAreaUser	
			
Else

	RestArea(aBkpSX1[11])
	RestArea(aBkpSX1[12])
	
	MV_PAR01 := aBkpSX1[1]
	MV_PAR02 := aBkpSX1[2]
	MV_PAR03 := aBkpSX1[3]
	MV_PAR04 := aBkpSX1[4]
	MV_PAR05 := aBkpSX1[5]
	MV_PAR06 := aBkpSX1[6]
	MV_PAR07 := aBkpSX1[7]
	MV_PAR08 := aBkpSX1[8]
	MV_PAR09 := aBkpSX1[9]
		
	Return nil

EndIF
	
RestArea(aAreaSX1)
RestArea(aAreaUser)

Return nil 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF003  บAutor  ณMicrosiga           บ Data ณ  11/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetTanCp(cField)

Local nRet	:= 0

//SX3->(DbSetOrder(2))
//SX3->(Dbseek(cField))
//nRet := CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,alltrim(SX3->X3_PICTURE),SX3->(X3Titulo()))

nRet := CalcFieldSize(FWSX3Util():GetFieldType(cField),TamSx3(cField)[1],TamSx3(cField)[2],Posicione("SX3",2,cField,"X3_PICTURE"),Posicione("SX3",2,cField,"X3_TITULO"))

Return nRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF003  บAutor  ณMicrosiga           บ Data ณ  12/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณrealizada baixa dos titulos com situa็ใo OK                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENMF03C(aDados,lAuto,oExcel,lMail,cSheet,cSheet2,cSheet4,cSheet5,cTable,cTable2,cTable4,cTable5)

Local cFilBkp	:= cFilAnt
Local aAreaSM0	:= SM0->(GetArea())
Local aArea		:= GetArea()
Local aAreaSE1	:= SE1->(GetArea())
Local cErro		:= ""
Local nAuxTit	:= 0
Local aLog		:= {}
Local lMultTitu	:= .F.
Local cTmpAlias	:= GetNextAlias()
Local nValBx	:= 0    
Local nSldBx	:= 0 
Local nE1Saldo	:= 0
Local nValAbat	:= 0
Local nValDesc	:= 0
Local nValAcre	:= 0
Local nDif		:= 0
Local nSldTxAdm	:= 0
Local aTxAdm	:= {}
Local aBaixa	:= {}

Local nMgMais	:= 2
Local nMgMenos	:= -2

Local cMOTBX		:= " "
Local cBANCO		:= Criavar("E1_PORTADO" ,.F.)
Local cAGENCIA		:= Criavar("E1_AGEDEP" ,.F.)
Local cCONTA		:= Criavar("E1_CONTA" ,.F.)
Local dDtBAIXA		:= DDataBase
Local dDTCREDITO	:= DDataBase
Local cHIST			:= ""
Local nJUROS		:= 0
Local nVALREC		:= 0
Local cMsgAux		:= ""
Local aMotBx		:= ReadMotBx()
Local aDescMotbx	:= {}
Local nNI			:= 1

Local oDlgMotBx		:= nil
Local oPnt01		:= nil
Local nMbrWidth		:= nil
Local nMbrHeight	:= nil
Local oTFont 		:= TFont():New('Courier new',,-18,.T.)

Local oMotBx		:= nil
Local oBanco		:= nil
Local oAgenc		:= nil
Local oConta		:= nil 
Local lOpcx			:= .F.
Local nVlrNoBx		:= 0
Local lZZ9         	:= .T.
Local cMsgErro     	:= ""
Local lDifVal      	:= .F.
Local cNSUProc      := ""
Local aDif          := {}

Default lAuto  := .F.
Default oExcel := Nil
Default lMail  := .F.

If Len(aDados) == 0
	If !lAuto
		MsgStop("Nใo foram encontrados titulos a serem baixados!")
	Else
		Conout("GENMF03C - Automแtico - Nใo foram encontrados titulos a serem baixados!")
	EndIf
	Return .F.
EndIf

For nNI := 1 to Len(aMotBx)
	If Substr(aMotBx[nNI],34,01) == "A" .or. Substr(aMotBx[nNI],34,01) =="R"
		AADD( aDescMotbx, Left(aMotBx[nNI],3)+"="+Substr(aMotBx[nNI],07,10))
	EndIf
Next

If !lAuto
	If oListBox:nat > 0
		SE1->(DbGoTo( aDados[oListBox:nat][N_SE1REC] ))
		ZZ9->(DbGoTo( aDados[oListBox:nat][N_ZZ9REC] ))       
	Else
		SE1->(DbGoTo( aDados[1][N_SE1REC] ))
		ZZ9->(DbGoTo( aDados[1][N_ZZ9REC] ))
	EndIf


	//SAE->(DbSetOrder(1))
	SAE->(DbOrderNickName("IDOPERA"))
	If SAE->(DbSeek(xFilial("SAE")+ZZ9->ZZ9_OPERA))
		cBANCO		:= SAE->AE_XCODIGO	
		cAGENCIA  	:= SAE->AE_XAGENCI
		cCONTA  	:= SAE->AE_XCONTA
		cMOTBX 		:= SAE->AE_XMOTBX
	EndIf
						
	/*		
	If !MsgYesNo("Confirma a baixa de todos os titulos com legenda verde?")
		Return nil
	EndIf
	*/
	
	DEFINE MSDIALOG oDlgMotBx TITLE 'Baixas a Receber'  From 00,00 To 250,500 pixel Style DS_MODALFRAME
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณArmazena as corrdenadas da tela                                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nMbrWidth	:= oDlgMotBx:nWidth/2
	nMbrHeight	:= oDlgMotBx:nHeight/2
	
	@00,00 MSPANEL oPnt01 PROMPT "" SIZE nMbrWidth,nMbrHeight OF oDlgMotBx
	oPnt01:Align	:= CONTROL_ALIGN_ALLCLIENT
	
	oGrpCt		:= TGroup():New(10,10,(oPnt01:NCLIENTHEIGHT/2)-25,(oPnt01:NCLIENTWIDTH/2)-10,"Dados para baixa",oPnt01,CLR_BLUE,,.T.)
	
	oMotBx		:= TComboBox():New(30,25,{|u| if( PCount()>0, cMOTBX:=u,cMOTBX)},aDescMotbx,100,20,oGrpCt,,{|| FA070VlNat(cMOTBX) } ,,,,.T.,,,,,,,,,'cMOTBX',"Mot.Baixa:",1,nil,CLR_BLUE)
	oBanco		:= TGet():New(55,025,{|u| if( Pcount()>0, cBANCO:= u,cBANCO ) },oGrpCt,035,010,"",{|| .T. },0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cBANCO",,,,,,,"Banco:",1,nil,CLR_BLUE )
	oBanco:CF3	:= "SA6" 
	oAgenc		:= TGet():New(55,080,{|u| if( Pcount()>0, cAGENCIA:= u,cAGENCIA ) },oGrpCt,050,010,"",{|| .T. },0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cAGENCIA",,,,,,,"Ag๊ncia:",1,nil,CLR_BLUE )
	oConta		:= TGet():New(55,150,{|u| if( Pcount()>0, cCONTA:= u,cCONTA ) },oGrpCt,080,010,"",{|| .T. },0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cCONTA",,,,,,,"Conta:",1,nil,CLR_BLUE )
	
	ACTIVATE MSDIALOG oDlgMotBx CENTERED ON INIT EnchoiceBar(oDlgMotBx,{|| IIF( Empty(cMOTBX) .OR. Empty(cBANCO) .Or. Empty(cAGENCIA) .Or. Empty(cCONTA) , MsgStop("Verifique os parametros informados!") , (lOpcx := .T.,oDlgMotBx:End())  ) }, {|| oDlgMotBx:End() })
	
	If !lOpcx
		Return .F.
	EndIf
	
	ProcRegua(Len(aDados))
EndIf

nCont := Len(aDados)

For nAuxTit := 1 To Len(aDados)
	
	cMsgAux	:= aDados[nAuxTit][N_NUM]+"/"+aDados[nAuxTit][N_PARCELA]+" - "+AllTrim(Str(nAuxTit))+"/"+AllTrim(Str(nCont))
	
	If !lAuto
		IncProc(cMsgAux+"Processando...")
	Else
		Conout(Time()+" - GENMF003 - Automatico - Processando titulo: "+cMsgAux)
	/*	If Empty(aDados[nAuxTit][N_ZZ9REC])
			lZZ9 := .F.
		Else
			lZZ9 := .T.
		EndIf*/
	EndIf
	
	If aDados[nAuxTit][N_OK]
						
		nValBx	:= 0
		
		SE1->(DbGoTo( aDados[nAuxTit][N_SE1REC] ))		
		ZZ9->(DbGoTo( aDados[nAuxTit][N_ZZ9REC] ))
				
		aAreaSE1	:= SE1->(GetArea())
		
		cFilAnt	:= SE1->E1_FILIAL
		SM0->(DbSeek( cEmpAnt+SE1->E1_FILIAL ))
				
		DbSelectArea("SAE")
		SAE->(DbOrderNickName("IDOPERA"))
		If SAE->(DbSeek(xFilial("SAE")+AllTrim(aDados[nAuxTit][N_OPERA])))
			cBANCO   := SAE->AE_XCODIGO	
			cAGENCIA := SAE->AE_XAGENCI
			cCONTA   := SAE->AE_XCONTA
			cMOTBX   := SAE->AE_XMOTBX
		Else
			If lAuto
				oExcel:AddRow(cSheet4,cTable4,{;
				SE1->E1_NUM,;
				SE1->E1_PREFIXO,;
				SE1->E1_PARCELA,;
				SE1->E1_DOCTEF,;
				SE1->E1_CLIENTE,;
				SE1->E1_LOJA,;
				SE1->E1_NOMCLI,;
				DtoC(SE1->E1_EMISSAO),;
				DtoC(SE1->E1_VENCREA),;
				SE1->E1_VALOR,;
				"",;
				SE1->E1_XOPERA;
				})
				
				lMail := .T.
			EndIf	
			
			Loop
		EndIf
		
		lMultTitu	:= .F.
		lJaBaixa 	:= .F.
		
		If !lAuto
			If SE1->E1_SALDO == 0
				Aadd(aLog, {"Falha","Baixa",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Nใo encontrado saldo em aberto para o titulo.",SE1->E1_EMISSAO, SE1->E1_VENCREA, ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, SE1->E1_XOPERA,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )
				Loop
			EndIf
			
			If ZZ9->ZZ9_SALDO == 0
				Aadd(aLog, {"Falha","Baixa",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Nใo encontrado saldo de pagamento para o titulo",SE1->E1_EMISSAO, SE1->E1_VENCREA, ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, SE1->E1_XOPERA,SE1->E1_CLIENTE,SE1->E1_LOJA,0} )
				Loop
			EndIf
			
			If ZZ9->ZZ9_DTCRED > DDataBase
				// removido o alerta pois teremos muitos titulos tela com data posterior
				//Aadd(aLog, {"Falha",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Data do credito maior que a data base do sistema"} )
				Loop
			EndIf
					
			//SAE->(DbSetOrder(1))
			SAE->(DbOrderNickName("IDOPERA"))
			If !SAE->(DbSeek(xFilial("SAE")+ZZ9->ZZ9_OPERA)) .OR. Empty(ZZ9->ZZ9_OPERA)
				Aadd(aLog, {"Falha","Baixa",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Operadora "+ZZ9->ZZ9_OPERA+" nใo localizada!",SE1->E1_EMISSAO, SE1->E1_VENCREA, ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, SE1->E1_XOPERA,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )
				Loop
			EndIf
		EndIf
        
        /*
		If Empty(SAE->AE_XCODIGO) .OR. Empty(SAE->AE_XAGENCI) .OR. Empty(SAE->AE_XCONTA) .OR. Empty(SAE->AE_XMOTBX)
			Aadd(aLog, {"Falha","Baixa",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Dados bancarios ou motivo de baixa nใo informados para operadora "+ZZ9->ZZ9_OPERA+"!"} )
			Loop			
		EndIf
		*/
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifico se o valor da parcela estแ dividido em mais titulos de devido a quebra ณ
		//ณde pedido em obra digital e impressa                                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		/* vivaz - 351714, Cleuto - 17/07217 removi da query o campo e1_filial pois estava quebrando o grup by retornando mais uma linha com isso  */
		
		cQuery := "SELECT E1_PARCELA,E1_TIPO,SUM(E1_SALDO) E1_SALDO,SUM(E1_VALOR) E1_VALOR,MAX(E1_BAIXA) E1_BAIXA,E1_VENCREA,COUNT(*) QTD "+CRLF 
		cQuery += "	FROM "+RetSqlName("SE1")+" SE1 "+CRLF
		cQuery += "	WHERE E1_TIPO = 'NF' "+CRLF
		cQuery += "	AND TO_NUMBER(nvl(TRIM( regexp_replace( regexp_replace(regexp_replace(TRIM(E1_DOCTEF),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)) = "+ALLTRIM(STR(VAL(ALLTRIM(ZZ9->ZZ9_NSU))))+" "+CRLF
		cQuery += "	AND NVL(TRIM(E1_PARCELA),'A') = '"+ALLTRIM(ZZ9->ZZ9_PARCEL)+"' "+CRLF
		cQuery += "	AND SE1.D_E_L_E_T_ = ' ' "+CRLF
		cQuery += "	GROUP BY E1_PARCELA,E1_TIPO,E1_VENCREA "+CRLF
		
		MemoWrite("GENMF003_cTmpAlias.sql",cQuery)
		
		If Select("TMP") > 0
			TMP->(DbCloseArea())
		EndIf
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP", .F., .T.)

		DbSelectArea("TMP")
		
		//BeginSql Alias cTmpAlias
		//	SELECT /*E1_FILIAL,*/E1_PARCELA,E1_TIPO,SUM(E1_SALDO) E1_SALDO,SUM(E1_VALOR) E1_VALOR,MAX(E1_BAIXA) E1_BAIXA,E1_VENCREA,COUNT(*) QTD 
		//	FROM %Table:SE1% SE1
		//	WHERE E1_TIPO = 'NF'
		//	/*AND TO_NUMBER(trim(translate(E1_DOCTEF,%Exp:'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-/.'%,%Exp:''%))) = %Exp:VAL(ALLTRIM(ZZ9->ZZ9_NSU))%*/
		//	AND E1_DOCTEF = %Exp:ALLTRIM(STR(VAL(ALLTRIM(ZZ9->ZZ9_NSU))))%
		//	AND NVL(TRIM(E1_PARCELA),'A') = %Exp:ALLTRIM(ZZ9->ZZ9_PARCEL)%
		//	AND SE1.%NotDel%
		//	GROUP BY /*E1_FILIAL,*/E1_PARCELA,E1_TIPO,E1_VENCREA
		//EndSql		

		TMP->(DbGoTop())
		lMultTitu 	:= TMP->QTD > 1 
		lJaBaixa	:= !Empty(TMP->E1_BAIXA)
		TMP->(DbCloseArea())
				
		nE1Saldo	:= SE1->E1_SALDO 
		nValBx		:= SE1->E1_SALDO
		
		nValDesc	:= 0
		nValAcre	:= 0
		nVlrNoBx	:= 0 // valor nใo baixado

		nSldBx		:= ZZ9->ZZ9_SALDO+ZZ9->ZZ9_STXADM
		nDif		:= (ZZ9->ZZ9_SALDO+ZZ9->ZZ9_STXADM)-SE1->E1_SALDO
		nSldTxAdm	:= ZZ9->ZZ9_STXADM

		//Se saldo pago ้ maior que o saldo do titulo verifico se existe outro titulo compartilhando este valor de pagamento 
		//como por exemplo os casos onde a venda tem quebra de obra digital e impressa
		If nDif > 0
			
			If lMultTitu 
				nValAcre	:= 0
				If lJaBaixa 
					nVlrNoBx	:= nDif
				EndIf	
			Else
				nValAcre	:= nDif	
			EndIf
			
		Else
			
			nValDesc	:= nDif*(-1)
				
		EndIf
        
		nValBx		+= nValAcre
		nValBx		-= nValDesc
		//nValAbat	:= nValBx // vriavel nValAbat por enquanto nใo serแ mais utilizada pois o valor das parcelas jแ vem com o desconto da tx adm
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAbater valor da taxa administrativa do cartใoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nValBx-=nSldTxAdm//ZZ9->ZZ9_TXADM

		
		If nValBx > SE1->E1_SALDO
			Aadd(aLog, {"Falha","Baixa",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Nใo encontrado saldo suficiente em aberto para o titulo "+SE1->E1_NUM+"/"+SE1->E1_PARCELA+", cliente:"+SE1->E1_NOMCLI+", Saldo: "+Transform(SE1->E1_SALDO,PesqPict("SE1","E1_SALDO"))+" valor a baixar "+Transform(nValBx,PesqPict("SE1","E1_SALDO")),SE1->E1_EMISSAO, SE1->E1_VENCREA, ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, SE1->E1_XOPERA,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )
			If !lAuto
				Loop
			Else
				//cMsgErro += "Diverg๊ncia de valores entre Protheus x AccesStage. Protheus: "+AllTrim(Transform(SE1->E1_SALDO,PesqPict("SE1","E1_SALDO")))+" AccesStage: "+AllTrim(Transform(nValBx,PesqPict("SE1","E1_SALDO")))
				nValBx := SE1->E1_SALDO 
			EndIf
		EndIf
	
		/*
		cMOTBX		:= SAE->AE_XMOTBX//"NOR"
		cBANCO		:= SAE->AE_XCODIGO//"104"
		cAGENCIA	:= SAE->AE_XAGENCI//"2834 "
		cCONTA		:= SAE->AE_XCONTA//"00031555  "
		*/
		
		//If lZZ9
			dDtBAIXA	:= ZZ9->ZZ9_DTCRED
			dDTCREDITO	:= ZZ9->ZZ9_DTCRED
		/*Else
			dDtBAIXA	:= SE1->E1_VENCREA
			dDTCREDITO	:= SE1->E1_VENCREA
		EndIf*/
		cHIST		:= "Valor recebido s /Titulo"
		nJUROS		:= 0
		nVALREC		:= nValBx
        	
        Do Case	
  		
  			Case nVALREC > SE1->E1_SALDO-nSldTxAdm .AND. ( nVALREC - (SE1->E1_SALDO-nSldTxAdm) ) <= nMgMais
  				
  				nJUROS	:= ( nVALREC - (SE1->E1_SALDO-nSldTxAdm) )
  				//nVALREC := nVALREC-( nVALREC - (SE1->E1_SALDO-nSldTxAdm) )  				
  				
  			Case nVALREC < SE1->E1_SALDO-nSldTxAdm .AND. ( nVALREC - (SE1->E1_SALDO-nSldTxAdm) ) >= nMgMenos
				
				If (SE1->E1_SALDO-nSldTxAdm)-nVALREC <> nValDesc
	  				nVALREC := SE1->E1_SALDO-nSldTxAdm
	  			EndIf	

        EndCase
        	
        	        
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRealizado a inclusใo do titulo de tx administrativaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aTxAdm		:= {}
		lMSHelpAuto := .t.
		lMsErroAuto := .f.
		 
		cTitPai	:= SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA//Prefixo + N๚mero + Parcela + Tipo + Cliente + Loja
		cNsu	:= SE1->E1_DOCTEF
		//Begin Transaction
		
		If nSldTxAdm > 0
			
			//SE1->(DBSetNickname("TITPAI"))
			//SE1->(DbSetOrder(28))
			//If !SE1->(DbSeek(xFilial("SE1")+cTitPai))
			/* CLEUTO - 17/07/2017 - DBSEEK SUBSTITUIDO PELA QUERY POIS PODEMOS TER MAIS DE UM TITULO POR VENDO E DEVE EXISTIR APENAS UM AB- POR VENDO POIS O MESMO Jม CONTEMPLA O VALOR TOTAL DA TAXA */
			
			lTMP := .F.

			cQuery := "SELECT E1_PARCELA,E1_TIPO,SUM(E1_SALDO) E1_SALDO,SUM(E1_VALOR) E1_VALOR,MAX(E1_BAIXA) E1_BAIXA,E1_VENCREA,COUNT(*) QTD "+CRLF 
			cQuery += "FROM "+RetSqlName("SE1")+" SE1 "+CRLF
			cQuery += "WHERE E1_TIPO = 'AB-' "+CRLF
			cQuery += "AND TO_NUMBER(nvl(TRIM( regexp_replace( regexp_replace(regexp_replace(TRIM(E1_DOCTEF),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)) = "+ALLTRIM(ZZ9->ZZ9_NSU)+" "+CRLF
			cQuery += "AND NVL(TRIM(E1_PARCELA),'A') = '"+ALLTRIM(ZZ9->ZZ9_PARCEL)+"' "+CRLF
			cQuery += "AND SE1.D_E_L_E_T_ = ' ' "+CRLF
			cQuery += "GROUP BY E1_PARCELA,E1_TIPO,E1_VENCREA "+CRLF
			
			MemoWrite("GENMF003_TEMP.sql",cQuery)
			
			If Select("TEMP") > 0
				TEMP->(DbCloseArea())
			EndIf
			
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP", .F., .T.)
	
			DbSelectArea("TEMP")

			/*If Select("TMP_TITAB") > 0
				TMP_TITAB->(DbCloseArea())
			EndIf
		
			BeginSql Alias "TMP_TITAB"
				SELECT E1_PARCELA,E1_TIPO,SUM(E1_SALDO) E1_SALDO,SUM(E1_VALOR) E1_VALOR,MAX(E1_BAIXA) E1_BAIXA,E1_VENCREA,COUNT(*) QTD 
				FROM %Table:SE1% SE1
				WHERE E1_TIPO = 'AB-'
				AND TO_NUMBER(TRIM(E1_DOCTEF)) = %Exp:VAL(ALLTRIM(ZZ9->ZZ9_NSU))%
				AND NVL(TRIM(E1_PARCELA),'A') = %Exp:ALLTRIM(ZZ9->ZZ9_PARCEL)%
				AND SE1.%NotDel%
				GROUP BY E1_PARCELA,E1_TIPO,E1_VENCREA					
			Endsql*/
			
			If TEMP->(EOF())
				lTMP := .T.
			EndIf
			
			If lTMP //.Or. !lZZ9 	
				RestArea(aAreaSE1)
				SE1->(DbGoTo( aDados[nAuxTit][N_SE1REC] ))
				
				SE1->(DbSetOrder(1))
				If !DbSeek(xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+"AB-")
					
					RestArea(aAreaSE1)
					SE1->(DbGoTo( aDados[nAuxTit][N_SE1REC] ))
					
					aTxAdm := {	{ "E1_PREFIXO"  , SE1->E1_PREFIXO	, NIL },;
								{ "E1_NUM"      , SE1->E1_NUM		, NIL },;
								{ "E1_PARCELA"  , SE1->E1_PARCELA	, NIL },;		            
								{ "E1_TIPO"     , "AB-"				, NIL },;
								{ "E1_NATUREZ"  , SE1->E1_NATUREZ	, NIL },;
								{ "E1_CLIENTE"  , SE1->E1_CLIENTE	, NIL },;
								{ "E1_LOJA"		, SE1->E1_LOJA		, NIL },;		            
								{ "E1_EMISSAO"  , SE1->E1_EMISSAO	, NIL },;
								{ "E1_VENCTO"   , SE1->E1_VENCTO	, NIL },;
								{ "E1_VENCREA"  , SE1->E1_VENCREA	, NIL },;
								{ "E1_TITPAI"	, cTitPai			, NIL },;
								{ "E1_VALOR"    , nSldTxAdm			, NIL },;
								{ "E1_OCORREN"	, "04"				, NIL },;
								{ "E1_XINTER"	, "0"	            , NIL },;
								{ "E1_XEDICAO"	, "3"	            , NIL },;
								{ "E1_PEDIDO"	, SE1->E1_PEDIDO	, NIL },;
								{ "E1_XOPERA"	, SE1->E1_XOPERA	, NIL },;
								{ "E1_XBANDEI"	, SE1->E1_XBANDEI	, NIL },;					            
								{ "E1_DOCTEF"	, cNsu				, NIL }}
					
					//Conout("GENMF003 - Gerando titulo AB-. Prefixo: "+SE1->E1_PREFIXO+" Titulo: "+SE1->E1_NUM+" Parcela: "+SE1->E1_PARCELA)
					
					MsExecAuto( { |x,y| FINA040(x,y)} , aTxAdm, 3)  // 3 - Inclusao, 4 - Altera็ใo, 5 - Exclusใo
			
					If lMsErroAuto
						SE1->(DbGoTo( aDados[nAuxTit][N_SE1REC] ))
						cErro := MostraErro("\logsiga\baixasite\","GENMF03C_"+AllTrim(SE1->E1_PREFIXO)+"_"+AllTrim(SE1->E1_NUM)+"_"+AllTrim(SE1->E1_PARCELA)+".log")
						Conout("GENMF003 - Erro na geracao do Titulo AB-. Prefixo: "+SE1->E1_PREFIXO+" Titulo: "+SE1->E1_NUM+" Parcela: "+SE1->E1_PARCELA)
						Aadd(aLog, {"Erro","Baixa",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU, "Nใo foi possํvel incluir o titulo com a taxa da operada de cartใo de credito, motivo: "+chr(13)+chr(10)+cErro,SE1->E1_EMISSAO, SE1->E1_VENCREA, ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, SE1->E1_XOPERA,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )
						
						oExcel:AddRow(cSheet5,cTable5,{;
						SE1->E1_NUM,;
						SE1->E1_PREFIXO,;
						SE1->E1_PARCELA,;
						SE1->E1_DOCTEF,;
						aDados[nAuxTit][N_CODCLI],;
						aDados[nAuxTit][N_LOJCLI],;
						aDados[nAuxTit][N_NOMCLI],;
						DtoC(SE1->E1_EMISSAO),;
						DtoC(SE1->E1_VENCREA),;
						SE1->E1_VALOR,;
						aDados[nAuxTit][N_PEDIDO],;
						AllTrim(SE1->E1_XOPERA),;
						"Erro na geracao do Titulo AB-. Prefixo: "+SE1->E1_PREFIXO+" Titulo: "+SE1->E1_NUM+" Parcela: "+SE1->E1_PARCELA;
						})

						Loop
					EndIf 
				EndIf
			EndIf
			
			If Select("TEMP") > 0
			TEMP->(DbCloseArea())
			EndIf				
			
		EndIf

		RestArea(aAreaSE1)
		SE1->(DbGoTo( aDados[nAuxTit][N_SE1REC] ))
		
		IF nSldTxAdm > 0
			RecLock("SE1",.F.)
			SE1->E1_XTAXCC	:= nSldTxAdm
			MsUnlock()
		ENDIF

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณInicia baixa do tituloณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aBaixa := {}
			
		aBaixa := {{"E1_PREFIXO"	,SE1->E1_PREFIXO	,Nil	},;
					{"E1_NUM"		,SE1->E1_NUM		,Nil	},;
					{"E1_PARCELA"	,SE1->E1_PARCELA	,Nil	},;
					{"E1_CLIENTE"	,SE1->E1_CLIENTE	,Nil	},;
					{"E1_LOJA"		,SE1->E1_LOJA		,Nil	},;		           
					{"E1_TIPO"		,SE1->E1_TIPO		,Nil	},;		           		           
					{"AUTMOTBX"		,cMOTBX				,Nil	},;
					{"AUTBANCO"		,cBANCO				,Nil	},;
					{"AUTAGENCIA"	,cAGENCIA			,Nil	},;
					{"AUTCONTA"		,cCONTA				,Nil	},;
					{"AUTDTBAIXA"	,dDtBAIXA			,Nil	},;
					{"AUTDTCREDITO"	,dDTCREDITO			,Nil	},;
					{"AUTHIST"		,cHIST				,Nil	},;
					{"AUTJUROS"		,nJUROS				,Nil	,.T.	},; 
					{"AUTDESCONT"	,nValDesc			,Nil	,.T.	},; 
					{"AUTVALREC"	,nVALREC			,Nil	}}

		lMSHelpAuto := .t.
		lMsErroAuto := .f.
		
		Begin Transaction
			MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3) 		
			lMSHelpAuto := .F.
			
			If lMsErroAuto
				cErro := MostraErro("\logsiga\baixasite\","GENMF03C_"+AllTrim(SE1->E1_PREFIXO)+"_"+AllTrim(SE1->E1_NUM)+"_"+AllTrim(SE1->E1_PARCELA)+".log")
				Aadd(aLog, {"Erro","Baixa",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,cErro,SE1->E1_EMISSAO, SE1->E1_VENCREA, ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, SE1->E1_XOPERA,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )

				If lAuto
					oExcel:AddRow(cSheet5,cTable5,{;
					SE1->E1_NUM,;
					SE1->E1_PREFIXO,;
					SE1->E1_PARCELA,;
					SE1->E1_DOCTEF,;
					aDados[nAuxTit][N_CODCLI],;
					aDados[nAuxTit][N_LOJCLI],;
					aDados[nAuxTit][N_NOMCLI],;
					DtoC(SE1->E1_EMISSAO),;
					DtoC(SE1->E1_VENCREA),;
					SE1->E1_VALOR,;
					aDados[nAuxTit][N_PEDIDO],;
					AllTrim(SE1->E1_XOPERA),;
					"Verificar arquivo \logsiga\baixasite\GENMF03C_"+AllTrim(SE1->E1_PREFIXO)+"_"+AllTrim(SE1->E1_NUM)+"_"+AllTrim(SE1->E1_PARCELA)+".log";
					})
					
					lMail := .T.
				EndIf
			Else
				If lAuto
					//Incli linhas no excel da rotina GENA089 (baixa de titulos automatica) [Parreira,18/06/2019]
					//If aDados[nAuxTit][N_ZZ9SIT] <> "2" .Or. SE1->E1_SALDO > 0
						cMsgErro := "" 
						
						aDif := DifValor(AllTrim(SE1->E1_DOCTEF),SE1->E1_PARCELA)
						
						If Len(aDif) > 0
							lDifVal := .T.
						else
							lDifVal := .F.
						EndIf

						If lDifVal .Or. SE1->E1_SALDO > 0
							If lDifVal
								cMsgErro += " Inconsist๊ncia de valores entre Protheus x AccesStage. "
							EndIf
							
							If SE1->E1_SALDO > 0
								cMsgErro += " Saldo pendente a ser baixado no tํtulo: "+Transform(SE1->E1_SALDO,PesqPict("SE1","E1_SALDO"))
							EndIf
							
							oExcel:AddRow(cSheet,cTable,{;
							SE1->E1_NUM,;
							SE1->E1_PREFIXO,;
							SE1->E1_PARCELA,;
							SE1->E1_DOCTEF,;
							aDados[nAuxTit][N_CODCLI],;
							aDados[nAuxTit][N_LOJCLI],;
							aDados[nAuxTit][N_NOMCLI],;
							DtoC(SE1->E1_EMISSAO),;
							DtoC(SE1->E1_VENCREA),;
							SE1->E1_VALOR,;
							aDados[nAuxTit][N_PEDIDO],;
							AllTrim(SE1->E1_XOPERA),;
							aDados[nAuxTit][N_VALBRU],;
							IF(!Empty(cMsgErro),cMsgErro,"Inconsist๊ncia entre protheus x AccesStage.");
							})
							
							If AllTrim(SE1->E1_DOCTEF) <> AllTrim(cNSUProc)
								oExcel:AddRow(cSheet2,cTable2,{;
								SE1->E1_DOCTEF,;
								SE1->E1_PARCELA,;
								DtoC(ZZ9->ZZ9_DTVEND),;
								DtoC(ZZ9->ZZ9_DTCRED),;
								aDif[1],;
								aDif[2],;
								aDif[1]-aDif[2];
								})
							EndIf

							lMail := .T.
						EndIf

						cNSUProc := SE1->E1_DOCTEF
					//EndIf
				EndIf
				
				ZZ9->(DbGoTo( aDados[nAuxTit][N_ZZ9REC] ))
				RecLock("ZZ9",.F.)
				ZZ9->ZZ9_SALDO	:= ZZ9->ZZ9_SALDO-nVALREC//nValAbat : VARIAVEL nValAbat voi substituida pelo valor liquido da baixa pois o valor da parcela enviado pelas operadores jแ contempla o abatimento da tx administrativa
				ZZ9->ZZ9_CONCIL	:= IIF( ZZ9->ZZ9_SALDO-nVlrNoBx > 0 , ZZ9->ZZ9_CONCIL , "1" ) 
				ZZ9->ZZ9_STXADM	:= ZZ9->ZZ9_STXADM-nSldTxAdm				
				If ZZ9->ZZ9_SALDO > 0 .AND. ZZ9->ZZ9_CONCIL == "1"
					ZZ9->ZZ9_MSG	:= "Concilia็ใo realizada mas resta saldo em aberto por diferen็a de recebimento protheus x acesstage!"
				EndIf
				MsUnLock()
					
				Aadd(aLog, {"Sucesso","Baixa",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU, "Titulo baixado com sucesso.",SE1->E1_EMISSAO, SE1->E1_VENCREA, ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, SE1->E1_XOPERA,SE1->E1_CLIENTE,SE1->E1_LOJA,nVALREC-nValDesc  } )
			
			EndIf
		End Transaction	
		//End Transaction
		
		cFilAnt	:= cFilBkp
		SM0->(DbSeek( cEmpAnt+cFilBkp ))

	EndIf

Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณIniciado processamento de estornosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// AGUARDANDO RETORNO DA ACESSTA
//Processa({|| GENMF03D(@aLog) },"Processado estornos...")	
If !lAuto
	If !Empty(aLog)
		ViewLog(aLog)
	EndIf	
EndIf

Return nil 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF003  บAutor  ณMicrosiga           บ Data ณ  01/10/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcEstono()

Local aLog:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณIniciado processamento de estornosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({|| GENMF03D(@aLog,.T.) },"Processado estornos...")	

If !Empty(aLog)
	ViewLog(aLog)
EndIf

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF003  บAutor  ณMicrosiga           บ Data ณ  01/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GENMF03D(aLog,lPerg)

Local cAliEstAux	:= GetNextAlias()
Local nTotReg		:= 0
Local nValTot		:= 0
Local nValLiq		:= 0  
Local nValSld		:= 0 
Local nSldaBx		:= 0
Local lEstorna		:= .T.
Local lContinua		:= .T.
Local cTmpZZ9		:= nil
Local aTitAux		:= {}

Local cSituac		:= nil
Local cMsg			:= nil
Local cConsil		:= nil

Default lPerg	:= .F.
// cleuto lima - 04/05/2017 rotina parada por inconsistencia de informa็ใo nos registros de estorno da acessateg, estamos aguardando retorno do fornecedor
Return .F.

If lPerg
	If !MsgYesno("Confirmar processamento dos estornos?")
		Return nil
	EndIf
EndIf
	
BeginSql Alias cAliEstAux
	SELECT ZZ9.R_E_C_N_O_ RECZZ9,ZZ9_NSU,ZZ9_DTCRED FROM %Table:ZZ9% ZZ9
	WHERE ZZ9_FILIAL = %xFilial:ZZ9%
	AND ZZ9_TIPO = '12'
	AND ZZ9_SALDO < 0
	AND ZZ9.ZZ9_CONCIL <> '1' 
	AND ZZ9_DTCRED <= %Exp:DtoS(DDataBase)%
	AND ZZ9.%NotDel%
	ORDER BY ZZ9_DTCRED 
EndSql

(cAliEstAux)->(DbGoTop())

nTotReg := Contar(cAliEstAux, "!EOF()")
ProcRegua(nTotReg)
IncProc("Iniciando processamento dos estornos...")

(cAliEstAux)->(DbGoTop())

If (cAliEstAux)->(!EOF())
	cTmpZZ9		:= GetNextAlias()
EndIf	

While (cAliEstAux)->(!EOF())
	
	ZZ9->(DbGoTo( (cAliEstAux)->RECZZ9 ))
	lEstorna	:= .F.
	nValTot		:= 0	
	
	// reprocessa a situa็ใo do registro
	If ZZ9->ZZ9_SITUAC <> "2"
		cConsil	:= ZZ9->ZZ9_CONCIL
		cSituac	:= ZZ9->ZZ9_SITUAC//1=Nao validado;2=Consistente;3=Inconsistente
		cMsg	:= ZZ9->ZZ9_MSG
			
		U_GENMF04E(cTmpZZ9,ZZ9->ZZ9_NSU,ZZ9->ZZ9_PARCEL,(ZZ9->ZZ9_LIGPAG+ZZ9->ZZ9_STXADM),ZZ9->ZZ9_DTCRED,@cSituac,@cMsg,ZZ9->ZZ9_TIPO,@cConsil)	
		
		Reclock("ZZ9",.F.)
		ZZ9->ZZ9_SITUAC	:= cSituac//1=Nao validado;2=Consistente;3=Inconsistente
		ZZ9->ZZ9_MSG	:= cMsg
		ZZ9->ZZ9_CONCIL	:= cConsil
		MsUnLock() 

		If ZZ9->ZZ9_SITUAC <> "2"
			Aadd(aLog, {"Erro","Estorno","","","", ZZ9->ZZ9_NSU , cMsg, CtoD("  /  /  "), CtoD("  /  /  "), ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, "","","",0 } )
		EndIf		
		
	EndIf

	If ZZ9->ZZ9_SITUAC <> "2"
		(cAliEstAux)->(DbSkip())
		Loop
	EndIf
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRastreando as vendasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If Select("BUSCA_VEND") > 0
		BUSCA_VEND->(DbCloseArea())
	EndIf
	
	BeginSql Alias "BUSCA_VEND"
		SELECT E1_VALOR,E1_VALLIQ,SE1.R_E_C_N_O_ RECSE1,E1_SALDO
		FROM %Table:SE1% SE1
		WHERE TO_NUMBER(TRIM(E1_DOCTEF)) = %Exp: VAL(ALLTRIM(ZZ9->ZZ9_NSU)) %
		AND E1_TIPO = 'NF'
		AND SE1.%NotDel%
	EndSql
	
	BUSCA_VEND->(DbGoTop())
	BUSCA_VEND->(DbEval( {|| nValTot+=BUSCA_VEND->E1_VALOR,nValLiq += BUSCA_VEND->E1_VALLIQ,nValSld+=BUSCA_VEND->E1_SALDO, Aadd(aTitAux, { SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI } ) }))
	BUSCA_VEND->(DbGoTop())
	
	Do Case 
		Case nValTot == 0

			Aadd(aLog, {"Alerta","Estorno","","","",ZZ9->ZZ9_NSU, "Nใo foram identificados titulos para este estorno, o mesmo serแ finalizado com alertas!", CtoD("  /  /  "), CtoD("  /  /  "), ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, "","","",0 } )
			
			ZZ9->ZZ9_MSG	:= "Nใo foram identificados titulos para este estorno, seu status serแ alterado para conciliado com alertas e seu saldo ficarแ em aberto!"
			ZZ9->ZZ9_CONCIL	:= "1"			
		/*// cleuto - 19/04/2017 - os valores das baixas podem ser diferentes do valor da venda e o titulo de NCC nใo mais serแ compensado e sim baixado com o mesmo motivo de baixa do cartใo de credito
		
		//Case nValLiq <> ZZ9->ZZ9_LIGPAG*(-1) // NESTE CASO EU VALIDO APENAS O VALOR LIQUIDO POGO POIS NO VALOR LIQ DO TITULO NรO CONSTA A TAXA ADM DO CARTรO
		Case nValTot <> (ZZ9->ZZ9_SALDO*(-1))+ZZ9->ZZ9_STXADM // ESTOU VALIDANDO O VALOR POIS PODEMOS TER TITULOS ONDE A BX VOI EXCLUIDA MANUALMENTE
			
			Aadd(aLog, {"Erro","Estorno","","",SE1->E1_NOMCLI,ZZ9->ZZ9_NSU, "Valor informado para estorno ้ diferen็a do valor dos titulos existentes na base!", CtoD("  /  /  "), CtoD("  /  /  "), ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, "",SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )
		*/	
		OtherWise
	        
			lEstorna	:= .T.

	EndCase
		
	If lEstorna
		
		BaixaNCC(ZZ9->(Recno()),BUSCA_VEND->RECSE1,@aLog)
		
		/*
			
		Cleuto - 09/04/2017 - Nใo mais serแ realizada compensa็ใo da NCC, agora a NCC deve ser baixada com saldo negativo com o mesmo motivo de baixa do titulo da venda	
			
		If BUSCA_VEND->(!EOF())
			
			SE1->(DbGoto( BUSCA_VEND->RECSE1 ))
			
			lContinua := CancBaixas(BUSCA_VEND->RECSE1,@aLog)
			
			If lContinua
				
				aEval(aTitAux, {|x| Aadd(aLog, {"Sucesso","Estorno",x[1],x[2],x[3],ZZ9->ZZ9_NSU, "Estorno de baixas realizado com sucesso!", CtoD("  /  /  "), CtoD("  /  /  "), ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, "","","",0 } ) } )
				
				lContinua	:= CompenTit(BUSCA_VEND->RECSE1,nValTot,@aLog)

			EndIf

			If lContinua
				
				aEval(aTitAux, {|x| Aadd(aLog, {"Sucesso","Estorno",x[1],x[2],x[3],ZZ9->ZZ9_NSU, "Compesa็ใo de titulos realizada com sucesso!", CtoD("  /  /  "), CtoD("  /  /  "), ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, "","","",0 } ) } )

				Reclock("ZZ9",.F.)
				ZZ9->ZZ9_MSG	:= " "
				ZZ9->ZZ9_CONCIL	:= "1"
				ZZ9->ZZ9_SALDO	:= 0
				ZZ9->ZZ9_STXADM	:= 0
				MsUnLock()				
				
			EndIf

			BUSCA_VEND->(DbSkip())
		EndIf
		*/
		
	EndIf
	
	BUSCA_VEND->(DbCloseArea())
	(cAliEstAux)->(DbSkip())
EndDo

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณViewLog   บAutor  ณMicrosiga           บ Data ณ  02/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ViewLog(aLog)

Local oReport

oReport := ReportDef(aLog)
oReport:printDialog()

Return

Static function ReportDef(aLog)

local oReport
local cTitulo	:= "Log de processamento"
local cPerg		:= ""

oReport := TReport():New(FunName(), cTitulo, cPerg , {|oReport| PrintReport(oReport,aLog)})

oReport:SetLandScape()

oReport:SetTotalInLine(.F.)

oReport:ShowHeader()

oSection0 := TRSection():New(oReport,"Mensagens",{""})

TRCell():New(oSection0,"Status"		,,"Status",		,045)
TRCell():New(oSection0,"Tipo"		,,"Tipo",		,045)
TRCell():New(oSection0,"TITULO"		,,"Titulo",		,045)
TRCell():New(oSection0,"PARCELA"	,,"Parcela",	,045)

TRCell():New(oSection0,"CODCLI"		,,"Cod.",	,150)
TRCell():New(oSection0,"LOJCLI"		,,"Loja",	,150)

TRCell():New(oSection0,"CLIENTE"	,,"Cliente",	,150)

TRCell():New(oSection0,"EMISSAO"	,,"Dt.Emissใo",	,045)
TRCell():New(oSection0,"VENCIME"	,,"Dt.Vencto",	,045)
TRCell():New(oSection0,"BAIXA"		,,"Dt.Baixa",	,045)
TRCell():New(oSection0,"VALBAIXA"	,,"Val.Baixa",X3Picture("E1_VALOR"),045)
TRCell():New(oSection0,"VALBRUT"	,,"Val.Bruto",X3Picture("E1_VALOR"),045)
TRCell():New(oSection0,"VALTXCC"	,,"Val.Tx.CC",X3Picture("E1_VALOR"),045)
TRCell():New(oSection0,"VALLIQ"		,,"Val.Liqui.",X3Picture("E1_VALOR"),045)
TRCell():New(oSection0,"OPERA"		,,"Operadora",	,045)

TRCell():New(oSection0,"NSU"		,,"NSU",		,100)
TRCell():New(oSection0,"MENSAGEM"	,,"Mensagem",	,300)

return (oReport)


Static Function PrintReport(oReport,aLog)

Local oSection0 := oReport:Section(1)
Local aTotais	:= {0,0,0,0}

For nx:=1 To Len(aLog)
 
 oReport:IncMeter()
 
 oSection0:Init()
 
 oSection0:Cell("TIPO"):SetValue(aLog[nx][1])
 oSection0:Cell("STATUS"):SetValue(aLog[nx][2])
 oSection0:Cell("TITULO"):SetValue(aLog[nx][3])
 oSection0:Cell("PARCELA"):SetValue(aLog[nx][4])
 oSection0:Cell("CODCLI"):SetValue(aLog[nx][15])
 oSection0:Cell("LOJCLI"):SetValue(aLog[nx][16])
  
 oSection0:Cell("CLIENTE"):SetValue(aLog[nx][5])
 oSection0:Cell("NSU"):SetValue(aLog[nx][6])
 oSection0:Cell("MENSAGEM"):SetValue(aLog[nx][7])
 
 aTotais[1]+=aLog[nx][11]
 aTotais[2]+=aLog[nx][12]
 aTotais[3]+=aLog[nx][13]
 aTotais[3]+=aLog[nx][17]
  
 oSection0:Cell("EMISSAO"):SetValue(aLog[nx][8])
 oSection0:Cell("VENCIME"):SetValue(aLog[nx][9])
 oSection0:Cell("BAIXA"):SetValue(aLog[nx][10])
 oSection0:Cell("VALBAIXA"):SetValue(aLog[nx][17])
 oSection0:Cell("VALBRUT"):SetValue(aLog[nx][11])
 oSection0:Cell("VALTXCC"):SetValue(aLog[nx][12])
 oSection0:Cell("VALLIQ"):SetValue(aLog[nx][13])
 oSection0:Cell("OPERA"):SetValue(aLog[nx][14])

 oSection0:PrintLine()      
  
Next nx

oReport:SkipLine()
oReport:FatLine()
	
oSection0:Cell("TIPO"):SetValue(" ")
oSection0:Cell("STATUS"):SetValue("SUBTOTAL")
oSection0:Cell("TITULO"):SetValue(" ")
oSection0:Cell("PARCELA"):SetValue(" ")
oSection0:Cell("CODCLI"):SetValue(" ")
oSection0:Cell("LOJCLI"):SetValue(" ")
oSection0:Cell("CLIENTE"):SetValue(" ")
oSection0:Cell("NSU"):SetValue(" ")
oSection0:Cell("MENSAGEM"):SetValue(" ")
oSection0:Cell("EMISSAO"):SetValue(" ")
oSection0:Cell("VENCIME"):SetValue(" ")
oSection0:Cell("BAIXA"):SetValue(" ")
oSection0:Cell("OPERA"):SetValue(" ")
  
oSection0:Cell("VALBRUT"):SetValue(aTotais[1])
oSection0:Cell("VALTXCC"):SetValue(aTotais[2])
oSection0:Cell("VALLIQ"):SetValue(aTotais[3])
oSection0:Cell("VALBAIXA"):SetValue(aTotais[4])
 
oSection0:PrintLine()   
 
oSection0:Finish()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF003  บAutor  ณMicrosiga           บ Data ณ  01/09/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CancBaixas(nSalvRec,aLog,nSldaBx) 

Local cAlias		:= Alias()    
Local lRet			:= .F.
Local _aCabec		:= {}
Local cQuery		:= ""
Local aArea			:= GetArea()
Local aAreaSE1		:= SE1->(GetArea())
Local aAreaSM0		:= SM0->(GetArea())
Local nTotAbat 		:= 0
Local nValPadrao	:= 0
Local dBkpData 		:= DDataBase
Local lSavTTS		:= __TTSInUse // Salvo o Estado atual do MV_TTS

__TTSInUse := .T. // Ativo o MV_TTS

DbSelectArea("SE1")

SE1->( DbGoTo( nSalvRec ) )
nSaldo		:= 0
aBaixa		:= {}
aBaixaSE5	:= {}
aBaixa		:= Sel070Baixa( "VL /V2 /BA /RA /CP /LJ /"+MV_CRNEG,SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA,SE1->E1_TIPO,,,SE1->E1_CLIENTE,SE1->E1_LOJA,@nSaldo,,,)
SE1->( DbGoTo( nSalvRec ) )

_aCabec      := {}
Aadd(_aCabec, {"E1_PREFIXO"		, SE1->E1_PREFIXO	, nil})
Aadd(_aCabec, {"E1_NUM"			, SE1->E1_NUM		, nil})
Aadd(_aCabec, {"E1_PARCELA"		, SE1->E1_PARCELA	, nil})
Aadd(_aCabec, {"E1_TIPO"		, SE1->E1_TIPO		, nil})
Aadd(_aCabec, {"E1_CLIENTE"		, SE1->E1_CLIENTE	, nil})
Aadd(_aCabec, {"E1_LOJA"		, SE1->E1_LOJA		, nil})

nSalvRec	:=	SE1->(Recno())
dDatabase	:=	SE1->E1_BAIXA

If SM0->M0_CODFIL <> SE1->E1_FILIAL
	cFilAnt := SE1->E1_FILIAL
	SM0->( DbSeek (SM0->M0_CODIGO + SE1->E1_FILIAL) )
Endif

If !Empty(SE1->E1_BAIXA)
   dDataBase := SE1->E1_BAIXA
Endif

lMsErroAuto := .F.
If Len(aBaixa) > 0
	Begin Transaction      
	
		If Len(aBaixa) == 1
		
		   MSExecAuto({|x,y| fina070(x,y)},_aCabec,5,52)
	
			IF lMsErroAuto		
				cErro := MostraErro(GetTempPath(), "GENMF03C.log" )
				Aadd(aLog, {"Erro","Estorno",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Falha ao tentar excluir a baixa do titulo!"+Chr(13)+Chr(10)+cErro,SE1->E1_EMISSAO, SE1->E1_VENCREA, ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, SE1->E1_XOPERA,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )
				DisarmTransaction()		   
				lRet		:= .F.		   
			Else		
				lRet	:= .T.			
			Endif
			   
		Else
		
			aSort(aBaixaSE5,,, { |x,y| x[9] > y[9] } ) // Ordeno por seq
			
			For nxy := 1 To Len(aBaixaSE5)	
				nQualBaixa	:= Val(aBaixaSE5[nxy][9]) // seq
				dDataBase	:= aBaixaSE5[nxy][7] // data da baixa
				MSExecAuto({|x,w,y,z| fina070(x,w,y,z)},_aCabec,5,,nQualBaixa ) //Cancelamento baixa
				
				IF lMsErroAuto					   
					cErro := MostraErro(GetTempPath(), "GENMF03C.log" )
					Aadd(aLog, {"Erro","Estorno",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Falha ao tentar excluir a baixa do titulo!"+Chr(13)+Chr(10)+cErro,SE1->E1_EMISSAO, SE1->E1_VENCREA, ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, SE1->E1_XOPERA,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )
					//DisarmTransaction()
					lRet := .F.
				Else
					lRet := .T.			
				Endif			
				
		    Next
		    
		Endif
		
	End Transaction
Else	
	// nใo a baixas a estornar
	lRet	:= .T.	
EndIf	
SE1->( dbGoTo( nSalvRec ) )

__TTSInUse := lSavTTS // Restauro o Estado do MV_TTS

SE1->(RestArea(aAreaSE1))
RestArea(aArea)
DDataBase := dBkpData

Return lRet 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF003  บAutor  ณMicrosiga           บ Data ณ  01/09/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TestComp()

Local nSalvRec	:= 160669
Local nValTot	:= 0
Local aLog		:= {}

RpcSetType(2)
RpcSetEnv( "00" , "1022")


SE1->(DbGoto( 160669 ))
nValTot	:= SE1->E1_VALOR
CompenTit(nSalvRec,nValTot,@aLog)

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF003  บAutor  ณMicrosiga           บ Data ณ  01/09/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function CompenTit(nSalvRec,nValTot,aLog)

Local cNatCart	:= GetMv("GENI018CAR") //NATUREZA PARA CARTAO DE CREDITO

Local lRet		:= .T.
Local aArea		:= GetArea()
Local nTaxaCM	:= 0
Local aTxMoeda	:= {} 
Local aRecNCC	:= {} 
Local aRecSE1	:= {}
Local nMoeda	:= 0

Local lContabiliza	:= nil
Local lAglutina		:= nil
Local lDigita		:= nil
Local nTaxaCM		:= 0 
Local nNCCSld		:= 0
Local aTxMoeda		:= {}

Private nRecnoNDF
Private nRecnoE1

SE1->(DbgoTo(nSalvRec))
nMoeda	:= SE1->E1_MOEDA

If Select("BUSCA_NCC") >0 
	BUSCA_NCC->(DbCloseArea())
EndIf

BeginSql Alias "BUSCA_NCC"
	
	SELECT SE1B.R_E_C_N_O_ RECNCC,SE1B.E1_SALDO SALDO
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
	AND TRIM(SE1.E1_DOCTEF) = %Exp: AllTrim(SE1->E1_DOCTEF) %
	AND SE1.E1_NATUREZ = %Exp:cNatCart%
	AND SE1.%NotDel%
	GROUP BY SE1B.R_E_C_N_O_,SE1B.E1_SALDO
	
EndSql

BUSCA_NCC->(DbGoTop())
BUSCA_NCC->(DbEval( {|| nNCCSld+= BUSCA_NCC->SALDO,Aadd(aRecNCC, BUSCA_NCC->RECNCC ) } ))

BUSCA_NCC->(DbCloseArea())

BeginSql Alias "BUSCA_NCC"
	
	SELECT SE1.R_E_C_N_O_ RECSE1
	FROM %Table:SE1% SE1
	WHERE SE1.E1_TIPO = 'NF'
	AND SE1.E1_DOCTEF = %Exp: SE1->E1_DOCTEF %
	AND SE1.E1_NATUREZ = %Exp:cNatCart%
	AND SE1.%NotDel%
	
EndSql

BUSCA_NCC->(DbGoTop())
BUSCA_NCC->(DbEval( {|| Aadd(aRecSE1, BUSCA_NCC->RECSE1 ) } ))

If Len(aRecNCC) == 0

	Aadd(aLog, {"Erro","Estorno",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Nใo foi localizado saldo de NCC para realizar a compensa็ใo!",SE1->E1_EMISSAO, SE1->E1_VENCREA, CtoD("  /  /  "), 0, 0, 0, SE1->E1_XOPERA,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )	
	Return .F.

ElseIf nNCCSld <> nValTot
	
	Aadd(aLog, {"Erro","Estorno",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Valor da NCC diferente do valor da venda! Venda R$:"+AllTrim(Transform(nValTot, "@E 999,999,999.99"))+", NCC: "+Transform(nNCCSld, "@E 999,999,999.99"),SE1->E1_EMISSAO, SE1->E1_VENCREA, CtoD("  /  /  "), 0, 0, 0, SE1->E1_XOPERA,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )
	Return .F.	
	
EndIf

DbSelectArea("SE1")
PERGUNTE("AFI340",.F.)

lContabiliza	:= MV_PAR11 == 1
lAglutina		:= MV_PAR08 == 1
lDigita			:= MV_PAR09 == 1
nTaxaCM			:= RecMoeda(dDataBase,nMoeda)   

aAdd(aTxMoeda, {1, 1} )
aAdd(aTxMoeda, {2, nTaxaCM} )

SE1->(dbSetOrder(1)) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_FORNECE+E1_LOJA
SE1->(DbgoTo(nSalvRec))

If !MaIntBxCR(3,aRecSE1,,aRecNCC,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,,dDatabase )
	Help("XAFCMPAD",1,"HELP","XAFCMPAD","Nใo foi possํvel a compensa็ใo"+CRLF+" do titulo NCC",1,0)
	lRet := .F.
EndIf

RestArea(aArea)

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF003  บAutor  ณMicrosiga           บ Data ณ  01/16/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENMF03H(lAuto,nRecno)

Local cAliRep	:= GetNextAlias()
Local cTmpZZ9	:= GetNextAlias()
Local nValLig	:= 0
Local cSituac	:= "2"
Local cMsg		:= ""
Local cNatCart	:= GetMv("GENI018CAR") //NATUREZA PARA CARTAO DE CREDITO
Local cConsil	:= ""
Local nTotReg	:= 0 
Local nCount	:= 0

Default lAuto  := .F.
DeFault nRecno := 0

/*
If !MsgYesNo("Confirma o reprocessamento dos registros nใo conciliados?")
	Return .F.
EndIf
*/

If !lAuto
	PutSx1("GENMF03E","01","De Dt.Credito"		,"","","mv_ch1" ,"D",08,0,0,"G","","","","","mv_par01" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
	PutSx1("GENMF03E","02","At้ Dt.Credito"		,"","","mv_ch2" ,"D",08,0,0,"G","","","","","mv_par02" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
	
	If !Pergunte("GENMF03E",.T.)
		Return .F.
	endIf
	
	DbSelectarea("ZZ9")
	
	BeginSql Alias cAliRep
		SELECT ZZ9.R_E_C_N_O_ RECZZ9 FROM ZZ9000 ZZ9
		WHERE ZZ9_FILIAL = %xFilial:ZZ9%
		AND ZZ9_CONCIL = '2'
		AND ZZ9.ZZ9_SITUAC <> '2'
		AND ZZ9_DTCRED BETWEEN %EXP: DtoS(mv_par01) % AND %EXP: DtoS(mv_par02) %  
		AND ZZ9.%NotDel%
	EndSql
Else
	BeginSql Alias cAliRep
		SELECT ZZ9.R_E_C_N_O_ RECZZ9 FROM ZZ9000 ZZ9
		WHERE ZZ9_FILIAL = %xFilial:ZZ9%
		AND ZZ9_CONCIL = '2'
		AND ZZ9.ZZ9_SITUAC <> '2'
		AND R_E_C_N_O_ = %EXP: nRecno %  
		AND ZZ9.%NotDel%
	EndSql
EndIf	

(cAliRep)->(DbGotop())
nTotReg := Contar(cAliRep, "!EOF()")
ProcRegua(nTotReg)
(cAliRep)->(DbGotop())

While (cAliRep)->(!EOF())
	nCount++
	IncProc("Processando "+StrZero(nCount,6)+" de "+StrZero(nTotReg,6))
	ZZ9->(DbGoTo( (cAliRep)->RECZZ9 ))	
    
	RecLock("ZZ9",.F.)
	
	//nValLig := (ZZ9->ZZ9_LIGPAG+ZZ9->ZZ9_STXADM)
	nValLig := (ZZ9->ZZ9_SALDO+ZZ9->ZZ9_STXADM)
	cConsil	:= ZZ9->ZZ9_CONCIL
	If 	ZZ9->ZZ9_TIPO == "11" // pagamento
		U_GENMF04D(cTmpZZ9,ZZ9->ZZ9_NSU,ZZ9->ZZ9_PARCEL,nValLig,ZZ9->ZZ9_DTCRED,@cSituac,@cMsg,ZZ9->ZZ9_TIPO,@cConsil,ZZ9->ZZ9_OPERA,ZZ9->ZZ9_TXADM,ZZ9->ZZ9_VALBRUT,ZZ9->ZZ9_PRODUT,ZZ9->ZZ9_DTVEND)
	ElseIf 	ZZ9->ZZ9_TIPO == "12" // estorno
		U_GENMF04E(cTmpZZ9,ZZ9->ZZ9_NSU,ZZ9->ZZ9_PARCEL,nValLig,ZZ9->ZZ9_DTCRED,@cSituac,@cMsg,ZZ9->ZZ9_TIPO,@cConsil,ZZ9->ZZ9_OPERA,ZZ9->ZZ9_TXADM,ZZ9->ZZ9_VALBRUT,ZZ9->ZZ9_PRODUT)
	EndIf
		
	ZZ9->ZZ9_SITUAC	:= cSituac//1=Nao validado;2=Consistente;3=Inconsistente
	ZZ9->ZZ9_MSG	:= cMsg
	ZZ9->ZZ9_CONCIL	:= cConsil
				
	MsUnLock()
					
	If Select(cTmpZZ9) > 0
		(cTmpZZ9)->(DbCloseArea())
	EndIf
					
	(cAliRep)->(DbSkip())
EndDo

(cAliRep)->(DbClosearea())
	
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


Static Function xAlterTit(nRecSE1Aux,nRecZZ9Aux)

Local _nOPCA	:= 0
Local nValLig 	:= 0
Local cConsil	:= ""
Local cMsg		:= ""
Local cTmpZZ9	:= ""
Local cSituac	:= "2"

SE1->(DbGoTo( nRecSE1Aux ))
ZZ9->(DbGoTo( nRecZZ9Aux ))	

//_nOPCA	:= FA040Alter("SE1",nRecSE1Aux,4)

_nOPCA	:= FinA040(nil, 4, nil,nil)

cTmpZZ9	:= GetNextAlias()    
RecLock("ZZ9",.F.)

nValLig := (ZZ9->ZZ9_LIGPAG+ZZ9->ZZ9_STXADM)
cConsil	:= ZZ9->ZZ9_CONCIL
If 	ZZ9->ZZ9_TIPO == "11" // pagamento
	U_GENMF04D(cTmpZZ9,ZZ9->ZZ9_NSU,ZZ9->ZZ9_PARCEL,nValLig,ZZ9->ZZ9_DTCRED,@cSituac,@cMsg,ZZ9->ZZ9_TIPO,@cConsil,ZZ9->ZZ9_OPERA,ZZ9->ZZ9_TXADM,ZZ9->ZZ9_VALBRUT,ZZ9->ZZ9_PRODUT,ZZ9->ZZ9_DTVEND)
ElseIf 	ZZ9->ZZ9_TIPO == "12" // estorno
	U_GENMF04E(cTmpZZ9,ZZ9->ZZ9_NSU,ZZ9->ZZ9_PARCEL,nValLig,ZZ9->ZZ9_DTCRED,@cSituac,@cMsg,ZZ9->ZZ9_TIPO,@cConsil,ZZ9->ZZ9_OPERA,ZZ9->ZZ9_TXADM,ZZ9->ZZ9_VALBRUT,ZZ9->ZZ9_PRODUT)
EndIf
	
ZZ9->ZZ9_SITUAC	:= cSituac//1=Nao validado;2=Consistente;3=Inconsistente
ZZ9->ZZ9_MSG	:= cMsg
ZZ9->ZZ9_CONCIL	:= cConsil
			
MsUnLock()
	
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


Static Function ExportGrid(aDados)

Local cSheet	:= "Concilia็ใo de Cartใo"
Local cTable	:= "Concilia็ใo de Cartใo"

Local cArquivo	:= "CONCIL_CARTAO_"+DtoS(DDataBase)+StrTran(Time(),":","")+".xls"
Local oExcel 	:= FWMSEXCEL():New()
Local cPath		:= GetTempPath() //Diretorio de gravacao de arquivos
Local lMail		:= .F.

If !ApOleClient( 'MsExcel' )
	MsgAlert( 'MsExcel nao instalado' )
	Return
EndIf

oExcel:AddworkSheet(cSheet)
oExcel:AddTable (cSheet,cTable)

//Alinhamento da coluna ( 1-Left,2-Center,3-Right )  //Codigo de formata็ใo ( 1-General,2-Number,3-Monetแrio,4-DateTime )
		
oExcel:AddColumn(cSheet,cTable,"Filial"	   			,1,1)
oExcel:AddColumn(cSheet,cTable,"No.Titulo"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"Parcela"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"Nome Cliente"	   	,1,1)
oExcel:AddColumn(cSheet,cTable,"Dt.Emissao"	   		,2,4)
oExcel:AddColumn(cSheet,cTable,"Vencto.Real"	   	,2,4)
oExcel:AddColumn(cSheet,cTable,"Vlr.Titulo"	   		,3,3)
oExcel:AddColumn(cSheet,cTable,"Saldo"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"Vlr.Tot.Parcela"	,3,3)
oExcel:AddColumn(cSheet,cTable,"Vlr.Tot.Venda"	   	,3,3)
oExcel:AddColumn(cSheet,cTable,"Ped.Protheus/Web"	,1,1)
oExcel:AddColumn(cSheet,cTable,"DT Baixa"	   		,2,4)
oExcel:AddColumn(cSheet,cTable,"NSU"	   			,1,1)
oExcel:AddColumn(cSheet,cTable,"#Val.Bruto"	   		,3,3)
oExcel:AddColumn(cSheet,cTable,"#Val.Liq.Pag"	   	,3,3)
oExcel:AddColumn(cSheet,cTable,"#Saldo Liq.Pago"	,3,3)
oExcel:AddColumn(cSheet,cTable,"#Sld.Tx.Adm."	   	,3,3)
oExcel:AddColumn(cSheet,cTable,"#Val.Tx.Adm."	   	,3,3)
oExcel:AddColumn(cSheet,cTable,"#DT.Venda"	   		,2,4)
oExcel:AddColumn(cSheet,cTable,"#DT.Credito"	   	,2,4)
oExcel:AddColumn(cSheet,cTable,"#Operadora"	   		,2,1)
oExcel:AddColumn(cSheet,cTable,"Bandeira"	   		,2,1)
oExcel:AddColumn(cSheet,cTable,"#Conciliado"	   	,1,1)
oExcel:AddColumn(cSheet,cTable,"#Mensagem"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"#Resumo vendas"	   	,1,1)
oExcel:AddColumn(cSheet,cTable,"#Qtd.Parcela"	   	,1,1)


For nAuxExp := 1 To Len(aDados)

		oExcel:AddRow(cSheet,cTable,{;		
		aDados[nAuxExp][N_FILIAL],;		//"Filial"
		aDados[nAuxExp][N_NUM],;		//"No.Titulo"
		aDados[nAuxExp][N_PARCELA],;	//"Parcela"
		aDados[nAuxExp][N_NOMCLI],;		//"Nome Cliente"
		aDados[nAuxExp][N_EMISSAO],;	//"Dt.Emissao"
		aDados[nAuxExp][N_VENCREA],;	//"Vencto.Real"
		aDados[nAuxExp][N_VALOR],;		//"Vlr.Titulo"
		aDados[nAuxExp][N_SALDO],;		//"Saldo"
		aDados[nAuxExp][N_TOT_PAR],;	//"Vlr.Tot.Parcela"		
		aDados[nAuxExp][N_VENDA],;		//"Vlr.Tot.Venda"
		aDados[nAuxExp][N_PEDIDO],;		//"Ped.Protheus/Web"				
		DtoC(aDados[nAuxExp][N_BAIXA]),;		//"DT Baixa"
		aDados[nAuxExp][N_NSU],;		//"NSU"
		aDados[nAuxExp][N_VALBRU],;		//"#Val.Bruto"
		aDados[nAuxExp][N_LIGPAG],;		//"#Val.Liq.Pag"
		aDados[nAuxExp][N_PG_SALDO],;	//"#Saldo Liq.Pago"
		aDados[nAuxExp][N_STXADM],;		//"#Sld.Tx.Adm."
		aDados[nAuxExp][N_TXADM],;		//"#Val.Tx.Adm."
		DtoC(aDados[nAuxExp][N_DTVEND]),;		//"#DT.Venda"
		DtoC(aDados[nAuxExp][N_DTCRED]),;		//"#DT.Credito"
		aDados[nAuxExp][N_OPERA],;		//"#Operadora"
		aDados[nAuxExp][N_DESBA],;		//"Bandeira"
		IIF( aDados[nAuxExp][N_ZZ9CONC] == "1","Sim","Nใo" ),;	//"#Conciliado"		
		aDados[nAuxExp][N_MSG],;		//"#Mensagem"		
		aDados[nAuxExp][N_LOTE],;		//"#Resumo vendas"		
		aDados[nAuxExp][N_QTDPAR];		//"#Qtd.Parcela"		
		})

Next nAuxExp
		
oExcel:Activate()
oExcel:GetXMLFile(cPath+cArquivo)

ShellExecute("Open", cPath+cArquivo, "", cPath, 1 )	
//oExcelApp := MsExcel():New()
//oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha
//oExcelApp:SetVisible(.T.)

FreeObj(oExcel)

Return nil   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF03F  บAutor  ณCleuto Lima         บ Data ณ  09/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ contabiliza็ใo de cartใo de credito                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function GENMF03F(cFilPed,nTipo)

Local cRet	:= ""

SCV->(DbSetOrder(1))
If SCV->(DbSeek( cFilPed ))

	/*
	DษBITO = 1.1.02.01.04 – Contas a Receber - CIELO
	DษBITO = 1.1.02.01.05 – Contas a Receber - REDECARD
	DษBITO = 1.1.02.01.06 – Contas a Receber - AMEX
	DษBITO = 1.1.02.01.11 – Contas a Receber - STONE
	
	V - STONE - VISA
	M - STONE - MASTERCARD
	N - STONE - VISA
	A - CIELO - AMEX (AMEX TAMBEM ษ OPERADORA MAS VEM PELA CIELO)
	E - CIELO - ELO
	H - REDECARD - HIPERCARD
	D - REDECARD - DINERS	
	*/
		
	Do Case
		Case UPPER(ALLTRIM(SCV->CV_XOPERA))+'#'$'CIELO#'
			If nTipo == 1
				cRet	:= '11020104'
			Else
				cRet	:= 'CIELO'
			EndIf	
		Case UPPER(ALLTRIM(SCV->CV_XOPERA))+'#'$'REDECARD#'
			If nTipo == 1
				cRet	:= '11020105'
			Else
				cRet	:= 'REDECARD'
			EndIf				
		Case UPPER(ALLTRIM(SCV->CV_XOPERA))+'#'$'AMEX#'
			If nTipo == 1
				cRet	:= '11020106'
			Else
				cRet	:= 'AMEX'
			EndIf				
		Case UPPER(ALLTRIM(SCV->CV_XOPERA))+'#'$'STONE#'
			If nTipo == 1
				cRet	:= '11020111'
			Else
				cRet	:= 'STONE'
			EndIf				
	EndCase
	
EndIf

Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF03F  บAutor  ณCleuto Lima         บ Data ณ  09/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ contabiliza็ใo de cartใo de credito                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function GENMF03G(cFilPed,nTipo)

Local nRet	:= 0

nRet := IIF(AllTrim(POSICIONE('SCV',1,SD2->(D2_FILIAL+D2_PEDIDO),'CV_FORMAPG'))=='CC'.AND.SF2->F2_TIPO="N".AND.SD2->D2_TES<>GETMV("MV_XTESINT").and.!(SD2->D2_TES$"516-517-518-519-504-818-819-820-525-536-522-514-520-521-523-526-527-531-532-533-821-839-840-540").and.alltrim(SM0->M0_CGC)<>alltrim(SA1->A1_CGC),SD2->D2_TOTAL,0)                                                                                             

Return nRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENMF003  บAutor  ณMicrosiga           บ Data ณ  04/19/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function BaixaNCC(nRecZZ9,nSalvRec,aLog)

Local cNatCart	:= GetMv("GENI018CAR") //NATUREZA PARA CARTAO DE CREDITO

Local lRet		:= .F.
Local aArea		:= GetArea()
Local cOperaTit	:= "" 
Local lBaixaNCC	:= .F. 
Local nRecNcc	:= 0
Local aBaixa	:= {}
Local cHIST		:= ""

Local nMgMais	:= 2
Local nMgMenos	:= -2
Local cMOTBX	:= ""
Local cBANCO	:= ""
Local cAGENCIA	:= ""
Local cCONTA	:= ""
	
Private nRecnoNDF
Private nRecnoE1

SE1->(DbgoTo(nSalvRec))
cOperaTit	:= SE1->E1_XOPERA

If Select("BUSCA_NCC") >0 
	BUSCA_NCC->(DbCloseArea())
EndIf

BeginSql Alias "BUSCA_NCC"
	
	SELECT SE1B.R_E_C_N_O_ RECNCC,SE1B.E1_SALDO SALDO,SE1B.E1_VENCTO,SE5.E5_MOTBX,SE5.E5_BANCO,SE5.E5_AGENCIA,SE5.E5_CONTA
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
	LEFT JOIN %Table:SE5%  SE5
	ON SE5.E5_FILIAL = SE1.E1_FILIAL
	AND SE5.E5_NUMERO = SE1.E1_NUM
	AND SE5.E5_PREFIXO = SE1.E1_PREFIXO
	AND SE5.E5_PARCELA = SE1.E1_PARCELA
	AND SE5.E5_TIPO = SE1.E1_TIPO
	AND SE5.%NotDel%	
	WHERE SE1.E1_TIPO = 'NF'
	AND TRIM(SE1.E1_DOCTEF) = %Exp: AllTrim(SE1->E1_DOCTEF) %
	AND SE1.E1_NATUREZ = %Exp:cNatCart%
	AND SE1.%NotDel%
	GROUP BY SE1B.R_E_C_N_O_,SE1B.E1_SALDO,SE1B.E1_VENCTO,SE5.E5_MOTBX,SE5.E5_BANCO,SE5.E5_AGENCIA,SE5.E5_CONTA
	ORDER BY SE1B.E1_VENCTO
	
EndSql

BUSCA_NCC->(DbGoTop())
If BUSCA_NCC->(EOF())
	Aadd(aLog, {"Erro","Estorno",SE1->E1_NUM,"",SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Nใo foi localizado saldo de NCC para realizar a baixa do estorno!",ZZ9->ZZ9_DTVEND, ZZ9->ZZ9_DTCRED, CtoD("  /  /  "), 0, 0, 0, cOperaTit,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )	
	Return .F.	
Else
	// no arquivo da ACESSTAGE nใo temos deferencia de parcela, com isso a paridade com a NCC ้ feita pelo vencimento
	SE1->(DbgoTo(BUSCA_NCC->RECNCC))
	nRecNcc 	:= BUSCA_NCC->RECNCC
	cMOTBX		:= BUSCA_NCC->E5_MOTBX
	cBANCO		:= BUSCA_NCC->E5_BANCO
	cAGENCIA	:= BUSCA_NCC->E5_AGENCIA
	cCONTA		:= BUSCA_NCC->E5_CONTA
	cHIST		:= "Valor recebido s /Titulo - "+Alltrim(ZZ9->ZZ9_DESAJU)
EndIf

//nValDif	:= ZZ9->ZZ9_VALBRU-SE1->E1_SALDO

BUSCA_NCC->(DbCloseArea())
SAE->(DbOrderNickName("IDOPERA"))

Do Case		
	Case Empty(cMOTBX)

		Aadd(aLog, {"Erro","Estorno",SE1->E1_NUM,"",SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Vencimento informado no arquivo ้ menor que a emissใo do titulo, Emissใo Titulo: "+DtoC(StoD(SE1->E1_EMISSAO))+", Venc.Arquivo: "+DtoC(ZZ9->ZZ9_DTCRED)+".",ZZ9->ZZ9_DTVEND, ZZ9->ZZ9_DTCRED, CtoD("  /  /  "), 0, 0, 0, cOperaTit,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )	
		Return .F.			
    /*
	Case nValDif < nMgMenos .OR. nMgMenos > nMgMais
        
		Aadd(aLog, {"Erro","Estorno",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Nใo foi localizado saldo de NCC para realizar a compensa็ใo!",SE1->E1_EMISSAO, SE1->E1_VENCREA, CtoD("  /  /  "), 0, 0, 0, cOperaTit,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )	
		
		cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
		cMsg	:= "Valor liquido informado no arquivo divergente do saldo da NCC, Saldo NCC: R$ "+AllTrim(transform(SE1->E1_SALDO, "@E 999,999,999.99"))+", Valor arquivo: R$ "+AllTrim(transform(nValLiq, "@E 999,999,999.99"))+"." 
	*/	
	Case ZZ9->ZZ9_DTCRED < SE1->E1_EMISSAO

		Aadd(aLog, {"Erro","Estorno",SE1->E1_NUM,"",SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Vencimento informado no arquivo ้ menor que a emissใo do titulo, Emissใo Titulo: "+DtoC(StoD(SE1->E1_EMISSAO))+", Venc.Arquivo: "+DtoC(ZZ9->ZZ9_DTCRED)+".",ZZ9->ZZ9_DTVEND, ZZ9->ZZ9_DTCRED, CtoD("  /  /  "), 0, 0, 0, cOperaTit,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )	
		Return .F.	
			
	Case SE1->E1_SALDO < ((-1)*ZZ9->ZZ9_VALBRU)

		Aadd(aLog, {"Erro","Estorno",SE1->E1_NUM,"",SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,"Saldo da NCC menor que valor do arquivo, Saldo NCC: R$ "+AllTrim(transform(SE1->E1_SALDO, "@E 999,999,999.99"))+", Valor arquivo: R$ "+AllTrim(transform(ZZ9->ZZ9_VALBRU, "@E 999,999,999.99"))+".",ZZ9->ZZ9_DTVEND, ZZ9->ZZ9_DTCRED, CtoD("  /  /  "), 0, 0, 0, cOperaTit,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )	
		Return .F.				
    /*
    Case DateDiffDay(ZZ9->ZZ9_DTCRED, StoD(SE1->E1_VENCREA)) > nMgVenc .AND. ZZ9->ZZ9_DTCRED > StoD(SE1->E1_VENCREA)

		cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
		cMsg	:= "Diferen็a entre vencimento informado no arquivo e vencimento do titulo ้ superior a margem aceitแvel, Venc.Titulo: "+DtoC(StoD(SE1->E1_VENCREA))+", Venc.Arquivo: "+DtoC(ZZ9->ZZ9_DTCRED)+"."
	*/
	/*
	Case !SAE->(DbSeek( xFilial("SAE")+cOpera ))

		cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
		cMsg	:= "Operadora nใo localizada para o c๓digo "+cOpera+"."
		
	Case Empty(SAE->AE_XCODIGO) .OR. Empty(SAE->AE_XAGENCI) .OR. Empty(SAE->AE_XCONTA)
	
		cSituac	:= "3"//1=Nao validado;2=Consistente;3=Inconsistente
		cMsg	:= "Dados bancarios nใo informados para Operadora "+cOpera+"."	
	*/	
	OtherWise
	
		lBaixaNCC	:= .T.
	
EndCase		

If lBaixaNCC

	SE1->(DbGoTo( nRecNcc ))
 		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicia baixa do tituloณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aBaixa := {}
	 
	aBaixa := {{"E1_PREFIXO"	,SE1->E1_PREFIXO	,Nil	},;
	           {"E1_NUM"		,SE1->E1_NUM		,Nil	},;
	           {"E1_PARCELA"	,SE1->E1_PARCELA	,Nil	},;
	           {"E1_CLIENTE"	,SE1->E1_CLIENTE	,Nil	},;
	           {"E1_LOJA"		,SE1->E1_LOJA		,Nil	},;		           
	           {"E1_TIPO"		,SE1->E1_TIPO		,Nil	},;		           		           
	           {"AUTMOTBX"		,cMOTBX				,Nil	},;
	           {"AUTBANCO"		,cBANCO				,Nil	},;
	           {"AUTAGENCIA"	,cAGENCIA			,Nil	},;
	           {"AUTCONTA"		,cCONTA				,Nil	},;
	           {"AUTDTBAIXA"	,ZZ9->ZZ9_DTCRED	,Nil	},;
	           {"AUTDTCREDITO"	,ZZ9->ZZ9_DTCRED	,Nil	},;
	           {"AUTHIST"		,cHIST				,Nil	},;
	           {"AUTJUROS"		,0					,Nil	,.T.	},; 
	           {"AUTDESCONT"	,IIF( ZZ9->ZZ9_STXADM < 0 , (-1)*ZZ9->ZZ9_STXADM , ZZ9->ZZ9_STXADM )	,Nil	,.T.	},; 
	           {"AUTVALREC"		,(-1)*ZZ9->ZZ9_SALDO	,Nil	}}

	lMSHelpAuto := .t.
	lMsErroAuto := .f.
	
	Begin Transaction
		MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3) 		
		lMSHelpAuto := .F.
		
		If lMsErroAuto
			cErro := MostraErro(GetTempPath(), "GENMF03C.log" )
			Aadd(aLog, {"Erro","Baixa",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU,cErro,SE1->E1_EMISSAO, SE1->E1_VENCREA, ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, cOperaTit,SE1->E1_CLIENTE,SE1->E1_LOJA,0 } )
		Else
			nValBaixa	:= (-1)*ZZ9->ZZ9_SALDO
			ZZ9->(DbGoTo( nRecZZ9 ))
			RecLock("ZZ9",.F.)
			ZZ9->ZZ9_MSG	:= " "
			ZZ9->ZZ9_CONCIL	:= "1"
			ZZ9->ZZ9_SALDO	:= 0
			ZZ9->ZZ9_STXADM	:= 0
			MsUnLock()

			Aadd(aLog, {"Sucesso","Baixa",SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,ZZ9->ZZ9_NSU, "NCC baixada "+iif( SE1->E1_SALDO > 0 , "parcialmente" , "totalmente" )+" com sucesso.",SE1->E1_EMISSAO, SE1->E1_VENCREA, ZZ9->ZZ9_DTCRED, ZZ9->ZZ9_VALBRU, (-1)*ZZ9->ZZ9_TXADM, ZZ9->ZZ9_LIGPAG, cOperaTit,SE1->E1_CLIENTE,SE1->E1_LOJA,nValBaixa  } )
		EndIf
	End Transaction		
	
EndIf

RestArea(aArea)

Return lRet

//Funcao para descobrir se hแ diferen็a entre o valor da SE1 e ZZ9 para o NSU e parcela.

Static Function DifValor(cNSU,cParc)
Local aRet   := {}
Local cQuery := ""

If Empty(cParc)
	cParc := "A"
EndIf

cQuery += "Select SUM(ZZ9_VALBRU) ZZ9_VALBRU,SUM(E1_VALOR) E1_VALOR from ( "+CRLF
cQuery += "select SUM(ZZ9_VALBRU) ZZ9_VALBRU, 0 AS E1_VALOR "+CRLF
cQuery += "from "+RetSqlName("ZZ9")+" ZZ9 "+CRLF
cQuery += "where ZZ9.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "AND TO_NUMBER(nvl(TRIM( regexp_replace( regexp_replace(regexp_replace(TRIM(ZZ9.ZZ9_NSU),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)) = "+cNSU+" "+CRLF
cQuery += "AND NVL(TRIM(ZZ9.ZZ9_PARCEL),'A') = '"+AllTrim(cParc)+"' "+CRLF
cQuery += "UNION ALL "+CRLF
cQuery += "SELECT 0 AS ZZ9_VALBRU, SUM(E1_VALOR) E1_VALOR "+CRLF
cQuery += "FROM "+RetSqlName("SE1")+" SE1 "+CRLF 
cQuery += "where E1_FILIAL IN ('1001','1022') "+CRLF  
cQuery += "AND SE1.E1_TIPO = 'NF'  "+CRLF
cQuery += "AND SE1.D_E_L_E_T_ <> '*'   "+CRLF
cQuery += "AND SE1.E1_NATUREZ = '30080'  "+CRLF
cQuery += "AND EXISTS (SELECT * FROM ZZ9000 ZZ9 "+CRLF 
cQuery += "            where TO_NUMBER(nvl(TRIM(regexp_replace( regexp_replace(regexp_replace(TRIM(SE1.E1_DOCTEF),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)) = TO_NUMBER(nvl(TRIM( regexp_replace( regexp_replace(regexp_replace(TRIM(ZZ9.ZZ9_NSU),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)) "+CRLF 
cQuery += "            AND NVL(TRIM(SE1.E1_PARCELA),'A') = TRIM(ZZ9.ZZ9_PARCEL) AND ZZ9_FILIAL = '    ' AND ZZ9.D_E_L_E_T_ <> '*' AND ZZ9.ZZ9_TIPO = '11') "+CRLF
cQuery += "AND TO_NUMBER(nvl(TRIM(regexp_replace( regexp_replace(regexp_replace(TRIM(SE1.E1_DOCTEF),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)) = "+cNSU+" "+CRLF
cQuery += "AND NVL(TRIM(E1_PARCELA),'A') = '"+AllTrim(cParc)+"' ) Z "+CRLF

MemoWrite("GENMF003_DiValor.sql",cQuery)

If Select("DIF") > 0
	dbSelectArea("DIF")
	DIF->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"DIF",.F.,.T.)

DbSelectArea("DIF")

If DIF->(!EOF())
	IF DIF->ZZ9_VALBRU <> DIF->E1_VALOR
		aRet := {DIF->E1_VALOR,DIF->ZZ9_VALBRU}
	EndIf
EndIf

DIF->(dbCloseArea())

Return aRet