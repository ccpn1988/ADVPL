#Include 'Protheus.ch'

User Function xEsc()
	Local cLocal     := "S� pode ser visualizada na funcao que foi criada"
	Static cStatic   := "Pode ser visualizada em qualquer parte do PRW, mas nao alteremos seu valor"
	Private cPrivate := "Pode ser visualizada em outros PRW"
	Public cPublic   := "Pode ser visualizada em qualquer parte"

//VARIAVEL SEM DECLARA��O := PRIVATE

	xEscopo()
	msginfo (cLocal  , "Local"  )
Return
//-----------------------------------------------------------------------------------------------
Static Function xEscopo() // N�o � aconselhavel ter duas fun�oes com o mesmo nome

msginfo(cLocal , "Local")
msginfo(cStatic, "Static")
msginfo(cPrivate, "Private")
msginfo(cPublic, "Public")

Return

//-----------------------------------------------------------------------------------------------

FUNCTION() //INTELIGENCIA PROTHEUS 10 CARACTERES (MATA001CLI()) RESTRITA
USER FUNCTION() //FUN��ES DEFINIDAS PELO USU�RIO U_FUNCTION()
STATIC FUNCTION() //UTILIZADA APENAS NO MESMO C�DIGO FONTE
MAIN FUNCTION() //TELA DE PAR�METROS PROTHEUS, RESTRITA "SIGAADV"

