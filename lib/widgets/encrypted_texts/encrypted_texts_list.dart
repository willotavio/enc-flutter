import 'package:enc_flutter/services/encrypted_text/encrypted_text_service.dart';
import 'package:enc_flutter/widgets/decryption/decryption_form.dart';
import 'package:enc_flutter/widgets/encrypted_texts/delete_encryption_text.dart';
import 'package:enc_flutter/widgets/encrypted_texts/edit_encrypted_text.dart';
import 'package:enc_flutter/widgets/reencryption/reencrypt_text_form.dart';
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
              return ExpansionTile(
                leading: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Container(
                            height: 600,
                            child: DecryptionForm(encryptedText: snapshot.data![index].encryptedText)
                          ),
                        );
                      }
                    );
                  },
                  icon: Icon(Icons.lock_open),
                ),
                title: Text("${snapshot.data![index].title}"),
                children: [
                  Column(
                    children: [
                      Text(snapshot.data![index].description ?? ""),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
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
                            icon: Icon(Icons.copy),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return Dialog(
                                    child: Padding(
                                      padding: const EdgeInsets.all(40.0),
                                      child: ReencryptTextForm(textToReencrypt: snapshot.data![index].encryptedText, onReencryptText: (bool status, String text) async {
                                        if(status) {
                                          var result = await EncryptedTextService.updateEncryptedText(snapshot.data![index].id, null, null, text);
                                          if(result) {
                                            setState(() {
                                              Navigator.of(context).pop();
                                            }); 
                                          };
                                        }
                                      },),
                                    ),
                                  );
                                }
                              );
                            }, 
                            icon: Icon(Icons.autorenew),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return Dialog(
                                    child: Padding(
                                      padding: const EdgeInsets.all(40.0),
                                      child: Container(
                                        height: 500,
                                        child: Center(
                                          child: EditEncryptedText(encryptedText: snapshot.data![index], onUpdateEncryptedText: () {
                                            setState(() {});
                                          }),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Container(
                                      height: 400,
                                      child: Center(
                                        child: DeleteEncryptedText(encryptedText: snapshot.data![index], onDeleteEncryptedText: () {
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
                        ],
                      ),
                    ],
                  ),
                ]
              );
            },
          );
        },
      ),
    );
  }
}