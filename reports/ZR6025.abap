*&---------------------------------------------------------------------*
*& Report ZR6025
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

*🥉 Exercício 3 – SELECT da tabela padrão
*
*Crie um REPORT que:
*
*Tenha um PARAMETER para cidade
*
*Faça SELECT na tabela de clientes (KNA1)
*
*Traga:
*
*NAME1
*
*ORT01
*
*Mostre somente clientes da cidade informada
*
*Mostre total encontrado
*
*⚠ Usar SELECT INTO TABLE
*⚠ Usar LOOP
*⚠ Sem ALV ainda

REPORT zr6025.

TABLES kna1.

TYPES: BEGIN OF ty_cliente,
         kunnr TYPE kna1-kunnr,
         name1 TYPE kna1-name1,
         ort01 TYPE kna1-ort01,
       END OF ty_cliente.

DATA: t_clientes TYPE STANDARD TABLE OF ty_cliente,
      wa_cliente TYPE ty_cliente.

DATA v_contag TYPE i VALUE 0.


PARAMETERS p_cidade TYPE kna1-ort01.

SELECT kunnr name1 ort01
  FROM kna1
  INTO TABLE t_clientes
  WHERE ort01 = p_cidade.

IF t_clientes IS INITIAL.
  MESSAGE 'Não há clientes na cidade informada.' TYPE 'I'.
ELSE.
  LOOP AT t_clientes INTO wa_cliente.
    v_contag = v_contag + 1.
    WRITE: / wa_cliente-kunnr,
         wa_cliente-name1,
         wa_cliente-ort01.
  ENDLOOP.
ENDIF.
WRITE: 'Total de clientes encontrados: ', v_contag.