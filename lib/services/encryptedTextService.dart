import 'package:enc_flutter/services/encryptedText.dart';
import 'package:enc_flutter/services/encryptedTextRepository.dart';

class EncryptedTextService{
  static Future<List<EncryptedText>> getEncryptedTexts() async {
    var encryptedTexts = await EncryptedTextRepository.getEncryptedTexts();
    return encryptedTexts;
  }

  static Future<int> insertEncryptedText(EncryptedText text) async {
    return await EncryptedTextRepository.insertEncryptedText(text);
  }

  static Future<int> deleteEncryptedText(String id) async {
    return await EncryptedTextRepository.deleteEncryptedText(id);
  }
}