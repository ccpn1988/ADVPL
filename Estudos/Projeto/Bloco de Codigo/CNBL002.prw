#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

User Function CNBL002()
Local aArea := GetArea()
Local bBloco := {|| Alert("Ol� Mundo")}
    
    Eval(bBloco)

    RCTIBL()

RestArea(aArea)

Return

Static Function RCTIBL()
Local aArea := GetArea()
//BLOCO DE CODIGO PASSAGEM POR PAR�METRO
Local bBloco := {|cMsg| Alert(cMsg)}
    Eval(bBloco,"Bloco via Par�metro")

RestArea(aArea)

Return
