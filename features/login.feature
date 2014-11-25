# language: pt
Funcionalidade: Fazer login
  Como usuário
  Desejo fazer login com uma conta de usuario
  Para que seja possível fazer login e ter acesso as funcionalidades do site

  @selenium
  Cenário: Na página de login, crio um novo usuario e logo
    Dado que estou na página inicial
    Quando clico no menu "Entrar"
    Então eu vejo na tela "Entrar"
    Quando clico no menu "Criar uma conta"
    Então eu digito "usuario" no campo "user_name"
    E eu digito "usuario2@email.com" no campo "user_email"
    E eu digito "usuario" no campo "user_username"
    E eu digito "password" no campo "user_password"
    E eu digito "password" no campo "user_password_confirmation"
    Então clico no botão "Criar usuário"
    Então eu vejo na tela "Entendendo o projeto Espelho Político"
    Então eu clico no menu "Entrar"
    E eu digito "usuario" no campo "username"
    E eu digito "password" no campo "password"
    Então eu vejo na tela "Logado com sucesso"