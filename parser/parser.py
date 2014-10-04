import sys
import xml.etree.ElementTree as ET
from urllib2 import urlopen, HTTPError, URLError
from MySQLdb import connect, IntegrityError
from models.parliamentarian import Parliamentarian
from models.proposition_type import PropositionType

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
            parliamentarian = self.xml_to_parliamentarian(parliamentarian_xml)
            self.parliamentarians.append(parliamentarian)

    def xml_to_parliamentarian(self, parliamentarian_xml):
        parliamentarian = Parliamentarian()
        parliamentarian.id = int(self.extract_xml_text(parliamentarian_xml, 'ideCadastro'))
        parliamentarian.registry = int(self.extract_xml_text(parliamentarian_xml, 'matricula'))
        parliamentarian.condition = self.extract_xml_text(parliamentarian_xml, 'condicao')
        parliamentarian.name = self.extract_xml_text(parliamentarian_xml, 'nomeparliamentarian')
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
            print "Parliamentarian", parliamentarian.name, "found"
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

    def xml_to_proposition_type(self, proposition_type_xml):
        proposition_type = PropositionType()
        proposition_type.acronym = self.extract_xml_text(proposition_type_xml, 'sigla')
        proposition_type.description = self.extract_xml_text(proposition_type_xml, 'descricao')

        return proposition_type

    def extract_xml_text(self, xml, value):
        return xml.find(value).text

    def start_parser(self):
        try:
            self.start_connection(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
        except IndexError:
            self.start_connection(sys.argv[1], sys.argv[2], sys.argv[3])
            self.get_cursor()

            self.obtain_parliamentarians()
