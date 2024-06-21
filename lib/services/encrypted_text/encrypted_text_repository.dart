import 'package:enc_flutter/services/database/database_helper.dart';
import 'package:enc_flutter/services/encrypted_text/encrypted_text.dart';
import 'package:sqflite/sqflite.dart';

class EncryptedTextRepository {
  static Database? _database;

  static Future<void> _initDatabase() async {
    _database = await DatabaseHelper.instance.database;
  }

  static Future<List<EncryptedText>> getEncryptedTexts() async {
    if(_database == null) {
      await _initDatabase();
    }
    var encryptedTextsList = await _database!.query("encryptedTexts");
    List<EncryptedText> encryptedTexts = encryptedTextsList.isNotEmpty
      ? encryptedTextsList.map((e) => EncryptedText.fromMap(e)).toList()
      : [];
    return encryptedTexts;
  }

  static Future<int> insertEncryptedText(EncryptedText text) async {
    if(_database == null) {
      await _initDatabase();
    }
    return await _database!.insert("encryptedTexts", text.toMap(text));
  }

  static Future<bool> updateEncryptedText(String encryptedTextId, Map<String, dynamic> encryptedTextMap) async {
    if(_database == null) {
      await _initDatabase();
    }
    try {
      await _database!.update("encryptedTexts", encryptedTextMap);
      return true;
    } catch(error) {
      throw Exception(error);
    }
  }

  static Future<int> deleteEncryptedText(String id) async {
    if(_database == null) {
      await _initDatabase();
    }
    return await _database!.delete("encryptedTexts", where: "id == ?", whereArgs: [id]);
  }
}