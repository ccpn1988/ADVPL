/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2016/09/06/criando-graficos-advpl-fwchartbar/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"  

/*/{Protheus.doc} zTstChart
Fun��o de teste da classe FWChartBar
@type function
@author Atilio
@since 01/12/2015
@version 1.0
	@example
	u_zTstChart()
	@see http://tdn.totvs.com/display/public/mp/FWChartBar
/*/

User Function zTstChart()
	Local oChart
	Local oDlg
	Local aRand := {}
	
	//Cria a Janela
	DEFINE MSDIALOG oDlg PIXEL FROM 0,0 TO 400,600
		//Instância a classe
		oChart := FWChartBar():New()
		
		//Inicializa pertencendo a janela
		oChart:Init(oDlg, .T., .T. )
		
		//Seta o título do gr�fico
		oChart:SetTitle("Título", CONTROL_ALIGN_CENTER)
		
		//Adiciona as s�ries, com as descri�ões e valores
		oChart:addSerie("Ano 2011", 20044453.50)
		oChart:addSerie("Ano 2012", 21044453.35)
		oChart:addSerie("Ano 2013", 22044453.15)
		oChart:addSerie("Ano 2014", 23044453.10)
		oChart:addSerie("Ano 2015", 25544453.01)
		
		//Define que a legenda ser� mostrada na esquerda
		oChart:setLegend( CONTROL_ALIGN_LEFT )
		
		//Seta a m�scara mostrada na r�gua
		oChart:cPicture := "@E 999,999,999,999,999.99"
		
		//Define as cores que ser�o utilizadas no gr�fico
		aAdd(aRand, {"084,120,164", "007,013,017"})
		aAdd(aRand, {"171,225,108", "017,019,010"})
		aAdd(aRand, {"207,136,077", "020,020,006"})
		aAdd(aRand, {"166,085,082", "017,007,007"})
		aAdd(aRand, {"130,130,130", "008,008,008"})
		
		//Seta as cores utilizadas
		oChart:oFWChartColor:aRandom := aRand
		oChart:oFWChartColor:SetColor("Random")
		
		//Constr�i o gr�fico
		oChart:Build()
	ACTIVATE MSDIALOG oDlg CENTERED
Return