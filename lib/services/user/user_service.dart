import 'package:enc_flutter/services/user/user.dart';
import 'package:enc_flutter/services/user/user_repository.dart';

class UserService {

  static Future<List<User>> getUsers() async {
    return await UserRepository.getUsers();
  }

  static Future<User?> getUserById(String id) async {
    return await UserRepository.getUserById(id);
  }

  static Future<bool> addUser(User newUser) async {
    return await UserRepository.addUser(newUser.toMap());
  }

}