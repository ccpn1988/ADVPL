//bibliotecas
#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} USER FUNCTION xLOGIC01
    COMO FUNCIONA A LINGUAGEM ADVPL
    @type  Function
    @author CAIO NEVES
    @since 06/04/2021
)
    /*/
USER Function xLOGIC01(param_name)
    LOCAL NVARIAVEL := 0

    NVARIAVEL := 5 + 2

    ALERT(NVARIAVEL)

    NVARIAVEL := 3 + 5

    ALERT(NVARIAVEL)
    
Return 
