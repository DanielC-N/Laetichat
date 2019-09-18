import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_counter/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/globals.dart' as global;

bool isOpen = false;

class UserIcons extends StatefulWidget {
  static const String routeName = "/main";

  @override
  createState() => UserIconsState();
}

class UserIconsState extends State<UserIcons> {
  WebSocketChannel channel;
  Stream<dynamic> listener;
  Users usersList;
  String _platformVersion = 'Unknown';
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => _onWillPop(),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('LaetiChat'),
            centerTitle: false,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/ui');
                },
                icon: Icon(Icons.account_box),
                iconSize: 40.0,
              ),
              IconButton(
                icon: Icon(Icons.cached),
                onPressed: () async {
                  String sortie = await _getResponse();
                  if (sortie != "Successfull") {
                    global.errorMessage = sortie;
                    print(sortie);
                    // Navigator.of(context).pushNamed('/error');
                  }
                },
                color: Colors.black,
              ),
            ],
          ),
          body: _loadUsers(),
        ));
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Attention !'),
            content: new Text('Tu vas quitter Laetichat'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => defaultTargetPlatform == TargetPlatform.android
                    ? SystemNavigator.pop()
                    : Navigator.of(context).pop(true),
                child: new Text('Quitter'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Rester'),
              ),
            ],
          ),
        ) ??
        false;
  }  

  Widget _loadUsers() {
    Widget _buildRow(String name) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            // margin: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: CircleAvatar(child: Text(name[0])),
              onPressed: () async {
                global.currentOther = name;
                global.currentuser = await usersList.getUserFromName(name);
                Navigator.of(context).pushNamed('/chat');
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text(name, style: Theme.of(context).textTheme.subhead),
                FlatButton(
                  textColor: Colors.black,
                  onPressed: () async {
                    global.currentOther = name;
                    global.currentuser = await usersList.getUserFromName(name);
                    Navigator.of(context).pushNamed('/chat');
                  },
                  child: Text(
                    name,
                    textAlign: TextAlign.left,
                  ),
                  // shape: CircleBorder(side: BorderSide(color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // The itemBuilder callback is called once per suggested word pairing,
        // and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing.
        // For odd rows, the function adds a Divider widget to visually
        // separate the entries. Note that the divider may be difficult
        // to see on smaller devices.

        itemBuilder: (context, i) {
          // Add a one-pixel-high divider widget before each row in theListView.
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index < usersList.getLength()) {
            return _buildRow(usersList.getUser(index).getName());
          }

          return null;
        });
  }

  Future<String> _getResponse() async {
    try {
      http.Response response = await http.get(
          // Encode the url
          Uri.encodeFull(global.url + "/users"),
          // Only accept JSON response
          headers: {"Accept": "application/json"});

      // Logs the response body to the console
      print(response.body);

      // To modify the state of the app, use this method
      setState(() {
        var dataConvertedToJSON = json.decode(response.body);
        // Extract the required part and assign it to the global variable named data
        var data = dataConvertedToJSON['list'];
        var myUserList = usersList.getListNames();
        for (dynamic item in data) {
          var name = item['name'];
          var id = item['id'];
          // print("YO : "+id);
          if (name != global.defaultUserName && !myUserList.contains(name)) {
            usersList.addUserStr(name, id);
          }
        }
      });
      return "Successfull";
    } catch (e) {
      return "Error !\n" + e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect(global.wsUrl);
    listener = channel.stream;
    usersList = Users(
        userList: List<User>(),
        length: 0,
        listNames: List<String>(),
        sqliteManager: SqliteManager());

    isOpen = true;
    _getResponse();
  }

  @override
  void dispose() {
    this.channel.sink.close();
    super.dispose();
  }
}
