import 'package:enc_flutter/services/cryptographer.dart';
import 'package:enc_flutter/services/encryptedText.dart';
import 'package:enc_flutter/services/encryptedTextService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class EncryptionForm extends StatefulWidget{
  @override
  State<EncryptionForm> createState() => _EncryptionFormState();
}

class _EncryptionFormState extends State<EncryptionForm> {
  TextEditingController _textToEncryptController = TextEditingController();
  TextEditingController _encryptionPasswordController = TextEditingController();
  TextEditingController _encryptedTextResult = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
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

    return Center(
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
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      ElevatedButton(
                        onPressed: () async{
                          if(_encryptedTextResult.text.isNotEmpty){
                            await Clipboard.setData(ClipboardData(text: _encryptedTextResult.text));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Copied (/•v•)/!"),
                                duration: Duration(seconds: 1),
                                dismissDirection: DismissDirection.horizontal,
                                showCloseIcon: true,
                              ),
                            );
                          }
                        },
                        child: Text("Copy"),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(100, 50),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if(_encryptedTextResult.text.isNotEmpty){
                            await EncryptedTextService.insertEncryptedText(EncryptedText(id: Uuid().v4(), encryptedText: _encryptedTextResult.text));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Saved (/•v-)/"),
                                duration: Duration(seconds: 1),
                                dismissDirection: DismissDirection.horizontal,
                                showCloseIcon: true,
                              ),
                            );
                            setState(() {});
                          }
                        },
                        child: Text("Save"),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(100, 50),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _textToEncryptController.text = "";
                          _encryptionPasswordController.text = "";
                          _encryptedTextResult.text = "";
                        },
                        child: Text("Clear"),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(100, 50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}