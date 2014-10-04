from unicodedata import normalize
class Parliamentarian(object):
    def __init__(self):
        self.id = 0
        self.registry = 0
        self.condition = ""
        self.name = ""
        self.photo_url = ""
        self.state = ""
        self.party = ""
        self.telephone = ""
        self.email = ""
        self.cabinet = ""

    def remove_accents_from_name(self):
        try:
            return normalize('NFKD', self.name).encode('ASCII', 'ignore')
        except TypeError:
            return normalize('NFKD', unicode(self.name, 'utf-8')).encode('ASCII', 'ignore')

