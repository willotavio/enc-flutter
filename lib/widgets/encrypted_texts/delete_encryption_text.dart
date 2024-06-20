import 'package:enc_flutter/services/cryptographer/cryptographer.dart';
import 'package:enc_flutter/services/encrypted_text/encrypted_text.dart';
import 'package:enc_flutter/services/encrypted_text/encrypted_text_service.dart';
import 'package:flutter/material.dart';

class DeleteEncryptedText extends StatefulWidget {
  final EncryptedText encryptedText;
  final VoidCallback ? onDeleteEncryptedText;
  DeleteEncryptedText({required this.encryptedText, this.onDeleteEncryptedText, Key? key}) : super(key : key);
  @override
  State<DeleteEncryptedText> createState() => _DeleteEncrypteTextState();
}

class _DeleteEncrypteTextState extends State<DeleteEncryptedText> {
  TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Are you sure you want to delete this encrypted text?"),
            SizedBox(height: 20),
            TextFormField(
              validator: (String? value) {
                if(value != null && value.isEmpty) {
                  return "Enter the password from before the changes";
                }
                return null;
              },
              controller: _password,
              decoration: InputDecoration(
                labelText: "Password"
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if(_formKey.currentState!.validate()) {
                  final decryptionResult = Cryptographer.decrypt(widget.encryptedText.encryptedText.split(" | ")[0], widget.encryptedText.encryptedText.split(" | ")[1], _password.text);
                  if(decryptionResult.$1) {
                    await EncryptedTextService.deleteEncryptedText(widget.encryptedText.id);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Deleted \\(-v-\\)!"),
                        duration: Duration(seconds: 1),
                        dismissDirection: DismissDirection.horizontal,
                        showCloseIcon: true,
                      ),
                    );
                    if(widget.onDeleteEncryptedText != null) {
                      widget.onDeleteEncryptedText!();
                    }
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Password is incorrect (|-v-)/"),
                        duration: Duration(seconds: 1),
                        dismissDirection: DismissDirection.horizontal,
                        showCloseIcon: true,
                      ),
                    );
                  }
                }
              },
              child: Text("Delete"),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(100, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}