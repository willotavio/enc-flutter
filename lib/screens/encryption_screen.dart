import 'package:flutter/material.dart';
import '../services/cryptographer.dart';
import 'package:flutter/services.dart';

class EncryptionScreen extends StatefulWidget{
  @override
  State<EncryptionScreen> createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {
  TextEditingController _textToEncryptController = TextEditingController();
  TextEditingController _encryptionPasswordController = TextEditingController();
  TextEditingController _encryptedTextResult = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String copyConfirmation = "";

  @override
  Widget build(BuildContext context){
    
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
                        final result = Cryptographer.encrypt(_textToEncryptController.text, _encryptionPasswordController.text);
                        _encryptedTextResult.text = result.$2;
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async{
                      if(_encryptedTextResult.text.isNotEmpty){
                        await Clipboard.setData(ClipboardData(text: _encryptedTextResult.text));
                        setState(() {
                          copyConfirmation = "Copied (/•v•)/!";
                        });
                      }
                    },
                    child: Text("Copy"),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(100, 50),
                    ),
                    ),
                  Text(copyConfirmation),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}