#Include 'Protheus.ch'

User Function MT410BRW()
	AADD(aRotina,{"Teste","AxTeste",0,9})
Return

Static Function AxTeste()
	
	Local oDlg
	Local cTitulo	:=	'Teste'
	Local oSay
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 080,300 PIXEL
			oSay():New( 020, 020, cTitulo, oDlg,,,,,,,,,,,,,,,,.t.,, [ nTxtAlgVer ] )
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return

