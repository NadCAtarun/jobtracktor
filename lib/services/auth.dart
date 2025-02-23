import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  static const String projectId = "67b70a0100373a0c8421";

  final Account _account;

  AuthService()
    : _account = Account(
        Client()
          ..setEndpoint('https://cloud.appwrite.io/v1')
          ..setProject(projectId)
          ..setSelfSigned(status: false),
      );

  Future<models.Session?> getSession() async {
    try {
      return await _account.getSession(sessionId: 'current');
    } catch (_) {
      return null;
    }
  }

  Future<models.User?> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (_) {
      return null;
    }
  }

  Future<void> registerWithEmail(String email, String password) async {
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception("Sign-up failed: ${e.toString()}");
    }
  }

  Future<models.Session?> loginWithEmail(String email, String password) async {
    try {
      return await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSessions();
    } catch (e) {
      rethrow;
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final userProvider = FutureProvider<models.User?>((ref) async {
  return ref.watch(authServiceProvider).getCurrentUser();
});
