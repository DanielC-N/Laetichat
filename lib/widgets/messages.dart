import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_counter/models/messages.dart';
import '../models/globals.dart' as global;

class Msg extends StatelessWidget {
  Msg({this.username, this.userID, this.txt, this.animationController});
  String txt;
  String username;
  String userID;
  AnimationController animationController;

  Msg.fromMessageBuilder(Messages msg, AnimationController anim) {
    this.animationController = anim;
    this.username = msg.username;
    this.txt = msg.text;
  }

  Msg.fromRaw(String usr, String txt, AnimationController anim) {
    this.animationController = anim;
    this.username = usr;
    this.txt = txt;
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: animationController, curve: Curves.fastLinearToSlowEaseIn),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: (username != global.defaultUserName) // || (userID != global.deviceId)
        ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 18.0),
              child: CircleAvatar(child: Text(username[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(username, style: Theme.of(context).textTheme.subhead),
                  Container(
                    margin: const EdgeInsets.only(top: 6.0),
                    child: Text(txt),
                  ),
                ],
              ),
            ),
          ],
        )
        : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 18.0),
                    child: Text(username, style: Theme.of(context).textTheme.subhead),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0, right: 18.0),
                    child: Text(txt),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 5.0),
              child: CircleAvatar(child: Text(username[0])),
            ),
          ],
        ),
      ),
    );
  }
}

