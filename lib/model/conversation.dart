import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/ui/const.dart';

class Conversation {
  String? id;
  String? displayMessage;
  List? members;
  Timestamp? time;
  int? imageCount;
  String? name;
  String? profileImage;

  Conversation(
      {this.id,
      this.displayMessage,
      this.members,
      this.time,
      this.imageCount,
      this.name,
      this.profileImage});

  Conversation.fromFirestore(Map<String, dynamic> map)
      : this(
            id: map["id"],
            displayMessage: map["displayMessage"],
            members: map["members"],
            time: map["time"],
            imageCount: map["imageCount"]);

  String getProfileImage() =>
      profileImage == null ? defaultProfilePictureUrl : profileImage!;

  String getDisplayMessage() => displayMessage ?? "";

  int getImageCount() => imageCount ?? 0;

  String timeConverter() {
    DateTime dt = time!.toDate();
    Duration duration = DateTime.now().difference(dt);
    if (duration.inDays > 0) {
      String month = dt.month < 10 ? "0${dt.month}" : dt.month.toString();
      String day = dt.day < 10 ? "0${dt.day}" : dt.day.toString();
      return "$day/$month/${dt.year}";
    }
    String minute = dt.minute < 10 ? "0${dt.minute}" : dt.minute.toString();
    String hour = dt.hour < 10 ? "0${dt.hour}" : dt.hour.toString();
    return "$hour:$minute";
  }
}
