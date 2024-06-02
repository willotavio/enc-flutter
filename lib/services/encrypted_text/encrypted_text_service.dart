import 'package:enc_flutter/services/encrypted_text/encrypted_text.dart';
import 'package:enc_flutter/services/encrypted_text/encrypted_text_repository.dart';

class EncryptedTextService{
  static Future<List<EncryptedText>> getEncryptedTexts() async {
    var encryptedTexts = await EncryptedTextRepository.getEncryptedTexts();
    return encryptedTexts;
  }

  static Future<int> insertEncryptedText(EncryptedText text) async {
    return await EncryptedTextRepository.insertEncryptedText(text);
  }

  static Future<bool> updateEncryptedText(String encryptedTextId, String? title, String? description, String? encryptedText) async {
    if(title != null || description != null || encryptedText != null) {
      return EncryptedTextRepository.updateEncryptedText(encryptedTextId, getDynamicEncryptedTextMap(title, description, encryptedText));
    }
    return false;
  } 

  static Future<int> deleteEncryptedText(String id) async {
    return await EncryptedTextRepository.deleteEncryptedText(id);
  }

  static Map<String, dynamic> getDynamicEncryptedTextMap(
    String? title,
    String? description,
    String? encryptedText
  ) {
    Map<String, dynamic> dynamicEncryptedTextMap = {};
    if(title != null) {
      dynamicEncryptedTextMap["title"] = title;
    }
    if(description != null) {
      dynamicEncryptedTextMap["description"] = description;
    }
    if(encryptedText != null) {
      dynamicEncryptedTextMap["encryptedText"] = encryptedText;
    }
    return dynamicEncryptedTextMap;
  }
}