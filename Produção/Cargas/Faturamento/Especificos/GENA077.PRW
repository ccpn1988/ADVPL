#include "rwmake.ch"
#include "protheus.ch"

#DEFINE cEnt	Chr(13)+chr(10)

#DEFINE N_SEL		01	
#DEFINE N_SIT		02
#DEFINE N_FILIAL	03
#DEFINE N_PEDIDO	04
#DEFINE N_TIPO	05
#DEFINE N_CLIENTE	06
#DEFINE N_LOJA	07
#DEFINE N_NOME	08
#DEFINE N_TOT		09
#DEFINE N_EMIS	10
#DEFINE N_PDCLI	11
#DEFINE N_PGT		12
#DEFINE N_MSG		13
#DEFINE N_OBS		14
#DEFINE N_USR		15
#DEFINE N_PDWEB	16
#DEFINE N_RECSC5	17
#DEFINE N_SIZE	17

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA077   ºAutor  ³CLEUTO LIMA         º Data ³  16/10/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA077()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da rotina.                                                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cPerg		:= "GENA077"
Local aDados		:= {}
Local aQuery		:= {}

Local aPosObj    	:= {} 
Local aObjects   	:= {}                        
Local aSize      	:= MsAdvSize() 
Local aInfo		:= {}

Local bConfirm	:= {|| oDlgPed:End() }
Local bCancel		:= {|| oDlgPed:End() }
Local aButtons	:= {}

Local oDlgPed		:= Nil
Local nWidth 		:= 50
Local oFont		:= Nil
Local oBmp			:= Nil
Local oTFont 		:= TFont():New('Courier new',,-18,.T.)
Local lRet			:= .F.
Local lBitmap		:= .T. 
Local nLenPixel	:= 0
Local cCadastro	:= "Liberação de Regra"

Local nMbrWidth	:= 0
Local nMbrHeight	:= 0

Local nDtIni		:= SuperGetMv("GEN_FAT216",.f.,60)

Private oListBox	:= nil

Private oVerme	:= LoadBitMap(GetResources(),"BR_VERMELHO")
Private oVerde	:= LoadBitMap(GetResources(),"BR_VERDE")
Private oAmar		:= LoadBitMap(GetResources(),"BR_AMARELO")
Private oAzul		:= LoadBitMap(GetResources(),"BR_AZUL")
Private oBranco	:= LoadBitMap(GetResources(),"BR_BRANCO")
Private oLaran	:= LoadBitMap(GetResources(),"BR_LARANJA")
Private oPink		:= LoadBitMap(GetResources(),"br_pink")
Private oOk	  	:= LoadBitMap(GetResources(),"LBOK")
Private oNOk		:= LoadBitMap(GetResources(),"LBNO")
Private oPreto	:= LoadBitMap(GetResources(),"BR_PRETO")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿         
//³Define a area dos objetos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {} 
Aadd( aObjects, { 100, 100, .t., .t. } )

aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 

If aSize[3] == 0
	aSize :=  {0,0,800,800,1800,800,0}
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

@00,00 MSPANEL oMainTop PROMPT "" SIZE nMbrWidth,40/*nMbrHeight*0.10*/  of oDlgPed
oMainTop:Align := CONTROL_ALIGN_TOP
oGrpFilt		:= TGroup():New(05,05,(oMainTop:NCLIENTHEIGHT/2),(oMainTop:NCLIENTWIDTH/2)-10,"Ações",oMainTop,CLR_RED,,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³titulos.                                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgPed
oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT

oGrpXML	:= TGroup():New(05,05,(oMainCentro:NCLIENTHEIGHT/2)-40,(oMainCentro:NCLIENTWIDTH/2)-10,"Pedidos Bloqueados",oMainCentro,CLR_RED,,.T.)

oButPed 	:= TButton():New( 23, 015, "Visualizar"	, oMainTop,{|| VisPed(aDados[oListBox:nAT][N_RECSC5]) },50,010,,,,.T.)
oButReg 	:= TButton():New( 23, 080, "Blq. Regras"	, oMainTop,{|| RetBlq(aDados[oListBox:nAT][N_RECSC5]) },50,010,,,,.T.)
oButSair 	:= TButton():New( 23, 145, "Sair"			, oMainTop,bConfirm,50,010,,,,.T.)

oButLb 	:= TButton():New( 23, 250, "Liberar"	, oMainTop,{|x| LiberPd(aDados[oListBox:nAT][N_RECSC5],@aDados,nDtIni) },50,010,,,,.T.)
oButLb:SetCss( "QPushButton{ background-color:DeepSkyBlue;}" )

oButRef 	:= TButton():New( 23, 315, "Atualizar Lista"	, oMainTop,{|x| PedRef(@aDados,nDtIni) },50,010,,,,.T.)
oButRef:SetCss( "QPushButton{ background-color:rgb(255, 242, 0);}" )

aHList	:= {}

Processa({|| CargaBase(@aDados,nDtIni)	},"Consultando Pedidos...") 

oListBox := TWBrowse():New(15,10,(oMainCentro:NCLIENTWIDTH/2)-30,(oMainCentro:NCLIENTHEIGHT/2)-60,,aHList,,oMainCentro,,,,,,,,,,,,, "ARRAY", .T. )

//oListBox:AddColumn(TCColumn():New(" "		,{|| IIF( aDados[oListBox:nAT][N_SEL] , oOk , oNOk )				},,,,'CENTER'	,10,.T.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New(" "		,{|| RetSit(aDados[oListBox:nAT][N_SIT])		},,,,'CENTER'	,25,lBitmap,.F.,,,,.F.,))

//CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,alltrim(SX3->X3_PICTURE),SX3->(X3Titulo()))
//nLenPixel	:= CalcFieldSize("C",20,0,"","Filial")
//oListBox:AddColumn(TCColumn():New("Filial"	,{|| aDados[oListBox:nAT][N_FILIAL]			},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",06,0,"999999","Pedido")
oListBox:AddColumn(TCColumn():New("Pedido"	,{|| aDados[oListBox:nAT][N_PEDIDO]			},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",60,0,"@!","Nome")
oListBox:AddColumn(TCColumn():New("Nome",{|| aDados[oListBox:nAT][N_NOME]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

//nLenPixel	:= CalcFieldSize("C",20,0,"","Tipo Pedido")
//oListBox:AddColumn(TCColumn():New("Tipo Pedido",{|| RetTipo(aDados[oListBox:nAT][N_TIPO])		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",10,0,"","Cliente")
oListBox:AddColumn(TCColumn():New("Cliente",{|| aDados[oListBox:nAT][N_CLIENTE]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",02,0,"","Loja")
oListBox:AddColumn(TCColumn():New("Loja",{|| aDados[oListBox:nAT][N_LOJA]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("N",050,0,"@E 999.999.999,99","Total Pedido")
oListBox:AddColumn(TCColumn():New("Total Pedido",{|| aDados[oListBox:nAT][N_TOT]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("N",020,0,"@D","Emissão")
oListBox:AddColumn(TCColumn():New("Emissão",{|| aDados[oListBox:nAT][N_EMIS]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",015,0,"","Pedido Web")
oListBox:AddColumn(TCColumn():New("Pedido Web",{|| aDados[oListBox:nAT][N_PDWEB]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))
/*
nLenPixel	:= CalcFieldSize("C",20,0,"@!","Ped.Cliente")
oListBox:AddColumn(TCColumn():New("Ped.Cliente",{|| aDados[oListBox:nAT][N_PDCLI]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",03,0,"@!","Cod.Pagto")
oListBox:AddColumn(TCColumn():New("Cod.Pagto",{|| aDados[oListBox:nAT][N_PGT]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",200,0,"","Mens.p/Nota")
oListBox:AddColumn(TCColumn():New("Mens.p/Nota",{|| aDados[oListBox:nAT][N_MSG]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",200,0,"","Obs.Interna")
oListBox:AddColumn(TCColumn():New("Obs.Interna",{|| aDados[oListBox:nAT][N_OBS]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",050,0,"","Usr.Digita.")
oListBox:AddColumn(TCColumn():New("Usr.Digita.",{|| aDados[oListBox:nAT][N_USR]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))
*/
oListBox:SetArray( aDados )

//AADD(aButtons, {"cargaseq",	{|| Processa({|| GENMF03B(.T.) , U_GENMF004() , GENMF03B(.F.) , Processa({|| CargaBase(@aQuery,@aDados)	},"Consultando titulos...")	},"Processando...")  }, "Registros Conciliação"})
//oListBox:bLDblClick	:= {|x| aDados[oListBox:nAT][N_SEL] := !aDados[oListBox:nAT][N_SEL] }

Activate MsDialog oDlgPed// On Init EnchoiceBar(oDlgPed,bConfirm,bCancel,,aButtons) Centered

FreeObj(oVerme)
FreeObj(oVerde)
FreeObj(oAmar)
FreeObj(oAzul)
FreeObj(oBranco)
FreeObj(oOk)
FreeObj(oNOk)
FreeObj(oTFont)
FreeObj(oLaran)
FreeObj(oPink)
FreeObj(oPreto)

Return nil


Static Function CargaBase(aDados,nDtIni)

Local aArea	:= GetArea()
Local cDtIni	:= DtoS(DDataBase-nDtIni)

aDados	:= {}

If Select("TMP_PED") > 0
	TMP_PED->(DbCloseArea())
EndIf

BeginSql Alias "TMP_PED"
	SELECT C5_NUM,SC5.C5_TIPO,SC5.C5_CLIENTE,SC5.C5_LOJACLI,A1_NREDUZ,C5_EMISSAO,SC5.C5_XPEDCLI,SC5.C5_CONDPAG,SC5.C5_MENNOTA,SC5.C5_XOBS,SC5.C5_XUSRDIG,C5_BLQ,
	/*
	(
	SELECT SUM(C6_VALOR) FROM %Table:SC6% SC6 WHERE C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC6.%NotDel%
	) VALOR*/
	C5_XVALTOT,
	C5_XPEDWEB,
	SC5.R_E_C_N_O_ RECSC5
	FROM %Table:SC5% SC5
	JOIN %Table:SA1% SA1
	ON A1_FILIAL = %xFilial:SA1%
	AND A1_COD = C5_CLIENTE
	AND A1_LOJA = C5_LOJACLI
	AND SA1.%NotDel%
	WHERE C5_FILIAL = %xFilial:SC5%
	AND C5_EMISSAO >= %Exp:cDtIni%
	AND SC5.%NotDel%
	AND SC5.C5_BLQ <> ' '
	ORDER BY C5_EMISSAO DESC,C5_NUM
EndSql

TMP_PED->(DbGoTop())

While TMP_PED->(!EOF())

	Aadd(aDados,Array(N_SIZE))

	aDados[Len(aDados)][N_SEL]		:= .F.
	aDados[Len(aDados)][N_SIT]		:= TMP_PED->C5_BLQ
	aDados[Len(aDados)][N_FILIAL]	:= AllTrim(cFilAnt)+"-"+AllTrim(SM0->M0_FILIAL)
	aDados[Len(aDados)][N_PEDIDO]	:= TMP_PED->C5_NUM
	aDados[Len(aDados)][N_TIPO]		:= TMP_PED->C5_TIPO
	aDados[Len(aDados)][N_CLIENTE]	:= TMP_PED->C5_CLIENTE
	aDados[Len(aDados)][N_LOJA]		:= TMP_PED->C5_LOJACLI
	aDados[Len(aDados)][N_NOME]		:= TMP_PED->A1_NREDUZ
	aDados[Len(aDados)][N_TOT]		:= TMP_PED->C5_XVALTOT
	aDados[Len(aDados)][N_EMIS]		:= StoD(TMP_PED->C5_EMISSAO)
	aDados[Len(aDados)][N_PDCLI]	:= TMP_PED->C5_XPEDCLI
	aDados[Len(aDados)][N_PGT]		:= TMP_PED->C5_CONDPAG
	aDados[Len(aDados)][N_MSG]		:= TMP_PED->C5_MENNOTA
	aDados[Len(aDados)][N_OBS]		:= TMP_PED->C5_XOBS
	aDados[Len(aDados)][N_USR]		:= TMP_PED->C5_XUSRDIG
	aDados[Len(aDados)][N_PDWEB]	:= TMP_PED->C5_XPEDWEB
	aDados[Len(aDados)][N_RECSC5]	:= TMP_PED->RECSC5

	TMP_PED->(DbSkip())	
EndDo

TMP_PED->(DbCloseArea())
RestArea(aArea)

Return nil

Static Function RetSit(cSit)

Local cRet	:= ""

Do Case
	Case cSit == "1"	
		cRet		:= oAzul
	Case cSit == "2"	
		cRet		:= oLaran
	Case cSit == "3"	
		cRet		:= oPink
	Case cSit == "4"	
		cRet		:= oPreto
EndCase
	
Return cRet

Static Function RetTipo(cTipo)

Local cRet			:= ""
Local aTipos		:= {{"N","Normal"},{"C","Compl.Preco/Quantidade"},{"I","Compl.ICMS"},{"P","Compl.IPI"},{"D","Dev.Compras"},{"B","Utiliza Fornecedor"}}
Local nPosTipo	:= 0
 
nPosTipo := aScan(aTipos,{|x| x[1]==cTipo })
If nPosTipo > 0
	cRet := aTipos[nPosTipo][2]
EndIf

Return cRet

Static Function RetBlq(nRecSC5)

SC5->(DbGoto(nRecSC5))
SA1->(DbsetOrder(1))
SA1->(DBSEEK(XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))

U_GENA007()

Return nil
                                  
Static Function VisPed(nRecSC5)

Private Inclui    	:= .F. //defino que a inclusão é falsa
Private Altera    	:= .F. //defino que a alteração é verdadeira
Private nOpca     	:= 1   //obrigatoriamente passo a variavel nOpca com o conteudo 1
Private cCadastro 	:= "Pedido de Vendas" //obrigatoriamente preciso definir com private a variável cCadastro
Private aRotina		:= {} //obrigatoriamente preciso definir a variavel aRotina como private
 
DbSelectArea("SC5")
SC5->(DbGoTo(nRecSC5))
MatA410(Nil, Nil, Nil, Nil, "A410Visual") //executo a função padrão MatA410

Return nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ft210Liber³Autor  ³ Eduardo Riera         ³ Data ³13.09.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Libera o pedido de vendas                                    ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina chama a liberacao do pedido de vendas            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function LiberPd(nRecSC5,aDados,nDtIni)

DbSelectArea("SC5")
SC5->(DbGoTo(nRecSC5))

If Empty(SC5->C5_BLQ)
	MsgStop("Pedido já liberado!")
Else
	Ft210Liber()	
EndIf

Processa({|| CargaBase(@aDados,nDtIni)	},"Consultando Pedidos...")

oListBox:SetArray( aDados )

Return 


Static Function PedRef(aDados,nDtIni)

Processa({|| CargaBase(@aDados,nDtIni)	},"Consultando Pedidos...")

oListBox:SetArray( aDados )

Return 
