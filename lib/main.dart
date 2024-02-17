import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCLEpzXxrA4THXlI5C8kGWzFePPalG-7Mg",
      authDomain: "graze-the-app.firebaseapp.com",
      projectId: "graze-the-app",
      storageBucket: "graze-the-app.appspot.com",
      messagingSenderId: "731884690951",
      appId: "1:731884690951:web:372d48867ebd6cdbdf14a2",
      measurementId: "G-GHBXB4CBPD" 
    ),
  );

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}