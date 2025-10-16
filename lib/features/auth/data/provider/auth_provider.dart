import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository()); // creates a Provider in Riverpod.

class AuthNotifier extends Notifier<AuthState> { // changes or updates that status
  late final AuthRepository _authRepository;

  @override
  AuthState build() { // Called when AuthNotifier starts
    _authRepository = ref.read(authRepositoryProvider); // Gets the repository from Riverpod
    _checkAuth(); // check if user is already logged in when the app starts
    return AuthState(); // empty initial state (not logged in yet). [ user: null, isLoading: false, error: null ]
  }

  Future<void> _checkAuth() async {
    state = state.setLoading(true);
    try {
      final user = await _authRepository.getCurrentUser();
      state = AuthState(user: user, isLoading: false);
    } catch (e) {
      state = AuthState(isLoading: false);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.setLoading(true).clearError();
    try {
      final user = await _authRepository.login(email, password);
      state = AuthState(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = AuthState(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    state = state.setLoading(true).clearError();
    try {
      final user = await _authRepository.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      state = AuthState(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = AuthState(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.setLoading(true);
    try {
      await _authRepository.logout();
      state = AuthState(isLoading: false);
    } catch (e) {
      state = AuthState(isLoading: false);
    }
  }

  void clearError() {
    state = state.clearError();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});