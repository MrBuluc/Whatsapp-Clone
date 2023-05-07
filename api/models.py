class Message(object):
    def __init__(self):
        self.message = None
        self.sender_id = None
        self.time = None
        self.media = None

    @staticmethod
    def from_dict(source):
        message = Message()

        if u'message' in source:
            message.message = source[u'message']
        if u'senderId' in source:
            message.sender_id = source[u'senderId']
        if u'time' in source:
            message.time = source[u'time']
        if u'media' in source:
            message.media = source[u'media']
        return message

    def to_dict(self):
        dest = {}

        if self.message:
            dest[u'message'] = self.message
        if self.sender_id:
            dest[u'senderId'] = self.sender_id
        if self.time:
            dest[u'time'] = self.time
        if self.media:
            dest[u'media'] = self.media
        return dest


class User(object):
    def __init__(self):
        self.id = None
        self.name = None
        self.surname = None
        self.picture_url = None

    @staticmethod
    def from_dict(source):
        user = User()

        if u'id' in source:
            user.id = source[u"id"]
        if u"name" in source:
            user.name = source[u"name"]
        if u"surname" in source:
            user.surname = source[u"surname"]
        if u"pictureUrl" in source:
            user.picture_url = source[u"pictureUrl"]

        return user

    def to_dict(self):
        dest = {}

        if self.id:
            dest[u"id"] = self.id
        if self.name:
            dest[u"name"] = self.name
        if self.surname:
            dest[u"surname"] = self.surname
        if self.picture_url:
            dest[u"pictureUrl"] = self.picture_url

        return dest

    def get_username(self):
        return f"{self.name} {self.surname}"
