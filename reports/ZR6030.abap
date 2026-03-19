*&---------------------------------------------------------------------*
*& Report ZR6030
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr6030.

TYPE-POOLS: slis. " É tipodiretório com estruturas salvas.

* Declarando tabela para o select-options
TABLES: z6030aula_curso.

" Selection-Screen: contorno na variável de entrada
SELECTION-SCREEN BEGIN OF BLOCK b11 WITH FRAME TITLE TEXT-001." Parâmetro de entrada
* Parâmetro
  SELECT-OPTIONS: so_curso FOR z6030aula_curso-nome_curso NO INTERVALS.
  PARAMETERS: p_basic TYPE char1 RADIOBUTTON GROUP gr1,
              p_compl TYPE char1 RADIOBUTTON GROUP gr1 DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b11.

* Tabelas internas
DATA: lt_zt6030_curso   TYPE TABLE OF z6030aula_curso,
      lt_zt6030_alun    TYPE TABLE OF z6030aula_alun,

* Declaração de variáveis
      lo_grid_100a      TYPE REF TO cl_gui_alv_grid,
      lo_grid_100b      TYPE REF TO cl_gui_alv_grid,
      lo_container_100a TYPE REF TO cl_gui_custom_container,
      lo_container_100b TYPE REF TO cl_gui_custom_container,
      lv_okcode_100     TYPE sy-ucomm,
      lt_fieldcata      TYPE lvc_t_fcat,
      lt_fieldcatb      TYPE lvc_t_fcat,
      ls_layout         TYPE lvc_s_layo,
      ls_variant        TYPE disvariant.

START-OF-SELECTION.
  PERFORM f_obtem_dados.

* Form
FORM f_obtem_dados.

  SELECT *
    FROM z6030aula_curso
    INTO TABLE lt_zt6030_curso[]
    WHERE nome_curso IN so_curso[].


  SELECT *
    FROM z6030aula_alun
    INTO TABLE lt_zt6030_alun[]
    WHERE nome_curso IN so_curso[].

  IF p_basic EQ 'X'.
    PERFORM f_visualizar_dados_alv_basico.
  ELSE.
    PERFORM f_visualizar_dados_alv_compl.
  ENDIF.

ENDFORM.

FORM f_visualizar_dados_alv_compl.

  IF lt_zt6030_curso[] IS NOT INITIAL OR lt_zt6030_alun[] IS NOT INITIAL.
    CALL SCREEN 100.
  ELSE.
    MESSAGE 'Dados não localizados!' TYPE 'S' DISPLAY LIKE 'W'.
  ENDIF.

ENDFORM.

FORM f_visualizar_dados_alv_basico.

  DATA: lt_fieldcata_basico TYPE slis_t_fieldcat_alv,
        ls_layout_basico    TYPE slis_layout_alv.

* Cria o lt_fieldcata[] com base em uma estrutura de dados criada na SE11
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'z6030aula_curso'
    CHANGING
      ct_fieldcat      = lt_fieldcata_basico[].

  ls_layout_basico-colwidth_optimize = 'X'.
  ls_layout_basico-zebra             = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout     = ls_layout_basico
      it_fieldcat   = lt_fieldcata_basico[]
    TABLES
      t_outtab      = lt_zt6030_curso[]
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE lv_okcode_100.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.

  ENDCASE.

ENDMODULE.


*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS100'. " Status 100
  SET TITLEBAR 'TITLE100'. " Exemplo ALV completo
ENDMODULE.


*&---------------------------------------------------------------------*
*& Module M_SHOW_GRID_100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE m_show_grid_100 OUTPUT.

  FREE: lt_fieldcata[].

  ls_layout-cwidth_opt = 'X'.
  ls_layout-zebra      = 'X'.
  ls_variant-report    = sy-repid.

  PERFORM f_build_grid_a.
  PERFORM f_build_grid_b.

ENDMODULE.

FORM f_build_grid_a.

  PERFORM f_build_fieldcat USING:
      'NOME_CURSO'  'NOME_CURSO' 'z6030aula_curso'  'Curso'       ''  CHANGING lt_fieldcata[],
      'DT_INICIO'   'DT_INICIO'  'z6030aula_curso'  'Dt. Início'  ''  CHANGING lt_fieldcata[],
      'DT_FIM'      'DT_FIM'     'z6030aula_curso'  'Dt. Fim'     ''  CHANGING lt_fieldcata[],
      'ATIVO'       'ATIVO'      'z6030aula_curso'  'Ativo'       'X' CHANGING lt_fieldcata[].

  IF lo_grid_100a IS INITIAL.

    lo_container_100a = NEW cl_gui_custom_container( container_name = 'CONTAINERA' ).
    lo_grid_100a      = NEW cl_gui_alv_grid( i_parent = lo_container_100a ).

    lo_grid_100a->set_table_for_first_display(
    EXPORTING
      is_variant = ls_variant
      is_layout = ls_layout
      i_save = 'A'
    CHANGING
      it_fieldcatalog = lt_fieldcata[]
      it_outtab = lt_zt6030_curso[]
   ).
    lo_grid_100a->set_gridtitle( 'Lista de Cursos'). " Adiciona um título em cima da tabela
  ELSE.
    lo_grid_100a->refresh_table_display( ).
  ENDIF.


ENDFORM.

FORM f_build_grid_b.

  PERFORM f_build_fieldcat USING:
      'NOME_CURSO'        'NOME_CURSO'        'z6030aula_alun'  'Curso'             ' '  CHANGING lt_fieldcatb[],
      'NOME_ALUNO'        'NOME_ALUNO'        'z6030aula_alun'  'Aluno'             ' '  CHANGING lt_fieldcatb[],
      'DT_NASCIMENTO'     'DT_NASCIMENTO'     'z6030aula_alun'  'Dt.Nascimento'     ' '  CHANGING lt_fieldcatb[],
      'INSCR_CONFIRMADA'  'INSCR_CONFIRMADA'  'z6030aula_alun'  'Insc.Confirmada'   'X'  CHANGING lt_fieldcatb[],
      'PGTO_CONFIRMADO'   'PGTO_CONFIRMADO'   'z6030aula_alun'  'Pgto.Confirmado'   'X'  CHANGING lt_fieldcatb[].

  IF lo_grid_100b IS INITIAL.

    lo_container_100b = NEW cl_gui_custom_container( container_name = 'CONTAINERB' ).
    lo_grid_100b      = NEW cl_gui_alv_grid( i_parent = lo_container_100b ).

    lo_grid_100b->set_table_for_first_display(
    EXPORTING
      is_variant = ls_variant
      is_layout = ls_layout
      i_save = 'A'
    CHANGING
      it_fieldcatalog = lt_fieldcatb[]
      it_outtab = lt_zt6030_alun[]
   ).
    lo_grid_100b->set_gridtitle( 'Lista de alunos'). " Adiciona um título em cima da tabela
  ELSE.
    lo_grid_100b->refresh_table_display( ).
  ENDIF.

ENDFORM.

FORM f_build_fieldcat USING VALUE(p_fieldname) TYPE c
                            VALUE(p_field)     TYPE c
                            VALUE(p_table)     TYPE c
                            VALUE(p_coltext)   TYPE c
                            VALUE(p_checkbox)  TYPE c
                         CHANGING t_fieldcat   TYPE lvc_t_fcat.

  DATA: ls_fieldcat LIKE LINE OF t_fieldcat[].
  ls_fieldcat-fieldname = p_fieldname.
  ls_fieldcat-ref_field = p_field.
  ls_fieldcat-ref_table = p_table.
  ls_fieldcat-coltext   = p_coltext.
  ls_fieldcat-checkbox  = p_checkbox.
  APPEND ls_fieldcat TO t_fieldcat[].

ENDFORM.