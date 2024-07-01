import 'dart:io';
import 'package:enc_flutter/services/encrypted_text/encrypted_text_service.dart';
import 'package:enc_flutter/services/permission_helper/permission_helper.dart';
import 'package:enc_flutter/services/xlsx_helper/xlsx_helper.dart';
import 'package:enc_flutter/widgets/encrypted_texts/encrypted_texts_list.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

class EncryptedTextsScreen extends StatefulWidget {

  @override
  State<EncryptedTextsScreen> createState() => _EncryptedTextsListState();

}

class _EncryptedTextsListState extends State<EncryptedTextsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            bool permissionGranted = await PermissionHelper.requestStoragePermission();
            if(permissionGranted) {
              Excel xlsx = XlsxHelper.getEncryptedTextsXLSX(await EncryptedTextService.getEncryptedTexts());
              String pathToSave = "storage/emulated/0/Download";
              var now = DateTime.now();
              File file = File("$pathToSave/encrypted-texts-${now.hour}${now.minute}${now.second}.xlsx");
              var saved = xlsx.save();
              if(saved != null) {
                file.writeAsBytes(saved);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("XLSX saved in downloads folder (/>v<)/!"),
                    duration: Duration(seconds: 1),
                    dismissDirection: DismissDirection.horizontal,
                    showCloseIcon: true,
                  ),
                );
              }
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Permission not granted"),
                  duration: Duration(seconds: 1),
                  dismissDirection: DismissDirection.horizontal,
                  showCloseIcon: true,
                ),
              );
            }
          },
          child: Text("Generate XLSX"),
        ),
        Expanded(child: EncryptedTextsList()),
      ],
    );
  }
}