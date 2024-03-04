import 'package:enc_flutter/services/encryptedText.dart';
import 'package:enc_flutter/services/encryptedTextService.dart';
import 'package:uuid/uuid.dart';

import '../services/cryptographer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReencryptionScreen extends StatefulWidget{
  @override
  State<ReencryptionScreen> createState() => _ReencryptionScreenState();
}

class _ReencryptionScreenState extends State<ReencryptionScreen>{
  TextEditingController _textToReencryptController = TextEditingController();
  TextEditingController _reencryptionOldPasswordController = TextEditingController();
  TextEditingController _reencryptionNewPasswordController = TextEditingController();
  TextEditingController _reencryptionResult = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    String? _validateTextToReencrypt(String? value){
      if(value == null || value.isEmpty){
        return "Enter at least 1 character (/-ц-)/";
      }
      return null;
    }
    String? _validateRencryptionOldPassword(String? value){
      if(value == null || value.isEmpty){
        return "Provide the password (/-ц-)/";
      }
      else if(value.length < 12){
        return "The password must have at least 12 characters (/-ц-)/";
      }
      return null;
    }
    String? _validateReencryptionNewPassword(String? value){
      if(value == null || value.isEmpty){
        return "Provide the password (/-ц-)/";
      }
      else if(value.length < 12){
        return "The password must have at least 12 characters (/-ц-)/";
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
                        controller: _textToReencryptController,
                        validator: _validateTextToReencrypt,
                        decoration: InputDecoration(
                          labelText: "Enter a text to be reencrypted",
                        ),
                        maxLines: null,
                      ),
                    )
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _reencryptionOldPasswordController,
                    validator: _validateRencryptionOldPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter the old password",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _reencryptionNewPasswordController,
                    validator: _validateReencryptionNewPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter the new password",
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(120, 50),
                    ),
                    onPressed: () {
                      if(_formKey.currentState?.validate() ?? false){
                        final result = Cryptographer.reencrypt(_textToReencryptController.text.split(" | ")[0], _textToReencryptController.text.split(" | ")[1], _reencryptionOldPasswordController.text, _reencryptionNewPasswordController.text);
                        _reencryptionResult.text = result.$2;
                      }
                    },
                    child: Text("Reencrypt"),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: 100,
                      child: TextField(
                        controller: _reencryptionResult,
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
                          if(_reencryptionResult.text.isNotEmpty){
                            await Clipboard.setData(ClipboardData(text: _reencryptionResult.text));
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
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if(_reencryptionResult.text.isNotEmpty){
                            await EncryptedTextService.insertEncryptedText(EncryptedText(id: Uuid().v4(), encryptedText: _reencryptionResult.text));
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
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          _textToReencryptController.text = "";
                          _reencryptionOldPasswordController.text = "";
                          _reencryptionNewPasswordController.text = "";
                          _reencryptionResult.text = "";
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
      ),
    ); 
  }
}