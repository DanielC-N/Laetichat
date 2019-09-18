import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_counter/widgets/widgets.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:http/http.dart' as http;
import '../models/globals.dart' as global;
import './user_icons.dart';

class Registering extends StatefulWidget {
  static const String routeName = "/register";

  @override
  createState() => RegisteringState();
}

class RegisteringState extends State<Registering> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final errorSnackbar = SnackBar(
    content: Text("Erreur ! Tu t'es trompé de mot de passe !"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.limeAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(40.0),
            child: Form(
              autovalidate: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: "Enter Pseudo"),
                    keyboardType: TextInputType.text,
                    controller: _usernameController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                  ),
                  MaterialButton(
                    height: 50.0,
                    minWidth: 150.0,
                    color: Colors.green,
                    splashColor: Colors.teal,
                    textColor: Colors.white,
                    child: Icon(Icons.subdirectory_arrow_right),
                    onPressed: () async {
                      if (_usernameController.text.isEmpty ||
                          _passwordController.text.isEmpty) return;
                      // global.deviceId = await FlutterUdid.consistentUdid;
                      String response = await _postRegister();
                      if (response != "Successfull") {
                        global.errorMessage = response;
                        _passwordController.clear();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ErrorHandlerWidget();
                            });
                      } else {
                        global.defaultUserName = _usernameController.text;
                        Navigator.of(context).popAndPushNamed('/main');
                      }
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<String> _postRegister() async {
    try {
      var response = await http.post(
          // Encode the url
          Uri.encodeFull(global.url + "/register"),
          // Only accept JSON response
          headers: {
            "Accept": "application/json"
          },
          body: {
            'username': _usernameController.text,
            'id': global.deviceId,
            'pass': _passwordController.text
          });

      // Logs the response body to the console
      print(response.body);

      if (response.statusCode != 200)
        return "Error : wrong password (go back and retry)";

      return "Successfull";
    } catch (e) {
      return "Error : wrong password (go back and retry)";
    }
  }
}
