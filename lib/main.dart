import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import './providers/auth.dart';
import './screens/home.dart';
import './screens/login.dart';
import './theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp.router(
      theme: baseTheme,
      routerConfig: GoRouter(
        initialLocation: '/',
        redirect: (context, state) => authState == null ? '/login' : '/home',
        routes: [
          GoRoute(
            path: '/',
            builder:
                (context, state) =>
                    authState == null ? LoginScreen() : HomeScreen(),
          ),
          GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
          GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
        ],
      ),
    );
  }
}
