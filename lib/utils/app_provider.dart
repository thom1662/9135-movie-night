import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  String? deviceID;

  void setDeviceID(String id) {
    deviceID = id;
    notifyListeners();
  }
}

//will need session id ??