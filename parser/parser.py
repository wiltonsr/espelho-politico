import threading
import sys
import xml.etree.ElementTree as ET
from datetime import date as _date
from time import sleep
from urllib2 import urlopen, URLError
from MySQLdb import connect, IntegrityError
from models.parliamentarian import Parliamentarian
from models.proposition_type import PropositionType
from models.proposition import Proposition

class Parser():
    def __init__(self):
        self.parliamentarians = []
        self.propositions = []
        self.proposition_type = []
        self.cursor = None
        self.connection = None


    def start_connection(self,db_host, db_name, db_user, db_pwd=''):
        self.connection = connect(db_host, db_user, db_pwd, db_name)

    def get_cursor(self):
        self.cursor = self.connection.cursor()

    def obtain_parliamentarians(self):
        parliamentarians_url = "http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDeputados"
        try:
            parliamentarians_et = ET.parse(urlopen(parliamentarians_url))
        except URLError:
            print "There was a problem when trying to open Parliamentarians list"
            return
        parliamentarian_root = parliamentarians_et.getroot()
        for parliamentarian_xml in parliamentarian_root:
            parliamentarian = self.extract_and_save_parliamentarian(parliamentarian_xml)

            self.obtain_all_propositions_from_parliamentarian(parliamentarian)

    def extract_and_save_parliamentarian(self, parliamentarian_xml):
        parliamentarian = self.xml_to_parliamentarian(parliamentarian_xml)
        self.save_parliamentarian(parliamentarian)
        self.parliamentarians.append(parliamentarian)

        return parliamentarian

    def xml_to_parliamentarian(self, parliamentarian_xml):
        parliamentarian = Parliamentarian()
        parliamentarian.id = self.extract_xml_text(parliamentarian_xml, 'ideCadastro')
        parliamentarian.registry = self.extract_xml_text(parliamentarian_xml, 'matricula')
        parliamentarian.condition = self.extract_xml_text(parliamentarian_xml, 'condicao')
        parliamentarian.name = self.extract_xml_text(parliamentarian_xml, 'nomeParlamentar')
        parliamentarian.photo_url = self.extract_xml_text(parliamentarian_xml, 'urlFoto')
        parliamentarian.state = self.extract_xml_text(parliamentarian_xml, 'uf')
        parliamentarian.party = self.extract_xml_text(parliamentarian_xml, 'partido')
        parliamentarian.telephone = self.extract_xml_text(parliamentarian_xml, 'fone')
        parliamentarian.email = self.extract_xml_text(parliamentarian_xml, 'email')
        parliamentarian.cabinet = self.extract_xml_text(parliamentarian_xml, 'gabinete')

        return parliamentarian

    def save_parliamentarian(self, parliamentarian):
        insert_parliamentarian = """
        insert into parliamentarians
            (id, name, registry, condition, photo_url, state, party, telephone, email, cabinet)
            values ("%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s")
            """ % (parliamentarian.id, parliamentarian.name, parliamentarian.registry, parliamentarian.condition,
                parliamentarian.photo_url, parliamentarian.state, parliamentarian.party, parliamentarian.telephone,
                parliamentarian.email, parliamentarian.cabinet)
        try:
            self.cursor.execute(insert_parliamentarian)
            self.connection.commit()
            print "Parliamentarian", parliamentarian.name, "saved"
        except IntegrityError:
            print "Parliamentarian", parliamentarian.name, "already recorded"
        print
        self.parliamentarians.append(parliamentarian)

    def obtain_proposition_types(self):
        proposition_types_url = "http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ListarSiglasTipoProposicao"
        try:
            proposition_types_et = ET.parse(urlopen(proposition_types_url))
        except URLError:
            print "There was a problem when trying to open Prosition Types list"
            print

        proposition_types_root = proposition_types_et.getroot()
        for proposition_type_xml in proposition_types_root:
            proposition_type = self.xml_to_proposition_type(proposition_type_xml)
            self.save_proposition_type(proposition_type)

    def xml_to_proposition_type(self, proposition_type_xml):
        proposition_type = PropositionType()
        proposition_type.acronym = proposition_type_xml.get('tipoSigla').strip()
        proposition_type.description = proposition_type_xml.get('descricao')

        return proposition_type

    def save_proposition_type(self, proposition_type):
        insert_proposition_type = """
            insert into proposition_types (acronym, description)
            values ('%s', '%s')
        """ % (proposition_type.acronym, proposition_type.description)

        try:
            self.cursor.execute(insert_proposition_type)
            self.connection.commit()
            print "Proposition Type saved"
        except IntegrityError:
            print "Proposition Type already recorded!"
            print

    def obtain_all_propositions_from_parliamentarian(self, parliamentarian):
        propositions_url = "http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ListarProposicoes?sigla=PL&numero=&ano=&datApresentacaoIni=&datApresentacaoFim=&parteNomeAutor=%s&idTipoAutor=&siglaPartidoAutor=&siglaUFAutor=&generoAutor=&codEstado=&codOrgaoEstado=&emTramitacao=" % (parliamentarian.remove_accents_from_name().replace(' ', '+'))
        try:
            propositions_et = ET.parse(urlopen(propositions_url))
        except URLError:
            print "There was a problem when trying to open Propositions list"
            print
        propositions_root = propositions_et.getroot()
        for proposition_elem in propositions_root:
            proposition_id = self.extract_xml_text(proposition_elem, 'id')
            specific_proposition_url = "http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ObterProposicaoPorID?idProp=%s" % proposition_id
            specific_proposition_et = ET.parse(urlopen(specific_proposition_url))
            specific_proposition_xml = specific_proposition_et.getroot()
            threading.start_new_thread(self.extract_and_save_proposition, (specific_proposition_xml, parliamentarian))
            sleep(3)

    def extract_and_save_proposition(self, proposition_xml, parliamentarian):
        proposition = self.extract_proposition_info(proposition_xml)
        self.save_proposition(proposition)

    def extract_proposition_info(self, proposition_xml):
        proposition = Proposition()
        proposition.number = self.extract_xml_text(proposition_xml, 'numero')
        proposition.year = self.extract_xml_text(proposition_xml, 'ano')
        proposition.id = self.extract_xml_text(proposition_xml, 'idProposicao')
        proposition.amendment = self.extract_xml_text(proposition_xml, 'Ementa')
        proposition.amendment = proposition.amendment.replace('"', '').replace("'", "")
        proposition.explanation = self.extract_xml_text(proposition_xml, 'ExplicacaoEmenta')
        proposition.explanation = proposition.explanation.replace('"', '').replace("'", "")
        date = self.extract_xml_text(proposition_xml, 'DataApresentacao')
        date = date.split('/')
        date = _date(int(date[2]), int(date[1]), int(date[0]))
        proposition.presentation_date = date.isoformat()
        proposition.situation = self.extract_xml_text(proposition_xml, 'Situacao')
        proposition.content_link = self.extract_xml_text(proposition_xml, 'LinkInteiroTeor')

        return proposition

    def recover_proposition_type_id(self, proposition_type_acronym):
        select_proposition_type_by_acronym = """
            select id from proposition_type where acronym like '%s'
        """ % (proposition_type_acronym)

        id = int(self.cursor.execute(select_proposition_type_by_acronym))

        return id

    def save_proposition(self, proposition):
        insert_proposition = """
            insert into propositions (id, year, number, amendment, explanation, presentation_date, situation, content_link)
            values ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')
        """ % (proposition.id, proposition.year, proposition.number, proposition.amendment, proposition.explanation,
               proposition.presentation_date, proposition.situation, proposition.content_link)

        try:
            self.cursor.execute(insert_proposition)
            self.connection.commit()
            print "Proposition saved"
        except IntegrityError:
            print "Proposition already recorded"
            print

    def extract_xml_text(self, xml, value):
        return xml.find(value).text

    def start_parser(self):
        try:
            self.start_connection(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
        except IndexError:
            self.start_connection(sys.argv[1], sys.argv[2], sys.argv[3])
        self.get_cursor()

        self.obtain_proposition_types()
        self.obtain_parliamentarians()
