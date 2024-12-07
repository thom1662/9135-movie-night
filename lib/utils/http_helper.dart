import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpHelper {
  static String movieNightBaseUrl = 'https://movie-night-api.onrender.com';

  static startSession(String? deviceID) async {
    String uri = '$movieNightBaseUrl/start-session?device_id=$deviceID';

    var response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to start session: ${response.reasonPhrase}');
    }
  }

  static joinSession(String? deviceID, int? code) async {
    String uri =
        '$movieNightBaseUrl/join-session?device_id=$deviceID&code=$code';

    var response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to join session: ${response.reasonPhrase}');
    }
  }

//not sure about this one
  static voteMovie(String? sessionId, int movieId, bool vote) async {
    String uri =
        '$movieNightBaseUrl/vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$vote';

    var response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to vote movie: ${response.reasonPhrase}');
    }
  }

}
