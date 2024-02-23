import 'package:flutter/material.dart';
import '../services/cryptographer.dart';
import 'package:flutter/services.dart';

class DecryptionScreen extends StatefulWidget{
  @override
  State<DecryptionScreen> createState() => _DecryptionScreenState();
}

class _DecryptionScreenState extends State<DecryptionScreen> {
  TextEditingController _textToDecryptController = TextEditingController();
  TextEditingController _decryptionPasswordController = TextEditingController();
  TextEditingController _decryptedTextResult = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String copyConfirmation = "";

  @override
  Widget build(BuildContext context){

    String? _validateTextToDecrypt(String? value){
      if(value == null || value.isEmpty){
        return "Enter something to be encrypted (*/•_•)/";
      }
      return null;
    }
    String? _validateDecryptionPassword(String? value){
      if(value == null || value.isEmpty){
        return "Enter the decryption password (*/•_•)/";
      }
      else if(value.length < 12){
        return "Decryption password must have at least 12 characters (*/•_•)/";
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
                    controller: _decryptionPasswordController,
                    validator: _validateDecryptionPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter the decryption password",
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState?.validate() ?? false){
                        final result = Cryptographer.decrypt(_textToDecryptController.text.split(" | ")[0], _textToDecryptController.text.split(" | ")[1], _decryptionPasswordController.text);
                        _decryptedTextResult.text = result.$2;
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async{
                          if(_decryptedTextResult.text.isNotEmpty){
                            await Clipboard.setData(ClipboardData(text: _decryptedTextResult.text));
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
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          _textToDecryptController.text = "";
                          _decryptionPasswordController.text = "";
                          _decryptedTextResult.text = "";
                          setState(() {
                            copyConfirmation = "";
                          });
                        },
                        child: Text("Clear"),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(100, 50)
                        ),
                      )
                    ],
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