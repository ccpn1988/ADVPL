#include "rwmake.ch"
#include "protheus.ch"

#DEFINE POS_FIELD	1
#DEFINE POS_SIZE   2
#DEFINE POS_INI    3
#DEFINE POS_FIM    4

#DEFINE N_FNOME	01
#DEFINE N_FNUM	02
#DEFINE N_FOPERA	03
#DEFINE N_AREA	04

#DEFINE N_CD_CHAVE_ACESSO		01
#DEFINE N_CD_BRIDGE				02
#DEFINE N_NOME_BRIDGE			03
#DEFINE N_DT_IMPORTACAO			04
#DEFINE N_CHAVE_ACESSO			05
#DEFINE N_EMAIL_PROFESSOR		06
#DEFINE N_CPF_PROFESSOR			07
#DEFINE N_NOME_PROFESSOR			08
#DEFINE N_DT_EXPIRACAO			09
#DEFINE N_DT_ASSOCIACAO			10
#DEFINE N_NOME_REPRESENTANTE	11
#DEFINE N_EMAIL_REPRESENTANTE	12
#DEFINE N_DT_ENVIO				13

#DEFINE N_NSIZE					13

#DEFINE cEnt	Chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA074   บAutor  ณCleuto Lima         บ Data ณ  23/06/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณManuten็ใo acesso vital source                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA074()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local aDados	:= {}
Local aQuery	:= {}

Local aPosObj    	:= {} 
Local aObjects   	:= {}                        
Local aSize      	:= MsAdvSize() 
Local aInfo		:= {}

Local bConfirm	:= {|| oDlgFin:End() }
Local bCancel		:= {|| oDlgFin:End() }
Local aButtons	:= {}

Local oDlgFin		:= Nil
Local nWidth 		:= 50
Local oFont		:= Nil
Local oBmp			:= Nil
Local oTFont 		:= TFont():New('Courier new',,-18,.T.)
Local nLenPixel	:= 0
Local cCadastro	:= "Consulta Vital Source"
Local aBRIDGE		:= FilArea()

//Adicionada variavel abaixo para receber o parametro com os usuarios que terao acesso a incluir e trocar chave. [Bruno Parreira, Actual Trend, 08/08/2018]
Local cUserLib	:= AllTrim(SuperGetMV("GEN_FAT218",.F.,"000000/000191/000218/")) 
Local cUsrInut	:= AllTrim(SuperGetMV("GEN_FAT219",.F.,"000000/000191/000218/"))

Local nMbrWidth	:= 0
Local nMbrHeight	:= 0

Private oListBox	:= nil
Private aFiltros	:= Array(4)

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
oMainTop:Align	:= CONTROL_ALIGN_TOP
oGrpFilt			:= TGroup():New(05,05,(oMainTop:NCLIENTHEIGHT/2),(oMainTop:NCLIENTWIDTH/2)-10,"Filtros",oMainTop,CLR_RED,,.T.)

aFiltros[N_FOPERA]		:= Array(4)

aFiltros[N_FOPERA][4]	:= Space(150)
oGFlCli					:= TGet():New(15,10,{|u| if( Pcount()>0, aFiltros[N_FOPERA][4] := u,aFiltros[N_FOPERA][4] ) },oMainTop,200,010,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"aFiltros[N_FOPERA][4]",,,,,,,"Pesquisar.: ",1,oFont,CLR_RED )

aFiltros[N_FOPERA][1]	:= {"0=Todos","1=Nome Professor","2=CPF Professor","3=Email Professor","4=Nome Representante","5=Email Representante","6=Chave Acesso","7=Dt.Importa็ใo","8=Dt.Expira็ใo","9=Dt.Associa็ใo","10=Dt.Envio"}
aFiltros[N_FOPERA][2]	:= NIL 
aFiltros[N_FOPERA][3]	:= ""
aFiltros[N_FOPERA][2] 	:= TComboBox():New(22, 215,{|u|if(PCount()>0,aFiltros[N_FOPERA][3]:=u,aFiltros[N_FOPERA][3])},aFiltros[N_FOPERA][1],100,17,oMainTop,,{|| },,,,.T.,,,,,,,,,'aFiltros[N_FOPERA][3]')

//oButFilt 	:= TButton():New( 23, 320, "Buscar"		, oMainTop,{|| Processa({|| FiltDados(@aDados)	},"Buscando dados...") },50,010,,,,.T.)
oButFilt	:= TButton():Create( oMainTop,23, 320,"Buscar",{|| Processa({|| FiltDados(@aDados)	},"Buscando dados...") },036,012,,,,.T.,,,,,,)

aFiltros[N_AREA]		:= Array(4)
aFiltros[N_AREA][1]	:= aBRIDGE
aFiltros[N_AREA][2]	:= ""
aFiltros[N_AREA][3] 	:= TComboBox():New(22, 400,{|u|if(PCount()>0,aFiltros[N_AREA][2]:=u,aFiltros[N_AREA][2])},aFiltros[N_AREA][1],100,17,oMainTop,,{|| },,,,.T.,,,,,,,,,'aFiltros[N_AREA][2]','มrea.:  ',2,oTFont,CLR_RED)
aFiltros[N_AREA][3]:bChange	:= {|x| Processa({|| FiltDados(@aDados)}) }
                  
@00,00 MSPANEL oMainBt PROMPT "" SIZE nMbrWidth,30/*nMbrHeight*0.10*/  of oDlgFin
oMainBt:Align	:= CONTROL_ALIGN_TOP
oGrpBt			:= TGroup():New(05,05,(oMainBt:NCLIENTHEIGHT/2),(oMainBt:NCLIENTWIDTH/2)-10,"Fun็๕es",oMainBt,CLR_RED,,.T.)

//Adcionada condicao abaixo para que somente os usuarios do parametro visualizem o botao "Trocar Chave" e "Incluir Prof". [Bruno Parreira, Actual Trend, 08/08/2018]
//P.S.: O botใo "Incluir Prof." jแ estava comentado no fonte que estava no servidor. Entใo mantive ele comentado na minha alteracao. 
If __cUserID $ cUserLib
	oTButTroca	:= TButton():Create( oMainBt,13,015,"Trocar Chave",{|| IIF( oListBox:nAT > 0 .AND. LEn(aDados) > 0 , (NewChave(aDados[oListBox:nAT][N_CHAVE_ACESSO],aDados[oListBox:nAT][N_NOME_PROFESSOR],aDados[oListBox:nAT][N_EMAIL_PROFESSOR],aDados[oListBox:nAT][N_CPF_PROFESSOR]), Processa({|| FiltDados(@aDados)	},"Buscando dados...")) , MsgStop("Nenhum Professor selecionado!") ) },036,012,,,,.T.,,,,,,)
	//oTButNew	:= TButton():Create( oMainBt,13,070,"Incluir Prof.",{|| NewProf(aBRIDGE), Processa({|| FiltDados(@aDados)	},"Buscando dados...") },036,012,,,,.T.,,,,,,)
	oTButCan	:= TButton():Create( oMainBt,13,070,"Inutilizar Chave",{|| IIF( oListBox:nAT > 0 .AND. LEn(aDados) > 0 , (InutChave(aDados[oListBox:nAT][N_CHAVE_ACESSO],aDados[oListBox:nAT][N_NOME_PROFESSOR],aDados[oListBox:nAT][N_EMAIL_PROFESSOR],aDados[oListBox:nAT][N_CPF_PROFESSOR]), Processa({|| FiltDados(@aDados)	},"Buscando dados...")) , MsgStop("Nenhum Professor selecionado!") ) },050,012,,,,.T.,,,,,,)
EndIf

If __cUserID $ cUsrInut
	oTButCan	:= TButton():Create( oMainBt,13,070,"Inutilizar Chave",{|| IIF( oListBox:nAT > 0 .AND. LEn(aDados) > 0 , (InutChave(aDados[oListBox:nAT][N_CHAVE_ACESSO],aDados[oListBox:nAT][N_NOME_PROFESSOR],aDados[oListBox:nAT][N_EMAIL_PROFESSOR],aDados[oListBox:nAT][N_CPF_PROFESSOR]), Processa({|| FiltDados(@aDados)	},"Buscando dados...")) , MsgStop("Nenhum Professor selecionado!") ) },050,012,,,,.T.,,,,,,)
EndIf


oTButClose	:= TButton():Create( oMainBt,13,320,"Fechar",{|| oDlgFin:End() },036,012,,,,.T.,,,,,,)
                  
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณtitulos.                                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgFin
oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT

oGrpXML:= TGroup():New(05,05,(oMainCentro:NCLIENTHEIGHT/2)-40,(oMainCentro:NCLIENTWIDTH/2)-10,cCadastro,oMainCentro,CLR_RED,,.T.)
aHList	:= {}

oListBox := TWBrowse():New(15,10,(oMainCentro:NCLIENTWIDTH/2)-30,(oMainCentro:NCLIENTHEIGHT/2)-60,,aHList,,oMainCentro,,,,,,,,,,,,, "ARRAY", .T. )
//nLenPixel := CalcFieldSize("C",30,SX3->X3_DECIMAL,alltrim(SX3->X3_PICTURE),SX3->(X3Titulo()))

nLenPixel := CalcFieldSize("C",50,0,"@!","Nome Professor") 
oListBox:AddColumn(TCColumn():New("Nome Professor"		,{|| aDados[oListBox:nAT][N_NOME_PROFESSOR]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel := CalcFieldSize("C",50,0,"@!","Email Professor") 
oListBox:AddColumn(TCColumn():New("Email Professor"		,{|| aDados[oListBox:nAT][N_EMAIL_PROFESSOR]		},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel := CalcFieldSize("C",20,0,"@R 999.999.999-99","CPF Professor") 
oListBox:AddColumn(TCColumn():New("CPF Professor"		,{|| aDados[oListBox:nAT][N_CPF_PROFESSOR]		},"@R 999.999.999-99",,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel := CalcFieldSize("C",20,0,"@!","Chave Acesso")
oListBox:AddColumn(TCColumn():New("Chave Acesso"			,{|| aDados[oListBox:nAT][N_CHAVE_ACESSO]			},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel := CalcFieldSize("C",30,0,"@!","มrea")
oListBox:AddColumn(TCColumn():New("มrea"					,{|| aDados[oListBox:nAT][N_NOME_BRIDGE]			},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel := CalcFieldSize("C",30,0,"@!","Nome Representante") 
oListBox:AddColumn(TCColumn():New("Nome Representante"	,{|| aDados[oListBox:nAT][N_NOME_REPRESENTANTE]	},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel := CalcFieldSize("C",35,0,"@!","Email Representante") 
oListBox:AddColumn(TCColumn():New("Email Representante"	,{|| aDados[oListBox:nAT][N_EMAIL_REPRESENTANTE]	},,,,"LEFT"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel := CalcFieldSize("C",15,0,"@!","Dt.Importa็ใo") 
oListBox:AddColumn(TCColumn():New("Dt.Importa็ใo"		,{|| aDados[oListBox:nAT][N_DT_IMPORTACAO]		},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel := CalcFieldSize("C",15,0,"@!","Dt.Expira็ใo") 
oListBox:AddColumn(TCColumn():New("Dt.Expira็ใo"			,{|| aDados[oListBox:nAT][N_DT_EXPIRACAO]			},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel := CalcFieldSize("C",15,0,"@!","Dt.Associa็ใo") 
oListBox:AddColumn(TCColumn():New("Dt.Associa็ใo"		,{|| aDados[oListBox:nAT][N_DT_ASSOCIACAO]		},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

nLenPixel := CalcFieldSize("C",15,0,"@!","Dt.Importa็ใo") 
oListBox:AddColumn(TCColumn():New("Dt.Envio"				,{|| aDados[oListBox:nAT][N_DT_ENVIO]				},,,,"CENTER"	,nLenPixel,.F.,.F.,,,,.F.,))

oListBox:SetArray( aDados )

//oListBox:bLDblClick	:= {|x| IIF( oListBox:nAT > 0 .AND. LEn(aDados) > 0 , (NewChave(aDados[oListBox:nAT][N_CHAVE_ACESSO],aDados[oListBox:nAT][N_NOME_PROFESSOR],aDados[oListBox:nAT][N_EMAIL_PROFESSOR],aDados[oListBox:nAT][N_CPF_PROFESSOR])) , nil )  }


Activate MsDialog oDlgFin //On Init EnchoiceBar(oDlgFin,bConfirm,bCancel,,aButtons) Centered


Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA074  บAutor  ณMicrosiga           บ Data ณ  11/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function InutChave(cCodAcess,cProfess,cEmailProf,cCpfProf)

If Select("TMP_CHAVE") > 0 
	TMP_CHAVE->(DbcloseArea())
EndIf

BeginSql Alias "TMP_CHAVE"
	SELECT CPF_PROFESSOR
	     , EMAIL_PROFESSOR
	     , NOME_PROFESSOR
	     , CHAVE_ACESSO
	FROM SCH_VS.VS_CHAVE_ACESSO	     
	WHERE CPF_PROFESSOR = %Exp:cCpfProf%
	AND CHAVE_ACESSO = %Exp:cCodAcess%
EndSql

TMP_CHAVE->(DbGotop())

If TMP_CHAVE->(EOF()) .OR. Empty(TMP_CHAVE->CHAVE_ACESSO)
	MsgStop("Professor nใo localizado!")
ElseIf MsgYesNo("Confirma a inutiliza็ใo da chave de acesso "+TMP_CHAVE->CHAVE_ACESSO+" para o professor "+Capital(AllTrim(TMP_CHAVE->NOME_PROFESSOR))+" e-mail "+Capital(AllTrim(TMP_CHAVE->EMAIL_PROFESSOR))+"?" )
	Begin Transaction		
		cUpd := "UPDATE SCH_VS.VS_CHAVE_ACESSO SET EMAIL_PROFESSOR = 'inutilizado', CPF_PROFESSOR = '99999999999', NOME_PROFESSOR = 'inutilizado' WHERE CHAVE_ACESSO = '"+cCodAcess+"' AND CPF_PROFESSOR  = '"+AllTrim(cCpfProf)+"'"
		If (TCSqlExec(cUpd) < 0)
			MsgStop("Falha ao limpar chave atual - TCSQLError()" + TCSQLError())
			Disarmtransaction()
		Else
			MsgAlert("Acesso inutilizado com sucesso!")
		EndIf
	End Transaction
EndIf

TMP_CHAVE->(DbcloseArea())

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA074  บAutor  ณMicrosiga           บ Data ณ  11/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FiltDados(aDados)

Local cTmpAlias	:= GetNextAlias()
Local cFilQry		:= ""
Local cFilArea	:= aFiltros[N_AREA][2]
Local cFilAux		:= ""

ProcRegua(0)
IncProc()

aDados	:= {}    

If !Empty(aFiltros[N_FOPERA][3])
	Do Case //{"0=Todos","1=Nome Professor","2=CPF Professor","3=Email Professor","4=Nome Representante","5=Email Representante","6=Chave Acesso","7=Dt.Importa็ใo","8=Dt.Expira็ใo","9=Dt.Associa็ใo","10=Dt.Envio"}

		Case aFiltros[N_FOPERA][3] == "1"
			cFilAux	:= " AND UPPER(ACESSO.NOME_PROFESSOR) LIKE '%"+UPPER(AllTrim(aFiltros[N_FOPERA][4]))+"%' "
		Case aFiltros[N_FOPERA][3] == "2"
			cFilAux	:= " AND ACESSO.CPF_PROFESSOR = '"+AllTrim(aFiltros[N_FOPERA][4])+"' "
		Case aFiltros[N_FOPERA][3] == "3"
			cFilAux	:= " AND UPPER(ACESSO.EMAIL_PROFESSOR) LIKE '%"+UPPER(AllTrim(aFiltros[N_FOPERA][4]))+"%' "
		Case aFiltros[N_FOPERA][3] == "4"
			cFilAux	:= " AND UPPER(ACESSO.NOME_REPRESENTANTE) LIKE '%"+UPPER(AllTrim(aFiltros[N_FOPERA][4]))+"%' "
		Case aFiltros[N_FOPERA][3] == "5"
			cFilAux	:= " AND UPPER(ACESSO.EMAIL_REPRESENTANTE) LIKE '%"+UPPER(AllTrim(aFiltros[N_FOPERA][4]))+"%' "
		Case aFiltros[N_FOPERA][3] == "6"
			cFilAux	:= " AND ACESSO.CHAVE_ACESSO = '"+AllTrim(aFiltros[N_FOPERA][4])+"' "  
		Case aFiltros[N_FOPERA][3] == "7"
			cFilAux	:= " AND TO_CHAR(ACESSO.DT_IMPORTACAO,'YYYYMMDD') = '"+DtoS(CtoD(aFiltros[N_FOPERA][4]))+"'"
		Case aFiltros[N_FOPERA][3] == "8"
			cFilAux	:= " AND TO_CHAR(ACESSO.DT_EXPIRACAO,'YYYYMMDD') = '"+DtoS(CtoD(aFiltros[N_FOPERA][4]))+"'"
		Case aFiltros[N_FOPERA][3] == "9"
			cFilAux	:= " AND TO_CHAR(ACESSO.DT_ASSOCIACAO,'YYYYMMDD') = '"+DtoS(CtoD(aFiltros[N_FOPERA][4]))+"'"
		Case aFiltros[N_FOPERA][3] == "10"
			cFilAux	:= " AND TO_CHAR(ACESSO.DT_ENVIO,'YYYYMMDD') = '"+DtoS(CtoD(aFiltros[N_FOPERA][4]))+"'"
		OtherWise
			cFilAux	:= ""										
	EndCase

EndIf

If cFilArea <> "0"
	cFilQry := " AND ACESSO.CD_BRIDGE = "+cFilArea		
EndIf
If !Empty(cFilAux)		
	cFilQry+=cFilAux 		
EndIf

cFilQry	:= "%"+cFilQry+"%"
	    
BeginSql Alias cTmpAlias
	SELECT  
	ACESSO.CD_CHAVE_ACESSO CDACESS, 
	BRIDGE.CD_BRIDGE CD_BRIDGE,
	NOME_BRIDGE BRIDGE, 
	ACESSO.DT_IMPORTACAO DTIMP, 
	ACESSO.CHAVE_ACESSO CHAVE, 
	ACESSO.EMAIL_PROFESSOR EMAILPROF, 
	ACESSO.CPF_PROFESSOR CPFPROF, 
	ACESSO.NOME_PROFESSOR NOMEPROF, 
	ACESSO.DT_EXPIRACAO DTEXP, 
	ACESSO.DT_ASSOCIACAO DTACESS, 
	ACESSO.NOME_REPRESENTANTE NOMEREP, 
	ACESSO.EMAIL_REPRESENTANTE EMAILREP, 
	ACESSO.DT_ENVIO DTENV
	FROM SCH_VS.VS_CHAVE_ACESSO ACESSO
	JOIN SCH_VS.VS_BRIDGE BRIDGE
	ON BRIDGE.CD_BRIDGE = ACESSO.CD_BRIDGE
	WHERE CPF_PROFESSOR <> ' ' AND CPF_PROFESSOR IS NOT NULL
	%Exp:cFilQry%
	ORDER BY NOMEPROF
EndSql
(cTmpAlias)->(DbGoTop())

While (cTmpAlias)->(!EOF())
	
	Aadd(aDados, Array(N_NSIZE) )
	
	nLenAux	:= Len(aDados)
	aDados[nLenAux][N_CD_CHAVE_ACESSO]		:= AllTrim((cTmpAlias)->CDACESS)
	aDados[nLenAux][N_CD_BRIDGE]			:= AllTrim((cTmpAlias)->CD_BRIDGE) 
	aDados[nLenAux][N_NOME_BRIDGE]			:= AllTrim((cTmpAlias)->BRIDGE)
	aDados[nLenAux][N_DT_IMPORTACAO]		:= (cTmpAlias)->DTIMP 
	aDados[nLenAux][N_CHAVE_ACESSO]			:= (cTmpAlias)->CHAVE 
	aDados[nLenAux][N_EMAIL_PROFESSOR]		:= AllTrim((cTmpAlias)->EMAILPROF) 
	aDados[nLenAux][N_CPF_PROFESSOR]		:= AllTrim((cTmpAlias)->CPFPROF)
	aDados[nLenAux][N_NOME_PROFESSOR]		:= AllTrim((cTmpAlias)->NOMEPROF) 
	aDados[nLenAux][N_DT_EXPIRACAO]			:= (cTmpAlias)->DTEXP 
	aDados[nLenAux][N_DT_ASSOCIACAO]		:= (cTmpAlias)->DTACESS 
	aDados[nLenAux][N_NOME_REPRESENTANTE]	:= AllTrim((cTmpAlias)->NOMEREP) 
	aDados[nLenAux][N_EMAIL_REPRESENTANTE]	:= AllTrim((cTmpAlias)->EMAILREP) 
	aDados[nLenAux][N_DT_ENVIO]				:= (cTmpAlias)->DTENV 
	
	(cTmpAlias)->(DbSkip())
EndDo

(cTmpAlias)->(DbCloseArea())

oListBox:nAT	:= 1
oListBox:SetArray( aDados )
        
oListBox:DrawSelect()
oListBox:Refresh()
oListBox:GoTop()
/*
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
*/
Return nil

Static Function FilArea()

Local aBRIDGE	:= {"0=Todos"}

If Select("TMP_BRIDGE") > 0 
	TMP_BRIDGE->(DbcloseArea())
EndIf

BeginSql Alias "TMP_BRIDGE"
	SELECT  
	CD_BRIDGE, NOME_BRIDGE
	FROM SCH_VS.VS_BRIDGE BRIDGE
	GROUP BY CD_BRIDGE, NOME_BRIDGE
	ORDER BY CD_BRIDGE
EndSql

TMP_BRIDGE->(DbGotop())

While TMP_BRIDGE->(!EOF())
	
	Aadd(aBRIDGE, cValToChar(TMP_BRIDGE->CD_BRIDGE)+"="+StrTran(AllTrim(TMP_BRIDGE->NOME_BRIDGE),"BIBLIOFERTA","") )
	
	TMP_BRIDGE->(DbSkip())
EndDo

TMP_BRIDGE->(DbcloseArea())

Return aBRIDGE

Static Function NewChave(cCodAcess,cProfess,cEmailProf,cCpfProf)

If Select("TMP_CHAVE") > 0 
	TMP_CHAVE->(DbcloseArea())
EndIf

BeginSql Alias "TMP_CHAVE"
	SELECT MIN(CHAVE_ACESSO) CHAVE_ACESSO FROM SCH_VS.VS_CHAVE_ACESSO ACESSO
	WHERE CPF_PROFESSOR IS NULL
EndSql

TMP_CHAVE->(DbGotop())

If TMP_CHAVE->(EOF()) .OR. Empty(TMP_CHAVE->CHAVE_ACESSO)
	MsgStop("No momento nใo foram encontradas chaves de acesso disponํveis!")
Else
	IF MsgYesNo("Confirma a atribui็ใo da chave de acesso "+TMP_CHAVE->CHAVE_ACESSO+" para o professor "+cProfess)
		Begin Transaction
			// limpo a chave de acesso atual
			cUpd := "UPDATE SCH_VS.VS_CHAVE_ACESSO SET EMAIL_PROFESSOR = NULL, CPF_PROFESSOR = NULL, NOME_PROFESSOR = NULL, DT_ASSOCIACAO = NULL WHERE CHAVE_ACESSO = '"+cCodAcess+"'"
			If (TCSqlExec(cUpd) < 0)
				MsgStop("Falha ao limpar chave atual - TCSQLError()" + TCSQLError())
				Disarmtransaction()
			Else
				// atribuo a nova chave
				cUpd := "UPDATE SCH_VS.VS_CHAVE_ACESSO SET EMAIL_PROFESSOR = '"+cEmailProf+"', CPF_PROFESSOR = '"+cCpfProf+"', NOME_PROFESSOR = '"+cProfess+"', DT_ASSOCIACAO = SYSDATE WHERE CHAVE_ACESSO = "+TMP_CHAVE->CHAVE_ACESSO
				If (TCSqlExec(cUpd) < 0)
					MsgStop("Falha ao atribuir chave de acesso - TCSQLError()" + TCSQLError())
					Disarmtransaction()
				Else
					MsgAlert("Chave de acesso "+TMP_CHAVE->CHAVE_ACESSO+" atribuida com sucesso!")
				EndIf
			EndIf						
		End Transaction
	EndIF	
EndIf

TMP_CHAVE->(DbcloseArea())

Return nil


Static Function NewProf(aBRIDGE)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local lOk			:= .F.
Local bConfirm	:= {|| IIF( VldDados(cNome,cEmail,cCPF,cNomeRep,cEmailRep,dDtExp) , (lOk := .T., oDlgProf:End())  , nil  ) }
Local bCancel		:= {|| oDlgProf:End() }
Local aCombo		:= aClone(aBRIDGE)

Local oDlgProf	:= Nil
Local oFont		:= Nil
Local oTFont 		:= TFont():New('Courier new',,-18,.T.)
Local cNome		:= ""
Local cEmail		:= ""
Local cArea		:= ""
Local cCPF			:= ""
Local oGtNome		:= Nil
Local oBjProf		:= Nil
Local oGtMail		:= Nil
Local aButtons	:= Nil
Local oGtCPF		:= Nil
	
aDel(aCombo,1)
aSize(aCombo,Len(aCombo)-1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta a tela                                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Define Dialog oDlgProf 	Title "Dados Professor" From 00,00 TO 380,865 STYLE 128 PIXEL

@00,00 MSPANEL oMainProf PROMPT "" SIZE 00,1000 of oDlgProf
oMainProf:Align := CONTROL_ALIGN_ALLCLIENT

oGrpProf	:= TGroup():New(05,05,(oMainProf:NCLIENTHEIGHT/2)-80,(oMainProf:NCLIENTWIDTH/2)-10,"Dados Professor",oMainProf,CLR_RED,,.T.)

cNome		:= Space(150)
oGtNome	:= TGet():New(15,10,{|u| if( Pcount()>0, cNome := u,cNome ) },oMainProf,200,010,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cNome",,,,,,,"Nome Professor.: ",1,oFont,CLR_RED )

cEmail		:= Space(150)
oGtMail	:= TGet():New(15,220,{|u| if( Pcount()>0, cEmail := u,cEmail ) },oMainProf,200,010,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cEmail",,,,,,,"E-Mail Professor.: ",1,oFont,CLR_RED )

cCPF		:= Space(11)
oGtCPF		:= TGet():New(35,10,{|u| if( Pcount()>0, cCPF := u,cCPF ) },oMainProf,90,010,"@R 999.999.999-99",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cCPF",,,,,,,"CPF.: ",1,oFont,CLR_RED )

oBjProf	:= TComboBox():New(35, 110,{|u|if(PCount()>0,cArea:=u,cArea)},aCombo,100,12.5,oMainProf,,{|| },,,,.T.,,,,,,,,,'cArea',"มrea.:",1,oFont,CLR_RED)

cNomeRep	:= Space(150)
oGtNRep	:= TGet():New(60,10,{|u| if( Pcount()>0, cNomeRep := u,cNomeRep ) },oMainProf,200,010,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cNomeRep",,,,,,,"Nome Representante.: ",1,oFont,CLR_RED )

cEmailRep	:= Space(150)
oGtMRep	:= TGet():New(60,220,{|u| if( Pcount()>0, cEmailRep := u,cEmailRep ) },oMainProf,200,010,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cEmailRep",,,,,,,"E-Mail Representante.: ",1,oFont,CLR_RED )
			
//dDtImp	:= DDataBase
//oGtImp	:= TGet():New(85,10,{|u| if( Pcount()>0, dDtImp := u,dDtImp ) },oMainProf,50,010,"",,0,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"dDtImp",,,,,,,"Dt.Importa็ใo.: ",1,oFont,CLR_RED )

dDtExp	:= CtoD("  /  /  ")
oGtExp	:= TGet():New(85,10,{|u| if( Pcount()>0, dDtExp := u,dDtExp ) },oMainProf,50,010,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"dDtExp",,,,,,,"Dt.Expira็ใo.: ",1,oFont,CLR_RED )

dAsso	:= DDataBase
oGtAss	:= TGet():New(85,70,{|u| if( Pcount()>0, dAsso := u,dAsso ) },oMainProf,50,010,"",,0,,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F.,,"dAsso",,,,,,,"Dt.Associa็ใo.: ",1,oFont,CLR_RED )


Activate MsDialog oDlgProf On Init EnchoiceBar(oDlgProf,bConfirm,bCancel,,aButtons) Centered

Return nil 

Static Function VldDados(cNome,cEmail,cCPF,cNomeRep,cEmailRep,dDtExp)

Local lRet		:= .T.
Local cChave	:= ""

Do Case
	Case Empty(cNome) .OR. Empty(cEmail) .OR. Empty(cCPF) .OR. Empty(cNomeRep) .OR. Empty(cEmailRep) .OR. Empty(dDtExp)
		lRet	:= .F. 
		MsgStop("Todos os campos devem ser preenchidos!")
	Case !IsEmail(AllTrim(cEmail))
		lRet	:= .F. 
		MsgStop("E-Mail Professor invalido!")		 	
	Case !IsEmail(AllTrim(cEmailRep))
		lRet	:= .F. 
		MsgStop("E-Mail Representante invalido!")		
	Case !CGC(StrTran(StrTran(cCPF,".",""),"-",""))
		lRet	:= .F. 
		MsgStop("CPF professor invalido!")			
	OtherWise
		
		lTenta	:= .T.
		
		While lTenta
			If Select("TMP_CHAVE") > 0 
				TMP_CHAVE->(DbcloseArea())
			EndIf		
			BeginSql Alias "TMP_CHAVE"
				SELECT MIN(CHAVE_ACESSO) CHAVE_ACESSO FROM SCH_VS.VS_CHAVE_ACESSO ACESSO
				WHERE CPF_PROFESSOR IS NULL
			EndSql		
			TMP_CHAVE->(DbGotop())		
			If TMP_CHAVE->(EOF()) .OR. Empty(TMP_CHAVE->CHAVE_ACESSO)				
				If !MsgYesNo("No momento nใo foram encontradas chaves de acesso disponํveis!"+Chr(13)+Chr(10)+"Deseja tentar novamente?")
					lRet	:= .F.
					lTenta	:= .F.	
				EndIf
			Else
				lTenta	:= .F.
				cChave	:= TMP_CHAVE->CHAVE_ACESSO		
			EndIf
			TMP_CHAVE->(DbCloseArea())
		EndDo
		
		If lRet
			Begin Transaction
				// atribuo a nova chave
				cUpd := "UPDATE SCH_VS.VS_CHAVE_ACESSO SET EMAIL_PROFESSOR = '"+AllTrim(cEmail)+"', CPF_PROFESSOR = '"+StrTran(StrTran(cCPF,".",""),"-","")+"', NOME_PROFESSOR = '"+AllTrim(cNome)+"', DT_ASSOCIACAO = SYSDATE, DT_EXPIRACAO = TO_DATE('"+DtoC(dDtExp)+" 00:00:00','DD/MM/YYYY hh24:mi:ss'),NOME_REPRESENTANTE = '"+AllTrim(cNomeRep)+"', EMAIL_REPRESENTANTE = '"+AllTrim(cEmailRep)+"' WHERE CHAVE_ACESSO = "+cChave+""
				If (TCSqlExec(cUpd) < 0)
					MsgStop("Falha ao atribuir chave de acesso - TCSQLError()" + TCSQLError())
					Disarmtransaction()
				Else
					MsgAlert("Cadastro realizado com sucesso!")	
				EndIf
			End Transaction			
		EndIf
		
EndCase

Return lRet