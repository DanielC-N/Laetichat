import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/local.txt');
  }

  Future<String> readLoc() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return empty String
      return "";
    }
  }

  Future<File> writeLoc(String data) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(data);
  }
}