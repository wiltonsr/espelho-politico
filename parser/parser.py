# -*- coding: utf-8 -*-

from urllib2 import urlopen, HTTPError
import unicodedata
import subprocess
import sys
from time import sleep
import xml.etree.ElementTree as ET
from datetime import date
import MySQLdb

db_user = str(sys.argv[1])
try:
    db_pwd = str(sys.argv[2])
except IndexError:
    db_pwd = ''

if db_pwd != '':
    create_db_string = "mysql -u %s -p%s -e 'CREATE DATABASE IF NOT EXISTS espelho_politico'" % (db_user, db_pwd)
else:
    create_db_string = "mysql -u %s -e 'CREATE DATABASE IF NOT EXISTS espelho_politico'" % (db_user)

db = MySQLdb.connect("localhost", db_user, db_pwd, "espelho_politico")
cursor = db.cursor()

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
        self.tema = ""
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

print "Criando base de dados espelho_politico..."
sleep(1)
subprocess.call(create_db_string, shell=True)

print "Obtendo os dados dos parlamentares"
url_parlamentares = 'http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDeputados'
xml_parlamentares = ET.parse(urlopen(url_parlamentares))
xml_parlamentares = xml_parlamentares.getroot()
parlamentares = []
drop_table_string = "DROP TABLE IF EXISTS proposicao;"
cursor.execute(drop_table_string)
db.commit()
drop_table_string = "DROP TABLE IF EXISTS parlamentar;"
cursor.execute(drop_table_string)
db.commit()
create_table_string = """
CREATE TABLE parlamentar (
id int not null primary key,
nome varchar(255),
matricula int,
condicao varchar(255),
url_foto varchar(400),
uf varchar(2),
partido varchar(20),
telefone varchar(20),
email varchar(100),
gabinete int
);"""
cursor.execute(create_table_string)
db.commit()
total_parlamentares = 0
for xml_parlamentar in xml_parlamentares:
    parlamentar = Parlamentar()
    parlamentar.nome = xml_parlamentar.find('nomeParlamentar').text
    parlamentar.id_cadastro = int(xml_parlamentar.find('ideCadastro').text)
    parlamentar.matricula = int(xml_parlamentar.find('matricula').text)
    parlamentar.condicao = xml_parlamentar.find('condicao').text
    parlamentar.url_foto = xml_parlamentar.find('urlFoto').text
    parlamentar.uf = xml_parlamentar.find('uf').text
    parlamentar.partido = xml_parlamentar.find('partido').text
    parlamentar.telefone = xml_parlamentar.find('fone').text
    parlamentar.email = xml_parlamentar.find('email').text
    parlamentar.gabinete = int(xml_parlamentar.find('gabinete').text)
    insert_parlamentar_string = """
    insert into parlamentar
    (id, nome, matricula, condicao, url_foto, uf, partido, telefone, email, gabinete)
    values ("%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s")
    """ % (parlamentar.id_cadastro, parlamentar.nome, parlamentar.matricula, parlamentar.condicao,
           parlamentar.url_foto, parlamentar.uf, parlamentar.partido, parlamentar.telefone,
           parlamentar.email, parlamentar.gabinete)

    cursor.execute(insert_parlamentar_string)
    db.commit()
    print "Parlamentar", parlamentar.nome, "encontrad@"
    print
    parlamentares.append(parlamentar)
    total_parlamentares += 1

print
print
print "Total de parlamentares:", total_parlamentares
proposicoes = []
print '-----------------------------------------------------------'
print

create_table_string = """
CREATE TABLE proposicao (
id int not null primary key,
numero int,
ano int,
ementa varchar(255),
explicacao varchar(1000),
tema varchar(255),
id_autor int not null,
data_apresentacao date,
situacao varchar(255),
link_teor varchar(100),
constraint FK_proposicao_id_autor foreign key(id_autor) references parlamentar(id)
);"""
cursor.execute(create_table_string)
db.commit()
total_proposicoes = 0
for parlamentar in parlamentares:
    print "Obtendo proposições d@ parlamentar", parlamentar.nome
    nome = remove_acentos(parlamentar.nome)
    for pl in ['PL', 'PLC', 'PLN', 'PLP', 'PLS', 'PLV']:
        url_proposicoes = 'http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ListarProposicoes?sigla=%s&numero=&ano=&datApresentacaoIni=&datApresentacaoFim=&parteNomeAutor=%s&idTipoAutor=&siglaPartidoAutor=&siglaUFAutor=&generoAutor=&codEstado=&codOrgaoEstado=&emTramitacao=' % (pl, nome.replace(' ', '+'))
        try:
            xml_proposicoes = ET.parse(urlopen(url_proposicoes))
        except HTTPError:
            print "Parlamentar sem proposição de", pl, ":'("
            print
            sleep(1)
            continue
        num_proposicoes = 0
        proposicoes = xml_proposicoes.getroot()
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
                proposicao.ementa = proposicao.ementa.replace('"', '').replace("'", "")
                proposicao.explicacao = root_proposicao.find('ExplicacaoEmenta').text
                proposicao.explicacao = proposicao.explicacao.replace('"', '').replace("'", "")
                proposicao.tema = root_proposicao.find('tema').text
                proposicao.autor = parlamentar
                data = root_proposicao.find('DataApresentacao').text
                data = data.split('/')
                data = date(int(data[2]), int(data[1]), int(data[0]))
                proposicao.data_apresentacao = data.isoformat()
                proposicao.situacao = root_proposicao.find('Situacao').text
                proposicao.link_teor = root_proposicao.find('LinkInteiroTeor').text
                insert_parlamentar_string = """
                    insert into proposicao
                    (id, numero, ano, ementa, explicacao, tema, id_autor, data_apresentacao, situacao, link_teor)
                    values ("%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s")
                    """ % (proposicao.id_proposicao, proposicao.numero, proposicao.ano, proposicao.ementa,
                            proposicao.explicacao, proposicao.tema, proposicao.autor.id_cadastro, proposicao.data_apresentacao,
                            proposicao.situacao, proposicao.link_teor)

                cursor.execute(insert_parlamentar_string)
                db.commit()

                num_proposicoes += 1
                total_proposicoes += 1
        if num_proposicoes > 0:
            print "Proposições de", pl, "d@ parlamentar", parlamentar.nome, "obtidas :D"
            print "Proposições de", pl, "encontradas:", num_proposicoes
            print
        else:
            print "Parlamentar sem proposição de", pl ,":'("
            print
            sleep(1)

print
print
print "Total de proposições:", total_parlamentares
db.close()
