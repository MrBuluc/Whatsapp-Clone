import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? message;
  String? senderId;
  Timestamp? time;

  Message({this.message, this.senderId, this.time});

  Message.fromFirestore(Map<String, dynamic> map)
      : this(
            message: map["message"],
            senderId: map["senderId"],
            time: map["time"]);

  Map<String, dynamic> toFirestore() => {
        if (message != null) "message": message,
        if (senderId != null) "senderId": senderId,
        if (time != null) "time": time
      };
}
