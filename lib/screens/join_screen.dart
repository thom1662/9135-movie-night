import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_night_project/utils/http_helper.dart';
import 'package:provider/provider.dart';
import 'package:movie_night_project/utils/app_provider.dart';
import 'package:movie_night_project/screens/movies_screen.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController _codeController = TextEditingController();

//called by button press
  void _joinSession() async {
    String codeInput = _codeController.text;
    int code = int.parse(codeInput);
    String? deviceID =
        Provider.of<AppProvider>(context, listen: false).deviceID;

    try {
      final response = await HttpHelper.joinSession(deviceID, code);
      String sessionId = response['data']['session_id'];
//save session id to provider
      Provider.of<AppProvider>(context, listen: false).setSessionID(sessionId);
//nav to movie selection screen
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MoviesScreen()));
    } catch (err) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Error"),
                content: const Text("Invalid code"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  )
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join a session"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter the code to join a session"),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _codeController,
                maxLength: 4,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofocus: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
                decoration: const InputDecoration(
                  constraints: BoxConstraints(maxWidth: 200),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _joinSession,
              // style: ,
              child: const Text("Join"),
            ),
          ],
        ),
      ),
    );
  }
}
