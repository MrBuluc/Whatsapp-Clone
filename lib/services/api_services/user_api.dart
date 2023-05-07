import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/services/api_services/api.dart';

class UserApi {
  Future<List> getFilteredUsersList(String? query, String userId) async {
    Uri uri = API(
        path: "filter-users",
        queryParameters: {"query": query, "user_id": userId}).tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    throw API.getError(uri, response);
  }

  Future<List<User>> getFilteredUsers(String? query, String userId) async {
    List filteredUsersList = await getFilteredUsersList(query, userId);
    List<User> filteredUsers = [];
    for (Map<String, dynamic> userMap in filteredUsersList) {
      filteredUsers.add(User.fromFirestore(userMap));
    }
    return filteredUsers;
  }
}
