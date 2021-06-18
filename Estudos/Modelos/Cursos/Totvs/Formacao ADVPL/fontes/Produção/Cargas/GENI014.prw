#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"
#DEFINE   cEnt      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI014   ºAutor  ³Vinicius Lança      º Data ³  12/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de importação de Lançamentos Mensais                 º±±
±±º          ³                                                            º±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºAlteração ³Autor  ³Joni Fujiyama                  º Data ³  09/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina foi adaptada para rodar por schedule.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//      21/08/2012 - Alteração - Flávio Bezerra - Alterada gravação dos registros da Tabela padrão SRC para a Tabela especifica SZ1
//		para tratamento de registros duplicados gerados pela View.

User Function GENI014()

Private cFunName := PROCNAME()

If MsgYesNo("Esta rotina fará a importação de Lançamentos Mensais. Deseja continuar?","Atenção")
	Processa({||LeviewLM()})
EndIf

Return()


User Function GENI014A()

Local lRotMens:=.F.
Private cFunName := PROCNAME()

Prepare Environment Empresa "00" Filial "1001"
RotMens("Executando a rotina ==> " + cFunName,"","")
lRotMens := RotMens("Iniciando o Schedule ...","","")
LeviewLM()
lRotMens := RotMens("Fim do Schedule ...","","")
Reset Environment

Return()


/**************************************************************************************************
Mostra a mensagem na tela ou no console			Autor: Joni Fujiyama		Data:02/07/2014
**************************************************************************************************/
Static Function RotMens(pTexto1,pTexto2,pTexto3,pTipo)

IF cFunName == "U_GENI014"
	DO CASE
		Case pTipo = "1"
			MSGBOX(pTexto1,pTexto2)
		Case pTipo = "2"
			MSGINFO(pTexto1,pTexto2)
		Case pTipo = "3"
			AVISO(pTexto1,pTexto2,pTexto3)
		Case pTipo = "4"
			ALERTA(pTexto1,pTexto2)
		Case pTipo = "5"
			Return AVISO(pTexto1,pTexto2,pTexto3)
	ENDCASE
ELSE
	IF cFunName == "U_GENI014A"
		Conout(pTexto1)
	ENDIF
ENDIF

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI014   ºAutor  ³Vinicius Lança      º Data ³  12/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de importação de Lançamentos Mensais                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LeviewLM()

Local lErro       	:= .F.
Local lLog        	:= .F.
Local nItens  	  	:= 0
Local cFilBkp 	  	:= cFilant //Para salvar a filial original
Local cPath   	  	:= "\LogSiga\lancmensais\"
Local cFile   	  	:= ""
Local cQuery
Local nTotReg 	  	:= 0
Private aLog	  	:= {}
//Private cAliasSX5 := GetNextAlias()
Private cAliasSRA := GetNextAlias()
Private cAliasCTH := GetNextAlias()
Private cAliasCTD := GetNextAlias()

nImport := 0
nNaoImp := 0
nProces := 0

cQuery := " SELECT * FROM TT_I14_LANCAMENTOS_MENSAIS"

If Select("TMP") > 0
	dbSelectArea("TMP")
	dbCloseArea()
EndIf

TcQuery cQuery Alias "TMP" New
Count TO nTotReg // Conta Registro
dbSelectArea("TMP")
dbGoTop()
IF cFunName == "U_GENI014"
	ProcRegua(nTotReg) // Numero de registros a processar
ENDIF
nItens:= 0
While !TMP->(Eof())
	
	nItens++
	lErro := .F.
	
	c_Item := alltrim(IIF(TMP->RC_ITEM == '0','000000',cvaltochar(TMP->RC_ITEM)))
	c_CLVL := alltrim(IIF(TMP->RC_CLVL == 0,'000000000',cvaltochar(TMP->RC_CLVL)))
	c_Matr := cvaltochar(TMP->RC_MAT)
	cRoteir:= space(tamsx3("RC_ROTEIR")[1])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Incrementa a regua                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF cFunName == "U_GENI014"
		IncProc("Importando Lançamentos Mensais...  Linha "+cValtoChar(nItens))
	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca descrição do serviço. Cadastro de Insumos  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*--------------------------------------------------*
	*                GRAVA LOGS DE ERRO                *
	*--------------------------------------------------*
	
	If TMP->RC_FILIAL == "(null)" .OR. TMP->RC_FILIAL = ' '
		
		cHora := Time()
		cHora := Substr(cHora,1,2)+"h"+Substr(cHora,4,2)+"m"+Substr(cHora,7,2)+"s"
		cFile := "Erro Importação de Lançamentos Mensais " + Dtos(dDatabase) + " - " + cHora  + ".log"
		cMsg	:= "Filial em branco " + cEnt + cEnt
		cMsg	+= "Filial....: " + Alltrim(TMP->RC_FILIAL) 	+ cEnt
		cMsg	+= "Matricula.: " + c_Matr					+ cEnt
		cMsg	+= "Nome......: " + TMP->RC_NOME 	+ cEnt
		cMsg	+= "Insumo....: " + c_Item				 	+ cEnt
		cMsg	+= "Proj./Obra: " + c_CLVL				 	+ cEnt
		cMsg	+= "Valor:      " + TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")   	 	+ cEnt
		
		//Grava log em disco
		MemoWrite(cpath+cFile,cMsg)
		
		//Grava array para impressão
		aAdd(aLog, {cPath,"Filial em branco"," ",c_Matr,TMP->RC_NOME,c_Item,c_CLVL,TMP->RC_CC,TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")})
		
		lErro := lLog := .T.
		
	ElseIf TMP->RC_PD == "(null)" .OR. TMP->RC_PD = ' '
		
		cHora := Time()
		cHora := Substr(cHora,1,2)+"h"+Substr(cHora,4,2)+"m"+Substr(cHora,7,2)+"s"
		cFile := "Erro Importação de Lançamentos Mensais " + Dtos(dDatabase) + " - " + cHora  + ".log"
		cMsg	:= "Código da Verba em branco " + cEnt + cEnt
		cMsg	+= "Filial....: " + AllTrim(TMP->RC_FILIAL) 	+ cEnt
		cMsg	+= "Matricula.: " + c_Matr					+ cEnt
		cMsg	+= "Nome......: " + TMP->RC_NOME 	+ cEnt
		cMsg	+= "Insumo....: " + c_Item				 	+ cEnt
		cMsg	+= "Proj./Obra: " + c_CLVL				 	+ cEnt
		cMsg	+= "Valor:      " + TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")   	 	+ cEnt
		
		//Grava log em disco
		MemoWrite(cpath+cFile,cMsg)
		
		//Grava array para impressão
		aAdd(aLog, {cPath,"Código da Verba em branco ",AllTrim(TMP->RC_FILIAL),c_Matr,TMP->RC_NOME,c_Item,c_CLVL,TMP->RC_CC,TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")})
		
		lErro := lLog := .T.
		
	ElseIf TMP->RC_NOME == "(null)" .OR. TMP->RC_NOME = ' '
		
		cHora := Time()
		cHora := Substr(cHora,1,2)+"h"+Substr(cHora,4,2)+"m"+Substr(cHora,7,2)+"s"
		cFile := "Erro Importação de Lançamentos Mensais " + Dtos(dDatabase) + " - " + cHora  + ".log"
		cMsg	:= "Nome em branco " + cEnt + cEnt
		cMsg	+= "Filial....: " + AllTrim(TMP->RC_FILIAL) 	+ cEnt
		cMsg	+= "Matricula.: " + c_Matr					+ cEnt
		cMsg	+= "Nome......: " + TMP->RC_NOME 	+ cEnt
		cMsg	+= "Insumo....: " + c_Item				 	+ cEnt
		cMsg	+= "Proj./Obra: " + c_CLVL				 	+ cEnt
		cMsg	+= "Valor:      " + TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")   	 	+ cEnt
		
		//Grava log em disco
		MemoWrite(cpath+cFile,cMsg)
		
		//Grava array para impressão
		aAdd(aLog, {cPath,"Nome em branco",AllTrim(TMP->RC_FILIAL),c_Matr," ",c_Item,c_CLVL,TMP->RC_CC,TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")})
		
		lErro := lLog := .T.
		/*	ElseIf TMP->RC_MAT == "(null)" //.OR. TMP->RC_MAT = ' '
		
		cHora := Time()
		cHora := Substr(cHora,1,2)+"h"+Substr(cHora,4,2)+"m"+Substr(cHora,7,2)+"s"
		cFile := "Erro Importação de Lançamentos Mensais " + Dtos(dDatabase) + " - " + cHora  + ".log"
		cMsg	:= "Matrícula em branco " + cEnt + cEnt
		cMsg	+= "Filial....: " + AllTrim(TMP->RC_FILIAL) 	+ cEnt
		cMsg	+= "Matricula.: " + c_Matr					+ cEnt
		cMsg	+= "Nome......: " + TMP->RC_NOME 	+ cEnt
		cMsg	+= "Insumo....: " + c_Item				 	+ cEnt
		cMsg	+= "Proj./Obra: " + c_CLVL				 	+ cEnt
		
		//Grava log em disco
		MemoWrite(cpath+cFile,cMsg)
		
		//Grava array para impressão
		aAdd(aLog, {cPath,"Matrícula em branco",AllTrim(TMP->RC_FILIAL)," ",TMP->RC_NOME,c_Item,c_CLVL,TMP->RC_CC})
		
		lErro := lLog := .T.
		*/
		
	ElseIf TMP->RC_VALOR == 0
		
		cHora := Time()
		cHora := Substr(cHora,1,2)+"h"+Substr(cHora,4,2)+"m"+Substr(cHora,7,2)+"s"
		cFile := "Erro Importação de Lançamentos Mensais " + Dtos(dDatabase) + " - " + cHora  + ".log"
		cMsg	:= "Sem Valor " + cEnt + cEnt
		cMsg	+= "Filial....: " + AllTrim(TMP->RC_FILIAL) 	+ cEnt
		cMsg	+= "Matricula.: " + c_Matr	   				+ cEnt
		cMsg	+= "Nome......: " + TMP->RC_NOME 	+ cEnt
		cMsg	+= "Insumo....: " + c_Item				 	+ cEnt
		cMsg	+= "Proj./Obra: " + c_CLVL				 	+ cEnt
		cMsg	+= "Valor:      " + TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")   	 	+ cEnt
		
		//Grava log em disco
		MemoWrite(cpath+cFile,cMsg)
		
		//Grava array para impressão
		aAdd(aLog, {cPath,"Sem Valor ",AllTrim(TMP->RC_FILIAL),c_Matr,TMP->RC_NOME,c_Item,c_CLVL,TMP->RC_CC,TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")})
		
		lErro := lLog := .T.
		
	Else
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Busca descrição do serviço pelo codigo do insumo na tabela ZH  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//cQuery := "SELECT X5_TABELA, X5_CHAVE, X5_DESCRI FROM "+RetSqlName("SX5")+" WHERE X5_TABELA = 'ZH' AND X5_CHAVE = '"+c_Item+"'"
		cDescZH := FWGetSX5("ZH",c_Item)[1,4]
		
		//VERIFICA SE ALIAS ESTA ABERTO E FECHA
		/*
		If Select(cAliasSX5) > 0
			dbSelectArea(cAliasSX5)
			dbCloseArea()
		EndIf
		
		DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliasSX5, .F., .T.)
		*/
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe o insumo no Protheus, caso não gera log ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(cDescZH)//(cAliasSX5)->(Eof())
			cHora := Time()
			cHora := Substr(cHora,1,2)+"h"+Substr(cHora,4,2)+"m"+Substr(cHora,7,2)+"s"
			cFile := "Erro Importação de Lançamentos Mensais " + Dtos(dDatabase) + " - " + cHora  + ".log"
			cMsg	:= "Código do Item (Insumo) não encontrado no Protheus " + cEnt + cEnt
			cMsg	+= "Filial....: " + AllTrim(TMP->RC_FILIAL) 	+ cEnt
			cMsg	+= "Matricula.: " + c_Matr					+ cEnt
			cMsg	+= "Nome......: " + TMP->RC_NOME 	+ cEnt
			cMsg	+= "Insumo....: " + c_Item				 	+ cEnt
			cMsg	+= "Proj./Obra: " + c_CLVL				 	+ cEnt
			cMsg	+= "Valor:      " + TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")   	 	+ cEnt
			
			//Grava log em disco
			MemoWrite(cpath+cFile,cMsg)
			
			//Grava array para impressão
			aAdd(aLog, {cPath,"Cód.Item(Insumo) não encontrado no Protheus ",AllTrim(TMP->RC_FILIAL),c_Matr,TMP->RC_NOME,c_Item,c_CLVL,TMP->RC_CC,TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")})
			lErro := lLog := .T.
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Busca código do autônomo no protheus utilizando o código GEN ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery := " SELECT RA_MAT FROM "+RetSqlName("SRA")+" WHERE RA_CATFUNC = 'A' AND RA_XCODGEN = '"+c_Matr+"' AND RA_FILIAL = '"+AllTrim(TMP->RC_FILIAL)+"' AND D_E_L_E_T_ <> '*'"
			
			//VERIFICA SE ALIAS ESTA ABERTO E FECHA
			If Select(cAliasSRA) > 0
				dbSelectArea(cAliasSRA)
				dbCloseArea()
			EndIf
			
			DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliasSRA, .F., .T.)
			
			//ARMAZENA MATRICULA DO PROTHEUS
			cMatSRA := (cAliasSRA)->RA_MAT
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe o codigo do autônomo no Protheus ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (cAliasSRA)->(Eof())
				cHora := Time()
				cHora := Substr(cHora,1,2)+"h"+Substr(cHora,4,2)+"m"+Substr(cHora,7,2)+"s"
				cFile := "Erro Importação de Lançamentos Mensais " + Dtos(dDatabase) + " - " + cHora  + ".log"
				cMsg	:= "Matricula não encontrado no Protheus " + cEnt + cEnt
				cMsg	+= "Filial....: " + AllTrim(TMP->RC_FILIAL) 	+ cEnt
				cMsg	+= "Matricula.: " + c_Matr					+ cEnt
				cMsg	+= "Nome......: " + TMP->RC_NOME 	+ cEnt
				cMsg	+= "Insumo....: " + c_Item				 	+ cEnt
				cMsg	+= "Proj./Obra: " + c_CLVL				 	+ cEnt
				cMsg	+= "Valor:      " + TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")   	 	+ cEnt
				
				//Grava log em disco
				MemoWrite(cpath+cFile,cMsg)
				
				//Grava array para impressão
				aAdd(aLog, {cPath,"Matricula não encontrado no Protheus ",AllTrim(TMP->RC_FILIAL),c_Matr,TMP->RC_NOME,c_Item,c_CLVL,TMP->RC_CC,TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")})
				
				lErro := lLog := .T.
			EndIf
		EndIf
	EndIf
	
	If !lErro
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os campos obtendo os valores da linha lidos na view  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		//INICIA TRANSAÇÃO COM O BANCO
		BEGIN TRANSACTION
		
		//Alterado por Flávio Bezerra - 21/08/2012..
		//Importação dos lançamentos mensais de Folha para tabela especifica para tratamento de informações repetidas gerada pela view.
		
		//Valida Matricula no Protheus..
		dbSelectArea("SRA")
		dbSetOrder(1)
		If dbSeek(alltrim(TMP->RC_FILIAL)+cMatSRA)
			dbSelectArea("CTT") //Valida Centro de custo no Protheus..
			dbSetOrder(1)
			If dbSeek(xfilial("CTT")+Alltrim(TMP->RC_CC))
				cQuery := " SELECT CTH_CLVL FROM "+RetSqlName("CTH")+" WHERE CTH_CLVL = '"+Alltrim(c_CLVL)+"' AND D_E_L_E_T_ <> '*'"
				If Select(cAliasCTH) > 0
					dbSelectArea(cAliasCTH)
					(cAliasCTH)->(dbCloseArea())
				EndIf
				DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliasCTH, .F., .T.)
				If !(cAliasCTH)->(Eof())
					//Valida Item contábil no Protheus..
					cQuery := " select R_E_C_N_O_ from "+RetSqlName("CTD")+" where CTD_ITEM = '"+c_Item+"' AND D_E_L_E_T_ <> '*'"
					If Select(cAliasCTD) > 0
						dbSelectArea(cAliasCTD)
						(cAliasCTD)->(dbCloseArea())
					EndIf
					DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliasCTD, .F., .T.)
					If !(cAliasCTD)->(Eof())
						//GRAVA DESCRIÇÃO DO SERVIÇO DO AUTONOMO
						RecLock("SRA",.F.)
						SRA->RA_SERVICO := cDescZH//(cAliasSX5)->X5_DESCRI
						SRA->(MsUnlock())
						//GRAVA LANÇAMENTOS
						lGrava := .T.
						DbselectArea("SZ1")
						cQuery := " SELECT R_E_C_N_O_, Z1_MAT
						cQuery += " FROM " + RetSqlName("SZ1")
						cQuery += " WHERE  Z1_FILIAL   =  '"+SRA->RA_FILIAL+"'"
						cQuery += " AND Z1_MAT         =  '"+SRA->RA_MAT+"'"
						cQuery += " AND Z1_PD          =  '"+ALLTRIM(TMP->RC_PD)+"'"
						//				cQuery += " AND Z1_CC          =  '"+CTT->CTT_CUSTO+"'"
						cQuery += " AND Z1_CC          =  '"+IIF(ALLTRIM(TMP->RC_PD)=="S02",CTT->CTT_CUSTO,SRA->RA_CC)+"'"
						cQuery += " AND Z1_ITEM        =  '"+Alltrim(c_Item)+"'"
						cQuery += " AND Z1_CLASSE      =  '"+Alltrim(c_CLVL)+"'"
						cQuery += " AND Z1_DATA        =  '"+Alltrim(TMP->RC_DATA)+"'"
						cQuery += " AND Z1_SEQ         =  '"+Iif(ALLTRIM(TMP->RC_SEQ) == "(null)",' ',Iif(Len(cvaltochar(TMP->RC_SEQ))==0,' ',cvaltochar(TMP->RC_SEQ)))+"'"
						cQuery += " AND Z1_DATAREF     =  '"+Alltrim(TMP->RC_DTREF)+"'"
						cQuery += " AND D_E_L_E_T_    <>  '*'"
						
						If Select("TMP2") > 0
							DbselectArea("TMP2")
							TMP2->(DbCloseArea())
						EndIf
						
						DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "TMP2" , .F., .T.)
						
						If !TMP2->(Eof())
							lGrava := .F.
							DbselectArea("SZ1")
							DbGotop()
							Dbgoto(TMP2->R_E_C_N_O_)
						EndIf
						
						RecLock("SZ1",lGrava)
						
						SZ1->Z1_FILIAL 	:= Alltrim(TMP->RC_FILIAL)		//Filial
						SZ1->Z1_MAT    	:= SRA->RA_MAT  					//Matricula
						SZ1->Z1_PD		:= ALLTRIM(TMP->RC_PD)          //Verba
						SZ1->Z1_VALOR	:= TMP->RC_VALOR				//Valor
						SZ1->Z1_DATA	:= Stod(TMP->RC_DATA)           //Data do pagemento do autonomo
						SZ1->Z1_DATAREF	:= Stod(TMP->RC_DTREF)          //Data de referência é a data de cadastramento do serviço no sistema legado da GEN
						//			SZ1->Z1_CC		:= CTT->CTT_CUSTO			// Centro de custo  **ALTERADO POR IRAN DIAS PARA BUSCAR O CENTRO DE CUSTO DO CAD.DO FUNC. QUANDO NAO HOUVER**19/10/12
						SZ1->Z1_CC		:= IIF(ALLTRIM(TMP->RC_PD)=="S02",CTT->CTT_CUSTO,SRA->RA_CC)	// Centro de custo **ALTERADO POR IRAN DIAS PARA BUSCAR O CENTRO DE CUSTO DO CAD.DO FUNC. QUANDO NAO HOUVER**19/10/12
						SZ1->Z1_SEQ		:= Iif(ALLTRIM(TMP->RC_SEQ) == "(null)",' ',Iif(Len(cvaltochar(TMP->RC_SEQ))==0,' ',cvaltochar(TMP->RC_SEQ)))   //Sequencia
						SZ1->Z1_ITEM	:= Alltrim(c_Item)              //Item contábil
						SZ1->Z1_CLASSE	:= Alltrim(c_CLVL)              //Classe de valor
						SZ1->Z1_NOME    := SRA->RA_NOME       //Nome do autônomo.
						//SZ1->Z1_HORAS	:=
						
						SZ1->(MsUnlock())
						
						SZ1->(DbCloseArea())
						cQueryINS := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) VALUES ('TT_I14_LANCAMENTOS_MENSAIS','RC_SEQ','"+cValToChar(TMP->RC_SEQ)+"','    ' ) "
						TCSqlExec(cQueryINS)
			
						//RotMens("Gravado no SZ1 ... Matricula => " + SRA->RA_MAT)
						
						nImport ++
						
					Else
						aAdd(aLog, {cPath,"Item Contábil não cadastrado no Protheus ",AllTrim(TMP->RC_FILIAL),c_Matr,TMP->RC_NOME,c_Item,c_CLVL,TMP->RC_CC,TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")})
						nNaoImp ++
						lErro := lLog := .T.
					EndIf
				Else
					aAdd(aLog, {cPath,"Proj./Obra: não cadastrado no Protheus ",AllTrim(TMP->RC_FILIAL),c_Matr,TMP->RC_NOME,c_Item,c_CLVL,TMP->RC_CC,TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")})
					nNaoImp ++
					lErro := lLog := .T.
				EndIf
			Else
				aAdd(aLog, {cPath,"Centro de custo não cadastrado no Protheus ",AllTrim(TMP->RC_FILIAL),c_Matr,TMP->RC_NOME,c_Item,c_CLVL,TMP->RC_CC,TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")})
				nNaoImp ++
				lErro := lLog := .T.
			EndIf
		Else
			
			aAdd(aLog, {cPath,"Matricula não encontrado no Protheus ",AllTrim(TMP->RC_FILIAL),c_Matr,TMP->RC_NOME,c_Item,c_CLVL,TMP->RC_CC,TRANSFORM(TMP->RC_VALOR,"@E 999,999,999.99")})
			cFile := "Funcionario - "+alltrim(TMP->RC_FILIAL)+" - Matricula: "+c_Matr+".log"
			MostraErro(cpath, cfile)
			DisarmTransaction()
			lErro := lLog := .T.
			nNaoImp ++
			RotMens("Matricula não encontrado no Protheus "+c_Matr)
		EndIf
		
		//TERMINA TRANSAÇÃO COM O BANCO
		END TRANSACTION
		
	Else
		RotMens("Criado Log de Erro ... Linha => " + cValtoChar(nItens))
		nNaoImp++
	EndIf
	nProces ++
	//PROXIMO REGISTRO
	TMP->(DbSkip())
	
	// Fim da Alteração - Flávio Bezerra - 10/08/2012
	//-------------------------------------------------------
	
EndDo
//NEXT

///	MsgInfo("Atualizados e/ou importados " +cvaltochar(nImport) + " Nao Importados " + cvaltochar(nNaoImp) + " Processados " +cvaltochar(nProces))
RotMens("Atualizados e/ou importados " +cvaltochar(nImport) + " Nao Importados " + cvaltochar(nNaoImp) + " Processados " +cvaltochar(nProces),"","","2")
If !lLog
	//		Aviso("Aviso","Importação Finalizada com Sucesso!", {"Ok"} )
	RotMens("Aviso","Importação Finalizada com Sucesso!", {"Ok"},"3" )
Else
	//	If Aviso("Atenção!","Ocorreram erros na importação! Deseja imprimir erros?", {"Sim","Não"} ) = 1
	IF cFunName == "U_GENI014"
		If Aviso("Atenção!","Ocorreram erros na importação! Deseja imprimir erros?", {"Sim","Não"} ) = 1
			ImpLOG()
		Else
			Alert("Os arquivos de log foram gravados em: "+cpath +cEnt+ "Dentro da pasta Protheus_Data no servidor.")
		Endif
	ELSE
		RotMens("Os arquivos de log foram gravados em: "+cpath +cEnt+ "Dentro da pasta Protheus_Data no servidor.")
	EndIf
EndIf

//FECHA ALIAS ABERTOS
dbSelectArea("TMP")
dbCloseArea()
//dbSelectArea(cAliasSX5)
//dbCloseArea()
dbSelectArea(cAliasSRA)
dbCloseArea()

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpLOG    ºAutor  ³Vinicius Lança      º Data ³  06/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPRIME RELATÓRIO DE LOGs                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpLOG

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Log de inconsistências"
Local cPict        := ""
Local titulo       := "Log de inconsistências - Importação de Lançamentos Mensais"
Local nLin         := 80
Local Cabec1       := "Campo                     Erro                                          Filial         Matricula   Nome                                      Insumo    Proj.Obra          Centro de Custo"
//  123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
//          10        20        30        40        50        60        70        80        90       100       110       120       130
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd 		   := {}
Private lEnd       := .F.
Private lAbortPrint := .F.
Private CbTxt      := ""
Private limite     := 220 //80
Private tamanho    := "G" //P
Private nomeprog   := "IMPLOGLM" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "ImpErroLM" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString	   := "SRA"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return()


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

SetRegua(Len(aLog))

If lAbortPrint
	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
Endif

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8

// "Campo                  Erro                                         Filial Matricula Nome                                       Insumo"
//  123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
//          10        20        30        40        50        60        70        80        90       100       110       120       130
//  \logsiga\autonomos\ - Cód.Item(Insumo) não encontrado no Protheus - 1001   000000    MARIA ELISABETH PADILHA CORDEIRO DE MELLO  0000000

For n:= 1 to Len(aLog)
	
	@nLin,00 PSAY aLog[n,1] + " - "
	@nLin,25 PSAY aLog[n,2]
	@nLin,72 PSAY aLog[n,3]
	@nLin,87 PSAY aLog[n,4]
	@nLin,99 PSAY aLog[n,5]
	@nLin,142 PSAY aLog[n,6]
	@nLin,152 PSAY aLog[n,7]
	@nLin,172 PSAY aLog[n,8]
	@nLin,200 PSAY aLog[n,9]
	
	nLin++
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
Next

@nLin,00 PSAY "TOTAL DE REGISTROS..:" + cValToChar(Len(aLog))

nLin++

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
