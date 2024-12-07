import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_night_project/utils/app_provider.dart';
import 'package:movie_night_project/utils/http_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_night_project/config.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  List<Map<String, dynamic>> _movies = [];
  // int _currentIndex = 0;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _fetchMovieList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logSessionAndDeviceID();
    });
  }

  void _logSessionAndDeviceID() {
    String? deviceID =
        Provider.of<AppProvider>(context, listen: false).deviceID;
    String? sessionID =
        Provider.of<AppProvider>(context, listen: false).sessionID;

    if (deviceID != null && sessionID != null) {
      debugPrint('Device ID movie page: $deviceID');
      debugPrint('Session ID movie page: $sessionID');
    } else {
      debugPrint('Device ID or Session ID is not set');
    }
  }

  _fetchMovieList() async {
    String? key = Config.apiKey;
    String movieDBBaseUrl = 'https://api.themoviedb.org/3/movie';
    String uri =
        '$movieDBBaseUrl/now_playing?language=en-US&page=$_page&api_key=$key';

    try {
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _movies.addAll(List<Map<String, dynamic>>.from(data['results']));
        });
        if (kDebugMode) {
          print('Movies array: $_movies');
        }
      } else {
        throw Exception('Failed to fetch movies: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch movies: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Night"),
      ),
      body: Center(
        child: Text("Movies go here"),
      ),
    );
  }
}

//have session and device id here