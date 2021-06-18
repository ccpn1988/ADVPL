#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCAUTO    ºAutor  ³Jorge Paiva         º Data ³  08/21/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para lancar os servicos de autonomos da tabela sz1º±±
±±º          ³ para a tabela de folha de pagto tabela src                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENM200()

Processa ( {  ||  GeraServ() } )

Return()


Static Function GeraServ()

LOCAL xArea  := GetArea()
LOCAL aLanc  := {}
LOCAL nPos   := 0
Local n_inc := 0
Local cProcesso	:="00003"
Local cRoteiro	:="AUT"
Local aPerAtual	:= {}	


//adaptcao padrao v12 - coelho
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄysÌPÇJ¿
//³usa funcao do padrao para busca do periodo a ser encerrado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄysÌPÇJÙ
fGetPerAtual( @aPerAtual, , cProcesso, cRoteiro )
cAnoFech	:=aPerAtual[1,5]
cMesFech	:=aPerAtual[1,4]
dIniMesFec	:=aPerAtual[1,6]
dFimMesFec  :=aPerAtual[1,7]
dPgto		:=aPerAtual[1,11]
cPeriodo	:=aPerAtual[1,5]+aPerAtual[1,4]

dbSelectArea("SZ1")
dbGotop("SZ1")

Do While !SZ1->(EOF())
	
	IF MESANO(SZ1->Z1_DATA) <> cPeriodo
		SZ1->(dbSkip()); LOOP
	ENDIF
	nPos := ascan(aLanc,{|x| x[1] + x[2] + x[3] + x[4] + x[5] = SZ1->Z1_FILIAL + SZ1->Z1_MAT + SZ1->Z1_CC + SZ1->Z1_CLASSE + SZ1->Z1_ITEM })
	IF nPos > 0
		aLanc[nPos,6] += SZ1->Z1_VALOR
	Else
		AADD(aLanc,{SZ1->Z1_FILIAL , SZ1->Z1_MAT , SZ1->Z1_CC , SZ1->Z1_CLASSE , SZ1->Z1_ITEM , SZ1->Z1_VALOR, SZ1->Z1_HORAS})
	Endif
	n_inc ++
	SZ1->(dbSkip())
EndDo

DelServ()

DBSELECTAREA("RGB")
ProcRegua(n_inc)
FOR I := 1 TO LEN(aLanc)
	IncProc ()
	RecLock("RGB",.T.)
	RGB->RGB_FILIAL := aLanc[I,1]
	RGB->RGB_MAT    := aLanc[I,2]
	RGB->RGB_PD     := '257'
	RGB->RGB_TIPO1  := 'V'
	RGB->RGB_CC     := aLanc[I,3]
	RGB->RGB_HORAS  := aLanc[I,7]
	RGB->RGB_VALOR  := aLanc[I,6]
	RGB->RGB_ITEM   := aLanc[I,5]
	RGB->RGB_CLVL   := aLanc[I,4]
	RGB->RGB_TIPO2  := 'G'
	RGB->RGB_ROTEIR	:="AUT"
	RGB->RGB_SEMANA	:="01"
	RGB->RGB_PERIOD	:=cPeriodo
	RGB->RGB_PROCES	:=cProcesso
	
	RGB->(MsUnLock())
Next

aLanc  := {}

RestArea(xArea)
dbClosearea("SZ1")
dbClosearea("RGB")

Return()


Static Function DelServ()

cQueryDelet := "DELETE FROM " +RETSQLNAME("RGB")
cQueryDelet += " WHERE RGB_PD = '257' AND RGB_TIPO2 <> 'I'   "

TcSqlExec( cQueryDelet )

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Acerta257 ºAutor  ³Jorge Paiva TOTVS Rio Data ³  10/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao provisoria para corrigir duplicidade da verba 257   º±±
±±º          ³ ate correção do fonte padrao de Multiplos Vinculos        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Acerta257()

Local xArea  := GetArea()

If SRA->RA_MAT = '601179'
	M:= 1
Endif

If Len(APD) > 0
	For w := 1 to Len(APD)
		If APD[W,1] = '257' .AND. APD[W,13] = SRA->RA_ITEM .AND. APD[W,14] = SRA->RA_CLVL
			APD[W,9] := 'D'
		Endif
	Next
Endif

RestArea(xArea)

Return()
