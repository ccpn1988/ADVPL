#include 'protheus.ch'
#include 'parmtype.ch'

//http://tdn.totvs.com/pages/releaseview.action?pageId=6814979

User Function TReport2()
	Local oReport := Nil
	Local cPerg := Padr("TRPT002",10)
	
	//Executa a pergunta
	Pergunte(cPerg,.F.,"RCTI TESTE")
	
Return

Static Function RPTPrint(oReport)
	
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery := ""
	Local cNumCod := ""
	
	
	

Return 