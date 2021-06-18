#include "protheus.ch"

USER FUNCTION TMP003

If !MsgYesNo("Deseja Executar a Função?") 
	Return
Endif

RecLock("SBM",.T.)
SBM->BM_FILIAL  := xFilial("SBM")
SBM->BM_GRUPO   := '601'
SBM->BM_DESC    := 'SOC APLIC HUMANAS - DIDÁTICA'
SBM->BM_PROORI  := '0'
SBM->BM_CLASGRU := '1'
SBM->BM_XCATEG  := 'D'
SBM->(MsUnlock())
  
RecLock("SBM",.T.)
SBM->BM_FILIAL  := xFilial("SBM")
SBM->BM_GRUPO   := '602'
SBM->BM_DESC    := 'SOC APLIC HUMANAS - PROFISSION'
SBM->BM_PROORI  := '0'
SBM->BM_CLASGRU := '1'
SBM->BM_XCATEG  := 'P'
SBM->(MsUnlock())

RecLock("SBM",.T.)
SBM->BM_FILIAL  := xFilial("SBM")
SBM->BM_GRUPO   := '603'
SBM->BM_DESC    := 'SOC APLIC HUMANAS - INT GERAL '
SBM->BM_PROORI  := '0'
SBM->BM_CLASGRU := '1'
SBM->BM_XCATEG  := 'I'
SBM->(MsUnlock())

SBM->(DBSetOrder(1))
If SBM->(DBSeek(xFilial("SBM")+"301"))
	RecLock("SBM",.F.)
	SBM->BM_DESC    := 'CIÊNCIAS EXATAS - DIDÁTICA'
	SBM->(MsUnlock())
Endif               

If SBM->(DBSeek(xFilial("SBM")+"302"))
	RecLock("SBM",.F.)
	SBM->BM_DESC    := 'CIÊNCIAS EXATAS - PROFISSIONAL'
	SBM->(MsUnlock())
Endif               

If SBM->(DBSeek(xFilial("SBM")+"303"))
	RecLock("SBM",.F.)
	SBM->BM_DESC    := 'CIÊNCIAS EXATAS - INTER GERAL'
	SBM->(MsUnlock())
Endif               

/*------------------------------------------------------------------------------------------                      
  CLASSE 601
--------------------------------------------------------------------------------------------*/
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '1  '
SZ2->Z2_DESC    := '1  '
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  50
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '132'
SZ2->Z2_DESC    := '132'
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '152'
SZ2->Z2_DESC    := '152'
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '155'
SZ2->Z2_DESC    := '155'
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '157'
SZ2->Z2_DESC    := '157'
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '158'
SZ2->Z2_DESC    := '158'
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '159'
SZ2->Z2_DESC    := '159'
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '160'
SZ2->Z2_DESC    := '160'
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '161'
SZ2->Z2_DESC    := '161'
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '162'
SZ2->Z2_DESC    := '162'
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '166'
SZ2->Z2_DESC    := '166'
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  45
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '192'
SZ2->Z2_DESC    := '192'
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  30
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '193'
SZ2->Z2_DESC    := '193'
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '2  '
SZ2->Z2_DESC    := '2  '
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  0 
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '3  '
SZ2->Z2_DESC    := '3  '
SZ2->Z2_CLASSE  := '601'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - DID '
SZ2->Z2_PERCDES :=  80
SZ2->(MsUnlock())

/*------------------------------------------------------------------------------------------                      
  CLASSE 602
--------------------------------------------------------------------------------------------*/
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '1  '
SZ2->Z2_DESC    := '1  '
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  50
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '132'
SZ2->Z2_DESC    := '132'
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '152'
SZ2->Z2_DESC    := '152'
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '155'
SZ2->Z2_DESC    := '155'
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '157'
SZ2->Z2_DESC    := '157'
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '158'
SZ2->Z2_DESC    := '158'
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '159'
SZ2->Z2_DESC    := '159'
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '160'
SZ2->Z2_DESC    := '160'
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '161'
SZ2->Z2_DESC    := '161'
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '162'
SZ2->Z2_DESC    := '162'
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '166'
SZ2->Z2_DESC    := '166'
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  45
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '192'
SZ2->Z2_DESC    := '192'
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  30
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '193'
SZ2->Z2_DESC    := '193'
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '2  '
SZ2->Z2_DESC    := '2  '
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  0 
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '3  '
SZ2->Z2_DESC    := '3  '
SZ2->Z2_CLASSE  := '602'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - PROF'
SZ2->Z2_PERCDES :=  80
SZ2->(MsUnlock())
                      
/*------------------------------------------------------------------------------------------                      
  CLASSE 603
--------------------------------------------------------------------------------------------*/
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '1  '
SZ2->Z2_DESC    := '1  '
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  50
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '132'
SZ2->Z2_DESC    := '132'
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '152'
SZ2->Z2_DESC    := '152'
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  45
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '155'
SZ2->Z2_DESC    := '155'
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '157'
SZ2->Z2_DESC    := '157'
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '158'
SZ2->Z2_DESC    := '158'
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '159'
SZ2->Z2_DESC    := '159'
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  45
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '160'
SZ2->Z2_DESC    := '160'
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '161'
SZ2->Z2_DESC    := '161'
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  45
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '162'
SZ2->Z2_DESC    := '162'
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '166'
SZ2->Z2_DESC    := '166'
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  45
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '192'
SZ2->Z2_DESC    := '192'
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  40
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '193'
SZ2->Z2_DESC    := '193'
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  50
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '2  '
SZ2->Z2_DESC    := '2  '
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  0 
SZ2->(MsUnlock())
                      
RecLock("SZ2",.T.)
SZ2->Z2_FILIAL  := xFilial("SZ2")
SZ2->Z2_TIPO    := '3  '
SZ2->Z2_DESC    := '3  '
SZ2->Z2_CLASSE  := '603'
SZ2->Z2_DESCCLA := 'SOC APLIC HUM - INT '
SZ2->Z2_PERCDES :=  80
SZ2->(MsUnlock())

/*------------------------------------------------------------------------------------------                      
  CLASSE 301
--------------------------------------------------------------------------------------------*/                    
SZ2->(DBSetOrder(1))
If SZ2->(DBSeek(xFilial("SZ2")+"1  "+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"132"+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"152"+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"155"+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"157"+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"158"+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"159"+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"160"+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"161"+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"162"+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"166"+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"192"+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"193"+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"2  "+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"3  "+"301"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - DID  '
	SZ2->(MsUnlock())
Endif               

/*------------------------------------------------------------------------------------------                      
  CLASSE 302
--------------------------------------------------------------------------------------------*/                    
SZ2->(DBSetOrder(1))
If SZ2->(DBSeek(xFilial("SZ2")+"1  "+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"132"+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"152"+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"155"+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"157"+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"158"+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"159"+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"160"+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"161"+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"162"+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"166"+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"192"+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"193"+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"2  "+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"3  "+"302"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - PROF '
	SZ2->(MsUnlock())
Endif               

/*------------------------------------------------------------------------------------------                      
  CLASSE 303
--------------------------------------------------------------------------------------------*/                    
SZ2->(DBSetOrder(1))
If SZ2->(DBSeek(xFilial("SZ2")+"1  "+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"132"+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"152"+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"155"+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"157"+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"158"+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"159"+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"160"+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"161"+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"162"+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"166"+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"192"+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"193"+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"2  "+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

If SZ2->(DBSeek(xFilial("SZ2")+"3  "+"303"))
	RecLock("SZ2",.F.)
	SZ2->Z2_DESCCLA := 'CIÊNC EXATAS - INT G'
	SZ2->(MsUnlock())
Endif               

SZ2->(DBSetOrder(1))
If SZ2->(DBSeek(xFilial("SZ2")+"1  "+"601"))
	RecLock("SZ2",.F.)
	SZ2->Z2_PERCDES := 50
	SZ2->(MsUnlock())
Endif               

MsgInfo("Alterações efetuadas com sucesso!")
