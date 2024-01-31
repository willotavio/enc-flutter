import 'package:flutter/material.dart';
import '../services/cryptographer.dart';

class EncryptionScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    TextEditingController _textToEncryptController = TextEditingController();
    TextEditingController _encryptionKeyController = TextEditingController();
    TextEditingController _encryptionIvController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    TextEditingController _encryptedTextResult = TextEditingController();
    
    String? _validateTextToEncrypt(String? value){
      if(value == null || value.isEmpty){
        return "Enter at least 1 character (*/-д-)/";
      }
      return null;
    }
    String? _validateEncryptionKey(String? value){
      if(value == null || value.isEmpty){
        return "Provide a key (*/-д-)/";
      }
      else if(value.length != 16){
        return "The key must have 16 characters (*/-д-)/";
      }
      else if(value == _encryptionIvController.text){
        return "The key and the IV must not be equal (*/-д-)/";
      }
      return null;
    }

    String? _validateEncryptionIv(String? value){
      if(value == null || value.isEmpty){
        return "Provide an IV (*/-д-)/";
      }
      else if(value.length != 16){
        return "The IV must have 16 characters (*/-д-)/";
      }
      else if(value == _encryptionKeyController.text){
        return "The IV and the key must not be equal (*/-д-)/";
      }
      return null;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _textToEncryptController,
                    validator: _validateTextToEncrypt,
                    decoration: InputDecoration(
                      labelText: "Enter a text to encrypt"
                    ),
                    maxLines: null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _encryptionKeyController,
                    validator: _validateEncryptionKey,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter the encryption key",
                    ),
                    maxLength: 16,
                  ),
                  TextFormField(
                    controller: _encryptionIvController,
                    validator: _validateEncryptionIv,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter the encryption IV",
                    ),
                    maxLength: 16,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(100, 50),
                    ),
                    onPressed: () {
                      if(_formKey.currentState?.validate() ?? false){
                        _encryptedTextResult.text = Cryptographer.encrypt(_textToEncryptController.text, _encryptionKeyController.text, _encryptionIvController.text);
                      }
                    }, 
                    child: Text("Encrypt"),
                  ),
                  TextField(
                    controller: _encryptedTextResult,
                    readOnly: true,
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}