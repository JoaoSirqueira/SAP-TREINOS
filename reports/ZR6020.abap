*&---------------------------------------------------------------------*
*& Report ZR6020
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR6020.

* Tabela transparente
TABLES: ZT6005.

* Tabela interna
DATA: T_ZT6005   TYPE TABLE OF ZT6005,
      T_ZT6001   TYPE TABLE OF ZT6001,
      T_SAIDA    TYPE TABLE OF ZS6001,
      T_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
      T_SORT     TYPE SLIS_T_SORTINFO_ALV,
      T_HEADER   TYPE SLIS_T_LISTHEADER.

* Work area
DATA: W_ZT6005   TYPE ZT6005,
      W_ZT6001   TYPE ZT6001,
      W_SAIDA    TYPE ZS6001,
      W_FIELDCAT TYPE SLIS_FIELDCAT_ALV,
      W_SORT     TYPE SLIS_SORTINFO_ALV,
      W_LAYOUT   TYPE SLIS_LAYOUT_ALV,
      W_HEADER   TYPE SLIS_LISTHEADER,
      W_VARIANT  TYPE DISVARIANT.

* Tela de seleção
SELECTION-SCREEN BEGIN OF BLOCK BC01 WITH FRAME TITLE TEXT-001. " Parâmetros de seleção
  SELECT-OPTIONS: S_TPMAT FOR ZT6005-TPMAT,
                  S_MATER FOR ZT6005-MATER.
SELECTION-SCREEN END OF BLOCK BC01.

SELECTION-SCREEN BEGIN OF BLOCK BC02 WITH FRAME TITLE TEXT-002. " Layout
  PARAMETERS: P_VARIAN TYPE SLIS_VARI.
SELECTION-SCREEN END OF BLOCK BC02.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_VARIAN.
  PERFORM F_VARIANT_F4 CHANGING P_VARIAN.


START-OF-SELECTION.

  PERFORM F_SELECIONA_DADOS.

  PERFORM F_MONTA_TABELA_SAIDA.

  PERFORM F_MONTA_ALV.

*&---------------------------------------------------------------------*
*& Form F_SELECIONA_DADOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_SELECIONA_DADOS .
  SELECT * FROM ZT6005 INTO TABLE T_ZT6005
    WHERE TPMAT IN S_TPMAT
      AND MATER IN S_MATER.

  IF SY-SUBRC IS INITIAL.
    SELECT * FROM ZT6001 INTO TABLE T_ZT6001
      FOR ALL ENTRIES IN T_ZT6005
      WHERE TPMAT = T_ZT6005-TPMAT.
  ELSE.
    MESSAGE TEXT-003 TYPE 'I'. "Não foi encontrado nenhum registro com esses parâmetros
    STOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_MONTA_TABELA_SAIDA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_MONTA_TABELA_SAIDA .

  LOOP AT T_ZT6005 INTO W_ZT6005.
    CLEAR W_SAIDA.
    W_SAIDA-MATER = W_ZT6005-MATER.
    W_SAIDA-DENOM = W_ZT6005-DENOM.
    W_SAIDA-BRGEW = W_ZT6005-BRGEW.
    W_SAIDA-NTGEW = W_ZT6005-NTGEW.
    W_SAIDA-GEWEI = W_ZT6005-GEWEI.
    W_SAIDA-STATUS = W_ZT6005-STATUS.
    W_SAIDA-TPMAT = W_ZT6005-TPMAT.

    READ TABLE T_ZT6001 INTO W_ZT6001 WITH KEY TPMAT = W_ZT6005-TPMAT.
    IF SY-SUBRC IS INITIAL.
      W_SAIDA-DENOM_TP = W_ZT6001-DENOM.
    ENDIF.

    APPEND W_SAIDA TO T_SAIDA.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_MONTA_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_MONTA_ALV .

  PERFORM F_DEFINE_FIELDCAT.

  PERFORM F_ORDENA.

  PERFORM F_LAYOUT.

  PERFORM F_IMPRIME_ALV.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_DEFINE_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_DEFINE_FIELDCAT .

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      I_PROGRAM_NAME         = SY-REPID
      I_INTERNAL_TABNAME     = 'T_SAIDA'
      I_STRUCTURE_NAME       = 'ZS6001'
*     I_CLIENT_NEVER_DISPLAY = 'X'
*     I_INCLNAME             =
*     I_BYPASSING_BUFFER     =
*     I_BUFFER_ACTIVE        =
    CHANGING
      CT_FIELDCAT            = T_FIELDCAT
    EXCEPTIONS
      INCONSISTENT_INTERFACE = 1
      PROGRAM_ERROR          = 2
      OTHERS                 = 3.
  IF SY-SUBRC <> 0.
    MESSAGE TEXT-006 TYPE 'I'. " Erro na definição da FIELDCAT
    STOP.
  ELSE.
    LOOP AT T_FIELDCAT INTO W_FIELDCAT.
      CASE W_FIELDCAT-FIELDNAME.
        WHEN 'BRGEW'.
          W_FIELDCAT-SELTEXT_S = W_FIELDCAT-SELTEXT_M = W_FIELDCAT-SELTEXT_L = W_FIELDCAT-REPTEXT_DDIC = TEXT-004.

        WHEN 'NTGEW'.
          W_FIELDCAT-SELTEXT_S = W_FIELDCAT-SELTEXT_M = W_FIELDCAT-SELTEXT_L = W_FIELDCAT-REPTEXT_DDIC = TEXT-005.

        WHEN 'MATER'.
          W_FIELDCAT-HOTSPOT = 'X'.

      ENDCASE.

      MODIFY T_FIELDCAT FROM W_FIELDCAT INDEX SY-TABIX TRANSPORTING SELTEXT_S SELTEXT_M SELTEXT_L REPTEXT_DDIC HOTSPOT.

    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_ORDENA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_ORDENA .

  CLEAR W_SORT.
  W_SORT-SPOS = 1.
  W_SORT-FIELDNAME = 'MATER'.
  W_SORT-TABNAME = 'T_SAIDA'.
  W_SORT-UP = 'X'.
  APPEND W_SORT TO T_SORT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_LAYOUT .

  W_LAYOUT-ZEBRA = 'X'.
  W_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_IMPRIME_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_IMPRIME_ALV .

  W_VARIANT-VARIANT = P_VARIAN.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      I_CALLBACK_PROGRAM      = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
      I_CALLBACK_USER_COMMAND = 'USER_COMAND'
      I_CALLBACK_TOP_OF_PAGE  = 'F_CABECALHO'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      IS_LAYOUT               = W_LAYOUT
      IT_FIELDCAT             = T_FIELDCAT
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
      IT_SORT                 = T_SORT
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      I_SAVE                  = 'X'
      IS_VARIANT              = W_VARIANT
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER =
*     O_COMMON_HUB            =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      T_OUTTAB                = T_SAIDA
    EXCEPTIONS
      PROGRAM_ERROR           = 1
      OTHERS                  = 2.

ENDFORM.

FORM F_CABECALHO.

  CLEAR W_HEADER.
  REFRESH T_HEADER.

  W_HEADER-TYP  = 'H'. " Tipo H é o tipo HEADER, imprimir em negrito
  W_HEADER-INFO = TEXT-007. " Relatório de materiais
  APPEND W_HEADER TO T_HEADER.

  W_HEADER-TYP  = 'S'.
  W_HEADER-KEY = TEXT-008. " Data.:
  WRITE SY-DATUM TO W_HEADER-INFO.
  APPEND W_HEADER TO T_HEADER.

  W_HEADER-TYP  = 'S'.
  W_HEADER-KEY = TEXT-009. " Hora.:
  WRITE SY-UZEIT TO W_HEADER-INFO.
  APPEND W_HEADER TO T_HEADER.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = T_HEADER
      I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .
ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_VARIANT_F4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- P_VARIAN
*&---------------------------------------------------------------------*
FORM F_VARIANT_F4  CHANGING P_P_VARIAN.

  DATA: VL_VARIANT TYPE DISVARIANT.

  VL_VARIANT-REPORT = SY-REPID.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      IS_VARIANT    = VL_VARIANT
*     I_TABNAME_HEADER          =
*     I_TABNAME_ITEM            =
*     IT_DEFAULT_FIELDCAT       =
      I_SAVE        = 'A'
*     I_DISPLAY_VIA_GRID        = ' '
    IMPORTING
*     E_EXIT        =
      ES_VARIANT    = VL_VARIANT
    EXCEPTIONS
      NOT_FOUND     = 1
      PROGRAM_ERROR = 2
      OTHERS        = 3.
  IF SY-SUBRC = 0.
    P_P_VARIAN = VL_VARIANT-VARIANT.
  ENDIF.

ENDFORM.

FORM USER_COMAND USING R_UCOMM LIKE SY-UCOMM
                       RS_SELFIELD TYPE SLIS_SELFIELD.

  DATA: TL_VIMSELLIST TYPE STANDARD TABLE OF VIMSELLIST,
        WL_VIMSELLIST TYPE VIMSELLIST.

  IF RS_SELFIELD-SEL_TAB_FIELD = 'T_SAIDA-MATER'.

    WL_VIMSELLIST-VIEWFIELD = 'MATER'.
    WL_VIMSELLIST-OPERATOR = 'EQ'.
    WL_VIMSELLIST-VALUE = RS_SELFIELD-VALUE.
    APPEND WL_VIMSELLIST TO TL_VIMSELLIST.

    CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
      EXPORTING
        ACTION                       = 'S'
*       CORR_NUMBER                  = '          '
*       GENERATE_MAINT_TOOL_IF_MISSING       = ' '
*       SHOW_SELECTION_POPUP         = ' '
        VIEW_NAME                    = 'ZT6005'
*       NO_WARNING_FOR_CLIENTINDEP   = ' '
*       RFC_DESTINATION_FOR_UPGRADE  = ' '
*       CLIENT_FOR_UPGRADE           = ' '
*       VARIANT_FOR_SELECTION        = ' '
*       COMPLEX_SELCONDS_USED        = ' '
*       CHECK_DDIC_MAINFLAG          = ' '
*       SUPPRESS_WA_POPUP            = ' '
      TABLES
        DBA_SELLIST                  = TL_VIMSELLIST
*       EXCL_CUA_FUNCT               =
      EXCEPTIONS
        CLIENT_REFERENCE             = 1
        FOREIGN_LOCK                 = 2
        INVALID_ACTION               = 3
        NO_CLIENTINDEPENDENT_AUTH    = 4
        NO_DATABASE_FUNCTION         = 5
        NO_EDITOR_FUNCTION           = 6
        NO_SHOW_AUTH                 = 7
        NO_TVDIR_ENTRY               = 8
        NO_UPD_AUTH                  = 9
        ONLY_SHOW_ALLOWED            = 10
        SYSTEM_FAILURE               = 11
        UNKNOWN_FIELD_IN_DBA_SELLIST = 12
        VIEW_NOT_FOUND               = 13
        MAINTENANCE_PROHIBITED       = 14
        OTHERS                       = 15.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.

ENDFORM.