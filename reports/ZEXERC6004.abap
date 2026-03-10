*&---------------------------------------------------------------------*
*& Report ZEXERC6004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERC6004.

* Criação de variáveis
DATA: V_LITROS TYPE P DECIMALS 2.
DATA: V_VALOR TYPE P DECIMALS 2.

PARAMETERS: P_DIST TYPE P DECIMALS 2,
            P_LT TYPE P DECIMALS 2,
            P_KMLT TYPE P DECIMALS 2.

* Cálculo
V_LITROS = P_DIST / P_KMLT.
V_VALOR = V_LITROS * P_LT.

* Imprimindo
WRITE: 'Quantidade combustível gasto: ', V_LITROS.
WRITE: 'Valor total gasto: ', V_VALOR.