#Include 'Protheus.ch'

User Function OperRelacional()
Local cNome  := "CLAUDIA "
Local cNome2 := "CLAUDIA"

if cNome == cNome2
	MsgInfo("Verdadeiro")  
else
    MsgInfo("False") 
endif

Return

//============================================================

User Function OperString

Local cNome1 := "Maria     "
Local cNome2 := "Maria"

if "M" $ cNome1
   msginfo("Verdadeiro")
endif

msginfo(cNome1 - cNome2)
 
Return

//===========================================================
User Function ValCampo()
Local lRet:=.F.
Local cPar:=Getmv("XX_NOME") // GetMV() >> Retorn a o conteúdo do parâmetro

//msginfo(cUserName)// c|UserName >> Retorna o nome do usuario logado

//lRet:=MsgYesNo("Deseja ativar o campo","x3_when") 

if upper(alltrim(cUsername)) $ upper(alltrim(cPar))

   lRet:=.T.

endif

Return lRet  