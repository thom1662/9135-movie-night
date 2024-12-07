import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  String? deviceID;
  String? sessionID;

  void setDeviceID(String id) {
    deviceID = id;
    notifyListeners();
  }

    void setSessionID(String id) {
    sessionID = id;
    notifyListeners();
  }
  
}

//will need session id here too