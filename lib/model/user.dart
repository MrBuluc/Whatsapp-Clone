import 'package:whatsapp_clone/ui/const.dart';

class User {
  String? id;
  String? name;
  String? surname;
  String? pictureUrl;
  String? conversationsPictureUrl;

  User(
      {this.id,
      this.name,
      this.surname,
      this.pictureUrl,
      this.conversationsPictureUrl});

  User.fromFirestore(Map<String, dynamic> map)
      : this(
            id: map["id"],
            name: map["name"],
            surname: map["surname"],
            pictureUrl: map[userProfilePictureFieldName],
            conversationsPictureUrl: map[userConversationsPictureFieldName]);

  String get username => "${name!} ${surname!}";

  String getConversationsPictureUrl() => conversationsPictureUrl == null
      ? "https://i.pinimg.com/originals/52/e5/6f/52e56fb927b170294ccc035f02c6477d.jpg"
      : conversationsPictureUrl!;

  Map<String, dynamic> toFirestore() => {
        if (id != null) "id": id,
        if (name != null) "name": name,
        if (surname != null) "surname": surname,
        if (pictureUrl != null) userProfilePictureFieldName: pictureUrl,
        if (conversationsPictureUrl != null)
          userConversationsPictureFieldName: conversationsPictureUrl
      };
}
