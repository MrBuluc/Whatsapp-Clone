import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? message;
  String? senderId;
  Timestamp? time;
  String? media;

  Message({this.message, this.senderId, this.time, this.media});

  Message.fromFirestore(Map<String, dynamic> map)
      : this(
            message: map["message"],
            senderId: map["senderId"],
            time: map["time"],
            media: map["media"]);

  Map<String, dynamic> toFirestore() => {
        if (message != null) "message": message,
        if (senderId != null) "senderId": senderId,
        if (time != null) "time": time,
        if (media != null) "media": media
      };
}
