*&---------------------------------------------------------------------*
*& Report ZEXERC6001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERC6001.

DATA V_IDADE(4) TYPE C.

PARAMETERS: P_NOME(40) TYPE C,
            P_ANO(4) TYPE N.

V_IDADE = SY-DATUM(4) - P_ANO.
WRITE: 'O sr(a):', P_NOME.
WRITE: /'possui ',V_IDADE, 'de idade'.