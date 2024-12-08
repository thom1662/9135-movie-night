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
  bool _buttonEnabled = false;

//called by button press
  void _joinSession() async {
    String codeInput = _codeController.text;
    int code = codeInput.isNotEmpty ? int.parse(codeInput) : 0;
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
              padding: const EdgeInsets.all(32),
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
                onChanged: (value) {
                  setState(() {
                    _buttonEnabled = value.length == 4;
                  });
                },
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _buttonEnabled
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              onPressed: _joinSession,
              // style: ,
              label: Text("Start selecting movies",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                  )),
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_right_alt, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
