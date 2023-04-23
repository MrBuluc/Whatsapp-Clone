class Message(object):
    def __init__(self):
        self.message = None
        self.sender_id = None
        self.time = None

    @staticmethod
    def from_dict(source):
        message = Message()

        if u'message' in source:
            message.message = source[u'message']
        if u'senderId' in source:
            message.sender_id = source[u'senderId']
        if u'time' in source:
            message.time = source[u'time']

        return message

    def to_dict(self):
        dest = {}

        if self.message:
            dest[u'message'] = self.message
        if self.sender_id:
            dest[u'senderId'] = self.sender_id
        if self.time:
            dest[u'time'] = self.time

        return dest
