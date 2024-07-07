import 'package:enc_flutter/services/database/database_helper.dart';
import 'package:enc_flutter/services/user/user.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {

  static Database? _database;

  static Future<void> _initDatabase() async {
    _database = await DatabaseHelper.instance.database;
  }

  static Future<List<User>> getUsers() async {
    if(_database == null) {
      await _initDatabase();
    }
    try {
      var users = await _database!.query("users");
      List<User> usersList = users.isNotEmpty 
      ? users.map((e) => User.fromMap(e)).toList()
      : [];
      return usersList;
    } catch(error) {
      throw Exception("Failed to get data: $error");      
    }
  }

  static Future<User?> getUserById(String id) async {
    if(_database == null) {
      await _initDatabase();
    }
    try {
      var user = await _database!.query("users", where: "id == ?", whereArgs: [id]);
      return user.isNotEmpty ? user.map((e) => User.fromMap(e)).toList()[0] : null;
    } catch(error) {
      throw Exception("Failed to get data: $error");
    }
  }

  static Future<bool> addUser(Map<String, dynamic> newUser) async {
    if(_database == null) {
      await _initDatabase();
    }
    try {
      var result = await _database?.insert("users", newUser);
      return result != -1 ? true : false;
    } catch(error) {
      throw Exception("Failed to add data: $error");
    }
  }

}