import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database ? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    String path = join(await getDatabasesPath(), "enc_ur_stuff.db");
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  void _onCreate(Database db, int version) async {
    print("------ entering _onCreate ------");
    for(int i = 1; i <= _migrationScripts.length; i++) {
      await _migrationScripts[i]!(db);
    }
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("------ entering _onUpgrade ------");
    for(int i = oldVersion + 1; i <= newVersion; i++) {
      print("------ updating to $newVersion ------");
      await _migrationScripts[i]!(db);
    }
  }

  Map<int, Function> _migrationScripts = {
    1: (Database db) async {
      db.execute('''
        CREATE TABLE encryptedTexts(
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT,
          encryptedText TEXT NOT NULL
        )
      ''');
    },
    2: (Database db) async {
      db.execute('''
        CREATE TABLE users(
          id TEXT PRIMARY KEY,
          username TEXT NOT NULL,
          email TEXT NOT NULL,
          password TEXT NOT NULL
        )
      ''');
    },
    3: (Database db) async {
      db.execute('''
        ALTER TABLE encryptedTexts ADD COLUMN encryptionMethod TEXT NOT NULL DEFAULT "AES-128-CBC"
      ''');
    }
  };
}