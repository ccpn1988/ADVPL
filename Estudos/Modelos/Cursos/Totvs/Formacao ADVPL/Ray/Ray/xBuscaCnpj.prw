#Include 'Protheus.ch'

User Function xBuscaCnpj()
	
	dbSelectArea("SA1")
	dbSetOrder(3)
	
	if MsSeek(xFilial("SA1") + '03338610002646')
		msgInfo("encontrei:" + CRLF + A1_COD + " -> " + A1_NREDUZ)
	Elseif msgInfo("N�o foi encontrado")
	endif
	
	dbCloseArea() //Utilizar para tabelas tempor�rias, n�o utilizar em ponto de entrada e tabelas padr�o.
Return

