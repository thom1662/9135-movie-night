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
  }

  @override
  void dispose() {
    super.dispose();
    _clearMovies();
  }

  void _clearMovies() {
    _movies.clear();
    _currentIndex = 0;
    _page = 1;
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
      // print(response);

      if (response['data']['match'] == true &&
          response['data']['num_devices'] > 1) {
        int matchedMovieId = int.parse(response['data']['movie_id'].toString());
        _showMatchDialog(matchedMovieId);
      } else {
        _showNextMovie();
      }
    } catch (e) {
      debugPrint('Failed to vote movie: $e');
    }
  }

  void _showMatchDialog(int movieId) {
    final currentMovie = _movies[_currentIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Match Found!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentMovie['poster_path'] != null)
              Image.network(
                'https://image.tmdb.org/t/p/w500${currentMovie['poster_path']}',
                width: 250,
              )
            else
              Image.asset('assets/images/default_poster.png', width: 250),
            const SizedBox(height: 16),
            Text(currentMovie['title'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('Back Home',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
      ),
    );
  }

  void _showNextMovie() {
    if (mounted) {
      if (_currentIndex >= _movies.length - 1) {
        //fetch next movies at index 19
        _fetchMovieList().then((_) {
          setState(() {
            _currentIndex++;
          });
        });
      } else {
        setState(() {
          _currentIndex++;
        });
      }
    }
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
        title: const Text("Currently in Theatres"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
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
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.thumb_up,
                      color: Colors.green,
                      size: 60,
                    ),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.thumb_down,
                      color: Colors.red,
                      size: 60,
                    ),
                  ),
                  child: Card(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          if (currentMovie['poster_path'] != null)
                            Image.network(
                              'https://image.tmdb.org/t/p/w500${currentMovie['poster_path']}',
                              width: 250,
                            )
                          else
                            Image.asset('assets/images/default_poster.png',
                                width: 250),
                          const SizedBox(height: 16),
                          Text(currentMovie['title'],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary)),
                          Text('Release Date: ${currentMovie['release_date']}',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary)),
                          Text(
                              'Rating: ${currentMovie['vote_average'].toStringAsFixed(1)}',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary)),
                        ],
                      ),
                    ),
                  ))),
        ],
      ),
    );
  }
}
