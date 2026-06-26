import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;
  final SharedPreferences _prefs;
  static const String _cachedUserKey = 'cached_user';

  AuthRepositoryImpl(this._dioClient, this._prefs);

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _dioClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    final user = UserModel.fromJson(response.data);
    
    // Save to SharedPreferences
    await _prefs.setString(_cachedUserKey, jsonEncode(user.toJson()));
    
    // Set token in HTTP headers
    _dioClient.setAuthToken(user.token);

    return user;
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _dioClient.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(_cachedUserKey);
    _dioClient.clearAuthToken();
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final cachedString = _prefs.getString(_cachedUserKey);
    if (cachedString != null) {
      try {
        final parsedJson = jsonDecode(cachedString) as Map<String, dynamic>;
        final user = UserModel.fromJson(parsedJson);
        
        // Restore authorization header
        _dioClient.setAuthToken(user.token);
        return user;
      } catch (_) {
        // Corrupted cache, clear it
        await _prefs.remove(_cachedUserKey);
      }
    }
    return null;
  }
}
