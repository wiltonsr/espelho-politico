# -*- coding: utf-8 -*-

import urllib2
import unicodedata
import os
from time import sleep
import xml.etree.ElementTree as ET

class Deputado():
    def __init__(self):
        self.id = 0
        self.matricula = 0
        self.condicao = ""
        self.nome_parlamentar = ""
        self.url_foto = ""
        self.uf = ""
        self.partido = ""
        self.telefone = ""
        self.email = ""
        self.gabinete = 0


class Proposicao():
    def __init__(self):
        self.id = 0
        self.ano = 0
        self.numero = 0
        self.ementa = ""
        self.explicacao = ""
        self.autor = Deputado()
        self.data_apresentacao = ""
        self.situacao = ""
        self.link_teor = ""


def remove_acentos(nome):
    return unicodedata.normalize('NFKD', unicode (nome, 'utf-8')).encode('ASCII', 'ignore')

url_deputados = 'http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDeputados'
xml_deputados = ET.parse(urllib2.urlopen(url_deputados))
deputados = xml_deputados.getroot()
nome_deputados = []
print "Obtendo os dados dos parlamentares"
for deputado in deputados:
    sleep(1)
    nome = deputado.find('nomeParlamentar').text
    print "Parlamentear", nome, "encontrado"
    nome_deputados.append(nome)

proposicoes = []
for deputado in nome_deputados:
    print "Obtendo proposições do parlamentar", deputado
    deputado = remove_acentos(deputado)
    url_proposicoes = 'http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ListarProposicoes?sigla=PL&numero=&ano=2011&datApresentacaoIni=&datApresentacaoFim=&parteNomeAutor=&idTipoAutor=&siglaPartidoAutor=&siglaUFAutor=&generoAutor=&codEstado=&codOrgaoEstado=&emTramitacao='
    xml_proposicoes = ET.parse(urllib2.urlopen(url_proposicoes))
    proposicoes = xml_proposicoes.getroot()
    for proposicao in proposicoes:
        url_proposicao = 'http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ObterProposicaoPorID?IdProp=%s' % proposicao.find('id').text
        xml_proposicao = ET.parse(urllib2.urlopen(url_proposicao))
        proposicao = xml_proposicao.getroot()
