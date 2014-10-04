from datetime import date

class Proposition(object):
    def __init__(self):
        self.id = 0
        self.year = 0
        self.number = 0
        self.amendment = ""
        self.explanation = ""
        self.presentation_date = date(year=1970, month=1, day=1)
        self.situation = ""
        self.content_link = ""
