*&---------------------------------------------------------------------*
*& Report ZR6022
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*🔹 Exercício 2 – SELECT com SELECT-OPTIONS
*
*Crie um report que:
*
*Use SELECT-OPTIONS para s_kunnr
*
*Busque na tabela KNA1
*
*Mostre:
*
*KUNNR
*
*NAME1
*
*ORT01
*
*Ordene por NAME1
*
*Exiba total de registros no final
REPORT ZR6022.

* Tabela interna
TABLES: KNA1.

* Tipos
TYPES: BEGIN OF TY_KUNNR,
  KUNNR LIKE KNA1-KUNNR,
  NAME1 LIKE KNA1-NAME1,
  ORT01 LIKE KNA1-ORT01,
       END OF TY_KUNNR.

* Tabela interna
DATA: T_KUNNR TYPE TABLE OF TY_KUNNR.

* Work area
DATA: W_KUNNR TYPE TY_KUNNR.


* Selecionar opções
SELECT-OPTIONS: S_KUNNR FOR KNA1-KUNNR.

* Selecionando os campos e ordenando por NAME1

IF S_KUNNR IS INITIAL.
  MESSAGE 'Informe um valor' TYPE 'I'.
  EXIT.
ENDIF.

SELECT KUNNR NAME1 ORT01 FROM KNA1
  INTO TABLE T_KUNNR
  WHERE KUNNR IN S_KUNNR
  ORDER BY NAME1.


IF T_KUNNR IS NOT INITIAL.
  LOOP AT T_KUNNR INTO W_KUNNR.
    WRITE: / W_KUNNR-KUNNR,
           W_KUNNR-NAME1,
           W_KUNNR-ORT01.
  ENDLOOP.
* Calculando o número total de registros
  DATA: lv_total TYPE i.
  DESCRIBE TABLE T_KUNNR LINES lv_total.
  WRITE: / 'O número total de registros é:', lv_total.

ELSE.
  MESSAGE 'Não foi encontrado nenhum registro' TYPE 'I'.
ENDIF.