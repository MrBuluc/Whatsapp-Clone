from fastapi import FastAPI, Body
from firebase_admin import credentials, firestore, initialize_app
import uvicorn
from models import Message, User
import json
from datetime import datetime, timedelta
import pytz

app = FastAPI()


@app.get("/")
def root():
    return "Whatsapp Clone API"


@app.post("/send-message/{conversation_id}")
def send_message(conversation_id, body: str = Body()):
    message = Message.from_dict(json.loads(body))
    message.time = datetime.now(pytz.timezone("Asia/Istanbul"))
    conversation_path = "Conversations"
    add(f"{conversation_path}/{conversation_id}/Messages", message.to_dict())
    update(conversation_path, conversation_id, {
           u'displayMessage': message.message, u'time': message.time})


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


def add(coll_path, doc_dict):
    firestore.client().collection(coll_path).add(doc_dict)


def update(coll_path, doc_id, update_fields):
    firestore.client().collection(coll_path).document(doc_id).update(update_fields)


def getUsers():
    return firestore.client().collection(u"Users").stream()


def initialize_firebase():
    initialize_app(credentials.Certificate(
        ".\secrets\whatsapp-clone-cb94e-firebase-adminsdk-bu22b-6c21d7bd1e.json"))


if __name__ == "__main__":
    initialize_firebase()
    uvicorn.run("views:app")
