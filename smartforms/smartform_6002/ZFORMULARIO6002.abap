*&---------------------------------------------------------------------*
*& Report ZFORMULARIO6002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zformulario6002.

DATA: w_cabe  TYPE zslista6001,
      t_lista TYPE TABLE OF zslista6002.

DATA v_name TYPE rs38l_fnam.

PARAMETERS: p_carrid TYPE s_carr_id,
            p_connid TYPE s_conn_id,
            p_fldate TYPE s_date.

START-OF-SELECTION.

  PERFORM f_select.

  IF NOT t_lista[] IS INITIAL.
    PERFORM f_smartforms.
  ENDIF.

*&---------------------------------------------------------------------*
*& Form F_SELECT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_select .

  SELECT SINGLE a~carrid a~carrname b~connid b~countryfr b~cityfrom
         b~airpfrom b~countryto b~cityto b~airpto b~deptime c~fldate
    FROM scarr AS a
   INNER JOIN spfli AS b
      ON a~carrid = b~carrid
   INNER JOIN sflight AS c
      ON b~carrid = c~carrid
     AND b~connid = c~connid
   INTO w_cabe
  WHERE c~carrid = p_carrid
    AND c~connid = p_connid
    AND c~fldate = p_fldate.

  IF sy-subrc IS INITIAL.

    SELECT bookid passname class luggweight wunit loccuram loccurkey
      FROM sbook INTO TABLE t_lista
     WHERE carrid = w_cabe-carrid
       AND connid = w_cabe-connid
       AND fldate = p_fldate.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_SMARTFORMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_smartforms .

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname = 'ZFORM6002'
    IMPORTING
      fm_name  = v_name.

  IF NOT v_name IS INITIAL.

    CALL FUNCTION v_name
      EXPORTING
*       ARCHIVE_INDEX    =
*       ARCHIVE_INDEX_TAB          =
*       ARCHIVE_PARAMETERS         =
*       CONTROL_PARAMETERS         =
*       MAIL_APPL_OBJ    =
*       MAIL_RECIPIENT   =
*       MAIL_SENDER      =
*       OUTPUT_OPTIONS   =
*       USER_SETTINGS    = 'X'
        cabe             = w_cabe
*     IMPORTING
*       DOCUMENT_OUTPUT_INFO       =
*       JOB_OUTPUT_INFO  =
*       JOB_OUTPUT_OPTIONS         =
      TABLES
        lista            = t_lista
      EXCEPTIONS
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        user_canceled    = 4
        OTHERS           = 5.

  ENDIF.

ENDFORM.