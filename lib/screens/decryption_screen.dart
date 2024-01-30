import 'package:flutter/material.dart';

class DecryptionScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    TextEditingController _textToDecryptController = TextEditingController();
    TextEditingController _decryptionKeyController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    String? _validateTextToDecrypt(String? value){
      if(value == null || value.isEmpty){
        return 'Enter something to be encrypted (*/•_•)/';
      }
      return null;
    }
    String? _validateDecryptionKey(String? value){
      if(value == null || value.isEmpty){
        return 'Enter the decryption key (*/•_•)/';
      }
      else if(value.length != 16){
        return 'Decryption key must have 16 characters (*/•_•)/';
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
                  controller: _textToDecryptController,
                  validator: _validateTextToDecrypt,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Enter a text to decrypt",
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState?.validate() ?? false){
                      print(_textToDecryptController.text);
                    }
                  },
                  child: Text("Decrypt"),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(100,50),
                  ),
                ),
              ],
            ),  
          ),
        ),
      ),
    );
  }
}