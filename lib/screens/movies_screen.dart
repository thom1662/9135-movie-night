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
  final List<Map<String, dynamic>> _movies = [];
  int _currentIndex = 0;
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
          _page++; //increment the page for next fetch
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

  _voteMovie(int movieId, bool vote) async {
    String? sessionId =
        Provider.of<AppProvider>(context, listen: false).sessionID;
    try {
      final response = await HttpHelper.voteMovie(sessionId, movieId, vote);
      if (response['match'] == true) {
        _showMatchDialog(response['movie_id']);
      } else {
        _showNextMovie();
      }
    } catch (e) {
      debugPrint('Failed to vote movie: $e');
    }
  }

  void _showMatchDialog(int movieId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Match Found!'),
        content: Text('Your movie match: $movieId'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showNextMovie() {
    setState(() {
      _currentIndex++;
      if (_currentIndex >= _movies.length) {
        _fetchMovieList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_movies.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Movie Night"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentMovie = _movies[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Night"),
      ),
      body: Center(
          child: Dismissible(
              key: Key(currentMovie['id'].toString()),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                bool vote;
                if (direction == DismissDirection.startToEnd) {
                  vote = true; // Swiped right
                } else if (direction == DismissDirection.endToStart) {
                  vote = false; // Swiped left
                } else {
                  vote =
                      false; // just in case, should not happen in horizontal direction
                }
                _voteMovie(currentMovie['id'], vote);
              },
              background: Container(
                color: Colors.green,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.thumb_up, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.thumb_down, color: Colors.white),
              ),
              child: Card(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                        'https://image.tmdb.org/t/p/w185${currentMovie['poster_path']}'),
                    ListTile(
                      title: Text(currentMovie['title']),
                      // subtitle: Text(currentMovie['overview']),
                    ),
                    Text('Release Date: ${currentMovie['release_date']}'),
                    Text('Rating: ${currentMovie['vote_average']}'),
                  ],
                ),
              ))),
    );
  }
}

//have session and device id here