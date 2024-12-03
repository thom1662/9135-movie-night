import 'package:flutter/material.dart';
import 'package:movie_night_project/utils/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:movie_night_project/utils/http_helper.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
String code = "unset";

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
        appBar: AppBar(
          title: Text("your code"),
        ),
        body: Center(
          child: Text("device code: $code"),
        ));
  }

  void _startSession() async {
    String? deviceID =
        Provider.of<AppProvider>(context, listen: false).deviceID;
    print('device id on share code screen: $deviceID');

    final response = await HttpHelper.startSession(deviceID);
    code = response['data']['code'];
    print('code from start session: $code');
    //need to put this into setState to update the code var on screen
  }
}
