#INCLUDE 'Protheus.ch'

//-----------------------------------//
//          TIPOS DE DADOS           //
//-----------------------------------//

/*
TIPO NUMERICO := 3
TIPO LOGICO := .T. / .F.
TIPO CARACTERE := 'A'/ "b"
TIPO DATA := DATE()
TIPO ARRAY := {'JOAO', 'MARIA', 'JOSE'}
TIPO BLOCO := {||VALOR := 1, MsgAlert('Caio Neves', "Alert")}
*/

USER FUNCTION VARIAV()

    Local aArea := GetArea()
    Local nNUM := 66
    Local lLOGIC := .T.
    Local dDATA := DATE()
    Local cCARAC := 'CAIO NEVES'
    Local aARRAY := {'JOAO', 'MARIA', 'JOSE'}
    Local bBLOCO := {|| nVALOR := 2, MsgAlert("O NUMERO É: " + CVALTOCHAR(nVALOR))}


    ALERT(nNUM)
    ALERT(lLOGIC)
    ALERT(dDATA)
    ALERT(cCARAC)
    ALERT(aARRAY[2])
    Eval(bBLOCO)

    RestArea(aArea)
    
RETURN 
