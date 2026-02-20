*&---------------------------------------------------------------------*
*& Report ZR6013
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR6014.

* Tabelas transparentes
TABLES: ZT6005.

* Tipos
TYPES: BEGIN OF TY_MATER,
         MATER  LIKE ZT6005-MATER,
         DENOM  LIKE ZT6005-DENOM,
         BRGEW  LIKE ZT6005-BRGEW,
         NTGEW  LIKE ZT6005-NTGEW,
         GEWEI  LIKE ZT6005-GEWEI,
         STATUS LIKE ZT6005-STATUS,
         TPMAT  LIKE ZT6001-TPMAT,
         DENOM1 LIKE ZT6001-DENOM,
       END OF TY_MATER.

* Tabelas internas
DATA: T_MATER TYPE TABLE OF TY_MATER.

* Work Área
DATA W_MATER TYPE TY_MATER.


* Tela de seleção
SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: S_TPMAT FOR ZT6005-TPMAT,
                  S_MATER FOR ZT6005-MATER.
SELECTION-SCREEN END OF BLOCK B01.

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

  SELECT ZT6005~MATER ZT6005~DENOM ZT6005~BRGEW ZT6005~NTGEW ZT6005~GEWEI
         ZT6005~STATUS ZT6001~TPMAT ZT6001~DENOM
    FROM ZT6005
    LEFT OUTER JOIN ZT6001
    ON ZT6005~TPMAT = ZT6001~TPMAT
    INTO TABLE T_MATER
    WHERE ZT6005~TPMAT IN S_TPMAT
    AND ZT6005~MATER IN S_MATER.

  IF SY-SUBRC <> 0.
    MESSAGE TEXT-002 TYPE 'I'. " Não foi encontrado nenhum registro com esses parâmetros
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

  LOOP AT T_MATER INTO W_MATER.

    WRITE: / W_MATER-MATER, W_MATER-DENOM, W_MATER-BRGEW, W_MATER-NTGEW,
             W_MATER-GEWEI, W_MATER-STATUS, W_MATER-TPMAT, W_MATER-DENOM1.

  ENDLOOP.


ENDFORM.