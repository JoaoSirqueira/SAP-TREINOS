*&---------------------------------------------------------------------*
*& Report ZR6005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR6005.

* Declaração de parâmetros
*PARAMETER P_DATA TYPE D. <- Não rodou
PARAMETERS: P_HORA TYPE T,
            P_NOME TYPE STRING,
            P_DATA TYPE D.

* Impressão dos valores
WRITE: / 'Nome:', P_NOME.
WRITE: / 'Data:', P_DATA DD/MM/YYYY.
WRITE: / 'Hora:', P_HORA ENVIRONMENT TIME FORMAT.