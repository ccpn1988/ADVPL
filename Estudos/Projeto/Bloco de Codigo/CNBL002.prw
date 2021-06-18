#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

User Function CNBL002()
Local aArea := GetArea()
Local bBloco := {|| Alert("Olá Mundo")}
    
    Eval(bBloco)

    RCTIBL()

RestArea(aArea)

Return

Static Function RCTIBL()
Local aArea := GetArea()
//BLOCO DE CODIGO PASSAGEM POR PARÂMETRO
Local bBloco := {|cMsg| Alert(cMsg)}
    Eval(bBloco,"Bloco via Parâmetro")

RestArea(aArea)

Return
