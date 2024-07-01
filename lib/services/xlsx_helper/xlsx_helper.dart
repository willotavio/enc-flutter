import 'package:enc_flutter/services/encrypted_text/encrypted_text.dart';
import 'package:excel/excel.dart';

class XlsxHelper {

  static Excel getEncryptedTextsXLSX(List<EncryptedText> encryptedTextsList) {
    Excel xlsx = Excel.createExcel();
    xlsx.rename("Sheet1", "Encrypted Texts");
    var encryptedTextsSheet = xlsx["Encrypted Texts"];
    var rows = [
      TextCellValue("ID"),
      TextCellValue("Title"),
      TextCellValue("Encrypted Text"),
      TextCellValue("Description")
    ];
    encryptedTextsSheet.appendRow(rows);
    
    for(var encryptedText in encryptedTextsList) {
      encryptedTextsSheet.appendRow(
        [
          TextCellValue(encryptedText.id),
          TextCellValue(encryptedText.title),
          TextCellValue(encryptedText.description ?? "No description"),
          TextCellValue(encryptedText.encryptedText),
        ],
      );
    }

    return xlsx;
  }

}