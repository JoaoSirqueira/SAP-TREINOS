*&---------------------------------------------------------------------*
*& Report ZR6024
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

*🥈 Exercício 2 – Tabela Interna + LOOP
*
*Crie um REPORT que:
*
*Declare uma tabela interna com:
*
*nome (string)
*
*idade (i)
*
*Insira manualmente 5 registros
*
*Faça um LOOP
*
*Mostre apenas pessoas com idade maior que 18
*
*Mostre no final quantas pessoas eram maiores de idade
*
*⚠ Não usar SELECT ainda
*⚠ Não usar ALV ainda
*⚠ Faça só com WRITE

REPORT zr6024.

TYPES: BEGIN OF ty_pessoa,
         nome  TYPE string,
         idade TYPE i,
       END OF ty_pessoa.

DATA: t_pessoa TYPE TABLE OF ty_pessoa.

DATA: wa_pessoa TYPE ty_pessoa.

DATA: v_contag TYPE i.

APPEND VALUE ty_pessoa( nome = 'João' idade = 18 ) TO t_pessoa.
APPEND VALUE ty_pessoa( nome = 'Jesus' idade = 33 ) TO t_pessoa.
APPEND VALUE ty_pessoa( nome = 'José' idade = 58 ) TO t_pessoa.
APPEND VALUE ty_pessoa( nome = 'Maria' idade = 56 ) TO t_pessoa.
APPEND VALUE ty_pessoa( nome = 'Matusalém' idade = 969 ) TO t_pessoa.
APPEND VALUE ty_pessoa( nome = 'Karl Heinz Rummenigge' idade = 17 ) TO t_pessoa.

LOOP AT t_pessoa INTO wa_pessoa.

  IF wa_pessoa-idade > 18.
    WRITE: / wa_pessoa-nome, wa_pessoa-idade.
    v_contag = v_contag + 1.
  ENDIF.

ENDLOOP.

WRITE: / 'Total de pessoas maiores de 18 anos: ', v_contag.