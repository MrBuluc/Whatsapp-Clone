import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:whatsapp_clone/services/api_services/api.dart';

class TimeApi {
  Future<String> getCurrentTimeFromEpoch() async {
    Uri uri = API(path: "time-now").tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes))["millisec_from_epoch"]
          .toString();
    }
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
