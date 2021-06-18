#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"
#DEFINE   cEnt      CHR(13)+CHR(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENI015   �Autor  �Vinicius Lan�a      � Data �  24/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � IMPORTA COLABORADORES AUTONOMOS                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͻ��
���Altera��o �Autor  �Joni Fujiyama                  � Data �  02/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina foi adaptada para rodar por schedule.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENI015

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

Define MSDialog oLeARQ  Title "Importa��o de Aut�nomos" From 000,000 to 150,380 Pixel
@ 000,003 to 075,190 Pixel
@ 010,018 Say " Este programa ira importar os Aut�nomos disponibilizados " pixel
@ 018,018 Say " na view TT_I12_COLABORADORES                             " pixel
@ 026,018 Say " 				                                         " pixel
@ 055,108 BMPBUTTON TYPE 01 ACTION MSAguarde({|| Leview() },"Processando...")
@ 055,138 BMPBUTTON TYPE 02 ACTION Close(oLeARQ)
Activate Dialog oLeARQ Centered


Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENI015   �Autor  �Vinicius Lan�a      � Data �  24/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � LE VIEW E IMPORTA COLABORADORES                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Leview

Local lErro   	:= .F.
Local nItens  	:= 0
Local cFilBkp 	:= cFilant //Para salvar a filial original
Local cFile   	:= ""
Local cQuery
Local nTotReg 	:= 0
Local lFind		:= .F.
Local lFlag		:= .F.
Local lMsgfim	:= .T.
Private lMSHelpAuto := .F. // para nao mostrar os erro na tela
Private lMSErroAuto := .f. // inicializa como falso, se voltar verdadeiro e'que deu erro
Private cAliasSRJ 	:= GetNextAlias()
Private cAliasSRJ2 	:= GetNextAlias()
Private cAliasQry 	:= GetNextAlias()
Private cAliasSRA 	:= GetNextAlias()
Private cPath   	:= "\LogSiga\Autonomos\"
Private aLog 		:= {} //Array para gravar log de erros


*-------------------------------------------*
*               QUERY VIEW                  *
*-------------------------------------------*
//cQuery := "SELECT * FROM TT_I12_COLABORADORES@TOTVS_LINK"
cQuery := "SELECT * FROM TT_I12_COLABORADORES"

//VERIFICA SE ALIAS ESTA ABERTO E FECHA
If Select(cAliasQry) > 0
	dbSelectArea(cAliasQry)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliasQry, .F., .T.)

// CONTA REGISTROS
Count TO nTotReg

dbSelectArea(cAliasQry)
dbGoTop()

// NUMERO DE REGISTROS A PROCESSAR
ProcRegua(nTotReg)

nItens:= 0

If (cAliasQry)->(EOF())
	Aviso("Aten��o!","N�o h� informa��es para importa��o", {"Ok"} )
	lMsgfim := .F.
EndIf

While !(cAliasQry)->(Eof())
	//for n:=1 to 20
	
	nItens++
	
	//����������������������������Ŀ
	//� Incrementa a regua         �
	//������������������������������
	
	IncProc("Importando colaboradores...  Linha "+cValtoChar(nItens))
	
	//INICIA TRANSA��O COM O BANCO
	BEGIN TRANSACTION
	
	cXCODGEN := CVALTOCHAR((cAliasQry)->RA_MAT)
	
	*--------------------------------------------------*
	*                GRAVA LOGS DE ERRO                *
	*--------------------------------------------------*
	
	If (cAliasQry)->RA_FILIAL == "(null)" .OR. (cAliasQry)->RA_FILIAL = ' '
		
		cHora := Time()
		cHora := Substr(cHora,1,2)+"h"+Substr(cHora,4,2)+"m"+Substr(cHora,7,2)+"s"
		cFile := "Erro Importa��o de Aut�nomos " + Dtos(dDatabase) + " - " + cHora  + ".log"
		cMsg	:= "Filial em branco " + cEnt + cEnt
		cMsg	+=  + cEnt + "Dados do Aut�nomo:" + cEnt
		cMsg	+= "Filial....: " + Alltrim((cAliasQry)->RA_FILIAL) 	+ cEnt
		cMsg	+= "Matricula.: " + cXCODGEN				+ cEnt
		cMsg	+= "Nome......: " + (cAliasQry)->RA_NOME 	+ cEnt
		
		//Grava log em disco
		MemoWrite(cpath+cFile,cMsg)
		
		//Grava array para impress�o
		aAdd(aLog, {cPath,"Filial em branco"," ",cXCODGEN,(cAliasQry)->RA_NOME})
		
		lErro := .T.
		
	ElseIf (cAliasQry)->RA_CODCBO == "(null)" .OR. (cAliasQry)->RA_CODCBO = ' '
		
		cHora := Time()
		cHora := Substr(cHora,1,2)+"h"+Substr(cHora,4,2)+"m"+Substr(cHora,7,2)+"s"
		cFile := "Erro Importa��o de Aut�nomos " + Dtos(dDatabase) + " - " + cHora  + ".log"
		cMsg	:= "C�digo CBO em branco " + cEnt + cEnt
		cMsg	+=  cEnt + "Dados do Aut�nomo:" + cEnt
		cMsg	+= "Filial....: " + AllTrim((cAliasQry)->RA_FILIAL) 	+ cEnt
		cMsg	+= "Matricula.: " + cXCODGEN				+ cEnt
		cMsg	+= "Nome......: " + (cAliasQry)->RA_NOME 	+ cEnt
		
		//Grava log em disco
		MemoWrite(cpath+cFile,cMsg)
		
		//Grava array para impress�o
		aAdd(aLog, {cPath,"C�digo CBO em branco ",AllTrim((cAliasQry)->RA_FILIAL),cXCODGEN,(cAliasQry)->RA_NOME})
		
		lErro := .T.
		
	ElseIf (cAliasQry)->RA_NOME == "(null)" .OR. (cAliasQry)->RA_NOME = ' '
		
		cHora := Time()
		cHora := Substr(cHora,1,2)+"h"+Substr(cHora,4,2)+"m"+Substr(cHora,7,2)+"s"
		cFile := "Erro Importa��o de Aut�nomos " + Dtos(dDatabase) + " - " + cHora  + ".log"
		cMsg	:= "Nome em branco " + cEnt + cEnt
		cMsg	+=  cEnt + "Dados do Aut�nomo:" + cEnt
		cMsg	+= "Filial....: " + AllTrim((cAliasQry)->RA_FILIAL) 	+ cEnt
		cMsg	+= "Matricula.: " + cXCODGEN				+ cEnt
		cMsg	+= "Nome......: " + (cAliasQry)->RA_NOME 	+ cEnt
		
		//Grava log em disco
		MemoWrite(cpath+cFile,cMsg)
		
		//Grava array para impress�o
		aAdd(aLog, {cPath,"Nome em branco",AllTrim((cAliasQry)->RA_FILIAL),cXCODGEN," "})
		
		lErro := .T.
		
	ElseIf (cAliasQry)->RA_MAT <= 0
		
		cHora := Time()
		cHora := Substr(cHora,1,2)+"h"+Substr(cHora,4,2)+"m"+Substr(cHora,7,2)+"s"
		cFile := "Erro Importa��o de Aut�nomos " + Dtos(dDatabase) + " - " + cHora  + ".log"
		cMsg	:= "Sem Matricula " + cEnt + cEnt
		cMsg	+=  cEnt + "Dados do Aut�nomo:" + cEnt
		cMsg	+= "Filial....: " + AllTrim((cAliasQry)->RA_FILIAL) 	+ cEnt
		cMsg	+= "Matricula.: " + cXCODGEN				+ cEnt
		cMsg	+= "Nome......: " + (cAliasQry)->RA_NOME 	+ cEnt
		
		//Grava log em disco
		MemoWrite(cpath+cFile,cMsg)
		
		//Grava array para impress�o
		aAdd(aLog, {cPath,"Sem Matricula",AllTrim((cAliasQry)->RA_FILIAL)," ",(cAliasQry)->RA_NOME})
		
		lErro := .T.
		
	Else
		
		*-----------------------------*
		* Busca Matricula do Aut�nomo *
		*-----------------------------*
		
		//-------------------------------------------------------------------------------*
		// Ficou definido que os aut�nomos ser�o importados com o c�digo iniciando por 6 *
		//-------------------------------------------------------------------------------*
		
		//QUERY
		cQuery := " SELECT MAX(RA_MAT) RA_MAT FROM "+RetSqlName("SRA")+" WHERE RA_CATFUNC = 'A' AND RA_PROCES='00003' AND D_E_L_E_T_ = ' ' AND RA_MAT LIKE '6%' "
		
		//VERIFICA SE ALIAS ESTA ABERTO E FECHA
		If Select(cAliasSRA) > 0
			dbSelectArea(cAliasSRA)
			dbCloseArea()
		EndIf
		
		DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliasSRA, .F., .T.)
		
		*------------------------*
		*' IMCREMENTA MATRICULA '*
		*------------------------*
		cCodMat := '6'+cvaltochar((strzero(val(substr((cAliasSRA)->RA_MAT,2))+1,5)))
		
		*------------------------------------*
		*         ARMAZENA INFORMA��ES       *
		*------------------------------------*
		
		cNome		:= Alltrim((cAliasQry)->RA_NOME)
		cNomecmp	:= alltrim((cAliasQry)->RA_NOMECMP)
		cEndereco	:= Iif(AllTrim((cAliasQry)->RA_ENDEREC) == "(null)",'',ALLTRIM((cAliasQry)->RA_ENDEREC))
		cBairro		:= Iif(AllTrim((cAliasQry)->RA_BAIRRO) == "(null)",'',Alltrim((cAliasQry)->RA_BAIRRO))
		cMunicipio	:= Iif(AllTrim((cAliasQry)->RA_MUNICIP) == "(null)",'',Alltrim((cAliasQry)->RA_MUNICIP))
		cEstado		:= Iif(AllTrim((cAliasQry)->RA_ESTADO) == "(null)",'',Alltrim((cAliasQry)->RA_ESTADO))
		cCodCBO 	:= Iif(AllTrim((cAliasQry)->RA_CODCBO) == "(null)",'',ALLTRIM((cAliasQry)->RA_CODCBO))
		cCIC		:= cValToChar((cAliasQry)->RA_CIC)
		//RG
		c_RG		:= Iif(AllTrim((cAliasQry)->RA_RG) == "(null)",'',ALLTRIM((cAliasQry)->RA_RG))
		c_RG		:= StrTran(c_RG,"/","")   //RETIRA '/'
		c_RG		:= StrTran(c_RG,"-","")   //RETIRA '-'
		//CEP
		cCEP		:= Iif(AllTrim((cAliasQry)->RA_CEP) == "(null)",'',Alltrim((cAliasQry)->RA_CEP))
		cCEP		:= StrTran(cCEP,".","")   //RETIRA '.'
		cCEP		:= StrTran(cCEP,"-","")   //RETIRA '-'
		
		*------------------------------------*
		*          VERIFICA FUN��O           *
		*------------------------------------*
		
		//QUERY
		cQuery := "SELECT * FROM "+RetSqlName("SRJ")+" WHERE D_E_L_E_T_ = ' ' AND RJ_CODCBO = '"+cCodCBO+"' AND RJ_FUNCAO LIKE 'A%'"
		
		//VERIFICA SE ALIAS ESTA ABERTO E FECHA
		If Select(cAliasSRJ) > 0
			dbSelectArea(cAliasSRJ)
			dbCloseArea()
		EndIf
		
		DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliasSRJ, .F., .T.)
		
		
		If !(cAliasSRJ)->(EOF())
			
			//����������������������������������������������������������������ć�
			//�SE EXISTIR FUN��O PARA AUTONOMOS COM O CODCBO ARMAZENA INFORMA��O�
			//����������������������������������������������������������������ć�
			//	If 'A' $ (cAliasSRJ)->RJ_FUNCAO
			
			cCodFunc :=	(cAliasSRJ)->RJ_FUNCAO
			
			//	EndIf
			
			
		Else
			
			//��������������������������������������������������Ŀ
			//�SE N�O EXISTIR FUN��O PARA AUTONOMOS COM O CODCBO �
			//�VERIFICA QUAL O ULTIMO C�DIGO E GERA NOVA FUN��O. �
			//����������������������������������������������������
			
			//QUERY
			cQuery := " SELECT MAX(RJ_FUNCAO) RJ_FUNCAO FROM "+RetSqlName("SRJ")+" WHERE RJ_FUNCAO LIKE 'A%' AND D_E_L_E_T_ = ' ' "
			
			//VERIFICA SE ALIAS ESTA ABERTO E FECHA
			If Select(cAliasSRJ2) > 0
				dbSelectArea(cAliasSRJ2)
				dbCloseArea()
			EndIf
			
			DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliasSRJ2, .F., .T.)
			
			
			*------------------------------------------*
			*      'IMCREMENTA CODIGO DE FUN��O'       *
			*------------------------------------------*
			cCodFunc := 'A'+cvaltochar((strzero(val(substr((cAliasSRJ2)->RJ_FUNCAO,2))+1,4)))
			
			
			*------------------------------------*
			*   GRAVA NOVA FUN��O DE AUTONOMO    *
			*------------------------------------*
			dbSelectArea("SRJ")
			dbSetOrder(1)
			If !dbSeek(xFilial("SRJ")+cCodFunc)
				RecLock("SRJ",.T.)
				
				SRJ->RJ_FILIAL 	:= xFilial("SRJ")
				SRJ->RJ_FUNCAO 	:= cCodFunc
				SRJ->RJ_DESC	:= 'FUNCAO DE AUTONOMO'
				SRJ->RJ_CODCBO	:= cCodCBO
				
				SRJ->(MsUnlock())
				
			EndIf
			
		EndIf
		
		
		*--------------------------------*
		* GRAVA INFORMA��ES DE AUTONOMOS *
		*--------------------------------*
		
		cXCODGEN := PADR(cXCODGEN,TamSX3("RA_XCODGEN")[1])
		
		dbSelectArea("SRA")
		//dbSetOrder(5)
		//If DbSeek(AllTrim((cAliasQry)->RA_FILIAL)+cCIC)
		DbOrderNickName("RA_XCODGEN")
		If DbSeek(AllTrim((cAliasQry)->RA_FILIAL)+cXCODGEN+'A')
			If SRA->RA_CATFUNC <> 'A'
				lGrava := .T.
				RecLock("SRA",lGrava)
				SRA->RA_FILIAL	:= AllTrim((cAliasQry)->RA_FILIAL)
				SRA->RA_MAT     := cCodMat
				SRA->RA_ADMISSA	:= FIRSTDATE(dDataBase)
				SRA->RA_PROCES	:= "00003"
			Else
				lGrava := .F.
				RecLock("SRA",lGrava)
			EndIf
		Else
			lGrava := .T.
			RecLock("SRA",lGrava)
			SRA->RA_FILIAL	:= AllTrim((cAliasQry)->RA_FILIAL)
			SRA->RA_MAT     := cCodMat
			SRA->RA_ADMISSA	:= FIRSTDATE(dDataBase)
			SRA->RA_PROCES	:= "00003"
		EndIf
		
		SRA->RA_NOME    := NoAcento(cNome)
		SRA->RA_NOMECMP := NoAcento(cNomecmp)
		SRA->RA_ENDEREC := NoAcento(cEndereco)
		SRA->RA_BAIRRO  := NoAcento(cBairro)
		SRA->RA_MUNICIP := NoAcento(cMunicipio)
		SRA->RA_ESTADO  := NoAcento(cEstado)
		SRA->RA_CEP     := cCEP
		SRA->RA_DEPIR	:= alltrim(cValToChar((cAliasQry)->RA_DEPIR))
		SRA->RA_CC      := Alltrim((cAliasQry)->RA_CC)
		SRA->RA_TNOTRAB	:= "001"
		SRA->RA_CODFUNC := cCodFunc
		SRA->RA_CATFUNC := "A"
		SRA->RA_TIPOPGT := "M"
		SRA->RA_CIC     := cCIC
		SRA->RA_PIS     := Iif(AllTrim((cAliasQry)->RA_PIS) == "(null)",'',ALLTRIM((cAliasQry)->RA_PIS))
		SRA->RA_RG      := c_RG
		//			SRA->RA_CODCBO	:= cCodCBO
		SRA->RA_BCDEPSA := StrTran((cAliasQry)->RA_BCDEPSA,"-","")
		SRA->RA_CTDEPSA := StrTran(Iif(AllTrim((cAliasQry)->RA_CTDEPSA) == "(null)",'',ALLTRIM((cAliasQry)->RA_CTDEPSA)),"-","")
		SRA->RA_RGORG 	:= StrTran(UPPER(Iif(AllTrim((cAliasQry)->RA_RGORG) == "(null)",'',Alltrim((cAliasQry)->RA_RGORG))),"-","")
		SRA->RA_EMAIL	:= Iif(AllTrim((cAliasQry)->RA_EMAIL) == "(null)",'',Alltrim((cAliasQry)->RA_EMAIL))
		SRA->RA_DEPTO	:= STRZERO((cAliasQry)->RA_DEPTO,9)
		SRA->RA_HOPARC	:= "2"
		SRA->RA_COMPSAB	:= "2"
		SRA->RA_CLVL    := "000000000"                                  //CLASSE DE VALOR - NAO SE APLICA
		SRA->RA_ITEM	:= AllTrim((cAliasQry)->RA_FILIAL)  			//ITEM CONTABIL IGUAL AO CODIGO DA FILIAL
		SRA->RA_XCODGEN := cXCODGEN					//GRAVA MATRICULA DO SISTEMA LEGADO
		
		SRA->(MsUnlock())
		
		lFlag := .T. //FLAG DE CONTROLA PARA GRAVA��O NA VIEW DE FLAG

	EndIf
	
	*-------------------------------------------------------*
	* GRAVA NA VIEW 'TT_I11_FLAG_VIEW' O REGISTRO IMPORTADO *
	*-------------------------------------------------------*
	
	If lFlag
		
		//		cQueryINS := " INSERT INTO TT_I11_FLAG_VIEW@TOTVS_LINK (VIEW_NAME,CHAVE,VALOR,FILIAL) "
		cQueryINS := " INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) "
		cQueryINS += " VALUES ( 'TT_I12_COLABORADORES','RA_MAT','"+cXCODGEN+"','"+AllTrim((cAliasQry)->RA_FILIAL)+"') "
		TCSqlExec( cQueryINS )
		
		lFlag := .F.
		
	EndIf
	
	*-------------------------------------------------------*
	
	//FINALIZA TRANSA��O COM O BANCO
	END TRANSACTION
	
	DbSelectARea(cAliasQry)
	(cAliasQry)->(DbSkip())
	
EndDo
//next

*-------------------------*
*   FECHA ALIAS ABERTOS   *
*-------------------------*
If Select(cAliasQry) > 0
	dbSelectArea(cAliasQry)
	dbCloseArea()
EndIf

If Select(cAliasSRJ) > 0
	dbSelectArea(cAliasSRJ)
	dbCloseArea()
EndIf


*----------------------------*
* EXIBE MSG NO FIM DA ROTINA *
*----------------------------*

If !lErro .and. lMsgfim
	Aviso("Aviso","Importa��o Finalizada com Sucesso!", {"Ok"} )
ElseIf lErro
	Alert("Ocorreram erros na importa��o! Verifique os arquivos gerados!")
Endif

*-----------------------*
*  Imprime Log de Erro  *
*-----------------------*
If Len(aLog) > 0
	ImpLOG()
EndIf

*-------------------------*
* Fecha a tela de dialogo *
*-------------------------*
Close(oLeARQ)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENI015   �Autor  �Microsiga           � Data �  04/09/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     � BUSCA ACENTUA��O E ALTERA                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION NoAcento(cString)

Local cChar  := ""
Local nX     := 0
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "�����"+"�����"
Local cCircu := "�����"+"�����"
Local cTrema := "�����"+"�����"
Local cCrase := "�����"+"�����"
Local cTio   := "��"
Local cCecid := "��"

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

Return cString

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENI015   �Autor  �Vinicius Lan�a      � Data �  06/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � IMPRIME RELAT�RIO DE LOGs                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ImpLOG

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Log de inconsist�ncias"
Local cPict        := ""
Local titulo       := "Log de inconsist�ncias - Importa��o de Aut�nomos"
Local nLin         := 80
Local Cabec1       := "Campo                  Erro                   Filial Matricula Nome"
//	                   1234567890123456789012345678901234567890123456789012345678901234567890
//                             10        20        30        40        50        60        70
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd 		   := {}
Private lEnd       := .F.
Private lAbortPrint := .F.
Private CbTxt      := ""
Private limite     := 220 //80
Private tamanho    := "G" //P
Private nomeprog   := "IMPLOGAU" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "ImpErro" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString	   := "SRA"

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)


Return


//�������������������������������������������������������������������������������������������������������Ŀ
//�Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS monta a janela com a regua de processamento.�
//���������������������������������������������������������������������������������������������������������

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local n	:= 0
//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(Len(aLog))

//���������������������������������������������������������������������Ŀ
//� Verifica o cancelamento pelo usuario...                             �
//�����������������������������������������������������������������������

If lAbortPrint
	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
Endif

//����������������������������������������������������������������������Ŀ
//�Imprime cabe�alho                                                     �
//������������������������������������������������������������������������

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8

//����������������������������������������������������������������������Ŀ
//�Informa��es de log                                                    �
//������������������������������������������������������������������������

// "Campo                  Erro                  Filial Matricula Nome"
//  1234567890123456789012345678901234567890123456789012345678901234567890
//          10        20        30        40        50        60        70
//  \logsiga\autonomos\ - codigo cbo em branco - 1001   000000    vinicius

For n:= 1 to Len(aLog)
	
	@nLin,00 PSAY aLog[n,1] + " - "
	@nLin,23 PSAY aLog[n,2]
	@nLin,46 PSAY aLog[n,3]
	@nLin,53 PSAY aLog[n,4]
	@nLin,64 PSAY aLog[n,5]
	
	nLin++
	
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
Next

nLin := nLin + 1 // Avanca a linha de impressao


//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
