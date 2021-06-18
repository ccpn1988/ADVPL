#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"


User Function CNBL003()
    bBloco := {|| Alert("TESTE")}

    EVal(bBloco)

    fFormaAnt()
Return

Static Function fFormaAnt()
    bAoQuadrado := {|nValor| nQuadrado := nValor * nValor, Alert("Valor ao Quadrado " + cValToChar(nQuadrado)) }

    EVal(bAoQuadrado,5)
    EVal(bAoQuadrado,7)
Return
