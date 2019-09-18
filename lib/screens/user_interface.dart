import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_counter/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/globals.dart' as global;

class UserInterface extends StatefulWidget {
  static const String routeName = "/ui";

  @override
  State createState() => UserInterfaceWindow();
}

class UserInterfaceWindow extends State<UserInterface> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your profile"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
      ),
    );
  }

  // Function for HTTP GET on my local server
  Future<String> _getAllMessages() async {
    var response = await http.post(
        // Encode the url
        Uri.encodeFull(global.url+"/messages"),
        // Only accept JSON response
        headers: {"Accept": "application/json"},
        body: { 'loby' : global.defaultUserName+global.currentOther}
    );

    // Logs the response body to the console
    print(response.body);
    var dataConvertedToJSON = json.decode(response.body);
    var data = dataConvertedToJSON['list'];

    if(data == []) return "Nothing to show here ...";

    // To modify the state of the app, use this method
    setState(() {
      
    });
    
    return "Successfull";
  }

  // Function for HTTP GET on my local server
  Future<String> _postAMessage(String message) async {
    var response = await http.post(
        // Encode the url
        Uri.encodeFull(global.url),
        // Only accept JSON response
        headers: {"Accept": "application/json"},
        body: { 'loby' : global.defaultUserName+global.currentOther,
                'message' : message,
                'username' : global.defaultUserName }
    );

    // Logs the response body to the console
    print(response.body);
    
    return "Successfull";
  }

}