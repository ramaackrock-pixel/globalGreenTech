import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

// Authentication State
class AuthState {
  final bool isLoading;
  final UserModel? user;
  final String? errorMessage;
  final bool isResetLinkSent;
  final bool isCheckingCache;

  AuthState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.isResetLinkSent = false,
    this.isCheckingCache = true,
  });

  AuthState copyWith({
    bool? isLoading,
    UserModel? user,
    String? errorMessage,
    bool? isResetLinkSent,
    bool? isCheckingCache,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage, // Allows setting to null implicitly
      isResetLinkSent: isResetLinkSent ?? this.isResetLinkSent,
      isCheckingCache: isCheckingCache ?? this.isCheckingCache,
    );
  }
}

// Global Providers
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in the ProviderScope');
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthRepositoryImpl(dioClient, prefs);
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(AuthState()) {
    checkCachedUser();
  }

  // Check if there is an active session cached
  Future<void> checkCachedUser() async {
    state = state.copyWith(isCheckingCache: true);
    try {
      final user = await _repository.getCachedUser();
      state = state.copyWith(user: user, isCheckingCache: false);
    } catch (_) {
      state = state.copyWith(isCheckingCache: false);
    }
  }

  // Login handler
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.login(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  // Reset password handler
  Future<void> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isResetLinkSent: false);
    try {
      await _repository.forgotPassword(email);
      state = state.copyWith(isLoading: false, isResetLinkSent: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  // Logout handler
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _repository.logout();
    state = AuthState(isCheckingCache: false);
  }

  // Clear errors manually
  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }
}

// Controller Provider
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(repository);
});
