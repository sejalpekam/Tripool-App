import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'members_page.dart';

class MainPage extends StatelessWidget{
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return const MembersPage(isCreator: true, activityId:"i1eqO0vSQ8iWHC7Z73Vj",);
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}