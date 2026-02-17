*&---------------------------------------------------------------------*
*& Report ZR6010
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR6010.

* Tabela transparente
TABLES: T005T. " Denominação dos países

* Tabela interna
DATA: T_T005T TYPE TABLE OF T005T WITH HEADER LINE.

* Tela de seleção
PARAMETERS P_SPRAS LIKE T005T-SPRAS DEFAULT 'EN'.

ULINE (30).

WRITE: /01 '|',
        02 'País',
        07 '|',
        08 'Denominação',
        30 '|'.

ULINE /(30).

SELECT * FROM T005T INTO TABLE T_T005T WHERE SPRAS = P_SPRAS.

  LOOP AT T_T005T.
  WRITE: /01 '|',
          02 T_T005T-LAND1,
          07 '|',
          08 T_T005T-LANDX,
          30 '|'.

  ULINE /(30).
ENDLOOP.