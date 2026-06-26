import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<void> forgotPassword(String email);
  Future<void> logout();
  Future<UserModel?> getCachedUser();
}
