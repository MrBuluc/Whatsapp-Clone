from fastapi import FastAPI, Body
from firebase_admin import credentials, firestore, initialize_app
from google.cloud.firestore import Increment
import uvicorn
from models import Message, User, Conversation
import json
from datetime import datetime, timedelta

app = FastAPI()


@app.get("/")
def root():
    return "Whatsapp Clone API"


@app.post("/send-message/{conversation_id}")
def send_message(conversation_id, body: str = Body()):
    message = Message.from_dict(json.loads(body))
    conversation_path = "Conversations"
    add(f"{conversation_path}/{conversation_id}/Messages", message.to_dict())
    conversation_update = {
        u'displayMessage': message.message, u'time': message.time}
    if message.media:
        conversation_update[u"imageCount"] = Increment(1)
    update(conversation_path, conversation_id, conversation_update)


@app.get("/time-now")
def get_time_now():
    return {"millisec_from_epoch": int((datetime.utcnow() + timedelta(hours=3) -
                                        datetime(1970, 1, 1)).total_seconds() * 1000)}


@app.get("/filter-users")
def filter_users(query: str, user_id: str):
    query = query.casefold()
    len_query = len(query)
    users = getUsers()
    filtered_users = []

    for user_dict in users:
        user = User.from_dict(user_dict.to_dict())
        if (user.id != user_id):
            if (user.name.casefold().find(query, 0, len_query) != -1):
                filtered_users.append(user.to_dict())
            elif (user.surname.casefold().find(query, 0, len_query) != -1):
                filtered_users.append(user.to_dict())

    return filtered_users


@app.post("/start-conversation")
def start_conversation(body: str = Body()):
    members = json.loads(body)
    conversation_id = members[0] + "-" + members[1]
    col_path = "Conversations"
    conversation = get(col_path, conversation_id)
    if conversation == None:
        conversation_id = members[1] + "-" + members[0]
        conversation = get(col_path, conversation_id)
        if conversation == None:
            conversation = Conversation()
            conversation.members = members
            conversation_id = members[0] + "-" + members[1]
            conversation.id = conversation_id
            set(col_path, conversation_id, conversation.to_dict())
    return conversation_id


def add(col_path, doc_dict):
    #update_time, doc_ref
    _, doc_ref = firestore.client().collection(col_path).add(doc_dict)
    return doc_ref


def set(col_path, doc_id, doc_dict):
    firestore.client().collection(col_path).document(doc_id).set(doc_dict)


def update(col_path, doc_id, update_fields):
    firestore.client().collection(col_path).document(doc_id).update(update_fields)


def getUsers():
    return firestore.client().collection(u"Users").stream()


def get(col_path, doc_id):
    return firestore.client().collection(col_path).document(doc_id).get().to_dict()


def initialize_firebase():
    initialize_app(credentials.Certificate(
        ".\secrets\whatsapp-clone-cb94e-firebase-adminsdk-bu22b-6c21d7bd1e.json"))


if __name__ == "__main__":
    initialize_firebase()
    uvicorn.run("views:app")
