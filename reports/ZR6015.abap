*&---------------------------------------------------------------------*
*& Report ZR6015
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR6015.

* Tabelas transparentes
TABLES: ZT6005.

* Tabelas internas
DATA: T_ZT6001 TYPE TABLE OF ZT6001 WITH HEADER LINE,
      T_ZT6005 TYPE TABLE OF ZT6005 WITH HEADER LINE.

* Tela de seleção
SELECT-OPTIONS: S_TPMAT FOR ZT6005-TPMAT,
                S_MATER FOR ZT6005-MATER.

* Início do processamento
START-OF-SELECTION.
  PERFORM F_SELECIONA_DADOS.

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

  SELECT * FROM ZT6005
    INTO TABLE T_ZT6005
    WHERE MATER IN S_MATER
    AND TPMAT IN S_TPMAT.

  IF T_ZT6005[] IS NOT INITIAL. " IS INITIAL é o mesmo que IGUAL A ZERO

    SELECT * FROM ZT6001
      INTO TABLE T_ZT6001
    FOR ALL ENTRIES IN T_ZT6005
      WHERE TPMAT = T_ZT6005-TPMAT.

  ELSE.
    MESSAGE TEXT-001 TYPE 'I'. " Nenhum registro encontrado para esse critério de seleção
    STOP.


  ENDIF.

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

  SORT T_ZT6005 BY MATER TPMAT.
  SORT T_ZT6001 BY TPMAT.

  LOOP AT T_ZT6005.
    WRITE: / T_ZT6005-MATER, T_ZT6005-DENOM, T_ZT6005-BRGEW, T_ZT6005-NTGEW,
             T_ZT6005-TPMAT.

    READ TABLE T_ZT6001 WITH KEY TPMAT = T_ZT6005-TPMAT BINARY SEARCH.
    IF SY-SUBRC IS INITIAL.
      WRITE: T_ZT6001-DENOM.
    ENDIF.

  ENDLOOP.

ENDFORM.