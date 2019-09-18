import 'package:flutter/widgets.dart';
import './list50Messages.dart';
import 'models.dart';

enum Status { connecte, deconnecte }

class User {
  String name;
  String id;
  Status currentStatus;
  CircularList messageList;
  // String last50Messages = "";
  // int length50thMessage = 0;

  User({@required this.name, @required this.id, @required this.currentStatus, @required this.messageList});

  void switchStatus() {
    this.currentStatus = this.currentStatus == Status.connecte ? Status.deconnecte : Status.connecte;
  }

  void changeName(String newName) {
    this.name = newName;
  }

  void changeId(String newId) {
    this.id = newId;
  }

  String getName() {
    return this.name;
  }

  String getId() {
    return this.id;
  }

  Status getStatus() {
    return this.currentStatus;
  }

  void setMessageList(CircularList listOfMessages) {
    this.messageList = listOfMessages;
  }

  void addAMessageStr(String usr, String incomingMessage) {
    this.messageList.addItemStr(usr, incomingMessage);
  }

  void addAMessage(Messages msg) {
    this.messageList.addItem(msg);
  }

  Map<String, String> toMap() {
    return {
      'name': this.name,
      'id': this.id,
      'messageList': this.messageList.toString()
    };
  }

  String listToString() {
    return this.messageList.toString();
  }

  List<Messages> getGrowableList() => isEmpty() ? List<Messages>() : this.messageList.getGrowableList();

  bool isEmpty() => this.messageList.isEmpty();

  // bool _checkConsistency() {
  //   int lenListOfMessages = messageList.length;
  //   if(lenListOfMessages < 50) {
  //     String tmp = listToString();
  //     if(longMessageString == tmp) return true;
  //     else return false;
  //   } else {
  //     List<Messages> last50Messages = messageList.sublist(lenListOfMessages-49, lenListOfMessages-1);
  //     // TODO Get the last 50 messages efficiently from the string
  //   }
  // }

  // void _fixConsistency() {
  //   String tmp = listToString();
  //   if(longMessageString.length > tmp.length) {
  //     setMessageList(stringToList(longMessageString));
  //   } else if (longMessageString.length < tmp.length) {
  //     setLongMessageString(tmp);
  //   }
  // }
}
