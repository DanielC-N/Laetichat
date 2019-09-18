import 'package:flutter/material.dart';
import 'package:flutter_counter/models/list50Messages.dart';

import 'models.dart';

class Users {
  List<User> userList;
  List<String> listNames;
  int length;
  final SqliteManager sqliteManager;

  Users({@required this.userList,@required this.length,@required this.listNames,@required this.sqliteManager});

  void addUser(User newUser) {
    try {
      this.userList.add(newUser);
      this.listNames.add(newUser.getName());
      length++;
    } catch (e) {
      print("ERROR adding User : "+e);
    }
  }

  void addUserStr(String newUser, String newId) {
    User tmpUser = User(name: newUser, id: newId, currentStatus: Status.deconnecte, messageList: CircularList());

    try {
      this.userList.add(tmpUser);
      this.listNames.add(newUser);
      length++;
    } catch (e) {
      print("ERROR adding User : "+e.toString());
    }
  }

  void removeUser(User newUser) {
    try {
      this.userList.remove(newUser);
      this.listNames.remove(newUser.getName());
      length--;
    } catch (e) {
      print("ERROR removing User : "+e.toString());
    }
  }

  void changeUserStatus(String name) {
    try {
      this.userList.forEach((element) {
        if(element.name == name) {
          element.switchStatus();
        }
      });
    } catch (e) {
      print("ERROR changing status (probably user doesn't exists): "+e.toString());
    }
  }

  int getLength() {
    return this.length;
  }

  User getUser(int index) {
    return this.userList[index];
  }

  Future<User> getUserFromName(String un) async {
    for(User elem in this.userList) {
      if(elem.getName() == un) return elem;
    }
    return null;
  }

  List<User> getUsers() {
    return this.userList;
  }

  List<String> getListNames() {
    return this.listNames;
  }

  @override
  String toString() {
    String res = "[ ";
    for(var elem in this.listNames) {
      res += elem+", ";
    }
    res += "]";
    return res;
  }

}