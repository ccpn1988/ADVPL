
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF401QRY2  บAutor  ณMicrosiga           บ Data ณ  09/15/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณponto de entrada da rotina fina401 fun็ใo F401BaseIr        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function F401QRY2()

Local cQuery	:= ParamIxb[1]

If 	MV_PAR01 == 4 .AND.; // pela baixa
	MV_PAR04 == 1 // pessoa fisica
	
	cQuery	:= cQuery+=" AND SE2.E2_BAIXA <> ' ' AND SE2.E2_CODRET  NOT IN ('0422') "
Else
	/* deve enviar apenas titulos onde ouve a reten็ใo*/
	cQuery	:= cQuery+=" AND NOT ( SE2.E2_PRETIRF IN (' ','1','6') AND F_GET_TX_IR(SE2.E2_FILIAL,SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA,1) = 0 ) "
EndIf

WfForceDir("\dirf_2017\"+cFilAnt+"\")
MemoWrite("\dirf_2017\"+cFilAnt+"\"+DtoS(DDataBase)+"_F401QRY2_"+SA2->A2_COD+".sql",cQuery)

return cQuery