#include 'protheus.ch'
#include 'parmtype.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'

user function ADVPLA05()

	If Empty(FunName())
		Prepare Environment Empresa '99' Filial '01'
	EndIf

	oDlg := FwDialogModal():New()
	
	oDlg:SetTitle('Resumo Financeiro')
	oDlg:SetSubTitle('Dados do Resumo Financeiro')	
	oDlg:SetSize(350,450)
	
	oDlg:CreateDialog()
	
	oPanelModal	:= oDlg:GetPanelMain()
	
	oLayer := FwLayer():New()
	oLayer:Init(oPanelModal)

	oLayer:AddCollumn('col01', 100, .T.)
	
	oLayer:AddWindow('col01', 'win01', 'Filtros', 20)
	oPanel01 := oLayer:getWinPanel('col01', 'win01')
	
	oLayer:AddWindow('col01', 'win02', 'Dados'	, 40)
	oPanel02 := oLayer:getWinPanel('col01', 'win02')
	
	oLayer:AddWindow('col01', 'win03', 'Gráfico', 40)
	oPanel03 := oLayer:getWinPanel('col01', 'win03')
	
	dDataDe := dDataBase - 30
	dDataAte:= dDatabase 
	
	oLblDe	:= TSay():create(oPanel01, {||  'Data de?' },5,5,,,,,,.T.,,,200,20)
	oGetDe  := TGet():New( 013, 005, { | u | If( PCount() == 0, dDataDe , dDataDe   := u ) },oPanel01, 060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDataDe",,,,.T.  )

    oLblAte	:= TSay():create(oPanel01, {||  'Data Ate?' },5,75,,,,,,.T.,,,200,20)
	oGetAte := TGet():New( 013, 075, { | u | If( PCount() == 0, dDataAte, dDataAte := u ) },oPanel01, 060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDataAte",,,,.T.  )
	
	oBrowse := FwBrowse():New(oPanel02)
	
	oBrowse:disableReport()
	oBrowse:disableConfig()	
	
	oChart := FwChartFactory():New()
	oChart:SetOwner(oPanel03)
	oChart:SetLegend(CONTROL_ALIGN_LEFT)
		
	oBrowse:SetDataQuery(.T.)
	oBrowse:SetAlias('QRY')
	oBrowse:SetQuery(getQuery())
	
	oColumn := FwBrwColumn():New()
	oColumn:SetData({|| QRY->ZZ1_DESCRI })
	oColumn:SetTitle('Grupo de Despesa')
	oColumn:SetSize(50)
	oBrowse:SetColumns({oColumn})
	
	
	oColumn := FwBrwColumn():New()
	oColumn:SetData({|| QRY->ZZ5_TOTAL })
	oColumn:SetTitle('Total')
	oColumn:SetSize(14)
	oColumn:SetAlign(2)
	oColumn:SetDecimal(2)
	oColumn:SetPicture('@e 999,999,999.99')
	oBrowse:SetColumns({oColumn})	
		
	oBrowse:Activate()
	
	
	oDlg:AddButton('Sair'		, {|| oDlg:Deactivate() }, 'Sair', , .T., .T., .T., ) 
	oDlg:AddButton('Atualizar'	, {|| oBrowse:SetQuery(getQuery()), oBrowse:Refresh() }, 'Atualizar',, .T., .T., .T., ) 
		
	oDlg:Activate()	
	
return

Static Function getQuery()
	Local cRet
	
	cRet := " SELECT ZZ1_CODIGO, ZZ1_DESCRI, SUM(ZZ5_TOTAL) ZZ5_TOTAL FROM "  + RetSqlTab('ZZ5')
	cRet += " INNER JOIN " + RetSqlTab('ZZ2') + " ON ZZ5_FILIAL = ZZ2_FILIAL AND ZZ5_CODZZ2 = ZZ2_CODIGO " 
	cRet += " INNER JOIN " + RetSqlTab('ZZ1') + " ON ZZ1_FILIAL = ZZ2_FILIAL AND ZZ1_CODIGO = ZZ2_CODZZ1 "
	cRet += " INNER JOIN " + RetSqlTab('ZZ4') + " ON ZZ4_FILIAL = ZZ5_FILIAL AND ZZ4_CODIGO = ZZ5_CODZZ4 "
	cRet += " WHERE ZZ1.D_E_L_E_T_ <> '*' "
	cRet += " AND ZZ2.D_E_L_E_T_ <> '*' "
	cRet += " AND ZZ4.D_E_L_E_T_ <> '*' "
	cRet += " AND ZZ5.D_E_L_E_T_ <> '*' "	
	cRet += " AND ZZ4_DATA BETWEEN '" + DtoS(dDataDe) +"' AND '" + DtoS(dDataAte) + "' " 	
	cRet += " GROUP BY ZZ1_CODIGO, ZZ1_DESCRI "

	MontaGrafico(cRet)
		 
Return cRet

Static Function MontaGrafico(cQuery)
	
	If Select('QRY1') > 0
		QRY1->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias 'QRY1'
	
	oChart:DeActivate()
	oChart:SetChartDefault(3)
	
	While ! QRY1->(Eof())
		oChart:AddSerie(QRY1->ZZ1_DESCRI, QRY1->ZZ5_TOTAL)	
		QRY1->(DbSkip())
	EndDo
	
	oChart:Activate()
	
Return