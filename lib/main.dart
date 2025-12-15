import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'repositories/auth_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'providers/notes_provider.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'providers/user_provider.dart';
import 'screens/settings_screen.dart';
import 'repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'repositories/mood_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Hive.initFlutter();
  //Hive.registerAdapter(NoteAdapter());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(UserRepository())),
          ChangeNotifierProvider(create: (_) => MoodProvider(MoodRepository()),)
        ],
      child: const MoodTrackerApp(),
    ),
  );
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
      routes: {
        '/login': (context) => LoginScreen(authRepository: authRepository),
        '/register': (context) => RegisterScreen(authRepository: authRepository),
        '/home': (context) => const HomeScreen(),
        '/settings': (_) => SettingsScreen(),
      },
    );
  }
}
