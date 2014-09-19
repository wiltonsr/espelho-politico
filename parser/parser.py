# -*- coding: utf-8 -*-

from urllib2 import urlopen, HTTPError
import unicodedata
# import os
from time import sleep
import xml.etree.ElementTree as ET

# Classe para parlamentar
class Parlamentar():
    def __init__(self):
        self.id_cadastro = 0
        self.matricula = 0
        self.condicao = ""
        self.nome_parlamentar = ""
        self.url_foto = ""
        self.uf = ""
        self.partido = ""
        self.telefone = ""
        self.email = ""
        self.gabinete = 0


# Classe para proposições
class Proposicao():
    def __init__(self):
        self.id_proposicao = 0
        self.ano = 0
        self.numero = 0
        self.ementa = ""
        self.explicacao = ""
        self.autor = Parlamentar()
        self.data_apresentacao = ""
        self.situacao = ""
        self.link_teor = ""


def remove_acentos(nome):
    try:
        # Normaliza nome do parlamentar se não tiver acentos
        return unicodedata.normalize('NFKD', unicode (nome, 'utf-8')).encode('ASCII', 'ignore')
    except TypeError:
        # Caso haja acentos, remove-os
        return unicodedata.normalize('NFKD', nome).encode('ASCII', 'ignore')

print "Obtendo os dados dos parlamentares"
url_parlamentares = 'http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDeputados'
xml_parlamentares = ET.parse(urlopen(url_parlamentares))
xml_parlamentares = xml_parlamentares.getroot()
parlamentares = []
for xml_parlamentar in xml_parlamentares:
    parlamentar = Parlamentar()
    parlamentar.nome = xml_parlamentar.find('nomeParlamentar').text
    parlamentar.id_cadastro = xml_parlamentar.find('ideCadastro').text
    parlamentar.matricula = xml_parlamentar.find('matricula').text
    parlamentar.condicao = xml_parlamentar.find('condicao').text
    parlamentar.url_foto = xml_parlamentar.find('urlFoto').text
    parlamentar.uf = xml_parlamentar.find('uf').text
    parlamentar.partido = xml_parlamentar.find('partido').text
    parlamentar.telefone = xml_parlamentar.find('fone').text
    parlamentar.email = xml_parlamentar.find('email').text
    parlamentar.gabinete = xml_parlamentar.find('gabinete').text

    print "Parlamentar", parlamentar.nome, "encontrad@"
    print
    parlamentares.append(parlamentar)

proposicoes = []
print '-----------------------------------------------------------'
print
for parlamentar in parlamentares:
    print "Obtendo proposições d@ parlamentar", parlamentar.nome
    nome = remove_acentos(parlamentar.nome)
    url_proposicoes = 'http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ListarProposicoes?sigla=PL&numero=&ano=&datApresentacaoIni=&datApresentacaoFim=&parteNomeAutor=%s&idTipoAutor=&siglaPartidoAutor=&siglaUFAutor=&generoAutor=&codEstado=&codOrgaoEstado=&emTramitacao=' % nome.replace(' ', '+')
    try:
        xml_proposicoes = ET.parse(urlopen(url_proposicoes))
    except HTTPError:
        print "Parlamentar sem proposição de PL :'("
        print
        sleep(1)
        continue
    proposicoes = xml_proposicoes.getroot()
    num_proposicoes = 0
    for proposicao in proposicoes:
        url_proposicao = 'http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ObterProposicaoPorID?IdProp=%s' % proposicao.find('id').text
        xml_proposicao = ET.parse(urlopen(url_proposicao))
        root_proposicao = xml_proposicao.getroot()
        nome_autor1 = root_proposicao.find('Autor').text
        if cmp(nome_autor1.upper(), parlamentar.nome) != 0:
            proposicao = Proposicao()
            proposicao.numero = root_proposicao.attrib.get('numero')
            proposicao.ano = root_proposicao.attrib.get('ano')
            proposicao.id_proposicao = int(root_proposicao.find('idProposicao').text)
            proposicao.ementa = root_proposicao.find('Ementa').text
            proposicao.explicacao = root_proposicao.find('ExplicacaoEmenta').text
            proposicao.autor = parlamentar
            proposicao.data_apresentacao = root_proposicao.find('DataApresentacao').text
            proposicao.situacao = root_proposicao.find('Situacao').text
            proposicao.link_teor = root_proposicao.find('LinkInteiroTeor').text
            num_proposicoes += 1
    if num_proposicoes > 0:
        print "Proposições de PL d@ parlamentar", parlamentar.nome, "obtidas :D"
        print "Proposições de PL encontradas:", num_proposicoes
        print
    else:
        print "Parlamentar sem proposição de PL :'("
        print
        sleep(1)


