/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/09/05/funcao-abre-outlook-funcao-advpl/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zOutlook
Fun��o que abre o outlook para escrever um novo e-mail
@type function
@author Atilio
@since 14/04/2017
@version 1.0
	@param cEmail, character, Endere�o de e-Mail
	@example
	u_zOutlook("suporte@terminaldeinformacao.com")
	u_zOutlook(SA3->A3_EMAIL)
	@obs Caso queira ver a op��o de adicionar assunto ou corpo do e-Mail, veja
	https://support.microsoft.com/pt-br/help/287573/how-to-use-command-line-switches-to-create-a-pre-addressed-e-mail-message-in-outlook
/*/

User Function zOutlook(cEmail)
	Local cExecute := "/c ipm.note /m "+Alltrim(cEmail)
	Default cEmail := ""
	
	//Se tiver email, abre o outlook
	If !Empty(Alltrim(cEmail))
		ShellExecute("OPEN", "outlook.exe", cExecute, "", 1)
	EndIf
Return