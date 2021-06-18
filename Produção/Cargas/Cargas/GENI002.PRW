#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Rwmake.ch"
#include "tbiconn.ch"
#include "parmtype.ch"
#Include "fwmvcdef.ch"

#DEFINE cEnt CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI002   ºAutor  ³Florence França     º Data ³  09/19/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para Importacao de Fornecedor                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³Autor  ³Joni Fujiyama                  º Data ³  02/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina foi adaptada para rodar por schedule.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENI002()

Private cFunName := PROCNAME()

If MsgYesNo("Esta rotina fará a importação de Fornecedores. Deseja continuar?", "Atenção" )
	Processa({||ImpFor()})
EndIf

Return()


//*************************************************************************************************//
// Rotina da execução por schedule				Autor: Joni Fujiyama			Data:02/07/2014			 //
//*************************************************************************************************//
User Function GENI002A()

Local lRotMens:=.F.
Private cFunName := PROCNAME()

Prepare Environment Empresa "00" Filial "1001"
RotMens("Executando a rotina ==> " + cFunName,"","")
ImpFor()
lRotMens := RotMens("Fim do Schedule...","","")
Reset Environment

Return()

//*************************************************************************************
// Mostra a mensagem na tela ou no console			Autor: Joni Fujiyama		Data:02/07/2014
//***************************************************************************************/
Static Function RotMens(pTexto1,pTexto2,pTipo)

IF cFunName == "U_GENI002"
	DO CASE
		Case pTipo = "1"
			MSGBOX(pTexto1,pTexto2)
		Case pTipo = "2"
			MSGINFO(pTexto1,pTexto2)
	ENDCASE
ELSE
	IF cFunName == "U_GENI002A"
		Conout("[" + DtoC(dDataBase) + Space(1) + Time() + "] " + cFunName + Space(1) + pTexto1)
	ENDIF
ENDIF

Return .T.

Static Function ImpFor()

Local cQuerySA2,cQueryMAX,cQuery
Local cPais	:= ""
Local cArqSA2	:= GetNextAlias()
Local cArqMAX	:= GetNextAlias()
Local cArqBUS	:= GetNextAlias()
Local cPath
Local cFile
Local cCod		:= 0
Local nContx 	:= 0
Local cCodOld := 0
Local lAchou  := .T.
Local lErro	:= .F.
Local aPosSA2	:= {}
Local aSA2Prod:= {}

Private oModel 	:= NIL

Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.
//Private aLog 		:= {}
Private	cPath := "\logsiga\fornecedor\"
Private cCodigo 	:= "0000002"

//Bloco descontinuado Fernando Lavor 03/07/2019
/*
SX3->(DbsetOrder(1))
SX3->(DbSeek( "SA2" ))
While SX3->X3_ARQUIVO == "SA2"
	
	Aadd(aPosSA2, {SX3->X3_CAMPO,SX3->X3_ORDEM,SX3->X3_TIPO,SX3->X3_TAMANHO} )
	
	SX3->(dbSkip())
EndDo
*/

aCampos := FWSX3Util():GetAllFields( "SA2", .T. ) //Retorna os campos de um alias específico da SX3.

For xA2 := 1 To Len(aCampos)
					//Nome do campo   posicone para retornar a posição        Tipo do campo                            Tamanho do campo
	Aadd(aPosSA2, {aCampos[xA2],Posicione("SX3",2,aCampos[xA2],"X3_ORDEM"),FWSX3Util():GetFieldType(aCampos[xA2]),TamSx3(aCampos[xA2])[1]} )

Next xA2

aSort(aPosSA2,,,{|x,y| x[2] < y[2]})

_aDir := directory(Alltrim(cPath)+"*")
For i:=1 to len(_aDir)
	fErase(Alltrim(cPath)+_aDir[i][1])
Next i

cQuerySA2 := "SELECT * FROM TT_I02_FORNECEDOR ORDER BY A2_COD"
//cQuerySA2 := "SELECT * FROM DBA_EGK.TT_I02_FORN ORDER BY A2_COD

If Select(cArqSA2) > 0
	dbSelectArea(cArqSA2)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuerySA2), cArqSA2, .F., .T.)

(cArqSA2)->(dbGoTop())

Do While !(cArqSA2)->(Eof())
	cCGC	:= padr((cArqSA2)->A2_CGC,TamSx3("A2_CGC")[1])
	cCod	:= ""
	cLoja	:= ""
	//CARREGA CODIGO GEN
	cCodOld	:= padr((cArqSA2)->A2_COD,TamSx3("A2_XCODOLD")[1])
	
	//VERIFICA SE CGC NAO FOI INFORMADO PARA FORNECEDOR NACIONAL
	If Empty(cCGC) .and. Alltrim((cArqSA2)->A2_EST) <> 'EX'
		Memowrite(cPath+"Fornecedor - CodGen "+alltrim(cCodOld)+".log","Cod. Fornecedor GEN: " + alltrim(cCodOld) +" | CNPJ/CPF Não Informado")
		(cArqSA2)->(DbSkip())
		Loop
	Else
		If Empty(cCGC) .and. !Empty(cCodOld)
			VldCodOld(cCodOld,@cCod,@cLoja)
			/*
			cCod  := POSICIONE("SA2",9,xFilial("SA2")+cCodOld,"A2_COD")
			cLoja := POSICIONE("SA2",9,xFilial("SA2")+cCodOld,"A2_LOJA")
			*/
		Else
			cCod  := POSICIONE("SA2",3,xFilial("SA2")+cCGC,"A2_COD")
			cLoja := POSICIONE("SA2",3,xFilial("SA2")+cCGC,"A2_LOJA")
			If Empty(cCod) .and. !Empty(cCodOld)
				VldCodOld(cCodOld,@cCod,@cLoja)
				/*
				cCod  := POSICIONE("SA2",9,xFilial("SA2")+cCodOld,"A2_COD")
				cLoja := POSICIONE("SA2",9,xFilial("SA2")+cCodOld,"A2_LOJA")
				*/
			EndIf
		EndIf
		
		If empty(cCod) //BUSCA PROXIMO COD DE FORNECEDOR
			/*
			cQueryMAX := "SELECT MAX(A2_COD) CODFOR FROM "+RetSQLName("SA2")+ " WHERE A2_COD NOT IN ('UNIAO','MUNIC') AND A2_COD NOT LIKE 'INP%' AND D_E_L_E_T_ = ' ' " //WHERE ROWNUM < 10
			If Select(cArqMAX) > 0
			dbSelectArea(cArqMAX)
			dbCloseArea()
			EndIf
			DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQueryMAX), cArqMAX, .F., .T.)
			cCod  := soma1((cArqMAX)->CODFOR)
			*/
			cCod  := Vercod()
			cLoja := "01"
		EndIf
		
		lMsErroAuto := .F.
		lGravaCod 	:= .F.
		
		DbSelectArea("SA2")
		DbSetOrder(1)	//A2_FILIAL+A2_COD+A2_LOJA
		If !DbSeek(xFilial("SA2")+cCod+cLoja)

			If ( (cArqSA2)->A2_TIPO="F" ).and.(alltrim((cArqSA2)->A2_BANCO) != '000')
				If ( Empty((cArqSA2)->A2_CGC) .or. Empty((cArqSA2)->A2_BANCO) .or. Empty((cArqSA2)->A2_AGENCIA) .or. Empty((cArqSA2)->A2_NUMCON))
					lErro := .T.
					cFile := "Fornecedor - CodGen "+alltrim(cCodOld)+".log"
					MemoWrite(cPath+cFile,"Para Pessoa Física é obrigatório o preenchimento do CPF e dos dados bancários")
					(cArqSA2)->(DbSkip())
					Loop
				EndIf
			EndIf

			lAchou := .F.
			
			//VERIFICA INFORMAÇÕES
			cNome   := ALLTRIM((cArqSA2)->A2_NREDUZ)
			cBairro := Iif(ALLTRIM((cArqSA2)->A2_BAIRRO) == "(null)",'',NoAcento(ALLTRIM((cArqSA2)->A2_BAIRRO)))
			
			cA2_CODPAIS:= strzero(Val((cArqSA2)->A2_CODPAIS),5)
			cA2_INSCR  := IIf(Empty((cArqSA2)->A2_INSCR),'ISENTO',AllTrim((cArqSA2)->A2_INSCR))
			cA2_INSCRM := IIf(Empty((cArqSA2)->A2_INSCRM),'ISENTO',AllTrim((cArqSA2)->A2_INSCRM))
			
			//ARMAZENA INFORMAÇÕES DA QUERY
			aMATA020 := {}
			
			aAdd(aMATA020,{"A2_FILIAL",xFilial("SA2"),Nil})
			aAdd(aMATA020,{"A2_COD",cCod,Nil})
			aAdd(aMATA020,{"A2_LOJA",cLoja,Nil})
			aAdd(aMATA020,{"A2_XCODOLD",ALLTRIM(cCodOld),Nil})
			aAdd(aMATA020,{"A2_NOME",NoAcento(ALLTRIM((cArqSA2)->A2_NOME)),Nil})
			aAdd(aMATA020,{"A2_NREDUZ",NoAcento(cNome),Nil})
			aAdd(aMATA020,{"A2_END",NoAcento(ALLTRIM((cArqSA2)->A2_END)),Nil})
			aAdd(aMATA020,{"A2_EST",NoAcento(ALLTRIM((cArqSA2)->A2_EST)),Nil})
			aAdd(aMATA020,{"A2_MUN",NoAcento(ALLTRIM((cArqSA2)->A2_MUN)),Nil})
			aAdd(aMATA020,{"A2_TIPO",UPPER(ALLTRIM((cArqSA2)->A2_TIPO)),Nil})
			aEndAux := FisGetEnd(ALLTRIM((cArqSA2)->A2_END))
				If Len(aEndAux) >= 3
 					aAdd(aMATA020,{"A2_NR_END",aEndAux[3],Nil})
				Else
 					aAdd(aMATA020,{"A2_NR_END"," ",Nil})
				EndIF			
			aAdd(aMATA020,{"A2_BAIRRO",NoAcento(cBairro),Nil})
			aAdd(aMATA020,{"A2_ESTADO",ALLTRIM((cArqSA2)->A2_ESTADO),Nil})
			aAdd(aMATA020,{"A2_COD_MUN",Substr(cValToChar((cArqSA2)->A2_COD_MUN),3),Nil})
			aAdd(aMATA020,{"A2_CEP",ALLTRIM((cArqSA2)->A2_CEP),Nil})
			aAdd(aMATA020,{"A2_CGC",ALLTRIM(cCGC),Nil})
			aAdd(aMATA020,{"A2_INSCR",cA2_INSCR,Nil})
			aAdd(aMATA020,{"A2_INSCRM",cA2_INSCRM,Nil})
			aAdd(aMATA020,{"A2_DDI",Iif(cValToChar((cArqSA2)->A2_DDI)=='0','',cValToChar((cArqSA2)->A2_DDI)),Nil})
			aAdd(aMATA020,{"A2_DDD",Iif(cValToChar((cArqSA2)->A2_DDD)=='0','',cValToChar((cArqSA2)->A2_DDD)),Nil})
			aAdd(aMATA020,{"A2_TEL",Iif(Alltrim((cArqSA2)->A2_TEL)== "(null)",'',Alltrim((cArqSA2)->A2_TEL)),Nil})
			aAdd(aMATA020,{"A2_FAX",Iif(Alltrim((cArqSA2)->A2_FAX)== "(null)",'',Alltrim((cArqSA2)->A2_FAX)),Nil})
			aAdd(aMATA020,{"A2_PAIS",Iif(Alltrim((cArqSA2)->A2_PAIS)== "(null)",'',Alltrim((cArqSA2)->A2_PAIS)),Nil})
			aAdd(aMATA020,{"A2_CODPAIS",cA2_CODPAIS,Nil})
			aAdd(aMATA020,{"A2_EMAIL",Iif(Alltrim((cArqSA2)->A2_EMAIL)== "(null)",'',Alltrim((cArqSA2)->A2_EMAIL)),Nil})
			aAdd(aMATA020,{"A2_PAISDES",Iif(Alltrim((cArqSA2)->A2_PAISDES)== "(null)",'',Alltrim((cArqSA2)->A2_PAISDES)),Nil})
			aAdd(aMATA020,{"A2_COMPLEM",Iif(Alltrim((cArqSA2)->A2_COMPLEM)== "(null)",'',Alltrim((cArqSA2)->A2_COMPLEM)),Nil})
			aAdd(aMATA020,{"A2_TPESSOA",Iif(Empty((cArqSA2)->A2_TPESSOA),'PF',Alltrim((cArqSA2)->A2_TPESSOA)),Nil})
			aAdd(aMATA020,{"A2_CONTA",Iif(Alltrim((cArqSA2)->A2_CONTA)== "(null)",'',Alltrim((cArqSA2)->A2_CONTA)),Nil})
			If UPPER(ALLTRIM((cArqSA2)->A2_TIPO)) == "F"
				aAdd(aMATA020,{"A2_CALCIRF","2",Nil}) //IRRF Baixa 
			Else
				aAdd(aMATA020,{"A2_CALCIRF","1",Nil}) //CALCULA IR NORMAL
			EndIf	
			
			aAdd(aMATA020,{"A2_BANCO",padl((cArqSA2)->A2_BANCO,tamsx3("A2_BANCO")[1],"0"),Nil})
			aAdd(aMATA020,{"A2_AGENCIA",Iif(Alltrim((cArqSA2)->A2_AGENCIA)== "(null)",'',Alltrim((cArqSA2)->A2_AGENCIA)),Nil})
			aAdd(aMATA020,{"A2_XDIGAG",Iif(Alltrim((cArqSA2)->A2_XDIGAG)== "(null)",'',Alltrim((cArqSA2)->A2_XDIGAG)),Nil})			
			aAdd(aMATA020,{"A2_NUMCON",Iif(Alltrim((cArqSA2)->A2_NUMCON)== "(null)",'',Alltrim((cArqSA2)->A2_NUMCON)),Nil})
			aAdd(aMATA020,{"A2_XDIGCON",Iif(Alltrim((cArqSA2)->A2_XDIGCON)== "(null)",'',Alltrim((cArqSA2)->A2_XDIGCON)),Nil})

			aSA2Prod	:= {}
			For nAuxPos	:= 1 To Len(aPosSA2)
				nPSA2 := aScan(aMATA020, {|x| AllTrim(x[1]) == AllTrim(aPosSA2[nAuxPos][1])  } )
				If nPSA2 == 0
					Loop
				EndIf
				Aadd(aSA2Prod, aClone(aMATA020[nPSA2]) )
				
				If aPosSA2[nAuxPos][3] == "C"
					aSA2Prod[Len(aSA2Prod)][2] := PadR(aSA2Prod[Len(aSA2Prod)][2],aPosSA2[nAuxPos][4])
				EndIf
				
			Next
			
			oModel	:= nil
			oModel := FwLoadModel("MATA020M")
			oModel:SetOperation(3)
			oModel:Activate()
			
			For nNewObj := 1 To Len(aMATA020)
				If ValType(aMATA020[nNewObj][2]) == "C"
					&('oModel:SetValue("SA2MASTER","'+aSA2Prod[nNewObj][1]+'" ,"'+aSA2Prod[nNewObj][2]+'")')
				Else	
					&('oModel:SetValue("SA2MASTER","'+aSA2Prod[nNewObj][1]+'" ,'+cValToChar(aSA2Prod[nNewObj][2])+')')
				EndIf
			Next nNewObj
			/*
			MSExecAuto({|x,y| Mata020(x,y)},aSA2Prod,3) //Inclusao
			*/

			If oModel:VldData()
		        oModel:CommitData()
		    Else
		        aLog := oModel:GetErrorMessage()
				 cLog := ""	
		        For nX := 1 To Len(aLog)
		            If !Empty(aLog[nX])
		                cLog += Alltrim(aLog[nX]) + CRLF
		            EndIf
		        Next nX
		
		       lMsErroAuto := .T.
		        lRet := .F.
		
		        AutoGRLog(cLog)
		    EndIf
		
		    oModel:DeActivate()

		Else
			lAchou := .T.
			If Empty(SA2->A2_XCODOLD) .or. alltrim(SA2->A2_XCODOLD) <> alltrim(cCodOld) //PREENCHE OU ATUALIZA O XCODOLD
				Reclock("SA2",.F.)
				SA2->A2_XCODOLD := cCodOld
				MsUnlock()
			Endif
		EndIf
		
		If !lMsErroAuto
			
			//ConfirmSX8()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³GRAVA NA VIEW 'TT_I11_FLAG_VIEW' O REGISTRO IMPORTADO³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQueryINS := " INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) VALUES ('TT_I02_FORNECEDOR','A2_XCODOLD','"+ALLTRIM(cCodOld)+"','"+xFilial("SA2")+"' ) "
			TCSqlExec(cQueryINS)
		Else 
			lErro := .T.
			cFile := "Fornecedor - CodGen "+alltrim(cCodOld)+".log"
			RotMens("Erro no MATA020","","")
			MostraErro(cPath,cFile)
			lMsErroAuto := .F.
			lMSHelpAuto	:= .F.
			
			//aAdd(aLog, {cPath+cFile, "Verifique o LOG gerado"})
			//DisarmTransaction()
			//Rollbacksx8()
		Endif
		
		(cArqSA2)->(DbSkip())
	EndIf
EndDo

If Select(cArqSA2) > 0
	dbSelectArea(cArqSA2)
	dbCloseArea()
EndIf

If !lErro
	RotMens("Importação Finalizada com sucesso!","Aviso","2")
	//	MsgInfo("Importação Finalizada com sucesso!","Aviso")
Else
	RotMens("Ocorreram erros na importação. Consulte o log de erro em "+cPath+" e avise o TI.","Atenção","1")
	//	MsgBox("Ocorreram erros na importação. Consulte o log de erro em "+cPath+" e avise o TI.","Atenção")
Endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI002   ºAutor  ³Microsiga           º Data ³  04/09/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ BUSCA ACENTUAÇÃO E ALTERA                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION NoAcento(cString)

/*
Local cChar  := ""
Local nX     := 0
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
Local cTio   := "ãõ"
Local cCecid := "çÇ"

cString := AllTrim(cString)

For nX:= 1 To Len(cString)
cChar:=SubStr(cString, nX, 1)
IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
nY:= At(cChar,cAgudo)
If nY > 0
cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
EndIf
nY:= At(cChar,cCircu)
If nY > 0
cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
EndIf
nY:= At(cChar,cTrema)
If nY > 0
cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
EndIf
nY:= At(cChar,cCrase)
If nY > 0
cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
EndIf
nY:= At(cChar,cTio)
If nY > 0
cString := StrTran(cString,cChar,SubStr("ao",nY,1))
EndIf
nY:= At(cChar,cCecid)
If nY > 0
cString := StrTran(cString,cChar,SubStr("cC",nY,1))
EndIf
Endif
Next

cString := UPPER(cString)
*/
Return(cString)


Static Function VerCod()

cMax := GetSx8Num("SA2")
ROLLBACKSX8()

dbSelectArea("SA2")
dbSetOrder(1)
lFind := .T.
Do While lFind .and. cCodigo < cMax //enquanto achar registro com o codigo pesquisado e o codigo for menor que o getsx8num
	If !dbSeek(xFilial("SA2")+cCodigo) //testa a chave
		lFind := .F. //se achar, desabilita pesquisa
	Else
		cCodigo := Soma1(cCodigo) //soma o codigo
	Endif
Enddo
If cCodigo >= cMax
	cCodigo := GetSx8Num("SA2")
Endif

Return(cCodigo)


Static Function VldCodOld(cCodOld,cCodFor,cLojaFor)

Local lRet	:= .F.

cCodFor	:= ""
cLojaFor	:= ""

If Select("XCODOLD") > 0
	XCODOLD->(DbCloseArea())
EndIf
BeginSql Alias "XCODOLD"
	SELECT A2_COD,A2_LOJA 
	FROM %Table:SA2% SA2
	WHERE A2_FILIAL = %xFilial:SA2%
	AND Trim(A2_XCODOLD) = %Exp:cCodOld%
	AND SA2.%NotDel%				 
EndSql
XCODOLD->(DbGoTop())
If XCODOLD->(!EOF())
	lRet		:= .T.
	cCodFor	:= XCODOLD->A2_COD
	cLojaFor	:= XCODOLD->A2_LOJA
EndIf
XCODOLD->(DbCloseArea())
Return lRet 