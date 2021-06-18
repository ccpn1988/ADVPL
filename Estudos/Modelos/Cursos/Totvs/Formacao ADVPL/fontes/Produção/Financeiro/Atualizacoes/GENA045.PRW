#include "PROTHEUS.ch"
#Include "TopConn.Ch"

#DEFINE C_DETENTOR		  01
#DEFINE C_CPF_CNPJ       02
#DEFINE C_NOME_COMPLETO  03
#DEFINE C_NOME_BUSCA     04
#DEFINE C_INSCRICAO      05
#DEFINE C_EMAIL          06
#DEFINE C_BENEFICIARIO   07
#DEFINE C_CD_BANCO       08
#DEFINE C_NAC_BANCO      09
#DEFINE C_AGENCIA        10
#DEFINE C_AGENCIA_DV     11
#DEFINE C_CTA_CORRENTE   12
#DEFINE C_CORRENTE_DV    13
#DEFINE C_A1_COD         14
#DEFINE C_A1_LOJA        15
#DEFINE C_A1_NOME        16
#DEFINE C_A1_NREDUZ      17
#DEFINE C_A1_XTIPCLI     18
#DEFINE C_X5_DESCRI      19
#DEFINE C_A1_XAUTOR      20
#DEFINE N_SIZE		      20

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA045   บAutor  ณMicrosiga           บ Data ณ  05/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ verifica se o CNPJ informado existe no cadastro de autores.บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen.                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA045(cCgc)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveia da rotina.                                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local aRet		:= {}
Local cSqlTmp	:= ""
Local aDescri	:= {"Sim","Nใo","Sem Defini็ใo"}
Local nPos		:= 0
Local cCodRet	:= "3"

If !Empty(cCgc)

	cSqlTmp	:= GetNextAlias()
	cCgc	:= AllTrim(cCgc)
	
	If Select(cSqlTmp) > 0
		(cSqlTmp)->(DbCloseArea())	
	EndIF
	
	BeginSql Alias cSqlTmp
	    SELECT COUNT(*) QTD
	    From GUA_DA.DAU_V04_DETENTORES V04
	    Where TRIM(V04.V04_NR_CPF_CNPJ)  = %Exp:Alltrim(cCgc)%
	EndSql
	
	(cSqlTmp)->(DbGoTop())
	
	If (cSqlTmp)->QTD >= 1
		cCodRet	:= "1"
	Else
		cCodRet	:= "2"
	EndIf
	
	(cSqlTmp)->(DbCloseArea())
	
EndIf

aRet := {cCodRet,aDescri[Val(cCodRet)]}

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA045   บAutor  ณMicrosiga           บ Data ณ  05/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function GENA045B()

Local aArea			:= GetArea()
Local aAreaSX1		:= SX1->(GetArea())

Local cPerg			:= "GENA045B"
Local cSql	 		:= ""

Local aPosObj    	:= {} 
Local aObjects   	:= {}                        
Local aSize      	:= MsAdvSize() 
Local aInfo			:= {}

Local bConfirm		:= {|| oDlgFat:End() }
Local bCancel		:= {|| oDlgFat:End() }
Local aButtons		:= {}

Local oDlgFat		:= Nil
Local nWidth 		:= 50
Local oFont			:= Nil
Local oBmp			:= Nil
Local oTFont 		:= TFont():New('Courier new',,-18,.T.)  

Local aDaObj		:= {}

Local cCadastro		:= "Cadastro de Autores"

Private oVerme		:= LoadBitMap(GetResources(),"BR_VERMELHO")
Private oVerde		:= LoadBitMap(GetResources(),"BR_VERDE")

PutSx1(cPerg,"01","CPF/CNPJ"			,"","","mv_ch1" ,"C",14,0,0,"G","","","","","mv_par01" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"02","NOME"				,"","","mv_ch2" ,"C",50,0,0,"G","","","","","mv_par02" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"03","NOME BUSCA"			,"","","mv_ch3" ,"C",50,0,0,"G","","","","","mv_par03" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"04","EMAIL"				,"","","mv_ch4" ,"C",99,0,0,"G","","","","","mv_par04" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"05","BENEFICIมRIO"		,"","","mv_ch5" ,"C",99,0,0,"G","","","","","mv_par05" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"06","COD.BANCO"			,"","","mv_ch6" ,"C",03,0,0,"G","","","","","mv_par06" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"07","AGENCIA SEM DIG."	,"","","mv_ch7" ,"C",15,0,0,"G","","","","","mv_par07" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"08","CONTA SEM DIG"		,"","","mv_ch8" ,"C",15,0,0,"G","","","","","mv_par08" , ""    ,""     ,""       ,"",""              ,""              ,""              ,"","","")
PutSx1(cPerg,"09","APENAS PROTHEUS"		,"","","mv_ch9", "N",01,0,2,"C","","","","","mv_par09","Nใo","No","No", "","Sim","Yes","Si", "", "", "", "", "", "", "", "", "", "", "", "", "")

If !Pergunte(cPerg,.T.)
	Return nil
EndIf

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
Define Dialog oDlgFat 	Title cCadastro ;
					From aSize[7],00 TO aSize[6],aSize[5] ;
					 /*STYLE nOR(WS_VISIBLE,WS_POPUP)*/ PIXEL
					
oDlgFat:lMaximized := .T.
oDlgFat:SetColor(CLR_BLACK,CLR_WHITE)
oDlgFat:SetFont(oFont)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณArmazena as corrdenadas da tela                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nMbrWidth	:= oDlgFat:nWidth/2-43
nMbrHeight	:= oDlgFat:nHeight/2

@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgFat
oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT

oGrpXML		:= TGroup():New(05,05,(oMainCentro:NCLIENTHEIGHT/2)-40,(oMainCentro:NCLIENTWIDTH/2)-10,"Cadastro de Autores",oMainCentro,CLR_RED,,.T.)
aHList	:= {}

oListBox := TWBrowse():New(15,10,(oMainCentro:NCLIENTWIDTH/2)-30,(oMainCentro:NCLIENTHEIGHT/2)-60,,aHList,,oMainCentro,,,,,,,,,,,,, "ARRAY", .T. )

oListBox:AddColumn(TCColumn():New(" "			   		,{|| IIF( !Empty(aDaObj[oListBox:nAT][C_A1_COD]), oVerde , oVerme )	},,,,'CENTER'	,15,.T.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("ID.Detentor"			,{|| aDaObj[oListBox:nAT][C_DETENTOR] 		   	},,,,'LEFT'		,035,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("CPF/CNPJ"			,{|| aDaObj[oListBox:nAT][C_CPF_CNPJ] 		   	},,,,'LEFT'		,060,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Nome Completo"	  	,{|| aDaObj[oListBox:nAT][C_NOME_COMPLETO] 		},,,,'LEFT'		,120,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Nome Busca"			,{|| aDaObj[oListBox:nAT][C_NOME_BUSCA] 		},,,,'LEFT'		,120,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Insc.Estadual"	  	,{|| aDaObj[oListBox:nAT][C_INSCRICAO] 		   	},,,,'LEFT'		,050,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Email"		  		,{|| aDaObj[oListBox:nAT][C_EMAIL] 		   		},,,,'LEFT'		,120,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Beneficiแrio"	  	,{|| aDaObj[oListBox:nAT][C_BENEFICIARIO] 		},,,,'LEFT'		,120,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Cod.Banco"			,{|| aDaObj[oListBox:nAT][C_CD_BANCO] 		   	},,,,'LEFT'		,035,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Banco"		  		,{|| aDaObj[oListBox:nAT][C_NAC_BANCO] 		   	},,,,'LEFT'		,080,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Agencia"		  		,{|| aDaObj[oListBox:nAT][C_AGENCIA] 		   	},,,,'LEFT'		,025,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Ag.Dig."			  	,{|| aDaObj[oListBox:nAT][C_AGENCIA_DV] 		},,,,'LEFT'		,025,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Conta"		  	 	,{|| aDaObj[oListBox:nAT][C_CTA_CORRENTE] 		},,,,'LEFT'		,030,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Cc.Dig."			  	,{|| aDaObj[oListBox:nAT][C_CORRENTE_DV] 		},,,,'LEFT'		,025,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Cod.Protheus"		,{|| aDaObj[oListBox:nAT][C_A1_COD] 		   	},,,,'LEFT'		,040,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Loja"				,{|| aDaObj[oListBox:nAT][C_A1_LOJA] 		   	},,,,'LEFT'		,025,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Nome Protheus"		,{|| aDaObj[oListBox:nAT][C_A1_NOME] 		   	},,,,'LEFT'		,080,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Nome Red.Protheus"	,{|| aDaObj[oListBox:nAT][C_A1_NREDUZ] 		   	},,,,'LEFT'		,080,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Tipo Clie."		  	,{|| aDaObj[oListBox:nAT][C_A1_XTIPCLI] 		},,,,'LEFT'		,030,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Desc.Tipo Clie."		,{|| aDaObj[oListBox:nAT][C_X5_DESCRI] 		   	},,,,'LEFT'		,050,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Clie. Autor?"		,{|| aDaObj[oListBox:nAT][C_A1_XAUTOR] 		   	},,,,'LEFT'		,040,.F.,.F.,,,,.F.,))

Carga(@aDaObj)

AADD(aButtons, {"cargaseq",	{|| IIF( Pergunte(cPerg,.T.) , LJMsgRun("Processando...","Aguarde...",{|| Carga(@aDaObj) }) , nil )	}, "Parametros"})

Activate MsDialog oDlgFat On Init EnchoiceBar(oDlgFat,bConfirm,bCancel,,aButtons) Centered

RestArea(aAreaSX1)
RestArea(aArea)

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA045   บAutor  ณMicrosiga           บ Data ณ  05/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Carga(aDaObj)

Local cQuebra	:= Chr(13)+Chr(10)
Local cAliasTmp	:= GetNextAlias()
Local cSql		:= ""

aDaObj	:= {}

cSql	+= " SELECT DETENTOR.V04_ID_DETENTOR DETENTOR "+cQuebra
cSql	+= "         ,DETENTOR.V04_NR_CPF_CNPJ CPF_CNPJ "+cQuebra
cSql	+= "         ,upper(translate(DETENTOR.V04_TX_NOME_COMPLETO,'โเใแมยภร้๊ษสํอ๓๔๕ำิีü๚Üฺว็','AAAAAAAAEEEEIIOOOOOOUUUUCC')) NOME_COMPL "+cQuebra
cSql	+= "         ,upper(translate(DETENTOR.V04_TX_NOME_BUSCA,'โเใแมยภร้๊ษสํอ๓๔๕ำิีü๚Üฺว็','AAAAAAAAEEEEIIOOOOOOUUUUCC')) NOME_BUSCA"+cQuebra
cSql	+= "         ,DETENTOR.V04_NR_INSCRICAO_ESTADUAL INSCRICAO "+cQuebra
cSql	+= "         ,EMAIL.V08_TX_EMAIL EMAIL "+cQuebra
cSql	+= "         ,V04_TX_BANCO_NOME_BENEFICIARIO BENEFICIAR "+cQuebra
cSql	+= "         ,V04_CD_NAC_BANCO CD_BANCO "+cQuebra
cSql	+= "         ,V04_TX_NAC_BANCO TX_BANCO "+cQuebra
cSql	+= "         ,DETENTOR.V04_CD_NAC_AGENCIA AGENCIA "+cQuebra
cSql	+= "         ,DETENTOR.V04_CD_NAC_AGENCIA_DV AGENCIA_DV "+cQuebra
cSql	+= "         ,DETENTOR.V04_NR_NAC_CTA_CORRENTE CORRENTE "+cQuebra
cSql	+= "         ,DETENTOR.V04_NR_NAC_CTA_CORRENTE_DV CORRENT_DV "+cQuebra
cSql	+= "         ,A1_COD "+cQuebra
cSql	+= "         ,A1_LOJA "+cQuebra
cSql	+= "         ,A1_NOME "+cQuebra
cSql	+= "         ,A1_NREDUZ "+cQuebra 
cSql	+= "		 ,A1_XTIPCLI "+cQuebra
cSql	+= "		 ,( SELECT X5_DESCRI FROM SX5000 SX5 WHERE X5_FILIAL = ' ' AND X5_TABELA = 'TP' AND X5_CHAVE = A1_XTIPCLI AND SX5.D_E_L_E_T_ <> '*') DESCX5 "+cQuebra
cSql	+= "		 ,DECODE(A1_XAUTOR,'1','Sim','2','Nใo') A1_XAUTOR "+cQuebra
cSql	+= " FROM GUA_DA.DAU_V04_DETENTORES DETENTOR "+cQuebra 

If MV_PAR09 == 2
	cSql	+= " JOIN "+RetSqlName("SA1")+" SA1 "+cQuebra
Else
	cSql	+= " LEFT JOIN "+RetSqlName("SA1")+" SA1 "+cQuebra
EndIf

cSql	+= " ON A1_FILIAL = '"+xFilial("SA1")+"' "+cQuebra
cSql	+= " AND TRIM(A1_CGC) = TRIM(DETENTOR.V04_NR_CPF_CNPJ) AND A1_CGC <> '              ' "+cQuebra
cSql	+= " AND SA1.D_E_L_E_T_ <> '*' "+cQuebra
cSql	+= " LEFT JOIN GUA_DA.DAU_V08_DETENTOR_EMAILS EMAIL "+cQuebra
cSql	+= " ON EMAIL.V04_ID_DETENTOR = DETENTOR.V04_ID_DETENTOR  "+cQuebra

cSql	+= " WHERE V04_TX_NOME_COMPLETO IS NOT NULL "+cQuebra 

If !Empty(MV_PAR01)
	cSql	+= " AND regexp_replace(DETENTOR.V04_NR_CPF_CNPJ,'[[:punct:]]','') = regexp_replace('"+ALLTRIM(MV_PAR01)+"','[[:punct:]]','')
EndIF

If !Empty(MV_PAR02)	
	cSql	+= " AND upper(translate(DETENTOR.V04_TX_NOME_COMPLETO,'โเใแมยภร้๊ษสํอ๓๔๕ำิีü๚Üฺว็','AAAAAAAAEEEEIIOOOOOOUUUUCC')) LIKE '%'||upper(translate('"+ALLTRIM(MV_PAR02)+"','โเใแมยภร้๊ษสํอ๓๔๕ำิีü๚Üฺว็','AAAAAAAAEEEEIIOOOOOOUUUUCC'))||'%' "+cQuebra
EndIF

If !Empty(MV_PAR03)
	cSql	+= " AND upper(translate(DETENTOR.V04_TX_NOME_BUSCA,'โเใแมยภร้๊ษสํอ๓๔๕ำิีü๚Üฺว็','AAAAAAAAEEEEIIOOOOOOUUUUCC')) LIKE '%'||upper(translate('"+ALLTRIM(MV_PAR03)+"','โเใแมยภร้๊ษสํอ๓๔๕ำิีü๚Üฺว็','AAAAAAAAEEEEIIOOOOOOUUUUCC'))||'%' "+cQuebra
EndIF

If !Empty(MV_PAR04)
	cSql	+= " AND UPPER(V08_TX_EMAIL) LIKE '%"+AllTrim(MV_PAR04)+"%' "+cQuebra
EndIF

If !Empty(MV_PAR05)
	cSql	+= " AND upper(translate(V04_TX_BANCO_NOME_BENEFICIARIO,'โเใแมยภร้๊ษสํอ๓๔๕ำิีü๚Üฺว็','AAAAAAAAEEEEIIOOOOOOUUUUCC')) LIKE '%'||upper(translate('"+ALLTRIM(MV_PAR05)+"','โเใแมยภร้๊ษสํอ๓๔๕ำิีü๚Üฺว็','AAAAAAAAEEEEIIOOOOOOUUUUCC'))||'%' "+cQuebra
EndIF

If !Empty(MV_PAR06)
	cSql	+= " AND V04_CD_NAC_BANCO = '"+AllTrim(MV_PAR06)+"' "+cQuebra
EndIF

If !Empty(MV_PAR07)
	cSql	+= " AND V04_CD_NAC_AGENCIA = '"+AllTrim(MV_PAR07)+"' "+cQuebra
EndIF

If !Empty(MV_PAR08)
	cSql	+= " AND V04_NR_NAC_CTA_CORRENTE = '"+AllTrim(MV_PAR08)+"' "+cQuebra
EndIF

cSql	+= " ORDER BY DETENTOR.V04_TX_NOME_COMPLETO "+cQuebra

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cSql), cAliasTmp, .F., .T.)

(cAliasTmp)->(DbGoTop())

While (cAliasTmp)->(!EOF())
	
	Aadd(aDaObj, Array(N_SIZE))
	nPos := Len(aDaObj)
	
	aDaObj[nPos][C_DETENTOR]		:= (cAliasTmp)->DETENTOR
	aDaObj[nPos][C_CPF_CNPJ] 		:= (cAliasTmp)->CPF_CNPJ
	aDaObj[nPos][C_NOME_COMPLETO]	:= (cAliasTmp)->NOME_COMPL
	aDaObj[nPos][C_NOME_BUSCA]		:= (cAliasTmp)->NOME_BUSCA
	aDaObj[nPos][C_INSCRICAO]		:= (cAliasTmp)->INSCRICAO
	aDaObj[nPos][C_EMAIL]			:= (cAliasTmp)->EMAIL
	aDaObj[nPos][C_BENEFICIARIO]	:= (cAliasTmp)->BENEFICIAR
	aDaObj[nPos][C_CD_BANCO]		:= (cAliasTmp)->CD_BANCO
	aDaObj[nPos][C_NAC_BANCO]		:= (cAliasTmp)->TX_BANCO
	aDaObj[nPos][C_AGENCIA]			:= (cAliasTmp)->AGENCIA
	aDaObj[nPos][C_AGENCIA_DV] 		:= (cAliasTmp)->AGENCIA_DV
	aDaObj[nPos][C_CTA_CORRENTE]	:= (cAliasTmp)->CORRENTE
	aDaObj[nPos][C_CORRENTE_DV]		:= (cAliasTmp)->CORRENT_DV
	aDaObj[nPos][C_A1_COD]	   		:= (cAliasTmp)->A1_COD
	aDaObj[nPos][C_A1_LOJA]	   		:= (cAliasTmp)->A1_LOJA
	aDaObj[nPos][C_A1_NOME]	   		:= (cAliasTmp)->A1_NOME
	aDaObj[nPos][C_A1_NREDUZ]  		:= (cAliasTmp)->A1_NREDUZ
	aDaObj[nPos][C_A1_XTIPCLI] 		:= (cAliasTmp)->A1_XTIPCLI
	aDaObj[nPos][C_X5_DESCRI]  		:= (cAliasTmp)->DESCX5
	aDaObj[nPos][C_A1_XAUTOR]  		:= (cAliasTmp)->A1_XAUTOR
	
	(cAliasTmp)->(DbSkip())
EndDo

(cAliasTmp)->(DbCloseArea())

oListBox:SetArray( aDaObj )

Return nil 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA045   บAutor  ณMicrosiga           บ Data ณ  05/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA045C()

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local cAliTmp	:= ""
Local cAutor	:= "1"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o cliente existe na tabela de autores e em existindoณ
//ณmuda o campo autor para sim.                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If AllTrim(SA1->A1_XAUTOR) <> cAutor .AND. !Empty(SA1->A1_CGC) .AND. !(!ALTERA .AND. !INCLUI)
	
	cAliTmp := GetNextAlias()
	
	BeginSql Alias cAliTmp
		SELECT V04_TX_NOME_COMPLETO NOME_COM FROM GUA_DA.DAU_V04_DETENTORES 
		WHERE trim(regexp_replace(V04_NR_CPF_CNPJ,'[[:punct:]]','')) = trim(regexp_replace(%Exp:AllTrim(SA1->A1_CGC)%,'[[:punct:]]','')) 
	EndSql
 	
 	(cAliTmp)->(DbGoTop())
 	If (cAliTmp)->(!EOF())
 	
 		If upper(alltrim(GetEnvServer())) $ "PRODUCAO"
			MsgStop("Cliente localizado no cadastro de autores, o campo Autor serแ alterado para (Sim)")
		Endif 	
		
		RecLock("SA1",.F.)
		SA1->A1_XAUTOR	:= cAutor
		MsUnLock()
 	EndIf
 	
 	(cAliTmp)->(DbCloseArea())
 	
EndIf

RestArea(aAreaSA1)
RestArea(aArea)

Return nil
