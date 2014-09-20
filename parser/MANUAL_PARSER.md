Manual do Parser
====================

	O script parser serve para fazer requisições no site www.camara.leg.br com o nome do parlamentar e proposições.
A cada requisição o parser irá baixar arquivos de extenção XML. Dois objetos (parlamentar e proposição) são instanciados com as informações extraidas das requisições. Por fim o banco é criado e esse objetos são persistidos no banco.

### Instruções de Instalação na plataforma Debian/Ubuntu
* apt-get install python-devel