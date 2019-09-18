import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_counter/controller.dart';
import 'package:flutter_counter/models/messages.dart';
import 'package:flutter_counter/models/user.dart';
import 'package:flutter_counter/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/globals.dart' as global;

class Chat extends StatefulWidget {
  static const String routeName = "/chat";
  ChatWindow currentState;

  @override
  State createState() {
    currentState = ChatWindow();
    return currentState;
  }

  ChatWindow getInstance() => currentState;
}

class ChatWindow extends State<Chat> with TickerProviderStateMixin {
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textController = TextEditingController();
  User currentUser = global.currentuser;
  bool _isWriting = false;
  List data;

  @override
  Widget build(BuildContext context) {
    // currentUser = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(global.currentOther),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
      ),
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
          reverse: true,
          padding: EdgeInsets.all(6.0),
        )),
        Divider(height: 1.0),
        Container(
          child: _buildComposer(),
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
        ),
      ]),
    );
  }

  Widget _buildComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  onChanged: (String txt) {
                    setState(() {
                      _isWriting = txt.length > 0;
                    });
                  },
                  onSubmitted: submitMsg,
                  decoration: InputDecoration.collapsed(
                      hintText: "Enter some text to send a message"),
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoButton(
                          child: Text("Submit"),
                          onPressed: _isWriting
                              ? () => submitMsg(_textController.text)
                              : null)
                      : IconButton(
                          icon: Icon(Icons.message),
                          onPressed: _isWriting
                              ? () => submitMsg(_textController.text)
                              : null,
                        )),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.brown)))
              : null),
    );
  }

  void submitMsg(String txt) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    Messages mess = Messages.fromText(global.defaultUserName, txt);
    Msg msg = Msg(
      username: global.defaultUserName,
      txt: txt,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 800)),
    );
    setState(() {
      _messages.insert(0, msg);
      currentUser.addAMessage(mess);
      _postAMessage(mess);
    });
    msg.animationController.forward();
  }

  void tmpSubmitMsg(dynamic jsonObject) {
    String senderName = jsonObject['username'];
    String senderID = jsonObject['usernameID'];
    String timestamp = jsonObject['timestamp'];
    String txtMessage = jsonObject['txt'];

    Messages mess = Messages.fromReceived(senderName, txtMessage, timestamp);
    Msg msg = Msg(
      username: global.defaultUserName,
      userID: senderID,
      txt: txtMessage,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 800)),
    );
    setState(() {
      _messages.insert(0, msg);
      currentUser.addAMessage(mess);
      _postAMessage(mess);
    });
    msg.animationController.forward();
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }

  // Function for HTTP POST on my local server
  Future<String> _getMessages(String needLess) async {
    var response = await http.post(
        // Encode the url
        Uri.encodeFull(global.url + "/messages"),
        // Only accept JSON response
        headers: {
          "Accept": "application/json"
        },
        body: {
          'sender': global.defaultUserName,
          'senderID': global.deviceId,
          'receiver': global.currentuser.getName(),
          'receiverID': global.currentuser.getId(),
          'less': needLess
        });

    // Logs the response body to the console
    print(response.body);
    if(response.statusCode != 200) {
      return "Nothing to show here ...";
    }
    var dataConvertedToJSON = json.decode(response.body);
    var data = dataConvertedToJSON['list'];

    if (data == []) return "Nothing to show here ...";

    // To modify the state of the app, use this method
    setState(() {
      Msg msg;
      // Extract the required part and assign it to the global variable named data
      for (var item in data) {
        msg = Msg(
          username: item['username'],
          txt: item['txt'],
          animationController: AnimationController(
              vsync: this, duration: Duration(milliseconds: 0)),
        );
        _messages.insert(0, msg);
        msg.animationController.forward();
      }
    });

    return "Successfull";
  }

  // Function for HTTP GET on my local server
  Future<String> _postAMessage(Messages message) async {
    var response = await http.post(
        // Encode the url
        Uri.encodeFull(global.url),
        // Only accept JSON response
        headers: {
          "Accept": "application/json"
        },
        body: {
          'sender': global.defaultUserName,
          'senderID': global.deviceId,
          'receiver': global.currentOther,
          'receiverID': global.currentuser.getId(),
          'message': message.text,
          'timestamp': message.timestamp
        });

    // Logs the response body to the console
    print(response.body);
    // var dataConvertedToJSON = json.decode(response.body);
    // var data = dataConvertedToJSON['list'];

    // if(data == []) return "Nothing to show here ...";
    // Msg msg;

    // // To modify the state of the app, use this method
    // setState(() {
    //   // Extract the required part and assign it to the global variable named data
    //   for (var item in data) {
    //     msg = Msg(
    //       username: item.username.toString(),
    //       txt: item.txt.toString(),
    //       animationController: AnimationController(
    //           vsync: this, duration: Duration(milliseconds: 0)),
    //     );
    //     msg.animationController.forward();
    //   }
    // });

    return "Successfull";
  }

  void _pushLast50Messages() {
    // To modify the state of the app, use this method
    setState(() {
      List<Messages> tmpListMsg = currentUser.getGrowableList();
      if (tmpListMsg != null) {
        Msg msg;
        // Extract the required part and assign it to the global variable named data
        for (var item in tmpListMsg) {
          if (item != null) {
            AnimationController tmpAnim = AnimationController(
              vsync: this,
              duration: Duration(milliseconds: 0),
            );
            msg = Msg.fromMessageBuilder(item, tmpAnim);
            _messages.insert(0, msg);
            msg.animationController.forward();
          }
        }
      }
    });
  }

  void _initMessages() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // I am connected to a network.
        _getMessages("1");
      }
    }
    on SocketException catch (_) {
      _pushLast50Messages();
    }
  }

  @override
  void initState() {
    super.initState();

    _initMessages();
  }
}
