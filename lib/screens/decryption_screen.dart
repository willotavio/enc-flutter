import 'package:flutter/material.dart';
import '../services/cryptographer.dart';

class DecryptionScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    TextEditingController _textToDecryptController = TextEditingController();
    TextEditingController _decryptionKeyController = TextEditingController();
    TextEditingController _decryptionIvController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    TextEditingController _decryptedTextResult = TextEditingController();

    String? _validateTextToDecrypt(String? value){
      if(value == null || value.isEmpty){
        return "Enter something to be encrypted (*/•_•)/";
      }
      return null;
    }
    String? _validateDecryptionKey(String? value){
      if(value == null || value.isEmpty){
        return "Enter the decryption key (*/•_•)/";
      }
      else if(value.length != 16){
        return "Decryption key must have 16 characters (*/•_•)/";
      }
      else if(value == _decryptionIvController.text){
        return "The key and the IV must not be equal (*/•_•)/";
      }
      return null;
    }
    String? _validateDecryptionIv(String? value){
      if(value == null || value.isEmpty){
        return "Enter the decryption IV (*/•_•)/";
      }
      else if(value.length != 16){
        return "The IV must have 16 characters";
      }
      else if(value == _decryptionKeyController){
        return "The IV and the key must not be equal (*/•_•)/";
      }
      return null;
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: 100,
                      child: TextFormField(
                        controller: _textToDecryptController,
                        validator: _validateTextToDecrypt,
                        decoration: InputDecoration(
                          labelText: "Enter a text to decrypt",
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _decryptionKeyController,
                    validator: _validateDecryptionKey,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter the decryption key",
                    ),
                    maxLength: 16,
                  ),
                  TextFormField(
                    controller: _decryptionIvController,
                    validator: _validateDecryptionIv,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter the decryption IV"
                    ),
                    maxLength: 16,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState?.validate() ?? false){
                        _decryptedTextResult.text = Cryptographer.decrypt(_textToDecryptController.text, _decryptionKeyController.text, _decryptionIvController.text);
                      }
                    },
                    child: Text("Decrypt"),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(100,50),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: 100,
                      child: TextField(
                        controller: _decryptedTextResult,
                        readOnly: true,
                        maxLines: null,
                      ),
                    ),
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