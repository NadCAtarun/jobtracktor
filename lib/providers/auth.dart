import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth.dart';

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, models.User?>((ref) {
      return AuthStateNotifier(ref);
    });

class AuthStateNotifier extends StateNotifier<models.User?> {
  final Ref _ref;
  AuthService? _authService;

  AuthStateNotifier(this._ref) : super(null) {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    _authService = await _ref.watch(authServiceProvider.future);
    state = await _authService!.getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    if (_authService == null) return;
    await _authService!.loginWithEmail(email, password);
    state = await _authService!.getCurrentUser();
  }

  Future<void> register(String email, String password) async {
    if (_authService == null) return;
    await _authService!.registerWithEmail(email, password);
    state = await _authService!.getCurrentUser();
  }

  Future<void> logout() async {
    if (_authService == null) return;
    await _authService!.logout();
    state = null;
  }
}
