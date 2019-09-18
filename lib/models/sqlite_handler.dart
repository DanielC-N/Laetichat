import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:flutter_counter/models/messages.dart';
import 'package:sqflite/sqflite.dart';

class SqliteManager {
  Future<Database> database;

  SqliteManager() {
    _initDb();
  }

  Future<void> _initDb() async {
    this.database = openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        p.join(await getDatabasesPath(), 'users_database.db'),
        // When the database is first created, create a table to store dogs.
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE users(username TEXT PRIMARY KEY, text TEXT)",
          );
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
      );
  }

  Future<List<Messages>> getListOfDatas() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, String>> maps = await db.query('users');

    // Convert the List<Map<String, String> into a List<Messages>.
    return List.generate(maps.length, (i) {
      return Messages(
        username: maps[i]['username'],
        text: maps[i]['text'],
      );
    });
  }

  Future<void> insert(Messages data) async {
    // Get a reference to the database.
    final Database db = await database;

    final List<Map<String, dynamic>> query = await db.query("users", where: "username = ?", whereArgs: [data.username], distinct: true);

    if(query.isEmpty) {
      // Insert the Dog into the correct table. Also specify the
      // `conflictAlgorithm`. In this case, if the same dog is inserted
      // multiple times, it replaces the previous data.
      await db.insert(
        'users',
        data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Future<void> update(Dog dog) async {
  //   // Get a reference to the database.
  //   final db = await database;

  //   // Update the given Dog.
  //   await db.update(
  //     'users',
  //     dog.toMap(),
  //     // Ensure that the Dog has a matching id.
  //     where: "id = ?",
  //     // Pass the Dog's id as a whereArg to prevent SQL injection.
  //     whereArgs: [dog.id],
  //   );
  // }

  // Future<void> delete(int id) async {
  //   // Get a reference to the database.
  //   final db = await database;

  //   // Remove the Dog from the database.
  //   await db.delete(
  //     'users',
  //     // Use a `where` clause to delete a specific dog.
  //     where: "id = ?",
  //     // Pass the Dog's id as a whereArg to prevent SQL injection.
  //     whereArgs: [id],
  //   );
  // }

}