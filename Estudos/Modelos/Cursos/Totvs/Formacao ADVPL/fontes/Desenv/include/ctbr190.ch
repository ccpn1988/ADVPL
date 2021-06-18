#ifdef SPANISH
	#define STR0001 "Este programa imprimirá el balance de "
	#define STR0002 "de acuerdo con los parametros solicitados por el usuario. "
	#define STR0003 "Balance de verificacao cuenta / "
	#define STR0004 If( cPaisLoc == "MEX", "|  CODIGO                     |      D E S C R I P C I O N                      |    SALDO ANTERIOR              |    CARGO        |      ABONO        |   MOVIMIENTO DEL PERIODO      |         SALDO ACTUAL              |", "|  CODIGO                     |      D E S C R I P C I O N                      |    SALDO ANTERIOR              |    DEBITO       |      CREDITO      |   MOVIMIENTO DEL PERIODO      |         SALDO ACTUAL              |" )
	#define STR0005 If( cPaisLoc == "MEX", "|  CODIGO               |D  E  S  C  R  I  P  C  I  O  N |   SALDO ANTERIOR  |      CARGO     |       ABONO    |   SALDO ACTUAL    |", "|  CODIGO               |      D E S C R I P C I O N    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ACTUAL    |" )
	#define STR0006 "DE BAL. PARC. ANALIT. "
	#define STR0007 "DE BAL. PAR. SINTETICO "
	#define STR0008 "DE BAL. PARC."
	#define STR0009 " DE "
	#define STR0010 " A  "
	#define STR0011 " EN "
	#define STR0012 " (PRESUP)"
	#define STR0013 " (DE GEST.) "
	#define STR0014 "Creando Archivo Temporal..."
	#define STR0015 "A Rayas"
	#define STR0016 "Administracion"
	#define STR0017 "***** ANULADO POR EL OPERADOR *****"
	#define STR0018 "TOTALES DE PERIODO:"
	#define STR0019 "TOTALES DE GRUPO ("
	#define STR0020 "TOTALES DEL"
	#define STR0021 " Cuenta "
	#define STR0022 "DIV."
	#define STR0023 "dejar el parametro Ignora Sl Ant.Ing/Gas=No "
	#define STR0024 "dejar el parametro Ignora Sl Ant.Ing/Gas=No "
	#define STR0025 "CODIGO"
	#define STR0026 "DESCRIPC."
	#define STR0027 "SALDO ANTERIOR"
	#define STR0028 If( cPaisLoc == "MEX", "CARGO", "DEBITO" )
	#define STR0029 If( cPaisLoc == "MEX", "ABONO", "CREDITO" )
	#define STR0030 "MOVIM. DEL PERIODO"
	#define STR0031 "SALDO ACT."
#else
	#ifdef ENGLISH
		#define STR0001 "This program will print the Trial Balance "
		#define STR0002 "according to the parameters selecteds by the User. "
		#define STR0003 "Account Trial Balance / "
		#define STR0004 "|  CODE                       |      D E S C R I P T I O N                      |    PREVIOUS BALANCE            |    DEBIT        |      CREDIT       |    PERIOD MOVEMENTS           |         CURRENT BALANCE           |"
		#define STR0005 "|  CODE                 |   D  E  S  C  R  I  P  T  .    |   PREV. BALANCE   |      DEBIT     |      CREDIT    |   CURRENT BAL.    |"
		#define STR0006 "DETAILED TRIAL BALANCE /  "
		#define STR0007 "SUMM. TRIAL BALANCE / "
		#define STR0008 "TRIAL BALANCE / "
		#define STR0009 " FROM "
		#define STR0010 " TO "
		#define STR0011 " IN "
		#define STR0012 " (BUDGETED)"
		#define STR0013 " (MANAGERIAL)"
		#define STR0014 "Creating Temporary File..."
		#define STR0015 "Z.Form"
		#define STR0016 "Management"
		#define STR0017 "***** CANCELLED BY THE OPERATOR *****"
		#define STR0018 "PERIOD TOTALS:     "
		#define STR0019 "GROUP TOTALS     ("
		#define STR0020 "TOTALS OF  "
		#define STR0021 " Account "
		#define STR0022 "DIV."
		#define STR0023 "Please, fill out the parameters Groups Incomes/Expenses& Date Prv Blnc Incomes/Expenses or "
		#define STR0024 "leave the parameter Ignor Prv.BlnInc/Exp = No  "
		#define STR0025 "CODE  "
		#define STR0026 "DESCRIPT."
		#define STR0027 "PREVIOUS BLNCE"
		#define STR0028 "DEBIT "
		#define STR0029 "CREDIT "
		#define STR0030 "PERIOD MOVEMENT     "
		#define STR0031 "CURRENT BLN"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Este programa vai imprimir o balancete de ", "Este programa ira imprimir o Balancete de " )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "De acordo com os parâmetros solicitados pelo utilizador. ", "de acordo com os parametros solicitados pelo Usuario. " )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Balancete de verificação ", "Balancete de Verificacao " )
		#define STR0004 If( cPaisLoc $ "ANG|EQU|HAI", "|  CÓDIGO                     |      D E S C R I Ç Ã O                          |    SALDO ANTERIOR              |    DÉBITO       |      CRÉDITO      |    MOVIMENTO DO PERÍODO       |         SALDO ATUAL               |", If( cPaisLoc $ "MEX|PTG", "|  código                     |      d e s c r i ç ã o                          |    saldo anterior              |    débito       |      crédito      |    movimento do período       |         saldo actual               |", "|  CODIGO                     |      D E S C R I C A O                          |    SALDO ANTERIOR              |    DEBITO       |      CREDITO      |    MOVIMENTO DO PERIODO       |         SALDO ATUAL               |" ) )
		#define STR0005 If( cPaisLoc $ "ANG|EQU|HAI", "|  CÓDIGO               |   D  E  S  C  R  I  Ç  Ã  O    |   SALDO ANTERIOR  |      DÉBITO    |      CRÉDITO   |   SALDO ATUAL     |", If( cPaisLoc $ "MEX|PTG", "|  código               |   d  e  s  c  r  i  ç  ã  o    |   saldo anterior  |      débito    |      crédito   |   saldo actual     |", "|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |" ) )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Balancete analitico de ", "BALANCETE ANALITICO DE " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Balancete sintetico de ", "BALANCETE SINTETICO DE " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Balancete de ", "BALANCETE DE " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", " de ", " DE " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", " até ", " ATE " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", " em ", " EM " )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", " (orcado)", " (ORCADO)" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", " (de gestão)", " (GERENCIAL)" )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "A Criar Ficheiro Temporário...", "Criando Arquivo Temporario..." )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "***** cancelado pelo operador *****", "***** CANCELADO PELO OPERADOR *****" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Totais do período: ", "TOTAIS DO PERIODO: " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Totais do  grupo (", "TOTAIS DO  GRUPO (" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Totais do  ", "TOTAIS DO  " )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", " conta ", " Conta " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Div.", "DIV." )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Favor preencher os parâmetros grupos receitas/despesas e data sld ant. receitas/despesas ou ", "Favor preencher os parametros Grupos Receitas/Despesas e Data Sld Ant. Receitas/Despesas ou " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Deixar o parâmetro ignora sl ant.rec/des = não ", "deixar o parametro Ignora Sl Ant.Rec/Des = Nao " )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Código", "CODIGO" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Descrição", "DESCRICAO" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Saldo Anterior", "SALDO ANTERIOR" )
		#define STR0028 If( cPaisLoc $ "ANG|EQU|HAI", "DÉBITO", If( cPaisLoc $ "MEX|PTG", "Débito", "DEBITO" ) )
		#define STR0029 If( cPaisLoc $ "ANG|EQU|HAI", "CRÉDITO", If( cPaisLoc $ "MEX|PTG", "Crédito", "CREDITO" ) )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Movimento Do Período", "MOVIMENTO DO PERIODO" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Saldo Actual", "SALDO ATUAL" )
	#endif
#endif
