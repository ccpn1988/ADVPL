#INCLUDE "Totvs.ch"

/*/{Protheus.doc} User Function nomeFunction
    TESTE VSCODE AUTO-COMPLETE
    @type  Function
    @author user
    @since 14/05/2020
    @version version
    /*/
User Function VSCODE01()
    Local aArea:= GetArea()
    Local cQuery := ""

        cQuery += " SELECT " + CRLF
        cQuery += "     A2_NOME,"+ CRLF
        cQuery += "     A2_COD,"+ CRLF
        cQuery += "     A2_LOJA"+ CRLF
        cQuery += " FROM "+ CRLF
        cQuery += "     RESTSQLNAME SA2990 'SA2'"+ CRLF
        cQuery += " WHERE "+ CRLF
        cQuery += "     FWXFILIAL(SA2) = ' '"+ CRLF
        cQuery += " AND " + CRLF
        cQuery += "   A2_MSBLQL != '1'"+ CRLF
        cQuery += " ORDER BY "+ CRLF
        cQuery += "     A2_NOME "+ CRLF
        
    RestArea(aArea)
Return 