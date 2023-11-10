import 'package:flutter/material.dart';
import 'package:tripool_app/screens/bottom_bar_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tripool',
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.purple,
            // accentColor: Colors.amber,
            fontFamily: 'Raleway',
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.white,
            )),
        home: const BottomBarScreen(),
      );
  }
}


 