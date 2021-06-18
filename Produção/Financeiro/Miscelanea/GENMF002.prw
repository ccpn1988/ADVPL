#include "rwmake.ch"
#include "protheus.ch"

#DEFINE POS_FIELD	1
#DEFINE POS_SIZE   2
#DEFINE POS_INI    3
#DEFINE POS_FIM    4

#DEFINE cEnt	Chr(13)+chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENMF002  �Autor  �CLEUTO LIMA         � Data �  11/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � rotina para processamento do arquivo com as movimenta��es  ���
���          � de pagamentos de cart�o de credito.                        ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENMF002()

Local alEmp 		:= {}
Local lEmp			:= Type('cFilAnt') == "C" .AND. Select("SM0") <> 0
Local nAuxEmp		:= 0
Local nX			:= 0
Local nLimite		:= 50  

Conout("GENMF002 - Iniciando Job - Integra��o Bx.Cart�o - "+Time()+".")

If !lEmp		
	RpcSetType(2)
	lOpenSM0 := RpcSetEnv( "00" , "1022")
	If !lOpenSM0
		ConOut("")
	   	ConOut(Replicate("+",nLimite))
	   	ConOut(Padc("GENMF002 - Nao foi possivel incializar ambiente confirme a senha/usuario digitado. "+Dtoc(Date())+" "+Time(),nLimite))
	   	ConOut(Replicate("+",nLimite))
	   	ConOut("") 
	   	RpcClearEnv()
		Return Nil
	Else
		Conout("GENMF002 - Abrindo empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())		
	EndIf
EndIF   

While !LockByName("GENMF002",.T.,.T.,.T.)
    nX++
	Sleep(10)
	If nX > 2     
		Conout("GENMF002 - N�o foi poss�vel executar a Integra��o Bx.Cart�o neste momento pois a fun��o GENMF002 j� esta sendo executada por outra processamento!"+DTOC(DDataBase)+" "+Time())
		Return .F.
    EndIf
EndDo

ProcFiles()

If !lEmp .AND. Type('cFilAnt') == "C"
	Conout("GENMF002 - Fechando empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())	
	RpcClearEnv()
EndIF

UnLockByName("GENMF002",.T.,.T.,.T.)

Conout("GENMF002 - Finalizando Job - Integra��o Bx.Cart�o - "+Time()+".")

Return nil  


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENMF002  �Autor  �Microsiga           � Data �  11/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProcFiles()

Local aLayout11	:= {}
Local aLayout12	:= {}
Local nPosIni	:= 0
Local nPosFim	:= 0
Local aFiles	:= {}
Local cLogPd	:= SUPERGETMV("GEN_FIN001",.T.,"\logsiga\Accesstage\") //Par�metro que cont�m o caminho onde ser� gravado o arquivo de log de inconsist�ncias
Local cLogErr	:= cLogPd+"Erro\"
Local cLogArq	:= cLogPd+"Arquivos\"
Local cLogPro	:= cLogPd+"Processados\"
Local cMsgErro	:= ""
Local aDados	:= {}
Local nRegOk	:= 0
Local nRegNOk	:= 0
Local lAviMail	:= .F.
Local nAuxLay
Local nAuxFile

Private nFileLog	:= 0
Private cFileLog	:= ""
Private cNatCart	:= GetMv("GENI018CAR") //NATUREZA PARA CARTAO DE CREDITO

If !FileLog(nil,.T.,.F.)
	Conout("GENMF002 - Falha ao criar o arquivo de log")
	Return .F.
EndIf
			
WFForceDir(cLogErr)
WFForceDir(cLogArq)
WFForceDir(cLogPro)

//�����������������������������Ŀ
//�Layout de Exporta��o bloco 11�
//�������������������������������

Aadd(aLayout11, {"ZZ9_TIPO"		,02,0,0})//Tipo de registro 1 2 N Constante �11�
Aadd(aLayout11, {"ZZ9_NUMSEQ"	,07,0,0})//N�mero sequencial de registro 3 7 N N�mero sequencial de registro
Aadd(aLayout11, {"ZZ9_NUMEST"	,15,0,0})//N�mero do Estabelecimento 10 15 A
Aadd(aLayout11, {"ZZ9_NOMEES"	,30,0,0})//Nome do Estabelecimento 25 30 A Nome de identifica��o do estabelecimento no AS Cart�es
Aadd(aLayout11, {"ZZ9_NUMLOT"	,09,0,0})//N�mero do lote 55 9 N N�mero do lote
Aadd(aLayout11, {"ZZ9_PARCEL"	,02,0,0})//Parcela 64 2 A Parcela
Aadd(aLayout11, {"ZZ9_PLANO"	,02,0,0})//Plano 66 2 A Plano
Aadd(aLayout11, {"ZZ9_NSU"		,15,0,0})//NSU 68 15 A C�digo de NSU
Aadd(aLayout11, {"ZZ9_AUTORI"	,15,0,0})//Autoriza��o 83 15 A N�mero de autoriza��o
Aadd(aLayout11, {"ZZ9_CARTAO"	,20,0,0})//Cart�o 98 20 A Cart�o Truncado
Aadd(aLayout11, {"ZZ9_DTVEND"	,08,0,0})//Data da Venda 118 8 N Data da Venda (AAAAMMDD)
Aadd(aLayout11, {"ZZ9_DTCRED"	,08,0,0})//Data de Cr�dito 126 8 N Data de Cr�dito (AAAAMMDD)
Aadd(aLayout11, {"ZZ9_VALBRU"	,15,0,0})//Valor bruto 134 15 N Valor bruto
Aadd(aLayout11, {"ZZ9_TXADM"	,15,0,0})//Valor taxa administrativa 149 15 N Valor taxa administrativa
Aadd(aLayout11, {"FILLER"		,15,0,0})//Filler 164 15 N Zeros
Aadd(aLayout11, {"ZZ9_TXANTE"	,15,0,0})//Valor taxa antecipa��o 179 15 N Valor taxa antecipa��o
Aadd(aLayout11, {"ZZ9_LIGPAG"	,15,0,0})//Valor l�quido pago 194 15 N Valor l�quido pago
Aadd(aLayout11, {"ZZ9_NUMANT"	,11,0,0})//N�mero da antecipa��o 209 11 N N�mero da antecipa��o
Aadd(aLayout11, {"ZZ9_TPEXP"	,02,0,0})//Tipo de exporta��o 220 2 N Tabela I
Aadd(aLayout11, {"ZZ9_STATUS"	,02,0,0})//Status 222 2 N Tabela II
Aadd(aLayout11, {"ZZ9_PRODUT"	,03,0,0})//Produto 224 3 N Tabela III
Aadd(aLayout11, {"ZZ9_OPERA"	,03,0,0})//Operadora 227 3 N Tabela IV
Aadd(aLayout11, {"ZZ9_BANCO"	,03,0,0})//Banco 230 3 N Banco
Aadd(aLayout11, {"ZZ9_AGENCI"	,06,0,0})//Ag�ncia 233 6 A Ag�ncia
Aadd(aLayout11, {"ZZ9_CONTA"	,20,0,0})//Conta corrente 239 20 A Conta corrente
Aadd(aLayout11, {"ZZ9_IDCONC"	,50,0,0})//ID Concilia��o 259 50 A Preenchido com a informa��o que o estabelecimento enviou no arquivo de concilia��o de vendas no campo "Reservado para o estabelecimento"
Aadd(aLayout11, {"ZZ9_DESAJU"	,41,0,0})//Filler 309 41 A Reservado para uso da Accesstage

//�����������������������������Ŀ
//�Layout de Exporta��o bloco 12�
//�������������������������������

Aadd(aLayout12, {"ZZ9_TIPO"		,02,0,0})//Tipo de registro 1 2 N Constante �11�
Aadd(aLayout12, {"ZZ9_NUMSEQ"	,07,0,0})//N�mero sequencial de registro 3 7 N N�mero sequencial de registro
Aadd(aLayout12, {"ZZ9_NUMEST"	,15,0,0})//N�mero do Estabelecimento 10 15 A
Aadd(aLayout12, {"ZZ9_NOMEES"	,30,0,0})//Nome do Estabelecimento 25 30 A Nome de identifica��o do estabelecimento no AS Cart�es
Aadd(aLayout12, {"ZZ9_NUMLOT"	,09,0,0})//N�mero do lote 55 9 N N�mero do lote
Aadd(aLayout12, {"FILLER"		,02,0,0})//Filler 64 2 A Brancos
Aadd(aLayout12, {"FILLER"		,02,0,0})//Filler 66 2 A Brancos
Aadd(aLayout12, {"ZZ9_NSU"		,15,0,0})//NSU 68 15 A C�digo de NSU
Aadd(aLayout12, {"ZZ9_AUTORI"	,15,0,0})//Autoriza��o 83 15 A N�mero de autoriza��o
Aadd(aLayout12, {"ZZ9_CARTAO"	,20,0,0})//Cart�o 98 20 A Cart�o Truncado
Aadd(aLayout12, {"ZZ9_DTVEND"	,08,0,0})//Data da Venda 118 8 N Data da Venda (AAAAMMDD)
Aadd(aLayout12, {"ZZ9_DTCRED"	,08,0,0})//Data de Cr�dito 126 8 N Data de Cr�dito (AAAAMMDD)
Aadd(aLayout12, {"ZZ9_VALBRU"	,15,0,0})//Valor bruto 134 15 N Valor bruto
Aadd(aLayout12, {"ZZ9_TXADM"	,15,0,0})//Valor taxa administrativa 149 15 N Valor taxa administrativa
Aadd(aLayout12, {"ZZ9_LIGPAG"	,15,0,0})//Valor l�quido pago 164 15 N Valor l�quido pago
Aadd(aLayout12, {"FILLER"		,11,0,0})//Filler 179 11 A Brancos
Aadd(aLayout12, {"ZZ9_TPEXP"	,02,0,0})//Tipo de exporta��o 190 2 N Tabela I
Aadd(aLayout12, {"ZZ9_STATUS"	,02,0,0})//Status 192 2 N Tabela V
Aadd(aLayout12, {"ZZ9_PRODUT"	,03,0,0})//Produto 194 3 N Tabela III
Aadd(aLayout12, {"ZZ9_OPERA"	,03,0,0})//Operadora 197 3 N Tabela IV
Aadd(aLayout12, {"ZZ9_BANCO"	,03,0,0})//Banco 200 3 N Banco
Aadd(aLayout12, {"ZZ9_AGENCI"	,06,0,0})//Ag�ncia 203 6 A Ag�ncia
Aadd(aLayout12, {"ZZ9_CONTA"	,20,0,0})//Conta corrente 209 20 A Conta corrente
Aadd(aLayout12, {"ZZ9_IDCONC"	,50,0,0})//ID Concilia��o 229 50 A Preenchido com a informa��o que o estabelecimento enviou no arquivo de concilia��o de vendas no campo "Reservado para o estabelecimento"
Aadd(aLayout12, {"ZZ9_DESAJU"	,50,0,0})//Descri��o do Ajuste 279 50 A Descri��o do Ajuste
Aadd(aLayout12, {"FILLER"		,21,0,0})//Filler 329 21 A Reservado para uso da Accesstage
                                                         
// compatibilizaar com vers�o 11
Aadd(aLayout12, {"ZZ9_TXANTE"	,01,0,0})//compatibilizar
Aadd(aLayout12, {"ZZ9_NUMANT"	,01,0,0})//compatibilizar
Aadd(aLayout12, {"ZZ9_PLANO"	,02,0,0})//compatibilizar

For nAuxLay := 1 To Len(aLayout11)

	nPosIni	:= nPosFim+1
	nPosFim	:= aLayout11[nAuxLay][POS_SIZE]+nPosIni-1
	aLayout11[nAuxLay][POS_INI]	:= nPosIni
	aLayout11[nAuxLay][POS_FIM]	:= nPosFim
	
Next

nPosFim	:= 0
nPosIni	:= 0
For nAuxLay := 1 To Len(aLayout12)

	nPosIni	:= nPosFim+1
	nPosFim	:= aLayout12[nAuxLay][POS_SIZE]+nPosIni-1
	aLayout12[nAuxLay][POS_INI]	:= nPosIni
	aLayout12[nAuxLay][POS_FIM]	:= nPosFim
	
Next

//��������������������������������������������������������������������������������������Ŀ
//�Busca arquivos.                                                                       �
//����������������������������������������������������������������������������������������

aFiles	:= DIRECTORY(cLogArq+"*.txt")

If Len(aFiles) > 0
	
	For nAuxFile := 1 To Len(aFiles)
		
		//cMsgErro += "Inicio processamento arquivo: "+aFiles[nAuxFile][1]+" "+Replicate("-",250)+cEnt
		FileLog("Inicio processamento arquivo: "+aFiles[nAuxFile][1]+" "+Replicate("-",250))
		
		If File(cLogArq+aFiles[nAuxFile][1])		
			
			aDados	:= {}
			nRegOk	:= 0
			nRegNOk	:= 0
			
			IF LerArquivo(cLogArq+aFiles[nAuxFile][1],aLayout11,aLayout12,@cMsgErro,@aDados)
				IF GravaZZ9(aDados,@cMsgErro,aFiles[nAuxFile][1],@nRegOk,@nRegNOk,aLayout11)
					If __CopyFile( cLogArq+aFiles[nAuxFile][1] , cLogPro+aFiles[nAuxFile][1] )
						FErase(cLogArq+aFiles[nAuxFile][1])
					Else
						lAviMail	:= .T.
						//cMsgErro += "Erro ao mover arquivo: "+AllTrim(cLogArq+aFiles[nAuxFile][1])+" para pasta processadas!"+cEnt	
						FileLog("Erro ao mover arquivo: "+AllTrim(cLogArq+aFiles[nAuxFile][1])+" para pasta processadas!")
					EndIf
				Else
					lAviMail	:= .T.
					//cMsgErro += "Falha ao armazenar a tabela ZZ9"+cEnt	
					FileLog("Falha ao armazenar a tabela ZZ9")
				EndIf	
			Else	
				lAviMail	:= .T.
				//cMsgErro += "Erro ao ler arquivo: "+AllTrim(cLogArq+aFiles[nAuxFile][1])+cEnt	
				FileLog("Erro ao ler arquivo: "+AllTrim(cLogArq+aFiles[nAuxFile][1]))
			EndIf
		
			//cMsgErro += " Arquivo: "+aFiles[nAuxFile][1]+cEnt
			FileLog(" Arquivo: "+aFiles[nAuxFile][1])
			//cMsgErro += " Qtd.Registros Processados: "+StrZero(Len(aDados),5)+cEnt
			FileLog(" Qtd.Registros Processados: "+StrZero(Len(aDados),5))
			//cMsgErro += " Qtd.Registros Proc.com sucesso: "+StrZero(nRegOk,5)+cEnt
			FileLog(" Qtd.Registros Proc.com sucesso: "+StrZero(nRegOk,5))
			//cMsgErro += " Qtd.Registros Proc.rejeitados: "+StrZero(nRegNOk,5)+cEnt			
			FileLog(" Qtd.Registros Proc.rejeitados: "+StrZero(nRegNOk,5))
			
			If nRegNOk > 0
				lAviMail	:= .T.
			EndIf
			
		Else
			lAviMail	:= .T.
			//cMsgErro += "Arquivo n�o localizado: "+AllTrim(cLogArq+aFiles[nAuxFile][1])+cEnt 
			FileLog("Arquivo n�o localizado: "+AllTrim(cLogArq+aFiles[nAuxFile][1]))
		EndIf	
		
		//cMsgErro += "Fim processamento arquivo: "+aFiles[nAuxFile][1]+" "+Replicate("-",250)+cEnt
		FileLog("Fim processamento arquivo: "+aFiles[nAuxFile][1]+" "+Replicate("-",250))
		
	Next
	
Else
	Conout("GENMF002 - Sem dados a processar "+DTOC(DDataBase)+" "+Time())	
EndIf

//If !Empty(cMsgErro)
	//MemoWrite ( cLogPd+"GENMF002_"+DtoS(DDataBase)+"_"+StrTran(Left(Time(),5),":","H")+".log" , cMsgErro )
	If lAviMail
		U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("GENMF002 - log"),cFileLog,cFileLog,,.F.)			
	EndIf
//EndIf

Return nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENMF002  �Autor  �Microsiga           � Data �  11/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LerArquivo(cFileaux,aLayout11,aLayout12,cMsgErro,aDados)

Local nHandle	:= 0  
Local cLinha	:= ""
Local nLinLay	:= 0
Local nLinAut	:= 0 
Local lRet		:= .F.
Local nQtdLinha	:= 0

nHandle := FT_FUSE(cFileaux)

If nHandle <> Nil .and. nHandle > 0
	FT_FGOTOP()
	
	While !FT_FEOF()
		lRet		:= .T.
		cLinha		:= FT_FREADLN()			
		nQtdLinha++
		
		If Left(cLinha,2) == "11"
			Aadd(aDados,{})
			nLinAut	:= Len(aDados)
			
			Aadd(aDados[nLinAut], {"LINHA", nQtdLinha , nil } )
			
			For nLinLay := 1 To Len(aLayout11)				
				Aadd(aDados[nLinAut], { aLayout11[nLinLay][POS_FIELD] , Substr( cLinha , aLayout11[nLinLay][POS_INI] , aLayout11[nLinLay][POS_SIZE] ) , nil } )				
			Next	            
			
		ElseIf Left(cLinha,2) == "12"
			Aadd(aDados,{})
			nLinAut	:= Len(aDados)
			
			Aadd(aDados[nLinAut], {"LINHA", nQtdLinha , nil } )
			
			For nLinLay := 1 To Len(aLayout12)				
				Aadd(aDados[nLinAut], { aLayout12[nLinLay][POS_FIELD] , Substr( cLinha , aLayout12[nLinLay][POS_INI] , aLayout12[nLinLay][POS_SIZE] ) , nil } )				
			Next			
		EndIf	
		FT_FSKIP()		
	EndDo
	
Else
	//cMsgErro += "Erro ao ler arquivo: "+AllTrim(cFileaux)+cEnt	
	FileLog("Erro ao ler arquivo: "+AllTrim(cFileaux))
EndIf

FT_FUSE()

Return lRet  


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENMF002  �Autor  �Microsiga           � Data �  11/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaZZ9(aDados,cMsgErro,cFile,nRegOk,nRegNOk,aLayout11)

Local lRet		:= .T.
Local nPosAux	:= 0
Local cField	:= ""
Local nAux		:= 0
Local cChaveZZ9	:= "" 
Local bRetInfo	:= {|x,z| cField := x, nPosAux := aScan(aDados[z], {|y| AllTrim(y[1]) == cField } ) , aDados[z][nPosAux][2] }
Local cParc1	:= GetMv("MV_1DUP")
Local cParcAux	:= ""
Local cPrefixo	:= PadL(" ",TamSx3("E1_PREFIXO")[1])
Local cDOCTEF	:= ""
Local cTmpAlias	:= GetNextAlias()
Local cSituac	:= "1"
Local cMsg		:= ""
Local nMgMais	:= 2
Local nMgMenos	:= -2
Local nValDif	:= 0
Local cConsil	:= "2"
Local cTipoZZ9	:= ""
	
DbSelectArea("SE1")
SE1->(DbsetOrder(1))//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	
DbSelectArea("ZZ9")
ZZ9->(DbsetORder(1))

//Begin Transaction
	For nAux := 1 To Len(aDados)
	    /* 
		If !((StoD(Eval(bRetInfo,"ZZ9_DTVEND",nAux)) >= CtoD("01/12/2016") .and. StoD(Eval(bRetInfo,"ZZ9_DTVEND",nAux)) <= CtoD("31/12/2016")) .or. Eval(bRetInfo,"ZZ9_TIPO",nAux) <> "11" .OR.;
			(StoD(Eval(bRetInfo,"ZZ9_DTCRED",nAux)) >= CtoD("01/12/2016") .AND. StoD(Eval(bRetInfo,"ZZ9_DTCRED",nAux)) <= CtoD("31/12/2016")))
			FileLog(" Registro fora do periodo de 12/2016 e ser� ignorado linha: "+StrZero(Eval(bRetInfo,"LINHA",nAux),6)+" para o arquivo: "+cFile)
			Loop
		EndIf
	    */
	    
		Begin Transaction
	    Conout("GravaZZ9 - Processando "+StrZero(nAux,6)+" de "+StrZero(Len(aDados),6)+" - "+Time())
		cParcAux	:= "" 
		cSituac		:= "1"
		cMsg		:= ""
		cConsil		:= "2"
		
		If Eval(bRetInfo,"ZZ9_TIPO",nAux) == "11" 
			cParcAux 	:= PadR(Eval(bRetInfo,"ZZ9_PARCEL",nAux),TamSX3("E1_PARCELA")[1])
			cParcAux	:= RetParc(cParc1,cParcAux)	
		ElseIf Eval(bRetInfo,"ZZ9_TIPO",nAux) == "12" 
			cParcAux	:= "XX"	
		EndIf
		
		cChaveZZ9 	:= 	xFilial("ZZ9")+;
						Eval(bRetInfo,"ZZ9_TIPO",nAux)+;
						Eval(bRetInfo,"ZZ9_TPEXP",nAux)+;
						Eval(bRetInfo,"ZZ9_OPERA",nAux)+;
						Eval(bRetInfo,"ZZ9_PRODUT",nAux)+;
						Eval(bRetInfo,"ZZ9_NSU",nAux)+;
						cParcAux+;//Eval(bRetInfo,"ZZ9_PARCEL",nAux)																
						Eval(bRetInfo,"ZZ9_NUMLOT",nAux)
						
		lAchouZZ9	:= ZZ9->(Dbseek(cChaveZZ9))
		
		If !lAchouZZ9
			Begin Transaction
				Reclock("ZZ9",.T.)
				ZZ9->ZZ9_FILIAL	:= xFilial("ZZ9")
				
				cTipoZZ9		:= Eval(bRetInfo,"ZZ9_TIPO",nAux)
				ZZ9->ZZ9_TIPO	:= cTipoZZ9
				ZZ9->ZZ9_NUMSEQ	:= Eval(bRetInfo,"ZZ9_NUMSEQ",nAux)
				ZZ9->ZZ9_NUMEST	:= UPPER(Eval(bRetInfo,"ZZ9_NUMEST",nAux))
				ZZ9->ZZ9_NOMEES	:= UPPER(Eval(bRetInfo,"ZZ9_NOMEES",nAux))
				ZZ9->ZZ9_NUMLOT	:= Eval(bRetInfo,"ZZ9_NUMLOT",nAux)
							
				ZZ9->ZZ9_PARCEL	:= cParcAux
				ZZ9->ZZ9_PLANO	:= Eval(bRetInfo,"ZZ9_PLANO",nAux)
				ZZ9->ZZ9_NSU	:= Eval(bRetInfo,"ZZ9_NSU",nAux)
				ZZ9->ZZ9_AUTORI	:= Eval(bRetInfo,"ZZ9_AUTORI",nAux)
				ZZ9->ZZ9_CARTAO	:= Eval(bRetInfo,"ZZ9_CARTAO",nAux)
				ZZ9->ZZ9_DTVEND	:= StoD(Eval(bRetInfo,"ZZ9_DTVEND",nAux))
				ZZ9->ZZ9_DTCRED	:= StoD(Eval(bRetInfo,"ZZ9_DTCRED",nAux))
				
	
				nValBru := Eval(bRetInfo,"ZZ9_VALBRU",nAux)
				nValBru := ConvNum(aLayout11,"ZZ9_VALBRU",nValBru)			
				ZZ9->ZZ9_VALBRU	:= nValBru
	
				nValTxAdm := Eval(bRetInfo,"ZZ9_TXADM",nAux)
				nValTxAdm := ConvNum(aLayout11,"ZZ9_TXADM",nValTxAdm)			
				ZZ9->ZZ9_TXADM	:= nValTxAdm
				ZZ9->ZZ9_STXADM	:= nValTxAdm
	
				nValTxAnt := Eval(bRetInfo,"ZZ9_TXANTE",nAux)
				nValTxAnt := ConvNum(aLayout11,"ZZ9_TXANTE",nValTxAnt)			
				ZZ9->ZZ9_TXANTE	:= nValTxAnt
	
				nValLiq := Eval(bRetInfo,"ZZ9_LIGPAG",nAux)
				nValLiq := ConvNum(aLayout11,"ZZ9_LIGPAG",nValLiq)			
				ZZ9->ZZ9_LIGPAG	:= nValLiq
				ZZ9->ZZ9_SALDO	:= nValLiq
				
				ZZ9->ZZ9_NUMANT	:= Eval(bRetInfo,"ZZ9_NUMANT",nAux)
				ZZ9->ZZ9_TPEXP	:= Eval(bRetInfo,"ZZ9_TPEXP",nAux)
				ZZ9->ZZ9_STATUS	:= Eval(bRetInfo,"ZZ9_STATUS",nAux)
				ZZ9->ZZ9_PRODUT	:= Eval(bRetInfo,"ZZ9_PRODUT",nAux)
				ZZ9->ZZ9_OPERA	:= Eval(bRetInfo,"ZZ9_OPERA",nAux)
				ZZ9->ZZ9_BANCO	:= Eval(bRetInfo,"ZZ9_BANCO",nAux)
				ZZ9->ZZ9_AGENCI	:= Eval(bRetInfo,"ZZ9_AGENCI",nAux)
				ZZ9->ZZ9_CONTA	:= Eval(bRetInfo,"ZZ9_CONTA",nAux)
				ZZ9->ZZ9_IDCONC	:= Eval(bRetInfo,"ZZ9_IDCONC",nAux)
				ZZ9->ZZ9_DESAJU	:= Eval(bRetInfo,"ZZ9_DESAJU",nAux)
		
				ZZ9->ZZ9_DATA	:= DDataBase
				ZZ9->ZZ9_HORA	:= Left(TIME(),5)
				ZZ9->ZZ9_ARQUIV	:= cFile
				ZZ9->ZZ9_LINHA	:= Eval(bRetInfo,"LINHA",nAux) 
				
				If 	cTipoZZ9 == "11" // pagamento
					U_GENMF04D(cTmpAlias,ZZ9->ZZ9_NSU,ZZ9->ZZ9_PARCEL, (ZZ9->ZZ9_LIGPAG+ZZ9->ZZ9_STXADM) ,ZZ9->ZZ9_DTCRED,@cSituac,@cMsg,ZZ9->ZZ9_TIPO,@cConsil,ZZ9->ZZ9_OPERA,ZZ9->ZZ9_TXADM,ZZ9->ZZ9_VALBRUT,ZZ9->ZZ9_PRODUT,ZZ9->ZZ9_DTVEND)
				ElseIf 	ZZ9->ZZ9_TIPO == "12" // estorno
					U_GENMF04E(cTmpAlias,ZZ9->ZZ9_NSU,ZZ9->ZZ9_PARCEL, (ZZ9->ZZ9_LIGPAG+ZZ9->ZZ9_STXADM) ,ZZ9->ZZ9_DTCRED,@cSituac,@cMsg,ZZ9->ZZ9_TIPO,@cConsil,ZZ9->ZZ9_OPERA,ZZ9->ZZ9_TXADM,ZZ9->ZZ9_VALBRUT,ZZ9->ZZ9_PRODUT)
				EndIf
				
				ZZ9->ZZ9_SITUAC	:= cSituac//1=Nao validado;2=Consistente;3=Inconsistente
				ZZ9->ZZ9_MSG	:= cMsg
				ZZ9->ZZ9_CONCIL	:= cConsil
							
				MsUnLock()
							
				nRegOk++
				If Select(cTmpAlias) > 0
					(cTmpAlias)->(DbCloseArea())
				EndIf
				
		    End Transaction
		Else
			nRegNOk++
			//cMsgErro += " Registro j� existe na base de dados e ser� ignorado linha: "+StrZero(Eval(bRetInfo,"LINHA",nAux),9)+" para o arquivo: "+cFile+cEnt
			FileLog(" Registro j� existe na base de dados "+AllTrim(ZZ9->ZZ9_ARQUIV)+" linha "+StrZero(ZZ9->ZZ9_LINHA,6)+" e ser� ignorado linha: "+StrZero(Eval(bRetInfo,"LINHA",nAux),6)+" para o arquivo: "+cFile)
		EndIf
		End Transaction
	Next nAux
//End Transaction

If nRegOk == 0 
	lRet := .F.
EndIf

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENMF002  �Autor  �Microsiga           � Data �  11/16/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RetParc(cParc1,cParcAux)

Local cRet		:= ""
Local cWhile	:= ""
Local nWhile	:= 1

If !Empty(cParcAux)
	If IsAlpha( cParc1 )
	
		If IsAlpha( cParcAux )
			cRet := cParcAux
		Else
	
			While nWhile <= Val(cParcAux)
				If nWhile == 1
					cRet	:= cParc1				
				Else
					cRet := Soma1(cRet)
				EndIf
				nWhile++
			EndDo
					
		EndIf
		
	Else
		
		If IsAlpha( cParcAux )
			nWhile	:= 0
			While cWhile < cParcAux
				nWhile++
				If Empty(cWhile)
					cWhile	:= cParc1
				Else
					cWhile	:= 	Soma1(cWhile)
				EndIf
				
			EndDo
			cRet	:= StrZero(nWhile,Len(AllTrim(cParc1)))
		Else	
		
			cRet := cParcAux
			
		EndIf
		
	EndIf
EndIf

cRet := PadR(AllTrim(cRet),TamSX3("E1_PARCELA")[1])

Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENMF002  �Autor  �Microsiga           � Data �  11/17/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ConvNum(aLayout11,cField,cValor)

Local nRet		:= 0
Local nTanAux	:= 0

nTanAux := aLayout11[aScan(aLayout11, {|y| AllTrim(y[1]) == cField } )][2]
nRet	:= Left(cValor,nTanAux-2)+"."+Right(cValor,2)
nRet	:= Val(nRet)

Return nRet   


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENMF002  �Autor  �Microsiga           � Data �  01/13/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function FileLog(cMsg,lCria,lClose)

Local cDirLog	:= "\logsiga\accesstage\"

Default lCria	:= .F.
Default lClose	:= .F.

If lCria
	cFileLog	:= cDirLog+CriaTrab(nil,.F.)+".log"
	nFileLog	:= fCreate(cFileLog)
	If nFileLog < 0
		Return .F.
	Else
		Return .T.	
	EndIf
EndIf

If lClose
	fClose(nFileLog)
	Return .T.	
EndIf

FSeek(nFileLog,0,2)
FWrite(nFileLog, cMsg + chr(13) + chr(10))

	
Return nil

