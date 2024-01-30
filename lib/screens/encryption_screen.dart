import 'package:flutter/material.dart';

class EncryptionScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    TextEditingController _textToEncryptController = TextEditingController();
    TextEditingController _encryptionKeyController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    
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
      if(value.length != 16){
        return "The key must have 16 characters (*/-д-)/";
      }
      return null;
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _textToEncryptController,
                  validator: _validateTextToEncrypt,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Enter a text to encrypt"
                  ),
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
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(100, 50),
                  ),
                  onPressed: () {
                    if(_formKey.currentState?.validate() ?? false){
                      print(_textToEncryptController.text); 
                    }
                  }, 
                  child: Text("Encrypt"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}