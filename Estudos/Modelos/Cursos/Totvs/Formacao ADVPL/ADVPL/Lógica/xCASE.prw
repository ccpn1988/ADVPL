#Include 'Protheus.ch'

User Function xCASE()
local dMES := MONTH(Date())//RETORNA MES DAY(DIA)YEAR(ANO)
local nTres := 3

Do case
	Case dMES <= nTres
		MSGINFO("1° TRIMESTRE")
	Case dMES <=6
		MSGINFO("2° TRIMESTRE")
	Case dMES <=9
		MSGINFO("3° TRIMESTRE")
	OtherWise 
		MSGINFO("4° TRIMESTRE")
EndCase

Return(NIL)

