#Include 'Protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCN121AFN  บAutor  ณCleuto Lima         บ Data ณ  21/05/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega informa็๕es complementares ao encerrar a medi็ใo    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CN121AFN()

    Local aResult   := Nil//Retornar nulo caso nao modifique o array
    Local aCab      := PARAMIXB[1]
    Local cTipo     := PARAMIXB[2] // 1-Compra, 2-Venda
    Local cChaveCNE := ""
    Local cChaveCNZ := ""
    Local nPosPlan  := aScan( aCab, {|x| x[1] == IIF(cTipo == "1", "E2_MDPLANI", "E1_MDPLANI")}) //C๓digo da planilha (CNTA121 nใo preenche CND_NUMERO)
  
    IF cTipo <> "1"
        Return aResult
    ENDIF

    aResult := aClone(aCab)
    CN9->(DbSetOrder(1))
    CNE->(DbSetOrder(1))//CNE_FILIAL+CNE_CONTRA+CNE_REVISA+CNE_NUMERO+CNE_NUMMED+CNE_ITEM
    CNZ->(DbSetOrder(2))//CNZ_FILIAL+CNZ_CONTRA+CNZ_REVISA+CNZ_NUMMED+CNZ_ITCONT+CNZ_ITEM    
    
    CN9->(DbSeek( CND->(CND_FILIAL+CND_CONTRA+CND_REVISA) ))
    aAdd(aResult, {'E2_HIST', CN9->CN9_XHISTI, Nil})

    cChaveCNE := CND->(CND_FILIAL+CND_CONTRA+CND_REVISA+aCab[nPosPlan][2]+CND_NUMMED)
    If CNE->(DbSeek(cChaveCNE))
        While CNE->(!EOF() .And. CNE_FILIAL+CNE_CONTRA+CNE_REVISA+CNE_NUMERO+CNE_NUMMED == cChaveCNE)

            /* Carga de centro de custo */
            If !Empty(CNE->CNE_CC)                                  
                aAdd(aResult, {'E2_CCD', CNE->CNE_CC, Nil})
            Else
                cChaveCNZ := CNE->(CNE_FILIAL+CNE_CONTRA+CNE_REVISA+CNE_NUMMED+CNE_ITEM)
                If CNZ->(DbSeek(cChaveCNZ))
                    aAdd(aResult, {'E2_CCD', CNZ->CNZ_CC, Nil})
                EndIf
            EndIf

            /* Carga de classe de valor */
            If !Empty(CNE->CNE_CLVL)
                aAdd(aResult, {'E2_CLVLDB', CNE->CNE_CLVL, Nil})
            EndIf

            /* Carga de CONTA */
            If !Empty(CNE->CNE_CONTA)
                aAdd(aResult, {'E2_CONTAD', CNE->CNE_CONTA, Nil})
            EndIf

            CNE->(DbSkip())
        EndDo
    EndIf
      
Return aResult
