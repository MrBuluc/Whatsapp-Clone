import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String? id;
  String? displayMessage;
  List? members;
  Timestamp? time;
  String? name;
  String? profileImage;
  String? wallpaperUrl;

  Conversation({this.id, this.displayMessage, this.members, this.time});

  Conversation.fromFirestore(Map<String, dynamic> map)
      : this(
            id: map["id"],
            displayMessage: map["displayMessage"],
            members: map["members"],
            time: map["time"]);

  String getProfileImage() => profileImage == null
      ? "https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto,q_auto,f_auto/gigs/128009228/original/8e8ad34b012b46ebd403bd4157f8fef6bb2c076b/design-minimalist-flat-cartoon-caricature-avatar-in-6-hours.jpg"
      : profileImage!;

  String getWallpaperUrl() => wallpaperUrl == null
      ? "https://i.pinimg.com/originals/52/e5/6f/52e56fb927b170294ccc035f02c6477d.jpg"
      : wallpaperUrl!;

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
