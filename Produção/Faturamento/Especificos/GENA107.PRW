#include "rwmake.ch"
#include "protheus.ch"

#DEFINE cEnt	Chr(13)+chr(10)

#DEFINE N_A1_COD     01
#DEFINE N_A1_LOJA    02
#DEFINE N_A1_NOME    03
#DEFINE N_A1_NREDUZ  04
#DEFINE N_A1_LC      05
#DEFINE N_A1_CGC     06
#DEFINE N_A1_RISCO	 07
#DEFINE N_RECSA1	 08
#DEFINE N_A1_CONTA	 09
#DEFINE N_A1_PESSOA	 10
#DEFINE N_A1_INSCRM	 11
#DEFINE N_A1_XCANALV 12
#DEFINE N_ACY_DESCRI 13
#DEFINE N_Z2		 14
#DEFINE N_TP		 15
#DEFINE N_Z2_DESCCLA 16
#DEFINE N_SIT		 17

#DEFINE N_DTCOM		 18
#DEFINE N_USCOM		 19
#DEFINE N_DTFIN		 20
#DEFINE N_USFIN		 21
#DEFINE N_DTDIR		 22
#DEFINE N_USDIR		 23

#DEFINE N_SIZE	     23
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA107   ºAutor  ³Cleuto Lima         º Data ³  26/02/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Liberação cadastro de cliente                               º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function GENA107()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da rotina.                                                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aDados		:= {}
Local aQuery		:= {}

Local aPosObj    	:= {} 
Local aObjects   	:= {}                        
Local aSize      	:= MsAdvSize() 
Local aInfo		    := {}

Local bConfirm	:= {|| oDlgPed:End() }
Local bCancel	:= {|| oDlgPed:End() }
Local aButtons	:= {}

Local oDlgPed	:= Nil
Local nWidth 	:= 50
Local oFont		:= Nil
Local oBmp		:= Nil
Local oTFont 	:= TFont():New('Courier new',,-18,.T.)
Local lRet		:= .F.
Local lBitmap	:= .T. 
Local nLenPixel	:= 0
Local cCadastro	:= "Liberação de Cliente"
Local cCodLoja	:= ""
Local cCGC		:= ""
Local cNome		:= ""
Local nMbrWidth	:= 0
Local nMbrHeight:= 0
Local oButAtu
Local cNivel1	:= ""
Local cNivel2	:= ""
Local cNivel3	:= ""
Local cNiv		:= ""
Local cInTpCli	:= ""
Local bCarga	:= {|x| Processa({|| CargaBase(@aDados,nDtIni,cCodLoja,cCGC,cNome,cInTpCli,lNivel,lbloqueados)	},"Consultando Clientes...")}
Local lNivel	:= .T.
Local nDtIni	:= 30
Local lbloqueados	:= .T.

Private nMinRec	:= 1
Private nMaxRec	:= 100
Private oListBox	:= nil

cNivel1	:= GetMv("MV_XCLIN1") //NIVEL 1 = Dir.Comercial
cNivel2	:= GetMv("MV_XCLIN2") //NIVEL 2 = Financeiro
cNivel3	:= GetMv("MV_XCLIN3") //NIVEL 3 = Diretoria

//VERIFICA QUAIS NIVEIS O USUARIO PERTENCE
If RetCodUsr()$cNivel1 .OR. FWIsAdmin(RetCodUsr())
	cNiv += "1;"
Endif                                                                                                                          

If RetCodUsr()$cNivel2 .OR. FWIsAdmin(RetCodUsr())
	cNiv += "2;"
Endif
If RetCodUsr()$cNivel3 .OR. FWIsAdmin(RetCodUsr())
	cNiv += "3;"
Endif

cInTpCli := FormatIn(cNiv,";")

Processa({|| CargaBase(@aDados,nDtIni,cCodLoja,cCGC,cNome,cInTpCli,lNivel,lbloqueados)	},"Consultando Clientes...")

cCodLoja	:= CriaVar("A1_COD",.F.)+CriaVar("A1_LOJA",.F.)
cCGC		:= CriaVar("A1_CGC",.F.)
cNome		:= CriaVar("A1_NOME",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿         
//³Define a area dos objetos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {} 
Aadd( aObjects, { 100, 100, .t., .t. } )

aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 

If aSize[3] == 0
	aSize :=  {100,100,800,800,1800,800,0}
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a tela                                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Define Dialog oDlgPed 	Title cCadastro ;
					From aSize[7],00 TO aSize[6],aSize[5] ;
					 /*STYLE nOR(WS_VISIBLE,WS_POPUP)*/ PIXEL
					
oDlgPed:lMaximized := .T.
oDlgPed:SetColor(CLR_BLACK,CLR_WHITE)
oDlgPed:SetFont(oFont)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Armazena as corrdenadas da tela                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMbrWidth	:= oDlgPed:nWidth/2-43
nMbrHeight	:= oDlgPed:nHeight/2

@00,00 MSPANEL oMainTop PROMPT "" SIZE nMbrWidth,65/*nMbrHeight*0.10*/  of oDlgPed
oMainTop:Align := CONTROL_ALIGN_TOP
oGrpAcoes		:= TGroup():New(05,05,(oMainTop:NCLIENTHEIGHT/2),85,"Ações",oMainTop,CLR_RED,,.T.)
oGrpFilt		:= TGroup():New(05,90,(oMainTop:NCLIENTHEIGHT/2),(oMainTop:NCLIENTWIDTH/2)-10,"Filtros",oMainTop,CLR_RED,,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³titulos.                                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgPed
oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT

bCargaAnt := { || Processa({|| CargaBase(@aDados,nDtIni,cCodLoja,cCGC,cNome,cInTpCli,lNivel,lbloqueados,-1)	},"Consultando Clientes...") }
bCargaNext := { || Processa({|| CargaBase(@aDados,nDtIni,cCodLoja,cCGC,cNome,cInTpCli,lNivel,lbloqueados,1)	},"Consultando Clientes...") }
oBAnt := TButton():New( 02, (((oMainCentro:NCLIENTWIDTH/2)-10)/2)-50, "Anterior"	, oMainCentro,bCargaAnt,30,10,,,,.T.)
oBAnt:bWhen := {|| !lbloqueados .AND. nMinRec > 1 .AND. Empty(cCodLoja) .AND. Empty(cCGC) .AND. Empty(cNome)  .AND. Len(aDados) > 0}

oBNex := TButton():New( 02, ((oMainCentro:NCLIENTWIDTH/2)-10)/2, "Próximo"	, oMainCentro,bCargaNext,30,10,,,,.T.)
oBNex:bWhen := {|| !lbloqueados .AND. Empty(cCodLoja) .AND. Empty(cCGC) .AND. Empty(cNome) .AND. Len(aDados) > 0 .AND. Len(aDados) == 100 }

oGrpXML	:= TGroup():New(10,05,(oMainCentro:NCLIENTHEIGHT/2)-40,(oMainCentro:NCLIENTWIDTH/2)-10,"Clientes Bloqueados",oMainCentro,CLR_RED,,.T.)

oButLb 		:= TButton():New( 15, 020, "Liberar"	, oMainTop,{|x| IIF( LibCad(aDados[oListBox:nAT][N_RECSA1]) , eVal(bCarga) , nil) },50,010,,,,.T.)
oButLb:bWhen	:= {|x| Len(aDados) > 0 }
oButLb:SetCss( "QPushButton{ background-color:DeepSkyBlue;}" )

oButPed 	:= TButton():New( 30, 020, "Visualizar"	, oMainTop,{|| VisCli(aDados[oListBox:nAT][N_RECSA1]) },50,010,,,,.T.)
oButPed:bWhen	:= {|x| Len(aDados) > 0 }

oButSair 	:= TButton():New( 45, 020, "Sair"		, oMainTop,bConfirm,50,010,,,,.T.)

// oButRef 	:= TButton():New( 30, 080, "Atualizar Lista"	, oMainTop,{|x| Processa({|| CargaBase(@aDados,nDtIni,cCodLoja,cCGC,cNome)	},"Consultando Clientes...")},50,010,,,,.T.)
// oButRef:SetCss( "QPushButton{ background-color:rgb(255, 242, 0);}" )

oCodLoja	:= TGet():New(015,100,{|u| if( Pcount()>0, cCodLoja := u,cCodLoja ) },oMainTop,050,010,"@!",{|| .T. },0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cCodLoja",,,,,,,"Cód. + Loja .: ",1,oFont,CLR_RED )
oCodLoja:bChange	:= {|| nMinRec	:= 1, nMaxRec	:= 100 }

oCGC		:= TGet():New(015,160,{|u| if( Pcount()>0, cCGC := u,cCGC ) },oMainTop,060,010,"@!",{|| .T. },0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cCGC",,,,,,,"CPF/CNPJ .: ",1,oFont,CLR_RED )
oCGC:bChange	:= {|| nMinRec	:= 1, nMaxRec	:= 100 }

oNome		:= TGet():New(015,230,{|u| if( Pcount()>0, cNome := u,cNome ) },oMainTop,120,010,"@!",{|| .T. },0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cNome",,,,,,,"Nome .: ",1,oFont,CLR_RED )
oNome:bChange	:= {|| nMinRec	:= 1, nMaxRec	:= 100 }

oButAtu 	:= TButton():New( 22.5, 355, "Pesquisar"	, oMainTop,bCarga,50,010,,,,.T.)
oButAtu:SetCss( "QPushButton{ background-color:rgb(255, 242, 0);}" )

oGetMinha	:= TCheckBox():New(40,100,'Apenas minhas pendencias?'	,{|m| If(Pcount()>0, lNivel:=m, lNivel)},oMainTop,100,210,,,,,,,,.T.,,,)
oGetMinha:bChange	:= bCarga

oGetAll	:= TCheckBox():New(50,100,'Apenas bloqueados?'	,{|m| If(Pcount()>0, lbloqueados:=m, lbloqueados)},oMainTop,100,210,,,,,,,,.T.,,,)
oGetAll:bChange	:= bCarga

TBitmap():New(41,210,15,15,,"CLIENTE",.T.,oMainTop, {|| },,.F.,.F.,,,.F.,,.T.,,.F.)
TSay():New(51,198,{|| "Bloq.Comercial" },oMainTop,,oFont,,,,.T.,,,50,10,,,,,,.T.)

TBitmap():New(41,270,15,15,,"POSCLI",.T.,oMainTop, {|| },,.F.,.F.,,,.F.,,.T.,,.F.)
TSay():New(51,257,{|| "Bloq.Financeiro" },oMainTop,,oFont,,,,.T.,,,50,10,,,,,,.T.)

TBitmap():New(41,330,15,15,,"VENDEDOR",.T.,oMainTop, {|| },,.F.,.F.,,,.F.,,.T.,,.F.)
TSay():New(51,318,{|| "Bloq.Diretoria" },oMainTop,,oFont,,,,.T.,,,50,10,,,,,,.T.)

//VERIFICA QUAIS NIVEIS O USUARIO PERTENCE
If RetCodUsr()$cNivel1 .OR. FWIsAdmin(RetCodUsr())
	oSayBloq := TSay():New(42,350,{|| "Seu nível de liberação é"+Chr(13)+Chr(10)+"Bloq.Comercial" },oMainTop,,oFont,,,,.T.,,,100,20,,,,,,.T.)
	oSayBloq:SetTextAlign(2,2)
ElseIf RetCodUsr()$cNivel2 .OR. FWIsAdmin(RetCodUsr())
	oSayBloq := TSay():New(42,350,{|| "Seu nível de liberação é"+Chr(13)+Chr(10)+"Bloq.Financeiro" },oMainTop,,oFont,,,,.T.,,,100,20,,,,,,.T.)
	oSayBloq:SetTextAlign(2,2)
ElseIf RetCodUsr()$cNivel3 .OR. FWIsAdmin(RetCodUsr())
	oSayBloq := TSay():New(42,350,{|| "Seu nível de liberação é"+Chr(13)+Chr(10)+"Bloq.Diretoria" },oMainTop,,oFont,,,,.T.,,,100,20,,,,,,.T.)
	oSayBloq:SetTextAlign(2,2)
Endif

aHList	:= {}

oListBox := TWBrowse():New(20,10,(oMainCentro:NCLIENTWIDTH/2)-30,(oMainCentro:NCLIENTHEIGHT/2)-60,,aHList,,oMainCentro,,,,,,,,,,,,, "ARRAY", .T. )

oListBox:AddColumn(TCColumn():New(" "		,{|| aDados[oListBox:nAT][N_SIT]		},,,,'CENTER'	,25,.T.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",06,0,"999999","Código")
oListBox:AddColumn(TCColumn():New("Código"	,{|| aDados[oListBox:nAT][N_A1_COD]			},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",02,0,"99","Loja")
oListBox:AddColumn(TCColumn():New("Loja"	,{|| aDados[oListBox:nAT][N_A1_LOJA]			},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",TamSX3("A1_NOME")[1],0,"@!","Nome")
oListBox:AddColumn(TCColumn():New("Nome",{|| aDados[oListBox:nAT][N_A1_NOME]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",TamSX3("A1_NREDUZ")[1],0,"@!","N Fantasia")
oListBox:AddColumn(TCColumn():New("N Fantasia",{|| aDados[oListBox:nAT][N_A1_NREDUZ]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",TamSX3("A1_LC")[1],TamSX3("A1_LC")[2],PesqPict("SA1","A1_LC"),"Limite Credito")
oListBox:AddColumn(TCColumn():New("Limite Credito",{|| aDados[oListBox:nAT][N_A1_LC]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",TamSX3("A1_CGC")[1],0,PesqPict("SA1","A1_CGC"),"CPF/CNPJ")
oListBox:AddColumn(TCColumn():New("CPF/CNPJ",{|| aDados[oListBox:nAT][N_A1_CGC]		},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",TamSX3("A1_RISCO")[1],0,PesqPict("SA1","A1_RISCO"),"Risco")
oListBox:AddColumn(TCColumn():New("Risco",{|| aDados[oListBox:nAT][N_A1_RISCO]		},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",TamSX3("A1_CONTA")[1],0,PesqPict("SA1","A1_CONTA"),"Conta")
oListBox:AddColumn(TCColumn():New("Conta",{|| aDados[oListBox:nAT][N_A1_CONTA]		},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",TamSX3("A1_PESSOA")[1],0,PesqPict("SA1","A1_PESSOA"),"Tp.Pessoa")
oListBox:AddColumn(TCColumn():New("Tp.Pessoa",{|| aDados[oListBox:nAT][N_A1_PESSOA]		},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",20,0,"","Canal Vendas")
oListBox:AddColumn(TCColumn():New("Canal Vendas",{|| aDados[oListBox:nAT][N_Z2]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",TamSX3("ACY_DESCRI")[1],0,PesqPict("SA1","ACY_DESCRI"),"Grp.Vendas")
oListBox:AddColumn(TCColumn():New("Grp.Vendas",{|| aDados[oListBox:nAT][N_ACY_DESCRI]		},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",20,0,"Tipo Cliente")
oListBox:AddColumn(TCColumn():New("Tipo Cliente",{|| aDados[oListBox:nAT][N_TP]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",TamSX3("A1_XDHCOME")[1],TamSX3("A1_XDHCOME")[2],PesqPict("SA1","A1_XDHCOME"),"Dt.Lib.Comercial")
oListBox:AddColumn(TCColumn():New("Dt.Lib.Comercial",{|| aDados[oListBox:nAT][N_DTCOM]		},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",TamSX3("A1_XUSCOME")[1],TamSX3("A1_XUSCOME")[2],PesqPict("SA1","A1_XUSCOME"),"Usuário Comercial")
oListBox:AddColumn(TCColumn():New("Usuário Comercial",{|| aDados[oListBox:nAT][N_USCOM]		},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",TamSX3("A1_XDHFINA")[1],TamSX3("A1_XDHFINA")[2],PesqPict("SA1","A1_XDHFINA"),"Dt.Lib.Financeiro")
oListBox:AddColumn(TCColumn():New("Dt.Lib.Financeiro",{|| aDados[oListBox:nAT][N_DTFIN]		},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",TamSX3("A1_XDHFINA")[1],TamSX3("A1_XDHFINA")[2],PesqPict("SA1","A1_XDHFINA"),"Usuário Financeiro")
oListBox:AddColumn(TCColumn():New("Usuário Financeiro",{|| aDados[oListBox:nAT][N_USFIN]		},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",TamSX3("A1_XDHDIRE")[1],TamSX3("A1_XDHDIRE")[2],PesqPict("SA1","A1_XDHDIRE"),"Dt.Lib.Diretoria")
oListBox:AddColumn(TCColumn():New("Dt.Lib.Diretoria",{|| aDados[oListBox:nAT][N_DTDIR]		},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",TamSX3("A1_XUSDIRE")[1],TamSX3("A1_XUSDIRE")[2],PesqPict("SA1","A1_XUSDIRE"),"Usuário Diretoria")
oListBox:AddColumn(TCColumn():New("Usuário Diretoria",{|| aDados[oListBox:nAT][N_USDIR]		},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

oListBox:SetArray( aDados )

Activate MsDialog oDlgPed

Return nil


Static Function CargaBase(aDados,nDtIni,cCodLoja,cCGC,cNome,cInTpCli,lNivel,lbloqueados,nAvanca)

Local aArea		:= GetArea()
// Local cDtIni:= DtoS(DDataBase-nDtIni)
Local cWhere	:= " "
Local nQtdPg	:= 100

Default lNivel		:= .T.
Default lbloqueados	:= .T.
Default nAvanca		:= 0

ProcRegua(0)
IncProc()

IF !Empty(cCodLoja)
	cWhere += " AND A1_COD||A1_LOJA LIKE '%"+AllTrim(Upper(cCodLoja))+"%' "
ENDIF

IF !Empty(cCGC)
	cWhere += " AND A1_CGC = '"+AllTrim(Upper(cCGC))+"' "
ENDIF

IF !Empty(cNome)
	cWhere += " AND ( A1_NOME LIKE '%"+AllTrim(Upper(cNome))+"%' "
	cWhere += " OR A1_NREDUZ LIKE '%"+AllTrim(Upper(cNome))+"%' )"
ENDIF

IF lbloqueados .OR. lNivel
    cWhere+= " AND A1_MSBLQL = '1' "
	cWhere+= " AND A1_XREV NOT IN ('5','4') "
ENDIF	

IF nAvanca <> 0
	IF nAvanca == 1
		nMinRec	+= 100
		nMaxRec	+= 100
	ELSE
		nMinRec	-= 100
		nMaxRec	-= 100
	ENDIF
	
	IF nMinRec < 0 .OR. nMaxRec < 0
		nMinRec	:= 1
		nMaxRec	:= 100
	ENDIF
ELSE
	nMinRec	:= 1
	nMaxRec	:= 100
ENDIF

cWhere := "%"+cWhere+IIF( lNivel , " AND A1_XREV IN "+cInTpCli , '' )+"%"


aDados	:= {}

If Select("TMP_DADOS") > 0
	TMP_DADOS->(DbCloseArea())
EndIf

BeginSql Alias "TMP_DADOS"
	SELECT * FROM (
	SELECT ROWNUM PS ,A1_MSBLQL,A1_XREV,A1_COD,A1_LOJA,A1_NOME,A1_NREDUZ,A1_CGC,A1_LC,A1_RISCO,SA1.R_E_C_N_O_ RECSA1,A1_CONTA,A1_PESSOA,A1_INSCRM,A1_XCANALV,ACY_DESCRI,Z2.X5_DESCRI Z2,TP.X5_DESCRI TP,A1_XDHCOME, A1_XUSCOME, A1_XDHFINA, A1_XUSFINA, A1_XDHDIRE, A1_XUSDIRE
    FROM %Table:SA1% SA1
    LEFT JOIN %Table:ACY% ACY
    ON ACY_FILIAL = %xFilial:ACY%
    AND ACY_GRPVEN = A1_GRPVEN
    AND ACY.%NotDel%
    LEFT JOIN %Table:SX5% Z2
    ON Z2.X5_FILIAL = %xFilial:SX5%
    AND Z2.X5_TABELA = 'Z2'
    AND Z2.X5_CHAVE = A1_XCANALV
    AND Z2.%NotDel%
    LEFT JOIN %Table:SX5% TP
    ON TP.X5_FILIAL = %xFilial:SX5%
    AND TP.X5_TABELA = 'TP'
    AND TP.X5_CHAVE = A1_XTIPCLI
    AND TP.%NotDel%
	WHERE A1_FILIAL = ' '
	%Exp:cWhere%	
    AND sa1.%NotDel%
	ORDER BY SA1.R_E_C_N_O_ ASC
	) TMP
	WHERE PS BETWEEN %Exp:nMinRec% AND %Exp:nMaxRec%
EndSql

TMP_DADOS->(DbGoTop())

While TMP_DADOS->(!EOF())

	Aadd(aDados,Array(N_SIZE))

	aDados[Len(aDados)][N_A1_COD]    	:= TMP_DADOS->A1_COD
	aDados[Len(aDados)][N_A1_LOJA]    	:= TMP_DADOS->A1_LOJA
	aDados[Len(aDados)][N_A1_NOME]    	:= TMP_DADOS->A1_NOME
	aDados[Len(aDados)][N_A1_NREDUZ]    := TMP_DADOS->A1_NREDUZ
	aDados[Len(aDados)][N_A1_LC]    	:= Transform(TMP_DADOS->A1_LC,"@E 999,999,999.99")
	aDados[Len(aDados)][N_A1_CGC]    	:= TMP_DADOS->A1_CGC
	aDados[Len(aDados)][N_A1_RISCO]     := TMP_DADOS->A1_RISCO
	aDados[Len(aDados)][N_RECSA1]    	:= TMP_DADOS->RECSA1
	aDados[Len(aDados)][N_A1_CONTA]     := TMP_DADOS->A1_CONTA
	aDados[Len(aDados)][N_A1_PESSOA]    := IIF( TMP_DADOS->A1_PESSOA == "J" , "Juridica", "Fisica" )
	aDados[Len(aDados)][N_A1_INSCRM]    := TMP_DADOS->A1_INSCRM
	aDados[Len(aDados)][N_A1_XCANALV]   := TMP_DADOS->A1_XCANALV
	aDados[Len(aDados)][N_ACY_DESCRI]   := TMP_DADOS->ACY_DESCRI
	aDados[Len(aDados)][N_Z2]    		:= TMP_DADOS->Z2
	aDados[Len(aDados)][N_TP]    		:= TMP_DADOS->TP

	aDados[Len(aDados)][N_DTCOM]		:= TMP_DADOS->A1_XDHCOME
	aDados[Len(aDados)][N_USCOM]		:= TMP_DADOS->A1_XUSCOME
	aDados[Len(aDados)][N_DTFIN]		:= TMP_DADOS->A1_XDHFINA
	aDados[Len(aDados)][N_USFIN]		:= TMP_DADOS->A1_XUSFINA
	aDados[Len(aDados)][N_DTDIR]		:= TMP_DADOS->A1_XDHDIRE
	aDados[Len(aDados)][N_USDIR]		:= TMP_DADOS->A1_XUSDIRE

	Do Case
		Case TMP_DADOS->A1_MSBLQL <> "1"
			aDados[Len(aDados)][N_SIT]	:= LoaDBitmap( GetResources(), "OK" )
		Case TMP_DADOS->A1_XREV == "1"
			aDados[Len(aDados)][N_SIT]	:= LoaDBitmap( GetResources(), "CLIENTE" )	
		Case TMP_DADOS->A1_XREV == "2"
			aDados[Len(aDados)][N_SIT]	:= LoaDBitmap( GetResources(), "POSCLI" )
		Case TMP_DADOS->A1_XREV == "3"
			aDados[Len(aDados)][N_SIT]	:= LoaDBitmap( GetResources(), "VENDEDOR" )	
		Case TMP_DADOS->A1_XREV == "4" .OR. TMP_DADOS->A1_XREV == "5"
			aDados[Len(aDados)][N_SIT]	:= LoaDBitmap( GetResources(), "afastamento" )							
		OtherWise
			aDados[Len(aDados)][N_SIT]	:= LoaDBitmap( GetResources(), "OK" )
	EndCase

	TMP_DADOS->(DbSkip())	
EndDo

TMP_DADOS->(DbCloseArea())
RestArea(aArea)

IF ValType(oListBox) == "O"
	oListBox:SetArray( aDados )
	oListBox:DrawSelect()
	oListBox:Refresh()
	oListBox:GoTop()	
ENDIF	

Return nil

Static Function LibCad(nRecSA1)

Local cNivel1	:= GetMv("MV_XCLIN1") //NIVEL 1 = Dir.Comercial
Local cNivel2	:= GetMv("MV_XCLIN2") //NIVEL 2 = Financeiro
Local cNivel3	:= GetMv("MV_XCLIN3") //NIVEL 3 = Diretoria
Local nLinCredPF:= GetMv("GEN_FAT292",.F.,1000)
Local nLinCredPJ:= GetMv("GEN_FAT293",.F.,10000)
Local cContaPF	:= AllTrim(GetMv("GEN_FAT294",.F.,"11020101"))
Local cContaPJ	:= AllTrim(GetMv("GEN_FAT295",.F.,"11020101"))
Local cContaEX	:= AllTrim(GetMv("GEN_FAT296",.F.,"11020102"))
Local lLib		:= .F.
Local cRev		:= ""
Local cBlock	:= ""

Local cCodUsr	:= RetCodUsr()

SA1->(DbGoTo(nRecSA1))

IF SA1->A1_MSBLQL <> "1"
	Return nil
ENDIF

If !MsgYesNo("Confirma a liberação de "+Alltrim(SA1->A1_NOME)+" cadastro(s)?","Confirma")
	Return()
Endif

If cCodUsr $ cNivel3

	cRev	:= "4"
	cBlock	:= "2"			
	lLib	:= .T.	
	cUsrLib	:= "A1_XUSDIRE"
	cDhLLib	:= "A1_XDHDIRE"

ElseIf cCodUsr $ cNivel2 //NIVEL 2 = Financeiro
	
	IF Val(SA1->A1_XREV) > 2
		MsgStop("Você não tem permissão para liberar este nivel de bloqueio!")
	ELSE
		If SA1->A1_LC <= nLinCredPJ //SE APROVADOR NIVEL 2 LIBERAR CLIENTE COM LIMITE DE CREDITO ATE 10K, LIBERA DIRETO.
			cRev	:= "4" //LIBERADO
			cBlock	:= "2" //LIBERADO
			lLib	:= .T.
		Else
			cRev	:= "3" //PENDENTE DIRETORIA
			cBlock	:= "1" //BLOQUEADO
			lLib	:= .T.
		Endif

		cUsrLib	:= "A1_XUSFINA"
		cDhLLib	:= "A1_XDHFINA"
	ENDIF	

ElseIf cCodUsr $ cNivel1 //NIVEL 1 = Dir.Comercial

	IF Val(SA1->A1_XREV) > 1
		MsgStop("Você não tem permissão para liberar este nivel de bloqueio!")
	ELSE

		Do Case
			Case SA1->A1_TIPO <> "X" .AND. Empty(SA1->A1_CGC)
				MsgStop("Cliente sem CPF/CNPJ")

			Case Empty(SA1->A1_CONTA)
				MsgStop("Conta contabil não informada")	

			Case SA1->A1_TIPO == "X" .AND. AllTrim(SA1->A1_CONTA) <> cContaEX
				MsgStop("Conta contabil inválida para Estrangeiro")
							
			Case SA1->A1_PESSOA == "F" .AND. AllTrim(SA1->A1_CONTA) <> cContaPF .AND. SA1->A1_TIPO <> "X"
				MsgStop("Conta contabil inválida para Pessoas Fisica")

			Case SA1->A1_PESSOA == "J" .AND. AllTrim(SA1->A1_CONTA) <> cContaPJ
				MsgStop("Conta contabil inválida para Pessoa Juridica")	

			Case SA1->A1_PESSOA == "J" .AND. SA1->A1_RECCOFI <> "S"
				xMagHelpFis("Cadastro invalido","O campo "+TitSX3('A1_RECCOFI')[1]+" não foi informado corretamente!","Para PJ o conteudo deste campo deve ser SIM!")

			Case SA1->A1_PESSOA == "J" .AND. SA1->A1_RECPIS <> "S"
				xMagHelpFis("Cadastro invalido","O campo "+TitSX3('A1_RECPIS')[1]+" não foi informado corretamente!","Para PJ o conteudo deste campo deve ser SIM!")

			Case SA1->A1_PESSOA == "J" .AND. SA1->A1_RECCSLL <> "S"
				xMagHelpFis("Cadastro invalido","O campo "+TitSX3('A1_RECCSLL')[1]+" não foi informado corretamente!","Para PJ o conteudo deste campo deve ser SIM!")

			Case SA1->A1_PESSOA == "J" .AND. SA1->A1_ABATIMP <> "1"
				xMagHelpFis("Cadastro invalido","O campo "+TitSX3('A1_ABATIMP')[1]+" não foi informado corretamente!","Para PJ o conteudo deste campo deve ser '1 - Cálculado do sistema'!")

			Case SA1->A1_PESSOA == "J" .AND. SA1->A1_RECIRRF <> "1"
				xMagHelpFis("Cadastro invalido","O campo "+TitSX3('A1_RECIRRF')[1]+" não foi informado corretamente!","Para PJ o conteudo deste campo deve ser SIM!")

			Case SA1->A1_PESSOA == "J"
				cRev	:= "2"
				cBlock	:= "1"
				lLib	:= .T.

			Case SA1->A1_PESSOA == "F" .AND. SA1->A1_LC <= nLinCredPF
				cRev	:= "4"
				cBlock	:= "2"			
				lLib	:= .T.
				
			Case SA1->A1_PESSOA == "F" .AND. SA1->A1_LC > nLinCredPF			
				cRev	:= "2"
				cBlock	:= "1"			
				lLib	:= .T.		
		EndCase

		cUsrLib	:= "A1_XUSCOME"
		cDhLLib	:= "A1_XDHCOME"
	ENDIF
Else
	MsgStop("Você não tem acesso a liberar cadastros!")
Endif

IF lLib
	RecLock("SA1",.F.)
	SA1->A1_XREV	:= cRev
	SA1->A1_MSBLQL	:= cBlock
	SA1->&(cUsrLib)	:= Alltrim(UsrFullName(RetCodUsr()))
	SA1->&(cDhLLib)	:= FWTimeStamp( 2 , DATE(), TIME())
	MsUnlock()
ENDIF


Return lLib


Static Function VisCli(nRecAuxSA1)

SA1->(DbGoTo( nRecAuxSA1 ))

// StaticCall(MATA030,A030Visual,nRecAuxSA1, 1)
MATA030( "A030Visual", 2 )

Return nil
