import 'package:flutter/material.dart';

class SignUpSuccessPage extends StatelessWidget {
  final VoidCallback goToLoginPage;

  const SignUpSuccessPage({Key? key, required this.goToLoginPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Successfully Signed Up!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: goToLoginPage,
              child: Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
