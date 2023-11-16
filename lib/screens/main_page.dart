import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripool_app/screens/auth/auth_page.dart';
import 'package:tripool_app/screens/bottom_bar_screen.dart';
import 'auth/login_page.dart';
import 'home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          print('AUTH SNAP: $snapshot');
          if (snapshot.hasData) {
            return const BottomBarScreen();
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}
