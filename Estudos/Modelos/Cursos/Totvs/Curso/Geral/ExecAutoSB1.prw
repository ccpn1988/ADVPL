#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH" 

User Function ExecAutoSB1()

Local aVetor := {} //Cria a matriz aVetor
private lMsErroAuto := .F. //Informa se tem erro no execauto
 
//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
/*RpcSetType( 3 ) // Executa o execauto sem consumir licenca
RPCSETENV("99","01")*/ //RPCSETENV - set a empresa 99 e a filial 01
 
 
//--- Exemplo: Inclusao --- //
aVetor:= { {"B1_COD" ,"9994" ,NIL},; //Campos da matriz - campo - codigo - vazio 
 {"B1_DESC" ,"PRODUTO TESTE" ,NIL},; 
 {"B1_TIPO" ,"PA" ,Nil},; 
 {"B1_GRUPO" ,"XXX" ,Nil},; 
 {"B1_UM" ,"UN" ,Nil},; 
 {"B1_LOCPAD" ,"01" ,Nil},; 
 {"B1_POSIPI" ,"N" ,Nil}}  
  
MSExecAuto({|x,y| Mata010(x,y)},aVetor,3) //Seta o comando execauto
               // Adicionar a rotina padrão  a ser executada o execauto
                             // Adicionar a matriz e a operação (3 inclusão, 4 alteração, 5 exclusão) 

If lMsErroAuto
	MostraErro() //MostraErro() - função que cria a tela de erro
Endif
/*
RpcClearEnv()*/ //Libera a licenca em uso
Return


