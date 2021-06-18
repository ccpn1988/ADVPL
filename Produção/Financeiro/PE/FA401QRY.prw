
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA401QRY  บAutor  ณMicrosiga           บ Data ณ  09/15/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณponto de entrada da rotina fina401 fun็ใo Fa401SqlCImp      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FA401QRY()

Local cQuery	:= ParamIxb[1]
Local cRemov	:= "OR  (PAI.E2_BAIXA = ' ' AND  PAI.E2_EMISSAO BETWEEN '"+DtoS(MV_PAR02)+"' AND '"+DtoS(MV_PAR03)+"' )"


//SELECT SE2.E2_FILIAL, SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_CODRET,SE2.E2_VENCREA, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, SE2.E2_NATUREZ, SE2.E2_BAIXA, SE2.E2_EMIS1,SE2.E2_SEQBX, SE2.E2_EMISSAO,SE2.E2_VENCTO, SE2.E2_VALOR, SE2.E2_INSS, SE2.E2_IRRF, SE2.E2_ISS, SE2.E2_PIS, SE2.E2_COFINS, SE2.E2_CSLL, SE2.E2_PARCIR, SE2.E2_PARCPIS,SE2.E2_FILORIG,SE2.R_E_C_N_O_ , NVL(PAI.R_E_C_N_O_,0) RECNOPAI , SE2.E2_TITPAI  FROM SE2000 SE2  LEFT JOIN SE2000 PAI ON  (SE2.E2_FILIAL = PAI.E2_FILIAL AND  PAI.E2_PREFIXO||PAI.E2_NUM||PAI.E2_PARCELA||PAI.E2_TIPO||PAI.E2_FORNECE||PAI.E2_LOJA = SE2.E2_TITPAI AND  PAI.E2_TIPO NOT IN ('NCC','NDF','IR-','CS-','CF-','PI-','AB-','FB-','FC-','FU-','FP-','FM-','IR-','IN-','IS-','PI-','CF-','CS-','FE-','IV-','ISS','TX ','INS','SES','PR ','PA ','TXA') AND  PAI.D_E_L_E_T_= ' ' ) JOIN SA2000 SA2 ON (PAI.E2_FORNECE = SA2.A2_COD AND PAI.E2_LOJA = SA2.A2_LOJA AND SA2.D_E_L_E_T_ = ' '  AND (SA2.A2_TIPO = 'F'  OR (SA2.A2_TIPO = 'J' AND SA2.A2_IRPROG = '1')) )  WHERE SE2.E2_FILIAL IN ('1001','1012','1021','1022','1101')     AND SE2.E2_DIRF IN ('1','S' )   AND SE2.E2_CODRET != ' ' AND  SE2.E2_TIPO IN ('NCC','NDF','IR-','CS-','CF-','PI-','AB-','FB-','FC-','FU-','FP-','FM-','IR-','IN-','IS-','PI-','CF-','CS-','FE-','IV-','ISS','TX ','INS','SES','PR ','PA ','TXA') AND (( SE2.E2_NATUREZ NOT IN ('PCC','COFINS','CSLL') AND ( (PAI.E2_BAIXA BETWEEN '20160101' AND '20161231' ) OR  (PAI.E2_BAIXA = ' ' AND  PAI.E2_EMIS1 BETWEEN '20160101' AND '20161231' ) )) OR ( SE2.E2_NATUREZ IN ('PCC','COFINS','CSLL') AND (PAI.E2_BAIXA BETWEEN '20160101' AND '20161231' ))) AND  SE2.D_E_L_E_T_ = ' ' ORDER BY SE2.E2_FILIAL , SE2.E2_FORNECE,SE2.E2_LOJA , SE2.E2_CODRET ,SE2.E2_BAIXA , SE2.E2_PREFIXO , SE2.E2_NUM , SE2.E2_PARCELA , SE2.E2_TIPO
If 	MV_PAR01 == 4 .AND.; // pela baixa
	MV_PAR04 == 1 // pessoa fisica
	
	//cQuery := StrTran(cQuery,cRemov,'')
	cQuery := StrTran(cQuery,"SE2.D_E_L_E_T_ = ' '","SE2.D_E_L_E_T_ = ' ' AND PAI.E2_BAIXA <> ' ' AND PAI.E2_CODRET  <> ' ' AND SE2.E2_CODRET  <> ' '  ")
	
	If Left(cFilAnt,1) == "9"		
		cQuery := StrTran(cQuery,"SE2.E2_FILIAL = PAI.E2_FILIAL AND  ",'')
	EndIf
		
EndIf

WfForceDir("\dirf_2017\"+cFilAnt+"\")
MemoWrite("\dirf_2017\"+cFilAnt+"\"+DtoS(DDataBase)+"_FA401QRY_"+StrTran(Time(),":","")+".sql",cQuery)


Return cQuery

