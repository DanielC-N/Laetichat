import 'package:flutter_counter/models/user.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final String url = "https://ef47c529.ngrok.io";
final String wsUrl = "wss://ef47c529.ngrok.io/";
String defaultUserName = "";
String currentOther = "";
User currentuser;
String errorMessage = "";
String deviceId = "";
WebSocketChannel channel;
String deviceIdentity;
