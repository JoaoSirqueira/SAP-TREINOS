*&---------------------------------------------------------------------*
*& Report ZR6026
*&---------------------------------------------------------------------*
REPORT zr6026.

* Parâmetros
PARAMETERS: p_werks TYPE mard-werks DEFAULT '1000',
            p_dias  TYPE i DEFAULT 0.

* Criação dos tipos
TYPES: BEGIN OF ty_output,
         matnr       TYPE mara-matnr, " Cód. Material
         maktx       TYPE makt-maktx, " Descr. Material
         werks       TYPE mard-werks, " Centro
         last_mov    TYPE mkpf-budat, " Últ. Movimentação
         dias_parado TYPE i,           " Campo calculado
         estoque     TYPE mard-labst,  " Qtd.
       END OF ty_output.

TYPES: BEGIN OF ty_mard_sel,
         matnr TYPE mard-matnr,
         werks TYPE mard-werks,
         labst TYPE mard-labst,
       END OF ty_mard_sel.

TYPES: BEGIN OF ty_last_mov,
         matnr TYPE mseg-matnr,
         werks TYPE mseg-werks,
         budat TYPE mkpf-budat,
       END OF ty_last_mov.

* Tabelas internas
DATA: gt_mard   TYPE STANDARD TABLE OF ty_mard_sel,
      gt_output TYPE STANDARD TABLE OF ty_output.

DATA: t_last_mov TYPE TABLE OF ty_last_mov.

* Work Area
DATA: wa_mard TYPE ty_mard_sel.
DATA: wa_output   TYPE ty_output,
      wa_last_mov TYPE ty_last_mov.

* Variável para descrição do material
DATA: t_maktx TYPE makt-maktx.

* Dados de teste (substituem SELECT de tabelas reais)
CLEAR wa_mard.
wa_mard-matnr = 'MAT001'.
wa_mard-werks = p_werks.
wa_mard-labst = 150.
APPEND wa_mard TO gt_mard.

CLEAR wa_mard.
wa_mard-matnr = 'MAT002'.
wa_mard-werks = p_werks.
wa_mard-labst = 50.
APPEND wa_mard TO gt_mard.

CLEAR wa_mard.
wa_mard-matnr = 'MAT003'.
wa_mard-werks = p_werks.
wa_mard-labst = 200.
APPEND wa_mard TO gt_mard.

CLEAR wa_last_mov.
wa_last_mov-matnr = 'MAT001'.
wa_last_mov-werks = p_werks.
wa_last_mov-budat = sy-datum - 12. " Última movimentação há 12 dias
APPEND wa_last_mov TO t_last_mov.

CLEAR wa_last_mov.
wa_last_mov-matnr = 'MAT002'.
wa_last_mov-werks = p_werks.
wa_last_mov-budat = sy-datum - 5. " Última movimentação há 5 dias
APPEND wa_last_mov TO t_last_mov.

CLEAR wa_last_mov.
wa_last_mov-matnr = 'MAT003'.
wa_last_mov-werks = p_werks.
wa_last_mov-budat = sy-datum - 20. " Última movimentação há 20 dias
APPEND wa_last_mov TO t_last_mov.

LOOP AT gt_mard INTO wa_mard.

  CLEAR: wa_output, wa_last_mov, t_maktx.

  " Descrição fictícia para teste
  CASE wa_mard-matnr.
    WHEN 'MAT001'. t_maktx = 'Parafuso M10'.
    WHEN 'MAT002'. t_maktx = 'Porca M10'.
    WHEN 'MAT003'. t_maktx = 'Arruela M10'.
    WHEN OTHERS.  t_maktx = 'Material Teste'.
  ENDCASE.

  wa_output-matnr = wa_mard-matnr.
  wa_output-werks = wa_mard-werks.
  wa_output-estoque = wa_mard-labst.
  wa_output-maktx = t_maktx.

  READ TABLE t_last_mov INTO wa_last_mov
    WITH KEY matnr = wa_mard-matnr
             werks = wa_mard-werks.

  IF sy-subrc IS INITIAL.
    wa_output-last_mov = wa_last_mov-budat.

    DATA(v_dias) = sy-datum - wa_last_mov-budat.
    wa_output-dias_parado = v_dias.

    IF wa_output-dias_parado > p_dias.
      APPEND wa_output TO gt_output.
    ENDIF.
  ENDIF.

ENDLOOP.

* Impressão do resultado
* ====================================
* Não foi eu que fiz isso abaixo:
* ====================================

DATA: gr_alv     TYPE REF TO cl_salv_table,
      gr_columns TYPE REF TO cl_salv_columns_table,
      gr_column  TYPE REF TO cl_salv_column.

TRY.

    cl_salv_table=>factory(
      IMPORTING r_salv_table = gr_alv
      CHANGING  t_table      = gt_output ).

    gr_columns = gr_alv->get_columns( ).
    gr_columns->set_optimize( abap_true ).

    TRY.
        gr_column ?= gr_columns->get_column( 'DIAS_PARADO' ).
        gr_column->set_short_text( 'Dias' ).
        gr_column->set_medium_text( 'Dias Parado' ).
        gr_column->set_long_text( 'Dias sem Movimentação' ).
      CATCH cx_salv_not_found.
        " Se não achar a coluna, não faz nada
    ENDTRY.

    gr_alv->display( ).

  CATCH cx_salv_msg.
    WRITE: / 'Erro ao gerar ALV'.
ENDTRY.