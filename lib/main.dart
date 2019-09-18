import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_counter/screens/screens.dart';
import './models/globals.dart' as global;
import './controller.dart';
// import 'package:bloc/bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

final ThemeData iOSTheme = ThemeData(
  primarySwatch: Colors.red,
  primaryColor: Colors.grey[400],
  primaryColorBrightness: Brightness.dark,
);

final ThemeData androidTheme = ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.green,
);

void main() {
  final GeneralController gc = GeneralController();
  runApp(MyApp(gc: gc));
}

class MyApp extends StatelessWidget {
  final GeneralController gc;

  MyApp({@required this.gc});
  
  @override
  Widget build(BuildContext context) {
    gc.setContext(context);
    return MaterialApp(
      theme:
          defaultTargetPlatform == TargetPlatform.iOS ? iOSTheme : androidTheme,
      title: 'LaetiChat',
      // home: BlocProvider<CounterBloc>(
      //   builder: (context) => CounterBloc(),
      //   child: CounterPage(),
      // ),
      home: gc.getUsername() == "" ? gc.getRegistering() : gc.getUserIcons(),
      routes: <String, WidgetBuilder>{
        // Set named routes
        Chat.routeName: (BuildContext context) => gc.getChat(),
        UserInterface.routeName: (BuildContext context) => gc.getUserInterface(),
        UserIcons.routeName: (BuildContext context) => gc.getUserIcons(),
      },
    );
  }
}
