from urllib2 import urlopen, HTTPError, URLError
import unicodedata
import subprocess
import sys
from time import sleep
import xml.etree.ElementTree as ET
from datetime import date
import MySQLdb
from MySQLdb import IntegrityError

db_name = str(sys.argv[1])

db_user = str(sys.argv[2])
try:
    db_pwd = str(sys.argv[3])
except IndexError:
    db_pwd = ''

db = MySQLdb.connect("localhost", db_user, db_pwd, db_name)
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


# Classe para proposicoes
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
        # Normaliza nome do parlamentar se nao tiver acentos
        return unicodedata.normalize('NFKD', unicode (nome, 'utf-8')).encode('ASCII', 'ignore')
    except TypeError:
        # Caso haja acentos, remove-os
        return unicodedata.normalize('NFKD', nome).encode('ASCII', 'ignore')

print "Obtendo os dados dos parlamentares"
url_parlamentares = 'http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDeputados'
xml_parlamentares = ET.parse(urlopen(url_parlamentares))
xml_parlamentares = xml_parlamentares.getroot()
parlamentares = []
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
    try:
        cursor.execute(insert_parlamentar_string)
        db.commit()
        print "Parlamentar", parlamentar.nome, "encontrad@"
    except IntegrityError:
        print "Parlamentar", parlamentar.nome, "ja cadastrado"
    print
    parlamentares.append(parlamentar)
    total_parlamentares += 1

print
print
print "Total de parlamentares:", total_parlamentares
proposicoes = []
print '-----------------------------------------------------------'
print

total_proposicoes = 0
tipos_pl = ['PL', 'PLC', 'PLN', 'PLP', 'PLS', 'PLV', 'EAG', 'EMA',
            'EMC', 'EMC-A', 'EMD', 'EML', 'EMO', 'EMP', 'EMPV',
            'EMR', 'EMRP', 'EMS', 'EPP', 'ERD', 'ERD-A', 'ESB',
            'ESP', 'PEC', 'PDS', 'PDN', 'PDC']
for parlamentar in parlamentares:
    print "Obtendo proposicoes d@ parlamentar", parlamentar.nome
    nome = remove_acentos(parlamentar.nome)
    for pl in tipos_pl:
        url_proposicoes = 'http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ListarProposicoes?sigla=%s&numero=&ano=&datApresentacaoIni=&datApresentacaoFim=&parteNomeAutor=%s&idTipoAutor=&siglaPartidoAutor=&siglaUFAutor=&generoAutor=&codEstado=&codOrgaoEstado=&emTramitacao=' % (pl, nome.replace(' ', '+'))
        try:
            xml_proposicoes = ET.parse(urlopen(url_proposicoes))
        except HTTPError:
            print "Parlamentar sem proposicao de", pl, ":'("
            print
            sleep(1)
            continue
        except URLError:
            print "Erro de conexao..."
            print "Prosseguindo..."
            print
            sleep(120)
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
                insert_proposicao_string = """
                    insert into proposicao
                    (id, numero, ano, ementa, explicacao, tema, parlamentar_id, data_apresentacao, situacao, link_teor)
                    values ("%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s")
                    """ % (proposicao.id_proposicao, proposicao.numero, proposicao.ano, proposicao.ementa,
                            proposicao.explicacao, proposicao.tema, proposicao.autor.id_cadastro, proposicao.data_apresentacao,
                            proposicao.situacao, proposicao.link_teor)
                try:
                    cursor.execute(insert_proposicao_string)
                    db.commit()
                except IntegrityError:
                    print "Proposicao '", proposicao.ementa, "' existente no banco de dados."

                num_proposicoes += 1
                total_proposicoes += 1
        if num_proposicoes > 0:
            print "Proposicoes de", pl, "d@ parlamentar", parlamentar.nome, "obtidas :D"
            print "Proposicoes de", pl, "encontradas:", num_proposicoes
            print
        else:
            print "Parlamentar sem proposicao de", pl ,":'("
            print
            sleep(1)
        sleep(2)

print
print
print "Total de proposicoes:", total_parlamentares
db.close()