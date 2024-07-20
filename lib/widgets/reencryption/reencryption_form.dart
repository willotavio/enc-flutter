import 'package:enc_flutter/widgets/encryption/save_encryption_text_form.dart';
import 'package:enc_flutter/widgets/reencryption/reencrypt_text_form.dart';
import 'package:flutter/material.dart';

class ReencryptionForm extends StatefulWidget {
  @override
  State<ReencryptionForm> createState() => _ReencryptionFormState();
}

class _ReencryptionFormState extends State<ReencryptionForm> {
  bool _reencryptionStatus = false;
  late String _reencryptionResult;
  late String _newEncryptionMethod;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ReencryptTextForm(onReencryptText: (bool status, String text, String newEncryptionMethod) {
                  setState(() {
                    _reencryptionStatus = status;
                    if(status) {
                      _reencryptionResult = text;
                      _newEncryptionMethod = newEncryptionMethod;
                    }
                  });
                }),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () async {
                    if(_reencryptionStatus && _reencryptionResult.isNotEmpty){
                      showDialog(
                        context: context, 
                        builder: (context) {
                          return Dialog(
                            child: Container(
                              height: 400,
                              child: Center(
                                child: SaveEncryptionTextForm(encryptedTextResult: _reencryptionResult, encryptionMethod: _newEncryptionMethod),
                              ),
                            )
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