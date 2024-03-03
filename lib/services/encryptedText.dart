class EncryptedText{
  final String id;
  final String encryptedText;
  EncryptedText({required this.id, required this.encryptedText});

  factory EncryptedText.fromMap(Map<String, dynamic> json) => EncryptedText(
    id: json["id"],
    encryptedText: json["encryptedText"],
  );

  Map<String, dynamic> toMap(EncryptedText encryptedText){
    return {
      "id": encryptedText.id,
      "encryptedText": encryptedText.encryptedText
    };
  }

  String toString(){
    return "$id - $encryptedText";
  }
}