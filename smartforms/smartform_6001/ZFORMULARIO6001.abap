*&---------------------------------------------------------------------*
*& Report ZFORMULARIO6001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zformulario6001.

DATA: v_name TYPE rs38l_fnam.

DATA: w_output TYPE ssfcompop,
      w_ctro   TYPE ssfctrlop.

PARAMETERS: p_carrid TYPE s_carr_id,
            p_connid TYPE s_conn_id,
            p_fldate TYPE s_date,
            p_id     TYPE s_customer.

CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
  EXPORTING
    formname = 'ZFORM6001'
*   VARIANT  = ' '
*   DIRECT_CALL              = ' '
  IMPORTING
    fm_name  = v_name.

IF NOT v_name IS INITIAL.

  w_ctro-no_dialog  = 'X'.
  w_output-tdnoprev = 'X'.
  w_output-tdimmed  = 'X'.
  w_output-tddest   = 'X'.

  CALL FUNCTION v_name
    EXPORTING
*     ARCHIVE_INDEX      =
*     ARCHIVE_INDEX_TAB  =
*     ARCHIVE_PARAMETERS =
      control_parameters = w_ctro
*     MAIL_APPL_OBJ      =
*     MAIL_RECIPIENT     =
*     MAIL_SENDER        =
      output_options     = w_output
*     USER_SETTINGS      = 'X'
      i_carrid           = p_carrid
      i_connid           = p_connid
      i_fldate           = p_fldate
      i_customid         = p_id
*   IMPORTING
*     DOCUMENT_OUTPUT_INFO       =
*     JOB_OUTPUT_INFO    =
*     JOB_OUTPUT_OPTIONS =
*   EXCEPTIONS
*     FORMATTING_ERROR   = 1
*     INTERNAL_ERROR     = 2
*     SEND_ERROR         = 3
*     USER_CANCELED      = 4
*     OTHERS             = 5
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDIF.