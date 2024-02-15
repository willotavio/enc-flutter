import "dart:convert";
import "dart:math";
import "dart:typed_data";
import "package:pointycastle/export.dart";

class Cryptographer{
  
  static String encrypt(String textToEncrypt, String password){
    try{
      if(textToEncrypt.isNotEmpty && password.length >= 12){
        final salt = generateSalt();
        final keyAndIv = deriveKeyAndIv(password, salt);
        final Uint8List keyBytes = keyAndIv["key"]!;
        final Uint8List ivBytes = keyAndIv["iv"]!;

        final params = PaddedBlockCipherParameters(ParametersWithIV(KeyParameter(keyBytes), ivBytes), null);

        final BlockCipher cipher = PaddedBlockCipher("AES/CBC/PKCS7");
        cipher.init(true, params);
        
        final textBytes = utf8.encode(textToEncrypt);

        final encryptedBytes = Uint8List.fromList(cipher.process(textBytes));
        final encryptedText = base64.encode(encryptedBytes);
        final base64Salt = base64.encode(salt);

        return "$encryptedText | $base64Salt";
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
        return message;
      }
    }
    catch(error){
      return "Error (*>•л•)>";
    }
  }

  static String decrypt(String encryptedInfo, String password){
    try{
      if(encryptedInfo.isNotEmpty && password.length >= 12){
        final encryptedText = encryptedInfo.split(" | ")[0];
        final base64Salt = encryptedInfo.split(" | ")[1];
        final salt = base64.decode(base64Salt);
        
        final keyAndIv = deriveKeyAndIv(password, salt);
        final Uint8List keyBytes = keyAndIv["key"]!;
        final Uint8List ivBytes = keyAndIv["iv"]!;
        
        final encryptedTextBytes = base64.decode(encryptedText);

        final params = PaddedBlockCipherParameters(ParametersWithIV(KeyParameter(keyBytes), ivBytes), null);

        final cipher = PaddedBlockCipher("AES/CBC/PKCS7")..init(false, params);

        final decryptedBytes = Uint8List.fromList(cipher.process(encryptedTextBytes));

        return utf8.decode(decryptedBytes);
      }
      else{
        String message = "";
        if(encryptedInfo.isEmpty){
          message = "Provide something to be decrypted \\(-д-\\*)";
        }
        else if(password.isEmpty){
          message = "Provide a password \\(-д-\\*)";
        }
        else if(password.length < 12){
          message = "The password must at least 12 characters \\(-д-\\*)";
        }
        return message;
      }
    }
    catch(error){
      return "Error (*>•л•)>";
    }
  }

  static String reencrypt(String encryptedInfo, String oldPassword, String newPassword){
    try{
      final decryptedInfo = decrypt(encryptedInfo, oldPassword);
      final reencryptedInfo = encrypt(decryptedInfo, newPassword);
      return reencryptedInfo;
    }
    catch(error){
      return "Error (*>•л•)>";
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

  static Map<String, Uint8List> deriveKeyAndIv(String password, Uint8List salt){
    try{
      const iterations = 10000;
      const keyLength = 16;
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