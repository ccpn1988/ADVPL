#Include 'Protheus.ch'

User Function xBloco()
Local bVar := {|Z,Y| MsgInfo(Z,Y)} // Bloco de codigo - Primeira variavel é o texto do código e a Segunda
                                   // variavel é o titulo da janela

eVal(bVar, "Exemplo de bloco","Titulo da janela") // Comando eVal ativa o bloco de código


Return

//---------------------------------------------------------------------------------------------------------------------------------------------------------

#Include 'Protheus.ch'

User Function Bloco()

Local bBloco := {|| Alert ("Olá Mundo")}

eVal (bBloco) // ATIVA O BLOCO DE CODIGO

return


//PASSAGEM POR PARAMETROS---------------------------------------------------------------------------------------------------------------------------------------------------------

#Include 'Protheus.ch'


User Function Bloco1()

Local bBloco := {|cMsg| Alert ("cMsg")} 

eVal (bBloco, "Olá Mundo!")

return

