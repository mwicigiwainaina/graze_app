import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/global/common/toast.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("HomePage"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
                       children: [
              const Text(
                "Welcome to the Home Page!",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Sign out the user using Firebase Authentication
                  try {
                    await FirebaseAuth.instance.signOut();
                    showToast(message: "Logged out successfully");
                  } catch (e) {
                    showToast(message: "Error signing out");
                    print(e);
                  }
                },
                child: const Text("Sign Out"),
              ),
            ],
          ),
        ),
    );
  }
}
