#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

User Function GENA015

Local _aAreaSA1	:= SA1->(GetArea())
Local _nQtd		:= ascan(aHeader,{|x| alltrim(x[2])=="C6_QTDLIB"})

//Pesquisa cliente
SA1->(DbSetOrder(1))
IF SA1->(DBSEEK(XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
    
	//Valida condicao de pagamento e tipo de frete
	If SA1->A1_COND <> SC5->C5_CONDPAG .or. (SA1->A1_TPFRET <> SC5->C5_TPFRETE .and. SA1->A1_TPFRET == 'F') 
	
		For _nx:=1 To Len(aCols)
					
			aCols[_nx][_nQtd] := 0	
										
		Next _nx				
	
	ENDIF
ENDIF

RestArea(_aAreaSA1)

Return 
