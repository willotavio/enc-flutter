import 'package:flutter/material.dart';
import '../services/cryptographer.dart';

class EncryptionScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    TextEditingController _textToEncryptController = TextEditingController();
    TextEditingController _encryptionPasswordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    TextEditingController _encryptedTextResult = TextEditingController();
    
    String? _validateTextToEncrypt(String? value){
      if(value == null || value.isEmpty){
        return "Enter at least 1 character (*/-д-)/";
      }
      return null;
    }
    String? _validateEncryptionPassword(String? value){
      if(value == null || value.isEmpty){
        return "Provide a password (*/-д-)/";
      }
      else if(value.length < 12){
        return "The password must have at least 12 characters (*/-д-)/";
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
                        controller: _textToEncryptController,
                        validator: _validateTextToEncrypt,
                        decoration: InputDecoration(
                          labelText: "Enter a text to encrypt"
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _encryptionPasswordController,
                    validator: _validateEncryptionPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter the encryption password",
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(100, 50),
                    ),
                    onPressed: () {
                      if(_formKey.currentState?.validate() ?? false){
                        _encryptedTextResult.text = Cryptographer.encrypt(_textToEncryptController.text, _encryptionPasswordController.text);
                      }
                    }, 
                    child: Text("Encrypt"),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: 100,
                      child: TextField(
                        controller: _encryptedTextResult,
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