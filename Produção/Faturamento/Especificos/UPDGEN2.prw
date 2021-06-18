#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

User Function UPDGEN2()

Prepare Environment Empresa "00" Filial "1022"
UPDGEN2A()
Reset Environment

Return()

Static Function UPDGEN2A

cIdnfe := "000001"
dbSelectArea("SF1")
dbSetOrder(1)
dbGoTop()
dbSeek(xFilial("SF1"))
While !EOF() .and. SF1->F1_FILIAL = xFilial("SF1")
	If empty(SF1->F1_XIDNFE)
		Reclock("SF1",.F.)
		SF1->F1_XIDNFE := cIdnfe
		MsUnlock()
		cIdnfe := soma1(cIdnfe)
	Endif
	dbSkip()
Enddo

Return()
