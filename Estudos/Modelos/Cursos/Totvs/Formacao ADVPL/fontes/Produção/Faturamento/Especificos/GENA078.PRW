#include "rwmake.ch"
#include "protheus.ch"

#DEFINE cEnt	Chr(13)+chr(10)

#DEFINE N_FILIAL		01
#DEFINE N_A4_NOME		02
#DEFINE N_A1_NOME		03
#DEFINE N_A1_NREDU	04
#DEFINE N_C9_PEDID	05
#DEFINE N_BLOQUEIO	06
#DEFINE N_LIBERACA	07
#DEFINE N_C5_TIPO		08
#DEFINE N_C5_CLIEN	09
#DEFINE N_C5_LOJAC	10
#DEFINE N_C5_XPEDC	11
#DEFINE N_C5_TPFRE	12
#DEFINE N_C5_TRANS	13
#DEFINE N_C5_TIPOC	14
#DEFINE N_C5_CONDP	15
#DEFINE N_C5_EMISS	16
#DEFINE N_C5_FRETE	17
#DEFINE N_C5_XPEDO	18
#DEFINE N_C5_XQTDT	19
#DEFINE N_C5_XVALT	20
#DEFINE N_C5_XPEDW	21
#DEFINE N_SIT			22
#DEFINE N_RECSC5		23
#DEFINE N_BLCRED		24
#DEFINE N_BLEST		25
#DEFINE N_RECBLE		26
#DEFINE N_RECBLC		27
#DEFINE N_RECSC9		28
#DEFINE N_SIZE		28


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA078   ºAutor  ³CLEUTO LIMA         º Data ³  16/10/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA078()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da rotina.                                                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cPerg		:= "GENA078"
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
Local cCadastro	:= "Analise Credito/Estoque"

Local nMbrWidth	:= 0
Local nMbrHeight	:= 0

Local 	lCred		:= VerSenha(136)
Local 	lEsto		:= VerSenha(137)

Local nDtIni		:= SuperGetMv("GEN_FAT216",.f.,60)
Local aAcess		:= StrTokArr(SuperGetMv("GEN_FAT217",.f.,""),";")

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

IF aScan(aAcess,AllTrim(__cUserID)) == 0
	MsgStop("Usuário sem acesso!"+Chr(13)+Chr(10)+"entre em contato com a TI solicitando acesso a rotina!"+Chr(13)+Chr(10)+"Seu código de usuário é "+AllTrim(__cUserID)+" e deve ser incluido no parametro GEN_FAT2017!")
	Return nil
EndIf

Processa({|| CargaBase(@aDados,nDtIni)	},"Consultando Pedidos...")

If Len(aDados) == 0	
	MsgStop("Não foram encontrados pedidos com bloqueio!")	
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

@00,00 MSPANEL oMainTop PROMPT "" SIZE nMbrWidth,50/*nMbrHeight*0.10*/  of oDlgPed
oMainTop:Align := CONTROL_ALIGN_TOP
oGrpFilt		:= TGroup():New(05,05,(oMainTop:NCLIENTHEIGHT/2),(oMainTop:NCLIENTWIDTH/2)-10,"Ações",oMainTop,CLR_RED,,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³titulos.                                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgPed
oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT

oGrpXML	:= TGroup():New(05,05,(oMainCentro:NCLIENTHEIGHT/2)-40,(oMainCentro:NCLIENTWIDTH/2)-10,"Pedidos Bloqueados",oMainCentro,CLR_RED,,.T.)

oButPed 	:= TButton():New( 20, 015, "Visualizar"	, oMainTop,{|| VisPed(aDados[oListBox:nAT][N_RECSC5]) },50,010,,,,.T.)
//oButReg 	:= TButton():New( , "Blq. Regras"	, oMainTop,{|| .T. },50,010,,,,.T.)
oButSair 	:= TButton():New( 35, 015, "Sair"			, oMainTop,bConfirm,50,010,,,,.T.)

oButRef 	:= TButton():New( 20, 080, "Atualizar Lista"	, oMainTop,{|x| PedRef(@aDados,nDtIni) },50,010,,,,.T.)
oButRef:SetCss( "QPushButton{ background-color:rgb(255, 242, 0);}" )

If lCred
	oButCli 	:= TButton():New( 35, 080, "Consulta Clientes"	, oMainTop,{|x| ConsCli(aDados[oListBox:nAT][N_RECSC5],aDados[oListBox:nAT][N_RECSC9],@aDados,nDtIni,oDlgPed) },50,010,,,,.T.)
	oButCli:SetCss( "QPushButton{ background-color:rgb(255, 242, 0);}" )

	oLbCrd 	:= TButton():New( 20, 145, "Lib.Credito"	, oMainTop,{|x| LibCred(aDados[oListBox:nAT][N_RECSC5],aDados[oListBox:nAT][N_RECSC9],@aDados,nDtIni) },50,010,,,,.T.)
	oLbCrd:SetCss( "QPushButton{ background-color:DeepSkyBlue;}" )
EndIf

If lEsto
	oLbEst 	:= TButton():New( 35, 145, "Lib.Estoque"	, oMainTop,{|x| NewLibEst(aDados[oListBox:nAT][N_RECSC5],aDados[oListBox:nAT][N_RECSC9],@aDados,nDtIni,aDados[oListBox:nAT][N_BLCRED]) },50,010,,,,.T.)
	oLbEst:SetCss( "QPushButton{ background-color:DeepSkyBlue;}" )
EndIf

If lCred .AND. lEsto
	oButLb 	:= TButton():New( 20, 210, "Lib.Cred. + Estoq."	, oMainTop,{|x| LiberPd(aDados[oListBox:nAT][N_RECSC5],aDados[oListBox:nAT][N_RECSC9],@aDados,nDtIni) },50,010,,,,.T.)
	oButLb:SetCss( "QPushButton{ background-color:DeepSkyBlue;}" )
EndIf

If lCred
	oPosCli 	:= TButton():New( 35, 210, "Analise Cred.Cli."	, oMainTop,{|x| AnaCliCred(aDados[oListBox:nAT][N_RECSC5],aDados[oListBox:nAT][N_RECSC9],@aDados,nDtIni,oDlgPed) },50,010,,,,.T.)
	oPosCli:SetCss( "QPushButton{ background-color:DeepSkyBlue;}" )
EndIf

aHList	:= {}

oListBox := TWBrowse():New(15,10,(oMainCentro:NCLIENTWIDTH/2)-30,(oMainCentro:NCLIENTHEIGHT/2)-60,,aHList,,oMainCentro,,,,,,,,,,,,, "ARRAY", .T. )

oListBox:AddColumn(TCColumn():New("Credito"		,{|| IIF(aDados[oListBox:nAT][N_BLCRED]	, oVerme , oVerde )		},,,,'CENTER'	,25,.T.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Estoque"		,{|| IIF(aDados[oListBox:nAT][N_BLEST]		, oVerme , oVerde )		},,,,'CENTER'	,25,.T.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",50,0,"","Tipo Bloqueio")
oListBox:AddColumn(TCColumn():New("Tipo Bloqueio"	,{|| aDados[oListBox:nAT][N_BLOQUEIO]			},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))


//CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,alltrim(SX3->X3_PICTURE),SX3->(X3Titulo()))
nLenPixel	:= CalcFieldSize("C",20,0,"","Filial")
oListBox:AddColumn(TCColumn():New("Filial"	,{|| aDados[oListBox:nAT][N_FILIAL]			},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",06,0,"999999","Pedido")
oListBox:AddColumn(TCColumn():New("Pedido"	,{|| aDados[oListBox:nAT][N_C9_PEDID]			},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",20,0,"","Tipo Pedido")
oListBox:AddColumn(TCColumn():New("Tipo Pedido",{|| aDados[oListBox:nAT][N_C5_TIPO]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",10,0,"","Cliente")
oListBox:AddColumn(TCColumn():New("Cliente",{|| aDados[oListBox:nAT][N_C5_CLIEN]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",02,0,"","Loja")
oListBox:AddColumn(TCColumn():New("Loja",{|| aDados[oListBox:nAT][N_C5_LOJAC]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",60,0,"@!","Nome")
oListBox:AddColumn(TCColumn():New("Nome",{|| aDados[oListBox:nAT][N_A1_NOME]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("N",050,0,"@E 999.999.999,99","Total Pedido")
oListBox:AddColumn(TCColumn():New("Total Pedido",{|| aDados[oListBox:nAT][N_C5_XVALT]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("N",050,0,"@E 999.999.999,99","Frete")
oListBox:AddColumn(TCColumn():New("Frete",{|| aDados[oListBox:nAT][N_C5_FRETE]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("N",020,0,"@D","Emissão")
oListBox:AddColumn(TCColumn():New("Emissão",{|| aDados[oListBox:nAT][N_C5_EMISS]		},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",015,0,"","Pedido Web")
oListBox:AddColumn(TCColumn():New("Pedido Web",{|| aDados[oListBox:nAT][N_C5_XPEDW]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",20,0,"@!","Ped.Cliente")
oListBox:AddColumn(TCColumn():New("Ped.Cliente",{|| aDados[oListBox:nAT][N_C5_XPEDC]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",03,0,"@!","Cond.Pagto")
oListBox:AddColumn(TCColumn():New("Cod.Pagto",{|| aDados[oListBox:nAT][N_C5_CONDP]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",20,0,"@!","Tipo Cli.")
oListBox:AddColumn(TCColumn():New("Tipo Cli.",{|| aDados[oListBox:nAT][N_C5_TIPOC]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",20,0,"@!","Tipo Frete")
oListBox:AddColumn(TCColumn():New("Tipo Frete",{|| aDados[oListBox:nAT][N_C5_TPFRE]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel	:= CalcFieldSize("C",60,0,"@!","Transportadora")
oListBox:AddColumn(TCColumn():New("Transportadora",{|| aDados[oListBox:nAT][N_A4_NOME]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))



//nLenPixel	:= CalcFieldSize("C",200,0,"","Mens.p/Nota")
//oListBox:AddColumn(TCColumn():New("Mens.p/Nota",{|| aDados[oListBox:nAT][N_MSG]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))
//nLenPixel	:= CalcFieldSize("C",200,0,"","Obs.Interna")
//oListBox:AddColumn(TCColumn():New("Obs.Interna",{|| aDados[oListBox:nAT][N_OBS]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))
//nLenPixel	:= CalcFieldSize("C",050,0,"","Usr.Digita.")
//oListBox:AddColumn(TCColumn():New("Usr.Digita.",{|| aDados[oListBox:nAT][N_USR]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

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
	SELECT 
	A4_NOME,A1_NOME,A1_NREDUZ,
	C9_PEDIDO, 
	CASE 
	WHEN LIBERACAO LIKE '%01%' THEN 'Bloqueio de Crédito por Valor | '
	END||
	CASE 
	WHEN LIBERACAO LIKE '%02%' THEN 'Bloqueio de Estoque | '
	END||
	CASE 
	WHEN LIBERACAO LIKE '%03%' THEN 'Bloqueio Manual de Estoque | '
	END||
	CASE 
	WHEN LIBERACAO LIKE '%04%' THEN 'Vencimento do Limite de Crédito - Data de Crédito Vencida | '
	END||
	CASE 
	WHEN LIBERACAO LIKE '%05%' THEN 'Bloqueio Manual/Estorno | '
	END
	BLOQUEIO,LIBERACAO,
	CASE 
	  C5_TIPO 
	  WHEN 'N' THEN 'Normal'
	  WHEN 'C' THEN 'Compl.Preco/Quantidade'
	  WHEN 'I' THEN 'Compl.ICMS'
	  WHEN 'P' THEN 'Compl.IPI'
	  WHEN 'D' THEN 'Dev.Compras'
	  WHEN 'B' THEN 'Utiliza Fornecedor' 
	END C5_TIPO
	, C5_CLIENTE, C5_LOJACLI,C5_XPEDCLI, 
	CASE C5_TPFRETE
	  WHEN 'C' THEN 'CIF'
	  WHEN 'F' THEN 'FOB'
	  WHEN 'T' THEN 'Por conta terceiros'
	  WHEN 'S' THEN 'Sem frete' 
	  ELSE 'Sem frete' 
	END C5_TPFRETE, C5_TRANSP, 
	CASE C5_TIPOCLI
	  WHEN 'F' THEN 'Cons.Final'
	  WHEN 'L' THEN 'Prod.Rural'
	  WHEN 'R' THEN 'Revendedor'
	  WHEN 'S' THEN 'Solidario'
	  WHEN 'X' THEN 'Exportacao/Importacao' 
	END C5_TIPOCLI, C5_CONDPAG, C5_EMISSAO, C5_FRETE, C5_XPEDOLD, C5_XQTDTOT, C5_XVALTOT, C5_XPEDWEB,RECSC5,RECSC9,RECSC9_CRE,RECSC9_EST FROM (
	SELECT LISTAGG(LIBERACAO, '#' ) WITHIN GROUP (ORDER BY LIBERACAO) LIBERACAO,C5_TIPO, C5_CLIENTE, C5_LOJACLI,C9_PEDIDO ,C5_XPEDCLI, C5_TPFRETE, C5_TRANSP, C5_TIPOCLI, C5_CONDPAG, C5_EMISSAO, C5_FRETE, C5_XPEDOLD, C5_XQTDTOT, C5_XVALTOT, C5_XPEDWEB,RECSC5,MAX(RECSC9) RECSC9,MAX(RECSC9_CRE) RECSC9_CRE,MAX(RECSC9_EST) RECSC9_EST FROM (
	
	SELECT C5_TIPO, C5_CLIENTE, C5_LOJACLI,C9_PEDIDO,C5_XPEDCLI, C5_TPFRETE, C5_TRANSP, C5_TIPOCLI, C5_CONDPAG, C5_EMISSAO, C5_FRETE, C5_XPEDOLD, C5_XQTDTOT, C5_XVALTOT, C5_XPEDWEB, 
	CASE 
	WHEN SC9.C9_BLCRED <> '  ' AND SC9.C9_BLEST <> '  ' THEN SC9.C9_BLCRED||'-'||SC9.C9_BLEST 
	WHEN SC9.C9_BLCRED <> '  ' AND SC9.C9_BLEST = '  ' THEN SC9.C9_BLCRED
	WHEN SC9.C9_BLCRED = '  ' AND SC9.C9_BLEST <> '  ' THEN SC9.C9_BLEST
	END LIBERACAO,
	SC5.R_E_C_N_O_ RECSC5,
	MAX(CASE WHEN C9_BLCRED <> ' ' THEN SC9.R_E_C_N_O_ ELSE 0 END ) RECSC9_CRE ,
	MAX(CASE WHEN C9_BLEST <> ' ' THEN SC9.R_E_C_N_O_ ELSE 0 END ) RECSC9_EST, 
	MAX(SC9.R_E_C_N_O_) RECSC9
	FROM %Table:SC5% SC5
	JOIN %Table:SC9% SC9
	ON SC9.C9_FILIAL = SC5.C5_FILIAL
	AND SC9.C9_PEDIDO = SC5.C5_NUM
	AND SC9.%NotDel%
	AND ( SC9.C9_BLEST NOT IN ('  ','10','ZZ') OR SC9.C9_BLCRED NOT IN ('  ','10','ZZ'))      
	WHERE C5_FILIAL = %xFilial:SC5%
	    AND C5_EMISSAO >= %Exp:cDtIni%
	    AND SC5.%NotDel%
	    AND C5_LIBEROK = 'S'
	    AND C5_BLQ = ' '
	    AND SC5.C5_NOTA NOT LIKE '%X%'
	GROUP BY CASE 
	WHEN SC9.C9_BLCRED <> '  ' AND SC9.C9_BLEST <> '  ' THEN SC9.C9_BLCRED||'-'||SC9.C9_BLEST 
	WHEN SC9.C9_BLCRED <> '  ' AND SC9.C9_BLEST = '  ' THEN SC9.C9_BLCRED
	WHEN SC9.C9_BLCRED = '  ' AND SC9.C9_BLEST <> '  ' THEN SC9.C9_BLEST
	END,C5_TIPO, C5_CLIENTE, C5_LOJACLI,C9_PEDIDO,C5_XPEDCLI, C5_TPFRETE, C5_TRANSP, C5_TIPOCLI, C5_CONDPAG, C5_EMISSAO, C5_FRETE, C5_XPEDOLD, C5_XQTDTOT, C5_XVALTOT, C5_XPEDWEB,SC5.R_E_C_N_O_ 
	) TMP GROUP BY C5_TIPO, C5_CLIENTE, C5_LOJACLI,C9_PEDIDO ,C5_XPEDCLI, C5_TPFRETE, C5_TRANSP, C5_TIPOCLI, C5_CONDPAG, C5_EMISSAO, C5_FRETE, C5_XPEDOLD, C5_XQTDTOT, C5_XVALTOT, C5_XPEDWEB,RECSC5 ) TMP2
	JOIN %Table:SA1% SA1
	ON A1_FILIAL = %xFilial:SA1%
	AND A1_COD = C5_CLIENTE
	AND A1_LOJA = C5_LOJACLI
	AND SA1.%NotDel%
	LEFT JOIN %Table:SA4% SA4
	ON A4_FILIAL = %xFilial:SA4%
	AND A4_COD = C5_TRANSP
	AND SA4.%NotDel%
	ORDER BY C5_EMISSAO
EndSql

TMP_PED->(DbGoTop())

While TMP_PED->(!EOF())

	Aadd(aDados,Array(N_SIZE))

	aDados[Len(aDados)][N_SIT]			:= TMP_PED->LIBERACAO

	aDados[Len(aDados)][N_BLCRED]		:= "01" $ TMP_PED->LIBERACAO .OR. "04" $ TMP_PED->LIBERACAO 
	aDados[Len(aDados)][N_BLEST]		:= "02" $ TMP_PED->LIBERACAO .OR. "03" $ TMP_PED->LIBERACAO .OR. "05" $ TMP_PED->LIBERACAO 
	
	aDados[Len(aDados)][N_FILIAL]		:= AllTrim(cFilAnt)+"-"+AllTrim(SM0->M0_FILIAL)
	aDados[Len(aDados)][N_A4_NOME]		:= TMP_PED->A4_NOME
	aDados[Len(aDados)][N_A1_NOME]		:= TMP_PED->A1_NOME
	aDados[Len(aDados)][N_A1_NREDU]		:= TMP_PED->A1_NREDUZ
	aDados[Len(aDados)][N_C9_PEDID]		:= TMP_PED->C9_PEDIDO
	aDados[Len(aDados)][N_BLOQUEIO]		:= Left(TMP_PED->BLOQUEIO,len(alltrim(TMP_PED->BLOQUEIO))-1)
	aDados[Len(aDados)][N_LIBERACA]		:= TMP_PED->LIBERACAO
	aDados[Len(aDados)][N_C5_TIPO]		:= TMP_PED->C5_TIPO
	aDados[Len(aDados)][N_C5_CLIEN]		:= TMP_PED->C5_CLIENTE
	aDados[Len(aDados)][N_C5_LOJAC]		:= TMP_PED->C5_LOJACLI
	aDados[Len(aDados)][N_C5_XPEDC]		:= TMP_PED->C5_XPEDCLI
	aDados[Len(aDados)][N_C5_TPFRE]		:= TMP_PED->C5_TPFRETE
	aDados[Len(aDados)][N_C5_TRANS]		:= TMP_PED->C5_TRANSP
	aDados[Len(aDados)][N_C5_TIPOC]		:= TMP_PED->C5_TIPOCLI
	aDados[Len(aDados)][N_C5_CONDP]		:= TMP_PED->C5_CONDPAG
	aDados[Len(aDados)][N_C5_EMISS]		:= StoD(TMP_PED->C5_EMISSAO)
	aDados[Len(aDados)][N_C5_FRETE]		:= TMP_PED->C5_FRETE
	aDados[Len(aDados)][N_C5_XPEDO]		:= TMP_PED->C5_XPEDOLD
	aDados[Len(aDados)][N_C5_XQTDT]		:= TMP_PED->C5_XQTDTOT
	aDados[Len(aDados)][N_C5_XVALT]		:= TMP_PED->C5_XVALTOT
	aDados[Len(aDados)][N_C5_XPEDW]		:= TMP_PED->C5_XPEDWEB
	aDados[Len(aDados)][N_RECSC5]		:= TMP_PED->RECSC5
	aDados[Len(aDados)][N_RECBLE]		:= TMP_PED->RECSC9_EST
	aDados[Len(aDados)][N_RECBLC]		:= TMP_PED->RECSC9_CRE
	aDados[Len(aDados)][N_RECSC9]		:= TMP_PED->RECSC9
	
	
	TMP_PED->(DbSkip())	
EndDo

TMP_PED->(DbCloseArea())
RestArea(aArea)

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

Static Function LibCred(nRecSC5,nRecSC9,aDados,nDtIni)

Private cCadastro := OemToAnsi("Liberação Credito / Estoque")
Private nOpc		:= 1
Private aRotina := MenuDef()

Private ALTERA	:= .F.
Private INCLUI	:= .F.

DbSelectArea("SC5")
SC5->(DbGoTo(nRecSC5))

DbSelectArea("SC9")
SC9->(DbGoTo(nRecSC9))

MATA450(3,.T.)

Processa({|| CargaBase(@aDados,nDtIni)	},"Consultando Pedidos...")

oListBox:SetArray( aDados )

Return 

Static Function LiberPd(nRecSC5,nRecSC9,aDados,nDtIni)

Private cCadastro := OemToAnsi("Liberação Credito / Estoque")
Private nOpc		:= 1
Private aRotina := MenuDef()

Private ALTERA	:= .F.
Private INCLUI	:= .F.

DbSelectArea("SC5")
SC5->(DbGoTo(nRecSC5))

DbSelectArea("SC9")
SC9->(DbGoTo(nRecSC9))

A456LibMan("SC9")

Processa({|| CargaBase(@aDados,nDtIni)	},"Consultando Pedidos...")

oListBox:SetArray( aDados )

Return 


Static Function PedRef(aDados,nDtIni)

Processa({|| CargaBase(@aDados,nDtIni)	},"Consultando Pedidos...")

oListBox:SetArray( aDados )

Return 

/* MenuDef - apenas para compatibilidade com a função padrão  */

Static Function MenuDef()
     

Private aRotina := {	{"Pesquisar","PesqBrw"		,0,1,0,.F.},;	// "Pesquisar"
							{ "Autom tica","A456LibAut"	,0,0,0,NIL},;	// "Autom tica"
							{ "Manual","A456LibMan"	,0,0,0,NIL},;	// "Manual"
							{"Legenda","A450Legend"	,0,0,0,.F.}}	// "Legenda"

If ExistBlock("MTA456MNU")
	ExecBlock("MTA456MNU",.F.,.F.)
EndIf

Return(aRotina)

Static Function AnaCliCred(nRecSC5,nRecSC9,aDados,nDtIni,oDlgPed,lCliPad)

Local aArea		:= GetArea()
Local cAliasTRB	:= nil
Local cNomeTrb	:= nil
Local aBrowse		:= {}
Local lEnd			:= .F.
Local lCria		:= .T.
Local cAliasPed	:= nil
Local cNomePed	:= nil 
Local cCliAux 	:= ""
Local cLojAux 	:= ""
Private cCadastro := OemToAnsi("Liberação Credito / Estoque")
Private nOpc		:= 1
Private aRotina := MenuDef()

Private ALTERA	:= .F.
Private INCLUI	:= .F.

Default lCliPad	:= .F.

If lCliPad
	cCliAux := SA1->A1_COD
	cLojAux := SA1->A1_LOJA
Else
	DbSelectArea("SC5")
	SC5->(DbGoTo(nRecSC5))
	
	DbSelectArea("SC9")
	SC9->(DbGoTo(nRecSC9))

	cCliAux := SC5->C5_CLIENTE
	cLojAux := SC5->C5_LOJACLI 	 			
EndIf

SA1->(DbsetOrder(1))
SA1->(DbSeek( xFilial("SA1")+cCliAux+cLojAux ))

xMa450PCli(@cAliasTRB,@cNomeTrb,@aBrowse,lEnd,lCria,@cAliasPed,@cNomePed)

SA1->(DbsetOrder(1))
SA1->(DbSeek( xFilial("SA1")+cCliAux+cLojAux ))
	
OTEMPTBTRB := FWTemporaryTable():New("PEDX") 
OTEMPTBTRB:SetFields( PED->(dbStruct()) )
//------------------
//Criação da tabela
//------------------
OTEMPTBTRB:Create()

Ma450ClMan(cAliasTRB)

PEDX->(DbCloseArea())
PED->(DbCloseArea())

FreeObj(OTEMPTBTRB)

Processa({|| CargaBase(@aDados,nDtIni)	},"Consultando Pedidos...")

oListBox:SetArray( aDados )

Return nil

Static Function xMa450PCli(cAliasTrb,cNomeTrb,aBrowse,lEnd,lCria,cAliasPed,cNomePed)

Local aArea     := GetArea()
Local aStruSA1  := {}
Local AStruSC5  := {}
Local cQuery    := ""
Local cAliasSA1 := "SA1"
Local cAliasSC5 := "SC5"
Local cAliasSC9 := "SC9"
Local cNomeSC9  := CriaTrab(,.F.)
Local lQuery    := .F.
Local lEmpresa  := FWModeAccess("SA1",3)=="C"
Local nX        := 0

DEFAULT cAliasTRB := ""
DEFAULT cNomeTrb  := ""
DEFAULT aBrowse   := {}
DEFAULT lCria     := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria os arquivos de trabalho                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SA1")
While !Eof() .And. SX3->X3_ARQUIVO == "SA1"
	If (SX3->X3_BROWSE == "S" .Or. AllTrim(SX3->X3_CAMPO)$"A1_COD,A1_LOJA,A1_NOME") .And.;
		SX3->X3_CONTEXT <> "V"
		aadd(aStruSA1,{ SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL })
		aadd(aBrowse,{X3TITULO(),SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE})
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo       
*/

aCampos := FWSX3Util():GetAllFields( "SA1", .F. )
For xLoop := 1 To Len(aCampos)
	If (Posicione("SX3",2,aCampos[xLoop],"X3_BROWSE") == "S" .Or. AllTrim(aCampos[xLoop])$"A1_COD,A1_LOJA,A1_NOME") .And.;
		Posicione("SX3",2,aCampos[xLoop],"X3_CONTEXT") <> "V"
						 //SX3->X3_CAMPO, 							SX3->X3_TIPO, 			SX3->X3_TAMANHO, 			SX3->X3_DECIMAL
		Aadd(aStruSA1, {aCampos[xLoop],FWSX3Util():GetFieldType(aCampos[xLoop]),TamSx3(aCampos[xLoop])[1],TamSx3(aCampos[xLoop])[2]} ) 
						//X3TITULO()								,SX3->X3_CAMPO ,							 SX3->X3_TIPO,			 SX3->X3_TAMANHO,			SX3->X3_DECIMAL,							SX3->X3_PICTURE		
		Aadd(aBrowse,  {Posicione("SX3",2,aCampos[xLoop],"X3_TITULO"),aCampos[xLoop],FWSX3Util():GetFieldType(aCampos[xLoop]),TamSx3(aCampos[xLoop])[1],TamSx3(aCampos[xLoop])[2],Posicione("SX3",2,aCampos[xLoop],"X3_PICTURE")})			
	EndIf
Next xLoop

aadd(aStruSC5,{"C5_VALOR","N",18,2})

/*
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC5")
While !Eof() .And. SX3->X3_ARQUIVO == "SC5"
	If (SX3->X3_BROWSE == "S" .Or. AllTrim(SX3->X3_CAMPO)$"C5_FILIAL,C5_CLIENTE,C5_LOJACLI") .And.;
		SX3->X3_CONTEXT <> "V"	
		aadd(aStruSC5,{ SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL })
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo
*/        
         
xLoop := 0         

aCampos := FWSX3Util():GetAllFields( "SC5", .F. )
For xLoop := 1 To Len(aCampos)
	If (Posicione("SX3",2,aCampos[xLoop],"X3_BROWSE") == "S" .Or. AllTrim(aCampos[xLoop])$"A1_COD,A1_LOJA,A1_NOME") .And.;
		Posicione("SX3",2,aCampos[xLoop],"X3_CONTEXT") <> "V"
						 //SX3->X3_CAMPO, 							SX3->X3_TIPO, 			SX3->X3_TAMANHO, 			SX3->X3_DECIMAL
		Aadd(aStruSC5, {aCampos[xLoop],FWSX3Util():GetFieldType(aCampos[xLoop]),TamSx3(aCampos[xLoop])[1],TamSx3(aCampos[xLoop])[2]} ) 		
		
	EndIf
Next xLoop


aadd(aStruSC5,{"C5_FLAG","L",1,0})

If lCria
	If Select("TRB") >= 1
		TRB->(DbCloseArea())
	EndIf
	cAliasTRB := "TRB"
	//cNomeTrb  := CriaTrab(aStruSA1,.T.)
	//dbUseArea(.T.,__LocalDrive,cNomeTrb,cAliasTrb,.F.,.F.)
	oTRB := FWTemporaryTable():New( cAliasTrb )
	oTRB:SetFields(aStruSA1)

	//------------------
	//Criação da tabela temporaria
	//------------------
	oTRB:Create()

	cNomeTrb := CriaTrab(Nil,.F.)
	IndRegua(cAliasTrb,cNomeTrb,"A1_COD+A1_LOJA")

	If Select("PED") >= 1
		PED->(DbCloseArea())
	EndIf
	cAliasPed := "PED"
	//cNomePed  := CriaTrab(aStruSC5,.T.)
	//dbUseArea(.T.,__LocalDrive,cNomePed,cAliasPed,.F.,.F.)	
	oPED := FWTemporaryTable():New( cAliasPed )
	oPED:SetFields(aStruSC5)

	//------------------
	//Criação da tabela temporaria
	//------------------
	oPED:Create()
	cNomePed := CriaTrab(Nil,.F.)
	IndRegua(cAliasPed,cNomePed,"C5_CLIENTE+C5_LOJACLI+C5_NUM")
	
Else
	dbSelectArea(cAliasTRB)
	Pack

	dbSelectArea(cAliasPed)
	Zap
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenche o arquivo temporario                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	cAliasSC5 := "Ma450PCli"
	cAliasSC9 := "Ma450PCli"
	cAliasSA1 := "Ma450PCli"

	lQuery    := .T.

	cQuery    := "SELECT SC9.C9_CLIENTE,SC9.C9_LOJA"
	For nX := 1 To Len(aStruSA1)
		cQuery += ",SA1."+aStruSA1[nX][1]+" "
	Next nX
	For nX := 1 To Len(AStruSC5)
		If AStruSC5[nX][1]<>"C5_FLAG" .And. AStruSC5[nX][1]<>"C5_VALOR"
			cQuery += ",SC5."+AStruSC5[nX][1]+" "
		EndIf
	Next nX
	cQuery += ",SC5.C5_MOEDA,SC9.C9_PEDIDO,SC9.C9_PRCVEN,SC9.C9_QTDLIB,SA1.A1_MOEDALC "
	cQuery += "FROM "+RetSqlName("SC9")+" SC9, "
	cQuery += RetSqlName("SA1")+" SA1, "
	cQuery += RetSqlName("SC5")+" SC5  "
	cQuery += "WHERE "
	If !lEmpresa
		cQuery    += "SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND "		
	EndIf
	cQuery += "SC9.C9_BLCRED<>'"+Repl(" ",Len(SC9->C9_BLCRED))+"' AND "
	cQuery += "SC9.C9_BLCRED<>'10' AND "
	cQuery += "SC9.C9_BLCRED<>'ZZ' AND "
	cQuery += "SC9.C9_BLCRED<>'09' AND "
	cQuery += "SC9.D_E_L_E_T_=' ' AND "
	cQuery += "SA1.A1_FILIAL='"+xFilial("SA1")+"' AND "
	cQuery += "SA1.A1_COD = SC9.C9_CLIENTE AND "
	cQuery += "SA1.A1_LOJA = SC9.C9_LOJA AND "
	cQuery += "SA1.D_E_L_E_T_=' ' AND "
	If !lEmpresa
		cQuery += "SC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
	Else
		cQuery += "SC5.C5_FILIAL=SC9.C9_FILIAL AND "
	EndIf
	cQuery += "SC5.C5_NUM=SC9.C9_PEDIDO AND "
	cQuery += "SC5.D_E_L_E_T_=' ' "
	
	If ExistBlock("M450ABRW")
		cQuery := ExecBlock('M450ABRW',.F.,.F.,{ cQuery })
	EndIf
	
	cQuery += " AND C5_CLIENTE = '"+SA1->A1_COD+"' AND C5_LOJACLI = '"+SA1->A1_LOJA+"'"
	
	cQuery += "ORDER BY SC9.C9_CLIENTE,SC9.C9_LOJA,SC9.C9_PEDIDO,SC9.C9_ITEM "
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9,.T.,.T.)

	For nX := 1 To Len(aStruSA1)
		If aStruSA1[nX][2]<>"C"
			TcSetField(cAliasSC9,aStruSA1[nX][1],aStruSA1[nX][2],aStruSA1[nX][3],aStruSA1[nX][4])
		EndIf
	Next nX                           
	
	For nX := 1 To Len(aStruSC5)
		If aStruSC5[nX][2]<>"C"
			TcSetField(cAliasSC9,aStruSC5[nX][1],aStruSC5[nX][2],aStruSC5[nX][3],aStruSC5[nX][4])
		EndIf
	Next nX
	
#ELSE
	cAliasSC9 := "MATA450A"
	ChkFile("SC9",.F.,cAliasSC9)
	If !lEmpresa
		cQuery := "C9_FILIAL=='"+xFilial("SC9")+"' .AND. "
	EndIf
	cQuery += "C9_BLCRED<>'  ' .AND. "
	cQuery += "C9_BLCRED<>'10' .AND. "	
	cQuery += "C9_BLCRED<>'ZZ' .AND. "
	cQuery += "C9_BLCRED<>'09'"

	dbSelectArea(cAliasSC9)
	IndRegua(cAliasSC9,cNomeSC9,"C9_FILIAL+C9_CLIENTE+C9_LOJA",,cQuery)
#ENDIF
dbSelectArea(cAliasSC9)
ProcRegua((cAliasSC9)->(LastRec()))
nValC78	:= Val(SuperGetMv("MV_MCUSTO"))
While !Eof()	
	If !lQuery
		dbSelectArea("SA1")
		dbSetOrder(1)
		MsSeek(xFilial("SA1")+(cAliasSC9)->C9_CLIENTE+(cAliasSC9)->C9_LOJA)

		dbSelectArea("SC5")
		dbSetOrder(1)
		MsSeek(OsFilial("SC5",(cAliasSC9)->C9_FILIAL)+(cAliasSC9)->C9_PEDIDO)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o cliente ja foi incluido                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAliasTRB)
	dbSetOrder(1)
	If !MsSeek((cAliasSC9)->C9_CLIENTE+(cAliasSC9)->C9_LOJA)
		RecLock(cAliasTRB,.T.)
		For nX := 1 To FCount()
			If (cAliasSA1)->(FieldPos((cAliasTRB)->(FieldName(nX))))<>0
				FieldPut(nX,(cAliasSA1)->(FieldGet(FieldPos((cAliasTRB)->(FieldName(nX))))))
			EndIf
		Next nX
		MsUnLock()
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o pedido ja foi incluido                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAliasPed)
	If !MsSeek((cAliasSC9)->C9_CLIENTE+(cAliasSC9)->C9_LOJA+(cAliasSC9)->C9_PEDIDO)
		RecLock(cAliasPed,.T.)
		For nX := 1 To FCount()
			If (cAliasSC5)->(FieldPos((cAliasPed)->(FieldName(nX))))<>0
				FieldPut(nX,(cAliasSC5)->(FieldGet(FieldPos((cAliasPed)->(FieldName(nX))))))
			EndIf
		Next nX
		(cAliasPed)->C5_FLAG := .F.
		MsUnLock()		
	EndIf	
	RecLock(cAliasPed,.F.)
	(cAliasPed)->C5_VALOR += xMoeda(A410Arred((cAliasSC9)->C9_PRCVEN*(cAliasSC9)->C9_QTDLIB,"C6_VALOR"),(cAliasSC5)->C5_MOEDA,IIf((cAliasSA1)->A1_MOEDALC>0,(cAliasSA1)->A1_MOEDALC,nValC78))
	MsUnlock()
	If lEnd
		Exit
	EndIf
	IncProc()
	dbSelectArea(cAliasSC9)
	dbSkip()
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a integridade da rotina                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAliasSC9)
dbCloseArea()
Ferase(cNomeSC9+OrdBagExt())
Ferase(cNomeTrb+GetDbExtension())
dbSelectArea("SC9")
RestArea(aArea)
Return(.T.)


Static Function NewLibEst(nRecSC5,nRecSC9,aDados,nDtIni,lBlqCred)

Local oDlgEst	:= nil
Local aSaldos	:= {}
Local nPosSld	:= 0
Local nMbrWidth	:= 0
Local nMbrHeight	:= 0
Local oMainCli	:= nil
Local oMainItens	:= nil
Local oGrpCli		:= nil
Local oListSld	:= nil
Local aHLSld		:= {}
Local aButSld		:= {}
Local nAuxBt		:= 0
Local oFont		:= Nil
Local oGCli		:= nil
Local oProcess	:= nil

If lBlqCred
	MsgStop("Pedido contem bloqueio de credito!"+chr(13)+chr(10)+"Primeiro deve ser realizado a liberação de credito!")
	Return nil
EndIf

SC5->(DbGoTo(nRecSC5))
	
If Select("TMP_SALDO") > 0
	TMP_SALDO->(DbCloseArea())
EndIf

BeginSql Alias "TMP_SALDO" 
	SELECT A1_NOME,SA1.A1_NREDUZ,A1_RISCO,B1_COD,B1_DESC,C9_LOCAL,(B2_QATU-(B2_RESERVA+B2_QEMP)) SALDO,C9_QTDLIB,SC9BLQ.R_E_C_N_O_ RECSC9,C9_ITEM
	FROM %Table:SC9% SC9BLQ
	JOIN %Table:SA1% SA1
	ON A1_FILIAL = %xFilial:SA1%
	AND A1_COD = SC9BLQ.C9_CLIENTE
	AND A1_LOJA = SC9BLQ.C9_LOJA
	AND SA1.%NotDel%
	JOIN %Table:SB1% SB1
	ON B1_FILIAL = %xFilial:SB1%
	AND B1_COD = C9_PRODUTO
	AND SB1.%NotDel%
	JOIN %Table:SB2% SB2
	ON B2_FILIAL = C9_FILIAL
	AND B2_COD = SC9BLQ.C9_PRODUTO
	AND B2_LOCAL = SC9BLQ.C9_LOCAL
	AND SC9BLQ.%NotDel%
	WHERE C9_FILIAL = %Exp:SC5->C5_FILIAL%
	AND C9_PEDIDO = %Exp:SC5->C5_NUM%	
	AND SC9BLQ.%NotDel%
	AND SC9BLQ.C9_BLEST IN ('02','03','05')	
	ORDER BY C9_ITEM
EndSql

TMP_SALDO->(DbGoTop())

While TMP_SALDO->(!EOF())	

	Aadd(aSaldos,Array(11))
	nPosSld	:= Len(aSaldos)
	
	aSaldos[nPosSld][01]	:= TMP_SALDO->A1_NOME
	aSaldos[nPosSld][02]	:= TMP_SALDO->A1_NREDUZ
	aSaldos[nPosSld][03]	:= TMP_SALDO->A1_RISCO
	aSaldos[nPosSld][04]	:= AllTrim(TMP_SALDO->B1_COD)
	aSaldos[nPosSld][05]	:= TMP_SALDO->B1_DESC
	aSaldos[nPosSld][06]	:= TMP_SALDO->C9_LOCAL
	aSaldos[nPosSld][07]	:= TMP_SALDO->SALDO
	aSaldos[nPosSld][08]	:= TMP_SALDO->C9_QTDLIB
	aSaldos[nPosSld][09]	:= TMP_SALDO->RECSC9
	aSaldos[nPosSld][10]	:= .T.
	aSaldos[nPosSld][11]	:= TMP_SALDO->C9_ITEM

	TMP_SALDO->(DbSkip())
EndDo
TMP_SALDO->(DbCloseArea())

If Len(aSaldos) > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a tela                                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Define Dialog oDlgEst 	Title "" From 10,10 TO 400,850 PIXEL
						
	//oDlgEst:lMaximized := .T.
	//oDlgEst:SetColor(CLR_BLACK,CLR_WHITE)
	//oDlgEst:SetFont(oFont)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Armazena as corrdenadas da tela                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nMbrWidth	:= oDlgEst:nWidth/2-43
	nMbrHeight	:= oDlgEst:nHeight/2
	
	@00,00 MSPANEL oMainCli PROMPT "" SIZE nMbrWidth,50/*nMbrHeight*0.10*/  of oDlgEst
	oMainCli:Align := CONTROL_ALIGN_TOP
	oGrpCli		:= TGroup():New(05,05,(oMainCli:NCLIENTHEIGHT/2),(oMainCli:NCLIENTWIDTH/2)-10,"",oMainCli,CLR_RED,,.T.)

	oGPed	:= TGet():New(015,010,{|u| if( Pcount()>0, SC5->C5_NUM := u,SC5->C5_NUM ) },oMainCli,020,010,"@!",{|| .F. },0,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"SC5->C5_NUM",,,,,,,"Pedido.: ",1,oFont,CLR_RED )
	oGCli	:= TGet():New(015,040,{|u| if( Pcount()>0, aSaldos[1][2] := u,aSaldos[1][2] ) },oMainCli,150,010,"@!",{|| .F. },0,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"aSaldos[1][2]",,,,,,,"Cliente.: ",1,oFont,CLR_RED )	
	oGRis	:= TGet():New(015,210,{|u| if( Pcount()>0, aSaldos[1][3] := u,aSaldos[1][3] ) },oMainCli,10,010,"@!",{|| .F. },0,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"aSaldos[1][3]",,,,,,,"Risco.: ",1,oFont,CLR_RED )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³titulos.                                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
	@00,00 MSPANEL oMainItens PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgEst
	oMainItens:Align := CONTROL_ALIGN_ALLCLIENT
	
	oGrpItens	:= TGroup():New(05,05,(oMainItens:NCLIENTHEIGHT/2)-40,(oMainItens:NCLIENTWIDTH/2)-05,"Itens Bloqueados",oMainItens,CLR_RED,,.T.)
	
	aHLSld	:= {} 
	
	oListSld := TWBrowse():New(15,10,(oMainItens:NCLIENTWIDTH/2)-25,(oMainItens:NCLIENTHEIGHT/2)-70,,aHLSld,,oMainItens,,,,,,,,,,,,, "ARRAY", .T. )
	
	oListSld:AddColumn(TCColumn():New("Liberar?"		,{|| IIF( aSaldos[oListSld:nAT][10]	, oVerde , oVerme )		},,,,'CENTER'	,25,.T.,.F.,,,,.F.,))

	nLenPixel	:= CalcFieldSize("C",05,0,"","Item")
	oListSld:AddColumn(TCColumn():New("Item"	,{|| aSaldos[oListSld:nAT][11]			},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))
		
	nLenPixel	:= CalcFieldSize("C",10,0,"","Cod.")
	oListSld:AddColumn(TCColumn():New("Cod."	,{|| aSaldos[oListSld:nAT][4]			},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))

	nLenPixel	:= CalcFieldSize("C",65,0,"","Titulo")
	oListSld:AddColumn(TCColumn():New("Titulo"	,{|| aSaldos[oListSld:nAT][5]		},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))
		
	nLenPixel	:= CalcFieldSize("N",050,0,"@E 999999.99","Quantidade")
	oListSld:AddColumn(TCColumn():New("Quantidade",{|| aSaldos[oListSld:nAT][8]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))
 
	nLenPixel	:= CalcFieldSize("N",050,0,"@E 999999.99","Saldo")
	oListSld:AddColumn(TCColumn():New("Saldo",{|| aSaldos[oListSld:nAT][7]		},,,,"RIGHT"	,nLenPixel,.F.,.F.,,,,.F.,))
	
	nLenPixel	:= CalcFieldSize("C",05,0,"","Local")
	oListSld:AddColumn(TCColumn():New("Local"	,{|| aSaldos[oListSld:nAT][6]		},,,,'LEFT'		,nLenPixel,.F.,.F.,,,,.F.,))
	
	oListSld:SetArray( aSaldos )
		
	//AADD(aButtons, {"cargaseq",	{|| Processa({|| GENMF03B(.T.) , U_GENMF004() , GENMF03B(.F.) , Processa({|| CargaBase(@aQuery,@aDados)	},"Consultando titulos...")	},"Processando...")  }, "Registros Conciliação"})
	oListSld:bLDblClick	:= {|x| aSaldos[oListSld:nAT][10] := !aSaldos[oListSld:nAT][10] }
	
	Activate MsDialog oDlgEst On Init EnchoiceBar(oDlgEst,{|| nAuxBt := 1,oDlgEst:End()  },{|| oDlgEst:End()  },,aButSld) Centered

Else
	MsgStop("Não foram localizadas obras com bloqueio de estoque para o pedido informado!")
EndIf


If nAuxBt == 1
	Processa({|| LibAllEst(aSaldos,@oProcess) }, "Liberar estoque", "Liberando estoque, aguarde...", .F. )	
EndIf

Processa({|| CargaBase(@aDados,nDtIni)	},"Consultando Pedidos...")

oListBox:SetArray( aDados )

Return nil


Static Function ConsCli(nRecSC5,nRecSC9,aDados,nDtIni,oDlgPed)

IF ConPad1(,,,"SA1")
	AnaCliCred(,,@aDados,nDtIni,oDlgPed,.T.)

	Processa({|| CargaBase(@aDados,nDtIni)	},"Consultando Pedidos...")

	oListBox:SetArray( aDados )
EndIf

Return nil

Static Function LibAllEst(aSaldos,oProcess)

Local nAuxLb		:= 0
Local cChaveSeek	:= ""
	
	ProcRegua( Len(aSaldos) )
	
	For nAuxLb := 1 To Len(aSaldos)
	 
		IncProc ( "Liberando "+StrZero(nAuxLb,3)+" de "+StrZero(Len(aSaldos),3) )
		
		If aSaldos[nAuxLb][10]
			
			SC9->(DBGoTo(aSaldos[nAuxLb][09]))
			
			cChaveSeek := SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO
						
			SC6->(DbSetOrder(1))//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			SC6->(DbSeek(cChaveSeek))

			SC5->(DbSetOrder(1))//C5_FILIAL+C5_NUM
			SC5->(DbSeek(SC6->C6_FILIAL+SC6->C6_NUM))
			
			a450Grava(1,.F.,.T.,.F.)
					
				
		EndIf
	Next

Return nil 