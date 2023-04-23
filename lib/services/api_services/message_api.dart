import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:whatsapp_clone/services/api_services/api.dart';

class MessageApi {
  Future<bool> sendMessage(
      String conversationId, Map<String, dynamic> messageMap) async {
    Uri uri = API(path: "send-message/$conversationId").tokenUri();
    http.Response response = await http.post(uri, body: jsonEncode(messageMap));
    if (response.statusCode == 200) {
      return true;
    }
    throw API.getError(uri, response);
  }
}
