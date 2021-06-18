#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUPDTABP   บAutor  ณDanilo Azevedo      บ Data ณ  30/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualizacao de tabela de preco nos parametros e cadastros   บฑฑ
ฑฑบ          ณde clientes.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN - Atualizacao de tabela de preco                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function UPDTABP()

cTabOld := "190"
cTabNew := "200"

Prepare Environment Empresa "00" Filial "1022"

If alltrim(GETMV("GEN_FAT006")) = cTabOld
	PutMv("GEN_FAT006",cTabNew)
Endif

//If alltrim(GETMV("GEN_FAT015")) = cTabOld
//	PutMv("GEN_FAT015",cTabNew)
//Endif

If alltrim(GETMV("GEN_FAT036")) = cTabOld
	PutMv("GEN_FAT036",cTabNew)
Endif

If alltrim(GETMV("GEN_FAT064")) = cTabOld
	PutMv("GEN_FAT064",cTabNew)
Endif

//If alltrim(GETMV("GEN_FAT069")) = cTabOld
//	PutMv("GEN_FAT069",cTabNew)
//Endif                          

If alltrim(GETMV("GEN_FAT107")) = cTabOld
	PutMv("GEN_FAT107",cTabNew)
Endif                          

If alltrim(GETMV("GEN_COM006")) = cTabOld
	PutMv("GEN_COM006",cTabNew)
Endif                          

Begin transaction
	tcsqlexec("CREATE TABLE SA1_"+DTOS(dDatabase)+" AS SELECT * FROM "+RetSqlName("SA1")) //FAZ BACKUP DA TABELA DE CLIENTES
	tcsqlexec("UPDATE "+RetSqlName("SA1")+" SET A1_TABELA = '"+cTabNew+"' WHERE A1_TABELA = '"+cTabOld+"' AND D_E_L_E_T_ = ' '") //ATUALIZA CLIENTES
End Transaction

Conout("Fim 200")

Reset Environment

Return()
