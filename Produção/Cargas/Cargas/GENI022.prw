#INCLUDE "rwmake.ch"
#INCLUDE "fivewin.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "topconn.ch"

#DEFINE cEnt Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออัออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProgramaณGENI022   บAutor  ณDanilo Azevedo     บ Data ณ  17/03/15   บฑฑ
ฑฑฬออออออออุออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.   ณRotina para gerar saldo nos produtos da pasta do professor บฑฑ
ฑฑบ        ณa partir de movimentacao interna.                          บฑฑ
ฑฑฬออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso     ณ GEN                                                       บฑฑ
ฑฑศออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GENI022()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Abertura do ambiente                                         |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PREPARE ENVIRONMENT EMPRESA "00" FILIAL "1022" MODULO "EST" TABLES "SD3","SB1"

_cLogPd			:= GetMv("GEN_FAT007") //Cont้m o caminho que serแ gravado o log de erro
cPath			:= "\LogSiga\Produtos\"

cTPMovimento 	:= "100"
cArmazem 		:= "01"
dEmissao 		:= dDataBase

lMsErroAuto		:= .F.
lMsHelpAuto		:= .T.
lAutoErrNoFile 	:= .T.
cAlias			:= GetNextAlias()

cQry := "SELECT 999999-B2_QATU CARGA, B2_COD, B1_UM, B1_GRUPO, B1_CONTA, B1_CC, B1_PROC, B1_LOJPROC
cQry += " FROM "+RetSqlName("SB2")+" B2
cQry += " JOIN "+RetSqlName("SB1")+" B1 ON B2_COD = B1_COD
cQry += " WHERE B2_FILIAL = '"+xFilial("SB2")+"'
cQry += " AND B1_FILIAL = '"+xFilial("SB1")+"'
cQry += " AND B2_LOCAL = '01'
cQry += " AND B2_QATU BETWEEN 1 AND 999998
cQry += " AND B2_COD IN (SELECT B1_COD FROM "+RetSqlName("SB1")+" WHERE B1_FILIAL = '"+xFilial("SB1")+"' AND B1_XIDTPPU IN ('11','15') AND D_E_L_E_T_ = ' ')
cQry += " AND B2_COD NOT IN (SELECT B2_COD FROM "+RetSqlName("SB2")+" WHERE B2_FILIAL <> '"+xFilial("SB2")+"' AND B2_QATU > 0 AND D_E_L_E_T_ = ' ')
cQry += " AND B2.D_E_L_E_T_ = ' '
cQry += " AND B1.D_E_L_E_T_ = ' '
cQry += " ORDER BY B1_PROC, B1_LOJPROC, B2_COD

If Select(cAlias) > 0
	dbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQry), cAlias, .F., .T.)

Do While !(cAlias)->(EOF())
	
	DbSelectArea("SA2")
	DbSetOrder(1)
	If !DbSeek(xFilial("SA2")+(cAlias)->B1_PROC+(cAlias)->B1_LOJPROC)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para alimentar Log de erroณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_cMsg := "Nใo foi encontrado no sistema fornecedor com o c๓digo: " + AllTrim((cAlias)->B1_PROC) + " e loja: " + AllTrim((cAlias)->B1_LOJPROC)
		MemoWrite(cPath+"Prod_"+AllTrim((cAlias)->B1_COD)+".txt",_cMsg)
		(_cAliQry)->(DbSkip())
		Loop
	EndIf
	
	_cClien := AllTrim(SA2->A2_COD)
	_cLoj   := AllTrim(SA2->A2_LOJA)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPonterando na SM0 para pegar o CNPJ correto e realzar o ponteramento ณ
	//ณna empresa quer serแ gravado a Nota                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_aArM0 := SM0->(GetArea())
	DbSelectArea("SM0")
	SM0->(DbGoTop())
	While SM0->(!EOF())
		If AllTrim(SM0->M0_CGC) == AllTrim(SA2->A2_CGC)
			_lEmp := .T.
			_cEmpCd := SM0->M0_CODIGO
			_cEmpFl := SM0->M0_CODFIL
			Exit
		Else
			_lEmp := .F.
		EndIf
		SM0->(DbSkip())
	EndDo
	
	If !_lEmp
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFun็ใo para alimentar Log de erroณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_cMsg := "Nใo foi encontrado no sistema empresa (SM0) com o CNPJ: " + SA2->A2_CGC
		MemoWrite(cPath+"Emp_"+AllTrim(SA2->A2_CGC)+".txt",_cMsg)
		(_cAliQry)->(DbSkip())
		Loop
	EndIf
	
	RestArea(_aArM0)
	
	cFil := _cEmpFl
	cFilAnt := _cEmpFl
	cChave := (cAlias)->B1_PROC+(cAlias)->B1_LOJPROC
	
	Do While (cAlias)->B1_PROC+(cAlias)->B1_LOJPROC = cChave
		Begin Transaction
		
		aSld := {}
		aadd(aSld,{"D3_TM",cTPMovimento,})
		aadd(aSld,{"D3_COD",(cAlias)->B2_COD,})
		aadd(aSld,{"D3_UM",(cAlias)->B1_UM,})
		aadd(aSld,{"D3_LOCAL",cArmazem,})
		aadd(aSld,{"D3_QUANT",(cAlias)->CARGA,})
		aadd(aSld,{"D3_EMISSAO",dEmissao,})
		
		MSExecAuto({|x,y| mata240(x,y)},aSld,3)
		
		If lMsErroAuto
			_cMsg := "Nใo foi possํvel concluir a opera็ใo."+ cEnt + cEnt
			_aErro := GetAutoGRLog()
			For _ni := 1 To Len(_aErro)
				_cMsg += _aErro[_ni] + cEnt
			Next _ni
			
			MemoWrite(cPath+"Prod_"+AllTrim((cAlias)->B1_COD)+".txt",_cMsg)
		EndIf
		
		End Transaction
		
		cFilAnt := cFil
		(cAlias)->(dbSkip())
	Enddo
Enddo

RESET ENVIRONMENT

Return()
