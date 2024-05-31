import 'package:enc_flutter/services/encryptedTextService.dart';
import 'package:enc_flutter/widgets/decryption_form.dart';
import 'package:enc_flutter/widgets/delete_encryption_text.dart';
import 'package:flutter/material.dart';
import "package:flutter/services.dart";

class EncryptedTextsList extends StatefulWidget{
  @override
  State<EncryptedTextsList> createState() => _EncryptedTextsListState();
}

class _EncryptedTextsListState extends State<EncryptedTextsList>{
  @override
  Widget build(BuildContext context){
    return Center(
      child: FutureBuilder(
        future: EncryptedTextService.getEncryptedTexts(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasData && snapshot.data!.length == 0){
            return Center(
              child: Text("There's no encrypted text saved (л-ш-)л"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              height: 150,
                              child: Center(
                                child: DeleteEncryptedText(encryptedText: snapshot.data![0], onDeleteEncryptedText: () {
                                  setState(() {});
                                },),
                              ),
                            ), 
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.delete),
                  ),
                  title: TextButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: snapshot.data![index].encryptedText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Copied (/•v•)/!"),
                          duration: Duration(seconds: 1),
                          dismissDirection: DismissDirection.horizontal,
                          showCloseIcon: true,
                        ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: DecryptionForm(encryptedText: snapshot.data![index].encryptedText),
                          );
                        }
                      );
                    },
                    child: Text(snapshot.data![index].title, maxLines: 2),
                  ),
                );
            },
          );
        },
      ),
    );
  }
}