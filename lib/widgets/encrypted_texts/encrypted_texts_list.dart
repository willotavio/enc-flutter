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

class _EncryptedTextsListState extends State<EncryptedTextsList> {
  @override
  Widget build(BuildContext context) {
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
                            child: DecryptionForm(encryptedText: snapshot.data![index].encryptedText, encryptionMethod: snapshot.data![index].encryptionMethod)
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
                      Text("${snapshot.data![index].description ?? "No description"} - ${snapshot.data![index].encryptionMethod}"),
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
                                    child: Container(
                                      height: 600,
                                      child: ReencryptTextForm(textToReencrypt: snapshot.data![index].encryptedText, currentEncryptionMethod: snapshot.data![index].encryptionMethod, onReencryptText: (bool status, String reencryptionResult, String newEncryptionMethod) async {
                                        if(status) {
                                          var result = await EncryptedTextService.updateEncryptedText(snapshot.data![index].id, null, null, reencryptionResult, newEncryptionMethod);
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
                                  return ScaffoldMessenger(
                                    child: Builder(builder: (context) {
                                      return Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () => Navigator.of(context).pop(),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: AlertDialog(
                                              content: GestureDetector(
                                                child: Container(
                                                  height: 600,
                                                  child: Center(
                                                    child: EditEncryptedText(encryptedText: snapshot.data![index], onUpdateEncryptedText: () {
                                                      setState(() {});
                                                    }),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      );
                                    }),
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
                                  return ScaffoldMessenger(
                                    child: Builder(builder: (context) {
                                      return Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () => Navigator.of(context).pop(),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: AlertDialog(
                                              content: Container(
                                                height: 400,
                                                child: Center(
                                                  child: DeleteEncryptedText(encryptedText: snapshot.data![index], onDeleteEncryptedText: () {
                                                    setState(() {});
                                                  },),
                                                ),
                                              ), 
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
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