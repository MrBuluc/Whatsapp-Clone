// ignore_for_file: avoid_print
import 'package:http/http.dart' as http;

class API {
  String path;

  API({required this.path});

  Uri tokenUri() =>
      Uri(scheme: "http", host: "10.0.2.2", port: 8000, path: path);

  static Exception getError(Uri uri, http.Response response) {
    print("Request $uri failed\n"
        "Response: ${response.statusCode} ${response.body}");
    throw response;
  }
}
