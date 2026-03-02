*&---------------------------------------------------------------------*
*& Report ZR6011
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR6011.

* Tabela transparente
TABLES T005U.

* Tabela interna
DATA: BEGIN OF T_T005U OCCURS 0,
        LAND1 LIKE T005U-LAND1,
        BLAND LIKE T005U-BLAND,
        BEZEI LIKE T005U-BEZEI,
      END OF T_T005U.

* Tela de seleção
SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: S_LAND1 FOR T005U-LAND1,
                  S_BLAND FOR T005U-BLAND.
SELECTION-SCREEN END OF BLOCK B01.

SELECTION-SCREEN BEGIN OF BLOCK B02 WITH FRAME TITLE TEXT-002.
  PARAMETERS: P_SPRAS LIKE T005U-SPRAS.
SELECTION-SCREEN END OF BLOCK B02.

PERFORM F_SELECIONA_DADOS. " F_ Para identificar que é um FORM

PERFORM F_IMPRIME_CABECALHO.

PERFORM F_IMPRIME_DADOS.

*&---------------------------------------------------------------------*
*& Form F_SELECIONA_DADOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_SELECIONA_DADOS .

* ROTINA DE SELEÇÃO
  SELECT LAND1 BLAND BEZEI
    FROM T005U
    INTO TABLE T_T005U
    WHERE LAND1 IN S_LAND1
    AND BLAND IN S_BLAND
    AND SPRAS = P_SPRAS.

  IF SY-SUBRC <> 0.
    MESSAGE TEXT-003 TYPE 'I'. "Nenhum registro encontrado.
    STOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_IMPRIME_CABECALHO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_IMPRIME_CABECALHO .

  FORMAT COLOR 1.
  ULINE /(35).
  WRITE: /1 '|',
          2 'País',
          7 '|',
          8 'Região',
          14 '|',
          15 'Denominação',
          35 '|'.
  ULINE /(35).
  FORMAT RESET.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_IMPRIME_DADOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_IMPRIME_DADOS .

    LOOP AT T_T005U.
      WRITE: /1 '|',
              2 T_T005U-LAND1,
              7 '|',
              8 T_T005U-BLAND,
              14 '|',
              15 T_T005U-BEZEI,
              35 '|'.
      ULINE /(35).
    ENDLOOP.

ENDFORM.