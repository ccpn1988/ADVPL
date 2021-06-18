#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

User Function TMP005()

Prepare Environment Empresa "00" Filial "1022"

TMP005C()

Reset Environment

Return .T.


User Function TMP005B()

Prepare Environment Empresa "00" Filial "1001"

TMP005C()

Reset Environment

Return .T.

Static Function TMP005C() 

Local aBaixa		:= {}
Local aLog			:= {}
Local cMOTBX		:= "DACAO	"
Local cBANCO		:= " "
Local cAGENCIA	:= " "
Local cCONTA		:= " "
Local cHIST		:= "Baixa de historico venda site cartão"
Local nAux
	           
DbSelectArea("SE1")

If Select("TMP_BXSE1") > 0
	TMPBXSE1->(DbCloseArea())
EndIf

BeginSql Alias "TMP_BXSE1"
	SELECT R_E_C_N_O_ RECSE1 FROM SE1000 SE1
	WHERE E1_FILIAL = %xFilial:SE1%
	AND E1_NATUREZ = '30080'
	AND SE1.D_E_L_E_T_ <> '*'
	AND E1_TIPO = 'NF'
	AND E1_SALDO > 0
EndSql

TMP_BXSE1->(DbGoTop())

While TMP_BXSE1->(!EOF())
	
	SE1->(DbGoTo( TMP_BXSE1->RECSE1 ))
 		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia baixa do titulo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aBaixa := {}
	 
	aBaixa := {{"E1_PREFIXO"		,SE1->E1_PREFIXO	,Nil	},;
	           {"E1_NUM"			,SE1->E1_NUM		,Nil	},;
	           {"E1_PARCELA"		,SE1->E1_PARCELA	,Nil	},;
	           {"E1_CLIENTE"		,SE1->E1_CLIENTE	,Nil	},;
	           {"E1_LOJA"		,SE1->E1_LOJA		,Nil	},;		           
	           {"E1_TIPO"		,SE1->E1_TIPO		,Nil	},;		           		           
	           {"AUTMOTBX"		,cMOTBX			,Nil	},;
	           {"AUTBANCO"		,cBANCO			,Nil	},;
	           {"AUTAGENCIA"		,cAGENCIA			,Nil	},;
	           {"AUTCONTA"		,cCONTA			,Nil	},;
	           {"AUTDTBAIXA"		,SE1->E1_VENCREA	,Nil	},;
	           {"AUTDTCREDITO"	,SE1->E1_VENCREA	,Nil	},;
	           {"AUTHIST"		,cHIST				,Nil	},;
	           {"AUTJUROS"		,0					,Nil	,.T.	},; 
	           {"AUTDESCONT"		,0					,Nil	,.T.	},; 
	           {"AUTVALREC"		,SE1->E1_SALDO	,Nil	}}

	lMSHelpAuto := .t.
	lMsErroAuto := .f.
	
	Begin Transaction
		MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3) 		
		lMSHelpAuto := .F.
		
		If lMsErroAuto
			cErro := MostraErro(GetTempPath(), "GENMF03C.log" )
			Aadd(aLog, {"Erro",		SE1->E1_NUM,SE1->E1_PARCELA, SE1->E1_VENCREA,SE1->E1_NOMCLI,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_DOCTEF,SE1->E1_EMISSAO,SE1->E1_SALDO, cErro } )
		Else
			Aadd(aLog, {"Sucesso",	SE1->E1_NUM,SE1->E1_PARCELA, SE1->E1_VENCREA,SE1->E1_NOMCLI,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_DOCTEF,SE1->E1_EMISSAO,SE1->E1_SALDO, "Sucesso"  } )
		EndIf
	End Transaction
	
	TMP_BXSE1->(DbSkip())	
EndDo

TMP_BXSE1->(DbCloseArea())

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
	_oFWMsExcel:AddRow("Erros","Aparas", Aclone(aLog[nAux]) )
Next

//Ativando o arquivo e gerando o xml
_oFWMsExcel:Activate()
_oFWMsExcel:GetXMLFile(GetTempPath()+"LogProc_"+DtoS(DDataBase)+StrTran(Time(),":","")+".xml")   

FreeObj(_oFWMsExcel)

Return nil