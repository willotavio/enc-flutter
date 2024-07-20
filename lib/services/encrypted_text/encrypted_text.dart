class EncryptedText{
  late String id;
  late String title;
  late String? description;
  late String encryptedText;
  late String encryptionMethod;

  EncryptedText({required String id, required String title, String? description, required String encryptedText, required String encryptionMethod}) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.encryptedText = encryptedText;
    this.encryptionMethod = encryptionMethod;
  }

  factory EncryptedText.fromMap(Map<String, dynamic> json) => EncryptedText(
    id: json["id"],
    title: json["title"],
    description: json["description"] != null ? json["description"] : null,
    encryptedText: json["encryptedText"],
    encryptionMethod: json["encryptionMethod"]
  );

  Map<String, dynamic> toMap(EncryptedText encryptedText){
    return {
      "id": encryptedText.id,
      "title": encryptedText.title,
      "description": encryptedText.description,
      "encryptedText": encryptedText.encryptedText,
      "encryptionMethod": encryptedText.encryptionMethod
    };
  }

  String toString(){
    return "ID: $id\n"
            "Title: $title\n"
            "Description: $description\n"
            "Encrypted Text: $encryptedText\n"
            "Encryption Method: $encryptionMethod";
  }
}