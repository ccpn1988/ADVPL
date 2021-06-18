User Function VLDLIQ()

Local lRet := .T.

IF ISINCALLSTACK("FINA565")
    GdFieldPut("E2_PREFIXO",SE2->E2_PREFIXO)
    GdFieldPut("E2_AGECHQ","00000")
    GdFieldPut("E2_CTACHQ","00000")
    GdFieldPut("E2_NUM",cValTOchar(oGet:oBrowse:nat)+right(SE2->E2_NUM,8))
EndIF

Return lRet