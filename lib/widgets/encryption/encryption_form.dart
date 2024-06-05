import 'package:enc_flutter/widgets/encryption/encrypt_text_form.dart';
import 'package:enc_flutter/widgets/encryption/save_encryption_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EncryptionForm extends StatefulWidget{
  @override
  State<EncryptionForm> createState() => _EncryptionFormState();
}

class _EncryptionFormState extends State<EncryptionForm> {
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
                  EncryptTextForm(onSaveEncryptedText: (String text) {
                    _encryptedTextResult.text = text;
                  }),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if(_encryptedTextResult.text.isNotEmpty){
                        showDialog(
                          context: context, 
                          builder: (context) {
                            return Dialog(
                              child: Container(
                                height: 400,
                                child: SaveEncryptionTextForm(encryptedTextResult: _encryptedTextResult.text)
                              ),
                            );
                          }
                        );
                        setState(() {});
                      }
                    },
                    child: Text("Save"),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(100, 50),
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