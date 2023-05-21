import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:whatsapp_clone/services/api_services/api.dart';

class ConversationApi {
  Future<String> startConversation(List<String> members) async {
    Uri uri = API(path: "start-conversation").tokenUri();
    http.Response response = await http.post(uri, body: jsonEncode(members));
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    throw API.getError(uri, response);
  }
}
