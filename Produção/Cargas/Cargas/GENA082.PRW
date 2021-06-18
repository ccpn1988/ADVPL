#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

#DEFINE P_01	01
#DEFINE P_02	02
#DEFINE P_03	03
#DEFINE P_04	04
#DEFINE P_05	05
#DEFINE P_06	06
#DEFINE P_07	07
#DEFINE P_08	08


#define CMD_OPENWORKBOOK		1
#define CMD_CLOSEWORKBOOK		2
#define CMD_ACTIVEWORKSHEET		3
#define CMD_READCELL			4

/* quando laitura via XLSX
	#define CELL_VBID		"A"
	#define CELL_ISBN		"B"
	#define CELL_QTDPGW		"E"
	#define CELL_VALPGW		"H"
*/
	#define CELL_VBID		1
	#define CELL_ISBN		2
	#define CELL_QTDPGW		3
	#define CELL_VALPGW		6

#define LAY_LEN	6

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA082   ºAutor  ³Cleuto Lima         º Data ³  27/11/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa planilha Excel MB com dados de faturamento          º±±
±±º          ³PageView's                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA082()

Local aCfgParam	:= {}
Local cCadastro	:= "Faturamento Minha Biblioteca"
Local aParam	:= Array(8)
Local nOpcA		:= 0
Local lContinua	:= .T.
Local lCrisStr	:= .F.
Local nPercApu	:= GetMv("GEN_FAT222",.f.,0.75)
Local nQtdRegOk	:= 0
Local aButtons	:= {}

Private cIdx1		:= xRetIndex("A")//GetNextAlias()+"A"
Private cIdx2		:= xRetIndex("B")//GetNextAlias()+"B"
Private TMPEXCEL	:= nil
Private lSemaExt	:= .F.
Private lDadoExt	:= .F.

If cFilAnt <> "1022"
	MsgStop("Rotina deve ser executada estando logado na filial 1022")
	Return .F.
EndIf

aParam[P_01]	:= Space(150)
aParam[P_02]	:= CriaVar("D2_TOTAL",.F.)
aParam[P_03]	:= CriaVar("D2_TOTAL",.F.)
aParam[P_04]	:= Space(6)
aParam[P_05]	:= CriaVar("C5_EMISSAO",.F.)
aParam[P_06]	:= nPercApu
aParam[P_07]	:= CriaVar("C5_EMISSAO",.F.)
aParam[P_08]	:= CriaVar("D2_TOTAL",.F.)

IF !LockByName("GENA082",.T.,.T.,.T.)
	MsgStop("Rotina já está sendo executada!")
	Return .F.
EndIf

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 000,000 TO 350,600 PIXEL

Aadd(aCfgParam,{06,"Diretorio Planilha"		,Space(150),"",".T.",".T.",150,.T.,"*.XLS/*.XLSX",Space(150),GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE} )
Aadd(aCfgParam,{01,"Valor 10% Rat.Editoras"	,CriaVar("D2_TOTAL",.F.)	,PesqPict("SD2","D2_TOTAL"),".T.",""/*F3*/,"",80,.T.})
Aadd(aCfgParam,{01,"Valor PageViews"		,CriaVar("D2_TOTAL",.F.)	,PesqPict("SD2","D2_TOTAL"),".T.",""/*F3*/,"",80,.T.})
Aadd(aCfgParam,{01,"Peri. Apur. AAAAMM"		,Space(6)	,"999999",".T.",""/*F3*/,"",20,.T.})
Aadd(aCfgParam,{01,"Vencimento"				,CriaVar("C5_EMISSAO",.F.)	,PesqPict("SC5","C5_EMISSAO"),".T.",""/*F3*/,"",60,.T.})
Aadd(aCfgParam,{01,"% Apuração DA"			,nPercApu	,PesqPict("SC6","C6_DESCONT"),".T.",""/*F3*/,".F.",80,.T.})
Aadd(aCfgParam,{01,"Dt.Emissao Pedidos"		,CriaVar("C5_EMISSAO",.F.)	,PesqPict("SC5","C5_EMISSAO"),".T.",""/*F3*/,"",60,.T.})
Aadd(aCfgParam,{01,"Valor Mesa.Dividida"	,CriaVar("D2_TOTAL",.F.)	,PesqPict("SD2","D2_TOTAL"),".T.",""/*F3*/,"",80,.T.})
//Aadd(aCfgParam,{02,"Reprocessamento"			,1	,{" ","1=Sim","2=Não"},25,".T.",.T.,".T."})

///Parambox ( aParametros@cTitle@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] ) --> aRet
ParamBox(aCfgParam,cCadastro,@aParam,{|x| nOpcA := 1 },.T.,,,,oDlg,,.F.,.F.)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA := 1,oDlg:End()},{|| oDlg:End() }) CENTERED

If nOpcA == 1

	/* validações primarias dos parametros*/

	Do Case
		Case aParam[P_02] <= 0
			MsgStop("Parametro: 'Valor 10% Rat.Editoras', deve ser informado!")
			lContinua := .F.
		Case aParam[P_03] <= 0
			MsgStop("Parametro: 'Valor PageViews', deve ser informado!")
			lContinua := .F.
		Case Empty(aParam[P_04])
			MsgStop("Parametro: 'Peri. Apur. AAAAMM', deve ser informado!")
			lContinua := .F.
		Case Empty(aParam[P_05])
			MsgStop("Parametro: 'Vencimento', deve ser informado!")
			lContinua := .F.
		Case Empty(aParam[P_07])
			MsgStop("Parametro: 'Emissão', deve ser informado!")
			lContinua := .F.
	EndCase

	If lContinua
		Processa({|| lContinua := ValidStru(aParam,@lCrisStr) },"Validação Semaforo","Aguarde.. estamos verificando a situação atual do periodo informado!",.F.)
		If lContinua .AND. lCrisStr
			If .t.//CpDllXls()
				Processa({|| lContinua := LerExcel(aParam,@nQtdRegOk) },"Lendo Excel","Aguarde.. estamos lendo o arquivo Excel!",.F.)
				If lContinua
					If CriaStru(aParam)
						Processa({|| lContinua := CargaEstru(aParam,nQtdRegOk) },"Processando...","Aguarde.. armazenando dados para processamento!",.F.)
					EndIf
				EndIf
			EndIf
		EndIf

		If lContinua
			//If !lCrisStr //  se .F. quer dizer que não é a primeira execução com isso é necessario revalidar os registros.
			Processa({|| lContinua := VldSitAtu(aParam,nQtdRegOk,lCrisStr) },"Processando...","Aguarde.. consultando situação atual dos registros!",.F.)
			//EndIf
		EndIf

		If lContinua
			Processa({|| lContinua := GerPedi(aParam) },"Processando...","Aguarde.. gerando pedidos!",.F.)
		EndIf

		If lContinua
			Processa({|| lContinua := GerNFs(aParam) },"Processando...","Aguarde.. gerando notas fiscais!",.F.)
		EndIf

		If lContinua
			cErroLg 	:= "Você finalizou com sucesso o faturamento minha biblioteca!"
			cSolucao	:= "Finalizado!"+chr(13)+chr(10)+DtoC(DDataBase)+" - "+Time()
			xMagHelpFis("Faturamento Minha biblioteca",cErroLg,cSolucao)
		EndIf

	EndIf
EndIf

UnLockByName("GENA082",.T.,.T.,.T.)

IF Select("GENA82SEMA") > 0
	GENA82SEMA->(DbCloseArea())
EndIF

IF Select("GENA82DADO") > 0
	GENA82DADO->(DbCloseArea())
EndIF

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA082   ºAutor  ³Cleuto Lima         º Data ³  27/11/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa planilha Excel MB com dados de faturamento          º±±
±±º          ³PageView's                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GerNFs(aParam)

Local aRet			:= {.T.,"",""}
Local lRet			:= .T.
Local cErroLg		:= ""
Local cSolucao		:= ""
Local lNFDA			:= .F.
Local cFilPed		:= Getmv("GEN_FAT223",.f.,"1001")
Local cSerieSrv		:= Getmv("GEN_FAT224",.f.,"3")
Local cSerieDA		:= Getmv("GEN_FAT225",.f.,"1")
Local aPedDA		:= {}
Local nAuxPd		:= 0
Local cIdxTmp		:= ""
Local aNFe			:= {}

ProcRegua(4)

IncProc("Gerando nota fiscal raterio editoras + mensalidade...")

If lRet .AND. Empty(GENA82SEMA->PEDRAT)
	lRet 		:= .F.
	cErroLg 	:= "Falha ao Gerar notas fiscais, os pedidos não foram identificados"
	cSolucao	:= "Execute o processamento novamente, caso o erro continue, entre em contato com a TI!"
	xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
ElseIf lRet .AND. Empty(GENA82SEMA->NFSRAT)
	aRet := {.T.,"",""}
	aRet := PedToNF(GENA82SEMA->PEDRAT,cFilPed,cSerieSrv)
	lRet := !aRet[1]
	If lRet
		RecLock("GENA82SEMA",.F.)
		GENA82SEMA->NFSRAT	:= aRet[2]
		MsUnLock()
	EndIf
ElseIf lRet .AND. !Empty(GENA82SEMA->NFSRAT)
	SF2->(DbSetOrder(1))
	If !SF2->(DbSeek( cFilPed+GENA82SEMA->NFSRAT+PadR(cSerieSrv,3) ))
		lRet 		:= .F.
		cErroLg 	:= "Falha ao Gerar notas fiscais, a nota fiscal informada para o pedido "+GENA82SEMA->PEDRAT+" não foi localizada!"
		cSolucao	:= "Execute o processamento novamente, caso o erro continue, entre em contato com a TI!"
		xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
	EndIf
EndIF

IncProc("Gerando nota fiscal serviço pageview...")

If lRet .AND. Empty(GENA82SEMA->PEDPGW)
	lRet 		:= .F.
	cErroLg 	:= "Falha ao Gerar notas fiscais, os pedidos não foram identificados"
	cSolucao	:= "Execute o processamento novamente, caso o erro continue, entre em contato com a TI!"
	xMagHelpFis("Gerando pedido PageView",cErroLg,cSolucao)
ElseIf lRet .AND. Empty(GENA82SEMA->NFSPGW)
	aRet := {.T.,"",""}
	aRet := PedToNF(GENA82SEMA->PEDPGW,cFilPed,cSerieSrv)
	lRet := !aRet[1]
	If lRet
		RecLock("GENA82SEMA",.F.)
		GENA82SEMA->NFSPGW	:= aRet[2]
		MsUnLock()
	EndIf
ElseIf lRet .AND. !Empty(GENA82SEMA->NFSPGW)
	SF2->(DbSetOrder(1))
	If !SF2->(DbSeek( cFilPed+GENA82SEMA->NFSPGW+PadR(cSerieSrv,3) ))
		lRet 		:= .F.
		cErroLg 	:= "Falha ao Gerar notas fiscais, a nota fiscal informada para o pedido "+GENA82SEMA->PEDPGW+" não foi localizada!"
		cSolucao	:= "Execute o processamento novamente, caso o erro continue, entre em contato com a TI!"
		xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
	EndIf
EndIF

If lRet

	IncProc("Gerando nota fiscal gerencial apuração DA...")

	SF2->(DbSetOrder(1))
	GENA82DADO->(DbGoTop())
	While GENA82DADO->(!EOF())

		If !(GENA82DADO->STS_PED $ "2#3") .OR. EMPTY(GENA82DADO->PEDIDO)
			lRet := .F.
			cErroLg := "Falha ao Gerar notas fiscais, os pedidos não foram identificados"
			xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
			Exit
		Else
			If !Empty(GENA82DADO->NOTA)
				If GENA82DADO->NOTA+GENA82DADO->SERIE <> SF2->F2_DOC+SF2->F2_SERIE
					If !SF2->(DbSeek( xFilial("SF2")+GENA82DADO->NOTA+GENA82DADO->SERIE ))
						lRet 		:= .F.
						cErroLg 	:= "Falha ao Gerar notas fiscais, a nota fiscal informada "+GENA82DADO->NOTA+"/"+GENA82DADO->SERIE+" não foi localizada!"
						cSolucao	:= "Execute o processamento novamente, caso o erro continue, entre em contato com a TI!"
						xMagHelpFis("Gerando nota fiscal DA",cErroLg,cSolucao)
					ElseIf GENA82DADO->STS_PED <> "3"
						RecLock("GENA82DADO",.F.)
						GENA82DADO->STS_PED	:= "3"
						MsUnLock()
					EndIf
				EndIf
			Else
				If aScan(aPedDA,GENA82DADO->PEDIDO) == 0
					Aadd(aPedDA,GENA82DADO->PEDIDO)
				EndIf
			EndIf
		EndIf
		GENA82DADO->(DbSkip())
	EndDo

	If lRet .AND. !Empty(GENA82SEMA->PEDPGW) .AND. !Empty(GENA82SEMA->NFSPGW) .AND. !Empty(GENA82SEMA->PEDRAT) .AND. !Empty(GENA82SEMA->NFSRAT) .AND. Len(aPedDA) > 0
		For nAuxPd := 1 To Len(aPedDA)
			aRet := {.T.,"",""}
			aRet := PedToNF(aPedDA[nAuxPd],xFilial("SF2"),cSerieDA)
			lRet := !aRet[1]
			If lRet
				DbSelectArea("GENA82DADO")
				DbSetOrder(2)
				/*
				DbClearIndex()
				DBCreateIndex("GENA82IDX1", "PEDIDO+LINHA"         , {|| PEDIDO+LINHA         })
				DbSetIndex("GENA82IDX1")
				*/
				/*
				FErase("GENA82IDX1"+OrdBagExt())
				cIdxTmp  := CriaTrab(nil,.F.)
				IndRegua("GENA82DADO",cIdxTmp,"PEDIDO+LINHA","C")
				DbSetIndex(cIdxTmp+OrdBagExt())
				*/
				//DbSetOrder(1)

				GENA82DADO->(DbGotop())
				GENA82DADO->(DbSeek( aPedDA[nAuxPd] ))
				While GENA82DADO->(!EOF()) .AND. GENA82DADO->PEDIDO == aPedDA[nAuxPd]
					RecLock("GENA82DADO",.F.)
					GENA82DADO->NOTA		:= aRet[2]
					GENA82DADO->SERIE		:= cSerieDA
					GENA82DADO->STS_PED	:= "3"
					MsUnLock()
					GENA82DADO->(DbSkip())
				EndDo
			Else
				Exit
			EndIf
		Next nAuxPd
	EndIf
EndIf

If lRet

	IncProc("Verificando integridade das otas fiscais geradas!")

	SF2->(DbSetOrder(1))
	GENA82DADO->(DbGoTop())
	While GENA82DADO->(!EOF())
		If GENA82DADO->STS_PED <> "3" .OR. EMPTY(GENA82DADO->PEDIDO) .OR. EMPTY(GENA82DADO->NOTA)
			lRet := .F.
			cErroLg := "Falha ao Gerar notas fiscais, os pedidos não foram identificados"
			xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
			Exit
		Else
			If GENA82DADO->NOTA+GENA82DADO->SERIE <> SF2->F2_DOC+SF2->F2_SERIE
				If !SF2->(DbSeek( xFilial("SF2")+GENA82DADO->NOTA+GENA82DADO->SERIE ))
					lRet 		:= .F.
					cErroLg 	:= "Falha ao Gerar notas fiscais, a nota fiscal informada "+GENA82DADO->NOTA+"/"+GENA82DADO->SERIE+" não foi localizada!"
					cSolucao	:= "Execute o processamento novamente, caso o erro continue, entre em contato com a TI!"
					xMagHelpFis("Gerando nota fiscal DA",cErroLg,cSolucao)
				Else
					RecLock("SF2",.F.)
					SF2->F2_XPEDWEB	:= GENA82SEMA->NFSPGW+cSerieSrv
					MsUnLock()
				EndIf
			EndIf
		EndIf
		GENA82DADO->(DbSkip())
	EndDo

	If lRet
		SC5->(DbSetOrder(1))
		SF2->(DbSetOrder(1))
		Do Case
			Case !SC5->(DbSeek( cFilPed+GENA82SEMA->PEDPGW )) .OR. Empty(GENA82SEMA->PEDPGW)
				lRet := .F.
			Case !SC5->(DbSeek( cFilPed+GENA82SEMA->PEDRAT )) .OR. Empty(GENA82SEMA->PEDRAT)
				lRet := .F.
			Case !SF2->(DbSeek( cFilPed+GENA82SEMA->NFSPGW+cSerieSrv )) .OR. Empty(GENA82SEMA->NFSPGW)
				lRet := .F.
			Case !SF2->(DbSeek( cFilPed+GENA82SEMA->NFSRAT+cSerieSrv )) .OR. Empty(GENA82SEMA->NFSRAT)
				lRet := .F.
			OtherWise
				If SF2->(DbSeek( cFilPed+GENA82SEMA->NFSRAT+cSerieSrv ))
					RecLock("SF2",.F.)
					SF2->F2_XPEDWEB	:= GENA82SEMA->NFSPGW+cSerieSrv
					MsUnLock()
				EndIF
				Reclock("GENA82SEMA",.F.)
					GENA82SEMA->STS		:= "5"// = processo finalizado
					GENA82SEMA->DTFIM		:= DtoS(DDataBase)
					GENA82SEMA->HRFIM		:= Time()
				MsUnLock()
		EndCase
		If !lRet
			cErroLg 	:= "Identificada falha nas etapas de processamento!"
			cSolucao	:= "Execute o processamento novamente, caso o erro continue, entre em contato com a TI!"
			xMagHelpFis("Validação Final!",cErroLg,cSolucao)
		Else

		EndIf
	EndIf

EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA082   ºAutor  ³Cleuto Lima         º Data ³  27/11/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa planilha Excel MB com dados de faturamento          º±±
±±º          ³PageView's                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GerPedi(aParam)

Local lRet		:= .T.
Local nLimPd	:= GetMv("GEN_FAT226",.f.,500) // limite de itens do pedido apuração DA
Local cTesDA	:= GetMv("GEN_FAT227",.f.,"504")
Local cTesSrv	:= GetMv("GEN_FAT228",.F.,"543")
Local cCliDA	:= GetMv("GEN_FAT229",.f.,"0007099")
Local cLojaDA	:= GetMv("GEN_FAT230",.f.,"01")
Local cTransp	:= GetMv("GEN_FAT231",.f.,"000472")
Local aPdArea	:= &(GetMv("GEN_FAT232",.f.,'{ {"00002018","000008"},{"00002017","000002"},{"00002019","000007"},{"00002016","000006"},{"00002014","000001"},{"00002015","000005"} }'))
Local cNaturez	:= GetMv("GEN_FAT233",.f.,"30030")
Local nCount	:= 0
Local cItPd		:= StrZero(1,TamSx3("C6_ITEM")[1])
Local cLimPd	:= cItPd
Local aItAux	:= {}
Local aItens	:= {}
Local aCabec	:= {}
Local cLast		:= ""
Local aFlag		:= {}
Local nValFat	:= 0
Local oServer	:= nil
Local cServ		:= GetMv("GEN_FAT234",.f.,"10.3.0.72")
Local nPort  	:= GetMv("GEN_FAT235",.f.,1266)
Local cAmb		:= GetMv("GEN_FAT236",.f.,"SCHEDULE")
Local lPedDA	:= .T.
Local cPedDA	:= ""
Local aPerc		:= {}
Local nRest		:= 0
Local aMesAux	:= {"JANEIRO","FEVEREIRO","MARÇO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}
Local nAuxFlg	:= 0
Local nAuxMb	:= 0

ProcRegua(4)
IncProc()

For nCount := 2 To nLimPd
	cLimPd	:= Soma1(cLimPd)
Next

DbSelectArea("GENA82DADO")
GENA82DADO->( DBClearIndex() )
GENA82DADO->( DbSetIndex(cIdx1) )
GENA82DADO->( DbSetIndex(cIdx2) )
GENA82DADO->( DbSetOrder(1) )

GENA82DADO->(DbGoTop())
GENA82DADO->(DbSeek("0"))

While GENA82DADO->(!EOF())

	If GENA82DADO->STS_PED <> "0"
		GENA82DADO->(DbSkip())
		Loop
	EndIf

	aItAux	:= {}
	aAdd ( aItAux , { "C6_ITEM"    , cItPd							, NIL} )
	aAdd ( aItAux , { "C6_PRODUTO" , GENA82DADO->B1_COD			, NIL} )
	aAdd ( aItAux , { "C6_DESCRI"  , GENA82DADO->TITULO			, NIL} )
	aAdd ( aItAux , { "C6_LOCAL"   , "01"   						, NIL} )
	aAdd ( aItAux , { "C6_TES"     , cTesDA						, NIL} )
	aAdd ( aItAux , { "C6_QTDVEN"  , GENA82DADO->QUANT 			, NIL} )
	aAdd ( aItAux , { "C6_QTDLIB"  , GENA82DADO->QUANT			, NIL} )
	//aAdd ( aItAux , { "C6_PRUNIT"  , Round(GENA82DADO->VLUNIT,TamSX3("C6_PRCVEN")[2])			, NIL} )
	aAdd ( aItAux , { "C6_PRCVEN"  , Round(GENA82DADO->VLUNIT,TamSX3("C6_PRCVEN")[2])			, NIL} )
	aAdd ( aItAux , { "C6_VALOR"   , Round(GENA82DADO->QUANT*Round(GENA82DADO->VLUNIT,TamSX3("C6_PRCVEN")[2]),2)/*GENA82DADO->VRLAPU*/			, NIL} )
	aAdd ( aItAux , { "C6_DESCONT" , 0    							, NIL} )
	aAdd ( aItAux , { "C6_VALDESC" , 0    							, NIL} )
	aAdd ( aItAux , { "C6_ENTREG"  , StoD(GENA82SEMA->EMISSA)	, NIL} )

	nValFat += Round(GENA82DADO->QUANT*Round(GENA82DADO->VLUNIT,TamSX3("C6_PRCVEN")[2]),2)

	RecLock("GENA82DADO",.F.)
	GENA82DADO->STS_PED	:= "1"
	GENA82DADO->ITEMPD	:= cItPd
	MsUnLock()
	Aadd(aFlag, {GENA82DADO->LINHA,GENA82DADO->ITEMPD} )

	Aadd(aItens, aClone(aItAux) )

	GENA82DADO->(DbSkip())

	While GENA82DADO->(!EOF()) .AND. GENA82DADO->STS_PED <> "0"
		GENA82DADO->(DbSkip())
	EndDo
	cLast := GENA82DADO->LINHA

	If GENA82DADO->(EOF()) .OR. cItPd >= cLimPd .AND. Len(aItens) > 0

		cItPd	:= StrZero(0,TamSx3("C6_ITEM")[1])

		SA1->(DbSetOrder(1))
		SA1->(DbSeek( xFilial("SA1")+cCliDA+cLojaDA ))

		aCabec	:= {}

		//aAdd ( aCabec , { "C5_FILIAL"	, cFilAnt						, NIL} )
		aAdd ( aCabec , { "C5_TIPO"		, "N"							, NIL} )
		aAdd ( aCabec , { "C5_CLIENTE"	, SA1->A1_COD					, NIL} )
		aAdd ( aCabec , { "C5_LOJACLI"	, SA1->A1_LOJA				, NIL} )
		aAdd ( aCabec , { "C5_CLIENT"	, SA1->A1_COD					, NIL} )
		aAdd ( aCabec , { "C5_LOJAENT"	, SA1->A1_LOJA				, NIL} )
		aAdd ( aCabec , { "C5_TIPOCLI"	, SA1->A1_TIPO				, NIL} )
		aAdd ( aCabec , { "C5_TABELA"	, "   "						, NIL} )
		aAdd ( aCabec , { "C5_VEND1"	, SA1->A1_VEND				, NIL} )
		aAdd ( aCabec , { "C5_CONDPAG"	, "001"						, NIL} )
		//aAdd ( aCabec , { "C5_DATA1"	, StoD(GENA82SEMA->VENCTO)	, NIL} )
		//aAdd ( aCabec , { "C5_PARC1"	, nValFat						, NIL} )
		aAdd ( aCabec , { "C5_EMISSAO"	, StoD(GENA82SEMA->EMISSA)	, NIL} )
		aAdd ( aCabec , { "C5_TPFRETE"	, "C"							, NIL} )
		aAdd ( aCabec , { "C5_FRETE"	, 0								, NIL} )
		aAdd ( aCabec , { "C5_TRANSP"	, cTransp						, NIL} )
		//aAdd ( aCabec , { "C5_NATUREZ"	, ""							, NIL} )
		aAdd ( aCabec , { "C5_MOEDA"	, 1								, NIL} )
		aAdd ( aCabec , { "C5_TIPLIB"	, "1"							, NIL} )
		aAdd ( aCabec , { "C5_MENNOTA"	, "PERIODO DE APURACAO – "+Right(GENA82SEMA->PERIOD,2)+"/"+Left(GENA82SEMA->PERIOD,4)+" – PAGEVIEW"	, NIL} )

		DbSelectArea("SC5")
		DbSelectArea("SC6")
		DbSelectArea("SB1")

		nValFat		:= 0
		lMsErroAuto	:= .F.
		cErroLg		:= ""
		aRet			:= {}
		IncProc("Gerando pedido DA...")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realizando a nova conexão para entrar na empresa e filial correta³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ValType(oServer) == "O"
			//Fecha a Conexao com o Servidor
			RESET ENVIRONMENT IN SERVER oServer
			CLOSE RPCCONN oServer
			FreeObj(oServer)
			oServer := Nil
		EndIf

		CREATE RPCCONN oServer ON  SERVER cServ 			;   //IP do servidor
		PORT  nPort           								;   //Porta de conexão do servidor
		ENVIRONMENT cAmb       							;   //Ambiente do servidor
		EMPRESA cEmpAnt          							;   //Empresa de conexão
		FILIAL  cFilAnt         							;   //Filial de conexão
		TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que serão abertas
		MODULO  "SIGAFAT"               					//Módulo de conexão

		//MSExecAuto({|x,y,z| mata410(x,y,z)},aCabec,aItens,3)

		If ValType(oServer) == "O"
			oServer:CallProc("RPCSetType", 2)
			aRet := {}
			aRet := oServer:CallProc("U_GENA082P",aCabec,aItens,cCliDA+cLojaDA )

 			If ValType(aRet) <> "A"
 				aRet	:= {.F.,"Erro ao tentar conectar no Protheus para emissão do pedido!",{}}
 			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Realizando a nova conexão para entrar na empresa e filial correta³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//Fecha a Conexao com o Servidor
			RESET ENVIRONMENT IN SERVER oServer
			CLOSE RPCCONN oServer
			FreeObj(oServer)
			oServer := Nil

			If !aRet[1]
				For nAuxFlg := 1 To Len(aFlag)
					If GENA82DADO->(DbSeek( aFlag[nAuxFlg][1] )) .AND. aFlag[nAuxFlg][2] ==  GENA82DADO->ITEMPD
						RecLock("GENA82DADO",.F.)
						GENA82DADO->STS_PED	:= "2"
						GENA82DADO->PEDIDO	:= aRet[3]
						MsUnLock()
					Else
						lMsErroAuto	:= .T.
						cErroLg		:= "Falha ao tentar atualizar arquivo de semaforo com o flag de processamento para o pedido gerado "+SC5->C5_NUM+" !"
					EndIf
				Next nAuxFlg
				aFlag	:= {}
				If Empty(cLast)
					GENA82DADO->(DbEval({||  }))
				Else
					GENA82DADO->(DbSeek( cLast ))
				EndIf
			Else
				aFlag			:= {}
				lRet			:= .F.
				lMsErroAuto	:= .T.
				cErroLg		:= aRet[2]
			EndIf

			If lMsErroAuto
				aFlag	:= {}
				lRet	:= .F.
				cSolucao	:= "O processo será finalizado, tente executar o processo novamente, o Protheus vai sinalizar que já existe um processo em andamento, aceite que sejá continuado este processo!"+chr(13)+chr(10)+;
				"Caso o problema persista, contate a TI!"
				xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
				Exit
			EndIf

		Else
			aFlag	:= {}
			lRet	:= .F.
			cErroLg	:= "Erro ao tentar conectar no Protheus para emissão do pedido!"+chr(13)+chr(10)
			cSolucao	:= "O processo será finalizado, tente executar o processo novamente, o Protheus vai sinalizar que já existe um processo em andamento, aceite que sejá continuado este processo!"+chr(13)+chr(10)+;
			"Caso o problema persista, contate a TI!"
			xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
			Exit
		EndIf

		aItens	:= {}
		aFlag	:= {}
	EndIf

	cItPd	:= Soma1(cItPd)

EndDo

If lRet // se neste ponto o retorno é .T., todos os pedidos de apuração DA devem ter sido emitidos
	IncProc("Calculando rateio...")
	lPedDA	:= .T.
	GENA82DADO->(DbGoTop())
	While GENA82DADO->(!EOF())
		If GENA82DADO->STS_PED $ "0#1#" .OR. Empty(GENA82DADO->STS_PED) .OR. Empty(GENA82DADO->PEDIDO)
			lRet 	:= .F.
			cMsgAux	:= "Não será possível gerar os pedidos de serviço faturamento pageview e raterio editoras pois os pedidos de apuração DA ainda não foram todos gerados!"
			cSolucao	:= "Execute a rotina novamente, caso o problema persista, acione a equipe de TI!"
			xMagHelpFis("Pedido Fat.PegeView",cMsgAux,cSolucao)
			Exit
		Else
			If !(GENA82DADO->PEDIDO $ cPedDA)
				cPedDA += " '"+GENA82DADO->PEDIDO+"',"
			EndIf
		EndIf
		GENA82DADO->(DbSkip())
	EndDo

	If lRet
		cPedDA := "%("+Left(cPedDA,Len(cPedDA)-1)+")%"

		If Select("TMPMEDIA") > 0
			TMPMEDIA->(DbCloseArea())
		EndIf

		BeginSql Alias "TMPMEDIA"
			SELECT Z7_AREA AREA,Z7_DESC DESCRI,(RATIO_TO_REPORT (SUM(C6_VALOR)) OVER()) PERC
			FROM %Table:SC6% SC6
			JOIN %Table:SC5% SC5 ON C5_FILIAL = C6_FILIAL
			AND C5_NUM = C6_NUM
			AND SC5.%NotDel%
			JOIN %Table:SB1% SB1
			ON B1_FILIAL = %xFilial:SB1%
			AND B1_COD = C6_PRODUTO
			AND SB1.%NotDel%
			JOIN %Table:SB5% SB5
			ON B5_FILIAL = B1_FILIAL
			AND B5_COD = B1_COD
			AND SB5.%NotDel%
			JOIN %Table:SZ7% SZ7
			ON Z7_FILIAL = %xFilial:SZ7%
			AND Z7_AREA = CASE WHEN B5_XAREA <> '      ' THEN B5_XAREA ELSE DBA_EGK.F_GET_AREA_OBRA(TRIM(SB1.B1_XIDMAE),TRIM(SB5.B5_XCODHIS)) END
			AND SZ7.%NotDel%
			WHERE C5_FILIAL = %xFilial:SC5%
			  AND C5_NUM IN %Exp:cPedDA%
			  AND C5_CLIENTE = %Exp:cCliDA%
			  AND C5_LOJACLI = %Exp:cLojaDA%
			  AND C6_TES = %Exp:cTesDA%
			  AND SC5.%NotDel%
			  GROUP BY Z7_DESC,Z7_AREA
			  ORDER BY 3
		EndSql

		TMPMEDIA->(DbgoTop())
		TMPMEDIA->(DbEval({|x| Aadd( aPerc, { TMPMEDIA->AREA,TMPMEDIA->PERC,"",TMPMEDIA->DESCRI,"" } ) }))
		TMPMEDIA->(DbCloseArea())

		If Len(aPerc) == 0 .OR. aScan(aPerc, {|x| Empty(AllTrim(x[1])) } )
			lRet 	:= .F.
			cMsgAux	:= "Não será possível gerar os pedidos de serviço faturamento pageview e raterio editoras pois não foi possível identificar todos os percentuais de rateio!"
			cSolucao	:= "Verifique se todas as obras tem área definida e execute a rotina novamente, caso o problema persista, acione a equipe de TI!"
			xMagHelpFis("Pedido Serviço",cMsgAux,cSolucao)
		Else
			SB1->(DbSetOrder(1))
			For nAuxMb := 1 To Len(aPerc)
				nPosArea := aScan(aPdArea, {|x| AllTrim(aPerc[nAuxMb][1]) == AllTrim(x[2]) } )
				If nPosArea == 0
					lRet 		:= .F.
					cMsgAux	:= "Não será possível gerar os pedidos de serviço faturamento pageview e raterio editoras pois não foi possível identificar os codidos do produtos serviços para raterio dos valores!"
					cSolucao	:= "Vefiquei se no parametro GEN_FAT232 contem a área "+aPerc[nAuxMb][4]+" caso o mesmo esteja correto execute a rotina novamente, caso o problema persista, acione a equipe de TI!"
					xMagHelpFis("Pedido Serviço",cMsgAux,cSolucao)
					Exit
				Else
					If SB1->(DbSeek(xFilial("SB1")+aPdArea[nPosArea][1]))
						aPerc[nAuxMb][3] :=  SB1->B1_COD
						aPerc[nAuxMb][4] :=  AllTrim(SB1->B1_DESC)
					Else
						lRet 		:= .F.
						cMsgAux	:= "Não será possível gerar os pedidos de serviço faturamento pageview e raterio editoras pois não foi possível identificar os codidos do produtos serviços para raterio dos valores!"
						cSolucao	:= "Vefiquei se no parametro GEN_FAT232 contem a área "+aPerc[nAuxMb][4]+" caso o mesmo esteja correto execute a rotina novamente, caso o problema persista, acione a equipe de TI!"
						xMagHelpFis("Pedido Serviço",cMsgAux,cSolucao)
						Exit
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	//GENA82DADO->(DbEval({|x| lPedDA	:= IIF( GENA82DADO->STS_PED $ "0#1#" .OR. Empty(GENA82DADO->STS_PED) .OR. Empty(GENA82DADO->PEDIDO) , .F. , lPedDA ) }))
EndIf

If lRet
	IncProc("Gerando pedido serviço faturamento raterio editoras+mensalidade...")
	/* gerando pedido serviço faturamento page view */
	If Empty(GENA82SEMA->PEDRAT) .AND. Empty(GENA82SEMA->NFSRAT)
		//VLRRAT
		SA1->(DbSetOrder(1))
		SA1->(DbSeek( xFilial("SA1")+cCliDA+cLojaDA ))

		aCabec	:= {}
		aItens	:= {}

		//aAdd ( aCabec , { "C5_FILIAL"	, cFilAnt						, NIL} )
		aAdd ( aCabec , { "C5_TIPO"		, "N"							, NIL} )
		aAdd ( aCabec , { "C5_CLIENTE"	, SA1->A1_COD					, NIL} )
		aAdd ( aCabec , { "C5_LOJACLI"	, SA1->A1_LOJA				, NIL} )
		aAdd ( aCabec , { "C5_CLIENT"	, SA1->A1_COD					, NIL} )
		aAdd ( aCabec , { "C5_LOJAENT"	, SA1->A1_LOJA				, NIL} )
		aAdd ( aCabec , { "C5_TIPOCLI"	, SA1->A1_TIPO				, NIL} )
		aAdd ( aCabec , { "C5_TABELA"	, "   "						, NIL} )
		aAdd ( aCabec , { "C5_VEND1"	, SA1->A1_VEND				, NIL} )
		aAdd ( aCabec , { "C5_CONDPAG"	, "099"						, NIL} )
		aAdd ( aCabec , { "C5_DATA1"	, StoD(GENA82SEMA->VENCTO)	, NIL} )

		aAdd ( aCabec , { "C5_PARC1"	, (GENA82SEMA->VLRRAT+GENA82SEMA->MENSAL)						, NIL} )

		aAdd ( aCabec , { "C5_EMISSAO"	, StoD(GENA82SEMA->EMISSA)	, NIL} )
		aAdd ( aCabec , { "C5_TPFRETE"	, "C"							, NIL} )
		aAdd ( aCabec , { "C5_FRETE"	, 0								, NIL} )
		aAdd ( aCabec , { "C5_TRANSP"	, cTransp						, NIL} )
		aAdd ( aCabec , { "C5_NATUREZ"	, cNaturez						, NIL} )
		aAdd ( aCabec , { "C5_MOEDA"	, 1								, NIL} )
		aAdd ( aCabec , { "C5_TIPLIB"	, "1"							, NIL} )
		aAdd ( aCabec , { "C5_XPEDCLI"	, "MB RATEIO"					, NIL} )

		//aAdd ( aCabec , { "C5_XMSGNFS"	, "1º NFS-e: 10 POR CENTO RATEIO EDITORAS "+AllTrim(Transform((GENA82SEMA->VLRRAT),"@E 999,999,999.99"))+" REAIS E MENSALIDADE DIVIDIDA "+AllTrim(Transform((GENA82SEMA->MENSAL),"@E 999,999,999.99"))+" REAIS - "+right(GENA82SEMA->PERIOD,2)+"/"+Left(GENA82SEMA->PERIOD,4)	, NIL} )
		aAdd ( aCabec , { "C5_XMSGNFS"	, ;
			"Disponibilização, sem cessão definitiva, de texto e imagem de livros (PAGEVIEWS) por meio da internet para PJ - Período de apuração - "+Capital(Left(aMesAux[val(right(GENA82SEMA->PERIOD,2))],3))+"/"+Left(GENA82SEMA->PERIOD,4)+" Vencimento: "+DtoC(StoD(GENA82SEMA->VENCTO));
			, NIL} )



		cItPd			:= StrZero(0,TamSX3("C6_ITEM")[1])
		nVlrAcumula	:= 0

		For nAuxMB := 1 To Len(aPerc)

			aItAux	:= {}
			cItPd	:= Soma1(cItPd)
			aAdd ( aItAux , { "C6_ITEM"    , cItPd							, NIL} )
			aAdd ( aItAux , { "C6_PRODUTO" , AllTrim(aPerc[nAuxMB][3])	, NIL} )
			aAdd ( aItAux , { "C6_DESCRI"  , aPerc[nAuxMB][4]			, NIL} )
			aAdd ( aItAux , { "C6_LOCAL"   , "01"							, NIL} )
			aAdd ( aItAux , { "C6_TES"     , cTesSrv						, NIL} )
			aAdd ( aItAux , { "C6_QTDVEN"  , 1 							, NIL} )
			aAdd ( aItAux , { "C6_QTDLIB"  , 1								, NIL} )
			aAdd ( aItAux , { "C6_PRCVEN"  , Round( aPerc[nAuxMB][2]*(GENA82SEMA->VLRRAT+GENA82SEMA->MENSAL) ,TamSX3("C6_PRCVEN")[2])	, NIL} ) // 8
			aAdd ( aItAux , { "C6_VALOR"   , Round( aPerc[nAuxMB][2]*(GENA82SEMA->VLRRAT+GENA82SEMA->MENSAL) ,TamSX3("C6_PRCVEN")[2])	, NIL} ) // 9
			aAdd ( aItAux , { "C6_DESCONT" , 0    							, NIL} )
			aAdd ( aItAux , { "C6_VALDESC" , 0    							, NIL} )
			aAdd ( aItAux , { "C6_ENTREG"  , StoD(GENA82SEMA->EMISSA)	, NIL} )

			nVlrAcumula += Round( aPerc[nAuxMB][2]*(GENA82SEMA->VLRRAT+GENA82SEMA->MENSAL) ,TamSX3("C6_PRCVEN")[2])

			If nAuxMB == Len(aPerc)
				nRest	:= (GENA82SEMA->VLRRAT+GENA82SEMA->MENSAL)-nVlrAcumula
				aItAux[8][2] += nRest
				aItAux[9][2] += nRest
			EndIf

			Aadd(aItens, aClone(aItAux) )

		Next nAuxMB

		lMsErroAuto	:= .F.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realizando a nova conexão para entrar na empresa e filial correta³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ValType(oServer) == "O"
			//Fecha a Conexao com o Servidor
			RESET ENVIRONMENT IN SERVER oServer
			CLOSE RPCCONN oServer
			FreeObj(oServer)
			oServer := Nil
		EndIf

		CREATE RPCCONN oServer ON  SERVER cServ 			;   //IP do servidor
		PORT  nPort           								;   //Porta de conexão do servidor
		ENVIRONMENT cAmb       								;   //Ambiente do servidor
		EMPRESA cEmpAnt          							;   //Empresa de conexão
		FILIAL  "1001"         								;   //Filial de conexão
		TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2";   //Tabela que serão abertas
		MODULO  "SIGAFAT"               					//Módulo de conexão

		//MSExecAuto({|x,y,z| mata410(x,y,z)},aCabec,aItens,3)

		If ValType(oServer) == "O"
			oServer:CallProc("RPCSetType", 2)
			aRet := {}
			aRet := oServer:CallProc("U_GENA082P",aCabec,aItens,cCliDA+cLojaDA )

 			If ValType(aRet) <> "A"
 				aRet	:= {.F.,"Erro ao tentar conectar no Protheus para emissão do pedido serviço!",{}}
 			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Realizando a nova conexão para entrar na empresa e filial correta³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//Fecha a Conexao com o Servidor
			RESET ENVIRONMENT IN SERVER oServer
			CLOSE RPCCONN oServer
			FreeObj(oServer)
			oServer := Nil

			If !aRet[1]
				RecLock("GENA82SEMA",.F.)
				GENA82SEMA->PEDRAT	:= aRet[3]
				MsUnLock()
			Else
				lRet			:= .F.
				lMsErroAuto	:= .T.
				cErroLg		:= aRet[2]
			EndIf

			If lMsErroAuto
				lRet		:= .F.
				cSolucao	:= "O processo será finalizado, tente executar o processo novamente, o Protheus vai sinalizar que já existe um processo em andamento, aceite que sejá continuado este processo!"+chr(13)+chr(10)+;
				"Caso o problema persista, contate a TI!"
				xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
			EndIf

		Else
			lRet	:= .F.
			cErroLg	:= "Erro ao tentar conectar no Protheus para emissão do pedido!"+chr(13)+chr(10)
			cSolucao	:= "O processo será finalizado, tente executar o processo novamente, o Protheus vai sinalizar que já existe um processo em andamento, aceite que sejá continuado este processo!"+chr(13)+chr(10)+;
			"Caso o problema persista, contate a TI!"
			xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
		EndIf

		aItens	:= {}

	EndIf
EndIf

If lRet
	IncProc("Gerando pedido serviço faturamento pageview...")
	/* gerando pedido serviço faturamento page view */
	If Empty(GENA82SEMA->PEDPGW) .AND. Empty(GENA82SEMA->NFSPGW)
		//VLRRAT
		SA1->(DbSetOrder(1))
		SA1->(DbSeek( xFilial("SA1")+cCliDA+cLojaDA ))

		aCabec	:= {}
		aItens	:= {}

		//aAdd ( aCabec , { "C5_FILIAL"	, cFilAnt						, NIL} )
		aAdd ( aCabec , { "C5_TIPO"		, "N"							, NIL} )
		aAdd ( aCabec , { "C5_CLIENTE"	, SA1->A1_COD					, NIL} )
		aAdd ( aCabec , { "C5_LOJACLI"	, SA1->A1_LOJA				, NIL} )
		aAdd ( aCabec , { "C5_CLIENT"	, SA1->A1_COD					, NIL} )
		aAdd ( aCabec , { "C5_LOJAENT"	, SA1->A1_LOJA				, NIL} )
		aAdd ( aCabec , { "C5_TIPOCLI"	, SA1->A1_TIPO				, NIL} )
		aAdd ( aCabec , { "C5_TABELA"	, "   "						, NIL} )
		aAdd ( aCabec , { "C5_VEND1"	, SA1->A1_VEND				, NIL} )
		aAdd ( aCabec , { "C5_CONDPAG"	, "099"						, NIL} )
		aAdd ( aCabec , { "C5_DATA1"	, StoD(GENA82SEMA->VENCTO)	, NIL} )
		aAdd ( aCabec , { "C5_PARC1"	, GENA82SEMA->VLRPAG			, NIL} )
		aAdd ( aCabec , { "C5_EMISSAO"	, StoD(GENA82SEMA->EMISSA)	, NIL} )
		aAdd ( aCabec , { "C5_TPFRETE"	, "C"							, NIL} )
		aAdd ( aCabec , { "C5_FRETE"	, 0								, NIL} )
		aAdd ( aCabec , { "C5_TRANSP"	, cTransp						, NIL} )
		aAdd ( aCabec , { "C5_NATUREZ"	, cNaturez						, NIL} )
		aAdd ( aCabec , { "C5_MOEDA"	, 1								, NIL} )
		aAdd ( aCabec , { "C5_TIPLIB"	, "1"							, NIL} )
		aAdd ( aCabec , { "C5_XPEDCLI"	, "MB PAGEVIEW"				, NIL} )

		aAdd ( aCabec , { "C5_PESOL"	, 0							, NIL} )
		aAdd ( aCabec , { "C5_PBRUTO"	, 0							, NIL} )

		//aAdd ( aCabec , { "C5_XMSGNFS"	, "2º NFS-e: PERIODO DE APURACAO "+Right(GENA82SEMA->PERIOD,2)+"/"+Left(GENA82SEMA->PERIOD,4)+" - PAGE VIEWS "+Transform(GENA82SEMA->VLRPAG,"@E 999,999,999.99")+" REAIS"	, NIL} )
		aAdd ( aCabec , { "C5_XMSGNFS"	, ;
			"Disponibilização, sem cessão definitiva, de texto e imagem de livros (PAGEVIEWS) por meio da internet para PJ - Período de apuração - "+Capital(Left(aMesAux[val(right(GENA82SEMA->PERIOD,2))],3))+"/"+Left(GENA82SEMA->PERIOD,4)+" Vencimento: "+DtoC(StoD(GENA82SEMA->VENCTO));
			, NIL} )

		cItPd			:= StrZero(0,TamSX3("C6_ITEM")[1])
		nVlrAcumula	:= 0

		For nAuxMB := 1 To Len(aPerc)

			aItAux	:= {}
			cItPd	:= Soma1(cItPd)
			aAdd ( aItAux , { "C6_ITEM"    , cItPd							, NIL} )
			aAdd ( aItAux , { "C6_PRODUTO" , AllTrim(aPerc[nAuxMB][3])	, NIL} )
			aAdd ( aItAux , { "C6_DESCRI"  , aPerc[nAuxMB][4]			, NIL} )
			aAdd ( aItAux , { "C6_LOCAL"   , "01"							, NIL} )
			aAdd ( aItAux , { "C6_TES"     , cTesSrv						, NIL} )
			aAdd ( aItAux , { "C6_QTDVEN"  , 1 							, NIL} )
			aAdd ( aItAux , { "C6_QTDLIB"  , 1								, NIL} )
			aAdd ( aItAux , { "C6_PRCVEN"  , Round( aPerc[nAuxMB][2]*GENA82SEMA->VLRPAG ,TamSX3("C6_PRCVEN")[2])	, NIL} )
			aAdd ( aItAux , { "C6_VALOR"   , Round( aPerc[nAuxMB][2]*GENA82SEMA->VLRPAG ,TamSX3("C6_PRCVEN")[2])	, NIL} )
			aAdd ( aItAux , { "C6_DESCONT" , 0    							, NIL} )
			aAdd ( aItAux , { "C6_VALDESC" , 0    							, NIL} )
			aAdd ( aItAux , { "C6_ENTREG"  , StoD(GENA82SEMA->EMISSA)	, NIL} )

			nVlrAcumula += Round( aPerc[nAuxMB][2]*GENA82SEMA->VLRPAG ,TamSX3("C6_PRCVEN")[2])

			If nAuxMB == Len(aPerc)
				nRest	:=	GENA82SEMA->VLRPAG-nVlrAcumula
				aItAux[8][2] += nRest
				aItAux[9][2] += nRest
			EndIf

			Aadd(aItens, aClone(aItAux) )

		Next nAuxMB

		lMsErroAuto	:= .F.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realizando a nova conexão para entrar na empresa e filial correta³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ValType(oServer) == "O"
			//Fecha a Conexao com o Servidor
			RESET ENVIRONMENT IN SERVER oServer
			CLOSE RPCCONN oServer
			FreeObj(oServer)
			oServer := Nil
		EndIf

		CREATE RPCCONN oServer ON  SERVER cServ 			;   //IP do servidor
		PORT  nPort           								;   //Porta de conexão do servidor
		ENVIRONMENT cAmb       								;   //Ambiente do servidor
		EMPRESA cEmpAnt          							;   //Empresa de conexão
		FILIAL  "1001"         								;   //Filial de conexão
		TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2";   //Tabela que serão abertas
		MODULO  "SIGAFAT"               					//Módulo de conexão

		//MSExecAuto({|x,y,z| mata410(x,y,z)},aCabec,aItens,3)

		If ValType(oServer) == "O"
			oServer:CallProc("RPCSetType", 2)
			aRet := {}
			aRet := oServer:CallProc("U_GENA082P",aCabec,aItens,cCliDA+cLojaDA )

 			If ValType(aRet) <> "A"
 				aRet	:= {.F.,"Erro ao tentar conectar no Protheus para emissão do pedido serviço!",{}}
 			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Realizando a nova conexão para entrar na empresa e filial correta³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//Fecha a Conexao com o Servidor
			RESET ENVIRONMENT IN SERVER oServer
			CLOSE RPCCONN oServer
			FreeObj(oServer)
			oServer := Nil

			If !aRet[1]
				RecLock("GENA82SEMA",.F.)
				GENA82SEMA->PEDPGW	:= aRet[3]
				MsUnLock()
			Else
				lRet			:= .F.
				lMsErroAuto	:= .T.
				cErroLg		:= aRet[2]
			EndIf

			If lMsErroAuto
				lRet		:= .F.
				cSolucao	:= "O processo será finalizado, tente executar o processo novamente, o Protheus vai sinalizar que já existe um processo em andamento, aceite que sejá continuado este processo!"+chr(13)+chr(10)+;
				"Caso o problema persista, contate a TI!"
				xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
			EndIf

		Else
			lRet	:= .F.
			cErroLg	:= "Erro ao tentar conectar no Protheus para emissão do pedido!"+chr(13)+chr(10)
			cSolucao	:= "O processo será finalizado, tente executar o processo novamente, o Protheus vai sinalizar que já existe um processo em andamento, aceite que sejá continuado este processo!"+chr(13)+chr(10)+;
			"Caso o problema persista, contate a TI!"
			xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
		EndIf

		aItens	:= {}

	EndIf
EndIf

Return lRet

Static Function VldSitAtu(aParam,nQtdRegOk,lCrisStr)

Local lRet	 	:= .T.
Local cClie		:= GetMv("GEN_FAT229",.F.,"0007099")
Local cLoja		:= GetMv("GEN_FAT230",.F.,"01")
Local cTes		:= GetMv("GEN_FAT227",.F.,"504")
Local cTesSrv	:= GetMv("GEN_FAT228",.F.,"543")
Local cFilSrv	:= GetMv("GEN_FAT223",.F.,"1001")
Local aDados	:= {}
Local cSitAux	:= ""
Local cPedido	:= ""
Local cItem		:= ""
Local cNota		:= ""
Local cSerie	:= ""
Local cCount	:= 0
Local cStsSer	:= ""

Local lPedDAOk	:=.T.
Local lPedRAOk	:=.T.
Local lPedPGOk	:=.T.
Local lNotaOk	:=.T.
Local lAchouPed	:= .F.
Local cDayIni	:= DtoS(FirstDay( StoD(GENA82SEMA->EMISSA) ))
Local cDayFim	:= DtoS(LastDay( StoD(GENA82SEMA->EMISSA) ))
Local nAux		:= 0

ProcRegua(0)
IncProc("Buscando pedidos gerados no periodo!")

GENA82SEMA->(DbGoTop())
GENA82DADO->(DbGoTop())

If Select("TMPFAT") > 0
	TMPFAT->(DbCloseArea())
EndIf

BeginSql Alias "TMPFAT"
	SELECT C5_NUM,C6_ITEM,C6_PRODUTO,C6_QTDVEN,C6_PRUNIT,C6_PRCVEN,C6_NOTA,C6_SERIE FROM %Table:SC6% SC6
	JOIN %Table:SC5% SC5
	ON C5_FILIAL = C6_FILIAL
	AND C5_NUM = C6_NUM
	AND SC5.%NotDel%
	WHERE C5_FILIAL = %xFilial:SC5%
	AND C5_EMISSAO BETWEEN %Exp:cDayIni% AND %Exp:cDayFim%
	AND C5_CLIENTE = %Exp:cClie%
	AND C5_LOJACLI = %Exp:cLoja%
	AND C6_TES 	= %Exp:cTes%
	AND SC5.%NotDel%
EndSql

TMPFAT->(DbGotop())
If TMPFAT->(EOF())
	While GENA82DADO->(!EOF())
		Reclock("GENA82DADO",.F.)
		GENA82DADO->STS_PED	:= "0"
		GENA82DADO->PEDIDO	:= ""
		GENA82DADO->ITEMPD	:= ""
		GENA82DADO->NOTA	:= ""
		GENA82DADO->SERIE	:= ""
		MsUnLock()
		GENA82DADO->(DbSkip())
	EndDo
Else
	While TMPFAT->(!EOF())

		Aadd(aDados, { TMPFAT->C5_NUM,TMPFAT->C6_ITEM,TMPFAT->C6_PRODUTO,TMPFAT->C6_QTDVEN,TMPFAT->C6_PRUNIT,TMPFAT->C6_PRCVEN,TMPFAT->C6_NOTA,TMPFAT->C6_SERIE,.F. } )

		TMPFAT->(DbSkip())
	EndDo
EndIf

DbSelectArea("GENA82DADO")
//DbClearIndex()
//FErase("GENA82IDX1"+OrdBagExt())

ProcRegua(nQtdRegOk)

If Len(aDados) > 0
	/*
	cIdxTmp  := CriaTrab(nil,.F.)
	IndRegua("GENA82DADO",cIdxTmp,"LINHA","D")
	DbSetIndex(cIdxTmp+OrdBagExt())
	DbSetOrder(1)
	*/
	GENA82DADO->(DbSetOrder(1))
	GENA82DADO->(DbGotop())

	While GENA82DADO->(!EOF())

		cCount++
		IncProc("Vld.Sit.Fat. "+StrZero(cCount,5))

		cSitAux := GENA82DADO->STS_PED
		//// 0 = ainda não processado;1 = includi no array para processamento ; 2 = pedido gerado com sucesso ; 3 = nota fiscal gerada com sucesso
		nPos := aScan(aDados, {|x| GENA82DADO->PEDIDO == x[1] .AND. GENA82DADO->ITEMPD == x[2] .AND. GENA82DADO->NOTA == x[7] .AND. GENA82DADO->SERIE == x[8] .AND. x[3] == GENA82DADO->B1_COD .AND. GENA82DADO->QUANT == x[4] .AND. !x[9] .AND. !Empty(x[7]) .AND.  x[6] == Round(GENA82DADO->VLUNIT,TamSX3("C6_PRCVEN")[2]) } )
		If nPos == 0
			nPos := aScan(aDados, {|x| GENA82DADO->PEDIDO == x[1] .AND. GENA82DADO->ITEMPD == x[2] .AND. x[3] == GENA82DADO->B1_COD .AND. GENA82DADO->QUANT == x[4] .AND. !x[9]  .AND.  x[6] == Round(GENA82DADO->VLUNIT,TamSX3("C6_PRCVEN")[2]) } )
			If nPos == 0
				nPos := aScan(aDados, {|x| GENA82DADO->PEDIDO == x[1] .AND. x[3] == GENA82DADO->B1_COD .AND. GENA82DADO->QUANT == x[4] .AND. !x[9]  .AND.  x[6] == Round(GENA82DADO->VLUNIT,TamSX3("C6_PRCVEN")[2]) } )
				If nPos == 0
					nPos := aScan(aDados, {|x| GENA82DADO->ITEMPD == x[2] .AND. AllTrim(x[3]) == AllTrim(GENA82DADO->B1_COD) .AND. GENA82DADO->QUANT == x[4] .AND. !x[9]  .AND.  x[6] == Round(GENA82DADO->VLUNIT,TamSX3("C6_PRCVEN")[2]) } )
					If nPos == 0
						nPos := aScan(aDados, {|x| AllTrim(x[3]) == AllTrim(GENA82DADO->B1_COD) .AND. GENA82DADO->QUANT == x[4] .AND. !x[9]  .AND.  x[6] == Round(GENA82DADO->VLUNIT,TamSX3("C6_PRCVEN")[2]) } )
					EndIf
				EndIf
			EndIf

			If nPos == 0
				cSitAux	:= "0"
				cPedido	:= ""
				cItem		:= ""
				cNota		:= ""
				cSerie		:= ""
			Else
				aDados[nPos][9]	:= .T.
				cSitAux	:= IIF( Empty(aDados[nPos][7]) , "2" , "3" )
				cPedido	:= aDados[nPos][1]
				cItem		:= aDados[nPos][2]
				cNota		:= aDados[nPos][7]
				cSerie		:= aDados[nPos][8]
			EndIF

		Else
			aDados[nPos][9]	:= .T.
			cSitAux	:= "3"
			cPedido	:= aDados[nPos][1]
			cItem		:= aDados[nPos][2]
			cNota		:= aDados[nPos][7]
			cSerie		:= aDados[nPos][8]
		EndIf

		Do Case
			Case cSitAux == "0" .OR. cSitAux == "1" .OR. Empty(cSitAux)
				lPedDAOk	:=.F.
				lNotaOk	:=.F.
			Case cSitAux == "2"
				lNotaOk	:=.F.
		EndCase

		//If cSitAux <> GENA82DADO->STS_PED
		RecLock("GENA82DADO",.F.)
		GENA82DADO->STS_PED	:= cSitAux
		GENA82DADO->PEDIDO	:= cPedido
		GENA82DADO->ITEMPD	:= cItem
		GENA82DADO->NOTA		:= cNota
		GENA82DADO->SERIE		:= cSerie
		MsUnLock()
		//EndIf


		GENA82DADO->(DbSkip())
	EndDo

	DbSelectArea("GENA82DADO")
//	DbClearIndex()
//	FErase(cIdxTmp+OrdBagExt())

EndIf

TMPFAT->(DbCloseArea())

If lRet
	lAchouPed := .F.

	If !Empty(GENA82SEMA->PEDRAT)
		BeginSql Alias "TMPFAT"
			SELECT C5_NUM,C5_NOTA,C5_SERIE,SUM(C6_VALOR) C6_VALOR FROM %Table:SC6% SC6
			JOIN %Table:SC5% SC5
			ON C5_FILIAL = C6_FILIAL
			AND C5_NUM = C6_NUM
			AND SC5.%NotDel%
			WHERE C5_FILIAL = %Exp:cFilSrv%
			AND C5_NUM = %Exp:GENA82SEMA->PEDRAT%
			AND C5_CLIENTE = %Exp:cClie%
			AND C5_LOJACLI = %Exp:cLoja%
			AND C6_TES 	= %Exp:cTesSrv%
			AND C5_XPEDCLI LIKE '%MB RATEIO%'
			AND SC5.%NotDel%
			GROUP BY C5_NUM,C5_NOTA,C5_SERIE
		EndSql
		TMPFAT->(DbGoTop())
		lAchouPed := !TMPFAT->(EOF())
	EndIf

	If !lAchouPed
		If Select("TMPFAT") > 0
			TMPFAT->(DbcloseArea())
		EndIf
		BeginSql Alias "TMPFAT"
			SELECT C5_NUM,C5_NOTA,C5_SERIE,SUM(C6_VALOR) C6_VALOR FROM %Table:SC6% SC6
			JOIN %Table:SC5% SC5
			ON C5_FILIAL = C6_FILIAL
			AND C5_NUM = C6_NUM
			AND SC5.%NotDel%
			WHERE C5_FILIAL = %Exp:cFilSrv%
			AND C5_EMISSAO BETWEEN %Exp:cDayIni% AND %Exp:cDayFim%
			AND C5_CLIENTE = %Exp:cClie%
			AND C5_LOJACLI = %Exp:cLoja%
			AND C6_TES 	= %Exp:cTesSrv%
			AND C5_XPEDCLI LIKE '%MB RATEIO%'
			AND SC5.%NotDel%
			GROUP BY C5_NUM,C5_NOTA,C5_SERIE
		EndSql
		TMPFAT->(DbGoTop())
	EndIf

	If TMPFAT->(EOF())
		RecLock("GENA82SEMA",.F.)
		GENA82SEMA->PEDRAT := ""
		GENA82SEMA->NFSRAT := ""
		MsUnLock()
	Else
		If TMPFAT->C6_VALOR <> GENA82SEMA->VLRRAT+GENA82SEMA->MENSAL
			nAvAux := Aviso("Integridade","Identificamos na base de dados o pedido "+TMPFAT->C5_NUM+" referente a faturamento rateio editoras + mensalidade com valor difernte do informado para o processamento do periodo atual!"+chr(13)+chr(10)+;
			"Valor do pedido: R$ "+Transform(TMPFAT->C6_VALOR,"@E 999,999,999.99")+", Valor informado para faturamento R$ "+Transform(GENA82SEMA->VLRRAT+GENA82SEMA->MENSAL,"@E 999,999,999.99") +chr(13)+chr(10)+;
			"O que deseja fazer?",{"Usar Pedido","Ignorar Pedido","Abortar"},,"Atenção!")
			If nAvAux == 1
				RecLock("GENA82SEMA",.F.)
				GENA82SEMA->PEDRAT := TMPFAT->C5_NUM
				GENA82SEMA->NFSRAT := TMPFAT->C5_NOTA
				MsUnLock()
			ElseIf nAvAux == 2
				RecLock("GENA82SEMA",.F.)
				GENA82SEMA->PEDRAT := ""
				GENA82SEMA->NFSRAT := ""
				MsUnLock()
			Else
				lRet	:= .F.
			EndIf
		Else
			RecLock("GENA82SEMA",.F.)
			GENA82SEMA->PEDRAT := TMPFAT->C5_NUM
			GENA82SEMA->NFSRAT := TMPFAT->C5_NOTA
			MsUnLock()
		EndIf

	EndIf
	TMPFAT->(DbCloseArea())
EndIf

If lRet
	lAchouPed := .F.
	If Select("TMPFAT") > 0
		TMPFAT->(DbCloseArea())
	EndIf

	If !Empty(GENA82SEMA->PEDPGW)
		BeginSql Alias "TMPFAT"
			SELECT C5_NUM,C5_NOTA,C5_SERIE,SUM(C6_VALOR) C6_VALOR FROM %Table:SC6% SC6
			JOIN %Table:SC5% SC5
			ON C5_FILIAL = C6_FILIAL
			AND C5_NUM = C6_NUM
			AND SC5.%NotDel%
			WHERE C5_FILIAL = %Exp:cFilSrv%
			AND C5_NUM = %Exp:GENA82SEMA->PEDPGW%
			AND C5_CLIENTE = %Exp:cClie%
			AND C5_LOJACLI = %Exp:cLoja%
			AND C6_TES 	= %Exp:cTesSrv%
			AND C5_XPEDCLI LIKE '%MB PAGEVIEW%'
			AND SC5.%NotDel%
			GROUP BY C5_NUM,C5_NOTA,C5_SERIE
		EndSql
		TMPFAT->(DbGoTop())
		lAchouPed := TMPFAT->(!EOF())
	EndIf

	If !lAchouPed
		If Select("TMPFAT") > 0
			TMPFAT->(DbcloseArea())
		EndIf
		BeginSql Alias "TMPFAT"
			SELECT C5_NUM,C5_NOTA,C5_SERIE,SUM(C6_VALOR) C6_VALOR FROM %Table:SC6% SC6
			JOIN %Table:SC5% SC5
			ON C5_FILIAL = C6_FILIAL
			AND C5_NUM = C6_NUM
			AND SC5.%NotDel%
			WHERE C5_FILIAL = %Exp:cFilSrv%
			AND C5_EMISSAO BETWEEN %Exp:cDayIni% AND %Exp:cDayFim%
			AND C5_CLIENTE = %Exp:cClie%
			AND C5_LOJACLI = %Exp:cLoja%
			AND C6_TES 	= %Exp:cTesSrv%
			AND C5_XPEDCLI LIKE '%MB PAGEVIEW%'
			AND SC5.%NotDel%
			GROUP BY C5_NUM,C5_NOTA,C5_SERIE
		EndSql
		TMPFAT->(DbGoTop())
	EndIf

	If TMPFAT->(EOF())
		RecLock("GENA82SEMA",.F.)
		GENA82SEMA->PEDPGW := ""
		GENA82SEMA->NFSPGW := ""
		MsUnLock()
	Else
		If TMPFAT->C6_VALOR <> GENA82SEMA->VLRPAG
			nAvAux := Aviso("Integridade","Identificamos na base de dados o pedido "+TMPFAT->C5_NUM+" referente a faturamento das pageviews com valor difernte do informado para o processamento do periodo atual!"+chr(13)+chr(10)+;
			"Valor do pedido: R$ "+Transform(TMPFAT->C6_VALOR,"@E 999,999,999.99")+", Valor informado para faturamento R$ "+Transform(GENA82SEMA->VLRPAG,"@E 999,999,999.99") +chr(13)+chr(10)+;
			"O que deseja fazer?",{"Usar Pedido","Descartar Pedido","Abortar"},,"Atenção!")

			If nAvAux == 1
				RecLock("GENA82SEMA",.F.)
				GENA82SEMA->PEDPGW := TMPFAT->C5_NUM
				GENA82SEMA->NFSPGW := TMPFAT->C5_NOTA
				MsUnLock()
			ElseIf nAvAux == 2
				RecLock("GENA82SEMA",.F.)
				GENA82SEMA->PEDPGW := ""
				GENA82SEMA->NFSPGW := ""
				MsUnLock()
			Else
				lRet	:= .F.
			EndIf
		Else
			RecLock("GENA82SEMA",.F.)
			GENA82SEMA->PEDPGW := TMPFAT->C5_NUM
			GENA82SEMA->NFSPGW := TMPFAT->C5_NOTA
			MsUnLock()
		EndIf
	EndIf
	TMPFAT->(DbCloseArea())
EndIF

If Select("TMPFAT") > 0
	TMPFAT->(DbCloseArea())
EndIf

GENA82SEMA->(DbGoTop())

If lRet
	// 0 ou branco = em processameno; 1 = pedidos gerados com sucesso e processando notas fiscais ; 2 = notas fiscais geradas DA com sucesso; 3 nota fiscal rateio editoras gerada com sucesso ; 4 = nota fiscal faturamento pageviw gerada com sucesso ; 5 = processo finalizado
	Do Case
		Case lNotaOk .AND. !Empty(GENA82SEMA->PEDRAT) .AND. !Empty(GENA82SEMA->NFSRAT) .AND. !Empty(GENA82SEMA->PEDPGW) .AND. !Empty(GENA82SEMA->NFSPGW)
			cStsSer := "5"
		Case lPedDAOk .AND. !Empty(GENA82SEMA->PEDRAT) .AND. !Empty(GENA82SEMA->PEDPGW)
			cStsSer := "1"
		OtherWise
			cStsSer := "0"
	EndCase

	If cStsSer <> GENA82SEMA->STS
		Reclock("GENA82SEMA",.F.)
		GENA82SEMA->STS	:= cStsSer
		MsUnLock()
	EndIf

	If aScan(aDados, {|x| !x[9] } ) <> 0
		cMsgAux	:= "Foram identificadas obras faturadas para o periodo informado que não estão no arquivo de processamento atual!"+Chr(13)+Chr(10)
		For nAux := 1 To Len(aDados)
			IF aDados[nAux][9]
				Loop
			EndIF
			cMsgAux += "Pedido: "+aDados[nAux][1]+", Item: "+aDados[nAux][2]+", Obra: "+aDados[nAux][3]+Chr(13)+Chr(10)
		Next nAux
		cSolucao	:= "A seguir será solicitado se deseja continuar com o processamento do arquivo atual!"
		xMagHelpFis("Periodo em processamento",cMsgAux,cSolucao)
		lRet := MsgYesNo("Deseja continuar com o processamento do arquivo?"+Chr(13)+Chr(10)+"Caso opte por não continuar com o processamento neste momento, o arquivo de processamento continuara salvo e você pode retomar o processamento em outro momento.")
	EndIf
EndIf

If lRet
	IncProc("Verificando situação das obras!")
	GENA82DADO->(DbGoTop())
	SB1->(DbSetOrder(1))
	cMsgAux	:= ""
	While GENA82DADO->(!EOF())
		If !SB1->(Dbseek(xFilial("SB1")+GENA82DADO->B1_COD))
			lRet := .F.
			cMsgAux += "Obra "+GENA82DADO->B1_COD+" não localizada!"+Chr(13)+Chr(10)
		ElseIf SB1->B1_MSBLQL == "1"
			lRet	:= .F.
			cMsgAux += "Obra "+GENA82DADO->B1_COD+" bloqueada!"+Chr(13)+Chr(10)
		EndIf

		GENA82DADO->(DbSkip())
	EndDo

	If !lRet
		cSolucao	:= "Verifique a situação das obras informadas e execute o processo novamente!"
		xMagHelpFis("Periodo em processamento",cMsgAux,cSolucao)
	EndIf

EndIf

Return lRet

Static Function CargaEstru(aParam,nQtdRegOk)

Local nQtdGrava	:= 0
Local lRet 		:= .T.
Local cSemaforo	:= "GENA082_"+AllTrim(aParam[P_04])+"_SEMA"
Local cDados	:= "GENA082_"+AllTrim(aParam[P_04])+"_DADO"
Local cExtAux	:= ".dtc"
Local cDirBase	:= "\system\"

DbSelectArea("TMPEXCEL")
TMPEXCEL->(DbSetOrder(2))
//DbClearIndex()
//cIdxTmp  := CriaTrab(nil,.F.)
//IndRegua("TMPEXCEL",cIdxTmp,"StrZero(LINHA,5)","C")
//DbSetIndex(cIdxTmp+OrdBagExt())

Begin Transaction
	Reclock("GENA82SEMA",.T.)
	GENA82SEMA->STS		:= "0"
	GENA82SEMA->DTINI		:= DtoS(DDataBase)
	GENA82SEMA->HRINI		:= Time()
	GENA82SEMA->DTFIM		:= ""
	GENA82SEMA->HRFIM		:= ""
	GENA82SEMA->USERPROC	:= RetCodUsr()
	GENA82SEMA->NAME		:= UsrRetName(RetCodUsr())
	//GENA82SEMA->CHAVE		:= ""
	GENA82SEMA->FILEPROC	:= AllTrim(aParam[P_01])
	GENA82SEMA->VLRRAT	:= aParam[P_02]
	GENA82SEMA->VLRPAG	:= aParam[P_03]
	GENA82SEMA->PERIOD	:= aParam[P_04]
	GENA82SEMA->VENCTO	:= DtoS(aParam[P_05])
	GENA82SEMA->EMISSA	:= DtoS(aParam[P_07])
	GENA82SEMA->MENSAL	:= aParam[P_08]
	MsUnLock()

	TMPEXCEL->(DbGoTop())
	While TMPEXCEL->(!EOF())

		If Empty(TMPEXCEL->STATUS) .OR. AllTrim(TMPEXCEL->STATUS) == "N" .OR. AllTrim(TMPEXCEL->STATUS) == "E"
			TMPEXCEL->(DbSkip())
			Loop
		EndIf

		// 0 = ainda não processado;1 = includi no array para processamento ; 2 = pedido gerado com sucesso ; 3 = nota fiscal gerada com sucesso
		Reclock("GENA82DADO",.T.)
		GENA82DADO->STS_PED	:= "0"
		GENA82DADO->PERIOD	:= aParam[P_04]
		GENA82DADO->B1_COD	:= TMPEXCEL->B1_COD
		GENA82DADO->ISBN	:= TMPEXCEL->B1_ISBN
		GENA82DADO->VBID	:= TMPEXCEL->VBID
		//GENA82DADO->ISBN_O	:= ""
		GENA82DADO->TITULO	:= TMPEXCEL->B1_DESC
		GENA82DADO->QUANT	:= TMPEXCEL->C6_QTDVEN
		GENA82DADO->VRLPGW	:= TMPEXCEL->C6_VALOR
		GENA82DADO->VRLAPU	:= TMPEXCEL->C6_PRUNIT
		GENA82DADO->VLUNIT	:= TMPEXCEL->C6_PRCVEN
		GENA82DADO->PERAPU	:= aParam[P_06]
		GENA82DADO->TPPUB	:= TMPEXCEL->TPPUB
		GENA82DADO->SITOBR	:= TMPEXCEL->SITOBR
		GENA82DADO->PEDIDO	:= ""
		GENA82DADO->ITEMPD	:= ""
		GENA82DADO->NOTA	:= ""
		GENA82DADO->SERIE	:= ""
		GENA82DADO->LINHA	:= STRZERO(TMPEXCEL->LINHA,10)
		GENA82DADO->RECAUX	:= TMPEXCEL->LINHA
		MsUnLock()
		nQtdGrava++
		TMPEXCEL->(DbSkip())

	EndDo
End Transaction

DbSelectArea("TMPEXCEL")
TMPEXCEL->(DbCloseArea())
//DbClearIndex()
//FErase(cIdxTmp+OrdBagExt())
TMPEXCEL:Delete()

GENA82DADO->(DbGotop())
GENA82SEMA->(DbGotop())

If !(GENA82SEMA->STS == "0" .AND. GENA82DADO->PERIOD == aParam[P_04] .AND. nQtdGrava == nQtdRegOk)
	GENA82SEMA->(DbCloseArea())
	GENA82DADO->(DbCloseArea())
	//FErase(cDirBase+cSemaforo+cExtAux)
	//FErase(cDirBase+cDados+cExtAux)
	lRet := .F.
	MsgStop("Falha no processo de armazenamento, por favor, repita o processo!")
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA082   ºAutor  ³Cleuto Lima         º Data ³  27/11/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa planilha Excel MB com dados de faturamento          º±±
±±º          ³PageView's                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaStru(aParam)

Local lRet			:= .T.
Local lContinua		:= .T.
Local cSemaforo		:= "GENA082_"+AllTrim(aParam[P_04])+"_SEMA"
Local cDados		:= "GENA082_"+AllTrim(aParam[P_04])+"_DADO"
Local aCpSts		:=	{}
Local aCpDat		:=	{}
Local cFlTmp		:= ""
Local cMsgAux		:= ""
Local cSolucao		:= ""
Local cExtAux		:= ".dtc"
Local cDirBase		:= "\system\"
Local cFileSema		:= cDirBase+cSemaforo+cExtAux
Local cFileDado		:= cDirBase+cDados+cExtAux

AADD(aCpSts,{"STS"	,"C"	,001,0})// 0 ou branco = em processameno; 1 = pedidos gerados com sucesso e processando notas fiscais ; 2 = notas fiscais geradas DA com sucesso; 3 nota fiscal rateio editoras gerada com sucesso ; 4 =3 nota fiscal faturamento pageviw gerada com sucesso ; 5 = processo finalizado
AADD(aCpSts,{"DTINI"	,"C"	,008,0})
AADD(aCpSts,{"HRINI"	,"C"	,005,0})
AADD(aCpSts,{"DTFIM"	,"C"	,008,0})
AADD(aCpSts,{"HRFIM"	,"C"	,005,0})
AADD(aCpSts,{"USERPROC"	,"C"	,030,0})
AADD(aCpSts,{"NAME"	,"C"	,050,0})
//AADD(aCpSts,{"CHAVE"	,"C"	,006,0})
AADD(aCpSts,{"FILEPROC"	,"C"	,150,0})
AADD(aCpSts,{"VLRRAT","N"	,015,2})
AADD(aCpSts,{"VLRPAG","N"	,015,2})
AADD(aCpSts,{"MENSAL","N"	,015,2})
AADD(aCpSts,{"PERIOD","C"	,006,0})
AADD(aCpSts,{"VENCTO","C"	,008,0})
AADD(aCpSts,{"EMISSA","C"	,008,0})

AADD(aCpSts,{"PEDRAT","C"	,006,0})
AADD(aCpSts,{"NFSRAT","C"	,009,0})
AADD(aCpSts,{"PEDPGW","C"	,006,0})
AADD(aCpSts,{"NFSPGW","C"	,009,0})

AADD(aCpDat,{"STS_PED"	,"C"	,001,0})// 0 = ainda não processado;1 = includi no array para processamento ; 2 = pedido gerado com sucesso ; 3 = nota fiscal gerada com sucesso
AADD(aCpDat,{"PERIOD"	,"C"	,006,0})
AADD(aCpDat,{"B1_COD"	,"C"	,TamSX3("B1_COD")[1],0})
AADD(aCpDat,{"ISBN"		,"C"	,TamSX3("B1_ISBN")[1],0})
AADD(aCpDat,{"VBID"		,"C"	,TamSX3("B1_ISBN")[1],0})
AADD(aCpDat,{"ISBN_O"	,"C"	,TamSX3("B1_ISBN")[1],0})
AADD(aCpDat,{"TITULO"	,"C"	,TamSX3("B1_DESC")[1],0})
AADD(aCpDat,{"QUANT"		,"N"	,TamSX3("C6_QTDVEN")[1],0})
AADD(aCpDat,{"VRLPGW"	,"N"	,18,6})
AADD(aCpDat,{"VRLAPU"	,"N"	,18,6})
AADD(aCpDat,{"VLUNIT"	,"N"	,18,6})
AADD(aCpDat,{"PERAPU"	,"N"	,TamSX3("C6_DESCONT")[1],TamSX3("C6_DESCONT")[2]})
AADD(aCpDat,{"TPPUB"		,"C"	,TamSX3("B1_XIDTPPU")[1],0})
AADD(aCpDat,{"SITOBR"	,"C"	,TamSX3("B1_XSITOBR")[1],0})
AADD(aCpDat,{"PEDIDO"	,"C"	,TamSX3("C6_NUM")[1],0})
AADD(aCpDat,{"ITEMPD"	,"C"	,TamSX3("C6_ITEM")[1],0})
AADD(aCpDat,{"NOTA"		,"C"	,TamSX3("C5_NOTA")[1],0})
AADD(aCpDat,{"SERIE"		,"C"	,TamSX3("C5_SERIE")[1],0})
AADD(aCpDat,{"LINHA"		,"C"	,10,0})
AADD(aCpDat,{"RECAUX"	,"N"	,010,0})
//AADD(aCpDat,{"SITUACAO"	,"C"	,30,0})

//If File(cFileSema)
If lSemaExt//ChkFile(cSemaforo,.F.,NIL,NIL,NIL,NIL,NIL,cSemaforo)//MsFile(cSemaforo,nil,"TOPCONN")
	xMagHelpFis("Periodo em processamento","Identificada inconsistência no controle de semáforo da rotina GENA082, o cabeçalho ("+cSemaforo+".dtc) não está integro em relação aos itens ("+cDados+".dtc).","Solicite a TI que realize a verificação dos dados!")
	Return .F.
Else
	If lDadoExt//MsFile(cDados,nil,"TOPCONN")//File(cFileDado)
		xMagHelpFis("Periodo em processamento","Identificada inconsistência no controle de semáforo da rotina GENA082, o cabeçalho ("+cSemaforo+".dtc) não está integro em relação aos itens ("+cDados+".dtc).","Solicite a TI que realize a verificação dos dados!")
		Return .F.
	EndIf
	/*
	 Descontinuado para versão lobo guara com dicionario no banco - Fernando Lavor 03/07/2019
	*/
	/* criando arquivo de semaforo de processamento */
    //cFlTmp	:=	CriaTrab(aCpSts) // cria tabela temporaia em Ctree
	//FRename(cDirBase+cFlTmp+cExtAux,cFileSema)
	//DbUseArea(.T.,__LocalDriver,cFileSema,"GENA82SEMA",.T.,.F.) // abre o alias
	//DbSelectArea("GENA82SEMA") // seleciona o alias

    //GENA82SEMA := FWTemporaryTable():New( "GENA82SEMA" )
	//GENA82SEMA:SetFields(aCpSts)
	//GENA82SEMA:AddIndex("1", {"STS_PED"})
	DBCreate(cSemaforo,aCpSts,"TOPCONN")
	DbUseArea(.T.,"TOPCONN",cSemaforo,"GENA82SEMA",.F.,.F.)
	GENA82SEMA->( DBClearIndex() )

	//DBCreateIndex("SEMAIDX1", "LINHA"         		, {|| LINHA			})
	//DBCreateIndex("SEMAIDX2", "PEDIDO+LINHA"        , {|| PEDIDO+LINHA	})
	

    //------------------
	//Criação da tabela temporaria
	//------------------
	//GENA82SEMA:Create()

	/*
	 Descontinuado para versão lobo guara com dicionario no banco - Fernando Lavor 03/07/2019
	*/

	/* criando arquivo de semaforo de processamento */
	//cFlTmp	:=	CriaTrab(aCpDat) // cria tabela temporaia em Ctree
	//FRename(cDirBase+cFlTmp+cExtAux,cFileDado)
	//DbUseArea(.T.,__LocalDriver,cFileDado,"GENA82DADO",.T.,.F.) // abre o alias
	//DbSelectArea("GENA82DADO") // seleciona o alias

    //GENA82DADO := FWTemporaryTable():New( "GENA82DADO" )
	//GENA82DADO:SetFields(aCpDat)
	//GENA82SEMA:AddIndex("1", {"STS_PED"})

    //------------------
	//Criação da tabela temporaria
	//------------------
	//GENA82SEMA:Create()

	DBCreate(cDados,aCpDat,"TOPCONN")
	DbUseArea(.T.,"TOPCONN",cDados,"GENA82DADO",.F.,.F.)	
	GENA82DADO->( DBClearIndex() )

	If !VldIndice(cDados)
		Return .F.
	EndIf

	GENA82DADO->(DBReindex())
	DbSelectArea("GENA82DADO")

	cIdx1		:= xRetIndex("A")//GetNextAlias()+"A"
	cIdx2		:= xRetIndex("B")//GetNextAlias()+"B"

	DbSelectArea("GENA82DADO")
	GENA82DADO->(DBCreateIndex(cIdx1, "LINHA"         , {|| LINHA		}))
	GENA82DADO->(DBCreateIndex(cIdx2, "PEDIDO+LINHA"  , {|| PEDIDO+LINHA	}))
		
EndIf

Return lRet

Static Function xRetIndex(cAux)

Local cRet	:= ""
Local lLoop	:= .T.

While lLoop
	cRet := GetNextAlias()+cAux

	IF select("TMP_IDX") > 0
		TMP_IDX->(DbcloseArea())
	ENDIF

	BeginSql Alias "TMP_IDX"
		SELECT OBJECT_NAME FROM ALL_OBJECTS 
		WHERE OBJECT_NAME LIKE '%'||%Exp:AllTrim(cRet)%||'%'
	EndSql

	lLoop := !(TMP_IDX->(EOF()))
	
EndDo

IF select("TMP_IDX") > 0
	TMP_IDX->(DbcloseArea())
ENDIF

Return cRet

Static Function ValidStru(aParam,lCrisStr)

Local lRet			:= .T.
Local lContinua		:= .T.
Local cSemaforo		:= "GENA082_"+AllTrim(aParam[P_04])+"_SEMA"
Local cDados		:= "GENA082_"+AllTrim(aParam[P_04])+"_DADO"
Local aCpSts		:=	{}
Local aCpDat		:=	{}
Local cFlTmp		:= ""
Local cMsgAux		:= ""
Local cSolucao		:= ""
Local cExtAux		:= ".dtc"
Local cDirBase		:= "\system\"
Local cFileSema		:= cDirBase+cSemaforo+cExtAux
Local cFileDado		:= cDirBase+cDados+cExtAux

IF Select("GENA82SEMA") > 0
	GENA82SEMA->(DbCloseArea())
EndIF

IF Select("GENA82DADO") > 0
	GENA82DADO->(DbCloseArea())
EndIF

IF Select("VLDSTRU") > 0
	VLDSTRU->(DbCloseArea())
EndIF

BEGINSQL alias "VLDSTRU"
	SELECT TABLE_NAME FROM ALL_TABLES WHERE TRIM(TABLE_NAME) = %EXP:cSemaforo% AND OWNER = (SELECT SYS_CONTEXT('USERENV','CURRENT_SCHEMA') FROM DUAL)
ENDSQL
lSemaExt := VLDSTRU->(!eof())
VLDSTRU->(DbCloseArea())

BEGINSQL alias "VLDSTRU"
	SELECT TABLE_NAME FROM ALL_TABLES WHERE TRIM(TABLE_NAME) = %EXP:cDados% AND OWNER = (SELECT SYS_CONTEXT('USERENV','CURRENT_SCHEMA') FROM DUAL)
ENDSQL
lDadoExt := VLDSTRU->(!eof())
VLDSTRU->(DbCloseArea())

ProcRegua(0)
IncProc()

If lSemaExt //MsFile(cSemaforo,nil,"TOPCONN")
	//File(cFileSema)
	//DbUseArea(.T.,__LocalDriver,cFileSema,"GENA82SEMA",.T.,.F.)

    //GENA82SEMA := FWTemporaryTable():New( "GENA82SEMA" )
	//GENA82SEMA:SetFields(aCpSts)
	//GENA82SEMA:AddIndex("1", {"STS_PED"})	

    //------------------
	//Criação da tabela temporaria
	//------------------
	//GENA82SEMA:Create()
	
	DbUseArea(.T.,"TOPCONN",cSemaforo,"GENA82SEMA",.F.,.F.)

	If GENA82SEMA->STS == "5"
		lRet	:= .F.
		GENA82SEMA->(DbCloseArea())
		MsgStop("Periodo já processado, nenhuma ação será realizada! Verifique os parâmetros informados!")
	Else
		cMsgAux += "Foi identificado um processamento em andamento para o periodo informado com os parametros a seguir:"+chr(13)+chr(10)
		cMsgAux += "Dt.inicio: "+DtoC(StoD(GENA82SEMA->DTINI))+chr(13)+chr(10)
		cMsgAux += "Hr.Inicio: "+GENA82SEMA->HRINI+chr(13)+chr(10)
		cMsgAux += "Dt.Fim: "+DtoC(StoD(GENA82SEMA->DTFIM))+chr(13)+chr(10)
		cMsgAux += "Hr.Fim: "+GENA82SEMA->HRFIM+chr(13)+chr(10)
		cMsgAux += "Usuario: "+AllTrim(GENA82SEMA->NAME)+" ("+alltrim(GENA82SEMA->USERPROC)+")"+chr(13)+chr(10)
		cMsgAux += "Planilha de dados: "+AllTrim(GENA82SEMA->FILEPROC)+chr(13)+chr(10)
		cMsgAux += "Valor 10% Rat.Edi.: R$ "+Transform(GENA82SEMA->VLRRAT,"@E 999,999,999.99")+chr(13)+chr(10)
		cMsgAux += "Valor Fat.PageViews: R$ "+Transform(GENA82SEMA->VLRPAG,"@E 999,999,999.99")+chr(13)+chr(10)
		cMsgAux += "Periodo: "+GENA82SEMA->PERIOD+chr(13)+chr(10)
		cMsgAux += "Vencimento: "+DtoC(StoD(GENA82SEMA->VENCTO))+chr(13)+chr(10)
		cMsgAux += "Emissão: "+DtoC(StoD(GENA82SEMA->EMISSA))+chr(13)+chr(10)

		cSolucao := "Após confimar esta tela, será solicitado se deseja continuar com o processamento atual ignorando os dados informados nos parâmetros, lembrando que não poderá ser processada uma nova planilha caso exista um processamento em aberto!"

		xMagHelpFis("Periodo em processamento",cMsgAux,cSolucao)
		lRet := MsgYesNo("Deseja continuar com o processamento em aberto?")
		If !lRet
			GENA82SEMA->(DbCloseArea())
		Else
			/* validando integridade do arquivo de dados */
			If !lDadoExt//MsFile(cDados,nil,"TOPCONN")//File(cDados+cExtAux)
				xMagHelpFis("Periodo em processamento","Identificada inconsistência no controle de semáforo da rotina GENA082, o cabeçalho ("+cSemaforo+".dtc) não está integro em relação aos itens ("+cDados+".dtc).","Solicite a TI que realize a verificação dos dados!")
				Return .F.
			EndIf

			//DbUseArea(.T.,__LocalDriver,cFileDado,"GENA82DADO",.T.,.F.) // abre o alias
		    //GENA82DADO := FWTemporaryTable():New( "GENA82DADO" )
			//GENA82DADO:SetFields(aCpDat)
		
		    //------------------
			//Criação da tabela temporaria
			//------------------
			//GENA82SEMA:Create()
			DbUseArea(.T.,"TOPCONN",cDados,"GENA82DADO",.F.,.F.)
			DbSelectArea("GENA82DADO") // seleciona o alias

			GENA82DADO->( DBClearIndex() )

			If !VldIndice(cDados)
				Return .F.
			EndIf
			
			GENA82DADO->(DBReindex())
			DbSelectArea("GENA82DADO")

			cIdx1		:= xRetIndex("A")//GetNextAlias()+"A"
			cIdx2		:= xRetIndex("B")//GetNextAlias()+"B"

			DbSelectArea("GENA82DADO")
			GENA82DADO->(DBCreateIndex(cIdx1, "LINHA"         , {|| LINHA		}))
			GENA82DADO->(DBCreateIndex(cIdx2, "PEDIDO+LINHA"  , {|| PEDIDO+LINHA	}))

			dbSetIndex(cIdx1)// ("DADOSIDX1", "LINHA"         		, {|| LINHA			})
			dbSetIndex(cIdx2)// ("DADOSIDX2", "PEDIDO+LINHA"        , {|| PEDIDO+LINHA	})

			// 0 ou branco = em processameno; 1 = pedidos gerados com sucesso e processando notas fiscais ; 2 = notas fiscais geradas DA com sucesso; 3 nota fiscal rateio editoras gerada com sucesso ; 4 = nota fiscal faturamento pageviw gerada com sucesso ; 5 = processo finalizado
			If lContinua .AND. Empty(GENA82SEMA->STS) .OR. GENA82SEMA->STS == "0"
				GENA82DADO->(DbGoTop())
				GENA82DADO->(Dbeval( {|x| lContinua := IIF( GENA82DADO->STS_PED $ "0#1#2#" , lContinua , .F. ) } ))
			EndIf

			If lContinua .AND. GENA82SEMA->STS == "1"
				GENA82DADO->(DbGoTop())
				GENA82DADO->(Dbeval( {|x| lContinua := IIF( GENA82DADO->STS_PED $ "1#2#3" , lContinua , .F. ) } ))
			EndIf

			If lContinua .AND. GENA82SEMA->STS $ "2#3#4"
				GENA82DADO->(DbGoTop())
				GENA82DADO->(Dbeval( {|x| lContinua := IIF( GENA82DADO->STS_PED $ "2#3" , lContinua , .F. ) } ))
			EndIf

			If lContinua .AND. GENA82SEMA->STS == "5"
				GENA82DADO->(DbGoTop())
				GENA82DADO->(Dbeval( {|x| lContinua := IIF( GENA82DADO->STS_PED == "3" , lContinua , .F. ) } ))
			EndIf

			If !lContinua
				xMagHelpFis("Periodo em processamento","Identificada inconsistência no controle de semáforo da rotina GENA082, o cabeçalho ("+cSemaforo+".dtc) não está integro em relação aos itens ("+cDados+".dtc).","Solicite a TI que realize a verificação dos dados!")
				Return .F.
			EndIf

			If lRet
				lRet := lContinua
			EndIf

		EndIf
	EndIf
ElseIf lDadoExt//MsFile(cDados,nil,"TOPCONN")//File(cDados+cExtAux)
	xMagHelpFis("Periodo em processamento","Identificada inconsistência no controle de semáforo da rotina GENA082, o cabeçalho ("+cSemaforo+".dtc) não está integro em relação aos itens ("+cDados+".dtc).","Solicite a TI que realize a verificação dos dados!")
	Return .F.
Else
	lCrisStr := .T.
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA082   ºAutor  ³Cleuto Lima         º Data ³  27/11/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa planilha Excel MB com dados de faturamento          º±±
±±º          ³PageView's                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function LerExcel(aParam,nQtdRegOk)

Local nTamCodObra	:= GetMv("GEN_FAT237",.f.,8)
Local cDllExcel		:= GetTempPath()+"readexcel.dll"
Local lDllExcel		:= .f.
Local nHdl 			:= If(lDllExcel,ExecInDLLOpen(cDllExcel),-1)
Local cBuffer		:= ""
Local nBytes		:= 0
Local cPlan			:= ""
Local nLinha		:= 2
Local lContinua		:= .T.
Local xCellAux		:= ""
Local aCpTmp		:= {}
Local aCpDat		:= {}
Local lRet			:= .T.
Local cStsAux		:= ""
Local nRecAux		:= 0

Local nTotPgw		:= 0
Local nTotApu		:= 0
Local nTotReg		:= 0
Local nTErrPgw	:= 0
Local nTErrApu	:= 0
Local nTErrReg	:= 0

Local nTSucPgw	:= 0
Local nTSucApu	:= 0
Local nTSucReg	:= 0

Local aNewISBN	:= {}
Local nLinha	:= 0
Local aLinha	:= {}

Local nRecNoSB1 := 0

Local cObraOrig := ""

If Select("DEPARAB1") > 0
	DEPARAB1->(DbCloseArea())
EndIf
BeginSql Alias "DEPARAB1"
	SELECT DE_ISBN, PARA_ISBN FROM DBA_EGK.GENA082_DE_PARA_MB
EndSql
DEPARAB1->(DbGoTop())
DEPARAB1->(DbeVal({|| Aadd( aNewISBN,{DEPARAB1->DE_ISBN,DEPARAB1->PARA_ISBN} ) }))
DEPARAB1->(DbCloseArea())
/*
Aadd(aNewISBN,{'9788522480702','9788522480708'})
Aadd(aNewISBN,{'9788522488964','9788597007589'})
Aadd(aNewISBN,{'9788522490790','9788597007596'})
Aadd(aNewISBN,{'9788522491063','9788597000382'})
Aadd(aNewISBN,{'9788522491162','9788522485055'})
Aadd(aNewISBN,{'9788522491186','9788597007602'})
Aadd(aNewISBN,{'9788522491414','9788597007794'})
Aadd(aNewISBN,{'9788522491599','9788522470181'})
Aadd(aNewISBN,{'9788522491605','9788522472925'})
Aadd(aNewISBN,{'9788522491759','9788522477579'})
Aadd(aNewISBN,{'9788522492268','9788522490196'})
Aadd(aNewISBN,{'9788522492329','9788597007619'})
Aadd(aNewISBN,{'9788522492381','9788522481965'})
Aadd(aNewISBN,{'9788522493647','9788597007626'})
Aadd(aNewISBN,{'9788522495122','9788597007633'})
Aadd(aNewISBN,{'9788522495597','9788597005417'})
Aadd(aNewISBN,{'9788522496099','9788522475049'})
Aadd(aNewISBN,{'9788522497157','9788597007640'})
Aadd(aNewISBN,{'9788522497195','9788597007657'})
Aadd(aNewISBN,{'9788522497294','9788597007664'})
Aadd(aNewISBN,{'9788522497430','9788597007671'})
Aadd(aNewISBN,{'9788522497492','9788522475438'})
Aadd(aNewISBN,{'9788522497577','9788522484362'})
Aadd(aNewISBN,{'9788522498338','9788597005424'})
Aadd(aNewISBN,{'9788522498390','9788597007688'})
Aadd(aNewISBN,{'9788522498604','9788522490431'})
Aadd(aNewISBN,{'9788522498956','9788522481514'})
Aadd(aNewISBN,{'9788522498970','9788597007800'})
Aadd(aNewISBN,{'9788522499076','9788597007695'})
Aadd(aNewISBN,{'9788522499243','9788597007701'})
Aadd(aNewISBN,{'9788522499403','9788597007718'})
Aadd(aNewISBN,{'9788522499724','9788597007725'})
Aadd(aNewISBN,{'9788522499892','9788597007732'})
Aadd(aNewISBN,{'9788522499915','9788597007749'})
Aadd(aNewISBN,{'9788522499977','9788597007756'})
Aadd(aNewISBN,{'9788527724882','9788521624882'})
Aadd(aNewISBN,{'9788527724905','9788521624905'})
Aadd(aNewISBN,{'9788527724929','9788521624929'})
Aadd(aNewISBN,{'9788527724936','9788521630715'})
Aadd(aNewISBN,{'9788527724950','9788521626121'})
Aadd(aNewISBN,{'9788530938512','9788530970451'})
Aadd(aNewISBN,{'9788530949655','9788530950460'})
Aadd(aNewISBN,{'9788597000344','9788597007770'})
Aadd(aNewISBN,{'9788597001044','9788597007787'})
Aadd(aNewISBN,{'9788597001501','9788522486533'})
Aadd(aNewISBN,{'9788597009798','9788597009798'})
Aadd(aNewISBN,{'9788597013146','9788597013153'})
*/
AADD(aCpDat,{"B1_COD"	,"C"	,TamSX3("B1_COD")[1],0})
AADD(aCpDat,{"B1_DESC"	,"C"	,TamSX3("B1_DESC")[1],0})
AADD(aCpDat,{"VBID"		,"C"	,TamSX3("B1_ISBN")[1],0})
AADD(aCpDat,{"B1_ISBN"	,"C"	,TamSX3("B1_ISBN")[1],0})
AADD(aCpDat,{"C6_QTDVEN"	,"N"	,TamSX3("C6_QTDVEN")[1],TamSX3("C6_QTDVEN")[2]})
AADD(aCpDat,{"C6_VALOR"	,"N"	,TamSX3("C6_VALOR")[1],TamSX3("C6_VALOR")[2]})
AADD(aCpDat,{"C6_PRUNIT"	,"N"	,18,6})
AADD(aCpDat,{"C6_PRCVEN"	,"N"	,18,6})
AADD(aCpDat,{"STATUS"	,"C"	,001,0}) // BRANCO = PENDENTE ; "S" = OK ; "N" NÃO OK ; "A" OK MAS COM ALERTA ; "O" ERRO (Nao tem o que fazer)
AADD(aCpDat,{"LINHA"		,"N"	,010,0})
AADD(aCpDat,{"MSG"		,"C"	,355,0})
AADD(aCpDat,{"TPPUB"		,"C"	,TamSX3("B1_XIDTPPU")[1],0})
AADD(aCpDat,{"SITOBR"	,"C"	,TamSX3("B1_XSITOBR")[1],0})
AADD(aCpDat,{"SITUACAO"	,"C"	,30,0})

ProcRegua(3000)
IncProc("Iniciando leitura do arquivo...")

If Select("TMPEXCEL")
	TMPEXCEL->(DbCloseArea())
EndIf

If lDllExcel
	If nHdl < 0
		Aviso("Falha","Não foi possível carregar a DLL de interface com o Excel (readexcel.dll).",{"Sair"},,"Atenção!")
		Return .F.
	Endif
ENDIF

If lDllExcel
	//Carrega o excel e abre o arquivo
	cBuffer := aParam[P_01]+Space(512)
	nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
	//Valida se abriu a planilha corretamente                                  ?
	If nBytes < 0
		Aviso("Falha","Não foi possível carregar a planilha solicitada!",{"Sair"},,"Atenção!")
		Return .f.
	ElseIf nBytes > 0
		Aviso("Falha","Não foi possível abrir a planilha Excel solicitada ("+Alltrim(aParam[P_01])+"). "+Chr(13)+Chr(10)+"Erro interno: "+Subs(cBuffer, 1, nBytes),{"Sair"},,"Atenção!")
		Return .f.
	EndIf
else
	nHdl 	:= FT_FUSE(aParam[P_01])
	FT_FGOTOP()
	//Valida se abriu a planilha corretamente                                  ?
	If nHdl < 0
		Aviso("Falha","Não foi possível carregar a planilha solicitada!",{"Sair"},,"Atenção!")
	EndIf
EndIf

IF lDllExcel
	//Seleciona a worksheet                                  					 ?
	cPlan		:= "Livros"
	cBuffer		:= Alltrim(cPlan)+Space(512)
	nBytes		:= ExeDLLRun2(nHdl,CMD_ACTIVEWORKSHEET,@cBuffer)

	//Valida se selecionou o worksheet solicitado                              ?
	If nBytes < 0
		Aviso("Falha","Não foi possível selecionar a WorkSheet solicitada ("+Alltrim(cPlan)+") na planilha Excel ("+Alltrim(cFile)+").",{"Sair"},,"Atenção!")
		cBuffer := Space(512)
		ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
		ExecInDLLClose(nHdl)
		Return .f.
	ElseIf nBytes > 0
		//Erro critico na abertura do arquivo com msg de erro						 ?
		Aviso("Falha","Não foi possível selecionar a WorkSheet solicitada ("+Alltrim(cPlan)+") na planilha Excel ("+Alltrim(cFile)+")."+Chr(13)+Chr(10)+"Erro interno: "+Subs(cBuffer, 1, nBytes),{"Sair"},,"Atenção!")
		cBuffer := Space(512)
		ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
		ExecInDLLClose(nHdl)
		Return .f.
	EndIf
else
	If !FT_FEOF()
			
		nLinha++
		cBuffer := Alltrim(FT_FREADLN())
		
		If Empty(cBuffer)
			Aviso("Falha","Não foi possível carregar a planilha solicitada!",{"Sair"},,"Atenção!")
			Return .f.
		EndIF
		
		aLinha  := Separa(cBuffer,";",.T.)
		
		If Len(aLinha) <> LAY_LEN
			Aviso("Falha","Não foi possível carregar a planilha solicitada!",{"Sair"},,"Atenção!")
			Return .f.	
		EndIf
		
		Do Case
			Case !("VBID" $ Upper(AllTrim(aLinha[CELL_VBID])))
				Aviso("Falha","Não foi possível carregar a planilha solicitada, falha na estrutura do arquivo!",{"Sair"},,"Atenção!")
				Return .f.
			Case !("ISBN" $ Upper(AllTrim(aLinha[CELL_ISBN])))
				Aviso("Falha","Não foi possível carregar a planilha solicitada, falha na estrutura do arquivo!",{"Sair"},,"Atenção!")
				Return .f.
			Case !("TOTAL PAGEVIEW" $ Upper(AllTrim(aLinha[CELL_QTDPGW])))
				Aviso("Falha","Não foi possível carregar a planilha solicitada, falha na estrutura do arquivo!",{"Sair"},,"Atenção!")
				Return .f.
			Case !("VALOR PAGEVIEW" $ Upper(AllTrim(aLinha[CELL_VALPGW])))
				Aviso("Falha","Não foi possível carregar a planilha solicitada, falha na estrutura do arquivo!",{"Sair"},,"Atenção!")
				Return .f.
		EndCase

		FT_FSKIP()

	EndIf
EndIf

//cFlTmp	:=	CriaTrab(aCpDat) // cria tabela temporaia em Ctree
//DbUseArea(.T.,__LocalDriver,cFlTmp,"TMPEXCEL",.T.,.F.) // abre o alias
//DbSelectArea("TMPEXCEL") // seleciona o alias

TMPEXCEL := FWTemporaryTable():New( "TMPEXCEL" )
TMPEXCEL:SetFields(aCpDat)
TMPEXCEL:AddIndex("1", {"STATUS","LINHA"})
TMPEXCEL:AddIndex("2", {"LINHA"})
//------------------
//Criação da tabela temporaria
//------------------
TMPEXCEL:Create()

nLinha		:= 2
lContinua	:= .T.

SB5->(DbSetOrder(1))
TMPEXCEL->(DbSetOrder(2))

While lContinua

	nLinha++
	cBuffer := Alltrim(FT_FREADLN())
	aLinha  := Separa(cBuffer,";",.T.)

	IncProc("Lendo linha ..."+StrZero(nLinha,5))

	cVBid	:= AllTrim(RelVatCell(nLinha,CELL_VBID,"B1_ISBN",nHdl,lDllExcel,aLinha))
	cIsbn	:= AllTrim(RelVatCell(nLinha,CELL_ISBN,"B1_ISBN",nHdl,lDllExcel,aLinha))
	nQtdPgw	:= RelVatCell(nLinha,CELL_QTDPGW,"C6_QTDVEN",nHdl,lDllExcel,aLinha)
	nValPgw	:= RelVatCell(nLinha,CELL_VALPGW,"C6_PRUNIT",nHdl,lDllExcel,aLinha)

	If aScan(aNewISBN,{|x| AllTrim(x[1]) == AllTrim(cVBid) }) > 0
		cVBid	:= aNewISBN[aScan(aNewISBN,{|x| AllTrim(x[1]) == AllTrim(cVBid) })][2]
	ElseIf aScan(aNewISBN,{|x| AllTrim(x[1]) == AllTrim(cIsbn) }) > 0
		cVBid	:= aNewISBN[aScan(aNewISBN,{|x| AllTrim(x[1]) == AllTrim(cIsbn) })][2]
	EndIf

	If Empty(cVBid)
		lContinua := .F.
	EndIf

	If Len(aLinha) <> LAY_LEN
		Aviso("Falha","Não foi possível carregar a planilha solicitada, falha na estrutura do arquivo na linha "+StrZero(nLinha,5)+"!",{"Sair"},,"Atenção!")
		Return .f.	
	EndIf

	If lContinua
		RecLock("TMPEXCEL",.T.)
		TMPEXCEL->STATUS	:= ""
		TMPEXCEL->VBID		:= cVBid
		TMPEXCEL->B1_ISBN	:= cIsbn
		TMPEXCEL->C6_QTDVEN	:= nQtdPgw
		TMPEXCEL->C6_VALOR	:= nValPgw
		TMPEXCEL->C6_PRUNIT	:= (nValPgw/aParam[P_06])
		TMPEXCEL->C6_PRCVEN	:= 0
		TMPEXCEL->LINHA		:= nLinha
		TMPEXCEL->MSG		:= ""
		MsUnLock()
	EndIf
	
	FT_FSKIP()
	IF FT_FEOF()
		lContinua := .F.
	EndIf

EndDo

ProcRegua(nLinha)

If lDllExcel
	//Fecha a interface com o excel
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
Else
	FT_FUSE(aParam[P_01])
endIf	

IncProc("Validando dados...")

DbSelectArea("TMPEXCEL")
TMPEXCEL->(DbSetOrder(2))
TMPEXCEL->(DbGoTop())

If TMPEXCEL->(EOF()) .OR. EMpty(TMPEXCEL->B1_ISBN)
	MsgStop("Não foi possível ler nenhum dado da planilha!")
	Return .F.
Else
	SB1->(DbOrderNickName("GENISBN"))
	While TMPEXCEL->(!EOF())
		nTotReg++
		nTotApu		+= (TMPEXCEL->C6_VALOR/aParam[P_06])
		nTotPgw		+= TMPEXCEL->C6_VALOR

		cStsAux	:= "S"
		IncProc("Validando linha ..."+StrZero(TMPEXCEL->LINHA,5))

		If !SB1->(DbSeek( xFilial("SB1")+TMPEXCEL->VBID ))
			If !SB1->(DbSeek( xFilial("SB1")+TMPEXCEL->B1_ISBN ))
				SB1->(DbSetOrder(1))

				If !SB1->(DbSeek( xFilial("SB1")+StrZero(val(TMPEXCEL->VBID),nTamCodObra) ))
					If !SB1->(DbSeek( xFilial("SB1")+StrZero(val(TMPEXCEL->B1_ISBN),nTamCodObra)  ))
						nTErrReg++
						nTErrPgw	+= TMPEXCEL->C6_VALOR
						nTErrApu	+= (TMPEXCEL->C6_VALOR/aParam[P_06])

						cStsAux	:= "E"
						RecLock("TMPEXCEL",.F.)
						TMPEXCEL->STATUS		:= "E"
						TMPEXCEL->MSG			:= "Não localizado produto SB1!"
						MsUnLock()
						TMPEXCEL->(DbSkip())
						SB1->(DbOrderNickName("GENISBN"))
						Loop
					EndIf
				EndIF

				nRecAux	:= SB1->(Recno())
				SB1->(DbOrderNickName("GENISBN"))
				SB1->(DbGoto(nRecAux))
			EndIf
		EndIf

		cObraOrig := AllTrim(SB1->B1_COD)

		If AllTrim(SB1->B1_XIDTPPU) <> "15" .OR. ALLTRIM(SB1->B1_XSITOBR) == "103"
			If Select("TMPMBSB1") > 0
				TMPMBSB1->(DbCloseArea())
			EndIf

			BeginSql Alias "TMPMBSB1"
				SELECT SB1.R_E_C_N_O_ RECSB1,B5_XDTPUBL,B1_XIDMAE,Z4_DESC,B1_XSITOBR,X5_DESCRI,B1_XIDTPPU,B1_COD FROM %Table:SB1% SB1
				JOIN %Table:SX5% SX5
				ON X5_FILIAL = %xFilial:SX5%
				AND X5_TABELA = 'Z4'
				AND TRIM(X5_CHAVE) = TRIM(B1_XIDTPPU)
				AND SX5.%NotDel%
				JOIN %Table:SZ4% SZ4
				ON Z4_FILIAL = %xFilial:SZ4%
				AND trim(Z4_COD) = trim(SB1.B1_XSITOBR)
				AND SZ4.%NotDel%
				JOIN %Table:SB5% SB5
				ON B5_FILIAL = B1_FILIAL
				AND B5_COD = B1_COD
				AND SB5.%NotDel%
				WHERE B1_FILIAL = %xFilial:SB1%
				AND SB1.%NotDel%
				AND B1_MSBLQL <> '1'
				AND Trim(B1_XIDTPPU) = '15'
				AND B1_XIDMAE = %Exp:SB1->B1_XIDMAE%
				AND TRIM(B1_XSITOBR) <> '103'
				ORDER BY B5_XDTPUBL DESC,B1_COD DESC
			EndSql

			TMPMBSB1->(DbGotop())
			If TMPMBSB1->(EOF())
				nTErrReg++
				nTErrPgw	+= TMPEXCEL->C6_VALOR
				nTErrApu	+= (TMPEXCEL->C6_VALOR/aParam[P_06])
				cStsAux	:= "N"
				RecLock("TMPEXCEL",.F.)
				TMPEXCEL->STATUS	:= "N"
				TMPEXCEL->MSG		:= "A obra informada na planilha não é MB ou está cancelada, e não foi possível indetificar uma obra tipo MB através do ID Obra Mãe!"
				TMPEXCEL->SITUACAO	:= Posicione("SZ4",1,xFilial("SZ4")+SB1->B1_XSITOBR,"Z4_DESC")
				MsUnLock()
				TMPMBSB1->(DbCloseArea())
				TMPEXCEL->(DbSkip())
				Loop
			Else
				SB1->(DbGoto(TMPMBSB1->RECSB1))
				//-------------------------------------------------------------ini
				nRecNoSB1 := PesqHist(SB1->B1_COD)
				If nRecNoSB1 > 0
					SB1->(DbGoto(nRecNoSB1))
					TMPEXCEL->MSG		:= "A obra "+cObraOrig+" informada na planilha não é do tipo MB e não é de uma edição atual, a mesma será substituida pela Obra "+AllTrim(SB1->B1_COD)+"( "+AllTrim(SB1->B1_DESC)+" ) ISBN: "+AllTrim(SB1->B1_ISBN)
				Else
					TMPEXCEL->MSG := "A obra "+cObraOrig+" informada na planilha não é do tipo MB, a mesma será substituida pela Obra "+AllTrim(SB1->B1_COD)+"( "+AllTrim(SB1->B1_DESC)+" ) ISBN: "+AllTrim(SB1->B1_ISBN)
				EndIf
				//-------------------------------------------------------------fim
				RecLock("TMPEXCEL",.F.)
				TMPEXCEL->SITUACAO	:= Posicione("SZ4",1,xFilial("SZ4")+SB1->B1_XSITOBR,"Z4_DESC")
				MsUnLock()
				cStsAux				:= "A"
			EndIf
			SB1->(DbGoto(TMPMBSB1->RECSB1))
			TMPMBSB1->(DbCloseArea())
		Else
			//-------------------------------------------------------------ini
			nRecNoSB1 := PesqHist(SB1->B1_COD)
			If nRecNoSB1 > 0
				SB1->(DbGoto(nRecNoSB1))
				RecLock("TMPEXCEL",.F.)
				TMPEXCEL->MSG		:= "A obra "+cObraOrig+" informada na planilha não é referente a uma edição atual e será substituída pela Obra "+AllTrim(SB1->B1_COD)+"( "+AllTrim(SB1->B1_DESC)+" ) ISBN: "+AllTrim(SB1->B1_ISBN)
				TMPEXCEL->SITUACAO	:= Posicione("SZ4",1,xFilial("SZ4")+SB1->B1_XSITOBR,"Z4_DESC")
				MsUnLock()
				cStsAux				:= "A"
			EndIf
			//-------------------------------------------------------------fim
			If SB1->B1_MSBLQL == '1'
				nTErrReg++
				nTErrPgw	+= TMPEXCEL->C6_VALOR
				nTErrApu	+= (TMPEXCEL->C6_VALOR/aParam[P_06])
				cStsAux	:= "N"
				RecLock("TMPEXCEL",.F.)
				TMPEXCEL->STATUS		:= "N"
				TMPEXCEL->MSG			:= "A obra informada está bloqueada para uso!"
				TMPEXCEL->SITUACAO	:= Posicione("SZ4",1,xFilial("SZ4")+B1_XSITOBR,"Z4_DESC")
				MsUnLock()
				TMPEXCEL->(DbSkip())
				Loop
			EndIf
		EndIf
		/*
			SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))
			If Empty(SB5->B5_XDTPUBL)
				nTErrReg++
				nTErrPgw	+= TMPEXCEL->C6_VALOR
				nTErrApu	+= (TMPEXCEL->C6_VALOR/aParam[P_06])
				cStsAux	:= "N"
				RecLock("TMPEXCEL",.F.)
				TMPEXCEL->STATUS		:= "N"
				TMPEXCEL->MSG			:= "A obra informada não tem data de publicação!"
				MsUnLock()
				TMPEXCEL->(DbSkip())
				Loop
			EndIf

		*/
		//SB1->(DbGoto(TMPMBSB1->RECSB1))
		RecLock("TMPEXCEL",.F.)
		TMPEXCEL->STATUS	:= cStsAux
		TMPEXCEL->B1_COD	:= SB1->B1_COD
		TMPEXCEL->B1_DESC	:= SB1->B1_DESC
		TMPEXCEL->C6_PRCVEN	:= Round( (TMPEXCEL->C6_VALOR/aParam[P_06])/TMPEXCEL->C6_QTDVEN , 6 )
		TMPEXCEL->B1_DESC	:= SB1->B1_DESC
		TMPEXCEL->TPPUB		:= SB1->B1_XIDTPPU
		TMPEXCEL->SITOBR	:= SB1->B1_XSITOBR
		TMPEXCEL->SITUACAO	:= Posicione("SZ4",1,xFilial("SZ4")+SB1->B1_XSITOBR,"Z4_DESC")
		MsUnLock()

		nTSucReg++
		nTSucApu		+= (TMPEXCEL->C6_VALOR/aParam[P_06])
		nTSucPgw		+= TMPEXCEL->C6_VALOR

		nRecNoSB1 := 0

		TMPEXCEL->(DbSkip())
	EndDo
EndIf

lRet := MostraDados(aParam,nTotPgw,nTotApu,nTotReg,nTErrPgw,nTErrApu,nTErrReg,nTSucPgw,nTSucApu,@nTSucReg)

If lRet
	nQtdRegOk := nTSucReg
EndIf

Return lRet

Static Function PesqHist(cCodPrd)
Local nRet := 0
Local cCodHis := Posicione("SB5",1,xFilial("SB5")+cCodPrd,"B5_XCODHIS")
Local cSitExc := SuperGetMv("GEN_FAT260",.f.,"'103'") //Sit de Obra que serão desconsideradas na pesquisa por uma obra com edição mais recente na MB. Cancelado/Producao/Pre-Venda

cQuery := "SELECT SB5.B5_XDTPUBL,TO_NUMBER(trim(regexp_replace(SB5.B5_XEDICAO,'[[:punct:]]',''))) EDICAO,SB1.R_E_C_N_O_ RECSB1,SB1.B1_COD "
cQuery += "FROM "+RetSqlName("SB5")+" SB5 "
cQuery += "JOIN "+RetSqlName("SB1")+" SB1 "
cQuery += "ON B1_FILIAL = B5_FILIAL "
cQuery += "AND B1_COD = B5_COD "
//cQuery += "AND B1_COD <> '"+AllTrim(cCodPrd)+"' "
cQuery += "AND SB1.D_E_L_E_T_ <> '*' "
cQuery += "WHERE B5_FILIAL = ' ' "
cQuery += "AND SB5.D_E_L_E_T_ = ' ' "
cQuery += "AND B5_XCODHIS = '"+cCodHis+"' "
cQuery += "AND SB1.B1_XIDTPPU = '15' "
cQuery += "AND SB1.B1_MSBLQL <> '1' "
cQuery += "AND SB1.B1_XSITOBR NOT IN ("+cSitExc+") "
cQuery += "AND trim(regexp_replace(SB5.B5_XEDICAO,'[[:punct:]]','')) <> ' ' "
cQuery += "AND B5_XDTPUBL <> ' ' "
cQuery += "ORDER BY 1 DESC "

If Select("TRB") > 0
	dbSelectArea("TRB")
	TRB->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery),"TRB", .F., .T.)

DbSelectArea("TRB")

If TRB->(!EOF())
	If Alltrim(TRB->B1_COD) <> AllTrim(cCodPrd)
		nRet := TRB->RECSB1
	EndIf
EndIf

Return nRet

Static Function MostraDados(aParam,nTotPgw,nTotApu,nTotReg,nTErrPgw,nTErrApu,nTErrReg,nTSucPgw,nTSucApu,nTSucReg)

Local oDlgDIRF	:= Nil
Local oFont		:= Nil
Local oTFont 		:= TFont():New('Courier new',,-18,.T.)
Local oVerde		:= LoaDBitmap( GetResources(), "BR_VERDE" )
Local oVerme		:= LoaDBitmap( GetResources(), "BR_VERMELHO" )
Local oAmare		:= LoaDBitmap( GetResources(), "BR_AMARELO" )
Local oCinza		:= LoaDBitmap( GetResources(), "BR_CINZA" )
Local lRet 		:= .F.
Local bConfirm	:= {|| oDlgDIRF:End(),lRet := .T. }
Local bCancel		:= {|| oDlgDIRF:End(),lRet := .F. }
Local aButtons	:= {}
Local aItensCB  := {"ISBN","COD.PROTHEUS","VBID"}

Private cPesq   := SPACE(20) 

DbSelectArea("TMPEXCEL")
TMPEXCEL->(DbSetOrder(1))
TMPEXCEL->(DbGoTop())
//cIdxTmp  := CriaTrab(nil,.F.)
//IndRegua("TMPEXCEL",cIdxTmp,"STATUS+StrZero(LINHA,5)","C")
//DbSetIndex(cIdxTmp+OrdBagExt())


	DEFINE MSDIALOG oDlgDIRF TITLE "ARQUIVO EXCEL" From 10,10 To 600,1280 pixel Style 128

	oDlgDIRF:lMaximized := .F.
	oDlgDIRF:SetColor(CLR_BLACK,CLR_WHITE)
	oDlgDIRF:SetFont(oFont)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Armazena as corrdenadas da tela                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nMbrWidth	:= oDlgDIRF:nWidth/2-43
	nMbrHeight	:= oDlgDIRF:nHeight/2

	@00,00 MSPANEL oMain PROMPT "" SIZE nMbrWidth,nMbrHeight of oDlgDIRF
	oMain:Align	:= CONTROL_ALIGN_ALLCLIENT

	@00,00 MSPANEL oMainTop PROMPT "" SIZE nMbrWidth,60/*nMbrHeight*0.10*/  of oMain
	oMainTop:Align	:= CONTROL_ALIGN_TOP
	oGrpFilt		:= TGroup():New(05,05,(oMainTop:NCLIENTHEIGHT/2),(oMainTop:NCLIENTWIDTH/2)-10,"",oMainTop,CLR_RED,,.T.)

	//cTitAux	:= '<p style="margin:-20px" align="Left"><font size="5" color="black">Valor Total de PageView'+Transform(nTotPgw,"@E 999,999,999.99")+'</font></p>'
	cTitAux	:= '<p style="margin:10px" align="Left"><font face="MS LineDraw New" size="5" color="black">Valores da Planilha.: Vlr.PageView R$ '+Transform(nTotPgw,"@E 999,999,999.99")+'</font>'
	cTitAux	+= '<font face="MS LineDraw New" size="5" color="black"> | Apuração R$ '+Transform(nTotApu,"@E 999,999,999.99")+'</font>'
	cTitAux	+= '<font face="MS LineDraw New" size="5" color="black"> | Qtd.Registros '+Transform(nTotReg,"9999999999")+'</font></p>'

	cTitAux	+= '<p style="margin:10px" align="Left"><font face="MS LineDraw New" size="5" color="black">Imp.Com sucesso.....:		Vlr.PageView R$ '+Transform(nTSucPgw,"@E 999,999,999.99")+'</font>'
	cTitAux	+= '<font face="MS LineDraw New" size="5" color="black"> | Apuração R$ '+Transform(nTSucApu,"@E 999,999,999.99")+'</font>'
	cTitAux	+= '<font face="MS LineDraw New" size="5" color="black"> | Qtd.Registros '+Transform(nTSucReg,"9999999999")+'</font></p>'

	cTitAux	+= '<p style="margin:10px" align="Left"><font face="MS LineDraw New" size="5" color="black">Não Imp. Erro.......:		Vlr.PageView R$ '+Transform(nTErrPgw,"@E 999,999,999.99")+'</font>'
	cTitAux	+= '<font face="MS LineDraw New" size="5" color="black"> | Apuração R$ '+Transform(nTErrApu,"@E 999,999,999.99")+'</font>'
	cTitAux	+= '<font face="MS LineDraw New" size="5" color="black"> | Qtd.Registros '+Transform(nTErrReg,"9999999999")+'</font></p>'

	oInfo	:= TSay():New(10,20,{|| cTitAux },oMainTop,,oFont,,,,.T.,CLR_RED,CLR_WHITE,(oMainTop:NCLIENTWIDTH/2),44,,,,,,.T.)
	//oInfo:SetCss("QLabel{ margin: -20px }")

	@00,00 MSPANEL oMainPesq PROMPT "" SIZE nMbrWidth,20 of oMain
	oMainPesq:Align := CONTROL_ALIGN_TOP

	@ 008,005 SAY oSay1 PROMPT "Pesquisa por:" SIZE 120,20 OF oMainPesq PIXEL

	cCombo := aItensCB[1]
    oCombo := TComboBox():New(005,045,{|u|if(PCount()>0,cCombo:=u,cCombo)},aItensCB,070,013,oMainPesq,,{|| },,,,.T.,,,,,,,,,)

	@ 005,125 MSGET cPesq SIZE 80,10 OF oMainPesq PIXEL

	TButton():New(005,215,"Pesquisar",oMainPesq,{|| PesqCB(oCombo:nAT)},50,12,,,,.T.) 

	@ 008,370 SAY oSay2 PROMPT "Ir para:" SIZE 120,20 OF oMainPesq PIXEL

	oButVerde := TButton():New(006,400,"Ok",oMainPesq,{|x| IrPara("S") },50,10,,,,.T.)
	oButVerde:SetCss("QPushButton{background-color:rgb(144,217,74);}" )

	oButAmarelo := TButton():New(006,460,"Alerta",oMainPesq,{|x| IrPara("A") },50,10,,,,.T.)
	oButAmarelo:SetCss("QPushButton{background-color:rgb(231,232,64);}" )

	oButVermelho := TButton():New(006,520,"Não Ok",oMainPesq,{|x| IrPara("N") },50,10,,,,.T.)
	oButVermelho:SetCss("QPushButton{background-color:rgb(200,61,67);}" )

	oButCinza := TButton():New(006,580,"Erro",oMainPesq,{|x| IrPara("E") },50,10,,,,.T.)
	oButCinza:SetCss("QPushButton{background-color:rgb(150,150,150);}" )

	@00,00 MSPANEL oMainCentro PROMPT "" SIZE nMbrWidth,nMbrHeight of oMain
	oMainCentro:Align := CONTROL_ALIGN_ALLCLIENT

	oGrpXML	:= TGroup():New(05,05,(oMainCentro:NCLIENTHEIGHT/2)-40,(oMainCentro:NCLIENTWIDTH/2)-10,"",oMainCentro,CLR_RED,,.T.)
	aHList	:= {}

	oListBox := TWBrowse():New(15,10,(oMainCentro:NCLIENTWIDTH/2)-30,(oMainCentro:NCLIENTHEIGHT/2)-60,,aHList,,oMainCentro,,,,,,,,,,,,, "TMPEXCEL", .T. )

	oListBox:AddColumn(TCColumn():New(" "					,{|| IIF( TMPEXCEL->STATUS == "S", oVerde , IIF( TMPEXCEL->STATUS == "N" , oVerme , IIF( TMPEXCEL->STATUS == "A" , oAmare , oCinza ) ) )	},,,,'CENTER'		,15,.T.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("COD.PROTHEUS ORIG"   ,{|| TMPEXCEL->B1_COD		},,,,'LEFT'		,045,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("DESCRICAO ORIG"  	,{|| TMPEXCEL->B1_DESC		},,,,'LEFT'		,100,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("VBID ORIG"			,{|| TMPEXCEL->VBID 			},,,,'LEFT'		,050,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("ISBN ORIG"			,{|| TMPEXCEL->B1_ISBN  		},,,,'LEFT'		,050,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("QTD.PAGEVIEW"		,{|| TMPEXCEL->C6_QTDVEN  	},,,,'RIGHT'		,045,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("VLR.PAGEVIEW"		,{|| TMPEXCEL->C6_VALOR  	},,,,'RIGHT'		,045,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("% APURAÇÃO"		,{|| aParam[P_06]			  	},,,,'RIGHT'		,045,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("VLR.UNI.APURADO"	,{|| TMPEXCEL->C6_PRCVEN  	},,,,'RIGHT'		,060,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("SIT.OBRA"			,{|| TMPEXCEL->SITUACAO  	},,,,'LEFT'		,060,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("EXCEL LINHA"		,{|| TMPEXCEL->LINHA  		},,,,'RIGHT'		,045,.F.,.F.,,,,.F.,))
	oListBox:AddColumn(TCColumn():New("OBSERVAÇÃO"		,{|| TMPEXCEL->MSG  			},,,,'LEFT'		,800,.F.,.F.,,,,.F.,))

	TMPEXCEL->(DbGoTop())

	oListBox:bLDblClick := {|| IIF( AlterISBN(@nTSucReg,aParam) , (TMPEXCEL->(DbGoTop()),oListBox:DrawSelect(),oListBox:Refresh()) , nil )}

	AADD(aButtons, {"cargaseq",	{|| ExportGrid("TMPEXCEL",aParam) }, "Exportar Excel"})

	ACTIVATE MSDIALOG oDlgDIRF On Init EnchoiceBar(oDlgDIRF,bConfirm,bCancel,,aButtons) Centered

	If !lRet
		MsgStop("Processo cancelado pelo usuario, nenhum dado armazenado!")
	EndIf

DbSelectArea("TMPEXCEL")
TMPEXCEL->(DbSetOrder(2))
//DbClearIndex()
//FErase(cIdxTmp+OrdBagExt())

Return lRet

Static Function PesqCB(nOpc)
Local lRet := .F.

If !Empty(Alltrim(cPesq))
	TMPEXCEL->(DbGoTop())

	While TMPEXCEL->(!EOF())
		Do Case
			Case nOpc = 1 //ISBN
				If Upper(Alltrim(TMPEXCEL->B1_ISBN)) == Upper(Alltrim(cPesq))
					lRet := .T.
					Exit
				EndIf
			Case nOpc = 2 //COD.PROTHEUS
				If Upper(Alltrim(TMPEXCEL->B1_COD)) == Upper(Alltrim(cPesq))
					lRet := .T.
					Exit
				EndIf
			Case nOpc = 3 //VBID
				If Upper(Alltrim(TMPEXCEL->VBID)) == Upper(Alltrim(cPesq))
					lRet := .T.
					Exit
				EndIf
			OtherWise
				Exit
		EndCase
		TMPEXCEL->(DbSkip())
	EndDo

	If !lRet
		MsgAlert("Pesquisa não encontrada!","Atenção!")
	EndIf
EndIf

Return

Static function IrPara(cStatus)
Local aArea := GetArea()
Local lRet := .F.

TMPEXCEL->(DbSetOrder(1))
TMPEXCEL->(DbGoTop())
If TMPEXCEL->(DbSeek(cStatus))
	lRet := .T.
EndIf

If !lRet
	RestArea(aArea)
	MsgAlert("Não há registros com o status selecionado!","Atenção!")
EndIf

Return

Static Function AlterISBN(nTSucReg,aParam)

Local lRet	:= .F.

If !(AllTrim(TMPEXCEL->STATUS) $ "N|E")
	Return .F.
EndIf

lRet := ConPad1(,,,"SB1")

If lRet
	Do Case
		Case AllTrim(SB1->B1_XIDTPPU) <> "15"
			MsgStop("Obra não é do tipo MB!")
			lRet := .F.
		Case AllTrim(SB1->B1_XSITOBR) == "103"
			MsgStop("Obra cancelada!")
			lRet := .F.
		Case !SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))
			MsgStop("Não localizado complemento do produto (SB5)!")
			lRet := .F.
			/*
		Case Empty(SB5->B5_XDTPUBL)
			MsgStop("A obra informada não tem data de publicação!")
			lRet := .F.
		Case SB1->B1_MSBLQL == '1'
		*/
			MsgStop("A obra informada está bloqueada para uso!")
			lRet := .F.
		OtherWise
			lRet := MsgYesNo("Confirma a alteração do ISBN "+AllTrim(TMPEXCEL->B1_ISBN)+" para "+AllTrim(SB1->B1_COD)+" ("+AllTrim(SB1->B1_ISBN)+") ?" )
		EndCase
		If lRet
			Reclock("TMPEXCEL",.F.)
			TMPEXCEL->MSG			:= "Alterado manualmente do ISBN "+AllTrim(TMPEXCEL->B1_ISBN)+" para "+AllTrim(SB1->B1_COD)+" ("+AllTrim(SB1->B1_ISBN)+")"
			TMPEXCEL->STATUS		:= "A"
			TMPEXCEL->B1_COD		:= SB1->B1_COD
			TMPEXCEL->B1_DESC		:= SB1->B1_DESC
			TMPEXCEL->TPPUB		:= SB1->B1_XIDTPPU
			TMPEXCEL->SITOBR		:= SB1->B1_XSITOBR
			TMPEXCEL->C6_PRCVEN	:= Round( (TMPEXCEL->C6_VALOR/aParam[P_06])/TMPEXCEL->C6_QTDVEN , 6 )
			MsUnLock()
			nTSucReg++
		EndIf
EndIf

Return lRet

Static Function RelVatCell(nLinha,cCellAux,cCampo,nHdl,lDllExcel,aLinha)

Local xCell	:= nil
Local cCell	:= ""
Local cTipo	:= TamSX3(cCampo)[3]
Local cBuffer	:= ""

If lDllExcel
	cCell		:= cCellAux+AllTrim(Str(nLinha))
	cBuffer		:= cCell+Space(1024)
	nBytes		:= ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
	xCell		:= AllTrim(Subs(cBuffer, 1, nBytes))
else
	xCell		:= AllTrim(aLinha[cCellAux])
ENDIF

Do Case
	Case cTipo == "N"
		xCell := Val(StrTran(StrTran(StrTran(xCell,".",""),",","."),"R$",""))
	Case cTipo == "D"
		xCell := CtoD(xCell)
	Case cTipo == "L"
		xCell := IIF( "S" $ xCell .OR. "T" $ xCell , .T. , .F. )
EndCase

Return xCell

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA082   ºAutor  ³Cleuto Lima         º Data ³  27/11/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa planilha Excel MB com dados de faturamento          º±±
±±º          ³PageView's                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function CpDllXls()

Local cTemp	:= GetTempPath()

If !File(cTemp+"ReadExcel.dll")
	If File("ReadExcel.dll")
		COPY FILE ("ReadExcel.dll") TO (cTemp+"\ReadExcel.dll")
		If !File(cTemp+"\ReadExcel.dll")
			Aviso("Falha","Não foi possível copiar a DLL de leitura da planilha excel para o diretóio "+cTemp+".",{"Sair"},,"Atenção!")
			lReturn := .F.
		Endif
	Else
		Aviso("Falha","Não foi possível copiar a DLL de leitura da planilha excel para o diretóio "+cTemp+".",{"Sair"},,"Atenção!")
	Endif
Endif

Return .T.


User Function GENA082P(aCabec,aItens,cCliente,cloja)

Local aRet		:= {.F.,"",""}
Local aErro	:= {}
Local cErroLg	:= ""
Local _ni		:= 0

Conout("GENA082 - Iniciando geração pedido DA. "+Time())

DbSelectArea("SC5")
DbSelectArea("SC6")
DbSelectArea("SB1")
DbSelectArea("SA1")

SA1->(DbsetOrder(1))
SA1->(Dbseek(xFilial("SA1")+cCliente,cloja))

lMsErroAuto	:= .F.

MSExecAuto({|x,y,z| mata410(x,y,z)},aCabec,aItens,3)

If !lMsErroAuto
	aRet	:= {.F.,"",SC5->C5_NUM}
Else
	cErroLg	:= ""
	aErro 		:= GetAutoGRLog()
	If Len(aErro) == 0
		cErroLg += MostraErro("\system\", "GENA082.log" )
	Else
		For _ni := 1 To Len(aErro)
			cErroLg += aErro[_ni] + Chr(13)+Chr(10)
		Next _ni
	EndIf
	aRet	:= {lMsErroAuto,cErroLg,""}
EndIf

Conout("GENA082 - Finalizando geração pedido DA. "+Time())

Return aRet


Static Function PedToNF(cNumPed,cFilPed,cSerie)

Local aRet		:= {.F.,"",""}
Local oServer	:= nil
Local cServ		:= GetMv("GEN_FAT234",.f.,"10.3.0.72")
Local nPort  	:= GetMv("GEN_FAT235",.f.,1266)
Local cAmb		:= GetMv("GEN_FAT236",.f.,"SCHEDULE")

Conout("GENA082 - Iniciando geração nota. "+Time())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realizando a nova conexão para entrar na empresa e filial correta³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ValType(oServer) == "O"
	//Fecha a Conexao com o Servidor
	RESET ENVIRONMENT IN SERVER oServer
	CLOSE RPCCONN oServer
	FreeObj(oServer)
	oServer := Nil
EndIf

CREATE RPCCONN oServer ON  SERVER cServ 			;   //IP do servidor
PORT  nPort           								;   //Porta de conexão do servidor
ENVIRONMENT cAmb       							;   //Ambiente do servidor
EMPRESA cEmpAnt          							;   //Empresa de conexão
FILIAL  cFilPed         							;   //Filial de conexão
TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que serão abertas
MODULO  "SIGAFAT"               					//Módulo de conexão

//MSExecAuto({|x,y,z| mata410(x,y,z)},aCabec,aItens,3)

If ValType(oServer) == "O"
	oServer:CallProc("RPCSetType", 2)
	aRet := {}
	aRet := oServer:CallProc("U_GENA082N",cNumPed,cSerie )

	If ValType(aRet) <> "A"
		aRet	:= {.T.,"Erro ao tentar conectar no Protheus para emissão do pedido!",{}}
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Realizando a nova conexão para entrar na empresa e filial correta³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Fecha a Conexao com o Servidor
	RESET ENVIRONMENT IN SERVER oServer
	CLOSE RPCCONN oServer
	FreeObj(oServer)
	oServer := Nil

	If aRet[1]
		cErroLg	:= aRet[3]
		cSolucao	:= "O processo será finalizado, tente executar o processo novamente, o Protheus vai sinalizar que já existe um processo em andamento, aceite que sejá continuado este processo!"+chr(13)+chr(10)+;
		"Caso o problema persista, contate a TI!"
		xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
	EndIf

Else
	cErroLg	:= "Erro ao tentar conectar no Protheus para emissão das notas fiscais!"+chr(13)+chr(10)
	cSolucao	:= "O processo será finalizado, tente executar o processo novamente, o Protheus vai sinalizar que já existe um processo em andamento, aceite que sejá continuado este processo!"+chr(13)+chr(10)+;
	"Caso o problema persista, contate a TI!"
	xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
	aRet := {.F.,"",""}
EndIf

Conout("GENA082 - finalizando geração nota. "+Time())

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA082   ºAutor  ³Cleuto Lima         º Data ³  27/11/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa planilha Excel MB com dados de faturamento          º±±
±±º          ³PageView's                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA082N(cNumPed,cSerie)

Local aRet			:= {.T.,"",""}
Local lContinua	:= .T.
Local cNota		:= ""

Conout("GENA082 - iniciando geração pedido. "+Time())

SC5->(DbSetOrder(1))
If !SC5->(DbSeek( xFilial("SC5")+cNumPed ))
	aRet		:= {.T.,"","Pedido "+cNumPed+" não localizado!"}
	lContinua	:= .F.
Else
	DDataBase := SC5->C5_EMISSAO
	If !Empty(SC5->C5_BLQ)
		MaAvalSC5("SC5",9)//Ft210Proc()
		SC5->(DbSeek( xFilial("SC5")+cNumPed ))
		If !Empty(SC5->C5_BLQ)
			aRet		:= {.T.,"","Pedido "+cNumPed+" não foi possível liberar o pedido, o mesmo está com bloqueio de regra!"}
			lContinua	:= .F.
		EndIf
	EndIf

	If lContinua
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
		//³Rotina para desbloquear crédito para que o pedido seja faturado sem problemas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
		//Posiciona na SC9 para confirmar que o pedido foi gravado na tabela
		DbSelectArea("SC9")
		DbSetOrder(1)
		//Posiciona na SC9 para confirmar que o pedido foi gravado na tabela
		If !DbSeek(xFilial("SC9") + SC5->C5_NUM)
			SC6->(DbSetOrder(1))
			SC6->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
			While SC6->(!EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
				If !SC9->(dbseek( SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM ))
					RecLock("SC6",.F.)
					SC6->C6_QTDLIB := MaLibDoFat(SC6->(Recno()),SC6->C6_QTDVEN,.T.,.T.,.F.,.T.,.F.)
					SC6->(msUnlock())
				EndIf
				SC6->(DbSkip())
			EndDo
		EndIf

		If Select("TMPSC9") > 0
			TMPSC9->(DbCloseArea())
		EndIf

		Beginsql Alias "TMPSC9"
			SELECT * FROM %Table:SC6% SC6
			WHERE C6_FILIAL = %Exp:SC5->C5_FILIAL%
			AND C6_NUM = %Exp:SC5->C5_NUM%
			AND SC6.%NotDel%
			AND C6_QTDVEN <> (
			  SELECT SUM(C9_QTDLIB) FROM %Table:SC9% SC9
			  WHERE C9_FILIAL = C6_FILIAL
			  AND C9_PEDIDO = C6_NUM
			  AND C9_PRODUTO = C6_PRODUTO
			  AND C9_ITEM = C6_ITEM
			  AND SC9.C9_BLEST IN('  ','10')
			  AND SC9.C9_BLCRED IN('  ','09','10')
			  AND SC9.%NotDel%
			)
		EndSql

		TMPSC9->(DbGoTop())
		If TMPSC9->(!EOF())
			lContinua	:= .F.
			aRet[1] := .T.
			aRet[2] := ""
			aRet[3] := "Pedido:"+SC5->C5_NUM+",Detectada inconsistência na liberação do pedido, a quantidade liberada está diferente da quantidade do pedido, libere o pedido e execute o processo novmanete!"
		EndIf
		TMPSC9->(DbCloseArea())
		If lContinua
			SC9->(dbsetOrder(1))
			SC9->(dbSeek(SC5->C5_FILIAL+SC5->C5_NUM ))
			aPvlNfs	:= {}
			While SC9->(!EOF()) .and. SC9->(C9_FILIAL+C9_PEDIDO) == SC5->C5_FILIAL+SC5->C5_NUM

				If ( Empty(SC9->C9_BLEST) .OR. SC9->C9_BLEST == "10" ) .and. ( Empty(SC9->C9_BLCRED) .OR. SC9->C9_BLCRED == "10") .AND. Empty(SC9->C9_NFISCAL)

			        SC6->(dbSeek(SC5->C5_FILIAL+SC9->(C9_PEDIDO+C9_ITEM+C9_PRODUTO) ))
			        SF4->(dbSeek(xFilial("SF4")+SC6->C6_TES ))
			        SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO ))
			        SB2->(dbSeek(xFilial("SB2")+SC6->(C6_PRODUTO+C6_LOCAL) ))
			        SE4->(dbSeek(xFilial("SE4")+SC5->C5_CONDPAG ))

					aAdd(aPvlNfs,{ 	SC9->C9_PEDIDO,;
									SC9->C9_ITEM,;
									SC9->C9_SEQUEN,;
									SC9->C9_QTDLIB,;
									SC6->C6_PRCVEN,;
									SC9->C9_PRODUTO,;
									.F.,;
									SC9->(Recno()),;
									SC5->(Recno()),;
									SC6->(Recno()),;
									SE4->(Recno()),;
									SB1->(Recno()),;
									SB2->(Recno()),;
									SF4->(Recno())})

			    Else
					lContinua	:= .F.
					aRet[1] := .T.
					aRet[2] := ""
					aRet[3] := "Pedido com bloqueio SC9 "+SC5->C5_FILIAL+SC5->C5_NUM
					aPvlNfs	:= {}
					Exit
			    EndIf

			    SC9->(dbSkip())
			EndDo

			If Len(aPvlNfs) <> 0
				cNota := MaPVlNFs(aPvlNfs,cSerie,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)
				If !Empty(cNota)
					lContinua	:= .T.
					aRet[1] := .F.
					aRet[2] := cNota
					aRet[3] := ""
				Else
					lContinua	:= .F.
					aRet[1] := .T.
					aRet[2] := ""
					aRet[3] := "Pedido:"+SC5->C5_NUM+", falha ao gerar nota fiscal!"
				EndIf
			EndIf

		EndIf
	EndIf
EndIf

Conout("GENA082 - finalizando geração pedido. "+Time())

Return aRet


User Function GENA082E()

Local lRet			:= .T.
Local aCfgParam		:= {}
Local cCadastro		:= "GENA082E - Faturamento Minha Biblioteca"
Local aParam		:= Array(3)
Local nOpcA			:= 0
Local lContinua		:= .T.
Local cFilPed		:= Getmv("GEN_FAT223",.f.,"1001")
Local cTesDA		:= GetMv("GEN_FAT227",.f.,"504")
Local cTesSrv		:= GetMv("GEN_FAT228",.F.,"543")
Local cCliDA		:= GetMv("GEN_FAT229",.f.,"0007099")
Local cLojaDA		:= GetMv("GEN_FAT230",.f.,"01")
Local aDados		:= {}
Local oOk			:= LoadBitmap( GetResources(), "LBOK" )
Local oNo			:= LoadBitmap( GetResources(), "LBNO" )
Local aButtons	:= {}

Private lSemaExt	:= .F.
Private lDadoExt	:= .F.

If cFilAnt <> "1022"
	MsgStop("Rotina deve ser executada estando logado na filial 1022")
	Return .F.
EndIf

aParam[1]	:= CriaVar("C5_EMISSAO",.F.)
aParam[2]	:= CriaVar("C5_EMISSAO",.F.)
aParam[3]	:= Space(6)

IF !LockByName("GENA082",.T.,.T.,.T.)
	MsgStop("Rotina já está sendo executada!")
	Return .F.
EndIf

Aadd(aCfgParam,{01,"Dt.Emis.Pedidos De"		,CriaVar("C5_EMISSAO",.F.)	,PesqPict("SC5","C5_EMISSAO"),".T.",""/*F3*/,"",60,.T.})
Aadd(aCfgParam,{01,"Dt.Emis.Pedidos Ate"		,CriaVar("C5_EMISSAO",.F.)	,PesqPict("SC5","C5_EMISSAO"),".T.",""/*F3*/,"",60,.T.})
Aadd(aCfgParam,{01,"Peri. Apur. AAAAMM"		,Space(6)	,"999999",".T.",""/*F3*/,"",20,.T.})

DEFINE MSDIALOG oDlgParam TITLE cCadastro FROM 000,000 TO 250,450 PIXEL

ParamBox(aCfgParam,cCadastro,@aParam,{|x| nOpcA := 1 },.T.,,,,oDlgParam,,.F.,.F.)

ACTIVATE MSDIALOG oDlgParam ON INIT EnchoiceBar(oDlgParam,{|| nOpcA := 1,oDlgParam:End()},{|| oDlgParam:End() }) CENTERED

IF nOpcA == 0
	Return .F.
EndIF

nOpca := 0

If Select("TMPFAT") > 0
	TMPFAT->(DbCloseArea())
EndIf

BeginSql Alias "TMPFAT"
	SELECT C6_FILIAL,C6_NUM,SUM(C6_VALOR) C6_VALOR,C5_EMISSAO,C5_NOTA,C5_SERIE,C5_MENNOTA,SC5.R_E_C_N_O_ SC5REC
	FROM %Table:SC6% SC6
	JOIN %Table:SC5% SC5
	ON C5_FILIAL = C6_FILIAL
	AND C5_NUM = C6_NUM
	AND SC5.%NotDel%
	WHERE C5_FILIAL = %xFilial:SC5%
	  AND C5_EMISSAO BETWEEN %Exp:DtoS(aParam[1])% AND %Exp:DtoS(aParam[2])%
	  AND C5_CLIENTE = %Exp:cCliDA%
	  AND C5_LOJACLI = %Exp:cLojaDA%
	  AND C6_TES = %Exp:cTesDA%
	  AND SC5.%NotDel%
	GROUP BY C6_FILIAL,C6_NUM,C5_EMISSAO,C5_MENNOTA,C5_NOTA,C5_SERIE,SC5.R_E_C_N_O_
	UNION ALL
	SELECT C6_FILIAL,C6_NUM,SUM(C6_VALOR) C6_VALOR,C5_EMISSAO,C5_NOTA,C5_SERIE,C5_MENNOTA,SC5.R_E_C_N_O_ SC5REC
	FROM %Table:SC6% SC6
	JOIN %Table:SC5% SC5 ON C5_FILIAL = C6_FILIAL
	AND C5_NUM = C6_NUM
	AND SC5.%NotDel%
	WHERE C5_FILIAL = %Exp:cFilPed%
	  AND C5_EMISSAO BETWEEN %Exp:DtoS(aParam[1])% AND %Exp:DtoS(aParam[2])%
	  AND C5_CLIENTE = %Exp:cCliDA%
	  AND C5_LOJACLI = %Exp:cLojaDA%
	  AND C6_TES = %Exp:cTesSrv%
	  AND SC5.%NotDel%
	GROUP BY C6_FILIAL,C6_NUM,C5_EMISSAO,C5_MENNOTA,C5_NOTA,C5_SERIE,SC5.R_E_C_N_O_
EndSql

TMPFAT->(DbGoTop())
While TMPFAT->(!EOF())
	SC5->(DbGoTo( TMPFAT->SC5REC ))
	Aadd(aDados, { TMPFAT->C6_FILIAL,	TMPFAT->C6_NUM,	+AllTrim(Transform(TMPFAT->C6_VALOR,"@E 999,999,999.99")),	STOD(TMPFAT->C5_EMISSAO),	TMPFAT->C5_NOTA,	TMPFAT->C5_SERIE,	IIF( TMPFAT->C6_FILIAL <> '1022' ,SC5->C5_XMSGNFS , TMPFAT->C5_MENNOTA ),	TMPFAT->SC5REC,	.F. } )
	TMPFAT->(DbSkip())
EndDo
TMPFAT->(DbClosearea())

DEFINE MSDIALOG oDlgT TITLE "GENA082E - Faturamento Minha Biblioteca" From 009,000 To 500,1000 OF oMainWnd Style DS_MODALFRAME Pixel

oDlgT:lMaximized	:= .F.

@00,00 MSPANEL oPanel PROMPT "" SIZE 250,45 COLOR CLR_WHITE,CLR_WHITE OF oDlgT
oPanel:Align := CONTROL_ALIGN_ALLCLIENT
aHList:={}
oListBox := TWBrowse():New(05,05,(oPanel:NCLIENTWIDTH/2)-10,(oPanel:NCLIENTHEIGHT/2)-55,,aHList,,oPanel,,,,,,,,,,,,, "ARRAY", .T. )

oListBox:AddColumn(TCColumn():New(" "					,{|| IIF(aDados[oListBox:nAT][9]	, oOk , oNo )		},,,,'CENTER'	,25,.T.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Filial"		  	,{|| aDados[oListBox:nAT][1]	},,,,'LEFT'		,20,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Pedido"		  	,{|| aDados[oListBox:nAT][2]	},,,,'RIGHT'		,45,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Valor"		  		,{|| aDados[oListBox:nAT][3]	},,,,'RIGHT'		,45,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Emissão"		  	,{|| aDados[oListBox:nAT][4]	},,,,'CENTER'		,45,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Nota"				,{|| aDados[oListBox:nAT][5]	},,,,'LEFT'		,35,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Serie"		  		,{|| aDados[oListBox:nAT][6]	},,,,'LEFT'		,20,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Mens.Nota"		  	,{|| aDados[oListBox:nAT][7]	},,,,'LEFT'		,300,.F.,.F.,,,,.F.,))

oListBox:SetArray( aDados )

oListBox:bLDblClick := {|| aDados[oListBox:nAT][9] := !aDados[oListBox:nAT][9] }

//AADD(aButtons, {"cargaseq",	{|| ExportGrid(aDados) }, "Registros Conciliação"})

ACTIVATE MSDIALOG oDlgT ON INIT EnchoiceBar(oDlgT,{|| nOpca := 1,oDlgT:End()},{|| oDlgT:End() },,aButtons) CENTERED

If nOpca == 1
	If  MsgYEsNo("Confirma a exclusão dos dados selecionados?")
		Processa({|| ProdEx(aParam,aDados) },"Processando...","Aguarde.. processando exclusões!",.F.)
	EndIf
EndIf

UnLockByName("GENA082",.T.,.T.,.T.)

Return nil

Static Function ProdEx(aParam,aDados)

Local lMudaSts		:= .F.
Local lRet			:= .T.
Local cCadastro		:= "GENA082E - Faturamento Minha Biblioteca"
Local lContinua		:= .T.
Local cFilPed		:= Getmv("GEN_FAT223",.f.,"1001")
Local cTesDA		:= GetMv("GEN_FAT227",.f.,"504")
Local cTesSrv		:= GetMv("GEN_FAT228",.F.,"543")
Local cCliDA		:= GetMv("GEN_FAT229",.f.,"0007099")
Local cLojaDA		:= GetMv("GEN_FAT230",.f.,"01")
Local cSemaforo		:= "GENA082_"+AllTrim(aParam[3])+"_SEMA"
Local cDados		:= "GENA082_"+AllTrim(aParam[3])+"_DADO"
Local cExtAux		:= ".dtc"
Local cDirBase		:= "\system\"
Local cFileSema		:= cDirBase+cSemaforo+cExtAux
Local cFileDado		:= cDirBase+cDados+cExtAux
Local lImpLog		:= .F.
Local cOwnerTb		:= ""
Local nAuxPed		:= 0

IF Select("VLDSTRU") > 0
	VLDSTRU->(DbCloseArea())
EndIF

BEGINSQL alias "VLDSTRU"
	SELECT TABLE_NAME FROM ALL_TABLES WHERE TRIM(TABLE_NAME) = %EXP:cSemaforo% AND OWNER = (SELECT SYS_CONTEXT('USERENV','CURRENT_SCHEMA') FROM DUAL)
ENDSQL
lSemaExt := VLDSTRU->(!eof())
VLDSTRU->(DbCloseArea())

BEGINSQL alias "VLDSTRU"
	SELECT TABLE_NAME FROM ALL_TABLES WHERE TRIM(TABLE_NAME) = %EXP:cDados% AND OWNER = (SELECT SYS_CONTEXT('USERENV','CURRENT_SCHEMA') FROM DUAL)
ENDSQL
lDadoExt := VLDSTRU->(!eof())
VLDSTRU->(DbCloseArea())

ProcRegua(Len(aDados)+1)

	For nAuxPed := 1 To Len(aDados)

		If !lContinua
			Exit
		EndIF

		IncProc("Processando pedido "+aDados[nAuxPed][2]+" filial "+aDados[nAuxPed][1])

		If !aDados[nAuxPed][9]
			Loop
		EndIf

		SC5->(DbGoTo(aDados[nAuxPed][8]))

		If !Empty(SC5->C5_NOTA)
			If xDelNFe(aDados[nAuxPed][1],aDados[nAuxPed][8])
				lMudaSts := .T.
			Else
				lContinua	:= .F.
			EndIf
		EndIf

		SC5->(DbGoTo(aDados[nAuxPed][8]))

		If lContinua .AND. Empty(SC5->C5_NOTA)
			If xDelPed(aDados[nAuxPed][1],aDados[nAuxPed][8])
				lMudaSts := .T.
			Else
				lContinua	:= .F.
			EndIf
		EndIf
	Next nAuxPed

	//If lContinua .AND. (lMudaSts .OR. ( Len(aDados) == 0 .AND. File(cFileSema) ))

	If lContinua .AND. (lMudaSts .OR. ( Len(aDados) == 0 .AND. lSemaExt/*ChkFile(cSemaforo,.F.,NIL,NIL,NIL,NIL,NIL,cSemaforo)*//*MsFile(cSemaforo,nil,"TOPCONN")*/ ))

		IncProc("Analisando situação atual!")

		IF Select("GENA82SEMA") > 0
			GENA82SEMA->(DbCloseArea())
		EndIF

		IF Select("GENA82DADO") > 0
			GENA82DADO->(DbCloseArea())
		EndIF
 
		If lSemaExt //ChkFile(cSemaforo,.F.,NIL,NIL,NIL,NIL,NIL,cSemaforo)//MsFile(cSemaforo,nil,"TOPCONN")//File(cFileSema)
			//DbUseArea(.T.,__LocalDriver,cFileSema,"GENA82SEMA",.T.,.F.)
			//DbUseArea(.T.,__LocalDriver,cFileDado,"GENA82DADO",.T.,.F.) // abre o alias

		    //GENA82SEMA := FWTemporaryTable():New( "GENA82SEMA" )
			//GENA82SEMA:SetFields(aCpSts)
		
		    //------------------
			//Criação da tabela temporaria
			//------------------
			//GENA82SEMA:Create()
			DbUseArea(.T.,"TOPCONN",cSemaforo,"GENA82SEMA",.F.,.F.)
		
			/*
			 Descontinuado para versão lobo guara com dicionario no banco - Fernando Lavor 03/07/2019
			*/		
		    //GENA82DADO := FWTemporaryTable():New( "GENA82DADO" )
			//GENA82DADO:SetFields(aCpDat)
		
		    //------------------
			//Criação da tabela temporaria
			//------------------
			//GENA82SEMA:Create()
			DbUseArea(.T.,"TOPCONN",cDados,"GENA82DADO",.F.,.F.)

			DbSelectArea("GENA82SEMA") // seleciona o alias
			DbSelectArea("GENA82DADO") // seleciona o alias
			GENA82DADO->( DBClearIndex() )

			If !VldIndice(cDados)
				Return .F.
			EndIf
			
			GENA82DADO->(DBReindex())
			DbSelectArea("GENA82DADO")

			cIdx1		:= xRetIndex("A")//GetNextAlias()+"A"
			cIdx2		:= xRetIndex("B")//GetNextAlias()+"B"

			DbSelectArea("GENA82DADO")
			GENA82DADO->(DBCreateIndex(cIdx1, "LINHA"         , {|| LINHA		}))
			GENA82DADO->(DBCreateIndex(cIdx2, "PEDIDO+LINHA"  , {|| PEDIDO+LINHA	}))

			If lContinua
				//If !lCrisStr //  se .F. quer dizer que não é a primeira execução com isso é necessario revalidar os registros.
				Processa({|| lContinua := VldSitAtu(nil,0,nil) },"Processando...","Aguarde.. consultando situação atual dos registros!",.F.)
				IF lContinua
					lImpLog	:= .T.
					IF EMPTY(GENA82SEMA->PEDRAT) .AND. EMPTY(GENA82SEMA->NFSRAT) .AND. EMPTY(GENA82SEMA->PEDPGW) .AND. EMPTY(GENA82SEMA->NFSPGW)
						GENA82DADO->(DbgoTop())
						while GENA82DADO->(!EOF())
							IF !EMPTY(GENA82DADO->PEDIDO) .or. !EMPTY(GENA82DADO->ITEMPD) .or. !EMPTY(GENA82DADO->NOTA) .or. !EMPTY(GENA82DADO->SERIE) .or. GENA82DADO->STS_PED <> "0"
								lImpLog	:= .F.
							ENDIF
							GENA82DADO->(DbSkip())
						end
					else
						lImpLog := .F.	
					ENDIF
				else
					lImpLog := .F.	
				EndIf
				//EndIf

				IF lImpLog .AND. lContinua
					IF Select("TEMP_OWNER") > 0
						TEMP_OWNER->(DbCloseArea())
					EndIf

					BEGINSQL ALIAS "TEMP_OWNER"
						SELECT SYS_CONTEXT('USERENV','CURRENT_SCHEMA') TP_OWNER FROM DUAL
					ENDSQL
					
					IF TEMP_OWNER->(!EOF())
						cOwnerTb := alltrim(TEMP_OWNER->TP_OWNER)
					else
						lImpLog	:= .F.
					EndIF 
					
					TEMP_OWNER->(DbCloseArea())

					If lImpLog
						cQry := " DROP TABLE "+cOwnerTb+"."+cSemaforo
						If (TCSQLExec(cQry) < 0)
							lImpLog := .F.
							MsgStop("TCSQLError() " + TCSQLError())
						EndIf
					EndIF

					If lImpLog
						cQry := " DROP TABLE "+cOwnerTb+"."+cDados
						If (TCSQLExec(cQry) < 0)
							lImpLog := .F.
							MsgStop("TCSQLError() " + TCSQLError())
						EndIf
					EndIF

					If !lImpLog
						MsgStop("Falha ao tentar limpar os logs de processamento, contate a TI!")
					EndIf
				EndIF
			EndIf
		EndIf

	EndIF
Return nil

User Function GENA082R(cRecSC5)

Local lRet		:= .F.
Local nOpCanc	:= 0
Local aRegSD2	:= {}
Local aRegSE1	:= {}
Local aRegSE2	:= {}
Local cFilPed	:= ""
Local cPedido	:= ""
Local cErro	:= ""
lMsErroAuto	:= .F.
DbSelectArea("SF2")
SF2->(DbSetOrder(1))

SC5->(DbGoTo(cRecSC5))

cFilPed	:= SC5->C5_FILIAL
cPedido	:= SC5->C5_NUM

If Empty(SC5->C5_NOTA)
	lRet	:= .F.
ElseIf SF2->(DbSeek( SC5->C5_FILIAL+SC5->C5_NOTA+SC5->C5_SERIE ))
	cCliente 	:= SF2->F2_CLIENTE
	cLojaCli 	:= SF2->F2_LOJA
	cNf			:= SF2->F2_DOC
	cSerie		:= SF2->F2_SERIE
	dEmissao	:= SF2->F2_EMISSAO
	lMsErroAuto	:= .F.

	IF MaCanDelF2("SF2",SF2->(Recno()),@aRegSD2,@aRegSE1,@aRegSE2) .And. MA521VerSC6(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui documento fiscal                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MaDelNFS(aRegSD2,aRegSE1,aRegSE2,.F.,.F.,.F.,.F.)
		If !lMsErroAuto
			lRet	:= !SF2->(DbSeek( SC5->C5_FILIAL+SC5->C5_NOTA+SC5->C5_SERIE ))
		EndIf

	Else
		cErro	:= "Exclusão da nota "+SF2->F2_DOC+"/"+SF2->F2_SERIE+" não pode ser executada!"
		lRet	:= .F.
	EndIf
EndIf

Return lRet

Static Function xDelNFe(cFilNew,nRecSC5)

Local oServer	:= nil
Local cServ		:= GetMv("GEN_FAT234",.f.,"10.3.0.72")
Local nPort  	:= GetMv("GEN_FAT235",.f.,1266)
Local cAmb		:= GetMv("GEN_FAT236",.f.,"SCHEDULE")
Local lRet		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realizando a nova conexão para entrar na empresa e filial correta³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ValType(oServer) == "O"
	//Fecha a Conexao com o Servidor
	RESET ENVIRONMENT IN SERVER oServer
	CLOSE RPCCONN oServer
	FreeObj(oServer)
	oServer := Nil
EndIf

CREATE RPCCONN oServer ON  SERVER cServ 			;   //IP do servidor
PORT  nPort           								;   //Porta de conexão do servidor
ENVIRONMENT cAmb       								;   //Ambiente do servidor
EMPRESA cEmpAnt          							;   //Empresa de conexão
FILIAL  cFilNew         								;   //Filial de conexão
TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2";   //Tabela que serão abertas
MODULO  "SIGAFAT"               					//Módulo de conexão

If ValType(oServer) == "O"
	oServer:CallProc("RPCSetType", 2)
	lRet := oServer:CallProc("U_GENA082R",nRecSC5 )

	If ValType(lRet) <> "L"
		lRet := .F.
	EndIf

	If !lRet
		cErroLg	:= "Erro ao tentar conectar no Protheus para exclusão da nota fiscal!"+chr(13)+chr(10)
		cSolucao	:= "O processo será finalizado, tente executar o processo novamente!"+chr(13)+chr(10)+;
		"Caso o problema persista, contate a TI!"
		xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Realizando a nova conexão para entrar na empresa e filial correta³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Fecha a Conexao com o Servidor
	RESET ENVIRONMENT IN SERVER oServer
	CLOSE RPCCONN oServer
	FreeObj(oServer)
	oServer := Nil

Else
	lRet	:= .F.
	cErroLg	:= "Erro ao tentar conectar no Protheus para exclusão da nota fiscal!"+chr(13)+chr(10)
	cSolucao	:= "O processo será finalizado, tente executar o processo novamente!"+chr(13)+chr(10)+;
	"Caso o problema persista, contate a TI!"
	xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
EndIf

Return lRet


Static Function xDelPed(cFilNew,nRecSC5)

Local oServer	:= nil
Local cServ		:= GetMv("GEN_FAT234",.f.,"10.3.0.72")
Local nPort  	:= GetMv("GEN_FAT235",.f.,1266)
Local cAmb		:= GetMv("GEN_FAT236",.f.,"SCHEDULE")
Local lRet		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realizando a nova conexão para entrar na empresa e filial correta³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ValType(oServer) == "O"
	//Fecha a Conexao com o Servidor
	RESET ENVIRONMENT IN SERVER oServer
	CLOSE RPCCONN oServer
	FreeObj(oServer)
	oServer := Nil
EndIf

CREATE RPCCONN oServer ON  SERVER cServ 			;   //IP do servidor
PORT  nPort           								;   //Porta de conexão do servidor
ENVIRONMENT cAmb       								;   //Ambiente do servidor
EMPRESA cEmpAnt          							;   //Empresa de conexão
FILIAL  cFilNew         								;   //Filial de conexão
TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2";   //Tabela que serão abertas
MODULO  "SIGAFAT"               					//Módulo de conexão

If ValType(oServer) == "O"
	oServer:CallProc("RPCSetType", 2)
	lRet := oServer:CallProc("U_GENA082D",nRecSC5 )

	If ValType(lRet) <> "L"
		lRet := .F.
		cErroLg	:= "Erro ao tentar conectar no Protheus para exclusão do pedido!"+chr(13)+chr(10)
		cSolucao	:= "O processo será finalizado, tente executar o processo novamente!"+chr(13)+chr(10)+;
		"Caso o problema persista, contate a TI!"
		xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
	ElseIf !lRet
		cErroLg	:= "Erro ao tentar excluir o pedido!"+chr(13)+chr(10)
		cSolucao	:= "O processo será finalizado, tente executar o processo novamente!"+chr(13)+chr(10)+;
		"Caso o problema persista, contate a TI!"
		xMagHelpFis("Excluindo pedido..",cErroLg,cSolucao)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Realizando a nova conexão para entrar na empresa e filial correta³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Fecha a Conexao com o Servidor
	RESET ENVIRONMENT IN SERVER oServer
	CLOSE RPCCONN oServer
	FreeObj(oServer)
	oServer := Nil

Else
	lRet	:= .F.
	cErroLg	:= "Erro ao tentar conectar no Protheus para exclusão do pedido!"+chr(13)+chr(10)
	cSolucao	:= "O processo será finalizado, tente executar o processo novamente!"+chr(13)+chr(10)+;
	"Caso o problema persista, contate a TI!"
	xMagHelpFis("Gerando pedido DA",cErroLg,cSolucao)
EndIf

Return lRet


User Function GENA082D(nRecSC5)

Local lRet		:= .F.
lMsErroAuto	:= .F.
DbSelectArea("SC5")
SC5->(DbsetOrder(1))
SC5->(DbGoTo( nRecSC5 ))

SC9->(DbSeek( SC5->C5_FILIAL+SC5->C5_NUM ))
While SC9->(!Eof()) .and. SC9->(C9_FILIAL+C9_PEDIDO) == SC5->C5_FILIAL+SC5->C5_NUM
	SC9->(a460Estorna())
	SC9->(DbSkip())
Enddo

//****************************************************************
//* Teste de alteracao
//****************************************************************
aCabec := {}
aItens := {}
aadd(aCabec,{"C5_NUM",		SC5->C5_NUM	,Nil})
aadd(aCabec,{"C5_TIPO",		"N"				,Nil})
aadd(aCabec,{"C5_CLIENTE",	SA1->A1_COD	,Nil})
aadd(aCabec,{"C5_LOJACLI",	SA1->A1_LOJA	,Nil})
aadd(aCabec,{"C5_LOJAENT",	SA1->A1_LOJA	,Nil})
aadd(aCabec,{"C5_CONDPAG",	SE4->E4_CODIGO,Nil})

SC6->(DbSetOrder(1))
SC6->(DbSeek( SC5->C5_FILIAL+SC5->C5_NUM ))

While SC6->(!EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
    aLinha := {}
    aadd(aLinha,{"LINPOS"		,"C6_ITEM",		SC6->C6_ITEM })
    aadd(aLinha,{"AUTDELETA"	,"S",				Nil})
    aadd(aLinha,{"C6_PRODUTO"	,SC6->C6_PRODUTO,	Nil})
    aadd(aLinha,{"C6_QTDVEN"	,SC6->C6_QTDVEN,	Nil})
    aadd(aLinha,{"C6_PRCVEN"	,SC6->C6_PRCVEN,	Nil})
    aadd(aLinha,{"C6_PRUNIT"	,SC6->C6_PRUNIT,	Nil})
    aadd(aLinha,{"C6_VALOR"		,SC6->C6_VALOR,	Nil})
    aadd(aLinha,{"C6_TES"		,SC6->C6_TES,		Nil})
    aadd(aItens,aLinha)
    SC6->(DbSkip())
EndDo

MSExecAuto({|x,y,z|mata410(x,y,z)},aCabec,aItens,5)
If !lMsErroAuto
	lRet := .t.
Else
	lRet := .F.
EndIf

Return lRet


Static Function ExportGrid(aDados,aParam)

Local cSheet	:= "Analise Planilha MB"
Local cTable	:= "Analise Planilha MB"

Local cArquivo	:= "ANALISE_MB_"+DtoS(DDataBase)+StrTran(Time(),":","")+".xls"
Local oExcel		:= FWMSEXCEL():New()
Local cPath		:= GetTempPath() //Diretorio de gravacao de arquivos
Local lMail		:= .F.

/*If !ApOleClient( 'MsExcel' )
	MsgAlert( 'MsExcel nao instalado' )
	Return
EndIf*/

TMPEXCEL->(DbGoTop())

oExcel:AddworkSheet(cSheet)
oExcel:AddTable (cSheet,cTable)

//Alinhamento da coluna ( 1-Left,2-Center,3-Right )  //Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )

oExcel:AddColumn(cSheet,cTable,"SIT."				,1,1)
oExcel:AddColumn(cSheet,cTable,"COD.PROTHEUS"		,1,1)
oExcel:AddColumn(cSheet,cTable,"VBID"	   			,1,1)
oExcel:AddColumn(cSheet,cTable,"ISBN"	   			,1,1)
oExcel:AddColumn(cSheet,cTable,"QTD.PAGEVIEW"		,3,2)
oExcel:AddColumn(cSheet,cTable,"VLR.PAGEVIEW"		,3,3)
oExcel:AddColumn(cSheet,cTable,"% APURAÇÃO"		,3,2)
oExcel:AddColumn(cSheet,cTable,"VLR.UNI.APURADO"	,3,3)
oExcel:AddColumn(cSheet,cTable,"SIT.OBRA"			,1,1)
oExcel:AddColumn(cSheet,cTable,"EXCEL LINHA"		,3,2)
oExcel:AddColumn(cSheet,cTable,"OBSERVAÇÃO"		,1,1)

While TMPEXCEL->(!EOF())
	oExcel:AddRow(cSheet,cTable,{;
		IIF( TMPEXCEL->STATUS == "S", "OK" , IIF( AllTrim(TMPEXCEL->STATUS) == "N" , "FALHA" , IIF(AllTrim(TMPEXCEL->STATUS) == "E" , "ERRO" , "ATENÇÃO" ) ) ),;
		TMPEXCEL->B1_COD,;
		TMPEXCEL->VBID,;
		TMPEXCEL->B1_ISBN,;
		TMPEXCEL->C6_QTDVEN,;
		TMPEXCEL->C6_VALOR,;
		aParam[P_06],;
		TMPEXCEL->C6_PRCVEN,;
		TMPEXCEL->SITUACAO,;
		TMPEXCEL->LINHA,;
		TMPEXCEL->MSG;
		})
	TMPEXCEL->(DbSkip())
EndDo

oExcel:Activate()
oExcel:GetXMLFile(cPath+cArquivo)

ShellExecute("Open", cPath+cArquivo, "", cPath, 1 )
//oExcelApp := MsExcel():New()
//oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha
//oExcelApp:SetVisible(.T.)

FreeObj(oExcel)

TMPEXCEL->(DbGoTop())

Return nil

Static Function VldIndice(cDados)

Local cSchema := IIF( "TST" $ GetSrvProfString("TopALIAS","GEN") ,"TOTVS_TST" , "TOTVS" )

IF select("TMP_IDX") > 0
	TMP_IDX->(DbcloseArea())
ENDIF

BeginSql Alias "TMP_IDX"
	SELECT INDEX_NAME FROM dba_indexes 
	WHERE OWNER = %Exp:cSchema%
	AND TABLE_NAME = %Exp:AllTrim(cDados)%
	AND INDEX_NAME NOT LIKE '%'||%Exp:AllTrim(cDados)%||'%'
	ORDER BY INDEX_NAME
EndSql

TMP_IDX->(DbGoTop())
While TMP_IDX->(!EOF())
	Begin Transaction
		If (TCSqlExec('drop index "'+cSchema+'"."'+AllTrim(TMP_IDX->INDEX_NAME)+'"') < 0)
			xMagHelpFis("TCSQLError()",TCSQLError(),"Falha ao tentar eliminar os indices temporarios da tabela "+AllTrim(TMP_IDX->INDEX_NAME))
			Return .F.
		EndIf
	End Transaction
	TMP_IDX->(DbSkip())
EndDo

Return .T.