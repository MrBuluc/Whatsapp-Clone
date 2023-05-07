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
      ? defaultConversationPictureUrl
      : conversationsPictureUrl!;

  String getProfileImage() =>
      pictureUrl == null ? defaultProfilePictureUrl : pictureUrl!;

  Map<String, dynamic> toFirestore() => {
        if (id != null) "id": id,
        if (name != null) "name": name,
        if (surname != null) "surname": surname,
        if (pictureUrl != null) userProfilePictureFieldName: pictureUrl,
        if (conversationsPictureUrl != null)
          userConversationsPictureFieldName: conversationsPictureUrl
      };
}
