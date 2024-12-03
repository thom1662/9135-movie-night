import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpHelper {
  static String movieNightBaseUrl = 'https://movie-night-api.onrender.com';


  static startSession(String? deviceID) async {
    String uri =
        '$movieNightBaseUrl/start-session?device_id=$deviceID';
    var response = await http.get(Uri.parse(uri));

    return jsonDecode(response.body);
  }
}
