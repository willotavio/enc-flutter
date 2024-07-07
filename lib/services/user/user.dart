class User {

  late String _id;
  late String _username;
  late String _email;
  late String _password;

  User({required String id, required String username, required String email, required String password}) {
    this._id = id;
    this._username = username;
    this._email = email;
    this._password = password;
  }

  String get id => this._id;
  String get username => this._username;
  String get email => this._email;
  String get password => this._password;

  set id(String id) {
    this._id = id;
  }

  set username(String username) {
    this._username = username;
  }

  set email(String email) {
    this._email = email;
  }

  set password(String password) {
    this._password = password;
  }

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    password: json["password"]
  );

  Map<String, dynamic> toMap() => {
    "id": this._id,
    "username": this._username,
    "email": this._email,
    "password": this._password
  };

  String toString() {
    return "ID: $_id\n" +
            "Name: $_username\n" +
            "Email: $_email";
  }

}