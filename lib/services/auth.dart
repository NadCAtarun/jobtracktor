import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AuthService {
  late final Account _account;
  static String? _projectId; // Cache project ID

  AuthService._internal(String projectId)
    : _account = Account(
        Client()
          ..setEndpoint('https://cloud.appwrite.io/v1')
          ..setProject(projectId)
          ..setSelfSigned(status: false),
      );

  static Future<AuthService> create() async {
    final projectId = await _fetchProjectId();
    return AuthService._internal(projectId);
  }

  static Future<String> _fetchProjectId() async {
    if (_projectId != null) return _projectId!;

    // Try to load .env from assets/.env (for local development)
    try {
      await dotenv.load(fileName: ".env");
      final localProjectId = dotenv.env['APPWRITE_PROJECT_ID'];
      if (localProjectId != null && localProjectId.isNotEmpty) {
        _projectId = localProjectId;
        return _projectId!;
      }
    } catch (e) {
      if (kDebugMode) {
        print(".env file not found or unreadable, falling back to /env.js");
      }
    }

    // If .env is missing, fetch from /env.js (for Netlify)
    try {
      final response = await http.get(Uri.parse('/env.js'));
      if (response.statusCode == 200) {
        final scriptContent = response.body;
        final match = RegExp(
          r'APPWRITE_PROJECT_ID:\s*"([^"]+)"',
        ).firstMatch(scriptContent);
        if (match != null) {
          _projectId = match.group(1);
          return _projectId!;
        }
      }
      throw Exception('Failed to load project ID from /env.js');
    } catch (e) {
      throw Exception('Error fetching project ID: ${e.toString()}');
    }
  }

  Future<models.Session?> getSession() async {
    try {
      return await _account.getSession(sessionId: 'current');
    } catch (e) {
      return null;
    }
  }

  Future<models.User?> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (e) {
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
    } catch (e) {
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

final authServiceProvider = FutureProvider<AuthService>((ref) async {
  return await AuthService.create();
});

final userProvider = FutureProvider<models.User?>((ref) async {
  final authService = await ref.watch(authServiceProvider.future);
  return authService.getCurrentUser();
});
