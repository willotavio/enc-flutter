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
  @override
  Widget build(BuildContext) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Are you sure you want to delete this encrypted text?"),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
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
          },
          child: Text("Delete"),
          style: ElevatedButton.styleFrom(
            fixedSize: Size(100, 50),
          ),
        ),
      ],
    );
  }
}