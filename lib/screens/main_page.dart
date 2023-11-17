import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripool_app/screens/auth/auth_page.dart';
import 'auth/login_page.dart';
import 'home_page.dart';

class MainPage extends StatelessWidget{
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            print(" I am in Home");
            return const HomePage();
          } else {
            print(" I am AuthPage");
            return const AuthPage();
          }
        },
      ),
    );
  }
}