#include 'protheus.ch'
#include 'parmtype.ch'

user function ADVPLR02()
	Private oReport
	
	ReportDef()
	
	oReport:PrintDialog()
	
return

Static Function ReportDef()
	Local oSection1

	oReport := TReport():New('ADVPLR02', 'Espelho do Movimento', '', {|oReport| PrintReport(oReport) }, 'Espelho do Movimento' )
	
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
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	
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
	
	oReport:EndPage()	
	
Return