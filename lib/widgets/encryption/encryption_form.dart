import 'package:enc_flutter/widgets/encryption/encrypt_text_form.dart';
import 'package:enc_flutter/widgets/encryption/save_encryption_text_form.dart';
import 'package:flutter/material.dart';

class EncryptionForm extends StatefulWidget{
  @override
  State<EncryptionForm> createState() => _EncryptionFormState();
}

class _EncryptionFormState extends State<EncryptionForm> {
  TextEditingController _encryptedTextResult = TextEditingController();
  TextEditingController _encryptionMethod = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  EncryptTextForm(onSaveEncryptedText: (String encryptedText, String encryptionMethod) {
                    _encryptedTextResult.text = encryptedText;
                    _encryptionMethod.text = encryptionMethod;
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
                                child: SaveEncryptionTextForm(encryptedTextResult: _encryptedTextResult.text, encryptionMethod: _encryptionMethod.text,)
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