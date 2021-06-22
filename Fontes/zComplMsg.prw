/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2019/11/21/como-adicionar-mensagem-complementar-na-danfe-atraves-de-uma-user-function/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

#Include "Protheus.ch"
#Include "TopConn.ch" 

#DEFINE MAXMENLIN 080 // M�ximo de caracteres por linha de dados adicionais - deixar igual o do fonte danfeii.prw

//1 - Criar uma F�rmula (SM4), com u_zComplMsg()
//2 - Colocar o c�digo dessa f�rmula no campo C5_MENPAD

User Function zComplMsg()
	Local aArea	   := GetArea()
	Local aAreaSD2 := SD2->(GetArea())
	Local aAreaSF2 := SF2->(GetArea())
	Local aAreaSC5 := SC5->(GetArea())
	Local aAreaSC6 := SC6->(GetArea())
	Local aAreaSA1 := SA1->(GetArea())
	Local aAreaSB1 := SB1->(GetArea())
	Local aAreaSA3 := SA3->(GetArea())
	Local aAreaSF4 := SF4->(GetArea())
	Local cMens    := ""          
	Local cAux     := ""
	
	cAux := "Beluguinha, Belug�o... Acesse Terminal de Informa��o (https://terminaldeinformacao.com)"
	cMens += fLinhaDanfe(cAux)
	
	RestArea(aAreaSD2)
	RestArea(aAreaSF2)
	RestArea(aAreaSC5)
	RestArea(aAreaSC6) 
	RestArea(aAreaSA1)
	RestArea(aAreaSB1)	
	RestArea(aAreaSA3)	   
	RestArea(aAreaSF4)	
	RestArea(aArea)
Return cMens

Static Function fLinhaDanfe(cLinhaTexto)
	Local cLinhaTrans:=""

	//Se houver texto
	If !Empty(cLinhaTexto)
		//Enquanto o tamnho for maior que o m�ximo da linha, vai quebrando 
		While Len(cLinhaTexto) > MAXMENLIN
			cLinhaTrans += Substr(cLinhaTexto, 1, MAXMENLIN)
			cLinhaTexto := Substr(cLinhaTexto, MAXMENLIN + 1, Len(cLinhaTexto) - MAXMENLIN)
		EndDo
		
		//Se restou texto, incrementa
		If cLinhaText != ""
			cLinhaTrans += PadR(cLinhaTexto, MAXMENLIN)
		EndIf
	EndIf
	
Return cLinhaTrans