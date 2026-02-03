REPORT ZR6003.

WRITE: / 'primeira linha'.
SKIP 1. "comando pula uma linha"
WRITE: / 'terceira linha'.
WRITE: / 'Fundo vermelho'. COLOR 6. "comando para utilizar cor no momento da impressão"
WRITE: / 'Letra vermelha'. COLOR 6 INVERSE. "comando INVERSE inverte a cor (pega a cor do fundo e coloca no texto)
ULINE. "comando imprime uma linha do início da tela até o final"
FORMAT COLOR 1. "comando informa que desse ponto para baixo toda a impressão será da cor definida"
WRITE: / 'Todo esse texto'.
WRITE: 'será impresso em'.
WRITE: 'AZUL'.
"os três textos acimas serão executados na mesma linha"
FORMAT RESET. "resetar a impressão da cor informada acima"

* COMANDO COLOR (COLOR BACKGROUND)
* COMANDO COLOR n INVERSE (COLOR TEXT)