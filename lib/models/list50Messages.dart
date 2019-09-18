
import 'package:flutter_counter/models/messages.dart';

class CircularList {
  int index;
  List<String> list;
  List<Messages> listMess;
  bool isempty;

  CircularList() {
    this.list = List<String>(50);
    this.index = 0;
    this.listMess = List<Messages>(50);
    this.isempty = true;
  }

  bool isEmpty() {
    return this.isempty;
  }

  void addItemStr(String usr, String item) {
    Messages tmpM = Messages.fromText(usr, item);
    isempty = false;
    listMess[index] = tmpM;
    list[index] = item;
    _incrementIndex();
  }

  void addItem(Messages newMess) {
    String tmpStr = newMess.toString();
    listMess[index] = newMess;
    list[index] = tmpStr;
    isempty = false;
    _incrementIndex();
  }

  void removeLast() {
    listMess[index] = null;
    list[index] = "";
    _decrementIndex();
  }

  void removeAt(int i) {
    listMess[i] = null;
    list[i] = "";
  }

  void modifyAtStr(int i, String newText) {
    Messages tmpM = Messages.fromString(newText);
    listMess[i] = tmpM;
    list[i] = newText;
  }

  void modifyAt(int i, Messages newMess) {
    String tmpStr = newMess.toString();
    listMess[i] = newMess;
    list[i] = tmpStr;
  }

  Messages getCurrentMessage() {
    return listMess[index];
  }

  String getCurrentMessageStr() {
    return list[index];
  }

  Messages get50thMessage() {
    return listMess[index+1];
  }

  String get50thMessageStr() {
    return list[index+1];
  }

  int getLenght50thMessageStr() {
    return list[index+1].length;
  }

  void _incrementIndex() {
    index = (index+1)%50;
  }

  void _decrementIndex() {
    if(index == 0) index = 49;
    else index = index-1;
  }

  List<Messages> getGrowableList() {
    List<Messages> messList = List<Messages>();
    int tempIndex = index+1;
    while(tempIndex != index) {
      messList.add(this.listMess[tempIndex]);
      tempIndex = (tempIndex+1)%50;
    }

    return messList;
  }

  @override
  String toString() {
    int tempIndex = index+1;
    String str = "";
    str += listMess[tempIndex].toString();
    tempIndex = (tempIndex+1)%50;
    while(tempIndex != index) {
      str += "|+++|"+listMess[tempIndex].toString();
      tempIndex = (tempIndex+1)%50;
    }

    return str;
  }
}