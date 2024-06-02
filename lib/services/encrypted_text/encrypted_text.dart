class EncryptedText{
  late String id;
  late String title;
  late String? description;
  late String encryptedText;

  EncryptedText({required String id, required String title, String? description, required String encryptedText}) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.encryptedText = encryptedText;
  }

  factory EncryptedText.fromMap(Map<String, dynamic> json) => EncryptedText(
    id: json["id"],
    title: json["title"],
    description: json["description"] != null ? json["description"] : null,
    encryptedText: json["encryptedText"],
  );

  Map<String, dynamic> toMap(EncryptedText encryptedText){
    return {
      "id": encryptedText.id,
      "title": encryptedText.title,
      "description": encryptedText.description,
      "encryptedText": encryptedText.encryptedText
    };
  }

  String toString(){
    return "ID: $id\n"
            "Title: $title\n"
            "Description: $description\n"
            "Encrypted Text: $encryptedText";
  }
}