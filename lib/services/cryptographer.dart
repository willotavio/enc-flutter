import "dart:convert";
import "dart:typed_data";
import "package:pointycastle/pointycastle.dart";

class Cryptographer{
  
  static String encrypt(String textToEncrypt, String encryptionKey, String iv){
    if(textToEncrypt.isNotEmpty && encryptionKey.length == 16){

      final Uint8List keyBytes = Uint8List.fromList(utf8.encode(encryptionKey));
      final Uint8List ivBytes = Uint8List.fromList(utf8.encode(iv));
      final params = ParametersWithIV(KeyParameter(keyBytes), ivBytes);

      final BlockCipher cipher = BlockCipher("AES/CBC")..init(true, params);
      
      final textBytes = utf8.encode(textToEncrypt);
      final paddedTextBytes = _padText(textBytes);

      final encryptedBytes = Uint8List.fromList(cipher.process(paddedTextBytes));
      final encryptedText = base64.encode(encryptedBytes);
      return encryptedText;
    }
    else{
      String message = "";
      if(textToEncrypt.isEmpty){
        message = "Provide something to be encrypted (`>-л-)>";
      }
      else if(encryptionKey.length < 16 || encryptionKey.length > 16){
        message = "The key must have 16 characters (`>-л-)>";
      }
      return message;
    }
  }

  static Uint8List _padText(Uint8List text){
    final blockSize = 16;
    final padLength = blockSize - (text.length % blockSize);
    final paddedText = Uint8List(text.length + padLength)..setAll(0, text);
    return paddedText;
  }
}