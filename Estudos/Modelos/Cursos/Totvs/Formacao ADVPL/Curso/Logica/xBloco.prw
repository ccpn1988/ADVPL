#Include 'Protheus.ch'

User Function xBloco()
Local bVar := {|Z,Y| MsgInfo(Z,Y)} // Bloco de codigo - Primeira variavel � o texto do c�digo e a Segunda
                                   // variavel � o titulo da janela

eVal(bVar, "Exemplo de bloco","Titulo da janela") // Comando eVal ativa o bloco de c�digo


Return

//---------------------------------------------------------------------------------------------------------------------------------------------------------

#Include 'Protheus.ch'

User Function Bloco()

Local bBloco := {|| Alert ("Ol� Mundo")}

eVal (bBloco) // ATIVA O BLOCO DE CODIGO

return


//PASSAGEM POR PARAMETROS---------------------------------------------------------------------------------------------------------------------------------------------------------

#Include 'Protheus.ch'


User Function Bloco1()

Local bBloco := {|cMsg| Alert ("cMsg")} 

eVal (bBloco, "Ol� Mundo!")

return

