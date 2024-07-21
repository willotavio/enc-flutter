import 'package:enc_flutter/services/user/user.dart';
import 'package:flutter/foundation.dart';

class SessionProvider extends ChangeNotifier {
  late User _user;

  User get user => _user;

  void setUser(User user) {
    this._user = user;
    notifyListeners();
  }
}