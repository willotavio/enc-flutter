import 'package:enc_flutter/services/user/user.dart';
import 'package:enc_flutter/services/user/user_repository.dart';

class UserService {

  static Future<List<User>> getUsers() async {
    return await UserRepository.getUsers();
  }

}