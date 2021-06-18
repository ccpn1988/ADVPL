#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

User Function TMP005()
Local cVar :=  ""

Prepare Environment Empresa "00" Filial "1022"


IF !LockByName('TMP005',.T.,.T.,.T.)
	Conout('TMP005 - 1022 '+ dToC(dDataBase)+' '+ Time()+ ' Start Ignorado - Rotina em execução')
	Reset Environment
	return Nil
Else
	Conout('TMP005 - 1022 '+ dToC(dDataBase)+' '+ Time()+ ' Iniciando processamento da Rotina')
ENDIF
cVar := GETMV("MV_DATAFIN")

PUTMV("MV_DATAFIN", "20190731")

PUTMV("GEN_DTFIN", cVar)

dDataBase := cToD('30/08/2019')

DEFINE WINDOW oMainWnd FROM 0,0 TO 01,30 TITLE "Bx. Tít. Cartão de Crédito."

                nMeter := 0
                oMeter := TMeter():New(025,215,{|u|if(Pcount()>0,nMeter:=u,nMeter)},0,oMainWnd,180,16,,.T.)
                oMeter:Set(0)                                                              
                        
ACTIVATE WINDOW oMainWnd ;
ON INIT (;
Processa( {|| TMP005C() }, "Andamento...", "Ajustando arquivo de texto...", .F.),oMainWnd:End() )

PUTMV("MV_DATAFIN", cVar)

UnLockByName('TMP005',.T.,.T.,.T.)
Conout('TMP005 - 1022 '+ dToC(dDataBase)+' '+ Time()+ ' Finalizado processamento da rotina')
Reset Environment

Return .T.


User Function TMP005B()
Local cVar := ''

Prepare Environment Empresa "00" Filial "1001"

IF !LockByName('TMP005B',.T.,.T.,.T.)
	Conout('TMP005B - 1001 '+ dToC(dDataBase)+' '+ Time()+ ' Start Ignorado - Rotina já em execução')
	Reset Environment
	return Nil
Else
	Conout('TMP005B - 1001 '+ dToC(dDataBase)+' '+ Time()+ ' Iniciando processamento da Rotina')
ENDIF
cVar := GETMV("MV_DATAFIN")

PUTMV("MV_DATAFIN", "20190731")

PUTMV("GEN_DTFIN", cVar)

dDataBase := cToD('30/08/2019')

DEFINE WINDOW oMainWnd FROM 0,0 TO 01,30 TITLE "Bx. Tít. Cartão de Crédito."
               
               nMeter := 0
               oMeter := TMeter():New(025,215,{|u|if(Pcount()>0,nMeter:=u,nMeter)},0,oMainWnd,180,16,,.T.)
               oMeter:Set(0)                                           
                        
ACTIVATE WINDOW oMainWnd ;
ON INIT (;
Processa( {|| TMP005C() }, "Andamento...", "Ajustando arquivo de texto...", .F.),oMainWnd:End() )

PUTMV("MV_DATAFIN", cVar)

UnLockByName('TMP005B',.T.,.T.,.T.)
Conout('TMP005B - 1001 '+ dToC(dDataBase)+' '+ Time()+ ' Finalizado processamento da rotina')
Reset Environment

Return .T.

Static Function TMP005C() 

Local aBaixa		:= {}
Local aLog			:= {}
Local nAux			:= ""
Local cMOTBX		:= "DACAO	"
Local cBANCO		:= " "
Local cAGENCIA	:= " "
Local cCONTA		:= " "
Local cHIST		:= "Baixa de historico venda site cartão"
	Procregua (0) 
	Incproc()          
DbSelectArea("SE1")

If Select("TMP_BXSE1") > 0
	TMPBXSE1->(DbCloseArea())
EndIf
Conout('TMP005 - '+ dToC(dDataBase)+' '+ Time()+ ' Executando query')
BeginSql Alias "TMP_BXSE1"
SELECT E.R_E_C_N_O_ RECSE1
FROM TOTVS.SE1000 E
WHERE ROWNUM <= 250
AND E1_SALDO > 0
AND E1_FILIAL = %xFILIAL:SE1%
AND EXISTS (SELECT 1 FROM BKP.SE1AGO C
WHERE C.E1_FILIAL = E.E1_FILIAL
AND C.E1_CLIENTE = E.E1_CLIENTE
AND C.E1_LOJA = E.E1_LOJA 
AND C.E1_PREFIXO = E.E1_PREFIXO
AND C.E1_NUM = E.E1_NUM
AND C.E1_PARCELA = E.E1_PARCELA
AND C.E1_TIPO = E.E1_TIPO
AND C.E1_NATUREZ = E.E1_NATUREZ)
AND E.D_E_L_E_T_ = ' '
EndSql

TMP_BXSE1->(DbGoTop())
nqtd := 0
Conout('TMP005 - '+ dToC(dDataBase)+' '+ Time()+ ' Iniciando While na query')
While TMP_BXSE1->(!EOF())
nqtd++
Conout('TMP005 - '+ dToC(dDataBase)+' '+ Time()+ ' Iniciando Processamento registro '+cValToChar(nqtd)+' de 250')
	Incproc()
	SE1->(DbGoTo( TMP_BXSE1->RECSE1 ))
 		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia baixa do titulo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aBaixa := {}
	 
	aBaixa := {{"E1_PREFIXO"	,SE1->E1_PREFIXO		,Nil	},;
	           {"E1_NUM"		,SE1->E1_NUM			,Nil	},;
	           {"E1_PARCELA"	,SE1->E1_PARCELA		,Nil	},;
	           {"E1_CLIENTE"	,SE1->E1_CLIENTE		,Nil	},;
	           {"E1_LOJA"		,SE1->E1_LOJA			,Nil	},;		           
	           {"E1_TIPO"		,SE1->E1_TIPO			,Nil	},;		           		           
	           {"AUTMOTBX"		,cMOTBX					,Nil	},;
	           {"AUTBANCO"		,cBANCO					,Nil	},;
	           {"AUTAGENCIA"	,cAGENCIA				,Nil	},;
	           {"AUTCONTA"		,cCONTA					,Nil	},;
	           {"AUTDTBAIXA"	,CTOD("01/06/2019")		,Nil	},;
	           {"AUTDTCREDITO"	,CTOD("01/06/2019")		,Nil	},;
	           {"AUTHIST"		,cHIST					,Nil	},;
	           {"AUTJUROS"		,0						,Nil	,.T.	},; 
	           {"AUTDESCONT"	,0						,Nil	,.T.	},; 
	           {"AUTVALREC"		,SE1->E1_SALDO			,Nil	}}

	lMSHelpAuto := .t.
	lMsErroAuto := .f.
	
	Begin Transaction
		MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3) 		
		lMSHelpAuto := .F.
		
		If lMsErroAuto
			cErro := MostraErro(GetTempPath(), "GENMF03C.log" )
			Aadd(aLog, {"Erro",		SE1->E1_NUM,SE1->E1_PARCELA, SE1->E1_VENCREA,SE1->E1_NOMCLI,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_DOCTEF,SE1->E1_EMISSAO,SE1->E1_SALDO, cErro } )
		Else
			Aadd(aLog, {"Sucesso",	SE1->E1_NUM,SE1->E1_PARCELA, SE1->E1_VENCREA,SE1->E1_NOMCLI,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_DOCTEF,SE1->E1_EMISSAO,SE1->E1_SALDO,"Sucesso"  } )
		EndIf
	End Transaction
Conout('TMP005 - '+ dToC(dDataBase)+' '+ Time()+ ' Finalizado Processamento registro '+cValToChar(nqtd)+' de 250')	
	TMP_BXSE1->(DbSkip())	
EndDo

TMP_BXSE1->(DbCloseArea())
Conout('TMP005 - '+ dToC(dDataBase)+' '+ Time()+ 'Gerando relatório de log')
// abrindo classe excel
_oFWMsExcel := FWMSExcel():New()  

//Aba 01 - Impressão
_oFWMsExcel:AddworkSheet("Historico")     

/*
cWorkSheet	Caracteres	Nome da planilha	 	X	 
cTable	Caracteres	Nome da planilha	 	X	 
cColumn	Caracteres	Titulo da tabela que será adicionada	 	X	 
nAlign	Numérico	Alinhamento da coluna ( 1-Left,2-Center,3-Right )	 	X	 
nFormat	Numérico	Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )	 	X	 
lTotal	Lógico	Indica se a coluna deve ser totalizada
*/
//Criando a Tabela
_oFWMsExcel:AddTable("Historico","Baixas")

_oFWMsExcel:AddColumn("Historico","Baixas","Situação",1,1)
_oFWMsExcel:AddColumn("Historico","Baixas","Titulo",1,1)
_oFWMsExcel:AddColumn("Historico","Baixas","Parcela",1,1)
_oFWMsExcel:AddColumn("Historico","Baixas","Vencimento",1,1)
_oFWMsExcel:AddColumn("Historico","Baixas","Cliente",1,1)
_oFWMsExcel:AddColumn("Historico","Baixas","Cod.Cliente",1,1)
_oFWMsExcel:AddColumn("Historico","Baixas","Loja",1,1)
_oFWMsExcel:AddColumn("Historico","Baixas","NSU",1,1)
_oFWMsExcel:AddColumn("Historico","Baixas","Emissao",1,1)
_oFWMsExcel:AddColumn("Historico","Baixas","Saldo",1,1)
_oFWMsExcel:AddColumn("Historico","Baixas","Mensagem",1,1)


For nAux :=1 To Len(aLog)
	// Preenchendo as linhas
	_oFWMsExcel:AddRow("Historico","Baixas", Aclone(aLog[nAux]) )
Next

//Ativando o arquivo e gerando o xml
_oFWMsExcel:Activate()
_oFWMsExcel:GetXMLFile(GetTempPath()+"LogProc_"+DtoS(DDataBase)+StrTran(Time(),":","")+".xml")   

FreeObj(_oFWMsExcel)
Conout('TMP005 - '+ dToC(dDataBase)+' '+ Time()+ 'Finalizando relatório de log')
Return nil