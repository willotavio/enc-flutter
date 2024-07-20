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

  static Future<bool> updateEncryptedText(String encryptedTextId, String? title, String? description, String? encryptedText, String? encryptionMethod) async {
    if(title != null && title.isNotEmpty 
      || (description != null && description.isNotEmpty) || description == null
      || encryptedText != null && encryptedText.isNotEmpty
      || encryptionMethod != null && encryptionMethod.isNotEmpty) {
      return EncryptedTextRepository.updateEncryptedText(encryptedTextId, getDynamicEncryptedTextMap(title, description, encryptedText, encryptionMethod));
    }
    return false;
  } 

  static Future<int> deleteEncryptedText(String id) async {
    return await EncryptedTextRepository.deleteEncryptedText(id);
  }

  static Map<String, dynamic> getDynamicEncryptedTextMap(
    String? title,
    String? description,
    String? encryptedText,
    String? encryptionMethod
  ) {
    Map<String, dynamic> dynamicEncryptedTextMap = {};
    if(title != null && title.isNotEmpty) {
      dynamicEncryptedTextMap["title"] = title;
    }
    if((description != null && description.isNotEmpty) || description == null) {
      dynamicEncryptedTextMap["description"] = description;
    }
    if(encryptedText != null && encryptedText.isNotEmpty) {
      dynamicEncryptedTextMap["encryptedText"] = encryptedText;
    }
    if(encryptionMethod != null && encryptionMethod.isNotEmpty) {
      dynamicEncryptedTextMap["encryptionMethod"] = encryptionMethod;
    }
    return dynamicEncryptedTextMap;
  }
}