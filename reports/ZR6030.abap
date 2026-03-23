*&---------------------------------------------------------------------*
*& Report ZR6030
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr6030.

INCLUDE <icon>.

TYPE-POOLS: slis. " É tipodiretório com estruturas salvas.

* Declarando tabela para o select-options
TABLES: z6030aula_curso.

* Tipos
TYPES:
  BEGIN OF ly_alun.
    INCLUDE TYPE z6030aula_alun.
TYPES: id    TYPE icon-id,
    color TYPE char4,
  END OF ly_alun.

" Selection-Screen: contorno na variável de entrada
SELECTION-SCREEN BEGIN OF BLOCK b11 WITH FRAME TITLE TEXT-001." Parâmetro de entrada
* Parâmetro
  SELECT-OPTIONS: so_curso FOR z6030aula_curso-nome_curso NO INTERVALS.
  PARAMETERS: p_basic TYPE char1 RADIOBUTTON GROUP gr1,
              p_compl TYPE char1 RADIOBUTTON GROUP gr1 DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b11.

* Tabelas internas
DATA: lt_zt6030_curso   TYPE TABLE OF z6030aula_curso,
      lt_zt6030_alun    TYPE TABLE OF ly_alun,

* Declaração de variáveis
      lo_grid_100a      TYPE REF TO cl_gui_alv_grid,
      lo_grid_100b      TYPE REF TO cl_gui_alv_grid,
      lo_container_100a TYPE REF TO cl_gui_custom_container,
      lo_container_100b TYPE REF TO cl_gui_custom_container,
      lv_okcode_100     TYPE sy-ucomm,
      lt_fieldcata      TYPE lvc_t_fcat,
      lt_fieldcatb      TYPE lvc_t_fcat,
      lt_tool_bar       TYPE ui_functions,
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

  " Percorre para adicionar os ícones
  LOOP AT lt_zt6030_alun[] ASSIGNING FIELD-SYMBOL(<fs_alun>).
    IF <fs_alun>-inscr_confirmada EQ 'X' AND <fs_alun>-pgto_confirmado EQ 'X'. " Se a confirmação estiver OK e o Pagamento estiver confirmado coloque ícone verde
      <fs_alun>-id    = icon_green_light.
      <fs_alun>-color = 'C500'.
    ELSEIF <fs_alun>-inscr_confirmada EQ 'X' AND <fs_alun>-pgto_confirmado IS INITIAL. " Se a confirmação for OK e o pagamento não coloque ícone amarelo
      <fs_alun>-id    = icon_yellow_light.
      <fs_alun>-color = 'C300'.
    ELSE.
      <fs_alun>-id    = icon_red_light.
      <fs_alun>-color = 'C600'.
    ENDIF.
  ENDLOOP.

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
  ls_layout-info_fname = 'COLOR'.
  ls_variant-report    = sy-repid.

  PERFORM f_remove_alv_buttons.
  PERFORM f_build_grid_a.
  PERFORM f_build_grid_b.

ENDMODULE.

FORM f_build_grid_a.

  PERFORM f_build_fieldcat USING:
      'NOME_CURSO'  'NOME_CURSO' 'z6030aula_curso'  'Curso'       ' '  ' ' CHANGING lt_fieldcata[],
      'DT_INICIO'   'DT_INICIO'  'z6030aula_curso'  'Dt. Início'  ' '  ' ' CHANGING lt_fieldcata[],
      'DT_FIM'      'DT_FIM'     'z6030aula_curso'  'Dt. Fim'     ' '  ' ' CHANGING lt_fieldcata[],
      'ATIVO'       'ATIVO'      'z6030aula_curso'  'Ativo'       'X'  ' ' CHANGING lt_fieldcata[].

  IF lo_grid_100a IS INITIAL.

    lo_container_100a = NEW cl_gui_custom_container( container_name = 'CONTAINERA' ).
    lo_grid_100a      = NEW cl_gui_alv_grid( i_parent = lo_container_100a ).

    " Permite seleção múltipla de linhas
    lo_grid_100a->set_ready_for_input( 1 ).

    lo_grid_100a->set_table_for_first_display(
    EXPORTING
      it_toolbar_excluding = lt_tool_bar[]
      is_variant           = ls_variant
      is_layout            = ls_layout
      i_save               = 'A'
    CHANGING
      it_fieldcatalog      = lt_fieldcata[]
      it_outtab            = lt_zt6030_curso[]
   ).
    lo_grid_100a->set_gridtitle( 'Lista de Cursos'). " Adiciona um título em cima da tabela
  ELSE.
    lo_grid_100a->refresh_table_display( ).
  ENDIF.


ENDFORM.

FORM f_build_grid_b.

  PERFORM f_build_fieldcat USING:
      'ID'                'ID'                'ICON'            'Status'            ' '  'X' CHANGING lt_fieldcatb[],
      'NOME_CURSO'        'NOME_CURSO'        'z6030aula_alun'  'Curso'             ' '  ' ' CHANGING lt_fieldcatb[],
      'NOME_ALUNO'        'NOME_ALUNO'        'z6030aula_alun'  'Aluno'             ' '  ' ' CHANGING lt_fieldcatb[],
      'DT_NASCIMENTO'     'DT_NASCIMENTO'     'z6030aula_alun'  'Dt.Nascimento'     ' '  ' ' CHANGING lt_fieldcatb[],
      'INSCR_CONFIRMADA'  'INSCR_CONFIRMADA'  'z6030aula_alun'  'Insc.Confirmada'   'X'  ' ' CHANGING lt_fieldcatb[],
      'PGTO_CONFIRMADO'   'PGTO_CONFIRMADO'   'z6030aula_alun'  'Pgto.Confirmado'   'X'  ' ' CHANGING lt_fieldcatb[].

  IF lo_grid_100b IS INITIAL.

    lo_container_100b = NEW cl_gui_custom_container( container_name = 'CONTAINERB' ).
    lo_grid_100b      = NEW cl_gui_alv_grid( i_parent = lo_container_100b ).

    " Permite seleção múltipla de linhas
    lo_grid_100b->set_ready_for_input( 1 ).

    lo_grid_100b->set_table_for_first_display(
    EXPORTING
      it_toolbar_excluding = lt_tool_bar[]
      is_variant           = ls_variant
      is_layout            = ls_layout
      i_save               = 'A'
    CHANGING
      it_fieldcatalog      = lt_fieldcatb[]
      it_outtab            = lt_zt6030_alun[]
   ).
    lo_grid_100b->set_gridtitle( 'Lista de alunos'). " Adiciona um título em cima da tabela
  ELSE.
    lo_grid_100b->refresh_table_display( ).
  ENDIF.

ENDFORM.

FORM f_remove_alv_buttons.

  " Remove botões indesejados do Grid.
* APPEND cl_gui_alv_grid=>mc_fc_excl_all                TO lt_tool_bar[]. " <- Comando remove todos os botões
  APPEND cl_gui_alv_grid=>mc_evt_delayed_change_select  TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_evt_delayed_move_curr_cell TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_evt_enter                  TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_evt_modified               TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_auf                     TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_average                 TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_back_classic            TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_call_abc                TO lt_tool_bar[].
* APPEND cl_gui_alv_grid->mc_fc_call_chain              TO lt_tool_bar[].
* APPEND cl_guilalv_grid=>mc_fc_call_crbatch            TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_call_crweb              TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_call_lineitems          TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_call_master_data        TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_call_more               TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_call_report             TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_call_xint               TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_call_xxl                TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_check                   TO lt_tool_bar[].
* APPEND cl_gui_alv_grid->mc_fc_col_invisible           TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_col_optimize            TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_count                   TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_current_variant         TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_data_save               TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_delete_filter           TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_deselect_all            TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_detail                  TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_expcrdata               TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_expcrdesig              TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_expcrtempl              TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_expmdb                  TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_extend                  TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_f4                      TO lt_tool_bar[].
* APPEND cl_gui_alv_grid=>mc_fc_filter                  TO lt_tool_bar[].
* APPEND cl_gui_alv_grid=>mc_fc_find                    TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_fix_columns             TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_graph                   TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_help                    TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_info                    TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_load_variant            TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_loc_append_row          TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy                TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row            TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_loc_cut                 TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row          TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row          TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_loc_move_row            TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_loc_paste               TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_loc_paste_new_row       TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_loc_undo                TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_maintain_variant        TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_maximum                 TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_minimum                 TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_pc_file                 TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_print                   TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_print_back              TO lt_tool_bar[].
  APPEND cl_gui_alv_grid=>mc_fc_print_prev              TO lt_tool_bar[].
* APPEND cl_gui_alv_grid->mc_fc_refresh                 TO lt_tool_bar[].


ENDFORM.

FORM f_build_fieldcat USING VALUE(p_fieldname) TYPE c
                            VALUE(p_field)     TYPE c
                            VALUE(p_table)     TYPE c
                            VALUE(p_coltext)   TYPE c
                            VALUE(p_checkbox)  TYPE c
                            VALUE(p_icon)      TYPE c
                         CHANGING t_fieldcat   TYPE lvc_t_fcat.

  DATA: ls_fieldcat LIKE LINE OF t_fieldcat[].
  ls_fieldcat-fieldname = p_fieldname.
  ls_fieldcat-ref_field = p_field.
  ls_fieldcat-ref_table = p_table.
  ls_fieldcat-coltext   = p_coltext.
  ls_fieldcat-checkbox  = p_checkbox.
  ls_fieldcat-icon  = p_icon.
  APPEND ls_fieldcat TO t_fieldcat[].

ENDFORM.