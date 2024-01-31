import "dart:convert";
import "dart:typed_data";
import "package:pointycastle/pointycastle.dart";

class Cryptographer{
  
  static String encrypt(String textToEncrypt, String encryptionKey, String encryptionIv){
    if(textToEncrypt.isNotEmpty && encryptionKey.length == 16 && encryptionIv.length == 16){
      final Uint8List keyBytes = Uint8List.fromList(utf8.encode(encryptionKey));
      final Uint8List ivBytes = Uint8List.fromList(utf8.encode(encryptionIv));
      final params = PaddedBlockCipherParameters(ParametersWithIV(KeyParameter(keyBytes), ivBytes), null);

      final BlockCipher cipher = PaddedBlockCipher("AES/CBC/PKCS7");
      cipher.init(true, params);
      
      final textBytes = utf8.encode(textToEncrypt);

      final encryptedBytes = Uint8List.fromList(cipher.process(textBytes));
      final encryptedText = base64.encode(encryptedBytes);
      return encryptedText;
    }
    else{
      String message = "";
      if(textToEncrypt.isEmpty){
        message = "Provide something to be encrypted (`>-л-)>";
      }
      else if(encryptionKey.length != 16){
        message = "The key must have 16 characters (`>-л-)>";
      }
      else if(encryptionIv.length != 16){
        message = "The IV must have 16 characters (`>-л-)>";
      }
      else if(encryptionKey == encryptionIv){
        message = "The IV and the key must not be equal \\(-д-\\*)";
      }
      return message;
    }
  }

  static String decrypt(String encryptedText, String decryptionKey, String decryptionIv){
    if(encryptedText.isNotEmpty && decryptionKey.length == 16 && decryptionIv.length == 16){
      final keyBytes = Uint8List.fromList(utf8.encode(decryptionKey));
      final ivBytes = Uint8List.fromList(utf8.encode(decryptionIv));
      final encryptedTextBytes = base64.decode(encryptedText);

      final params = PaddedBlockCipherParameters(ParametersWithIV(KeyParameter(keyBytes), ivBytes), null);

      final cipher = PaddedBlockCipher("AES/CBC/PKCS7")..init(false, params);

      final decryptedBytes = Uint8List.fromList(cipher.process(encryptedTextBytes));

      return utf8.decode(decryptedBytes);
    }
    else{
      String message = "";
      if(encryptedText.isEmpty){
        message = "Provide something to be decrypted \\(-д-\\*)";
      }
      else if(decryptionKey.length != 16){
        message = "The key must have 16 characters \\(-д-\\*)";
      }
      else if(decryptionIv.length != 16){
        message = "The IV must have 16 characters \\(-д-\\*)";
      }
      else if(decryptionKey == decryptionIv){
        message = "The key and the IV must not be equal \\(-д-\\*)";
      }
      return message;
    }
  }
}