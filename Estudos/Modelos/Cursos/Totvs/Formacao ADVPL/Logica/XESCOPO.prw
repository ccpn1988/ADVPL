#Include 'Protheus.ch'

User Function xEsc()
	Local cLocal     := "Só pode ser visualizada na funcao que foi criada"
	Static cStatic   := "Pode ser visualizada em qualquer parte do PRW, mas nao alteremos seu valor"
	Private cPrivate := "Pode ser visualizada em outros PRW"
	Public cPublic   := "Pode ser visualizada em qualquer parte"

//VARIAVEL SEM DECLARAÇÃO := PRIVATE

	xEscopo()
	msginfo (cLocal  , "Local"  )
Return
//-----------------------------------------------------------------------------------------------
Static Function xEscopo() // Não é aconselhavel ter duas funçoes com o mesmo nome

msginfo(cLocal , "Local")
msginfo(cStatic, "Static")
msginfo(cPrivate, "Private")
msginfo(cPublic, "Public")

Return

//-----------------------------------------------------------------------------------------------

FUNCTION() //INTELIGENCIA PROTHEUS 10 CARACTERES (MATA001CLI()) RESTRITA
USER FUNCTION() //FUNÇÕES DEFINIDAS PELO USUÁRIO U_FUNCTION()
STATIC FUNCTION() //UTILIZADA APENAS NO MESMO CÓDIGO FONTE
MAIN FUNCTION() //TELA DE PARÂMETROS PROTHEUS, RESTRITA "SIGAADV"

