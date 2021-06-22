/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/01/23/vd-advpl-024/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} zExecView
Fun��o de teste que demonstra o funcionamento da FWExecView
@type function
@author Atilio
@since 24/10/2016
@version 1.0
	@example
	u_zExecView()
@obs Se a rotina tiver grid, provavelmente ser� necess�rio declarar a vari�vel "n" como private
/*/

User Function zExecView()
	Local aArea := GetArea()
	Local cFunBkp     := FunName()
	
	DbSelectArea('ZZ1')
	ZZ1->(DbSetOrder(1)) //Filial + C�digo
	
	//Se conseguir posicionar
	If ZZ1->(DbSeek(FWxFilial('ZZ1') + "000002"))
		SetFunName("zModel1")
		FWExecView('Visualizacao Teste', 'zModel1', MODEL_OPERATION_VIEW)
		SetFunName(cFunBkp)
	EndIf
	
	RestArea(aArea)
Return