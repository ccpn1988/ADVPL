#ifdef SPANISH
	#define STR0001 "Detalle de la Situacion del Stock"
	#define STR0002 "Este informe emite la situacion de los saldos y reservas de cada producto"
	#define STR0003 "en stock. Tambien  muestra el saldo  disponible, o sea el saldo obtenido "
	#define STR0004 "de las reservas."
	#define STR0005 " Por Codigo         "
	#define STR0006 " Por Tipo           "
	#define STR0007 " Por Descripcion    "
	#define STR0008 " Por Grupo          "
	#define STR0009 " Por Deposito       "
	#define STR0010 "A Rayas"
	#define STR0011 "Administracion"
	#define STR0012 "Seleccionando registros..."
	#define STR0013 "Organizando archivo..."
	#define STR0014 "CODIGO          TP GRUP DESCRIPCION           UM FL DEP.  SALDO       RESERVA PARA     STOCK         ____________VALOR ___________"
	#define STR0015 "                                                          EN STOCK    REQ/PV/RESERVA   DISPONIBLE       EN STOCK        RESERVADO "
	#define STR0016 "Total del "
	#define STR0017 "Tipo"
	#define STR0018 "Grupo"
	#define STR0019 "Total unidad medida  : "
	#define STR0020 "Total general: "
	#define STR0021 "ANULADO POR EL OPERADOR."
	#define STR0022 "Registro(s) procesado(s)"
	#define STR0023 ": Preparacion..."
	#define STR0024 "Costo Unificado"
	#define STR0025 "Con el parametro MV_CUSFIL activado se debe observar el completamiento de las siguintes preguntas:"
	#define STR0026 'Agrupa Por Deposito/Sucursal/Empresa? -> Pueden utilizarse solo las opciones "Sucursal" o "Empresa"'
	#define STR0027 'Deposito De? -> Solamente "**"'
	#define STR0028 'Deposito A? -> Solamente "**"'
	#define STR0029 'Orden de Impresion -> Todas, excepto "DEPOSITO"'
	#define STR0030 "Los parametros no estan debidamente configurados. ¿Imprime informe de esa Forma ?"
	#define STR0031 "Imprime"
	#define STR0032 "Cancela"
	#define STR0033 "Subtotal por Almacen"
	#define STR0034 "    DESCRIPCION"
	#define STR0035 "    DE ALMACEN"
	#define STR0036 "CODIGO"
	#define STR0037 "TP"
	#define STR0038 "GRUP"
	#define STR0039 "DESCRIPCION"
	#define STR0040 "UM"
	#define STR0041 "SC"
	#define STR0042 "ALMC"
	#define STR0043 "SALDO"
	#define STR0044 "EN STOCK"
	#define STR0045 "RESERVA PARA"
	#define STR0046 "REQ/PV/RESERVA"
	#define STR0047 "STOCK"
	#define STR0048 "DISPONIBLE"
	#define STR0049 "VALOR"
	#define STR0050 "RESERVADO"
	#define STR0051 "DESCRIPCION"
	#define STR0052 "DEL ALMACEN"
	#define STR0053 "Saldos en Stock"
#else
	#ifdef ENGLISH
		#define STR0001 "Inventory Status Report"
		#define STR0002 "This report prints Balance and Reserve Status of each product in"
		#define STR0003 "Stock, and also the available Balance, that is, the differences "
		#define STR0004 "subtracted allocations."
		#define STR0005 " By Code            "
		#define STR0006 " By Type            "
		#define STR0007 " By Description     "
		#define STR0008 " By Group           "
		#define STR0009 " By Warehouse       "
		#define STR0010 "Z.Form "
		#define STR0011 "Management   "
		#define STR0012 "Selecting Records...     "
		#define STR0013 "Sorting File...       "
		#define STR0014 "CODE            TP GRP  DESCRIPTION           UM BC WRH   BALANCE     ALLOCATION TO      AVAILABLE     ____________VALUE ___________"
		#define STR0015 "                                                          IN STOCK    REQ/SO/RESERV.     STOCK            IN STOCK        ALLOCATED "
		#define STR0016 "Total of "
		#define STR0017 "Type"
		#define STR0018 "Group"
		#define STR0019 "Total Unit meas. : "
		#define STR0020 "Grand Total:"
		#define STR0021 "CANCELLED BY THE OPERATOR.  "
		#define STR0022 "Record(s) processed "
		#define STR0023 ": Preparation.."
		#define STR0024 "Unified Cost"
		#define STR0025 "When the parameter MV_CUSFIL is activated, the following questions filling are supposed to be observed:"
		#define STR0026 'Do you want to group per warehouse/branch/company? -> "Branch" or "Company" are the unique options to be used'
		#define STR0027 'From Warehouse? -> Only "**"'
		#define STR0028 'To Warehouse? -> Only "**"'
		#define STR0029 'Printing Order -> All, except "WAREHOUSE"'
		#define STR0030 "Parameters are not properly set up.Do you want to print the report anyway?"
		#define STR0031 "Print"
		#define STR0032 "Cancel"
		#define STR0033 "SubTotal by warehous"
		#define STR0034 "    DESCRIPT."
		#define STR0035 "  OF WAREHOUSE"
		#define STR0036 "CODE  "
		#define STR0037 "TP"
		#define STR0038 "GRP."
		#define STR0039 "DESCRIPT."
		#define STR0040 "UM"
		#define STR0041 "FL"
		#define STR0042 "WARH"
		#define STR0043 "BALAN"
		#define STR0044 "IN STOCK  "
		#define STR0045 "ALLOCAT. FOR"
		#define STR0046 "REQ/SO/RESERVE"
		#define STR0047 "STOCK"
		#define STR0048 "AVAILABLE "
		#define STR0049 "VALUE"
		#define STR0050 "ALLOCATED"
		#define STR0051 "DESCRIPT."
		#define STR0052 "OF WAREHOU"
		#define STR0053 "Balances in stock"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Relação Da Posição Do Stock", "Relacao da Posicao do Estoque" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Este relatório emite a posição dos saldos e alocações de cada  produto", "Este relatorio emite a posicao dos saldos e empenhos de cada  produto" )
		#define STR0003 "em estoque. Ele tambem mostrara' o saldo disponivel ,ou seja ,o saldo"
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Subtraído das alocações.", "subtraido dos empenhos." )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", " por código         ", " Por Codigo         " )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", " por tipo           ", " Por Tipo           " )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", " por descrição      ", " Por Descricao      " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", " por grupo          ", " Por Grupo          " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", " por armazém        ", " Por Armazem        " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "Administração", "Administracao" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "A Organizar Ficheiro...", "Organizando Arquivo..." )
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Código          tp grup descrição             um fl armz  saldo       alocação para       stock       ____________valor ___________", "CODIGO          TP GRUP DESCRICAO             UM FL ARMZ  SALDO       EMPENHO PARA       ESTOQUE       ____________VALOR ___________" )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "                                                          Em Stock  Req/pv/reserva     Disponível      Em Stock        Alocado", "                                                          EM ESTOQUE  REQ/PV/RESERVA     DISPONIVEL      EM ESTOQUE        EMPENHADO" )
		#define STR0016 "Total do "
		#define STR0017 "Tipo"
		#define STR0018 "Grupo"
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Total unidade medida : ", "Total Unidade Medida : " )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Total crial : ", "Total Geral : " )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Cancelado Pelo Operador.", "CANCELADO PELO OPERADOR." )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Registo(s) processado(s)", "Registro(s) processado(s)" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", ": Preparação...", ": Preparacao..." )
		#define STR0024 "Custo Unificado"
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Com o parâmetro mv_cusfil activado o preenchimento das seguintes perguntas deve ser observado:", "Com o parametro MV_CUSFIL ativado o preenchimento das seguintes perguntas deve ser observado:" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", 'aGlutina por almoxarifado/filial/empresa? -> somente podem ser utilizadas as opções "filial" ou "empresa"', 'Aglutina Por Almoxarifado/Filial/Empresa? -> Somente podem ser utilizadas as opcoes "Filial" ou "Empresa"' )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", 'aRmazém de? -> somente "**"', 'Armazem De? -> Somente "**"' )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", 'aRmazém ate? -> somente "**"', 'Armazem Ate? -> Somente "**"' )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", 'oRdem de impressão -> todas, exceto "armazém"', 'Ordem de Impressao -> Todas, exceto "ARMAZEM"' )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Os parâmetros não estão devidamente configurados. imprimir relatório assim mesmo ?", "Os parametros nao estao devidamente configurados. Imprime relatorio dessa forma ?" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Imprimir", "Imprime" )
		#define STR0032 "Cancela"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Subtotal Por Armazém", "SubTotal por Armazem" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "    Descrição", "    DESCRICAO" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "    Do Armazém", "    DO ARMAZEM" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Código", "CODIGO" )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Tp.", "TP" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Grup", "GRUP" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Descrição", "DESCRIÇÃO" )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "Um", "UM" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Fl", "FL" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "Armz", "ARMZ" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Saldo", "SALDO" )
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "Em Stock", "EM ESTOQUE" )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Alocação Para", "EMPENHO PARA" )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Req/pv/reserva", "REQ/PV/RESERVA" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Stock", "ESTOQUE" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Disponível", "DISPONIVEL" )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "Valor", "VALOR" )
		#define STR0050 If( cPaisLoc $ "ANG|PTG", "Empenhado", "EMPENHADO" )
		#define STR0051 If( cPaisLoc $ "ANG|PTG", "Descrição", "DESCRIÇÃO" )
		#define STR0052 If( cPaisLoc $ "ANG|PTG", "Do Armazém", "DO ARMAZEM" )
		#define STR0053 If( cPaisLoc $ "ANG|PTG", "Saldos Em Stock", "Saldos em Estoque" )
	#endif
#endif
