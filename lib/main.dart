import 'package:flutter/material.dart';
import 'package:movie_night_project/screens/welcome.dart';
import 'package:movie_night_project/utils/app_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(ChangeNotifierProvider(
    create: (context) => AppProvider(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'DMSans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: Brightness.light,
          ).primary,
          foregroundColor: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Movie Night"),
        ),
        body: const Welcome(),
      ),
    );
  }
}


//create provider for the device id so all views can access