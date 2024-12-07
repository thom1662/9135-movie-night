import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_night_project/utils/app_provider.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  @override
  void initState() {
    super.initState();
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