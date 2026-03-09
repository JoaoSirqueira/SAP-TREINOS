*&---------------------------------------------------------------------*
*& Report ZEXERC6002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERC6002.

DATA: METRO_QUADRADO TYPE p DECIMALS 2.

PARAMETERS: P_MED1 TYPE p DECIMALS 2,
            P_MED2 TYPE p DECIMALS 2.

METRO_QUADRADO = P_MED1 * P_MED2.

WRITE: / 'A metragem quadrada é ', METRO_QUADRADO.