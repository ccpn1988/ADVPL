#Include 'Protheus.ch'

User Function xMdl02()
Local oBrowser := FwMBrowse():NEW() //FwBrowse - novo browser
Private INCLUI := .T. //Na validação do campo SZ1_CODIGO na tabela SZ1, existe a função INCLUI, por isso ela precisa ser declarada no fonte
Private cCadastro := "Cadastro Modelo 2"

oBrowser:SetAlias("SZ1")
oBrowser:SetDescription("Exemplo FwMBrowse")
oBrowser:Activate()

Return
//--------------------------------------------------------------------

Static Function MenuDef()
Local aRotina := {}
	
	 aRotina := {;
				{ "Pesquisar"  , "AxPesqui", 0, 1},;
				{ "Visualizar" , "U_xMod02", 0, 2},;
				{ "Incluir"    , "U_xMod02", 0, 3},;
				{ "Alterar"    , "U_xMod02", 0, 4},;
				{ "Exlcuir"    , "U_xMod02", 0, 5};
				}
Return aRotina
//--------------------------------------------------------------------

User Function xMod02(cAlias, nReg, nOpc)
Local aC        := {}                                        //Array com os campos do cabeçalho
Local aGd       := {80,05,100,100}                           //Array com as posições para edição do campo
Local bF4       := {||MsgInfo("Numero do pedido" + cCodigo)} //Função para ativar o bloco de código no botão F4
Local nMax      := 99                                        //Numero maximo de linhas que vai aparecer no browser
Local aR        := {}
Local aGetsD     := {}
Private cCodigo := CriaVar("Z1_CODIGO",.T.) //Puxa o tamanho do campo que esta cadastrado na tabela SZ1
Private dData   := CriaVar("Z1_DATA"  ,.T.) //Puxa o tamanho do campo que esta cadastrado na tabela SZ1
Private cNome   := CriaVar("Z1_NOME"  ,.T.) //Puxa o tamanho do campo que esta cadastrado na tabela SZ1
Private aHeader := {} //Inteligencia da linha
Private aCols   := {} //O que o usuário digita

aAdd( aC,{"cCodigo",{15,10} , "Codigo"      , "@R 999999", , /*F3*/, .F. } )
aAdd( aC,{"dData  ",{15,80} , "Data"        ,            , , /*F3*/, .F. } )
aAdd( aC,{"cNome"  ,{15,150}, "Solicitante" ,            , , /*F3*/, .F. } )

/*
aC[n,1] = Nome da Variável Ex.:"cCliente"
aC[n,2] = Array com coordenadas do Get [x,y], em Windows estão em PIXEL
aC[n,3] = Titulo do Campo
aC[n,4] = Picture
aC[n,5] = Validação
aC[n,6] = F3
aC[n,7] = Se campo é editavel .T. se não .F.*/

fCriaItns()

lRet := Modelo2 (cCadastro, aC, aR, aGd, nOpc, /*cLinhaOk*/, /*cTudoOk*/, /*aGetsD*/, bF4, /*cIniCpos*/, nMax, , , .T.)

If lRet
	fGravaDados()
Else
	RollbackSX8()
EndIf

Return (NIL)
//------------------------------------------------------------------------------------------------------------------

Static Function fCriaItns() 
DbSelectArea("SX3")         //Abre a tabela SX3
DbSetOrder(1)               //Seleciona o indice 1 da tabela SX3
DbSeek("SZ1")               //Trava na tabela SZ1

While !Eof() .AND. SX3->X3_ARQUIVO =="SZ1" //
	If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. ! AllTrim(SX3->X3_CAMPO) $ "Z1_CODIGO|Z1_NOME|Z1_DATA"
		aAdd(aHeader,{Trim(X3Titulo()),;
					  SX3->X3_CAMPO   ,;
		              SX3->X3_PICTURE ,;
		              SX3->X3_TAMANHO ,;
		              SX3->X3_DECIMAL ,;
		              SX3->X3_VALID   ,;
		              SX3->X3_USADO   ,;
		              SX3->X3_TIPO    ,;
		              SX3->X3_ARQUIVO ,;
		              SX3->X3_CONTEXT})
	EndIf
	DbSkip()
EndDo

aAdd(aCols,Array(Len(aHeader) + 1))

For nCol:= 1 To Len (aHeader)
	
	aCols[1,nCol] := CriaVar(aHeader[nCol,2])

Next

aCols[1,Len(aHeader) + 1] := .F.

Return (NIL)
//-------------------------------------------------------------------------------------------------------------------------

Static Function fGravaDados()

//Exercicio fazer a gravacao dos dados 

For nLinha := 1 To Len(aCols) //Na linha 1

	If aCols[nLinha,Len(aHeader) + 1] //Verifica se a linha esta deletada e não faz nada
		Loop
	EndIf
	
	RecLock("SZ1",.T.) //Cria uma linha em branco no banco

		For nColuna := 1 To Len(aHeader)                                  //Percorre a linha 1
			//SZ1->&( aHeader[nColuna,2] := aCols[nLinha,nColuna])        //Grava os campos na tabela
			FieldPut (FieldPos(aHeader[nColuna,2]),aCols[nLinha,nColuna]) //Seta o aHeader na posição 2 (que são os campos)
			        //FieldPos - retorna a posição                       
			
		Next nColuna
	
		SZ1->Z1_FILIAL  := xFilial("SZ1")
		SZ1->Z1_CODIGO  := cCodigo
		SZ1->Z1_NOME    := cNome
		SZ1->Z1_DATA    := dData
	
		ConfirmSX8()
		
	Msunlock()	

Next nLinha

Return (NIL)



















