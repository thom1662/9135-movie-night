import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_night_project/utils/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:movie_night_project/utils/http_helper.dart';
import 'package:movie_night_project/screens/movies_screen.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  String code = "unset";
  String sessionId = "unset";

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  void _startSession() async {
    //how to get device id from anywhere:
    String? deviceID = Provider.of<AppProvider>(context, listen: false).deviceID;

    final response = await HttpHelper.startSession(deviceID);
    setState(() {
      code = response['data']['code'];
      sessionId = response['data']['session_id'];
    });
    //set session in provider
      Provider.of<AppProvider>(context, listen: false).setSessionID(sessionId);

    if (kDebugMode) {
      print('code from start session: $code');
      print('session from start session: $sessionId');
    }
  }


  @override
  Widget build(BuildContext context) {
//put main scaffold on main.dart, title only here
    return Scaffold(
        appBar: AppBar(
          title: Text("your code"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("share this code: $code"),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MoviesScreen()));
                },
                child: const Text("Start selecting movies"),
              )
            ],
          ),
        ));
  }

}
