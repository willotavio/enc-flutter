import 'package:enc_flutter/services/encryptedTextRepository.dart';
import 'package:enc_flutter/services/encryptedTextService.dart';
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
        future: EncryptedTextRepository.getEncryptedTexts(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
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
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Are you sure you want to delete this encrypted text?"),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await EncryptedTextService.deleteEncryptedText(snapshot.data![index].id);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Deleted!"),
                                          ),
                                        );
                                        setState(() {});
                                      },
                                      child: Text("Delete"),
                                    ),
                                  ],
                                )
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
                          content: Text("Copied!"),
                        ),
                      );
                    },
                    child: Text(snapshot.data![index].encryptedText)
                  ),
                );
            },
          );
        },
      ),
    );
  }
}