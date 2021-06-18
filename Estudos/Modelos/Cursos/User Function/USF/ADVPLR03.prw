#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

user function ADVPLR03()
	Private oReport
	Private cPerg	:= 'U_ADVPLR03'
	
	ValidPerg()
	
	If !Pergunte(cPerg, .T.)
		return
	EndIf
		
	ReportDef()
	
	oReport:PrintDialog()
	
return

Static Function ReportDef()
	Local oSection1

	oReport := TReport():New('ADVPLR03', 'Movimentos do Periodo de ' + DtoC(MV_PAR01) + ' até ' + DtoC(MV_PAR02), cPerg, {|oReport| PrintReport(oReport) }, 'Movimentos do Periodo ' )
	
	oSection1 := TRSection():New(oReport, 'Dados Gerais', {'ZZ4'})

	TRCell():New(oSection1, "ZZ4_STATUS", "ZZ4")
	TRCell():New(oSection1, "ZZ4_CODIGO", "ZZ4")
	TRCell():New(oSection1, "ZZ4_DATA"	, "ZZ4")
	TRCell():New(oSection1, "ZZ4_TOTAL"	, "ZZ4")
	
	oSection2 := TRSection():New(oReport, 'Detalhes do Movimento', {'ZZ5'})
	TRCell():New(oSection2, "ZZ5_CODZZ2"	, "ZZ5")
	TRCell():New(oSection2, "ZZ5_DESCRI"	, "ZZ5")
	TRCell():New(oSection2, "ZZ5_TOTAL"		, "ZZ5")
	
Return

Static Function PrintReport(oReport)
	Local cQuery
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	
	cQuery := " SELECT R_E_C_N_O_ AS RECNOZZ4 FROM " + RetSqlTab("ZZ4") 
	cQuery += " WHERE " + RetSqlDel('ZZ4')
	cQuery += " AND ZZ4_DATA BETWEEN '" + DtoS(MV_PAR01) + "' AND '"+DtoS(MV_PAR02) + "' "
	
	If Select('QRY') > 0
		QRY->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias 'QRY'
	
	While QRY->(!Eof())
		
		ZZ4->(DbGoto(QRY->RECNOZZ4))
		
		oSection1:Init()
		oSection1:PrintLine()
		
		oSection2:Init()
		
		ZZ5->(DbSetOrder(1))//Filial+CodigoZZ4
		ZZ5->(DbSeek(cSeek := xFilial('ZZ5') + ZZ4->ZZ4_CODIGO))
		
		While ZZ5->(!Eof()) .AND. cSeek == ZZ5->(ZZ5_FILIAL + ZZ5_CODZZ4)
			oSection2:PrintLine()
			ZZ5->(DBSkip())
		EndDo
		
		oSection1:Finish()
		oSection2:Finish()
	
		QRY->(DbSkip())
	EndDo
	
	oReport:EndPage()	
	
Return

Static Function ValidPerg
    Local aRegs    := {}
    Local aAreaSX1 := SX1->(GetArea())
    Local i, j

    SX1->(DbSetOrder(1))

    // Numeracao dos campos:
    // 01 -> X1_GRUPO   02 -> X1_ORDEM    03 -> X1_PERGUNT  04 -> X1_PERSPA  05 -> X1_PERENG
    // 06 -> X1_VARIAVL 07 -> X1_TIPO     08 -> X1_TAMANHO  09 -> X1_DECIMAL 10 -> X1_PRESEL
    // 11 -> X1_GSC     12 -> X1_VALID    13 -> X1_VAR01    14 -> X1_DEF01   15 -> X1_DEFSPA1
    // 16 -> X1_DEFENG1 17 -> X1_CNT01    18 -> X1_VAR02    19 -> X1_DEF02   20 -> X1_DEFSPA2
    // 21 -> X1_DEFENG2 22 -> X1_CNT02    23 -> X1_VAR03    24 -> X1_DEF03   25 -> X1_DEFSPA3
    // 26 -> X1_DEFENG3 27 -> X1_CNT03    28 -> X1_VAR04    29 -> X1_DEF04   30 -> X1_DEFSPA4
    // 31 -> X1_DEFENG4 32 -> X1_CNT04    33 -> X1_VAR05    34 -> X1_DEF05   35 -> X1_DEFSPA5
    // 36 -> X1_DEFENG5 37 -> X1_CNT05    38 -> X1_F3       39 -> X1_GRPSXG

    aAdd(aRegs, {cPerg, "01", "Data de?"  , "", "", "mv_ch1", 'D', 8, 0, 0, 'G', "", "MV_PAR01", "",  "", "", "", "", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
    aAdd(aRegs, {cPerg, "02", "Data ate?" , "", "", "mv_ch2", 'D', 8, 0, 0, 'G', "", "MV_PAR02", "",  "", "", "", "", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

    For i := 1 To Len(aRegs)
        If ! SX1->(DbSeek(cPerg+aRegs[i,2]))
            RecLock("SX1", .T.)

            For j :=1 to SX1->(FCount())
                If j <= Len(aRegs[i])
                    SX1->(FieldPut(j,aRegs[i,j]))
                EndIf
            Next

            SX1->(MsUnlock())
        EndIf
    Next

    SX1->(RestArea(aAreaSX1))
Return
