*&---------------------------------------------------------------------*
*& Report ZR6009
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR6009.

* Tabela transparente
TABLES: T005T. " Denominação dos países

* Tela de seleção
PARAMETERS P_SPRAS LIKE T005T-SPRAS DEFAULT 'EN'.

ULINE (30).

WRITE: /01 '|',
        02 'País',
        07 '|',
        08 'Denominação',
        30 '|'.

ULINE /(30).

SELECT * FROM T005T WHERE SPRAS = P_SPRAS.
  WRITE: /01 '|',
          02 T005T-LAND1,
          07 '|',
          08 T005T-LANDX,
          30 '|'.

  ULINE /(30).
ENDSELECT.