import "package:flutter/material.dart";
import 'package:tripool_app/screens/auth/login_page.dart';
import 'package:tripool_app/screens/auth/register_page.dart';

class AuthPage extends StatefulWidget {
  final bool showLoginPageInitially;
  const AuthPage({Key? key, this.showLoginPageInitially = true}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with RouteAware {
  // initially shows the logiin page
  late bool showLoginPage;

  @override
  void initState() {
    super.initState();
    showLoginPage = widget.showLoginPageInitially;
  }

  void toggleScreens(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(showRegisterPage: toggleScreens);
    }else{
      return RegisterPage(showLoginPage: toggleScreens);
    }
  }
}
