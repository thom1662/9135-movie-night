import 'package:flutter/material.dart';
import 'package:movie_night_project/screens/welcome.dart';
import 'package:movie_night_project/utils/app_provider.dart';
import 'package:provider/provider.dart';

void main() {
  // runApp(const MainApp());
  runApp(ChangeNotifierProvider(
    create: (context) => AppProvider(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Welcome(),
        ),
      ),
    );
  }
}


//create provider for the device id so all views can access