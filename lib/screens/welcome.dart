import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_night_project/screens/code_screen.dart';
import 'package:movie_night_project/utils/app_provider.dart';
import 'package:provider/provider.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    initDeviceID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Movie Night")),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CodeScreen()));
                },
                child: const Text("Start"))
          ],
        )));
  }

  Future<void> initDeviceID() async {
    // Initialize the device ID
    String deviceID = await _fetchDeviceID();
    Provider.of<AppProvider>(context, listen: false).setDeviceID(deviceID);
    //fetch the api to get the device ID
  }

  Future<String> _fetchDeviceID() async {
    String deviceID;

    try {
      if (Platform.isAndroid) {
        const androidID = AndroidId();
        deviceID = await androidID.getId() ?? 'unknown android id';
      } else if (Platform.isIOS) {
        var iosID = DeviceInfoPlugin();
        var iosInfo = await iosID.iosInfo;
        deviceID = iosInfo.identifierForVendor ?? 'unknown ios id';
      } else {
        deviceID = 'unsupported platform';
      }
    } on Exception catch (e) {
      deviceID = 'error: $e';
    }
    if (kDebugMode){
      print('device id: $deviceID');
    }
    return deviceID;
  }
}
