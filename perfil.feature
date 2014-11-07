# language: pt
Funcionalidade: Busca de Parlamentares
  Como usuário
  Desejo procurar um parlamentar pelo nome
  Para que seja possível saber mais informações e os dados de um determinado parlamentar

  @selenium
  Cenário: Ao entrar na página inicial, clico em Perfil do Parlamentar
    Dado que estou na página inicial
    Quando clico no menu "Perfil do Parlamentar"
    Então eu vejo na tela "Perfil do Parlamentar"
