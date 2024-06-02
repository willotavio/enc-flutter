import 'package:enc_flutter/services/databaseHelper.dart';
import 'package:enc_flutter/services/encryptedText.dart';
import 'package:sqflite/sqflite.dart';

class EncryptedTextRepository{
  static Future<List<EncryptedText>> getEncryptedTexts() async {
    Database db = await DatabaseHelper.instance.database;
    var encryptedTextsList = await db.query("encryptedTexts");
    List<EncryptedText> encryptedTexts = encryptedTextsList.isNotEmpty
      ? encryptedTextsList.map((e) => EncryptedText.fromMap(e)).toList()
      : [];
    return encryptedTexts;
  }

  static Future<int> insertEncryptedText(EncryptedText text) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.insert("encryptedTexts", text.toMap(text));
  }

  static Future<bool> updateEncryptedText(String encryptedTextId, Map<String, dynamic> encryptedTextMap) async {
    Database db = await DatabaseHelper.instance.database;
    try {
      await db.update("encryptedTexts", encryptedTextMap);
      return true;
    } catch(error) {
      throw Exception(error);
    }
  }

  static Future<int> deleteEncryptedText(String id) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.delete("encryptedTexts", where: "id == ?", whereArgs: [id]);
  }
}