#include 'protheus.ch'
#include 'parmtype.ch'

user function zEmbedd()
	Local aArea := GetArea()
	Local cMsg := ""
	
	BeginSQL Alias "QRY_SB1"
	//COLUMN CAMPO AS DATE //DEVE USAR PARA TRANSFORMAR CAMPO EM DATA
		
		SELECT 
			B1_COD,
			B1_DESC
		FROM
			%table:SB1% SB1
		WHERE
			SB1.%notDel%
			AND B1_MSBLQL != '1'
		ENDSQL
		
		//PERCORRENDO REGISTROS
		WHILE ! QRY_SB1->( EOF())
			cMsg += ("O CODIGO É: "+ ALLTRIM(QRY_SB1->B1_COD) + "Descrição é: "+  ALLTRIM(QRY_SB1->B1_DESC))
				MSGINFO(cMsg)
			QRY_SB1->(dbSkip())
		ENDDO
	QRY_SB1->(dbCloseArea())
	RestArea(aArea)
return