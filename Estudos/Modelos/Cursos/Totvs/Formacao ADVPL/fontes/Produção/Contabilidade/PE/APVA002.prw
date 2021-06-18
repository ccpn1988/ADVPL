#include "rwmake.ch"
#include "tbicode.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³APVA002   ºAutor  ³Rafael Lima         º Data ³  10/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para montagem da grade de aprovacao da efetivacao    º±±
±±º          ³de lançamento contabil.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function APVA002(aPar)

Local 	aArea		:= GetArea()
Local 	aAreaCT2	:= CT2->(GetArea())
Local 	nTotal		:= 0
Private cGrpEfe		:= GetNewPar('MV_XGRPEFE','EFELCT')
Private	cChave		:= xFilial("CT2")+DTOS(aPar[2])+aPar[3]+aPar[4]+aPar[5]
Private aVetLct		:= {}

DbSelectArea("CT2")
DbSetOrder(1)
If DbSeek(cChave)
	Do While CT2->(!EOF()) .And. CT2->CT2_FILIAL+DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC == cChave
		
		nTotal	+= CT2->CT2_VALOR
		aAdd(aVetLct,{CT2->CT2_LINHA,CT2->CT2_DC,CT2->CT2_DEBITO,CT2->CT2_CREDIT,CT2->CT2_VALOR,CT2->CT2_HIST,__cUserId,CT2->CT2_DATA})
		
		RecLock("CT2",.F.)
		CT2->CT2_XAPROV := 'A'
		CT2->(MsUnLock())
		
		CT2->(DbSkip())
	EndDo
Endif
RestArea(aAreaCT2)

//Montagem das alçadas
If aPar[1] == 4 .Or. aPar[1] == 5 .Or. aPar[1] == 6//Executar na Alteração, Exclusão e Estorno
	//Funcao que deleta os registros do SCR
	MaAlcDoc({cChave,"EF",nTotal,,,cGrpEfe,,,,," "},dDataBase,3)
Endif
If aPar[1] == 4 .Or. aPar[1] == 3 .Or. aPar[1] == 7//Executar na Alteração, Inclusão e Cópia
	//Funcao que cria(monta) os registros do SCR
	MaAlcDoc({cChave,"EF",nTotal,,,cGrpEfe,,,,," "},dDataBase,1)
Endif
U_WfEfe()

RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³WfEfe     ºAutor  ³Rafael Lima         º Data ³  10/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para montar os HTML's a serem enviados para os      º±±
±±º          ³ aprovadores                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WfEfe

Local aMails	:= {}
Local i

aMails := u_AprovEfe(cChave)

If len(aMails) = 0
	Aviso("A T E N Ç Ã O","Não foi montada nenhuma grade de aprovação para esse título. Verifique o parâmetro MV_XGRPEFE.", {"Ok"})
	Return
Endif

cWFBRWS	:= AllTrim(GetMv('MV_WFBRWSR'))

For i:=1 to len(aMails)
	cAssunto := "Autorizacao de Liberacao para Efetivacaoo"
	cTitHtm := "Autorizacao de Liberacao para Efetivacao"
	
	//Gravar Pasta
	cCodPasta	:= "efelct"
	Op:=Twfprocess():New("efelct","Aprovacao de Efetivacao de Lancamento")
	Op:NewTask("efelct","/html/aprovlote.htm") //Nome do HTML para montagem dos dados
	Op:oHtml:Valbyname("APROVADOR"  , aMails[i,4])
	oP:oHtml:ValByName( "CHAVE", cChave)
	oP:oHtml:ValByName( "CFILANT", cFilAnt)
//	oP:oHtml:ValByName( "CMAILUSER", amails[i,2])
	//oP:oHtml:ValByName( "RECNO", SE2->(Recno()))
	
	Montaemail()
	Op:cSubject := cAssunto
	Op:cTo := cCodPasta
	oP:bReturn := "U_LibEfe()"
	cMailID := oP:Start()
	
	//Mandar Link
	cIdProc	:="emp"+cEmpAnt+"/efelct/"+cMailID
	oP:= TWFProcess():New("efelct","Aprovacao de Efetivacao de Lancamento")
	oP:NewTask("efelct","/html/linkle.htm") //Nome do HTML para envio do LINK
	Op:cSubject := cAssunto
	Op:cTo := aMails[i,2]
	Op:ohtml:ValByName("usuario",xfRetName(amails[i,1]))
	Op:ohtml:ValByName("proc_link","http://"+cWFBRWS+"/messenger/emp"+cEmpAnt+"/efelct/" + cMailID + ".htm")
	Op:ohtml:ValByName("link","http://"+cWFBRWS+"/messenger/emp"+cEmpAnt+"/efelct/" + cMailID + ".htm")
	Op:ohtml:ValByName("titulo","http://"+cWFBRWS+"/messenger/emp"+cEmpAnt+"/efelct/" + cMailID + ".htm")
	oP:Start()
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Montaemail ºAutor ³Rafael Lima         º Data ³  10/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para montar os dados do titulo de acordo com o layout±±
±±º          ³ do HTML                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Montaemail()

Local nX:= 0
//Dados do usuário
Op:oHtml:Valbyname("solicitante"	,UsrFullName(aVetLct[1][7]))
Op:oHtml:Valbyname("emissao"   		,aVetLct[1][8])

//Itens
For nX:=1 To Len(aVetLct)
	AAdd((op:oHtml:ValByName( "t1.1"    )), aVetLct[nX][1]) //Linha
	AAdd((op:oHtml:ValByName( "t1.2"    )), aVetLct[nX][2]) //Tipo Lcto
	AAdd((op:oHtml:ValByName( "t1.3"    )), aVetLct[nX][3]) //Cta Debito
	AAdd((op:oHtml:ValByName( "t1.4"    )), aVetLct[nX][4]) //Cta Credito
	AAdd((op:oHtml:ValByName( "t1.5"    )), aVetLct[nX][5]) //Valor
	AAdd((op:oHtml:ValByName( "t1.6"    )), aVetLct[nX][6])//Obs
Next

//Processo de aprovacao
DBSelectarea("SCR")
DBSetOrder(1)
If DbSeek(xFilial("SCR")+"EF"+cChave)
	Do While Alltrim(SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM) == xFilial("SCR")+"EF"+cChave  .and. SCR->(!Eof())
		
		cSituaca := ""
		Do Case
			Case SCR->CR_STATUS == "01"
				cSituaca := "Aguardando"
			Case SCR->CR_STATUS == "02"
				cSituaca := "Em Aprovacao"
			Case SCR->CR_STATUS == "03"
				cSituaca := "Aprovado"
			Case SCR->CR_STATUS == "04"
				cSituaca := "Reprovado"
				lBloq := .T.
			Case SCR->CR_STATUS == "05"
				cSituaca := "Nivel Liberado"
		EndCase
		
		_cT4 := Upper(UsrRetName(SCR->CR_USERLIB))
		_cT6 := SCR->CR_OBS

		cUsrName := UsrRetName(SCR->CR_USER)		
		
		AAdd( (op:oHtml:ValByName( "t2.1"    )), SCR->CR_NIVEL)
		AAdd( (op:oHtml:ValByName( "t2.2"    )), Upper(cUsrName))
		AAdd( (op:oHtml:ValByName( "t2.3"    )), cSituaca    )
		AAdd( (op:oHtml:ValByName( "t2.4"    )), IIF(EMPTY(_cT4),"", _cT4))
		AAdd( (op:oHtml:ValByName( "t2.5"    )), DTOC(SCR->CR_DATALIB))
		AAdd( (op:oHtml:ValByName( "t2.6"    )), IIF(EMPTY(_cT6),"", _cT6))
		
		dbSelectArea("SCR")
		SCR->(dbSkip())
	EndDo
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AprovEfe  ºAutor  ³Rafael Lima         º Data ³  10/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para listar os aprovadores que foram selecionados   º±±
±±º          ³ para o lote contabil                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AprovEfe(cChave)

Local aMails 	:= {}
Local cQuery	:= ""
Local ArqSCR	:= GetNextAlias()
PRIVATE cMailUser

cQuery := " SELECT CR_FILIAL, CR_TIPO, CR_USER ,CR_NUM, CR_APROV,R_E_C_N_O_ FROM "+RetSqlName("SCR")+" (NOLOCK) "
cQuery += " WHERE D_E_L_E_T_ = ' ' "
cQuery += " AND CR_FILIAL = "+ValToSql(xFilial("SCR"))
cQuery += " AND CR_STATUS = '02' "
cQuery += " AND CR_WF = ' ' "
cQuery += " AND CR_TIPO = 'EF' "
cQuery += " AND CR_NUM = "+ValToSql(cChave)

If Select(ArqSCR) > 0
	dbSelectArea(ArqSCR)
	dbCloseArea()
EndIf

cQuery := CHANGEQUERY(cQuery)
dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery), ArqSCR ,.T.,.T.)


DbSelectArea(ArqSCR)
(ArqSCR)->(dbGoTop())

Do While !(ArqSCR)->(Eof())
	
	PswOrder(1)
	PswSeek((ArqSCR)->CR_USER,.T.)
	aUser := PswRet(1) //traz o email     
	             
	If aUser[1,14] <> ""
		AADD(amails,{(ArqSCR)->CR_USER,aUser[1,14],(ArqSCR)->R_E_C_N_O_,(ArqSCR)->CR_APROV})
	Endif         
	  
*************************Florence França*************************
	If !Empty(aUser[1,14] )
		cMailUser := ALLTRIM(aUser[1,14])
	Endif
*****************************************************************

	(ArqSCR)->(DbSkip())
EndDo

Return(aMails)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LibEfe     ºAutor ³Rafael Lima         º Data ³  20/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para executar o retorno do e-mail                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LibEfe(oP)

Local aArea			:= GetArea()
Local cCodFil   	:= AllTrim(oP:oHtml:RetByName('CFILANT'))
Local cCodApr   	:= AllTrim(oP:oHtml:RetByName('APROVADOR'))
Local cResp    		:= Iif(Upper(oP:oHtml:RetByName('OPC'))="S","S","N")
Local cGrupo
Local cObs      	:= alltrim(oP:oHtml:RetByName("OBS"))
//Local cRecno		:= oP:oHtml:RetByName('RECNO')
Local cQryAtu		:= ""
Local aAreaCT2		:= {}
Local nTotal		:= 0
Private cMailUser	:= AllTrim(oP:oHtml:RetByName('cMailUser'))
Private aVetLct		:= {}
Private cChave	   	:= AllTrim(oP:oHtml:RetByName('CHAVE'))
Private cAssunto	:= "Efetivação de Lançamento "+cChave

ConOut('Executando Retorno')
ConOut('Chave: ' +cCodFil+cChave)
Conout('Variavel cResp Inicio'+cResp)

cCodUsr 	:= Posicione("SAK",1,xFilial("SAK")+cCodApr,"AK_USER")
cNomeUsu	:= UsrFullName(cCodUsr)

//Posicionar no lote contabil
DbSelectArea("CT2")
DbSetOrder(1)
If DbSeek(cChave)

cFilCt2		:= CT2->CT2_FILIAL 
dDataLanc 	:= CT2->CT2_DATA    
cLote		:= CT2->CT2_LOTE
cSubLote	:= CT2->CT2_SBLOTE
cDoc		:= CT2->CT2_DOC
			
	cGrupo 		:=  AllTrim(GetMv('MV_XGRPEFE'))
	aAreaCT2	:= CT2->(GetArea())
	Conout('Entrei no DbSeek do CT2')
	ConOut("Lote Posicionado: " + CT2->CT2_FILIAL+DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC)
	
	Do While CT2->(!EOF()) .And. CT2->CT2_FILIAL+DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC == cChave
		
		nTotal	+= CT2->CT2_VALOR
		aAdd(aVetLct,{CT2->CT2_LINHA,CT2->CT2_DC,CT2->CT2_DEBITO,CT2->CT2_CREDIT,CT2->CT2_VALOR,CT2->CT2_HIST,__cUserId,CT2->CT2_DATA})
		
		CT2->(DbSkip())
	EndDo
	RestArea(aAreaCT2)
	
	Conout('Codigo do usuario '+cCodUsr+'-----'+cNomeUsu)
	//Processar liberacao
	aTam := TamSX3("CR_NUM")
	DbSelectArea("SCR")
	DbSetOrder(2)
	If DbSeek(xFilial("SCR")+'EF'+cChave+Space(aTam[1]-Len(cChave))+cCodUsr)
		
		Conout("Entrou no SCR")
		nTotal 	:= SCR->CR_TOTAL
		cNumCT2	:= SCR->CR_NUM
		
		Conout('Variavel cResp '+cResp)
		If cResp = 'S'
			lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodApr,,cGrupo,,,,,cObs},dDataBase,If(cResp=='S',4,6))
			Conout(lLiberou)
			Conout('SCR->CR_NUM '+SCR->CR_NUM)
			Conout('SCR->CR_TIPO '+SCR->CR_TIPO)
			Conout(nTotal)
			Conout('cCodApr '+cCodApr)
			Conout('cGrupo '+cGrupo)
			CONOUT("LIBEROU")
		Else
			lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodApr,,cGrupo,,,,,cObs},dDataBase,If(cResp=='S',4,6))
			Conout(lLiberou)
			Conout('SCR->CR_NUM '+SCR->CR_NUM)
			Conout('SCR->CR_TIPO '+SCR->CR_TIPO)
			Conout(nTotal)
			Conout('cCodApr '+cCodApr)
			Conout('cGrupo '+cGrupo)
			CONOUT("BLOQUEOU")
		EndIf
		
		
		If lLiberou
			
			Conout('Registro Liberado')
			Conout('Tipo de Liberacao: '+SCR->CR_TIPO)
			
			If SCR->CR_TIPO == "EF"
				
				Conout('Vou todas as linhas do lote')
				Conout('SCR->CR_NUM '+SCR->CR_NUM)
				
				dbSelectArea("CT2")
				dbSetOrder(1)
				If DbSeek(cChave)
								
					cQryAtu	:= " UPDATE "+RetSqlName("CT2")+" SET CT2_XAPROV = 'S' "					
					cQryAtu	+= " WHERE D_E_L_E_T_ <> '*' "
					cQryAtu	+= " AND CT2_FILIAL = '"+cFilCt2+"' "
					cQryAtu	+= " AND CT2_DATA = '"+DtoS(dDataLanc)+"' "
					cQryAtu	+= " AND CT2_LOTE = '"+cLote+"' "
					cQryAtu	+= " AND CT2_SBLOTE = '"+cSubLote+"' "															
					cQryAtu	+= " AND CT2_DOC = '"+cDoc+"' "																				
					Conout(cQryAtu)
					cQryAtu := TcSqlExec(cQryAtu)
				                                 
					Conout('Atualizei e vou enviar aviso de liberacao')
					
					//Função de Aviso de Liberação
					U_AvisoLib("S",cNomeUsu,"Liberacação de Efetivação ","S")
				Else
					Conout('Nao consegui entrar no IF para atualizar: '+SCR->CR_NUM)
				EndIf
			EndIf
			
			
		ElseIf !lLiberou .and. cResp = "S"
			
			Conout('Registro Liberado para outros niveis')
			Conout(lLiberou)
			
			c_Recno := SCR->(Recno()) //Gravar Recno Atual
			c_NvOrg	:= SCR->CR_NIVEL
			
			DbSelectArea("SCR")
			DbSetOrder(1)
			DbSeek(xFilial("SCR")+'EF'+cChave)		

			While !Eof() .And. (xFilial("SCR")+'EF'+cChave = AllTrim(SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM))
				Conout('Nível c_NvOrg '+c_NvOrg)
				Conout('Nível SCR->CR_NIVEL '+SCR->CR_NIVEL) 
			
				If Empty(SCR->CR_DATALIB).and. c_NvOrg <> SCR->CR_NIVEL

					Conout("Entrou no if...")
										
					c_Nivel := ""
					Do Case
						Case SCR->CR_NIVEL == "01"
							c_Nivel := "C"
						Case SCR->CR_NIVEL == "02"
							c_Nivel := "A"
						Case SCR->CR_NIVEL == "03"
							c_Nivel := "F"
						Case SCR->CR_NIVEL == "04"
							c_Nivel := "S"
					EndCase
					
					// Envio novamente para aprovação
					CT2->(dbSeek(cChave))
					
					conout(":-) Chamara novamente a fc de Envio WF....")
					
					U_WfEfe()
					lContinua := .T.
					Conout("Entrou no if E DEU EXIT")					
					Exit 
				ELSE
				    Conout("Não entrou no IF...") 
				EndIf
				DbSelectArea("SCR")
				DbSkip()
			End
			
			//Reposiciona SCR
			DbSelectArea("SCR")
			DbGoTo(c_Recno)
			
			// Envio novamente para aprovação
			CT2->(dbSeek(cChave))
			
		Else // REJEITOU
			
			Conout('Registro Rejeitado')
			
			If SCR->CR_TIPO == "EF"
				dbSelectArea("CT2")
				dbSetOrder(1)
				If DbSeek(cChave)
					
					
					cQryAtu	:= " UPDATE "+RetSqlName("CT2")+" SET CT2_XAPROV = 'N' "					
					cQryAtu	+= " WHERE D_E_L_E_T_ <> '*' "
					cQryAtu	+= " AND CT2_FILIAL = '"+cFilCt2+"' "
					cQryAtu	+= " AND CT2_DATA = '"+DtoS(dDataLanc)+"' "
					cQryAtu	+= " AND CT2_LOTE = '"+cLote+"' "
					cQryAtu	+= " AND CT2_SBLOTE = '"+cSubLote+"' "															
					cQryAtu	+= " AND CT2_DOC = '"+cDoc+"' "																				
					Conout(cQryAtu)
					cQryAtu := TcSqlExec(cQryAtu)
					
					
					Conout('Atualizei e vou enviar aviso de rejeicao')
					
					//Função de Aviso de Liberação
					U_AvisoLib("N",cNomeUsu,"Liberacação de Efetivação ","N")
				Else
					Conout('Nao consegui entrar no IF para atualizar: '+SCR->CR_NUM)
				EndIf
				
				
			EndIf
			
		EndIf
	Else
		Conout("Aprovadores do lote " + cChave + " nao encontrado")
	EndIf
	
	ConOut('Termino da Execucao do Retorno')
Else
	ConOut('Nao deu o Seek')
Endif
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AvisoLib   ºAutor ³Rafael Lima         º Data ³  20/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para envio do aviso de liberacao.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AvisoLib(cAprov,cNomeUsu,cAssunto,cResp)

//Local lRet         := .F.
//Local aDados 	   := {}                                                   

ConOut("Entrou na funcao de aviso!!!")

cSubject := "Lote : " + cChave + Iif(cResp == "S"," Liberado"," Nao Liberado")
cTitHtm  := "Lote : " + cChave + Iif(cResp == "S"," Liberado"," Nao Liberado")

Conout(cSubject)



Op:=Twfprocess():New("efelct","Aviso de Liberacao de Efetivacao de Lancamento")
Conout("1...")
Op:NewTask("efelct","/html/avisolote.htm")
Op:cSubject := cSubject
Conout("2...")
Op:oHtml:Valbyname("aprovado"  , IIf(cResp == "S","Liberado","Nao Liberado"))
Op:oHtml:Valbyname("M0_NOME"  , SM0->M0_NOMECOM)
Montaemail()
Conout("3...")    
Conout(cMailUser)    
	
oP:bReturn  := "" 
oP:cTo:= cMailUser
oP:Start()
op:Finish()

Return

User Function xfRetName(cUserGen)

Local cRet	:= ""
cRet := UsrFullName(cUserGen)

Return(cRet)