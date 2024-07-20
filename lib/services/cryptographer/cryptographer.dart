import "dart:convert";
import "dart:math";
import "dart:typed_data";
import "package:pointycastle/export.dart";

class Cryptographer{
  
  static (bool, String) cryptographerResult(Map<String, dynamic> json){
    return (json["status"] as bool, json["message"] as String);
  }

  static (bool, String) encrypt(String textToEncrypt, String password, String encryptionMethod){
    try{
      int keyLength = getKeyLength(encryptionMethod);
      if(textToEncrypt.isNotEmpty && password.length >= 12){
        final salt = generateSalt();
        final keyAndIv = deriveKeyAndIv(password, salt, keyLength);
        final Uint8List keyBytes = keyAndIv["key"]!;
        final Uint8List ivBytes = keyAndIv["iv"]!;

        final params = PaddedBlockCipherParameters(ParametersWithIV(KeyParameter(keyBytes), ivBytes), null);

        final BlockCipher cipher = PaddedBlockCipher("AES/CBC/PKCS7");
        cipher.init(true, params);
        
        final textBytes = utf8.encode(textToEncrypt);

        final encryptedBytes = Uint8List.fromList(cipher.process(textBytes));
        final encryptedText = base64.encode(encryptedBytes);
        final base64Salt = base64.encode(salt);

        return cryptographerResult({ "status": true, "message": "$encryptedText | $base64Salt" });
      }
      else{
        String message = "";
        if(textToEncrypt.isEmpty){
          message = "Provide something to be encrypted (`>-л-)>";
        }
        else if(password.isEmpty){
          message = "Provide a password (`>-л-)>";
        }
        else if(password.length < 12){
          message = "Password must have at least 12 characters (`>-л-)>";
        }
        return cryptographerResult({ "status": false, "message": message });
      }
    }
    catch(error){
      return cryptographerResult({ "status": false, "message": "Error (*>•л•)> - ${error}" });
    }
  }

  static (bool, String) decrypt(String encryptedText, String base64Salt, String password, String encryptionMethod){
    try{
      int keyLength = getKeyLength(encryptionMethod);
      if(encryptedText.isNotEmpty && base64Salt.isNotEmpty && password.length >= 12){
        final salt = base64.decode(base64Salt);
        
        final keyAndIv = deriveKeyAndIv(password, salt, keyLength);
        final Uint8List keyBytes = keyAndIv["key"]!;
        final Uint8List ivBytes = keyAndIv["iv"]!;
        
        final encryptedTextBytes = base64.decode(encryptedText);

        final params = PaddedBlockCipherParameters(ParametersWithIV(KeyParameter(keyBytes), ivBytes), null);

        final cipher = PaddedBlockCipher("AES/CBC/PKCS7")..init(false, params);

        final decryptedBytes = Uint8List.fromList(cipher.process(encryptedTextBytes));

        return cryptographerResult({ "status": true, "message": utf8.decode(decryptedBytes) });
      }
      else{
        String message = "";
        if(encryptedText.isEmpty){
          message = "Provide something to be decrypted \\(-д-\\*)";
        }
        else if(base64Salt.isEmpty){
          message = "Provide the salt \\(-д-\\*)";
        }
        else if(password.isEmpty){
          message = "Provide a password \\(-д-\\*)";
        }
        else if(password.length < 12){
          message = "The password must at least 12 characters \\(-д-\\*)";
        }
        return cryptographerResult({ "status": false, "message": message });
      }
    }
    catch(error){
      return cryptographerResult({ "status": false, "message": "Error (*>•л•)> - ${error}" });
    }
  }

  static (bool, String) reencrypt(String encryptedText, String base64Salt, String oldPassword, String newPassword, String previousEncryptionMethod, String newEncryptionMethod){
    try{
      final decryptedInfo = decrypt(encryptedText, base64Salt, oldPassword, previousEncryptionMethod);
      if(!decryptedInfo.$1){
        return cryptographerResult({ "status": false, "message": "Error (*>•л•)>" });
      }
      final reencryptedInfo = encrypt(decryptedInfo.$2, newPassword, newEncryptionMethod);
      if(!reencryptedInfo.$1){
        return cryptographerResult({ "status": false, "message": "Error (*>•л•)>" });
      }
      return reencryptedInfo;
    }
    catch(error){
      return cryptographerResult({ "status": false, "message": "Error (*>•л•)> - ${error}" });
    }
  }

  static Uint8List generateSalt(){
    try{
      final random = Random.secure();
      final salt = Uint8List(32);
      for(int i = 0; i < 32; i++){
        salt[i] = random.nextInt(256);
      }
      return salt;
    }
    catch(error){
      rethrow;
    }
  }

  static int getKeyLength(String encryptionMethod) {
    switch(encryptionMethod) {
      case "AES-128-CBC":
        return 16;
      case "AES-192-CBC":
        return 24;
      case "AES-256-CBC":
        return 32;
      default: 
        throw Exception("Invalid encryption method");
    }
  }

  static Map<String, Uint8List> deriveKeyAndIv(String password, Uint8List salt, int keyLength){
    try{
      const iterations = 10000;
      const ivLength = 16;

      final pbkdf2Parameters = Pbkdf2Parameters(
        salt,
        iterations,
        keyLength + ivLength
      );

      final pbkdf2 = KeyDerivator("SHA-256/HMAC/PBKDF2")..init(pbkdf2Parameters);

      final keyAndIv = pbkdf2.process(Uint8List.fromList(utf8.encode(password)));

      final Uint8List key = keyAndIv.sublist(0, keyLength);
      final Uint8List iv = keyAndIv.sublist(keyLength, keyLength + ivLength);

      return { "key": key, "iv": iv };
    }
    catch(error){
      rethrow;
    }
  }
}