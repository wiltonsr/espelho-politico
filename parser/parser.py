import sys
import xml.etree.ElementTree as ET
from urllib2 import urlopen, HTTPError, URLError
from MySQLdb import connect#, IntegrityError
from models.parliamentarian import Parliamentarian

class Parser():

    def __init__(self):
        self.parliamentarians = []
        self.propositions = []
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
            parliamentarian = self.extract_parliamentarian_info(parliamentarian_xml)
            self.parliamentarians.append(parliamentarian)

    def extract_parliamentarian_info(self, parliamentarian_xml):
        parliamentarian = Parliamentarian()
        parliamentarian.id = int(self.extract_xml_text(parliamentarian_xml, 'ideCadastro'))
        parliamentarian.registration_number = int(self.extract_xml_text(parliamentarian_xml, 'matricula'))

        return parliamentarian

    def extract_xml_text(self, xml, value):
        return xml.find(value).text

    def start_parser(self):
        try:
            self.start_connection(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
        except IndexError:
            self.start_connection(sys.argv[1], sys.argv[2], sys.argv[3])

            self.get_cursor()

            self.obtain_parliamentarians()
