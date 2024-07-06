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

}