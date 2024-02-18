import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Import Firebase Auth


import 'features/user_login_registration/presentation/screens/home_screen.dart';
import 'features/user_login_registration/presentation/screens/login_screen.dart';
import 'features/user_login_registration/presentation/screens/signup_screen.dart';
import 'features/user_login_registration/presentation/screens/splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: " ",
        appId: " ",
        messagingSenderId: " ",
        projectId: " ",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => const SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child: LoginPage(),
        ),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}