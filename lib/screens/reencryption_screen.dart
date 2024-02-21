import 'package:enc_flutter/services/cryptographer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReencryptionScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    TextEditingController _textToReencryptController = TextEditingController();
    TextEditingController _reencryptionOldPasswordController = TextEditingController();
    TextEditingController _reencryptionNewPasswordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    TextEditingController _reencryptionResult = TextEditingController();

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
                        final result = Cryptographer.reencrypt(_textToReencryptController.text, _reencryptionOldPasswordController.text, _reencryptionNewPasswordController.text);
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
                  ElevatedButton(
                    onPressed: () async{
                      await Clipboard.setData(ClipboardData(text: _reencryptionResult.text));
                    },
                    child: Text("Copy"),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(100, 50),
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