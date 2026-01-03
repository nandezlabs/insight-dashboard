import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insight_core/insight_core.dart';

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Auth State Provider
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState()) {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _authRepository.restoreSession();
      state = AuthState(user: user, isLoading: false);
    } catch (e) {
      print('Error restoring session: $e');
      state = const AuthState(isLoading: false);
    }
  }

  Future<bool> login(String storeCode, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print('Attempting login with storeCode: $storeCode');
      final authToken = await _authRepository.login(storeCode, password);
      print('Login successful, user: ${authToken.user.username}');
      state = AuthState(user: authToken.user, isLoading: false);
      return true;
    } on ApiException catch (e) {
      print('Login failed - ApiException: ${e.message}');
      state = AuthState(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      print('Login failed - Unexpected error: $e');
      state = AuthState(isLoading: false, error: 'An unexpected error occurred: $e');
      return false;
    }
  }

  Future<bool> createAccount(String storeCode, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authToken = await _authRepository.createAccount(storeCode, password);
      state = AuthState(user: authToken.user, isLoading: false);
      return true;
    } on ApiException catch (e) {
      state = AuthState(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = AuthState(isLoading: false, error: 'An unexpected error occurred');
      return false;
    }
  }

  Future<bool> signup(String email, String password, String fullName) async {
    // Deprecated: Use createAccount instead
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.createAccount(email, password);
      // After account creation, automatically log in
      return await login(email, password);
    } on ApiException catch (e) {
      state = AuthState(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = AuthState(isLoading: false, error: 'An unexpected error occurred');
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
