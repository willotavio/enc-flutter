import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  DatabaseHelper._privateConstructor();
  static DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database ? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    String path = join(await getDatabasesPath(), "enc_ur_stuff.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate
    );
  }

  void _onCreate(Database db, int version){
    db.execute('''
      CREATE TABLE encryptedTexts(
        id TEXT PRIMARY KEY,
        encryptedText TEXT
      )
    ''');
  }
}