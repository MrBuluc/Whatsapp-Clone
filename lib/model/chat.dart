import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? message;
  String? name;
  Timestamp? time;

  Chat({this.message, this.name, this.time});

  Chat.fromFirestore(Map<String, dynamic> map)
      : this(message: map["message"], name: map["name"], time: map["time"]);

  String timeConverter() {
    DateTime dt = time!.toDate();
    Duration duration = DateTime.now().difference(dt);
    if (duration.inDays > 0) {
      String month = dt.month < 10 ? "0${dt.month}" : dt.month.toString();
      String day = dt.day < 10 ? "0${dt.day}" : dt.day.toString();
      return "$day/$month/${dt.year}";
    }
    return "${dt.hour}:${dt.minute}";
  }
}
