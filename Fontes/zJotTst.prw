/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2020/12/22/como-integrar-protheus-com-jotforms/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Totvs.ch"
 
/*/{Protheus.doc} zJotTst
Exemplo de GET em uma integra��o com JotForms
@author Atilio
@since 01/11/2020
@version 1.0
@type function
@obs No exemplo abaixo � usado o /user/forms com Get, mas � possível usar Set e outros m�todos conforme documenta��o disponível - https://api.jotform.com/docs/#user-forms
/*/
 
User Function zJotTst()
    Local aArea := GetArea()
    Local cURL := "api.jotform.com"
    Local aHeaderStr   := {}
    Local oRestClient  := FwRest():New(cUrl)
    Local cAPIKey := "Seu Token de Acesso"
    Local oJSON
    Local cDtIni := "2020-11-01"
    Local cResult
 
    //Se o token tiver preenchido
    If !Empty(cAPIKey)
        //No cabe�alho define o Token usado
        aAdd(aHeaderStr, 'APIKEY: ' + cAPIKey)
 
        //Iremos definir a integra��o como /user/forms e iremos filtrar cria�ões a partir da data 01/11/2020
        oRestClient:SetPath('/user/forms?filter={%22created_at:gt%22:%22' + cDtIni + '%2000:00:00%22}%20')
         
        //Chama o m�todo Get do FWRest, armazena o resultado em uma vari�vel
        If oRestClient:Get( aHeaderStr )
            cResult := oRestClient:GetResult()
 
            //Se o JSON for deserializado, significa que deu certo, e aí basta pegar os atributos dentro do oJSON e fazer as tratativas
            If (FWJsonDeserialize(cResult, @oJSON))
                Alert('Json foi deserializado')
            EndIf
             
        //Sen�o, pega os erros, e se quiser exibir, basta adicionar um Alert
        Else
            cLastError := oRestClient:GetLastError()
            cErrorDetail := oRestClient:GetResult()
        EndIf
    EndIf
 
    RestArea(aArea)
Return