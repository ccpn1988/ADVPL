#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บ Autor ณ AP6 IDE            บ Data ณ  19/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function SLDB9()

aEmpCD := {}
aAdd(aEmpCD,"2022")
aAdd(aEmpCD,"3022")
aAdd(aEmpCD,"4022")
aAdd(aEmpCD,"6022")
aAdd(aEmpCD,"1022")

For i := 1 to len(aEmpCD)
	SLDB9A(aEmpCD[i])
Next i

Return()


Static Function SLDB9A(cEmpCD)

RPCSetType(3)
Prepare Environment Empresa "00" Filial cEmpCD //EXECUTA NA EMPRESA 1022 GEN DEPOSITO SP

_cAliQry	:= GetNextAlias()

cQry := "SELECT DISTINCT B2_COD FROM "+RetSqlName("SB2")+" WHERE B2_FILIAL = '"+xFilial("SB2")+"'
If cEmpCD <> "1022"
	cQry += " AND B2_COD IN (SELECT B1_COD FROM "+RetSqlName("SB1")+" WHERE B1_GRUPO <> '9999' AND B1_XSITOBR = '111' AND D_E_L_E_T_ = ' ')
	//cQry += " AND B2_LOCAL NOT IN ('02','03')
	nMax := 3
Else
	cQry += " AND B2_COD IN (SELECT B1_COD FROM "+RetSqlName("SB1")+" WHERE B1_GRUPO <> '9999' AND D_E_L_E_T_ = ' ')
	//cQry += " AND B2_LOCAL NOT IN ('02','03','04','05')
	nMax := 5
Endif
cQry += " AND D_E_L_E_T_ = ' ' ORDER BY B2_COD
If Select(_cAliQry) > 0
	dbSelectArea(_cAliQry)
	(_cAliQry)->(dbCloseArea())
EndIf
dbUseArea(.T., "TOPCONN", TcGenQry(,,cQry), _cAliQry, .F., .T.)

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()

Do While !(_cAliQry)->(EOF())
	cProd := (_cAliQry)->B2_COD
	nQt := 0
	For nAmz := 1 to nMax
		cLoc := strzero(nAmz,2)
		dbSelectArea("SB9")
		dbSetOrder(1)
		If !dbSeek(xFilial("SB9")+cProd+cLoc) //SE NAO ENCONTRAR, GERA SALDO INICIAL
			nOp := 3
			aSldIni  := {}
			aAdd(aSldIni  ,{"B9_COD",cProd,Nil})
			aAdd(aSldIni  ,{"B9_LOCAL",cLoc,Nil})
			aAdd(aSldIni  ,{"B9_QINI",nQt,Nil})
			MsExecAuto({|x,y,z|MATA220(x,y,z)},aSldIni,nOp)
		Endif
	Next nAmz
	(_cAliQry)->(dbSkip())
	
Enddo

Reset Environment

Return()
