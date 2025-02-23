import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth.dart';

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, models.User?>((ref) {
      return AuthStateNotifier(ref.watch(authServiceProvider));
    });

class AuthStateNotifier extends StateNotifier<models.User?> {
  final AuthService _authService;

  AuthStateNotifier(this._authService) : super(null) {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    state = await _authService.getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    await _authService.loginWithEmail(email, password);
    state = await _authService.getCurrentUser();
  }

  Future<void> register(String email, String password) async {
    await _authService.registerWithEmail(email, password);
    state = await _authService.getCurrentUser();
  }

  Future<void> logout() async {
    await _authService.logout();
    state = null;
  }
}
