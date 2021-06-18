#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFISFILNFE บAutor  ณDanilo Azevedo      บ Data ณ  21/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada para adicionar opcoes de filtro na rotina  บฑฑ
ฑฑบ          ณde transmissao de notas (SPEDNFE).                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN - Faturamento                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FISFILNFE()

//08/06/2015 - Rafael Leite - Alterado fonte para servir como fun็ใo de impressใo da DANFE. Esta rotina trabalha em conjunto com o fonte FISFILNFE
//para gerar um menu somente de impressใo do DANFE.

//If Existblock("GENNFE") .or. Alltrim(FUNNAME()) == "GENDAN" //SE O FILTRO ANTIGO ESTIVER COMPILADO, NAO EXECUTA
If Alltrim(FUNNAME()) == "GENNFE" //Se for rotina de impressใo de danfe nใo faz filtro.
	Return()
Endif

lRet := .T.

If SubStr(MV_PAR01,1,1) == "1"
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRealiza a Filtragem na 1-Saida                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	cUsrLib := GetMv("GEN_NFEFIL")
	If RetCodUsr() $ cUsrLib
		lRet := MsgYesNo("Deseja visualizar apenas produtos jแ embalados?","Aten็ใo")
	Endif
		
	cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
	
	If !Empty(MV_PAR03)
		cCondicao += ".AND.F2_SERIE=='"+MV_PAR03+"'"
	EndIf
	If SubStr(MV_PAR02,1,1) == "1" //"1-NF Autorizada"
		cCondicao += ".AND. F2_FIMP$'S' "
	ElseIf SubStr(MV_PAR02,1,1) == "3" //"3-Nใo Autorizadas"
		cCondicao += ".AND. F2_FIMP$'N' "
	ElseIf SubStr(MV_PAR02,1,1) == "4" //"4-Transmitidas"
		cCondicao += ".AND. F2_FIMP$'T' "
	ElseIf SubStr(MV_PAR02,1,1) == "5" //"5-Nใo Transmitidas"
		cCondicao += ".AND. F2_FIMP$' ' "
	EndIf
	If lRet .and. alltrim(MV_PAR03) <> "2" //SERIE 2 NAO ENTRA NO FILTRO
		cCondicao += ".AND. F2_XSTROMA = 'B' "
	Endif
	
Else
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRealiza a Filtragem na 2-Entrada                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	cCondicao := "F1_FILIAL=='"+xFilial("SF1")+"' .AND. "
	cCondicao += "F1_FORMUL=='S'"
	
	If !Empty(MV_PAR03)
		cCondicao += ".AND.F1_SERIE=='"+MV_PAR03+"'"
	EndIf
	If SubStr(MV_PAR02,1,1) == "1" .And. SF1->(FieldPos("F1_FIMP"))>0 //"1-NF Autorizada"
		cCondicao += ".AND. F1_FIMP$'S' "
	ElseIf SubStr(MV_PAR02,1,1) == "3" .And. SF1->(FieldPos("F1_FIMP"))>0 //"3-Nใo Autorizadas"
		cCondicao += ".AND. F1_FIMP$'N' "
	ElseIf SubStr(MV_PAR02,1,1) == "4" .And. SF1->(FieldPos("F1_FIMP"))>0 //"4-Transmitidas"
		cCondicao += ".AND. F1_FIMP$'T' "
	ElseIf SubStr(MV_PAR02,1,1) == "5" .And. SF1->(FieldPos("F1_FIMP"))>0 //"5-Nใo Transmitidas"
		cCondicao += ".AND. F1_FIMP$' ' "
	EndIf
	
Endif

Return(cCondicao)
