#INCLUDE "Totvs.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#include "Fileio.ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'FWEditPanel.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#include "apwebex.ch"


User Function GENA107()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verificação para saber se a rotina esta sendo chamada pela Schedule³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Prepare Environment Empresa "00" Filial "1022"

If LockByName("GENA107",.T.,.T.,.T.)

	Conout("GENA107 - iniciando importação de imagens. "+DtoC(DDataBase)+" - "+Time())

	ProcImg()
	
	UnLockByName("GENA107",.T.,.T.,.T.)
	
	Conout("GENA107 - finalizando importação de imagens. "+DtoC(DDataBase)+" - "+Time())
	
Else
	Conout("GENA107 - não foi possível iniciar a rotina pois a mesma já está sendo executada! "+DtoC(DDataBase)+" - "+Time())
EndIf

Reset Environment

Return()

Static Function ProcImg()

Local aFiles	:= {} 
Local aFileAux	:= {}
Local aSizes	:= {}
Local nHandle	:= {}
Local cPacth	:= "\ImgTempProc\"
Local cImgDir	:= ""
Local cString	:= ""
Local cEncode64	:= ""
Local nQtdFile	:= 0
Local nAuxImg	:= 0
Local cIsbn		:= ""
Local cLogProd	:= ""
Local cFile		:= ""
Local nQtdProc	:= GetMv("GEN_FAT275",.f.,1)
Local lCopy		:= .F.

ZZL->(DbSetOrder(9))

aFiles		:= Directory(cPacth+"Pendentes\*.*")
nQtdFile	:= IIF( nQtdProc <= Len(aFiles) , nQtdProc , Len(aFiles) )

For nAuxImg := 1 To nQtdFile
	lCopy		:= .F.
	cIsbn		:= ""
	cEncode64	:= ""
	cImgDir		:= cPacth+"Pendentes\"+aFiles[nAuxImg][1]
	cImgPara	:= cPacth+"Processadas\"+aFiles[nAuxImg][1]
	cFile		:= Separa(aFiles[nAuxImg][1],"\")[Len(Separa(aFiles[nAuxImg][1],"\"))]

	IF At(".",aFiles[nAuxImg][1])
		cIsbn := Left(aFiles[nAuxImg][1],At(".",aFiles[nAuxImg][1])-1)
	ENDIF

	IF Empty(cIsbn)
		cLogProd += "ISBN invalido para imagem "+cImgDir+Chr(13)+Chr(10)
		Loop
	ENDIF
	
	IF !ZZL->( DbSeek( xFilial("ZZL") + cIsbn ) )
		cLogProd += "ISBN invalido para imagem "+cImgDir+Chr(13)+Chr(10)
		Loop
	ENDIF

	ADir(cImgDir, aFileAux, aSizes)//Verifica o tamanho do arquivo, parâmetro exigido na FRead.	
	nHandle := fopen(cImgDir, FO_READWRITE + FO_SHARED )
	cString := ""

	FRead( nHandle, cString, aSizes[1] ) //Carrega na variável cString, a string ASCII do arquivo.
	fclose(nHandle)
	cEncode64	:= Encode64(cString,NIL,.F.,.F.)//Encode64(,cPacth,.F.,.F.)

	IF Empty(cEncode64)
		cLogProd += "ISBN invalido para imagem "+cImgDir+Chr(13)+Chr(10)
		Loop
	ENDIF	

	IF Select("TMP_ISBN") > 0 
		TMP_ISBN->(DbCloseArea())
	ENDIF

	BeginSql Alias "TMP_ISBN"
		SELECT ZZL.R_E_C_N_O_ RECZZL, ZZU.R_E_C_N_O_ RECZZU,ZZU_PRODUT FROM %Table:ZZL% ZZL
		JOIN %Table:ZZU% ZZU
		ON ZZU_FILIAL = %xFilial:ZZU%
		AND ZZU.ZZU_PRODUT = ZZL_COD
		AND ZZU.%NotDel%
		AND ZZU.ZZU_PRINCI = '1'
		WHERE ZZL_FILIAL = %xFilial:ZZL%
		AND ZZL.%NotDel%
		AND ZZL.ZZL_IDTPPU IN ('1                 ','14                ')
		AND ZZL_ISBN = %Exp:cIsbn%
	EndSql

	COPY FILE (cImgDir) TO (cImgPara)
	lCopy := File(cImgPara)

	IF lCopy
		TMP_ISBN->(DbGoTop())
		While TMP_ISBN->(!EOF())		
			Begin Transaction
				ZZU->(DbGoTo( TMP_ISBN->RECZZU ))
				RecLock("ZZU",.F.)
				ZZU->(DbDelete())
				MsUnlock()
				GravaImg(cFile,cString,cEncode64, TMP_ISBN->ZZU_PRODUT,aFiles[nAuxImg])

				ZZL->(DbGoTo( TMP_ISBN->RECZZL ))

				RecLock("ZZL",.F.)
					ZZL->ZZL_DTALTE	:= DDataBase
					ZZL->ZZL_HALTER	:= Time()
					ZZL->ZZL_USRALT	:= "GENA107"
				MsUnLock()

			End Transaction			
			TMP_ISBN->(DbSkip())
		EndDo
		TMP_ISBN->(DbCloseArea())

		FErase(cImgDir)
	ENDIF 	

Next nAuxImg

IF !Empty(cLogProd)
	U_GenSendMail(,,,"noreply@grupogen.com.br","desenvolvimento@grupogen.com.br",oemtoansi("GENA107 - Processamento de imagens - Log de Erro"),cLogProd,,,.F.)
ENDIF	

Return nil


Static Function GravaImg(cFile, cString, cEncode64, cProduto, aFile)

	RecLock("ZZU",.T.)
	ZZU->ZZU_PRODUT	:= cProduto
	ZZU->ZZU_TITULO	:= "Carga via rotina temporaria GENA107"
	ZZU->ZZU_CODIMG	:= GetSX8Num("ZZU","ZZU_CODIMG")
	ZZU->ZZU_FILE	:= AllTrim(cFile)
	ZZU->ZZU_TIPO	:= Separa(cFile,".")[Len(Separa(cFile,"."))]
	ZZU->ZZU_SIZE	:= aFile[2]
	ZZU->ZZU_B64	:= cEncode64
	ZZU->ZZU_MEMO	:= cString
	ZZU->ZZU_DTINC	:= DDataBase
	ZZU->ZZU_HRINCL	:= Left(Time(),5)
	ZZU->ZZU_PRINCI	:= "1"
	ZZU->ZZU_DTALT	:= DDataBase
	ZZU->ZZU_HRALT	:= Left(Time(),5)

	MsUnLock()
	ConfirmSX8()

Return nil
