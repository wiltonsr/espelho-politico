# language: pt
Funcionalidade: Ranking de temas
  Como usuário
  Desejo visualizar a quantidade de proposições do tema por parlamentar
  Para que seja possível saber qual parlamentar possui mais proposições naquele tema

  @selenium
  Cenário: Ao entrar na página inicial, clico em Rankings
    Dado que estou na página inicial
    Quando clico no menu "Rankings"
    Então eu vejo na tela "Ranking Área de Investimento x Parlamentares"
