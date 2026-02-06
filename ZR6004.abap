*&---------------------------------------------------------------------*
*& Report ZR6004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR6004.

* para comentar a linha inteira utiliza-se o asterisco.
* para boas práticas, variável inicia-se com V_
* a constante inicia-se com C_

* Declaração de variáveis
DATA: V_DATA TYPE D,
      V_HORA TYPE T,
      V_NOME TYPE STRING.

* Declaração de constantes
CONSTANTS C_ANO(4) TYPE C VALUE '2014'.
* Dentro dos parenteses da constante significa a quantidade de posições
* Tipo da variável caracter (C) com valor 2014
* Não é possível alterar uma CONST

* Atribuindo valores a variáveis
V_DATA = '20140101'. "Formato americano"
V_HORA = '120000'.
V_NOME = 'JOSÉ DA SILVA'.

* Impressão de valores
WRITE: / 'Nome:', V_NOME.
WRITE: / 'Data:', V_DATA DD/MM/YYYY, "imprimindo no padrão brasileiro"
       / 'Hora:', V_HORA ENVIRONMENT TIME FORMAT,
       / 'Ano:', C_ANO.