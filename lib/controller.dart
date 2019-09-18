import 'dart:convert';
import 'dart:io' show InternetAddress, Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_counter/models/models.dart';
import 'package:flutter_counter/screens/chat.dart';
import 'package:flutter_counter/screens/screens.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'models/globals.dart' as global;
import 'models/models.dart';
import 'widgets/widgets.dart';


class GeneralController {
  BuildContext context;
  WebSocketChannel _channel;
  Stream<dynamic> _listener;
  Users _usersList;
  String _platformVersion;
  String deviceID;
  bool _isOpen;
  Widget _currentActiveWidget;

  String currentUserName;

  GeneralController() {
    _isOpen = false;
    currentUserName = "";
    this._initCommunication();
    this._usersList = Users(
        userList: List<User>(),
        length: 0,
        listNames: List<String>(),
        sqliteManager: SqliteManager());
    this._platformVersion = Platform.operatingSystemVersion;
    this._currentActiveWidget = null;

    // INIT GLOBALS
    _initGlobals();
  }

  void dispose() {
    this._channel.sink.close();
  }

  void setContext(BuildContext c) {
    this.context = c;
  }

  void setUsername(String usr) {
    this.currentUserName = usr;
  }



  void _initGlobals() {
    global.channel = this._channel;
  }
  
  void _initCommunication() async {
    ///
    /// Ouvrir une nouvelle communication WebSockets
    ///
    try {
      deviceID = await FlutterUdid.consistentUdid;
      global.deviceId = deviceID;
      final result = await InternetAddress.lookup(global.url);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _channel = IOWebSocketChannel.connect(global.wsUrl);
        _listener = _channel.stream;

        // final String deviceIdentity = await FlutterUdid.consistentUdid;
        Map<String, String> jjs = {"deviceID": deviceId};
        print("DEVICE ID : "+deviceId);

        _channel.sink.add(json.encode(jjs));

        ///
        /// Demarrage de l'ecoute des nouveaux messages
        ///
        _listener.listen(_onReceptionOfMessageFromServer);
        
        _isOpen = true;
        print("ca marche !");
      }
    } catch (e) {
      _isOpen = false;
      print("ca marche pas !\n"+e.toString());
      
      ///
      /// Gestion des erreurs globales
      /// TODO
      ///
    }
  }

  void _onReceptionOfMessageFromServer(message) {
    try {
      dynamic parsedMessage = jsonDecode(message);
      
      if(_currentActiveWidget.runtimeType != Chat().runtimeType) {
        print(parsedMessage);
      } else {
        ChatWindow currentInstance = (_currentActiveWidget as Chat).getInstance();
        currentInstance.tmpSubmitMsg(parsedMessage);
      }
    } catch(e) {
      print("Couldn't push it in Chat !\n"+message);
    }
    
    // setState(() {
    //   try {
    //     Msg msg;
    //     dynamic messg = jsonDecode(message);
    //     AnimationController tmpAnim = AnimationController(
    //       vsync: this,
    //       duration: Duration(milliseconds: 0),
    //     );
    //     Messages newMessage = Messages.fromReceived(message.username, message.txt, message.timestamp);
    //     msg = Msg.fromMessageBuilder(newMessage, tmpAnim);
    //     _messages.insert(0, msg);
    //     msg.animationController.forward();
    //   } catch(e) {
    //       print(message);
    //   }
    // });
  }

  Users getUsersList() => _usersList;

  String getPlatformVersion() => _platformVersion;

  BuildContext getContext() => context;

  WebSocketChannel getWSChannel() => channel;

  Stream<dynamic> getListener() => _listener;

  Widget getCurrentActiveWidget() => _currentActiveWidget;

  String getUsername() => this.currentUserName;

  Widget getChat() {
    Widget tmp = Chat();
    _currentActiveWidget = tmp;
    return tmp;
  }

  Widget getUserInterface() {
    Widget tmp = UserInterface();
    _currentActiveWidget = tmp;
    return tmp;
  }

  Widget getUserIcons() {
    Widget tmp = UserIcons();
    _currentActiveWidget = tmp;
    return tmp;
  }

  Widget getRegistering() {
    Widget tmp = Registering();
    _currentActiveWidget = tmp;
    return tmp;
  }
}